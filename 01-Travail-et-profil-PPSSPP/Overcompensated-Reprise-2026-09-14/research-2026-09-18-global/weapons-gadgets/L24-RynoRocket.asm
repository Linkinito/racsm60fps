
CALLBACK 0x00149C68 end 0x00149C84 ordinal 0

00149C68 8C850058 lw         $a1, 0x58($a0)
00149C6C 44806000 mtc1       $zero, $f12
00149C70 E48C0070 swc1       $f12, 0x70($a0)
00149C74 A0800045 sb         $zero, 0x45($a0)
00149C78 ACA0001C sw         $zero, 0x1c($a1)
00149C7C 03E00008 jr         $ra
00149C80 34020001 ori        $v0, $zero, 1

CALLBACK 0x00149C84 end 0x00149CD4 ordinal 1

00149C84 27BDFFE0 addiu      $sp, $sp, -0x20
00149C88 AFB00010 sw         $s0, 0x10($sp)
00149C8C 8C900058 lw         $s0, 0x58($a0)
00149C90 8E04001C lw         $a0, 0x1c($s0)
00149C94 AFBF0014 sw         $ra, 0x14($sp)
00149C98 10800004 beqz       $a0, 0x149cac
00149C9C 00000000 nop        
00149CA0 0C019BAB jal        0x66eac
00149CA4 00000000 nop        
00149CA8 AE00001C sw         $zero, 0x1c($s0)
00149CAC 8E04002C lw         $a0, 0x2c($s0)
00149CB0 10800004 beqz       $a0, 0x149cc4
00149CB4 00000000 nop        
00149CB8 0C0329E6 jal        0xca798
00149CBC 00000000 nop        
00149CC0 AE00002C sw         $zero, 0x2c($s0)
00149CC4 8FB00010 lw         $s0, 0x10($sp)
00149CC8 8FBF0014 lw         $ra, 0x14($sp)
00149CCC 03E00008 jr         $ra
00149CD0 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x00149CD4 end 0x00149FCC ordinal 2

00149CD4 27BDFF70 addiu      $sp, $sp, -0x90
00149CD8 C48D0070 lwc1       $f13, 0x70($a0)
00149CDC 3C053F80 lui        $a1, 0x3f80
00149CE0 44857000 mtc1       $a1, $f14
00149CE4 AFB20080 sw         $s2, 0x80($sp)
00149CE8 460E6B40 add.s      $f13, $f13, $f14
00149CEC 8C920058 lw         $s2, 0x58($a0)
00149CF0 3C05002A lui        $a1, 0x2a
00149CF4 C4AF3574 lwc1       $f15, 0x3574($a1)
00149CF8 AFB00078 sw         $s0, 0x78($sp)
00149CFC 00808025 move       $s0, $a0
00149D00 460F683E c.le.s     $f13, $f15
00149D04 AFB1007C sw         $s1, 0x7c($sp)
00149D08 AFBF0084 sw         $ra, 0x84($sp)
00149D0C 45010027 bc1t       0x149dac
00149D10 E48D0070 swc1       $f13, 0x70($a0)
00149D14 8E44001C lw         $a0, 0x1c($s2)
00149D18 10800004 beqz       $a0, 0x149d2c
00149D1C 00000000 nop        
00149D20 0C019BAB jal        0x66eac
00149D24 8E44001C lw         $a0, 0x1c($s2)
00149D28 AE40001C sw         $zero, 0x1c($s2)
00149D2C 3C04002A lui        $a0, 0x2a
00149D30 8C843558 lw         $a0, 0x3558($a0)
00149D34 10800012 beqz       $a0, 0x149d80
00149D38 00000000 nop        
00149D3C 3C04002A lui        $a0, 0x2a
00149D40 8C843558 lw         $a0, 0x3558($a0)
00149D44 1080000E beqz       $a0, 0x149d80
00149D48 3C04002A lui        $a0, 0x2a
00149D4C 8C853558 lw         $a1, 0x3558($a0)
00149D50 34070000 ori        $a3, $zero, 0
00149D54 C4AC0014 lwc1       $f12, 0x14($a1)
00149D58 C4AD0018 lwc1       $f13, 0x18($a1)
00149D5C C4AE001C lwc1       $f14, 0x1c($a1)
00149D60 C4AF0020 lwc1       $f15, 0x20($a1)
00149D64 34090000 ori        $t1, $zero, 0
00149D68 340A0000 ori        $t2, $zero, 0
00149D6C 340B0001 ori        $t3, $zero, 1
00149D70 02002025 move       $a0, $s0
00149D74 00003025 move       $a2, $zero
00149D78 0C019B4F jal        0x66d3c
00149D7C 00004025 move       $t0, $zero
00149D80 92040045 lbu        $a0, 0x45($s0)
00149D84 14800004 bnez       $a0, 0x149d98
00149D88 00000000 nop        
00149D8C 26050030 addiu      $a1, $s0, 0x30
00149D90 0C0327CD jal        0xc9f34
00149D94 34040020 ori        $a0, $zero, 0x20
00149D98 02002025 move       $a0, $s0
00149D9C 0C0192FF jal        0x64bfc
00149DA0 34050001 ori        $a1, $zero, 1
00149DA4 10000083 b          0x149fb4
00149DA8 00000000 nop        
00149DAC 92040045 lbu        $a0, 0x45($s0)
00149DB0 1480007C bnez       $a0, 0x149fa4
00149DB4 00000000 nop        
00149DB8 0C0529AF jal        0x14a6bc
00149DBC 02002025 move       $a0, $s0
00149DC0 8E440000 lw         $a0, ($s2)
00149DC4 C64C0018 lwc1       $f12, 0x18($s2)
00149DC8 8C870594 lw         $a3, 0x594($a0)
00149DCC 27A50030 addiu      $a1, $sp, 0x30
00149DD0 2646000C addiu      $a2, $s2, 0xc
00149DD4 0C0527F3 jal        0x149fcc
00149DD8 02002025 move       $a0, $s0
00149DDC 10400071 beqz       $v0, 0x149fa4
00149DE0 00000000 nop        
00149DE4 8FA40044 lw         $a0, 0x44($sp)
00149DE8 34050002 ori        $a1, $zero, 2
00149DEC 1485003D bne        $a0, $a1, 0x149ee4
00149DF0 00000000 nop        
00149DF4 C7AC0048 lwc1       $f12, 0x48($sp)
00149DF8 C7AD004C lwc1       $f13, 0x4c($sp)
00149DFC E7AC0058 swc1       $f12, 0x58($sp)
00149E00 C7AC0050 lwc1       $f12, 0x50($sp)
00149E04 E7AD005C swc1       $f13, 0x5c($sp)
00149E08 E7AC0060 swc1       $f12, 0x60($sp)
00149E0C 3C043F80 lui        $a0, 0x3f80
00149E10 44846000 mtc1       $a0, $f12
00149E14 8FB10040 lw         $s1, 0x40($sp)
00149E18 E7AC0064 swc1       $f12, 0x64($sp)
00149E1C 44806800 mtc1       $zero, $f13
00149E20 C64C000C lwc1       $f12, 0xc($s2)
00149E24 E7AC0068 swc1       $f12, 0x68($sp)
00149E28 C64C0010 lwc1       $f12, 0x10($s2)
00149E2C E7AC006C swc1       $f12, 0x6c($sp)
00149E30 C64C0014 lwc1       $f12, 0x14($s2)
00149E34 E7AD0074 swc1       $f13, 0x74($sp)
00149E38 E7AC0070 swc1       $f12, 0x70($sp)
00149E3C 8E240040 lw         $a0, 0x40($s1)
00149E40 8C840020 lw         $a0, 0x20($a0)
00149E44 10800027 beqz       $a0, 0x149ee4
00149E48 00000000 nop        
00149E4C 8E440008 lw         $a0, 8($s2)
00149E50 8E250040 lw         $a1, 0x40($s1)
00149E54 8CA60020 lw         $a2, 0x20($a1)
00149E58 14C00003 bnez       $a2, 0x149e68
00149E5C 248400E7 addiu      $a0, $a0, 0xe7
00149E60 1000001B b          0x149ed0
00149E64 2405FFFF addiu      $a1, $zero, -1
00149E68 3C06002A lui        $a2, 0x2a
00149E6C 00042100 sll        $a0, $a0, 4
00149E70 24C6A864 addiu      $a2, $a2, -0x579c
00149E74 00862021 addu       $a0, $a0, $a2
00149E78 00803825 move       $a3, $a0
00149E7C 8CE60000 lw         $a2, ($a3)
00149E80 28C80002 slti       $t0, $a2, 2
00149E84 15000008 bnez       $t0, 0x149ea8
00149E88 28C60003 slti       $a2, $a2, 3
00149E8C 50C00007 beql       $a2, $zero, 0x149eac
00149E90 C4EC0004 lwc1       $f12, 4($a3)
00149E94 C4EC0004 lwc1       $f12, 4($a3)
00149E98 3C063F00 lui        $a2, 0x3f00
00149E9C 44866800 mtc1       $a2, $f13
00149EA0 10000002 b          0x149eac
00149EA4 460D6302 mul.s      $f12, $f12, $f13
00149EA8 C4EC0004 lwc1       $f12, 4($a3)
00149EAC 8CAA0020 lw         $t2, 0x20($a1)
00149EB0 8C850008 lw         $a1, 8($a0)
00149EB4 8C86000C lw         $a2, 0xc($a0)
00149EB8 27A70058 addiu      $a3, $sp, 0x58
00149EBC 27A80068 addiu      $t0, $sp, 0x68
00149EC0 02202025 move       $a0, $s1
00149EC4 0140F809 jalr       $t2
00149EC8 02004825 move       $t1, $s0
00149ECC 00402825 move       $a1, $v0
00149ED0 00A03825 move       $a3, $a1
00149ED4 8E440000 lw         $a0, ($s2)
00149ED8 3405000F ori        $a1, $zero, 0xf
00149EDC 0C003EC2 jal        0xfb08
00149EE0 02203025 move       $a2, $s1
00149EE4 8E44001C lw         $a0, 0x1c($s2)
00149EE8 10800004 beqz       $a0, 0x149efc
00149EEC 00000000 nop        
00149EF0 0C019BAB jal        0x66eac
00149EF4 8E44001C lw         $a0, 0x1c($s2)
00149EF8 AE40001C sw         $zero, 0x1c($s2)
00149EFC 3C04002A lui        $a0, 0x2a
00149F00 8C843558 lw         $a0, 0x3558($a0)
00149F04 10800012 beqz       $a0, 0x149f50
00149F08 00000000 nop        
00149F0C 3C04002A lui        $a0, 0x2a
00149F10 8C843558 lw         $a0, 0x3558($a0)
00149F14 1080000E beqz       $a0, 0x149f50
00149F18 3C04002A lui        $a0, 0x2a
00149F1C 8C853558 lw         $a1, 0x3558($a0)
00149F20 34070000 ori        $a3, $zero, 0
00149F24 C4AC0014 lwc1       $f12, 0x14($a1)
00149F28 C4AD0018 lwc1       $f13, 0x18($a1)
00149F2C C4AE001C lwc1       $f14, 0x1c($a1)
00149F30 C4AF0020 lwc1       $f15, 0x20($a1)
00149F34 34090000 ori        $t1, $zero, 0
00149F38 340A0000 ori        $t2, $zero, 0
00149F3C 340B0001 ori        $t3, $zero, 1
00149F40 02002025 move       $a0, $s0
00149F44 00003025 move       $a2, $zero
00149F48 0C019B4F jal        0x66d3c
00149F4C 00004025 move       $t0, $zero
00149F50 26110030 addiu      $s1, $s0, 0x30
00149F54 34040020 ori        $a0, $zero, 0x20
00149F58 0C0327CD jal        0xc9f34
00149F5C 02202825 move       $a1, $s1
00149F60 8E450008 lw         $a1, 8($s2)
00149F64 8E470000 lw         $a3, ($s2)
00149F68 3C0B002A lui        $t3, 0x2a
00149F6C C56C355C lwc1       $f12, 0x355c($t3)
00149F70 24A500EB addiu      $a1, $a1, 0xeb
00149F74 02202025 move       $a0, $s1
00149F78 02003025 move       $a2, $s0
00149F7C 3408000F ori        $t0, $zero, 0xf
00149F80 34090129 ori        $t1, $zero, 0x129
00149F84 340A0101 ori        $t2, $zero, 0x101
00149F88 0C03DC6A jal        0xf71a8
00149F8C 340B0036 ori        $t3, $zero, 0x36
00149F90 02002025 move       $a0, $s0
00149F94 0C0192FF jal        0x64bfc
00149F98 34050001 ori        $a1, $zero, 1
00149F9C 10000005 b          0x149fb4
00149FA0 00000000 nop        
00149FA4 0C05294E jal        0x14a538
00149FA8 02002025 move       $a0, $s0
00149FAC 0C052841 jal        0x14a104
00149FB0 02002025 move       $a0, $s0
00149FB4 8FB00078 lw         $s0, 0x78($sp)
00149FB8 8FB1007C lw         $s1, 0x7c($sp)
00149FBC 8FB20080 lw         $s2, 0x80($sp)
00149FC0 8FBF0084 lw         $ra, 0x84($sp)
00149FC4 03E00008 jr         $ra
00149FC8 27BD0090 addiu      $sp, $sp, 0x90