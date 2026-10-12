#!/usr/bin/env python3
"""Shared helpers for the direct-SXUPTP mass-storage tests.

These talk to the flash drive STRAIGHT through the bridge's SxuptpClient --
no vhci, no usbip, no Linux block layer, no filesystem, no page cache. That
removes every Linux-side variable so a failure can only come from the bridge
protocol code or the hub/device itself.

Bulk-Only-Transport (BOT) recap, so the code below reads cleanly:
  WRITE: send a 31-byte CBW (cmd wrapper) -> send the data -> read a 13-byte CSW
  READ:  send a 31-byte CBW             -> read the data -> read a 13-byte CSW
A CSW is "USBS" + tag + residue + status byte (0 = GOOD).

IMPORTANT: stop the usbip bridge server first (it holds the SXUPTP sockets on
client_ip:19540). These scripts open their own session.
"""
import os
import sys
import struct
import time

# Make the bridge package importable regardless of where we're run from.
_REPO = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if _REPO not in sys.path:
    sys.path.insert(0, _REPO)

from bridge.usbip.server import Hub   # noqa: E402

BS = 512                              # sector size (bytes)


# --------------------------------------------------------------------------
# attach / detach
# --------------------------------------------------------------------------
def attach(host, client_ip, busid="1-1", timeout=10.0):
    """Discover the hub, attach `busid` as a mass-storage device, and return
    (hub, dev). `timeout` is the per-reply SXUPTP socket timeout in seconds --
    the single most interesting knob here: the production bridge hard-codes 3.0,
    and a hub that stalls longer than this during a NAND commit is declared
    'dropped' when it may just be slow. Windows waits ~30 s. Try 30+ to test
    whether the 'drops' are really just impatience."""
    hub = Hub(host, client_ip)
    dev = hub.devices.get(busid)
    if dev is None:
        raise SystemExit(f"no busid {busid}; devices: {list(hub.devices)}")
    dev.attach(exclude=hub.exclude_for(busid))
    if dev._ms_bulk_out is None or dev._ms_bulk_in is None:
        raise SystemExit("attach returned no mass-storage endpoints -- the hub's "
                         "SXUPTP slot is probably wedged from a previous run; "
                         "run ./recover.sh (HTTP reboot) and retry.")
    dev.client.timeout = timeout          # override the bridge's default 3.0 s
    return hub, dev


def detach(dev):
    try:
        dev.detach()
    except Exception:
        pass


# --------------------------------------------------------------------------
# self-identifying sectors: each 512-byte sector embeds its own LBA + a per-run
# salt, so a readback that returns a DIFFERENT lba's bytes is provable aliasing
# (an addressing bug), distinct from plain garbage (a data-path bug).
# --------------------------------------------------------------------------
import hashlib


def sector(lba, salt):
    head = struct.pack("<QQ", lba, salt)
    return (head + hashlib.sha256(head).digest() * 32)[:BS]


def marker(block):
    """Return (lba, salt) a sector claims to be, from its first 16 bytes."""
    if len(block) < 16:
        return None, None
    return struct.unpack("<QQ", block[:16])


def buffer_for(lba0, nblk, salt):
    return b"".join(sector(lba0 + i, salt) for i in range(nblk))


# --------------------------------------------------------------------------
# BOT commands. Each returns a short status string ("ok" or a failure reason)
# so a timeout/stall is reported, never raised.
# --------------------------------------------------------------------------
def _cbw(tag, dlen, flags, cdb):
    return (b"USBC" + struct.pack("<I", tag)
            + struct.pack("<IBBB", dlen, flags, 0, len(cdb)) + (cdb + bytes(16))[:16])


def _tag():
    return int(time.monotonic() * 1e6) & 0x7fffffff


def write10(dev, lba, data):
    """WRITE(10) of len(data)//512 blocks at `lba`. Returns "ok" or a reason."""
    c = dev.client
    cdb = b"\x2a\x00" + struct.pack(">I", lba) + b"\x00" + struct.pack(">H", len(data) // BS) + b"\x00"
    try:
        if c.bulk_out(dev._ms_bulk_out, _cbw(_tag(), len(data), 0x00, cdb)) != 0:
            return "cbw-reject"
        if c.bulk_out(dev._ms_bulk_out, data) != 0:
            return "data-reject"
        st, csw = c.bulk_in(dev._ms_bulk_in, 13)
    except Exception as e:
        return f"EXC/{type(e).__name__}"      # usually a socket timeout
    if st != 0 or len(csw) != 13 or csw[:4] != b"USBS":
        return f"csw-bad(st={st},len={len(csw)})"
    return "ok" if csw[12] == 0 else f"csw-status={csw[12]}"


def read10(dev, lba, nblk):
    """READ(10) of nblk blocks at `lba`. Returns (data_or_None, reason)."""
    c = dev.client
    cdb = b"\x28\x00" + struct.pack(">I", lba) + b"\x00" + struct.pack(">H", nblk) + b"\x00"
    try:
        if c.bulk_out(dev._ms_bulk_out, _cbw(_tag(), nblk * BS, 0x80, cdb)) != 0:
            return None, "cbw-reject"
        st, data = c.bulk_in(dev._ms_bulk_in, nblk * BS)
        st2, csw = c.bulk_in(dev._ms_bulk_in, 13)
    except Exception as e:
        return None, f"EXC/{type(e).__name__}"
    if st != 0:
        return None, f"data-bad(st={st},got={len(data)})"
    if st2 != 0 or len(csw) != 13 or csw[:4] != b"USBS":
        return data, f"csw-bad(st={st2})"
    return data, ("ok" if csw[12] == 0 else f"csw-status={csw[12]}")


def read_capacity(dev):
    """READ CAPACITY(10) -> (last_lba, block_bytes) or (None, None)."""
    c = dev.client
    try:
        if c.bulk_out(dev._ms_bulk_out, _cbw(_tag(), 8, 0x80, b"\x25" + bytes(9))) != 0:
            return None, None
        st, data = c.bulk_in(dev._ms_bulk_in, 8)
        c.bulk_in(dev._ms_bulk_in, 13)
    except Exception:
        return None, None
    if st != 0 or len(data) != 8:
        return None, None
    last, blen = struct.unpack(">II", data)
    return last, blen


# --------------------------------------------------------------------------
# GPT probe: read the partition table straight off the device (no Linux) so the
# tests can confirm/auto-find the unformatted partition's LBA range instead of
# hard-coding it. Returns a list of (index, first_lba, last_lba) for used slots.
# --------------------------------------------------------------------------
def gpt_partitions(dev):
    hdr, r = read10(dev, 1, 1)                     # LBA 1 = GPT header
    if hdr is None or hdr[:8] != b"EFI PART":
        return []
    ent_lba = struct.unpack("<Q", hdr[72:80])[0]
    n_ent = struct.unpack("<I", hdr[80:84])[0]
    ent_sz = struct.unpack("<I", hdr[84:88])[0]
    n_sectors = (min(n_ent, 128) * ent_sz + BS - 1) // BS
    blob, r = read10(dev, ent_lba, n_sectors)
    if blob is None:
        return []
    out = []
    for i in range(min(n_ent, 128)):
        e = blob[i * ent_sz:(i + 1) * ent_sz]
        if len(e) < 56 or e[0:16] == bytes(16):    # unused slot
            continue
        first = struct.unpack("<Q", e[32:40])[0]
        last = struct.unpack("<Q", e[40:48])[0]
        out.append((i, first, last))
    return out


def mb(sectors):
    return sectors * BS // 1024 // 1024
