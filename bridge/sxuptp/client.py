"""
SXUPTP probe client.

Implements the reverse-engineered SXUPTP handshake and data channel: discovery,
device list, attach (two-step CONNECT + OPEN_WAIT match), control and bulk/
interrupt transfers, and clean slot release (RST close). Confirmed live against a
Belkin F5L009 hub (see ../SXUPTP_PROTOCOL.md).
"""
from __future__ import annotations

import collections
import os
import queue
import select
import socket
import struct
import sys
import threading
import time

from . import protocol as p


class KeepaliveResponder:
    """Answers the hub's SXUP_ALC keepalive. The hub runs a dedicated task (fn
    @0x308464) bound to UDP 0xC15D and pings every client at client_ip:0xC15D with
    "\\x00\\x04BS" ({len=4}{"BS"}) ~every 10s; the client must echo it, or the
    Salc age reaches ~5999 ticks (~69s) and the hub RSTs the data channel
    ('SXUP_ALC: Send RST!'). We echo each ping back to its source.

    0xC15D is a FIXED firmware constant (the salc [+8] signature / keepalive port),
    NOT negotiated or per-device: the hub runs ONE keepalive stream for the whole
    host regardless of how many devices are attached. So a single responder per
    client_ip suffices (this is why the Hub owns one, not each SxuptpClient). The
    bind must use this exact port to receive the ping. SO_REUSEPORT lets a stray
    per-client responder coexist harmlessly. Disable via SXUPTP_NO_KEEPALIVE.
    """
    PORT = 0xC15D          # 49501
    PING = b"\x00\x04BS"

    def __init__(self, host: str, client_ip: str):
        self.host = host
        self.client_ip = client_ip
        self.echoed = 0
        self.error: str | None = None     # why the responder is not running, if so
        self._sock: socket.socket | None = None
        self._thread = None
        self._stop = threading.Event()

    def start(self) -> bool:
        if self._sock is not None:
            return True
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        try:
            s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)
        except (AttributeError, OSError):
            pass
        try:
            s.bind((self.client_ip, self.PORT))
        except OSError as e:
            s.close()
            self._fail(f"cannot bind {self.client_ip}:{self.PORT}: {e}")
            return False
        self.error = None
        s.settimeout(0.5)
        self._sock = s
        self._stop.clear()
        self._thread = threading.Thread(target=self._loop, name="sxuptp-keepalive",
                                        daemon=True)
        self._thread.start()
        return True

    def _fail(self, msg: str) -> None:
        # Without the echo the hub RSTs every data channel after ~69s, so a dead
        # responder must never be silent.
        self.error = msg
        print(f"[sxuptp] KEEPALIVE FAILED: {msg} -- the hub will reset data "
              f"channels after ~69s", file=sys.stderr, flush=True)

    @property
    def running(self) -> bool:
        return (self._sock is not None and self._thread is not None
                and self._thread.is_alive())

    def _loop(self) -> None:
        s = self._sock
        send_failing = False
        while s is not None and not self._stop.is_set():
            try:
                d, a = s.recvfrom(256)
            except socket.timeout:
                continue
            except OSError as e:
                if not self._stop.is_set():
                    self._fail(f"receive loop died: {e}")
                break
            if a[0] == self.host and d[:4] == self.PING:
                try:
                    s.sendto(d, a)      # echo verbatim back to the ping's source
                    self.echoed += 1
                    send_failing = False
                except OSError as e:
                    if not send_failing:    # report once per failure streak
                        self._fail(f"echo to {a[0]}:{a[1]} failed: {e}")
                        send_failing = True

    def stop(self) -> None:
        self._stop.set()
        if self._sock is not None:
            try:
                self._sock.close()
            except OSError:
                pass
            self._sock = None


class SxuptpClient:
    def __init__(self, host: str, port: int = p.PORT, timeout: float = 3.0):
        self.host = host
        self.port = port
        self.timeout = timeout
        self.tcp: socket.socket | None = None
        # endpoint addr -> wMaxPacketSize, populated by the backend after
        # enumeration so bulk headers carry the real MPS (0x8000|mps). Falls back
        # to 512 (correct high-speed bulk) for any endpoint not listed.
        self.ep_mps: dict[int, int] = {}
        # SXUP_ALC keepalive responder (see KeepaliveResponder). Standalone
        # SxuptpClient users get their own; under a Hub it is disabled
        # (self._ka_enabled=False) because the Hub owns one host-level responder.
        self._ka: KeepaliveResponder | None = None
        self._ka_enabled = os.environ.get("SXUPTP_NO_KEEPALIVE") is None

    # --- discovery (UDP 19540) ------------------------------------------
    @staticmethod
    def discover(target: str = "255.255.255.255", port: int = p.PORT,
                 timeout: float = 2.0, src: str = "") -> list[dict]:
        """Discover devices via the JCP identity query (cmd4/0x9506).

        CONFIRMED against hardware: returns parsed device info dicts (model, mac,
        ip, proto_version, usb_device, hostname, firmware). Send to a broadcast
        or a unicast IP.
        """
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        if src:
            s.bind((src, port))
        s.settimeout(timeout)
        try:
            s.sendto(p.pack_identify(), (target, port))
            found: list[dict] = []
            t0 = time.time()
            while time.time() - t0 < timeout:
                try:
                    data, addr = s.recvfrom(2048)
                except socket.timeout:
                    break
                try:
                    info = p.parse_identity(data)
                    info["from"] = addr[0]
                    found.append(info)
                except ValueError:
                    pass
            return found
        finally:
            s.close()

    @staticmethod
    def list_devices(host: str, port: int = p.PORT, timeout: float = 2.0,
                     src: str = "", retries: int = 2) -> list:
        """GET USB_DEVICE_LIST (cmd=1) -> [{port, device}]. CONFIRMED live.

        `src` binds the source IP (use a non-gateway alias for consistency with
        attach). Retries because the delta protocol can return an empty "no
        change" reply before the full dump settles.

        Uses pack_device_list_query() — the vendor-exact request with the
        `[generation 0][flag 0x0200]` full-dump selector. A bare request without
        that selector only returns the full list while the hub's list generation
        is 0 (right after a reboot); once it advances you get an empty 8-byte
        reply or an unparseable 3072-byte alternate dump. That omission — not any
        hub fault — is what made the list look empty/"corrupted" after device
        churn.

        IMPORTANT: bind an EPHEMERAL source port (src, 0), like the vendor driver
        / pybelkusb. Binding the well-known port 19540 here poisons a subsequent
        CONNECT in the same process (the attach then never matches OPEN_WAIT).
        """
        for _ in range(max(1, retries)):
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            try:
                s.bind((src, 0))      # ephemeral; the reply returns to this port
            except OSError:
                pass
            s.settimeout(timeout)
            try:
                s.sendto(p.pack_device_list_query(), (host, port))
                try:
                    data, _ = s.recvfrom(8192)
                    devs = p.parse_device_list(data)
                    if devs:
                        return devs
                except socket.timeout:
                    pass
            finally:
                s.close()
        return []

    @staticmethod
    def scanner_status(host: str, device_mac: bytes, port_name: str,
                       port: int = p.PORT, timeout: float = 2.0) -> bytes:
        """GET SCANNER_STATUS -> raw reply containing the device's USB
        descriptors (read-only; no attach). Multi-byte descriptor fields are
        big-endian in the reply. CONFIRMED live."""
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        try:
            s.bind(("", port))
        except OSError:
            pass
        s.settimeout(timeout)
        body = bytes([1, len(device_mac)]) + device_mac + port_name.encode() + b"\x00"
        try:
            s.sendto(p.pack_jcp(p.JCP_SCANNER_STATUS, body, command=1), (host, port))
            try:
                data, _ = s.recvfrom(4096)
            except socket.timeout:
                return b""
            return data
        finally:
            s.close()

    # --- session (TCP 19540) --------------------------------------------
    def attach(self, port_name: str, device_mac: bytes, client_ip: str,
               window: float = 5.0, udp: socket.socket | None = None,
               bc: socket.socket | None = None) -> int | None:
        """
        Claim a device and open the TCP data channel. CONFIRMED live (first real
        USB transfer obtained 2026-10-10).

        Sequence (byte-identical to the official driver / pybelkusb):
          1. UDP `EXEC SCANNER CONNECT` cmd 0x0001 -> creates the job ("OK").
          2. UDP `EXEC SCANNER CONNECT` cmd 0x0003 -> commits it; the device
             advances the job to OPEN_WAIT and announces the devId.
          3. TCP-connect; the device matches the job by our peer IP. The
             OPEN_WAIT window is brief, so we retry the connect across `window`.

        IMPORTANT: `client_ip` must NOT be the hub's network gateway. From the
        gateway IP the device replies "NG"; a non-gateway client IP is required.

        CRITICAL socket rules (learned the hard way against hardware):
          * The CONNECT must be sent from the SAME UDP socket (same source port)
            that issued GET USB_DEVICE_LIST. The hub keys the session to
            (client_ip, source_port); a CONNECT from a different port never
            advances to OPEN_WAIT. Pass that socket as `udp` (the server reuses
            one persistent session socket for the device list and every attach).
          * A socket MUST stay bound on (client_ip, 19540) through the connect —
            the device sends the OPEN_WAIT grant / devId there. Pass it as `bc`.
        When `udp`/`bc` are omitted this method creates (and later closes) its
        own, which is correct only when no prior GET USB_DEVICE_LIST was sent
        from another socket in this process.

        `device_mac` is the hub's MAC (from discovery). Returns the devId if the
        announcement was captured, else None (use find_dev_id() to sweep).
        """
        import time
        self._node = port_name.encode("latin1") if isinstance(port_name, str) else port_name
        self._mac = device_mac
        self._client_ip = client_ip
        self.seq = 0
        self.dev_id: int | None = None
        self.announce: dict | None = None   # parsed 0x2908 device-attach announcement

        self._rxbuf = b""          # persistent data-channel read buffer (framing)
        self._intr_outstanding = 0 # interrupt_read submits sent but not yet answered

        self._owns_bc = bc is None
        if bc is None:
            bc = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            bc.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            bc.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
            try:
                bc.bind((client_ip, self.port))
            except OSError:
                bc = None
                self._owns_bc = False
        self._bc = bc

        self._owns_udp = udp is None
        if udp is None:
            udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            udp.bind((client_ip, 0))
            udp.connect((self.host, self.port))
        udp.settimeout(1.5)
        self._udp = udp

        # Vendor handshake order (from Packet_Dumps): connect-init -> "OK" ->
        # device-attach announce -> connect-commit. So wait (briefly) for the
        # announce on the grant socket BEFORE sending the commit, matching the
        # vendor; it also gives us the devId up front. NOTE: do NOT insert a
        # blocking wait between connect-commit and the TCP match — the OPEN_WAIT
        # window is only ~0.5s.
        self._udp.send(p.pack_connect_init(device_mac, client_ip, self._node))
        try:
            self._udp.recv(256)   # "OK"
        except socket.timeout:
            pass
        self._capture_announce(wait=1.0)
        self._udp.send(p.pack_connect_commit(device_mac, client_ip, self._node))
        try:
            self._udp.recv(256)
        except socket.timeout:
            pass

        # TCP match immediately (catch the OPEN_WAIT window). The device-attach
        # announcement (0x2908) is captured AFTER the match, not here: it lands on
        # the grant socket a few ms after connect, so a pre-match drain races it
        # (and a blocking wait here would miss the time-sensitive OPEN_WAIT window).
        t0 = time.time()
        while time.time() - t0 < window:
            s = socket.socket()
            s.settimeout(0.5)
            try:
                s.bind((client_ip, 0))
                s.connect((self.host, self.port))
                s.settimeout(0.5)
                try:
                    s.recv(1)      # RST raises; timeout => held open (matched)
                except socket.timeout:
                    pass
                # Arm an abortive (RST) close immediately, so the hub frees the
                # job even if this process dies abruptly (kill -9 / crash) without
                # calling disconnect() — not just on a graceful close().
                s.setsockopt(socket.SOL_SOCKET, socket.SO_LINGER,
                             struct.pack("ii", 1, 0))
                self.tcp = s
                # By now the announcement has been buffered on the grant socket
                # during the match; a non-blocking drain reliably captures it.
                self._capture_announce()
                self._start_keepalive()    # answer the hub's :49501 Salc pings
                return self.dev_id
            except (ConnectionResetError, ConnectionAbortedError, OSError):
                s.close()
            time.sleep(0.08)
        raise TimeoutError("could not match the OPEN_WAIT window (power-cycle if slot busy)")

    def _capture_announce(self, wait: float = 0.0) -> bool:
        """Drain the grant/connect sockets for the hub's device-attach announcement
        (JCP 0x2908, or 0x29eb in state 2) and, if found, set ``self.dev_id`` and
        ``self.announce`` (devId + the attached device's USB descriptors — see
        protocol.parse_announce / SXUPTP_PROTOCOL.md). Gating on the opcode avoids
        mistaking the "OK" reply (byte[3]==0) or a device-list reply for the grant.

        ``wait`` is the max seconds to BLOCK for the announcement to arrive (0 =
        pure non-blocking drain of what's already buffered). Returns True once an
        announcement is captured. Best-effort: if it never arrives, dev_id is left
        as-is and find_dev_id() sweeps instead."""
        socks = [s for s in (self._bc, self._udp) if s is not None]
        saved = {}
        for s in socks:                     # go non-blocking, but restore after:
            try:                            # self._udp keeps a 1.5s timeout the
                saved[s] = s.gettimeout()   # handshake recv()s rely on
                s.settimeout(0.0)
            except OSError:
                pass
        deadline = time.time() + wait
        found = False
        try:
            while True:
                for s in socks:             # drain everything pending right now
                    for _ in range(8):
                        try:
                            d, a = s.recvfrom(4096)
                        except (BlockingIOError, OSError):
                            break
                        if a[0] != self.host or len(d) < 4 or d[0] != 0x29 or d[1] not in (0x08, 0xeb):
                            continue
                        try:
                            self.announce = p.parse_announce(d)
                            self.dev_id = self.announce["dev_id"]
                            found = True
                        except ValueError:
                            pass
                if found or time.time() >= deadline:
                    return found
                select.select(socks, [], [], max(0.0, deadline - time.time()))
        finally:
            for s, to in saved.items():
                try:
                    s.settimeout(to)
                except OSError:
                    pass

    @property
    def ka_echoed(self) -> int:
        return self._ka.echoed if self._ka is not None else 0

    def _start_keepalive(self) -> None:
        # Under a Hub, _ka_enabled is False: the Hub owns the single host-level
        # KeepaliveResponder (the hub keeps ONE keepalive stream per host). A
        # standalone SxuptpClient starts its own.
        if not self._ka_enabled or self._ka is not None:
            return
        self._ka = KeepaliveResponder(self.host, self._client_ip)
        self._ka.start()

    def _stop_keepalive(self) -> None:
        if self._ka is not None:
            self._ka.stop()
            self._ka = None

    def reconnect(self, window: float = 5.0) -> int | None:
        """Re-establish the SXUPTP data channel as a NEW job, to reset the hub's
        per-connection ~60-70s TCP keepalive/RTO timer that otherwise RSTs a long
        single transfer (see proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/
        tcp_connection_and_keepalive.md). The device stays enumerated on the hub;
        only the transport channel (and its timer) is renewed. Call at a safe
        Bulk-Only-Transport boundary (right after a CSW, with no transfer
        in-flight). Reuses the shared session/grant sockets, node and MAC from the
        original attach. Returns the (possibly new) devId.

        The old channel is RST-closed first (SO_LINGER 0) so its job frees in ~1s;
        the new connect/commit re-enters OPEN_WAIT and the TCP match is retried
        across `window`, exactly like attach()."""
        import time
        # Free the current job: send EXEC SCANNER DISCONNECT, then RST-close the
        # TCP (SO_LINGER 0). The firmware frees the slot ~1s after the RST, so a
        # new CONNECT for the same device NGs until then -- settle before re-connect.
        try:
            self._udp.send(p.pack_disconnect(self._mac, self._client_ip, self._node))
        except OSError:
            pass
        if self.tcp is not None:
            try:
                self.tcp.setsockopt(socket.SOL_SOCKET, socket.SO_LINGER,
                                    struct.pack("ii", 1, 0))
                self.tcp.close()
            except OSError:
                pass
            self.tcp = None
        time.sleep(1.5)                 # let the hub free the old slot
        self.seq = 0
        self._rxbuf = b""
        self._udp.send(p.pack_connect_init(self._mac, self._client_ip, self._node))
        try:
            self._udp.recv(256)
        except socket.timeout:
            pass
        self._capture_announce(wait=1.0)   # vendor order: await announce before commit
        self._udp.send(p.pack_connect_commit(self._mac, self._client_ip, self._node))
        try:
            self._udp.recv(256)
        except socket.timeout:
            pass
        t0 = time.time()
        while time.time() - t0 < window:
            s = socket.socket()
            s.settimeout(0.5)
            try:
                s.bind((self._client_ip, 0))
                s.connect((self.host, self.port))
                s.settimeout(0.5)
                try:
                    s.recv(1)
                except socket.timeout:
                    pass
                s.setsockopt(socket.SOL_SOCKET, socket.SO_LINGER, struct.pack("ii", 1, 0))
                self.tcp = s
                self._capture_announce()   # announcement is buffered by now
                self._start_keepalive()
                return self.dev_id
            except (ConnectionResetError, ConnectionAbortedError, OSError):
                s.close()
            time.sleep(0.08)
        raise TimeoutError("reconnect: could not match the OPEN_WAIT window")

    def _control(self, dev_id: int, setup: p.Setup, data: bytes = b"") -> tuple[int, bytes]:
        """One control transfer on an open channel -> (status, data). CONFIRMED."""
        if self.tcp is None:
            raise RuntimeError("not attached")
        self.seq = (self.seq + 1) & 0xFFFF
        if setup.bmRequestType & 0x80:          # device -> host (read)
            req = p.control_read(dev_id, setup.bmRequestType, setup.bRequest,
                                 setup.wValue, setup.wIndex, setup.wLength, seq=self.seq)
        else:                                    # host -> device (write)
            req = p.control_write(dev_id, setup.bmRequestType, setup.bRequest,
                                  setup.wValue, setup.wIndex, data, seq=self.seq)
        self.tcp.sendall(req)
        self.tcp.settimeout(self.timeout)
        reply = self.tcp.recv(4096)
        return p.parse_control_reply(reply)

    def _recv_exact(self, n: int) -> bytes:
        buf = b""
        while len(buf) < n:
            chunk = self.tcp.recv(n - len(buf))
            if not chunk:
                raise ConnectionError("peer closed during recv")
            buf += chunk
        return buf

    def _recv_reply(self) -> tuple[int, bytes]:
        """Read one framed transfer reply: 10-byte header + `size` data bytes."""
        import struct
        hdr = self._recv_exact(p.CTRL_REPLY_HEADER)
        status = struct.unpack_from(">H", hdr, 4)[0]
        size = struct.unpack_from(">H", hdr, 8)[0]
        data = self._recv_exact(size) if size else b""
        return status, data

    def _read_framed(self, timeout: float | None) -> tuple[int, int, bytes]:
        """Read one complete data-channel message -> (seq, status, data).

        Every SXUPTP data-channel message is UNIFORMLY framed: a 10-byte header
        (type, seq, status, reserved, size) followed by `size` data bytes. There
        are no bare 6-byte ACKs (verified against a Windows-driver capture — a
        keyboard report is a single 18-byte message: 10-byte header + 8 data), and
        replies echo the request's seq in FIFO order.

        Buffering across calls makes framing robust to TCP fragmentation and to a
        `timeout` firing mid-message: on timeout the partial bytes stay in
        `self._rxbuf` and the socket.timeout propagates, so the next call resumes
        exactly where this one stopped. `timeout=None` blocks indefinitely (the
        ChannelMux reader always wants the next message).
        """
        self.tcp.settimeout(timeout)
        while True:
            if len(self._rxbuf) >= p.CTRL_REPLY_HEADER:
                seq = struct.unpack_from(">H", self._rxbuf, 2)[0]
                size = struct.unpack_from(">H", self._rxbuf, 8)[0]
                total = p.CTRL_REPLY_HEADER + size
                if len(self._rxbuf) >= total:
                    status = struct.unpack_from(">H", self._rxbuf, 4)[0]
                    data = self._rxbuf[p.CTRL_REPLY_HEADER:total]
                    self._rxbuf = self._rxbuf[total:]
                    return seq, status, data
            chunk = self.tcp.recv(2048)      # socket.timeout keeps _rxbuf intact
            if not chunk:
                raise ConnectionError("peer closed during reply")
            self._rxbuf += chunk

    def _read_reply(self, timeout: float) -> tuple[int, bytes]:
        """Read one complete data-channel reply (status, data), ignoring seq."""
        _seq, status, data = self._read_framed(timeout)
        return status, data

    def bulk_out(self, ep_addr: int, data: bytes) -> int:
        """Bulk/interrupt OUT transfer -> status (0 = OK). ep_addr is a full USB
        endpoint address (bit7=0). CONFIRMED path (pybelkusb bulk worked live).

        The SXUPTP size field is 16-bit, so a single request can carry at most
        0xFFFF bytes; a larger buffer (e.g. a multi-sector mass-storage WRITE(10)
        data phase, which the kernel issues up to ~120 KB at a time) overflows it
        and wedges the device with -32. Split into 512-aligned chunks, the same
        cap bulk_in uses, and send them back-to-back as one USB OUT stream."""
        if self.tcp is None or self.dev_id is None:
            raise RuntimeError("not attached")
        mps = self.ep_mps.get(ep_addr, 512)
        if not data:
            self.seq = (self.seq + 1) & 0xFFFF
            self.tcp.sendall(p.bulk_write(self.dev_id, ep_addr, data, seq=self.seq, mps=mps))
            self.tcp.settimeout(self.timeout)
            status, _ = self._recv_reply()
            return status
        off = 0
        while off < len(data):
            chunk = data[off:off + self._BULK_CHUNK]
            # On a sustained write the device's write-back cache fills and it NAKs
            # its bulk-OUT pipe; the hub gives up and returns an error. Pause to let
            # the flash flush, then resend the same chunk (the hub delivers a chunk
            # all-or-nothing, so a resend does not duplicate bytes). A steady
            # inter-chunk pace keeps the cache from filling in the first place.
            deadline = time.monotonic() + self._bulk_retry_window
            pause = self._bulk_recover
            backpressure = False
            while True:
                self.seq = (self.seq + 1) & 0xFFFF
                t0 = time.monotonic()
                self.tcp.sendall(p.bulk_write(self.dev_id, ep_addr, chunk, seq=self.seq, mps=mps))
                self.tcp.settimeout(self.timeout)
                status, _ = self._recv_reply()
                lat = time.monotonic() - t0          # how long the hub took to ACK
                if status == p.STATUS_OK:
                    break
                backpressure = True
                if self._bulk_stats:
                    self._stats(lat, pause, True, len(chunk),
                                event=f"resend status={status:#06x}")
                if time.monotonic() > deadline:
                    if self._bulk_stats:
                        self._stats(lat, pause, True, 0, event=f"GIVEUP status={status:#06x}")
                    return status
                time.sleep(pause)
                pause = min(pause * 1.5, 1.0)
            off += len(chunk)
            # Pacing: adaptive (device-driven) when enabled, else the fixed pace.
            delay = self._adapt_step(lat, backpressure) if self._bulk_adapt else self._bulk_pace
            if self._bulk_stats:
                self._stats(lat, delay, backpressure, len(chunk))
            if delay:
                time.sleep(delay)
        return p.STATUS_OK

    # Per-request cap for bulk IN. Must be 512-aligned: one SXUPTP bulk_read maps
    # to one USB bulk IN of this many bytes, and a non-512-aligned size corrupts
    # USB packetization mid-stream (observed: 0xFFFF reset the device). The length
    # field is 16-bit, so this is the largest 512-multiple that fits.
    _BULK_CHUNK = 0xFE00   # 65024 = 127 * 512

    # Inter-chunk pace after each bulk-OUT chunk. DEFAULT 0 (no pacing) -- we do
    # not throttle by default: the vendor doesn't, and the ~69s wedge is cured by
    # the SXUP_ALC keepalive (KeepaliveResponder), not by slowing writes (the old
    # "pacing keeps RTT samples flowing / cache from filling" rationale was from
    # the refuted traffic-shape theories). The reactive resend-on-NAK loop above
    # still rides out a transient flash-flush stall. If a specific device still
    # NAK-storms under full-rate sustained writes, set SXBULK_PACE (seconds) or use
    # SXBULK_ADAPT=1 for device-driven pacing. Tunable via SXBULK_PACE; 0 = off.
    _bulk_pace = float(os.environ.get("SXBULK_PACE", "0") or 0)
    # On a bulk-OUT the hub rejects (device write-cache briefly full), pause and
    # resend the same chunk (the hub delivers a chunk all-or-nothing, so a resend
    # never duplicates bytes), backing off up to 1s, until this window elapses.
    # This rides out a transient flush stall. The window is deliberately short: a
    # device that has truly wedged does not recover by resending, and hammering a
    # wedged slot only prolongs it, so we fail the I/O promptly instead.
    _bulk_recover = float(os.environ.get("SXBULK_RECOVER", "0.05") or 0)
    _bulk_retry_window = float(os.environ.get("SXBULK_RETRY_WINDOW", "1.5") or 0)

    # --- reactive (adaptive) pacing [PROTOTYPE] -------------------------------
    # Instead of a fixed inter-chunk pace, derive the write rate from the hub's
    # own back-pressure: time how long each 64 KB chunk's ACK takes and run AIMD
    # on the inter-chunk delay -- shrink it while ACKs stay fast and status is OK,
    # grow it the instant an ACK slows or the device reports busy. The device sets
    # the pace, not a synthetic constant. Opt in with SXBULK_ADAPT=1 (then
    # SXBULK_PACE is ignored for multi-chunk transfers).
    _bulk_adapt = bool(os.environ.get("SXBULK_ADAPT"))
    # SXBULK_STATS=1 prints the per-window latency/pace trend to stderr -- the
    # instrumentation that answers "does ACK latency rise before the -32 drop, or
    # does the device drop cold?" (works with fixed OR adaptive pacing).
    _bulk_stats = bool(os.environ.get("SXBULK_STATS"))
    _ADAPT_FLOOR = 0.0      # min inter-chunk delay (s) while the hub keeps up
    _ADAPT_CAP = 0.25       # max delay (s) under sustained back-pressure
    _ADAPT_AI = 0.001       # additive decrease per healthy chunk (speed back up)
    _ADAPT_MD = 2.0         # multiplicative increase on back-pressure (slow down)
    _ADAPT_BUMP = 0.010     # delay floor the first back-pressure jumps to
    _ADAPT_SPIKE = 4.0      # ACK latency > this x EWMA baseline => back-pressure
    _ADAPT_ABS = 0.012      # ...or ACK latency over this many seconds (absolute)
    _STATS_WINDOW = int(os.environ.get("SXBULK_STATS_WINDOW", "64") or 64)  # chunks/line (~4 MB)

    def _adapt_step(self, lat: float, backpressure: bool) -> float:
        """Update the adaptive inter-chunk delay from one chunk's ACK latency and
        whether it needed a resend; return the delay to sleep. AIMD on the delay:
        additive-decrease while healthy, multiplicative-increase under stress."""
        if not hasattr(self, "_adapt_pace"):
            self._adapt_pace = self._bulk_pace or 0.0
            self._lat_ewma = lat
        ewma = self._lat_ewma
        # Either signal means back off: an absolute slow ACK (always suspicious on
        # this hub, where a healthy ACK is ~1 ms), or a relative spike over the
        # running baseline (catches a gradual climb before it crosses the absolute
        # line). Only update the baseline from NON-stressed samples, so a sustained
        # stall can't creep into the baseline and silence the detector.
        stressed = (backpressure or lat > self._ADAPT_ABS
                    or lat > ewma * self._ADAPT_SPIKE)
        if not stressed:
            self._lat_ewma = 0.85 * ewma + 0.15 * lat
        if stressed:
            self._adapt_pace = min(max(self._adapt_pace * self._ADAPT_MD,
                                       self._ADAPT_BUMP), self._ADAPT_CAP)
        else:
            self._adapt_pace = max(self._adapt_pace - self._ADAPT_AI, self._ADAPT_FLOOR)
        return self._adapt_pace

    def _stats(self, lat: float, delay: float, backpressure: bool, n: int,
               event: str = "") -> None:
        """Accumulate per-chunk write stats and emit a line every _STATS_WINDOW
        chunks (plus immediately on any back-pressure/anomaly), to stderr. Cumulative
        counters (bytes, total back-pressure) never reset; window counters (count,
        latency sum/max) reset on each emitted line."""
        import os as _os
        if not hasattr(self, "_st_t0"):
            self._st_t0 = time.monotonic()
            self._st_bytes = self._st_bp = 0           # cumulative
            self._st_wn = self._st_wsum = self._st_wmax = 0.0   # per window
        if event:                                      # anomaly line only; no accounting
            _os.write(2, (f"[wstat] t={time.monotonic()-self._st_t0:6.1f}s "
                          f"MB={self._st_bytes/1e6:6.1f} !! {event} "
                          f"(lat_ms={lat*1000:.2f})\n").encode())
            return
        self._st_bytes += n
        if backpressure:
            self._st_bp += 1
        self._st_wn += 1
        self._st_wsum += lat
        self._st_wmax = max(self._st_wmax, lat)
        if backpressure or self._st_wn >= self._STATS_WINDOW:
            avg = self._st_wsum / self._st_wn
            _os.write(2, (f"[wstat] t={time.monotonic()-self._st_t0:6.1f}s "
                          f"MB={self._st_bytes/1e6:6.1f} "
                          f"lat_ms avg={avg*1000:6.2f} max={self._st_wmax*1000:7.2f} "
                          f"pace_ms={delay*1000:6.2f} bp_total={self._st_bp}\n").encode())
            self._st_wn = self._st_wsum = self._st_wmax = 0.0

    def bulk_in(self, ep_addr: int, length: int) -> tuple[int, bytes]:
        """Bulk/interrupt IN transfer -> (status, data). ep_addr has bit7=1 (IN).

        One SXUPTP bulk_read = one USB bulk IN of the requested size; the firmware
        returns the actual bytes (verified: a 4096-byte read came back whole).

        A **non-zero** reply shorter than requested is a USB short packet = end of
        transfer, so we stop (re-requesting would pull the next transfer's bytes,
        e.g. a CSW, and desync mass storage). A **zero-length** reply is different:
        it is the device NAKing because data is not ready yet — notably the CSW
        after a mass-storage WRITE, while the flash commits. Treating that as a
        short packet would hand the kernel a 0-byte CSW (-> I/O error), so we
        instead retry until data arrives or a deadline passes. Larger transfers are
        split into 512-aligned chunks.
        """
        if self.tcp is None or self.dev_id is None:
            raise RuntimeError("not attached")
        mps = self.ep_mps.get(ep_addr, 512)
        out = b""
        remaining = length
        deadline = time.monotonic() + max(self.timeout, 5.0)
        while remaining > 0:
            req = min(remaining, self._BULK_CHUNK)
            self.seq = (self.seq + 1) & 0xFFFF
            self.tcp.sendall(p.bulk_read(self.dev_id, ep_addr, req, seq=self.seq, mps=mps))
            self.tcp.settimeout(self.timeout)
            status, data = self._recv_reply()
            if status != p.STATUS_OK:
                return status, out
            if not data:                     # NAK: no data yet (e.g. CSW committing)
                if time.monotonic() > deadline:
                    break
                time.sleep(0.002)
                continue
            out += data
            remaining -= len(data)
            if len(data) < req:              # non-zero short packet => transfer complete
                break
        return p.STATUS_OK, out

    def interrupt_in(self, ep_addr: int, length: int, interval: int = 10,
                     timeout: float | None = None) -> tuple[int, bytes]:
        """Interrupt IN transfer -> (status, report). Uses type 0x0002 (category
        2), which is what actually polls an interrupt endpoint — `bulk_in`
        (category 3) hits the bulk/queue path and never delivers HID reports.

        With SET_IDLE the device reports only on change, so it HOLDS the request
        and replies when a report is ready (a key event); `timeout` bounds the
        wait (None = self.timeout) so the caller's URB loop stays responsive.

        Exactly one interrupt_read is kept outstanding at the device: a timeout
        does NOT resubmit (that would pile up unanswered reads and leave stale
        reports in the stream) — we simply keep waiting on the one already in
        flight. The reply is a single uniform 10-byte-header + `size` message.
        """
        if self.tcp is None or self.dev_id is None:
            raise RuntimeError("not attached")
        if self._intr_outstanding <= 0:
            self.seq = (self.seq + 1) & 0xFFFF
            self.tcp.sendall(p.interrupt_read(self.dev_id, ep_addr, length,
                                              interval, seq=self.seq))
            self._intr_outstanding = 1
        status, data = self._read_reply(self.timeout if timeout is None else timeout)
        self._intr_outstanding -= 1          # answered; next call resubmits
        return status, data

    def find_dev_id(self, candidates: tuple[int, ...] = (1, 2, 3, 4, 5, 6, 7, 8, 0),
                    want_vid: int | None = None, want_pid: int | None = None,
                    exclude: tuple[int, ...] = ()) -> int:
        """Probe candidate devIds with GET_DESCRIPTOR(device) and pick one.

        The devId is a USB device address, NOT the devNN index. The hub *does*
        announce it (byte[3] of the JCP 0x2908 device-attach announcement, which
        also carries the USB descriptors — see SXUPTP_PROTOCOL.md), and attach()/
        reconnect() capture it opportunistically; but that announcement may not
        reach the socket we listen on, so this sweep is the reliable fallback: it
        matches by the device's VID:PID when given — the dependable node->device
        mapping, since GET USB_DEVICE_LIST carries the VID:PID for each devNN.
        Without want_vid/pid we take the first OK devId.
        `exclude` skips handles already assigned (for duplicate VID:PID devices).
        Remembers and returns the chosen devId.
        """
        setup = p.Setup.get_descriptor(desc_type=1, desc_index=0, length=18)
        order = ([self.dev_id] if self.dev_id is not None else []) + \
                [c for c in candidates if c != self.dev_id]
        first_ok = None
        for dv in order:
            if dv in exclude:
                continue
            status, data = self._control(dv, setup)
            if status != p.STATUS_OK or data[:2] != b"\x12\x01" or len(data) < 12:
                continue
            vid = data[8] | (data[9] << 8)
            pid = data[10] | (data[11] << 8)
            if want_vid is None:
                self.dev_id = dv
                return dv
            if vid == want_vid and pid == want_pid:
                self.dev_id = dv
                return dv
            if first_ok is None:
                first_ok = dv
        if want_vid is not None and first_ok is not None:
            # no exact VID:PID match (e.g. device not reachable) — fall back
            self.dev_id = first_ok
            return first_ok
        if first_ok is not None:
            self.dev_id = first_ok
            return first_ok
        raise RuntimeError("no devId returned a device descriptor")

    def control_transfer(self, setup: p.Setup, data: bytes = b"") -> bytes:
        """Send a control transfer and return the data stage (b"" for writes).
        Raises if the device reports a non-OK status. CONFIRMED live."""
        if self.dev_id is None:
            self.find_dev_id()
        status, out = self._control(self.dev_id, setup, data)
        if status != p.STATUS_OK:
            raise RuntimeError(f"control transfer failed: status=0x{status:04x}")
        return out

    def disconnect(self) -> None:
        """Release the device slot and close the channel.

        The slot is freed by closing the TCP data channel with an ABORTIVE RST
        (SO_LINGER 0), not a graceful FIN: the firmware's connection state machine
        sets the job to state 3 only when its recv() returns an ERROR, and state 3
        is the teardown that calls Free job (sub_00302924). A clean FIN leaves the
        job reserved (NG on reconnect) until the hub reboots; an RST frees it in
        ~1s, enabling attach/detach cycles with no reboot. (Verified live.)

        The EXEC SCANNER DISCONNECT datagram is still sent (it is acked and is the
        documented teardown), but the RST is what actually releases the slot.
        Caller-owned sockets (shared session/grant) are left open.
        """
        if getattr(self, "_udp", None):
            try:
                self._udp.send(p.pack_disconnect(self._mac, self._client_ip, self._node))
            except OSError:
                pass
            if getattr(self, "_owns_udp", True):
                self._udp.close()
            self._udp = None
        self.close()

    def close(self) -> None:
        self._stop_keepalive()
        if self.tcp:
            try:
                # abortive close -> RST, so the hub frees the job (see disconnect)
                self.tcp.setsockopt(socket.SOL_SOCKET, socket.SO_LINGER,
                                    struct.pack("ii", 1, 0))
            except OSError:
                pass
            self.tcp.close()
            self.tcp = None
        if getattr(self, "_bc", None):
            if getattr(self, "_owns_bc", True):
                self._bc.close()
            self._bc = None


class ChannelMux:
    """Multiplex control + interrupt + bulk over ONE attached SXUPTP channel.

    The hub serves every endpoint of a device on its node's channel and replies
    echo the request's seq; crucially the device replies OUT OF ORDER by seq (a
    blocked bulk-IN read does NOT hold up a later control reply — verified live).
    A single-threaded URB loop would stall on any blocking read, so this owns the
    channel after enumeration: one reader thread drains every reply and demuxes by
    seq —

      * interrupt reports -> the matching endpoint; the kernel's pending URB is
        completed via its callback, and one read is kept outstanding (resubmitted)
        so reports arrive the instant they're ready (no polling, no latency);
      * bulk-IN replies -> the kernel URB that issued that read (one read per URB;
        a serial RX read may park for a long time with no data, which is exactly
        why it must be async — it must not stall control/TX on the same channel);
      * control and bulk-OUT replies -> the waiting synchronous caller.

    Sends on the SXUPTP socket are serialized with `_lock`; the reader only
    receives. URB-completion callbacks send on the (separate) USB/IP socket, which
    the server serializes independently.
    """

    def __init__(self, client: SxuptpClient):
        self.c = client
        self._lock = threading.Lock()
        self._ep_cfg: dict[int, tuple[int, int]] = {}      # intr ep -> (length, interval)
        self._primed: set[int] = set()                     # intr eps with a read outstanding
        self._seq_ep: dict[int, int] = {}                  # outstanding intr read seq -> ep
        self._pending: dict[int, "collections.deque"] = {} # intr ep -> URBs awaiting a report
        self._reports: dict[int, "collections.deque"] = {} # intr ep -> reports awaiting a URB
        self._bulk_in: set[int] = set()                    # registered bulk-IN eps
        self._bulk_pending: dict[int, tuple] = {}          # bulk read seq -> (urb, complete, ep)
        self._next_read_at: dict[int, float] = {}          # bulk ep -> earliest next read (throttle)
        self._ctrl: dict[int, list] = {}                   # control/bulk-out seq -> [Event, result]
        self._err: Exception | None = None
        self._alive = True
        self._t = threading.Thread(target=self._reader, daemon=True)
        self._t.start()

    def register_intr(self, ep_addr: int, length: int, interval: int) -> None:
        self._ep_cfg[ep_addr] = (length or 8, interval or 10)
        self._pending[ep_addr] = collections.deque()
        self._reports[ep_addr] = collections.deque()

    def register_bulk_in(self, ep_addr: int) -> None:
        self._bulk_in.add(ep_addr)

    # --- interrupt (async) ----------------------------------------------
    def _prime(self, ep: int) -> None:
        """Send one interrupt_read for `ep` (caller holds _lock)."""
        length, interval = self._ep_cfg[ep]
        self.c.seq = (self.c.seq + 1) & 0xFFFF
        seq = self.c.seq
        self._seq_ep[seq] = ep
        self.c.tcp.sendall(p.interrupt_read(self.c.dev_id, ep, length, interval, seq=seq))
        self._primed.add(ep)

    def _reprime_later(self, ep: int) -> None:
        """Re-issue the interrupt poll for `ep` after its bInterval, off the reader
        thread, so an idle or hub-errored poll does not busy-loop. At most one
        re-poll is scheduled per ep (the read is single-outstanding)."""
        if not self._alive:
            return
        interval = self._ep_cfg.get(ep, (8, 10))[1] or 10
        delay = min(max(interval, 4), 20) / 1000.0        # bInterval ms -> seconds, clamped
        def fire():
            with self._lock:
                if not self._alive or self._err or ep in self._primed:
                    return
                self._prime(ep)
        threading.Timer(delay, fire).start()

    def enqueue(self, ep: int, urb, complete) -> None:
        """Register a kernel interrupt-IN URB. `complete(urb, status, data)` is
        called (possibly on the reader thread) when a report for `ep` arrives; if
        a report is already buffered it completes immediately."""
        with self._lock:
            if self._err:
                complete(urb, EREMOTEIO_, b"")
                return
            rep = self._reports[ep]
            if rep:
                status, data = rep.popleft()
                cb = (urb, complete)
            else:
                self._pending[ep].append((urb, complete))
                cb = None
            if ep not in self._primed:
                self._prime(ep)
        if cb is not None:
            cb[1](cb[0], status, data)

    def cancel(self, ep: int) -> None:
        """Drop any URBs queued for `ep` (on UNLINK / teardown)."""
        with self._lock:
            self._pending.get(ep, collections.deque()).clear()

    # --- bulk IN (async) ------------------------------------------------
    # Some adapters (FTDI) answer every bulk-IN read instantly with 2 modem-status
    # bytes and no data, so an async read-per-URB would spin as fast as the kernel
    # resubmits, pegging the CPU and starving other devices. We throttle: after a
    # read returns no real payload, defer the next read on that endpoint by this
    # much (~the FTDI latency-timer cadence). Reads carrying data are not delayed.
    _BULK_IDLE_DELAY = 0.010
    _BULK_EMPTY = 2          # <= this many bytes is "status only / empty"

    def enqueue_bulk_in(self, ep: int, urb, complete, length: int) -> None:
        """Register a kernel bulk-IN URB: issue ONE bulk_read(length) and complete
        the URB (`complete(urb, status, data)`) when its reply arrives. A reply
        shorter than `length` is a USB short packet = the data for this URB (normal
        for a serial stream), not an error. Throttled per endpoint (see above)."""
        def send():
            with self._lock:
                if self._err:
                    cb = (urb, complete)
                else:
                    self.c.seq = (self.c.seq + 1) & 0xFFFF
                    seq = self.c.seq
                    self._bulk_pending[seq] = (urb, complete, ep)
                    self.c.tcp.sendall(p.bulk_read(self.c.dev_id, ep, length, seq=seq,
                                                   mps=self.c.ep_mps.get(ep, 512)))
                    cb = None
            if cb is not None:
                cb[1](cb[0], EREMOTEIO_, b"")
        delay = self._next_read_at.get(ep, 0.0) - time.monotonic()
        if delay > 0:
            threading.Timer(delay, send).start()
        else:
            send()

    # --- bulk OUT (synchronous) -----------------------------------------
    def bulk_out(self, ep: int, data: bytes, timeout: float = 3.0) -> int:
        """Write a bulk-OUT transfer, waiting for its ack (by seq). Returns status.
        The ack returns promptly even while a bulk-IN read is parked."""
        ev = threading.Event()
        with self._lock:
            if self._err:
                raise self._err
            self.c.seq = (self.c.seq + 1) & 0xFFFF
            seq = self.c.seq
            self._ctrl[seq] = [ev, None]
            self.c.tcp.sendall(p.bulk_write(self.c.dev_id, ep, data, seq=seq,
                                            mps=self.c.ep_mps.get(ep, 512)))
        if not ev.wait(timeout):
            with self._lock:
                self._ctrl.pop(seq, None)
            raise TimeoutError("bulk-out transfer timed out")
        with self._lock:
            res = self._ctrl.pop(seq, None)
        if self._err:
            raise self._err
        return res[1][0]                                   # status

    # --- control (synchronous) ------------------------------------------
    def control(self, setup: p.Setup, data: bytes = b"", timeout: float = 3.0) -> tuple[int, bytes]:
        ev = threading.Event()
        with self._lock:
            if self._err:
                raise self._err
            self.c.seq = (self.c.seq + 1) & 0xFFFF
            seq = self.c.seq
            self._ctrl[seq] = [ev, None]
            if setup.bmRequestType & 0x80:
                req = p.control_read(self.c.dev_id, setup.bmRequestType, setup.bRequest,
                                     setup.wValue, setup.wIndex, setup.wLength, seq=seq)
            else:
                req = p.control_write(self.c.dev_id, setup.bmRequestType, setup.bRequest,
                                      setup.wValue, setup.wIndex, data, seq=seq)
            self.c.tcp.sendall(req)
        if not ev.wait(timeout):
            with self._lock:
                self._ctrl.pop(seq, None)
            raise TimeoutError("control transfer timed out")
        with self._lock:
            res = self._ctrl.pop(seq, None)
        if self._err:
            raise self._err
        return res[1]

    # --- reader ----------------------------------------------------------
    def _reader(self) -> None:
        try:
            while self._alive:
                seq, status, data = self.c._read_framed(None)
                done = None
                with self._lock:
                    ep = self._seq_ep.pop(seq, None)
                    if ep is not None:                  # interrupt poll reply
                        self._primed.discard(ep)
                        if status == p.STATUS_OK and data:   # a real HID report
                            pend = self._pending[ep]
                            if pend:
                                urb, complete = pend.popleft()
                                done = (complete, urb, status, data)
                            else:
                                self._reports[ep].append((status, data))
                            self._prime(ep)             # keep one outstanding
                        else:
                            # No usable report: either an empty reply (endpoint idle)
                            # or a non-OK status -- under multi-device load the hub
                            # stops holding the interrupt read and kicks it back with
                            # an error (often still carrying stale bytes). Do NOT
                            # complete the URB: the kernel resubmits with no backoff,
                            # and a hub that keeps erroring these turns it into a
                            # ~1 kHz storm that saturates the hub and wedges the other
                            # devices. Keep the URB parked and re-poll at the
                            # endpoint's interval; the next real report still arrives
                            # promptly.
                            self._reprime_later(ep)
                    elif seq in self._bulk_pending:     # bulk-IN reply
                        urb, complete, bep = self._bulk_pending.pop(seq)
                        if len(data) <= self._BULK_EMPTY:  # no real payload -> pace
                            self._next_read_at[bep] = time.monotonic() + self._BULK_IDLE_DELAY
                        else:
                            self._next_read_at[bep] = 0.0
                        done = (complete, urb, status, data)
                    else:                               # control / bulk-out ack
                        w = self._ctrl.get(seq)
                        if w is not None:
                            w[1] = (status, data)
                            w[0].set()
                if done is not None:
                    done[0](done[1], done[2], done[3])  # complete URB (no lock held)
        except Exception as e:                           # socket closed / peer gone
            self._err = e
            self._alive = False
            with self._lock:
                for w in self._ctrl.values():
                    w[0].set()
                pend_all = [(c, u) for dq in self._pending.values() for (u, c) in dq]
                for dq in self._pending.values():
                    dq.clear()
                pend_all += [(cb, urb) for urb, cb, _ep in self._bulk_pending.values()]
                self._bulk_pending.clear()
            for complete, urb in pend_all:
                try:
                    complete(urb, EREMOTEIO_, b"")
                except Exception:
                    pass

    def close(self) -> None:
        self._alive = False
        try:
            self.c.tcp.shutdown(socket.SHUT_RDWR)        # unblock the reader's recv
        except OSError:
            pass


# USB/IP short-IO errno surfaced to a URB when the channel dies mid-flight.
EREMOTEIO_ = -121
