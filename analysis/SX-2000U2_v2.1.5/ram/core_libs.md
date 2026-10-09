# Core library labelling — SX-2000U2 v2.1.5 RAM image (Thumb)

The SX-2000U2 shares the F5L009 codebase (both Silex), so its C runtime is the
same routines at different link addresses — the `0x000D8xxx`–`0x000D9xxx` cluster
here corresponds to F5L009's `0x00336xxx`. Addresses are RAM addresses in this
image's `ram_reconstructed.bin` (base `0x0`). The entries marked verified were
read directly and match F5L009 instruction-for-instruction.

## Formatted output / logging

| Addr | Calls | Name | Conf | Evidence |
|---|---|---|---|---|
| `0x000d8f04` | 1041 | **`printf`/`vlog`** | high | variadic `push {r0,r1,r2,r3}`; parses `#`/`?`/`%`; identical to F5L009 `0x336f24` |

## String / memory library (`0x000d8xxx`–`0x000d9xxx`)

| Addr | Name | Conf | Evidence |
|---|---|---|---|
| `0x000d9050` | **`strcpy`** | high (verified) | `ldrb/strb` to NUL, return dest-1 |
| `0x000d9062` | **`strncpy`** | high | count + NUL-pad (adjacent, as in F5L009) |
| `0x000d8184` | **`bswap16`/`htons`** | high (verified) | `(x&0xff)<<8 \| (x>>8)` |
| `0x000d8194` | **`bswap32`/`htonl`** | high (verified) | full 4-byte reversal |
| `0x000d81b4` | **`put_le16`** | high (verified) | `strb r1,[r0]; strb r1>>8,[r0,#1]` |

The `memset`, `memcpy`, `strlen`, `get_le16`, `strcmp`/`memcmp` leaves sit in the
same cluster with the shapes documented in the F5L009
[`core_libs.md`](../../F5L009_v1.2.0/ram/core_libs.md); locate them by matching
those shapes in a disassembler.

## Most-called routines (by call count)

| Addr | Calls | Likely role |
|---|---|---|
| `0x000d8f04` | 1041 | printf/logger |
| `0x000d843c` | 673 | console puts / log string |
| `0x000d9050` | 624 | strcpy |
| `0x000d8184` | 358 | bswap16 |
| `0x000dca80` | 262 | (RTOS/net helper) |
| `0x000d66cc` | 231 | (heap/alloc) |

## Caveats

Same as the F5L009 pass: high-confidence labels are determined by instruction
shape; the rest are inferred. Verify against `ram_reconstructed.bin` (base 0,
Thumb, entry `0x0008b8d8`) in a real disassembler.
