00017A50 f0ffbd27 addiu      $sp, $sp, -0x10
00017A54 0a00043c lui        $a0, 0xa
00017A58 b8138424 addiu      $a0, $a0, 0x13b8
00017A5C 1000858c lw         $a1, 0x10($a0)
00017A60 2800848c lw         $a0, 0x28($a0)
00017A64 0000bfaf sw         $ra, ($sp)
00017A68 2520a400 or         $a0, $a1, $a0
00017A6C 03008014 bnez       $a0, 0x17a7c
00017A70 00000000 nop        
00017A74 07000010 b          0x17a94
00017A78 00000000 nop        
00017A7C a85e000c jal        0x17aa0
00017A80 00000000 nop        
00017A84 7d5e000c jal        0x179f4
00017A88 00000000 nop        
00017A8C aa5e000c jal        0x17aa8
00017A90 00000000 nop        
00017A94 0000bf8f lw         $ra, ($sp)
00017A98 0800e003 jr         $ra
00017A9C 1000bd27 addiu      $sp, $sp, 0x10