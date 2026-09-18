00018E1C e0ffbd27 addiu      $sp, $sp, -0x20
00018E20 1000bfaf sw         $ra, 0x10($sp)
00018E24 c22f000c jal        0xbf08
00018E28 01000434 ori        $a0, $zero, 1
00018E2C 2d63000c jal        0x18cb4
00018E30 00000000 nop        
00018E34 8730000c jal        0xc21c
00018E38 25200000 move       $a0, $zero
00018E3C 1000bf8f lw         $ra, 0x10($sp)
00018E40 0800e003 jr         $ra
00018E44 2000bd27 addiu      $sp, $sp, 0x20