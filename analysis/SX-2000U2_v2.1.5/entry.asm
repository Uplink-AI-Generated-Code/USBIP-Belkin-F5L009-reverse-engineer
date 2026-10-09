; entry/reset @ 0x01020480 (file off 0x480)

0x01020480:  mov     r2, #0
0x01020484:  ldr     r0, [pc, #0x3c]  ; =0x00000080
0x01020488:  str     r2, [r0]
0x0102048c:  msr     cpsr_c, #0xdf
0x01020490:  mov     r0, r0
0x01020494:  ldr     r0, [pc, #0x30]  ; =0x03ffe608
0x01020498:  ldr     r1, [r0]
0x0102049c:  ldr     r2, [pc, #0x2c]  ; =0x00007ff8
0x010204a0:  orr     r1, r1, r2
0x010204a4:  str     r1, [r0]
0x010204a8:  ldr     r0, [pc, #0x24]  ; =0x03ffe604
0x010204ac:  ldr     r2, [pc, #0x24]  ; =0x03ffe600
0x010204b0:  ldr     r1, [pc, #0x24]  ; =0x00000888
0x010204b4:  ldr     r3, [pc, #0x14]  ; =0x00007ff8
0x010204b8:  str     r1, [r0]
0x010204bc:  str     r3, [r2]
0x010204c0:  mov     r0, r0
0x010204c4:  b       #0x1020800
0x010204c8:  andeq   r0, r0, r0, lsl #1
