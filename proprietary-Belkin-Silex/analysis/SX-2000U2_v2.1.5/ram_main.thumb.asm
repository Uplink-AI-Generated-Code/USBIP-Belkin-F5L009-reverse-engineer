; SX-2000U2 RAM image, main() @ 0x0008b8d8 (THUMB)

0x0008b8d8:  00b5      push    {lr}
0x0008b8da:  81b0      sub     sp, #4
0x0008b8dc:  fdf73cf8  bl      #0x88958
0x0008b8e0:  4bf000fe  bl      #0xd74e4
0x0008b8e4:  fdf75cf8  bl      #0x889a0
0x0008b8e8:  2348      ldr     r0, [pc, #0x8c]
0x0008b8ea:  4bf065fd  bl      #0xd73b8
0x0008b8ee:  0a20      movs    r0, #0xa
0x0008b8f0:  4bf0c8fe  bl      #0xd7684
0x0008b8f4:  214b      ldr     r3, [pc, #0x84]
0x0008b8f6:  2249      ldr     r1, [pc, #0x88]
0x0008b8f8:  181c      adds    r0, r3, #0
0x0008b8fa:  c91a      subs    r1, r1, r3
0x0008b8fc:  4cf016fb  bl      #0xd7f2c
0x0008b900:  1d48      ldr     r0, [pc, #0x74]
0x0008b902:  fcf7f7ff  bl      #0x888f4
0x0008b906:  0020      movs    r0, #0
0x0008b908:  fdf7baf8  bl      #0x88a80
0x0008b90c:  1d4b      ldr     r3, [pc, #0x74]
0x0008b90e:  1860      str     r0, [r3]
0x0008b910:  8020      movs    r0, #0x80
0x0008b912:  c001      lsls    r0, r0, #7
0x0008b914:  4cf00efa  bl      #0xd7d34
0x0008b918:  0028      cmp     r0, #0
0x0008b91a:  2ad0      beq     #0x8b972
0x0008b91c:  8021      movs    r1, #0x80
0x0008b91e:  c901      lsls    r1, r1, #7
0x0008b920:  4cf088fc  bl      #0xd8234
0x0008b924:  0420      movs    r0, #4
0x0008b926:  4cf0b7fc  bl      #0xd8298
0x0008b92a:  0120      movs    r0, #1
0x0008b92c:  4cf090fc  bl      #0xd8250
0x0008b930:  1548      ldr     r0, [pc, #0x54]
0x0008b932:  4cf083fd  bl      #0xd843c
0x0008b936:  11f00dfa  bl      #0x9cd54
0x0008b93a:  104b      ldr     r3, [pc, #0x40]
0x0008b93c:  104a      ldr     r2, [pc, #0x40]
0x0008b93e:  191c      adds    r1, r3, #0
0x0008b940:  d21a      subs    r2, r2, r3
0x0008b942:  1248      ldr     r0, [pc, #0x48]
0x0008b944:  4df0defa  bl      #0xd8f04
0x0008b948:  114b      ldr     r3, [pc, #0x44]
0x0008b94a:  c022      movs    r2, #0xc0
0x0008b94c:  0093      str     r3, [sp]
0x0008b94e:  1148      ldr     r0, [pc, #0x44]
0x0008b950:  1149      ldr     r1, [pc, #0x44]
0x0008b952:  1201      lsls    r2, r2, #4
0x0008b954:  0123      movs    r3, #1
0x0008b956:  fff7c9fd  bl      #0x8b4ec
0x0008b95a:  104b      ldr     r3, [pc, #0x40]
0x0008b95c:  8022      movs    r2, #0x80
0x0008b95e:  0093      str     r3, [sp]
0x0008b960:  0f48      ldr     r0, [pc, #0x3c]
0x0008b962:  1049      ldr     r1, [pc, #0x40]
0x0008b964:  1201      lsls    r2, r2, #4
0x0008b966:  0223      movs    r3, #2
0x0008b968:  fff7c0fd  bl      #0x8b4ec
0x0008b96c:  4bf074fd  bl      #0xd7458
0x0008b970:  fee7      b       #0x8b970
0x0008b972:  0d48      ldr     r0, [pc, #0x34]
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
0x0008b9b2:  41f0abfa  bl      #0xccf0c
0x0008b9b6:  0028      cmp     r0, #0
0x0008b9b8:  02d0      beq     #0x8b9c0
0x0008b9ba:  0068      ldr     r0, [r0]
0x0008b9bc:  02bc      pop     {r1}
0x0008b9be:  0847      bx      r1
0x0008b9c0:  0020      movs    r0, #0
0x0008b9c2:  fbe7      b       #0x8b9bc
0x0008b9c4:  10b5      push    {r4, lr}
0x0008b9c6:  81b0      sub     sp, #4
0x0008b9c8:  fff7f0ff  bl      #0x8b9ac
0x0008b9cc:  041e      subs    r4, r0, #0
0x0008b9ce:  0dd0      beq     #0x8b9ec
0x0008b9d0:  0e4b      ldr     r3, [pc, #0x38]
0x0008b9d2:  0721      movs    r1, #7
0x0008b9d4:  1868      ldr     r0, [r3]
0x0008b9d6:  0130      adds    r0, #1
0x0008b9d8:  0006      lsls    r0, r0, #0x18
0x0008b9da:  000e      lsrs    r0, r0, #0x18
0x0008b9dc:  2cf078fe  bl      #0xb86d0
0x0008b9e0:  0006      lsls    r0, r0, #0x18
0x0008b9e2:  0028      cmp     r0, #0
0x0008b9e4:  06d1      bne     #0x8b9f4
0x0008b9e6:  0a48      ldr     r0, [pc, #0x28]
0x0008b9e8:  4df08cfa  bl      #0xd8f04
0x0008b9ec:  01b0      add     sp, #4
0x0008b9ee:  10bc      pop     {r4}
0x0008b9f0:  01bc      pop     {r0}
0x0008b9f2:  0047      bx      r0
0x0008b9f4:  074b      ldr     r3, [pc, #0x1c]
0x0008b9f6:  201c      adds    r0, r4, #0
0x0008b9f8:  1a68      ldr     r2, [r3]
0x0008b9fa:  074b      ldr     r3, [pc, #0x1c]
0x0008b9fc:  0749      ldr     r1, [pc, #0x1c]
0x0008b9fe:  1b68      ldr     r3, [r3]
0x0008ba00:  0093      str     r3, [sp]
0x0008ba02:  074b      ldr     r3, [pc, #0x1c]
0x0008ba04:  fff7cafa  bl      #0x8af9c
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
0x0008ba26:  fff7edfc  bl      #0x8b404
0x0008ba2a:  02bc      pop     {r1}
0x0008ba2c:  0847      bx      r1
0x0008ba2e:  0000      movs    r0, r0
0x0008ba30:  10b5      push    {r4, lr}
0x0008ba32:  81b0      sub     sp, #4
0x0008ba34:  fff7baff  bl      #0x8b9ac
0x0008ba38:  041e      subs    r4, r0, #0
0x0008ba3a:  0dd0      beq     #0x8ba58
0x0008ba3c:  0e4b      ldr     r3, [pc, #0x38]
0x0008ba3e:  0721      movs    r1, #7
0x0008ba40:  1868      ldr     r0, [r3]
0x0008ba42:  0130      adds    r0, #1
0x0008ba44:  0006      lsls    r0, r0, #0x18
0x0008ba46:  000e      lsrs    r0, r0, #0x18
0x0008ba48:  2cf042fe  bl      #0xb86d0
0x0008ba4c:  0006      lsls    r0, r0, #0x18
0x0008ba4e:  0028      cmp     r0, #0
0x0008ba50:  06d1      bne     #0x8ba60
0x0008ba52:  0a48      ldr     r0, [pc, #0x28]
0x0008ba54:  4df056fa  bl      #0xd8f04
0x0008ba58:  01b0      add     sp, #4
0x0008ba5a:  10bc      pop     {r4}
0x0008ba5c:  01bc      pop     {r0}
0x0008ba5e:  0047      bx      r0
0x0008ba60:  074b      ldr     r3, [pc, #0x1c]
0x0008ba62:  201c      adds    r0, r4, #0
0x0008ba64:  1a68      ldr     r2, [r3]
0x0008ba66:  074b      ldr     r3, [pc, #0x1c]
0x0008ba68:  0749      ldr     r1, [pc, #0x1c]
0x0008ba6a:  1b68      ldr     r3, [r3]
0x0008ba6c:  0093      str     r3, [sp]
0x0008ba6e:  074b      ldr     r3, [pc, #0x1c]
0x0008ba70:  fff782fb  bl      #0x8b178
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
0x0008ba92:  fff7bdfc  bl      #0x8b410
0x0008ba96:  02bc      pop     {r1}
0x0008ba98:  0847      bx      r1
0x0008ba9a:  0000      movs    r0, r0
0x0008ba9c:  10b5      push    {r4, lr}
0x0008ba9e:  81b0      sub     sp, #4
0x0008baa0:  fff784ff  bl      #0x8b9ac
0x0008baa4:  041e      subs    r4, r0, #0
0x0008baa6:  0dd0      beq     #0x8bac4
0x0008baa8:  0f4b      ldr     r3, [pc, #0x3c]
0x0008baaa:  0721      movs    r1, #7
0x0008baac:  1868      ldr     r0, [r3]
0x0008baae:  0130      adds    r0, #1
0x0008bab0:  0006      lsls    r0, r0, #0x18
0x0008bab2:  000e      lsrs    r0, r0, #0x18
0x0008bab4:  2cf00cfe  bl      #0xb86d0
0x0008bab8:  0006      lsls    r0, r0, #0x18
0x0008baba:  0028      cmp     r0, #0
0x0008babc:  08d1      bne     #0x8bad0
0x0008babe:  0b48      ldr     r0, [pc, #0x2c]
0x0008bac0:  4df020fa  bl      #0xd8f04
0x0008bac4:  4cf094fb  bl      #0xd81f0
0x0008bac8:  01b0      add     sp, #4
0x0008baca:  10bc      pop     {r4}
0x0008bacc:  01bc      pop     {r0}
0x0008bace:  0047      bx      r0
0x0008bad0:  074b      ldr     r3, [pc, #0x1c]
0x0008bad2:  201c      adds    r0, r4, #0
0x0008bad4:  1a68      ldr     r2, [r3]
0x0008bad6:  074b      ldr     r3, [pc, #0x1c]
0x0008bad8:  0749      ldr     r1, [pc, #0x1c]
0x0008bada:  1b68      ldr     r3, [r3]
0x0008badc:  0093      str     r3, [sp]
0x0008bade:  074b      ldr     r3, [pc, #0x1c]
0x0008bae0:  fff7f6fb  bl      #0x8b2d0
0x0008bae4:  eee7      b       #0x8bac4
0x0008bae6:  0000      movs    r0, r0
0x0008bae8:  a814      asrs    r0, r5, #0x12
0x0008baea:  0800      movs    r0, r1
0x0008baec:  f081      strh    r0, [r6, #0xe]
0x0008baee:  1000      movs    r0, r2
0x0008baf0:  e47e      ldrb    r4, [r4, #0x1b]
0x0008baf2:  1000      movs    r0, r2
0x0008baf4:  e07e      ldrb    r0, [r4, #0x1b]
0x0008baf6:  1000      movs    r0, r2
0x0008baf8:  88ce      ldm     r6!, {r3, r7}
0x0008bafa:  0d00      movs    r5, r1
0x0008bafc:  70ce      ldm     r6, {r4, r5, r6}
0x0008bafe:  0d00      movs    r5, r1
0x0008bb00:  00b5      push    {lr}
0x0008bb02:  0248      ldr     r0, [pc, #8]
0x0008bb04:  50f074fa  bl      #0xdbff0
0x0008bb08:  02bc      pop     {r1}
0x0008bb0a:  0847      bx      r1
0x0008bb0c:  DCW 0xba9d
0x0008bb0e:  0800      movs    r0, r1
0x0008bb10:  10b5      push    {r4, lr}
0x0008bb12:  104b      ldr     r3, [pc, #0x40]
0x0008bb14:  0022      movs    r2, #0
0x0008bb16:  1a60      str     r2, [r3]
0x0008bb18:  2cf092f9  bl      #0xb7e40
0x0008bb1c:  0e48      ldr     r0, [pc, #0x38]
0x0008bb1e:  4bf07df9  bl      #0xd6e1c
0x0008bb22:  fa20      movs    r0, #0xfa
0x0008bb24:  4000      lsls    r0, r0, #1
0x0008bb26:  4bf0fff9  bl      #0xd6f28
0x0008bb2a:  2ef01ffc  bl      #0xba36c
0x0008bb2e:  12f083fe  bl      #0x9e838
0x0008bb32:  0a4b      ldr     r3, [pc, #0x28]
0x0008bb34:  0a4c      ldr     r4, [pc, #0x28]
0x0008bb36:  0122      movs    r2, #1
0x0008bb38:  1a60      str     r2, [r3]
0x0008bb3a:  201c      adds    r0, r4, #0
0x0008bb3c:  fdf7c8fd  bl      #0x896d0
0x0008bb40:  4af0d8fa  bl      #0xd60f4
0x0008bb44:  11f0d4fa  bl      #0x9d0f0
0x0008bb48:  50f0aaff  bl      #0xdcaa0
0x0008bb4c:  10bc      pop     {r4}
0x0008bb4e:  01bc      pop     {r0}
0x0008bb50:  0047      bx      r0
0x0008bb52:  0000      movs    r0, r0
0x0008bb54:  4408      lsrs    r4, r0, #1
0x0008bb56:  0800      movs    r0, r1
0x0008bb58:  c00b      lsrs    r0, r0, #0xf
0x0008bb5a:  0800      movs    r0, r1
0x0008bb5c:  8000      lsls    r0, r0, #2
0x0008bb5e:  0000      movs    r0, r0
0x0008bb60:  0002      lsls    r0, r0, #8
0x0008bb62:  0201      lsls    r2, r0, #4
0x0008bb64:  00b5      push    {lr}
0x0008bb66:  0248      ldr     r0, [pc, #8]
0x0008bb68:  50f042fa  bl      #0xdbff0
0x0008bb6c:  02bc      pop     {r1}
0x0008bb6e:  0847      bx      r1
0x0008bb70:  11bb      cbnz    r1, #0x8bbb8
0x0008bb72:  0800      movs    r0, r1
0x0008bb74:  00b5      push    {lr}
0x0008bb76:  fef7cbf8  bl      #0x89d10
0x0008bb7a:  01bc      pop     {r0}
0x0008bb7c:  0047      bx      r0
0x0008bb7e:  0000      movs    r0, r0
0x0008bb80:  00b5      push    {lr}
0x0008bb82:  fef7c5f8  bl      #0x89d10
0x0008bb86:  0020      movs    r0, #0
0x0008bb88:  02bc      pop     {r1}
0x0008bb8a:  0847      bx      r1
0x0008bb8c:  30b5      push    {r4, r5, lr}
0x0008bb8e:  0f48      ldr     r0, [pc, #0x3c]
0x0008bb90:  0421      movs    r1, #4
0x0008bb92:  43f043fc  bl      #0xcf41c
0x0008bb96:  06f0bdff  bl      #0x92b14
0x0008bb9a:  0025      movs    r5, #0
0x0008bb9c:  8823      movs    r3, #0x88
0x0008bb9e:  2806      lsls    r0, r5, #0x18
0x0008bba0:  5b05      lsls    r3, r3, #0x15
0x0008bba2:  c018      adds    r0, r0, r3
0x0008bba4:  8423      movs    r3, #0x84
0x0008bba6:  db03      lsls    r3, r3, #0xf
0x0008bba8:  040c      lsrs    r4, r0, #0x10
0x0008bbaa:  4334      adds    r4, #0x43
0x0008bbac:  c018      adds    r0, r0, r3
0x0008bbae:  0121      movs    r1, #1
0x0008bbb0:  000c      lsrs    r0, r0, #0x10
0x0008bbb2:  2404      lsls    r4, r4, #0x10
0x0008bbb4:  44f03afc  bl      #0xd042c
0x0008bbb8:  0135      adds    r5, #1
0x0008bbba:  200c      lsrs    r0, r4, #0x10
0x0008bbbc:  0121      movs    r1, #1
0x0008bbbe:  44f035fc  bl      #0xd042c
0x0008bbc2:  032d      cmp     r5, #3
0x0008bbc4:  eadd      ble     #0x8bb9c
0x0008bbc6:  30bc      pop     {r4, r5}
0x0008bbc8:  01bc      pop     {r0}
0x0008bbca:  0047      bx      r0
0x0008bbcc:  0202      lsls    r2, r0, #8
0x0008bbce:  0000      movs    r0, r0
0x0008bbd0:  7047      bx      lr
0x0008bbd2:  0000      movs    r0, r0
0x0008bbd4:  7047      bx      lr
0x0008bbd6:  0000      movs    r0, r0
0x0008bbd8:  70b5      push    {r4, r5, r6, lr}
0x0008bbda:  0025      movs    r5, #0
0x0008bbdc:  1449      ldr     r1, [pc, #0x50]
0x0008bbde:  0570      strb    r5, [r0]
0x0008bbe0:  041c      adds    r4, r0, #0
0x0008bbe2:  4df035fa  bl      #0xd9050
0x0008bbe6:  1349      ldr     r1, [pc, #0x4c]
0x0008bbe8:  4df032fa  bl      #0xd9050
0x0008bbec:  1249      ldr     r1, [pc, #0x48]
0x0008bbee:  4df02ffa  bl      #0xd9050
0x0008bbf2:  1249      ldr     r1, [pc, #0x48]
0x0008bbf4:  4df02cfa  bl      #0xd9050
0x0008bbf8:  061c      adds    r6, r0, #0
0x0008bbfa:  07f0abf9  bl      #0x92f54
0x0008bbfe:  3018      adds    r0, r6, r0
0x0008bc00:  09f038ff  bl      #0x95a74
0x0008bc04:  8023      movs    r3, #0x80
0x0008bc06:  041b      subs    r4, r0, r4
0x0008bc08:  5b01      lsls    r3, r3, #5
0x0008bc0a:  0570      strb    r5, [r0]
0x0008bc0c:  9c42      cmp     r4, r3
0x0008bc0e:  0cdc      bgt     #0x8bc2a
0x0008bc10:  8023      movs    r3, #0x80
0x0008bc12:  1b01      lsls    r3, r3, #4
0x0008bc14:  9c42      cmp     r4, r3
0x0008bc16:  03dc      bgt     #0x8bc20
0x0008bc18:  201c      adds    r0, r4, #0
0x0008bc1a:  70bc      pop     {r4, r5, r6}
0x0008bc1c:  02bc      pop     {r1}
0x0008bc1e:  0847      bx      r1
0x0008bc20:  0748      ldr     r0, [pc, #0x1c]
0x0008bc22:  211c      adds    r1, r4, #0
0x0008bc24:  4df06ef9  bl      #0xd8f04
0x0008bc28:  f6e7      b       #0x8bc18
0x0008bc2a:  0648      ldr     r0, [pc, #0x18]
0x0008bc2c:  f9e7      b       #0x8bc22
0x0008bc2e:  0000      movs    r0, r0
0x0008bc30:  90f00700  eors    r0, r0, #7
0x0008bc34:  247f      ldrb    r4, [r4, #0x1c]
0x0008bc36:  1000      movs    r0, r2
0x0008bc38:  a8e3      b       #0x8c38c
0x0008bc3a:  0700      movs    r7, r0
0x0008bc3c:  24db      blt     #0x8bc88
0x0008bc3e:  1000      movs    r0, r2
0x0008bc40:  1c82      strh    r4, [r3, #0x10]
0x0008bc42:  1000      movs    r0, r2
0x0008bc44:  4082      strh    r0, [r0, #0x12]
0x0008bc46:  1000      movs    r0, r2
0x0008bc48:  00b5      push    {lr}
0x0008bc4a:  fff7c5ff  bl      #0x8bbd8
0x0008bc4e:  01bc      pop     {r0}
0x0008bc50:  0047      bx      r0
0x0008bc52:  0000      movs    r0, r0
0x0008bc54:  30b5      push    {r4, r5, lr}
0x0008bc56:  2a48      ldr     r0, [pc, #0xa8]
0x0008bc58:  4cf0f0fb  bl      #0xd843c
0x0008bc5c:  4020      movs    r0, #0x40
0x0008bc5e:  41f09bf9  bl      #0xccf98
0x0008bc62:  2848      ldr     r0, [pc, #0xa0]
0x0008bc64:  4cf0eafb  bl      #0xd843c
0x0008bc68:  41f024fb  bl      #0xcd2b4
0x0008bc6c:  2648      ldr     r0, [pc, #0x98]
0x0008bc6e:  4cf0e5fb  bl      #0xd843c
0x0008bc72:  0020      movs    r0, #0
0x0008bc74:  0021      movs    r1, #0
0x0008bc76:  41f0adfa  bl      #0xcd1d4
0x0008bc7a:  041e      subs    r4, r0, #0
0x0008bc7c:  27d0      beq     #0x8bcce
0x0008bc7e:  5b20      movs    r0, #0x5b
0x0008bc80:  4cf096fb  bl      #0xd83b0
0x0008bc84:  2068      ldr     r0, [r4]
0x0008bc86:  4cf0d9fb  bl      #0xd843c
0x0008bc8a:  5d20      movs    r0, #0x5d
0x0008bc8c:  4cf090fb  bl      #0xd83b0
0x0008bc90:  0020      movs    r0, #0
0x0008bc92:  2168      ldr     r1, [r4]
0x0008bc94:  41f03af9  bl      #0xccf0c
0x0008bc98:  051e      subs    r5, r0, #0
0x0008bc9a:  10d0      beq     #0x8bcbe
0x0008bc9c:  3c20      movs    r0, #0x3c
0x0008bc9e:  4cf087fb  bl      #0xd83b0
0x0008bca2:  2868      ldr     r0, [r5]
0x0008bca4:  4cf0cafb  bl      #0xd843c
0x0008bca8:  3e20      movs    r0, #0x3e
0x0008bcaa:  4cf081fb  bl      #0xd83b0
0x0008bcae:  201c      adds    r0, r4, #0
0x0008bcb0:  291c      adds    r1, r5, #0
0x0008bcb2:  164a      ldr     r2, [pc, #0x58]
0x0008bcb4:  41f062fb  bl      #0xcd37c
0x0008bcb8:  201c      adds    r0, r4, #0
0x0008bcba:  10f0f1ff  bl      #0x9cca0
0x0008bcbe:  4cf0a7fb  bl      #0xd8410
0x0008bcc2:  201c      adds    r0, r4, #0
0x0008bcc4:  0021      movs    r1, #0
0x0008bcc6:  41f085fa  bl      #0xcd1d4
0x0008bcca:  041e      subs    r4, r0, #0
0x0008bccc:  d7d1      bne     #0x8bc7e
0x0008bcce:  4cf09ffb  bl      #0xd8410
0x0008bcd2:  0020      movs    r0, #0
0x0008bcd4:  0021      movs    r1, #0
0x0008bcd6:  0022      movs    r2, #0
0x0008bcd8:  1bf012fa  bl      #0xa7100
0x0008bcdc:  041e      subs    r4, r0, #0
0x0008bcde:  09d0      beq     #0x8bcf4
0x0008bce0:  201c      adds    r0, r4, #0
0x0008bce2:  01f03dfb  bl      #0x8d360
0x0008bce6:  201c      adds    r0, r4, #0
0x0008bce8:  0021      movs    r1, #0
0x0008bcea:  0022      movs    r2, #0
0x0008bcec:  1bf008fa  bl      #0xa7100
0x0008bcf0:  041e      subs    r4, r0, #0
0x0008bcf2:  f5d1      bne     #0x8bce0
0x0008bcf4:  01f008ff  bl      #0x8db08
0x0008bcf8:  30bc      pop     {r4, r5}
0x0008bcfa:  01bc      pop     {r0}
0x0008bcfc:  0047      bx      r0
0x0008bcfe:  0000      movs    r0, r0
0x0008bd00:  6482      strh    r4, [r4, #0x12]
0x0008bd02:  1000      movs    r0, r2
0x0008bd04:  6c82      strh    r4, [r5, #0x12]
0x0008bd06:  1000      movs    r0, r2
0x0008bd08:  7482      strh    r4, [r6, #0x12]
0x0008bd0a:  1000      movs    r0, r2
0x0008bd0c:  59d4      bmi     #0x8bdc2
0x0008bd0e:  0c00      movs    r4, r1
0x0008bd10:  00b5      push    {lr}
0x0008bd12:  0a20      movs    r0, #0xa
0x0008bd14:  fdf720fc  bl      #0x89558
0x0008bd18:  50f09cfc  bl      #0xdc654
0x0008bd1c:  fef7dafe  bl      #0x8aad4
0x0008bd20:  01bc      pop     {r0}
0x0008bd22:  0047      bx      r0
0x0008bd24:  00b5      push    {lr}
0x0008bd26:  7821      movs    r1, #0x78
0x0008bd28:  0448      ldr     r0, [pc, #0x10]
0x0008bd2a:  fff703fc  bl      #0x8b534
0x0008bd2e:  09f0edfe  bl      #0x95b0c
0x0008bd32:  0af0a5f9  bl      #0x96080
0x0008bd36:  01bc      pop     {r0}
0x0008bd38:  0047      bx      r0
0x0008bd3a:  0000      movs    r0, r0
0x0008bd3c:  54cf      ldm     r7!, {r2, r4, r6}
0x0008bd3e:  0d00      movs    r5, r1
0x0008bd40:  00b5      push    {lr}
0x0008bd42:  4af0b3f9  bl      #0xd60ac
0x0008bd46:  4bf08ffc  bl      #0xd7668
0x0008bd4a:  c923      movs    r3, #0xc9
0x0008bd4c:  c386      strh    r3, [r0, #0x36]
0x0008bd4e:  4af0bbf9  bl      #0xd60c8
0x0008bd52:  50f05df9  bl      #0xdc010
0x0008bd56:  01bc      pop     {r0}
0x0008bd58:  0047      bx      r0
0x0008bd5a:  c046      mov     r8, r8
0x0008bd5c:  0120      movs    r0, #1
0x0008bd5e:  4042      rsbs    r0, r0, #0
0x0008bd60:  7047      bx      lr
0x0008bd62:  0000      movs    r0, r0
0x0008bd64:  f0b5      push    {r4, r5, r6, r7, lr}
0x0008bd66:  5746      mov     r7, sl
0x0008bd68:  4e46      mov     r6, sb
0x0008bd6a:  4546      mov     r5, r8
0x0008bd6c:  e0b4      push    {r5, r6, r7}
0x0008bd6e:  0025      movs    r5, #0
0x0008bd70:  071c      adds    r7, r0, #0
0x0008bd72:  8046      mov     r8, r0
0x0008bd74:  a946      mov     sb, r5
0x0008bd76:  0026      movs    r6, #0
0x0008bd78:  0137      adds    r7, #1
0x0008bd7a:  8246      mov     sl, r0
0x0008bd7c:  281c      adds    r0, r5, #0
0x0008bd7e:  0021      movs    r1, #0
0x0008bd80:  41f0c4f8  bl      #0xccf0c
0x0008bd84:  051e      subs    r5, r0, #0
0x0008bd86:  40d0      beq     #0x8be0a
0x0008bd88:  301c      adds    r0, r6, #0
0x0008bd8a:  0021      movs    r1, #0
0x0008bd8c:  1bf01afa  bl      #0xa71c4
0x0008bd90:  061e      subs    r6, r0, #0
0x0008bd92:  3ad0      beq     #0x8be0a
0x0008bd94:  2968      ldr     r1, [r5]
0x0008bd96:  0b78      ldrb    r3, [r1]
0x0008bd98:  402b      cmp     r3, #0x40
0x0008bd9a:  efd0      beq     #0x8bd7c
0x0008bd9c:  7068      ldr     r0, [r6, #4]
0x0008bd9e:  4df0adf9  bl      #0xd90fc
0x0008bda2:  0028      cmp     r0, #0
0x0008bda4:  ead1      bne     #0x8bd7c
0x0008bda6:  3068      ldr     r0, [r6]
0x0008bda8:  1d49      ldr     r1, [pc, #0x74]
0x0008bdaa:  4df0a7f9  bl      #0xd90fc
0x0008bdae:  0028      cmp     r0, #0
0x0008bdb0:  e4d0      beq     #0x8bd7c
0x0008bdb2:  2022      movs    r2, #0x20
0x0008bdb4:  381c      adds    r0, r7, #0
0x0008bdb6:  0021      movs    r1, #0
0x0008bdb8:  4cf074f9  bl      #0xd80a4
0x0008bdbc:  2968      ldr     r1, [r5]
0x0008bdbe:  381c      adds    r0, r7, #0
0x0008bdc0:  4df046f9  bl      #0xd9050
0x0008bdc4:  471c      adds    r7, r0, #1
0x0008bdc6:  2968      ldr     r1, [r5]
0x0008bdc8:  381c      adds    r0, r7, #0
0x0008bdca:  01f00bfb  bl      #0x8d3e4
0x0008bdce:  381c      adds    r0, r7, #0
0x0008bdd0:  1bf006fa  bl      #0xa71e0
0x0008bdd4:  0404      lsls    r4, r0, #0x10
0x0008bdd6:  381c      adds    r0, r7, #0
0x0008bdd8:  4cf024fb  bl      #0xd8424
0x0008bddc:  240c      lsrs    r4, r4, #0x10
0x0008bdde:  c019      adds    r0, r0, r7
0x0008bde0:  471c      adds    r7, r0, #1
0x0008bde2:  201c      adds    r0, r4, #0
0x0008bde4:  4cf0cef9  bl      #0xd8184
0x0008bde8:  0104      lsls    r1, r0, #0x10
0x0008bdea:  090c      lsrs    r1, r1, #0x10
0x0008bdec:  381c      adds    r0, r7, #0
0x0008bdee:  4cf0e1f9  bl      #0xd81b4
0x0008bdf2:  2023      movs    r3, #0x20
0x0008bdf4:  9a44      add     sl, r3
0x0008bdf6:  0122      movs    r2, #1
0x0008bdf8:  5746      mov     r7, sl
0x0008bdfa:  281c      adds    r0, r5, #0
0x0008bdfc:  0021      movs    r1, #0
0x0008bdfe:  9144      add     sb, r2
0x0008be00:  0137      adds    r7, #1
0x0008be02:  41f083f8  bl      #0xccf0c
0x0008be06:  051e      subs    r5, r0, #0
0x0008be08:  bed1      bne     #0x8bd88
0x0008be0a:  4246      mov     r2, r8
0x0008be0c:  4b46      mov     r3, sb
0x0008be0e:  b81a      subs    r0, r7, r2
0x0008be10:  1370      strb    r3, [r2]
0x0008be12:  38bc      pop     {r3, r4, r5}
0x0008be14:  9846      mov     r8, r3
0x0008be16:  a146      mov     sb, r4
0x0008be18:  aa46      mov     sl, r5
0x0008be1a:  f0bc      pop     {r4, r5, r6, r7}
0x0008be1c:  02bc      pop     {r1}
0x0008be1e:  0847      bx      r1
0x0008be20:  8482      strh    r4, [r0, #0x14]
0x0008be22:  1000      movs    r0, r2
0x0008be24:  0020      movs    r0, #0
0x0008be26:  7047      bx      lr
0x0008be28:  10b5      push    {r4, lr}
0x0008be2a:  041c      adds    r4, r0, #0
0x0008be2c:  2078      ldrb    r0, [r4]
0x0008be2e:  0006      lsls    r0, r0, #0x18
0x0008be30:  0028      cmp     r0, #0
0x0008be32:  09d0      beq     #0x8be48
0x0008be34:  000e      lsrs    r0, r0, #0x18
0x0008be36:  4df033f9  bl      #0xd90a0
0x0008be3a:  0128      cmp     r0, #1
0x0008be3c:  08d1      bne     #0x8be50
0x0008be3e:  0134      adds    r4, #1
0x0008be40:  2078      ldrb    r0, [r4]
0x0008be42:  0006      lsls    r0, r0, #0x18
0x0008be44:  0028      cmp     r0, #0
0x0008be46:  f5d1      bne     #0x8be34
0x0008be48:  0120      movs    r0, #1
0x0008be4a:  10bc      pop     {r4}
0x0008be4c:  02bc      pop     {r1}
0x0008be4e:  0847      bx      r1
0x0008be50:  0020      movs    r0, #0
0x0008be52:  fae7      b       #0x8be4a
0x0008be54:  30b5      push    {r4, r5, lr}
0x0008be56:  8a23      movs    r3, #0x8a
0x0008be58:  5b00      lsls    r3, r3, #1
0x0008be5a:  c018      adds    r0, r0, r3
0x0008be5c:  0068      ldr     r0, [r0]
0x0008be5e:  0906      lsls    r1, r1, #0x18
0x0008be60:  0d0e      lsrs    r5, r1, #0x18
0x0008be62:  0028      cmp     r0, #0
0x0008be64:  11d0      beq     #0x8be8a
0x0008be66:  0379      ldrb    r3, [r0, #4]
0x0008be68:  0022      movs    r2, #0
0x0008be6a:  002b      cmp     r3, #0
0x0008be6c:  0ddd      ble     #0x8be8a
0x0008be6e:  c168      ldr     r1, [r0, #0xc]
0x0008be70:  1c1c      adds    r4, r3, #0
0x0008be72:  01c9      ldm     r1!, {r0}
0x0008be74:  031c      adds    r3, r0, #0
0x0008be76:  8033      adds    r3, #0x80
0x0008be78:  1b78      ldrb    r3, [r3]
0x0008be7a:  9b00      lsls    r3, r3, #2
0x0008be7c:  1b58      ldr     r3, [r3, r0]
0x0008be7e:  5b79      ldrb    r3, [r3, #5]
0x0008be80:  ab42      cmp     r3, r5
0x0008be82:  03d0      beq     #0x8be8c
0x0008be84:  0132      adds    r2, #1
0x0008be86:  9442      cmp     r4, r2
0x0008be88:  f3dc      bgt     #0x8be72
0x0008be8a:  0020      movs    r0, #0
0x0008be8c:  30bc      pop     {r4, r5}
0x0008be8e:  02bc      pop     {r1}
0x0008be90:  0847      bx      r1
0x0008be92:  c046      mov     r8, r8
0x0008be94:  f0b5      push    {r4, r5, r6, r7, lr}
0x0008be96:  1204      lsls    r2, r2, #0x10
0x0008be98:  120c      lsrs    r2, r2, #0x10
0x0008be9a:  0023      movs    r3, #0
0x0008be9c:  013a      subs    r2, #1
0x0008be9e:  051c      adds    r5, r0, #0
0x0008bea0:  9c46      mov     ip, r3
0x0008bea2:  0024      movs    r4, #0
0x0008bea4:  012a      cmp     r2, #1
0x0008bea6:  1cd8      bhi     #0x8bee2
0x0008bea8:  144e      ldr     r6, [pc, #0x50]
0x0008beaa:  154f      ldr     r7, [pc, #0x54]
0x0008beac:  0020      movs    r0, #0
0x0008beae:  0021      movs    r1, #0
0x0008beb0:  8a59      ldr     r2, [r1, r6]
0x0008beb2:  002a      cmp     r2, #0
0x0008beb4:  02d1      bne     #0x8bebc
0x0008beb6:  cb59      ldr     r3, [r1, r7]
0x0008beb8:  002b      cmp     r3, #0
0x0008beba:  05d0      beq     #0x8bec8
0x0008bebc:  0134      adds    r4, #1
0x0008bebe:  aa42      cmp     r2, r5
0x0008bec0:  02d8      bhi     #0x8bec8
0x0008bec2:  cb59      ldr     r3, [r1, r7]
0x0008bec4:  ab42      cmp     r3, r5
0x0008bec6:  16d2      bhs     #0x8bef6
0x0008bec8:  0130      adds    r0, #1
0x0008beca:  0431      adds    r1, #4
0x0008becc:  0328      cmp     r0, #3
0x0008bece:  efdd      ble     #0x8beb0
0x0008bed0:  002c      cmp     r4, #0
0x0008bed2:  06dd      ble     #0x8bee2
0x0008bed4:  6346      mov     r3, ip
0x0008bed6:  002b      cmp     r3, #0
