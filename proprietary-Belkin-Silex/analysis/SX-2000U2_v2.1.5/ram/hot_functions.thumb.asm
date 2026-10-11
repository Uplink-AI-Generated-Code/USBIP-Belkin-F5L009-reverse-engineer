; SX-2000U2 top-called functions + main() (THUMB)

===== main @ 0x0008b8d8 =====
0x0008b8d8:  00b5      push    {lr}
0x0008b8da:  81b0      sub     sp, #4
0x0008b8dc:  fdf73cf8  bl      #0x88958  ; sub_00088958
0x0008b8e0:  4bf000fe  bl      #0xd74e4  ; sub_000d74e4
0x0008b8e4:  fdf75cf8  bl      #0x889a0  ; sub_000889a0
0x0008b8e8:  2348      ldr     r0, [pc, #0x8c]
0x0008b8ea:  4bf065fd  bl      #0xd73b8  ; sub_000d73b8
0x0008b8ee:  0a20      movs    r0, #0xa
0x0008b8f0:  4bf0c8fe  bl      #0xd7684  ; sub_000d7684
0x0008b8f4:  214b      ldr     r3, [pc, #0x84]
0x0008b8f6:  2249      ldr     r1, [pc, #0x88]
0x0008b8f8:  181c      adds    r0, r3, #0
0x0008b8fa:  c91a      subs    r1, r1, r3
0x0008b8fc:  4cf016fb  bl      #0xd7f2c  ; sub_000d7f2c
0x0008b900:  1d48      ldr     r0, [pc, #0x74]
0x0008b902:  fcf7f7ff  bl      #0x888f4  ; sub_000888f4
0x0008b906:  0020      movs    r0, #0
0x0008b908:  fdf7baf8  bl      #0x88a80  ; sub_00088a80
0x0008b90c:  1d4b      ldr     r3, [pc, #0x74]
0x0008b90e:  1860      str     r0, [r3]
0x0008b910:  8020      movs    r0, #0x80
0x0008b912:  c001      lsls    r0, r0, #7
0x0008b914:  4cf00efa  bl      #0xd7d34  ; sub_000d7d34
0x0008b918:  0028      cmp     r0, #0
0x0008b91a:  2ad0      beq     #0x8b972
0x0008b91c:  8021      movs    r1, #0x80
0x0008b91e:  c901      lsls    r1, r1, #7
0x0008b920:  4cf088fc  bl      #0xd8234  ; sub_000d8234
0x0008b924:  0420      movs    r0, #4
0x0008b926:  4cf0b7fc  bl      #0xd8298  ; sub_000d8298
0x0008b92a:  0120      movs    r0, #1
0x0008b92c:  4cf090fc  bl      #0xd8250  ; sub_000d8250
0x0008b930:  1548      ldr     r0, [pc, #0x54]  ; &"SYSLOG START: MSG_DEBUG"
0x0008b932:  4cf083fd  bl      #0xd843c  ; sub_000d843c
0x0008b936:  11f00dfa  bl      #0x9cd54  ; sub_0009cd54
0x0008b93a:  104b      ldr     r3, [pc, #0x40]
0x0008b93c:  104a      ldr     r2, [pc, #0x40]
0x0008b93e:  191c      adds    r1, r3, #0
0x0008b940:  d21a      subs    r2, r2, r3
0x0008b942:  1248      ldr     r0, [pc, #0x48]  ; &"HEAP: addr=%lx size=%lx"
0x0008b944:  4df0defa  bl      #0xd8f04  ; sub_000d8f04
0x0008b948:  114b      ldr     r3, [pc, #0x44]  ; &"DEBUG"
0x0008b94a:  c022      movs    r2, #0xc0
0x0008b94c:  0093      str     r3, [sp]
0x0008b94e:  1148      ldr     r0, [pc, #0x44]
0x0008b950:  1149      ldr     r1, [pc, #0x44]
0x0008b952:  1201      lsls    r2, r2, #4
0x0008b954:  0123      movs    r3, #1
0x0008b956:  fff7c9fd  bl      #0x8b4ec  ; sub_0008b4ec
0x0008b95a:  104b      ldr     r3, [pc, #0x40]  ; &"INIT"
0x0008b95c:  8022      movs    r2, #0x80
0x0008b95e:  0093      str     r3, [sp]
0x0008b960:  0f48      ldr     r0, [pc, #0x3c]
0x0008b962:  1049      ldr     r1, [pc, #0x40]
0x0008b964:  1201      lsls    r2, r2, #4
0x0008b966:  0223      movs    r3, #2
0x0008b968:  fff7c0fd  bl      #0x8b4ec  ; sub_0008b4ec
0x0008b96c:  4bf074fd  bl      #0xd7458  ; sub_000d7458
0x0008b970:  fee7      b       #0x8b970
0x0008b972:  0d48      ldr     r0, [pc, #0x34]  ; &"Alloc Error"
0x0008b974:  dde7      b       #0x8b932
0x0008b976:  0000      movs    r0, r0
0x0008b978:  1027      movs    r7, #0x10
0x0008b97a:  0000      movs    r0, r0
0x0008b97c:  d085      strh    r0, [r2, #0x2e]
0x0008b97e:  1100      movs    r1, r2
0x0008b980:  0000      movs    r0, r0
0x0008b982:  8000      lsls    r0, r0, #2
0x0008b984:  e0e4      b       #0x8b348
0x0008b986:  0700      movs    r7, r0
0x0008b988:  0c81      strh    r4, [r1, #8]
0x0008b98a:  1000      movs    r0, r2
0x0008b98c:  2881      strh    r0, [r5, #8]
0x0008b98e:  1000      movs    r0, r2
0x0008b990:  4081      strh    r0, [r0, #0xa]
0x0008b992:  1000      movs    r0, r2
0x0008b994:  80ed0700  stc     p0, c0, [r0, #0x1c]
0x0008b998:  c5ed0900  stcl    p0, c0, [r5, #0x24]
0x0008b99c:  4881      strh    r0, [r1, #0xa]
0x0008b99e:  1000      movs    r0, r2
0x0008b9a0:  00ed0700  stc     p0, c0, [r0, #-0x1c]
0x0008b9a4:  e1b5      push    {r0, r5, r6, r7, lr}
0x0008b9a6:  0800      movs    r0, r1
0x0008b9a8:  5081      strh    r0, [r2, #0xa]
0x0008b9aa:  1000      movs    r0, r2
0x0008b9ac:  00b5      push    {lr}
0x0008b9ae:  0020      movs    r0, #0
0x0008b9b0:  0021      movs    r1, #0
0x0008b9b2:  41f0abfa  bl      #0xccf0c  ; sub_000ccf0c
0x0008b9b6:  0028      cmp     r0, #0
0x0008b9b8:  02d0      beq     #0x8b9c0
0x0008b9ba:  0068      ldr     r0, [r0]
0x0008b9bc:  02bc      pop     {r1}
0x0008b9be:  0847      bx      r1
0x0008b9c0:  0020      movs    r0, #0
0x0008b9c2:  fbe7      b       #0x8b9bc
0x0008b9c4:  10b5      push    {r4, lr}
0x0008b9c6:  81b0      sub     sp, #4
0x0008b9c8:  fff7f0ff  bl      #0x8b9ac  ; sub_0008b9ac
0x0008b9cc:  041e      subs    r4, r0, #0
0x0008b9ce:  0dd0      beq     #0x8b9ec
0x0008b9d0:  0e4b      ldr     r3, [pc, #0x38]
0x0008b9d2:  0721      movs    r1, #7
0x0008b9d4:  1868      ldr     r0, [r3]
0x0008b9d6:  0130      adds    r0, #1
0x0008b9d8:  0006      lsls    r0, r0, #0x18
0x0008b9da:  000e      lsrs    r0, r0, #0x18
0x0008b9dc:  2cf078fe  bl      #0xb86d0  ; sub_000b86d0
0x0008b9e0:  0006      lsls    r0, r0, #0x18
0x0008b9e2:  0028      cmp     r0, #0
0x0008b9e4:  06d1      bne     #0x8b9f4
0x0008b9e6:  0a48      ldr     r0, [pc, #0x28]  ; &"DIAGNOS_PRINT: Not found PirnterClass De"
0x0008b9e8:  4df08cfa  bl      #0xd8f04  ; sub_000d8f04
0x0008b9ec:  01b0      add     sp, #4
0x0008b9ee:  10bc      pop     {r4}
0x0008b9f0:  01bc      pop     {r0}
0x0008b9f2:  0047      bx      r0
0x0008b9f4:  074b      ldr     r3, [pc, #0x1c]
0x0008b9f6:  201c      adds    r0, r4, #0
0x0008b9f8:  1a68      ldr     r2, [r3]
0x0008b9fa:  074b      ldr     r3, [pc, #0x1c]
0x0008b9fc:  0749      ldr     r1, [pc, #0x1c]  ; &"%!PS-Adobe-2.0"
0x0008b9fe:  1b68      ldr     r3, [r3]
0x0008ba00:  0093      str     r3, [sp]
0x0008ba02:  074b      ldr     r3, [pc, #0x1c]
0x0008ba04:  fff7cafa  bl      #0x8af9c  ; sub_0008af9c
0x0008ba08:  f0e7      b       #0x8b9ec
0x0008ba0a:  0000      movs    r0, r0
0x0008ba0c:  a814      asrs    r0, r5, #0x12
0x0008ba0e:  0800      movs    r0, r1
0x0008ba10:  9481      strh    r4, [r2, #0xc]
0x0008ba12:  1000      movs    r0, r2
0x0008ba14:  e47e      ldrb    r4, [r4, #0x1b]
0x0008ba16:  1000      movs    r0, r2
0x0008ba18:  e07e      ldrb    r0, [r4, #0x1b]
0x0008ba1a:  1000      movs    r0, r2
0x0008ba1c:  88ce      ldm     r6!, {r3, r7}
0x0008ba1e:  0d00      movs    r5, r1
0x0008ba20:  70ce      ldm     r6, {r4, r5, r6}
0x0008ba22:  0d00      movs    r5, r1
0x0008ba24:  00b5      push    {lr}
0x0008ba26:  fff7edfc  bl      #0x8b404  ; sub_0008b404
0x0008ba2a:  02bc      pop     {r1}
0x0008ba2c:  0847      bx      r1
0x0008ba2e:  0000      movs    r0, r0
0x0008ba30:  10b5      push    {r4, lr}
0x0008ba32:  81b0      sub     sp, #4
0x0008ba34:  fff7baff  bl      #0x8b9ac  ; sub_0008b9ac
0x0008ba38:  041e      subs    r4, r0, #0
0x0008ba3a:  0dd0      beq     #0x8ba58
0x0008ba3c:  0e4b      ldr     r3, [pc, #0x38]
0x0008ba3e:  0721      movs    r1, #7
0x0008ba40:  1868      ldr     r0, [r3]
0x0008ba42:  0130      adds    r0, #1
0x0008ba44:  0006      lsls    r0, r0, #0x18
0x0008ba46:  000e      lsrs    r0, r0, #0x18
0x0008ba48:  2cf042fe  bl      #0xb86d0  ; sub_000b86d0
0x0008ba4c:  0006      lsls    r0, r0, #0x18
0x0008ba4e:  0028      cmp     r0, #0
0x0008ba50:  06d1      bne     #0x8ba60
0x0008ba52:  0a48      ldr     r0, [pc, #0x28]  ; &"CONFIG_PRINT: Not found PirnterClass Dev"
0x0008ba54:  4df056fa  bl      #0xd8f04  ; sub_000d8f04
0x0008ba58:  01b0      add     sp, #4
0x0008ba5a:  10bc      pop     {r4}
0x0008ba5c:  01bc      pop     {r0}
0x0008ba5e:  0047      bx      r0
0x0008ba60:  074b      ldr     r3, [pc, #0x1c]
0x0008ba62:  201c      adds    r0, r4, #0
0x0008ba64:  1a68      ldr     r2, [r3]
0x0008ba66:  074b      ldr     r3, [pc, #0x1c]
0x0008ba68:  0749      ldr     r1, [pc, #0x1c]  ; &"%!PS-Adobe-2.0"
0x0008ba6a:  1b68      ldr     r3, [r3]
0x0008ba6c:  0093      str     r3, [sp]
0x0008ba6e:  074b      ldr     r3, [pc, #0x1c]
0x0008ba70:  fff782fb  bl      #0x8b178  ; sub_0008b178
0x0008ba74:  f0e7      b       #0x8ba58
0x0008ba76:  0000      movs    r0, r0
0x0008ba78:  a814      asrs    r0, r5, #0x12
0x0008ba7a:  0800      movs    r0, r1
0x0008ba7c:  c481      strh    r4, [r0, #0xe]
0x0008ba7e:  1000      movs    r0, r2
0x0008ba80:  e47e      ldrb    r4, [r4, #0x1b]
0x0008ba82:  1000      movs    r0, r2
0x0008ba84:  e07e      ldrb    r0, [r4, #0x1b]
0x0008ba86:  1000      movs    r0, r2
0x0008ba88:  88ce      ldm     r6!, {r3, r7}
0x0008ba8a:  0d00      movs    r5, r1
0x0008ba8c:  70ce      ldm     r6, {r4, r5, r6}
0x0008ba8e:  0d00      movs    r5, r1
0x0008ba90:  00b5      push    {lr}
0x0008ba92:  fff7bdfc  bl      #0x8b410  ; sub_0008b410
0x0008ba96:  02bc      pop     {r1}
0x0008ba98:  0847      bx      r1
0x0008ba9a:  0000      movs    r0, r0
0x0008ba9c:  10b5      push    {r4, lr}
0x0008ba9e:  81b0      sub     sp, #4
0x0008baa0:  fff784ff  bl      #0x8b9ac  ; sub_0008b9ac
0x0008baa4:  041e      subs    r4, r0, #0
0x0008baa6:  0dd0      beq     #0x8bac4
0x0008baa8:  0f4b      ldr     r3, [pc, #0x3c]
0x0008baaa:  0721      movs    r1, #7
0x0008baac:  1868      ldr     r0, [r3]
0x0008baae:  0130      adds    r0, #1
0x0008bab0:  0006      lsls    r0, r0, #0x18
0x0008bab2:  000e      lsrs    r0, r0, #0x18
0x0008bab4:  2cf00cfe  bl      #0xb86d0  ; sub_000b86d0

===== sub_00088e74 @ 0x00088e74 =====
0x00088e74:  0068      ldr     r0, [r0]
0x00088e76:  7047      bx      lr

===== sub_00088e88 @ 0x00088e88 =====
0x00088e88:  0160      str     r1, [r0]
0x00088e8a:  7047      bx      lr

===== sub_00093600 @ 0x00093600 =====
0x00093600:  0028      cmp     r0, #0
0x00093602:  00d0      beq     #0x93606
0x00093604:  4162      str     r1, [r0, #0x24]
0x00093606:  024b      ldr     r3, [pc, #8]
0x00093608:  0020      movs    r0, #0
0x0009360a:  1960      str     r1, [r3]
0x0009360c:  7047      bx      lr

===== sub_0009f1fc @ 0x0009f1fc =====
0x0009f1fc:  30b5      push    {r4, r5, lr}
0x0009f1fe:  051c      adds    r5, r0, #0
0x0009f200:  081c      adds    r0, r1, #0
0x0009f202:  0c1c      adds    r4, r1, #0
0x0009f204:  39f00ef9  bl      #0xd8424  ; sub_000d8424
0x0009f208:  211c      adds    r1, r4, #0
0x0009f20a:  021c      adds    r2, r0, #0
0x0009f20c:  0023      movs    r3, #0
0x0009f20e:  6868      ldr     r0, [r5, #4]
0x0009f210:  12f07cf9  bl      #0xb150c  ; sub_000b150c
0x0009f214:  30bc      pop     {r4, r5}
0x0009f216:  02bc      pop     {r1}
0x0009f218:  0847      bx      r1
0x0009f21a:  0000      movs    r0, r0
0x0009f21c:  f0b5      push    {r4, r5, r6, r7, lr}
0x0009f21e:  037b      ldrb    r3, [r0, #0xc]
0x0009f220:  071c      adds    r7, r0, #0
0x0009f222:  84b0      sub     sp, #0x10
0x0009f224:  041c      adds    r4, r0, #0
0x0009f226:  0026      movs    r6, #0
0x0009f228:  1037      adds    r7, #0x10
0x0009f22a:  002b      cmp     r3, #0
0x0009f22c:  26d1      bne     #0x9f27c
0x0009f22e:  8368      ldr     r3, [r0, #8]
0x0009f230:  002b      cmp     r3, #0
0x0009f232:  46d1      bne     #0x9f2c2
0x0009f234:  437b      ldrb    r3, [r0, #0xd]
0x0009f236:  002b      cmp     r3, #0
0x0009f238:  41d0      beq     #0x9f2be
0x0009f23a:  4673      strb    r6, [r0, #0xd]
0x0009f23c:  4068      ldr     r0, [r0, #4]
0x0009f23e:  6c30      adds    r0, #0x6c
0x0009f240:  0df04cff  bl      #0xad0dc  ; sub_000ad0dc
0x0009f244:  1422      movs    r2, #0x14
0x0009f246:  011c      adds    r1, r0, #0
0x0009f248:  6846      mov     r0, sp
0x0009f24a:  0df033ff  bl      #0xad0b4  ; sub_000ad0b4
0x0009f24e:  10f00dfe  bl      #0xafe6c  ; sub_000afe6c
0x0009f252:  051e      subs    r5, r0, #0
0x0009f254:  48d0      beq     #0x9f2e8
0x0009f256:  0021      movs    r1, #0
0x0009f258:  281c      adds    r0, r5, #0
0x0009f25a:  0222      movs    r2, #2
0x0009f25c:  10f02cfc  bl      #0xafab8  ; sub_000afab8
0x0009f260:  281c      adds    r0, r5, #0
0x0009f262:  6946      mov     r1, sp
0x0009f264:  10f0b8ff  bl      #0xb01d8  ; sub_000b01d8
0x0009f268:  061e      subs    r6, r0, #0
0x0009f26a:  2cd0      beq     #0x9f2c6
0x0009f26c:  1f48      ldr     r0, [pc, #0x7c]  ; &"!FTPD-PORT:Bind"
0x0009f26e:  39f049fe  bl      #0xd8f04  ; sub_000d8f04
0x0009f272:  281c      adds    r0, r5, #0
0x0009f274:  13f0d8ff  bl      #0xb3228  ; sub_000b3228
0x0009f278:  301c      adds    r0, r6, #0
0x0009f27a:  06e0      b       #0x9f28a
0x0009f27c:  8068      ldr     r0, [r0, #8]
0x0009f27e:  0028      cmp     r0, #0
0x0009f280:  07d1      bne     #0x9f292
0x0009f282:  1b48      ldr     r0, [pc, #0x6c]  ; &"!FTPD-PASV:No port"
0x0009f284:  39f03efe  bl      #0xd8f04  ; sub_000d8f04
0x0009f288:  0120      movs    r0, #1
0x0009f28a:  04b0      add     sp, #0x10
0x0009f28c:  f0bc      pop     {r4, r5, r6, r7}
0x0009f28e:  02bc      pop     {r1}
0x0009f290:  0847      bx      r1
0x0009f292:  1849      ldr     r1, [pc, #0x60]
0x0009f294:  2673      strb    r6, [r4, #0xc]
0x0009f296:  11f05bf9  bl      #0xb0550  ; sub_000b0550
0x0009f29a:  a068      ldr     r0, [r4, #8]
0x0009f29c:  13f036ff  bl      #0xb310c  ; sub_000b310c
0x0009f2a0:  0122      movs    r2, #1
0x0009f2a2:  051c      adds    r5, r0, #0
0x0009f2a4:  0121      movs    r1, #1
0x0009f2a6:  a068      ldr     r0, [r4, #8]
0x0009f2a8:  5242      rsbs    r2, r2, #0
0x0009f2aa:  14f033ff  bl      #0xb4114  ; sub_000b4114
0x0009f2ae:  a068      ldr     r0, [r4, #8]
0x0009f2b0:  13f0baff  bl      #0xb3228  ; sub_000b3228
0x0009f2b4:  002d      cmp     r5, #0
0x0009f2b6:  15d0      beq     #0x9f2e4
0x0009f2b8:  0020      movs    r0, #0
0x0009f2ba:  a560      str     r5, [r4, #8]
0x0009f2bc:  e5e7      b       #0x9f28a
0x0009f2be:  0e48      ldr     r0, [pc, #0x38]  ; &"!FTPD-PORT:No port specified"
0x0009f2c0:  e0e7      b       #0x9f284
0x0009f2c2:  0e48      ldr     r0, [pc, #0x38]  ; &"!FTPD-PORT:Already open"
0x0009f2c4:  dee7      b       #0x9f284
0x0009f2c6:  281c      adds    r0, r5, #0
0x0009f2c8:  0a49      ldr     r1, [pc, #0x28]
0x0009f2ca:  11f041f9  bl      #0xb0550  ; sub_000b0550
0x0009f2ce:  281c      adds    r0, r5, #0
0x0009f2d0:  391c      adds    r1, r7, #0
0x0009f2d2:  12f031fa  bl      #0xb1738  ; sub_000b1738
0x0009f2d6:  061e      subs    r6, r0, #0
0x0009f2d8:  eed0      beq     #0x9f2b8
0x0009f2da:  0948      ldr     r0, [pc, #0x24]  ; &"!FTPD-PORT:Connect %SS"
0x0009f2dc:  391c      adds    r1, r7, #0
0x0009f2de:  39f011fe  bl      #0xd8f04  ; sub_000d8f04
0x0009f2e2:  c6e7      b       #0x9f272
0x0009f2e4:  0748      ldr     r0, [pc, #0x1c]  ; &"!FTPD-PASV:Accept"
0x0009f2e6:  cde7      b       #0x9f284
0x0009f2e8:  0748      ldr     r0, [pc, #0x1c]  ; &"!FTPD-PORT:No TCB"
0x0009f2ea:  cbe7      b       #0x9f284
0x0009f2ec:  f8df      svc     #0xf8
0x0009f2ee:  1000      movs    r0, r2
0x0009f2f0:  08e0      b       #0x9f304
0x0009f2f2:  1000      movs    r0, r2
0x0009f2f4:  1027      movs    r7, #0x10
0x0009f2f6:  0000      movs    r0, r0
0x0009f2f8:  1ce0      b       #0x9f334
0x0009f2fa:  1000      movs    r0, r2
0x0009f2fc:  3ce0      b       #0x9f378
0x0009f2fe:  1000      movs    r0, r2
0x0009f300:  54e0      b       #0x9f3ac
0x0009f302:  1000      movs    r0, r2
0x0009f304:  6ce0      b       #0x9f3e0
0x0009f306:  1000      movs    r0, r2
0x0009f308:  80e0      b       #0x9f40c
0x0009f30a:  1000      movs    r0, r2
0x0009f30c:  30b5      push    {r4, r5, lr}
0x0009f30e:  041c      adds    r4, r0, #0
0x0009f310:  8068      ldr     r0, [r0, #8]
0x0009f312:  0025      movs    r5, #0
0x0009f314:  0028      cmp     r0, #0
0x0009f316:  03d1      bne     #0x9f320
0x0009f318:  281c      adds    r0, r5, #0
0x0009f31a:  30bc      pop     {r4, r5}
0x0009f31c:  02bc      pop     {r1}
0x0009f31e:  0847      bx      r1
0x0009f320:  0122      movs    r2, #1
0x0009f322:  0121      movs    r1, #1
0x0009f324:  5242      rsbs    r2, r2, #0
0x0009f326:  14f0f5fe  bl      #0xb4114  ; sub_000b4114
0x0009f32a:  051c      adds    r5, r0, #0
0x0009f32c:  a068      ldr     r0, [r4, #8]
0x0009f32e:  13f07bff  bl      #0xb3228  ; sub_000b3228
0x0009f332:  0023      movs    r3, #0
0x0009f334:  a360      str     r3, [r4, #8]
0x0009f336:  efe7      b       #0x9f318
0x0009f338:  30b5      push    {r4, r5, lr}
0x0009f33a:  041c      adds    r4, r0, #0
0x0009f33c:  8068      ldr     r0, [r0, #8]
0x0009f33e:  0028      cmp     r0, #0
0x0009f340:  09d1      bne     #0x9f356
0x0009f342:  251c      adds    r5, r4, #0
0x0009f344:  c635      adds    r5, #0xc6
0x0009f346:  2b88      ldrh    r3, [r5]
0x0009f348:  002b      cmp     r3, #0
0x0009f34a:  10d1      bne     #0x9f36e
0x0009f34c:  0323      movs    r3, #3
0x0009f34e:  2384      strh    r3, [r4, #0x20]
0x0009f350:  30bc      pop     {r4, r5}
0x0009f352:  01bc      pop     {r0}
0x0009f354:  0047      bx      r0
0x0009f356:  13f003fe  bl      #0xb2f60  ; sub_000b2f60
0x0009f35a:  a068      ldr     r0, [r4, #8]
0x0009f35c:  13f064ff  bl      #0xb3228  ; sub_000b3228
0x0009f360:  251c      adds    r5, r4, #0
0x0009f362:  0023      movs    r3, #0
0x0009f364:  a360      str     r3, [r4, #8]
0x0009f366:  c635      adds    r5, #0xc6
0x0009f368:  2b88      ldrh    r3, [r5]
0x0009f36a:  002b      cmp     r3, #0
0x0009f36c:  eed0      beq     #0x9f34c
0x0009f36e:  231c      adds    r3, r4, #0
0x0009f370:  221c      adds    r2, r4, #0
0x0009f372:  c033      adds    r3, #0xc0
0x0009f374:  c432      adds    r2, #0xc4
0x0009f376:  1868      ldr     r0, [r3]
0x0009f378:  1188      ldrh    r1, [r2]
0x0009f37a:  2ef09bfa  bl      #0xcd8b4  ; sub_000cd8b4
0x0009f37e:  0023      movs    r3, #0
0x0009f380:  2b80      strh    r3, [r5]
0x0009f382:  e3e7      b       #0x9f34c
0x0009f384:  30b5      push    {r4, r5, lr}
0x0009f386:  041c      adds    r4, r0, #0
0x0009f388:  fff7e8fe  bl      #0x9f15c  ; sub_0009f15c
0x0009f38c:  051e      subs    r5, r0, #0
0x0009f38e:  45d0      beq     #0x9f41c
0x0009f390:  0123      movs    r3, #1
0x0009f392:  2b84      strh    r3, [r5, #0x20]
0x0009f394:  2b1c      adds    r3, r5, #0
0x0009f396:  b433      adds    r3, #0xb4
0x0009f398:  1a68      ldr     r2, [r3]
0x0009f39a:  6c60      str     r4, [r5, #4]
0x0009f39c:  0024      movs    r4, #0
0x0009f39e:  ec73      strb    r4, [r5, #0xf]
0x0009f3a0:  5368      ldr     r3, [r2, #4]
0x0009f3a2:  281c      adds    r0, r5, #0
0x0009f3a4:  ab62      str     r3, [r5, #0x28]
0x0009f3a6:  9368      ldr     r3, [r2, #8]
0x0009f3a8:  2a1c      adds    r2, r5, #0
0x0009f3aa:  ab85      strh    r3, [r5, #0x2c]
0x0009f3ac:  0023      movs    r3, #0
0x0009f3ae:  2b73      strb    r3, [r5, #0xc]
0x0009f3b0:  1e4b      ldr     r3, [pc, #0x78]
0x0009f3b2:  b832      adds    r2, #0xb8
0x0009f3b4:  1360      str     r3, [r2]
0x0009f3b6:  1e49      ldr     r1, [pc, #0x78]  ; &"unknown"
0x0009f3b8:  0822      movs    r2, #8
0x0009f3ba:  ac60      str     r4, [r5, #8]
0x0009f3bc:  ac84      strh    r4, [r5, #0x24]
0x0009f3be:  3830      adds    r0, #0x38
0x0009f3c0:  39f050fe  bl      #0xd9064  ; sub_000d9064
0x0009f3c4:  281c      adds    r0, r5, #0
0x0009f3c6:  2022      movs    r2, #0x20
0x0009f3c8:  1a49      ldr     r1, [pc, #0x68]  ; &"unknown"
0x0009f3ca:  4130      adds    r0, #0x41
0x0009f3cc:  39f04afe  bl      #0xd9064  ; sub_000d9064
0x0009f3d0:  2b1c      adds    r3, r5, #0
0x0009f3d2:  c033      adds    r3, #0xc0
0x0009f3d4:  1c60      str     r4, [r3]
0x0009f3d6:  0633      adds    r3, #6
0x0009f3d8:  1c80      strh    r4, [r3]
0x0009f3da:  281c      adds    r0, r5, #0

===== sub_000d60ac @ 0x000d60ac =====
0x000d60ac:  00b5      push    {lr}
0x000d60ae:  06f0ebfc  bl      #0xdca88  ; sub_000dca88
0x000d60b2:  044a      ldr     r2, [pc, #0x10]
0x000d60b4:  1388      ldrh    r3, [r2]
0x000d60b6:  0133      adds    r3, #1
0x000d60b8:  1380      strh    r3, [r2]
0x000d60ba:  06f0e9fc  bl      #0xdca90  ; sub_000dca90
0x000d60be:  01bc      pop     {r0}
0x000d60c0:  0047      bx      r0
0x000d60c2:  0000      movs    r0, r0
0x000d60c4:  d07c      ldrb    r0, [r2, #0x13]
0x000d60c6:  0800      movs    r0, r1
0x000d60c8:  10b5      push    {r4, lr}
0x000d60ca:  06f0ddfc  bl      #0xdca88  ; sub_000dca88
0x000d60ce:  084a      ldr     r2, [pc, #0x20]
0x000d60d0:  041c      adds    r4, r0, #0
0x000d60d2:  1388      ldrh    r3, [r2]
0x000d60d4:  013b      subs    r3, #1
0x000d60d6:  1380      strh    r3, [r2]
0x000d60d8:  1b04      lsls    r3, r3, #0x10
0x000d60da:  002b      cmp     r3, #0
0x000d60dc:  05d0      beq     #0xd60ea
0x000d60de:  201c      adds    r0, r4, #0
0x000d60e0:  06f0d6fc  bl      #0xdca90  ; sub_000dca90
0x000d60e4:  10bc      pop     {r4}
0x000d60e6:  01bc      pop     {r0}
0x000d60e8:  0047      bx      r0
0x000d60ea:  fff7b3ff  bl      #0xd6054  ; sub_000d6054
0x000d60ee:  f6e7      b       #0xd60de
0x000d60f0:  d07c      ldrb    r0, [r2, #0x13]
0x000d60f2:  0800      movs    r0, r1
0x000d60f4:  10b5      push    {r4, lr}
0x000d60f6:  064c      ldr     r4, [pc, #0x18]
0x000d60f8:  2288      ldrh    r2, [r4]
0x000d60fa:  002a      cmp     r2, #0
0x000d60fc:  04d0      beq     #0xd6108
0x000d60fe:  531c      adds    r3, r2, #1
0x000d6100:  2380      strh    r3, [r4]
0x000d6102:  10bc      pop     {r4}
0x000d6104:  01bc      pop     {r0}
0x000d6106:  0047      bx      r0
0x000d6108:  06f002fd  bl      #0xdcb10  ; sub_000dcb10
0x000d610c:  2288      ldrh    r2, [r4]
0x000d610e:  f6e7      b       #0xd60fe
0x000d6110:  1081      strh    r0, [r2, #8]
0x000d6112:  0800      movs    r0, r1
0x000d6114:  00b5      push    {lr}
0x000d6116:  064a      ldr     r2, [pc, #0x18]
0x000d6118:  1388      ldrh    r3, [r2]
0x000d611a:  013b      subs    r3, #1
0x000d611c:  1380      strh    r3, [r2]
0x000d611e:  1b04      lsls    r3, r3, #0x10
0x000d6120:  002b      cmp     r3, #0
0x000d6122:  01d0      beq     #0xd6128
0x000d6124:  01bc      pop     {r0}
0x000d6126:  0047      bx      r0
0x000d6128:  06f0f6fc  bl      #0xdcb18  ; sub_000dcb18
0x000d612c:  fae7      b       #0xd6124
0x000d612e:  0000      movs    r0, r0
0x000d6130:  1081      strh    r0, [r2, #8]
0x000d6132:  0800      movs    r0, r1
0x000d6134:  70b5      push    {r4, r5, r6, lr}
0x000d6136:  0268      ldr     r2, [r0]
0x000d6138:  051c      adds    r5, r0, #0
0x000d613a:  0e1c      adds    r6, r1, #0
0x000d613c:  0024      movs    r4, #0
0x000d613e:  0120      movs    r0, #1
0x000d6140:  08e0      b       #0xd6154
0x000d6142:  9368      ldr     r3, [r2, #8]
0x000d6144:  5988      ldrh    r1, [r3, #2]
0x000d6146:  8142      cmp     r1, r0
0x000d6148:  06d3      blo     #0xd6158
0x000d614a:  4b1c      adds    r3, r1, #1
0x000d614c:  1b04      lsls    r3, r3, #0x10
0x000d614e:  141c      adds    r4, r2, #0
0x000d6150:  1268      ldr     r2, [r2]
0x000d6152:  180c      lsrs    r0, r3, #0x10
0x000d6154:  002a      cmp     r2, #0
0x000d6156:  f4d1      bne     #0xd6142
0x000d6158:  321c      adds    r2, r6, #0
0x000d615a:  7080      strh    r0, [r6, #2]
0x000d615c:  211c      adds    r1, r4, #0
0x000d615e:  281c      adds    r0, r5, #0
0x000d6160:  0832      adds    r2, #8
0x000d6162:  03f037f9  bl      #0xd93d4  ; sub_000d93d4
0x000d6166:  70bc      pop     {r4, r5, r6}
0x000d6168:  01bc      pop     {r0}
0x000d616a:  0047      bx      r0
0x000d616c:  70b5      push    {r4, r5, r6, lr}
0x000d616e:  ca8e      ldrh    r2, [r1, #0x36]
0x000d6170:  4c69      ldr     r4, [r1, #0x14]
0x000d6172:  061c      adds    r6, r0, #0
0x000d6174:  0025      movs    r5, #0
0x000d6176:  05e0      b       #0xd6184
0x000d6178:  a368      ldr     r3, [r4, #8]
0x000d617a:  db8e      ldrh    r3, [r3, #0x36]
0x000d617c:  9342      cmp     r3, r2
0x000d617e:  03d1      bne     #0xd6188
0x000d6180:  251c      adds    r5, r4, #0
0x000d6182:  2468      ldr     r4, [r4]
0x000d6184:  002c      cmp     r4, #0
0x000d6186:  f7d1      bne     #0xd6178
0x000d6188:  0c1c      adds    r4, r1, #0
0x000d618a:  1434      adds    r4, #0x14
0x000d618c:  002d      cmp     r5, #0
0x000d618e:  0ad0      beq     #0xd61a6
0x000d6190:  ac42      cmp     r4, r5
0x000d6192:  08d0      beq     #0xd61a6
0x000d6194:  301c      adds    r0, r6, #0
0x000d6196:  211c      adds    r1, r4, #0
0x000d6198:  03f07af9  bl      #0xd9490  ; sub_000d9490
0x000d619c:  301c      adds    r0, r6, #0
0x000d619e:  291c      adds    r1, r5, #0
0x000d61a0:  221c      adds    r2, r4, #0
0x000d61a2:  03f017f9  bl      #0xd93d4  ; sub_000d93d4
0x000d61a6:  70bc      pop     {r4, r5, r6}
0x000d61a8:  01bc      pop     {r0}
0x000d61aa:  0047      bx      r0
0x000d61ac:  30b5      push    {r4, r5, lr}
0x000d61ae:  041c      adds    r4, r0, #0
0x000d61b0:  0d1c      adds    r5, r1, #0
0x000d61b2:  e88e      ldrh    r0, [r5, #0x36]
0x000d61b4:  2268      ldr     r2, [r4]
0x000d61b6:  0021      movs    r1, #0
0x000d61b8:  2c62      str     r4, [r5, #0x20]
0x000d61ba:  05e0      b       #0xd61c8
0x000d61bc:  9368      ldr     r3, [r2, #8]
0x000d61be:  db8e      ldrh    r3, [r3, #0x36]
0x000d61c0:  8342      cmp     r3, r0
0x000d61c2:  03d8      bhi     #0xd61cc
0x000d61c4:  111c      adds    r1, r2, #0
0x000d61c6:  1268      ldr     r2, [r2]
0x000d61c8:  002a      cmp     r2, #0
0x000d61ca:  f7d1      bne     #0xd61bc
0x000d61cc:  2a1c      adds    r2, r5, #0
0x000d61ce:  201c      adds    r0, r4, #0
0x000d61d0:  1432      adds    r2, #0x14
0x000d61d2:  03f0fff8  bl      #0xd93d4  ; sub_000d93d4
0x000d61d6:  30bc      pop     {r4, r5}
0x000d61d8:  01bc      pop     {r0}
0x000d61da:  0047      bx      r0
0x000d61dc:  10b5      push    {r4, lr}
0x000d61de:  041c      adds    r4, r0, #0
0x000d61e0:  211c      adds    r1, r4, #0
0x000d61e2:  0848      ldr     r0, [pc, #0x20]
0x000d61e4:  5431      adds    r1, #0x54
0x000d61e6:  03f053f9  bl      #0xd9490  ; sub_000d9490
0x000d61ea:  206a      ldr     r0, [r4, #0x20]
0x000d61ec:  0028      cmp     r0, #0
0x000d61ee:  04d1      bne     #0xd61fa
0x000d61f0:  0023      movs    r3, #0
0x000d61f2:  2362      str     r3, [r4, #0x20]
0x000d61f4:  10bc      pop     {r4}
0x000d61f6:  01bc      pop     {r0}
0x000d61f8:  0047      bx      r0
0x000d61fa:  211c      adds    r1, r4, #0
0x000d61fc:  1431      adds    r1, #0x14
0x000d61fe:  03f047f9  bl      #0xd9490  ; sub_000d9490
0x000d6202:  f5e7      b       #0xd61f0
0x000d6204:  807b      ldrb    r0, [r0, #0xe]
0x000d6206:  0800      movs    r0, r1
0x000d6208:  70b5      push    {r4, r5, r6, lr}
0x000d620a:  051c      adds    r5, r0, #0
0x000d620c:  06f03cfc  bl      #0xdca88  ; sub_000dca88
0x000d6210:  061c      adds    r6, r0, #0
0x000d6212:  002d      cmp     r5, #0
0x000d6214:  17d0      beq     #0xd6246
0x000d6216:  286a      ldr     r0, [r5, #0x20]
0x000d6218:  0028      cmp     r0, #0
0x000d621a:  0fd1      bne     #0xd623c
0x000d621c:  0024      movs    r4, #0
0x000d621e:  291c      adds    r1, r5, #0
0x000d6220:  0831      adds    r1, #8
0x000d6222:  2c62      str     r4, [r5, #0x20]
0x000d6224:  0948      ldr     r0, [pc, #0x24]
0x000d6226:  03f033f9  bl      #0xd9490  ; sub_000d9490
0x000d622a:  2c80      strh    r4, [r5]
0x000d622c:  fff712ff  bl      #0xd6054  ; sub_000d6054
0x000d6230:  301c      adds    r0, r6, #0
0x000d6232:  06f02dfc  bl      #0xdca90  ; sub_000dca90
0x000d6236:  70bc      pop     {r4, r5, r6}
0x000d6238:  01bc      pop     {r0}
0x000d623a:  0047      bx      r0
0x000d623c:  291c      adds    r1, r5, #0
0x000d623e:  1431      adds    r1, #0x14
0x000d6240:  03f026f9  bl      #0xd9490  ; sub_000d9490
0x000d6244:  eae7      b       #0xd621c
0x000d6246:  024b      ldr     r3, [pc, #8]
0x000d6248:  1d68      ldr     r5, [r3]
0x000d624a:  e4e7      b       #0xd6216
0x000d624c:  a07c      ldrb    r0, [r4, #0x12]
0x000d624e:  0800      movs    r0, r1
0x000d6250:  4081      strh    r0, [r0, #0xa]
0x000d6252:  0800      movs    r0, r1
0x000d6254:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d6256:  5746      mov     r7, sl
0x000d6258:  4646      mov     r6, r8
0x000d625a:  c0b4      push    {r6, r7}
0x000d625c:  071c      adds    r7, r0, #0
0x000d625e:  8a46      mov     sl, r1
0x000d6260:  0830      adds    r0, #8
0x000d6262:  391c      adds    r1, r7, #0
0x000d6264:  161c      adds    r6, r2, #0
0x000d6266:  9846      mov     r8, r3
0x000d6268:  079c      ldr     r4, [sp, #0x1c]
0x000d626a:  089d      ldr     r5, [sp, #0x20]
0x000d626c:  03f0acf8  bl      #0xd93c8  ; sub_000d93c8
0x000d6270:  381c      adds    r0, r7, #0
0x000d6272:  1430      adds    r0, #0x14
0x000d6274:  391c      adds    r1, r7, #0
0x000d6276:  03f0a7f8  bl      #0xd93c8  ; sub_000d93c8
0x000d627a:  381c      adds    r0, r7, #0
0x000d627c:  5430      adds    r0, #0x54
0x000d627e:  391c      adds    r1, r7, #0
0x000d6280:  03f0a2f8  bl      #0xd93c8  ; sub_000d93c8
0x000d6284:  184b      ldr     r3, [pc, #0x60]
0x000d6286:  4246      mov     r2, r8
0x000d6288:  fa62      str     r2, [r7, #0x2c]
0x000d628a:  2404      lsls    r4, r4, #0x10

===== sub_000d60c8 @ 0x000d60c8 =====
0x000d60c8:  10b5      push    {r4, lr}
0x000d60ca:  06f0ddfc  bl      #0xdca88  ; sub_000dca88
0x000d60ce:  084a      ldr     r2, [pc, #0x20]
0x000d60d0:  041c      adds    r4, r0, #0
0x000d60d2:  1388      ldrh    r3, [r2]
0x000d60d4:  013b      subs    r3, #1
0x000d60d6:  1380      strh    r3, [r2]
0x000d60d8:  1b04      lsls    r3, r3, #0x10
0x000d60da:  002b      cmp     r3, #0
0x000d60dc:  05d0      beq     #0xd60ea
0x000d60de:  201c      adds    r0, r4, #0
0x000d60e0:  06f0d6fc  bl      #0xdca90  ; sub_000dca90
0x000d60e4:  10bc      pop     {r4}
0x000d60e6:  01bc      pop     {r0}
0x000d60e8:  0047      bx      r0
0x000d60ea:  fff7b3ff  bl      #0xd6054  ; sub_000d6054
0x000d60ee:  f6e7      b       #0xd60de
0x000d60f0:  d07c      ldrb    r0, [r2, #0x13]
0x000d60f2:  0800      movs    r0, r1
0x000d60f4:  10b5      push    {r4, lr}
0x000d60f6:  064c      ldr     r4, [pc, #0x18]
0x000d60f8:  2288      ldrh    r2, [r4]
0x000d60fa:  002a      cmp     r2, #0
0x000d60fc:  04d0      beq     #0xd6108
0x000d60fe:  531c      adds    r3, r2, #1
0x000d6100:  2380      strh    r3, [r4]
0x000d6102:  10bc      pop     {r4}
0x000d6104:  01bc      pop     {r0}
0x000d6106:  0047      bx      r0
0x000d6108:  06f002fd  bl      #0xdcb10  ; sub_000dcb10
0x000d610c:  2288      ldrh    r2, [r4]
0x000d610e:  f6e7      b       #0xd60fe
0x000d6110:  1081      strh    r0, [r2, #8]
0x000d6112:  0800      movs    r0, r1
0x000d6114:  00b5      push    {lr}
0x000d6116:  064a      ldr     r2, [pc, #0x18]
0x000d6118:  1388      ldrh    r3, [r2]
0x000d611a:  013b      subs    r3, #1
0x000d611c:  1380      strh    r3, [r2]
0x000d611e:  1b04      lsls    r3, r3, #0x10
0x000d6120:  002b      cmp     r3, #0
0x000d6122:  01d0      beq     #0xd6128
0x000d6124:  01bc      pop     {r0}
0x000d6126:  0047      bx      r0
0x000d6128:  06f0f6fc  bl      #0xdcb18  ; sub_000dcb18
0x000d612c:  fae7      b       #0xd6124
0x000d612e:  0000      movs    r0, r0
0x000d6130:  1081      strh    r0, [r2, #8]
0x000d6132:  0800      movs    r0, r1
0x000d6134:  70b5      push    {r4, r5, r6, lr}
0x000d6136:  0268      ldr     r2, [r0]
0x000d6138:  051c      adds    r5, r0, #0
0x000d613a:  0e1c      adds    r6, r1, #0
0x000d613c:  0024      movs    r4, #0
0x000d613e:  0120      movs    r0, #1
0x000d6140:  08e0      b       #0xd6154
0x000d6142:  9368      ldr     r3, [r2, #8]
0x000d6144:  5988      ldrh    r1, [r3, #2]
0x000d6146:  8142      cmp     r1, r0
0x000d6148:  06d3      blo     #0xd6158
0x000d614a:  4b1c      adds    r3, r1, #1
0x000d614c:  1b04      lsls    r3, r3, #0x10
0x000d614e:  141c      adds    r4, r2, #0
0x000d6150:  1268      ldr     r2, [r2]
0x000d6152:  180c      lsrs    r0, r3, #0x10
0x000d6154:  002a      cmp     r2, #0
0x000d6156:  f4d1      bne     #0xd6142
0x000d6158:  321c      adds    r2, r6, #0
0x000d615a:  7080      strh    r0, [r6, #2]
0x000d615c:  211c      adds    r1, r4, #0
0x000d615e:  281c      adds    r0, r5, #0
0x000d6160:  0832      adds    r2, #8
0x000d6162:  03f037f9  bl      #0xd93d4  ; sub_000d93d4
0x000d6166:  70bc      pop     {r4, r5, r6}
0x000d6168:  01bc      pop     {r0}
0x000d616a:  0047      bx      r0
0x000d616c:  70b5      push    {r4, r5, r6, lr}
0x000d616e:  ca8e      ldrh    r2, [r1, #0x36]
0x000d6170:  4c69      ldr     r4, [r1, #0x14]
0x000d6172:  061c      adds    r6, r0, #0
0x000d6174:  0025      movs    r5, #0
0x000d6176:  05e0      b       #0xd6184
0x000d6178:  a368      ldr     r3, [r4, #8]
0x000d617a:  db8e      ldrh    r3, [r3, #0x36]
0x000d617c:  9342      cmp     r3, r2
0x000d617e:  03d1      bne     #0xd6188
0x000d6180:  251c      adds    r5, r4, #0
0x000d6182:  2468      ldr     r4, [r4]
0x000d6184:  002c      cmp     r4, #0
0x000d6186:  f7d1      bne     #0xd6178
0x000d6188:  0c1c      adds    r4, r1, #0
0x000d618a:  1434      adds    r4, #0x14
0x000d618c:  002d      cmp     r5, #0
0x000d618e:  0ad0      beq     #0xd61a6
0x000d6190:  ac42      cmp     r4, r5
0x000d6192:  08d0      beq     #0xd61a6
0x000d6194:  301c      adds    r0, r6, #0
0x000d6196:  211c      adds    r1, r4, #0
0x000d6198:  03f07af9  bl      #0xd9490  ; sub_000d9490
0x000d619c:  301c      adds    r0, r6, #0
0x000d619e:  291c      adds    r1, r5, #0
0x000d61a0:  221c      adds    r2, r4, #0
0x000d61a2:  03f017f9  bl      #0xd93d4  ; sub_000d93d4
0x000d61a6:  70bc      pop     {r4, r5, r6}
0x000d61a8:  01bc      pop     {r0}
0x000d61aa:  0047      bx      r0
0x000d61ac:  30b5      push    {r4, r5, lr}
0x000d61ae:  041c      adds    r4, r0, #0
0x000d61b0:  0d1c      adds    r5, r1, #0
0x000d61b2:  e88e      ldrh    r0, [r5, #0x36]
0x000d61b4:  2268      ldr     r2, [r4]
0x000d61b6:  0021      movs    r1, #0
0x000d61b8:  2c62      str     r4, [r5, #0x20]
0x000d61ba:  05e0      b       #0xd61c8
0x000d61bc:  9368      ldr     r3, [r2, #8]
0x000d61be:  db8e      ldrh    r3, [r3, #0x36]
0x000d61c0:  8342      cmp     r3, r0
0x000d61c2:  03d8      bhi     #0xd61cc
0x000d61c4:  111c      adds    r1, r2, #0
0x000d61c6:  1268      ldr     r2, [r2]
0x000d61c8:  002a      cmp     r2, #0
0x000d61ca:  f7d1      bne     #0xd61bc
0x000d61cc:  2a1c      adds    r2, r5, #0
0x000d61ce:  201c      adds    r0, r4, #0
0x000d61d0:  1432      adds    r2, #0x14
0x000d61d2:  03f0fff8  bl      #0xd93d4  ; sub_000d93d4
0x000d61d6:  30bc      pop     {r4, r5}
0x000d61d8:  01bc      pop     {r0}
0x000d61da:  0047      bx      r0
0x000d61dc:  10b5      push    {r4, lr}
0x000d61de:  041c      adds    r4, r0, #0
0x000d61e0:  211c      adds    r1, r4, #0
0x000d61e2:  0848      ldr     r0, [pc, #0x20]
0x000d61e4:  5431      adds    r1, #0x54
0x000d61e6:  03f053f9  bl      #0xd9490  ; sub_000d9490
0x000d61ea:  206a      ldr     r0, [r4, #0x20]
0x000d61ec:  0028      cmp     r0, #0
0x000d61ee:  04d1      bne     #0xd61fa
0x000d61f0:  0023      movs    r3, #0
0x000d61f2:  2362      str     r3, [r4, #0x20]
0x000d61f4:  10bc      pop     {r4}
0x000d61f6:  01bc      pop     {r0}
0x000d61f8:  0047      bx      r0
0x000d61fa:  211c      adds    r1, r4, #0
0x000d61fc:  1431      adds    r1, #0x14
0x000d61fe:  03f047f9  bl      #0xd9490  ; sub_000d9490
0x000d6202:  f5e7      b       #0xd61f0
0x000d6204:  807b      ldrb    r0, [r0, #0xe]
0x000d6206:  0800      movs    r0, r1
0x000d6208:  70b5      push    {r4, r5, r6, lr}
0x000d620a:  051c      adds    r5, r0, #0
0x000d620c:  06f03cfc  bl      #0xdca88  ; sub_000dca88
0x000d6210:  061c      adds    r6, r0, #0
0x000d6212:  002d      cmp     r5, #0
0x000d6214:  17d0      beq     #0xd6246
0x000d6216:  286a      ldr     r0, [r5, #0x20]
0x000d6218:  0028      cmp     r0, #0
0x000d621a:  0fd1      bne     #0xd623c
0x000d621c:  0024      movs    r4, #0
0x000d621e:  291c      adds    r1, r5, #0
0x000d6220:  0831      adds    r1, #8
0x000d6222:  2c62      str     r4, [r5, #0x20]
0x000d6224:  0948      ldr     r0, [pc, #0x24]
0x000d6226:  03f033f9  bl      #0xd9490  ; sub_000d9490
0x000d622a:  2c80      strh    r4, [r5]
0x000d622c:  fff712ff  bl      #0xd6054  ; sub_000d6054
0x000d6230:  301c      adds    r0, r6, #0
0x000d6232:  06f02dfc  bl      #0xdca90  ; sub_000dca90
0x000d6236:  70bc      pop     {r4, r5, r6}
0x000d6238:  01bc      pop     {r0}
0x000d623a:  0047      bx      r0
0x000d623c:  291c      adds    r1, r5, #0
0x000d623e:  1431      adds    r1, #0x14
0x000d6240:  03f026f9  bl      #0xd9490  ; sub_000d9490
0x000d6244:  eae7      b       #0xd621c
0x000d6246:  024b      ldr     r3, [pc, #8]
0x000d6248:  1d68      ldr     r5, [r3]
0x000d624a:  e4e7      b       #0xd6216
0x000d624c:  a07c      ldrb    r0, [r4, #0x12]
0x000d624e:  0800      movs    r0, r1
0x000d6250:  4081      strh    r0, [r0, #0xa]
0x000d6252:  0800      movs    r0, r1
0x000d6254:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d6256:  5746      mov     r7, sl
0x000d6258:  4646      mov     r6, r8
0x000d625a:  c0b4      push    {r6, r7}
0x000d625c:  071c      adds    r7, r0, #0
0x000d625e:  8a46      mov     sl, r1
0x000d6260:  0830      adds    r0, #8
0x000d6262:  391c      adds    r1, r7, #0
0x000d6264:  161c      adds    r6, r2, #0
0x000d6266:  9846      mov     r8, r3
0x000d6268:  079c      ldr     r4, [sp, #0x1c]
0x000d626a:  089d      ldr     r5, [sp, #0x20]
0x000d626c:  03f0acf8  bl      #0xd93c8  ; sub_000d93c8
0x000d6270:  381c      adds    r0, r7, #0
0x000d6272:  1430      adds    r0, #0x14
0x000d6274:  391c      adds    r1, r7, #0
0x000d6276:  03f0a7f8  bl      #0xd93c8  ; sub_000d93c8
0x000d627a:  381c      adds    r0, r7, #0
0x000d627c:  5430      adds    r0, #0x54
0x000d627e:  391c      adds    r1, r7, #0
0x000d6280:  03f0a2f8  bl      #0xd93c8  ; sub_000d93c8
0x000d6284:  184b      ldr     r3, [pc, #0x60]
0x000d6286:  4246      mov     r2, r8
0x000d6288:  fa62      str     r2, [r7, #0x2c]
0x000d628a:  2404      lsls    r4, r4, #0x10
0x000d628c:  0122      movs    r2, #1
0x000d628e:  3b80      strh    r3, [r7]
0x000d6290:  3a86      strh    r2, [r7, #0x30]
0x000d6292:  0023      movs    r3, #0
0x000d6294:  7a86      strh    r2, [r7, #0x32]
0x000d6296:  240c      lsrs    r4, r4, #0x10
0x000d6298:  5246      mov     r2, sl
0x000d629a:  7b60      str     r3, [r7, #4]
0x000d629c:  3b62      str     r3, [r7, #0x20]
0x000d629e:  bb86      strh    r3, [r7, #0x34]
0x000d62a0:  3b87      strh    r3, [r7, #0x38]
0x000d62a2:  7b87      strh    r3, [r7, #0x3a]
0x000d62a4:  bb87      strh    r3, [r7, #0x3c]
0x000d62a6:  fb87      strh    r3, [r7, #0x3e]

===== sub_000d60f4 @ 0x000d60f4 =====
0x000d60f4:  10b5      push    {r4, lr}
0x000d60f6:  064c      ldr     r4, [pc, #0x18]
0x000d60f8:  2288      ldrh    r2, [r4]
0x000d60fa:  002a      cmp     r2, #0
0x000d60fc:  04d0      beq     #0xd6108
0x000d60fe:  531c      adds    r3, r2, #1
0x000d6100:  2380      strh    r3, [r4]
0x000d6102:  10bc      pop     {r4}
0x000d6104:  01bc      pop     {r0}
0x000d6106:  0047      bx      r0
0x000d6108:  06f002fd  bl      #0xdcb10  ; sub_000dcb10
0x000d610c:  2288      ldrh    r2, [r4]
0x000d610e:  f6e7      b       #0xd60fe
0x000d6110:  1081      strh    r0, [r2, #8]
0x000d6112:  0800      movs    r0, r1
0x000d6114:  00b5      push    {lr}
0x000d6116:  064a      ldr     r2, [pc, #0x18]
0x000d6118:  1388      ldrh    r3, [r2]
0x000d611a:  013b      subs    r3, #1
0x000d611c:  1380      strh    r3, [r2]
0x000d611e:  1b04      lsls    r3, r3, #0x10
0x000d6120:  002b      cmp     r3, #0
0x000d6122:  01d0      beq     #0xd6128
0x000d6124:  01bc      pop     {r0}
0x000d6126:  0047      bx      r0
0x000d6128:  06f0f6fc  bl      #0xdcb18  ; sub_000dcb18
0x000d612c:  fae7      b       #0xd6124
0x000d612e:  0000      movs    r0, r0
0x000d6130:  1081      strh    r0, [r2, #8]
0x000d6132:  0800      movs    r0, r1
0x000d6134:  70b5      push    {r4, r5, r6, lr}
0x000d6136:  0268      ldr     r2, [r0]
0x000d6138:  051c      adds    r5, r0, #0
0x000d613a:  0e1c      adds    r6, r1, #0
0x000d613c:  0024      movs    r4, #0
0x000d613e:  0120      movs    r0, #1
0x000d6140:  08e0      b       #0xd6154
0x000d6142:  9368      ldr     r3, [r2, #8]
0x000d6144:  5988      ldrh    r1, [r3, #2]
0x000d6146:  8142      cmp     r1, r0
0x000d6148:  06d3      blo     #0xd6158
0x000d614a:  4b1c      adds    r3, r1, #1
0x000d614c:  1b04      lsls    r3, r3, #0x10
0x000d614e:  141c      adds    r4, r2, #0
0x000d6150:  1268      ldr     r2, [r2]
0x000d6152:  180c      lsrs    r0, r3, #0x10
0x000d6154:  002a      cmp     r2, #0
0x000d6156:  f4d1      bne     #0xd6142
0x000d6158:  321c      adds    r2, r6, #0
0x000d615a:  7080      strh    r0, [r6, #2]
0x000d615c:  211c      adds    r1, r4, #0
0x000d615e:  281c      adds    r0, r5, #0
0x000d6160:  0832      adds    r2, #8
0x000d6162:  03f037f9  bl      #0xd93d4  ; sub_000d93d4
0x000d6166:  70bc      pop     {r4, r5, r6}
0x000d6168:  01bc      pop     {r0}
0x000d616a:  0047      bx      r0
0x000d616c:  70b5      push    {r4, r5, r6, lr}
0x000d616e:  ca8e      ldrh    r2, [r1, #0x36]
0x000d6170:  4c69      ldr     r4, [r1, #0x14]
0x000d6172:  061c      adds    r6, r0, #0
0x000d6174:  0025      movs    r5, #0
0x000d6176:  05e0      b       #0xd6184
0x000d6178:  a368      ldr     r3, [r4, #8]
0x000d617a:  db8e      ldrh    r3, [r3, #0x36]
0x000d617c:  9342      cmp     r3, r2
0x000d617e:  03d1      bne     #0xd6188
0x000d6180:  251c      adds    r5, r4, #0
0x000d6182:  2468      ldr     r4, [r4]
0x000d6184:  002c      cmp     r4, #0
0x000d6186:  f7d1      bne     #0xd6178
0x000d6188:  0c1c      adds    r4, r1, #0
0x000d618a:  1434      adds    r4, #0x14
0x000d618c:  002d      cmp     r5, #0
0x000d618e:  0ad0      beq     #0xd61a6
0x000d6190:  ac42      cmp     r4, r5
0x000d6192:  08d0      beq     #0xd61a6
0x000d6194:  301c      adds    r0, r6, #0
0x000d6196:  211c      adds    r1, r4, #0
0x000d6198:  03f07af9  bl      #0xd9490  ; sub_000d9490
0x000d619c:  301c      adds    r0, r6, #0
0x000d619e:  291c      adds    r1, r5, #0
0x000d61a0:  221c      adds    r2, r4, #0
0x000d61a2:  03f017f9  bl      #0xd93d4  ; sub_000d93d4
0x000d61a6:  70bc      pop     {r4, r5, r6}
0x000d61a8:  01bc      pop     {r0}
0x000d61aa:  0047      bx      r0
0x000d61ac:  30b5      push    {r4, r5, lr}
0x000d61ae:  041c      adds    r4, r0, #0
0x000d61b0:  0d1c      adds    r5, r1, #0
0x000d61b2:  e88e      ldrh    r0, [r5, #0x36]
0x000d61b4:  2268      ldr     r2, [r4]
0x000d61b6:  0021      movs    r1, #0
0x000d61b8:  2c62      str     r4, [r5, #0x20]
0x000d61ba:  05e0      b       #0xd61c8
0x000d61bc:  9368      ldr     r3, [r2, #8]
0x000d61be:  db8e      ldrh    r3, [r3, #0x36]
0x000d61c0:  8342      cmp     r3, r0
0x000d61c2:  03d8      bhi     #0xd61cc
0x000d61c4:  111c      adds    r1, r2, #0
0x000d61c6:  1268      ldr     r2, [r2]
0x000d61c8:  002a      cmp     r2, #0
0x000d61ca:  f7d1      bne     #0xd61bc
0x000d61cc:  2a1c      adds    r2, r5, #0
0x000d61ce:  201c      adds    r0, r4, #0
0x000d61d0:  1432      adds    r2, #0x14
0x000d61d2:  03f0fff8  bl      #0xd93d4  ; sub_000d93d4
0x000d61d6:  30bc      pop     {r4, r5}
0x000d61d8:  01bc      pop     {r0}
0x000d61da:  0047      bx      r0
0x000d61dc:  10b5      push    {r4, lr}
0x000d61de:  041c      adds    r4, r0, #0
0x000d61e0:  211c      adds    r1, r4, #0
0x000d61e2:  0848      ldr     r0, [pc, #0x20]
0x000d61e4:  5431      adds    r1, #0x54
0x000d61e6:  03f053f9  bl      #0xd9490  ; sub_000d9490
0x000d61ea:  206a      ldr     r0, [r4, #0x20]
0x000d61ec:  0028      cmp     r0, #0
0x000d61ee:  04d1      bne     #0xd61fa
0x000d61f0:  0023      movs    r3, #0
0x000d61f2:  2362      str     r3, [r4, #0x20]
0x000d61f4:  10bc      pop     {r4}
0x000d61f6:  01bc      pop     {r0}
0x000d61f8:  0047      bx      r0
0x000d61fa:  211c      adds    r1, r4, #0
0x000d61fc:  1431      adds    r1, #0x14
0x000d61fe:  03f047f9  bl      #0xd9490  ; sub_000d9490
0x000d6202:  f5e7      b       #0xd61f0
0x000d6204:  807b      ldrb    r0, [r0, #0xe]
0x000d6206:  0800      movs    r0, r1
0x000d6208:  70b5      push    {r4, r5, r6, lr}
0x000d620a:  051c      adds    r5, r0, #0
0x000d620c:  06f03cfc  bl      #0xdca88  ; sub_000dca88
0x000d6210:  061c      adds    r6, r0, #0
0x000d6212:  002d      cmp     r5, #0
0x000d6214:  17d0      beq     #0xd6246
0x000d6216:  286a      ldr     r0, [r5, #0x20]
0x000d6218:  0028      cmp     r0, #0
0x000d621a:  0fd1      bne     #0xd623c
0x000d621c:  0024      movs    r4, #0
0x000d621e:  291c      adds    r1, r5, #0
0x000d6220:  0831      adds    r1, #8
0x000d6222:  2c62      str     r4, [r5, #0x20]
0x000d6224:  0948      ldr     r0, [pc, #0x24]
0x000d6226:  03f033f9  bl      #0xd9490  ; sub_000d9490
0x000d622a:  2c80      strh    r4, [r5]
0x000d622c:  fff712ff  bl      #0xd6054  ; sub_000d6054
0x000d6230:  301c      adds    r0, r6, #0
0x000d6232:  06f02dfc  bl      #0xdca90  ; sub_000dca90
0x000d6236:  70bc      pop     {r4, r5, r6}
0x000d6238:  01bc      pop     {r0}
0x000d623a:  0047      bx      r0
0x000d623c:  291c      adds    r1, r5, #0
0x000d623e:  1431      adds    r1, #0x14
0x000d6240:  03f026f9  bl      #0xd9490  ; sub_000d9490
0x000d6244:  eae7      b       #0xd621c
0x000d6246:  024b      ldr     r3, [pc, #8]
0x000d6248:  1d68      ldr     r5, [r3]
0x000d624a:  e4e7      b       #0xd6216
0x000d624c:  a07c      ldrb    r0, [r4, #0x12]
0x000d624e:  0800      movs    r0, r1
0x000d6250:  4081      strh    r0, [r0, #0xa]
0x000d6252:  0800      movs    r0, r1
0x000d6254:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d6256:  5746      mov     r7, sl
0x000d6258:  4646      mov     r6, r8
0x000d625a:  c0b4      push    {r6, r7}
0x000d625c:  071c      adds    r7, r0, #0
0x000d625e:  8a46      mov     sl, r1
0x000d6260:  0830      adds    r0, #8
0x000d6262:  391c      adds    r1, r7, #0
0x000d6264:  161c      adds    r6, r2, #0
0x000d6266:  9846      mov     r8, r3
0x000d6268:  079c      ldr     r4, [sp, #0x1c]
0x000d626a:  089d      ldr     r5, [sp, #0x20]
0x000d626c:  03f0acf8  bl      #0xd93c8  ; sub_000d93c8
0x000d6270:  381c      adds    r0, r7, #0
0x000d6272:  1430      adds    r0, #0x14
0x000d6274:  391c      adds    r1, r7, #0
0x000d6276:  03f0a7f8  bl      #0xd93c8  ; sub_000d93c8
0x000d627a:  381c      adds    r0, r7, #0
0x000d627c:  5430      adds    r0, #0x54
0x000d627e:  391c      adds    r1, r7, #0
0x000d6280:  03f0a2f8  bl      #0xd93c8  ; sub_000d93c8
0x000d6284:  184b      ldr     r3, [pc, #0x60]
0x000d6286:  4246      mov     r2, r8
0x000d6288:  fa62      str     r2, [r7, #0x2c]
0x000d628a:  2404      lsls    r4, r4, #0x10
0x000d628c:  0122      movs    r2, #1
0x000d628e:  3b80      strh    r3, [r7]
0x000d6290:  3a86      strh    r2, [r7, #0x30]
0x000d6292:  0023      movs    r3, #0
0x000d6294:  7a86      strh    r2, [r7, #0x32]
0x000d6296:  240c      lsrs    r4, r4, #0x10
0x000d6298:  5246      mov     r2, sl
0x000d629a:  7b60      str     r3, [r7, #4]
0x000d629c:  3b62      str     r3, [r7, #0x20]
0x000d629e:  bb86      strh    r3, [r7, #0x34]
0x000d62a0:  3b87      strh    r3, [r7, #0x38]
0x000d62a2:  7b87      strh    r3, [r7, #0x3a]
0x000d62a4:  bb87      strh    r3, [r7, #0x3c]
0x000d62a6:  fb87      strh    r3, [r7, #0x3e]
0x000d62a8:  3b64      str     r3, [r7, #0x40]
0x000d62aa:  7b64      str     r3, [r7, #0x44]
0x000d62ac:  fb64      str     r3, [r7, #0x4c]
0x000d62ae:  4146      mov     r1, r8
0x000d62b0:  be62      str     r6, [r7, #0x28]
0x000d62b2:  fc86      strh    r4, [r7, #0x36]
0x000d62b4:  ba64      str     r2, [r7, #0x48]
0x000d62b6:  301c      adds    r0, r6, #0
0x000d62b8:  01f098fa  bl      #0xd77ec  ; sub_000d77ec
0x000d62bc:  2d04      lsls    r5, r5, #0x10
0x000d62be:  2d0c      lsrs    r5, r5, #0x10
0x000d62c0:  7862      str     r0, [r7, #0x24]
0x000d62c2:  391c      adds    r1, r7, #0
0x000d62c4:  0948      ldr     r0, [pc, #0x24]
0x000d62c6:  fff735ff  bl      #0xd6134  ; sub_000d6134
0x000d62ca:  eb07      lsls    r3, r5, #0x1f
0x000d62cc:  09d5      bpl     #0xd62e2
0x000d62ce:  0848      ldr     r0, [pc, #0x20]
0x000d62d0:  391c      adds    r1, r7, #0

===== sub_000d6114 @ 0x000d6114 =====
0x000d6114:  00b5      push    {lr}
0x000d6116:  064a      ldr     r2, [pc, #0x18]
0x000d6118:  1388      ldrh    r3, [r2]
0x000d611a:  013b      subs    r3, #1
0x000d611c:  1380      strh    r3, [r2]
0x000d611e:  1b04      lsls    r3, r3, #0x10
0x000d6120:  002b      cmp     r3, #0
0x000d6122:  01d0      beq     #0xd6128
0x000d6124:  01bc      pop     {r0}
0x000d6126:  0047      bx      r0
0x000d6128:  06f0f6fc  bl      #0xdcb18  ; sub_000dcb18
0x000d612c:  fae7      b       #0xd6124
0x000d612e:  0000      movs    r0, r0
0x000d6130:  1081      strh    r0, [r2, #8]
0x000d6132:  0800      movs    r0, r1
0x000d6134:  70b5      push    {r4, r5, r6, lr}
0x000d6136:  0268      ldr     r2, [r0]
0x000d6138:  051c      adds    r5, r0, #0
0x000d613a:  0e1c      adds    r6, r1, #0
0x000d613c:  0024      movs    r4, #0
0x000d613e:  0120      movs    r0, #1
0x000d6140:  08e0      b       #0xd6154
0x000d6142:  9368      ldr     r3, [r2, #8]
0x000d6144:  5988      ldrh    r1, [r3, #2]
0x000d6146:  8142      cmp     r1, r0
0x000d6148:  06d3      blo     #0xd6158
0x000d614a:  4b1c      adds    r3, r1, #1
0x000d614c:  1b04      lsls    r3, r3, #0x10
0x000d614e:  141c      adds    r4, r2, #0
0x000d6150:  1268      ldr     r2, [r2]
0x000d6152:  180c      lsrs    r0, r3, #0x10
0x000d6154:  002a      cmp     r2, #0
0x000d6156:  f4d1      bne     #0xd6142
0x000d6158:  321c      adds    r2, r6, #0
0x000d615a:  7080      strh    r0, [r6, #2]
0x000d615c:  211c      adds    r1, r4, #0
0x000d615e:  281c      adds    r0, r5, #0
0x000d6160:  0832      adds    r2, #8
0x000d6162:  03f037f9  bl      #0xd93d4  ; sub_000d93d4
0x000d6166:  70bc      pop     {r4, r5, r6}
0x000d6168:  01bc      pop     {r0}
0x000d616a:  0047      bx      r0
0x000d616c:  70b5      push    {r4, r5, r6, lr}
0x000d616e:  ca8e      ldrh    r2, [r1, #0x36]
0x000d6170:  4c69      ldr     r4, [r1, #0x14]
0x000d6172:  061c      adds    r6, r0, #0
0x000d6174:  0025      movs    r5, #0
0x000d6176:  05e0      b       #0xd6184
0x000d6178:  a368      ldr     r3, [r4, #8]
0x000d617a:  db8e      ldrh    r3, [r3, #0x36]
0x000d617c:  9342      cmp     r3, r2
0x000d617e:  03d1      bne     #0xd6188
0x000d6180:  251c      adds    r5, r4, #0
0x000d6182:  2468      ldr     r4, [r4]
0x000d6184:  002c      cmp     r4, #0
0x000d6186:  f7d1      bne     #0xd6178
0x000d6188:  0c1c      adds    r4, r1, #0
0x000d618a:  1434      adds    r4, #0x14
0x000d618c:  002d      cmp     r5, #0
0x000d618e:  0ad0      beq     #0xd61a6
0x000d6190:  ac42      cmp     r4, r5
0x000d6192:  08d0      beq     #0xd61a6
0x000d6194:  301c      adds    r0, r6, #0
0x000d6196:  211c      adds    r1, r4, #0
0x000d6198:  03f07af9  bl      #0xd9490  ; sub_000d9490
0x000d619c:  301c      adds    r0, r6, #0
0x000d619e:  291c      adds    r1, r5, #0
0x000d61a0:  221c      adds    r2, r4, #0
0x000d61a2:  03f017f9  bl      #0xd93d4  ; sub_000d93d4
0x000d61a6:  70bc      pop     {r4, r5, r6}
0x000d61a8:  01bc      pop     {r0}
0x000d61aa:  0047      bx      r0
0x000d61ac:  30b5      push    {r4, r5, lr}
0x000d61ae:  041c      adds    r4, r0, #0
0x000d61b0:  0d1c      adds    r5, r1, #0
0x000d61b2:  e88e      ldrh    r0, [r5, #0x36]
0x000d61b4:  2268      ldr     r2, [r4]
0x000d61b6:  0021      movs    r1, #0
0x000d61b8:  2c62      str     r4, [r5, #0x20]
0x000d61ba:  05e0      b       #0xd61c8
0x000d61bc:  9368      ldr     r3, [r2, #8]
0x000d61be:  db8e      ldrh    r3, [r3, #0x36]
0x000d61c0:  8342      cmp     r3, r0
0x000d61c2:  03d8      bhi     #0xd61cc
0x000d61c4:  111c      adds    r1, r2, #0
0x000d61c6:  1268      ldr     r2, [r2]
0x000d61c8:  002a      cmp     r2, #0
0x000d61ca:  f7d1      bne     #0xd61bc
0x000d61cc:  2a1c      adds    r2, r5, #0
0x000d61ce:  201c      adds    r0, r4, #0
0x000d61d0:  1432      adds    r2, #0x14
0x000d61d2:  03f0fff8  bl      #0xd93d4  ; sub_000d93d4
0x000d61d6:  30bc      pop     {r4, r5}
0x000d61d8:  01bc      pop     {r0}
0x000d61da:  0047      bx      r0
0x000d61dc:  10b5      push    {r4, lr}
0x000d61de:  041c      adds    r4, r0, #0
0x000d61e0:  211c      adds    r1, r4, #0
0x000d61e2:  0848      ldr     r0, [pc, #0x20]
0x000d61e4:  5431      adds    r1, #0x54
0x000d61e6:  03f053f9  bl      #0xd9490  ; sub_000d9490
0x000d61ea:  206a      ldr     r0, [r4, #0x20]
0x000d61ec:  0028      cmp     r0, #0
0x000d61ee:  04d1      bne     #0xd61fa
0x000d61f0:  0023      movs    r3, #0
0x000d61f2:  2362      str     r3, [r4, #0x20]
0x000d61f4:  10bc      pop     {r4}
0x000d61f6:  01bc      pop     {r0}
0x000d61f8:  0047      bx      r0
0x000d61fa:  211c      adds    r1, r4, #0
0x000d61fc:  1431      adds    r1, #0x14
0x000d61fe:  03f047f9  bl      #0xd9490  ; sub_000d9490
0x000d6202:  f5e7      b       #0xd61f0
0x000d6204:  807b      ldrb    r0, [r0, #0xe]
0x000d6206:  0800      movs    r0, r1
0x000d6208:  70b5      push    {r4, r5, r6, lr}
0x000d620a:  051c      adds    r5, r0, #0
0x000d620c:  06f03cfc  bl      #0xdca88  ; sub_000dca88
0x000d6210:  061c      adds    r6, r0, #0
0x000d6212:  002d      cmp     r5, #0
0x000d6214:  17d0      beq     #0xd6246
0x000d6216:  286a      ldr     r0, [r5, #0x20]
0x000d6218:  0028      cmp     r0, #0
0x000d621a:  0fd1      bne     #0xd623c
0x000d621c:  0024      movs    r4, #0
0x000d621e:  291c      adds    r1, r5, #0
0x000d6220:  0831      adds    r1, #8
0x000d6222:  2c62      str     r4, [r5, #0x20]
0x000d6224:  0948      ldr     r0, [pc, #0x24]
0x000d6226:  03f033f9  bl      #0xd9490  ; sub_000d9490
0x000d622a:  2c80      strh    r4, [r5]
0x000d622c:  fff712ff  bl      #0xd6054  ; sub_000d6054
0x000d6230:  301c      adds    r0, r6, #0
0x000d6232:  06f02dfc  bl      #0xdca90  ; sub_000dca90
0x000d6236:  70bc      pop     {r4, r5, r6}
0x000d6238:  01bc      pop     {r0}
0x000d623a:  0047      bx      r0
0x000d623c:  291c      adds    r1, r5, #0
0x000d623e:  1431      adds    r1, #0x14
0x000d6240:  03f026f9  bl      #0xd9490  ; sub_000d9490
0x000d6244:  eae7      b       #0xd621c
0x000d6246:  024b      ldr     r3, [pc, #8]
0x000d6248:  1d68      ldr     r5, [r3]
0x000d624a:  e4e7      b       #0xd6216
0x000d624c:  a07c      ldrb    r0, [r4, #0x12]
0x000d624e:  0800      movs    r0, r1
0x000d6250:  4081      strh    r0, [r0, #0xa]
0x000d6252:  0800      movs    r0, r1
0x000d6254:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d6256:  5746      mov     r7, sl
0x000d6258:  4646      mov     r6, r8
0x000d625a:  c0b4      push    {r6, r7}
0x000d625c:  071c      adds    r7, r0, #0
0x000d625e:  8a46      mov     sl, r1
0x000d6260:  0830      adds    r0, #8
0x000d6262:  391c      adds    r1, r7, #0
0x000d6264:  161c      adds    r6, r2, #0
0x000d6266:  9846      mov     r8, r3
0x000d6268:  079c      ldr     r4, [sp, #0x1c]
0x000d626a:  089d      ldr     r5, [sp, #0x20]
0x000d626c:  03f0acf8  bl      #0xd93c8  ; sub_000d93c8
0x000d6270:  381c      adds    r0, r7, #0
0x000d6272:  1430      adds    r0, #0x14
0x000d6274:  391c      adds    r1, r7, #0
0x000d6276:  03f0a7f8  bl      #0xd93c8  ; sub_000d93c8
0x000d627a:  381c      adds    r0, r7, #0
0x000d627c:  5430      adds    r0, #0x54
0x000d627e:  391c      adds    r1, r7, #0
0x000d6280:  03f0a2f8  bl      #0xd93c8  ; sub_000d93c8
0x000d6284:  184b      ldr     r3, [pc, #0x60]
0x000d6286:  4246      mov     r2, r8
0x000d6288:  fa62      str     r2, [r7, #0x2c]
0x000d628a:  2404      lsls    r4, r4, #0x10
0x000d628c:  0122      movs    r2, #1
0x000d628e:  3b80      strh    r3, [r7]
0x000d6290:  3a86      strh    r2, [r7, #0x30]
0x000d6292:  0023      movs    r3, #0
0x000d6294:  7a86      strh    r2, [r7, #0x32]
0x000d6296:  240c      lsrs    r4, r4, #0x10
0x000d6298:  5246      mov     r2, sl
0x000d629a:  7b60      str     r3, [r7, #4]
0x000d629c:  3b62      str     r3, [r7, #0x20]
0x000d629e:  bb86      strh    r3, [r7, #0x34]
0x000d62a0:  3b87      strh    r3, [r7, #0x38]
0x000d62a2:  7b87      strh    r3, [r7, #0x3a]
0x000d62a4:  bb87      strh    r3, [r7, #0x3c]
0x000d62a6:  fb87      strh    r3, [r7, #0x3e]
0x000d62a8:  3b64      str     r3, [r7, #0x40]
0x000d62aa:  7b64      str     r3, [r7, #0x44]
0x000d62ac:  fb64      str     r3, [r7, #0x4c]
0x000d62ae:  4146      mov     r1, r8
0x000d62b0:  be62      str     r6, [r7, #0x28]
0x000d62b2:  fc86      strh    r4, [r7, #0x36]
0x000d62b4:  ba64      str     r2, [r7, #0x48]
0x000d62b6:  301c      adds    r0, r6, #0
0x000d62b8:  01f098fa  bl      #0xd77ec  ; sub_000d77ec
0x000d62bc:  2d04      lsls    r5, r5, #0x10
0x000d62be:  2d0c      lsrs    r5, r5, #0x10
0x000d62c0:  7862      str     r0, [r7, #0x24]
0x000d62c2:  391c      adds    r1, r7, #0
0x000d62c4:  0948      ldr     r0, [pc, #0x24]
0x000d62c6:  fff735ff  bl      #0xd6134  ; sub_000d6134
0x000d62ca:  eb07      lsls    r3, r5, #0x1f
0x000d62cc:  09d5      bpl     #0xd62e2
0x000d62ce:  0848      ldr     r0, [pc, #0x20]
0x000d62d0:  391c      adds    r1, r7, #0
0x000d62d2:  fff76bff  bl      #0xd61ac  ; sub_000d61ac
0x000d62d6:  18bc      pop     {r3, r4}
0x000d62d8:  9846      mov     r8, r3
0x000d62da:  a246      mov     sl, r4
0x000d62dc:  f0bc      pop     {r4, r5, r6, r7}
0x000d62de:  01bc      pop     {r0}
0x000d62e0:  0047      bx      r0
0x000d62e2:  0448      ldr     r0, [pc, #0x10]
0x000d62e4:  f4e7      b       #0xd62d0
0x000d62e6:  0000      movs    r0, r0
0x000d62e8:  4154      strb    r1, [r0, r1]
0x000d62ea:  0000      movs    r0, r0
0x000d62ec:  a07c      ldrb    r0, [r4, #0x12]
0x000d62ee:  0800      movs    r0, r1
0x000d62f0:  007c      ldrb    r0, [r0, #0x10]
0x000d62f2:  0800      movs    r0, r1

===== sub_000d6564 @ 0x000d6564 =====
0x000d6564:  30b5      push    {r4, r5, lr}
0x000d6566:  041c      adds    r4, r0, #0
0x000d6568:  0d04      lsls    r5, r1, #0x10
0x000d656a:  0830      adds    r0, #8
0x000d656c:  211c      adds    r1, r4, #0
0x000d656e:  02f02bff  bl      #0xd93c8  ; sub_000d93c8
0x000d6572:  0a4b      ldr     r3, [pc, #0x28]
0x000d6574:  2d0c      lsrs    r5, r5, #0x10
0x000d6576:  2380      strh    r3, [r4]
0x000d6578:  0023      movs    r3, #0
0x000d657a:  6360      str     r3, [r4, #4]
0x000d657c:  6361      str     r3, [r4, #0x14]
0x000d657e:  a361      str     r3, [r4, #0x18]
0x000d6580:  a583      strh    r5, [r4, #0x1c]
0x000d6582:  06f081fa  bl      #0xdca88  ; sub_000dca88
0x000d6586:  211c      adds    r1, r4, #0
0x000d6588:  051c      adds    r5, r0, #0
0x000d658a:  0548      ldr     r0, [pc, #0x14]
0x000d658c:  fff7d2fd  bl      #0xd6134  ; sub_000d6134
0x000d6590:  281c      adds    r0, r5, #0
0x000d6592:  06f07dfa  bl      #0xdca90  ; sub_000dca90
0x000d6596:  30bc      pop     {r4, r5}
0x000d6598:  01bc      pop     {r0}
0x000d659a:  0047      bx      r0
0x000d659c:  4553      strh    r5, [r0, r5]
0x000d659e:  0000      movs    r0, r0
0x000d65a0:  c07b      ldrb    r0, [r0, #0xf]
0x000d65a2:  0800      movs    r0, r1
0x000d65a4:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d65a6:  5746      mov     r7, sl
0x000d65a8:  4646      mov     r6, r8
0x000d65aa:  c0b4      push    {r6, r7}
0x000d65ac:  0023      movs    r3, #0
0x000d65ae:  071c      adds    r7, r0, #0
0x000d65b0:  9a46      mov     sl, r3
0x000d65b2:  06f069fa  bl      #0xdca88  ; sub_000dca88
0x000d65b6:  7d69      ldr     r5, [r7, #0x14]
0x000d65b8:  8046      mov     r8, r0
0x000d65ba:  002d      cmp     r5, #0
0x000d65bc:  18d0      beq     #0xd65f0
0x000d65be:  3e1c      adds    r6, r7, #0
0x000d65c0:  0123      movs    r3, #1
0x000d65c2:  1436      adds    r6, #0x14
0x000d65c4:  9a46      mov     sl, r3
0x000d65c6:  ac68      ldr     r4, [r5, #8]
0x000d65c8:  144b      ldr     r3, [pc, #0x50]
0x000d65ca:  228e      ldrh    r2, [r4, #0x30]
0x000d65cc:  211c      adds    r1, r4, #0
0x000d65ce:  1340      ands    r3, r2
0x000d65d0:  0122      movs    r2, #1
0x000d65d2:  1343      orrs    r3, r2
0x000d65d4:  2386      strh    r3, [r4, #0x30]
0x000d65d6:  301c      adds    r0, r6, #0
0x000d65d8:  1431      adds    r1, #0x14
0x000d65da:  2d68      ldr     r5, [r5]
0x000d65dc:  02f058ff  bl      #0xd9490  ; sub_000d9490
0x000d65e0:  0023      movs    r3, #0
0x000d65e2:  2362      str     r3, [r4, #0x20]
0x000d65e4:  0e48      ldr     r0, [pc, #0x38]
0x000d65e6:  211c      adds    r1, r4, #0
0x000d65e8:  fff7e0fd  bl      #0xd61ac  ; sub_000d61ac
0x000d65ec:  002d      cmp     r5, #0
0x000d65ee:  ead1      bne     #0xd65c6
0x000d65f0:  391c      adds    r1, r7, #0
0x000d65f2:  0c48      ldr     r0, [pc, #0x30]
0x000d65f4:  0831      adds    r1, #8
0x000d65f6:  02f04bff  bl      #0xd9490  ; sub_000d9490
0x000d65fa:  0023      movs    r3, #0
0x000d65fc:  3b80      strh    r3, [r7]
0x000d65fe:  5346      mov     r3, sl
0x000d6600:  002b      cmp     r3, #0
0x000d6602:  08d1      bne     #0xd6616
0x000d6604:  4046      mov     r0, r8
0x000d6606:  06f043fa  bl      #0xdca90  ; sub_000dca90
0x000d660a:  18bc      pop     {r3, r4}
0x000d660c:  9846      mov     r8, r3
0x000d660e:  a246      mov     sl, r4
0x000d6610:  f0bc      pop     {r4, r5, r6, r7}
0x000d6612:  01bc      pop     {r0}
0x000d6614:  0047      bx      r0
0x000d6616:  fff71dfd  bl      #0xd6054  ; sub_000d6054
0x000d661a:  f3e7      b       #0xd6604
0x000d661c:  0080      strh    r0, [r0]

===== sub_000d6628 @ 0x000d6628 =====
0x000d6628:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d662a:  0904      lsls    r1, r1, #0x10
0x000d662c:  061c      adds    r6, r0, #0
0x000d662e:  0d0c      lsrs    r5, r1, #0x10
0x000d6630:  06f02afa  bl      #0xdca88  ; sub_000dca88
0x000d6634:  1d4b      ldr     r3, [pc, #0x74]
0x000d6636:  071c      adds    r7, r0, #0
0x000d6638:  1b88      ldrh    r3, [r3]
0x000d663a:  002b      cmp     r3, #0
0x000d663c:  26d1      bne     #0xd668c
0x000d663e:  b28b      ldrh    r2, [r6, #0x1c]
0x000d6640:  aa42      cmp     r2, r5
0x000d6642:  1dd2      bhs     #0xd6680
0x000d6644:  1a4c      ldr     r4, [pc, #0x68]
0x000d6646:  1b4b      ldr     r3, [pc, #0x6c]
0x000d6648:  2168      ldr     r1, [r4]
0x000d664a:  1b48      ldr     r0, [pc, #0x6c]
0x000d664c:  0a8e      ldrh    r2, [r1, #0x30]
0x000d664e:  8d87      strh    r5, [r1, #0x3c]
0x000d6650:  1340      ands    r3, r2
0x000d6652:  0222      movs    r2, #2
0x000d6654:  1343      orrs    r3, r2
0x000d6656:  0b86      strh    r3, [r1, #0x30]
0x000d6658:  1431      adds    r1, #0x14
0x000d665a:  02f019ff  bl      #0xd9490  ; sub_000d9490
0x000d665e:  2168      ldr     r1, [r4]
0x000d6660:  301c      adds    r0, r6, #0
0x000d6662:  1430      adds    r0, #0x14
0x000d6664:  0862      str     r0, [r1, #0x20]
0x000d6666:  1431      adds    r1, #0x14
0x000d6668:  02f0cefe  bl      #0xd9408  ; sub_000d9408
0x000d666c:  fff7f2fc  bl      #0xd6054  ; sub_000d6054
0x000d6670:  2368      ldr     r3, [r4]
0x000d6672:  b361      str     r3, [r6, #0x18]
0x000d6674:  381c      adds    r0, r7, #0
0x000d6676:  06f00bfa  bl      #0xdca90  ; sub_000dca90
0x000d667a:  f0bc      pop     {r4, r5, r6, r7}
0x000d667c:  01bc      pop     {r0}
0x000d667e:  0047      bx      r0
0x000d6680:  0b4b      ldr     r3, [pc, #0x2c]
0x000d6682:  1b68      ldr     r3, [r3]
0x000d6684:  b361      str     r3, [r6, #0x18]
0x000d6686:  531b      subs    r3, r2, r5
0x000d6688:  b383      strh    r3, [r6, #0x1c]
0x000d668a:  f3e7      b       #0xd6674
0x000d668c:  0b49      ldr     r1, [pc, #0x2c]
0x000d668e:  0c4b      ldr     r3, [pc, #0x30]
0x000d6690:  0a88      ldrh    r2, [r1]
0x000d6692:  1340      ands    r3, r2
0x000d6694:  8022      movs    r2, #0x80
0x000d6696:  5201      lsls    r2, r2, #5
0x000d6698:  0133      adds    r3, #1
0x000d669a:  1343      orrs    r3, r2
0x000d669c:  0b80      strh    r3, [r1]
0x000d669e:  044b      ldr     r3, [pc, #0x10]
0x000d66a0:  1a68      ldr     r2, [r3]
0x000d66a2:  084b      ldr     r3, [pc, #0x20]
0x000d66a4:  1a60      str     r2, [r3]
0x000d66a6:  084b      ldr     r3, [pc, #0x20]
0x000d66a8:  1e60      str     r6, [r3]
0x000d66aa:  e3e7      b       #0xd6674
0x000d66ac:  d07c      ldrb    r0, [r2, #0x13]
0x000d66ae:  0800      movs    r0, r1
0x000d66b0:  4081      strh    r0, [r0, #0xa]
0x000d66b2:  0800      movs    r0, r1
0x000d66b4:  0080      strh    r0, [r0]

===== sub_000d66cc @ 0x000d66cc =====
0x000d66cc:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d66ce:  5746      mov     r7, sl
0x000d66d0:  4646      mov     r6, r8
0x000d66d2:  c0b4      push    {r6, r7}
0x000d66d4:  0023      movs    r3, #0
0x000d66d6:  0904      lsls    r1, r1, #0x10
0x000d66d8:  071c      adds    r7, r0, #0
0x000d66da:  0e0c      lsrs    r6, r1, #0x10
0x000d66dc:  9846      mov     r8, r3
0x000d66de:  06f0d3f9  bl      #0xdca88  ; sub_000dca88
0x000d66e2:  bb8b      ldrh    r3, [r7, #0x1c]
0x000d66e4:  7d69      ldr     r5, [r7, #0x14]
0x000d66e6:  f318      adds    r3, r6, r3
0x000d66e8:  1b04      lsls    r3, r3, #0x10
0x000d66ea:  8246      mov     sl, r0
0x000d66ec:  1e0c      lsrs    r6, r3, #0x10
0x000d66ee:  1de0      b       #0xd672c
0x000d66f0:  ac68      ldr     r4, [r5, #8]
0x000d66f2:  2d68      ldr     r5, [r5]
0x000d66f4:  a18f      ldrh    r1, [r4, #0x3c]
0x000d66f6:  b142      cmp     r1, r6
0x000d66f8:  1ad8      bhi     #0xd6730
0x000d66fa:  731a      subs    r3, r6, r1
0x000d66fc:  1b04      lsls    r3, r3, #0x10
0x000d66fe:  1e0c      lsrs    r6, r3, #0x10
0x000d6700:  0023      movs    r3, #0
0x000d6702:  228e      ldrh    r2, [r4, #0x30]
0x000d6704:  a387      strh    r3, [r4, #0x3c]
0x000d6706:  124b      ldr     r3, [pc, #0x48]
0x000d6708:  381c      adds    r0, r7, #0
0x000d670a:  1340      ands    r3, r2
0x000d670c:  0122      movs    r2, #1
0x000d670e:  1343      orrs    r3, r2
0x000d6710:  211c      adds    r1, r4, #0
0x000d6712:  2386      strh    r3, [r4, #0x30]
0x000d6714:  1430      adds    r0, #0x14
0x000d6716:  1431      adds    r1, #0x14
0x000d6718:  02f0bafe  bl      #0xd9490  ; sub_000d9490
0x000d671c:  0023      movs    r3, #0
0x000d671e:  2362      str     r3, [r4, #0x20]
0x000d6720:  0c48      ldr     r0, [pc, #0x30]
0x000d6722:  211c      adds    r1, r4, #0
0x000d6724:  fff742fd  bl      #0xd61ac  ; sub_000d61ac
0x000d6728:  0123      movs    r3, #1
0x000d672a:  9846      mov     r8, r3
0x000d672c:  002d      cmp     r5, #0
0x000d672e:  dfd1      bne     #0xd66f0
0x000d6730:  4346      mov     r3, r8
0x000d6732:  be83      strh    r6, [r7, #0x1c]
0x000d6734:  002b      cmp     r3, #0
0x000d6736:  08d1      bne     #0xd674a
0x000d6738:  5046      mov     r0, sl
0x000d673a:  06f0a9f9  bl      #0xdca90  ; sub_000dca90
0x000d673e:  18bc      pop     {r3, r4}
0x000d6740:  9846      mov     r8, r3
0x000d6742:  a246      mov     sl, r4
0x000d6744:  f0bc      pop     {r4, r5, r6, r7}
0x000d6746:  01bc      pop     {r0}
0x000d6748:  0047      bx      r0
0x000d674a:  fff783fc  bl      #0xd6054  ; sub_000d6054
0x000d674e:  f3e7      b       #0xd6738
0x000d6750:  0080      strh    r0, [r0]

===== sub_000d6f28 @ 0x000d6f28 =====
0x000d6f28:  70b5      push    {r4, r5, r6, lr}
0x000d6f2a:  244b      ldr     r3, [pc, #0x90]
0x000d6f2c:  0004      lsls    r0, r0, #0x10
0x000d6f2e:  1b88      ldrh    r3, [r3]
0x000d6f30:  050c      lsrs    r5, r0, #0x10
0x000d6f32:  002b      cmp     r3, #0
0x000d6f34:  10d0      beq     #0xd6f58
0x000d6f36:  2249      ldr     r1, [pc, #0x88]
0x000d6f38:  224b      ldr     r3, [pc, #0x88]
0x000d6f3a:  0a88      ldrh    r2, [r1]
0x000d6f3c:  0020      movs    r0, #0
0x000d6f3e:  1340      ands    r3, r2
0x000d6f40:  a022      movs    r2, #0xa0
0x000d6f42:  d201      lsls    r2, r2, #7
0x000d6f44:  0133      adds    r3, #1
0x000d6f46:  1343      orrs    r3, r2
0x000d6f48:  0b80      strh    r3, [r1]
0x000d6f4a:  1f4b      ldr     r3, [pc, #0x7c]
0x000d6f4c:  1a68      ldr     r2, [r3]
0x000d6f4e:  1f4b      ldr     r3, [pc, #0x7c]
0x000d6f50:  1a60      str     r2, [r3]
0x000d6f52:  70bc      pop     {r4, r5, r6}
0x000d6f54:  02bc      pop     {r1}
0x000d6f56:  0847      bx      r1
0x000d6f58:  002d      cmp     r5, #0
0x000d6f5a:  01d1      bne     #0xd6f60
0x000d6f5c:  281c      adds    r0, r5, #0
0x000d6f5e:  f8e7      b       #0xd6f52
0x000d6f60:  05f092fd  bl      #0xdca88  ; sub_000dca88
0x000d6f64:  184c      ldr     r4, [pc, #0x60]
0x000d6f66:  1a4b      ldr     r3, [pc, #0x68]
0x000d6f68:  2168      ldr     r1, [r4]
0x000d6f6a:  061c      adds    r6, r0, #0
0x000d6f6c:  0a8e      ldrh    r2, [r1, #0x30]
0x000d6f6e:  8d87      strh    r5, [r1, #0x3c]
0x000d6f70:  1340      ands    r3, r2
0x000d6f72:  0222      movs    r2, #2
0x000d6f74:  1343      orrs    r3, r2
0x000d6f76:  0b86      strh    r3, [r1, #0x30]
0x000d6f78:  1648      ldr     r0, [pc, #0x58]
0x000d6f7a:  1431      adds    r1, #0x14
0x000d6f7c:  02f088fa  bl      #0xd9490  ; sub_000d9490
0x000d6f80:  2468      ldr     r4, [r4]
0x000d6f82:  1548      ldr     r0, [pc, #0x54]
0x000d6f84:  a58f      ldrh    r5, [r4, #0x3c]
0x000d6f86:  0268      ldr     r2, [r0]
0x000d6f88:  0021      movs    r1, #0
0x000d6f8a:  2062      str     r0, [r4, #0x20]
0x000d6f8c:  05e0      b       #0xd6f9a
0x000d6f8e:  9368      ldr     r3, [r2, #8]
0x000d6f90:  9b8f      ldrh    r3, [r3, #0x3c]
0x000d6f92:  ab42      cmp     r3, r5
0x000d6f94:  03d2      bhs     #0xd6f9e
0x000d6f96:  111c      adds    r1, r2, #0
0x000d6f98:  1268      ldr     r2, [r2]
0x000d6f9a:  002a      cmp     r2, #0
0x000d6f9c:  f7d1      bne     #0xd6f8e
0x000d6f9e:  221c      adds    r2, r4, #0
0x000d6fa0:  1432      adds    r2, #0x14
0x000d6fa2:  02f017fa  bl      #0xd93d4  ; sub_000d93d4
0x000d6fa6:  fff755f8  bl      #0xd6054  ; sub_000d6054
0x000d6faa:  074b      ldr     r3, [pc, #0x1c]
0x000d6fac:  301c      adds    r0, r6, #0
0x000d6fae:  1b68      ldr     r3, [r3]
0x000d6fb0:  9d8f      ldrh    r5, [r3, #0x3c]
0x000d6fb2:  05f06dfd  bl      #0xdca90  ; sub_000dca90
0x000d6fb6:  281c      adds    r0, r5, #0
0x000d6fb8:  cbe7      b       #0xd6f52
0x000d6fba:  0000      movs    r0, r0
0x000d6fbc:  d07c      ldrb    r0, [r2, #0x13]
0x000d6fbe:  0800      movs    r0, r1
0x000d6fc0:  2081      strh    r0, [r4, #8]
0x000d6fc2:  0800      movs    r0, r1
0x000d6fc4:  ff0f      lsrs    r7, r7, #0x1f
0x000d6fc6:  0000      movs    r0, r0
0x000d6fc8:  4081      strh    r0, [r0, #0xa]
0x000d6fca:  0800      movs    r0, r1
0x000d6fcc:  a07b      ldrb    r0, [r4, #0xe]
0x000d6fce:  0800      movs    r0, r1
0x000d6fd0:  0080      strh    r0, [r0]

===== sub_000d7030 @ 0x000d7030 =====
0x000d7030:  0028      cmp     r0, #0
0x000d7032:  01d0      beq     #0xd7038
0x000d7034:  4160      str     r1, [r0, #4]
0x000d7036:  7047      bx      lr

===== sub_000d7104 @ 0x000d7104 =====
0x000d7104:  10b5      push    {r4, lr}
0x000d7106:  05f0bffc  bl      #0xdca88  ; sub_000dca88
0x000d710a:  044b      ldr     r3, [pc, #0x10]
0x000d710c:  1c68      ldr     r4, [r3]
0x000d710e:  05f0bffc  bl      #0xdca90  ; sub_000dca90
0x000d7112:  201c      adds    r0, r4, #0
0x000d7114:  10bc      pop     {r4}
0x000d7116:  02bc      pop     {r1}
0x000d7118:  0847      bx      r1
0x000d711a:  0000      movs    r0, r0
0x000d711c:  207c      ldrb    r0, [r4, #0x10]
0x000d711e:  0800      movs    r0, r1
0x000d7120:  10b5      push    {r4, lr}
0x000d7122:  041c      adds    r4, r0, #0
0x000d7124:  05f0b0fc  bl      #0xdca88  ; sub_000dca88
0x000d7128:  034b      ldr     r3, [pc, #0xc]
0x000d712a:  1c60      str     r4, [r3]
0x000d712c:  05f0b0fc  bl      #0xdca90  ; sub_000dca90
0x000d7130:  10bc      pop     {r4}
0x000d7132:  01bc      pop     {r0}
0x000d7134:  0047      bx      r0
0x000d7136:  0000      movs    r0, r0
0x000d7138:  207c      ldrb    r0, [r4, #0x10]
0x000d713a:  0800      movs    r0, r1
0x000d713c:  70b5      push    {r4, r5, r6, lr}
0x000d713e:  224b      ldr     r3, [pc, #0x88]
0x000d7140:  0020      movs    r0, #0
0x000d7142:  1968      ldr     r1, [r3]
0x000d7144:  0029      cmp     r1, #0
0x000d7146:  2ed0      beq     #0xd71a6
0x000d7148:  204b      ldr     r3, [pc, #0x80]
0x000d714a:  0c1c      adds    r4, r1, #0
0x000d714c:  1a68      ldr     r2, [r3]
0x000d714e:  0132      adds    r2, #1
0x000d7150:  1a60      str     r2, [r3]
0x000d7152:  098f      ldrh    r1, [r1, #0x38]
0x000d7154:  0029      cmp     r1, #0
0x000d7156:  29d1      bne     #0xd71ac
0x000d7158:  1d4b      ldr     r3, [pc, #0x74]
0x000d715a:  1d68      ldr     r5, [r3]
0x000d715c:  002d      cmp     r5, #0
0x000d715e:  1ed0      beq     #0xd719e
0x000d7160:  ac68      ldr     r4, [r5, #8]
0x000d7162:  2d68      ldr     r5, [r5]
0x000d7164:  a28f      ldrh    r2, [r4, #0x3c]
0x000d7166:  002a      cmp     r2, #0
0x000d7168:  02d0      beq     #0xd7170
0x000d716a:  531e      subs    r3, r2, #1
0x000d716c:  a387      strh    r3, [r4, #0x3c]
0x000d716e:  1a1c      adds    r2, r3, #0
0x000d7170:  1304      lsls    r3, r2, #0x10
0x000d7172:  1e0c      lsrs    r6, r3, #0x10
0x000d7174:  002e      cmp     r6, #0
0x000d7176:  f1d1      bne     #0xd715c
0x000d7178:  238e      ldrh    r3, [r4, #0x30]
0x000d717a:  164a      ldr     r2, [pc, #0x58]
0x000d717c:  211c      adds    r1, r4, #0
0x000d717e:  1a40      ands    r2, r3
0x000d7180:  0123      movs    r3, #1
0x000d7182:  1a43      orrs    r2, r3
0x000d7184:  2286      strh    r2, [r4, #0x30]
0x000d7186:  1248      ldr     r0, [pc, #0x48]
0x000d7188:  1431      adds    r1, #0x14
0x000d718a:  02f081f9  bl      #0xd9490  ; sub_000d9490
0x000d718e:  1248      ldr     r0, [pc, #0x48]
0x000d7190:  2662      str     r6, [r4, #0x20]
0x000d7192:  211c      adds    r1, r4, #0
0x000d7194:  fff70af8  bl      #0xd61ac  ; sub_000d61ac
0x000d7198:  0120      movs    r0, #1
0x000d719a:  002d      cmp     r5, #0
0x000d719c:  e0d1      bne     #0xd7160
0x000d719e:  0028      cmp     r0, #0
0x000d71a0:  01d0      beq     #0xd71a6
0x000d71a2:  fef757ff  bl      #0xd6054  ; sub_000d6054
0x000d71a6:  70bc      pop     {r4, r5, r6}
0x000d71a8:  01bc      pop     {r0}
0x000d71aa:  0047      bx      r0
0x000d71ac:  638f      ldrh    r3, [r4, #0x3a]
0x000d71ae:  5a1e      subs    r2, r3, #1
0x000d71b0:  1304      lsls    r3, r2, #0x10
0x000d71b2:  002b      cmp     r3, #0
0x000d71b4:  01d0      beq     #0xd71ba
0x000d71b6:  6287      strh    r2, [r4, #0x3a]
0x000d71b8:  cee7      b       #0xd7158
0x000d71ba:  6187      strh    r1, [r4, #0x3a]
0x000d71bc:  0648      ldr     r0, [pc, #0x18]
0x000d71be:  211c      adds    r1, r4, #0
0x000d71c0:  fef7d4ff  bl      #0xd616c  ; sub_000d616c
0x000d71c4:  0120      movs    r0, #1
0x000d71c6:  c7e7      b       #0xd7158
0x000d71c8:  4081      strh    r0, [r0, #0xa]
0x000d71ca:  0800      movs    r0, r1
0x000d71cc:  207c      ldrb    r0, [r4, #0x10]
0x000d71ce:  0800      movs    r0, r1
0x000d71d0:  407c      ldrb    r0, [r0, #0x11]
0x000d71d2:  0800      movs    r0, r1
0x000d71d4:  0080      strh    r0, [r0]

===== sub_000d76a8 @ 0x000d76a8 =====
0x000d76a8:  30b5      push    {r4, r5, lr}
0x000d76aa:  05f0edf9  bl      #0xdca88  ; sub_000dca88
0x000d76ae:  084b      ldr     r3, [pc, #0x20]
0x000d76b0:  fa21      movs    r1, #0xfa
0x000d76b2:  041c      adds    r4, r0, #0
0x000d76b4:  8900      lsls    r1, r1, #2
0x000d76b6:  1888      ldrh    r0, [r3]
0x000d76b8:  04f07cfe  bl      #0xdc3b4  ; sub_000dc3b4
0x000d76bc:  0504      lsls    r5, r0, #0x10
0x000d76be:  201c      adds    r0, r4, #0
0x000d76c0:  05f0e6f9  bl      #0xdca90  ; sub_000dca90
0x000d76c4:  2d0c      lsrs    r5, r5, #0x10
0x000d76c6:  281c      adds    r0, r5, #0
0x000d76c8:  30bc      pop     {r4, r5}
0x000d76ca:  02bc      pop     {r1}
0x000d76cc:  0847      bx      r1
0x000d76ce:  0000      movs    r0, r0
0x000d76d0:  5081      strh    r0, [r2, #0xa]
0x000d76d2:  0800      movs    r0, r1
0x000d76d4:  00b5      push    {lr}
0x000d76d6:  064b      ldr     r3, [pc, #0x18]
0x000d76d8:  0020      movs    r0, #0
0x000d76da:  1b88      ldrh    r3, [r3]
0x000d76dc:  002b      cmp     r3, #0
0x000d76de:  04d1      bne     #0xd76ea
0x000d76e0:  044b      ldr     r3, [pc, #0x10]
0x000d76e2:  1b88      ldrh    r3, [r3]
0x000d76e4:  002b      cmp     r3, #0
0x000d76e6:  00d1      bne     #0xd76ea
0x000d76e8:  0120      movs    r0, #1
0x000d76ea:  02bc      pop     {r1}
0x000d76ec:  0847      bx      r1
0x000d76ee:  0000      movs    r0, r0
0x000d76f0:  1081      strh    r0, [r2, #8]
0x000d76f2:  0800      movs    r0, r1
0x000d76f4:  d07c      ldrb    r0, [r2, #0x13]
0x000d76f6:  0800      movs    r0, r1
0x000d76f8:  7047      bx      lr

===== sub_000d7d34 @ 0x000d7d34 =====
0x000d7d34:  30b5      push    {r4, r5, lr}
0x000d7d36:  051c      adds    r5, r0, #0
0x000d7d38:  fef7dcf9  bl      #0xd60f4  ; sub_000d60f4
0x000d7d3c:  1f4b      ldr     r3, [pc, #0x7c]
0x000d7d3e:  1c68      ldr     r4, [r3]
0x000d7d40:  002c      cmp     r4, #0
0x000d7d42:  13d0      beq     #0xd7d6c
0x000d7d44:  0120      movs    r0, #1
0x000d7d46:  221c      adds    r2, r4, #0
0x000d7d48:  02e0      b       #0xd7d50
0x000d7d4a:  d368      ldr     r3, [r2, #0xc]
0x000d7d4c:  9b18      adds    r3, r3, r2
0x000d7d4e:  1a1c      adds    r2, r3, #0
0x000d7d50:  1032      adds    r2, #0x10
0x000d7d52:  5388      ldrh    r3, [r2, #2]
0x000d7d54:  1904      lsls    r1, r3, #0x10
0x000d7d56:  1842      tst     r0, r3
0x000d7d58:  02d1      bne     #0xd7d60
0x000d7d5a:  d368      ldr     r3, [r2, #0xc]
0x000d7d5c:  ab42      cmp     r3, r5
0x000d7d5e:  0ed2      bhs     #0xd7d7e
0x000d7d60:  8b0c      lsrs    r3, r1, #0x12
0x000d7d62:  0342      tst     r3, r0
0x000d7d64:  f1d0      beq     #0xd7d4a
0x000d7d66:  a468      ldr     r4, [r4, #8]
0x000d7d68:  002c      cmp     r4, #0
0x000d7d6a:  ecd1      bne     #0xd7d46
0x000d7d6c:  fef7d2f9  bl      #0xd6114  ; sub_000d6114
0x000d7d70:  1348      ldr     r0, [pc, #0x4c]  ; &"#MALLOC:Failed!"
0x000d7d72:  01f0c7f8  bl      #0xd8f04  ; sub_000d8f04
0x000d7d76:  0020      movs    r0, #0
0x000d7d78:  30bc      pop     {r4, r5}
0x000d7d7a:  02bc      pop     {r1}
0x000d7d7c:  0847      bx      r1
0x000d7d7e:  141e      subs    r4, r2, #0
0x000d7d80:  f4d0      beq     #0xd7d6c
0x000d7d82:  291c      adds    r1, r5, #0
0x000d7d84:  201c      adds    r0, r4, #0
0x000d7d86:  fff7abff  bl      #0xd7ce0  ; sub_000d7ce0
0x000d7d8a:  0e49      ldr     r1, [pc, #0x38]
0x000d7d8c:  e368      ldr     r3, [r4, #0xc]
0x000d7d8e:  0a68      ldr     r2, [r1]
0x000d7d90:  9b18      adds    r3, r3, r2
0x000d7d92:  1a1c      adds    r2, r3, #0
0x000d7d94:  1032      adds    r2, #0x10
0x000d7d96:  0a60      str     r2, [r1]
0x000d7d98:  0b49      ldr     r1, [pc, #0x2c]
0x000d7d9a:  0b68      ldr     r3, [r1]
0x000d7d9c:  9a42      cmp     r2, r3
0x000d7d9e:  00d9      bls     #0xd7da2
0x000d7da0:  0a60      str     r2, [r1]
0x000d7da2:  6388      ldrh    r3, [r4, #2]
0x000d7da4:  0122      movs    r2, #1
0x000d7da6:  1343      orrs    r3, r2
0x000d7da8:  6380      strh    r3, [r4, #2]
0x000d7daa:  fff75dfc  bl      #0xd7668  ; sub_000d7668
0x000d7dae:  a060      str     r0, [r4, #8]
0x000d7db0:  fef7b0f9  bl      #0xd6114  ; sub_000d6114
0x000d7db4:  1034      adds    r4, #0x10
0x000d7db6:  201c      adds    r0, r4, #0
0x000d7db8:  dee7      b       #0xd7d78
0x000d7dba:  0000      movs    r0, r0
0x000d7dbc:  0083      strh    r0, [r0, #0x18]
0x000d7dbe:  0800      movs    r0, r1
0x000d7dc0:  f47d      ldrb    r4, [r6, #0x17]
0x000d7dc2:  1100      movs    r1, r2
0x000d7dc4:  4083      strh    r0, [r0, #0x1a]
0x000d7dc6:  0800      movs    r0, r1
0x000d7dc8:  2083      strh    r0, [r4, #0x18]
0x000d7dca:  0800      movs    r0, r1
0x000d7dcc:  70b5      push    {r4, r5, r6, lr}
0x000d7dce:  041c      adds    r4, r0, #0
0x000d7dd0:  103c      subs    r4, #0x10
0x000d7dd2:  0d1c      adds    r5, r1, #0
0x000d7dd4:  fef78ef9  bl      #0xd60f4  ; sub_000d60f4
0x000d7dd8:  e168      ldr     r1, [r4, #0xc]
0x000d7dda:  a942      cmp     r1, r5
0x000d7ddc:  0fd8      bhi     #0xd7dfe
0x000d7dde:  0b19      adds    r3, r1, r4
0x000d7de0:  1e1c      adds    r6, r3, #0
0x000d7de2:  6388      ldrh    r3, [r4, #2]
0x000d7de4:  1036      adds    r6, #0x10
0x000d7de6:  5a07      lsls    r2, r3, #0x1d
0x000d7de8:  03d4      bmi     #0xd7df2
0x000d7dea:  7288      ldrh    r2, [r6, #2]
0x000d7dec:  0123      movs    r3, #1
0x000d7dee:  1a42      tst     r2, r3
0x000d7df0:  10d0      beq     #0xd7e14
0x000d7df2:  fef78ff9  bl      #0xd6114  ; sub_000d6114
0x000d7df6:  e068      ldr     r0, [r4, #0xc]
0x000d7df8:  70bc      pop     {r4, r5, r6}
0x000d7dfa:  02bc      pop     {r1}
0x000d7dfc:  0847      bx      r1
0x000d7dfe:  104b      ldr     r3, [pc, #0x40]
0x000d7e00:  6a1a      subs    r2, r5, r1
0x000d7e02:  1968      ldr     r1, [r3]
0x000d7e04:  201c      adds    r0, r4, #0
0x000d7e06:  5218      adds    r2, r2, r1
0x000d7e08:  1032      adds    r2, #0x10
0x000d7e0a:  1a60      str     r2, [r3]
0x000d7e0c:  291c      adds    r1, r5, #0
0x000d7e0e:  fff767ff  bl      #0xd7ce0  ; sub_000d7ce0
0x000d7e12:  eee7      b       #0xd7df2
0x000d7e14:  691a      subs    r1, r5, r1
0x000d7e16:  1039      subs    r1, #0x10
0x000d7e18:  301c      adds    r0, r6, #0
0x000d7e1a:  fff761ff  bl      #0xd7ce0  ; sub_000d7ce0
0x000d7e1e:  0849      ldr     r1, [pc, #0x20]
0x000d7e20:  f368      ldr     r3, [r6, #0xc]
0x000d7e22:  0a68      ldr     r2, [r1]
0x000d7e24:  9b18      adds    r3, r3, r2
0x000d7e26:  1a1c      adds    r2, r3, #0
0x000d7e28:  1032      adds    r2, #0x10
0x000d7e2a:  0a60      str     r2, [r1]
0x000d7e2c:  0549      ldr     r1, [pc, #0x14]
0x000d7e2e:  0b68      ldr     r3, [r1]
0x000d7e30:  9a42      cmp     r2, r3
0x000d7e32:  00d9      bls     #0xd7e36
0x000d7e34:  0a60      str     r2, [r1]
0x000d7e36:  201c      adds    r0, r4, #0
0x000d7e38:  311c      adds    r1, r6, #0
0x000d7e3a:  fff73bff  bl      #0xd7cb4  ; sub_000d7cb4
0x000d7e3e:  d8e7      b       #0xd7df2
0x000d7e40:  4083      strh    r0, [r0, #0x1a]
0x000d7e42:  0800      movs    r0, r1
0x000d7e44:  2083      strh    r0, [r4, #0x18]
0x000d7e46:  0800      movs    r0, r1
0x000d7e48:  30b5      push    {r4, r5, lr}
0x000d7e4a:  041c      adds    r4, r0, #0
0x000d7e4c:  103c      subs    r4, #0x10
0x000d7e4e:  fef751f9  bl      #0xd60f4  ; sub_000d60f4
0x000d7e52:  2288      ldrh    r2, [r4]
0x000d7e54:  1c4b      ldr     r3, [pc, #0x70]
0x000d7e56:  9a42      cmp     r2, r3
0x000d7e58:  05d0      beq     #0xd7e66
0x000d7e5a:  fef75bf9  bl      #0xd6114  ; sub_000d6114
0x000d7e5e:  0120      movs    r0, #1
0x000d7e60:  30bc      pop     {r4, r5}
0x000d7e62:  02bc      pop     {r1}
0x000d7e64:  0847      bx      r1
0x000d7e66:  194d      ldr     r5, [pc, #0x64]
0x000d7e68:  0023      movs    r3, #0
0x000d7e6a:  6288      ldrh    r2, [r4, #2]
0x000d7e6c:  e168      ldr     r1, [r4, #0xc]
0x000d7e6e:  a360      str     r3, [r4, #8]
0x000d7e70:  2b68      ldr     r3, [r5]
0x000d7e72:  0120      movs    r0, #1
0x000d7e74:  8243      bics    r2, r0
0x000d7e76:  5b1a      subs    r3, r3, r1
0x000d7e78:  6280      strh    r2, [r4, #2]
0x000d7e7a:  103b      subs    r3, #0x10
0x000d7e7c:  9208      lsrs    r2, r2, #2
0x000d7e7e:  2b60      str     r3, [r5]
0x000d7e80:  0242      tst     r2, r0
0x000d7e82:  05d1      bne     #0xd7e90
0x000d7e84:  0b19      adds    r3, r1, r4
0x000d7e86:  191c      adds    r1, r3, #0
0x000d7e88:  1031      adds    r1, #0x10
0x000d7e8a:  4b88      ldrh    r3, [r1, #2]
0x000d7e8c:  0342      tst     r3, r0
0x000d7e8e:  14d0      beq     #0xd7eba
0x000d7e90:  6388      ldrh    r3, [r4, #2]
0x000d7e92:  9a07      lsls    r2, r3, #0x1e
0x000d7e94:  0dd4      bmi     #0xd7eb2
0x000d7e96:  6068      ldr     r0, [r4, #4]
0x000d7e98:  0028      cmp     r0, #0
0x000d7e9a:  0ad0      beq     #0xd7eb2
0x000d7e9c:  4288      ldrh    r2, [r0, #2]
0x000d7e9e:  0123      movs    r3, #1
0x000d7ea0:  1a42      tst     r2, r3
0x000d7ea2:  06d1      bne     #0xd7eb2
0x000d7ea4:  211c      adds    r1, r4, #0
0x000d7ea6:  fff705ff  bl      #0xd7cb4  ; sub_000d7cb4
0x000d7eaa:  084a      ldr     r2, [pc, #0x20]
0x000d7eac:  1368      ldr     r3, [r2]
0x000d7eae:  103b      subs    r3, #0x10
0x000d7eb0:  1360      str     r3, [r2]
0x000d7eb2:  fef72ff9  bl      #0xd6114  ; sub_000d6114
0x000d7eb6:  0020      movs    r0, #0
0x000d7eb8:  d2e7      b       #0xd7e60
0x000d7eba:  201c      adds    r0, r4, #0
0x000d7ebc:  fff7fafe  bl      #0xd7cb4  ; sub_000d7cb4
0x000d7ec0:  2b68      ldr     r3, [r5]
0x000d7ec2:  103b      subs    r3, #0x10
0x000d7ec4:  2b60      str     r3, [r5]
0x000d7ec6:  e3e7      b       #0xd7e90
0x000d7ec8:  454d      ldr     r5, [pc, #0x114]
0x000d7eca:  0000      movs    r0, r0
0x000d7ecc:  4083      strh    r0, [r0, #0x1a]
0x000d7ece:  0800      movs    r0, r1
0x000d7ed0:  10b5      push    {r4, lr}
0x000d7ed2:  134b      ldr     r3, [pc, #0x4c]
0x000d7ed4:  041c      adds    r4, r0, #0
0x000d7ed6:  0380      strh    r3, [r0]
0x000d7ed8:  0023      movs    r3, #0
0x000d7eda:  4380      strh    r3, [r0, #2]
0x000d7edc:  0b1c      adds    r3, r1, #0
0x000d7ede:  103b      subs    r3, #0x10
0x000d7ee0:  e360      str     r3, [r4, #0xc]
0x000d7ee2:  104b      ldr     r3, [pc, #0x40]
0x000d7ee4:  221c      adds    r2, r4, #0
0x000d7ee6:  1032      adds    r2, #0x10
0x000d7ee8:  2382      strh    r3, [r4, #0x10]
0x000d7eea:  0623      movs    r3, #6
0x000d7eec:  0020      movs    r0, #0
0x000d7eee:  5380      strh    r3, [r2, #2]
0x000d7ef0:  0d4b      ldr     r3, [pc, #0x34]
0x000d7ef2:  6060      str     r0, [r4, #4]
0x000d7ef4:  a060      str     r0, [r4, #8]
0x000d7ef6:  2039      subs    r1, #0x20
0x000d7ef8:  5060      str     r0, [r2, #4]
0x000d7efa:  9060      str     r0, [r2, #8]
0x000d7efc:  d160      str     r1, [r2, #0xc]
0x000d7efe:  1a68      ldr     r2, [r3]
0x000d7f00:  002a      cmp     r2, #0
0x000d7f02:  01d1      bne     #0xd7f08
0x000d7f04:  09e0      b       #0xd7f1a
0x000d7f06:  1a1c      adds    r2, r3, #0
0x000d7f08:  9368      ldr     r3, [r2, #8]
0x000d7f0a:  002b      cmp     r3, #0
0x000d7f0c:  fbd1      bne     #0xd7f06
0x000d7f0e:  9460      str     r4, [r2, #8]
0x000d7f10:  6260      str     r2, [r4, #4]
0x000d7f12:  0020      movs    r0, #0

===== sub_000d7e48 @ 0x000d7e48 =====
0x000d7e48:  30b5      push    {r4, r5, lr}
0x000d7e4a:  041c      adds    r4, r0, #0
0x000d7e4c:  103c      subs    r4, #0x10
0x000d7e4e:  fef751f9  bl      #0xd60f4  ; sub_000d60f4
0x000d7e52:  2288      ldrh    r2, [r4]
0x000d7e54:  1c4b      ldr     r3, [pc, #0x70]
0x000d7e56:  9a42      cmp     r2, r3
0x000d7e58:  05d0      beq     #0xd7e66
0x000d7e5a:  fef75bf9  bl      #0xd6114  ; sub_000d6114
0x000d7e5e:  0120      movs    r0, #1
0x000d7e60:  30bc      pop     {r4, r5}
0x000d7e62:  02bc      pop     {r1}
0x000d7e64:  0847      bx      r1
0x000d7e66:  194d      ldr     r5, [pc, #0x64]
0x000d7e68:  0023      movs    r3, #0
0x000d7e6a:  6288      ldrh    r2, [r4, #2]
0x000d7e6c:  e168      ldr     r1, [r4, #0xc]
0x000d7e6e:  a360      str     r3, [r4, #8]
0x000d7e70:  2b68      ldr     r3, [r5]
0x000d7e72:  0120      movs    r0, #1
0x000d7e74:  8243      bics    r2, r0
0x000d7e76:  5b1a      subs    r3, r3, r1
0x000d7e78:  6280      strh    r2, [r4, #2]
0x000d7e7a:  103b      subs    r3, #0x10
0x000d7e7c:  9208      lsrs    r2, r2, #2
0x000d7e7e:  2b60      str     r3, [r5]
0x000d7e80:  0242      tst     r2, r0
0x000d7e82:  05d1      bne     #0xd7e90
0x000d7e84:  0b19      adds    r3, r1, r4
0x000d7e86:  191c      adds    r1, r3, #0
0x000d7e88:  1031      adds    r1, #0x10
0x000d7e8a:  4b88      ldrh    r3, [r1, #2]
0x000d7e8c:  0342      tst     r3, r0
0x000d7e8e:  14d0      beq     #0xd7eba
0x000d7e90:  6388      ldrh    r3, [r4, #2]
0x000d7e92:  9a07      lsls    r2, r3, #0x1e
0x000d7e94:  0dd4      bmi     #0xd7eb2
0x000d7e96:  6068      ldr     r0, [r4, #4]
0x000d7e98:  0028      cmp     r0, #0
0x000d7e9a:  0ad0      beq     #0xd7eb2
0x000d7e9c:  4288      ldrh    r2, [r0, #2]
0x000d7e9e:  0123      movs    r3, #1
0x000d7ea0:  1a42      tst     r2, r3
0x000d7ea2:  06d1      bne     #0xd7eb2
0x000d7ea4:  211c      adds    r1, r4, #0
0x000d7ea6:  fff705ff  bl      #0xd7cb4  ; sub_000d7cb4
0x000d7eaa:  084a      ldr     r2, [pc, #0x20]
0x000d7eac:  1368      ldr     r3, [r2]
0x000d7eae:  103b      subs    r3, #0x10
0x000d7eb0:  1360      str     r3, [r2]
0x000d7eb2:  fef72ff9  bl      #0xd6114  ; sub_000d6114
0x000d7eb6:  0020      movs    r0, #0
0x000d7eb8:  d2e7      b       #0xd7e60
0x000d7eba:  201c      adds    r0, r4, #0
0x000d7ebc:  fff7fafe  bl      #0xd7cb4  ; sub_000d7cb4
0x000d7ec0:  2b68      ldr     r3, [r5]
0x000d7ec2:  103b      subs    r3, #0x10
0x000d7ec4:  2b60      str     r3, [r5]
0x000d7ec6:  e3e7      b       #0xd7e90
0x000d7ec8:  454d      ldr     r5, [pc, #0x114]
0x000d7eca:  0000      movs    r0, r0
0x000d7ecc:  4083      strh    r0, [r0, #0x1a]
0x000d7ece:  0800      movs    r0, r1
0x000d7ed0:  10b5      push    {r4, lr}
0x000d7ed2:  134b      ldr     r3, [pc, #0x4c]
0x000d7ed4:  041c      adds    r4, r0, #0
0x000d7ed6:  0380      strh    r3, [r0]
0x000d7ed8:  0023      movs    r3, #0
0x000d7eda:  4380      strh    r3, [r0, #2]
0x000d7edc:  0b1c      adds    r3, r1, #0
0x000d7ede:  103b      subs    r3, #0x10
0x000d7ee0:  e360      str     r3, [r4, #0xc]
0x000d7ee2:  104b      ldr     r3, [pc, #0x40]
0x000d7ee4:  221c      adds    r2, r4, #0
0x000d7ee6:  1032      adds    r2, #0x10
0x000d7ee8:  2382      strh    r3, [r4, #0x10]
0x000d7eea:  0623      movs    r3, #6
0x000d7eec:  0020      movs    r0, #0
0x000d7eee:  5380      strh    r3, [r2, #2]
0x000d7ef0:  0d4b      ldr     r3, [pc, #0x34]
0x000d7ef2:  6060      str     r0, [r4, #4]
0x000d7ef4:  a060      str     r0, [r4, #8]
0x000d7ef6:  2039      subs    r1, #0x20
0x000d7ef8:  5060      str     r0, [r2, #4]
0x000d7efa:  9060      str     r0, [r2, #8]
0x000d7efc:  d160      str     r1, [r2, #0xc]
0x000d7efe:  1a68      ldr     r2, [r3]
0x000d7f00:  002a      cmp     r2, #0
0x000d7f02:  01d1      bne     #0xd7f08
0x000d7f04:  09e0      b       #0xd7f1a
0x000d7f06:  1a1c      adds    r2, r3, #0
0x000d7f08:  9368      ldr     r3, [r2, #8]
0x000d7f0a:  002b      cmp     r3, #0
0x000d7f0c:  fbd1      bne     #0xd7f06
0x000d7f0e:  9460      str     r4, [r2, #8]
0x000d7f10:  6260      str     r2, [r4, #4]
0x000d7f12:  0020      movs    r0, #0
0x000d7f14:  10bc      pop     {r4}
0x000d7f16:  02bc      pop     {r1}
0x000d7f18:  0847      bx      r1
0x000d7f1a:  1c60      str     r4, [r3]
0x000d7f1c:  f9e7      b       #0xd7f12
0x000d7f1e:  0000      movs    r0, r0
0x000d7f20:  4f52      strh    r7, [r1, r1]
0x000d7f22:  0000      movs    r0, r0
0x000d7f24:  454d      ldr     r5, [pc, #0x114]
0x000d7f26:  0000      movs    r0, r0
0x000d7f28:  0083      strh    r0, [r0, #0x18]
0x000d7f2a:  0800      movs    r0, r1
0x000d7f2c:  00b5      push    {lr}
0x000d7f2e:  064b      ldr     r3, [pc, #0x18]
0x000d7f30:  0022      movs    r2, #0
0x000d7f32:  1a60      str     r2, [r3]
0x000d7f34:  054b      ldr     r3, [pc, #0x14]
0x000d7f36:  1a60      str     r2, [r3]
0x000d7f38:  054b      ldr     r3, [pc, #0x14]
0x000d7f3a:  1a60      str     r2, [r3]
0x000d7f3c:  fff7c8ff  bl      #0xd7ed0  ; sub_000d7ed0
0x000d7f40:  0020      movs    r0, #0
0x000d7f42:  02bc      pop     {r1}
0x000d7f44:  0847      bx      r1
0x000d7f46:  0000      movs    r0, r0
0x000d7f48:  0083      strh    r0, [r0, #0x18]
0x000d7f4a:  0800      movs    r0, r1
0x000d7f4c:  4083      strh    r0, [r0, #0x1a]
0x000d7f4e:  0800      movs    r0, r1
0x000d7f50:  2083      strh    r0, [r4, #0x18]
0x000d7f52:  0800      movs    r0, r1
0x000d7f54:  10b5      push    {r4, lr}
0x000d7f56:  041c      adds    r4, r0, #0
0x000d7f58:  fef7ccf8  bl      #0xd60f4  ; sub_000d60f4
0x000d7f5c:  2388      ldrh    r3, [r4]
0x000d7f5e:  002b      cmp     r3, #0
0x000d7f60:  07d1      bne     #0xd7f72
0x000d7f62:  0123      movs    r3, #1
0x000d7f64:  2380      strh    r3, [r4]
0x000d7f66:  fef7d5f8  bl      #0xd6114  ; sub_000d6114
0x000d7f6a:  0120      movs    r0, #1
0x000d7f6c:  10bc      pop     {r4}
0x000d7f6e:  02bc      pop     {r1}
0x000d7f70:  0847      bx      r1
0x000d7f72:  fef7cff8  bl      #0xd6114  ; sub_000d6114
0x000d7f76:  0020      movs    r0, #0
0x000d7f78:  f8e7      b       #0xd7f6c
0x000d7f7a:  0000      movs    r0, r0
0x000d7f7c:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d7f7e:  1204      lsls    r2, r2, #0x10
0x000d7f80:  170c      lsrs    r7, r2, #0x10
0x000d7f82:  031c      adds    r3, r0, #0
0x000d7f84:  0122      movs    r2, #1
0x000d7f86:  0c1c      adds    r4, r1, #0
0x000d7f88:  4b40      eors    r3, r1
0x000d7f8a:  111c      adds    r1, r2, #0
0x000d7f8c:  9943      bics    r1, r3
0x000d7f8e:  38d0      beq     #0xd8002
0x000d7f90:  0326      movs    r6, #3
0x000d7f92:  011c      adds    r1, r0, #0
0x000d7f94:  251c      adds    r5, r4, #0
0x000d7f96:  3140      ands    r1, r6
0x000d7f98:  3540      ands    r5, r6
0x000d7f9a:  a942      cmp     r1, r5
0x000d7f9c:  48d1      bne     #0xd8030
0x000d7f9e:  0423      movs    r3, #4
0x000d7fa0:  591a      subs    r1, r3, r1
0x000d7fa2:  3140      ands    r1, r6
0x000d7fa4:  7b1a      subs    r3, r7, r1
0x000d7fa6:  5ad4      bmi     #0xd805e
0x000d7fa8:  9d10      asrs    r5, r3, #2
0x000d7faa:  ab00      lsls    r3, r5, #2
0x000d7fac:  5b18      adds    r3, r3, r1
0x000d7fae:  ff1a      subs    r7, r7, r3
0x000d7fb0:  09e0      b       #0xd7fc6
0x000d7fb2:  0378      ldrb    r3, [r0]
0x000d7fb4:  2678      ldrb    r6, [r4]
0x000d7fb6:  9c46      mov     ip, r3
0x000d7fb8:  1a1c      adds    r2, r3, #0
0x000d7fba:  331c      adds    r3, r6, #0
0x000d7fbc:  9a42      cmp     r2, r3
0x000d7fbe:  30d1      bne     #0xd8022
0x000d7fc0:  0130      adds    r0, #1
0x000d7fc2:  0134      adds    r4, #1
0x000d7fc4:  0139      subs    r1, #1
0x000d7fc6:  0029      cmp     r1, #0
0x000d7fc8:  f3dc      bgt     #0xd7fb2
0x000d7fca:  211c      adds    r1, r4, #0
0x000d7fcc:  06e0      b       #0xd7fdc
0x000d7fce:  0268      ldr     r2, [r0]
0x000d7fd0:  0b68      ldr     r3, [r1]
0x000d7fd2:  9a42      cmp     r2, r3
0x000d7fd4:  5cd1      bne     #0xd8090
0x000d7fd6:  0430      adds    r0, #4
0x000d7fd8:  0431      adds    r1, #4
0x000d7fda:  013d      subs    r5, #1
0x000d7fdc:  002d      cmp     r5, #0
0x000d7fde:  f6dc      bgt     #0xd7fce
0x000d7fe0:  0c1c      adds    r4, r1, #0
0x000d7fe2:  08e0      b       #0xd7ff6
0x000d7fe4:  2678      ldrb    r6, [r4]
0x000d7fe6:  0178      ldrb    r1, [r0]
0x000d7fe8:  331c      adds    r3, r6, #0
0x000d7fea:  8c46      mov     ip, r1
0x000d7fec:  9942      cmp     r1, r3
0x000d7fee:  18d1      bne     #0xd8022
0x000d7ff0:  0130      adds    r0, #1
0x000d7ff2:  0134      adds    r4, #1
0x000d7ff4:  013f      subs    r7, #1
0x000d7ff6:  002f      cmp     r7, #0
0x000d7ff8:  f4dc      bgt     #0xd7fe4
0x000d7ffa:  0020      movs    r0, #0
0x000d7ffc:  f0bc      pop     {r4, r5, r6, r7}
0x000d7ffe:  02bc      pop     {r1}
0x000d8000:  0847      bx      r1
0x000d8002:  002f      cmp     r7, #0
0x000d8004:  08dd      ble     #0xd8018
0x000d8006:  0278      ldrb    r2, [r0]
0x000d8008:  2378      ldrb    r3, [r4]
0x000d800a:  9a42      cmp     r2, r3
0x000d800c:  04d1      bne     #0xd8018
0x000d800e:  0130      adds    r0, #1
0x000d8010:  0134      adds    r4, #1
0x000d8012:  013f      subs    r7, #1
0x000d8014:  002f      cmp     r7, #0
0x000d8016:  f6dc      bgt     #0xd8006
0x000d8018:  002f      cmp     r7, #0
0x000d801a:  eed0      beq     #0xd7ffa
0x000d801c:  0078      ldrb    r0, [r0]
0x000d801e:  2678      ldrb    r6, [r4]
0x000d8020:  8446      mov     ip, r0
0x000d8022:  6346      mov     r3, ip
0x000d8024:  1a06      lsls    r2, r3, #0x18
0x000d8026:  3306      lsls    r3, r6, #0x18

===== sub_000d7f54 @ 0x000d7f54 =====
0x000d7f54:  10b5      push    {r4, lr}
0x000d7f56:  041c      adds    r4, r0, #0
0x000d7f58:  fef7ccf8  bl      #0xd60f4  ; sub_000d60f4
0x000d7f5c:  2388      ldrh    r3, [r4]
0x000d7f5e:  002b      cmp     r3, #0
0x000d7f60:  07d1      bne     #0xd7f72
0x000d7f62:  0123      movs    r3, #1
0x000d7f64:  2380      strh    r3, [r4]
0x000d7f66:  fef7d5f8  bl      #0xd6114  ; sub_000d6114
0x000d7f6a:  0120      movs    r0, #1
0x000d7f6c:  10bc      pop     {r4}
0x000d7f6e:  02bc      pop     {r1}
0x000d7f70:  0847      bx      r1
0x000d7f72:  fef7cff8  bl      #0xd6114  ; sub_000d6114
0x000d7f76:  0020      movs    r0, #0
0x000d7f78:  f8e7      b       #0xd7f6c
0x000d7f7a:  0000      movs    r0, r0
0x000d7f7c:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d7f7e:  1204      lsls    r2, r2, #0x10
0x000d7f80:  170c      lsrs    r7, r2, #0x10
0x000d7f82:  031c      adds    r3, r0, #0
0x000d7f84:  0122      movs    r2, #1
0x000d7f86:  0c1c      adds    r4, r1, #0
0x000d7f88:  4b40      eors    r3, r1
0x000d7f8a:  111c      adds    r1, r2, #0
0x000d7f8c:  9943      bics    r1, r3
0x000d7f8e:  38d0      beq     #0xd8002
0x000d7f90:  0326      movs    r6, #3
0x000d7f92:  011c      adds    r1, r0, #0
0x000d7f94:  251c      adds    r5, r4, #0
0x000d7f96:  3140      ands    r1, r6
0x000d7f98:  3540      ands    r5, r6
0x000d7f9a:  a942      cmp     r1, r5
0x000d7f9c:  48d1      bne     #0xd8030
0x000d7f9e:  0423      movs    r3, #4
0x000d7fa0:  591a      subs    r1, r3, r1
0x000d7fa2:  3140      ands    r1, r6
0x000d7fa4:  7b1a      subs    r3, r7, r1
0x000d7fa6:  5ad4      bmi     #0xd805e
0x000d7fa8:  9d10      asrs    r5, r3, #2
0x000d7faa:  ab00      lsls    r3, r5, #2
0x000d7fac:  5b18      adds    r3, r3, r1
0x000d7fae:  ff1a      subs    r7, r7, r3
0x000d7fb0:  09e0      b       #0xd7fc6
0x000d7fb2:  0378      ldrb    r3, [r0]
0x000d7fb4:  2678      ldrb    r6, [r4]
0x000d7fb6:  9c46      mov     ip, r3
0x000d7fb8:  1a1c      adds    r2, r3, #0
0x000d7fba:  331c      adds    r3, r6, #0
0x000d7fbc:  9a42      cmp     r2, r3
0x000d7fbe:  30d1      bne     #0xd8022
0x000d7fc0:  0130      adds    r0, #1
0x000d7fc2:  0134      adds    r4, #1
0x000d7fc4:  0139      subs    r1, #1
0x000d7fc6:  0029      cmp     r1, #0
0x000d7fc8:  f3dc      bgt     #0xd7fb2
0x000d7fca:  211c      adds    r1, r4, #0
0x000d7fcc:  06e0      b       #0xd7fdc
0x000d7fce:  0268      ldr     r2, [r0]
0x000d7fd0:  0b68      ldr     r3, [r1]
0x000d7fd2:  9a42      cmp     r2, r3
0x000d7fd4:  5cd1      bne     #0xd8090
0x000d7fd6:  0430      adds    r0, #4
0x000d7fd8:  0431      adds    r1, #4
0x000d7fda:  013d      subs    r5, #1
0x000d7fdc:  002d      cmp     r5, #0
0x000d7fde:  f6dc      bgt     #0xd7fce
0x000d7fe0:  0c1c      adds    r4, r1, #0
0x000d7fe2:  08e0      b       #0xd7ff6
0x000d7fe4:  2678      ldrb    r6, [r4]
0x000d7fe6:  0178      ldrb    r1, [r0]
0x000d7fe8:  331c      adds    r3, r6, #0
0x000d7fea:  8c46      mov     ip, r1
0x000d7fec:  9942      cmp     r1, r3
0x000d7fee:  18d1      bne     #0xd8022
0x000d7ff0:  0130      adds    r0, #1
0x000d7ff2:  0134      adds    r4, #1
0x000d7ff4:  013f      subs    r7, #1
0x000d7ff6:  002f      cmp     r7, #0
0x000d7ff8:  f4dc      bgt     #0xd7fe4
0x000d7ffa:  0020      movs    r0, #0
0x000d7ffc:  f0bc      pop     {r4, r5, r6, r7}
0x000d7ffe:  02bc      pop     {r1}
0x000d8000:  0847      bx      r1
0x000d8002:  002f      cmp     r7, #0
0x000d8004:  08dd      ble     #0xd8018
0x000d8006:  0278      ldrb    r2, [r0]
0x000d8008:  2378      ldrb    r3, [r4]
0x000d800a:  9a42      cmp     r2, r3
0x000d800c:  04d1      bne     #0xd8018
0x000d800e:  0130      adds    r0, #1
0x000d8010:  0134      adds    r4, #1
0x000d8012:  013f      subs    r7, #1
0x000d8014:  002f      cmp     r7, #0
0x000d8016:  f6dc      bgt     #0xd8006
0x000d8018:  002f      cmp     r7, #0
0x000d801a:  eed0      beq     #0xd7ffa
0x000d801c:  0078      ldrb    r0, [r0]
0x000d801e:  2678      ldrb    r6, [r4]
0x000d8020:  8446      mov     ip, r0
0x000d8022:  6346      mov     r3, ip
0x000d8024:  1a06      lsls    r2, r3, #0x18
0x000d8026:  3306      lsls    r3, r6, #0x18
0x000d8028:  9342      cmp     r3, r2
0x000d802a:  34d2      bhs     #0xd8096
0x000d802c:  0120      movs    r0, #1
0x000d802e:  e5e7      b       #0xd7ffc
0x000d8030:  011c      adds    r1, r0, #0
0x000d8032:  251c      adds    r5, r4, #0
0x000d8034:  1140      ands    r1, r2
0x000d8036:  1540      ands    r5, r2
0x000d8038:  a942      cmp     r1, r5
0x000d803a:  edd1      bne     #0xd8018
0x000d803c:  7b1a      subs    r3, r7, r1
0x000d803e:  da0f      lsrs    r2, r3, #0x1f
0x000d8040:  9b18      adds    r3, r3, r2
0x000d8042:  5d10      asrs    r5, r3, #1
0x000d8044:  6b00      lsls    r3, r5, #1
0x000d8046:  5b18      adds    r3, r3, r1
0x000d8048:  ff1a      subs    r7, r7, r3
0x000d804a:  0029      cmp     r1, #0
0x000d804c:  0bdd      ble     #0xd8066
0x000d804e:  2178      ldrb    r1, [r4]
0x000d8050:  0678      ldrb    r6, [r0]
0x000d8052:  0b1c      adds    r3, r1, #0
0x000d8054:  9e42      cmp     r6, r3
0x000d8056:  04d0      beq     #0xd8062
0x000d8058:  b446      mov     ip, r6
0x000d805a:  0e1c      adds    r6, r1, #0
0x000d805c:  e1e7      b       #0xd8022
0x000d805e:  0333      adds    r3, #3
0x000d8060:  a2e7      b       #0xd7fa8
0x000d8062:  0130      adds    r0, #1
0x000d8064:  0134      adds    r4, #1
0x000d8066:  211c      adds    r1, r4, #0
0x000d8068:  06e0      b       #0xd8078
0x000d806a:  0288      ldrh    r2, [r0]
0x000d806c:  0b88      ldrh    r3, [r1]
0x000d806e:  9a42      cmp     r2, r3
0x000d8070:  14d1      bne     #0xd809c
0x000d8072:  0230      adds    r0, #2
0x000d8074:  0231      adds    r1, #2
0x000d8076:  013d      subs    r5, #1
0x000d8078:  002d      cmp     r5, #0
0x000d807a:  f6dc      bgt     #0xd806a
0x000d807c:  002f      cmp     r7, #0
0x000d807e:  bcdd      ble     #0xd7ffa
0x000d8080:  0978      ldrb    r1, [r1]
0x000d8082:  0578      ldrb    r5, [r0]
0x000d8084:  0b1c      adds    r3, r1, #0
0x000d8086:  9d42      cmp     r5, r3
0x000d8088:  b7d0      beq     #0xd7ffa
0x000d808a:  ac46      mov     ip, r5
0x000d808c:  0e1c      adds    r6, r1, #0
0x000d808e:  c8e7      b       #0xd8022
0x000d8090:  0c1c      adds    r4, r1, #0
0x000d8092:  0427      movs    r7, #4
0x000d8094:  b7e7      b       #0xd8006
0x000d8096:  0120      movs    r0, #1
0x000d8098:  4042      rsbs    r0, r0, #0
0x000d809a:  afe7      b       #0xd7ffc
0x000d809c:  0c1c      adds    r4, r1, #0
0x000d809e:  0227      movs    r7, #2
0x000d80a0:  b1e7      b       #0xd8006
0x000d80a2:  0000      movs    r0, r0
0x000d80a4:  10b5      push    {r4, lr}
0x000d80a6:  1204      lsls    r2, r2, #0x10
0x000d80a8:  0906      lsls    r1, r1, #0x18
0x000d80aa:  120c      lsrs    r2, r2, #0x10
0x000d80ac:  0c0e      lsrs    r4, r1, #0x18
0x000d80ae:  032a      cmp     r2, #3
0x000d80b0:  2ed9      bls     #0xd8110
0x000d80b2:  0323      movs    r3, #3
0x000d80b4:  011c      adds    r1, r0, #0
0x000d80b6:  1940      ands    r1, r3
0x000d80b8:  08d0      beq     #0xd80cc
0x000d80ba:  0423      movs    r3, #4
0x000d80bc:  5b1a      subs    r3, r3, r1
0x000d80be:  d21a      subs    r2, r2, r3
0x000d80c0:  02e0      b       #0xd80c8
0x000d80c2:  0470      strb    r4, [r0]
0x000d80c4:  013b      subs    r3, #1
0x000d80c6:  0130      adds    r0, #1
0x000d80c8:  002b      cmp     r3, #0
0x000d80ca:  fad1      bne     #0xd80c2
0x000d80cc:  2102      lsls    r1, r4, #8
0x000d80ce:  2143      orrs    r1, r4
0x000d80d0:  0b04      lsls    r3, r1, #0x10
0x000d80d2:  1943      orrs    r1, r3
0x000d80d4:  05e0      b       #0xd80e2
0x000d80d6:  0160      str     r1, [r0]
0x000d80d8:  4160      str     r1, [r0, #4]
0x000d80da:  8160      str     r1, [r0, #8]
0x000d80dc:  c160      str     r1, [r0, #0xc]
0x000d80de:  103a      subs    r2, #0x10
0x000d80e0:  1030      adds    r0, #0x10
0x000d80e2:  0f2a      cmp     r2, #0xf
0x000d80e4:  f7d8      bhi     #0xd80d6
0x000d80e6:  032a      cmp     r2, #3
0x000d80e8:  0bd9      bls     #0xd8102
0x000d80ea:  02c0      stm     r0!, {r1}
0x000d80ec:  043a      subs    r2, #4
0x000d80ee:  032a      cmp     r2, #3
0x000d80f0:  fbd8      bhi     #0xd80ea
0x000d80f2:  032a      cmp     r2, #3
0x000d80f4:  0cd9      bls     #0xd8110
0x000d80f6:  0470      strb    r4, [r0]
0x000d80f8:  4470      strb    r4, [r0, #1]
0x000d80fa:  8470      strb    r4, [r0, #2]
0x000d80fc:  c470      strb    r4, [r0, #3]
0x000d80fe:  043a      subs    r2, #4
0x000d8100:  0430      adds    r0, #4
0x000d8102:  032a      cmp     r2, #3
0x000d8104:  f7d8      bhi     #0xd80f6
0x000d8106:  002a      cmp     r2, #0
0x000d8108:  04d0      beq     #0xd8114
0x000d810a:  0470      strb    r4, [r0]
0x000d810c:  013a      subs    r2, #1
0x000d810e:  0130      adds    r0, #1
0x000d8110:  002a      cmp     r2, #0
0x000d8112:  fad1      bne     #0xd810a
0x000d8114:  10bc      pop     {r4}
0x000d8116:  01bc      pop     {r0}
0x000d8118:  0047      bx      r0
0x000d811a:  0000      movs    r0, r0
0x000d811c:  00b5      push    {lr}
0x000d811e:  0904      lsls    r1, r1, #0x10
0x000d8120:  1204      lsls    r2, r2, #0x10
0x000d8122:  090c      lsrs    r1, r1, #0x10
0x000d8124:  120c      lsrs    r2, r2, #0x10
0x000d8126:  08e0      b       #0xd813a
0x000d8128:  0180      strh    r1, [r0]
0x000d812a:  0230      adds    r0, #2
0x000d812c:  0180      strh    r1, [r0]
0x000d812e:  0230      adds    r0, #2
0x000d8130:  0180      strh    r1, [r0]
0x000d8132:  0230      adds    r0, #2

===== sub_000d7f7c @ 0x000d7f7c =====
0x000d7f7c:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d7f7e:  1204      lsls    r2, r2, #0x10
0x000d7f80:  170c      lsrs    r7, r2, #0x10
0x000d7f82:  031c      adds    r3, r0, #0
0x000d7f84:  0122      movs    r2, #1
0x000d7f86:  0c1c      adds    r4, r1, #0
0x000d7f88:  4b40      eors    r3, r1
0x000d7f8a:  111c      adds    r1, r2, #0
0x000d7f8c:  9943      bics    r1, r3
0x000d7f8e:  38d0      beq     #0xd8002
0x000d7f90:  0326      movs    r6, #3
0x000d7f92:  011c      adds    r1, r0, #0
0x000d7f94:  251c      adds    r5, r4, #0
0x000d7f96:  3140      ands    r1, r6
0x000d7f98:  3540      ands    r5, r6
0x000d7f9a:  a942      cmp     r1, r5
0x000d7f9c:  48d1      bne     #0xd8030
0x000d7f9e:  0423      movs    r3, #4
0x000d7fa0:  591a      subs    r1, r3, r1
0x000d7fa2:  3140      ands    r1, r6
0x000d7fa4:  7b1a      subs    r3, r7, r1
0x000d7fa6:  5ad4      bmi     #0xd805e
0x000d7fa8:  9d10      asrs    r5, r3, #2
0x000d7faa:  ab00      lsls    r3, r5, #2
0x000d7fac:  5b18      adds    r3, r3, r1
0x000d7fae:  ff1a      subs    r7, r7, r3
0x000d7fb0:  09e0      b       #0xd7fc6
0x000d7fb2:  0378      ldrb    r3, [r0]
0x000d7fb4:  2678      ldrb    r6, [r4]
0x000d7fb6:  9c46      mov     ip, r3
0x000d7fb8:  1a1c      adds    r2, r3, #0
0x000d7fba:  331c      adds    r3, r6, #0
0x000d7fbc:  9a42      cmp     r2, r3
0x000d7fbe:  30d1      bne     #0xd8022
0x000d7fc0:  0130      adds    r0, #1
0x000d7fc2:  0134      adds    r4, #1
0x000d7fc4:  0139      subs    r1, #1
0x000d7fc6:  0029      cmp     r1, #0
0x000d7fc8:  f3dc      bgt     #0xd7fb2
0x000d7fca:  211c      adds    r1, r4, #0
0x000d7fcc:  06e0      b       #0xd7fdc
0x000d7fce:  0268      ldr     r2, [r0]
0x000d7fd0:  0b68      ldr     r3, [r1]
0x000d7fd2:  9a42      cmp     r2, r3
0x000d7fd4:  5cd1      bne     #0xd8090
0x000d7fd6:  0430      adds    r0, #4
0x000d7fd8:  0431      adds    r1, #4
0x000d7fda:  013d      subs    r5, #1
0x000d7fdc:  002d      cmp     r5, #0
0x000d7fde:  f6dc      bgt     #0xd7fce
0x000d7fe0:  0c1c      adds    r4, r1, #0
0x000d7fe2:  08e0      b       #0xd7ff6
0x000d7fe4:  2678      ldrb    r6, [r4]
0x000d7fe6:  0178      ldrb    r1, [r0]
0x000d7fe8:  331c      adds    r3, r6, #0
0x000d7fea:  8c46      mov     ip, r1
0x000d7fec:  9942      cmp     r1, r3
0x000d7fee:  18d1      bne     #0xd8022
0x000d7ff0:  0130      adds    r0, #1
0x000d7ff2:  0134      adds    r4, #1
0x000d7ff4:  013f      subs    r7, #1
0x000d7ff6:  002f      cmp     r7, #0
0x000d7ff8:  f4dc      bgt     #0xd7fe4
0x000d7ffa:  0020      movs    r0, #0
0x000d7ffc:  f0bc      pop     {r4, r5, r6, r7}
0x000d7ffe:  02bc      pop     {r1}
0x000d8000:  0847      bx      r1
0x000d8002:  002f      cmp     r7, #0
0x000d8004:  08dd      ble     #0xd8018
0x000d8006:  0278      ldrb    r2, [r0]
0x000d8008:  2378      ldrb    r3, [r4]
0x000d800a:  9a42      cmp     r2, r3
0x000d800c:  04d1      bne     #0xd8018
0x000d800e:  0130      adds    r0, #1
0x000d8010:  0134      adds    r4, #1
0x000d8012:  013f      subs    r7, #1
0x000d8014:  002f      cmp     r7, #0
0x000d8016:  f6dc      bgt     #0xd8006
0x000d8018:  002f      cmp     r7, #0
0x000d801a:  eed0      beq     #0xd7ffa
0x000d801c:  0078      ldrb    r0, [r0]
0x000d801e:  2678      ldrb    r6, [r4]
0x000d8020:  8446      mov     ip, r0
0x000d8022:  6346      mov     r3, ip
0x000d8024:  1a06      lsls    r2, r3, #0x18
0x000d8026:  3306      lsls    r3, r6, #0x18
0x000d8028:  9342      cmp     r3, r2
0x000d802a:  34d2      bhs     #0xd8096
0x000d802c:  0120      movs    r0, #1
0x000d802e:  e5e7      b       #0xd7ffc
0x000d8030:  011c      adds    r1, r0, #0
0x000d8032:  251c      adds    r5, r4, #0
0x000d8034:  1140      ands    r1, r2
0x000d8036:  1540      ands    r5, r2
0x000d8038:  a942      cmp     r1, r5
0x000d803a:  edd1      bne     #0xd8018
0x000d803c:  7b1a      subs    r3, r7, r1
0x000d803e:  da0f      lsrs    r2, r3, #0x1f
0x000d8040:  9b18      adds    r3, r3, r2
0x000d8042:  5d10      asrs    r5, r3, #1
0x000d8044:  6b00      lsls    r3, r5, #1
0x000d8046:  5b18      adds    r3, r3, r1
0x000d8048:  ff1a      subs    r7, r7, r3
0x000d804a:  0029      cmp     r1, #0
0x000d804c:  0bdd      ble     #0xd8066
0x000d804e:  2178      ldrb    r1, [r4]
0x000d8050:  0678      ldrb    r6, [r0]
0x000d8052:  0b1c      adds    r3, r1, #0
0x000d8054:  9e42      cmp     r6, r3
0x000d8056:  04d0      beq     #0xd8062
0x000d8058:  b446      mov     ip, r6
0x000d805a:  0e1c      adds    r6, r1, #0
0x000d805c:  e1e7      b       #0xd8022
0x000d805e:  0333      adds    r3, #3
0x000d8060:  a2e7      b       #0xd7fa8
0x000d8062:  0130      adds    r0, #1
0x000d8064:  0134      adds    r4, #1
0x000d8066:  211c      adds    r1, r4, #0
0x000d8068:  06e0      b       #0xd8078
0x000d806a:  0288      ldrh    r2, [r0]
0x000d806c:  0b88      ldrh    r3, [r1]
0x000d806e:  9a42      cmp     r2, r3
0x000d8070:  14d1      bne     #0xd809c
0x000d8072:  0230      adds    r0, #2
0x000d8074:  0231      adds    r1, #2
0x000d8076:  013d      subs    r5, #1
0x000d8078:  002d      cmp     r5, #0
0x000d807a:  f6dc      bgt     #0xd806a
0x000d807c:  002f      cmp     r7, #0
0x000d807e:  bcdd      ble     #0xd7ffa
0x000d8080:  0978      ldrb    r1, [r1]
0x000d8082:  0578      ldrb    r5, [r0]
0x000d8084:  0b1c      adds    r3, r1, #0
0x000d8086:  9d42      cmp     r5, r3
0x000d8088:  b7d0      beq     #0xd7ffa
0x000d808a:  ac46      mov     ip, r5
0x000d808c:  0e1c      adds    r6, r1, #0
0x000d808e:  c8e7      b       #0xd8022
0x000d8090:  0c1c      adds    r4, r1, #0
0x000d8092:  0427      movs    r7, #4
0x000d8094:  b7e7      b       #0xd8006
0x000d8096:  0120      movs    r0, #1
0x000d8098:  4042      rsbs    r0, r0, #0
0x000d809a:  afe7      b       #0xd7ffc
0x000d809c:  0c1c      adds    r4, r1, #0
0x000d809e:  0227      movs    r7, #2
0x000d80a0:  b1e7      b       #0xd8006
0x000d80a2:  0000      movs    r0, r0
0x000d80a4:  10b5      push    {r4, lr}
0x000d80a6:  1204      lsls    r2, r2, #0x10
0x000d80a8:  0906      lsls    r1, r1, #0x18
0x000d80aa:  120c      lsrs    r2, r2, #0x10
0x000d80ac:  0c0e      lsrs    r4, r1, #0x18
0x000d80ae:  032a      cmp     r2, #3
0x000d80b0:  2ed9      bls     #0xd8110
0x000d80b2:  0323      movs    r3, #3
0x000d80b4:  011c      adds    r1, r0, #0
0x000d80b6:  1940      ands    r1, r3
0x000d80b8:  08d0      beq     #0xd80cc
0x000d80ba:  0423      movs    r3, #4
0x000d80bc:  5b1a      subs    r3, r3, r1
0x000d80be:  d21a      subs    r2, r2, r3
0x000d80c0:  02e0      b       #0xd80c8
0x000d80c2:  0470      strb    r4, [r0]
0x000d80c4:  013b      subs    r3, #1
0x000d80c6:  0130      adds    r0, #1
0x000d80c8:  002b      cmp     r3, #0
0x000d80ca:  fad1      bne     #0xd80c2
0x000d80cc:  2102      lsls    r1, r4, #8
0x000d80ce:  2143      orrs    r1, r4
0x000d80d0:  0b04      lsls    r3, r1, #0x10
0x000d80d2:  1943      orrs    r1, r3
0x000d80d4:  05e0      b       #0xd80e2
0x000d80d6:  0160      str     r1, [r0]
0x000d80d8:  4160      str     r1, [r0, #4]
0x000d80da:  8160      str     r1, [r0, #8]
0x000d80dc:  c160      str     r1, [r0, #0xc]
0x000d80de:  103a      subs    r2, #0x10
0x000d80e0:  1030      adds    r0, #0x10
0x000d80e2:  0f2a      cmp     r2, #0xf
0x000d80e4:  f7d8      bhi     #0xd80d6
0x000d80e6:  032a      cmp     r2, #3
0x000d80e8:  0bd9      bls     #0xd8102
0x000d80ea:  02c0      stm     r0!, {r1}
0x000d80ec:  043a      subs    r2, #4
0x000d80ee:  032a      cmp     r2, #3
0x000d80f0:  fbd8      bhi     #0xd80ea
0x000d80f2:  032a      cmp     r2, #3
0x000d80f4:  0cd9      bls     #0xd8110
0x000d80f6:  0470      strb    r4, [r0]
0x000d80f8:  4470      strb    r4, [r0, #1]
0x000d80fa:  8470      strb    r4, [r0, #2]
0x000d80fc:  c470      strb    r4, [r0, #3]
0x000d80fe:  043a      subs    r2, #4
0x000d8100:  0430      adds    r0, #4
0x000d8102:  032a      cmp     r2, #3
0x000d8104:  f7d8      bhi     #0xd80f6
0x000d8106:  002a      cmp     r2, #0
0x000d8108:  04d0      beq     #0xd8114
0x000d810a:  0470      strb    r4, [r0]
0x000d810c:  013a      subs    r2, #1
0x000d810e:  0130      adds    r0, #1
0x000d8110:  002a      cmp     r2, #0
0x000d8112:  fad1      bne     #0xd810a
0x000d8114:  10bc      pop     {r4}
0x000d8116:  01bc      pop     {r0}
0x000d8118:  0047      bx      r0
0x000d811a:  0000      movs    r0, r0
0x000d811c:  00b5      push    {lr}
0x000d811e:  0904      lsls    r1, r1, #0x10
0x000d8120:  1204      lsls    r2, r2, #0x10
0x000d8122:  090c      lsrs    r1, r1, #0x10
0x000d8124:  120c      lsrs    r2, r2, #0x10
0x000d8126:  08e0      b       #0xd813a
0x000d8128:  0180      strh    r1, [r0]
0x000d812a:  0230      adds    r0, #2
0x000d812c:  0180      strh    r1, [r0]
0x000d812e:  0230      adds    r0, #2
0x000d8130:  0180      strh    r1, [r0]
0x000d8132:  0230      adds    r0, #2
0x000d8134:  0180      strh    r1, [r0]
0x000d8136:  043a      subs    r2, #4
0x000d8138:  0230      adds    r0, #2
0x000d813a:  032a      cmp     r2, #3
0x000d813c:  f4dc      bgt     #0xd8128
0x000d813e:  002a      cmp     r2, #0
0x000d8140:  04dd      ble     #0xd814c
0x000d8142:  0180      strh    r1, [r0]
0x000d8144:  013a      subs    r2, #1
0x000d8146:  0230      adds    r0, #2
0x000d8148:  002a      cmp     r2, #0
0x000d814a:  fadc      bgt     #0xd8142
0x000d814c:  01bc      pop     {r0}
0x000d814e:  0047      bx      r0
0x000d8150:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d8152:  0906      lsls    r1, r1, #0x18
0x000d8154:  0f0e      lsrs    r7, r1, #0x18
0x000d8156:  061c      adds    r6, r0, #0
0x000d8158:  141e      subs    r4, r2, #0
0x000d815a:  0dd0      beq     #0xd8178

===== sub_000d80a4 @ 0x000d80a4 =====
0x000d80a4:  10b5      push    {r4, lr}
0x000d80a6:  1204      lsls    r2, r2, #0x10
0x000d80a8:  0906      lsls    r1, r1, #0x18
0x000d80aa:  120c      lsrs    r2, r2, #0x10
0x000d80ac:  0c0e      lsrs    r4, r1, #0x18
0x000d80ae:  032a      cmp     r2, #3
0x000d80b0:  2ed9      bls     #0xd8110
0x000d80b2:  0323      movs    r3, #3
0x000d80b4:  011c      adds    r1, r0, #0
0x000d80b6:  1940      ands    r1, r3
0x000d80b8:  08d0      beq     #0xd80cc
0x000d80ba:  0423      movs    r3, #4
0x000d80bc:  5b1a      subs    r3, r3, r1
0x000d80be:  d21a      subs    r2, r2, r3
0x000d80c0:  02e0      b       #0xd80c8
0x000d80c2:  0470      strb    r4, [r0]
0x000d80c4:  013b      subs    r3, #1
0x000d80c6:  0130      adds    r0, #1
0x000d80c8:  002b      cmp     r3, #0
0x000d80ca:  fad1      bne     #0xd80c2
0x000d80cc:  2102      lsls    r1, r4, #8
0x000d80ce:  2143      orrs    r1, r4
0x000d80d0:  0b04      lsls    r3, r1, #0x10
0x000d80d2:  1943      orrs    r1, r3
0x000d80d4:  05e0      b       #0xd80e2
0x000d80d6:  0160      str     r1, [r0]
0x000d80d8:  4160      str     r1, [r0, #4]
0x000d80da:  8160      str     r1, [r0, #8]
0x000d80dc:  c160      str     r1, [r0, #0xc]
0x000d80de:  103a      subs    r2, #0x10
0x000d80e0:  1030      adds    r0, #0x10
0x000d80e2:  0f2a      cmp     r2, #0xf
0x000d80e4:  f7d8      bhi     #0xd80d6
0x000d80e6:  032a      cmp     r2, #3
0x000d80e8:  0bd9      bls     #0xd8102
0x000d80ea:  02c0      stm     r0!, {r1}
0x000d80ec:  043a      subs    r2, #4
0x000d80ee:  032a      cmp     r2, #3
0x000d80f0:  fbd8      bhi     #0xd80ea
0x000d80f2:  032a      cmp     r2, #3
0x000d80f4:  0cd9      bls     #0xd8110
0x000d80f6:  0470      strb    r4, [r0]
0x000d80f8:  4470      strb    r4, [r0, #1]
0x000d80fa:  8470      strb    r4, [r0, #2]
0x000d80fc:  c470      strb    r4, [r0, #3]
0x000d80fe:  043a      subs    r2, #4
0x000d8100:  0430      adds    r0, #4
0x000d8102:  032a      cmp     r2, #3
0x000d8104:  f7d8      bhi     #0xd80f6
0x000d8106:  002a      cmp     r2, #0
0x000d8108:  04d0      beq     #0xd8114
0x000d810a:  0470      strb    r4, [r0]
0x000d810c:  013a      subs    r2, #1
0x000d810e:  0130      adds    r0, #1
0x000d8110:  002a      cmp     r2, #0
0x000d8112:  fad1      bne     #0xd810a
0x000d8114:  10bc      pop     {r4}
0x000d8116:  01bc      pop     {r0}
0x000d8118:  0047      bx      r0
0x000d811a:  0000      movs    r0, r0
0x000d811c:  00b5      push    {lr}
0x000d811e:  0904      lsls    r1, r1, #0x10
0x000d8120:  1204      lsls    r2, r2, #0x10
0x000d8122:  090c      lsrs    r1, r1, #0x10
0x000d8124:  120c      lsrs    r2, r2, #0x10
0x000d8126:  08e0      b       #0xd813a
0x000d8128:  0180      strh    r1, [r0]
0x000d812a:  0230      adds    r0, #2
0x000d812c:  0180      strh    r1, [r0]
0x000d812e:  0230      adds    r0, #2
0x000d8130:  0180      strh    r1, [r0]
0x000d8132:  0230      adds    r0, #2
0x000d8134:  0180      strh    r1, [r0]
0x000d8136:  043a      subs    r2, #4
0x000d8138:  0230      adds    r0, #2
0x000d813a:  032a      cmp     r2, #3
0x000d813c:  f4dc      bgt     #0xd8128
0x000d813e:  002a      cmp     r2, #0
0x000d8140:  04dd      ble     #0xd814c
0x000d8142:  0180      strh    r1, [r0]
0x000d8144:  013a      subs    r2, #1
0x000d8146:  0230      adds    r0, #2
0x000d8148:  002a      cmp     r2, #0
0x000d814a:  fadc      bgt     #0xd8142
0x000d814c:  01bc      pop     {r0}
0x000d814e:  0047      bx      r0
0x000d8150:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d8152:  0906      lsls    r1, r1, #0x18
0x000d8154:  0f0e      lsrs    r7, r1, #0x18
0x000d8156:  061c      adds    r6, r0, #0
0x000d8158:  141e      subs    r4, r2, #0
0x000d815a:  0dd0      beq     #0xd8178
0x000d815c:  084d      ldr     r5, [pc, #0x20]
0x000d815e:  ac42      cmp     r4, r5
0x000d8160:  00d2      bhs     #0xd8164
0x000d8162:  251c      adds    r5, r4, #0
0x000d8164:  2a04      lsls    r2, r5, #0x10
0x000d8166:  301c      adds    r0, r6, #0
0x000d8168:  391c      adds    r1, r7, #0
0x000d816a:  120c      lsrs    r2, r2, #0x10
0x000d816c:  641b      subs    r4, r4, r5
0x000d816e:  fff799ff  bl      #0xd80a4  ; sub_000d80a4
0x000d8172:  7619      adds    r6, r6, r5
0x000d8174:  002c      cmp     r4, #0
0x000d8176:  f1d1      bne     #0xd815c
0x000d8178:  f0bc      pop     {r4, r5, r6, r7}
0x000d817a:  01bc      pop     {r0}
0x000d817c:  0047      bx      r0
0x000d817e:  0000      movs    r0, r0

===== sub_000d8184 @ 0x000d8184 =====
0x000d8184:  ff22      movs    r2, #0xff
0x000d8186:  031c      adds    r3, r0, #0
0x000d8188:  1340      ands    r3, r2
0x000d818a:  000a      lsrs    r0, r0, #8
0x000d818c:  1b02      lsls    r3, r3, #8
0x000d818e:  1040      ands    r0, r2
0x000d8190:  1843      orrs    r0, r3
0x000d8192:  7047      bx      lr

===== sub_000d8194 @ 0x000d8194 =====
0x000d8194:  ff21      movs    r1, #0xff
0x000d8196:  021c      adds    r2, r0, #0
0x000d8198:  130a      lsrs    r3, r2, #8
0x000d819a:  0840      ands    r0, r1
0x000d819c:  0b40      ands    r3, r1
0x000d819e:  0002      lsls    r0, r0, #8
0x000d81a0:  1843      orrs    r0, r3
0x000d81a2:  130c      lsrs    r3, r2, #0x10
0x000d81a4:  0b40      ands    r3, r1
0x000d81a6:  120e      lsrs    r2, r2, #0x18
0x000d81a8:  0a40      ands    r2, r1
0x000d81aa:  1b02      lsls    r3, r3, #8
0x000d81ac:  1343      orrs    r3, r2
0x000d81ae:  0004      lsls    r0, r0, #0x10
0x000d81b0:  1843      orrs    r0, r3
0x000d81b2:  7047      bx      lr

===== sub_000d81b4 @ 0x000d81b4 =====
0x000d81b4:  0170      strb    r1, [r0]
0x000d81b6:  090a      lsrs    r1, r1, #8
0x000d81b8:  4170      strb    r1, [r0, #1]
0x000d81ba:  7047      bx      lr

===== sub_000d81bc @ 0x000d81bc =====
0x000d81bc:  031c      adds    r3, r0, #0
0x000d81be:  5b78      ldrb    r3, [r3, #1]
0x000d81c0:  0078      ldrb    r0, [r0]
0x000d81c2:  1b02      lsls    r3, r3, #8
0x000d81c4:  1843      orrs    r0, r3
0x000d81c6:  7047      bx      lr

===== sub_000d81c8 @ 0x000d81c8 =====
0x000d81c8:  0b0a      lsrs    r3, r1, #8
0x000d81ca:  0170      strb    r1, [r0]
0x000d81cc:  4370      strb    r3, [r0, #1]
0x000d81ce:  0b0c      lsrs    r3, r1, #0x10
0x000d81d0:  090e      lsrs    r1, r1, #0x18
0x000d81d2:  8370      strb    r3, [r0, #2]
0x000d81d4:  c170      strb    r1, [r0, #3]
0x000d81d6:  7047      bx      lr

===== sub_000d81d8 @ 0x000d81d8 =====
0x000d81d8:  021c      adds    r2, r0, #0
0x000d81da:  5378      ldrb    r3, [r2, #1]
0x000d81dc:  0078      ldrb    r0, [r0]
0x000d81de:  1b02      lsls    r3, r3, #8
0x000d81e0:  1843      orrs    r0, r3
0x000d81e2:  9378      ldrb    r3, [r2, #2]
0x000d81e4:  1b04      lsls    r3, r3, #0x10
0x000d81e6:  1843      orrs    r0, r3
0x000d81e8:  d378      ldrb    r3, [r2, #3]
0x000d81ea:  1b06      lsls    r3, r3, #0x18
0x000d81ec:  1843      orrs    r0, r3
0x000d81ee:  7047      bx      lr

===== sub_000d83b0 @ 0x000d83b0 =====
0x000d83b0:  10b5      push    {r4, lr}
0x000d83b2:  0006      lsls    r0, r0, #0x18
0x000d83b4:  040e      lsrs    r4, r0, #0x18
0x000d83b6:  201c      adds    r0, r4, #0
0x000d83b8:  03f02cfd  bl      #0xdbe14  ; sub_000dbe14
0x000d83bc:  0f4b      ldr     r3, [pc, #0x3c]
0x000d83be:  1b88      ldrh    r3, [r3]
0x000d83c0:  002b      cmp     r3, #0
0x000d83c2:  18d0      beq     #0xd83f6
0x000d83c4:  0e4b      ldr     r3, [pc, #0x38]
0x000d83c6:  1a68      ldr     r2, [r3]
0x000d83c8:  002a      cmp     r2, #0
0x000d83ca:  14d0      beq     #0xd83f6
0x000d83cc:  0d49      ldr     r1, [pc, #0x34]
0x000d83ce:  0b88      ldrh    r3, [r1]
0x000d83d0:  002b      cmp     r3, #0
0x000d83d2:  10d0      beq     #0xd83f6
0x000d83d4:  0c48      ldr     r0, [pc, #0x30]
0x000d83d6:  0388      ldrh    r3, [r0]
0x000d83d8:  9c54      strb    r4, [r3, r2]
0x000d83da:  0133      adds    r3, #1
0x000d83dc:  1b04      lsls    r3, r3, #0x10
0x000d83de:  0988      ldrh    r1, [r1]
0x000d83e0:  1b0c      lsrs    r3, r3, #0x10
0x000d83e2:  9942      cmp     r1, r3
0x000d83e4:  00d8      bhi     #0xd83e8
0x000d83e6:  0023      movs    r3, #0
0x000d83e8:  084a      ldr     r2, [pc, #0x20]
0x000d83ea:  0380      strh    r3, [r0]
0x000d83ec:  1088      ldrh    r0, [r2]
0x000d83ee:  8842      cmp     r0, r1
0x000d83f0:  01d2      bhs     #0xd83f6
0x000d83f2:  431c      adds    r3, r0, #1
0x000d83f4:  1380      strh    r3, [r2]
0x000d83f6:  10bc      pop     {r4}
0x000d83f8:  01bc      pop     {r0}
0x000d83fa:  0047      bx      r0
0x000d83fc:  960b      lsrs    r6, r2, #0xe
0x000d83fe:  1000      movs    r0, r2
0x000d8400:  4c83      strh    r4, [r1, #0x1a]
0x000d8402:  0800      movs    r0, r1
0x000d8404:  4883      strh    r0, [r1, #0x1a]
0x000d8406:  0800      movs    r0, r1
0x000d8408:  4683      strh    r6, [r0, #0x1a]
0x000d840a:  0800      movs    r0, r1
0x000d840c:  4483      strh    r4, [r0, #0x1a]
0x000d840e:  0800      movs    r0, r1
0x000d8410:  00b5      push    {lr}
0x000d8412:  0d20      movs    r0, #0xd
0x000d8414:  fff7ccff  bl      #0xd83b0  ; sub_000d83b0
0x000d8418:  0a20      movs    r0, #0xa
0x000d841a:  fff7c9ff  bl      #0xd83b0  ; sub_000d83b0
0x000d841e:  01bc      pop     {r0}
0x000d8420:  0047      bx      r0
0x000d8422:  0000      movs    r0, r0
0x000d8424:  00b5      push    {lr}
0x000d8426:  0022      movs    r2, #0
0x000d8428:  00e0      b       #0xd842c
0x000d842a:  0132      adds    r2, #1
0x000d842c:  0378      ldrb    r3, [r0]
0x000d842e:  0130      adds    r0, #1
0x000d8430:  1b06      lsls    r3, r3, #0x18
0x000d8432:  002b      cmp     r3, #0
0x000d8434:  f9d1      bne     #0xd842a
0x000d8436:  101c      adds    r0, r2, #0
0x000d8438:  02bc      pop     {r1}
0x000d843a:  0847      bx      r1
0x000d843c:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d843e:  061c      adds    r6, r0, #0
0x000d8440:  03f02afd  bl      #0xdbe98  ; sub_000dbe98
0x000d8444:  204b      ldr     r3, [pc, #0x80]
0x000d8446:  1b88      ldrh    r3, [r3]
0x000d8448:  002b      cmp     r3, #0
0x000d844a:  07d0      beq     #0xd845c
0x000d844c:  1f4b      ldr     r3, [pc, #0x7c]
0x000d844e:  1b68      ldr     r3, [r3]
0x000d8450:  002b      cmp     r3, #0
0x000d8452:  03d0      beq     #0xd845c
0x000d8454:  1e4c      ldr     r4, [pc, #0x78]
0x000d8456:  2388      ldrh    r3, [r4]
0x000d8458:  002b      cmp     r3, #0
0x000d845a:  02d1      bne     #0xd8462
0x000d845c:  f0bc      pop     {r4, r5, r6, r7}
0x000d845e:  01bc      pop     {r0}
0x000d8460:  0047      bx      r0
0x000d8462:  301c      adds    r0, r6, #0
0x000d8464:  fff7deff  bl      #0xd8424  ; sub_000d8424
0x000d8468:  1a49      ldr     r1, [pc, #0x68]
0x000d846a:  0004      lsls    r0, r0, #0x10
0x000d846c:  050c      lsrs    r5, r0, #0x10
0x000d846e:  2088      ldrh    r0, [r4]
0x000d8470:  0f88      ldrh    r7, [r1]
0x000d8472:  031c      adds    r3, r0, #0
0x000d8474:  9f42      cmp     r7, r3
0x000d8476:  1fd3      blo     #0xd84b8
0x000d8478:  002d      cmp     r5, #0
0x000d847a:  efd0      beq     #0xd845c
0x000d847c:  164f      ldr     r7, [pc, #0x58]
0x000d847e:  0ee0      b       #0xd849e
0x000d8480:  5319      adds    r3, r2, r5
0x000d8482:  1b04      lsls    r3, r3, #0x10
0x000d8484:  2c1c      adds    r4, r5, #0
0x000d8486:  1a0c      lsrs    r2, r3, #0x10
0x000d8488:  3a80      strh    r2, [r7]
0x000d848a:  311c      adds    r1, r6, #0
0x000d848c:  221c      adds    r2, r4, #0
0x000d848e:  04f0f3fa  bl      #0xdca78  ; sub_000dca78
0x000d8492:  2b1b      subs    r3, r5, r4
0x000d8494:  1b04      lsls    r3, r3, #0x10
0x000d8496:  1d0c      lsrs    r5, r3, #0x10
0x000d8498:  3619      adds    r6, r6, r4
0x000d849a:  002d      cmp     r5, #0
0x000d849c:  ded0      beq     #0xd845c
0x000d849e:  0b4b      ldr     r3, [pc, #0x2c]
0x000d84a0:  3a88      ldrh    r2, [r7]
0x000d84a2:  1b68      ldr     r3, [r3]
0x000d84a4:  d018      adds    r0, r2, r3
0x000d84a6:  0a4b      ldr     r3, [pc, #0x28]
0x000d84a8:  1b88      ldrh    r3, [r3]
0x000d84aa:  9b1a      subs    r3, r3, r2
0x000d84ac:  1b04      lsls    r3, r3, #0x10
0x000d84ae:  1c0c      lsrs    r4, r3, #0x10
0x000d84b0:  ac42      cmp     r4, r5
0x000d84b2:  e5d8      bhi     #0xd8480
0x000d84b4:  0022      movs    r2, #0
0x000d84b6:  e7e7      b       #0xd8488
0x000d84b8:  c31b      subs    r3, r0, r7
0x000d84ba:  ab42      cmp     r3, r5
0x000d84bc:  02dd      ble     #0xd84c4
0x000d84be:  eb19      adds    r3, r5, r7
0x000d84c0:  0b80      strh    r3, [r1]
0x000d84c2:  d9e7      b       #0xd8478
0x000d84c4:  0880      strh    r0, [r1]
0x000d84c6:  d7e7      b       #0xd8478
0x000d84c8:  960b      lsrs    r6, r2, #0xe
0x000d84ca:  1000      movs    r0, r2
0x000d84cc:  4c83      strh    r4, [r1, #0x1a]
0x000d84ce:  0800      movs    r0, r1
0x000d84d0:  4883      strh    r0, [r1, #0x1a]
0x000d84d2:  0800      movs    r0, r1
0x000d84d4:  4483      strh    r4, [r0, #0x1a]
0x000d84d6:  0800      movs    r0, r1
0x000d84d8:  4683      strh    r6, [r0, #0x1a]
0x000d84da:  0800      movs    r0, r1
0x000d84dc:  00b5      push    {lr}
0x000d84de:  0006      lsls    r0, r0, #0x18
0x000d84e0:  000e      lsrs    r0, r0, #0x18
0x000d84e2:  6028      cmp     r0, #0x60
0x000d84e4:  00dd      ble     #0xd84e8
0x000d84e6:  2038      subs    r0, #0x20
0x000d84e8:  3038      subs    r0, #0x30
0x000d84ea:  0928      cmp     r0, #9
0x000d84ec:  04d9      bls     #0xd84f8
0x000d84ee:  0738      subs    r0, #7
0x000d84f0:  031c      adds    r3, r0, #0
0x000d84f2:  0a3b      subs    r3, #0xa
0x000d84f4:  052b      cmp     r3, #5
0x000d84f6:  01d8      bhi     #0xd84fc
0x000d84f8:  02bc      pop     {r1}
0x000d84fa:  0847      bx      r1
0x000d84fc:  0120      movs    r0, #1
0x000d84fe:  4042      rsbs    r0, r0, #0
0x000d8500:  fae7      b       #0xd84f8
0x000d8502:  0000      movs    r0, r0
0x000d8504:  00b5      push    {lr}
0x000d8506:  0006      lsls    r0, r0, #0x18
0x000d8508:  000e      lsrs    r0, r0, #0x18
0x000d850a:  0928      cmp     r0, #9
0x000d850c:  05d8      bhi     #0xd851a
0x000d850e:  031c      adds    r3, r0, #0
0x000d8510:  3033      adds    r3, #0x30
0x000d8512:  1b06      lsls    r3, r3, #0x18
0x000d8514:  180e      lsrs    r0, r3, #0x18
0x000d8516:  02bc      pop     {r1}
0x000d8518:  0847      bx      r1
0x000d851a:  031c      adds    r3, r0, #0
0x000d851c:  3733      adds    r3, #0x37
0x000d851e:  f8e7      b       #0xd8512
0x000d8520:  00b5      push    {lr}
0x000d8522:  0006      lsls    r0, r0, #0x18
0x000d8524:  000e      lsrs    r0, r0, #0x18
0x000d8526:  3038      subs    r0, #0x30
0x000d8528:  0306      lsls    r3, r0, #0x18
0x000d852a:  1b0e      lsrs    r3, r3, #0x18
0x000d852c:  092b      cmp     r3, #9
0x000d852e:  01d8      bhi     #0xd8534
0x000d8530:  02bc      pop     {r1}
0x000d8532:  0847      bx      r1
0x000d8534:  0120      movs    r0, #1
0x000d8536:  4042      rsbs    r0, r0, #0
0x000d8538:  fae7      b       #0xd8530
0x000d853a:  0000      movs    r0, r0
0x000d853c:  c023      movs    r3, #0xc0
0x000d853e:  9b05      lsls    r3, r3, #0x16
0x000d8540:  0006      lsls    r0, r0, #0x18
0x000d8542:  c018      adds    r0, r0, r3
0x000d8544:  000e      lsrs    r0, r0, #0x18
0x000d8546:  7047      bx      lr

===== sub_000d8410 @ 0x000d8410 =====
0x000d8410:  00b5      push    {lr}
0x000d8412:  0d20      movs    r0, #0xd
0x000d8414:  fff7ccff  bl      #0xd83b0  ; sub_000d83b0
0x000d8418:  0a20      movs    r0, #0xa
0x000d841a:  fff7c9ff  bl      #0xd83b0  ; sub_000d83b0
0x000d841e:  01bc      pop     {r0}
0x000d8420:  0047      bx      r0
0x000d8422:  0000      movs    r0, r0
0x000d8424:  00b5      push    {lr}
0x000d8426:  0022      movs    r2, #0
0x000d8428:  00e0      b       #0xd842c
0x000d842a:  0132      adds    r2, #1
0x000d842c:  0378      ldrb    r3, [r0]
0x000d842e:  0130      adds    r0, #1
0x000d8430:  1b06      lsls    r3, r3, #0x18
0x000d8432:  002b      cmp     r3, #0
0x000d8434:  f9d1      bne     #0xd842a
0x000d8436:  101c      adds    r0, r2, #0
0x000d8438:  02bc      pop     {r1}
0x000d843a:  0847      bx      r1
0x000d843c:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d843e:  061c      adds    r6, r0, #0
0x000d8440:  03f02afd  bl      #0xdbe98  ; sub_000dbe98
0x000d8444:  204b      ldr     r3, [pc, #0x80]
0x000d8446:  1b88      ldrh    r3, [r3]
0x000d8448:  002b      cmp     r3, #0
0x000d844a:  07d0      beq     #0xd845c
0x000d844c:  1f4b      ldr     r3, [pc, #0x7c]
0x000d844e:  1b68      ldr     r3, [r3]
0x000d8450:  002b      cmp     r3, #0
0x000d8452:  03d0      beq     #0xd845c
0x000d8454:  1e4c      ldr     r4, [pc, #0x78]
0x000d8456:  2388      ldrh    r3, [r4]
0x000d8458:  002b      cmp     r3, #0
0x000d845a:  02d1      bne     #0xd8462
0x000d845c:  f0bc      pop     {r4, r5, r6, r7}
0x000d845e:  01bc      pop     {r0}
0x000d8460:  0047      bx      r0
0x000d8462:  301c      adds    r0, r6, #0
0x000d8464:  fff7deff  bl      #0xd8424  ; sub_000d8424
0x000d8468:  1a49      ldr     r1, [pc, #0x68]
0x000d846a:  0004      lsls    r0, r0, #0x10
0x000d846c:  050c      lsrs    r5, r0, #0x10
0x000d846e:  2088      ldrh    r0, [r4]
0x000d8470:  0f88      ldrh    r7, [r1]
0x000d8472:  031c      adds    r3, r0, #0
0x000d8474:  9f42      cmp     r7, r3
0x000d8476:  1fd3      blo     #0xd84b8
0x000d8478:  002d      cmp     r5, #0
0x000d847a:  efd0      beq     #0xd845c
0x000d847c:  164f      ldr     r7, [pc, #0x58]
0x000d847e:  0ee0      b       #0xd849e
0x000d8480:  5319      adds    r3, r2, r5
0x000d8482:  1b04      lsls    r3, r3, #0x10
0x000d8484:  2c1c      adds    r4, r5, #0
0x000d8486:  1a0c      lsrs    r2, r3, #0x10
0x000d8488:  3a80      strh    r2, [r7]
0x000d848a:  311c      adds    r1, r6, #0
0x000d848c:  221c      adds    r2, r4, #0
0x000d848e:  04f0f3fa  bl      #0xdca78  ; sub_000dca78
0x000d8492:  2b1b      subs    r3, r5, r4
0x000d8494:  1b04      lsls    r3, r3, #0x10
0x000d8496:  1d0c      lsrs    r5, r3, #0x10
0x000d8498:  3619      adds    r6, r6, r4
0x000d849a:  002d      cmp     r5, #0
0x000d849c:  ded0      beq     #0xd845c
0x000d849e:  0b4b      ldr     r3, [pc, #0x2c]
0x000d84a0:  3a88      ldrh    r2, [r7]
0x000d84a2:  1b68      ldr     r3, [r3]
0x000d84a4:  d018      adds    r0, r2, r3
0x000d84a6:  0a4b      ldr     r3, [pc, #0x28]
0x000d84a8:  1b88      ldrh    r3, [r3]
0x000d84aa:  9b1a      subs    r3, r3, r2
0x000d84ac:  1b04      lsls    r3, r3, #0x10
0x000d84ae:  1c0c      lsrs    r4, r3, #0x10
0x000d84b0:  ac42      cmp     r4, r5
0x000d84b2:  e5d8      bhi     #0xd8480
0x000d84b4:  0022      movs    r2, #0
0x000d84b6:  e7e7      b       #0xd8488
0x000d84b8:  c31b      subs    r3, r0, r7
0x000d84ba:  ab42      cmp     r3, r5
0x000d84bc:  02dd      ble     #0xd84c4
0x000d84be:  eb19      adds    r3, r5, r7
0x000d84c0:  0b80      strh    r3, [r1]
0x000d84c2:  d9e7      b       #0xd8478
0x000d84c4:  0880      strh    r0, [r1]
0x000d84c6:  d7e7      b       #0xd8478
0x000d84c8:  960b      lsrs    r6, r2, #0xe
0x000d84ca:  1000      movs    r0, r2
0x000d84cc:  4c83      strh    r4, [r1, #0x1a]
0x000d84ce:  0800      movs    r0, r1
0x000d84d0:  4883      strh    r0, [r1, #0x1a]
0x000d84d2:  0800      movs    r0, r1
0x000d84d4:  4483      strh    r4, [r0, #0x1a]
0x000d84d6:  0800      movs    r0, r1
0x000d84d8:  4683      strh    r6, [r0, #0x1a]
0x000d84da:  0800      movs    r0, r1
0x000d84dc:  00b5      push    {lr}
0x000d84de:  0006      lsls    r0, r0, #0x18
0x000d84e0:  000e      lsrs    r0, r0, #0x18
0x000d84e2:  6028      cmp     r0, #0x60
0x000d84e4:  00dd      ble     #0xd84e8
0x000d84e6:  2038      subs    r0, #0x20
0x000d84e8:  3038      subs    r0, #0x30
0x000d84ea:  0928      cmp     r0, #9
0x000d84ec:  04d9      bls     #0xd84f8
0x000d84ee:  0738      subs    r0, #7
0x000d84f0:  031c      adds    r3, r0, #0
0x000d84f2:  0a3b      subs    r3, #0xa
0x000d84f4:  052b      cmp     r3, #5
0x000d84f6:  01d8      bhi     #0xd84fc
0x000d84f8:  02bc      pop     {r1}
0x000d84fa:  0847      bx      r1
0x000d84fc:  0120      movs    r0, #1
0x000d84fe:  4042      rsbs    r0, r0, #0
0x000d8500:  fae7      b       #0xd84f8
0x000d8502:  0000      movs    r0, r0
0x000d8504:  00b5      push    {lr}
0x000d8506:  0006      lsls    r0, r0, #0x18
0x000d8508:  000e      lsrs    r0, r0, #0x18
0x000d850a:  0928      cmp     r0, #9
0x000d850c:  05d8      bhi     #0xd851a
0x000d850e:  031c      adds    r3, r0, #0
0x000d8510:  3033      adds    r3, #0x30
0x000d8512:  1b06      lsls    r3, r3, #0x18
0x000d8514:  180e      lsrs    r0, r3, #0x18
0x000d8516:  02bc      pop     {r1}
0x000d8518:  0847      bx      r1
0x000d851a:  031c      adds    r3, r0, #0
0x000d851c:  3733      adds    r3, #0x37
0x000d851e:  f8e7      b       #0xd8512
0x000d8520:  00b5      push    {lr}
0x000d8522:  0006      lsls    r0, r0, #0x18
0x000d8524:  000e      lsrs    r0, r0, #0x18
0x000d8526:  3038      subs    r0, #0x30
0x000d8528:  0306      lsls    r3, r0, #0x18
0x000d852a:  1b0e      lsrs    r3, r3, #0x18
0x000d852c:  092b      cmp     r3, #9
0x000d852e:  01d8      bhi     #0xd8534
0x000d8530:  02bc      pop     {r1}
0x000d8532:  0847      bx      r1
0x000d8534:  0120      movs    r0, #1
0x000d8536:  4042      rsbs    r0, r0, #0
0x000d8538:  fae7      b       #0xd8530
0x000d853a:  0000      movs    r0, r0
0x000d853c:  c023      movs    r3, #0xc0
0x000d853e:  9b05      lsls    r3, r3, #0x16
0x000d8540:  0006      lsls    r0, r0, #0x18
0x000d8542:  c018      adds    r0, r0, r3
0x000d8544:  000e      lsrs    r0, r0, #0x18
0x000d8546:  7047      bx      lr

===== sub_000d8424 @ 0x000d8424 =====
0x000d8424:  00b5      push    {lr}
0x000d8426:  0022      movs    r2, #0
0x000d8428:  00e0      b       #0xd842c
0x000d842a:  0132      adds    r2, #1
0x000d842c:  0378      ldrb    r3, [r0]
0x000d842e:  0130      adds    r0, #1
0x000d8430:  1b06      lsls    r3, r3, #0x18
0x000d8432:  002b      cmp     r3, #0
0x000d8434:  f9d1      bne     #0xd842a
0x000d8436:  101c      adds    r0, r2, #0
0x000d8438:  02bc      pop     {r1}
0x000d843a:  0847      bx      r1
0x000d843c:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d843e:  061c      adds    r6, r0, #0
0x000d8440:  03f02afd  bl      #0xdbe98  ; sub_000dbe98
0x000d8444:  204b      ldr     r3, [pc, #0x80]
0x000d8446:  1b88      ldrh    r3, [r3]
0x000d8448:  002b      cmp     r3, #0
0x000d844a:  07d0      beq     #0xd845c
0x000d844c:  1f4b      ldr     r3, [pc, #0x7c]
0x000d844e:  1b68      ldr     r3, [r3]
0x000d8450:  002b      cmp     r3, #0
0x000d8452:  03d0      beq     #0xd845c
0x000d8454:  1e4c      ldr     r4, [pc, #0x78]
0x000d8456:  2388      ldrh    r3, [r4]
0x000d8458:  002b      cmp     r3, #0
0x000d845a:  02d1      bne     #0xd8462
0x000d845c:  f0bc      pop     {r4, r5, r6, r7}
0x000d845e:  01bc      pop     {r0}
0x000d8460:  0047      bx      r0
0x000d8462:  301c      adds    r0, r6, #0
0x000d8464:  fff7deff  bl      #0xd8424  ; sub_000d8424
0x000d8468:  1a49      ldr     r1, [pc, #0x68]
0x000d846a:  0004      lsls    r0, r0, #0x10
0x000d846c:  050c      lsrs    r5, r0, #0x10
0x000d846e:  2088      ldrh    r0, [r4]
0x000d8470:  0f88      ldrh    r7, [r1]
0x000d8472:  031c      adds    r3, r0, #0
0x000d8474:  9f42      cmp     r7, r3
0x000d8476:  1fd3      blo     #0xd84b8
0x000d8478:  002d      cmp     r5, #0
0x000d847a:  efd0      beq     #0xd845c
0x000d847c:  164f      ldr     r7, [pc, #0x58]
0x000d847e:  0ee0      b       #0xd849e
0x000d8480:  5319      adds    r3, r2, r5
0x000d8482:  1b04      lsls    r3, r3, #0x10
0x000d8484:  2c1c      adds    r4, r5, #0
0x000d8486:  1a0c      lsrs    r2, r3, #0x10
0x000d8488:  3a80      strh    r2, [r7]
0x000d848a:  311c      adds    r1, r6, #0
0x000d848c:  221c      adds    r2, r4, #0
0x000d848e:  04f0f3fa  bl      #0xdca78  ; sub_000dca78
0x000d8492:  2b1b      subs    r3, r5, r4
0x000d8494:  1b04      lsls    r3, r3, #0x10
0x000d8496:  1d0c      lsrs    r5, r3, #0x10
0x000d8498:  3619      adds    r6, r6, r4
0x000d849a:  002d      cmp     r5, #0
0x000d849c:  ded0      beq     #0xd845c
0x000d849e:  0b4b      ldr     r3, [pc, #0x2c]
0x000d84a0:  3a88      ldrh    r2, [r7]
0x000d84a2:  1b68      ldr     r3, [r3]
0x000d84a4:  d018      adds    r0, r2, r3
0x000d84a6:  0a4b      ldr     r3, [pc, #0x28]
0x000d84a8:  1b88      ldrh    r3, [r3]
0x000d84aa:  9b1a      subs    r3, r3, r2
0x000d84ac:  1b04      lsls    r3, r3, #0x10
0x000d84ae:  1c0c      lsrs    r4, r3, #0x10
0x000d84b0:  ac42      cmp     r4, r5
0x000d84b2:  e5d8      bhi     #0xd8480
0x000d84b4:  0022      movs    r2, #0
0x000d84b6:  e7e7      b       #0xd8488
0x000d84b8:  c31b      subs    r3, r0, r7
0x000d84ba:  ab42      cmp     r3, r5
0x000d84bc:  02dd      ble     #0xd84c4
0x000d84be:  eb19      adds    r3, r5, r7
0x000d84c0:  0b80      strh    r3, [r1]
0x000d84c2:  d9e7      b       #0xd8478
0x000d84c4:  0880      strh    r0, [r1]
0x000d84c6:  d7e7      b       #0xd8478
0x000d84c8:  960b      lsrs    r6, r2, #0xe
0x000d84ca:  1000      movs    r0, r2
0x000d84cc:  4c83      strh    r4, [r1, #0x1a]
0x000d84ce:  0800      movs    r0, r1
0x000d84d0:  4883      strh    r0, [r1, #0x1a]
0x000d84d2:  0800      movs    r0, r1
0x000d84d4:  4483      strh    r4, [r0, #0x1a]
0x000d84d6:  0800      movs    r0, r1
0x000d84d8:  4683      strh    r6, [r0, #0x1a]
0x000d84da:  0800      movs    r0, r1
0x000d84dc:  00b5      push    {lr}
0x000d84de:  0006      lsls    r0, r0, #0x18
0x000d84e0:  000e      lsrs    r0, r0, #0x18
0x000d84e2:  6028      cmp     r0, #0x60
0x000d84e4:  00dd      ble     #0xd84e8
0x000d84e6:  2038      subs    r0, #0x20
0x000d84e8:  3038      subs    r0, #0x30
0x000d84ea:  0928      cmp     r0, #9
0x000d84ec:  04d9      bls     #0xd84f8
0x000d84ee:  0738      subs    r0, #7
0x000d84f0:  031c      adds    r3, r0, #0
0x000d84f2:  0a3b      subs    r3, #0xa
0x000d84f4:  052b      cmp     r3, #5
0x000d84f6:  01d8      bhi     #0xd84fc
0x000d84f8:  02bc      pop     {r1}
0x000d84fa:  0847      bx      r1
0x000d84fc:  0120      movs    r0, #1
0x000d84fe:  4042      rsbs    r0, r0, #0
0x000d8500:  fae7      b       #0xd84f8
0x000d8502:  0000      movs    r0, r0
0x000d8504:  00b5      push    {lr}
0x000d8506:  0006      lsls    r0, r0, #0x18
0x000d8508:  000e      lsrs    r0, r0, #0x18
0x000d850a:  0928      cmp     r0, #9
0x000d850c:  05d8      bhi     #0xd851a
0x000d850e:  031c      adds    r3, r0, #0
0x000d8510:  3033      adds    r3, #0x30
0x000d8512:  1b06      lsls    r3, r3, #0x18
0x000d8514:  180e      lsrs    r0, r3, #0x18
0x000d8516:  02bc      pop     {r1}
0x000d8518:  0847      bx      r1
0x000d851a:  031c      adds    r3, r0, #0
0x000d851c:  3733      adds    r3, #0x37
0x000d851e:  f8e7      b       #0xd8512
0x000d8520:  00b5      push    {lr}
0x000d8522:  0006      lsls    r0, r0, #0x18
0x000d8524:  000e      lsrs    r0, r0, #0x18
0x000d8526:  3038      subs    r0, #0x30
0x000d8528:  0306      lsls    r3, r0, #0x18
0x000d852a:  1b0e      lsrs    r3, r3, #0x18
0x000d852c:  092b      cmp     r3, #9
0x000d852e:  01d8      bhi     #0xd8534
0x000d8530:  02bc      pop     {r1}
0x000d8532:  0847      bx      r1
0x000d8534:  0120      movs    r0, #1
0x000d8536:  4042      rsbs    r0, r0, #0
0x000d8538:  fae7      b       #0xd8530
0x000d853a:  0000      movs    r0, r0
0x000d853c:  c023      movs    r3, #0xc0
0x000d853e:  9b05      lsls    r3, r3, #0x16
0x000d8540:  0006      lsls    r0, r0, #0x18
0x000d8542:  c018      adds    r0, r0, r3
0x000d8544:  000e      lsrs    r0, r0, #0x18
0x000d8546:  7047      bx      lr

===== sub_000d843c @ 0x000d843c =====
0x000d843c:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d843e:  061c      adds    r6, r0, #0
0x000d8440:  03f02afd  bl      #0xdbe98  ; sub_000dbe98
0x000d8444:  204b      ldr     r3, [pc, #0x80]
0x000d8446:  1b88      ldrh    r3, [r3]
0x000d8448:  002b      cmp     r3, #0
0x000d844a:  07d0      beq     #0xd845c
0x000d844c:  1f4b      ldr     r3, [pc, #0x7c]
0x000d844e:  1b68      ldr     r3, [r3]
0x000d8450:  002b      cmp     r3, #0
0x000d8452:  03d0      beq     #0xd845c
0x000d8454:  1e4c      ldr     r4, [pc, #0x78]
0x000d8456:  2388      ldrh    r3, [r4]
0x000d8458:  002b      cmp     r3, #0
0x000d845a:  02d1      bne     #0xd8462
0x000d845c:  f0bc      pop     {r4, r5, r6, r7}
0x000d845e:  01bc      pop     {r0}
0x000d8460:  0047      bx      r0
0x000d8462:  301c      adds    r0, r6, #0
0x000d8464:  fff7deff  bl      #0xd8424  ; sub_000d8424
0x000d8468:  1a49      ldr     r1, [pc, #0x68]
0x000d846a:  0004      lsls    r0, r0, #0x10
0x000d846c:  050c      lsrs    r5, r0, #0x10
0x000d846e:  2088      ldrh    r0, [r4]
0x000d8470:  0f88      ldrh    r7, [r1]
0x000d8472:  031c      adds    r3, r0, #0
0x000d8474:  9f42      cmp     r7, r3
0x000d8476:  1fd3      blo     #0xd84b8
0x000d8478:  002d      cmp     r5, #0
0x000d847a:  efd0      beq     #0xd845c
0x000d847c:  164f      ldr     r7, [pc, #0x58]
0x000d847e:  0ee0      b       #0xd849e
0x000d8480:  5319      adds    r3, r2, r5
0x000d8482:  1b04      lsls    r3, r3, #0x10
0x000d8484:  2c1c      adds    r4, r5, #0
0x000d8486:  1a0c      lsrs    r2, r3, #0x10
0x000d8488:  3a80      strh    r2, [r7]
0x000d848a:  311c      adds    r1, r6, #0
0x000d848c:  221c      adds    r2, r4, #0
0x000d848e:  04f0f3fa  bl      #0xdca78  ; sub_000dca78
0x000d8492:  2b1b      subs    r3, r5, r4
0x000d8494:  1b04      lsls    r3, r3, #0x10
0x000d8496:  1d0c      lsrs    r5, r3, #0x10
0x000d8498:  3619      adds    r6, r6, r4
0x000d849a:  002d      cmp     r5, #0
0x000d849c:  ded0      beq     #0xd845c
0x000d849e:  0b4b      ldr     r3, [pc, #0x2c]
0x000d84a0:  3a88      ldrh    r2, [r7]
0x000d84a2:  1b68      ldr     r3, [r3]
0x000d84a4:  d018      adds    r0, r2, r3
0x000d84a6:  0a4b      ldr     r3, [pc, #0x28]
0x000d84a8:  1b88      ldrh    r3, [r3]
0x000d84aa:  9b1a      subs    r3, r3, r2
0x000d84ac:  1b04      lsls    r3, r3, #0x10
0x000d84ae:  1c0c      lsrs    r4, r3, #0x10
0x000d84b0:  ac42      cmp     r4, r5
0x000d84b2:  e5d8      bhi     #0xd8480
0x000d84b4:  0022      movs    r2, #0
0x000d84b6:  e7e7      b       #0xd8488
0x000d84b8:  c31b      subs    r3, r0, r7
0x000d84ba:  ab42      cmp     r3, r5
0x000d84bc:  02dd      ble     #0xd84c4
0x000d84be:  eb19      adds    r3, r5, r7
0x000d84c0:  0b80      strh    r3, [r1]
0x000d84c2:  d9e7      b       #0xd8478
0x000d84c4:  0880      strh    r0, [r1]
0x000d84c6:  d7e7      b       #0xd8478
0x000d84c8:  960b      lsrs    r6, r2, #0xe
0x000d84ca:  1000      movs    r0, r2
0x000d84cc:  4c83      strh    r4, [r1, #0x1a]
0x000d84ce:  0800      movs    r0, r1
0x000d84d0:  4883      strh    r0, [r1, #0x1a]
0x000d84d2:  0800      movs    r0, r1
0x000d84d4:  4483      strh    r4, [r0, #0x1a]
0x000d84d6:  0800      movs    r0, r1
0x000d84d8:  4683      strh    r6, [r0, #0x1a]
0x000d84da:  0800      movs    r0, r1
0x000d84dc:  00b5      push    {lr}
0x000d84de:  0006      lsls    r0, r0, #0x18
0x000d84e0:  000e      lsrs    r0, r0, #0x18
0x000d84e2:  6028      cmp     r0, #0x60
0x000d84e4:  00dd      ble     #0xd84e8
0x000d84e6:  2038      subs    r0, #0x20
0x000d84e8:  3038      subs    r0, #0x30
0x000d84ea:  0928      cmp     r0, #9
0x000d84ec:  04d9      bls     #0xd84f8
0x000d84ee:  0738      subs    r0, #7
0x000d84f0:  031c      adds    r3, r0, #0
0x000d84f2:  0a3b      subs    r3, #0xa
0x000d84f4:  052b      cmp     r3, #5
0x000d84f6:  01d8      bhi     #0xd84fc
0x000d84f8:  02bc      pop     {r1}
0x000d84fa:  0847      bx      r1
0x000d84fc:  0120      movs    r0, #1
0x000d84fe:  4042      rsbs    r0, r0, #0
0x000d8500:  fae7      b       #0xd84f8
0x000d8502:  0000      movs    r0, r0
0x000d8504:  00b5      push    {lr}
0x000d8506:  0006      lsls    r0, r0, #0x18
0x000d8508:  000e      lsrs    r0, r0, #0x18
0x000d850a:  0928      cmp     r0, #9
0x000d850c:  05d8      bhi     #0xd851a
0x000d850e:  031c      adds    r3, r0, #0
0x000d8510:  3033      adds    r3, #0x30
0x000d8512:  1b06      lsls    r3, r3, #0x18
0x000d8514:  180e      lsrs    r0, r3, #0x18
0x000d8516:  02bc      pop     {r1}
0x000d8518:  0847      bx      r1
0x000d851a:  031c      adds    r3, r0, #0
0x000d851c:  3733      adds    r3, #0x37
0x000d851e:  f8e7      b       #0xd8512
0x000d8520:  00b5      push    {lr}
0x000d8522:  0006      lsls    r0, r0, #0x18
0x000d8524:  000e      lsrs    r0, r0, #0x18
0x000d8526:  3038      subs    r0, #0x30
0x000d8528:  0306      lsls    r3, r0, #0x18
0x000d852a:  1b0e      lsrs    r3, r3, #0x18
0x000d852c:  092b      cmp     r3, #9
0x000d852e:  01d8      bhi     #0xd8534
0x000d8530:  02bc      pop     {r1}
0x000d8532:  0847      bx      r1
0x000d8534:  0120      movs    r0, #1
0x000d8536:  4042      rsbs    r0, r0, #0
0x000d8538:  fae7      b       #0xd8530
0x000d853a:  0000      movs    r0, r0
0x000d853c:  c023      movs    r3, #0xc0
0x000d853e:  9b05      lsls    r3, r3, #0x16
0x000d8540:  0006      lsls    r0, r0, #0x18
0x000d8542:  c018      adds    r0, r0, r3
0x000d8544:  000e      lsrs    r0, r0, #0x18
0x000d8546:  7047      bx      lr

===== sub_000d8548 @ 0x000d8548 =====
0x000d8548:  30b5      push    {r4, r5, lr}
0x000d854a:  0006      lsls    r0, r0, #0x18
0x000d854c:  050e      lsrs    r5, r0, #0x18
0x000d854e:  000f      lsrs    r0, r0, #0x1c
0x000d8550:  0c1c      adds    r4, r1, #0
0x000d8552:  fff7d7ff  bl      #0xd8504  ; sub_000d8504
0x000d8556:  0f23      movs    r3, #0xf
0x000d8558:  2070      strb    r0, [r4]
0x000d855a:  281c      adds    r0, r5, #0
0x000d855c:  1840      ands    r0, r3
0x000d855e:  fff7d1ff  bl      #0xd8504  ; sub_000d8504
0x000d8562:  0134      adds    r4, #1
0x000d8564:  2070      strb    r0, [r4]
0x000d8566:  601c      adds    r0, r4, #1
0x000d8568:  30bc      pop     {r4, r5}
0x000d856a:  02bc      pop     {r1}
0x000d856c:  0847      bx      r1
0x000d856e:  0000      movs    r0, r0
0x000d8570:  10b5      push    {r4, lr}
0x000d8572:  81b0      sub     sp, #4
0x000d8574:  0006      lsls    r0, r0, #0x18
0x000d8576:  6946      mov     r1, sp
0x000d8578:  000e      lsrs    r0, r0, #0x18
0x000d857a:  fff7e5ff  bl      #0xd8548  ; sub_000d8548
0x000d857e:  0023      movs    r3, #0
0x000d8580:  0370      strb    r3, [r0]
0x000d8582:  6846      mov     r0, sp
0x000d8584:  fff75aff  bl      #0xd843c  ; sub_000d843c
0x000d8588:  0220      movs    r0, #2
0x000d858a:  01b0      add     sp, #4
0x000d858c:  10bc      pop     {r4}
0x000d858e:  02bc      pop     {r1}
0x000d8590:  0847      bx      r1
0x000d8592:  0000      movs    r0, r0
0x000d8594:  10b5      push    {r4, lr}
0x000d8596:  0004      lsls    r0, r0, #0x10
0x000d8598:  040c      lsrs    r4, r0, #0x10
0x000d859a:  000e      lsrs    r0, r0, #0x18
0x000d859c:  fff7d4ff  bl      #0xd8548  ; sub_000d8548
0x000d85a0:  2406      lsls    r4, r4, #0x18
0x000d85a2:  011c      adds    r1, r0, #0
0x000d85a4:  200e      lsrs    r0, r4, #0x18
0x000d85a6:  fff7cfff  bl      #0xd8548  ; sub_000d8548
0x000d85aa:  10bc      pop     {r4}
0x000d85ac:  02bc      pop     {r1}
0x000d85ae:  0847      bx      r1
0x000d85b0:  10b5      push    {r4, lr}
0x000d85b2:  82b0      sub     sp, #8
0x000d85b4:  0004      lsls    r0, r0, #0x10
0x000d85b6:  6946      mov     r1, sp
0x000d85b8:  000c      lsrs    r0, r0, #0x10
0x000d85ba:  fff7ebff  bl      #0xd8594  ; sub_000d8594
0x000d85be:  0023      movs    r3, #0
0x000d85c0:  0370      strb    r3, [r0]
0x000d85c2:  6846      mov     r0, sp
0x000d85c4:  fff73aff  bl      #0xd843c  ; sub_000d843c
0x000d85c8:  0420      movs    r0, #4
0x000d85ca:  02b0      add     sp, #8
0x000d85cc:  10bc      pop     {r4}
0x000d85ce:  02bc      pop     {r1}
0x000d85d0:  0847      bx      r1
0x000d85d2:  0000      movs    r0, r0
0x000d85d4:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d85d6:  5746      mov     r7, sl
0x000d85d8:  4646      mov     r6, r8
0x000d85da:  c0b4      push    {r6, r7}
0x000d85dc:  071c      adds    r7, r0, #0
0x000d85de:  0e1e      subs    r6, r1, #0
0x000d85e0:  55dd      ble     #0xd868e
0x000d85e2:  0023      movs    r3, #0
0x000d85e4:  9846      mov     r8, r3
0x000d85e6:  731e      subs    r3, r6, #1
0x000d85e8:  9a46      mov     sl, r3
0x000d85ea:  5346      mov     r3, sl
0x000d85ec:  002b      cmp     r3, #0
0x000d85ee:  49db      blt     #0xd8684
0x000d85f0:  1b11      asrs    r3, r3, #4
0x000d85f2:  4345      cmp     r3, r8
0x000d85f4:  4bdb      blt     #0xd868e
0x000d85f6:  2020      movs    r0, #0x20
0x000d85f8:  fff7dafe  bl      #0xd83b0  ; sub_000d83b0
0x000d85fc:  4346      mov     r3, r8
0x000d85fe:  1805      lsls    r0, r3, #0x14
0x000d8600:  000c      lsrs    r0, r0, #0x10
0x000d8602:  1d01      lsls    r5, r3, #4
0x000d8604:  fff7d4ff  bl      #0xd85b0  ; sub_000d85b0
0x000d8608:  3a20      movs    r0, #0x3a
0x000d860a:  fff7d1fe  bl      #0xd83b0  ; sub_000d83b0
0x000d860e:  0024      movs    r4, #0
0x000d8610:  09e0      b       #0xd8626
0x000d8612:  2020      movs    r0, #0x20
0x000d8614:  fff7ccfe  bl      #0xd83b0  ; sub_000d83b0
0x000d8618:  eb19      adds    r3, r5, r7
0x000d861a:  185d      ldrb    r0, [r3, r4]
0x000d861c:  0134      adds    r4, #1
0x000d861e:  fff7a7ff  bl      #0xd8570  ; sub_000d8570
0x000d8622:  0f2c      cmp     r4, #0xf
0x000d8624:  0edc      bgt     #0xd8644
0x000d8626:  2b19      adds    r3, r5, r4
0x000d8628:  b342      cmp     r3, r6
0x000d862a:  f2db      blt     #0xd8612
0x000d862c:  2020      movs    r0, #0x20
0x000d862e:  fff7bffe  bl      #0xd83b0  ; sub_000d83b0
0x000d8632:  2020      movs    r0, #0x20
0x000d8634:  fff7bcfe  bl      #0xd83b0  ; sub_000d83b0
0x000d8638:  0134      adds    r4, #1
0x000d863a:  2020      movs    r0, #0x20
0x000d863c:  fff7b8fe  bl      #0xd83b0  ; sub_000d83b0
0x000d8640:  0f2c      cmp     r4, #0xf
0x000d8642:  f0dd      ble     #0xd8626
0x000d8644:  2020      movs    r0, #0x20
0x000d8646:  fff7b3fe  bl      #0xd83b0  ; sub_000d83b0
0x000d864a:  2f20      movs    r0, #0x2f
0x000d864c:  fff7b0fe  bl      #0xd83b0  ; sub_000d83b0
0x000d8650:  2020      movs    r0, #0x20
0x000d8652:  fff7adfe  bl      #0xd83b0  ; sub_000d83b0
0x000d8656:  0024      movs    r4, #0
0x000d8658:  2b19      adds    r3, r5, r4
0x000d865a:  b342      cmp     r3, r6
0x000d865c:  08da      bge     #0xd8670
0x000d865e:  eb19      adds    r3, r5, r7
0x000d8660:  185d      ldrb    r0, [r3, r4]
0x000d8662:  031c      adds    r3, r0, #0
0x000d8664:  203b      subs    r3, #0x20
0x000d8666:  5f2b      cmp     r3, #0x5f
0x000d8668:  00d9      bls     #0xd866c
0x000d866a:  2e20      movs    r0, #0x2e
0x000d866c:  fff7a0fe  bl      #0xd83b0  ; sub_000d83b0
0x000d8670:  0134      adds    r4, #1
0x000d8672:  0f2c      cmp     r4, #0xf
0x000d8674:  f0dd      ble     #0xd8658
0x000d8676:  fff7cbfe  bl      #0xd8410  ; sub_000d8410
0x000d867a:  0123      movs    r3, #1
0x000d867c:  9844      add     r8, r3
0x000d867e:  5346      mov     r3, sl
0x000d8680:  002b      cmp     r3, #0
0x000d8682:  b5da      bge     #0xd85f0
0x000d8684:  331c      adds    r3, r6, #0
0x000d8686:  0e33      adds    r3, #0xe
0x000d8688:  1b11      asrs    r3, r3, #4
0x000d868a:  4345      cmp     r3, r8
0x000d868c:  b3da      bge     #0xd85f6
0x000d868e:  18bc      pop     {r3, r4}
0x000d8690:  9846      mov     r8, r3
0x000d8692:  a246      mov     sl, r4
0x000d8694:  f0bc      pop     {r4, r5, r6, r7}
0x000d8696:  01bc      pop     {r0}
0x000d8698:  0047      bx      r0
0x000d869a:  0000      movs    r0, r0
0x000d869c:  30b5      push    {r4, r5, lr}
0x000d869e:  041c      adds    r4, r0, #0
0x000d86a0:  0d1c      adds    r5, r1, #0
0x000d86a2:  101e      subs    r0, r2, #0
0x000d86a4:  03d0      beq     #0xd86ae
0x000d86a6:  fff7c9fe  bl      #0xd843c  ; sub_000d843c
0x000d86aa:  fff7b1fe  bl      #0xd8410  ; sub_000d8410
0x000d86ae:  291c      adds    r1, r5, #0
0x000d86b0:  201c      adds    r0, r4, #0
0x000d86b2:  fff78fff  bl      #0xd85d4  ; sub_000d85d4
0x000d86b6:  30bc      pop     {r4, r5}
0x000d86b8:  01bc      pop     {r0}
0x000d86ba:  0047      bx      r0
0x000d86bc:  10b5      push    {r4, lr}
0x000d86be:  041c      adds    r4, r0, #0
0x000d86c0:  000c      lsrs    r0, r0, #0x10
0x000d86c2:  fff767ff  bl      #0xd8594  ; sub_000d8594
0x000d86c6:  2404      lsls    r4, r4, #0x10
0x000d86c8:  011c      adds    r1, r0, #0
0x000d86ca:  200c      lsrs    r0, r4, #0x10
0x000d86cc:  fff762ff  bl      #0xd8594  ; sub_000d8594
0x000d86d0:  10bc      pop     {r4}
0x000d86d2:  02bc      pop     {r1}
0x000d86d4:  0847      bx      r1
0x000d86d6:  0000      movs    r0, r0
0x000d86d8:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d86da:  154e      ldr     r6, [pc, #0x54]
0x000d86dc:  0004      lsls    r0, r0, #0x10
0x000d86de:  3388      ldrh    r3, [r6]
0x000d86e0:  0d1c      adds    r5, r1, #0
0x000d86e2:  000c      lsrs    r0, r0, #0x10
0x000d86e4:  0027      movs    r7, #0
0x000d86e6:  311c      adds    r1, r6, #0
0x000d86e8:  012b      cmp     r3, #1
0x000d86ea:  19d9      bls     #0xd8720
0x000d86ec:  0022      movs    r2, #0
0x000d86ee:  0024      movs    r4, #0
0x000d86f0:  525a      ldrh    r2, [r2, r1]
0x000d86f2:  0021      movs    r1, #0
0x000d86f4:  03e0      b       #0xd86fe
0x000d86f6:  831a      subs    r3, r0, r2
0x000d86f8:  1b04      lsls    r3, r3, #0x10
0x000d86fa:  180c      lsrs    r0, r3, #0x10
0x000d86fc:  0131      adds    r1, #1
0x000d86fe:  9042      cmp     r0, r2
0x000d8700:  f9d2      bhs     #0xd86f6
0x000d8702:  002f      cmp     r7, #0
0x000d8704:  01d1      bne     #0xd870a
0x000d8706:  0029      cmp     r1, #0
0x000d8708:  04d0      beq     #0xd8714
0x000d870a:  0b1c      adds    r3, r1, #0
0x000d870c:  3033      adds    r3, #0x30
0x000d870e:  2b70      strb    r3, [r5]
0x000d8710:  0127      movs    r7, #1
0x000d8712:  0135      adds    r5, #1
0x000d8714:  0234      adds    r4, #2
0x000d8716:  a35b      ldrh    r3, [r4, r6]
0x000d8718:  311c      adds    r1, r6, #0
0x000d871a:  221c      adds    r2, r4, #0
0x000d871c:  012b      cmp     r3, #1
0x000d871e:  e7d8      bhi     #0xd86f0
0x000d8720:  031c      adds    r3, r0, #0
0x000d8722:  3033      adds    r3, #0x30
0x000d8724:  681c      adds    r0, r5, #1
0x000d8726:  2b70      strb    r3, [r5]

===== sub_000d86d8 @ 0x000d86d8 =====
0x000d86d8:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d86da:  154e      ldr     r6, [pc, #0x54]
0x000d86dc:  0004      lsls    r0, r0, #0x10
0x000d86de:  3388      ldrh    r3, [r6]
0x000d86e0:  0d1c      adds    r5, r1, #0
0x000d86e2:  000c      lsrs    r0, r0, #0x10
0x000d86e4:  0027      movs    r7, #0
0x000d86e6:  311c      adds    r1, r6, #0
0x000d86e8:  012b      cmp     r3, #1
0x000d86ea:  19d9      bls     #0xd8720
0x000d86ec:  0022      movs    r2, #0
0x000d86ee:  0024      movs    r4, #0
0x000d86f0:  525a      ldrh    r2, [r2, r1]
0x000d86f2:  0021      movs    r1, #0
0x000d86f4:  03e0      b       #0xd86fe
0x000d86f6:  831a      subs    r3, r0, r2
0x000d86f8:  1b04      lsls    r3, r3, #0x10
0x000d86fa:  180c      lsrs    r0, r3, #0x10
0x000d86fc:  0131      adds    r1, #1
0x000d86fe:  9042      cmp     r0, r2
0x000d8700:  f9d2      bhs     #0xd86f6
0x000d8702:  002f      cmp     r7, #0
0x000d8704:  01d1      bne     #0xd870a
0x000d8706:  0029      cmp     r1, #0
0x000d8708:  04d0      beq     #0xd8714
0x000d870a:  0b1c      adds    r3, r1, #0
0x000d870c:  3033      adds    r3, #0x30
0x000d870e:  2b70      strb    r3, [r5]
0x000d8710:  0127      movs    r7, #1
0x000d8712:  0135      adds    r5, #1
0x000d8714:  0234      adds    r4, #2
0x000d8716:  a35b      ldrh    r3, [r4, r6]
0x000d8718:  311c      adds    r1, r6, #0
0x000d871a:  221c      adds    r2, r4, #0
0x000d871c:  012b      cmp     r3, #1
0x000d871e:  e7d8      bhi     #0xd86f0
0x000d8720:  031c      adds    r3, r0, #0
0x000d8722:  3033      adds    r3, #0x30
0x000d8724:  681c      adds    r0, r5, #1
0x000d8726:  2b70      strb    r3, [r5]
0x000d8728:  f0bc      pop     {r4, r5, r6, r7}
0x000d872a:  02bc      pop     {r1}
0x000d872c:  0847      bx      r1
0x000d872e:  0000      movs    r0, r0
0x000d8730:  c00b      lsrs    r0, r0, #0xf
0x000d8732:  1000      movs    r0, r2
0x000d8734:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d8736:  124d      ldr     r5, [pc, #0x48]
0x000d8738:  0c1c      adds    r4, r1, #0
0x000d873a:  2b68      ldr     r3, [r5]
0x000d873c:  0027      movs    r7, #0
0x000d873e:  2e1c      adds    r6, r5, #0
0x000d8740:  012b      cmp     r3, #1
0x000d8742:  16d9      bls     #0xd8772
0x000d8744:  0022      movs    r2, #0
0x000d8746:  0021      movs    r1, #0
0x000d8748:  9259      ldr     r2, [r2, r6]
0x000d874a:  0023      movs    r3, #0
0x000d874c:  01e0      b       #0xd8752
0x000d874e:  801a      subs    r0, r0, r2
0x000d8750:  0133      adds    r3, #1
0x000d8752:  9042      cmp     r0, r2
0x000d8754:  fbd2      bhs     #0xd874e
0x000d8756:  002f      cmp     r7, #0
0x000d8758:  01d1      bne     #0xd875e
0x000d875a:  002b      cmp     r3, #0
0x000d875c:  03d0      beq     #0xd8766
0x000d875e:  3033      adds    r3, #0x30
0x000d8760:  2370      strb    r3, [r4]
0x000d8762:  0127      movs    r7, #1
0x000d8764:  0134      adds    r4, #1
0x000d8766:  0431      adds    r1, #4
0x000d8768:  4b59      ldr     r3, [r1, r5]
0x000d876a:  2e1c      adds    r6, r5, #0
0x000d876c:  0a1c      adds    r2, r1, #0
0x000d876e:  012b      cmp     r3, #1
0x000d8770:  ead8      bhi     #0xd8748
0x000d8772:  031c      adds    r3, r0, #0
0x000d8774:  3033      adds    r3, #0x30
0x000d8776:  601c      adds    r0, r4, #1
0x000d8778:  2370      strb    r3, [r4]
0x000d877a:  f0bc      pop     {r4, r5, r6, r7}
0x000d877c:  02bc      pop     {r1}
0x000d877e:  0847      bx      r1
0x000d8780:  980b      lsrs    r0, r3, #0xe
0x000d8782:  1000      movs    r0, r2
0x000d8784:  70b5      push    {r4, r5, r6, lr}
0x000d8786:  051c      adds    r5, r0, #0
0x000d8788:  000e      lsrs    r0, r0, #0x18
0x000d878a:  fff7a5ff  bl      #0xd86d8  ; sub_000d86d8
0x000d878e:  2e24      movs    r4, #0x2e
0x000d8790:  ff26      movs    r6, #0xff
0x000d8792:  0470      strb    r4, [r0]
0x000d8794:  011c      adds    r1, r0, #0
0x000d8796:  280c      lsrs    r0, r5, #0x10
0x000d8798:  3040      ands    r0, r6
0x000d879a:  0131      adds    r1, #1
0x000d879c:  fff79cff  bl      #0xd86d8  ; sub_000d86d8
0x000d87a0:  0470      strb    r4, [r0]
0x000d87a2:  011c      adds    r1, r0, #0
0x000d87a4:  280a      lsrs    r0, r5, #8
0x000d87a6:  3040      ands    r0, r6
0x000d87a8:  0131      adds    r1, #1
0x000d87aa:  fff795ff  bl      #0xd86d8  ; sub_000d86d8
0x000d87ae:  0470      strb    r4, [r0]
0x000d87b0:  011c      adds    r1, r0, #0
0x000d87b2:  281c      adds    r0, r5, #0
0x000d87b4:  3040      ands    r0, r6
0x000d87b6:  0131      adds    r1, #1
0x000d87b8:  fff78eff  bl      #0xd86d8  ; sub_000d86d8
0x000d87bc:  0023      movs    r3, #0
0x000d87be:  0370      strb    r3, [r0]
0x000d87c0:  70bc      pop     {r4, r5, r6}
0x000d87c2:  02bc      pop     {r1}
0x000d87c4:  0847      bx      r1
0x000d87c6:  0000      movs    r0, r0
0x000d87c8:  00b5      push    {lr}
0x000d87ca:  d022      movs    r2, #0xd0
0x000d87cc:  0006      lsls    r0, r0, #0x18
0x000d87ce:  1206      lsls    r2, r2, #0x18
0x000d87d0:  8018      adds    r0, r0, r2
0x000d87d2:  000e      lsrs    r0, r0, #0x18
0x000d87d4:  0023      movs    r3, #0
0x000d87d6:  0928      cmp     r0, #9
0x000d87d8:  00d8      bhi     #0xd87dc
0x000d87da:  0123      movs    r3, #1
0x000d87dc:  181c      adds    r0, r3, #0
0x000d87de:  02bc      pop     {r1}
0x000d87e0:  0847      bx      r1
0x000d87e2:  0000      movs    r0, r0
0x000d87e4:  30b5      push    {r4, r5, lr}
0x000d87e6:  0d1c      adds    r5, r1, #0
0x000d87e8:  0a24      movs    r4, #0xa
0x000d87ea:  0021      movs    r1, #0
0x000d87ec:  08e0      b       #0xd8800
0x000d87ee:  0b1c      adds    r3, r1, #0
0x000d87f0:  6343      muls    r3, r4, r3
0x000d87f2:  1b04      lsls    r3, r3, #0x10
0x000d87f4:  190c      lsrs    r1, r3, #0x10
0x000d87f6:  5318      adds    r3, r2, r1
0x000d87f8:  303b      subs    r3, #0x30
0x000d87fa:  1b04      lsls    r3, r3, #0x10
0x000d87fc:  190c      lsrs    r1, r3, #0x10
0x000d87fe:  0130      adds    r0, #1
0x000d8800:  0278      ldrb    r2, [r0]
0x000d8802:  131c      adds    r3, r2, #0
0x000d8804:  303b      subs    r3, #0x30
0x000d8806:  092b      cmp     r3, #9
0x000d8808:  f1d9      bls     #0xd87ee
0x000d880a:  2980      strh    r1, [r5]
0x000d880c:  30bc      pop     {r4, r5}
0x000d880e:  02bc      pop     {r1}
0x000d8810:  0847      bx      r1
0x000d8812:  0000      movs    r0, r0
0x000d8814:  00b5      push    {lr}
0x000d8816:  0378      ldrb    r3, [r0]
0x000d8818:  202b      cmp     r3, #0x20
0x000d881a:  01d0      beq     #0xd8820
0x000d881c:  092b      cmp     r3, #9
0x000d881e:  01d1      bne     #0xd8824
0x000d8820:  0130      adds    r0, #1
0x000d8822:  f8e7      b       #0xd8816
0x000d8824:  02bc      pop     {r1}
0x000d8826:  0847      bx      r1
0x000d8828:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d882a:  4746      mov     r7, r8
0x000d882c:  80b4      push    {r7}
0x000d882e:  81b0      sub     sp, #4
0x000d8830:  6f46      mov     r7, sp
0x000d8832:  0237      adds    r7, #2
0x000d8834:  0023      movs    r3, #0
0x000d8836:  8046      mov     r8, r0
0x000d8838:  0d1c      adds    r5, r1, #0
0x000d883a:  3b80      strh    r3, [r7]
0x000d883c:  041c      adds    r4, r0, #0
0x000d883e:  0026      movs    r6, #0
0x000d8840:  2078      ldrb    r0, [r4]
0x000d8842:  fff7c1ff  bl      #0xd87c8  ; sub_000d87c8
0x000d8846:  0028      cmp     r0, #0
0x000d8848:  18d1      bne     #0xd887c
0x000d884a:  8023      movs    r3, #0x80
0x000d884c:  5b00      lsls    r3, r3, #1
0x000d884e:  3b80      strh    r3, [r7]
0x000d8850:  3a88      ldrh    r2, [r7]
0x000d8852:  ff2a      cmp     r2, #0xff
0x000d8854:  1ad8      bhi     #0xd888c
0x000d8856:  2378      ldrb    r3, [r4]
0x000d8858:  2e2b      cmp     r3, #0x2e
0x000d885a:  1bd0      beq     #0xd8894
0x000d885c:  2b68      ldr     r3, [r5]
0x000d885e:  0136      adds    r6, #1
0x000d8860:  1b02      lsls    r3, r3, #8
0x000d8862:  9b18      adds    r3, r3, r2
0x000d8864:  2b60      str     r3, [r5]
0x000d8866:  032e      cmp     r6, #3
0x000d8868:  eadd      ble     #0xd8840
0x000d886a:  201c      adds    r0, r4, #0
0x000d886c:  fff7d2ff  bl      #0xd8814  ; sub_000d8814
0x000d8870:  01b0      add     sp, #4
0x000d8872:  08bc      pop     {r3}
0x000d8874:  9846      mov     r8, r3
0x000d8876:  f0bc      pop     {r4, r5, r6, r7}
0x000d8878:  02bc      pop     {r1}
0x000d887a:  0847      bx      r1
0x000d887c:  201c      adds    r0, r4, #0
0x000d887e:  391c      adds    r1, r7, #0
0x000d8880:  fff7b0ff  bl      #0xd87e4  ; sub_000d87e4
0x000d8884:  3a88      ldrh    r2, [r7]
0x000d8886:  041c      adds    r4, r0, #0
0x000d8888:  ff2a      cmp     r2, #0xff
0x000d888a:  e4d9      bls     #0xd8856
0x000d888c:  0023      movs    r3, #0
0x000d888e:  4046      mov     r0, r8
0x000d8890:  2b60      str     r3, [r5]
0x000d8892:  ede7      b       #0xd8870
0x000d8894:  0134      adds    r4, #1
0x000d8896:  e1e7      b       #0xd885c
0x000d8898:  30b5      push    {r4, r5, lr}
0x000d889a:  0006      lsls    r0, r0, #0x18
0x000d889c:  050e      lsrs    r5, r0, #0x18
0x000d889e:  0722      movs    r2, #7
0x000d88a0:  8020      movs    r0, #0x80
0x000d88a2:  04e0      b       #0xd88ae
0x000d88a4:  3024      movs    r4, #0x30
0x000d88a6:  1c70      strb    r4, [r3]
0x000d88a8:  4008      lsrs    r0, r0, #1
0x000d88aa:  013a      subs    r2, #1
0x000d88ac:  08d4      bmi     #0xd88c0
0x000d88ae:  0b1c      adds    r3, r1, #0
0x000d88b0:  0131      adds    r1, #1
0x000d88b2:  2842      tst     r0, r5
0x000d88b4:  f6d0      beq     #0xd88a4
0x000d88b6:  3124      movs    r4, #0x31

===== sub_000d87e4 @ 0x000d87e4 =====
0x000d87e4:  30b5      push    {r4, r5, lr}
0x000d87e6:  0d1c      adds    r5, r1, #0
0x000d87e8:  0a24      movs    r4, #0xa
0x000d87ea:  0021      movs    r1, #0
0x000d87ec:  08e0      b       #0xd8800
0x000d87ee:  0b1c      adds    r3, r1, #0
0x000d87f0:  6343      muls    r3, r4, r3
0x000d87f2:  1b04      lsls    r3, r3, #0x10
0x000d87f4:  190c      lsrs    r1, r3, #0x10
0x000d87f6:  5318      adds    r3, r2, r1
0x000d87f8:  303b      subs    r3, #0x30
0x000d87fa:  1b04      lsls    r3, r3, #0x10
0x000d87fc:  190c      lsrs    r1, r3, #0x10
0x000d87fe:  0130      adds    r0, #1
0x000d8800:  0278      ldrb    r2, [r0]
0x000d8802:  131c      adds    r3, r2, #0
0x000d8804:  303b      subs    r3, #0x30
0x000d8806:  092b      cmp     r3, #9
0x000d8808:  f1d9      bls     #0xd87ee
0x000d880a:  2980      strh    r1, [r5]
0x000d880c:  30bc      pop     {r4, r5}
0x000d880e:  02bc      pop     {r1}
0x000d8810:  0847      bx      r1
0x000d8812:  0000      movs    r0, r0
0x000d8814:  00b5      push    {lr}
0x000d8816:  0378      ldrb    r3, [r0]
0x000d8818:  202b      cmp     r3, #0x20
0x000d881a:  01d0      beq     #0xd8820
0x000d881c:  092b      cmp     r3, #9
0x000d881e:  01d1      bne     #0xd8824
0x000d8820:  0130      adds    r0, #1
0x000d8822:  f8e7      b       #0xd8816
0x000d8824:  02bc      pop     {r1}
0x000d8826:  0847      bx      r1
0x000d8828:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d882a:  4746      mov     r7, r8
0x000d882c:  80b4      push    {r7}
0x000d882e:  81b0      sub     sp, #4
0x000d8830:  6f46      mov     r7, sp
0x000d8832:  0237      adds    r7, #2
0x000d8834:  0023      movs    r3, #0
0x000d8836:  8046      mov     r8, r0
0x000d8838:  0d1c      adds    r5, r1, #0
0x000d883a:  3b80      strh    r3, [r7]
0x000d883c:  041c      adds    r4, r0, #0
0x000d883e:  0026      movs    r6, #0
0x000d8840:  2078      ldrb    r0, [r4]
0x000d8842:  fff7c1ff  bl      #0xd87c8  ; sub_000d87c8
0x000d8846:  0028      cmp     r0, #0
0x000d8848:  18d1      bne     #0xd887c
0x000d884a:  8023      movs    r3, #0x80
0x000d884c:  5b00      lsls    r3, r3, #1
0x000d884e:  3b80      strh    r3, [r7]
0x000d8850:  3a88      ldrh    r2, [r7]
0x000d8852:  ff2a      cmp     r2, #0xff
0x000d8854:  1ad8      bhi     #0xd888c
0x000d8856:  2378      ldrb    r3, [r4]
0x000d8858:  2e2b      cmp     r3, #0x2e
0x000d885a:  1bd0      beq     #0xd8894
0x000d885c:  2b68      ldr     r3, [r5]
0x000d885e:  0136      adds    r6, #1
0x000d8860:  1b02      lsls    r3, r3, #8
0x000d8862:  9b18      adds    r3, r3, r2
0x000d8864:  2b60      str     r3, [r5]
0x000d8866:  032e      cmp     r6, #3
0x000d8868:  eadd      ble     #0xd8840
0x000d886a:  201c      adds    r0, r4, #0
0x000d886c:  fff7d2ff  bl      #0xd8814  ; sub_000d8814
0x000d8870:  01b0      add     sp, #4
0x000d8872:  08bc      pop     {r3}
0x000d8874:  9846      mov     r8, r3
0x000d8876:  f0bc      pop     {r4, r5, r6, r7}
0x000d8878:  02bc      pop     {r1}
0x000d887a:  0847      bx      r1
0x000d887c:  201c      adds    r0, r4, #0
0x000d887e:  391c      adds    r1, r7, #0
0x000d8880:  fff7b0ff  bl      #0xd87e4  ; sub_000d87e4
0x000d8884:  3a88      ldrh    r2, [r7]
0x000d8886:  041c      adds    r4, r0, #0
0x000d8888:  ff2a      cmp     r2, #0xff
0x000d888a:  e4d9      bls     #0xd8856
0x000d888c:  0023      movs    r3, #0
0x000d888e:  4046      mov     r0, r8
0x000d8890:  2b60      str     r3, [r5]
0x000d8892:  ede7      b       #0xd8870
0x000d8894:  0134      adds    r4, #1
0x000d8896:  e1e7      b       #0xd885c
0x000d8898:  30b5      push    {r4, r5, lr}
0x000d889a:  0006      lsls    r0, r0, #0x18
0x000d889c:  050e      lsrs    r5, r0, #0x18
0x000d889e:  0722      movs    r2, #7
0x000d88a0:  8020      movs    r0, #0x80
0x000d88a2:  04e0      b       #0xd88ae
0x000d88a4:  3024      movs    r4, #0x30
0x000d88a6:  1c70      strb    r4, [r3]
0x000d88a8:  4008      lsrs    r0, r0, #1
0x000d88aa:  013a      subs    r2, #1
0x000d88ac:  08d4      bmi     #0xd88c0
0x000d88ae:  0b1c      adds    r3, r1, #0
0x000d88b0:  0131      adds    r1, #1
0x000d88b2:  2842      tst     r0, r5
0x000d88b4:  f6d0      beq     #0xd88a4
0x000d88b6:  3124      movs    r4, #0x31
0x000d88b8:  1c70      strb    r4, [r3]
0x000d88ba:  4008      lsrs    r0, r0, #1
0x000d88bc:  013a      subs    r2, #1
0x000d88be:  f6d5      bpl     #0xd88ae
0x000d88c0:  081c      adds    r0, r1, #0
0x000d88c2:  30bc      pop     {r4, r5}
0x000d88c4:  02bc      pop     {r1}
0x000d88c6:  0847      bx      r1
0x000d88c8:  30b5      push    {r4, r5, lr}
0x000d88ca:  0004      lsls    r0, r0, #0x10
0x000d88cc:  8024      movs    r4, #0x80
0x000d88ce:  050c      lsrs    r5, r0, #0x10
0x000d88d0:  2402      lsls    r4, r4, #8
0x000d88d2:  0f22      movs    r2, #0xf
0x000d88d4:  04e0      b       #0xd88e0
0x000d88d6:  3020      movs    r0, #0x30
0x000d88d8:  1870      strb    r0, [r3]
0x000d88da:  6408      lsrs    r4, r4, #1
0x000d88dc:  013a      subs    r2, #1
0x000d88de:  08d4      bmi     #0xd88f2
0x000d88e0:  0b1c      adds    r3, r1, #0
0x000d88e2:  0131      adds    r1, #1
0x000d88e4:  2c42      tst     r4, r5
0x000d88e6:  f6d0      beq     #0xd88d6
0x000d88e8:  3120      movs    r0, #0x31
0x000d88ea:  1870      strb    r0, [r3]
0x000d88ec:  6408      lsrs    r4, r4, #1
0x000d88ee:  013a      subs    r2, #1
0x000d88f0:  f6d5      bpl     #0xd88e0
0x000d88f2:  081c      adds    r0, r1, #0
0x000d88f4:  30bc      pop     {r4, r5}
0x000d88f6:  02bc      pop     {r1}
0x000d88f8:  0847      bx      r1
0x000d88fa:  0000      movs    r0, r0
0x000d88fc:  30b5      push    {r4, r5, lr}
0x000d88fe:  8024      movs    r4, #0x80
0x000d8900:  051c      adds    r5, r0, #0
0x000d8902:  2406      lsls    r4, r4, #0x18
0x000d8904:  081c      adds    r0, r1, #0
0x000d8906:  1f22      movs    r2, #0x1f
0x000d8908:  04e0      b       #0xd8914
0x000d890a:  3021      movs    r1, #0x30
0x000d890c:  1970      strb    r1, [r3]
0x000d890e:  6408      lsrs    r4, r4, #1
0x000d8910:  013a      subs    r2, #1
0x000d8912:  08d4      bmi     #0xd8926
0x000d8914:  031c      adds    r3, r0, #0
0x000d8916:  0130      adds    r0, #1
0x000d8918:  2c42      tst     r4, r5
0x000d891a:  f6d0      beq     #0xd890a
0x000d891c:  3121      movs    r1, #0x31
0x000d891e:  1970      strb    r1, [r3]
0x000d8920:  6408      lsrs    r4, r4, #1
0x000d8922:  013a      subs    r2, #1
0x000d8924:  f6d5      bpl     #0xd8914
0x000d8926:  30bc      pop     {r4, r5}
0x000d8928:  02bc      pop     {r1}
0x000d892a:  0847      bx      r1
0x000d892c:  70b5      push    {r4, r5, r6, lr}
0x000d892e:  041c      adds    r4, r0, #0
0x000d8930:  0e1c      adds    r6, r1, #0
0x000d8932:  0025      movs    r5, #0
0x000d8934:  05e0      b       #0xd8942
0x000d8936:  2b05      lsls    r3, r5, #0x14
0x000d8938:  1d0c      lsrs    r5, r3, #0x10
0x000d893a:  4319      adds    r3, r0, r5
0x000d893c:  1b04      lsls    r3, r3, #0x10
0x000d893e:  1d0c      lsrs    r5, r3, #0x10
0x000d8940:  0134      adds    r4, #1
0x000d8942:  2078      ldrb    r0, [r4]
0x000d8944:  fff7cafd  bl      #0xd84dc  ; sub_000d84dc
0x000d8948:  0028      cmp     r0, #0
0x000d894a:  f4da      bge     #0xd8936
0x000d894c:  201c      adds    r0, r4, #0
0x000d894e:  3580      strh    r5, [r6]
0x000d8950:  70bc      pop     {r4, r5, r6}
0x000d8952:  02bc      pop     {r1}
0x000d8954:  0847      bx      r1
0x000d8956:  0000      movs    r0, r0
0x000d8958:  70b5      push    {r4, r5, r6, lr}
0x000d895a:  041c      adds    r4, r0, #0
0x000d895c:  0e1c      adds    r6, r1, #0
0x000d895e:  0025      movs    r5, #0
0x000d8960:  02e0      b       #0xd8968
0x000d8962:  2d01      lsls    r5, r5, #4
0x000d8964:  2d18      adds    r5, r5, r0
0x000d8966:  0134      adds    r4, #1
0x000d8968:  2078      ldrb    r0, [r4]
0x000d896a:  fff7b7fd  bl      #0xd84dc  ; sub_000d84dc
0x000d896e:  0028      cmp     r0, #0
0x000d8970:  f7da      bge     #0xd8962
0x000d8972:  201c      adds    r0, r4, #0
0x000d8974:  3560      str     r5, [r6]
0x000d8976:  70bc      pop     {r4, r5, r6}
0x000d8978:  02bc      pop     {r1}
0x000d897a:  0847      bx      r1
0x000d897c:  30b5      push    {r4, r5, lr}
0x000d897e:  0d1c      adds    r5, r1, #0
0x000d8980:  0a24      movs    r4, #0xa
0x000d8982:  0021      movs    r1, #0
0x000d8984:  04e0      b       #0xd8990
0x000d8986:  6143      muls    r1, r4, r1
0x000d8988:  5318      adds    r3, r2, r1
0x000d898a:  191c      adds    r1, r3, #0
0x000d898c:  3039      subs    r1, #0x30
0x000d898e:  0130      adds    r0, #1
0x000d8990:  0278      ldrb    r2, [r0]
0x000d8992:  131c      adds    r3, r2, #0
0x000d8994:  303b      subs    r3, #0x30
0x000d8996:  092b      cmp     r3, #9
0x000d8998:  f5d9      bls     #0xd8986
0x000d899a:  2960      str     r1, [r5]
0x000d899c:  30bc      pop     {r4, r5}
0x000d899e:  02bc      pop     {r1}
0x000d89a0:  0847      bx      r1
0x000d89a2:  0000      movs    r0, r0
0x000d89a4:  10b5      push    {r4, lr}
0x000d89a6:  83b0      sub     sp, #0xc
0x000d89a8:  6946      mov     r1, sp
0x000d89aa:  fff787fe  bl      #0xd86bc  ; sub_000d86bc
0x000d89ae:  0023      movs    r3, #0
0x000d89b0:  0370      strb    r3, [r0]
0x000d89b2:  6846      mov     r0, sp
0x000d89b4:  fff742fd  bl      #0xd843c  ; sub_000d843c
0x000d89b8:  0820      movs    r0, #8
0x000d89ba:  03b0      add     sp, #0xc
0x000d89bc:  10bc      pop     {r4}
0x000d89be:  02bc      pop     {r1}
0x000d89c0:  0847      bx      r1
0x000d89c2:  0000      movs    r0, r0

===== sub_000d8814 @ 0x000d8814 =====
0x000d8814:  00b5      push    {lr}
0x000d8816:  0378      ldrb    r3, [r0]
0x000d8818:  202b      cmp     r3, #0x20
0x000d881a:  01d0      beq     #0xd8820
0x000d881c:  092b      cmp     r3, #9
0x000d881e:  01d1      bne     #0xd8824
0x000d8820:  0130      adds    r0, #1
0x000d8822:  f8e7      b       #0xd8816
0x000d8824:  02bc      pop     {r1}
0x000d8826:  0847      bx      r1
0x000d8828:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d882a:  4746      mov     r7, r8
0x000d882c:  80b4      push    {r7}
0x000d882e:  81b0      sub     sp, #4
0x000d8830:  6f46      mov     r7, sp
0x000d8832:  0237      adds    r7, #2
0x000d8834:  0023      movs    r3, #0
0x000d8836:  8046      mov     r8, r0
0x000d8838:  0d1c      adds    r5, r1, #0
0x000d883a:  3b80      strh    r3, [r7]
0x000d883c:  041c      adds    r4, r0, #0
0x000d883e:  0026      movs    r6, #0
0x000d8840:  2078      ldrb    r0, [r4]
0x000d8842:  fff7c1ff  bl      #0xd87c8  ; sub_000d87c8
0x000d8846:  0028      cmp     r0, #0
0x000d8848:  18d1      bne     #0xd887c
0x000d884a:  8023      movs    r3, #0x80
0x000d884c:  5b00      lsls    r3, r3, #1
0x000d884e:  3b80      strh    r3, [r7]
0x000d8850:  3a88      ldrh    r2, [r7]
0x000d8852:  ff2a      cmp     r2, #0xff
0x000d8854:  1ad8      bhi     #0xd888c
0x000d8856:  2378      ldrb    r3, [r4]
0x000d8858:  2e2b      cmp     r3, #0x2e
0x000d885a:  1bd0      beq     #0xd8894
0x000d885c:  2b68      ldr     r3, [r5]
0x000d885e:  0136      adds    r6, #1
0x000d8860:  1b02      lsls    r3, r3, #8
0x000d8862:  9b18      adds    r3, r3, r2
0x000d8864:  2b60      str     r3, [r5]
0x000d8866:  032e      cmp     r6, #3
0x000d8868:  eadd      ble     #0xd8840
0x000d886a:  201c      adds    r0, r4, #0
0x000d886c:  fff7d2ff  bl      #0xd8814  ; sub_000d8814
0x000d8870:  01b0      add     sp, #4
0x000d8872:  08bc      pop     {r3}
0x000d8874:  9846      mov     r8, r3
0x000d8876:  f0bc      pop     {r4, r5, r6, r7}
0x000d8878:  02bc      pop     {r1}
0x000d887a:  0847      bx      r1
0x000d887c:  201c      adds    r0, r4, #0
0x000d887e:  391c      adds    r1, r7, #0
0x000d8880:  fff7b0ff  bl      #0xd87e4  ; sub_000d87e4
0x000d8884:  3a88      ldrh    r2, [r7]
0x000d8886:  041c      adds    r4, r0, #0
0x000d8888:  ff2a      cmp     r2, #0xff
0x000d888a:  e4d9      bls     #0xd8856
0x000d888c:  0023      movs    r3, #0
0x000d888e:  4046      mov     r0, r8
0x000d8890:  2b60      str     r3, [r5]
0x000d8892:  ede7      b       #0xd8870
0x000d8894:  0134      adds    r4, #1
0x000d8896:  e1e7      b       #0xd885c
0x000d8898:  30b5      push    {r4, r5, lr}
0x000d889a:  0006      lsls    r0, r0, #0x18
0x000d889c:  050e      lsrs    r5, r0, #0x18
0x000d889e:  0722      movs    r2, #7
0x000d88a0:  8020      movs    r0, #0x80
0x000d88a2:  04e0      b       #0xd88ae
0x000d88a4:  3024      movs    r4, #0x30
0x000d88a6:  1c70      strb    r4, [r3]
0x000d88a8:  4008      lsrs    r0, r0, #1
0x000d88aa:  013a      subs    r2, #1
0x000d88ac:  08d4      bmi     #0xd88c0
0x000d88ae:  0b1c      adds    r3, r1, #0
0x000d88b0:  0131      adds    r1, #1
0x000d88b2:  2842      tst     r0, r5
0x000d88b4:  f6d0      beq     #0xd88a4
0x000d88b6:  3124      movs    r4, #0x31
0x000d88b8:  1c70      strb    r4, [r3]
0x000d88ba:  4008      lsrs    r0, r0, #1
0x000d88bc:  013a      subs    r2, #1
0x000d88be:  f6d5      bpl     #0xd88ae
0x000d88c0:  081c      adds    r0, r1, #0
0x000d88c2:  30bc      pop     {r4, r5}
0x000d88c4:  02bc      pop     {r1}
0x000d88c6:  0847      bx      r1
0x000d88c8:  30b5      push    {r4, r5, lr}
0x000d88ca:  0004      lsls    r0, r0, #0x10
0x000d88cc:  8024      movs    r4, #0x80
0x000d88ce:  050c      lsrs    r5, r0, #0x10
0x000d88d0:  2402      lsls    r4, r4, #8
0x000d88d2:  0f22      movs    r2, #0xf
0x000d88d4:  04e0      b       #0xd88e0
0x000d88d6:  3020      movs    r0, #0x30
0x000d88d8:  1870      strb    r0, [r3]
0x000d88da:  6408      lsrs    r4, r4, #1
0x000d88dc:  013a      subs    r2, #1
0x000d88de:  08d4      bmi     #0xd88f2
0x000d88e0:  0b1c      adds    r3, r1, #0
0x000d88e2:  0131      adds    r1, #1
0x000d88e4:  2c42      tst     r4, r5
0x000d88e6:  f6d0      beq     #0xd88d6
0x000d88e8:  3120      movs    r0, #0x31
0x000d88ea:  1870      strb    r0, [r3]
0x000d88ec:  6408      lsrs    r4, r4, #1
0x000d88ee:  013a      subs    r2, #1
0x000d88f0:  f6d5      bpl     #0xd88e0
0x000d88f2:  081c      adds    r0, r1, #0
0x000d88f4:  30bc      pop     {r4, r5}
0x000d88f6:  02bc      pop     {r1}
0x000d88f8:  0847      bx      r1
0x000d88fa:  0000      movs    r0, r0
0x000d88fc:  30b5      push    {r4, r5, lr}
0x000d88fe:  8024      movs    r4, #0x80
0x000d8900:  051c      adds    r5, r0, #0
0x000d8902:  2406      lsls    r4, r4, #0x18
0x000d8904:  081c      adds    r0, r1, #0
0x000d8906:  1f22      movs    r2, #0x1f
0x000d8908:  04e0      b       #0xd8914
0x000d890a:  3021      movs    r1, #0x30
0x000d890c:  1970      strb    r1, [r3]
0x000d890e:  6408      lsrs    r4, r4, #1
0x000d8910:  013a      subs    r2, #1
0x000d8912:  08d4      bmi     #0xd8926
0x000d8914:  031c      adds    r3, r0, #0
0x000d8916:  0130      adds    r0, #1
0x000d8918:  2c42      tst     r4, r5
0x000d891a:  f6d0      beq     #0xd890a
0x000d891c:  3121      movs    r1, #0x31
0x000d891e:  1970      strb    r1, [r3]
0x000d8920:  6408      lsrs    r4, r4, #1
0x000d8922:  013a      subs    r2, #1
0x000d8924:  f6d5      bpl     #0xd8914
0x000d8926:  30bc      pop     {r4, r5}
0x000d8928:  02bc      pop     {r1}
0x000d892a:  0847      bx      r1
0x000d892c:  70b5      push    {r4, r5, r6, lr}
0x000d892e:  041c      adds    r4, r0, #0
0x000d8930:  0e1c      adds    r6, r1, #0
0x000d8932:  0025      movs    r5, #0
0x000d8934:  05e0      b       #0xd8942
0x000d8936:  2b05      lsls    r3, r5, #0x14
0x000d8938:  1d0c      lsrs    r5, r3, #0x10
0x000d893a:  4319      adds    r3, r0, r5
0x000d893c:  1b04      lsls    r3, r3, #0x10
0x000d893e:  1d0c      lsrs    r5, r3, #0x10
0x000d8940:  0134      adds    r4, #1
0x000d8942:  2078      ldrb    r0, [r4]
0x000d8944:  fff7cafd  bl      #0xd84dc  ; sub_000d84dc
0x000d8948:  0028      cmp     r0, #0
0x000d894a:  f4da      bge     #0xd8936
0x000d894c:  201c      adds    r0, r4, #0
0x000d894e:  3580      strh    r5, [r6]
0x000d8950:  70bc      pop     {r4, r5, r6}
0x000d8952:  02bc      pop     {r1}
0x000d8954:  0847      bx      r1
0x000d8956:  0000      movs    r0, r0
0x000d8958:  70b5      push    {r4, r5, r6, lr}
0x000d895a:  041c      adds    r4, r0, #0
0x000d895c:  0e1c      adds    r6, r1, #0
0x000d895e:  0025      movs    r5, #0
0x000d8960:  02e0      b       #0xd8968
0x000d8962:  2d01      lsls    r5, r5, #4
0x000d8964:  2d18      adds    r5, r5, r0
0x000d8966:  0134      adds    r4, #1
0x000d8968:  2078      ldrb    r0, [r4]
0x000d896a:  fff7b7fd  bl      #0xd84dc  ; sub_000d84dc
0x000d896e:  0028      cmp     r0, #0
0x000d8970:  f7da      bge     #0xd8962
0x000d8972:  201c      adds    r0, r4, #0
0x000d8974:  3560      str     r5, [r6]
0x000d8976:  70bc      pop     {r4, r5, r6}
0x000d8978:  02bc      pop     {r1}
0x000d897a:  0847      bx      r1
0x000d897c:  30b5      push    {r4, r5, lr}
0x000d897e:  0d1c      adds    r5, r1, #0
0x000d8980:  0a24      movs    r4, #0xa
0x000d8982:  0021      movs    r1, #0
0x000d8984:  04e0      b       #0xd8990
0x000d8986:  6143      muls    r1, r4, r1
0x000d8988:  5318      adds    r3, r2, r1
0x000d898a:  191c      adds    r1, r3, #0
0x000d898c:  3039      subs    r1, #0x30
0x000d898e:  0130      adds    r0, #1
0x000d8990:  0278      ldrb    r2, [r0]
0x000d8992:  131c      adds    r3, r2, #0
0x000d8994:  303b      subs    r3, #0x30
0x000d8996:  092b      cmp     r3, #9
0x000d8998:  f5d9      bls     #0xd8986
0x000d899a:  2960      str     r1, [r5]
0x000d899c:  30bc      pop     {r4, r5}
0x000d899e:  02bc      pop     {r1}
0x000d89a0:  0847      bx      r1
0x000d89a2:  0000      movs    r0, r0
0x000d89a4:  10b5      push    {r4, lr}
0x000d89a6:  83b0      sub     sp, #0xc
0x000d89a8:  6946      mov     r1, sp
0x000d89aa:  fff787fe  bl      #0xd86bc  ; sub_000d86bc
0x000d89ae:  0023      movs    r3, #0
0x000d89b0:  0370      strb    r3, [r0]
0x000d89b2:  6846      mov     r0, sp
0x000d89b4:  fff742fd  bl      #0xd843c  ; sub_000d843c
0x000d89b8:  0820      movs    r0, #8
0x000d89ba:  03b0      add     sp, #0xc
0x000d89bc:  10bc      pop     {r4}
0x000d89be:  02bc      pop     {r1}
0x000d89c0:  0847      bx      r1
0x000d89c2:  0000      movs    r0, r0
0x000d89c4:  10b5      push    {r4, lr}
0x000d89c6:  81b0      sub     sp, #4
0x000d89c8:  0006      lsls    r0, r0, #0x18
0x000d89ca:  6946      mov     r1, sp
0x000d89cc:  000e      lsrs    r0, r0, #0x18
0x000d89ce:  fff783fe  bl      #0xd86d8  ; sub_000d86d8
0x000d89d2:  0023      movs    r3, #0
0x000d89d4:  0370      strb    r3, [r0]
0x000d89d6:  6846      mov     r0, sp
0x000d89d8:  fff730fd  bl      #0xd843c  ; sub_000d843c
0x000d89dc:  6846      mov     r0, sp
0x000d89de:  fff721fd  bl      #0xd8424  ; sub_000d8424
0x000d89e2:  01b0      add     sp, #4
0x000d89e4:  10bc      pop     {r4}
0x000d89e6:  02bc      pop     {r1}
0x000d89e8:  0847      bx      r1
0x000d89ea:  0000      movs    r0, r0
0x000d89ec:  10b5      push    {r4, lr}
0x000d89ee:  82b0      sub     sp, #8
0x000d89f0:  0004      lsls    r0, r0, #0x10
0x000d89f2:  6946      mov     r1, sp

===== sub_000d89a4 @ 0x000d89a4 =====
0x000d89a4:  10b5      push    {r4, lr}
0x000d89a6:  83b0      sub     sp, #0xc
0x000d89a8:  6946      mov     r1, sp
0x000d89aa:  fff787fe  bl      #0xd86bc  ; sub_000d86bc
0x000d89ae:  0023      movs    r3, #0
0x000d89b0:  0370      strb    r3, [r0]
0x000d89b2:  6846      mov     r0, sp
0x000d89b4:  fff742fd  bl      #0xd843c  ; sub_000d843c
0x000d89b8:  0820      movs    r0, #8
0x000d89ba:  03b0      add     sp, #0xc
0x000d89bc:  10bc      pop     {r4}
0x000d89be:  02bc      pop     {r1}
0x000d89c0:  0847      bx      r1
0x000d89c2:  0000      movs    r0, r0
0x000d89c4:  10b5      push    {r4, lr}
0x000d89c6:  81b0      sub     sp, #4
0x000d89c8:  0006      lsls    r0, r0, #0x18
0x000d89ca:  6946      mov     r1, sp
0x000d89cc:  000e      lsrs    r0, r0, #0x18
0x000d89ce:  fff783fe  bl      #0xd86d8  ; sub_000d86d8
0x000d89d2:  0023      movs    r3, #0
0x000d89d4:  0370      strb    r3, [r0]
0x000d89d6:  6846      mov     r0, sp
0x000d89d8:  fff730fd  bl      #0xd843c  ; sub_000d843c
0x000d89dc:  6846      mov     r0, sp
0x000d89de:  fff721fd  bl      #0xd8424  ; sub_000d8424
0x000d89e2:  01b0      add     sp, #4
0x000d89e4:  10bc      pop     {r4}
0x000d89e6:  02bc      pop     {r1}
0x000d89e8:  0847      bx      r1
0x000d89ea:  0000      movs    r0, r0
0x000d89ec:  10b5      push    {r4, lr}
0x000d89ee:  82b0      sub     sp, #8
0x000d89f0:  0004      lsls    r0, r0, #0x10
0x000d89f2:  6946      mov     r1, sp
0x000d89f4:  000c      lsrs    r0, r0, #0x10
0x000d89f6:  fff76ffe  bl      #0xd86d8  ; sub_000d86d8
0x000d89fa:  0023      movs    r3, #0
0x000d89fc:  0370      strb    r3, [r0]
0x000d89fe:  6846      mov     r0, sp
0x000d8a00:  fff71cfd  bl      #0xd843c  ; sub_000d843c
0x000d8a04:  6846      mov     r0, sp
0x000d8a06:  fff70dfd  bl      #0xd8424  ; sub_000d8424
0x000d8a0a:  02b0      add     sp, #8
0x000d8a0c:  10bc      pop     {r4}
0x000d8a0e:  02bc      pop     {r1}
0x000d8a10:  0847      bx      r1
0x000d8a12:  0000      movs    r0, r0
0x000d8a14:  10b5      push    {r4, lr}
0x000d8a16:  83b0      sub     sp, #0xc
0x000d8a18:  6946      mov     r1, sp
0x000d8a1a:  fff78bfe  bl      #0xd8734  ; sub_000d8734
0x000d8a1e:  0023      movs    r3, #0
0x000d8a20:  0370      strb    r3, [r0]
0x000d8a22:  6846      mov     r0, sp
0x000d8a24:  fff70afd  bl      #0xd843c  ; sub_000d843c
0x000d8a28:  6846      mov     r0, sp
0x000d8a2a:  fff7fbfc  bl      #0xd8424  ; sub_000d8424
0x000d8a2e:  03b0      add     sp, #0xc
0x000d8a30:  10bc      pop     {r4}
0x000d8a32:  02bc      pop     {r1}
0x000d8a34:  0847      bx      r1
0x000d8a36:  0000      movs    r0, r0
0x000d8a38:  10b5      push    {r4, lr}
0x000d8a3a:  0b1c      adds    r3, r1, #0
0x000d8a3c:  041c      adds    r4, r0, #0
0x000d8a3e:  0021      movs    r1, #0
0x000d8a40:  002a      cmp     r2, #0
0x000d8a42:  05d0      beq     #0xd8a50
0x000d8a44:  082b      cmp     r3, #8
0x000d8a46:  15d0      beq     #0xd8a74
0x000d8a48:  102b      cmp     r3, #0x10
0x000d8a4a:  18d0      beq     #0xd8a7e
0x000d8a4c:  6442      rsbs    r4, r4, #0
0x000d8a4e:  0121      movs    r1, #1
0x000d8a50:  0c4a      ldr     r2, [pc, #0x30]
0x000d8a52:  0020      movs    r0, #0
0x000d8a54:  08ca      ldm     r2!, {r3}
0x000d8a56:  a342      cmp     r3, r4
0x000d8a58:  02d9      bls     #0xd8a60
0x000d8a5a:  0130      adds    r0, #1
0x000d8a5c:  0928      cmp     r0, #9
0x000d8a5e:  f9dd      ble     #0xd8a54
0x000d8a60:  0b1a      subs    r3, r1, r0
0x000d8a62:  191c      adds    r1, r3, #0
0x000d8a64:  0a31      adds    r1, #0xa
0x000d8a66:  0029      cmp     r1, #0
0x000d8a68:  00d1      bne     #0xd8a6c
0x000d8a6a:  0121      movs    r1, #1
0x000d8a6c:  081c      adds    r0, r1, #0
0x000d8a6e:  10bc      pop     {r4}
0x000d8a70:  02bc      pop     {r1}
0x000d8a72:  0847      bx      r1
0x000d8a74:  044b      ldr     r3, [pc, #0x10]
0x000d8a76:  1c43      orrs    r4, r3
0x000d8a78:  6442      rsbs    r4, r4, #0
0x000d8a7a:  0121      movs    r1, #1
0x000d8a7c:  e8e7      b       #0xd8a50
0x000d8a7e:  034b      ldr     r3, [pc, #0xc]
0x000d8a80:  1c43      orrs    r4, r3
0x000d8a82:  f9e7      b       #0xd8a78
0x000d8a84:  980b      lsrs    r0, r3, #0xe
0x000d8a86:  1000      movs    r0, r2

===== sub_000d89ec @ 0x000d89ec =====
0x000d89ec:  10b5      push    {r4, lr}
0x000d89ee:  82b0      sub     sp, #8
0x000d89f0:  0004      lsls    r0, r0, #0x10
0x000d89f2:  6946      mov     r1, sp
0x000d89f4:  000c      lsrs    r0, r0, #0x10
0x000d89f6:  fff76ffe  bl      #0xd86d8  ; sub_000d86d8
0x000d89fa:  0023      movs    r3, #0
0x000d89fc:  0370      strb    r3, [r0]
0x000d89fe:  6846      mov     r0, sp
0x000d8a00:  fff71cfd  bl      #0xd843c  ; sub_000d843c
0x000d8a04:  6846      mov     r0, sp
0x000d8a06:  fff70dfd  bl      #0xd8424  ; sub_000d8424
0x000d8a0a:  02b0      add     sp, #8
0x000d8a0c:  10bc      pop     {r4}
0x000d8a0e:  02bc      pop     {r1}
0x000d8a10:  0847      bx      r1
0x000d8a12:  0000      movs    r0, r0
0x000d8a14:  10b5      push    {r4, lr}
0x000d8a16:  83b0      sub     sp, #0xc
0x000d8a18:  6946      mov     r1, sp
0x000d8a1a:  fff78bfe  bl      #0xd8734  ; sub_000d8734
0x000d8a1e:  0023      movs    r3, #0
0x000d8a20:  0370      strb    r3, [r0]
0x000d8a22:  6846      mov     r0, sp
0x000d8a24:  fff70afd  bl      #0xd843c  ; sub_000d843c
0x000d8a28:  6846      mov     r0, sp
0x000d8a2a:  fff7fbfc  bl      #0xd8424  ; sub_000d8424
0x000d8a2e:  03b0      add     sp, #0xc
0x000d8a30:  10bc      pop     {r4}
0x000d8a32:  02bc      pop     {r1}
0x000d8a34:  0847      bx      r1
0x000d8a36:  0000      movs    r0, r0
0x000d8a38:  10b5      push    {r4, lr}
0x000d8a3a:  0b1c      adds    r3, r1, #0
0x000d8a3c:  041c      adds    r4, r0, #0
0x000d8a3e:  0021      movs    r1, #0
0x000d8a40:  002a      cmp     r2, #0
0x000d8a42:  05d0      beq     #0xd8a50
0x000d8a44:  082b      cmp     r3, #8
0x000d8a46:  15d0      beq     #0xd8a74
0x000d8a48:  102b      cmp     r3, #0x10
0x000d8a4a:  18d0      beq     #0xd8a7e
0x000d8a4c:  6442      rsbs    r4, r4, #0
0x000d8a4e:  0121      movs    r1, #1
0x000d8a50:  0c4a      ldr     r2, [pc, #0x30]
0x000d8a52:  0020      movs    r0, #0
0x000d8a54:  08ca      ldm     r2!, {r3}
0x000d8a56:  a342      cmp     r3, r4
0x000d8a58:  02d9      bls     #0xd8a60
0x000d8a5a:  0130      adds    r0, #1
0x000d8a5c:  0928      cmp     r0, #9
0x000d8a5e:  f9dd      ble     #0xd8a54
0x000d8a60:  0b1a      subs    r3, r1, r0
0x000d8a62:  191c      adds    r1, r3, #0
0x000d8a64:  0a31      adds    r1, #0xa
0x000d8a66:  0029      cmp     r1, #0
0x000d8a68:  00d1      bne     #0xd8a6c
0x000d8a6a:  0121      movs    r1, #1
0x000d8a6c:  081c      adds    r0, r1, #0
0x000d8a6e:  10bc      pop     {r4}
0x000d8a70:  02bc      pop     {r1}
0x000d8a72:  0847      bx      r1
0x000d8a74:  044b      ldr     r3, [pc, #0x10]
0x000d8a76:  1c43      orrs    r4, r3
0x000d8a78:  6442      rsbs    r4, r4, #0
0x000d8a7a:  0121      movs    r1, #1
0x000d8a7c:  e8e7      b       #0xd8a50
0x000d8a7e:  034b      ldr     r3, [pc, #0xc]
0x000d8a80:  1c43      orrs    r4, r3
0x000d8a82:  f9e7      b       #0xd8a78
0x000d8a84:  980b      lsrs    r0, r3, #0xe
0x000d8a86:  1000      movs    r0, r2

===== sub_000d8f04 @ 0x000d8f04 =====
0x000d8f04:  0fb4      push    {r0, r1, r2, r3}
0x000d8f06:  30b5      push    {r4, r5, lr}
0x000d8f08:  94b0      sub     sp, #0x50
0x000d8f0a:  17ab      add     r3, sp, #0x5c
0x000d8f0c:  04cb      ldm     r3!, {r2}
0x000d8f0e:  0424      movs    r4, #4
0x000d8f10:  1178      ldrb    r1, [r2]
0x000d8f12:  2329      cmp     r1, #0x23
0x000d8f14:  26d0      beq     #0xd8f64
0x000d8f16:  2329      cmp     r1, #0x23
0x000d8f18:  10dd      ble     #0xd8f3c
0x000d8f1a:  3f29      cmp     r1, #0x3f
0x000d8f1c:  25d0      beq     #0xd8f6a
0x000d8f1e:  6846      mov     r0, sp
0x000d8f20:  5021      movs    r1, #0x50
0x000d8f22:  fff7b5fd  bl      #0xd8a90  ; sub_000d8a90
0x000d8f26:  0023      movs    r3, #0
0x000d8f28:  0370      strb    r3, [r0]
0x000d8f2a:  114b      ldr     r3, [pc, #0x44]
0x000d8f2c:  1b88      ldrh    r3, [r3]
0x000d8f2e:  a342      cmp     r3, r4
0x000d8f30:  12da      bge     #0xd8f58
0x000d8f32:  14b0      add     sp, #0x50
0x000d8f34:  30bc      pop     {r4, r5}
0x000d8f36:  08bc      pop     {r3}
0x000d8f38:  04b0      add     sp, #0x10
0x000d8f3a:  1847      bx      r3
0x000d8f3c:  2129      cmp     r1, #0x21
0x000d8f3e:  eed1      bne     #0xd8f1e
0x000d8f40:  0224      movs    r4, #2
0x000d8f42:  0132      adds    r2, #1
0x000d8f44:  6846      mov     r0, sp
0x000d8f46:  5021      movs    r1, #0x50
0x000d8f48:  fff7a2fd  bl      #0xd8a90  ; sub_000d8a90
0x000d8f4c:  0023      movs    r3, #0
0x000d8f4e:  0370      strb    r3, [r0]
0x000d8f50:  074b      ldr     r3, [pc, #0x1c]
0x000d8f52:  1b88      ldrh    r3, [r3]
0x000d8f54:  a342      cmp     r3, r4
0x000d8f56:  ecdb      blt     #0xd8f32
0x000d8f58:  6846      mov     r0, sp
0x000d8f5a:  fff76ffa  bl      #0xd843c  ; sub_000d843c
0x000d8f5e:  fff757fa  bl      #0xd8410  ; sub_000d8410
0x000d8f62:  e6e7      b       #0xd8f32
0x000d8f64:  0124      movs    r4, #1
0x000d8f66:  0132      adds    r2, #1
0x000d8f68:  ece7      b       #0xd8f44
0x000d8f6a:  0324      movs    r4, #3
0x000d8f6c:  0132      adds    r2, #1
0x000d8f6e:  e9e7      b       #0xd8f44
0x000d8f70:  960b      lsrs    r6, r2, #0xe
0x000d8f72:  1000      movs    r0, r2
0x000d8f74:  00b5      push    {lr}
0x000d8f76:  0378      ldrb    r3, [r0]
0x000d8f78:  202b      cmp     r3, #0x20
0x000d8f7a:  07d0      beq     #0xd8f8c
0x000d8f7c:  092b      cmp     r3, #9
0x000d8f7e:  05d0      beq     #0xd8f8c
0x000d8f80:  002b      cmp     r3, #0
0x000d8f82:  03d0      beq     #0xd8f8c
0x000d8f84:  0130      adds    r0, #1
0x000d8f86:  0378      ldrb    r3, [r0]
0x000d8f88:  202b      cmp     r3, #0x20
0x000d8f8a:  f7d1      bne     #0xd8f7c
0x000d8f8c:  02bc      pop     {r1}
0x000d8f8e:  0847      bx      r1
0x000d8f90:  00b5      push    {lr}
0x000d8f92:  9f22      movs    r2, #0x9f
0x000d8f94:  0006      lsls    r0, r0, #0x18
0x000d8f96:  1206      lsls    r2, r2, #0x18
0x000d8f98:  030e      lsrs    r3, r0, #0x18
0x000d8f9a:  8018      adds    r0, r0, r2
0x000d8f9c:  000e      lsrs    r0, r0, #0x18
0x000d8f9e:  1928      cmp     r0, #0x19
0x000d8fa0:  02d8      bhi     #0xd8fa8
0x000d8fa2:  203b      subs    r3, #0x20
0x000d8fa4:  1b06      lsls    r3, r3, #0x18
0x000d8fa6:  1b0e      lsrs    r3, r3, #0x18
0x000d8fa8:  181c      adds    r0, r3, #0
0x000d8faa:  02bc      pop     {r1}
0x000d8fac:  0847      bx      r1
0x000d8fae:  0000      movs    r0, r0
0x000d8fb0:  10b5      push    {r4, lr}
0x000d8fb2:  0378      ldrb    r3, [r0]
0x000d8fb4:  041c      adds    r4, r0, #0
0x000d8fb6:  1b06      lsls    r3, r3, #0x18
0x000d8fb8:  002b      cmp     r3, #0
0x000d8fba:  11d0      beq     #0xd8fe0
0x000d8fbc:  181c      adds    r0, r3, #0
0x000d8fbe:  000e      lsrs    r0, r0, #0x18
0x000d8fc0:  7f28      cmp     r0, #0x7f
0x000d8fc2:  10dd      ble     #0xd8fe6
0x000d8fc4:  031c      adds    r3, r0, #0
0x000d8fc6:  a03b      subs    r3, #0xa0
0x000d8fc8:  2070      strb    r0, [r4]
0x000d8fca:  0134      adds    r4, #1
0x000d8fcc:  3f2b      cmp     r3, #0x3f
0x000d8fce:  03d9      bls     #0xd8fd8
0x000d8fd0:  2078      ldrb    r0, [r4]
0x000d8fd2:  0028      cmp     r0, #0
0x000d8fd4:  01d0      beq     #0xd8fda
0x000d8fd6:  0134      adds    r4, #1
0x000d8fd8:  2078      ldrb    r0, [r4]
0x000d8fda:  0006      lsls    r0, r0, #0x18
0x000d8fdc:  0028      cmp     r0, #0
0x000d8fde:  eed1      bne     #0xd8fbe
0x000d8fe0:  10bc      pop     {r4}
0x000d8fe2:  01bc      pop     {r0}
0x000d8fe4:  0047      bx      r0
0x000d8fe6:  fff7d3ff  bl      #0xd8f90  ; sub_000d8f90
0x000d8fea:  2070      strb    r0, [r4]
0x000d8fec:  0134      adds    r4, #1
0x000d8fee:  f3e7      b       #0xd8fd8
0x000d8ff0:  00b5      push    {lr}
0x000d8ff2:  bf22      movs    r2, #0xbf
0x000d8ff4:  0006      lsls    r0, r0, #0x18
0x000d8ff6:  1206      lsls    r2, r2, #0x18
0x000d8ff8:  030e      lsrs    r3, r0, #0x18
0x000d8ffa:  8018      adds    r0, r0, r2
0x000d8ffc:  000e      lsrs    r0, r0, #0x18
0x000d8ffe:  1928      cmp     r0, #0x19
0x000d9000:  02d8      bhi     #0xd9008
0x000d9002:  2033      adds    r3, #0x20
0x000d9004:  1b06      lsls    r3, r3, #0x18
0x000d9006:  1b0e      lsrs    r3, r3, #0x18
0x000d9008:  181c      adds    r0, r3, #0
0x000d900a:  02bc      pop     {r1}
0x000d900c:  0847      bx      r1
0x000d900e:  0000      movs    r0, r0
0x000d9010:  10b5      push    {r4, lr}
0x000d9012:  0378      ldrb    r3, [r0]
0x000d9014:  041c      adds    r4, r0, #0
0x000d9016:  1b06      lsls    r3, r3, #0x18
0x000d9018:  002b      cmp     r3, #0
0x000d901a:  11d0      beq     #0xd9040
0x000d901c:  181c      adds    r0, r3, #0
0x000d901e:  000e      lsrs    r0, r0, #0x18
0x000d9020:  7f28      cmp     r0, #0x7f
0x000d9022:  10dd      ble     #0xd9046
0x000d9024:  031c      adds    r3, r0, #0
0x000d9026:  a03b      subs    r3, #0xa0
0x000d9028:  2070      strb    r0, [r4]
0x000d902a:  0134      adds    r4, #1
0x000d902c:  3f2b      cmp     r3, #0x3f
0x000d902e:  03d9      bls     #0xd9038
0x000d9030:  2078      ldrb    r0, [r4]
0x000d9032:  0028      cmp     r0, #0
0x000d9034:  01d0      beq     #0xd903a
0x000d9036:  0134      adds    r4, #1
0x000d9038:  2078      ldrb    r0, [r4]
0x000d903a:  0006      lsls    r0, r0, #0x18
0x000d903c:  0028      cmp     r0, #0
0x000d903e:  eed1      bne     #0xd901e
0x000d9040:  10bc      pop     {r4}
0x000d9042:  01bc      pop     {r0}
0x000d9044:  0047      bx      r0
0x000d9046:  fff7d3ff  bl      #0xd8ff0  ; sub_000d8ff0
0x000d904a:  2070      strb    r0, [r4]
0x000d904c:  0134      adds    r4, #1
0x000d904e:  f3e7      b       #0xd9038
0x000d9050:  00b5      push    {lr}
0x000d9052:  0b78      ldrb    r3, [r1]
0x000d9054:  0131      adds    r1, #1
0x000d9056:  0370      strb    r3, [r0]
0x000d9058:  0130      adds    r0, #1
0x000d905a:  002b      cmp     r3, #0
0x000d905c:  f9d1      bne     #0xd9052
0x000d905e:  0138      subs    r0, #1
0x000d9060:  02bc      pop     {r1}
0x000d9062:  0847      bx      r1
0x000d9064:  00b5      push    {lr}
0x000d9066:  131c      adds    r3, r2, #0
0x000d9068:  013a      subs    r2, #1
0x000d906a:  002b      cmp     r3, #0
0x000d906c:  08dd      ble     #0xd9080
0x000d906e:  0b78      ldrb    r3, [r1]
0x000d9070:  0131      adds    r1, #1
0x000d9072:  0370      strb    r3, [r0]
0x000d9074:  0130      adds    r0, #1
0x000d9076:  002b      cmp     r3, #0
0x000d9078:  f5d1      bne     #0xd9066
0x000d907a:  0138      subs    r0, #1
0x000d907c:  02bc      pop     {r1}
0x000d907e:  0847      bx      r1
0x000d9080:  0023      movs    r3, #0
0x000d9082:  0370      strb    r3, [r0]
0x000d9084:  0130      adds    r0, #1
0x000d9086:  f8e7      b       #0xd907a
0x000d9088:  30b5      push    {r4, r5, lr}
0x000d908a:  0d1c      adds    r5, r1, #0
0x000d908c:  041c      adds    r4, r0, #0
0x000d908e:  fff7c9f9  bl      #0xd8424  ; sub_000d8424
0x000d9092:  291c      adds    r1, r5, #0
0x000d9094:  2018      adds    r0, r4, r0
0x000d9096:  fff7dbff  bl      #0xd9050  ; sub_000d9050
0x000d909a:  30bc      pop     {r4, r5}
0x000d909c:  02bc      pop     {r1}
0x000d909e:  0847      bx      r1
0x000d90a0:  00b5      push    {lr}
0x000d90a2:  d023      movs    r3, #0xd0
0x000d90a4:  0006      lsls    r0, r0, #0x18
0x000d90a6:  1b06      lsls    r3, r3, #0x18
0x000d90a8:  020e      lsrs    r2, r0, #0x18
0x000d90aa:  c018      adds    r0, r0, r3
0x000d90ac:  000e      lsrs    r0, r0, #0x18
0x000d90ae:  0021      movs    r1, #0
0x000d90b0:  0928      cmp     r0, #9
0x000d90b2:  05d9      bls     #0xd90c0
0x000d90b4:  131c      adds    r3, r2, #0
0x000d90b6:  413b      subs    r3, #0x41
0x000d90b8:  1b06      lsls    r3, r3, #0x18
0x000d90ba:  1b0e      lsrs    r3, r3, #0x18
0x000d90bc:  052b      cmp     r3, #5
0x000d90be:  03d8      bhi     #0xd90c8
0x000d90c0:  0121      movs    r1, #1
0x000d90c2:  081c      adds    r0, r1, #0
0x000d90c4:  02bc      pop     {r1}
0x000d90c6:  0847      bx      r1
0x000d90c8:  131c      adds    r3, r2, #0
0x000d90ca:  613b      subs    r3, #0x61
0x000d90cc:  1b06      lsls    r3, r3, #0x18
0x000d90ce:  1b0e      lsrs    r3, r3, #0x18
0x000d90d0:  052b      cmp     r3, #5
0x000d90d2:  f6d8      bhi     #0xd90c2
0x000d90d4:  f4e7      b       #0xd90c0
0x000d90d6:  0000      movs    r0, r0
0x000d90d8:  0006      lsls    r0, r0, #0x18
0x000d90da:  000e      lsrs    r0, r0, #0x18
0x000d90dc:  3038      subs    r0, #0x30
0x000d90de:  7047      bx      lr

===== sub_000d9050 @ 0x000d9050 =====
0x000d9050:  00b5      push    {lr}
0x000d9052:  0b78      ldrb    r3, [r1]
0x000d9054:  0131      adds    r1, #1
0x000d9056:  0370      strb    r3, [r0]
0x000d9058:  0130      adds    r0, #1
0x000d905a:  002b      cmp     r3, #0
0x000d905c:  f9d1      bne     #0xd9052
0x000d905e:  0138      subs    r0, #1
0x000d9060:  02bc      pop     {r1}
0x000d9062:  0847      bx      r1
0x000d9064:  00b5      push    {lr}
0x000d9066:  131c      adds    r3, r2, #0
0x000d9068:  013a      subs    r2, #1
0x000d906a:  002b      cmp     r3, #0
0x000d906c:  08dd      ble     #0xd9080
0x000d906e:  0b78      ldrb    r3, [r1]
0x000d9070:  0131      adds    r1, #1
0x000d9072:  0370      strb    r3, [r0]
0x000d9074:  0130      adds    r0, #1
0x000d9076:  002b      cmp     r3, #0
0x000d9078:  f5d1      bne     #0xd9066
0x000d907a:  0138      subs    r0, #1
0x000d907c:  02bc      pop     {r1}
0x000d907e:  0847      bx      r1
0x000d9080:  0023      movs    r3, #0
0x000d9082:  0370      strb    r3, [r0]
0x000d9084:  0130      adds    r0, #1
0x000d9086:  f8e7      b       #0xd907a
0x000d9088:  30b5      push    {r4, r5, lr}
0x000d908a:  0d1c      adds    r5, r1, #0
0x000d908c:  041c      adds    r4, r0, #0
0x000d908e:  fff7c9f9  bl      #0xd8424  ; sub_000d8424
0x000d9092:  291c      adds    r1, r5, #0
0x000d9094:  2018      adds    r0, r4, r0
0x000d9096:  fff7dbff  bl      #0xd9050  ; sub_000d9050
0x000d909a:  30bc      pop     {r4, r5}
0x000d909c:  02bc      pop     {r1}
0x000d909e:  0847      bx      r1
0x000d90a0:  00b5      push    {lr}
0x000d90a2:  d023      movs    r3, #0xd0
0x000d90a4:  0006      lsls    r0, r0, #0x18
0x000d90a6:  1b06      lsls    r3, r3, #0x18
0x000d90a8:  020e      lsrs    r2, r0, #0x18
0x000d90aa:  c018      adds    r0, r0, r3
0x000d90ac:  000e      lsrs    r0, r0, #0x18
0x000d90ae:  0021      movs    r1, #0
0x000d90b0:  0928      cmp     r0, #9
0x000d90b2:  05d9      bls     #0xd90c0
0x000d90b4:  131c      adds    r3, r2, #0
0x000d90b6:  413b      subs    r3, #0x41
0x000d90b8:  1b06      lsls    r3, r3, #0x18
0x000d90ba:  1b0e      lsrs    r3, r3, #0x18
0x000d90bc:  052b      cmp     r3, #5
0x000d90be:  03d8      bhi     #0xd90c8
0x000d90c0:  0121      movs    r1, #1
0x000d90c2:  081c      adds    r0, r1, #0
0x000d90c4:  02bc      pop     {r1}
0x000d90c6:  0847      bx      r1
0x000d90c8:  131c      adds    r3, r2, #0
0x000d90ca:  613b      subs    r3, #0x61
0x000d90cc:  1b06      lsls    r3, r3, #0x18
0x000d90ce:  1b0e      lsrs    r3, r3, #0x18
0x000d90d0:  052b      cmp     r3, #5
0x000d90d2:  f6d8      bhi     #0xd90c2
0x000d90d4:  f4e7      b       #0xd90c0
0x000d90d6:  0000      movs    r0, r0
0x000d90d8:  0006      lsls    r0, r0, #0x18
0x000d90da:  000e      lsrs    r0, r0, #0x18
0x000d90dc:  3038      subs    r0, #0x30
0x000d90de:  7047      bx      lr

===== sub_000d90fc @ 0x000d90fc =====
0x000d90fc:  00b5      push    {lr}
0x000d90fe:  0278      ldrb    r2, [r0]
0x000d9100:  0b78      ldrb    r3, [r1]
0x000d9102:  0130      adds    r0, #1
0x000d9104:  0131      adds    r1, #1
0x000d9106:  002a      cmp     r2, #0
0x000d9108:  01d1      bne     #0xd910e
0x000d910a:  002b      cmp     r3, #0
0x000d910c:  06d0      beq     #0xd911c
0x000d910e:  9a42      cmp     r2, r3
0x000d9110:  f5d0      beq     #0xd90fe
0x000d9112:  9a42      cmp     r2, r3
0x000d9114:  04d9      bls     #0xd9120
0x000d9116:  0120      movs    r0, #1
0x000d9118:  02bc      pop     {r1}
0x000d911a:  0847      bx      r1
0x000d911c:  0020      movs    r0, #0
0x000d911e:  fbe7      b       #0xd9118
0x000d9120:  0120      movs    r0, #1
0x000d9122:  4042      rsbs    r0, r0, #0
0x000d9124:  f8e7      b       #0xd9118
0x000d9126:  0000      movs    r0, r0
0x000d9128:  70b5      push    {r4, r5, r6, lr}
0x000d912a:  061c      adds    r6, r0, #0
0x000d912c:  0d1c      adds    r5, r1, #0
0x000d912e:  3078      ldrb    r0, [r6]
0x000d9130:  fff72eff  bl      #0xd8f90  ; sub_000d8f90
0x000d9134:  0006      lsls    r0, r0, #0x18
0x000d9136:  040e      lsrs    r4, r0, #0x18
0x000d9138:  2878      ldrb    r0, [r5]
0x000d913a:  fff729ff  bl      #0xd8f90  ; sub_000d8f90
0x000d913e:  0006      lsls    r0, r0, #0x18
0x000d9140:  0136      adds    r6, #1
0x000d9142:  0135      adds    r5, #1
0x000d9144:  000e      lsrs    r0, r0, #0x18
0x000d9146:  002c      cmp     r4, #0
0x000d9148:  01d1      bne     #0xd914e
0x000d914a:  0028      cmp     r0, #0
0x000d914c:  07d0      beq     #0xd915e
0x000d914e:  8442      cmp     r4, r0
0x000d9150:  edd0      beq     #0xd912e
0x000d9152:  8442      cmp     r4, r0
0x000d9154:  05d9      bls     #0xd9162
0x000d9156:  0120      movs    r0, #1
0x000d9158:  70bc      pop     {r4, r5, r6}
0x000d915a:  02bc      pop     {r1}
0x000d915c:  0847      bx      r1
0x000d915e:  0020      movs    r0, #0
0x000d9160:  fae7      b       #0xd9158
0x000d9162:  0120      movs    r0, #1
0x000d9164:  4042      rsbs    r0, r0, #0
0x000d9166:  f7e7      b       #0xd9158
0x000d9168:  10b5      push    {r4, lr}
0x000d916a:  041c      adds    r4, r0, #0
0x000d916c:  081c      adds    r0, r1, #0
0x000d916e:  111c      adds    r1, r2, #0
0x000d9170:  0b1c      adds    r3, r1, #0
0x000d9172:  0139      subs    r1, #1
0x000d9174:  002b      cmp     r3, #0
0x000d9176:  0fdd      ble     #0xd9198
0x000d9178:  2278      ldrb    r2, [r4]
0x000d917a:  0378      ldrb    r3, [r0]
0x000d917c:  0134      adds    r4, #1
0x000d917e:  0130      adds    r0, #1
0x000d9180:  002a      cmp     r2, #0
0x000d9182:  01d1      bne     #0xd9188
0x000d9184:  002b      cmp     r3, #0
0x000d9186:  07d0      beq     #0xd9198
0x000d9188:  9a42      cmp     r2, r3
0x000d918a:  f1d0      beq     #0xd9170
0x000d918c:  9a42      cmp     r2, r3
0x000d918e:  05d9      bls     #0xd919c
0x000d9190:  0120      movs    r0, #1
0x000d9192:  10bc      pop     {r4}
0x000d9194:  02bc      pop     {r1}
0x000d9196:  0847      bx      r1
0x000d9198:  0020      movs    r0, #0
0x000d919a:  fae7      b       #0xd9192
0x000d919c:  0120      movs    r0, #1
0x000d919e:  4042      rsbs    r0, r0, #0
0x000d91a0:  f7e7      b       #0xd9192
0x000d91a2:  0000      movs    r0, r0
0x000d91a4:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d91a6:  071c      adds    r7, r0, #0
0x000d91a8:  0e1c      adds    r6, r1, #0
0x000d91aa:  151c      adds    r5, r2, #0
0x000d91ac:  2b1c      adds    r3, r5, #0
0x000d91ae:  013d      subs    r5, #1
0x000d91b0:  002b      cmp     r3, #0
0x000d91b2:  17dd      ble     #0xd91e4
0x000d91b4:  3878      ldrb    r0, [r7]
0x000d91b6:  fff7ebfe  bl      #0xd8f90  ; sub_000d8f90
0x000d91ba:  0006      lsls    r0, r0, #0x18
0x000d91bc:  040e      lsrs    r4, r0, #0x18
0x000d91be:  3078      ldrb    r0, [r6]
0x000d91c0:  fff7e6fe  bl      #0xd8f90  ; sub_000d8f90
0x000d91c4:  0006      lsls    r0, r0, #0x18
0x000d91c6:  0137      adds    r7, #1
0x000d91c8:  0136      adds    r6, #1
0x000d91ca:  000e      lsrs    r0, r0, #0x18
0x000d91cc:  002c      cmp     r4, #0
0x000d91ce:  01d1      bne     #0xd91d4
0x000d91d0:  0028      cmp     r0, #0
0x000d91d2:  07d0      beq     #0xd91e4
0x000d91d4:  8442      cmp     r4, r0
0x000d91d6:  e9d0      beq     #0xd91ac
0x000d91d8:  8442      cmp     r4, r0
0x000d91da:  05d9      bls     #0xd91e8
0x000d91dc:  0120      movs    r0, #1
0x000d91de:  f0bc      pop     {r4, r5, r6, r7}
0x000d91e0:  02bc      pop     {r1}
0x000d91e2:  0847      bx      r1
0x000d91e4:  0020      movs    r0, #0
0x000d91e6:  fae7      b       #0xd91de
0x000d91e8:  0120      movs    r0, #1
0x000d91ea:  4042      rsbs    r0, r0, #0
0x000d91ec:  f7e7      b       #0xd91de
0x000d91ee:  0000      movs    r0, r0
0x000d91f0:  00b5      push    {lr}
0x000d91f2:  0906      lsls    r1, r1, #0x18
0x000d91f4:  090e      lsrs    r1, r1, #0x18
0x000d91f6:  03e0      b       #0xd9200
0x000d91f8:  1b0e      lsrs    r3, r3, #0x18
0x000d91fa:  8b42      cmp     r3, r1
0x000d91fc:  05d0      beq     #0xd920a
0x000d91fe:  0130      adds    r0, #1
0x000d9200:  0378      ldrb    r3, [r0]
0x000d9202:  1b06      lsls    r3, r3, #0x18
0x000d9204:  002b      cmp     r3, #0
0x000d9206:  f7d1      bne     #0xd91f8
0x000d9208:  0020      movs    r0, #0
0x000d920a:  02bc      pop     {r1}
0x000d920c:  0847      bx      r1
0x000d920e:  0000      movs    r0, r0
0x000d9210:  30b5      push    {r4, r5, lr}
0x000d9212:  0278      ldrb    r2, [r0]
0x000d9214:  0d1c      adds    r5, r1, #0
0x000d9216:  041c      adds    r4, r0, #0
0x000d9218:  0ee0      b       #0xd9238
0x000d921a:  201c      adds    r0, r4, #0
0x000d921c:  fef7ceff  bl      #0xd81bc  ; sub_000d81bc
0x000d9220:  0004      lsls    r0, r0, #0x10
0x000d9222:  000c      lsrs    r0, r0, #0x10
0x000d9224:  a842      cmp     r0, r5
0x000d9226:  1bd0      beq     #0xd9260
0x000d9228:  0234      adds    r4, #2
0x000d922a:  2278      ldrb    r2, [r4]
0x000d922c:  002a      cmp     r2, #0
0x000d922e:  17d0      beq     #0xd9260
0x000d9230:  631e      subs    r3, r4, #1
0x000d9232:  1b78      ldrb    r3, [r3]
0x000d9234:  002b      cmp     r3, #0
0x000d9236:  13d0      beq     #0xd9260
0x000d9238:  131c      adds    r3, r2, #0
0x000d923a:  7f33      adds    r3, #0x7f
0x000d923c:  1b06      lsls    r3, r3, #0x18
0x000d923e:  1b0e      lsrs    r3, r3, #0x18
0x000d9240:  1e2b      cmp     r3, #0x1e
0x000d9242:  ead9      bls     #0xd921a
0x000d9244:  131c      adds    r3, r2, #0
0x000d9246:  2033      adds    r3, #0x20
0x000d9248:  1b06      lsls    r3, r3, #0x18
0x000d924a:  1b0e      lsrs    r3, r3, #0x18
0x000d924c:  1c2b      cmp     r3, #0x1c
0x000d924e:  e4d9      bls     #0xd921a
0x000d9250:  1306      lsls    r3, r2, #0x18
0x000d9252:  1b0e      lsrs    r3, r3, #0x18
0x000d9254:  ab42      cmp     r3, r5
0x000d9256:  03d0      beq     #0xd9260
0x000d9258:  0134      adds    r4, #1
0x000d925a:  2278      ldrb    r2, [r4]
0x000d925c:  002a      cmp     r2, #0
0x000d925e:  e7d1      bne     #0xd9230
0x000d9260:  201c      adds    r0, r4, #0
0x000d9262:  30bc      pop     {r4, r5}
0x000d9264:  02bc      pop     {r1}
0x000d9266:  0847      bx      r1
0x000d9268:  30b5      push    {r4, r5, lr}
0x000d926a:  051c      adds    r5, r0, #0
0x000d926c:  081c      adds    r0, r1, #0
0x000d926e:  0c1c      adds    r4, r1, #0
0x000d9270:  fff7d8f8  bl      #0xd8424  ; sub_000d8424
0x000d9274:  ff28      cmp     r0, #0xff
0x000d9276:  00dd      ble     #0xd927a
0x000d9278:  ff20      movs    r0, #0xff
0x000d927a:  2870      strb    r0, [r5]
0x000d927c:  0135      adds    r5, #1
0x000d927e:  0028      cmp     r0, #0
0x000d9280:  07dd      ble     #0xd9292
0x000d9282:  021c      adds    r2, r0, #0
0x000d9284:  2378      ldrb    r3, [r4]
0x000d9286:  013a      subs    r2, #1
0x000d9288:  2b70      strb    r3, [r5]
0x000d928a:  0134      adds    r4, #1
0x000d928c:  0135      adds    r5, #1
0x000d928e:  002a      cmp     r2, #0
0x000d9290:  f8d1      bne     #0xd9284
0x000d9292:  30bc      pop     {r4, r5}
0x000d9294:  02bc      pop     {r1}
0x000d9296:  0847      bx      r1
0x000d9298:  10b5      push    {r4, lr}
0x000d929a:  0c78      ldrb    r4, [r1]
0x000d929c:  0131      adds    r1, #1
0x000d929e:  002c      cmp     r4, #0
0x000d92a0:  07dd      ble     #0xd92b2
0x000d92a2:  221c      adds    r2, r4, #0
0x000d92a4:  0b78      ldrb    r3, [r1]
0x000d92a6:  013a      subs    r2, #1
0x000d92a8:  0370      strb    r3, [r0]
0x000d92aa:  0131      adds    r1, #1
0x000d92ac:  0130      adds    r0, #1
0x000d92ae:  002a      cmp     r2, #0
0x000d92b0:  f8d1      bne     #0xd92a4
0x000d92b2:  0023      movs    r3, #0
0x000d92b4:  0370      strb    r3, [r0]
0x000d92b6:  201c      adds    r0, r4, #0
0x000d92b8:  10bc      pop     {r4}
0x000d92ba:  02bc      pop     {r1}
0x000d92bc:  0847      bx      r1
0x000d92be:  0000      movs    r0, r0
0x000d92c0:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d92c2:  4746      mov     r7, r8
0x000d92c4:  80b4      push    {r7}
0x000d92c6:  8846      mov     r8, r1
0x000d92c8:  141c      adds    r4, r2, #0
0x000d92ca:  061c      adds    r6, r0, #0
0x000d92cc:  fff7aaf8  bl      #0xd8424  ; sub_000d8424
0x000d92d0:  051c      adds    r5, r0, #0
0x000d92d2:  4046      mov     r0, r8
0x000d92d4:  fff7a6f8  bl      #0xd8424  ; sub_000d8424
0x000d92d8:  071c      adds    r7, r0, #0
0x000d92da:  002c      cmp     r4, #0

===== sub_000d91a4 @ 0x000d91a4 =====
0x000d91a4:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d91a6:  071c      adds    r7, r0, #0
0x000d91a8:  0e1c      adds    r6, r1, #0
0x000d91aa:  151c      adds    r5, r2, #0
0x000d91ac:  2b1c      adds    r3, r5, #0
0x000d91ae:  013d      subs    r5, #1
0x000d91b0:  002b      cmp     r3, #0
0x000d91b2:  17dd      ble     #0xd91e4
0x000d91b4:  3878      ldrb    r0, [r7]
0x000d91b6:  fff7ebfe  bl      #0xd8f90  ; sub_000d8f90
0x000d91ba:  0006      lsls    r0, r0, #0x18
0x000d91bc:  040e      lsrs    r4, r0, #0x18
0x000d91be:  3078      ldrb    r0, [r6]
0x000d91c0:  fff7e6fe  bl      #0xd8f90  ; sub_000d8f90
0x000d91c4:  0006      lsls    r0, r0, #0x18
0x000d91c6:  0137      adds    r7, #1
0x000d91c8:  0136      adds    r6, #1
0x000d91ca:  000e      lsrs    r0, r0, #0x18
0x000d91cc:  002c      cmp     r4, #0
0x000d91ce:  01d1      bne     #0xd91d4
0x000d91d0:  0028      cmp     r0, #0
0x000d91d2:  07d0      beq     #0xd91e4
0x000d91d4:  8442      cmp     r4, r0
0x000d91d6:  e9d0      beq     #0xd91ac
0x000d91d8:  8442      cmp     r4, r0
0x000d91da:  05d9      bls     #0xd91e8
0x000d91dc:  0120      movs    r0, #1
0x000d91de:  f0bc      pop     {r4, r5, r6, r7}
0x000d91e0:  02bc      pop     {r1}
0x000d91e2:  0847      bx      r1
0x000d91e4:  0020      movs    r0, #0
0x000d91e6:  fae7      b       #0xd91de
0x000d91e8:  0120      movs    r0, #1
0x000d91ea:  4042      rsbs    r0, r0, #0
0x000d91ec:  f7e7      b       #0xd91de
0x000d91ee:  0000      movs    r0, r0
0x000d91f0:  00b5      push    {lr}
0x000d91f2:  0906      lsls    r1, r1, #0x18
0x000d91f4:  090e      lsrs    r1, r1, #0x18
0x000d91f6:  03e0      b       #0xd9200
0x000d91f8:  1b0e      lsrs    r3, r3, #0x18
0x000d91fa:  8b42      cmp     r3, r1
0x000d91fc:  05d0      beq     #0xd920a
0x000d91fe:  0130      adds    r0, #1
0x000d9200:  0378      ldrb    r3, [r0]
0x000d9202:  1b06      lsls    r3, r3, #0x18
0x000d9204:  002b      cmp     r3, #0
0x000d9206:  f7d1      bne     #0xd91f8
0x000d9208:  0020      movs    r0, #0
0x000d920a:  02bc      pop     {r1}
0x000d920c:  0847      bx      r1
0x000d920e:  0000      movs    r0, r0
0x000d9210:  30b5      push    {r4, r5, lr}
0x000d9212:  0278      ldrb    r2, [r0]
0x000d9214:  0d1c      adds    r5, r1, #0
0x000d9216:  041c      adds    r4, r0, #0
0x000d9218:  0ee0      b       #0xd9238
0x000d921a:  201c      adds    r0, r4, #0
0x000d921c:  fef7ceff  bl      #0xd81bc  ; sub_000d81bc
0x000d9220:  0004      lsls    r0, r0, #0x10
0x000d9222:  000c      lsrs    r0, r0, #0x10
0x000d9224:  a842      cmp     r0, r5
0x000d9226:  1bd0      beq     #0xd9260
0x000d9228:  0234      adds    r4, #2
0x000d922a:  2278      ldrb    r2, [r4]
0x000d922c:  002a      cmp     r2, #0
0x000d922e:  17d0      beq     #0xd9260
0x000d9230:  631e      subs    r3, r4, #1
0x000d9232:  1b78      ldrb    r3, [r3]
0x000d9234:  002b      cmp     r3, #0
0x000d9236:  13d0      beq     #0xd9260
0x000d9238:  131c      adds    r3, r2, #0
0x000d923a:  7f33      adds    r3, #0x7f
0x000d923c:  1b06      lsls    r3, r3, #0x18
0x000d923e:  1b0e      lsrs    r3, r3, #0x18
0x000d9240:  1e2b      cmp     r3, #0x1e
0x000d9242:  ead9      bls     #0xd921a
0x000d9244:  131c      adds    r3, r2, #0
0x000d9246:  2033      adds    r3, #0x20
0x000d9248:  1b06      lsls    r3, r3, #0x18
0x000d924a:  1b0e      lsrs    r3, r3, #0x18
0x000d924c:  1c2b      cmp     r3, #0x1c
0x000d924e:  e4d9      bls     #0xd921a
0x000d9250:  1306      lsls    r3, r2, #0x18
0x000d9252:  1b0e      lsrs    r3, r3, #0x18
0x000d9254:  ab42      cmp     r3, r5
0x000d9256:  03d0      beq     #0xd9260
0x000d9258:  0134      adds    r4, #1
0x000d925a:  2278      ldrb    r2, [r4]
0x000d925c:  002a      cmp     r2, #0
0x000d925e:  e7d1      bne     #0xd9230
0x000d9260:  201c      adds    r0, r4, #0
0x000d9262:  30bc      pop     {r4, r5}
0x000d9264:  02bc      pop     {r1}
0x000d9266:  0847      bx      r1
0x000d9268:  30b5      push    {r4, r5, lr}
0x000d926a:  051c      adds    r5, r0, #0
0x000d926c:  081c      adds    r0, r1, #0
0x000d926e:  0c1c      adds    r4, r1, #0
0x000d9270:  fff7d8f8  bl      #0xd8424  ; sub_000d8424
0x000d9274:  ff28      cmp     r0, #0xff
0x000d9276:  00dd      ble     #0xd927a
0x000d9278:  ff20      movs    r0, #0xff
0x000d927a:  2870      strb    r0, [r5]
0x000d927c:  0135      adds    r5, #1
0x000d927e:  0028      cmp     r0, #0
0x000d9280:  07dd      ble     #0xd9292
0x000d9282:  021c      adds    r2, r0, #0
0x000d9284:  2378      ldrb    r3, [r4]
0x000d9286:  013a      subs    r2, #1
0x000d9288:  2b70      strb    r3, [r5]
0x000d928a:  0134      adds    r4, #1
0x000d928c:  0135      adds    r5, #1
0x000d928e:  002a      cmp     r2, #0
0x000d9290:  f8d1      bne     #0xd9284
0x000d9292:  30bc      pop     {r4, r5}
0x000d9294:  02bc      pop     {r1}
0x000d9296:  0847      bx      r1
0x000d9298:  10b5      push    {r4, lr}
0x000d929a:  0c78      ldrb    r4, [r1]
0x000d929c:  0131      adds    r1, #1
0x000d929e:  002c      cmp     r4, #0
0x000d92a0:  07dd      ble     #0xd92b2
0x000d92a2:  221c      adds    r2, r4, #0
0x000d92a4:  0b78      ldrb    r3, [r1]
0x000d92a6:  013a      subs    r2, #1
0x000d92a8:  0370      strb    r3, [r0]
0x000d92aa:  0131      adds    r1, #1
0x000d92ac:  0130      adds    r0, #1
0x000d92ae:  002a      cmp     r2, #0
0x000d92b0:  f8d1      bne     #0xd92a4
0x000d92b2:  0023      movs    r3, #0
0x000d92b4:  0370      strb    r3, [r0]
0x000d92b6:  201c      adds    r0, r4, #0
0x000d92b8:  10bc      pop     {r4}
0x000d92ba:  02bc      pop     {r1}
0x000d92bc:  0847      bx      r1
0x000d92be:  0000      movs    r0, r0
0x000d92c0:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d92c2:  4746      mov     r7, r8
0x000d92c4:  80b4      push    {r7}
0x000d92c6:  8846      mov     r8, r1
0x000d92c8:  141c      adds    r4, r2, #0
0x000d92ca:  061c      adds    r6, r0, #0
0x000d92cc:  fff7aaf8  bl      #0xd8424  ; sub_000d8424
0x000d92d0:  051c      adds    r5, r0, #0
0x000d92d2:  4046      mov     r0, r8
0x000d92d4:  fff7a6f8  bl      #0xd8424  ; sub_000d8424
0x000d92d8:  071c      adds    r7, r0, #0
0x000d92da:  002c      cmp     r4, #0
0x000d92dc:  12d0      beq     #0xd9304
0x000d92de:  bd42      cmp     r5, r7
0x000d92e0:  0adb      blt     #0xd92f8
0x000d92e2:  301c      adds    r0, r6, #0
0x000d92e4:  4146      mov     r1, r8
0x000d92e6:  3a1c      adds    r2, r7, #0
0x000d92e8:  fff75cff  bl      #0xd91a4  ; sub_000d91a4
0x000d92ec:  0028      cmp     r0, #0
0x000d92ee:  17d0      beq     #0xd9320
0x000d92f0:  0136      adds    r6, #1
0x000d92f2:  013d      subs    r5, #1
0x000d92f4:  bd42      cmp     r5, r7
0x000d92f6:  f4da      bge     #0xd92e2
0x000d92f8:  0020      movs    r0, #0
0x000d92fa:  08bc      pop     {r3}
0x000d92fc:  9846      mov     r8, r3
0x000d92fe:  f0bc      pop     {r4, r5, r6, r7}
0x000d9300:  02bc      pop     {r1}
0x000d9302:  0847      bx      r1
0x000d9304:  bd42      cmp     r5, r7
0x000d9306:  f7db      blt     #0xd92f8
0x000d9308:  301c      adds    r0, r6, #0
0x000d930a:  4146      mov     r1, r8
0x000d930c:  3a1c      adds    r2, r7, #0
0x000d930e:  fff72bff  bl      #0xd9168  ; sub_000d9168
0x000d9312:  0028      cmp     r0, #0
0x000d9314:  04d0      beq     #0xd9320
0x000d9316:  0136      adds    r6, #1
0x000d9318:  013d      subs    r5, #1
0x000d931a:  bd42      cmp     r5, r7
0x000d931c:  f4da      bge     #0xd9308
0x000d931e:  ebe7      b       #0xd92f8
0x000d9320:  301c      adds    r0, r6, #0
0x000d9322:  eae7      b       #0xd92fa
0x000d9324:  f0b5      push    {r4, r5, r6, r7, lr}
0x000d9326:  051c      adds    r5, r0, #0
0x000d9328:  0f1c      adds    r7, r1, #0
0x000d932a:  0026      movs    r6, #0
0x000d932c:  002a      cmp     r2, #0
0x000d932e:  15d0      beq     #0xd935c
0x000d9330:  0368      ldr     r3, [r0]
0x000d9332:  002b      cmp     r3, #0
0x000d9334:  0dd0      beq     #0xd9352
0x000d9336:  0022      movs    r2, #0
0x000d9338:  0024      movs    r4, #0
0x000d933a:  5059      ldr     r0, [r2, r5]
0x000d933c:  391c      adds    r1, r7, #0
0x000d933e:  fff7f3fe  bl      #0xd9128  ; sub_000d9128
0x000d9342:  0028      cmp     r0, #0
0x000d9344:  21d0      beq     #0xd938a
0x000d9346:  0434      adds    r4, #4
0x000d9348:  6359      ldr     r3, [r4, r5]
0x000d934a:  0136      adds    r6, #1
0x000d934c:  221c      adds    r2, r4, #0
0x000d934e:  002b      cmp     r3, #0
0x000d9350:  f3d1      bne     #0xd933a
0x000d9352:  0120      movs    r0, #1
0x000d9354:  4042      rsbs    r0, r0, #0
0x000d9356:  f0bc      pop     {r4, r5, r6, r7}
0x000d9358:  02bc      pop     {r1}
0x000d935a:  0847      bx      r1
0x000d935c:  0368      ldr     r3, [r0]
0x000d935e:  002b      cmp     r3, #0
0x000d9360:  f7d0      beq     #0xd9352
0x000d9362:  0022      movs    r2, #0
0x000d9364:  0024      movs    r4, #0
0x000d9366:  5059      ldr     r0, [r2, r5]
0x000d9368:  391c      adds    r1, r7, #0
0x000d936a:  fff7c7fe  bl      #0xd90fc  ; sub_000d90fc
0x000d936e:  0028      cmp     r0, #0
0x000d9370:  0bd0      beq     #0xd938a
0x000d9372:  0434      adds    r4, #4
0x000d9374:  6359      ldr     r3, [r4, r5]
0x000d9376:  0136      adds    r6, #1
0x000d9378:  221c      adds    r2, r4, #0
0x000d937a:  002b      cmp     r3, #0
0x000d937c:  e9d0      beq     #0xd9352
0x000d937e:  5059      ldr     r0, [r2, r5]
0x000d9380:  391c      adds    r1, r7, #0

===== sub_000d93c8 @ 0x000d93c8 =====
0x000d93c8:  0023      movs    r3, #0
0x000d93ca:  0360      str     r3, [r0]
0x000d93cc:  4360      str     r3, [r0, #4]
0x000d93ce:  8160      str     r1, [r0, #8]
0x000d93d0:  7047      bx      lr

===== sub_000d9408 @ 0x000d9408 =====
0x000d9408:  00b5      push    {lr}
0x000d940a:  0023      movs    r3, #0
0x000d940c:  0b60      str     r3, [r1]
0x000d940e:  0368      ldr     r3, [r0]
0x000d9410:  002b      cmp     r3, #0
0x000d9412:  03d1      bne     #0xd941c
0x000d9414:  4b60      str     r3, [r1, #4]
0x000d9416:  0160      str     r1, [r0]
0x000d9418:  01bc      pop     {r0}
0x000d941a:  0047      bx      r0
0x000d941c:  1a1c      adds    r2, r3, #0
0x000d941e:  1b68      ldr     r3, [r3]
0x000d9420:  002b      cmp     r3, #0
0x000d9422:  fbd1      bne     #0xd941c
0x000d9424:  1160      str     r1, [r2]
0x000d9426:  4a60      str     r2, [r1, #4]
0x000d9428:  f6e7      b       #0xd9418
0x000d942a:  0000      movs    r0, r0
0x000d942c:  10b5      push    {r4, lr}
0x000d942e:  041c      adds    r4, r0, #0
0x000d9430:  2368      ldr     r3, [r4]
0x000d9432:  081c      adds    r0, r1, #0
0x000d9434:  111c      adds    r1, r2, #0
0x000d9436:  002b      cmp     r3, #0
0x000d9438:  15d0      beq     #0xd9466
0x000d943a:  0b68      ldr     r3, [r1]
0x000d943c:  01e0      b       #0xd9442
0x000d943e:  1a1c      adds    r2, r3, #0
0x000d9440:  1b68      ldr     r3, [r3]
0x000d9442:  002b      cmp     r3, #0
0x000d9444:  fbd1      bne     #0xd943e
0x000d9446:  0028      cmp     r0, #0
0x000d9448:  08d0      beq     #0xd945c
0x000d944a:  0368      ldr     r3, [r0]
0x000d944c:  1360      str     r3, [r2]
0x000d944e:  0368      ldr     r3, [r0]
0x000d9450:  002b      cmp     r3, #0
0x000d9452:  00d0      beq     #0xd9456
0x000d9454:  5a60      str     r2, [r3, #4]
0x000d9456:  0160      str     r1, [r0]
0x000d9458:  4860      str     r0, [r1, #4]
0x000d945a:  05e0      b       #0xd9468
0x000d945c:  4860      str     r0, [r1, #4]
0x000d945e:  2368      ldr     r3, [r4]
0x000d9460:  1360      str     r3, [r2]
0x000d9462:  2368      ldr     r3, [r4]
0x000d9464:  5a60      str     r2, [r3, #4]
0x000d9466:  2160      str     r1, [r4]
0x000d9468:  10bc      pop     {r4}
0x000d946a:  01bc      pop     {r0}
0x000d946c:  0047      bx      r0
0x000d946e:  0000      movs    r0, r0
0x000d9470:  00b5      push    {lr}
0x000d9472:  0368      ldr     r3, [r0]
0x000d9474:  002b      cmp     r3, #0
0x000d9476:  03d1      bne     #0xd9480
0x000d9478:  4b60      str     r3, [r1, #4]
0x000d947a:  0160      str     r1, [r0]
0x000d947c:  01bc      pop     {r0}
0x000d947e:  0047      bx      r0
0x000d9480:  1a1c      adds    r2, r3, #0
0x000d9482:  1b68      ldr     r3, [r3]
0x000d9484:  002b      cmp     r3, #0
0x000d9486:  fbd1      bne     #0xd9480
0x000d9488:  1160      str     r1, [r2]
0x000d948a:  4a60      str     r2, [r1, #4]
0x000d948c:  f6e7      b       #0xd947c
0x000d948e:  0000      movs    r0, r0
0x000d9490:  00b5      push    {lr}
0x000d9492:  0a68      ldr     r2, [r1]
0x000d9494:  002a      cmp     r2, #0
0x000d9496:  01d0      beq     #0xd949c
0x000d9498:  4b68      ldr     r3, [r1, #4]
0x000d949a:  5360      str     r3, [r2, #4]
0x000d949c:  4b68      ldr     r3, [r1, #4]
0x000d949e:  002b      cmp     r3, #0
0x000d94a0:  04d1      bne     #0xd94ac
0x000d94a2:  0368      ldr     r3, [r0]
0x000d94a4:  8b42      cmp     r3, r1
0x000d94a6:  02d1      bne     #0xd94ae
0x000d94a8:  0260      str     r2, [r0]
0x000d94aa:  00e0      b       #0xd94ae
0x000d94ac:  1a60      str     r2, [r3]
0x000d94ae:  0023      movs    r3, #0
0x000d94b0:  4b60      str     r3, [r1, #4]
0x000d94b2:  0b60      str     r3, [r1]
0x000d94b4:  01bc      pop     {r0}
0x000d94b6:  0047      bx      r0
0x000d94b8:  00b5      push    {lr}
0x000d94ba:  0023      movs    r3, #0
0x000d94bc:  0028      cmp     r0, #0
0x000d94be:  03d0      beq     #0xd94c8
0x000d94c0:  0068      ldr     r0, [r0]
0x000d94c2:  0133      adds    r3, #1
0x000d94c4:  0028      cmp     r0, #0
0x000d94c6:  fbd1      bne     #0xd94c0
0x000d94c8:  181c      adds    r0, r3, #0
0x000d94ca:  02bc      pop     {r1}
0x000d94cc:  0847      bx      r1
0x000d94ce:  c046      mov     r8, r8
0x000d94d0:  024b      ldr     r3, [pc, #8]
0x000d94d2:  0004      lsls    r0, r0, #0x10
0x000d94d4:  000c      lsrs    r0, r0, #0x10
0x000d94d6:  1860      str     r0, [r3]
0x000d94d8:  7047      bx      lr

===== sub_000d9490 @ 0x000d9490 =====
0x000d9490:  00b5      push    {lr}
0x000d9492:  0a68      ldr     r2, [r1]
0x000d9494:  002a      cmp     r2, #0
0x000d9496:  01d0      beq     #0xd949c
0x000d9498:  4b68      ldr     r3, [r1, #4]
0x000d949a:  5360      str     r3, [r2, #4]
0x000d949c:  4b68      ldr     r3, [r1, #4]
0x000d949e:  002b      cmp     r3, #0
0x000d94a0:  04d1      bne     #0xd94ac
0x000d94a2:  0368      ldr     r3, [r0]
0x000d94a4:  8b42      cmp     r3, r1
0x000d94a6:  02d1      bne     #0xd94ae
0x000d94a8:  0260      str     r2, [r0]
0x000d94aa:  00e0      b       #0xd94ae
0x000d94ac:  1a60      str     r2, [r3]
0x000d94ae:  0023      movs    r3, #0
0x000d94b0:  4b60      str     r3, [r1, #4]
0x000d94b2:  0b60      str     r3, [r1]
0x000d94b4:  01bc      pop     {r0}
0x000d94b6:  0047      bx      r0
0x000d94b8:  00b5      push    {lr}
0x000d94ba:  0023      movs    r3, #0
0x000d94bc:  0028      cmp     r0, #0
0x000d94be:  03d0      beq     #0xd94c8
0x000d94c0:  0068      ldr     r0, [r0]
0x000d94c2:  0133      adds    r3, #1
0x000d94c4:  0028      cmp     r0, #0
0x000d94c6:  fbd1      bne     #0xd94c0
0x000d94c8:  181c      adds    r0, r3, #0
0x000d94ca:  02bc      pop     {r1}
0x000d94cc:  0847      bx      r1
0x000d94ce:  c046      mov     r8, r8
0x000d94d0:  024b      ldr     r3, [pc, #8]
0x000d94d2:  0004      lsls    r0, r0, #0x10
0x000d94d4:  000c      lsrs    r0, r0, #0x10
0x000d94d6:  1860      str     r0, [r3]
0x000d94d8:  7047      bx      lr

===== sub_000dc3b4 @ 0x000dc3b4 =====
0x000dc3b4:  10b5      push    {r4, lr}
0x000dc3b6:  8842      cmp     r0, r1
0x000dc3b8:  01d3      blo     #0xdc3be
0x000dc3ba:  0029      cmp     r1, #0
0x000dc3bc:  03d1      bne     #0xdc3c6
0x000dc3be:  0020      movs    r0, #0
0x000dc3c0:  10bc      pop     {r4}
0x000dc3c2:  02bc      pop     {r1}
0x000dc3c4:  0847      bx      r1
0x000dc3c6:  ca07      lsls    r2, r1, #0x1f
0x000dc3c8:  05d4      bmi     #0xdc3d6
0x000dc3ca:  0123      movs    r3, #1
0x000dc3cc:  4908      lsrs    r1, r1, #1
0x000dc3ce:  1a1c      adds    r2, r3, #0
0x000dc3d0:  4008      lsrs    r0, r0, #1
0x000dc3d2:  8a43      bics    r2, r1
0x000dc3d4:  fad1      bne     #0xdc3cc
0x000dc3d6:  0129      cmp     r1, #1
0x000dc3d8:  f2d0      beq     #0xdc3c0
0x000dc3da:  040a      lsrs    r4, r0, #8
0x000dc3dc:  0022      movs    r2, #0
0x000dc3de:  0123      movs    r3, #1
0x000dc3e0:  8c42      cmp     r4, r1
0x000dc3e2:  06d3      blo     #0xdc3f2
0x000dc3e4:  0902      lsls    r1, r1, #8
0x000dc3e6:  1b02      lsls    r3, r3, #8
0x000dc3e8:  8c42      cmp     r4, r1
0x000dc3ea:  fbd2      bhs     #0xdc3e4
0x000dc3ec:  05e0      b       #0xdc3fa
0x000dc3ee:  d218      adds    r2, r2, r3
0x000dc3f0:  401a      subs    r0, r0, r1
0x000dc3f2:  8842      cmp     r0, r1
0x000dc3f4:  fbd2      bhs     #0xdc3ee
0x000dc3f6:  090a      lsrs    r1, r1, #8
0x000dc3f8:  1b0a      lsrs    r3, r3, #8
0x000dc3fa:  002b      cmp     r3, #0
0x000dc3fc:  f9d1      bne     #0xdc3f2
0x000dc3fe:  101c      adds    r0, r2, #0
0x000dc400:  dee7      b       #0xdc3c0
0x000dc402:  0000      movs    r0, r0
0x000dc404:  30b5      push    {r4, r5, lr}
0x000dc406:  051c      adds    r5, r0, #0
0x000dc408:  0c1c      adds    r4, r1, #0
0x000dc40a:  0129      cmp     r1, #1
0x000dc40c:  03d8      bhi     #0xdc416
0x000dc40e:  0020      movs    r0, #0
0x000dc410:  30bc      pop     {r4, r5}
0x000dc412:  02bc      pop     {r1}
0x000dc414:  0847      bx      r1
0x000dc416:  fff7cdff  bl      #0xdc3b4  ; sub_000dc3b4
0x000dc41a:  231c      adds    r3, r4, #0
0x000dc41c:  4343      muls    r3, r0, r3
0x000dc41e:  e81a      subs    r0, r5, r3
0x000dc420:  f6e7      b       #0xdc410
0x000dc422:  0000      movs    r0, r0
0x000dc424:  00b5      push    {lr}
0x000dc426:  0028      cmp     r0, #0
0x000dc428:  01dd      ble     #0xdc42e
0x000dc42a:  02bc      pop     {r1}
0x000dc42c:  0847      bx      r1
0x000dc42e:  4042      rsbs    r0, r0, #0
0x000dc430:  fbe7      b       #0xdc42a
0x000dc432:  0000      movs    r0, r0
0x000dc434:  70b5      push    {r4, r5, r6, lr}
0x000dc436:  0e1c      adds    r6, r1, #0
0x000dc438:  0028      cmp     r0, #0
0x000dc43a:  01d0      beq     #0xdc440
0x000dc43c:  0029      cmp     r1, #0
0x000dc43e:  03d1      bne     #0xdc448
0x000dc440:  0020      movs    r0, #0
0x000dc442:  70bc      pop     {r4, r5, r6}
0x000dc444:  02bc      pop     {r1}
0x000dc446:  0847      bx      r1
0x000dc448:  041c      adds    r4, r0, #0
0x000dc44a:  8023      movs    r3, #0x80
0x000dc44c:  4c40      eors    r4, r1
0x000dc44e:  1b06      lsls    r3, r3, #0x18
0x000dc450:  1c40      ands    r4, r3
0x000dc452:  fff7e7ff  bl      #0xdc424  ; sub_000dc424
0x000dc456:  051c      adds    r5, r0, #0
0x000dc458:  301c      adds    r0, r6, #0
0x000dc45a:  fff7e3ff  bl      #0xdc424  ; sub_000dc424
0x000dc45e:  011c      adds    r1, r0, #0
0x000dc460:  281c      adds    r0, r5, #0
0x000dc462:  fff7cfff  bl      #0xdc404  ; sub_000dc404
0x000dc466:  002c      cmp     r4, #0
0x000dc468:  ebd0      beq     #0xdc442
0x000dc46a:  4042      rsbs    r0, r0, #0
0x000dc46c:  e9e7      b       #0xdc442
0x000dc46e:  0000      movs    r0, r0
0x000dc470:  70b5      push    {r4, r5, r6, lr}
0x000dc472:  0e1c      adds    r6, r1, #0
0x000dc474:  0028      cmp     r0, #0
0x000dc476:  01d0      beq     #0xdc47c
0x000dc478:  0029      cmp     r1, #0
0x000dc47a:  03d1      bne     #0xdc484
0x000dc47c:  0020      movs    r0, #0
0x000dc47e:  70bc      pop     {r4, r5, r6}
0x000dc480:  02bc      pop     {r1}
0x000dc482:  0847      bx      r1
0x000dc484:  041c      adds    r4, r0, #0
0x000dc486:  8023      movs    r3, #0x80
0x000dc488:  4c40      eors    r4, r1
0x000dc48a:  1b06      lsls    r3, r3, #0x18
0x000dc48c:  1c40      ands    r4, r3
0x000dc48e:  fff7c9ff  bl      #0xdc424  ; sub_000dc424
0x000dc492:  051c      adds    r5, r0, #0
0x000dc494:  301c      adds    r0, r6, #0
0x000dc496:  fff7c5ff  bl      #0xdc424  ; sub_000dc424
0x000dc49a:  011c      adds    r1, r0, #0
0x000dc49c:  281c      adds    r0, r5, #0
0x000dc49e:  fff789ff  bl      #0xdc3b4  ; sub_000dc3b4
0x000dc4a2:  002c      cmp     r4, #0
0x000dc4a4:  ebd0      beq     #0xdc47e
0x000dc4a6:  4042      rsbs    r0, r0, #0
0x000dc4a8:  e9e7      b       #0xdc47e
0x000dc4aa:  c046      mov     r8, r8
0x000dc4ac:  10b5      push    {r4, lr}
0x000dc4ae:  0368      ldr     r3, [r0]
0x000dc4b0:  002b      cmp     r3, #0
0x000dc4b2:  08d0      beq     #0xdc4c6
0x000dc4b4:  021c      adds    r2, r0, #0
0x000dc4b6:  1432      adds    r2, #0x14
0x000dc4b8:  d368      ldr     r3, [r2, #0xc]
0x000dc4ba:  8b42      cmp     r3, r1
0x000dc4bc:  09d8      bhi     #0xdc4d2
0x000dc4be:  101c      adds    r0, r2, #0
0x000dc4c0:  0368      ldr     r3, [r0]
0x000dc4c2:  002b      cmp     r3, #0
0x000dc4c4:  f6d1      bne     #0xdc4b4
0x000dc4c6:  0b48      ldr     r0, [pc, #0x2c]  ; &"#POOL:Free fail size unknown[%lx]"
0x000dc4c8:  fcf71cfd  bl      #0xd8f04  ; sub_000d8f04
0x000dc4cc:  10bc      pop     {r4}
0x000dc4ce:  01bc      pop     {r0}
0x000dc4d0:  0047      bx      r0
0x000dc4d2:  0269      ldr     r2, [r0, #0x10]
0x000dc4d4:  4068      ldr     r0, [r0, #4]
0x000dc4d6:  0024      movs    r4, #0
0x000dc4d8:  0028      cmp     r0, #0
0x000dc4da:  06dd      ble     #0xdc4ea
0x000dc4dc:  5368      ldr     r3, [r2, #4]
0x000dc4de:  8b42      cmp     r3, r1
0x000dc4e0:  05d0      beq     #0xdc4ee
0x000dc4e2:  0134      adds    r4, #1
0x000dc4e4:  0c32      adds    r2, #0xc
0x000dc4e6:  a042      cmp     r0, r4
0x000dc4e8:  f8dc      bgt     #0xdc4dc
0x000dc4ea:  0348      ldr     r0, [pc, #0xc]  ; &"#POOL:Free fail ptr unkown[%lx]"
0x000dc4ec:  ece7      b       #0xdc4c8
0x000dc4ee:  0023      movs    r3, #0
0x000dc4f0:  1380      strh    r3, [r2]
0x000dc4f2:  ebe7      b       #0xdc4cc
0x000dc4f4:  6084      strh    r0, [r4, #0x22]
0x000dc4f6:  1100      movs    r1, r2
0x000dc4f8:  8484      strh    r4, [r0, #0x24]
0x000dc4fa:  1100      movs    r1, r2
0x000dc4fc:  f0b5      push    {r4, r5, r6, r7, lr}
0x000dc4fe:  4746      mov     r7, r8
0x000dc500:  80b4      push    {r7}
0x000dc502:  041c      adds    r4, r0, #0
0x000dc504:  0026      movs    r6, #0
0x000dc506:  0d1e      subs    r5, r1, #0
0x000dc508:  03d1      bne     #0xdc512
0x000dc50a:  13e0      b       #0xdc534
0x000dc50c:  ab42      cmp     r3, r5
0x000dc50e:  16d2      bhs     #0xdc53e
0x000dc510:  1434      adds    r4, #0x14
0x000dc512:  2368      ldr     r3, [r4]
0x000dc514:  002b      cmp     r3, #0
0x000dc516:  f9d1      bne     #0xdc50c
0x000dc518:  1b48      ldr     r0, [pc, #0x6c]  ; &"#POOL: get NG size=%ld[0x%lx]"
0x000dc51a:  291c      adds    r1, r5, #0
0x000dc51c:  2a1c      adds    r2, r5, #0
0x000dc51e:  fcf7f1fc  bl      #0xd8f04  ; sub_000d8f04
0x000dc522:  0220      movs    r0, #2
0x000dc524:  faf700fd  bl      #0xd6f28  ; sub_000d6f28
0x000dc528:  301c      adds    r0, r6, #0
0x000dc52a:  08bc      pop     {r3}
0x000dc52c:  9846      mov     r8, r3
0x000dc52e:  f0bc      pop     {r4, r5, r6, r7}
0x000dc530:  02bc      pop     {r1}
0x000dc532:  0847      bx      r1
0x000dc534:  1548      ldr     r0, [pc, #0x54]  ; &"?POOL: get 0byte"
0x000dc536:  fcf7e5fc  bl      #0xd8f04  ; sub_000d8f04
0x000dc53a:  0020      movs    r0, #0
0x000dc53c:  f5e7      b       #0xdc52a
0x000dc53e:  0023      movs    r3, #0
0x000dc540:  9846      mov     r8, r3
0x000dc542:  f9f7d7fd  bl      #0xd60f4  ; sub_000d60f4
0x000dc546:  6368      ldr     r3, [r4, #4]
0x000dc548:  2669      ldr     r6, [r4, #0x10]
0x000dc54a:  0027      movs    r7, #0
0x000dc54c:  002b      cmp     r3, #0
0x000dc54e:  0bdd      ble     #0xdc568
0x000dc550:  301c      adds    r0, r6, #0
0x000dc552:  fbf7fffc  bl      #0xd7f54  ; sub_000d7f54
0x000dc556:  0004      lsls    r0, r0, #0x10
0x000dc558:  000c      lsrs    r0, r0, #0x10
0x000dc55a:  0128      cmp     r0, #1
0x000dc55c:  0ad0      beq     #0xdc574
0x000dc55e:  6368      ldr     r3, [r4, #4]
0x000dc560:  0137      adds    r7, #1
0x000dc562:  0c36      adds    r6, #0xc
0x000dc564:  bb42      cmp     r3, r7
0x000dc566:  f3dc      bgt     #0xdc550
0x000dc568:  4646      mov     r6, r8
0x000dc56a:  f9f7d3fd  bl      #0xd6114  ; sub_000d6114
0x000dc56e:  002e      cmp     r6, #0
0x000dc570:  dad1      bne     #0xdc528
0x000dc572:  d1e7      b       #0xdc518
0x000dc574:  a368      ldr     r3, [r4, #8]
0x000dc576:  7a1c      adds    r2, r7, #1
0x000dc578:  9a42      cmp     r2, r3
0x000dc57a:  00dd      ble     #0xdc57e
0x000dc57c:  a260      str     r2, [r4, #8]
0x000dc57e:  7368      ldr     r3, [r6, #4]
0x000dc580:  b560      str     r5, [r6, #8]
0x000dc582:  9846      mov     r8, r3
0x000dc584:  f0e7      b       #0xdc568
0x000dc586:  0000      movs    r0, r0
0x000dc588:  a484      strh    r4, [r4, #0x24]
0x000dc58a:  1100      movs    r1, r2
0x000dc58c:  c484      strh    r4, [r0, #0x26]
0x000dc58e:  1100      movs    r1, r2
0x000dc590:  f0b5      push    {r4, r5, r6, r7, lr}
0x000dc592:  4746      mov     r7, r8

===== sub_000dc470 @ 0x000dc470 =====
0x000dc470:  70b5      push    {r4, r5, r6, lr}
0x000dc472:  0e1c      adds    r6, r1, #0
0x000dc474:  0028      cmp     r0, #0
0x000dc476:  01d0      beq     #0xdc47c
0x000dc478:  0029      cmp     r1, #0
0x000dc47a:  03d1      bne     #0xdc484
0x000dc47c:  0020      movs    r0, #0
0x000dc47e:  70bc      pop     {r4, r5, r6}
0x000dc480:  02bc      pop     {r1}
0x000dc482:  0847      bx      r1
0x000dc484:  041c      adds    r4, r0, #0
0x000dc486:  8023      movs    r3, #0x80
0x000dc488:  4c40      eors    r4, r1
0x000dc48a:  1b06      lsls    r3, r3, #0x18
0x000dc48c:  1c40      ands    r4, r3
0x000dc48e:  fff7c9ff  bl      #0xdc424  ; sub_000dc424
0x000dc492:  051c      adds    r5, r0, #0
0x000dc494:  301c      adds    r0, r6, #0
0x000dc496:  fff7c5ff  bl      #0xdc424  ; sub_000dc424
0x000dc49a:  011c      adds    r1, r0, #0
0x000dc49c:  281c      adds    r0, r5, #0
0x000dc49e:  fff789ff  bl      #0xdc3b4  ; sub_000dc3b4
0x000dc4a2:  002c      cmp     r4, #0
0x000dc4a4:  ebd0      beq     #0xdc47e
0x000dc4a6:  4042      rsbs    r0, r0, #0
0x000dc4a8:  e9e7      b       #0xdc47e
0x000dc4aa:  c046      mov     r8, r8
0x000dc4ac:  10b5      push    {r4, lr}
0x000dc4ae:  0368      ldr     r3, [r0]
0x000dc4b0:  002b      cmp     r3, #0
0x000dc4b2:  08d0      beq     #0xdc4c6
0x000dc4b4:  021c      adds    r2, r0, #0
0x000dc4b6:  1432      adds    r2, #0x14
0x000dc4b8:  d368      ldr     r3, [r2, #0xc]
0x000dc4ba:  8b42      cmp     r3, r1
0x000dc4bc:  09d8      bhi     #0xdc4d2
0x000dc4be:  101c      adds    r0, r2, #0
0x000dc4c0:  0368      ldr     r3, [r0]
0x000dc4c2:  002b      cmp     r3, #0
0x000dc4c4:  f6d1      bne     #0xdc4b4
0x000dc4c6:  0b48      ldr     r0, [pc, #0x2c]  ; &"#POOL:Free fail size unknown[%lx]"
0x000dc4c8:  fcf71cfd  bl      #0xd8f04  ; sub_000d8f04
0x000dc4cc:  10bc      pop     {r4}
0x000dc4ce:  01bc      pop     {r0}
0x000dc4d0:  0047      bx      r0
0x000dc4d2:  0269      ldr     r2, [r0, #0x10]
0x000dc4d4:  4068      ldr     r0, [r0, #4]
0x000dc4d6:  0024      movs    r4, #0
0x000dc4d8:  0028      cmp     r0, #0
0x000dc4da:  06dd      ble     #0xdc4ea
0x000dc4dc:  5368      ldr     r3, [r2, #4]
0x000dc4de:  8b42      cmp     r3, r1
0x000dc4e0:  05d0      beq     #0xdc4ee
0x000dc4e2:  0134      adds    r4, #1
0x000dc4e4:  0c32      adds    r2, #0xc
0x000dc4e6:  a042      cmp     r0, r4
0x000dc4e8:  f8dc      bgt     #0xdc4dc
0x000dc4ea:  0348      ldr     r0, [pc, #0xc]  ; &"#POOL:Free fail ptr unkown[%lx]"
0x000dc4ec:  ece7      b       #0xdc4c8
0x000dc4ee:  0023      movs    r3, #0
0x000dc4f0:  1380      strh    r3, [r2]
0x000dc4f2:  ebe7      b       #0xdc4cc
0x000dc4f4:  6084      strh    r0, [r4, #0x22]
0x000dc4f6:  1100      movs    r1, r2
0x000dc4f8:  8484      strh    r4, [r0, #0x24]
0x000dc4fa:  1100      movs    r1, r2
0x000dc4fc:  f0b5      push    {r4, r5, r6, r7, lr}
0x000dc4fe:  4746      mov     r7, r8
0x000dc500:  80b4      push    {r7}
0x000dc502:  041c      adds    r4, r0, #0
0x000dc504:  0026      movs    r6, #0
0x000dc506:  0d1e      subs    r5, r1, #0
0x000dc508:  03d1      bne     #0xdc512
0x000dc50a:  13e0      b       #0xdc534
0x000dc50c:  ab42      cmp     r3, r5
0x000dc50e:  16d2      bhs     #0xdc53e
0x000dc510:  1434      adds    r4, #0x14
0x000dc512:  2368      ldr     r3, [r4]
0x000dc514:  002b      cmp     r3, #0
0x000dc516:  f9d1      bne     #0xdc50c
0x000dc518:  1b48      ldr     r0, [pc, #0x6c]  ; &"#POOL: get NG size=%ld[0x%lx]"
0x000dc51a:  291c      adds    r1, r5, #0
0x000dc51c:  2a1c      adds    r2, r5, #0
0x000dc51e:  fcf7f1fc  bl      #0xd8f04  ; sub_000d8f04
0x000dc522:  0220      movs    r0, #2
0x000dc524:  faf700fd  bl      #0xd6f28  ; sub_000d6f28
0x000dc528:  301c      adds    r0, r6, #0
0x000dc52a:  08bc      pop     {r3}
0x000dc52c:  9846      mov     r8, r3
0x000dc52e:  f0bc      pop     {r4, r5, r6, r7}
0x000dc530:  02bc      pop     {r1}
0x000dc532:  0847      bx      r1
0x000dc534:  1548      ldr     r0, [pc, #0x54]  ; &"?POOL: get 0byte"
0x000dc536:  fcf7e5fc  bl      #0xd8f04  ; sub_000d8f04
0x000dc53a:  0020      movs    r0, #0
0x000dc53c:  f5e7      b       #0xdc52a
0x000dc53e:  0023      movs    r3, #0
0x000dc540:  9846      mov     r8, r3
0x000dc542:  f9f7d7fd  bl      #0xd60f4  ; sub_000d60f4
0x000dc546:  6368      ldr     r3, [r4, #4]
0x000dc548:  2669      ldr     r6, [r4, #0x10]
0x000dc54a:  0027      movs    r7, #0
0x000dc54c:  002b      cmp     r3, #0
0x000dc54e:  0bdd      ble     #0xdc568
0x000dc550:  301c      adds    r0, r6, #0
0x000dc552:  fbf7fffc  bl      #0xd7f54  ; sub_000d7f54
0x000dc556:  0004      lsls    r0, r0, #0x10
0x000dc558:  000c      lsrs    r0, r0, #0x10
0x000dc55a:  0128      cmp     r0, #1
0x000dc55c:  0ad0      beq     #0xdc574
0x000dc55e:  6368      ldr     r3, [r4, #4]
0x000dc560:  0137      adds    r7, #1
0x000dc562:  0c36      adds    r6, #0xc
0x000dc564:  bb42      cmp     r3, r7
0x000dc566:  f3dc      bgt     #0xdc550
0x000dc568:  4646      mov     r6, r8
0x000dc56a:  f9f7d3fd  bl      #0xd6114  ; sub_000d6114
0x000dc56e:  002e      cmp     r6, #0
0x000dc570:  dad1      bne     #0xdc528
0x000dc572:  d1e7      b       #0xdc518
0x000dc574:  a368      ldr     r3, [r4, #8]
0x000dc576:  7a1c      adds    r2, r7, #1
0x000dc578:  9a42      cmp     r2, r3
0x000dc57a:  00dd      ble     #0xdc57e
0x000dc57c:  a260      str     r2, [r4, #8]
0x000dc57e:  7368      ldr     r3, [r6, #4]
0x000dc580:  b560      str     r5, [r6, #8]
0x000dc582:  9846      mov     r8, r3
0x000dc584:  f0e7      b       #0xdc568
0x000dc586:  0000      movs    r0, r0
0x000dc588:  a484      strh    r4, [r4, #0x24]
0x000dc58a:  1100      movs    r1, r2
0x000dc58c:  c484      strh    r4, [r0, #0x26]
0x000dc58e:  1100      movs    r1, r2
0x000dc590:  f0b5      push    {r4, r5, r6, r7, lr}
0x000dc592:  4746      mov     r7, r8
0x000dc594:  80b4      push    {r7}
0x000dc596:  0368      ldr     r3, [r0]
0x000dc598:  0025      movs    r5, #0
0x000dc59a:  061c      adds    r6, r0, #0
0x000dc59c:  0f1c      adds    r7, r1, #0
0x000dc59e:  a846      mov     r8, r5
0x000dc5a0:  002b      cmp     r3, #0
0x000dc5a2:  10d0      beq     #0xdc5c6
0x000dc5a4:  0c1c      adds    r4, r1, #0
0x000dc5a6:  2360      str     r3, [r4]
0x000dc5a8:  0022      movs    r2, #0
0x000dc5aa:  7368      ldr     r3, [r6, #4]
0x000dc5ac:  a260      str     r2, [r4, #8]
0x000dc5ae:  0c22      movs    r2, #0xc
0x000dc5b0:  6360      str     r3, [r4, #4]
0x000dc5b2:  181c      adds    r0, r3, #0
0x000dc5b4:  5043      muls    r0, r2, r0
0x000dc5b6:  fbf7bdfb  bl      #0xd7d34  ; sub_000d7d34
0x000dc5ba:  0836      adds    r6, #8
0x000dc5bc:  3368      ldr     r3, [r6]
0x000dc5be:  2061      str     r0, [r4, #0x10]
0x000dc5c0:  1434      adds    r4, #0x14
0x000dc5c2:  002b      cmp     r3, #0
0x000dc5c4:  efd1      bne     #0xdc5a6
0x000dc5c6:  3b68      ldr     r3, [r7]
0x000dc5c8:  3c1c      adds    r4, r7, #0
0x000dc5ca:  002b      cmp     r3, #0
0x000dc5cc:  22d0      beq     #0xdc614
0x000dc5ce:  181c      adds    r0, r3, #0
0x000dc5d0:  6368      ldr     r3, [r4, #4]
0x000dc5d2:  1f1c      adds    r7, r3, #0
0x000dc5d4:  4743      muls    r7, r0, r7
0x000dc5d6:  381c      adds    r0, r7, #0
0x000dc5d8:  fbf7acfb  bl      #0xd7d34  ; sub_000d7d34
0x000dc5dc:  3a04      lsls    r2, r7, #0x10
0x000dc5de:  120c      lsrs    r2, r2, #0x10
0x000dc5e0:  0021      movs    r1, #0
0x000dc5e2:  051c      adds    r5, r0, #0
0x000dc5e4:  fbf75efd  bl      #0xd80a4  ; sub_000d80a4
0x000dc5e8:  6368      ldr     r3, [r4, #4]
0x000dc5ea:  e560      str     r5, [r4, #0xc]
0x000dc5ec:  2269      ldr     r2, [r4, #0x10]
0x000dc5ee:  002b      cmp     r3, #0
0x000dc5f0:  0bdd      ble     #0xdc60a
0x000dc5f2:  0026      movs    r6, #0
0x000dc5f4:  0020      movs    r0, #0
0x000dc5f6:  191c      adds    r1, r3, #0
0x000dc5f8:  9060      str     r0, [r2, #8]
0x000dc5fa:  2368      ldr     r3, [r4]
0x000dc5fc:  0139      subs    r1, #1
0x000dc5fe:  5560      str     r5, [r2, #4]
0x000dc600:  1680      strh    r6, [r2]
0x000dc602:  ed18      adds    r5, r5, r3
0x000dc604:  0c32      adds    r2, #0xc
0x000dc606:  0029      cmp     r1, #0
0x000dc608:  f6d1      bne     #0xdc5f8
0x000dc60a:  1434      adds    r4, #0x14
0x000dc60c:  2068      ldr     r0, [r4]
0x000dc60e:  b844      add     r8, r7
0x000dc610:  0028      cmp     r0, #0
0x000dc612:  ddd1      bne     #0xdc5d0
0x000dc614:  e560      str     r5, [r4, #0xc]
0x000dc616:  4146      mov     r1, r8
0x000dc618:  0348      ldr     r0, [pc, #0xc]  ; &"?POOL:Use heap [%ld]"
0x000dc61a:  fcf773fc  bl      #0xd8f04  ; sub_000d8f04
0x000dc61e:  08bc      pop     {r3}
0x000dc620:  9846      mov     r8, r3
0x000dc622:  f0bc      pop     {r4, r5, r6, r7}
0x000dc624:  01bc      pop     {r0}
0x000dc626:  0047      bx      r0
0x000dc628:  d884      strh    r0, [r3, #0x26]
0x000dc62a:  1100      movs    r1, r2
0x000dc62c:  00b5      push    {lr}
0x000dc62e:  011c      adds    r1, r0, #0
0x000dc630:  0248      ldr     r0, [pc, #8]
0x000dc632:  fff73bff  bl      #0xdc4ac  ; sub_000dc4ac
0x000dc636:  01bc      pop     {r0}
0x000dc638:  0047      bx      r0
0x000dc63a:  0000      movs    r0, r0

===== sub_000dca78 @ 0x000dca78 =====
0x000dca78:  7847      bx      pc
0x000dca7a:  c046      mov     r8, r8
0x000dca7c:  73fdffea  ldc2l   p10, c14, [r3, #-0x3fc]!
0x000dca80:  7847      bx      pc
0x000dca82:  c046      mov     r8, r8

===== sub_000dca80 @ 0x000dca80 =====
0x000dca80:  7847      bx      pc
0x000dca82:  c046      mov     r8, r8

===== sub_000dca88 @ 0x000dca88 =====
0x000dca88:  7847      bx      pc
0x000dca8a:  c046      mov     r8, r8
0x000dca8c:  c1ebffea  rsb     sl, r1, pc, ror #27
0x000dca90:  7847      bx      pc
0x000dca92:  c046      mov     r8, r8
0x000dca94:  c5ebffea  rsb     sl, r5, pc, ror #27
0x000dca98:  7847      bx      pc
0x000dca9a:  c046      mov     r8, r8

===== sub_000dca90 @ 0x000dca90 =====
0x000dca90:  7847      bx      pc
0x000dca92:  c046      mov     r8, r8
0x000dca94:  c5ebffea  rsb     sl, r5, pc, ror #27
0x000dca98:  7847      bx      pc
0x000dca9a:  c046      mov     r8, r8

===== sub_000dcaa0 @ 0x000dcaa0 =====
0x000dcaa0:  7847      bx      pc
0x000dcaa2:  c046      mov     r8, r8
