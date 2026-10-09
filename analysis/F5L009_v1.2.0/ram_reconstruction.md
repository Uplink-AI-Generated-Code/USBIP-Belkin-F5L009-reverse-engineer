# F5L009 RAM reconstruction

The flash image (`image.bin`, exec base `0x01020000`) is only a bootstrap: it
sets up the MMU and **copies/scatters the real firmware into RAM**, then jumps to
it in Thumb mode at `0x002F959C` (see [`boot_trace.md`](boot_trace.md)). Most of
the application therefore does not exist as straight code in the flash image —
it only takes shape once the bootstrap has run.

`ram_reconstructed.bin` is that post-boot RAM image, produced by **emulating the
bootstrap** rather than reversing the scatter tables by hand.

## How it was built

Emulated with the Unicorn engine (`emulate.py`):

1. Map a flat 64 MB physical space; load the flash `image.bin` at `0x01020000`.
2. Seed the clock-lock status register (`*0x03FFE014 |= 0x40`) so the PLL-wait
   poll in the pre-init helper returns instead of spinning.
3. Start at the reset handler `0x01020480` in SVC mode, IRQ/FIQ masked.
4. **Skip the CP15 c1 (MMU-enable) writes** at `0x010208A8` / `0x010208D4`. The
   bootstrap builds a translation table at `0x00040000`, but our flat map is
   already identity (VA == PA for every region the copies touch), so leaving the
   MMU off lets Unicorn run without faulting on untranslated fetches while the
   copies land at exactly the same addresses.
5. Let the three stage-2 routines run (MMU table build, `.data`/`.bss` init, the
   ~2 MB scatter copy), then stop the instant execution leaves flash and enters
   RAM — which happened precisely at **`0x002F959C`**, the predicted `main()`.
6. Dump physical `0x00000000–0x00400000` to `ram_reconstructed.bin`.

Result: 537 populated 4 KB pages across the 4 MB working set; `main()` decodes as
clean Thumb; string count jumps from 3,586 (flash) to ~9,400 (RAM).

## Runtime layout (confirmed by emulation)

| Region | Contents |
|---|---|
| `0x00040000` | MMU translation table |
| `0x0010E000`– | `.data` / `.bss` (low working RAM) |
| `0x002E0000`–`0x00340000` approx | **application code** (Thumb) — HTTPD, DHCP, FTPD, UPnP, SXUPTP |
| `0x002F66D0` | supervisor stack |
| **`0x002F959C` (Thumb)** | **`main()` entry** |
| `0x00335B54`–`0x00335CF4` | exception handlers (matches the flash vector table targets) |

The exception-vector targets that pointed "outside" the flash image
(`0x00335xxx`) now resolve inside this reconstructed image — confirming the
reconstruction is faithful.

## What the RAM image reveals

Content that was absent or fragmented in flash is now intact, e.g.:

- Full multi-language web UI (`/en /de /es /fr /it /ja /ko /nl /pt /tch /zh`),
  login/password forms, `<j mlword:NNNN>` template tokens.
- `JC-HTTPD/1.16.22` server, `215 silex FTP daemon.`, UPnP
  `silex-jp:device:NullDevice:1`, SXUPTP buffers.
- Verbose diagnostic format strings (`?HTTPD:`, `?DHCP:`, `!TCPMAIN:`), e.g.
  `Firmware update failed`, `You must login as an administrator.`

## Files

- `ram_reconstructed.bin` — the 4 MB post-boot image. **Load at base
  `0x00000000`** in Ghidra/IDA; set the entry point to `0x002F959C` in **Thumb**.
- `ram_main.thumb.asm` — Thumb disassembly of `main()` and the following code.
- `ram_strings.txt` — all ASCII strings (len>=6) with their RAM addresses.

## Caveats

- Peripheral behaviour is stubbed (only the clock-lock bit). The copies are pure
  memory moves, so the reconstructed memory is accurate; nothing here depends on
  live device state.
- The MMU is left off during emulation. Because the firmware's own map is
  identity for the copied regions, addresses match; if any region were remapped
  non-identity at runtime this would differ, but the vector-target check above
  indicates it is not for the code/data we recovered.
- Code vs. data boundaries are not marked; use the string table and `main()` as
  entry points for a real disassembler.
