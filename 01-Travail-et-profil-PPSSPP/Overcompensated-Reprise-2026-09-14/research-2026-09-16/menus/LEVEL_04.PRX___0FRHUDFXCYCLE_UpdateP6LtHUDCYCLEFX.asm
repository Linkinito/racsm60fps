000A6A34 2000878c lw         $a3, 0x20($a0)
000A6A38 01000634 ori        $a2, $zero, 1
000A6A3C 1d00e610 beq        $a3, $a2, 0xa6ab4
000A6A40 2400858c lw         $a1, 0x24($a0)
000A6A44 1c008690 lbu        $a2, 0x1c($a0)
000A6A48 0e00c010 beqz       $a2, 0xa6a84
000A6A4C 08008cc4 lwc1       $f12, 8($a0)
000A6A50 14008dc4 lwc1       $f13, 0x14($a0)
000A6A54 40630d46 add.s      $f13, $f12, $f13
000A6A58 10008cc4 lwc1       $f12, 0x10($a0)
000A6A5C 3c680c46 c.lt.s     $f13, $f12
000A6A60 00000000 nop        
000A6A64 13000145 bc1t       0xa6ab4
000A6A68 08008de4 swc1       $f13, 8($a0)
000A6A6C 02000834 ori        $t0, $zero, 2
000A6A70 1000e810 beq        $a3, $t0, 0xa6ab4
000A6A74 08008ce4 swc1       $f12, 8($a0)
000A6A78 0100c62c sltiu      $a2, $a2, 1
000A6A7C 0d000010 b          0xa6ab4
000A6A80 1c0086a0 sb         $a2, 0x1c($a0)
000A6A84 18008dc4 lwc1       $f13, 0x18($a0)
000A6A88 41630d46 sub.s      $f13, $f12, $f13
000A6A8C 0c008cc4 lwc1       $f12, 0xc($a0)
000A6A90 3e680c46 c.le.s     $f13, $f12
000A6A94 00000000 nop        
000A6A98 06000045 bc1f       0xa6ab4
000A6A9C 08008de4 swc1       $f13, 8($a0)
000A6AA0 03000834 ori        $t0, $zero, 3
000A6AA4 0300e810 beq        $a3, $t0, 0xa6ab4
000A6AA8 08008ce4 swc1       $f12, 8($a0)
000A6AAC 0100c62c sltiu      $a2, $a2, 1
000A6AB0 1c0086a0 sb         $a2, 0x1c($a0)
000A6AB4 0500a010 beqz       $a1, 0xa6acc
000A6AB8 00000000 nop        
000A6ABC ffffa524 addiu      $a1, $a1, -1
000A6AC0 0200a014 bnez       $a1, 0xa6acc
000A6AC4 240085ac sw         $a1, 0x24($a0)
000A6AC8 200080ac sw         $zero, 0x20($a0)
000A6ACC 0800e003 jr         $ra
000A6AD0 00000000 nop        