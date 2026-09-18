
CALLBACK 0x00132B38 end 0x00132BA8 ordinal 0

00132B38 44807000 mtc1       $zero, $f14
00132B3C 8C870058 lw         $a3, 0x58($a0)
00132B40 46007346 mov.s      $f13, $f14
00132B44 3C043F00 lui        $a0, 0x3f00
00132B48 44846000 mtc1       $a0, $f12
00132B4C ACE00000 sw         $zero, ($a3)
00132B50 34060000 ori        $a2, $zero, 0
00132B54 00E02825 move       $a1, $a3
00132B58 3C04002D lui        $a0, 0x2d
00132B5C ACA00004 sw         $zero, 4($a1)
00132B60 E4AD000C swc1       $f13, 0xc($a1)
00132B64 C48F0F20 lwc1       $f15, 0xf20($a0)
00132B68 24C60001 addiu      $a2, $a2, 1
00132B6C 460C7C02 mul.s      $f16, $f15, $f12
00132B70 24A50004 addiu      $a1, $a1, 4
00132B74 2CC80002 sltiu      $t0, $a2, 2
00132B78 1500FFF8 bnez       $t0, 0x132b5c
00132B7C 46106B40 add.s      $f13, $f13, $f16
00132B80 ACE00014 sw         $zero, 0x14($a3)
00132B84 3C043F80 lui        $a0, 0x3f80
00132B88 44846000 mtc1       $a0, $f12
00132B8C E4EE001C swc1       $f14, 0x1c($a3)
00132B90 E4EC0018 swc1       $f12, 0x18($a3)
00132B94 2404FFFF addiu      $a0, $zero, -1
00132B98 ACE40020 sw         $a0, 0x20($a3)
00132B9C E4EE0024 swc1       $f14, 0x24($a3)
00132BA0 03E00008 jr         $ra
00132BA4 34020001 ori        $v0, $zero, 1

CALLBACK 0x00132BA8 end 0x00132BEC ordinal 1

00132BA8 27BDFFE0 addiu      $sp, $sp, -0x20
00132BAC AFB00010 sw         $s0, 0x10($sp)
00132BB0 AFB10014 sw         $s1, 0x14($sp)
00132BB4 AFBF0018 sw         $ra, 0x18($sp)
00132BB8 8C900058 lw         $s0, 0x58($a0)
00132BBC 34110000 ori        $s1, $zero, 0
00132BC0 0C04CD3E jal        0x1334f8
00132BC4 8E040004 lw         $a0, 4($s0)
00132BC8 26310001 addiu      $s1, $s1, 1
00132BCC 2E240002 sltiu      $a0, $s1, 2
00132BD0 1480FFFB bnez       $a0, 0x132bc0
00132BD4 26100004 addiu      $s0, $s0, 4
00132BD8 8FB00010 lw         $s0, 0x10($sp)
00132BDC 8FB10014 lw         $s1, 0x14($sp)
00132BE0 8FBF0018 lw         $ra, 0x18($sp)
00132BE4 03E00008 jr         $ra
00132BE8 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x00132BEC end 0x00132E20 ordinal 2

00132BEC 27BDFFA0 addiu      $sp, $sp, -0x60
00132BF0 AFB10044 sw         $s1, 0x44($sp)
00132BF4 8C910058 lw         $s1, 0x58($a0)
00132BF8 C48C0070 lwc1       $f12, 0x70($a0)
00132BFC E7B40034 swc1       $f20, 0x34($sp)
00132C00 4480A000 mtc1       $zero, $f20
00132C04 E7B60038 swc1       $f22, 0x38($sp)
00132C08 4614603E c.le.s     $f12, $f20
00132C0C E7B8003C swc1       $f24, 0x3c($sp)
00132C10 AFB00040 sw         $s0, 0x40($sp)
00132C14 AFB20048 sw         $s2, 0x48($sp)
00132C18 AFB3004C sw         $s3, 0x4c($sp)
00132C1C AFB40050 sw         $s4, 0x50($sp)
00132C20 AFB50054 sw         $s5, 0x54($sp)
00132C24 AFBF0058 sw         $ra, 0x58($sp)
00132C28 45010008 bc1t       0x132c4c
00132C2C 00808025 move       $s0, $a0
00132C30 3C043F80 lui        $a0, 0x3f80
00132C34 44846800 mtc1       $a0, $f13
00132C38 460D6301 sub.s      $f12, $f12, $f13
00132C3C 4614603E c.le.s     $f12, $f20
00132C40 00000000 nop        
00132C44 45010006 bc1t       0x132c60
00132C48 E60C0070 swc1       $f12, 0x70($s0)
00132C4C 8E240014 lw         $a0, 0x14($s1)
00132C50 14800008 bnez       $a0, 0x132c74
00132C54 00000000 nop        
00132C58 10000019 b          0x132cc0
00132C5C 00000000 nop        
00132C60 02002025 move       $a0, $s0
00132C64 0C01A8F0 jal        0x6a3c0
00132C68 34050001 ori        $a1, $zero, 1
00132C6C 10000060 b          0x132df0
00132C70 00000000 nop        
00132C74 8C850064 lw         $a1, 0x64($a0)
00132C78 30A50006 andi       $a1, $a1, 6
00132C7C 10A00006 beqz       $a1, 0x132c98
00132C80 00000000 nop        
00132C84 02002025 move       $a0, $s0
00132C88 0C01A8F0 jal        0x6a3c0
00132C8C 34050001 ori        $a1, $zero, 1
00132C90 10000057 b          0x132df0
00132C94 00000000 nop        
00132C98 27A50020 addiu      $a1, $sp, 0x20
00132C9C 00003025 move       $a2, $zero
00132CA0 0C01B0C6 jal        0x6c318
00132CA4 00003825 move       $a3, $zero
00132CA8 C7AC0020 lwc1       $f12, 0x20($sp)
00132CAC C7AD0024 lwc1       $f13, 0x24($sp)
00132CB0 E60C0030 swc1       $f12, 0x30($s0)
00132CB4 C7AC0028 lwc1       $f12, 0x28($sp)
00132CB8 E60D0034 swc1       $f13, 0x34($s0)
00132CBC E60C0038 swc1       $f12, 0x38($s0)
00132CC0 C62C0024 lwc1       $f12, 0x24($s1)
00132CC4 46146032 c.eq.s     $f12, $f20
00132CC8 00000000 nop        
00132CCC 45010025 bc1t       0x132d64
00132CD0 26120030 addiu      $s2, $s0, 0x30
00132CD4 34070129 ori        $a3, $zero, 0x129
00132CD8 34080101 ori        $t0, $zero, 0x101
00132CDC 27A4002C addiu      $a0, $sp, 0x2c
00132CE0 34050002 ori        $a1, $zero, 2
00132CE4 02403025 move       $a2, $s2
00132CE8 34090002 ori        $t1, $zero, 2
00132CEC 0C005BA6 jal        0x16e98
00132CF0 340A0001 ori        $t2, $zero, 1
00132CF4 00409825 move       $s3, $v0
00132CF8 34140000 ori        $s4, $zero, 0
00132CFC 0293202B sltu       $a0, $s4, $s3
00132D00 10800018 beqz       $a0, 0x132d64
00132D04 03A0A825 move       $s5, $sp
00132D08 8EA4002C lw         $a0, 0x2c($s5)
00132D0C 8C850040 lw         $a1, 0x40($a0)
00132D10 8CA50020 lw         $a1, 0x20($a1)
00132D14 10A0000F beqz       $a1, 0x132d54
00132D18 00000000 nop        
00132D1C 0C00428A jal        0x10a28
00132D20 00000000 nop        
00132D24 10400008 beqz       $v0, 0x132d48
00132D28 00000000 nop        
00132D2C 8EA4002C lw         $a0, 0x2c($s5)
00132D30 02002825 move       $a1, $s0
00132D34 8C840058 lw         $a0, 0x58($a0)
00132D38 0C00C678 jal        0x319e0
00132D3C 8C840000 lw         $a0, ($a0)
00132D40 10400004 beqz       $v0, 0x132d54
00132D44 00000000 nop        
00132D48 8EA5002C lw         $a1, 0x2c($s5)
00132D4C 0C04CD7D jal        0x1335f4
00132D50 02002025 move       $a0, $s0
00132D54 26940001 addiu      $s4, $s4, 1
00132D58 0293202B sltu       $a0, $s4, $s3
00132D5C 1480FFEA bnez       $a0, 0x132d08
00132D60 26B50004 addiu      $s5, $s5, 4
00132D64 3C043F80 lui        $a0, 0x3f80
00132D68 4484B000 mtc1       $a0, $f22
00132D6C 34100000 ori        $s0, $zero, 0
00132D70 3C043000 lui        $a0, 0x3000
00132D74 02209825 move       $s3, $s1
00132D78 4484C000 mtc1       $a0, $f24
00132D7C 3C14002D lui        $s4, 0x2d
00132D80 0C04CD69 jal        0x1335a4
00132D84 8E640004 lw         $a0, 4($s3)
00132D88 14400012 bnez       $v0, 0x132dd4
00132D8C 00000000 nop        
00132D90 C66C000C lwc1       $f12, 0xc($s3)
00132D94 46166301 sub.s      $f12, $f12, $f22
00132D98 4614603E c.le.s     $f12, $f20
00132D9C 00000000 nop        
00132DA0 4500000C bc1f       0x132dd4
00132DA4 E66C000C swc1       $f12, 0xc($s3)
00132DA8 C62C0018 lwc1       $f12, 0x18($s1)
00132DAC 0C04CC52 jal        0x133148
00132DB0 02402025 move       $a0, $s2
00132DB4 0C06B652 jal        0x1ad948
00132DB8 AE620004 sw         $v0, 4($s3)
00132DBC 44826000 mtc1       $v0, $f12
00132DC0 C68D0F20 lwc1       $f13, 0xf20($s4)
00132DC4 46806320 cvt.s.w    $f12, $f12
00132DC8 460D6302 mul.s      $f12, $f12, $f13
00132DCC 46186302 mul.s      $f12, $f12, $f24
00132DD0 E66C000C swc1       $f12, 0xc($s3)
00132DD4 8E640004 lw         $a0, 4($s3)
00132DD8 0C04CC0B jal        0x13302c
00132DDC 02402825 move       $a1, $s2
00132DE0 26100001 addiu      $s0, $s0, 1
00132DE4 2E040002 sltiu      $a0, $s0, 2
00132DE8 1480FFE5 bnez       $a0, 0x132d80
00132DEC 26730004 addiu      $s3, $s3, 4
00132DF0 C7B40034 lwc1       $f20, 0x34($sp)
00132DF4 C7B60038 lwc1       $f22, 0x38($sp)
00132DF8 C7B8003C lwc1       $f24, 0x3c($sp)
00132DFC 8FB00040 lw         $s0, 0x40($sp)
00132E00 8FB10044 lw         $s1, 0x44($sp)
00132E04 8FB20048 lw         $s2, 0x48($sp)
00132E08 8FB3004C lw         $s3, 0x4c($sp)
00132E0C 8FB40050 lw         $s4, 0x50($sp)
00132E10 8FB50054 lw         $s5, 0x54($sp)
00132E14 8FBF0058 lw         $ra, 0x58($sp)
00132E18 03E00008 jr         $ra
00132E1C 27BD0060 addiu      $sp, $sp, 0x60