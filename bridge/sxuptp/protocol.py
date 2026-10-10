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

# --- discovery / ALC datagram (UDP 19540) -------------------------------
# CONFIRMED header: {u16 length, u16 rule}, big-endian. Rule is a 2-char tag.
RULE_BS = 0x4253  # "BS" — broadcast search / discovery request (CONFIRMED tag)
RULE_BB = 0x4242  # "BB" — discovery/announce variant (CONFIRMED tag)

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
    """USB control SETUP packet (8 bytes). CONFIRMED layout at header +0x0C."""
    bmRequestType: int
    bRequest: int
    wValue: int
    wIndex: int
    wLength: int

    def pack(self) -> bytes:
        # bm/b are bytes; wValue/wIndex/wLength big-endian u16 (per firmware ntohs)
        return struct.pack(">BBHHH", self.bmRequestType, self.bRequest,
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
    message the SETUP packet occupies 0x0C..0x13.
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
            hdr[0x0C:0x14] = self.setup.pack()
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
        if category == CAT_CONTROL and len(buf) >= 0x14:
            m.setup = Setup(*struct.unpack_from(">BBHHH", buf, 0x0C))
        m.data = buf[HEADER_LEN:]
        return m


def pack_discovery(rule: int = RULE_BS, body: bytes = b"\x00\x00\x00\x00") -> bytes:
    """
    Build a discovery datagram. CONFIRMED header {u16 length, u16 rule}; the
    device validated length==4 for the "BS" request. The body contents are
    INFERRED (the client->device search payload was not reversed).
    """
    return struct.pack(">HH", len(body), rule) + body


def _selftest() -> None:
    # round-trip a control GET_DESCRIPTOR(device) message
    s = Setup.get_descriptor(desc_type=1, desc_index=0, length=18)
    assert s.pack() == bytes.fromhex("8006" + "0100" + "0000" + "0012"), s.pack().hex()
    m = Message(category=CAT_CONTROL, endpoint=0x00, setup=s)
    raw = m.pack()
    assert len(raw) == HEADER_LEN, len(raw)
    assert struct.unpack_from(">H", raw, 0)[0] == 0x0001  # dir=request, cat=control
    assert raw[0x0C:0x14] == s.pack()
    back = Message.unpack(raw)
    assert back.category == CAT_CONTROL and back.setup == s, back
    # type model
    assert make_type(CAT_ISOC, DIR_RESPONSE) == 0x8004
    # discovery framing
    d = pack_discovery()
    assert d[:4] == bytes.fromhex("0004" "4253"), d[:4].hex()
    print("protocol selftest: OK")


if __name__ == "__main__":
    _selftest()
