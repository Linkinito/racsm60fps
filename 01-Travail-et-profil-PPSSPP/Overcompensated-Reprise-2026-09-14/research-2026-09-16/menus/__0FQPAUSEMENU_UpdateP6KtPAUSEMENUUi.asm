00015E94 e0ffbd27 addiu      $sp, $sp, -0x20
00015E98 1000b0af sw         $s0, 0x10($sp)
00015E9C 25808000 move       $s0, $a0
00015EA0 1400b1af sw         $s1, 0x14($sp)
00015EA4 1800bfaf sw         $ra, 0x18($sp)
00015EA8 2b58000c jal        0x160ac
00015EAC 2588a000 move       $s1, $a1
00015EB0 0400048e lw         $a0, 4($s0)
00015EB4 0d008010 beqz       $a0, 0x15eec
00015EB8 00000000 nop        
00015EBC 25200002 move       $a0, $s0
00015EC0 cc57000c jal        0x15f30
00015EC4 25282002 move       $a1, $s1
00015EC8 25884000 move       $s1, $v0
00015ECC b558000c jal        0x162d4
00015ED0 25200002 move       $a0, $s0
00015ED4 1400048e lw         $a0, 0x14($s0)
00015ED8 02008430 andi       $a0, $a0, 2
00015EDC 05008014 bnez       $a0, 0x15ef4
00015EE0 00000000 nop        
00015EE4 0c000010 b          0x15f18
00015EE8 00000000 nop        
00015EEC 0b000010 b          0x15f1c
00015EF0 25100000 move       $v0, $zero
00015EF4 f158000c jal        0x163c4
00015EF8 25200002 move       $a0, $s0
00015EFC 25304000 move       $a2, $v0
00015F00 6800058e lw         $a1, 0x68($s0)
00015F04 00000434 ori        $a0, $zero, 0
00015F08 0100c054 bnel       $a2, $zero, 0x15f10
00015F0C 2520c000 move       $a0, $a2
00015F10 2120a400 addu       $a0, $a1, $a0
00015F14 680004ae sw         $a0, 0x68($s0)
00015F18 25102002 move       $v0, $s1
00015F1C 1000b08f lw         $s0, 0x10($sp)
00015F20 1400b18f lw         $s1, 0x14($sp)
00015F24 1800bf8f lw         $ra, 0x18($sp)
00015F28 0800e003 jr         $ra
00015F2C 2000bd27 addiu      $sp, $sp, 0x20