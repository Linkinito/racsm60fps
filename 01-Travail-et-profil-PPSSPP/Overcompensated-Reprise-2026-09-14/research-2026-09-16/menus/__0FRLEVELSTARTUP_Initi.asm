00018E48 e0ffbd27 addiu      $sp, $sp, -0x20
00018E4C 1100053c lui        $a1, 0x11
00018E50 9026a58c lw         $a1, 0x2690($a1)
00018E54 1200063c lui        $a2, 0x12
00018E58 2c1ca0ac sw         $zero, 0x1c2c($a1)
00018E5C 10fac4ac sw         $a0, -0x5f0($a2)
00018E60 0000053c lui        $a1, 0
00018E64 25200000 move       $a0, $zero
00018E68 1000bfaf sw         $ra, 0x10($sp)
00018E6C 5f7d000c jal        0x1f57c
00018E70 3c0ea524 addiu      $a1, $a1, 0xe3c
00018E74 1000bf8f lw         $ra, 0x10($sp)
00018E78 0800e003 jr         $ra
00018E7C 2000bd27 addiu      $sp, $sp, 0x20