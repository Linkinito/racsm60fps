00017904 e0ffbd27 addiu      $sp, $sp, -0x20
00017908 0a00053c lui        $a1, 0xa
0001790C b813a524 addiu      $a1, $a1, 0x13b8
00017910 0800a48c lw         $a0, 8($a1)
00017914 1000bfaf sw         $ra, 0x10($sp)
00017918 06008010 beqz       $a0, 0x17934
0001791C 00000000 nop        
00017920 ffff8424 addiu      $a0, $a0, -1
00017924 03008014 bnez       $a0, 0x17934
00017928 0800a4ac sw         $a0, 8($a1)
0001792C 375e000c jal        0x178dc
00017930 03000434 ori        $a0, $zero, 3
00017934 1000bf8f lw         $ra, 0x10($sp)
00017938 0800e003 jr         $ra
0001793C 2000bd27 addiu      $sp, $sp, 0x20