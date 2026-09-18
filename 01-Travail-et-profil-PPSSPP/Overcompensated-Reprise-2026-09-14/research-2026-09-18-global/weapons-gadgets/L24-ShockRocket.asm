
CALLBACK 0x0014E304 end 0x0014E3F0 ordinal 0

0014E304 27BDFFC0 addiu      $sp, $sp, -0x40
0014E308 AFB00020 sw         $s0, 0x20($sp)
0014E30C 00808025 move       $s0, $a0
0014E310 AFB10024 sw         $s1, 0x24($sp)
0014E314 AFB20028 sw         $s2, 0x28($sp)
0014E318 AFB3002C sw         $s3, 0x2c($sp)
0014E31C AFB40030 sw         $s4, 0x30($sp)
0014E320 AFBF0034 sw         $ra, 0x34($sp)
0014E324 8E140058 lw         $s4, 0x58($s0)
0014E328 3C110028 lui        $s1, 0x28
0014E32C AE800000 sw         $zero, ($s4)
0014E330 34130000 ori        $s3, $zero, 0
0014E334 26312090 addiu      $s1, $s1, 0x2090
0014E338 26920020 addiu      $s2, $s4, 0x20
0014E33C 02402025 move       $a0, $s2
0014E340 00002825 move       $a1, $zero
0014E344 34060044 ori        $a2, $zero, 0x44
0014E348 34070045 ori        $a3, $zero, 0x45
0014E34C 0C01859E jal        0x61678
0014E350 02204025 move       $t0, $s1
0014E354 26730001 addiu      $s3, $s3, 1
0014E358 2E640004 sltiu      $a0, $s3, 4
0014E35C 1480FFF7 bnez       $a0, 0x14e33c
0014E360 26520028 addiu      $s2, $s2, 0x28
0014E364 44806000 mtc1       $zero, $f12
0014E368 AE80001C sw         $zero, 0x1c($s4)
0014E36C E68C0010 swc1       $f12, 0x10($s4)
0014E370 A28000C0 sb         $zero, 0xc0($s4)
0014E374 AE800014 sw         $zero, 0x14($s4)
0014E378 E68C0018 swc1       $f12, 0x18($s4)
0014E37C 3C110028 lui        $s1, 0x28
0014E380 8E24F8D8 lw         $a0, -0x728($s1)
0014E384 3C05002A lui        $a1, 0x2a
0014E388 C4AC38E4 lwc1       $f12, 0x38e4($a1)
0014E38C 3C05002A lui        $a1, 0x2a
0014E390 C4AD38E8 lwc1       $f13, 0x38e8($a1)
0014E394 3C05002A lui        $a1, 0x2a
0014E398 C4AE38EC lwc1       $f14, 0x38ec($a1)
0014E39C 3C05002A lui        $a1, 0x2a
0014E3A0 3C06002A lui        $a2, 0x2a
0014E3A4 34070001 ori        $a3, $zero, 1
0014E3A8 24A538D8 addiu      $a1, $a1, 0x38d8
0014E3AC 0C01569F jal        0x55a7c
0014E3B0 24C63864 addiu      $a2, $a2, 0x3864
0014E3B4 8E25F8D8 lw         $a1, -0x728($s1)
0014E3B8 26040074 addiu      $a0, $s0, 0x74
0014E3BC 8CA600F0 lw         $a2, 0xf0($a1)
0014E3C0 34050008 ori        $a1, $zero, 8
0014E3C4 0C006F54 jal        0x1bd50
0014E3C8 2407FFFF addiu      $a3, $zero, -1
0014E3CC 34020001 ori        $v0, $zero, 1
0014E3D0 8FB00020 lw         $s0, 0x20($sp)
0014E3D4 8FB10024 lw         $s1, 0x24($sp)
0014E3D8 8FB20028 lw         $s2, 0x28($sp)
0014E3DC 8FB3002C lw         $s3, 0x2c($sp)
0014E3E0 8FB40030 lw         $s4, 0x30($sp)
0014E3E4 8FBF0034 lw         $ra, 0x34($sp)
0014E3E8 03E00008 jr         $ra
0014E3EC 27BD0040 addiu      $sp, $sp, 0x40

CALLBACK 0x0014E3F0 end 0x0014E3F8 ordinal 1

0014E3F0 03E00008 jr         $ra
0014E3F4 00000000 nop        

CALLBACK 0x0014E6DC end 0x0014EF10 ordinal 2

0014E6DC 27BDFEF0 addiu      $sp, $sp, -0x110
0014E6E0 AFB100E4 sw         $s1, 0xe4($sp)
0014E6E4 00808825 move       $s1, $a0
0014E6E8 3C040028 lui        $a0, 0x28
0014E6EC 8C84F8D8 lw         $a0, -0x728($a0)
0014E6F0 3C05002A lui        $a1, 0x2a
0014E6F4 C4AC38E4 lwc1       $f12, 0x38e4($a1)
0014E6F8 3C05002A lui        $a1, 0x2a
0014E6FC C4AD38E8 lwc1       $f13, 0x38e8($a1)
0014E700 AFB000E0 sw         $s0, 0xe0($sp)
0014E704 3C05002A lui        $a1, 0x2a
0014E708 3C10002A lui        $s0, 0x2a
0014E70C C4AE38EC lwc1       $f14, 0x38ec($a1)
0014E710 26103864 addiu      $s0, $s0, 0x3864
0014E714 3C05002A lui        $a1, 0x2a
0014E718 02003025 move       $a2, $s0
0014E71C 34070001 ori        $a3, $zero, 1
0014E720 E7B400D4 swc1       $f20, 0xd4($sp)
0014E724 E7B600D8 swc1       $f22, 0xd8($sp)
0014E728 E7B800DC swc1       $f24, 0xdc($sp)
0014E72C AFB200E8 sw         $s2, 0xe8($sp)
0014E730 AFB300EC sw         $s3, 0xec($sp)
0014E734 AFB400F0 sw         $s4, 0xf0($sp)
0014E738 AFB500F4 sw         $s5, 0xf4($sp)
0014E73C AFB600F8 sw         $s6, 0xf8($sp)
0014E740 AFB700FC sw         $s7, 0xfc($sp)
0014E744 AFBE0100 sw         $fp, 0x100($sp)
0014E748 AFBF0104 sw         $ra, 0x104($sp)
0014E74C 0C01569F jal        0x55a7c
0014E750 24A538D8 addiu      $a1, $a1, 0x38d8
0014E754 8E3E0058 lw         $fp, 0x58($s1)
0014E758 34040008 ori        $a0, $zero, 8
0014E75C 8FD30000 lw         $s3, ($fp)
0014E760 0C007541 jal        0x1d504
0014E764 8E6500F0 lw         $a1, 0xf0($s3)
0014E768 926409E4 lbu        $a0, 0x9e4($s3)
0014E76C 3C053F80 lui        $a1, 0x3f80
0014E770 4480B000 mtc1       $zero, $f22
0014E774 27D40004 addiu      $s4, $fp, 4
0014E778 4485A000 mtc1       $a1, $f20
0014E77C 10800022 beqz       $a0, 0x14e808
0014E780 27B50048 addiu      $s5, $sp, 0x48
0014E784 C66C09E8 lwc1       $f12, 0x9e8($s3)
0014E788 3C043CA3 lui        $a0, 0x3ca3
0014E78C E7CC0004 swc1       $f12, 4($fp)
0014E790 C66C09EC lwc1       $f12, 0x9ec($s3)
0014E794 3484D70A ori        $a0, $a0, 0xd70a
0014E798 E7CC0008 swc1       $f12, 8($fp)
0014E79C 44846800 mtc1       $a0, $f13
0014E7A0 C66C09F0 lwc1       $f12, 0x9f0($s3)
0014E7A4 E7CC000C swc1       $f12, 0xc($fp)
0014E7A8 C66C09F4 lwc1       $f12, 0x9f4($s3)
0014E7AC 460D6302 mul.s      $f12, $f12, $f13
0014E7B0 E7AC0058 swc1       $f12, 0x58($sp)
0014E7B4 C66E09F8 lwc1       $f14, 0x9f8($s3)
0014E7B8 460D7382 mul.s      $f14, $f14, $f13
0014E7BC E7AE005C swc1       $f14, 0x5c($sp)
0014E7C0 C66E09FC lwc1       $f14, 0x9fc($s3)
0014E7C4 460D7342 mul.s      $f13, $f14, $f13
0014E7C8 E7AD0060 swc1       $f13, 0x60($sp)
0014E7CC C7CD0004 lwc1       $f13, 4($fp)
0014E7D0 C7CF0008 lwc1       $f15, 8($fp)
0014E7D4 460C6B00 add.s      $f12, $f13, $f12
0014E7D8 C7D0000C lwc1       $f16, 0xc($fp)
0014E7DC C7D10010 lwc1       $f17, 0x10($fp)
0014E7E0 E7CC0004 swc1       $f12, 4($fp)
0014E7E4 C7AC005C lwc1       $f12, 0x5c($sp)
0014E7E8 8FD00014 lw         $s0, 0x14($fp)
0014E7EC 460C7B80 add.s      $f14, $f15, $f12
0014E7F0 E7CE0008 swc1       $f14, 8($fp)
0014E7F4 46148B01 sub.s      $f12, $f17, $f20
0014E7F8 C7AD0060 lwc1       $f13, 0x60($sp)
0014E7FC 460D8340 add.s      $f13, $f16, $f13
0014E800 10000008 b          0x14e824
0014E804 E7CD000C swc1       $f13, 0xc($fp)
0014E808 02802025 move       $a0, $s4
0014E80C 02202825 move       $a1, $s1
0014E810 0C03AEA4 jal        0xeba90
0014E814 02003025 move       $a2, $s0
0014E818 C7CC0010 lwc1       $f12, 0x10($fp)
0014E81C 8FD00014 lw         $s0, 0x14($fp)
0014E820 46146301 sub.s      $f12, $f12, $f20
0014E824 4616603C c.lt.s     $f12, $f22
0014E828 00000000 nop        
0014E82C 45000002 bc1f       0x14e838
0014E830 E7CC0010 swc1       $f12, 0x10($fp)
0014E834 E7D60010 swc1       $f22, 0x10($fp)
0014E838 34040003 ori        $a0, $zero, 3
0014E83C 16040013 bne        $s0, $a0, 0x14e88c
0014E840 AFB100C8 sw         $s1, 0xc8($sp)
0014E844 AFB100C8 sw         $s1, 0xc8($sp)
0014E848 02202025 move       $a0, $s1
0014E84C 0C019491 jal        0x65244
0014E850 00002825 move       $a1, $zero
0014E854 1040000D beqz       $v0, 0x14e88c
0014E858 00000000 nop        
0014E85C AFB100C8 sw         $s1, 0xc8($sp)
0014E860 4600B346 mov.s      $f13, $f22
0014E864 3C083DCC lui        $t0, 0x3dcc
0014E868 A2200045 sb         $zero, 0x45($s1)
0014E86C 3508CCCD ori        $t0, $t0, 0xcccd
0014E870 AFC00014 sw         $zero, 0x14($fp)
0014E874 44886000 mtc1       $t0, $f12
0014E878 02202025 move       $a0, $s1
0014E87C 00002825 move       $a1, $zero
0014E880 00003025 move       $a2, $zero
0014E884 0C01955C jal        0x65570
0014E888 34070001 ori        $a3, $zero, 1
0014E88C 8E6600F0 lw         $a2, 0xf0($s3)
0014E890 34040008 ori        $a0, $zero, 8
0014E894 0C0076E2 jal        0x1db88
0014E898 34050014 ori        $a1, $zero, 0x14
0014E89C 34100001 ori        $s0, $zero, 1
0014E8A0 10400017 beqz       $v0, 0x14e900
0014E8A4 A3A200CC sb         $v0, 0xcc($sp)
0014E8A8 C7CC0018 lwc1       $f12, 0x18($fp)
0014E8AC 34040001 ori        $a0, $zero, 1
0014E8B0 4600630D trunc.w.s  $f12, $f12
0014E8B4 AFA40068 sw         $a0, 0x68($sp)
0014E8B8 34050004 ori        $a1, $zero, 4
0014E8BC AFA5006C sw         $a1, 0x6c($sp)
0014E8C0 44046000 mfc1       $a0, $f12
0014E8C4 24840001 addiu      $a0, $a0, 1
0014E8C8 28850001 slti       $a1, $a0, 1
0014E8CC 10A00004 beqz       $a1, 0x14e8e0
0014E8D0 AFA40064 sw         $a0, 0x64($sp)
0014E8D4 27A40068 addiu      $a0, $sp, 0x68
0014E8D8 10000008 b          0x14e8fc
0014E8DC 8C840000 lw         $a0, ($a0)
0014E8E0 8FA5006C lw         $a1, 0x6c($sp)
0014E8E4 00A4202A slt        $a0, $a1, $a0
0014E8E8 10800003 beqz       $a0, 0x14e8f8
0014E8EC 27A40064 addiu      $a0, $sp, 0x64
0014E8F0 10000001 b          0x14e8f8
0014E8F4 27A4006C addiu      $a0, $sp, 0x6c
0014E8F8 8C840000 lw         $a0, ($a0)
0014E8FC 00808025 move       $s0, $a0
0014E900 27A40030 addiu      $a0, $sp, 0x30
0014E904 0C00A9C4 jal        0x2a710
0014E908 02602825 move       $a1, $s3
0014E90C 0C00A99C jal        0x2a670
0014E910 02602025 move       $a0, $s3
0014E914 24440020 addiu      $a0, $v0, 0x20
0014E918 C48C0000 lwc1       $f12, ($a0)
0014E91C C48D0004 lwc1       $f13, 4($a0)
0014E920 AFA200C4 sw         $v0, 0xc4($sp)
0014E924 44056000 mfc1       $a1, $f12
0014E928 C48E0008 lwc1       $f14, 8($a0)
0014E92C 44066800 mfc1       $a2, $f13
0014E930 C48F000C lwc1       $f15, 0xc($a0)
0014E934 AFA50038 sw         $a1, 0x38($sp)
0014E938 44047000 mfc1       $a0, $f14
0014E93C AFA6003C sw         $a2, 0x3c($sp)
0014E940 44057800 mfc1       $a1, $f15
0014E944 AFA40040 sw         $a0, 0x40($sp)
0014E948 AFA50044 sw         $a1, 0x44($sp)
0014E94C 34170000 ori        $s7, $zero, 0
0014E950 0C00A900 jal        0x2a400
0014E954 02602025 move       $a0, $s3
0014E958 10400006 beqz       $v0, 0x14e974
0014E95C 00000000 nop        
0014E960 0C0155F5 jal        0x557d4
0014E964 02602025 move       $a0, $s3
0014E968 10400002 beqz       $v0, 0x14e974
0014E96C 00000000 nop        
0014E970 34170001 ori        $s7, $zero, 1
0014E974 AFB400D0 sw         $s4, 0xd0($sp)
0014E978 AFB000BC sw         $s0, 0xbc($sp)
0014E97C 32F100FF andi       $s1, $s7, 0xff
0014E980 AFB100C0 sw         $s1, 0xc0($sp)
0014E984 0C00A99C jal        0x2a670
0014E988 02602025 move       $a0, $s3
0014E98C 3C09002A lui        $t1, 0x2a
0014E990 C52C3860 lwc1       $f12, 0x3860($t1)
0014E994 3C0B002A lui        $t3, 0x2a
0014E998 02602025 move       $a0, $s3
0014E99C 02002825 move       $a1, $s0
0014E9A0 02A03025 move       $a2, $s5
0014E9A4 27A70038 addiu      $a3, $sp, 0x38
0014E9A8 00404025 move       $t0, $v0
0014E9AC 02804825 move       $t1, $s4
0014E9B0 02205025 move       $t2, $s1
0014E9B4 0C00F1BF jal        0x3c6fc
0014E9B8 256B38B4 addiu      $t3, $t3, 0x38b4
0014E9BC 0040B825 move       $s7, $v0
0014E9C0 34120000 ori        $s2, $zero, 0
0014E9C4 0257202B sltu       $a0, $s2, $s7
0014E9C8 10800048 beqz       $a0, 0x14eaec
0014E9CC 3C043480 lui        $a0, 0x3480
0014E9D0 27B40070 addiu      $s4, $sp, 0x70
0014E9D4 4484C000 mtc1       $a0, $f24
0014E9D8 27B5007C addiu      $s5, $sp, 0x7c
0014E9DC 03A08825 move       $s1, $sp
0014E9E0 27D00020 addiu      $s0, $fp, 0x20
0014E9E4 3C160002 lui        $s6, 2
0014E9E8 8E240048 lw         $a0, 0x48($s1)
0014E9EC 02802825 move       $a1, $s4
0014E9F0 34060001 ori        $a2, $zero, 1
0014E9F4 0C019ACE jal        0x66b38
0014E9F8 00003825 move       $a3, $zero
0014E9FC 0C00A900 jal        0x2a400
0014EA00 02602025 move       $a0, $s3
0014EA04 1040000A beqz       $v0, 0x14ea30
0014EA08 00000000 nop        
0014EA0C 8E260048 lw         $a2, 0x48($s1)
0014EA10 02002025 move       $a0, $s0
0014EA14 34050001 ori        $a1, $zero, 1
0014EA18 0C0183F6 jal        0x60fd8
0014EA1C 34070001 ori        $a3, $zero, 1
0014EA20 02002025 move       $a0, $s0
0014EA24 02802825 move       $a1, $s4
0014EA28 0C018416 jal        0x61058
0014EA2C 00003025 move       $a2, $zero
0014EA30 16400029 bnez       $s2, 0x14ead8
0014EA34 00000000 nop        
0014EA38 0C015603 jal        0x5580c
0014EA3C 02602025 move       $a0, $s3
0014EA40 8E64095C lw         $a0, 0x95c($s3)
0014EA44 02A02825 move       $a1, $s5
0014EA48 00962025 or         $a0, $a0, $s6
0014EA4C AE64095C sw         $a0, 0x95c($s3)
0014EA50 8FA40048 lw         $a0, 0x48($sp)
0014EA54 00003025 move       $a2, $zero
0014EA58 0C019ACE jal        0x66b38
0014EA5C 00003825 move       $a3, $zero
0014EA60 C7AC007C lwc1       $f12, 0x7c($sp)
0014EA64 C66D0030 lwc1       $f13, 0x30($s3)
0014EA68 C66E0034 lwc1       $f14, 0x34($s3)
0014EA6C 460D6301 sub.s      $f12, $f12, $f13
0014EA70 C66F0038 lwc1       $f15, 0x38($s3)
0014EA74 E66C02A8 swc1       $f12, 0x2a8($s3)
0014EA78 C7B00080 lwc1       $f16, 0x80($sp)
0014EA7C 4600B346 mov.s      $f13, $f22
0014EA80 460E8381 sub.s      $f14, $f16, $f14
0014EA84 460C6442 mul.s      $f17, $f12, $f12
0014EA88 460D6C82 mul.s      $f18, $f13, $f13
0014EA8C E66E02AC swc1       $f14, 0x2ac($s3)
0014EA90 C7AE0084 lwc1       $f14, 0x84($sp)
0014EA94 46128C40 add.s      $f17, $f17, $f18
0014EA98 460F7381 sub.s      $f14, $f14, $f15
0014EA9C E67602AC swc1       $f22, 0x2ac($s3)
0014EAA0 460E73C2 mul.s      $f15, $f14, $f14
0014EAA4 460F8BC0 add.s      $f15, $f17, $f15
0014EAA8 4618783C c.lt.s     $f15, $f24
0014EAAC 00000000 nop        
0014EAB0 45010009 bc1t       0x14ead8
0014EAB4 E66E02B0 swc1       $f14, 0x2b0($s3)
0014EAB8 46007BC4 sqrt.s     $f15, $f15
0014EABC 460FA3C3 div.s      $f15, $f20, $f15
0014EAC0 460F6302 mul.s      $f12, $f12, $f15
0014EAC4 460F6B42 mul.s      $f13, $f13, $f15
0014EAC8 460F7382 mul.s      $f14, $f14, $f15
0014EACC E66C02A8 swc1       $f12, 0x2a8($s3)
0014EAD0 E66D02AC swc1       $f13, 0x2ac($s3)
0014EAD4 E66E02B0 swc1       $f14, 0x2b0($s3)
0014EAD8 26520001 addiu      $s2, $s2, 1
0014EADC 26310004 addiu      $s1, $s1, 4
0014EAE0 0257202B sltu       $a0, $s2, $s7
0014EAE4 1480FFC0 bnez       $a0, 0x14e9e8
0014EAE8 26100028 addiu      $s0, $s0, 0x28
0014EAEC 8E6600F0 lw         $a2, 0xf0($s3)
0014EAF0 34040008 ori        $a0, $zero, 8
0014EAF4 0C0076E2 jal        0x1db88
0014EAF8 34050015 ori        $a1, $zero, 0x15
0014EAFC 10400033 beqz       $v0, 0x14ebcc
0014EB00 34050001 ori        $a1, $zero, 1
0014EB04 8E64095C lw         $a0, 0x95c($s3)
0014EB08 3C060010 lui        $a2, 0x10
0014EB0C 00862024 and        $a0, $a0, $a2
0014EB10 0004202B sltu       $a0, $zero, $a0
0014EB14 308400FF andi       $a0, $a0, 0xff
0014EB18 1080002C beqz       $a0, 0x14ebcc
0014EB1C 00000000 nop        
0014EB20 866400F8 lh         $a0, 0xf8($s3)
0014EB24 3406001F ori        $a2, $zero, 0x1f
0014EB28 10860028 beq        $a0, $a2, 0x14ebcc
0014EB2C 00000000 nop        
0014EB30 93C400C0 lbu        $a0, 0xc0($fp)
0014EB34 1080001A beqz       $a0, 0x14eba0
0014EB38 00000000 nop        
0014EB3C 8FC4001C lw         $a0, 0x1c($fp)
0014EB40 8C840064 lw         $a0, 0x64($a0)
0014EB44 30860001 andi       $a2, $a0, 1
0014EB48 10C00007 beqz       $a2, 0x14eb68
0014EB4C 30860008 andi       $a2, $a0, 8
0014EB50 14C00005 bnez       $a2, 0x14eb68
0014EB54 30860006 andi       $a2, $a0, 6
0014EB58 14C00003 bnez       $a2, 0x14eb68
0014EB5C 30840400 andi       $a0, $a0, 0x400
0014EB60 1080001C beqz       $a0, 0x14ebd4
0014EB64 00000000 nop        
0014EB68 8FA40048 lw         $a0, 0x48($sp)
0014EB6C 10800009 beqz       $a0, 0x14eb94
0014EB70 00000000 nop        
0014EB74 8C860040 lw         $a2, 0x40($a0)
0014EB78 34070001 ori        $a3, $zero, 1
0014EB7C 90C6004B lbu        $a2, 0x4b($a2)
0014EB80 14C70004 bne        $a2, $a3, 0x14eb94
0014EB84 00000000 nop        
0014EB88 AFC4001C sw         $a0, 0x1c($fp)
0014EB8C 10000011 b          0x14ebd4
0014EB90 A3C500C0 sb         $a1, 0xc0($fp)
0014EB94 AFC0001C sw         $zero, 0x1c($fp)
0014EB98 1000000E b          0x14ebd4
0014EB9C A3C000C0 sb         $zero, 0xc0($fp)
0014EBA0 8FA40048 lw         $a0, 0x48($sp)
0014EBA4 1080000B beqz       $a0, 0x14ebd4
0014EBA8 00000000 nop        
0014EBAC 8C860040 lw         $a2, 0x40($a0)
0014EBB0 34070001 ori        $a3, $zero, 1
0014EBB4 90C6004B lbu        $a2, 0x4b($a2)
0014EBB8 14C70006 bne        $a2, $a3, 0x14ebd4
0014EBBC 00000000 nop        
0014EBC0 AFC4001C sw         $a0, 0x1c($fp)
0014EBC4 10000003 b          0x14ebd4
0014EBC8 A3C500C0 sb         $a1, 0xc0($fp)
0014EBCC AFC0001C sw         $zero, 0x1c($fp)
0014EBD0 A3C000C0 sb         $zero, 0xc0($fp)
0014EBD4 0C00A900 jal        0x2a400
0014EBD8 02602025 move       $a0, $s3
0014EBDC 1040001C beqz       $v0, 0x14ec50
0014EBE0 00000000 nop        
0014EBE4 93C400C0 lbu        $a0, 0xc0($fp)
0014EBE8 10800019 beqz       $a0, 0x14ec50
0014EBEC 00000000 nop        
0014EBF0 8FC4001C lw         $a0, 0x1c($fp)
0014EBF4 10800016 beqz       $a0, 0x14ec50
0014EBF8 00000000 nop        
0014EBFC 3C06002A lui        $a2, 0x2a
0014EC00 4600A346 mov.s      $f13, $f20
0014EC04 34040064 ori        $a0, $zero, 0x64
0014EC08 34050002 ori        $a1, $zero, 2
0014EC0C 0C000993 jal        0x264c
0014EC10 C4CC3958 lwc1       $f12, 0x3958($a2)
0014EC14 3C053F91 lui        $a1, 0x3f91
0014EC18 4600A346 mov.s      $f13, $f20
0014EC1C 34A5EB85 ori        $a1, $a1, 0xeb85
0014EC20 44856000 mtc1       $a1, $f12
0014EC24 34040064 ori        $a0, $zero, 0x64
0014EC28 0C00099E jal        0x2678
0014EC2C 34050002 ori        $a1, $zero, 2
0014EC30 8FC4001C lw         $a0, 0x1c($fp)
0014EC34 0C00031B jal        0xc6c
0014EC38 24900030 addiu      $s0, $a0, 0x30
0014EC3C 46000347 neg.s      $f13, $f0
0014EC40 02002025 move       $a0, $s0
0014EC44 4600A306 mov.s      $f12, $f20
0014EC48 0C000A42 jal        0x2908
0014EC4C 00002825 move       $a1, $zero
0014EC50 0C00A900 jal        0x2a400
0014EC54 02602025 move       $a0, $s3
0014EC58 1040009E beqz       $v0, 0x14eed4
0014EC5C 00000000 nop        
0014EC60 C7CC0010 lwc1       $f12, 0x10($fp)
0014EC64 46166032 c.eq.s     $f12, $f22
0014EC68 00000000 nop        
0014EC6C 45000099 bc1f       0x14eed4
0014EC70 00000000 nop        
0014EC74 0C0070C3 jal        0x1c30c
0014EC78 02602025 move       $a0, $s3
0014EC7C 10400095 beqz       $v0, 0x14eed4
0014EC80 00000000 nop        
0014EC84 8FA40030 lw         $a0, 0x30($sp)
0014EC88 30840020 andi       $a0, $a0, 0x20
0014EC8C 10800091 beqz       $a0, 0x14eed4
0014EC90 00000000 nop        
0014EC94 8FA400C8 lw         $a0, 0xc8($sp)
0014EC98 90840045 lbu        $a0, 0x45($a0)
0014EC9C 10800003 beqz       $a0, 0x14ecac
0014ECA0 34050008 ori        $a1, $zero, 8
0014ECA4 1485008B bne        $a0, $a1, 0x14eed4
0014ECA8 00000000 nop        
0014ECAC 266400C0 addiu      $a0, $s3, 0xc0
0014ECB0 8C930014 lw         $s3, 0x14($a0)
0014ECB4 93A400CC lbu        $a0, 0xcc($sp)
0014ECB8 34100000 ori        $s0, $zero, 0
0014ECBC 1080003B beqz       $a0, 0x14edac
0014ECC0 32732000 andi       $s3, $s3, 0x2000
0014ECC4 12600033 beqz       $s3, 0x14ed94
0014ECC8 C7CC0018 lwc1       $f12, 0x18($fp)
0014ECCC 3C044F00 lui        $a0, 0x4f00
0014ECD0 44846800 mtc1       $a0, $f13
0014ECD4 3C04002A lui        $a0, 0x2a
0014ECD8 460D603C c.lt.s     $f12, $f13
0014ECDC 00000000 nop        
0014ECE0 45000004 bc1f       0x14ecf4
0014ECE4 C48E38F0 lwc1       $f14, 0x38f0($a0)
0014ECE8 460063CD trunc.w.s  $f15, $f12
0014ECEC 10000006 b          0x14ed08
0014ECF0 44047800 mfc1       $a0, $f15
0014ECF4 460D63C1 sub.s      $f15, $f12, $f13
0014ECF8 3C048000 lui        $a0, 0x8000
0014ECFC 46007BCD trunc.w.s  $f15, $f15
0014ED00 44057800 mfc1       $a1, $f15
0014ED04 00A42021 addu       $a0, $a1, $a0
0014ED08 460E6300 add.s      $f12, $f12, $f14
0014ED0C 3C054080 lui        $a1, 0x4080
0014ED10 44857800 mtc1       $a1, $f15
0014ED14 E7CC0018 swc1       $f12, 0x18($fp)
0014ED18 E7AF0088 swc1       $f15, 0x88($sp)
0014ED1C C7CC0018 lwc1       $f12, 0x18($fp)
0014ED20 460F603C c.lt.s     $f12, $f15
0014ED24 00000000 nop        
0014ED28 45000004 bc1f       0x14ed3c
0014ED2C 27A50088 addiu      $a1, $sp, 0x88
0014ED30 27C50018 addiu      $a1, $fp, 0x18
0014ED34 10000002 b          0x14ed40
0014ED38 C4AC0000 lwc1       $f12, ($a1)
0014ED3C C4AC0000 lwc1       $f12, ($a1)
0014ED40 E7CC0018 swc1       $f12, 0x18($fp)
0014ED44 C7CC0018 lwc1       $f12, 0x18($fp)
0014ED48 460D603C c.lt.s     $f12, $f13
0014ED4C 00000000 nop        
0014ED50 45020005 bc1fl      0x14ed68
0014ED54 460D6301 sub.s      $f12, $f12, $f13
0014ED58 4600630D trunc.w.s  $f12, $f12
0014ED5C 44056000 mfc1       $a1, $f12
0014ED60 10000006 b          0x14ed7c
0014ED64 0085202B sltu       $a0, $a0, $a1
0014ED68 3C058000 lui        $a1, 0x8000
0014ED6C 4600630D trunc.w.s  $f12, $f12
0014ED70 44066000 mfc1       $a2, $f12
0014ED74 00C52821 addu       $a1, $a2, $a1
0014ED78 0085202B sltu       $a0, $a0, $a1
0014ED7C 10800003 beqz       $a0, 0x14ed8c
0014ED80 00000000 nop        
0014ED84 0C027A9C jal        0x9ea70
0014ED88 34040006 ori        $a0, $zero, 6
0014ED8C 1000000A b          0x14edb8
0014ED90 00000000 nop        
0014ED94 46166032 c.eq.s     $f12, $f22
0014ED98 00000000 nop        
0014ED9C 45010006 bc1t       0x14edb8
0014EDA0 00000000 nop        
0014EDA4 10000004 b          0x14edb8
0014EDA8 34100001 ori        $s0, $zero, 1
0014EDAC 12600002 beqz       $s3, 0x14edb8
0014EDB0 00000000 nop        
0014EDB4 34100001 ori        $s0, $zero, 1
0014EDB8 12000046 beqz       $s0, 0x14eed4
0014EDBC 00000000 nop        
0014EDC0 8FA400BC lw         $a0, 0xbc($sp)
0014EDC4 34120000 ori        $s2, $zero, 0
0014EDC8 0244202B sltu       $a0, $s2, $a0
0014EDCC 1080003B beqz       $a0, 0x14eebc
0014EDD0 34100000 ori        $s0, $zero, 0
0014EDD4 8FB600BC lw         $s6, 0xbc($sp)
0014EDD8 8FB700C0 lw         $s7, 0xc0($sp)
0014EDDC 26C4FFFF addiu      $a0, $s6, -1
0014EDE0 00049880 sll        $s3, $a0, 2
0014EDE4 3C04002A lui        $a0, 0x2a
0014EDE8 248438A0 addiu      $a0, $a0, 0x38a0
0014EDEC 3C14002A lui        $s4, 0x2a
0014EDF0 34150001 ori        $s5, $zero, 1
0014EDF4 27B1008C addiu      $s1, $sp, 0x8c
0014EDF8 02649821 addu       $s3, $s3, $a0
0014EDFC 8FBE00C4 lw         $fp, 0xc4($sp)
0014EE00 26943870 addiu      $s4, $s4, 0x3870
0014EE04 12E0000A beqz       $s7, 0x14ee30
0014EE08 00000000 nop        
0014EE0C 16D50008 bne        $s6, $s5, 0x14ee30
0014EE10 00000000 nop        
0014EE14 C7AC0038 lwc1       $f12, 0x38($sp)
0014EE18 E62C0000 swc1       $f12, ($s1)
0014EE1C C7AC003C lwc1       $f12, 0x3c($sp)
0014EE20 E62C0004 swc1       $f12, 4($s1)
0014EE24 C7AC0040 lwc1       $f12, 0x40($sp)
0014EE28 10000016 b          0x14ee84
0014EE2C E62C0008 swc1       $f12, 8($s1)
0014EE30 1640000C bnez       $s2, 0x14ee64
0014EE34 00102080 sll        $a0, $s0, 2
0014EE38 03A42021 addu       $a0, $sp, $a0
0014EE3C 8C840048 lw         $a0, 0x48($a0)
0014EE40 10800008 beqz       $a0, 0x14ee64
0014EE44 00000000 nop        
0014EE48 C7AC0038 lwc1       $f12, 0x38($sp)
0014EE4C E62C0000 swc1       $f12, ($s1)
0014EE50 C7AC003C lwc1       $f12, 0x3c($sp)
0014EE54 E62C0004 swc1       $f12, 4($s1)
0014EE58 C7AC0040 lwc1       $f12, 0x40($sp)
0014EE5C 10000009 b          0x14ee84
0014EE60 E62C0008 swc1       $f12, 8($s1)
0014EE64 92650000 lbu        $a1, ($s3)
0014EE68 02202025 move       $a0, $s1
0014EE6C 00A53021 addu       $a2, $a1, $a1
0014EE70 00A62821 addu       $a1, $a1, $a2
0014EE74 00053080 sll        $a2, $a1, 2
0014EE78 00D43021 addu       $a2, $a2, $s4
0014EE7C 0C03AE58 jal        0xeb960
0014EE80 03C02825 move       $a1, $fp
0014EE84 26100001 addiu      $s0, $s0, 1
0014EE88 2E040004 sltiu      $a0, $s0, 4
0014EE8C 10800005 beqz       $a0, 0x14eea4
0014EE90 00102080 sll        $a0, $s0, 2
0014EE94 03A42021 addu       $a0, $sp, $a0
0014EE98 8C840048 lw         $a0, 0x48($a0)
0014EE9C 14800002 bnez       $a0, 0x14eea8
0014EEA0 00000000 nop        
0014EEA4 34100000 ori        $s0, $zero, 0
0014EEA8 26520001 addiu      $s2, $s2, 1
0014EEAC 2631000C addiu      $s1, $s1, 0xc
0014EEB0 0256202B sltu       $a0, $s2, $s6
0014EEB4 1480FFD3 bnez       $a0, 0x14ee04
0014EEB8 26730001 addiu      $s3, $s3, 1
0014EEBC 8FA400C8 lw         $a0, 0xc8($sp)
0014EEC0 8FA500D0 lw         $a1, 0xd0($sp)
0014EEC4 27A6008C addiu      $a2, $sp, 0x8c
0014EEC8 27A70048 addiu      $a3, $sp, 0x48
0014EECC 0C0538FE jal        0x14e3f8
0014EED0 8FA800BC lw         $t0, 0xbc($sp)
0014EED4 C7B400D4 lwc1       $f20, 0xd4($sp)
0014EED8 C7B600D8 lwc1       $f22, 0xd8($sp)
0014EEDC C7B800DC lwc1       $f24, 0xdc($sp)
0014EEE0 8FB000E0 lw         $s0, 0xe0($sp)
0014EEE4 8FB100E4 lw         $s1, 0xe4($sp)
0014EEE8 8FB200E8 lw         $s2, 0xe8($sp)
0014EEEC 8FB300EC lw         $s3, 0xec($sp)
0014EEF0 8FB400F0 lw         $s4, 0xf0($sp)
0014EEF4 8FB500F4 lw         $s5, 0xf4($sp)
0014EEF8 8FB600F8 lw         $s6, 0xf8($sp)
0014EEFC 8FB700FC lw         $s7, 0xfc($sp)
0014EF00 8FBE0100 lw         $fp, 0x100($sp)
0014EF04 8FBF0104 lw         $ra, 0x104($sp)
0014EF08 03E00008 jr         $ra
0014EF0C 27BD0110 addiu      $sp, $sp, 0x110