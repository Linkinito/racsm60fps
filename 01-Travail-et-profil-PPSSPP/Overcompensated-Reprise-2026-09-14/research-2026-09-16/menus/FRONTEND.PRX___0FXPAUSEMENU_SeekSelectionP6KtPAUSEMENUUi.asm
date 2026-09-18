00015D30 e0ffbd27 addiu      $sp, $sp, -0x20
00015D34 0800878c lw         $a3, 8($a0)
00015D38 1000b0af sw         $s0, 0x10($sp)
00015D3C 00001034 ori        $s0, $zero, 0
00015D40 2530e000 move       $a2, $a3
00015D44 5000a930 andi       $t1, $a1, 0x50
00015D48 1400bfaf sw         $ra, 0x14($sp)
00015D4C 07002015 bnez       $t1, 0x15d6c
00015D50 0000888c lw         $t0, ($a0)
00015D54 80480700 sll        $t1, $a3, 2
00015D58 21480901 addu       $t1, $t0, $t1
00015D5C 0000298d lw         $t1, ($t1)
00015D60 cc002991 lbu        $t1, 0xcc($t1)
00015D64 1e002015 bnez       $t1, 0x15de0
00015D68 00000000 nop        
00015D6C 2548a000 move       $t1, $a1
00015D70 01000534 ori        $a1, $zero, 1
00015D74 10002931 andi       $t1, $t1, 0x10
00015D78 01002055 bnel       $t1, $zero, 0x15d80
00015D7C ffff0524 addiu      $a1, $zero, -1
00015D80 04008a8c lw         $t2, 4($a0)
00015D84 ffff4925 addiu      $t1, $t2, -1
00015D88 2130c500 addu       $a2, $a2, $a1
00015D8C 0200c104 bgez       $a2, 0x15d98
00015D90 00000000 nop        
00015D94 25302001 move       $a2, $t1
00015D98 2b58ca00 sltu       $t3, $a2, $t2
00015D9C 02006015 bnez       $t3, 0x15da8
00015DA0 00000000 nop        
00015DA4 00000634 ori        $a2, $zero, 0
00015DA8 80580600 sll        $t3, $a2, 2
00015DAC 21580b01 addu       $t3, $t0, $t3
00015DB0 00006b8d lw         $t3, ($t3)
00015DB4 cc006291 lbu        $v0, 0xcc($t3)
00015DB8 05004010 beqz       $v0, 0x15dd0
00015DBC 00000000 nop        
00015DC0 cd006b91 lbu        $t3, 0xcd($t3)
00015DC4 02006011 beqz       $t3, 0x15dd0
00015DC8 00000000 nop        
00015DCC 01001034 ori        $s0, $zero, 1
00015DD0 0300c710 beq        $a2, $a3, 0x15de0
00015DD4 00000000 nop        
00015DD8 ebff0012 beqz       $s0, 0x15d88
00015DDC 00000000 nop        
00015DE0 03000012 beqz       $s0, 0x15df0
00015DE4 00000000 nop        
00015DE8 01000010 b          0x15df0
00015DEC 2538c000 move       $a3, $a2
00015DF0 03000012 beqz       $s0, 0x15e00
00015DF4 080087ac sw         $a3, 8($a0)
00015DF8 4e61000c jal        0x18538
00015DFC 08000434 ori        $a0, $zero, 8
00015E00 25100002 move       $v0, $s0
00015E04 1000b08f lw         $s0, 0x10($sp)
00015E08 1400bf8f lw         $ra, 0x14($sp)
00015E0C 0800e003 jr         $ra
00015E10 2000bd27 addiu      $sp, $sp, 0x20