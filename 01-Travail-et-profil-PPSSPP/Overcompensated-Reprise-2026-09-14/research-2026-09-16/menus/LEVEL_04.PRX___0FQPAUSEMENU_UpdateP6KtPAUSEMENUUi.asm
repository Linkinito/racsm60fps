000ABB18 e0ffbd27 addiu      $sp, $sp, -0x20
000ABB1C 1000b0af sw         $s0, 0x10($sp)
000ABB20 25808000 move       $s0, $a0
000ABB24 1400b1af sw         $s1, 0x14($sp)
000ABB28 1800bfaf sw         $ra, 0x18($sp)
000ABB2C deaf020c jal        0xabf78
000ABB30 2588a000 move       $s1, $a1
000ABB34 0400048e lw         $a0, 4($s0)
000ABB38 0d008010 beqz       $a0, 0xabb70
000ABB3C 00000000 nop        
000ABB40 25200002 move       $a0, $s0
000ABB44 edae020c jal        0xabbb4
000ABB48 25282002 move       $a1, $s1
000ABB4C 25884000 move       $s1, $v0
000ABB50 6fb0020c jal        0xac1bc
000ABB54 25200002 move       $a0, $s0
000ABB58 1400048e lw         $a0, 0x14($s0)
000ABB5C 02008430 andi       $a0, $a0, 2
000ABB60 05008014 bnez       $a0, 0xabb78
000ABB64 00000000 nop        
000ABB68 0c000010 b          0xabb9c
000ABB6C 00000000 nop        
000ABB70 0b000010 b          0xabba0
000ABB74 25100000 move       $v0, $zero
000ABB78 abb0020c jal        0xac2ac
000ABB7C 25200002 move       $a0, $s0
000ABB80 25304000 move       $a2, $v0
000ABB84 6800058e lw         $a1, 0x68($s0)
000ABB88 00000434 ori        $a0, $zero, 0
000ABB8C 0100c054 bnel       $a2, $zero, 0xabb94
000ABB90 2520c000 move       $a0, $a2
000ABB94 2120a400 addu       $a0, $a1, $a0
000ABB98 680004ae sw         $a0, 0x68($s0)
000ABB9C 25102002 move       $v0, $s1
000ABBA0 1000b08f lw         $s0, 0x10($sp)
000ABBA4 1400b18f lw         $s1, 0x14($sp)
000ABBA8 1800bf8f lw         $ra, 0x18($sp)
000ABBAC 0800e003 jr         $ra
000ABBB0 2000bd27 addiu      $sp, $sp, 0x20