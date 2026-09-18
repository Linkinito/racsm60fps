000160AC d0ffbd27 addiu      $sp, $sp, -0x30
000160B0 1000b0af sw         $s0, 0x10($sp)
000160B4 25808000 move       $s0, $a0
000160B8 1400b1af sw         $s1, 0x14($sp)
000160BC 1800b2af sw         $s2, 0x18($sp)
000160C0 1c00b3af sw         $s3, 0x1c($sp)
000160C4 2000bfaf sw         $ra, 0x20($sp)
000160C8 0400048e lw         $a0, 4($s0)
000160CC 00001334 ori        $s3, $zero, 0
000160D0 2b206402 sltu       $a0, $s3, $a0
000160D4 0f008010 beqz       $a0, 0x16114
000160D8 ffff1124 addiu      $s1, $zero, -1
000160DC 00001234 ori        $s2, $zero, 0
000160E0 0000048e lw         $a0, ($s0)
000160E4 21209200 addu       $a0, $a0, $s2
000160E8 0000848c lw         $a0, ($a0)
000160EC c800848c lw         $a0, 0xc8($a0)
000160F0 03009110 beq        $a0, $s1, 0x16100
000160F4 00000000 nop        
000160F8 1147000c jal        0x11c44
000160FC 25280000 move       $a1, $zero
00016100 0400048e lw         $a0, 4($s0)
00016104 01007326 addiu      $s3, $s3, 1
00016108 2b206402 sltu       $a0, $s3, $a0
0001610C f4ff8014 bnez       $a0, 0x160e0
00016110 04005226 addiu      $s2, $s2, 4
00016114 1000b08f lw         $s0, 0x10($sp)
00016118 1400b18f lw         $s1, 0x14($sp)
0001611C 1800b28f lw         $s2, 0x18($sp)
00016120 1c00b38f lw         $s3, 0x1c($sp)
00016124 2000bf8f lw         $ra, 0x20($sp)
00016128 0800e003 jr         $ra
0001612C 3000bd27 addiu      $sp, $sp, 0x30