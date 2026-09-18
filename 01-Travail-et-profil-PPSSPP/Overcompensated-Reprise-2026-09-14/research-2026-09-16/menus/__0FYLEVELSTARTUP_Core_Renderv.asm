00018CB4 c0ffbd27 addiu      $sp, $sp, -0x40
00018CB8 3000b0af sw         $s0, 0x30($sp)
00018CBC 3400bfaf sw         $ra, 0x34($sp)
00018CC0 4339000c jal        0xe50c
00018CC4 00000000 nop        
00018CC8 de38000c jal        0xe378
00018CCC 00000000 nop        
00018CD0 ec38000c jal        0xe3b0
00018CD4 00000000 nop        
00018CD8 1200043c lui        $a0, 0x12
00018CDC 10fa848c lw         $a0, -0x5f0($a0)
00018CE0 feff8424 addiu      $a0, $a0, -2
00018CE4 2000852c sltiu      $a1, $a0, 0x20
00018CE8 4600a010 beqz       $a1, 0x18e04
00018CEC 00000000 nop        
00018CF0 80200400 sll        $a0, $a0, 2
00018CF4 0300013c lui        $at, 3
00018CF8 21082400 addu       $at, $at, $a0
00018CFC f01f218c lw         $at, 0x1ff0($at)
00018D00 08002000 jr         $at
00018D04 00000000 nop        
00018D08 3e000010 b          0x18e04
00018D0C 00000000 nop        
00018D10 1200043c lui        $a0, 0x12
00018D14 1cfa848c lw         $a0, -0x5e4($a0)
00018D18 09008528 slti       $a1, $a0, 9
00018D1C 0500a010 beqz       $a1, 0x18d34
00018D20 02000534 ori        $a1, $zero, 2
00018D24 0a008514 bne        $a0, $a1, 0x18d50
00018D28 00000000 nop        
00018D2C 0e000010 b          0x18d68
00018D30 00000000 nop        
00018D34 0b008428 slti       $a0, $a0, 0xb
00018D38 05008010 beqz       $a0, 0x18d50
00018D3C 00000000 nop        
00018D40 0f63000c jal        0x18c3c
00018D44 00000000 nop        
00018D48 07000010 b          0x18d68
00018D4C 00000000 nop        
00018D50 25200000 move       $a0, $zero
00018D54 25280000 move       $a1, $zero
00018D58 e0010634 ori        $a2, $zero, 0x1e0
00018D5C 10010734 ori        $a3, $zero, 0x110
00018D60 2d40000c jal        0x100b4
00018D64 00ff083c lui        $t0, 0xff00
00018D68 26000010 b          0x18e04
00018D6C 00000000 nop        
00018D70 24000010 b          0x18e04
00018D74 00000000 nop        
00018D78 ffff1024 addiu      $s0, $zero, -1
00018D7C 25200000 move       $a0, $zero
00018D80 25280000 move       $a1, $zero
00018D84 e0010634 ori        $a2, $zero, 0x1e0
00018D88 10010734 ori        $a3, $zero, 0x110
00018D8C 2d40000c jal        0x100b4
00018D90 ffff0824 addiu      $t0, $zero, -1
00018D94 1200043c lui        $a0, 0x12
00018D98 5cf6848c lw         $a0, -0x9a4($a0)
00018D9C 10010234 ori        $v0, $zero, 0x110
00018DA0 0000a2af sw         $v0, ($sp)
00018DA4 25280000 move       $a1, $zero
00018DA8 25300000 move       $a2, $zero
00018DAC e0010734 ori        $a3, $zero, 0x1e0
00018DB0 10010834 ori        $t0, $zero, 0x110
00018DB4 25480000 move       $t1, $zero
00018DB8 25500000 move       $t2, $zero
00018DBC e0010b34 ori        $t3, $zero, 0x1e0
00018DC0 9c41000c jal        0x10670
00018DC4 0400b0af sw         $s0, 4($sp)
00018DC8 1200043c lui        $a0, 0x12
00018DCC b459000c jal        0x166d0
00018DD0 70fe8424 addiu      $a0, $a0, -0x190
00018DD4 765f000c jal        0x17dd8
00018DD8 00000000 nop        
00018DDC 09000010 b          0x18e04
00018DE0 00000000 nop        
00018DE4 0f63000c jal        0x18c3c
00018DE8 00000000 nop        
00018DEC 765f000c jal        0x17dd8
00018DF0 00000000 nop        
00018DF4 03000010 b          0x18e04
00018DF8 00000000 nop        
00018DFC 765f000c jal        0x17dd8
00018E00 00000000 nop        
00018E04 4837000c jal        0xdd20
00018E08 00000000 nop        
00018E0C 3000b08f lw         $s0, 0x30($sp)
00018E10 3400bf8f lw         $ra, 0x34($sp)
00018E14 0800e003 jr         $ra
00018E18 4000bd27 addiu      $sp, $sp, 0x40