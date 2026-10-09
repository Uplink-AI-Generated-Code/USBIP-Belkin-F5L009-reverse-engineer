#!/usr/bin/env python3
"""
Encrypt / decrypt tool for Silex ".VUP" firmware images, as shipped on the
Belkin F5L009 "Network USB Hub" (a rebranded Silex SX-2000U2) and on Silex's
own SX-2000U2.  Verified round-trip against both the Belkin v1.2.0 image and
the Silex v2.1.5 image.

Container layout
----------------
  * A variable-length, un-obfuscated file header, copied through unchanged.
    It begins with the magic ".VUP" and carries length-prefixed device-name
    and version strings, so its size varies (0x50 for "Network USB Hub",
    0x4A for "SX-2000U2").  The first record is found by locating the first
    record signature (type=0x0003, seq=0x0001) rather than a fixed offset.
  * A chain of records:

        struct record_header {         # all fields big-endian
            u16 checksum;  # sum of the *previous* record's data bytes & 0xFFFF
            u16 type;      # 0x0003 for payload records
            u16 seq;       # 1,2,3,...  (0xFFFF marks the trailer/end)
            u16 flags;
            u16 addr_lo;   # low 16 bits of the load address (base 0x20000)
            u16 length;    # number of data bytes that follow the header
        };
        u8 data[length];   # XOR-obfuscated payload

    Record 1's checksum is a fixed seed (no predecessor).  The records tile a
    flat ARM firmware image; most are 480 (0x1E0) bytes.
  * A trailer record whose seq == 0xFFFF ends the chain, followed by two u16
    fields: an echo of record 1's checksum, then a global checksum equal to
    the sum of every file byte before it.

Obfuscation
-----------
Each record's `data` block is XOR-ed with a single constant byte.  The byte
is chosen from an 8-entry schedule indexed by (seq - 1) % 8:

    KEYS = C3 F3 BC 8A CC E5 D7 9F

Because XOR is its own inverse, encryption and decryption are the identical
operation: toggling the obfuscation on each record's data in place.  Record
headers, the file header, the trailer and the per-record checksum chain are
left untouched, so `encrypt(decrypt(x)) == x` byte-for-byte.

Usage
-----
    python3 fw_codec.py decrypt F5L009_v1.2.0.bin firmware.dec.bin
    python3 fw_codec.py encrypt firmware.dec.bin F5L009_v1.2.0.bin
    python3 fw_codec.py toggle  <in> <out>         # same thing, explicit
    python3 fw_codec.py selftest                   # test checked-in fixtures
    python3 fw_codec.py selftest some_image.bin    # or test a specific image

    # Repackage a MODIFIED image (fix every checksum after editing payload):
    python3 fw_codec.py encrypt firmware.dec.bin out.bin --recompute-checksums
    python3 fw_codec.py recompute in.bin out.bin

Checksums
---------
The container is self-checked three ways (all computed over the ENCRYPTED
payload, which is why --recompute-checksums must run on an encrypted image):

  * Per-record chain: record[i].checksum == sum(record[i-1].data) & 0xFFFF.
    Record 1's checksum is a fixed seed with no predecessor and is preserved.
  * The trailer (seq=0xFFFF) carries the seed echoed back, then
  * a global checksum == sum of every file byte before it, & 0xFFFF.

If you edit payload bytes you must rebuild these, either by passing
--recompute-checksums to encrypt/toggle or by running the `recompute` command
on the finished (encrypted) image.
"""

import struct
import sys

MAGIC = b".VUP"
RECORD_HEADER_SIZE = 12
SEQ_END = 0xFFFF
TRAILER_TAIL = 4            # seed echo (u16) + global checksum (u16)
KEYS = (0xC3, 0xF3, 0xBC, 0x8A, 0xCC, 0xE5, 0xD7, 0x9F)


def key_for_seq(seq: int) -> int:
    """Return the XOR key byte used for the record with this sequence number."""
    return KEYS[(seq - 1) % len(KEYS)]


def payload_start(data: bytes) -> int:
    """
    Return the offset of the first payload record (= end of the file header).

    The header is variable-length: it holds length-prefixed device-name and
    version strings, so its size differs per image (e.g. 0x50 for the Belkin
    "Network USB Hub", 0x4A for the Silex "SX-2000U2").  The first record is
    always type=0x0003, seq=0x0001, preceded by its 2-byte checksum, so locate
    that signature and validate the candidate by walking the whole chain to the
    seq=0xFFFF trailer.  Validation lets us skip any stray match inside the
    header strings.
    """
    if len(data) < len(MAGIC) or data[:len(MAGIC)] != MAGIC:
        raise ValueError("not a .VUP image (bad magic)")
    sig = b"\x00\x03\x00\x01"        # type=0x0003, seq=0x0001
    candidates = []
    pos = data.find(sig)
    while pos != -1:
        start = pos - 2              # back up over the checksum field
        if start >= len(MAGIC):
            candidates.append(start)
        pos = data.find(sig, pos + 1)
    if not candidates:
        raise ValueError("could not locate the first payload record (seq=1)")
    # Prefer a candidate whose record chain actually reaches the trailer; this
    # skips any stray signature inside the header strings.  If none validates
    # (e.g. a corrupted or truncated chain), fall back to the first candidate
    # so the caller's walk reports the specific structural error.
    for start in candidates:
        if _walks_to_trailer(data, start):
            return start
    return candidates[0]


def _walks_to_trailer(data: bytes, start: int) -> bool:
    """True if records parse cleanly from `start` to a seq=0xFFFF trailer."""
    off = start
    seen_first = False
    while off + RECORD_HEADER_SIZE <= len(data):
        _cs, _type, seq, _flags, _addr, length = struct.unpack_from(">6H", data, off)
        if seq == SEQ_END:
            return seen_first
        if not seen_first and seq != 1:
            return False
        seen_first = True
        off += RECORD_HEADER_SIZE + length
        if off > len(data):
            return False
    return False


def toggle(blob: bytes) -> bytearray:
    """
    Toggle the XOR obfuscation on every record's data block.

    Applied to an encrypted image this decrypts it; applied to a decrypted
    image this re-encrypts it.  The two are the same operation.
    """
    data = bytearray(blob)
    off = payload_start(data)
    while off + RECORD_HEADER_SIZE <= len(data):
        _cs, _type, seq, _flags, _addr, length = struct.unpack_from(">6H", data, off)
        if seq == SEQ_END:
            break
        start = off + RECORD_HEADER_SIZE
        end = start + length
        if end > len(data):
            raise ValueError(
                f"record seq={seq} at 0x{off:x} claims length 0x{length:x} "
                f"but runs past end of file"
            )
        key = key_for_seq(seq)
        for i in range(start, end):
            data[i] ^= key
        off = end
    else:
        raise ValueError("reached end of file without a seq=0xFFFF trailer")

    return data


# decrypt and encrypt are identical (XOR is an involution); alias for clarity.
decrypt = toggle
encrypt = toggle


def recompute_checksums(blob: bytes) -> bytearray:
    """
    Rebuild every checksum in an ENCRYPTED image after its payload was edited.

    Rewrites, in place:
      * each payload record's checksum = sum of the previous record's data
        (record 1's checksum is a fixed seed and is left untouched);
      * the trailer's checksum = sum of the last payload record's data;
      * the trailer's seed echo = record 1's checksum;
      * the trailing global checksum = sum of all bytes before it.

    Returns a new bytearray; the input is not modified.
    """
    data = bytearray(blob)
    off = payload_start(data)
    seed = None            # record 1's checksum field
    prev_data = None       # previous record's data bytes
    trailer_off = None
    while off + RECORD_HEADER_SIZE <= len(data):
        cs, _type, seq, _flags, _addr, length = struct.unpack_from(">6H", data, off)
        if seq == SEQ_END:
            trailer_off = off
            break
        if seed is None:
            seed = cs                      # record 1: fixed seed, preserved
        else:
            struct.pack_into(">H", data, off, sum(prev_data) & 0xFFFF)
        start = off + RECORD_HEADER_SIZE
        end = start + length
        if end > len(data):
            raise ValueError(f"record seq={seq} at 0x{off:x} runs past end of file")
        prev_data = data[start:end]
        off = end
    if trailer_off is None:
        raise ValueError("reached end of file without a seq=0xFFFF trailer")

    # Trailer: checksum of the last payload record's data, then the seed echo.
    struct.pack_into(">H", data, trailer_off, sum(prev_data) & 0xFFFF)
    if trailer_off + RECORD_HEADER_SIZE + TRAILER_TAIL != len(data):
        raise ValueError(
            "unexpected trailer size: expected a 12-byte header followed by "
            "a 2-byte seed echo and a 2-byte global checksum"
        )
    struct.pack_into(">H", data, trailer_off + RECORD_HEADER_SIZE, seed & 0xFFFF)

    # Global checksum: sum of every byte before the final 2-byte field.
    struct.pack_into(">H", data, len(data) - 2, sum(data[:-2]) & 0xFFFF)
    return data


def iter_records(blob: bytes):
    """Yield (offset, checksum, type, seq, flags, addr_lo, length) per record."""
    off = payload_start(blob)
    while off + RECORD_HEADER_SIZE <= len(blob):
        cs, typ, seq, flags, addr, length = struct.unpack_from(">6H", blob, off)
        if seq == SEQ_END:
            yield (off, cs, typ, seq, flags, addr, 0)
            return
        yield (off, cs, typ, seq, flags, addr, length)
        off += RECORD_HEADER_SIZE + length


# Firmware images checked in beside this script, used as default self-test
# fixtures when `selftest` is invoked with no path.
FIXTURES = ("F5L009_v1.2.0.bin", "SX-2000U2_v2.1.5.bin")


def selftest_all(paths) -> int:
    """Run selftest over several images; return non-zero if any fails."""
    import os
    if not paths:
        here = os.path.dirname(os.path.abspath(__file__))
        paths = [os.path.join(here, f) for f in FIXTURES]
    rc = 0
    for i, p in enumerate(paths):
        if i:
            print()
        print(f"### {p}")
        rc |= selftest(p)
    return rc


def selftest(path: str) -> int:
    original = open(path, "rb").read()

    # 1) Round-trip: decrypt then encrypt must reproduce the input exactly.
    once = toggle(original)
    twice = toggle(once)
    if bytes(twice) != original:
        print("FAIL: round-trip did not reproduce the original file")
        return 1
    print("PASS: decrypt->encrypt round-trip is byte-for-byte identical")

    # 2) Structural sanity on the decrypted payload.
    #    Record 1 maps to the ARM reset vector table: repeated
    #    'ldr pc,[pc,#0x18]' == 18 f0 9f e5 (little-endian).
    first_off = payload_start(once) + RECORD_HEADER_SIZE
    vec = once[first_off:first_off + 4]
    if bytes(vec) == b"\x18\xf0\x9f\xe5":
        print("PASS: record 1 decrypts to the ARM reset vector table")
    else:
        print(f"WARN: record 1 head is {bytes(vec).hex()} (expected 18f09fe5)")

    # 3) Checksum chain: each record's checksum == sum of the PREVIOUS record's
    #    data bytes (& 0xFFFF).  The stored checksums cover the ENCRYPTED
    #    payload, so this is validated against the original (encrypted) image.
    recs = [r for r in iter_records(original) if r[3] != SEQ_END]
    mismatches = 0
    for prev, cur in zip(recs, recs[1:]):
        p_off, _pcs, _pt, _pseq, _pf, _pa, plen = prev
        p_data = original[p_off + RECORD_HEADER_SIZE:p_off + RECORD_HEADER_SIZE + plen]
        if cur[1] != (sum(p_data) & 0xFFFF):
            mismatches += 1
    print(f"{'PASS' if mismatches == 0 else 'WARN'}: "
          f"checksum chain mismatches = {mismatches} (of {max(len(recs) - 1, 0)})")

    # 3b) recompute_checksums on the unmodified image must be a no-op.
    if bytes(recompute_checksums(original)) == original:
        print("PASS: recompute_checksums reproduces all checksums (idempotent)")
    else:
        print("FAIL: recompute_checksums changed an unmodified image")
        return 1

    # 4) Negative tests: images with a wrong byte count must be rejected, not
    #    silently (mis)processed.  Each variant is synthesized in memory from
    #    the good image.
    failures = []

    def expect_rejected(label, fn):
        try:
            fn()
        except ValueError as exc:
            print(f"PASS: {label} rejected -> {exc}")
        else:
            print(f"FAIL: {label} was NOT rejected")
            failures.append(label)

    # 4a) A record whose length field overruns the buffer.
    oversized = bytearray(original)
    victim = recs[2][0] if len(recs) > 2 else recs[0][0]   # a payload record's offset
    struct.pack_into(">H", oversized, victim + 10, 0xFFF0)
    expect_rejected("oversized record length", lambda: toggle(bytes(oversized)))

    # 4b) A file truncated mid-payload (last record's length now overruns).
    expect_rejected("truncated file", lambda: toggle(original[:-100]))

    # 4c) Stray bytes appended after the trailer (wrong total byte count).
    expect_rejected("extra trailing bytes",
                    lambda: recompute_checksums(original + b"\xde\xad\xbe\xef"))

    # 4d) A file too small to even hold the .VUP header.
    expect_rejected("truncated header", lambda: toggle(original[:0x10]))

    # 4e) A container that parses cleanly but has no seq=0xFFFF trailer
    #     (cut exactly at the end of record 1, so no record overruns first).
    cut = recs[1][0] if len(recs) > 1 else len(original)
    expect_rejected("missing trailer", lambda: toggle(original[:cut]))

    # 5) Report what we parsed.  Header strings are length-prefixed: a count
    #    byte then that many chars.  The device name sits at 0x07; the version
    #    follows it (name, a NUL separator, then the version string), so its
    #    offset is derived from the name length rather than hardcoded.
    device = _pstr(original, 0x07)
    version = _pstr(original, 0x07 + 1 + len(device) + 1)
    print(f"INFO: {len(recs)} payload records, header 0x{recs[0][0]:x} bytes, "
          f"device '{device}', version '{version}'")
    return 1 if failures else 0


def _pstr(blob: bytes, off: int) -> str:
    """Read a length-prefixed string: one count byte then that many chars."""
    n = blob[off]
    return blob[off + 1:off + 1 + n].decode("latin1", "replace")


def _dispatch(argv) -> int:
    cmd = argv[1].lower()

    if cmd == "selftest":
        # With no path, run against the checked-in fixtures; otherwise test
        # each image given.
        return selftest_all(argv[2:])

    if cmd in ("decrypt", "encrypt", "toggle"):
        args = [a for a in argv[2:] if not a.startswith("-")]
        recompute = "--recompute-checksums" in argv[2:]
        unknown = [a for a in argv[2:] if a.startswith("-") and a != "--recompute-checksums"]
        if unknown or len(args) != 2:
            print(f"usage: fw_codec.py {cmd} <in> <out> [--recompute-checksums]")
            return 2
        src, dst = args
        blob = open(src, "rb").read()
        out = toggle(blob)
        if recompute:
            if cmd == "decrypt":
                print("warning: --recompute-checksums on 'decrypt' is almost "
                      "never what you want; checksums are computed over the "
                      "ENCRYPTED payload.")
            out = recompute_checksums(out)
        open(dst, "wb").write(out)
        suffix = " (+recomputed checksums)" if recompute else ""
        print(f"{cmd}: {src} -> {dst} ({len(out)} bytes){suffix}")
        return 0

    if cmd == "recompute":
        if len(argv) != 4:
            print("usage: fw_codec.py recompute <in> <out>  "
                  "(operates on an encrypted image)")
            return 2
        blob = open(argv[2], "rb").read()
        out = recompute_checksums(blob)
        open(argv[3], "wb").write(out)
        print(f"recompute: {argv[2]} -> {argv[3]} ({len(out)} bytes)")
        return 0

    print(f"unknown command: {cmd!r}")
    print(__doc__)
    return 2


def main(argv) -> int:
    if len(argv) < 2:
        print(__doc__)
        return 2
    try:
        return _dispatch(argv)
    except (ValueError, struct.error) as exc:
        # Malformed container (bad length / byte count, missing trailer, ...).
        print(f"error: {exc}", file=sys.stderr)
        return 1
    except OSError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
