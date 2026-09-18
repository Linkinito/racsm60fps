0001AB14 4e61000c jal        0x18538
0001AB18 07000434 ori        $a0, $zero, 7
0001AB1C 0c000434 ori        $a0, $zero, 0xc
0001AB20 ab03000c jal        0xeac
0001AB24 25280000 move       $a1, $zero
0001AB28 10000010 b          0x1ab6c
0001AB2C 00000000 nop        
0001AB30 00408530 andi       $a1, $a0, 0x4000
0001AB34 0a00a010 beqz       $a1, 0x1ab60
0001AB38 00000000 nop        
0001AB3C 0b002012 beqz       $s1, 0x1ab6c
0001AB40 00000000 nop        
0001AB44 4e61000c jal        0x18538
0001AB48 01000434 ori        $a0, $zero, 1
0001AB4C d000248e lw         $a0, 0xd0($s1)
0001AB50 e003000c jal        0xf80
0001AB54 01000534 ori        $a1, $zero, 1
0001AB58 04000010 b          0x1ab6c
0001AB5C 00000000 nop        
0001AB60 25288000 move       $a1, $a0
0001AB64 2557000c jal        0x15c94
0001AB68 25200002 move       $a0, $s0
0001AB6C 2001b08f lw         $s0, 0x120($sp)
0001AB70 2401b18f lw         $s1, 0x124($sp)
0001AB74 2801bf8f lw         $ra, 0x128($sp)
0001AB78 0800e003 jr         $ra
0001AB7C 3001bd27 addiu      $sp, $sp, 0x130
0001AB80 c0ffbd27 addiu      $sp, $sp, -0x40
0001AB84 2000b4e7 swc1       $f20, 0x20($sp)
0001AB88 2400b0af sw         $s0, 0x24($sp)
0001AB8C 2800b1af sw         $s1, 0x28($sp)
0001AB90 2c00b2af sw         $s2, 0x2c($sp)
0001AB94 3000bfaf sw         $ra, 0x30($sp)
0001AB98 3e39000c jal        0xe4f8
0001AB9C 00000000 nop        
0001ABA0 e738000c jal        0xe39c
0001ABA4 00000000 nop        
0001ABA8 00a08044 mtc1       $zero, $f20
0001ABAC 1000b027 addiu      $s0, $sp, 0x10
0001ABB0 d0010434 ori        $a0, $zero, 0x1d0
0001ABB4 06a30046 mov.s      $f12, $f20
0001ABB8 5247000c jal        0x11d48
0001ABBC 25280002 move       $a1, $s0
0001ABC0 e24c000c jal        0x13388
0001ABC4 25200002 move       $a0, $s0

0001B4F8 02000010 b          0x1b504
0001B4FC fbffa524 addiu      $a1, $a1, -5
0001B500 0500a524 addiu      $a1, $a1, 5
0001B504 6107000c jal        0x1d84
0001B508 1c0085ac sw         $a1, 0x1c($a0)
0001B50C 02000010 b          0x1b518
0001B510 00000000 nop        
0001B514 00001134 ori        $s1, $zero, 0
0001B518 08002012 beqz       $s1, 0x1b53c
0001B51C 00000000 nop        
0001B520 c8db4496 lhu        $a0, -0x2438($s2)
0001B524 08008428 slti       $a0, $a0, 8
0001B528 04008014 bnez       $a0, 0x1b53c
0001B52C 00000000 nop        
0001B530 4e61000c jal        0x18538
0001B534 0b000434 ori        $a0, $zero, 0xb
0001B538 c8db40a6 sh         $zero, -0x2438($s2)
0001B53C 04000010 b          0x1b550
0001B540 00000000 nop        
0001B544 25200002 move       $a0, $s0
0001B548 2557000c jal        0x15c94
0001B54C 25282002 move       $a1, $s1
0001B550 1200043c lui        $a0, 0x12
0001B554 b556000c jal        0x15ad4
0001B558 6cbb8424 addiu      $a0, $a0, -0x4494
0001B55C 766c000c jal        0x1b1d8
0001B560 1c0002ae sw         $v0, 0x1c($s0)
0001B564 7b07000c jal        0x1dec
0001B568 00000000 nop        
0001B56C 1807000c jal        0x1c60
0001B570 00000000 nop        
0001B574 bb63000c jal        0x18eec
0001B578 00000000 nop        
0001B57C 8d56000c jal        0x15a34
0001B580 25204000 move       $a0, $v0
0001B584 bb63000c jal        0x18eec
0001B588 00000000 nop        
0001B58C b556000c jal        0x15ad4
0001B590 25204000 move       $a0, $v0
0001B594 1c0002ae sw         $v0, 0x1c($s0)
0001B598 1000b08f lw         $s0, 0x10($sp)
0001B59C 1400b18f lw         $s1, 0x14($sp)
0001B5A0 1800b28f lw         $s2, 0x18($sp)
0001B5A4 1c00bf8f lw         $ra, 0x1c($sp)
0001B5A8 0800e003 jr         $ra