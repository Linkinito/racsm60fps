
CALLBACK 0x00151CAC end 0x00151CE0 ordinal 0

00151CAC 3C040009 lui        $a0, 9
00151CB0 2484CF90 addiu      $a0, $a0, -0x3070
00151CB4 8C8400E4 lw         $a0, 0xe4($a0)
00151CB8 3C05002A lui        $a1, 0x2a
00151CBC 8CA63BBC lw         $a2, 0x3bbc($a1)
00151CC0 3C07F801 lui        $a3, 0xf801
00151CC4 24E7FFFF addiu      $a3, $a3, -1
00151CC8 00C73024 and        $a2, $a2, $a3
00151CCC 00042400 sll        $a0, $a0, 0x10
00151CD0 00C42025 or         $a0, $a2, $a0
00151CD4 ACA43BBC sw         $a0, 0x3bbc($a1)
00151CD8 03E00008 jr         $ra
00151CDC 34020001 ori        $v0, $zero, 1

CALLBACK 0x00151CE0 end 0x00151CE8 ordinal 1

00151CE0 03E00008 jr         $ra
00151CE4 00000000 nop        

CALLBACK 0x00151D04 end 0x00151F30 ordinal 2

00151D04 27BDFF90 addiu      $sp, $sp, -0x70
00151D08 AFB00048 sw         $s0, 0x48($sp)
00151D0C 00808025 move       $s0, $a0
00151D10 AFB1004C sw         $s1, 0x4c($sp)
00151D14 8E110058 lw         $s1, 0x58($s0)
00151D18 AFB20050 sw         $s2, 0x50($sp)
00151D1C 26120030 addiu      $s2, $s0, 0x30
00151D20 27A40020 addiu      $a0, $sp, 0x20
00151D24 27A50024 addiu      $a1, $sp, 0x24
00151D28 C62C0020 lwc1       $f12, 0x20($s1)
00151D2C 26270004 addiu      $a3, $s1, 4
00151D30 02403025 move       $a2, $s2
00151D34 34080028 ori        $t0, $zero, 0x28
00151D38 00004825 move       $t1, $zero
00151D3C E7B4003C swc1       $f20, 0x3c($sp)
00151D40 E7B60040 swc1       $f22, 0x40($sp)
00151D44 E7B80044 swc1       $f24, 0x44($sp)
00151D48 AFB30054 sw         $s3, 0x54($sp)
00151D4C AFB40058 sw         $s4, 0x58($sp)
00151D50 AFB5005C sw         $s5, 0x5c($sp)
00151D54 AFB60060 sw         $s6, 0x60($sp)
00151D58 AFB70064 sw         $s7, 0x64($sp)
00151D5C AFBF0068 sw         $ra, 0x68($sp)
00151D60 0C00654F jal        0x1953c
00151D64 00005025 move       $t2, $zero
00151D68 50400011 beql       $v0, $zero, 0x151db0
00151D6C C62C0020 lwc1       $f12, 0x20($s1)
00151D70 8FA40038 lw         $a0, 0x38($sp)
00151D74 34050002 ori        $a1, $zero, 2
00151D78 14850006 bne        $a0, $a1, 0x151d94
00151D7C 00000000 nop        
00151D80 8E240000 lw         $a0, ($s1)
00151D84 8FA50034 lw         $a1, 0x34($sp)
00151D88 8C840594 lw         $a0, 0x594($a0)
00151D8C 50A40008 beql       $a1, $a0, 0x151db0
00151D90 C62C0020 lwc1       $f12, 0x20($s1)
00151D94 0C0547CC jal        0x151f30
00151D98 02002025 move       $a0, $s0
00151D9C 02002025 move       $a0, $s0
00151DA0 0C0192FF jal        0x64bfc
00151DA4 34050001 ori        $a1, $zero, 1
00151DA8 10000053 b          0x151ef8
00151DAC 00000000 nop        
00151DB0 C62D0004 lwc1       $f13, 4($s1)
00151DB4 C60E0030 lwc1       $f14, 0x30($s0)
00151DB8 460C6B42 mul.s      $f13, $f13, $f12
00151DBC C60F0034 lwc1       $f15, 0x34($s0)
00151DC0 C6100038 lwc1       $f16, 0x38($s0)
00151DC4 460D7340 add.s      $f13, $f14, $f13
00151DC8 3C044006 lui        $a0, 0x4006
00151DCC E60D0030 swc1       $f13, 0x30($s0)
00151DD0 C62D0008 lwc1       $f13, 8($s1)
00151DD4 460C6B42 mul.s      $f13, $f13, $f12
00151DD8 3C15002A lui        $s5, 0x2a
00151DDC 3C053F80 lui        $a1, 0x3f80
00151DE0 4480C000 mtc1       $zero, $f24
00151DE4 460D7B40 add.s      $f13, $f15, $f13
00151DE8 34840A92 ori        $a0, $a0, 0xa92
00151DEC 3C14002A lui        $s4, 0x2a
00151DF0 4484A000 mtc1       $a0, $f20
00151DF4 34130000 ori        $s3, $zero, 0
00151DF8 4485B000 mtc1       $a1, $f22
00151DFC E60D0034 swc1       $f13, 0x34($s0)
00151E00 C62D000C lwc1       $f13, 0xc($s1)
00151E04 460C6B02 mul.s      $f12, $f13, $f12
00151E08 26B53B84 addiu      $s5, $s5, 0x3b84
00151E0C 26160020 addiu      $s6, $s0, 0x20
00151E10 26370014 addiu      $s7, $s1, 0x14
00151E14 460C8300 add.s      $f12, $f16, $f12
00151E18 E60C0038 swc1       $f12, 0x38($s0)
00151E1C 8E843B80 lw         $a0, 0x3b80($s4)
00151E20 C62C0010 lwc1       $f12, 0x10($s1)
00151E24 02A02825 move       $a1, $s5
00151E28 02403025 move       $a2, $s2
00151E2C 02C03825 move       $a3, $s6
00151E30 0C0548D1 jal        0x152344
00151E34 02E04025 move       $t0, $s7
00151E38 0C0620CD jal        0x188334
00151E3C 4600A306 mov.s      $f12, $f20
00151E40 46000306 mov.s      $f12, $f0
00151E44 460C6342 mul.s      $f13, $f12, $f12
00151E48 4618A03C c.lt.s     $f20, $f24
00151E4C 460DB341 sub.s      $f13, $f22, $f13
00151E50 46006B44 sqrt.s     $f13, $f13
00151E54 45030001 bc1tl      0x151e5c
00151E58 46006B47 neg.s      $f13, $f13
00151E5C 46006386 mov.s      $f14, $f12
00151E60 02E02025 move       $a0, $s7
00151E64 46006B06 mov.s      $f12, $f13
00151E68 02E02825 move       $a1, $s7
00151E6C 02C03025 move       $a2, $s6
00151E70 0C03B6C8 jal        0xedb20
00151E74 46007346 mov.s      $f13, $f14
00151E78 26730001 addiu      $s3, $s3, 1
00151E7C 2E640003 sltiu      $a0, $s3, 3
00151E80 1480FFE6 bnez       $a0, 0x151e1c
00151E84 00000000 nop        
00151E88 0C054881 jal        0x152204
00151E8C 02002025 move       $a0, $s0
00151E90 10400009 beqz       $v0, 0x151eb8
00151E94 C60C0070 lwc1       $f12, 0x70($s0)
00151E98 3C04002A lui        $a0, 0x2a
00151E9C C48D3B74 lwc1       $f13, 0x3b74($a0)
00151EA0 460D603E c.le.s     $f12, $f13
00151EA4 00000000 nop        
00151EA8 45010003 bc1t       0x151eb8
00151EAC 00000000 nop        
00151EB0 E60D0070 swc1       $f13, 0x70($s0)
00151EB4 46006B06 mov.s      $f12, $f13
00151EB8 3C04BF80 lui        $a0, 0xbf80
00151EBC 44846800 mtc1       $a0, $f13
00151EC0 460D6300 add.s      $f12, $f12, $f13
00151EC4 4618603E c.le.s     $f12, $f24
00151EC8 00000000 nop        
00151ECC 45010005 bc1t       0x151ee4
00151ED0 E60C0070 swc1       $f12, 0x70($s0)
00151ED4 0C0548A7 jal        0x15229c
00151ED8 02002025 move       $a0, $s0
00151EDC 10400006 beqz       $v0, 0x151ef8
00151EE0 00000000 nop        
00151EE4 0C0547CC jal        0x151f30
00151EE8 02002025 move       $a0, $s0
00151EEC 02002025 move       $a0, $s0
00151EF0 0C0192FF jal        0x64bfc
00151EF4 34050001 ori        $a1, $zero, 1
00151EF8 C7B4003C lwc1       $f20, 0x3c($sp)
00151EFC C7B60040 lwc1       $f22, 0x40($sp)
00151F00 C7B80044 lwc1       $f24, 0x44($sp)
00151F04 8FB00048 lw         $s0, 0x48($sp)
00151F08 8FB1004C lw         $s1, 0x4c($sp)
00151F0C 8FB20050 lw         $s2, 0x50($sp)
00151F10 8FB30054 lw         $s3, 0x54($sp)
00151F14 8FB40058 lw         $s4, 0x58($sp)
00151F18 8FB5005C lw         $s5, 0x5c($sp)
00151F1C 8FB60060 lw         $s6, 0x60($sp)
00151F20 8FB70064 lw         $s7, 0x64($sp)
00151F24 8FBF0068 lw         $ra, 0x68($sp)
00151F28 03E00008 jr         $ra
00151F2C 27BD0070 addiu      $sp, $sp, 0x70