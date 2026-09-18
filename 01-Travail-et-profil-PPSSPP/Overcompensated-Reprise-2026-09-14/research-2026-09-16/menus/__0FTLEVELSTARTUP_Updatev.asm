00019488 e0febd27 addiu      $sp, $sp, -0x120
0001948C 1200043c lui        $a0, 0x12
00019490 18ff848c lw         $a0, -0xe8($a0)
00019494 1200053c lui        $a1, 0x12
00019498 10faa58c lw         $a1, -0x5f0($a1)
0001949C 0401b0af sw         $s0, 0x104($sp)
000194A0 0801b1af sw         $s1, 0x108($sp)
000194A4 0c01b2af sw         $s2, 0x10c($sp)
000194A8 1001bfaf sw         $ra, 0x110($sp)
000194AC 04008510 beq        $a0, $a1, 0x194c0
000194B0 00000000 nop        
000194B4 01000434 ori        $a0, $zero, 1
000194B8 1200053c lui        $a1, 0x12
000194BC 14ffa4a0 sb         $a0, -0xec($a1)
000194C0 1200043c lui        $a0, 0x12
000194C4 10fa848c lw         $a0, -0x5f0($a0)
000194C8 1200053c lui        $a1, 0x12
000194CC b85e000c jal        0x17ae0
000194D0 18ffa4ac sw         $a0, -0xe8($a1)
000194D4 5f38000c jal        0xe17c
000194D8 ffff0424 addiu      $a0, $zero, -1
000194DC 7610000c jal        0x41d8
000194E0 00000000 nop        
000194E4 f310000c jal        0x43cc
000194E8 01000434 ori        $a0, $zero, 1
000194EC 04004010 beqz       $v0, 0x19500
000194F0 00000000 nop        
000194F4 01000434 ori        $a0, $zero, 1
000194F8 1200053c lui        $a1, 0x12
000194FC 14ffa4a0 sb         $a0, -0xec($a1)
00019500 25200000 move       $a0, $zero
00019504 8611000c jal        0x4618
00019508 25280000 move       $a1, $zero
0001950C 4405000c jal        0x1510
00019510 00000000 nop        
00019514 4037000c jal        0xdd00
00019518 00000000 nop        
0001951C 1200043c lui        $a0, 0x12
00019520 10fa848c lw         $a0, -0x5f0($a0)
00019524 ffff8524 addiu      $a1, $a0, -1
00019528 2200a52c sltiu      $a1, $a1, 0x22
0001952C 5e05a010 beqz       $a1, 0x1aaa8
00019530 ffff8424 addiu      $a0, $a0, -1
00019534 80200400 sll        $a0, $a0, 2
00019538 0300013c lui        $at, 3
0001953C 21082400 addu       $at, $at, $a0
00019540 7020218c lw         $at, 0x2070($at)
00019544 08002000 jr         $at
00019548 00000000 nop        
0001954C 03000434 ori        $a0, $zero, 3
00019550 1200053c lui        $a1, 0x12
00019554 10faa4ac sw         $a0, -0x5f0($a1)
00019558 06000434 ori        $a0, $zero, 6
0001955C 1200053c lui        $a1, 0x12
00019560 14faa4ac sw         $a0, -0x5ec($a1)
00019564 1200053c lui        $a1, 0x12
00019568 18faa4ac sw         $a0, -0x5e8($a1)
0001956C 1200043c lui        $a0, 0x12
00019570 1cfa80ac sw         $zero, -0x5e4($a0)
00019574 0e7b000c jal        0x1ec38
00019578 ffff0424 addiu      $a0, $zero, -1
0001957C ef76000c jal        0x1dbbc
00019580 25200000 move       $a0, $zero
00019584 48050010 b          0x1aaa8
00019588 00000000 nop        
0001958C 46050010 b          0x1aaa8
00019590 00000000 nop        
00019594 1200043c lui        $a0, 0x12
00019598 14fa848c lw         $a0, -0x5ec($a0)
0001959C 1200053c lui        $a1, 0x12
000195A0 41050010 b          0x1aaa8
000195A4 10faa4ac sw         $a0, -0x5f0($a1)
000195A8 20000534 ori        $a1, $zero, 0x20
000195AC 20000634 ori        $a2, $zero, 0x20
000195B0 03000734 ori        $a3, $zero, 3
000195B4 25400000 move       $t0, $zero
000195B8 2337000c jal        0xdc8c
000195BC 00ff043c lui        $a0, 0xff00
000195C0 3037000c jal        0xdcc0
000195C4 00000000 nop        
000195C8 05004010 beqz       $v0, 0x195e0
000195CC 00000000 nop        
000195D0 1200043c lui        $a0, 0x12
000195D4 18fa848c lw         $a0, -0x5e8($a0)
000195D8 1200053c lui        $a1, 0x12
000195DC 10faa4ac sw         $a0, -0x5f0($a1)
000195E0 31050010 b          0x1aaa8
000195E4 00000000 nop        
000195E8 8874000c jal        0x1d220
000195EC b8070434 ori        $a0, $zero, 0x7b8
000195F0 1100043c lui        $a0, 0x11
000195F4 9c6282ac sw         $v0, 0x629c($a0)
000195F8 1100043c lui        $a0, 0x11
000195FC 9026848c lw         $a0, 0x2690($a0)
00019600 dd62000c jal        0x18b74
00019604 3800848c lw         $a0, 0x38($a0)
00019608 25204000 move       $a0, $v0
0001960C 8001000c jal        0x600
00019610 01000534 ori        $a1, $zero, 1
00019614 0402000c jal        0x810
00019618 00000000 nop        
0001961C 05004010 beqz       $v0, 0x19634
00019620 00000000 nop        
00019624 0a000434 ori        $a0, $zero, 0xa
00019628 1200053c lui        $a1, 0x12
0001962C 09000010 b          0x19654
00019630 10faa4ac sw         $a0, -0x5f0($a1)
00019634 03000434 ori        $a0, $zero, 3
00019638 1200053c lui        $a1, 0x12
0001963C 10faa4ac sw         $a0, -0x5f0($a1)
00019640 07000434 ori        $a0, $zero, 7
00019644 1200053c lui        $a1, 0x12
00019648 18faa4ac sw         $a0, -0x5e8($a1)
0001964C 1200043c lui        $a0, 0x12
00019650 1cfa80ac sw         $zero, -0x5e4($a0)
00019654 14050010 b          0x1aaa8
00019658 00000000 nop        
0001965C 1100043c lui        $a0, 0x11
00019660 9026848c lw         $a0, 0x2690($a0)
00019664 e362000c jal        0x18b8c
00019668 3800848c lw         $a0, 0x38($a0)
0001966C 25204000 move       $a0, $v0
00019670 8001000c jal        0x600
00019674 25280000 move       $a1, $zero
00019678 04000434 ori        $a0, $zero, 4
0001967C 1200053c lui        $a1, 0x12
00019680 10faa4ac sw         $a0, -0x5f0($a1)
00019684 08000434 ori        $a0, $zero, 8
00019688 1200053c lui        $a1, 0x12
0001968C 06050010 b          0x1aaa8
00019690 14faa4ac sw         $a0, -0x5ec($a1)
00019694 1100043c lui        $a0, 0x11
00019698 9026848c lw         $a0, 0x2690($a0)
0001969C ee62000c jal        0x18bb8
000196A0 3800848c lw         $a0, 0x38($a0)
000196A4 25204000 move       $a0, $v0
000196A8 8001000c jal        0x600
000196AC 25280000 move       $a1, $zero
000196B0 04000434 ori        $a0, $zero, 4
000196B4 1200053c lui        $a1, 0x12
000196B8 10faa4ac sw         $a0, -0x5f0($a1)
000196BC 1200053c lui        $a1, 0x12
000196C0 c8faa58c lw         $a1, -0x538($a1)
000196C4 01000434 ori        $a0, $zero, 1
000196C8 0700a414 bne        $a1, $a0, 0x196e8
000196CC 00000000 nop        
000196D0 07000434 ori        $a0, $zero, 7
000196D4 1200053c lui        $a1, 0x12
000196D8 14faa4ac sw         $a0, -0x5ec($a1)
000196DC 1200043c lui        $a0, 0x12
000196E0 04000010 b          0x196f4
000196E4 c8fa80ac sw         $zero, -0x538($a0)
000196E8 05000434 ori        $a0, $zero, 5
000196EC 1200053c lui        $a1, 0x12
000196F0 14faa4ac sw         $a0, -0x5ec($a1)
000196F4 ec040010 b          0x1aaa8
000196F8 00000000 nop        
000196FC f310000c jal        0x43cc
00019700 01000434 ori        $a0, $zero, 1
00019704 25804000 move       $s0, $v0
00019708 8874000c jal        0x1d220
0001970C 98070434 ori        $a0, $zero, 0x798
00019710 25884000 move       $s1, $v0
00019714 8874000c jal        0x1d220
00019718 e9000434 ori        $a0, $zero, 0xe9
0001971C 25904000 move       $s2, $v0
00019720 8874000c jal        0x1d220
00019724 eb000434 ori        $a0, $zero, 0xeb
00019728 03000434 ori        $a0, $zero, 3
0001972C 25282002 move       $a1, $s1
00019730 25304002 move       $a2, $s2
00019734 b260000c jal        0x182c8
00019738 25384000 move       $a3, $v0
0001973C c05e000c jal        0x17b00
00019740 25200002 move       $a0, $s0
00019744 6f5f000c jal        0x17dbc
00019748 00000000 nop        
0001974C 25204000 move       $a0, $v0
00019750 02000534 ori        $a1, $zero, 2
00019754 07008514 bne        $a0, $a1, 0x19774
00019758 00000000 nop        
0001975C 3060000c jal        0x180c0
00019760 25200000 move       $a0, $zero
00019764 0a000434 ori        $a0, $zero, 0xa
00019768 1200053c lui        $a1, 0x12
0001976C 61000010 b          0x198f4
00019770 10faa4ac sw         $a0, -0x5f0($a1)
00019774 01000534 ori        $a1, $zero, 1
00019778 5e008514 bne        $a0, $a1, 0x198f4
0001977C 00000000 nop        
00019780 3060000c jal        0x180c0
00019784 25200000 move       $a0, $zero
00019788 1100043c lui        $a0, 0x11
0001978C 9026848c lw         $a0, 0x2690($a0)
00019790 23008010 beqz       $a0, 0x19820
00019794 1100043c lui        $a0, 0x11
00019798 9026848c lw         $a0, 0x2690($a0)
0001979C 08008424 addiu      $a0, $a0, 8
000197A0 0000858c lw         $a1, ($a0)
000197A4 0400868c lw         $a2, 4($a0)
000197A8 0800878c lw         $a3, 8($a0)
000197AC 2000a5af sw         $a1, 0x20($sp)
000197B0 0c00858c lw         $a1, 0xc($a0)
000197B4 2400a6af sw         $a2, 0x24($sp)
000197B8 1000868c lw         $a2, 0x10($a0)
000197BC 2800a7af sw         $a3, 0x28($sp)
000197C0 1400878c lw         $a3, 0x14($a0)
000197C4 1c008cc4 lwc1       $f12, 0x1c($a0)
000197C8 2c00a5af sw         $a1, 0x2c($sp)
000197CC 1800858c lw         $a1, 0x18($a0)
000197D0 00600844 mfc1       $t0, $f12
000197D4 3000a6af sw         $a2, 0x30($sp)
000197D8 20008dc4 lwc1       $f13, 0x20($a0)
000197DC 3400a7af sw         $a3, 0x34($sp)
000197E0 24008ec4 lwc1       $f14, 0x24($a0)
000197E4 00680644 mfc1       $a2, $f13
000197E8 3800a5af sw         $a1, 0x38($sp)
000197EC 28008fc4 lwc1       $f15, 0x28($a0)
000197F0 00700544 mfc1       $a1, $f14
000197F4 3c00a8af sw         $t0, 0x3c($sp)
000197F8 4000a6af sw         $a2, 0x40($sp)
000197FC 2c00878c lw         $a3, 0x2c($a0)
00019800 00780644 mfc1       $a2, $f15
00019804 4400a5af sw         $a1, 0x44($sp)
00019808 3000858c lw         $a1, 0x30($a0)
0001980C 4800a6af sw         $a2, 0x48($sp)
00019810 3400848c lw         $a0, 0x34($a0)
00019814 4c00a7af sw         $a3, 0x4c($sp)
00019818 5000a5af sw         $a1, 0x50($sp)
0001981C 5400a4af sw         $a0, 0x54($sp)
00019820 1100103c lui        $s0, 0x11
00019824 9026048e lw         $a0, 0x2690($s0)
00019828 7d06000c jal        0x19f4
0001982C 01000534 ori        $a1, $zero, 1
00019830 9026048e lw         $a0, 0x2690($s0)
00019834 24008010 beqz       $a0, 0x198c8
00019838 00000000 nop        
0001983C 2000a48f lw         $a0, 0x20($sp)
00019840 1100053c lui        $a1, 0x11
00019844 9026a58c lw         $a1, 0x2690($a1)
00019848 2400a68f lw         $a2, 0x24($sp)
0001984C 0800a524 addiu      $a1, $a1, 8
00019850 2800a78f lw         $a3, 0x28($sp)
00019854 0000a4ac sw         $a0, ($a1)
00019858 2c00a48f lw         $a0, 0x2c($sp)
0001985C 0400a6ac sw         $a2, 4($a1)
00019860 3000a68f lw         $a2, 0x30($sp)
00019864 0800a7ac sw         $a3, 8($a1)
00019868 3400a78f lw         $a3, 0x34($sp)
0001986C 3c00acc7 lwc1       $f12, 0x3c($sp)
00019870 0c00a4ac sw         $a0, 0xc($a1)
00019874 3800a48f lw         $a0, 0x38($sp)
00019878 00600844 mfc1       $t0, $f12
0001987C 1000a6ac sw         $a2, 0x10($a1)
00019880 4000adc7 lwc1       $f13, 0x40($sp)
00019884 1400a7ac sw         $a3, 0x14($a1)
00019888 4400aec7 lwc1       $f14, 0x44($sp)
0001988C 00680644 mfc1       $a2, $f13
00019890 1800a4ac sw         $a0, 0x18($a1)
00019894 4800afc7 lwc1       $f15, 0x48($sp)
00019898 00700444 mfc1       $a0, $f14
0001989C 1c00a8ac sw         $t0, 0x1c($a1)
000198A0 2000a6ac sw         $a2, 0x20($a1)
000198A4 4c00a78f lw         $a3, 0x4c($sp)
000198A8 00780644 mfc1       $a2, $f15
000198AC 2400a4ac sw         $a0, 0x24($a1)
000198B0 5000a48f lw         $a0, 0x50($sp)
000198B4 2800a6ac sw         $a2, 0x28($a1)
000198B8 5400a68f lw         $a2, 0x54($sp)
000198BC 2c00a7ac sw         $a3, 0x2c($a1)
000198C0 3000a4ac sw         $a0, 0x30($a1)
000198C4 3400a6ac sw         $a2, 0x34($a1)
000198C8 1100043c lui        $a0, 0x11
000198CC 9426848c lw         $a0, 0x2694($a0)
000198D0 e806000c jal        0x1ba0
000198D4 01000534 ori        $a1, $zero, 1
000198D8 1100043c lui        $a0, 0x11
000198DC 842680a0 sb         $zero, 0x2684($a0)
000198E0 14000434 ori        $a0, $zero, 0x14
000198E4 ce03000c jal        0xf38
000198E8 01000534 ori        $a1, $zero, 1
000198EC 9b61000c jal        0x1866c
000198F0 01000434 ori        $a0, $zero, 1
000198F4 6c040010 b          0x1aaa8
000198F8 00000000 nop        
000198FC 8874000c jal        0x1d220
00019900 b8070434 ori        $a0, $zero, 0x7b8
00019904 1100043c lui        $a0, 0x11
00019908 9c6282ac sw         $v0, 0x629c($a0)
0001990C 1100043c lui        $a0, 0x11
00019910 9026848c lw         $a0, 0x2690($a0)
00019914 e062000c jal        0x18b80
00019918 3800848c lw         $a0, 0x38($a0)
0001991C 25204000 move       $a0, $v0
00019920 8001000c jal        0x600
00019924 01000534 ori        $a1, $zero, 1
00019928 84030434 ori        $a0, $zero, 0x384
0001992C 1200053c lui        $a1, 0x12
00019930 0402000c jal        0x810
00019934 c4faa4ac sw         $a0, -0x53c($a1)
00019938 05004010 beqz       $v0, 0x19950
0001993C 03000434 ori        $a0, $zero, 3
00019940 0a000434 ori        $a0, $zero, 0xa
00019944 1200053c lui        $a1, 0x12
00019948 0a000010 b          0x19974
0001994C 10faa4ac sw         $a0, -0x5f0($a1)
00019950 1200053c lui        $a1, 0x12
00019954 10faa4ac sw         $a0, -0x5f0($a1)
00019958 06000434 ori        $a0, $zero, 6
0001995C 1200053c lui        $a1, 0x12
00019960 14faa4ac sw         $a0, -0x5ec($a1)
00019964 1200053c lui        $a1, 0x12
00019968 18faa4ac sw         $a0, -0x5e8($a1)
0001996C 1200043c lui        $a0, 0x12
00019970 1cfa80ac sw         $zero, -0x5e4($a0)
00019974 4c040010 b          0x1aaa8
00019978 00000000 nop        
0001997C 1200043c lui        $a0, 0x12
00019980 c4fa848c lw         $a0, -0x53c($a0)
00019984 05008010 beqz       $a0, 0x1999c
00019988 00000000 nop        
0001998C 1200043c lui        $a0, 0x12
00019990 c4fa858c lw         $a1, -0x53c($a0)
00019994 ffffa524 addiu      $a1, $a1, -1
00019998 c4fa85ac sw         $a1, -0x53c($a0)
0001999C 1200043c lui        $a0, 0x12
000199A0 c4fa848c lw         $a0, -0x53c($a0)
000199A4 0c008014 bnez       $a0, 0x199d8
000199A8 04000434 ori        $a0, $zero, 4
000199AC 1200053c lui        $a1, 0x12
000199B0 10faa4ac sw         $a0, -0x5f0($a1)
000199B4 1200053c lui        $a1, 0x12
000199B8 18faa4ac sw         $a0, -0x5e8($a1)
000199BC 0a000434 ori        $a0, $zero, 0xa
000199C0 1200053c lui        $a1, 0x12
000199C4 1cfaa4ac sw         $a0, -0x5e4($a1)
000199C8 06000434 ori        $a0, $zero, 6
000199CC 1200053c lui        $a1, 0x12
000199D0 35040010 b          0x1aaa8
000199D4 14faa4ac sw         $a0, -0x5ec($a1)
000199D8 00001034 ori        $s0, $zero, 0
000199DC 1e77000c jal        0x1dc78
000199E0 25200000 move       $a0, $zero
000199E4 02004010 beqz       $v0, 0x199f0
000199E8 00000000 nop        
000199EC 01001034 ori        $s0, $zero, 1
000199F0 1200053c lui        $a1, 0x12
000199F4 70fea524 addiu      $a1, $a1, -0x190
000199F8 0400a58c lw         $a1, 4($a1)
000199FC 00000434 ori        $a0, $zero, 0
00019A00 2b288500 sltu       $a1, $a0, $a1
00019A04 1400a010 beqz       $a1, 0x19a58
00019A08 00000000 nop        
00019A0C 1200063c lui        $a2, 0x12
00019A10 70fec68c lw         $a2, -0x190($a2)
00019A14 80280400 sll        $a1, $a0, 2
00019A18 2128c500 addu       $a1, $a2, $a1
00019A1C 1200073c lui        $a3, 0x12
00019A20 0000a58c lw         $a1, ($a1)
00019A24 b0fbe624 addiu      $a2, $a3, -0x450
00019A28 0400a614 bne        $a1, $a2, 0x19a3c
00019A2C 00000000 nop        
00019A30 1200053c lui        $a1, 0x12
00019A34 b0fba524 addiu      $a1, $a1, -0x450
00019A38 cc00b0a0 sb         $s0, 0xcc($a1)
00019A3C 1200053c lui        $a1, 0x12
00019A40 70fea524 addiu      $a1, $a1, -0x190
00019A44 0400a58c lw         $a1, 4($a1)
00019A48 01008424 addiu      $a0, $a0, 1
00019A4C 2b288500 sltu       $a1, $a0, $a1
00019A50 eeffa014 bnez       $a1, 0x19a0c
00019A54 00000000 nop        
00019A58 25880002 move       $s1, $s0
00019A5C f310000c jal        0x43cc
00019A60 01000434 ori        $a0, $zero, 1
00019A64 07002016 bnez       $s1, 0x19a84
00019A68 25804000 move       $s0, $v0
00019A6C 725f000c jal        0x17dc8
00019A70 00000000 nop        
00019A74 03004010 beqz       $v0, 0x19a84
00019A78 00000000 nop        
00019A7C 3060000c jal        0x180c0
00019A80 25200000 move       $a0, $zero
00019A84 725f000c jal        0x17dc8
00019A88 00000000 nop        
00019A8C 1c004010 beqz       $v0, 0x19b00
00019A90 00000000 nop        
00019A94 c05e000c jal        0x17b00
00019A98 25200002 move       $a0, $s0
00019A9C 6f5f000c jal        0x17dbc
00019AA0 00000000 nop        
00019AA4 25804000 move       $s0, $v0
00019AA8 0200042a slti       $a0, $s0, 2
00019AAC 0a008010 beqz       $a0, 0x19ad8
00019AB0 0300042a slti       $a0, $s0, 3
00019AB4 0e00001a blez       $s0, 0x19af0
00019AB8 00000000 nop        
00019ABC 1c000434 ori        $a0, $zero, 0x1c
00019AC0 1200053c lui        $a1, 0x12
00019AC4 10faa4ac sw         $a0, -0x5f0($a1)
00019AC8 3060000c jal        0x180c0
00019ACC 25200000 move       $a0, $zero
00019AD0 09000010 b          0x19af8
00019AD4 00000000 nop        
00019AD8 05008010 beqz       $a0, 0x19af0
00019ADC 00000000 nop        
00019AE0 3060000c jal        0x180c0
00019AE4 25200000 move       $a0, $zero
00019AE8 03000010 b          0x19af8
00019AEC 00000000 nop        
00019AF0 f962000c jal        0x18be4
00019AF4 00000000 nop        
00019AF8 f5000010 b          0x19ed0
00019AFC 00000000 nop        
00019B00 00400432 andi       $a0, $s0, 0x4000
00019B04 ee008010 beqz       $a0, 0x19ec0
00019B08 1200043c lui        $a0, 0x12
00019B0C 70fe8524 addiu      $a1, $a0, -0x190
00019B10 70fe848c lw         $a0, -0x190($a0)
00019B14 0800a58c lw         $a1, 8($a1)
00019B18 80280500 sll        $a1, $a1, 2
00019B1C 21208500 addu       $a0, $a0, $a1
00019B20 0000848c lw         $a0, ($a0)
00019B24 cc008490 lbu        $a0, 0xcc($a0)
00019B28 e9008010 beqz       $a0, 0x19ed0
00019B2C 1200043c lui        $a0, 0x12
00019B30 70fe8524 addiu      $a1, $a0, -0x190
00019B34 70fe848c lw         $a0, -0x190($a0)
00019B38 0800a58c lw         $a1, 8($a1)
00019B3C 80280500 sll        $a1, $a1, 2
00019B40 21208500 addu       $a0, $a0, $a1
00019B44 0000848c lw         $a0, ($a0)
00019B48 62000534 ori        $a1, $zero, 0x62
00019B4C d000848c lw         $a0, 0xd0($a0)
00019B50 0b008514 bne        $a0, $a1, 0x19b80
00019B54 1200043c lui        $a0, 0x12
00019B58 18000434 ori        $a0, $zero, 0x18
00019B5C 1200053c lui        $a1, 0x12
00019B60 10faa4ac sw         $a0, -0x5f0($a1)
00019B64 9b61000c jal        0x1866c
00019B68 01000434 ori        $a0, $zero, 1
00019B6C 25200000 move       $a0, $zero
00019B70 7377000c jal        0x1ddcc
00019B74 01000534 ori        $a1, $zero, 1
00019B78 d5000010 b          0x19ed0
00019B7C 00000000 nop        
00019B80 70fe8524 addiu      $a1, $a0, -0x190
00019B84 70fe848c lw         $a0, -0x190($a0)
00019B88 0800a58c lw         $a1, 8($a1)
00019B8C 80280500 sll        $a1, $a1, 2
00019B90 21208500 addu       $a0, $a0, $a1
00019B94 0000848c lw         $a0, ($a0)
00019B98 63000534 ori        $a1, $zero, 0x63
00019B9C d000848c lw         $a0, 0xd0($a0)
00019BA0 0b008514 bne        $a0, $a1, 0x19bd0
00019BA4 1200043c lui        $a0, 0x12
00019BA8 0f000434 ori        $a0, $zero, 0xf
00019BAC 1200053c lui        $a1, 0x12
00019BB0 10faa4ac sw         $a0, -0x5f0($a1)
00019BB4 25200000 move       $a0, $zero
00019BB8 7377000c jal        0x1ddcc
00019BBC 01000534 ori        $a1, $zero, 1
00019BC0 9b61000c jal        0x1866c
00019BC4 01000434 ori        $a0, $zero, 1
00019BC8 c1000010 b          0x19ed0
00019BCC 00000000 nop        
00019BD0 70fe8524 addiu      $a1, $a0, -0x190
00019BD4 70fe848c lw         $a0, -0x190($a0)
00019BD8 0800a58c lw         $a1, 8($a1)
00019BDC 80280500 sll        $a1, $a1, 2
00019BE0 21208500 addu       $a0, $a0, $a1
00019BE4 0000848c lw         $a0, ($a0)
00019BE8 50000534 ori        $a1, $zero, 0x50
00019BEC d000848c lw         $a0, 0xd0($a0)
00019BF0 0b008514 bne        $a0, $a1, 0x19c20
00019BF4 1200043c lui        $a0, 0x12
00019BF8 03000434 ori        $a0, $zero, 3
00019BFC 1200053c lui        $a1, 0x12
00019C00 10faa4ac sw         $a0, -0x5f0($a1)
00019C04 02000434 ori        $a0, $zero, 2
00019C08 1200053c lui        $a1, 0x12
00019C0C 18faa4ac sw         $a0, -0x5e8($a1)
00019C10 0a000434 ori        $a0, $zero, 0xa
00019C14 1200053c lui        $a1, 0x12
00019C18 ad000010 b          0x19ed0
00019C1C 1cfaa4ac sw         $a0, -0x5e4($a1)
00019C20 70fe8524 addiu      $a1, $a0, -0x190
00019C24 70fe848c lw         $a0, -0x190($a0)
00019C28 0800a58c lw         $a1, 8($a1)
00019C2C 80280500 sll        $a1, $a1, 2
00019C30 21208500 addu       $a0, $a0, $a1
00019C34 0000848c lw         $a0, ($a0)
00019C38 4f000534 ori        $a1, $zero, 0x4f
00019C3C d000848c lw         $a0, 0xd0($a0)
00019C40 08008514 bne        $a0, $a1, 0x19c64
00019C44 1200043c lui        $a0, 0x12
00019C48 0f000434 ori        $a0, $zero, 0xf
00019C4C b003000c jal        0xec0
00019C50 25280000 move       $a1, $zero
00019C54 9b61000c jal        0x1866c
00019C58 01000434 ori        $a0, $zero, 1
00019C5C 9c000010 b          0x19ed0
00019C60 00000000 nop        
00019C64 70fe8524 addiu      $a1, $a0, -0x190
00019C68 70fe848c lw         $a0, -0x190($a0)
00019C6C 0800a58c lw         $a1, 8($a1)
00019C70 80280500 sll        $a1, $a1, 2
00019C74 21208500 addu       $a0, $a0, $a1
00019C78 0000848c lw         $a0, ($a0)
00019C7C 5e000534 ori        $a1, $zero, 0x5e
00019C80 d000848c lw         $a0, 0xd0($a0)
00019C84 7d008514 bne        $a0, $a1, 0x19e7c
00019C88 00000000 nop        
00019C8C 01000434 ori        $a0, $zero, 1
00019C90 7377000c jal        0x1ddcc
00019C94 01000534 ori        $a1, $zero, 1
00019C98 5800a0af sw         $zero, 0x58($sp)
00019C9C 5800a527 addiu      $a1, $sp, 0x58
00019CA0 f7bf000c jal        0x2ffdc
00019CA4 03000434 ori        $a0, $zero, 3
00019CA8 5800a48f lw         $a0, 0x58($sp)
00019CAC 01000534 ori        $a1, $zero, 1
00019CB0 15008514 bne        $a0, $a1, 0x19d08
00019CB4 00000000 nop        
00019CB8 8874000c jal        0x1d220
00019CBC 98070434 ori        $a0, $zero, 0x798
00019CC0 25804000 move       $s0, $v0
00019CC4 8874000c jal        0x1d220
00019CC8 e9000434 ori        $a0, $zero, 0xe9
00019CCC 25884000 move       $s1, $v0
00019CD0 8874000c jal        0x1d220
00019CD4 eb000434 ori        $a0, $zero, 0xeb
00019CD8 03000434 ori        $a0, $zero, 3
00019CDC 25280002 move       $a1, $s0
00019CE0 25302002 move       $a2, $s1
00019CE4 b260000c jal        0x182c8
00019CE8 25384000 move       $a3, $v0
00019CEC 09000434 ori        $a0, $zero, 9
00019CF0 1200053c lui        $a1, 0x12
00019CF4 10faa4ac sw         $a0, -0x5f0($a1)
00019CF8 9b61000c jal        0x1866c
00019CFC 25200000 move       $a0, $zero
00019D00 5c000010 b          0x19e74
00019D04 00000000 nop        
00019D08 1100043c lui        $a0, 0x11
00019D0C 9026848c lw         $a0, 0x2690($a0)
00019D10 23008010 beqz       $a0, 0x19da0
00019D14 1100043c lui        $a0, 0x11
00019D18 9026848c lw         $a0, 0x2690($a0)
00019D1C 08008424 addiu      $a0, $a0, 8
00019D20 0000858c lw         $a1, ($a0)
00019D24 0400868c lw         $a2, 4($a0)
00019D28 0800878c lw         $a3, 8($a0)
00019D2C 5c00a5af sw         $a1, 0x5c($sp)
00019D30 0c00858c lw         $a1, 0xc($a0)
00019D34 6000a6af sw         $a2, 0x60($sp)
00019D38 1000868c lw         $a2, 0x10($a0)
00019D3C 6400a7af sw         $a3, 0x64($sp)
00019D40 1400878c lw         $a3, 0x14($a0)
00019D44 1c008cc4 lwc1       $f12, 0x1c($a0)
00019D48 6800a5af sw         $a1, 0x68($sp)
00019D4C 1800858c lw         $a1, 0x18($a0)
00019D50 00600844 mfc1       $t0, $f12
00019D54 6c00a6af sw         $a2, 0x6c($sp)
00019D58 20008dc4 lwc1       $f13, 0x20($a0)
00019D5C 7000a7af sw         $a3, 0x70($sp)
00019D60 24008ec4 lwc1       $f14, 0x24($a0)
00019D64 00680644 mfc1       $a2, $f13
00019D68 7400a5af sw         $a1, 0x74($sp)
00019D6C 28008fc4 lwc1       $f15, 0x28($a0)
00019D70 00700544 mfc1       $a1, $f14
00019D74 7800a8af sw         $t0, 0x78($sp)
00019D78 7c00a6af sw         $a2, 0x7c($sp)
00019D7C 2c00878c lw         $a3, 0x2c($a0)
00019D80 00780644 mfc1       $a2, $f15
00019D84 8000a5af sw         $a1, 0x80($sp)
00019D88 3000858c lw         $a1, 0x30($a0)
00019D8C 8400a6af sw         $a2, 0x84($sp)
00019D90 3400848c lw         $a0, 0x34($a0)
00019D94 8800a7af sw         $a3, 0x88($sp)
00019D98 8c00a5af sw         $a1, 0x8c($sp)
00019D9C 9000a4af sw         $a0, 0x90($sp)
00019DA0 1100103c lui        $s0, 0x11
00019DA4 9026048e lw         $a0, 0x2690($s0)
00019DA8 7d06000c jal        0x19f4
00019DAC 01000534 ori        $a1, $zero, 1
00019DB0 9026048e lw         $a0, 0x2690($s0)
00019DB4 24008010 beqz       $a0, 0x19e48
00019DB8 00000000 nop        
00019DBC 5c00a48f lw         $a0, 0x5c($sp)
00019DC0 1100053c lui        $a1, 0x11
00019DC4 9026a58c lw         $a1, 0x2690($a1)
00019DC8 6000a68f lw         $a2, 0x60($sp)
00019DCC 0800a524 addiu      $a1, $a1, 8
00019DD0 6400a78f lw         $a3, 0x64($sp)
00019DD4 0000a4ac sw         $a0, ($a1)
00019DD8 6800a48f lw         $a0, 0x68($sp)
00019DDC 0400a6ac sw         $a2, 4($a1)
00019DE0 6c00a68f lw         $a2, 0x6c($sp)
00019DE4 0800a7ac sw         $a3, 8($a1)
00019DE8 7000a78f lw         $a3, 0x70($sp)
00019DEC 7800acc7 lwc1       $f12, 0x78($sp)
00019DF0 0c00a4ac sw         $a0, 0xc($a1)
00019DF4 7400a48f lw         $a0, 0x74($sp)
00019DF8 00600844 mfc1       $t0, $f12
00019DFC 1000a6ac sw         $a2, 0x10($a1)
00019E00 7c00adc7 lwc1       $f13, 0x7c($sp)
00019E04 1400a7ac sw         $a3, 0x14($a1)
00019E08 8000aec7 lwc1       $f14, 0x80($sp)
00019E0C 00680644 mfc1       $a2, $f13
00019E10 1800a4ac sw         $a0, 0x18($a1)
00019E14 8400afc7 lwc1       $f15, 0x84($sp)
00019E18 00700444 mfc1       $a0, $f14
00019E1C 1c00a8ac sw         $t0, 0x1c($a1)
00019E20 2000a6ac sw         $a2, 0x20($a1)
00019E24 8800a78f lw         $a3, 0x88($sp)
00019E28 00780644 mfc1       $a2, $f15
00019E2C 2400a4ac sw         $a0, 0x24($a1)
00019E30 8c00a48f lw         $a0, 0x8c($sp)
00019E34 2800a6ac sw         $a2, 0x28($a1)
00019E38 9000a68f lw         $a2, 0x90($sp)
00019E3C 2c00a7ac sw         $a3, 0x2c($a1)
00019E40 3000a4ac sw         $a0, 0x30($a1)
00019E44 3400a6ac sw         $a2, 0x34($a1)
00019E48 1100043c lui        $a0, 0x11
00019E4C 9426848c lw         $a0, 0x2694($a0)
00019E50 e806000c jal        0x1ba0
00019E54 01000534 ori        $a1, $zero, 1
00019E58 1100043c lui        $a0, 0x11
00019E5C 842680a0 sb         $zero, 0x2684($a0)
00019E60 14000434 ori        $a0, $zero, 0x14
00019E64 ce03000c jal        0xf38
00019E68 01000534 ori        $a1, $zero, 1
00019E6C 9b61000c jal        0x1866c
00019E70 01000434 ori        $a0, $zero, 1
00019E74 16000010 b          0x19ed0
00019E78 00000000 nop        
00019E7C 1100043c lui        $a0, 0x11
00019E80 e776000c jal        0x1db9c
00019E84 842680a0 sb         $zero, 0x2684($a0)
00019E88 1200043c lui        $a0, 0x12
00019E8C 70fe8524 addiu      $a1, $a0, -0x190
00019E90 70fe848c lw         $a0, -0x190($a0)
00019E94 0800a58c lw         $a1, 8($a1)
00019E98 80280500 sll        $a1, $a1, 2
00019E9C 21208500 addu       $a0, $a0, $a1
00019EA0 0000848c lw         $a0, ($a0)
00019EA4 01000534 ori        $a1, $zero, 1
00019EA8 ce03000c jal        0xf38
00019EAC d000848c lw         $a0, 0xd0($a0)
00019EB0 9b61000c jal        0x1866c
00019EB4 01000434 ori        $a0, $zero, 1
00019EB8 05000010 b          0x19ed0
00019EBC 00000000 nop        
00019EC0 1200043c lui        $a0, 0x12
00019EC4 25280002 move       $a1, $s0
00019EC8 cc57000c jal        0x15f30
00019ECC 70fe8424 addiu      $a0, $a0, -0x190
00019ED0 1200043c lui        $a0, 0x12
00019ED4 20fa8490 lbu        $a0, -0x5e0($a0)
00019ED8 05008010 beqz       $a0, 0x19ef0
00019EDC 00000000 nop        
00019EE0 1b0c000c jal        0x306c
00019EE4 00000000 nop        
00019EE8 1200043c lui        $a0, 0x12
00019EEC 20fa80a0 sb         $zero, -0x5e0($a0)
00019EF0 ed020010 b          0x1aaa8
00019EF4 00000000 nop        
00019EF8 1e77000c jal        0x1dc78
00019EFC 25200000 move       $a0, $zero
00019F00 05004014 bnez       $v0, 0x19f18
00019F04 00000000 nop        
00019F08 13000434 ori        $a0, $zero, 0x13
00019F0C 1200053c lui        $a1, 0x12
00019F10 0c000010 b          0x19f44
00019F14 10faa4ac sw         $a0, -0x5f0($a1)
00019F18 6c76000c jal        0x1d9b0
00019F1C 01000434 ori        $a0, $zero, 1
00019F20 08004014 bnez       $v0, 0x19f44
00019F24 00000000 nop        
00019F28 1100043c lui        $a0, 0x11
00019F2C 9026848c lw         $a0, 0x2690($a0)
00019F30 0079000c jal        0x1e400
00019F34 3800848c lw         $a0, 0x38($a0)
00019F38 10000434 ori        $a0, $zero, 0x10
00019F3C 1200053c lui        $a1, 0x12
00019F40 10faa4ac sw         $a0, -0x5f0($a1)
00019F44 d8020010 b          0x1aaa8
00019F48 00000000 nop        
00019F4C f310000c jal        0x43cc
00019F50 01000434 ori        $a0, $zero, 1
00019F54 3479000c jal        0x1e4d0
00019F58 25804000 move       $s0, $v0
00019F5C 0400053c lui        $a1, 4
00019F60 25884000 move       $s1, $v0
00019F64 bb070434 ori        $a0, $zero, 0x7bb
00019F68 8874000c jal        0x1d220
00019F6C 5841b224 addiu      $s2, $a1, 0x4158
00019F70 25204002 move       $a0, $s2
00019F74 25284000 move       $a1, $v0
00019F78 c990000c jal        0x24324
00019F7C 25302002 move       $a2, $s1
00019F80 8874000c jal        0x1d220
00019F84 eb000434 ori        $a0, $zero, 0xeb
00019F88 02000434 ori        $a0, $zero, 2
00019F8C 25284002 move       $a1, $s2
00019F90 25304000 move       $a2, $v0
00019F94 b260000c jal        0x182c8
00019F98 25380000 move       $a3, $zero
00019F9C c05e000c jal        0x17b00
00019FA0 25200002 move       $a0, $s0
00019FA4 6f5f000c jal        0x17dbc
00019FA8 00000000 nop        
00019FAC 02000434 ori        $a0, $zero, 2
00019FB0 07004414 bne        $v0, $a0, 0x19fd0
00019FB4 00000000 nop        
00019FB8 3060000c jal        0x180c0
00019FBC 25200000 move       $a0, $zero
00019FC0 19000434 ori        $a0, $zero, 0x19
00019FC4 1200053c lui        $a1, 0x12
00019FC8 08000010 b          0x19fec
00019FCC 10faa4ac sw         $a0, -0x5f0($a1)
00019FD0 1e77000c jal        0x1dc78
00019FD4 25200000 move       $a0, $zero
00019FD8 04004010 beqz       $v0, 0x19fec
00019FDC 00000000 nop        
00019FE0 0f000434 ori        $a0, $zero, 0xf
00019FE4 1200053c lui        $a1, 0x12
00019FE8 10faa4ac sw         $a0, -0x5f0($a1)
00019FEC ae020010 b          0x1aaa8
00019FF0 00000000 nop        
00019FF4 6c76000c jal        0x1d9b0
00019FF8 01000434 ori        $a0, $zero, 1
00019FFC 25004014 bnez       $v0, 0x1a094
0001A000 00000000 nop        
0001A004 ae76000c jal        0x1dab8
0001A008 00000000 nop        
0001A00C 05004010 beqz       $v0, 0x1a024
0001A010 00000000 nop        
0001A014 0a000434 ori        $a0, $zero, 0xa
0001A018 1200053c lui        $a1, 0x12
0001A01C 1d000010 b          0x1a094
0001A020 10faa4ac sw         $a0, -0x5f0($a1)
0001A024 b476000c jal        0x1dad0
0001A028 00000000 nop        
0001A02C 25204000 move       $a0, $v0
0001A030 0f00805c bgtzl      $a0, 0x1a070
0001A034 02008428 slti       $a0, $a0, 2
0001A038 13008004 bltz       $a0, 0x1a088
0001A03C 00000000 nop        
0001A040 1100043c lui        $a0, 0x11
0001A044 e776000c jal        0x1db9c
0001A048 842680a0 sb         $zero, 0x2684($a0)
0001A04C 6a07000c jal        0x1da8
0001A050 00000000 nop        
0001A054 25204000 move       $a0, $v0
0001A058 ce03000c jal        0xf38
0001A05C 01000534 ori        $a1, $zero, 1
0001A060 11000434 ori        $a0, $zero, 0x11
0001A064 1200053c lui        $a1, 0x12
0001A068 0a000010 b          0x1a094
0001A06C 10faa4ac sw         $a0, -0x5f0($a1)
0001A070 05008010 beqz       $a0, 0x1a088
0001A074 00000000 nop        
0001A078 0a000434 ori        $a0, $zero, 0xa
0001A07C 1200053c lui        $a1, 0x12
0001A080 04000010 b          0x1a094
0001A084 10faa4ac sw         $a0, -0x5f0($a1)
0001A088 0a000434 ori        $a0, $zero, 0xa
0001A08C 1200053c lui        $a1, 0x12
0001A090 10faa4ac sw         $a0, -0x5f0($a1)
0001A094 84020010 b          0x1aaa8
0001A098 00000000 nop        
0001A09C 82020010 b          0x1aaa8
0001A0A0 00000000 nop        
0001A0A4 0a000434 ori        $a0, $zero, 0xa
0001A0A8 1200053c lui        $a1, 0x12
0001A0AC 7e020010 b          0x1aaa8
0001A0B0 10faa4ac sw         $a0, -0x5f0($a1)
0001A0B4 20000534 ori        $a1, $zero, 0x20
0001A0B8 20000634 ori        $a2, $zero, 0x20
0001A0BC 03000734 ori        $a3, $zero, 3
0001A0C0 25400000 move       $t0, $zero
0001A0C4 2337000c jal        0xdc8c
0001A0C8 0080043c lui        $a0, 0x8000
0001A0CC 1100103c lui        $s0, 0x11
0001A0D0 9026048e lw         $a0, 0x2690($s0)
0001A0D4 25280000 move       $a1, $zero
0001A0D8 3800848c lw         $a0, 0x38($a0)
0001A0DC 25300000 move       $a2, $zero
0001A0E0 607b000c jal        0x1ed80
0001A0E4 25380000 move       $a3, $zero
0001A0E8 1b000434 ori        $a0, $zero, 0x1b
0001A0EC 1200053c lui        $a1, 0x12
0001A0F0 10faa4ac sw         $a0, -0x5f0($a1)
0001A0F4 9026048e lw         $a0, 0x2690($s0)
0001A0F8 08008010 beqz       $a0, 0x1a11c
0001A0FC 00000000 nop        
0001A100 1100043c lui        $a0, 0x11
0001A104 9026848c lw         $a0, 0x2690($a0)
0001A108 0300053c lui        $a1, 3
0001A10C 20000634 ori        $a2, $zero, 0x20
0001A110 40008424 addiu      $a0, $a0, 0x40
0001A114 9c93000c jal        0x24e70
0001A118 e41fa524 addiu      $a1, $a1, 0x1fe4
0001A11C 62020010 b          0x1aaa8
0001A120 00000000 nop        
0001A124 1200043c lui        $a0, 0x12
0001A128 20fa8490 lbu        $a0, -0x5e0($a0)
0001A12C 06008014 bnez       $a0, 0x1a148
0001A130 00000000 nop        
0001A134 fd0b000c jal        0x2ff4
0001A138 00000000 nop        
0001A13C 01000434 ori        $a0, $zero, 1
0001A140 1200053c lui        $a1, 0x12
0001A144 20faa4a0 sb         $a0, -0x5e0($a1)
0001A148 6c76000c jal        0x1d9b0
0001A14C 01000434 ori        $a0, $zero, 1
0001A150 1e004014 bnez       $v0, 0x1a1cc
0001A154 00000000 nop        
0001A158 1e77000c jal        0x1dc78
0001A15C 25200000 move       $a0, $zero
0001A160 05004014 bnez       $v0, 0x1a178
0001A164 00000000 nop        
0001A168 1f000434 ori        $a0, $zero, 0x1f
0001A16C 1200053c lui        $a1, 0x12
0001A170 16000010 b          0x1a1cc
0001A174 10faa4ac sw         $a0, -0x5f0($a1)
0001A178 4279000c jal        0x1e508
0001A17C 00000000 nop        
0001A180 05004014 bnez       $v0, 0x1a198
0001A184 00000000 nop        
0001A188 1e000434 ori        $a0, $zero, 0x1e
0001A18C 1200053c lui        $a1, 0x12
0001A190 0e000010 b          0x1a1cc
0001A194 10faa4ac sw         $a0, -0x5f0($a1)
0001A198 20000534 ori        $a1, $zero, 0x20
0001A19C 20000634 ori        $a2, $zero, 0x20
0001A1A0 03000734 ori        $a3, $zero, 3
0001A1A4 25400000 move       $t0, $zero
0001A1A8 2337000c jal        0xdc8c
0001A1AC 0080043c lui        $a0, 0x8000
0001A1B0 3037000c jal        0xdcc0
0001A1B4 00000000 nop        
0001A1B8 04004010 beqz       $v0, 0x1a1cc
0001A1BC 00000000 nop        
0001A1C0 14000434 ori        $a0, $zero, 0x14
0001A1C4 1200053c lui        $a1, 0x12
0001A1C8 10faa4ac sw         $a0, -0x5f0($a1)
0001A1CC 36020010 b          0x1aaa8
0001A1D0 00000000 nop        
0001A1D4 f310000c jal        0x43cc
0001A1D8 01000434 ori        $a0, $zero, 1
0001A1DC 2b79000c jal        0x1e4ac
0001A1E0 25804000 move       $s0, $v0
0001A1E4 0400053c lui        $a1, 4
0001A1E8 25884000 move       $s1, $v0
0001A1EC bc070434 ori        $a0, $zero, 0x7bc
0001A1F0 8874000c jal        0x1d220
0001A1F4 5841b224 addiu      $s2, $a1, 0x4158
0001A1F8 25204002 move       $a0, $s2
0001A1FC 25284000 move       $a1, $v0
0001A200 c990000c jal        0x24324
0001A204 25302002 move       $a2, $s1
0001A208 8874000c jal        0x1d220
0001A20C ea000434 ori        $a0, $zero, 0xea
0001A210 25884000 move       $s1, $v0
0001A214 8874000c jal        0x1d220
0001A218 eb000434 ori        $a0, $zero, 0xeb
0001A21C 03000434 ori        $a0, $zero, 3
0001A220 25284002 move       $a1, $s2
0001A224 25302002 move       $a2, $s1
0001A228 b260000c jal        0x182c8
0001A22C 25384000 move       $a3, $v0
0001A230 c05e000c jal        0x17b00
0001A234 25200002 move       $a0, $s0
0001A238 6f5f000c jal        0x17dbc
0001A23C 00000000 nop        
0001A240 25204000 move       $a0, $v0
0001A244 01000534 ori        $a1, $zero, 1
0001A248 07008514 bne        $a0, $a1, 0x1a268
0001A24C 00000000 nop        
0001A250 3060000c jal        0x180c0
0001A254 25200000 move       $a0, $zero
0001A258 19000434 ori        $a0, $zero, 0x19
0001A25C 1200053c lui        $a1, 0x12
0001A260 09000010 b          0x1a288
0001A264 10faa4ac sw         $a0, -0x5f0($a1)
0001A268 02000534 ori        $a1, $zero, 2
0001A26C 06008514 bne        $a0, $a1, 0x1a288
0001A270 00000000 nop        
0001A274 3060000c jal        0x180c0
0001A278 25200000 move       $a0, $zero
0001A27C 0a000434 ori        $a0, $zero, 0xa
0001A280 1200053c lui        $a1, 0x12
0001A284 10faa4ac sw         $a0, -0x5f0($a1)
0001A288 07020010 b          0x1aaa8
0001A28C 00000000 nop        
0001A290 1e77000c jal        0x1dc78
0001A294 25200000 move       $a0, $zero
0001A298 07004014 bnez       $v0, 0x1a2b8
0001A29C 00000000 nop        
0001A2A0 3060000c jal        0x180c0
0001A2A4 25200000 move       $a0, $zero
0001A2A8 1f000434 ori        $a0, $zero, 0x1f
0001A2AC 1200053c lui        $a1, 0x12
0001A2B0 2e000010 b          0x1a36c
0001A2B4 10faa4ac sw         $a0, -0x5f0($a1)
0001A2B8 f310000c jal        0x43cc
0001A2BC 01000434 ori        $a0, $zero, 1
0001A2C0 2b79000c jal        0x1e4ac
0001A2C4 25804000 move       $s0, $v0
0001A2C8 0400053c lui        $a1, 4
0001A2CC 25884000 move       $s1, $v0
0001A2D0 be070434 ori        $a0, $zero, 0x7be
0001A2D4 8874000c jal        0x1d220
0001A2D8 5841b224 addiu      $s2, $a1, 0x4158
0001A2DC 25204002 move       $a0, $s2
0001A2E0 25284000 move       $a1, $v0
0001A2E4 c990000c jal        0x24324
0001A2E8 25302002 move       $a2, $s1
0001A2EC 8874000c jal        0x1d220
0001A2F0 ea000434 ori        $a0, $zero, 0xea
0001A2F4 25884000 move       $s1, $v0
0001A2F8 8874000c jal        0x1d220
0001A2FC bd070434 ori        $a0, $zero, 0x7bd
0001A300 03000434 ori        $a0, $zero, 3
0001A304 25284002 move       $a1, $s2
0001A308 25302002 move       $a2, $s1
0001A30C b260000c jal        0x182c8
0001A310 25384000 move       $a3, $v0
0001A314 c05e000c jal        0x17b00
0001A318 25200002 move       $a0, $s0
0001A31C 6f5f000c jal        0x17dbc
0001A320 00000000 nop        
0001A324 25204000 move       $a0, $v0
0001A328 01000534 ori        $a1, $zero, 1
0001A32C 07008514 bne        $a0, $a1, 0x1a34c
0001A330 00000000 nop        
0001A334 3060000c jal        0x180c0
0001A338 25200000 move       $a0, $zero
0001A33C 18000434 ori        $a0, $zero, 0x18
0001A340 1200053c lui        $a1, 0x12
0001A344 09000010 b          0x1a36c
0001A348 10faa4ac sw         $a0, -0x5f0($a1)
0001A34C 02000534 ori        $a1, $zero, 2
0001A350 06008514 bne        $a0, $a1, 0x1a36c
0001A354 00000000 nop        
0001A358 3060000c jal        0x180c0
0001A35C 25200000 move       $a0, $zero
0001A360 20000434 ori        $a0, $zero, 0x20
0001A364 1200053c lui        $a1, 0x12
0001A368 10faa4ac sw         $a0, -0x5f0($a1)
0001A36C ce010010 b          0x1aaa8
0001A370 00000000 nop        
0001A374 1e77000c jal        0x1dc78
0001A378 25200000 move       $a0, $zero
0001A37C 07004010 beqz       $v0, 0x1a39c
0001A380 00000000 nop        
0001A384 3060000c jal        0x180c0
0001A388 25200000 move       $a0, $zero
0001A38C 21000434 ori        $a0, $zero, 0x21
0001A390 1200053c lui        $a1, 0x12
0001A394 2e000010 b          0x1a450
0001A398 10faa4ac sw         $a0, -0x5f0($a1)
0001A39C f310000c jal        0x43cc
0001A3A0 01000434 ori        $a0, $zero, 1
0001A3A4 3479000c jal        0x1e4d0
0001A3A8 25804000 move       $s0, $v0
0001A3AC 0400053c lui        $a1, 4
0001A3B0 25884000 move       $s1, $v0
0001A3B4 ba070434 ori        $a0, $zero, 0x7ba
0001A3B8 8874000c jal        0x1d220
0001A3BC 5841b224 addiu      $s2, $a1, 0x4158
0001A3C0 25204002 move       $a0, $s2
0001A3C4 25284000 move       $a1, $v0
0001A3C8 c990000c jal        0x24324
0001A3CC 25302002 move       $a2, $s1
0001A3D0 8874000c jal        0x1d220
0001A3D4 ea000434 ori        $a0, $zero, 0xea
0001A3D8 25884000 move       $s1, $v0
0001A3DC 8874000c jal        0x1d220
0001A3E0 eb000434 ori        $a0, $zero, 0xeb
0001A3E4 03000434 ori        $a0, $zero, 3
0001A3E8 25284002 move       $a1, $s2
0001A3EC 25302002 move       $a2, $s1
0001A3F0 b260000c jal        0x182c8
0001A3F4 25384000 move       $a3, $v0
0001A3F8 c05e000c jal        0x17b00
0001A3FC 25200002 move       $a0, $s0
0001A400 6f5f000c jal        0x17dbc
0001A404 00000000 nop        
0001A408 25204000 move       $a0, $v0
0001A40C 01000534 ori        $a1, $zero, 1
0001A410 07008514 bne        $a0, $a1, 0x1a430
0001A414 00000000 nop        
0001A418 3060000c jal        0x180c0
0001A41C 25200000 move       $a0, $zero
0001A420 19000434 ori        $a0, $zero, 0x19
0001A424 1200053c lui        $a1, 0x12
0001A428 09000010 b          0x1a450
0001A42C 10faa4ac sw         $a0, -0x5f0($a1)
0001A430 02000534 ori        $a1, $zero, 2
0001A434 06008514 bne        $a0, $a1, 0x1a450
0001A438 00000000 nop        
0001A43C 3060000c jal        0x180c0
0001A440 25200000 move       $a0, $zero
0001A444 0a000434 ori        $a0, $zero, 0xa
0001A448 1200053c lui        $a1, 0x12
0001A44C 10faa4ac sw         $a0, -0x5f0($a1)
0001A450 95010010 b          0x1aaa8
0001A454 00000000 nop        
0001A458 20000534 ori        $a1, $zero, 0x20
0001A45C 20000634 ori        $a2, $zero, 0x20
0001A460 03000734 ori        $a3, $zero, 3
0001A464 25400000 move       $t0, $zero
0001A468 2337000c jal        0xdc8c
0001A46C 0080043c lui        $a0, 0x8000
0001A470 017c000c jal        0x1f004
0001A474 00000000 nop        
0001A478 687c000c jal        0x1f1a0
0001A47C 00000000 nop        
0001A480 07004010 beqz       $v0, 0x1a4a0
0001A484 00000000 nop        
0001A488 657c000c jal        0x1f194
0001A48C 00000000 nop        
0001A490 1c000434 ori        $a0, $zero, 0x1c
0001A494 1200053c lui        $a1, 0x12
0001A498 28000010 b          0x1a53c
0001A49C 10faa4ac sw         $a0, -0x5f0($a1)
0001A4A0 fd7b000c jal        0x1eff4
0001A4A4 00000000 nop        
0001A4A8 24004010 beqz       $v0, 0x1a53c
0001A4AC 00000000 nop        
0001A4B0 517b000c jal        0x1ed44
0001A4B4 00000000 nop        
0001A4B8 25804000 move       $s0, $v0
0001A4BC 1c000012 beqz       $s0, 0x1a530
0001A4C0 00000000 nop        
0001A4C4 1100113c lui        $s1, 0x11
0001A4C8 9026248e lw         $a0, 0x2690($s1)
0001A4CC 25280000 move       $a1, $zero
0001A4D0 40008424 addiu      $a0, $a0, 0x40
0001A4D4 0693000c jal        0x24c18
0001A4D8 20000634 ori        $a2, $zero, 0x20
0001A4DC 9026258e lw         $a1, 0x2690($s1)
0001A4E0 25200002 move       $a0, $s0
0001A4E4 4000a524 addiu      $a1, $a1, 0x40
0001A4E8 20000634 ori        $a2, $zero, 0x20
0001A4EC 2256000c jal        0x15888
0001A4F0 20000734 ori        $a3, $zero, 0x20
0001A4F4 00000434 ori        $a0, $zero, 0
0001A4F8 2000852c sltiu      $a1, $a0, 0x20
0001A4FC 0c00a010 beqz       $a1, 0x1a530
0001A500 00000000 nop        
0001A504 21288400 addu       $a1, $a0, $a0
0001A508 1100063c lui        $a2, 0x11
0001A50C 21280502 addu       $a1, $s0, $a1
0001A510 9026c68c lw         $a2, 0x2690($a2)
0001A514 0000a580 lb         $a1, ($a1)
0001A518 2130c400 addu       $a2, $a2, $a0
0001A51C 4000c5a0 sb         $a1, 0x40($a2)
0001A520 01008424 addiu      $a0, $a0, 1
0001A524 2000852c sltiu      $a1, $a0, 0x20
0001A528 f6ffa014 bnez       $a1, 0x1a504
0001A52C 00000000 nop        
0001A530 1c000434 ori        $a0, $zero, 0x1c
0001A534 1200053c lui        $a1, 0x12
0001A538 10faa4ac sw         $a0, -0x5f0($a1)
0001A53C 5a010010 b          0x1aaa8
0001A540 00000000 nop        
0001A544 3837000c jal        0xdce0
0001A548 00000000 nop        
0001A54C 04004010 beqz       $v0, 0x1a560
0001A550 00000000 nop        
0001A554 14000434 ori        $a0, $zero, 0x14
0001A558 1200053c lui        $a1, 0x12
0001A55C 10faa4ac sw         $a0, -0x5f0($a1)
0001A560 51010010 b          0x1aaa8
0001A564 00000000 nop        
0001A568 1100043c lui        $a0, 0x11
0001A56C 9026848c lw         $a0, 0x2690($a0)
0001A570 23008010 beqz       $a0, 0x1a600
0001A574 1100043c lui        $a0, 0x11
0001A578 9026848c lw         $a0, 0x2690($a0)
0001A57C 08008424 addiu      $a0, $a0, 8
0001A580 0000858c lw         $a1, ($a0)
0001A584 0400868c lw         $a2, 4($a0)
0001A588 0800878c lw         $a3, 8($a0)
0001A58C 9400a5af sw         $a1, 0x94($sp)
0001A590 0c00858c lw         $a1, 0xc($a0)
0001A594 9800a6af sw         $a2, 0x98($sp)
0001A598 1000868c lw         $a2, 0x10($a0)
0001A59C 9c00a7af sw         $a3, 0x9c($sp)
0001A5A0 1400878c lw         $a3, 0x14($a0)
0001A5A4 1c008cc4 lwc1       $f12, 0x1c($a0)
0001A5A8 a000a5af sw         $a1, 0xa0($sp)
0001A5AC 1800858c lw         $a1, 0x18($a0)
0001A5B0 00600844 mfc1       $t0, $f12
0001A5B4 a400a6af sw         $a2, 0xa4($sp)
0001A5B8 20008dc4 lwc1       $f13, 0x20($a0)
0001A5BC a800a7af sw         $a3, 0xa8($sp)
0001A5C0 24008ec4 lwc1       $f14, 0x24($a0)
0001A5C4 00680644 mfc1       $a2, $f13
0001A5C8 ac00a5af sw         $a1, 0xac($sp)
0001A5CC 28008fc4 lwc1       $f15, 0x28($a0)
0001A5D0 00700544 mfc1       $a1, $f14
0001A5D4 b000a8af sw         $t0, 0xb0($sp)
0001A5D8 b400a6af sw         $a2, 0xb4($sp)
0001A5DC 2c00878c lw         $a3, 0x2c($a0)
0001A5E0 00780644 mfc1       $a2, $f15
0001A5E4 b800a5af sw         $a1, 0xb8($sp)
0001A5E8 3000858c lw         $a1, 0x30($a0)
0001A5EC bc00a6af sw         $a2, 0xbc($sp)
0001A5F0 3400848c lw         $a0, 0x34($a0)
0001A5F4 c000a7af sw         $a3, 0xc0($sp)
0001A5F8 c400a5af sw         $a1, 0xc4($sp)
0001A5FC c800a4af sw         $a0, 0xc8($sp)
0001A600 1100103c lui        $s0, 0x11
0001A604 9026048e lw         $a0, 0x2690($s0)
0001A608 7d06000c jal        0x19f4
0001A60C 01000534 ori        $a1, $zero, 1
0001A610 9026048e lw         $a0, 0x2690($s0)
0001A614 24008010 beqz       $a0, 0x1a6a8
0001A618 00000000 nop        
0001A61C 9400a48f lw         $a0, 0x94($sp)
0001A620 1100053c lui        $a1, 0x11
0001A624 9026a58c lw         $a1, 0x2690($a1)
0001A628 9800a68f lw         $a2, 0x98($sp)
0001A62C 0800a524 addiu      $a1, $a1, 8
0001A630 9c00a78f lw         $a3, 0x9c($sp)
0001A634 0000a4ac sw         $a0, ($a1)
0001A638 a000a48f lw         $a0, 0xa0($sp)
0001A63C 0400a6ac sw         $a2, 4($a1)
0001A640 a400a68f lw         $a2, 0xa4($sp)
0001A644 0800a7ac sw         $a3, 8($a1)
0001A648 a800a78f lw         $a3, 0xa8($sp)
0001A64C b000acc7 lwc1       $f12, 0xb0($sp)
0001A650 0c00a4ac sw         $a0, 0xc($a1)
0001A654 ac00a48f lw         $a0, 0xac($sp)
0001A658 00600844 mfc1       $t0, $f12
0001A65C 1000a6ac sw         $a2, 0x10($a1)
0001A660 b400adc7 lwc1       $f13, 0xb4($sp)
0001A664 1400a7ac sw         $a3, 0x14($a1)
0001A668 b800aec7 lwc1       $f14, 0xb8($sp)
0001A66C 00680644 mfc1       $a2, $f13
0001A670 1800a4ac sw         $a0, 0x18($a1)
0001A674 bc00afc7 lwc1       $f15, 0xbc($sp)
0001A678 00700444 mfc1       $a0, $f14
0001A67C 1c00a8ac sw         $t0, 0x1c($a1)
0001A680 2000a6ac sw         $a2, 0x20($a1)
0001A684 c000a78f lw         $a3, 0xc0($sp)
0001A688 00780644 mfc1       $a2, $f15
0001A68C 2400a4ac sw         $a0, 0x24($a1)
0001A690 c400a48f lw         $a0, 0xc4($sp)
0001A694 2800a6ac sw         $a2, 0x28($a1)
0001A698 c800a68f lw         $a2, 0xc8($sp)
0001A69C 2c00a7ac sw         $a3, 0x2c($a1)
0001A6A0 3000a4ac sw         $a0, 0x30($a1)
0001A6A4 3400a6ac sw         $a2, 0x34($a1)
0001A6A8 22000434 ori        $a0, $zero, 0x22
0001A6AC 1200053c lui        $a1, 0x12
0001A6B0 10faa4ac sw         $a0, -0x5f0($a1)
0001A6B4 1100043c lui        $a0, 0x11
0001A6B8 e776000c jal        0x1db9c
0001A6BC 842680a0 sb         $zero, 0x2684($a0)
0001A6C0 1100043c lui        $a0, 0x11
0001A6C4 9026848c lw         $a0, 0x2690($a0)
0001A6C8 01000534 ori        $a1, $zero, 1
0001A6CC ce03000c jal        0xf38
0001A6D0 2c1c848c lw         $a0, 0x1c2c($a0)
0001A6D4 f4000010 b          0x1aaa8
0001A6D8 00000000 nop        
0001A6DC 1e77000c jal        0x1dc78
0001A6E0 25200000 move       $a0, $zero
0001A6E4 05004014 bnez       $v0, 0x1a6fc
0001A6E8 00000000 nop        
0001A6EC 1f000434 ori        $a0, $zero, 0x1f
0001A6F0 1200053c lui        $a1, 0x12
0001A6F4 5d000010 b          0x1a86c
0001A6F8 10faa4ac sw         $a0, -0x5f0($a1)
0001A6FC 6c76000c jal        0x1d9b0
0001A700 01000434 ori        $a0, $zero, 1
0001A704 59004014 bnez       $v0, 0x1a86c
0001A708 00000000 nop        
0001A70C 1100043c lui        $a0, 0x11
0001A710 9026848c lw         $a0, 0x2690($a0)
0001A714 23008010 beqz       $a0, 0x1a7a4
0001A718 1100043c lui        $a0, 0x11
0001A71C 9026848c lw         $a0, 0x2690($a0)
0001A720 08008424 addiu      $a0, $a0, 8
0001A724 0000858c lw         $a1, ($a0)
0001A728 0400868c lw         $a2, 4($a0)
0001A72C 0800878c lw         $a3, 8($a0)
0001A730 cc00a5af sw         $a1, 0xcc($sp)
0001A734 0c00858c lw         $a1, 0xc($a0)
0001A738 d000a6af sw         $a2, 0xd0($sp)
0001A73C 1000868c lw         $a2, 0x10($a0)
0001A740 d400a7af sw         $a3, 0xd4($sp)
0001A744 1400878c lw         $a3, 0x14($a0)
0001A748 1c008cc4 lwc1       $f12, 0x1c($a0)
0001A74C d800a5af sw         $a1, 0xd8($sp)
0001A750 1800858c lw         $a1, 0x18($a0)
0001A754 00600844 mfc1       $t0, $f12
0001A758 dc00a6af sw         $a2, 0xdc($sp)
0001A75C 20008dc4 lwc1       $f13, 0x20($a0)
0001A760 e000a7af sw         $a3, 0xe0($sp)
0001A764 24008ec4 lwc1       $f14, 0x24($a0)
0001A768 00680644 mfc1       $a2, $f13
0001A76C e400a5af sw         $a1, 0xe4($sp)
0001A770 28008fc4 lwc1       $f15, 0x28($a0)
0001A774 00700544 mfc1       $a1, $f14
0001A778 e800a8af sw         $t0, 0xe8($sp)
0001A77C ec00a6af sw         $a2, 0xec($sp)
0001A780 2c00878c lw         $a3, 0x2c($a0)
0001A784 00780644 mfc1       $a2, $f15
0001A788 f000a5af sw         $a1, 0xf0($sp)
0001A78C 3000858c lw         $a1, 0x30($a0)
0001A790 f400a6af sw         $a2, 0xf4($sp)
0001A794 3400848c lw         $a0, 0x34($a0)
0001A798 f800a7af sw         $a3, 0xf8($sp)
0001A79C fc00a5af sw         $a1, 0xfc($sp)
0001A7A0 0001a4af sw         $a0, 0x100($sp)
0001A7A4 1100103c lui        $s0, 0x11
0001A7A8 9026048e lw         $a0, 0x2690($s0)
0001A7AC 7d06000c jal        0x19f4
0001A7B0 01000534 ori        $a1, $zero, 1
0001A7B4 9026048e lw         $a0, 0x2690($s0)
0001A7B8 24008010 beqz       $a0, 0x1a84c
0001A7BC 00000000 nop        
0001A7C0 cc00a48f lw         $a0, 0xcc($sp)
0001A7C4 1100053c lui        $a1, 0x11
0001A7C8 9026a58c lw         $a1, 0x2690($a1)
0001A7CC d000a68f lw         $a2, 0xd0($sp)
0001A7D0 0800a524 addiu      $a1, $a1, 8
0001A7D4 d400a78f lw         $a3, 0xd4($sp)
0001A7D8 0000a4ac sw         $a0, ($a1)
0001A7DC d800a48f lw         $a0, 0xd8($sp)
0001A7E0 0400a6ac sw         $a2, 4($a1)
0001A7E4 dc00a68f lw         $a2, 0xdc($sp)
0001A7E8 0800a7ac sw         $a3, 8($a1)
0001A7EC e000a78f lw         $a3, 0xe0($sp)
0001A7F0 e800acc7 lwc1       $f12, 0xe8($sp)
0001A7F4 0c00a4ac sw         $a0, 0xc($a1)
0001A7F8 e400a48f lw         $a0, 0xe4($sp)
0001A7FC 00600844 mfc1       $t0, $f12
0001A800 1000a6ac sw         $a2, 0x10($a1)
0001A804 ec00adc7 lwc1       $f13, 0xec($sp)
0001A808 1400a7ac sw         $a3, 0x14($a1)
0001A80C f000aec7 lwc1       $f14, 0xf0($sp)
0001A810 00680644 mfc1       $a2, $f13
0001A814 1800a4ac sw         $a0, 0x18($a1)
0001A818 f400afc7 lwc1       $f15, 0xf4($sp)
0001A81C 00700444 mfc1       $a0, $f14
0001A820 1c00a8ac sw         $t0, 0x1c($a1)
0001A824 2000a6ac sw         $a2, 0x20($a1)
0001A828 f800a78f lw         $a3, 0xf8($sp)
0001A82C 00780644 mfc1       $a2, $f15
0001A830 2400a4ac sw         $a0, 0x24($a1)
0001A834 fc00a48f lw         $a0, 0xfc($sp)
0001A838 2800a6ac sw         $a2, 0x28($a1)
0001A83C 0001a68f lw         $a2, 0x100($sp)
0001A840 2c00a7ac sw         $a3, 0x2c($a1)
0001A844 3000a4ac sw         $a0, 0x30($a1)
0001A848 3400a6ac sw         $a2, 0x34($a1)
0001A84C 15000434 ori        $a0, $zero, 0x15
0001A850 1200053c lui        $a1, 0x12
0001A854 10faa4ac sw         $a0, -0x5f0($a1)
0001A858 1100043c lui        $a0, 0x11
0001A85C 9026858c lw         $a1, 0x2690($a0)
0001A860 25200000 move       $a0, $zero
0001A864 ca78000c jal        0x1e328
0001A868 3800a58c lw         $a1, 0x38($a1)
0001A86C 8e000010 b          0x1aaa8
0001A870 00000000 nop        
0001A874 6c76000c jal        0x1d9b0
0001A878 01000434 ori        $a0, $zero, 1
0001A87C 35004014 bnez       $v0, 0x1a954
0001A880 00000000 nop        
0001A884 ae76000c jal        0x1dab8
0001A888 00000000 nop        
0001A88C 05004010 beqz       $v0, 0x1a8a4
0001A890 00000000 nop        
0001A894 17000434 ori        $a0, $zero, 0x17
0001A898 1200053c lui        $a1, 0x12
0001A89C 2d000010 b          0x1a954
0001A8A0 10faa4ac sw         $a0, -0x5f0($a1)
0001A8A4 b476000c jal        0x1dad0
0001A8A8 00000000 nop        
0001A8AC 25204000 move       $a0, $v0
0001A8B0 08008104 bgez       $a0, 0x1a8d4
0001A8B4 1180053c lui        $a1, 0x8011
0001A8B8 8303a524 addiu      $a1, $a1, 0x383
0001A8BC 22008514 bne        $a0, $a1, 0x1a948
0001A8C0 00000000 nop        
0001A8C4 1e000434 ori        $a0, $zero, 0x1e
0001A8C8 1200053c lui        $a1, 0x12
0001A8CC 21000010 b          0x1a954
0001A8D0 10faa4ac sw         $a0, -0x5f0($a1)
0001A8D4 07008018 blez       $a0, 0x1a8f4
0001A8D8 02008428 slti       $a0, $a0, 2
0001A8DC 1a008010 beqz       $a0, 0x1a948
0001A8E0 00000000 nop        
0001A8E4 20000434 ori        $a0, $zero, 0x20
0001A8E8 1200053c lui        $a1, 0x12
0001A8EC 19000010 b          0x1a954
0001A8F0 10faa4ac sw         $a0, -0x5f0($a1)
0001A8F4 16000434 ori        $a0, $zero, 0x16
0001A8F8 1200053c lui        $a1, 0x12
0001A8FC 10faa4ac sw         $a0, -0x5f0($a1)
0001A900 1100043c lui        $a0, 0x11
0001A904 e776000c jal        0x1db9c
0001A908 842680a0 sb         $zero, 0x2684($a0)
0001A90C 1200043c lui        $a0, 0x12
0001A910 20fa8490 lbu        $a0, -0x5e0($a0)
0001A914 05008010 beqz       $a0, 0x1a92c
0001A918 00000000 nop        
0001A91C 1b0c000c jal        0x306c
0001A920 00000000 nop        
0001A924 1200043c lui        $a0, 0x12
0001A928 20fa80a0 sb         $zero, -0x5e0($a0)
0001A92C 1100043c lui        $a0, 0x11
0001A930 9026848c lw         $a0, 0x2690($a0)
0001A934 01000534 ori        $a1, $zero, 1
0001A938 ce03000c jal        0xf38
0001A93C 2c1c848c lw         $a0, 0x1c2c($a0)
0001A940 04000010 b          0x1a954
0001A944 00000000 nop        
0001A948 0a000434 ori        $a0, $zero, 0xa
0001A94C 1200053c lui        $a1, 0x12
0001A950 10faa4ac sw         $a0, -0x5f0($a1)
0001A954 54000010 b          0x1aaa8
0001A958 00000000 nop        
0001A95C 1e77000c jal        0x1dc78
0001A960 25200000 move       $a0, $zero
0001A964 05004014 bnez       $v0, 0x1a97c
0001A968 00000000 nop        
0001A96C 1f000434 ori        $a0, $zero, 0x1f
0001A970 1200053c lui        $a1, 0x12
0001A974 30000010 b          0x1aa38
0001A978 10faa4ac sw         $a0, -0x5f0($a1)
0001A97C f310000c jal        0x43cc
0001A980 01000434 ori        $a0, $zero, 1
0001A984 2b79000c jal        0x1e4ac
0001A988 25804000 move       $s0, $v0
0001A98C 0400053c lui        $a1, 4
0001A990 25884000 move       $s1, $v0
0001A994 f6020434 ori        $a0, $zero, 0x2f6
0001A998 8874000c jal        0x1d220
0001A99C 5841b224 addiu      $s2, $a1, 0x4158
0001A9A0 25204002 move       $a0, $s2
0001A9A4 25284000 move       $a1, $v0
0001A9A8 c990000c jal        0x24324
0001A9AC 25302002 move       $a2, $s1
0001A9B0 8874000c jal        0x1d220
0001A9B4 ea000434 ori        $a0, $zero, 0xea
0001A9B8 25884000 move       $s1, $v0
0001A9BC 8874000c jal        0x1d220
0001A9C0 eb000434 ori        $a0, $zero, 0xeb
0001A9C4 03000434 ori        $a0, $zero, 3
0001A9C8 25284002 move       $a1, $s2
0001A9CC 25302002 move       $a2, $s1
0001A9D0 b260000c jal        0x182c8
0001A9D4 25384000 move       $a3, $v0
0001A9D8 c05e000c jal        0x17b00
0001A9DC 25200002 move       $a0, $s0
0001A9E0 6f5f000c jal        0x17dbc
0001A9E4 00000000 nop        
0001A9E8 25204000 move       $a0, $v0
0001A9EC 01000534 ori        $a1, $zero, 1
0001A9F0 0b008514 bne        $a0, $a1, 0x1aa20
0001A9F4 00000000 nop        
0001A9F8 3060000c jal        0x180c0
0001A9FC 25200000 move       $a0, $zero
0001AA00 1100043c lui        $a0, 0x11
0001AA04 9026848c lw         $a0, 0x2690($a0)
0001AA08 6579000c jal        0x1e594
0001AA0C 3800848c lw         $a0, 0x38($a0)
0001AA10 1d000434 ori        $a0, $zero, 0x1d
0001AA14 1200053c lui        $a1, 0x12
0001AA18 07000010 b          0x1aa38
0001AA1C 10faa4ac sw         $a0, -0x5f0($a1)
0001AA20 02000534 ori        $a1, $zero, 2
0001AA24 04008514 bne        $a0, $a1, 0x1aa38
0001AA28 00000000 nop        
0001AA2C 20000434 ori        $a0, $zero, 0x20
0001AA30 1200053c lui        $a1, 0x12
0001AA34 10faa4ac sw         $a0, -0x5f0($a1)
0001AA38 1b000010 b          0x1aaa8
0001AA3C 00000000 nop        
0001AA40 6c76000c jal        0x1d9b0
0001AA44 01000434 ori        $a0, $zero, 1
0001AA48 09004010 beqz       $v0, 0x1aa70
0001AA4C 00000000 nop        
0001AA50 20000534 ori        $a1, $zero, 0x20
0001AA54 20000634 ori        $a2, $zero, 0x20
0001AA58 03000734 ori        $a3, $zero, 3
0001AA5C 25400000 move       $t0, $zero
0001AA60 2337000c jal        0xdc8c
0001AA64 0080043c lui        $a0, 0x8000
0001AA68 04000010 b          0x1aa7c
0001AA6C 00000000 nop        
0001AA70 18000434 ori        $a0, $zero, 0x18
0001AA74 1200053c lui        $a1, 0x12
0001AA78 10faa4ac sw         $a0, -0x5f0($a1)
0001AA7C 0a000010 b          0x1aaa8
0001AA80 00000000 nop        
0001AA84 22000434 ori        $a0, $zero, 0x22
0001AA88 1200053c lui        $a1, 0x12
0001AA8C 06000010 b          0x1aaa8
0001AA90 10faa4ac sw         $a0, -0x5f0($a1)
0001AA94 04000010 b          0x1aaa8
0001AA98 00000000 nop        
0001AA9C 0a000434 ori        $a0, $zero, 0xa
0001AAA0 1200053c lui        $a1, 0x12
0001AAA4 10faa4ac sw         $a0, -0x5f0($a1)
0001AAA8 1200043c lui        $a0, 0x12
0001AAAC 4cfa9024 addiu      $s0, $a0, -0x5b4
0001AAB0 0d57000c jal        0x15c34
0001AAB4 25200002 move       $a0, $s0
0001AAB8 1200043c lui        $a0, 0x12
0001AABC 0d57000c jal        0x15c34
0001AAC0 74fa8424 addiu      $a0, $a0, -0x58c
0001AAC4 1200043c lui        $a0, 0x12
0001AAC8 0d57000c jal        0x15c34
0001AACC 9cfa8424 addiu      $a0, $a0, -0x564
0001AAD0 3557000c jal        0x15cd4
0001AAD4 25200002 move       $a0, $s0
0001AAD8 1200043c lui        $a0, 0x12
0001AADC 70fe8424 addiu      $a0, $a0, -0x190
0001AAE0 1c0082ac sw         $v0, 0x1c($a0)
0001AAE4 1200043c lui        $a0, 0x12
0001AAE8 14ff8490 lbu        $a0, -0xec($a0)
0001AAEC 06008010 beqz       $a0, 0x1ab08
0001AAF0 00000000 nop        
0001AAF4 84030434 ori        $a0, $zero, 0x384
0001AAF8 1200053c lui        $a1, 0x12
0001AAFC c4faa4ac sw         $a0, -0x53c($a1)
0001AB00 1200043c lui        $a0, 0x12
0001AB04 14ff80a0 sb         $zero, -0xec($a0)
0001AB08 0401b08f lw         $s0, 0x104($sp)
0001AB0C 0801b18f lw         $s1, 0x108($sp)
0001AB10 0c01b28f lw         $s2, 0x10c($sp)
0001AB14 1001bf8f lw         $ra, 0x110($sp)
0001AB18 0800e003 jr         $ra
0001AB1C 2001bd27 addiu      $sp, $sp, 0x120