
CALLBACK 0x0015CCD0 end 0x0015CCD8 ordinal 0

0015CCD0 03E00008 jr         $ra
0015CCD4 34020001 ori        $v0, $zero, 1

CALLBACK 0x0015CCD8 end 0x0015CCE0 ordinal 1

0015CCD8 03E00008 jr         $ra
0015CCDC 00000000 nop        

CALLBACK 0x0015CCE0 end 0x0015CE28 ordinal 2

0015CCE0 27BDFFE0 addiu      $sp, $sp, -0x20
0015CCE4 AFB00010 sw         $s0, 0x10($sp)
0015CCE8 00808025 move       $s0, $a0
0015CCEC AFB10014 sw         $s1, 0x14($sp)
0015CCF0 8E110058 lw         $s1, 0x58($s0)
0015CCF4 8E240004 lw         $a0, 4($s1)
0015CCF8 AFBF0018 sw         $ra, 0x18($sp)
0015CCFC 50800020 beql       $a0, $zero, 0x15cd80
0015CD00 C62C0000 lwc1       $f12, ($s1)
0015CD04 8C850064 lw         $a1, 0x64($a0)
0015CD08 30A60001 andi       $a2, $a1, 1
0015CD0C 10C0000D beqz       $a2, 0x15cd44
0015CD10 30A60006 andi       $a2, $a1, 6
0015CD14 14C0000B bnez       $a2, 0x15cd44
0015CD18 30A50008 andi       $a1, $a1, 8
0015CD1C 14A00009 bnez       $a1, 0x15cd44
0015CD20 00000000 nop        
0015CD24 8C850040 lw         $a1, 0x40($a0)
0015CD28 8CA50010 lw         $a1, 0x10($a1)
0015CD2C 8CA5003C lw         $a1, 0x3c($a1)
0015CD30 30A50008 andi       $a1, $a1, 8
0015CD34 14A0000A bnez       $a1, 0x15cd60
0015CD38 00000000 nop        
0015CD3C 10000010 b          0x15cd80
0015CD40 C62C0000 lwc1       $f12, ($s1)
0015CD44 0C05738A jal        0x15ce28
0015CD48 02002025 move       $a0, $s0
0015CD4C 02002025 move       $a0, $s0
0015CD50 0C01A8F0 jal        0x6a3c0
0015CD54 34050001 ori        $a1, $zero, 1
0015CD58 1000002E b          0x15ce14
0015CD5C 00000000 nop        
0015CD60 00803025 move       $a2, $a0
0015CD64 26250038 addiu      $a1, $s1, 0x38
0015CD68 0C03E2D9 jal        0xf8b64
0015CD6C 02002025 move       $a0, $s0
0015CD70 8E250004 lw         $a1, 4($s1)
0015CD74 0C03D0F2 jal        0xf43c8
0015CD78 26240008 addiu      $a0, $s1, 8
0015CD7C C62C0000 lwc1       $f12, ($s1)
0015CD80 3C04002D lui        $a0, 0x2d
0015CD84 C48D5AC0 lwc1       $f13, 0x5ac0($a0)
0015CD88 460D6300 add.s      $f12, $f12, $f13
0015CD8C 3C04002D lui        $a0, 0x2d
0015CD90 E62C0000 swc1       $f12, ($s1)
0015CD94 E60C0000 swc1       $f12, ($s0)
0015CD98 92050078 lbu        $a1, 0x78($s0)
0015CD9C E60C0014 swc1       $f12, 0x14($s0)
0015CDA0 E60C0028 swc1       $f12, 0x28($s0)
0015CDA4 44856000 mtc1       $a1, $f12
0015CDA8 C48E5AC4 lwc1       $f14, 0x5ac4($a0)
0015CDAC 46806320 cvt.s.w    $f12, $f12
0015CDB0 92040079 lbu        $a0, 0x79($s0)
0015CDB4 44846800 mtc1       $a0, $f13
0015CDB8 460E6300 add.s      $f12, $f12, $f14
0015CDBC 3C04002D lui        $a0, 0x2d
0015CDC0 46806B60 cvt.s.w    $f13, $f13
0015CDC4 3C05002D lui        $a1, 0x2d
0015CDC8 4600630D trunc.w.s  $f12, $f12
0015CDCC 44066000 mfc1       $a2, $f12
0015CDD0 A2060078 sb         $a2, 0x78($s0)
0015CDD4 C48E5AC8 lwc1       $f14, 0x5ac8($a0)
0015CDD8 460E6B40 add.s      $f13, $f13, $f14
0015CDDC 46006B4D trunc.w.s  $f13, $f13
0015CDE0 44046800 mfc1       $a0, $f13
0015CDE4 A2040079 sb         $a0, 0x79($s0)
0015CDE8 C62F0000 lwc1       $f15, ($s1)
0015CDEC C4B05ACC lwc1       $f16, 0x5acc($a1)
0015CDF0 4610783E c.le.s     $f15, $f16
0015CDF4 00000000 nop        
0015CDF8 45010006 bc1t       0x15ce14
0015CDFC 00000000 nop        
0015CE00 0C05738A jal        0x15ce28
0015CE04 02002025 move       $a0, $s0
0015CE08 02002025 move       $a0, $s0
0015CE0C 0C01A8F0 jal        0x6a3c0
0015CE10 34050001 ori        $a1, $zero, 1
0015CE14 8FB00010 lw         $s0, 0x10($sp)
0015CE18 8FB10014 lw         $s1, 0x14($sp)
0015CE1C 8FBF0018 lw         $ra, 0x18($sp)
0015CE20 03E00008 jr         $ra
0015CE24 27BD0020 addiu      $sp, $sp, 0x20