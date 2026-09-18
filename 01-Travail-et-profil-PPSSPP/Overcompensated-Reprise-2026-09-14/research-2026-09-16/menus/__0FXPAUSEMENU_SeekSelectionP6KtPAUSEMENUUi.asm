00015F30 e0ffbd27 addiu      $sp, $sp, -0x20
00015F34 0800878c lw         $a3, 8($a0)
00015F38 1000b0af sw         $s0, 0x10($sp)
00015F3C 00001034 ori        $s0, $zero, 0
00015F40 2530e000 move       $a2, $a3
00015F44 5000a930 andi       $t1, $a1, 0x50
00015F48 1400bfaf sw         $ra, 0x14($sp)
00015F4C 07002015 bnez       $t1, 0x15f6c
00015F50 0000888c lw         $t0, ($a0)
00015F54 80480700 sll        $t1, $a3, 2
00015F58 21480901 addu       $t1, $t0, $t1
00015F5C 0000298d lw         $t1, ($t1)
00015F60 cc002991 lbu        $t1, 0xcc($t1)
00015F64 1e002015 bnez       $t1, 0x15fe0
00015F68 00000000 nop        
00015F6C 2548a000 move       $t1, $a1
00015F70 01000534 ori        $a1, $zero, 1
00015F74 10002931 andi       $t1, $t1, 0x10
00015F78 01002055 bnel       $t1, $zero, 0x15f80
00015F7C ffff0524 addiu      $a1, $zero, -1
00015F80 04008a8c lw         $t2, 4($a0)
00015F84 ffff4925 addiu      $t1, $t2, -1
00015F88 2130c500 addu       $a2, $a2, $a1
00015F8C 0200c104 bgez       $a2, 0x15f98
00015F90 00000000 nop        
00015F94 25302001 move       $a2, $t1
00015F98 2b58ca00 sltu       $t3, $a2, $t2
00015F9C 02006015 bnez       $t3, 0x15fa8
00015FA0 00000000 nop        
00015FA4 00000634 ori        $a2, $zero, 0
00015FA8 80580600 sll        $t3, $a2, 2
00015FAC 21580b01 addu       $t3, $t0, $t3
00015FB0 00006b8d lw         $t3, ($t3)
00015FB4 cc006291 lbu        $v0, 0xcc($t3)
00015FB8 05004010 beqz       $v0, 0x15fd0
00015FBC 00000000 nop        
00015FC0 cd006b91 lbu        $t3, 0xcd($t3)
00015FC4 02006011 beqz       $t3, 0x15fd0
00015FC8 00000000 nop        
00015FCC 01001034 ori        $s0, $zero, 1
00015FD0 0300c710 beq        $a2, $a3, 0x15fe0
00015FD4 00000000 nop        
00015FD8 ebff0012 beqz       $s0, 0x15f88
00015FDC 00000000 nop        
00015FE0 03000012 beqz       $s0, 0x15ff0
00015FE4 00000000 nop        
00015FE8 01000010 b          0x15ff0
00015FEC 2538c000 move       $a3, $a2
00015FF0 03000012 beqz       $s0, 0x16000
00015FF4 080087ac sw         $a3, 8($a0)
00015FF8 9b61000c jal        0x1866c
00015FFC 08000434 ori        $a0, $zero, 8
00016000 25100002 move       $v0, $s0
00016004 1000b08f lw         $s0, 0x10($sp)
00016008 1400bf8f lw         $ra, 0x14($sp)
0001600C 0800e003 jr         $ra
00016010 2000bd27 addiu      $sp, $sp, 0x20