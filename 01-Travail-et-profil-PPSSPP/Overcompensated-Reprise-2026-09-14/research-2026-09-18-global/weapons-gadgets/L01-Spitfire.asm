
CALLBACK 0x00173A48 end 0x00173A7C ordinal 0

00173A48 3C040009 lui        $a0, 9
00173A4C 2484CF10 addiu      $a0, $a0, -0x30f0
00173A50 8C8400E4 lw         $a0, 0xe4($a0)
00173A54 3C05002D lui        $a1, 0x2d
00173A58 8CA67954 lw         $a2, 0x7954($a1)
00173A5C 3C07F801 lui        $a3, 0xf801
00173A60 24E7FFFF addiu      $a3, $a3, -1
00173A64 00C73024 and        $a2, $a2, $a3
00173A68 00042400 sll        $a0, $a0, 0x10
00173A6C 00C42025 or         $a0, $a2, $a0
00173A70 ACA47954 sw         $a0, 0x7954($a1)
00173A74 03E00008 jr         $ra
00173A78 34020001 ori        $v0, $zero, 1

CALLBACK 0x00173A7C end 0x00173A84 ordinal 1

00173A7C 03E00008 jr         $ra
00173A80 00000000 nop        

CALLBACK 0x00173AA0 end 0x00173CCC ordinal 2

00173AA0 27BDFF90 addiu      $sp, $sp, -0x70
00173AA4 AFB00048 sw         $s0, 0x48($sp)
00173AA8 00808025 move       $s0, $a0
00173AAC AFB1004C sw         $s1, 0x4c($sp)
00173AB0 8E110058 lw         $s1, 0x58($s0)
00173AB4 AFB20050 sw         $s2, 0x50($sp)
00173AB8 26120030 addiu      $s2, $s0, 0x30
00173ABC 27A40020 addiu      $a0, $sp, 0x20
00173AC0 27A50024 addiu      $a1, $sp, 0x24
00173AC4 C62C0020 lwc1       $f12, 0x20($s1)
00173AC8 26270004 addiu      $a3, $s1, 4
00173ACC 02403025 move       $a2, $s2
00173AD0 34080028 ori        $t0, $zero, 0x28
00173AD4 00004825 move       $t1, $zero
00173AD8 E7B4003C swc1       $f20, 0x3c($sp)
00173ADC E7B60040 swc1       $f22, 0x40($sp)
00173AE0 E7B80044 swc1       $f24, 0x44($sp)
00173AE4 AFB30054 sw         $s3, 0x54($sp)
00173AE8 AFB40058 sw         $s4, 0x58($sp)
00173AEC AFB5005C sw         $s5, 0x5c($sp)
00173AF0 AFB60060 sw         $s6, 0x60($sp)
00173AF4 AFB70064 sw         $s7, 0x64($sp)
00173AF8 AFBF0068 sw         $ra, 0x68($sp)
00173AFC 0C006D3C jal        0x1b4f0
00173B00 00005025 move       $t2, $zero
00173B04 50400011 beql       $v0, $zero, 0x173b4c
00173B08 C62C0020 lwc1       $f12, 0x20($s1)
00173B0C 8FA40038 lw         $a0, 0x38($sp)
00173B10 34050002 ori        $a1, $zero, 2
00173B14 14850006 bne        $a0, $a1, 0x173b30
00173B18 00000000 nop        
00173B1C 8E240000 lw         $a0, ($s1)
00173B20 8FA50034 lw         $a1, 0x34($sp)
00173B24 8C840594 lw         $a0, 0x594($a0)
00173B28 50A40008 beql       $a1, $a0, 0x173b4c
00173B2C C62C0020 lwc1       $f12, 0x20($s1)
00173B30 0C05CF33 jal        0x173ccc
00173B34 02002025 move       $a0, $s0
00173B38 02002025 move       $a0, $s0
00173B3C 0C01A8F0 jal        0x6a3c0
00173B40 34050001 ori        $a1, $zero, 1
00173B44 10000053 b          0x173c94
00173B48 00000000 nop        
00173B4C C62D0004 lwc1       $f13, 4($s1)
00173B50 C60E0030 lwc1       $f14, 0x30($s0)
00173B54 460C6B42 mul.s      $f13, $f13, $f12
00173B58 C60F0034 lwc1       $f15, 0x34($s0)
00173B5C C6100038 lwc1       $f16, 0x38($s0)
00173B60 460D7340 add.s      $f13, $f14, $f13
00173B64 3C044006 lui        $a0, 0x4006
00173B68 E60D0030 swc1       $f13, 0x30($s0)
00173B6C C62D0008 lwc1       $f13, 8($s1)
00173B70 460C6B42 mul.s      $f13, $f13, $f12
00173B74 3C15002D lui        $s5, 0x2d
00173B78 3C053F80 lui        $a1, 0x3f80
00173B7C 4480C000 mtc1       $zero, $f24
00173B80 460D7B40 add.s      $f13, $f15, $f13
00173B84 34840A92 ori        $a0, $a0, 0xa92
00173B88 3C14002D lui        $s4, 0x2d
00173B8C 4484A000 mtc1       $a0, $f20
00173B90 34130000 ori        $s3, $zero, 0
00173B94 4485B000 mtc1       $a1, $f22
00173B98 E60D0034 swc1       $f13, 0x34($s0)
00173B9C C62D000C lwc1       $f13, 0xc($s1)
00173BA0 460C6B02 mul.s      $f12, $f13, $f12
00173BA4 26B5791C addiu      $s5, $s5, 0x791c
00173BA8 26160020 addiu      $s6, $s0, 0x20
00173BAC 26370014 addiu      $s7, $s1, 0x14
00173BB0 460C8300 add.s      $f12, $f16, $f12
00173BB4 E60C0038 swc1       $f12, 0x38($s0)
00173BB8 8E847918 lw         $a0, 0x7918($s4)
00173BBC C62C0010 lwc1       $f12, 0x10($s1)
00173BC0 02A02825 move       $a1, $s5
00173BC4 02403025 move       $a2, $s2
00173BC8 02C03825 move       $a3, $s6
00173BCC 0C05D038 jal        0x1740e0
00173BD0 02E04025 move       $t0, $s7
00173BD4 0C06D6C8 jal        0x1b5b20
00173BD8 4600A306 mov.s      $f12, $f20
00173BDC 46000306 mov.s      $f12, $f0
00173BE0 460C6342 mul.s      $f13, $f12, $f12
00173BE4 4618A03C c.lt.s     $f20, $f24
00173BE8 460DB341 sub.s      $f13, $f22, $f13
00173BEC 46006B44 sqrt.s     $f13, $f13
00173BF0 45030001 bc1tl      0x173bf8
00173BF4 46006B47 neg.s      $f13, $f13
00173BF8 46006386 mov.s      $f14, $f12
00173BFC 02E02025 move       $a0, $s7
00173C00 46006B06 mov.s      $f12, $f13
00173C04 02E02825 move       $a1, $s7
00173C08 02C03025 move       $a2, $s6
00173C0C 0C03DCFC jal        0xf73f0
00173C10 46007346 mov.s      $f13, $f14
00173C14 26730001 addiu      $s3, $s3, 1
00173C18 2E640003 sltiu      $a0, $s3, 3
00173C1C 1480FFE6 bnez       $a0, 0x173bb8
00173C20 00000000 nop        
00173C24 0C05CFE8 jal        0x173fa0
00173C28 02002025 move       $a0, $s0
00173C2C 10400009 beqz       $v0, 0x173c54
00173C30 C60C0070 lwc1       $f12, 0x70($s0)
00173C34 3C04002D lui        $a0, 0x2d
00173C38 C48D790C lwc1       $f13, 0x790c($a0)
00173C3C 460D603E c.le.s     $f12, $f13
00173C40 00000000 nop        
00173C44 45010003 bc1t       0x173c54
00173C48 00000000 nop        
00173C4C E60D0070 swc1       $f13, 0x70($s0)
00173C50 46006B06 mov.s      $f12, $f13
00173C54 3C04BF80 lui        $a0, 0xbf80
00173C58 44846800 mtc1       $a0, $f13
00173C5C 460D6300 add.s      $f12, $f12, $f13
00173C60 4618603E c.le.s     $f12, $f24
00173C64 00000000 nop        
00173C68 45010005 bc1t       0x173c80
00173C6C E60C0070 swc1       $f12, 0x70($s0)
00173C70 0C05D00E jal        0x174038
00173C74 02002025 move       $a0, $s0
00173C78 10400006 beqz       $v0, 0x173c94
00173C7C 00000000 nop        
00173C80 0C05CF33 jal        0x173ccc
00173C84 02002025 move       $a0, $s0
00173C88 02002025 move       $a0, $s0
00173C8C 0C01A8F0 jal        0x6a3c0
00173C90 34050001 ori        $a1, $zero, 1
00173C94 C7B4003C lwc1       $f20, 0x3c($sp)
00173C98 C7B60040 lwc1       $f22, 0x40($sp)
00173C9C C7B80044 lwc1       $f24, 0x44($sp)
00173CA0 8FB00048 lw         $s0, 0x48($sp)
00173CA4 8FB1004C lw         $s1, 0x4c($sp)
00173CA8 8FB20050 lw         $s2, 0x50($sp)
00173CAC 8FB30054 lw         $s3, 0x54($sp)
00173CB0 8FB40058 lw         $s4, 0x58($sp)
00173CB4 8FB5005C lw         $s5, 0x5c($sp)
00173CB8 8FB60060 lw         $s6, 0x60($sp)
00173CBC 8FB70064 lw         $s7, 0x64($sp)
00173CC0 8FBF0068 lw         $ra, 0x68($sp)
00173CC4 03E00008 jr         $ra
00173CC8 27BD0070 addiu      $sp, $sp, 0x70