
CALLBACK 0x00110D48 end 0x00111050 ordinal 0

00110D48 27BDFF80 addiu      $sp, $sp, -0x80
00110D4C AFB00058 sw         $s0, 0x58($sp)
00110D50 AFB30064 sw         $s3, 0x64($sp)
00110D54 00808025 move       $s0, $a0
00110D58 3C130009 lui        $s3, 9
00110D5C AFB1005C sw         $s1, 0x5c($sp)
00110D60 8E110058 lw         $s1, 0x58($s0)
00110D64 2673CF10 addiu      $s3, $s3, -0x30f0
00110D68 8E66001C lw         $a2, 0x1c($s3)
00110D6C AFB20060 sw         $s2, 0x60($sp)
00110D70 34120001 ori        $s2, $zero, 1
00110D74 34040003 ori        $a0, $zero, 3
00110D78 30C6FFFF andi       $a2, $a2, 0xffff
00110D7C 34050001 ori        $a1, $zero, 1
00110D80 34070001 ori        $a3, $zero, 1
00110D84 E7B40040 swc1       $f20, 0x40($sp)
00110D88 E7B60044 swc1       $f22, 0x44($sp)
00110D8C E7B80048 swc1       $f24, 0x48($sp)
00110D90 E7BA004C swc1       $f26, 0x4c($sp)
00110D94 E7BC0050 swc1       $f28, 0x50($sp)
00110D98 E7BE0054 swc1       $f30, 0x54($sp)
00110D9C AFB40068 sw         $s4, 0x68($sp)
00110DA0 AFB5006C sw         $s5, 0x6c($sp)
00110DA4 AFB60070 sw         $s6, 0x70($sp)
00110DA8 AFB70074 sw         $s7, 0x74($sp)
00110DAC AFBF0078 sw         $ra, 0x78($sp)
00110DB0 0C01F9B0 jal        0x7e6c0
00110DB4 00004025 move       $t0, $zero
00110DB8 00402025 move       $a0, $v0
00110DBC 1480000F bnez       $a0, 0x110dfc
00110DC0 AE220000 sw         $v0, ($s1)
00110DC4 3C05002D lui        $a1, 0x2d
00110DC8 3C06001C lui        $a2, 0x1c
00110DCC 3C08001C lui        $t0, 0x1c
00110DD0 34040001 ori        $a0, $zero, 1
00110DD4 3407008B ori        $a3, $zero, 0x8b
00110DD8 24A5D5B4 addiu      $a1, $a1, -0x2a4c
00110DDC 24C66064 addiu      $a2, $a2, 0x6064
00110DE0 0C03B04D jal        0xec134
00110DE4 250860A0 addiu      $t0, $t0, 0x60a0
00110DE8 3C04001C lui        $a0, 0x1c
00110DEC 0C03B058 jal        0xec160
00110DF0 248460A4 addiu      $a0, $a0, 0x60a4
00110DF4 10000085 b          0x11100c
00110DF8 00001025 move       $v0, $zero
00110DFC 00802825 move       $a1, $a0
00110E00 ACA00000 sw         $zero, ($a1)
00110E04 2404FFFF addiu      $a0, $zero, -1
00110E08 ACA4001C sw         $a0, 0x1c($a1)
00110E0C ACA40008 sw         $a0, 8($a1)
00110E10 3C04002D lui        $a0, 0x2d
00110E14 C48CD510 lwc1       $f12, -0x2af0($a0)
00110E18 0220A025 move       $s4, $s1
00110E1C E4AC0018 swc1       $f12, 0x18($a1)
00110E20 02002025 move       $a0, $s0
00110E24 0C0444B9 jal        0x1112e4
00110E28 E4AC002C swc1       $f12, 0x2c($a1)
00110E2C 4480A000 mtc1       $zero, $f20
00110E30 3C04002D lui        $a0, 0x2d
00110E34 E6140070 swc1       $f20, 0x70($s0)
00110E38 C48CD508 lwc1       $f12, -0x2af8($a0)
00110E3C 3C0440A0 lui        $a0, 0x40a0
00110E40 44846800 mtc1       $a0, $f13
00110E44 460D6303 div.s      $f12, $f12, $f13
00110E48 3C04002D lui        $a0, 0x2d
00110E4C C48ED50C lwc1       $f14, -0x2af4($a0)
00110E50 C60F0020 lwc1       $f15, 0x20($s0)
00110E54 C6100024 lwc1       $f16, 0x24($s0)
00110E58 C6110028 lwc1       $f17, 0x28($s0)
00110E5C C6120030 lwc1       $f18, 0x30($s0)
00110E60 3C0440C9 lui        $a0, 0x40c9
00110E64 34840FDB ori        $a0, $a0, 0xfdb
00110E68 3C05C049 lui        $a1, 0xc049
00110E6C 3C155523 lui        $s5, 0x5523
00110E70 3C063000 lui        $a2, 0x3000
00110E74 3C073F80 lui        $a3, 0x3f80
00110E78 3C16002D lui        $s6, 0x2d
00110E7C 34110000 ori        $s1, $zero, 0
00110E80 26B5AADD addiu      $s5, $s5, -0x5523
00110E84 46007387 neg.s      $f14, $f14
00110E88 460F7002 mul.s      $f0, $f14, $f15
00110E8C 46107082 mul.s      $f2, $f14, $f16
00110E90 4484B000 mtc1       $a0, $f22
00110E94 46009480 add.s      $f18, $f18, $f0
00110E98 46117382 mul.s      $f14, $f14, $f17
00110E9C C60D0034 lwc1       $f13, 0x34($s0)
00110EA0 460F63C2 mul.s      $f15, $f12, $f15
00110EA4 C6130038 lwc1       $f19, 0x38($s0)
00110EA8 46106402 mul.s      $f16, $f12, $f16
00110EAC E7A00020 swc1       $f0, 0x20($sp)
00110EB0 46026B40 add.s      $f13, $f13, $f2
00110EB4 E7A20024 swc1       $f2, 0x24($sp)
00110EB8 E7AE0028 swc1       $f14, 0x28($sp)
00110EBC 460E9B80 add.s      $f14, $f19, $f14
00110EC0 E7B20020 swc1       $f18, 0x20($sp)
00110EC4 E7AD0024 swc1       $f13, 0x24($sp)
00110EC8 46116302 mul.s      $f12, $f12, $f17
00110ECC 34A40FDB ori        $a0, $a1, 0xfdb
00110ED0 4486C000 mtc1       $a2, $f24
00110ED4 4487E000 mtc1       $a3, $f28
00110ED8 E7AE0028 swc1       $f14, 0x28($sp)
00110EDC 4484D000 mtc1       $a0, $f26
00110EE0 E7AF0030 swc1       $f15, 0x30($sp)
00110EE4 E7B00034 swc1       $f16, 0x34($sp)
00110EE8 E7AC0038 swc1       $f12, 0x38($sp)
00110EEC 8E660038 lw         $a2, 0x38($s3)
00110EF0 00002025 move       $a0, $zero
00110EF4 30C6FFFF andi       $a2, $a2, 0xffff
00110EF8 34050001 ori        $a1, $zero, 1
00110EFC 34070001 ori        $a3, $zero, 1
00110F00 0C01F904 jal        0x7e410
00110F04 00004025 move       $t0, $zero
00110F08 0040B825 move       $s7, $v0
00110F0C 12E00016 beqz       $s7, 0x110f68
00110F10 AE970010 sw         $s7, 0x10($s4)
00110F14 AEF50008 sw         $s5, 8($s7)
00110F18 AEE00000 sw         $zero, ($s7)
00110F1C C6CCD518 lwc1       $f12, -0x2ae8($s6)
00110F20 0C06B652 jal        0x1ad948
00110F24 E6EC0018 swc1       $f12, 0x18($s7)
00110F28 44826000 mtc1       $v0, $f12
00110F2C 46806320 cvt.s.w    $f12, $f12
00110F30 46186302 mul.s      $f12, $f12, $f24
00110F34 46166302 mul.s      $f12, $f12, $f22
00110F38 461A6780 add.s      $f30, $f12, $f26
00110F3C 0C06D6C8 jal        0x1b5b20
00110F40 4600F306 mov.s      $f12, $f30
00110F44 46000306 mov.s      $f12, $f0
00110F48 460C6342 mul.s      $f13, $f12, $f12
00110F4C 4614F03C c.lt.s     $f30, $f20
00110F50 460DE341 sub.s      $f13, $f28, $f13
00110F54 46006B44 sqrt.s     $f13, $f13
00110F58 45030013 bc1tl      0x110fa8
00110F5C 46006B47 neg.s      $f13, $f13
00110F60 10000012 b          0x110fac
00110F64 E6ED001C swc1       $f13, 0x1c($s7)
00110F68 3C05002D lui        $a1, 0x2d
00110F6C 3C06001C lui        $a2, 0x1c
00110F70 3C08001C lui        $t0, 0x1c
00110F74 34040001 ori        $a0, $zero, 1
00110F78 340700A6 ori        $a3, $zero, 0xa6
00110F7C 24A5D5B4 addiu      $a1, $a1, -0x2a4c
00110F80 24C66064 addiu      $a2, $a2, 0x6064
00110F84 0C03B04D jal        0xec134
00110F88 250860A0 addiu      $t0, $t0, 0x60a0
00110F8C 3C04001C lui        $a0, 0x1c
00110F90 0C03B058 jal        0xec160
00110F94 248460A4 addiu      $a0, $a0, 0x60a4
00110F98 0C044414 jal        0x111050
00110F9C 02002025 move       $a0, $s0
00110FA0 1000001A b          0x11100c
00110FA4 00001025 move       $v0, $zero
00110FA8 E6ED001C swc1       $f13, 0x1c($s7)
00110FAC E6EC0020 swc1       $f12, 0x20($s7)
00110FB0 C7AC0020 lwc1       $f12, 0x20($sp)
00110FB4 26E4000C addiu      $a0, $s7, 0xc
00110FB8 E48C0000 swc1       $f12, ($a0)
00110FBC C7AC0024 lwc1       $f12, 0x24($sp)
00110FC0 E48C0004 swc1       $f12, 4($a0)
00110FC4 C7AC0028 lwc1       $f12, 0x28($sp)
00110FC8 E48C0008 swc1       $f12, 8($a0)
00110FCC C7AD0020 lwc1       $f13, 0x20($sp)
00110FD0 C7AE0030 lwc1       $f14, 0x30($sp)
00110FD4 C7AF0024 lwc1       $f15, 0x24($sp)
00110FD8 C7B00034 lwc1       $f16, 0x34($sp)
00110FDC 460E6B40 add.s      $f13, $f13, $f14
00110FE0 C7B10038 lwc1       $f17, 0x38($sp)
00110FE4 46107BC0 add.s      $f15, $f15, $f16
00110FE8 26310001 addiu      $s1, $s1, 1
00110FEC 46116300 add.s      $f12, $f12, $f17
00110FF0 26940004 addiu      $s4, $s4, 4
00110FF4 E7AD0020 swc1       $f13, 0x20($sp)
00110FF8 2E240005 sltiu      $a0, $s1, 5
00110FFC E7AF0024 swc1       $f15, 0x24($sp)
00111000 1480FFBA bnez       $a0, 0x110eec
00111004 E7AC0028 swc1       $f12, 0x28($sp)
00111008 02401025 move       $v0, $s2
0011100C C7B40040 lwc1       $f20, 0x40($sp)
00111010 C7B60044 lwc1       $f22, 0x44($sp)
00111014 C7B80048 lwc1       $f24, 0x48($sp)
00111018 C7BA004C lwc1       $f26, 0x4c($sp)
0011101C C7BC0050 lwc1       $f28, 0x50($sp)
00111020 C7BE0054 lwc1       $f30, 0x54($sp)
00111024 8FB00058 lw         $s0, 0x58($sp)
00111028 8FB1005C lw         $s1, 0x5c($sp)
0011102C 8FB20060 lw         $s2, 0x60($sp)
00111030 8FB30064 lw         $s3, 0x64($sp)
00111034 8FB40068 lw         $s4, 0x68($sp)
00111038 8FB5006C lw         $s5, 0x6c($sp)
0011103C 8FB60070 lw         $s6, 0x70($sp)
00111040 8FB70074 lw         $s7, 0x74($sp)
00111044 8FBF0078 lw         $ra, 0x78($sp)
00111048 03E00008 jr         $ra
0011104C 27BD0080 addiu      $sp, $sp, 0x80

CALLBACK 0x00111050 end 0x00111104 ordinal 1

00111050 27BDFFE0 addiu      $sp, $sp, -0x20
00111054 AFB10014 sw         $s1, 0x14($sp)
00111058 8C910058 lw         $s1, 0x58($a0)
0011105C 8E240000 lw         $a0, ($s1)
00111060 AFB00010 sw         $s0, 0x10($sp)
00111064 AFB20018 sw         $s2, 0x18($sp)
00111068 AFBF001C sw         $ra, 0x1c($sp)
0011106C 1080000C beqz       $a0, 0x1110a0
00111070 3C10002B lui        $s0, 0x2b
00111074 00802825 move       $a1, $a0
00111078 50A00009 beql       $a1, $zero, 0x1110a0
0011107C AE200000 sw         $zero, ($s1)
00111080 8E063058 lw         $a2, 0x3058($s0)
00111084 14860003 bne        $a0, $a2, 0x111094
00111088 00000000 nop        
0011108C 10000003 b          0x11109c
00111090 AE003058 sw         $zero, 0x3058($s0)
00111094 0C023293 jal        0x8ca4c
00111098 00A02025 move       $a0, $a1
0011109C AE200000 sw         $zero, ($s1)
001110A0 34120000 ori        $s2, $zero, 0
001110A4 8E250010 lw         $a1, 0x10($s1)
001110A8 10A0000C beqz       $a1, 0x1110dc
001110AC 00000000 nop        
001110B0 00A02025 move       $a0, $a1
001110B4 50800009 beql       $a0, $zero, 0x1110dc
001110B8 AE200010 sw         $zero, 0x10($s1)
001110BC 8E063058 lw         $a2, 0x3058($s0)
001110C0 14A60003 bne        $a1, $a2, 0x1110d0
001110C4 00000000 nop        
001110C8 10000003 b          0x1110d8
001110CC AE003058 sw         $zero, 0x3058($s0)
001110D0 0C023293 jal        0x8ca4c
001110D4 00000000 nop        
001110D8 AE200010 sw         $zero, 0x10($s1)
001110DC 26520001 addiu      $s2, $s2, 1
001110E0 2E440005 sltiu      $a0, $s2, 5
001110E4 1480FFEF bnez       $a0, 0x1110a4
001110E8 26310004 addiu      $s1, $s1, 4
001110EC 8FB00010 lw         $s0, 0x10($sp)
001110F0 8FB10014 lw         $s1, 0x14($sp)
001110F4 8FB20018 lw         $s2, 0x18($sp)
001110F8 8FBF001C lw         $ra, 0x1c($sp)
001110FC 03E00008 jr         $ra
00111100 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x00111104 end 0x001112E4 ordinal 2

00111104 27BDFFB0 addiu      $sp, $sp, -0x50
00111108 AFB10044 sw         $s1, 0x44($sp)
0011110C 8C910058 lw         $s1, 0x58($a0)
00111110 8C850064 lw         $a1, 0x64($a0)
00111114 AFB00040 sw         $s0, 0x40($sp)
00111118 30A50001 andi       $a1, $a1, 1
0011111C AFBF0048 sw         $ra, 0x48($sp)
00111120 10A00016 beqz       $a1, 0x11117c
00111124 00808025 move       $s0, $a0
00111128 92040045 lbu        $a0, 0x45($s0)
0011112C 34050001 ori        $a1, $zero, 1
00111130 1085000E beq        $a0, $a1, 0x11116c
00111134 00000000 nop        
00111138 C60D0070 lwc1       $f13, 0x70($s0)
0011113C 3C04002D lui        $a0, 0x2d
00111140 460C6B40 add.s      $f13, $f13, $f12
00111144 E60D0070 swc1       $f13, 0x70($s0)
00111148 C48ED514 lwc1       $f14, -0x2aec($a0)
0011114C 460E683C c.lt.s     $f13, $f14
00111150 00000000 nop        
00111154 4503000B bc1tl      0x111184
00111158 C62D000C lwc1       $f13, 0xc($s1)
0011115C 0C0445E8 jal        0x1117a0
00111160 02002025 move       $a0, $s0
00111164 1000005A b          0x1112d0
00111168 00000000 nop        
0011116C 0C04461A jal        0x111868
00111170 02002025 move       $a0, $s0
00111174 10000056 b          0x1112d0
00111178 00000000 nop        
0011117C 10000054 b          0x1112d0
00111180 00000000 nop        
00111184 C60E0020 lwc1       $f14, 0x20($s0)
00111188 460C6B02 mul.s      $f12, $f13, $f12
0011118C C60F0024 lwc1       $f15, 0x24($s0)
00111190 C6100028 lwc1       $f16, 0x28($s0)
00111194 C6110030 lwc1       $f17, 0x30($s0)
00111198 C6120034 lwc1       $f18, 0x34($s0)
0011119C 460E6382 mul.s      $f14, $f12, $f14
001111A0 C60D0038 lwc1       $f13, 0x38($s0)
001111A4 460F63C2 mul.s      $f15, $f12, $f15
001111A8 02002025 move       $a0, $s0
001111AC E7AE0010 swc1       $f14, 0x10($sp)
001111B0 46106302 mul.s      $f12, $f12, $f16
001111B4 E7AF0014 swc1       $f15, 0x14($sp)
001111B8 460E8B80 add.s      $f14, $f17, $f14
001111BC 460F93C0 add.s      $f15, $f18, $f15
001111C0 E7AC0018 swc1       $f12, 0x18($sp)
001111C4 460C6B00 add.s      $f12, $f13, $f12
001111C8 E60E0030 swc1       $f14, 0x30($s0)
001111CC E60F0034 swc1       $f15, 0x34($s0)
001111D0 0C0444B9 jal        0x1112e4
001111D4 E60C0038 swc1       $f12, 0x38($s0)
001111D8 3C04002D lui        $a0, 0x2d
001111DC C48CD508 lwc1       $f12, -0x2af8($a0)
001111E0 3C0440A0 lui        $a0, 0x40a0
001111E4 44847000 mtc1       $a0, $f14
001111E8 460E6303 div.s      $f12, $f12, $f14
001111EC 3C04002D lui        $a0, 0x2d
001111F0 C48DD50C lwc1       $f13, -0x2af4($a0)
001111F4 C60F0020 lwc1       $f15, 0x20($s0)
001111F8 C6100024 lwc1       $f16, 0x24($s0)
001111FC C6110028 lwc1       $f17, 0x28($s0)
00111200 C6120030 lwc1       $f18, 0x30($s0)
00111204 C6130034 lwc1       $f19, 0x34($s0)
00111208 34040000 ori        $a0, $zero, 0
0011120C 46006B47 neg.s      $f13, $f13
00111210 460F6802 mul.s      $f0, $f13, $f15
00111214 46106882 mul.s      $f2, $f13, $f16
00111218 46009480 add.s      $f18, $f18, $f0
0011121C 46116B42 mul.s      $f13, $f13, $f17
00111220 C60E0038 lwc1       $f14, 0x38($s0)
00111224 46029CC0 add.s      $f19, $f19, $f2
00111228 E7A00020 swc1       $f0, 0x20($sp)
0011122C 460F63C2 mul.s      $f15, $f12, $f15
00111230 E7A20024 swc1       $f2, 0x24($sp)
00111234 46106402 mul.s      $f16, $f12, $f16
00111238 E7AD0028 swc1       $f13, 0x28($sp)
0011123C 460D7340 add.s      $f13, $f14, $f13
00111240 E7B20020 swc1       $f18, 0x20($sp)
00111244 E7B30024 swc1       $f19, 0x24($sp)
00111248 46116302 mul.s      $f12, $f12, $f17
0011124C E7AD0028 swc1       $f13, 0x28($sp)
00111250 E7AF0030 swc1       $f15, 0x30($sp)
00111254 E7B00034 swc1       $f16, 0x34($sp)
00111258 E7AC0038 swc1       $f12, 0x38($sp)
0011125C 8E250010 lw         $a1, 0x10($s1)
00111260 C7AC0020 lwc1       $f12, 0x20($sp)
00111264 24A5000C addiu      $a1, $a1, 0xc
00111268 E4AC0000 swc1       $f12, ($a1)
0011126C C7AC0024 lwc1       $f12, 0x24($sp)
00111270 E4AC0004 swc1       $f12, 4($a1)
00111274 C7AC0028 lwc1       $f12, 0x28($sp)
00111278 E4AC0008 swc1       $f12, 8($a1)
0011127C C7AD0020 lwc1       $f13, 0x20($sp)
00111280 C7AE0030 lwc1       $f14, 0x30($sp)
00111284 C7AF0024 lwc1       $f15, 0x24($sp)
00111288 C7B00034 lwc1       $f16, 0x34($sp)
0011128C 460E6B40 add.s      $f13, $f13, $f14
00111290 C7B10038 lwc1       $f17, 0x38($sp)
00111294 46107BC0 add.s      $f15, $f15, $f16
00111298 24840001 addiu      $a0, $a0, 1
0011129C 46116300 add.s      $f12, $f12, $f17
001112A0 26310004 addiu      $s1, $s1, 4
001112A4 E7AD0020 swc1       $f13, 0x20($sp)
001112A8 2C850005 sltiu      $a1, $a0, 5
001112AC E7AF0024 swc1       $f15, 0x24($sp)
001112B0 14A0FFEA bnez       $a1, 0x11125c
001112B4 E7AC0028 swc1       $f12, 0x28($sp)
001112B8 0C0444DB jal        0x11136c
001112BC 02002025 move       $a0, $s0
001112C0 10400003 beqz       $v0, 0x1112d0
001112C4 00000000 nop        
001112C8 0C0445E8 jal        0x1117a0
001112CC 02002025 move       $a0, $s0
001112D0 8FB00040 lw         $s0, 0x40($sp)
001112D4 8FB10044 lw         $s1, 0x44($sp)
001112D8 8FBF0048 lw         $ra, 0x48($sp)
001112DC 03E00008 jr         $ra
001112E0 27BD0050 addiu      $sp, $sp, 0x50