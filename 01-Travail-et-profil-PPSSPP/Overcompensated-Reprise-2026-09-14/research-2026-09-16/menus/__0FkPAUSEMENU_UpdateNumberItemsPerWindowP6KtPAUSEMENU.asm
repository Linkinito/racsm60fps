000162D4 e0ffbd27 addiu      $sp, $sp, -0x20
000162D8 1000b0af sw         $s0, 0x10($sp)
000162DC 25808000 move       $s0, $a0
000162E0 5400058e lw         $a1, 0x54($s0)
000162E4 5000068e lw         $a2, 0x50($s0)
000162E8 1400b1af sw         $s1, 0x14($sp)
000162EC 2388a600 subu       $s1, $a1, $a2
000162F0 1800bfaf sw         $ra, 0x18($sp)
000162F4 c758000c jal        0x1631c
000162F8 740011ae sw         $s1, 0x74($s0)
000162FC 1b002202 divu       $zero, $s1, $v0
00016300 12200000 mflo       $a0
00016304 740004ae sw         $a0, 0x74($s0)
00016308 1000b08f lw         $s0, 0x10($sp)
0001630C 1400b18f lw         $s1, 0x14($sp)
00016310 1800bf8f lw         $ra, 0x18($sp)
00016314 0800e003 jr         $ra
00016318 2000bd27 addiu      $sp, $sp, 0x20