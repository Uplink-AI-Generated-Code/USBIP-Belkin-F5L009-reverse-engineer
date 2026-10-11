# Core library labelling — F5L009 RAM image (Thumb)

Identifications of the most-called routines, by reading each function and
cross-checking call patterns and the firmware's format strings. Addresses are
RAM addresses in `ram_reconstructed.bin` (base `0x0`). Confidence noted; the
high-confidence ones are unambiguous from their instruction shape.

## Formatted output / logging

| Addr | Calls | Name | Conf | Evidence |
|---|---|---|---|---|
| `0x00336f24` | 888 | **`printf`/`vlog`** | high | variadic prologue `push {r0,r1,r2,r3}` (va_list); parses `#`(0x23)/`?`(0x3f)/`%`(0x25); emits via the console primitives below. Consumes the firmware's `?`/`!`/`#`-prefixed format strings with custom specs `%I`=IP, `%M`=MAC, `%SA`=sockaddr. |

The `?`/`!`/`#` prefixes on strings like `?DHCP:Discover.` / `!HTTPD:No job` /
`#DHCP:No UCB` are severity markers this routine reads.

## String / memory library (the `0x336xxx` cluster)

| Addr | Name | Conf | Evidence |
|---|---|---|---|
| `0x00337070` | **`strcpy`** | high | `ldrb [r1]+; strb [r0]+; until NUL; return dest-1` |
| `0x00337084` | **`strncpy`** | high | same loop with count `r2`, NUL-pads remainder (adjacent) |
| `0x003370a8` | **`strcat`** | high | `strlen(dst)` then `strcpy(dst+len, src)` (adjacent) |
| `0x0033652c` | **`strlen`** | high | `ldrb [r0]+; count++; until NUL; return count` |
| `0x003361e0` | **`memset`** | high | replicates byte to a word, stores 16 B/iter then words then bytes |
| `0x0033628c` | **`bswap16`/`htons`** | high | `(x&0xff)<<8 \| (x>>8)&0xff` |
| `0x003362bc` | **`put_le16`** (unaligned store16) | high | `strb r1,[r0]; strb r1>>8,[r0,#1]` |
| `0x003362c4` | **`get_le16`** (unaligned load16) | high | `ldrb[r0] \| ldrb[r0,#1]<<8` |

(A `memcpy` sibling lives beside `memset` in the same cluster; `strcmp`/`memcmp`
are the remaining `0x3362xx`/`0x3363xx` leaves of identical shape.)

## Console / debug-log I/O

| Addr | Calls | Name | Conf | Evidence |
|---|---|---|---|---|
| `0x003364b8` | 150 | **`putc_logbuf`** | med | writes one byte into an in-RAM ring buffer (head/tail indices at fixed globals, wrap-around) |
| `0x00336544` | 614 | **`puts`/`log_str`** | med | emits a string a char at a time through the output path |
| `0x00336518` | 145 | **`put_crlf`** | high | outputs `0x0D` then `0x0A` via `putc` |
| `0x00339700` | — | **`str_out`** (driver) | med | per-char string output via the ARM veneer below |
| `0x0033967c` | — | **`putc_out`** (driver) | med | single-char output with a stack temp, same path |
| `0x00339fa0` | — | **Thumb→ARM veneer** | high | `bx pc; mov r8,r8` then ARM code — interworking stub into the ARM-mode low-level driver (UART/console) |

## Heap

| Addr | Calls | Name | Conf | Evidence |
|---|---|---|---|---|
| `0x00335e70` | 140 | **`malloc`/block-alloc** | med | walks a block list (next-ptr at `+8`, size at `+0xc`), checks flags at `+0x10/+2`, logs via `printf` on failure — matches `!HTTPD:address %lx is not free(can't find memory block)` |

## Networking (hot, not libc)

| Addr | Calls | Name | Conf | Evidence |
|---|---|---|---|---|
| `0x003347d8` | 207 | TCB/socket buffer walk | low | iterates control blocks; fields `+0x1c` len, `+0x30` flags, `+0x3c`; calls send helper `0x3374b0` |
| `0x00334734` | 144 | TCB enqueue/send | low | sets flags `+0x30`, stores buffer ptr `+0x20`, calls `0x3374b0`/`0x337428` |

## Caveats

- High-confidence labels are determined purely by instruction shape (strcpy,
  strlen, memset, bswap, printf) and are reliable.
- Medium/low labels are inferred from call patterns and nearby strings; treat
  the TCB entries as region hints, not firm names.
- Function boundaries come from prologue/BL-target detection on a linear Thumb
  sweep, so a few neighbours may be mislisted. Verify against
  `ram_reconstructed.bin` in a real disassembler.
