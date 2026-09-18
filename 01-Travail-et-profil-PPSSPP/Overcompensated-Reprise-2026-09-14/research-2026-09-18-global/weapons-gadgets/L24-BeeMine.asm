
CALLBACK 0x0010A26C end 0x0010A27C ordinal 0

0010A26C 8C840058 lw         $a0, 0x58($a0)
0010A270 34020001 ori        $v0, $zero, 1
0010A274 03E00008 jr         $ra
0010A278 AC800058 sw         $zero, 0x58($a0)

CALLBACK 0x0010A27C end 0x0010A354 ordinal 1

0010A27C 27BDFFD0 addiu      $sp, $sp, -0x30
0010A280 AFB00010 sw         $s0, 0x10($sp)
0010A284 AFB10014 sw         $s1, 0x14($sp)
0010A288 AFB20018 sw         $s2, 0x18($sp)
0010A28C AFB3001C sw         $s3, 0x1c($sp)
0010A290 AFBF0020 sw         $ra, 0x20($sp)
0010A294 0C04294D jal        0x10a534
0010A298 8C910058 lw         $s1, 0x58($a0)
0010A29C 8E240018 lw         $a0, 0x18($s1)
0010A2A0 10800008 beqz       $a0, 0x10a2c4
0010A2A4 00000000 nop        
0010A2A8 8E250004 lw         $a1, 4($s1)
0010A2AC 10A00004 beqz       $a1, 0x10a2c0
0010A2B0 AC850000 sw         $a1, ($a0)
0010A2B4 8E240018 lw         $a0, 0x18($s1)
0010A2B8 8E250004 lw         $a1, 4($s1)
0010A2BC ACA40014 sw         $a0, 0x14($a1)
0010A2C0 AE200018 sw         $zero, 0x18($s1)
0010A2C4 9224008D lbu        $a0, 0x8d($s1)
0010A2C8 1080001B beqz       $a0, 0x10a338
0010A2CC 00000000 nop        
0010A2D0 3C12002A lui        $s2, 0x2a
0010A2D4 2652D480 addiu      $s2, $s2, -0x2b80
0010A2D8 8E44002C lw         $a0, 0x2c($s2)
0010A2DC 34130000 ori        $s3, $zero, 0
0010A2E0 0264202B sltu       $a0, $s3, $a0
0010A2E4 10800014 beqz       $a0, 0x10a338
0010A2E8 3C100028 lui        $s0, 0x28
0010A2EC 8E25005C lw         $a1, 0x5c($s1)
0010A2F0 10A0000C beqz       $a1, 0x10a324
0010A2F4 00000000 nop        
0010A2F8 00A02025 move       $a0, $a1
0010A2FC 10800008 beqz       $a0, 0x10a320
0010A300 00000000 nop        
0010A304 8E0627F8 lw         $a2, 0x27f8($s0)
0010A308 14A60003 bne        $a1, $a2, 0x10a318
0010A30C 00000000 nop        
0010A310 10000003 b          0x10a320
0010A314 AE0027F8 sw         $zero, 0x27f8($s0)
0010A318 0C02172B jal        0x85cac
0010A31C 00000000 nop        
0010A320 AE20005C sw         $zero, 0x5c($s1)
0010A324 8E44002C lw         $a0, 0x2c($s2)
0010A328 26730001 addiu      $s3, $s3, 1
0010A32C 0264202B sltu       $a0, $s3, $a0
0010A330 1480FFEE bnez       $a0, 0x10a2ec
0010A334 26310004 addiu      $s1, $s1, 4
0010A338 8FB00010 lw         $s0, 0x10($sp)
0010A33C 8FB10014 lw         $s1, 0x14($sp)
0010A340 8FB20018 lw         $s2, 0x18($sp)
0010A344 8FB3001C lw         $s3, 0x1c($sp)
0010A348 8FBF0020 lw         $ra, 0x20($sp)
0010A34C 03E00008 jr         $ra
0010A350 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x0010A65C end 0x0010C038 ordinal 2

0010A65C 27BDFE10 addiu      $sp, $sp, -0x1f0
0010A660 AFB001E0 sw         $s0, 0x1e0($sp)
0010A664 00808025 move       $s0, $a0
0010A668 92040045 lbu        $a0, 0x45($s0)
0010A66C E7B401D0 swc1       $f20, 0x1d0($sp)
0010A670 2C850009 sltiu      $a1, $a0, 9
0010A674 E7B601D4 swc1       $f22, 0x1d4($sp)
0010A678 E7B801D8 swc1       $f24, 0x1d8($sp)
0010A67C E7BA01DC swc1       $f26, 0x1dc($sp)
0010A680 AFB101E4 sw         $s1, 0x1e4($sp)
0010A684 AFB201E8 sw         $s2, 0x1e8($sp)
0010A688 AFBF01EC sw         $ra, 0x1ec($sp)
0010A68C 10A00563 beqz       $a1, 0x10bc1c
0010A690 8E110058 lw         $s1, 0x58($s0)
0010A694 00042080 sll        $a0, $a0, 2
0010A698 3C01001A lui        $at, 0x1a
0010A69C 00240821 addu       $at, $at, $a0
0010A6A0 8C218720 lw         $at, -0x78e0($at)
0010A6A4 00200008 jr         $at
0010A6A8 00000000 nop        
0010A6AC C62C003C lwc1       $f12, 0x3c($s1)
0010A6B0 C62D0040 lwc1       $f13, 0x40($s1)
0010A6B4 460C6382 mul.s      $f14, $f12, $f12
0010A6B8 C62F0044 lwc1       $f15, 0x44($s1)
0010A6BC 460D6B42 mul.s      $f13, $f13, $f13
0010A6C0 460F7BC2 mul.s      $f15, $f15, $f15
0010A6C4 3C043F80 lui        $a0, 0x3f80
0010A6C8 44848000 mtc1       $a0, $f16
0010A6CC 460D7340 add.s      $f13, $f14, $f13
0010A6D0 460F6B40 add.s      $f13, $f13, $f15
0010A6D4 46006B44 sqrt.s     $f13, $f13
0010A6D8 460D8343 div.s      $f13, $f16, $f13
0010A6DC 26050030 addiu      $a1, $s0, 0x30
0010A6E0 27A60050 addiu      $a2, $sp, 0x50
0010A6E4 02002025 move       $a0, $s0
0010A6E8 460C6B02 mul.s      $f12, $f13, $f12
0010A6EC E7AC0050 swc1       $f12, 0x50($sp)
0010A6F0 C62C0040 lwc1       $f12, 0x40($s1)
0010A6F4 460C6B02 mul.s      $f12, $f13, $f12
0010A6F8 E7AC0054 swc1       $f12, 0x54($sp)
0010A6FC C62C0044 lwc1       $f12, 0x44($s1)
0010A700 460C6B02 mul.s      $f12, $f13, $f12
0010A704 E7AC0058 swc1       $f12, 0x58($sp)
0010A708 0C056ED8 jal        0x15bb60
0010A70C 8E270000 lw         $a3, ($s1)
0010A710 14400053 bnez       $v0, 0x10a860
0010A714 AE220028 sw         $v0, 0x28($s1)
0010A718 3C04002A lui        $a0, 0x2a
0010A71C 8C859868 lw         $a1, -0x6798($a0)
0010A720 34040000 ori        $a0, $zero, 0
0010A724 8CA50038 lw         $a1, 0x38($a1)
0010A728 0085282B sltu       $a1, $a0, $a1
0010A72C 10A0001B beqz       $a1, 0x10a79c
0010A730 00000000 nop        
0010A734 3C07002A lui        $a3, 0x2a
0010A738 00042980 sll        $a1, $a0, 6
0010A73C 00043100 sll        $a2, $a0, 4
0010A740 8CE79868 lw         $a3, -0x6798($a3)
0010A744 00A62821 addu       $a1, $a1, $a2
0010A748 8CE60034 lw         $a2, 0x34($a3)
0010A74C 3C07A6FC lui        $a3, 0xa6fc
0010A750 00C52821 addu       $a1, $a2, $a1
0010A754 8CA50030 lw         $a1, 0x30($a1)
0010A758 24E650BB addiu      $a2, $a3, 0x50bb
0010A75C 14A60009 bne        $a1, $a2, 0x10a784
0010A760 3C05002A lui        $a1, 0x2a
0010A764 00042980 sll        $a1, $a0, 6
0010A768 3C06002A lui        $a2, 0x2a
0010A76C 00042100 sll        $a0, $a0, 4
0010A770 8CC69868 lw         $a2, -0x6798($a2)
0010A774 00A42021 addu       $a0, $a1, $a0
0010A778 8CC50034 lw         $a1, 0x34($a2)
0010A77C 10000008 b          0x10a7a0
0010A780 00A42021 addu       $a0, $a1, $a0
0010A784 8CA59868 lw         $a1, -0x6798($a1)
0010A788 24840001 addiu      $a0, $a0, 1
0010A78C 8CA50038 lw         $a1, 0x38($a1)
0010A790 0085282B sltu       $a1, $a0, $a1
0010A794 14A0FFE8 bnez       $a1, 0x10a738
0010A798 3C07002A lui        $a3, 0x2a
0010A79C 34040000 ori        $a0, $zero, 0
0010A7A0 1080002F beqz       $a0, 0x10a860
0010A7A4 00000000 nop        
0010A7A8 00802825 move       $a1, $a0
0010A7AC 44806000 mtc1       $zero, $f12
0010A7B0 8CA6003C lw         $a2, 0x3c($a1)
0010A7B4 8CA7000C lw         $a3, 0xc($a1)
0010A7B8 000629C0 sll        $a1, $a2, 7
0010A7BC 00E52821 addu       $a1, $a3, $a1
0010A7C0 00E03025 move       $a2, $a3
0010A7C4 10C5001E beq        $a2, $a1, 0x10a840
0010A7C8 34040000 ori        $a0, $zero, 0
0010A7CC 8CC70058 lw         $a3, 0x58($a2)
0010A7D0 8E280000 lw         $t0, ($s1)
0010A7D4 8CE70000 lw         $a3, ($a3)
0010A7D8 50E80003 beql       $a3, $t0, 0x10a7e8
0010A7DC C4CD0030 lwc1       $f13, 0x30($a2)
0010A7E0 10000014 b          0x10a834
0010A7E4 00000000 nop        
0010A7E8 C60E0030 lwc1       $f14, 0x30($s0)
0010A7EC C4CF0034 lwc1       $f15, 0x34($a2)
0010A7F0 C6100034 lwc1       $f16, 0x34($s0)
0010A7F4 460E6B41 sub.s      $f13, $f13, $f14
0010A7F8 C4D10038 lwc1       $f17, 0x38($a2)
0010A7FC 46107BC1 sub.s      $f15, $f15, $f16
0010A800 C6120038 lwc1       $f18, 0x38($s0)
0010A804 460D6B42 mul.s      $f13, $f13, $f13
0010A808 46128C41 sub.s      $f17, $f17, $f18
0010A80C 460F7B82 mul.s      $f14, $f15, $f15
0010A810 46118C42 mul.s      $f17, $f17, $f17
0010A814 460E6B40 add.s      $f13, $f13, $f14
0010A818 46116B40 add.s      $f13, $f13, $f17
0010A81C 460C683E c.le.s     $f13, $f12
0010A820 00000000 nop        
0010A824 45010003 bc1t       0x10a834
0010A828 00000000 nop        
0010A82C 00C02025 move       $a0, $a2
0010A830 46006B06 mov.s      $f12, $f13
0010A834 24C60080 addiu      $a2, $a2, 0x80
0010A838 14C5FFE4 bne        $a2, $a1, 0x10a7cc
0010A83C 00000000 nop        
0010A840 10800007 beqz       $a0, 0x10a860
0010A844 00000000 nop        
0010A848 00802825 move       $a1, $a0
0010A84C 26060030 addiu      $a2, $s0, 0x30
0010A850 27A70050 addiu      $a3, $sp, 0x50
0010A854 0C056F3B jal        0x15bcec
0010A858 02002025 move       $a0, $s0
0010A85C AE220028 sw         $v0, 0x28($s1)
0010A860 8E240028 lw         $a0, 0x28($s1)
0010A864 14800004 bnez       $a0, 0x10a878
0010A868 00000000 nop        
0010A86C 34040008 ori        $a0, $zero, 8
0010A870 100004EA b          0x10bc1c
0010A874 A2040045 sb         $a0, 0x45($s0)
0010A878 8E040064 lw         $a0, 0x64($s0)
0010A87C 2405FFDF addiu      $a1, $zero, -0x21
0010A880 00852024 and        $a0, $a0, $a1
0010A884 AE040064 sw         $a0, 0x64($s0)
0010A888 34040001 ori        $a0, $zero, 1
0010A88C 100004E3 b          0x10bc1c
0010A890 A2040045 sb         $a0, 0x45($s0)
0010A894 96240010 lhu        $a0, 0x10($s1)
0010A898 34840008 ori        $a0, $a0, 8
0010A89C A6240010 sh         $a0, 0x10($s1)
0010A8A0 C60C0030 lwc1       $f12, 0x30($s0)
0010A8A4 C60D0034 lwc1       $f13, 0x34($s0)
0010A8A8 E7AC0060 swc1       $f12, 0x60($sp)
0010A8AC C60E0038 lwc1       $f14, 0x38($s0)
0010A8B0 E7AD0064 swc1       $f13, 0x64($sp)
0010A8B4 E7AE0068 swc1       $f14, 0x68($sp)
0010A8B8 C62F003C lwc1       $f15, 0x3c($s1)
0010A8BC 460F63C0 add.s      $f15, $f12, $f15
0010A8C0 27A40060 addiu      $a0, $sp, 0x60
0010A8C4 27A50084 addiu      $a1, $sp, 0x84
0010A8C8 E7AF006C swc1       $f15, 0x6c($sp)
0010A8CC C6300040 lwc1       $f16, 0x40($s1)
0010A8D0 460C7B01 sub.s      $f12, $f15, $f12
0010A8D4 46106C00 add.s      $f16, $f13, $f16
0010A8D8 27A60088 addiu      $a2, $sp, 0x88
0010A8DC E7B00070 swc1       $f16, 0x70($sp)
0010A8E0 460D8341 sub.s      $f13, $f16, $f13
0010A8E4 C6310044 lwc1       $f17, 0x44($s1)
0010A8E8 E7AC0078 swc1       $f12, 0x78($sp)
0010A8EC 46117440 add.s      $f17, $f14, $f17
0010A8F0 E7AD007C swc1       $f13, 0x7c($sp)
0010A8F4 460E8B01 sub.s      $f12, $f17, $f14
0010A8F8 E7B10074 swc1       $f17, 0x74($sp)
0010A8FC 0C0066D9 jal        0x19b64
0010A900 E7AC0080 swc1       $f12, 0x80($sp)
0010A904 10400186 beqz       $v0, 0x10af20
0010A908 00000000 nop        
0010A90C 97A40094 lhu        $a0, 0x94($sp)
0010A910 30840008 andi       $a0, $a0, 8
0010A914 1480001A bnez       $a0, 0x10a980
0010A918 00000000 nop        
0010A91C C62C003C lwc1       $f12, 0x3c($s1)
0010A920 44806800 mtc1       $zero, $f13
0010A924 46006307 neg.s      $f12, $f12
0010A928 E7AC00B8 swc1       $f12, 0xb8($sp)
0010A92C C62E0040 lwc1       $f14, 0x40($s1)
0010A930 460C6302 mul.s      $f12, $f12, $f12
0010A934 46007387 neg.s      $f14, $f14
0010A938 E7AE00BC swc1       $f14, 0xbc($sp)
0010A93C 460D6B82 mul.s      $f14, $f13, $f13
0010A940 C62F0044 lwc1       $f15, 0x44($s1)
0010A944 46007BC7 neg.s      $f15, $f15
0010A948 E7AF00C0 swc1       $f15, 0xc0($sp)
0010A94C 460E6300 add.s      $f12, $f12, $f14
0010A950 E7AD00BC swc1       $f13, 0xbc($sp)
0010A954 460F7BC2 mul.s      $f15, $f15, $f15
0010A958 3C043480 lui        $a0, 0x3480
0010A95C E7AD00C4 swc1       $f13, 0xc4($sp)
0010A960 44846800 mtc1       $a0, $f13
0010A964 460F6300 add.s      $f12, $f12, $f15
0010A968 460D603C c.lt.s     $f12, $f13
0010A96C 00000000 nop        
0010A970 45030015 bc1tl      0x10a9c8
0010A974 C7AC00B8 lwc1       $f12, 0xb8($sp)
0010A978 10000006 b          0x10a994
0010A97C 3C043F80 lui        $a0, 0x3f80
0010A980 8E240028 lw         $a0, 0x28($s1)
0010A984 0C0192FF jal        0x64bfc
0010A988 34050001 ori        $a1, $zero, 1
0010A98C 100005A0 b          0x10c010
0010A990 00000000 nop        
0010A994 46006304 sqrt.s     $f12, $f12
0010A998 44846800 mtc1       $a0, $f13
0010A99C 460C6B03 div.s      $f12, $f13, $f12
0010A9A0 C7AE00B8 lwc1       $f14, 0xb8($sp)
0010A9A4 C7AF00BC lwc1       $f15, 0xbc($sp)
0010A9A8 C7B000C0 lwc1       $f16, 0xc0($sp)
0010A9AC 460C7382 mul.s      $f14, $f14, $f12
0010A9B0 460C7BC2 mul.s      $f15, $f15, $f12
0010A9B4 E7AE00B8 swc1       $f14, 0xb8($sp)
0010A9B8 460C8302 mul.s      $f12, $f16, $f12
0010A9BC E7AF00BC swc1       $f15, 0xbc($sp)
0010A9C0 E7AC00C0 swc1       $f12, 0xc0($sp)
0010A9C4 C7AC00B8 lwc1       $f12, 0xb8($sp)
0010A9C8 C7AD00BC lwc1       $f13, 0xbc($sp)
0010A9CC E60C0020 swc1       $f12, 0x20($s0)
0010A9D0 C7AE00C0 lwc1       $f14, 0xc0($sp)
0010A9D4 E60D0024 swc1       $f13, 0x24($s0)
0010A9D8 3C04002A lui        $a0, 0x2a
0010A9DC E60E0028 swc1       $f14, 0x28($s0)
0010A9E0 24859B10 addiu      $a1, $a0, -0x64f0
0010A9E4 C4AF0004 lwc1       $f15, 4($a1)
0010A9E8 C4B00008 lwc1       $f16, 8($a1)
0010A9EC 460E7BC2 mul.s      $f15, $f15, $f14
0010A9F0 460D8402 mul.s      $f16, $f16, $f13
0010A9F4 46107BC1 sub.s      $f15, $f15, $f16
0010A9F8 E60F0000 swc1       $f15, ($s0)
0010A9FC C4B10008 lwc1       $f17, 8($a1)
0010AA00 C4929B10 lwc1       $f18, -0x64f0($a0)
0010AA04 460C8C42 mul.s      $f17, $f17, $f12
0010AA08 460E9382 mul.s      $f14, $f18, $f14
0010AA0C 460F7BC2 mul.s      $f15, $f15, $f15
0010AA10 460E8B81 sub.s      $f14, $f17, $f14
0010AA14 3C063480 lui        $a2, 0x3480
0010AA18 E60E0004 swc1       $f14, 4($s0)
0010AA1C C4909B10 lwc1       $f16, -0x64f0($a0)
0010AA20 460E7382 mul.s      $f14, $f14, $f14
0010AA24 C4B30004 lwc1       $f19, 4($a1)
0010AA28 460D8342 mul.s      $f13, $f16, $f13
0010AA2C 460C9B02 mul.s      $f12, $f19, $f12
0010AA30 460E7B80 add.s      $f14, $f15, $f14
0010AA34 44808800 mtc1       $zero, $f17
0010AA38 E611000C swc1       $f17, 0xc($s0)
0010AA3C 460C6B01 sub.s      $f12, $f13, $f12
0010AA40 44868800 mtc1       $a2, $f17
0010AA44 460C6402 mul.s      $f16, $f12, $f12
0010AA48 E60C0008 swc1       $f12, 8($s0)
0010AA4C 46107300 add.s      $f12, $f14, $f16
0010AA50 4611603C c.lt.s     $f12, $f17
0010AA54 00000000 nop        
0010AA58 4501000D bc1t       0x10aa90
0010AA5C 3C043F80 lui        $a0, 0x3f80
0010AA60 46006304 sqrt.s     $f12, $f12
0010AA64 44846800 mtc1       $a0, $f13
0010AA68 460C6B03 div.s      $f12, $f13, $f12
0010AA6C C60E0000 lwc1       $f14, ($s0)
0010AA70 C60F0004 lwc1       $f15, 4($s0)
0010AA74 C6100008 lwc1       $f16, 8($s0)
0010AA78 460C7382 mul.s      $f14, $f14, $f12
0010AA7C 460C7BC2 mul.s      $f15, $f15, $f12
0010AA80 E60E0000 swc1       $f14, ($s0)
0010AA84 460C8302 mul.s      $f12, $f16, $f12
0010AA88 E60F0004 swc1       $f15, 4($s0)
0010AA8C E60C0008 swc1       $f12, 8($s0)
0010AA90 C60C0024 lwc1       $f12, 0x24($s0)
0010AA94 C60D0008 lwc1       $f13, 8($s0)
0010AA98 C60E0028 lwc1       $f14, 0x28($s0)
0010AA9C C60F0004 lwc1       $f15, 4($s0)
0010AAA0 460D6402 mul.s      $f16, $f12, $f13
0010AAA4 C6110000 lwc1       $f17, ($s0)
0010AAA8 460F7482 mul.s      $f18, $f14, $f15
0010AAAC C6130020 lwc1       $f19, 0x20($s0)
0010AAB0 44800000 mtc1       $zero, $f0
0010AAB4 460D9B42 mul.s      $f13, $f19, $f13
0010AAB8 46116302 mul.s      $f12, $f12, $f17
0010AABC 46117382 mul.s      $f14, $f14, $f17
0010AAC0 460F9BC2 mul.s      $f15, $f19, $f15
0010AAC4 34120000 ori        $s2, $zero, 0
0010AAC8 46128401 sub.s      $f16, $f16, $f18
0010AACC 2E440004 sltiu      $a0, $s2, 4
0010AAD0 460D7341 sub.s      $f13, $f14, $f13
0010AAD4 460C7B01 sub.s      $f12, $f15, $f12
0010AAD8 E6100010 swc1       $f16, 0x10($s0)
0010AADC E600001C swc1       $f0, 0x1c($s0)
0010AAE0 E60D0014 swc1       $f13, 0x14($s0)
0010AAE4 10800065 beqz       $a0, 0x10ac7c
0010AAE8 E60C0018 swc1       $f12, 0x18($s0)
0010AAEC 3C043ECC lui        $a0, 0x3ecc
0010AAF0 3484CCCD ori        $a0, $a0, 0xcccd
0010AAF4 0C060057 jal        0x18015c
0010AAF8 4484A000 mtc1       $a0, $f20
0010AAFC 44826000 mtc1       $v0, $f12
0010AB00 3C043000 lui        $a0, 0x3000
0010AB04 46806320 cvt.s.w    $f12, $f12
0010AB08 4484B000 mtc1       $a0, $f22
0010AB0C C60D0030 lwc1       $f13, 0x30($s0)
0010AB10 3C04BE4C lui        $a0, 0xbe4c
0010AB14 3484CCCD ori        $a0, $a0, 0xcccd
0010AB18 46166302 mul.s      $f12, $f12, $f22
0010AB1C 4484C000 mtc1       $a0, $f24
0010AB20 46146302 mul.s      $f12, $f12, $f20
0010AB24 46186300 add.s      $f12, $f12, $f24
0010AB28 460D6300 add.s      $f12, $f12, $f13
0010AB2C 0C060057 jal        0x18015c
0010AB30 E7AC00C8 swc1       $f12, 0xc8($sp)
0010AB34 44826000 mtc1       $v0, $f12
0010AB38 46806320 cvt.s.w    $f12, $f12
0010AB3C C60E0034 lwc1       $f14, 0x34($s0)
0010AB40 46166302 mul.s      $f12, $f12, $f22
0010AB44 46146302 mul.s      $f12, $f12, $f20
0010AB48 46186300 add.s      $f12, $f12, $f24
0010AB4C 460E6300 add.s      $f12, $f12, $f14
0010AB50 0C060057 jal        0x18015c
0010AB54 E7AC00CC swc1       $f12, 0xcc($sp)
0010AB58 44826000 mtc1       $v0, $f12
0010AB5C 46806320 cvt.s.w    $f12, $f12
0010AB60 C60D0038 lwc1       $f13, 0x38($s0)
0010AB64 3C043E80 lui        $a0, 0x3e80
0010AB68 46166302 mul.s      $f12, $f12, $f22
0010AB6C 4484D000 mtc1       $a0, $f26
0010AB70 46146302 mul.s      $f12, $f12, $f20
0010AB74 46186300 add.s      $f12, $f12, $f24
0010AB78 460D6300 add.s      $f12, $f12, $f13
0010AB7C 0C060057 jal        0x18015c
0010AB80 E7AC00D0 swc1       $f12, 0xd0($sp)
0010AB84 44826000 mtc1       $v0, $f12
0010AB88 46806320 cvt.s.w    $f12, $f12
0010AB8C 3C043F40 lui        $a0, 0x3f40
0010AB90 4484A000 mtc1       $a0, $f20
0010AB94 3C044120 lui        $a0, 0x4120
0010AB98 46166302 mul.s      $f12, $f12, $f22
0010AB9C 4484C000 mtc1       $a0, $f24
0010ABA0 461A6302 mul.s      $f12, $f12, $f26
0010ABA4 0C060057 jal        0x18015c
0010ABA8 46146500 add.s      $f20, $f12, $f20
0010ABAC 44826800 mtc1       $v0, $f13
0010ABB0 46806B60 cvt.s.w    $f13, $f13
0010ABB4 3C043D75 lui        $a0, 0x3d75
0010ABB8 3484C28F ori        $a0, $a0, 0xc28f
0010ABBC 44807000 mtc1       $zero, $f14
0010ABC0 44846000 mtc1       $a0, $f12
0010ABC4 E7AE00D8 swc1       $f14, 0xd8($sp)
0010ABC8 3C0441C8 lui        $a0, 0x41c8
0010ABCC 46166B42 mul.s      $f13, $f13, $f22
0010ABD0 E7AC00DC swc1       $f12, 0xdc($sp)
0010ABD4 44847800 mtc1       $a0, $f15
0010ABD8 E7AE00E0 swc1       $f14, 0xe0($sp)
0010ABDC 3C044100 lui        $a0, 0x4100
0010ABE0 46186B42 mul.s      $f13, $f13, $f24
0010ABE4 E7AE00E4 swc1       $f14, 0xe4($sp)
0010ABE8 2E450002 sltiu      $a1, $s2, 2
0010ABEC 460F6B00 add.s      $f12, $f13, $f15
0010ABF0 44846800 mtc1       $a0, $f13
0010ABF4 34040003 ori        $a0, $zero, 3
0010ABF8 460D6341 sub.s      $f13, $f12, $f13
0010ABFC 54A00001 bnel       $a1, $zero, 0x10ac04
0010AC00 34040001 ori        $a0, $zero, 1
0010AC04 34070000 ori        $a3, $zero, 0
0010AC08 AFA70000 sw         $a3, ($sp)
0010AC0C 3C073CA3 lui        $a3, 0x3ca3
0010AC10 34E7D70A ori        $a3, $a3, 0xd70a
0010AC14 46006BC6 mov.s      $f15, $f13
0010AC18 44878000 mtc1       $a3, $f16
0010AC1C 00804025 move       $t0, $a0
0010AC20 3C073C23 lui        $a3, 0x3c23
0010AC24 46006386 mov.s      $f14, $f12
0010AC28 34E7D70A ori        $a3, $a3, 0xd70a
0010AC2C 44806800 mtc1       $zero, $f13
0010AC30 44878800 mtc1       $a3, $f17
0010AC34 340A0001 ori        $t2, $zero, 1
0010AC38 3C073F7A lui        $a3, 0x3f7a
0010AC3C 4600A306 mov.s      $f12, $f20
0010AC40 34E7E148 ori        $a3, $a3, 0xe148
0010AC44 46006CC6 mov.s      $f19, $f13
0010AC48 44879000 mtc1       $a3, $f18
0010AC4C 340B0000 ori        $t3, $zero, 0
0010AC50 3C078081 lui        $a3, 0x8081
0010AC54 27A500C8 addiu      $a1, $sp, 0xc8
0010AC58 27A600D8 addiu      $a2, $sp, 0xd8
0010AC5C 34040001 ori        $a0, $zero, 1
0010AC60 3409000B ori        $t1, $zero, 0xb
0010AC64 0C030CC3 jal        0xc330c
0010AC68 24E78080 addiu      $a3, $a3, -0x7f80
0010AC6C 26520001 addiu      $s2, $s2, 1
0010AC70 2E440004 sltiu      $a0, $s2, 4
0010AC74 1480FF9D bnez       $a0, 0x10aaec
0010AC78 00000000 nop        
0010AC7C 92040044 lbu        $a0, 0x44($s0)
0010AC80 8E050040 lw         $a1, 0x40($s0)
0010AC84 00043900 sll        $a3, $a0, 4
0010AC88 8E060064 lw         $a2, 0x64($s0)
0010AC8C 00872021 addu       $a0, $a0, $a3
0010AC90 8CA50004 lw         $a1, 4($a1)
0010AC94 00042080 sll        $a0, $a0, 2
0010AC98 00872023 subu       $a0, $a0, $a3
0010AC9C 00A42021 addu       $a0, $a1, $a0
0010ACA0 2485000C addiu      $a1, $a0, 0xc
0010ACA4 30D21420 andi       $s2, $a2, 0x1420
0010ACA8 8CA50000 lw         $a1, ($a1)
0010ACAC 36520001 ori        $s2, $s2, 1
0010ACB0 54A00001 bnel       $a1, $zero, 0x10acb8
0010ACB4 36520080 ori        $s2, $s2, 0x80
0010ACB8 2485000C addiu      $a1, $a0, 0xc
0010ACBC 8CA50004 lw         $a1, 4($a1)
0010ACC0 54A00001 bnel       $a1, $zero, 0x10acc8
0010ACC4 36520100 ori        $s2, $s2, 0x100
0010ACC8 8C840014 lw         $a0, 0x14($a0)
0010ACCC 54800001 bnel       $a0, $zero, 0x10acd4
0010ACD0 36520200 ori        $s2, $s2, 0x200
0010ACD4 8E040040 lw         $a0, 0x40($s0)
0010ACD8 34050001 ori        $a1, $zero, 1
0010ACDC 9084004B lbu        $a0, 0x4b($a0)
0010ACE0 50850001 beql       $a0, $a1, 0x10ace8
0010ACE4 36520800 ori        $s2, $s2, 0x800
0010ACE8 8E040064 lw         $a0, 0x64($s0)
0010ACEC 30840008 andi       $a0, $a0, 8
0010ACF0 54800001 bnel       $a0, $zero, 0x10acf8
0010ACF4 36520400 ori        $s2, $s2, 0x400
0010ACF8 8E260014 lw         $a2, 0x14($s1)
0010ACFC 36520010 ori        $s2, $s2, 0x10
0010AD00 27A40188 addiu      $a0, $sp, 0x188
0010AD04 0C019E1E jal        0x67878
0010AD08 27A50194 addiu      $a1, $sp, 0x194
0010AD0C 50400022 beql       $v0, $zero, 0x10ad98
0010AD10 C60C0020 lwc1       $f12, 0x20($s0)
0010AD14 C7AC0194 lwc1       $f12, 0x194($sp)
0010AD18 C7AD0188 lwc1       $f13, 0x188($sp)
0010AD1C C7AE019C lwc1       $f14, 0x19c($sp)
0010AD20 460D6341 sub.s      $f13, $f12, $f13
0010AD24 3C054100 lui        $a1, 0x4100
0010AD28 44857800 mtc1       $a1, $f15
0010AD2C 34040000 ori        $a0, $zero, 0
0010AD30 C7AC0190 lwc1       $f12, 0x190($sp)
0010AD34 460F683E c.le.s     $f13, $f15
0010AD38 00000000 nop        
0010AD3C 45000007 bc1f       0x10ad5c
0010AD40 460C7301 sub.s      $f12, $f14, $f12
0010AD44 3C054100 lui        $a1, 0x4100
0010AD48 44856800 mtc1       $a1, $f13
0010AD4C 460D603E c.le.s     $f12, $f13
0010AD50 00000000 nop        
0010AD54 45010003 bc1t       0x10ad64
0010AD58 00042900 sll        $a1, $a0, 4
0010AD5C 34040001 ori        $a0, $zero, 1
0010AD60 00042900 sll        $a1, $a0, 4
0010AD64 00A43023 subu       $a2, $a1, $a0
0010AD68 A2240013 sb         $a0, 0x13($s1)
0010AD6C 000620C0 sll        $a0, $a2, 3
0010AD70 00852023 subu       $a0, $a0, $a1
0010AD74 3C050006 lui        $a1, 6
0010AD78 24A5E2A8 addiu      $a1, $a1, -0x1d58
0010AD7C 00852021 addu       $a0, $a0, $a1
0010AD80 26250004 addiu      $a1, $s1, 4
0010AD84 27A60188 addiu      $a2, $sp, 0x188
0010AD88 27A70194 addiu      $a3, $sp, 0x194
0010AD8C 0C020EB5 jal        0x83ad4
0010AD90 02404025 move       $t0, $s2
0010AD94 C60C0020 lwc1       $f12, 0x20($s0)
0010AD98 C60D0024 lwc1       $f13, 0x24($s0)
0010AD9C 460C6302 mul.s      $f12, $f12, $f12
0010ADA0 C60E0028 lwc1       $f14, 0x28($s0)
0010ADA4 460D6B42 mul.s      $f13, $f13, $f13
0010ADA8 3C043480 lui        $a0, 0x3480
0010ADAC 460E7382 mul.s      $f14, $f14, $f14
0010ADB0 44847800 mtc1       $a0, $f15
0010ADB4 460D6300 add.s      $f12, $f12, $f13
0010ADB8 460E6300 add.s      $f12, $f12, $f14
0010ADBC 460F603C c.lt.s     $f12, $f15
0010ADC0 00000000 nop        
0010ADC4 4501000D bc1t       0x10adfc
0010ADC8 3C043F80 lui        $a0, 0x3f80
0010ADCC 46006304 sqrt.s     $f12, $f12
0010ADD0 44846800 mtc1       $a0, $f13
0010ADD4 460C6B03 div.s      $f12, $f13, $f12
0010ADD8 C60E0020 lwc1       $f14, 0x20($s0)
0010ADDC C60F0024 lwc1       $f15, 0x24($s0)
0010ADE0 C6100028 lwc1       $f16, 0x28($s0)
0010ADE4 460C7382 mul.s      $f14, $f14, $f12
0010ADE8 460C7BC2 mul.s      $f15, $f15, $f12
0010ADEC E60E0020 swc1       $f14, 0x20($s0)
0010ADF0 460C8302 mul.s      $f12, $f16, $f12
0010ADF4 E60F0024 swc1       $f15, 0x24($s0)
0010ADF8 E60C0028 swc1       $f12, 0x28($s0)
0010ADFC C60C0014 lwc1       $f12, 0x14($s0)
0010AE00 C60D0028 lwc1       $f13, 0x28($s0)
0010AE04 C60E0018 lwc1       $f14, 0x18($s0)
0010AE08 C60F0024 lwc1       $f15, 0x24($s0)
0010AE0C 460D6402 mul.s      $f16, $f12, $f13
0010AE10 C6110020 lwc1       $f17, 0x20($s0)
0010AE14 460F7482 mul.s      $f18, $f14, $f15
0010AE18 C6130010 lwc1       $f19, 0x10($s0)
0010AE1C 460D9B42 mul.s      $f13, $f19, $f13
0010AE20 46116302 mul.s      $f12, $f12, $f17
0010AE24 46117382 mul.s      $f14, $f14, $f17
0010AE28 46128401 sub.s      $f16, $f16, $f18
0010AE2C 460F9BC2 mul.s      $f15, $f19, $f15
0010AE30 460D7341 sub.s      $f13, $f14, $f13
0010AE34 46108002 mul.s      $f0, $f16, $f16
0010AE38 E6100000 swc1       $f16, ($s0)
0010AE3C 460C7B01 sub.s      $f12, $f15, $f12
0010AE40 3C043480 lui        $a0, 0x3480
0010AE44 E60D0004 swc1       $f13, 4($s0)
0010AE48 460D6C02 mul.s      $f16, $f13, $f13
0010AE4C 44847000 mtc1       $a0, $f14
0010AE50 44806800 mtc1       $zero, $f13
0010AE54 E60D000C swc1       $f13, 0xc($s0)
0010AE58 460C6342 mul.s      $f13, $f12, $f12
0010AE5C E60C0008 swc1       $f12, 8($s0)
0010AE60 46100300 add.s      $f12, $f0, $f16
0010AE64 460D6300 add.s      $f12, $f12, $f13
0010AE68 460E603C c.lt.s     $f12, $f14
0010AE6C 00000000 nop        
0010AE70 4501000D bc1t       0x10aea8
0010AE74 3C043F80 lui        $a0, 0x3f80
0010AE78 46006304 sqrt.s     $f12, $f12
0010AE7C 44846800 mtc1       $a0, $f13
0010AE80 460C6B03 div.s      $f12, $f13, $f12
0010AE84 C60E0000 lwc1       $f14, ($s0)
0010AE88 C60F0004 lwc1       $f15, 4($s0)
0010AE8C C6100008 lwc1       $f16, 8($s0)
0010AE90 460C7382 mul.s      $f14, $f14, $f12
0010AE94 460C7BC2 mul.s      $f15, $f15, $f12
0010AE98 E60E0000 swc1       $f14, ($s0)
0010AE9C 460C8302 mul.s      $f12, $f16, $f12
0010AEA0 E60F0004 swc1       $f15, 4($s0)
0010AEA4 E60C0008 swc1       $f12, 8($s0)
0010AEA8 C60C0024 lwc1       $f12, 0x24($s0)
0010AEAC C60D0008 lwc1       $f13, 8($s0)
0010AEB0 C60E0028 lwc1       $f14, 0x28($s0)
0010AEB4 C60F0004 lwc1       $f15, 4($s0)
0010AEB8 460D6402 mul.s      $f16, $f12, $f13
0010AEBC C6110000 lwc1       $f17, ($s0)
0010AEC0 460F7482 mul.s      $f18, $f14, $f15
0010AEC4 C6130020 lwc1       $f19, 0x20($s0)
0010AEC8 44800000 mtc1       $zero, $f0
0010AECC 460D9B42 mul.s      $f13, $f19, $f13
0010AED0 46116302 mul.s      $f12, $f12, $f17
0010AED4 46117382 mul.s      $f14, $f14, $f17
0010AED8 460F9BC2 mul.s      $f15, $f19, $f15
0010AEDC 46128401 sub.s      $f16, $f16, $f18
0010AEE0 460D7341 sub.s      $f13, $f14, $f13
0010AEE4 460C7B01 sub.s      $f12, $f15, $f12
0010AEE8 E6100010 swc1       $f16, 0x10($s0)
0010AEEC E600001C swc1       $f0, 0x1c($s0)
0010AEF0 E60D0014 swc1       $f13, 0x14($s0)
0010AEF4 E60C0018 swc1       $f12, 0x18($s0)
0010AEF8 9224008C lbu        $a0, 0x8c($s1)
0010AEFC 10800004 beqz       $a0, 0x10af10
0010AF00 00000000 nop        
0010AF04 34040005 ori        $a0, $zero, 5
0010AF08 10000003 b          0x10af18
0010AF0C A2040045 sb         $a0, 0x45($s0)
0010AF10 34040003 ori        $a0, $zero, 3
0010AF14 A2040045 sb         $a0, 0x45($s0)
0010AF18 10000276 b          0x10b8f4
0010AF1C 00000000 nop        
0010AF20 3C07002A lui        $a3, 0x2a
0010AF24 C4ECD4F4 lwc1       $f12, -0x2b0c($a3)
0010AF28 27A400AC addiu      $a0, $sp, 0xac
0010AF2C 27A500A0 addiu      $a1, $sp, 0xa0
0010AF30 27A6006C addiu      $a2, $sp, 0x6c
0010AF34 34070028 ori        $a3, $zero, 0x28
0010AF38 0C006111 jal        0x18444
0010AF3C 00004025 move       $t0, $zero
0010AF40 1040017B beqz       $v0, 0x10b530
0010AF44 00000000 nop        
0010AF48 C62C003C lwc1       $f12, 0x3c($s1)
0010AF4C 44806800 mtc1       $zero, $f13
0010AF50 46006307 neg.s      $f12, $f12
0010AF54 E7AC00E8 swc1       $f12, 0xe8($sp)
0010AF58 C62E0040 lwc1       $f14, 0x40($s1)
0010AF5C 460C6302 mul.s      $f12, $f12, $f12
0010AF60 46007387 neg.s      $f14, $f14
0010AF64 E7AE00EC swc1       $f14, 0xec($sp)
0010AF68 460D6B82 mul.s      $f14, $f13, $f13
0010AF6C C62F0044 lwc1       $f15, 0x44($s1)
0010AF70 46007BC7 neg.s      $f15, $f15
0010AF74 E7AF00F0 swc1       $f15, 0xf0($sp)
0010AF78 460E6300 add.s      $f12, $f12, $f14
0010AF7C E7AD00EC swc1       $f13, 0xec($sp)
0010AF80 460F7BC2 mul.s      $f15, $f15, $f15
0010AF84 3C043480 lui        $a0, 0x3480
0010AF88 E7AD00F4 swc1       $f13, 0xf4($sp)
0010AF8C 44846800 mtc1       $a0, $f13
0010AF90 460F6300 add.s      $f12, $f12, $f15
0010AF94 460D603C c.lt.s     $f12, $f13
0010AF98 00000000 nop        
0010AF9C 4501000D bc1t       0x10afd4
0010AFA0 3C043F80 lui        $a0, 0x3f80
0010AFA4 46006304 sqrt.s     $f12, $f12
0010AFA8 44846800 mtc1       $a0, $f13
0010AFAC 460C6B03 div.s      $f12, $f13, $f12
0010AFB0 C7AE00E8 lwc1       $f14, 0xe8($sp)
0010AFB4 C7AF00EC lwc1       $f15, 0xec($sp)
0010AFB8 C7B000F0 lwc1       $f16, 0xf0($sp)
0010AFBC 460C7382 mul.s      $f14, $f14, $f12
0010AFC0 460C7BC2 mul.s      $f15, $f15, $f12
0010AFC4 E7AE00E8 swc1       $f14, 0xe8($sp)
0010AFC8 460C8302 mul.s      $f12, $f16, $f12
0010AFCC E7AF00EC swc1       $f15, 0xec($sp)
0010AFD0 E7AC00F0 swc1       $f12, 0xf0($sp)
0010AFD4 C7AC00E8 lwc1       $f12, 0xe8($sp)
0010AFD8 C7AD00EC lwc1       $f13, 0xec($sp)
0010AFDC E60C0020 swc1       $f12, 0x20($s0)
0010AFE0 C7AE00F0 lwc1       $f14, 0xf0($sp)
0010AFE4 E60D0024 swc1       $f13, 0x24($s0)
0010AFE8 3C04002A lui        $a0, 0x2a
0010AFEC E60E0028 swc1       $f14, 0x28($s0)
0010AFF0 24859B10 addiu      $a1, $a0, -0x64f0
0010AFF4 C4AF0004 lwc1       $f15, 4($a1)
0010AFF8 C4B00008 lwc1       $f16, 8($a1)
0010AFFC 460E7BC2 mul.s      $f15, $f15, $f14
0010B000 460D8402 mul.s      $f16, $f16, $f13
0010B004 46107BC1 sub.s      $f15, $f15, $f16
0010B008 E60F0000 swc1       $f15, ($s0)
0010B00C C4B10008 lwc1       $f17, 8($a1)
0010B010 C4929B10 lwc1       $f18, -0x64f0($a0)
0010B014 460C8C42 mul.s      $f17, $f17, $f12
0010B018 460E9382 mul.s      $f14, $f18, $f14
0010B01C 460F7BC2 mul.s      $f15, $f15, $f15
0010B020 460E8B81 sub.s      $f14, $f17, $f14
0010B024 3C063480 lui        $a2, 0x3480
0010B028 E60E0004 swc1       $f14, 4($s0)
0010B02C C4909B10 lwc1       $f16, -0x64f0($a0)
0010B030 460E7382 mul.s      $f14, $f14, $f14
0010B034 C4B30004 lwc1       $f19, 4($a1)
0010B038 460D8342 mul.s      $f13, $f16, $f13
0010B03C 460C9B02 mul.s      $f12, $f19, $f12
0010B040 460E7B80 add.s      $f14, $f15, $f14
0010B044 44808800 mtc1       $zero, $f17
0010B048 E611000C swc1       $f17, 0xc($s0)
0010B04C 460C6B01 sub.s      $f12, $f13, $f12
0010B050 44868800 mtc1       $a2, $f17
0010B054 460C6402 mul.s      $f16, $f12, $f12
0010B058 E60C0008 swc1       $f12, 8($s0)
0010B05C 46107300 add.s      $f12, $f14, $f16
0010B060 4611603C c.lt.s     $f12, $f17
0010B064 00000000 nop        
0010B068 4501000D bc1t       0x10b0a0
0010B06C 3C043F80 lui        $a0, 0x3f80
0010B070 46006304 sqrt.s     $f12, $f12
0010B074 44846800 mtc1       $a0, $f13
0010B078 460C6B03 div.s      $f12, $f13, $f12
0010B07C C60E0000 lwc1       $f14, ($s0)
0010B080 C60F0004 lwc1       $f15, 4($s0)
0010B084 C6100008 lwc1       $f16, 8($s0)
0010B088 460C7382 mul.s      $f14, $f14, $f12
0010B08C 460C7BC2 mul.s      $f15, $f15, $f12
0010B090 E60E0000 swc1       $f14, ($s0)
0010B094 460C8302 mul.s      $f12, $f16, $f12
0010B098 E60F0004 swc1       $f15, 4($s0)
0010B09C E60C0008 swc1       $f12, 8($s0)
0010B0A0 C60C0024 lwc1       $f12, 0x24($s0)
0010B0A4 C60D0008 lwc1       $f13, 8($s0)
0010B0A8 C60E0028 lwc1       $f14, 0x28($s0)
0010B0AC C60F0004 lwc1       $f15, 4($s0)
0010B0B0 460D6402 mul.s      $f16, $f12, $f13
0010B0B4 C6110000 lwc1       $f17, ($s0)
0010B0B8 460F7482 mul.s      $f18, $f14, $f15
0010B0BC C6130020 lwc1       $f19, 0x20($s0)
0010B0C0 44800000 mtc1       $zero, $f0
0010B0C4 460D9B42 mul.s      $f13, $f19, $f13
0010B0C8 46116302 mul.s      $f12, $f12, $f17
0010B0CC 46117382 mul.s      $f14, $f14, $f17
0010B0D0 460F9BC2 mul.s      $f15, $f19, $f15
0010B0D4 34120000 ori        $s2, $zero, 0
0010B0D8 46128401 sub.s      $f16, $f16, $f18
0010B0DC 2E440004 sltiu      $a0, $s2, 4
0010B0E0 460D7341 sub.s      $f13, $f14, $f13
0010B0E4 460C7B01 sub.s      $f12, $f15, $f12
0010B0E8 E6100010 swc1       $f16, 0x10($s0)
0010B0EC E600001C swc1       $f0, 0x1c($s0)
0010B0F0 E60D0014 swc1       $f13, 0x14($s0)
0010B0F4 10800065 beqz       $a0, 0x10b28c
0010B0F8 E60C0018 swc1       $f12, 0x18($s0)
0010B0FC 3C043ECC lui        $a0, 0x3ecc
0010B100 3484CCCD ori        $a0, $a0, 0xcccd
0010B104 0C060057 jal        0x18015c
0010B108 4484A000 mtc1       $a0, $f20
0010B10C 44826000 mtc1       $v0, $f12
0010B110 3C043000 lui        $a0, 0x3000
0010B114 46806320 cvt.s.w    $f12, $f12
0010B118 4484B000 mtc1       $a0, $f22
0010B11C C60D0030 lwc1       $f13, 0x30($s0)
0010B120 3C04BE4C lui        $a0, 0xbe4c
0010B124 3484CCCD ori        $a0, $a0, 0xcccd
0010B128 46166302 mul.s      $f12, $f12, $f22
0010B12C 4484C000 mtc1       $a0, $f24
0010B130 46146302 mul.s      $f12, $f12, $f20
0010B134 46186300 add.s      $f12, $f12, $f24
0010B138 460D6300 add.s      $f12, $f12, $f13
0010B13C 0C060057 jal        0x18015c
0010B140 E7AC00F8 swc1       $f12, 0xf8($sp)
0010B144 44826000 mtc1       $v0, $f12
0010B148 46806320 cvt.s.w    $f12, $f12
0010B14C C60E0034 lwc1       $f14, 0x34($s0)
0010B150 46166302 mul.s      $f12, $f12, $f22
0010B154 46146302 mul.s      $f12, $f12, $f20
0010B158 46186300 add.s      $f12, $f12, $f24
0010B15C 460E6300 add.s      $f12, $f12, $f14
0010B160 0C060057 jal        0x18015c
0010B164 E7AC00FC swc1       $f12, 0xfc($sp)
0010B168 44826000 mtc1       $v0, $f12
0010B16C 46806320 cvt.s.w    $f12, $f12
0010B170 C60D0038 lwc1       $f13, 0x38($s0)
0010B174 3C043E80 lui        $a0, 0x3e80
0010B178 46166302 mul.s      $f12, $f12, $f22
0010B17C 4484D000 mtc1       $a0, $f26
0010B180 46146302 mul.s      $f12, $f12, $f20
0010B184 46186300 add.s      $f12, $f12, $f24
0010B188 460D6300 add.s      $f12, $f12, $f13
0010B18C 0C060057 jal        0x18015c
0010B190 E7AC0100 swc1       $f12, 0x100($sp)
0010B194 44826000 mtc1       $v0, $f12
0010B198 46806320 cvt.s.w    $f12, $f12
0010B19C 3C043F40 lui        $a0, 0x3f40
0010B1A0 4484A000 mtc1       $a0, $f20
0010B1A4 3C044120 lui        $a0, 0x4120
0010B1A8 46166302 mul.s      $f12, $f12, $f22
0010B1AC 4484C000 mtc1       $a0, $f24
0010B1B0 461A6302 mul.s      $f12, $f12, $f26
0010B1B4 0C060057 jal        0x18015c
0010B1B8 46146500 add.s      $f20, $f12, $f20
0010B1BC 44826800 mtc1       $v0, $f13
0010B1C0 46806B60 cvt.s.w    $f13, $f13
0010B1C4 3C043D75 lui        $a0, 0x3d75
0010B1C8 3484C28F ori        $a0, $a0, 0xc28f
0010B1CC 44807000 mtc1       $zero, $f14
0010B1D0 44846000 mtc1       $a0, $f12
0010B1D4 E7AE0108 swc1       $f14, 0x108($sp)
0010B1D8 3C0441C8 lui        $a0, 0x41c8
0010B1DC 46166B42 mul.s      $f13, $f13, $f22
0010B1E0 E7AC010C swc1       $f12, 0x10c($sp)
0010B1E4 44847800 mtc1       $a0, $f15
0010B1E8 E7AE0110 swc1       $f14, 0x110($sp)
0010B1EC 3C044100 lui        $a0, 0x4100
0010B1F0 46186B42 mul.s      $f13, $f13, $f24
0010B1F4 E7AE0114 swc1       $f14, 0x114($sp)
0010B1F8 2E450002 sltiu      $a1, $s2, 2
0010B1FC 460F6B00 add.s      $f12, $f13, $f15
0010B200 44846800 mtc1       $a0, $f13
0010B204 34040003 ori        $a0, $zero, 3
0010B208 460D6341 sub.s      $f13, $f12, $f13
0010B20C 54A00001 bnel       $a1, $zero, 0x10b214
0010B210 34040001 ori        $a0, $zero, 1
0010B214 34070000 ori        $a3, $zero, 0
0010B218 AFA70000 sw         $a3, ($sp)
0010B21C 3C073CA3 lui        $a3, 0x3ca3
0010B220 34E7D70A ori        $a3, $a3, 0xd70a
0010B224 46006BC6 mov.s      $f15, $f13
0010B228 44878000 mtc1       $a3, $f16
0010B22C 00804025 move       $t0, $a0
0010B230 3C073C23 lui        $a3, 0x3c23
0010B234 46006386 mov.s      $f14, $f12
0010B238 34E7D70A ori        $a3, $a3, 0xd70a
0010B23C 44806800 mtc1       $zero, $f13
0010B240 44878800 mtc1       $a3, $f17
0010B244 340A0001 ori        $t2, $zero, 1
0010B248 3C073F7A lui        $a3, 0x3f7a
0010B24C 4600A306 mov.s      $f12, $f20
0010B250 34E7E148 ori        $a3, $a3, 0xe148
0010B254 46006CC6 mov.s      $f19, $f13
0010B258 44879000 mtc1       $a3, $f18
0010B25C 340B0000 ori        $t3, $zero, 0
0010B260 3C078081 lui        $a3, 0x8081
0010B264 27A500F8 addiu      $a1, $sp, 0xf8
0010B268 27A60108 addiu      $a2, $sp, 0x108
0010B26C 34040001 ori        $a0, $zero, 1
0010B270 3409000B ori        $t1, $zero, 0xb
0010B274 0C030CC3 jal        0xc330c
0010B278 24E78080 addiu      $a3, $a3, -0x7f80
0010B27C 26520001 addiu      $s2, $s2, 1
0010B280 2E440004 sltiu      $a0, $s2, 4
0010B284 1480FF9D bnez       $a0, 0x10b0fc
0010B288 00000000 nop        
0010B28C 92040044 lbu        $a0, 0x44($s0)
0010B290 8E050040 lw         $a1, 0x40($s0)
0010B294 00043900 sll        $a3, $a0, 4
0010B298 8E060064 lw         $a2, 0x64($s0)
0010B29C 00872021 addu       $a0, $a0, $a3
0010B2A0 8CA50004 lw         $a1, 4($a1)
0010B2A4 00042080 sll        $a0, $a0, 2
0010B2A8 00872023 subu       $a0, $a0, $a3
0010B2AC 00A42021 addu       $a0, $a1, $a0
0010B2B0 2485000C addiu      $a1, $a0, 0xc
0010B2B4 30D21420 andi       $s2, $a2, 0x1420
0010B2B8 8CA50000 lw         $a1, ($a1)
0010B2BC 36520001 ori        $s2, $s2, 1
0010B2C0 54A00001 bnel       $a1, $zero, 0x10b2c8
0010B2C4 36520080 ori        $s2, $s2, 0x80
0010B2C8 2485000C addiu      $a1, $a0, 0xc
0010B2CC 8CA50004 lw         $a1, 4($a1)
0010B2D0 54A00001 bnel       $a1, $zero, 0x10b2d8
0010B2D4 36520100 ori        $s2, $s2, 0x100
0010B2D8 8C840014 lw         $a0, 0x14($a0)
0010B2DC 54800001 bnel       $a0, $zero, 0x10b2e4
0010B2E0 36520200 ori        $s2, $s2, 0x200
0010B2E4 8E040040 lw         $a0, 0x40($s0)
0010B2E8 34050001 ori        $a1, $zero, 1
0010B2EC 9084004B lbu        $a0, 0x4b($a0)
0010B2F0 50850001 beql       $a0, $a1, 0x10b2f8
0010B2F4 36520800 ori        $s2, $s2, 0x800
0010B2F8 8E040064 lw         $a0, 0x64($s0)
0010B2FC 30840008 andi       $a0, $a0, 8
0010B300 54800001 bnel       $a0, $zero, 0x10b308
0010B304 36520400 ori        $s2, $s2, 0x400
0010B308 8E260014 lw         $a2, 0x14($s1)
0010B30C 36520010 ori        $s2, $s2, 0x10
0010B310 27A401A0 addiu      $a0, $sp, 0x1a0
0010B314 0C019E1E jal        0x67878
0010B318 27A501AC addiu      $a1, $sp, 0x1ac
0010B31C 50400022 beql       $v0, $zero, 0x10b3a8
0010B320 C60C0020 lwc1       $f12, 0x20($s0)
0010B324 C7AC01AC lwc1       $f12, 0x1ac($sp)
0010B328 C7AD01A0 lwc1       $f13, 0x1a0($sp)
0010B32C C7AE01B4 lwc1       $f14, 0x1b4($sp)
0010B330 460D6341 sub.s      $f13, $f12, $f13
0010B334 3C054100 lui        $a1, 0x4100
0010B338 44857800 mtc1       $a1, $f15
0010B33C 34040000 ori        $a0, $zero, 0
0010B340 C7AC01A8 lwc1       $f12, 0x1a8($sp)
0010B344 460F683E c.le.s     $f13, $f15
0010B348 00000000 nop        
0010B34C 45000007 bc1f       0x10b36c
0010B350 460C7301 sub.s      $f12, $f14, $f12
0010B354 3C054100 lui        $a1, 0x4100
0010B358 44856800 mtc1       $a1, $f13
0010B35C 460D603E c.le.s     $f12, $f13
0010B360 00000000 nop        
0010B364 45010003 bc1t       0x10b374
0010B368 00042900 sll        $a1, $a0, 4
0010B36C 34040001 ori        $a0, $zero, 1
0010B370 00042900 sll        $a1, $a0, 4
0010B374 00A43023 subu       $a2, $a1, $a0
0010B378 A2240013 sb         $a0, 0x13($s1)
0010B37C 000620C0 sll        $a0, $a2, 3
0010B380 00852023 subu       $a0, $a0, $a1
0010B384 3C050006 lui        $a1, 6
0010B388 24A5E2A8 addiu      $a1, $a1, -0x1d58
0010B38C 00852021 addu       $a0, $a0, $a1
0010B390 26250004 addiu      $a1, $s1, 4
0010B394 27A601A0 addiu      $a2, $sp, 0x1a0
0010B398 27A701AC addiu      $a3, $sp, 0x1ac
0010B39C 0C020EB5 jal        0x83ad4
0010B3A0 02404025 move       $t0, $s2
0010B3A4 C60C0020 lwc1       $f12, 0x20($s0)
0010B3A8 C60D0024 lwc1       $f13, 0x24($s0)
0010B3AC 460C6302 mul.s      $f12, $f12, $f12
0010B3B0 C60E0028 lwc1       $f14, 0x28($s0)
0010B3B4 460D6B42 mul.s      $f13, $f13, $f13
0010B3B8 3C043480 lui        $a0, 0x3480
0010B3BC 460E7382 mul.s      $f14, $f14, $f14
0010B3C0 44847800 mtc1       $a0, $f15
0010B3C4 460D6300 add.s      $f12, $f12, $f13
0010B3C8 460E6300 add.s      $f12, $f12, $f14
0010B3CC 460F603C c.lt.s     $f12, $f15
0010B3D0 00000000 nop        
0010B3D4 4501000D bc1t       0x10b40c
0010B3D8 3C043F80 lui        $a0, 0x3f80
0010B3DC 46006304 sqrt.s     $f12, $f12
0010B3E0 44846800 mtc1       $a0, $f13
0010B3E4 460C6B03 div.s      $f12, $f13, $f12
0010B3E8 C60E0020 lwc1       $f14, 0x20($s0)
0010B3EC C60F0024 lwc1       $f15, 0x24($s0)
0010B3F0 C6100028 lwc1       $f16, 0x28($s0)
0010B3F4 460C7382 mul.s      $f14, $f14, $f12
0010B3F8 460C7BC2 mul.s      $f15, $f15, $f12
0010B3FC E60E0020 swc1       $f14, 0x20($s0)
0010B400 460C8302 mul.s      $f12, $f16, $f12
0010B404 E60F0024 swc1       $f15, 0x24($s0)
0010B408 E60C0028 swc1       $f12, 0x28($s0)
0010B40C C60C0014 lwc1       $f12, 0x14($s0)
0010B410 C60D0028 lwc1       $f13, 0x28($s0)
0010B414 C60E0018 lwc1       $f14, 0x18($s0)
0010B418 C60F0024 lwc1       $f15, 0x24($s0)
0010B41C 460D6402 mul.s      $f16, $f12, $f13
0010B420 C6110020 lwc1       $f17, 0x20($s0)
0010B424 460F7482 mul.s      $f18, $f14, $f15
0010B428 C6130010 lwc1       $f19, 0x10($s0)
0010B42C 460D9B42 mul.s      $f13, $f19, $f13
0010B430 46116302 mul.s      $f12, $f12, $f17
0010B434 46117382 mul.s      $f14, $f14, $f17
0010B438 46128401 sub.s      $f16, $f16, $f18
0010B43C 460F9BC2 mul.s      $f15, $f19, $f15
0010B440 460D7341 sub.s      $f13, $f14, $f13
0010B444 46108002 mul.s      $f0, $f16, $f16
0010B448 E6100000 swc1       $f16, ($s0)
0010B44C 460C7B01 sub.s      $f12, $f15, $f12
0010B450 3C043480 lui        $a0, 0x3480
0010B454 E60D0004 swc1       $f13, 4($s0)
0010B458 460D6C02 mul.s      $f16, $f13, $f13
0010B45C 44847000 mtc1       $a0, $f14
0010B460 44806800 mtc1       $zero, $f13
0010B464 E60D000C swc1       $f13, 0xc($s0)
0010B468 460C6342 mul.s      $f13, $f12, $f12
0010B46C E60C0008 swc1       $f12, 8($s0)
0010B470 46100300 add.s      $f12, $f0, $f16
0010B474 460D6300 add.s      $f12, $f12, $f13
0010B478 460E603C c.lt.s     $f12, $f14
0010B47C 00000000 nop        
0010B480 4501000D bc1t       0x10b4b8
0010B484 3C043F80 lui        $a0, 0x3f80
0010B488 46006304 sqrt.s     $f12, $f12
0010B48C 44846800 mtc1       $a0, $f13
0010B490 460C6B03 div.s      $f12, $f13, $f12
0010B494 C60E0000 lwc1       $f14, ($s0)
0010B498 C60F0004 lwc1       $f15, 4($s0)
0010B49C C6100008 lwc1       $f16, 8($s0)
0010B4A0 460C7382 mul.s      $f14, $f14, $f12
0010B4A4 460C7BC2 mul.s      $f15, $f15, $f12
0010B4A8 E60E0000 swc1       $f14, ($s0)
0010B4AC 460C8302 mul.s      $f12, $f16, $f12
0010B4B0 E60F0004 swc1       $f15, 4($s0)
0010B4B4 E60C0008 swc1       $f12, 8($s0)
0010B4B8 C60C0024 lwc1       $f12, 0x24($s0)
0010B4BC C60D0008 lwc1       $f13, 8($s0)
0010B4C0 C60E0028 lwc1       $f14, 0x28($s0)
0010B4C4 C60F0004 lwc1       $f15, 4($s0)
0010B4C8 460D6402 mul.s      $f16, $f12, $f13
0010B4CC C6110000 lwc1       $f17, ($s0)
0010B4D0 460F7482 mul.s      $f18, $f14, $f15
0010B4D4 C6130020 lwc1       $f19, 0x20($s0)
0010B4D8 44800000 mtc1       $zero, $f0
0010B4DC 460D9B42 mul.s      $f13, $f19, $f13
0010B4E0 46116302 mul.s      $f12, $f12, $f17
0010B4E4 46117382 mul.s      $f14, $f14, $f17
0010B4E8 460F9BC2 mul.s      $f15, $f19, $f15
0010B4EC 46128401 sub.s      $f16, $f16, $f18
0010B4F0 460D7341 sub.s      $f13, $f14, $f13
0010B4F4 460C7B01 sub.s      $f12, $f15, $f12
0010B4F8 E6100010 swc1       $f16, 0x10($s0)
0010B4FC E600001C swc1       $f0, 0x1c($s0)
0010B500 E60D0014 swc1       $f13, 0x14($s0)
0010B504 E60C0018 swc1       $f12, 0x18($s0)
0010B508 9224008C lbu        $a0, 0x8c($s1)
0010B50C 10800004 beqz       $a0, 0x10b520
0010B510 00000000 nop        
0010B514 34040005 ori        $a0, $zero, 5
0010B518 10000003 b          0x10b528
0010B51C A2040045 sb         $a0, 0x45($s0)
0010B520 34040003 ori        $a0, $zero, 3
0010B524 A2040045 sb         $a0, 0x45($s0)
0010B528 100000F2 b          0x10b8f4
0010B52C 00000000 nop        
0010B530 92040045 lbu        $a0, 0x45($s0)
0010B534 34050002 ori        $a1, $zero, 2
0010B538 1085000D beq        $a0, $a1, 0x10b570
0010B53C 3C040006 lui        $a0, 6
0010B540 C7AC0064 lwc1       $f12, 0x64($sp)
0010B544 2484E2A8 addiu      $a0, $a0, -0x1d58
0010B548 C48D000C lwc1       $f13, 0xc($a0)
0010B54C 27A40084 addiu      $a0, $sp, 0x84
0010B550 460D6301 sub.s      $f12, $f12, $f13
0010B554 27A50088 addiu      $a1, $sp, 0x88
0010B558 27A60060 addiu      $a2, $sp, 0x60
0010B55C 34070028 ori        $a3, $zero, 0x28
0010B560 0C0063F5 jal        0x18fd4
0010B564 00004025 move       $t0, $zero
0010B568 14400009 bnez       $v0, 0x10b590
0010B56C 00000000 nop        
0010B570 34040002 ori        $a0, $zero, 2
0010B574 A2040045 sb         $a0, 0x45($s0)
0010B578 8E24007C lw         $a0, 0x7c($s1)
0010B57C 24840001 addiu      $a0, $a0, 1
0010B580 AE24007C sw         $a0, 0x7c($s1)
0010B584 2C84001E sltiu      $a0, $a0, 0x1e
0010B588 10800015 beqz       $a0, 0x10b5e0
0010B58C 00000000 nop        
0010B590 C62C0048 lwc1       $f12, 0x48($s1)
0010B594 27A40118 addiu      $a0, $sp, 0x118
0010B598 0C03AC60 jal        0xeb180
0010B59C 2625002C addiu      $a1, $s1, 0x2c
0010B5A0 C60C0020 lwc1       $f12, 0x20($s0)
0010B5A4 C60D0024 lwc1       $f13, 0x24($s0)
0010B5A8 460C6302 mul.s      $f12, $f12, $f12
0010B5AC C60E0028 lwc1       $f14, 0x28($s0)
0010B5B0 460D6B42 mul.s      $f13, $f13, $f13
0010B5B4 3C043480 lui        $a0, 0x3480
0010B5B8 460E7382 mul.s      $f14, $f14, $f14
0010B5BC 44847800 mtc1       $a0, $f15
0010B5C0 460D6300 add.s      $f12, $f12, $f13
0010B5C4 460E6300 add.s      $f12, $f12, $f14
0010B5C8 460F603C c.lt.s     $f12, $f15
0010B5CC 00000000 nop        
0010B5D0 45030015 bc1tl      0x10b628
0010B5D4 C60C0014 lwc1       $f12, 0x14($s0)
0010B5D8 10000006 b          0x10b5f4
0010B5DC 3C043F80 lui        $a0, 0x3f80
0010B5E0 8E240028 lw         $a0, 0x28($s1)
0010B5E4 0C0192FF jal        0x64bfc
0010B5E8 34050001 ori        $a1, $zero, 1
0010B5EC 10000288 b          0x10c010
0010B5F0 00000000 nop        
0010B5F4 46006304 sqrt.s     $f12, $f12
0010B5F8 44846800 mtc1       $a0, $f13
0010B5FC 460C6B03 div.s      $f12, $f13, $f12
0010B600 C60E0020 lwc1       $f14, 0x20($s0)
0010B604 C60F0024 lwc1       $f15, 0x24($s0)
0010B608 C6100028 lwc1       $f16, 0x28($s0)
0010B60C 460C7382 mul.s      $f14, $f14, $f12
0010B610 460C7BC2 mul.s      $f15, $f15, $f12
0010B614 E60E0020 swc1       $f14, 0x20($s0)
0010B618 460C8302 mul.s      $f12, $f16, $f12
0010B61C E60F0024 swc1       $f15, 0x24($s0)
0010B620 E60C0028 swc1       $f12, 0x28($s0)
0010B624 C60C0014 lwc1       $f12, 0x14($s0)
0010B628 C60D0028 lwc1       $f13, 0x28($s0)
0010B62C C60E0018 lwc1       $f14, 0x18($s0)
0010B630 C60F0024 lwc1       $f15, 0x24($s0)
0010B634 460D6402 mul.s      $f16, $f12, $f13
0010B638 C6110020 lwc1       $f17, 0x20($s0)
0010B63C 460F7482 mul.s      $f18, $f14, $f15
0010B640 C6130010 lwc1       $f19, 0x10($s0)
0010B644 460D9B42 mul.s      $f13, $f19, $f13
0010B648 46116302 mul.s      $f12, $f12, $f17
0010B64C 46117382 mul.s      $f14, $f14, $f17
0010B650 46128401 sub.s      $f16, $f16, $f18
0010B654 460F9BC2 mul.s      $f15, $f19, $f15
0010B658 460D7341 sub.s      $f13, $f14, $f13
0010B65C 46108002 mul.s      $f0, $f16, $f16
0010B660 E6100000 swc1       $f16, ($s0)
0010B664 460C7B01 sub.s      $f12, $f15, $f12
0010B668 3C043480 lui        $a0, 0x3480
0010B66C E60D0004 swc1       $f13, 4($s0)
0010B670 460D6C02 mul.s      $f16, $f13, $f13
0010B674 44847000 mtc1       $a0, $f14
0010B678 44806800 mtc1       $zero, $f13
0010B67C E60D000C swc1       $f13, 0xc($s0)
0010B680 460C6342 mul.s      $f13, $f12, $f12
0010B684 E60C0008 swc1       $f12, 8($s0)
0010B688 46100300 add.s      $f12, $f0, $f16
0010B68C 460D6300 add.s      $f12, $f12, $f13
0010B690 460E603C c.lt.s     $f12, $f14
0010B694 00000000 nop        
0010B698 4501000D bc1t       0x10b6d0
0010B69C 3C043F80 lui        $a0, 0x3f80
0010B6A0 46006304 sqrt.s     $f12, $f12
0010B6A4 44846800 mtc1       $a0, $f13
0010B6A8 460C6B03 div.s      $f12, $f13, $f12
0010B6AC C60E0000 lwc1       $f14, ($s0)
0010B6B0 C60F0004 lwc1       $f15, 4($s0)
0010B6B4 C6100008 lwc1       $f16, 8($s0)
0010B6B8 460C7382 mul.s      $f14, $f14, $f12
0010B6BC 460C7BC2 mul.s      $f15, $f15, $f12
0010B6C0 E60E0000 swc1       $f14, ($s0)
0010B6C4 460C8302 mul.s      $f12, $f16, $f12
0010B6C8 E60F0004 swc1       $f15, 4($s0)
0010B6CC E60C0008 swc1       $f12, 8($s0)
0010B6D0 C60C0024 lwc1       $f12, 0x24($s0)
0010B6D4 C60D0008 lwc1       $f13, 8($s0)
0010B6D8 C60E0028 lwc1       $f14, 0x28($s0)
0010B6DC C60F0004 lwc1       $f15, 4($s0)
0010B6E0 460D6402 mul.s      $f16, $f12, $f13
0010B6E4 C6110000 lwc1       $f17, ($s0)
0010B6E8 460F7482 mul.s      $f18, $f14, $f15
0010B6EC C6130020 lwc1       $f19, 0x20($s0)
0010B6F0 44800000 mtc1       $zero, $f0
0010B6F4 460D9B42 mul.s      $f13, $f19, $f13
0010B6F8 46116302 mul.s      $f12, $f12, $f17
0010B6FC 46117382 mul.s      $f14, $f14, $f17
0010B700 460F9BC2 mul.s      $f15, $f19, $f15
0010B704 46128401 sub.s      $f16, $f16, $f18
0010B708 27A60118 addiu      $a2, $sp, 0x118
0010B70C 02002025 move       $a0, $s0
0010B710 460D7341 sub.s      $f13, $f14, $f13
0010B714 02002825 move       $a1, $s0
0010B718 460C7B01 sub.s      $f12, $f15, $f12
0010B71C E6100010 swc1       $f16, 0x10($s0)
0010B720 E600001C swc1       $f0, 0x1c($s0)
0010B724 E60D0014 swc1       $f13, 0x14($s0)
0010B728 0C03BA8F jal        0xeea3c
0010B72C E60C0018 swc1       $f12, 0x18($s0)
0010B730 C62C0054 lwc1       $f12, 0x54($s1)
0010B734 3C043F80 lui        $a0, 0x3f80
0010B738 44846800 mtc1       $a0, $f13
0010B73C 460D603C c.lt.s     $f12, $f13
0010B740 00000000 nop        
0010B744 4502005A bc1fl      0x10b8b0
0010B748 C62C003C lwc1       $f12, 0x3c($s1)
0010B74C C62C0054 lwc1       $f12, 0x54($s1)
0010B750 3C04002A lui        $a0, 0x2a
0010B754 C48DD4D4 lwc1       $f13, -0x2b2c($a0)
0010B758 3C043F80 lui        $a0, 0x3f80
0010B75C 460D6300 add.s      $f12, $f12, $f13
0010B760 44847000 mtc1       $a0, $f14
0010B764 460E603E c.le.s     $f12, $f14
0010B768 00000000 nop        
0010B76C 45010004 bc1t       0x10b780
0010B770 E62C0054 swc1       $f12, 0x54($s1)
0010B774 3C043F80 lui        $a0, 0x3f80
0010B778 44846000 mtc1       $a0, $f12
0010B77C E62C0054 swc1       $f12, 0x54($s1)
0010B780 C60C0010 lwc1       $f12, 0x10($s0)
0010B784 C60D0014 lwc1       $f13, 0x14($s0)
0010B788 460C6382 mul.s      $f14, $f12, $f12
0010B78C C60F0018 lwc1       $f15, 0x18($s0)
0010B790 460D6B42 mul.s      $f13, $f13, $f13
0010B794 3C043480 lui        $a0, 0x3480
0010B798 460F7BC2 mul.s      $f15, $f15, $f15
0010B79C 44848000 mtc1       $a0, $f16
0010B7A0 460D7340 add.s      $f13, $f14, $f13
0010B7A4 460F6B40 add.s      $f13, $f13, $f15
0010B7A8 4610683C c.lt.s     $f13, $f16
0010B7AC 00000000 nop        
0010B7B0 4501000C bc1t       0x10b7e4
0010B7B4 C62C0054 lwc1       $f12, 0x54($s1)
0010B7B8 46006B44 sqrt.s     $f13, $f13
0010B7BC 460D6303 div.s      $f12, $f12, $f13
0010B7C0 C60E0010 lwc1       $f14, 0x10($s0)
0010B7C4 C60F0014 lwc1       $f15, 0x14($s0)
0010B7C8 C6100018 lwc1       $f16, 0x18($s0)
0010B7CC 460C7382 mul.s      $f14, $f14, $f12
0010B7D0 460C7BC2 mul.s      $f15, $f15, $f12
0010B7D4 E60E0010 swc1       $f14, 0x10($s0)
0010B7D8 460C8302 mul.s      $f12, $f16, $f12
0010B7DC E60F0014 swc1       $f15, 0x14($s0)
0010B7E0 E60C0018 swc1       $f12, 0x18($s0)
0010B7E4 C60C0020 lwc1       $f12, 0x20($s0)
0010B7E8 C60D0024 lwc1       $f13, 0x24($s0)
0010B7EC 460C6382 mul.s      $f14, $f12, $f12
0010B7F0 C60F0028 lwc1       $f15, 0x28($s0)
0010B7F4 460D6B42 mul.s      $f13, $f13, $f13
0010B7F8 3C043480 lui        $a0, 0x3480
0010B7FC 460F7BC2 mul.s      $f15, $f15, $f15
0010B800 44848000 mtc1       $a0, $f16
0010B804 460D7340 add.s      $f13, $f14, $f13
0010B808 460F6B40 add.s      $f13, $f13, $f15
0010B80C 4610683C c.lt.s     $f13, $f16
0010B810 00000000 nop        
0010B814 4501000C bc1t       0x10b848
0010B818 C62C0054 lwc1       $f12, 0x54($s1)
0010B81C 46006B44 sqrt.s     $f13, $f13
0010B820 460D6303 div.s      $f12, $f12, $f13
0010B824 C60E0020 lwc1       $f14, 0x20($s0)
0010B828 C60F0024 lwc1       $f15, 0x24($s0)
0010B82C C6100028 lwc1       $f16, 0x28($s0)
0010B830 460C7382 mul.s      $f14, $f14, $f12
0010B834 460C7BC2 mul.s      $f15, $f15, $f12
0010B838 E60E0020 swc1       $f14, 0x20($s0)
0010B83C 460C8302 mul.s      $f12, $f16, $f12
0010B840 E60F0024 swc1       $f15, 0x24($s0)
0010B844 E60C0028 swc1       $f12, 0x28($s0)
0010B848 C60C0000 lwc1       $f12, ($s0)
0010B84C C60D0004 lwc1       $f13, 4($s0)
0010B850 460C6382 mul.s      $f14, $f12, $f12
0010B854 C60F0008 lwc1       $f15, 8($s0)
0010B858 460D6B42 mul.s      $f13, $f13, $f13
0010B85C 3C043480 lui        $a0, 0x3480
0010B860 460F7BC2 mul.s      $f15, $f15, $f15
0010B864 44848000 mtc1       $a0, $f16
0010B868 460D7340 add.s      $f13, $f14, $f13
0010B86C 460F6B40 add.s      $f13, $f13, $f15
0010B870 4610683C c.lt.s     $f13, $f16
0010B874 00000000 nop        
0010B878 4501000C bc1t       0x10b8ac
0010B87C C62C0054 lwc1       $f12, 0x54($s1)
0010B880 46006B44 sqrt.s     $f13, $f13
0010B884 460D6303 div.s      $f12, $f12, $f13
0010B888 C60E0000 lwc1       $f14, ($s0)
0010B88C C60F0004 lwc1       $f15, 4($s0)
0010B890 C6100008 lwc1       $f16, 8($s0)
0010B894 460C7382 mul.s      $f14, $f14, $f12
0010B898 460C7BC2 mul.s      $f15, $f15, $f12
0010B89C E60E0000 swc1       $f14, ($s0)
0010B8A0 460C8302 mul.s      $f12, $f16, $f12
0010B8A4 E60F0004 swc1       $f15, 4($s0)
0010B8A8 E60C0008 swc1       $f12, 8($s0)
0010B8AC C62C003C lwc1       $f12, 0x3c($s1)
0010B8B0 C62D001C lwc1       $f13, 0x1c($s1)
0010B8B4 C62E0040 lwc1       $f14, 0x40($s1)
0010B8B8 460D6300 add.s      $f12, $f12, $f13
0010B8BC C62F0020 lwc1       $f15, 0x20($s1)
0010B8C0 C6300044 lwc1       $f16, 0x44($s1)
0010B8C4 C6310024 lwc1       $f17, 0x24($s1)
0010B8C8 460F7380 add.s      $f14, $f14, $f15
0010B8CC E62C003C swc1       $f12, 0x3c($s1)
0010B8D0 46118300 add.s      $f12, $f16, $f17
0010B8D4 E62E0040 swc1       $f14, 0x40($s1)
0010B8D8 E62C0044 swc1       $f12, 0x44($s1)
0010B8DC C7AC006C lwc1       $f12, 0x6c($sp)
0010B8E0 C7AD0070 lwc1       $f13, 0x70($sp)
0010B8E4 E60C0030 swc1       $f12, 0x30($s0)
0010B8E8 C7AC0074 lwc1       $f12, 0x74($sp)
0010B8EC E60D0034 swc1       $f13, 0x34($s0)
0010B8F0 E60C0038 swc1       $f12, 0x38($s0)
0010B8F4 9224008C lbu        $a0, 0x8c($s1)
0010B8F8 10800004 beqz       $a0, 0x10b90c
0010B8FC 00000000 nop        
0010B900 8E240028 lw         $a0, 0x28($s1)
0010B904 0C056F69 jal        0x15bda4
0010B908 26050030 addiu      $a1, $s0, 0x30
0010B90C 96240010 lhu        $a0, 0x10($s1)
0010B910 2405FFF7 addiu      $a1, $zero, -9
0010B914 00852024 and        $a0, $a0, $a1
0010B918 A6240010 sh         $a0, 0x10($s1)
0010B91C C60C0034 lwc1       $f12, 0x34($s0)
0010B920 0C003F0A jal        0xfc28
0010B924 00002025 move       $a0, $zero
0010B928 14400003 bnez       $v0, 0x10b938
0010B92C 00000000 nop        
0010B930 100000BA b          0x10bc1c
0010B934 00000000 nop        
0010B938 8E240028 lw         $a0, 0x28($s1)
0010B93C 0C0192FF jal        0x64bfc
0010B940 34050001 ori        $a1, $zero, 1
0010B944 100001B2 b          0x10c010
0010B948 00000000 nop        
0010B94C 8E240028 lw         $a0, 0x28($s1)
0010B950 0C056F69 jal        0x15bda4
0010B954 26050030 addiu      $a1, $s0, 0x30
0010B958 0C056FA5 jal        0x15be94
0010B95C 8E240028 lw         $a0, 0x28($s1)
0010B960 0C042937 jal        0x10a4dc
0010B964 02002025 move       $a0, $s0
0010B968 34040004 ori        $a0, $zero, 4
0010B96C 100000AB b          0x10bc1c
0010B970 A2040045 sb         $a0, 0x45($s0)
0010B974 0C04295A jal        0x10a568
0010B978 02002025 move       $a0, $s0
0010B97C C60C0070 lwc1       $f12, 0x70($s0)
0010B980 3C043F80 lui        $a0, 0x3f80
0010B984 44846800 mtc1       $a0, $f13
0010B988 460D6300 add.s      $f12, $f12, $f13
0010B98C 3C044100 lui        $a0, 0x4100
0010B990 44847000 mtc1       $a0, $f14
0010B994 460E603C c.lt.s     $f12, $f14
0010B998 00000000 nop        
0010B99C 4501002B bc1t       0x10ba4c
0010B9A0 E60C0070 swc1       $f12, 0x70($s0)
0010B9A4 C62C003C lwc1       $f12, 0x3c($s1)
0010B9A8 C62D0040 lwc1       $f13, 0x40($s1)
0010B9AC 460C6382 mul.s      $f14, $f12, $f12
0010B9B0 C62F0044 lwc1       $f15, 0x44($s1)
0010B9B4 460D6B42 mul.s      $f13, $f13, $f13
0010B9B8 460F7BC2 mul.s      $f15, $f15, $f15
0010B9BC 3C043F80 lui        $a0, 0x3f80
0010B9C0 44848000 mtc1       $a0, $f16
0010B9C4 460D7340 add.s      $f13, $f14, $f13
0010B9C8 460F6B40 add.s      $f13, $f13, $f15
0010B9CC 46006B44 sqrt.s     $f13, $f13
0010B9D0 460D8343 div.s      $f13, $f16, $f13
0010B9D4 26060030 addiu      $a2, $s0, 0x30
0010B9D8 27A7013C addiu      $a3, $sp, 0x13c
0010B9DC 02002025 move       $a0, $s0
0010B9E0 460C6B02 mul.s      $f12, $f13, $f12
0010B9E4 E7AC013C swc1       $f12, 0x13c($sp)
0010B9E8 C62C0040 lwc1       $f12, 0x40($s1)
0010B9EC 460C6B02 mul.s      $f12, $f13, $f12
0010B9F0 E7AC0140 swc1       $f12, 0x140($sp)
0010B9F4 C62C0044 lwc1       $f12, 0x44($s1)
0010B9F8 460C6B02 mul.s      $f12, $f13, $f12
0010B9FC E7AC0144 swc1       $f12, 0x144($sp)
0010BA00 8E250028 lw         $a1, 0x28($s1)
0010BA04 8E280038 lw         $t0, 0x38($s1)
0010BA08 0C0485CE jal        0x121738
0010BA0C 8E290088 lw         $t1, 0x88($s1)
0010BA10 00402025 move       $a0, $v0
0010BA14 1080000D beqz       $a0, 0x10ba4c
0010BA18 00000000 nop        
0010BA1C 00802825 move       $a1, $a0
0010BA20 8E240000 lw         $a0, ($s1)
0010BA24 8CA60058 lw         $a2, 0x58($a1)
0010BA28 ACC40000 sw         $a0, ($a2)
0010BA2C 8E240028 lw         $a0, 0x28($s1)
0010BA30 0C056FC2 jal        0x15bf08
0010BA34 8E260038 lw         $a2, 0x38($s1)
0010BA38 8E240038 lw         $a0, 0x38($s1)
0010BA3C 44806000 mtc1       $zero, $f12
0010BA40 24840001 addiu      $a0, $a0, 1
0010BA44 AE240038 sw         $a0, 0x38($s1)
0010BA48 E60C0070 swc1       $f12, 0x70($s0)
0010BA4C 8E240038 lw         $a0, 0x38($s1)
0010BA50 34050005 ori        $a1, $zero, 5
0010BA54 14850005 bne        $a0, $a1, 0x10ba6c
0010BA58 00000000 nop        
0010BA5C 34040005 ori        $a0, $zero, 5
0010BA60 A2040045 sb         $a0, 0x45($s0)
0010BA64 34040001 ori        $a0, $zero, 1
0010BA68 A224008C sb         $a0, 0x8c($s1)
0010BA6C 1000006B b          0x10bc1c
0010BA70 00000000 nop        
0010BA74 0C04295A jal        0x10a568
0010BA78 02002025 move       $a0, $s0
0010BA7C C60C0070 lwc1       $f12, 0x70($s0)
0010BA80 3C043F80 lui        $a0, 0x3f80
0010BA84 44846800 mtc1       $a0, $f13
0010BA88 460D6300 add.s      $f12, $f12, $f13
0010BA8C 3C04002A lui        $a0, 0x2a
0010BA90 C48ED4C0 lwc1       $f14, -0x2b40($a0)
0010BA94 460E603E c.le.s     $f12, $f14
0010BA98 00000000 nop        
0010BA9C 45010003 bc1t       0x10baac
0010BAA0 E60C0070 swc1       $f12, 0x70($s0)
0010BAA4 0C042886 jal        0x10a218
0010BAA8 02002025 move       $a0, $s0
0010BAAC 1000005B b          0x10bc1c
0010BAB0 00000000 nop        
0010BAB4 8E240000 lw         $a0, ($s1)
0010BAB8 0C043209 jal        0x10c824
0010BABC 02002825 move       $a1, $s0
0010BAC0 AE200028 sw         $zero, 0x28($s1)
0010BAC4 34040008 ori        $a0, $zero, 8
0010BAC8 8E050064 lw         $a1, 0x64($s0)
0010BACC A2040045 sb         $a0, 0x45($s0)
0010BAD0 34A40020 ori        $a0, $a1, 0x20
0010BAD4 AE040064 sw         $a0, 0x64($s0)
0010BAD8 3C04002A lui        $a0, 0x2a
0010BADC 8C84D500 lw         $a0, -0x2b00($a0)
0010BAE0 10800012 beqz       $a0, 0x10bb2c
0010BAE4 00000000 nop        
0010BAE8 3C04002A lui        $a0, 0x2a
0010BAEC 8C84D500 lw         $a0, -0x2b00($a0)
0010BAF0 1080000E beqz       $a0, 0x10bb2c
0010BAF4 3C04002A lui        $a0, 0x2a
0010BAF8 8C85D500 lw         $a1, -0x2b00($a0)
0010BAFC 34070000 ori        $a3, $zero, 0
0010BB00 C4AC0014 lwc1       $f12, 0x14($a1)
0010BB04 C4AD0018 lwc1       $f13, 0x18($a1)
0010BB08 C4AE001C lwc1       $f14, 0x1c($a1)
0010BB0C C4AF0020 lwc1       $f15, 0x20($a1)
0010BB10 34090000 ori        $t1, $zero, 0
0010BB14 340A0000 ori        $t2, $zero, 0
0010BB18 340B0001 ori        $t3, $zero, 1
0010BB1C 02002025 move       $a0, $s0
0010BB20 00003025 move       $a2, $zero
0010BB24 0C019B4F jal        0x66d3c
0010BB28 00004025 move       $t0, $zero
0010BB2C 1000003B b          0x10bc1c
0010BB30 00000000 nop        
0010BB34 8E040064 lw         $a0, 0x64($s0)
0010BB38 2405FFFF addiu      $a1, $zero, -1
0010BB3C 34840040 ori        $a0, $a0, 0x40
0010BB40 AE040064 sw         $a0, 0x64($s0)
0010BB44 AE050068 sw         $a1, 0x68($s0)
0010BB48 AE200028 sw         $zero, 0x28($s1)
0010BB4C 34040008 ori        $a0, $zero, 8
0010BB50 10000032 b          0x10bc1c
0010BB54 A2040045 sb         $a0, 0x45($s0)
0010BB58 C62C004C lwc1       $f12, 0x4c($s1)
0010BB5C 44806800 mtc1       $zero, $f13
0010BB60 460D6032 c.eq.s     $f12, $f13
0010BB64 00000000 nop        
0010BB68 45010027 bc1t       0x10bc08
0010BB6C 00000000 nop        
0010BB70 0C04295A jal        0x10a568
0010BB74 02002025 move       $a0, $s0
0010BB78 C62D004C lwc1       $f13, 0x4c($s1)
0010BB7C 44806000 mtc1       $zero, $f12
0010BB80 3C04002A lui        $a0, 0x2a
0010BB84 C48ED4BC lwc1       $f14, -0x2b44($a0)
0010BB88 460E6B41 sub.s      $f13, $f13, $f14
0010BB8C E62D004C swc1       $f13, 0x4c($s1)
0010BB90 460C683C c.lt.s     $f13, $f12
0010BB94 00000000 nop        
0010BB98 45030001 bc1tl      0x10bba0
0010BB9C E62C004C swc1       $f12, 0x4c($s1)
0010BBA0 C62C004C lwc1       $f12, 0x4c($s1)
0010BBA4 3C044F00 lui        $a0, 0x4f00
0010BBA8 44846800 mtc1       $a0, $f13
0010BBAC 460D603C c.lt.s     $f12, $f13
0010BBB0 00000000 nop        
0010BBB4 45020005 bc1fl      0x10bbcc
0010BBB8 C62C004C lwc1       $f12, 0x4c($s1)
0010BBBC C62C004C lwc1       $f12, 0x4c($s1)
0010BBC0 4600630D trunc.w.s  $f12, $f12
0010BBC4 10000008 b          0x10bbe8
0010BBC8 44046000 mfc1       $a0, $f12
0010BBCC 3C044F00 lui        $a0, 0x4f00
0010BBD0 44846800 mtc1       $a0, $f13
0010BBD4 460D6301 sub.s      $f12, $f12, $f13
0010BBD8 3C048000 lui        $a0, 0x8000
0010BBDC 4600630D trunc.w.s  $f12, $f12
0010BBE0 44056000 mfc1       $a1, $f12
0010BBE4 00A42021 addu       $a0, $a1, $a0
0010BBE8 8E050068 lw         $a1, 0x68($s0)
0010BBEC 3C060100 lui        $a2, 0x100
0010BBF0 24C6FFFF addiu      $a2, $a2, -1
0010BBF4 00042600 sll        $a0, $a0, 0x18
0010BBF8 00A62824 and        $a1, $a1, $a2
0010BBFC 00852025 or         $a0, $a0, $a1
0010BC00 10000006 b          0x10bc1c
0010BC04 AE040068 sw         $a0, 0x68($s0)
0010BC08 02002025 move       $a0, $s0
0010BC0C 0C0192FF jal        0x64bfc
0010BC10 34050001 ori        $a1, $zero, 1
0010BC14 100000FE b          0x10c010
0010BC18 00000000 nop        
0010BC1C 92040045 lbu        $a0, 0x45($s0)
0010BC20 28840004 slti       $a0, $a0, 4
0010BC24 148000FA bnez       $a0, 0x10c010
0010BC28 00000000 nop        
0010BC2C AFA00164 sw         $zero, 0x164($sp)
0010BC30 44806000 mtc1       $zero, $f12
0010BC34 C60D0034 lwc1       $f13, 0x34($s0)
0010BC38 AFA00160 sw         $zero, 0x160($sp)
0010BC3C C60E0030 lwc1       $f14, 0x30($s0)
0010BC40 E7AC0168 swc1       $f12, 0x168($sp)
0010BC44 3C04002A lui        $a0, 0x2a
0010BC48 C48CD4F0 lwc1       $f12, -0x2b10($a0)
0010BC4C E7AE016C swc1       $f14, 0x16c($sp)
0010BC50 460C6B00 add.s      $f12, $f13, $f12
0010BC54 C60E0038 lwc1       $f14, 0x38($s0)
0010BC58 E7AD0170 swc1       $f13, 0x170($sp)
0010BC5C E7AE0174 swc1       $f14, 0x174($sp)
0010BC60 E7AC0170 swc1       $f12, 0x170($sp)
0010BC64 96240010 lhu        $a0, 0x10($s1)
0010BC68 27A50150 addiu      $a1, $sp, 0x150
0010BC6C 34840008 ori        $a0, $a0, 8
0010BC70 A6240010 sh         $a0, 0x10($s1)
0010BC74 3C040006 lui        $a0, 6
0010BC78 C7AC0170 lwc1       $f12, 0x170($sp)
0010BC7C 2484E2A8 addiu      $a0, $a0, -0x1d58
0010BC80 C48D000C lwc1       $f13, 0xc($a0)
0010BC84 27A40168 addiu      $a0, $sp, 0x168
0010BC88 460D6301 sub.s      $f12, $f12, $f13
0010BC8C 27A6016C addiu      $a2, $sp, 0x16c
0010BC90 34070828 ori        $a3, $zero, 0x828
0010BC94 0C0063F5 jal        0x18fd4
0010BC98 00004025 move       $t0, $zero
0010BC9C 96240010 lhu        $a0, 0x10($s1)
0010BCA0 2405FFF7 addiu      $a1, $zero, -9
0010BCA4 00852024 and        $a0, $a0, $a1
0010BCA8 A6240010 sh         $a0, 0x10($s1)
0010BCAC 8FA40164 lw         $a0, 0x164($sp)
0010BCB0 108000D7 beqz       $a0, 0x10c010
0010BCB4 00000000 nop        
0010BCB8 C7AC0168 lwc1       $f12, 0x168($sp)
0010BCBC 3C04002A lui        $a0, 0x2a
0010BCC0 C48DD4F0 lwc1       $f13, -0x2b10($a0)
0010BCC4 C60E0030 lwc1       $f14, 0x30($s0)
0010BCC8 460D6301 sub.s      $f12, $f12, $f13
0010BCCC C60F0034 lwc1       $f15, 0x34($s0)
0010BCD0 E7AE017C swc1       $f14, 0x17c($sp)
0010BCD4 C60E0038 lwc1       $f14, 0x38($s0)
0010BCD8 E7AF0180 swc1       $f15, 0x180($sp)
0010BCDC E7AC0168 swc1       $f12, 0x168($sp)
0010BCE0 E7AE0184 swc1       $f14, 0x184($sp)
0010BCE4 8E240050 lw         $a0, 0x50($s1)
0010BCE8 8E250088 lw         $a1, 0x88($s1)
0010BCEC 24840001 addiu      $a0, $a0, 1
0010BCF0 2CB20003 sltiu      $s2, $a1, 3
0010BCF4 AE240050 sw         $a0, 0x50($s1)
0010BCF8 3A520001 xori       $s2, $s2, 1
0010BCFC 3C05002A lui        $a1, 0x2a
0010BD00 00122080 sll        $a0, $s2, 2
0010BD04 24A5D4E0 addiu      $a1, $a1, -0x2b20
0010BD08 3C06002A lui        $a2, 0x2a
0010BD0C 00852821 addu       $a1, $a0, $a1
0010BD10 24C6D4E8 addiu      $a2, $a2, -0x2b18
0010BD14 C4B40000 lwc1       $f20, ($a1)
0010BD18 00862021 addu       $a0, $a0, $a2
0010BD1C C48C0000 lwc1       $f12, ($a0)
0010BD20 0C060057 jal        0x18015c
0010BD24 46146581 sub.s      $f22, $f12, $f20
0010BD28 44826800 mtc1       $v0, $f13
0010BD2C 3C043000 lui        $a0, 0x3000
0010BD30 46806B60 cvt.s.w    $f13, $f13
0010BD34 44847000 mtc1       $a0, $f14
0010BD38 C62F0084 lwc1       $f15, 0x84($s1)
0010BD3C 460E6B42 mul.s      $f13, $f13, $f14
0010BD40 3C0440C9 lui        $a0, 0x40c9
0010BD44 34840FDB ori        $a0, $a0, 0xfdb
0010BD48 46166B02 mul.s      $f12, $f13, $f22
0010BD4C 460CA300 add.s      $f12, $f20, $f12
0010BD50 44846800 mtc1       $a0, $f13
0010BD54 460C7B00 add.s      $f12, $f15, $f12
0010BD58 0C05E27A jal        0x1789e8
0010BD5C E62C0084 swc1       $f12, 0x84($s1)
0010BD60 46000306 mov.s      $f12, $f0
0010BD64 44806800 mtc1       $zero, $f13
0010BD68 460D603C c.lt.s     $f12, $f13
0010BD6C 00000000 nop        
0010BD70 45000004 bc1f       0x10bd84
0010BD74 3C0440C9 lui        $a0, 0x40c9
0010BD78 34840FDB ori        $a0, $a0, 0xfdb
0010BD7C 44846800 mtc1       $a0, $f13
0010BD80 460D6300 add.s      $f12, $f12, $f13
0010BD84 E62C0084 swc1       $f12, 0x84($s1)
0010BD88 0C062080 jal        0x188200
0010BD8C C6340080 lwc1       $f20, 0x80($s1)
0010BD90 3C05002A lui        $a1, 0x2a
0010BD94 00122080 sll        $a0, $s2, 2
0010BD98 24A5D4D8 addiu      $a1, $a1, -0x2b28
0010BD9C 00852021 addu       $a0, $a0, $a1
0010BDA0 C48C0000 lwc1       $f12, ($a0)
0010BDA4 C7AD0168 lwc1       $f13, 0x168($sp)
0010BDA8 460C0302 mul.s      $f12, $f0, $f12
0010BDAC 3C04002A lui        $a0, 0x2a
0010BDB0 C48ED4D0 lwc1       $f14, -0x2b30($a0)
0010BDB4 460CA300 add.s      $f12, $f20, $f12
0010BDB8 3C04002A lui        $a0, 0x2a
0010BDBC 460C6B01 sub.s      $f12, $f13, $f12
0010BDC0 E7AC0168 swc1       $f12, 0x168($sp)
0010BDC4 C62C0080 lwc1       $f12, 0x80($s1)
0010BDC8 460E6300 add.s      $f12, $f12, $f14
0010BDCC E62C0080 swc1       $f12, 0x80($s1)
0010BDD0 C48FD4CC lwc1       $f15, -0x2b34($a0)
0010BDD4 460F603E c.le.s     $f12, $f15
0010BDD8 00000000 nop        
0010BDDC 45010003 bc1t       0x10bdec
0010BDE0 3C04002A lui        $a0, 0x2a
0010BDE4 C48CD4CC lwc1       $f12, -0x2b34($a0)
0010BDE8 E62C0080 swc1       $f12, 0x80($s1)
0010BDEC 8E240050 lw         $a0, 0x50($s1)
0010BDF0 44846000 mtc1       $a0, $f12
0010BDF4 04810004 bgez       $a0, 0x10be08
0010BDF8 46806320 cvt.s.w    $f12, $f12
0010BDFC 3C044F80 lui        $a0, 0x4f80
0010BE00 44846800 mtc1       $a0, $f13
0010BE04 460D6300 add.s      $f12, $f12, $f13
0010BE08 3C04002A lui        $a0, 0x2a
0010BE0C C48DD4B8 lwc1       $f13, -0x2b48($a0)
0010BE10 C7AE0168 lwc1       $f14, 0x168($sp)
0010BE14 460C6B02 mul.s      $f12, $f13, $f12
0010BE18 460E603E c.le.s     $f12, $f14
0010BE1C 00000000 nop        
0010BE20 45010003 bc1t       0x10be30
0010BE24 E7AC0178 swc1       $f12, 0x178($sp)
0010BE28 10000002 b          0x10be34
0010BE2C 27A40168 addiu      $a0, $sp, 0x168
0010BE30 27A40178 addiu      $a0, $sp, 0x178
0010BE34 C4940000 lwc1       $f20, ($a0)
0010BE38 C60C0034 lwc1       $f12, 0x34($s0)
0010BE3C 46146301 sub.s      $f12, $f12, $f20
0010BE40 E60C0034 swc1       $f12, 0x34($s0)
0010BE44 8E240028 lw         $a0, 0x28($s1)
0010BE48 50800005 beql       $a0, $zero, 0x10be60
0010BE4C 92040044 lbu        $a0, 0x44($s0)
0010BE50 8E240028 lw         $a0, 0x28($s1)
0010BE54 0C056F69 jal        0x15bda4
0010BE58 26050030 addiu      $a1, $s0, 0x30
0010BE5C 92040044 lbu        $a0, 0x44($s0)
0010BE60 8E050040 lw         $a1, 0x40($s0)
0010BE64 8E060064 lw         $a2, 0x64($s0)
0010BE68 00043900 sll        $a3, $a0, 4
0010BE6C 00872021 addu       $a0, $a0, $a3
0010BE70 30C61420 andi       $a2, $a2, 0x1420
0010BE74 00044080 sll        $t0, $a0, 2
0010BE78 8CA50004 lw         $a1, 4($a1)
0010BE7C 34C40001 ori        $a0, $a2, 1
0010BE80 01073023 subu       $a2, $t0, $a3
0010BE84 00A62821 addu       $a1, $a1, $a2
0010BE88 24A6000C addiu      $a2, $a1, 0xc
0010BE8C 8CC60000 lw         $a2, ($a2)
0010BE90 54C00001 bnel       $a2, $zero, 0x10be98
0010BE94 34840080 ori        $a0, $a0, 0x80
0010BE98 24A6000C addiu      $a2, $a1, 0xc
0010BE9C 8CC60004 lw         $a2, 4($a2)
0010BEA0 54C00001 bnel       $a2, $zero, 0x10bea8
0010BEA4 34840100 ori        $a0, $a0, 0x100
0010BEA8 8CA50014 lw         $a1, 0x14($a1)
0010BEAC 54A00001 bnel       $a1, $zero, 0x10beb4
0010BEB0 34840200 ori        $a0, $a0, 0x200
0010BEB4 8E050040 lw         $a1, 0x40($s0)
0010BEB8 34060001 ori        $a2, $zero, 1
0010BEBC 90A5004B lbu        $a1, 0x4b($a1)
0010BEC0 50A60001 beql       $a1, $a2, 0x10bec8
0010BEC4 34840800 ori        $a0, $a0, 0x800
0010BEC8 8E050064 lw         $a1, 0x64($s0)
0010BECC 30A50008 andi       $a1, $a1, 8
0010BED0 54A00001 bnel       $a1, $zero, 0x10bed8
0010BED4 34840400 ori        $a0, $a0, 0x400
0010BED8 34900010 ori        $s0, $a0, 0x10
0010BEDC 8E260014 lw         $a2, 0x14($s1)
0010BEE0 27A401B8 addiu      $a0, $sp, 0x1b8
0010BEE4 0C019E1E jal        0x67878
0010BEE8 27A501C4 addiu      $a1, $sp, 0x1c4
0010BEEC 5040002F beql       $v0, $zero, 0x10bfac
0010BEF0 8E240018 lw         $a0, 0x18($s1)
0010BEF4 C7AC01C4 lwc1       $f12, 0x1c4($sp)
0010BEF8 C7AD01B8 lwc1       $f13, 0x1b8($sp)
0010BEFC C7AE01CC lwc1       $f14, 0x1cc($sp)
0010BF00 460D6341 sub.s      $f13, $f12, $f13
0010BF04 3C054100 lui        $a1, 0x4100
0010BF08 44857800 mtc1       $a1, $f15
0010BF0C 34040000 ori        $a0, $zero, 0
0010BF10 C7AC01C0 lwc1       $f12, 0x1c0($sp)
0010BF14 460F683E c.le.s     $f13, $f15
0010BF18 00000000 nop        
0010BF1C 45000007 bc1f       0x10bf3c
0010BF20 460C7301 sub.s      $f12, $f14, $f12
0010BF24 3C054100 lui        $a1, 0x4100
0010BF28 44856800 mtc1       $a1, $f13
0010BF2C 460D603E c.le.s     $f12, $f13
0010BF30 00000000 nop        
0010BF34 45030003 bc1tl      0x10bf44
0010BF38 8E250018 lw         $a1, 0x18($s1)
0010BF3C 34040001 ori        $a0, $zero, 1
0010BF40 8E250018 lw         $a1, 0x18($s1)
0010BF44 10A0000A beqz       $a1, 0x10bf70
0010BF48 00042900 sll        $a1, $a0, 4
0010BF4C 8E250004 lw         $a1, 4($s1)
0010BF50 8E260018 lw         $a2, 0x18($s1)
0010BF54 10A00004 beqz       $a1, 0x10bf68
0010BF58 ACC50000 sw         $a1, ($a2)
0010BF5C 8E250018 lw         $a1, 0x18($s1)
0010BF60 8E260004 lw         $a2, 4($s1)
0010BF64 ACC50014 sw         $a1, 0x14($a2)
0010BF68 AE200018 sw         $zero, 0x18($s1)
0010BF6C 00042900 sll        $a1, $a0, 4
0010BF70 00A43023 subu       $a2, $a1, $a0
0010BF74 A2240013 sb         $a0, 0x13($s1)
0010BF78 000620C0 sll        $a0, $a2, 3
0010BF7C 00852023 subu       $a0, $a0, $a1
0010BF80 3C050006 lui        $a1, 6
0010BF84 24A5E2A8 addiu      $a1, $a1, -0x1d58
0010BF88 00852021 addu       $a0, $a0, $a1
0010BF8C 26250004 addiu      $a1, $s1, 4
0010BF90 27A601B8 addiu      $a2, $sp, 0x1b8
0010BF94 27A701C4 addiu      $a3, $sp, 0x1c4
0010BF98 0C020EB5 jal        0x83ad4
0010BF9C 02004025 move       $t0, $s0
0010BFA0 1000000D b          0x10bfd8
0010BFA4 C7AC0168 lwc1       $f12, 0x168($sp)
0010BFA8 8E240018 lw         $a0, 0x18($s1)
0010BFAC 5080000A beql       $a0, $zero, 0x10bfd8
0010BFB0 C7AC0168 lwc1       $f12, 0x168($sp)
0010BFB4 8E240004 lw         $a0, 4($s1)
0010BFB8 8E250018 lw         $a1, 0x18($s1)
0010BFBC 10800004 beqz       $a0, 0x10bfd0
0010BFC0 ACA40000 sw         $a0, ($a1)
0010BFC4 8E240018 lw         $a0, 0x18($s1)
0010BFC8 8E250004 lw         $a1, 4($s1)
0010BFCC ACA40014 sw         $a0, 0x14($a1)
0010BFD0 AE200018 sw         $zero, 0x18($s1)
0010BFD4 C7AC0168 lwc1       $f12, 0x168($sp)
0010BFD8 3C053727 lui        $a1, 0x3727
0010BFDC 460CA301 sub.s      $f12, $f20, $f12
0010BFE0 34A5C5AC ori        $a1, $a1, 0xc5ac
0010BFE4 44856800 mtc1       $a1, $f13
0010BFE8 34040000 ori        $a0, $zero, 0
0010BFEC 46006305 abs.s      $f12, $f12
0010BFF0 460D603E c.le.s     $f12, $f13
0010BFF4 00000000 nop        
0010BFF8 45030001 bc1tl      0x10c000
0010BFFC 34040001 ori        $a0, $zero, 1
0010C000 308400FF andi       $a0, $a0, 0xff
0010C004 10800002 beqz       $a0, 0x10c010
0010C008 00000000 nop        
0010C00C AE200050 sw         $zero, 0x50($s1)
0010C010 C7B401D0 lwc1       $f20, 0x1d0($sp)
0010C014 C7B601D4 lwc1       $f22, 0x1d4($sp)
0010C018 C7B801D8 lwc1       $f24, 0x1d8($sp)
0010C01C C7BA01DC lwc1       $f26, 0x1dc($sp)
0010C020 8FB001E0 lw         $s0, 0x1e0($sp)
0010C024 8FB101E4 lw         $s1, 0x1e4($sp)
0010C028 8FB201E8 lw         $s2, 0x1e8($sp)
0010C02C 8FBF01EC lw         $ra, 0x1ec($sp)
0010C030 03E00008 jr         $ra
0010C034 27BD01F0 addiu      $sp, $sp, 0x1f0

CALLBACK 0x0010A354 end 0x0010A4DC ordinal 3

0010A354 27BDFFD0 addiu      $sp, $sp, -0x30
0010A358 AFB00010 sw         $s0, 0x10($sp)
0010A35C AFB10014 sw         $s1, 0x14($sp)
0010A360 8C900058 lw         $s0, 0x58($a0)
0010A364 00808825 move       $s1, $a0
0010A368 AFB20018 sw         $s2, 0x18($sp)
0010A36C AFB3001C sw         $s3, 0x1c($sp)
0010A370 AFB40020 sw         $s4, 0x20($sp)
0010A374 AFBF0024 sw         $ra, 0x24($sp)
0010A378 1120004F beqz       $t1, 0x10a4b8
0010A37C 01202025 move       $a0, $t1
0010A380 8C850040 lw         $a1, 0x40($a0)
0010A384 3C069708 lui        $a2, 0x9708
0010A388 8CA50030 lw         $a1, 0x30($a1)
0010A38C 24C6D8E6 addiu      $a2, $a2, -0x271a
0010A390 14A60049 bne        $a1, $a2, 0x10a4b8
0010A394 00000000 nop        
0010A398 8C850058 lw         $a1, 0x58($a0)
0010A39C 8E060000 lw         $a2, ($s0)
0010A3A0 8CA50000 lw         $a1, ($a1)
0010A3A4 8CC600F4 lw         $a2, 0xf4($a2)
0010A3A8 8CA500F4 lw         $a1, 0xf4($a1)
0010A3AC 14A60042 bne        $a1, $a2, 0x10a4b8
0010A3B0 00000000 nop        
0010A3B4 92250045 lbu        $a1, 0x45($s1)
0010A3B8 34060005 ori        $a2, $zero, 5
0010A3BC 14A6003E bne        $a1, $a2, 0x10a4b8
0010A3C0 00000000 nop        
0010A3C4 8E050018 lw         $a1, 0x18($s0)
0010A3C8 10A00008 beqz       $a1, 0x10a3ec
0010A3CC 00000000 nop        
0010A3D0 8E060004 lw         $a2, 4($s0)
0010A3D4 10C00004 beqz       $a2, 0x10a3e8
0010A3D8 ACA60000 sw         $a2, ($a1)
0010A3DC 8E050018 lw         $a1, 0x18($s0)
0010A3E0 8E060004 lw         $a2, 4($s0)
0010A3E4 ACC50014 sw         $a1, 0x14($a2)
0010A3E8 AE000018 sw         $zero, 0x18($s0)
0010A3EC 8C840058 lw         $a0, 0x58($a0)
0010A3F0 0C00A99C jal        0x2a670
0010A3F4 8C840000 lw         $a0, ($a0)
0010A3F8 C44C0020 lwc1       $f12, 0x20($v0)
0010A3FC 3C04002A lui        $a0, 0x2a
0010A400 C48DD4F8 lwc1       $f13, -0x2b08($a0)
0010A404 460C6B02 mul.s      $f12, $f13, $f12
0010A408 34050001 ori        $a1, $zero, 1
0010A40C 44807800 mtc1       $zero, $f15
0010A410 E60C003C swc1       $f12, 0x3c($s0)
0010A414 C44C0024 lwc1       $f12, 0x24($v0)
0010A418 C48ED4F8 lwc1       $f14, -0x2b08($a0)
0010A41C 460C7302 mul.s      $f12, $f14, $f12
0010A420 E60C0040 swc1       $f12, 0x40($s0)
0010A424 C44C0028 lwc1       $f12, 0x28($v0)
0010A428 C48DD4F8 lwc1       $f13, -0x2b08($a0)
0010A42C 460C6B02 mul.s      $f12, $f13, $f12
0010A430 E60C0044 swc1       $f12, 0x44($s0)
0010A434 A2250045 sb         $a1, 0x45($s1)
0010A438 E60F0080 swc1       $f15, 0x80($s0)
0010A43C 9204008D lbu        $a0, 0x8d($s0)
0010A440 1080001D beqz       $a0, 0x10a4b8
0010A444 00000000 nop        
0010A448 3C12002A lui        $s2, 0x2a
0010A44C 2652D480 addiu      $s2, $s2, -0x2b80
0010A450 8E44002C lw         $a0, 0x2c($s2)
0010A454 34110000 ori        $s1, $zero, 0
0010A458 0224202B sltu       $a0, $s1, $a0
0010A45C 10800015 beqz       $a0, 0x10a4b4
0010A460 02009825 move       $s3, $s0
0010A464 3C140028 lui        $s4, 0x28
0010A468 8E64005C lw         $a0, 0x5c($s3)
0010A46C 1080000C beqz       $a0, 0x10a4a0
0010A470 00000000 nop        
0010A474 00802825 move       $a1, $a0
0010A478 10A00008 beqz       $a1, 0x10a49c
0010A47C 00000000 nop        
0010A480 8E8627F8 lw         $a2, 0x27f8($s4)
0010A484 14860003 bne        $a0, $a2, 0x10a494
0010A488 00000000 nop        
0010A48C 10000003 b          0x10a49c
0010A490 AE8027F8 sw         $zero, 0x27f8($s4)
0010A494 0C02172B jal        0x85cac
0010A498 00A02025 move       $a0, $a1
0010A49C AE60005C sw         $zero, 0x5c($s3)
0010A4A0 8E44002C lw         $a0, 0x2c($s2)
0010A4A4 26310001 addiu      $s1, $s1, 1
0010A4A8 0224202B sltu       $a0, $s1, $a0
0010A4AC 1480FFEE bnez       $a0, 0x10a468
0010A4B0 26730004 addiu      $s3, $s3, 4
0010A4B4 A200008D sb         $zero, 0x8d($s0)
0010A4B8 00001025 move       $v0, $zero
0010A4BC 8FB00010 lw         $s0, 0x10($sp)
0010A4C0 8FB10014 lw         $s1, 0x14($sp)
0010A4C4 8FB20018 lw         $s2, 0x18($sp)
0010A4C8 8FB3001C lw         $s3, 0x1c($sp)
0010A4CC 8FB40020 lw         $s4, 0x20($sp)
0010A4D0 8FBF0024 lw         $ra, 0x24($sp)
0010A4D4 03E00008 jr         $ra
0010A4D8 27BD0030 addiu      $sp, $sp, 0x30