000B0E28 10004cc6 lwc1       $f12, 0x10($s2)
000B0E2C 4000a4af sw         $a0, 0x40($sp)
000B0E30 0c00448e lw         $a0, 0xc($s2)
000B0E34 00600744 mfc1       $a3, $f12
000B0E38 4400a5af sw         $a1, 0x44($sp)
000B0E3C 4800a6af sw         $a2, 0x48($sp)
000B0E40 4c00a4af sw         $a0, 0x4c($sp)
000B0E44 5000a7af sw         $a3, 0x50($sp)
000B0E48 3201000c jal        0x4c8
000B0E4C 4000a427 addiu      $a0, $sp, 0x40
000B0E50 42031646 mul.s      $f13, $f0, $f22
000B0E54 4d6b0046 trunc.w.s  $f13, $f13
000B0E58 00680444 mfc1       $a0, $f13
000B0E5C e0f8a4ae sw         $a0, -0x720($s5)
000B0E60 6c72020c jal        0x9c9b0
000B0E64 25200000 move       $a0, $zero
000B0E68 5cb2020c jal        0xac970
000B0E6C 25202002 move       $a0, $s1
000B0E70 6c72020c jal        0x9c9b0
000B0E74 01000434 ori        $a0, $zero, 1
000B0E78 1a010434 ori        $a0, $zero, 0x11a
000B0E7C 06a30046 mov.s      $f12, $f20
000B0E80 f583020c jal        0xa0fd4
000B0E84 25280002 move       $a1, $s0
000B0E88 3000a48f lw         $a0, 0x30($sp)
000B0E8C 3400a58f lw         $a1, 0x34($sp)
000B0E90 3800a68f lw         $a2, 0x38($sp)
000B0E94 3c00a78f lw         $a3, 0x3c($sp)
000B0E98 d400a4af sw         $a0, 0xd4($sp)
000B0E9C d800a5af sw         $a1, 0xd8($sp)
000B0EA0 dc00a6af sw         $a2, 0xdc($sp)
000B0EA4 e000a7af sw         $a3, 0xe0($sp)
000B0EA8 00240400 sll        $a0, $a0, 0x10
000B0EAC 002c0500 sll        $a1, $a1, 0x10
000B0EB0 00340600 sll        $a2, $a2, 0x10
000B0EB4 003c0700 sll        $a3, $a3, 0x10

000B14B0 6000bf8f lw         $ra, 0x60($sp)
000B14B4 0800e003 jr         $ra
000B14B8 7000bd27 addiu      $sp, $sp, 0x70
000B14BC 90ffbd27 addiu      $sp, $sp, -0x70
000B14C0 2d00043c lui        $a0, 0x2d
000B14C4 4000b4e7 swc1       $f20, 0x40($sp)
000B14C8 4400b6e7 swc1       $f22, 0x44($sp)
000B14CC 4800b8e7 swc1       $f24, 0x48($sp)
000B14D0 4c00bae7 swc1       $f26, 0x4c($sp)
000B14D4 5000b0af sw         $s0, 0x50($sp)
000B14D8 5400b1af sw         $s1, 0x54($sp)
000B14DC 5800b2af sw         $s2, 0x58($sp)
000B14E0 5c00b3af sw         $s3, 0x5c($sp)
000B14E4 6000b4af sw         $s4, 0x60($sp)
000B14E8 6400b5af sw         $s5, 0x64($sp)
000B14EC 6800bfaf sw         $ra, 0x68($sp)
000B14F0 5cb2020c jal        0xac970
000B14F4 b80d8424 addiu      $a0, $a0, 0xdb8
000B14F8 803f093c lui        $t1, 0x3f80
000B14FC 00c08044 mtc1       $zero, $f24
000B1500 00d08944 mtc1       $t1, $f26
000B1504 40030434 ori        $a0, $zero, 0x340
000B1508 25280000 move       $a1, $zero
000B150C 86c30046 mov.s      $f14, $f24
000B1510 25300000 move       $a2, $zero
000B1514 c6c30046 mov.s      $f15, $f24
000B1518 25380000 move       $a3, $zero
000B151C 06d30046 mov.s      $f12, $f26
000B1520 ffff0824 addiu      $t0, $zero, -1
000B1524 6490020c jal        0xa4190
000B1528 46d30046 mov.s      $f13, $f26
000B152C 6472020c jal        0x9c990
000B1530 ffff0424 addiu      $a0, $zero, -1
000B1534 3000b327 addiu      $s3, $sp, 0x30
000B1538 06c30046 mov.s      $f12, $f24
000B153C 57010434 ori        $a0, $zero, 0x157

000B1E58 3a8a020c jal        0xa28e8
000B1E5C 25200002 move       $a0, $s0
000B1E60 3c00a48f lw         $a0, 0x3c($sp)
000B1E64 002c0200 sll        $a1, $v0, 0x10
000B1E68 00240400 sll        $a0, $a0, 0x10
000B1E6C 038c0400 sra        $s1, $a0, 0x10
000B1E70 03840500 sra        $s0, $a1, 0x10
000B1E74 5227040c jal        0x109d48
000B1E78 1c020434 ori        $a0, $zero, 0x21c
000B1E7C 25200002 move       $a0, $s0
000B1E80 06a30046 mov.s      $f12, $f20
000B1E84 25282002 move       $a1, $s1
000B1E88 46a30046 mov.s      $f13, $f20
000B1E8C 4378020c jal        0x9e10c
000B1E90 25304000 move       $a2, $v0
000B1E94 2d00043c lui        $a0, 0x2d
000B1E98 5cb2020c jal        0xac970
000B1E9C c8148424 addiu      $a0, $a0, 0x14c8
000B1EA0 4000b4c7 lwc1       $f20, 0x40($sp)
000B1EA4 4400b6c7 lwc1       $f22, 0x44($sp)
000B1EA8 4800b08f lw         $s0, 0x48($sp)
000B1EAC 4c00b18f lw         $s1, 0x4c($sp)
000B1EB0 5000b28f lw         $s2, 0x50($sp)
000B1EB4 5400bf8f lw         $ra, 0x54($sp)
000B1EB8 0800e003 jr         $ra
000B1EBC 6000bd27 addiu      $sp, $sp, 0x60
000B1EC0 c0ffbd27 addiu      $sp, $sp, -0x40
000B1EC4 2400b0af sw         $s0, 0x24($sp)
000B1EC8 2d00103c lui        $s0, 0x2d
000B1ECC 2800b1af sw         $s1, 0x28($sp)
000B1ED0 6c15048e lw         $a0, 0x156c($s0)
000B1ED4 2d00113c lui        $s1, 0x2d
000B1ED8 80bf053c lui        $a1, 0xbf80
000B1EDC 2000b4e7 swc1       $f20, 0x20($sp)
000B1EE0 2c00b2af sw         $s2, 0x2c($sp)
000B1EE4 00a08544 mtc1       $a1, $f20

000B2438 0800e003 jr         $ra
000B243C 00000000 nop        
000B2440 f0ffbd27 addiu      $sp, $sp, -0x10
000B2444 0000bfaf sw         $ra, ($sp)
000B2448 0ec9020c jal        0xb2438
000B244C 00000000 nop        
000B2450 0000bf8f lw         $ra, ($sp)
000B2454 0800e003 jr         $ra
000B2458 1000bd27 addiu      $sp, $sp, 0x10
000B245C 0800e003 jr         $ra
000B2460 00000000 nop        
000B2464 e0ffbd27 addiu      $sp, $sp, -0x20
000B2468 1000bfaf sw         $ra, 0x10($sp)
000B246C 1b67040c jal        0x119c6c
000B2470 00000000 nop        
000B2474 2d00043c lui        $a0, 0x2d
000B2478 5cb2020c jal        0xac970
000B247C 48178424 addiu      $a0, $a0, 0x1748
000B2480 1000bf8f lw         $ra, 0x10($sp)
000B2484 0800e003 jr         $ra
000B2488 2000bd27 addiu      $sp, $sp, 0x20
000B248C e0ffbd27 addiu      $sp, $sp, -0x20
000B2490 1000b0af sw         $s0, 0x10($sp)
000B2494 1400b1af sw         $s1, 0x14($sp)
000B2498 1800bfaf sw         $ra, 0x18($sp)
000B249C 5227040c jal        0x109d48
000B24A0 00000000 nop        
000B24A4 25804000 move       $s0, $v0
000B24A8 5227040c jal        0x109d48
000B24AC 25020434 ori        $a0, $zero, 0x225
000B24B0 25884000 move       $s1, $v0
000B24B4 5227040c jal        0x109d48
000B24B8 36010434 ori        $a0, $zero, 0x136
000B24BC 03000434 ori        $a0, $zero, 3
000B24C0 25280002 move       $a1, $s0
000B24C4 25302002 move       $a2, $s1

000B4E5C 25206002 move       $a0, $s3
000B4E60 3c00a48f lw         $a0, 0x3c($sp)
000B4E64 002c0200 sll        $a1, $v0, 0x10
000B4E68 00240400 sll        $a0, $a0, 0x10
000B4E6C 03ac0400 sra        $s5, $a0, 0x10
000B4E70 03a40500 sra        $s4, $a1, 0x10
000B4E74 5227040c jal        0x109d48
000B4E78 6a010434 ori        $a0, $zero, 0x16a
000B4E7C 25208002 move       $a0, $s4
000B4E80 2528a002 move       $a1, $s5
000B4E84 9477020c jal        0x9de50
000B4E88 25304000 move       $a2, $v0
000B4E8C 4c73020c jal        0x9cd30
000B4E90 00000000 nop        
000B4E94 f572020c jal        0x9cbd4
000B4E98 00000000 nop        
000B4E9C 5cb2020c jal        0xac970
000B4EA0 25202002 move       $a0, $s1
000B4EA4 27004012 beqz       $s2, 0xb4f44
000B4EA8 00000000 nop        
000B4EAC 3489000c jal        0x224d0
000B4EB0 d000448e lw         $a0, 0xd0($s2)
000B4EB4 25a04000 move       $s4, $v0
000B4EB8 22008012 beqz       $s4, 0xb4f44
000B4EBC 00000000 nop        
000B4EC0 3b89000c jal        0x224ec
000B4EC4 d000448e lw         $a0, 0xd0($s2)
000B4EC8 25a84000 move       $s5, $v0
000B4ECC 06a30046 mov.s      $f12, $f20
000B4ED0 aa010434 ori        $a0, $zero, 0x1aa
000B4ED4 f583020c jal        0xa0fd4
000B4ED8 25286002 move       $a1, $s3
000B4EDC 07000434 ori        $a0, $zero, 7
000B4EE0 25286002 move       $a1, $s3
000B4EE4 137f020c jal        0x9fc4c
000B4EE8 ffff0624 addiu      $a2, $zero, -1

000B55E0 0800e003 jr         $ra
000B55E4 1000bd27 addiu      $sp, $sp, 0x10
000B55E8 0800e003 jr         $ra
000B55EC 00000000 nop        
000B55F0 f0ffbd27 addiu      $sp, $sp, -0x10
000B55F4 0000bfaf sw         $ra, ($sp)
000B55F8 7ad5020c jal        0xb55e8
000B55FC 00000000 nop        
000B5600 0000bf8f lw         $ra, ($sp)
000B5604 0800e003 jr         $ra
000B5608 1000bd27 addiu      $sp, $sp, 0x10
000B560C 0800e003 jr         $ra
000B5610 00000000 nop        
000B5614 e0ffbd27 addiu      $sp, $sp, -0x20
000B5618 2d00043c lui        $a0, 0x2d
000B561C 1000bfaf sw         $ra, 0x10($sp)
000B5620 5cb2020c jal        0xac970
000B5624 a42d8424 addiu      $a0, $a0, 0x2da4
000B5628 1000bf8f lw         $ra, 0x10($sp)
000B562C 0800e003 jr         $ra
000B5630 2000bd27 addiu      $sp, $sp, 0x20
000B5634 e0ffbd27 addiu      $sp, $sp, -0x20
000B5638 1000b0af sw         $s0, 0x10($sp)
000B563C 1400b1af sw         $s1, 0x14($sp)
000B5640 1800bfaf sw         $ra, 0x18($sp)
000B5644 12e1010c jal        0x78448
000B5648 106b0434 ori        $a0, $zero, 0x6b10
000B564C 25204000 move       $a0, $v0
000B5650 2d00113c lui        $s1, 0x2d
000B5654 08008530 andi       $a1, $a0, 8
000B5658 0a00a010 beqz       $a1, 0xb5684
000B565C a42d3026 addiu      $s0, $s1, 0x2da4
000B5660 24a4020c jal        0xa9090
000B5664 25200000 move       $a0, $zero
000B5668 24a4020c jal        0xa9090
000B566C 07000434 ori        $a0, $zero, 7

000B5904 1000a48f lw         $a0, 0x10($sp)
000B5908 1c00a58f lw         $a1, 0x1c($sp)
000B590C 00240400 sll        $a0, $a0, 0x10
000B5910 03840400 sra        $s0, $a0, 0x10
000B5914 00240500 sll        $a0, $a1, 0x10
000B5918 038c0400 sra        $s1, $a0, 0x10
000B591C 5227040c jal        0x109d48
000B5920 e5010434 ori        $a0, $zero, 0x1e5
000B5924 25200002 move       $a0, $s0
000B5928 25282002 move       $a1, $s1
000B592C 3e75020c jal        0x9d4f8
000B5930 25304000 move       $a2, $v0
000B5934 6c72020c jal        0x9c9b0
000B5938 25200000 move       $a0, $zero
000B593C 0400043c lui        $a0, 4
000B5940 5c619024 addiu      $s0, $a0, 0x615c
000B5944 5cb2020c jal        0xac970
000B5948 25200002 move       $a0, $s0
000B594C 6c72020c jal        0x9c9b0
000B5950 01000434 ori        $a0, $zero, 1
000B5954 fcb1020c jal        0xac7f0
000B5958 25200002 move       $a0, $s0
000B595C 25904000 move       $s2, $v0
000B5960 1a004012 beqz       $s2, 0xb59cc
000B5964 00000000 nop        
000B5968 5227040c jal        0x109d48
000B596C d000448e lw         $a0, 0xd0($s2)
000B5970 0400113c lui        $s1, 4
000B5974 00623126 addiu      $s1, $s1, 0x6200
000B5978 140022ae sw         $v0, 0x14($s1)
000B597C 2d00103c lui        $s0, 0x2d
000B5980 4c2e048e lw         $a0, 0x2e4c($s0)
000B5984 04009210 beq        $a0, $s2, 0xb5998
000B5988 00000000 nop        
000B598C bf7a020c jal        0x9eafc
000B5990 25202002 move       $a0, $s1

000B5DD4 1000a48f lw         $a0, 0x10($sp)
000B5DD8 1c00a58f lw         $a1, 0x1c($sp)
000B5DDC 00240400 sll        $a0, $a0, 0x10
000B5DE0 03840400 sra        $s0, $a0, 0x10
000B5DE4 00240500 sll        $a0, $a1, 0x10
000B5DE8 038c0400 sra        $s1, $a0, 0x10
000B5DEC 5227040c jal        0x109d48
000B5DF0 e5010434 ori        $a0, $zero, 0x1e5
000B5DF4 25200002 move       $a0, $s0
000B5DF8 25282002 move       $a1, $s1
000B5DFC 3e75020c jal        0x9d4f8
000B5E00 25304000 move       $a2, $v0
000B5E04 6c72020c jal        0x9c9b0
000B5E08 25200000 move       $a0, $zero
000B5E0C 0400043c lui        $a0, 4
000B5E10 54629024 addiu      $s0, $a0, 0x6254
000B5E14 5cb2020c jal        0xac970
000B5E18 25200002 move       $a0, $s0
000B5E1C 6c72020c jal        0x9c9b0
000B5E20 01000434 ori        $a0, $zero, 1
000B5E24 fcb1020c jal        0xac7f0
000B5E28 25200002 move       $a0, $s0
000B5E2C 25984000 move       $s3, $v0
000B5E30 2d006012 beqz       $s3, 0xb5ee8
000B5E34 00000000 nop        
000B5E38 d000648e lw         $a0, 0xd0($s3)
000B5E3C 0400113c lui        $s1, 4
000B5E40 78ff0524 addiu      $a1, $zero, -0x88
000B5E44 f8623126 addiu      $s1, $s1, 0x62f8
000B5E48 1c008514 bne        $a0, $a1, 0xb5ebc
000B5E4C 2d00103c lui        $s0, 0x2d
000B5E50 b6000434 ori        $a0, $zero, 0xb6
000B5E54 9d85000c jal        0x21674
000B5E58 ff000534 ori        $a1, $zero, 0xff
000B5E5C 5f01000c jal        0x57c
000B5E60 25204000 move       $a0, $v0

000B6440 a000bd27 addiu      $sp, $sp, 0xa0
000B6444 f0ffbd27 addiu      $sp, $sp, -0x10
000B6448 0000bfaf sw         $ra, ($sp)
000B644C b26d020c jal        0x9b6c8
000B6450 00000000 nop        
000B6454 04004010 beqz       $v0, 0xb6468
000B6458 00000000 nop        
000B645C 2d00043c lui        $a0, 0x2d
000B6460 dc348424 addiu      $a0, $a0, 0x34dc
000B6464 080080ac sw         $zero, 8($a0)
000B6468 0000bf8f lw         $ra, ($sp)
000B646C 0800e003 jr         $ra
000B6470 1000bd27 addiu      $sp, $sp, 0x10
000B6474 e0ffbd27 addiu      $sp, $sp, -0x20
000B6478 2d00043c lui        $a0, 0x2d
000B647C 1000bfaf sw         $ra, 0x10($sp)
000B6480 5cb2020c jal        0xac970
000B6484 dc348424 addiu      $a0, $a0, 0x34dc
000B6488 1000bf8f lw         $ra, 0x10($sp)
000B648C 0800e003 jr         $ra
000B6490 2000bd27 addiu      $sp, $sp, 0x20
000B6494 e0ffbd27 addiu      $sp, $sp, -0x20
000B6498 1000b0af sw         $s0, 0x10($sp)
000B649C 1400b1af sw         $s1, 0x14($sp)
000B64A0 1800bfaf sw         $ra, 0x18($sp)
000B64A4 12e1010c jal        0x78448
000B64A8 106b0434 ori        $a0, $zero, 0x6b10
000B64AC 25204000 move       $a0, $v0
000B64B0 2d00113c lui        $s1, 0x2d
000B64B4 08108530 andi       $a1, $a0, 0x1008
000B64B8 0a00a010 beqz       $a1, 0xb64e4
000B64BC dc343026 addiu      $s0, $s1, 0x34dc
000B64C0 24a4020c jal        0xa9090
000B64C4 25200000 move       $a0, $zero
000B64C8 24a4020c jal        0xa9090
000B64CC 07000434 ori        $a0, $zero, 7

000B6820 2528a002 move       $a1, $s5
000B6824 01000434 ori        $a0, $zero, 1
000B6828 2528a002 move       $a1, $s5
000B682C 0c31040c jal        0x10c430
000B6830 ffff0624 addiu      $a2, $zero, -1
000B6834 5227040c jal        0x109d48
000B6838 d000648e lw         $a0, 0xd0($s3)
000B683C 140022ae sw         $v0, 0x14($s1)
000B6840 b035048e lw         $a0, 0x35b0($s0)
000B6844 04009310 beq        $a0, $s3, 0xb6858
000B6848 00000000 nop        
000B684C bf7a020c jal        0x9eafc
000B6850 25202002 move       $a0, $s1
000B6854 b03513ae sw         $s3, 0x35b0($s0)
000B6858 198c020c jal        0xa3064
000B685C 25202002 move       $a0, $s1
000B6860 5cb2020c jal        0xac970
000B6864 25208002 move       $a0, $s4
000B6868 c6010434 ori        $a0, $zero, 0x1c6
000B686C 06a30046 mov.s      $f12, $f20
000B6870 f583020c jal        0xa0fd4
000B6874 2528a002 move       $a1, $s5
000B6878 1800a48f lw         $a0, 0x18($sp)
000B687C 1c00a58f lw         $a1, 0x1c($sp)
000B6880 00240400 sll        $a0, $a0, 0x10
000B6884 03840400 sra        $s0, $a0, 0x10
000B6888 00240500 sll        $a0, $a1, 0x10
000B688C 038c0400 sra        $s1, $a0, 0x10
000B6890 5227040c jal        0x109d48
000B6894 e8000434 ori        $a0, $zero, 0xe8
000B6898 25200002 move       $a0, $s0
000B689C 25282002 move       $a1, $s1
000B68A0 2979020c jal        0x9e4a4
000B68A4 25304000 move       $a2, $v0
000B68A8 16006012 beqz       $s3, 0xb6904
000B68AC 00000000 nop        

000B7DD0 00000000 nop        
000B7DD4 dad8020c jal        0xb6368
000B7DD8 00000000 nop        
000B7DDC 0b2b040c jal        0x10ac2c
000B7DE0 25200002 move       $a0, $s0
000B7DE4 2c00043c lui        $a0, 0x2c
000B7DE8 001d848c lw         $a0, 0x1d00($a0)
000B7DEC 3d2c040c jal        0x10b0f4
000B7DF0 3800848c lw         $a0, 0x38($a0)
000B7DF4 1000b08f lw         $s0, 0x10($sp)
000B7DF8 1400bf8f lw         $ra, 0x14($sp)
000B7DFC 0800e003 jr         $ra
000B7E00 2000bd27 addiu      $sp, $sp, 0x20
000B7E04 e0ffbd27 addiu      $sp, $sp, -0x20
000B7E08 2d00043c lui        $a0, 0x2d
000B7E0C 1000bfaf sw         $ra, 0x10($sp)
000B7E10 5cb2020c jal        0xac970
000B7E14 f43b8424 addiu      $a0, $a0, 0x3bf4
000B7E18 3629040c jal        0x10a4d8
000B7E1C 01000434 ori        $a0, $zero, 1
000B7E20 1000bf8f lw         $ra, 0x10($sp)
000B7E24 0800e003 jr         $ra
000B7E28 2000bd27 addiu      $sp, $sp, 0x20
000B7E2C e0ffbd27 addiu      $sp, $sp, -0x20
000B7E30 2c00043c lui        $a0, 0x2c
000B7E34 001d848c lw         $a0, 0x1d00($a0)
000B7E38 1000b0af sw         $s0, 0x10($sp)
000B7E3C 2d00103c lui        $s0, 0x2d
000B7E40 1400bfaf sw         $ra, 0x14($sp)
000B7E44 07008010 beqz       $a0, 0xb7e64
000B7E48 48381026 addiu      $s0, $s0, 0x3848
000B7E4C 834b000c jal        0x12e0c
000B7E50 2c1c848c lw         $a0, 0x1c2c($a0)
000B7E54 03004010 beqz       $v0, 0xb7e64
000B7E58 00000000 nop        
000B7E5C 03000010 b          0xb7e6c

000BAF78 0800e003 jr         $ra
000BAF7C 2001bd27 addiu      $sp, $sp, 0x120
000BAF80 0800e003 jr         $ra
000BAF84 00000000 nop        
000BAF88 f0ffbd27 addiu      $sp, $sp, -0x10
000BAF8C 0000bfaf sw         $ra, ($sp)
000BAF90 e0eb020c jal        0xbaf80
000BAF94 00000000 nop        
000BAF98 0000bf8f lw         $ra, ($sp)
000BAF9C 0800e003 jr         $ra
000BAFA0 1000bd27 addiu      $sp, $sp, 0x10
000BAFA4 0800e003 jr         $ra
000BAFA8 00000000 nop        
000BAFAC e0ffbd27 addiu      $sp, $sp, -0x20
000BAFB0 2d00043c lui        $a0, 0x2d
000BAFB4 1000bfaf sw         $ra, 0x10($sp)
000BAFB8 5cb2020c jal        0xac970
000BAFBC dc448424 addiu      $a0, $a0, 0x44dc
000BAFC0 1000bf8f lw         $ra, 0x10($sp)
000BAFC4 0800e003 jr         $ra
000BAFC8 2000bd27 addiu      $sp, $sp, 0x20
000BAFCC e0ffbd27 addiu      $sp, $sp, -0x20
000BAFD0 1000b0af sw         $s0, 0x10($sp)
000BAFD4 1400b1af sw         $s1, 0x14($sp)
000BAFD8 1800bfaf sw         $ra, 0x18($sp)
000BAFDC 12e1010c jal        0x78448
000BAFE0 106b0434 ori        $a0, $zero, 0x6b10
000BAFE4 25204000 move       $a0, $v0
000BAFE8 2d00113c lui        $s1, 0x2d
000BAFEC 08008530 andi       $a1, $a0, 8
000BAFF0 0a00a010 beqz       $a1, 0xbb01c
000BAFF4 dc443026 addiu      $s0, $s1, 0x44dc
000BAFF8 24a4020c jal        0xa9090
000BAFFC 25200000 move       $a0, $zero
000BB000 24a4020c jal        0xa9090
000BB004 07000434 ori        $a0, $zero, 7

000BB3B0 25280002 move       $a1, $s0
000BB3B4 1000a48f lw         $a0, 0x10($sp)
000BB3B8 1c00a58f lw         $a1, 0x1c($sp)
000BB3BC 00240400 sll        $a0, $a0, 0x10
000BB3C0 038c0400 sra        $s1, $a0, 0x10
000BB3C4 00240500 sll        $a0, $a1, 0x10
000BB3C8 03940400 sra        $s2, $a0, 0x10
000BB3CC 5227040c jal        0x109d48
000BB3D0 39010434 ori        $a0, $zero, 0x139
000BB3D4 25202002 move       $a0, $s1
000BB3D8 25284002 move       $a1, $s2
000BB3DC 3e75020c jal        0x9d4f8
000BB3E0 25304000 move       $a2, $v0
000BB3E4 6c72020c jal        0x9c9b0
000BB3E8 25200000 move       $a0, $zero
000BB3EC 0400043c lui        $a0, 4
000BB3F0 5cb2020c jal        0xac970
000BB3F4 006a8424 addiu      $a0, $a0, 0x6a00
000BB3F8 6c72020c jal        0x9c9b0
000BB3FC 01000434 ori        $a0, $zero, 1
000BB400 6472020c jal        0x9c990
000BB404 ffff0424 addiu      $a0, $zero, -1
000BB408 6e010434 ori        $a0, $zero, 0x16e
000BB40C 06a30046 mov.s      $f12, $f20
000BB410 f583020c jal        0xa0fd4
000BB414 25280002 move       $a1, $s0
000BB418 3a8a020c jal        0xa28e8
000BB41C 25200002 move       $a0, $s0
000BB420 1c00a48f lw         $a0, 0x1c($sp)
000BB424 002c0200 sll        $a1, $v0, 0x10
000BB428 00240400 sll        $a0, $a0, 0x10
000BB42C 03940400 sra        $s2, $a0, 0x10
000BB430 038c0500 sra        $s1, $a1, 0x10
000BB434 5227040c jal        0x109d48
000BB438 d6010434 ori        $a0, $zero, 0x1d6
000BB43C 25202002 move       $a0, $s1

000BBF34 03240400 sra        $a0, $a0, 0x10
000BBF38 032c0500 sra        $a1, $a1, 0x10
000BBF3C 2979020c jal        0x9e4a4
000BBF40 2530c002 move       $a2, $s6
000BBF44 33020434 ori        $a0, $zero, 0x233
000BBF48 06a30046 mov.s      $f12, $f20
000BBF4C f583020c jal        0xa0fd4
000BBF50 25286002 move       $a1, $s3
000BBF54 07000434 ori        $a0, $zero, 7
000BBF58 25286002 move       $a1, $s3
000BBF5C 137f020c jal        0x9fc4c
000BBF60 ffff0624 addiu      $a2, $zero, -1
000BBF64 6472020c jal        0x9c990
000BBF68 ffff0424 addiu      $a0, $zero, -1
000BBF6C 6c72020c jal        0x9c9b0
000BBF70 25200000 move       $a0, $zero
000BBF74 5cb2020c jal        0xac970
000BBF78 25200002 move       $a0, $s0
000BBF7C 6c72020c jal        0x9c9b0
000BBF80 01000434 ori        $a0, $zero, 1
000BBF84 2d00043c lui        $a0, 0x2d
000BBF88 9af2020c jal        0xbca68
000BBF8C 0c578cc4 lwc1       $f12, 0x570c($a0)
000BBF90 6000b4c7 lwc1       $f20, 0x60($sp)
000BBF94 6400b08f lw         $s0, 0x64($sp)
000BBF98 6800b18f lw         $s1, 0x68($sp)
000BBF9C 6c00b28f lw         $s2, 0x6c($sp)
000BBFA0 7000b38f lw         $s3, 0x70($sp)
000BBFA4 7400b48f lw         $s4, 0x74($sp)
000BBFA8 7800b58f lw         $s5, 0x78($sp)
000BBFAC 7c00b68f lw         $s6, 0x7c($sp)
000BBFB0 8000b78f lw         $s7, 0x80($sp)
000BBFB4 8400bf8f lw         $ra, 0x84($sp)
000BBFB8 0800e003 jr         $ra
000BBFBC 9000bd27 addiu      $sp, $sp, 0x90
000BBFC0 c0ffbd27 addiu      $sp, $sp, -0x40

000BD26C 1800a48f lw         $a0, 0x18($sp)
000BD270 2400a58f lw         $a1, 0x24($sp)
000BD274 00240400 sll        $a0, $a0, 0x10
000BD278 03840400 sra        $s0, $a0, 0x10
000BD27C 00240500 sll        $a0, $a1, 0x10
000BD280 038c0400 sra        $s1, $a0, 0x10
000BD284 5227040c jal        0x109d48
000BD288 e5010434 ori        $a0, $zero, 0x1e5
000BD28C 25200002 move       $a0, $s0
000BD290 25282002 move       $a1, $s1
000BD294 3e75020c jal        0x9d4f8
000BD298 25304000 move       $a2, $v0
000BD29C 6c72020c jal        0x9c9b0
000BD2A0 25200000 move       $a0, $zero
000BD2A4 0400043c lui        $a0, 4
000BD2A8 f86c9024 addiu      $s0, $a0, 0x6cf8
000BD2AC 5cb2020c jal        0xac970
000BD2B0 25200002 move       $a0, $s0
000BD2B4 6c72020c jal        0x9c9b0
000BD2B8 01000434 ori        $a0, $zero, 1
000BD2BC 26020434 ori        $a0, $zero, 0x226
000BD2C0 06a30046 mov.s      $f12, $f20
000BD2C4 f583020c jal        0xa0fd4
000BD2C8 25286002 move       $a1, $s3
000BD2CC 0000043c lui        $a0, 0
000BD2D0 1000b127 addiu      $s1, $sp, 0x10
000BD2D4 a4028690 lbu        $a2, 0x2a4($a0)
000BD2D8 1d00053c lui        $a1, 0x1d
000BD2DC 25202002 move       $a0, $s1
000BD2E0 19000734 ori        $a3, $zero, 0x19
000BD2E4 1100070c jal        0x1c0044
000BD2E8 8071a524 addiu      $a1, $a1, 0x7180
000BD2EC 1800a48f lw         $a0, 0x18($sp)
000BD2F0 2400a58f lw         $a1, 0x24($sp)
000BD2F4 00240400 sll        $a0, $a0, 0x10
000BD2F8 002c0500 sll        $a1, $a1, 0x10

000BDADC 1000a48f lw         $a0, 0x10($sp)
000BDAE0 1c00a58f lw         $a1, 0x1c($sp)
000BDAE4 00240400 sll        $a0, $a0, 0x10
000BDAE8 038c0400 sra        $s1, $a0, 0x10
000BDAEC 00240500 sll        $a0, $a1, 0x10
000BDAF0 03940400 sra        $s2, $a0, 0x10
000BDAF4 5227040c jal        0x109d48
000BDAF8 18020434 ori        $a0, $zero, 0x218
000BDAFC 25202002 move       $a0, $s1
000BDB00 25284002 move       $a1, $s2
000BDB04 3e75020c jal        0x9d4f8
000BDB08 25304000 move       $a2, $v0
000BDB0C 6c72020c jal        0x9c9b0
000BDB10 25200000 move       $a0, $zero
000BDB14 0400043c lui        $a0, 4
000BDB18 f0719124 addiu      $s1, $a0, 0x71f0
000BDB1C 5cb2020c jal        0xac970
000BDB20 25202002 move       $a0, $s1
000BDB24 6c72020c jal        0x9c9b0
000BDB28 01000434 ori        $a0, $zero, 1
000BDB2C fcb1020c jal        0xac7f0
000BDB30 25202002 move       $a0, $s1
000BDB34 25204000 move       $a0, $v0
000BDB38 11008010 beqz       $a0, 0xbdb80
000BDB3C 00000000 nop        
000BDB40 d400848c lw         $a0, 0xd4($a0)
000BDB44 2d00053c lui        $a1, 0x2d
000BDB48 00210400 sll        $a0, $a0, 4
000BDB4C 8058a524 addiu      $a1, $a1, 0x5880
000BDB50 21208500 addu       $a0, $a0, $a1
000BDB54 0c00848c lw         $a0, 0xc($a0)
000BDB58 09008010 beqz       $a0, 0xbdb80
000BDB5C 00000000 nop        
000BDB60 7a010434 ori        $a0, $zero, 0x17a
000BDB64 06a30046 mov.s      $f12, $f20
000BDB68 f583020c jal        0xa0fd4

000C3848 06a30046 mov.s      $f12, $f20
000C384C f583020c jal        0xa0fd4
000C3850 25286002 move       $a1, $s3
000C3854 2000a48f lw         $a0, 0x20($sp)
000C3858 2c00a58f lw         $a1, 0x2c($sp)
000C385C 00240400 sll        $a0, $a0, 0x10
000C3860 038c0400 sra        $s1, $a0, 0x10
000C3864 00240500 sll        $a0, $a1, 0x10
000C3868 1476458e lw         $a1, 0x7614($s2)
000C386C 03940400 sra        $s2, $a0, 0x10
000C3870 5227040c jal        0x109d48
000C3874 2520a000 move       $a0, $a1
000C3878 25202002 move       $a0, $s1
000C387C 25284002 move       $a1, $s2
000C3880 3e75020c jal        0x9d4f8
000C3884 25304000 move       $a2, $v0
000C3888 5cb2020c jal        0xac970
000C388C 25200002 move       $a0, $s0
000C3890 3002b4c7 lwc1       $f20, 0x230($sp)
000C3894 3402b08f lw         $s0, 0x234($sp)
000C3898 3802b18f lw         $s1, 0x238($sp)
000C389C 3c02b28f lw         $s2, 0x23c($sp)
000C38A0 4002b38f lw         $s3, 0x240($sp)
000C38A4 4402b48f lw         $s4, 0x244($sp)
000C38A8 4802b58f lw         $s5, 0x248($sp)
000C38AC 4c02b68f lw         $s6, 0x24c($sp)
000C38B0 5002bf8f lw         $ra, 0x250($sp)
000C38B4 0800e003 jr         $ra
000C38B8 6002bd27 addiu      $sp, $sp, 0x260
000C38BC 80ffbd27 addiu      $sp, $sp, -0x80
000C38C0 6800b5af sw         $s5, 0x68($sp)
000C38C4 0400153c lui        $s5, 4
000C38C8 7400beaf sw         $fp, 0x74($sp)
000C38CC 3476b526 addiu      $s5, $s5, 0x7634
000C38D0 2d001e3c lui        $fp, 0x2d
000C38D4 5400b0af sw         $s0, 0x54($sp)

000C47E8 1100070c jal        0x1c0044
000C47EC 2528c002 move       $a1, $s6
000C47F0 3a8a020c jal        0xa28e8
000C47F4 25208002 move       $a0, $s4
000C47F8 3c00a58f lw         $a1, 0x3c($sp)
000C47FC 00240200 sll        $a0, $v0, 0x10
000C4800 002c0500 sll        $a1, $a1, 0x10
000C4804 03240400 sra        $a0, $a0, 0x10
000C4808 032c0500 sra        $a1, $a1, 0x10
000C480C 9477020c jal        0x9de50
000C4810 25304002 move       $a2, $s2
000C4814 0400a48e lw         $a0, 4($s5)
000C4818 01003126 addiu      $s1, $s1, 1
000C481C 2b202402 sltu       $a0, $s1, $a0
000C4820 bbff8014 bnez       $a0, 0xc4710
000C4824 00000000 nop        
000C4828 5cb2020c jal        0xac970
000C482C 2520a002 move       $a0, $s5
000C4830 4002b4c7 lwc1       $f20, 0x240($sp)
000C4834 4402b6c7 lwc1       $f22, 0x244($sp)
000C4838 4802b8c7 lwc1       $f24, 0x248($sp)
000C483C 4c02bac7 lwc1       $f26, 0x24c($sp)
000C4840 5002b08f lw         $s0, 0x250($sp)
000C4844 5402b18f lw         $s1, 0x254($sp)
000C4848 5802b28f lw         $s2, 0x258($sp)
000C484C 5c02b38f lw         $s3, 0x25c($sp)
000C4850 6002b48f lw         $s4, 0x260($sp)
000C4854 6402b58f lw         $s5, 0x264($sp)
000C4858 6802b68f lw         $s6, 0x268($sp)
000C485C 6c02b78f lw         $s7, 0x26c($sp)
000C4860 7002be8f lw         $fp, 0x270($sp)
000C4864 7402bf8f lw         $ra, 0x274($sp)
000C4868 0800e003 jr         $ra
000C486C 8002bd27 addiu      $sp, $sp, 0x280
000C4870 0800e003 jr         $ra
000C4874 00000000 nop        

000C4868 0800e003 jr         $ra
000C486C 8002bd27 addiu      $sp, $sp, 0x280
000C4870 0800e003 jr         $ra
000C4874 00000000 nop        
000C4878 f0ffbd27 addiu      $sp, $sp, -0x10
000C487C 0000bfaf sw         $ra, ($sp)
000C4880 1c12030c jal        0xc4870
000C4884 00000000 nop        
000C4888 0000bf8f lw         $ra, ($sp)
000C488C 0800e003 jr         $ra
000C4890 1000bd27 addiu      $sp, $sp, 0x10
000C4894 0800e003 jr         $ra
000C4898 00000000 nop        
000C489C e0ffbd27 addiu      $sp, $sp, -0x20
000C48A0 2d00043c lui        $a0, 0x2d
000C48A4 1000bfaf sw         $ra, 0x10($sp)
000C48A8 5cb2020c jal        0xac970
000C48AC f87b8424 addiu      $a0, $a0, 0x7bf8
000C48B0 1000bf8f lw         $ra, 0x10($sp)
000C48B4 0800e003 jr         $ra
000C48B8 2000bd27 addiu      $sp, $sp, 0x20
000C48BC e0ffbd27 addiu      $sp, $sp, -0x20
000C48C0 1000b0af sw         $s0, 0x10($sp)
000C48C4 1400b1af sw         $s1, 0x14($sp)
000C48C8 1800bfaf sw         $ra, 0x18($sp)
000C48CC 5227040c jal        0x109d48
000C48D0 00000000 nop        
000C48D4 25804000 move       $s0, $v0
000C48D8 5227040c jal        0x109d48
000C48DC 25020434 ori        $a0, $zero, 0x225
000C48E0 25884000 move       $s1, $v0
000C48E4 5227040c jal        0x109d48
000C48E8 36010434 ori        $a0, $zero, 0x136
000C48EC 03000434 ori        $a0, $zero, 3
000C48F0 25280002 move       $a1, $s0
000C48F4 25302002 move       $a2, $s1

000C4BC8 0800e003 jr         $ra
000C4BCC 2000bd27 addiu      $sp, $sp, 0x20
000C4BD0 0800e003 jr         $ra
000C4BD4 00000000 nop        
000C4BD8 f0ffbd27 addiu      $sp, $sp, -0x10
000C4BDC 0000bfaf sw         $ra, ($sp)
000C4BE0 f412030c jal        0xc4bd0
000C4BE4 00000000 nop        
000C4BE8 0000bf8f lw         $ra, ($sp)
000C4BEC 0800e003 jr         $ra
000C4BF0 1000bd27 addiu      $sp, $sp, 0x10
000C4BF4 0800e003 jr         $ra
000C4BF8 00000000 nop        
000C4BFC e0ffbd27 addiu      $sp, $sp, -0x20
000C4C00 2d00043c lui        $a0, 0x2d
000C4C04 1000bfaf sw         $ra, 0x10($sp)
000C4C08 5cb2020c jal        0xac970
000C4C0C 607f8424 addiu      $a0, $a0, 0x7f60
000C4C10 1000bf8f lw         $ra, 0x10($sp)
000C4C14 0800e003 jr         $ra
000C4C18 2000bd27 addiu      $sp, $sp, 0x20
000C4C1C e0ffbd27 addiu      $sp, $sp, -0x20
000C4C20 1000b0af sw         $s0, 0x10($sp)
000C4C24 1400b1af sw         $s1, 0x14($sp)
000C4C28 1800bfaf sw         $ra, 0x18($sp)
000C4C2C 5227040c jal        0x109d48
000C4C30 00000000 nop        
000C4C34 25804000 move       $s0, $v0
000C4C38 5227040c jal        0x109d48
000C4C3C 25020434 ori        $a0, $zero, 0x225
000C4C40 25884000 move       $s1, $v0
000C4C44 5227040c jal        0x109d48
000C4C48 36010434 ori        $a0, $zero, 0x136
000C4C4C 03000434 ori        $a0, $zero, 3
000C4C50 25280002 move       $a1, $s0
000C4C54 25302002 move       $a2, $s1

000C5024 f583020c jal        0xa0fd4
000C5028 25280002 move       $a1, $s0
000C502C 3a8a020c jal        0xa28e8
000C5030 25200002 move       $a0, $s0
000C5034 1c00a48f lw         $a0, 0x1c($sp)
000C5038 002c0200 sll        $a1, $v0, 0x10
000C503C 00240400 sll        $a0, $a0, 0x10
000C5040 03940400 sra        $s2, $a0, 0x10
000C5044 038c0500 sra        $s1, $a1, 0x10
000C5048 5227040c jal        0x109d48
000C504C 6a010434 ori        $a0, $zero, 0x16a
000C5050 25202002 move       $a0, $s1
000C5054 25284002 move       $a1, $s2
000C5058 9477020c jal        0x9de50
000C505C 25304000 move       $a2, $v0
000C5060 0400043c lui        $a0, 4
000C5064 5cb2020c jal        0xac970
000C5068 80778424 addiu      $a0, $a0, 0x7780
000C506C 9b020434 ori        $a0, $zero, 0x29b
000C5070 06a30046 mov.s      $f12, $f20
000C5074 f583020c jal        0xa0fd4
000C5078 25280002 move       $a1, $s0
000C507C 1000a48f lw         $a0, 0x10($sp)
000C5080 1c00a58f lw         $a1, 0x1c($sp)
000C5084 00240400 sll        $a0, $a0, 0x10
000C5088 038c0400 sra        $s1, $a0, 0x10
000C508C 00240500 sll        $a0, $a1, 0x10
000C5090 03940400 sra        $s2, $a0, 0x10
000C5094 5227040c jal        0x109d48
000C5098 41010434 ori        $a0, $zero, 0x141
000C509C 25202002 move       $a0, $s1
000C50A0 25284002 move       $a1, $s2
000C50A4 3e75020c jal        0x9d4f8
000C50A8 25304000 move       $a2, $v0
000C50AC 9d020434 ori        $a0, $zero, 0x29d
000C50B0 06a30046 mov.s      $f12, $f20