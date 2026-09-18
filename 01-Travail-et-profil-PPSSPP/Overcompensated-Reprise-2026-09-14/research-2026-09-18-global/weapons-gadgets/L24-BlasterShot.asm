
CALLBACK 0x0010EBF0 end 0x0010EC18 ordinal 0

0010EBF0 27BDFFE0 addiu      $sp, $sp, -0x20
0010EBF4 8C840058 lw         $a0, 0x58($a0)
0010EBF8 00002825 move       $a1, $zero
0010EBFC AFBF0010 sw         $ra, 0x10($sp)
0010EC00 0C0600AC jal        0x1802b0
0010EC04 340600A4 ori        $a2, $zero, 0xa4
0010EC08 34020001 ori        $v0, $zero, 1
0010EC0C 8FBF0010 lw         $ra, 0x10($sp)
0010EC10 03E00008 jr         $ra
0010EC14 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0010EC18 end 0x0010EC20 ordinal 1

0010EC18 03E00008 jr         $ra
0010EC1C 00000000 nop        

CALLBACK 0x0010EFBC end 0x0010F5C0 ordinal 2

0010EFBC 27BDFF20 addiu      $sp, $sp, -0xe0
0010EFC0 AFB100BC sw         $s1, 0xbc($sp)
0010EFC4 8C910058 lw         $s1, 0x58($a0)
0010EFC8 E7B400A8 swc1       $f20, 0xa8($sp)
0010EFCC C4940070 lwc1       $f20, 0x70($a0)
0010EFD0 3C053F80 lui        $a1, 0x3f80
0010EFD4 E7B600AC swc1       $f22, 0xac($sp)
0010EFD8 4485B000 mtc1       $a1, $f22
0010EFDC 4616A300 add.s      $f12, $f20, $f22
0010EFE0 AFB200C0 sw         $s2, 0xc0($sp)
0010EFE4 8E320000 lw         $s2, ($s1)
0010EFE8 3C05002A lui        $a1, 0x2a
0010EFEC 3C063C88 lui        $a2, 0x3c88
0010EFF0 E48C0070 swc1       $f12, 0x70($a0)
0010EFF4 34C6893B ori        $a2, $a2, 0x893b
0010EFF8 C4AED9A8 lwc1       $f14, -0x2658($a1)
0010EFFC 44866800 mtc1       $a2, $f13
0010F000 460D7342 mul.s      $f13, $f14, $f13
0010F004 3C0541F0 lui        $a1, 0x41f0
0010F008 44857800 mtc1       $a1, $f15
0010F00C 460F6B42 mul.s      $f13, $f13, $f15
0010F010 C65009DC lwc1       $f16, 0x9dc($s2)
0010F014 46106B42 mul.s      $f13, $f13, $f16
0010F018 E7B800B0 swc1       $f24, 0xb0($sp)
0010F01C E7BA00B4 swc1       $f26, 0xb4($sp)
0010F020 AFB000B8 sw         $s0, 0xb8($sp)
0010F024 AFB300C4 sw         $s3, 0xc4($sp)
0010F028 460D603C c.lt.s     $f12, $f13
0010F02C AFB400C8 sw         $s4, 0xc8($sp)
0010F030 AFB500CC sw         $s5, 0xcc($sp)
0010F034 AFBF00D0 sw         $ra, 0xd0($sp)
0010F038 45000020 bc1f       0x10f0bc
0010F03C 00808025 move       $s0, $a0
0010F040 C60C0030 lwc1       $f12, 0x30($s0)
0010F044 C60D0034 lwc1       $f13, 0x34($s0)
0010F048 E7AC0020 swc1       $f12, 0x20($sp)
0010F04C C60E0038 lwc1       $f14, 0x38($s0)
0010F050 E7AD0024 swc1       $f13, 0x24($sp)
0010F054 C60F003C lwc1       $f15, 0x3c($s0)
0010F058 E7AE0028 swc1       $f14, 0x28($sp)
0010F05C E7AF002C swc1       $f15, 0x2c($sp)
0010F060 C6300010 lwc1       $f16, 0x10($s1)
0010F064 46106300 add.s      $f12, $f12, $f16
0010F068 3C040028 lui        $a0, 0x28
0010F06C 3C053480 lui        $a1, 0x3480
0010F070 4480D000 mtc1       $zero, $f26
0010F074 E60C0030 swc1       $f12, 0x30($s0)
0010F078 C6310014 lwc1       $f17, 0x14($s1)
0010F07C 46116B40 add.s      $f13, $f13, $f17
0010F080 27B50020 addiu      $s5, $sp, 0x20
0010F084 E60D0034 swc1       $f13, 0x34($s0)
0010F088 C6320018 lwc1       $f18, 0x18($s1)
0010F08C E7AC0030 swc1       $f12, 0x30($sp)
0010F090 46127380 add.s      $f14, $f14, $f18
0010F094 E7AD0034 swc1       $f13, 0x34($sp)
0010F098 E7AF003C swc1       $f15, 0x3c($sp)
0010F09C E60E0038 swc1       $f14, 0x38($s0)
0010F0A0 E7AE0038 swc1       $f14, 0x38($sp)
0010F0A4 90849C51 lbu        $a0, -0x63af($a0)
0010F0A8 10800009 beqz       $a0, 0x10f0d0
0010F0AC 4485C000 mtc1       $a1, $f24
0010F0B0 3C050006 lui        $a1, 6
0010F0B4 10000007 b          0x10f0d4
0010F0B8 24A5E268 addiu      $a1, $a1, -0x1d98
0010F0BC 02002025 move       $a0, $s0
0010F0C0 0C0192FF jal        0x64bfc
0010F0C4 34050001 ori        $a1, $zero, 1
0010F0C8 10000130 b          0x10f58c
0010F0CC 00000000 nop        
0010F0D0 34050000 ori        $a1, $zero, 0
0010F0D4 10A00008 beqz       $a1, 0x10f0f8
0010F0D8 3C13002A lui        $s3, 0x2a
0010F0DC 10800004 beqz       $a0, 0x10f0f0
0010F0E0 34130000 ori        $s3, $zero, 0
0010F0E4 3C130006 lui        $s3, 6
0010F0E8 10000001 b          0x10f0f0
0010F0EC 2673E268 addiu      $s3, $s3, -0x1d98
0010F0F0 10000002 b          0x10f0fc
0010F0F4 00000000 nop        
0010F0F8 26739A50 addiu      $s3, $s3, -0x65b0
0010F0FC 3C05FF40 lui        $a1, 0xff40
0010F100 3C064120 lui        $a2, 0x4120
0010F104 27A40030 addiu      $a0, $sp, 0x30
0010F108 44866000 mtc1       $a2, $f12
0010F10C 0C01CC7B jal        0x731ec
0010F110 24A5CCFF addiu      $a1, $a1, -0x3301
0010F114 C62D0010 lwc1       $f13, 0x10($s1)
0010F118 C62C0014 lwc1       $f12, 0x14($s1)
0010F11C 460D6B82 mul.s      $f14, $f13, $f13
0010F120 C62F0018 lwc1       $f15, 0x18($s1)
0010F124 460C6302 mul.s      $f12, $f12, $f12
0010F128 460F7BC2 mul.s      $f15, $f15, $f15
0010F12C 34140000 ori        $s4, $zero, 0
0010F130 460C7300 add.s      $f12, $f14, $f12
0010F134 460F6300 add.s      $f12, $f12, $f15
0010F138 4618603C c.lt.s     $f12, $f24
0010F13C 00000000 nop        
0010F140 45000008 bc1f       0x10f164
0010F144 00000000 nop        
0010F148 E7AD005C swc1       $f13, 0x5c($sp)
0010F14C 4600D306 mov.s      $f12, $f26
0010F150 C62D0014 lwc1       $f13, 0x14($s1)
0010F154 E7AD0060 swc1       $f13, 0x60($sp)
0010F158 C62D0018 lwc1       $f13, 0x18($s1)
0010F15C 1000000B b          0x10f18c
0010F160 E7AD0064 swc1       $f13, 0x64($sp)
0010F164 46006304 sqrt.s     $f12, $f12
0010F168 460CB383 div.s      $f14, $f22, $f12
0010F16C 460D7342 mul.s      $f13, $f14, $f13
0010F170 E7AD005C swc1       $f13, 0x5c($sp)
0010F174 C62D0014 lwc1       $f13, 0x14($s1)
0010F178 460D7342 mul.s      $f13, $f14, $f13
0010F17C E7AD0060 swc1       $f13, 0x60($sp)
0010F180 C62D0018 lwc1       $f13, 0x18($s1)
0010F184 460D7342 mul.s      $f13, $f14, $f13
0010F188 E7AD0064 swc1       $f13, 0x64($sp)
0010F18C 34080028 ori        $t0, $zero, 0x28
0010F190 34090000 ori        $t1, $zero, 0
0010F194 27A40058 addiu      $a0, $sp, 0x58
0010F198 27A50040 addiu      $a1, $sp, 0x40
0010F19C 27A7005C addiu      $a3, $sp, 0x5c
0010F1A0 02A03025 move       $a2, $s5
0010F1A4 0C006C84 jal        0x1b210
0010F1A8 00005025 move       $t2, $zero
0010F1AC 10400089 beqz       $v0, 0x10f3d4
0010F1B0 3C043F37 lui        $a0, 0x3f37
0010F1B4 8FA40050 lw         $a0, 0x50($sp)
0010F1B8 8E450594 lw         $a1, 0x594($s2)
0010F1BC 10850085 beq        $a0, $a1, 0x10f3d4
0010F1C0 3C043F37 lui        $a0, 0x3f37
0010F1C4 C7AC0058 lwc1       $f12, 0x58($sp)
0010F1C8 3C04002A lui        $a0, 0x2a
0010F1CC C48DD9B4 lwc1       $f13, -0x264c($a0)
0010F1D0 C7AE005C lwc1       $f14, 0x5c($sp)
0010F1D4 460D6302 mul.s      $f12, $f12, $f13
0010F1D8 460E63C2 mul.s      $f15, $f12, $f14
0010F1DC E62F0010 swc1       $f15, 0x10($s1)
0010F1E0 C7B00060 lwc1       $f16, 0x60($sp)
0010F1E4 46106402 mul.s      $f16, $f12, $f16
0010F1E8 E6300014 swc1       $f16, 0x14($s1)
0010F1EC C7B00064 lwc1       $f16, 0x64($sp)
0010F1F0 46106302 mul.s      $f12, $f12, $f16
0010F1F4 34050002 ori        $a1, $zero, 2
0010F1F8 E62C0018 swc1       $f12, 0x18($s1)
0010F1FC C7AE0020 lwc1       $f14, 0x20($sp)
0010F200 C7AD0024 lwc1       $f13, 0x24($sp)
0010F204 460F73C0 add.s      $f15, $f14, $f15
0010F208 C7AC0028 lwc1       $f12, 0x28($sp)
0010F20C 8FA40054 lw         $a0, 0x54($sp)
0010F210 E60F0030 swc1       $f15, 0x30($s0)
0010F214 C62F0014 lwc1       $f15, 0x14($s1)
0010F218 460F6BC0 add.s      $f15, $f13, $f15
0010F21C E60F0034 swc1       $f15, 0x34($s0)
0010F220 C62F0018 lwc1       $f15, 0x18($s1)
0010F224 460F63C0 add.s      $f15, $f12, $f15
0010F228 1485005E bne        $a0, $a1, 0x10f3a4
0010F22C E60F0038 swc1       $f15, 0x38($s0)
0010F230 8FA50050 lw         $a1, 0x50($sp)
0010F234 8E24000C lw         $a0, 0xc($s1)
0010F238 10A4005A beq        $a1, $a0, 0x10f3a4
0010F23C 00000000 nop        
0010F240 8CA40040 lw         $a0, 0x40($a1)
0010F244 8C840020 lw         $a0, 0x20($a0)
0010F248 10800056 beqz       $a0, 0x10f3a4
0010F24C 00000000 nop        
0010F250 C60F0030 lwc1       $f15, 0x30($s0)
0010F254 C6100034 lwc1       $f16, 0x34($s0)
0010F258 460E7BC1 sub.s      $f15, $f15, $f14
0010F25C 460D8341 sub.s      $f13, $f16, $f13
0010F260 C60E0038 lwc1       $f14, 0x38($s0)
0010F264 460D6C42 mul.s      $f17, $f13, $f13
0010F268 460C7381 sub.s      $f14, $f14, $f12
0010F26C E7AF0098 swc1       $f15, 0x98($sp)
0010F270 E7AD009C swc1       $f13, 0x9c($sp)
0010F274 46007B06 mov.s      $f12, $f15
0010F278 460C6482 mul.s      $f18, $f12, $f12
0010F27C 460E73C2 mul.s      $f15, $f14, $f14
0010F280 46119440 add.s      $f17, $f18, $f17
0010F284 460F8BC0 add.s      $f15, $f17, $f15
0010F288 4618783C c.lt.s     $f15, $f24
0010F28C 00000000 nop        
0010F290 45000003 bc1f       0x10f2a0
0010F294 E7AE00A0 swc1       $f14, 0xa0($sp)
0010F298 1000000A b          0x10f2c4
0010F29C 8E270004 lw         $a3, 4($s1)
0010F2A0 46007BC4 sqrt.s     $f15, $f15
0010F2A4 460FB3C3 div.s      $f15, $f22, $f15
0010F2A8 460F6302 mul.s      $f12, $f12, $f15
0010F2AC 460F6B42 mul.s      $f13, $f13, $f15
0010F2B0 460F7382 mul.s      $f14, $f14, $f15
0010F2B4 E7AC0098 swc1       $f12, 0x98($sp)
0010F2B8 E7AD009C swc1       $f13, 0x9c($sp)
0010F2BC E7AE00A0 swc1       $f14, 0xa0($sp)
0010F2C0 8E270004 lw         $a3, 4($s1)
0010F2C4 00A02025 move       $a0, $a1
0010F2C8 8C860040 lw         $a2, 0x40($a0)
0010F2CC 8CC60020 lw         $a2, 0x20($a2)
0010F2D0 54C00004 bnel       $a2, $zero, 0x10f2e4
0010F2D4 00072900 sll        $a1, $a3, 4
0010F2D8 2406FFFF addiu      $a2, $zero, -1
0010F2DC 10000018 b          0x10f340
0010F2E0 8E240000 lw         $a0, ($s1)
0010F2E4 3C07002A lui        $a3, 0x2a
0010F2E8 24E7A864 addiu      $a3, $a3, -0x579c
0010F2EC 00A72821 addu       $a1, $a1, $a3
0010F2F0 8CA70000 lw         $a3, ($a1)
0010F2F4 28E80002 slti       $t0, $a3, 2
0010F2F8 15000007 bnez       $t0, 0x10f318
0010F2FC C4AC0004 lwc1       $f12, 4($a1)
0010F300 28E70003 slti       $a3, $a3, 3
0010F304 10E00004 beqz       $a3, 0x10f318
0010F308 3C073F00 lui        $a3, 0x3f00
0010F30C 44876800 mtc1       $a3, $f13
0010F310 10000001 b          0x10f318
0010F314 460D6302 mul.s      $f12, $f12, $f13
0010F318 00C05025 move       $t2, $a2
0010F31C 8CA6000C lw         $a2, 0xc($a1)
0010F320 8CA50008 lw         $a1, 8($a1)
0010F324 27A80098 addiu      $t0, $sp, 0x98
0010F328 02A03825 move       $a3, $s5
0010F32C 0140F809 jalr       $t2
0010F330 02004825 move       $t1, $s0
0010F334 8E240000 lw         $a0, ($s1)
0010F338 00403025 move       $a2, $v0
0010F33C 8FA50050 lw         $a1, 0x50($sp)
0010F340 00C03825 move       $a3, $a2
0010F344 00A03025 move       $a2, $a1
0010F348 0C003EC2 jal        0xfb08
0010F34C 34050002 ori        $a1, $zero, 2
0010F350 10400014 beqz       $v0, 0x10f3a4
0010F354 00000000 nop        
0010F358 8E250000 lw         $a1, ($s1)
0010F35C 34040002 ori        $a0, $zero, 2
0010F360 0C007870 jal        0x1e1c0
0010F364 8CA500F0 lw         $a1, 0xf0($a1)
0010F368 34040003 ori        $a0, $zero, 3
0010F36C 1444000D bne        $v0, $a0, 0x10f3a4
0010F370 00000000 nop        
0010F374 8E250000 lw         $a1, ($s1)
0010F378 0C0439D6 jal        0x10e758
0010F37C 02002025 move       $a0, $s0
0010F380 00409025 move       $s2, $v0
0010F384 12400007 beqz       $s2, 0x10f3a4
0010F388 00000000 nop        
0010F38C 8E24000C lw         $a0, 0xc($s1)
0010F390 0C043477 jal        0x10d1dc
0010F394 02402825 move       $a1, $s2
0010F398 8E240000 lw         $a0, ($s1)
0010F39C 8E450058 lw         $a1, 0x58($s2)
0010F3A0 ACA40000 sw         $a0, ($a1)
0010F3A4 0C044268 jal        0x1109a0
0010F3A8 02002025 move       $a0, $s0
0010F3AC 3C04002A lui        $a0, 0x2a
0010F3B0 8C84D9B8 lw         $a0, -0x2648($a0)
0010F3B4 10800005 beqz       $a0, 0x10f3cc
0010F3B8 00000000 nop        
0010F3BC 26050030 addiu      $a1, $s0, 0x30
0010F3C0 4600D306 mov.s      $f12, $f26
0010F3C4 0C01E518 jal        0x79460
0010F3C8 00003025 move       $a2, $zero
0010F3CC 34140001 ori        $s4, $zero, 1
0010F3D0 3C043F37 lui        $a0, 0x3f37
0010F3D4 34848D50 ori        $a0, $a0, 0x8d50
0010F3D8 44846000 mtc1       $a0, $f12
0010F3DC E7BA006C swc1       $f26, 0x6c($sp)
0010F3E0 E7AC0068 swc1       $f12, 0x68($sp)
0010F3E4 E7AC0070 swc1       $f12, 0x70($sp)
0010F3E8 E7BA0074 swc1       $f26, 0x74($sp)
0010F3EC C62E0010 lwc1       $f14, 0x10($s1)
0010F3F0 C62C0014 lwc1       $f12, 0x14($s1)
0010F3F4 460E7342 mul.s      $f13, $f14, $f14
0010F3F8 C62F0018 lwc1       $f15, 0x18($s1)
0010F3FC 460C6402 mul.s      $f16, $f12, $f12
0010F400 C7BA0020 lwc1       $f26, 0x20($sp)
0010F404 460F7BC2 mul.s      $f15, $f15, $f15
0010F408 46106C00 add.s      $f16, $f13, $f16
0010F40C C7AC0024 lwc1       $f12, 0x24($sp)
0010F410 460F83C0 add.s      $f15, $f16, $f15
0010F414 4618783C c.lt.s     $f15, $f24
0010F418 00000000 nop        
0010F41C 4500000D bc1f       0x10f454
0010F420 C7AD0028 lwc1       $f13, 0x28($sp)
0010F424 C7AF0068 lwc1       $f15, 0x68($sp)
0010F428 C7B0006C lwc1       $f16, 0x6c($sp)
0010F42C C6710020 lwc1       $f17, 0x20($s3)
0010F430 C6720024 lwc1       $f18, 0x24($s3)
0010F434 46117BC2 mul.s      $f15, $f15, $f17
0010F438 C7B30070 lwc1       $f19, 0x70($sp)
0010F43C 46128402 mul.s      $f16, $f16, $f18
0010F440 C6600028 lwc1       $f0, 0x28($s3)
0010F444 46009CC2 mul.s      $f19, $f19, $f0
0010F448 46107BC0 add.s      $f15, $f15, $f16
0010F44C 10000014 b          0x10f4a0
0010F450 46137BC0 add.s      $f15, $f15, $f19
0010F454 46007BC4 sqrt.s     $f15, $f15
0010F458 460FB3C3 div.s      $f15, $f22, $f15
0010F45C 460E7B82 mul.s      $f14, $f15, $f14
0010F460 E7AE0068 swc1       $f14, 0x68($sp)
0010F464 C6300014 lwc1       $f16, 0x14($s1)
0010F468 46107C02 mul.s      $f16, $f15, $f16
0010F46C E7B0006C swc1       $f16, 0x6c($sp)
0010F470 C6310018 lwc1       $f17, 0x18($s1)
0010F474 46117BC2 mul.s      $f15, $f15, $f17
0010F478 E7AF0070 swc1       $f15, 0x70($sp)
0010F47C C6720020 lwc1       $f18, 0x20($s3)
0010F480 C6730024 lwc1       $f19, 0x24($s3)
0010F484 46127482 mul.s      $f18, $f14, $f18
0010F488 C6600028 lwc1       $f0, 0x28($s3)
0010F48C 46138402 mul.s      $f16, $f16, $f19
0010F490 46007BC2 mul.s      $f15, $f15, $f0
0010F494 C62E0010 lwc1       $f14, 0x10($s1)
0010F498 46109400 add.s      $f16, $f18, $f16
0010F49C 460F83C0 add.s      $f15, $f16, $f15
0010F4A0 3C044000 lui        $a0, 0x4000
0010F4A4 44848000 mtc1       $a0, $f16
0010F4A8 4610A03C c.lt.s     $f20, $f16
0010F4AC 00000000 nop        
0010F4B0 4500000B bc1f       0x10f4e0
0010F4B4 3C043F33 lui        $a0, 0x3f33
0010F4B8 34843333 ori        $a0, $a0, 0x3333
0010F4BC 44848000 mtc1       $a0, $f16
0010F4C0 4610783C c.lt.s     $f15, $f16
0010F4C4 00000000 nop        
0010F4C8 45000005 bc1f       0x10f4e0
0010F4CC 00000000 nop        
0010F4D0 3C054140 lui        $a1, 0x4140
0010F4D4 3404000C ori        $a0, $zero, 0xc
0010F4D8 1000000E b          0x10f514
0010F4DC 44857800 mtc1       $a1, $f15
0010F4E0 3C043F00 lui        $a0, 0x3f00
0010F4E4 44848000 mtc1       $a0, $f16
0010F4E8 4610783C c.lt.s     $f15, $f16
0010F4EC 00000000 nop        
0010F4F0 45000005 bc1f       0x10f508
0010F4F4 00000000 nop        
0010F4F8 3C054000 lui        $a1, 0x4000
0010F4FC 34040002 ori        $a0, $zero, 2
0010F500 10000004 b          0x10f514
0010F504 44857800 mtc1       $a1, $f15
0010F508 3C0540C0 lui        $a1, 0x40c0
0010F50C 34040006 ori        $a0, $zero, 6
0010F510 44857800 mtc1       $a1, $f15
0010F514 04810003 bgez       $a0, 0x10f524
0010F518 3C044F80 lui        $a0, 0x4f80
0010F51C 44848000 mtc1       $a0, $f16
0010F520 46107BC0 add.s      $f15, $f15, $f16
0010F524 460FB3C3 div.s      $f15, $f22, $f15
0010F528 C7B0002C lwc1       $f16, 0x2c($sp)
0010F52C 02002025 move       $a0, $s0
0010F530 460E7B82 mul.s      $f14, $f15, $f14
0010F534 E7AE0078 swc1       $f14, 0x78($sp)
0010F538 C62E0014 lwc1       $f14, 0x14($s1)
0010F53C 460E7B82 mul.s      $f14, $f15, $f14
0010F540 E7AE007C swc1       $f14, 0x7c($sp)
0010F544 C62E0018 lwc1       $f14, 0x18($s1)
0010F548 E7BA0088 swc1       $f26, 0x88($sp)
0010F54C 460E7B82 mul.s      $f14, $f15, $f14
0010F550 E7AC008C swc1       $f12, 0x8c($sp)
0010F554 E7AD0090 swc1       $f13, 0x90($sp)
0010F558 E7B00094 swc1       $f16, 0x94($sp)
0010F55C 0C043D70 jal        0x10f5c0
0010F560 E7AE0080 swc1       $f14, 0x80($sp)
0010F564 0C043FFE jal        0x10fff8
0010F568 02002025 move       $a0, $s0
0010F56C 02002025 move       $a0, $s0
0010F570 0C043B08 jal        0x10ec20
0010F574 02A02825 move       $a1, $s5
0010F578 12800004 beqz       $s4, 0x10f58c
0010F57C 00000000 nop        
0010F580 02002025 move       $a0, $s0
0010F584 0C0192FF jal        0x64bfc
0010F588 34050001 ori        $a1, $zero, 1
0010F58C C7B400A8 lwc1       $f20, 0xa8($sp)
0010F590 C7B600AC lwc1       $f22, 0xac($sp)
0010F594 C7B800B0 lwc1       $f24, 0xb0($sp)
0010F598 C7BA00B4 lwc1       $f26, 0xb4($sp)
0010F59C 8FB000B8 lw         $s0, 0xb8($sp)
0010F5A0 8FB100BC lw         $s1, 0xbc($sp)
0010F5A4 8FB200C0 lw         $s2, 0xc0($sp)
0010F5A8 8FB300C4 lw         $s3, 0xc4($sp)
0010F5AC 8FB400C8 lw         $s4, 0xc8($sp)
0010F5B0 8FB500CC lw         $s5, 0xcc($sp)
0010F5B4 8FBF00D0 lw         $ra, 0xd0($sp)
0010F5B8 03E00008 jr         $ra
0010F5BC 27BD00E0 addiu      $sp, $sp, 0xe0