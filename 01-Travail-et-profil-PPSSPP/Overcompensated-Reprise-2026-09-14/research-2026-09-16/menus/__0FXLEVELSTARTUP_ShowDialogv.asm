00018BE4 e0ffbd27 addiu      $sp, $sp, -0x20
00018BE8 1000b0af sw         $s0, 0x10($sp)
00018BEC 1400b1af sw         $s1, 0x14($sp)
00018BF0 1800bfaf sw         $ra, 0x18($sp)
00018BF4 8874000c jal        0x1d220
00018BF8 1f010434 ori        $a0, $zero, 0x11f
00018BFC 25804000 move       $s0, $v0
00018C00 8874000c jal        0x1d220
00018C04 e9000434 ori        $a0, $zero, 0xe9
00018C08 25884000 move       $s1, $v0
00018C0C 8874000c jal        0x1d220
00018C10 eb000434 ori        $a0, $zero, 0xeb
00018C14 03000434 ori        $a0, $zero, 3
00018C18 25280002 move       $a1, $s0
00018C1C 25302002 move       $a2, $s1
00018C20 b260000c jal        0x182c8
00018C24 25384000 move       $a3, $v0
00018C28 1000b08f lw         $s0, 0x10($sp)
00018C2C 1400b18f lw         $s1, 0x14($sp)
00018C30 1800bf8f lw         $ra, 0x18($sp)
00018C34 0800e003 jr         $ra
00018C38 2000bd27 addiu      $sp, $sp, 0x20