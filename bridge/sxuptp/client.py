"""
SXUPTP probe client.

Implements the reverse-engineered handshake far enough to discover a device,
open a TCP session, and issue a control transfer. CONFIRMED pieces (ports,
framing, control SETUP) are solid; the discovery-reply parsing and the attach
request body are INFERRED and will likely need adjustment against a real device
(see ../SXUPTP_PROTOCOL.md). Nothing here has been tested against hardware yet.
"""
from __future__ import annotations

import socket
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

    def bulk_in(self, ep_addr: int, length: int) -> tuple[int, bytes]:
        """Bulk/interrupt IN transfer -> (status, data). ep_addr has bit7=1 (IN).
        Re-requests until `length` bytes arrive or a short/zero packet ends it."""
        if self.tcp is None or self.dev_id is None:
            raise RuntimeError("not attached")
        out = b""
        remaining = length
        while remaining > 0:
            chunk_req = min(remaining, 0xFFFF)
            self.seq += 1
            self.tcp.sendall(p.bulk_read(self.dev_id, ep_addr, chunk_req, seq=self.seq))
            self.tcp.settimeout(self.timeout)
            status, data = self._recv_reply()
            if status != p.STATUS_OK:
                return status, out
            out += data
            if len(data) < chunk_req:        # short packet / ZLP => transfer done
                break
            remaining -= len(data)
        return p.STATUS_OK, out

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
        """Free the device slot (EXEC SCANNER DISCONNECT) and close the channel.
        Sockets passed in by the caller (shared session/grant sockets) are left
        open; only sockets this client created are closed."""
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
            self.tcp.close()
            self.tcp = None
        if getattr(self, "_bc", None):
            if getattr(self, "_owns_bc", True):
                self._bc.close()
            self._bc = None
