
CALLBACK 0x00139160 end 0x00139168 ordinal 0

00139160 03E00008 jr         $ra
00139164 34020001 ori        $v0, $zero, 1

CALLBACK 0x00139168 end 0x001391C0 ordinal 1

00139168 27BDFFE0 addiu      $sp, $sp, -0x20
0013916C AFB00010 sw         $s0, 0x10($sp)
00139170 00808025 move       $s0, $a0
00139174 AFB10014 sw         $s1, 0x14($sp)
00139178 8E110058 lw         $s1, 0x58($s0)
0013917C 26050030 addiu      $a1, $s0, 0x30
00139180 AFBF0018 sw         $ra, 0x18($sp)
00139184 0C0327CD jal        0xc9f34
00139188 34040016 ori        $a0, $zero, 0x16
0013918C 8E240008 lw         $a0, 8($s1)
00139190 0C04EBEA jal        0x13afa8
00139194 02002825 move       $a1, $s0
00139198 8E24000C lw         $a0, 0xc($s1)
0013919C 10800003 beqz       $a0, 0x1391ac
001391A0 00000000 nop        
001391A4 0C0192FF jal        0x64bfc
001391A8 34050001 ori        $a1, $zero, 1
001391AC 8FB00010 lw         $s0, 0x10($sp)
001391B0 8FB10014 lw         $s1, 0x14($sp)
001391B4 8FBF0018 lw         $ra, 0x18($sp)
001391B8 03E00008 jr         $ra
001391BC 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x001399B0 end 0x00139FDC ordinal 2

001399B0 27BDFEC0 addiu      $sp, $sp, -0x140
001399B4 AFB10128 sw         $s1, 0x128($sp)
001399B8 8C910058 lw         $s1, 0x58($a0)
001399BC 90850045 lbu        $a1, 0x45($a0)
001399C0 E7B40120 swc1       $f20, 0x120($sp)
001399C4 28A50002 slti       $a1, $a1, 2
001399C8 AFB00124 sw         $s0, 0x124($sp)
001399CC AFB2012C sw         $s2, 0x12c($sp)
001399D0 AFBF0130 sw         $ra, 0x130($sp)
001399D4 14A00017 bnez       $a1, 0x139a34
001399D8 00808025 move       $s0, $a0
001399DC C60C0070 lwc1       $f12, 0x70($s0)
001399E0 44806800 mtc1       $zero, $f13
001399E4 3C04BF80 lui        $a0, 0xbf80
001399E8 44847000 mtc1       $a0, $f14
001399EC 460E6300 add.s      $f12, $f12, $f14
001399F0 460D603E c.le.s     $f12, $f13
001399F4 00000000 nop        
001399F8 45010009 bc1t       0x139a20
001399FC E60C0070 swc1       $f12, 0x70($s0)
00139A00 C62C0010 lwc1       $f12, 0x10($s1)
00139A04 44806800 mtc1       $zero, $f13
00139A08 460D6032 c.eq.s     $f12, $f13
00139A0C 00000000 nop        
00139A10 4500000C bc1f       0x139a44
00139A14 00000000 nop        
00139A18 10000015 b          0x139a70
00139A1C 00000000 nop        
00139A20 02002025 move       $a0, $s0
00139A24 0C0192FF jal        0x64bfc
00139A28 34050001 ori        $a1, $zero, 1
00139A2C 10000164 b          0x139fc0
00139A30 00000000 nop        
00139A34 0C04E5C2 jal        0x139708
00139A38 02002025 move       $a0, $s0
00139A3C 10000160 b          0x139fc0
00139A40 00000000 nop        
00139A44 C62C0010 lwc1       $f12, 0x10($s1)
00139A48 44806800 mtc1       $zero, $f13
00139A4C 3C04BF80 lui        $a0, 0xbf80
00139A50 44847000 mtc1       $a0, $f14
00139A54 460E6300 add.s      $f12, $f12, $f14
00139A58 460D603C c.lt.s     $f12, $f13
00139A5C 00000000 nop        
00139A60 45000003 bc1f       0x139a70
00139A64 E62C0010 swc1       $f12, 0x10($s1)
00139A68 44806000 mtc1       $zero, $f12
00139A6C E62C0010 swc1       $f12, 0x10($s1)
00139A70 92040045 lbu        $a0, 0x45($s0)
00139A74 34050004 ori        $a1, $zero, 4
00139A78 14850075 bne        $a0, $a1, 0x139c50
00139A7C 00000000 nop        
00139A80 8E240004 lw         $a0, 4($s1)
00139A84 27A50020 addiu      $a1, $sp, 0x20
00139A88 00003025 move       $a2, $zero
00139A8C 0C019ACE jal        0x66b38
00139A90 00003825 move       $a3, $zero
00139A94 3C043F80 lui        $a0, 0x3f80
00139A98 44846000 mtc1       $a0, $f12
00139A9C 34120000 ori        $s2, $zero, 0
00139AA0 2E44000A sltiu      $a0, $s2, 0xa
00139AA4 10800067 beqz       $a0, 0x139c44
00139AA8 E7AC002C swc1       $f12, 0x2c($sp)
00139AAC 0C060057 jal        0x18015c
00139AB0 00000000 nop        
00139AB4 44826000 mtc1       $v0, $f12
00139AB8 3C043000 lui        $a0, 0x3000
00139ABC 46806320 cvt.s.w    $f12, $f12
00139AC0 44846800 mtc1       $a0, $f13
00139AC4 3C044000 lui        $a0, 0x4000
00139AC8 44847000 mtc1       $a0, $f14
00139ACC 460D6302 mul.s      $f12, $f12, $f13
00139AD0 3C044049 lui        $a0, 0x4049
00139AD4 34840FDB ori        $a0, $a0, 0xfdb
00139AD8 44847800 mtc1       $a0, $f15
00139ADC 460E6302 mul.s      $f12, $f12, $f14
00139AE0 460F6502 mul.s      $f20, $f12, $f15
00139AE4 0C05DEE8 jal        0x177ba0
00139AE8 4600A306 mov.s      $f12, $f20
00139AEC E7A00030 swc1       $f0, 0x30($sp)
00139AF0 0C05DF32 jal        0x177cc8
00139AF4 4600A306 mov.s      $f12, $f20
00139AF8 3C04002A lui        $a0, 0x2a
00139AFC 44806800 mtc1       $zero, $f13
00139B00 C48E1F40 lwc1       $f14, 0x1f40($a0)
00139B04 C7AC0030 lwc1       $f12, 0x30($sp)
00139B08 460E7380 add.s      $f14, $f14, $f14
00139B0C C7AF0020 lwc1       $f15, 0x20($sp)
00139B10 C7B00024 lwc1       $f16, 0x24($sp)
00139B14 E7A00038 swc1       $f0, 0x38($sp)
00139B18 E7AD0034 swc1       $f13, 0x34($sp)
00139B1C 460E6302 mul.s      $f12, $f12, $f14
00139B20 C7B10028 lwc1       $f17, 0x28($sp)
00139B24 460E6B42 mul.s      $f13, $f13, $f14
00139B28 E7AF003C swc1       $f15, 0x3c($sp)
00139B2C 460C7B00 add.s      $f12, $f15, $f12
00139B30 460E0382 mul.s      $f14, $f0, $f14
00139B34 460D8340 add.s      $f13, $f16, $f13
00139B38 27A4003C addiu      $a0, $sp, 0x3c
00139B3C E7AC0030 swc1       $f12, 0x30($sp)
00139B40 460F63C1 sub.s      $f15, $f12, $f15
00139B44 460E8B80 add.s      $f14, $f17, $f14
00139B48 E7AD0034 swc1       $f13, 0x34($sp)
00139B4C 46106C81 sub.s      $f18, $f13, $f16
00139B50 27A50060 addiu      $a1, $sp, 0x60
00139B54 E7AE0038 swc1       $f14, 0x38($sp)
00139B58 461174C1 sub.s      $f19, $f14, $f17
00139B5C E7B00040 swc1       $f16, 0x40($sp)
00139B60 E7B10044 swc1       $f17, 0x44($sp)
00139B64 E7AC0048 swc1       $f12, 0x48($sp)
00139B68 E7AD004C swc1       $f13, 0x4c($sp)
00139B6C E7AE0050 swc1       $f14, 0x50($sp)
00139B70 E7AF0054 swc1       $f15, 0x54($sp)
00139B74 E7B20058 swc1       $f18, 0x58($sp)
00139B78 0C037664 jal        0xdd990
00139B7C E7B3005C swc1       $f19, 0x5c($sp)
00139B80 2404FFFF addiu      $a0, $zero, -1
00139B84 10440003 beq        $v0, $a0, 0x139b94
00139B88 00000000 nop        
00139B8C 10000029 b          0x139c34
00139B90 00000000 nop        
00139B94 3C040006 lui        $a0, 6
00139B98 C7AC0034 lwc1       $f12, 0x34($sp)
00139B9C 2484E2A8 addiu      $a0, $a0, -0x1d58
00139BA0 C48D000C lwc1       $f13, 0xc($a0)
00139BA4 27A40064 addiu      $a0, $sp, 0x64
00139BA8 460D6301 sub.s      $f12, $f12, $f13
00139BAC 27A50068 addiu      $a1, $sp, 0x68
00139BB0 27A60030 addiu      $a2, $sp, 0x30
00139BB4 34070038 ori        $a3, $zero, 0x38
00139BB8 0C0063F5 jal        0x18fd4
00139BBC 00004025 move       $t0, $zero
00139BC0 1040001C beqz       $v0, 0x139c34
00139BC4 00000000 nop        
00139BC8 C7AC0064 lwc1       $f12, 0x64($sp)
00139BCC 3C04002A lui        $a0, 0x2a
00139BD0 C48D1F44 lwc1       $f13, 0x1f44($a0)
00139BD4 3C04002A lui        $a0, 0x2a
00139BD8 460C6B01 sub.s      $f12, $f13, $f12
00139BDC C48E9B10 lwc1       $f14, -0x64f0($a0)
00139BE0 24849B10 addiu      $a0, $a0, -0x64f0
00139BE4 C7AF0030 lwc1       $f15, 0x30($sp)
00139BE8 C4900004 lwc1       $f16, 4($a0)
00139BEC 460C7382 mul.s      $f14, $f14, $f12
00139BF0 C7B10034 lwc1       $f17, 0x34($sp)
00139BF4 460C8342 mul.s      $f13, $f16, $f12
00139BF8 C4920008 lwc1       $f18, 8($a0)
00139BFC C7B30038 lwc1       $f19, 0x38($sp)
00139C00 460E7B80 add.s      $f14, $f15, $f14
00139C04 460C9302 mul.s      $f12, $f18, $f12
00139C08 460D8B40 add.s      $f13, $f17, $f13
00139C0C 34040003 ori        $a0, $zero, 3
00139C10 E7AE0030 swc1       $f14, 0x30($sp)
00139C14 460C9B00 add.s      $f12, $f19, $f12
00139C18 E7AD0034 swc1       $f13, 0x34($sp)
00139C1C E60E0030 swc1       $f14, 0x30($s0)
00139C20 E7AC0038 swc1       $f12, 0x38($sp)
00139C24 E60D0034 swc1       $f13, 0x34($s0)
00139C28 E60C0038 swc1       $f12, 0x38($s0)
00139C2C 100000E4 b          0x139fc0
00139C30 A2040045 sb         $a0, 0x45($s0)
00139C34 26520001 addiu      $s2, $s2, 1
00139C38 2E44000A sltiu      $a0, $s2, 0xa
00139C3C 1480FF9B bnez       $a0, 0x139aac
00139C40 00000000 nop        
00139C44 34040002 ori        $a0, $zero, 2
00139C48 10000013 b          0x139c98
00139C4C A2040045 sb         $a0, 0x45($s0)
00139C50 8E240004 lw         $a0, 4($s1)
00139C54 10800005 beqz       $a0, 0x139c6c
00139C58 00000000 nop        
00139C5C 0C04E5B4 jal        0x1396d0
00139C60 02002025 move       $a0, $s0
00139C64 14400015 bnez       $v0, 0x139cbc
00139C68 00000000 nop        
00139C6C 34040002 ori        $a0, $zero, 2
00139C70 A2040045 sb         $a0, 0x45($s0)
00139C74 8E240008 lw         $a0, 8($s1)
00139C78 3C05002A lui        $a1, 0x2a
00139C7C C4AC1F0C lwc1       $f12, 0x1f0c($a1)
00139C80 3C05002A lui        $a1, 0x2a
00139C84 C4AD1F40 lwc1       $f13, 0x1f40($a1)
00139C88 0C04EB27 jal        0x13ac9c
00139C8C 02002825 move       $a1, $s0
00139C90 14400007 bnez       $v0, 0x139cb0
00139C94 AE220004 sw         $v0, 4($s1)
00139C98 92040045 lbu        $a0, 0x45($s0)
00139C9C 34050002 ori        $a1, $zero, 2
00139CA0 10850063 beq        $a0, $a1, 0x139e30
00139CA4 00000000 nop        
00139CA8 100000C5 b          0x139fc0
00139CAC 00000000 nop        
00139CB0 34040003 ori        $a0, $zero, 3
00139CB4 100000C2 b          0x139fc0
00139CB8 A2040045 sb         $a0, 0x45($s0)
00139CBC 34040003 ori        $a0, $zero, 3
00139CC0 A2040045 sb         $a0, 0x45($s0)
00139CC4 27B20080 addiu      $s2, $sp, 0x80
00139CC8 8E240004 lw         $a0, 4($s1)
00139CCC 02402825 move       $a1, $s2
00139CD0 00003025 move       $a2, $zero
00139CD4 0C019ACE jal        0x66b38
00139CD8 00003825 move       $a3, $zero
00139CDC 3C043F80 lui        $a0, 0x3f80
00139CE0 44846000 mtc1       $a0, $f12
00139CE4 3C05002A lui        $a1, 0x2a
00139CE8 E7AC008C swc1       $f12, 0x8c($sp)
00139CEC C4AC1F18 lwc1       $f12, 0x1f18($a1)
00139CF0 3C05002A lui        $a1, 0x2a
00139CF4 C4AD1F20 lwc1       $f13, 0x1f20($a1)
00139CF8 02002025 move       $a0, $s0
00139CFC 0C04E470 jal        0x1391c0
00139D00 02402825 move       $a1, $s2
00139D04 14400048 bnez       $v0, 0x139e28
00139D08 00000000 nop        
00139D0C C62C0010 lwc1       $f12, 0x10($s1)
00139D10 44806800 mtc1       $zero, $f13
00139D14 460D6032 c.eq.s     $f12, $f13
00139D18 00000000 nop        
00139D1C 45000042 bc1f       0x139e28
00139D20 00000000 nop        
00139D24 C60C0020 lwc1       $f12, 0x20($s0)
00139D28 C60D0024 lwc1       $f13, 0x24($s0)
00139D2C E7AC00B0 swc1       $f12, 0xb0($sp)
00139D30 C60C0028 lwc1       $f12, 0x28($s0)
00139D34 E7AD00B4 swc1       $f13, 0xb4($sp)
00139D38 C60D002C lwc1       $f13, 0x2c($s0)
00139D3C E7AC00B8 swc1       $f12, 0xb8($sp)
00139D40 C60C0000 lwc1       $f12, ($s0)
00139D44 E7AD00BC swc1       $f13, 0xbc($sp)
00139D48 C60D0004 lwc1       $f13, 4($s0)
00139D4C E7AC0090 swc1       $f12, 0x90($sp)
00139D50 C60C0008 lwc1       $f12, 8($s0)
00139D54 E7AD0094 swc1       $f13, 0x94($sp)
00139D58 C60D000C lwc1       $f13, 0xc($s0)
00139D5C E7AC0098 swc1       $f12, 0x98($sp)
00139D60 C60C0010 lwc1       $f12, 0x10($s0)
00139D64 E7AD009C swc1       $f13, 0x9c($sp)
00139D68 C60D0014 lwc1       $f13, 0x14($s0)
00139D6C E7AC00A0 swc1       $f12, 0xa0($sp)
00139D70 C60C0018 lwc1       $f12, 0x18($s0)
00139D74 E7AD00A4 swc1       $f13, 0xa4($sp)
00139D78 C60D001C lwc1       $f13, 0x1c($s0)
00139D7C E7AC00A8 swc1       $f12, 0xa8($sp)
00139D80 C60C0030 lwc1       $f12, 0x30($s0)
00139D84 E7AD00AC swc1       $f13, 0xac($sp)
00139D88 C60D0034 lwc1       $f13, 0x34($s0)
00139D8C E7AC00C0 swc1       $f12, 0xc0($sp)
00139D90 C60C0038 lwc1       $f12, 0x38($s0)
00139D94 E7AD00C4 swc1       $f13, 0xc4($sp)
00139D98 C60D003C lwc1       $f13, 0x3c($s0)
00139D9C E7AC00C8 swc1       $f12, 0xc8($sp)
00139DA0 3C06002A lui        $a2, 0x2a
00139DA4 E7AD00CC swc1       $f13, 0xcc($sp)
00139DA8 27A400C0 addiu      $a0, $sp, 0xc0
00139DAC 02002825 move       $a1, $s0
00139DB0 0C03AF43 jal        0xebd0c
00139DB4 24C61F28 addiu      $a2, $a2, 0x1f28
00139DB8 8E250000 lw         $a1, ($s1)
00139DBC 3404000E ori        $a0, $zero, 0xe
00139DC0 0C007769 jal        0x1dda4
00139DC4 8CA500F0 lw         $a1, 0xf0($a1)
00139DC8 10400008 beqz       $v0, 0x139dec
00139DCC 00000000 nop        
00139DD0 8E250000 lw         $a1, ($s1)
00139DD4 3C06002A lui        $a2, 0x2a
00139DD8 27A40090 addiu      $a0, $sp, 0x90
00139DDC 0C04EC2D jal        0x13b0b4
00139DE0 C4CC1F00 lwc1       $f12, 0x1f00($a2)
00139DE4 10000006 b          0x139e00
00139DE8 00000000 nop        
00139DEC 8E250000 lw         $a1, ($s1)
00139DF0 3C06002A lui        $a2, 0x2a
00139DF4 27A40090 addiu      $a0, $sp, 0x90
00139DF8 0C03F29E jal        0xfca78
00139DFC C4CC1F00 lwc1       $f12, 0x1f00($a2)
00139E00 3C04002A lui        $a0, 0x2a
00139E04 C48C1F08 lwc1       $f12, 0x1f08($a0)
00139E08 8E24001C lw         $a0, 0x1c($s1)
00139E0C 14800006 bnez       $a0, 0x139e28
00139E10 E62C0010 swc1       $f12, 0x10($s1)
00139E14 02002025 move       $a0, $s0
00139E18 0C0192FF jal        0x64bfc
00139E1C 34050001 ori        $a1, $zero, 1
00139E20 10000067 b          0x139fc0
00139E24 00000000 nop        
00139E28 10000065 b          0x139fc0
00139E2C 00000000 nop        
00139E30 92040046 lbu        $a0, 0x46($s0)
00139E34 5C800005 bgtzl      $a0, 0x139e4c
00139E38 28840002 slti       $a0, $a0, 2
00139E3C 04800060 bltz       $a0, 0x139fc0
00139E40 00000000 nop        
00139E44 10000053 b          0x139f94
00139E48 00000000 nop        
00139E4C 1080005C beqz       $a0, 0x139fc0
00139E50 00000000 nop        
00139E54 C62C0020 lwc1       $f12, 0x20($s1)
00139E58 3C043F80 lui        $a0, 0x3f80
00139E5C E7AC00D0 swc1       $f12, 0xd0($sp)
00139E60 C62C0024 lwc1       $f12, 0x24($s1)
00139E64 E7AC00D4 swc1       $f12, 0xd4($sp)
00139E68 44846000 mtc1       $a0, $f12
00139E6C C62D0028 lwc1       $f13, 0x28($s1)
00139E70 E7AC00DC swc1       $f12, 0xdc($sp)
00139E74 E7AD00D8 swc1       $f13, 0xd8($sp)
00139E78 3C04002A lui        $a0, 0x2a
00139E7C C48C1F1C lwc1       $f12, 0x1f1c($a0)
00139E80 3C04002A lui        $a0, 0x2a
00139E84 C48D1F24 lwc1       $f13, 0x1f24($a0)
00139E88 27A500D0 addiu      $a1, $sp, 0xd0
00139E8C 0C04E470 jal        0x1391c0
00139E90 02002025 move       $a0, $s0
00139E94 1440003D bnez       $v0, 0x139f8c
00139E98 00000000 nop        
00139E9C C60C0020 lwc1       $f12, 0x20($s0)
00139EA0 C60D0024 lwc1       $f13, 0x24($s0)
00139EA4 E7AC0100 swc1       $f12, 0x100($sp)
00139EA8 C60C0028 lwc1       $f12, 0x28($s0)
00139EAC E7AD0104 swc1       $f13, 0x104($sp)
00139EB0 C60D002C lwc1       $f13, 0x2c($s0)
00139EB4 E7AC0108 swc1       $f12, 0x108($sp)
00139EB8 C60C0000 lwc1       $f12, ($s0)
00139EBC E7AD010C swc1       $f13, 0x10c($sp)
00139EC0 C60D0004 lwc1       $f13, 4($s0)
00139EC4 E7AC00E0 swc1       $f12, 0xe0($sp)
00139EC8 C60C0008 lwc1       $f12, 8($s0)
00139ECC E7AD00E4 swc1       $f13, 0xe4($sp)
00139ED0 C60D000C lwc1       $f13, 0xc($s0)
00139ED4 E7AC00E8 swc1       $f12, 0xe8($sp)
00139ED8 C60C0010 lwc1       $f12, 0x10($s0)
00139EDC E7AD00EC swc1       $f13, 0xec($sp)
00139EE0 C60D0014 lwc1       $f13, 0x14($s0)
00139EE4 E7AC00F0 swc1       $f12, 0xf0($sp)
00139EE8 C60C0018 lwc1       $f12, 0x18($s0)
00139EEC E7AD00F4 swc1       $f13, 0xf4($sp)
00139EF0 C60D001C lwc1       $f13, 0x1c($s0)
00139EF4 E7AC00F8 swc1       $f12, 0xf8($sp)
00139EF8 C60C0030 lwc1       $f12, 0x30($s0)
00139EFC E7AD00FC swc1       $f13, 0xfc($sp)
00139F00 C60D0034 lwc1       $f13, 0x34($s0)
00139F04 E7AC0110 swc1       $f12, 0x110($sp)
00139F08 C60C0038 lwc1       $f12, 0x38($s0)
00139F0C E7AD0114 swc1       $f13, 0x114($sp)
00139F10 C60D003C lwc1       $f13, 0x3c($s0)
00139F14 E7AC0118 swc1       $f12, 0x118($sp)
00139F18 3C06002A lui        $a2, 0x2a
00139F1C E7AD011C swc1       $f13, 0x11c($sp)
00139F20 27A40110 addiu      $a0, $sp, 0x110
00139F24 02002825 move       $a1, $s0
00139F28 0C03AF43 jal        0xebd0c
00139F2C 24C61F28 addiu      $a2, $a2, 0x1f28
00139F30 8E250000 lw         $a1, ($s1)
00139F34 3C06002A lui        $a2, 0x2a
00139F38 27A400E0 addiu      $a0, $sp, 0xe0
00139F3C 0C04EC2D jal        0x13b0b4
00139F40 C4CC1F00 lwc1       $f12, 0x1f00($a2)
00139F44 3C04002A lui        $a0, 0x2a
00139F48 C48C1F38 lwc1       $f12, 0x1f38($a0)
00139F4C 3C12002A lui        $s2, 0x2a
00139F50 C64D1F3C lwc1       $f13, 0x1f3c($s2)
00139F54 0C060057 jal        0x18015c
00139F58 460D6501 sub.s      $f20, $f12, $f13
00139F5C 44827000 mtc1       $v0, $f14
00139F60 3C043000 lui        $a0, 0x3000
00139F64 468073A0 cvt.s.w    $f14, $f14
00139F68 44847800 mtc1       $a0, $f15
00139F6C C6501F3C lwc1       $f16, 0x1f3c($s2)
00139F70 02002025 move       $a0, $s0
00139F74 460F7302 mul.s      $f12, $f14, $f15
00139F78 46146302 mul.s      $f12, $f12, $f20
00139F7C 460C8300 add.s      $f12, $f16, $f12
00139F80 0C04E579 jal        0x1395e4
00139F84 E62C002C swc1       $f12, 0x2c($s1)
00139F88 A2000046 sb         $zero, 0x46($s0)
00139F8C 1000000C b          0x139fc0
00139F90 00000000 nop        
00139F94 C62C002C lwc1       $f12, 0x2c($s1)
00139F98 44806800 mtc1       $zero, $f13
00139F9C 3C04BF80 lui        $a0, 0xbf80
00139FA0 44847000 mtc1       $a0, $f14
00139FA4 460E6300 add.s      $f12, $f12, $f14
00139FA8 460D603E c.le.s     $f12, $f13
00139FAC 00000000 nop        
00139FB0 45000003 bc1f       0x139fc0
00139FB4 E62C002C swc1       $f12, 0x2c($s1)
00139FB8 34040001 ori        $a0, $zero, 1
00139FBC A2040046 sb         $a0, 0x46($s0)
00139FC0 C7B40120 lwc1       $f20, 0x120($sp)
00139FC4 8FB00124 lw         $s0, 0x124($sp)
00139FC8 8FB10128 lw         $s1, 0x128($sp)
00139FCC 8FB2012C lw         $s2, 0x12c($sp)
00139FD0 8FBF0130 lw         $ra, 0x130($sp)
00139FD4 03E00008 jr         $ra
00139FD8 27BD0140 addiu      $sp, $sp, 0x140