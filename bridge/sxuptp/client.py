"""
SXUPTP probe client.

Implements the reverse-engineered SXUPTP handshake and data channel: discovery,
device list, attach (two-step CONNECT + OPEN_WAIT match), control and bulk/
interrupt transfers, and clean slot release (RST close). Confirmed live against a
Belkin F5L009 hub (see ../SXUPTP_PROTOCOL.md).
"""
from __future__ import annotations

import collections
import queue
import socket
import struct
import threading
import time

from . import protocol as p


class SxuptpClient:
    def __init__(self, host: str, port: int = p.PORT, timeout: float = 3.0):
        self.host = host
        self.port = port
        self.timeout = timeout
        self.tcp: socket.socket | None = None

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
        attach). Retries once because the hub occasionally drops the first reply
        right after a discovery round.

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
                s.sendto(p.pack_jcp(p.JCP_USB_DEVICE_LIST, command=1), (host, port))
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

        # NOTE: do NOT insert any blocking wait between connect-commit and the
        # TCP match. The OPEN_WAIT window is only ~0.5s.
        self._udp.send(p.pack_connect_init(device_mac, client_ip, self._node))
        try:
            self._udp.recv(256)   # "OK"
        except socket.timeout:
            pass
        self._udp.send(p.pack_connect_commit(device_mac, client_ip, self._node))
        try:
            self._udp.recv(256)
        except socket.timeout:
            pass

        # best-effort, NON-blocking devId capture from the grant on :19540
        if self._bc is not None:
            self._bc.settimeout(0.0)
            try:
                d, a = self._bc.recvfrom(4096)
                if a[0] == self.host and len(d) > 3:
                    self.dev_id = d[3]
            except (BlockingIOError, OSError):
                pass

        # TCP match immediately (catch the OPEN_WAIT window)
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
                return self.dev_id
            except (ConnectionResetError, ConnectionAbortedError, OSError):
                s.close()
            time.sleep(0.08)
        raise TimeoutError("could not match the OPEN_WAIT window (power-cycle if slot busy)")

    def _control(self, dev_id: int, setup: p.Setup, data: bytes = b"") -> tuple[int, bytes]:
        """One control transfer on an open channel -> (status, data). CONFIRMED."""
        if self.tcp is None:
            raise RuntimeError("not attached")
        self.seq += 1
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
        endpoint address (bit7=0). CONFIRMED path (pybelkusb bulk worked live)."""
        if self.tcp is None or self.dev_id is None:
            raise RuntimeError("not attached")
        self.seq += 1
        self.tcp.sendall(p.bulk_write(self.dev_id, ep_addr, data, seq=self.seq))
        self.tcp.settimeout(self.timeout)
        status, _ = self._recv_reply()
        return status

    # Per-request cap for bulk IN. Must be 512-aligned: one SXUPTP bulk_read maps
    # to one USB bulk IN of this many bytes, and a non-512-aligned size corrupts
    # USB packetization mid-stream (observed: 0xFFFF reset the device). The length
    # field is 16-bit, so this is the largest 512-multiple that fits.
    _BULK_CHUNK = 0xFE00   # 65024 = 127 * 512

    def bulk_in(self, ep_addr: int, length: int) -> tuple[int, bytes]:
        """Bulk/interrupt IN transfer -> (status, data). ep_addr has bit7=1 (IN).

        One SXUPTP bulk_read = one USB bulk IN of the requested size; the firmware
        returns the actual bytes (verified: a 4096-byte read came back whole). A
        reply SHORTER than requested is a USB short packet = end of transfer, so we
        stop (re-requesting would pull the next transfer's bytes, e.g. a CSW, and
        desync mass storage). Larger transfers are split into 512-aligned chunks.
        """
        if self.tcp is None or self.dev_id is None:
            raise RuntimeError("not attached")
        out = b""
        remaining = length
        while remaining > 0:
            req = min(remaining, self._BULK_CHUNK)
            self.seq += 1
            self.tcp.sendall(p.bulk_read(self.dev_id, ep_addr, req, seq=self.seq))
            self.tcp.settimeout(self.timeout)
            status, data = self._recv_reply()
            if status != p.STATUS_OK:
                return status, out
            out += data
            remaining -= len(data)
            if len(data) < req:              # USB short packet => transfer complete
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
            self.seq += 1
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

        The devId is a USB device address, NOT the devNN index, and the hub does
        not announce it to us (the OPEN_WAIT grant never arrives on :19540 here).
        So we sweep and match by the device's VID:PID when given — this is the
        reliable node->device mapping, since GET USB_DEVICE_LIST carries the
        VID:PID for each devNN. Without want_vid/pid we take the first OK devId.
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
        self.c.seq += 1
        seq = self.c.seq
        self._seq_ep[seq] = ep
        self.c.tcp.sendall(p.interrupt_read(self.c.dev_id, ep, length, interval, seq=seq))
        self._primed.add(ep)

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
                    self.c.seq += 1
                    seq = self.c.seq
                    self._bulk_pending[seq] = (urb, complete, ep)
                    self.c.tcp.sendall(p.bulk_read(self.c.dev_id, ep, length, seq=seq))
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
            self.c.seq += 1
            seq = self.c.seq
            self._ctrl[seq] = [ev, None]
            self.c.tcp.sendall(p.bulk_write(self.c.dev_id, ep, data, seq=seq))
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
            self.c.seq += 1
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
                    if ep is not None:                  # interrupt report
                        self._primed.discard(ep)
                        pend = self._pending[ep]
                        if pend:
                            urb, complete = pend.popleft()
                            done = (complete, urb, status, data)
                        else:
                            self._reports[ep].append((status, data))
                        self._prime(ep)                 # keep one outstanding
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
