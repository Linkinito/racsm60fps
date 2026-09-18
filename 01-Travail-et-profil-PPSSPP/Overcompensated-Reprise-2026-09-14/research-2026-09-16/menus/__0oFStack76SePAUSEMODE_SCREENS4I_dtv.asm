0002FF4C e0ffbd27 addiu      $sp, $sp, -0x20
0002FF50 1000bfaf sw         $ra, 0x10($sp)
0002FF54 05008010 beqz       $a0, 0x2ff6c
0002FF58 0100a530 andi       $a1, $a1, 1
0002FF5C 0300a010 beqz       $a1, 0x2ff6c
0002FF60 00000000 nop        
0002FF64 317f000c jal        0x1fcc4
0002FF68 00000000 nop        
0002FF6C 1000bf8f lw         $ra, 0x10($sp)
0002FF70 0800e003 jr         $ra
0002FF74 2000bd27 addiu      $sp, $sp, 0x20