000B1374 ffff0824 addiu      $t0, $zero, -1
000B1378 20010934 ori        $t1, $zero, 0x120
000B137C 25500000 move       $t2, $zero
000B1380 9bb1020c jal        0xac66c
000B1384 25588002 move       $t3, $s4
000B1388 72b1020c jal        0xac5c8
000B138C 25206002 move       $a0, $s3
000B1390 0100f726 addiu      $s7, $s7, 1
000B1394 0100d626 addiu      $s6, $s6, 1
000B1398 0e00e42e sltiu      $a0, $s7, 0xe
000B139C 79ff8014 bnez       $a0, 0xb1184
000B13A0 0400b526 addiu      $s5, $s5, 4
000B13A4 1400648e lw         $a0, 0x14($s3)
000B13A8 3400b28f lw         $s2, 0x34($sp)
000B13AC 10008434 ori        $a0, $a0, 0x10
000B13B0 140064ae sw         $a0, 0x14($s3)
000B13B4 3eb0020c jal        0xac0f8
000B13B8 25206002 move       $a0, $s3
000B13BC 81ff143c lui        $s4, 0xff81
000B13C0 01001034 ori        $s0, $zero, 1
000B13C4 00001134 ori        $s1, $zero, 0
000B13C8 80809426 addiu      $s4, $s4, -0x7f80
000B13CC 0000458e lw         $a1, ($s2)
000B13D0 82000434 ori        $a0, $zero, 0x82
000B13D4 ffffa524 addiu      $a1, $a1, -1
000B13D8 e785000c jal        0x2179c
000B13DC ff00a530 andi       $a1, $a1, 0xff
000B13E0 21004014 bnez       $v0, 0xb1468
000B13E4 00000000 nop        
000B13E8 25206002 move       $a0, $s3
000B13EC 25282002 move       $a1, $s1
000B13F0 25300000 move       $a2, $zero
000B13F4 25388002 move       $a3, $s4
000B13F8 25408002 move       $t0, $s4
000B13FC 25488002 move       $t1, $s4
000B1400 51af020c jal        0xabd44

000B446C 25302002 move       $a2, $s1
000B4470 25380000 move       $a3, $zero
000B4474 25400000 move       $t0, $zero
000B4478 25480000 move       $t1, $zero
000B447C 01000a34 ori        $t2, $zero, 1
000B4480 25580000 move       $t3, $zero
000B4484 14b2020c jal        0xac850
000B4488 0000b2af sw         $s2, ($sp)
000B448C 01003126 addiu      $s1, $s1, 1
000B4490 0c00242e sltiu      $a0, $s1, 0xc
000B4494 deff8014 bnez       $a0, 0xb4410
000B4498 00000000 nop        
000B449C 1400648e lw         $a0, 0x14($s3)
000B44A0 04008434 ori        $a0, $a0, 4
000B44A4 10008434 ori        $a0, $a0, 0x10
000B44A8 140064ae sw         $a0, 0x14($s3)
000B44AC 3eb0020c jal        0xac0f8
000B44B0 25206002 move       $a0, $s3
000B44B4 4000b08f lw         $s0, 0x40($sp)
000B44B8 4400b18f lw         $s1, 0x44($sp)
000B44BC 4800b28f lw         $s2, 0x48($sp)
000B44C0 4c00b38f lw         $s3, 0x4c($sp)
000B44C4 5000bf8f lw         $ra, 0x50($sp)
000B44C8 0800e003 jr         $ra
000B44CC 6000bd27 addiu      $sp, $sp, 0x60
000B44D0 c0ffbd27 addiu      $sp, $sp, -0x40
000B44D4 2c00b3af sw         $s3, 0x2c($sp)
000B44D8 2d00133c lui        $s3, 0x2d
000B44DC 2000b0af sw         $s0, 0x20($sp)
000B44E0 2400b1af sw         $s1, 0x24($sp)
000B44E4 2800b2af sw         $s2, 0x28($sp)
000B44E8 3000bfaf sw         $ra, 0x30($sp)
000B44EC daca030c jal        0xf2b68
000B44F0 741a708e lw         $s0, 0x1a74($s3)
000B44F4 2d00113c lui        $s1, 0x2d
000B44F8 d81a248e lw         $a0, 0x1ad8($s1)

000B5BEC 25308002 move       $a2, $s4
000B5BF0 25386002 move       $a3, $s3
000B5BF4 25400000 move       $t0, $zero
000B5BF8 25480000 move       $t1, $zero
000B5BFC 01000a34 ori        $t2, $zero, 1
000B5C00 25580000 move       $t3, $zero
000B5C04 14b2020c jal        0xac850
000B5C08 0000b1af sw         $s1, ($sp)
000B5C0C 01001026 addiu      $s0, $s0, 1
000B5C10 c60b042e sltiu      $a0, $s0, 0xbc6
000B5C14 ebff8014 bnez       $a0, 0xb5bc4
000B5C18 00000000 nop        
000B5C1C 1400448e lw         $a0, 0x14($s2)
000B5C20 04008434 ori        $a0, $a0, 4
000B5C24 10008434 ori        $a0, $a0, 0x10
000B5C28 140044ae sw         $a0, 0x14($s2)
000B5C2C 3eb0020c jal        0xac0f8
000B5C30 25204002 move       $a0, $s2
000B5C34 4000b08f lw         $s0, 0x40($sp)
000B5C38 4400b18f lw         $s1, 0x44($sp)
000B5C3C 4800b28f lw         $s2, 0x48($sp)
000B5C40 4c00b38f lw         $s3, 0x4c($sp)
000B5C44 5000b48f lw         $s4, 0x50($sp)
000B5C48 5400bf8f lw         $ra, 0x54($sp)
000B5C4C 0800e003 jr         $ra
000B5C50 6000bd27 addiu      $sp, $sp, 0x60
000B5C54 e0ffbd27 addiu      $sp, $sp, -0x20
000B5C58 1000b0af sw         $s0, 0x10($sp)
000B5C5C 0400103c lui        $s0, 4
000B5C60 54621026 addiu      $s0, $s0, 0x6254
000B5C64 1400bfaf sw         $ra, 0x14($sp)
000B5C68 fcb1020c jal        0xac7f0
000B5C6C 25200002 move       $a0, $s0
000B5C70 12e1010c jal        0x78448
000B5C74 106b0434 ori        $a0, $zero, 0x6b10
000B5C78 25204000 move       $a0, $v0

000B6108 25302002 move       $a2, $s1
000B610C 25380000 move       $a3, $zero
000B6110 25400000 move       $t0, $zero
000B6114 25480000 move       $t1, $zero
000B6118 01000a34 ori        $t2, $zero, 1
000B611C 25580000 move       $t3, $zero
000B6120 14b2020c jal        0xac850
000B6124 0000b3af sw         $s3, ($sp)
000B6128 ffff5226 addiu      $s2, $s2, -1
000B612C 0300442a slti       $a0, $s2, 3
000B6130 e2ff8010 beqz       $a0, 0xb60bc
000B6134 00000000 nop        
000B6138 1400848e lw         $a0, 0x14($s4)
000B613C 04008434 ori        $a0, $a0, 4
000B6140 10008434 ori        $a0, $a0, 0x10
000B6144 140084ae sw         $a0, 0x14($s4)
000B6148 3eb0020c jal        0xac0f8
000B614C 25208002 move       $a0, $s4
000B6150 4000b08f lw         $s0, 0x40($sp)
000B6154 4400b18f lw         $s1, 0x44($sp)
000B6158 4800b28f lw         $s2, 0x48($sp)
000B615C 4c00b38f lw         $s3, 0x4c($sp)
000B6160 5000b48f lw         $s4, 0x50($sp)
000B6164 5400bf8f lw         $ra, 0x54($sp)
000B6168 0800e003 jr         $ra
000B616C 6000bd27 addiu      $sp, $sp, 0x60
000B6170 e0ffbd27 addiu      $sp, $sp, -0x20
000B6174 2d00053c lui        $a1, 0x2d
000B6178 5c2ea58c lw         $a1, 0x2e5c($a1)
000B617C 1000bfaf sw         $ra, 0x10($sp)
000B6180 0300a010 beqz       $a1, 0xb6190
000B6184 00000000 nop        
000B6188 09f8a000 jalr       $a1
000B618C 00000000 nop        
000B6190 01000434 ori        $a0, $zero, 1
000B6194 2d00053c lui        $a1, 0x2d

000B6BC0 0800868c lw         $a2, 8($a0)
000B6BC4 ffff7326 addiu      $s3, $s3, -1
000B6BC8 25208002 move       $a0, $s4
000B6BCC 25386002 move       $a3, $s3
000B6BD0 25400000 move       $t0, $zero
000B6BD4 25480000 move       $t1, $zero
000B6BD8 25500000 move       $t2, $zero
000B6BDC 14b2020c jal        0xac850
000B6BE0 0000b0af sw         $s0, ($sp)
000B6BE4 ebff601e bgtz       $s3, 0xb6b94
000B6BE8 fcff5226 addiu      $s2, $s2, -4
000B6BEC 1400848e lw         $a0, 0x14($s4)
000B6BF0 04008434 ori        $a0, $a0, 4
000B6BF4 140084ae sw         $a0, 0x14($s4)
000B6BF8 10008434 ori        $a0, $a0, 0x10
000B6BFC 140084ae sw         $a0, 0x14($s4)
000B6C00 3eb0020c jal        0xac0f8
000B6C04 25208002 move       $a0, $s4
000B6C08 4000b08f lw         $s0, 0x40($sp)
000B6C0C 4400b18f lw         $s1, 0x44($sp)
000B6C10 4800b28f lw         $s2, 0x48($sp)
000B6C14 4c00b38f lw         $s3, 0x4c($sp)
000B6C18 5000b48f lw         $s4, 0x50($sp)
000B6C1C 5400bf8f lw         $ra, 0x54($sp)
000B6C20 0800e003 jr         $ra
000B6C24 6000bd27 addiu      $sp, $sp, 0x60
000B6C28 8d630046 trunc.w.s  $f14, $f12
000B6C2C 8043063c lui        $a2, 0x4380
000B6C30 cd6b0046 trunc.w.s  $f15, $f13
000B6C34 0400073c lui        $a3, 4
000B6C38 00808644 mtc1       $a2, $f16
000B6C3C c468e724 addiu      $a3, $a3, 0x68c4
000B6C40 00700644 mfc1       $a2, $f14
000B6C44 000086a4 sh         $a2, ($a0)
000B6C48 00780644 mfc1       $a2, $f15
000B6C4C 0000a6a4 sh         $a2, ($a1)

000BB724 ffff0924 addiu      $t1, $zero, -1
000BB728 02000a34 ori        $t2, $zero, 2
000BB72C 9bb1020c jal        0xac66c
000BB730 ffff0b24 addiu      $t3, $zero, -1
000BB734 72b1020c jal        0xac5c8
000BB738 25204002 move       $a0, $s2
000BB73C 01001026 addiu      $s0, $s0, 1
000BB740 10007326 addiu      $s3, $s3, 0x10
000BB744 0e00042e sltiu      $a0, $s0, 0xe
000BB748 d1ff8014 bnez       $a0, 0xbb690
000BB74C 04009426 addiu      $s4, $s4, 4
000BB750 1400448e lw         $a0, 0x14($s2)
000BB754 04008434 ori        $a0, $a0, 4
000BB758 140044ae sw         $a0, 0x14($s2)
000BB75C 10008434 ori        $a0, $a0, 0x10
000BB760 140044ae sw         $a0, 0x14($s2)
000BB764 3eb0020c jal        0xac0f8
000BB768 25204002 move       $a0, $s2
000BB76C e7ed020c jal        0xbb79c
000BB770 00000000 nop        
000BB774 3000b08f lw         $s0, 0x30($sp)
000BB778 3400b18f lw         $s1, 0x34($sp)
000BB77C 3800b28f lw         $s2, 0x38($sp)
000BB780 3c00b38f lw         $s3, 0x3c($sp)
000BB784 4000b48f lw         $s4, 0x40($sp)
000BB788 4400b58f lw         $s5, 0x44($sp)
000BB78C 4800b68f lw         $s6, 0x48($sp)
000BB790 4c00bf8f lw         $ra, 0x4c($sp)
000BB794 0800e003 jr         $ra
000BB798 5000bd27 addiu      $sp, $sp, 0x50
000BB79C c0ffbd27 addiu      $sp, $sp, -0x40
000BB7A0 2400b1af sw         $s1, 0x24($sp)
000BB7A4 2d00113c lui        $s1, 0x2d
000BB7A8 84453126 addiu      $s1, $s1, 0x4584
000BB7AC 2000b0af sw         $s0, 0x20($sp)
000BB7B0 2800b2af sw         $s2, 0x28($sp)

000BC444 25380000 move       $a3, $zero
000BC448 25400000 move       $t0, $zero
000BC44C 25480000 move       $t1, $zero
000BC450 25500000 move       $t2, $zero
000BC454 25580000 move       $t3, $zero
000BC458 14b2020c jal        0xac850
000BC45C 0000b3af sw         $s3, ($sp)
000BC460 01005226 addiu      $s2, $s2, 1
000BC464 0500442e sltiu      $a0, $s2, 5
000BC468 e9ff8014 bnez       $a0, 0xbc410
000BC46C 10003126 addiu      $s1, $s1, 0x10
000BC470 1400848e lw         $a0, 0x14($s4)
000BC474 04008434 ori        $a0, $a0, 4
000BC478 140084ae sw         $a0, 0x14($s4)
000BC47C 10008434 ori        $a0, $a0, 0x10
000BC480 140084ae sw         $a0, 0x14($s4)
000BC484 3eb0020c jal        0xac0f8
000BC488 25208002 move       $a0, $s4
000BC48C 4000b08f lw         $s0, 0x40($sp)
000BC490 4400b18f lw         $s1, 0x44($sp)
000BC494 4800b28f lw         $s2, 0x48($sp)
000BC498 4c00b38f lw         $s3, 0x4c($sp)
000BC49C 5000b48f lw         $s4, 0x50($sp)
000BC4A0 5400bf8f lw         $ra, 0x54($sp)
000BC4A4 0800e003 jr         $ra
000BC4A8 6000bd27 addiu      $sp, $sp, 0x60
000BC4AC c0ffbd27 addiu      $sp, $sp, -0x40
000BC4B0 2000b0af sw         $s0, 0x20($sp)
000BC4B4 2400b1af sw         $s1, 0x24($sp)
000BC4B8 2800b2af sw         $s2, 0x28($sp)
000BC4BC 2c00b3af sw         $s3, 0x2c($sp)
000BC4C0 3000b4af sw         $s4, 0x30($sp)
000BC4C4 3400b5af sw         $s5, 0x34($sp)
000BC4C8 3800bfaf sw         $ra, 0x38($sp)
000BC4CC 0400133c lui        $s3, 4
000BC4D0 2d00123c lui        $s2, 0x2d

000BD73C 25300000 move       $a2, $zero
000BD740 e1010734 ori        $a3, $zero, 0x1e1
000BD744 2540a002 move       $t0, $s5
000BD748 25480000 move       $t1, $zero
000BD74C 01000a34 ori        $t2, $zero, 1
000BD750 25580000 move       $t3, $zero
000BD754 14b2020c jal        0xac850
000BD758 0000b1af sw         $s1, ($sp)
000BD75C 1900642e sltiu      $a0, $s3, 0x19
000BD760 ccff8014 bnez       $a0, 0xbd694
000BD764 0c001026 addiu      $s0, $s0, 0xc
000BD768 1400448e lw         $a0, 0x14($s2)
000BD76C 04008434 ori        $a0, $a0, 4
000BD770 140044ae sw         $a0, 0x14($s2)
000BD774 10008434 ori        $a0, $a0, 0x10
000BD778 140044ae sw         $a0, 0x14($s2)
000BD77C 3eb0020c jal        0xac0f8
000BD780 25204002 move       $a0, $s2
000BD784 ecf5020c jal        0xbd7b0
000BD788 00000000 nop        
000BD78C 4000b08f lw         $s0, 0x40($sp)
000BD790 4400b18f lw         $s1, 0x44($sp)
000BD794 4800b28f lw         $s2, 0x48($sp)
000BD798 4c00b38f lw         $s3, 0x4c($sp)
000BD79C 5000b48f lw         $s4, 0x50($sp)
000BD7A0 5400b58f lw         $s5, 0x54($sp)
000BD7A4 5800bf8f lw         $ra, 0x58($sp)
000BD7A8 0800e003 jr         $ra
000BD7AC 6000bd27 addiu      $sp, $sp, 0x60
000BD7B0 c0ffbd27 addiu      $sp, $sp, -0x40
000BD7B4 2800b2af sw         $s2, 0x28($sp)
000BD7B8 2d00123c lui        $s2, 0x2d
000BD7BC 40575226 addiu      $s2, $s2, 0x5740
000BD7C0 2000b0af sw         $s0, 0x20($sp)
000BD7C4 2400b1af sw         $s1, 0x24($sp)
000BD7C8 2c00b3af sw         $s3, 0x2c($sp)

000BDDB4 25300000 move       $a2, $zero
000BDDB8 25384002 move       $a3, $s2
000BDDBC 25400000 move       $t0, $zero
000BDDC0 25480000 move       $t1, $zero
000BDDC4 25500000 move       $t2, $zero
000BDDC8 25580000 move       $t3, $zero
000BDDCC 14b2020c jal        0xac850
000BDDD0 0000b4af sw         $s4, ($sp)
000BDDD4 01007326 addiu      $s3, $s3, 1
000BDDD8 1b10642a slti       $a0, $s3, 0x101b
000BDDDC d7ff8014 bnez       $a0, 0xbdd3c
000BDDE0 00000000 nop        
000BDDE4 1400a48e lw         $a0, 0x14($s5)
000BDDE8 04008434 ori        $a0, $a0, 4
000BDDEC 10008434 ori        $a0, $a0, 0x10
000BDDF0 1400a4ae sw         $a0, 0x14($s5)
000BDDF4 3eb0020c jal        0xac0f8
000BDDF8 2520a002 move       $a0, $s5
000BDDFC 4000b08f lw         $s0, 0x40($sp)
000BDE00 4400b18f lw         $s1, 0x44($sp)
000BDE04 4800b28f lw         $s2, 0x48($sp)
000BDE08 4c00b38f lw         $s3, 0x4c($sp)
000BDE0C 5000b48f lw         $s4, 0x50($sp)
000BDE10 5400b58f lw         $s5, 0x54($sp)
000BDE14 5800bf8f lw         $ra, 0x58($sp)
000BDE18 0800e003 jr         $ra
000BDE1C 6000bd27 addiu      $sp, $sp, 0x60
000BDE20 2c00043c lui        $a0, 0x2c
000BDE24 0800e003 jr         $ra
000BDE28 396d80a0 sb         $zero, 0x6d39($a0)
000BDE2C e0ffbd27 addiu      $sp, $sp, -0x20
000BDE30 0400043c lui        $a0, 4
000BDE34 1000b0af sw         $s0, 0x10($sp)
000BDE38 1400bfaf sw         $ra, 0x14($sp)
000BDE3C 151b030c jal        0xc6c54
000BDE40 94728424 addiu      $a0, $a0, 0x7294

000C3C90 0000b4af sw         $s4, ($sp)
000C3C94 2d00043c lui        $a0, 0x2d
000C3C98 d874848c lw         $a0, 0x74d8($a0)
000C3C9C 01001026 addiu      $s0, $s0, 1
000C3CA0 2b200402 sltu       $a0, $s0, $a0
000C3CA4 e9ff8014 bnez       $a0, 0xc3c4c
000C3CA8 00000000 nop        
000C3CAC 4400a48f lw         $a0, 0x44($sp)
000C3CB0 0100f726 addiu      $s7, $s7, 1
000C3CB4 2b20e402 sltu       $a0, $s7, $a0
000C3CB8 d5ff8014 bnez       $a0, 0xc3c10
000C3CBC 0400b526 addiu      $s5, $s5, 4
000C3CC0 4000a48f lw         $a0, 0x40($sp)
000C3CC4 18001034 ori        $s0, $zero, 0x18
000C3CC8 1400868c lw         $a2, 0x14($a0)
000C3CCC 1000c634 ori        $a2, $a2, 0x10
000C3CD0 3eb0020c jal        0xac0f8
000C3CD4 140086ac sw         $a2, 0x14($a0)
000C3CD8 2e00043c lui        $a0, 0x2e
000C3CDC 38f3848c lw         $a0, -0xcc8($a0)
000C3CE0 00001434 ori        $s4, $zero, 0
000C3CE4 01009050 beql       $a0, $s0, 0xc3cec
000C3CE8 02001434 ori        $s4, $zero, 2
000C3CEC 4400a48f lw         $a0, 0x44($sp)
000C3CF0 25a88002 move       $s5, $s4
000C3CF4 2b20a402 sltu       $a0, $s5, $a0
000C3CF8 33008010 beqz       $a0, 0xc3dc8
000C3CFC 81ff113c lui        $s1, 0xff81
000C3D00 80a01400 sll        $s4, $s4, 2
000C3D04 4000b78f lw         $s7, 0x40($sp)
000C3D08 80803126 addiu      $s1, $s1, -0x7f80
000C3D0C dc74c48f lw         $a0, 0x74dc($fp)
000C3D10 5400848c lw         $a0, 0x54($a0)
000C3D14 21209400 addu       $a0, $a0, $s4
000C3D18 0000928c lw         $s2, ($a0)
000C3D1C f667040c jal        0x119fd8

000C5244 25380000 move       $a3, $zero
000C5248 25400000 move       $t0, $zero
000C524C 25480000 move       $t1, $zero
000C5250 01000a34 ori        $t2, $zero, 1
000C5254 25580000 move       $t3, $zero
000C5258 14b2020c jal        0xac850
000C525C 0000b0af sw         $s0, ($sp)
000C5260 01007326 addiu      $s3, $s3, 1
000C5264 0b00642e sltiu      $a0, $s3, 0xb
000C5268 e2ff8014 bnez       $a0, 0xc51f4
000C526C 08003126 addiu      $s1, $s1, 8
000C5270 1400848e lw         $a0, 0x14($s4)
000C5274 04008434 ori        $a0, $a0, 4
000C5278 140084ae sw         $a0, 0x14($s4)
000C527C 10008434 ori        $a0, $a0, 0x10
000C5280 140084ae sw         $a0, 0x14($s4)
000C5284 3eb0020c jal        0xac0f8
000C5288 25208002 move       $a0, $s4
000C528C 4000b08f lw         $s0, 0x40($sp)
000C5290 4400b18f lw         $s1, 0x44($sp)
000C5294 4800b28f lw         $s2, 0x48($sp)
000C5298 4c00b38f lw         $s3, 0x4c($sp)
000C529C 5000b48f lw         $s4, 0x50($sp)
000C52A0 5400bf8f lw         $ra, 0x54($sp)
000C52A4 0800e003 jr         $ra
000C52A8 6000bd27 addiu      $sp, $sp, 0x60
000C52AC e0ffbd27 addiu      $sp, $sp, -0x20
000C52B0 2e00043c lui        $a0, 0x2e
000C52B4 909080ac sw         $zero, -0x6f70($a0)
000C52B8 0400043c lui        $a0, 4
000C52BC 1000bfaf sw         $ra, 0x10($sp)
000C52C0 3b6b020c jal        0x9acec
000C52C4 24788424 addiu      $a0, $a0, 0x7824
000C52C8 1000bf8f lw         $ra, 0x10($sp)
000C52CC 0800e003 jr         $ra
000C52D0 2000bd27 addiu      $sp, $sp, 0x20