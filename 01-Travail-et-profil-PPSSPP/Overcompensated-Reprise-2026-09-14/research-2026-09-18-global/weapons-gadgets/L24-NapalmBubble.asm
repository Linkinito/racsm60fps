
CALLBACK 0x00140E54 end 0x00140E5C ordinal 0

00140E54 03E00008 jr         $ra
00140E58 34020001 ori        $v0, $zero, 1

CALLBACK 0x00140E5C end 0x00140E64 ordinal 1

00140E5C 03E00008 jr         $ra
00140E60 00000000 nop        

CALLBACK 0x00140E64 end 0x00140FAC ordinal 2

00140E64 27BDFFE0 addiu      $sp, $sp, -0x20
00140E68 AFB00010 sw         $s0, 0x10($sp)
00140E6C 00808025 move       $s0, $a0
00140E70 AFB10014 sw         $s1, 0x14($sp)
00140E74 8E110058 lw         $s1, 0x58($s0)
00140E78 8E240004 lw         $a0, 4($s1)
00140E7C AFBF0018 sw         $ra, 0x18($sp)
00140E80 50800020 beql       $a0, $zero, 0x140f04
00140E84 C62C0000 lwc1       $f12, ($s1)
00140E88 8C850064 lw         $a1, 0x64($a0)
00140E8C 30A60001 andi       $a2, $a1, 1
00140E90 10C0000D beqz       $a2, 0x140ec8
00140E94 30A60006 andi       $a2, $a1, 6
00140E98 14C0000B bnez       $a2, 0x140ec8
00140E9C 30A50008 andi       $a1, $a1, 8
00140EA0 14A00009 bnez       $a1, 0x140ec8
00140EA4 00000000 nop        
00140EA8 8C850040 lw         $a1, 0x40($a0)
00140EAC 8CA50010 lw         $a1, 0x10($a1)
00140EB0 8CA5003C lw         $a1, 0x3c($a1)
00140EB4 30A50008 andi       $a1, $a1, 8
00140EB8 14A0000A bnez       $a1, 0x140ee4
00140EBC 00000000 nop        
00140EC0 10000010 b          0x140f04
00140EC4 C62C0000 lwc1       $f12, ($s1)
00140EC8 0C0503EB jal        0x140fac
00140ECC 02002025 move       $a0, $s0
00140ED0 02002025 move       $a0, $s0
00140ED4 0C0192FF jal        0x64bfc
00140ED8 34050001 ori        $a1, $zero, 1
00140EDC 1000002E b          0x140f98
00140EE0 00000000 nop        
00140EE4 00803025 move       $a2, $a0
00140EE8 26250038 addiu      $a1, $s1, 0x38
00140EEC 0C03BC37 jal        0xef0dc
00140EF0 02002025 move       $a0, $s0
00140EF4 8E250004 lw         $a1, 4($s1)
00140EF8 0C03AB3E jal        0xeacf8
00140EFC 26240008 addiu      $a0, $s1, 8
00140F00 C62C0000 lwc1       $f12, ($s1)
00140F04 3C04002A lui        $a0, 0x2a
00140F08 C48D2950 lwc1       $f13, 0x2950($a0)
00140F0C 460D6300 add.s      $f12, $f12, $f13
00140F10 3C04002A lui        $a0, 0x2a
00140F14 E62C0000 swc1       $f12, ($s1)
00140F18 E60C0000 swc1       $f12, ($s0)
00140F1C 92050078 lbu        $a1, 0x78($s0)
00140F20 E60C0014 swc1       $f12, 0x14($s0)
00140F24 E60C0028 swc1       $f12, 0x28($s0)
00140F28 44856000 mtc1       $a1, $f12
00140F2C C48E2954 lwc1       $f14, 0x2954($a0)
00140F30 46806320 cvt.s.w    $f12, $f12
00140F34 92040079 lbu        $a0, 0x79($s0)
00140F38 44846800 mtc1       $a0, $f13
00140F3C 460E6300 add.s      $f12, $f12, $f14
00140F40 3C04002A lui        $a0, 0x2a
00140F44 46806B60 cvt.s.w    $f13, $f13
00140F48 3C05002A lui        $a1, 0x2a
00140F4C 4600630D trunc.w.s  $f12, $f12
00140F50 44066000 mfc1       $a2, $f12
00140F54 A2060078 sb         $a2, 0x78($s0)
00140F58 C48E2958 lwc1       $f14, 0x2958($a0)
00140F5C 460E6B40 add.s      $f13, $f13, $f14
00140F60 46006B4D trunc.w.s  $f13, $f13
00140F64 44046800 mfc1       $a0, $f13
00140F68 A2040079 sb         $a0, 0x79($s0)
00140F6C C62F0000 lwc1       $f15, ($s1)
00140F70 C4B0295C lwc1       $f16, 0x295c($a1)
00140F74 4610783E c.le.s     $f15, $f16
00140F78 00000000 nop        
00140F7C 45010006 bc1t       0x140f98
00140F80 00000000 nop        
00140F84 0C0503EB jal        0x140fac
00140F88 02002025 move       $a0, $s0
00140F8C 02002025 move       $a0, $s0
00140F90 0C0192FF jal        0x64bfc
00140F94 34050001 ori        $a1, $zero, 1
00140F98 8FB00010 lw         $s0, 0x10($sp)
00140F9C 8FB10014 lw         $s1, 0x14($sp)
00140FA0 8FBF0018 lw         $ra, 0x18($sp)
00140FA4 03E00008 jr         $ra
00140FA8 27BD0020 addiu      $sp, $sp, 0x20