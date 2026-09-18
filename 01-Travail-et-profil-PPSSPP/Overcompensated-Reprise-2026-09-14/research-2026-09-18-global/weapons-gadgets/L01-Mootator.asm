
CALLBACK 0x00158FC4 end 0x00159214 ordinal 0

00158FC4 27BDFFB0 addiu      $sp, $sp, -0x50
00158FC8 AFB0003C sw         $s0, 0x3c($sp)
00158FCC 00808025 move       $s0, $a0
00158FD0 AFB10040 sw         $s1, 0x40($sp)
00158FD4 8E110058 lw         $s1, 0x58($s0)
00158FD8 00002825 move       $a1, $zero
00158FDC 02202025 move       $a0, $s1
00158FE0 E7B40030 swc1       $f20, 0x30($sp)
00158FE4 E7B60034 swc1       $f22, 0x34($sp)
00158FE8 E7B80038 swc1       $f24, 0x38($sp)
00158FEC AFB20044 sw         $s2, 0x44($sp)
00158FF0 AFB30048 sw         $s3, 0x48($sp)
00158FF4 AFBF004C sw         $ra, 0x4c($sp)
00158FF8 0C06B6A7 jal        0x1ada9c
00158FFC 340601A4 ori        $a2, $zero, 0x1a4
00159000 3C04002D lui        $a0, 0x2d
00159004 C48CA34C lwc1       $f12, -0x5cb4($a0)
00159008 2485A34C addiu      $a1, $a0, -0x5cb4
0015900C E62C0010 swc1       $f12, 0x10($s1)
00159010 C4AC0004 lwc1       $f12, 4($a1)
00159014 E62C0014 swc1       $f12, 0x14($s1)
00159018 C4AC0008 lwc1       $f12, 8($a1)
0015901C E62C0018 swc1       $f12, 0x18($s1)
00159020 C48CA34C lwc1       $f12, -0x5cb4($a0)
00159024 E62C0020 swc1       $f12, 0x20($s1)
00159028 C4AC0004 lwc1       $f12, 4($a1)
0015902C E62C0024 swc1       $f12, 0x24($s1)
00159030 C4AC0008 lwc1       $f12, 8($a1)
00159034 3C05002D lui        $a1, 0x2d
00159038 24B2563C addiu      $s2, $a1, 0x563c
0015903C 27A40020 addiu      $a0, $sp, 0x20
00159040 E62C0028 swc1       $f12, 0x28($s1)
00159044 02002825 move       $a1, $s0
00159048 0C03D550 jal        0xf5540
0015904C 02403025 move       $a2, $s2
00159050 C7AC0020 lwc1       $f12, 0x20($sp)
00159054 E62C0030 swc1       $f12, 0x30($s1)
00159058 C7AC0024 lwc1       $f12, 0x24($sp)
0015905C E62C0034 swc1       $f12, 0x34($s1)
00159060 C7AC0028 lwc1       $f12, 0x28($sp)
00159064 3C08002B lui        $t0, 0x2b
00159068 262400A8 addiu      $a0, $s1, 0xa8
0015906C 00002825 move       $a1, $zero
00159070 E62C0038 swc1       $f12, 0x38($s1)
00159074 34060044 ori        $a2, $zero, 0x44
00159078 34070045 ori        $a3, $zero, 0x45
0015907C 0C019B8F jal        0x66e3c
00159080 250828D8 addiu      $t0, $t0, 0x28d8
00159084 3C04BF80 lui        $a0, 0xbf80
00159088 44846000 mtc1       $a0, $f12
0015908C E62C002C swc1       $f12, 0x2c($s1)
00159090 92040044 lbu        $a0, 0x44($s0)
00159094 AE200188 sw         $zero, 0x188($s1)
00159098 A224004E sb         $a0, 0x4e($s1)
0015909C 3C043E4C lui        $a0, 0x3e4c
001590A0 3484CCCD ori        $a0, $a0, 0xcccd
001590A4 44846000 mtc1       $a0, $f12
001590A8 AE20003C sw         $zero, 0x3c($s1)
001590AC 3C043F26 lui        $a0, 0x3f26
001590B0 E62C0050 swc1       $f12, 0x50($s1)
001590B4 34846666 ori        $a0, $a0, 0x6666
001590B8 44846000 mtc1       $a0, $f12
001590BC 4480A000 mtc1       $zero, $f20
001590C0 3C044080 lui        $a0, 0x4080
001590C4 E6340058 swc1       $f20, 0x58($s1)
001590C8 4484B000 mtc1       $a0, $f22
001590CC E62C0054 swc1       $f12, 0x54($s1)
001590D0 3C043F00 lui        $a0, 0x3f00
001590D4 E6360074 swc1       $f22, 0x74($s1)
001590D8 4484C000 mtc1       $a0, $f24
001590DC E6380078 swc1       $f24, 0x78($s1)
001590E0 3C043DCC lui        $a0, 0x3dcc
001590E4 E634007C swc1       $f20, 0x7c($s1)
001590E8 3484CCCD ori        $a0, $a0, 0xcccd
001590EC 44846000 mtc1       $a0, $f12
001590F0 E6340064 swc1       $f20, 0x64($s1)
001590F4 E62C0060 swc1       $f12, 0x60($s1)
001590F8 34047800 ori        $a0, $zero, 0x7800
001590FC AE240068 sw         $a0, 0x68($s1)
00159100 AE20006C sw         $zero, 0x6c($s1)
00159104 3404000C ori        $a0, $zero, 0xc
00159108 AE240070 sw         $a0, 0x70($s1)
0015910C 34040004 ori        $a0, $zero, 4
00159110 AE24005C sw         $a0, 0x5c($s1)
00159114 34040002 ori        $a0, $zero, 2
00159118 AE240080 sw         $a0, 0x80($s1)
0015911C 3C13002B lui        $s3, 0x2b
00159120 8E6500C0 lw         $a1, 0xc0($s3)
00159124 3404000D ori        $a0, $zero, 0xd
00159128 0C00810D jal        0x20434
0015912C 8CA500F0 lw         $a1, 0xf0($a1)
00159130 28440003 slti       $a0, $v0, 3
00159134 38840001 xori       $a0, $a0, 1
00159138 308400FF andi       $a0, $a0, 0xff
0015913C 3C05002D lui        $a1, 0x2d
00159140 00042080 sll        $a0, $a0, 2
00159144 24A555D0 addiu      $a1, $a1, 0x55d0
00159148 00852021 addu       $a0, $a0, $a1
0015914C 8C840000 lw         $a0, ($a0)
00159150 E636008C swc1       $f22, 0x8c($s1)
00159154 AE240084 sw         $a0, 0x84($s1)
00159158 E6380090 swc1       $f24, 0x90($s1)
0015915C E6340094 swc1       $f20, 0x94($s1)
00159160 E6340088 swc1       $f20, 0x88($s1)
00159164 E636009C swc1       $f22, 0x9c($s1)
00159168 E63800A0 swc1       $f24, 0xa0($s1)
0015916C E63400A4 swc1       $f20, 0xa4($s1)
00159170 E6380098 swc1       $f24, 0x98($s1)
00159174 8E040048 lw         $a0, 0x48($s0)
00159178 3C050016 lui        $a1, 0x16
0015917C 24A59334 addiu      $a1, $a1, -0x6ccc
00159180 AC8500DC sw         $a1, 0xdc($a0)
00159184 A2000045 sb         $zero, 0x45($s0)
00159188 0C056801 jal        0x15a004
0015918C 2624018C addiu      $a0, $s1, 0x18c
00159190 8E6500C0 lw         $a1, 0xc0($s3)
00159194 8CA600F0 lw         $a2, 0xf0($a1)
00159198 26040074 addiu      $a0, $s0, 0x74
0015919C 3405000D ori        $a1, $zero, 0xd
001591A0 0C0077E7 jal        0x1df9c
001591A4 2407FFFF addiu      $a3, $zero, -1
001591A8 8E6400C0 lw         $a0, 0xc0($s3)
001591AC 3C05002D lui        $a1, 0x2d
001591B0 C4AC56FC lwc1       $f12, 0x56fc($a1)
001591B4 3C05002D lui        $a1, 0x2d
001591B8 C4AD5700 lwc1       $f13, 0x5700($a1)
001591BC 3C05002D lui        $a1, 0x2d
001591C0 C4AE5704 lwc1       $f14, 0x5704($a1)
001591C4 3C05002D lui        $a1, 0x2d
001591C8 02403025 move       $a2, $s2
001591CC 34070001 ori        $a3, $zero, 1
001591D0 0C01707F jal        0x5c1fc
001591D4 24A556F0 addiu      $a1, $a1, 0x56f0
001591D8 8E040064 lw         $a0, 0x64($s0)
001591DC 3C050004 lui        $a1, 4
001591E0 00852025 or         $a0, $a0, $a1
001591E4 AE040064 sw         $a0, 0x64($s0)
001591E8 34020001 ori        $v0, $zero, 1
001591EC C7B40030 lwc1       $f20, 0x30($sp)
001591F0 C7B60034 lwc1       $f22, 0x34($sp)
001591F4 C7B80038 lwc1       $f24, 0x38($sp)
001591F8 8FB0003C lw         $s0, 0x3c($sp)
001591FC 8FB10040 lw         $s1, 0x40($sp)
00159200 8FB20044 lw         $s2, 0x44($sp)
00159204 8FB30048 lw         $s3, 0x48($sp)
00159208 8FBF004C lw         $ra, 0x4c($sp)
0015920C 03E00008 jr         $ra
00159210 27BD0050 addiu      $sp, $sp, 0x50

CALLBACK 0x00159214 end 0x00159240 ordinal 1

00159214 27BDFFE0 addiu      $sp, $sp, -0x20
00159218 8C850058 lw         $a1, 0x58($a0)
0015921C 90A7004E lbu        $a3, 0x4e($a1)
00159220 00003025 move       $a2, $zero
00159224 90850045 lbu        $a1, 0x45($a0)
00159228 AFBF0010 sw         $ra, 0x10($sp)
0015922C 0C056490 jal        0x159240
00159230 A0870044 sb         $a3, 0x44($a0)
00159234 8FBF0010 lw         $ra, 0x10($sp)
00159238 03E00008 jr         $ra
0015923C 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0015A364 end 0x0015A8CC ordinal 2

0015A364 27BDFF60 addiu      $sp, $sp, -0xa0
0015A368 AFB00074 sw         $s0, 0x74($sp)
0015A36C 00808025 move       $s0, $a0
0015A370 AFB10078 sw         $s1, 0x78($sp)
0015A374 8E110058 lw         $s1, 0x58($s0)
0015A378 E7B40070 swc1       $f20, 0x70($sp)
0015A37C AFB2007C sw         $s2, 0x7c($sp)
0015A380 46006506 mov.s      $f20, $f12
0015A384 3404000D ori        $a0, $zero, 0xd
0015A388 8E320000 lw         $s2, ($s1)
0015A38C AFB30080 sw         $s3, 0x80($sp)
0015A390 AFB40084 sw         $s4, 0x84($sp)
0015A394 AFB50088 sw         $s5, 0x88($sp)
0015A398 AFB6008C sw         $s6, 0x8c($sp)
0015A39C AFB70090 sw         $s7, 0x90($sp)
0015A3A0 AFBE0094 sw         $fp, 0x94($sp)
0015A3A4 AFBF0098 sw         $ra, 0x98($sp)
0015A3A8 0C007DC7 jal        0x1f71c
0015A3AC 8E4500F0 lw         $a1, 0xf0($s2)
0015A3B0 00409825 move       $s3, $v0
0015A3B4 0C016FD5 jal        0x5bf54
0015A3B8 02402025 move       $a0, $s2
0015A3BC 9224004C lbu        $a0, 0x4c($s1)
0015A3C0 34140000 ori        $s4, $zero, 0
0015A3C4 34160001 ori        $s6, $zero, 1
0015A3C8 10800005 beqz       $a0, 0x15a3e0
0015A3CC 341E0001 ori        $fp, $zero, 1
0015A3D0 8E240008 lw         $a0, 8($s1)
0015A3D4 10800002 beqz       $a0, 0x15a3e0
0015A3D8 00000000 nop        
0015A3DC 03C0A025 move       $s4, $fp
0015A3E0 27B70030 addiu      $s7, $sp, 0x30
0015A3E4 3C06002D lui        $a2, 0x2d
0015A3E8 92150045 lbu        $s5, 0x45($s0)
0015A3EC 329400FF andi       $s4, $s4, 0xff
0015A3F0 02E02025 move       $a0, $s7
0015A3F4 02002825 move       $a1, $s0
0015A3F8 0C03D550 jal        0xf5540
0015A3FC 24C6563C addiu      $a2, $a2, 0x563c
0015A400 0C00C4BD jal        0x312f4
0015A404 02402025 move       $a0, $s2
0015A408 24440020 addiu      $a0, $v0, 0x20
0015A40C C48C0000 lwc1       $f12, ($a0)
0015A410 C48D0004 lwc1       $f13, 4($a0)
0015A414 C48E0008 lwc1       $f14, 8($a0)
0015A418 44056000 mfc1       $a1, $f12
0015A41C C48F000C lwc1       $f15, 0xc($a0)
0015A420 44066800 mfc1       $a2, $f13
0015A424 AFA50040 sw         $a1, 0x40($sp)
0015A428 44047000 mfc1       $a0, $f14
0015A42C AFA60044 sw         $a2, 0x44($sp)
0015A430 44057800 mfc1       $a1, $f15
0015A434 AFA40048 sw         $a0, 0x48($sp)
0015A438 AFA5004C sw         $a1, 0x4c($sp)
0015A43C 0C00C4BD jal        0x312f4
0015A440 02402025 move       $a0, $s2
0015A444 9224004C lbu        $a0, 0x4c($s1)
0015A448 8E65003C lw         $a1, 0x3c($s3)
0015A44C 00043140 sll        $a2, $a0, 5
0015A450 00052880 sll        $a1, $a1, 2
0015A454 00C52821 addu       $a1, $a2, $a1
0015A458 3C06002D lui        $a2, 0x2d
0015A45C 24C655F8 addiu      $a2, $a2, 0x55f8
0015A460 00A62821 addu       $a1, $a1, $a2
0015A464 C4AC0000 lwc1       $f12, ($a1)
0015A468 00042940 sll        $a1, $a0, 5
0015A46C 00042080 sll        $a0, $a0, 2
0015A470 00A44821 addu       $t1, $a1, $a0
0015A474 3C04002D lui        $a0, 0x2d
0015A478 2484564C addiu      $a0, $a0, 0x564c
0015A47C 01244821 addu       $t1, $t1, $a0
0015A480 02402025 move       $a0, $s2
0015A484 27A50040 addiu      $a1, $sp, 0x40
0015A488 00403025 move       $a2, $v0
0015A48C 02E03825 move       $a3, $s7
0015A490 0C00D6BC jal        0x35af0
0015A494 34080001 ori        $t0, $zero, 1
0015A498 0040B825 move       $s7, $v0
0015A49C 16E00008 bnez       $s7, 0x15a4c0
0015A4A0 00000000 nop        
0015A4A4 0C00C41E jal        0x31078
0015A4A8 02402025 move       $a0, $s2
0015A4AC 1440005E bnez       $v0, 0x15a628
0015A4B0 00000000 nop        
0015A4B4 9224004C lbu        $a0, 0x4c($s1)
0015A4B8 1080005B beqz       $a0, 0x15a628
0015A4BC 00000000 nop        
0015A4C0 0C00C41E jal        0x31078
0015A4C4 02402025 move       $a0, $s2
0015A4C8 10400007 beqz       $v0, 0x15a4e8
0015A4CC 00000000 nop        
0015A4D0 8E240008 lw         $a0, 8($s1)
0015A4D4 12E40004 beq        $s7, $a0, 0x15a4e8
0015A4D8 00000000 nop        
0015A4DC 02002025 move       $a0, $s0
0015A4E0 0C056351 jal        0x158d44
0015A4E4 02E02825 move       $a1, $s7
0015A4E8 C62C002C lwc1       $f12, 0x2c($s1)
0015A4EC 3C04BF80 lui        $a0, 0xbf80
0015A4F0 44846800 mtc1       $a0, $f13
0015A4F4 460D6032 c.eq.s     $f12, $f13
0015A4F8 00000000 nop        
0015A4FC 45010045 bc1t       0x15a614
0015A500 00000000 nop        
0015A504 0C00C41E jal        0x31078
0015A508 02402025 move       $a0, $s2
0015A50C 10400012 beqz       $v0, 0x15a558
0015A510 00000000 nop        
0015A514 AFBE006C sw         $fp, 0x6c($sp)
0015A518 27A50058 addiu      $a1, $sp, 0x58
0015A51C 02E02025 move       $a0, $s7
0015A520 34060001 ori        $a2, $zero, 1
0015A524 0C01B0C6 jal        0x6c318
0015A528 00003825 move       $a3, $zero
0015A52C 263E00A8 addiu      $fp, $s1, 0xa8
0015A530 03C02025 move       $a0, $fp
0015A534 34050001 ori        $a1, $zero, 1
0015A538 02E03025 move       $a2, $s7
0015A53C 0C0199E7 jal        0x6679c
0015A540 34070001 ori        $a3, $zero, 1
0015A544 03C02025 move       $a0, $fp
0015A548 27A50058 addiu      $a1, $sp, 0x58
0015A54C 0C019A07 jal        0x6681c
0015A550 00003025 move       $a2, $zero
0015A554 8FBE006C lw         $fp, 0x6c($sp)
0015A558 0C016FE3 jal        0x5bf8c
0015A55C 02402025 move       $a0, $s2
0015A560 8E44095C lw         $a0, 0x95c($s2)
0015A564 3C050002 lui        $a1, 2
0015A568 00852025 or         $a0, $a0, $a1
0015A56C AE44095C sw         $a0, 0x95c($s2)
0015A570 8E240008 lw         $a0, 8($s1)
0015A574 C64C0030 lwc1       $f12, 0x30($s2)
0015A578 24840030 addiu      $a0, $a0, 0x30
0015A57C C48D0000 lwc1       $f13, ($a0)
0015A580 C64E0034 lwc1       $f14, 0x34($s2)
0015A584 460C6B01 sub.s      $f12, $f13, $f12
0015A588 C64F0038 lwc1       $f15, 0x38($s2)
0015A58C E64C02A8 swc1       $f12, 0x2a8($s2)
0015A590 C4900004 lwc1       $f16, 4($a0)
0015A594 44806800 mtc1       $zero, $f13
0015A598 460E8381 sub.s      $f14, $f16, $f14
0015A59C 460C6442 mul.s      $f17, $f12, $f12
0015A5A0 460D6C82 mul.s      $f18, $f13, $f13
0015A5A4 E64E02AC swc1       $f14, 0x2ac($s2)
0015A5A8 C48E0008 lwc1       $f14, 8($a0)
0015A5AC 460F7381 sub.s      $f14, $f14, $f15
0015A5B0 3C043480 lui        $a0, 0x3480
0015A5B4 E64D02AC swc1       $f13, 0x2ac($s2)
0015A5B8 44848000 mtc1       $a0, $f16
0015A5BC 46128BC0 add.s      $f15, $f17, $f18
0015A5C0 460E74C2 mul.s      $f19, $f14, $f14
0015A5C4 46137BC0 add.s      $f15, $f15, $f19
0015A5C8 4610783C c.lt.s     $f15, $f16
0015A5CC 00000000 nop        
0015A5D0 4501000B bc1t       0x15a600
0015A5D4 E64E02B0 swc1       $f14, 0x2b0($s2)
0015A5D8 3C043F80 lui        $a0, 0x3f80
0015A5DC 46007BC4 sqrt.s     $f15, $f15
0015A5E0 44848000 mtc1       $a0, $f16
0015A5E4 460F83C3 div.s      $f15, $f16, $f15
0015A5E8 460F6302 mul.s      $f12, $f12, $f15
0015A5EC 460F6B42 mul.s      $f13, $f13, $f15
0015A5F0 460F7382 mul.s      $f14, $f14, $f15
0015A5F4 E64C02A8 swc1       $f12, 0x2a8($s2)
0015A5F8 E64D02AC swc1       $f13, 0x2ac($s2)
0015A5FC E64E02B0 swc1       $f14, 0x2b0($s2)
0015A600 A236004C sb         $s6, 0x4c($s1)
0015A604 3C04002D lui        $a0, 0x2d
0015A608 C48C5638 lwc1       $f12, 0x5638($a0)
0015A60C 10000014 b          0x15a660
0015A610 E60C0070 swc1       $f12, 0x70($s0)
0015A614 C62C000C lwc1       $f12, 0xc($s1)
0015A618 0C056371 jal        0x158dc4
0015A61C 02002025 move       $a0, $s0
0015A620 1000000F b          0x15a660
0015A624 00000000 nop        
0015A628 0C00C41E jal        0x31078
0015A62C 02402025 move       $a0, $s2
0015A630 1040000B beqz       $v0, 0x15a660
0015A634 00000000 nop        
0015A638 C60C0070 lwc1       $f12, 0x70($s0)
0015A63C 44806800 mtc1       $zero, $f13
0015A640 46146301 sub.s      $f12, $f12, $f20
0015A644 460D603E c.le.s     $f12, $f13
0015A648 00000000 nop        
0015A64C 45000004 bc1f       0x15a660
0015A650 E60C0070 swc1       $f12, 0x70($s0)
0015A654 C62C000C lwc1       $f12, 0xc($s1)
0015A658 0C056371 jal        0x158dc4
0015A65C 02002025 move       $a0, $s0
0015A660 92040045 lbu        $a0, 0x45($s0)
0015A664 149E0010 bne        $a0, $fp, 0x15a6a8
0015A668 00000000 nop        
0015A66C 8E240004 lw         $a0, 4($s1)
0015A670 34050003 ori        $a1, $zero, 3
0015A674 1085000C beq        $a0, $a1, 0x15a6a8
0015A678 00000000 nop        
0015A67C 34040003 ori        $a0, $zero, 3
0015A680 44806800 mtc1       $zero, $f13
0015A684 3C083DCC lui        $t0, 0x3dcc
0015A688 AE240004 sw         $a0, 4($s1)
0015A68C 3508CCCD ori        $t0, $t0, 0xcccd
0015A690 02002025 move       $a0, $s0
0015A694 44886000 mtc1       $t0, $f12
0015A698 34050003 ori        $a1, $zero, 3
0015A69C 00003025 move       $a2, $zero
0015A6A0 0C01AB54 jal        0x6ad50
0015A6A4 34070001 ori        $a3, $zero, 1
0015A6A8 27A40050 addiu      $a0, $sp, 0x50
0015A6AC 0C00C4D4 jal        0x31350
0015A6B0 02402825 move       $a1, $s2
0015A6B4 8FA40050 lw         $a0, 0x50($sp)
0015A6B8 30840020 andi       $a0, $a0, 0x20
0015A6BC 1080006C beqz       $a0, 0x15a870
0015A6C0 00000000 nop        
0015A6C4 0C0564B0 jal        0x1592c0
0015A6C8 02002025 move       $a0, $s0
0015A6CC 10400068 beqz       $v0, 0x15a870
0015A6D0 00000000 nop        
0015A6D4 264400C0 addiu      $a0, $s2, 0xc0
0015A6D8 8C840014 lw         $a0, 0x14($a0)
0015A6DC 30842000 andi       $a0, $a0, 0x2000
0015A6E0 1080005D beqz       $a0, 0x15a858
0015A6E4 00000000 nop        
0015A6E8 A2160045 sb         $s6, 0x45($s0)
0015A6EC 8E360008 lw         $s6, 8($s1)
0015A6F0 12C00007 beqz       $s6, 0x15a710
0015A6F4 00000000 nop        
0015A6F8 8E24003C lw         $a0, 0x3c($s1)
0015A6FC 10960004 beq        $a0, $s6, 0x15a710
0015A700 00000000 nop        
0015A704 44806000 mtc1       $zero, $f12
0015A708 E62C000C swc1       $f12, 0xc($s1)
0015A70C E60C0070 swc1       $f12, 0x70($s0)
0015A710 3C04002D lui        $a0, 0x2d
0015A714 8C845730 lw         $a0, 0x5730($a0)
0015A718 10800012 beqz       $a0, 0x15a764
0015A71C 00000000 nop        
0015A720 8E250188 lw         $a1, 0x188($s1)
0015A724 14A0000F bnez       $a1, 0x15a764
0015A728 00000000 nop        
0015A72C 1080000D beqz       $a0, 0x15a764
0015A730 00802825 move       $a1, $a0
0015A734 C4AC0014 lwc1       $f12, 0x14($a1)
0015A738 C4AD0018 lwc1       $f13, 0x18($a1)
0015A73C C4AE001C lwc1       $f14, 0x1c($a1)
0015A740 26260188 addiu      $a2, $s1, 0x188
0015A744 C4AF0020 lwc1       $f15, 0x20($a1)
0015A748 34070000 ori        $a3, $zero, 0
0015A74C 34090000 ori        $t1, $zero, 0
0015A750 340B0001 ori        $t3, $zero, 1
0015A754 340A0000 ori        $t2, $zero, 0
0015A758 02002025 move       $a0, $s0
0015A75C 0C01B147 jal        0x6c51c
0015A760 00004025 move       $t0, $zero
0015A764 3C05002D lui        $a1, 0x2d
0015A768 8CA5C588 lw         $a1, -0x3a78($a1)
0015A76C 34040009 ori        $a0, $zero, 9
0015A770 14A40009 bne        $a1, $a0, 0x15a798
0015A774 3C040009 lui        $a0, 9
0015A778 2484C928 addiu      $a0, $a0, -0x36d8
0015A77C 9085000D lbu        $a1, 0xd($a0)
0015A780 18A00005 blez       $a1, 0x15a798
0015A784 28A50040 slti       $a1, $a1, 0x40
0015A788 10A00003 beqz       $a1, 0x15a798
0015A78C 00000000 nop        
0015A790 34050080 ori        $a1, $zero, 0x80
0015A794 A085000D sb         $a1, 0xd($a0)
0015A798 8E240008 lw         $a0, 8($s1)
0015A79C 1080002B beqz       $a0, 0x15a84c
0015A7A0 00000000 nop        
0015A7A4 9225004C lbu        $a1, 0x4c($s1)
0015A7A8 10A00028 beqz       $a1, 0x15a84c
0015A7AC 00000000 nop        
0015A7B0 AE24003C sw         $a0, 0x3c($s1)
0015A7B4 8E64003C lw         $a0, 0x3c($s3)
0015A7B8 3C05002D lui        $a1, 0x2d
0015A7BC 00042080 sll        $a0, $a0, 2
0015A7C0 24A555D8 addiu      $a1, $a1, 0x55d8
0015A7C4 C62C000C lwc1       $f12, 0xc($s1)
0015A7C8 00852021 addu       $a0, $a0, $a1
0015A7CC C48D0000 lwc1       $f13, ($a0)
0015A7D0 02002025 move       $a0, $s0
0015A7D4 460D6300 add.s      $f12, $f12, $f13
0015A7D8 0C05671C jal        0x159c70
0015A7DC E62C000C swc1       $f12, 0xc($s1)
0015A7E0 0C00C41E jal        0x31078
0015A7E4 02402025 move       $a0, $s2
0015A7E8 1040001F beqz       $v0, 0x15a868
0015A7EC 00000000 nop        
0015A7F0 C62D000C lwc1       $f13, 0xc($s1)
0015A7F4 C62C002C lwc1       $f12, 0x2c($s1)
0015A7F8 460C6B43 div.s      $f13, $f13, $f12
0015A7FC 3C043F80 lui        $a0, 0x3f80
0015A800 44846000 mtc1       $a0, $f12
0015A804 460D603C c.lt.s     $f12, $f13
0015A808 00000000 nop        
0015A80C 45030001 bc1tl      0x15a814
0015A810 46006346 mov.s      $f13, $f12
0015A814 46006B06 mov.s      $f12, $f13
0015A818 0C0291D8 jal        0xa4760
0015A81C 34040003 ori        $a0, $zero, 3
0015A820 C62C000C lwc1       $f12, 0xc($s1)
0015A824 C62E002C lwc1       $f14, 0x2c($s1)
0015A828 460E603E c.le.s     $f12, $f14
0015A82C 00000000 nop        
0015A830 45010004 bc1t       0x15a844
0015A834 00000000 nop        
0015A838 8E250008 lw         $a1, 8($s1)
0015A83C 0C056384 jal        0x158e10
0015A840 02002025 move       $a0, $s0
0015A844 10000008 b          0x15a868
0015A848 00000000 nop        
0015A84C 44806000 mtc1       $zero, $f12
0015A850 10000005 b          0x15a868
0015A854 E62C000C swc1       $f12, 0xc($s1)
0015A858 02002025 move       $a0, $s0
0015A85C 02A02825 move       $a1, $s5
0015A860 0C056490 jal        0x159240
0015A864 02803025 move       $a2, $s4
0015A868 10000006 b          0x15a884
0015A86C C7AC0030 lwc1       $f12, 0x30($sp)
0015A870 02002025 move       $a0, $s0
0015A874 02A02825 move       $a1, $s5
0015A878 0C056490 jal        0x159240
0015A87C 02803025 move       $a2, $s4
0015A880 C7AC0030 lwc1       $f12, 0x30($sp)
0015A884 E62C0030 swc1       $f12, 0x30($s1)
0015A888 C7AC0034 lwc1       $f12, 0x34($sp)
0015A88C E62C0034 swc1       $f12, 0x34($s1)
0015A890 C7AC0038 lwc1       $f12, 0x38($sp)
0015A894 E62C0038 swc1       $f12, 0x38($s1)
0015A898 C7B40070 lwc1       $f20, 0x70($sp)
0015A89C 8FB00074 lw         $s0, 0x74($sp)
0015A8A0 8FB10078 lw         $s1, 0x78($sp)
0015A8A4 8FB2007C lw         $s2, 0x7c($sp)
0015A8A8 8FB30080 lw         $s3, 0x80($sp)
0015A8AC 8FB40084 lw         $s4, 0x84($sp)
0015A8B0 8FB50088 lw         $s5, 0x88($sp)
0015A8B4 8FB6008C lw         $s6, 0x8c($sp)
0015A8B8 8FB70090 lw         $s7, 0x90($sp)
0015A8BC 8FBE0094 lw         $fp, 0x94($sp)
0015A8C0 8FBF0098 lw         $ra, 0x98($sp)
0015A8C4 03E00008 jr         $ra
0015A8C8 27BD00A0 addiu      $sp, $sp, 0xa0