
CALLBACK 0x0013D148 end 0x0013D398 ordinal 0

0013D148 27BDFFB0 addiu      $sp, $sp, -0x50
0013D14C AFB0003C sw         $s0, 0x3c($sp)
0013D150 00808025 move       $s0, $a0
0013D154 AFB10040 sw         $s1, 0x40($sp)
0013D158 8E110058 lw         $s1, 0x58($s0)
0013D15C 00002825 move       $a1, $zero
0013D160 02202025 move       $a0, $s1
0013D164 E7B40030 swc1       $f20, 0x30($sp)
0013D168 E7B60034 swc1       $f22, 0x34($sp)
0013D16C E7B80038 swc1       $f24, 0x38($sp)
0013D170 AFB20044 sw         $s2, 0x44($sp)
0013D174 AFB30048 sw         $s3, 0x48($sp)
0013D178 AFBF004C sw         $ra, 0x4c($sp)
0013D17C 0C0600AC jal        0x1802b0
0013D180 340601A4 ori        $a2, $zero, 0x1a4
0013D184 3C04002A lui        $a0, 0x2a
0013D188 C48C9AE4 lwc1       $f12, -0x651c($a0)
0013D18C 24859AE4 addiu      $a1, $a0, -0x651c
0013D190 E62C0010 swc1       $f12, 0x10($s1)
0013D194 C4AC0004 lwc1       $f12, 4($a1)
0013D198 E62C0014 swc1       $f12, 0x14($s1)
0013D19C C4AC0008 lwc1       $f12, 8($a1)
0013D1A0 E62C0018 swc1       $f12, 0x18($s1)
0013D1A4 C48C9AE4 lwc1       $f12, -0x651c($a0)
0013D1A8 E62C0020 swc1       $f12, 0x20($s1)
0013D1AC C4AC0004 lwc1       $f12, 4($a1)
0013D1B0 E62C0024 swc1       $f12, 0x24($s1)
0013D1B4 C4AC0008 lwc1       $f12, 8($a1)
0013D1B8 3C05002A lui        $a1, 0x2a
0013D1BC 24B224CC addiu      $s2, $a1, 0x24cc
0013D1C0 27A40020 addiu      $a0, $sp, 0x20
0013D1C4 E62C0028 swc1       $f12, 0x28($s1)
0013D1C8 02002825 move       $a1, $s0
0013D1CC 0C03AF43 jal        0xebd0c
0013D1D0 02403025 move       $a2, $s2
0013D1D4 C7AC0020 lwc1       $f12, 0x20($sp)
0013D1D8 E62C0030 swc1       $f12, 0x30($s1)
0013D1DC C7AC0024 lwc1       $f12, 0x24($sp)
0013D1E0 E62C0034 swc1       $f12, 0x34($s1)
0013D1E4 C7AC0028 lwc1       $f12, 0x28($sp)
0013D1E8 3C080028 lui        $t0, 0x28
0013D1EC 262400A8 addiu      $a0, $s1, 0xa8
0013D1F0 00002825 move       $a1, $zero
0013D1F4 E62C0038 swc1       $f12, 0x38($s1)
0013D1F8 34060044 ori        $a2, $zero, 0x44
0013D1FC 34070045 ori        $a3, $zero, 0x45
0013D200 0C01859E jal        0x61678
0013D204 25082090 addiu      $t0, $t0, 0x2090
0013D208 3C04BF80 lui        $a0, 0xbf80
0013D20C 44846000 mtc1       $a0, $f12
0013D210 E62C002C swc1       $f12, 0x2c($s1)
0013D214 92040044 lbu        $a0, 0x44($s0)
0013D218 AE200188 sw         $zero, 0x188($s1)
0013D21C A224004E sb         $a0, 0x4e($s1)
0013D220 3C043E4C lui        $a0, 0x3e4c
0013D224 3484CCCD ori        $a0, $a0, 0xcccd
0013D228 44846000 mtc1       $a0, $f12
0013D22C AE20003C sw         $zero, 0x3c($s1)
0013D230 3C043F26 lui        $a0, 0x3f26
0013D234 E62C0050 swc1       $f12, 0x50($s1)
0013D238 34846666 ori        $a0, $a0, 0x6666
0013D23C 44846000 mtc1       $a0, $f12
0013D240 4480A000 mtc1       $zero, $f20
0013D244 3C044080 lui        $a0, 0x4080
0013D248 E6340058 swc1       $f20, 0x58($s1)
0013D24C 4484B000 mtc1       $a0, $f22
0013D250 E62C0054 swc1       $f12, 0x54($s1)
0013D254 3C043F00 lui        $a0, 0x3f00
0013D258 E6360074 swc1       $f22, 0x74($s1)
0013D25C 4484C000 mtc1       $a0, $f24
0013D260 E6380078 swc1       $f24, 0x78($s1)
0013D264 3C043DCC lui        $a0, 0x3dcc
0013D268 E634007C swc1       $f20, 0x7c($s1)
0013D26C 3484CCCD ori        $a0, $a0, 0xcccd
0013D270 44846000 mtc1       $a0, $f12
0013D274 E6340064 swc1       $f20, 0x64($s1)
0013D278 E62C0060 swc1       $f12, 0x60($s1)
0013D27C 34047800 ori        $a0, $zero, 0x7800
0013D280 AE240068 sw         $a0, 0x68($s1)
0013D284 AE20006C sw         $zero, 0x6c($s1)
0013D288 3404000C ori        $a0, $zero, 0xc
0013D28C AE240070 sw         $a0, 0x70($s1)
0013D290 34040004 ori        $a0, $zero, 4
0013D294 AE24005C sw         $a0, 0x5c($s1)
0013D298 34040002 ori        $a0, $zero, 2
0013D29C AE240080 sw         $a0, 0x80($s1)
0013D2A0 3C130028 lui        $s3, 0x28
0013D2A4 8E65F8D8 lw         $a1, -0x728($s3)
0013D2A8 3404000D ori        $a0, $zero, 0xd
0013D2AC 0C007870 jal        0x1e1c0
0013D2B0 8CA500F0 lw         $a1, 0xf0($a1)
0013D2B4 28440003 slti       $a0, $v0, 3
0013D2B8 38840001 xori       $a0, $a0, 1
0013D2BC 308400FF andi       $a0, $a0, 0xff
0013D2C0 3C05002A lui        $a1, 0x2a
0013D2C4 00042080 sll        $a0, $a0, 2
0013D2C8 24A52460 addiu      $a1, $a1, 0x2460
0013D2CC 00852021 addu       $a0, $a0, $a1
0013D2D0 8C840000 lw         $a0, ($a0)
0013D2D4 E636008C swc1       $f22, 0x8c($s1)
0013D2D8 AE240084 sw         $a0, 0x84($s1)
0013D2DC E6380090 swc1       $f24, 0x90($s1)
0013D2E0 E6340094 swc1       $f20, 0x94($s1)
0013D2E4 E6340088 swc1       $f20, 0x88($s1)
0013D2E8 E636009C swc1       $f22, 0x9c($s1)
0013D2EC E63800A0 swc1       $f24, 0xa0($s1)
0013D2F0 E63400A4 swc1       $f20, 0xa4($s1)
0013D2F4 E6380098 swc1       $f24, 0x98($s1)
0013D2F8 8E040048 lw         $a0, 0x48($s0)
0013D2FC 3C050014 lui        $a1, 0x14
0013D300 24A5D4B8 addiu      $a1, $a1, -0x2b48
0013D304 AC8500DC sw         $a1, 0xdc($a0)
0013D308 A2000045 sb         $zero, 0x45($s0)
0013D30C 0C04F862 jal        0x13e188
0013D310 2624018C addiu      $a0, $s1, 0x18c
0013D314 8E65F8D8 lw         $a1, -0x728($s3)
0013D318 8CA600F0 lw         $a2, 0xf0($a1)
0013D31C 26040074 addiu      $a0, $s0, 0x74
0013D320 3405000D ori        $a1, $zero, 0xd
0013D324 0C006F54 jal        0x1bd50
0013D328 2407FFFF addiu      $a3, $zero, -1
0013D32C 8E64F8D8 lw         $a0, -0x728($s3)
0013D330 3C05002A lui        $a1, 0x2a
0013D334 C4AC258C lwc1       $f12, 0x258c($a1)
0013D338 3C05002A lui        $a1, 0x2a
0013D33C C4AD2590 lwc1       $f13, 0x2590($a1)
0013D340 3C05002A lui        $a1, 0x2a
0013D344 C4AE2594 lwc1       $f14, 0x2594($a1)
0013D348 3C05002A lui        $a1, 0x2a
0013D34C 02403025 move       $a2, $s2
0013D350 34070001 ori        $a3, $zero, 1
0013D354 0C01569F jal        0x55a7c
0013D358 24A52580 addiu      $a1, $a1, 0x2580
0013D35C 8E040064 lw         $a0, 0x64($s0)
0013D360 3C050004 lui        $a1, 4
0013D364 00852025 or         $a0, $a0, $a1
0013D368 AE040064 sw         $a0, 0x64($s0)
0013D36C 34020001 ori        $v0, $zero, 1
0013D370 C7B40030 lwc1       $f20, 0x30($sp)
0013D374 C7B60034 lwc1       $f22, 0x34($sp)
0013D378 C7B80038 lwc1       $f24, 0x38($sp)
0013D37C 8FB0003C lw         $s0, 0x3c($sp)
0013D380 8FB10040 lw         $s1, 0x40($sp)
0013D384 8FB20044 lw         $s2, 0x44($sp)
0013D388 8FB30048 lw         $s3, 0x48($sp)
0013D38C 8FBF004C lw         $ra, 0x4c($sp)
0013D390 03E00008 jr         $ra
0013D394 27BD0050 addiu      $sp, $sp, 0x50

CALLBACK 0x0013D398 end 0x0013D3C4 ordinal 1

0013D398 27BDFFE0 addiu      $sp, $sp, -0x20
0013D39C 8C850058 lw         $a1, 0x58($a0)
0013D3A0 90A7004E lbu        $a3, 0x4e($a1)
0013D3A4 00003025 move       $a2, $zero
0013D3A8 90850045 lbu        $a1, 0x45($a0)
0013D3AC AFBF0010 sw         $ra, 0x10($sp)
0013D3B0 0C04F4F1 jal        0x13d3c4
0013D3B4 A0870044 sb         $a3, 0x44($a0)
0013D3B8 8FBF0010 lw         $ra, 0x10($sp)
0013D3BC 03E00008 jr         $ra
0013D3C0 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0013E4E8 end 0x0013EA50 ordinal 2

0013E4E8 27BDFF60 addiu      $sp, $sp, -0xa0
0013E4EC AFB00074 sw         $s0, 0x74($sp)
0013E4F0 00808025 move       $s0, $a0
0013E4F4 AFB10078 sw         $s1, 0x78($sp)
0013E4F8 8E110058 lw         $s1, 0x58($s0)
0013E4FC E7B40070 swc1       $f20, 0x70($sp)
0013E500 AFB2007C sw         $s2, 0x7c($sp)
0013E504 46006506 mov.s      $f20, $f12
0013E508 3404000D ori        $a0, $zero, 0xd
0013E50C 8E320000 lw         $s2, ($s1)
0013E510 AFB30080 sw         $s3, 0x80($sp)
0013E514 AFB40084 sw         $s4, 0x84($sp)
0013E518 AFB50088 sw         $s5, 0x88($sp)
0013E51C AFB6008C sw         $s6, 0x8c($sp)
0013E520 AFB70090 sw         $s7, 0x90($sp)
0013E524 AFBE0094 sw         $fp, 0x94($sp)
0013E528 AFBF0098 sw         $ra, 0x98($sp)
0013E52C 0C007541 jal        0x1d504
0013E530 8E4500F0 lw         $a1, 0xf0($s2)
0013E534 00409825 move       $s3, $v0
0013E538 0C0155F5 jal        0x557d4
0013E53C 02402025 move       $a0, $s2
0013E540 9224004C lbu        $a0, 0x4c($s1)
0013E544 34140000 ori        $s4, $zero, 0
0013E548 34160001 ori        $s6, $zero, 1
0013E54C 10800005 beqz       $a0, 0x13e564
0013E550 341E0001 ori        $fp, $zero, 1
0013E554 8E240008 lw         $a0, 8($s1)
0013E558 10800002 beqz       $a0, 0x13e564
0013E55C 00000000 nop        
0013E560 03C0A025 move       $s4, $fp
0013E564 27B70030 addiu      $s7, $sp, 0x30
0013E568 3C06002A lui        $a2, 0x2a
0013E56C 92150045 lbu        $s5, 0x45($s0)
0013E570 329400FF andi       $s4, $s4, 0xff
0013E574 02E02025 move       $a0, $s7
0013E578 02002825 move       $a1, $s0
0013E57C 0C03AF43 jal        0xebd0c
0013E580 24C624CC addiu      $a2, $a2, 0x24cc
0013E584 0C00A99C jal        0x2a670
0013E588 02402025 move       $a0, $s2
0013E58C 24440020 addiu      $a0, $v0, 0x20
0013E590 C48C0000 lwc1       $f12, ($a0)
0013E594 C48D0004 lwc1       $f13, 4($a0)
0013E598 C48E0008 lwc1       $f14, 8($a0)
0013E59C 44056000 mfc1       $a1, $f12
0013E5A0 C48F000C lwc1       $f15, 0xc($a0)
0013E5A4 44066800 mfc1       $a2, $f13
0013E5A8 AFA50040 sw         $a1, 0x40($sp)
0013E5AC 44047000 mfc1       $a0, $f14
0013E5B0 AFA60044 sw         $a2, 0x44($sp)
0013E5B4 44057800 mfc1       $a1, $f15
0013E5B8 AFA40048 sw         $a0, 0x48($sp)
0013E5BC AFA5004C sw         $a1, 0x4c($sp)
0013E5C0 0C00A99C jal        0x2a670
0013E5C4 02402025 move       $a0, $s2
0013E5C8 9224004C lbu        $a0, 0x4c($s1)
0013E5CC 8E65003C lw         $a1, 0x3c($s3)
0013E5D0 00043140 sll        $a2, $a0, 5
0013E5D4 00052880 sll        $a1, $a1, 2
0013E5D8 00C52821 addu       $a1, $a2, $a1
0013E5DC 3C06002A lui        $a2, 0x2a
0013E5E0 24C62488 addiu      $a2, $a2, 0x2488
0013E5E4 00A62821 addu       $a1, $a1, $a2
0013E5E8 C4AC0000 lwc1       $f12, ($a1)
0013E5EC 00042940 sll        $a1, $a0, 5
0013E5F0 00042080 sll        $a0, $a0, 2
0013E5F4 00A44821 addu       $t1, $a1, $a0
0013E5F8 3C04002A lui        $a0, 0x2a
0013E5FC 248424DC addiu      $a0, $a0, 0x24dc
0013E600 01244821 addu       $t1, $t1, $a0
0013E604 02402025 move       $a0, $s2
0013E608 27A50040 addiu      $a1, $sp, 0x40
0013E60C 00403025 move       $a2, $v0
0013E610 02E03825 move       $a3, $s7
0013E614 0C00BB23 jal        0x2ec8c
0013E618 34080001 ori        $t0, $zero, 1
0013E61C 0040B825 move       $s7, $v0
0013E620 16E00008 bnez       $s7, 0x13e644
0013E624 00000000 nop        
0013E628 0C00A900 jal        0x2a400
0013E62C 02402025 move       $a0, $s2
0013E630 1440005E bnez       $v0, 0x13e7ac
0013E634 00000000 nop        
0013E638 9224004C lbu        $a0, 0x4c($s1)
0013E63C 1080005B beqz       $a0, 0x13e7ac
0013E640 00000000 nop        
0013E644 0C00A900 jal        0x2a400
0013E648 02402025 move       $a0, $s2
0013E64C 10400007 beqz       $v0, 0x13e66c
0013E650 00000000 nop        
0013E654 8E240008 lw         $a0, 8($s1)
0013E658 12E40004 beq        $s7, $a0, 0x13e66c
0013E65C 00000000 nop        
0013E660 02002025 move       $a0, $s0
0013E664 0C04F3B2 jal        0x13cec8
0013E668 02E02825 move       $a1, $s7
0013E66C C62C002C lwc1       $f12, 0x2c($s1)
0013E670 3C04BF80 lui        $a0, 0xbf80
0013E674 44846800 mtc1       $a0, $f13
0013E678 460D6032 c.eq.s     $f12, $f13
0013E67C 00000000 nop        
0013E680 45010045 bc1t       0x13e798
0013E684 00000000 nop        
0013E688 0C00A900 jal        0x2a400
0013E68C 02402025 move       $a0, $s2
0013E690 10400012 beqz       $v0, 0x13e6dc
0013E694 00000000 nop        
0013E698 AFBE006C sw         $fp, 0x6c($sp)
0013E69C 27A50058 addiu      $a1, $sp, 0x58
0013E6A0 02E02025 move       $a0, $s7
0013E6A4 34060001 ori        $a2, $zero, 1
0013E6A8 0C019ACE jal        0x66b38
0013E6AC 00003825 move       $a3, $zero
0013E6B0 263E00A8 addiu      $fp, $s1, 0xa8
0013E6B4 03C02025 move       $a0, $fp
0013E6B8 34050001 ori        $a1, $zero, 1
0013E6BC 02E03025 move       $a2, $s7
0013E6C0 0C0183F6 jal        0x60fd8
0013E6C4 34070001 ori        $a3, $zero, 1
0013E6C8 03C02025 move       $a0, $fp
0013E6CC 27A50058 addiu      $a1, $sp, 0x58
0013E6D0 0C018416 jal        0x61058
0013E6D4 00003025 move       $a2, $zero
0013E6D8 8FBE006C lw         $fp, 0x6c($sp)
0013E6DC 0C015603 jal        0x5580c
0013E6E0 02402025 move       $a0, $s2
0013E6E4 8E44095C lw         $a0, 0x95c($s2)
0013E6E8 3C050002 lui        $a1, 2
0013E6EC 00852025 or         $a0, $a0, $a1
0013E6F0 AE44095C sw         $a0, 0x95c($s2)
0013E6F4 8E240008 lw         $a0, 8($s1)
0013E6F8 C64C0030 lwc1       $f12, 0x30($s2)
0013E6FC 24840030 addiu      $a0, $a0, 0x30
0013E700 C48D0000 lwc1       $f13, ($a0)
0013E704 C64E0034 lwc1       $f14, 0x34($s2)
0013E708 460C6B01 sub.s      $f12, $f13, $f12
0013E70C C64F0038 lwc1       $f15, 0x38($s2)
0013E710 E64C02A8 swc1       $f12, 0x2a8($s2)
0013E714 C4900004 lwc1       $f16, 4($a0)
0013E718 44806800 mtc1       $zero, $f13
0013E71C 460E8381 sub.s      $f14, $f16, $f14
0013E720 460C6442 mul.s      $f17, $f12, $f12
0013E724 460D6C82 mul.s      $f18, $f13, $f13
0013E728 E64E02AC swc1       $f14, 0x2ac($s2)
0013E72C C48E0008 lwc1       $f14, 8($a0)
0013E730 460F7381 sub.s      $f14, $f14, $f15
0013E734 3C043480 lui        $a0, 0x3480
0013E738 E64D02AC swc1       $f13, 0x2ac($s2)
0013E73C 44848000 mtc1       $a0, $f16
0013E740 46128BC0 add.s      $f15, $f17, $f18
0013E744 460E74C2 mul.s      $f19, $f14, $f14
0013E748 46137BC0 add.s      $f15, $f15, $f19
0013E74C 4610783C c.lt.s     $f15, $f16
0013E750 00000000 nop        
0013E754 4501000B bc1t       0x13e784
0013E758 E64E02B0 swc1       $f14, 0x2b0($s2)
0013E75C 3C043F80 lui        $a0, 0x3f80
0013E760 46007BC4 sqrt.s     $f15, $f15
0013E764 44848000 mtc1       $a0, $f16
0013E768 460F83C3 div.s      $f15, $f16, $f15
0013E76C 460F6302 mul.s      $f12, $f12, $f15
0013E770 460F6B42 mul.s      $f13, $f13, $f15
0013E774 460F7382 mul.s      $f14, $f14, $f15
0013E778 E64C02A8 swc1       $f12, 0x2a8($s2)
0013E77C E64D02AC swc1       $f13, 0x2ac($s2)
0013E780 E64E02B0 swc1       $f14, 0x2b0($s2)
0013E784 A236004C sb         $s6, 0x4c($s1)
0013E788 3C04002A lui        $a0, 0x2a
0013E78C C48C24C8 lwc1       $f12, 0x24c8($a0)
0013E790 10000014 b          0x13e7e4
0013E794 E60C0070 swc1       $f12, 0x70($s0)
0013E798 C62C000C lwc1       $f12, 0xc($s1)
0013E79C 0C04F3D2 jal        0x13cf48
0013E7A0 02002025 move       $a0, $s0
0013E7A4 1000000F b          0x13e7e4
0013E7A8 00000000 nop        
0013E7AC 0C00A900 jal        0x2a400
0013E7B0 02402025 move       $a0, $s2
0013E7B4 1040000B beqz       $v0, 0x13e7e4
0013E7B8 00000000 nop        
0013E7BC C60C0070 lwc1       $f12, 0x70($s0)
0013E7C0 44806800 mtc1       $zero, $f13
0013E7C4 46146301 sub.s      $f12, $f12, $f20
0013E7C8 460D603E c.le.s     $f12, $f13
0013E7CC 00000000 nop        
0013E7D0 45000004 bc1f       0x13e7e4
0013E7D4 E60C0070 swc1       $f12, 0x70($s0)
0013E7D8 C62C000C lwc1       $f12, 0xc($s1)
0013E7DC 0C04F3D2 jal        0x13cf48
0013E7E0 02002025 move       $a0, $s0
0013E7E4 92040045 lbu        $a0, 0x45($s0)
0013E7E8 149E0010 bne        $a0, $fp, 0x13e82c
0013E7EC 00000000 nop        
0013E7F0 8E240004 lw         $a0, 4($s1)
0013E7F4 34050003 ori        $a1, $zero, 3
0013E7F8 1085000C beq        $a0, $a1, 0x13e82c
0013E7FC 00000000 nop        
0013E800 34040003 ori        $a0, $zero, 3
0013E804 44806800 mtc1       $zero, $f13
0013E808 3C083DCC lui        $t0, 0x3dcc
0013E80C AE240004 sw         $a0, 4($s1)
0013E810 3508CCCD ori        $t0, $t0, 0xcccd
0013E814 02002025 move       $a0, $s0
0013E818 44886000 mtc1       $t0, $f12
0013E81C 34050003 ori        $a1, $zero, 3
0013E820 00003025 move       $a2, $zero
0013E824 0C01955C jal        0x65570
0013E828 34070001 ori        $a3, $zero, 1
0013E82C 27A40050 addiu      $a0, $sp, 0x50
0013E830 0C00A9C4 jal        0x2a710
0013E834 02402825 move       $a1, $s2
0013E838 8FA40050 lw         $a0, 0x50($sp)
0013E83C 30840020 andi       $a0, $a0, 0x20
0013E840 1080006C beqz       $a0, 0x13e9f4
0013E844 00000000 nop        
0013E848 0C04F511 jal        0x13d444
0013E84C 02002025 move       $a0, $s0
0013E850 10400068 beqz       $v0, 0x13e9f4
0013E854 00000000 nop        
0013E858 264400C0 addiu      $a0, $s2, 0xc0
0013E85C 8C840014 lw         $a0, 0x14($a0)
0013E860 30842000 andi       $a0, $a0, 0x2000
0013E864 1080005D beqz       $a0, 0x13e9dc
0013E868 00000000 nop        
0013E86C A2160045 sb         $s6, 0x45($s0)
0013E870 8E360008 lw         $s6, 8($s1)
0013E874 12C00007 beqz       $s6, 0x13e894
0013E878 00000000 nop        
0013E87C 8E24003C lw         $a0, 0x3c($s1)
0013E880 10960004 beq        $a0, $s6, 0x13e894
0013E884 00000000 nop        
0013E888 44806000 mtc1       $zero, $f12
0013E88C E62C000C swc1       $f12, 0xc($s1)
0013E890 E60C0070 swc1       $f12, 0x70($s0)
0013E894 3C04002A lui        $a0, 0x2a
0013E898 8C8425C0 lw         $a0, 0x25c0($a0)
0013E89C 10800012 beqz       $a0, 0x13e8e8
0013E8A0 00000000 nop        
0013E8A4 8E250188 lw         $a1, 0x188($s1)
0013E8A8 14A0000F bnez       $a1, 0x13e8e8
0013E8AC 00000000 nop        
0013E8B0 1080000D beqz       $a0, 0x13e8e8
0013E8B4 00802825 move       $a1, $a0
0013E8B8 C4AC0014 lwc1       $f12, 0x14($a1)
0013E8BC C4AD0018 lwc1       $f13, 0x18($a1)
0013E8C0 C4AE001C lwc1       $f14, 0x1c($a1)
0013E8C4 26260188 addiu      $a2, $s1, 0x188
0013E8C8 C4AF0020 lwc1       $f15, 0x20($a1)
0013E8CC 34070000 ori        $a3, $zero, 0
0013E8D0 34090000 ori        $t1, $zero, 0
0013E8D4 340B0001 ori        $t3, $zero, 1
0013E8D8 340A0000 ori        $t2, $zero, 0
0013E8DC 02002025 move       $a0, $s0
0013E8E0 0C019B4F jal        0x66d3c
0013E8E4 00004025 move       $t0, $zero
0013E8E8 3C05002A lui        $a1, 0x2a
0013E8EC 8CA5BD20 lw         $a1, -0x42e0($a1)
0013E8F0 34040009 ori        $a0, $zero, 9
0013E8F4 14A40009 bne        $a1, $a0, 0x13e91c
0013E8F8 3C040009 lui        $a0, 9
0013E8FC 2484C9A8 addiu      $a0, $a0, -0x3658
0013E900 9085000D lbu        $a1, 0xd($a0)
0013E904 18A00005 blez       $a1, 0x13e91c
0013E908 28A50040 slti       $a1, $a1, 0x40
0013E90C 10A00003 beqz       $a1, 0x13e91c
0013E910 00000000 nop        
0013E914 34050080 ori        $a1, $zero, 0x80
0013E918 A085000D sb         $a1, 0xd($a0)
0013E91C 8E240008 lw         $a0, 8($s1)
0013E920 1080002B beqz       $a0, 0x13e9d0
0013E924 00000000 nop        
0013E928 9225004C lbu        $a1, 0x4c($s1)
0013E92C 10A00028 beqz       $a1, 0x13e9d0
0013E930 00000000 nop        
0013E934 AE24003C sw         $a0, 0x3c($s1)
0013E938 8E64003C lw         $a0, 0x3c($s3)
0013E93C 3C05002A lui        $a1, 0x2a
0013E940 00042080 sll        $a0, $a0, 2
0013E944 24A52468 addiu      $a1, $a1, 0x2468
0013E948 C62C000C lwc1       $f12, 0xc($s1)
0013E94C 00852021 addu       $a0, $a0, $a1
0013E950 C48D0000 lwc1       $f13, ($a0)
0013E954 02002025 move       $a0, $s0
0013E958 460D6300 add.s      $f12, $f12, $f13
0013E95C 0C04F77D jal        0x13ddf4
0013E960 E62C000C swc1       $f12, 0xc($s1)
0013E964 0C00A900 jal        0x2a400
0013E968 02402025 move       $a0, $s2
0013E96C 1040001F beqz       $v0, 0x13e9ec
0013E970 00000000 nop        
0013E974 C62D000C lwc1       $f13, 0xc($s1)
0013E978 C62C002C lwc1       $f12, 0x2c($s1)
0013E97C 460C6B43 div.s      $f13, $f13, $f12
0013E980 3C043F80 lui        $a0, 0x3f80
0013E984 44846000 mtc1       $a0, $f12
0013E988 460D603C c.lt.s     $f12, $f13
0013E98C 00000000 nop        
0013E990 45030001 bc1tl      0x13e998
0013E994 46006346 mov.s      $f13, $f12
0013E998 46006B06 mov.s      $f12, $f13
0013E99C 0C0277CB jal        0x9df2c
0013E9A0 34040003 ori        $a0, $zero, 3
0013E9A4 C62C000C lwc1       $f12, 0xc($s1)
0013E9A8 C62E002C lwc1       $f14, 0x2c($s1)
0013E9AC 460E603E c.le.s     $f12, $f14
0013E9B0 00000000 nop        
0013E9B4 45010004 bc1t       0x13e9c8
0013E9B8 00000000 nop        
0013E9BC 8E250008 lw         $a1, 8($s1)
0013E9C0 0C04F3E5 jal        0x13cf94
0013E9C4 02002025 move       $a0, $s0
0013E9C8 10000008 b          0x13e9ec
0013E9CC 00000000 nop        
0013E9D0 44806000 mtc1       $zero, $f12
0013E9D4 10000005 b          0x13e9ec
0013E9D8 E62C000C swc1       $f12, 0xc($s1)
0013E9DC 02002025 move       $a0, $s0
0013E9E0 02A02825 move       $a1, $s5
0013E9E4 0C04F4F1 jal        0x13d3c4
0013E9E8 02803025 move       $a2, $s4
0013E9EC 10000006 b          0x13ea08
0013E9F0 C7AC0030 lwc1       $f12, 0x30($sp)
0013E9F4 02002025 move       $a0, $s0
0013E9F8 02A02825 move       $a1, $s5
0013E9FC 0C04F4F1 jal        0x13d3c4
0013EA00 02803025 move       $a2, $s4
0013EA04 C7AC0030 lwc1       $f12, 0x30($sp)
0013EA08 E62C0030 swc1       $f12, 0x30($s1)
0013EA0C C7AC0034 lwc1       $f12, 0x34($sp)
0013EA10 E62C0034 swc1       $f12, 0x34($s1)
0013EA14 C7AC0038 lwc1       $f12, 0x38($sp)
0013EA18 E62C0038 swc1       $f12, 0x38($s1)
0013EA1C C7B40070 lwc1       $f20, 0x70($sp)
0013EA20 8FB00074 lw         $s0, 0x74($sp)
0013EA24 8FB10078 lw         $s1, 0x78($sp)
0013EA28 8FB2007C lw         $s2, 0x7c($sp)
0013EA2C 8FB30080 lw         $s3, 0x80($sp)
0013EA30 8FB40084 lw         $s4, 0x84($sp)
0013EA34 8FB50088 lw         $s5, 0x88($sp)
0013EA38 8FB6008C lw         $s6, 0x8c($sp)
0013EA3C 8FB70090 lw         $s7, 0x90($sp)
0013EA40 8FBE0094 lw         $fp, 0x94($sp)
0013EA44 8FBF0098 lw         $ra, 0x98($sp)
0013EA48 03E00008 jr         $ra
0013EA4C 27BD00A0 addiu      $sp, $sp, 0xa0