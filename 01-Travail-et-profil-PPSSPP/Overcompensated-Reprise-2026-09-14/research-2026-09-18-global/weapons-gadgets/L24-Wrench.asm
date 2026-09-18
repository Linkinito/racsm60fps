
CALLBACK 0x0015F318 end 0x0015F3EC ordinal 0

0015F318 27BDFFD0 addiu      $sp, $sp, -0x30
0015F31C AFB00020 sw         $s0, 0x20($sp)
0015F320 00808025 move       $s0, $a0
0015F324 AFB10024 sw         $s1, 0x24($sp)
0015F328 AFBF0028 sw         $ra, 0x28($sp)
0015F32C 8E110058 lw         $s1, 0x58($s0)
0015F330 00002825 move       $a1, $zero
0015F334 02202025 move       $a0, $s1
0015F338 0C0600AC jal        0x1802b0
0015F33C 34060104 ori        $a2, $zero, 0x104
0015F340 AE200000 sw         $zero, ($s1)
0015F344 0C03D60B jal        0xf582c
0015F348 26240004 addiu      $a0, $s1, 4
0015F34C 8E040048 lw         $a0, 0x48($s0)
0015F350 3C050016 lui        $a1, 0x16
0015F354 24A50308 addiu      $a1, $a1, 0x308
0015F358 AC8500DC sw         $a1, 0xdc($a0)
0015F35C A2000046 sb         $zero, 0x46($s0)
0015F360 A22000FC sb         $zero, 0xfc($s1)
0015F364 AE2000F8 sw         $zero, 0xf8($s1)
0015F368 34050000 ori        $a1, $zero, 0
0015F36C 02202025 move       $a0, $s1
0015F370 AC8000E0 sw         $zero, 0xe0($a0)
0015F374 24A50001 addiu      $a1, $a1, 1
0015F378 2CA60006 sltiu      $a2, $a1, 6
0015F37C 14C0FFFC bnez       $a2, 0x15f370
0015F380 24840004 addiu      $a0, $a0, 4
0015F384 3C040028 lui        $a0, 0x28
0015F388 8C84F8D8 lw         $a0, -0x728($a0)
0015F38C 3C05002A lui        $a1, 0x2a
0015F390 C4AC5148 lwc1       $f12, 0x5148($a1)
0015F394 3C05002A lui        $a1, 0x2a
0015F398 C4AD514C lwc1       $f13, 0x514c($a1)
0015F39C 3C05002A lui        $a1, 0x2a
0015F3A0 3C06002A lui        $a2, 0x2a
0015F3A4 3C084120 lui        $t0, 0x4120
0015F3A8 00003825 move       $a3, $zero
0015F3AC 44887000 mtc1       $t0, $f14
0015F3B0 24A5513C addiu      $a1, $a1, 0x513c
0015F3B4 0C01569F jal        0x55a7c
0015F3B8 24C69AE4 addiu      $a2, $a2, -0x651c
0015F3BC 8E040064 lw         $a0, 0x64($s0)
0015F3C0 3C050004 lui        $a1, 4
0015F3C4 00852025 or         $a0, $a0, $a1
0015F3C8 AE040064 sw         $a0, 0x64($s0)
0015F3CC A2200102 sb         $zero, 0x102($s1)
0015F3D0 A2200103 sb         $zero, 0x103($s1)
0015F3D4 34020001 ori        $v0, $zero, 1
0015F3D8 8FB00020 lw         $s0, 0x20($sp)
0015F3DC 8FB10024 lw         $s1, 0x24($sp)
0015F3E0 8FBF0028 lw         $ra, 0x28($sp)
0015F3E4 03E00008 jr         $ra
0015F3E8 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x0015F3EC end 0x0015F43C ordinal 1

0015F3EC 27BDFFE0 addiu      $sp, $sp, -0x20
0015F3F0 AFB00014 sw         $s0, 0x14($sp)
0015F3F4 00808025 move       $s0, $a0
0015F3F8 8E050058 lw         $a1, 0x58($s0)
0015F3FC 8CA400F8 lw         $a0, 0xf8($a1)
0015F400 AFBF0018 sw         $ra, 0x18($sp)
0015F404 10800005 beqz       $a0, 0x15f41c
0015F408 00000000 nop        
0015F40C 0C019BAB jal        0x66eac
0015F410 AFA50010 sw         $a1, 0x10($sp)
0015F414 8FA40010 lw         $a0, 0x10($sp)
0015F418 AC8000F8 sw         $zero, 0xf8($a0)
0015F41C 0C0594AA jal        0x1652a8
0015F420 00000000 nop        
0015F424 0C057D6B jal        0x15f5ac
0015F428 02002025 move       $a0, $s0
0015F42C 8FB00014 lw         $s0, 0x14($sp)
0015F430 8FBF0018 lw         $ra, 0x18($sp)
0015F434 03E00008 jr         $ra
0015F438 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0015F828 end 0x0015FB0C ordinal 2

0015F828 27BDFFD0 addiu      $sp, $sp, -0x30
0015F82C AFB00020 sw         $s0, 0x20($sp)
0015F830 00808025 move       $s0, $a0
0015F834 AFB10024 sw         $s1, 0x24($sp)
0015F838 8E110058 lw         $s1, 0x58($s0)
0015F83C 8E240000 lw         $a0, ($s1)
0015F840 A22000FE sb         $zero, 0xfe($s1)
0015F844 848500F8 lh         $a1, 0xf8($a0)
0015F848 92260100 lbu        $a2, 0x100($s1)
0015F84C AFBF0028 sw         $ra, 0x28($sp)
0015F850 54A60006 bnel       $a1, $a2, 0x15f86c
0015F854 8C87095C lw         $a3, 0x95c($a0)
0015F858 94870100 lhu        $a3, 0x100($a0)
0015F85C 92280101 lbu        $t0, 0x101($s1)
0015F860 10E8001F beq        $a3, $t0, 0x15f8e0
0015F864 00000000 nop        
0015F868 8C87095C lw         $a3, 0x95c($a0)
0015F86C 30E70800 andi       $a3, $a3, 0x800
0015F870 14E0001B bnez       $a3, 0x15f8e0
0015F874 00000000 nop        
0015F878 34070011 ori        $a3, $zero, 0x11
0015F87C 14A70005 bne        $a1, $a3, 0x15f894
0015F880 34080012 ori        $t0, $zero, 0x12
0015F884 34080010 ori        $t0, $zero, 0x10
0015F888 10C80012 beq        $a2, $t0, 0x15f8d4
0015F88C 00000000 nop        
0015F890 34080012 ori        $t0, $zero, 0x12
0015F894 54A80004 bnel       $a1, $t0, 0x15f8a8
0015F898 34070013 ori        $a3, $zero, 0x13
0015F89C 10C7000D beq        $a2, $a3, 0x15f8d4
0015F8A0 00000000 nop        
0015F8A4 34070013 ori        $a3, $zero, 0x13
0015F8A8 14A70003 bne        $a1, $a3, 0x15f8b8
0015F8AC 00000000 nop        
0015F8B0 10C80008 beq        $a2, $t0, 0x15f8d4
0015F8B4 00000000 nop        
0015F8B8 A22000CA sb         $zero, 0xca($s1)
0015F8BC A22000CD sb         $zero, 0xcd($s1)
0015F8C0 A22000FD sb         $zero, 0xfd($s1)
0015F8C4 3C05002A lui        $a1, 0x2a
0015F8C8 A0A05084 sb         $zero, 0x5084($a1)
0015F8CC A22000FC sb         $zero, 0xfc($s1)
0015F8D0 848500F8 lh         $a1, 0xf8($a0)
0015F8D4 A2250100 sb         $a1, 0x100($s1)
0015F8D8 94850100 lhu        $a1, 0x100($a0)
0015F8DC A2250101 sb         $a1, 0x101($s1)
0015F8E0 8E2500DC lw         $a1, 0xdc($s1)
0015F8E4 24A5FFFF addiu      $a1, $a1, -1
0015F8E8 04A10002 bgez       $a1, 0x15f8f4
0015F8EC AE2500DC sw         $a1, 0xdc($s1)
0015F8F0 AE2000DC sw         $zero, 0xdc($s1)
0015F8F4 8C8605C8 lw         $a2, 0x5c8($a0)
0015F8F8 24C6FFFF addiu      $a2, $a2, -1
0015F8FC 2CC7000D sltiu      $a3, $a2, 0xd
0015F900 10E00014 beqz       $a3, 0x15f954
0015F904 34050000 ori        $a1, $zero, 0
0015F908 00063080 sll        $a2, $a2, 2
0015F90C 3C01001A lui        $at, 0x1a
0015F910 00260821 addu       $at, $at, $a2
0015F914 8C219C20 lw         $at, -0x63e0($at)
0015F918 00200008 jr         $at
0015F91C 00000000 nop        
0015F920 1000000C b          0x15f954
0015F924 34050001 ori        $a1, $zero, 1
0015F928 1000000A b          0x15f954
0015F92C 34050002 ori        $a1, $zero, 2
0015F930 10000008 b          0x15f954
0015F934 34050003 ori        $a1, $zero, 3
0015F938 10000006 b          0x15f954
0015F93C 34050004 ori        $a1, $zero, 4
0015F940 10000004 b          0x15f954
0015F944 34050005 ori        $a1, $zero, 5
0015F948 10000002 b          0x15f954
0015F94C 34050006 ori        $a1, $zero, 6
0015F950 34050007 ori        $a1, $zero, 7
0015F954 14A00005 bnez       $a1, 0x15f96c
0015F958 00000000 nop        
0015F95C 92260103 lbu        $a2, 0x103($s1)
0015F960 34070001 ori        $a3, $zero, 1
0015F964 10C7005C beq        $a2, $a3, 0x15fad8
0015F968 00000000 nop        
0015F96C 848600F8 lh         $a2, 0xf8($a0)
0015F970 24C6FFF7 addiu      $a2, $a2, -9
0015F974 2CC7002F sltiu      $a3, $a2, 0x2f
0015F978 10E00045 beqz       $a3, 0x15fa90
0015F97C 00000000 nop        
0015F980 00063080 sll        $a2, $a2, 2
0015F984 3C01001A lui        $at, 0x1a
0015F988 00260821 addu       $at, $at, $a2
0015F98C 8C219C58 lw         $at, -0x63a8($at)
0015F990 00200008 jr         $at
0015F994 00000000 nop        
0015F998 00A04025 move       $t0, $a1
0015F99C 8C860594 lw         $a2, 0x594($a0)
0015F9A0 262400C8 addiu      $a0, $s1, 0xc8
0015F9A4 02002825 move       $a1, $s0
0015F9A8 0C03D6A9 jal        0xf5aa4
0015F9AC 00003825 move       $a3, $zero
0015F9B0 10000049 b          0x15fad8
0015F9B4 00000000 nop        
0015F9B8 00A04025 move       $t0, $a1
0015F9BC 8C860594 lw         $a2, 0x594($a0)
0015F9C0 262400C8 addiu      $a0, $s1, 0xc8
0015F9C4 02002825 move       $a1, $s0
0015F9C8 0C03D6A9 jal        0xf5aa4
0015F9CC 34070001 ori        $a3, $zero, 1
0015F9D0 10000041 b          0x15fad8
0015F9D4 00000000 nop        
0015F9D8 00A04025 move       $t0, $a1
0015F9DC 8C860594 lw         $a2, 0x594($a0)
0015F9E0 262400C8 addiu      $a0, $s1, 0xc8
0015F9E4 02002825 move       $a1, $s0
0015F9E8 0C03D6A9 jal        0xf5aa4
0015F9EC 34070002 ori        $a3, $zero, 2
0015F9F0 10000039 b          0x15fad8
0015F9F4 00000000 nop        
0015F9F8 10000037 b          0x15fad8
0015F9FC 00000000 nop        
0015FA00 00A04025 move       $t0, $a1
0015FA04 8C860594 lw         $a2, 0x594($a0)
0015FA08 262400C8 addiu      $a0, $s1, 0xc8
0015FA0C 02002825 move       $a1, $s0
0015FA10 0C03D6A9 jal        0xf5aa4
0015FA14 34070003 ori        $a3, $zero, 3
0015FA18 1000002F b          0x15fad8
0015FA1C 00000000 nop        
0015FA20 1000002D b          0x15fad8
0015FA24 00000000 nop        
0015FA28 0C057D1E jal        0x15f478
0015FA2C 02002025 move       $a0, $s0
0015FA30 10000029 b          0x15fad8
0015FA34 00000000 nop        
0015FA38 94860100 lhu        $a2, 0x100($a0)
0015FA3C 34070006 ori        $a3, $zero, 6
0015FA40 14C70007 bne        $a2, $a3, 0x15fa60
0015FA44 00000000 nop        
0015FA48 00A04025 move       $t0, $a1
0015FA4C 8C860594 lw         $a2, 0x594($a0)
0015FA50 262400C8 addiu      $a0, $s1, 0xc8
0015FA54 02002825 move       $a1, $s0
0015FA58 0C03D6A9 jal        0xf5aa4
0015FA5C 00003825 move       $a3, $zero
0015FA60 1000001D b          0x15fad8
0015FA64 00000000 nop        
0015FA68 94860100 lhu        $a2, 0x100($a0)
0015FA6C 34070005 ori        $a3, $zero, 5
0015FA70 14C70007 bne        $a2, $a3, 0x15fa90
0015FA74 00000000 nop        
0015FA78 00A04025 move       $t0, $a1
0015FA7C 8C860594 lw         $a2, 0x594($a0)
0015FA80 262400C8 addiu      $a0, $s1, 0xc8
0015FA84 02002825 move       $a1, $s0
0015FA88 0C03D6A9 jal        0xf5aa4
0015FA8C 00003825 move       $a3, $zero
0015FA90 02002025 move       $a0, $s0
0015FA94 0C019491 jal        0x65244
0015FA98 00002825 move       $a1, $zero
0015FA9C 1040000E beqz       $v0, 0x15fad8
0015FAA0 00000000 nop        
0015FAA4 0C0195BC jal        0x656f0
0015FAA8 02002025 move       $a0, $s0
0015FAAC 1040000A beqz       $v0, 0x15fad8
0015FAB0 00000000 nop        
0015FAB4 3C083ECC lui        $t0, 0x3ecc
0015FAB8 44806800 mtc1       $zero, $f13
0015FABC 3508CCCD ori        $t0, $t0, 0xcccd
0015FAC0 02002025 move       $a0, $s0
0015FAC4 44886000 mtc1       $t0, $f12
0015FAC8 00002825 move       $a1, $zero
0015FACC 00003025 move       $a2, $zero
0015FAD0 0C01955C jal        0x65570
0015FAD4 34070001 ori        $a3, $zero, 1
0015FAD8 92040046 lbu        $a0, 0x46($s0)
0015FADC 10800003 beqz       $a0, 0x15faec
0015FAE0 00000000 nop        
0015FAE4 0C057EC3 jal        0x15fb0c
0015FAE8 02002025 move       $a0, $s0
0015FAEC 92240103 lbu        $a0, 0x103($s1)
0015FAF0 2C840001 sltiu      $a0, $a0, 1
0015FAF4 A2240103 sb         $a0, 0x103($s1)
0015FAF8 8FB00020 lw         $s0, 0x20($sp)
0015FAFC 8FB10024 lw         $s1, 0x24($sp)
0015FB00 8FBF0028 lw         $ra, 0x28($sp)
0015FB04 03E00008 jr         $ra
0015FB08 27BD0030 addiu      $sp, $sp, 0x30