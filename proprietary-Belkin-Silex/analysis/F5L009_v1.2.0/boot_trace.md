# F5L009 boot trace — reset → RAM copy → jump to RAM

Exec base `0x01020000` (flash `0x20000` + `0x01000000`). ARM32 little-endian.
Addresses below are execution addresses; subtract `0x01000000` for the file
offset into `image.bin`.

## Flow summary

```
reset 0x01020480
  └─ bl 0x010208bc      invalidate I/D cache, clear MMU/cache enable bits (CP15 c1)
  program clock controller @0x03FFE6xx
  b 0x01020800          stage-2
        ├─ bl 0x010208bc            caches off / MMU off again
        ├─ sp = 0x002F66D0          (RAM stack, bit25 mirror cleared)
        ├─ bx 0x01021970  (routine C)  MMU page-table / region setup driver
        │       └─ … bl 0x01020878  set TTB=0x40000, domain, flush TLB, MMU on
        ├─ bx 0x01021764  (routine B)  low-RAM data init
        │       ├─ memset(0x0010E040, 0, 0x470)        BSS clear
        │       └─ memcpy(0x0010E000, 0x01021BB0, 0x30) copy .data from flash
        ├─ bx 0x0102155C  (routine A)  main RAM image init
        │       ├─ memset(0x0010E4C0, 0, ~0x1F1E10)    ~2 MB BSS clear
        │       └─ scatter-copy via 0x01021110 using workers 0x01021044/0x01021098
        └─ bx 0x002F959D           jump into RAM, THUMB mode -> real main()
```

The odd target `0x002F959D` (bit0 = 1) is a **Thumb** entry: after the flash
image has been copied/expanded into RAM at `0x002xxxxx`, control transfers there
and the rest of the firmware executes from RAM. This is why most call targets in
`functions.txt` land in `0x002xxxxx`/`0x00Exxxxx` rather than in this image.

## Runtime memory map (inferred from the copy code)

| Region | Purpose |
|---|---|
| `0x00040000` | MMU translation-table base (TTB) |
| `0x0010E000`–`0x0010E030` | `.data` copied from flash `0x01021BB0` |
| `0x0010E040`–`0x0010E4B0` | `.bss` (zeroed) |
| `0x0010E4C0`–`0x002F62D0` | large zeroed region (~2 MB RAM working set) |
| `0x002F66D0` | initial supervisor stack pointer |
| `0x002F959C` (+1 Thumb) | real firmware entry in RAM |
| `0x03FFE000`–`0x03FFE6xx` | SoC system/clock/interrupt control registers |
| bit `0x02000000` | cached/uncached address mirror (cleared via `bic #0x2000000`) |

## The copy/fill primitives

### `memcpy` — `sub_01021000(dest r0, src r1, len r2)` — byte copy loop
```asm
01021000:  subs  r2, r2, #1       ; len-- ; if underflow,
01021004:  bxlo  lr               ;   return (len==0)
01021008:  sub   r2, r2, #1
0102100C:  ldrb  r3, [r1], #1      ; r3 = *src++
01021010:  cmn   r2, #1
01021014:  strb  r3, [r0], #1      ; *dest++ = r3
01021018:  bne   #0x1021008        ; loop until r2 == -1
0102101C:  bx    lr
```

### `memset` — `sub_01021020(dest r0, byte r1, len r2)` — byte fill loop
```asm
01021020:  sub   r2, r2, #1
01021024:  cmn   r2, #1
01021028:  and   r1, r1, #0xff     ; fill byte
0102102C:  bxeq  lr
01021030:  sub   r2, r2, #1
01021034:  cmn   r2, #1
01021038:  strb  r1, [r0], #1      ; *dest++ = byte
0102103C:  bne   #0x1021030        ; loop
01021040:  bx    lr
```

`sub_01021044` continues as a **word-wise** variant (`lsr r1,r1,#2` → len/4),
used as the fast copy worker that `sub_01021110` drives over a region table.

### `sub_01021110` — scatter-load table walker
Takes a copy-worker pointer in `r0` (e.g. `0x01021044`) and a source in `r1`,
walks a descriptor table, normalises cached/uncached addresses with
`bic #0x2000000`, and calls the worker via `bx r8` for each `{src, dest, len}`
region — the generic relocation engine behind routine A.

## How this reconciles the vectors

The reset vector lives in this flash image (`0x01020480`), but the other
exception handlers point at `0x00335xxx`. Those handler bodies are part of the
RAM image copied above (the `0x0010Exxxx`/`0x002xxxxx` working set), installed
once RAM is populated — so they are not addressable in this flash image.
