# Reverse-engineering the `.VUP` container and its XOR key

How the [`.VUP` firmware format](FORMAT.md) and its obfuscation were worked out,
from nothing but two shipping firmware images and no vendor documentation.

This is a reconstruction of the derivation, written so each step is **reproducible
against the committed images** ([`F5L009_v1.2.0.bin`](F5L009_v1.2.0.bin),
[`SX-2000U2_v2.1.5.bin`](SX-2000U2_v2.1.5.bin)). Every byte value below was read
back from those files; you can re-run each step with a few lines of Python (or
just `python3 fw_codec.py …`). All multi-byte integers are big-endian.

## 0. What we start with

Two `.bin` files, ~450–490 KB each, that the vendor's updater flashes to the
device. No spec, no symbols. The questions: what is the container, and the
payload is clearly not plain code — how is it obfuscated?

## 1. First look: magic and strings

A hexdump of the first bytes is immediately legible:

```
00000000  2e 56 55 50 00 46 00 0f  4e 65 74 77 6f 72 6b 20   .VUP.F..Network
00000010  55 53 42 20 48 75 62 00  05 31 2e 32 2e 30 00 ...  USB Hub..1.2.0.
```

- ASCII **`.VUP`** magic at `0x00`.
- A length-prefixed **device name** (`0x0F` = 15, `"Network USB Hub"`) and a
  length-prefixed **version** (`0x05`, `"1.2.0"`).
- One byte at offset `0x05` (`0x46` here, `0x40` in the Silex image) that never
  resolved to anything — noted as unidentified and preserved verbatim.

So it is a firmware **container** with a small textual header. The rest is binary
and looks random — the payload is obfuscated.

## 2. The record structure

Scanning past the header, a regular cadence appears: a short fixed-size header
every few hundred bytes, each with a counter that increments by one. That is a
**record-chained container**. Pinning it down:

- **Locate record 1 by signature.** Every record header has a constant
  `type = 0x0003` and a running `seq`, so the first record is the first
  occurrence of `00 03 00 01` (type 3, seq 1). Backing up 2 bytes (over a
  leading `u16`) lands on the record header. In `F5L009_v1.2.0.bin` that is
  offset **`0x50`**:

  ```
  record 1 header (12 bytes):  48 0f 00 03 00 01 03 02 00 00 01 e0
                               └cks┘ └typ┘ └seq┘ └flg┘ └alo┘ └len┘
  ```

  → `type=0x0003`, `seq=1`, `length=0x01E0` (480) data bytes follow.

- **Walk the chain.** `length` lives in the clear, so you can hop header →
  `length` bytes → next header without decrypting anything, incrementing `seq`
  each time, until **`seq = 0xFFFF`**: the trailer. That walk both proves the
  structure and rejects any stray `00 03 00 01` that happens to fall inside the
  header strings (a bad guess fails to chain to the trailer).

- **Read the pre-record block backwards.** The 18 bytes just before record 1
  then decode as `{u32 remaining-length, u32 record-count, u16 type=3, 8×00}` —
  confirmed because `remaining-length == filesize-(S-8)` and `record-count ==
  payload records + 1` on both samples.

Field meanings (`flags`/`addr_lo` → load address, etc.) come later from where the
decrypted bytes land; see [FORMAT.md](FORMAT.md). At this point we can walk and
slice records but their data is still scrambled.

## 3. Cracking the obfuscation: record 1

Dump record 1's data (the 480 bytes after its header):

```
db 33 5c 26 db 33 5c 26 db 33 5c 26 db 33 5c 26 ...
```

Two things jump out:

1. **It is periodic with period 4.** A repeating 4-byte ciphertext pattern can
   only come from a repeating 4-byte *plaintext* XORed with a key whose period
   divides 4 — and the simplest such key is a **single constant byte** (a
   multi-byte or streaming key would destroy the period). So the hypothesis is:
   each record's data is XORed with one constant byte.

2. **We know what that plaintext is.** The payload is an ARM32 image, and record
   1 loads at the image base — so it begins with the **ARM exception-vector
   table**, canonically a run of `LDR PC, [PC, #0x18]` = `18 F0 9F E5`
   (little-endian) repeated.

XOR the ciphertext against the known vector:

```
cipher   db 33 5c 26
known    18 f0 9f e5
XOR  =   c3 c3 c3 c3      → the key is the constant byte 0xC3
```

Decrypting the record with `0xC3` yields `18 f0 9f e5 18 f0 9f e5 …` — the full
vector table. **Record 1's key is `0xC3`, and the per-record-constant hypothesis
holds.** (Independent cross-check: record 1 also contains a **216-byte run of
`0xC3`** — that is a block of `0x00` padding showing the key directly.)

## 4. The key schedule and its period

Record 2 decrypted with `0xC3` is garbage, so each record uses its **own**
constant. Rather than crack 940 of them, test the usual shape of such schemes —
a **short repeating schedule**. Recovering a few keys (from the ARM anchor, and
from padding runs where a record has a long run of one byte = `0x00` plaintext)
gives a candidate 8-entry table, and the decisive test is **decrypt the whole
image under an 8-entry, period-8 schedule and see if it is coherent firmware**:

```
index  (seq-1) mod 8:   0    1    2    3    4    5    6    7
key:                    C3   F3   BC   8A   CC   E5   D7   9F
```

With `key = schedule[(seq-1) mod 8]` the entire image decrypts to a single valid
ARM firmware — the vector table at the start, readable strings throughout, and
the banner **`Copyright (C) 2007 Belkin International, Inc.`**. A wrong byte in
any one slot turns every 8th record to noise, which is obvious on inspection, so
the schedule is self-checking. Period-8 is confirmed directly: **record 9**
(residue 0) decrypts with `0xC3` to valid ARM (`48 20 9f e5`, `ldr r2,[pc,#…]`),
record 10 with `0xF3`, and so on.

> Note: no cheap one-byte statistic (e.g. "most common byte = key") recovers all
> eight — real code is not zero-dominated, and that shortcut yields a plausible
> but wrong schedule. The reliable recipe is **ARM known-plaintext for the anchor
> + whole-image coherence under the period-8 hypothesis.**

XOR is its own inverse, so encryption and decryption are the same operation. The
container header, record headers, trailer, and checksum fields are never XORed.

## 5. The checksums

Each record header's leading `u16` is not random. Testing the obvious relation
over the whole chain:

```
record[i].checksum  ==  sum(record[i-1].data bytes) & 0xFFFF
```

holds for **every** record 2…940 (0 mismatches). It is a **backward chain**:
each record carries the checksum of its *predecessor's* data. Record 1 has no
predecessor, so its field is a fixed **seed** (`0x480F`), preserved as-is.

The trailer closes the loop. Its `checksum` field equals the sum of the *last*
payload record's data, and the 4 bytes after its header are two `u16`s:

- a **seed echo** = record 1's checksum (`0x480F`), and
- a **global checksum** = `sum(every file byte before it) & 0xFFFF` (`0xBE56`).

Both verify exactly. Crucially, all three layers are computed over the
**obfuscated / on-disk** bytes, so they validate independently of knowing the
XOR key — which is itself a hint that the checksum and the obfuscation are
separate layers, and is why `fw_codec.py` can verify the chain before it ever
decrypts anything.

## 6. Why we trust it: the second sample

The Silex **SX-2000U2 v2.1.5** image — a *different device and firmware version*
— is the control. It uses the **identical** container and the **identical** key
schedule: its record 1 ciphertext is byte-for-byte the same `db 33 5c 26 …`,
`^ 0xC3` gives the same ARM vector, and the same 8-key table decrypts it to valid
firmware carrying `Copyright (C) 2005-2008 silex technology, Inc.`. A scheme
reverse-engineered from one file and then found to fit a second, unrelated file
untouched is strong evidence it is the real scheme and not an overfit. The only
cross-sample difference is the unidentified header byte at `0x05`
(`0x46` vs `0x40`).

## 7. What is still unknown

The single header byte at `0x05` (`0x46` / `0x40`) was never tied to a behaviour;
it looks like a product/format code. It is preserved verbatim on repack, so the
round-trip is exact despite the gap.

## Reproduce

Everything above is implemented and self-tested in [`fw_codec.py`](fw_codec.py):

```sh
cd proprietary-Belkin-Silex
python3 fw_codec.py selftest          # round-trip + ARM-vector + checksum checks, both images
python3 fw_codec.py decrypt F5L009_v1.2.0.bin out.dec.bin
```

The format itself is specified in [FORMAT.md](FORMAT.md).
