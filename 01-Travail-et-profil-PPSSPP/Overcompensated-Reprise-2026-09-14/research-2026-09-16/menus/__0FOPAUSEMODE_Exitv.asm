000175DC f0ffbd27 addiu      $sp, $sp, -0x10
000175E0 0000bfaf sw         $ra, ($sp)
000175E4 a85e000c jal        0x17aa0
000175E8 00000000 nop        
000175EC 7d5e000c jal        0x179f4
000175F0 00000000 nop        
000175F4 1200043c lui        $a0, 0x12
000175F8 6e5d000c jal        0x175b8
000175FC 9cf780ac sw         $zero, -0x864($a0)
00017600 0a00043c lui        $a0, 0xa
00017604 b8138424 addiu      $a0, $a0, 0x13b8
00017608 040080ac sw         $zero, 4($a0)
0001760C 0000bf8f lw         $ra, ($sp)
00017610 0800e003 jr         $ra
00017614 1000bd27 addiu      $sp, $sp, 0x10