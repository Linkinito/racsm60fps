00019058 e0ffbd27 addiu      $sp, $sp, -0x20
0001905C 1000b0af sw         $s0, 0x10($sp)
00019060 1400b1af sw         $s1, 0x14($sp)
00019064 1800bfaf sw         $ra, 0x18($sp)
00019068 dd73000c jal        0x1cf74
0001906C 6b010434 ori        $a0, $zero, 0x16b
00019070 25804000 move       $s0, $v0
00019074 dd73000c jal        0x1cf74
00019078 25020434 ori        $a0, $zero, 0x225
0001907C 25884000 move       $s1, $v0
00019080 dd73000c jal        0x1cf74
00019084 36010434 ori        $a0, $zero, 0x136
00019088 03000434 ori        $a0, $zero, 3
0001908C 25280002 move       $a1, $s0
00019090 25302002 move       $a2, $s1
00019094 6560000c jal        0x18194
00019098 25384000 move       $a3, $v0
0001909C 1000b08f lw         $s0, 0x10($sp)
000190A0 1400b18f lw         $s1, 0x14($sp)
000190A4 1800bf8f lw         $ra, 0x18($sp)
000190A8 0800e003 jr         $ra
000190AC 2000bd27 addiu      $sp, $sp, 0x20