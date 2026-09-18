
CALLBACK 0x0012AF88 end 0x0012B074 ordinal 0

0012AF88 27BDFFD0 addiu      $sp, $sp, -0x30
0012AF8C 3C05002B lui        $a1, 0x2b
0012AF90 AFB00020 sw         $s0, 0x20($sp)
0012AF94 AFB10024 sw         $s1, 0x24($sp)
0012AF98 8CB100C0 lw         $s1, 0xc0($a1)
0012AF9C 00808025 move       $s0, $a0
0012AFA0 AFB20028 sw         $s2, 0x28($sp)
0012AFA4 AFBF002C sw         $ra, 0x2c($sp)
0012AFA8 0C00C41E jal        0x31078
0012AFAC 02202025 move       $a0, $s1
0012AFB0 10400006 beqz       $v0, 0x12afcc
0012AFB4 00000000 nop        
0012AFB8 3C04001C lui        $a0, 0x1c
0012AFBC 2405FF76 addiu      $a1, $zero, -0x8a
0012AFC0 2406FFFF addiu      $a2, $zero, -1
0012AFC4 0C028ED4 jal        0xa3b50
0012AFC8 24846C5C addiu      $a0, $a0, 0x6c5c
0012AFCC 8E120058 lw         $s2, 0x58($s0)
0012AFD0 3C08002B lui        $t0, 0x2b
0012AFD4 AE400000 sw         $zero, ($s2)
0012AFD8 00002825 move       $a1, $zero
0012AFDC AE400004 sw         $zero, 4($s2)
0012AFE0 26440010 addiu      $a0, $s2, 0x10
0012AFE4 34060044 ori        $a2, $zero, 0x44
0012AFE8 34070045 ori        $a3, $zero, 0x45
0012AFEC 0C019B8F jal        0x66e3c
0012AFF0 250828D8 addiu      $t0, $t0, 0x28d8
0012AFF4 44806000 mtc1       $zero, $f12
0012AFF8 E60C0070 swc1       $f12, 0x70($s0)
0012AFFC 0C00039F jal        0xe7c
0012B000 AE400038 sw         $zero, 0x38($s2)
0012B004 0C00039F jal        0xe7c
0012B008 E640000C swc1       $f0, 0xc($s2)
0012B00C E6400008 swc1       $f0, 8($s2)
0012B010 8E2600F0 lw         $a2, 0xf0($s1)
0012B014 26040074 addiu      $a0, $s0, 0x74
0012B018 34050009 ori        $a1, $zero, 9
0012B01C 0C0077E7 jal        0x1df9c
0012B020 2407FFFF addiu      $a3, $zero, -1
0012B024 3C05002D lui        $a1, 0x2d
0012B028 C4AC0630 lwc1       $f12, 0x630($a1)
0012B02C 3C05002D lui        $a1, 0x2d
0012B030 C4AD0634 lwc1       $f13, 0x634($a1)
0012B034 3C05002D lui        $a1, 0x2d
0012B038 C4AE0638 lwc1       $f14, 0x638($a1)
0012B03C 3C05002D lui        $a1, 0x2d
0012B040 3C06002D lui        $a2, 0x2d
0012B044 02202025 move       $a0, $s1
0012B048 00003825 move       $a3, $zero
0012B04C 24A50624 addiu      $a1, $a1, 0x624
0012B050 0C01707F jal        0x5c1fc
0012B054 24C60608 addiu      $a2, $a2, 0x608
0012B058 34020001 ori        $v0, $zero, 1
0012B05C 8FB00020 lw         $s0, 0x20($sp)
0012B060 8FB10024 lw         $s1, 0x24($sp)
0012B064 8FB20028 lw         $s2, 0x28($sp)
0012B068 8FBF002C lw         $ra, 0x2c($sp)
0012B06C 03E00008 jr         $ra
0012B070 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x0012B074 end 0x0012B098 ordinal 1

0012B074 27BDFFE0 addiu      $sp, $sp, -0x20
0012B078 8C840058 lw         $a0, 0x58($a0)
0012B07C 00002825 move       $a1, $zero
0012B080 AFBF0010 sw         $ra, 0x10($sp)
0012B084 0C0170A4 jal        0x5c290
0012B088 8C840000 lw         $a0, ($a0)
0012B08C 8FBF0010 lw         $ra, 0x10($sp)
0012B090 03E00008 jr         $ra
0012B094 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0012B254 end 0x0012B8A4 ordinal 2

0012B254 27BDFF50 addiu      $sp, $sp, -0xb0
0012B258 AFB30090 sw         $s3, 0x90($sp)
0012B25C 00809825 move       $s3, $a0
0012B260 AFB00084 sw         $s0, 0x84($sp)
0012B264 8E700058 lw         $s0, 0x58($s3)
0012B268 3C050013 lui        $a1, 0x13
0012B26C AFB10088 sw         $s1, 0x88($sp)
0012B270 8E110000 lw         $s1, ($s0)
0012B274 24A5B098 addiu      $a1, $a1, -0x4f68
0012B278 E7B4007C swc1       $f20, 0x7c($sp)
0012B27C E7B60080 swc1       $f22, 0x80($sp)
0012B280 AFB2008C sw         $s2, 0x8c($sp)
0012B284 AFB40094 sw         $s4, 0x94($sp)
0012B288 AFB50098 sw         $s5, 0x98($sp)
0012B28C AFB6009C sw         $s6, 0x9c($sp)
0012B290 AFB700A0 sw         $s7, 0xa0($sp)
0012B294 AFBE00A4 sw         $fp, 0xa4($sp)
0012B298 AFBF00A8 sw         $ra, 0xa8($sp)
0012B29C 0C0170A4 jal        0x5c290
0012B2A0 02202025 move       $a0, $s1
0012B2A4 8E2500F0 lw         $a1, 0xf0($s1)
0012B2A8 0C007DC7 jal        0x1f71c
0012B2AC 34040009 ori        $a0, $zero, 9
0012B2B0 AFA20078 sw         $v0, 0x78($sp)
0012B2B4 0C016FD5 jal        0x5bf54
0012B2B8 02202025 move       $a0, $s1
0012B2BC 0040B025 move       $s6, $v0
0012B2C0 0C00C4BD jal        0x312f4
0012B2C4 02202025 move       $a0, $s1
0012B2C8 263E00C0 addiu      $fp, $s1, 0xc0
0012B2CC 4480A000 mtc1       $zero, $f20
0012B2D0 27B70030 addiu      $s7, $sp, 0x30
0012B2D4 12C00077 beqz       $s6, 0x12b4b4
0012B2D8 3C12002D lui        $s2, 0x2d
0012B2DC 0C00C41E jal        0x31078
0012B2E0 02202025 move       $a0, $s1
0012B2E4 10400006 beqz       $v0, 0x12b300
0012B2E8 00000000 nop        
0012B2EC 3C04001C lui        $a0, 0x1c
0012B2F0 2405FF75 addiu      $a1, $zero, -0x8b
0012B2F4 2406FFFF addiu      $a2, $zero, -1
0012B2F8 0C028ED4 jal        0xa3b50
0012B2FC 24846C74 addiu      $a0, $a0, 0x6c74
0012B300 C60C0008 lwc1       $f12, 8($s0)
0012B304 46146032 c.eq.s     $f12, $f20
0012B308 00000000 nop        
0012B30C 45000006 bc1f       0x12b328
0012B310 00000000 nop        
0012B314 0C00039F jal        0xe7c
0012B318 00000000 nop        
0012B31C 0C00039F jal        0xe7c
0012B320 E600000C swc1       $f0, 0xc($s0)
0012B324 E6000008 swc1       $f0, 8($s0)
0012B328 8FC40014 lw         $a0, 0x14($fp)
0012B32C 30850200 andi       $a1, $a0, 0x200
0012B330 10A0002A beqz       $a1, 0x12b3dc
0012B334 00000000 nop        
0012B338 C60C0008 lwc1       $f12, 8($s0)
0012B33C 3C04002D lui        $a0, 0x2d
0012B340 C48D061C lwc1       $f13, 0x61c($a0)
0012B344 460D6341 sub.s      $f13, $f12, $f13
0012B348 E60D0008 swc1       $f13, 8($s0)
0012B34C C64C0620 lwc1       $f12, 0x620($s2)
0012B350 460C683C c.lt.s     $f13, $f12
0012B354 00000000 nop        
0012B358 45000009 bc1f       0x12b380
0012B35C 00000000 nop        
0012B360 E60C0008 swc1       $f12, 8($s0)
0012B364 8E040038 lw         $a0, 0x38($s0)
0012B368 1080004D beqz       $a0, 0x12b4a0
0012B36C 00000000 nop        
0012B370 0C01B1A3 jal        0x6c68c
0012B374 00000000 nop        
0012B378 10000049 b          0x12b4a0
0012B37C AE000038 sw         $zero, 0x38($s0)
0012B380 3C04002D lui        $a0, 0x2d
0012B384 8C8406A0 lw         $a0, 0x6a0($a0)
0012B388 10800045 beqz       $a0, 0x12b4a0
0012B38C 00000000 nop        
0012B390 8E050038 lw         $a1, 0x38($s0)
0012B394 14A00042 bnez       $a1, 0x12b4a0
0012B398 00000000 nop        
0012B39C 10800040 beqz       $a0, 0x12b4a0
0012B3A0 00802825 move       $a1, $a0
0012B3A4 C4AC0014 lwc1       $f12, 0x14($a1)
0012B3A8 C4AD0018 lwc1       $f13, 0x18($a1)
0012B3AC C4AE001C lwc1       $f14, 0x1c($a1)
0012B3B0 26060038 addiu      $a2, $s0, 0x38
0012B3B4 C4AF0020 lwc1       $f15, 0x20($a1)
0012B3B8 34070000 ori        $a3, $zero, 0
0012B3BC 34090000 ori        $t1, $zero, 0
0012B3C0 340A0000 ori        $t2, $zero, 0
0012B3C4 340B0001 ori        $t3, $zero, 1
0012B3C8 02602025 move       $a0, $s3
0012B3CC 0C01B147 jal        0x6c51c
0012B3D0 00004025 move       $t0, $zero
0012B3D4 10000032 b          0x12b4a0
0012B3D8 00000000 nop        
0012B3DC 30840100 andi       $a0, $a0, 0x100
0012B3E0 10800029 beqz       $a0, 0x12b488
0012B3E4 00000000 nop        
0012B3E8 C60D0008 lwc1       $f13, 8($s0)
0012B3EC 3C04002D lui        $a0, 0x2d
0012B3F0 C48E061C lwc1       $f14, 0x61c($a0)
0012B3F4 C60C000C lwc1       $f12, 0xc($s0)
0012B3F8 460E6B40 add.s      $f13, $f13, $f14
0012B3FC 460C683E c.le.s     $f13, $f12
0012B400 00000000 nop        
0012B404 45010009 bc1t       0x12b42c
0012B408 E60D0008 swc1       $f13, 8($s0)
0012B40C E60C0008 swc1       $f12, 8($s0)
0012B410 8E040038 lw         $a0, 0x38($s0)
0012B414 10800022 beqz       $a0, 0x12b4a0
0012B418 00000000 nop        
0012B41C 0C01B1A3 jal        0x6c68c
0012B420 00000000 nop        
0012B424 1000001E b          0x12b4a0
0012B428 AE000038 sw         $zero, 0x38($s0)
0012B42C 3C04002D lui        $a0, 0x2d
0012B430 8C8406A0 lw         $a0, 0x6a0($a0)
0012B434 1080001A beqz       $a0, 0x12b4a0
0012B438 00000000 nop        
0012B43C 8E050038 lw         $a1, 0x38($s0)
0012B440 14A00017 bnez       $a1, 0x12b4a0
0012B444 00000000 nop        
0012B448 10800015 beqz       $a0, 0x12b4a0
0012B44C 00802825 move       $a1, $a0
0012B450 C4AC0014 lwc1       $f12, 0x14($a1)
0012B454 C4AD0018 lwc1       $f13, 0x18($a1)
0012B458 C4AE001C lwc1       $f14, 0x1c($a1)
0012B45C 26060038 addiu      $a2, $s0, 0x38
0012B460 C4AF0020 lwc1       $f15, 0x20($a1)
0012B464 34070000 ori        $a3, $zero, 0
0012B468 34090000 ori        $t1, $zero, 0
0012B46C 340A0000 ori        $t2, $zero, 0
0012B470 340B0001 ori        $t3, $zero, 1
0012B474 02602025 move       $a0, $s3
0012B478 0C01B147 jal        0x6c51c
0012B47C 00004025 move       $t0, $zero
0012B480 10000007 b          0x12b4a0
0012B484 00000000 nop        
0012B488 8E040038 lw         $a0, 0x38($s0)
0012B48C 10800004 beqz       $a0, 0x12b4a0
0012B490 00000000 nop        
0012B494 0C01B1A3 jal        0x6c68c
0012B498 00000000 nop        
0012B49C AE000038 sw         $zero, 0x38($s0)
0012B4A0 C60C0008 lwc1       $f12, 8($s0)
0012B4A4 0C0170A2 jal        0x5c288
0012B4A8 02202025 move       $a0, $s1
0012B4AC 10000007 b          0x12b4cc
0012B4B0 00000000 nop        
0012B4B4 C60C0008 lwc1       $f12, 8($s0)
0012B4B8 46146032 c.eq.s     $f12, $f20
0012B4BC 00000000 nop        
0012B4C0 45010002 bc1t       0x12b4cc
0012B4C4 00000000 nop        
0012B4C8 E6140008 swc1       $f20, 8($s0)
0012B4CC C66C0070 lwc1       $f12, 0x70($s3)
0012B4D0 46146032 c.eq.s     $f12, $f20
0012B4D4 00000000 nop        
0012B4D8 45010009 bc1t       0x12b500
0012B4DC 00000000 nop        
0012B4E0 3C04BF80 lui        $a0, 0xbf80
0012B4E4 44846800 mtc1       $a0, $f13
0012B4E8 460D6300 add.s      $f12, $f12, $f13
0012B4EC 4614603C c.lt.s     $f12, $f20
0012B4F0 00000000 nop        
0012B4F4 45000002 bc1f       0x12b500
0012B4F8 E66C0070 swc1       $f12, 0x70($s3)
0012B4FC E6740070 swc1       $f20, 0x70($s3)
0012B500 8E040004 lw         $a0, 4($s0)
0012B504 34050003 ori        $a1, $zero, 3
0012B508 14850011 bne        $a0, $a1, 0x12b550
0012B50C 00000000 nop        
0012B510 02602025 move       $a0, $s3
0012B514 0C01AA82 jal        0x6aa08
0012B518 00002825 move       $a1, $zero
0012B51C 1040000C beqz       $v0, 0x12b550
0012B520 00000000 nop        
0012B524 3C083DCC lui        $t0, 0x3dcc
0012B528 4600A346 mov.s      $f13, $f20
0012B52C A2600045 sb         $zero, 0x45($s3)
0012B530 3508CCCD ori        $t0, $t0, 0xcccd
0012B534 AE000004 sw         $zero, 4($s0)
0012B538 44886000 mtc1       $t0, $f12
0012B53C 02602025 move       $a0, $s3
0012B540 00002825 move       $a1, $zero
0012B544 00003025 move       $a2, $zero
0012B548 0C01AB54 jal        0x6ad50
0012B54C 34070001 ori        $a3, $zero, 1
0012B550 0C00C4BD jal        0x312f4
0012B554 02202025 move       $a0, $s1
0012B558 24440020 addiu      $a0, $v0, 0x20
0012B55C C48C0000 lwc1       $f12, ($a0)
0012B560 C48D0004 lwc1       $f13, 4($a0)
0012B564 C48E0008 lwc1       $f14, 8($a0)
0012B568 44056000 mfc1       $a1, $f12
0012B56C C48F000C lwc1       $f15, 0xc($a0)
0012B570 44066800 mfc1       $a2, $f13
0012B574 AFA50040 sw         $a1, 0x40($sp)
0012B578 44047000 mfc1       $a0, $f14
0012B57C AFA60044 sw         $a2, 0x44($sp)
0012B580 44057800 mfc1       $a1, $f15
0012B584 AFA40048 sw         $a0, 0x48($sp)
0012B588 AFA5004C sw         $a1, 0x4c($sp)
0012B58C 922409E4 lbu        $a0, 0x9e4($s1)
0012B590 1080001D beqz       $a0, 0x12b608
0012B594 00000000 nop        
0012B598 C62C09E8 lwc1       $f12, 0x9e8($s1)
0012B59C 3C043CA3 lui        $a0, 0x3ca3
0012B5A0 E7AC0030 swc1       $f12, 0x30($sp)
0012B5A4 C62C09EC lwc1       $f12, 0x9ec($s1)
0012B5A8 3484D70A ori        $a0, $a0, 0xd70a
0012B5AC E7AC0034 swc1       $f12, 0x34($sp)
0012B5B0 44846800 mtc1       $a0, $f13
0012B5B4 C62C09F0 lwc1       $f12, 0x9f0($s1)
0012B5B8 E7AC0038 swc1       $f12, 0x38($sp)
0012B5BC C62C09F4 lwc1       $f12, 0x9f4($s1)
0012B5C0 C7AE0030 lwc1       $f14, 0x30($sp)
0012B5C4 460D6302 mul.s      $f12, $f12, $f13
0012B5C8 C7AF0034 lwc1       $f15, 0x34($sp)
0012B5CC E7AC006C swc1       $f12, 0x6c($sp)
0012B5D0 C63009F8 lwc1       $f16, 0x9f8($s1)
0012B5D4 460C7300 add.s      $f12, $f14, $f12
0012B5D8 C7B10038 lwc1       $f17, 0x38($sp)
0012B5DC 460D8402 mul.s      $f16, $f16, $f13
0012B5E0 E7B00070 swc1       $f16, 0x70($sp)
0012B5E4 46107BC0 add.s      $f15, $f15, $f16
0012B5E8 C63209FC lwc1       $f18, 0x9fc($s1)
0012B5EC E7AC0030 swc1       $f12, 0x30($sp)
0012B5F0 460D9342 mul.s      $f13, $f18, $f13
0012B5F4 E7AF0034 swc1       $f15, 0x34($sp)
0012B5F8 460D8B00 add.s      $f12, $f17, $f13
0012B5FC E7AD0074 swc1       $f13, 0x74($sp)
0012B600 10000006 b          0x12b61c
0012B604 E7AC0038 swc1       $f12, 0x38($sp)
0012B608 3C06002D lui        $a2, 0x2d
0012B60C 02E02025 move       $a0, $s7
0012B610 02602825 move       $a1, $s3
0012B614 0C03D550 jal        0xf5540
0012B618 24C60608 addiu      $a2, $a2, 0x608
0012B61C E7B40068 swc1       $f20, 0x68($sp)
0012B620 8FA40078 lw         $a0, 0x78($sp)
0012B624 8C84003C lw         $a0, 0x3c($a0)
0012B628 34080028 ori        $t0, $zero, 0x28
0012B62C 00043080 sll        $a2, $a0, 2
0012B630 3C04002D lui        $a0, 0x2d
0012B634 24870680 addiu      $a3, $a0, 0x680
0012B638 00C73021 addu       $a2, $a2, $a3
0012B63C C4CC0000 lwc1       $f12, ($a2)
0012B640 34090000 ori        $t1, $zero, 0
0012B644 34150000 ori        $s5, $zero, 0
0012B648 27A40068 addiu      $a0, $sp, 0x68
0012B64C 27A50050 addiu      $a1, $sp, 0x50
0012B650 8E2A0594 lw         $t2, 0x594($s1)
0012B654 27A70040 addiu      $a3, $sp, 0x40
0012B658 0C007517 jal        0x1d45c
0012B65C 02E03025 move       $a2, $s7
0012B660 0040A025 move       $s4, $v0
0012B664 0C00C41E jal        0x31078
0012B668 02202025 move       $a0, $s1
0012B66C 50400010 beql       $v0, $zero, 0x12b6b0
0012B670 C60C000C lwc1       $f12, 0xc($s0)
0012B674 5280000E beql       $s4, $zero, 0x12b6b0
0012B678 C60C000C lwc1       $f12, 0xc($s0)
0012B67C 8FA40064 lw         $a0, 0x64($sp)
0012B680 34050002 ori        $a1, $zero, 2
0012B684 5485000A bnel       $a0, $a1, 0x12b6b0
0012B688 C60C000C lwc1       $f12, 0xc($s0)
0012B68C 8FA40060 lw         $a0, 0x60($sp)
0012B690 34050001 ori        $a1, $zero, 1
0012B694 8C840040 lw         $a0, 0x40($a0)
0012B698 9084004B lbu        $a0, 0x4b($a0)
0012B69C 54850004 bnel       $a0, $a1, 0x12b6b0
0012B6A0 C60C000C lwc1       $f12, 0xc($s0)
0012B6A4 0C016FE3 jal        0x5bf8c
0012B6A8 8E040000 lw         $a0, ($s0)
0012B6AC C60C000C lwc1       $f12, 0xc($s0)
0012B6B0 C64D0620 lwc1       $f13, 0x620($s2)
0012B6B4 C60E0008 lwc1       $f14, 8($s0)
0012B6B8 460D6581 sub.s      $f22, $f12, $f13
0012B6BC 3C044040 lui        $a0, 0x4040
0012B6C0 460E6301 sub.s      $f12, $f12, $f14
0012B6C4 46166583 div.s      $f22, $f12, $f22
0012B6C8 44847800 mtc1       $a0, $f15
0012B6CC 460FB3C2 mul.s      $f15, $f22, $f15
0012B6D0 46007BCD trunc.w.s  $f15, $f15
0012B6D4 16C00003 bnez       $s6, 0x12b6e4
0012B6D8 44127800 mfc1       $s2, $f15
0012B6DC 1000000F b          0x12b71c
0012B6E0 34120000 ori        $s2, $zero, 0
0012B6E4 12C0000D beqz       $s6, 0x12b71c
0012B6E8 00000000 nop        
0012B6EC 0C00C41E jal        0x31078
0012B6F0 02202025 move       $a0, $s1
0012B6F4 10400009 beqz       $v0, 0x12b71c
0012B6F8 00000000 nop        
0012B6FC 3C05002D lui        $a1, 0x2d
0012B700 4600B306 mov.s      $f12, $f22
0012B704 00122100 sll        $a0, $s2, 4
0012B708 24A50640 addiu      $a1, $a1, 0x640
0012B70C 00852021 addu       $a0, $a0, $a1
0012B710 8C840000 lw         $a0, ($a0)
0012B714 0C0293E0 jal        0xa4f80
0012B718 34050003 ori        $a1, $zero, 3
0012B71C 0C00C41E jal        0x31078
0012B720 02202025 move       $a0, $s1
0012B724 10400051 beqz       $v0, 0x12b86c
0012B728 00000000 nop        
0012B72C C66C0070 lwc1       $f12, 0x70($s3)
0012B730 46146032 c.eq.s     $f12, $f20
0012B734 00000000 nop        
0012B738 4500004C bc1f       0x12b86c
0012B73C 00000000 nop        
0012B740 0C007956 jal        0x1e558
0012B744 02202025 move       $a0, $s1
0012B748 10400048 beqz       $v0, 0x12b86c
0012B74C 00000000 nop        
0012B750 8E24095C lw         $a0, 0x95c($s1)
0012B754 30840020 andi       $a0, $a0, 0x20
0012B758 10800044 beqz       $a0, 0x12b86c
0012B75C 00000000 nop        
0012B760 92640045 lbu        $a0, 0x45($s3)
0012B764 14800041 bnez       $a0, 0x12b86c
0012B768 00000000 nop        
0012B76C 8FC40014 lw         $a0, 0x14($fp)
0012B770 30842000 andi       $a0, $a0, 0x2000
0012B774 1080003D beqz       $a0, 0x12b86c
0012B778 00000000 nop        
0012B77C 0C00C41E jal        0x31078
0012B780 02202025 move       $a0, $s1
0012B784 10400019 beqz       $v0, 0x12b7ec
0012B788 00000000 nop        
0012B78C 3C05002D lui        $a1, 0x2d
0012B790 44927000 mtc1       $s2, $f14
0012B794 C4AC0704 lwc1       $f12, 0x704($a1)
0012B798 468073A0 cvt.s.w    $f14, $f14
0012B79C 3C05002D lui        $a1, 0x2d
0012B7A0 C4AD0708 lwc1       $f13, 0x708($a1)
0012B7A4 3C05002D lui        $a1, 0x2d
0012B7A8 26640030 addiu      $a0, $s3, 0x30
0012B7AC 06410004 bgez       $s2, 0x12b7c0
0012B7B0 C4AF063C lwc1       $f15, 0x63c($a1)
0012B7B4 3C054F80 lui        $a1, 0x4f80
0012B7B8 44858000 mtc1       $a1, $f16
0012B7BC 46107380 add.s      $f14, $f14, $f16
0012B7C0 44928000 mtc1       $s2, $f16
0012B7C4 460E7B82 mul.s      $f14, $f15, $f14
0012B7C8 06410004 bgez       $s2, 0x12b7dc
0012B7CC 46808420 cvt.s.w    $f16, $f16
0012B7D0 3C054F80 lui        $a1, 0x4f80
0012B7D4 44858800 mtc1       $a1, $f17
0012B7D8 46118400 add.s      $f16, $f16, $f17
0012B7DC 46107C02 mul.s      $f16, $f15, $f16
0012B7E0 460073C6 mov.s      $f15, $f14
0012B7E4 0C003476 jal        0xd1d8
0012B7E8 4600A386 mov.s      $f14, $f20
0012B7EC 12800009 beqz       $s4, 0x12b814
0012B7F0 00000000 nop        
0012B7F4 8FA40064 lw         $a0, 0x64($sp)
0012B7F8 34050002 ori        $a1, $zero, 2
0012B7FC 14850005 bne        $a0, $a1, 0x12b814
0012B800 00000000 nop        
0012B804 8FA40060 lw         $a0, 0x60($sp)
0012B808 10800002 beqz       $a0, 0x12b814
0012B80C 00000000 nop        
0012B810 0080A825 move       $s5, $a0
0012B814 8E040000 lw         $a0, ($s0)
0012B818 8FA50078 lw         $a1, 0x78($sp)
0012B81C 3C06002D lui        $a2, 0x2d
0012B820 00123900 sll        $a3, $s2, 4
0012B824 24C60640 addiu      $a2, $a2, 0x640
0012B828 C7AC0068 lwc1       $f12, 0x68($sp)
0012B82C 8CA9003C lw         $t1, 0x3c($a1)
0012B830 00E63821 addu       $a3, $a3, $a2
0012B834 27A60040 addiu      $a2, $sp, 0x40
0012B838 02E02825 move       $a1, $s7
0012B83C 02A04025 move       $t0, $s5
0012B840 02C05025 move       $t2, $s6
0012B844 02805825 move       $t3, $s4
0012B848 0C04B007 jal        0x12c01c
0012B84C AFA00000 sw         $zero, ($sp)
0012B850 00408025 move       $s0, $v0
0012B854 12000005 beqz       $s0, 0x12b86c
0012B858 00000000 nop        
0012B85C 8E050058 lw         $a1, 0x58($s0)
0012B860 02602025 move       $a0, $s3
0012B864 0C04AC53 jal        0x12b14c
0012B868 ACB10000 sw         $s1, ($a1)
0012B86C C7B4007C lwc1       $f20, 0x7c($sp)
0012B870 C7B60080 lwc1       $f22, 0x80($sp)
0012B874 8FB00084 lw         $s0, 0x84($sp)
0012B878 8FB10088 lw         $s1, 0x88($sp)
0012B87C 8FB2008C lw         $s2, 0x8c($sp)
0012B880 8FB30090 lw         $s3, 0x90($sp)
0012B884 8FB40094 lw         $s4, 0x94($sp)
0012B888 8FB50098 lw         $s5, 0x98($sp)
0012B88C 8FB6009C lw         $s6, 0x9c($sp)
0012B890 8FB700A0 lw         $s7, 0xa0($sp)
0012B894 8FBE00A4 lw         $fp, 0xa4($sp)
0012B898 8FBF00A8 lw         $ra, 0xa8($sp)
0012B89C 03E00008 jr         $ra
0012B8A0 27BD00B0 addiu      $sp, $sp, 0xb0