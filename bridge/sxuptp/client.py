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
    def list_devices(host: str, port: int = p.PORT, timeout: float = 2.0) -> list:
        """GET USB_DEVICE_LIST (cmd=1) -> [{port, device}]. CONFIRMED live."""
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        try:
            s.bind(("", port))   # reply comes to the well-known port
        except OSError:
            pass
        s.settimeout(timeout)
        try:
            s.sendto(p.pack_jcp(p.JCP_USB_DEVICE_LIST, command=1), (host, port))
            try:
                data, _ = s.recvfrom(8192)
            except socket.timeout:
                return []
            return p.parse_device_list(data)
        finally:
            s.close()

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
               window: float = 5.0) -> int | None:
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
        gateway IP the device replies "NG"; a non-gateway client IP is required
        (documented by pybelkusb and confirmed here). `device_mac` is the hub's
        MAC (from discovery). Returns the devId if the announcement was captured,
        else None (use find_dev_id() to sweep). Leaves self.tcp connected and
        records the session for disconnect().
        """
        import time
        self._node = port_name.encode("latin1") if isinstance(port_name, str) else port_name
        self._mac = device_mac
        self._client_ip = client_ip
        self.seq = 0
        self.dev_id: int | None = None

        # capture socket on ('', port) so the devId announcement arrives (on BSD a
        # socket bound to a specific unicast IP would drop a broadcast).
        cap = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        cap.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        cap.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        try:
            cap.bind(("", self.port))
        except OSError:
            cap = None
        if cap:
            cap.settimeout(0.1)

        self._udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self._udp.bind((client_ip, 0))
        self._udp.connect((self.host, self.port))
        self._udp.settimeout(1.5)
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

        # best-effort devId capture (byte 3 of the host's announcement)
        if cap:
            t0 = time.time()
            while time.time() - t0 < 1.0:
                try:
                    d, a = cap.recvfrom(4096)
                except socket.timeout:
                    continue
                if a[0] == self.host and len(d) > 3:
                    self.dev_id = d[3]
                    break
            cap.close()

        # TCP match (catch the OPEN_WAIT window)
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

    def find_dev_id(self, candidates: tuple[int, ...] = (3, 1, 2, 4, 5, 0, 6, 7, 8)) -> int:
        """Probe candidate devIds with GET_DESCRIPTOR(device) until one returns
        STATUS_OK, and remember it. Needed when the announcement was not captured.
        """
        setup = p.Setup.get_descriptor(desc_type=1, desc_index=0, length=18)
        order = ([self.dev_id] if self.dev_id is not None else []) + \
                [c for c in candidates if c != self.dev_id]
        for dv in order:
            status, data = self._control(dv, setup)
            if status == p.STATUS_OK and data[:2] == b"\x12\x01":
                self.dev_id = dv
                return dv
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
        """Free the device slot (EXEC SCANNER DISCONNECT) and close the channel."""
        if getattr(self, "_udp", None):
            try:
                self._udp.send(p.pack_disconnect(self._mac, self._client_ip, self._node))
            except OSError:
                pass
            self._udp.close()
            self._udp = None
        self.close()

    def close(self) -> None:
        if self.tcp:
            self.tcp.close()
            self.tcp = None
