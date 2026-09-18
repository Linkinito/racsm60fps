00019154 e0ffbd27 addiu      $sp, $sp, -0x20
00019158 1100053c lui        $a1, 0x11
0001915C 302aa58c lw         $a1, 0x2a30($a1)
00019160 1200063c lui        $a2, 0x12
00019164 2c1ca0ac sw         $zero, 0x1c2c($a1)
00019168 60bec4ac sw         $a0, -0x41a0($a2)
0001916C 0000053c lui        $a1, 0
00019170 25200000 move       $a0, $zero
00019174 1000bfaf sw         $ra, 0x10($sp)
00019178 407e000c jal        0x1f900
0001917C 280ea524 addiu      $a1, $a1, 0xe28
00019180 1000bf8f lw         $ra, 0x10($sp)
00019184 0800e003 jr         $ra
00019188 2000bd27 addiu      $sp, $sp, 0x20