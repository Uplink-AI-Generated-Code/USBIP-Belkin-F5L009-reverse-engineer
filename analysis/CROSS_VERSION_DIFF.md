# Cross-version diff — Belkin F5L009 v1.2.0 vs Silex SX-2000U2 v2.1.5

Both images are the same Silex firmware for the same USB-device-server hardware;
the Belkin F5L009 is a rebrand of the Silex SX-2000U2. This compares the two
`.VUP` images and their reconstructed RAM images (see each product's
`ram_reconstruction.md`).

## Container / identity

| | F5L009 v1.2.0 | SX-2000U2 v2.1.5 |
|---|---|---|
| Magic | `.VUP` | `.VUP` |
| Device string | `Network USB Hub` | `SX-2000U2` |
| Version | `1.2.0` | `2.1.5` |
| Header size | `0x50` | `0x4A` (shorter device name) |
| Payload records | 940 | 991 |
| File size | `0x70A90` (461,456) | `0x76D6E` (486,766) |
| Copyright | `(C) 2007 Belkin International, Inc.` | `(C) 2005-2008 silex technology, Inc.` |

Everything about the container format is identical — same record layout, the
same XOR key schedule (`C3 F3 BC 8A CC E5 D7 9F`, `(seq-1)%8`), the same
backward checksum chain, seed echo, and global checksum. Only the embedded
strings and payload size differ.

## Boot / addressing

| | F5L009 | SX-2000U2 |
|---|---|---|
| Reset vector | `0x01020480` | `0x01020480` |
| Exec base (flash) | `0x01020000` | `0x01020000` |
| CP15 MMU-enable sites | `0x010208A8`, `0x010208D4` | `0x010208A0`, `0x010208CC` |
| RAM `main()` entry (Thumb) | `0x002F959C` | `0x0008B8D8` |
| Exception handlers (RAM) | `0x00335Bxx–0x00335Cxx` | `0x000D7Axx–0x000D7Bxx` |

Same bootstrap design (identical reset → cache/MMU setup → scatter copy →
Thumb jump to RAM). The application is simply **linked to a different RAM base**:
the SX image places its code/handlers near `0x0008xxxx–0x000Dxxxx`, the Belkin
image near `0x002Exxxx–0x00335xxx`.

## Shared codebase (confirmed instruction-for-instruction)

`main()` and the C runtime are the same routines at shifted addresses:

| Routine | F5L009 | SX-2000U2 |
|---|---|---|
| `main` | `0x002F959C` | `0x0008B8D8` |
| `printf`/logger | `0x00336F24` (888 calls) | `0x000D8F04` (1041 calls) |
| `strcpy` | `0x00337070` | `0x000D9050` |
| `bswap16` | `0x0033628C` | `0x000D8184` |
| `put_le16` | `0x003362BC` | `0x000D81B4` |

The C-runtime cluster maps `0x00336xxx (F5L009) ↔ 0x000D8xxx (SX)`. `main()` has
a byte-identical prologue and the same opening sequence of init calls in both.

## String-set diff (reconstructed RAM images)

| | count |
|---|---|
| Strings in common | 3,323 |
| Only in F5L009 v1.2.0 | 1,948 |
| Only in SX-2000U2 v2.1.5 | 1,160 |

Most "only in X" strings are the same messages with branding or wording changes,
but a few differences are substantive:

### Branding (expected)
- **F5L009**: `Belkin International, Inc.`, `http://www.belkin.com/`.
- **SX-2000U2**: `silex technology, Inc.`, `http://www.silex.jp/`,
  `silexamerica.com`, `silexeurope.com`, `silex.com.cn` (the OEM's own regional
  sites).

### USB sub-driver framework — expanded in v2.1.5
v2.1.5 carries a richer USB-over-IP sub-driver layer (`USBUPTP`) with messages
the v1.2.0 image lacks, e.g. `Regist Sub Driver`, `Find SubDrv`, `Free SubDrv`,
`SubDrv(Prn) alt[%d]->[%d]`, `bind I/F(ep)`, `Hi-Isoc Dev[...] through HUB`,
`Isoc remain data`. v1.2.0's equivalent layer (`SXUP_ALC` / `VP_SXUP`) is
simpler. This points to improved device-class handling (isochronous endpoints,
hubs, printer sub-drivers) in the newer firmware.

### Debug tooling — added in v2.1.5
Both ship the `'DISH' Debugging shell Version 2.5.0`. v2.1.5 additionally
contains a `'FSDEB' FileSystem debugger Ver 0.0.1`.

### Shared app stack (both versions)
`JC-HTTPD/1.16.22`, `215 silex FTP daemon.`, UPnP (`silex-jp:device:...`),
DHCP/BOOTP, NetBIOS, the 11-language web UI, and the SXUPTP transport.

## Takeaways

- The two firmwares are the **same program** with different branding and a newer
  revision; the container and boot mechanics are identical.
- Tooling built for one works directly on the other: `fw_codec.py` handles both,
  the RAM reconstruction method is unchanged, and labelled symbols transfer via
  the `0x00336xxx ↔ 0x000D8xxx` mapping.
- The meaningful v1.2.0 → v2.1.5 change is in the **USB sub-driver framework**
  (broader device support), plus a filesystem debugger and the silex-vs-Belkin
  branding.

## Caveats

- RAM function-candidate counts differ widely (F5L009 ~17.8k vs SX ~37.4k) but
  that is dominated by linear-sweep false positives over different data layouts,
  not a real 2x in real functions — do not read it as a code-size metric.
- String counts are from the reconstructed RAM images; exact numbers depend on
  the minimum-length filter.
