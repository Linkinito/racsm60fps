
CALLBACK 0x001506C0 end 0x001506C8 ordinal 0

001506C0 03E00008 jr         $ra
001506C4 34020001 ori        $v0, $zero, 1

CALLBACK 0x001506C8 end 0x00150718 ordinal 1

001506C8 27BDFFE0 addiu      $sp, $sp, -0x20
001506CC AFB00014 sw         $s0, 0x14($sp)
001506D0 00808025 move       $s0, $a0
001506D4 8E040058 lw         $a0, 0x58($s0)
001506D8 AFBF0018 sw         $ra, 0x18($sp)
001506DC 0C05D95A jal        0x176568
001506E0 AFA40010 sw         $a0, 0x10($sp)
001506E4 8FA40010 lw         $a0, 0x10($sp)
001506E8 0C05D95A jal        0x176568
001506EC 24840034 addiu      $a0, $a0, 0x34
001506F0 92050045 lbu        $a1, 0x45($s0)
001506F4 34060001 ori        $a2, $zero, 1
001506F8 10A60003 beq        $a1, $a2, 0x150708
001506FC 8FA40010 lw         $a0, 0x10($sp)
00150700 0C054358 jal        0x150d60
00150704 24840068 addiu      $a0, $a0, 0x68
00150708 8FB00014 lw         $s0, 0x14($sp)
0015070C 8FBF0018 lw         $ra, 0x18($sp)
00150710 03E00008 jr         $ra
00150714 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x00150D7C end 0x00151038 ordinal 2

00150D7C 27BDFFC0 addiu      $sp, $sp, -0x40
00150D80 AFB10024 sw         $s1, 0x24($sp)
00150D84 8C910058 lw         $s1, 0x58($a0)
00150D88 90850046 lbu        $a1, 0x46($a0)
00150D8C AFB00020 sw         $s0, 0x20($sp)
00150D90 AFB20028 sw         $s2, 0x28($sp)
00150D94 AFB3002C sw         $s3, 0x2c($sp)
00150D98 AFB40030 sw         $s4, 0x30($sp)
00150D9C AFBF0034 sw         $ra, 0x34($sp)
00150DA0 10A00063 beqz       $a1, 0x150f30
00150DA4 00808025 move       $s0, $a0
00150DA8 C62D001C lwc1       $f13, 0x1c($s1)
00150DAC 3C04002A lui        $a0, 0x2a
00150DB0 C48C3A64 lwc1       $f12, 0x3a64($a0)
00150DB4 3C05C049 lui        $a1, 0xc049
00150DB8 460C6B41 sub.s      $f13, $f13, $f12
00150DBC 34A50FDB ori        $a1, $a1, 0xfdb
00150DC0 44857000 mtc1       $a1, $f14
00150DC4 C62C0020 lwc1       $f12, 0x20($s1)
00150DC8 460E683C c.lt.s     $f13, $f14
00150DCC 00000000 nop        
00150DD0 45000006 bc1f       0x150dec
00150DD4 E62D001C swc1       $f13, 0x1c($s1)
00150DD8 3C0540C9 lui        $a1, 0x40c9
00150DDC 34A50FDB ori        $a1, $a1, 0xfdb
00150DE0 44857800 mtc1       $a1, $f15
00150DE4 460F6B40 add.s      $f13, $f13, $f15
00150DE8 E62D001C swc1       $f13, 0x1c($s1)
00150DEC C48F3A64 lwc1       $f15, 0x3a64($a0)
00150DF0 460F6301 sub.s      $f12, $f12, $f15
00150DF4 460E603C c.lt.s     $f12, $f14
00150DF8 00000000 nop        
00150DFC 45000006 bc1f       0x150e18
00150E00 E62C0020 swc1       $f12, 0x20($s1)
00150E04 3C0440C9 lui        $a0, 0x40c9
00150E08 34840FDB ori        $a0, $a0, 0xfdb
00150E0C 44847000 mtc1       $a0, $f14
00150E10 460E6300 add.s      $f12, $f12, $f14
00150E14 E62C0020 swc1       $f12, 0x20($s1)
00150E18 3C044049 lui        $a0, 0x4049
00150E1C 34840FDB ori        $a0, $a0, 0xfdb
00150E20 44847000 mtc1       $a0, $f14
00150E24 460E6B40 add.s      $f13, $f13, $f14
00150E28 460E683E c.le.s     $f13, $f14
00150E2C 00000000 nop        
00150E30 45010006 bc1t       0x150e4c
00150E34 E62D0050 swc1       $f13, 0x50($s1)
00150E38 3C0440C9 lui        $a0, 0x40c9
00150E3C 34840FDB ori        $a0, $a0, 0xfdb
00150E40 44847000 mtc1       $a0, $f14
00150E44 460E6B41 sub.s      $f13, $f13, $f14
00150E48 E62D0050 swc1       $f13, 0x50($s1)
00150E4C E62C0054 swc1       $f12, 0x54($s1)
00150E50 92040045 lbu        $a0, 0x45($s0)
00150E54 34050001 ori        $a1, $zero, 1
00150E58 1085006F beq        $a0, $a1, 0x151018
00150E5C 00000000 nop        
00150E60 0C060057 jal        0x18015c
00150E64 00000000 nop        
00150E68 44826000 mtc1       $v0, $f12
00150E6C 3C042FFF lui        $a0, 0x2fff
00150E70 46806320 cvt.s.w    $f12, $f12
00150E74 3484FFFE ori        $a0, $a0, 0xfffe
00150E78 44846800 mtc1       $a0, $f13
00150E7C 3C043F80 lui        $a0, 0x3f80
00150E80 460D6302 mul.s      $f12, $f12, $f13
00150E84 3C054280 lui        $a1, 0x4280
00150E88 44859000 mtc1       $a1, $f18
00150E8C 44846800 mtc1       $a0, $f13
00150E90 3C04437F lui        $a0, 0x437f
00150E94 460C6BC1 sub.s      $f15, $f13, $f12
00150E98 44847000 mtc1       $a0, $f14
00150E9C 460E6402 mul.s      $f16, $f12, $f14
00150EA0 3C044300 lui        $a0, 0x4300
00150EA4 44848800 mtc1       $a0, $f17
00150EA8 460E7B82 mul.s      $f14, $f15, $f14
00150EAC 46117BC2 mul.s      $f15, $f15, $f17
00150EB0 461074C0 add.s      $f19, $f14, $f16
00150EB4 46116442 mul.s      $f17, $f12, $f17
00150EB8 46107400 add.s      $f16, $f14, $f16
00150EBC 46009CCD trunc.w.s  $f19, $f19
00150EC0 46126302 mul.s      $f12, $f12, $f18
00150EC4 46117BC0 add.s      $f15, $f15, $f17
00150EC8 4600840D trunc.w.s  $f16, $f16
00150ECC 460C7300 add.s      $f12, $f14, $f12
00150ED0 46007BCD trunc.w.s  $f15, $f15
00150ED4 44058000 mfc1       $a1, $f16
00150ED8 00052A00 sll        $a1, $a1, 8
00150EDC 4600630D trunc.w.s  $f12, $f12
00150EE0 44067800 mfc1       $a2, $f15
00150EE4 00063400 sll        $a2, $a2, 0x10
00150EE8 44049800 mfc1       $a0, $f19
00150EEC 44076000 mfc1       $a3, $f12
00150EF0 00073E00 sll        $a3, $a3, 0x18
00150EF4 00E63025 or         $a2, $a3, $a2
00150EF8 00C52825 or         $a1, $a2, $a1
00150EFC 00A42025 or         $a0, $a1, $a0
00150F00 AE24008C sw         $a0, 0x8c($s1)
00150F04 C62C0088 lwc1       $f12, 0x88($s1)
00150F08 3C04002A lui        $a0, 0x2a
00150F0C C48E3A6C lwc1       $f14, 0x3a6c($a0)
00150F10 460E6300 add.s      $f12, $f12, $f14
00150F14 460D603E c.le.s     $f12, $f13
00150F18 00000000 nop        
00150F1C 4501003E bc1t       0x151018
00150F20 E62C0088 swc1       $f12, 0x88($s1)
00150F24 460D6301 sub.s      $f12, $f12, $f13
00150F28 1000003B b          0x151018
00150F2C E62C0088 swc1       $f12, 0x88($s1)
00150F30 92040045 lbu        $a0, 0x45($s0)
00150F34 5C800023 bgtzl      $a0, 0x150fc4
00150F38 28840002 slti       $a0, $a0, 2
00150F3C 04800034 bltz       $a0, 0x151010
00150F40 00000000 nop        
00150F44 8E270090 lw         $a3, 0x90($s1)
00150F48 8E280094 lw         $t0, 0x94($s1)
00150F4C 3C12002A lui        $s2, 0x2a
00150F50 3C05002A lui        $a1, 0x2a
00150F54 8E443AA4 lw         $a0, 0x3aa4($s2)
00150F58 24B33A84 addiu      $s3, $a1, 0x3a84
00150F5C 3C14002A lui        $s4, 0x2a
00150F60 3C098001 lui        $t1, 0x8001
00150F64 02202825 move       $a1, $s1
00150F68 02603025 move       $a2, $s3
00150F6C C68C3A60 lwc1       $f12, 0x3a60($s4)
00150F70 0C05D8FD jal        0x1763f4
00150F74 2529FFFF addiu      $t1, $t1, -1
00150F78 8E443AA4 lw         $a0, 0x3aa4($s2)
00150F7C 8E270090 lw         $a3, 0x90($s1)
00150F80 8E280094 lw         $t0, 0x94($s1)
00150F84 3C098100 lui        $t1, 0x8100
00150F88 26250034 addiu      $a1, $s1, 0x34
00150F8C C68C3A60 lwc1       $f12, 0x3a60($s4)
00150F90 02603025 move       $a2, $s3
00150F94 0C05D8FD jal        0x1763f4
00150F98 2529FFFF addiu      $t1, $t1, -1
00150F9C 8E250090 lw         $a1, 0x90($s1)
00150FA0 8E260094 lw         $a2, 0x94($s1)
00150FA4 3C07002A lui        $a3, 0x2a
00150FA8 C4EC3A68 lwc1       $f12, 0x3a68($a3)
00150FAC 3C07FF81 lui        $a3, 0xff81
00150FB0 26240068 addiu      $a0, $s1, 0x68
00150FB4 0C054301 jal        0x150c04
00150FB8 24E7FFFF addiu      $a3, $a3, -1
00150FBC 10000014 b          0x151010
00150FC0 00000000 nop        
00150FC4 10800012 beqz       $a0, 0x151010
00150FC8 00000000 nop        
00150FCC 8E250090 lw         $a1, 0x90($s1)
00150FD0 8E260094 lw         $a2, 0x94($s1)
00150FD4 8E280098 lw         $t0, 0x98($s1)
00150FD8 3C12002A lui        $s2, 0x2a
00150FDC 3C078001 lui        $a3, 0x8001
00150FE0 02202025 move       $a0, $s1
00150FE4 C64C3A60 lwc1       $f12, 0x3a60($s2)
00150FE8 0C054242 jal        0x150908
00150FEC 24E7FFFF addiu      $a3, $a3, -1
00150FF0 8E250090 lw         $a1, 0x90($s1)
00150FF4 8E260094 lw         $a2, 0x94($s1)
00150FF8 C64C3A60 lwc1       $f12, 0x3a60($s2)
00150FFC 3C078100 lui        $a3, 0x8100
00151000 26240034 addiu      $a0, $s1, 0x34
00151004 8E280098 lw         $t0, 0x98($s1)
00151008 0C054242 jal        0x150908
0015100C 24E7FFFF addiu      $a3, $a3, -1
00151010 34040001 ori        $a0, $zero, 1
00151014 A2040046 sb         $a0, 0x46($s0)
00151018 8FB00020 lw         $s0, 0x20($sp)
0015101C 8FB10024 lw         $s1, 0x24($sp)
00151020 8FB20028 lw         $s2, 0x28($sp)
00151024 8FB3002C lw         $s3, 0x2c($sp)
00151028 8FB40030 lw         $s4, 0x30($sp)
0015102C 8FBF0034 lw         $ra, 0x34($sp)
00151030 03E00008 jr         $ra
00151034 27BD0040 addiu      $sp, $sp, 0x40