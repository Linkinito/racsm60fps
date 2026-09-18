000AC1BC e0ffbd27 addiu      $sp, $sp, -0x20
000AC1C0 1000b0af sw         $s0, 0x10($sp)
000AC1C4 25808000 move       $s0, $a0
000AC1C8 5400058e lw         $a1, 0x54($s0)
000AC1CC 5000068e lw         $a2, 0x50($s0)
000AC1D0 1400b1af sw         $s1, 0x14($sp)
000AC1D4 2388a600 subu       $s1, $a1, $a2
000AC1D8 1800bfaf sw         $ra, 0x18($sp)
000AC1DC 81b0020c jal        0xac204
000AC1E0 740011ae sw         $s1, 0x74($s0)
000AC1E4 1b002202 divu       $zero, $s1, $v0
000AC1E8 12200000 mflo       $a0
000AC1EC 740004ae sw         $a0, 0x74($s0)
000AC1F0 1000b08f lw         $s0, 0x10($sp)
000AC1F4 1400b18f lw         $s1, 0x14($sp)
000AC1F8 1800bf8f lw         $ra, 0x18($sp)
000AC1FC 0800e003 jr         $ra
000AC200 2000bd27 addiu      $sp, $sp, 0x20