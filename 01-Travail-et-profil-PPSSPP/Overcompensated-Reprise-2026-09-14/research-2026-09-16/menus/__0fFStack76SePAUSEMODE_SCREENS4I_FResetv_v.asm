0002FF78 e0ffbd27 addiu      $sp, $sp, -0x20
0002FF7C 200080ac sw         $zero, 0x20($a0)
0002FF80 25280000 move       $a1, $zero
0002FF84 1000bfaf sw         $ra, 0x10($sp)
0002FF88 0693000c jal        0x24c18
0002FF8C 20000634 ori        $a2, $zero, 0x20
0002FF90 1000bf8f lw         $ra, 0x10($sp)
0002FF94 0800e003 jr         $ra
0002FF98 2000bd27 addiu      $sp, $sp, 0x20