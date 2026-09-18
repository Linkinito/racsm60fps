000AC0F8 e0ffbd27 addiu      $sp, $sp, -0x20
000AC0FC 2c00858c lw         $a1, 0x2c($a0)
000AC100 1000bfaf sw         $ra, 0x10($sp)
000AC104 02000634 ori        $a2, $zero, 2
000AC108 300086ac sw         $a2, 0x30($a0)
000AC10C 3400868c lw         $a2, 0x34($a0)
000AC110 00000834 ori        $t0, $zero, 0
000AC114 2b300601 sltu       $a2, $t0, $a2
000AC118 1500c010 beqz       $a2, 0xac170
000AC11C 2548a000 move       $t1, $a1
000AC120 00000734 ori        $a3, $zero, 0
000AC124 2400868c lw         $a2, 0x24($a0)
000AC128 2130c700 addu       $a2, $a2, $a3
000AC12C 0000a6ac sw         $a2, ($a1)
000AC130 2c00858c lw         $a1, 0x2c($a0)
000AC134 2800868c lw         $a2, 0x28($a0)
000AC138 0400a524 addiu      $a1, $a1, 4
000AC13C 2b50c500 sltu       $t2, $a2, $a1
000AC140 08004015 bnez       $t2, 0xac164
000AC144 2c0085ac sw         $a1, 0x2c($a0)
000AC148 3400868c lw         $a2, 0x34($a0)
000AC14C 01000825 addiu      $t0, $t0, 1
000AC150 2b300601 sltu       $a2, $t0, $a2
000AC154 f3ffc014 bnez       $a2, 0xac124
000AC158 e400e724 addiu      $a3, $a3, 0xe4
000AC15C 04000010 b          0xac170
000AC160 00000000 nop        
000AC164 2c0086ac sw         $a2, 0x2c($a0)
000AC168 11000010 b          0xac1b0
000AC16C 25100000 move       $v0, $zero
000AC170 0000a0ac sw         $zero, ($a1)
000AC174 2c00858c lw         $a1, 0x2c($a0)
000AC178 2800868c lw         $a2, 0x28($a0)
000AC17C 0400a524 addiu      $a1, $a1, 4
000AC180 2c0085ac sw         $a1, 0x2c($a0)
000AC184 2b28c500 sltu       $a1, $a2, $a1
000AC188 0400a010 beqz       $a1, 0xac19c
000AC18C 00000000 nop        
000AC190 2c0086ac sw         $a2, 0x2c($a0)
000AC194 06000010 b          0xac1b0
000AC198 25100000 move       $v0, $zero
000AC19C 3400858c lw         $a1, 0x34($a0)
000AC1A0 000089ac sw         $t1, ($a0)
000AC1A4 6fb0020c jal        0xac1bc
000AC1A8 040085ac sw         $a1, 4($a0)
000AC1AC 01000234 ori        $v0, $zero, 1
000AC1B0 1000bf8f lw         $ra, 0x10($sp)
000AC1B4 0800e003 jr         $ra
000AC1B8 2000bd27 addiu      $sp, $sp, 0x20