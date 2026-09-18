
CALLBACK 0x0016F1DC end 0x0016F1E4 ordinal 0

0016F1DC 03E00008 jr         $ra
0016F1E0 34020001 ori        $v0, $zero, 1

CALLBACK 0x0016F1E4 end 0x0016F228 ordinal 1

0016F1E4 27BDFFE0 addiu      $sp, $sp, -0x20
0016F1E8 AFBF0018 sw         $ra, 0x18($sp)
0016F1EC 8C840058 lw         $a0, 0x58($a0)
0016F1F0 34050000 ori        $a1, $zero, 0
0016F1F4 24840008 addiu      $a0, $a0, 8
0016F1F8 AFA50014 sw         $a1, 0x14($sp)
0016F1FC 0C017E49 jal        0x5f924
0016F200 AFA40010 sw         $a0, 0x10($sp)
0016F204 8FA50014 lw         $a1, 0x14($sp)
0016F208 8FA40010 lw         $a0, 0x10($sp)
0016F20C 24A50001 addiu      $a1, $a1, 1
0016F210 2CA60003 sltiu      $a2, $a1, 3
0016F214 14C0FFF8 bnez       $a2, 0x16f1f8
0016F218 2484003C addiu      $a0, $a0, 0x3c
0016F21C 8FBF0018 lw         $ra, 0x18($sp)
0016F220 03E00008 jr         $ra
0016F224 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0016F228 end 0x0016F4F0 ordinal 2

0016F228 27BDFF90 addiu      $sp, $sp, -0x70
0016F22C AFB30048 sw         $s3, 0x48($sp)
0016F230 00809825 move       $s3, $a0
0016F234 AFB0003C sw         $s0, 0x3c($sp)
0016F238 8E700058 lw         $s0, 0x58($s3)
0016F23C E7B40030 swc1       $f20, 0x30($sp)
0016F240 E7B60034 swc1       $f22, 0x34($sp)
0016F244 E7B80038 swc1       $f24, 0x38($sp)
0016F248 AFB10040 sw         $s1, 0x40($sp)
0016F24C AFB20044 sw         $s2, 0x44($sp)
0016F250 AFB4004C sw         $s4, 0x4c($sp)
0016F254 AFB50050 sw         $s5, 0x50($sp)
0016F258 AFB60054 sw         $s6, 0x54($sp)
0016F25C AFB70058 sw         $s7, 0x58($sp)
0016F260 AFBE005C sw         $fp, 0x5c($sp)
0016F264 AFBF0060 sw         $ra, 0x60($sp)
0016F268 0C05BD3C jal        0x16f4f0
0016F26C 8E040004 lw         $a0, 4($s0)
0016F270 14400003 bnez       $v0, 0x16f280
0016F274 920400D4 lbu        $a0, 0xd4($s0)
0016F278 10800005 beqz       $a0, 0x16f290
0016F27C 00000000 nop        
0016F280 10800008 beqz       $a0, 0x16f2a4
0016F284 00000000 nop        
0016F288 1000000C b          0x16f2bc
0016F28C 8E040000 lw         $a0, ($s0)
0016F290 02602025 move       $a0, $s3
0016F294 0C01A8F0 jal        0x6a3c0
0016F298 34050001 ori        $a1, $zero, 1
0016F29C 10000085 b          0x16f4b4
0016F2A0 00000000 nop        
0016F2A4 8E040004 lw         $a0, 4($s0)
0016F2A8 260500C8 addiu      $a1, $s0, 0xc8
0016F2AC 00003025 move       $a2, $zero
0016F2B0 0C01B0C6 jal        0x6c318
0016F2B4 00003825 move       $a3, $zero
0016F2B8 8E040000 lw         $a0, ($s0)
0016F2BC 24840030 addiu      $a0, $a0, 0x30
0016F2C0 C48C0000 lwc1       $f12, ($a0)
0016F2C4 3C053F00 lui        $a1, 0x3f00
0016F2C8 E60C00BC swc1       $f12, 0xbc($s0)
0016F2CC 4485A000 mtc1       $a1, $f20
0016F2D0 C48C0004 lwc1       $f12, 4($a0)
0016F2D4 E60C00C0 swc1       $f12, 0xc0($s0)
0016F2D8 C60C00C0 lwc1       $f12, 0xc0($s0)
0016F2DC C48D0008 lwc1       $f13, 8($a0)
0016F2E0 46146300 add.s      $f12, $f12, $f20
0016F2E4 34040007 ori        $a0, $zero, 7
0016F2E8 E60D00C4 swc1       $f13, 0xc4($s0)
0016F2EC 2405FFFF addiu      $a1, $zero, -1
0016F2F0 0C00810D jal        0x20434
0016F2F4 E60C00C0 swc1       $f12, 0xc0($s0)
0016F2F8 3C043480 lui        $a0, 0x3480
0016F2FC 4484B000 mtc1       $a0, $f22
0016F300 02009025 move       $s2, $s0
0016F304 3C043F80 lui        $a0, 0x3f80
0016F308 3C16002D lui        $s6, 0x2d
0016F30C 4484C000 mtc1       $a0, $f24
0016F310 34140000 ori        $s4, $zero, 0
0016F314 341E0001 ori        $fp, $zero, 1
0016F318 245700DF addiu      $s7, $v0, 0xdf
0016F31C 27B50020 addiu      $s5, $sp, 0x20
0016F320 26510008 addiu      $s1, $s2, 8
0016F324 26D6B0CC addiu      $s6, $s6, -0x4f34
0016F328 0C017EB3 jal        0x5facc
0016F32C 02202025 move       $a0, $s1
0016F330 82440038 lb         $a0, 0x38($s2)
0016F334 149E004D bne        $a0, $fp, 0x16f46c
0016F338 00000000 nop        
0016F33C 920400D4 lbu        $a0, 0xd4($s0)
0016F340 1480004A bnez       $a0, 0x16f46c
0016F344 00000000 nop        
0016F348 8E040004 lw         $a0, 4($s0)
0016F34C C66C0030 lwc1       $f12, 0x30($s3)
0016F350 24840030 addiu      $a0, $a0, 0x30
0016F354 C48D0000 lwc1       $f13, ($a0)
0016F358 C66E0034 lwc1       $f14, 0x34($s3)
0016F35C 460D6301 sub.s      $f12, $f12, $f13
0016F360 C66F0038 lwc1       $f15, 0x38($s3)
0016F364 E7AC0020 swc1       $f12, 0x20($sp)
0016F368 C48D0004 lwc1       $f13, 4($a0)
0016F36C 460C6402 mul.s      $f16, $f12, $f12
0016F370 460D7341 sub.s      $f13, $f14, $f13
0016F374 E7AD0024 swc1       $f13, 0x24($sp)
0016F378 460D6C42 mul.s      $f17, $f13, $f13
0016F37C C48E0008 lwc1       $f14, 8($a0)
0016F380 460E7B81 sub.s      $f14, $f15, $f14
0016F384 461183C0 add.s      $f15, $f16, $f17
0016F388 460E7482 mul.s      $f18, $f14, $f14
0016F38C 46127BC0 add.s      $f15, $f15, $f18
0016F390 4616783C c.lt.s     $f15, $f22
0016F394 00000000 nop        
0016F398 45000004 bc1f       0x16f3ac
0016F39C E7AE0028 swc1       $f14, 0x28($sp)
0016F3A0 8E040004 lw         $a0, 4($s0)
0016F3A4 1000000B b          0x16f3d4
0016F3A8 24850030 addiu      $a1, $a0, 0x30
0016F3AC 46007BC4 sqrt.s     $f15, $f15
0016F3B0 460FC3C3 div.s      $f15, $f24, $f15
0016F3B4 460F6302 mul.s      $f12, $f12, $f15
0016F3B8 460F6B42 mul.s      $f13, $f13, $f15
0016F3BC 460F7382 mul.s      $f14, $f14, $f15
0016F3C0 E7AC0020 swc1       $f12, 0x20($sp)
0016F3C4 E7AD0024 swc1       $f13, 0x24($sp)
0016F3C8 E7AE0028 swc1       $f14, 0x28($sp)
0016F3CC 8E040004 lw         $a0, 4($s0)
0016F3D0 24850030 addiu      $a1, $a0, 0x30
0016F3D4 00803025 move       $a2, $a0
0016F3D8 8CC70040 lw         $a3, 0x40($a2)
0016F3DC 8CE70020 lw         $a3, 0x20($a3)
0016F3E0 54E00004 bnel       $a3, $zero, 0x16f3f4
0016F3E4 00172100 sll        $a0, $s7, 4
0016F3E8 2406FFFF addiu      $a2, $zero, -1
0016F3EC 10000017 b          0x16f44c
0016F3F0 8E050000 lw         $a1, ($s0)
0016F3F4 00962021 addu       $a0, $a0, $s6
0016F3F8 8C880000 lw         $t0, ($a0)
0016F3FC 29090002 slti       $t1, $t0, 2
0016F400 15200006 bnez       $t1, 0x16f41c
0016F404 C48C0004 lwc1       $f12, 4($a0)
0016F408 29080003 slti       $t0, $t0, 3
0016F40C 11000003 beqz       $t0, 0x16f41c
0016F410 00000000 nop        
0016F414 10000001 b          0x16f41c
0016F418 46146302 mul.s      $f12, $f12, $f20
0016F41C 00E05025 move       $t2, $a3
0016F420 00A03825 move       $a3, $a1
0016F424 8C850008 lw         $a1, 8($a0)
0016F428 8C89000C lw         $t1, 0xc($a0)
0016F42C 00C02025 move       $a0, $a2
0016F430 01203025 move       $a2, $t1
0016F434 02A04025 move       $t0, $s5
0016F438 0140F809 jalr       $t2
0016F43C 02604825 move       $t1, $s3
0016F440 8E040004 lw         $a0, 4($s0)
0016F444 00403025 move       $a2, $v0
0016F448 8E050000 lw         $a1, ($s0)
0016F44C 00C03825 move       $a3, $a2
0016F450 00803025 move       $a2, $a0
0016F454 00A02025 move       $a0, $a1
0016F458 0C004249 jal        0x10924
0016F45C 34050007 ori        $a1, $zero, 7
0016F460 34040001 ori        $a0, $zero, 1
0016F464 10000007 b          0x16f484
0016F468 A20400D4 sb         $a0, 0xd4($s0)
0016F46C 82240030 lb         $a0, 0x30($s1)
0016F470 38840003 xori       $a0, $a0, 3
0016F474 2C840001 sltiu      $a0, $a0, 1
0016F478 308400FF andi       $a0, $a0, 0xff
0016F47C 14800008 bnez       $a0, 0x16f4a0
0016F480 00000000 nop        
0016F484 26940001 addiu      $s4, $s4, 1
0016F488 2652003C addiu      $s2, $s2, 0x3c
0016F48C 2E840003 sltiu      $a0, $s4, 3
0016F490 1480FFA5 bnez       $a0, 0x16f328
0016F494 2631003C addiu      $s1, $s1, 0x3c
0016F498 10000006 b          0x16f4b4
0016F49C 00000000 nop        
0016F4A0 02602025 move       $a0, $s3
0016F4A4 0C01A8F0 jal        0x6a3c0
0016F4A8 34050001 ori        $a1, $zero, 1
0016F4AC 10000001 b          0x16f4b4
0016F4B0 00000000 nop        
0016F4B4 C7B40030 lwc1       $f20, 0x30($sp)
0016F4B8 C7B60034 lwc1       $f22, 0x34($sp)
0016F4BC C7B80038 lwc1       $f24, 0x38($sp)
0016F4C0 8FB0003C lw         $s0, 0x3c($sp)
0016F4C4 8FB10040 lw         $s1, 0x40($sp)
0016F4C8 8FB20044 lw         $s2, 0x44($sp)
0016F4CC 8FB30048 lw         $s3, 0x48($sp)
0016F4D0 8FB4004C lw         $s4, 0x4c($sp)
0016F4D4 8FB50050 lw         $s5, 0x50($sp)
0016F4D8 8FB60054 lw         $s6, 0x54($sp)
0016F4DC 8FB70058 lw         $s7, 0x58($sp)
0016F4E0 8FBE005C lw         $fp, 0x5c($sp)
0016F4E4 8FBF0060 lw         $ra, 0x60($sp)
0016F4E8 03E00008 jr         $ra
0016F4EC 27BD0070 addiu      $sp, $sp, 0x70