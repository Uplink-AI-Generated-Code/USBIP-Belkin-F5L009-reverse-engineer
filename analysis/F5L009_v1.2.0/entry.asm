; entry/reset @ 0x01020480 (file off 0x480)

0x01020480:  bl      #0x10208bc
0x01020484:  mov     r2, #0
0x01020488:  ldr     r0, [pc, #0x54]  ; =0x02000080
0x0102048c:  bic     r0, r0, #0x2000000
0x01020490:  str     r2, [r0]
0x01020494:  msr     cpsr_c, #0xdf
0x01020498:  mov     r0, r0
0x0102049c:  ldr     r0, [pc, #0x44]  ; =0x03ffe608
0x010204a0:  ldr     r1, [r0]
0x010204a4:  ldr     r2, [pc, #0x40]  ; =0x000070f8
0x010204a8:  orr     r1, r1, r2
0x010204ac:  str     r1, [r0]
0x010204b0:  ldr     r0, [pc, #0x38]  ; =0x03ffe604
0x010204b4:  ldr     r2, [pc, #0x38]  ; =0x03ffe600
0x010204b8:  ldr     r1, [pc, #0x38]  ; =0x00000888
0x010204bc:  ldr     r3, [pc, #0x38]  ; =0x00007ff8
0x010204c0:  str     r1, [r0]
0x010204c4:  str     r3, [r2]
0x010204c8:  ldr     r0, [pc, #0x18]  ; =0x03ffe608
0x010204cc:  ldr     r1, [r0]
0x010204d0:  ldr     r2, [pc, #0x28]  ; =0x0000efff
0x010204d4:  ands    r1, r1, r2
0x010204d8:  str     r1, [r0]
0x010204dc:  mov     r0, r0
0x010204e0:  b       #0x1020800
0x010204e4:  andeq   r0, r0, #0x80
