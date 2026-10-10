"""
SXUPTP wire protocol encoding/decoding.

Derived by static RE of the F5L009/SX-2000U2 firmware (see
../SXUPTP_PROTOCOL.md). Fields marked CONFIRMED were read directly from the
device's parser; fields marked INFERRED are best-effort and should be validated
against a live device.

All multi-byte integers are big-endian (the firmware uses ntohs/ntohl).
"""
from __future__ import annotations

import struct
from dataclasses import dataclass, field

PORT = 19540  # CONFIRMED: TCP + UDP (IANA "sxuptp"), firmware constant 0x4C54

# --- UDP control protocol (port 19540) ----------------------------------
# CONFIRMED against hardware: request starts with a big-endian u16 command.
# Reply framing: {u16 cmd_echo, u16 status, u16 _, u16 length, body[length]}.
# Commands 0,5,6,7,8 -> "ERR(NOT SUPPORTED)"; 1,2,3,4 recognized (bodies TBD);
# 4 is special. The valid request bodies for 1-4 are not yet known.
#
# NOTE: the "BS"/"BB" ASCII tags from the SXUP_ALC code path are NOT this
# protocol; live testing showed UDP 19540 uses numeric commands.

def unpack_udp_reply(buf: bytes):
    """Parse a UDP control reply header -> (command, status, length, body)."""
    if len(buf) < 8:
        raise ValueError("short UDP reply")
    cmd, status, _resv, length = struct.unpack_from(">HHHH", buf, 0)
    return cmd, status, length, buf[8:8 + length]


def pack_udp_command(command: int, body: bytes = b"") -> bytes:
    """Build a UDP control request: u16 command + body (body format TBD)."""
    return struct.pack(">H", command) + body


# JCP commands (UDP 19540), CONFIRMED against hardware:
JCP_IDENTIFY = 4          # with subcommand 0x9506 -> device identity/discovery
JCP_IDENTIFY_SUB = 0x9506

# Named JCP commands (request = u16 cmd, u16 sub, "NAME\0", body). The cmd value
# selects a response class: 1 and 3 both observed valid. CONFIRMED live.
JCP_CMD = 3               # class used by ENUM/SCANNER commands
# USB/scanner verbs (from GET CONTEXT, live):
JCP_SCANNER_CONNECT = "EXEC SCANNER CONNECT"
JCP_SCANNER_DISCONNECT = "EXEC SCANNER DISCONNECT"
JCP_USB_DEVICE_LIST = "GET USB_DEVICE_LIST"
JCP_USB_PORT_NAME = "GET USB_PORT_NAME"
JCP_SCANNER_STATUS = "GET SCANNER_STATUS"   # returns raw USB descriptors (read-only)


def pack_jcp(name: str, body: bytes = b"", command: int = JCP_CMD, sub: int = 0) -> bytes:
    """Build a named JCP request (CONFIRMED framing)."""
    return struct.pack(">HH", command, sub) + name.encode("latin1") + b"\x00" + body


def parse_device_list(buf: bytes) -> list[dict]:
    """
    Parse a `GET USB_DEVICE_LIST` reply (cmd=1). CONFIRMED live: 8-byte header
    {cmd,status,_,len}, then a count byte, then entries each beginning with the
    ASCII port name `devNN` followed by the device product string.
    Returns [{port, device}]. (Only the human-readable fields are decoded; the
    binary attribute bytes between entries are left for later.)
    """
    import re
    out = []
    for m in re.finditer(rb"dev0[0-9A-Fa-f]", buf):
        o = m.start()
        port = buf[o:o + 6].rstrip(b"\x00").decode("latin1")
        end = buf.find(b"\x00", o + 6)
        device = buf[o + 6:end].decode("latin1") if end != -1 else ""
        # tail after the name's NUL: ip[4] flags[2] vid[2 BE] pid[2 BE] serial...
        t = end + 1
        vid = int.from_bytes(buf[t + 6:t + 8], "big") if end != -1 and len(buf) >= t + 8 else 0
        pid = int.from_bytes(buf[t + 8:t + 10], "big") if end != -1 and len(buf) >= t + 10 else 0
        serial = ""
        if end != -1:
            s_end = buf.find(b"\x00", t + 10)
            if s_end != -1:
                serial = buf[t + 10:s_end].decode("latin1", "replace")
        out.append({"port": port, "device": device, "vid": vid, "pid": pid,
                    "serial": serial})
    return out


def pack_scanner_connect(port_name: str, client_ip: str, device_mac: bytes,
                         command: int = 1) -> bytes:
    """
    EXEC SCANNER CONNECT request. CONFIRMED live: returns "OK" and creates a job.

    - command=1 selects the ACTION path in the EXEC trampoline (cmd=3 is the
      field-copy/response path and no-ops the action).
    - body = {flag=1, mac_len=6, DEVICE_MAC(6), client_IP(4), port_name "devNN"}.
      The MAC must be the DEVICE's own MAC (a target-selector pre-check,
      sub_002FA0A0); port_name is a `devNN` from GET USB_DEVICE_LIST.

    NOTE: this creates a job (OPEN_WAIT) but the OPEN_WAIT->active handshake
    (UDP grant callback + TCP match) is not yet completed by this client, and a
    created-but-unattached job stays reserved (NG to new CONNECTs) until it times
    out or the device is power-cycled. See ../SXUPTP_PROTOCOL.md.
    """
    import socket as _s
    body = bytes([1, len(device_mac)]) + device_mac + _s.inet_aton(client_ip) + \
        port_name.encode("latin1") + b"\x00"
    return pack_jcp(JCP_SCANNER_CONNECT, body, command=command)


def _connect_body(device_mac: bytes, client_ip: str, node: bytes) -> bytes:
    import socket as _s
    return (b"EXEC SCANNER CONNECT:" + b"\x01\x06" + device_mac +
            _s.inet_aton(client_ip) + node + b"\x00LT\x00")


def pack_connect_init(device_mac: bytes, client_ip: str, node: bytes) -> bytes:
    """First CONNECT packet (cmd 0x0001) — creates the job. CONFIRMED live.
    Byte-identical to the official driver / pybelkusb; reply ends in "OK"."""
    return (b"\x00\x01\x00\x01" + _connect_body(device_mac, client_ip, node) +
            b"\x00" * 40 + b"\x02" + b"\x00" * 423)


def pack_connect_commit(device_mac: bytes, client_ip: str, node: bytes) -> bytes:
    """Second CONNECT packet (cmd 0x0003) — commits the job and triggers the
    devId announcement. CONFIRMED live. Note the short `03 02` trailer."""
    return (b"\x00\x03\x00\x01" + _connect_body(device_mac, client_ip, node) +
            b"\x00" * 39 + b"\x03\x02" + b"\x00")


def pack_disconnect(device_mac: bytes, client_ip: str, node: bytes) -> bytes:
    """EXEC SCANNER DISCONNECT (cmd 0x0064) — frees the slot. CONFIRMED live."""
    import socket as _s
    return (b"\x00\x01\x00\x64" + b"EXEC SCANNER DISCONNECT:" + b"\x01\x06" +
            device_mac + _s.inet_aton(client_ip) + node + b"\x00" +
            b"\x00" * 42 + b"\x02" + b"\x00" * 423)


def pack_identify() -> bytes:
    """Discovery/identity request (CONFIRMED live): cmd=4, subcmd=0x9506."""
    return struct.pack(">HH", JCP_IDENTIFY, JCP_IDENTIFY_SUB)


def _cstr(buf: bytes, off: int) -> str:
    end = off
    while end < len(buf) and 0x20 <= buf[end] < 0x7F:
        end += 1
    return buf[off:end].decode("latin1")


def parse_identity(buf: bytes) -> dict:
    """
    Parse a cmd4/0x9506 identity reply. Field offsets CONFIRMED byte-for-byte
    against the live F5L009 (166-byte reply).
    """
    if len(buf) < 0xA6 or struct.unpack_from(">H", buf, 2)[0] != JCP_IDENTIFY_SUB:
        raise ValueError("not a JCP identity reply")
    return {
        "model": _cstr(buf, 0x24),
        "mac": buf[0x38:0x3E].hex(":"),
        "ip": ".".join(str(x) for x in buf[0x42:0x46]),
        "proto_version": _cstr(buf, 0x48),      # e.g. "Ver 2.2.0"
        "usb_device": _cstr(buf, 0x54),         # attached USB device name
        "hostname": _cstr(buf, 0x74),
        "firmware": _cstr(buf, 0x84),
    }

# --- data channel (TCP 19540) message type ------------------------------
# CONFIRMED: type u16 = (dir << 8) | category
DIR_REQUEST = 0x00   # host -> device
DIR_RESPONSE = 0x80  # device -> host / data-IN

CAT_CONTROL = 1      # CONFIRMED: body carries a USB SETUP packet at +0x0C
CAT_DATA2 = 2        # INFERRED: bulk/interrupt data transfer
CAT_DATA3 = 3        # INFERRED: bulk/interrupt data transfer (other direction)
CAT_ISOC = 4         # INFERRED: isochronous (6 extra header bytes)

HEADER_LEN = 0x18    # CONFIRMED: device copies a 24-byte header off the stream

# endpoint byte (+0x07): low nibble = EP number, bit7 = direction (IN) — CONFIRMED
EP_DIR_IN = 0x80


def make_type(category: int, dir_bit: int = DIR_REQUEST) -> int:
    return ((dir_bit & 0xFF) << 8) | (category & 0xFF)


@dataclass
class Setup:
    """
    SXUPTP control SETUP — a **10-byte** structure at header +0x0C. CONFIRMED by
    the parser (`sub_0030481C` @0x304CA4): bmRequestType, bRequest, wValue (u16
    BE), wIndex (u16 BE), **wLength (u32 BE)**. Note wLength is 32-bit here, not
    the standard USB 16-bit.
    """
    bmRequestType: int
    bRequest: int
    wValue: int
    wIndex: int
    wLength: int

    def pack(self) -> bytes:
        return struct.pack(">BBHHI", self.bmRequestType, self.bRequest,
                           self.wValue, self.wIndex, self.wLength)

    @classmethod
    def get_descriptor(cls, desc_type: int, desc_index: int, length: int,
                       lang_id: int = 0) -> "Setup":
        # standard GET_DESCRIPTOR (device->host, standard, device)
        return cls(bmRequestType=0x80, bRequest=0x06,
                   wValue=(desc_type << 8) | desc_index,
                   wIndex=lang_id, wLength=length)


@dataclass
class Message:
    """
    One SXUPTP data-channel message.

    The common header (bytes 0x00..0x09) is CONFIRMED by field offset; bytes
    0x0A..0x0B and 0x14..0x17 are reserved/unknown (INFERRED zero). For a control
    message the 10-byte SETUP occupies 0x0C..0x15 (wLength is u32 BE).
    """
    category: int
    endpoint: int = 0
    dir_bit: int = DIR_REQUEST
    tag: int = 0                      # +0x02, INFERRED (transfer handle)
    field2: int = 0                   # +0x04, INFERRED
    flags: int = 0                    # +0x06, INFERRED
    field3: int = 0                   # +0x08, INFERRED
    setup: Setup | None = None        # control only
    data: bytes = b""                 # OUT payload (data categories)

    def pack(self) -> bytes:
        hdr = bytearray(HEADER_LEN)
        struct.pack_into(">H", hdr, 0x00, make_type(self.category, self.dir_bit))
        struct.pack_into(">H", hdr, 0x02, self.tag & 0xFFFF)
        struct.pack_into(">H", hdr, 0x04, self.field2 & 0xFFFF)
        hdr[0x06] = self.flags & 0xFF
        hdr[0x07] = self.endpoint & 0xFF
        struct.pack_into(">H", hdr, 0x08, self.field3 & 0xFFFF)
        if self.category == CAT_CONTROL:
            if self.setup is None:
                raise ValueError("control message requires a SETUP packet")
            hdr[0x0C:0x16] = self.setup.pack()
        return bytes(hdr) + self.data

    @classmethod
    def unpack(cls, buf: bytes) -> "Message":
        if len(buf) < HEADER_LEN:
            raise ValueError(f"short message: {len(buf)} < {HEADER_LEN}")
        t = struct.unpack_from(">H", buf, 0x00)[0]
        dir_bit = (t >> 8) & 0xFF
        category = t & 0xFF
        m = cls(category=category, dir_bit=dir_bit,
                tag=struct.unpack_from(">H", buf, 0x02)[0],
                field2=struct.unpack_from(">H", buf, 0x04)[0],
                flags=buf[0x06], endpoint=buf[0x07],
                field3=struct.unpack_from(">H", buf, 0x08)[0])
        if category == CAT_CONTROL and len(buf) >= 0x16:
            m.setup = Setup(*struct.unpack_from(">BBHHI", buf, 0x0C))
        m.data = buf[HEADER_LEN:]
        return m


def _selftest() -> None:
    # round-trip a control GET_DESCRIPTOR(device) message
    s = Setup.get_descriptor(desc_type=1, desc_index=0, length=18)
    assert s.pack() == bytes.fromhex("8006" + "0100" + "0000" + "00000012"), s.pack().hex()
    m = Message(category=CAT_CONTROL, endpoint=0x00, setup=s)
    raw = m.pack()
    assert len(raw) == HEADER_LEN, len(raw)
    assert struct.unpack_from(">H", raw, 0)[0] == 0x0001  # dir=request, cat=control
    assert raw[0x0C:0x16] == s.pack()
    back = Message.unpack(raw)
    assert back.category == CAT_CONTROL and back.setup == s, back
    # type model
    assert make_type(CAT_ISOC, DIR_RESPONSE) == 0x8004
    # UDP control reply parse (shape confirmed against hardware)
    sample = bytes.fromhex("0000000000000018") + b"ERR(NOT SUPPORTED)\x00" + b"\x00"*7
    cmd, status, length, body = unpack_udp_reply(sample)
    assert cmd == 0 and length == 0x18 and body.startswith(b"ERR(NOT SUPPORTED)"), (cmd, length, body)
    assert pack_udp_command(4) == bytes.fromhex("0004")
    assert pack_identify() == bytes.fromhex("00049506")
    # identity reply parse vs the captured live bytes
    ident = bytes.fromhex(
        "000295060000000000000000000000000000000000000000000000000000000000000000"
        "4e6574776f726b20555342204875620000000000001cdf11cb6d00000000c0a8020300005665"
        "7220322e322e30008081534f4e69582053492047616d696e67204b6579626f61726400000000"
        "00000000424b3131434236440000000000000000312e322e3000000000000000000000000000"
        "00000000000000000000000000000000")
    info = parse_identity(ident)
    assert info["mac"] == "00:1c:df:11:cb:6d" and info["ip"] == "192.168.2.3", info
    assert info["usb_device"] == "SONiX SI Gaming Keyboard" and info["firmware"] == "1.2.0", info

    # control-IN request bytes vs the ground-truth driver capture (string desc #2)
    assert control_read(dev_id=5, bm_request_type=0x80, b_request=0x06,
                        w_value=0x0302, w_index=0x0409, length=0xFF, seq=6).hex() == \
        "000100060002050002010008800603020409000000ff"
    # control-IN reply parse vs the live device descriptor from 192.168.2.3
    status, dd = parse_control_reply(
        bytes.fromhex("000100040000000000121201000200000008450c0386000201020001"))
    assert status == STATUS_OK and len(dd) == 18 and dd[:2] == b"\x12\x01", (status, dd.hex())
    assert (dd[8] | dd[9] << 8, dd[10] | dd[11] << 8) == (0x0C45, 0x8603), dd.hex()
    # a failed transfer carries status 0xffff and no data
    status2, dd2 = parse_control_reply(bytes.fromhex("00010001ffff00000000"))
    assert status2 == STATUS_FAIL and dd2 == b"", (status2, dd2)
    print("protocol selftest: OK")


# ============================================================================
# Data-channel transfers — CONFIRMED live (192.168.2.3) + daeken/pybelkusb capture
# ============================================================================
# A control request is 22 bytes on the wire:
#   [0:2] type   0001 ctrl-read / 8001 ctrl-write  (0x80 = host->device data)
#   [2:4] seq    incrementing per transfer on the TCP channel
#   [4:6] 0x0002 (control READ) / 0x0003 (control WRITE) in the real driver.
#               The firmware parser only STORES this half-word and never reads
#               it; the reply overwrites the slot with the status. It is cosmetic
#               (we send it to match the driver), not a gating field.
#   [6:8] devId<<8   [8:10] 0x0201   [10:12] 0x0008
#               devId is the only one of these the firmware acts on: byte [6] is
#               the USB device address, looked up by sub_0031F368; byte [7] is
#               the endpoint. 0x0201 and 0x0008 are stored-and-ignored constants.
#   [12] bmRequestType [13] bRequest [14:16] wValue [16:18] wIndex
#   [18:20] 0x0000 [20:22] wLength
# The reply is a 10-byte header (see parse_control_reply) + `size` data bytes.
# devId is the device's transfer handle. It is NOT the devNN index and need not
# equal it: a CONNECT on dev01 yielded devId=4 live. It is read from byte 3 of
# the connect announcement when that arrives, else found by a short sweep.
# See ../SXUPTP_PROTOCOL.md for the full connect sequence.

def control_read(dev_id: int, bm_request_type: int, b_request: int,
                 w_value: int, w_index: int, length: int, seq: int = 0) -> bytes:
    """Build a control-IN (device->host) message.

    Offset 0x04 is set to 0x0002 to match the official driver's control-read
    bytes (control writes use 0x0003). NOTE on causation: the firmware message
    parser (sub_0030481C) only *stores* this half-word (strh [r6,#4]) and never
    reads it back; the reply reuses the same slot for the completion status
    (0x0000 OK / 0xffff fail). So this value is cosmetic/faithful, NOT what
    unblocks a transfer. The real device selector is the devId byte at 0x06
    (USB device-address lookup, sub_0031F368) — a wrong devId is what returns
    0xffff. We still send 0x0002 to stay byte-identical to the real driver.
    """
    return struct.pack(">HHHHHH BBHHHH",
                       0x0001, seq & 0xFFFF, 0x0002, (dev_id & 0xFF) << 8,
                       0x0201, 0x0008,
                       bm_request_type, b_request, w_value, w_index, 0x0000, length)


def control_write(dev_id: int, bm_request_type: int, b_request: int,
                  w_value: int, w_index: int, payload: bytes = b"", seq: int = 0) -> bytes:
    """Build a control-OUT (host->device) message (prefix 0x8001, field0 0x0003)."""
    hdr = struct.pack(">HHHHHH BBHHHH",
                      0x8001, seq & 0xFFFF, 0x0003, (dev_id & 0xFF) << 8,
                      0x0201, 0x0008,
                      bm_request_type, b_request, w_value, w_index, 0x0000, len(payload))
    return hdr + payload


def bulk_write(dev_id: int, endpoint: int, payload: bytes, seq: int = 0) -> bytes:
    """Bulk-OUT: prefix 0x8003, body >HHBBHLH {0003,(devId<<8)|02,ep,01,8040,0,len}."""
    hdr = struct.pack(">HHHBBHLH",
                      0x8003, seq & 0xFFFF, 0x0003 if False else ((dev_id & 0xFF) << 8) | 0x02,
                      endpoint & 0xFF, 0x01, 0x8040, 0, len(payload))
    return hdr + payload


def bulk_read(dev_id: int, endpoint: int, length: int, seq: int = 0) -> bytes:
    """Bulk-IN: prefix 0x0003, direction field (devId<<8)|0x83. Reply: data after 10 bytes."""
    return struct.pack(">HHHBBHLH",
                       0x0003, seq & 0xFFFF, ((dev_id & 0xFF) << 8) | 0x83,
                       endpoint & 0xFF, 0x01, 0x8040, 0, length)


# A data-channel transfer reply has a 10-byte header, then `size` bytes of data.
# CONFIRMED live (192.168.2.3) and against daeken's driver captures:
#   [0:2] type (echoes request)   [2:4] seq (echoes request)
#   [4:6] status  (0x0000 = OK, 0xffff = failed)
#   [6:8] reserved (0x0000)       [8:10] size  (bytes of data that follow)
CTRL_REPLY_HEADER = 10
STATUS_OK = 0x0000
STATUS_FAIL = 0xFFFF


def parse_control_reply(buf: bytes) -> tuple[int, bytes]:
    """Parse a control/bulk transfer reply -> (status, data). CONFIRMED live.

    A control-IN GET_DESCRIPTOR(device) reply observed on hardware:
        0001 0004 0000 0000 0012 | 1201000200000008450c0386000201020001
        type seq  stat _    size | <18-byte USB device descriptor>
    status 0x0000 = OK (data follows); 0xffff = the transfer failed (no data).
    """
    if len(buf) < CTRL_REPLY_HEADER:
        raise ValueError(f"short reply: {len(buf)} < {CTRL_REPLY_HEADER}")
    status = struct.unpack_from(">H", buf, 4)[0]
    size = struct.unpack_from(">H", buf, 8)[0]
    data = buf[CTRL_REPLY_HEADER:CTRL_REPLY_HEADER + size]
    return status, data


if __name__ == "__main__":
    _selftest()
