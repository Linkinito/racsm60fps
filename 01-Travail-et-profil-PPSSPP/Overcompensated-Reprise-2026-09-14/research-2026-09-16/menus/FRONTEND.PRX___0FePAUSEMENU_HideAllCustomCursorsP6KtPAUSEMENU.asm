00015EAC d0ffbd27 addiu      $sp, $sp, -0x30
00015EB0 1000b0af sw         $s0, 0x10($sp)
00015EB4 25808000 move       $s0, $a0
00015EB8 1400b1af sw         $s1, 0x14($sp)
00015EBC 1800b2af sw         $s2, 0x18($sp)
00015EC0 1c00b3af sw         $s3, 0x1c($sp)
00015EC4 2000bfaf sw         $ra, 0x20($sp)
00015EC8 0400048e lw         $a0, 4($s0)
00015ECC 00001334 ori        $s3, $zero, 0
00015ED0 2b206402 sltu       $a0, $s3, $a0
00015ED4 0f008010 beqz       $a0, 0x15f14
00015ED8 ffff1124 addiu      $s1, $zero, -1
00015EDC 00001234 ori        $s2, $zero, 0
00015EE0 0000048e lw         $a0, ($s0)
00015EE4 21209200 addu       $a0, $a0, $s2
00015EE8 0000848c lw         $a0, ($a0)
00015EEC c800848c lw         $a0, 0xc8($a0)
00015EF0 03009110 beq        $a0, $s1, 0x15f00
00015EF4 00000000 nop        
00015EF8 1347000c jal        0x11c4c
00015EFC 25280000 move       $a1, $zero
00015F00 0400048e lw         $a0, 4($s0)
00015F04 01007326 addiu      $s3, $s3, 1
00015F08 2b206402 sltu       $a0, $s3, $a0
00015F0C f4ff8014 bnez       $a0, 0x15ee0
00015F10 04005226 addiu      $s2, $s2, 4
00015F14 1000b08f lw         $s0, 0x10($sp)
00015F18 1400b18f lw         $s1, 0x14($sp)
00015F1C 1800b28f lw         $s2, 0x18($sp)
00015F20 1c00b38f lw         $s3, 0x1c($sp)
00015F24 2000bf8f lw         $ra, 0x20($sp)
00015F28 0800e003 jr         $ra
00015F2C 3000bd27 addiu      $sp, $sp, 0x30