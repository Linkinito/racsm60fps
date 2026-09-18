
CALLBACK 0x0011F178 end 0x0011F1E8 ordinal 0

0011F178 44807000 mtc1       $zero, $f14
0011F17C 8C870058 lw         $a3, 0x58($a0)
0011F180 46007346 mov.s      $f13, $f14
0011F184 3C043F00 lui        $a0, 0x3f00
0011F188 44846000 mtc1       $a0, $f12
0011F18C ACE00000 sw         $zero, ($a3)
0011F190 34060000 ori        $a2, $zero, 0
0011F194 00E02825 move       $a1, $a3
0011F198 3C04002A lui        $a0, 0x2a
0011F19C ACA00004 sw         $zero, 4($a1)
0011F1A0 E4AD000C swc1       $f13, 0xc($a1)
0011F1A4 C48FF0A8 lwc1       $f15, -0xf58($a0)
0011F1A8 24C60001 addiu      $a2, $a2, 1
0011F1AC 460C7C02 mul.s      $f16, $f15, $f12
0011F1B0 24A50004 addiu      $a1, $a1, 4
0011F1B4 2CC80002 sltiu      $t0, $a2, 2
0011F1B8 1500FFF8 bnez       $t0, 0x11f19c
0011F1BC 46106B40 add.s      $f13, $f13, $f16
0011F1C0 ACE00014 sw         $zero, 0x14($a3)
0011F1C4 3C043F80 lui        $a0, 0x3f80
0011F1C8 44846000 mtc1       $a0, $f12
0011F1CC E4EE001C swc1       $f14, 0x1c($a3)
0011F1D0 E4EC0018 swc1       $f12, 0x18($a3)
0011F1D4 2404FFFF addiu      $a0, $zero, -1
0011F1D8 ACE40020 sw         $a0, 0x20($a3)
0011F1DC E4EE0024 swc1       $f14, 0x24($a3)
0011F1E0 03E00008 jr         $ra
0011F1E4 34020001 ori        $v0, $zero, 1

CALLBACK 0x0011F1E8 end 0x0011F22C ordinal 1

0011F1E8 27BDFFE0 addiu      $sp, $sp, -0x20
0011F1EC AFB00010 sw         $s0, 0x10($sp)
0011F1F0 AFB10014 sw         $s1, 0x14($sp)
0011F1F4 AFBF0018 sw         $ra, 0x18($sp)
0011F1F8 8C900058 lw         $s0, 0x58($a0)
0011F1FC 34110000 ori        $s1, $zero, 0
0011F200 0C047ECE jal        0x11fb38
0011F204 8E040004 lw         $a0, 4($s0)
0011F208 26310001 addiu      $s1, $s1, 1
0011F20C 2E240002 sltiu      $a0, $s1, 2
0011F210 1480FFFB bnez       $a0, 0x11f200
0011F214 26100004 addiu      $s0, $s0, 4
0011F218 8FB00010 lw         $s0, 0x10($sp)
0011F21C 8FB10014 lw         $s1, 0x14($sp)
0011F220 8FBF0018 lw         $ra, 0x18($sp)
0011F224 03E00008 jr         $ra
0011F228 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0011F22C end 0x0011F460 ordinal 2

0011F22C 27BDFFA0 addiu      $sp, $sp, -0x60
0011F230 AFB10044 sw         $s1, 0x44($sp)
0011F234 8C910058 lw         $s1, 0x58($a0)
0011F238 C48C0070 lwc1       $f12, 0x70($a0)
0011F23C E7B40034 swc1       $f20, 0x34($sp)
0011F240 4480A000 mtc1       $zero, $f20
0011F244 E7B60038 swc1       $f22, 0x38($sp)
0011F248 4614603E c.le.s     $f12, $f20
0011F24C E7B8003C swc1       $f24, 0x3c($sp)
0011F250 AFB00040 sw         $s0, 0x40($sp)
0011F254 AFB20048 sw         $s2, 0x48($sp)
0011F258 AFB3004C sw         $s3, 0x4c($sp)
0011F25C AFB40050 sw         $s4, 0x50($sp)
0011F260 AFB50054 sw         $s5, 0x54($sp)
0011F264 AFBF0058 sw         $ra, 0x58($sp)
0011F268 45010008 bc1t       0x11f28c
0011F26C 00808025 move       $s0, $a0
0011F270 3C043F80 lui        $a0, 0x3f80
0011F274 44846800 mtc1       $a0, $f13
0011F278 460D6301 sub.s      $f12, $f12, $f13
0011F27C 4614603E c.le.s     $f12, $f20
0011F280 00000000 nop        
0011F284 45010006 bc1t       0x11f2a0
0011F288 E60C0070 swc1       $f12, 0x70($s0)
0011F28C 8E240014 lw         $a0, 0x14($s1)
0011F290 14800008 bnez       $a0, 0x11f2b4
0011F294 00000000 nop        
0011F298 10000019 b          0x11f300
0011F29C 00000000 nop        
0011F2A0 02002025 move       $a0, $s0
0011F2A4 0C0192FF jal        0x64bfc
0011F2A8 34050001 ori        $a1, $zero, 1
0011F2AC 10000060 b          0x11f430
0011F2B0 00000000 nop        
0011F2B4 8C850064 lw         $a1, 0x64($a0)
0011F2B8 30A50006 andi       $a1, $a1, 6
0011F2BC 10A00006 beqz       $a1, 0x11f2d8
0011F2C0 00000000 nop        
0011F2C4 02002025 move       $a0, $s0
0011F2C8 0C0192FF jal        0x64bfc
0011F2CC 34050001 ori        $a1, $zero, 1
0011F2D0 10000057 b          0x11f430
0011F2D4 00000000 nop        
0011F2D8 27A50020 addiu      $a1, $sp, 0x20
0011F2DC 00003025 move       $a2, $zero
0011F2E0 0C019ACE jal        0x66b38
0011F2E4 00003825 move       $a3, $zero
0011F2E8 C7AC0020 lwc1       $f12, 0x20($sp)
0011F2EC C7AD0024 lwc1       $f13, 0x24($sp)
0011F2F0 E60C0030 swc1       $f12, 0x30($s0)
0011F2F4 C7AC0028 lwc1       $f12, 0x28($sp)
0011F2F8 E60D0034 swc1       $f13, 0x34($s0)
0011F2FC E60C0038 swc1       $f12, 0x38($s0)
0011F300 C62C0024 lwc1       $f12, 0x24($s1)
0011F304 46146032 c.eq.s     $f12, $f20
0011F308 00000000 nop        
0011F30C 45010025 bc1t       0x11f3a4
0011F310 26120030 addiu      $s2, $s0, 0x30
0011F314 34070129 ori        $a3, $zero, 0x129
0011F318 34080101 ori        $t0, $zero, 0x101
0011F31C 27A4002C addiu      $a0, $sp, 0x2c
0011F320 34050002 ori        $a1, $zero, 2
0011F324 02403025 move       $a2, $s2
0011F328 34090002 ori        $t1, $zero, 2
0011F32C 0C00555F jal        0x1557c
0011F330 340A0001 ori        $t2, $zero, 1
0011F334 00409825 move       $s3, $v0
0011F338 34140000 ori        $s4, $zero, 0
0011F33C 0293202B sltu       $a0, $s4, $s3
0011F340 10800018 beqz       $a0, 0x11f3a4
0011F344 03A0A825 move       $s5, $sp
0011F348 8EA4002C lw         $a0, 0x2c($s5)
0011F34C 8C850040 lw         $a1, 0x40($a0)
0011F350 8CA50020 lw         $a1, 0x20($a1)
0011F354 10A0000F beqz       $a1, 0x11f394
0011F358 00000000 nop        
0011F35C 0C003F03 jal        0xfc0c
0011F360 00000000 nop        
0011F364 10400008 beqz       $v0, 0x11f388
0011F368 00000000 nop        
0011F36C 8EA4002C lw         $a0, 0x2c($s5)
0011F370 02002825 move       $a1, $s0
0011F374 8C840058 lw         $a0, 0x58($a0)
0011F378 0C00AAF0 jal        0x2abc0
0011F37C 8C840000 lw         $a0, ($a0)
0011F380 10400004 beqz       $v0, 0x11f394
0011F384 00000000 nop        
0011F388 8EA5002C lw         $a1, 0x2c($s5)
0011F38C 0C047F0D jal        0x11fc34
0011F390 02002025 move       $a0, $s0
0011F394 26940001 addiu      $s4, $s4, 1
0011F398 0293202B sltu       $a0, $s4, $s3
0011F39C 1480FFEA bnez       $a0, 0x11f348
0011F3A0 26B50004 addiu      $s5, $s5, 4
0011F3A4 3C043F80 lui        $a0, 0x3f80
0011F3A8 4484B000 mtc1       $a0, $f22
0011F3AC 34100000 ori        $s0, $zero, 0
0011F3B0 3C043000 lui        $a0, 0x3000
0011F3B4 02209825 move       $s3, $s1
0011F3B8 4484C000 mtc1       $a0, $f24
0011F3BC 3C14002A lui        $s4, 0x2a
0011F3C0 0C047EF9 jal        0x11fbe4
0011F3C4 8E640004 lw         $a0, 4($s3)
0011F3C8 14400012 bnez       $v0, 0x11f414
0011F3CC 00000000 nop        
0011F3D0 C66C000C lwc1       $f12, 0xc($s3)
0011F3D4 46166301 sub.s      $f12, $f12, $f22
0011F3D8 4614603E c.le.s     $f12, $f20
0011F3DC 00000000 nop        
0011F3E0 4500000C bc1f       0x11f414
0011F3E4 E66C000C swc1       $f12, 0xc($s3)
0011F3E8 C62C0018 lwc1       $f12, 0x18($s1)
0011F3EC 0C047DE2 jal        0x11f788
0011F3F0 02402025 move       $a0, $s2
0011F3F4 0C060057 jal        0x18015c
0011F3F8 AE620004 sw         $v0, 4($s3)
0011F3FC 44826000 mtc1       $v0, $f12
0011F400 C68DF0A8 lwc1       $f13, -0xf58($s4)
0011F404 46806320 cvt.s.w    $f12, $f12
0011F408 460D6302 mul.s      $f12, $f12, $f13
0011F40C 46186302 mul.s      $f12, $f12, $f24
0011F410 E66C000C swc1       $f12, 0xc($s3)
0011F414 8E640004 lw         $a0, 4($s3)
0011F418 0C047D9B jal        0x11f66c
0011F41C 02402825 move       $a1, $s2
0011F420 26100001 addiu      $s0, $s0, 1
0011F424 2E040002 sltiu      $a0, $s0, 2
0011F428 1480FFE5 bnez       $a0, 0x11f3c0
0011F42C 26730004 addiu      $s3, $s3, 4
0011F430 C7B40034 lwc1       $f20, 0x34($sp)
0011F434 C7B60038 lwc1       $f22, 0x38($sp)
0011F438 C7B8003C lwc1       $f24, 0x3c($sp)
0011F43C 8FB00040 lw         $s0, 0x40($sp)
0011F440 8FB10044 lw         $s1, 0x44($sp)
0011F444 8FB20048 lw         $s2, 0x48($sp)
0011F448 8FB3004C lw         $s3, 0x4c($sp)
0011F44C 8FB40050 lw         $s4, 0x50($sp)
0011F450 8FB50054 lw         $s5, 0x54($sp)
0011F454 8FBF0058 lw         $ra, 0x58($sp)
0011F458 03E00008 jr         $ra
0011F45C 27BD0060 addiu      $sp, $sp, 0x60