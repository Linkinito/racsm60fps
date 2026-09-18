
CALLBACK 0x00111B10 end 0x00111BD4 ordinal 0

00111B10 00803825 move       $a3, $a0
00111B14 C4EC0020 lwc1       $f12, 0x20($a3)
00111B18 3C08002D lui        $t0, 0x2d
00111B1C C50DD5E4 lwc1       $f13, -0x2a1c($t0)
00111B20 C4EE0024 lwc1       $f14, 0x24($a3)
00111B24 460D6302 mul.s      $f12, $f12, $f13
00111B28 C4EF0028 lwc1       $f15, 0x28($a3)
00111B2C E4EC0020 swc1       $f12, 0x20($a3)
00111B30 C50CD5E4 lwc1       $f12, -0x2a1c($t0)
00111B34 C4F00000 lwc1       $f16, ($a3)
00111B38 460C7302 mul.s      $f12, $f14, $f12
00111B3C E4EC0024 swc1       $f12, 0x24($a3)
00111B40 C50CD5E4 lwc1       $f12, -0x2a1c($t0)
00111B44 C4ED0004 lwc1       $f13, 4($a3)
00111B48 460C7B02 mul.s      $f12, $f15, $f12
00111B4C E4EC0028 swc1       $f12, 0x28($a3)
00111B50 C50CD5E4 lwc1       $f12, -0x2a1c($t0)
00111B54 C4EE0008 lwc1       $f14, 8($a3)
00111B58 460C8302 mul.s      $f12, $f16, $f12
00111B5C 8CE60058 lw         $a2, 0x58($a3)
00111B60 E4EC0000 swc1       $f12, ($a3)
00111B64 C50CD5E4 lwc1       $f12, -0x2a1c($t0)
00111B68 C4EF0010 lwc1       $f15, 0x10($a3)
00111B6C 460C6B02 mul.s      $f12, $f13, $f12
00111B70 E4EC0004 swc1       $f12, 4($a3)
00111B74 C50CD5E4 lwc1       $f12, -0x2a1c($t0)
00111B78 C4F00014 lwc1       $f16, 0x14($a3)
00111B7C 460C7302 mul.s      $f12, $f14, $f12
00111B80 34050000 ori        $a1, $zero, 0
00111B84 E4EC0008 swc1       $f12, 8($a3)
00111B88 C50CD5E4 lwc1       $f12, -0x2a1c($t0)
00111B8C C4ED0018 lwc1       $f13, 0x18($a3)
00111B90 460C7B02 mul.s      $f12, $f15, $f12
00111B94 00C02025 move       $a0, $a2
00111B98 E4EC0010 swc1       $f12, 0x10($a3)
00111B9C C50CD5E4 lwc1       $f12, -0x2a1c($t0)
00111BA0 460C8302 mul.s      $f12, $f16, $f12
00111BA4 E4EC0014 swc1       $f12, 0x14($a3)
00111BA8 C50CD5E4 lwc1       $f12, -0x2a1c($t0)
00111BAC 460C6B02 mul.s      $f12, $f13, $f12
00111BB0 E4EC0018 swc1       $f12, 0x18($a3)
00111BB4 AC800004 sw         $zero, 4($a0)
00111BB8 24A50001 addiu      $a1, $a1, 1
00111BBC 2CA70004 sltiu      $a3, $a1, 4
00111BC0 14E0FFFC bnez       $a3, 0x111bb4
00111BC4 24840004 addiu      $a0, $a0, 4
00111BC8 ACC00000 sw         $zero, ($a2)
00111BCC 03E00008 jr         $ra
00111BD0 34020001 ori        $v0, $zero, 1

CALLBACK 0x00111BD4 end 0x00111C54 ordinal 1

00111BD4 27BDFFE0 addiu      $sp, $sp, -0x20
00111BD8 AFB00010 sw         $s0, 0x10($sp)
00111BDC AFB10014 sw         $s1, 0x14($sp)
00111BE0 AFB20018 sw         $s2, 0x18($sp)
00111BE4 AFBF001C sw         $ra, 0x1c($sp)
00111BE8 8C910058 lw         $s1, 0x58($a0)
00111BEC 34120000 ori        $s2, $zero, 0
00111BF0 3C10002B lui        $s0, 0x2b
00111BF4 8E250004 lw         $a1, 4($s1)
00111BF8 10A0000C beqz       $a1, 0x111c2c
00111BFC 00000000 nop        
00111C00 00A02025 move       $a0, $a1
00111C04 10800008 beqz       $a0, 0x111c28
00111C08 00000000 nop        
00111C0C 8E063058 lw         $a2, 0x3058($s0)
00111C10 14A60003 bne        $a1, $a2, 0x111c20
00111C14 00000000 nop        
00111C18 10000003 b          0x111c28
00111C1C AE003058 sw         $zero, 0x3058($s0)
00111C20 0C023293 jal        0x8ca4c
00111C24 00000000 nop        
00111C28 AE200004 sw         $zero, 4($s1)
00111C2C 26520001 addiu      $s2, $s2, 1
00111C30 2E440004 sltiu      $a0, $s2, 4
00111C34 1480FFEF bnez       $a0, 0x111bf4
00111C38 26310004 addiu      $s1, $s1, 4
00111C3C 8FB00010 lw         $s0, 0x10($sp)
00111C40 8FB10014 lw         $s1, 0x14($sp)
00111C44 8FB20018 lw         $s2, 0x18($sp)
00111C48 8FBF001C lw         $ra, 0x1c($sp)
00111C4C 03E00008 jr         $ra
00111C50 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x00111C54 end 0x00112054 ordinal 2

00111C54 27BDFF10 addiu      $sp, $sp, -0xf0
00111C58 3C05002D lui        $a1, 0x2d
00111C5C C4ACD5E8 lwc1       $f12, -0x2a18($a1)
00111C60 3C05002D lui        $a1, 0x2d
00111C64 C4ADD5D8 lwc1       $f13, -0x2a28($a1)
00111C68 460D6302 mul.s      $f12, $f12, $f13
00111C6C C48E0020 lwc1       $f14, 0x20($a0)
00111C70 C48F0030 lwc1       $f15, 0x30($a0)
00111C74 C4900024 lwc1       $f16, 0x24($a0)
00111C78 AFB100E0 sw         $s1, 0xe0($sp)
00111C7C 460C7382 mul.s      $f14, $f14, $f12
00111C80 8C910058 lw         $s1, 0x58($a0)
00111C84 460C8342 mul.s      $f13, $f16, $f12
00111C88 C4910034 lwc1       $f17, 0x34($a0)
00111C8C C4920028 lwc1       $f18, 0x28($a0)
00111C90 460E7B80 add.s      $f14, $f15, $f14
00111C94 460C9302 mul.s      $f12, $f18, $f12
00111C98 460D8B40 add.s      $f13, $f17, $f13
00111C9C C4930038 lwc1       $f19, 0x38($a0)
00111CA0 C4800070 lwc1       $f0, 0x70($a0)
00111CA4 3C063D08 lui        $a2, 0x3d08
00111CA8 34C68889 ori        $a2, $a2, 0x8889
00111CAC E48E0030 swc1       $f14, 0x30($a0)
00111CB0 460C9B00 add.s      $f12, $f19, $f12
00111CB4 44867000 mtc1       $a2, $f14
00111CB8 E48D0034 swc1       $f13, 0x34($a0)
00111CBC 460E0340 add.s      $f13, $f0, $f14
00111CC0 E48C0038 swc1       $f12, 0x38($a0)
00111CC4 3C05002D lui        $a1, 0x2d
00111CC8 E48D0070 swc1       $f13, 0x70($a0)
00111CCC C4ACD5EC lwc1       $f12, -0x2a14($a1)
00111CD0 E7B400C8 swc1       $f20, 0xc8($sp)
00111CD4 460C683C c.lt.s     $f13, $f12
00111CD8 E7B600CC swc1       $f22, 0xcc($sp)
00111CDC E7B800D0 swc1       $f24, 0xd0($sp)
00111CE0 E7BA00D4 swc1       $f26, 0xd4($sp)
00111CE4 E7BC00D8 swc1       $f28, 0xd8($sp)
00111CE8 AFB000DC sw         $s0, 0xdc($sp)
00111CEC AFB200E4 sw         $s2, 0xe4($sp)
00111CF0 AFBF00E8 sw         $ra, 0xe8($sp)
00111CF4 45000008 bc1f       0x111d18
00111CF8 00808025 move       $s0, $a0
00111CFC 3C04002D lui        $a0, 0x2d
00111D00 C48CD5E0 lwc1       $f12, -0x2a20($a0)
00111D04 8E240000 lw         $a0, ($s1)
00111D08 54800008 bnel       $a0, $zero, 0x111d2c
00111D0C 8E250000 lw         $a1, ($s1)
00111D10 10000018 b          0x111d74
00111D14 00000000 nop        
00111D18 02002025 move       $a0, $s0
00111D1C 0C0448C7 jal        0x11231c
00111D20 02202825 move       $a1, $s1
00111D24 100000C0 b          0x112028
00111D28 00000000 nop        
00111D2C 3C09002D lui        $t1, 0x2d
00111D30 94A6000C lhu        $a2, 0xc($a1)
00111D34 27A40040 addiu      $a0, $sp, 0x40
00111D38 34C60008 ori        $a2, $a2, 8
00111D3C A4A6000C sh         $a2, 0xc($a1)
00111D40 C52CD5E0 lwc1       $f12, -0x2a20($t1)
00111D44 27A5004C addiu      $a1, $sp, 0x4c
00111D48 26060030 addiu      $a2, $s0, 0x30
00111D4C 34070068 ori        $a3, $zero, 0x68
00111D50 34080000 ori        $t0, $zero, 0
00111D54 0C00681E jal        0x1a078
00111D58 00004825 move       $t1, $zero
00111D5C 8E240000 lw         $a0, ($s1)
00111D60 46000306 mov.s      $f12, $f0
00111D64 2405FFF7 addiu      $a1, $zero, -9
00111D68 9486000C lhu        $a2, 0xc($a0)
00111D6C 00C52824 and        $a1, $a2, $a1
00111D70 A485000C sh         $a1, 0xc($a0)
00111D74 3C04002D lui        $a0, 0x2d
00111D78 C48DD5E0 lwc1       $f13, -0x2a20($a0)
00111D7C 460C6832 c.eq.s     $f13, $f12
00111D80 00000000 nop        
00111D84 4503001E bc1tl      0x111e00
00111D88 C60C0020 lwc1       $f12, 0x20($s0)
00111D8C 8FA40060 lw         $a0, 0x60($sp)
00111D90 34050002 ori        $a1, $zero, 2
00111D94 14850015 bne        $a0, $a1, 0x111dec
00111D98 00000000 nop        
00111D9C 8FA4005C lw         $a0, 0x5c($sp)
00111DA0 3C05462E lui        $a1, 0x462e
00111DA4 8C860040 lw         $a2, 0x40($a0)
00111DA8 24A54E09 addiu      $a1, $a1, 0x4e09
00111DAC 8CC60030 lw         $a2, 0x30($a2)
00111DB0 10C50007 beq        $a2, $a1, 0x111dd0
00111DB4 00000000 nop        
00111DB8 8C840040 lw         $a0, 0x40($a0)
00111DBC 3C053692 lui        $a1, 0x3692
00111DC0 8C840030 lw         $a0, 0x30($a0)
00111DC4 24A59224 addiu      $a1, $a1, -0x6ddc
00111DC8 14850003 bne        $a0, $a1, 0x111dd8
00111DCC 00000000 nop        
00111DD0 10000095 b          0x112028
00111DD4 00000000 nop        
00111DD8 02002025 move       $a0, $s0
00111DDC 0C0448C7 jal        0x11231c
00111DE0 02202825 move       $a1, $s1
00111DE4 10000090 b          0x112028
00111DE8 00000000 nop        
00111DEC 02002025 move       $a0, $s0
00111DF0 0C0448C7 jal        0x11231c
00111DF4 02202825 move       $a1, $s1
00111DF8 1000008B b          0x112028
00111DFC 00000000 nop        
00111E00 C60D0024 lwc1       $f13, 0x24($s0)
00111E04 C60E0028 lwc1       $f14, 0x28($s0)
00111E08 E7AC0084 swc1       $f12, 0x84($sp)
00111E0C E7AD0088 swc1       $f13, 0x88($sp)
00111E10 C60F002C lwc1       $f15, 0x2c($s0)
00111E14 E7AE008C swc1       $f14, 0x8c($sp)
00111E18 C6100000 lwc1       $f16, ($s0)
00111E1C E7AF0090 swc1       $f15, 0x90($sp)
00111E20 C60F0004 lwc1       $f15, 4($s0)
00111E24 E7B00064 swc1       $f16, 0x64($sp)
00111E28 C6100008 lwc1       $f16, 8($s0)
00111E2C E7AF0068 swc1       $f15, 0x68($sp)
00111E30 C60F000C lwc1       $f15, 0xc($s0)
00111E34 E7B0006C swc1       $f16, 0x6c($sp)
00111E38 C6100010 lwc1       $f16, 0x10($s0)
00111E3C E7AF0070 swc1       $f15, 0x70($sp)
00111E40 C60F0014 lwc1       $f15, 0x14($s0)
00111E44 C6110030 lwc1       $f17, 0x30($s0)
00111E48 E7B00074 swc1       $f16, 0x74($sp)
00111E4C C6100018 lwc1       $f16, 0x18($s0)
00111E50 C6120034 lwc1       $f18, 0x34($s0)
00111E54 E7AF0078 swc1       $f15, 0x78($sp)
00111E58 C60F001C lwc1       $f15, 0x1c($s0)
00111E5C C6130038 lwc1       $f19, 0x38($s0)
00111E60 3C04BE4C lui        $a0, 0xbe4c
00111E64 3484CCCD ori        $a0, $a0, 0xcccd
00111E68 E7B0007C swc1       $f16, 0x7c($sp)
00111E6C 44848000 mtc1       $a0, $f16
00111E70 E7AF0080 swc1       $f15, 0x80($sp)
00111E74 46106302 mul.s      $f12, $f12, $f16
00111E78 E7B10094 swc1       $f17, 0x94($sp)
00111E7C 46106B42 mul.s      $f13, $f13, $f16
00111E80 E7B20098 swc1       $f18, 0x98($sp)
00111E84 46107382 mul.s      $f14, $f14, $f16
00111E88 C60F003C lwc1       $f15, 0x3c($s0)
00111E8C E7B3009C swc1       $f19, 0x9c($sp)
00111E90 460C8B00 add.s      $f12, $f17, $f12
00111E94 E7AF00A0 swc1       $f15, 0xa0($sp)
00111E98 460D9340 add.s      $f13, $f18, $f13
00111E9C 3C04002D lui        $a0, 0x2d
00111EA0 460E9B80 add.s      $f14, $f19, $f14
00111EA4 C48FA388 lwc1       $f15, -0x5c78($a0)
00111EA8 2484A388 addiu      $a0, $a0, -0x5c78
00111EAC E7AC0094 swc1       $f12, 0x94($sp)
00111EB0 E7AD0098 swc1       $f13, 0x98($sp)
00111EB4 46007B07 neg.s      $f12, $f15
00111EB8 E7AE009C swc1       $f14, 0x9c($sp)
00111EBC C48D0004 lwc1       $f13, 4($a0)
00111EC0 E7AC00A4 swc1       $f12, 0xa4($sp)
00111EC4 C48C0008 lwc1       $f12, 8($a0)
00111EC8 46006B47 neg.s      $f13, $f13
00111ECC E7AD00A8 swc1       $f13, 0xa8($sp)
00111ED0 46006307 neg.s      $f12, $f12
00111ED4 34120000 ori        $s2, $zero, 0
00111ED8 2E440004 sltiu      $a0, $s2, 4
00111EDC 10800015 beqz       $a0, 0x111f34
00111EE0 E7AC00AC swc1       $f12, 0xac($sp)
00111EE4 00122080 sll        $a0, $s2, 2
00111EE8 02242021 addu       $a0, $s1, $a0
00111EEC 8C840004 lw         $a0, 4($a0)
00111EF0 14800003 bnez       $a0, 0x111f00
00111EF4 24850030 addiu      $a1, $a0, 0x30
00111EF8 1000000A b          0x111f24
00111EFC 00000000 nop        
00111F00 27A60064 addiu      $a2, $sp, 0x64
00111F04 ACA60010 sw         $a2, 0x10($a1)
00111F08 C7AC00A4 lwc1       $f12, 0xa4($sp)
00111F0C E4AC0000 swc1       $f12, ($a1)
00111F10 C7AC00A8 lwc1       $f12, 0xa8($sp)
00111F14 E4AC0004 swc1       $f12, 4($a1)
00111F18 C7AC00AC lwc1       $f12, 0xac($sp)
00111F1C 0C0336F0 jal        0xcdbc0
00111F20 E4AC0008 swc1       $f12, 8($a1)
00111F24 26520001 addiu      $s2, $s2, 1
00111F28 2E440004 sltiu      $a0, $s2, 4
00111F2C 1480FFED bnez       $a0, 0x111ee4
00111F30 00000000 nop        
00111F34 3C04002D lui        $a0, 0x2d
00111F38 C48CA388 lwc1       $f12, -0x5c78($a0)
00111F3C 2484A388 addiu      $a0, $a0, -0x5c78
00111F40 C48D0004 lwc1       $f13, 4($a0)
00111F44 46006387 neg.s      $f14, $f12
00111F48 C48F0008 lwc1       $f15, 8($a0)
00111F4C 3C04BF33 lui        $a0, 0xbf33
00111F50 34843333 ori        $a0, $a0, 0x3333
00111F54 46007C07 neg.s      $f16, $f15
00111F58 E7AE00B0 swc1       $f14, 0xb0($sp)
00111F5C 44848800 mtc1       $a0, $f17
00111F60 46006B87 neg.s      $f14, $f13
00111F64 3C043E2A lui        $a0, 0x3e2a
00111F68 46116302 mul.s      $f12, $f12, $f17
00111F6C E7AE00B4 swc1       $f14, 0xb4($sp)
00111F70 46116B42 mul.s      $f13, $f13, $f17
00111F74 E7B000B8 swc1       $f16, 0xb8($sp)
00111F78 46117B82 mul.s      $f14, $f15, $f17
00111F7C 3484AAAB ori        $a0, $a0, 0xaaab
00111F80 4484A000 mtc1       $a0, $f20
00111F84 E7AC00BC swc1       $f12, 0xbc($sp)
00111F88 E7AD00C0 swc1       $f13, 0xc0($sp)
00111F8C 3C04002D lui        $a0, 0x2d
00111F90 E7AE00C4 swc1       $f14, 0xc4($sp)
00111F94 2484D5F0 addiu      $a0, $a0, -0x2a10
00111F98 C496000C lwc1       $f22, 0xc($a0)
00111F9C 3C043ECC lui        $a0, 0x3ecc
00111FA0 3484CCCD ori        $a0, $a0, 0xcccd
00111FA4 4484C000 mtc1       $a0, $f24
00111FA8 3C043A83 lui        $a0, 0x3a83
00111FAC 3484126F ori        $a0, $a0, 0x126f
00111FB0 4484D000 mtc1       $a0, $f26
00111FB4 3C0440C9 lui        $a0, 0x40c9
00111FB8 34840FDB ori        $a0, $a0, 0xfdb
00111FBC 4484E000 mtc1       $a0, $f28
00111FC0 3C049A00 lui        $a0, 0x9a00
00111FC4 0C06B652 jal        0x1ad948
00111FC8 2491FFFF addiu      $s1, $a0, -1
00111FCC 44826000 mtc1       $v0, $f12
00111FD0 3C043000 lui        $a0, 0x3000
00111FD4 46806320 cvt.s.w    $f12, $f12
00111FD8 44846800 mtc1       $a0, $f13
00111FDC 3C04C049 lui        $a0, 0xc049
00111FE0 4600C386 mov.s      $f14, $f24
00111FE4 34850FDB ori        $a1, $a0, 0xfdb
00111FE8 460D6342 mul.s      $f13, $f12, $f13
00111FEC 00002025 move       $a0, $zero
00111FF0 44858000 mtc1       $a1, $f16
00111FF4 27A600B0 addiu      $a2, $sp, 0xb0
00111FF8 27A500BC addiu      $a1, $sp, 0xbc
00111FFC 461C6BC2 mul.s      $f15, $f13, $f28
00112000 02203825 move       $a3, $s1
00112004 4600A306 mov.s      $f12, $f20
00112008 00004025 move       $t0, $zero
0011200C 02004825 move       $t1, $s0
00112010 340A0003 ori        $t2, $zero, 3
00112014 46107C00 add.s      $f16, $f15, $f16
00112018 340B000E ori        $t3, $zero, 0xe
0011201C 4600B346 mov.s      $f13, $f22
00112020 0C0316C4 jal        0xc5b10
00112024 4600D3C6 mov.s      $f15, $f26
00112028 C7B400C8 lwc1       $f20, 0xc8($sp)
0011202C C7B600CC lwc1       $f22, 0xcc($sp)
00112030 C7B800D0 lwc1       $f24, 0xd0($sp)
00112034 C7BA00D4 lwc1       $f26, 0xd4($sp)
00112038 C7BC00D8 lwc1       $f28, 0xd8($sp)
0011203C 8FB000DC lw         $s0, 0xdc($sp)
00112040 8FB100E0 lw         $s1, 0xe0($sp)
00112044 8FB200E4 lw         $s2, 0xe4($sp)
00112048 8FBF00E8 lw         $ra, 0xe8($sp)
0011204C 03E00008 jr         $ra
00112050 27BD00F0 addiu      $sp, $sp, 0xf0