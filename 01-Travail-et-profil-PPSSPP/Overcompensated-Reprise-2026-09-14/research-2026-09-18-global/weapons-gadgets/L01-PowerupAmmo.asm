
CALLBACK 0x0015FFC8 end 0x00160094 ordinal 0

0015FFC8 27BDFFD0 addiu      $sp, $sp, -0x30
0015FFCC AFB00020 sw         $s0, 0x20($sp)
0015FFD0 00808025 move       $s0, $a0
0015FFD4 A2000045 sb         $zero, 0x45($s0)
0015FFD8 34040003 ori        $a0, $zero, 3
0015FFDC 8E050058 lw         $a1, 0x58($s0)
0015FFE0 A2040046 sb         $a0, 0x46($s0)
0015FFE4 00A02025 move       $a0, $a1
0015FFE8 00002825 move       $a1, $zero
0015FFEC AFB10024 sw         $s1, 0x24($sp)
0015FFF0 AFBF0028 sw         $ra, 0x28($sp)
0015FFF4 0C06B6A7 jal        0x1ada9c
0015FFF8 34060004 ori        $a2, $zero, 4
0015FFFC 34040020 ori        $a0, $zero, 0x20
00160000 A2040077 sb         $a0, 0x77($s0)
00160004 A2040076 sb         $a0, 0x76($s0)
00160008 2404FFFF addiu      $a0, $zero, -1
0016000C AE040068 sw         $a0, 0x68($s0)
00160010 3C11002D lui        $s1, 0x2d
00160014 8E245E3C lw         $a0, 0x5e3c($s1)
00160018 14800018 bnez       $a0, 0x16007c
0016001C 34100001 ori        $s0, $zero, 1
00160020 3C04BD50 lui        $a0, 0xbd50
00160024 0C03E761 jal        0xf9d84
00160028 24846DCC addiu      $a0, $a0, 0x6dcc
0016002C AE225E3C sw         $v0, 0x5e3c($s1)
00160030 3C11002D lui        $s1, 0x2d
00160034 92245EBD lbu        $a0, 0x5ebd($s1)
00160038 00442025 or         $a0, $v0, $a0
0016003C 1480000F bnez       $a0, 0x16007c
00160040 00000000 nop        
00160044 3C05002D lui        $a1, 0x2d
00160048 3C06001D lui        $a2, 0x1d
0016004C 3C08001D lui        $t0, 0x1d
00160050 34040001 ori        $a0, $zero, 1
00160054 340700AD ori        $a3, $zero, 0xad
00160058 24A55EAC addiu      $a1, $a1, 0x5eac
0016005C 24C68834 addiu      $a2, $a2, -0x77cc
00160060 0C03B04D jal        0xec134
00160064 25088870 addiu      $t0, $t0, -0x7790
00160068 3C04001D lui        $a0, 0x1d
0016006C 0C03B058 jal        0xec160
00160070 24848874 addiu      $a0, $a0, -0x778c
00160074 34040001 ori        $a0, $zero, 1
00160078 A2245EBD sb         $a0, 0x5ebd($s1)
0016007C 02001025 move       $v0, $s0
00160080 8FB00020 lw         $s0, 0x20($sp)
00160084 8FB10024 lw         $s1, 0x24($sp)
00160088 8FBF0028 lw         $ra, 0x28($sp)
0016008C 03E00008 jr         $ra
00160090 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x00160094 end 0x0016009C ordinal 1

00160094 03E00008 jr         $ra
00160098 00000000 nop        

CALLBACK 0x0016009C end 0x0016013C ordinal 2

0016009C 27BDFFE0 addiu      $sp, $sp, -0x20
001600A0 90850045 lbu        $a1, 0x45($a0)
001600A4 AFBF0010 sw         $ra, 0x10($sp)
001600A8 2CA60005 sltiu      $a2, $a1, 5
001600AC 10C00020 beqz       $a2, 0x160130
001600B0 00000000 nop        
001600B4 24010001 addiu      $at, $zero, 1
001600B8 10A10013 beq        $a1, $at, 0x160108
001600BC 24010002 addiu      $at, $zero, 2
001600C0 10A1000D beq        $a1, $at, 0x1600f8
001600C4 24010003 addiu      $at, $zero, 3
001600C8 10A10017 beq        $a1, $at, 0x160128
001600CC 24010004 addiu      $at, $zero, 4
001600D0 10A10011 beq        $a1, $at, 0x160118
001600D4 00000000 nop        
001600D8 3C05002D lui        $a1, 0x2d
001600DC 8CA65DF0 lw         $a2, 0x5df0($a1)
001600E0 24C60001 addiu      $a2, $a2, 1
001600E4 ACA65DF0 sw         $a2, 0x5df0($a1)
001600E8 0C058262 jal        0x160988
001600EC 34050001 ori        $a1, $zero, 1
001600F0 1000000F b          0x160130
001600F4 00000000 nop        
001600F8 0C058096 jal        0x160258
001600FC 00000000 nop        
00160100 1000000B b          0x160130
00160104 00000000 nop        
00160108 0C05804F jal        0x16013c
0016010C 00000000 nop        
00160110 10000007 b          0x160130
00160114 00000000 nop        
00160118 0C05809D jal        0x160274
0016011C 00000000 nop        
00160120 10000003 b          0x160130
00160124 00000000 nop        
00160128 0C0580AB jal        0x1602ac
0016012C 00000000 nop        
00160130 8FBF0010 lw         $ra, 0x10($sp)
00160134 03E00008 jr         $ra
00160138 27BD0020 addiu      $sp, $sp, 0x20