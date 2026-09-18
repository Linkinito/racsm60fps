000B6494 e0ffbd27 addiu      $sp, $sp, -0x20
000B6498 1000b0af sw         $s0, 0x10($sp)
000B649C 1400b1af sw         $s1, 0x14($sp)
000B64A0 1800bfaf sw         $ra, 0x18($sp)
000B64A4 12e1010c jal        0x78448
000B64A8 106b0434 ori        $a0, $zero, 0x6b10
000B64AC 25204000 move       $a0, $v0
000B64B0 2d00113c lui        $s1, 0x2d
000B64B4 08108530 andi       $a1, $a0, 0x1008
000B64B8 0a00a010 beqz       $a1, 0xb64e4
000B64BC dc343026 addiu      $s0, $s1, 0x34dc
000B64C0 24a4020c jal        0xa9090
000B64C4 25200000 move       $a0, $zero
000B64C8 24a4020c jal        0xa9090
000B64CC 07000434 ori        $a0, $zero, 7
000B64D0 04000434 ori        $a0, $zero, 4
000B64D4 ff51000c jal        0x147fc
000B64D8 25280000 move       $a1, $zero
000B64DC 26000010 b          0xb6578
000B64E0 00000000 nop        
000B64E4 00408530 andi       $a1, $a0, 0x4000
000B64E8 2000a010 beqz       $a1, 0xb656c
000B64EC 00000000 nop        
000B64F0 0800048e lw         $a0, 8($s0)
000B64F4 dc34258e lw         $a1, 0x34dc($s1)
000B64F8 80200400 sll        $a0, $a0, 2
000B64FC 2120a400 addu       $a0, $a1, $a0
000B6500 0000848c lw         $a0, ($a0)
000B6504 cc008490 lbu        $a0, 0xcc($a0)
000B6508 1b008010 beqz       $a0, 0xb6578
000B650C 00000000 nop        
000B6510 24a4020c jal        0xa9090
000B6514 01000434 ori        $a0, $zero, 1
000B6518 0800048e lw         $a0, 8($s0)
000B651C dc34258e lw         $a1, 0x34dc($s1)
000B6520 80200400 sll        $a0, $a0, 2
000B6524 2120a400 addu       $a0, $a1, $a0
000B6528 0000848c lw         $a0, ($a0)
000B652C d000918c lw         $s1, 0xd0($a0)
000B6530 08002016 bnez       $s1, 0xb6554
000B6534 00000000 nop        
000B6538 24a4020c jal        0xa9090
000B653C 07000434 ori        $a0, $zero, 7
000B6540 04000434 ori        $a0, $zero, 4
000B6544 ff51000c jal        0x147fc
000B6548 25280000 move       $a1, $zero
000B654C 05000010 b          0xb6564
000B6550 00000000 nop        
000B6554 24a4020c jal        0xa9090
000B6558 06000434 ori        $a0, $zero, 6
000B655C 32ba020c jal        0xae8c8
000B6560 25202002 move       $a0, $s1
000B6564 04000010 b          0xb6578
000B6568 00000000 nop        
000B656C 25288000 move       $a1, $a0
000B6570 c6ae020c jal        0xabb18
000B6574 25200002 move       $a0, $s0
000B6578 2d00043c lui        $a0, 0x2d
000B657C b59a020c jal        0xa6ad4
000B6580 bcf78424 addiu      $a0, $a0, -0x844
000B6584 1c0002ae sw         $v0, 0x1c($s0)
000B6588 1000b08f lw         $s0, 0x10($sp)
000B658C 1400b18f lw         $s1, 0x14($sp)
000B6590 1800bf8f lw         $ra, 0x18($sp)
000B6594 0800e003 jr         $ra
000B6598 2000bd27 addiu      $sp, $sp, 0x20
000B659C e0ffbd27 addiu      $sp, $sp, -0x20
000B65A0 1000b0af sw         $s0, 0x10($sp)
000B65A4 1400bfaf sw         $ra, 0x14($sp)
000B65A8 12e1010c jal        0x78448
000B65AC 106b0434 ori        $a0, $zero, 0x6b10
000B65B0 25204000 move       $a0, $v0
000B65B4 0400103c lui        $s0, 4
000B65B8 08008530 andi       $a1, $a0, 8
000B65BC 0800a010 beqz       $a1, 0xb65e0
000B65C0 cc631026 addiu      $s0, $s0, 0x63cc
000B65C4 24a4020c jal        0xa9090
000B65C8 25200000 move       $a0, $zero
000B65CC 04000434 ori        $a0, $zero, 4
000B65D0 ff51000c jal        0x147fc
000B65D4 25280000 move       $a1, $zero
000B65D8 2e000010 b          0xb6694
000B65DC 00000000 nop        
000B65E0 00108530 andi       $a1, $a0, 0x1000
000B65E4 0e00a010 beqz       $a1, 0xb6620
000B65E8 00000000 nop        
000B65EC 24a4020c jal        0xa9090
000B65F0 25200000 move       $a0, $zero