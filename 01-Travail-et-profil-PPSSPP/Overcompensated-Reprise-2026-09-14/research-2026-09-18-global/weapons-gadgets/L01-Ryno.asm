
CALLBACK 0x001684AC end 0x00168588 ordinal 0

001684AC 27BDFFC0 addiu      $sp, $sp, -0x40
001684B0 AFB00020 sw         $s0, 0x20($sp)
001684B4 00808025 move       $s0, $a0
001684B8 AFB10024 sw         $s1, 0x24($sp)
001684BC AFB20028 sw         $s2, 0x28($sp)
001684C0 AFB3002C sw         $s3, 0x2c($sp)
001684C4 AFB40030 sw         $s4, 0x30($sp)
001684C8 AFBF0034 sw         $ra, 0x34($sp)
001684CC 8E140058 lw         $s4, 0x58($s0)
001684D0 3C11002B lui        $s1, 0x2b
001684D4 AE800000 sw         $zero, ($s4)
001684D8 AE800004 sw         $zero, 4($s4)
001684DC 34130000 ori        $s3, $zero, 0
001684E0 263128D8 addiu      $s1, $s1, 0x28d8
001684E4 26920008 addiu      $s2, $s4, 8
001684E8 02402025 move       $a0, $s2
001684EC 00002825 move       $a1, $zero
001684F0 34060044 ori        $a2, $zero, 0x44
001684F4 34070045 ori        $a3, $zero, 0x45
001684F8 0C019B8F jal        0x66e3c
001684FC 02204025 move       $t0, $s1
00168500 26730001 addiu      $s3, $s3, 1
00168504 2E640007 sltiu      $a0, $s3, 7
00168508 1480FFF7 bnez       $a0, 0x1684e8
0016850C 26520028 addiu      $s2, $s2, 0x28
00168510 A2800120 sb         $zero, 0x120($s4)
00168514 3C11002B lui        $s1, 0x2b
00168518 8E2400C0 lw         $a0, 0xc0($s1)
0016851C 3C05002D lui        $a1, 0x2d
00168520 C4AC6AB0 lwc1       $f12, 0x6ab0($a1)
00168524 3C05002D lui        $a1, 0x2d
00168528 C4AD6AB4 lwc1       $f13, 0x6ab4($a1)
0016852C 3C05002D lui        $a1, 0x2d
00168530 C4AE6AB8 lwc1       $f14, 0x6ab8($a1)
00168534 3C05002D lui        $a1, 0x2d
00168538 3C06002D lui        $a2, 0x2d
0016853C 34070001 ori        $a3, $zero, 1
00168540 24A56AA4 addiu      $a1, $a1, 0x6aa4
00168544 0C01707F jal        0x5c1fc
00168548 24C66A7C addiu      $a2, $a2, 0x6a7c
0016854C 8E2500C0 lw         $a1, 0xc0($s1)
00168550 26040074 addiu      $a0, $s0, 0x74
00168554 8CA600F0 lw         $a2, 0xf0($a1)
00168558 3405000F ori        $a1, $zero, 0xf
0016855C 0C0077E7 jal        0x1df9c
00168560 2407FFFF addiu      $a3, $zero, -1
00168564 34020001 ori        $v0, $zero, 1
00168568 8FB00020 lw         $s0, 0x20($sp)
0016856C 8FB10024 lw         $s1, 0x24($sp)
00168570 8FB20028 lw         $s2, 0x28($sp)
00168574 8FB3002C lw         $s3, 0x2c($sp)
00168578 8FB40030 lw         $s4, 0x30($sp)
0016857C 8FBF0034 lw         $ra, 0x34($sp)
00168580 03E00008 jr         $ra
00168584 27BD0040 addiu      $sp, $sp, 0x40

CALLBACK 0x00168588 end 0x00168590 ordinal 1

00168588 03E00008 jr         $ra
0016858C 00000000 nop        

CALLBACK 0x00168C28 end 0x00169338 ordinal 2

00168C28 27BDFED0 addiu      $sp, $sp, -0x130
00168C2C AFB7011C sw         $s7, 0x11c($sp)
00168C30 0080B825 move       $s7, $a0
00168C34 AFB20108 sw         $s2, 0x108($sp)
00168C38 8EF20058 lw         $s2, 0x58($s7)
00168C3C AFB3010C sw         $s3, 0x10c($sp)
00168C40 3404000F ori        $a0, $zero, 0xf
00168C44 8E530000 lw         $s3, ($s2)
00168C48 E7B400F4 swc1       $f20, 0xf4($sp)
00168C4C E7B600F8 swc1       $f22, 0xf8($sp)
00168C50 E7B800FC swc1       $f24, 0xfc($sp)
00168C54 AFB00100 sw         $s0, 0x100($sp)
00168C58 AFB10104 sw         $s1, 0x104($sp)
00168C5C AFB40110 sw         $s4, 0x110($sp)
00168C60 AFB50114 sw         $s5, 0x114($sp)
00168C64 AFB60118 sw         $s6, 0x118($sp)
00168C68 AFBE0120 sw         $fp, 0x120($sp)
00168C6C AFBF0124 sw         $ra, 0x124($sp)
00168C70 0C007DC7 jal        0x1f71c
00168C74 8E6500F0 lw         $a1, 0xf0($s3)
00168C78 34100000 ori        $s0, $zero, 0
00168C7C 0C00C41E jal        0x31078
00168C80 02602025 move       $a0, $s3
00168C84 3C11002D lui        $s1, 0x2d
00168C88 4480A000 mtc1       $zero, $f20
00168C8C 27B50058 addiu      $s5, $sp, 0x58
00168C90 10400006 beqz       $v0, 0x168cac
00168C94 26316A88 addiu      $s1, $s1, 0x6a88
00168C98 0C016FD5 jal        0x5bf54
00168C9C 02602025 move       $a0, $s3
00168CA0 10400002 beqz       $v0, 0x168cac
00168CA4 00000000 nop        
00168CA8 34100001 ori        $s0, $zero, 1
00168CAC 0220A025 move       $s4, $s1
00168CB0 321100FF andi       $s1, $s0, 0xff
00168CB4 27A40050 addiu      $a0, $sp, 0x50
00168CB8 0C00C4D4 jal        0x31350
00168CBC 02602825 move       $a1, $s3
00168CC0 0C00C4BD jal        0x312f4
00168CC4 02602025 move       $a0, $s3
00168CC8 8E6500F0 lw         $a1, 0xf0($s3)
00168CCC 00408025 move       $s0, $v0
00168CD0 0C007FEF jal        0x1ffbc
00168CD4 3404000F ori        $a0, $zero, 0xf
00168CD8 0040B025 move       $s6, $v0
00168CDC 3C06002D lui        $a2, 0x2d
00168CE0 A3B600F0 sb         $s6, 0xf0($sp)
00168CE4 02A02025 move       $a0, $s5
00168CE8 02E02825 move       $a1, $s7
00168CEC 0C03D4B1 jal        0xf52c4
00168CF0 24C66A7C addiu      $a2, $a2, 0x6a7c
00168CF4 C6EC0070 lwc1       $f12, 0x70($s7)
00168CF8 3C04BF80 lui        $a0, 0xbf80
00168CFC 44846800 mtc1       $a0, $f13
00168D00 460D6300 add.s      $f12, $f12, $f13
00168D04 00162080 sll        $a0, $s6, 2
00168D08 0094A021 addu       $s4, $a0, $s4
00168D0C 4614603C c.lt.s     $f12, $f20
00168D10 00000000 nop        
00168D14 45000002 bc1f       0x168d20
00168D18 E6EC0070 swc1       $f12, 0x70($s7)
00168D1C E6F40070 swc1       $f20, 0x70($s7)
00168D20 3C04002D lui        $a0, 0x2d
00168D24 8C846B60 lw         $a0, 0x6b60($a0)
00168D28 1080001A beqz       $a0, 0x168d94
00168D2C 00000000 nop        
00168D30 C6EC0070 lwc1       $f12, 0x70($s7)
00168D34 3C05002D lui        $a1, 0x2d
00168D38 C4AD6B64 lwc1       $f13, 0x6b64($a1)
00168D3C 460D603E c.le.s     $f12, $f13
00168D40 00000000 nop        
00168D44 45000013 bc1f       0x168d94
00168D48 00000000 nop        
00168D4C 92450120 lbu        $a1, 0x120($s2)
00168D50 10A00010 beqz       $a1, 0x168d94
00168D54 00000000 nop        
00168D58 1080000D beqz       $a0, 0x168d90
00168D5C 00802825 move       $a1, $a0
00168D60 C4AC0014 lwc1       $f12, 0x14($a1)
00168D64 C4AD0018 lwc1       $f13, 0x18($a1)
00168D68 C4AE001C lwc1       $f14, 0x1c($a1)
00168D6C C4AF0020 lwc1       $f15, 0x20($a1)
00168D70 34070000 ori        $a3, $zero, 0
00168D74 34090000 ori        $t1, $zero, 0
00168D78 340A0000 ori        $t2, $zero, 0
00168D7C 340B0001 ori        $t3, $zero, 1
00168D80 02E02025 move       $a0, $s7
00168D84 00003025 move       $a2, $zero
00168D88 0C01B147 jal        0x6c51c
00168D8C 00004025 move       $t0, $zero
00168D90 A2400120 sb         $zero, 0x120($s2)
00168D94 AFB200EC sw         $s2, 0xec($sp)
00168D98 8E440004 lw         $a0, 4($s2)
00168D9C 34050003 ori        $a1, $zero, 3
00168DA0 14850014 bne        $a0, $a1, 0x168df4
00168DA4 26040020 addiu      $a0, $s0, 0x20
00168DA8 AFB200EC sw         $s2, 0xec($sp)
00168DAC 02E02025 move       $a0, $s7
00168DB0 0C01AA82 jal        0x6aa08
00168DB4 00002825 move       $a1, $zero
00168DB8 1040000E beqz       $v0, 0x168df4
00168DBC 26040020 addiu      $a0, $s0, 0x20
00168DC0 AFB200EC sw         $s2, 0xec($sp)
00168DC4 4600A346 mov.s      $f13, $f20
00168DC8 3C083DCC lui        $t0, 0x3dcc
00168DCC A2E00045 sb         $zero, 0x45($s7)
00168DD0 3508CCCD ori        $t0, $t0, 0xcccd
00168DD4 AE400004 sw         $zero, 4($s2)
00168DD8 44886000 mtc1       $t0, $f12
00168DDC 02E02025 move       $a0, $s7
00168DE0 00002825 move       $a1, $zero
00168DE4 00003025 move       $a2, $zero
00168DE8 0C01AB54 jal        0x6ad50
00168DEC 34070001 ori        $a3, $zero, 1
00168DF0 26040020 addiu      $a0, $s0, 0x20
00168DF4 C48C0000 lwc1       $f12, ($a0)
00168DF8 AFB400E8 sw         $s4, 0xe8($sp)
00168DFC C48D0004 lwc1       $f13, 4($a0)
00168E00 44056000 mfc1       $a1, $f12
00168E04 C48E0008 lwc1       $f14, 8($a0)
00168E08 C48F000C lwc1       $f15, 0xc($a0)
00168E0C 44066800 mfc1       $a2, $f13
00168E10 AFA50064 sw         $a1, 0x64($sp)
00168E14 44047000 mfc1       $a0, $f14
00168E18 AFA60068 sw         $a2, 0x68($sp)
00168E1C 44057800 mfc1       $a1, $f15
00168E20 AFA4006C sw         $a0, 0x6c($sp)
00168E24 8E880000 lw         $t0, ($s4)
00168E28 AFA50070 sw         $a1, 0x70($sp)
00168E2C 3C09002D lui        $t1, 0x2d
00168E30 01002825 move       $a1, $t0
00168E34 C52C6A98 lwc1       $f12, 0x6a98($t1)
00168E38 3C0B002D lui        $t3, 0x2d
00168E3C 27A60074 addiu      $a2, $sp, 0x74
00168E40 27A70064 addiu      $a3, $sp, 0x64
00168E44 02602025 move       $a0, $s3
00168E48 02004025 move       $t0, $s0
00168E4C 02A04825 move       $t1, $s5
00168E50 02205025 move       $t2, $s1
00168E54 0C010CED jal        0x433b4
00168E58 256B6ADC addiu      $t3, $t3, 0x6adc
00168E5C 0040F025 move       $fp, $v0
00168E60 34120000 ori        $s2, $zero, 0
00168E64 025E202B sltu       $a0, $s2, $fp
00168E68 10800047 beqz       $a0, 0x168f88
00168E6C 3C043480 lui        $a0, 0x3480
00168E70 8FB000EC lw         $s0, 0xec($sp)
00168E74 4484C000 mtc1       $a0, $f24
00168E78 3C043F80 lui        $a0, 0x3f80
00168E7C 27B40090 addiu      $s4, $sp, 0x90
00168E80 4484B000 mtc1       $a0, $f22
00168E84 27B5009C addiu      $s5, $sp, 0x9c
00168E88 03A08825 move       $s1, $sp
00168E8C 26100008 addiu      $s0, $s0, 8
00168E90 3C160002 lui        $s6, 2
00168E94 8E240074 lw         $a0, 0x74($s1)
00168E98 02802825 move       $a1, $s4
00168E9C 34060001 ori        $a2, $zero, 1
00168EA0 0C01B0C6 jal        0x6c318
00168EA4 00003825 move       $a3, $zero
00168EA8 8E260074 lw         $a2, 0x74($s1)
00168EAC 02002025 move       $a0, $s0
00168EB0 34050001 ori        $a1, $zero, 1
00168EB4 0C0199E7 jal        0x6679c
00168EB8 34070001 ori        $a3, $zero, 1
00168EBC 02002025 move       $a0, $s0
00168EC0 02802825 move       $a1, $s4
00168EC4 0C019A07 jal        0x6681c
00168EC8 00003025 move       $a2, $zero
00168ECC 16400029 bnez       $s2, 0x168f74
00168ED0 00000000 nop        
00168ED4 0C016FE3 jal        0x5bf8c
00168ED8 02602025 move       $a0, $s3
00168EDC 8E64095C lw         $a0, 0x95c($s3)
00168EE0 02A02825 move       $a1, $s5
00168EE4 00962025 or         $a0, $a0, $s6
00168EE8 AE64095C sw         $a0, 0x95c($s3)
00168EEC 8FA40074 lw         $a0, 0x74($sp)
00168EF0 00003025 move       $a2, $zero
00168EF4 0C01B0C6 jal        0x6c318
00168EF8 00003825 move       $a3, $zero
00168EFC C7AC009C lwc1       $f12, 0x9c($sp)
00168F00 C66D0030 lwc1       $f13, 0x30($s3)
00168F04 C66E0034 lwc1       $f14, 0x34($s3)
00168F08 460D6301 sub.s      $f12, $f12, $f13
00168F0C C66F0038 lwc1       $f15, 0x38($s3)
00168F10 E66C02A8 swc1       $f12, 0x2a8($s3)
00168F14 C7B000A0 lwc1       $f16, 0xa0($sp)
00168F18 4600A346 mov.s      $f13, $f20
00168F1C 460E8381 sub.s      $f14, $f16, $f14
00168F20 460C6442 mul.s      $f17, $f12, $f12
00168F24 460D6C82 mul.s      $f18, $f13, $f13
00168F28 E66E02AC swc1       $f14, 0x2ac($s3)
00168F2C C7AE00A4 lwc1       $f14, 0xa4($sp)
00168F30 46128C40 add.s      $f17, $f17, $f18
00168F34 460F7381 sub.s      $f14, $f14, $f15
00168F38 E67402AC swc1       $f20, 0x2ac($s3)
00168F3C 460E73C2 mul.s      $f15, $f14, $f14
00168F40 460F8BC0 add.s      $f15, $f17, $f15
00168F44 4618783C c.lt.s     $f15, $f24
00168F48 00000000 nop        
00168F4C 45010009 bc1t       0x168f74
00168F50 E66E02B0 swc1       $f14, 0x2b0($s3)
00168F54 46007BC4 sqrt.s     $f15, $f15
00168F58 460FB3C3 div.s      $f15, $f22, $f15
00168F5C 460F6302 mul.s      $f12, $f12, $f15
00168F60 460F6B42 mul.s      $f13, $f13, $f15
00168F64 460F7382 mul.s      $f14, $f14, $f15
00168F68 E66C02A8 swc1       $f12, 0x2a8($s3)
00168F6C E66D02AC swc1       $f13, 0x2ac($s3)
00168F70 E66E02B0 swc1       $f14, 0x2b0($s3)
00168F74 26520001 addiu      $s2, $s2, 1
00168F78 26310004 addiu      $s1, $s1, 4
00168F7C 025E202B sltu       $a0, $s2, $fp
00168F80 1480FFC4 bnez       $a0, 0x168e94
00168F84 26100028 addiu      $s0, $s0, 0x28
00168F88 C6EC0070 lwc1       $f12, 0x70($s7)
00168F8C 46146032 c.eq.s     $f12, $f20
00168F90 00000000 nop        
00168F94 450000D9 bc1f       0x1692fc
00168F98 00000000 nop        
00168F9C 0C007956 jal        0x1e558
00168FA0 02602025 move       $a0, $s3
00168FA4 104000D5 beqz       $v0, 0x1692fc
00168FA8 00000000 nop        
00168FAC 8FA40050 lw         $a0, 0x50($sp)
00168FB0 30840020 andi       $a0, $a0, 0x20
00168FB4 108000D1 beqz       $a0, 0x1692fc
00168FB8 00000000 nop        
00168FBC 266400C0 addiu      $a0, $s3, 0xc0
00168FC0 8C840014 lw         $a0, 0x14($a0)
00168FC4 30842000 andi       $a0, $a0, 0x2000
00168FC8 108000CC beqz       $a0, 0x1692fc
00168FCC 00000000 nop        
00168FD0 8FA400E8 lw         $a0, 0xe8($sp)
00168FD4 3C06002D lui        $a2, 0x2d
00168FD8 8CC6C588 lw         $a2, -0x3a78($a2)
00168FDC 3C073F80 lui        $a3, 0x3f80
00168FE0 34050009 ori        $a1, $zero, 9
00168FE4 4487C000 mtc1       $a3, $f24
00168FE8 14C5000A bne        $a2, $a1, 0x169014
00168FEC 8C840000 lw         $a0, ($a0)
00168FF0 3C050009 lui        $a1, 9
00168FF4 24A5C928 addiu      $a1, $a1, -0x36d8
00168FF8 90A6000D lbu        $a2, 0xd($a1)
00168FFC 18C00005 blez       $a2, 0x169014
00169000 28C60040 slti       $a2, $a2, 0x40
00169004 10C00003 beqz       $a2, 0x169014
00169008 00000000 nop        
0016900C 34060080 ori        $a2, $zero, 0x80
00169010 A0A6000D sb         $a2, 0xd($a1)
00169014 34110000 ori        $s1, $zero, 0
00169018 0224202B sltu       $a0, $s1, $a0
0016901C 10800057 beqz       $a0, 0x16917c
00169020 00000000 nop        
00169024 93A400F0 lbu        $a0, 0xf0($sp)
00169028 00042900 sll        $a1, $a0, 4
0016902C 00852021 addu       $a0, $a0, $a1
00169030 00042080 sll        $a0, $a0, 2
00169034 00A49021 addu       $s2, $a1, $a0
00169038 3C04002D lui        $a0, 0x2d
0016903C 248469C8 addiu      $a0, $a0, 0x69c8
00169040 02449021 addu       $s2, $s2, $a0
00169044 3C043480 lui        $a0, 0x3480
00169048 27B300D0 addiu      $s3, $sp, 0xd0
0016904C 4484B000 mtc1       $a0, $f22
00169050 27B500DC addiu      $s5, $sp, 0xdc
00169054 27B400B4 addiu      $s4, $sp, 0xb4
00169058 03A08025 move       $s0, $sp
0016905C 8FB600E8 lw         $s6, 0xe8($sp)
00169060 02602025 move       $a0, $s3
00169064 02E02825 move       $a1, $s7
00169068 0C03D4B1 jal        0xf52c4
0016906C 02403025 move       $a2, $s2
00169070 023E202B sltu       $a0, $s1, $fp
00169074 10800030 beqz       $a0, 0x169138
00169078 00000000 nop        
0016907C 8E040074 lw         $a0, 0x74($s0)
00169080 02A02825 move       $a1, $s5
00169084 00003025 move       $a2, $zero
00169088 0C01B0C6 jal        0x6c318
0016908C 00003825 move       $a3, $zero
00169090 C7AC00DC lwc1       $f12, 0xdc($sp)
00169094 C7AD00D0 lwc1       $f13, 0xd0($sp)
00169098 C7AE00E0 lwc1       $f14, 0xe0($sp)
0016909C 460D6301 sub.s      $f12, $f12, $f13
001690A0 C7AD00D4 lwc1       $f13, 0xd4($sp)
001690A4 460C6402 mul.s      $f16, $f12, $f12
001690A8 C7AF00E4 lwc1       $f15, 0xe4($sp)
001690AC 460D7341 sub.s      $f13, $f14, $f13
001690B0 C7AE00D8 lwc1       $f14, 0xd8($sp)
001690B4 460D6C42 mul.s      $f17, $f13, $f13
001690B8 460E7B81 sub.s      $f14, $f15, $f14
001690BC E7AC00DC swc1       $f12, 0xdc($sp)
001690C0 46118400 add.s      $f16, $f16, $f17
001690C4 E7AD00E0 swc1       $f13, 0xe0($sp)
001690C8 460E73C2 mul.s      $f15, $f14, $f14
001690CC 460F83C0 add.s      $f15, $f16, $f15
001690D0 4616783C c.lt.s     $f15, $f22
001690D4 00000000 nop        
001690D8 45000008 bc1f       0x1690fc
001690DC E7AE00E4 swc1       $f14, 0xe4($sp)
001690E0 C7AC0064 lwc1       $f12, 0x64($sp)
001690E4 C7AD0068 lwc1       $f13, 0x68($sp)
001690E8 E7AC00B4 swc1       $f12, 0xb4($sp)
001690EC C7AC006C lwc1       $f12, 0x6c($sp)
001690F0 E7AD00B8 swc1       $f13, 0xb8($sp)
001690F4 10000009 b          0x16911c
001690F8 E7AC00BC swc1       $f12, 0xbc($sp)
001690FC 46007BC4 sqrt.s     $f15, $f15
00169100 460FC3C3 div.s      $f15, $f24, $f15
00169104 460C7B02 mul.s      $f12, $f15, $f12
00169108 460D7B42 mul.s      $f13, $f15, $f13
0016910C 460E7B82 mul.s      $f14, $f15, $f14
00169110 E7AC00B4 swc1       $f12, 0xb4($sp)
00169114 E7AD00B8 swc1       $f13, 0xb8($sp)
00169118 E7AE00BC swc1       $f14, 0xbc($sp)
0016911C 8E070074 lw         $a3, 0x74($s0)
00169120 02E02025 move       $a0, $s7
00169124 02602825 move       $a1, $s3
00169128 0C05A164 jal        0x168590
0016912C 02803025 move       $a2, $s4
00169130 1000000D b          0x169168
00169134 8EC40000 lw         $a0, ($s6)
00169138 C7AC0064 lwc1       $f12, 0x64($sp)
0016913C C7AD0068 lwc1       $f13, 0x68($sp)
00169140 E7AC00B4 swc1       $f12, 0xb4($sp)
00169144 C7AC006C lwc1       $f12, 0x6c($sp)
00169148 E7AD00B8 swc1       $f13, 0xb8($sp)
0016914C E7AC00BC swc1       $f12, 0xbc($sp)
00169150 02E02025 move       $a0, $s7
00169154 02602825 move       $a1, $s3
00169158 02803025 move       $a2, $s4
0016915C 0C05A164 jal        0x168590
00169160 00003825 move       $a3, $zero
00169164 8EC40000 lw         $a0, ($s6)
00169168 26310001 addiu      $s1, $s1, 1
0016916C 2652000C addiu      $s2, $s2, 0xc
00169170 0224202B sltu       $a0, $s1, $a0
00169174 1480FFBA bnez       $a0, 0x169060
00169178 26100004 addiu      $s0, $s0, 4
0016917C 27A50058 addiu      $a1, $sp, 0x58
00169180 0C03467E jal        0xd19f8
00169184 3404001E ori        $a0, $zero, 0x1e
00169188 C7AC0058 lwc1       $f12, 0x58($sp)
0016918C C7AD005C lwc1       $f13, 0x5c($sp)
00169190 E7AC00C0 swc1       $f12, 0xc0($sp)
00169194 C7AC0060 lwc1       $f12, 0x60($sp)
00169198 E7AD00C4 swc1       $f13, 0xc4($sp)
0016919C E7AC00C8 swc1       $f12, 0xc8($sp)
001691A0 E7B800CC swc1       $f24, 0xcc($sp)
001691A4 3C13002D lui        $s3, 0x2d
001691A8 34020000 ori        $v0, $zero, 0
001691AC 8E676A70 lw         $a3, 0x6a70($s3)
001691B0 AFA20000 sw         $v0, ($sp)
001691B4 3C14002D lui        $s4, 0x2d
001691B8 3C023E80 lui        $v0, 0x3e80
001691BC C68E6AC8 lwc1       $f14, 0x6ac8($s4)
001691C0 4482B000 mtc1       $v0, $f22
001691C4 3C15002D lui        $s5, 0x2d
001691C8 4600A346 mov.s      $f13, $f20
001691CC C6AC6AC4 lwc1       $f12, 0x6ac4($s5)
001691D0 461673C2 mul.s      $f15, $f14, $f22
001691D4 3C023FC0 lui        $v0, 0x3fc0
001691D8 4600C486 mov.s      $f18, $f24
001691DC 44828000 mtc1       $v0, $f16
001691E0 3C04002D lui        $a0, 0x2d
001691E4 46106302 mul.s      $f12, $f12, $f16
001691E8 34100001 ori        $s0, $zero, 1
001691EC 27B100C0 addiu      $s1, $sp, 0xc0
001691F0 4600A4C6 mov.s      $f19, $f20
001691F4 2492A368 addiu      $s2, $a0, -0x5c98
001691F8 3C16002D lui        $s6, 0x2d
001691FC 3C023F00 lui        $v0, 0x3f00
00169200 340B0000 ori        $t3, $zero, 0
00169204 44828000 mtc1       $v0, $f16
00169208 00002025 move       $a0, $zero
0016920C 02202825 move       $a1, $s1
00169210 02403025 move       $a2, $s2
00169214 34080001 ori        $t0, $zero, 1
00169218 34090034 ori        $t1, $zero, 0x34
0016921C 02005025 move       $t2, $s0
00169220 0C03297A jal        0xca5e8
00169224 C6D16ACC lwc1       $f17, 0x6acc($s6)
00169228 C68E6AC8 lwc1       $f14, 0x6ac8($s4)
0016922C 3C043F99 lui        $a0, 0x3f99
00169230 4600C486 mov.s      $f18, $f24
00169234 C6AC6AC4 lwc1       $f12, 0x6ac4($s5)
00169238 461673C2 mul.s      $f15, $f14, $f22
0016923C 3484999A ori        $a0, $a0, 0x999a
00169240 4600A4C6 mov.s      $f19, $f20
00169244 44846800 mtc1       $a0, $f13
00169248 26736A70 addiu      $s3, $s3, 0x6a70
0016924C 460D6302 mul.s      $f12, $f12, $f13
00169250 C6D16ACC lwc1       $f17, 0x6acc($s6)
00169254 8E670004 lw         $a3, 4($s3)
00169258 34020000 ori        $v0, $zero, 0
0016925C AFA20000 sw         $v0, ($sp)
00169260 3C02BF00 lui        $v0, 0xbf00
00169264 4600A346 mov.s      $f13, $f20
00169268 340B0000 ori        $t3, $zero, 0
0016926C 44828000 mtc1       $v0, $f16
00169270 00002025 move       $a0, $zero
00169274 02202825 move       $a1, $s1
00169278 02403025 move       $a2, $s2
0016927C 34080001 ori        $t0, $zero, 1
00169280 34090025 ori        $t1, $zero, 0x25
00169284 0C03297A jal        0xca5e8
00169288 02005025 move       $t2, $s0
0016928C C6AC6AC4 lwc1       $f12, 0x6ac4($s5)
00169290 4600A346 mov.s      $f13, $f20
00169294 C68E6AC8 lwc1       $f14, 0x6ac8($s4)
00169298 4600C486 mov.s      $f18, $f24
0016929C C6D16ACC lwc1       $f17, 0x6acc($s6)
001692A0 4600A4C6 mov.s      $f19, $f20
001692A4 3C033E4C lui        $v1, 0x3e4c
001692A8 461673C2 mul.s      $f15, $f14, $f22
001692AC 8E670008 lw         $a3, 8($s3)
001692B0 34020000 ori        $v0, $zero, 0
001692B4 3463CCCD ori        $v1, $v1, 0xcccd
001692B8 340B0000 ori        $t3, $zero, 0
001692BC 44838000 mtc1       $v1, $f16
001692C0 00002025 move       $a0, $zero
001692C4 02202825 move       $a1, $s1
001692C8 02403025 move       $a2, $s2
001692CC 34080001 ori        $t0, $zero, 1
001692D0 34090034 ori        $t1, $zero, 0x34
001692D4 02005025 move       $t2, $s0
001692D8 0C03297A jal        0xca5e8
001692DC AFA20000 sw         $v0, ($sp)
001692E0 93A400F0 lbu        $a0, 0xf0($sp)
001692E4 10800003 beqz       $a0, 0x1692f4
001692E8 00000000 nop        
001692EC 0C05A214 jal        0x168850
001692F0 02E02025 move       $a0, $s7
001692F4 0C05A29B jal        0x168a6c
001692F8 02E02025 move       $a0, $s7
001692FC C7B400F4 lwc1       $f20, 0xf4($sp)
00169300 C7B600F8 lwc1       $f22, 0xf8($sp)
00169304 C7B800FC lwc1       $f24, 0xfc($sp)
00169308 8FB00100 lw         $s0, 0x100($sp)
0016930C 8FB10104 lw         $s1, 0x104($sp)
00169310 8FB20108 lw         $s2, 0x108($sp)
00169314 8FB3010C lw         $s3, 0x10c($sp)
00169318 8FB40110 lw         $s4, 0x110($sp)
0016931C 8FB50114 lw         $s5, 0x114($sp)
00169320 8FB60118 lw         $s6, 0x118($sp)
00169324 8FB7011C lw         $s7, 0x11c($sp)
00169328 8FBE0120 lw         $fp, 0x120($sp)
0016932C 8FBF0124 lw         $ra, 0x124($sp)
00169330 03E00008 jr         $ra
00169334 27BD0130 addiu      $sp, $sp, 0x130