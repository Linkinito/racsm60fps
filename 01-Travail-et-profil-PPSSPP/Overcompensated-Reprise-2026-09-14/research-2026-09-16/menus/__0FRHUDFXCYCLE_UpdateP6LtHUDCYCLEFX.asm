00015C34 2000878c lw         $a3, 0x20($a0)
00015C38 01000634 ori        $a2, $zero, 1
00015C3C 1d00e610 beq        $a3, $a2, 0x15cb4
00015C40 2400858c lw         $a1, 0x24($a0)
00015C44 1c008690 lbu        $a2, 0x1c($a0)
00015C48 0e00c010 beqz       $a2, 0x15c84
00015C4C 08008cc4 lwc1       $f12, 8($a0)
00015C50 14008dc4 lwc1       $f13, 0x14($a0)
00015C54 40630d46 add.s      $f13, $f12, $f13
00015C58 10008cc4 lwc1       $f12, 0x10($a0)
00015C5C 3c680c46 c.lt.s     $f13, $f12
00015C60 00000000 nop        
00015C64 13000145 bc1t       0x15cb4
00015C68 08008de4 swc1       $f13, 8($a0)
00015C6C 02000834 ori        $t0, $zero, 2
00015C70 1000e810 beq        $a3, $t0, 0x15cb4
00015C74 08008ce4 swc1       $f12, 8($a0)
00015C78 0100c62c sltiu      $a2, $a2, 1
00015C7C 0d000010 b          0x15cb4
00015C80 1c0086a0 sb         $a2, 0x1c($a0)
00015C84 18008dc4 lwc1       $f13, 0x18($a0)
00015C88 41630d46 sub.s      $f13, $f12, $f13
00015C8C 0c008cc4 lwc1       $f12, 0xc($a0)
00015C90 3e680c46 c.le.s     $f13, $f12
00015C94 00000000 nop        
00015C98 06000045 bc1f       0x15cb4
00015C9C 08008de4 swc1       $f13, 8($a0)
00015CA0 03000834 ori        $t0, $zero, 3
00015CA4 0300e810 beq        $a3, $t0, 0x15cb4
00015CA8 08008ce4 swc1       $f12, 8($a0)
00015CAC 0100c62c sltiu      $a2, $a2, 1
00015CB0 1c0086a0 sb         $a2, 0x1c($a0)
00015CB4 0500a010 beqz       $a1, 0x15ccc
00015CB8 00000000 nop        
00015CBC ffffa524 addiu      $a1, $a1, -1
00015CC0 0200a014 bnez       $a1, 0x15ccc
00015CC4 240085ac sw         $a1, 0x24($a0)
00015CC8 200080ac sw         $zero, 0x20($a0)
00015CCC 0800e003 jr         $ra
00015CD0 00000000 nop        