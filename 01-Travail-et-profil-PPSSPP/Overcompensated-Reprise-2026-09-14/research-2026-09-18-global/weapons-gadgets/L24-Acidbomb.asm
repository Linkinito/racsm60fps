
CALLBACK 0x000FD04C end 0x000FD05C ordinal 0

000FD04C 8C840058 lw         $a0, 0x58($a0)
000FD050 34020001 ori        $v0, $zero, 1
000FD054 03E00008 jr         $ra
000FD058 AC800044 sw         $zero, 0x44($a0)

CALLBACK 0x000FD05C end 0x000FD090 ordinal 1

000FD05C 27BDFFE0 addiu      $sp, $sp, -0x20
000FD060 8C850058 lw         $a1, 0x58($a0)
000FD064 8CA40044 lw         $a0, 0x44($a1)
000FD068 AFBF0014 sw         $ra, 0x14($sp)
000FD06C 10800005 beqz       $a0, 0xfd084
000FD070 00000000 nop        
000FD074 0C019BAB jal        0x66eac
000FD078 AFA50010 sw         $a1, 0x10($sp)
000FD07C 8FA40010 lw         $a0, 0x10($sp)
000FD080 AC800044 sw         $zero, 0x44($a0)
000FD084 8FBF0014 lw         $ra, 0x14($sp)
000FD088 03E00008 jr         $ra
000FD08C 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x000FD9C4 end 0x000FE108 ordinal 2

000FD9C4 27BDFED0 addiu      $sp, $sp, -0x130
000FD9C8 AFB20124 sw         $s2, 0x124($sp)
000FD9CC 8C920058 lw         $s2, 0x58($a0)
000FD9D0 C64D0034 lwc1       $f13, 0x34($s2)
000FD9D4 AFB30128 sw         $s3, 0x128($sp)
000FD9D8 460C6B41 sub.s      $f13, $f13, $f12
000FD9DC 8E530000 lw         $s3, ($s2)
000FD9E0 C64E000C lwc1       $f14, 0xc($s2)
000FD9E4 460C7301 sub.s      $f12, $f14, $f12
000FD9E8 8E450038 lw         $a1, 0x38($s2)
000FD9EC E64D0034 swc1       $f13, 0x34($s2)
000FD9F0 44807800 mtc1       $zero, $f15
000FD9F4 E64C000C swc1       $f12, 0xc($s2)
000FD9F8 E7AF0040 swc1       $f15, 0x40($sp)
000FD9FC C64C000C lwc1       $f12, 0xc($s2)
000FDA00 AFB0011C sw         $s0, 0x11c($sp)
000FDA04 AFB10120 sw         $s1, 0x120($sp)
000FDA08 460F603E c.le.s     $f12, $f15
000FDA0C 00808025 move       $s0, $a0
000FDA10 38B10003 xori       $s1, $a1, 3
000FDA14 E7B40118 swc1       $f20, 0x118($sp)
000FDA18 AFBF012C sw         $ra, 0x12c($sp)
000FDA1C 45010003 bc1t       0xfda2c
000FDA20 2E310001 sltiu      $s1, $s1, 1
000FDA24 10000002 b          0xfda30
000FDA28 2644000C addiu      $a0, $s2, 0xc
000FDA2C 27A40040 addiu      $a0, $sp, 0x40
000FDA30 C48C0000 lwc1       $f12, ($a0)
000FDA34 34040001 ori        $a0, $zero, 1
000FDA38 E64C000C swc1       $f12, 0xc($s2)
000FDA3C 92050045 lbu        $a1, 0x45($s0)
000FDA40 54A4002E bnel       $a1, $a0, 0xfdafc
000FDA44 C60C0030 lwc1       $f12, 0x30($s0)
000FDA48 8E440040 lw         $a0, 0x40($s2)
000FDA4C 34050001 ori        $a1, $zero, 1
000FDA50 14850019 bne        $a0, $a1, 0xfdab8
000FDA54 00000000 nop        
000FDA58 3C04002A lui        $a0, 0x2a
000FDA5C 2484C144 addiu      $a0, $a0, -0x3ebc
000FDA60 8C840004 lw         $a0, 4($a0)
000FDA64 1080000B beqz       $a0, 0xfda94
000FDA68 00000000 nop        
000FDA6C 8E440044 lw         $a0, 0x44($s2)
000FDA70 14800008 bnez       $a0, 0xfda94
000FDA74 00000000 nop        
000FDA78 3C04002A lui        $a0, 0x2a
000FDA7C 44806000 mtc1       $zero, $f12
000FDA80 2484C144 addiu      $a0, $a0, -0x3ebc
000FDA84 8C840004 lw         $a0, 4($a0)
000FDA88 26050030 addiu      $a1, $s0, 0x30
000FDA8C 0C01E518 jal        0x79460
000FDA90 26460044 addiu      $a2, $s2, 0x44
000FDA94 3C06002A lui        $a2, 0x2a
000FDA98 00112080 sll        $a0, $s1, 2
000FDA9C 24C6C154 addiu      $a2, $a2, -0x3eac
000FDAA0 8E450038 lw         $a1, 0x38($s2)
000FDAA4 00862021 addu       $a0, $a0, $a2
000FDAA8 C48C0000 lwc1       $f12, ($a0)
000FDAAC 24A50009 addiu      $a1, $a1, 9
000FDAB0 0C03F842 jal        0xfe108
000FDAB4 02002025 move       $a0, $s0
000FDAB8 C64C000C lwc1       $f12, 0xc($s2)
000FDABC 44806800 mtc1       $zero, $f13
000FDAC0 460D603E c.le.s     $f12, $f13
000FDAC4 00000000 nop        
000FDAC8 4500000A bc1f       0xfdaf4
000FDACC 00000000 nop        
000FDAD0 8E440044 lw         $a0, 0x44($s2)
000FDAD4 10800004 beqz       $a0, 0xfdae8
000FDAD8 00000000 nop        
000FDADC 0C019BAB jal        0x66eac
000FDAE0 8E440044 lw         $a0, 0x44($s2)
000FDAE4 AE400044 sw         $zero, 0x44($s2)
000FDAE8 02002025 move       $a0, $s0
000FDAEC 0C0192FF jal        0x64bfc
000FDAF0 34050001 ori        $a1, $zero, 1
000FDAF4 1000017C b          0xfe0e8
000FDAF8 00000000 nop        
000FDAFC C60D0034 lwc1       $f13, 0x34($s0)
000FDB00 E7AC0044 swc1       $f12, 0x44($sp)
000FDB04 C60E0038 lwc1       $f14, 0x38($s0)
000FDB08 E7AD0048 swc1       $f13, 0x48($sp)
000FDB0C C60F003C lwc1       $f15, 0x3c($s0)
000FDB10 E7AE004C swc1       $f14, 0x4c($sp)
000FDB14 E7AF0050 swc1       $f15, 0x50($sp)
000FDB18 C64F0010 lwc1       $f15, 0x10($s2)
000FDB1C 460F6300 add.s      $f12, $f12, $f15
000FDB20 E60C0030 swc1       $f12, 0x30($s0)
000FDB24 C64C0014 lwc1       $f12, 0x14($s2)
000FDB28 460C6B00 add.s      $f12, $f13, $f12
000FDB2C E60C0034 swc1       $f12, 0x34($s0)
000FDB30 C64C0018 lwc1       $f12, 0x18($s2)
000FDB34 460C7300 add.s      $f12, $f14, $f12
000FDB38 E60C0038 swc1       $f12, 0x38($s0)
000FDB3C C64C0014 lwc1       $f12, 0x14($s2)
000FDB40 C6500008 lwc1       $f16, 8($s2)
000FDB44 46106301 sub.s      $f12, $f12, $f16
000FDB48 E64C0014 swc1       $f12, 0x14($s2)
000FDB4C C60C0030 lwc1       $f12, 0x30($s0)
000FDB50 C7AD0044 lwc1       $f13, 0x44($sp)
000FDB54 C60F0034 lwc1       $f15, 0x34($s0)
000FDB58 C7AE0048 lwc1       $f14, 0x48($sp)
000FDB5C 460D6301 sub.s      $f12, $f12, $f13
000FDB60 C6110038 lwc1       $f17, 0x38($s0)
000FDB64 460E7B81 sub.s      $f14, $f15, $f14
000FDB68 C7B0004C lwc1       $f16, 0x4c($sp)
000FDB6C E7AC0054 swc1       $f12, 0x54($sp)
000FDB70 46108C01 sub.s      $f16, $f17, $f16
000FDB74 460C6302 mul.s      $f12, $f12, $f12
000FDB78 460E7342 mul.s      $f13, $f14, $f14
000FDB7C E7AE0058 swc1       $f14, 0x58($sp)
000FDB80 E7B0005C swc1       $f16, 0x5c($sp)
000FDB84 46108382 mul.s      $f14, $f16, $f16
000FDB88 460D6300 add.s      $f12, $f12, $f13
000FDB8C 0C05E2E0 jal        0x178b80
000FDB90 460E6300 add.s      $f12, $f12, $f14
000FDB94 C7AC0054 lwc1       $f12, 0x54($sp)
000FDB98 C7AF0058 lwc1       $f15, 0x58($sp)
000FDB9C 460C6302 mul.s      $f12, $f12, $f12
000FDBA0 C7B0005C lwc1       $f16, 0x5c($sp)
000FDBA4 460F7B42 mul.s      $f13, $f15, $f15
000FDBA8 3C043480 lui        $a0, 0x3480
000FDBAC 46108382 mul.s      $f14, $f16, $f16
000FDBB0 44848800 mtc1       $a0, $f17
000FDBB4 460D6300 add.s      $f12, $f12, $f13
000FDBB8 460E6300 add.s      $f12, $f12, $f14
000FDBBC 4611603C c.lt.s     $f12, $f17
000FDBC0 00000000 nop        
000FDBC4 4501000E bc1t       0xfdc00
000FDBC8 46000506 mov.s      $f20, $f0
000FDBCC 3C043F80 lui        $a0, 0x3f80
000FDBD0 46006304 sqrt.s     $f12, $f12
000FDBD4 44846800 mtc1       $a0, $f13
000FDBD8 460C6B03 div.s      $f12, $f13, $f12
000FDBDC C7AE0054 lwc1       $f14, 0x54($sp)
000FDBE0 C7AF0058 lwc1       $f15, 0x58($sp)
000FDBE4 C7B0005C lwc1       $f16, 0x5c($sp)
000FDBE8 460C7382 mul.s      $f14, $f14, $f12
000FDBEC 460C7BC2 mul.s      $f15, $f15, $f12
000FDBF0 E7AE0054 swc1       $f14, 0x54($sp)
000FDBF4 460C8302 mul.s      $f12, $f16, $f12
000FDBF8 E7AF0058 swc1       $f15, 0x58($sp)
000FDBFC E7AC005C swc1       $f12, 0x5c($sp)
000FDC00 C64C000C lwc1       $f12, 0xc($s2)
000FDC04 44806800 mtc1       $zero, $f13
000FDC08 460D603E c.le.s     $f12, $f13
000FDC0C 00000000 nop        
000FDC10 45000024 bc1f       0xfdca4
000FDC14 3C04002A lui        $a0, 0x2a
000FDC18 44806000 mtc1       $zero, $f12
000FDC1C 26040030 addiu      $a0, $s0, 0x30
000FDC20 E7AC00C0 swc1       $f12, 0xc0($sp)
000FDC24 0C037599 jal        0xdd664
000FDC28 27A500C0 addiu      $a1, $sp, 0xc0
000FDC2C 04430011 bgezl      $v0, 0xfdc74
000FDC30 8E440038 lw         $a0, 0x38($s2)
000FDC34 0C03F471 jal        0xfd1c4
000FDC38 02002025 move       $a0, $s0
000FDC3C 8E450038 lw         $a1, 0x38($s2)
000FDC40 3C04002A lui        $a0, 0x2a
000FDC44 00053080 sll        $a2, $a1, 2
000FDC48 2484C15C addiu      $a0, $a0, -0x3ea4
000FDC4C 00C42021 addu       $a0, $a2, $a0
000FDC50 C48C0000 lwc1       $f12, ($a0)
000FDC54 24A50001 addiu      $a1, $a1, 1
000FDC58 0C03F842 jal        0xfe108
000FDC5C 02002025 move       $a0, $s0
000FDC60 02002025 move       $a0, $s0
000FDC64 0C0192FF jal        0x64bfc
000FDC68 34050001 ori        $a1, $zero, 1
000FDC6C 1000011E b          0xfe0e8
000FDC70 00000000 nop        
000FDC74 C60C0034 lwc1       $f12, 0x34($s0)
000FDC78 C7AD00C0 lwc1       $f13, 0xc0($sp)
000FDC7C 3C05002A lui        $a1, 0x2a
000FDC80 460D6301 sub.s      $f12, $f12, $f13
000FDC84 00042080 sll        $a0, $a0, 2
000FDC88 24A5C15C addiu      $a1, $a1, -0x3ea4
000FDC8C 00852021 addu       $a0, $a0, $a1
000FDC90 C48D0000 lwc1       $f13, ($a0)
000FDC94 0C03F424 jal        0xfd090
000FDC98 02002025 move       $a0, $s0
000FDC9C 10000112 b          0xfe0e8
000FDCA0 00000000 nop        
000FDCA4 C48CC22C lwc1       $f12, -0x3dd4($a0)
000FDCA8 3C04002A lui        $a0, 0x2a
000FDCAC E7AC00C4 swc1       $f12, 0xc4($sp)
000FDCB0 C48C9B10 lwc1       $f12, -0x64f0($a0)
000FDCB4 AFA000DC sw         $zero, 0xdc($sp)
000FDCB8 24849B10 addiu      $a0, $a0, -0x64f0
000FDCBC 46006307 neg.s      $f12, $f12
000FDCC0 C48D0004 lwc1       $f13, 4($a0)
000FDCC4 E7AC00E0 swc1       $f12, 0xe0($sp)
000FDCC8 C48C0008 lwc1       $f12, 8($a0)
000FDCCC 46006B47 neg.s      $f13, $f13
000FDCD0 E7AD00E4 swc1       $f13, 0xe4($sp)
000FDCD4 46006307 neg.s      $f12, $f12
000FDCD8 3C0B4120 lui        $t3, 0x4120
000FDCDC E7AC00E8 swc1       $f12, 0xe8($sp)
000FDCE0 27A400C4 addiu      $a0, $sp, 0xc4
000FDCE4 448B6000 mtc1       $t3, $f12
000FDCE8 27A500C8 addiu      $a1, $sp, 0xc8
000FDCEC 26060030 addiu      $a2, $s0, 0x30
000FDCF0 27A700E0 addiu      $a3, $sp, 0xe0
000FDCF4 34080028 ori        $t0, $zero, 0x28
000FDCF8 00004825 move       $t1, $zero
000FDCFC 0C00654F jal        0x1953c
000FDD00 00005025 move       $t2, $zero
000FDD04 10400048 beqz       $v0, 0xfde28
000FDD08 00000000 nop        
000FDD0C 8FA400DC lw         $a0, 0xdc($sp)
000FDD10 10800045 beqz       $a0, 0xfde28
000FDD14 00000000 nop        
000FDD18 C7AC00C4 lwc1       $f12, 0xc4($sp)
000FDD1C 3C04002A lui        $a0, 0x2a
000FDD20 C48DC22C lwc1       $f13, -0x3dd4($a0)
000FDD24 460D603E c.le.s     $f12, $f13
000FDD28 00000000 nop        
000FDD2C 45010004 bc1t       0xfdd40
000FDD30 27A400C4 addiu      $a0, $sp, 0xc4
000FDD34 3C04002A lui        $a0, 0x2a
000FDD38 10000001 b          0xfdd40
000FDD3C 2484C22C addiu      $a0, $a0, -0x3dd4
000FDD40 C48C0000 lwc1       $f12, ($a0)
000FDD44 3C04002A lui        $a0, 0x2a
000FDD48 C48D9B10 lwc1       $f13, -0x64f0($a0)
000FDD4C 46006307 neg.s      $f12, $f12
000FDD50 24849B10 addiu      $a0, $a0, -0x64f0
000FDD54 C60E0030 lwc1       $f14, 0x30($s0)
000FDD58 460C6B42 mul.s      $f13, $f13, $f12
000FDD5C C48F0004 lwc1       $f15, 4($a0)
000FDD60 C6100034 lwc1       $f16, 0x34($s0)
000FDD64 460C7BC2 mul.s      $f15, $f15, $f12
000FDD68 C4910008 lwc1       $f17, 8($a0)
000FDD6C 460D7340 add.s      $f13, $f14, $f13
000FDD70 C6120038 lwc1       $f18, 0x38($s0)
000FDD74 3C04002A lui        $a0, 0x2a
000FDD78 C493C150 lwc1       $f19, -0x3eb0($a0)
000FDD7C 460C8B02 mul.s      $f12, $f17, $f12
000FDD80 C7A00054 lwc1       $f0, 0x54($sp)
000FDD84 460F83C0 add.s      $f15, $f16, $f15
000FDD88 E7AD00EC swc1       $f13, 0xec($sp)
000FDD8C 46009B87 neg.s      $f14, $f19
000FDD90 460E0002 mul.s      $f0, $f0, $f14
000FDD94 C7B10058 lwc1       $f17, 0x58($sp)
000FDD98 460C9300 add.s      $f12, $f18, $f12
000FDD9C C7A2005C lwc1       $f2, 0x5c($sp)
000FDDA0 460E8C02 mul.s      $f16, $f17, $f14
000FDDA4 E7AF00F0 swc1       $f15, 0xf0($sp)
000FDDA8 46006B40 add.s      $f13, $f13, $f0
000FDDAC 27A400EC addiu      $a0, $sp, 0xec
000FDDB0 E7AC00F4 swc1       $f12, 0xf4($sp)
000FDDB4 460E1382 mul.s      $f14, $f2, $f14
000FDDB8 34050129 ori        $a1, $zero, 0x129
000FDDBC 46107BC0 add.s      $f15, $f15, $f16
000FDDC0 E7AD00EC swc1       $f13, 0xec($sp)
000FDDC4 34060101 ori        $a2, $zero, 0x101
000FDDC8 34070022 ori        $a3, $zero, 0x22
000FDDCC 460E6380 add.s      $f14, $f12, $f14
000FDDD0 34080001 ori        $t0, $zero, 1
000FDDD4 E7AF00F0 swc1       $f15, 0xf0($sp)
000FDDD8 46009B06 mov.s      $f12, $f19
000FDDDC 0C0054E4 jal        0x15390
000FDDE0 E7AE00F4 swc1       $f14, 0xf4($sp)
000FDDE4 00402025 move       $a0, $v0
000FDDE8 1080000F beqz       $a0, 0xfde28
000FDDEC 00000000 nop        
000FDDF0 8E650594 lw         $a1, 0x594($s3)
000FDDF4 1085000C beq        $a0, $a1, 0xfde28
000FDDF8 00000000 nop        
000FDDFC 8E450038 lw         $a1, 0x38($s2)
000FDE00 C48C0034 lwc1       $f12, 0x34($a0)
000FDE04 00052080 sll        $a0, $a1, 2
000FDE08 3C05002A lui        $a1, 0x2a
000FDE0C 24A5C15C addiu      $a1, $a1, -0x3ea4
000FDE10 00852021 addu       $a0, $a0, $a1
000FDE14 C48D0000 lwc1       $f13, ($a0)
000FDE18 0C03F424 jal        0xfd090
000FDE1C 02002025 move       $a0, $s0
000FDE20 100000B1 b          0xfe0e8
000FDE24 00000000 nop        
000FDE28 27A40064 addiu      $a0, $sp, 0x64
000FDE2C 4600A306 mov.s      $f12, $f20
000FDE30 27A50068 addiu      $a1, $sp, 0x68
000FDE34 27A60044 addiu      $a2, $sp, 0x44
000FDE38 27A70054 addiu      $a3, $sp, 0x54
000FDE3C 34080028 ori        $t0, $zero, 0x28
000FDE40 00004825 move       $t1, $zero
000FDE44 0C00654F jal        0x1953c
000FDE48 00005025 move       $t2, $zero
000FDE4C 10400033 beqz       $v0, 0xfdf1c
000FDE50 00000000 nop        
000FDE54 8FA4007C lw         $a0, 0x7c($sp)
000FDE58 34050002 ori        $a1, $zero, 2
000FDE5C 14850005 bne        $a0, $a1, 0xfde74
000FDE60 00000000 nop        
000FDE64 8FA40078 lw         $a0, 0x78($sp)
000FDE68 8E650594 lw         $a1, 0x594($s3)
000FDE6C 1085002B beq        $a0, $a1, 0xfdf1c
000FDE70 00000000 nop        
000FDE74 C7AC0064 lwc1       $f12, 0x64($sp)
000FDE78 3C043DE1 lui        $a0, 0x3de1
000FDE7C 46146302 mul.s      $f12, $f12, $f20
000FDE80 348447AE ori        $a0, $a0, 0x47ae
000FDE84 44846800 mtc1       $a0, $f13
000FDE88 460D603E c.le.s     $f12, $f13
000FDE8C 00000000 nop        
000FDE90 45010005 bc1t       0xfdea8
000FDE94 00000000 nop        
000FDE98 3C043DCC lui        $a0, 0x3dcc
000FDE9C 3484CCCD ori        $a0, $a0, 0xcccd
000FDEA0 44846800 mtc1       $a0, $f13
000FDEA4 460D6301 sub.s      $f12, $f12, $f13
000FDEA8 46146303 div.s      $f12, $f12, $f20
000FDEAC C7AD0054 lwc1       $f13, 0x54($sp)
000FDEB0 C7AE0058 lwc1       $f14, 0x58($sp)
000FDEB4 C7AF005C lwc1       $f15, 0x5c($sp)
000FDEB8 C7B00044 lwc1       $f16, 0x44($sp)
000FDEBC C7B10048 lwc1       $f17, 0x48($sp)
000FDEC0 C7B2004C lwc1       $f18, 0x4c($sp)
000FDEC4 3C04002A lui        $a0, 0x2a
000FDEC8 2485C15C addiu      $a1, $a0, -0x3ea4
000FDECC 02002025 move       $a0, $s0
000FDED0 460D6342 mul.s      $f13, $f12, $f13
000FDED4 460E6382 mul.s      $f14, $f12, $f14
000FDED8 460F63C2 mul.s      $f15, $f12, $f15
000FDEDC E7AD00F8 swc1       $f13, 0xf8($sp)
000FDEE0 460D8340 add.s      $f13, $f16, $f13
000FDEE4 E7AE00FC swc1       $f14, 0xfc($sp)
000FDEE8 460E8B00 add.s      $f12, $f17, $f14
000FDEEC E7AF0100 swc1       $f15, 0x100($sp)
000FDEF0 460F93C0 add.s      $f15, $f18, $f15
000FDEF4 E60D0030 swc1       $f13, 0x30($s0)
000FDEF8 E60C0034 swc1       $f12, 0x34($s0)
000FDEFC E60F0038 swc1       $f15, 0x38($s0)
000FDF00 8E460038 lw         $a2, 0x38($s2)
000FDF04 00063080 sll        $a2, $a2, 2
000FDF08 00C52821 addu       $a1, $a2, $a1
000FDF0C 0C03F424 jal        0xfd090
000FDF10 C4AD0000 lwc1       $f13, ($a1)
000FDF14 10000074 b          0xfe0e8
000FDF18 00000000 nop        
000FDF1C C64C0034 lwc1       $f12, 0x34($s2)
000FDF20 44806800 mtc1       $zero, $f13
000FDF24 460D6032 c.eq.s     $f12, $f13
000FDF28 00000000 nop        
000FDF2C 4501005E bc1t       0xfe0a8
000FDF30 00000000 nop        
000FDF34 C60C0034 lwc1       $f12, 0x34($s0)
000FDF38 C60D0030 lwc1       $f13, 0x30($s0)
000FDF3C 3C04002A lui        $a0, 0x2a
000FDF40 E7AD0108 swc1       $f13, 0x108($sp)
000FDF44 C60D0038 lwc1       $f13, 0x38($s0)
000FDF48 C48EC22C lwc1       $f14, -0x3dd4($a0)
000FDF4C E7AC010C swc1       $f12, 0x10c($sp)
000FDF50 460E6301 sub.s      $f12, $f12, $f14
000FDF54 C60F003C lwc1       $f15, 0x3c($s0)
000FDF58 E7AD0110 swc1       $f13, 0x110($sp)
000FDF5C E7AF0114 swc1       $f15, 0x114($sp)
000FDF60 341300FF ori        $s3, $zero, 0xff
000FDF64 0C060057 jal        0x18015c
000FDF68 E7AC010C swc1       $f12, 0x10c($sp)
000FDF6C 340400BF ori        $a0, $zero, 0xbf
000FDF70 0044001A div        $zero, $v0, $a0
000FDF74 34070003 ori        $a3, $zero, 3
000FDF78 AFA70000 sw         $a3, ($sp)
000FDF7C 3C07002A lui        $a3, 0x2a
000FDF80 3408000C ori        $t0, $zero, 0xc
000FDF84 C4ECC230 lwc1       $f12, -0x3dd0($a3)
000FDF88 AFA80004 sw         $t0, 4($sp)
000FDF8C 3C073FC0 lui        $a3, 0x3fc0
000FDF90 34E700FA ori        $a3, $a3, 0xfa
000FDF94 44876800 mtc1       $a3, $f13
000FDF98 AFA00008 sw         $zero, 8($sp)
000FDF9C 3C07002A lui        $a3, 0x2a
000FDFA0 26050030 addiu      $a1, $s0, 0x30
000FDFA4 27A60108 addiu      $a2, $sp, 0x108
000FDFA8 34040001 ori        $a0, $zero, 1
000FDFAC 02604825 move       $t1, $s3
000FDFB0 340A0001 ori        $t2, $zero, 1
000FDFB4 340B0001 ori        $t3, $zero, 1
000FDFB8 AFA0000C sw         $zero, 0xc($sp)
000FDFBC 24E79B00 addiu      $a3, $a3, -0x6500
000FDFC0 00004010 mfhi       $t0
000FDFC4 25080040 addiu      $t0, $t0, 0x40
000FDFC8 00084600 sll        $t0, $t0, 0x18
000FDFCC 0C030A79 jal        0xc29e4
000FDFD0 01134025 or         $t0, $t0, $s3
000FDFD4 00402025 move       $a0, $v0
000FDFD8 10800006 beqz       $a0, 0xfdff4
000FDFDC 3C05002A lui        $a1, 0x2a
000FDFE0 C4ACC230 lwc1       $f12, -0x3dd0($a1)
000FDFE4 3C054120 lui        $a1, 0x4120
000FDFE8 44856800 mtc1       $a1, $f13
000FDFEC 460D6302 mul.s      $f12, $f12, $f13
000FDFF0 E48C002C swc1       $f12, 0x2c($a0)
000FDFF4 3C05002A lui        $a1, 0x2a
000FDFF8 00112080 sll        $a0, $s1, 2
000FDFFC 24A5C194 addiu      $a1, $a1, -0x3e6c
000FE000 00852021 addu       $a0, $a0, $a1
000FE004 0C060057 jal        0x18015c
000FE008 8C910000 lw         $s1, ($a0)
000FE00C 34040003 ori        $a0, $zero, 3
000FE010 0044001A div        $zero, $v0, $a0
000FE014 00002010 mfhi       $a0
000FE018 14800003 bnez       $a0, 0xfe028
000FE01C 34070001 ori        $a3, $zero, 1
000FE020 3C113081 lui        $s1, 0x3081
000FE024 263180FF addiu      $s1, $s1, -0x7f01
000FE028 AFA70000 sw         $a3, ($sp)
000FE02C 3C07002A lui        $a3, 0x2a
000FE030 C4ECC234 lwc1       $f12, -0x3dcc($a3)
000FE034 3C073FC0 lui        $a3, 0x3fc0
000FE038 3409000C ori        $t1, $zero, 0xc
000FE03C 34E700FA ori        $a3, $a3, 0xfa
000FE040 AFA90004 sw         $t1, 4($sp)
000FE044 44876800 mtc1       $a3, $f13
000FE048 AFA00008 sw         $zero, 8($sp)
000FE04C 3C07002A lui        $a3, 0x2a
000FE050 3C090081 lui        $t1, 0x81
000FE054 26050030 addiu      $a1, $s0, 0x30
000FE058 27A60108 addiu      $a2, $sp, 0x108
000FE05C 00002025 move       $a0, $zero
000FE060 02204025 move       $t0, $s1
000FE064 340A0001 ori        $t2, $zero, 1
000FE068 340B0001 ori        $t3, $zero, 1
000FE06C AFA0000C sw         $zero, 0xc($sp)
000FE070 24E79B00 addiu      $a3, $a3, -0x6500
000FE074 0C030A79 jal        0xc29e4
000FE078 252980FF addiu      $t1, $t1, -0x7f01
000FE07C 00402025 move       $a0, $v0
000FE080 10800006 beqz       $a0, 0xfe09c
000FE084 3C05002A lui        $a1, 0x2a
000FE088 C4ACC234 lwc1       $f12, -0x3dcc($a1)
000FE08C 3C054120 lui        $a1, 0x4120
000FE090 44856800 mtc1       $a1, $f13
000FE094 460D6302 mul.s      $f12, $f12, $f13
000FE098 E48C002C swc1       $f12, 0x2c($a0)
000FE09C 3C04002A lui        $a0, 0x2a
000FE0A0 C48CC220 lwc1       $f12, -0x3de0($a0)
000FE0A4 E64C0034 swc1       $f12, 0x34($s2)
000FE0A8 27B10080 addiu      $s1, $sp, 0x80
000FE0AC C64C0004 lwc1       $f12, 4($s2)
000FE0B0 26450020 addiu      $a1, $s2, 0x20
000FE0B4 0C03ABAB jal        0xeaeac
000FE0B8 02202025 move       $a0, $s1
000FE0BC 02002025 move       $a0, $s0
000FE0C0 02202825 move       $a1, $s1
000FE0C4 0C03B8E1 jal        0xee384
000FE0C8 02003025 move       $a2, $s0
000FE0CC 44806000 mtc1       $zero, $f12
000FE0D0 3C043F80 lui        $a0, 0x3f80
000FE0D4 E60C001C swc1       $f12, 0x1c($s0)
000FE0D8 44846800 mtc1       $a0, $f13
000FE0DC E60C000C swc1       $f12, 0xc($s0)
000FE0E0 E60C002C swc1       $f12, 0x2c($s0)
000FE0E4 E60D003C swc1       $f13, 0x3c($s0)
000FE0E8 C7B40118 lwc1       $f20, 0x118($sp)
000FE0EC 8FB0011C lw         $s0, 0x11c($sp)
000FE0F0 8FB10120 lw         $s1, 0x120($sp)
000FE0F4 8FB20124 lw         $s2, 0x124($sp)
000FE0F8 8FB30128 lw         $s3, 0x128($sp)
000FE0FC 8FBF012C lw         $ra, 0x12c($sp)
000FE100 03E00008 jr         $ra
000FE104 27BD0130 addiu      $sp, $sp, 0x130