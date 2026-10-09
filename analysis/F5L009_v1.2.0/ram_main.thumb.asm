; Reconstructed RAM image, main() @ 0x002f959c (THUMB), first 0x600 bytes
; load ram_reconstructed.bin at base 0x00000000 in a disassembler

0x002f959c:  00b5      push    {lr}
0x002f959e:  81b0      sub     sp, #4
0x002f95a0:  fdf732f9  bl      #0x2f6808
0x002f95a4:  3cf020f8  bl      #0x3355e8
0x002f95a8:  fdf752f9  bl      #0x2f6850
0x002f95ac:  2348      ldr     r0, [pc, #0x8c]
0x002f95ae:  3bf089ff  bl      #0x3354c4
0x002f95b2:  0a20      movs    r0, #0xa
0x002f95b4:  3cf0e8f8  bl      #0x335788
0x002f95b8:  214b      ldr     r3, [pc, #0x84]
0x002f95ba:  2249      ldr     r1, [pc, #0x88]
0x002f95bc:  181c      adds    r0, r3, #0
0x002f95be:  c91a      subs    r1, r1, r3
0x002f95c0:  3cf052fd  bl      #0x336068
0x002f95c4:  1d48      ldr     r0, [pc, #0x74]
0x002f95c6:  fdf7edf8  bl      #0x2f67a4
0x002f95ca:  0020      movs    r0, #0
0x002f95cc:  fdf7b0f9  bl      #0x2f6930
0x002f95d0:  1d4b      ldr     r3, [pc, #0x74]
0x002f95d2:  1860      str     r0, [r3]
0x002f95d4:  8020      movs    r0, #0x80
0x002f95d6:  c001      lsls    r0, r0, #7
0x002f95d8:  3cf04afc  bl      #0x335e70
0x002f95dc:  0028      cmp     r0, #0
0x002f95de:  2ad0      beq     #0x2f9636
0x002f95e0:  8021      movs    r1, #0x80
0x002f95e2:  c901      lsls    r1, r1, #7
0x002f95e4:  3cf0aafe  bl      #0x33633c
0x002f95e8:  0420      movs    r0, #4
0x002f95ea:  3cf0d9fe  bl      #0x3363a0
0x002f95ee:  0120      movs    r0, #1
0x002f95f0:  3cf0b2fe  bl      #0x336358
0x002f95f4:  1548      ldr     r0, [pc, #0x54]
0x002f95f6:  3cf0a5ff  bl      #0x336544
0x002f95fa:  0ff05ff8  bl      #0x3086bc
0x002f95fe:  104b      ldr     r3, [pc, #0x40]
0x002f9600:  104a      ldr     r2, [pc, #0x40]
0x002f9602:  191c      adds    r1, r3, #0
0x002f9604:  d21a      subs    r2, r2, r3
0x002f9606:  1248      ldr     r0, [pc, #0x48]
0x002f9608:  3df08cfc  bl      #0x336f24
0x002f960c:  114b      ldr     r3, [pc, #0x44]
0x002f960e:  c022      movs    r2, #0xc0
0x002f9610:  0093      str     r3, [sp]
0x002f9612:  1148      ldr     r0, [pc, #0x44]
0x002f9614:  1149      ldr     r1, [pc, #0x44]
0x002f9616:  1201      lsls    r2, r2, #4
0x002f9618:  0123      movs    r3, #1
0x002f961a:  fff7c9fd  bl      #0x2f91b0
0x002f961e:  104b      ldr     r3, [pc, #0x40]
0x002f9620:  8022      movs    r2, #0x80
0x002f9622:  0093      str     r3, [sp]
0x002f9624:  0f48      ldr     r0, [pc, #0x3c]
0x002f9626:  1049      ldr     r1, [pc, #0x40]
0x002f9628:  1201      lsls    r2, r2, #4
0x002f962a:  0223      movs    r3, #2
0x002f962c:  fff7c0fd  bl      #0x2f91b0
0x002f9630:  3bf098ff  bl      #0x335564
0x002f9634:  fee7      b       #0x2f9634
0x002f9636:  0d48      ldr     r0, [pc, #0x34]
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
0x002f9670:  0048      ldr     r0, [pc, #0]
0x002f9672:  7047      bx      lr
0x002f9674:  c4a4      adr     r4, #0x310
0x002f9676:  3300      movs    r3, r6
0x002f9678:  10b5      push    {r4, lr}
0x002f967a:  81b0      sub     sp, #4
0x002f967c:  fff7f8ff  bl      #0x2f9670
0x002f9680:  041e      subs    r4, r0, #0
0x002f9682:  0ed0      beq     #0x2f96a2
0x002f9684:  114b      ldr     r3, [pc, #0x44]
0x002f9686:  0721      movs    r1, #7
0x002f9688:  1868      ldr     r0, [r3]
0x002f968a:  0130      adds    r0, #1
0x002f968c:  0006      lsls    r0, r0, #0x18
0x002f968e:  000e      lsrs    r0, r0, #0x18
0x002f9690:  24f0a4ff  bl      #0x31e5dc
0x002f9694:  0006      lsls    r0, r0, #0x18
0x002f9696:  000e      lsrs    r0, r0, #0x18
0x002f9698:  0028      cmp     r0, #0
0x002f969a:  06d1      bne     #0x2f96aa
0x002f969c:  0c48      ldr     r0, [pc, #0x30]
0x002f969e:  3df041fc  bl      #0x336f24
0x002f96a2:  01b0      add     sp, #4
0x002f96a4:  10bc      pop     {r4}
0x002f96a6:  01bc      pop     {r0}
0x002f96a8:  0047      bx      r0
0x002f96aa:  0221      movs    r1, #2
0x002f96ac:  0af070fc  bl      #0x303f90
0x002f96b0:  0028      cmp     r0, #0
0x002f96b2:  f3d1      bne     #0x2f969c
0x002f96b4:  074b      ldr     r3, [pc, #0x1c]
0x002f96b6:  201c      adds    r0, r4, #0
0x002f96b8:  1a68      ldr     r2, [r3]
0x002f96ba:  074b      ldr     r3, [pc, #0x1c]
0x002f96bc:  0749      ldr     r1, [pc, #0x1c]
0x002f96be:  1b68      ldr     r3, [r3]
0x002f96c0:  0093      str     r3, [sp]
0x002f96c2:  074b      ldr     r3, [pc, #0x1c]
0x002f96c4:  fff75efa  bl      #0x2f8b84
0x002f96c8:  ebe7      b       #0x2f96a2
0x002f96ca:  0000      movs    r0, r0
0x002f96cc:  88ff2e00  vaddl.u8 q0, d8, d30
0x002f96d0:  5466      str     r4, [r2, #0x64]
0x002f96d2:  3600      movs    r6, r6
0x002f96d4:  e463      str     r4, [r4, #0x3c]
0x002f96d6:  3600      movs    r6, r6
0x002f96d8:  e063      str     r0, [r4, #0x3c]
0x002f96da:  3600      movs    r6, r6
0x002f96dc:  94a3      adr     r3, #0x250
0x002f96de:  3300      movs    r3, r6
0x002f96e0:  7ca3      adr     r3, #0x1f0
0x002f96e2:  3300      movs    r3, r6
0x002f96e4:  00b5      push    {lr}
0x002f96e6:  fff755fc  bl      #0x2f8f94
0x002f96ea:  02bc      pop     {r1}
0x002f96ec:  0847      bx      r1
0x002f96ee:  0000      movs    r0, r0
0x002f96f0:  10b5      push    {r4, lr}
0x002f96f2:  81b0      sub     sp, #4
0x002f96f4:  fff7bcff  bl      #0x2f9670
0x002f96f8:  041e      subs    r4, r0, #0
0x002f96fa:  0ed0      beq     #0x2f971a
0x002f96fc:  114b      ldr     r3, [pc, #0x44]
0x002f96fe:  0721      movs    r1, #7
0x002f9700:  1868      ldr     r0, [r3]
0x002f9702:  0130      adds    r0, #1
0x002f9704:  0006      lsls    r0, r0, #0x18
0x002f9706:  000e      lsrs    r0, r0, #0x18
0x002f9708:  24f068ff  bl      #0x31e5dc
0x002f970c:  0006      lsls    r0, r0, #0x18
0x002f970e:  000e      lsrs    r0, r0, #0x18
0x002f9710:  0028      cmp     r0, #0
0x002f9712:  06d1      bne     #0x2f9722
0x002f9714:  0c48      ldr     r0, [pc, #0x30]
0x002f9716:  3df005fc  bl      #0x336f24
0x002f971a:  01b0      add     sp, #4
0x002f971c:  10bc      pop     {r4}
0x002f971e:  01bc      pop     {r0}
0x002f9720:  0047      bx      r0
0x002f9722:  0221      movs    r1, #2
0x002f9724:  0af034fc  bl      #0x303f90
0x002f9728:  0028      cmp     r0, #0
0x002f972a:  f3d1      bne     #0x2f9714
0x002f972c:  074b      ldr     r3, [pc, #0x1c]
0x002f972e:  201c      adds    r0, r4, #0
0x002f9730:  1a68      ldr     r2, [r3]
0x002f9732:  074b      ldr     r3, [pc, #0x1c]
0x002f9734:  0749      ldr     r1, [pc, #0x1c]
0x002f9736:  1b68      ldr     r3, [r3]
0x002f9738:  0093      str     r3, [sp]
0x002f973a:  074b      ldr     r3, [pc, #0x1c]
0x002f973c:  fff710fb  bl      #0x2f8d60
0x002f9740:  ebe7      b       #0x2f971a
0x002f9742:  0000      movs    r0, r0
0x002f9744:  88ff2e00  vaddl.u8 q0, d8, d30
0x002f9748:  8466      str     r4, [r0, #0x68]
0x002f974a:  3600      movs    r6, r6
0x002f974c:  e463      str     r4, [r4, #0x3c]
0x002f974e:  3600      movs    r6, r6
0x002f9750:  e063      str     r0, [r4, #0x3c]
0x002f9752:  3600      movs    r6, r6
0x002f9754:  94a3      adr     r3, #0x250
0x002f9756:  3300      movs    r3, r6
0x002f9758:  7ca3      adr     r3, #0x1f0
0x002f975a:  3300      movs    r3, r6
0x002f975c:  00b5      push    {lr}
0x002f975e:  fff72ffc  bl      #0x2f8fc0
0x002f9762:  02bc      pop     {r1}
0x002f9764:  0847      bx      r1
0x002f9766:  0000      movs    r0, r0
0x002f9768:  10b5      push    {r4, lr}
0x002f976a:  81b0      sub     sp, #4
0x002f976c:  fff780ff  bl      #0x2f9670
0x002f9770:  041e      subs    r4, r0, #0
0x002f9772:  0ed0      beq     #0x2f9792
0x002f9774:  124b      ldr     r3, [pc, #0x48]
0x002f9776:  0721      movs    r1, #7
0x002f9778:  1868      ldr     r0, [r3]
0x002f977a:  0130      adds    r0, #1
0x002f977c:  0006      lsls    r0, r0, #0x18
0x002f977e:  000e      lsrs    r0, r0, #0x18
0x002f9780:  24f02cff  bl      #0x31e5dc
0x002f9784:  0006      lsls    r0, r0, #0x18
0x002f9786:  000e      lsrs    r0, r0, #0x18
0x002f9788:  0028      cmp     r0, #0
0x002f978a:  08d1      bne     #0x2f979e
0x002f978c:  0d48      ldr     r0, [pc, #0x34]
0x002f978e:  3df0c9fb  bl      #0x336f24
0x002f9792:  3cf0b1fd  bl      #0x3362f8
0x002f9796:  01b0      add     sp, #4
0x002f9798:  10bc      pop     {r4}
0x002f979a:  01bc      pop     {r0}
0x002f979c:  0047      bx      r0
0x002f979e:  0221      movs    r1, #2
0x002f97a0:  0af0f6fb  bl      #0x303f90
0x002f97a4:  0028      cmp     r0, #0
0x002f97a6:  f1d1      bne     #0x2f978c
0x002f97a8:  074b      ldr     r3, [pc, #0x1c]
0x002f97aa:  201c      adds    r0, r4, #0
0x002f97ac:  1a68      ldr     r2, [r3]
0x002f97ae:  074b      ldr     r3, [pc, #0x1c]
0x002f97b0:  0749      ldr     r1, [pc, #0x1c]
0x002f97b2:  1b68      ldr     r3, [r3]
0x002f97b4:  0093      str     r3, [sp]
0x002f97b6:  074b      ldr     r3, [pc, #0x1c]
0x002f97b8:  fff77efb  bl      #0x2f8eb8
0x002f97bc:  e9e7      b       #0x2f9792
0x002f97be:  0000      movs    r0, r0
0x002f97c0:  88ff2e00  vaddl.u8 q0, d8, d30
0x002f97c4:  b066      str     r0, [r6, #0x68]
0x002f97c6:  3600      movs    r6, r6
0x002f97c8:  e463      str     r4, [r4, #0x3c]
0x002f97ca:  3600      movs    r6, r6
0x002f97cc:  e063      str     r0, [r4, #0x3c]
0x002f97ce:  3600      movs    r6, r6
0x002f97d0:  94a3      adr     r3, #0x250
0x002f97d2:  3300      movs    r3, r6
0x002f97d4:  7ca3      adr     r3, #0x1f0
0x002f97d6:  3300      movs    r3, r6
0x002f97d8:  00b5      push    {lr}
0x002f97da:  0248      ldr     r0, [pc, #8]
0x002f97dc:  40f03cf8  bl      #0x339858
0x002f97e0:  02bc      pop     {r1}
0x002f97e2:  0847      bx      r1
0x002f97e4:  6997      str     r7, [sp, #0x1a4]
0x002f97e6:  2f00      movs    r7, r5
0x002f97e8:  10b5      push    {r4, lr}
0x002f97ea:  104b      ldr     r3, [pc, #0x40]
0x002f97ec:  0022      movs    r2, #0
0x002f97ee:  1a60      str     r2, [r3]
0x002f97f0:  24f0acfa  bl      #0x31dd4c
0x002f97f4:  0e48      ldr     r0, [pc, #0x38]
0x002f97f6:  3bf097fb  bl      #0x334f28
0x002f97fa:  fa20      movs    r0, #0xfa
0x002f97fc:  4000      lsls    r0, r0, #1
0x002f97fe:  3bf019fc  bl      #0x335034
0x002f9802:  26f0f7fc  bl      #0x3201f4
0x002f9806:  10f0b3fc  bl      #0x30a170
0x002f980a:  0a4b      ldr     r3, [pc, #0x28]
0x002f980c:  0a4c      ldr     r4, [pc, #0x28]
0x002f980e:  0122      movs    r2, #1
0x002f9810:  1a60      str     r2, [r3]
0x002f9812:  201c      adds    r0, r4, #0
0x002f9814:  fdf7a8fe  bl      #0x2f7568
0x002f9818:  3af0f2fc  bl      #0x334200
0x002f981c:  0ff016f9  bl      #0x308a4c
0x002f9820:  40f0cafb  bl      #0x339fb8
0x002f9824:  10bc      pop     {r4}
0x002f9826:  01bc      pop     {r0}
0x002f9828:  0047      bx      r0
0x002f982a:  0000      movs    r0, r0
0x002f982c:  8cf3      DCW     0xf38c
0x002f982e:  2e00      movs    r6, r5
0x002f9830:  00f7      DCW     0xf700
0x002f9832:  2e00      movs    r6, r5
0x002f9834:  8000      lsls    r0, r0, #2
0x002f9836:  0002      lsls    r0, r0, #8
0x002f9838:  0002      lsls    r0, r0, #8
0x002f983a:  0201      lsls    r2, r0, #4
0x002f983c:  00b5      push    {lr}
0x002f983e:  0248      ldr     r0, [pc, #8]
0x002f9840:  40f00af8  bl      #0x339858
0x002f9844:  02bc      pop     {r1}
0x002f9846:  0847      bx      r1
0x002f9848:  e997      str     r7, [sp, #0x3a4]
0x002f984a:  2f00      movs    r7, r5
0x002f984c:  00b5      push    {lr}
0x002f984e:  fef79df9  bl      #0x2f7b8c
0x002f9852:  01bc      pop     {r0}
0x002f9854:  0047      bx      r0
0x002f9856:  0000      movs    r0, r0
0x002f9858:  00b5      push    {lr}
0x002f985a:  fef797f9  bl      #0x2f7b8c
0x002f985e:  0020      movs    r0, #0
0x002f9860:  02bc      pop     {r1}
0x002f9862:  0847      bx      r1
0x002f9864:  00b5      push    {lr}
0x002f9866:  0848      ldr     r0, [pc, #0x20]
0x002f9868:  0421      movs    r1, #4
0x002f986a:  33f04ffe  bl      #0x32d50c
0x002f986e:  05f091fe  bl      #0x2ff594
0x002f9872:  0121      movs    r1, #1
0x002f9874:  0548      ldr     r0, [pc, #0x14]
0x002f9876:  34f051fe  bl      #0x32e51c
0x002f987a:  0548      ldr     r0, [pc, #0x14]
0x002f987c:  0121      movs    r1, #1
0x002f987e:  34f04dfe  bl      #0x32e51c
0x002f9882:  01bc      pop     {r0}
0x002f9884:  0047      bx      r0
0x002f9886:  0000      movs    r0, r0
0x002f9888:  0202      lsls    r2, r0, #8
0x002f988a:  0000      movs    r0, r0
0x002f988c:  4211      asrs    r2, r0, #5
0x002f988e:  0000      movs    r0, r0
0x002f9890:  4311      asrs    r3, r0, #5
0x002f9892:  0000      movs    r0, r0
0x002f9894:  7047      bx      lr
0x002f9896:  0000      movs    r0, r0
0x002f9898:  7047      bx      lr
0x002f989a:  0000      movs    r0, r0
0x002f989c:  70b5      push    {r4, r5, r6, lr}
0x002f989e:  0025      movs    r5, #0
0x002f98a0:  1449      ldr     r1, [pc, #0x50]
0x002f98a2:  0570      strb    r5, [r0]
0x002f98a4:  041c      adds    r4, r0, #0
0x002f98a6:  3df0e3fb  bl      #0x337070
0x002f98aa:  1349      ldr     r1, [pc, #0x4c]
0x002f98ac:  3df0e0fb  bl      #0x337070
0x002f98b0:  1249      ldr     r1, [pc, #0x48]
0x002f98b2:  3df0ddfb  bl      #0x337070
0x002f98b6:  1249      ldr     r1, [pc, #0x48]
0x002f98b8:  3df0dafb  bl      #0x337070
0x002f98bc:  061c      adds    r6, r0, #0
0x002f98be:  06f049f8  bl      #0x2ff954
0x002f98c2:  3018      adds    r0, r6, r0
0x002f98c4:  08f0dafd  bl      #0x30247c
0x002f98c8:  8023      movs    r3, #0x80
0x002f98ca:  041b      subs    r4, r0, r4
0x002f98cc:  5b01      lsls    r3, r3, #5
0x002f98ce:  0570      strb    r5, [r0]
0x002f98d0:  9c42      cmp     r4, r3
0x002f98d2:  0cdc      bgt     #0x2f98ee
0x002f98d4:  8023      movs    r3, #0x80
0x002f98d6:  1b01      lsls    r3, r3, #4
0x002f98d8:  9c42      cmp     r4, r3
0x002f98da:  03dc      bgt     #0x2f98e4
0x002f98dc:  201c      adds    r0, r4, #0
0x002f98de:  70bc      pop     {r4, r5, r6}
0x002f98e0:  02bc      pop     {r1}
0x002f98e2:  0847      bx      r1
0x002f98e4:  0748      ldr     r0, [pc, #0x1c]
0x002f98e6:  211c      adds    r1, r4, #0
0x002f98e8:  3df01cfb  bl      #0x336f24
0x002f98ec:  f6e7      b       #0x2f98dc
0x002f98ee:  0648      ldr     r0, [pc, #0x18]
0x002f98f0:  f9e7      b       #0x2f98e6
0x002f98f2:  0000      movs    r0, r0
0x002f98f4:  30f01000  bics    r0, r0, #0x10
0x002f98f8:  2464      str     r4, [r4, #0x40]
0x002f98fa:  3600      movs    r6, r6
0x002f98fc:  a8e3      b       #0x2fa050
0x002f98fe:  1000      movs    r0, r2
0x002f9900:  c0d2      bhs     #0x2f9884
0x002f9902:  3700      movs    r7, r6
0x002f9904:  dc66      str     r4, [r3, #0x6c]
0x002f9906:  3600      movs    r6, r6
0x002f9908:  0067      str     r0, [r0, #0x70]
0x002f990a:  3600      movs    r6, r6
0x002f990c:  00b5      push    {lr}
0x002f990e:  fff7c5ff  bl      #0x2f989c
0x002f9912:  01bc      pop     {r0}
0x002f9914:  0047      bx      r0
0x002f9916:  0000      movs    r0, r0
0x002f9918:  30b5      push    {r4, r5, lr}
0x002f991a:  2a48      ldr     r0, [pc, #0xa8]
0x002f991c:  3cf012fe  bl      #0x336544
0x002f9920:  4020      movs    r0, #0x40
0x002f9922:  31f0ddfb  bl      #0x32b0e0
0x002f9926:  2848      ldr     r0, [pc, #0xa0]
0x002f9928:  3cf00cfe  bl      #0x336544
0x002f992c:  31f066fd  bl      #0x32b3fc
0x002f9930:  2648      ldr     r0, [pc, #0x98]
0x002f9932:  3cf007fe  bl      #0x336544
0x002f9936:  0020      movs    r0, #0
0x002f9938:  0021      movs    r1, #0
0x002f993a:  31f0effc  bl      #0x32b31c
0x002f993e:  041e      subs    r4, r0, #0
0x002f9940:  27d0      beq     #0x2f9992
0x002f9942:  5b20      movs    r0, #0x5b
0x002f9944:  3cf0b8fd  bl      #0x3364b8
0x002f9948:  2068      ldr     r0, [r4]
0x002f994a:  3cf0fbfd  bl      #0x336544
0x002f994e:  5d20      movs    r0, #0x5d
0x002f9950:  3cf0b2fd  bl      #0x3364b8
0x002f9954:  0020      movs    r0, #0
0x002f9956:  2168      ldr     r1, [r4]
0x002f9958:  31f07cfb  bl      #0x32b054
0x002f995c:  051e      subs    r5, r0, #0
0x002f995e:  10d0      beq     #0x2f9982
0x002f9960:  3c20      movs    r0, #0x3c
0x002f9962:  3cf0a9fd  bl      #0x3364b8
0x002f9966:  2868      ldr     r0, [r5]
0x002f9968:  3cf0ecfd  bl      #0x336544
0x002f996c:  3e20      movs    r0, #0x3e
0x002f996e:  3cf0a3fd  bl      #0x3364b8
0x002f9972:  201c      adds    r0, r4, #0
0x002f9974:  291c      adds    r1, r5, #0
0x002f9976:  164a      ldr     r2, [pc, #0x58]
0x002f9978:  31f0a4fd  bl      #0x32b4c4
0x002f997c:  201c      adds    r0, r4, #0
0x002f997e:  0ef08dfe  bl      #0x30869c
0x002f9982:  3cf0c9fd  bl      #0x336518
0x002f9986:  201c      adds    r0, r4, #0
0x002f9988:  0021      movs    r1, #0
0x002f998a:  31f0c7fc  bl      #0x32b31c
0x002f998e:  041e      subs    r4, r0, #0
0x002f9990:  d7d1      bne     #0x2f9942
0x002f9992:  3cf0c1fd  bl      #0x336518
0x002f9996:  0020      movs    r0, #0
0x002f9998:  0021      movs    r1, #0
0x002f999a:  0022      movs    r2, #0
0x002f999c:  15f08aff  bl      #0x30f8b4
0x002f99a0:  041e      subs    r4, r0, #0
0x002f99a2:  09d0      beq     #0x2f99b8
0x002f99a4:  201c      adds    r0, r4, #0
0x002f99a6:  01f0dbf8  bl      #0x2fab60
0x002f99aa:  201c      adds    r0, r4, #0
0x002f99ac:  0021      movs    r1, #0
0x002f99ae:  0022      movs    r2, #0
0x002f99b0:  15f080ff  bl      #0x30f8b4
0x002f99b4:  041e      subs    r4, r0, #0
0x002f99b6:  f5d1      bne     #0x2f99a4
0x002f99b8:  01f058fd  bl      #0x2fb46c
0x002f99bc:  30bc      pop     {r4, r5}
0x002f99be:  01bc      pop     {r0}
0x002f99c0:  0047      bx      r0
0x002f99c2:  0000      movs    r0, r0
0x002f99c4:  2467      str     r4, [r4, #0x70]
0x002f99c6:  3600      movs    r6, r6
0x002f99c8:  2c67      str     r4, [r5, #0x70]
0x002f99ca:  3600      movs    r6, r6
0x002f99cc:  3467      str     r4, [r6, #0x70]
0x002f99ce:  3600      movs    r6, r6
0x002f99d0:  a1b5      push    {r0, r5, r7, lr}
0x002f99d2:  3200      movs    r2, r6
0x002f99d4:  00b5      push    {lr}
0x002f99d6:  0a20      movs    r0, #0xa
0x002f99d8:  fdf716fd  bl      #0x2f7408
0x002f99dc:  01bc      pop     {r0}
0x002f99de:  0047      bx      r0
0x002f99e0:  00b5      push    {lr}
0x002f99e2:  6421      movs    r1, #0x64
0x002f99e4:  0448      ldr     r0, [pc, #0x10]
0x002f99e6:  fff707fc  bl      #0x2f91f8
0x002f99ea:  08f093fd  bl      #0x302514
0x002f99ee:  08f03bff  bl      #0x302868
0x002f99f2:  01bc      pop     {r0}
0x002f99f4:  0047      bx      r0
0x002f99f6:  0000      movs    r0, r0
0x002f99f8:  60a4      adr     r4, #0x180
0x002f99fa:  3300      movs    r3, r6
0x002f99fc:  00b5      push    {lr}
0x002f99fe:  3af0dbfb  bl      #0x3341b8
0x002f9a02:  3bf0b3fe  bl      #0x33576c
0x002f9a06:  c923      movs    r3, #0xc9
0x002f9a08:  c386      strh    r3, [r0, #0x36]
0x002f9a0a:  3af0e3fb  bl      #0x3341d4
0x002f9a0e:  3ff033ff  bl      #0x339878
0x002f9a12:  01bc      pop     {r0}
0x002f9a14:  0047      bx      r0
0x002f9a16:  c046      mov     r8, r8
0x002f9a18:  0120      movs    r0, #1
0x002f9a1a:  4042      rsbs    r0, r0, #0
0x002f9a1c:  7047      bx      lr
0x002f9a1e:  0000      movs    r0, r0
0x002f9a20:  f0b5      push    {r4, r5, r6, r7, lr}
0x002f9a22:  5746      mov     r7, sl
0x002f9a24:  4646      mov     r6, r8
0x002f9a26:  c0b4      push    {r6, r7}
0x002f9a28:  0026      movs    r6, #0
0x002f9a2a:  051c      adds    r5, r0, #0
0x002f9a2c:  8246      mov     sl, r0
0x002f9a2e:  b046      mov     r8, r6
0x002f9a30:  0135      adds    r5, #1
0x002f9a32:  071c      adds    r7, r0, #0
0x002f9a34:  301c      adds    r0, r6, #0
0x002f9a36:  0021      movs    r1, #0
0x002f9a38:  31f00cfb  bl      #0x32b054
0x002f9a3c:  061e      subs    r6, r0, #0
0x002f9a3e:  2dd0      beq     #0x2f9a9c
0x002f9a40:  3368      ldr     r3, [r6]
0x002f9a42:  1b78      ldrb    r3, [r3]
0x002f9a44:  402b      cmp     r3, #0x40
0x002f9a46:  f5d0      beq     #0x2f9a34
0x002f9a48:  2022      movs    r2, #0x20
0x002f9a4a:  281c      adds    r0, r5, #0
0x002f9a4c:  0021      movs    r1, #0
0x002f9a4e:  3cf0c7fb  bl      #0x3361e0
0x002f9a52:  3168      ldr     r1, [r6]
0x002f9a54:  281c      adds    r0, r5, #0
0x002f9a56:  3df00bfb  bl      #0x337070
0x002f9a5a:  451c      adds    r5, r0, #1
0x002f9a5c:  3168      ldr     r1, [r6]
0x002f9a5e:  281c      adds    r0, r5, #0
0x002f9a60:  01f0b4f8  bl      #0x2fabcc
0x002f9a64:  281c      adds    r0, r5, #0
0x002f9a66:  15f095ff  bl      #0x30f994
0x002f9a6a:  0404      lsls    r4, r0, #0x10
0x002f9a6c:  281c      adds    r0, r5, #0
0x002f9a6e:  3cf05dfd  bl      #0x33652c
0x002f9a72:  240c      lsrs    r4, r4, #0x10
0x002f9a74:  4019      adds    r0, r0, r5
0x002f9a76:  451c      adds    r5, r0, #1
0x002f9a78:  201c      adds    r0, r4, #0
0x002f9a7a:  3cf007fc  bl      #0x33628c
0x002f9a7e:  0104      lsls    r1, r0, #0x10
0x002f9a80:  090c      lsrs    r1, r1, #0x10
0x002f9a82:  281c      adds    r0, r5, #0
0x002f9a84:  3cf01afc  bl      #0x3362bc
0x002f9a88:  2037      adds    r7, #0x20
0x002f9a8a:  0122      movs    r2, #1
0x002f9a8c:  301c      adds    r0, r6, #0
0x002f9a8e:  0021      movs    r1, #0
0x002f9a90:  9044      add     r8, r2
0x002f9a92:  7d1c      adds    r5, r7, #1
0x002f9a94:  31f0defa  bl      #0x32b054
0x002f9a98:  061e      subs    r6, r0, #0
0x002f9a9a:  d1d1      bne     #0x2f9a40
0x002f9a9c:  5346      mov     r3, sl
0x002f9a9e:  4246      mov     r2, r8
0x002f9aa0:  e81a      subs    r0, r5, r3
0x002f9aa2:  1a70      strb    r2, [r3]
0x002f9aa4:  18bc      pop     {r3, r4}
0x002f9aa6:  9846      mov     r8, r3
0x002f9aa8:  a246      mov     sl, r4
0x002f9aaa:  f0bc      pop     {r4, r5, r6, r7}
0x002f9aac:  02bc      pop     {r1}
0x002f9aae:  0847      bx      r1
0x002f9ab0:  0020      movs    r0, #0
0x002f9ab2:  7047      bx      lr
0x002f9ab4:  10b5      push    {r4, lr}
0x002f9ab6:  041c      adds    r4, r0, #0
0x002f9ab8:  2078      ldrb    r0, [r4]
0x002f9aba:  0006      lsls    r0, r0, #0x18
0x002f9abc:  0028      cmp     r0, #0
0x002f9abe:  09d0      beq     #0x2f9ad4
0x002f9ac0:  000e      lsrs    r0, r0, #0x18
0x002f9ac2:  3df0fdfa  bl      #0x3370c0
0x002f9ac6:  0128      cmp     r0, #1
0x002f9ac8:  08d1      bne     #0x2f9adc
0x002f9aca:  0134      adds    r4, #1
0x002f9acc:  2078      ldrb    r0, [r4]
0x002f9ace:  0006      lsls    r0, r0, #0x18
0x002f9ad0:  0028      cmp     r0, #0
0x002f9ad2:  f5d1      bne     #0x2f9ac0
0x002f9ad4:  0120      movs    r0, #1
0x002f9ad6:  10bc      pop     {r4}
0x002f9ad8:  02bc      pop     {r1}
0x002f9ada:  0847      bx      r1
0x002f9adc:  0020      movs    r0, #0
0x002f9ade:  fae7      b       #0x2f9ad6
0x002f9ae0:  f0b5      push    {r4, r5, r6, r7, lr}
0x002f9ae2:  5746      mov     r7, sl
0x002f9ae4:  4646      mov     r6, r8
0x002f9ae6:  c0b4      push    {r6, r7}
0x002f9ae8:  071c      adds    r7, r0, #0
0x002f9aea:  0e1e      subs    r6, r1, #0
0x002f9aec:  55dd      ble     #0x2f9b9a
0x002f9aee:  0023      movs    r3, #0
0x002f9af0:  9846      mov     r8, r3
0x002f9af2:  731e      subs    r3, r6, #1
0x002f9af4:  9a46      mov     sl, r3
0x002f9af6:  5346      mov     r3, sl
0x002f9af8:  002b      cmp     r3, #0
0x002f9afa:  49db      blt     #0x2f9b90
0x002f9afc:  1b11      asrs    r3, r3, #4
0x002f9afe:  4345      cmp     r3, r8
0x002f9b00:  4bdb      blt     #0x2f9b9a
0x002f9b02:  2020      movs    r0, #0x20
0x002f9b04:  3cf0d8fc  bl      #0x3364b8
0x002f9b08:  4346      mov     r3, r8
0x002f9b0a:  1805      lsls    r0, r3, #0x14
0x002f9b0c:  000c      lsrs    r0, r0, #0x10
0x002f9b0e:  1d01      lsls    r5, r3, #4
0x002f9b10:  3cf046ff  bl      #0x3369a0
0x002f9b14:  3a20      movs    r0, #0x3a
0x002f9b16:  3cf0cffc  bl      #0x3364b8
0x002f9b1a:  0024      movs    r4, #0
0x002f9b1c:  09e0      b       #0x2f9b32
0x002f9b1e:  2020      movs    r0, #0x20
0x002f9b20:  3cf0cafc  bl      #0x3364b8
0x002f9b24:  eb19      adds    r3, r5, r7
0x002f9b26:  185d      ldrb    r0, [r3, r4]
0x002f9b28:  0134      adds    r4, #1
0x002f9b2a:  3cf027ff  bl      #0x33697c
0x002f9b2e:  0f2c      cmp     r4, #0xf
0x002f9b30:  0edc      bgt     #0x2f9b50
0x002f9b32:  2b19      adds    r3, r5, r4
0x002f9b34:  b342      cmp     r3, r6
0x002f9b36:  f2db      blt     #0x2f9b1e
0x002f9b38:  2020      movs    r0, #0x20
0x002f9b3a:  3cf0bdfc  bl      #0x3364b8
0x002f9b3e:  2020      movs    r0, #0x20
0x002f9b40:  3cf0bafc  bl      #0x3364b8
0x002f9b44:  0134      adds    r4, #1
0x002f9b46:  2020      movs    r0, #0x20
0x002f9b48:  3cf0b6fc  bl      #0x3364b8
0x002f9b4c:  0f2c      cmp     r4, #0xf
0x002f9b4e:  f0dd      ble     #0x2f9b32
0x002f9b50:  2020      movs    r0, #0x20
0x002f9b52:  3cf0b1fc  bl      #0x3364b8
0x002f9b56:  2f20      movs    r0, #0x2f
0x002f9b58:  3cf0aefc  bl      #0x3364b8
0x002f9b5c:  2020      movs    r0, #0x20
0x002f9b5e:  3cf0abfc  bl      #0x3364b8
0x002f9b62:  0024      movs    r4, #0
0x002f9b64:  2b19      adds    r3, r5, r4
0x002f9b66:  b342      cmp     r3, r6
0x002f9b68:  08da      bge     #0x2f9b7c
0x002f9b6a:  eb19      adds    r3, r5, r7
0x002f9b6c:  185d      ldrb    r0, [r3, r4]
0x002f9b6e:  031c      adds    r3, r0, #0
0x002f9b70:  203b      subs    r3, #0x20
0x002f9b72:  5f2b      cmp     r3, #0x5f
0x002f9b74:  00d9      bls     #0x2f9b78
0x002f9b76:  2e20      movs    r0, #0x2e
0x002f9b78:  3cf09efc  bl      #0x3364b8
0x002f9b7c:  0134      adds    r4, #1
0x002f9b7e:  0f2c      cmp     r4, #0xf
0x002f9b80:  f0dd      ble     #0x2f9b64
0x002f9b82:  3cf0c9fc  bl      #0x336518
0x002f9b86:  0123      movs    r3, #1
0x002f9b88:  9844      add     r8, r3
0x002f9b8a:  5346      mov     r3, sl
0x002f9b8c:  002b      cmp     r3, #0
0x002f9b8e:  b5da      bge     #0x2f9afc
0x002f9b90:  331c      adds    r3, r6, #0
0x002f9b92:  0e33      adds    r3, #0xe
0x002f9b94:  1b11      asrs    r3, r3, #4
0x002f9b96:  4345      cmp     r3, r8
0x002f9b98:  b3da      bge     #0x2f9b02
0x002f9b9a:  18bc      pop     {r3, r4}
