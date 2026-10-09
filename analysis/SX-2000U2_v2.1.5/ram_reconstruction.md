# SX-2000U2 RAM reconstruction

Same method as the F5L009 reconstruction (see
[`../F5L009_v1.2.0/ram_reconstruction.md`](../F5L009_v1.2.0/ram_reconstruction.md)):
emulate the flash bootstrap with Unicorn, skip the CP15 MMU-enable writes to keep
an identity map, and stop when execution first enters RAM.

## Result

- Reset handler: `0x01020480` (same as F5L009).
- CP15 c1 sites skipped: `0x010208A0`, `0x010208CC`.
- **Entered RAM at `0x0008B8D8`** — the Thumb `main()`. (F5L009's `main` is at
  `0x002F959C`; the SX image links its application lower in RAM.)
- 1015 populated 4 KB pages across the 4 MB working set.
- `main()` has the identical prologue/init-call shape as F5L009's, confirming the
  shared Silex codebase.
- Exception-vector targets (`0x000D7Axx`/`0x000D7Bxx`) resolve inside the
  reconstructed image, as expected.

## Files

- `ram_reconstructed.bin` — 4 MB post-boot image. Load at base `0x0`, Thumb,
  entry `0x0008B8D8`.
- `ram_main.thumb.asm` — `main()` disassembly.
- `ram_strings.txt` — 11,500 strings with addresses.
- `ram/` — full Thumb analysis: `functions.txt`, `strings*.txt`,
  `hot_functions.thumb.asm`, `core_libs.md`, `symbols.txt`, `report.md`.

Caveats identical to the F5L009 reconstruction (peripherals stubbed, MMU left
off against an identity map).
