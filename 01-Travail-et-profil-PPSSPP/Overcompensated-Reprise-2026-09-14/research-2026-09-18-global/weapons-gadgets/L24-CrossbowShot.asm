
CALLBACK 0x00119A24 end 0x00119A2C ordinal 0

00119A24 03E00008 jr         $ra
00119A28 34020001 ori        $v0, $zero, 1

CALLBACK 0x00119A2C end 0x00119A68 ordinal 1

00119A2C 27BDFFE0 addiu      $sp, $sp, -0x20
00119A30 8C840058 lw         $a0, 0x58($a0)
00119A34 9085025D lbu        $a1, 0x25d($a0)
00119A38 AFBF0014 sw         $ra, 0x14($sp)
00119A3C 10A00007 beqz       $a1, 0x119a5c
00119A40 00000000 nop        
00119A44 AFA40010 sw         $a0, 0x10($sp)
00119A48 0C035479 jal        0xd51e4
00119A4C 2484013C addiu      $a0, $a0, 0x13c
00119A50 8FA40010 lw         $a0, 0x10($sp)
00119A54 0C035479 jal        0xd51e4
00119A58 24840198 addiu      $a0, $a0, 0x198
00119A5C 8FBF0014 lw         $ra, 0x14($sp)
00119A60 03E00008 jr         $ra
00119A64 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0011AF6C end 0x0011B784 ordinal 2

0011AF6C 27BDFF20 addiu      $sp, $sp, -0xe0
0011AF70 AFB000B4 sw         $s0, 0xb4($sp)
0011AF74 00808025 move       $s0, $a0
0011AF78 92040045 lbu        $a0, 0x45($s0)
0011AF7C E7B4009C swc1       $f20, 0x9c($sp)
0011AF80 28850002 slti       $a1, $a0, 2
0011AF84 E7B600A0 swc1       $f22, 0xa0($sp)
0011AF88 E7B800A4 swc1       $f24, 0xa4($sp)
0011AF8C E7BA00A8 swc1       $f26, 0xa8($sp)
0011AF90 E7BC00AC swc1       $f28, 0xac($sp)
0011AF94 E7BE00B0 swc1       $f30, 0xb0($sp)
0011AF98 AFB100B8 sw         $s1, 0xb8($sp)
0011AF9C AFB200BC sw         $s2, 0xbc($sp)
0011AFA0 AFB300C0 sw         $s3, 0xc0($sp)
0011AFA4 AFB400C4 sw         $s4, 0xc4($sp)
0011AFA8 AFB500C8 sw         $s5, 0xc8($sp)
0011AFAC AFB600CC sw         $s6, 0xcc($sp)
0011AFB0 AFB700D0 sw         $s7, 0xd0($sp)
0011AFB4 AFBE00D4 sw         $fp, 0xd4($sp)
0011AFB8 AFBF00D8 sw         $ra, 0xd8($sp)
0011AFBC 10A00007 beqz       $a1, 0x11afdc
0011AFC0 8E1E0058 lw         $fp, 0x58($s0)
0011AFC4 04800137 bltz       $a0, 0x11b4a4
0011AFC8 AFB00094 sw         $s0, 0x94($sp)
0011AFCC 18800035 blez       $a0, 0x11b0a4
0011AFD0 00000000 nop        
0011AFD4 10000008 b          0x11aff8
0011AFD8 00000000 nop        
0011AFDC 28850003 slti       $a1, $a0, 3
0011AFE0 14A00127 bnez       $a1, 0x11b480
0011AFE4 28840004 slti       $a0, $a0, 4
0011AFE8 1480012D bnez       $a0, 0x11b4a0
0011AFEC AFB00094 sw         $s0, 0x94($sp)
0011AFF0 1000012C b          0x11b4a4
0011AFF4 00000000 nop        
0011AFF8 C60C0070 lwc1       $f12, 0x70($s0)
0011AFFC 44806800 mtc1       $zero, $f13
0011B000 3C04BF80 lui        $a0, 0xbf80
0011B004 44847000 mtc1       $a0, $f14
0011B008 460E6300 add.s      $f12, $f12, $f14
0011B00C 460D603E c.le.s     $f12, $f13
0011B010 00000000 nop        
0011B014 45010007 bc1t       0x11b034
0011B018 E60C0070 swc1       $f12, 0x70($s0)
0011B01C 3C04002A lui        $a0, 0x2a
0011B020 C48CEAF8 lwc1       $f12, -0x1508($a0)
0011B024 0C0467F7 jal        0x119fdc
0011B028 02002025 move       $a0, $s0
0011B02C 10400004 beqz       $v0, 0x11b040
0011B030 00000000 nop        
0011B034 AFB00094 sw         $s0, 0x94($sp)
0011B038 1000011A b          0x11b4a4
0011B03C A2000045 sb         $zero, 0x45($s0)
0011B040 8FC40004 lw         $a0, 4($fp)
0011B044 10800012 beqz       $a0, 0x11b090
0011B048 00000000 nop        
0011B04C 8C850064 lw         $a1, 0x64($a0)
0011B050 30A60001 andi       $a2, $a1, 1
0011B054 10C00005 beqz       $a2, 0x11b06c
0011B058 30A60006 andi       $a2, $a1, 6
0011B05C 14C00003 bnez       $a2, 0x11b06c
0011B060 30A50008 andi       $a1, $a1, 8
0011B064 10A00003 beqz       $a1, 0x11b074
0011B068 00000000 nop        
0011B06C 10000008 b          0x11b090
0011B070 A2000045 sb         $zero, 0x45($s0)
0011B074 00803025 move       $a2, $a0
0011B078 27C5004C addiu      $a1, $fp, 0x4c
0011B07C 0C03BC37 jal        0xef0dc
0011B080 02002025 move       $a0, $s0
0011B084 8FC50004 lw         $a1, 4($fp)
0011B088 0C03AB3E jal        0xeacf8
0011B08C 27C4001C addiu      $a0, $fp, 0x1c
0011B090 AFB00094 sw         $s0, 0x94($sp)
0011B094 0C046DE1 jal        0x11b784
0011B098 27C40228 addiu      $a0, $fp, 0x228
0011B09C 10000101 b          0x11b4a4
0011B0A0 00000000 nop        
0011B0A4 0C04669A jal        0x119a68
0011B0A8 02002025 move       $a0, $s0
0011B0AC 8FC50000 lw         $a1, ($fp)
0011B0B0 34040009 ori        $a0, $zero, 9
0011B0B4 8CA600F0 lw         $a2, 0xf0($a1)
0011B0B8 0C0076E2 jal        0x1db88
0011B0BC 34050016 ori        $a1, $zero, 0x16
0011B0C0 10400062 beqz       $v0, 0x11b24c
0011B0C4 00000000 nop        
0011B0C8 93C4025E lbu        $a0, 0x25e($fp)
0011B0CC 1480005F bnez       $a0, 0x11b24c
0011B0D0 00000000 nop        
0011B0D4 8FC40004 lw         $a0, 4($fp)
0011B0D8 1080005C beqz       $a0, 0x11b24c
0011B0DC AFB00094 sw         $s0, 0x94($sp)
0011B0E0 3C13002A lui        $s3, 0x2a
0011B0E4 3C044000 lui        $a0, 0x4000
0011B0E8 4480E000 mtc1       $zero, $f28
0011B0EC C66CEAF4 lwc1       $f12, -0x150c($s3)
0011B0F0 44846800 mtc1       $a0, $f13
0011B0F4 3C04002A lui        $a0, 0x2a
0011B0F8 460D6502 mul.s      $f20, $f12, $f13
0011B0FC C496EAD0 lwc1       $f22, -0x1530($a0)
0011B100 3C053F00 lui        $a1, 0x3f00
0011B104 3C044F80 lui        $a0, 0x4f80
0011B108 44857000 mtc1       $a1, $f14
0011B10C 8FB20094 lw         $s2, 0x94($sp)
0011B110 4484C000 mtc1       $a0, $f24
0011B114 3C053F80 lui        $a1, 0x3f80
0011B118 460EA502 mul.s      $f20, $f20, $f14
0011B11C 26440020 addiu      $a0, $s2, 0x20
0011B120 4485D000 mtc1       $a1, $f26
0011B124 26570010 addiu      $s7, $s2, 0x10
0011B128 34100000 ori        $s0, $zero, 0
0011B12C 27B10030 addiu      $s1, $sp, 0x30
0011B130 27B60058 addiu      $s6, $sp, 0x58
0011B134 AFA40090 sw         $a0, 0x90($sp)
0011B138 27B50040 addiu      $s5, $sp, 0x40
0011B13C 26520030 addiu      $s2, $s2, 0x30
0011B140 27D40218 addiu      $s4, $fp, 0x218
0011B144 44906000 mtc1       $s0, $f12
0011B148 46806320 cvt.s.w    $f12, $f12
0011B14C 06020001 bltzl      $s0, 0x11b154
0011B150 46186300 add.s      $f12, $f12, $f24
0011B154 C66DEAF4 lwc1       $f13, -0x150c($s3)
0011B158 460C6B02 mul.s      $f12, $f13, $f12
0011B15C 46146781 sub.s      $f30, $f12, $f20
0011B160 0C0620CD jal        0x188334
0011B164 4600F306 mov.s      $f12, $f30
0011B168 46000306 mov.s      $f12, $f0
0011B16C 460C6382 mul.s      $f14, $f12, $f12
0011B170 461CF03C c.lt.s     $f30, $f28
0011B174 460ED341 sub.s      $f13, $f26, $f14
0011B178 46006B44 sqrt.s     $f13, $f13
0011B17C 45030001 bc1tl      0x11b184
0011B180 46006B47 neg.s      $f13, $f13
0011B184 46006386 mov.s      $f14, $f12
0011B188 8FA50090 lw         $a1, 0x90($sp)
0011B18C 46006B06 mov.s      $f12, $f13
0011B190 02202025 move       $a0, $s1
0011B194 46007346 mov.s      $f13, $f14
0011B198 0C03B6C8 jal        0xedb20
0011B19C 02E03025 move       $a2, $s7
0011B1A0 E7BC003C swc1       $f28, 0x3c($sp)
0011B1A4 4600B306 mov.s      $f12, $f22
0011B1A8 E7B60058 swc1       $f22, 0x58($sp)
0011B1AC 8FCA0004 lw         $t2, 4($fp)
0011B1B0 02C02025 move       $a0, $s6
0011B1B4 02A02825 move       $a1, $s5
0011B1B8 02403025 move       $a2, $s2
0011B1BC 02203825 move       $a3, $s1
0011B1C0 34080068 ori        $t0, $zero, 0x68
0011B1C4 0C006C84 jal        0x1b210
0011B1C8 00004825 move       $t1, $zero
0011B1CC 8FC40000 lw         $a0, ($fp)
0011B1D0 8FC7000C lw         $a3, 0xc($fp)
0011B1D4 C7AC0058 lwc1       $f12, 0x58($sp)
0011B1D8 93C5025C lbu        $a1, 0x25c($fp)
0011B1DC 8FC90008 lw         $t1, 8($fp)
0011B1E0 0005502B sltu       $t2, $zero, $a1
0011B1E4 34020001 ori        $v0, $zero, 1
0011B1E8 314A00FF andi       $t2, $t2, 0xff
0011B1EC 02402825 move       $a1, $s2
0011B1F0 02203025 move       $a2, $s1
0011B1F4 00004025 move       $t0, $zero
0011B1F8 340B0001 ori        $t3, $zero, 1
0011B1FC 0C046867 jal        0x11a19c
0011B200 AFA20000 sw         $v0, ($sp)
0011B204 00402025 move       $a0, $v0
0011B208 1080000B beqz       $a0, 0x11b238
0011B20C 00000000 nop        
0011B210 AFB20098 sw         $s2, 0x98($sp)
0011B214 8C920058 lw         $s2, 0x58($a0)
0011B218 93C60267 lbu        $a2, 0x267($fp)
0011B21C 26440218 addiu      $a0, $s2, 0x218
0011B220 00063080 sll        $a2, $a2, 2
0011B224 0C060077 jal        0x1801dc
0011B228 02802825 move       $a1, $s4
0011B22C 93C40267 lbu        $a0, 0x267($fp)
0011B230 A2440267 sb         $a0, 0x267($s2)
0011B234 8FB20098 lw         $s2, 0x98($sp)
0011B238 26100001 addiu      $s0, $s0, 1
0011B23C 2E040003 sltiu      $a0, $s0, 3
0011B240 1480FFC0 bnez       $a0, 0x11b144
0011B244 00000000 nop        
0011B248 8FB00094 lw         $s0, 0x94($sp)
0011B24C 8FC40008 lw         $a0, 8($fp)
0011B250 2C840003 sltiu      $a0, $a0, 3
0011B254 14800083 bnez       $a0, 0x11b464
0011B258 AFB00094 sw         $s0, 0x94($sp)
0011B25C 3C044049 lui        $a0, 0x4049
0011B260 34840FDB ori        $a0, $a0, 0xfdb
0011B264 4484D000 mtc1       $a0, $f26
0011B268 8FB40094 lw         $s4, 0x94($sp)
0011B26C 3C043E99 lui        $a0, 0x3e99
0011B270 4480A000 mtc1       $zero, $f20
0011B274 3484999A ori        $a0, $a0, 0x999a
0011B278 4484E000 mtc1       $a0, $f28
0011B27C 03C08825 move       $s1, $fp
0011B280 3C043000 lui        $a0, 0x3000
0011B284 4484C000 mtc1       $a0, $f24
0011B288 3C12002A lui        $s2, 0x2a
0011B28C 3C044000 lui        $a0, 0x4000
0011B290 3C16002A lui        $s6, 0x2a
0011B294 4484B000 mtc1       $a0, $f22
0011B298 34130000 ori        $s3, $zero, 0
0011B29C 26940030 addiu      $s4, $s4, 0x30
0011B2A0 263001F4 addiu      $s0, $s1, 0x1f4
0011B2A4 2635007C addiu      $s5, $s1, 0x7c
0011B2A8 2652EB38 addiu      $s2, $s2, -0x14c8
0011B2AC 26D69B10 addiu      $s6, $s6, -0x64f0
0011B2B0 3C17002A lui        $s7, 0x2a
0011B2B4 0C060057 jal        0x18015c
0011B2B8 00000000 nop        
0011B2BC 44826000 mtc1       $v0, $f12
0011B2C0 46806320 cvt.s.w    $f12, $f12
0011B2C4 46186302 mul.s      $f12, $f12, $f24
0011B2C8 46166302 mul.s      $f12, $f12, $f22
0011B2CC 461A6782 mul.s      $f30, $f12, $f26
0011B2D0 0C05DEE8 jal        0x177ba0
0011B2D4 4600F306 mov.s      $f12, $f30
0011B2D8 E7A0005C swc1       $f0, 0x5c($sp)
0011B2DC 0C05DF32 jal        0x177cc8
0011B2E0 4600F306 mov.s      $f12, $f30
0011B2E4 E7A00064 swc1       $f0, 0x64($sp)
0011B2E8 E7B40060 swc1       $f20, 0x60($sp)
0011B2EC C6EDEAE8 lwc1       $f13, -0x1518($s7)
0011B2F0 3C04002A lui        $a0, 0x2a
0011B2F4 C48EEAEC lwc1       $f14, -0x1514($a0)
0011B2F8 0C060057 jal        0x18015c
0011B2FC 460D7781 sub.s      $f30, $f14, $f13
0011B300 44826000 mtc1       $v0, $f12
0011B304 46806320 cvt.s.w    $f12, $f12
0011B308 C6EFEAE8 lwc1       $f15, -0x1518($s7)
0011B30C C7B0005C lwc1       $f16, 0x5c($sp)
0011B310 46186302 mul.s      $f12, $f12, $f24
0011B314 C68E0000 lwc1       $f14, ($s4)
0011B318 461E6302 mul.s      $f12, $f12, $f30
0011B31C 460C7B00 add.s      $f12, $f15, $f12
0011B320 460C8342 mul.s      $f13, $f16, $f12
0011B324 460D7340 add.s      $f13, $f14, $f13
0011B328 E60D0000 swc1       $f13, ($s0)
0011B32C C7AD0060 lwc1       $f13, 0x60($sp)
0011B330 C6910004 lwc1       $f17, 4($s4)
0011B334 460C6B42 mul.s      $f13, $f13, $f12
0011B338 3C09002A lui        $t1, 0x2a
0011B33C 460D8B40 add.s      $f13, $f17, $f13
0011B340 27A40068 addiu      $a0, $sp, 0x68
0011B344 E60D0004 swc1       $f13, 4($s0)
0011B348 C7AD0064 lwc1       $f13, 0x64($sp)
0011B34C C68F0008 lwc1       $f15, 8($s4)
0011B350 460C6B02 mul.s      $f12, $f13, $f12
0011B354 27A5006C addiu      $a1, $sp, 0x6c
0011B358 02003025 move       $a2, $s0
0011B35C 460C7B00 add.s      $f12, $f15, $f12
0011B360 34070868 ori        $a3, $zero, 0x868
0011B364 00004025 move       $t0, $zero
0011B368 E60C0008 swc1       $f12, 8($s0)
0011B36C C62C01F8 lwc1       $f12, 0x1f8($s1)
0011B370 C64E0008 lwc1       $f14, 8($s2)
0011B374 460E6300 add.s      $f12, $f12, $f14
0011B378 E62C01F8 swc1       $f12, 0x1f8($s1)
0011B37C C52CEAF0 lwc1       $f12, -0x1510($t1)
0011B380 AFA00080 sw         $zero, 0x80($sp)
0011B384 0C0063F5 jal        0x18fd4
0011B388 E7AC0068 swc1       $f12, 0x68($sp)
0011B38C 1040001D beqz       $v0, 0x11b404
0011B390 00000000 nop        
0011B394 8FA40080 lw         $a0, 0x80($sp)
0011B398 1080001A beqz       $a0, 0x11b404
0011B39C 00000000 nop        
0011B3A0 C7AC0068 lwc1       $f12, 0x68($sp)
0011B3A4 C61E0000 lwc1       $f30, ($s0)
0011B3A8 0C061B58 jal        0x186d60
0011B3AC 461C6301 sub.s      $f12, $f12, $f28
0011B3B0 00602825 move       $a1, $v1
0011B3B4 0C061E5E jal        0x187978
0011B3B8 00402025 move       $a0, $v0
0011B3BC 00602825 move       $a1, $v1
0011B3C0 0C061E7C jal        0x1879f0
0011B3C4 00402025 move       $a0, $v0
0011B3C8 3C04002A lui        $a0, 0x2a
0011B3CC C48C9B10 lwc1       $f12, -0x64f0($a0)
0011B3D0 C60D0004 lwc1       $f13, 4($s0)
0011B3D4 46006302 mul.s      $f12, $f12, $f0
0011B3D8 C60E0008 lwc1       $f14, 8($s0)
0011B3DC 460CF300 add.s      $f12, $f30, $f12
0011B3E0 E60C0000 swc1       $f12, ($s0)
0011B3E4 C6CC0004 lwc1       $f12, 4($s6)
0011B3E8 46006302 mul.s      $f12, $f12, $f0
0011B3EC 460C6B00 add.s      $f12, $f13, $f12
0011B3F0 E60C0004 swc1       $f12, 4($s0)
0011B3F4 C6CC0008 lwc1       $f12, 8($s6)
0011B3F8 46006302 mul.s      $f12, $f12, $f0
0011B3FC 460C7300 add.s      $f12, $f14, $f12
0011B400 E60C0008 swc1       $f12, 8($s0)
0011B404 8FC80000 lw         $t0, ($fp)
0011B408 02A02025 move       $a0, $s5
0011B40C 25080010 addiu      $t0, $t0, 0x10
0011B410 02402825 move       $a1, $s2
0011B414 02803025 move       $a2, $s4
0011B418 0C016438 jal        0x590e0
0011B41C 02003825 move       $a3, $s0
0011B420 03D32021 addu       $a0, $fp, $s3
0011B424 34050001 ori        $a1, $zero, 1
0011B428 A0800263 sb         $zero, 0x263($a0)
0011B42C A0850260 sb         $a1, 0x260($a0)
0011B430 26730001 addiu      $s3, $s3, 1
0011B434 2631000C addiu      $s1, $s1, 0xc
0011B438 2610000C addiu      $s0, $s0, 0xc
0011B43C 26520044 addiu      $s2, $s2, 0x44
0011B440 2E640003 sltiu      $a0, $s3, 3
0011B444 1480FF9B bnez       $a0, 0x11b2b4
0011B448 26B5003C addiu      $s5, $s5, 0x3c
0011B44C 8FB00094 lw         $s0, 0x94($sp)
0011B450 34040002 ori        $a0, $zero, 2
0011B454 8E050064 lw         $a1, 0x64($s0)
0011B458 A2040045 sb         $a0, 0x45($s0)
0011B45C 10000005 b          0x11b474
0011B460 34A40020 ori        $a0, $a1, 0x20
0011B464 34040003 ori        $a0, $zero, 3
0011B468 8E050064 lw         $a1, 0x64($s0)
0011B46C A2040045 sb         $a0, 0x45($s0)
0011B470 34A40020 ori        $a0, $a1, 0x20
0011B474 AFB00094 sw         $s0, 0x94($sp)
0011B478 1000000A b          0x11b4a4
0011B47C AE040064 sw         $a0, 0x64($s0)
0011B480 93C40266 lbu        $a0, 0x266($fp)
0011B484 34050003 ori        $a1, $zero, 3
0011B488 14850003 bne        $a0, $a1, 0x11b498
0011B48C 00000000 nop        
0011B490 34040003 ori        $a0, $zero, 3
0011B494 A2040045 sb         $a0, 0x45($s0)
0011B498 10000002 b          0x11b4a4
0011B49C AFB00094 sw         $s0, 0x94($sp)
0011B4A0 AFB00094 sw         $s0, 0x94($sp)
0011B4A4 03C09025 move       $s2, $fp
0011B4A8 34100000 ori        $s0, $zero, 0
0011B4AC 34140001 ori        $s4, $zero, 1
0011B4B0 2653007C addiu      $s3, $s2, 0x7c
0011B4B4 265501F4 addiu      $s5, $s2, 0x1f4
0011B4B8 8FB60094 lw         $s6, 0x94($sp)
0011B4BC 34170001 ori        $s7, $zero, 1
0011B4C0 03D08821 addu       $s1, $fp, $s0
0011B4C4 92240260 lbu        $a0, 0x260($s1)
0011B4C8 10800043 beqz       $a0, 0x11b5d8
0011B4CC 00000000 nop        
0011B4D0 0C0164CE jal        0x59338
0011B4D4 02602025 move       $a0, $s3
0011B4D8 824400AC lb         $a0, 0xac($s2)
0011B4DC 14940032 bne        $a0, $s4, 0x11b5a8
0011B4E0 00000000 nop        
0011B4E4 92240263 lbu        $a0, 0x263($s1)
0011B4E8 1480002F bnez       $a0, 0x11b5a8
0011B4EC 00000000 nop        
0011B4F0 A2370263 sb         $s7, 0x263($s1)
0011B4F4 02C02025 move       $a0, $s6
0011B4F8 0C04674F jal        0x119d3c
0011B4FC 02A02825 move       $a1, $s5
0011B500 0C060057 jal        0x18015c
0011B504 00000000 nop        
0011B508 00408825 move       $s1, $v0
0011B50C 06210004 bgez       $s1, 0x11b520
0011B510 00112023 negu       $a0, $s1
0011B514 30910003 andi       $s1, $a0, 3
0011B518 10000002 b          0x11b524
0011B51C 00118823 negu       $s1, $s1
0011B520 32310003 andi       $s1, $s1, 3
0011B524 2A240002 slti       $a0, $s1, 2
0011B528 1080000A beqz       $a0, 0x11b554
0011B52C 2A240003 slti       $a0, $s1, 3
0011B530 0620001B bltz       $s1, 0x11b5a0
0011B534 00000000 nop        
0011B538 1E20000C bgtz       $s1, 0x11b56c
0011B53C 00000000 nop        
0011B540 34040008 ori        $a0, $zero, 8
0011B544 0C0327CD jal        0xc9f34
0011B548 02A02825 move       $a1, $s5
0011B54C 10000014 b          0x11b5a0
0011B550 00000000 nop        
0011B554 1480000A bnez       $a0, 0x11b580
0011B558 2A240004 slti       $a0, $s1, 4
0011B55C 1480000D bnez       $a0, 0x11b594
0011B560 00000000 nop        
0011B564 1000000E b          0x11b5a0
0011B568 00000000 nop        
0011B56C 34040009 ori        $a0, $zero, 9
0011B570 0C0327CD jal        0xc9f34
0011B574 02A02825 move       $a1, $s5
0011B578 10000009 b          0x11b5a0
0011B57C 00000000 nop        
0011B580 3404000A ori        $a0, $zero, 0xa
0011B584 0C0327CD jal        0xc9f34
0011B588 02A02825 move       $a1, $s5
0011B58C 10000004 b          0x11b5a0
0011B590 00000000 nop        
0011B594 3404000B ori        $a0, $zero, 0xb
0011B598 0C0327CD jal        0xc9f34
0011B59C 02A02825 move       $a1, $s5
0011B5A0 1000000D b          0x11b5d8
0011B5A4 00000000 nop        
0011B5A8 82640030 lb         $a0, 0x30($s3)
0011B5AC 38840003 xori       $a0, $a0, 3
0011B5B0 2C840001 sltiu      $a0, $a0, 1
0011B5B4 308400FF andi       $a0, $a0, 0xff
0011B5B8 10800007 beqz       $a0, 0x11b5d8
0011B5BC 00000000 nop        
0011B5C0 0C016464 jal        0x59190
0011B5C4 02602025 move       $a0, $s3
0011B5C8 93C40266 lbu        $a0, 0x266($fp)
0011B5CC A2200260 sb         $zero, 0x260($s1)
0011B5D0 24840001 addiu      $a0, $a0, 1
0011B5D4 A3C40266 sb         $a0, 0x266($fp)
0011B5D8 26100001 addiu      $s0, $s0, 1
0011B5DC 2652003C addiu      $s2, $s2, 0x3c
0011B5E0 2673003C addiu      $s3, $s3, 0x3c
0011B5E4 2E040003 sltiu      $a0, $s0, 3
0011B5E8 1480FFB5 bnez       $a0, 0x11b4c0
0011B5EC 26B5000C addiu      $s5, $s5, 0xc
0011B5F0 93C4025D lbu        $a0, 0x25d($fp)
0011B5F4 1080004A beqz       $a0, 0x11b720
0011B5F8 00000000 nop        
0011B5FC 3C043F00 lui        $a0, 0x3f00
0011B600 34120000 ori        $s2, $zero, 0
0011B604 4484A000 mtc1       $a0, $f20
0011B608 27B40084 addiu      $s4, $sp, 0x84
0011B60C 27D1013C addiu      $s1, $fp, 0x13c
0011B610 3C17002A lui        $s7, 0x2a
0011B614 3C16002A lui        $s6, 0x2a
0011B618 3C13002A lui        $s3, 0x2a
0011B61C 3C15002A lui        $s5, 0x2a
0011B620 02208025 move       $s0, $s1
0011B624 0C035483 jal        0xd520c
0011B628 02002025 move       $a0, $s0
0011B62C 00022602 srl        $a0, $v0, 0x18
0011B630 2484FFE2 addiu      $a0, $a0, -0x1e
0011B634 00042400 sll        $a0, $a0, 0x10
0011B638 00042403 sra        $a0, $a0, 0x10
0011B63C 1C800005 bgtz       $a0, 0x11b654
0011B640 02002825 move       $a1, $s0
0011B644 0C035479 jal        0xd51e4
0011B648 02002025 move       $a0, $s0
0011B64C 1000002E b          0x11b708
0011B650 A3C0025D sb         $zero, 0x25d($fp)
0011B654 8FC6000C lw         $a2, 0xc($fp)
0011B658 00048600 sll        $s0, $a0, 0x18
0011B65C 8CC40000 lw         $a0, ($a2)
0011B660 3C060100 lui        $a2, 0x100
0011B664 24C6FFFF addiu      $a2, $a2, -1
0011B668 00862024 and        $a0, $a0, $a2
0011B66C 00908025 or         $s0, $a0, $s0
0011B670 00A02025 move       $a0, $a1
0011B674 0C035480 jal        0xd5200
0011B678 02002825 move       $a1, $s0
0011B67C 93C4025F lbu        $a0, 0x25f($fp)
0011B680 10800021 beqz       $a0, 0x11b708
0011B684 00000000 nop        
0011B688 8FA40094 lw         $a0, 0x94($sp)
0011B68C C6ECEAE4 lwc1       $f12, -0x151c($s7)
0011B690 C48D0020 lwc1       $f13, 0x20($a0)
0011B694 C48E0030 lwc1       $f14, 0x30($a0)
0011B698 C48F0024 lwc1       $f15, 0x24($a0)
0011B69C 460C6B42 mul.s      $f13, $f13, $f12
0011B6A0 C4900034 lwc1       $f16, 0x34($a0)
0011B6A4 460C7BC2 mul.s      $f15, $f15, $f12
0011B6A8 C4910028 lwc1       $f17, 0x28($a0)
0011B6AC C4920038 lwc1       $f18, 0x38($a0)
0011B6B0 460D7340 add.s      $f13, $f14, $f13
0011B6B4 8EC5EB2C lw         $a1, -0x14d4($s6)
0011B6B8 460C8B02 mul.s      $f12, $f17, $f12
0011B6BC 02802025 move       $a0, $s4
0011B6C0 460F83C0 add.s      $f15, $f16, $f15
0011B6C4 02003025 move       $a2, $s0
0011B6C8 E7AD0084 swc1       $f13, 0x84($sp)
0011B6CC C66DEAE0 lwc1       $f13, -0x1520($s3)
0011B6D0 460C9480 add.s      $f18, $f18, $f12
0011B6D4 00003825 move       $a3, $zero
0011B6D8 E7AF0088 swc1       $f15, 0x88($sp)
0011B6DC 46006B06 mov.s      $f12, $f13
0011B6E0 0C0224DE jal        0x89378
0011B6E4 E7B2008C swc1       $f18, 0x8c($sp)
0011B6E8 C66CEAE0 lwc1       $f12, -0x1520($s3)
0011B6EC 8EA5EB30 lw         $a1, -0x14d0($s5)
0011B6F0 46146302 mul.s      $f12, $f12, $f20
0011B6F4 02802025 move       $a0, $s4
0011B6F8 02003025 move       $a2, $s0
0011B6FC 00003825 move       $a3, $zero
0011B700 0C0224DE jal        0x89378
0011B704 46006346 mov.s      $f13, $f12
0011B708 26520001 addiu      $s2, $s2, 1
0011B70C 2E440002 sltiu      $a0, $s2, 2
0011B710 1480FFC3 bnez       $a0, 0x11b620
0011B714 2631005C addiu      $s1, $s1, 0x5c
0011B718 10000008 b          0x11b73c
0011B71C 00000000 nop        
0011B720 8FA40094 lw         $a0, 0x94($sp)
0011B724 34050003 ori        $a1, $zero, 3
0011B728 90860045 lbu        $a2, 0x45($a0)
0011B72C 14C50003 bne        $a2, $a1, 0x11b73c
0011B730 00000000 nop        
0011B734 0C0192FF jal        0x64bfc
0011B738 34050001 ori        $a1, $zero, 1
0011B73C C7B4009C lwc1       $f20, 0x9c($sp)
0011B740 C7B600A0 lwc1       $f22, 0xa0($sp)
0011B744 C7B800A4 lwc1       $f24, 0xa4($sp)
0011B748 C7BA00A8 lwc1       $f26, 0xa8($sp)
0011B74C C7BC00AC lwc1       $f28, 0xac($sp)
0011B750 C7BE00B0 lwc1       $f30, 0xb0($sp)
0011B754 8FB000B4 lw         $s0, 0xb4($sp)
0011B758 8FB100B8 lw         $s1, 0xb8($sp)
0011B75C 8FB200BC lw         $s2, 0xbc($sp)
0011B760 8FB300C0 lw         $s3, 0xc0($sp)
0011B764 8FB400C4 lw         $s4, 0xc4($sp)
0011B768 8FB500C8 lw         $s5, 0xc8($sp)
0011B76C 8FB600CC lw         $s6, 0xcc($sp)
0011B770 8FB700D0 lw         $s7, 0xd0($sp)
0011B774 8FBE00D4 lw         $fp, 0xd4($sp)
0011B778 8FBF00D8 lw         $ra, 0xd8($sp)
0011B77C 03E00008 jr         $ra
0011B780 27BD00E0 addiu      $sp, $sp, 0xe0