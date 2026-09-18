0001B200 f5000434 ori        $a0, $zero, 0xf5
0001B204 25388000 move       $a3, $a0
0001B208 24db2426 addiu      $a0, $s1, -0x24dc
0001B20C 25280000 move       $a1, $zero
0001B210 01000634 ori        $a2, $zero, 1
0001B214 8557000c jal        0x15e14
0001B218 25400000 move       $t0, $zero
0001B21C 302a058e lw         $a1, 0x2a30($s0)
0001B220 f6000434 ori        $a0, $zero, 0xf6
0001B224 1000a58c lw         $a1, 0x10($a1)
0001B228 0100a054 bnel       $a1, $zero, 0x1b230
0001B22C f5000434 ori        $a0, $zero, 0xf5
0001B230 25388000 move       $a3, $a0
0001B234 24db2426 addiu      $a0, $s1, -0x24dc
0001B238 03000534 ori        $a1, $zero, 3
0001B23C 01000634 ori        $a2, $zero, 1
0001B240 8557000c jal        0x15e14
0001B244 25400000 move       $t0, $zero
0001B248 302a058e lw         $a1, 0x2a30($s0)
0001B24C f6000434 ori        $a0, $zero, 0xf6
0001B250 1400a58c lw         $a1, 0x14($a1)
0001B254 0100a054 bnel       $a1, $zero, 0x1b25c
0001B258 f5000434 ori        $a0, $zero, 0xf5
0001B25C 25388000 move       $a3, $a0
0001B260 24db2426 addiu      $a0, $s1, -0x24dc
0001B264 04000534 ori        $a1, $zero, 4
0001B268 01000634 ori        $a2, $zero, 1
0001B26C 8557000c jal        0x15e14
0001B270 25400000 move       $t0, $zero
0001B274 2000b08f lw         $s0, 0x20($sp)
0001B278 2400b18f lw         $s1, 0x24($sp)
0001B27C 2800bf8f lw         $ra, 0x28($sp)
0001B280 0800e003 jr         $ra
0001B284 3000bd27 addiu      $sp, $sp, 0x30
0001B288 e0ffbd27 addiu      $sp, $sp, -0x20
0001B28C 1000b0af sw         $s0, 0x10($sp)
0001B290 1400b1af sw         $s1, 0x14($sp)
0001B294 1800b2af sw         $s2, 0x18($sp)
0001B298 1c00bfaf sw         $ra, 0x1c($sp)
0001B29C 5a38000c jal        0xe168
0001B2A0 ffff0424 addiu      $a0, $zero, -1
0001B2A4 6310000c jal        0x418c
0001B2A8 00000000 nop        
0001B2AC 25200000 move       $a0, $zero
0001B2B0 7311000c jal        0x45cc
0001B2B4 25280000 move       $a1, $zero
0001B2B8 5a05000c jal        0x1568
0001B2BC 00000000 nop        
0001B2C0 3b37000c jal        0xdcec
0001B2C4 00000000 nop        
0001B2C8 e010000c jal        0x4380
0001B2CC 01000434 ori        $a0, $zero, 1
0001B2D0 25884000 move       $s1, $v0
0001B2D4 ce10000c jal        0x4338
0001B2D8 01000434 ori        $a0, $zero, 1
0001B2DC 1200103c lui        $s0, 0x12
0001B2E0 25204000 move       $a0, $v0
0001B2E4 08102532 andi       $a1, $s1, 0x1008
0001B2E8 0a00a010 beqz       $a1, 0x1b314
0001B2EC 24db1026 addiu      $s0, $s0, -0x24dc
0001B2F0 4e61000c jal        0x18538
0001B2F4 25200000 move       $a0, $zero
0001B2F8 4e61000c jal        0x18538
0001B2FC 07000434 ori        $a0, $zero, 7
0001B300 0c000434 ori        $a0, $zero, 0xc
0001B304 ab03000c jal        0xeac
0001B308 0a000534 ori        $a1, $zero, 0xa
0001B30C 90000010 b          0x1b550
0001B310 00000000 nop        
0001B314 00402532 andi       $a1, $s1, 0x4000
0001B318 2800a010 beqz       $a1, 0x1b3bc
0001B31C 00000000 nop        
0001B320 0800058e lw         $a1, 8($s0)
0001B324 0300a628 slti       $a2, $a1, 3
0001B328 0a00c010 beqz       $a2, 0x1b354
0001B32C 01000434 ori        $a0, $zero, 1
0001B330 1b00a014 bnez       $a1, 0x1b3a0
0001B334 00000000 nop        
0001B338 1100053c lui        $a1, 0x11
0001B33C 302aa58c lw         $a1, 0x2a30($a1)
0001B340 01000634 ori        $a2, $zero, 1
0001B344 0c00a78c lw         $a3, 0xc($a1)
0001B348 2330c700 subu       $a2, $a2, $a3
0001B34C 15000010 b          0x1b3a4
0001B350 0c00a6ac sw         $a2, 0xc($a1)
0001B354 0400a628 slti       $a2, $a1, 4
0001B358 0a00c014 bnez       $a2, 0x1b384
0001B35C 0500a528 slti       $a1, $a1, 5
0001B360 0f00a010 beqz       $a1, 0x1b3a0
0001B364 00000000 nop        
0001B368 1100053c lui        $a1, 0x11
0001B36C 302aa58c lw         $a1, 0x2a30($a1)
0001B370 01000634 ori        $a2, $zero, 1
0001B374 1400a78c lw         $a3, 0x14($a1)
0001B378 2330c700 subu       $a2, $a2, $a3
0001B37C 09000010 b          0x1b3a4
0001B380 1400a6ac sw         $a2, 0x14($a1)
0001B384 1100053c lui        $a1, 0x11
0001B388 302aa58c lw         $a1, 0x2a30($a1)
0001B38C 01000634 ori        $a2, $zero, 1
0001B390 1000a78c lw         $a3, 0x10($a1)
0001B394 2330c700 subu       $a2, $a2, $a3
0001B398 02000010 b          0x1b3a4
0001B39C 1000a6ac sw         $a2, 0x10($a1)
0001B3A0 00000434 ori        $a0, $zero, 0
0001B3A4 03008010 beqz       $a0, 0x1b3b4
0001B3A8 00000000 nop        
0001B3AC 4e61000c jal        0x18538
0001B3B0 0b000434 ori        $a0, $zero, 0xb
0001B3B4 66000010 b          0x1b550
0001B3B8 00000000 nop        
0001B3BC a0002532 andi       $a1, $s1, 0xa0
0001B3C0 2800a010 beqz       $a1, 0x1b464
0001B3C4 00000000 nop        
0001B3C8 0800058e lw         $a1, 8($s0)
0001B3CC 0300a628 slti       $a2, $a1, 3
0001B3D0 0a00c010 beqz       $a2, 0x1b3fc
0001B3D4 01000434 ori        $a0, $zero, 1
0001B3D8 1b00a014 bnez       $a1, 0x1b448
0001B3DC 00000000 nop        
0001B3E0 1100053c lui        $a1, 0x11
0001B3E4 302aa58c lw         $a1, 0x2a30($a1)
0001B3E8 01000634 ori        $a2, $zero, 1
0001B3EC 0c00a78c lw         $a3, 0xc($a1)
0001B3F0 2330c700 subu       $a2, $a2, $a3
0001B3F4 15000010 b          0x1b44c
0001B3F8 0c00a6ac sw         $a2, 0xc($a1)
0001B3FC 0400a628 slti       $a2, $a1, 4
0001B400 0a00c014 bnez       $a2, 0x1b42c
0001B404 0500a528 slti       $a1, $a1, 5
0001B408 0f00a010 beqz       $a1, 0x1b448
0001B40C 00000000 nop        
0001B410 1100053c lui        $a1, 0x11
0001B414 302aa58c lw         $a1, 0x2a30($a1)
0001B418 01000634 ori        $a2, $zero, 1
0001B41C 1400a78c lw         $a3, 0x14($a1)
0001B420 2330c700 subu       $a2, $a2, $a3
0001B424 09000010 b          0x1b44c
0001B428 1400a6ac sw         $a2, 0x14($a1)
0001B42C 1100053c lui        $a1, 0x11
0001B430 302aa58c lw         $a1, 0x2a30($a1)
0001B434 01000634 ori        $a2, $zero, 1
0001B438 1000a78c lw         $a3, 0x10($a1)
0001B43C 2330c700 subu       $a2, $a2, $a3
0001B440 02000010 b          0x1b44c
0001B444 1000a6ac sw         $a2, 0x10($a1)
0001B448 00000434 ori        $a0, $zero, 0
0001B44C 03008010 beqz       $a0, 0x1b45c
0001B450 00000000 nop        
0001B454 4e61000c jal        0x18538
0001B458 0b000434 ori        $a0, $zero, 0xb
0001B45C 3c000010 b          0x1b550
0001B460 00000000 nop        
0001B464 a0008530 andi       $a1, $a0, 0xa0
0001B468 3600a010 beqz       $a1, 0x1b544
0001B46C 00000000 nop        
0001B470 1200123c lui        $s2, 0x12
0001B474 c8db4696 lhu        $a2, -0x2438($s2)
0001B478 0800058e lw         $a1, 8($s0)
0001B47C 0100c624 addiu      $a2, $a2, 1
0001B480 c8db46a6 sh         $a2, -0x2438($s2)
0001B484 0200a628 slti       $a2, $a1, 2
0001B488 0500c010 beqz       $a2, 0x1b4a0
0001B48C 01001134 ori        $s1, $zero, 1
0001B490 2000a018 blez       $a1, 0x1b514
0001B494 00000000 nop        
0001B498 06000010 b          0x1b4b4
0001B49C 00000000 nop        
0001B4A0 0300a528 slti       $a1, $a1, 3
0001B4A4 0f00a014 bnez       $a1, 0x1b4e4
0001B4A8 00000000 nop        
0001B4AC 19000010 b          0x1b514
0001B4B0 00000000 nop        
0001B4B4 1100053c lui        $a1, 0x11
0001B4B8 302aa58c lw         $a1, 0x2a30($a1)
0001B4BC 80008630 andi       $a2, $a0, 0x80
0001B4C0 0300c010 beqz       $a2, 0x1b4d0
0001B4C4 1800a48c lw         $a0, 0x18($a1)
0001B4C8 02000010 b          0x1b4d4
0001B4CC fbff8424 addiu      $a0, $a0, -5
0001B4D0 05008424 addiu      $a0, $a0, 5
0001B4D4 6107000c jal        0x1d84
0001B4D8 1800a4ac sw         $a0, 0x18($a1)
0001B4DC 0e000010 b          0x1b518
0001B4E0 00000000 nop        
0001B4E4 80008630 andi       $a2, $a0, 0x80
0001B4E8 1100043c lui        $a0, 0x11
0001B4EC 302a848c lw         $a0, 0x2a30($a0)
0001B4F0 0300c010 beqz       $a2, 0x1b500
0001B4F4 1c00858c lw         $a1, 0x1c($a0)
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
0001B5AC 2000bd27 addiu      $sp, $sp, 0x20
0001B5B0 d0ffbd27 addiu      $sp, $sp, -0x30
0001B5B4 25308000 move       $a2, $a0
0001B5B8 2400bfaf sw         $ra, 0x24($sp)
0001B5BC 0f00c014 bnez       $a2, 0x1b5fc
0001B5C0 00000000 nop        
0001B5C4 1200053c lui        $a1, 0x12
0001B5C8 0300063c lui        $a2, 3
0001B5CC 0300083c lui        $t0, 3
0001B5D0 01000434 ori        $a0, $zero, 1
0001B5D4 71000734 ori        $a3, $zero, 0x71
0001B5D8 d0dfa524 addiu      $a1, $a1, -0x2030
0001B5DC e025c624 addiu      $a2, $a2, 0x25e0
0001B5E0 4771000c jal        0x1c51c
0001B5E4 10260825 addiu      $t0, $t0, 0x2610
0001B5E8 0300043c lui        $a0, 3
0001B5EC 5271000c jal        0x1c548
0001B5F0 14268424 addiu      $a0, $a0, 0x2614
0001B5F4 1b000010 b          0x1b664
0001B5F8 25100000 move       $v0, $zero
0001B5FC 2138a600 addu       $a3, $a1, $a2
0001B600 ffff0424 addiu      $a0, $zero, -1
0001B604 2000a4af sw         $a0, 0x20($sp)
0001B608 2528c000 move       $a1, $a2
0001B60C 2b40a700 sltu       $t0, $a1, $a3
0001B610 ffff0624 addiu      $a2, $zero, -1
0001B614 10000011 beqz       $t0, 0x1b658
0001B618 2000a427 addiu      $a0, $sp, 0x20
0001B61C 1200083c lui        $t0, 0x12
0001B620 d0db0825 addiu      $t0, $t0, -0x2430
0001B624 0000a990 lbu        $t1, ($a1)
0001B628 ff00ca30 andi       $t2, $a2, 0xff
0001B62C ff002931 andi       $t1, $t1, 0xff
0001B630 26482a01 xor        $t1, $t1, $t2
0001B634 80480900 sll        $t1, $t1, 2
0001B638 21482801 addu       $t1, $t1, $t0
0001B63C 0000298d lw         $t1, ($t1)
0001B640 02320600 srl        $a2, $a2, 8
0001B644 0100a524 addiu      $a1, $a1, 1
0001B648 2630c900 xor        $a2, $a2, $t1
0001B64C 2b48a700 sltu       $t1, $a1, $a3
0001B650 f4ff2015 bnez       $t1, 0x1b624
0001B654 2000a6af sw         $a2, 0x20($sp)
0001B658 2728c000 not        $a1, $a2
0001B65C 2000a5af sw         $a1, 0x20($sp)
0001B660 0000828c lw         $v0, ($a0)
0001B664 2400bf8f lw         $ra, 0x24($sp)
0001B668 0800e003 jr         $ra
0001B66C 3000bd27 addiu      $sp, $sp, 0x30
0001B670 d0ffbd27 addiu      $sp, $sp, -0x30
0001B674 2000bfaf sw         $ra, 0x20($sp)
0001B678 0f008014 bnez       $a0, 0x1b6b8
0001B67C 00000000 nop        
0001B680 1200053c lui        $a1, 0x12
0001B684 0300063c lui        $a2, 3
0001B688 0300083c lui        $t0, 3
0001B68C 01000434 ori        $a0, $zero, 1
0001B690 b9000734 ori        $a3, $zero, 0xb9
0001B694 e9dfa524 addiu      $a1, $a1, -0x2017
0001B698 e025c624 addiu      $a2, $a2, 0x25e0
0001B69C 4771000c jal        0x1c51c
0001B6A0 10260825 addiu      $t0, $t0, 0x2610
0001B6A4 0300043c lui        $a0, 3
0001B6A8 5271000c jal        0x1c548
0001B6AC 48268424 addiu      $a0, $a0, 0x2648
0001B6B0 2c000010 b          0x1b764
0001B6B4 25100000 move       $v0, $zero
0001B6B8 25288000 move       $a1, $a0
0001B6BC 0000a490 lbu        $a0, ($a1)
0001B6C0 27008010 beqz       $a0, 0x1b760
0001B6C4 ffff0624 addiu      $a2, $zero, -1
0001B6C8 1200073c lui        $a3, 0x12
0001B6CC 2f000934 ori        $t1, $zero, 0x2f
0001B6D0 5c000834 ori        $t0, $zero, 0x5c
0001B6D4 d0dbe724 addiu      $a3, $a3, -0x2430
0001B6D8 2558a000 move       $t3, $a1
0001B6DC 00006a91 lbu        $t2, ($t3)
0001B6E0 03004911 beq        $t2, $t1, 0x1b6f0
0001B6E4 00000000 nop        
0001B6E8 08004815 bne        $t2, $t0, 0x1b70c
0001B6EC 00000000 nop        
0001B6F0 04004951 beql       $t2, $t1, 0x1b704
0001B6F4 01006b25 addiu      $t3, $t3, 1
0001B6F8 04004815 bne        $t2, $t0, 0x1b70c
0001B6FC 00000000 nop        
0001B700 01006b25 addiu      $t3, $t3, 1
0001B704 faff0010 b          0x1b6f0
0001B708 00006a91 lbu        $t2, ($t3)
0001B70C 25508000 move       $t2, $a0
0001B710 61004b29 slti       $t3, $t2, 0x61
0001B714 05006015 bnez       $t3, 0x1b72c
0001B718 7b008b28 slti       $t3, $a0, 0x7b
0001B71C 03006011 beqz       $t3, 0x1b72c
0001B720 00000000 nop        
0001B724 e0ff8a24 addiu      $t2, $a0, -0x20
0001B728 ff004a31 andi       $t2, $t2, 0xff
0001B72C 02004915 bne        $t2, $t1, 0x1b738
0001B730 ff00c430 andi       $a0, $a2, 0xff
0001B734 25500001 move       $t2, $t0
0001B738 26204401 xor        $a0, $t2, $a0
0001B73C 80200400 sll        $a0, $a0, 2
0001B740 21208700 addu       $a0, $a0, $a3
0001B744 0000848c lw         $a0, ($a0)
0001B748 02320600 srl        $a2, $a2, 8
0001B74C 0100a524 addiu      $a1, $a1, 1
0001B750 2630c400 xor        $a2, $a2, $a0
0001B754 0000a490 lbu        $a0, ($a1)
0001B758 dfff8014 bnez       $a0, 0x1b6d8
0001B75C 00000000 nop        
0001B760 2710c000 not        $v0, $a2
0001B764 2000bf8f lw         $ra, 0x20($sp)
0001B768 0800e003 jr         $ra
0001B76C 3000bd27 addiu      $sp, $sp, 0x30
0001B770 1200083c lui        $t0, 0x12
0001B774 20e0078d lw         $a3, -0x1fe0($t0)
0001B778 00000234 ori        $v0, $zero, 0
0001B77C 2b304700 sltu       $a2, $v0, $a3
0001B780 1000c010 beqz       $a2, 0x1b7c4
0001B784 0800063c lui        $a2, 8
0001B788 e0f4c624 addiu      $a2, $a2, -0xb20
0001B78C 0000c98c lw         $t1, ($a2)
0001B790 04002415 bne        $t1, $a0, 0x1b7a4
0001B794 00000000 nop        
0001B798 0400c98c lw         $t1, 4($a2)
0001B79C 07002511 beq        $t1, $a1, 0x1b7bc
0001B7A0 00000000 nop        
0001B7A4 01004224 addiu      $v0, $v0, 1
0001B7A8 2b484700 sltu       $t1, $v0, $a3
0001B7AC f7ff2015 bnez       $t1, 0x1b78c
0001B7B0 1400c624 addiu      $a2, $a2, 0x14
0001B7B4 03000010 b          0x1b7c4
0001B7B8 00000000 nop        
0001B7BC 09000010 b          0x1b7e4
0001B7C0 00000000 nop        
0001B7C4 ff03e42c sltiu      $a0, $a3, 0x3ff
0001B7C8 05008010 beqz       $a0, 0x1b7e0
0001B7CC 00000000 nop        
0001B7D0 0100e224 addiu      $v0, $a3, 1
0001B7D4 20e002ad sw         $v0, -0x1fe0($t0)
0001B7D8 02000010 b          0x1b7e4
0001B7DC ffff4224 addiu      $v0, $v0, -1
0001B7E0 25100000 move       $v0, $zero
0001B7E4 0800e003 jr         $ra
0001B7E8 00000000 nop        
0001B7EC e0ffbd27 addiu      $sp, $sp, -0x20
0001B7F0 0800043c lui        $a0, 8
0001B7F4 25280000 move       $a1, $zero
0001B7F8 00500634 ori        $a2, $zero, 0x5000
0001B7FC 1000bfaf sw         $ra, 0x10($sp)
0001B800 e793000c jal        0x24f9c
0001B804 e0f48424 addiu      $a0, $a0, -0xb20
0001B808 1200043c lui        $a0, 0x12
0001B80C 20e080ac sw         $zero, -0x1fe0($a0)
0001B810 1000bf8f lw         $ra, 0x10($sp)
0001B814 0800e003 jr         $ra
0001B818 2000bd27 addiu      $sp, $sp, 0x20
0001B81C c0ffbd27 addiu      $sp, $sp, -0x40
0001B820 2800b0af sw         $s0, 0x28($sp)
0001B824 2c00b1af sw         $s1, 0x2c($sp)
0001B828 3000bfaf sw         $ra, 0x30($sp)
0001B82C 4492000c jal        0x24910
0001B830 10000434 ori        $a0, $zero, 0x10
0001B834 4d92000c jal        0x24934
0001B838 25204000 move       $a0, $v0
0001B83C 0800043c lui        $a0, 8
0001B840 68f48424 addiu      $a0, $a0, -0xb98
0001B844 2400a4af sw         $a0, 0x24($sp)
0001B848 25280000 move       $a1, $zero
0001B84C e793000c jal        0x24f9c
0001B850 6c000634 ori        $a2, $zero, 0x6c
0001B854 fb6d000c jal        0x1b7ec
0001B858 00000000 nop        
0001B85C edc1000c jal        0x307b4
0001B860 00000000 nop        
0001B864 1200053c lui        $a1, 0x12
0001B868 0400043c lui        $a0, 4
0001B86C 1ce0a58c lw         $a1, -0x1fe4($a1)
0001B870 23204400 subu       $a0, $v0, $a0
0001B874 23208500 subu       $a0, $a0, $a1
0001B878 f3c1000c jal        0x307cc
0001B87C 2000a4af sw         $a0, 0x20($sp)
0001B880 edc1000c jal        0x307b4
0001B884 25804000 move       $s0, $v0
0001B888 2000a48f lw         $a0, 0x20($sp)
0001B88C 2400a58f lw         $a1, 0x24($sp)
0001B890 17000212 beq        $s0, $v0, 0x1b8f0
0001B894 0800063c lui        $a2, 8
0001B898 2400a5af sw         $a1, 0x24($sp)
0001B89C 2000a4af sw         $a0, 0x20($sp)
0001B8A0 1200053c lui        $a1, 0x12
0001B8A4 0300063c lui        $a2, 3
0001B8A8 0300083c lui        $t0, 3
0001B8AC 01000434 ori        $a0, $zero, 1
0001B8B0 b3000734 ori        $a3, $zero, 0xb3
0001B8B4 24e0a524 addiu      $a1, $a1, -0x1fdc
0001B8B8 8026c624 addiu      $a2, $a2, 0x2680
0001B8BC 4771000c jal        0x1c51c
0001B8C0 ac260825 addiu      $t0, $t0, 0x26ac
0001B8C4 0300043c lui        $a0, 3
0001B8C8 f3c1000c jal        0x307cc
0001B8CC b0269024 addiu      $s0, $a0, 0x26b0
0001B8D0 edc1000c jal        0x307b4
0001B8D4 25884000 move       $s1, $v0
0001B8D8 23282202 subu       $a1, $s1, $v0
0001B8DC 5271000c jal        0x1c548
0001B8E0 25200002 move       $a0, $s0
0001B8E4 2000a48f lw         $a0, 0x20($sp)
0001B8E8 2400a58f lw         $a1, 0x24($sp)
0001B8EC 0800063c lui        $a2, 8
0001B8F0 2400a5af sw         $a1, 0x24($sp)
0001B8F4 2000a4af sw         $a0, 0x20($sp)
0001B8F8 25388000 move       $a3, $a0
0001B8FC 0300043c lui        $a0, 3
0001B900 02000534 ori        $a1, $zero, 2
0001B904 25300000 move       $a2, $zero
0001B908 01000834 ori        $t0, $zero, 1
0001B90C 25480000 move       $t1, $zero
0001B910 e3c1000c jal        0x3078c
0001B914 e8268424 addiu      $a0, $a0, 0x26e8
0001B918 2400a58f lw         $a1, 0x24($sp)
0001B91C 25204000 move       $a0, $v0
0001B920 c7c1000c jal        0x3071c
0001B924 1c00a2ac sw         $v0, 0x1c($a1)
0001B928 2000a48f lw         $a0, 0x20($sp)
0001B92C 2400a58f lw         $a1, 0x24($sp)
0001B930 10004010 beqz       $v0, 0x1b974
0001B934 0800063c lui        $a2, 8
0001B938 2400a5af sw         $a1, 0x24($sp)
0001B93C 1200053c lui        $a1, 0x12
0001B940 0300063c lui        $a2, 3
0001B944 0300083c lui        $t0, 3
0001B948 02000434 ori        $a0, $zero, 2
0001B94C bc000734 ori        $a3, $zero, 0xbc
0001B950 24e0a524 addiu      $a1, $a1, -0x1fdc
0001B954 8026c624 addiu      $a2, $a2, 0x2680
0001B958 4771000c jal        0x1c51c
0001B95C ac260825 addiu      $t0, $t0, 0x26ac
0001B960 0300043c lui        $a0, 3
0001B964 5271000c jal        0x1c548
0001B968 f4268424 addiu      $a0, $a0, 0x26f4
0001B96C 05000010 b          0x1b984
0001B970 2400a58f lw         $a1, 0x24($sp)
0001B974 68f4c68c lw         $a2, -0xb98($a2)
0001B978 1000a4ac sw         $a0, 0x10($a1)
0001B97C 0800a6ac sw         $a2, 8($a1)
0001B980 0400a4ac sw         $a0, 4($a1)
0001B984 2000a424 addiu      $a0, $a1, 0x20
0001B988 25280000 move       $a1, $zero
0001B98C e793000c jal        0x24f9c
0001B990 4c000634 ori        $a2, $zero, 0x4c
0001B994 2800b08f lw         $s0, 0x28($sp)
0001B998 2c00b18f lw         $s1, 0x2c($sp)
0001B99C 3000bf8f lw         $ra, 0x30($sp)
0001B9A0 0800e003 jr         $ra
0001B9A4 4000bd27 addiu      $sp, $sp, 0x40
0001B9A8 d0ffbd27 addiu      $sp, $sp, -0x30
0001B9AC 2400b1af sw         $s1, 0x24($sp)
0001B9B0 0800113c lui        $s1, 8
0001B9B4 2000b0af sw         $s0, 0x20($sp)
0001B9B8 68f43026 addiu      $s0, $s1, -0xb98
0001B9BC 1c00048e lw         $a0, 0x1c($s0)
0001B9C0 2800bfaf sw         $ra, 0x28($sp)
0001B9C4 adc1000c jal        0x306b4
0001B9C8 68f4258e lw         $a1, -0xb98($s1)
0001B9CC 25204000 move       $a0, $v0
0001B9D0 20008010 beqz       $a0, 0x1ba54
0001B9D4 0280053c lui        $a1, 0x8002
0001B9D8 b601a824 addiu      $t0, $a1, 0x1b6
0001B9DC 1200073c lui        $a3, 0x12
0001B9E0 0300063c lui        $a2, 3
0001B9E4 0300053c lui        $a1, 3
0001B9E8 39e0e724 addiu      $a3, $a3, -0x1fc7
0001B9EC 8026c624 addiu      $a2, $a2, 0x2680
0001B9F0 1d008810 beq        $a0, $t0, 0x1ba68
0001B9F4 ac26a524 addiu      $a1, $a1, 0x26ac
0001B9F8 0280083c lui        $t0, 0x8002
0001B9FC 9d010825 addiu      $t0, $t0, 0x19d