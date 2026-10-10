"""
Minimal USB/IP client — validates the exporter end-to-end without a Linux kernel.

It does what `usbip attach` does at the wire level: OP_REQ_IMPORT a busid, then
USBIP_CMD_SUBMIT a control GET_DESCRIPTOR(device), and print the returned USB
device descriptor. Point it at a running `bridge.usbip.server`.

Usage:
    python3 -m bridge.usbip.testclient [HOST] [BUSID]
        HOST  defaults to 127.0.0.1 (the machine running the server)
        BUSID defaults to 1-1
"""
from __future__ import annotations

import socket
import struct
import sys

from . import protocol as u


def fetch_descriptor(host: str, busid: str, port: int = 3240) -> int:
    s = socket.create_connection((host, port), timeout=10)
    try:
        # OP_REQ_IMPORT
        s.sendall(u.pack_op_header(u.OP_REQ_IMPORT) + busid.encode().ljust(32, b"\x00"))
        _ver, op, st = u.parse_op_header(_recvall(s, 8))
        print(f"IMPORT reply: op=0x{op:04x} status={st}")
        if st != u.ST_OK:
            print("  import failed (busid not found or attach error)")
            return 1
        dev = _recvall(s, 312)
        busnum, devnum = struct.unpack_from(">II", dev, 256 + 32)
        vid, pid = struct.unpack_from(">HH", dev, 256 + 32 + 12)
        print(f"  imported busid={busid}  {vid:04x}:{pid:04x}")

        # USBIP_CMD_SUBMIT: control IN GET_DESCRIPTOR(device), 18 bytes
        setup = struct.pack("<BBHHH", 0x80, 0x06, 0x0100, 0x0000, 18)
        cmd = struct.pack(">IIIII", u.USBIP_CMD_SUBMIT, 1, (busnum << 16) | devnum,
                          u.USBIP_DIR_IN, 0)
        cmd += struct.pack(">IIIII8s", 0, 18, 0, 0, 0, setup)
        s.sendall(cmd)
        rh = _recvall(s, u.CMD_HDR_LEN)
        seq, status, actual = (struct.unpack_from(">I", rh, 4)[0],
                               struct.unpack_from(">I", rh, 20)[0],
                               struct.unpack_from(">I", rh, 24)[0])
        data = _recvall(s, actual) if actual else b""
        print(f"RET_SUBMIT: seq={seq} status={status} actual_length={actual}")
        print(f"  descriptor: {data.hex()}")
        if data[:2] == b"\x12\x01":
            dv, dp = data[8] | data[9] << 8, data[10] | data[11] << 8
            print(f"  >>> DEVICE DESCRIPTOR OK  {dv:04x}:{dp:04x}")
            return 0
        return 1
    finally:
        s.close()


def _recvall(s: socket.socket, n: int) -> bytes:
    buf = b""
    while len(buf) < n:
        chunk = s.recv(n - len(buf))
        if not chunk:
            raise ConnectionError("server closed")
        buf += chunk
    return buf


if __name__ == "__main__":
    host = sys.argv[1] if len(sys.argv) > 1 else "127.0.0.1"
    busid = sys.argv[2] if len(sys.argv) > 2 else "1-1"
    raise SystemExit(fetch_descriptor(host, busid))
