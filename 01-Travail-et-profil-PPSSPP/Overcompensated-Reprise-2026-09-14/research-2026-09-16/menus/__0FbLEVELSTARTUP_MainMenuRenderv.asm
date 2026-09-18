00018C3C c0ffbd27 addiu      $sp, $sp, -0x40
00018C40 3000b0af sw         $s0, 0x30($sp)
00018C44 ffff1024 addiu      $s0, $zero, -1
00018C48 25200000 move       $a0, $zero
00018C4C 25280000 move       $a1, $zero
00018C50 e0010634 ori        $a2, $zero, 0x1e0
00018C54 10010734 ori        $a3, $zero, 0x110
00018C58 3400bfaf sw         $ra, 0x34($sp)
00018C5C 2d40000c jal        0x100b4
00018C60 ffff0824 addiu      $t0, $zero, -1
00018C64 1200043c lui        $a0, 0x12
00018C68 5cf6848c lw         $a0, -0x9a4($a0)
00018C6C 10010234 ori        $v0, $zero, 0x110
00018C70 0000a2af sw         $v0, ($sp)
00018C74 25280000 move       $a1, $zero
00018C78 25300000 move       $a2, $zero
00018C7C e0010734 ori        $a3, $zero, 0x1e0
00018C80 10010834 ori        $t0, $zero, 0x110
00018C84 25480000 move       $t1, $zero
00018C88 25500000 move       $t2, $zero
00018C8C e0010b34 ori        $t3, $zero, 0x1e0
00018C90 9c41000c jal        0x10670
00018C94 0400b0af sw         $s0, 4($sp)
00018C98 1200043c lui        $a0, 0x12
00018C9C b459000c jal        0x166d0
00018CA0 70fe8424 addiu      $a0, $a0, -0x190
00018CA4 3000b08f lw         $s0, 0x30($sp)
00018CA8 3400bf8f lw         $ra, 0x34($sp)
00018CAC 0800e003 jr         $ra
00018CB0 4000bd27 addiu      $sp, $sp, 0x40