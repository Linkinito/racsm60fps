000178B8 e0ffbd27 addiu      $sp, $sp, -0x20
000178BC ff008530 andi       $a1, $a0, 0xff
000178C0 0a00043c lui        $a0, 0xa
000178C4 1000bfaf sw         $ra, 0x10($sp)
000178C8 505e000c jal        0x17940
000178CC b813848c lw         $a0, 0x13b8($a0)
000178D0 1000bf8f lw         $ra, 0x10($sp)
000178D4 0800e003 jr         $ra
000178D8 2000bd27 addiu      $sp, $sp, 0x20