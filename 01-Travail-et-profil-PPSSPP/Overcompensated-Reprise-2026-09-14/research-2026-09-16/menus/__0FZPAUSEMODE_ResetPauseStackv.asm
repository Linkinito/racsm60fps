000174B4 e0ffbd27 addiu      $sp, $sp, -0x20
000174B8 0a00043c lui        $a0, 0xa
000174BC 1000b0af sw         $s0, 0x10($sp)
000174C0 b8139024 addiu      $s0, $a0, 0x13b8
000174C4 1400bfaf sw         $ra, 0x14($sp)
000174C8 debf000c jal        0x2ff78
000174CC 2c000426 addiu      $a0, $s0, 0x2c
000174D0 240000a2 sb         $zero, 0x24($s0)
000174D4 280000ae sw         $zero, 0x28($s0)
000174D8 1000b08f lw         $s0, 0x10($sp)
000174DC 1400bf8f lw         $ra, 0x14($sp)
000174E0 0800e003 jr         $ra
000174E4 2000bd27 addiu      $sp, $sp, 0x20