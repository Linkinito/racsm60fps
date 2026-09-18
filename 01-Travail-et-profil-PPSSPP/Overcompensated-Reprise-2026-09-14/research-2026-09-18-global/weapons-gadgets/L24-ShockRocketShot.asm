
CALLBACK 0x0014F250 end 0x0014F2A0 ordinal 0

0014F250 8C860058 lw         $a2, 0x58($a0)
0014F254 3C05002A lui        $a1, 0x2a
0014F258 C4AC39C4 lwc1       $f12, 0x39c4($a1)
0014F25C A0800045 sb         $zero, 0x45($a0)
0014F260 E48C0070 swc1       $f12, 0x70($a0)
0014F264 34050000 ori        $a1, $zero, 0
0014F268 00C02025 move       $a0, $a2
0014F26C AC800008 sw         $zero, 8($a0)
0014F270 24A50001 addiu      $a1, $a1, 1
0014F274 2CA70003 sltiu      $a3, $a1, 3
0014F278 14E0FFFC bnez       $a3, 0x14f26c
0014F27C 24840004 addiu      $a0, $a0, 4
0014F280 3C04002A lui        $a0, 0x2a
0014F284 44806000 mtc1       $zero, $f12
0014F288 C48D39C8 lwc1       $f13, 0x39c8($a0)
0014F28C ACC00004 sw         $zero, 4($a2)
0014F290 E4CD0024 swc1       $f13, 0x24($a2)
0014F294 E4CC0034 swc1       $f12, 0x34($a2)
0014F298 03E00008 jr         $ra
0014F29C 34020001 ori        $v0, $zero, 1

CALLBACK 0x0014F2A0 end 0x0014F308 ordinal 1

0014F2A0 27BDFFE0 addiu      $sp, $sp, -0x20
0014F2A4 AFB00010 sw         $s0, 0x10($sp)
0014F2A8 AFB10014 sw         $s1, 0x14($sp)
0014F2AC AFB20018 sw         $s2, 0x18($sp)
0014F2B0 AFBF001C sw         $ra, 0x1c($sp)
0014F2B4 8C900058 lw         $s0, 0x58($a0)
0014F2B8 34120000 ori        $s2, $zero, 0
0014F2BC 02008825 move       $s1, $s0
0014F2C0 0C047ECE jal        0x11fb38
0014F2C4 8E240008 lw         $a0, 8($s1)
0014F2C8 26520001 addiu      $s2, $s2, 1
0014F2CC 2E440003 sltiu      $a0, $s2, 3
0014F2D0 1480FFFB bnez       $a0, 0x14f2c0
0014F2D4 26310004 addiu      $s1, $s1, 4
0014F2D8 8E100004 lw         $s0, 4($s0)
0014F2DC 12000004 beqz       $s0, 0x14f2f0
0014F2E0 00000000 nop        
0014F2E4 02002025 move       $a0, $s0
0014F2E8 0C0192FF jal        0x64bfc
0014F2EC 34050001 ori        $a1, $zero, 1
0014F2F0 8FB00010 lw         $s0, 0x10($sp)
0014F2F4 8FB10014 lw         $s1, 0x14($sp)
0014F2F8 8FB20018 lw         $s2, 0x18($sp)
0014F2FC 8FBF001C lw         $ra, 0x1c($sp)
0014F300 03E00008 jr         $ra
0014F304 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0014F8A8 end 0x00150350 ordinal 2

0014F8A8 27BDFEE0 addiu      $sp, $sp, -0x120
0014F8AC AFB00100 sw         $s0, 0x100($sp)
0014F8B0 00808025 move       $s0, $a0
0014F8B4 C60D0070 lwc1       $f13, 0x70($s0)
0014F8B8 3C043F80 lui        $a0, 0x3f80
0014F8BC E7B400F8 swc1       $f20, 0xf8($sp)
0014F8C0 4484A000 mtc1       $a0, $f20
0014F8C4 46146B41 sub.s      $f13, $f13, $f20
0014F8C8 E7B600FC swc1       $f22, 0xfc($sp)
0014F8CC AFB10104 sw         $s1, 0x104($sp)
0014F8D0 4480B000 mtc1       $zero, $f22
0014F8D4 8E110058 lw         $s1, 0x58($s0)
0014F8D8 92040045 lbu        $a0, 0x45($s0)
0014F8DC 4616683E c.le.s     $f13, $f22
0014F8E0 AFB20108 sw         $s2, 0x108($sp)
0014F8E4 AFB3010C sw         $s3, 0x10c($sp)
0014F8E8 AFB40110 sw         $s4, 0x110($sp)
0014F8EC AFB50114 sw         $s5, 0x114($sp)
0014F8F0 AFB60118 sw         $s6, 0x118($sp)
0014F8F4 AFBF011C sw         $ra, 0x11c($sp)
0014F8F8 45000013 bc1f       0x14f948
0014F8FC E60D0070 swc1       $f13, 0x70($s0)
0014F900 1480000C bnez       $a0, 0x14f934
0014F904 00000000 nop        
0014F908 3C04002A lui        $a0, 0x2a
0014F90C 8C8439E0 lw         $a0, 0x39e0($a0)
0014F910 10800005 beqz       $a0, 0x14f928
0014F914 26110030 addiu      $s1, $s0, 0x30
0014F918 4600B306 mov.s      $f12, $f22
0014F91C 02202825 move       $a1, $s1
0014F920 0C01E518 jal        0x79460
0014F924 00003025 move       $a2, $zero
0014F928 02002025 move       $a0, $s0
0014F92C 0C04737E jal        0x11cdf8
0014F930 02202825 move       $a1, $s1
0014F934 02002025 move       $a0, $s0
0014F938 0C0192FF jal        0x64bfc
0014F93C 34050001 ori        $a1, $zero, 1
0014F940 10000277 b          0x150320
0014F944 00000000 nop        
0014F948 1480025E bnez       $a0, 0x1502c4
0014F94C 00000000 nop        
0014F950 0C053CDC jal        0x14f370
0014F954 02002025 move       $a0, $s0
0014F958 8E240000 lw         $a0, ($s1)
0014F95C C62C0024 lwc1       $f12, 0x24($s1)
0014F960 8C870594 lw         $a3, 0x594($a0)
0014F964 27A50020 addiu      $a1, $sp, 0x20
0014F968 26260018 addiu      $a2, $s1, 0x18
0014F96C 0C053DDD jal        0x14f774
0014F970 02002025 move       $a0, $s0
0014F974 3C14002A lui        $s4, 0x2a
0014F978 26943960 addiu      $s4, $s4, 0x3960
0014F97C 10400074 beqz       $v0, 0x14fb50
0014F980 3C150000 lui        $s5, 0
0014F984 8FA40034 lw         $a0, 0x34($sp)
0014F988 34050002 ori        $a1, $zero, 2
0014F98C 14850040 bne        $a0, $a1, 0x14fa90
0014F990 26120030 addiu      $s2, $s0, 0x30
0014F994 C7AC0038 lwc1       $f12, 0x38($sp)
0014F998 C7AD003C lwc1       $f13, 0x3c($sp)
0014F99C E7AC00A8 swc1       $f12, 0xa8($sp)
0014F9A0 C7AC0040 lwc1       $f12, 0x40($sp)
0014F9A4 E7AD00AC swc1       $f13, 0xac($sp)
0014F9A8 E7AC00B0 swc1       $f12, 0xb0($sp)
0014F9AC E7B400B4 swc1       $f20, 0xb4($sp)
0014F9B0 8FB30030 lw         $s3, 0x30($sp)
0014F9B4 C62C0018 lwc1       $f12, 0x18($s1)
0014F9B8 E7AC00B8 swc1       $f12, 0xb8($sp)
0014F9BC C62C001C lwc1       $f12, 0x1c($s1)
0014F9C0 E7AC00BC swc1       $f12, 0xbc($sp)
0014F9C4 C62C0020 lwc1       $f12, 0x20($s1)
0014F9C8 E7B600C4 swc1       $f22, 0xc4($sp)
0014F9CC E7AC00C0 swc1       $f12, 0xc0($sp)
0014F9D0 8E640040 lw         $a0, 0x40($s3)
0014F9D4 8C840020 lw         $a0, 0x20($a0)
0014F9D8 1080002D beqz       $a0, 0x14fa90
0014F9DC 00000000 nop        
0014F9E0 02002025 move       $a0, $s0
0014F9E4 02602825 move       $a1, $s3
0014F9E8 0C0540D4 jal        0x150350
0014F9EC 2406FFFF addiu      $a2, $zero, -1
0014F9F0 14400027 bnez       $v0, 0x14fa90
0014F9F4 00000000 nop        
0014F9F8 96240030 lhu        $a0, 0x30($s1)
0014F9FC 8E650040 lw         $a1, 0x40($s3)
0014FA00 8CA50020 lw         $a1, 0x20($a1)
0014FA04 14A00005 bnez       $a1, 0x14fa1c
0014FA08 2484005D addiu      $a0, $a0, 0x5d
0014FA0C 8E040058 lw         $a0, 0x58($s0)
0014FA10 2405FFFF addiu      $a1, $zero, -1
0014FA14 1000001A b          0x14fa80
0014FA18 8C840000 lw         $a0, ($a0)
0014FA1C 3C06002A lui        $a2, 0x2a
0014FA20 00042100 sll        $a0, $a0, 4
0014FA24 24C6A864 addiu      $a2, $a2, -0x579c
0014FA28 00862021 addu       $a0, $a0, $a2
0014FA2C 8C860000 lw         $a2, ($a0)
0014FA30 28C70002 slti       $a3, $a2, 2
0014FA34 14E00007 bnez       $a3, 0x14fa54
0014FA38 C48C0004 lwc1       $f12, 4($a0)
0014FA3C 28C60003 slti       $a2, $a2, 3
0014FA40 10C00004 beqz       $a2, 0x14fa54
0014FA44 3C063F00 lui        $a2, 0x3f00
0014FA48 44866800 mtc1       $a2, $f13
0014FA4C 10000001 b          0x14fa54
0014FA50 460D6302 mul.s      $f12, $f12, $f13
0014FA54 00A05025 move       $t2, $a1
0014FA58 8C850008 lw         $a1, 8($a0)
0014FA5C 8C86000C lw         $a2, 0xc($a0)
0014FA60 27A700A8 addiu      $a3, $sp, 0xa8
0014FA64 27A800B8 addiu      $t0, $sp, 0xb8
0014FA68 02602025 move       $a0, $s3
0014FA6C 0140F809 jalr       $t2
0014FA70 02004825 move       $t1, $s0
0014FA74 8E040058 lw         $a0, 0x58($s0)
0014FA78 00402825 move       $a1, $v0
0014FA7C 8C840000 lw         $a0, ($a0)
0014FA80 00A03825 move       $a3, $a1
0014FA84 34050008 ori        $a1, $zero, 8
0014FA88 0C003EC2 jal        0xfb08
0014FA8C 02603025 move       $a2, $s3
0014FA90 3C04002A lui        $a0, 0x2a
0014FA94 8C8439E0 lw         $a0, 0x39e0($a0)
0014FA98 10800005 beqz       $a0, 0x14fab0
0014FA9C 00000000 nop        
0014FAA0 4600B306 mov.s      $f12, $f22
0014FAA4 02402825 move       $a1, $s2
0014FAA8 0C01E518 jal        0x79460
0014FAAC 00003025 move       $a2, $zero
0014FAB0 02002025 move       $a0, $s0
0014FAB4 0C04737E jal        0x11cdf8
0014FAB8 02402825 move       $a1, $s2
0014FABC 3C06002A lui        $a2, 0x2a
0014FAC0 C4CC39CC lwc1       $f12, 0x39cc($a2)
0014FAC4 34070169 ori        $a3, $zero, 0x169
0014FAC8 34080101 ori        $t0, $zero, 0x101
0014FACC 27A400C8 addiu      $a0, $sp, 0xc8
0014FAD0 3409AE3E ori        $t1, $zero, 0xae3e
0014FAD4 34050003 ori        $a1, $zero, 3
0014FAD8 02403025 move       $a2, $s2
0014FADC 0C00555F jal        0x1557c
0014FAE0 340A0001 ori        $t2, $zero, 1
0014FAE4 00409025 move       $s2, $v0
0014FAE8 34130000 ori        $s3, $zero, 0
0014FAEC 0272202B sltu       $a0, $s3, $s2
0014FAF0 10800010 beqz       $a0, 0x14fb34
0014FAF4 34040001 ori        $a0, $zero, 1
0014FAF8 03A0B025 move       $s6, $sp
0014FAFC 8EC400C8 lw         $a0, 0xc8($s6)
0014FB00 8C850040 lw         $a1, 0x40($a0)
0014FB04 8CA50020 lw         $a1, 0x20($a1)
0014FB08 10A00005 beqz       $a1, 0x14fb20
0014FB0C 00000000 nop        
0014FB10 00802825 move       $a1, $a0
0014FB14 02002025 move       $a0, $s0
0014FB18 0C0540D4 jal        0x150350
0014FB1C 2406FFFF addiu      $a2, $zero, -1
0014FB20 26730001 addiu      $s3, $s3, 1
0014FB24 0272202B sltu       $a0, $s3, $s2
0014FB28 1480FFF4 bnez       $a0, 0x14fafc
0014FB2C 26D60004 addiu      $s6, $s6, 4
0014FB30 34040001 ori        $a0, $zero, 1
0014FB34 A2040045 sb         $a0, 0x45($s0)
0014FB38 3C04002A lui        $a0, 0x2a
0014FB3C C48C39D0 lwc1       $f12, 0x39d0($a0)
0014FB40 8E040064 lw         $a0, 0x64($s0)
0014FB44 E60C0070 swc1       $f12, 0x70($s0)
0014FB48 34840020 ori        $a0, $a0, 0x20
0014FB4C AE040064 sw         $a0, 0x64($s0)
0014FB50 96240030 lhu        $a0, 0x30($s1)
0014FB54 00042080 sll        $a0, $a0, 2
0014FB58 00942021 addu       $a0, $a0, $s4
0014FB5C C48C0000 lwc1       $f12, ($a0)
0014FB60 46166032 c.eq.s     $f12, $f22
0014FB64 00000000 nop        
0014FB68 4501001B bc1t       0x14fbd8
0014FB6C 00000000 nop        
0014FB70 34070169 ori        $a3, $zero, 0x169
0014FB74 34080101 ori        $t0, $zero, 0x101
0014FB78 27A400D4 addiu      $a0, $sp, 0xd4
0014FB7C 26060030 addiu      $a2, $s0, 0x30
0014FB80 34050003 ori        $a1, $zero, 3
0014FB84 34090002 ori        $t1, $zero, 2
0014FB88 0C00555F jal        0x1557c
0014FB8C 340A0001 ori        $t2, $zero, 1
0014FB90 00409025 move       $s2, $v0
0014FB94 34130000 ori        $s3, $zero, 0
0014FB98 0272202B sltu       $a0, $s3, $s2
0014FB9C 1080000E beqz       $a0, 0x14fbd8
0014FBA0 03A0A025 move       $s4, $sp
0014FBA4 8E8400D4 lw         $a0, 0xd4($s4)
0014FBA8 8C850040 lw         $a1, 0x40($a0)
0014FBAC 8CA50020 lw         $a1, 0x20($a1)
0014FBB0 10A00005 beqz       $a1, 0x14fbc8
0014FBB4 00000000 nop        
0014FBB8 00802825 move       $a1, $a0
0014FBBC 02002025 move       $a0, $s0
0014FBC0 0C0540D4 jal        0x150350
0014FBC4 2406FFFF addiu      $a2, $zero, -1
0014FBC8 26730001 addiu      $s3, $s3, 1
0014FBCC 0272202B sltu       $a0, $s3, $s2
0014FBD0 1480FFF4 bnez       $a0, 0x14fba4
0014FBD4 26940004 addiu      $s4, $s4, 4
0014FBD8 8EA401A4 lw         $a0, 0x1a4($s5)
0014FBDC 28840120 slti       $a0, $a0, 0x120
0014FBE0 14800023 bnez       $a0, 0x14fc70
0014FBE4 00000000 nop        
0014FBE8 C6010024 lwc1       $f1, 0x24($s0)
0014FBEC C6000020 lwc1       $f0, 0x20($s0)
0014FBF0 3C050000 lui        $a1, 0
0014FBF4 46010B42 mul.s      $f13, $f1, $f1
0014FBF8 8CAC01A0 lw         $t4, 0x1a0($a1)
0014FBFC 46000302 mul.s      $f12, $f0, $f0
0014FC00 C6030028 lwc1       $f3, 0x28($s0)
0014FC04 C62A0038 lwc1       $f10, 0x38($s1)
0014FC08 C6100030 lwc1       $f16, 0x30($s0)
0014FC0C 46031C42 mul.s      $f17, $f3, $f3
0014FC10 C60F0034 lwc1       $f15, 0x34($s0)
0014FC14 460D6340 add.s      $f13, $f12, $f13
0014FC18 3C073480 lui        $a3, 0x3480
0014FC1C C60E0038 lwc1       $f14, 0x38($s0)
0014FC20 44879000 mtc1       $a3, $f18
0014FC24 3C060028 lui        $a2, 0x28
0014FC28 90C69C51 lbu        $a2, -0x63af($a2)
0014FC2C 46116B40 add.s      $f13, $f13, $f17
0014FC30 3C07002A lui        $a3, 0x2a
0014FC34 C4E93A54 lwc1       $f9, 0x3a54($a3)
0014FC38 3C07002A lui        $a3, 0x2a
0014FC3C 3C020028 lui        $v0, 0x28
0014FC40 01801825 move       $v1, $t4
0014FC44 2404FFFF addiu      $a0, $zero, -1
0014FC48 25880090 addiu      $t0, $t4, 0x90
0014FC4C C4EC3A50 lwc1       $f12, 0x3a50($a3)
0014FC50 24425E50 addiu      $v0, $v0, 0x5e50
0014FC54 3C090000 lui        $t1, 0
0014FC58 3C0A0000 lui        $t2, 0
0014FC5C 10C00006 beqz       $a2, 0x14fc78
0014FC60 3C0B0000 lui        $t3, 0
0014FC64 3C070006 lui        $a3, 6
0014FC68 10000004 b          0x14fc7c
0014FC6C 24E7E268 addiu      $a3, $a3, -0x1d98
0014FC70 100001AB b          0x150320
0014FC74 00000000 nop        
0014FC78 34070000 ori        $a3, $zero, 0
0014FC7C 50E00009 beql       $a3, $zero, 0x14fca4
0014FC80 3C06002A lui        $a2, 0x2a
0014FC84 10C00004 beqz       $a2, 0x14fc98
0014FC88 34060000 ori        $a2, $zero, 0
0014FC8C 3C060006 lui        $a2, 6
0014FC90 10000001 b          0x14fc98
0014FC94 24C6E268 addiu      $a2, $a2, -0x1d98
0014FC98 10000004 b          0x14fcac
0014FC9C C4D10024 lwc1       $f17, 0x24($a2)
0014FCA0 3C06002A lui        $a2, 0x2a
0014FCA4 24C69A50 addiu      $a2, $a2, -0x65b0
0014FCA8 C4D10024 lwc1       $f17, 0x24($a2)
0014FCAC C4D30028 lwc1       $f19, 0x28($a2)
0014FCB0 46038882 mul.s      $f2, $f17, $f3
0014FCB4 46019CC2 mul.s      $f19, $f19, $f1
0014FCB8 46131081 sub.s      $f2, $f2, $f19
0014FCBC E7A20048 swc1       $f2, 0x48($sp)
0014FCC0 C4C40028 lwc1       $f4, 0x28($a2)
0014FCC4 C4C50020 lwc1       $f5, 0x20($a2)
0014FCC8 460024C2 mul.s      $f19, $f4, $f0
0014FCCC 46032942 mul.s      $f5, $f5, $f3
0014FCD0 46021182 mul.s      $f6, $f2, $f2
0014FCD4 46059CC1 sub.s      $f19, $f19, $f5
0014FCD8 E7B3004C swc1       $f19, 0x4c($sp)
0014FCDC C4D10020 lwc1       $f17, 0x20($a2)
0014FCE0 46139A02 mul.s      $f8, $f19, $f19
0014FCE4 C4C70024 lwc1       $f7, 0x24($a2)
0014FCE8 46018C42 mul.s      $f17, $f17, $f1
0014FCEC 46003902 mul.s      $f4, $f7, $f0
0014FCF0 46083140 add.s      $f5, $f6, $f8
0014FCF4 46048C41 sub.s      $f17, $f17, $f4
0014FCF8 46118AC2 mul.s      $f11, $f17, $f17
0014FCFC 460B2940 add.s      $f5, $f5, $f11
0014FD00 4612283C c.lt.s     $f5, $f18
0014FD04 00000000 nop        
0014FD08 45000007 bc1f       0x14fd28
0014FD0C E7B10050 swc1       $f17, 0x50($sp)
0014FD10 C6020010 lwc1       $f2, 0x10($s0)
0014FD14 C6130014 lwc1       $f19, 0x14($s0)
0014FD18 E7A20048 swc1       $f2, 0x48($sp)
0014FD1C E7B3004C swc1       $f19, 0x4c($sp)
0014FD20 C6110018 lwc1       $f17, 0x18($s0)
0014FD24 E7B10050 swc1       $f17, 0x50($sp)
0014FD28 46021102 mul.s      $f4, $f2, $f2
0014FD2C 46139942 mul.s      $f5, $f19, $f19
0014FD30 46118982 mul.s      $f6, $f17, $f17
0014FD34 46052100 add.s      $f4, $f4, $f5
0014FD38 46006307 neg.s      $f12, $f12
0014FD3C 46006B44 sqrt.s     $f13, $f13
0014FD40 46062100 add.s      $f4, $f4, $f6
0014FD44 460D6303 div.s      $f12, $f12, $f13
0014FD48 3C060100 lui        $a2, 0x100
0014FD4C 24078080 addiu      $a3, $zero, -0x7f80
0014FD50 24C68080 addiu      $a2, $a2, -0x7f80
0014FD54 46002104 sqrt.s     $f4, $f4
0014FD58 46044903 div.s      $f4, $f9, $f4
0014FD5C 46006342 mul.s      $f13, $f12, $f0
0014FD60 46016042 mul.s      $f1, $f12, $f1
0014FD64 461452C0 add.s      $f11, $f10, $f20
0014FD68 46036302 mul.s      $f12, $f12, $f3
0014FD6C 46022082 mul.s      $f2, $f4, $f2
0014FD70 461324C2 mul.s      $f19, $f4, $f19
0014FD74 46112442 mul.s      $f17, $f4, $f17
0014FD78 46028140 add.s      $f5, $f16, $f2
0014FD7C E7A20058 swc1       $f2, 0x58($sp)
0014FD80 46137980 add.s      $f6, $f15, $f19
0014FD84 E7B3005C swc1       $f19, 0x5c($sp)
0014FD88 E7B10060 swc1       $f17, 0x60($sp)
0014FD8C 461171C0 add.s      $f7, $f14, $f17
0014FD90 46028101 sub.s      $f4, $f16, $f2
0014FD94 E7A50068 swc1       $f5, 0x68($sp)
0014FD98 E7A6006C swc1       $f6, 0x6c($sp)
0014FD9C 46137941 sub.s      $f5, $f15, $f19
0014FDA0 46117181 sub.s      $f6, $f14, $f17
0014FDA4 E7A70070 swc1       $f7, 0x70($sp)
0014FDA8 E7AD0098 swc1       $f13, 0x98($sp)
0014FDAC E7A1009C swc1       $f1, 0x9c($sp)
0014FDB0 46106B40 add.s      $f13, $f13, $f16
0014FDB4 E7A40074 swc1       $f4, 0x74($sp)
0014FDB8 460F0BC0 add.s      $f15, $f1, $f15
0014FDBC 460E6380 add.s      $f14, $f12, $f14
0014FDC0 E7A50078 swc1       $f5, 0x78($sp)
0014FDC4 E7A6007C swc1       $f6, 0x7c($sp)
0014FDC8 E7AC00A0 swc1       $f12, 0xa0($sp)
0014FDCC E7AD0098 swc1       $f13, 0x98($sp)
0014FDD0 46137800 add.s      $f0, $f15, $f19
0014FDD4 46026B00 add.s      $f12, $f13, $f2
0014FDD8 E7AF009C swc1       $f15, 0x9c($sp)
0014FDDC 461170C0 add.s      $f3, $f14, $f17
0014FDE0 E7AE00A0 swc1       $f14, 0xa0($sp)
0014FDE4 46005246 mov.s      $f9, $f10
0014FDE8 46005D46 mov.s      $f21, $f11
0014FDEC 46026B41 sub.s      $f13, $f13, $f2
0014FDF0 E7AC0080 swc1       $f12, 0x80($sp)
0014FDF4 46137B01 sub.s      $f12, $f15, $f19
0014FDF8 E7A00084 swc1       $f0, 0x84($sp)
0014FDFC 46117381 sub.s      $f14, $f14, $f17
0014FE00 E7A30088 swc1       $f3, 0x88($sp)
0014FE04 E7AD008C swc1       $f13, 0x8c($sp)
0014FE08 E7AC0090 swc1       $f12, 0x90($sp)
0014FE0C E7AE0094 swc1       $f14, 0x94($sp)
0014FE10 E5890000 swc1       $f9, ($t4)
0014FE14 E5960004 swc1       $f22, 4($t4)
0014FE18 AD870008 sw         $a3, 8($t4)
0014FE1C C7AC0068 lwc1       $f12, 0x68($sp)
0014FE20 E58C000C swc1       $f12, 0xc($t4)
0014FE24 C7AC006C lwc1       $f12, 0x6c($sp)
0014FE28 E58C0010 swc1       $f12, 0x10($t4)
0014FE2C C7AC0070 lwc1       $f12, 0x70($sp)
0014FE30 E58C0014 swc1       $f12, 0x14($t4)
0014FE34 246C0018 addiu      $t4, $v1, 0x18
0014FE38 E5890000 swc1       $f9, ($t4)
0014FE3C E5960004 swc1       $f22, 4($t4)
0014FE40 AD870008 sw         $a3, 8($t4)
0014FE44 C7AC0068 lwc1       $f12, 0x68($sp)
0014FE48 E58C000C swc1       $f12, 0xc($t4)
0014FE4C C7AC006C lwc1       $f12, 0x6c($sp)
0014FE50 E58C0010 swc1       $f12, 0x10($t4)
0014FE54 C7AC0070 lwc1       $f12, 0x70($sp)
0014FE58 E58C0014 swc1       $f12, 0x14($t4)
0014FE5C 246C0030 addiu      $t4, $v1, 0x30
0014FE60 E58A0000 swc1       $f10, ($t4)
0014FE64 E5940004 swc1       $f20, 4($t4)
0014FE68 AD870008 sw         $a3, 8($t4)
0014FE6C C7AC0074 lwc1       $f12, 0x74($sp)
0014FE70 E58C000C swc1       $f12, 0xc($t4)
0014FE74 C7AC0078 lwc1       $f12, 0x78($sp)
0014FE78 E58C0010 swc1       $f12, 0x10($t4)
0014FE7C C7AC007C lwc1       $f12, 0x7c($sp)
0014FE80 E58C0014 swc1       $f12, 0x14($t4)
0014FE84 24670048 addiu      $a3, $v1, 0x48
0014FE88 E4EB0000 swc1       $f11, ($a3)
0014FE8C E4F60004 swc1       $f22, 4($a3)
0014FE90 ACE60008 sw         $a2, 8($a3)
0014FE94 C7AC0080 lwc1       $f12, 0x80($sp)
0014FE98 E4EC000C swc1       $f12, 0xc($a3)
0014FE9C C7AC0084 lwc1       $f12, 0x84($sp)
0014FEA0 E4EC0010 swc1       $f12, 0x10($a3)
0014FEA4 C7AC0088 lwc1       $f12, 0x88($sp)
0014FEA8 E4EC0014 swc1       $f12, 0x14($a3)
0014FEAC 24670060 addiu      $a3, $v1, 0x60
0014FEB0 E4F50000 swc1       $f21, ($a3)
0014FEB4 E4F40004 swc1       $f20, 4($a3)
0014FEB8 ACE60008 sw         $a2, 8($a3)
0014FEBC C7AC008C lwc1       $f12, 0x8c($sp)
0014FEC0 E4EC000C swc1       $f12, 0xc($a3)
0014FEC4 C7AC0090 lwc1       $f12, 0x90($sp)
0014FEC8 E4EC0010 swc1       $f12, 0x10($a3)
0014FECC C7AC0094 lwc1       $f12, 0x94($sp)
0014FED0 E4EC0014 swc1       $f12, 0x14($a3)
0014FED4 24670078 addiu      $a3, $v1, 0x78
0014FED8 E4F50000 swc1       $f21, ($a3)
0014FEDC E4F40004 swc1       $f20, 4($a3)
0014FEE0 ACE60008 sw         $a2, 8($a3)
0014FEE4 C7AC008C lwc1       $f12, 0x8c($sp)
0014FEE8 E4EC000C swc1       $f12, 0xc($a3)
0014FEEC C7AC0090 lwc1       $f12, 0x90($sp)
0014FEF0 3C06002A lui        $a2, 0x2a
0014FEF4 E4EC0010 swc1       $f12, 0x10($a3)
0014FEF8 C7AC0094 lwc1       $f12, 0x94($sp)
0014FEFC E4EC0014 swc1       $f12, 0x14($a3)
0014FF00 C62C0038 lwc1       $f12, 0x38($s1)
0014FF04 C4CD3A4C lwc1       $f13, 0x3a4c($a2)
0014FF08 460D6300 add.s      $f12, $f12, $f13
0014FF0C 4616603C c.lt.s     $f12, $f22
0014FF10 00000000 nop        
0014FF14 45000004 bc1f       0x14ff28
0014FF18 E62C0038 swc1       $f12, 0x38($s1)
0014FF1C 46146300 add.s      $f12, $f12, $f20
0014FF20 10000007 b          0x14ff40
0014FF24 E62C0038 swc1       $f12, 0x38($s1)
0014FF28 4614603E c.le.s     $f12, $f20
0014FF2C 00000000 nop        
0014FF30 45030004 bc1tl      0x14ff44
0014FF34 E7A900F0 swc1       $f9, 0xf0($sp)
0014FF38 46146301 sub.s      $f12, $f12, $f20
0014FF3C E62C0038 swc1       $f12, 0x38($s1)
0014FF40 E7A900F0 swc1       $f9, 0xf0($sp)
0014FF44 E7AA00EC swc1       $f10, 0xec($sp)
0014FF48 3C07002A lui        $a3, 0x2a
0014FF4C 8CE73A44 lw         $a3, 0x3a44($a3)
0014FF50 E7AB00E8 swc1       $f11, 0xe8($sp)
0014FF54 E7B500E4 swc1       $f21, 0xe4($sp)
0014FF58 00071882 srl        $v1, $a3, 2
0014FF5C 00403025 move       $a2, $v0
0014FF60 3063000F andi       $v1, $v1, 0xf
0014FF64 AFA200E0 sw         $v0, 0xe0($sp)
0014FF68 00031080 sll        $v0, $v1, 2
0014FF6C 8CA301A0 lw         $v1, 0x1a0($a1)
0014FF70 AFA800F4 sw         $t0, 0xf4($sp)
0014FF74 00463021 addu       $a2, $v0, $a2
0014FF78 8CC60000 lw         $a2, ($a2)
0014FF7C AD2001A8 sw         $zero, 0x1a8($t1)
0014FF80 AD4001AC sw         $zero, 0x1ac($t2)
0014FF84 AD6401B0 sw         $a0, 0x1b0($t3)
0014FF88 00C62021 addu       $a0, $a2, $a2
0014FF8C 00C42021 addu       $a0, $a2, $a0
0014FF90 00842021 addu       $a0, $a0, $a0
0014FF94 8EA601A4 lw         $a2, 0x1a4($s5)
0014FF98 00644021 addu       $t0, $v1, $a0
0014FF9C ACA801A0 sw         $t0, 0x1a0($a1)
0014FFA0 00C42023 subu       $a0, $a2, $a0
0014FFA4 AEA401A4 sw         $a0, 0x1a4($s5)
0014FFA8 00E03025 move       $a2, $a3
0014FFAC 00602025 move       $a0, $v1
0014FFB0 34050006 ori        $a1, $zero, 6
0014FFB4 00003825 move       $a3, $zero
0014FFB8 00004025 move       $t0, $zero
0014FFBC 0C021B75 jal        0x86dd4
0014FFC0 00004825 move       $t1, $zero
0014FFC4 C7AE0048 lwc1       $f14, 0x48($sp)
0014FFC8 C7B0004C lwc1       $f16, 0x4c($sp)
0014FFCC C7B10050 lwc1       $f17, 0x50($sp)
0014FFD0 460E7482 mul.s      $f18, $f14, $f14
0014FFD4 C60D0024 lwc1       $f13, 0x24($s0)
0014FFD8 461084C2 mul.s      $f19, $f16, $f16
0014FFDC C60F0020 lwc1       $f15, 0x20($s0)
0014FFE0 46118802 mul.s      $f0, $f17, $f17
0014FFE4 460D6842 mul.s      $f1, $f13, $f13
0014FFE8 C60C0028 lwc1       $f12, 0x28($s0)
0014FFEC 460F78C2 mul.s      $f3, $f15, $f15
0014FFF0 46139480 add.s      $f18, $f18, $f19
0014FFF4 3C05002A lui        $a1, 0x2a
0014FFF8 460C6202 mul.s      $f8, $f12, $f12
0014FFFC 3C043480 lui        $a0, 0x3480
00150000 46011840 add.s      $f1, $f3, $f1
00150004 C6130030 lwc1       $f19, 0x30($s0)
00150008 46009000 add.s      $f0, $f18, $f0
0015000C C6020034 lwc1       $f2, 0x34($s0)
00150010 C6030038 lwc1       $f3, 0x38($s0)
00150014 46080A00 add.s      $f8, $f1, $f8
00150018 8FA200E0 lw         $v0, 0xe0($sp)
0015001C 44849000 mtc1       $a0, $f18
00150020 C4B73A58 lwc1       $f23, 0x3a58($a1)
00150024 4612003C c.lt.s     $f0, $f18
00150028 8FA800F4 lw         $t0, 0xf4($sp)
0015002C C7B500E4 lwc1       $f21, 0xe4($sp)
00150030 C7AB00E8 lwc1       $f11, 0xe8($sp)
00150034 C7AA00EC lwc1       $f10, 0xec($sp)
00150038 3C0B0000 lui        $t3, 0
0015003C 3C0A0000 lui        $t2, 0
00150040 3C090000 lui        $t1, 0
00150044 3C050000 lui        $a1, 0
00150048 2404FFFF addiu      $a0, $zero, -1
0015004C 4500000B bc1f       0x15007c
00150050 C7A900F0 lwc1       $f9, 0xf0($sp)
00150054 C7AE0058 lwc1       $f14, 0x58($sp)
00150058 C7B0005C lwc1       $f16, 0x5c($sp)
0015005C C7B10060 lwc1       $f17, 0x60($sp)
00150060 460E9800 add.s      $f0, $f19, $f14
00150064 46101040 add.s      $f1, $f2, $f16
00150068 46111900 add.s      $f4, $f3, $f17
0015006C 460E9941 sub.s      $f5, $f19, $f14
00150070 46101181 sub.s      $f6, $f2, $f16
00150074 10000011 b          0x1500bc
00150078 461119C1 sub.s      $f7, $f3, $f17
0015007C 3C06002A lui        $a2, 0x2a
00150080 46000004 sqrt.s     $f0, $f0
00150084 C4C13A5C lwc1       $f1, 0x3a5c($a2)
00150088 46000803 div.s      $f0, $f1, $f0
0015008C 460E0382 mul.s      $f14, $f0, $f14
00150090 46100402 mul.s      $f16, $f0, $f16
00150094 46110442 mul.s      $f17, $f0, $f17
00150098 E7AE0058 swc1       $f14, 0x58($sp)
0015009C 460E9941 sub.s      $f5, $f19, $f14
001500A0 E7B0005C swc1       $f16, 0x5c($sp)
001500A4 46101040 add.s      $f1, $f2, $f16
001500A8 E7B10060 swc1       $f17, 0x60($sp)
001500AC 460E9800 add.s      $f0, $f19, $f14
001500B0 46111900 add.s      $f4, $f3, $f17
001500B4 46101181 sub.s      $f6, $f2, $f16
001500B8 461119C1 sub.s      $f7, $f3, $f17
001500BC E7A00068 swc1       $f0, 0x68($sp)
001500C0 4612403C c.lt.s     $f8, $f18
001500C4 E7A1006C swc1       $f1, 0x6c($sp)
001500C8 4600B807 neg.s      $f0, $f23
001500CC E7A40070 swc1       $f4, 0x70($sp)
001500D0 E7A50074 swc1       $f5, 0x74($sp)
001500D4 E7A60078 swc1       $f6, 0x78($sp)
001500D8 45000008 bc1f       0x1500fc
001500DC E7A7007C swc1       $f7, 0x7c($sp)
001500E0 C7AC0098 lwc1       $f12, 0x98($sp)
001500E4 C7AD009C lwc1       $f13, 0x9c($sp)
001500E8 461364C0 add.s      $f19, $f12, $f19
001500EC C7AF00A0 lwc1       $f15, 0xa0($sp)
001500F0 46026B00 add.s      $f12, $f13, $f2
001500F4 1000000C b          0x150128
001500F8 46037B40 add.s      $f13, $f15, $f3
001500FC 46004484 sqrt.s     $f18, $f8
00150100 46120483 div.s      $f18, $f0, $f18
00150104 460F93C2 mul.s      $f15, $f18, $f15
00150108 460D9342 mul.s      $f13, $f18, $f13
0015010C E7AF0098 swc1       $f15, 0x98($sp)
00150110 460C9482 mul.s      $f18, $f18, $f12
00150114 E7AD009C swc1       $f13, 0x9c($sp)
00150118 46137CC0 add.s      $f19, $f15, $f19
0015011C 46026B00 add.s      $f12, $f13, $f2
00150120 E7B200A0 swc1       $f18, 0xa0($sp)
00150124 46039340 add.s      $f13, $f18, $f3
00150128 460E9BC0 add.s      $f15, $f19, $f14
0015012C E7B30098 swc1       $f19, 0x98($sp)
00150130 46106480 add.s      $f18, $f12, $f16
00150134 E7AC009C swc1       $f12, 0x9c($sp)
00150138 46116800 add.s      $f0, $f13, $f17
0015013C E7AD00A0 swc1       $f13, 0xa0($sp)
00150140 3C060100 lui        $a2, 0x100
00150144 460E9B81 sub.s      $f14, $f19, $f14
00150148 E7AF0080 swc1       $f15, 0x80($sp)
0015014C 46106301 sub.s      $f12, $f12, $f16
00150150 E7B20084 swc1       $f18, 0x84($sp)
00150154 46116B41 sub.s      $f13, $f13, $f17
00150158 E7A00088 swc1       $f0, 0x88($sp)
0015015C 00803825 move       $a3, $a0
00150160 E7AE008C swc1       $f14, 0x8c($sp)
00150164 E7AC0090 swc1       $f12, 0x90($sp)
00150168 E7AD0094 swc1       $f13, 0x94($sp)
0015016C 24C6FFFF addiu      $a2, $a2, -1
00150170 E5090000 swc1       $f9, ($t0)
00150174 E5160004 swc1       $f22, 4($t0)
00150178 AD070008 sw         $a3, 8($t0)
0015017C C7AC0068 lwc1       $f12, 0x68($sp)
00150180 E50C000C swc1       $f12, 0xc($t0)
00150184 C7AC006C lwc1       $f12, 0x6c($sp)
00150188 E50C0010 swc1       $f12, 0x10($t0)
0015018C C7AC0070 lwc1       $f12, 0x70($sp)
00150190 E50C0014 swc1       $f12, 0x14($t0)
00150194 25030018 addiu      $v1, $t0, 0x18
00150198 E4690000 swc1       $f9, ($v1)
0015019C E4760004 swc1       $f22, 4($v1)
001501A0 AC670008 sw         $a3, 8($v1)
001501A4 C7AC0068 lwc1       $f12, 0x68($sp)
001501A8 E46C000C swc1       $f12, 0xc($v1)
001501AC C7AC006C lwc1       $f12, 0x6c($sp)
001501B0 E46C0010 swc1       $f12, 0x10($v1)
001501B4 C7AC0070 lwc1       $f12, 0x70($sp)
001501B8 E46C0014 swc1       $f12, 0x14($v1)
001501BC 25030030 addiu      $v1, $t0, 0x30
001501C0 E46A0000 swc1       $f10, ($v1)
001501C4 E4740004 swc1       $f20, 4($v1)
001501C8 AC670008 sw         $a3, 8($v1)
001501CC C7AC0074 lwc1       $f12, 0x74($sp)
001501D0 E46C000C swc1       $f12, 0xc($v1)
001501D4 C7AC0078 lwc1       $f12, 0x78($sp)
001501D8 E46C0010 swc1       $f12, 0x10($v1)
001501DC C7AC007C lwc1       $f12, 0x7c($sp)
001501E0 E46C0014 swc1       $f12, 0x14($v1)
001501E4 25070048 addiu      $a3, $t0, 0x48
001501E8 E4EB0000 swc1       $f11, ($a3)
001501EC E4F60004 swc1       $f22, 4($a3)
001501F0 ACE60008 sw         $a2, 8($a3)
001501F4 C7AC0080 lwc1       $f12, 0x80($sp)
001501F8 E4EC000C swc1       $f12, 0xc($a3)
001501FC C7AC0084 lwc1       $f12, 0x84($sp)
00150200 E4EC0010 swc1       $f12, 0x10($a3)
00150204 C7AC0088 lwc1       $f12, 0x88($sp)
00150208 E4EC0014 swc1       $f12, 0x14($a3)
0015020C 25070060 addiu      $a3, $t0, 0x60
00150210 E4F50000 swc1       $f21, ($a3)
00150214 E4F40004 swc1       $f20, 4($a3)
00150218 ACE60008 sw         $a2, 8($a3)
0015021C C7AC008C lwc1       $f12, 0x8c($sp)
00150220 E4EC000C swc1       $f12, 0xc($a3)
00150224 C7AC0090 lwc1       $f12, 0x90($sp)
00150228 E4EC0010 swc1       $f12, 0x10($a3)
0015022C C7AC0094 lwc1       $f12, 0x94($sp)
00150230 E4EC0014 swc1       $f12, 0x14($a3)
00150234 25070078 addiu      $a3, $t0, 0x78
00150238 E4F50000 swc1       $f21, ($a3)
0015023C E4F40004 swc1       $f20, 4($a3)
00150240 ACE60008 sw         $a2, 8($a3)
00150244 C7AC008C lwc1       $f12, 0x8c($sp)
00150248 E4EC000C swc1       $f12, 0xc($a3)
0015024C C7AC0090 lwc1       $f12, 0x90($sp)
00150250 3C03002A lui        $v1, 0x2a
00150254 E4EC0010 swc1       $f12, 0x10($a3)
00150258 C7AC0094 lwc1       $f12, 0x94($sp)
0015025C E4EC0014 swc1       $f12, 0x14($a3)
00150260 8EA801A4 lw         $t0, 0x1a4($s5)
00150264 8CA601A0 lw         $a2, 0x1a0($a1)
00150268 8C673A48 lw         $a3, 0x3a48($v1)
0015026C 00071882 srl        $v1, $a3, 2
00150270 3063000F andi       $v1, $v1, 0xf
00150274 00031880 sll        $v1, $v1, 2
00150278 00621021 addu       $v0, $v1, $v0
0015027C 8C420000 lw         $v0, ($v0)
00150280 AD2001A8 sw         $zero, 0x1a8($t1)
00150284 AD4001AC sw         $zero, 0x1ac($t2)
00150288 AD6401B0 sw         $a0, 0x1b0($t3)
0015028C 00422021 addu       $a0, $v0, $v0
00150290 00442021 addu       $a0, $v0, $a0
00150294 00842021 addu       $a0, $a0, $a0
00150298 00C44821 addu       $t1, $a2, $a0
0015029C 01042023 subu       $a0, $t0, $a0
001502A0 ACA901A0 sw         $t1, 0x1a0($a1)
001502A4 AEA401A4 sw         $a0, 0x1a4($s5)
001502A8 00C02025 move       $a0, $a2
001502AC 00E03025 move       $a2, $a3
001502B0 34050006 ori        $a1, $zero, 6
001502B4 00003825 move       $a3, $zero
001502B8 00004025 move       $t0, $zero
001502BC 0C021B75 jal        0x86dd4
001502C0 00004825 move       $t1, $zero
001502C4 26100030 addiu      $s0, $s0, 0x30
001502C8 34120000 ori        $s2, $zero, 0
001502CC 02209825 move       $s3, $s1
001502D0 8E640008 lw         $a0, 8($s3)
001502D4 0C047D9B jal        0x11f66c
001502D8 02002825 move       $a1, $s0
001502DC 26520001 addiu      $s2, $s2, 1
001502E0 2E440003 sltiu      $a0, $s2, 3
001502E4 1480FFFA bnez       $a0, 0x1502d0
001502E8 26730004 addiu      $s3, $s3, 4
001502EC 8E240004 lw         $a0, 4($s1)
001502F0 10800006 beqz       $a0, 0x15030c
001502F4 00000000 nop        
001502F8 8C840064 lw         $a0, 0x64($a0)
001502FC 30840006 andi       $a0, $a0, 6
00150300 10800002 beqz       $a0, 0x15030c
00150304 00000000 nop        
00150308 AE200004 sw         $zero, 4($s1)
0015030C 3C06002A lui        $a2, 0x2a
00150310 02002025 move       $a0, $s0
00150314 2405C080 addiu      $a1, $zero, -0x3f80
00150318 0C01CC7B jal        0x731ec
0015031C C4CC39DC lwc1       $f12, 0x39dc($a2)
00150320 C7B400F8 lwc1       $f20, 0xf8($sp)
00150324 C7B600FC lwc1       $f22, 0xfc($sp)
00150328 8FB00100 lw         $s0, 0x100($sp)
0015032C 8FB10104 lw         $s1, 0x104($sp)
00150330 8FB20108 lw         $s2, 0x108($sp)
00150334 8FB3010C lw         $s3, 0x10c($sp)
00150338 8FB40110 lw         $s4, 0x110($sp)
0015033C 8FB50114 lw         $s5, 0x114($sp)
00150340 8FB60118 lw         $s6, 0x118($sp)
00150344 8FBF011C lw         $ra, 0x11c($sp)
00150348 03E00008 jr         $ra
0015034C 27BD0120 addiu      $sp, $sp, 0x120