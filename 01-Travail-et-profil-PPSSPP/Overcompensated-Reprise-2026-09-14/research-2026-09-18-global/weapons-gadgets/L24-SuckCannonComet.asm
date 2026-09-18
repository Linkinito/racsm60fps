
CALLBACK 0x0016DF9C end 0x0016DFA4 ordinal 0

0016DF9C 03E00008 jr         $ra
0016DFA0 34020001 ori        $v0, $zero, 1

CALLBACK 0x0016DFA4 end 0x0016DFAC ordinal 1

0016DFA4 03E00008 jr         $ra
0016DFA8 00000000 nop        

CALLBACK 0x0016E1D8 end 0x0016ED24 ordinal 2

0016E1D8 27BDFEF0 addiu      $sp, $sp, -0x110
0016E1DC AFB70104 sw         $s7, 0x104($sp)
0016E1E0 8C970058 lw         $s7, 0x58($a0)
0016E1E4 AFBE0108 sw         $fp, 0x108($sp)
0016E1E8 92E50041 lbu        $a1, 0x41($s7)
0016E1EC 0080F025 move       $fp, $a0
0016E1F0 24A40001 addiu      $a0, $a1, 1
0016E1F4 308500FF andi       $a1, $a0, 0xff
0016E1F8 A2E40041 sb         $a0, 0x41($s7)
0016E1FC 28A40002 slti       $a0, $a1, 2
0016E200 E7B400D8 swc1       $f20, 0xd8($sp)
0016E204 E7B600DC swc1       $f22, 0xdc($sp)
0016E208 E7B800E0 swc1       $f24, 0xe0($sp)
0016E20C E7BA00E4 swc1       $f26, 0xe4($sp)
0016E210 AFB000E8 sw         $s0, 0xe8($sp)
0016E214 AFB100EC sw         $s1, 0xec($sp)
0016E218 AFB200F0 sw         $s2, 0xf0($sp)
0016E21C AFB300F4 sw         $s3, 0xf4($sp)
0016E220 AFB400F8 sw         $s4, 0xf8($sp)
0016E224 AFB500FC sw         $s5, 0xfc($sp)
0016E228 AFB60100 sw         $s6, 0x100($sp)
0016E22C AFBF010C sw         $ra, 0x10c($sp)
0016E230 1480000D bnez       $a0, 0x16e268
0016E234 00000000 nop        
0016E238 C7CC0070 lwc1       $f12, 0x70($fp)
0016E23C 3C043F80 lui        $a0, 0x3f80
0016E240 4484A000 mtc1       $a0, $f20
0016E244 46146300 add.s      $f12, $f12, $f20
0016E248 3C04002A lui        $a0, 0x2a
0016E24C C48D5D24 lwc1       $f13, 0x5d24($a0)
0016E250 460D603E c.le.s     $f12, $f13
0016E254 00000000 nop        
0016E258 45000005 bc1f       0x16e270
0016E25C E7CC0070 swc1       $f12, 0x70($fp)
0016E260 10000038 b          0x16e344
0016E264 00000000 nop        
0016E268 1000029E b          0x16ece4
0016E26C 00000000 nop        
0016E270 8EE4003C lw         $a0, 0x3c($s7)
0016E274 2C840003 sltiu      $a0, $a0, 3
0016E278 14800018 bnez       $a0, 0x16e2dc
0016E27C 27D70030 addiu      $s7, $fp, 0x30
0016E280 34040006 ori        $a0, $zero, 6
0016E284 0C0327CD jal        0xc9f34
0016E288 02E02825 move       $a1, $s7
0016E28C 0C007265 jal        0x1c994
0016E290 34040005 ori        $a0, $zero, 5
0016E294 0040B825 move       $s7, $v0
0016E298 12E00025 beqz       $s7, 0x16e330
0016E29C 00000000 nop        
0016E2A0 C6EC0014 lwc1       $f12, 0x14($s7)
0016E2A4 C6ED0018 lwc1       $f13, 0x18($s7)
0016E2A8 C6EE001C lwc1       $f14, 0x1c($s7)
0016E2AC C6EF0020 lwc1       $f15, 0x20($s7)
0016E2B0 34070000 ori        $a3, $zero, 0
0016E2B4 34090000 ori        $t1, $zero, 0
0016E2B8 340A0000 ori        $t2, $zero, 0
0016E2BC 340B0001 ori        $t3, $zero, 1
0016E2C0 03C02025 move       $a0, $fp
0016E2C4 02E02825 move       $a1, $s7
0016E2C8 00003025 move       $a2, $zero
0016E2CC 0C019B4F jal        0x66d3c
0016E2D0 00004025 move       $t0, $zero
0016E2D4 10000016 b          0x16e330
0016E2D8 00000000 nop        
0016E2DC 34040007 ori        $a0, $zero, 7
0016E2E0 0C0327CD jal        0xc9f34
0016E2E4 02E02825 move       $a1, $s7
0016E2E8 0C007265 jal        0x1c994
0016E2EC 34040003 ori        $a0, $zero, 3
0016E2F0 0040B825 move       $s7, $v0
0016E2F4 12E0000E beqz       $s7, 0x16e330
0016E2F8 00000000 nop        
0016E2FC C6EC0014 lwc1       $f12, 0x14($s7)
0016E300 C6ED0018 lwc1       $f13, 0x18($s7)
0016E304 C6EE001C lwc1       $f14, 0x1c($s7)
0016E308 C6EF0020 lwc1       $f15, 0x20($s7)
0016E30C 34070000 ori        $a3, $zero, 0
0016E310 34090000 ori        $t1, $zero, 0
0016E314 340A0000 ori        $t2, $zero, 0
0016E318 340B0001 ori        $t3, $zero, 1
0016E31C 03C02025 move       $a0, $fp
0016E320 02E02825 move       $a1, $s7
0016E324 00003025 move       $a2, $zero
0016E328 0C019B4F jal        0x66d3c
0016E32C 00004025 move       $t0, $zero
0016E330 03C02025 move       $a0, $fp
0016E334 0C0192FF jal        0x64bfc
0016E338 34050001 ori        $a1, $zero, 1
0016E33C 10000269 b          0x16ece4
0016E340 00000000 nop        
0016E344 34040028 ori        $a0, $zero, 0x28
0016E348 AFA400D4 sw         $a0, 0xd4($sp)
0016E34C 34060000 ori        $a2, $zero, 0
0016E350 8FC50040 lw         $a1, 0x40($fp)
0016E354 AFA600D0 sw         $a2, 0xd0($sp)
0016E358 3C04002A lui        $a0, 0x2a
0016E35C C4965D3C lwc1       $f22, 0x5d3c($a0)
0016E360 90A40048 lbu        $a0, 0x48($a1)
0016E364 1080000F beqz       $a0, 0x16e3a4
0016E368 3C06002A lui        $a2, 0x2a
0016E36C 93C70044 lbu        $a3, 0x44($fp)
0016E370 44806800 mtc1       $zero, $f13
0016E374 8CA50004 lw         $a1, 4($a1)
0016E378 00074100 sll        $t0, $a3, 4
0016E37C 00E83821 addu       $a3, $a3, $t0
0016E380 00073880 sll        $a3, $a3, 2
0016E384 00E83823 subu       $a3, $a3, $t0
0016E388 00A72821 addu       $a1, $a1, $a3
0016E38C C4AC0028 lwc1       $f12, 0x28($a1)
0016E390 460D6032 c.eq.s     $f12, $f13
0016E394 00000000 nop        
0016E398 45010002 bc1t       0x16e3a4
0016E39C 00000000 nop        
0016E3A0 46006586 mov.s      $f22, $f12
0016E3A4 10800012 beqz       $a0, 0x16e3f0
0016E3A8 00000000 nop        
0016E3AC C6EC0008 lwc1       $f12, 8($s7)
0016E3B0 C7CD0010 lwc1       $f13, 0x10($fp)
0016E3B4 460CB302 mul.s      $f12, $f22, $f12
0016E3B8 C7CE0030 lwc1       $f14, 0x30($fp)
0016E3BC C7CF0014 lwc1       $f15, 0x14($fp)
0016E3C0 C7D00034 lwc1       $f16, 0x34($fp)
0016E3C4 C7D10018 lwc1       $f17, 0x18($fp)
0016E3C8 460C6B42 mul.s      $f13, $f13, $f12
0016E3CC C7D20038 lwc1       $f18, 0x38($fp)
0016E3D0 460C7BC2 mul.s      $f15, $f15, $f12
0016E3D4 460D7340 add.s      $f13, $f14, $f13
0016E3D8 460C8B02 mul.s      $f12, $f17, $f12
0016E3DC 460F83C0 add.s      $f15, $f16, $f15
0016E3E0 E7CD0030 swc1       $f13, 0x30($fp)
0016E3E4 460C9300 add.s      $f12, $f18, $f12
0016E3E8 E7CF0034 swc1       $f15, 0x34($fp)
0016E3EC E7CC0038 swc1       $f12, 0x38($fp)
0016E3F0 92E40040 lbu        $a0, 0x40($s7)
0016E3F4 10800004 beqz       $a0, 0x16e408
0016E3F8 C6F8001C lwc1       $f24, 0x1c($s7)
0016E3FC 2484FFFF addiu      $a0, $a0, -1
0016E400 A2E40040 sb         $a0, 0x40($s7)
0016E404 92E40040 lbu        $a0, 0x40($s7)
0016E408 C4CC5D30 lwc1       $f12, 0x5d30($a2)
0016E40C 460CC303 div.s      $f12, $f24, $f12
0016E410 46146300 add.s      $f12, $f12, $f20
0016E414 4600630D trunc.w.s  $f12, $f12
0016E418 14800158 bnez       $a0, 0x16e97c
0016E41C 44166000 mfc1       $s6, $f12
0016E420 34100000 ori        $s0, $zero, 0
0016E424 0216202A slt        $a0, $s0, $s6
0016E428 1080014D beqz       $a0, 0x16e960
0016E42C 00000000 nop        
0016E430 4496C000 mtc1       $s6, $f24
0016E434 27B40048 addiu      $s4, $sp, 0x48
0016E438 4680C620 cvt.s.w    $f24, $f24
0016E43C 27B3004C addiu      $s3, $sp, 0x4c
0016E440 27B20030 addiu      $s2, $sp, 0x30
0016E444 27B10058 addiu      $s1, $sp, 0x58
0016E448 34150002 ori        $s5, $zero, 2
0016E44C 26100001 addiu      $s0, $s0, 1
0016E450 44906000 mtc1       $s0, $f12
0016E454 C6ED001C lwc1       $f13, 0x1c($s7)
0016E458 46806320 cvt.s.w    $f12, $f12
0016E45C C6EF0010 lwc1       $f15, 0x10($s7)
0016E460 460D6302 mul.s      $f12, $f12, $f13
0016E464 46186383 div.s      $f14, $f12, $f24
0016E468 C7D00030 lwc1       $f16, 0x30($fp)
0016E46C C7D10034 lwc1       $f17, 0x34($fp)
0016E470 C7D20038 lwc1       $f18, 0x38($fp)
0016E474 3C08002A lui        $t0, 0x2a
0016E478 02802025 move       $a0, $s4
0016E47C 02602825 move       $a1, $s3
0016E480 02403025 move       $a2, $s2
0016E484 02203825 move       $a3, $s1
0016E488 460E7B42 mul.s      $f13, $f15, $f14
0016E48C C50C5D30 lwc1       $f12, 0x5d30($t0)
0016E490 8FA800D4 lw         $t0, 0xd4($sp)
0016E494 8FA900D0 lw         $t1, 0xd0($sp)
0016E498 460D8340 add.s      $f13, $f16, $f13
0016E49C E7AD0058 swc1       $f13, 0x58($sp)
0016E4A0 C6ED0014 lwc1       $f13, 0x14($s7)
0016E4A4 460E6B42 mul.s      $f13, $f13, $f14
0016E4A8 460D8B40 add.s      $f13, $f17, $f13
0016E4AC E7AD005C swc1       $f13, 0x5c($sp)
0016E4B0 C6ED0018 lwc1       $f13, 0x18($s7)
0016E4B4 460E6B42 mul.s      $f13, $f13, $f14
0016E4B8 460D9340 add.s      $f13, $f18, $f13
0016E4BC 0C00682F jal        0x1a0bc
0016E4C0 E7AD0060 swc1       $f13, 0x60($sp)
0016E4C4 10400123 beqz       $v0, 0x16e954
0016E4C8 00000000 nop        
0016E4CC 8FA40044 lw         $a0, 0x44($sp)
0016E4D0 1495000B bne        $a0, $s5, 0x16e500
0016E4D4 00000000 nop        
0016E4D8 8EE60000 lw         $a2, ($s7)
0016E4DC 8FA50040 lw         $a1, 0x40($sp)
0016E4E0 8CC60594 lw         $a2, 0x594($a2)
0016E4E4 10A60004 beq        $a1, $a2, 0x16e4f8
0016E4E8 00000000 nop        
0016E4EC 8EE60004 lw         $a2, 4($s7)
0016E4F0 14A60003 bne        $a1, $a2, 0x16e500
0016E4F4 00000000 nop        
0016E4F8 10000116 b          0x16e954
0016E4FC 00000000 nop        
0016E500 149500C1 bne        $a0, $s5, 0x16e808
0016E504 00000000 nop        
0016E508 8FA40040 lw         $a0, 0x40($sp)
0016E50C 8C850040 lw         $a1, 0x40($a0)
0016E510 8CA50020 lw         $a1, 0x20($a1)
0016E514 10A000BC beqz       $a1, 0x16e808
0016E518 00000000 nop        
0016E51C 27B000A4 addiu      $s0, $sp, 0xa4
0016E520 02002825 move       $a1, $s0
0016E524 00003025 move       $a2, $zero
0016E528 0C019ACE jal        0x66b38
0016E52C 00003825 move       $a3, $zero
0016E530 8EE4003C lw         $a0, 0x3c($s7)
0016E534 2C850003 sltiu      $a1, $a0, 3
0016E538 54A00057 bnel       $a1, $zero, 0x16e698
0016E53C C6EC0010 lwc1       $f12, 0x10($s7)
0016E540 92E50043 lbu        $a1, 0x43($s7)
0016E544 54A00054 bnel       $a1, $zero, 0x16e698
0016E548 C6EC0010 lwc1       $f12, 0x10($s7)
0016E54C 248500C6 addiu      $a1, $a0, 0xc6
0016E550 27D10030 addiu      $s1, $fp, 0x30
0016E554 8EE70000 lw         $a3, ($s7)
0016E558 3C02002A lui        $v0, 0x2a
0016E55C 02202025 move       $a0, $s1
0016E560 03C03025 move       $a2, $fp
0016E564 3408000C ori        $t0, $zero, 0xc
0016E568 34090129 ori        $t1, $zero, 0x129
0016E56C 340A0101 ori        $t2, $zero, 0x101
0016E570 340B0036 ori        $t3, $zero, 0x36
0016E574 0C03DC6A jal        0xf71a8
0016E578 C44C5D34 lwc1       $f12, 0x5d34($v0)
0016E57C C6EC0010 lwc1       $f12, 0x10($s7)
0016E580 E7AC00B0 swc1       $f12, 0xb0($sp)
0016E584 C6EC0014 lwc1       $f12, 0x14($s7)
0016E588 E7AC00B4 swc1       $f12, 0xb4($sp)
0016E58C C6EC0018 lwc1       $f12, 0x18($s7)
0016E590 E7B400BC swc1       $f20, 0xbc($sp)
0016E594 E7AC00B8 swc1       $f12, 0xb8($sp)
0016E598 8FA80040 lw         $t0, 0x40($sp)
0016E59C 8EE4003C lw         $a0, 0x3c($s7)
0016E5A0 8D050040 lw         $a1, 0x40($t0)
0016E5A4 8CA50020 lw         $a1, 0x20($a1)
0016E5A8 14A00004 bnez       $a1, 0x16e5bc
0016E5AC 248400B6 addiu      $a0, $a0, 0xb6
0016E5B0 2405FFFF addiu      $a1, $zero, -1
0016E5B4 1000001C b          0x16e628
0016E5B8 8EE40000 lw         $a0, ($s7)
0016E5BC 3C06002A lui        $a2, 0x2a
0016E5C0 00042100 sll        $a0, $a0, 4
0016E5C4 24C6A864 addiu      $a2, $a2, -0x579c
0016E5C8 00863821 addu       $a3, $a0, $a2
0016E5CC 8CE40000 lw         $a0, ($a3)
0016E5D0 8CE60008 lw         $a2, 8($a3)
0016E5D4 C4EC0004 lwc1       $f12, 4($a3)
0016E5D8 28890002 slti       $t1, $a0, 2
0016E5DC 15200007 bnez       $t1, 0x16e5fc
0016E5E0 8CE7000C lw         $a3, 0xc($a3)
0016E5E4 28840003 slti       $a0, $a0, 3
0016E5E8 10800004 beqz       $a0, 0x16e5fc
0016E5EC 3C043F00 lui        $a0, 0x3f00
0016E5F0 44846800 mtc1       $a0, $f13
0016E5F4 10000001 b          0x16e5fc
0016E5F8 460D6302 mul.s      $f12, $f12, $f13
0016E5FC 00A05025 move       $t2, $a1
0016E600 00C02825 move       $a1, $a2
0016E604 01002025 move       $a0, $t0
0016E608 00E03025 move       $a2, $a3
0016E60C 27A800B0 addiu      $t0, $sp, 0xb0
0016E610 02203825 move       $a3, $s1
0016E614 0140F809 jalr       $t2
0016E618 03C04825 move       $t1, $fp
0016E61C 8FA80040 lw         $t0, 0x40($sp)
0016E620 00402825 move       $a1, $v0
0016E624 8EE40000 lw         $a0, ($s7)
0016E628 00A03825 move       $a3, $a1
0016E62C 3405000C ori        $a1, $zero, 0xc
0016E630 0C003EC2 jal        0xfb08
0016E634 01003025 move       $a2, $t0
0016E638 34040006 ori        $a0, $zero, 6
0016E63C 0C0327CD jal        0xc9f34
0016E640 02002825 move       $a1, $s0
0016E644 0C007265 jal        0x1c994
0016E648 34040005 ori        $a0, $zero, 5
0016E64C 00408025 move       $s0, $v0
0016E650 1200000E beqz       $s0, 0x16e68c
0016E654 00000000 nop        
0016E658 C60C0014 lwc1       $f12, 0x14($s0)
0016E65C C60D0018 lwc1       $f13, 0x18($s0)
0016E660 C60E001C lwc1       $f14, 0x1c($s0)
0016E664 C60F0020 lwc1       $f15, 0x20($s0)
0016E668 34070000 ori        $a3, $zero, 0
0016E66C 34090000 ori        $t1, $zero, 0
0016E670 340A0000 ori        $t2, $zero, 0
0016E674 340B0001 ori        $t3, $zero, 1
0016E678 03C02025 move       $a0, $fp
0016E67C 02002825 move       $a1, $s0
0016E680 00003025 move       $a2, $zero
0016E684 0C019B4F jal        0x66d3c
0016E688 00004025 move       $t0, $zero
0016E68C 8EE4003C lw         $a0, 0x3c($s7)
0016E690 1000004E b          0x16e7cc
0016E694 2C840001 sltiu      $a0, $a0, 1
0016E698 E7AC00C0 swc1       $f12, 0xc0($sp)
0016E69C C6EC0014 lwc1       $f12, 0x14($s7)
0016E6A0 E7AC00C4 swc1       $f12, 0xc4($sp)
0016E6A4 C6EC0018 lwc1       $f12, 0x18($s7)
0016E6A8 E7B400CC swc1       $f20, 0xcc($sp)
0016E6AC E7AC00C8 swc1       $f12, 0xc8($sp)
0016E6B0 92E50043 lbu        $a1, 0x43($s7)
0016E6B4 8EE7003C lw         $a3, 0x3c($s7)
0016E6B8 18A00003 blez       $a1, 0x16e6c8
0016E6BC 8FA40040 lw         $a0, 0x40($sp)
0016E6C0 10000002 b          0x16e6cc
0016E6C4 24E700BE addiu      $a3, $a3, 0xbe
0016E6C8 24E700B6 addiu      $a3, $a3, 0xb6
0016E6CC 00802825 move       $a1, $a0
0016E6D0 8CA60040 lw         $a2, 0x40($a1)
0016E6D4 8CC60020 lw         $a2, 0x20($a2)
0016E6D8 54C00004 bnel       $a2, $zero, 0x16e6ec
0016E6DC 00072100 sll        $a0, $a3, 4
0016E6E0 2406FFFF addiu      $a2, $zero, -1
0016E6E4 1000001E b          0x16e760
0016E6E8 8EE50000 lw         $a1, ($s7)
0016E6EC 3C07002A lui        $a3, 0x2a
0016E6F0 24E7A864 addiu      $a3, $a3, -0x579c
0016E6F4 00873821 addu       $a3, $a0, $a3
0016E6F8 8CE90000 lw         $t1, ($a3)
0016E6FC 8CE40008 lw         $a0, 8($a3)
0016E700 C4EC0004 lwc1       $f12, 4($a3)
0016E704 292A0002 slti       $t2, $t1, 2
0016E708 27C80030 addiu      $t0, $fp, 0x30
0016E70C 15400007 bnez       $t2, 0x16e72c
0016E710 8CE7000C lw         $a3, 0xc($a3)
0016E714 29290003 slti       $t1, $t1, 3
0016E718 11200004 beqz       $t1, 0x16e72c
0016E71C 3C093F00 lui        $t1, 0x3f00
0016E720 44896800 mtc1       $t1, $f13
0016E724 10000001 b          0x16e72c
0016E728 460D6302 mul.s      $f12, $f12, $f13
0016E72C 00C05025 move       $t2, $a2
0016E730 00803025 move       $a2, $a0
0016E734 00A02025 move       $a0, $a1
0016E738 00C02825 move       $a1, $a2
0016E73C 00E03025 move       $a2, $a3
0016E740 27A900C0 addiu      $t1, $sp, 0xc0
0016E744 01003825 move       $a3, $t0
0016E748 01204025 move       $t0, $t1
0016E74C 0140F809 jalr       $t2
0016E750 03C04825 move       $t1, $fp
0016E754 8FA40040 lw         $a0, 0x40($sp)
0016E758 00403025 move       $a2, $v0
0016E75C 8EE50000 lw         $a1, ($s7)
0016E760 00C03825 move       $a3, $a2
0016E764 00803025 move       $a2, $a0
0016E768 00A02025 move       $a0, $a1
0016E76C 0C003EC2 jal        0xfb08
0016E770 3405000C ori        $a1, $zero, 0xc
0016E774 34040007 ori        $a0, $zero, 7
0016E778 0C0327CD jal        0xc9f34
0016E77C 02002825 move       $a1, $s0
0016E780 0C007265 jal        0x1c994
0016E784 34040003 ori        $a0, $zero, 3
0016E788 00402025 move       $a0, $v0
0016E78C 1080000D beqz       $a0, 0x16e7c4
0016E790 00802825 move       $a1, $a0
0016E794 C4AC0014 lwc1       $f12, 0x14($a1)
0016E798 C4AD0018 lwc1       $f13, 0x18($a1)
0016E79C C4AE001C lwc1       $f14, 0x1c($a1)
0016E7A0 C4AF0020 lwc1       $f15, 0x20($a1)
0016E7A4 34070000 ori        $a3, $zero, 0
0016E7A8 34090000 ori        $t1, $zero, 0
0016E7AC 340A0000 ori        $t2, $zero, 0
0016E7B0 340B0001 ori        $t3, $zero, 1
0016E7B4 03C02025 move       $a0, $fp
0016E7B8 00003025 move       $a2, $zero
0016E7BC 0C019B4F jal        0x66d3c
0016E7C0 00004025 move       $t0, $zero
0016E7C4 8EE4003C lw         $a0, 0x3c($s7)
0016E7C8 2C840001 sltiu      $a0, $a0, 1
0016E7CC 1480000C bnez       $a0, 0x16e800
0016E7D0 00000000 nop        
0016E7D4 0C017655 jal        0x5d954
0016E7D8 8FA40040 lw         $a0, 0x40($sp)
0016E7DC 10400008 beqz       $v0, 0x16e800
0016E7E0 00000000 nop        
0016E7E4 8EE5003C lw         $a1, 0x3c($s7)
0016E7E8 44806000 mtc1       $zero, $f12
0016E7EC 8FA40040 lw         $a0, 0x40($sp)
0016E7F0 24A500CF addiu      $a1, $a1, 0xcf
0016E7F4 00003025 move       $a2, $zero
0016E7F8 0C0176E2 jal        0x5db88
0016E7FC 00003825 move       $a3, $zero
0016E800 1000003E b          0x16e8fc
0016E804 00000000 nop        
0016E808 8EE4003C lw         $a0, 0x3c($s7)
0016E80C 2C850003 sltiu      $a1, $a0, 3
0016E810 14A00025 bnez       $a1, 0x16e8a8
0016E814 27D00030 addiu      $s0, $fp, 0x30
0016E818 92E50043 lbu        $a1, 0x43($s7)
0016E81C 14A00022 bnez       $a1, 0x16e8a8
0016E820 00000000 nop        
0016E824 8EE70000 lw         $a3, ($s7)
0016E828 3C0B002A lui        $t3, 0x2a
0016E82C 248500C6 addiu      $a1, $a0, 0xc6
0016E830 C56C5D34 lwc1       $f12, 0x5d34($t3)
0016E834 02002025 move       $a0, $s0
0016E838 03C03025 move       $a2, $fp
0016E83C 3408000C ori        $t0, $zero, 0xc
0016E840 34090129 ori        $t1, $zero, 0x129
0016E844 340A0101 ori        $t2, $zero, 0x101
0016E848 0C03DC6A jal        0xf71a8
0016E84C 340B0036 ori        $t3, $zero, 0x36
0016E850 34040006 ori        $a0, $zero, 6
0016E854 0C0327CD jal        0xc9f34
0016E858 02002825 move       $a1, $s0
0016E85C 0C007265 jal        0x1c994
0016E860 34040005 ori        $a0, $zero, 5
0016E864 00402025 move       $a0, $v0
0016E868 1080000D beqz       $a0, 0x16e8a0
0016E86C 00802825 move       $a1, $a0
0016E870 C4AC0014 lwc1       $f12, 0x14($a1)
0016E874 C4AD0018 lwc1       $f13, 0x18($a1)
0016E878 C4AE001C lwc1       $f14, 0x1c($a1)
0016E87C C4AF0020 lwc1       $f15, 0x20($a1)
0016E880 34070000 ori        $a3, $zero, 0
0016E884 34090000 ori        $t1, $zero, 0
0016E888 340A0000 ori        $t2, $zero, 0
0016E88C 340B0001 ori        $t3, $zero, 1
0016E890 03C02025 move       $a0, $fp
0016E894 00003025 move       $a2, $zero
0016E898 0C019B4F jal        0x66d3c
0016E89C 00004025 move       $t0, $zero
0016E8A0 10000016 b          0x16e8fc
0016E8A4 00000000 nop        
0016E8A8 34040007 ori        $a0, $zero, 7
0016E8AC 0C0327CD jal        0xc9f34
0016E8B0 02002825 move       $a1, $s0
0016E8B4 0C007265 jal        0x1c994
0016E8B8 34040003 ori        $a0, $zero, 3
0016E8BC 00408025 move       $s0, $v0
0016E8C0 1200000E beqz       $s0, 0x16e8fc
0016E8C4 00000000 nop        
0016E8C8 C60C0014 lwc1       $f12, 0x14($s0)
0016E8CC C60D0018 lwc1       $f13, 0x18($s0)
0016E8D0 C60E001C lwc1       $f14, 0x1c($s0)
0016E8D4 C60F0020 lwc1       $f15, 0x20($s0)
0016E8D8 34070000 ori        $a3, $zero, 0
0016E8DC 34090000 ori        $t1, $zero, 0
0016E8E0 340A0000 ori        $t2, $zero, 0
0016E8E4 340B0001 ori        $t3, $zero, 1
0016E8E8 03C02025 move       $a0, $fp
0016E8EC 02002825 move       $a1, $s0
0016E8F0 00003025 move       $a2, $zero
0016E8F4 0C019B4F jal        0x66d3c
0016E8F8 00004025 move       $t0, $zero
0016E8FC 92E40042 lbu        $a0, 0x42($s7)
0016E900 1080000F beqz       $a0, 0x16e940
0016E904 00000000 nop        
0016E908 92E40043 lbu        $a0, 0x43($s7)
0016E90C 28840003 slti       $a0, $a0, 3
0016E910 1080000B beqz       $a0, 0x16e940
0016E914 00000000 nop        
0016E918 0C05B7F4 jal        0x16dfd0
0016E91C 03C02025 move       $a0, $fp
0016E920 92E40043 lbu        $a0, 0x43($s7)
0016E924 C6F80008 lwc1       $f24, 8($s7)
0016E928 24840001 addiu      $a0, $a0, 1
0016E92C A2E40043 sb         $a0, 0x43($s7)
0016E930 3C043480 lui        $a0, 0x3480
0016E934 C6EC000C lwc1       $f12, 0xc($s7)
0016E938 10000089 b          0x16eb60
0016E93C 4484D000 mtc1       $a0, $f26
0016E940 03C02025 move       $a0, $fp
0016E944 0C0192FF jal        0x64bfc
0016E948 34050001 ori        $a1, $zero, 1
0016E94C 100000E5 b          0x16ece4
0016E950 00000000 nop        
0016E954 0216202A slt        $a0, $s0, $s6
0016E958 1480FEBD bnez       $a0, 0x16e450
0016E95C 26100001 addiu      $s0, $s0, 1
0016E960 3C053480 lui        $a1, 0x3480
0016E964 4480C000 mtc1       $zero, $f24
0016E968 27B00064 addiu      $s0, $sp, 0x64
0016E96C 4485D000 mtc1       $a1, $f26
0016E970 26E40020 addiu      $a0, $s7, 0x20
0016E974 10000016 b          0x16e9d0
0016E978 C6EC002C lwc1       $f12, 0x2c($s7)
0016E97C C6EC0010 lwc1       $f12, 0x10($s7)
0016E980 C7CD0030 lwc1       $f13, 0x30($fp)
0016E984 46186302 mul.s      $f12, $f12, $f24
0016E988 C7CE0034 lwc1       $f14, 0x34($fp)
0016E98C C7CF0038 lwc1       $f15, 0x38($fp)
0016E990 460C6B00 add.s      $f12, $f13, $f12
0016E994 3C053480 lui        $a1, 0x3480
0016E998 E7AC0058 swc1       $f12, 0x58($sp)
0016E99C C6EC0014 lwc1       $f12, 0x14($s7)
0016E9A0 46186302 mul.s      $f12, $f12, $f24
0016E9A4 27B00064 addiu      $s0, $sp, 0x64
0016E9A8 26E40020 addiu      $a0, $s7, 0x20
0016E9AC 4485D000 mtc1       $a1, $f26
0016E9B0 460C7300 add.s      $f12, $f14, $f12
0016E9B4 E7AC005C swc1       $f12, 0x5c($sp)
0016E9B8 C6EC0018 lwc1       $f12, 0x18($s7)
0016E9BC 46186302 mul.s      $f12, $f12, $f24
0016E9C0 460C7B00 add.s      $f12, $f15, $f12
0016E9C4 4480C000 mtc1       $zero, $f24
0016E9C8 E7AC0060 swc1       $f12, 0x60($sp)
0016E9CC C6EC002C lwc1       $f12, 0x2c($s7)
0016E9D0 00802825 move       $a1, $a0
0016E9D4 0C03ABAB jal        0xeaeac
0016E9D8 02002025 move       $a0, $s0
0016E9DC C7D20020 lwc1       $f18, 0x20($fp)
0016E9E0 C7D10024 lwc1       $f17, 0x24($fp)
0016E9E4 46129302 mul.s      $f12, $f18, $f18
0016E9E8 C7D00028 lwc1       $f16, 0x28($fp)
0016E9EC 46118B42 mul.s      $f13, $f17, $f17
0016E9F0 C7CF0010 lwc1       $f15, 0x10($fp)
0016E9F4 461084C2 mul.s      $f19, $f16, $f16
0016E9F8 C7CE0014 lwc1       $f14, 0x14($fp)
0016E9FC 460D6300 add.s      $f12, $f12, $f13
0016EA00 46136300 add.s      $f12, $f12, $f19
0016EA04 461A603C c.lt.s     $f12, $f26
0016EA08 00000000 nop        
0016EA0C 4500000B bc1f       0x16ea3c
0016EA10 C7CD0018 lwc1       $f13, 0x18($fp)
0016EA14 46107302 mul.s      $f12, $f14, $f16
0016EA18 46116CC2 mul.s      $f19, $f13, $f17
0016EA1C 46107802 mul.s      $f0, $f15, $f16
0016EA20 46127382 mul.s      $f14, $f14, $f18
0016EA24 46126B42 mul.s      $f13, $f13, $f18
0016EA28 46117BC2 mul.s      $f15, $f15, $f17
0016EA2C 46136301 sub.s      $f12, $f12, $f19
0016EA30 46006B41 sub.s      $f13, $f13, $f0
0016EA34 10000012 b          0x16ea80
0016EA38 460E7B81 sub.s      $f14, $f15, $f14
0016EA3C 46006304 sqrt.s     $f12, $f12
0016EA40 460CA303 div.s      $f12, $f20, $f12
0016EA44 460C9482 mul.s      $f18, $f18, $f12
0016EA48 460C8C42 mul.s      $f17, $f17, $f12
0016EA4C 460C8402 mul.s      $f16, $f16, $f12
0016EA50 46126CC2 mul.s      $f19, $f13, $f18
0016EA54 E7D20020 swc1       $f18, 0x20($fp)
0016EA58 46116B02 mul.s      $f12, $f13, $f17
0016EA5C 46107002 mul.s      $f0, $f14, $f16
0016EA60 E7D10024 swc1       $f17, 0x24($fp)
0016EA64 E7D00028 swc1       $f16, 0x28($fp)
0016EA68 46107B42 mul.s      $f13, $f15, $f16
0016EA6C 46127382 mul.s      $f14, $f14, $f18
0016EA70 460C0301 sub.s      $f12, $f0, $f12
0016EA74 46117BC2 mul.s      $f15, $f15, $f17
0016EA78 460D9B41 sub.s      $f13, $f19, $f13
0016EA7C 460E7B81 sub.s      $f14, $f15, $f14
0016EA80 E7CD0004 swc1       $f13, 4($fp)
0016EA84 460063C6 mov.s      $f15, $f12
0016EA88 E7CE0008 swc1       $f14, 8($fp)
0016EA8C 460F7CC2 mul.s      $f19, $f15, $f15
0016EA90 E7CC0000 swc1       $f12, ($fp)
0016EA94 460E7002 mul.s      $f0, $f14, $f14
0016EA98 460D6B02 mul.s      $f12, $f13, $f13
0016EA9C 460C9B00 add.s      $f12, $f19, $f12
0016EAA0 46006300 add.s      $f12, $f12, $f0
0016EAA4 461A603C c.lt.s     $f12, $f26
0016EAA8 00000000 nop        
0016EAAC 4500000B bc1f       0x16eadc
0016EAB0 E7D8000C swc1       $f24, 0xc($fp)
0016EAB4 460D8302 mul.s      $f12, $f16, $f13
0016EAB8 460E8D02 mul.s      $f20, $f17, $f14
0016EABC 460F8402 mul.s      $f16, $f16, $f15
0016EAC0 460E9382 mul.s      $f14, $f18, $f14
0016EAC4 460D9342 mul.s      $f13, $f18, $f13
0016EAC8 460CA501 sub.s      $f20, $f20, $f12
0016EACC 460F8BC2 mul.s      $f15, $f17, $f15
0016EAD0 460E8381 sub.s      $f14, $f16, $f14
0016EAD4 10000012 b          0x16eb20
0016EAD8 460F6B01 sub.s      $f12, $f13, $f15
0016EADC 46006304 sqrt.s     $f12, $f12
0016EAE0 460CA303 div.s      $f12, $f20, $f12
0016EAE4 460C7BC2 mul.s      $f15, $f15, $f12
0016EAE8 460C6B42 mul.s      $f13, $f13, $f12
0016EAEC E7CF0000 swc1       $f15, ($fp)
0016EAF0 460C7302 mul.s      $f12, $f14, $f12
0016EAF4 E7CD0004 swc1       $f13, 4($fp)
0016EAF8 460D8502 mul.s      $f20, $f16, $f13
0016EAFC 460C8CC2 mul.s      $f19, $f17, $f12
0016EB00 E7CC0008 swc1       $f12, 8($fp)
0016EB04 460F8382 mul.s      $f14, $f16, $f15
0016EB08 460D9342 mul.s      $f13, $f18, $f13
0016EB0C 460C9302 mul.s      $f12, $f18, $f12
0016EB10 460F8BC2 mul.s      $f15, $f17, $f15
0016EB14 46149D01 sub.s      $f20, $f19, $f20
0016EB18 460C7381 sub.s      $f14, $f14, $f12
0016EB1C 460F6B01 sub.s      $f12, $f13, $f15
0016EB20 E7D40010 swc1       $f20, 0x10($fp)
0016EB24 E7CE0014 swc1       $f14, 0x14($fp)
0016EB28 E7CC0018 swc1       $f12, 0x18($fp)
0016EB2C E7D8001C swc1       $f24, 0x1c($fp)
0016EB30 03C02025 move       $a0, $fp
0016EB34 03C02825 move       $a1, $fp
0016EB38 0C03B8E1 jal        0xee384
0016EB3C 02003025 move       $a2, $s0
0016EB40 C7AC0058 lwc1       $f12, 0x58($sp)
0016EB44 C7AD005C lwc1       $f13, 0x5c($sp)
0016EB48 E7CC0030 swc1       $f12, 0x30($fp)
0016EB4C C7AC0060 lwc1       $f12, 0x60($sp)
0016EB50 E7CD0034 swc1       $f13, 0x34($fp)
0016EB54 E7CC0038 swc1       $f12, 0x38($fp)
0016EB58 C6F80008 lwc1       $f24, 8($s7)
0016EB5C C6EC000C lwc1       $f12, 0xc($s7)
0016EB60 460CC03C c.lt.s     $f24, $f12
0016EB64 00000000 nop        
0016EB68 45000009 bc1f       0x16eb90
0016EB6C 3C04002A lui        $a0, 0x2a
0016EB70 C48D5D14 lwc1       $f13, 0x5d14($a0)
0016EB74 460DC600 add.s      $f24, $f24, $f13
0016EB78 460CC03E c.le.s     $f24, $f12
0016EB7C 00000000 nop        
0016EB80 45010003 bc1t       0x16eb90
0016EB84 E6F80008 swc1       $f24, 8($s7)
0016EB88 E6EC0008 swc1       $f12, 8($s7)
0016EB8C 46006606 mov.s      $f24, $f12
0016EB90 C7CF0020 lwc1       $f15, 0x20($fp)
0016EB94 C7D00024 lwc1       $f16, 0x24($fp)
0016EB98 460F7B42 mul.s      $f13, $f15, $f15
0016EB9C C7D10028 lwc1       $f17, 0x28($fp)
0016EBA0 46108382 mul.s      $f14, $f16, $f16
0016EBA4 8FC40040 lw         $a0, 0x40($fp)
0016EBA8 46118882 mul.s      $f2, $f17, $f17
0016EBAC C7CC0010 lwc1       $f12, 0x10($fp)
0016EBB0 460E6CC0 add.s      $f19, $f13, $f14
0016EBB4 46029880 add.s      $f2, $f19, $f2
0016EBB8 C7CD0014 lwc1       $f13, 0x14($fp)
0016EBBC C7CE0018 lwc1       $f14, 0x18($fp)
0016EBC0 C7D20000 lwc1       $f18, ($fp)
0016EBC4 C7D30004 lwc1       $f19, 4($fp)
0016EBC8 461A103C c.lt.s     $f2, $f26
0016EBCC 00000000 nop        
0016EBD0 4501000A bc1t       0x16ebfc
0016EBD4 C7C00008 lwc1       $f0, 8($fp)
0016EBD8 46001084 sqrt.s     $f2, $f2
0016EBDC 4602C083 div.s      $f2, $f24, $f2
0016EBE0 46027BC2 mul.s      $f15, $f15, $f2
0016EBE4 46028402 mul.s      $f16, $f16, $f2
0016EBE8 46028C42 mul.s      $f17, $f17, $f2
0016EBEC E7CF0020 swc1       $f15, 0x20($fp)
0016EBF0 E7D00024 swc1       $f16, 0x24($fp)
0016EBF4 E7D10028 swc1       $f17, 0x28($fp)
0016EBF8 C6F80008 lwc1       $f24, 8($s7)
0016EBFC 460C63C2 mul.s      $f15, $f12, $f12
0016EC00 460D6C02 mul.s      $f16, $f13, $f13
0016EC04 460E7442 mul.s      $f17, $f14, $f14
0016EC08 46107BC0 add.s      $f15, $f15, $f16
0016EC0C 46117BC0 add.s      $f15, $f15, $f17
0016EC10 461A783C c.lt.s     $f15, $f26
0016EC14 00000000 nop        
0016EC18 4503000B bc1tl      0x16ec48
0016EC1C 46129302 mul.s      $f12, $f18, $f18
0016EC20 46007BC4 sqrt.s     $f15, $f15
0016EC24 460FC3C3 div.s      $f15, $f24, $f15
0016EC28 460F6302 mul.s      $f12, $f12, $f15
0016EC2C 460F6B42 mul.s      $f13, $f13, $f15
0016EC30 460F7382 mul.s      $f14, $f14, $f15
0016EC34 E7CC0010 swc1       $f12, 0x10($fp)
0016EC38 E7CD0014 swc1       $f13, 0x14($fp)
0016EC3C E7CE0018 swc1       $f14, 0x18($fp)
0016EC40 C6F80008 lwc1       $f24, 8($s7)
0016EC44 46129302 mul.s      $f12, $f18, $f18
0016EC48 46139B42 mul.s      $f13, $f19, $f19
0016EC4C 46000382 mul.s      $f14, $f0, $f0
0016EC50 460D6300 add.s      $f12, $f12, $f13
0016EC54 460E6300 add.s      $f12, $f12, $f14
0016EC58 461A603C c.lt.s     $f12, $f26
0016EC5C 00000000 nop        
0016EC60 45000003 bc1f       0x16ec70
0016EC64 00000000 nop        
0016EC68 1000000A b          0x16ec94
0016EC6C 90840048 lbu        $a0, 0x48($a0)
0016EC70 46006304 sqrt.s     $f12, $f12
0016EC74 460CC303 div.s      $f12, $f24, $f12
0016EC78 460C9342 mul.s      $f13, $f18, $f12
0016EC7C 460C9B82 mul.s      $f14, $f19, $f12
0016EC80 E7CD0000 swc1       $f13, ($fp)
0016EC84 460C0302 mul.s      $f12, $f0, $f12
0016EC88 E7CE0004 swc1       $f14, 4($fp)
0016EC8C E7CC0008 swc1       $f12, 8($fp)
0016EC90 90840048 lbu        $a0, 0x48($a0)
0016EC94 10800013 beqz       $a0, 0x16ece4
0016EC98 00000000 nop        
0016EC9C C6EC0008 lwc1       $f12, 8($s7)
0016ECA0 C7CD0010 lwc1       $f13, 0x10($fp)
0016ECA4 460CB302 mul.s      $f12, $f22, $f12
0016ECA8 C7CE0030 lwc1       $f14, 0x30($fp)
0016ECAC C7CF0014 lwc1       $f15, 0x14($fp)
0016ECB0 C7D00034 lwc1       $f16, 0x34($fp)
0016ECB4 C7D10018 lwc1       $f17, 0x18($fp)
0016ECB8 46006307 neg.s      $f12, $f12
0016ECBC C7D20038 lwc1       $f18, 0x38($fp)
0016ECC0 460C6B42 mul.s      $f13, $f13, $f12
0016ECC4 460C7BC2 mul.s      $f15, $f15, $f12
0016ECC8 460D7340 add.s      $f13, $f14, $f13
0016ECCC 460C8B02 mul.s      $f12, $f17, $f12
0016ECD0 460F83C0 add.s      $f15, $f16, $f15
0016ECD4 E7CD0030 swc1       $f13, 0x30($fp)
0016ECD8 460C9300 add.s      $f12, $f18, $f12
0016ECDC E7CF0034 swc1       $f15, 0x34($fp)
0016ECE0 E7CC0038 swc1       $f12, 0x38($fp)
0016ECE4 C7B400D8 lwc1       $f20, 0xd8($sp)
0016ECE8 C7B600DC lwc1       $f22, 0xdc($sp)
0016ECEC C7B800E0 lwc1       $f24, 0xe0($sp)
0016ECF0 C7BA00E4 lwc1       $f26, 0xe4($sp)
0016ECF4 8FB000E8 lw         $s0, 0xe8($sp)
0016ECF8 8FB100EC lw         $s1, 0xec($sp)
0016ECFC 8FB200F0 lw         $s2, 0xf0($sp)
0016ED00 8FB300F4 lw         $s3, 0xf4($sp)
0016ED04 8FB400F8 lw         $s4, 0xf8($sp)
0016ED08 8FB500FC lw         $s5, 0xfc($sp)
0016ED0C 8FB60100 lw         $s6, 0x100($sp)
0016ED10 8FB70104 lw         $s7, 0x104($sp)
0016ED14 8FBE0108 lw         $fp, 0x108($sp)
0016ED18 8FBF010C lw         $ra, 0x10c($sp)
0016ED1C 03E00008 jr         $ra
0016ED20 27BD0110 addiu      $sp, $sp, 0x110