0002FF24 e0ffbd27 addiu      $sp, $sp, -0x20
0002FF28 1000b0af sw         $s0, 0x10($sp)
0002FF2C 1400bfaf sw         $ra, 0x14($sp)
0002FF30 debf000c jal        0x2ff78
0002FF34 25808000 move       $s0, $a0
0002FF38 25100002 move       $v0, $s0
0002FF3C 1000b08f lw         $s0, 0x10($sp)
0002FF40 1400bf8f lw         $ra, 0x14($sp)
0002FF44 0800e003 jr         $ra
0002FF48 2000bd27 addiu      $sp, $sp, 0x20