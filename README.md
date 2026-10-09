# Belkin F5L009 "Network USB Hub" — firmware tooling & reverse-engineering

Reverse-engineering of the Silex `.VUP` firmware container used by the **Belkin
F5L009 Network USB Hub** (a rebranded **Silex SX-2000U2** USB device server),
plus a working encode/decode tool and a full static + dynamic analysis of both
firmware images.

Everything here was derived from the firmware itself — no vendor documentation
of the `.VUP` format is known to exist.

## Contents

| Path | What it is |
|---|---|
| [`fw_codec.py`](fw_codec.py) | Encode/decode/repack tool for `.VUP` images (+ self-test) |
| [`FORMAT.md`](FORMAT.md) | The reverse-engineered `.VUP` container specification |
| `F5L009_v1.2.0.bin` | Belkin F5L009 firmware v1.2.0 (test fixture) |
| `SX-2000U2_v2.1.5.bin` | Silex SX-2000U2 firmware v2.1.5 (test fixture) |
| [`analysis/`](analysis/) | Static + dynamic analysis of both images (see below) |
| [`analysis/CROSS_VERSION_DIFF.md`](analysis/CROSS_VERSION_DIFF.md) | v1.2.0 vs v2.1.5 comparison |

## The tool

`fw_codec.py` is pure-Python (stdlib only) and handles both images:

```sh
python3 fw_codec.py selftest                       # verify against both fixtures
python3 fw_codec.py decrypt F5L009_v1.2.0.bin out.dec.bin
python3 fw_codec.py encrypt out.dec.bin out.bin    # symmetric (XOR)
python3 fw_codec.py unpack  F5L009_v1.2.0.bin dir/ # -> flat image.bin + manifest.json
python3 fw_codec.py pack    dir/ rebuilt.bin       # rebuild container, fix checksums
python3 fw_codec.py recompute in.bin out.bin       # rebuild checksums after edits
```

`selftest` verifies decrypt↔encrypt round-trips byte-for-byte, the record
checksum chain, the ARM reset-vector sanity check, and rejection of malformed
images — green on both firmware files.

## The format, in brief

A `.VUP` image is a variable-length header (magic `.VUP`, length-prefixed device
and version strings, record count) followed by a chain of records. Each record
has a 12-byte big-endian header (`checksum, type, seq, flags, addr_lo, length`)
and XOR-obfuscated data; the key cycles through `C3 F3 BC 8A CC E5 D7 9F` by
`(seq-1) % 8`. Three checksum layers protect it (per-record backward chain, a
seed echo, and a whole-file checksum). Full details in [`FORMAT.md`](FORMAT.md).

## The analysis

Each firmware was decoded, unpacked to a flat ARM image, and then **booted under
emulation** (Unicorn) to reconstruct the post-boot RAM image, because the flash
image is only a bootstrap that scatter-copies the real application into RAM and
jumps to it in Thumb mode. See each product's `ram_reconstruction.md`.

```
analysis/
├── CROSS_VERSION_DIFF.md        v1.2.0 vs v2.1.5
├── F5L009_v1.2.0/
│   ├── report.md, vectors.txt, entry.asm, records.csv
│   ├── strings.txt, strings_xref.txt, functions.txt
│   ├── boot_trace.md            reset → MMU/cache → RAM copy → jump
│   ├── ram_reconstruction.md    how the RAM image was emulated out
│   ├── ram_reconstructed.bin    4 MB post-boot image (load at base 0, Thumb)
│   ├── ram_main.thumb.asm, ram_strings.txt
│   └── ram/                     Thumb analysis of the RAM image
│       ├── report.md, functions.txt, strings.txt, strings_xref.txt
│       ├── hot_functions.thumb.asm
│       ├── core_libs.md         labelled C runtime (printf/strcpy/memset/…)
│       └── symbols.txt          Ghidra/IDA-importable names
└── SX-2000U2_v2.1.5/            same layout
```

### Key findings
- **Entry**: flash runs at exec base `0x01020000`; reset `0x01020480` sets up the
  MMU/cache and scatter-copies the app into RAM, then jumps to Thumb `main`
  (F5L009 `0x002F959C`, SX-2000U2 `0x0008B8D8`).
- **App stack**: `JC-HTTPD/1.16.22` web server (11-language admin UI), DHCP/BOOTP,
  `silex FTP daemon`, UPnP, NetBIOS, the SXUPTP USB-over-IP transport, and a
  `DISH` debug shell.
- **Shared codebase**: F5L009 and SX-2000U2 are the same Silex program; the C
  runtime maps `0x00336xxx ↔ 0x000D8xxx`. The main v1.2.0→v2.1.5 change is an
  expanded USB sub-driver framework. See the cross-version diff.

## Reproducing

The committed firmware `.bin` files are the only required inputs; all
`analysis/` artifacts regenerate from them with `fw_codec.py` plus Capstone
(disassembly) and Unicorn (boot emulation). Two large, noisy, regenerable
outputs are intentionally git-ignored: `analysis/*/disasm_full.asm` (linear
sweeps) and `*.unpacked/` (unpack outputs).

## Scope & caveats

- All reconstruction and verification is **static/offline** — no image here has
  been flashed to hardware, and doing so carries real bricking risk.
- The firmware `.bin` files are vendor firmware (© Belkin / silex technology),
  included here for interoperability and analysis.
- Analysis labels range from high confidence (unambiguous instruction shapes) to
  inferred; confidence is noted in each document.
