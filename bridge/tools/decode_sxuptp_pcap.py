#!/usr/bin/env python3
"""
Decode a packet capture of SXUPTP traffic (UDP+TCP port 19540) using the
reverse-engineered framing. Built to analyze a capture of the OFFICIAL Silex/
Belkin driver (or Control Center) driving the keyboard, so we can see the exact
messages that ACTIVATE interrupt (HID) polling and carry key reports — the one
piece static RE hasn't cracked (see ../SXUPTP_PROTOCOL.md, interrupt section).

Usage:
    python3 bridge/tools/decode_sxuptp_pcap.py capture.pcap
    python3 bridge/tools/decode_sxuptp_pcap.py capture.pcap --hub 192.168.2.3

Capture it with (classic pcap, not pcapng):
    tcpdump -i <iface> -s0 -w capture.pcap 'port 19540'
or in Wireshark save As -> "Wireshark/tcpdump/... - pcap".

Pure stdlib. Handles classic pcap (LE/BE, us/ns) with Ethernet, raw-IP, or BSD
loopback (null) link layers. TCP is decoded per-segment (no reassembly) which is
enough to see message headers; a flag dumps full hex for anything unrecognized.
"""
from __future__ import annotations

import struct
import sys

PORT = 19540


# ---- pcap container -------------------------------------------------------
def _read_pcapng(blob):
    """Parse pcapng -> (linktype, [packet_bytes]). Handles SHB/IDB/EPB/SPB."""
    en = "<"
    linktype = 1
    frames = []
    off = 0
    snaplen = 0x40000
    while off + 12 <= len(blob):
        btype = struct.unpack_from("<I", blob, off)[0]
        if btype == 0x0A0D0D0A:                      # Section Header Block
            bom = struct.unpack_from("<I", blob, off + 8)[0]
            en = "<" if bom == 0x1A2B3C4D else ">"
        blen = struct.unpack_from(en + "I", blob, off + 4)[0]
        if blen < 12 or off + blen > len(blob):
            break
        if btype == 0x00000001:                      # Interface Description Block
            linktype = struct.unpack_from(en + "H", blob, off + 8)[0]
            snaplen = struct.unpack_from(en + "I", blob, off + 12)[0]
        elif btype == 0x00000006:                    # Enhanced Packet Block
            caplen = struct.unpack_from(en + "I", blob, off + 20)[0]
            frames.append(blob[off + 28:off + 28 + caplen])
        elif btype == 0x00000003:                    # Simple Packet Block
            origlen = struct.unpack_from(en + "I", blob, off + 8)[0]
            frames.append(blob[off + 12:off + 12 + min(origlen, snaplen)])
        off += blen
    return linktype, frames


def read_pcap_with_linktype(path):
    with open(path, "rb") as f:
        blob = f.read()
    magic = blob[:4]
    if magic == b"\x0a\x0d\x0d\x0a":
        return _read_pcapng(blob)
    if magic in (b"\xa1\xb2\xc3\xd4", b"\xa1\xb2\x3c\x4d"):
        en = ">"
    elif magic in (b"\xd4\xc3\xb2\xa1", b"\x4d\x3c\xb2\xa1"):
        en = "<"
    else:
        sys.exit(f"Not a pcap/pcapng file (magic {magic.hex()}).")
    linktype = struct.unpack_from(en + "I", blob, 20)[0]
    frames = []
    off = 24
    while off + 16 <= len(blob):
        _ts, _tu, incl, _orig = struct.unpack_from(en + "IIII", blob, off)
        off += 16
        frames.append(blob[off:off + incl])
        off += incl
    return linktype, frames


# ---- L2/L3/L4 -------------------------------------------------------------
def ip_payload(frame, linktype):
    """Return (proto, src, dst, l4payload) or None."""
    if linktype == 1:            # Ethernet
        if len(frame) < 14:
            return None
        eth = struct.unpack_from(">H", frame, 12)[0]
        if eth != 0x0800:
            return None
        ip = frame[14:]
    elif linktype in (0, 108):   # BSD/OpenBSD loopback (null): 4-byte family
        if len(frame) < 4:
            return None
        ip = frame[4:]
    elif linktype == 101:        # raw IP
        ip = frame
    else:
        ip = frame               # best effort
    if len(ip) < 20 or (ip[0] >> 4) != 4:
        return None
    ihl = (ip[0] & 0xF) * 4
    proto = ip[9]
    src = ".".join(str(b) for b in ip[12:16])
    dst = ".".join(str(b) for b in ip[16:20])
    l4 = ip[ihl:]
    return proto, src, dst, l4


def l4_ports_payload(proto, l4):
    if proto == 17:              # UDP
        if len(l4) < 8:
            return None
        sp, dp, length = struct.unpack_from(">HHH", l4, 0)
        return sp, dp, l4[8:8 + max(0, length - 8)] or l4[8:]
    if proto == 6:               # TCP
        if len(l4) < 20:
            return None
        sp, dp = struct.unpack_from(">HH", l4, 0)
        doff = (l4[12] >> 4) * 4
        return sp, dp, l4[doff:]
    return None


# ---- SXUPTP decode --------------------------------------------------------
TYPE_NAME = {0x0001: "CTRL-IN(req)", 0x8001: "CTRL-OUT(req)",
             0x0003: "BULK/INT-IN(req)", 0x8003: "BULK/INT-OUT(req)",
             0x0002: "type0002", 0x8002: "type8002", 0x0004: "ISOC?",
             0x8004: "ISOC?-OUT"}


def decode_udp(payload):
    if payload[:2] == b"\x00\x04" and payload[2:4] == b"\x95\x06":
        return "JCP identify/discovery"
    # JCP: cmd(2) sub(2) then often an ASCII verb
    try:
        txt = payload[4:40].split(b"\x00", 1)[0].decode("ascii")
    except Exception:
        txt = ""
    if txt.isprintable() and txt.strip():
        return f"JCP cmd={payload[:2].hex()} '{txt}'"
    return f"UDP {len(payload)}B {payload[:16].hex()}"


def decode_tcp(payload, to_hub):
    """Decode a data-channel segment. Direction disambiguates request vs reply
    (they share the type field). to_hub=True => client->device request."""
    if len(payload) < 4:
        return f"short {payload.hex()}"
    t, seq = struct.unpack_from(">HH", payload, 0)
    name = TYPE_NAME.get(t, f"type{t:04x}")
    out = [f"{name} seq={seq}"]
    if not to_hub:
        # device -> client: a reply (10-byte header + data) OR a pushed message
        if len(payload) >= 10:
            status, size = struct.unpack_from(">H", payload, 4)[0], struct.unpack_from(">H", payload, 8)[0]
            data = payload[10:10 + size]
            out.append(f"REPLY status={status:#06x} size={size} data={data.hex()}"
                       + ("  <-- HID REPORT? (size 1-8, status OK)"
                          if 0 < size <= 8 and status == 0 else ""))
        else:
            out.append("PUSH " + payload.hex())
        return "  ".join(out)
    # client -> device: a request
    if t in (0x0001, 0x8001) and len(payload) >= 22:       # control
        devid = payload[6]
        bm, breq = payload[12], payload[13]
        wv, wi = struct.unpack_from(">HH", payload, 14)
        out.append(f"dev={devid} f04={payload[4]:02x}{payload[5]:02x} "
                   f"SETUP bm={bm:02x} req={breq:02x} val={wv:04x} idx={wi:04x}")
    elif t in (0x0003, 0x8003) and len(payload) >= 18:     # bulk/interrupt
        devid = payload[6]
        epaddr = payload[7]
        ln = struct.unpack_from(">I", payload, 14)[0]
        out.append(f"dev={devid} ep={epaddr:#04x} f04={payload[4]:02x}{payload[5]:02x} len={ln}"
                   + ("  <-- INTERRUPT EP" if epaddr in (0x81, 0x82, 0x83) else ""))
    else:
        out.append("UNRECOGNIZED REQ " + payload[:24].hex())
    return "  ".join(out)


def main(argv):
    if not argv or argv[0] in ("-h", "--help"):
        print(__doc__); return 0
    path = argv[0]
    hub = None
    if "--hub" in argv:
        hub = argv[argv.index("--hub") + 1]
    linktype, frames = read_pcap_with_linktype(path)
    print(f"# {path}: {len(frames)} frames, linktype={linktype}\n")
    n = 0
    for frame in frames:
        ipp = ip_payload(frame, linktype)
        if not ipp:
            continue
        proto, src, dst, l4 = ipp
        pp = l4_ports_payload(proto, l4)
        if not pp:
            continue
        sp, dp, pl = pp
        if PORT not in (sp, dp) or not pl:
            continue
        if hub and hub not in (src, dst):
            continue
        n += 1
        pr = "UDP" if proto == 17 else "TCP"
        arrow = f"{src}:{sp} -> {dst}:{dp}"
        tohub = (dst == hub) if hub else (dp == PORT)
        dec = decode_udp(pl) if proto == 17 else decode_tcp(pl, tohub)
        dirc = "C>D" if tohub else "D>C"
        print(f"[{n:4d}] {pr} {dirc} {arrow}\n       {dec}")
    print(f"\n# {n} SXUPTP packets on :{PORT}")
    print("# Look for: a message to an interrupt EP (0x81/0x82) the DRIVER sends that")
    print("#   we don't (the poll 'arm'), and D>C replies with size=8 (HID reports).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
