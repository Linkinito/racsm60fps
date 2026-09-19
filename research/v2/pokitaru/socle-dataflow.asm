# Source SHA256 d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571; addresses are unrelocated module RVAs; bounds are extraction windows.

# 0002FB8C..00030180
0002FB8C 27BDFF90 addiu      $sp, $sp, -0x70
0002FB90 E7B40044 swc1       $f20, 0x44($sp)
0002FB94 AFB00048 sw         $s0, 0x48($sp)
0002FB98 AFB1004C sw         $s1, 0x4c($sp)
0002FB9C AFB20050 sw         $s2, 0x50($sp)
0002FBA0 AFB30054 sw         $s3, 0x54($sp)
0002FBA4 AFB40058 sw         $s4, 0x58($sp)
0002FBA8 AFB5005C sw         $s5, 0x5c($sp)
0002FBAC AFB60060 sw         $s6, 0x60($sp)
0002FBB0 AFB70064 sw         $s7, 0x64($sp)
0002FBB4 AFBF0068 sw         $ra, 0x68($sp)
0002FBB8 00808025 move       $s0, $a0
0002FBBC 46006506 mov.s      $f20, $f12
0002FBC0 3C04002B lui        $a0, 0x2b
0002FBC4 AC9000C0 sw         $s0, 0xc0($a0)
0002FBC8 44806000 mtc1       $zero, $f12
0002FBCC E7AC0020 swc1       $f12, 0x20($sp)
0002FBD0 3C04461C lui        $a0, 0x461c
0002FBD4 34844000 ori        $a0, $a0, 0x4000
0002FBD8 44846800 mtc1       $a0, $f13
0002FBDC E7AD0024 swc1       $f13, 0x24($sp)
0002FBE0 E7AC0028 swc1       $f12, 0x28($sp)
0002FBE4 8FA40020 lw         $a0, 0x20($sp)
0002FBE8 8FA50024 lw         $a1, 0x24($sp)
0002FBEC 8FA60028 lw         $a2, 0x28($sp)
0002FBF0 3C070009 lui        $a3, 9
0002FBF4 ACE4FB30 sw         $a0, -0x4d0($a3)
0002FBF8 24E4FB30 addiu      $a0, $a3, -0x4d0
0002FBFC AC850004 sw         $a1, 4($a0)
0002FC00 AC860008 sw         $a2, 8($a0)
0002FC04 8E040D90 lw         $a0, 0xd90($s0)
0002FC08 14800006 bnez       $a0, 0x2fc24
0002FC0C 00000000 nop        
0002FC10 8E040594 lw         $a0, 0x594($s0)
0002FC14 10800008 beqz       $a0, 0x2fc38
0002FC18 00000000 nop        
0002FC1C 1000000F b          0x2fc5c
0002FC20 00000000 nop        
0002FC24 8C850000 lw         $a1, ($a0)
0002FC28 00A0F809 jalr       $a1
0002FC2C 02002025 move       $a0, $s0
0002FC30 100000E3 b          0x2ffc0
0002FC34 00000000 nop        
0002FC38 8E0405AC lw         $a0, 0x5ac($s0)
0002FC3C 10800005 beqz       $a0, 0x2fc54
0002FC40 00000000 nop        
0002FC44 0C015760 jal        0x55d80
0002FC48 02002025 move       $a0, $s0
0002FC4C 10000003 b          0x2fc5c
0002FC50 00000000 nop        
0002FC54 100000DA b          0x2ffc0
0002FC58 00000000 nop        
0002FC5C 02002025 move       $a0, $s0
0002FC60 0C00D829 jal        0x360a4
0002FC64 4600A306 mov.s      $f12, $f20
0002FC68 C60C0A20 lwc1       $f12, 0xa20($s0)
0002FC6C E60C0F6C swc1       $f12, 0xf6c($s0)
0002FC70 C60C0A24 lwc1       $f12, 0xa24($s0)
0002FC74 E60C0F70 swc1       $f12, 0xf70($s0)
0002FC78 C60C0A28 lwc1       $f12, 0xa28($s0)
0002FC7C E60C0F74 swc1       $f12, 0xf74($s0)
0002FC80 8E04095C lw         $a0, 0x95c($s0)
0002FC84 30848000 andi       $a0, $a0, 0x8000
0002FC88 3C130040 lui        $s3, 0x40
0002FC8C 3C14FFC0 lui        $s4, 0xffc0
0002FC90 2694FFFF addiu      $s4, $s4, -1
0002FC94 27B5002C addiu      $s5, $sp, 0x2c
0002FC98 27B60038 addiu      $s6, $sp, 0x38
0002FC9C 3C170006 lui        $s7, 6
0002FCA0 10800029 beqz       $a0, 0x2fd48
0002FCA4 26F7E228 addiu      $s7, $s7, -0x1dd8
0002FCA8 34110000 ori        $s1, $zero, 0
0002FCAC 3C12002B lui        $s2, 0x2b
0002FCB0 2E240001 sltiu      $a0, $s1, 1
0002FCB4 A2440208 sb         $a0, 0x208($s2)
0002FCB8 0C00D4E9 jal        0x353a4
0002FCBC 02002025 move       $a0, $s0
0002FCC0 0C00C801 jal        0x32004
0002FCC4 02002025 move       $a0, $s0
0002FCC8 0C00EFFE jal        0x3bff8
0002FCCC 02002025 move       $a0, $s0
0002FCD0 0C00F223 jal        0x3c88c
0002FCD4 02002025 move       $a0, $s0
0002FCD8 0C00CA22 jal        0x32888
0002FCDC 02002025 move       $a0, $s0
0002FCE0 02002025 move       $a0, $s0
0002FCE4 0C00E6DD jal        0x39b74
0002FCE8 4600A306 mov.s      $f12, $f20
0002FCEC 02002025 move       $a0, $s0
0002FCF0 0C007AF1 jal        0x1ebc4
0002FCF4 4600A306 mov.s      $f12, $f20
0002FCF8 26310001 addiu      $s1, $s1, 1
0002FCFC 2A240002 slti       $a0, $s1, 2
0002FD00 1480FFEB bnez       $a0, 0x2fcb0
0002FD04 00000000 nop        
0002FD08 34040001 ori        $a0, $zero, 1
0002FD0C A2440208 sb         $a0, 0x208($s2)
0002FD10 0C00D659 jal        0x35964
0002FD14 02002025 move       $a0, $s0
0002FD18 10400005 beqz       $v0, 0x2fd30
0002FD1C 00000000 nop        
0002FD20 0C00D650 jal        0x35940
0002FD24 02002025 move       $a0, $s0
0002FD28 0C013CB4 jal        0x4f2d0
0002FD2C 02002025 move       $a0, $s0
0002FD30 8E040594 lw         $a0, 0x594($s0)
0002FD34 8C840064 lw         $a0, 0x64($a0)
0002FD38 00939824 and        $s3, $a0, $s3
0002FD3C 0013982B sltu       $s3, $zero, $s3
0002FD40 10000008 b          0x2fd64
0002FD44 8E04059C lw         $a0, 0x59c($s0)
0002FD48 0C00D4E9 jal        0x353a4
0002FD4C 02002025 move       $a0, $s0
0002FD50 8E040594 lw         $a0, 0x594($s0)
0002FD54 8C840064 lw         $a0, 0x64($a0)
0002FD58 00939824 and        $s3, $a0, $s3
0002FD5C 0013982B sltu       $s3, $zero, $s3
0002FD60 8E04059C lw         $a0, 0x59c($s0)
0002FD64 32730001 andi       $s3, $s3, 1
0002FD68 10800005 beqz       $a0, 0x2fd80
0002FD6C 00139D80 sll        $s3, $s3, 0x16
0002FD70 8C850064 lw         $a1, 0x64($a0)
0002FD74 00B42824 and        $a1, $a1, $s4
0002FD78 00B32825 or         $a1, $a1, $s3
0002FD7C AC850064 sw         $a1, 0x64($a0)
0002FD80 8E0405A0 lw         $a0, 0x5a0($s0)
0002FD84 10800005 beqz       $a0, 0x2fd9c
0002FD88 00000000 nop        
0002FD8C 8C850064 lw         $a1, 0x64($a0)
0002FD90 00B42824 and        $a1, $a1, $s4
0002FD94 00B32825 or         $a1, $a1, $s3
0002FD98 AC850064 sw         $a1, 0x64($a0)
0002FD9C 8E040598 lw         $a0, 0x598($s0)
0002FDA0 10800005 beqz       $a0, 0x2fdb8
0002FDA4 00000000 nop        
0002FDA8 8C850064 lw         $a1, 0x64($a0)
0002FDAC 00B42824 and        $a1, $a1, $s4
0002FDB0 00B32825 or         $a1, $a1, $s3
0002FDB4 AC850064 sw         $a1, 0x64($a0)
0002FDB8 8E0405A4 lw         $a0, 0x5a4($s0)
0002FDBC 10800005 beqz       $a0, 0x2fdd4
0002FDC0 00000000 nop        
0002FDC4 8C850064 lw         $a1, 0x64($a0)
0002FDC8 00B42824 and        $a1, $a1, $s4
0002FDCC 00B32825 or         $a1, $a1, $s3
0002FDD0 AC850064 sw         $a1, 0x64($a0)
0002FDD4 34040000 ori        $a0, $zero, 0
0002FDD8 02002825 move       $a1, $s0
0002FDDC 8CA605B0 lw         $a2, 0x5b0($a1)
0002FDE0 10C00005 beqz       $a2, 0x2fdf8
0002FDE4 00000000 nop        
0002FDE8 8CC70064 lw         $a3, 0x64($a2)
0002FDEC 00F43824 and        $a3, $a3, $s4
0002FDF0 00F33825 or         $a3, $a3, $s3
0002FDF4 ACC70064 sw         $a3, 0x64($a2)
0002FDF8 24840001 addiu      $a0, $a0, 1
0002FDFC 2C860006 sltiu      $a2, $a0, 6
0002FE00 14C0FFF6 bnez       $a2, 0x2fddc
0002FE04 24A50004 addiu      $a1, $a1, 4
0002FE08 8E0500F0 lw         $a1, 0xf0($s0)
0002FE0C 0C007FF8 jal        0x1ffe0
0002FE10 34040015 ori        $a0, $zero, 0x15
0002FE14 10400004 beqz       $v0, 0x2fe28
0002FE18 00000000 nop        
0002FE1C 3C04002B lui        $a0, 0x2b
0002FE20 0C047B17 jal        0x11ec5c
0002FE24 C48C018C lwc1       $f12, 0x18c($a0)
0002FE28 0C003963 jal        0xe58c
0002FE2C 00000000 nop        
0002FE30 26040AB8 addiu      $a0, $s0, 0xab8
0002FE34 26050030 addiu      $a1, $s0, 0x30
0002FE38 3C06002B lui        $a2, 0x2b
0002FE3C 0C009319 jal        0x24c64
0002FE40 24C60190 addiu      $a2, $a2, 0x190
0002FE44 AE0000D8 sw         $zero, 0xd8($s0)
0002FE48 A2000F84 sb         $zero, 0xf84($s0)
0002FE4C 8E04095C lw         $a0, 0x95c($s0)
0002FE50 3C05FF80 lui        $a1, 0xff80
0002FE54 24A5FFFF addiu      $a1, $a1, -1
0002FE58 00852024 and        $a0, $a0, $a1
0002FE5C AE04095C sw         $a0, 0x95c($s0)
0002FE60 3C043F80 lui        $a0, 0x3f80
0002FE64 44846000 mtc1       $a0, $f12
0002FE68 E60C09DC swc1       $f12, 0x9dc($s0)
0002FE6C 8E040F98 lw         $a0, 0xf98($s0)
0002FE70 8C850064 lw         $a1, 0x64($a0)
0002FE74 30B11420 andi       $s1, $a1, 0x1420
0002FE78 36310001 ori        $s1, $s1, 1
0002FE7C 8C870040 lw         $a3, 0x40($a0)
0002FE80 8CE50004 lw         $a1, 4($a3)
0002FE84 90860044 lbu        $a2, 0x44($a0)
0002FE88 00064100 sll        $t0, $a2, 4
0002FE8C 00C83021 addu       $a2, $a2, $t0
0002FE90 00063080 sll        $a2, $a2, 2
0002FE94 00C83023 subu       $a2, $a2, $t0
0002FE98 00A63021 addu       $a2, $a1, $a2
0002FE9C 24C5000C addiu      $a1, $a2, 0xc
0002FEA0 8CA90000 lw         $t1, ($a1)
0002FEA4 8CA50004 lw         $a1, 4($a1)
0002FEA8 8CC60014 lw         $a2, 0x14($a2)
0002FEAC 90E7004B lbu        $a3, 0x4b($a3)
0002FEB0 8C880064 lw         $t0, 0x64($a0)
0002FEB4 55200001 bnel       $t1, $zero, 0x2febc
0002FEB8 36310080 ori        $s1, $s1, 0x80
0002FEBC 54A00001 bnel       $a1, $zero, 0x2fec4
0002FEC0 36310100 ori        $s1, $s1, 0x100
0002FEC4 54C00001 bnel       $a2, $zero, 0x2fecc
0002FEC8 36310200 ori        $s1, $s1, 0x200
0002FECC 34050001 ori        $a1, $zero, 1
0002FED0 50E50001 beql       $a3, $a1, 0x2fed8
0002FED4 36310800 ori        $s1, $s1, 0x800
0002FED8 31050008 andi       $a1, $t0, 8
0002FEDC 54A00001 bnel       $a1, $zero, 0x2fee4
0002FEE0 36310400 ori        $s1, $s1, 0x400
0002FEE4 36310040 ori        $s1, $s1, 0x40
0002FEE8 00803025 move       $a2, $a0
0002FEEC 02A02025 move       $a0, $s5
0002FEF0 0C01B477 jal        0x6d1dc
0002FEF4 02C02825 move       $a1, $s6
0002FEF8 10400028 beqz       $v0, 0x2ff9c
0002FEFC 8E040F9C lw         $a0, 0xf9c($s0)
0002FF00 C7AC0038 lwc1       $f12, 0x38($sp)
0002FF04 C7AD002C lwc1       $f13, 0x2c($sp)
0002FF08 460D6381 sub.s      $f14, $f12, $f13
0002FF0C C7AC0040 lwc1       $f12, 0x40($sp)
0002FF10 C7AF0034 lwc1       $f15, 0x34($sp)
0002FF14 460F6301 sub.s      $f12, $f12, $f15
0002FF18 3C064100 lui        $a2, 0x4100
0002FF1C 44866800 mtc1       $a2, $f13
0002FF20 460D703E c.le.s     $f14, $f13
0002FF24 00000000 nop        
0002FF28 45000005 bc1f       0x2ff40
0002FF2C 34050000 ori        $a1, $zero, 0
0002FF30 460D603E c.le.s     $f12, $f13
0002FF34 00000000 nop        
0002FF38 45010002 bc1t       0x2ff44
0002FF3C 00000000 nop        
0002FF40 34050001 ori        $a1, $zero, 1
0002FF44 50800009 beql       $a0, $zero, 0x2ff6c
0002FF48 A2050F97 sb         $a1, 0xf97($s0)
0002FF4C 8E060F88 lw         $a2, 0xf88($s0)
0002FF50 10C00004 beqz       $a2, 0x2ff64
0002FF54 AC860000 sw         $a2, ($a0)
0002FF58 8E040F9C lw         $a0, 0xf9c($s0)
0002FF5C 8E060F88 lw         $a2, 0xf88($s0)
0002FF60 ACC40014 sw         $a0, 0x14($a2)
0002FF64 AE000F9C sw         $zero, 0xf9c($s0)
0002FF68 A2050F97 sb         $a1, 0xf97($s0)
0002FF6C 00052100 sll        $a0, $a1, 4
0002FF70 00852823 subu       $a1, $a0, $a1
0002FF74 000528C0 sll        $a1, $a1, 3
0002FF78 00A42023 subu       $a0, $a1, $a0
0002FF7C 00972021 addu       $a0, $a0, $s7
0002FF80 26050F88 addiu      $a1, $s0, 0xf88
0002FF84 02A03025 move       $a2, $s5
0002FF88 02C03825 move       $a3, $s6
0002FF8C 0C022A7D jal        0x8a9f4
0002FF90 02204025 move       $t0, $s1
0002FF94 1000000A b          0x2ffc0
0002FF98 00000000 nop        
0002FF9C 10800008 beqz       $a0, 0x2ffc0
0002FFA0 00000000 nop        
0002FFA4 8E050F88 lw         $a1, 0xf88($s0)
0002FFA8 10A00004 beqz       $a1, 0x2ffbc
0002FFAC AC850000 sw         $a1, ($a0)
0002FFB0 8E040F9C lw         $a0, 0xf9c($s0)
0002FFB4 8E050F88 lw         $a1, 0xf88($s0)
0002FFB8 ACA40014 sw         $a0, 0x14($a1)
0002FFBC AE000F9C sw         $zero, 0xf9c($s0)
0002FFC0 C7B40044 lwc1       $f20, 0x44($sp)
0002FFC4 8FB00048 lw         $s0, 0x48($sp)
0002FFC8 8FB1004C lw         $s1, 0x4c($sp)
0002FFCC 8FB20050 lw         $s2, 0x50($sp)
0002FFD0 8FB30054 lw         $s3, 0x54($sp)
0002FFD4 8FB40058 lw         $s4, 0x58($sp)
0002FFD8 8FB5005C lw         $s5, 0x5c($sp)
0002FFDC 8FB60060 lw         $s6, 0x60($sp)
0002FFE0 8FB70064 lw         $s7, 0x64($sp)
0002FFE4 8FBF0068 lw         $ra, 0x68($sp)
0002FFE8 03E00008 jr         $ra
0002FFEC 27BD0070 addiu      $sp, $sp, 0x70
0002FFF0 27BDFFC0 addiu      $sp, $sp, -0x40
0002FFF4 E7B40020 swc1       $f20, 0x20($sp)
0002FFF8 AFB00024 sw         $s0, 0x24($sp)
0002FFFC AFB10028 sw         $s1, 0x28($sp)
00030000 AFB2002C sw         $s2, 0x2c($sp)
00030004 AFB30030 sw         $s3, 0x30($sp)
00030008 AFB40034 sw         $s4, 0x34($sp)
0003000C AFB50038 sw         $s5, 0x38($sp)
00030010 AFBF003C sw         $ra, 0x3c($sp)
00030014 3C100006 lui        $s0, 6
00030018 2610A838 addiu      $s0, $s0, -0x57c8
0003001C 8E040D90 lw         $a0, 0xd90($s0)
00030020 10800008 beqz       $a0, 0x30044
00030024 46006506 mov.s      $f20, $f12
00030028 8C840010 lw         $a0, 0x10($a0)
0003002C 10800005 beqz       $a0, 0x30044
00030030 00802825 move       $a1, $a0
00030034 00A0F809 jalr       $a1
00030038 02002025 move       $a0, $s0
0003003C 1000002C b          0x300f0
00030040 00000000 nop        
00030044 261100C0 addiu      $s1, $s0, 0xc0
00030048 02202025 move       $a0, $s1
0003004C 00002825 move       $a1, $zero
00030050 0C06B6A7 jal        0x1ada9c
00030054 34060028 ori        $a2, $zero, 0x28
00030058 0C01D56C jal        0x755b0
0003005C 00000000 nop        
00030060 00402825 move       $a1, $v0
00030064 34060002 ori        $a2, $zero, 2
00030068 10A60004 beq        $a1, $a2, 0x3007c
0003006C 34040002 ori        $a0, $zero, 2
00030070 34060010 ori        $a2, $zero, 0x10
00030074 14A60003 bne        $a1, $a2, 0x30084
00030078 00809025 move       $s2, $a0
0003007C 00A02025 move       $a0, $a1
00030080 00809025 move       $s2, $a0
00030084 0C01D56F jal        0x755bc
00030088 00000000 nop        
0003008C 00409825 move       $s3, $v0
00030090 0C01D5AC jal        0x756b0
00030094 02402025 move       $a0, $s2
00030098 AE0200D8 sw         $v0, 0xd8($s0)
0003009C 0C01D622 jal        0x75888
000300A0 02602025 move       $a0, $s3
000300A4 0040A025 move       $s4, $v0
000300A8 92750009 lbu        $s5, 9($s3)
000300AC 8E680004 lw         $t0, 4($s3)
000300B0 8E0900D8 lw         $t1, 0xd8($s0)
000300B4 02002025 move       $a0, $s0
000300B8 02202825 move       $a1, $s1
000300BC 02803025 move       $a2, $s4
000300C0 0C010626 jal        0x41898
000300C4 02A03825 move       $a3, $s5
000300C8 E60000D0 swc1       $f0, 0xd0($s0)
000300CC 8E640004 lw         $a0, 4($s3)
000300D0 AE0400D4 sw         $a0, 0xd4($s0)
000300D4 0C00BCC1 jal        0x2f304
000300D8 02802025 move       $a0, $s4
000300DC E60000DC swc1       $f0, 0xdc($s0)
000300E0 0C00BCC1 jal        0x2f304
000300E4 02A02025 move       $a0, $s5
000300E8 E60000E0 swc1       $f0, 0xe0($s0)
000300EC AE1200E4 sw         $s2, 0xe4($s0)
000300F0 02002025 move       $a0, $s0
000300F4 0C00BEE3 jal        0x2fb8c
000300F8 4600A306 mov.s      $f12, $f20
000300FC 0C00CACD jal        0x32b34
00030100 02002025 move       $a0, $s0
00030104 0C00D4E4 jal        0x35390
00030108 02002025 move       $a0, $s0
0003010C C7B40020 lwc1       $f20, 0x20($sp)
00030110 8FB00024 lw         $s0, 0x24($sp)
00030114 8FB10028 lw         $s1, 0x28($sp)
00030118 8FB2002C lw         $s2, 0x2c($sp)
0003011C 8FB30030 lw         $s3, 0x30($sp)
00030120 8FB40034 lw         $s4, 0x34($sp)
00030124 8FB50038 lw         $s5, 0x38($sp)
00030128 8FBF003C lw         $ra, 0x3c($sp)
0003012C 03E00008 jr         $ra
00030130 27BD0040 addiu      $sp, $sp, 0x40
00030134 848400F8 lh         $a0, 0xf8($a0)
00030138 34060021 ori        $a2, $zero, 0x21
0003013C 10860004 beq        $a0, $a2, 0x30150
00030140 34050000 ori        $a1, $zero, 0
00030144 34060039 ori        $a2, $zero, 0x39
00030148 14860002 bne        $a0, $a2, 0x30154
0003014C 00000000 nop        
00030150 34050001 ori        $a1, $zero, 1
00030154 03E00008 jr         $ra
00030158 30A200FF andi       $v0, $a1, 0xff
0003015C 27BDFF80 addiu      $sp, $sp, -0x80
00030160 AFB00050 sw         $s0, 0x50($sp)
00030164 AFB10054 sw         $s1, 0x54($sp)
00030168 AFB20058 sw         $s2, 0x58($sp)
0003016C AFB3005C sw         $s3, 0x5c($sp)
00030170 AFB40060 sw         $s4, 0x60($sp)
00030174 AFB50064 sw         $s5, 0x64($sp)
00030178 AFB60068 sw         $s6, 0x68($sp)
0003017C AFB7006C sw         $s7, 0x6c($sp)

# 000360A4..00036240
000360A4 27BDFFE0 addiu      $sp, $sp, -0x20
000360A8 E7B40010 swc1       $f20, 0x10($sp)
000360AC AFB00014 sw         $s0, 0x14($sp)
000360B0 AFBF0018 sw         $ra, 0x18($sp)
000360B4 46006506 mov.s      $f20, $f12
000360B8 00808025 move       $s0, $a0
000360BC C60C0570 lwc1       $f12, 0x570($s0)
000360C0 3C043C88 lui        $a0, 0x3c88
000360C4 3484893B ori        $a0, $a0, 0x893b
000360C8 0C06975A jal        0x1a5d68
000360CC 44846800 mtc1       $a0, $f13
000360D0 E614056C swc1       $f20, 0x56c($s0)
000360D4 46140300 add.s      $f12, $f0, $f20
000360D8 E60C0570 swc1       $f12, 0x570($s0)
000360DC C60C0574 lwc1       $f12, 0x574($s0)
000360E0 46146300 add.s      $f12, $f12, $f20
000360E4 E60C0574 swc1       $f12, 0x574($s0)
000360E8 3C0441F0 lui        $a0, 0x41f0
000360EC 44846000 mtc1       $a0, $f12
000360F0 460CA302 mul.s      $f12, $f20, $f12
000360F4 E60C0578 swc1       $f12, 0x578($s0)
000360F8 C60C0584 lwc1       $f12, 0x584($s0)
000360FC 46146300 add.s      $f12, $f12, $f20
00036100 E60C0584 swc1       $f12, 0x584($s0)
00036104 C60C0588 lwc1       $f12, 0x588($s0)
00036108 46146300 add.s      $f12, $f12, $f20
0003610C E60C0588 swc1       $f12, 0x588($s0)
00036110 C60C058C lwc1       $f12, 0x58c($s0)
00036114 46146300 add.s      $f12, $f12, $f20
00036118 E60C058C swc1       $f12, 0x58c($s0)
0003611C 860400F8 lh         $a0, 0xf8($s0)
00036120 10800009 beqz       $a0, 0x36148
00036124 34050001 ori        $a1, $zero, 1
00036128 10850007 beq        $a0, $a1, 0x36148
0003612C 34050024 ori        $a1, $zero, 0x24
00036130 10850005 beq        $a0, $a1, 0x36148
00036134 00000000 nop        
00036138 C60C057C lwc1       $f12, 0x57c($s0)
0003613C 46146300 add.s      $f12, $f12, $f20
00036140 10000004 b          0x36154
00036144 E60C057C swc1       $f12, 0x57c($s0)
00036148 C60C0580 lwc1       $f12, 0x580($s0)
0003614C 46146300 add.s      $f12, $f12, $f20
00036150 E60C0580 swc1       $f12, 0x580($s0)
00036154 0C003961 jal        0xe584
00036158 C60C0570 lwc1       $f12, 0x570($s0)
0003615C C7B40010 lwc1       $f20, 0x10($sp)
00036160 8FB00014 lw         $s0, 0x14($sp)
00036164 8FBF0018 lw         $ra, 0x18($sp)
00036168 03E00008 jr         $ra
0003616C 27BD0020 addiu      $sp, $sp, 0x20
00036170 27BDFFD0 addiu      $sp, $sp, -0x30
00036174 E7B40020 swc1       $f20, 0x20($sp)
00036178 AFB00024 sw         $s0, 0x24($sp)
0003617C AFBF0028 sw         $ra, 0x28($sp)
00036180 00808025 move       $s0, $a0
00036184 0C00F11C jal        0x3c470
00036188 34050001 ori        $a1, $zero, 1
0003618C 8E040360 lw         $a0, 0x360($s0)
00036190 34050052 ori        $a1, $zero, 0x52
00036194 14850022 bne        $a0, $a1, 0x36220
00036198 00000000 nop        
0003619C 0C01AA78 jal        0x6a9e0
000361A0 8E040594 lw         $a0, 0x594($s0)
000361A4 C60C096C lwc1       $f12, 0x96c($s0)
000361A8 E60C0204 swc1       $f12, 0x204($s0)
000361AC C60C0970 lwc1       $f12, 0x970($s0)
000361B0 E60C0208 swc1       $f12, 0x208($s0)
000361B4 C60C0974 lwc1       $f12, 0x974($s0)
000361B8 E60C020C swc1       $f12, 0x20c($s0)
000361BC 3C043F80 lui        $a0, 0x3f80
000361C0 44846000 mtc1       $a0, $f12
000361C4 E60C0260 swc1       $f12, 0x260($s0)
000361C8 4480A000 mtc1       $zero, $f20
000361CC E6140234 swc1       $f20, 0x234($s0)
000361D0 0C0106CF jal        0x41b3c
000361D4 02002025 move       $a0, $s0
000361D8 02002025 move       $a0, $s0
000361DC 0C00D8BA jal        0x362e8
000361E0 00002825 move       $a1, $zero
000361E4 1040000C beqz       $v0, 0x36218
000361E8 00000000 nop        
000361EC 3404003C ori        $a0, $zero, 0x3c
000361F0 AE040980 sw         $a0, 0x980($s0)
000361F4 3C043E19 lui        $a0, 0x3e19
000361F8 3484999A ori        $a0, $a0, 0x999a
000361FC 44846000 mtc1       $a0, $f12
00036200 02002025 move       $a0, $s0
00036204 34050053 ori        $a1, $zero, 0x53
00036208 00003025 move       $a2, $zero
0003620C 34070001 ori        $a3, $zero, 1
00036210 0C00D8A6 jal        0x36298
00036214 4600A346 mov.s      $f13, $f20
00036218 1000001A b          0x36284
0003621C 00000000 nop        
00036220 34050053 ori        $a1, $zero, 0x53
00036224 14850011 bne        $a0, $a1, 0x3626c
00036228 00000000 nop        
0003622C 8E040980 lw         $a0, 0x980($s0)
00036230 2484FFFF addiu      $a0, $a0, -1
00036234 AE040980 sw         $a0, 0x980($s0)
00036238 14800012 bnez       $a0, 0x36284
0003623C 00000000 nop        

# 00039B74..00039CC0
00039B74 27BDFF90 addiu      $sp, $sp, -0x70
00039B78 E7B40040 swc1       $f20, 0x40($sp)
00039B7C E7B60044 swc1       $f22, 0x44($sp)
00039B80 E7B80048 swc1       $f24, 0x48($sp)
00039B84 AFB0004C sw         $s0, 0x4c($sp)
00039B88 AFB10050 sw         $s1, 0x50($sp)
00039B8C AFB20054 sw         $s2, 0x54($sp)
00039B90 AFB30058 sw         $s3, 0x58($sp)
00039B94 AFB4005C sw         $s4, 0x5c($sp)
00039B98 AFBF0060 sw         $ra, 0x60($sp)
00039B9C 46006506 mov.s      $f20, $f12
00039BA0 00808025 move       $s0, $a0
00039BA4 0C00C79A jal        0x31e68
00039BA8 00000000 nop        
00039BAC 0C010B01 jal        0x42c04
00039BB0 02002025 move       $a0, $s0
00039BB4 0C015883 jal        0x5620c
00039BB8 02002025 move       $a0, $s0
00039BBC 0C011DEA jal        0x477a8
00039BC0 02002025 move       $a0, $s0
00039BC4 0C01168F jal        0x45a3c
00039BC8 02002025 move       $a0, $s0
00039BCC 0C014175 jal        0x505d4
00039BD0 02002025 move       $a0, $s0
00039BD4 0C012BE4 jal        0x4af90
00039BD8 02002025 move       $a0, $s0
00039BDC 0C013CEB jal        0x4f3ac
00039BE0 02002025 move       $a0, $s0
00039BE4 0C00CA28 jal        0x328a0
00039BE8 02002025 move       $a0, $s0
00039BEC 0C00E7F5 jal        0x39fd4
00039BF0 02002025 move       $a0, $s0
00039BF4 0C00C41E jal        0x31078
00039BF8 02002025 move       $a0, $s0
00039BFC 3411000D ori        $s1, $zero, 0xd
00039C00 3C043F80 lui        $a0, 0x3f80
00039C04 4484B000 mtc1       $a0, $f22
00039C08 4480C000 mtc1       $zero, $f24
00039C0C 261205E4 addiu      $s2, $s0, 0x5e4
00039C10 10400037 beqz       $v0, 0x39cf0
00039C14 261307A0 addiu      $s3, $s0, 0x7a0
00039C18 C60C0030 lwc1       $f12, 0x30($s0)
00039C1C C60D0A20 lwc1       $f13, 0xa20($s0)
00039C20 460D6300 add.s      $f12, $f12, $f13
00039C24 E60C0030 swc1       $f12, 0x30($s0)
00039C28 C60C0034 lwc1       $f12, 0x34($s0)
00039C2C C60E0A24 lwc1       $f14, 0xa24($s0)
00039C30 460E6300 add.s      $f12, $f12, $f14
00039C34 E60C0034 swc1       $f12, 0x34($s0)
00039C38 C60C0038 lwc1       $f12, 0x38($s0)
00039C3C C60F0A28 lwc1       $f15, 0xa28($s0)
00039C40 460F6300 add.s      $f12, $f12, $f15
00039C44 E60C0038 swc1       $f12, 0x38($s0)
00039C48 C60C02D0 lwc1       $f12, 0x2d0($s0)
00039C4C 460E6300 add.s      $f12, $f12, $f14
00039C50 E60C02D0 swc1       $f12, 0x2d0($s0)
00039C54 3C04002D lui        $a0, 0x2d
00039C58 C48CA358 lwc1       $f12, -0x5ca8($a0)
00039C5C E60C0A20 swc1       $f12, 0xa20($s0)
00039C60 2484A358 addiu      $a0, $a0, -0x5ca8
00039C64 C48C0004 lwc1       $f12, 4($a0)
00039C68 E60C0A24 swc1       $f12, 0xa24($s0)
00039C6C C48C0008 lwc1       $f12, 8($a0)
00039C70 E60C0A28 swc1       $f12, 0xa28($s0)
00039C74 C48C000C lwc1       $f12, 0xc($a0)
00039C78 E60C0A2C swc1       $f12, 0xa2c($s0)
00039C7C 260401F4 addiu      $a0, $s0, 0x1f4
00039C80 26140A30 addiu      $s4, $s0, 0xa30
00039C84 02802825 move       $a1, $s4
00039C88 0C03D419 jal        0xf5064
00039C8C 00803025 move       $a2, $a0
00039C90 26040204 addiu      $a0, $s0, 0x204
00039C94 02802825 move       $a1, $s4
00039C98 0C03D419 jal        0xf5064
00039C9C 00803025 move       $a2, $a0
00039CA0 3C04002D lui        $a0, 0x2d
00039CA4 8C85A2F8 lw         $a1, -0x5d08($a0)
00039CA8 2484A2F8 addiu      $a0, $a0, -0x5d08
00039CAC 8C860004 lw         $a2, 4($a0)
00039CB0 8C870008 lw         $a3, 8($a0)
00039CB4 AE850000 sw         $a1, ($s4)
00039CB8 AE860004 sw         $a2, 4($s4)
00039CBC AE870008 sw         $a3, 8($s4)

# 0001EBC4..0001ED40
0001EBC4 27BDFFB0 addiu      $sp, $sp, -0x50
0001EBC8 848500F8 lh         $a1, 0xf8($a0)
0001EBCC E7B40030 swc1       $f20, 0x30($sp)
0001EBD0 AFB2003C sw         $s2, 0x3c($sp)
0001EBD4 46006506 mov.s      $f20, $f12
0001EBD8 249200C0 addiu      $s2, $a0, 0xc0
0001EBDC 34060021 ori        $a2, $zero, 0x21
0001EBE0 AFB00034 sw         $s0, 0x34($sp)
0001EBE4 AFB10038 sw         $s1, 0x38($sp)
0001EBE8 AFB30040 sw         $s3, 0x40($sp)
0001EBEC AFB40044 sw         $s4, 0x44($sp)
0001EBF0 AFBF0048 sw         $ra, 0x48($sp)
0001EBF4 10A60008 beq        $a1, $a2, 0x1ec18
0001EBF8 00808025 move       $s0, $a0
0001EBFC 8E04095C lw         $a0, 0x95c($s0)
0001EC00 3C051000 lui        $a1, 0x1000
0001EC04 00852024 and        $a0, $a0, $a1
0001EC08 14800005 bnez       $a0, 0x1ec20
0001EC0C 00000000 nop        
0001EC10 1000000C b          0x1ec44
0001EC14 00000000 nop        
0001EC18 100001D4 b          0x1f36c
0001EC1C 00000000 nop        
0001EC20 8E04059C lw         $a0, 0x59c($s0)
0001EC24 10800005 beqz       $a0, 0x1ec3c
0001EC28 00000000 nop        
0001EC2C 8E04059C lw         $a0, 0x59c($s0)
0001EC30 8C850064 lw         $a1, 0x64($a0)
0001EC34 34A50020 ori        $a1, $a1, 0x20
0001EC38 AC850064 sw         $a1, 0x64($a0)
0001EC3C 100001CB b          0x1f36c
0001EC40 00000000 nop        
0001EC44 8E04059C lw         $a0, 0x59c($s0)
0001EC48 10800006 beqz       $a0, 0x1ec64
0001EC4C 00000000 nop        
0001EC50 8E04059C lw         $a0, 0x59c($s0)
0001EC54 2405FFDF addiu      $a1, $zero, -0x21
0001EC58 8C860064 lw         $a2, 0x64($a0)
0001EC5C 00C52824 and        $a1, $a2, $a1
0001EC60 AC850064 sw         $a1, 0x64($a0)
0001EC64 920409C5 lbu        $a0, 0x9c5($s0)
0001EC68 10800003 beqz       $a0, 0x1ec78
0001EC6C 00000000 nop        
0001EC70 8E040998 lw         $a0, 0x998($s0)
0001EC74 AE0409B4 sw         $a0, 0x9b4($s0)
0001EC78 8E0409BC lw         $a0, 0x9bc($s0)
0001EC7C 2C85000D sltiu      $a1, $a0, 0xd
0001EC80 10A00170 beqz       $a1, 0x1f244
0001EC84 34110000 ori        $s1, $zero, 0
0001EC88 00042080 sll        $a0, $a0, 2
0001EC8C 3C01001C lui        $at, 0x1c
0001EC90 00240821 addu       $at, $at, $a0
0001EC94 8C210450 lw         $at, 0x450($at)
0001EC98 00200008 jr         $at
0001EC9C 00000000 nop        
0001ECA0 8E0409B8 lw         $a0, 0x9b8($s0)
0001ECA4 10800013 beqz       $a0, 0x1ecf4
0001ECA8 00000000 nop        
0001ECAC 8E040998 lw         $a0, 0x998($s0)
0001ECB0 34050001 ori        $a1, $zero, 1
0001ECB4 54850006 bnel       $a0, $a1, 0x1ecd0
0001ECB8 8E04095C lw         $a0, 0x95c($s0)
0001ECBC 0C0077D7 jal        0x1df5c
0001ECC0 02002025 move       $a0, $s0
0001ECC4 10400005 beqz       $v0, 0x1ecdc
0001ECC8 00000000 nop        
0001ECCC 8E04095C lw         $a0, 0x95c($s0)
0001ECD0 30840800 andi       $a0, $a0, 0x800
0001ECD4 10800007 beqz       $a0, 0x1ecf4
0001ECD8 00000000 nop        
0001ECDC 8E0409A0 lw         $a0, 0x9a0($s0)
0001ECE0 8E0509B8 lw         $a1, 0x9b8($s0)
0001ECE4 AE0409A4 sw         $a0, 0x9a4($s0)
0001ECE8 AE0509A0 sw         $a1, 0x9a0($s0)
0001ECEC 10000155 b          0x1f244
0001ECF0 AE0009B8 sw         $zero, 0x9b8($s0)
0001ECF4 920409C7 lbu        $a0, 0x9c7($s0)
0001ECF8 10800003 beqz       $a0, 0x1ed08
0001ECFC 00000000 nop        
0001ED00 10000150 b          0x1f244
0001ED04 AE0009B8 sw         $zero, 0x9b8($s0)
0001ED08 8E1309B8 lw         $s3, 0x9b8($s0)
0001ED0C 1260000C beqz       $s3, 0x1ed40
0001ED10 AE0009B8 sw         $zero, 0x9b8($s0)
0001ED14 8E040998 lw         $a0, 0x998($s0)
0001ED18 12640009 beq        $s3, $a0, 0x1ed40
0001ED1C 00000000 nop        
0001ED20 12600007 beqz       $s3, 0x1ed40
0001ED24 00000000 nop        
0001ED28 0C00C41E jal        0x31078
0001ED2C 02002025 move       $a0, $s0
0001ED30 10400003 beqz       $v0, 0x1ed40
0001ED34 00000000 nop        
0001ED38 1000002C b          0x1edec
0001ED3C AE13099C sw         $s3, 0x99c($s0)

# 000965A0..000966E0
000965A0 14E0FFF8 bnez       $a3, 0x96584
000965A4 26730004 addiu      $s3, $s3, 4
000965A8 14A00002 bnez       $a1, 0x965b4
000965AC 00000000 nop        
000965B0 A2806E50 sb         $zero, 0x6e50($s4)
000965B4 10000010 b          0x965f8
000965B8 00000000 nop        
000965BC 34050001 ori        $a1, $zero, 1
000965C0 34060000 ori        $a2, $zero, 0
000965C4 8E670000 lw         $a3, ($s3)
000965C8 2CE7001F sltiu      $a3, $a3, 0x1f
000965CC 10E00002 beqz       $a3, 0x965d8
000965D0 00000000 nop        
000965D4 34050000 ori        $a1, $zero, 0
000965D8 24C60001 addiu      $a2, $a2, 1
000965DC 2CC70003 sltiu      $a3, $a2, 3
000965E0 14E0FFF8 bnez       $a3, 0x965c4
000965E4 26730004 addiu      $s3, $s3, 4
000965E8 10A00003 beqz       $a1, 0x965f8
000965EC 00000000 nop        
000965F0 34050001 ori        $a1, $zero, 1
000965F4 A2856E50 sb         $a1, 0x6e50($s4)
000965F8 24840001 addiu      $a0, $a0, 1
000965FC AE446E54 sw         $a0, 0x6e54($s2)
00096600 0C005308 jal        0x14c20
00096604 34040004 ori        $a0, $zero, 4
00096608 10400003 beqz       $v0, 0x96618
0009660C 00000000 nop        
00096610 12000003 beqz       $s0, 0x96620
00096614 00000000 nop        
00096618 34040001 ori        $a0, $zero, 1
0009661C A2846E50 sb         $a0, 0x6e50($s4)
00096620 92846E50 lbu        $a0, 0x6e50($s4)
00096624 10800010 beqz       $a0, 0x96668
00096628 00000000 nop        
0009662C 0C06FD09 jal        0x1bf424
00096630 00000000 nop        
00096634 3C10002B lui        $s0, 0x2b
00096638 0C06FD0B jal        0x1bf42c
0009663C 00000000 nop        
00096640 8E046E58 lw         $a0, 0x6e58($s0)
00096644 24840001 addiu      $a0, $a0, 1
00096648 14440003 bne        $v0, $a0, 0x96658
0009664C 00000000 nop        
00096650 0C06FD09 jal        0x1bf424
00096654 00000000 nop        
00096658 0C06FD0B jal        0x1bf42c
0009665C 00000000 nop        
00096660 10000003 b          0x96670
00096664 AE026E58 sw         $v0, 0x6e58($s0)
00096668 0C06FD2D jal        0x1bf4b4
0009666C 34040064 ori        $a0, $zero, 0x64
00096670 0C06DD20 jal        0x1b7480
00096674 00000000 nop        
00096678 AE226DF4 sw         $v0, 0x6df4($s1)
0009667C 8FB00010 lw         $s0, 0x10($sp)
00096680 8FB10014 lw         $s1, 0x14($sp)
00096684 8FB20018 lw         $s2, 0x18($sp)
00096688 8FB3001C lw         $s3, 0x1c($sp)
0009668C 8FB40020 lw         $s4, 0x20($sp)
00096690 8FBF0024 lw         $ra, 0x24($sp)
00096694 03E00008 jr         $ra
00096698 27BD0030 addiu      $sp, $sp, 0x30
0009669C 27BDFFE0 addiu      $sp, $sp, -0x20
000966A0 AFB10014 sw         $s1, 0x14($sp)
000966A4 00808825 move       $s1, $a0
000966A8 AFB00010 sw         $s0, 0x10($sp)
000966AC 00A08025 move       $s0, $a1
000966B0 8E240010 lw         $a0, 0x10($s1)
000966B4 8E250000 lw         $a1, ($s1)
000966B8 AFBF0018 sw         $ra, 0x18($sp)
000966BC 0C06DCD9 jal        0x1b7364
000966C0 9626000C lhu        $a2, 0xc($s1)
000966C4 8E240004 lw         $a0, 4($s1)
000966C8 0C06DCEC jal        0x1b73b0
000966CC 9625000C lhu        $a1, 0xc($s1)
000966D0 96240008 lhu        $a0, 8($s1)
000966D4 00043043 sra        $a2, $a0, 1
000966D8 9625000A lhu        $a1, 0xa($s1)
000966DC 000637C2 srl        $a2, $a2, 0x1f

# 001BF424..001BF43C
001BF424 03E00008 jr         $ra
001BF428 00000000 nop        
001BF42C 03E00008 jr         $ra
001BF430 00000000 nop        
001BF434 03E00008 jr         $ra
001BF438 00000000 nop        
