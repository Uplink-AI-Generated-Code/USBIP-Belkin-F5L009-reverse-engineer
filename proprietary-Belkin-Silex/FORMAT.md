# The Silex `.VUP` firmware container

This document describes the `.VUP` firmware image format used by Silex
Technology USB device servers and their OEM rebrands. It was reverse-engineered
from two shipping images and is implemented, with a round-trip self-test, in
[`fw_codec.py`](fw_codec.py).

> **Status.** No public/vendor specification of this container is known to
> exist; this write-up is derived entirely from analysis. Everything marked
> **confirmed** was verified byte-for-byte against both samples below. One
> header byte remains **unidentified**. Field names are descriptive, not
> official.

## Samples analysed

| | Sample A | Sample B |
|---|---|---|
| Device | Belkin F5L009 "Network USB Hub" | Silex **SX-2000U2** |
| Version string | `1.2.0` | `2.1.5` |
| File size | 461,456 bytes (`0x70A90`) | 486,766 bytes (`0x76D6E`) |
| Payload records | 940 | 991 |
| First-record offset | `0x50` | `0x4A` |

The Belkin unit is a rebranded Silex SX-2000U2 (it loads Silex's `SXUPTP`
driver); both images share this identical container. The decrypted payload of
each is an **ARM32 little-endian** firmware image carrying a silex FTPD / HTTP /
DHCP / UPnP networking stack and a copyright string
(`Copyright (C) 2005-2008 silex technology, Inc.` in the SX-2000U2 image).

## Overview

```
+--------------------------------------------------+
| File header (variable length, NOT obfuscated)    |
|   magic, strings, record count, ...              |
+--------------------------------------------------+
| Record 1   (header + XOR-obfuscated data)        |
| Record 2   (header + XOR-obfuscated data)        |
|   ...                                            |
| Record N                                         |
+--------------------------------------------------+
| Trailer record (seq = 0xFFFF)                    |
| u16 seed echo · u16 global checksum              |
+--------------------------------------------------+
```

All multi-byte integers are **big-endian**.

The records tile a flat ARM image loaded at base address **`0x20000`**; most
records carry 480 (`0x1E0`) bytes of data. Record boundaries are fixed-size
transport chunks, *not* logical sections — code and strings routinely straddle
two records.

## File header (not obfuscated, copied verbatim)

The header is **variable-length** because it embeds length-prefixed strings. Do
not assume a fixed size: locate the first record instead (see
[Finding the first record](#finding-the-first-record)).

| Offset | Size | Field | Notes |
|---|---|---|---|
| `0x00` | 4 | Magic | ASCII `.VUP` (`2E 56 55 50`) — **confirmed** |
| `0x04` | 1 | Zero | `0x00` in both samples |
| `0x05` | 1 | *Unknown* | `0x46` (A) / `0x40` (B) — **unidentified**; appears to be a product/format code |
| `0x06` | 1 | Zero | `0x00` in both samples |
| `0x07` | 1 | Device-name length `n` | Pascal-style count byte |
| `0x08` | `n` | Device name | e.g. `Network USB Hub`, `SX-2000U2` |
| `0x08+n` | 1 | Zero | separator |
| `0x09+n` | 1 | Version length `m` | |
| `0x0A+n` | `m` | Version string | e.g. `1.2.0`, `2.1.5` |
| … | | Zero padding | up to the fixed pre-record block below |

### Pre-record block (the 18 bytes immediately before record 1)

Let `S` = offset of the first record. The 18 bytes at `S-18 .. S-1` are a fixed
structure — **confirmed** on both samples:

| Offset | Size | Field | Sample A | Sample B |
|---|---|---|---|---|
| `S-18` | u32 | Remaining length | `0x00070A48` | `0x00076D2C` |
| `S-14` | u32 | Record count | `0x000003AD` (941) | `0x000003E0` (992) |
| `S-10` | u16 | Record type | `0x0003` | `0x0003` |
| `S-8`  | 8 | Zero pad | all `00` | all `00` |

* **Remaining length** = number of bytes from offset `S-8` (the start of the
  zero pad) to end of file. Equivalently `file_size - (S - 8)`. Verified on both.
* **Record count** counts *all* records including the `seq=0xFFFF` trailer, so
  it is `(payload records) + 1`.
* **Record type** mirrors the `0x0003` used by every payload record.

## Record

Each record is a 12-byte header followed by `length` bytes of obfuscated data:

```c
struct record_header {        // big-endian
    u16 checksum;   // sum of the PREVIOUS record's data bytes, & 0xFFFF
    u16 type;       // 0x0003 for payload records
    u16 seq;        // 1, 2, 3, ...  (0xFFFF marks the trailer)
    u16 flags;      // high byte 0x03 (region id); low byte = addr bits 16..23
    u16 addr_lo;    // load address bits 0..15
    u16 length;     // number of data bytes following this header
};
u8 data[length];    // XOR-obfuscated (see below)
```

* **Load address** = `((flags & 0xFF) << 16) | addr_lo`. The flat image base is
  `0x20000` (record 1 has `flags=0x0302, addr_lo=0x0000` → `0x20000`). The high
  byte of `flags` is `0x03` throughout both images.
* **`type`** is `0x0003` for every payload record observed.
* **`length`** lives in the *un-obfuscated* header, so the record chain can be
  walked without decrypting.

## Obfuscation (XOR)

Each record's `data` block is XOR-ed with a **single constant byte**, selected
from an 8-entry schedule indexed by `(seq - 1) mod 8` — **confirmed** identical
across both samples (different device, different firmware version):

```
index:  0    1    2    3    4    5    6    7
key:   C3   F3   BC   8A   CC   E5   D7   9F
```

XOR is its own inverse, so **encryption and decryption are the same operation**.
The header, record headers, trailer, and checksum fields are never obfuscated.

Ground truth: record 1 (key `0xC3`) decrypts to the ARM reset vector table —
`18 F0 9F E5` (`ldr pc, [pc, #0x18]`) repeated — in both images.

## Checksums

Three layers, all computed over the **obfuscated** (on-disk) data — **confirmed**
on both samples (0 mismatches each):

1. **Per-record backward chain.** `record[i].checksum == sum(record[i-1].data) &
   0xFFFF`. Record 1's checksum is a fixed **seed** with no predecessor and is
   preserved as-is.
2. **Trailer.** The `seq=0xFFFF` record's `checksum` field = sum of the *last*
   payload record's data. Its 12-byte header is followed by two u16 fields:
   * **seed echo** = record 1's checksum (the seed), then
   * **global checksum** = `sum(every file byte before it) & 0xFFFF`.

So the file ends with exactly 4 bytes after the trailer header:
`[u16 seed echo][u16 global checksum]`.

### Editing implications

Because each record carries an explicit load address and a fixed `length`,
edits must be **length-preserving** (patch in place). Growing a record would
collide with the next record's address. After editing *obfuscated* bytes, all
three checksum layers must be rebuilt (`fw_codec.py recompute`, or `encrypt
--recompute-checksums`).

## Finding the first record

The header length is not fixed, so do **not** hardcode `0x50`. Locate the first
record by its signature — `type=0x0003, seq=0x0001` — and back up 2 bytes over
its checksum field:

```
first_record = (index of first  00 03 00 01  in the file) - 2
```

Validate the candidate by walking the record chain to the `seq=0xFFFF` trailer;
this rejects any stray signature match inside the header strings. See
`payload_start()` in [`fw_codec.py`](fw_codec.py).

## Worked offsets

Belkin v1.2.0 (`F5L009_v1.2.0.bin`): header `0x00–0x4F`, records `0x50`…, trailer at
`0x70A80` (`46 61 00 03 FF FF 00 00 00 00 00 00`), then `48 0F` (seed echo) and
`BE 56` (global checksum) at `0x70A8C`.

Silex v2.1.5 (`SX-2000U2_v2.1.5.bin`): header `0x00–0x49`, records `0x4A`…, trailer at
`0x76D5E`, then `D5 3E` (seed echo) and `24 1F` (global checksum).

## Tooling

[`fw_codec.py`](fw_codec.py) implements encode/decode, checksum recomputation,
and a self-test (`python3 fw_codec.py selftest`) that verifies round-trip
identity, the ARM-vector sanity check, the checksum chain, and rejection of
malformed images. It passes on both samples above (run with no path, it tests
the checked-in `F5L009_v1.2.0.bin` and `SX-2000U2_v2.1.5.bin` fixtures).

Subcommands:

| Command | Purpose |
|---|---|
| `decrypt <in> <out>` | de-obfuscate every record's data (container kept intact) |
| `encrypt <in> <out>` | re-obfuscate (identical operation — XOR is symmetric) |
| `recompute <in> <out>` | rebuild all checksums of an encrypted image after edits |
| `unpack <image> <dir>` | extract to a flat image + manifest (see below) |
| `pack <dir> <out>` | rebuild the container from a manifest + flat image |
| `selftest [image ...]` | run the verification suite |

`encrypt`/`decrypt`/`recompute` keep the record structure in place; they are the
right tools for a targeted patch when you already know the byte you want to
change. `unpack`/`pack` are the better workflow for editing the firmware as a
whole.

## Unpack / pack workflow

`unpack` decrypts the records and lays them out at their load addresses into one
flat **ARM image**, so you edit real code and strings instead of transport
chunks:

```sh
python3 fw_codec.py unpack F5L009_v1.2.0.bin out_dir/
#   -> out_dir/image.bin      decrypted flat image (base address 0x20000)
#   -> out_dir/manifest.json  everything needed to rebuild the container
#   ...edit out_dir/image.bin in place...
python3 fw_codec.py pack out_dir/ rebuilt.bin
```

With an unedited image, `unpack` → `pack` reproduces the input **byte-for-byte**
(verified on both samples).

### `image.bin`

The decrypted payload of every record, placed at `load_addr - base_addr`. The
records tile this image; a few address gaps exist and read back as zero. Because
each record carries a fixed load address and length, **edits must be
length-preserving** — patch bytes in place; do not insert or delete. `pack`
reads each record's bytes from the same `[addr, addr+length)` window, so
changing the file's overall size has no effect and bytes in gap regions are
ignored.

### `manifest.json`

Captures everything `pack` needs for an exact rebuild:

| Key | Meaning |
|---|---|
| `device`, `version` | parsed from the header (informational) |
| `image_file`, `image_size` | flat-image filename and byte size |
| `base_addr` | lowest record load address (`0x20000`) |
| `seed_checksum` | record 1's checksum (the chain seed, preserved on repack) |
| `header_b64` | the **verbatim** file header, base64 — preserves every byte, including the unidentified `0x05` field |
| `trailer_b64` | the verbatim `seq=0xFFFF` trailer header |
| `records` | ordered list of `{seq, type, flags, addr_lo, length}` |

### What `pack` does

1. Writes the verbatim header from `header_b64`.
2. For each record, reads `image.bin[addr-base : addr-base+length]`, re-applies
   the per-record XOR key, and emits the record header (record 1 keeps
   `seed_checksum`; other checksums are placeholders).
3. Appends the verbatim trailer header plus four placeholder bytes.
4. Calls the checksum rebuild so the per-record chain, trailer checksum, seed
   echo, and global checksum are all correct.
5. Decrypts its own output as a sanity check before writing.

Preserving the header and trailer verbatim means repacking stays faithful even
where this spec is incomplete (e.g. the `0x05` byte). `pack` raises if any
record's window falls outside the flat image, catching a non-length-preserving
edit.
