
CALLBACK 0x0013A5F4 end 0x0013A6AC ordinal 0

0013A5F4 27BDFFD0 addiu      $sp, $sp, -0x30
0013A5F8 AFB00020 sw         $s0, 0x20($sp)
0013A5FC 00808025 move       $s0, $a0
0013A600 AFB10024 sw         $s1, 0x24($sp)
0013A604 8E110058 lw         $s1, 0x58($s0)
0013A608 00002825 move       $a1, $zero
0013A60C 02202025 move       $a0, $s1
0013A610 AFB20028 sw         $s2, 0x28($sp)
0013A614 AFBF002C sw         $ra, 0x2c($sp)
0013A618 0C0600AC jal        0x1802b0
0013A61C 3406004C ori        $a2, $zero, 0x4c
0013A620 3C120028 lui        $s2, 0x28
0013A624 8E45F8D8 lw         $a1, -0x728($s2)
0013A628 8CA600F0 lw         $a2, 0xf0($a1)
0013A62C 26040074 addiu      $a0, $s0, 0x74
0013A630 34050004 ori        $a1, $zero, 4
0013A634 0C006F54 jal        0x1bd50
0013A638 2407FFFF addiu      $a3, $zero, -1
0013A63C 3C080028 lui        $t0, 0x28
0013A640 26240020 addiu      $a0, $s1, 0x20
0013A644 34100001 ori        $s0, $zero, 1
0013A648 34050001 ori        $a1, $zero, 1
0013A64C 34060044 ori        $a2, $zero, 0x44
0013A650 34070045 ori        $a3, $zero, 0x45
0013A654 0C01859E jal        0x61678
0013A658 25082090 addiu      $t0, $t0, 0x2090
0013A65C 8E44F8D8 lw         $a0, -0x728($s2)
0013A660 3C05002A lui        $a1, 0x2a
0013A664 C4AC20D8 lwc1       $f12, 0x20d8($a1)
0013A668 3C05002A lui        $a1, 0x2a
0013A66C C4AD20DC lwc1       $f13, 0x20dc($a1)
0013A670 3C05002A lui        $a1, 0x2a
0013A674 3C084120 lui        $t0, 0x4120
0013A678 3C06002A lui        $a2, 0x2a
0013A67C 44887000 mtc1       $t0, $f14
0013A680 00003825 move       $a3, $zero
0013A684 24A520CC addiu      $a1, $a1, 0x20cc
0013A688 0C01569F jal        0x55a7c
0013A68C 24C620E0 addiu      $a2, $a2, 0x20e0
0013A690 02001025 move       $v0, $s0
0013A694 8FB00020 lw         $s0, 0x20($sp)
0013A698 8FB10024 lw         $s1, 0x24($sp)
0013A69C 8FB20028 lw         $s2, 0x28($sp)
0013A6A0 8FBF002C lw         $ra, 0x2c($sp)
0013A6A4 03E00008 jr         $ra
0013A6A8 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x0013A6AC end 0x0013A6D8 ordinal 1

0013A6AC 27BDFFE0 addiu      $sp, $sp, -0x20
0013A6B0 8C840058 lw         $a0, 0x58($a0)
0013A6B4 8C840000 lw         $a0, ($a0)
0013A6B8 AFBF0010 sw         $ra, 0x10($sp)
0013A6BC 10800003 beqz       $a0, 0x13a6cc
0013A6C0 00000000 nop        
0013A6C4 0C00A7B3 jal        0x29ecc
0013A6C8 34050001 ori        $a1, $zero, 1
0013A6CC 8FBF0010 lw         $ra, 0x10($sp)
0013A6D0 03E00008 jr         $ra
0013A6D4 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0013A7AC end 0x0013ABC8 ordinal 2

0013A7AC 27BDFF90 addiu      $sp, $sp, -0x70
0013A7B0 AFB1004C sw         $s1, 0x4c($sp)
0013A7B4 8C910058 lw         $s1, 0x58($a0)
0013A7B8 AFB00048 sw         $s0, 0x48($sp)
0013A7BC 8E25001C lw         $a1, 0x1c($s1)
0013A7C0 00808025 move       $s0, $a0
0013A7C4 E7B40040 swc1       $f20, 0x40($sp)
0013A7C8 E7B60044 swc1       $f22, 0x44($sp)
0013A7CC AFB20050 sw         $s2, 0x50($sp)
0013A7D0 AFB30054 sw         $s3, 0x54($sp)
0013A7D4 AFB40058 sw         $s4, 0x58($sp)
0013A7D8 AFB5005C sw         $s5, 0x5c($sp)
0013A7DC AFB60060 sw         $s6, 0x60($sp)
0013A7E0 AFBF0064 sw         $ra, 0x64($sp)
0013A7E4 14A00006 bnez       $a1, 0x13a800
0013A7E8 8E320000 lw         $s2, ($s1)
0013A7EC 02002025 move       $a0, $s0
0013A7F0 0C04E9B6 jal        0x13a6d8
0013A7F4 02402825 move       $a1, $s2
0013A7F8 10400015 beqz       $v0, 0x13a850
0013A7FC AE22001C sw         $v0, 0x1c($s1)
0013A800 8E4500F0 lw         $a1, 0xf0($s2)
0013A804 0C007541 jal        0x1d504
0013A808 3404000E ori        $a0, $zero, 0xe
0013A80C 00409825 move       $s3, $v0
0013A810 0C00A9CA jal        0x2a728
0013A814 27A40020 addiu      $a0, $sp, 0x20
0013A818 3C040006 lui        $a0, 6
0013A81C 2484A8B8 addiu      $a0, $a0, -0x5748
0013A820 8C940594 lw         $s4, 0x594($a0)
0013A824 02402025 move       $a0, $s2
0013A828 0C00A7B3 jal        0x29ecc
0013A82C 00002825 move       $a1, $zero
0013A830 C62C000C lwc1       $f12, 0xc($s1)
0013A834 4480A000 mtc1       $zero, $f20
0013A838 46146032 c.eq.s     $f12, $f20
0013A83C 00000000 nop        
0013A840 45000005 bc1f       0x13a858
0013A844 00000000 nop        
0013A848 10000077 b          0x13aa28
0013A84C 00000000 nop        
0013A850 100000C3 b          0x13ab60
0013A854 00000000 nop        
0013A858 0C00A907 jal        0x2a41c
0013A85C 00000000 nop        
0013A860 C62C000C lwc1       $f12, 0xc($s1)
0013A864 3C04BF80 lui        $a0, 0xbf80
0013A868 44846800 mtc1       $a0, $f13
0013A86C 460D6300 add.s      $f12, $f12, $f13
0013A870 00402025 move       $a0, $v0
0013A874 4614603E c.le.s     $f12, $f20
0013A878 00000000 nop        
0013A87C 45010010 bc1t       0x13a8c0
0013A880 E62C000C swc1       $f12, 0xc($s1)
0013A884 8FA50020 lw         $a1, 0x20($sp)
0013A888 30A50020 andi       $a1, $a1, 0x20
0013A88C 10A00066 beqz       $a1, 0x13aa28
0013A890 3405001E ori        $a1, $zero, 0x1e
0013A894 10850064 beq        $a0, $a1, 0x13aa28
0013A898 3C04002A lui        $a0, 0x2a
0013A89C C48C2038 lwc1       $f12, 0x2038($a0)
0013A8A0 3C04002A lui        $a0, 0x2a
0013A8A4 C48D203C lwc1       $f13, 0x203c($a0)
0013A8A8 C62E000C lwc1       $f14, 0xc($s1)
0013A8AC 460D6301 sub.s      $f12, $f12, $f13
0013A8B0 460C703E c.le.s     $f14, $f12
0013A8B4 00000000 nop        
0013A8B8 4500005B bc1f       0x13aa28
0013A8BC 00000000 nop        
0013A8C0 27B50028 addiu      $s5, $sp, 0x28
0013A8C4 3C06002A lui        $a2, 0x2a
0013A8C8 E634000C swc1       $f20, 0xc($s1)
0013A8CC 02A02025 move       $a0, $s5
0013A8D0 02002825 move       $a1, $s0
0013A8D4 0C03AEA4 jal        0xeba90
0013A8D8 24C62020 addiu      $a2, $a2, 0x2020
0013A8DC C62C0010 lwc1       $f12, 0x10($s1)
0013A8E0 C7AD0028 lwc1       $f13, 0x28($sp)
0013A8E4 C7AE002C lwc1       $f14, 0x2c($sp)
0013A8E8 460D6581 sub.s      $f22, $f12, $f13
0013A8EC C7AF0030 lwc1       $f15, 0x30($sp)
0013A8F0 E7B60034 swc1       $f22, 0x34($sp)
0013A8F4 C6300014 lwc1       $f16, 0x14($s1)
0013A8F8 460E8301 sub.s      $f12, $f16, $f14
0013A8FC E7AC0038 swc1       $f12, 0x38($sp)
0013A900 C6310018 lwc1       $f17, 0x18($s1)
0013A904 460F8B41 sub.s      $f13, $f17, $f15
0013A908 E7AD003C swc1       $f13, 0x3c($sp)
0013A90C C6920010 lwc1       $f18, 0x10($s4)
0013A910 C6930014 lwc1       $f19, 0x14($s4)
0013A914 4612B402 mul.s      $f16, $f22, $f18
0013A918 C68E0018 lwc1       $f14, 0x18($s4)
0013A91C 461364C2 mul.s      $f19, $f12, $f19
0013A920 460E6B82 mul.s      $f14, $f13, $f14
0013A924 461383C0 add.s      $f15, $f16, $f19
0013A928 460E7B80 add.s      $f14, $f15, $f14
0013A92C 46007447 neg.s      $f17, $f14
0013A930 46119482 mul.s      $f18, $f18, $f17
0013A934 4612B580 add.s      $f22, $f22, $f18
0013A938 E7B60034 swc1       $f22, 0x34($sp)
0013A93C C6800014 lwc1       $f0, 0x14($s4)
0013A940 46110402 mul.s      $f16, $f0, $f17
0013A944 4616B4C2 mul.s      $f19, $f22, $f22
0013A948 46106300 add.s      $f12, $f12, $f16
0013A94C 3C043480 lui        $a0, 0x3480
0013A950 3C05002A lui        $a1, 0x2a
0013A954 E7AC0038 swc1       $f12, 0x38($sp)
0013A958 460C6482 mul.s      $f18, $f12, $f12
0013A95C C68F0018 lwc1       $f15, 0x18($s4)
0013A960 46117BC2 mul.s      $f15, $f15, $f17
0013A964 46129C80 add.s      $f18, $f19, $f18
0013A968 27B60034 addiu      $s6, $sp, 0x34
0013A96C 44848000 mtc1       $a0, $f16
0013A970 460F6B40 add.s      $f13, $f13, $f15
0013A974 24A42044 addiu      $a0, $a1, 0x2044
0013A978 460D6BC2 mul.s      $f15, $f13, $f13
0013A97C 460F93C0 add.s      $f15, $f18, $f15
0013A980 4610783C c.lt.s     $f15, $f16
0013A984 00000000 nop        
0013A988 45000003 bc1f       0x13a998
0013A98C E7AD003C swc1       $f13, 0x3c($sp)
0013A990 1000000C b          0x13a9c4
0013A994 4600A586 mov.s      $f22, $f20
0013A998 3C053F80 lui        $a1, 0x3f80
0013A99C 46007BC4 sqrt.s     $f15, $f15
0013A9A0 44858000 mtc1       $a1, $f16
0013A9A4 460F8403 div.s      $f16, $f16, $f15
0013A9A8 4610B442 mul.s      $f17, $f22, $f16
0013A9AC 46106302 mul.s      $f12, $f12, $f16
0013A9B0 46106B42 mul.s      $f13, $f13, $f16
0013A9B4 E7B10034 swc1       $f17, 0x34($sp)
0013A9B8 46007D86 mov.s      $f22, $f15
0013A9BC E7AC0038 swc1       $f12, 0x38($sp)
0013A9C0 E7AD003C swc1       $f13, 0x3c($sp)
0013A9C4 4614703C c.lt.s     $f14, $f20
0013A9C8 00000000 nop        
0013A9CC 45010009 bc1t       0x13a9f4
0013A9D0 00000000 nop        
0013A9D4 8E25001C lw         $a1, 0x1c($s1)
0013A9D8 C48C0014 lwc1       $f12, 0x14($a0)
0013A9DC 02802025 move       $a0, $s4
0013A9E0 02A03025 move       $a2, $s5
0013A9E4 0C04E7F7 jal        0x139fdc
0013A9E8 02C03825 move       $a3, $s6
0013A9EC 1000000E b          0x13aa28
0013A9F0 00000000 nop        
0013A9F4 3C05C080 lui        $a1, 0xc080
0013A9F8 44856000 mtc1       $a1, $f12
0013A9FC C48D0010 lwc1       $f13, 0x10($a0)
0013AA00 460C7302 mul.s      $f12, $f14, $f12
0013AA04 460D6303 div.s      $f12, $f12, $f13
0013AA08 0C05E2E0 jal        0x178b80
0013AA0C 00000000 nop        
0013AA10 8E25001C lw         $a1, 0x1c($s1)
0013AA14 02802025 move       $a0, $s4
0013AA18 02A03025 move       $a2, $s5
0013AA1C 4600B303 div.s      $f12, $f22, $f0
0013AA20 0C04E7F7 jal        0x139fdc
0013AA24 02C03825 move       $a3, $s6
0013AA28 C62C0008 lwc1       $f12, 8($s1)
0013AA2C 46146032 c.eq.s     $f12, $f20
0013AA30 00000000 nop        
0013AA34 45010009 bc1t       0x13aa5c
0013AA38 00000000 nop        
0013AA3C 3C04BF80 lui        $a0, 0xbf80
0013AA40 44846800 mtc1       $a0, $f13
0013AA44 460D6300 add.s      $f12, $f12, $f13
0013AA48 4614603C c.lt.s     $f12, $f20
0013AA4C 00000000 nop        
0013AA50 45000002 bc1f       0x13aa5c
0013AA54 E62C0008 swc1       $f12, 8($s1)
0013AA58 E6340008 swc1       $f20, 8($s1)
0013AA5C 8E240004 lw         $a0, 4($s1)
0013AA60 34050004 ori        $a1, $zero, 4
0013AA64 14850007 bne        $a0, $a1, 0x13aa84
0013AA68 00000000 nop        
0013AA6C 02002025 move       $a0, $s0
0013AA70 0C019491 jal        0x65244
0013AA74 00002825 move       $a1, $zero
0013AA78 10400002 beqz       $v0, 0x13aa84
0013AA7C 00000000 nop        
0013AA80 A2000045 sb         $zero, 0x45($s0)
0013AA84 C62C0008 lwc1       $f12, 8($s1)
0013AA88 46146032 c.eq.s     $f12, $f20
0013AA8C 00000000 nop        
0013AA90 45000033 bc1f       0x13ab60
0013AA94 00000000 nop        
0013AA98 0C0070C3 jal        0x1c30c
0013AA9C 02402025 move       $a0, $s2
0013AAA0 1040002F beqz       $v0, 0x13ab60
0013AAA4 00000000 nop        
0013AAA8 8FA40020 lw         $a0, 0x20($sp)
0013AAAC 30840020 andi       $a0, $a0, 0x20
0013AAB0 1080002B beqz       $a0, 0x13ab60
0013AAB4 00000000 nop        
0013AAB8 0C00A99C jal        0x2a670
0013AABC 8E240000 lw         $a0, ($s1)
0013AAC0 02402025 move       $a0, $s2
0013AAC4 0C0155F5 jal        0x557d4
0013AAC8 00409025 move       $s2, $v0
0013AACC 3C09002A lui        $t1, 0x2a
0013AAD0 26270010 addiu      $a3, $s1, 0x10
0013AAD4 26280020 addiu      $t0, $s1, 0x20
0013AAD8 02002025 move       $a0, $s0
0013AADC 02402825 move       $a1, $s2
0013AAE0 00403025 move       $a2, $v0
0013AAE4 00005025 move       $t2, $zero
0013AAE8 00005825 move       $t3, $zero
0013AAEC 0C015AE8 jal        0x56ba0
0013AAF0 25292044 addiu      $t1, $t1, 0x2044
0013AAF4 A2220049 sb         $v0, 0x49($s1)
0013AAF8 92240049 lbu        $a0, 0x49($s1)
0013AAFC 10800018 beqz       $a0, 0x13ab60
0013AB00 00000000 nop        
0013AB04 92040045 lbu        $a0, 0x45($s0)
0013AB08 10800003 beqz       $a0, 0x13ab18
0013AB0C 34050005 ori        $a1, $zero, 5
0013AB10 14850013 bne        $a0, $a1, 0x13ab60
0013AB14 00000000 nop        
0013AB18 0C01BA8D jal        0x6ea34
0013AB1C 34040002 ori        $a0, $zero, 2
0013AB20 8C440004 lw         $a0, 4($v0)
0013AB24 30842000 andi       $a0, $a0, 0x2000
0013AB28 1080000D beqz       $a0, 0x13ab60
0013AB2C 00000000 nop        
0013AB30 8E640040 lw         $a0, 0x40($s3)
0013AB34 3C05002A lui        $a1, 0x2a
0013AB38 2484FFFF addiu      $a0, $a0, -1
0013AB3C AE640040 sw         $a0, 0x40($s3)
0013AB40 C4AC2040 lwc1       $f12, 0x2040($a1)
0013AB44 3C04002A lui        $a0, 0x2a
0013AB48 E62C0008 swc1       $f12, 8($s1)
0013AB4C C48C2038 lwc1       $f12, 0x2038($a0)
0013AB50 34040005 ori        $a0, $zero, 5
0013AB54 E62C000C swc1       $f12, 0xc($s1)
0013AB58 A2040045 sb         $a0, 0x45($s0)
0013AB5C A2200049 sb         $zero, 0x49($s1)
0013AB60 C7B40040 lwc1       $f20, 0x40($sp)
0013AB64 C7B60044 lwc1       $f22, 0x44($sp)
0013AB68 8FB00048 lw         $s0, 0x48($sp)
0013AB6C 8FB1004C lw         $s1, 0x4c($sp)
0013AB70 8FB20050 lw         $s2, 0x50($sp)
0013AB74 8FB30054 lw         $s3, 0x54($sp)
0013AB78 8FB40058 lw         $s4, 0x58($sp)
0013AB7C 8FB5005C lw         $s5, 0x5c($sp)
0013AB80 8FB60060 lw         $s6, 0x60($sp)
0013AB84 8FBF0064 lw         $ra, 0x64($sp)
0013AB88 03E00008 jr         $ra
0013AB8C 27BD0070 addiu      $sp, $sp, 0x70
0013AB90 3C04002A lui        $a0, 0x2a
0013AB94 2485202C addiu      $a1, $a0, 0x202c
0013AB98 8C84202C lw         $a0, 0x202c($a0)
0013AB9C 8CA60004 lw         $a2, 4($a1)
0013ABA0 8CA50008 lw         $a1, 8($a1)
0013ABA4 3C07002A lui        $a3, 0x2a
0013ABA8 24E82044 addiu      $t0, $a3, 0x2044
0013ABAC ACE42044 sw         $a0, 0x2044($a3)
0013ABB0 3C04002A lui        $a0, 0x2a
0013ABB4 AD060004 sw         $a2, 4($t0)
0013ABB8 C48C1FB8 lwc1       $f12, 0x1fb8($a0)
0013ABBC AD050008 sw         $a1, 8($t0)
0013ABC0 03E00008 jr         $ra
0013ABC4 E50C0010 swc1       $f12, 0x10($t0)