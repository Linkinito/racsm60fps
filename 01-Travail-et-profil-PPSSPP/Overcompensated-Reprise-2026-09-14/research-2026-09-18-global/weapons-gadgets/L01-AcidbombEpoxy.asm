
CALLBACK 0x00108978 end 0x00108980 ordinal 0

00108978 03E00008 jr         $ra
0010897C 34020001 ori        $v0, $zero, 1

CALLBACK 0x00108980 end 0x00108A08 ordinal 1

00108980 27BDFFD0 addiu      $sp, $sp, -0x30
00108984 8C850058 lw         $a1, 0x58($a0)
00108988 8CA70004 lw         $a3, 4($a1)
0010898C AFBF0020 sw         $ra, 0x20($sp)
00108990 10E0001A beqz       $a3, 0x1089fc
00108994 00000000 nop        
00108998 8CE60040 lw         $a2, 0x40($a3)
0010899C 8CC60020 lw         $a2, 0x20($a2)
001089A0 10C00016 beqz       $a2, 0x1089fc
001089A4 3C08002D lui        $t0, 0x2d
001089A8 2509B0CC addiu      $t1, $t0, -0x4f34
001089AC 25290140 addiu      $t1, $t1, 0x140
001089B0 8D280000 lw         $t0, ($t1)
001089B4 290A0002 slti       $t2, $t0, 2
001089B8 15400007 bnez       $t2, 0x1089d8
001089BC C52C0004 lwc1       $f12, 4($t1)
001089C0 29080003 slti       $t0, $t0, 3
001089C4 11000004 beqz       $t0, 0x1089d8
001089C8 3C083F00 lui        $t0, 0x3f00
001089CC 44886800 mtc1       $t0, $f13
001089D0 10000001 b          0x1089d8
001089D4 460D6302 mul.s      $f12, $f12, $f13
001089D8 24A8000C addiu      $t0, $a1, 0xc
001089DC 00C05025 move       $t2, $a2
001089E0 00805825 move       $t3, $a0
001089E4 8D250008 lw         $a1, 8($t1)
001089E8 8D26000C lw         $a2, 0xc($t1)
001089EC 00E02025 move       $a0, $a3
001089F0 25670030 addiu      $a3, $t3, 0x30
001089F4 0140F809 jalr       $t2
001089F8 01604825 move       $t1, $t3
001089FC 8FBF0020 lw         $ra, 0x20($sp)
00108A00 03E00008 jr         $ra
00108A04 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x00108A08 end 0x00108BB0 ordinal 2

00108A08 27BDFFD0 addiu      $sp, $sp, -0x30
00108A0C AFB00020 sw         $s0, 0x20($sp)
00108A10 00808025 move       $s0, $a0
00108A14 8E040058 lw         $a0, 0x58($s0)
00108A18 8C850004 lw         $a1, 4($a0)
00108A1C AFBF0024 sw         $ra, 0x24($sp)
00108A20 10A0000B beqz       $a1, 0x108a50
00108A24 00000000 nop        
00108A28 8CA60064 lw         $a2, 0x64($a1)
00108A2C 30C70006 andi       $a3, $a2, 6
00108A30 14E00005 bnez       $a3, 0x108a48
00108A34 30C70008 andi       $a3, $a2, 8
00108A38 14E00003 bnez       $a3, 0x108a48
00108A3C 30C60001 andi       $a2, $a2, 1
00108A40 14C00003 bnez       $a2, 0x108a50
00108A44 00000000 nop        
00108A48 AC800004 sw         $zero, 4($a0)
00108A4C 00002825 move       $a1, $zero
00108A50 10A00012 beqz       $a1, 0x108a9c
00108A54 00000000 nop        
00108A58 8C860008 lw         $a2, 8($a0)
00108A5C 10C0000F beqz       $a2, 0x108a9c
00108A60 00000000 nop        
00108A64 8CC60064 lw         $a2, 0x64($a2)
00108A68 30C70006 andi       $a3, $a2, 6
00108A6C 14E0000B bnez       $a3, 0x108a9c
00108A70 30C70008 andi       $a3, $a2, 8
00108A74 14E00009 bnez       $a3, 0x108a9c
00108A78 30C60001 andi       $a2, $a2, 1
00108A7C 10C00007 beqz       $a2, 0x108a9c
00108A80 00000000 nop        
00108A84 8CA60040 lw         $a2, 0x40($a1)
00108A88 8CC60020 lw         $a2, 0x20($a2)
00108A8C 14C00008 bnez       $a2, 0x108ab0
00108A90 3C07002D lui        $a3, 0x2d
00108A94 1000001D b          0x108b0c
00108A98 2404FFFF addiu      $a0, $zero, -1
00108A9C 02002025 move       $a0, $s0
00108AA0 0C01A8F0 jal        0x6a3c0
00108AA4 34050001 ori        $a1, $zero, 1
00108AA8 1000001E b          0x108b24
00108AAC 00000000 nop        
00108AB0 24E7B0CC addiu      $a3, $a3, -0x4f34
00108AB4 24E70130 addiu      $a3, $a3, 0x130
00108AB8 8CE80000 lw         $t0, ($a3)
00108ABC 29090002 slti       $t1, $t0, 2
00108AC0 15200007 bnez       $t1, 0x108ae0
00108AC4 C4EC0004 lwc1       $f12, 4($a3)
00108AC8 29080003 slti       $t0, $t0, 3
00108ACC 11000004 beqz       $t0, 0x108ae0
00108AD0 3C083F00 lui        $t0, 0x3f00
00108AD4 44886800 mtc1       $t0, $f13
00108AD8 10000001 b          0x108ae0
00108ADC 460D6302 mul.s      $f12, $f12, $f13
00108AE0 00C05025 move       $t2, $a2
00108AE4 8CE60008 lw         $a2, 8($a3)
00108AE8 2488000C addiu      $t0, $a0, 0xc
00108AEC 8CE9000C lw         $t1, 0xc($a3)
00108AF0 00A02025 move       $a0, $a1
00108AF4 00C02825 move       $a1, $a2
00108AF8 01203025 move       $a2, $t1
00108AFC 26070030 addiu      $a3, $s0, 0x30
00108B00 0140F809 jalr       $t2
00108B04 02004825 move       $t1, $s0
00108B08 00402025 move       $a0, $v0
00108B0C 34050003 ori        $a1, $zero, 3
00108B10 14850004 bne        $a0, $a1, 0x108b24
00108B14 00000000 nop        
00108B18 02002025 move       $a0, $s0
00108B1C 0C01A8F0 jal        0x6a3c0
00108B20 34050001 ori        $a1, $zero, 1
00108B24 8FB00020 lw         $s0, 0x20($sp)
00108B28 8FBF0024 lw         $ra, 0x24($sp)
00108B2C 03E00008 jr         $ra
00108B30 27BD0030 addiu      $sp, $sp, 0x30
00108B34 3C05002D lui        $a1, 0x2d
00108B38 8CA5A0D0 lw         $a1, -0x5f30($a1)
00108B3C 8CA80038 lw         $t0, 0x38($a1)
00108B40 34090000 ori        $t1, $zero, 0
00108B44 0128202B sltu       $a0, $t1, $t0
00108B48 1080000F beqz       $a0, 0x108b88
00108B4C 00000000 nop        
00108B50 8CA50034 lw         $a1, 0x34($a1)
00108B54 3C06355F lui        $a2, 0x355f
00108B58 34040000 ori        $a0, $zero, 0
00108B5C 00A03825 move       $a3, $a1
00108B60 24C68368 addiu      $a2, $a2, -0x7c98
00108B64 8CEA0030 lw         $t2, 0x30($a3)
00108B68 15460003 bne        $t2, $a2, 0x108b78
00108B6C 25290001 addiu      $t1, $t1, 1
00108B70 10000006 b          0x108b8c
00108B74 00A42821 addu       $a1, $a1, $a0
00108B78 24840050 addiu      $a0, $a0, 0x50
00108B7C 0128502B sltu       $t2, $t1, $t0
00108B80 1540FFF8 bnez       $t2, 0x108b64
00108B84 24E70050 addiu      $a3, $a3, 0x50
00108B88 34050000 ori        $a1, $zero, 0
00108B8C 8CA4000C lw         $a0, 0xc($a1)
00108B90 8CA5003C lw         $a1, 0x3c($a1)
00108B94 3C06002D lui        $a2, 0x2d
00108B98 ACC4CD10 sw         $a0, -0x32f0($a2)
00108B9C 000529C0 sll        $a1, $a1, 7
00108BA0 00852021 addu       $a0, $a0, $a1
00108BA4 3C05002D lui        $a1, 0x2d
00108BA8 03E00008 jr         $ra
00108BAC ACA4CD14 sw         $a0, -0x32ec($a1)