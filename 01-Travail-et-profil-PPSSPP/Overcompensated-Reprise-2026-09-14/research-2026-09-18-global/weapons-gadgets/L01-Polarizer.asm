
CALLBACK 0x0015E3B4 end 0x0015E570 ordinal 0

0015E3B4 27BDFFB0 addiu      $sp, $sp, -0x50
0015E3B8 AFB00020 sw         $s0, 0x20($sp)
0015E3BC 8C900058 lw         $s0, 0x58($a0)
0015E3C0 00002825 move       $a1, $zero
0015E3C4 02002025 move       $a0, $s0
0015E3C8 AFB10024 sw         $s1, 0x24($sp)
0015E3CC AFB20028 sw         $s2, 0x28($sp)
0015E3D0 AFB3002C sw         $s3, 0x2c($sp)
0015E3D4 AFB40030 sw         $s4, 0x30($sp)
0015E3D8 AFB50034 sw         $s5, 0x34($sp)
0015E3DC AFB60038 sw         $s6, 0x38($sp)
0015E3E0 AFB7003C sw         $s7, 0x3c($sp)
0015E3E4 AFBE0040 sw         $fp, 0x40($sp)
0015E3E8 AFBF0044 sw         $ra, 0x44($sp)
0015E3EC 0C06B6A7 jal        0x1ada9c
0015E3F0 34060184 ori        $a2, $zero, 0x184
0015E3F4 3C043E4C lui        $a0, 0x3e4c
0015E3F8 34110001 ori        $s1, $zero, 1
0015E3FC 3484CCCD ori        $a0, $a0, 0xcccd
0015E400 A2110149 sb         $s1, 0x149($s0)
0015E404 44846000 mtc1       $a0, $f12
0015E408 3C04447A lui        $a0, 0x447a
0015E40C E60C0048 swc1       $f12, 0x48($s0)
0015E410 44846800 mtc1       $a0, $f13
0015E414 E60C004C swc1       $f12, 0x4c($s0)
0015E418 3C08002D lui        $t0, 0x2d
0015E41C E60D0050 swc1       $f13, 0x50($s0)
0015E420 26040010 addiu      $a0, $s0, 0x10
0015E424 34050004 ori        $a1, $zero, 4
0015E428 34060042 ori        $a2, $zero, 0x42
0015E42C 34070043 ori        $a3, $zero, 0x43
0015E430 0C019B8F jal        0x66e3c
0015E434 25085CC4 addiu      $t0, $t0, 0x5cc4
0015E438 3C12002B lui        $s2, 0x2b
0015E43C 8E4400C0 lw         $a0, 0xc0($s2)
0015E440 3C05002D lui        $a1, 0x2d
0015E444 C4AC5CB4 lwc1       $f12, 0x5cb4($a1)
0015E448 3C05002D lui        $a1, 0x2d
0015E44C C4AD5CB8 lwc1       $f13, 0x5cb8($a1)
0015E450 3C05002D lui        $a1, 0x2d
0015E454 C4AE5CBC lwc1       $f14, 0x5cbc($a1)
0015E458 3C05002D lui        $a1, 0x2d
0015E45C 3C06002D lui        $a2, 0x2d
0015E460 34070001 ori        $a3, $zero, 1
0015E464 24A55C9C addiu      $a1, $a1, 0x5c9c
0015E468 0C01707F jal        0x5c1fc
0015E46C 24C65CA8 addiu      $a2, $a2, 0x5ca8
0015E470 8E4500C0 lw         $a1, 0xc0($s2)
0015E474 8CB205A8 lw         $s2, 0x5a8($a1)
0015E478 3C05002D lui        $a1, 0x2d
0015E47C 2613014C addiu      $s3, $s0, 0x14c
0015E480 26140158 addiu      $s4, $s0, 0x158
0015E484 26150164 addiu      $s5, $s0, 0x164
0015E488 3C16002D lui        $s6, 0x2d
0015E48C 26170181 addiu      $s7, $s0, 0x181
0015E490 24BE5C48 addiu      $fp, $a1, 0x5c48
0015E494 26040058 addiu      $a0, $s0, 0x58
0015E498 8EC65C70 lw         $a2, 0x5c70($s6)
0015E49C 03C02825 move       $a1, $fp
0015E4A0 02603825 move       $a3, $s3
0015E4A4 02804025 move       $t0, $s4
0015E4A8 02A04825 move       $t1, $s5
0015E4AC 02E05025 move       $t2, $s7
0015E4B0 0C038206 jal        0xe0818
0015E4B4 02405825 move       $t3, $s2
0015E4B8 8EC65C70 lw         $a2, 0x5c70($s6)
0015E4BC 26160170 addiu      $s6, $s0, 0x170
0015E4C0 26040094 addiu      $a0, $s0, 0x94
0015E4C4 03C02825 move       $a1, $fp
0015E4C8 02603825 move       $a3, $s3
0015E4CC 02804025 move       $t0, $s4
0015E4D0 02C04825 move       $t1, $s6
0015E4D4 02E05025 move       $t2, $s7
0015E4D8 0C038206 jal        0xe0818
0015E4DC 02405825 move       $t3, $s2
0015E4E0 3C05002D lui        $a1, 0x2d
0015E4E4 3C1E002D lui        $fp, 0x2d
0015E4E8 24B15C5C addiu      $s1, $a1, 0x5c5c
0015E4EC 260400D0 addiu      $a0, $s0, 0xd0
0015E4F0 8FC65C74 lw         $a2, 0x5c74($fp)
0015E4F4 02202825 move       $a1, $s1
0015E4F8 02603825 move       $a3, $s3
0015E4FC 02804025 move       $t0, $s4
0015E500 02A04825 move       $t1, $s5
0015E504 02E05025 move       $t2, $s7
0015E508 0C038206 jal        0xe0818
0015E50C 02405825 move       $t3, $s2
0015E510 8FC65C74 lw         $a2, 0x5c74($fp)
0015E514 2604010C addiu      $a0, $s0, 0x10c
0015E518 02202825 move       $a1, $s1
0015E51C 02603825 move       $a3, $s3
0015E520 02804025 move       $t0, $s4
0015E524 02C04825 move       $t1, $s6
0015E528 02E05025 move       $t2, $s7
0015E52C 0C038206 jal        0xe0818
0015E530 02405825 move       $t3, $s2
0015E534 34040001 ori        $a0, $zero, 1
0015E538 A2040181 sb         $a0, 0x181($s0)
0015E53C 34020001 ori        $v0, $zero, 1
0015E540 8FB00020 lw         $s0, 0x20($sp)
0015E544 8FB10024 lw         $s1, 0x24($sp)
0015E548 8FB20028 lw         $s2, 0x28($sp)
0015E54C 8FB3002C lw         $s3, 0x2c($sp)
0015E550 8FB40030 lw         $s4, 0x30($sp)
0015E554 8FB50034 lw         $s5, 0x34($sp)
0015E558 8FB60038 lw         $s6, 0x38($sp)
0015E55C 8FB7003C lw         $s7, 0x3c($sp)
0015E560 8FBE0040 lw         $fp, 0x40($sp)
0015E564 8FBF0044 lw         $ra, 0x44($sp)
0015E568 03E00008 jr         $ra
0015E56C 27BD0050 addiu      $sp, $sp, 0x50

CALLBACK 0x0015E570 end 0x0015E600 ordinal 1

0015E570 27BDFFE0 addiu      $sp, $sp, -0x20
0015E574 AFB00010 sw         $s0, 0x10($sp)
0015E578 00808025 move       $s0, $a0
0015E57C AFB10014 sw         $s1, 0x14($sp)
0015E580 8E110058 lw         $s1, 0x58($s0)
0015E584 8E240038 lw         $a0, 0x38($s1)
0015E588 AFBF0018 sw         $ra, 0x18($sp)
0015E58C 10800004 beqz       $a0, 0x15e5a0
0015E590 00000000 nop        
0015E594 0C01B1A3 jal        0x6c68c
0015E598 00000000 nop        
0015E59C AE200038 sw         $zero, 0x38($s1)
0015E5A0 8E24000C lw         $a0, 0xc($s1)
0015E5A4 10800008 beqz       $a0, 0x15e5c8
0015E5A8 00000000 nop        
0015E5AC 0C057C04 jal        0x15f010
0015E5B0 00000000 nop        
0015E5B4 8E24000C lw         $a0, 0xc($s1)
0015E5B8 8C470000 lw         $a3, ($v0)
0015E5BC 02002825 move       $a1, $s0
0015E5C0 00E0F809 jalr       $a3
0015E5C4 34060002 ori        $a2, $zero, 2
0015E5C8 0C02320E jal        0x8c838
0015E5CC 262400D0 addiu      $a0, $s1, 0xd0
0015E5D0 0C02320E jal        0x8c838
0015E5D4 2624010C addiu      $a0, $s1, 0x10c
0015E5D8 0C02320E jal        0x8c838
0015E5DC 26240058 addiu      $a0, $s1, 0x58
0015E5E0 0C02320E jal        0x8c838
0015E5E4 26240094 addiu      $a0, $s1, 0x94
0015E5E8 A2200181 sb         $zero, 0x181($s1)
0015E5EC 8FB00010 lw         $s0, 0x10($sp)
0015E5F0 8FB10014 lw         $s1, 0x14($sp)
0015E5F4 8FBF0018 lw         $ra, 0x18($sp)
0015E5F8 03E00008 jr         $ra
0015E5FC 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0015F058 end 0x0015F760 ordinal 2

0015F058 27BDFF80 addiu      $sp, $sp, -0x80
0015F05C AFB00064 sw         $s0, 0x64($sp)
0015F060 00808025 move       $s0, $a0
0015F064 AFB10068 sw         $s1, 0x68($sp)
0015F068 8E110058 lw         $s1, 0x58($s0)
0015F06C 3C043D08 lui        $a0, 0x3d08
0015F070 C62C0004 lwc1       $f12, 4($s1)
0015F074 34848889 ori        $a0, $a0, 0x8889
0015F078 44846800 mtc1       $a0, $f13
0015F07C E7B40060 swc1       $f20, 0x60($sp)
0015F080 460D6301 sub.s      $f12, $f12, $f13
0015F084 8E240000 lw         $a0, ($s1)
0015F088 AFB2006C sw         $s2, 0x6c($sp)
0015F08C AFB30070 sw         $s3, 0x70($sp)
0015F090 AFB40074 sw         $s4, 0x74($sp)
0015F094 AFBF0078 sw         $ra, 0x78($sp)
0015F098 0C016FD5 jal        0x5bf54
0015F09C E62C0004 swc1       $f12, 4($s1)
0015F0A0 1040001D beqz       $v0, 0x15f118
0015F0A4 00000000 nop        
0015F0A8 C60D0020 lwc1       $f13, 0x20($s0)
0015F0AC C60E0024 lwc1       $f14, 0x24($s0)
0015F0B0 460D6B02 mul.s      $f12, $f13, $f13
0015F0B4 C60F0028 lwc1       $f15, 0x28($s0)
0015F0B8 460E7402 mul.s      $f16, $f14, $f14
0015F0BC 460F7C42 mul.s      $f17, $f15, $f15
0015F0C0 3C043F80 lui        $a0, 0x3f80
0015F0C4 44849000 mtc1       $a0, $f18
0015F0C8 46106300 add.s      $f12, $f12, $f16
0015F0CC 46116300 add.s      $f12, $f12, $f17
0015F0D0 46006304 sqrt.s     $f12, $f12
0015F0D4 460C9483 div.s      $f18, $f18, $f12
0015F0D8 3C06002D lui        $a2, 0x2d
0015F0DC 27B2003C addiu      $s2, $sp, 0x3c
0015F0E0 27A50030 addiu      $a1, $sp, 0x30
0015F0E4 02402025 move       $a0, $s2
0015F0E8 460D9342 mul.s      $f13, $f18, $f13
0015F0EC C4CC5CC0 lwc1       $f12, 0x5cc0($a2)
0015F0F0 460E9382 mul.s      $f14, $f18, $f14
0015F0F4 460F93C2 mul.s      $f15, $f18, $f15
0015F0F8 E7AD0030 swc1       $f13, 0x30($sp)
0015F0FC E7AE0034 swc1       $f14, 0x34($sp)
0015F100 0C03D224 jal        0xf4890
0015F104 E7AF0038 swc1       $f15, 0x38($sp)
0015F108 02002025 move       $a0, $s0
0015F10C 02002825 move       $a1, $s0
0015F110 0C03E131 jal        0xf84c4
0015F114 02403025 move       $a2, $s2
0015F118 8E250000 lw         $a1, ($s1)
0015F11C 26240164 addiu      $a0, $s1, 0x164
0015F120 8CA505A8 lw         $a1, 0x5a8($a1)
0015F124 C62C017C lwc1       $f12, 0x17c($s1)
0015F128 0C03D27E jal        0xf49f8
0015F12C 24A60020 addiu      $a2, $a1, 0x20
0015F130 C62C0164 lwc1       $f12, 0x164($s1)
0015F134 C62D0168 lwc1       $f13, 0x168($s1)
0015F138 46006307 neg.s      $f12, $f12
0015F13C C62E016C lwc1       $f14, 0x16c($s1)
0015F140 E62C0170 swc1       $f12, 0x170($s1)
0015F144 46006B07 neg.s      $f12, $f13
0015F148 3C043F00 lui        $a0, 0x3f00
0015F14C E62C0174 swc1       $f12, 0x174($s1)
0015F150 44847800 mtc1       $a0, $f15
0015F154 46007307 neg.s      $f12, $f14
0015F158 E62C0178 swc1       $f12, 0x178($s1)
0015F15C C60C0000 lwc1       $f12, ($s0)
0015F160 C6100030 lwc1       $f16, 0x30($s0)
0015F164 460F6302 mul.s      $f12, $f12, $f15
0015F168 460C8300 add.s      $f12, $f16, $f12
0015F16C E62C014C swc1       $f12, 0x14c($s1)
0015F170 C60C0004 lwc1       $f12, 4($s0)
0015F174 C60D0034 lwc1       $f13, 0x34($s0)
0015F178 460F6302 mul.s      $f12, $f12, $f15
0015F17C 460C6B00 add.s      $f12, $f13, $f12
0015F180 E62C0150 swc1       $f12, 0x150($s1)
0015F184 C60C0008 lwc1       $f12, 8($s0)
0015F188 C60E0038 lwc1       $f14, 0x38($s0)
0015F18C 460F6302 mul.s      $f12, $f12, $f15
0015F190 460C7300 add.s      $f12, $f14, $f12
0015F194 E62C0154 swc1       $f12, 0x154($s1)
0015F198 92040045 lbu        $a0, 0x45($s0)
0015F19C 14800051 bnez       $a0, 0x15f2e4
0015F1A0 00000000 nop        
0015F1A4 8E240038 lw         $a0, 0x38($s1)
0015F1A8 10800004 beqz       $a0, 0x15f1bc
0015F1AC 00000000 nop        
0015F1B0 0C01B1A3 jal        0x6c68c
0015F1B4 00000000 nop        
0015F1B8 AE200038 sw         $zero, 0x38($s1)
0015F1BC 92240148 lbu        $a0, 0x148($s1)
0015F1C0 10800013 beqz       $a0, 0x15f210
0015F1C4 00000000 nop        
0015F1C8 8E24000C lw         $a0, 0xc($s1)
0015F1CC 10800008 beqz       $a0, 0x15f1f0
0015F1D0 00000000 nop        
0015F1D4 0C057C04 jal        0x15f010
0015F1D8 00000000 nop        
0015F1DC 8E24000C lw         $a0, 0xc($s1)
0015F1E0 8C470000 lw         $a3, ($v0)
0015F1E4 02002825 move       $a1, $s0
0015F1E8 00E0F809 jalr       $a3
0015F1EC 34060002 ori        $a2, $zero, 2
0015F1F0 A2200181 sb         $zero, 0x181($s1)
0015F1F4 34040001 ori        $a0, $zero, 1
0015F1F8 A2240149 sb         $a0, 0x149($s1)
0015F1FC A2200148 sb         $zero, 0x148($s1)
0015F200 AE20000C sw         $zero, 0xc($s1)
0015F204 3C04002D lui        $a0, 0x2d
0015F208 C48C5C78 lwc1       $f12, 0x5c78($a0)
0015F20C E62C0004 swc1       $f12, 4($s1)
0015F210 8E320000 lw         $s2, ($s1)
0015F214 0C00C4BD jal        0x312f4
0015F218 02402025 move       $a0, $s2
0015F21C 02002025 move       $a0, $s0
0015F220 0C057DD8 jal        0x15f760
0015F224 00402825 move       $a1, $v0
0015F228 8E4500F0 lw         $a1, 0xf0($s2)
0015F22C 0C007DC7 jal        0x1f71c
0015F230 34040012 ori        $a0, $zero, 0x12
0015F234 8E44095C lw         $a0, 0x95c($s2)
0015F238 30840020 andi       $a0, $a0, 0x20
0015F23C 10800027 beqz       $a0, 0x15f2dc
0015F240 00000000 nop        
0015F244 8E4400D4 lw         $a0, 0xd4($s2)
0015F248 30842000 andi       $a0, $a0, 0x2000
0015F24C 10800023 beqz       $a0, 0x15f2dc
0015F250 00000000 nop        
0015F254 C62D0004 lwc1       $f13, 4($s1)
0015F258 44806000 mtc1       $zero, $f12
0015F25C 460C683E c.le.s     $f13, $f12
0015F260 00000000 nop        
0015F264 4500001D bc1f       0x15f2dc
0015F268 00000000 nop        
0015F26C A2000046 sb         $zero, 0x46($s0)
0015F270 E60C0070 swc1       $f12, 0x70($s0)
0015F274 3C04002D lui        $a0, 0x2d
0015F278 C48D5C78 lwc1       $f13, 0x5c78($a0)
0015F27C E62C0008 swc1       $f12, 8($s1)
0015F280 E62D0004 swc1       $f13, 4($s1)
0015F284 34040001 ori        $a0, $zero, 1
0015F288 A2240181 sb         $a0, 0x181($s1)
0015F28C 3404000A ori        $a0, $zero, 0xa
0015F290 A2040045 sb         $a0, 0x45($s0)
0015F294 3C040005 lui        $a0, 5
0015F298 8C846008 lw         $a0, 0x6008($a0)
0015F29C 1080000F beqz       $a0, 0x15f2dc
0015F2A0 00000000 nop        
0015F2A4 1080000D beqz       $a0, 0x15f2dc
0015F2A8 00802825 move       $a1, $a0
0015F2AC C4AC0014 lwc1       $f12, 0x14($a1)
0015F2B0 C4AD0018 lwc1       $f13, 0x18($a1)
0015F2B4 C4AE001C lwc1       $f14, 0x1c($a1)
0015F2B8 26260038 addiu      $a2, $s1, 0x38
0015F2BC C4AF0020 lwc1       $f15, 0x20($a1)
0015F2C0 34070000 ori        $a3, $zero, 0
0015F2C4 34090000 ori        $t1, $zero, 0
0015F2C8 340A0000 ori        $t2, $zero, 0
0015F2CC 340B0001 ori        $t3, $zero, 1
0015F2D0 02002025 move       $a0, $s0
0015F2D4 0C01B147 jal        0x6c51c
0015F2D8 00004025 move       $t0, $zero
0015F2DC 10000117 b          0x15f73c
0015F2E0 00000000 nop        
0015F2E4 3405000A ori        $a1, $zero, 0xa
0015F2E8 14850114 bne        $a0, $a1, 0x15f73c
0015F2EC 00000000 nop        
0015F2F0 92240148 lbu        $a0, 0x148($s1)
0015F2F4 1480000A bnez       $a0, 0x15f320
0015F2F8 00000000 nop        
0015F2FC 0C00C4BD jal        0x312f4
0015F300 8E240000 lw         $a0, ($s1)
0015F304 02002025 move       $a0, $s0
0015F308 0C057DD8 jal        0x15f760
0015F30C 00402825 move       $a1, $v0
0015F310 8E24000C lw         $a0, 0xc($s1)
0015F314 10800002 beqz       $a0, 0x15f320
0015F318 00000000 nop        
0015F31C A2000046 sb         $zero, 0x46($s0)
0015F320 92040046 lbu        $a0, 0x46($s0)
0015F324 14800014 bnez       $a0, 0x15f378
0015F328 00000000 nop        
0015F32C 8E33000C lw         $s3, 0xc($s1)
0015F330 12600010 beqz       $s3, 0x15f374
0015F334 34120001 ori        $s2, $zero, 1
0015F338 0C057C04 jal        0x15f010
0015F33C 02602025 move       $a0, $s3
0015F340 8C450004 lw         $a1, 4($v0)
0015F344 10A00004 beqz       $a1, 0x15f358
0015F348 34040000 ori        $a0, $zero, 0
0015F34C 00A0F809 jalr       $a1
0015F350 02602025 move       $a0, $s3
0015F354 00402025 move       $a0, $v0
0015F358 10800006 beqz       $a0, 0x15f374
0015F35C 00000000 nop        
0015F360 A2320148 sb         $s2, 0x148($s1)
0015F364 A2320180 sb         $s2, 0x180($s1)
0015F368 C48C0014 lwc1       $f12, 0x14($a0)
0015F36C A2320149 sb         $s2, 0x149($s1)
0015F370 E62C0040 swc1       $f12, 0x40($s1)
0015F374 A2120046 sb         $s2, 0x46($s0)
0015F378 92040046 lbu        $a0, 0x46($s0)
0015F37C 34050001 ori        $a1, $zero, 1
0015F380 148500EE bne        $a0, $a1, 0x15f73c
0015F384 00000000 nop        
0015F388 92240148 lbu        $a0, 0x148($s1)
0015F38C 10800026 beqz       $a0, 0x15f428
0015F390 00000000 nop        
0015F394 0C057C04 jal        0x15f010
0015F398 8E24000C lw         $a0, 0xc($s1)
0015F39C 8E250000 lw         $a1, ($s1)
0015F3A0 92260149 lbu        $a2, 0x149($s1)
0015F3A4 8CA500D4 lw         $a1, 0xd4($a1)
0015F3A8 00402025 move       $a0, $v0
0015F3AC 10C00005 beqz       $a2, 0x15f3c4
0015F3B0 30A52000 andi       $a1, $a1, 0x2000
0015F3B4 14A00014 bnez       $a1, 0x15f408
0015F3B8 00000000 nop        
0015F3BC 10000012 b          0x15f408
0015F3C0 A2200149 sb         $zero, 0x149($s1)
0015F3C4 10A00010 beqz       $a1, 0x15f408
0015F3C8 00000000 nop        
0015F3CC A2200181 sb         $zero, 0x181($s1)
0015F3D0 34050001 ori        $a1, $zero, 1
0015F3D4 A2250149 sb         $a1, 0x149($s1)
0015F3D8 A2200148 sb         $zero, 0x148($s1)
0015F3DC A2000045 sb         $zero, 0x45($s0)
0015F3E0 8C870000 lw         $a3, ($a0)
0015F3E4 8E24000C lw         $a0, 0xc($s1)
0015F3E8 02002825 move       $a1, $s0
0015F3EC 00E0F809 jalr       $a3
0015F3F0 34060002 ori        $a2, $zero, 2
0015F3F4 AE20000C sw         $zero, 0xc($s1)
0015F3F8 3C04002D lui        $a0, 0x2d
0015F3FC C48C5C78 lwc1       $f12, 0x5c78($a0)
0015F400 100000CE b          0x15f73c
0015F404 E62C0004 swc1       $f12, 4($s1)
0015F408 8C860004 lw         $a2, 4($a0)
0015F40C 00C0F809 jalr       $a2
0015F410 8E24000C lw         $a0, 0xc($s1)
0015F414 02002025 move       $a0, $s0
0015F418 0C057EDA jal        0x15fb68
0015F41C 00402825 move       $a1, $v0
0015F420 10000009 b          0x15f448
0015F424 00000000 nop        
0015F428 92240149 lbu        $a0, 0x149($s1)
0015F42C 10800006 beqz       $a0, 0x15f448
0015F430 00000000 nop        
0015F434 8E240000 lw         $a0, ($s1)
0015F438 8C8400D4 lw         $a0, 0xd4($a0)
0015F43C 30842000 andi       $a0, $a0, 0x2000
0015F440 10800006 beqz       $a0, 0x15f45c
0015F444 00000000 nop        
0015F448 8E26000C lw         $a2, 0xc($s1)
0015F44C 14C0000A bnez       $a2, 0x15f478
0015F450 00000000 nop        
0015F454 10000025 b          0x15f4ec
0015F458 00000000 nop        
0015F45C A2200181 sb         $zero, 0x181($s1)
0015F460 A2000045 sb         $zero, 0x45($s0)
0015F464 AE20000C sw         $zero, 0xc($s1)
0015F468 3C04002D lui        $a0, 0x2d
0015F46C C48C5C78 lwc1       $f12, 0x5c78($a0)
0015F470 100000B2 b          0x15f73c
0015F474 E62C0004 swc1       $f12, 4($s1)
0015F478 0C057C04 jal        0x15f010
0015F47C 00C02025 move       $a0, $a2
0015F480 8E050058 lw         $a1, 0x58($s0)
0015F484 3C063F80 lui        $a2, 0x3f80
0015F488 C4AC0008 lwc1       $f12, 8($a1)
0015F48C 44866800 mtc1       $a2, $f13
0015F490 00402025 move       $a0, $v0
0015F494 34050000 ori        $a1, $zero, 0
0015F498 460D603C c.lt.s     $f12, $f13
0015F49C 8E26000C lw         $a2, 0xc($s1)
0015F4A0 45020001 bc1fl      0x15f4a8
0015F4A4 34050001 ori        $a1, $zero, 1
0015F4A8 30A500FF andi       $a1, $a1, 0xff
0015F4AC 14A00003 bnez       $a1, 0x15f4bc
0015F4B0 00000000 nop        
0015F4B4 10000002 b          0x15f4c0
0015F4B8 34050000 ori        $a1, $zero, 0
0015F4BC 34050001 ori        $a1, $zero, 1
0015F4C0 8C880000 lw         $t0, ($a0)
0015F4C4 00A03825 move       $a3, $a1
0015F4C8 00C02025 move       $a0, $a2
0015F4CC 02002825 move       $a1, $s0
0015F4D0 0100F809 jalr       $t0
0015F4D4 00E03025 move       $a2, $a3
0015F4D8 10400004 beqz       $v0, 0x15f4ec
0015F4DC 00000000 nop        
0015F4E0 A2200181 sb         $zero, 0x181($s1)
0015F4E4 A2200148 sb         $zero, 0x148($s1)
0015F4E8 A2000045 sb         $zero, 0x45($s0)
0015F4EC 3C04002B lui        $a0, 0x2b
0015F4F0 8C84F28C lw         $a0, -0xd74($a0)
0015F4F4 30840003 andi       $a0, $a0, 3
0015F4F8 14800016 bnez       $a0, 0x15f554
0015F4FC 00000000 nop        
0015F500 0C016FD5 jal        0x5bf54
0015F504 8E240000 lw         $a0, ($s1)
0015F508 14400012 bnez       $v0, 0x15f554
0015F50C 00000000 nop        
0015F510 26120030 addiu      $s2, $s0, 0x30
0015F514 26130020 addiu      $s3, $s0, 0x20
0015F518 26140010 addiu      $s4, $s0, 0x10
0015F51C 02002025 move       $a0, $s0
0015F520 02402825 move       $a1, $s2
0015F524 02603025 move       $a2, $s3
0015F528 02803825 move       $a3, $s4
0015F52C 02004025 move       $t0, $s0
0015F530 0C057980 jal        0x15e600
0015F534 34090001 ori        $t1, $zero, 1
0015F538 02002025 move       $a0, $s0
0015F53C 02402825 move       $a1, $s2
0015F540 02603025 move       $a2, $s3
0015F544 02803825 move       $a3, $s4
0015F548 02004025 move       $t0, $s0
0015F54C 0C057980 jal        0x15e600
0015F550 00004825 move       $t1, $zero
0015F554 8E24000C lw         $a0, 0xc($s1)
0015F558 10800076 beqz       $a0, 0x15f734
0015F55C 3C053C88 lui        $a1, 0x3c88
0015F560 C62C0008 lwc1       $f12, 8($s1)
0015F564 34A58889 ori        $a1, $a1, 0x8889
0015F568 44856800 mtc1       $a1, $f13
0015F56C 26320158 addiu      $s2, $s1, 0x158
0015F570 460D6300 add.s      $f12, $f12, $f13
0015F574 24930030 addiu      $s3, $a0, 0x30
0015F578 0C057C04 jal        0x15f010
0015F57C E62C0008 swc1       $f12, 8($s1)
0015F580 00402025 move       $a0, $v0
0015F584 8C85000C lw         $a1, 0xc($a0)
0015F588 10A00033 beqz       $a1, 0x15f658
0015F58C C66C0000 lwc1       $f12, ($s3)
0015F590 C4AD0000 lwc1       $f13, ($a1)
0015F594 C60E0000 lwc1       $f14, ($s0)
0015F598 460D7382 mul.s      $f14, $f14, $f13
0015F59C 460E6300 add.s      $f12, $f12, $f14
0015F5A0 E64C0000 swc1       $f12, ($s2)
0015F5A4 C60C0004 lwc1       $f12, 4($s0)
0015F5A8 C66F0004 lwc1       $f15, 4($s3)
0015F5AC 460D6302 mul.s      $f12, $f12, $f13
0015F5B0 C6500000 lwc1       $f16, ($s2)
0015F5B4 460C7B00 add.s      $f12, $f15, $f12
0015F5B8 E64C0004 swc1       $f12, 4($s2)
0015F5BC C60C0008 lwc1       $f12, 8($s0)
0015F5C0 C66E0008 lwc1       $f14, 8($s3)
0015F5C4 460D6302 mul.s      $f12, $f12, $f13
0015F5C8 C6510004 lwc1       $f17, 4($s2)
0015F5CC 460C7300 add.s      $f12, $f14, $f12
0015F5D0 E64C0008 swc1       $f12, 8($s2)
0015F5D4 8C85000C lw         $a1, 0xc($a0)
0015F5D8 C60C0010 lwc1       $f12, 0x10($s0)
0015F5DC C4AF0004 lwc1       $f15, 4($a1)
0015F5E0 460F6302 mul.s      $f12, $f12, $f15
0015F5E4 C64D0008 lwc1       $f13, 8($s2)
0015F5E8 460C8300 add.s      $f12, $f16, $f12
0015F5EC E64C0000 swc1       $f12, ($s2)
0015F5F0 C60C0014 lwc1       $f12, 0x14($s0)
0015F5F4 460F6302 mul.s      $f12, $f12, $f15
0015F5F8 C64E0000 lwc1       $f14, ($s2)
0015F5FC 460C8B00 add.s      $f12, $f17, $f12
0015F600 E64C0004 swc1       $f12, 4($s2)
0015F604 C60C0018 lwc1       $f12, 0x18($s0)
0015F608 460F6302 mul.s      $f12, $f12, $f15
0015F60C C6500004 lwc1       $f16, 4($s2)
0015F610 460C6B00 add.s      $f12, $f13, $f12
0015F614 E64C0008 swc1       $f12, 8($s2)
0015F618 8C84000C lw         $a0, 0xc($a0)
0015F61C C60C0020 lwc1       $f12, 0x20($s0)
0015F620 C4910008 lwc1       $f17, 8($a0)
0015F624 46116302 mul.s      $f12, $f12, $f17
0015F628 C64F0008 lwc1       $f15, 8($s2)
0015F62C 460C7300 add.s      $f12, $f14, $f12
0015F630 E64C0000 swc1       $f12, ($s2)
0015F634 C60C0024 lwc1       $f12, 0x24($s0)
0015F638 46116302 mul.s      $f12, $f12, $f17
0015F63C 460C8300 add.s      $f12, $f16, $f12
0015F640 E64C0004 swc1       $f12, 4($s2)
0015F644 C60C0028 lwc1       $f12, 0x28($s0)
0015F648 46116302 mul.s      $f12, $f12, $f17
0015F64C 460C7B00 add.s      $f12, $f15, $f12
0015F650 10000006 b          0x15f66c
0015F654 E64C0008 swc1       $f12, 8($s2)
0015F658 E64C0000 swc1       $f12, ($s2)
0015F65C C66C0004 lwc1       $f12, 4($s3)
0015F660 E64C0004 swc1       $f12, 4($s2)
0015F664 C66C0008 lwc1       $f12, 8($s3)
0015F668 E64C0008 swc1       $f12, 8($s2)
0015F66C 3C04AB00 lui        $a0, 0xab00
0015F670 2492C000 addiu      $s2, $a0, -0x4000
0015F674 3C04AAFF lui        $a0, 0xaaff
0015F678 249300FF addiu      $s3, $a0, 0xff
0015F67C 3C043F80 lui        $a0, 0x3f80
0015F680 0C06B652 jal        0x1ad948
0015F684 4484A000 mtc1       $a0, $f20
0015F688 44826000 mtc1       $v0, $f12
0015F68C 3C043000 lui        $a0, 0x3000
0015F690 46806320 cvt.s.w    $f12, $f12
0015F694 02602825 move       $a1, $s3
0015F698 44846800 mtc1       $a0, $f13
0015F69C 02402025 move       $a0, $s2
0015F6A0 460D6302 mul.s      $f12, $f12, $f13
0015F6A4 0C03C93C jal        0xf24f0
0015F6A8 46146302 mul.s      $f12, $f12, $f20
0015F6AC 00409025 move       $s2, $v0
0015F6B0 26240058 addiu      $a0, $s1, 0x58
0015F6B4 0C038229 jal        0xe08a4
0015F6B8 02402825 move       $a1, $s2
0015F6BC 26240094 addiu      $a0, $s1, 0x94
0015F6C0 0C038229 jal        0xe08a4
0015F6C4 02402825 move       $a1, $s2
0015F6C8 262400D0 addiu      $a0, $s1, 0xd0
0015F6CC 0C038229 jal        0xe08a4
0015F6D0 02402825 move       $a1, $s2
0015F6D4 2624010C addiu      $a0, $s1, 0x10c
0015F6D8 0C038229 jal        0xe08a4
0015F6DC 02402825 move       $a1, $s2
0015F6E0 8E040058 lw         $a0, 0x58($s0)
0015F6E4 34100000 ori        $s0, $zero, 0
0015F6E8 C48C0008 lwc1       $f12, 8($a0)
0015F6EC 4614603C c.lt.s     $f12, $f20
0015F6F0 00000000 nop        
0015F6F4 45020001 bc1fl      0x15f6fc
0015F6F8 34100001 ori        $s0, $zero, 1
0015F6FC 320400FF andi       $a0, $s0, 0xff
0015F700 1080000A beqz       $a0, 0x15f72c
0015F704 00000000 nop        
0015F708 C62C017C lwc1       $f12, 0x17c($s1)
0015F70C 3C04002D lui        $a0, 0x2d
0015F710 C48D5C98 lwc1       $f13, 0x5c98($a0)
0015F714 3C0440C9 lui        $a0, 0x40c9
0015F718 460D6300 add.s      $f12, $f12, $f13
0015F71C 34840FDB ori        $a0, $a0, 0xfdb
0015F720 44846800 mtc1       $a0, $f13
0015F724 0C06975A jal        0x1a5d68
0015F728 E62C017C swc1       $f12, 0x17c($s1)
0015F72C 10000003 b          0x15f73c
0015F730 00000000 nop        
0015F734 44806000 mtc1       $zero, $f12
0015F738 E62C0008 swc1       $f12, 8($s1)
0015F73C C7B40060 lwc1       $f20, 0x60($sp)
0015F740 8FB00064 lw         $s0, 0x64($sp)
0015F744 8FB10068 lw         $s1, 0x68($sp)
0015F748 8FB2006C lw         $s2, 0x6c($sp)
0015F74C 8FB30070 lw         $s3, 0x70($sp)
0015F750 8FB40074 lw         $s4, 0x74($sp)
0015F754 8FBF0078 lw         $ra, 0x78($sp)
0015F758 03E00008 jr         $ra
0015F75C 27BD0080 addiu      $sp, $sp, 0x80