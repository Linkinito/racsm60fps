
CALLBACK 0x00117700 end 0x001177D8 ordinal 0

00117700 27BDFFD0 addiu      $sp, $sp, -0x30
00117704 AFB00020 sw         $s0, 0x20($sp)
00117708 00808025 move       $s0, $a0
0011770C AFB10024 sw         $s1, 0x24($sp)
00117710 8E110058 lw         $s1, 0x58($s0)
00117714 00002825 move       $a1, $zero
00117718 02202025 move       $a0, $s1
0011771C AFB20028 sw         $s2, 0x28($sp)
00117720 AFBF002C sw         $ra, 0x2c($sp)
00117724 0C0600AC jal        0x1802b0
00117728 34060044 ori        $a2, $zero, 0x44
0011772C 2624001C addiu      $a0, $s1, 0x1c
00117730 3C080028 lui        $t0, 0x28
00117734 34110001 ori        $s1, $zero, 1
00117738 34050001 ori        $a1, $zero, 1
0011773C 34060044 ori        $a2, $zero, 0x44
00117740 34070045 ori        $a3, $zero, 0x45
00117744 0C01859E jal        0x61678
00117748 25082090 addiu      $t0, $t0, 0x2090
0011774C 3C040028 lui        $a0, 0x28
00117750 8C92F8D8 lw         $s2, -0x728($a0)
00117754 26040074 addiu      $a0, $s0, 0x74
00117758 8E4600F0 lw         $a2, 0xf0($s2)
0011775C 34050004 ori        $a1, $zero, 4
00117760 0C006F54 jal        0x1bd50
00117764 2407FFFF addiu      $a3, $zero, -1
00117768 8E040048 lw         $a0, 0x48($s0)
0011776C 3C050011 lui        $a1, 0x11
00117770 24A57804 addiu      $a1, $a1, 0x7804
00117774 AC8500DC sw         $a1, 0xdc($a0)
00117778 3C05002A lui        $a1, 0x2a
0011777C C4ACE404 lwc1       $f12, -0x1bfc($a1)
00117780 3C05002A lui        $a1, 0x2a
00117784 C4ADE408 lwc1       $f13, -0x1bf8($a1)
00117788 3C05002A lui        $a1, 0x2a
0011778C 3C084120 lui        $t0, 0x4120
00117790 3C06002A lui        $a2, 0x2a
00117794 44887000 mtc1       $t0, $f14
00117798 02402025 move       $a0, $s2
0011779C 00003825 move       $a3, $zero
001177A0 24A5E3F8 addiu      $a1, $a1, -0x1c08
001177A4 0C01569F jal        0x55a7c
001177A8 24C6E40C addiu      $a2, $a2, -0x1bf4
001177AC 8E040064 lw         $a0, 0x64($s0)
001177B0 3C050004 lui        $a1, 4
001177B4 00852025 or         $a0, $a0, $a1
001177B8 AE040064 sw         $a0, 0x64($s0)
001177BC 02201025 move       $v0, $s1
001177C0 8FB00020 lw         $s0, 0x20($sp)
001177C4 8FB10024 lw         $s1, 0x24($sp)
001177C8 8FB20028 lw         $s2, 0x28($sp)
001177CC 8FBF002C lw         $ra, 0x2c($sp)
001177D0 03E00008 jr         $ra
001177D4 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x001177D8 end 0x00117804 ordinal 1

001177D8 27BDFFE0 addiu      $sp, $sp, -0x20
001177DC 8C840058 lw         $a0, 0x58($a0)
001177E0 8C840000 lw         $a0, ($a0)
001177E4 AFBF0010 sw         $ra, 0x10($sp)
001177E8 10800003 beqz       $a0, 0x1177f8
001177EC 00000000 nop        
001177F0 0C00A7B3 jal        0x29ecc
001177F4 34050001 ori        $a1, $zero, 1
001177F8 8FBF0010 lw         $ra, 0x10($sp)
001177FC 03E00008 jr         $ra
00117800 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x00117C88 end 0x001181F8 ordinal 2

00117C88 27BDFF30 addiu      $sp, $sp, -0xd0
00117C8C AFBE00BC sw         $fp, 0xbc($sp)
00117C90 0080F025 move       $fp, $a0
00117C94 8FC40058 lw         $a0, 0x58($fp)
00117C98 E7B40094 swc1       $f20, 0x94($sp)
00117C9C AFB600B4 sw         $s6, 0xb4($sp)
00117CA0 46006506 mov.s      $f20, $f12
00117CA4 00002825 move       $a1, $zero
00117CA8 8C960000 lw         $s6, ($a0)
00117CAC E7B60098 swc1       $f22, 0x98($sp)
00117CB0 AFB0009C sw         $s0, 0x9c($sp)
00117CB4 AFB100A0 sw         $s1, 0xa0($sp)
00117CB8 AFB200A4 sw         $s2, 0xa4($sp)
00117CBC AFB300A8 sw         $s3, 0xa8($sp)
00117CC0 AFB400AC sw         $s4, 0xac($sp)
00117CC4 AFB500B0 sw         $s5, 0xb0($sp)
00117CC8 AFB700B8 sw         $s7, 0xb8($sp)
00117CCC AFBF00C0 sw         $ra, 0xc0($sp)
00117CD0 0C00A7B3 jal        0x29ecc
00117CD4 02C02025 move       $a0, $s6
00117CD8 8FD70058 lw         $s7, 0x58($fp)
00117CDC 8EC500F0 lw         $a1, 0xf0($s6)
00117CE0 0C007541 jal        0x1d504
00117CE4 34040004 ori        $a0, $zero, 4
00117CE8 27A40020 addiu      $a0, $sp, 0x20
00117CEC 0C00A9C4 jal        0x2a710
00117CF0 02C02825 move       $a1, $s6
00117CF4 34100000 ori        $s0, $zero, 0
00117CF8 0C00A900 jal        0x2a400
00117CFC 02C02025 move       $a0, $s6
00117D00 10400006 beqz       $v0, 0x117d1c
00117D04 4480B000 mtc1       $zero, $f22
00117D08 0C0155F5 jal        0x557d4
00117D0C 02C02025 move       $a0, $s6
00117D10 10400002 beqz       $v0, 0x117d1c
00117D14 00000000 nop        
00117D18 34100001 ori        $s0, $zero, 1
00117D1C C6EC0018 lwc1       $f12, 0x18($s7)
00117D20 46166032 c.eq.s     $f12, $f22
00117D24 00000000 nop        
00117D28 4501001B bc1t       0x117d98
00117D2C 321300FF andi       $s3, $s0, 0xff
00117D30 46146301 sub.s      $f12, $f12, $f20
00117D34 02C02025 move       $a0, $s6
00117D38 0C00A905 jal        0x2a414
00117D3C E6EC0018 swc1       $f12, 0x18($s7)
00117D40 C6EC0018 lwc1       $f12, 0x18($s7)
00117D44 4616603E c.le.s     $f12, $f22
00117D48 00000000 nop        
00117D4C 4501000F bc1t       0x117d8c
00117D50 00402025 move       $a0, $v0
00117D54 8FA50020 lw         $a1, 0x20($sp)
00117D58 30A50020 andi       $a1, $a1, 0x20
00117D5C 10A0000E beqz       $a1, 0x117d98
00117D60 3405001E ori        $a1, $zero, 0x1e
00117D64 1085000C beq        $a0, $a1, 0x117d98
00117D68 3C04002A lui        $a0, 0x2a
00117D6C C48DE3EC lwc1       $f13, -0x1c14($a0)
00117D70 3C04002A lui        $a0, 0x2a
00117D74 C48EE3F0 lwc1       $f14, -0x1c10($a0)
00117D78 460E6B41 sub.s      $f13, $f13, $f14
00117D7C 460D603E c.le.s     $f12, $f13
00117D80 00000000 nop        
00117D84 45000004 bc1f       0x117d98
00117D88 00000000 nop        
00117D8C E6F60018 swc1       $f22, 0x18($s7)
00117D90 34040001 ori        $a0, $zero, 1
00117D94 A3C40046 sb         $a0, 0x46($fp)
00117D98 C6EC0014 lwc1       $f12, 0x14($s7)
00117D9C 46146301 sub.s      $f12, $f12, $f20
00117DA0 4616603C c.lt.s     $f12, $f22
00117DA4 00000000 nop        
00117DA8 45000002 bc1f       0x117db4
00117DAC E6EC0014 swc1       $f12, 0x14($s7)
00117DB0 E6F60014 swc1       $f22, 0x14($s7)
00117DB4 8EE40010 lw         $a0, 0x10($s7)
00117DB8 34050004 ori        $a1, $zero, 4
00117DBC 14850007 bne        $a0, $a1, 0x117ddc
00117DC0 00000000 nop        
00117DC4 03C02025 move       $a0, $fp
00117DC8 0C019491 jal        0x65244
00117DCC 00002825 move       $a1, $zero
00117DD0 10400002 beqz       $v0, 0x117ddc
00117DD4 00000000 nop        
00117DD8 A3C00045 sb         $zero, 0x45($fp)
00117DDC A3B30091 sb         $s3, 0x91($sp)
00117DE0 0C00A99C jal        0x2a670
00117DE4 02C02025 move       $a0, $s6
00117DE8 C44C0020 lwc1       $f12, 0x20($v0)
00117DEC E7AC0028 swc1       $f12, 0x28($sp)
00117DF0 C44C0024 lwc1       $f12, 0x24($v0)
00117DF4 E7AC002C swc1       $f12, 0x2c($sp)
00117DF8 C44C0028 lwc1       $f12, 0x28($v0)
00117DFC E7AC0030 swc1       $f12, 0x30($sp)
00117E00 C6CC0030 lwc1       $f12, 0x30($s6)
00117E04 3C043F80 lui        $a0, 0x3f80
00117E08 E7AC0038 swc1       $f12, 0x38($sp)
00117E0C C6CC0034 lwc1       $f12, 0x34($s6)
00117E10 E7AC003C swc1       $f12, 0x3c($sp)
00117E14 C6CC0038 lwc1       $f12, 0x38($s6)
00117E18 C7AD003C lwc1       $f13, 0x3c($sp)
00117E1C E7AC0040 swc1       $f12, 0x40($sp)
00117E20 44846000 mtc1       $a0, $f12
00117E24 460C6B00 add.s      $f12, $f13, $f12
00117E28 34120000 ori        $s2, $zero, 0
00117E2C E7AC003C swc1       $f12, 0x3c($sp)
00117E30 C6EC0014 lwc1       $f12, 0x14($s7)
00117E34 46166032 c.eq.s     $f12, $f22
00117E38 00000000 nop        
00117E3C 450000B3 bc1f       0x11810c
00117E40 34150000 ori        $s5, $zero, 0
00117E44 A3B30091 sb         $s3, 0x91($sp)
00117E48 0C00A900 jal        0x2a400
00117E4C 02C02025 move       $a0, $s6
00117E50 104000AE beqz       $v0, 0x11810c
00117E54 00000000 nop        
00117E58 A3B30091 sb         $s3, 0x91($sp)
00117E5C 0C00A99C jal        0x2a670
00117E60 02C02025 move       $a0, $s6
00117E64 27B10038 addiu      $s1, $sp, 0x38
00117E68 3C10002A lui        $s0, 0x2a
00117E6C 3C09002A lui        $t1, 0x2a
00117E70 02C02025 move       $a0, $s6
00117E74 27A50028 addiu      $a1, $sp, 0x28
00117E78 00403025 move       $a2, $v0
00117E7C C60CE41C lwc1       $f12, -0x1be4($s0)
00117E80 02203825 move       $a3, $s1
00117E84 02604025 move       $t0, $s3
00117E88 0C00BB23 jal        0x2ec8c
00117E8C 2529E420 addiu      $t1, $t1, -0x1be0
00117E90 34120001 ori        $s2, $zero, 1
00117E94 0040A825 move       $s5, $v0
00117E98 12A00058 beqz       $s5, 0x117ffc
00117E9C A3B20090 sb         $s2, 0x90($sp)
00117EA0 AFA00058 sw         $zero, 0x58($sp)
00117EA4 AFA00054 sw         $zero, 0x54($sp)
00117EA8 E7B6005C swc1       $f22, 0x5c($sp)
00117EAC C6AC0030 lwc1       $f12, 0x30($s5)
00117EB0 E7AC0060 swc1       $f12, 0x60($sp)
00117EB4 C6AC0034 lwc1       $f12, 0x34($s5)
00117EB8 E7AC0064 swc1       $f12, 0x64($sp)
00117EBC C6AC0038 lwc1       $f12, 0x38($s5)
00117EC0 C7AD0060 lwc1       $f13, 0x60($sp)
00117EC4 E7AC0068 swc1       $f12, 0x68($sp)
00117EC8 C6AC0010 lwc1       $f12, 0x10($s5)
00117ECC C7AE0064 lwc1       $f14, 0x64($sp)
00117ED0 460C6B00 add.s      $f12, $f13, $f12
00117ED4 C7AF0068 lwc1       $f15, 0x68($sp)
00117ED8 3C040006 lui        $a0, 6
00117EDC 2484E2A8 addiu      $a0, $a0, -0x1d58
00117EE0 E7AC0060 swc1       $f12, 0x60($sp)
00117EE4 C6AC0014 lwc1       $f12, 0x14($s5)
00117EE8 C490000C lwc1       $f16, 0xc($a0)
00117EEC 460C7300 add.s      $f12, $f14, $f12
00117EF0 27B00044 addiu      $s0, $sp, 0x44
00117EF4 27B10060 addiu      $s1, $sp, 0x60
00117EF8 27A4005C addiu      $a0, $sp, 0x5c
00117EFC E7AC0064 swc1       $f12, 0x64($sp)
00117F00 C6AD0018 lwc1       $f13, 0x18($s5)
00117F04 46106301 sub.s      $f12, $f12, $f16
00117F08 02002825 move       $a1, $s0
00117F0C 460D7B40 add.s      $f13, $f15, $f13
00117F10 02203025 move       $a2, $s1
00117F14 34070008 ori        $a3, $zero, 8
00117F18 00004025 move       $t0, $zero
00117F1C 02A04825 move       $t1, $s5
00117F20 0C00649C jal        0x19270
00117F24 E7AD0068 swc1       $f13, 0x68($sp)
00117F28 10400032 beqz       $v0, 0x117ff4
00117F2C 00000000 nop        
00117F30 C7AC0044 lwc1       $f12, 0x44($sp)
00117F34 C7AD0048 lwc1       $f13, 0x48($sp)
00117F38 460C6302 mul.s      $f12, $f12, $f12
00117F3C C7AE004C lwc1       $f14, 0x4c($sp)
00117F40 460D6B42 mul.s      $f13, $f13, $f13
00117F44 3C053727 lui        $a1, 0x3727
00117F48 460E7382 mul.s      $f14, $f14, $f14
00117F4C 34A5C5AC ori        $a1, $a1, 0xc5ac
00117F50 44857800 mtc1       $a1, $f15
00117F54 34040000 ori        $a0, $zero, 0
00117F58 460D6300 add.s      $f12, $f12, $f13
00117F5C 460E6300 add.s      $f12, $f12, $f14
00117F60 46006305 abs.s      $f12, $f12
00117F64 460F603E c.le.s     $f12, $f15
00117F68 00000000 nop        
00117F6C 45030001 bc1tl      0x117f74
00117F70 34040001 ori        $a0, $zero, 1
00117F74 308400FF andi       $a0, $a0, 0xff
00117F78 1480001E bnez       $a0, 0x117ff4
00117F7C 00000000 nop        
00117F80 C7AC005C lwc1       $f12, 0x5c($sp)
00117F84 C6AD0010 lwc1       $f13, 0x10($s5)
00117F88 46006307 neg.s      $f12, $f12
00117F8C C7AE0060 lwc1       $f14, 0x60($sp)
00117F90 460C6B42 mul.s      $f13, $f13, $f12
00117F94 C7AF0064 lwc1       $f15, 0x64($sp)
00117F98 C7B00068 lwc1       $f16, 0x68($sp)
00117F9C 460D7340 add.s      $f13, $f14, $f13
00117FA0 26F3001C addiu      $s3, $s7, 0x1c
00117FA4 E7AD0060 swc1       $f13, 0x60($sp)
00117FA8 C6AD0014 lwc1       $f13, 0x14($s5)
00117FAC 460C6B42 mul.s      $f13, $f13, $f12
00117FB0 02602025 move       $a0, $s3
00117FB4 34050001 ori        $a1, $zero, 1
00117FB8 460D7B40 add.s      $f13, $f15, $f13
00117FBC 02A03025 move       $a2, $s5
00117FC0 34070001 ori        $a3, $zero, 1
00117FC4 E7AD0064 swc1       $f13, 0x64($sp)
00117FC8 C6AD0018 lwc1       $f13, 0x18($s5)
00117FCC 460C6B02 mul.s      $f12, $f13, $f12
00117FD0 460C8300 add.s      $f12, $f16, $f12
00117FD4 0C0183F6 jal        0x60fd8
00117FD8 E7AC0068 swc1       $f12, 0x68($sp)
00117FDC 3C070028 lui        $a3, 0x28
00117FE0 02602025 move       $a0, $s3
00117FE4 02202825 move       $a1, $s1
00117FE8 02003025 move       $a2, $s0
00117FEC 0C018476 jal        0x611d8
00117FF0 C4EC2110 lwc1       $f12, 0x2110($a3)
00117FF4 10000045 b          0x11810c
00117FF8 00000000 nop        
00117FFC C60CE41C lwc1       $f12, -0x1be4($s0)
00118000 C7AD002C lwc1       $f13, 0x2c($sp)
00118004 C7AE0028 lwc1       $f14, 0x28($sp)
00118008 460D6342 mul.s      $f13, $f12, $f13
0011800C C7AF0030 lwc1       $f15, 0x30($sp)
00118010 460E6382 mul.s      $f14, $f12, $f14
00118014 3C044000 lui        $a0, 0x4000
00118018 44848000 mtc1       $a0, $f16
0011801C 26F4001C addiu      $s4, $s7, 0x1c
00118020 02802025 move       $a0, $s4
00118024 E7AD0070 swc1       $f13, 0x70($sp)
00118028 460F6302 mul.s      $f12, $f12, $f15
0011802C E7AE006C swc1       $f14, 0x6c($sp)
00118030 46106B40 add.s      $f13, $f13, $f16
00118034 00002825 move       $a1, $zero
00118038 00003025 move       $a2, $zero
0011803C 34070001 ori        $a3, $zero, 1
00118040 E7AC0074 swc1       $f12, 0x74($sp)
00118044 0C0183F6 jal        0x60fd8
00118048 E7AD0070 swc1       $f13, 0x70($sp)
0011804C 27B30078 addiu      $s3, $sp, 0x78
00118050 27B20084 addiu      $s2, $sp, 0x84
00118054 27B0006C addiu      $s0, $sp, 0x6c
00118058 02602025 move       $a0, $s3
0011805C 02402825 move       $a1, $s2
00118060 02203025 move       $a2, $s1
00118064 0C0184EE jal        0x613b8
00118068 02003825 move       $a3, $s0
0011806C 50400009 beql       $v0, $zero, 0x118094
00118070 C7AC0038 lwc1       $f12, 0x38($sp)
00118074 3C070028 lui        $a3, 0x28
00118078 02802025 move       $a0, $s4
0011807C 02602825 move       $a1, $s3
00118080 02403025 move       $a2, $s2
00118084 0C018476 jal        0x611d8
00118088 C4EC2110 lwc1       $f12, 0x2110($a3)
0011808C 1000001E b          0x118108
00118090 00000000 nop        
00118094 C7AD006C lwc1       $f13, 0x6c($sp)
00118098 C7AE003C lwc1       $f14, 0x3c($sp)
0011809C 460D6300 add.s      $f12, $f12, $f13
001180A0 C7AF0070 lwc1       $f15, 0x70($sp)
001180A4 C7B00040 lwc1       $f16, 0x40($sp)
001180A8 C7B10074 lwc1       $f17, 0x74($sp)
001180AC 460F7380 add.s      $f14, $f14, $f15
001180B0 3C04C120 lui        $a0, 0xc120
001180B4 E7AC0038 swc1       $f12, 0x38($sp)
001180B8 46118300 add.s      $f12, $f16, $f17
001180BC E7B6006C swc1       $f22, 0x6c($sp)
001180C0 E7AE003C swc1       $f14, 0x3c($sp)
001180C4 02402825 move       $a1, $s2
001180C8 02203025 move       $a2, $s1
001180CC E7AC0040 swc1       $f12, 0x40($sp)
001180D0 44846000 mtc1       $a0, $f12
001180D4 02003825 move       $a3, $s0
001180D8 E7AC0070 swc1       $f12, 0x70($sp)
001180DC E7B60074 swc1       $f22, 0x74($sp)
001180E0 0C0184EE jal        0x613b8
001180E4 02602025 move       $a0, $s3
001180E8 10400007 beqz       $v0, 0x118108
001180EC 00000000 nop        
001180F0 3C070028 lui        $a3, 0x28
001180F4 02802025 move       $a0, $s4
001180F8 02602825 move       $a1, $s3
001180FC 02403025 move       $a2, $s2
00118100 0C018476 jal        0x611d8
00118104 C4EC2110 lwc1       $f12, 0x2110($a3)
00118108 93B20090 lbu        $s2, 0x90($sp)
0011810C 0C00A900 jal        0x2a400
00118110 02C02025 move       $a0, $s6
00118114 1040002A beqz       $v0, 0x1181c0
00118118 00000000 nop        
0011811C C6EC0014 lwc1       $f12, 0x14($s7)
00118120 46166032 c.eq.s     $f12, $f22
00118124 00000000 nop        
00118128 45000025 bc1f       0x1181c0
0011812C 00000000 nop        
00118130 0C0070C3 jal        0x1c30c
00118134 02C02025 move       $a0, $s6
00118138 10400021 beqz       $v0, 0x1181c0
0011813C 00000000 nop        
00118140 8FA40020 lw         $a0, 0x20($sp)
00118144 30840020 andi       $a0, $a0, 0x20
00118148 1080001D beqz       $a0, 0x1181c0
0011814C 00000000 nop        
00118150 93C40045 lbu        $a0, 0x45($fp)
00118154 10800003 beqz       $a0, 0x118164
00118158 34050005 ori        $a1, $zero, 5
0011815C 14850018 bne        $a0, $a1, 0x1181c0
00118160 00000000 nop        
00118164 26C400C0 addiu      $a0, $s6, 0xc0
00118168 8C840014 lw         $a0, 0x14($a0)
0011816C 30842000 andi       $a0, $a0, 0x2000
00118170 10800013 beqz       $a0, 0x1181c0
00118174 00000000 nop        
00118178 1640000E bnez       $s2, 0x1181b4
0011817C 00000000 nop        
00118180 0C00A99C jal        0x2a670
00118184 02C02025 move       $a0, $s6
00118188 3C06002A lui        $a2, 0x2a
0011818C C4CCE41C lwc1       $f12, -0x1be4($a2)
00118190 3C09002A lui        $t1, 0x2a
00118194 27A70038 addiu      $a3, $sp, 0x38
00118198 02C02025 move       $a0, $s6
0011819C 27A50028 addiu      $a1, $sp, 0x28
001181A0 93A80091 lbu        $t0, 0x91($sp)
001181A4 00403025 move       $a2, $v0
001181A8 0C00BB23 jal        0x2ec8c
001181AC 2529E420 addiu      $t1, $t1, -0x1be0
001181B0 0040A825 move       $s5, $v0
001181B4 03C02025 move       $a0, $fp
001181B8 0C045E8C jal        0x117a30
001181BC 02A02825 move       $a1, $s5
001181C0 C7B40094 lwc1       $f20, 0x94($sp)
001181C4 C7B60098 lwc1       $f22, 0x98($sp)
001181C8 8FB0009C lw         $s0, 0x9c($sp)
001181CC 8FB100A0 lw         $s1, 0xa0($sp)
001181D0 8FB200A4 lw         $s2, 0xa4($sp)
001181D4 8FB300A8 lw         $s3, 0xa8($sp)
001181D8 8FB400AC lw         $s4, 0xac($sp)
001181DC 8FB500B0 lw         $s5, 0xb0($sp)
001181E0 8FB600B4 lw         $s6, 0xb4($sp)
001181E4 8FB700B8 lw         $s7, 0xb8($sp)
001181E8 8FBE00BC lw         $fp, 0xbc($sp)
001181EC 8FBF00C0 lw         $ra, 0xc0($sp)
001181F0 03E00008 jr         $ra
001181F4 27BD00D0 addiu      $sp, $sp, 0xd0