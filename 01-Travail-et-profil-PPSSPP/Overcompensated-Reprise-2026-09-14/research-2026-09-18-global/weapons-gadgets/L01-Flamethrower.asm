
CALLBACK 0x0013A964 end 0x0013AA8C ordinal 0

0013A964 27BDFFD0 addiu      $sp, $sp, -0x30
0013A968 AFB00020 sw         $s0, 0x20($sp)
0013A96C 00808025 move       $s0, $a0
0013A970 AFB20028 sw         $s2, 0x28($sp)
0013A974 8E120058 lw         $s2, 0x58($s0)
0013A978 8E040048 lw         $a0, 0x48($s0)
0013A97C 3C050014 lui        $a1, 0x14
0013A980 24A5C3D8 addiu      $a1, $a1, -0x3c28
0013A984 AC8500DC sw         $a1, 0xdc($a0)
0013A988 8E040058 lw         $a0, 0x58($s0)
0013A98C 00002825 move       $a1, $zero
0013A990 AFB10024 sw         $s1, 0x24($sp)
0013A994 AFBF002C sw         $ra, 0x2c($sp)
0013A998 0C06B6A7 jal        0x1ada9c
0013A99C 3406027C ori        $a2, $zero, 0x27c
0013A9A0 3C11002B lui        $s1, 0x2b
0013A9A4 8E2500C0 lw         $a1, 0xc0($s1)
0013A9A8 3404000A ori        $a0, $zero, 0xa
0013A9AC 0C007FEF jal        0x1ffbc
0013A9B0 8CA500F0 lw         $a1, 0xf0($a1)
0013A9B4 3C05F801 lui        $a1, 0xf801
0013A9B8 24A5FFFF addiu      $a1, $a1, -1
0013A9BC 3C06002D lui        $a2, 0x2d
0013A9C0 1040000B beqz       $v0, 0x13a9f0
0013A9C4 3C040009 lui        $a0, 9
0013A9C8 3C07002D lui        $a3, 0x2d
0013A9CC C4EC19B8 lwc1       $f12, 0x19b8($a3)
0013A9D0 E64C0278 swc1       $f12, 0x278($s2)
0013A9D4 8CC71A1C lw         $a3, 0x1a1c($a2)
0013A9D8 8C88CF10 lw         $t0, -0x30f0($a0)
0013A9DC 00E59024 and        $s2, $a3, $a1
0013A9E0 00082C00 sll        $a1, $t0, 0x10
0013A9E4 8E2400C0 lw         $a0, 0xc0($s1)
0013A9E8 1000000A b          0x13aa14
0013A9EC 02459025 or         $s2, $s2, $a1
0013A9F0 3C07002D lui        $a3, 0x2d
0013A9F4 C4EC198C lwc1       $f12, 0x198c($a3)
0013A9F8 E64C0278 swc1       $f12, 0x278($s2)
0013A9FC 8CC71A1C lw         $a3, 0x1a1c($a2)
0013AA00 8C88CF10 lw         $t0, -0x30f0($a0)
0013AA04 00E59024 and        $s2, $a3, $a1
0013AA08 00082C00 sll        $a1, $t0, 0x10
0013AA0C 8E2400C0 lw         $a0, 0xc0($s1)
0013AA10 02459025 or         $s2, $s2, $a1
0013AA14 ACD21A1C sw         $s2, 0x1a1c($a2)
0013AA18 8C8600F0 lw         $a2, 0xf0($a0)
0013AA1C 26040074 addiu      $a0, $s0, 0x74
0013AA20 3405000A ori        $a1, $zero, 0xa
0013AA24 0C0077E7 jal        0x1df9c
0013AA28 2407FFFF addiu      $a3, $zero, -1
0013AA2C 8E2400C0 lw         $a0, 0xc0($s1)
0013AA30 3C05002D lui        $a1, 0x2d
0013AA34 C4AC19D8 lwc1       $f12, 0x19d8($a1)
0013AA38 3C05002D lui        $a1, 0x2d
0013AA3C C4AD19DC lwc1       $f13, 0x19dc($a1)
0013AA40 3C05002D lui        $a1, 0x2d
0013AA44 C4AE19E0 lwc1       $f14, 0x19e0($a1)
0013AA48 3C05002D lui        $a1, 0x2d
0013AA4C 3C06002D lui        $a2, 0x2d
0013AA50 34070001 ori        $a3, $zero, 1
0013AA54 24A519CC addiu      $a1, $a1, 0x19cc
0013AA58 0C01707F jal        0x5c1fc
0013AA5C 24C6A34C addiu      $a2, $a2, -0x5cb4
0013AA60 8E040064 lw         $a0, 0x64($s0)
0013AA64 3C050004 lui        $a1, 4
0013AA68 00852025 or         $a0, $a0, $a1
0013AA6C AE040064 sw         $a0, 0x64($s0)
0013AA70 34020001 ori        $v0, $zero, 1
0013AA74 8FB00020 lw         $s0, 0x20($sp)
0013AA78 8FB10024 lw         $s1, 0x24($sp)
0013AA7C 8FB20028 lw         $s2, 0x28($sp)
0013AA80 8FBF002C lw         $ra, 0x2c($sp)
0013AA84 03E00008 jr         $ra
0013AA88 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x0013AAE0 end 0x0013AB84 ordinal 1

0013AAE0 27BDFFD0 addiu      $sp, $sp, -0x30
0013AAE4 AFB3001C sw         $s3, 0x1c($sp)
0013AAE8 8C930058 lw         $s3, 0x58($a0)
0013AAEC 8E640008 lw         $a0, 8($s3)
0013AAF0 AFB00010 sw         $s0, 0x10($sp)
0013AAF4 AFB10014 sw         $s1, 0x14($sp)
0013AAF8 AFB20018 sw         $s2, 0x18($sp)
0013AAFC AFBF0020 sw         $ra, 0x20($sp)
0013AB00 10800018 beqz       $a0, 0x13ab64
0013AB04 00000000 nop        
0013AB08 8E650004 lw         $a1, 4($s3)
0013AB0C 34120000 ori        $s2, $zero, 0
0013AB10 0245202B sltu       $a0, $s2, $a1
0013AB14 10800013 beqz       $a0, 0x13ab64
0013AB18 02608825 move       $s1, $s3
0013AB1C 3C10002B lui        $s0, 0x2b
0013AB20 8E240018 lw         $a0, 0x18($s1)
0013AB24 1080000A beqz       $a0, 0x13ab50
0013AB28 00000000 nop        
0013AB2C 8E053058 lw         $a1, 0x3058($s0)
0013AB30 14850004 bne        $a0, $a1, 0x13ab44
0013AB34 00000000 nop        
0013AB38 AE003058 sw         $zero, 0x3058($s0)
0013AB3C 10000004 b          0x13ab50
0013AB40 8E650004 lw         $a1, 4($s3)
0013AB44 0C023293 jal        0x8ca4c
0013AB48 00000000 nop        
0013AB4C 8E650004 lw         $a1, 4($s3)
0013AB50 AE200018 sw         $zero, 0x18($s1)
0013AB54 26520001 addiu      $s2, $s2, 1
0013AB58 0245202B sltu       $a0, $s2, $a1
0013AB5C 1480FFF0 bnez       $a0, 0x13ab20
0013AB60 26310004 addiu      $s1, $s1, 4
0013AB64 AE600000 sw         $zero, ($s3)
0013AB68 8FB00010 lw         $s0, 0x10($sp)
0013AB6C 8FB10014 lw         $s1, 0x14($sp)
0013AB70 8FB20018 lw         $s2, 0x18($sp)
0013AB74 8FB3001C lw         $s3, 0x1c($sp)
0013AB78 8FBF0020 lw         $ra, 0x20($sp)
0013AB7C 03E00008 jr         $ra
0013AB80 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x0013B8F0 end 0x0013BBEC ordinal 2

0013B8F0 27BDFFB0 addiu      $sp, $sp, -0x50
0013B8F4 AFB0002C sw         $s0, 0x2c($sp)
0013B8F8 00808025 move       $s0, $a0
0013B8FC AFB10030 sw         $s1, 0x30($sp)
0013B900 8E110058 lw         $s1, 0x58($s0)
0013B904 AFB20034 sw         $s2, 0x34($sp)
0013B908 AFB30038 sw         $s3, 0x38($sp)
0013B90C 34120001 ori        $s2, $zero, 1
0013B910 8E330000 lw         $s3, ($s1)
0013B914 A2320015 sb         $s2, 0x15($s1)
0013B918 27A40020 addiu      $a0, $sp, 0x20
0013B91C E7B40028 swc1       $f20, 0x28($sp)
0013B920 AFB4003C sw         $s4, 0x3c($sp)
0013B924 AFB50040 sw         $s5, 0x40($sp)
0013B928 AFB60044 sw         $s6, 0x44($sp)
0013B92C AFBF0048 sw         $ra, 0x48($sp)
0013B930 0C00C4D4 jal        0x31350
0013B934 02602825 move       $a1, $s3
0013B938 8E6500F0 lw         $a1, 0xf0($s3)
0013B93C 0C007DC7 jal        0x1f71c
0013B940 3404000A ori        $a0, $zero, 0xa
0013B944 92040046 lbu        $a0, 0x46($s0)
0013B948 34050001 ori        $a1, $zero, 1
0013B94C 14850056 bne        $a0, $a1, 0x13baa8
0013B950 0040A025 move       $s4, $v0
0013B954 8E240000 lw         $a0, ($s1)
0013B958 C60C0070 lwc1       $f12, 0x70($s0)
0013B95C 8C9500D4 lw         $s5, 0xd4($a0)
0013B960 3C043F80 lui        $a0, 0x3f80
0013B964 44846800 mtc1       $a0, $f13
0013B968 460D6300 add.s      $f12, $f12, $f13
0013B96C 26240010 addiu      $a0, $s1, 0x10
0013B970 3C05002D lui        $a1, 0x2d
0013B974 4480A000 mtc1       $zero, $f20
0013B978 E60C0070 swc1       $f12, 0x70($s0)
0013B97C C48C0000 lwc1       $f12, ($a0)
0013B980 460D6300 add.s      $f12, $f12, $f13
0013B984 E48C0000 swc1       $f12, ($a0)
0013B988 C48E0000 lwc1       $f14, ($a0)
0013B98C C4AC19B0 lwc1       $f12, 0x19b0($a1)
0013B990 460C703E c.le.s     $f14, $f12
0013B994 00000000 nop        
0013B998 45020001 bc1fl      0x13b9a0
0013B99C E48C0000 swc1       $f12, ($a0)
0013B9A0 C60C0070 lwc1       $f12, 0x70($s0)
0013B9A4 3C04002D lui        $a0, 0x2d
0013B9A8 C48D19A0 lwc1       $f13, 0x19a0($a0)
0013B9AC 460D603C c.lt.s     $f12, $f13
0013B9B0 00000000 nop        
0013B9B4 45010006 bc1t       0x13b9d0
0013B9B8 00000000 nop        
0013B9BC 460D6301 sub.s      $f12, $f12, $f13
0013B9C0 E60C0070 swc1       $f12, 0x70($s0)
0013B9C4 8E840040 lw         $a0, 0x40($s4)
0013B9C8 2484FFFF addiu      $a0, $a0, -1
0013B9CC AE840040 sw         $a0, 0x40($s4)
0013B9D0 0C04EEFB jal        0x13bbec
0013B9D4 02002025 move       $a0, $s0
0013B9D8 3C05002D lui        $a1, 0x2d
0013B9DC C4AC19AC lwc1       $f12, 0x19ac($a1)
0013B9E0 3C05FF23 lui        $a1, 0xff23
0013B9E4 26040030 addiu      $a0, $s0, 0x30
0013B9E8 0C01E7FC jal        0x79ff0
0013B9EC 24A599FF addiu      $a1, $a1, -0x6601
0013B9F0 32A42000 andi       $a0, $s5, 0x2000
0013B9F4 1080000A beqz       $a0, 0x13ba20
0013B9F8 00000000 nop        
0013B9FC 8E840040 lw         $a0, 0x40($s4)
0013BA00 10800007 beqz       $a0, 0x13ba20
0013BA04 00000000 nop        
0013BA08 8E240000 lw         $a0, ($s1)
0013BA0C C48C0964 lwc1       $f12, 0x964($a0)
0013BA10 4614603E c.le.s     $f12, $f20
0013BA14 00000000 nop        
0013BA18 45000016 bc1f       0x13ba74
0013BA1C 00000000 nop        
0013BA20 A2000045 sb         $zero, 0x45($s0)
0013BA24 4600A346 mov.s      $f13, $f20
0013BA28 A2000046 sb         $zero, 0x46($s0)
0013BA2C 3C07002D lui        $a3, 0x2d
0013BA30 C4EC1988 lwc1       $f12, 0x1988($a3)
0013BA34 02002025 move       $a0, $s0
0013BA38 00002825 move       $a1, $zero
0013BA3C 00003025 move       $a2, $zero
0013BA40 0C01AB54 jal        0x6ad50
0013BA44 34070001 ori        $a3, $zero, 1
0013BA48 3404012C ori        $a0, $zero, 0x12c
0013BA4C AE240008 sw         $a0, 8($s1)
0013BA50 E634000C swc1       $f20, 0xc($s1)
0013BA54 8E6600F0 lw         $a2, 0xf0($s3)
0013BA58 3404000A ori        $a0, $zero, 0xa
0013BA5C 0C007F68 jal        0x1fda0
0013BA60 3405001A ori        $a1, $zero, 0x1a
0013BA64 1040000E beqz       $v0, 0x13baa0
0013BA68 00000000 nop        
0013BA6C 1000000C b          0x13baa0
0013BA70 A2320016 sb         $s2, 0x16($s1)
0013BA74 866400F8 lh         $a0, 0xf8($s3)
0013BA78 3405003E ori        $a1, $zero, 0x3e
0013BA7C 10850008 beq        $a0, $a1, 0x13baa0
0013BA80 00000000 nop        
0013BA84 C66C0264 lwc1       $f12, 0x264($s3)
0013BA88 46146032 c.eq.s     $f12, $f20
0013BA8C 00000000 nop        
0013BA90 45000003 bc1f       0x13baa0
0013BA94 00000000 nop        
0013BA98 34040009 ori        $a0, $zero, 9
0013BA9C A2040045 sb         $a0, 0x45($s0)
0013BAA0 10000047 b          0x13bbc0
0013BAA4 00000000 nop        
0013BAA8 8FA40020 lw         $a0, 0x20($sp)
0013BAAC 30840020 andi       $a0, $a0, 0x20
0013BAB0 1080002F beqz       $a0, 0x13bb70
0013BAB4 00000000 nop        
0013BAB8 0C007956 jal        0x1e558
0013BABC 02602025 move       $a0, $s3
0013BAC0 1040002B beqz       $v0, 0x13bb70
0013BAC4 00000000 nop        
0013BAC8 8E240000 lw         $a0, ($s1)
0013BACC 8C8400D4 lw         $a0, 0xd4($a0)
0013BAD0 30842000 andi       $a0, $a0, 0x2000
0013BAD4 10800026 beqz       $a0, 0x13bb70
0013BAD8 00000000 nop        
0013BADC 8E240004 lw         $a0, 4($s1)
0013BAE0 34140000 ori        $s4, $zero, 0
0013BAE4 0284282B sltu       $a1, $s4, $a0
0013BAE8 10A00013 beqz       $a1, 0x13bb38
0013BAEC 0220A825 move       $s5, $s1
0013BAF0 3C16002B lui        $s6, 0x2b
0013BAF4 8EA50018 lw         $a1, 0x18($s5)
0013BAF8 10A0000A beqz       $a1, 0x13bb24
0013BAFC 00000000 nop        
0013BB00 8EC43058 lw         $a0, 0x3058($s6)
0013BB04 14A40004 bne        $a1, $a0, 0x13bb18
0013BB08 00000000 nop        
0013BB0C AEC03058 sw         $zero, 0x3058($s6)
0013BB10 10000004 b          0x13bb24
0013BB14 8E240004 lw         $a0, 4($s1)
0013BB18 0C023293 jal        0x8ca4c
0013BB1C 00A02025 move       $a0, $a1
0013BB20 8E240004 lw         $a0, 4($s1)
0013BB24 AEA00018 sw         $zero, 0x18($s5)
0013BB28 26940001 addiu      $s4, $s4, 1
0013BB2C 0284282B sltu       $a1, $s4, $a0
0013BB30 14A0FFF0 bnez       $a1, 0x13baf4
0013BB34 26B50004 addiu      $s5, $s5, 4
0013BB38 AE200004 sw         $zero, 4($s1)
0013BB3C 44806800 mtc1       $zero, $f13
0013BB40 AE200008 sw         $zero, 8($s1)
0013BB44 A2320014 sb         $s2, 0x14($s1)
0013BB48 A2120046 sb         $s2, 0x46($s0)
0013BB4C 34040009 ori        $a0, $zero, 9
0013BB50 A2040045 sb         $a0, 0x45($s0)
0013BB54 3C08002D lui        $t0, 0x2d
0013BB58 02002025 move       $a0, $s0
0013BB5C 34050003 ori        $a1, $zero, 3
0013BB60 00003025 move       $a2, $zero
0013BB64 34070001 ori        $a3, $zero, 1
0013BB68 0C01AB54 jal        0x6ad50
0013BB6C C50C1988 lwc1       $f12, 0x1988($t0)
0013BB70 8E240018 lw         $a0, 0x18($s1)
0013BB74 1080000B beqz       $a0, 0x13bba4
0013BB78 00000000 nop        
0013BB7C 8E050064 lw         $a1, 0x64($s0)
0013BB80 90860005 lbu        $a2, 5($a0)
0013BB84 30A40020 andi       $a0, $a1, 0x20
0013BB88 00042942 srl        $a1, $a0, 5
0013BB8C 10C50005 beq        $a2, $a1, 0x13bba4
0013BB90 00000000 nop        
0013BB94 0004282B sltu       $a1, $zero, $a0
0013BB98 30A500FF andi       $a1, $a1, 0xff
0013BB9C 0C04EC73 jal        0x13b1cc
0013BBA0 02002025 move       $a0, $s0
0013BBA4 8E6600F0 lw         $a2, 0xf0($s3)
0013BBA8 3404000A ori        $a0, $zero, 0xa
0013BBAC 0C007F68 jal        0x1fda0
0013BBB0 3405001A ori        $a1, $zero, 0x1a
0013BBB4 10400002 beqz       $v0, 0x13bbc0
0013BBB8 00000000 nop        
0013BBBC A2320016 sb         $s2, 0x16($s1)
0013BBC0 C7B40028 lwc1       $f20, 0x28($sp)
0013BBC4 8FB0002C lw         $s0, 0x2c($sp)
0013BBC8 8FB10030 lw         $s1, 0x30($sp)
0013BBCC 8FB20034 lw         $s2, 0x34($sp)
0013BBD0 8FB30038 lw         $s3, 0x38($sp)
0013BBD4 8FB4003C lw         $s4, 0x3c($sp)
0013BBD8 8FB50040 lw         $s5, 0x40($sp)
0013BBDC 8FB60044 lw         $s6, 0x44($sp)
0013BBE0 8FBF0048 lw         $ra, 0x48($sp)
0013BBE4 03E00008 jr         $ra
0013BBE8 27BD0050 addiu      $sp, $sp, 0x50