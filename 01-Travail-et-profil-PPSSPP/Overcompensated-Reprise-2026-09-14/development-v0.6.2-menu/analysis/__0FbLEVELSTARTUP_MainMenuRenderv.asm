000190B0 c0ffbd27 addiu      $sp, $sp, -0x40
000190B4 3000b0af sw         $s0, 0x30($sp)
000190B8 ffff1024 addiu      $s0, $zero, -1
000190BC 25200000 move       $a0, $zero
000190C0 25280000 move       $a1, $zero
000190C4 e0010634 ori        $a2, $zero, 0x1e0
000190C8 10010734 ori        $a3, $zero, 0x110
000190CC 3400bfaf sw         $ra, 0x34($sp)
000190D0 2f40000c jal        0x100bc
000190D4 ffff0824 addiu      $t0, $zero, -1
000190D8 1200043c lui        $a0, 0x12
000190DC fcb9848c lw         $a0, -0x4604($a0)
000190E0 10010234 ori        $v0, $zero, 0x110
000190E4 0000a2af sw         $v0, ($sp)
000190E8 25280000 move       $a1, $zero
000190EC 25300000 move       $a2, $zero
000190F0 e0010734 ori        $a3, $zero, 0x1e0
000190F4 10010834 ori        $t0, $zero, 0x110
000190F8 25480000 move       $t1, $zero
000190FC 25500000 move       $t2, $zero
00019100 e0010b34 ori        $t3, $zero, 0x1e0
00019104 9e41000c jal        0x10678
00019108 0400b0af sw         $s0, 4($sp)
0001910C 1200043c lui        $a0, 0x12
00019110 3459000c jal        0x164d0
00019114 f0c28424 addiu      $a0, $a0, -0x3d10
00019118 3000b08f lw         $s0, 0x30($sp)
0001911C 3400bf8f lw         $ra, 0x34($sp)
00019120 0800e003 jr         $ra
00019124 4000bd27 addiu      $sp, $sp, 0x40