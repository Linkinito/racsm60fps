00017550 e0ffbd27 addiu      $sp, $sp, -0x20
00017554 1000b0af sw         $s0, 0x10($sp)
00017558 25808000 move       $s0, $a0
0001755C 0a00043c lui        $a0, 0xa
00017560 b813858c lw         $a1, 0x13b8($a0)
00017564 1400b1af sw         $s1, 0x14($sp)
00017568 b8139124 addiu      $s1, $a0, 0x13b8
0001756C 1200043c lui        $a0, 0x12
00017570 040025ae sw         $a1, 4($s1)
00017574 1800bfaf sw         $ra, 0x18($sp)
00017578 9f57000c jal        0x15e7c
0001757C b0f78424 addiu      $a0, $a0, -0x850
00017580 1200043c lui        $a0, 0x12
00017584 9f57000c jal        0x15e7c
00017588 d8f78424 addiu      $a0, $a0, -0x828
0001758C 7d5e000c jal        0x179f4
00017590 100030ae sw         $s0, 0x10($s1)
00017594 aa5e000c jal        0x17aa8
00017598 00000000 nop        
0001759C b407000c jal        0x1ed0
000175A0 00000000 nop        
000175A4 1000b08f lw         $s0, 0x10($sp)
000175A8 1400b18f lw         $s1, 0x14($sp)
000175AC 1800bf8f lw         $ra, 0x18($sp)
000175B0 0800e003 jr         $ra
000175B4 2000bd27 addiu      $sp, $sp, 0x20