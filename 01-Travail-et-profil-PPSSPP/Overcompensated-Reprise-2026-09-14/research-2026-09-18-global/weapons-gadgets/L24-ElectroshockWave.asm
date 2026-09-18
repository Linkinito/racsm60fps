
CALLBACK 0x0011FE70 end 0x0011FE78 ordinal 0

0011FE70 03E00008 jr         $ra
0011FE74 34020001 ori        $v0, $zero, 1

CALLBACK 0x0011FE78 end 0x0011FEC0 ordinal 1

0011FE78 27BDFFE0 addiu      $sp, $sp, -0x20
0011FE7C AFB00010 sw         $s0, 0x10($sp)
0011FE80 AFB10014 sw         $s1, 0x14($sp)
0011FE84 AFBF0018 sw         $ra, 0x18($sp)
0011FE88 8C900058 lw         $s0, 0x58($a0)
0011FE8C 34110000 ori        $s1, $zero, 0
0011FE90 2610002C addiu      $s0, $s0, 0x2c
0011FE94 0C021698 jal        0x85a60
0011FE98 02002025 move       $a0, $s0
0011FE9C 26310001 addiu      $s1, $s1, 1
0011FEA0 2E240013 sltiu      $a0, $s1, 0x13
0011FEA4 1480FFFB bnez       $a0, 0x11fe94
0011FEA8 2610001C addiu      $s0, $s0, 0x1c
0011FEAC 8FB00010 lw         $s0, 0x10($sp)
0011FEB0 8FB10014 lw         $s1, 0x14($sp)
0011FEB4 8FBF0018 lw         $ra, 0x18($sp)
0011FEB8 03E00008 jr         $ra
0011FEBC 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x00120950 end 0x00120CE0 ordinal 2

00120950 27BDFF80 addiu      $sp, $sp, -0x80
00120954 AFB1005C sw         $s1, 0x5c($sp)
00120958 8C910058 lw         $s1, 0x58($a0)
0012095C 3C05BF80 lui        $a1, 0xbf80
00120960 C62C024C lwc1       $f12, 0x24c($s1)
00120964 44856800 mtc1       $a1, $f13
00120968 460D6300 add.s      $f12, $f12, $f13
0012096C E7B40048 swc1       $f20, 0x48($sp)
00120970 4480A000 mtc1       $zero, $f20
00120974 AFB00058 sw         $s0, 0x58($sp)
00120978 00808025 move       $s0, $a0
0012097C E7B6004C swc1       $f22, 0x4c($sp)
00120980 4614603E c.le.s     $f12, $f20
00120984 E7B80050 swc1       $f24, 0x50($sp)
00120988 E7BA0054 swc1       $f26, 0x54($sp)
0012098C AFB20060 sw         $s2, 0x60($sp)
00120990 AFB30064 sw         $s3, 0x64($sp)
00120994 AFB40068 sw         $s4, 0x68($sp)
00120998 AFB5006C sw         $s5, 0x6c($sp)
0012099C AFB60070 sw         $s6, 0x70($sp)
001209A0 AFBF0074 sw         $ra, 0x74($sp)
001209A4 45000006 bc1f       0x1209c0
001209A8 E62C024C swc1       $f12, 0x24c($s1)
001209AC 92040045 lbu        $a0, 0x45($s0)
001209B0 10800005 beqz       $a0, 0x1209c8
001209B4 00000000 nop        
001209B8 10000027 b          0x120a58
001209BC C62C0000 lwc1       $f12, ($s1)
001209C0 100000B9 b          0x120ca8
001209C4 00000000 nop        
001209C8 34120000 ori        $s2, $zero, 0
001209CC 26350008 addiu      $s5, $s1, 8
001209D0 2633002C addiu      $s3, $s1, 0x2c
001209D4 3C14002A lui        $s4, 0x2a
001209D8 8E85F234 lw         $a1, -0xdcc($s4)
001209DC 02602025 move       $a0, $s3
001209E0 0C03203A jal        0xc80e8
001209E4 02A03025 move       $a2, $s5
001209E8 26520001 addiu      $s2, $s2, 1
001209EC 2E440013 sltiu      $a0, $s2, 0x13
001209F0 1480FFF9 bnez       $a0, 0x1209d8
001209F4 2673001C addiu      $s3, $s3, 0x1c
001209F8 92040045 lbu        $a0, 0x45($s0)
001209FC E6140070 swc1       $f20, 0x70($s0)
00120A00 24840001 addiu      $a0, $a0, 1
00120A04 A2040045 sb         $a0, 0x45($s0)
00120A08 8E310250 lw         $s1, 0x250($s1)
00120A0C 16200008 bnez       $s1, 0x120a30
00120A10 00000000 nop        
00120A14 3C06002A lui        $a2, 0x2a
00120A18 02002025 move       $a0, $s0
00120A1C 02202825 move       $a1, $s1
00120A20 0C047FB0 jal        0x11fec0
00120A24 C4CCF2A8 lwc1       $f12, -0xd58($a2)
00120A28 1000009F b          0x120ca8
00120A2C 00000000 nop        
00120A30 34040001 ori        $a0, $zero, 1
00120A34 1624009C bne        $s1, $a0, 0x120ca8
00120A38 00000000 nop        
00120A3C 3C06002A lui        $a2, 0x2a
00120A40 02002025 move       $a0, $s0
00120A44 02202825 move       $a1, $s1
00120A48 0C047FB0 jal        0x11fec0
00120A4C C4CCF2AC lwc1       $f12, -0xd54($a2)
00120A50 10000095 b          0x120ca8
00120A54 00000000 nop        
00120A58 3C04002A lui        $a0, 0x2a
00120A5C C48DF230 lwc1       $f13, -0xdd0($a0)
00120A60 3C043D08 lui        $a0, 0x3d08
00120A64 460D6340 add.s      $f13, $f12, $f13
00120A68 C62E0240 lwc1       $f14, 0x240($s1)
00120A6C 34848889 ori        $a0, $a0, 0x8889
00120A70 44846000 mtc1       $a0, $f12
00120A74 E62D0000 swc1       $f13, ($s1)
00120A78 460C7381 sub.s      $f14, $f14, $f12
00120A7C 4614703E c.le.s     $f14, $f20
00120A80 00000000 nop        
00120A84 45000016 bc1f       0x120ae0
00120A88 E62E0240 swc1       $f14, 0x240($s1)
00120A8C C62D0244 lwc1       $f13, 0x244($s1)
00120A90 8E240014 lw         $a0, 0x14($s1)
00120A94 8E250248 lw         $a1, 0x248($s1)
00120A98 460C6B01 sub.s      $f12, $f13, $f12
00120A9C 00043602 srl        $a2, $a0, 0x18
00120AA0 30C600FF andi       $a2, $a2, 0xff
00120AA4 00C52823 subu       $a1, $a2, $a1
00120AA8 3C060100 lui        $a2, 0x100
00120AAC 4614603E c.le.s     $f12, $f20
00120AB0 24C6FFFF addiu      $a2, $a2, -1
00120AB4 00862024 and        $a0, $a0, $a2
00120AB8 00052E00 sll        $a1, $a1, 0x18
00120ABC E62C0244 swc1       $f12, 0x244($s1)
00120AC0 00852025 or         $a0, $a0, $a1
00120AC4 45000006 bc1f       0x120ae0
00120AC8 AE240014 sw         $a0, 0x14($s1)
00120ACC 02002025 move       $a0, $s0
00120AD0 0C0192FF jal        0x64bfc
00120AD4 34050001 ori        $a1, $zero, 1
00120AD8 10000073 b          0x120ca8
00120ADC 00000000 nop        
00120AE0 8E240250 lw         $a0, 0x250($s1)
00120AE4 34050002 ori        $a1, $zero, 2
00120AE8 C6360000 lwc1       $f22, ($s1)
00120AEC 10850004 beq        $a0, $a1, 0x120b00
00120AF0 3C120005 lui        $s2, 5
00120AF4 34050003 ori        $a1, $zero, 3
00120AF8 5485000A bnel       $a0, $a1, 0x120b24
00120AFC C64C5D04 lwc1       $f12, 0x5d04($s2)
00120B00 00802825 move       $a1, $a0
00120B04 4600B306 mov.s      $f12, $f22
00120B08 3C04002A lui        $a0, 0x2a
00120B0C C48DF240 lwc1       $f13, -0xdc0($a0)
00120B10 02002025 move       $a0, $s0
00120B14 0C048054 jal        0x120150
00120B18 460DB341 sub.s      $f13, $f22, $f13
00120B1C C6360000 lwc1       $f22, ($s1)
00120B20 C64C5D04 lwc1       $f12, 0x5d04($s2)
00120B24 26545D04 addiu      $s4, $s2, 0x5d04
00120B28 C60D0030 lwc1       $f13, 0x30($s0)
00120B2C 46166302 mul.s      $f12, $f12, $f22
00120B30 C68E0004 lwc1       $f14, 4($s4)
00120B34 C60F0038 lwc1       $f15, 0x38($s0)
00120B38 46167382 mul.s      $f14, $f14, $f22
00120B3C C6100034 lwc1       $f16, 0x34($s0)
00120B40 460C6B00 add.s      $f12, $f13, $f12
00120B44 3C053F00 lui        $a1, 0x3f00
00120B48 3C043DCC lui        $a0, 0x3dcc
00120B4C 460E7B80 add.s      $f14, $f15, $f14
00120B50 3C063F80 lui        $a2, 0x3f80
00120B54 E7AC0010 swc1       $f12, 0x10($sp)
00120B58 4485B000 mtc1       $a1, $f22
00120B5C E7B00014 swc1       $f16, 0x14($sp)
00120B60 4486C000 mtc1       $a2, $f24
00120B64 3484CCCD ori        $a0, $a0, 0xcccd
00120B68 E7AE0018 swc1       $f14, 0x18($sp)
00120B6C 4484D000 mtc1       $a0, $f26
00120B70 C62C0000 lwc1       $f12, ($s1)
00120B74 E7B40038 swc1       $f20, 0x38($sp)
00120B78 E7AC0034 swc1       $f12, 0x34($sp)
00120B7C 34050008 ori        $a1, $zero, 8
00120B80 E7B00020 swc1       $f16, 0x20($sp)
00120B84 34130001 ori        $s3, $zero, 1
00120B88 34120001 ori        $s2, $zero, 1
00120B8C 27B6001C addiu      $s6, $sp, 0x1c
00120B90 00B4A021 addu       $s4, $a1, $s4
00120B94 2635002C addiu      $s5, $s1, 0x2c
00120B98 C68C0000 lwc1       $f12, ($s4)
00120B9C C62D0000 lwc1       $f13, ($s1)
00120BA0 C60E0030 lwc1       $f14, 0x30($s0)
00120BA4 460D6302 mul.s      $f12, $f12, $f13
00120BA8 C60F0038 lwc1       $f15, 0x38($s0)
00120BAC C7B00020 lwc1       $f16, 0x20($sp)
00120BB0 460C7380 add.s      $f14, $f14, $f12
00120BB4 C7AC0010 lwc1       $f12, 0x10($sp)
00120BB8 C7B10014 lwc1       $f17, 0x14($sp)
00120BBC E7AE001C swc1       $f14, 0x1c($sp)
00120BC0 460E6301 sub.s      $f12, $f12, $f14
00120BC4 C6920004 lwc1       $f18, 4($s4)
00120BC8 46108C41 sub.s      $f17, $f17, $f16
00120BCC C7B30018 lwc1       $f19, 0x18($sp)
00120BD0 460D9342 mul.s      $f13, $f18, $f13
00120BD4 E7AE003C swc1       $f14, 0x3c($sp)
00120BD8 46166002 mul.s      $f0, $f12, $f22
00120BDC E7B00040 swc1       $f16, 0x40($sp)
00120BE0 46168882 mul.s      $f2, $f17, $f22
00120BE4 E7AC0028 swc1       $f12, 0x28($sp)
00120BE8 460D7BC0 add.s      $f15, $f15, $f13
00120BEC E7B1002C swc1       $f17, 0x2c($sp)
00120BF0 46007380 add.s      $f14, $f14, $f0
00120BF4 46028400 add.s      $f16, $f16, $f2
00120BF8 460F9B41 sub.s      $f13, $f19, $f15
00120BFC E7AF0024 swc1       $f15, 0x24($sp)
00120C00 E7AF0044 swc1       $f15, 0x44($sp)
00120C04 46166C42 mul.s      $f17, $f13, $f22
00120C08 E7AD0030 swc1       $f13, 0x30($sp)
00120C0C E7AE001C swc1       $f14, 0x1c($sp)
00120C10 E7B00020 swc1       $f16, 0x20($sp)
00120C14 46117B80 add.s      $f14, $f15, $f17
00120C18 16720008 bne        $s3, $s2, 0x120c3c
00120C1C E7AE0024 swc1       $f14, 0x24($sp)
00120C20 460C6302 mul.s      $f12, $f12, $f12
00120C24 460D6B42 mul.s      $f13, $f13, $f13
00120C28 0C05E2E0 jal        0x178b80
00120C2C 460D6300 add.s      $f12, $f12, $f13
00120C30 C7AC0028 lwc1       $f12, 0x28($sp)
00120C34 4600C503 div.s      $f20, $f24, $f0
00120C38 C7AD0030 lwc1       $f13, 0x30($sp)
00120C3C 46146302 mul.s      $f12, $f12, $f20
00120C40 C7AE002C lwc1       $f14, 0x2c($sp)
00120C44 C60F0034 lwc1       $f15, 0x34($s0)
00120C48 46146B42 mul.s      $f13, $f13, $f20
00120C4C C7B00020 lwc1       $f16, 0x20($sp)
00120C50 46147382 mul.s      $f14, $f14, $f20
00120C54 02A02025 move       $a0, $s5
00120C58 E7AC0028 swc1       $f12, 0x28($sp)
00120C5C 46107B01 sub.s      $f12, $f15, $f16
00120C60 E7AD0030 swc1       $f13, 0x30($sp)
00120C64 E7AE002C swc1       $f14, 0x2c($sp)
00120C68 02C02825 move       $a1, $s6
00120C6C 00003025 move       $a2, $zero
00120C70 46006305 abs.s      $f12, $f12
00120C74 0C03208E jal        0xc8238
00120C78 461A6302 mul.s      $f12, $f12, $f26
00120C7C C7AC003C lwc1       $f12, 0x3c($sp)
00120C80 C7AD0040 lwc1       $f13, 0x40($sp)
00120C84 E7AC0010 swc1       $f12, 0x10($sp)
00120C88 C7AC0044 lwc1       $f12, 0x44($sp)
00120C8C E7AD0014 swc1       $f13, 0x14($sp)
00120C90 26730001 addiu      $s3, $s3, 1
00120C94 E7AC0018 swc1       $f12, 0x18($sp)
00120C98 26940008 addiu      $s4, $s4, 8
00120C9C 2E640014 sltiu      $a0, $s3, 0x14
00120CA0 1480FFBD bnez       $a0, 0x120b98
00120CA4 26B5001C addiu      $s5, $s5, 0x1c
00120CA8 C7B40048 lwc1       $f20, 0x48($sp)
00120CAC C7B6004C lwc1       $f22, 0x4c($sp)
00120CB0 C7B80050 lwc1       $f24, 0x50($sp)
00120CB4 C7BA0054 lwc1       $f26, 0x54($sp)
00120CB8 8FB00058 lw         $s0, 0x58($sp)
00120CBC 8FB1005C lw         $s1, 0x5c($sp)
00120CC0 8FB20060 lw         $s2, 0x60($sp)
00120CC4 8FB30064 lw         $s3, 0x64($sp)
00120CC8 8FB40068 lw         $s4, 0x68($sp)
00120CCC 8FB5006C lw         $s5, 0x6c($sp)
00120CD0 8FB60070 lw         $s6, 0x70($sp)
00120CD4 8FBF0074 lw         $ra, 0x74($sp)
00120CD8 03E00008 jr         $ra
00120CDC 27BD0080 addiu      $sp, $sp, 0x80