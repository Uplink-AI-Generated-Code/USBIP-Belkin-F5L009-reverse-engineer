"""
USB/IP wire protocol (Linux `usbip`, TCP 3240) — encode/decode.

Two phases on one connection:
  1. OP phase: client sends OP_REQ_DEVLIST / OP_REQ_IMPORT; we reply.
  2. URB phase (after a successful IMPORT): client streams USBIP_CMD_SUBMIT /
     USBIP_CMD_UNLINK; we reply USBIP_RET_SUBMIT / USBIP_RET_UNLINK.

All fields are network byte order (big-endian). References: Linux kernel
Documentation/usb/usbip_protocol.rst and tools/usb/usbip.

This module is pure stdlib and has a self-test: `python3 -m bridge.usbip.protocol`.
"""
from __future__ import annotations

import struct
from dataclasses import dataclass, field

USBIP_VERSION = 0x0111

# OP-phase opcodes
OP_REQ_DEVLIST = 0x8005
OP_REP_DEVLIST = 0x0005
OP_REQ_IMPORT = 0x8003
OP_REP_IMPORT = 0x0003

# URB-phase commands
USBIP_CMD_SUBMIT = 0x00000001
USBIP_RET_SUBMIT = 0x00000003
USBIP_CMD_UNLINK = 0x00000002
USBIP_RET_UNLINK = 0x00000004

# directions (USB/IP)
USBIP_DIR_OUT = 0
USBIP_DIR_IN = 1

# speeds (enum usb_device_speed)
SPEED_LOW = 1
SPEED_FULL = 2
SPEED_HIGH = 3

ST_OK = 0
ST_NA = 1  # OP status: device not available / error

_OP_HDR = struct.Struct(">HHI")                 # version, opcode, status
# udev-style exported device (312 bytes); interfaces follow only in DEVLIST
_DEV = struct.Struct(">256s32sIIIHHHBBBBBB")


@dataclass
class UsbipDevice:
    """One exported device, as USB/IP advertises it."""
    busid: str                          # e.g. "1-1"
    busnum: int
    devnum: int
    speed: int = SPEED_FULL
    id_vendor: int = 0
    id_product: int = 0
    bcd_device: int = 0
    b_device_class: int = 0
    b_device_subclass: int = 0
    b_device_protocol: int = 0
    b_configuration_value: int = 1
    b_num_configurations: int = 1
    b_num_interfaces: int = 1
    # (class, subclass, protocol) per interface, for DEVLIST
    interfaces: list[tuple[int, int, int]] = field(default_factory=list)

    @property
    def devid(self) -> int:
        return ((self.busnum & 0xFFFF) << 16) | (self.devnum & 0xFFFF)

    def pack(self, with_interfaces: bool) -> bytes:
        path = f"/sys/devices/usbip/{self.busid}".encode()[:255]
        out = _DEV.pack(
            path, self.busid.encode()[:31],
            self.busnum, self.devnum, self.speed,
            self.id_vendor, self.id_product, self.bcd_device,
            self.b_device_class, self.b_device_subclass, self.b_device_protocol,
            self.b_configuration_value, self.b_num_configurations,
            self.b_num_interfaces)
        if with_interfaces:
            ifs = self.interfaces or [(self.b_device_class, self.b_device_subclass,
                                       self.b_device_protocol)]
            for cls, sub, proto in ifs[: self.b_num_interfaces or len(ifs)]:
                out += struct.pack(">BBBB", cls, sub, proto, 0)
        return out


# --- OP phase ---------------------------------------------------------------
def pack_op_header(opcode: int, status: int = ST_OK) -> bytes:
    return _OP_HDR.pack(USBIP_VERSION, opcode, status)


def parse_op_header(buf: bytes) -> tuple[int, int, int]:
    """-> (version, opcode, status). Needs the first 8 bytes."""
    return _OP_HDR.unpack_from(buf, 0)


def pack_devlist_reply(devices: list[UsbipDevice]) -> bytes:
    out = pack_op_header(OP_REP_DEVLIST) + struct.pack(">I", len(devices))
    for d in devices:
        out += d.pack(with_interfaces=True)
    return out


def parse_import_request_busid(buf: bytes) -> str:
    """The 32-byte busid follows the 8-byte OP header in an IMPORT request."""
    return buf[8:8 + 32].split(b"\x00", 1)[0].decode("latin1")


def pack_import_reply(device: UsbipDevice | None) -> bytes:
    if device is None:
        return pack_op_header(OP_REP_IMPORT, ST_NA)
    return pack_op_header(OP_REP_IMPORT, ST_OK) + device.pack(with_interfaces=False)


# --- URB phase --------------------------------------------------------------
_BASIC = struct.Struct(">IIIII")        # command, seqnum, devid, direction, ep
_SUBMIT_TAIL = struct.Struct(">IIIII8s")   # flags, buflen, start, npkts, interval, setup
_RET_SUBMIT_TAIL = struct.Struct(">IIIII8s")  # status, actual_len, start, npkts, err, pad
_UNLINK_TAIL = struct.Struct(">I24s")      # (unlink_)seqnum, pad
CMD_HDR_LEN = 48


@dataclass
class CmdSubmit:
    seqnum: int
    devid: int
    direction: int
    ep: int
    transfer_flags: int
    transfer_buffer_length: int
    start_frame: int
    number_of_packets: int
    interval: int
    setup: bytes                        # 8 raw USB SETUP bytes
    transfer_buffer: bytes = b""        # OUT data (IN: empty)

    @property
    def is_in(self) -> bool:
        return self.direction == USBIP_DIR_IN


@dataclass
class CmdUnlink:
    seqnum: int
    devid: int
    unlink_seqnum: int


def parse_command(hdr: bytes) -> tuple[int, object]:
    """Parse a 48-byte command header -> (command, CmdSubmit|CmdUnlink).

    For a CmdSubmit the OUT data (transfer_buffer) is NOT included here; the
    caller reads transfer_buffer_length more bytes when direction==OUT.
    """
    command, seqnum, devid, direction, ep = _BASIC.unpack_from(hdr, 0)
    if command == USBIP_CMD_SUBMIT:
        (flags, blen, start, npkts, interval, setup) = _SUBMIT_TAIL.unpack_from(hdr, 20)
        return command, CmdSubmit(seqnum, devid, direction, ep, flags, blen,
                                  start, npkts, interval, setup)
    if command == USBIP_CMD_UNLINK:
        (useq, _pad) = _UNLINK_TAIL.unpack_from(hdr, 20)
        return command, CmdUnlink(seqnum, devid, useq)
    raise ValueError(f"unknown USB/IP command 0x{command:08x}")


def pack_ret_submit(cmd: CmdSubmit, status: int, data: bytes = b"") -> bytes:
    """Build USBIP_RET_SUBMIT. `data` is the IN payload (ignored for OUT)."""
    actual = len(data) if cmd.is_in else cmd.transfer_buffer_length
    hdr = _BASIC.pack(USBIP_RET_SUBMIT, cmd.seqnum, cmd.devid, cmd.direction, cmd.ep)
    hdr += _RET_SUBMIT_TAIL.pack(status & 0xFFFFFFFF, actual, 0, 0, 0, b"\x00" * 8)
    return hdr + (data if cmd.is_in else b"")


def pack_ret_unlink(cmd: CmdUnlink, status: int) -> bytes:
    hdr = _BASIC.pack(USBIP_RET_UNLINK, cmd.seqnum, cmd.devid, 0, 0)
    hdr += _UNLINK_TAIL.pack(status & 0xFFFFFFFF, b"\x00" * 24)
    return hdr


def _selftest() -> None:
    d = UsbipDevice(busid="1-1", busnum=1, devnum=1, id_vendor=0x0C45,
                    id_product=0x8603, bcd_device=0x0200, b_num_interfaces=1,
                    interfaces=[(3, 1, 1)])
    dl = pack_devlist_reply([d])
    v, op, st = parse_op_header(dl)
    assert (v, op, st) == (USBIP_VERSION, OP_REP_DEVLIST, 0)
    assert struct.unpack_from(">I", dl, 8)[0] == 1
    assert len(dl) == 8 + 4 + _DEV.size + 4      # one device + one interface
    imp = pack_import_reply(d)
    assert len(imp) == 8 + _DEV.size and parse_op_header(imp)[1] == OP_REP_IMPORT
    assert pack_import_reply(None) == pack_op_header(OP_REP_IMPORT, ST_NA)
    assert parse_import_request_busid(pack_op_header(OP_REQ_IMPORT) +
                                      b"1-2".ljust(32, b"\x00")) == "1-2"

    # a control-IN SUBMIT (GET_DESCRIPTOR device), then its RET with 18 bytes
    setup = bytes.fromhex("8006010000001200")      # bmReq,bReq,wValue,wIndex,wLen (LE)
    cmd_bytes = _BASIC.pack(USBIP_CMD_SUBMIT, 7, d.devid, USBIP_DIR_IN, 0) + \
        _SUBMIT_TAIL.pack(0, 18, 0, 0, 0, setup)
    assert len(cmd_bytes) == CMD_HDR_LEN
    c, sub = parse_command(cmd_bytes)
    assert c == USBIP_CMD_SUBMIT and sub.is_in and sub.transfer_buffer_length == 18
    assert sub.setup == setup and sub.seqnum == 7
    desc = bytes.fromhex("120100020000000845 0c0386000201020001".replace(" ", ""))
    ret = pack_ret_submit(sub, 0, desc)
    assert ret[:4] == struct.pack(">I", USBIP_RET_SUBMIT)
    assert struct.unpack_from(">I", ret, 4)[0] == 7            # seqnum echoed
    assert struct.unpack_from(">I", ret, 20)[0] == 0           # status  (@ +20)
    assert struct.unpack_from(">I", ret, 24)[0] == 18          # actual_length (@ +24)
    assert ret[CMD_HDR_LEN:] == desc

    # UNLINK round-trip
    u = _BASIC.pack(USBIP_CMD_UNLINK, 9, d.devid, 0, 0) + _UNLINK_TAIL.pack(7, b"\x00" * 24)
    c2, unl = parse_command(u)
    assert c2 == USBIP_CMD_UNLINK and unl.unlink_seqnum == 7
    assert struct.unpack_from(">I", pack_ret_unlink(unl, 0), 0)[0] == USBIP_RET_UNLINK
    print("usbip protocol selftest: OK")


if __name__ == "__main__":
    _selftest()
