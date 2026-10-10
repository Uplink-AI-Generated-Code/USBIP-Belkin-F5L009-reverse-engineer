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
    def connect(self) -> None:
        self.tcp = socket.create_connection((self.host, self.port), self.timeout)
        self.tcp.settimeout(self.timeout)

    def attach(self, port_name: str, device_mac: bytes, client_ip: str,
               window: float = 5.0) -> None:
        """
        Claim a device and open the TCP data channel. CONFIRMED live.

        Sequence: JCP `EXEC SCANNER CONNECT` (cmd=1) creates a job; the device
        advances it to OPEN_WAIT (~0.5s) via its pump; we then TCP-connect and
        the device matches the job by our peer IP -> data channel open. Because
        the OPEN_WAIT window is short and then times out, we retry the TCP
        connect across `window` seconds to catch it. Leaves self.tcp connected.
        """
        import struct
        u = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        u.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        try:
            u.bind(("", self.port))
        except OSError:
            pass
        u.settimeout(1.2)
        u.sendto(p.pack_scanner_connect(port_name, client_ip, device_mac), (self.host, self.port))
        try:
            u.recv(256)   # "OK"
        except socket.timeout:
            pass
        import time
        t0 = time.time()
        while time.time() - t0 < window:
            s = socket.socket()
            s.settimeout(0.5)
            try:
                s.connect((self.host, self.port))
                s.settimeout(0.5)
                try:
                    s.recv(1)      # RST raises; timeout => held open (matched)
                except socket.timeout:
                    pass
                self.tcp = s
                u.close()
                return
            except (ConnectionResetError, ConnectionAbortedError, OSError):
                s.close()
            time.sleep(0.08)
        u.close()
        raise TimeoutError("could not match the OPEN_WAIT window (power-cycle if slot busy)")

    def control_transfer(self, setup: p.Setup, data: bytes = b"") -> bytes:
        """Send a control (category 1) message and read the response.

        The request framing is CONFIRMED; the response parsing assumes the device
        echoes a 24-byte header + data (INFERRED length handling).
        """
        if self.tcp is None:
            raise RuntimeError("not connected")
        msg = p.Message(category=p.CAT_CONTROL, endpoint=0x00, setup=setup, data=data)
        self.tcp.sendall(msg.pack())
        hdr = self._recv_exact(p.HEADER_LEN)
        reply = p.Message.unpack(hdr)
        # INFERRED: a device->host control reply carries wLength bytes of data
        want = setup.wLength if (setup.bmRequestType & 0x80) else 0
        payload = self._recv_exact(want) if want else b""
        return payload

    def _recv_exact(self, n: int) -> bytes:
        assert self.tcp is not None
        buf = b""
        while len(buf) < n:
            chunk = self.tcp.recv(n - len(buf))
            if not chunk:
                raise ConnectionError("peer closed during recv")
            buf += chunk
        return buf

    def close(self) -> None:
        if self.tcp:
            self.tcp.close()
            self.tcp = None
