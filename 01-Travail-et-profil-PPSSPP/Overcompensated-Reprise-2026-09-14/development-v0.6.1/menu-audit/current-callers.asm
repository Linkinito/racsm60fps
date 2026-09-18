000B0720 25300000 move       $a2, $zero
000B0724 b100000c jal        0x2c4
000B0728 01000734 ori        $a3, $zero, 1
000B072C 24a4020c jal        0xa9090
000B0730 01000434 ori        $a0, $zero, 1
000B0734 1000b08f lw         $s0, 0x10($sp)
000B0738 1400bf8f lw         $ra, 0x14($sp)
000B073C 0800e003 jr         $ra
000B0740 2000bd27 addiu      $sp, $sp, 0x20
000B0744 d0ffbd27 addiu      $sp, $sp, -0x30
000B0748 2800b2af sw         $s2, 0x28($sp)
000B074C 0400123c lui        $s2, 4
000B0750 785e5226 addiu      $s2, $s2, 0x5e78
000B0754 2000b0af sw         $s0, 0x20($sp)
000B0758 2400b1af sw         $s1, 0x24($sp)
000B075C 2c00bfaf sw         $ra, 0x2c($sp)
000B0760 fcb1020c jal        0xac7f0
000B0764 25204002 move       $a0, $s2
000B0768 25804000 move       $s0, $v0
000B076C 12e1010c jal        0x78448
000B0770 106b0434 ori        $a0, $zero, 0x6b10
000B0774 25884000 move       $s1, $v0
000B0778 00e1010c jal        0x78400
000B077C 106b0434 ori        $a0, $zero, 0x6b10
000B0780 25204000 move       $a0, $v0
000B0784 00028530 andi       $a1, $a0, 0x200
000B0788 1d00a010 beqz       $a1, 0xb0800
000B078C 00000000 nop        
000B0790 2d00043c lui        $a0, 0x2d
000B0794 e4088ec4 lwc1       $f14, 0x8e4($a0)
000B0798 2d00053c lui        $a1, 0x2d
000B079C e808acc4 lwc1       $f12, 0x8e8($a1)
000B07A0 49c0053c lui        $a1, 0xc049
000B07A4 80730c46 add.s      $f14, $f14, $f12
000B07A8 db0fa534 ori        $a1, $a1, 0xfdb
000B07AC 4940063c lui        $a2, 0x4049

000B0D78 25280002 move       $a1, $s0
000B0D7C 3a8a020c jal        0xa28e8
000B0D80 25200002 move       $a0, $s0
000B0D84 00240200 sll        $a0, $v0, 0x10
000B0D88 039c0400 sra        $s3, $a0, 0x10
000B0D8C 468a020c jal        0xa2918
000B0D90 25200002 move       $a0, $s0
000B0D94 00240200 sll        $a0, $v0, 0x10
000B0D98 0000458e lw         $a1, ($s2)
000B0D9C 03940400 sra        $s2, $a0, 0x10
000B0DA0 5227040c jal        0x109d48
000B0DA4 2520a000 move       $a0, $a1
000B0DA8 25206002 move       $a0, $s3
000B0DAC 25284002 move       $a1, $s2
000B0DB0 9477020c jal        0x9de50
000B0DB4 25304000 move       $a2, $v0
000B0DB8 fcb1020c jal        0xac7f0
000B0DBC 25202002 move       $a0, $s1
000B0DC0 25904000 move       $s2, $v0
000B0DC4 26004012 beqz       $s2, 0xb0e60
000B0DC8 00000000 nop        
000B0DCC d400538e lw         $s3, 0xd4($s2)
000B0DD0 0f006012 beqz       $s3, 0xb0e10
000B0DD4 00000000 nop        
000B0DD8 5227040c jal        0x109d48
000B0DDC 0400648e lw         $a0, 4($s3)
000B0DE0 0400133c lui        $s3, 4
000B0DE4 1c5f7326 addiu      $s3, $s3, 0x5f1c
000B0DE8 140062ae sw         $v0, 0x14($s3)
000B0DEC 2d00143c lui        $s4, 0x2d
000B0DF0 2409848e lw         $a0, 0x924($s4)
000B0DF4 04009210 beq        $a0, $s2, 0xb0e08
000B0DF8 00000000 nop        
000B0DFC bf7a020c jal        0x9eafc
000B0E00 25206002 move       $a0, $s3
000B0E04 240992ae sw         $s2, 0x924($s4)

000B40B8 3000b08f lw         $s0, 0x30($sp)
000B40BC 3400b18f lw         $s1, 0x34($sp)
000B40C0 3800b28f lw         $s2, 0x38($sp)
000B40C4 3c00b38f lw         $s3, 0x3c($sp)
000B40C8 4000b48f lw         $s4, 0x40($sp)
000B40CC 4400bf8f lw         $ra, 0x44($sp)
000B40D0 0800e003 jr         $ra
000B40D4 5000bd27 addiu      $sp, $sp, 0x50
000B40D8 e0ffbd27 addiu      $sp, $sp, -0x20
000B40DC 1000b0af sw         $s0, 0x10($sp)
000B40E0 1400b1af sw         $s1, 0x14($sp)
000B40E4 1800bfaf sw         $ra, 0x18($sp)
000B40E8 34d1020c jal        0xb44d0
000B40EC 00000000 nop        
000B40F0 0400113c lui        $s1, 4
000B40F4 64603126 addiu      $s1, $s1, 0x6064
000B40F8 fcb1020c jal        0xac7f0
000B40FC 25202002 move       $a0, $s1
000B4100 25804000 move       $s0, $v0
000B4104 12e1010c jal        0x78448
000B4108 01000434 ori        $a0, $zero, 1
000B410C 25204000 move       $a0, $v0
000B4110 08008530 andi       $a1, $a0, 8
000B4114 0a00a010 beqz       $a1, 0xb4140
000B4118 00000000 nop        
000B411C 24a4020c jal        0xa9090
000B4120 25200000 move       $a0, $zero
000B4124 5c8a000c jal        0x22970
000B4128 00000000 nop        
000B412C 04000434 ori        $a0, $zero, 4
000B4130 ff51000c jal        0x147fc
000B4134 25280000 move       $a1, $zero
000B4138 4f000010 b          0xb4278
000B413C 00000000 nop        
000B4140 00108530 andi       $a1, $a0, 0x1000
000B4144 1000a010 beqz       $a1, 0xb4188

000B4D4C 4000bd27 addiu      $sp, $sp, 0x40
000B4D50 60ffbd27 addiu      $sp, $sp, -0xa0
000B4D54 7000b0af sw         $s0, 0x70($sp)
000B4D58 0400103c lui        $s0, 4
000B4D5C 7400b1af sw         $s1, 0x74($sp)
000B4D60 64601126 addiu      $s1, $s0, 0x6064
000B4D64 6800b4e7 swc1       $f20, 0x68($sp)
000B4D68 6c00b6e7 swc1       $f22, 0x6c($sp)
000B4D6C 7800b2af sw         $s2, 0x78($sp)
000B4D70 7c00b3af sw         $s3, 0x7c($sp)
000B4D74 8000b4af sw         $s4, 0x80($sp)
000B4D78 8400b5af sw         $s5, 0x84($sp)
000B4D7C 8800b6af sw         $s6, 0x88($sp)
000B4D80 8c00b7af sw         $s7, 0x8c($sp)
000B4D84 9000beaf sw         $fp, 0x90($sp)
000B4D88 9400bfaf sw         $ra, 0x94($sp)
000B4D8C fcb1020c jal        0xac7f0
000B4D90 25202002 move       $a0, $s1
000B4D94 00a08044 mtc1       $zero, $f20
000B4D98 25904000 move       $s2, $v0
000B4D9C 2e000434 ori        $a0, $zero, 0x2e
000B4DA0 06a30046 mov.s      $f12, $f20
000B4DA4 4485020c jal        0xa1510
000B4DA8 ffff0524 addiu      $a1, $zero, -1
000B4DAC 3000b327 addiu      $s3, $sp, 0x30
000B4DB0 06a30046 mov.s      $f12, $f20
000B4DB4 ac010434 ori        $a0, $zero, 0x1ac
000B4DB8 f583020c jal        0xa0fd4
000B4DBC 25286002 move       $a1, $s3
000B4DC0 3000a48f lw         $a0, 0x30($sp)
000B4DC4 3c00a58f lw         $a1, 0x3c($sp)
000B4DC8 00240400 sll        $a0, $a0, 0x10
000B4DCC 03a40400 sra        $s4, $a0, 0x10
000B4DD0 00240500 sll        $a0, $a1, 0x10
000B4DD4 03ac0400 sra        $s5, $a0, 0x10
000B4DD8 5227040c jal        0x109d48

000B57C0 24a4020c jal        0xa9090
000B57C4 07000434 ori        $a0, $zero, 7
000B57C8 24a4020c jal        0xa9090
000B57CC 25200000 move       $a0, $zero
000B57D0 51ba020c jal        0xae944
000B57D4 00000000 nop        
000B57D8 09004014 bnez       $v0, 0xb5800
000B57DC 00000000 nop        
000B57E0 04000434 ori        $a0, $zero, 4
000B57E4 ff51000c jal        0x147fc
000B57E8 25280000 move       $a1, $zero
000B57EC 04000010 b          0xb5800
000B57F0 00000000 nop        
000B57F4 25288000 move       $a1, $a0
000B57F8 c6ae020c jal        0xabb18
000B57FC 25200002 move       $a0, $s0
000B5800 fcb1020c jal        0xac7f0
000B5804 25200002 move       $a0, $s0
000B5808 25804000 move       $s0, $v0
000B580C 07000012 beqz       $s0, 0xb582c
000B5810 00000000 nop        
000B5814 d400108e lw         $s0, 0xd4($s0)
000B5818 04000012 beqz       $s0, 0xb582c
000B581C 00000000 nop        
000B5820 25200000 move       $a0, $zero
000B5824 c530040c jal        0x10c314
000B5828 25280002 move       $a1, $s0
000B582C 1000b08f lw         $s0, 0x10($sp)
000B5830 1400bf8f lw         $ra, 0x14($sp)
000B5834 0800e003 jr         $ra
000B5838 2000bd27 addiu      $sp, $sp, 0x20
000B583C c0ffbd27 addiu      $sp, $sp, -0x40
000B5840 2000b4e7 swc1       $f20, 0x20($sp)
000B5844 00a08044 mtc1       $zero, $f20
000B5848 32000434 ori        $a0, $zero, 0x32
000B584C ffff0524 addiu      $a1, $zero, -1

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
000B5994 4c2e12ae sw         $s2, 0x2e4c($s0)
000B5998 198c020c jal        0xa3064
000B599C 25202002 move       $a0, $s1
000B59A0 d400448e lw         $a0, 0xd4($s2)

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
000B5C7C 08008530 andi       $a1, $a0, 8
000B5C80 0a00a010 beqz       $a1, 0xb5cac
000B5C84 00000000 nop        
000B5C88 24a4020c jal        0xa9090
000B5C8C 07000434 ori        $a0, $zero, 7
000B5C90 24a4020c jal        0xa9090
000B5C94 25200000 move       $a0, $zero
000B5C98 04000434 ori        $a0, $zero, 4
000B5C9C ff51000c jal        0x147fc
000B5CA0 25280000 move       $a1, $zero
000B5CA4 14000010 b          0xb5cf8
000B5CA8 00000000 nop        
000B5CAC 00108530 andi       $a1, $a0, 0x1000
000B5CB0 0e00a010 beqz       $a1, 0xb5cec
000B5CB4 00000000 nop        

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
000B5E64 25904000 move       $s2, $v0
000B5E68 0e004012 beqz       $s2, 0xb5ea4
000B5E6C d000648e lw         $a0, 0xd0($s3)
000B5E70 0400053c lui        $a1, 4

000B6654 00028530 andi       $a1, $a0, 0x200
000B6658 0b00a010 beqz       $a1, 0xb6688
000B665C 00000000 nop        
000B6660 2d00043c lui        $a0, 0x2d
000B6664 ac35858c lw         $a1, 0x35ac($a0)
000B6668 0100a524 addiu      $a1, $a1, 1
000B666C ac3585ac sw         $a1, 0x35ac($a0)
000B6670 0200a52c sltiu      $a1, $a1, 2
000B6674 0700a014 bnez       $a1, 0xb6694
000B6678 00000000 nop        
000B667C 01000534 ori        $a1, $zero, 1
000B6680 04000010 b          0xb6694
000B6684 ac3585ac sw         $a1, 0x35ac($a0)
000B6688 25288000 move       $a1, $a0
000B668C c6ae020c jal        0xabb18
000B6690 25200002 move       $a0, $s0
000B6694 fcb1020c jal        0xac7f0
000B6698 25200002 move       $a0, $s0
000B669C 25804000 move       $s0, $v0
000B66A0 16000012 beqz       $s0, 0xb66fc
000B66A4 00000000 nop        
000B66A8 d400048e lw         $a0, 0xd4($s0)
000B66AC 1800053c lui        $a1, 0x18
000B66B0 80200400 sll        $a0, $a0, 2
000B66B4 c83ba524 addiu      $a1, $a1, 0x3bc8
000B66B8 21208500 addu       $a0, $a0, $a1
000B66BC 0000908c lw         $s0, ($a0)
000B66C0 3400048e lw         $a0, 0x34($s0)
000B66C4 0d008010 beqz       $a0, 0xb66fc
000B66C8 00000000 nop        
000B66CC 3000048e lw         $a0, 0x30($s0)
000B66D0 2d00053c lui        $a1, 0x2d
000B66D4 ffff8424 addiu      $a0, $a0, -1
000B66D8 80200400 sll        $a0, $a0, 2
000B66DC 8035a524 addiu      $a1, $a1, 0x3580
000B66E0 21208500 addu       $a0, $a0, $a1

000B6754 2528a002 move       $a1, $s5
000B6758 3a8a020c jal        0xa28e8
000B675C 2520a002 move       $a0, $s5
000B6760 1c00a48f lw         $a0, 0x1c($sp)
000B6764 002c0200 sll        $a1, $v0, 0x10
000B6768 00240400 sll        $a0, $a0, 0x10
000B676C 038c0400 sra        $s1, $a0, 0x10
000B6770 03840500 sra        $s0, $a1, 0x10
000B6774 5227040c jal        0x109d48
000B6778 69010434 ori        $a0, $zero, 0x169
000B677C 25200002 move       $a0, $s0
000B6780 25282002 move       $a1, $s1
000B6784 9477020c jal        0x9de50
000B6788 25304000 move       $a2, $v0
000B678C 0400143c lui        $s4, 4
000B6790 cc639426 addiu      $s4, $s4, 0x63cc
000B6794 fcb1020c jal        0xac7f0
000B6798 25208002 move       $a0, $s4
000B679C 25984000 move       $s3, $v0
000B67A0 2f006012 beqz       $s3, 0xb6860
000B67A4 00000000 nop        
000B67A8 d400648e lw         $a0, 0xd4($s3)
000B67AC 1800053c lui        $a1, 0x18
000B67B0 80200400 sll        $a0, $a0, 2
000B67B4 c83ba524 addiu      $a1, $a1, 0x3bc8
000B67B8 21208500 addu       $a0, $a0, $a1
000B67BC 0000928c lw         $s2, ($a0)
000B67C0 2d00053c lui        $a1, 0x2d
000B67C4 3000448e lw         $a0, 0x30($s2)
000B67C8 8035a524 addiu      $a1, $a1, 0x3580
000B67CC 80200400 sll        $a0, $a0, 2
000B67D0 21208500 addu       $a0, $a0, $a1
000B67D4 0000848c lw         $a0, ($a0)
000B67D8 0400113c lui        $s1, 4
000B67DC 70643126 addiu      $s1, $s1, 0x6470
000B67E0 09008010 beqz       $a0, 0xb6808

000BB160 2440e500 and        $t0, $a3, $a1
000BB164 01000055 bnel       $t0, $zero, 0xbb16c
000BB168 01007326 addiu      $s3, $s3, 1
000BB16C 40280500 sll        $a1, $a1, 1
000BB170 ff00a530 andi       $a1, $a1, 0xff
000BB174 fbffa014 bnez       $a1, 0xbb164
000BB178 2440e500 and        $t0, $a3, $a1
000BB17C 01008424 addiu      $a0, $a0, 1
000BB180 7d00852c sltiu      $a1, $a0, 0x7d
000BB184 f3ffa014 bnez       $a1, 0xbb154
000BB188 00000000 nop        
000BB18C 2c00043c lui        $a0, 0x2c
000BB190 101d93ac sw         $s3, 0x1d10($a0)
000BB194 0400458e lw         $a1, 4($s2)
000BB198 25202002 move       $a0, $s1
000BB19C 2b986502 sltu       $s3, $s3, $a1
000BB1A0 fcb1020c jal        0xac7f0
000BB1A4 0100733a xori       $s3, $s3, 1
000BB1A8 06006012 beqz       $s3, 0xbb1c4
000BB1AC 25a04000 move       $s4, $v0
000BB1B0 0800458e lw         $a1, 8($s2)
000BB1B4 c530040c jal        0x10c314
000BB1B8 25200000 move       $a0, $zero
000BB1BC 04000010 b          0xbb1d0
000BB1C0 00000000 nop        
000BB1C4 25200000 move       $a0, $zero
000BB1C8 c530040c jal        0x10c314
000BB1CC 0d000534 ori        $a1, $zero, 0xd
000BB1D0 6f15030c jal        0xc55bc
000BB1D4 00000000 nop        
000BB1D8 0b004014 bnez       $v0, 0xbb208
000BB1DC 00000000 nop        
000BB1E0 08000432 andi       $a0, $s0, 8
000BB1E4 0a008010 beqz       $a0, 0xbb210
000BB1E8 00000000 nop        
000BB1EC 24a4020c jal        0xa9090

000BBA58 01730c46 sub.s      $f12, $f14, $f12
000BBA5C 08000010 b          0xbba80
000BBA60 0c578ce4 swc1       $f12, 0x570c($a0)
000BBA64 3c700c46 c.lt.s     $f14, $f12
000BBA68 00000000 nop        
000BBA6C 04000045 bc1f       0xbba80
000BBA70 00000000 nop        
000BBA74 01630e46 sub.s      $f12, $f12, $f14
000BBA78 006b0c46 add.s      $f12, $f13, $f12
000BBA7C 0c578ce4 swc1       $f12, 0x570c($a0)
000BBA80 3a000010 b          0xbbb6c
000BBA84 00000000 nop        
000BBA88 0400113c lui        $s1, 4
000BBA8C 00404432 andi       $a0, $s2, 0x4000
000BBA90 33008010 beqz       $a0, 0xbbb60
000BBA94 f86a3126 addiu      $s1, $s1, 0x6af8
000BBA98 fcb1020c jal        0xac7f0
000BBA9C 25202002 move       $a0, $s1
000BBAA0 25904000 move       $s2, $v0
000BBAA4 d000448e lw         $a0, 0xd0($s2)
000BBAA8 2d00053c lui        $a1, 0x2d
000BBAAC 00990400 sll        $s3, $a0, 4
000BBAB0 7c56a424 addiu      $a0, $a1, 0x567c
000BBAB4 8c89000c jal        0x22630
000BBAB8 21986402 addu       $s3, $s3, $a0
000BBABC 0c006592 lbu        $a1, 0xc($s3)
000BBAC0 25a04000 move       $s4, $v0
000BBAC4 ca85000c jal        0x21728
000BBAC8 9a000434 ori        $a0, $zero, 0x9a
000BBACC 0b004010 beqz       $v0, 0xbbafc
000BBAD0 00000000 nop        
000BBAD4 0c006592 lbu        $a1, 0xc($s3)
000BBAD8 9b000434 ori        $a0, $zero, 0x9b
000BBADC bf85000c jal        0x216fc
000BBAE0 ff000634 ori        $a2, $zero, 0xff
000BBAE4 2bf1020c jal        0xbc4ac

000BBAE4 2bf1020c jal        0xbc4ac
000BBAE8 00000000 nop        
000BBAEC 24a4020c jal        0xa9090
000BBAF0 0b000434 ori        $a0, $zero, 0xb
000BBAF4 0d000010 b          0xbbb2c
000BBAF8 00000000 nop        
000BBAFC 0400648e lw         $a0, 4($s3)
000BBB00 2b208402 sltu       $a0, $s4, $a0
000BBB04 05008010 beqz       $a0, 0xbbb1c
000BBB08 00000000 nop        
000BBB0C 24a4020c jal        0xa9090
000BBB10 0c000434 ori        $a0, $zero, 0xc
000BBB14 05000010 b          0xbbb2c
000BBB18 00000000 nop        
000BBB1C 01000434 ori        $a0, $zero, 1
000BBB20 785604ae sw         $a0, 0x5678($s0)
000BBB24 fcb1020c jal        0xac7f0
000BBB28 25202002 move       $a0, $s1
000BBB2C 0400053c lui        $a1, 4
000BBB30 15010434 ori        $a0, $zero, 0x115
000BBB34 5227040c jal        0x109d48
000BBB38 9c6bb024 addiu      $s0, $a1, 0x6b9c
000BBB3C 0000448e lw         $a0, ($s2)
000BBB40 5227040c jal        0x109d48
000BBB44 25884000 move       $s1, $v0
000BBB48 25200002 move       $a0, $s0
000BBB4C 25282002 move       $a1, $s1
000BBB50 1100070c jal        0x1c0044
000BBB54 25304000 move       $a2, $v0
000BBB58 04000010 b          0xbbb6c
000BBB5C 00000000 nop        
000BBB60 25202002 move       $a0, $s1
000BBB64 c6ae020c jal        0xabb18
000BBB68 25284002 move       $a1, $s2
000BBB6C 30000010 b          0xbbc30
000BBB70 00000000 nop        

000BBB88 5227040c jal        0x109d48
000BBB8C 9c6bb224 addiu      $s2, $a1, 0x6b9c
000BBB90 25984000 move       $s3, $v0
000BBB94 5227040c jal        0x109d48
000BBB98 37010434 ori        $a0, $zero, 0x137
000BBB9C 03000434 ori        $a0, $zero, 3
000BBBA0 25284002 move       $a1, $s2
000BBBA4 25306002 move       $a2, $s3
000BBBA8 b316030c jal        0xc5acc
000BBBAC 25384000 move       $a3, $v0
000BBBB0 6c15030c jal        0xc55b0
000BBBB4 00000000 nop        
000BBBB8 25204000 move       $a0, $v0
000BBBBC 16009114 bne        $a0, $s1, 0xbbc18
000BBBC0 00000000 nop        
000BBBC4 0400043c lui        $a0, 4
000BBBC8 fcb1020c jal        0xac7f0
000BBBCC f86a8424 addiu      $a0, $a0, 0x6af8
000BBBD0 d000448c lw         $a0, 0xd0($v0)
000BBBD4 2d00053c lui        $a1, 0x2d
000BBBD8 00210400 sll        $a0, $a0, 4
000BBBDC 7c56a524 addiu      $a1, $a1, 0x567c
000BBBE0 8c89000c jal        0x22630
000BBBE4 21888500 addu       $s1, $a0, $a1
000BBBE8 9489000c jal        0x22650
000BBBEC 0400248e lw         $a0, 4($s1)
000BBBF0 0c002692 lbu        $a2, 0xc($s1)
000BBBF4 9a000434 ori        $a0, $zero, 0x9a
000BBBF8 d385000c jal        0x2174c
000BBBFC 01000534 ori        $a1, $zero, 1
000BBC00 2bf1020c jal        0xbc4ac
000BBC04 00000000 nop        
000BBC08 24a4020c jal        0xa9090
000BBC0C 01000434 ori        $a0, $zero, 1
000BBC10 07000010 b          0xbbc30
000BBC14 785600ae sw         $zero, 0x5678($s0)

000BBC60 00a08044 mtc1       $zero, $f20
000BBC64 3b000434 ori        $a0, $zero, 0x3b
000BBC68 ffff0524 addiu      $a1, $zero, -1
000BBC6C 6400b0af sw         $s0, 0x64($sp)
000BBC70 6800b1af sw         $s1, 0x68($sp)
000BBC74 6c00b2af sw         $s2, 0x6c($sp)
000BBC78 7000b3af sw         $s3, 0x70($sp)
000BBC7C 7400b4af sw         $s4, 0x74($sp)
000BBC80 7800b5af sw         $s5, 0x78($sp)
000BBC84 7c00b6af sw         $s6, 0x7c($sp)
000BBC88 8000b7af sw         $s7, 0x80($sp)
000BBC8C 8400bfaf sw         $ra, 0x84($sp)
000BBC90 4485020c jal        0xa1510
000BBC94 06a30046 mov.s      $f12, $f20
000BBC98 0400103c lui        $s0, 4
000BBC9C f86a1026 addiu      $s0, $s0, 0x6af8
000BBCA0 fcb1020c jal        0xac7f0
000BBCA4 25200002 move       $a0, $s0
000BBCA8 d000448c lw         $a0, 0xd0($v0)
000BBCAC 2d00053c lui        $a1, 0x2d
000BBCB0 00890400 sll        $s1, $a0, 4
000BBCB4 7c56a424 addiu      $a0, $a1, 0x567c
000BBCB8 21882402 addu       $s1, $s1, $a0
000BBCBC 0c002592 lbu        $a1, 0xc($s1)
000BBCC0 ca85000c jal        0x21728
000BBCC4 9a000434 ori        $a0, $zero, 0x9a
000BBCC8 1000b327 addiu      $s3, $sp, 0x10
000BBCCC 06a30046 mov.s      $f12, $f20
000BBCD0 2b900200 sltu       $s2, $zero, $v0
000BBCD4 30020434 ori        $a0, $zero, 0x230
000BBCD8 f583020c jal        0xa0fd4
000BBCDC 25286002 move       $a1, $s3
000BBCE0 3a8a020c jal        0xa28e8
000BBCE4 25206002 move       $a0, $s3
000BBCE8 1c00a48f lw         $a0, 0x1c($sp)
000BBCEC 002c0200 sll        $a1, $v0, 0x10

000BC6B4 1800b28f lw         $s2, 0x18($sp)
000BC6B8 1c00bf8f lw         $ra, 0x1c($sp)
000BC6BC 0800e003 jr         $ra
000BC6C0 2000bd27 addiu      $sp, $sp, 0x20
000BC6C4 d0ffbd27 addiu      $sp, $sp, -0x30
000BC6C8 1800b0af sw         $s0, 0x18($sp)
000BC6CC 2d00103c lui        $s0, 0x2d
000BC6D0 1c00b1af sw         $s1, 0x1c($sp)
000BC6D4 0400043c lui        $a0, 4
000BC6D8 7456118e lw         $s1, 0x5674($s0)
000BC6DC 1000b4e7 swc1       $f20, 0x10($sp)
000BC6E0 1400b6e7 swc1       $f22, 0x14($sp)
000BC6E4 2000b2af sw         $s2, 0x20($sp)
000BC6E8 2400b3af sw         $s3, 0x24($sp)
000BC6EC 2800b4af sw         $s4, 0x28($sp)
000BC6F0 2c00bfaf sw         $ra, 0x2c($sp)
000BC6F4 fcb1020c jal        0xac7f0
000BC6F8 f86a8424 addiu      $a0, $a0, 0x6af8
000BC6FC 25904000 move       $s2, $v0
000BC700 08004012 beqz       $s2, 0xbc724
000BC704 00000000 nop        
000BC708 2d00133c lui        $s3, 0x2d
000BC70C 6856648e lw         $a0, 0x5668($s3)
000BC710 02008528 slti       $a1, $a0, 2
000BC714 0500a014 bnez       $a1, 0xbc72c
000BC718 00000000 nop        
000BC71C 09000010 b          0xbc744
000BC720 03008528 slti       $a1, $a0, 3
000BC724 c6000010 b          0xbca40
000BC728 00000000 nop        
000BC72C c4008004 bltz       $a0, 0xbca40
000BC730 00000000 nop        
000BC734 09008018 blez       $a0, 0xbc75c
000BC738 00000000 nop        
000BC73C 59000010 b          0xbc8a4
000BC740 00000000 nop        

000BD124 24a4020c jal        0xa9090
000BD128 07000434 ori        $a0, $zero, 7
000BD12C 24a4020c jal        0xa9090
000BD130 25200000 move       $a0, $zero
000BD134 51ba020c jal        0xae944
000BD138 00000000 nop        
000BD13C 09004014 bnez       $v0, 0xbd164
000BD140 00000000 nop        
000BD144 04000434 ori        $a0, $zero, 4
000BD148 ff51000c jal        0x147fc
000BD14C 25280000 move       $a1, $zero
000BD150 04000010 b          0xbd164
000BD154 00000000 nop        
000BD158 25288000 move       $a1, $a0
000BD15C c6ae020c jal        0xabb18
000BD160 25200002 move       $a0, $s0
000BD164 fcb1020c jal        0xac7f0
000BD168 25200002 move       $a0, $s0
000BD16C 25804000 move       $s0, $v0
000BD170 07000012 beqz       $s0, 0xbd190
000BD174 00000000 nop        
000BD178 dc00108e lw         $s0, 0xdc($s0)
000BD17C 04000012 beqz       $s0, 0xbd190
000BD180 00000000 nop        
000BD184 25200000 move       $a0, $zero
000BD188 c530040c jal        0x10c314
000BD18C 25280002 move       $a1, $s0
000BD190 1000b08f lw         $s0, 0x10($sp)
000BD194 1400bf8f lw         $ra, 0x14($sp)
000BD198 0800e003 jr         $ra
000BD19C 2000bd27 addiu      $sp, $sp, 0x20
000BD1A0 b0ffbd27 addiu      $sp, $sp, -0x50
000BD1A4 2800b4e7 swc1       $f20, 0x28($sp)
000BD1A8 00a08044 mtc1       $zero, $f20
000BD1AC 3a000434 ori        $a0, $zero, 0x3a
000BD1B0 ffff0524 addiu      $a1, $zero, -1

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
000BD2FC 03240400 sra        $a0, $a0, 0x10
000BD300 032c0500 sra        $a1, $a1, 0x10
000BD304 3e75020c jal        0x9d4f8
000BD308 25302002 move       $a2, $s1
000BD30C fcb1020c jal        0xac7f0
000BD310 25200002 move       $a0, $s0
000BD314 25904000 move       $s2, $v0
000BD318 45004012 beqz       $s2, 0xbd430
000BD31C 00000000 nop        
000BD320 d400448e lw         $a0, 0xd4($s2)
000BD324 0400113c lui        $s1, 4
000BD328 dd0f0534 ori        $a1, $zero, 0xfdd
000BD32C 9c6d3126 addiu      $s1, $s1, 0x6d9c
000BD330 17008514 bne        $a0, $a1, 0xbd390
000BD334 2d00103c lui        $s0, 0x2d
000BD338 0c89000c jal        0x22430
000BD33C 00000000 nop        
000BD340 0400143c lui        $s4, 4
000BD344 09004010 beqz       $v0, 0xbd36c
000BD348 f06d9426 addiu      $s4, $s4, 0x6df0
000BD34C 5227040c jal        0x109d48
000BD350 dd0f0434 ori        $a0, $zero, 0xfdd
000BD354 25208002 move       $a0, $s4
000BD358 25284000 move       $a1, $v0

000BD85C 2c00b38f lw         $s3, 0x2c($sp)
000BD860 3000b48f lw         $s4, 0x30($sp)
000BD864 3400bf8f lw         $ra, 0x34($sp)
000BD868 0800e003 jr         $ra
000BD86C 4000bd27 addiu      $sp, $sp, 0x40
000BD870 c0ffbd27 addiu      $sp, $sp, -0x40
000BD874 2000b0af sw         $s0, 0x20($sp)
000BD878 2400b1af sw         $s1, 0x24($sp)
000BD87C 2800b2af sw         $s2, 0x28($sp)
000BD880 2c00b3af sw         $s3, 0x2c($sp)
000BD884 3000bfaf sw         $ra, 0x30($sp)
000BD888 12e1010c jal        0x78448
000BD88C 106b0434 ori        $a0, $zero, 0x6b10
000BD890 0400123c lui        $s2, 4
000BD894 f0715226 addiu      $s2, $s2, 0x71f0
000BD898 25984000 move       $s3, $v0
000BD89C fcb1020c jal        0xac7f0
000BD8A0 25204002 move       $a0, $s2
000BD8A4 25884000 move       $s1, $v0
000BD8A8 06002012 beqz       $s1, 0xbd8c4
000BD8AC 00001034 ori        $s0, $zero, 0
000BD8B0 d400248e lw         $a0, 0xd4($s1)
000BD8B4 2d00053c lui        $a1, 0x2d
000BD8B8 00810400 sll        $s0, $a0, 4
000BD8BC 8058a424 addiu      $a0, $a1, 0x5880
000BD8C0 21800402 addu       $s0, $s0, $a0
000BD8C4 08006432 andi       $a0, $s3, 8
000BD8C8 08008010 beqz       $a0, 0xbd8ec
000BD8CC 00000000 nop        
000BD8D0 24a4020c jal        0xa9090
000BD8D4 25200000 move       $a0, $zero
000BD8D8 04000434 ori        $a0, $zero, 4
000BD8DC ff51000c jal        0x147fc
000BD8E0 25280000 move       $a1, $zero
000BD8E4 3b000010 b          0xbd9d4
000BD8E8 00000000 nop        

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
000BDB6C 25280002 move       $a1, $s0
000BDB70 25200000 move       $a0, $zero
000BDB74 25280002 move       $a1, $s0
000BDB78 0c31040c jal        0x10c430

000C31F0 9c01bf8f lw         $ra, 0x19c($sp)
000C31F4 0800e003 jr         $ra
000C31F8 a001bd27 addiu      $sp, $sp, 0x1a0
000C31FC 2d00053c lui        $a1, 0x2d
000C3200 0800e003 jr         $ra
000C3204 dc74a4ac sw         $a0, 0x74dc($a1)
000C3208 2d00043c lui        $a0, 0x2d
000C320C 0800e003 jr         $ra
000C3210 dc74828c lw         $v0, 0x74dc($a0)
000C3214 e0ffbd27 addiu      $sp, $sp, -0x20
000C3218 1400b1af sw         $s1, 0x14($sp)
000C321C 0400113c lui        $s1, 4
000C3220 34763126 addiu      $s1, $s1, 0x7634
000C3224 1000b0af sw         $s0, 0x10($sp)
000C3228 1800b2af sw         $s2, 0x18($sp)
000C322C 1c00bfaf sw         $ra, 0x1c($sp)
000C3230 fcb1020c jal        0xac7f0
000C3234 25202002 move       $a0, $s1
000C3238 25804000 move       $s0, $v0
000C323C 18000012 beqz       $s0, 0xc32a0
000C3240 00000000 nop        
000C3244 d400048e lw         $a0, 0xd4($s0)
000C3248 15008010 beqz       $a0, 0xc32a0
000C324C 00000000 nop        
000C3250 4d68040c jal        0x11a134
000C3254 00000000 nop        
000C3258 0400123c lui        $s2, 4
000C325C 147642ae sw         $v0, 0x7614($s2)
000C3260 3768040c jal        0x11a0dc
000C3264 d400048e lw         $a0, 0xd4($s0)
000C3268 14765226 addiu      $s2, $s2, 0x7614
000C326C 040042ae sw         $v0, 4($s2)
000C3270 dc00048e lw         $a0, 0xdc($s0)
000C3274 080044ae sw         $a0, 8($s2)
000C3278 f667040c jal        0x119fd8
000C327C d400048e lw         $a0, 0xd4($s0)

000C3758 9372020c jal        0x9ca4c
000C375C 25400000 move       $t0, $zero
000C3760 01000010 b          0xc3768
000C3764 00000000 nop        
000C3768 87010434 ori        $a0, $zero, 0x187
000C376C 06a30046 mov.s      $f12, $f20
000C3770 f583020c jal        0xa0fd4
000C3774 25286002 move       $a1, $s3
000C3778 2000a48f lw         $a0, 0x20($sp)
000C377C 2c00a58f lw         $a1, 0x2c($sp)
000C3780 00240400 sll        $a0, $a0, 0x10
000C3784 002c0500 sll        $a1, $a1, 0x10
000C3788 03240400 sra        $a0, $a0, 0x10
000C378C 032c0500 sra        $a1, $a1, 0x10
000C3790 3e75020c jal        0x9d4f8
000C3794 25308002 move       $a2, $s4
000C3798 fcb1020c jal        0xac7f0
000C379C 25200002 move       $a0, $s0
000C37A0 25a04000 move       $s4, $v0
000C37A4 11008012 beqz       $s4, 0xc37ec
000C37A8 00000000 nop        
000C37AC 0400248e lw         $a0, 4($s1)
000C37B0 d000858e lw         $a1, 0xd0($s4)
000C37B4 5227040c jal        0x109d48
000C37B8 21208500 addu       $a0, $a0, $a1
000C37BC 0400163c lui        $s6, 4
000C37C0 d876d626 addiu      $s6, $s6, 0x76d8
000C37C4 1400c2ae sw         $v0, 0x14($s6)
000C37C8 2d00153c lui        $s5, 0x2d
000C37CC e474a48e lw         $a0, 0x74e4($s5)
000C37D0 04009410 beq        $a0, $s4, 0xc37e4
000C37D4 00000000 nop        
000C37D8 bf7a020c jal        0x9eafc
000C37DC 2520c002 move       $a0, $s6
000C37E0 e474b4ae sw         $s4, 0x74e4($s5)
000C37E4 198c020c jal        0xa3064

000C4574 06660046 mov.s      $f24, $f12
000C4578 3a8a020c jal        0xa28e8
000C457C 25208002 move       $a0, $s4
000C4580 3c00a48f lw         $a0, 0x3c($sp)
000C4584 002c0200 sll        $a1, $v0, 0x10
000C4588 00240400 sll        $a0, $a0, 0x10
000C458C 038c0400 sra        $s1, $a0, 0x10
000C4590 03840500 sra        $s0, $a1, 0x10
000C4594 5227040c jal        0x109d48
000C4598 c8010434 ori        $a0, $zero, 0x1c8
000C459C 25200002 move       $a0, $s0
000C45A0 06c30046 mov.s      $f12, $f24
000C45A4 25282002 move       $a1, $s1
000C45A8 46c30046 mov.s      $f13, $f24
000C45AC 4378020c jal        0x9e10c
000C45B0 25304000 move       $a2, $v0
000C45B4 fcb1020c jal        0xac7f0
000C45B8 2520a002 move       $a0, $s5
000C45BC 25804000 move       $s0, $v0
000C45C0 23000012 beqz       $s0, 0xc4650
000C45C4 00000000 nop        
000C45C8 5227040c jal        0x109d48
000C45CC d000048e lw         $a0, 0xd0($s0)
000C45D0 0400113c lui        $s1, 4
000C45D4 2c773126 addiu      $s1, $s1, 0x772c
000C45D8 140022ae sw         $v0, 0x14($s1)
000C45DC 2d00123c lui        $s2, 0x2d
000C45E0 3079448e lw         $a0, 0x7930($s2)
000C45E4 04009010 beq        $a0, $s0, 0xc45f8
000C45E8 00000000 nop        
000C45EC bf7a020c jal        0x9eafc
000C45F0 25202002 move       $a0, $s1
000C45F4 307950ae sw         $s0, 0x7930($s2)
000C45F8 198c020c jal        0xa3064
000C45FC 25202002 move       $a0, $s1
000C4600 12010434 ori        $a0, $zero, 0x112

000C4EDC 6090248e lw         $a0, -0x6fa0($s1)
000C4EE0 2001b0af sw         $s0, 0x120($sp)
000C4EE4 0400103c lui        $s0, 4
000C4EE8 2801bfaf sw         $ra, 0x128($sp)
000C4EEC 09008010 beqz       $a0, 0xc4f14
000C4EF0 80771026 addiu      $s0, $s0, 0x7780
000C4EF4 1d00063c lui        $a2, 0x1d
000C4EF8 25288000 move       $a1, $a0
000C4EFC f073c624 addiu      $a2, $a2, 0x73f0
000C4F00 2000a427 addiu      $a0, $sp, 0x20
000C4F04 2538c000 move       $a3, $a2
000C4F08 9372020c jal        0x9ca4c
000C4F0C 2540c000 move       $t0, $a2
000C4F10 609020ae sw         $zero, -0x6fa0($s1)
000C4F14 6472020c jal        0x9c990
000C4F18 ffff0424 addiu      $a0, $zero, -1
000C4F1C fcb1020c jal        0xac7f0
000C4F20 25200002 move       $a0, $s0
000C4F24 25884000 move       $s1, $v0
000C4F28 12e1010c jal        0x78448
000C4F2C 01000434 ori        $a0, $zero, 1
000C4F30 25204000 move       $a0, $v0
000C4F34 08008530 andi       $a1, $a0, 8
000C4F38 0800a010 beqz       $a1, 0xc4f5c
000C4F3C 00000000 nop        
000C4F40 24a4020c jal        0xa9090
000C4F44 25200000 move       $a0, $zero
000C4F48 04000434 ori        $a0, $zero, 4
000C4F4C ff51000c jal        0x147fc
000C4F50 25280000 move       $a1, $zero
000C4F54 20000010 b          0xc4fd8
000C4F58 00000000 nop        
000C4F5C 00108530 andi       $a1, $a0, 0x1000
000C4F60 0e00a010 beqz       $a1, 0xc4f9c
000C4F64 00000000 nop        
000C4F68 24a4020c jal        0xa9090