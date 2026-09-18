000160D4 e0ffbd27 addiu      $sp, $sp, -0x20
000160D8 1000b0af sw         $s0, 0x10($sp)
000160DC 25808000 move       $s0, $a0
000160E0 5400058e lw         $a1, 0x54($s0)
000160E4 5000068e lw         $a2, 0x50($s0)
000160E8 1400b1af sw         $s1, 0x14($sp)
000160EC 2388a600 subu       $s1, $a1, $a2
000160F0 1800bfaf sw         $ra, 0x18($sp)
000160F4 4758000c jal        0x1611c
000160F8 740011ae sw         $s1, 0x74($s0)
000160FC 1b002202 divu       $zero, $s1, $v0
00016100 12200000 mflo       $a0
00016104 740004ae sw         $a0, 0x74($s0)
00016108 1000b08f lw         $s0, 0x10($sp)
0001610C 1400b18f lw         $s1, 0x14($sp)
00016110 1800bf8f lw         $ra, 0x18($sp)
00016114 0800e003 jr         $ra
00016118 2000bd27 addiu      $sp, $sp, 0x20