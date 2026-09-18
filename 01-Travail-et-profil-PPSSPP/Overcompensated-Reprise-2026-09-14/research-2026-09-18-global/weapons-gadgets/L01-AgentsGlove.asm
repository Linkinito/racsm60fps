
CALLBACK 0x0010FCA0 end 0x0010FD2C ordinal 0

0010FCA0 27BDFFD0 addiu      $sp, $sp, -0x30
0010FCA4 AFB00020 sw         $s0, 0x20($sp)
0010FCA8 8C900058 lw         $s0, 0x58($a0)
0010FCAC 00002825 move       $a1, $zero
0010FCB0 02002025 move       $a0, $s0
0010FCB4 AFBF0024 sw         $ra, 0x24($sp)
0010FCB8 0C06B6A7 jal        0x1ada9c
0010FCBC 34060048 ori        $a2, $zero, 0x48
0010FCC0 3C04002B lui        $a0, 0x2b
0010FCC4 8C8400C0 lw         $a0, 0xc0($a0)
0010FCC8 3C05002D lui        $a1, 0x2d
0010FCCC C4ACD3B4 lwc1       $f12, -0x2c4c($a1)
0010FCD0 3C05002D lui        $a1, 0x2d
0010FCD4 C4ADD3B8 lwc1       $f13, -0x2c48($a1)
0010FCD8 3C05002D lui        $a1, 0x2d
0010FCDC 3C084120 lui        $t0, 0x4120
0010FCE0 3C06002D lui        $a2, 0x2d
0010FCE4 44887000 mtc1       $t0, $f14
0010FCE8 00003825 move       $a3, $zero
0010FCEC 24A5D3A8 addiu      $a1, $a1, -0x2c58
0010FCF0 0C01707F jal        0x5c1fc
0010FCF4 24C6D3C0 addiu      $a2, $a2, -0x2c40
0010FCF8 26040018 addiu      $a0, $s0, 0x18
0010FCFC 3C08002B lui        $t0, 0x2b
0010FD00 34100001 ori        $s0, $zero, 1
0010FD04 34050001 ori        $a1, $zero, 1
0010FD08 34060044 ori        $a2, $zero, 0x44
0010FD0C 34070045 ori        $a3, $zero, 0x45
0010FD10 0C019B8F jal        0x66e3c
0010FD14 250828D8 addiu      $t0, $t0, 0x28d8
0010FD18 02001025 move       $v0, $s0
0010FD1C 8FB00020 lw         $s0, 0x20($sp)
0010FD20 8FBF0024 lw         $ra, 0x24($sp)
0010FD24 03E00008 jr         $ra
0010FD28 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x0010FD2C end 0x0010FD58 ordinal 1

0010FD2C 27BDFFE0 addiu      $sp, $sp, -0x20
0010FD30 8C840058 lw         $a0, 0x58($a0)
0010FD34 8C840000 lw         $a0, ($a0)
0010FD38 AFBF0010 sw         $ra, 0x10($sp)
0010FD3C 10800003 beqz       $a0, 0x10fd4c
0010FD40 00000000 nop        
0010FD44 0C00C2D1 jal        0x30b44
0010FD48 34050001 ori        $a1, $zero, 1
0010FD4C 8FBF0010 lw         $ra, 0x10($sp)
0010FD50 03E00008 jr         $ra
0010FD54 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0010FD58 end 0x00110228 ordinal 2

0010FD58 27BDFF80 addiu      $sp, $sp, -0x80
0010FD5C AFB00054 sw         $s0, 0x54($sp)
0010FD60 00808025 move       $s0, $a0
0010FD64 AFB2005C sw         $s2, 0x5c($sp)
0010FD68 8E120058 lw         $s2, 0x58($s0)
0010FD6C AFB10058 sw         $s1, 0x58($sp)
0010FD70 34040005 ori        $a0, $zero, 5
0010FD74 8E510000 lw         $s1, ($s2)
0010FD78 E7B4004C swc1       $f20, 0x4c($sp)
0010FD7C E7B60050 swc1       $f22, 0x50($sp)
0010FD80 AFB30060 sw         $s3, 0x60($sp)
0010FD84 AFB40064 sw         $s4, 0x64($sp)
0010FD88 AFB50068 sw         $s5, 0x68($sp)
0010FD8C AFB6006C sw         $s6, 0x6c($sp)
0010FD90 AFB70070 sw         $s7, 0x70($sp)
0010FD94 AFBF0074 sw         $ra, 0x74($sp)
0010FD98 0C007DC7 jal        0x1f71c
0010FD9C 8E2500F0 lw         $a1, 0xf0($s1)
0010FDA0 00409825 move       $s3, $v0
0010FDA4 0C00C4DA jal        0x31368
0010FDA8 27A40020 addiu      $a0, $sp, 0x20
0010FDAC 3C040006 lui        $a0, 6
0010FDB0 2484A838 addiu      $a0, $a0, -0x57c8
0010FDB4 8C940594 lw         $s4, 0x594($a0)
0010FDB8 02202025 move       $a0, $s1
0010FDBC 0C00C2D1 jal        0x30b44
0010FDC0 00002825 move       $a1, $zero
0010FDC4 C64C0040 lwc1       $f12, 0x40($s2)
0010FDC8 4480A000 mtc1       $zero, $f20
0010FDCC 46146032 c.eq.s     $f12, $f20
0010FDD0 00000000 nop        
0010FDD4 45010099 bc1t       0x11003c
0010FDD8 00000000 nop        
0010FDDC 0C00C428 jal        0x310a0
0010FDE0 00000000 nop        
0010FDE4 C64C0040 lwc1       $f12, 0x40($s2)
0010FDE8 3C04BF80 lui        $a0, 0xbf80
0010FDEC 44846800 mtc1       $a0, $f13
0010FDF0 460D6300 add.s      $f12, $f12, $f13
0010FDF4 00402025 move       $a0, $v0
0010FDF8 4614603E c.le.s     $f12, $f20
0010FDFC 00000000 nop        
0010FE00 45010010 bc1t       0x10fe44
0010FE04 E64C0040 swc1       $f12, 0x40($s2)
0010FE08 8FA50020 lw         $a1, 0x20($sp)
0010FE0C 30A50020 andi       $a1, $a1, 0x20
0010FE10 10A0008A beqz       $a1, 0x11003c
0010FE14 3405001E ori        $a1, $zero, 0x1e
0010FE18 10850088 beq        $a0, $a1, 0x11003c
0010FE1C 3C04002D lui        $a0, 0x2d
0010FE20 C48CD3CC lwc1       $f12, -0x2c34($a0)
0010FE24 3C04002D lui        $a0, 0x2d
0010FE28 C48DD3D0 lwc1       $f13, -0x2c30($a0)
0010FE2C C64E0040 lwc1       $f14, 0x40($s2)
0010FE30 460D6301 sub.s      $f12, $f12, $f13
0010FE34 460C703E c.le.s     $f14, $f12
0010FE38 00000000 nop        
0010FE3C 4500007F bc1f       0x11003c
0010FE40 00000000 nop        
0010FE44 E6540040 swc1       $f20, 0x40($s2)
0010FE48 922409E4 lbu        $a0, 0x9e4($s1)
0010FE4C 3C17002D lui        $s7, 0x2d
0010FE50 27B50028 addiu      $s5, $sp, 0x28
0010FE54 27B60034 addiu      $s6, $sp, 0x34
0010FE58 1080001D beqz       $a0, 0x10fed0
0010FE5C 26F7D440 addiu      $s7, $s7, -0x2bc0
0010FE60 C62C09E8 lwc1       $f12, 0x9e8($s1)
0010FE64 3C043CA3 lui        $a0, 0x3ca3
0010FE68 E7AC0028 swc1       $f12, 0x28($sp)
0010FE6C C62C09EC lwc1       $f12, 0x9ec($s1)
0010FE70 3484D70A ori        $a0, $a0, 0xd70a
0010FE74 E7AC002C swc1       $f12, 0x2c($sp)
0010FE78 44846800 mtc1       $a0, $f13
0010FE7C C62C09F0 lwc1       $f12, 0x9f0($s1)
0010FE80 E7AC0030 swc1       $f12, 0x30($sp)
0010FE84 C62C09F4 lwc1       $f12, 0x9f4($s1)
0010FE88 C7AE0028 lwc1       $f14, 0x28($sp)
0010FE8C 460D6582 mul.s      $f22, $f12, $f13
0010FE90 C7AC002C lwc1       $f12, 0x2c($sp)
0010FE94 E7B60040 swc1       $f22, 0x40($sp)
0010FE98 C62F09F8 lwc1       $f15, 0x9f8($s1)
0010FE9C 46167580 add.s      $f22, $f14, $f22
0010FEA0 C7B00030 lwc1       $f16, 0x30($sp)
0010FEA4 460D7BC2 mul.s      $f15, $f15, $f13
0010FEA8 E7AF0044 swc1       $f15, 0x44($sp)
0010FEAC 460F6300 add.s      $f12, $f12, $f15
0010FEB0 C63109FC lwc1       $f17, 0x9fc($s1)
0010FEB4 E7B60028 swc1       $f22, 0x28($sp)
0010FEB8 460D8B42 mul.s      $f13, $f17, $f13
0010FEBC E7AC002C swc1       $f12, 0x2c($sp)
0010FEC0 E7AD0048 swc1       $f13, 0x48($sp)
0010FEC4 460D8340 add.s      $f13, $f16, $f13
0010FEC8 10000011 b          0x10ff10
0010FECC E7AD0030 swc1       $f13, 0x30($sp)
0010FED0 3C06002D lui        $a2, 0x2d
0010FED4 02A02025 move       $a0, $s5
0010FED8 02002825 move       $a1, $s0
0010FEDC 0C03D4B1 jal        0xf52c4
0010FEE0 24C6D3C0 addiu      $a2, $a2, -0x2c40
0010FEE4 862400F8 lh         $a0, 0xf8($s1)
0010FEE8 C7B60028 lwc1       $f22, 0x28($sp)
0010FEEC C7AC002C lwc1       $f12, 0x2c($sp)
0010FEF0 34050001 ori        $a1, $zero, 1
0010FEF4 14850006 bne        $a0, $a1, 0x10ff10
0010FEF8 C7AD0030 lwc1       $f13, 0x30($sp)
0010FEFC 3C043DCC lui        $a0, 0x3dcc
0010FF00 3484CCCD ori        $a0, $a0, 0xcccd
0010FF04 44847000 mtc1       $a0, $f14
0010FF08 460E6300 add.s      $f12, $f12, $f14
0010FF0C E7AC002C swc1       $f12, 0x2c($sp)
0010FF10 C64E0004 lwc1       $f14, 4($s2)
0010FF14 46167581 sub.s      $f22, $f14, $f22
0010FF18 E7B60034 swc1       $f22, 0x34($sp)
0010FF1C C64F0008 lwc1       $f15, 8($s2)
0010FF20 460C7B01 sub.s      $f12, $f15, $f12
0010FF24 E7AC0038 swc1       $f12, 0x38($sp)
0010FF28 C650000C lwc1       $f16, 0xc($s2)
0010FF2C 460D8341 sub.s      $f13, $f16, $f13
0010FF30 E7AD003C swc1       $f13, 0x3c($sp)
0010FF34 C6910010 lwc1       $f17, 0x10($s4)
0010FF38 C6920014 lwc1       $f18, 0x14($s4)
0010FF3C 4611B382 mul.s      $f14, $f22, $f17
0010FF40 C6930018 lwc1       $f19, 0x18($s4)
0010FF44 461263C2 mul.s      $f15, $f12, $f18
0010FF48 46136CC2 mul.s      $f19, $f13, $f19
0010FF4C 460F7380 add.s      $f14, $f14, $f15
0010FF50 46137380 add.s      $f14, $f14, $f19
0010FF54 46007407 neg.s      $f16, $f14
0010FF58 46108C42 mul.s      $f17, $f17, $f16
0010FF5C 4611B580 add.s      $f22, $f22, $f17
0010FF60 E7B60034 swc1       $f22, 0x34($sp)
0010FF64 C6920014 lwc1       $f18, 0x14($s4)
0010FF68 46109482 mul.s      $f18, $f18, $f16
0010FF6C 4616B3C2 mul.s      $f15, $f22, $f22
0010FF70 46126300 add.s      $f12, $f12, $f18
0010FF74 3C043480 lui        $a0, 0x3480
0010FF78 E7AC0038 swc1       $f12, 0x38($sp)
0010FF7C 460C6442 mul.s      $f17, $f12, $f12
0010FF80 C6930018 lwc1       $f19, 0x18($s4)
0010FF84 46109C02 mul.s      $f16, $f19, $f16
0010FF88 46117BC0 add.s      $f15, $f15, $f17
0010FF8C 44849000 mtc1       $a0, $f18
0010FF90 46106B40 add.s      $f13, $f13, $f16
0010FF94 460D6802 mul.s      $f0, $f13, $f13
0010FF98 46007BC0 add.s      $f15, $f15, $f0
0010FF9C 4612783C c.lt.s     $f15, $f18
0010FFA0 00000000 nop        
0010FFA4 45000003 bc1f       0x10ffb4
0010FFA8 E7AD003C swc1       $f13, 0x3c($sp)
0010FFAC 1000000C b          0x10ffe0
0010FFB0 4600A586 mov.s      $f22, $f20
0010FFB4 3C043F80 lui        $a0, 0x3f80
0010FFB8 46007BC4 sqrt.s     $f15, $f15
0010FFBC 44848000 mtc1       $a0, $f16
0010FFC0 460F8403 div.s      $f16, $f16, $f15
0010FFC4 4610B442 mul.s      $f17, $f22, $f16
0010FFC8 46106302 mul.s      $f12, $f12, $f16
0010FFCC 46106B42 mul.s      $f13, $f13, $f16
0010FFD0 E7B10034 swc1       $f17, 0x34($sp)
0010FFD4 46007D86 mov.s      $f22, $f15
0010FFD8 E7AC0038 swc1       $f12, 0x38($sp)
0010FFDC E7AD003C swc1       $f13, 0x3c($sp)
0010FFE0 4614703C c.lt.s     $f14, $f20
0010FFE4 00000000 nop        
0010FFE8 45010008 bc1t       0x11000c
0010FFEC 00000000 nop        
0010FFF0 C6EC0014 lwc1       $f12, 0x14($s7)
0010FFF4 02802025 move       $a0, $s4
0010FFF8 02A02825 move       $a1, $s5
0010FFFC 0C0439DF jal        0x10e77c
00110000 02C03025 move       $a2, $s6
00110004 1000000D b          0x11003c
00110008 00000000 nop        
0011000C 3C04C000 lui        $a0, 0xc000
00110010 44846000 mtc1       $a0, $f12
00110014 C6ED0010 lwc1       $f13, 0x10($s7)
00110018 460C7302 mul.s      $f12, $f14, $f12
0011001C 460D6303 div.s      $f12, $f12, $f13
00110020 0C0697C0 jal        0x1a5f00
00110024 00000000 nop        
00110028 02802025 move       $a0, $s4
0011002C 02A02825 move       $a1, $s5
00110030 4600B303 div.s      $f12, $f22, $f0
00110034 0C0439DF jal        0x10e77c
00110038 02C03025 move       $a2, $s6
0011003C C64C0014 lwc1       $f12, 0x14($s2)
00110040 46146032 c.eq.s     $f12, $f20
00110044 00000000 nop        
00110048 45010009 bc1t       0x110070
0011004C 00000000 nop        
00110050 3C04BF80 lui        $a0, 0xbf80
00110054 44846800 mtc1       $a0, $f13
00110058 460D6300 add.s      $f12, $f12, $f13
0011005C 4614603C c.lt.s     $f12, $f20
00110060 00000000 nop        
00110064 45000002 bc1f       0x110070
00110068 E64C0014 swc1       $f12, 0x14($s2)
0011006C E6540014 swc1       $f20, 0x14($s2)
00110070 8E440010 lw         $a0, 0x10($s2)
00110074 34050004 ori        $a1, $zero, 4
00110078 14850007 bne        $a0, $a1, 0x110098
0011007C 00000000 nop        
00110080 02002025 move       $a0, $s0
00110084 0C01AA82 jal        0x6aa08
00110088 00002825 move       $a1, $zero
0011008C 10400002 beqz       $v0, 0x110098
00110090 00000000 nop        
00110094 A2000045 sb         $zero, 0x45($s0)
00110098 C64C0014 lwc1       $f12, 0x14($s2)
0011009C 46146032 c.eq.s     $f12, $f20
001100A0 00000000 nop        
001100A4 45000045 bc1f       0x1101bc
001100A8 00000000 nop        
001100AC 0C007956 jal        0x1e558
001100B0 02202025 move       $a0, $s1
001100B4 10400041 beqz       $v0, 0x1101bc
001100B8 00000000 nop        
001100BC 8FA40020 lw         $a0, 0x20($sp)
001100C0 30840020 andi       $a0, $a0, 0x20
001100C4 1080003D beqz       $a0, 0x1101bc
001100C8 00000000 nop        
001100CC 0C0425AA jal        0x1096a8
001100D0 00000000 nop        
001100D4 10400039 beqz       $v0, 0x1101bc
001100D8 00000000 nop        
001100DC 0C00C4BD jal        0x312f4
001100E0 8E440000 lw         $a0, ($s2)
001100E4 02202025 move       $a0, $s1
001100E8 0C016FD5 jal        0x5bf54
001100EC 00408825 move       $s1, $v0
001100F0 3C09002D lui        $t1, 0x2d
001100F4 3C0A90AE lui        $t2, 0x90ae
001100F8 26470004 addiu      $a3, $s2, 4
001100FC 26480018 addiu      $t0, $s2, 0x18
00110100 02002025 move       $a0, $s0
00110104 02202825 move       $a1, $s1
00110108 00403025 move       $a2, $v0
0011010C 00005825 move       $t3, $zero
00110110 2529D440 addiu      $t1, $t1, -0x2bc0
00110114 0C0174CD jal        0x5d334
00110118 254AE4EB addiu      $t2, $t2, -0x1b15
0011011C A2420045 sb         $v0, 0x45($s2)
00110120 92440045 lbu        $a0, 0x45($s2)
00110124 10800025 beqz       $a0, 0x1101bc
00110128 00000000 nop        
0011012C 92040045 lbu        $a0, 0x45($s0)
00110130 10800003 beqz       $a0, 0x110140
00110134 34050005 ori        $a1, $zero, 5
00110138 14850020 bne        $a0, $a1, 0x1101bc
0011013C 00000000 nop        
00110140 0C01D56F jal        0x755bc
00110144 34040002 ori        $a0, $zero, 2
00110148 8C440004 lw         $a0, 4($v0)
0011014C 30842000 andi       $a0, $a0, 0x2000
00110150 1080001A beqz       $a0, 0x1101bc
00110154 00000000 nop        
00110158 8E640040 lw         $a0, 0x40($s3)
0011015C 3C05002D lui        $a1, 0x2d
00110160 2484FFFF addiu      $a0, $a0, -1
00110164 AE640040 sw         $a0, 0x40($s3)
00110168 C4ACD3BC lwc1       $f12, -0x2c44($a1)
0011016C 3C04002D lui        $a0, 0x2d
00110170 E64C0014 swc1       $f12, 0x14($s2)
00110174 C48CD3CC lwc1       $f12, -0x2c34($a0)
00110178 34040005 ori        $a0, $zero, 5
0011017C E64C0040 swc1       $f12, 0x40($s2)
00110180 A2040045 sb         $a0, 0x45($s0)
00110184 A2400045 sb         $zero, 0x45($s2)
00110188 3C05002D lui        $a1, 0x2d
0011018C 8CA5C588 lw         $a1, -0x3a78($a1)
00110190 34040009 ori        $a0, $zero, 9
00110194 14A40009 bne        $a1, $a0, 0x1101bc
00110198 3C040009 lui        $a0, 9
0011019C 2484C928 addiu      $a0, $a0, -0x36d8
001101A0 9085000D lbu        $a1, 0xd($a0)
001101A4 18A00005 blez       $a1, 0x1101bc
001101A8 28A50040 slti       $a1, $a1, 0x40
001101AC 10A00003 beqz       $a1, 0x1101bc
001101B0 00000000 nop        
001101B4 34050080 ori        $a1, $zero, 0x80
001101B8 A085000D sb         $a1, 0xd($a0)
001101BC C7B4004C lwc1       $f20, 0x4c($sp)
001101C0 C7B60050 lwc1       $f22, 0x50($sp)
001101C4 8FB00054 lw         $s0, 0x54($sp)
001101C8 8FB10058 lw         $s1, 0x58($sp)
001101CC 8FB2005C lw         $s2, 0x5c($sp)
001101D0 8FB30060 lw         $s3, 0x60($sp)
001101D4 8FB40064 lw         $s4, 0x64($sp)
001101D8 8FB50068 lw         $s5, 0x68($sp)
001101DC 8FB6006C lw         $s6, 0x6c($sp)
001101E0 8FB70070 lw         $s7, 0x70($sp)
001101E4 8FBF0074 lw         $ra, 0x74($sp)
001101E8 03E00008 jr         $ra
001101EC 27BD0080 addiu      $sp, $sp, 0x80
001101F0 3C04002D lui        $a0, 0x2d
001101F4 2485D3D4 addiu      $a1, $a0, -0x2c2c
001101F8 8C84D3D4 lw         $a0, -0x2c2c($a0)
001101FC 8CA60004 lw         $a2, 4($a1)
00110200 8CA50008 lw         $a1, 8($a1)
00110204 3C07002D lui        $a3, 0x2d
00110208 24E8D440 addiu      $t0, $a3, -0x2bc0
0011020C ACE4D440 sw         $a0, -0x2bc0($a3)
00110210 3C04002D lui        $a0, 0x2d
00110214 AD060004 sw         $a2, 4($t0)
00110218 C48CD270 lwc1       $f12, -0x2d90($a0)
0011021C AD050008 sw         $a1, 8($t0)
00110220 03E00008 jr         $ra
00110224 E50C0010 swc1       $f12, 0x10($t0)