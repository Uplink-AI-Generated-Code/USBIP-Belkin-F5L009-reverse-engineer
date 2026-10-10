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

    # --- session (TCP 19540) --------------------------------------------
    def connect(self) -> None:
        self.tcp = socket.create_connection((self.host, self.port), self.timeout)
        self.tcp.settimeout(self.timeout)

    def attach(self, device_id: int) -> None:
        """Claim a device on the open TCP session.

        INFERRED: the firmware matches conn+0x64 (a device/port id) against a
        pre-allocated job (job+0x28) in state OPEN_WAIT. The exact attach request
        bytes the client sends were not reversed; this sends a best-effort
        control-channel open and is the most likely thing to need fixing against
        hardware.
        """
        raise NotImplementedError(
            "attach(): request format not yet reverse-engineered — needs a "
            "device/capture to confirm the OPEN request body (see "
            "SXUPTP_PROTOCOL.md 'Still open')."
        )

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
