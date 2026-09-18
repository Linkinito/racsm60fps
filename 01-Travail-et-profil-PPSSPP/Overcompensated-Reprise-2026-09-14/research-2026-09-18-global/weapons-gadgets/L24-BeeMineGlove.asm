
CALLBACK 0x0010C038 end 0x0010C1C0 ordinal 0

0010C038 27BDFFC0 addiu      $sp, $sp, -0x40
0010C03C AFB00020 sw         $s0, 0x20($sp)
0010C040 00808025 move       $s0, $a0
0010C044 AFB10024 sw         $s1, 0x24($sp)
0010C048 8E110058 lw         $s1, 0x58($s0)
0010C04C 00002825 move       $a1, $zero
0010C050 02202025 move       $a0, $s1
0010C054 AFB20028 sw         $s2, 0x28($sp)
0010C058 AFB3002C sw         $s3, 0x2c($sp)
0010C05C AFB40030 sw         $s4, 0x30($sp)
0010C060 AFB50034 sw         $s5, 0x34($sp)
0010C064 AFBF0038 sw         $ra, 0x38($sp)
0010C068 0C0600AC jal        0x1802b0
0010C06C 34060048 ori        $a2, $zero, 0x48
0010C070 3C080028 lui        $t0, 0x28
0010C074 2624001C addiu      $a0, $s1, 0x1c
0010C078 34150001 ori        $s5, $zero, 1
0010C07C 34050001 ori        $a1, $zero, 1
0010C080 34060044 ori        $a2, $zero, 0x44
0010C084 34070045 ori        $a3, $zero, 0x45
0010C088 0C01859E jal        0x61678
0010C08C 25082090 addiu      $t0, $t0, 0x2090
0010C090 3C140028 lui        $s4, 0x28
0010C094 8E93F8D8 lw         $s3, -0x728($s4)
0010C098 A2000046 sb         $zero, 0x46($s0)
0010C09C 8E040048 lw         $a0, 0x48($s0)
0010C0A0 3C050011 lui        $a1, 0x11
0010C0A4 24A5C400 addiu      $a1, $a1, -0x3c00
0010C0A8 AC8500DC sw         $a1, 0xdc($a0)
0010C0AC 8E6600F0 lw         $a2, 0xf0($s3)
0010C0B0 34040004 ori        $a0, $zero, 4
0010C0B4 0C0076E2 jal        0x1db88
0010C0B8 3405000D ori        $a1, $zero, 0xd
0010C0BC 304400FF andi       $a0, $v0, 0xff
0010C0C0 308500FF andi       $a1, $a0, 0xff
0010C0C4 96040074 lhu        $a0, 0x74($s0)
0010C0C8 3C12002A lui        $s2, 0x2a
0010C0CC 10A00006 beqz       $a1, 0x10c0e8
0010C0D0 3C11002A lui        $s1, 0x2a
0010C0D4 2405FFFD addiu      $a1, $zero, -3
0010C0D8 00852024 and        $a0, $a0, $a1
0010C0DC A6040074 sh         $a0, 0x74($s0)
0010C0E0 10000004 b          0x10c0f4
0010C0E4 8E6400F0 lw         $a0, 0xf0($s3)
0010C0E8 34840002 ori        $a0, $a0, 2
0010C0EC A6040074 sh         $a0, 0x74($s0)
0010C0F0 8E6400F0 lw         $a0, 0xf0($s3)
0010C0F4 00803025 move       $a2, $a0
0010C0F8 34040004 ori        $a0, $zero, 4
0010C0FC 0C0076E2 jal        0x1db88
0010C100 3405000E ori        $a1, $zero, 0xe
0010C104 304400FF andi       $a0, $v0, 0xff
0010C108 308500FF andi       $a1, $a0, 0xff
0010C10C 10A00008 beqz       $a1, 0x10c130
0010C110 96040074 lhu        $a0, 0x74($s0)
0010C114 2405FFFB addiu      $a1, $zero, -5
0010C118 00852024 and        $a0, $a0, $a1
0010C11C A6040074 sh         $a0, 0x74($s0)
0010C120 8E94F8D8 lw         $s4, -0x728($s4)
0010C124 C64DD574 lwc1       $f13, -0x2a8c($s2)
0010C128 10000006 b          0x10c144
0010C12C C62CD578 lwc1       $f12, -0x2a88($s1)
0010C130 34840004 ori        $a0, $a0, 4
0010C134 A6040074 sh         $a0, 0x74($s0)
0010C138 8E94F8D8 lw         $s4, -0x728($s4)
0010C13C C64DD574 lwc1       $f13, -0x2a8c($s2)
0010C140 C62CD578 lwc1       $f12, -0x2a88($s1)
0010C144 46006386 mov.s      $f14, $f12
0010C148 3C05002A lui        $a1, 0x2a
0010C14C 46006B06 mov.s      $f12, $f13
0010C150 3C06002A lui        $a2, 0x2a
0010C154 46007346 mov.s      $f13, $f14
0010C158 3C084120 lui        $t0, 0x4120
0010C15C 02802025 move       $a0, $s4
0010C160 44887000 mtc1       $t0, $f14
0010C164 00003825 move       $a3, $zero
0010C168 24A5D568 addiu      $a1, $a1, -0x2a98
0010C16C 0C01569F jal        0x55a7c
0010C170 24C6D580 addiu      $a2, $a2, -0x2a80
0010C174 8E6600F0 lw         $a2, 0xf0($s3)
0010C178 26040074 addiu      $a0, $s0, 0x74
0010C17C 34050006 ori        $a1, $zero, 6
0010C180 0C006F54 jal        0x1bd50
0010C184 2407FFFF addiu      $a3, $zero, -1
0010C188 8E040064 lw         $a0, 0x64($s0)
0010C18C 3C050004 lui        $a1, 4
0010C190 00852025 or         $a0, $a0, $a1
0010C194 AE040064 sw         $a0, 0x64($s0)
0010C198 02A01025 move       $v0, $s5
0010C19C 8FB00020 lw         $s0, 0x20($sp)
0010C1A0 8FB10024 lw         $s1, 0x24($sp)
0010C1A4 8FB20028 lw         $s2, 0x28($sp)
0010C1A8 8FB3002C lw         $s3, 0x2c($sp)
0010C1AC 8FB40030 lw         $s4, 0x30($sp)
0010C1B0 8FB50034 lw         $s5, 0x34($sp)
0010C1B4 8FBF0038 lw         $ra, 0x38($sp)
0010C1B8 03E00008 jr         $ra
0010C1BC 27BD0040 addiu      $sp, $sp, 0x40

CALLBACK 0x0010C1C0 end 0x0010C1EC ordinal 1

0010C1C0 27BDFFE0 addiu      $sp, $sp, -0x20
0010C1C4 8C840058 lw         $a0, 0x58($a0)
0010C1C8 8C840000 lw         $a0, ($a0)
0010C1CC AFBF0010 sw         $ra, 0x10($sp)
0010C1D0 10800003 beqz       $a0, 0x10c1e0
0010C1D4 00000000 nop        
0010C1D8 0C00A7B3 jal        0x29ecc
0010C1DC 34050001 ori        $a1, $zero, 1
0010C1E0 8FBF0010 lw         $ra, 0x10($sp)
0010C1E4 03E00008 jr         $ra
0010C1E8 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0010C1EC end 0x0010C400 ordinal 2

0010C1EC 27BDFFB0 addiu      $sp, $sp, -0x50
0010C1F0 AFB00030 sw         $s0, 0x30($sp)
0010C1F4 00808025 move       $s0, $a0
0010C1F8 AFB20038 sw         $s2, 0x38($sp)
0010C1FC 8E120058 lw         $s2, 0x58($s0)
0010C200 E7B40028 swc1       $f20, 0x28($sp)
0010C204 AFB10034 sw         $s1, 0x34($sp)
0010C208 46006506 mov.s      $f20, $f12
0010C20C 34040006 ori        $a0, $zero, 6
0010C210 8E510000 lw         $s1, ($s2)
0010C214 E7B6002C swc1       $f22, 0x2c($sp)
0010C218 AFB3003C sw         $s3, 0x3c($sp)
0010C21C AFB40040 sw         $s4, 0x40($sp)
0010C220 AFBF0044 sw         $ra, 0x44($sp)
0010C224 0C007541 jal        0x1d504
0010C228 8E2500F0 lw         $a1, 0xf0($s1)
0010C22C 27A40020 addiu      $a0, $sp, 0x20
0010C230 0C00A9C4 jal        0x2a710
0010C234 02202825 move       $a1, $s1
0010C238 02202025 move       $a0, $s1
0010C23C 0C00A7B3 jal        0x29ecc
0010C240 00002825 move       $a1, $zero
0010C244 C64C0018 lwc1       $f12, 0x18($s2)
0010C248 4480B000 mtc1       $zero, $f22
0010C24C 46166032 c.eq.s     $f12, $f22
0010C250 00000000 nop        
0010C254 4501001D bc1t       0x10c2cc
0010C258 00000000 nop        
0010C25C 46146301 sub.s      $f12, $f12, $f20
0010C260 02202025 move       $a0, $s1
0010C264 0C00A905 jal        0x2a414
0010C268 E64C0018 swc1       $f12, 0x18($s2)
0010C26C C64C0018 lwc1       $f12, 0x18($s2)
0010C270 4616603E c.le.s     $f12, $f22
0010C274 00000000 nop        
0010C278 45010011 bc1t       0x10c2c0
0010C27C 00402025 move       $a0, $v0
0010C280 8FA50020 lw         $a1, 0x20($sp)
0010C284 30A50020 andi       $a1, $a1, 0x20
0010C288 10A00010 beqz       $a1, 0x10c2cc
0010C28C 3405001E ori        $a1, $zero, 0x1e
0010C290 1085000E beq        $a0, $a1, 0x10c2cc
0010C294 34050001 ori        $a1, $zero, 1
0010C298 1085000C beq        $a0, $a1, 0x10c2cc
0010C29C 3C04002A lui        $a0, 0x2a
0010C2A0 C48DD58C lwc1       $f13, -0x2a74($a0)
0010C2A4 3C04002A lui        $a0, 0x2a
0010C2A8 C48ED590 lwc1       $f14, -0x2a70($a0)
0010C2AC 460E6B41 sub.s      $f13, $f13, $f14
0010C2B0 460D603E c.le.s     $f12, $f13
0010C2B4 00000000 nop        
0010C2B8 45000004 bc1f       0x10c2cc
0010C2BC 00000000 nop        
0010C2C0 E6560018 swc1       $f22, 0x18($s2)
0010C2C4 34040001 ori        $a0, $zero, 1
0010C2C8 A2040046 sb         $a0, 0x46($s0)
0010C2CC C64C0014 lwc1       $f12, 0x14($s2)
0010C2D0 46146301 sub.s      $f12, $f12, $f20
0010C2D4 4616603C c.lt.s     $f12, $f22
0010C2D8 00000000 nop        
0010C2DC 45000002 bc1f       0x10c2e8
0010C2E0 E64C0014 swc1       $f12, 0x14($s2)
0010C2E4 E6560014 swc1       $f22, 0x14($s2)
0010C2E8 8E440010 lw         $a0, 0x10($s2)
0010C2EC 34050004 ori        $a1, $zero, 4
0010C2F0 14850007 bne        $a0, $a1, 0x10c310
0010C2F4 00000000 nop        
0010C2F8 02002025 move       $a0, $s0
0010C2FC 0C019491 jal        0x65244
0010C300 00002825 move       $a1, $zero
0010C304 10400002 beqz       $v0, 0x10c310
0010C308 00000000 nop        
0010C30C A2000045 sb         $zero, 0x45($s0)
0010C310 0C00A900 jal        0x2a400
0010C314 02202025 move       $a0, $s1
0010C318 1040002F beqz       $v0, 0x10c3d8
0010C31C 00000000 nop        
0010C320 C64C0014 lwc1       $f12, 0x14($s2)
0010C324 46166032 c.eq.s     $f12, $f22
0010C328 00000000 nop        
0010C32C 4500002A bc1f       0x10c3d8
0010C330 00000000 nop        
0010C334 0C0070C3 jal        0x1c30c
0010C338 02202025 move       $a0, $s1
0010C33C 10400026 beqz       $v0, 0x10c3d8
0010C340 00000000 nop        
0010C344 8FA40020 lw         $a0, 0x20($sp)
0010C348 30840020 andi       $a0, $a0, 0x20
0010C34C 10800022 beqz       $a0, 0x10c3d8
0010C350 00000000 nop        
0010C354 02409825 move       $s3, $s2
0010C358 0C00A99C jal        0x2a670
0010C35C 02202025 move       $a0, $s1
0010C360 0040A025 move       $s4, $v0
0010C364 0C0155F5 jal        0x557d4
0010C368 02202025 move       $a0, $s1
0010C36C 26720004 addiu      $s2, $s3, 4
0010C370 3C09002A lui        $t1, 0x2a
0010C374 2668001C addiu      $t0, $s3, 0x1c
0010C378 02002025 move       $a0, $s0
0010C37C 02802825 move       $a1, $s4
0010C380 00403025 move       $a2, $v0
0010C384 02403825 move       $a3, $s2
0010C388 00005025 move       $t2, $zero
0010C38C 00005825 move       $t3, $zero
0010C390 0C015AE8 jal        0x56ba0
0010C394 2529D5A8 addiu      $t1, $t1, -0x2a58
0010C398 A2620045 sb         $v0, 0x45($s3)
0010C39C 92640045 lbu        $a0, 0x45($s3)
0010C3A0 1080000D beqz       $a0, 0x10c3d8
0010C3A4 00000000 nop        
0010C3A8 92040045 lbu        $a0, 0x45($s0)
0010C3AC 10800003 beqz       $a0, 0x10c3bc
0010C3B0 34050005 ori        $a1, $zero, 5
0010C3B4 14850008 bne        $a0, $a1, 0x10c3d8
0010C3B8 00000000 nop        
0010C3BC 8E2400D4 lw         $a0, 0xd4($s1)
0010C3C0 30842000 andi       $a0, $a0, 0x2000
0010C3C4 10800004 beqz       $a0, 0x10c3d8
0010C3C8 00000000 nop        
0010C3CC 02002025 move       $a0, $s0
0010C3D0 0C0431BC jal        0x10c6f0
0010C3D4 02402825 move       $a1, $s2
0010C3D8 C7B40028 lwc1       $f20, 0x28($sp)
0010C3DC C7B6002C lwc1       $f22, 0x2c($sp)
0010C3E0 8FB00030 lw         $s0, 0x30($sp)
0010C3E4 8FB10034 lw         $s1, 0x34($sp)
0010C3E8 8FB20038 lw         $s2, 0x38($sp)
0010C3EC 8FB3003C lw         $s3, 0x3c($sp)
0010C3F0 8FB40040 lw         $s4, 0x40($sp)
0010C3F4 8FBF0044 lw         $ra, 0x44($sp)
0010C3F8 03E00008 jr         $ra
0010C3FC 27BD0050 addiu      $sp, $sp, 0x50