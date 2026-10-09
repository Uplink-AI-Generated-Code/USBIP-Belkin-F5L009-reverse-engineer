; Top-called functions + main() from reconstructed RAM (THUMB)
; disassembled until first pop{...,pc}/bx lr (cap 120 instrs)


===== main @ 0x002f959c =====
0x002f959c:  00b5      push    {lr}
0x002f959e:  81b0      sub     sp, #4
0x002f95a0:  fdf732f9  bl      #0x2f6808  ; sub_002f6808
0x002f95a4:  3cf020f8  bl      #0x3355e8  ; sub_003355e8
0x002f95a8:  fdf752f9  bl      #0x2f6850  ; sub_002f6850
0x002f95ac:  2348      ldr     r0, [pc, #0x8c]  ; =0x00002710
0x002f95ae:  3bf089ff  bl      #0x3354c4  ; sub_003354c4
0x002f95b2:  0a20      movs    r0, #0xa
0x002f95b4:  3cf0e8f8  bl      #0x335788  ; sub_00335788
0x002f95b8:  214b      ldr     r3, [pc, #0x84]  ; =0x00386280
0x002f95ba:  2249      ldr     r1, [pc, #0x88]  ; =0x01000000
0x002f95bc:  181c      adds    r0, r3, #0
0x002f95be:  c91a      subs    r1, r1, r3
0x002f95c0:  3cf052fd  bl      #0x336068  ; sub_00336068
0x002f95c4:  1d48      ldr     r0, [pc, #0x74]  ; =0x00002710
0x002f95c6:  fdf7edf8  bl      #0x2f67a4  ; sub_002f67a4
0x002f95ca:  0020      movs    r0, #0
0x002f95cc:  fdf7b0f9  bl      #0x2f6930  ; sub_002f6930
0x002f95d0:  1d4b      ldr     r3, [pc, #0x74]  ; =0x0010e4e0
0x002f95d2:  1860      str     r0, [r3]
0x002f95d4:  8020      movs    r0, #0x80
0x002f95d6:  c001      lsls    r0, r0, #7
0x002f95d8:  3cf04afc  bl      #0x335e70  ; sub_00335e70
0x002f95dc:  0028      cmp     r0, #0
0x002f95de:  2ad0      beq     #0x2f9636
0x002f95e0:  8021      movs    r1, #0x80
0x002f95e2:  c901      lsls    r1, r1, #7
0x002f95e4:  3cf0aafe  bl      #0x33633c  ; sub_0033633c
0x002f95e8:  0420      movs    r0, #4
0x002f95ea:  3cf0d9fe  bl      #0x3363a0  ; sub_003363a0
0x002f95ee:  0120      movs    r0, #1
0x002f95f0:  3cf0b2fe  bl      #0x336358  ; sub_00336358
0x002f95f4:  1548      ldr     r0, [pc, #0x54]  ; =0x003665d4 &"SYSLOG START: MSG_DEBUG"
0x002f95f6:  3cf0a5ff  bl      #0x336544  ; sub_00336544
0x002f95fa:  0ff05ff8  bl      #0x3086bc  ; sub_003086bc
0x002f95fe:  104b      ldr     r3, [pc, #0x40]  ; =0x00386280
0x002f9600:  104a      ldr     r2, [pc, #0x40]  ; =0x01000000
0x002f9602:  191c      adds    r1, r3, #0
0x002f9604:  d21a      subs    r2, r2, r3
0x002f9606:  1248      ldr     r0, [pc, #0x48]  ; =0x003665f0 &"HEAP: addr=%lx size=%lx"
0x002f9608:  3df08cfc  bl      #0x336f24  ; sub_00336f24
0x002f960c:  114b      ldr     r3, [pc, #0x44]  ; =0x00366608 &"DEBUG"
0x002f960e:  c022      movs    r2, #0xc0
0x002f9610:  0093      str     r3, [sp]
0x002f9612:  1148      ldr     r0, [pc, #0x44]  ; =0x0010ed80
0x002f9614:  1149      ldr     r1, [pc, #0x44]  ; =0x0030a6f1
0x002f9616:  1201      lsls    r2, r2, #4
0x002f9618:  0123      movs    r3, #1
0x002f961a:  fff7c9fd  bl      #0x2f91b0  ; sub_002f91b0
0x002f961e:  104b      ldr     r3, [pc, #0x40]  ; =0x00366610 &"INIT"
0x002f9620:  8022      movs    r2, #0x80
0x002f9622:  0093      str     r3, [sp]
0x002f9624:  0f48      ldr     r0, [pc, #0x3c]  ; =0x0010ed00
0x002f9626:  1049      ldr     r1, [pc, #0x40]  ; =0x002f92a5
0x002f9628:  1201      lsls    r2, r2, #4
0x002f962a:  0223      movs    r3, #2
0x002f962c:  fff7c0fd  bl      #0x2f91b0  ; sub_002f91b0
0x002f9630:  3bf098ff  bl      #0x335564  ; sub_00335564
0x002f9634:  fee7      b       #0x2f9634
0x002f9636:  0d48      ldr     r0, [pc, #0x34]  ; =0x00366618 &"Alloc Error"
0x002f9638:  dde7      b       #0x2f95f6
0x002f963a:  0000      movs    r0, r0
0x002f963c:  1027      movs    r7, #0x10
0x002f963e:  0000      movs    r0, r0
0x002f9640:  8062      str     r0, [r0, #0x28]
0x002f9642:  3800      movs    r0, r7
0x002f9644:  0000      movs    r0, r0
0x002f9646:  0001      lsls    r0, r0, #4
0x002f9648:  e0e4      b       #0x2f900c
0x002f964a:  1000      movs    r0, r2
0x002f964c:  d465      str     r4, [r2, #0x5c]
0x002f964e:  3600      movs    r6, r6
0x002f9650:  f065      str     r0, [r6, #0x5c]
0x002f9652:  3600      movs    r6, r6
0x002f9654:  0866      str     r0, [r1, #0x60]
0x002f9656:  3600      movs    r6, r6
0x002f9658:  80ed1000  stc     p0, c0, [r0, #0x40]
0x002f965c:  f1a6      adr     r6, #0x3c4
0x002f965e:  3000      movs    r0, r6
0x002f9660:  1066      str     r0, [r2, #0x60]
0x002f9662:  3600      movs    r6, r6
0x002f9664:  00ed1000  stc     p0, c0, [r0, #-0x40]
0x002f9668:  a592      str     r2, [sp, #0x294]
0x002f966a:  2f00      movs    r7, r5
0x002f966c:  1866      str     r0, [r3, #0x60]
0x002f966e:  3600      movs    r6, r6
0x002f9670:  0048      ldr     r0, [pc, #0]  ; =0x0033a4c4 &"@prn"
0x002f9672:  7047      bx      lr

===== sub_002f6d24 @ 0x002f6d24 =====
0x002f6d24:  0068      ldr     r0, [r0]
0x002f6d26:  7047      bx      lr

===== sub_002f6d38 @ 0x002f6d38 =====
0x002f6d38:  0160      str     r1, [r0]
0x002f6d3a:  7047      bx      lr

===== sub_00300000 @ 0x00300000 =====
0x00300000:  0028      cmp     r0, #0
0x00300002:  00d0      beq     #0x300006
0x00300004:  4162      str     r1, [r0, #0x24]
0x00300006:  024b      ldr     r3, [pc, #8]  ; =0x002eff20
0x00300008:  0020      movs    r0, #0
0x0030000a:  1960      str     r1, [r3]
0x0030000c:  7047      bx      lr

===== sub_0030ab64 @ 0x0030ab64 =====
0x0030ab64:  30b5      push    {r4, r5, lr}
0x0030ab66:  051c      adds    r5, r0, #0
0x0030ab68:  081c      adds    r0, r1, #0
0x0030ab6a:  0c1c      adds    r4, r1, #0
0x0030ab6c:  2bf0defc  bl      #0x33652c  ; sub_0033652c
0x0030ab70:  211c      adds    r1, r4, #0
0x0030ab72:  021c      adds    r2, r0, #0
0x0030ab74:  0023      movs    r3, #0
0x0030ab76:  6868      ldr     r0, [r5, #4]
0x0030ab78:  0cf01efc  bl      #0x3173b8  ; sub_003173b8
0x0030ab7c:  30bc      pop     {r4, r5}
0x0030ab7e:  02bc      pop     {r1}
0x0030ab80:  0847      bx      r1
0x0030ab82:  0000      movs    r0, r0
0x0030ab84:  f0b5      push    {r4, r5, r6, r7, lr}
0x0030ab86:  037b      ldrb    r3, [r0, #0xc]
0x0030ab88:  071c      adds    r7, r0, #0
0x0030ab8a:  84b0      sub     sp, #0x10
0x0030ab8c:  041c      adds    r4, r0, #0
0x0030ab8e:  0026      movs    r6, #0
0x0030ab90:  1037      adds    r7, #0x10
0x0030ab92:  002b      cmp     r3, #0
0x0030ab94:  26d1      bne     #0x30abe4
0x0030ab96:  8368      ldr     r3, [r0, #8]
0x0030ab98:  002b      cmp     r3, #0
0x0030ab9a:  46d1      bne     #0x30ac2a
0x0030ab9c:  437b      ldrb    r3, [r0, #0xd]
0x0030ab9e:  002b      cmp     r3, #0
0x0030aba0:  41d0      beq     #0x30ac26
0x0030aba2:  4673      strb    r6, [r0, #0xd]
0x0030aba4:  4068      ldr     r0, [r0, #4]
0x0030aba6:  6c30      adds    r0, #0x6c
0x0030aba8:  08f0faf9  bl      #0x312fa0  ; sub_00312fa0
0x0030abac:  1422      movs    r2, #0x14
0x0030abae:  011c      adds    r1, r0, #0
0x0030abb0:  6846      mov     r0, sp
0x0030abb2:  08f0e1f9  bl      #0x312f78  ; sub_00312f78
0x0030abb6:  0bf0aff8  bl      #0x315d18  ; sub_00315d18
0x0030abba:  051e      subs    r5, r0, #0
0x0030abbc:  48d0      beq     #0x30ac50
0x0030abbe:  0021      movs    r1, #0
0x0030abc0:  281c      adds    r0, r5, #0
0x0030abc2:  0222      movs    r2, #2
0x0030abc4:  0af0d4fe  bl      #0x315970  ; sub_00315970
0x0030abc8:  281c      adds    r0, r5, #0
0x0030abca:  6946      mov     r1, sp
0x0030abcc:  0bf05afa  bl      #0x316084  ; sub_00316084
0x0030abd0:  061e      subs    r6, r0, #0
0x0030abd2:  2cd0      beq     #0x30ac2e
0x0030abd4:  1f48      ldr     r0, [pc, #0x7c]  ; =0x0037d764 &"!FTPD-PORT:Bind"
0x0030abd6:  2cf0a5f9  bl      #0x336f24  ; sub_00336f24
0x0030abda:  281c      adds    r0, r5, #0
0x0030abdc:  0ef074fa  bl      #0x3190c8  ; sub_003190c8
0x0030abe0:  301c      adds    r0, r6, #0
0x0030abe2:  06e0      b       #0x30abf2
0x0030abe4:  8068      ldr     r0, [r0, #8]
0x0030abe6:  0028      cmp     r0, #0
0x0030abe8:  07d1      bne     #0x30abfa
0x0030abea:  1b48      ldr     r0, [pc, #0x6c]  ; =0x0037d774 &"!FTPD-PASV:No port"
0x0030abec:  2cf09af9  bl      #0x336f24  ; sub_00336f24
0x0030abf0:  0120      movs    r0, #1
0x0030abf2:  04b0      add     sp, #0x10
0x0030abf4:  f0bc      pop     {r4, r5, r6, r7}
0x0030abf6:  02bc      pop     {r1}
0x0030abf8:  0847      bx      r1
0x0030abfa:  1849      ldr     r1, [pc, #0x60]  ; =0x00002710
0x0030abfc:  2673      strb    r6, [r4, #0xc]
0x0030abfe:  0bf0fdfb  bl      #0x3163fc  ; sub_003163fc
0x0030ac02:  a068      ldr     r0, [r4, #8]
0x0030ac04:  0ef0d2f9  bl      #0x318fac  ; sub_00318fac
0x0030ac08:  0122      movs    r2, #1
0x0030ac0a:  051c      adds    r5, r0, #0
0x0030ac0c:  0121      movs    r1, #1
0x0030ac0e:  a068      ldr     r0, [r4, #8]
0x0030ac10:  5242      rsbs    r2, r2, #0
0x0030ac12:  0ff017fa  bl      #0x31a044  ; sub_0031a044
0x0030ac16:  a068      ldr     r0, [r4, #8]
0x0030ac18:  0ef056fa  bl      #0x3190c8  ; sub_003190c8
0x0030ac1c:  002d      cmp     r5, #0
0x0030ac1e:  15d0      beq     #0x30ac4c
0x0030ac20:  0020      movs    r0, #0
0x0030ac22:  a560      str     r5, [r4, #8]
0x0030ac24:  e5e7      b       #0x30abf2
0x0030ac26:  0e48      ldr     r0, [pc, #0x38]  ; =0x0037d788 &"!FTPD-PORT:No port specified"
0x0030ac28:  e0e7      b       #0x30abec
0x0030ac2a:  0e48      ldr     r0, [pc, #0x38]  ; =0x0037d7a8 &"!FTPD-PORT:Already open"
0x0030ac2c:  dee7      b       #0x30abec
0x0030ac2e:  281c      adds    r0, r5, #0
0x0030ac30:  0a49      ldr     r1, [pc, #0x28]  ; =0x00002710
0x0030ac32:  0bf0e3fb  bl      #0x3163fc  ; sub_003163fc
0x0030ac36:  281c      adds    r0, r5, #0
0x0030ac38:  391c      adds    r1, r7, #0
0x0030ac3a:  0cf0d3fc  bl      #0x3175e4  ; sub_003175e4
0x0030ac3e:  061e      subs    r6, r0, #0
0x0030ac40:  eed0      beq     #0x30ac20
0x0030ac42:  0948      ldr     r0, [pc, #0x24]  ; =0x0037d7c0 &"!FTPD-PORT:Connect %SS"
0x0030ac44:  391c      adds    r1, r7, #0
0x0030ac46:  2cf06df9  bl      #0x336f24  ; sub_00336f24
0x0030ac4a:  c6e7      b       #0x30abda
0x0030ac4c:  0748      ldr     r0, [pc, #0x1c]  ; =0x0037d7d8 &"!FTPD-PASV:Accept"
0x0030ac4e:  cde7      b       #0x30abec
0x0030ac50:  0748      ldr     r0, [pc, #0x1c]  ; =0x0037d7ec &"!FTPD-PORT:No TCB"
0x0030ac52:  cbe7      b       #0x30abec
0x0030ac54:  64d7      bvc     #0x30ad20
0x0030ac56:  3700      movs    r7, r6
0x0030ac58:  74d7      bvc     #0x30ad44
0x0030ac5a:  3700      movs    r7, r6
0x0030ac5c:  1027      movs    r7, #0x10
0x0030ac5e:  0000      movs    r0, r0
0x0030ac60:  88d7      bvc     #0x30ab74
0x0030ac62:  3700      movs    r7, r6
0x0030ac64:  a8d7      bvc     #0x30abb8
0x0030ac66:  3700      movs    r7, r6
0x0030ac68:  c0d7      bvc     #0x30abec
0x0030ac6a:  3700      movs    r7, r6
0x0030ac6c:  d8d7      bvc     #0x30ac20
0x0030ac6e:  3700      movs    r7, r6
0x0030ac70:  ecd7      bvc     #0x30ac4c
0x0030ac72:  3700      movs    r7, r6
0x0030ac74:  30b5      push    {r4, r5, lr}
0x0030ac76:  041c      adds    r4, r0, #0
0x0030ac78:  8068      ldr     r0, [r0, #8]
0x0030ac7a:  0025      movs    r5, #0
0x0030ac7c:  0028      cmp     r0, #0
0x0030ac7e:  03d1      bne     #0x30ac88
0x0030ac80:  281c      adds    r0, r5, #0
0x0030ac82:  30bc      pop     {r4, r5}
0x0030ac84:  02bc      pop     {r1}
0x0030ac86:  0847      bx      r1
0x0030ac88:  0122      movs    r2, #1
0x0030ac8a:  0121      movs    r1, #1
0x0030ac8c:  5242      rsbs    r2, r2, #0
0x0030ac8e:  0ff0d9f9  bl      #0x31a044  ; sub_0031a044
0x0030ac92:  051c      adds    r5, r0, #0
0x0030ac94:  a068      ldr     r0, [r4, #8]
0x0030ac96:  0ef017fa  bl      #0x3190c8  ; sub_003190c8
0x0030ac9a:  0023      movs    r3, #0
0x0030ac9c:  a360      str     r3, [r4, #8]
0x0030ac9e:  efe7      b       #0x30ac80
0x0030aca0:  30b5      push    {r4, r5, lr}
0x0030aca2:  041c      adds    r4, r0, #0
0x0030aca4:  8068      ldr     r0, [r0, #8]
0x0030aca6:  0028      cmp     r0, #0
0x0030aca8:  09d1      bne     #0x30acbe
0x0030acaa:  251c      adds    r5, r4, #0
0x0030acac:  c635      adds    r5, #0xc6
0x0030acae:  2b88      ldrh    r3, [r5]
0x0030acb0:  002b      cmp     r3, #0
0x0030acb2:  10d1      bne     #0x30acd6
0x0030acb4:  0323      movs    r3, #3
0x0030acb6:  2384      strh    r3, [r4, #0x20]
0x0030acb8:  30bc      pop     {r4, r5}
0x0030acba:  01bc      pop     {r0}
0x0030acbc:  0047      bx      r0
0x0030acbe:  0ef09ff8  bl      #0x318e00  ; sub_00318e00
0x0030acc2:  a068      ldr     r0, [r4, #8]
0x0030acc4:  0ef000fa  bl      #0x3190c8  ; sub_003190c8
0x0030acc8:  251c      adds    r5, r4, #0
0x0030acca:  0023      movs    r3, #0
0x0030accc:  a360      str     r3, [r4, #8]
0x0030acce:  c635      adds    r5, #0xc6
0x0030acd0:  2b88      ldrh    r3, [r5]
0x0030acd2:  002b      cmp     r3, #0
0x0030acd4:  eed0      beq     #0x30acb4
0x0030acd6:  231c      adds    r3, r4, #0
0x0030acd8:  221c      adds    r2, r4, #0
0x0030acda:  c033      adds    r3, #0xc0
0x0030acdc:  c432      adds    r2, #0xc4
0x0030acde:  1868      ldr     r0, [r3]
0x0030ace0:  1188      ldrh    r1, [r2]
0x0030ace2:  20f08bfe  bl      #0x32b9fc  ; sub_0032b9fc
0x0030ace6:  0023      movs    r3, #0
0x0030ace8:  2b80      strh    r3, [r5]
0x0030acea:  e3e7      b       #0x30acb4
0x0030acec:  30b5      push    {r4, r5, lr}
0x0030acee:  041c      adds    r4, r0, #0
0x0030acf0:  fff7e8fe  bl      #0x30aac4  ; sub_0030aac4
0x0030acf4:  051e      subs    r5, r0, #0
0x0030acf6:  45d0      beq     #0x30ad84
0x0030acf8:  0123      movs    r3, #1
0x0030acfa:  2b84      strh    r3, [r5, #0x20]
0x0030acfc:  2b1c      adds    r3, r5, #0
0x0030acfe:  b433      adds    r3, #0xb4
0x0030ad00:  1a68      ldr     r2, [r3]
0x0030ad02:  6c60      str     r4, [r5, #4]
0x0030ad04:  0024      movs    r4, #0
0x0030ad06:  ec73      strb    r4, [r5, #0xf]
0x0030ad08:  5368      ldr     r3, [r2, #4]
0x0030ad0a:  281c      adds    r0, r5, #0
0x0030ad0c:  ab62      str     r3, [r5, #0x28]
0x0030ad0e:  9368      ldr     r3, [r2, #8]
0x0030ad10:  2a1c      adds    r2, r5, #0
0x0030ad12:  ab85      strh    r3, [r5, #0x2c]
0x0030ad14:  0023      movs    r3, #0
0x0030ad16:  2b73      strb    r3, [r5, #0xc]
0x0030ad18:  1e4b      ldr     r3, [pc, #0x78]  ; =0x0033a6b4
0x0030ad1a:  b832      adds    r2, #0xb8
0x0030ad1c:  1360      str     r3, [r2]
0x0030ad1e:  1e49      ldr     r1, [pc, #0x78]  ; =0x0035ec68 &"unknown"
0x0030ad20:  0822      movs    r2, #8
0x0030ad22:  ac60      str     r4, [r5, #8]
0x0030ad24:  ac84      strh    r4, [r5, #0x24]
0x0030ad26:  3830      adds    r0, #0x38
0x0030ad28:  2cf0acf9  bl      #0x337084  ; sub_00337084
0x0030ad2c:  281c      adds    r0, r5, #0
0x0030ad2e:  2022      movs    r2, #0x20
0x0030ad30:  1a49      ldr     r1, [pc, #0x68]  ; =0x0035ec60 &"unknown"
0x0030ad32:  4130      adds    r0, #0x41
0x0030ad34:  2cf0a6f9  bl      #0x337084  ; sub_00337084
0x0030ad38:  2b1c      adds    r3, r5, #0
0x0030ad3a:  c033      adds    r3, #0xc0
0x0030ad3c:  1c60      str     r4, [r3]
0x0030ad3e:  0633      adds    r3, #6
0x0030ad40:  1c80      strh    r4, [r3]
0x0030ad42:  281c      adds    r0, r5, #0

===== sub_00316458 @ 0x00316458 =====
0x00316458:  f0b5      push    {r4, r5, r6, r7, lr}
0x0031645a:  5f46      mov     r7, fp
0x0031645c:  5646      mov     r6, sl
0x0031645e:  4d46      mov     r5, sb
0x00316460:  4446      mov     r4, r8
0x00316462:  f0b4      push    {r4, r5, r6, r7}
0x00316464:  0904      lsls    r1, r1, #0x10
0x00316466:  090c      lsrs    r1, r1, #0x10
0x00316468:  1204      lsls    r2, r2, #0x10
0x0031646a:  9db0      sub     sp, #0x74
0x0031646c:  8946      mov     sb, r1
0x0031646e:  110c      lsrs    r1, r2, #0x10
0x00316470:  1c91      str     r1, [sp, #0x70]
0x00316472:  dd49      ldr     r1, [pc, #0x374]  ; =0x002f2740
0x00316474:  8246      mov     sl, r0
0x00316476:  0b68      ldr     r3, [r1]
0x00316478:  0133      adds    r3, #1
0x0031647a:  0b60      str     r3, [r1]
0x0031647c:  5303      lsls    r3, r2, #0xd
0x0031647e:  03d5      bpl     #0x316488
0x00316480:  da4a      ldr     r2, [pc, #0x368]  ; =0x002f2520
0x00316482:  1368      ldr     r3, [r2]
0x00316484:  0133      adds    r3, #1
0x00316486:  1360      str     r3, [r2]
0x00316488:  5246      mov     r2, sl
0x0031648a:  9432      adds    r2, #0x94
0x0031648c:  0021      movs    r1, #0
0x0031648e:  1b91      str     r1, [sp, #0x6c]
0x00316490:  1368      ldr     r3, [r2]
0x00316492:  5146      mov     r1, sl
0x00316494:  9c31      adds    r1, #0x9c
0x00316496:  1a93      str     r3, [sp, #0x68]
0x00316498:  0e92      str     r2, [sp, #0x38]
0x0031649a:  0c91      str     r1, [sp, #0x30]
0x0031649c:  0a88      ldrh    r2, [r1]
0x0031649e:  5346      mov     r3, sl
0x003164a0:  1592      str     r2, [sp, #0x54]
0x003164a2:  9e33      adds    r3, #0x9e
0x003164a4:  1b88      ldrh    r3, [r3]
0x003164a6:  9342      cmp     r3, r2
0x003164a8:  00d2      bhs     #0x3164ac
0x003164aa:  1593      str     r3, [sp, #0x54]
0x003164ac:  5346      mov     r3, sl
0x003164ae:  9033      adds    r3, #0x90
0x003164b0:  1093      str     r3, [sp, #0x40]
0x003164b2:  1a99      ldr     r1, [sp, #0x68]
0x003164b4:  1b68      ldr     r3, [r3]
0x003164b6:  9942      cmp     r1, r3
0x003164b8:  00d5      bpl     #0x3164bc
0x003164ba:  dfe1      b       #0x31687c
0x003164bc:  4b46      mov     r3, sb
0x003164be:  002b      cmp     r3, #0
0x003164c0:  00d0      beq     #0x3164c4
0x003164c2:  8ae1      b       #0x3167da
0x003164c4:  1c9a      ldr     r2, [sp, #0x70]
0x003164c6:  0323      movs    r3, #3
0x003164c8:  1a42      tst     r2, r3
0x003164ca:  0ad0      beq     #0x3164e2
0x003164cc:  8a22      movs    r2, #0x8a
0x003164ce:  5200      lsls    r2, r2, #1
0x003164d0:  5244      add     r2, sl
0x003164d2:  1368      ldr     r3, [r2]
0x003164d4:  002b      cmp     r3, #0
0x003164d6:  04d1      bne     #0x3164e2
0x003164d8:  8c23      movs    r3, #0x8c
0x003164da:  5b00      lsls    r3, r3, #1
0x003164dc:  5344      add     r3, sl
0x003164de:  1b68      ldr     r3, [r3]
0x003164e0:  1360      str     r3, [r2]
0x003164e2:  5346      mov     r3, sl
0x003164e4:  5833      adds    r3, #0x58
0x003164e6:  0893      str     r3, [sp, #0x20]
0x003164e8:  1888      ldrh    r0, [r3]
0x003164ea:  5030      adds    r0, #0x50
0x003164ec:  0004      lsls    r0, r0, #0x10
0x003164ee:  000c      lsrs    r0, r0, #0x10
0x003164f0:  fff7c8fa  bl      #0x315a84  ; sub_00315a84
0x003164f4:  0028      cmp     r0, #0
0x003164f6:  1990      str     r0, [sp, #0x64]
0x003164f8:  00d1      bne     #0x3164fc
0x003164fa:  17e2      b       #0x31692c
0x003164fc:  1999      ldr     r1, [sp, #0x64]
0x003164fe:  199e      ldr     r6, [sp, #0x64]
0x00316500:  1c9b      ldr     r3, [sp, #0x70]
0x00316502:  5031      adds    r1, #0x50
0x00316504:  1422      movs    r2, #0x14
0x00316506:  8b46      mov     fp, r1
0x00316508:  1492      str     r2, [sp, #0x50]
0x0031650a:  6436      adds    r6, #0x64
0x0031650c:  0025      movs    r5, #0
0x0031650e:  9b07      lsls    r3, r3, #0x1e
0x00316510:  00d5      bpl     #0x316514
0x00316512:  86e1      b       #0x316822
0x00316514:  1c99      ldr     r1, [sp, #0x70]
0x00316516:  c906      lsls    r1, r1, #0x1b
0x00316518:  00d4      bmi     #0x31651c
0x0031651a:  6fe1      b       #0x3167fc
0x0031651c:  5346      mov     r3, sl
0x0031651e:  1a69      ldr     r2, [r3, #0x10]
0x00316520:  0123      movs    r3, #1
0x00316522:  9208      lsrs    r2, r2, #2
0x00316524:  1a42      tst     r2, r3
0x00316526:  00d1      bne     #0x31652a
0x00316528:  a1e1      b       #0x31686e
0x0031652a:  b149      ldr     r1, [pc, #0x2c4]  ; =0x0000013b
0x0031652c:  5144      add     r1, sl
0x0031652e:  0a91      str     r1, [sp, #0x28]
0x00316530:  0b78      ldrb    r3, [r1]
0x00316532:  002b      cmp     r3, #0
0x00316534:  00d1      bne     #0x316538
0x00316536:  64e1      b       #0x316802
0x00316538:  0323      movs    r3, #3
0x0031653a:  2b40      ands    r3, r5
0x0031653c:  022b      cmp     r3, #2
0x0031653e:  0ad0      beq     #0x316556
0x00316540:  0121      movs    r1, #1
0x00316542:  0322      movs    r2, #3
0x00316544:  a955      strb    r1, [r5, r6]
0x00316546:  149b      ldr     r3, [sp, #0x50]
0x00316548:  0135      adds    r5, #1
0x0031654a:  0133      adds    r3, #1
0x0031654c:  1493      str     r3, [sp, #0x50]
0x0031654e:  2b1c      adds    r3, r5, #0
0x00316550:  1340      ands    r3, r2
0x00316552:  022b      cmp     r3, #2
0x00316554:  f6d1      bne     #0x316544
0x00316556:  0a99      ldr     r1, [sp, #0x28]
0x00316558:  0523      movs    r3, #5
0x0031655a:  0978      ldrb    r1, [r1]
0x0031655c:  1391      str     r1, [sp, #0x4c]
0x0031655e:  ab55      strb    r3, [r5, r6]
0x00316560:  cb00      lsls    r3, r1, #3
0x00316562:  0233      adds    r3, #2
0x00316564:  0135      adds    r5, #1
0x00316566:  ab55      strb    r3, [r5, r6]
0x00316568:  9846      mov     r8, r3
0x0031656a:  149b      ldr     r3, [sp, #0x50]
0x0031656c:  139a      ldr     r2, [sp, #0x4c]
0x0031656e:  4344      add     r3, r8
0x00316570:  0021      movs    r1, #0
0x00316572:  0135      adds    r5, #1
0x00316574:  1493      str     r3, [sp, #0x50]
0x00316576:  8846      mov     r8, r1
0x00316578:  002a      cmp     r2, #0
0x0031657a:  00dc      bgt     #0x31657e
0x0031657c:  d2e1      b       #0x316924
0x0031657e:  5346      mov     r3, sl
0x00316580:  9e27      movs    r7, #0x9e
0x00316582:  c033      adds    r3, #0xc0
0x00316584:  7f00      lsls    r7, r7, #1
0x00316586:  0b93      str     r3, [sp, #0x2c]
0x00316588:  5744      add     r7, sl
0x0031658a:  0b99      ldr     r1, [sp, #0x2c]
0x0031658c:  3b88      ldrh    r3, [r7]
0x0031658e:  0c68      ldr     r4, [r1]
0x00316590:  e418      adds    r4, r4, r3
0x00316592:  201c      adds    r0, r4, #0
0x00316594:  1ff082fe  bl      #0x33629c  ; sub_0033629c
0x00316598:  011c      adds    r1, r0, #0
0x0031659a:  7019      adds    r0, r6, r5
0x0031659c:  1ff098fe  bl      #0x3362d0  ; sub_003362d0
0x003165a0:  7888      ldrh    r0, [r7, #2]
0x003165a2:  0435      adds    r5, #4
0x003165a4:  2018      adds    r0, r4, r0
0x003165a6:  1ff079fe  bl      #0x33629c  ; sub_0033629c
0x003165aa:  011c      adds    r1, r0, #0
0x003165ac:  7019      adds    r0, r6, r5
0x003165ae:  1ff08ffe  bl      #0x3362d0  ; sub_003362d0
0x003165b2:  0122      movs    r2, #1
0x003165b4:  139b      ldr     r3, [sp, #0x4c]
0x003165b6:  9044      add     r8, r2
0x003165b8:  0435      adds    r5, #4
0x003165ba:  0837      adds    r7, #8
0x003165bc:  9845      cmp     r8, r3
0x003165be:  e4db      blt     #0x31658a
0x003165c0:  0323      movs    r3, #3
0x003165c2:  1d42      tst     r5, r3
0x003165c4:  00d0      beq     #0x3165c8
0x003165c6:  23e1      b       #0x316810
0x003165c8:  149a      ldr     r2, [sp, #0x50]
0x003165ca:  8a4b      ldr     r3, [pc, #0x228]  ; =0x0000fffc
0x003165cc:  0332      adds    r2, #3
0x003165ce:  1a40      ands    r2, r3
0x003165d0:  5146      mov     r1, sl
0x003165d2:  5346      mov     r3, sl
0x003165d4:  8033      adds    r3, #0x80
0x003165d6:  096f      ldr     r1, [r1, #0x70]
0x003165d8:  1868      ldr     r0, [r3]
0x003165da:  1492      str     r2, [sp, #0x50]
0x003165dc:  5a44      add     r2, fp
0x003165de:  1892      str     r2, [sp, #0x60]
0x003165e0:  1691      str     r1, [sp, #0x58]
0x003165e2:  1ff05bfe  bl      #0x33629c  ; sub_0033629c
0x003165e6:  1790      str     r0, [sp, #0x5c]
0x003165e8:  1698      ldr     r0, [sp, #0x58]
0x003165ea:  1ff057fe  bl      #0x33629c  ; sub_0033629c
0x003165ee:  5246      mov     r2, sl
0x003165f0:  9832      adds    r2, #0x98
0x003165f2:  1368      ldr     r3, [r2]
0x003165f4:  1a99      ldr     r1, [sp, #0x68]
0x003165f6:  0d92      str     r2, [sp, #0x34]
0x003165f8:  cb1a      subs    r3, r1, r3
0x003165fa:  1b04      lsls    r3, r3, #0x10
0x003165fc:  1f0c      lsrs    r7, r3, #0x10
0x003165fe:  5b46      mov     r3, fp
0x00316600:  0233      adds    r3, #2
0x00316602:  5146      mov     r1, sl
0x00316604:  2a3a      subs    r2, #0x2a
0x00316606:  7e31      adds    r1, #0x7e
0x00316608:  0593      str     r3, [sp, #0x14]
0x0031660a:  0633      adds    r3, #6
0x0031660c:  0792      str     r2, [sp, #0x1c]
0x0031660e:  0691      str     r1, [sp, #0x18]
0x00316610:  5a46      mov     r2, fp
0x00316612:  4e31      adds    r1, #0x4e
0x00316614:  0393      str     r3, [sp, #0xc]
0x00316616:  0a33      adds    r3, #0xa
0x00316618:  0432      adds    r2, #4
0x0031661a:  0991      str     r1, [sp, #0x24]
0x0031661c:  0f93      str     r3, [sp, #0x3c]
0x0031661e:  5946      mov     r1, fp
0x00316620:  149b      ldr     r3, [sp, #0x50]
0x00316622:  1031      adds    r1, #0x10
0x00316624:  0492      str     r2, [sp, #0x10]
0x00316626:  0a32      adds    r2, #0xa
0x00316628:  0292      str     r2, [sp, #8]
0x0031662a:  1191      str     r1, [sp, #0x44]
0x0031662c:  9a02      lsls    r2, r3, #0xa
0x0031662e:  1c99      ldr     r1, [sp, #0x70]
0x00316630:  714b      ldr     r3, [pc, #0x1c4]  ; =0x00000fff
0x00316632:  1690      str     r0, [sp, #0x58]
0x00316634:  0b40      ands    r3, r1
0x00316636:  1a43      orrs    r2, r3

===== sub_003341b8 @ 0x003341b8 =====
0x003341b8:  00b5      push    {lr}
0x003341ba:  05f0f5fe  bl      #0x339fa8  ; sub_00339fa8
0x003341be:  044a      ldr     r2, [pc, #0x10]  ; =0x002f5b90
0x003341c0:  1388      ldrh    r3, [r2]
0x003341c2:  0133      adds    r3, #1
0x003341c4:  1380      strh    r3, [r2]
0x003341c6:  05f0f3fe  bl      #0x339fb0  ; sub_00339fb0
0x003341ca:  01bc      pop     {r0}
0x003341cc:  0047      bx      r0
0x003341ce:  0000      movs    r0, r0
0x003341d0:  905b      ldrh    r0, [r2, r6]
0x003341d2:  2f00      movs    r7, r5
0x003341d4:  10b5      push    {r4, lr}
0x003341d6:  05f0e7fe  bl      #0x339fa8  ; sub_00339fa8
0x003341da:  084a      ldr     r2, [pc, #0x20]  ; =0x002f5b90
0x003341dc:  041c      adds    r4, r0, #0
0x003341de:  1388      ldrh    r3, [r2]
0x003341e0:  013b      subs    r3, #1
0x003341e2:  1380      strh    r3, [r2]
0x003341e4:  1b04      lsls    r3, r3, #0x10
0x003341e6:  002b      cmp     r3, #0
0x003341e8:  05d0      beq     #0x3341f6
0x003341ea:  201c      adds    r0, r4, #0
0x003341ec:  05f0e0fe  bl      #0x339fb0  ; sub_00339fb0
0x003341f0:  10bc      pop     {r4}
0x003341f2:  01bc      pop     {r0}
0x003341f4:  0047      bx      r0
0x003341f6:  fff7b3ff  bl      #0x334160  ; sub_00334160
0x003341fa:  f6e7      b       #0x3341ea
0x003341fc:  905b      ldrh    r0, [r2, r6]
0x003341fe:  2f00      movs    r7, r5
0x00334200:  10b5      push    {r4, lr}
0x00334202:  064c      ldr     r4, [pc, #0x18]  ; =0x002f5fd0
0x00334204:  2288      ldrh    r2, [r4]
0x00334206:  002a      cmp     r2, #0
0x00334208:  04d0      beq     #0x334214
0x0033420a:  531c      adds    r3, r2, #1
0x0033420c:  2380      strh    r3, [r4]
0x0033420e:  10bc      pop     {r4}
0x00334210:  01bc      pop     {r0}
0x00334212:  0047      bx      r0
0x00334214:  05f000ff  bl      #0x33a018  ; sub_0033a018
0x00334218:  2288      ldrh    r2, [r4]
0x0033421a:  f6e7      b       #0x33420a
0x0033421c:  d05f      ldrsh   r0, [r2, r7]
0x0033421e:  2f00      movs    r7, r5
0x00334220:  00b5      push    {lr}
0x00334222:  064a      ldr     r2, [pc, #0x18]  ; =0x002f5fd0
0x00334224:  1388      ldrh    r3, [r2]
0x00334226:  013b      subs    r3, #1
0x00334228:  1380      strh    r3, [r2]
0x0033422a:  1b04      lsls    r3, r3, #0x10
0x0033422c:  002b      cmp     r3, #0
0x0033422e:  01d0      beq     #0x334234
0x00334230:  01bc      pop     {r0}
0x00334232:  0047      bx      r0
0x00334234:  05f0f4fe  bl      #0x33a020  ; sub_0033a020
0x00334238:  fae7      b       #0x334230
0x0033423a:  0000      movs    r0, r0
0x0033423c:  d05f      ldrsh   r0, [r2, r7]
0x0033423e:  2f00      movs    r7, r5
0x00334240:  70b5      push    {r4, r5, r6, lr}
0x00334242:  0268      ldr     r2, [r0]
0x00334244:  051c      adds    r5, r0, #0
0x00334246:  0e1c      adds    r6, r1, #0
0x00334248:  0024      movs    r4, #0
0x0033424a:  0120      movs    r0, #1
0x0033424c:  08e0      b       #0x334260
0x0033424e:  9368      ldr     r3, [r2, #8]
0x00334250:  5988      ldrh    r1, [r3, #2]
0x00334252:  8142      cmp     r1, r0
0x00334254:  06d3      blo     #0x334264
0x00334256:  4b1c      adds    r3, r1, #1
0x00334258:  1b04      lsls    r3, r3, #0x10
0x0033425a:  141c      adds    r4, r2, #0
0x0033425c:  1268      ldr     r2, [r2]
0x0033425e:  180c      lsrs    r0, r3, #0x10
0x00334260:  002a      cmp     r2, #0
0x00334262:  f4d1      bne     #0x33424e
0x00334264:  321c      adds    r2, r6, #0
0x00334266:  7080      strh    r0, [r6, #2]
0x00334268:  211c      adds    r1, r4, #0
0x0033426a:  281c      adds    r0, r5, #0
0x0033426c:  0832      adds    r2, #8
0x0033426e:  03f0c1f8  bl      #0x3373f4  ; sub_003373f4
0x00334272:  70bc      pop     {r4, r5, r6}
0x00334274:  01bc      pop     {r0}
0x00334276:  0047      bx      r0
0x00334278:  70b5      push    {r4, r5, r6, lr}
0x0033427a:  ca8e      ldrh    r2, [r1, #0x36]
0x0033427c:  4c69      ldr     r4, [r1, #0x14]
0x0033427e:  061c      adds    r6, r0, #0
0x00334280:  0025      movs    r5, #0
0x00334282:  05e0      b       #0x334290
0x00334284:  a368      ldr     r3, [r4, #8]
0x00334286:  db8e      ldrh    r3, [r3, #0x36]
0x00334288:  9342      cmp     r3, r2
0x0033428a:  03d1      bne     #0x334294
0x0033428c:  251c      adds    r5, r4, #0
0x0033428e:  2468      ldr     r4, [r4]
0x00334290:  002c      cmp     r4, #0
0x00334292:  f7d1      bne     #0x334284
0x00334294:  0c1c      adds    r4, r1, #0
0x00334296:  1434      adds    r4, #0x14
0x00334298:  002d      cmp     r5, #0
0x0033429a:  0ad0      beq     #0x3342b2
0x0033429c:  ac42      cmp     r4, r5
0x0033429e:  08d0      beq     #0x3342b2
0x003342a0:  301c      adds    r0, r6, #0
0x003342a2:  211c      adds    r1, r4, #0
0x003342a4:  03f004f9  bl      #0x3374b0  ; sub_003374b0
0x003342a8:  301c      adds    r0, r6, #0
0x003342aa:  291c      adds    r1, r5, #0
0x003342ac:  221c      adds    r2, r4, #0
0x003342ae:  03f0a1f8  bl      #0x3373f4  ; sub_003373f4
0x003342b2:  70bc      pop     {r4, r5, r6}
0x003342b4:  01bc      pop     {r0}
0x003342b6:  0047      bx      r0
0x003342b8:  30b5      push    {r4, r5, lr}
0x003342ba:  041c      adds    r4, r0, #0
0x003342bc:  0d1c      adds    r5, r1, #0
0x003342be:  e88e      ldrh    r0, [r5, #0x36]
0x003342c0:  2268      ldr     r2, [r4]
0x003342c2:  0021      movs    r1, #0
0x003342c4:  2c62      str     r4, [r5, #0x20]
0x003342c6:  05e0      b       #0x3342d4
0x003342c8:  9368      ldr     r3, [r2, #8]
0x003342ca:  db8e      ldrh    r3, [r3, #0x36]
0x003342cc:  8342      cmp     r3, r0
0x003342ce:  03d8      bhi     #0x3342d8
0x003342d0:  111c      adds    r1, r2, #0
0x003342d2:  1268      ldr     r2, [r2]
0x003342d4:  002a      cmp     r2, #0
0x003342d6:  f7d1      bne     #0x3342c8
0x003342d8:  2a1c      adds    r2, r5, #0
0x003342da:  201c      adds    r0, r4, #0
0x003342dc:  1432      adds    r2, #0x14
0x003342de:  03f089f8  bl      #0x3373f4  ; sub_003373f4
0x003342e2:  30bc      pop     {r4, r5}
0x003342e4:  01bc      pop     {r0}
0x003342e6:  0047      bx      r0
0x003342e8:  10b5      push    {r4, lr}
0x003342ea:  041c      adds    r4, r0, #0
0x003342ec:  211c      adds    r1, r4, #0
0x003342ee:  0848      ldr     r0, [pc, #0x20]  ; =0x002f5a40
0x003342f0:  5431      adds    r1, #0x54
0x003342f2:  03f0ddf8  bl      #0x3374b0  ; sub_003374b0
0x003342f6:  206a      ldr     r0, [r4, #0x20]
0x003342f8:  0028      cmp     r0, #0
0x003342fa:  04d1      bne     #0x334306
0x003342fc:  0023      movs    r3, #0
0x003342fe:  2362      str     r3, [r4, #0x20]
0x00334300:  10bc      pop     {r4}
0x00334302:  01bc      pop     {r0}
0x00334304:  0047      bx      r0
0x00334306:  211c      adds    r1, r4, #0
0x00334308:  1431      adds    r1, #0x14
0x0033430a:  03f0d1f8  bl      #0x3374b0  ; sub_003374b0
0x0033430e:  f5e7      b       #0x3342fc
0x00334310:  405a      ldrh    r0, [r0, r1]
0x00334312:  2f00      movs    r7, r5
0x00334314:  70b5      push    {r4, r5, r6, lr}
0x00334316:  051c      adds    r5, r0, #0
0x00334318:  05f046fe  bl      #0x339fa8  ; sub_00339fa8
0x0033431c:  061c      adds    r6, r0, #0
0x0033431e:  002d      cmp     r5, #0
0x00334320:  17d0      beq     #0x334352
0x00334322:  286a      ldr     r0, [r5, #0x20]
0x00334324:  0028      cmp     r0, #0
0x00334326:  0fd1      bne     #0x334348
0x00334328:  0024      movs    r4, #0
0x0033432a:  291c      adds    r1, r5, #0
0x0033432c:  0831      adds    r1, #8
0x0033432e:  2c62      str     r4, [r5, #0x20]
0x00334330:  0948      ldr     r0, [pc, #0x24]  ; =0x002f5b60
0x00334332:  03f0bdf8  bl      #0x3374b0  ; sub_003374b0
0x00334336:  2c80      strh    r4, [r5]
0x00334338:  fff712ff  bl      #0x334160  ; sub_00334160
0x0033433c:  301c      adds    r0, r6, #0
0x0033433e:  05f037fe  bl      #0x339fb0  ; sub_00339fb0
0x00334342:  70bc      pop     {r4, r5, r6}
0x00334344:  01bc      pop     {r0}
0x00334346:  0047      bx      r0
0x00334348:  291c      adds    r1, r5, #0
0x0033434a:  1431      adds    r1, #0x14
0x0033434c:  03f0b0f8  bl      #0x3374b0  ; sub_003374b0
0x00334350:  eae7      b       #0x334328
0x00334352:  024b      ldr     r3, [pc, #8]  ; =0x002f6000
0x00334354:  1d68      ldr     r5, [r3]
0x00334356:  e4e7      b       #0x334322
0x00334358:  605b      ldrh    r0, [r4, r5]
0x0033435a:  2f00      movs    r7, r5
0x0033435c:  0060      str     r0, [r0]
0x0033435e:  2f00      movs    r7, r5
0x00334360:  f0b5      push    {r4, r5, r6, r7, lr}
0x00334362:  5746      mov     r7, sl
0x00334364:  4646      mov     r6, r8
0x00334366:  c0b4      push    {r6, r7}
0x00334368:  071c      adds    r7, r0, #0
0x0033436a:  8a46      mov     sl, r1
0x0033436c:  0830      adds    r0, #8
0x0033436e:  391c      adds    r1, r7, #0
0x00334370:  161c      adds    r6, r2, #0
0x00334372:  9846      mov     r8, r3
0x00334374:  079c      ldr     r4, [sp, #0x1c]
0x00334376:  089d      ldr     r5, [sp, #0x20]
0x00334378:  03f036f8  bl      #0x3373e8  ; sub_003373e8
0x0033437c:  381c      adds    r0, r7, #0
0x0033437e:  1430      adds    r0, #0x14
0x00334380:  391c      adds    r1, r7, #0
0x00334382:  03f031f8  bl      #0x3373e8  ; sub_003373e8
0x00334386:  381c      adds    r0, r7, #0
0x00334388:  5430      adds    r0, #0x54
0x0033438a:  391c      adds    r1, r7, #0
0x0033438c:  03f02cf8  bl      #0x3373e8  ; sub_003373e8
0x00334390:  184b      ldr     r3, [pc, #0x60]  ; =0x00005441
0x00334392:  4246      mov     r2, r8
0x00334394:  fa62      str     r2, [r7, #0x2c]
0x00334396:  2404      lsls    r4, r4, #0x10

===== sub_003341d4 @ 0x003341d4 =====
0x003341d4:  10b5      push    {r4, lr}
0x003341d6:  05f0e7fe  bl      #0x339fa8  ; sub_00339fa8
0x003341da:  084a      ldr     r2, [pc, #0x20]  ; =0x002f5b90
0x003341dc:  041c      adds    r4, r0, #0
0x003341de:  1388      ldrh    r3, [r2]
0x003341e0:  013b      subs    r3, #1
0x003341e2:  1380      strh    r3, [r2]
0x003341e4:  1b04      lsls    r3, r3, #0x10
0x003341e6:  002b      cmp     r3, #0
0x003341e8:  05d0      beq     #0x3341f6
0x003341ea:  201c      adds    r0, r4, #0
0x003341ec:  05f0e0fe  bl      #0x339fb0  ; sub_00339fb0
0x003341f0:  10bc      pop     {r4}
0x003341f2:  01bc      pop     {r0}
0x003341f4:  0047      bx      r0
0x003341f6:  fff7b3ff  bl      #0x334160  ; sub_00334160
0x003341fa:  f6e7      b       #0x3341ea
0x003341fc:  905b      ldrh    r0, [r2, r6]
0x003341fe:  2f00      movs    r7, r5
0x00334200:  10b5      push    {r4, lr}
0x00334202:  064c      ldr     r4, [pc, #0x18]  ; =0x002f5fd0
0x00334204:  2288      ldrh    r2, [r4]
0x00334206:  002a      cmp     r2, #0
0x00334208:  04d0      beq     #0x334214
0x0033420a:  531c      adds    r3, r2, #1
0x0033420c:  2380      strh    r3, [r4]
0x0033420e:  10bc      pop     {r4}
0x00334210:  01bc      pop     {r0}
0x00334212:  0047      bx      r0
0x00334214:  05f000ff  bl      #0x33a018  ; sub_0033a018
0x00334218:  2288      ldrh    r2, [r4]
0x0033421a:  f6e7      b       #0x33420a
0x0033421c:  d05f      ldrsh   r0, [r2, r7]
0x0033421e:  2f00      movs    r7, r5
0x00334220:  00b5      push    {lr}
0x00334222:  064a      ldr     r2, [pc, #0x18]  ; =0x002f5fd0
0x00334224:  1388      ldrh    r3, [r2]
0x00334226:  013b      subs    r3, #1
0x00334228:  1380      strh    r3, [r2]
0x0033422a:  1b04      lsls    r3, r3, #0x10
0x0033422c:  002b      cmp     r3, #0
0x0033422e:  01d0      beq     #0x334234
0x00334230:  01bc      pop     {r0}
0x00334232:  0047      bx      r0
0x00334234:  05f0f4fe  bl      #0x33a020  ; sub_0033a020
0x00334238:  fae7      b       #0x334230
0x0033423a:  0000      movs    r0, r0
0x0033423c:  d05f      ldrsh   r0, [r2, r7]
0x0033423e:  2f00      movs    r7, r5
0x00334240:  70b5      push    {r4, r5, r6, lr}
0x00334242:  0268      ldr     r2, [r0]
0x00334244:  051c      adds    r5, r0, #0
0x00334246:  0e1c      adds    r6, r1, #0
0x00334248:  0024      movs    r4, #0
0x0033424a:  0120      movs    r0, #1
0x0033424c:  08e0      b       #0x334260
0x0033424e:  9368      ldr     r3, [r2, #8]
0x00334250:  5988      ldrh    r1, [r3, #2]
0x00334252:  8142      cmp     r1, r0
0x00334254:  06d3      blo     #0x334264
0x00334256:  4b1c      adds    r3, r1, #1
0x00334258:  1b04      lsls    r3, r3, #0x10
0x0033425a:  141c      adds    r4, r2, #0
0x0033425c:  1268      ldr     r2, [r2]
0x0033425e:  180c      lsrs    r0, r3, #0x10
0x00334260:  002a      cmp     r2, #0
0x00334262:  f4d1      bne     #0x33424e
0x00334264:  321c      adds    r2, r6, #0
0x00334266:  7080      strh    r0, [r6, #2]
0x00334268:  211c      adds    r1, r4, #0
0x0033426a:  281c      adds    r0, r5, #0
0x0033426c:  0832      adds    r2, #8
0x0033426e:  03f0c1f8  bl      #0x3373f4  ; sub_003373f4
0x00334272:  70bc      pop     {r4, r5, r6}
0x00334274:  01bc      pop     {r0}
0x00334276:  0047      bx      r0
0x00334278:  70b5      push    {r4, r5, r6, lr}
0x0033427a:  ca8e      ldrh    r2, [r1, #0x36]
0x0033427c:  4c69      ldr     r4, [r1, #0x14]
0x0033427e:  061c      adds    r6, r0, #0
0x00334280:  0025      movs    r5, #0
0x00334282:  05e0      b       #0x334290
0x00334284:  a368      ldr     r3, [r4, #8]
0x00334286:  db8e      ldrh    r3, [r3, #0x36]
0x00334288:  9342      cmp     r3, r2
0x0033428a:  03d1      bne     #0x334294
0x0033428c:  251c      adds    r5, r4, #0
0x0033428e:  2468      ldr     r4, [r4]
0x00334290:  002c      cmp     r4, #0
0x00334292:  f7d1      bne     #0x334284
0x00334294:  0c1c      adds    r4, r1, #0
0x00334296:  1434      adds    r4, #0x14
0x00334298:  002d      cmp     r5, #0
0x0033429a:  0ad0      beq     #0x3342b2
0x0033429c:  ac42      cmp     r4, r5
0x0033429e:  08d0      beq     #0x3342b2
0x003342a0:  301c      adds    r0, r6, #0
0x003342a2:  211c      adds    r1, r4, #0
0x003342a4:  03f004f9  bl      #0x3374b0  ; sub_003374b0
0x003342a8:  301c      adds    r0, r6, #0
0x003342aa:  291c      adds    r1, r5, #0
0x003342ac:  221c      adds    r2, r4, #0
0x003342ae:  03f0a1f8  bl      #0x3373f4  ; sub_003373f4
0x003342b2:  70bc      pop     {r4, r5, r6}
0x003342b4:  01bc      pop     {r0}
0x003342b6:  0047      bx      r0
0x003342b8:  30b5      push    {r4, r5, lr}
0x003342ba:  041c      adds    r4, r0, #0
0x003342bc:  0d1c      adds    r5, r1, #0
0x003342be:  e88e      ldrh    r0, [r5, #0x36]
0x003342c0:  2268      ldr     r2, [r4]
0x003342c2:  0021      movs    r1, #0
0x003342c4:  2c62      str     r4, [r5, #0x20]
0x003342c6:  05e0      b       #0x3342d4
0x003342c8:  9368      ldr     r3, [r2, #8]
0x003342ca:  db8e      ldrh    r3, [r3, #0x36]
0x003342cc:  8342      cmp     r3, r0
0x003342ce:  03d8      bhi     #0x3342d8
0x003342d0:  111c      adds    r1, r2, #0
0x003342d2:  1268      ldr     r2, [r2]
0x003342d4:  002a      cmp     r2, #0
0x003342d6:  f7d1      bne     #0x3342c8
0x003342d8:  2a1c      adds    r2, r5, #0
0x003342da:  201c      adds    r0, r4, #0
0x003342dc:  1432      adds    r2, #0x14
0x003342de:  03f089f8  bl      #0x3373f4  ; sub_003373f4
0x003342e2:  30bc      pop     {r4, r5}
0x003342e4:  01bc      pop     {r0}
0x003342e6:  0047      bx      r0
0x003342e8:  10b5      push    {r4, lr}
0x003342ea:  041c      adds    r4, r0, #0
0x003342ec:  211c      adds    r1, r4, #0
0x003342ee:  0848      ldr     r0, [pc, #0x20]  ; =0x002f5a40
0x003342f0:  5431      adds    r1, #0x54
0x003342f2:  03f0ddf8  bl      #0x3374b0  ; sub_003374b0
0x003342f6:  206a      ldr     r0, [r4, #0x20]
0x003342f8:  0028      cmp     r0, #0
0x003342fa:  04d1      bne     #0x334306
0x003342fc:  0023      movs    r3, #0
0x003342fe:  2362      str     r3, [r4, #0x20]
0x00334300:  10bc      pop     {r4}
0x00334302:  01bc      pop     {r0}
0x00334304:  0047      bx      r0
0x00334306:  211c      adds    r1, r4, #0
0x00334308:  1431      adds    r1, #0x14
0x0033430a:  03f0d1f8  bl      #0x3374b0  ; sub_003374b0
0x0033430e:  f5e7      b       #0x3342fc
0x00334310:  405a      ldrh    r0, [r0, r1]
0x00334312:  2f00      movs    r7, r5
0x00334314:  70b5      push    {r4, r5, r6, lr}
0x00334316:  051c      adds    r5, r0, #0
0x00334318:  05f046fe  bl      #0x339fa8  ; sub_00339fa8
0x0033431c:  061c      adds    r6, r0, #0
0x0033431e:  002d      cmp     r5, #0
0x00334320:  17d0      beq     #0x334352
0x00334322:  286a      ldr     r0, [r5, #0x20]
0x00334324:  0028      cmp     r0, #0
0x00334326:  0fd1      bne     #0x334348
0x00334328:  0024      movs    r4, #0
0x0033432a:  291c      adds    r1, r5, #0
0x0033432c:  0831      adds    r1, #8
0x0033432e:  2c62      str     r4, [r5, #0x20]
0x00334330:  0948      ldr     r0, [pc, #0x24]  ; =0x002f5b60
0x00334332:  03f0bdf8  bl      #0x3374b0  ; sub_003374b0
0x00334336:  2c80      strh    r4, [r5]
0x00334338:  fff712ff  bl      #0x334160  ; sub_00334160
0x0033433c:  301c      adds    r0, r6, #0
0x0033433e:  05f037fe  bl      #0x339fb0  ; sub_00339fb0
0x00334342:  70bc      pop     {r4, r5, r6}
0x00334344:  01bc      pop     {r0}
0x00334346:  0047      bx      r0
0x00334348:  291c      adds    r1, r5, #0
0x0033434a:  1431      adds    r1, #0x14
0x0033434c:  03f0b0f8  bl      #0x3374b0  ; sub_003374b0
0x00334350:  eae7      b       #0x334328
0x00334352:  024b      ldr     r3, [pc, #8]  ; =0x002f6000
0x00334354:  1d68      ldr     r5, [r3]
0x00334356:  e4e7      b       #0x334322
0x00334358:  605b      ldrh    r0, [r4, r5]
0x0033435a:  2f00      movs    r7, r5
0x0033435c:  0060      str     r0, [r0]
0x0033435e:  2f00      movs    r7, r5
0x00334360:  f0b5      push    {r4, r5, r6, r7, lr}
0x00334362:  5746      mov     r7, sl
0x00334364:  4646      mov     r6, r8
0x00334366:  c0b4      push    {r6, r7}
0x00334368:  071c      adds    r7, r0, #0
0x0033436a:  8a46      mov     sl, r1
0x0033436c:  0830      adds    r0, #8
0x0033436e:  391c      adds    r1, r7, #0
0x00334370:  161c      adds    r6, r2, #0
0x00334372:  9846      mov     r8, r3
0x00334374:  079c      ldr     r4, [sp, #0x1c]
0x00334376:  089d      ldr     r5, [sp, #0x20]
0x00334378:  03f036f8  bl      #0x3373e8  ; sub_003373e8
0x0033437c:  381c      adds    r0, r7, #0
0x0033437e:  1430      adds    r0, #0x14
0x00334380:  391c      adds    r1, r7, #0
0x00334382:  03f031f8  bl      #0x3373e8  ; sub_003373e8
0x00334386:  381c      adds    r0, r7, #0
0x00334388:  5430      adds    r0, #0x54
0x0033438a:  391c      adds    r1, r7, #0
0x0033438c:  03f02cf8  bl      #0x3373e8  ; sub_003373e8
0x00334390:  184b      ldr     r3, [pc, #0x60]  ; =0x00005441
0x00334392:  4246      mov     r2, r8
0x00334394:  fa62      str     r2, [r7, #0x2c]
0x00334396:  2404      lsls    r4, r4, #0x10
0x00334398:  0122      movs    r2, #1
0x0033439a:  3b80      strh    r3, [r7]
0x0033439c:  3a86      strh    r2, [r7, #0x30]
0x0033439e:  0023      movs    r3, #0
0x003343a0:  7a86      strh    r2, [r7, #0x32]
0x003343a2:  240c      lsrs    r4, r4, #0x10
0x003343a4:  5246      mov     r2, sl
0x003343a6:  7b60      str     r3, [r7, #4]
0x003343a8:  3b62      str     r3, [r7, #0x20]
0x003343aa:  bb86      strh    r3, [r7, #0x34]
0x003343ac:  3b87      strh    r3, [r7, #0x38]
0x003343ae:  7b87      strh    r3, [r7, #0x3a]
0x003343b0:  bb87      strh    r3, [r7, #0x3c]
0x003343b2:  fb87      strh    r3, [r7, #0x3e]

===== sub_00334200 @ 0x00334200 =====
0x00334200:  10b5      push    {r4, lr}
0x00334202:  064c      ldr     r4, [pc, #0x18]  ; =0x002f5fd0
0x00334204:  2288      ldrh    r2, [r4]
0x00334206:  002a      cmp     r2, #0
0x00334208:  04d0      beq     #0x334214
0x0033420a:  531c      adds    r3, r2, #1
0x0033420c:  2380      strh    r3, [r4]
0x0033420e:  10bc      pop     {r4}
0x00334210:  01bc      pop     {r0}
0x00334212:  0047      bx      r0
0x00334214:  05f000ff  bl      #0x33a018  ; sub_0033a018
0x00334218:  2288      ldrh    r2, [r4]
0x0033421a:  f6e7      b       #0x33420a
0x0033421c:  d05f      ldrsh   r0, [r2, r7]
0x0033421e:  2f00      movs    r7, r5
0x00334220:  00b5      push    {lr}
0x00334222:  064a      ldr     r2, [pc, #0x18]  ; =0x002f5fd0
0x00334224:  1388      ldrh    r3, [r2]
0x00334226:  013b      subs    r3, #1
0x00334228:  1380      strh    r3, [r2]
0x0033422a:  1b04      lsls    r3, r3, #0x10
0x0033422c:  002b      cmp     r3, #0
0x0033422e:  01d0      beq     #0x334234
0x00334230:  01bc      pop     {r0}
0x00334232:  0047      bx      r0
0x00334234:  05f0f4fe  bl      #0x33a020  ; sub_0033a020
0x00334238:  fae7      b       #0x334230
0x0033423a:  0000      movs    r0, r0
0x0033423c:  d05f      ldrsh   r0, [r2, r7]
0x0033423e:  2f00      movs    r7, r5
0x00334240:  70b5      push    {r4, r5, r6, lr}
0x00334242:  0268      ldr     r2, [r0]
0x00334244:  051c      adds    r5, r0, #0
0x00334246:  0e1c      adds    r6, r1, #0
0x00334248:  0024      movs    r4, #0
0x0033424a:  0120      movs    r0, #1
0x0033424c:  08e0      b       #0x334260
0x0033424e:  9368      ldr     r3, [r2, #8]
0x00334250:  5988      ldrh    r1, [r3, #2]
0x00334252:  8142      cmp     r1, r0
0x00334254:  06d3      blo     #0x334264
0x00334256:  4b1c      adds    r3, r1, #1
0x00334258:  1b04      lsls    r3, r3, #0x10
0x0033425a:  141c      adds    r4, r2, #0
0x0033425c:  1268      ldr     r2, [r2]
0x0033425e:  180c      lsrs    r0, r3, #0x10
0x00334260:  002a      cmp     r2, #0
0x00334262:  f4d1      bne     #0x33424e
0x00334264:  321c      adds    r2, r6, #0
0x00334266:  7080      strh    r0, [r6, #2]
0x00334268:  211c      adds    r1, r4, #0
0x0033426a:  281c      adds    r0, r5, #0
0x0033426c:  0832      adds    r2, #8
0x0033426e:  03f0c1f8  bl      #0x3373f4  ; sub_003373f4
0x00334272:  70bc      pop     {r4, r5, r6}
0x00334274:  01bc      pop     {r0}
0x00334276:  0047      bx      r0
0x00334278:  70b5      push    {r4, r5, r6, lr}
0x0033427a:  ca8e      ldrh    r2, [r1, #0x36]
0x0033427c:  4c69      ldr     r4, [r1, #0x14]
0x0033427e:  061c      adds    r6, r0, #0
0x00334280:  0025      movs    r5, #0
0x00334282:  05e0      b       #0x334290
0x00334284:  a368      ldr     r3, [r4, #8]
0x00334286:  db8e      ldrh    r3, [r3, #0x36]
0x00334288:  9342      cmp     r3, r2
0x0033428a:  03d1      bne     #0x334294
0x0033428c:  251c      adds    r5, r4, #0
0x0033428e:  2468      ldr     r4, [r4]
0x00334290:  002c      cmp     r4, #0
0x00334292:  f7d1      bne     #0x334284
0x00334294:  0c1c      adds    r4, r1, #0
0x00334296:  1434      adds    r4, #0x14
0x00334298:  002d      cmp     r5, #0
0x0033429a:  0ad0      beq     #0x3342b2
0x0033429c:  ac42      cmp     r4, r5
0x0033429e:  08d0      beq     #0x3342b2
0x003342a0:  301c      adds    r0, r6, #0
0x003342a2:  211c      adds    r1, r4, #0
0x003342a4:  03f004f9  bl      #0x3374b0  ; sub_003374b0
0x003342a8:  301c      adds    r0, r6, #0
0x003342aa:  291c      adds    r1, r5, #0
0x003342ac:  221c      adds    r2, r4, #0
0x003342ae:  03f0a1f8  bl      #0x3373f4  ; sub_003373f4
0x003342b2:  70bc      pop     {r4, r5, r6}
0x003342b4:  01bc      pop     {r0}
0x003342b6:  0047      bx      r0
0x003342b8:  30b5      push    {r4, r5, lr}
0x003342ba:  041c      adds    r4, r0, #0
0x003342bc:  0d1c      adds    r5, r1, #0
0x003342be:  e88e      ldrh    r0, [r5, #0x36]
0x003342c0:  2268      ldr     r2, [r4]
0x003342c2:  0021      movs    r1, #0
0x003342c4:  2c62      str     r4, [r5, #0x20]
0x003342c6:  05e0      b       #0x3342d4
0x003342c8:  9368      ldr     r3, [r2, #8]
0x003342ca:  db8e      ldrh    r3, [r3, #0x36]
0x003342cc:  8342      cmp     r3, r0
0x003342ce:  03d8      bhi     #0x3342d8
0x003342d0:  111c      adds    r1, r2, #0
0x003342d2:  1268      ldr     r2, [r2]
0x003342d4:  002a      cmp     r2, #0
0x003342d6:  f7d1      bne     #0x3342c8
0x003342d8:  2a1c      adds    r2, r5, #0
0x003342da:  201c      adds    r0, r4, #0
0x003342dc:  1432      adds    r2, #0x14
0x003342de:  03f089f8  bl      #0x3373f4  ; sub_003373f4
0x003342e2:  30bc      pop     {r4, r5}
0x003342e4:  01bc      pop     {r0}
0x003342e6:  0047      bx      r0
0x003342e8:  10b5      push    {r4, lr}
0x003342ea:  041c      adds    r4, r0, #0
0x003342ec:  211c      adds    r1, r4, #0
0x003342ee:  0848      ldr     r0, [pc, #0x20]  ; =0x002f5a40
0x003342f0:  5431      adds    r1, #0x54
0x003342f2:  03f0ddf8  bl      #0x3374b0  ; sub_003374b0
0x003342f6:  206a      ldr     r0, [r4, #0x20]
0x003342f8:  0028      cmp     r0, #0
0x003342fa:  04d1      bne     #0x334306
0x003342fc:  0023      movs    r3, #0
0x003342fe:  2362      str     r3, [r4, #0x20]
0x00334300:  10bc      pop     {r4}
0x00334302:  01bc      pop     {r0}
0x00334304:  0047      bx      r0
0x00334306:  211c      adds    r1, r4, #0
0x00334308:  1431      adds    r1, #0x14
0x0033430a:  03f0d1f8  bl      #0x3374b0  ; sub_003374b0
0x0033430e:  f5e7      b       #0x3342fc
0x00334310:  405a      ldrh    r0, [r0, r1]
0x00334312:  2f00      movs    r7, r5
0x00334314:  70b5      push    {r4, r5, r6, lr}
0x00334316:  051c      adds    r5, r0, #0
0x00334318:  05f046fe  bl      #0x339fa8  ; sub_00339fa8
0x0033431c:  061c      adds    r6, r0, #0
0x0033431e:  002d      cmp     r5, #0
0x00334320:  17d0      beq     #0x334352
0x00334322:  286a      ldr     r0, [r5, #0x20]
0x00334324:  0028      cmp     r0, #0
0x00334326:  0fd1      bne     #0x334348
0x00334328:  0024      movs    r4, #0
0x0033432a:  291c      adds    r1, r5, #0
0x0033432c:  0831      adds    r1, #8
0x0033432e:  2c62      str     r4, [r5, #0x20]
0x00334330:  0948      ldr     r0, [pc, #0x24]  ; =0x002f5b60
0x00334332:  03f0bdf8  bl      #0x3374b0  ; sub_003374b0
0x00334336:  2c80      strh    r4, [r5]
0x00334338:  fff712ff  bl      #0x334160  ; sub_00334160
0x0033433c:  301c      adds    r0, r6, #0
0x0033433e:  05f037fe  bl      #0x339fb0  ; sub_00339fb0
0x00334342:  70bc      pop     {r4, r5, r6}
0x00334344:  01bc      pop     {r0}
0x00334346:  0047      bx      r0
0x00334348:  291c      adds    r1, r5, #0
0x0033434a:  1431      adds    r1, #0x14
0x0033434c:  03f0b0f8  bl      #0x3374b0  ; sub_003374b0
0x00334350:  eae7      b       #0x334328
0x00334352:  024b      ldr     r3, [pc, #8]  ; =0x002f6000
0x00334354:  1d68      ldr     r5, [r3]
0x00334356:  e4e7      b       #0x334322
0x00334358:  605b      ldrh    r0, [r4, r5]
0x0033435a:  2f00      movs    r7, r5
0x0033435c:  0060      str     r0, [r0]
0x0033435e:  2f00      movs    r7, r5
0x00334360:  f0b5      push    {r4, r5, r6, r7, lr}
0x00334362:  5746      mov     r7, sl
0x00334364:  4646      mov     r6, r8
0x00334366:  c0b4      push    {r6, r7}
0x00334368:  071c      adds    r7, r0, #0
0x0033436a:  8a46      mov     sl, r1
0x0033436c:  0830      adds    r0, #8
0x0033436e:  391c      adds    r1, r7, #0
0x00334370:  161c      adds    r6, r2, #0
0x00334372:  9846      mov     r8, r3
0x00334374:  079c      ldr     r4, [sp, #0x1c]
0x00334376:  089d      ldr     r5, [sp, #0x20]
0x00334378:  03f036f8  bl      #0x3373e8  ; sub_003373e8
0x0033437c:  381c      adds    r0, r7, #0
0x0033437e:  1430      adds    r0, #0x14
0x00334380:  391c      adds    r1, r7, #0
0x00334382:  03f031f8  bl      #0x3373e8  ; sub_003373e8
0x00334386:  381c      adds    r0, r7, #0
0x00334388:  5430      adds    r0, #0x54
0x0033438a:  391c      adds    r1, r7, #0
0x0033438c:  03f02cf8  bl      #0x3373e8  ; sub_003373e8
0x00334390:  184b      ldr     r3, [pc, #0x60]  ; =0x00005441
0x00334392:  4246      mov     r2, r8
0x00334394:  fa62      str     r2, [r7, #0x2c]
0x00334396:  2404      lsls    r4, r4, #0x10
0x00334398:  0122      movs    r2, #1
0x0033439a:  3b80      strh    r3, [r7]
0x0033439c:  3a86      strh    r2, [r7, #0x30]
0x0033439e:  0023      movs    r3, #0
0x003343a0:  7a86      strh    r2, [r7, #0x32]
0x003343a2:  240c      lsrs    r4, r4, #0x10
0x003343a4:  5246      mov     r2, sl
0x003343a6:  7b60      str     r3, [r7, #4]
0x003343a8:  3b62      str     r3, [r7, #0x20]
0x003343aa:  bb86      strh    r3, [r7, #0x34]
0x003343ac:  3b87      strh    r3, [r7, #0x38]
0x003343ae:  7b87      strh    r3, [r7, #0x3a]
0x003343b0:  bb87      strh    r3, [r7, #0x3c]
0x003343b2:  fb87      strh    r3, [r7, #0x3e]
0x003343b4:  3b64      str     r3, [r7, #0x40]
0x003343b6:  7b64      str     r3, [r7, #0x44]
0x003343b8:  fb64      str     r3, [r7, #0x4c]
0x003343ba:  4146      mov     r1, r8
0x003343bc:  be62      str     r6, [r7, #0x28]
0x003343be:  fc86      strh    r4, [r7, #0x36]
0x003343c0:  ba64      str     r2, [r7, #0x48]
0x003343c2:  301c      adds    r0, r6, #0
0x003343c4:  01f094fa  bl      #0x3358f0  ; sub_003358f0
0x003343c8:  2d04      lsls    r5, r5, #0x10
0x003343ca:  2d0c      lsrs    r5, r5, #0x10
0x003343cc:  7862      str     r0, [r7, #0x24]
0x003343ce:  391c      adds    r1, r7, #0
0x003343d0:  0948      ldr     r0, [pc, #0x24]  ; =0x002f5b60
0x003343d2:  fff735ff  bl      #0x334240  ; sub_00334240
0x003343d6:  eb07      lsls    r3, r5, #0x1f
0x003343d8:  09d5      bpl     #0x3343ee
0x003343da:  0848      ldr     r0, [pc, #0x20]  ; =0x002f5ac0
0x003343dc:  391c      adds    r1, r7, #0

===== sub_00334220 @ 0x00334220 =====
0x00334220:  00b5      push    {lr}
0x00334222:  064a      ldr     r2, [pc, #0x18]  ; =0x002f5fd0
0x00334224:  1388      ldrh    r3, [r2]
0x00334226:  013b      subs    r3, #1
0x00334228:  1380      strh    r3, [r2]
0x0033422a:  1b04      lsls    r3, r3, #0x10
0x0033422c:  002b      cmp     r3, #0
0x0033422e:  01d0      beq     #0x334234
0x00334230:  01bc      pop     {r0}
0x00334232:  0047      bx      r0
0x00334234:  05f0f4fe  bl      #0x33a020  ; sub_0033a020
0x00334238:  fae7      b       #0x334230
0x0033423a:  0000      movs    r0, r0
0x0033423c:  d05f      ldrsh   r0, [r2, r7]
0x0033423e:  2f00      movs    r7, r5
0x00334240:  70b5      push    {r4, r5, r6, lr}
0x00334242:  0268      ldr     r2, [r0]
0x00334244:  051c      adds    r5, r0, #0
0x00334246:  0e1c      adds    r6, r1, #0
0x00334248:  0024      movs    r4, #0
0x0033424a:  0120      movs    r0, #1
0x0033424c:  08e0      b       #0x334260
0x0033424e:  9368      ldr     r3, [r2, #8]
0x00334250:  5988      ldrh    r1, [r3, #2]
0x00334252:  8142      cmp     r1, r0
0x00334254:  06d3      blo     #0x334264
0x00334256:  4b1c      adds    r3, r1, #1
0x00334258:  1b04      lsls    r3, r3, #0x10
0x0033425a:  141c      adds    r4, r2, #0
0x0033425c:  1268      ldr     r2, [r2]
0x0033425e:  180c      lsrs    r0, r3, #0x10
0x00334260:  002a      cmp     r2, #0
0x00334262:  f4d1      bne     #0x33424e
0x00334264:  321c      adds    r2, r6, #0
0x00334266:  7080      strh    r0, [r6, #2]
0x00334268:  211c      adds    r1, r4, #0
0x0033426a:  281c      adds    r0, r5, #0
0x0033426c:  0832      adds    r2, #8
0x0033426e:  03f0c1f8  bl      #0x3373f4  ; sub_003373f4
0x00334272:  70bc      pop     {r4, r5, r6}
0x00334274:  01bc      pop     {r0}
0x00334276:  0047      bx      r0
0x00334278:  70b5      push    {r4, r5, r6, lr}
0x0033427a:  ca8e      ldrh    r2, [r1, #0x36]
0x0033427c:  4c69      ldr     r4, [r1, #0x14]
0x0033427e:  061c      adds    r6, r0, #0
0x00334280:  0025      movs    r5, #0
0x00334282:  05e0      b       #0x334290
0x00334284:  a368      ldr     r3, [r4, #8]
0x00334286:  db8e      ldrh    r3, [r3, #0x36]
0x00334288:  9342      cmp     r3, r2
0x0033428a:  03d1      bne     #0x334294
0x0033428c:  251c      adds    r5, r4, #0
0x0033428e:  2468      ldr     r4, [r4]
0x00334290:  002c      cmp     r4, #0
0x00334292:  f7d1      bne     #0x334284
0x00334294:  0c1c      adds    r4, r1, #0
0x00334296:  1434      adds    r4, #0x14
0x00334298:  002d      cmp     r5, #0
0x0033429a:  0ad0      beq     #0x3342b2
0x0033429c:  ac42      cmp     r4, r5
0x0033429e:  08d0      beq     #0x3342b2
0x003342a0:  301c      adds    r0, r6, #0
0x003342a2:  211c      adds    r1, r4, #0
0x003342a4:  03f004f9  bl      #0x3374b0  ; sub_003374b0
0x003342a8:  301c      adds    r0, r6, #0
0x003342aa:  291c      adds    r1, r5, #0
0x003342ac:  221c      adds    r2, r4, #0
0x003342ae:  03f0a1f8  bl      #0x3373f4  ; sub_003373f4
0x003342b2:  70bc      pop     {r4, r5, r6}
0x003342b4:  01bc      pop     {r0}
0x003342b6:  0047      bx      r0
0x003342b8:  30b5      push    {r4, r5, lr}
0x003342ba:  041c      adds    r4, r0, #0
0x003342bc:  0d1c      adds    r5, r1, #0
0x003342be:  e88e      ldrh    r0, [r5, #0x36]
0x003342c0:  2268      ldr     r2, [r4]
0x003342c2:  0021      movs    r1, #0
0x003342c4:  2c62      str     r4, [r5, #0x20]
0x003342c6:  05e0      b       #0x3342d4
0x003342c8:  9368      ldr     r3, [r2, #8]
0x003342ca:  db8e      ldrh    r3, [r3, #0x36]
0x003342cc:  8342      cmp     r3, r0
0x003342ce:  03d8      bhi     #0x3342d8
0x003342d0:  111c      adds    r1, r2, #0
0x003342d2:  1268      ldr     r2, [r2]
0x003342d4:  002a      cmp     r2, #0
0x003342d6:  f7d1      bne     #0x3342c8
0x003342d8:  2a1c      adds    r2, r5, #0
0x003342da:  201c      adds    r0, r4, #0
0x003342dc:  1432      adds    r2, #0x14
0x003342de:  03f089f8  bl      #0x3373f4  ; sub_003373f4
0x003342e2:  30bc      pop     {r4, r5}
0x003342e4:  01bc      pop     {r0}
0x003342e6:  0047      bx      r0
0x003342e8:  10b5      push    {r4, lr}
0x003342ea:  041c      adds    r4, r0, #0
0x003342ec:  211c      adds    r1, r4, #0
0x003342ee:  0848      ldr     r0, [pc, #0x20]  ; =0x002f5a40
0x003342f0:  5431      adds    r1, #0x54
0x003342f2:  03f0ddf8  bl      #0x3374b0  ; sub_003374b0
0x003342f6:  206a      ldr     r0, [r4, #0x20]
0x003342f8:  0028      cmp     r0, #0
0x003342fa:  04d1      bne     #0x334306
0x003342fc:  0023      movs    r3, #0
0x003342fe:  2362      str     r3, [r4, #0x20]
0x00334300:  10bc      pop     {r4}
0x00334302:  01bc      pop     {r0}
0x00334304:  0047      bx      r0
0x00334306:  211c      adds    r1, r4, #0
0x00334308:  1431      adds    r1, #0x14
0x0033430a:  03f0d1f8  bl      #0x3374b0  ; sub_003374b0
0x0033430e:  f5e7      b       #0x3342fc
0x00334310:  405a      ldrh    r0, [r0, r1]
0x00334312:  2f00      movs    r7, r5
0x00334314:  70b5      push    {r4, r5, r6, lr}
0x00334316:  051c      adds    r5, r0, #0
0x00334318:  05f046fe  bl      #0x339fa8  ; sub_00339fa8
0x0033431c:  061c      adds    r6, r0, #0
0x0033431e:  002d      cmp     r5, #0
0x00334320:  17d0      beq     #0x334352
0x00334322:  286a      ldr     r0, [r5, #0x20]
0x00334324:  0028      cmp     r0, #0
0x00334326:  0fd1      bne     #0x334348
0x00334328:  0024      movs    r4, #0
0x0033432a:  291c      adds    r1, r5, #0
0x0033432c:  0831      adds    r1, #8
0x0033432e:  2c62      str     r4, [r5, #0x20]
0x00334330:  0948      ldr     r0, [pc, #0x24]  ; =0x002f5b60
0x00334332:  03f0bdf8  bl      #0x3374b0  ; sub_003374b0
0x00334336:  2c80      strh    r4, [r5]
0x00334338:  fff712ff  bl      #0x334160  ; sub_00334160
0x0033433c:  301c      adds    r0, r6, #0
0x0033433e:  05f037fe  bl      #0x339fb0  ; sub_00339fb0
0x00334342:  70bc      pop     {r4, r5, r6}
0x00334344:  01bc      pop     {r0}
0x00334346:  0047      bx      r0
0x00334348:  291c      adds    r1, r5, #0
0x0033434a:  1431      adds    r1, #0x14
0x0033434c:  03f0b0f8  bl      #0x3374b0  ; sub_003374b0
0x00334350:  eae7      b       #0x334328
0x00334352:  024b      ldr     r3, [pc, #8]  ; =0x002f6000
0x00334354:  1d68      ldr     r5, [r3]
0x00334356:  e4e7      b       #0x334322
0x00334358:  605b      ldrh    r0, [r4, r5]
0x0033435a:  2f00      movs    r7, r5
0x0033435c:  0060      str     r0, [r0]
0x0033435e:  2f00      movs    r7, r5
0x00334360:  f0b5      push    {r4, r5, r6, r7, lr}
0x00334362:  5746      mov     r7, sl
0x00334364:  4646      mov     r6, r8
0x00334366:  c0b4      push    {r6, r7}
0x00334368:  071c      adds    r7, r0, #0
0x0033436a:  8a46      mov     sl, r1
0x0033436c:  0830      adds    r0, #8
0x0033436e:  391c      adds    r1, r7, #0
0x00334370:  161c      adds    r6, r2, #0
0x00334372:  9846      mov     r8, r3
0x00334374:  079c      ldr     r4, [sp, #0x1c]
0x00334376:  089d      ldr     r5, [sp, #0x20]
0x00334378:  03f036f8  bl      #0x3373e8  ; sub_003373e8
0x0033437c:  381c      adds    r0, r7, #0
0x0033437e:  1430      adds    r0, #0x14
0x00334380:  391c      adds    r1, r7, #0
0x00334382:  03f031f8  bl      #0x3373e8  ; sub_003373e8
0x00334386:  381c      adds    r0, r7, #0
0x00334388:  5430      adds    r0, #0x54
0x0033438a:  391c      adds    r1, r7, #0
0x0033438c:  03f02cf8  bl      #0x3373e8  ; sub_003373e8
0x00334390:  184b      ldr     r3, [pc, #0x60]  ; =0x00005441
0x00334392:  4246      mov     r2, r8
0x00334394:  fa62      str     r2, [r7, #0x2c]
0x00334396:  2404      lsls    r4, r4, #0x10
0x00334398:  0122      movs    r2, #1
0x0033439a:  3b80      strh    r3, [r7]
0x0033439c:  3a86      strh    r2, [r7, #0x30]
0x0033439e:  0023      movs    r3, #0
0x003343a0:  7a86      strh    r2, [r7, #0x32]
0x003343a2:  240c      lsrs    r4, r4, #0x10
0x003343a4:  5246      mov     r2, sl
0x003343a6:  7b60      str     r3, [r7, #4]
0x003343a8:  3b62      str     r3, [r7, #0x20]
0x003343aa:  bb86      strh    r3, [r7, #0x34]
0x003343ac:  3b87      strh    r3, [r7, #0x38]
0x003343ae:  7b87      strh    r3, [r7, #0x3a]
0x003343b0:  bb87      strh    r3, [r7, #0x3c]
0x003343b2:  fb87      strh    r3, [r7, #0x3e]
0x003343b4:  3b64      str     r3, [r7, #0x40]
0x003343b6:  7b64      str     r3, [r7, #0x44]
0x003343b8:  fb64      str     r3, [r7, #0x4c]
0x003343ba:  4146      mov     r1, r8
0x003343bc:  be62      str     r6, [r7, #0x28]
0x003343be:  fc86      strh    r4, [r7, #0x36]
0x003343c0:  ba64      str     r2, [r7, #0x48]
0x003343c2:  301c      adds    r0, r6, #0
0x003343c4:  01f094fa  bl      #0x3358f0  ; sub_003358f0
0x003343c8:  2d04      lsls    r5, r5, #0x10
0x003343ca:  2d0c      lsrs    r5, r5, #0x10
0x003343cc:  7862      str     r0, [r7, #0x24]
0x003343ce:  391c      adds    r1, r7, #0
0x003343d0:  0948      ldr     r0, [pc, #0x24]  ; =0x002f5b60
0x003343d2:  fff735ff  bl      #0x334240  ; sub_00334240
0x003343d6:  eb07      lsls    r3, r5, #0x1f
0x003343d8:  09d5      bpl     #0x3343ee
0x003343da:  0848      ldr     r0, [pc, #0x20]  ; =0x002f5ac0
0x003343dc:  391c      adds    r1, r7, #0
0x003343de:  fff76bff  bl      #0x3342b8  ; sub_003342b8
0x003343e2:  18bc      pop     {r3, r4}
0x003343e4:  9846      mov     r8, r3
0x003343e6:  a246      mov     sl, r4
0x003343e8:  f0bc      pop     {r4, r5, r6, r7}
0x003343ea:  01bc      pop     {r0}
0x003343ec:  0047      bx      r0
0x003343ee:  0448      ldr     r0, [pc, #0x10]  ; =0x002f5b40
0x003343f0:  f4e7      b       #0x3343dc
0x003343f2:  0000      movs    r0, r0
0x003343f4:  4154      strb    r1, [r0, r1]
0x003343f6:  0000      movs    r0, r0
0x003343f8:  605b      ldrh    r0, [r4, r5]
0x003343fa:  2f00      movs    r7, r5
0x003343fc:  c05a      ldrh    r0, [r0, r3]
0x003343fe:  2f00      movs    r7, r5

===== sub_00334670 @ 0x00334670 =====
0x00334670:  30b5      push    {r4, r5, lr}
0x00334672:  041c      adds    r4, r0, #0
0x00334674:  0d04      lsls    r5, r1, #0x10
0x00334676:  0830      adds    r0, #8
0x00334678:  211c      adds    r1, r4, #0
0x0033467a:  02f0b5fe  bl      #0x3373e8  ; sub_003373e8
0x0033467e:  0a4b      ldr     r3, [pc, #0x28]  ; =0x00005345
0x00334680:  2d0c      lsrs    r5, r5, #0x10
0x00334682:  2380      strh    r3, [r4]
0x00334684:  0023      movs    r3, #0
0x00334686:  6360      str     r3, [r4, #4]
0x00334688:  6361      str     r3, [r4, #0x14]
0x0033468a:  a361      str     r3, [r4, #0x18]
0x0033468c:  a583      strh    r5, [r4, #0x1c]
0x0033468e:  05f08bfc  bl      #0x339fa8  ; sub_00339fa8
0x00334692:  211c      adds    r1, r4, #0
0x00334694:  051c      adds    r5, r0, #0
0x00334696:  0548      ldr     r0, [pc, #0x14]  ; =0x002f5a80
0x00334698:  fff7d2fd  bl      #0x334240  ; sub_00334240
0x0033469c:  281c      adds    r0, r5, #0
0x0033469e:  05f087fc  bl      #0x339fb0  ; sub_00339fb0
0x003346a2:  30bc      pop     {r4, r5}
0x003346a4:  01bc      pop     {r0}
0x003346a6:  0047      bx      r0
0x003346a8:  4553      strh    r5, [r0, r5]
0x003346aa:  0000      movs    r0, r0
0x003346ac:  805a      ldrh    r0, [r0, r2]
0x003346ae:  2f00      movs    r7, r5
0x003346b0:  f0b5      push    {r4, r5, r6, r7, lr}
0x003346b2:  5746      mov     r7, sl
0x003346b4:  4646      mov     r6, r8
0x003346b6:  c0b4      push    {r6, r7}
0x003346b8:  0023      movs    r3, #0
0x003346ba:  071c      adds    r7, r0, #0
0x003346bc:  9a46      mov     sl, r3
0x003346be:  05f073fc  bl      #0x339fa8  ; sub_00339fa8
0x003346c2:  7d69      ldr     r5, [r7, #0x14]
0x003346c4:  8046      mov     r8, r0
0x003346c6:  002d      cmp     r5, #0
0x003346c8:  18d0      beq     #0x3346fc
0x003346ca:  3e1c      adds    r6, r7, #0
0x003346cc:  0123      movs    r3, #1
0x003346ce:  1436      adds    r6, #0x14
0x003346d0:  9a46      mov     sl, r3
0x003346d2:  ac68      ldr     r4, [r5, #8]
0x003346d4:  144b      ldr     r3, [pc, #0x50]  ; =0xffff8000
0x003346d6:  228e      ldrh    r2, [r4, #0x30]
0x003346d8:  211c      adds    r1, r4, #0
0x003346da:  1340      ands    r3, r2
0x003346dc:  0122      movs    r2, #1
0x003346de:  1343      orrs    r3, r2
0x003346e0:  2386      strh    r3, [r4, #0x30]
0x003346e2:  301c      adds    r0, r6, #0
0x003346e4:  1431      adds    r1, #0x14
0x003346e6:  2d68      ldr     r5, [r5]
0x003346e8:  02f0e2fe  bl      #0x3374b0  ; sub_003374b0
0x003346ec:  0023      movs    r3, #0
0x003346ee:  2362      str     r3, [r4, #0x20]
0x003346f0:  0e48      ldr     r0, [pc, #0x38]  ; =0x002f5b40
0x003346f2:  211c      adds    r1, r4, #0
0x003346f4:  fff7e0fd  bl      #0x3342b8  ; sub_003342b8
0x003346f8:  002d      cmp     r5, #0
0x003346fa:  ead1      bne     #0x3346d2
0x003346fc:  391c      adds    r1, r7, #0
0x003346fe:  0c48      ldr     r0, [pc, #0x30]  ; =0x002f5a80
0x00334700:  0831      adds    r1, #8
0x00334702:  02f0d5fe  bl      #0x3374b0  ; sub_003374b0
0x00334706:  0023      movs    r3, #0
0x00334708:  3b80      strh    r3, [r7]
0x0033470a:  5346      mov     r3, sl
0x0033470c:  002b      cmp     r3, #0
0x0033470e:  08d1      bne     #0x334722
0x00334710:  4046      mov     r0, r8
0x00334712:  05f04dfc  bl      #0x339fb0  ; sub_00339fb0
0x00334716:  18bc      pop     {r3, r4}
0x00334718:  9846      mov     r8, r3
0x0033471a:  a246      mov     sl, r4
0x0033471c:  f0bc      pop     {r4, r5, r6, r7}
0x0033471e:  01bc      pop     {r0}
0x00334720:  0047      bx      r0
0x00334722:  fff71dfd  bl      #0x334160  ; sub_00334160
0x00334726:  f3e7      b       #0x334710
0x00334728:  0080      strh    r0, [r0]
0x0033472a:  ffff405b  vtbx.8  d21, {d15, d16, d17, d18}, d0
0x0033472e:  2f00      movs    r7, r5
0x00334730:  805a      ldrh    r0, [r0, r2]
0x00334732:  2f00      movs    r7, r5
0x00334734:  f0b5      push    {r4, r5, r6, r7, lr}
0x00334736:  0904      lsls    r1, r1, #0x10
0x00334738:  061c      adds    r6, r0, #0
0x0033473a:  0d0c      lsrs    r5, r1, #0x10
0x0033473c:  05f034fc  bl      #0x339fa8  ; sub_00339fa8
0x00334740:  1d4b      ldr     r3, [pc, #0x74]  ; =0x002f5b90
0x00334742:  071c      adds    r7, r0, #0
0x00334744:  1b88      ldrh    r3, [r3]
0x00334746:  002b      cmp     r3, #0
0x00334748:  26d1      bne     #0x334798
0x0033474a:  b28b      ldrh    r2, [r6, #0x1c]
0x0033474c:  aa42      cmp     r2, r5
0x0033474e:  1dd2      bhs     #0x33478c
0x00334750:  1a4c      ldr     r4, [pc, #0x68]  ; =0x002f6000
0x00334752:  1b4b      ldr     r3, [pc, #0x6c]  ; =0xffff8000
0x00334754:  2168      ldr     r1, [r4]
0x00334756:  1b48      ldr     r0, [pc, #0x6c]  ; =0x002f5b40
0x00334758:  0a8e      ldrh    r2, [r1, #0x30]
0x0033475a:  8d87      strh    r5, [r1, #0x3c]
0x0033475c:  1340      ands    r3, r2
0x0033475e:  0222      movs    r2, #2
0x00334760:  1343      orrs    r3, r2
0x00334762:  0b86      strh    r3, [r1, #0x30]
0x00334764:  1431      adds    r1, #0x14
0x00334766:  02f0a3fe  bl      #0x3374b0  ; sub_003374b0
0x0033476a:  2168      ldr     r1, [r4]
0x0033476c:  301c      adds    r0, r6, #0
0x0033476e:  1430      adds    r0, #0x14
0x00334770:  0862      str     r0, [r1, #0x20]
0x00334772:  1431      adds    r1, #0x14
0x00334774:  02f058fe  bl      #0x337428  ; sub_00337428
0x00334778:  fff7f2fc  bl      #0x334160  ; sub_00334160
0x0033477c:  2368      ldr     r3, [r4]
0x0033477e:  b361      str     r3, [r6, #0x18]
0x00334780:  381c      adds    r0, r7, #0
0x00334782:  05f015fc  bl      #0x339fb0  ; sub_00339fb0
0x00334786:  f0bc      pop     {r4, r5, r6, r7}
0x00334788:  01bc      pop     {r0}
0x0033478a:  0047      bx      r0
0x0033478c:  0b4b      ldr     r3, [pc, #0x2c]  ; =0x002f6000
0x0033478e:  1b68      ldr     r3, [r3]
0x00334790:  b361      str     r3, [r6, #0x18]
0x00334792:  531b      subs    r3, r2, r5
0x00334794:  b383      strh    r3, [r6, #0x1c]
0x00334796:  f3e7      b       #0x334780
0x00334798:  0b49      ldr     r1, [pc, #0x2c]  ; =0x002f5fe0
0x0033479a:  0c4b      ldr     r3, [pc, #0x30]  ; =0x00000fff
0x0033479c:  0a88      ldrh    r2, [r1]
0x0033479e:  1340      ands    r3, r2
0x003347a0:  8022      movs    r2, #0x80
0x003347a2:  5201      lsls    r2, r2, #5
0x003347a4:  0133      adds    r3, #1
0x003347a6:  1343      orrs    r3, r2
0x003347a8:  0b80      strh    r3, [r1]
0x003347aa:  044b      ldr     r3, [pc, #0x10]  ; =0x002f6000
0x003347ac:  1a68      ldr     r2, [r3]
0x003347ae:  084b      ldr     r3, [pc, #0x20]  ; =0x002f5a60
0x003347b0:  1a60      str     r2, [r3]
0x003347b2:  084b      ldr     r3, [pc, #0x20]  ; =0x002f5aa0
0x003347b4:  1e60      str     r6, [r3]
0x003347b6:  e3e7      b       #0x334780
0x003347b8:  905b      ldrh    r0, [r2, r6]
0x003347ba:  2f00      movs    r7, r5
0x003347bc:  0060      str     r0, [r0]
0x003347be:  2f00      movs    r7, r5
0x003347c0:  0080      strh    r0, [r0]
0x003347c2:  ffff405b  vtbx.8  d21, {d15, d16, d17, d18}, d0
0x003347c6:  2f00      movs    r7, r5
0x003347c8:  e05f      ldrsh   r0, [r4, r7]
0x003347ca:  2f00      movs    r7, r5
0x003347cc:  ff0f      lsrs    r7, r7, #0x1f
0x003347ce:  0000      movs    r0, r0
0x003347d0:  605a      ldrh    r0, [r4, r1]
0x003347d2:  2f00      movs    r7, r5
0x003347d4:  a05a      ldrh    r0, [r4, r2]
0x003347d6:  2f00      movs    r7, r5
0x003347d8:  f0b5      push    {r4, r5, r6, r7, lr}
0x003347da:  5746      mov     r7, sl
0x003347dc:  4646      mov     r6, r8
0x003347de:  c0b4      push    {r6, r7}
0x003347e0:  0023      movs    r3, #0
0x003347e2:  0904      lsls    r1, r1, #0x10
0x003347e4:  071c      adds    r7, r0, #0
0x003347e6:  0e0c      lsrs    r6, r1, #0x10
0x003347e8:  9846      mov     r8, r3
0x003347ea:  05f0ddfb  bl      #0x339fa8  ; sub_00339fa8
0x003347ee:  bb8b      ldrh    r3, [r7, #0x1c]
0x003347f0:  7d69      ldr     r5, [r7, #0x14]
0x003347f2:  f318      adds    r3, r6, r3
0x003347f4:  1b04      lsls    r3, r3, #0x10
0x003347f6:  8246      mov     sl, r0
0x003347f8:  1e0c      lsrs    r6, r3, #0x10
0x003347fa:  1de0      b       #0x334838
0x003347fc:  ac68      ldr     r4, [r5, #8]
0x003347fe:  2d68      ldr     r5, [r5]
0x00334800:  a18f      ldrh    r1, [r4, #0x3c]
0x00334802:  b142      cmp     r1, r6
0x00334804:  1ad8      bhi     #0x33483c
0x00334806:  731a      subs    r3, r6, r1
0x00334808:  1b04      lsls    r3, r3, #0x10
0x0033480a:  1e0c      lsrs    r6, r3, #0x10
0x0033480c:  0023      movs    r3, #0
0x0033480e:  228e      ldrh    r2, [r4, #0x30]
0x00334810:  a387      strh    r3, [r4, #0x3c]
0x00334812:  124b      ldr     r3, [pc, #0x48]  ; =0xffff8000
0x00334814:  381c      adds    r0, r7, #0
0x00334816:  1340      ands    r3, r2
0x00334818:  0122      movs    r2, #1
0x0033481a:  1343      orrs    r3, r2
0x0033481c:  211c      adds    r1, r4, #0
0x0033481e:  2386      strh    r3, [r4, #0x30]
0x00334820:  1430      adds    r0, #0x14
0x00334822:  1431      adds    r1, #0x14
0x00334824:  02f044fe  bl      #0x3374b0  ; sub_003374b0
0x00334828:  0023      movs    r3, #0
0x0033482a:  2362      str     r3, [r4, #0x20]
0x0033482c:  0c48      ldr     r0, [pc, #0x30]  ; =0x002f5b40
0x0033482e:  211c      adds    r1, r4, #0
0x00334830:  fff742fd  bl      #0x3342b8  ; sub_003342b8
0x00334834:  0123      movs    r3, #1
0x00334836:  9846      mov     r8, r3
0x00334838:  002d      cmp     r5, #0
0x0033483a:  dfd1      bne     #0x3347fc
0x0033483c:  4346      mov     r3, r8
0x0033483e:  be83      strh    r6, [r7, #0x1c]
0x00334840:  002b      cmp     r3, #0
0x00334842:  08d1      bne     #0x334856
0x00334844:  5046      mov     r0, sl
0x00334846:  05f0b3fb  bl      #0x339fb0  ; sub_00339fb0
0x0033484a:  18bc      pop     {r3, r4}
0x0033484c:  9846      mov     r8, r3
0x0033484e:  a246      mov     sl, r4

===== sub_00334734 @ 0x00334734 =====
0x00334734:  f0b5      push    {r4, r5, r6, r7, lr}
0x00334736:  0904      lsls    r1, r1, #0x10
0x00334738:  061c      adds    r6, r0, #0
0x0033473a:  0d0c      lsrs    r5, r1, #0x10
0x0033473c:  05f034fc  bl      #0x339fa8  ; sub_00339fa8
0x00334740:  1d4b      ldr     r3, [pc, #0x74]  ; =0x002f5b90
0x00334742:  071c      adds    r7, r0, #0
0x00334744:  1b88      ldrh    r3, [r3]
0x00334746:  002b      cmp     r3, #0
0x00334748:  26d1      bne     #0x334798
0x0033474a:  b28b      ldrh    r2, [r6, #0x1c]
0x0033474c:  aa42      cmp     r2, r5
0x0033474e:  1dd2      bhs     #0x33478c
0x00334750:  1a4c      ldr     r4, [pc, #0x68]  ; =0x002f6000
0x00334752:  1b4b      ldr     r3, [pc, #0x6c]  ; =0xffff8000
0x00334754:  2168      ldr     r1, [r4]
0x00334756:  1b48      ldr     r0, [pc, #0x6c]  ; =0x002f5b40
0x00334758:  0a8e      ldrh    r2, [r1, #0x30]
0x0033475a:  8d87      strh    r5, [r1, #0x3c]
0x0033475c:  1340      ands    r3, r2
0x0033475e:  0222      movs    r2, #2
0x00334760:  1343      orrs    r3, r2
0x00334762:  0b86      strh    r3, [r1, #0x30]
0x00334764:  1431      adds    r1, #0x14
0x00334766:  02f0a3fe  bl      #0x3374b0  ; sub_003374b0
0x0033476a:  2168      ldr     r1, [r4]
0x0033476c:  301c      adds    r0, r6, #0
0x0033476e:  1430      adds    r0, #0x14
0x00334770:  0862      str     r0, [r1, #0x20]
0x00334772:  1431      adds    r1, #0x14
0x00334774:  02f058fe  bl      #0x337428  ; sub_00337428
0x00334778:  fff7f2fc  bl      #0x334160  ; sub_00334160
0x0033477c:  2368      ldr     r3, [r4]
0x0033477e:  b361      str     r3, [r6, #0x18]
0x00334780:  381c      adds    r0, r7, #0
0x00334782:  05f015fc  bl      #0x339fb0  ; sub_00339fb0
0x00334786:  f0bc      pop     {r4, r5, r6, r7}
0x00334788:  01bc      pop     {r0}
0x0033478a:  0047      bx      r0
0x0033478c:  0b4b      ldr     r3, [pc, #0x2c]  ; =0x002f6000
0x0033478e:  1b68      ldr     r3, [r3]
0x00334790:  b361      str     r3, [r6, #0x18]
0x00334792:  531b      subs    r3, r2, r5
0x00334794:  b383      strh    r3, [r6, #0x1c]
0x00334796:  f3e7      b       #0x334780
0x00334798:  0b49      ldr     r1, [pc, #0x2c]  ; =0x002f5fe0
0x0033479a:  0c4b      ldr     r3, [pc, #0x30]  ; =0x00000fff
0x0033479c:  0a88      ldrh    r2, [r1]
0x0033479e:  1340      ands    r3, r2
0x003347a0:  8022      movs    r2, #0x80
0x003347a2:  5201      lsls    r2, r2, #5
0x003347a4:  0133      adds    r3, #1
0x003347a6:  1343      orrs    r3, r2
0x003347a8:  0b80      strh    r3, [r1]
0x003347aa:  044b      ldr     r3, [pc, #0x10]  ; =0x002f6000
0x003347ac:  1a68      ldr     r2, [r3]
0x003347ae:  084b      ldr     r3, [pc, #0x20]  ; =0x002f5a60
0x003347b0:  1a60      str     r2, [r3]
0x003347b2:  084b      ldr     r3, [pc, #0x20]  ; =0x002f5aa0
0x003347b4:  1e60      str     r6, [r3]
0x003347b6:  e3e7      b       #0x334780
0x003347b8:  905b      ldrh    r0, [r2, r6]
0x003347ba:  2f00      movs    r7, r5
0x003347bc:  0060      str     r0, [r0]
0x003347be:  2f00      movs    r7, r5
0x003347c0:  0080      strh    r0, [r0]
0x003347c2:  ffff405b  vtbx.8  d21, {d15, d16, d17, d18}, d0
0x003347c6:  2f00      movs    r7, r5
0x003347c8:  e05f      ldrsh   r0, [r4, r7]
0x003347ca:  2f00      movs    r7, r5
0x003347cc:  ff0f      lsrs    r7, r7, #0x1f
0x003347ce:  0000      movs    r0, r0
0x003347d0:  605a      ldrh    r0, [r4, r1]
0x003347d2:  2f00      movs    r7, r5
0x003347d4:  a05a      ldrh    r0, [r4, r2]
0x003347d6:  2f00      movs    r7, r5
0x003347d8:  f0b5      push    {r4, r5, r6, r7, lr}
0x003347da:  5746      mov     r7, sl
0x003347dc:  4646      mov     r6, r8
0x003347de:  c0b4      push    {r6, r7}
0x003347e0:  0023      movs    r3, #0
0x003347e2:  0904      lsls    r1, r1, #0x10
0x003347e4:  071c      adds    r7, r0, #0
0x003347e6:  0e0c      lsrs    r6, r1, #0x10
0x003347e8:  9846      mov     r8, r3
0x003347ea:  05f0ddfb  bl      #0x339fa8  ; sub_00339fa8
0x003347ee:  bb8b      ldrh    r3, [r7, #0x1c]
0x003347f0:  7d69      ldr     r5, [r7, #0x14]
0x003347f2:  f318      adds    r3, r6, r3
0x003347f4:  1b04      lsls    r3, r3, #0x10
0x003347f6:  8246      mov     sl, r0
0x003347f8:  1e0c      lsrs    r6, r3, #0x10
0x003347fa:  1de0      b       #0x334838
0x003347fc:  ac68      ldr     r4, [r5, #8]
0x003347fe:  2d68      ldr     r5, [r5]
0x00334800:  a18f      ldrh    r1, [r4, #0x3c]
0x00334802:  b142      cmp     r1, r6
0x00334804:  1ad8      bhi     #0x33483c
0x00334806:  731a      subs    r3, r6, r1
0x00334808:  1b04      lsls    r3, r3, #0x10
0x0033480a:  1e0c      lsrs    r6, r3, #0x10
0x0033480c:  0023      movs    r3, #0
0x0033480e:  228e      ldrh    r2, [r4, #0x30]
0x00334810:  a387      strh    r3, [r4, #0x3c]
0x00334812:  124b      ldr     r3, [pc, #0x48]  ; =0xffff8000
0x00334814:  381c      adds    r0, r7, #0
0x00334816:  1340      ands    r3, r2
0x00334818:  0122      movs    r2, #1
0x0033481a:  1343      orrs    r3, r2
0x0033481c:  211c      adds    r1, r4, #0
0x0033481e:  2386      strh    r3, [r4, #0x30]
0x00334820:  1430      adds    r0, #0x14
0x00334822:  1431      adds    r1, #0x14
0x00334824:  02f044fe  bl      #0x3374b0  ; sub_003374b0
0x00334828:  0023      movs    r3, #0
0x0033482a:  2362      str     r3, [r4, #0x20]
0x0033482c:  0c48      ldr     r0, [pc, #0x30]  ; =0x002f5b40
0x0033482e:  211c      adds    r1, r4, #0
0x00334830:  fff742fd  bl      #0x3342b8  ; sub_003342b8
0x00334834:  0123      movs    r3, #1
0x00334836:  9846      mov     r8, r3
0x00334838:  002d      cmp     r5, #0
0x0033483a:  dfd1      bne     #0x3347fc
0x0033483c:  4346      mov     r3, r8
0x0033483e:  be83      strh    r6, [r7, #0x1c]
0x00334840:  002b      cmp     r3, #0
0x00334842:  08d1      bne     #0x334856
0x00334844:  5046      mov     r0, sl
0x00334846:  05f0b3fb  bl      #0x339fb0  ; sub_00339fb0
0x0033484a:  18bc      pop     {r3, r4}
0x0033484c:  9846      mov     r8, r3
0x0033484e:  a246      mov     sl, r4
0x00334850:  f0bc      pop     {r4, r5, r6, r7}
0x00334852:  01bc      pop     {r0}
0x00334854:  0047      bx      r0
0x00334856:  fff783fc  bl      #0x334160  ; sub_00334160
0x0033485a:  f3e7      b       #0x334844
0x0033485c:  0080      strh    r0, [r0]
0x0033485e:  ffff405b  vtbx.8  d21, {d15, d16, d17, d18}, d0
0x00334862:  2f00      movs    r7, r5
0x00334864:  10b5      push    {r4, lr}
0x00334866:  041c      adds    r4, r0, #0
0x00334868:  05f09efb  bl      #0x339fa8  ; sub_00339fa8
0x0033486c:  a48b      ldrh    r4, [r4, #0x1c]
0x0033486e:  05f09ffb  bl      #0x339fb0  ; sub_00339fb0
0x00334872:  201c      adds    r0, r4, #0
0x00334874:  10bc      pop     {r4}
0x00334876:  02bc      pop     {r1}
0x00334878:  0847      bx      r1
0x0033487a:  0000      movs    r0, r0
0x0033487c:  30b5      push    {r4, r5, lr}
0x0033487e:  041c      adds    r4, r0, #0
0x00334880:  211c      adds    r1, r4, #0
0x00334882:  0830      adds    r0, #8
0x00334884:  02f0b0fd  bl      #0x3373e8  ; sub_003373e8
0x00334888:  094b      ldr     r3, [pc, #0x24]  ; =0x00004556
0x0033488a:  2380      strh    r3, [r4]
0x0033488c:  0023      movs    r3, #0
0x0033488e:  6360      str     r3, [r4, #4]
0x00334890:  6361      str     r3, [r4, #0x14]
0x00334892:  a383      strh    r3, [r4, #0x1c]
0x00334894:  a361      str     r3, [r4, #0x18]
0x00334896:  05f087fb  bl      #0x339fa8  ; sub_00339fa8
0x0033489a:  211c      adds    r1, r4, #0
0x0033489c:  051c      adds    r5, r0, #0
0x0033489e:  0548      ldr     r0, [pc, #0x14]  ; =0x002f5fc0
0x003348a0:  fff7cefc  bl      #0x334240  ; sub_00334240
0x003348a4:  281c      adds    r0, r5, #0
0x003348a6:  05f083fb  bl      #0x339fb0  ; sub_00339fb0
0x003348aa:  30bc      pop     {r4, r5}
0x003348ac:  01bc      pop     {r0}
0x003348ae:  0047      bx      r0
0x003348b0:  5645      cmp     r6, sl
0x003348b2:  0000      movs    r0, r0
0x003348b4:  c05f      ldrsh   r0, [r0, r7]
0x003348b6:  2f00      movs    r7, r5
0x003348b8:  f0b5      push    {r4, r5, r6, r7, lr}
0x003348ba:  5746      mov     r7, sl
0x003348bc:  4646      mov     r6, r8
0x003348be:  c0b4      push    {r6, r7}
0x003348c0:  0023      movs    r3, #0
0x003348c2:  071c      adds    r7, r0, #0
0x003348c4:  9a46      mov     sl, r3
0x003348c6:  05f06ffb  bl      #0x339fa8  ; sub_00339fa8
0x003348ca:  7d69      ldr     r5, [r7, #0x14]
0x003348cc:  8046      mov     r8, r0
0x003348ce:  002d      cmp     r5, #0
0x003348d0:  18d0      beq     #0x334904
0x003348d2:  3e1c      adds    r6, r7, #0
0x003348d4:  0123      movs    r3, #1
0x003348d6:  1436      adds    r6, #0x14
0x003348d8:  9a46      mov     sl, r3
0x003348da:  ac68      ldr     r4, [r5, #8]
0x003348dc:  144b      ldr     r3, [pc, #0x50]  ; =0xffff8000
0x003348de:  228e      ldrh    r2, [r4, #0x30]
0x003348e0:  211c      adds    r1, r4, #0
0x003348e2:  1340      ands    r3, r2
0x003348e4:  0122      movs    r2, #1
0x003348e6:  1343      orrs    r3, r2
0x003348e8:  2386      strh    r3, [r4, #0x30]
0x003348ea:  301c      adds    r0, r6, #0
0x003348ec:  1431      adds    r1, #0x14
0x003348ee:  2d68      ldr     r5, [r5]
0x003348f0:  02f0defd  bl      #0x3374b0  ; sub_003374b0
0x003348f4:  0023      movs    r3, #0
0x003348f6:  2362      str     r3, [r4, #0x20]
0x003348f8:  0e48      ldr     r0, [pc, #0x38]  ; =0x002f5b40
0x003348fa:  211c      adds    r1, r4, #0
0x003348fc:  fff7dcfc  bl      #0x3342b8  ; sub_003342b8
0x00334900:  002d      cmp     r5, #0
0x00334902:  ead1      bne     #0x3348da
0x00334904:  391c      adds    r1, r7, #0
0x00334906:  0c48      ldr     r0, [pc, #0x30]  ; =0x002f5fc0
0x00334908:  0831      adds    r1, #8
0x0033490a:  02f0d1fd  bl      #0x3374b0  ; sub_003374b0
0x0033490e:  0023      movs    r3, #0
0x00334910:  3b80      strh    r3, [r7]
0x00334912:  5346      mov     r3, sl

===== sub_003347d8 @ 0x003347d8 =====
0x003347d8:  f0b5      push    {r4, r5, r6, r7, lr}
0x003347da:  5746      mov     r7, sl
0x003347dc:  4646      mov     r6, r8
0x003347de:  c0b4      push    {r6, r7}
0x003347e0:  0023      movs    r3, #0
0x003347e2:  0904      lsls    r1, r1, #0x10
0x003347e4:  071c      adds    r7, r0, #0
0x003347e6:  0e0c      lsrs    r6, r1, #0x10
0x003347e8:  9846      mov     r8, r3
0x003347ea:  05f0ddfb  bl      #0x339fa8  ; sub_00339fa8
0x003347ee:  bb8b      ldrh    r3, [r7, #0x1c]
0x003347f0:  7d69      ldr     r5, [r7, #0x14]
0x003347f2:  f318      adds    r3, r6, r3
0x003347f4:  1b04      lsls    r3, r3, #0x10
0x003347f6:  8246      mov     sl, r0
0x003347f8:  1e0c      lsrs    r6, r3, #0x10
0x003347fa:  1de0      b       #0x334838
0x003347fc:  ac68      ldr     r4, [r5, #8]
0x003347fe:  2d68      ldr     r5, [r5]
0x00334800:  a18f      ldrh    r1, [r4, #0x3c]
0x00334802:  b142      cmp     r1, r6
0x00334804:  1ad8      bhi     #0x33483c
0x00334806:  731a      subs    r3, r6, r1
0x00334808:  1b04      lsls    r3, r3, #0x10
0x0033480a:  1e0c      lsrs    r6, r3, #0x10
0x0033480c:  0023      movs    r3, #0
0x0033480e:  228e      ldrh    r2, [r4, #0x30]
0x00334810:  a387      strh    r3, [r4, #0x3c]
0x00334812:  124b      ldr     r3, [pc, #0x48]  ; =0xffff8000
0x00334814:  381c      adds    r0, r7, #0
0x00334816:  1340      ands    r3, r2
0x00334818:  0122      movs    r2, #1
0x0033481a:  1343      orrs    r3, r2
0x0033481c:  211c      adds    r1, r4, #0
0x0033481e:  2386      strh    r3, [r4, #0x30]
0x00334820:  1430      adds    r0, #0x14
0x00334822:  1431      adds    r1, #0x14
0x00334824:  02f044fe  bl      #0x3374b0  ; sub_003374b0
0x00334828:  0023      movs    r3, #0
0x0033482a:  2362      str     r3, [r4, #0x20]
0x0033482c:  0c48      ldr     r0, [pc, #0x30]  ; =0x002f5b40
0x0033482e:  211c      adds    r1, r4, #0
0x00334830:  fff742fd  bl      #0x3342b8  ; sub_003342b8
0x00334834:  0123      movs    r3, #1
0x00334836:  9846      mov     r8, r3
0x00334838:  002d      cmp     r5, #0
0x0033483a:  dfd1      bne     #0x3347fc
0x0033483c:  4346      mov     r3, r8
0x0033483e:  be83      strh    r6, [r7, #0x1c]
0x00334840:  002b      cmp     r3, #0
0x00334842:  08d1      bne     #0x334856
0x00334844:  5046      mov     r0, sl
0x00334846:  05f0b3fb  bl      #0x339fb0  ; sub_00339fb0
0x0033484a:  18bc      pop     {r3, r4}
0x0033484c:  9846      mov     r8, r3
0x0033484e:  a246      mov     sl, r4
0x00334850:  f0bc      pop     {r4, r5, r6, r7}
0x00334852:  01bc      pop     {r0}
0x00334854:  0047      bx      r0
0x00334856:  fff783fc  bl      #0x334160  ; sub_00334160
0x0033485a:  f3e7      b       #0x334844
0x0033485c:  0080      strh    r0, [r0]
0x0033485e:  ffff405b  vtbx.8  d21, {d15, d16, d17, d18}, d0
0x00334862:  2f00      movs    r7, r5
0x00334864:  10b5      push    {r4, lr}
0x00334866:  041c      adds    r4, r0, #0
0x00334868:  05f09efb  bl      #0x339fa8  ; sub_00339fa8
0x0033486c:  a48b      ldrh    r4, [r4, #0x1c]
0x0033486e:  05f09ffb  bl      #0x339fb0  ; sub_00339fb0
0x00334872:  201c      adds    r0, r4, #0
0x00334874:  10bc      pop     {r4}
0x00334876:  02bc      pop     {r1}
0x00334878:  0847      bx      r1
0x0033487a:  0000      movs    r0, r0
0x0033487c:  30b5      push    {r4, r5, lr}
0x0033487e:  041c      adds    r4, r0, #0
0x00334880:  211c      adds    r1, r4, #0
0x00334882:  0830      adds    r0, #8
0x00334884:  02f0b0fd  bl      #0x3373e8  ; sub_003373e8
0x00334888:  094b      ldr     r3, [pc, #0x24]  ; =0x00004556
0x0033488a:  2380      strh    r3, [r4]
0x0033488c:  0023      movs    r3, #0
0x0033488e:  6360      str     r3, [r4, #4]
0x00334890:  6361      str     r3, [r4, #0x14]
0x00334892:  a383      strh    r3, [r4, #0x1c]
0x00334894:  a361      str     r3, [r4, #0x18]
0x00334896:  05f087fb  bl      #0x339fa8  ; sub_00339fa8
0x0033489a:  211c      adds    r1, r4, #0
0x0033489c:  051c      adds    r5, r0, #0
0x0033489e:  0548      ldr     r0, [pc, #0x14]  ; =0x002f5fc0
0x003348a0:  fff7cefc  bl      #0x334240  ; sub_00334240
0x003348a4:  281c      adds    r0, r5, #0
0x003348a6:  05f083fb  bl      #0x339fb0  ; sub_00339fb0
0x003348aa:  30bc      pop     {r4, r5}
0x003348ac:  01bc      pop     {r0}
0x003348ae:  0047      bx      r0
0x003348b0:  5645      cmp     r6, sl
0x003348b2:  0000      movs    r0, r0
0x003348b4:  c05f      ldrsh   r0, [r0, r7]
0x003348b6:  2f00      movs    r7, r5
0x003348b8:  f0b5      push    {r4, r5, r6, r7, lr}
0x003348ba:  5746      mov     r7, sl
0x003348bc:  4646      mov     r6, r8
0x003348be:  c0b4      push    {r6, r7}
0x003348c0:  0023      movs    r3, #0
0x003348c2:  071c      adds    r7, r0, #0
0x003348c4:  9a46      mov     sl, r3
0x003348c6:  05f06ffb  bl      #0x339fa8  ; sub_00339fa8
0x003348ca:  7d69      ldr     r5, [r7, #0x14]
0x003348cc:  8046      mov     r8, r0
0x003348ce:  002d      cmp     r5, #0
0x003348d0:  18d0      beq     #0x334904
0x003348d2:  3e1c      adds    r6, r7, #0
0x003348d4:  0123      movs    r3, #1
0x003348d6:  1436      adds    r6, #0x14
0x003348d8:  9a46      mov     sl, r3
0x003348da:  ac68      ldr     r4, [r5, #8]
0x003348dc:  144b      ldr     r3, [pc, #0x50]  ; =0xffff8000
0x003348de:  228e      ldrh    r2, [r4, #0x30]
0x003348e0:  211c      adds    r1, r4, #0
0x003348e2:  1340      ands    r3, r2
0x003348e4:  0122      movs    r2, #1
0x003348e6:  1343      orrs    r3, r2
0x003348e8:  2386      strh    r3, [r4, #0x30]
0x003348ea:  301c      adds    r0, r6, #0
0x003348ec:  1431      adds    r1, #0x14
0x003348ee:  2d68      ldr     r5, [r5]
0x003348f0:  02f0defd  bl      #0x3374b0  ; sub_003374b0
0x003348f4:  0023      movs    r3, #0
0x003348f6:  2362      str     r3, [r4, #0x20]
0x003348f8:  0e48      ldr     r0, [pc, #0x38]  ; =0x002f5b40
0x003348fa:  211c      adds    r1, r4, #0
0x003348fc:  fff7dcfc  bl      #0x3342b8  ; sub_003342b8
0x00334900:  002d      cmp     r5, #0
0x00334902:  ead1      bne     #0x3348da
0x00334904:  391c      adds    r1, r7, #0
0x00334906:  0c48      ldr     r0, [pc, #0x30]  ; =0x002f5fc0
0x00334908:  0831      adds    r1, #8
0x0033490a:  02f0d1fd  bl      #0x3374b0  ; sub_003374b0
0x0033490e:  0023      movs    r3, #0
0x00334910:  3b80      strh    r3, [r7]
0x00334912:  5346      mov     r3, sl
0x00334914:  002b      cmp     r3, #0
0x00334916:  08d1      bne     #0x33492a
0x00334918:  4046      mov     r0, r8
0x0033491a:  05f049fb  bl      #0x339fb0  ; sub_00339fb0
0x0033491e:  18bc      pop     {r3, r4}
0x00334920:  9846      mov     r8, r3
0x00334922:  a246      mov     sl, r4
0x00334924:  f0bc      pop     {r4, r5, r6, r7}
0x00334926:  01bc      pop     {r0}
0x00334928:  0047      bx      r0
0x0033492a:  fff719fc  bl      #0x334160  ; sub_00334160
0x0033492e:  f3e7      b       #0x334918
0x00334930:  0080      strh    r0, [r0]
0x00334932:  ffff405b  vtbx.8  d21, {d15, d16, d17, d18}, d0
0x00334936:  2f00      movs    r7, r5
0x00334938:  c05f      ldrsh   r0, [r0, r7]
0x0033493a:  2f00      movs    r7, r5
0x0033493c:  70b5      push    {r4, r5, r6, lr}
0x0033493e:  051c      adds    r5, r0, #0
0x00334940:  05f032fb  bl      #0x339fa8  ; sub_00339fa8
0x00334944:  284b      ldr     r3, [pc, #0xa0]  ; =0x002f5b90
0x00334946:  061c      adds    r6, r0, #0
0x00334948:  1b88      ldrh    r3, [r3]
0x0033494a:  002b      cmp     r3, #0
0x0033494c:  26d1      bne     #0x33499c
0x0033494e:  aa8b      ldrh    r2, [r5, #0x1c]
0x00334950:  002a      cmp     r2, #0
0x00334952:  0dd0      beq     #0x334970
0x00334954:  531e      subs    r3, r2, #1
0x00334956:  ab83      strh    r3, [r5, #0x1c]
0x00334958:  6b69      ldr     r3, [r5, #0x14]
0x0033495a:  002b      cmp     r3, #0
0x0033495c:  2ed1      bne     #0x3349bc
0x0033495e:  234b      ldr     r3, [pc, #0x8c]  ; =0x002f6000
0x00334960:  1b68      ldr     r3, [r3]
0x00334962:  ab61      str     r3, [r5, #0x18]
0x00334964:  301c      adds    r0, r6, #0
0x00334966:  05f023fb  bl      #0x339fb0  ; sub_00339fb0
0x0033496a:  70bc      pop     {r4, r5, r6}
0x0033496c:  01bc      pop     {r0}
0x0033496e:  0047      bx      r0
0x00334970:  1e4c      ldr     r4, [pc, #0x78]  ; =0x002f6000
0x00334972:  1f4b      ldr     r3, [pc, #0x7c]  ; =0xffff8000
0x00334974:  2168      ldr     r1, [r4]
0x00334976:  1f48      ldr     r0, [pc, #0x7c]  ; =0x002f5b40
0x00334978:  0a8e      ldrh    r2, [r1, #0x30]
0x0033497a:  1340      ands    r3, r2
0x0033497c:  0222      movs    r2, #2
0x0033497e:  1343      orrs    r3, r2
0x00334980:  0b86      strh    r3, [r1, #0x30]
0x00334982:  1431      adds    r1, #0x14
0x00334984:  02f094fd  bl      #0x3374b0  ; sub_003374b0
0x00334988:  2168      ldr     r1, [r4]
0x0033498a:  281c      adds    r0, r5, #0
0x0033498c:  1430      adds    r0, #0x14
0x0033498e:  0862      str     r0, [r1, #0x20]
0x00334990:  1431      adds    r1, #0x14
0x00334992:  02f049fd  bl      #0x337428  ; sub_00337428
0x00334996:  fff7e3fb  bl      #0x334160  ; sub_00334160
0x0033499a:  e0e7      b       #0x33495e
0x0033499c:  1649      ldr     r1, [pc, #0x58]  ; =0x002f5fe0
0x0033499e:  174b      ldr     r3, [pc, #0x5c]  ; =0x00000fff
0x003349a0:  0a88      ldrh    r2, [r1]
0x003349a2:  1340      ands    r3, r2
0x003349a4:  8022      movs    r2, #0x80
0x003349a6:  9201      lsls    r2, r2, #6
0x003349a8:  0133      adds    r3, #1
0x003349aa:  1343      orrs    r3, r2
0x003349ac:  0b80      strh    r3, [r1]
0x003349ae:  0f4b      ldr     r3, [pc, #0x3c]  ; =0x002f6000
0x003349b0:  1a68      ldr     r2, [r3]
0x003349b2:  134b      ldr     r3, [pc, #0x4c]  ; =0x002f5a60
0x003349b4:  1a60      str     r2, [r3]
0x003349b6:  134b      ldr     r3, [pc, #0x4c]  ; =0x002f5aa0

===== sub_00335034 @ 0x00335034 =====
0x00335034:  70b5      push    {r4, r5, r6, lr}
0x00335036:  244b      ldr     r3, [pc, #0x90]  ; =0x002f5b90
0x00335038:  0004      lsls    r0, r0, #0x10
0x0033503a:  1b88      ldrh    r3, [r3]
0x0033503c:  050c      lsrs    r5, r0, #0x10
0x0033503e:  002b      cmp     r3, #0
0x00335040:  10d0      beq     #0x335064
0x00335042:  2249      ldr     r1, [pc, #0x88]  ; =0x002f5fe0
0x00335044:  224b      ldr     r3, [pc, #0x88]  ; =0x00000fff
0x00335046:  0a88      ldrh    r2, [r1]
0x00335048:  0020      movs    r0, #0
0x0033504a:  1340      ands    r3, r2
0x0033504c:  a022      movs    r2, #0xa0
0x0033504e:  d201      lsls    r2, r2, #7
0x00335050:  0133      adds    r3, #1
0x00335052:  1343      orrs    r3, r2
0x00335054:  0b80      strh    r3, [r1]
0x00335056:  1f4b      ldr     r3, [pc, #0x7c]  ; =0x002f6000
0x00335058:  1a68      ldr     r2, [r3]
0x0033505a:  1f4b      ldr     r3, [pc, #0x7c]  ; =0x002f5a60
0x0033505c:  1a60      str     r2, [r3]
0x0033505e:  70bc      pop     {r4, r5, r6}
0x00335060:  02bc      pop     {r1}
0x00335062:  0847      bx      r1
0x00335064:  002d      cmp     r5, #0
0x00335066:  01d1      bne     #0x33506c
0x00335068:  281c      adds    r0, r5, #0
0x0033506a:  f8e7      b       #0x33505e
0x0033506c:  04f09cff  bl      #0x339fa8  ; sub_00339fa8
0x00335070:  184c      ldr     r4, [pc, #0x60]  ; =0x002f6000
0x00335072:  1a4b      ldr     r3, [pc, #0x68]  ; =0xffff8000
0x00335074:  2168      ldr     r1, [r4]
0x00335076:  061c      adds    r6, r0, #0
0x00335078:  0a8e      ldrh    r2, [r1, #0x30]
0x0033507a:  8d87      strh    r5, [r1, #0x3c]
0x0033507c:  1340      ands    r3, r2
0x0033507e:  0222      movs    r2, #2
0x00335080:  1343      orrs    r3, r2
0x00335082:  0b86      strh    r3, [r1, #0x30]
0x00335084:  1648      ldr     r0, [pc, #0x58]  ; =0x002f5b40
0x00335086:  1431      adds    r1, #0x14
0x00335088:  02f012fa  bl      #0x3374b0  ; sub_003374b0
0x0033508c:  2468      ldr     r4, [r4]
0x0033508e:  1548      ldr     r0, [pc, #0x54]  ; =0x002f5b00
0x00335090:  a58f      ldrh    r5, [r4, #0x3c]
0x00335092:  0268      ldr     r2, [r0]
0x00335094:  0021      movs    r1, #0
0x00335096:  2062      str     r0, [r4, #0x20]
0x00335098:  05e0      b       #0x3350a6
0x0033509a:  9368      ldr     r3, [r2, #8]
0x0033509c:  9b8f      ldrh    r3, [r3, #0x3c]
0x0033509e:  ab42      cmp     r3, r5
0x003350a0:  03d2      bhs     #0x3350aa
0x003350a2:  111c      adds    r1, r2, #0
0x003350a4:  1268      ldr     r2, [r2]
0x003350a6:  002a      cmp     r2, #0
0x003350a8:  f7d1      bne     #0x33509a
0x003350aa:  221c      adds    r2, r4, #0
0x003350ac:  1432      adds    r2, #0x14
0x003350ae:  02f0a1f9  bl      #0x3373f4  ; sub_003373f4
0x003350b2:  fff755f8  bl      #0x334160  ; sub_00334160
0x003350b6:  074b      ldr     r3, [pc, #0x1c]  ; =0x002f6000
0x003350b8:  301c      adds    r0, r6, #0
0x003350ba:  1b68      ldr     r3, [r3]
0x003350bc:  9d8f      ldrh    r5, [r3, #0x3c]
0x003350be:  04f077ff  bl      #0x339fb0  ; sub_00339fb0
0x003350c2:  281c      adds    r0, r5, #0
0x003350c4:  cbe7      b       #0x33505e
0x003350c6:  0000      movs    r0, r0
0x003350c8:  905b      ldrh    r0, [r2, r6]
0x003350ca:  2f00      movs    r7, r5
0x003350cc:  e05f      ldrsh   r0, [r4, r7]
0x003350ce:  2f00      movs    r7, r5
0x003350d0:  ff0f      lsrs    r7, r7, #0x1f
0x003350d2:  0000      movs    r0, r0
0x003350d4:  0060      str     r0, [r0]
0x003350d6:  2f00      movs    r7, r5
0x003350d8:  605a      ldrh    r0, [r4, r1]
0x003350da:  2f00      movs    r7, r5
0x003350dc:  0080      strh    r0, [r0]
0x003350de:  ffff405b  vtbx.8  d21, {d15, d16, d17, d18}, d0
0x003350e2:  2f00      movs    r7, r5
0x003350e4:  005b      ldrh    r0, [r0, r4]
0x003350e6:  2f00      movs    r7, r5
0x003350e8:  70b5      push    {r4, r5, r6, lr}
0x003350ea:  041c      adds    r4, r0, #0
0x003350ec:  04f05cff  bl      #0x339fa8  ; sub_00339fa8
0x003350f0:  0f4b      ldr     r3, [pc, #0x3c]  ; =0x002f5b00
0x003350f2:  061c      adds    r6, r0, #0
0x003350f4:  206a      ldr     r0, [r4, #0x20]
0x003350f6:  0025      movs    r5, #0
0x003350f8:  9842      cmp     r0, r3
0x003350fa:  06d0      beq     #0x33510a
0x003350fc:  301c      adds    r0, r6, #0
0x003350fe:  04f057ff  bl      #0x339fb0  ; sub_00339fb0
0x00335102:  281c      adds    r0, r5, #0
0x00335104:  70bc      pop     {r4, r5, r6}
0x00335106:  02bc      pop     {r1}
0x00335108:  0847      bx      r1
0x0033510a:  238e      ldrh    r3, [r4, #0x30]
0x0033510c:  094a      ldr     r2, [pc, #0x24]  ; =0xffff8000
0x0033510e:  211c      adds    r1, r4, #0
0x00335110:  1a40      ands    r2, r3
0x00335112:  0123      movs    r3, #1
0x00335114:  1a43      orrs    r2, r3
0x00335116:  2286      strh    r2, [r4, #0x30]
0x00335118:  1431      adds    r1, #0x14
0x0033511a:  02f0c9f9  bl      #0x3374b0  ; sub_003374b0
0x0033511e:  2562      str     r5, [r4, #0x20]
0x00335120:  0548      ldr     r0, [pc, #0x14]  ; =0x002f5b40
0x00335122:  211c      adds    r1, r4, #0
0x00335124:  fff7c8f8  bl      #0x3342b8  ; sub_003342b8
0x00335128:  a58f      ldrh    r5, [r4, #0x3c]
0x0033512a:  fff719f8  bl      #0x334160  ; sub_00334160
0x0033512e:  e5e7      b       #0x3350fc
0x00335130:  005b      ldrh    r0, [r0, r4]
0x00335132:  2f00      movs    r7, r5
0x00335134:  0080      strh    r0, [r0]
0x00335136:  ffff405b  vtbx.8  d21, {d15, d16, d17, d18}, d0
0x0033513a:  2f00      movs    r7, r5
0x0033513c:  0028      cmp     r0, #0
0x0033513e:  01d0      beq     #0x335144
0x00335140:  4160      str     r1, [r0, #4]
0x00335142:  7047      bx      lr

===== sub_0033513c @ 0x0033513c =====
0x0033513c:  0028      cmp     r0, #0
0x0033513e:  01d0      beq     #0x335144
0x00335140:  4160      str     r1, [r0, #4]
0x00335142:  7047      bx      lr

===== sub_00335210 @ 0x00335210 =====
0x00335210:  10b5      push    {r4, lr}
0x00335212:  04f0c9fe  bl      #0x339fa8  ; sub_00339fa8
0x00335216:  044b      ldr     r3, [pc, #0x10]  ; =0x002f5ae0
0x00335218:  1c68      ldr     r4, [r3]
0x0033521a:  04f0c9fe  bl      #0x339fb0  ; sub_00339fb0
0x0033521e:  201c      adds    r0, r4, #0
0x00335220:  10bc      pop     {r4}
0x00335222:  02bc      pop     {r1}
0x00335224:  0847      bx      r1
0x00335226:  0000      movs    r0, r0
0x00335228:  e05a      ldrh    r0, [r4, r3]
0x0033522a:  2f00      movs    r7, r5
0x0033522c:  10b5      push    {r4, lr}
0x0033522e:  041c      adds    r4, r0, #0
0x00335230:  04f0bafe  bl      #0x339fa8  ; sub_00339fa8
0x00335234:  034b      ldr     r3, [pc, #0xc]  ; =0x002f5ae0
0x00335236:  1c60      str     r4, [r3]
0x00335238:  04f0bafe  bl      #0x339fb0  ; sub_00339fb0
0x0033523c:  10bc      pop     {r4}
0x0033523e:  01bc      pop     {r0}
0x00335240:  0047      bx      r0
0x00335242:  0000      movs    r0, r0
0x00335244:  e05a      ldrh    r0, [r4, r3]
0x00335246:  2f00      movs    r7, r5
0x00335248:  70b5      push    {r4, r5, r6, lr}
0x0033524a:  224b      ldr     r3, [pc, #0x88]  ; =0x002f6000
0x0033524c:  0020      movs    r0, #0
0x0033524e:  1968      ldr     r1, [r3]
0x00335250:  0029      cmp     r1, #0
0x00335252:  2ed0      beq     #0x3352b2
0x00335254:  204b      ldr     r3, [pc, #0x80]  ; =0x002f5ae0
0x00335256:  0c1c      adds    r4, r1, #0
0x00335258:  1a68      ldr     r2, [r3]
0x0033525a:  0132      adds    r2, #1
0x0033525c:  1a60      str     r2, [r3]
0x0033525e:  098f      ldrh    r1, [r1, #0x38]
0x00335260:  0029      cmp     r1, #0
0x00335262:  29d1      bne     #0x3352b8
0x00335264:  1d4b      ldr     r3, [pc, #0x74]  ; =0x002f5b00
0x00335266:  1d68      ldr     r5, [r3]
0x00335268:  002d      cmp     r5, #0
0x0033526a:  1ed0      beq     #0x3352aa
0x0033526c:  ac68      ldr     r4, [r5, #8]
0x0033526e:  2d68      ldr     r5, [r5]
0x00335270:  a28f      ldrh    r2, [r4, #0x3c]
0x00335272:  002a      cmp     r2, #0
0x00335274:  02d0      beq     #0x33527c
0x00335276:  531e      subs    r3, r2, #1
0x00335278:  a387      strh    r3, [r4, #0x3c]
0x0033527a:  1a1c      adds    r2, r3, #0
0x0033527c:  1304      lsls    r3, r2, #0x10
0x0033527e:  1e0c      lsrs    r6, r3, #0x10
0x00335280:  002e      cmp     r6, #0
0x00335282:  f1d1      bne     #0x335268
0x00335284:  238e      ldrh    r3, [r4, #0x30]
0x00335286:  164a      ldr     r2, [pc, #0x58]  ; =0xffff8000
0x00335288:  211c      adds    r1, r4, #0
0x0033528a:  1a40      ands    r2, r3
0x0033528c:  0123      movs    r3, #1
0x0033528e:  1a43      orrs    r2, r3
0x00335290:  2286      strh    r2, [r4, #0x30]
0x00335292:  1248      ldr     r0, [pc, #0x48]  ; =0x002f5b00
0x00335294:  1431      adds    r1, #0x14
0x00335296:  02f00bf9  bl      #0x3374b0  ; sub_003374b0
0x0033529a:  1248      ldr     r0, [pc, #0x48]  ; =0x002f5b40
0x0033529c:  2662      str     r6, [r4, #0x20]
0x0033529e:  211c      adds    r1, r4, #0
0x003352a0:  fff70af8  bl      #0x3342b8  ; sub_003342b8
0x003352a4:  0120      movs    r0, #1
0x003352a6:  002d      cmp     r5, #0
0x003352a8:  e0d1      bne     #0x33526c
0x003352aa:  0028      cmp     r0, #0
0x003352ac:  01d0      beq     #0x3352b2
0x003352ae:  fef757ff  bl      #0x334160  ; sub_00334160
0x003352b2:  70bc      pop     {r4, r5, r6}
0x003352b4:  01bc      pop     {r0}
0x003352b6:  0047      bx      r0
0x003352b8:  638f      ldrh    r3, [r4, #0x3a]
0x003352ba:  5a1e      subs    r2, r3, #1
0x003352bc:  1304      lsls    r3, r2, #0x10
0x003352be:  002b      cmp     r3, #0
0x003352c0:  01d0      beq     #0x3352c6
0x003352c2:  6287      strh    r2, [r4, #0x3a]
0x003352c4:  cee7      b       #0x335264
0x003352c6:  6187      strh    r1, [r4, #0x3a]
0x003352c8:  0648      ldr     r0, [pc, #0x18]  ; =0x002f5b40
0x003352ca:  211c      adds    r1, r4, #0
0x003352cc:  fef7d4ff  bl      #0x334278  ; sub_00334278
0x003352d0:  0120      movs    r0, #1
0x003352d2:  c7e7      b       #0x335264
0x003352d4:  0060      str     r0, [r0]
0x003352d6:  2f00      movs    r7, r5
0x003352d8:  e05a      ldrh    r0, [r4, r3]
0x003352da:  2f00      movs    r7, r5
0x003352dc:  005b      ldrh    r0, [r0, r4]
0x003352de:  2f00      movs    r7, r5
0x003352e0:  0080      strh    r0, [r0]
0x003352e2:  ffff405b  vtbx.8  d21, {d15, d16, d17, d18}, d0
0x003352e6:  2f00      movs    r7, r5
0x003352e8:  f0b5      push    {r4, r5, r6, r7, lr}
0x003352ea:  474b      ldr     r3, [pc, #0x11c]  ; =0x002f6000
0x003352ec:  0027      movs    r7, #0
0x003352ee:  1b68      ldr     r3, [r3]
0x003352f0:  002b      cmp     r3, #0
0x003352f2:  75d0      beq     #0x3353e0
0x003352f4:  454b      ldr     r3, [pc, #0x114]  ; =0x002f5540
0x003352f6:  1c68      ldr     r4, [r3]
0x003352f8:  002c      cmp     r4, #0
0x003352fa:  0cd0      beq     #0x335316
0x003352fc:  a168      ldr     r1, [r4, #8]
0x003352fe:  444b      ldr     r3, [pc, #0x110]  ; =0x002f5b70
0x00335300:  2468      ldr     r4, [r4]
0x00335302:  1a88      ldrh    r2, [r3]
0x00335304:  4b69      ldr     r3, [r1, #0x14]
0x00335306:  9b18      adds    r3, r3, r2
0x00335308:  8a69      ldr     r2, [r1, #0x18]
0x0033530a:  9342      cmp     r3, r2
0x0033530c:  00d3      blo     #0x335310
0x0033530e:  6ae0      b       #0x3353e6
0x00335310:  4b61      str     r3, [r1, #0x14]
0x00335312:  002c      cmp     r4, #0
0x00335314:  f2d1      bne     #0x3352fc
0x00335316:  3f4b      ldr     r3, [pc, #0xfc]  ; =0x002f5a40
0x00335318:  1c68      ldr     r4, [r3]
0x0033531a:  002c      cmp     r4, #0
0x0033531c:  1cd0      beq     #0x335358
0x0033531e:  a568      ldr     r5, [r4, #8]
0x00335320:  2b6d      ldr     r3, [r5, #0x50]
0x00335322:  002b      cmp     r3, #0
0x00335324:  03d0      beq     #0x33532e
0x00335326:  013b      subs    r3, #1
0x00335328:  2b65      str     r3, [r5, #0x50]
0x0033532a:  002b      cmp     r3, #0
0x0033532c:  14d1      bne     #0x335358
0x0033532e:  0127      movs    r7, #1
0x00335330:  2b8e      ldrh    r3, [r5, #0x30]
0x00335332:  394a      ldr     r2, [pc, #0xe4]  ; =0xffff8000
0x00335334:  2468      ldr     r4, [r4]
0x00335336:  1a40      ands    r2, r3
0x00335338:  0123      movs    r3, #1
0x0033533a:  1a43      orrs    r2, r3
0x0033533c:  281c      adds    r0, r5, #0
0x0033533e:  2a86      strh    r2, [r5, #0x30]
0x00335340:  fef7d2ff  bl      #0x3342e8  ; sub_003342e8
0x00335344:  3548      ldr     r0, [pc, #0xd4]  ; =0x002f5b40
0x00335346:  291c      adds    r1, r5, #0
0x00335348:  fef7b6ff  bl      #0x3342b8  ; sub_003342b8
0x0033534c:  002c      cmp     r4, #0
0x0033534e:  03d0      beq     #0x335358
0x00335350:  a568      ldr     r5, [r4, #8]
0x00335352:  2b6d      ldr     r3, [r5, #0x50]
0x00335354:  002b      cmp     r3, #0
0x00335356:  ebd0      beq     #0x335330
0x00335358:  314c      ldr     r4, [pc, #0xc4]  ; =0x002f5b80
0x0033535a:  2d4b      ldr     r3, [pc, #0xb4]  ; =0x002f5b70
0x0033535c:  2288      ldrh    r2, [r4]
0x0033535e:  1b88      ldrh    r3, [r3]
0x00335360:  d118      adds    r1, r2, r3
0x00335362:  304a      ldr     r2, [pc, #0xc0]  ; =0x002f6010
0x00335364:  0b04      lsls    r3, r1, #0x10
0x00335366:  1088      ldrh    r0, [r2]
0x00335368:  1b0c      lsrs    r3, r3, #0x10
0x0033536a:  021c      adds    r2, r0, #0
0x0033536c:  9342      cmp     r3, r2
0x0033536e:  41d3      blo     #0x3353f4
0x00335370:  2d4a      ldr     r2, [pc, #0xb4]  ; =0x002f5ae0
0x00335372:  0b1a      subs    r3, r1, r0
0x00335374:  2380      strh    r3, [r4]
0x00335376:  1368      ldr     r3, [r2]
0x00335378:  0133      adds    r3, #1
0x0033537a:  1360      str     r3, [r2]
0x0033537c:  224b      ldr     r3, [pc, #0x88]  ; =0x002f6000
0x0033537e:  1d68      ldr     r5, [r3]
0x00335380:  298f      ldrh    r1, [r5, #0x38]
0x00335382:  0029      cmp     r1, #0
0x00335384:  05d0      beq     #0x335392
0x00335386:  6b8f      ldrh    r3, [r5, #0x3a]
0x00335388:  5a1e      subs    r2, r3, #1
0x0033538a:  1304      lsls    r3, r2, #0x10
0x0033538c:  002b      cmp     r3, #0
0x0033538e:  33d0      beq     #0x3353f8
0x00335390:  6a87      strh    r2, [r5, #0x3a]
0x00335392:  264b      ldr     r3, [pc, #0x98]  ; =0x002f5b00
0x00335394:  1c68      ldr     r4, [r3]
0x00335396:  002c      cmp     r4, #0
0x00335398:  1ed0      beq     #0x3353d8
0x0033539a:  a568      ldr     r5, [r4, #8]
0x0033539c:  2468      ldr     r4, [r4]
0x0033539e:  aa8f      ldrh    r2, [r5, #0x3c]
0x003353a0:  002a      cmp     r2, #0
0x003353a2:  02d0      beq     #0x3353aa
0x003353a4:  531e      subs    r3, r2, #1
0x003353a6:  ab87      strh    r3, [r5, #0x3c]
0x003353a8:  1a1c      adds    r2, r3, #0
0x003353aa:  1304      lsls    r3, r2, #0x10
0x003353ac:  1e0c      lsrs    r6, r3, #0x10
0x003353ae:  002e      cmp     r6, #0
0x003353b0:  f1d1      bne     #0x335396
0x003353b2:  2b8e      ldrh    r3, [r5, #0x30]
0x003353b4:  184a      ldr     r2, [pc, #0x60]  ; =0xffff8000
0x003353b6:  291c      adds    r1, r5, #0
0x003353b8:  1a40      ands    r2, r3
0x003353ba:  0123      movs    r3, #1
0x003353bc:  1a43      orrs    r2, r3
0x003353be:  2a86      strh    r2, [r5, #0x30]
0x003353c0:  1a48      ldr     r0, [pc, #0x68]  ; =0x002f5b00
0x003353c2:  1431      adds    r1, #0x14
0x003353c4:  02f074f8  bl      #0x3374b0  ; sub_003374b0
0x003353c8:  2e62      str     r6, [r5, #0x20]
0x003353ca:  1448      ldr     r0, [pc, #0x50]  ; =0x002f5b40
0x003353cc:  291c      adds    r1, r5, #0
0x003353ce:  fef773ff  bl      #0x3342b8  ; sub_003342b8
0x003353d2:  0127      movs    r7, #1
0x003353d4:  002c      cmp     r4, #0
0x003353d6:  e0d1      bne     #0x33539a
0x003353d8:  002f      cmp     r7, #0
0x003353da:  01d0      beq     #0x3353e0
0x003353dc:  fef7c0fe  bl      #0x334160  ; sub_00334160
0x003353e0:  f0bc      pop     {r4, r5, r6, r7}
0x003353e2:  01bc      pop     {r0}
0x003353e4:  0047      bx      r0
0x003353e6:  9b1a      subs    r3, r3, r2
0x003353e8:  4b61      str     r3, [r1, #0x14]
0x003353ea:  c869      ldr     r0, [r1, #0x1c]
0x003353ec:  0b6a      ldr     r3, [r1, #0x20]

===== sub_003357ac @ 0x003357ac =====
0x003357ac:  30b5      push    {r4, r5, lr}
0x003357ae:  04f0fbfb  bl      #0x339fa8  ; sub_00339fa8
0x003357b2:  084b      ldr     r3, [pc, #0x20]  ; =0x002f6010
0x003357b4:  fa21      movs    r1, #0xfa
0x003357b6:  041c      adds    r4, r0, #0
0x003357b8:  8900      lsls    r1, r1, #2
0x003357ba:  1888      ldrh    r0, [r3]
0x003357bc:  04f02efa  bl      #0x339c1c  ; sub_00339c1c
0x003357c0:  0504      lsls    r5, r0, #0x10
0x003357c2:  201c      adds    r0, r4, #0
0x003357c4:  04f0f4fb  bl      #0x339fb0  ; sub_00339fb0
0x003357c8:  2d0c      lsrs    r5, r5, #0x10
0x003357ca:  281c      adds    r0, r5, #0
0x003357cc:  30bc      pop     {r4, r5}
0x003357ce:  02bc      pop     {r1}
0x003357d0:  0847      bx      r1
0x003357d2:  0000      movs    r0, r0
0x003357d4:  1060      str     r0, [r2]
0x003357d6:  2f00      movs    r7, r5
0x003357d8:  00b5      push    {lr}
0x003357da:  064b      ldr     r3, [pc, #0x18]  ; =0x002f5fd0
0x003357dc:  0020      movs    r0, #0
0x003357de:  1b88      ldrh    r3, [r3]
0x003357e0:  002b      cmp     r3, #0
0x003357e2:  04d1      bne     #0x3357ee
0x003357e4:  044b      ldr     r3, [pc, #0x10]  ; =0x002f5b90
0x003357e6:  1b88      ldrh    r3, [r3]
0x003357e8:  002b      cmp     r3, #0
0x003357ea:  00d1      bne     #0x3357ee
0x003357ec:  0120      movs    r0, #1
0x003357ee:  02bc      pop     {r1}
0x003357f0:  0847      bx      r1
0x003357f2:  0000      movs    r0, r0
0x003357f4:  d05f      ldrsh   r0, [r2, r7]
0x003357f6:  2f00      movs    r7, r5
0x003357f8:  905b      ldrh    r0, [r2, r6]
0x003357fa:  2f00      movs    r7, r5
0x003357fc:  7047      bx      lr

===== sub_00335e70 @ 0x00335e70 =====
0x00335e70:  30b5      push    {r4, r5, lr}
0x00335e72:  051c      adds    r5, r0, #0
0x00335e74:  fef7c4f9  bl      #0x334200  ; sub_00334200
0x00335e78:  1f4b      ldr     r3, [pc, #0x7c]  ; =0x002f61c0
0x00335e7a:  1c68      ldr     r4, [r3]
0x00335e7c:  002c      cmp     r4, #0
0x00335e7e:  13d0      beq     #0x335ea8
0x00335e80:  0120      movs    r0, #1
0x00335e82:  221c      adds    r2, r4, #0
0x00335e84:  02e0      b       #0x335e8c
0x00335e86:  d368      ldr     r3, [r2, #0xc]
0x00335e88:  9b18      adds    r3, r3, r2
0x00335e8a:  1a1c      adds    r2, r3, #0
0x00335e8c:  1032      adds    r2, #0x10
0x00335e8e:  5388      ldrh    r3, [r2, #2]
0x00335e90:  1904      lsls    r1, r3, #0x10
0x00335e92:  1842      tst     r0, r3
0x00335e94:  02d1      bne     #0x335e9c
0x00335e96:  d368      ldr     r3, [r2, #0xc]
0x00335e98:  ab42      cmp     r3, r5
0x00335e9a:  0ed2      bhs     #0x335eba
0x00335e9c:  8b0c      lsrs    r3, r1, #0x12
0x00335e9e:  0342      tst     r3, r0
0x00335ea0:  f1d0      beq     #0x335e86
0x00335ea2:  a468      ldr     r4, [r4, #8]
0x00335ea4:  002c      cmp     r4, #0
0x00335ea6:  ecd1      bne     #0x335e82
0x00335ea8:  fef7baf9  bl      #0x334220  ; sub_00334220
0x00335eac:  1348      ldr     r0, [pc, #0x4c]  ; =0x00385cf8 &"#MALLOC:Failed!"
0x00335eae:  01f039f8  bl      #0x336f24  ; sub_00336f24
0x00335eb2:  0020      movs    r0, #0
0x00335eb4:  30bc      pop     {r4, r5}
0x00335eb6:  02bc      pop     {r1}
0x00335eb8:  0847      bx      r1
0x00335eba:  141e      subs    r4, r2, #0
0x00335ebc:  f4d0      beq     #0x335ea8
0x00335ebe:  291c      adds    r1, r5, #0
0x00335ec0:  201c      adds    r0, r4, #0
0x00335ec2:  fff7abff  bl      #0x335e1c  ; sub_00335e1c
0x00335ec6:  0e49      ldr     r1, [pc, #0x38]  ; =0x002f6200
0x00335ec8:  e368      ldr     r3, [r4, #0xc]
0x00335eca:  0a68      ldr     r2, [r1]
0x00335ecc:  9b18      adds    r3, r3, r2
0x00335ece:  1a1c      adds    r2, r3, #0
0x00335ed0:  1032      adds    r2, #0x10
0x00335ed2:  0a60      str     r2, [r1]
0x00335ed4:  0b49      ldr     r1, [pc, #0x2c]  ; =0x002f61e0
0x00335ed6:  0b68      ldr     r3, [r1]
0x00335ed8:  9a42      cmp     r2, r3
0x00335eda:  00d9      bls     #0x335ede
0x00335edc:  0a60      str     r2, [r1]
0x00335ede:  6388      ldrh    r3, [r4, #2]
0x00335ee0:  0122      movs    r2, #1
0x00335ee2:  1343      orrs    r3, r2
0x00335ee4:  6380      strh    r3, [r4, #2]
0x00335ee6:  fff741fc  bl      #0x33576c  ; sub_0033576c
0x00335eea:  a060      str     r0, [r4, #8]
0x00335eec:  fef798f9  bl      #0x334220  ; sub_00334220
0x00335ef0:  1034      adds    r4, #0x10
0x00335ef2:  201c      adds    r0, r4, #0
0x00335ef4:  dee7      b       #0x335eb4
0x00335ef6:  0000      movs    r0, r0
0x00335ef8:  c061      str     r0, [r0, #0x1c]
0x00335efa:  2f00      movs    r7, r5
0x00335efc:  f85c      ldrb    r0, [r7, r3]
0x00335efe:  3800      movs    r0, r7
0x00335f00:  0062      str     r0, [r0, #0x20]
0x00335f02:  2f00      movs    r7, r5
0x00335f04:  e061      str     r0, [r4, #0x1c]
0x00335f06:  2f00      movs    r7, r5
0x00335f08:  70b5      push    {r4, r5, r6, lr}
0x00335f0a:  041c      adds    r4, r0, #0
0x00335f0c:  103c      subs    r4, #0x10
0x00335f0e:  0d1c      adds    r5, r1, #0
0x00335f10:  fef776f9  bl      #0x334200  ; sub_00334200
0x00335f14:  e168      ldr     r1, [r4, #0xc]
0x00335f16:  a942      cmp     r1, r5
0x00335f18:  0fd8      bhi     #0x335f3a
0x00335f1a:  0b19      adds    r3, r1, r4
0x00335f1c:  1e1c      adds    r6, r3, #0
0x00335f1e:  6388      ldrh    r3, [r4, #2]
0x00335f20:  1036      adds    r6, #0x10
0x00335f22:  5a07      lsls    r2, r3, #0x1d
0x00335f24:  03d4      bmi     #0x335f2e
0x00335f26:  7288      ldrh    r2, [r6, #2]
0x00335f28:  0123      movs    r3, #1
0x00335f2a:  1a42      tst     r2, r3
0x00335f2c:  10d0      beq     #0x335f50
0x00335f2e:  fef777f9  bl      #0x334220  ; sub_00334220
0x00335f32:  e068      ldr     r0, [r4, #0xc]
0x00335f34:  70bc      pop     {r4, r5, r6}
0x00335f36:  02bc      pop     {r1}
0x00335f38:  0847      bx      r1
0x00335f3a:  104b      ldr     r3, [pc, #0x40]  ; =0x002f6200
0x00335f3c:  6a1a      subs    r2, r5, r1
0x00335f3e:  1968      ldr     r1, [r3]
0x00335f40:  201c      adds    r0, r4, #0
0x00335f42:  5218      adds    r2, r2, r1
0x00335f44:  1032      adds    r2, #0x10
0x00335f46:  1a60      str     r2, [r3]
0x00335f48:  291c      adds    r1, r5, #0
0x00335f4a:  fff767ff  bl      #0x335e1c  ; sub_00335e1c
0x00335f4e:  eee7      b       #0x335f2e
0x00335f50:  691a      subs    r1, r5, r1
0x00335f52:  1039      subs    r1, #0x10
0x00335f54:  301c      adds    r0, r6, #0
0x00335f56:  fff761ff  bl      #0x335e1c  ; sub_00335e1c
0x00335f5a:  0849      ldr     r1, [pc, #0x20]  ; =0x002f6200
0x00335f5c:  f368      ldr     r3, [r6, #0xc]
0x00335f5e:  0a68      ldr     r2, [r1]
0x00335f60:  9b18      adds    r3, r3, r2
0x00335f62:  1a1c      adds    r2, r3, #0
0x00335f64:  1032      adds    r2, #0x10
0x00335f66:  0a60      str     r2, [r1]
0x00335f68:  0549      ldr     r1, [pc, #0x14]  ; =0x002f61e0
0x00335f6a:  0b68      ldr     r3, [r1]
0x00335f6c:  9a42      cmp     r2, r3
0x00335f6e:  00d9      bls     #0x335f72
0x00335f70:  0a60      str     r2, [r1]
0x00335f72:  201c      adds    r0, r4, #0
0x00335f74:  311c      adds    r1, r6, #0
0x00335f76:  fff73bff  bl      #0x335df0  ; sub_00335df0
0x00335f7a:  d8e7      b       #0x335f2e
0x00335f7c:  0062      str     r0, [r0, #0x20]
0x00335f7e:  2f00      movs    r7, r5
0x00335f80:  e061      str     r0, [r4, #0x1c]
0x00335f82:  2f00      movs    r7, r5
0x00335f84:  30b5      push    {r4, r5, lr}
0x00335f86:  041c      adds    r4, r0, #0
0x00335f88:  103c      subs    r4, #0x10
0x00335f8a:  fef739f9  bl      #0x334200  ; sub_00334200
0x00335f8e:  2288      ldrh    r2, [r4]
0x00335f90:  1c4b      ldr     r3, [pc, #0x70]  ; =0x00004d45
0x00335f92:  9a42      cmp     r2, r3
0x00335f94:  05d0      beq     #0x335fa2
0x00335f96:  fef743f9  bl      #0x334220  ; sub_00334220
0x00335f9a:  0120      movs    r0, #1
0x00335f9c:  30bc      pop     {r4, r5}
0x00335f9e:  02bc      pop     {r1}
0x00335fa0:  0847      bx      r1
0x00335fa2:  194d      ldr     r5, [pc, #0x64]  ; =0x002f6200
0x00335fa4:  0023      movs    r3, #0
0x00335fa6:  6288      ldrh    r2, [r4, #2]
0x00335fa8:  e168      ldr     r1, [r4, #0xc]
0x00335faa:  a360      str     r3, [r4, #8]
0x00335fac:  2b68      ldr     r3, [r5]
0x00335fae:  0120      movs    r0, #1
0x00335fb0:  8243      bics    r2, r0
0x00335fb2:  5b1a      subs    r3, r3, r1
0x00335fb4:  6280      strh    r2, [r4, #2]
0x00335fb6:  103b      subs    r3, #0x10
0x00335fb8:  9208      lsrs    r2, r2, #2
0x00335fba:  2b60      str     r3, [r5]
0x00335fbc:  0242      tst     r2, r0
0x00335fbe:  05d1      bne     #0x335fcc
0x00335fc0:  0b19      adds    r3, r1, r4
0x00335fc2:  191c      adds    r1, r3, #0
0x00335fc4:  1031      adds    r1, #0x10
0x00335fc6:  4b88      ldrh    r3, [r1, #2]
0x00335fc8:  0342      tst     r3, r0
0x00335fca:  14d0      beq     #0x335ff6
0x00335fcc:  6388      ldrh    r3, [r4, #2]
0x00335fce:  9a07      lsls    r2, r3, #0x1e
0x00335fd0:  0dd4      bmi     #0x335fee
0x00335fd2:  6068      ldr     r0, [r4, #4]
0x00335fd4:  0028      cmp     r0, #0
0x00335fd6:  0ad0      beq     #0x335fee
0x00335fd8:  4288      ldrh    r2, [r0, #2]
0x00335fda:  0123      movs    r3, #1
0x00335fdc:  1a42      tst     r2, r3
0x00335fde:  06d1      bne     #0x335fee
0x00335fe0:  211c      adds    r1, r4, #0
0x00335fe2:  fff705ff  bl      #0x335df0  ; sub_00335df0
0x00335fe6:  084a      ldr     r2, [pc, #0x20]  ; =0x002f6200
0x00335fe8:  1368      ldr     r3, [r2]
0x00335fea:  103b      subs    r3, #0x10
0x00335fec:  1360      str     r3, [r2]
0x00335fee:  fef717f9  bl      #0x334220  ; sub_00334220
0x00335ff2:  0020      movs    r0, #0
0x00335ff4:  d2e7      b       #0x335f9c
0x00335ff6:  201c      adds    r0, r4, #0
0x00335ff8:  fff7fafe  bl      #0x335df0  ; sub_00335df0
0x00335ffc:  2b68      ldr     r3, [r5]
0x00335ffe:  103b      subs    r3, #0x10
0x00336000:  2b60      str     r3, [r5]
0x00336002:  e3e7      b       #0x335fcc
0x00336004:  454d      ldr     r5, [pc, #0x114]  ; =0xe0081c0c
0x00336006:  0000      movs    r0, r0
0x00336008:  0062      str     r0, [r0, #0x20]
0x0033600a:  2f00      movs    r7, r5
0x0033600c:  10b5      push    {r4, lr}
0x0033600e:  134b      ldr     r3, [pc, #0x4c]  ; =0x0000524f
0x00336010:  041c      adds    r4, r0, #0
0x00336012:  0380      strh    r3, [r0]
0x00336014:  0023      movs    r3, #0
0x00336016:  4380      strh    r3, [r0, #2]
0x00336018:  0b1c      adds    r3, r1, #0
0x0033601a:  103b      subs    r3, #0x10
0x0033601c:  e360      str     r3, [r4, #0xc]
0x0033601e:  104b      ldr     r3, [pc, #0x40]  ; =0x00004d45
0x00336020:  221c      adds    r2, r4, #0
0x00336022:  1032      adds    r2, #0x10
0x00336024:  2382      strh    r3, [r4, #0x10]
0x00336026:  0623      movs    r3, #6
0x00336028:  0020      movs    r0, #0
0x0033602a:  5380      strh    r3, [r2, #2]
0x0033602c:  0d4b      ldr     r3, [pc, #0x34]  ; =0x002f61c0
0x0033602e:  6060      str     r0, [r4, #4]
0x00336030:  a060      str     r0, [r4, #8]
0x00336032:  2039      subs    r1, #0x20
0x00336034:  5060      str     r0, [r2, #4]
0x00336036:  9060      str     r0, [r2, #8]
0x00336038:  d160      str     r1, [r2, #0xc]
0x0033603a:  1a68      ldr     r2, [r3]
0x0033603c:  002a      cmp     r2, #0
0x0033603e:  01d1      bne     #0x336044
0x00336040:  09e0      b       #0x336056
0x00336042:  1a1c      adds    r2, r3, #0
0x00336044:  9368      ldr     r3, [r2, #8]
0x00336046:  002b      cmp     r3, #0
0x00336048:  fbd1      bne     #0x336042
0x0033604a:  9460      str     r4, [r2, #8]
0x0033604c:  6260      str     r2, [r4, #4]
0x0033604e:  0020      movs    r0, #0

===== sub_00336090 @ 0x00336090 =====
0x00336090:  10b5      push    {r4, lr}
0x00336092:  041c      adds    r4, r0, #0
0x00336094:  fef7b4f8  bl      #0x334200  ; sub_00334200
0x00336098:  2388      ldrh    r3, [r4]
0x0033609a:  002b      cmp     r3, #0
0x0033609c:  07d1      bne     #0x3360ae
0x0033609e:  0123      movs    r3, #1
0x003360a0:  2380      strh    r3, [r4]
0x003360a2:  fef7bdf8  bl      #0x334220  ; sub_00334220
0x003360a6:  0120      movs    r0, #1
0x003360a8:  10bc      pop     {r4}
0x003360aa:  02bc      pop     {r1}
0x003360ac:  0847      bx      r1
0x003360ae:  fef7b7f8  bl      #0x334220  ; sub_00334220
0x003360b2:  0020      movs    r0, #0
0x003360b4:  f8e7      b       #0x3360a8
0x003360b6:  0000      movs    r0, r0
0x003360b8:  f0b5      push    {r4, r5, r6, r7, lr}
0x003360ba:  1204      lsls    r2, r2, #0x10
0x003360bc:  170c      lsrs    r7, r2, #0x10
0x003360be:  031c      adds    r3, r0, #0
0x003360c0:  0122      movs    r2, #1
0x003360c2:  0c1c      adds    r4, r1, #0
0x003360c4:  4b40      eors    r3, r1
0x003360c6:  111c      adds    r1, r2, #0
0x003360c8:  9943      bics    r1, r3
0x003360ca:  38d0      beq     #0x33613e
0x003360cc:  0326      movs    r6, #3
0x003360ce:  011c      adds    r1, r0, #0
0x003360d0:  251c      adds    r5, r4, #0
0x003360d2:  3140      ands    r1, r6
0x003360d4:  3540      ands    r5, r6
0x003360d6:  a942      cmp     r1, r5
0x003360d8:  48d1      bne     #0x33616c
0x003360da:  0423      movs    r3, #4
0x003360dc:  591a      subs    r1, r3, r1
0x003360de:  3140      ands    r1, r6
0x003360e0:  7b1a      subs    r3, r7, r1
0x003360e2:  5ad4      bmi     #0x33619a
0x003360e4:  9d10      asrs    r5, r3, #2
0x003360e6:  ab00      lsls    r3, r5, #2
0x003360e8:  5b18      adds    r3, r3, r1
0x003360ea:  ff1a      subs    r7, r7, r3
0x003360ec:  09e0      b       #0x336102
0x003360ee:  0378      ldrb    r3, [r0]
0x003360f0:  2678      ldrb    r6, [r4]
0x003360f2:  9c46      mov     ip, r3
0x003360f4:  1a1c      adds    r2, r3, #0
0x003360f6:  331c      adds    r3, r6, #0
0x003360f8:  9a42      cmp     r2, r3
0x003360fa:  30d1      bne     #0x33615e
0x003360fc:  0130      adds    r0, #1
0x003360fe:  0134      adds    r4, #1
0x00336100:  0139      subs    r1, #1
0x00336102:  0029      cmp     r1, #0
0x00336104:  f3dc      bgt     #0x3360ee
0x00336106:  211c      adds    r1, r4, #0
0x00336108:  06e0      b       #0x336118
0x0033610a:  0268      ldr     r2, [r0]
0x0033610c:  0b68      ldr     r3, [r1]
0x0033610e:  9a42      cmp     r2, r3
0x00336110:  5cd1      bne     #0x3361cc
0x00336112:  0430      adds    r0, #4
0x00336114:  0431      adds    r1, #4
0x00336116:  013d      subs    r5, #1
0x00336118:  002d      cmp     r5, #0
0x0033611a:  f6dc      bgt     #0x33610a
0x0033611c:  0c1c      adds    r4, r1, #0
0x0033611e:  08e0      b       #0x336132
0x00336120:  2678      ldrb    r6, [r4]
0x00336122:  0178      ldrb    r1, [r0]
0x00336124:  331c      adds    r3, r6, #0
0x00336126:  8c46      mov     ip, r1
0x00336128:  9942      cmp     r1, r3
0x0033612a:  18d1      bne     #0x33615e
0x0033612c:  0130      adds    r0, #1
0x0033612e:  0134      adds    r4, #1
0x00336130:  013f      subs    r7, #1
0x00336132:  002f      cmp     r7, #0
0x00336134:  f4dc      bgt     #0x336120
0x00336136:  0020      movs    r0, #0
0x00336138:  f0bc      pop     {r4, r5, r6, r7}
0x0033613a:  02bc      pop     {r1}
0x0033613c:  0847      bx      r1
0x0033613e:  002f      cmp     r7, #0
0x00336140:  08dd      ble     #0x336154
0x00336142:  0278      ldrb    r2, [r0]
0x00336144:  2378      ldrb    r3, [r4]
0x00336146:  9a42      cmp     r2, r3
0x00336148:  04d1      bne     #0x336154
0x0033614a:  0130      adds    r0, #1
0x0033614c:  0134      adds    r4, #1
0x0033614e:  013f      subs    r7, #1
0x00336150:  002f      cmp     r7, #0
0x00336152:  f6dc      bgt     #0x336142
0x00336154:  002f      cmp     r7, #0
0x00336156:  eed0      beq     #0x336136
0x00336158:  0078      ldrb    r0, [r0]
0x0033615a:  2678      ldrb    r6, [r4]
0x0033615c:  8446      mov     ip, r0
0x0033615e:  6346      mov     r3, ip
0x00336160:  1a06      lsls    r2, r3, #0x18
0x00336162:  3306      lsls    r3, r6, #0x18
0x00336164:  9342      cmp     r3, r2
0x00336166:  34d2      bhs     #0x3361d2
0x00336168:  0120      movs    r0, #1
0x0033616a:  e5e7      b       #0x336138
0x0033616c:  011c      adds    r1, r0, #0
0x0033616e:  251c      adds    r5, r4, #0
0x00336170:  1140      ands    r1, r2
0x00336172:  1540      ands    r5, r2
0x00336174:  a942      cmp     r1, r5
0x00336176:  edd1      bne     #0x336154
0x00336178:  7b1a      subs    r3, r7, r1
0x0033617a:  da0f      lsrs    r2, r3, #0x1f
0x0033617c:  9b18      adds    r3, r3, r2
0x0033617e:  5d10      asrs    r5, r3, #1
0x00336180:  6b00      lsls    r3, r5, #1
0x00336182:  5b18      adds    r3, r3, r1
0x00336184:  ff1a      subs    r7, r7, r3
0x00336186:  0029      cmp     r1, #0
0x00336188:  0bdd      ble     #0x3361a2
0x0033618a:  2178      ldrb    r1, [r4]
0x0033618c:  0678      ldrb    r6, [r0]
0x0033618e:  0b1c      adds    r3, r1, #0
0x00336190:  9e42      cmp     r6, r3
0x00336192:  04d0      beq     #0x33619e
0x00336194:  b446      mov     ip, r6
0x00336196:  0e1c      adds    r6, r1, #0
0x00336198:  e1e7      b       #0x33615e
0x0033619a:  0333      adds    r3, #3
0x0033619c:  a2e7      b       #0x3360e4
0x0033619e:  0130      adds    r0, #1
0x003361a0:  0134      adds    r4, #1
0x003361a2:  211c      adds    r1, r4, #0
0x003361a4:  06e0      b       #0x3361b4
0x003361a6:  0288      ldrh    r2, [r0]
0x003361a8:  0b88      ldrh    r3, [r1]
0x003361aa:  9a42      cmp     r2, r3
0x003361ac:  14d1      bne     #0x3361d8
0x003361ae:  0230      adds    r0, #2
0x003361b0:  0231      adds    r1, #2
0x003361b2:  013d      subs    r5, #1
0x003361b4:  002d      cmp     r5, #0
0x003361b6:  f6dc      bgt     #0x3361a6
0x003361b8:  002f      cmp     r7, #0
0x003361ba:  bcdd      ble     #0x336136
0x003361bc:  0978      ldrb    r1, [r1]
0x003361be:  0578      ldrb    r5, [r0]
0x003361c0:  0b1c      adds    r3, r1, #0
0x003361c2:  9d42      cmp     r5, r3
0x003361c4:  b7d0      beq     #0x336136
0x003361c6:  ac46      mov     ip, r5
0x003361c8:  0e1c      adds    r6, r1, #0
0x003361ca:  c8e7      b       #0x33615e
0x003361cc:  0c1c      adds    r4, r1, #0
0x003361ce:  0427      movs    r7, #4
0x003361d0:  b7e7      b       #0x336142
0x003361d2:  0120      movs    r0, #1
0x003361d4:  4042      rsbs    r0, r0, #0
0x003361d6:  afe7      b       #0x336138
0x003361d8:  0c1c      adds    r4, r1, #0
0x003361da:  0227      movs    r7, #2
0x003361dc:  b1e7      b       #0x336142
0x003361de:  0000      movs    r0, r0
0x003361e0:  10b5      push    {r4, lr}
0x003361e2:  1204      lsls    r2, r2, #0x10
0x003361e4:  0906      lsls    r1, r1, #0x18
0x003361e6:  120c      lsrs    r2, r2, #0x10
0x003361e8:  0c0e      lsrs    r4, r1, #0x18
0x003361ea:  032a      cmp     r2, #3
0x003361ec:  2ed9      bls     #0x33624c
0x003361ee:  0323      movs    r3, #3
0x003361f0:  011c      adds    r1, r0, #0
0x003361f2:  1940      ands    r1, r3
0x003361f4:  08d0      beq     #0x336208
0x003361f6:  0423      movs    r3, #4
0x003361f8:  5b1a      subs    r3, r3, r1
0x003361fa:  d21a      subs    r2, r2, r3
0x003361fc:  02e0      b       #0x336204
0x003361fe:  0470      strb    r4, [r0]
0x00336200:  013b      subs    r3, #1
0x00336202:  0130      adds    r0, #1
0x00336204:  002b      cmp     r3, #0
0x00336206:  fad1      bne     #0x3361fe
0x00336208:  2102      lsls    r1, r4, #8
0x0033620a:  2143      orrs    r1, r4
0x0033620c:  0b04      lsls    r3, r1, #0x10
0x0033620e:  1943      orrs    r1, r3
0x00336210:  05e0      b       #0x33621e
0x00336212:  0160      str     r1, [r0]
0x00336214:  4160      str     r1, [r0, #4]
0x00336216:  8160      str     r1, [r0, #8]
0x00336218:  c160      str     r1, [r0, #0xc]
0x0033621a:  103a      subs    r2, #0x10
0x0033621c:  1030      adds    r0, #0x10
0x0033621e:  0f2a      cmp     r2, #0xf
0x00336220:  f7d8      bhi     #0x336212
0x00336222:  032a      cmp     r2, #3
0x00336224:  0bd9      bls     #0x33623e
0x00336226:  02c0      stm     r0!, {r1}
0x00336228:  043a      subs    r2, #4
0x0033622a:  032a      cmp     r2, #3
0x0033622c:  fbd8      bhi     #0x336226
0x0033622e:  032a      cmp     r2, #3
0x00336230:  0cd9      bls     #0x33624c
0x00336232:  0470      strb    r4, [r0]
0x00336234:  4470      strb    r4, [r0, #1]
0x00336236:  8470      strb    r4, [r0, #2]
0x00336238:  c470      strb    r4, [r0, #3]
0x0033623a:  043a      subs    r2, #4
0x0033623c:  0430      adds    r0, #4
0x0033623e:  032a      cmp     r2, #3
0x00336240:  f7d8      bhi     #0x336232
0x00336242:  002a      cmp     r2, #0
0x00336244:  04d0      beq     #0x336250
0x00336246:  0470      strb    r4, [r0]
0x00336248:  013a      subs    r2, #1
0x0033624a:  0130      adds    r0, #1
0x0033624c:  002a      cmp     r2, #0
0x0033624e:  fad1      bne     #0x336246
0x00336250:  10bc      pop     {r4}
0x00336252:  01bc      pop     {r0}
0x00336254:  0047      bx      r0
0x00336256:  0000      movs    r0, r0
0x00336258:  00b5      push    {lr}
0x0033625a:  0904      lsls    r1, r1, #0x10
0x0033625c:  1204      lsls    r2, r2, #0x10
0x0033625e:  090c      lsrs    r1, r1, #0x10
0x00336260:  120c      lsrs    r2, r2, #0x10
0x00336262:  08e0      b       #0x336276
0x00336264:  0180      strh    r1, [r0]
0x00336266:  0230      adds    r0, #2
0x00336268:  0180      strh    r1, [r0]
0x0033626a:  0230      adds    r0, #2
0x0033626c:  0180      strh    r1, [r0]
0x0033626e:  0230      adds    r0, #2

===== sub_003360b8 @ 0x003360b8 =====
0x003360b8:  f0b5      push    {r4, r5, r6, r7, lr}
0x003360ba:  1204      lsls    r2, r2, #0x10
0x003360bc:  170c      lsrs    r7, r2, #0x10
0x003360be:  031c      adds    r3, r0, #0
0x003360c0:  0122      movs    r2, #1
0x003360c2:  0c1c      adds    r4, r1, #0
0x003360c4:  4b40      eors    r3, r1
0x003360c6:  111c      adds    r1, r2, #0
0x003360c8:  9943      bics    r1, r3
0x003360ca:  38d0      beq     #0x33613e
0x003360cc:  0326      movs    r6, #3
0x003360ce:  011c      adds    r1, r0, #0
0x003360d0:  251c      adds    r5, r4, #0
0x003360d2:  3140      ands    r1, r6
0x003360d4:  3540      ands    r5, r6
0x003360d6:  a942      cmp     r1, r5
0x003360d8:  48d1      bne     #0x33616c
0x003360da:  0423      movs    r3, #4
0x003360dc:  591a      subs    r1, r3, r1
0x003360de:  3140      ands    r1, r6
0x003360e0:  7b1a      subs    r3, r7, r1
0x003360e2:  5ad4      bmi     #0x33619a
0x003360e4:  9d10      asrs    r5, r3, #2
0x003360e6:  ab00      lsls    r3, r5, #2
0x003360e8:  5b18      adds    r3, r3, r1
0x003360ea:  ff1a      subs    r7, r7, r3
0x003360ec:  09e0      b       #0x336102
0x003360ee:  0378      ldrb    r3, [r0]
0x003360f0:  2678      ldrb    r6, [r4]
0x003360f2:  9c46      mov     ip, r3
0x003360f4:  1a1c      adds    r2, r3, #0
0x003360f6:  331c      adds    r3, r6, #0
0x003360f8:  9a42      cmp     r2, r3
0x003360fa:  30d1      bne     #0x33615e
0x003360fc:  0130      adds    r0, #1
0x003360fe:  0134      adds    r4, #1
0x00336100:  0139      subs    r1, #1
0x00336102:  0029      cmp     r1, #0
0x00336104:  f3dc      bgt     #0x3360ee
0x00336106:  211c      adds    r1, r4, #0
0x00336108:  06e0      b       #0x336118
0x0033610a:  0268      ldr     r2, [r0]
0x0033610c:  0b68      ldr     r3, [r1]
0x0033610e:  9a42      cmp     r2, r3
0x00336110:  5cd1      bne     #0x3361cc
0x00336112:  0430      adds    r0, #4
0x00336114:  0431      adds    r1, #4
0x00336116:  013d      subs    r5, #1
0x00336118:  002d      cmp     r5, #0
0x0033611a:  f6dc      bgt     #0x33610a
0x0033611c:  0c1c      adds    r4, r1, #0
0x0033611e:  08e0      b       #0x336132
0x00336120:  2678      ldrb    r6, [r4]
0x00336122:  0178      ldrb    r1, [r0]
0x00336124:  331c      adds    r3, r6, #0
0x00336126:  8c46      mov     ip, r1
0x00336128:  9942      cmp     r1, r3
0x0033612a:  18d1      bne     #0x33615e
0x0033612c:  0130      adds    r0, #1
0x0033612e:  0134      adds    r4, #1
0x00336130:  013f      subs    r7, #1
0x00336132:  002f      cmp     r7, #0
0x00336134:  f4dc      bgt     #0x336120
0x00336136:  0020      movs    r0, #0
0x00336138:  f0bc      pop     {r4, r5, r6, r7}
0x0033613a:  02bc      pop     {r1}
0x0033613c:  0847      bx      r1
0x0033613e:  002f      cmp     r7, #0
0x00336140:  08dd      ble     #0x336154
0x00336142:  0278      ldrb    r2, [r0]
0x00336144:  2378      ldrb    r3, [r4]
0x00336146:  9a42      cmp     r2, r3
0x00336148:  04d1      bne     #0x336154
0x0033614a:  0130      adds    r0, #1
0x0033614c:  0134      adds    r4, #1
0x0033614e:  013f      subs    r7, #1
0x00336150:  002f      cmp     r7, #0
0x00336152:  f6dc      bgt     #0x336142
0x00336154:  002f      cmp     r7, #0
0x00336156:  eed0      beq     #0x336136
0x00336158:  0078      ldrb    r0, [r0]
0x0033615a:  2678      ldrb    r6, [r4]
0x0033615c:  8446      mov     ip, r0
0x0033615e:  6346      mov     r3, ip
0x00336160:  1a06      lsls    r2, r3, #0x18
0x00336162:  3306      lsls    r3, r6, #0x18
0x00336164:  9342      cmp     r3, r2
0x00336166:  34d2      bhs     #0x3361d2
0x00336168:  0120      movs    r0, #1
0x0033616a:  e5e7      b       #0x336138
0x0033616c:  011c      adds    r1, r0, #0
0x0033616e:  251c      adds    r5, r4, #0
0x00336170:  1140      ands    r1, r2
0x00336172:  1540      ands    r5, r2
0x00336174:  a942      cmp     r1, r5
0x00336176:  edd1      bne     #0x336154
0x00336178:  7b1a      subs    r3, r7, r1
0x0033617a:  da0f      lsrs    r2, r3, #0x1f
0x0033617c:  9b18      adds    r3, r3, r2
0x0033617e:  5d10      asrs    r5, r3, #1
0x00336180:  6b00      lsls    r3, r5, #1
0x00336182:  5b18      adds    r3, r3, r1
0x00336184:  ff1a      subs    r7, r7, r3
0x00336186:  0029      cmp     r1, #0
0x00336188:  0bdd      ble     #0x3361a2
0x0033618a:  2178      ldrb    r1, [r4]
0x0033618c:  0678      ldrb    r6, [r0]
0x0033618e:  0b1c      adds    r3, r1, #0
0x00336190:  9e42      cmp     r6, r3
0x00336192:  04d0      beq     #0x33619e
0x00336194:  b446      mov     ip, r6
0x00336196:  0e1c      adds    r6, r1, #0
0x00336198:  e1e7      b       #0x33615e
0x0033619a:  0333      adds    r3, #3
0x0033619c:  a2e7      b       #0x3360e4
0x0033619e:  0130      adds    r0, #1
0x003361a0:  0134      adds    r4, #1
0x003361a2:  211c      adds    r1, r4, #0
0x003361a4:  06e0      b       #0x3361b4
0x003361a6:  0288      ldrh    r2, [r0]
0x003361a8:  0b88      ldrh    r3, [r1]
0x003361aa:  9a42      cmp     r2, r3
0x003361ac:  14d1      bne     #0x3361d8
0x003361ae:  0230      adds    r0, #2
0x003361b0:  0231      adds    r1, #2
0x003361b2:  013d      subs    r5, #1
0x003361b4:  002d      cmp     r5, #0
0x003361b6:  f6dc      bgt     #0x3361a6
0x003361b8:  002f      cmp     r7, #0
0x003361ba:  bcdd      ble     #0x336136
0x003361bc:  0978      ldrb    r1, [r1]
0x003361be:  0578      ldrb    r5, [r0]
0x003361c0:  0b1c      adds    r3, r1, #0
0x003361c2:  9d42      cmp     r5, r3
0x003361c4:  b7d0      beq     #0x336136
0x003361c6:  ac46      mov     ip, r5
0x003361c8:  0e1c      adds    r6, r1, #0
0x003361ca:  c8e7      b       #0x33615e
0x003361cc:  0c1c      adds    r4, r1, #0
0x003361ce:  0427      movs    r7, #4
0x003361d0:  b7e7      b       #0x336142
0x003361d2:  0120      movs    r0, #1
0x003361d4:  4042      rsbs    r0, r0, #0
0x003361d6:  afe7      b       #0x336138
0x003361d8:  0c1c      adds    r4, r1, #0
0x003361da:  0227      movs    r7, #2
0x003361dc:  b1e7      b       #0x336142
0x003361de:  0000      movs    r0, r0
0x003361e0:  10b5      push    {r4, lr}
0x003361e2:  1204      lsls    r2, r2, #0x10
0x003361e4:  0906      lsls    r1, r1, #0x18
0x003361e6:  120c      lsrs    r2, r2, #0x10
0x003361e8:  0c0e      lsrs    r4, r1, #0x18
0x003361ea:  032a      cmp     r2, #3
0x003361ec:  2ed9      bls     #0x33624c
0x003361ee:  0323      movs    r3, #3
0x003361f0:  011c      adds    r1, r0, #0
0x003361f2:  1940      ands    r1, r3
0x003361f4:  08d0      beq     #0x336208
0x003361f6:  0423      movs    r3, #4
0x003361f8:  5b1a      subs    r3, r3, r1
0x003361fa:  d21a      subs    r2, r2, r3
0x003361fc:  02e0      b       #0x336204
0x003361fe:  0470      strb    r4, [r0]
0x00336200:  013b      subs    r3, #1
0x00336202:  0130      adds    r0, #1
0x00336204:  002b      cmp     r3, #0
0x00336206:  fad1      bne     #0x3361fe
0x00336208:  2102      lsls    r1, r4, #8
0x0033620a:  2143      orrs    r1, r4
0x0033620c:  0b04      lsls    r3, r1, #0x10
0x0033620e:  1943      orrs    r1, r3
0x00336210:  05e0      b       #0x33621e
0x00336212:  0160      str     r1, [r0]
0x00336214:  4160      str     r1, [r0, #4]
0x00336216:  8160      str     r1, [r0, #8]
0x00336218:  c160      str     r1, [r0, #0xc]
0x0033621a:  103a      subs    r2, #0x10
0x0033621c:  1030      adds    r0, #0x10
0x0033621e:  0f2a      cmp     r2, #0xf
0x00336220:  f7d8      bhi     #0x336212
0x00336222:  032a      cmp     r2, #3
0x00336224:  0bd9      bls     #0x33623e
0x00336226:  02c0      stm     r0!, {r1}
0x00336228:  043a      subs    r2, #4
0x0033622a:  032a      cmp     r2, #3
0x0033622c:  fbd8      bhi     #0x336226
0x0033622e:  032a      cmp     r2, #3
0x00336230:  0cd9      bls     #0x33624c
0x00336232:  0470      strb    r4, [r0]
0x00336234:  4470      strb    r4, [r0, #1]
0x00336236:  8470      strb    r4, [r0, #2]
0x00336238:  c470      strb    r4, [r0, #3]
0x0033623a:  043a      subs    r2, #4
0x0033623c:  0430      adds    r0, #4
0x0033623e:  032a      cmp     r2, #3
0x00336240:  f7d8      bhi     #0x336232
0x00336242:  002a      cmp     r2, #0
0x00336244:  04d0      beq     #0x336250
0x00336246:  0470      strb    r4, [r0]
0x00336248:  013a      subs    r2, #1
0x0033624a:  0130      adds    r0, #1
0x0033624c:  002a      cmp     r2, #0
0x0033624e:  fad1      bne     #0x336246
0x00336250:  10bc      pop     {r4}
0x00336252:  01bc      pop     {r0}
0x00336254:  0047      bx      r0
0x00336256:  0000      movs    r0, r0
0x00336258:  00b5      push    {lr}
0x0033625a:  0904      lsls    r1, r1, #0x10
0x0033625c:  1204      lsls    r2, r2, #0x10
0x0033625e:  090c      lsrs    r1, r1, #0x10
0x00336260:  120c      lsrs    r2, r2, #0x10
0x00336262:  08e0      b       #0x336276
0x00336264:  0180      strh    r1, [r0]
0x00336266:  0230      adds    r0, #2
0x00336268:  0180      strh    r1, [r0]
0x0033626a:  0230      adds    r0, #2
0x0033626c:  0180      strh    r1, [r0]
0x0033626e:  0230      adds    r0, #2
0x00336270:  0180      strh    r1, [r0]
0x00336272:  043a      subs    r2, #4
0x00336274:  0230      adds    r0, #2
0x00336276:  032a      cmp     r2, #3
0x00336278:  f4dc      bgt     #0x336264
0x0033627a:  002a      cmp     r2, #0
0x0033627c:  04dd      ble     #0x336288
0x0033627e:  0180      strh    r1, [r0]
0x00336280:  013a      subs    r2, #1
0x00336282:  0230      adds    r0, #2
0x00336284:  002a      cmp     r2, #0
0x00336286:  fadc      bgt     #0x33627e
0x00336288:  01bc      pop     {r0}
0x0033628a:  0047      bx      r0
0x0033628c:  ff22      movs    r2, #0xff
0x0033628e:  031c      adds    r3, r0, #0
0x00336290:  1340      ands    r3, r2
0x00336292:  000a      lsrs    r0, r0, #8
0x00336294:  1b02      lsls    r3, r3, #8
0x00336296:  1040      ands    r0, r2

===== sub_003361e0 @ 0x003361e0 =====
0x003361e0:  10b5      push    {r4, lr}
0x003361e2:  1204      lsls    r2, r2, #0x10
0x003361e4:  0906      lsls    r1, r1, #0x18
0x003361e6:  120c      lsrs    r2, r2, #0x10
0x003361e8:  0c0e      lsrs    r4, r1, #0x18
0x003361ea:  032a      cmp     r2, #3
0x003361ec:  2ed9      bls     #0x33624c
0x003361ee:  0323      movs    r3, #3
0x003361f0:  011c      adds    r1, r0, #0
0x003361f2:  1940      ands    r1, r3
0x003361f4:  08d0      beq     #0x336208
0x003361f6:  0423      movs    r3, #4
0x003361f8:  5b1a      subs    r3, r3, r1
0x003361fa:  d21a      subs    r2, r2, r3
0x003361fc:  02e0      b       #0x336204
0x003361fe:  0470      strb    r4, [r0]
0x00336200:  013b      subs    r3, #1
0x00336202:  0130      adds    r0, #1
0x00336204:  002b      cmp     r3, #0
0x00336206:  fad1      bne     #0x3361fe
0x00336208:  2102      lsls    r1, r4, #8
0x0033620a:  2143      orrs    r1, r4
0x0033620c:  0b04      lsls    r3, r1, #0x10
0x0033620e:  1943      orrs    r1, r3
0x00336210:  05e0      b       #0x33621e
0x00336212:  0160      str     r1, [r0]
0x00336214:  4160      str     r1, [r0, #4]
0x00336216:  8160      str     r1, [r0, #8]
0x00336218:  c160      str     r1, [r0, #0xc]
0x0033621a:  103a      subs    r2, #0x10
0x0033621c:  1030      adds    r0, #0x10
0x0033621e:  0f2a      cmp     r2, #0xf
0x00336220:  f7d8      bhi     #0x336212
0x00336222:  032a      cmp     r2, #3
0x00336224:  0bd9      bls     #0x33623e
0x00336226:  02c0      stm     r0!, {r1}
0x00336228:  043a      subs    r2, #4
0x0033622a:  032a      cmp     r2, #3
0x0033622c:  fbd8      bhi     #0x336226
0x0033622e:  032a      cmp     r2, #3
0x00336230:  0cd9      bls     #0x33624c
0x00336232:  0470      strb    r4, [r0]
0x00336234:  4470      strb    r4, [r0, #1]
0x00336236:  8470      strb    r4, [r0, #2]
0x00336238:  c470      strb    r4, [r0, #3]
0x0033623a:  043a      subs    r2, #4
0x0033623c:  0430      adds    r0, #4
0x0033623e:  032a      cmp     r2, #3
0x00336240:  f7d8      bhi     #0x336232
0x00336242:  002a      cmp     r2, #0
0x00336244:  04d0      beq     #0x336250
0x00336246:  0470      strb    r4, [r0]
0x00336248:  013a      subs    r2, #1
0x0033624a:  0130      adds    r0, #1
0x0033624c:  002a      cmp     r2, #0
0x0033624e:  fad1      bne     #0x336246
0x00336250:  10bc      pop     {r4}
0x00336252:  01bc      pop     {r0}
0x00336254:  0047      bx      r0
0x00336256:  0000      movs    r0, r0
0x00336258:  00b5      push    {lr}
0x0033625a:  0904      lsls    r1, r1, #0x10
0x0033625c:  1204      lsls    r2, r2, #0x10
0x0033625e:  090c      lsrs    r1, r1, #0x10
0x00336260:  120c      lsrs    r2, r2, #0x10
0x00336262:  08e0      b       #0x336276
0x00336264:  0180      strh    r1, [r0]
0x00336266:  0230      adds    r0, #2
0x00336268:  0180      strh    r1, [r0]
0x0033626a:  0230      adds    r0, #2
0x0033626c:  0180      strh    r1, [r0]
0x0033626e:  0230      adds    r0, #2
0x00336270:  0180      strh    r1, [r0]
0x00336272:  043a      subs    r2, #4
0x00336274:  0230      adds    r0, #2
0x00336276:  032a      cmp     r2, #3
0x00336278:  f4dc      bgt     #0x336264
0x0033627a:  002a      cmp     r2, #0
0x0033627c:  04dd      ble     #0x336288
0x0033627e:  0180      strh    r1, [r0]
0x00336280:  013a      subs    r2, #1
0x00336282:  0230      adds    r0, #2
0x00336284:  002a      cmp     r2, #0
0x00336286:  fadc      bgt     #0x33627e
0x00336288:  01bc      pop     {r0}
0x0033628a:  0047      bx      r0
0x0033628c:  ff22      movs    r2, #0xff
0x0033628e:  031c      adds    r3, r0, #0
0x00336290:  1340      ands    r3, r2
0x00336292:  000a      lsrs    r0, r0, #8
0x00336294:  1b02      lsls    r3, r3, #8
0x00336296:  1040      ands    r0, r2
0x00336298:  1843      orrs    r0, r3
0x0033629a:  7047      bx      lr

===== sub_0033628c @ 0x0033628c =====
0x0033628c:  ff22      movs    r2, #0xff
0x0033628e:  031c      adds    r3, r0, #0
0x00336290:  1340      ands    r3, r2
0x00336292:  000a      lsrs    r0, r0, #8
0x00336294:  1b02      lsls    r3, r3, #8
0x00336296:  1040      ands    r0, r2
0x00336298:  1843      orrs    r0, r3
0x0033629a:  7047      bx      lr

===== sub_0033629c @ 0x0033629c =====
0x0033629c:  ff21      movs    r1, #0xff
0x0033629e:  021c      adds    r2, r0, #0
0x003362a0:  130a      lsrs    r3, r2, #8
0x003362a2:  0840      ands    r0, r1
0x003362a4:  0b40      ands    r3, r1
0x003362a6:  0002      lsls    r0, r0, #8
0x003362a8:  1843      orrs    r0, r3
0x003362aa:  130c      lsrs    r3, r2, #0x10
0x003362ac:  0b40      ands    r3, r1
0x003362ae:  120e      lsrs    r2, r2, #0x18
0x003362b0:  0a40      ands    r2, r1
0x003362b2:  1b02      lsls    r3, r3, #8
0x003362b4:  1343      orrs    r3, r2
0x003362b6:  0004      lsls    r0, r0, #0x10
0x003362b8:  1843      orrs    r0, r3
0x003362ba:  7047      bx      lr

===== sub_003362bc @ 0x003362bc =====
0x003362bc:  0170      strb    r1, [r0]
0x003362be:  090a      lsrs    r1, r1, #8
0x003362c0:  4170      strb    r1, [r0, #1]
0x003362c2:  7047      bx      lr

===== sub_003362c4 @ 0x003362c4 =====
0x003362c4:  031c      adds    r3, r0, #0
0x003362c6:  5b78      ldrb    r3, [r3, #1]
0x003362c8:  0078      ldrb    r0, [r0]
0x003362ca:  1b02      lsls    r3, r3, #8
0x003362cc:  1843      orrs    r0, r3
0x003362ce:  7047      bx      lr

===== sub_003362d0 @ 0x003362d0 =====
0x003362d0:  0b0a      lsrs    r3, r1, #8
0x003362d2:  0170      strb    r1, [r0]
0x003362d4:  4370      strb    r3, [r0, #1]
0x003362d6:  0b0c      lsrs    r3, r1, #0x10
0x003362d8:  090e      lsrs    r1, r1, #0x18
0x003362da:  8370      strb    r3, [r0, #2]
0x003362dc:  c170      strb    r1, [r0, #3]
0x003362de:  7047      bx      lr

===== sub_003362e0 @ 0x003362e0 =====
0x003362e0:  021c      adds    r2, r0, #0
0x003362e2:  5378      ldrb    r3, [r2, #1]
0x003362e4:  0078      ldrb    r0, [r0]
0x003362e6:  1b02      lsls    r3, r3, #8
0x003362e8:  1843      orrs    r0, r3
0x003362ea:  9378      ldrb    r3, [r2, #2]
0x003362ec:  1b04      lsls    r3, r3, #0x10
0x003362ee:  1843      orrs    r0, r3
0x003362f0:  d378      ldrb    r3, [r2, #3]
0x003362f2:  1b06      lsls    r3, r3, #0x18
0x003362f4:  1843      orrs    r0, r3
0x003362f6:  7047      bx      lr

===== sub_003364b8 @ 0x003364b8 =====
0x003364b8:  10b5      push    {r4, lr}
0x003364ba:  0006      lsls    r0, r0, #0x18
0x003364bc:  040e      lsrs    r4, r0, #0x18
0x003364be:  201c      adds    r0, r4, #0
0x003364c0:  03f0dcf8  bl      #0x33967c  ; sub_0033967c
0x003364c4:  0f4b      ldr     r3, [pc, #0x3c]  ; =0x0035f1c2
0x003364c6:  1b88      ldrh    r3, [r3]
0x003364c8:  002b      cmp     r3, #0
0x003364ca:  18d0      beq     #0x3364fe
0x003364cc:  0e4b      ldr     r3, [pc, #0x38]  ; =0x002f620c
0x003364ce:  1a68      ldr     r2, [r3]
0x003364d0:  002a      cmp     r2, #0
0x003364d2:  14d0      beq     #0x3364fe
0x003364d4:  0d49      ldr     r1, [pc, #0x34]  ; =0x002f6208
0x003364d6:  0b88      ldrh    r3, [r1]
0x003364d8:  002b      cmp     r3, #0
0x003364da:  10d0      beq     #0x3364fe
0x003364dc:  0c48      ldr     r0, [pc, #0x30]  ; =0x002f6206
0x003364de:  0388      ldrh    r3, [r0]
0x003364e0:  9c54      strb    r4, [r3, r2]
0x003364e2:  0133      adds    r3, #1
0x003364e4:  1b04      lsls    r3, r3, #0x10
0x003364e6:  0988      ldrh    r1, [r1]
0x003364e8:  1b0c      lsrs    r3, r3, #0x10
0x003364ea:  9942      cmp     r1, r3
0x003364ec:  00d8      bhi     #0x3364f0
0x003364ee:  0023      movs    r3, #0
0x003364f0:  084a      ldr     r2, [pc, #0x20]  ; =0x002f6204
0x003364f2:  0380      strh    r3, [r0]
0x003364f4:  1088      ldrh    r0, [r2]
0x003364f6:  8842      cmp     r0, r1
0x003364f8:  01d2      bhs     #0x3364fe
0x003364fa:  431c      adds    r3, r0, #1
0x003364fc:  1380      strh    r3, [r2]
0x003364fe:  10bc      pop     {r4}
0x00336500:  01bc      pop     {r0}
0x00336502:  0047      bx      r0
0x00336504:  c2f13500  rsb.w   r0, r2, #0x35
0x00336508:  0c62      str     r4, [r1, #0x20]
0x0033650a:  2f00      movs    r7, r5
0x0033650c:  0862      str     r0, [r1, #0x20]
0x0033650e:  2f00      movs    r7, r5
0x00336510:  0662      str     r6, [r0, #0x20]
0x00336512:  2f00      movs    r7, r5
0x00336514:  0462      str     r4, [r0, #0x20]
0x00336516:  2f00      movs    r7, r5
0x00336518:  00b5      push    {lr}
0x0033651a:  0d20      movs    r0, #0xd
0x0033651c:  fff7ccff  bl      #0x3364b8  ; sub_003364b8
0x00336520:  0a20      movs    r0, #0xa
0x00336522:  fff7c9ff  bl      #0x3364b8  ; sub_003364b8
0x00336526:  01bc      pop     {r0}
0x00336528:  0047      bx      r0
0x0033652a:  0000      movs    r0, r0
0x0033652c:  00b5      push    {lr}
0x0033652e:  0022      movs    r2, #0
0x00336530:  00e0      b       #0x336534
0x00336532:  0132      adds    r2, #1
0x00336534:  0378      ldrb    r3, [r0]
0x00336536:  0130      adds    r0, #1
0x00336538:  1b06      lsls    r3, r3, #0x18
0x0033653a:  002b      cmp     r3, #0
0x0033653c:  f9d1      bne     #0x336532
0x0033653e:  101c      adds    r0, r2, #0
0x00336540:  02bc      pop     {r1}
0x00336542:  0847      bx      r1
0x00336544:  f0b5      push    {r4, r5, r6, r7, lr}
0x00336546:  061c      adds    r6, r0, #0
0x00336548:  03f0daf8  bl      #0x339700  ; sub_00339700
0x0033654c:  204b      ldr     r3, [pc, #0x80]  ; =0x0035f1c2
0x0033654e:  1b88      ldrh    r3, [r3]
0x00336550:  002b      cmp     r3, #0
0x00336552:  07d0      beq     #0x336564
0x00336554:  1f4b      ldr     r3, [pc, #0x7c]  ; =0x002f620c
0x00336556:  1b68      ldr     r3, [r3]
0x00336558:  002b      cmp     r3, #0
0x0033655a:  03d0      beq     #0x336564
0x0033655c:  1e4c      ldr     r4, [pc, #0x78]  ; =0x002f6208
0x0033655e:  2388      ldrh    r3, [r4]
0x00336560:  002b      cmp     r3, #0
0x00336562:  02d1      bne     #0x33656a
0x00336564:  f0bc      pop     {r4, r5, r6, r7}
0x00336566:  01bc      pop     {r0}
0x00336568:  0047      bx      r0
0x0033656a:  301c      adds    r0, r6, #0
0x0033656c:  fff7deff  bl      #0x33652c  ; sub_0033652c
0x00336570:  1a49      ldr     r1, [pc, #0x68]  ; =0x002f6204
0x00336572:  0004      lsls    r0, r0, #0x10
0x00336574:  050c      lsrs    r5, r0, #0x10
0x00336576:  2088      ldrh    r0, [r4]
0x00336578:  0f88      ldrh    r7, [r1]
0x0033657a:  031c      adds    r3, r0, #0
0x0033657c:  9f42      cmp     r7, r3
0x0033657e:  1fd3      blo     #0x3365c0
0x00336580:  002d      cmp     r5, #0
0x00336582:  efd0      beq     #0x336564
0x00336584:  164f      ldr     r7, [pc, #0x58]  ; =0x002f6206
0x00336586:  0ee0      b       #0x3365a6
0x00336588:  5319      adds    r3, r2, r5
0x0033658a:  1b04      lsls    r3, r3, #0x10
0x0033658c:  2c1c      adds    r4, r5, #0
0x0033658e:  1a0c      lsrs    r2, r3, #0x10
0x00336590:  3a80      strh    r2, [r7]
0x00336592:  311c      adds    r1, r6, #0
0x00336594:  221c      adds    r2, r4, #0
0x00336596:  03f0fffc  bl      #0x339f98  ; sub_00339f98
0x0033659a:  2b1b      subs    r3, r5, r4
0x0033659c:  1b04      lsls    r3, r3, #0x10
0x0033659e:  1d0c      lsrs    r5, r3, #0x10
0x003365a0:  3619      adds    r6, r6, r4
0x003365a2:  002d      cmp     r5, #0
0x003365a4:  ded0      beq     #0x336564
0x003365a6:  0b4b      ldr     r3, [pc, #0x2c]  ; =0x002f620c
0x003365a8:  3a88      ldrh    r2, [r7]
0x003365aa:  1b68      ldr     r3, [r3]
0x003365ac:  d018      adds    r0, r2, r3
0x003365ae:  0a4b      ldr     r3, [pc, #0x28]  ; =0x002f6208
0x003365b0:  1b88      ldrh    r3, [r3]
0x003365b2:  9b1a      subs    r3, r3, r2
0x003365b4:  1b04      lsls    r3, r3, #0x10
0x003365b6:  1c0c      lsrs    r4, r3, #0x10
0x003365b8:  ac42      cmp     r4, r5
0x003365ba:  e5d8      bhi     #0x336588
0x003365bc:  0022      movs    r2, #0
0x003365be:  e7e7      b       #0x336590
0x003365c0:  c31b      subs    r3, r0, r7
0x003365c2:  ab42      cmp     r3, r5
0x003365c4:  02dd      ble     #0x3365cc
0x003365c6:  eb19      adds    r3, r5, r7
0x003365c8:  0b80      strh    r3, [r1]
0x003365ca:  d9e7      b       #0x336580
0x003365cc:  0880      strh    r0, [r1]
0x003365ce:  d7e7      b       #0x336580
0x003365d0:  c2f13500  rsb.w   r0, r2, #0x35
0x003365d4:  0c62      str     r4, [r1, #0x20]
0x003365d6:  2f00      movs    r7, r5
0x003365d8:  0862      str     r0, [r1, #0x20]
0x003365da:  2f00      movs    r7, r5
0x003365dc:  0462      str     r4, [r0, #0x20]
0x003365de:  2f00      movs    r7, r5
0x003365e0:  0662      str     r6, [r0, #0x20]
0x003365e2:  2f00      movs    r7, r5
0x003365e4:  00b5      push    {lr}
0x003365e6:  0006      lsls    r0, r0, #0x18
0x003365e8:  000e      lsrs    r0, r0, #0x18
0x003365ea:  6028      cmp     r0, #0x60
0x003365ec:  00dd      ble     #0x3365f0
0x003365ee:  2038      subs    r0, #0x20
0x003365f0:  3038      subs    r0, #0x30
0x003365f2:  0928      cmp     r0, #9
0x003365f4:  04d9      bls     #0x336600
0x003365f6:  0738      subs    r0, #7
0x003365f8:  031c      adds    r3, r0, #0
0x003365fa:  0a3b      subs    r3, #0xa
0x003365fc:  052b      cmp     r3, #5
0x003365fe:  01d8      bhi     #0x336604
0x00336600:  02bc      pop     {r1}
0x00336602:  0847      bx      r1
0x00336604:  0120      movs    r0, #1
0x00336606:  4042      rsbs    r0, r0, #0
0x00336608:  fae7      b       #0x336600
0x0033660a:  0000      movs    r0, r0
0x0033660c:  00b5      push    {lr}
0x0033660e:  0006      lsls    r0, r0, #0x18
0x00336610:  000e      lsrs    r0, r0, #0x18
0x00336612:  0928      cmp     r0, #9
0x00336614:  05d8      bhi     #0x336622
0x00336616:  031c      adds    r3, r0, #0
0x00336618:  3033      adds    r3, #0x30
0x0033661a:  1b06      lsls    r3, r3, #0x18
0x0033661c:  180e      lsrs    r0, r3, #0x18
0x0033661e:  02bc      pop     {r1}
0x00336620:  0847      bx      r1
0x00336622:  031c      adds    r3, r0, #0
0x00336624:  3733      adds    r3, #0x37
0x00336626:  f8e7      b       #0x33661a
0x00336628:  00b5      push    {lr}
0x0033662a:  0006      lsls    r0, r0, #0x18
0x0033662c:  000e      lsrs    r0, r0, #0x18
0x0033662e:  3038      subs    r0, #0x30
0x00336630:  0306      lsls    r3, r0, #0x18
0x00336632:  1b0e      lsrs    r3, r3, #0x18
0x00336634:  092b      cmp     r3, #9
0x00336636:  01d8      bhi     #0x33663c
0x00336638:  02bc      pop     {r1}
0x0033663a:  0847      bx      r1
0x0033663c:  0120      movs    r0, #1
0x0033663e:  4042      rsbs    r0, r0, #0
0x00336640:  fae7      b       #0x336638
0x00336642:  0000      movs    r0, r0
0x00336644:  c023      movs    r3, #0xc0
0x00336646:  9b05      lsls    r3, r3, #0x16
0x00336648:  0006      lsls    r0, r0, #0x18
0x0033664a:  c018      adds    r0, r0, r3
0x0033664c:  000e      lsrs    r0, r0, #0x18
0x0033664e:  7047      bx      lr

===== sub_00336518 @ 0x00336518 =====
0x00336518:  00b5      push    {lr}
0x0033651a:  0d20      movs    r0, #0xd
0x0033651c:  fff7ccff  bl      #0x3364b8  ; sub_003364b8
0x00336520:  0a20      movs    r0, #0xa
0x00336522:  fff7c9ff  bl      #0x3364b8  ; sub_003364b8
0x00336526:  01bc      pop     {r0}
0x00336528:  0047      bx      r0
0x0033652a:  0000      movs    r0, r0
0x0033652c:  00b5      push    {lr}
0x0033652e:  0022      movs    r2, #0
0x00336530:  00e0      b       #0x336534
0x00336532:  0132      adds    r2, #1
0x00336534:  0378      ldrb    r3, [r0]
0x00336536:  0130      adds    r0, #1
0x00336538:  1b06      lsls    r3, r3, #0x18
0x0033653a:  002b      cmp     r3, #0
0x0033653c:  f9d1      bne     #0x336532
0x0033653e:  101c      adds    r0, r2, #0
0x00336540:  02bc      pop     {r1}
0x00336542:  0847      bx      r1
0x00336544:  f0b5      push    {r4, r5, r6, r7, lr}
0x00336546:  061c      adds    r6, r0, #0
0x00336548:  03f0daf8  bl      #0x339700  ; sub_00339700
0x0033654c:  204b      ldr     r3, [pc, #0x80]  ; =0x0035f1c2
0x0033654e:  1b88      ldrh    r3, [r3]
0x00336550:  002b      cmp     r3, #0
0x00336552:  07d0      beq     #0x336564
0x00336554:  1f4b      ldr     r3, [pc, #0x7c]  ; =0x002f620c
0x00336556:  1b68      ldr     r3, [r3]
0x00336558:  002b      cmp     r3, #0
0x0033655a:  03d0      beq     #0x336564
0x0033655c:  1e4c      ldr     r4, [pc, #0x78]  ; =0x002f6208
0x0033655e:  2388      ldrh    r3, [r4]
0x00336560:  002b      cmp     r3, #0
0x00336562:  02d1      bne     #0x33656a
0x00336564:  f0bc      pop     {r4, r5, r6, r7}
0x00336566:  01bc      pop     {r0}
0x00336568:  0047      bx      r0
0x0033656a:  301c      adds    r0, r6, #0
0x0033656c:  fff7deff  bl      #0x33652c  ; sub_0033652c
0x00336570:  1a49      ldr     r1, [pc, #0x68]  ; =0x002f6204
0x00336572:  0004      lsls    r0, r0, #0x10
0x00336574:  050c      lsrs    r5, r0, #0x10
0x00336576:  2088      ldrh    r0, [r4]
0x00336578:  0f88      ldrh    r7, [r1]
0x0033657a:  031c      adds    r3, r0, #0
0x0033657c:  9f42      cmp     r7, r3
0x0033657e:  1fd3      blo     #0x3365c0
0x00336580:  002d      cmp     r5, #0
0x00336582:  efd0      beq     #0x336564
0x00336584:  164f      ldr     r7, [pc, #0x58]  ; =0x002f6206
0x00336586:  0ee0      b       #0x3365a6
0x00336588:  5319      adds    r3, r2, r5
0x0033658a:  1b04      lsls    r3, r3, #0x10
0x0033658c:  2c1c      adds    r4, r5, #0
0x0033658e:  1a0c      lsrs    r2, r3, #0x10
0x00336590:  3a80      strh    r2, [r7]
0x00336592:  311c      adds    r1, r6, #0
0x00336594:  221c      adds    r2, r4, #0
0x00336596:  03f0fffc  bl      #0x339f98  ; sub_00339f98
0x0033659a:  2b1b      subs    r3, r5, r4
0x0033659c:  1b04      lsls    r3, r3, #0x10
0x0033659e:  1d0c      lsrs    r5, r3, #0x10
0x003365a0:  3619      adds    r6, r6, r4
0x003365a2:  002d      cmp     r5, #0
0x003365a4:  ded0      beq     #0x336564
0x003365a6:  0b4b      ldr     r3, [pc, #0x2c]  ; =0x002f620c
0x003365a8:  3a88      ldrh    r2, [r7]
0x003365aa:  1b68      ldr     r3, [r3]
0x003365ac:  d018      adds    r0, r2, r3
0x003365ae:  0a4b      ldr     r3, [pc, #0x28]  ; =0x002f6208
0x003365b0:  1b88      ldrh    r3, [r3]
0x003365b2:  9b1a      subs    r3, r3, r2
0x003365b4:  1b04      lsls    r3, r3, #0x10
0x003365b6:  1c0c      lsrs    r4, r3, #0x10
0x003365b8:  ac42      cmp     r4, r5
0x003365ba:  e5d8      bhi     #0x336588
0x003365bc:  0022      movs    r2, #0
0x003365be:  e7e7      b       #0x336590
0x003365c0:  c31b      subs    r3, r0, r7
0x003365c2:  ab42      cmp     r3, r5
0x003365c4:  02dd      ble     #0x3365cc
0x003365c6:  eb19      adds    r3, r5, r7
0x003365c8:  0b80      strh    r3, [r1]
0x003365ca:  d9e7      b       #0x336580
0x003365cc:  0880      strh    r0, [r1]
0x003365ce:  d7e7      b       #0x336580
0x003365d0:  c2f13500  rsb.w   r0, r2, #0x35
0x003365d4:  0c62      str     r4, [r1, #0x20]
0x003365d6:  2f00      movs    r7, r5
0x003365d8:  0862      str     r0, [r1, #0x20]
0x003365da:  2f00      movs    r7, r5
0x003365dc:  0462      str     r4, [r0, #0x20]
0x003365de:  2f00      movs    r7, r5
0x003365e0:  0662      str     r6, [r0, #0x20]
0x003365e2:  2f00      movs    r7, r5
0x003365e4:  00b5      push    {lr}
0x003365e6:  0006      lsls    r0, r0, #0x18
0x003365e8:  000e      lsrs    r0, r0, #0x18
0x003365ea:  6028      cmp     r0, #0x60
0x003365ec:  00dd      ble     #0x3365f0
0x003365ee:  2038      subs    r0, #0x20
0x003365f0:  3038      subs    r0, #0x30
0x003365f2:  0928      cmp     r0, #9
0x003365f4:  04d9      bls     #0x336600
0x003365f6:  0738      subs    r0, #7
0x003365f8:  031c      adds    r3, r0, #0
0x003365fa:  0a3b      subs    r3, #0xa
0x003365fc:  052b      cmp     r3, #5
0x003365fe:  01d8      bhi     #0x336604
0x00336600:  02bc      pop     {r1}
0x00336602:  0847      bx      r1
0x00336604:  0120      movs    r0, #1
0x00336606:  4042      rsbs    r0, r0, #0
0x00336608:  fae7      b       #0x336600
0x0033660a:  0000      movs    r0, r0
0x0033660c:  00b5      push    {lr}
0x0033660e:  0006      lsls    r0, r0, #0x18
0x00336610:  000e      lsrs    r0, r0, #0x18
0x00336612:  0928      cmp     r0, #9
0x00336614:  05d8      bhi     #0x336622
0x00336616:  031c      adds    r3, r0, #0
0x00336618:  3033      adds    r3, #0x30
0x0033661a:  1b06      lsls    r3, r3, #0x18
0x0033661c:  180e      lsrs    r0, r3, #0x18
0x0033661e:  02bc      pop     {r1}
0x00336620:  0847      bx      r1
0x00336622:  031c      adds    r3, r0, #0
0x00336624:  3733      adds    r3, #0x37
0x00336626:  f8e7      b       #0x33661a
0x00336628:  00b5      push    {lr}
0x0033662a:  0006      lsls    r0, r0, #0x18
0x0033662c:  000e      lsrs    r0, r0, #0x18
0x0033662e:  3038      subs    r0, #0x30
0x00336630:  0306      lsls    r3, r0, #0x18
0x00336632:  1b0e      lsrs    r3, r3, #0x18
0x00336634:  092b      cmp     r3, #9
0x00336636:  01d8      bhi     #0x33663c
0x00336638:  02bc      pop     {r1}
0x0033663a:  0847      bx      r1
0x0033663c:  0120      movs    r0, #1
0x0033663e:  4042      rsbs    r0, r0, #0
0x00336640:  fae7      b       #0x336638
0x00336642:  0000      movs    r0, r0
0x00336644:  c023      movs    r3, #0xc0
0x00336646:  9b05      lsls    r3, r3, #0x16
0x00336648:  0006      lsls    r0, r0, #0x18
0x0033664a:  c018      adds    r0, r0, r3
0x0033664c:  000e      lsrs    r0, r0, #0x18
0x0033664e:  7047      bx      lr

===== sub_0033652c @ 0x0033652c =====
0x0033652c:  00b5      push    {lr}
0x0033652e:  0022      movs    r2, #0
0x00336530:  00e0      b       #0x336534
0x00336532:  0132      adds    r2, #1
0x00336534:  0378      ldrb    r3, [r0]
0x00336536:  0130      adds    r0, #1
0x00336538:  1b06      lsls    r3, r3, #0x18
0x0033653a:  002b      cmp     r3, #0
0x0033653c:  f9d1      bne     #0x336532
0x0033653e:  101c      adds    r0, r2, #0
0x00336540:  02bc      pop     {r1}
0x00336542:  0847      bx      r1
0x00336544:  f0b5      push    {r4, r5, r6, r7, lr}
0x00336546:  061c      adds    r6, r0, #0
0x00336548:  03f0daf8  bl      #0x339700  ; sub_00339700
0x0033654c:  204b      ldr     r3, [pc, #0x80]  ; =0x0035f1c2
0x0033654e:  1b88      ldrh    r3, [r3]
0x00336550:  002b      cmp     r3, #0
0x00336552:  07d0      beq     #0x336564
0x00336554:  1f4b      ldr     r3, [pc, #0x7c]  ; =0x002f620c
0x00336556:  1b68      ldr     r3, [r3]
0x00336558:  002b      cmp     r3, #0
0x0033655a:  03d0      beq     #0x336564
0x0033655c:  1e4c      ldr     r4, [pc, #0x78]  ; =0x002f6208
0x0033655e:  2388      ldrh    r3, [r4]
0x00336560:  002b      cmp     r3, #0
0x00336562:  02d1      bne     #0x33656a
0x00336564:  f0bc      pop     {r4, r5, r6, r7}
0x00336566:  01bc      pop     {r0}
0x00336568:  0047      bx      r0
0x0033656a:  301c      adds    r0, r6, #0
0x0033656c:  fff7deff  bl      #0x33652c  ; sub_0033652c
0x00336570:  1a49      ldr     r1, [pc, #0x68]  ; =0x002f6204
0x00336572:  0004      lsls    r0, r0, #0x10
0x00336574:  050c      lsrs    r5, r0, #0x10
0x00336576:  2088      ldrh    r0, [r4]
0x00336578:  0f88      ldrh    r7, [r1]
0x0033657a:  031c      adds    r3, r0, #0
0x0033657c:  9f42      cmp     r7, r3
0x0033657e:  1fd3      blo     #0x3365c0
0x00336580:  002d      cmp     r5, #0
0x00336582:  efd0      beq     #0x336564
0x00336584:  164f      ldr     r7, [pc, #0x58]  ; =0x002f6206
0x00336586:  0ee0      b       #0x3365a6
0x00336588:  5319      adds    r3, r2, r5
0x0033658a:  1b04      lsls    r3, r3, #0x10
0x0033658c:  2c1c      adds    r4, r5, #0
0x0033658e:  1a0c      lsrs    r2, r3, #0x10
0x00336590:  3a80      strh    r2, [r7]
0x00336592:  311c      adds    r1, r6, #0
0x00336594:  221c      adds    r2, r4, #0
0x00336596:  03f0fffc  bl      #0x339f98  ; sub_00339f98
0x0033659a:  2b1b      subs    r3, r5, r4
0x0033659c:  1b04      lsls    r3, r3, #0x10
0x0033659e:  1d0c      lsrs    r5, r3, #0x10
0x003365a0:  3619      adds    r6, r6, r4
0x003365a2:  002d      cmp     r5, #0
0x003365a4:  ded0      beq     #0x336564
0x003365a6:  0b4b      ldr     r3, [pc, #0x2c]  ; =0x002f620c
0x003365a8:  3a88      ldrh    r2, [r7]
0x003365aa:  1b68      ldr     r3, [r3]
0x003365ac:  d018      adds    r0, r2, r3
0x003365ae:  0a4b      ldr     r3, [pc, #0x28]  ; =0x002f6208
0x003365b0:  1b88      ldrh    r3, [r3]
0x003365b2:  9b1a      subs    r3, r3, r2
0x003365b4:  1b04      lsls    r3, r3, #0x10
0x003365b6:  1c0c      lsrs    r4, r3, #0x10
0x003365b8:  ac42      cmp     r4, r5
0x003365ba:  e5d8      bhi     #0x336588
0x003365bc:  0022      movs    r2, #0
0x003365be:  e7e7      b       #0x336590
0x003365c0:  c31b      subs    r3, r0, r7
0x003365c2:  ab42      cmp     r3, r5
0x003365c4:  02dd      ble     #0x3365cc
0x003365c6:  eb19      adds    r3, r5, r7
0x003365c8:  0b80      strh    r3, [r1]
0x003365ca:  d9e7      b       #0x336580
0x003365cc:  0880      strh    r0, [r1]
0x003365ce:  d7e7      b       #0x336580
0x003365d0:  c2f13500  rsb.w   r0, r2, #0x35
0x003365d4:  0c62      str     r4, [r1, #0x20]
0x003365d6:  2f00      movs    r7, r5
0x003365d8:  0862      str     r0, [r1, #0x20]
0x003365da:  2f00      movs    r7, r5
0x003365dc:  0462      str     r4, [r0, #0x20]
0x003365de:  2f00      movs    r7, r5
0x003365e0:  0662      str     r6, [r0, #0x20]
0x003365e2:  2f00      movs    r7, r5
0x003365e4:  00b5      push    {lr}
0x003365e6:  0006      lsls    r0, r0, #0x18
0x003365e8:  000e      lsrs    r0, r0, #0x18
0x003365ea:  6028      cmp     r0, #0x60
0x003365ec:  00dd      ble     #0x3365f0
0x003365ee:  2038      subs    r0, #0x20
0x003365f0:  3038      subs    r0, #0x30
0x003365f2:  0928      cmp     r0, #9
0x003365f4:  04d9      bls     #0x336600
0x003365f6:  0738      subs    r0, #7
0x003365f8:  031c      adds    r3, r0, #0
0x003365fa:  0a3b      subs    r3, #0xa
0x003365fc:  052b      cmp     r3, #5
0x003365fe:  01d8      bhi     #0x336604
0x00336600:  02bc      pop     {r1}
0x00336602:  0847      bx      r1
0x00336604:  0120      movs    r0, #1
0x00336606:  4042      rsbs    r0, r0, #0
0x00336608:  fae7      b       #0x336600
0x0033660a:  0000      movs    r0, r0
0x0033660c:  00b5      push    {lr}
0x0033660e:  0006      lsls    r0, r0, #0x18
0x00336610:  000e      lsrs    r0, r0, #0x18
0x00336612:  0928      cmp     r0, #9
0x00336614:  05d8      bhi     #0x336622
0x00336616:  031c      adds    r3, r0, #0
0x00336618:  3033      adds    r3, #0x30
0x0033661a:  1b06      lsls    r3, r3, #0x18
0x0033661c:  180e      lsrs    r0, r3, #0x18
0x0033661e:  02bc      pop     {r1}
0x00336620:  0847      bx      r1
0x00336622:  031c      adds    r3, r0, #0
0x00336624:  3733      adds    r3, #0x37
0x00336626:  f8e7      b       #0x33661a
0x00336628:  00b5      push    {lr}
0x0033662a:  0006      lsls    r0, r0, #0x18
0x0033662c:  000e      lsrs    r0, r0, #0x18
0x0033662e:  3038      subs    r0, #0x30
0x00336630:  0306      lsls    r3, r0, #0x18
0x00336632:  1b0e      lsrs    r3, r3, #0x18
0x00336634:  092b      cmp     r3, #9
0x00336636:  01d8      bhi     #0x33663c
0x00336638:  02bc      pop     {r1}
0x0033663a:  0847      bx      r1
0x0033663c:  0120      movs    r0, #1
0x0033663e:  4042      rsbs    r0, r0, #0
0x00336640:  fae7      b       #0x336638
0x00336642:  0000      movs    r0, r0
0x00336644:  c023      movs    r3, #0xc0
0x00336646:  9b05      lsls    r3, r3, #0x16
0x00336648:  0006      lsls    r0, r0, #0x18
0x0033664a:  c018      adds    r0, r0, r3
0x0033664c:  000e      lsrs    r0, r0, #0x18
0x0033664e:  7047      bx      lr

===== sub_00336544 @ 0x00336544 =====
0x00336544:  f0b5      push    {r4, r5, r6, r7, lr}
0x00336546:  061c      adds    r6, r0, #0
0x00336548:  03f0daf8  bl      #0x339700  ; sub_00339700
0x0033654c:  204b      ldr     r3, [pc, #0x80]  ; =0x0035f1c2
0x0033654e:  1b88      ldrh    r3, [r3]
0x00336550:  002b      cmp     r3, #0
0x00336552:  07d0      beq     #0x336564
0x00336554:  1f4b      ldr     r3, [pc, #0x7c]  ; =0x002f620c
0x00336556:  1b68      ldr     r3, [r3]
0x00336558:  002b      cmp     r3, #0
0x0033655a:  03d0      beq     #0x336564
0x0033655c:  1e4c      ldr     r4, [pc, #0x78]  ; =0x002f6208
0x0033655e:  2388      ldrh    r3, [r4]
0x00336560:  002b      cmp     r3, #0
0x00336562:  02d1      bne     #0x33656a
0x00336564:  f0bc      pop     {r4, r5, r6, r7}
0x00336566:  01bc      pop     {r0}
0x00336568:  0047      bx      r0
0x0033656a:  301c      adds    r0, r6, #0
0x0033656c:  fff7deff  bl      #0x33652c  ; sub_0033652c
0x00336570:  1a49      ldr     r1, [pc, #0x68]  ; =0x002f6204
0x00336572:  0004      lsls    r0, r0, #0x10
0x00336574:  050c      lsrs    r5, r0, #0x10
0x00336576:  2088      ldrh    r0, [r4]
0x00336578:  0f88      ldrh    r7, [r1]
0x0033657a:  031c      adds    r3, r0, #0
0x0033657c:  9f42      cmp     r7, r3
0x0033657e:  1fd3      blo     #0x3365c0
0x00336580:  002d      cmp     r5, #0
0x00336582:  efd0      beq     #0x336564
0x00336584:  164f      ldr     r7, [pc, #0x58]  ; =0x002f6206
0x00336586:  0ee0      b       #0x3365a6
0x00336588:  5319      adds    r3, r2, r5
0x0033658a:  1b04      lsls    r3, r3, #0x10
0x0033658c:  2c1c      adds    r4, r5, #0
0x0033658e:  1a0c      lsrs    r2, r3, #0x10
0x00336590:  3a80      strh    r2, [r7]
0x00336592:  311c      adds    r1, r6, #0
0x00336594:  221c      adds    r2, r4, #0
0x00336596:  03f0fffc  bl      #0x339f98  ; sub_00339f98
0x0033659a:  2b1b      subs    r3, r5, r4
0x0033659c:  1b04      lsls    r3, r3, #0x10
0x0033659e:  1d0c      lsrs    r5, r3, #0x10
0x003365a0:  3619      adds    r6, r6, r4
0x003365a2:  002d      cmp     r5, #0
0x003365a4:  ded0      beq     #0x336564
0x003365a6:  0b4b      ldr     r3, [pc, #0x2c]  ; =0x002f620c
0x003365a8:  3a88      ldrh    r2, [r7]
0x003365aa:  1b68      ldr     r3, [r3]
0x003365ac:  d018      adds    r0, r2, r3
0x003365ae:  0a4b      ldr     r3, [pc, #0x28]  ; =0x002f6208
0x003365b0:  1b88      ldrh    r3, [r3]
0x003365b2:  9b1a      subs    r3, r3, r2
0x003365b4:  1b04      lsls    r3, r3, #0x10
0x003365b6:  1c0c      lsrs    r4, r3, #0x10
0x003365b8:  ac42      cmp     r4, r5
0x003365ba:  e5d8      bhi     #0x336588
0x003365bc:  0022      movs    r2, #0
0x003365be:  e7e7      b       #0x336590
0x003365c0:  c31b      subs    r3, r0, r7
0x003365c2:  ab42      cmp     r3, r5
0x003365c4:  02dd      ble     #0x3365cc
0x003365c6:  eb19      adds    r3, r5, r7
0x003365c8:  0b80      strh    r3, [r1]
0x003365ca:  d9e7      b       #0x336580
0x003365cc:  0880      strh    r0, [r1]
0x003365ce:  d7e7      b       #0x336580
0x003365d0:  c2f13500  rsb.w   r0, r2, #0x35
0x003365d4:  0c62      str     r4, [r1, #0x20]
0x003365d6:  2f00      movs    r7, r5
0x003365d8:  0862      str     r0, [r1, #0x20]
0x003365da:  2f00      movs    r7, r5
0x003365dc:  0462      str     r4, [r0, #0x20]
0x003365de:  2f00      movs    r7, r5
0x003365e0:  0662      str     r6, [r0, #0x20]
0x003365e2:  2f00      movs    r7, r5
0x003365e4:  00b5      push    {lr}
0x003365e6:  0006      lsls    r0, r0, #0x18
0x003365e8:  000e      lsrs    r0, r0, #0x18
0x003365ea:  6028      cmp     r0, #0x60
0x003365ec:  00dd      ble     #0x3365f0
0x003365ee:  2038      subs    r0, #0x20
0x003365f0:  3038      subs    r0, #0x30
0x003365f2:  0928      cmp     r0, #9
0x003365f4:  04d9      bls     #0x336600
0x003365f6:  0738      subs    r0, #7
0x003365f8:  031c      adds    r3, r0, #0
0x003365fa:  0a3b      subs    r3, #0xa
0x003365fc:  052b      cmp     r3, #5
0x003365fe:  01d8      bhi     #0x336604
0x00336600:  02bc      pop     {r1}
0x00336602:  0847      bx      r1
0x00336604:  0120      movs    r0, #1
0x00336606:  4042      rsbs    r0, r0, #0
0x00336608:  fae7      b       #0x336600
0x0033660a:  0000      movs    r0, r0
0x0033660c:  00b5      push    {lr}
0x0033660e:  0006      lsls    r0, r0, #0x18
0x00336610:  000e      lsrs    r0, r0, #0x18
0x00336612:  0928      cmp     r0, #9
0x00336614:  05d8      bhi     #0x336622
0x00336616:  031c      adds    r3, r0, #0
0x00336618:  3033      adds    r3, #0x30
0x0033661a:  1b06      lsls    r3, r3, #0x18
0x0033661c:  180e      lsrs    r0, r3, #0x18
0x0033661e:  02bc      pop     {r1}
0x00336620:  0847      bx      r1
0x00336622:  031c      adds    r3, r0, #0
0x00336624:  3733      adds    r3, #0x37
0x00336626:  f8e7      b       #0x33661a
0x00336628:  00b5      push    {lr}
0x0033662a:  0006      lsls    r0, r0, #0x18
0x0033662c:  000e      lsrs    r0, r0, #0x18
0x0033662e:  3038      subs    r0, #0x30
0x00336630:  0306      lsls    r3, r0, #0x18
0x00336632:  1b0e      lsrs    r3, r3, #0x18
0x00336634:  092b      cmp     r3, #9
0x00336636:  01d8      bhi     #0x33663c
0x00336638:  02bc      pop     {r1}
0x0033663a:  0847      bx      r1
0x0033663c:  0120      movs    r0, #1
0x0033663e:  4042      rsbs    r0, r0, #0
0x00336640:  fae7      b       #0x336638
0x00336642:  0000      movs    r0, r0
0x00336644:  c023      movs    r3, #0xc0
0x00336646:  9b05      lsls    r3, r3, #0x16
0x00336648:  0006      lsls    r0, r0, #0x18
0x0033664a:  c018      adds    r0, r0, r3
0x0033664c:  000e      lsrs    r0, r0, #0x18
0x0033664e:  7047      bx      lr

===== sub_00336650 @ 0x00336650 =====
0x00336650:  30b5      push    {r4, r5, lr}
0x00336652:  0006      lsls    r0, r0, #0x18
0x00336654:  050e      lsrs    r5, r0, #0x18
0x00336656:  000f      lsrs    r0, r0, #0x1c
0x00336658:  0c1c      adds    r4, r1, #0
0x0033665a:  fff7d7ff  bl      #0x33660c  ; sub_0033660c
0x0033665e:  0f23      movs    r3, #0xf
0x00336660:  2070      strb    r0, [r4]
0x00336662:  281c      adds    r0, r5, #0
0x00336664:  1840      ands    r0, r3
0x00336666:  fff7d1ff  bl      #0x33660c  ; sub_0033660c
0x0033666a:  0134      adds    r4, #1
0x0033666c:  2070      strb    r0, [r4]
0x0033666e:  601c      adds    r0, r4, #1
0x00336670:  30bc      pop     {r4, r5}
0x00336672:  02bc      pop     {r1}
0x00336674:  0847      bx      r1
0x00336676:  0000      movs    r0, r0
0x00336678:  10b5      push    {r4, lr}
0x0033667a:  0004      lsls    r0, r0, #0x10
0x0033667c:  040c      lsrs    r4, r0, #0x10
0x0033667e:  000e      lsrs    r0, r0, #0x18
0x00336680:  fff7e6ff  bl      #0x336650  ; sub_00336650
0x00336684:  2406      lsls    r4, r4, #0x18
0x00336686:  011c      adds    r1, r0, #0
0x00336688:  200e      lsrs    r0, r4, #0x18
0x0033668a:  fff7e1ff  bl      #0x336650  ; sub_00336650
0x0033668e:  10bc      pop     {r4}
0x00336690:  02bc      pop     {r1}
0x00336692:  0847      bx      r1
0x00336694:  10b5      push    {r4, lr}
0x00336696:  041c      adds    r4, r0, #0
0x00336698:  000c      lsrs    r0, r0, #0x10
0x0033669a:  fff7edff  bl      #0x336678  ; sub_00336678
0x0033669e:  2404      lsls    r4, r4, #0x10
0x003366a0:  011c      adds    r1, r0, #0
0x003366a2:  200c      lsrs    r0, r4, #0x10
0x003366a4:  fff7e8ff  bl      #0x336678  ; sub_00336678
0x003366a8:  10bc      pop     {r4}
0x003366aa:  02bc      pop     {r1}
0x003366ac:  0847      bx      r1
0x003366ae:  0000      movs    r0, r0
0x003366b0:  f0b5      push    {r4, r5, r6, r7, lr}
0x003366b2:  154e      ldr     r6, [pc, #0x54]  ; =0x0035f1ec
0x003366b4:  0004      lsls    r0, r0, #0x10
0x003366b6:  3388      ldrh    r3, [r6]
0x003366b8:  0d1c      adds    r5, r1, #0
0x003366ba:  000c      lsrs    r0, r0, #0x10
0x003366bc:  0027      movs    r7, #0
0x003366be:  311c      adds    r1, r6, #0
0x003366c0:  012b      cmp     r3, #1
0x003366c2:  19d9      bls     #0x3366f8
0x003366c4:  0022      movs    r2, #0
0x003366c6:  0024      movs    r4, #0
0x003366c8:  525a      ldrh    r2, [r2, r1]
0x003366ca:  0021      movs    r1, #0
0x003366cc:  03e0      b       #0x3366d6
0x003366ce:  831a      subs    r3, r0, r2
0x003366d0:  1b04      lsls    r3, r3, #0x10
0x003366d2:  180c      lsrs    r0, r3, #0x10
0x003366d4:  0131      adds    r1, #1
0x003366d6:  9042      cmp     r0, r2
0x003366d8:  f9d2      bhs     #0x3366ce
0x003366da:  002f      cmp     r7, #0
0x003366dc:  01d1      bne     #0x3366e2
0x003366de:  0029      cmp     r1, #0
0x003366e0:  04d0      beq     #0x3366ec
0x003366e2:  0b1c      adds    r3, r1, #0
0x003366e4:  3033      adds    r3, #0x30
0x003366e6:  2b70      strb    r3, [r5]
0x003366e8:  0127      movs    r7, #1
0x003366ea:  0135      adds    r5, #1
0x003366ec:  0234      adds    r4, #2
0x003366ee:  a35b      ldrh    r3, [r4, r6]
0x003366f0:  311c      adds    r1, r6, #0
0x003366f2:  221c      adds    r2, r4, #0
0x003366f4:  012b      cmp     r3, #1
0x003366f6:  e7d8      bhi     #0x3366c8
0x003366f8:  031c      adds    r3, r0, #0
0x003366fa:  3033      adds    r3, #0x30
0x003366fc:  681c      adds    r0, r5, #1
0x003366fe:  2b70      strb    r3, [r5]
0x00336700:  f0bc      pop     {r4, r5, r6, r7}
0x00336702:  02bc      pop     {r1}
0x00336704:  0847      bx      r1
0x00336706:  0000      movs    r0, r0

===== sub_003366b0 @ 0x003366b0 =====
0x003366b0:  f0b5      push    {r4, r5, r6, r7, lr}
0x003366b2:  154e      ldr     r6, [pc, #0x54]  ; =0x0035f1ec
0x003366b4:  0004      lsls    r0, r0, #0x10
0x003366b6:  3388      ldrh    r3, [r6]
0x003366b8:  0d1c      adds    r5, r1, #0
0x003366ba:  000c      lsrs    r0, r0, #0x10
0x003366bc:  0027      movs    r7, #0
0x003366be:  311c      adds    r1, r6, #0
0x003366c0:  012b      cmp     r3, #1
0x003366c2:  19d9      bls     #0x3366f8
0x003366c4:  0022      movs    r2, #0
0x003366c6:  0024      movs    r4, #0
0x003366c8:  525a      ldrh    r2, [r2, r1]
0x003366ca:  0021      movs    r1, #0
0x003366cc:  03e0      b       #0x3366d6
0x003366ce:  831a      subs    r3, r0, r2
0x003366d0:  1b04      lsls    r3, r3, #0x10
0x003366d2:  180c      lsrs    r0, r3, #0x10
0x003366d4:  0131      adds    r1, #1
0x003366d6:  9042      cmp     r0, r2
0x003366d8:  f9d2      bhs     #0x3366ce
0x003366da:  002f      cmp     r7, #0
0x003366dc:  01d1      bne     #0x3366e2
0x003366de:  0029      cmp     r1, #0
0x003366e0:  04d0      beq     #0x3366ec
0x003366e2:  0b1c      adds    r3, r1, #0
0x003366e4:  3033      adds    r3, #0x30
0x003366e6:  2b70      strb    r3, [r5]
0x003366e8:  0127      movs    r7, #1
0x003366ea:  0135      adds    r5, #1
0x003366ec:  0234      adds    r4, #2
0x003366ee:  a35b      ldrh    r3, [r4, r6]
0x003366f0:  311c      adds    r1, r6, #0
0x003366f2:  221c      adds    r2, r4, #0
0x003366f4:  012b      cmp     r3, #1
0x003366f6:  e7d8      bhi     #0x3366c8
0x003366f8:  031c      adds    r3, r0, #0
0x003366fa:  3033      adds    r3, #0x30
0x003366fc:  681c      adds    r0, r5, #1
0x003366fe:  2b70      strb    r3, [r5]
0x00336700:  f0bc      pop     {r4, r5, r6, r7}
0x00336702:  02bc      pop     {r1}
0x00336704:  0847      bx      r1
0x00336706:  0000      movs    r0, r0

===== sub_003367ec @ 0x003367ec =====
0x003367ec:  00b5      push    {lr}
0x003367ee:  0378      ldrb    r3, [r0]
0x003367f0:  202b      cmp     r3, #0x20
0x003367f2:  01d0      beq     #0x3367f8
0x003367f4:  092b      cmp     r3, #9
0x003367f6:  01d1      bne     #0x3367fc
0x003367f8:  0130      adds    r0, #1
0x003367fa:  f8e7      b       #0x3367ee
0x003367fc:  02bc      pop     {r1}
0x003367fe:  0847      bx      r1
0x00336800:  f0b5      push    {r4, r5, r6, r7, lr}
0x00336802:  4746      mov     r7, r8
0x00336804:  80b4      push    {r7}
0x00336806:  81b0      sub     sp, #4
0x00336808:  6f46      mov     r7, sp
0x0033680a:  0237      adds    r7, #2
0x0033680c:  0023      movs    r3, #0
0x0033680e:  8046      mov     r8, r0
0x00336810:  0d1c      adds    r5, r1, #0
0x00336812:  3b80      strh    r3, [r7]
0x00336814:  041c      adds    r4, r0, #0
0x00336816:  0026      movs    r6, #0
0x00336818:  2078      ldrb    r0, [r4]
0x0033681a:  fff7c1ff  bl      #0x3367a0  ; sub_003367a0
0x0033681e:  0028      cmp     r0, #0
0x00336820:  18d1      bne     #0x336854
0x00336822:  8023      movs    r3, #0x80
0x00336824:  5b00      lsls    r3, r3, #1
0x00336826:  3b80      strh    r3, [r7]
0x00336828:  3a88      ldrh    r2, [r7]
0x0033682a:  ff2a      cmp     r2, #0xff
0x0033682c:  1ad8      bhi     #0x336864
0x0033682e:  2378      ldrb    r3, [r4]
0x00336830:  2e2b      cmp     r3, #0x2e
0x00336832:  1bd0      beq     #0x33686c
0x00336834:  2b68      ldr     r3, [r5]
0x00336836:  0136      adds    r6, #1
0x00336838:  1b02      lsls    r3, r3, #8
0x0033683a:  9b18      adds    r3, r3, r2
0x0033683c:  2b60      str     r3, [r5]
0x0033683e:  032e      cmp     r6, #3
0x00336840:  eadd      ble     #0x336818
0x00336842:  201c      adds    r0, r4, #0
0x00336844:  fff7d2ff  bl      #0x3367ec  ; sub_003367ec
0x00336848:  01b0      add     sp, #4
0x0033684a:  08bc      pop     {r3}
0x0033684c:  9846      mov     r8, r3
0x0033684e:  f0bc      pop     {r4, r5, r6, r7}
0x00336850:  02bc      pop     {r1}
0x00336852:  0847      bx      r1
0x00336854:  201c      adds    r0, r4, #0
0x00336856:  391c      adds    r1, r7, #0
0x00336858:  fff7b0ff  bl      #0x3367bc  ; sub_003367bc
0x0033685c:  3a88      ldrh    r2, [r7]
0x0033685e:  041c      adds    r4, r0, #0
0x00336860:  ff2a      cmp     r2, #0xff
0x00336862:  e4d9      bls     #0x33682e
0x00336864:  0023      movs    r3, #0
0x00336866:  4046      mov     r0, r8
0x00336868:  2b60      str     r3, [r5]
0x0033686a:  ede7      b       #0x336848
0x0033686c:  0134      adds    r4, #1
0x0033686e:  e1e7      b       #0x336834
0x00336870:  30b5      push    {r4, r5, lr}
0x00336872:  0006      lsls    r0, r0, #0x18
0x00336874:  050e      lsrs    r5, r0, #0x18
0x00336876:  0722      movs    r2, #7
0x00336878:  8020      movs    r0, #0x80
0x0033687a:  04e0      b       #0x336886
0x0033687c:  3024      movs    r4, #0x30
0x0033687e:  1c70      strb    r4, [r3]
0x00336880:  4008      lsrs    r0, r0, #1
0x00336882:  013a      subs    r2, #1
0x00336884:  08d4      bmi     #0x336898
0x00336886:  0b1c      adds    r3, r1, #0
0x00336888:  0131      adds    r1, #1
0x0033688a:  2842      tst     r0, r5
0x0033688c:  f6d0      beq     #0x33687c
0x0033688e:  3124      movs    r4, #0x31
0x00336890:  1c70      strb    r4, [r3]
0x00336892:  4008      lsrs    r0, r0, #1
0x00336894:  013a      subs    r2, #1
0x00336896:  f6d5      bpl     #0x336886
0x00336898:  081c      adds    r0, r1, #0
0x0033689a:  30bc      pop     {r4, r5}
0x0033689c:  02bc      pop     {r1}
0x0033689e:  0847      bx      r1
0x003368a0:  30b5      push    {r4, r5, lr}
0x003368a2:  0004      lsls    r0, r0, #0x10
0x003368a4:  8024      movs    r4, #0x80
0x003368a6:  050c      lsrs    r5, r0, #0x10
0x003368a8:  2402      lsls    r4, r4, #8
0x003368aa:  0f22      movs    r2, #0xf
0x003368ac:  04e0      b       #0x3368b8
0x003368ae:  3020      movs    r0, #0x30
0x003368b0:  1870      strb    r0, [r3]
0x003368b2:  6408      lsrs    r4, r4, #1
0x003368b4:  013a      subs    r2, #1
0x003368b6:  08d4      bmi     #0x3368ca
0x003368b8:  0b1c      adds    r3, r1, #0
0x003368ba:  0131      adds    r1, #1
0x003368bc:  2c42      tst     r4, r5
0x003368be:  f6d0      beq     #0x3368ae
0x003368c0:  3120      movs    r0, #0x31
0x003368c2:  1870      strb    r0, [r3]
0x003368c4:  6408      lsrs    r4, r4, #1
0x003368c6:  013a      subs    r2, #1
0x003368c8:  f6d5      bpl     #0x3368b8
0x003368ca:  081c      adds    r0, r1, #0
0x003368cc:  30bc      pop     {r4, r5}
0x003368ce:  02bc      pop     {r1}
0x003368d0:  0847      bx      r1
0x003368d2:  0000      movs    r0, r0
0x003368d4:  30b5      push    {r4, r5, lr}
0x003368d6:  8024      movs    r4, #0x80
0x003368d8:  051c      adds    r5, r0, #0
0x003368da:  2406      lsls    r4, r4, #0x18
0x003368dc:  081c      adds    r0, r1, #0
0x003368de:  1f22      movs    r2, #0x1f
0x003368e0:  04e0      b       #0x3368ec
0x003368e2:  3021      movs    r1, #0x30
0x003368e4:  1970      strb    r1, [r3]
0x003368e6:  6408      lsrs    r4, r4, #1
0x003368e8:  013a      subs    r2, #1
0x003368ea:  08d4      bmi     #0x3368fe
0x003368ec:  031c      adds    r3, r0, #0
0x003368ee:  0130      adds    r0, #1
0x003368f0:  2c42      tst     r4, r5
0x003368f2:  f6d0      beq     #0x3368e2
0x003368f4:  3121      movs    r1, #0x31
0x003368f6:  1970      strb    r1, [r3]
0x003368f8:  6408      lsrs    r4, r4, #1
0x003368fa:  013a      subs    r2, #1
0x003368fc:  f6d5      bpl     #0x3368ec
0x003368fe:  30bc      pop     {r4, r5}
0x00336900:  02bc      pop     {r1}
0x00336902:  0847      bx      r1
0x00336904:  70b5      push    {r4, r5, r6, lr}
0x00336906:  041c      adds    r4, r0, #0
0x00336908:  0e1c      adds    r6, r1, #0
0x0033690a:  0025      movs    r5, #0
0x0033690c:  05e0      b       #0x33691a
0x0033690e:  2b05      lsls    r3, r5, #0x14
0x00336910:  1d0c      lsrs    r5, r3, #0x10
0x00336912:  4319      adds    r3, r0, r5
0x00336914:  1b04      lsls    r3, r3, #0x10
0x00336916:  1d0c      lsrs    r5, r3, #0x10
0x00336918:  0134      adds    r4, #1
0x0033691a:  2078      ldrb    r0, [r4]
0x0033691c:  fff762fe  bl      #0x3365e4  ; sub_003365e4
0x00336920:  0028      cmp     r0, #0
0x00336922:  f4da      bge     #0x33690e
0x00336924:  201c      adds    r0, r4, #0
0x00336926:  3580      strh    r5, [r6]
0x00336928:  70bc      pop     {r4, r5, r6}
0x0033692a:  02bc      pop     {r1}
0x0033692c:  0847      bx      r1
0x0033692e:  0000      movs    r0, r0
0x00336930:  70b5      push    {r4, r5, r6, lr}
0x00336932:  041c      adds    r4, r0, #0
0x00336934:  0e1c      adds    r6, r1, #0
0x00336936:  0025      movs    r5, #0
0x00336938:  02e0      b       #0x336940
0x0033693a:  2d01      lsls    r5, r5, #4
0x0033693c:  2d18      adds    r5, r5, r0
0x0033693e:  0134      adds    r4, #1
0x00336940:  2078      ldrb    r0, [r4]
0x00336942:  fff74ffe  bl      #0x3365e4  ; sub_003365e4
0x00336946:  0028      cmp     r0, #0
0x00336948:  f7da      bge     #0x33693a
0x0033694a:  201c      adds    r0, r4, #0
0x0033694c:  3560      str     r5, [r6]
0x0033694e:  70bc      pop     {r4, r5, r6}
0x00336950:  02bc      pop     {r1}
0x00336952:  0847      bx      r1
0x00336954:  30b5      push    {r4, r5, lr}
0x00336956:  0d1c      adds    r5, r1, #0
0x00336958:  0a24      movs    r4, #0xa
0x0033695a:  0021      movs    r1, #0
0x0033695c:  04e0      b       #0x336968
0x0033695e:  6143      muls    r1, r4, r1
0x00336960:  5318      adds    r3, r2, r1
0x00336962:  191c      adds    r1, r3, #0
0x00336964:  3039      subs    r1, #0x30
0x00336966:  0130      adds    r0, #1
0x00336968:  0278      ldrb    r2, [r0]
0x0033696a:  131c      adds    r3, r2, #0
0x0033696c:  303b      subs    r3, #0x30
0x0033696e:  092b      cmp     r3, #9
0x00336970:  f5d9      bls     #0x33695e
0x00336972:  2960      str     r1, [r5]
0x00336974:  30bc      pop     {r4, r5}
0x00336976:  02bc      pop     {r1}
0x00336978:  0847      bx      r1
0x0033697a:  0000      movs    r0, r0
0x0033697c:  10b5      push    {r4, lr}
0x0033697e:  81b0      sub     sp, #4
0x00336980:  0006      lsls    r0, r0, #0x18
0x00336982:  6946      mov     r1, sp
0x00336984:  000e      lsrs    r0, r0, #0x18
0x00336986:  fff763fe  bl      #0x336650  ; sub_00336650
0x0033698a:  0023      movs    r3, #0
0x0033698c:  0370      strb    r3, [r0]
0x0033698e:  6846      mov     r0, sp
0x00336990:  fff7d8fd  bl      #0x336544  ; sub_00336544
0x00336994:  0220      movs    r0, #2
0x00336996:  01b0      add     sp, #4
0x00336998:  10bc      pop     {r4}
0x0033699a:  02bc      pop     {r1}
0x0033699c:  0847      bx      r1
0x0033699e:  0000      movs    r0, r0
0x003369a0:  10b5      push    {r4, lr}
0x003369a2:  82b0      sub     sp, #8
0x003369a4:  0004      lsls    r0, r0, #0x10
0x003369a6:  6946      mov     r1, sp
0x003369a8:  000c      lsrs    r0, r0, #0x10
0x003369aa:  fff765fe  bl      #0x336678  ; sub_00336678
0x003369ae:  0023      movs    r3, #0
0x003369b0:  0370      strb    r3, [r0]
0x003369b2:  6846      mov     r0, sp
0x003369b4:  fff7c6fd  bl      #0x336544  ; sub_00336544
0x003369b8:  0420      movs    r0, #4
0x003369ba:  02b0      add     sp, #8
0x003369bc:  10bc      pop     {r4}
0x003369be:  02bc      pop     {r1}
0x003369c0:  0847      bx      r1
0x003369c2:  0000      movs    r0, r0
0x003369c4:  10b5      push    {r4, lr}
0x003369c6:  83b0      sub     sp, #0xc
0x003369c8:  6946      mov     r1, sp

===== sub_003369c4 @ 0x003369c4 =====
0x003369c4:  10b5      push    {r4, lr}
0x003369c6:  83b0      sub     sp, #0xc
0x003369c8:  6946      mov     r1, sp
0x003369ca:  fff763fe  bl      #0x336694  ; sub_00336694
0x003369ce:  0023      movs    r3, #0
0x003369d0:  0370      strb    r3, [r0]
0x003369d2:  6846      mov     r0, sp
0x003369d4:  fff7b6fd  bl      #0x336544  ; sub_00336544
0x003369d8:  0820      movs    r0, #8
0x003369da:  03b0      add     sp, #0xc
0x003369dc:  10bc      pop     {r4}
0x003369de:  02bc      pop     {r1}
0x003369e0:  0847      bx      r1
0x003369e2:  0000      movs    r0, r0
0x003369e4:  10b5      push    {r4, lr}
0x003369e6:  81b0      sub     sp, #4
0x003369e8:  0006      lsls    r0, r0, #0x18
0x003369ea:  6946      mov     r1, sp
0x003369ec:  000e      lsrs    r0, r0, #0x18
0x003369ee:  fff75ffe  bl      #0x3366b0  ; sub_003366b0
0x003369f2:  0023      movs    r3, #0
0x003369f4:  0370      strb    r3, [r0]
0x003369f6:  6846      mov     r0, sp
0x003369f8:  fff7a4fd  bl      #0x336544  ; sub_00336544
0x003369fc:  6846      mov     r0, sp
0x003369fe:  fff795fd  bl      #0x33652c  ; sub_0033652c
0x00336a02:  01b0      add     sp, #4
0x00336a04:  10bc      pop     {r4}
0x00336a06:  02bc      pop     {r1}
0x00336a08:  0847      bx      r1
0x00336a0a:  0000      movs    r0, r0
0x00336a0c:  10b5      push    {r4, lr}
0x00336a0e:  82b0      sub     sp, #8
0x00336a10:  0004      lsls    r0, r0, #0x10
0x00336a12:  6946      mov     r1, sp
0x00336a14:  000c      lsrs    r0, r0, #0x10
0x00336a16:  fff74bfe  bl      #0x3366b0  ; sub_003366b0
0x00336a1a:  0023      movs    r3, #0
0x00336a1c:  0370      strb    r3, [r0]
0x00336a1e:  6846      mov     r0, sp
0x00336a20:  fff790fd  bl      #0x336544  ; sub_00336544
0x00336a24:  6846      mov     r0, sp
0x00336a26:  fff781fd  bl      #0x33652c  ; sub_0033652c
0x00336a2a:  02b0      add     sp, #8
0x00336a2c:  10bc      pop     {r4}
0x00336a2e:  02bc      pop     {r1}
0x00336a30:  0847      bx      r1
0x00336a32:  0000      movs    r0, r0
0x00336a34:  10b5      push    {r4, lr}
0x00336a36:  83b0      sub     sp, #0xc
0x00336a38:  6946      mov     r1, sp
0x00336a3a:  fff767fe  bl      #0x33670c  ; sub_0033670c
0x00336a3e:  0023      movs    r3, #0
0x00336a40:  0370      strb    r3, [r0]
0x00336a42:  6846      mov     r0, sp
0x00336a44:  fff77efd  bl      #0x336544  ; sub_00336544
0x00336a48:  6846      mov     r0, sp
0x00336a4a:  fff76ffd  bl      #0x33652c  ; sub_0033652c
0x00336a4e:  03b0      add     sp, #0xc
0x00336a50:  10bc      pop     {r4}
0x00336a52:  02bc      pop     {r1}
0x00336a54:  0847      bx      r1
0x00336a56:  0000      movs    r0, r0
0x00336a58:  10b5      push    {r4, lr}
0x00336a5a:  0b1c      adds    r3, r1, #0
0x00336a5c:  041c      adds    r4, r0, #0
0x00336a5e:  0021      movs    r1, #0
0x00336a60:  002a      cmp     r2, #0
0x00336a62:  05d0      beq     #0x336a70
0x00336a64:  082b      cmp     r3, #8
0x00336a66:  15d0      beq     #0x336a94
0x00336a68:  102b      cmp     r3, #0x10
0x00336a6a:  18d0      beq     #0x336a9e
0x00336a6c:  6442      rsbs    r4, r4, #0
0x00336a6e:  0121      movs    r1, #1
0x00336a70:  0c4a      ldr     r2, [pc, #0x30]  ; =0x0035f1c4
0x00336a72:  0020      movs    r0, #0
0x00336a74:  08ca      ldm     r2!, {r3}
0x00336a76:  a342      cmp     r3, r4
0x00336a78:  02d9      bls     #0x336a80
0x00336a7a:  0130      adds    r0, #1
0x00336a7c:  0928      cmp     r0, #9
0x00336a7e:  f9dd      ble     #0x336a74
0x00336a80:  0b1a      subs    r3, r1, r0
0x00336a82:  191c      adds    r1, r3, #0
0x00336a84:  0a31      adds    r1, #0xa
0x00336a86:  0029      cmp     r1, #0
0x00336a88:  00d1      bne     #0x336a8c
0x00336a8a:  0121      movs    r1, #1
0x00336a8c:  081c      adds    r0, r1, #0
0x00336a8e:  10bc      pop     {r4}
0x00336a90:  02bc      pop     {r1}
0x00336a92:  0847      bx      r1
0x00336a94:  044b      ldr     r3, [pc, #0x10]  ; =0xffffff00
0x00336a96:  1c43      orrs    r4, r3
0x00336a98:  6442      rsbs    r4, r4, #0
0x00336a9a:  0121      movs    r1, #1
0x00336a9c:  e8e7      b       #0x336a70
0x00336a9e:  034b      ldr     r3, [pc, #0xc]  ; =0xffff0000
0x00336aa0:  1c43      orrs    r4, r3
0x00336aa2:  f9e7      b       #0x336a98
0x00336aa4:  c4f13500  rsb.w   r0, r4, #0x35

===== sub_00336a0c @ 0x00336a0c =====
0x00336a0c:  10b5      push    {r4, lr}
0x00336a0e:  82b0      sub     sp, #8
0x00336a10:  0004      lsls    r0, r0, #0x10
0x00336a12:  6946      mov     r1, sp
0x00336a14:  000c      lsrs    r0, r0, #0x10
0x00336a16:  fff74bfe  bl      #0x3366b0  ; sub_003366b0
0x00336a1a:  0023      movs    r3, #0
0x00336a1c:  0370      strb    r3, [r0]
0x00336a1e:  6846      mov     r0, sp
0x00336a20:  fff790fd  bl      #0x336544  ; sub_00336544
0x00336a24:  6846      mov     r0, sp
0x00336a26:  fff781fd  bl      #0x33652c  ; sub_0033652c
0x00336a2a:  02b0      add     sp, #8
0x00336a2c:  10bc      pop     {r4}
0x00336a2e:  02bc      pop     {r1}
0x00336a30:  0847      bx      r1
0x00336a32:  0000      movs    r0, r0
0x00336a34:  10b5      push    {r4, lr}
0x00336a36:  83b0      sub     sp, #0xc
0x00336a38:  6946      mov     r1, sp
0x00336a3a:  fff767fe  bl      #0x33670c  ; sub_0033670c
0x00336a3e:  0023      movs    r3, #0
0x00336a40:  0370      strb    r3, [r0]
0x00336a42:  6846      mov     r0, sp
0x00336a44:  fff77efd  bl      #0x336544  ; sub_00336544
0x00336a48:  6846      mov     r0, sp
0x00336a4a:  fff76ffd  bl      #0x33652c  ; sub_0033652c
0x00336a4e:  03b0      add     sp, #0xc
0x00336a50:  10bc      pop     {r4}
0x00336a52:  02bc      pop     {r1}
0x00336a54:  0847      bx      r1
0x00336a56:  0000      movs    r0, r0
0x00336a58:  10b5      push    {r4, lr}
0x00336a5a:  0b1c      adds    r3, r1, #0
0x00336a5c:  041c      adds    r4, r0, #0
0x00336a5e:  0021      movs    r1, #0
0x00336a60:  002a      cmp     r2, #0
0x00336a62:  05d0      beq     #0x336a70
0x00336a64:  082b      cmp     r3, #8
0x00336a66:  15d0      beq     #0x336a94
0x00336a68:  102b      cmp     r3, #0x10
0x00336a6a:  18d0      beq     #0x336a9e
0x00336a6c:  6442      rsbs    r4, r4, #0
0x00336a6e:  0121      movs    r1, #1
0x00336a70:  0c4a      ldr     r2, [pc, #0x30]  ; =0x0035f1c4
0x00336a72:  0020      movs    r0, #0
0x00336a74:  08ca      ldm     r2!, {r3}
0x00336a76:  a342      cmp     r3, r4
0x00336a78:  02d9      bls     #0x336a80
0x00336a7a:  0130      adds    r0, #1
0x00336a7c:  0928      cmp     r0, #9
0x00336a7e:  f9dd      ble     #0x336a74
0x00336a80:  0b1a      subs    r3, r1, r0
0x00336a82:  191c      adds    r1, r3, #0
0x00336a84:  0a31      adds    r1, #0xa
0x00336a86:  0029      cmp     r1, #0
0x00336a88:  00d1      bne     #0x336a8c
0x00336a8a:  0121      movs    r1, #1
0x00336a8c:  081c      adds    r0, r1, #0
0x00336a8e:  10bc      pop     {r4}
0x00336a90:  02bc      pop     {r1}
0x00336a92:  0847      bx      r1
0x00336a94:  044b      ldr     r3, [pc, #0x10]  ; =0xffffff00
0x00336a96:  1c43      orrs    r4, r3
0x00336a98:  6442      rsbs    r4, r4, #0
0x00336a9a:  0121      movs    r1, #1
0x00336a9c:  e8e7      b       #0x336a70
0x00336a9e:  034b      ldr     r3, [pc, #0xc]  ; =0xffff0000
0x00336aa0:  1c43      orrs    r4, r3
0x00336aa2:  f9e7      b       #0x336a98
0x00336aa4:  c4f13500  rsb.w   r0, r4, #0x35

===== sub_00336f24 @ 0x00336f24 =====
0x00336f24:  0fb4      push    {r0, r1, r2, r3}
0x00336f26:  30b5      push    {r4, r5, lr}
0x00336f28:  94b0      sub     sp, #0x50
0x00336f2a:  17ab      add     r3, sp, #0x5c
0x00336f2c:  04cb      ldm     r3!, {r2}
0x00336f2e:  0424      movs    r4, #4
0x00336f30:  1178      ldrb    r1, [r2]
0x00336f32:  2329      cmp     r1, #0x23
0x00336f34:  26d0      beq     #0x336f84
0x00336f36:  2329      cmp     r1, #0x23
0x00336f38:  10dd      ble     #0x336f5c
0x00336f3a:  3f29      cmp     r1, #0x3f
0x00336f3c:  25d0      beq     #0x336f8a
0x00336f3e:  6846      mov     r0, sp
0x00336f40:  5021      movs    r1, #0x50
0x00336f42:  fff7b5fd  bl      #0x336ab0  ; sub_00336ab0
0x00336f46:  0023      movs    r3, #0
0x00336f48:  0370      strb    r3, [r0]
0x00336f4a:  114b      ldr     r3, [pc, #0x44]  ; =0x0035f1c2
0x00336f4c:  1b88      ldrh    r3, [r3]
0x00336f4e:  a342      cmp     r3, r4
0x00336f50:  12da      bge     #0x336f78
0x00336f52:  14b0      add     sp, #0x50
0x00336f54:  30bc      pop     {r4, r5}
0x00336f56:  08bc      pop     {r3}
0x00336f58:  04b0      add     sp, #0x10
0x00336f5a:  1847      bx      r3
0x00336f5c:  2129      cmp     r1, #0x21
0x00336f5e:  eed1      bne     #0x336f3e
0x00336f60:  0224      movs    r4, #2
0x00336f62:  0132      adds    r2, #1
0x00336f64:  6846      mov     r0, sp
0x00336f66:  5021      movs    r1, #0x50
0x00336f68:  fff7a2fd  bl      #0x336ab0  ; sub_00336ab0
0x00336f6c:  0023      movs    r3, #0
0x00336f6e:  0370      strb    r3, [r0]
0x00336f70:  074b      ldr     r3, [pc, #0x1c]  ; =0x0035f1c2
0x00336f72:  1b88      ldrh    r3, [r3]
0x00336f74:  a342      cmp     r3, r4
0x00336f76:  ecdb      blt     #0x336f52
0x00336f78:  6846      mov     r0, sp
0x00336f7a:  fff7e3fa  bl      #0x336544  ; sub_00336544
0x00336f7e:  fff7cbfa  bl      #0x336518  ; sub_00336518
0x00336f82:  e6e7      b       #0x336f52
0x00336f84:  0124      movs    r4, #1
0x00336f86:  0132      adds    r2, #1
0x00336f88:  ece7      b       #0x336f64
0x00336f8a:  0324      movs    r4, #3
0x00336f8c:  0132      adds    r2, #1
0x00336f8e:  e9e7      b       #0x336f64
0x00336f90:  c2f13500  rsb.w   r0, r2, #0x35
0x00336f94:  00b5      push    {lr}
0x00336f96:  0378      ldrb    r3, [r0]
0x00336f98:  202b      cmp     r3, #0x20
0x00336f9a:  07d0      beq     #0x336fac
0x00336f9c:  092b      cmp     r3, #9
0x00336f9e:  05d0      beq     #0x336fac
0x00336fa0:  002b      cmp     r3, #0
0x00336fa2:  03d0      beq     #0x336fac
0x00336fa4:  0130      adds    r0, #1
0x00336fa6:  0378      ldrb    r3, [r0]
0x00336fa8:  202b      cmp     r3, #0x20
0x00336faa:  f7d1      bne     #0x336f9c
0x00336fac:  02bc      pop     {r1}
0x00336fae:  0847      bx      r1
0x00336fb0:  00b5      push    {lr}
0x00336fb2:  9f22      movs    r2, #0x9f
0x00336fb4:  0006      lsls    r0, r0, #0x18
0x00336fb6:  1206      lsls    r2, r2, #0x18
0x00336fb8:  030e      lsrs    r3, r0, #0x18
0x00336fba:  8018      adds    r0, r0, r2
0x00336fbc:  000e      lsrs    r0, r0, #0x18
0x00336fbe:  1928      cmp     r0, #0x19
0x00336fc0:  02d8      bhi     #0x336fc8
0x00336fc2:  203b      subs    r3, #0x20
0x00336fc4:  1b06      lsls    r3, r3, #0x18
0x00336fc6:  1b0e      lsrs    r3, r3, #0x18
0x00336fc8:  181c      adds    r0, r3, #0
0x00336fca:  02bc      pop     {r1}
0x00336fcc:  0847      bx      r1
0x00336fce:  0000      movs    r0, r0
0x00336fd0:  10b5      push    {r4, lr}
0x00336fd2:  0378      ldrb    r3, [r0]
0x00336fd4:  041c      adds    r4, r0, #0
0x00336fd6:  1b06      lsls    r3, r3, #0x18
0x00336fd8:  002b      cmp     r3, #0
0x00336fda:  11d0      beq     #0x337000
0x00336fdc:  181c      adds    r0, r3, #0
0x00336fde:  000e      lsrs    r0, r0, #0x18
0x00336fe0:  7f28      cmp     r0, #0x7f
0x00336fe2:  10dd      ble     #0x337006
0x00336fe4:  031c      adds    r3, r0, #0
0x00336fe6:  a03b      subs    r3, #0xa0
0x00336fe8:  2070      strb    r0, [r4]
0x00336fea:  0134      adds    r4, #1
0x00336fec:  3f2b      cmp     r3, #0x3f
0x00336fee:  03d9      bls     #0x336ff8
0x00336ff0:  2078      ldrb    r0, [r4]
0x00336ff2:  0028      cmp     r0, #0
0x00336ff4:  01d0      beq     #0x336ffa
0x00336ff6:  0134      adds    r4, #1
0x00336ff8:  2078      ldrb    r0, [r4]
0x00336ffa:  0006      lsls    r0, r0, #0x18
0x00336ffc:  0028      cmp     r0, #0
0x00336ffe:  eed1      bne     #0x336fde
0x00337000:  10bc      pop     {r4}
0x00337002:  01bc      pop     {r0}
0x00337004:  0047      bx      r0
0x00337006:  fff7d3ff  bl      #0x336fb0  ; sub_00336fb0
0x0033700a:  2070      strb    r0, [r4]
0x0033700c:  0134      adds    r4, #1
0x0033700e:  f3e7      b       #0x336ff8
0x00337010:  00b5      push    {lr}
0x00337012:  bf22      movs    r2, #0xbf
0x00337014:  0006      lsls    r0, r0, #0x18
0x00337016:  1206      lsls    r2, r2, #0x18
0x00337018:  030e      lsrs    r3, r0, #0x18
0x0033701a:  8018      adds    r0, r0, r2
0x0033701c:  000e      lsrs    r0, r0, #0x18
0x0033701e:  1928      cmp     r0, #0x19
0x00337020:  02d8      bhi     #0x337028
0x00337022:  2033      adds    r3, #0x20
0x00337024:  1b06      lsls    r3, r3, #0x18
0x00337026:  1b0e      lsrs    r3, r3, #0x18
0x00337028:  181c      adds    r0, r3, #0
0x0033702a:  02bc      pop     {r1}
0x0033702c:  0847      bx      r1
0x0033702e:  0000      movs    r0, r0
0x00337030:  10b5      push    {r4, lr}
0x00337032:  0378      ldrb    r3, [r0]
0x00337034:  041c      adds    r4, r0, #0
0x00337036:  1b06      lsls    r3, r3, #0x18
0x00337038:  002b      cmp     r3, #0
0x0033703a:  11d0      beq     #0x337060
0x0033703c:  181c      adds    r0, r3, #0
0x0033703e:  000e      lsrs    r0, r0, #0x18
0x00337040:  7f28      cmp     r0, #0x7f
0x00337042:  10dd      ble     #0x337066
0x00337044:  031c      adds    r3, r0, #0
0x00337046:  a03b      subs    r3, #0xa0
0x00337048:  2070      strb    r0, [r4]
0x0033704a:  0134      adds    r4, #1
0x0033704c:  3f2b      cmp     r3, #0x3f
0x0033704e:  03d9      bls     #0x337058
0x00337050:  2078      ldrb    r0, [r4]
0x00337052:  0028      cmp     r0, #0
0x00337054:  01d0      beq     #0x33705a
0x00337056:  0134      adds    r4, #1
0x00337058:  2078      ldrb    r0, [r4]
0x0033705a:  0006      lsls    r0, r0, #0x18
0x0033705c:  0028      cmp     r0, #0
0x0033705e:  eed1      bne     #0x33703e
0x00337060:  10bc      pop     {r4}
0x00337062:  01bc      pop     {r0}
0x00337064:  0047      bx      r0
0x00337066:  fff7d3ff  bl      #0x337010  ; sub_00337010
0x0033706a:  2070      strb    r0, [r4]
0x0033706c:  0134      adds    r4, #1
0x0033706e:  f3e7      b       #0x337058
0x00337070:  00b5      push    {lr}
0x00337072:  0b78      ldrb    r3, [r1]
0x00337074:  0131      adds    r1, #1
0x00337076:  0370      strb    r3, [r0]
0x00337078:  0130      adds    r0, #1
0x0033707a:  002b      cmp     r3, #0
0x0033707c:  f9d1      bne     #0x337072
0x0033707e:  0138      subs    r0, #1
0x00337080:  02bc      pop     {r1}
0x00337082:  0847      bx      r1
0x00337084:  00b5      push    {lr}
0x00337086:  131c      adds    r3, r2, #0
0x00337088:  013a      subs    r2, #1
0x0033708a:  002b      cmp     r3, #0
0x0033708c:  08dd      ble     #0x3370a0
0x0033708e:  0b78      ldrb    r3, [r1]
0x00337090:  0131      adds    r1, #1
0x00337092:  0370      strb    r3, [r0]
0x00337094:  0130      adds    r0, #1
0x00337096:  002b      cmp     r3, #0
0x00337098:  f5d1      bne     #0x337086
0x0033709a:  0138      subs    r0, #1
0x0033709c:  02bc      pop     {r1}
0x0033709e:  0847      bx      r1
0x003370a0:  0023      movs    r3, #0
0x003370a2:  0370      strb    r3, [r0]
0x003370a4:  0130      adds    r0, #1
0x003370a6:  f8e7      b       #0x33709a
0x003370a8:  30b5      push    {r4, r5, lr}
0x003370aa:  0d1c      adds    r5, r1, #0
0x003370ac:  041c      adds    r4, r0, #0
0x003370ae:  fff73dfa  bl      #0x33652c  ; sub_0033652c
0x003370b2:  291c      adds    r1, r5, #0
0x003370b4:  2018      adds    r0, r4, r0
0x003370b6:  fff7dbff  bl      #0x337070  ; sub_00337070
0x003370ba:  30bc      pop     {r4, r5}
0x003370bc:  02bc      pop     {r1}
0x003370be:  0847      bx      r1
0x003370c0:  00b5      push    {lr}
0x003370c2:  d023      movs    r3, #0xd0
0x003370c4:  0006      lsls    r0, r0, #0x18
0x003370c6:  1b06      lsls    r3, r3, #0x18
0x003370c8:  020e      lsrs    r2, r0, #0x18
0x003370ca:  c018      adds    r0, r0, r3
0x003370cc:  000e      lsrs    r0, r0, #0x18
0x003370ce:  0021      movs    r1, #0
0x003370d0:  0928      cmp     r0, #9
0x003370d2:  05d9      bls     #0x3370e0
0x003370d4:  131c      adds    r3, r2, #0
0x003370d6:  413b      subs    r3, #0x41
0x003370d8:  1b06      lsls    r3, r3, #0x18
0x003370da:  1b0e      lsrs    r3, r3, #0x18
0x003370dc:  052b      cmp     r3, #5
0x003370de:  03d8      bhi     #0x3370e8
0x003370e0:  0121      movs    r1, #1
0x003370e2:  081c      adds    r0, r1, #0
0x003370e4:  02bc      pop     {r1}
0x003370e6:  0847      bx      r1
0x003370e8:  131c      adds    r3, r2, #0
0x003370ea:  613b      subs    r3, #0x61
0x003370ec:  1b06      lsls    r3, r3, #0x18
0x003370ee:  1b0e      lsrs    r3, r3, #0x18
0x003370f0:  052b      cmp     r3, #5
0x003370f2:  f6d8      bhi     #0x3370e2
0x003370f4:  f4e7      b       #0x3370e0
0x003370f6:  0000      movs    r0, r0
0x003370f8:  0006      lsls    r0, r0, #0x18
0x003370fa:  000e      lsrs    r0, r0, #0x18
0x003370fc:  3038      subs    r0, #0x30
0x003370fe:  7047      bx      lr

===== sub_00337070 @ 0x00337070 =====
0x00337070:  00b5      push    {lr}
0x00337072:  0b78      ldrb    r3, [r1]
0x00337074:  0131      adds    r1, #1
0x00337076:  0370      strb    r3, [r0]
0x00337078:  0130      adds    r0, #1
0x0033707a:  002b      cmp     r3, #0
0x0033707c:  f9d1      bne     #0x337072
0x0033707e:  0138      subs    r0, #1
0x00337080:  02bc      pop     {r1}
0x00337082:  0847      bx      r1
0x00337084:  00b5      push    {lr}
0x00337086:  131c      adds    r3, r2, #0
0x00337088:  013a      subs    r2, #1
0x0033708a:  002b      cmp     r3, #0
0x0033708c:  08dd      ble     #0x3370a0
0x0033708e:  0b78      ldrb    r3, [r1]
0x00337090:  0131      adds    r1, #1
0x00337092:  0370      strb    r3, [r0]
0x00337094:  0130      adds    r0, #1
0x00337096:  002b      cmp     r3, #0
0x00337098:  f5d1      bne     #0x337086
0x0033709a:  0138      subs    r0, #1
0x0033709c:  02bc      pop     {r1}
0x0033709e:  0847      bx      r1
0x003370a0:  0023      movs    r3, #0
0x003370a2:  0370      strb    r3, [r0]
0x003370a4:  0130      adds    r0, #1
0x003370a6:  f8e7      b       #0x33709a
0x003370a8:  30b5      push    {r4, r5, lr}
0x003370aa:  0d1c      adds    r5, r1, #0
0x003370ac:  041c      adds    r4, r0, #0
0x003370ae:  fff73dfa  bl      #0x33652c  ; sub_0033652c
0x003370b2:  291c      adds    r1, r5, #0
0x003370b4:  2018      adds    r0, r4, r0
0x003370b6:  fff7dbff  bl      #0x337070  ; sub_00337070
0x003370ba:  30bc      pop     {r4, r5}
0x003370bc:  02bc      pop     {r1}
0x003370be:  0847      bx      r1
0x003370c0:  00b5      push    {lr}
0x003370c2:  d023      movs    r3, #0xd0
0x003370c4:  0006      lsls    r0, r0, #0x18
0x003370c6:  1b06      lsls    r3, r3, #0x18
0x003370c8:  020e      lsrs    r2, r0, #0x18
0x003370ca:  c018      adds    r0, r0, r3
0x003370cc:  000e      lsrs    r0, r0, #0x18
0x003370ce:  0021      movs    r1, #0
0x003370d0:  0928      cmp     r0, #9
0x003370d2:  05d9      bls     #0x3370e0
0x003370d4:  131c      adds    r3, r2, #0
0x003370d6:  413b      subs    r3, #0x41
0x003370d8:  1b06      lsls    r3, r3, #0x18
0x003370da:  1b0e      lsrs    r3, r3, #0x18
0x003370dc:  052b      cmp     r3, #5
0x003370de:  03d8      bhi     #0x3370e8
0x003370e0:  0121      movs    r1, #1
0x003370e2:  081c      adds    r0, r1, #0
0x003370e4:  02bc      pop     {r1}
0x003370e6:  0847      bx      r1
0x003370e8:  131c      adds    r3, r2, #0
0x003370ea:  613b      subs    r3, #0x61
0x003370ec:  1b06      lsls    r3, r3, #0x18
0x003370ee:  1b0e      lsrs    r3, r3, #0x18
0x003370f0:  052b      cmp     r3, #5
0x003370f2:  f6d8      bhi     #0x3370e2
0x003370f4:  f4e7      b       #0x3370e0
0x003370f6:  0000      movs    r0, r0
0x003370f8:  0006      lsls    r0, r0, #0x18
0x003370fa:  000e      lsrs    r0, r0, #0x18
0x003370fc:  3038      subs    r0, #0x30
0x003370fe:  7047      bx      lr

===== sub_003370a8 @ 0x003370a8 =====
0x003370a8:  30b5      push    {r4, r5, lr}
0x003370aa:  0d1c      adds    r5, r1, #0
0x003370ac:  041c      adds    r4, r0, #0
0x003370ae:  fff73dfa  bl      #0x33652c  ; sub_0033652c
0x003370b2:  291c      adds    r1, r5, #0
0x003370b4:  2018      adds    r0, r4, r0
0x003370b6:  fff7dbff  bl      #0x337070  ; sub_00337070
0x003370ba:  30bc      pop     {r4, r5}
0x003370bc:  02bc      pop     {r1}
0x003370be:  0847      bx      r1
0x003370c0:  00b5      push    {lr}
0x003370c2:  d023      movs    r3, #0xd0
0x003370c4:  0006      lsls    r0, r0, #0x18
0x003370c6:  1b06      lsls    r3, r3, #0x18
0x003370c8:  020e      lsrs    r2, r0, #0x18
0x003370ca:  c018      adds    r0, r0, r3
0x003370cc:  000e      lsrs    r0, r0, #0x18
0x003370ce:  0021      movs    r1, #0
0x003370d0:  0928      cmp     r0, #9
0x003370d2:  05d9      bls     #0x3370e0
0x003370d4:  131c      adds    r3, r2, #0
0x003370d6:  413b      subs    r3, #0x41
0x003370d8:  1b06      lsls    r3, r3, #0x18
0x003370da:  1b0e      lsrs    r3, r3, #0x18
0x003370dc:  052b      cmp     r3, #5
0x003370de:  03d8      bhi     #0x3370e8
0x003370e0:  0121      movs    r1, #1
0x003370e2:  081c      adds    r0, r1, #0
0x003370e4:  02bc      pop     {r1}
0x003370e6:  0847      bx      r1
0x003370e8:  131c      adds    r3, r2, #0
0x003370ea:  613b      subs    r3, #0x61
0x003370ec:  1b06      lsls    r3, r3, #0x18
0x003370ee:  1b0e      lsrs    r3, r3, #0x18
0x003370f0:  052b      cmp     r3, #5
0x003370f2:  f6d8      bhi     #0x3370e2
0x003370f4:  f4e7      b       #0x3370e0
0x003370f6:  0000      movs    r0, r0
0x003370f8:  0006      lsls    r0, r0, #0x18
0x003370fa:  000e      lsrs    r0, r0, #0x18
0x003370fc:  3038      subs    r0, #0x30
0x003370fe:  7047      bx      lr

===== sub_0033711c @ 0x0033711c =====
0x0033711c:  00b5      push    {lr}
0x0033711e:  0278      ldrb    r2, [r0]
0x00337120:  0b78      ldrb    r3, [r1]
0x00337122:  0130      adds    r0, #1
0x00337124:  0131      adds    r1, #1
0x00337126:  002a      cmp     r2, #0
0x00337128:  01d1      bne     #0x33712e
0x0033712a:  002b      cmp     r3, #0
0x0033712c:  06d0      beq     #0x33713c
0x0033712e:  9a42      cmp     r2, r3
0x00337130:  f5d0      beq     #0x33711e
0x00337132:  9a42      cmp     r2, r3
0x00337134:  04d9      bls     #0x337140
0x00337136:  0120      movs    r0, #1
0x00337138:  02bc      pop     {r1}
0x0033713a:  0847      bx      r1
0x0033713c:  0020      movs    r0, #0
0x0033713e:  fbe7      b       #0x337138
0x00337140:  0120      movs    r0, #1
0x00337142:  4042      rsbs    r0, r0, #0
0x00337144:  f8e7      b       #0x337138
0x00337146:  0000      movs    r0, r0
0x00337148:  70b5      push    {r4, r5, r6, lr}
0x0033714a:  061c      adds    r6, r0, #0
0x0033714c:  0d1c      adds    r5, r1, #0
0x0033714e:  3078      ldrb    r0, [r6]
0x00337150:  fff72eff  bl      #0x336fb0  ; sub_00336fb0
0x00337154:  0006      lsls    r0, r0, #0x18
0x00337156:  040e      lsrs    r4, r0, #0x18
0x00337158:  2878      ldrb    r0, [r5]
0x0033715a:  fff729ff  bl      #0x336fb0  ; sub_00336fb0
0x0033715e:  0006      lsls    r0, r0, #0x18
0x00337160:  0136      adds    r6, #1
0x00337162:  0135      adds    r5, #1
0x00337164:  000e      lsrs    r0, r0, #0x18
0x00337166:  002c      cmp     r4, #0
0x00337168:  01d1      bne     #0x33716e
0x0033716a:  0028      cmp     r0, #0
0x0033716c:  07d0      beq     #0x33717e
0x0033716e:  8442      cmp     r4, r0
0x00337170:  edd0      beq     #0x33714e
0x00337172:  8442      cmp     r4, r0
0x00337174:  05d9      bls     #0x337182
0x00337176:  0120      movs    r0, #1
0x00337178:  70bc      pop     {r4, r5, r6}
0x0033717a:  02bc      pop     {r1}
0x0033717c:  0847      bx      r1
0x0033717e:  0020      movs    r0, #0
0x00337180:  fae7      b       #0x337178
0x00337182:  0120      movs    r0, #1
0x00337184:  4042      rsbs    r0, r0, #0
0x00337186:  f7e7      b       #0x337178
0x00337188:  10b5      push    {r4, lr}
0x0033718a:  041c      adds    r4, r0, #0
0x0033718c:  081c      adds    r0, r1, #0
0x0033718e:  111c      adds    r1, r2, #0
0x00337190:  0b1c      adds    r3, r1, #0
0x00337192:  0139      subs    r1, #1
0x00337194:  002b      cmp     r3, #0
0x00337196:  0fdd      ble     #0x3371b8
0x00337198:  2278      ldrb    r2, [r4]
0x0033719a:  0378      ldrb    r3, [r0]
0x0033719c:  0134      adds    r4, #1
0x0033719e:  0130      adds    r0, #1
0x003371a0:  002a      cmp     r2, #0
0x003371a2:  01d1      bne     #0x3371a8
0x003371a4:  002b      cmp     r3, #0
0x003371a6:  07d0      beq     #0x3371b8
0x003371a8:  9a42      cmp     r2, r3
0x003371aa:  f1d0      beq     #0x337190
0x003371ac:  9a42      cmp     r2, r3
0x003371ae:  05d9      bls     #0x3371bc
0x003371b0:  0120      movs    r0, #1
0x003371b2:  10bc      pop     {r4}
0x003371b4:  02bc      pop     {r1}
0x003371b6:  0847      bx      r1
0x003371b8:  0020      movs    r0, #0
0x003371ba:  fae7      b       #0x3371b2
0x003371bc:  0120      movs    r0, #1
0x003371be:  4042      rsbs    r0, r0, #0
0x003371c0:  f7e7      b       #0x3371b2
0x003371c2:  0000      movs    r0, r0
0x003371c4:  f0b5      push    {r4, r5, r6, r7, lr}
0x003371c6:  071c      adds    r7, r0, #0
0x003371c8:  0e1c      adds    r6, r1, #0
0x003371ca:  151c      adds    r5, r2, #0
0x003371cc:  2b1c      adds    r3, r5, #0
0x003371ce:  013d      subs    r5, #1
0x003371d0:  002b      cmp     r3, #0
0x003371d2:  17dd      ble     #0x337204
0x003371d4:  3878      ldrb    r0, [r7]
0x003371d6:  fff7ebfe  bl      #0x336fb0  ; sub_00336fb0
0x003371da:  0006      lsls    r0, r0, #0x18
0x003371dc:  040e      lsrs    r4, r0, #0x18
0x003371de:  3078      ldrb    r0, [r6]
0x003371e0:  fff7e6fe  bl      #0x336fb0  ; sub_00336fb0
0x003371e4:  0006      lsls    r0, r0, #0x18
0x003371e6:  0137      adds    r7, #1
0x003371e8:  0136      adds    r6, #1
0x003371ea:  000e      lsrs    r0, r0, #0x18
0x003371ec:  002c      cmp     r4, #0
0x003371ee:  01d1      bne     #0x3371f4
0x003371f0:  0028      cmp     r0, #0
0x003371f2:  07d0      beq     #0x337204
0x003371f4:  8442      cmp     r4, r0
0x003371f6:  e9d0      beq     #0x3371cc
0x003371f8:  8442      cmp     r4, r0
0x003371fa:  05d9      bls     #0x337208
0x003371fc:  0120      movs    r0, #1
0x003371fe:  f0bc      pop     {r4, r5, r6, r7}
0x00337200:  02bc      pop     {r1}
0x00337202:  0847      bx      r1
0x00337204:  0020      movs    r0, #0
0x00337206:  fae7      b       #0x3371fe
0x00337208:  0120      movs    r0, #1
0x0033720a:  4042      rsbs    r0, r0, #0
0x0033720c:  f7e7      b       #0x3371fe
0x0033720e:  0000      movs    r0, r0
0x00337210:  00b5      push    {lr}
0x00337212:  0906      lsls    r1, r1, #0x18
0x00337214:  090e      lsrs    r1, r1, #0x18
0x00337216:  03e0      b       #0x337220
0x00337218:  1b0e      lsrs    r3, r3, #0x18
0x0033721a:  8b42      cmp     r3, r1
0x0033721c:  05d0      beq     #0x33722a
0x0033721e:  0130      adds    r0, #1
0x00337220:  0378      ldrb    r3, [r0]
0x00337222:  1b06      lsls    r3, r3, #0x18
0x00337224:  002b      cmp     r3, #0
0x00337226:  f7d1      bne     #0x337218
0x00337228:  0020      movs    r0, #0
0x0033722a:  02bc      pop     {r1}
0x0033722c:  0847      bx      r1
0x0033722e:  0000      movs    r0, r0
0x00337230:  30b5      push    {r4, r5, lr}
0x00337232:  0278      ldrb    r2, [r0]
0x00337234:  0d1c      adds    r5, r1, #0
0x00337236:  041c      adds    r4, r0, #0
0x00337238:  0ee0      b       #0x337258
0x0033723a:  201c      adds    r0, r4, #0
0x0033723c:  fff742f8  bl      #0x3362c4  ; sub_003362c4
0x00337240:  0004      lsls    r0, r0, #0x10
0x00337242:  000c      lsrs    r0, r0, #0x10
0x00337244:  a842      cmp     r0, r5
0x00337246:  1bd0      beq     #0x337280
0x00337248:  0234      adds    r4, #2
0x0033724a:  2278      ldrb    r2, [r4]
0x0033724c:  002a      cmp     r2, #0
0x0033724e:  17d0      beq     #0x337280
0x00337250:  631e      subs    r3, r4, #1
0x00337252:  1b78      ldrb    r3, [r3]
0x00337254:  002b      cmp     r3, #0
0x00337256:  13d0      beq     #0x337280
0x00337258:  131c      adds    r3, r2, #0
0x0033725a:  7f33      adds    r3, #0x7f
0x0033725c:  1b06      lsls    r3, r3, #0x18
0x0033725e:  1b0e      lsrs    r3, r3, #0x18
0x00337260:  1e2b      cmp     r3, #0x1e
0x00337262:  ead9      bls     #0x33723a
0x00337264:  131c      adds    r3, r2, #0
0x00337266:  2033      adds    r3, #0x20
0x00337268:  1b06      lsls    r3, r3, #0x18
0x0033726a:  1b0e      lsrs    r3, r3, #0x18
0x0033726c:  1c2b      cmp     r3, #0x1c
0x0033726e:  e4d9      bls     #0x33723a
0x00337270:  1306      lsls    r3, r2, #0x18
0x00337272:  1b0e      lsrs    r3, r3, #0x18
0x00337274:  ab42      cmp     r3, r5
0x00337276:  03d0      beq     #0x337280
0x00337278:  0134      adds    r4, #1
0x0033727a:  2278      ldrb    r2, [r4]
0x0033727c:  002a      cmp     r2, #0
0x0033727e:  e7d1      bne     #0x337250
0x00337280:  201c      adds    r0, r4, #0
0x00337282:  30bc      pop     {r4, r5}
0x00337284:  02bc      pop     {r1}
0x00337286:  0847      bx      r1
0x00337288:  30b5      push    {r4, r5, lr}
0x0033728a:  051c      adds    r5, r0, #0
0x0033728c:  081c      adds    r0, r1, #0
0x0033728e:  0c1c      adds    r4, r1, #0
0x00337290:  fff74cf9  bl      #0x33652c  ; sub_0033652c
0x00337294:  ff28      cmp     r0, #0xff
0x00337296:  00dd      ble     #0x33729a
0x00337298:  ff20      movs    r0, #0xff
0x0033729a:  2870      strb    r0, [r5]
0x0033729c:  0135      adds    r5, #1
0x0033729e:  0028      cmp     r0, #0
0x003372a0:  07dd      ble     #0x3372b2
0x003372a2:  021c      adds    r2, r0, #0
0x003372a4:  2378      ldrb    r3, [r4]
0x003372a6:  013a      subs    r2, #1
0x003372a8:  2b70      strb    r3, [r5]
0x003372aa:  0134      adds    r4, #1
0x003372ac:  0135      adds    r5, #1
0x003372ae:  002a      cmp     r2, #0
0x003372b0:  f8d1      bne     #0x3372a4
0x003372b2:  30bc      pop     {r4, r5}
0x003372b4:  02bc      pop     {r1}
0x003372b6:  0847      bx      r1
0x003372b8:  10b5      push    {r4, lr}
0x003372ba:  0c78      ldrb    r4, [r1]
0x003372bc:  0131      adds    r1, #1
0x003372be:  002c      cmp     r4, #0
0x003372c0:  07dd      ble     #0x3372d2
0x003372c2:  221c      adds    r2, r4, #0
0x003372c4:  0b78      ldrb    r3, [r1]
0x003372c6:  013a      subs    r2, #1
0x003372c8:  0370      strb    r3, [r0]
0x003372ca:  0131      adds    r1, #1
0x003372cc:  0130      adds    r0, #1
0x003372ce:  002a      cmp     r2, #0
0x003372d0:  f8d1      bne     #0x3372c4
0x003372d2:  0023      movs    r3, #0
0x003372d4:  0370      strb    r3, [r0]
0x003372d6:  201c      adds    r0, r4, #0
0x003372d8:  10bc      pop     {r4}
0x003372da:  02bc      pop     {r1}
0x003372dc:  0847      bx      r1
0x003372de:  0000      movs    r0, r0
0x003372e0:  f0b5      push    {r4, r5, r6, r7, lr}
0x003372e2:  4746      mov     r7, r8
0x003372e4:  80b4      push    {r7}
0x003372e6:  8846      mov     r8, r1
0x003372e8:  141c      adds    r4, r2, #0
0x003372ea:  061c      adds    r6, r0, #0
0x003372ec:  fff71ef9  bl      #0x33652c  ; sub_0033652c
0x003372f0:  051c      adds    r5, r0, #0
0x003372f2:  4046      mov     r0, r8
0x003372f4:  fff71af9  bl      #0x33652c  ; sub_0033652c
0x003372f8:  071c      adds    r7, r0, #0
0x003372fa:  002c      cmp     r4, #0

===== sub_003371c4 @ 0x003371c4 =====
0x003371c4:  f0b5      push    {r4, r5, r6, r7, lr}
0x003371c6:  071c      adds    r7, r0, #0
0x003371c8:  0e1c      adds    r6, r1, #0
0x003371ca:  151c      adds    r5, r2, #0
0x003371cc:  2b1c      adds    r3, r5, #0
0x003371ce:  013d      subs    r5, #1
0x003371d0:  002b      cmp     r3, #0
0x003371d2:  17dd      ble     #0x337204
0x003371d4:  3878      ldrb    r0, [r7]
0x003371d6:  fff7ebfe  bl      #0x336fb0  ; sub_00336fb0
0x003371da:  0006      lsls    r0, r0, #0x18
0x003371dc:  040e      lsrs    r4, r0, #0x18
0x003371de:  3078      ldrb    r0, [r6]
0x003371e0:  fff7e6fe  bl      #0x336fb0  ; sub_00336fb0
0x003371e4:  0006      lsls    r0, r0, #0x18
0x003371e6:  0137      adds    r7, #1
0x003371e8:  0136      adds    r6, #1
0x003371ea:  000e      lsrs    r0, r0, #0x18
0x003371ec:  002c      cmp     r4, #0
0x003371ee:  01d1      bne     #0x3371f4
0x003371f0:  0028      cmp     r0, #0
0x003371f2:  07d0      beq     #0x337204
0x003371f4:  8442      cmp     r4, r0
0x003371f6:  e9d0      beq     #0x3371cc
0x003371f8:  8442      cmp     r4, r0
0x003371fa:  05d9      bls     #0x337208
0x003371fc:  0120      movs    r0, #1
0x003371fe:  f0bc      pop     {r4, r5, r6, r7}
0x00337200:  02bc      pop     {r1}
0x00337202:  0847      bx      r1
0x00337204:  0020      movs    r0, #0
0x00337206:  fae7      b       #0x3371fe
0x00337208:  0120      movs    r0, #1
0x0033720a:  4042      rsbs    r0, r0, #0
0x0033720c:  f7e7      b       #0x3371fe
0x0033720e:  0000      movs    r0, r0
0x00337210:  00b5      push    {lr}
0x00337212:  0906      lsls    r1, r1, #0x18
0x00337214:  090e      lsrs    r1, r1, #0x18
0x00337216:  03e0      b       #0x337220
0x00337218:  1b0e      lsrs    r3, r3, #0x18
0x0033721a:  8b42      cmp     r3, r1
0x0033721c:  05d0      beq     #0x33722a
0x0033721e:  0130      adds    r0, #1
0x00337220:  0378      ldrb    r3, [r0]
0x00337222:  1b06      lsls    r3, r3, #0x18
0x00337224:  002b      cmp     r3, #0
0x00337226:  f7d1      bne     #0x337218
0x00337228:  0020      movs    r0, #0
0x0033722a:  02bc      pop     {r1}
0x0033722c:  0847      bx      r1
0x0033722e:  0000      movs    r0, r0
0x00337230:  30b5      push    {r4, r5, lr}
0x00337232:  0278      ldrb    r2, [r0]
0x00337234:  0d1c      adds    r5, r1, #0
0x00337236:  041c      adds    r4, r0, #0
0x00337238:  0ee0      b       #0x337258
0x0033723a:  201c      adds    r0, r4, #0
0x0033723c:  fff742f8  bl      #0x3362c4  ; sub_003362c4
0x00337240:  0004      lsls    r0, r0, #0x10
0x00337242:  000c      lsrs    r0, r0, #0x10
0x00337244:  a842      cmp     r0, r5
0x00337246:  1bd0      beq     #0x337280
0x00337248:  0234      adds    r4, #2
0x0033724a:  2278      ldrb    r2, [r4]
0x0033724c:  002a      cmp     r2, #0
0x0033724e:  17d0      beq     #0x337280
0x00337250:  631e      subs    r3, r4, #1
0x00337252:  1b78      ldrb    r3, [r3]
0x00337254:  002b      cmp     r3, #0
0x00337256:  13d0      beq     #0x337280
0x00337258:  131c      adds    r3, r2, #0
0x0033725a:  7f33      adds    r3, #0x7f
0x0033725c:  1b06      lsls    r3, r3, #0x18
0x0033725e:  1b0e      lsrs    r3, r3, #0x18
0x00337260:  1e2b      cmp     r3, #0x1e
0x00337262:  ead9      bls     #0x33723a
0x00337264:  131c      adds    r3, r2, #0
0x00337266:  2033      adds    r3, #0x20
0x00337268:  1b06      lsls    r3, r3, #0x18
0x0033726a:  1b0e      lsrs    r3, r3, #0x18
0x0033726c:  1c2b      cmp     r3, #0x1c
0x0033726e:  e4d9      bls     #0x33723a
0x00337270:  1306      lsls    r3, r2, #0x18
0x00337272:  1b0e      lsrs    r3, r3, #0x18
0x00337274:  ab42      cmp     r3, r5
0x00337276:  03d0      beq     #0x337280
0x00337278:  0134      adds    r4, #1
0x0033727a:  2278      ldrb    r2, [r4]
0x0033727c:  002a      cmp     r2, #0
0x0033727e:  e7d1      bne     #0x337250
0x00337280:  201c      adds    r0, r4, #0
0x00337282:  30bc      pop     {r4, r5}
0x00337284:  02bc      pop     {r1}
0x00337286:  0847      bx      r1
0x00337288:  30b5      push    {r4, r5, lr}
0x0033728a:  051c      adds    r5, r0, #0
0x0033728c:  081c      adds    r0, r1, #0
0x0033728e:  0c1c      adds    r4, r1, #0
0x00337290:  fff74cf9  bl      #0x33652c  ; sub_0033652c
0x00337294:  ff28      cmp     r0, #0xff
0x00337296:  00dd      ble     #0x33729a
0x00337298:  ff20      movs    r0, #0xff
0x0033729a:  2870      strb    r0, [r5]
0x0033729c:  0135      adds    r5, #1
0x0033729e:  0028      cmp     r0, #0
0x003372a0:  07dd      ble     #0x3372b2
0x003372a2:  021c      adds    r2, r0, #0
0x003372a4:  2378      ldrb    r3, [r4]
0x003372a6:  013a      subs    r2, #1
0x003372a8:  2b70      strb    r3, [r5]
0x003372aa:  0134      adds    r4, #1
0x003372ac:  0135      adds    r5, #1
0x003372ae:  002a      cmp     r2, #0
0x003372b0:  f8d1      bne     #0x3372a4
0x003372b2:  30bc      pop     {r4, r5}
0x003372b4:  02bc      pop     {r1}
0x003372b6:  0847      bx      r1
0x003372b8:  10b5      push    {r4, lr}
0x003372ba:  0c78      ldrb    r4, [r1]
0x003372bc:  0131      adds    r1, #1
0x003372be:  002c      cmp     r4, #0
0x003372c0:  07dd      ble     #0x3372d2
0x003372c2:  221c      adds    r2, r4, #0
0x003372c4:  0b78      ldrb    r3, [r1]
0x003372c6:  013a      subs    r2, #1
0x003372c8:  0370      strb    r3, [r0]
0x003372ca:  0131      adds    r1, #1
0x003372cc:  0130      adds    r0, #1
0x003372ce:  002a      cmp     r2, #0
0x003372d0:  f8d1      bne     #0x3372c4
0x003372d2:  0023      movs    r3, #0
0x003372d4:  0370      strb    r3, [r0]
0x003372d6:  201c      adds    r0, r4, #0
0x003372d8:  10bc      pop     {r4}
0x003372da:  02bc      pop     {r1}
0x003372dc:  0847      bx      r1
0x003372de:  0000      movs    r0, r0
0x003372e0:  f0b5      push    {r4, r5, r6, r7, lr}
0x003372e2:  4746      mov     r7, r8
0x003372e4:  80b4      push    {r7}
0x003372e6:  8846      mov     r8, r1
0x003372e8:  141c      adds    r4, r2, #0
0x003372ea:  061c      adds    r6, r0, #0
0x003372ec:  fff71ef9  bl      #0x33652c  ; sub_0033652c
0x003372f0:  051c      adds    r5, r0, #0
0x003372f2:  4046      mov     r0, r8
0x003372f4:  fff71af9  bl      #0x33652c  ; sub_0033652c
0x003372f8:  071c      adds    r7, r0, #0
0x003372fa:  002c      cmp     r4, #0
0x003372fc:  12d0      beq     #0x337324
0x003372fe:  bd42      cmp     r5, r7
0x00337300:  0adb      blt     #0x337318
0x00337302:  301c      adds    r0, r6, #0
0x00337304:  4146      mov     r1, r8
0x00337306:  3a1c      adds    r2, r7, #0
0x00337308:  fff75cff  bl      #0x3371c4  ; sub_003371c4
0x0033730c:  0028      cmp     r0, #0
0x0033730e:  17d0      beq     #0x337340
0x00337310:  0136      adds    r6, #1
0x00337312:  013d      subs    r5, #1
0x00337314:  bd42      cmp     r5, r7
0x00337316:  f4da      bge     #0x337302
0x00337318:  0020      movs    r0, #0
0x0033731a:  08bc      pop     {r3}
0x0033731c:  9846      mov     r8, r3
0x0033731e:  f0bc      pop     {r4, r5, r6, r7}
0x00337320:  02bc      pop     {r1}
0x00337322:  0847      bx      r1
0x00337324:  bd42      cmp     r5, r7
0x00337326:  f7db      blt     #0x337318
0x00337328:  301c      adds    r0, r6, #0
0x0033732a:  4146      mov     r1, r8
0x0033732c:  3a1c      adds    r2, r7, #0
0x0033732e:  fff72bff  bl      #0x337188  ; sub_00337188
0x00337332:  0028      cmp     r0, #0
0x00337334:  04d0      beq     #0x337340
0x00337336:  0136      adds    r6, #1
0x00337338:  013d      subs    r5, #1
0x0033733a:  bd42      cmp     r5, r7
0x0033733c:  f4da      bge     #0x337328
0x0033733e:  ebe7      b       #0x337318
0x00337340:  301c      adds    r0, r6, #0
0x00337342:  eae7      b       #0x33731a
0x00337344:  f0b5      push    {r4, r5, r6, r7, lr}
0x00337346:  051c      adds    r5, r0, #0
0x00337348:  0f1c      adds    r7, r1, #0
0x0033734a:  0026      movs    r6, #0
0x0033734c:  002a      cmp     r2, #0
0x0033734e:  15d0      beq     #0x33737c
0x00337350:  0368      ldr     r3, [r0]
0x00337352:  002b      cmp     r3, #0
0x00337354:  0dd0      beq     #0x337372
0x00337356:  0022      movs    r2, #0
0x00337358:  0024      movs    r4, #0
0x0033735a:  5059      ldr     r0, [r2, r5]
0x0033735c:  391c      adds    r1, r7, #0
0x0033735e:  fff7f3fe  bl      #0x337148  ; sub_00337148
0x00337362:  0028      cmp     r0, #0
0x00337364:  21d0      beq     #0x3373aa
0x00337366:  0434      adds    r4, #4
0x00337368:  6359      ldr     r3, [r4, r5]
0x0033736a:  0136      adds    r6, #1
0x0033736c:  221c      adds    r2, r4, #0
0x0033736e:  002b      cmp     r3, #0
0x00337370:  f3d1      bne     #0x33735a
0x00337372:  0120      movs    r0, #1
0x00337374:  4042      rsbs    r0, r0, #0
0x00337376:  f0bc      pop     {r4, r5, r6, r7}
0x00337378:  02bc      pop     {r1}
0x0033737a:  0847      bx      r1
0x0033737c:  0368      ldr     r3, [r0]
0x0033737e:  002b      cmp     r3, #0
0x00337380:  f7d0      beq     #0x337372
0x00337382:  0022      movs    r2, #0
0x00337384:  0024      movs    r4, #0
0x00337386:  5059      ldr     r0, [r2, r5]
0x00337388:  391c      adds    r1, r7, #0
0x0033738a:  fff7c7fe  bl      #0x33711c  ; sub_0033711c
0x0033738e:  0028      cmp     r0, #0
0x00337390:  0bd0      beq     #0x3373aa
0x00337392:  0434      adds    r4, #4
0x00337394:  6359      ldr     r3, [r4, r5]
0x00337396:  0136      adds    r6, #1
0x00337398:  221c      adds    r2, r4, #0
0x0033739a:  002b      cmp     r3, #0
0x0033739c:  e9d0      beq     #0x337372
0x0033739e:  5059      ldr     r0, [r2, r5]
0x003373a0:  391c      adds    r1, r7, #0

===== sub_003373e8 @ 0x003373e8 =====
0x003373e8:  0023      movs    r3, #0
0x003373ea:  0360      str     r3, [r0]
0x003373ec:  4360      str     r3, [r0, #4]
0x003373ee:  8160      str     r1, [r0, #8]
0x003373f0:  7047      bx      lr

===== sub_00337428 @ 0x00337428 =====
0x00337428:  00b5      push    {lr}
0x0033742a:  0023      movs    r3, #0
0x0033742c:  0b60      str     r3, [r1]
0x0033742e:  0368      ldr     r3, [r0]
0x00337430:  002b      cmp     r3, #0
0x00337432:  03d1      bne     #0x33743c
0x00337434:  4b60      str     r3, [r1, #4]
0x00337436:  0160      str     r1, [r0]
0x00337438:  01bc      pop     {r0}
0x0033743a:  0047      bx      r0
0x0033743c:  1a1c      adds    r2, r3, #0
0x0033743e:  1b68      ldr     r3, [r3]
0x00337440:  002b      cmp     r3, #0
0x00337442:  fbd1      bne     #0x33743c
0x00337444:  1160      str     r1, [r2]
0x00337446:  4a60      str     r2, [r1, #4]
0x00337448:  f6e7      b       #0x337438
0x0033744a:  0000      movs    r0, r0
0x0033744c:  10b5      push    {r4, lr}
0x0033744e:  041c      adds    r4, r0, #0
0x00337450:  2368      ldr     r3, [r4]
0x00337452:  081c      adds    r0, r1, #0
0x00337454:  111c      adds    r1, r2, #0
0x00337456:  002b      cmp     r3, #0
0x00337458:  15d0      beq     #0x337486
0x0033745a:  0b68      ldr     r3, [r1]
0x0033745c:  01e0      b       #0x337462
0x0033745e:  1a1c      adds    r2, r3, #0
0x00337460:  1b68      ldr     r3, [r3]
0x00337462:  002b      cmp     r3, #0
0x00337464:  fbd1      bne     #0x33745e
0x00337466:  0028      cmp     r0, #0
0x00337468:  08d0      beq     #0x33747c
0x0033746a:  0368      ldr     r3, [r0]
0x0033746c:  1360      str     r3, [r2]
0x0033746e:  0368      ldr     r3, [r0]
0x00337470:  002b      cmp     r3, #0
0x00337472:  00d0      beq     #0x337476
0x00337474:  5a60      str     r2, [r3, #4]
0x00337476:  0160      str     r1, [r0]
0x00337478:  4860      str     r0, [r1, #4]
0x0033747a:  05e0      b       #0x337488
0x0033747c:  4860      str     r0, [r1, #4]
0x0033747e:  2368      ldr     r3, [r4]
0x00337480:  1360      str     r3, [r2]
0x00337482:  2368      ldr     r3, [r4]
0x00337484:  5a60      str     r2, [r3, #4]
0x00337486:  2160      str     r1, [r4]
0x00337488:  10bc      pop     {r4}
0x0033748a:  01bc      pop     {r0}
0x0033748c:  0047      bx      r0
0x0033748e:  0000      movs    r0, r0
0x00337490:  00b5      push    {lr}
0x00337492:  0368      ldr     r3, [r0]
0x00337494:  002b      cmp     r3, #0
0x00337496:  03d1      bne     #0x3374a0
0x00337498:  4b60      str     r3, [r1, #4]
0x0033749a:  0160      str     r1, [r0]
0x0033749c:  01bc      pop     {r0}
0x0033749e:  0047      bx      r0
0x003374a0:  1a1c      adds    r2, r3, #0
0x003374a2:  1b68      ldr     r3, [r3]
0x003374a4:  002b      cmp     r3, #0
0x003374a6:  fbd1      bne     #0x3374a0
0x003374a8:  1160      str     r1, [r2]
0x003374aa:  4a60      str     r2, [r1, #4]
0x003374ac:  f6e7      b       #0x33749c
0x003374ae:  0000      movs    r0, r0
0x003374b0:  00b5      push    {lr}
0x003374b2:  0a68      ldr     r2, [r1]
0x003374b4:  002a      cmp     r2, #0
0x003374b6:  01d0      beq     #0x3374bc
0x003374b8:  4b68      ldr     r3, [r1, #4]
0x003374ba:  5360      str     r3, [r2, #4]
0x003374bc:  4b68      ldr     r3, [r1, #4]
0x003374be:  002b      cmp     r3, #0
0x003374c0:  04d1      bne     #0x3374cc
0x003374c2:  0368      ldr     r3, [r0]
0x003374c4:  8b42      cmp     r3, r1
0x003374c6:  02d1      bne     #0x3374ce
0x003374c8:  0260      str     r2, [r0]
0x003374ca:  00e0      b       #0x3374ce
0x003374cc:  1a60      str     r2, [r3]
0x003374ce:  0023      movs    r3, #0
0x003374d0:  4b60      str     r3, [r1, #4]
0x003374d2:  0b60      str     r3, [r1]
0x003374d4:  01bc      pop     {r0}
0x003374d6:  0047      bx      r0
0x003374d8:  00b5      push    {lr}
0x003374da:  0023      movs    r3, #0
0x003374dc:  0028      cmp     r0, #0
0x003374de:  03d0      beq     #0x3374e8
0x003374e0:  0068      ldr     r0, [r0]
0x003374e2:  0133      adds    r3, #1
0x003374e4:  0028      cmp     r0, #0
0x003374e6:  fbd1      bne     #0x3374e0
0x003374e8:  181c      adds    r0, r3, #0
0x003374ea:  02bc      pop     {r1}
0x003374ec:  0847      bx      r1
0x003374ee:  c046      mov     r8, r8
0x003374f0:  044b      ldr     r3, [pc, #0x10]  ; =0x0035f200
0x003374f2:  0004      lsls    r0, r0, #0x10
0x003374f4:  000c      lsrs    r0, r0, #0x10
0x003374f6:  1860      str     r0, [r3]
0x003374f8:  034b      ldr     r3, [pc, #0xc]  ; =0x0035f1fc
0x003374fa:  1860      str     r0, [r3]
0x003374fc:  034b      ldr     r3, [pc, #0xc]  ; =0x0035f1f8
0x003374fe:  1860      str     r0, [r3]
0x00337500:  7047      bx      lr

===== sub_003374b0 @ 0x003374b0 =====
0x003374b0:  00b5      push    {lr}
0x003374b2:  0a68      ldr     r2, [r1]
0x003374b4:  002a      cmp     r2, #0
0x003374b6:  01d0      beq     #0x3374bc
0x003374b8:  4b68      ldr     r3, [r1, #4]
0x003374ba:  5360      str     r3, [r2, #4]
0x003374bc:  4b68      ldr     r3, [r1, #4]
0x003374be:  002b      cmp     r3, #0
0x003374c0:  04d1      bne     #0x3374cc
0x003374c2:  0368      ldr     r3, [r0]
0x003374c4:  8b42      cmp     r3, r1
0x003374c6:  02d1      bne     #0x3374ce
0x003374c8:  0260      str     r2, [r0]
0x003374ca:  00e0      b       #0x3374ce
0x003374cc:  1a60      str     r2, [r3]
0x003374ce:  0023      movs    r3, #0
0x003374d0:  4b60      str     r3, [r1, #4]
0x003374d2:  0b60      str     r3, [r1]
0x003374d4:  01bc      pop     {r0}
0x003374d6:  0047      bx      r0
0x003374d8:  00b5      push    {lr}
0x003374da:  0023      movs    r3, #0
0x003374dc:  0028      cmp     r0, #0
0x003374de:  03d0      beq     #0x3374e8
0x003374e0:  0068      ldr     r0, [r0]
0x003374e2:  0133      adds    r3, #1
0x003374e4:  0028      cmp     r0, #0
0x003374e6:  fbd1      bne     #0x3374e0
0x003374e8:  181c      adds    r0, r3, #0
0x003374ea:  02bc      pop     {r1}
0x003374ec:  0847      bx      r1
0x003374ee:  c046      mov     r8, r8
0x003374f0:  044b      ldr     r3, [pc, #0x10]  ; =0x0035f200
0x003374f2:  0004      lsls    r0, r0, #0x10
0x003374f4:  000c      lsrs    r0, r0, #0x10
0x003374f6:  1860      str     r0, [r3]
0x003374f8:  034b      ldr     r3, [pc, #0xc]  ; =0x0035f1fc
0x003374fa:  1860      str     r0, [r3]
0x003374fc:  034b      ldr     r3, [pc, #0xc]  ; =0x0035f1f8
0x003374fe:  1860      str     r0, [r3]
0x00337500:  7047      bx      lr

===== sub_00339c1c @ 0x00339c1c =====
0x00339c1c:  10b5      push    {r4, lr}
0x00339c1e:  8842      cmp     r0, r1
0x00339c20:  01d3      blo     #0x339c26
0x00339c22:  0029      cmp     r1, #0
0x00339c24:  03d1      bne     #0x339c2e
0x00339c26:  0020      movs    r0, #0
0x00339c28:  10bc      pop     {r4}
0x00339c2a:  02bc      pop     {r1}
0x00339c2c:  0847      bx      r1
0x00339c2e:  ca07      lsls    r2, r1, #0x1f
0x00339c30:  05d4      bmi     #0x339c3e
0x00339c32:  0123      movs    r3, #1
0x00339c34:  4908      lsrs    r1, r1, #1
0x00339c36:  1a1c      adds    r2, r3, #0
0x00339c38:  4008      lsrs    r0, r0, #1
0x00339c3a:  8a43      bics    r2, r1
0x00339c3c:  fad1      bne     #0x339c34
0x00339c3e:  0129      cmp     r1, #1
0x00339c40:  f2d0      beq     #0x339c28
0x00339c42:  040a      lsrs    r4, r0, #8
0x00339c44:  0022      movs    r2, #0
0x00339c46:  0123      movs    r3, #1
0x00339c48:  8c42      cmp     r4, r1
0x00339c4a:  06d3      blo     #0x339c5a
0x00339c4c:  0902      lsls    r1, r1, #8
0x00339c4e:  1b02      lsls    r3, r3, #8
0x00339c50:  8c42      cmp     r4, r1
0x00339c52:  fbd2      bhs     #0x339c4c
0x00339c54:  05e0      b       #0x339c62
0x00339c56:  d218      adds    r2, r2, r3
0x00339c58:  401a      subs    r0, r0, r1
0x00339c5a:  8842      cmp     r0, r1
0x00339c5c:  fbd2      bhs     #0x339c56
0x00339c5e:  090a      lsrs    r1, r1, #8
0x00339c60:  1b0a      lsrs    r3, r3, #8
0x00339c62:  002b      cmp     r3, #0
0x00339c64:  f9d1      bne     #0x339c5a
0x00339c66:  101c      adds    r0, r2, #0
0x00339c68:  dee7      b       #0x339c28
0x00339c6a:  0000      movs    r0, r0
0x00339c6c:  30b5      push    {r4, r5, lr}
0x00339c6e:  051c      adds    r5, r0, #0
0x00339c70:  0c1c      adds    r4, r1, #0
0x00339c72:  0129      cmp     r1, #1
0x00339c74:  03d8      bhi     #0x339c7e
0x00339c76:  0020      movs    r0, #0
0x00339c78:  30bc      pop     {r4, r5}
0x00339c7a:  02bc      pop     {r1}
0x00339c7c:  0847      bx      r1
0x00339c7e:  fff7cdff  bl      #0x339c1c  ; sub_00339c1c
0x00339c82:  231c      adds    r3, r4, #0
0x00339c84:  4343      muls    r3, r0, r3
0x00339c86:  e81a      subs    r0, r5, r3
0x00339c88:  f6e7      b       #0x339c78
0x00339c8a:  0000      movs    r0, r0
0x00339c8c:  00b5      push    {lr}
0x00339c8e:  0028      cmp     r0, #0
0x00339c90:  01dd      ble     #0x339c96
0x00339c92:  02bc      pop     {r1}
0x00339c94:  0847      bx      r1
0x00339c96:  4042      rsbs    r0, r0, #0
0x00339c98:  fbe7      b       #0x339c92
0x00339c9a:  0000      movs    r0, r0
0x00339c9c:  70b5      push    {r4, r5, r6, lr}
0x00339c9e:  0e1c      adds    r6, r1, #0
0x00339ca0:  0028      cmp     r0, #0
0x00339ca2:  01d0      beq     #0x339ca8
0x00339ca4:  0029      cmp     r1, #0
0x00339ca6:  03d1      bne     #0x339cb0
0x00339ca8:  0020      movs    r0, #0
0x00339caa:  70bc      pop     {r4, r5, r6}
0x00339cac:  02bc      pop     {r1}
0x00339cae:  0847      bx      r1
0x00339cb0:  041c      adds    r4, r0, #0
0x00339cb2:  8023      movs    r3, #0x80
0x00339cb4:  4c40      eors    r4, r1
0x00339cb6:  1b06      lsls    r3, r3, #0x18
0x00339cb8:  1c40      ands    r4, r3
0x00339cba:  fff7e7ff  bl      #0x339c8c  ; sub_00339c8c
0x00339cbe:  051c      adds    r5, r0, #0
0x00339cc0:  301c      adds    r0, r6, #0
0x00339cc2:  fff7e3ff  bl      #0x339c8c  ; sub_00339c8c
0x00339cc6:  011c      adds    r1, r0, #0
0x00339cc8:  281c      adds    r0, r5, #0
0x00339cca:  fff7cfff  bl      #0x339c6c  ; sub_00339c6c
0x00339cce:  002c      cmp     r4, #0
0x00339cd0:  ebd0      beq     #0x339caa
0x00339cd2:  4042      rsbs    r0, r0, #0
0x00339cd4:  e9e7      b       #0x339caa
0x00339cd6:  0000      movs    r0, r0
0x00339cd8:  70b5      push    {r4, r5, r6, lr}
0x00339cda:  0e1c      adds    r6, r1, #0
0x00339cdc:  0028      cmp     r0, #0
0x00339cde:  01d0      beq     #0x339ce4
0x00339ce0:  0029      cmp     r1, #0
0x00339ce2:  03d1      bne     #0x339cec
0x00339ce4:  0020      movs    r0, #0
0x00339ce6:  70bc      pop     {r4, r5, r6}
0x00339ce8:  02bc      pop     {r1}
0x00339cea:  0847      bx      r1
0x00339cec:  041c      adds    r4, r0, #0
0x00339cee:  8023      movs    r3, #0x80
0x00339cf0:  4c40      eors    r4, r1
0x00339cf2:  1b06      lsls    r3, r3, #0x18
0x00339cf4:  1c40      ands    r4, r3
0x00339cf6:  fff7c9ff  bl      #0x339c8c  ; sub_00339c8c
0x00339cfa:  051c      adds    r5, r0, #0
0x00339cfc:  301c      adds    r0, r6, #0
0x00339cfe:  fff7c5ff  bl      #0x339c8c  ; sub_00339c8c
0x00339d02:  011c      adds    r1, r0, #0
0x00339d04:  281c      adds    r0, r5, #0
0x00339d06:  fff789ff  bl      #0x339c1c  ; sub_00339c1c
0x00339d0a:  002c      cmp     r4, #0
0x00339d0c:  ebd0      beq     #0x339ce6
0x00339d0e:  4042      rsbs    r0, r0, #0
0x00339d10:  e9e7      b       #0x339ce6
0x00339d12:  c046      mov     r8, r8
0x00339d14:  f0b5      push    {r4, r5, r6, r7, lr}
0x00339d16:  5746      mov     r7, sl
0x00339d18:  4e46      mov     r6, sb
0x00339d1a:  4546      mov     r5, r8
0x00339d1c:  e0b4      push    {r5, r6, r7}
0x00339d1e:  8846      mov     r8, r1
0x00339d20:  0028      cmp     r0, #0
0x00339d22:  8246      mov     sl, r0
0x00339d24:  3add      ble     #0x339d9c
0x00339d26:  0029      cmp     r1, #0
0x00339d28:  38dd      ble     #0x339d9c
0x00339d2a:  4446      mov     r4, r8
0x00339d2c:  0423      movs    r3, #4
0x00339d2e:  5b42      rsbs    r3, r3, #0
0x00339d30:  0334      adds    r4, #3
0x00339d32:  1c40      ands    r4, r3
0x00339d34:  231c      adds    r3, r4, #0
0x00339d36:  0c33      adds    r3, #0xc
0x00339d38:  5046      mov     r0, sl
0x00339d3a:  5843      muls    r0, r3, r0
0x00339d3c:  3830      adds    r0, #0x38
0x00339d3e:  fcf797f8  bl      #0x335e70  ; sub_00335e70
0x00339d42:  071e      subs    r7, r0, #0
0x00339d44:  22d0      beq     #0x339d8c
0x00339d46:  1822      movs    r2, #0x18
0x00339d48:  0c23      movs    r3, #0xc
0x00339d4a:  d219      adds    r2, r2, r7
0x00339d4c:  9146      mov     sb, r2
0x00339d4e:  5246      mov     r2, sl
0x00339d50:  5a43      muls    r2, r3, r2
0x00339d52:  3d1c      adds    r5, r7, #0
0x00339d54:  3835      adds    r5, #0x38
0x00339d56:  4846      mov     r0, sb
0x00339d58:  0021      movs    r1, #0
0x00339d5a:  5619      adds    r6, r2, r5
0x00339d5c:  faf788fc  bl      #0x334670  ; sub_00334670
0x00339d60:  4b46      mov     r3, sb
0x00339d62:  7b61      str     r3, [r7, #0x14]
0x00339d64:  4346      mov     r3, r8
0x00339d66:  5246      mov     r2, sl
0x00339d68:  7b60      str     r3, [r7, #4]
0x00339d6a:  0023      movs    r3, #0
0x00339d6c:  3a60      str     r2, [r7]
0x00339d6e:  bd60      str     r5, [r7, #8]
0x00339d70:  fb60      str     r3, [r7, #0xc]
0x00339d72:  3b61      str     r3, [r7, #0x10]
0x00339d74:  5046      mov     r0, sl
0x00339d76:  2b1c      adds    r3, r5, #0
0x00339d78:  0c33      adds    r3, #0xc
0x00339d7a:  0138      subs    r0, #1
0x00339d7c:  6e60      str     r6, [r5, #4]
0x00339d7e:  2b60      str     r3, [r5]
0x00339d80:  3619      adds    r6, r6, r4
0x00339d82:  1d1c      adds    r5, r3, #0
0x00339d84:  0028      cmp     r0, #0
0x00339d86:  f6d1      bne     #0x339d76
0x00339d88:  0c3d      subs    r5, #0xc
0x00339d8a:  2860      str     r0, [r5]
0x00339d8c:  381c      adds    r0, r7, #0
0x00339d8e:  38bc      pop     {r3, r4, r5}
0x00339d90:  9846      mov     r8, r3
0x00339d92:  a146      mov     sb, r4
0x00339d94:  aa46      mov     sl, r5
0x00339d96:  f0bc      pop     {r4, r5, r6, r7}
0x00339d98:  02bc      pop     {r1}
0x00339d9a:  0847      bx      r1
0x00339d9c:  0020      movs    r0, #0
0x00339d9e:  f6e7      b       #0x339d8e
0x00339da0:  00b5      push    {lr}
0x00339da2:  0028      cmp     r0, #0
0x00339da4:  01d0      beq     #0x339daa
0x00339da6:  fcf7edf8  bl      #0x335f84  ; sub_00335f84
0x00339daa:  01bc      pop     {r0}
0x00339dac:  0047      bx      r0
0x00339dae:  0000      movs    r0, r0
0x00339db0:  f0b5      push    {r4, r5, r6, r7, lr}
0x00339db2:  4746      mov     r7, r8
0x00339db4:  80b4      push    {r7}
0x00339db6:  0f1c      adds    r7, r1, #0
0x00339db8:  141c      adds    r4, r2, #0
0x00339dba:  9846      mov     r8, r3
0x00339dbc:  051e      subs    r5, r0, #0
0x00339dbe:  02d0      beq     #0x339dc6
0x00339dc0:  6b68      ldr     r3, [r5, #4]
0x00339dc2:  a342      cmp     r3, r4
0x00339dc4:  07da      bge     #0x339dd6
0x00339dc6:  0124      movs    r4, #1
0x00339dc8:  6442      rsbs    r4, r4, #0
0x00339dca:  201c      adds    r0, r4, #0
0x00339dcc:  08bc      pop     {r3}
0x00339dce:  9846      mov     r8, r3
0x00339dd0:  f0bc      pop     {r4, r5, r6, r7}
0x00339dd2:  02bc      pop     {r1}
0x00339dd4:  0847      bx      r1
0x00339dd6:  faf713fa  bl      #0x334200  ; sub_00334200
0x00339dda:  ae68      ldr     r6, [r5, #8]
0x00339ddc:  002e      cmp     r6, #0
0x00339dde:  20d0      beq     #0x339e22
0x00339de0:  3368      ldr     r3, [r6]
0x00339de2:  ab60      str     r3, [r5, #8]
0x00339de4:  faf71cfa  bl      #0x334220  ; sub_00334220
0x00339de8:  2204      lsls    r2, r4, #0x10
0x00339dea:  7068      ldr     r0, [r6, #4]
0x00339dec:  391c      adds    r1, r7, #0
0x00339dee:  120c      lsrs    r2, r2, #0x10
0x00339df0:  00f0d2f8  bl      #0x339f98  ; sub_00339f98
0x00339df4:  b460      str     r4, [r6, #8]
0x00339df6:  faf703fa  bl      #0x334200  ; sub_00334200
0x00339dfa:  4346      mov     r3, r8

===== sub_00339cd8 @ 0x00339cd8 =====
0x00339cd8:  70b5      push    {r4, r5, r6, lr}
0x00339cda:  0e1c      adds    r6, r1, #0
0x00339cdc:  0028      cmp     r0, #0
0x00339cde:  01d0      beq     #0x339ce4
0x00339ce0:  0029      cmp     r1, #0
0x00339ce2:  03d1      bne     #0x339cec
0x00339ce4:  0020      movs    r0, #0
0x00339ce6:  70bc      pop     {r4, r5, r6}
0x00339ce8:  02bc      pop     {r1}
0x00339cea:  0847      bx      r1
0x00339cec:  041c      adds    r4, r0, #0
0x00339cee:  8023      movs    r3, #0x80
0x00339cf0:  4c40      eors    r4, r1
0x00339cf2:  1b06      lsls    r3, r3, #0x18
0x00339cf4:  1c40      ands    r4, r3
0x00339cf6:  fff7c9ff  bl      #0x339c8c  ; sub_00339c8c
0x00339cfa:  051c      adds    r5, r0, #0
0x00339cfc:  301c      adds    r0, r6, #0
0x00339cfe:  fff7c5ff  bl      #0x339c8c  ; sub_00339c8c
0x00339d02:  011c      adds    r1, r0, #0
0x00339d04:  281c      adds    r0, r5, #0
0x00339d06:  fff789ff  bl      #0x339c1c  ; sub_00339c1c
0x00339d0a:  002c      cmp     r4, #0
0x00339d0c:  ebd0      beq     #0x339ce6
0x00339d0e:  4042      rsbs    r0, r0, #0
0x00339d10:  e9e7      b       #0x339ce6
0x00339d12:  c046      mov     r8, r8
0x00339d14:  f0b5      push    {r4, r5, r6, r7, lr}
0x00339d16:  5746      mov     r7, sl
0x00339d18:  4e46      mov     r6, sb
0x00339d1a:  4546      mov     r5, r8
0x00339d1c:  e0b4      push    {r5, r6, r7}
0x00339d1e:  8846      mov     r8, r1
0x00339d20:  0028      cmp     r0, #0
0x00339d22:  8246      mov     sl, r0
0x00339d24:  3add      ble     #0x339d9c
0x00339d26:  0029      cmp     r1, #0
0x00339d28:  38dd      ble     #0x339d9c
0x00339d2a:  4446      mov     r4, r8
0x00339d2c:  0423      movs    r3, #4
0x00339d2e:  5b42      rsbs    r3, r3, #0
0x00339d30:  0334      adds    r4, #3
0x00339d32:  1c40      ands    r4, r3
0x00339d34:  231c      adds    r3, r4, #0
0x00339d36:  0c33      adds    r3, #0xc
0x00339d38:  5046      mov     r0, sl
0x00339d3a:  5843      muls    r0, r3, r0
0x00339d3c:  3830      adds    r0, #0x38
0x00339d3e:  fcf797f8  bl      #0x335e70  ; sub_00335e70
0x00339d42:  071e      subs    r7, r0, #0
0x00339d44:  22d0      beq     #0x339d8c
0x00339d46:  1822      movs    r2, #0x18
0x00339d48:  0c23      movs    r3, #0xc
0x00339d4a:  d219      adds    r2, r2, r7
0x00339d4c:  9146      mov     sb, r2
0x00339d4e:  5246      mov     r2, sl
0x00339d50:  5a43      muls    r2, r3, r2
0x00339d52:  3d1c      adds    r5, r7, #0
0x00339d54:  3835      adds    r5, #0x38
0x00339d56:  4846      mov     r0, sb
0x00339d58:  0021      movs    r1, #0
0x00339d5a:  5619      adds    r6, r2, r5
0x00339d5c:  faf788fc  bl      #0x334670  ; sub_00334670
0x00339d60:  4b46      mov     r3, sb
0x00339d62:  7b61      str     r3, [r7, #0x14]
0x00339d64:  4346      mov     r3, r8
0x00339d66:  5246      mov     r2, sl
0x00339d68:  7b60      str     r3, [r7, #4]
0x00339d6a:  0023      movs    r3, #0
0x00339d6c:  3a60      str     r2, [r7]
0x00339d6e:  bd60      str     r5, [r7, #8]
0x00339d70:  fb60      str     r3, [r7, #0xc]
0x00339d72:  3b61      str     r3, [r7, #0x10]
0x00339d74:  5046      mov     r0, sl
0x00339d76:  2b1c      adds    r3, r5, #0
0x00339d78:  0c33      adds    r3, #0xc
0x00339d7a:  0138      subs    r0, #1
0x00339d7c:  6e60      str     r6, [r5, #4]
0x00339d7e:  2b60      str     r3, [r5]
0x00339d80:  3619      adds    r6, r6, r4
0x00339d82:  1d1c      adds    r5, r3, #0
0x00339d84:  0028      cmp     r0, #0
0x00339d86:  f6d1      bne     #0x339d76
0x00339d88:  0c3d      subs    r5, #0xc
0x00339d8a:  2860      str     r0, [r5]
0x00339d8c:  381c      adds    r0, r7, #0
0x00339d8e:  38bc      pop     {r3, r4, r5}
0x00339d90:  9846      mov     r8, r3
0x00339d92:  a146      mov     sb, r4
0x00339d94:  aa46      mov     sl, r5
0x00339d96:  f0bc      pop     {r4, r5, r6, r7}
0x00339d98:  02bc      pop     {r1}
0x00339d9a:  0847      bx      r1
0x00339d9c:  0020      movs    r0, #0
0x00339d9e:  f6e7      b       #0x339d8e
0x00339da0:  00b5      push    {lr}
0x00339da2:  0028      cmp     r0, #0
0x00339da4:  01d0      beq     #0x339daa
0x00339da6:  fcf7edf8  bl      #0x335f84  ; sub_00335f84
0x00339daa:  01bc      pop     {r0}
0x00339dac:  0047      bx      r0
0x00339dae:  0000      movs    r0, r0
0x00339db0:  f0b5      push    {r4, r5, r6, r7, lr}
0x00339db2:  4746      mov     r7, r8
0x00339db4:  80b4      push    {r7}
0x00339db6:  0f1c      adds    r7, r1, #0
0x00339db8:  141c      adds    r4, r2, #0
0x00339dba:  9846      mov     r8, r3
0x00339dbc:  051e      subs    r5, r0, #0
0x00339dbe:  02d0      beq     #0x339dc6
0x00339dc0:  6b68      ldr     r3, [r5, #4]
0x00339dc2:  a342      cmp     r3, r4
0x00339dc4:  07da      bge     #0x339dd6
0x00339dc6:  0124      movs    r4, #1
0x00339dc8:  6442      rsbs    r4, r4, #0
0x00339dca:  201c      adds    r0, r4, #0
0x00339dcc:  08bc      pop     {r3}
0x00339dce:  9846      mov     r8, r3
0x00339dd0:  f0bc      pop     {r4, r5, r6, r7}
0x00339dd2:  02bc      pop     {r1}
0x00339dd4:  0847      bx      r1
0x00339dd6:  faf713fa  bl      #0x334200  ; sub_00334200
0x00339dda:  ae68      ldr     r6, [r5, #8]
0x00339ddc:  002e      cmp     r6, #0
0x00339dde:  20d0      beq     #0x339e22
0x00339de0:  3368      ldr     r3, [r6]
0x00339de2:  ab60      str     r3, [r5, #8]
0x00339de4:  faf71cfa  bl      #0x334220  ; sub_00334220
0x00339de8:  2204      lsls    r2, r4, #0x10
0x00339dea:  7068      ldr     r0, [r6, #4]
0x00339dec:  391c      adds    r1, r7, #0
0x00339dee:  120c      lsrs    r2, r2, #0x10
0x00339df0:  00f0d2f8  bl      #0x339f98  ; sub_00339f98
0x00339df4:  b460      str     r4, [r6, #8]
0x00339df6:  faf703fa  bl      #0x334200  ; sub_00334200
0x00339dfa:  4346      mov     r3, r8
0x00339dfc:  012b      cmp     r3, #1
0x00339dfe:  15d0      beq     #0x339e2c
0x00339e00:  2b69      ldr     r3, [r5, #0x10]
0x00339e02:  002b      cmp     r3, #0
0x00339e04:  10d1      bne     #0x339e28
0x00339e06:  ee60      str     r6, [r5, #0xc]
0x00339e08:  0023      movs    r3, #0
0x00339e0a:  2e61      str     r6, [r5, #0x10]
0x00339e0c:  3360      str     r3, [r6]
0x00339e0e:  0024      movs    r4, #0
0x00339e10:  faf706fa  bl      #0x334220  ; sub_00334220
0x00339e14:  002c      cmp     r4, #0
0x00339e16:  d8d1      bne     #0x339dca
0x00339e18:  6869      ldr     r0, [r5, #0x14]
0x00339e1a:  0121      movs    r1, #1
0x00339e1c:  faf7dcfc  bl      #0x3347d8  ; sub_003347d8
0x00339e20:  d3e7      b       #0x339dca
0x00339e22:  0124      movs    r4, #1
0x00339e24:  6442      rsbs    r4, r4, #0
0x00339e26:  f3e7      b       #0x339e10
0x00339e28:  1e60      str     r6, [r3]
0x00339e2a:  ede7      b       #0x339e08
0x00339e2c:  eb68      ldr     r3, [r5, #0xc]
0x00339e2e:  3360      str     r3, [r6]
0x00339e30:  ee60      str     r6, [r5, #0xc]
0x00339e32:  ece7      b       #0x339e0e
0x00339e34:  f0b5      push    {r4, r5, r6, r7, lr}
0x00339e36:  4746      mov     r7, r8
0x00339e38:  80b4      push    {r7}
0x00339e3a:  8846      mov     r8, r1
0x00339e3c:  171c      adds    r7, r2, #0
0x00339e3e:  061e      subs    r6, r0, #0
0x00339e40:  27d0      beq     #0x339e92
0x00339e42:  7069      ldr     r0, [r6, #0x14]
0x00339e44:  0121      movs    r1, #1
0x00339e46:  faf775fc  bl      #0x334734  ; sub_00334734
0x00339e4a:  faf7d9f9  bl      #0x334200  ; sub_00334200
0x00339e4e:  f568      ldr     r5, [r6, #0xc]
0x00339e50:  002d      cmp     r5, #0
0x00339e52:  21d0      beq     #0x339e98
0x00339e54:  2b68      ldr     r3, [r5]
0x00339e56:  f360      str     r3, [r6, #0xc]
0x00339e58:  002b      cmp     r3, #0
0x00339e5a:  18d0      beq     #0x339e8e
0x00339e5c:  faf7e0f9  bl      #0x334220  ; sub_00334220
0x00339e60:  ac68      ldr     r4, [r5, #8]
0x00339e62:  bc42      cmp     r4, r7
0x00339e64:  00dd      ble     #0x339e68
0x00339e66:  3c1c      adds    r4, r7, #0
0x00339e68:  2204      lsls    r2, r4, #0x10
0x00339e6a:  4046      mov     r0, r8
0x00339e6c:  6968      ldr     r1, [r5, #4]
0x00339e6e:  120c      lsrs    r2, r2, #0x10
0x00339e70:  00f092f8  bl      #0x339f98  ; sub_00339f98
0x00339e74:  faf7c4f9  bl      #0x334200  ; sub_00334200
0x00339e78:  b368      ldr     r3, [r6, #8]
0x00339e7a:  2b60      str     r3, [r5]
0x00339e7c:  b560      str     r5, [r6, #8]
0x00339e7e:  faf7cff9  bl      #0x334220  ; sub_00334220
0x00339e82:  201c      adds    r0, r4, #0
0x00339e84:  08bc      pop     {r3}
0x00339e86:  9846      mov     r8, r3
0x00339e88:  f0bc      pop     {r4, r5, r6, r7}
0x00339e8a:  02bc      pop     {r1}
0x00339e8c:  0847      bx      r1
0x00339e8e:  3361      str     r3, [r6, #0x10]
0x00339e90:  e4e7      b       #0x339e5c
0x00339e92:  0124      movs    r4, #1
0x00339e94:  6442      rsbs    r4, r4, #0
0x00339e96:  f4e7      b       #0x339e82
0x00339e98:  0024      movs    r4, #0
0x00339e9a:  f0e7      b       #0x339e7e
0x00339e9c:  00b5      push    {lr}
0x00339e9e:  0028      cmp     r0, #0
0x00339ea0:  06d0      beq     #0x339eb0
0x00339ea2:  4069      ldr     r0, [r0, #0x14]
0x00339ea4:  faf7defc  bl      #0x334864  ; sub_00334864
0x00339ea8:  0004      lsls    r0, r0, #0x10
0x00339eaa:  000c      lsrs    r0, r0, #0x10
0x00339eac:  02bc      pop     {r1}
0x00339eae:  0847      bx      r1
0x00339eb0:  0120      movs    r0, #1
0x00339eb2:  4042      rsbs    r0, r0, #0
0x00339eb4:  fae7      b       #0x339eac
0x00339eb6:  c046      mov     r8, r8

===== sub_00339f98 @ 0x00339f98 =====
0x00339f98:  7847      bx      pc
0x00339f9a:  c046      mov     r8, r8

===== sub_00339fa0 @ 0x00339fa0 =====
0x00339fa0:  7847      bx      pc
0x00339fa2:  c046      mov     r8, r8

===== sub_00339fa8 @ 0x00339fa8 =====
0x00339fa8:  7847      bx      pc
0x00339faa:  c046      mov     r8, r8

===== sub_00339fb0 @ 0x00339fb0 =====
0x00339fb0:  7847      bx      pc
0x00339fb2:  c046      mov     r8, r8

===== sub_00339fb8 @ 0x00339fb8 =====
0x00339fb8:  7847      bx      pc
0x00339fba:  c046      mov     r8, r8
