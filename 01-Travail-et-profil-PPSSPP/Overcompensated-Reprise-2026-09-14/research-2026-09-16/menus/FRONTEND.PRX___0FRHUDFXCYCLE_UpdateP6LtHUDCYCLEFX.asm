00015A34 2000878c lw         $a3, 0x20($a0)
00015A38 01000634 ori        $a2, $zero, 1
00015A3C 1d00e610 beq        $a3, $a2, 0x15ab4
00015A40 2400858c lw         $a1, 0x24($a0)
00015A44 1c008690 lbu        $a2, 0x1c($a0)
00015A48 0e00c010 beqz       $a2, 0x15a84
00015A4C 08008cc4 lwc1       $f12, 8($a0)
00015A50 14008dc4 lwc1       $f13, 0x14($a0)
00015A54 40630d46 add.s      $f13, $f12, $f13
00015A58 10008cc4 lwc1       $f12, 0x10($a0)
00015A5C 3c680c46 c.lt.s     $f13, $f12
00015A60 00000000 nop        
00015A64 13000145 bc1t       0x15ab4
00015A68 08008de4 swc1       $f13, 8($a0)
00015A6C 02000834 ori        $t0, $zero, 2
00015A70 1000e810 beq        $a3, $t0, 0x15ab4
00015A74 08008ce4 swc1       $f12, 8($a0)
00015A78 0100c62c sltiu      $a2, $a2, 1
00015A7C 0d000010 b          0x15ab4
00015A80 1c0086a0 sb         $a2, 0x1c($a0)
00015A84 18008dc4 lwc1       $f13, 0x18($a0)
00015A88 41630d46 sub.s      $f13, $f12, $f13
00015A8C 0c008cc4 lwc1       $f12, 0xc($a0)
00015A90 3e680c46 c.le.s     $f13, $f12
00015A94 00000000 nop        
00015A98 06000045 bc1f       0x15ab4
00015A9C 08008de4 swc1       $f13, 8($a0)
00015AA0 03000834 ori        $t0, $zero, 3
00015AA4 0300e810 beq        $a3, $t0, 0x15ab4
00015AA8 08008ce4 swc1       $f12, 8($a0)
00015AAC 0100c62c sltiu      $a2, $a2, 1
00015AB0 1c0086a0 sb         $a2, 0x1c($a0)
00015AB4 0500a010 beqz       $a1, 0x15acc
00015AB8 00000000 nop        
00015ABC ffffa524 addiu      $a1, $a1, -1
00015AC0 0200a014 bnez       $a1, 0x15acc
00015AC4 240085ac sw         $a1, 0x24($a0)
00015AC8 200080ac sw         $zero, 0x20($a0)
00015ACC 0800e003 jr         $ra
00015AD0 00000000 nop        