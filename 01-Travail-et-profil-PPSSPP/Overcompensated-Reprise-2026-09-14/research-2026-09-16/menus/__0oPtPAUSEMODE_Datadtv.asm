0002FED4 e0ffbd27 addiu      $sp, $sp, -0x20
0002FED8 1400b1af sw         $s1, 0x14($sp)
0002FEDC 25888000 move       $s1, $a0
0002FEE0 1000b0af sw         $s0, 0x10($sp)
0002FEE4 1800bfaf sw         $ra, 0x18($sp)
0002FEE8 09008010 beqz       $a0, 0x2ff10
0002FEEC 2580a000 move       $s0, $a1
0002FEF0 2c002426 addiu      $a0, $s1, 0x2c
0002FEF4 d3bf000c jal        0x2ff4c
0002FEF8 02000534 ori        $a1, $zero, 2
0002FEFC 01000432 andi       $a0, $s0, 1
0002FF00 03008010 beqz       $a0, 0x2ff10
0002FF04 00000000 nop        
0002FF08 317f000c jal        0x1fcc4
0002FF0C 25202002 move       $a0, $s1
0002FF10 1000b08f lw         $s0, 0x10($sp)
0002FF14 1400b18f lw         $s1, 0x14($sp)
0002FF18 1800bf8f lw         $ra, 0x18($sp)
0002FF1C 0800e003 jr         $ra
0002FF20 2000bd27 addiu      $sp, $sp, 0x20