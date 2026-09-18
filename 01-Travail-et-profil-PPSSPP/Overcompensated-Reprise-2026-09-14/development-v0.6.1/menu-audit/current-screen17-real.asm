000B25AC e0ffbd27 addiu      $sp, $sp, -0x20
000B25B0 1000b0af sw         $s0, 0x10($sp)
000B25B4 1400b1af sw         $s1, 0x14($sp)
000B25B8 1800bfaf sw         $ra, 0x18($sp)
000B25BC 12e1010c jal        0x78448
000B25C0 106b0434 ori        $a0, $zero, 0x6b10
000B25C4 1b67040c jal        0x119c6c
000B25C8 25884000 move       $s1, $v0
000B25CC 2d00103c lui        $s0, 0x2d
000B25D0 6f15030c jal        0xc55bc
000B25D4 48171026 addiu      $s0, $s0, 0x1748
000B25D8 05004010 beqz       $v0, 0xb25f0
000B25DC 00000000 nop        
000B25E0 39c9020c jal        0xb24e4
000B25E4 25202002 move       $a0, $s1
000B25E8 4a000010 b          0xb2714
000B25EC 00000000 nop        
000B25F0 08102432 andi       $a0, $s1, 0x1008
000B25F4 0a008010 beqz       $a0, 0xb2620
000B25F8 00000000 nop        
000B25FC 24a4020c jal        0xa9090
000B2600 25200000 move       $a0, $zero
000B2604 24a4020c jal        0xa9090
000B2608 07000434 ori        $a0, $zero, 7
000B260C 04000434 ori        $a0, $zero, 4
000B2610 ff51000c jal        0x147fc
000B2614 25280000 move       $a1, $zero
000B2618 3e000010 b          0xb2714
000B261C 00000000 nop        
000B2620 00402432 andi       $a0, $s1, 0x4000
000B2624 38008010 beqz       $a0, 0xb2708
000B2628 00000000 nop        
000B262C 0800048e lw         $a0, 8($s0)
000B2630 0000058e lw         $a1, ($s0)
000B2634 80200400 sll        $a0, $a0, 2
000B2638 2120a400 addu       $a0, $a1, $a0
000B263C 0000848c lw         $a0, ($a0)
000B2640 cc008490 lbu        $a0, 0xcc($a0)
000B2644 33008010 beqz       $a0, 0xb2714
000B2648 00000000 nop        
000B264C 24a4020c jal        0xa9090
000B2650 01000434 ori        $a0, $zero, 1
000B2654 0800048e lw         $a0, 8($s0)
000B2658 0000058e lw         $a1, ($s0)
000B265C 80200400 sll        $a0, $a0, 2
000B2660 2120a400 addu       $a0, $a1, $a0
000B2664 0000848c lw         $a0, ($a0)
000B2668 d000848c lw         $a0, 0xd0($a0)
000B266C 08008014 bnez       $a0, 0xb2690
000B2670 00000000 nop        
000B2674 24a4020c jal        0xa9090
000B2678 07000434 ori        $a0, $zero, 7
000B267C 04000434 ori        $a0, $zero, 4
000B2680 ff51000c jal        0x147fc
000B2684 25280000 move       $a1, $zero
000B2688 1d000010 b          0xb2700
000B268C 00000000 nop        
000B2690 24a4020c jal        0xa9090
000B2694 06000434 ori        $a0, $zero, 6
000B2698 0800048e lw         $a0, 8($s0)
000B269C 0000058e lw         $a1, ($s0)
000B26A0 80200400 sll        $a0, $a0, 2
000B26A4 2120a400 addu       $a0, $a1, $a0
000B26A8 0000848c lw         $a0, ($a0)
000B26AC cc008590 lbu        $a1, 0xcc($a0)
000B26B0 1300a010 beqz       $a1, 0xb2700
000B26B4 00000000 nop        
000B26B8 d000848c lw         $a0, 0xd0($a0)
000B26BC 64000534 ori        $a1, $zero, 0x64
000B26C0 08008514 bne        $a0, $a1, 0xb26e4
000B26C4 00000000 nop        
000B26C8 01000434 ori        $a0, $zero, 1
000B26CC 2d00053c lui        $a1, 0x2d
000B26D0 7015a4a0 sb         $a0, 0x1570($a1)
000B26D4 23c9020c jal        0xb248c
000B26D8 c3010434 ori        $a0, $zero, 0x1c3
000B26DC 08000010 b          0xb2700
000B26E0 00000000 nop        
000B26E4 65000534 ori        $a1, $zero, 0x65
000B26E8 05008514 bne        $a0, $a1, 0xb2700
000B26EC 00000000 nop        
000B26F0 2d00043c lui        $a0, 0x2d
000B26F4 701580a0 sb         $zero, 0x1570($a0)
000B26F8 23c9020c jal        0xb248c
000B26FC c4010434 ori        $a0, $zero, 0x1c4
000B2700 04000010 b          0xb2714
000B2704 00000000 nop        
000B2708 25200002 move       $a0, $s0
000B270C c6ae020c jal        0xabb18
000B2710 25282002 move       $a1, $s1
000B2714 2d00043c lui        $a0, 0x2d
000B2718 b59a020c jal        0xa6ad4
000B271C bcf78424 addiu      $a0, $a0, -0x844
000B2720 1c0002ae sw         $v0, 0x1c($s0)
000B2724 1000b08f lw         $s0, 0x10($sp)
000B2728 1400b18f lw         $s1, 0x14($sp)
000B272C 1800bf8f lw         $ra, 0x18($sp)
000B2730 0800e003 jr         $ra
000B2734 2000bd27 addiu      $sp, $sp, 0x20
000B2738 00290500 sll        $a1, $a1, 4
000B273C 80200400 sll        $a0, $a0, 2
000B2740 2120a400 addu       $a0, $a1, $a0
000B2744 2d00053c lui        $a1, 0x2d
000B2748 f017a524 addiu      $a1, $a1, 0x17f0
000B274C 21208500 addu       $a0, $a0, $a1
000B2750 0800e003 jr         $ra
000B2754 0000828c lw         $v0, ($a0)
000B2758 00290500 sll        $a1, $a1, 4
000B275C 80200400 sll        $a0, $a0, 2
000B2760 2120a400 addu       $a0, $a1, $a0
000B2764 2d00053c lui        $a1, 0x2d
000B2768 2018a524 addiu      $a1, $a1, 0x1820
000B276C 21208500 addu       $a0, $a0, $a1
000B2770 0800e003 jr         $ra
000B2774 0000828c lw         $v0, ($a0)
000B2778 e0ffbd27 addiu      $sp, $sp, -0x20
000B277C 1000bfaf sw         $ra, 0x10($sp)
000B2780 d6c9020c jal        0xb2758
000B2784 00000000 nop        
000B2788 2e00053c lui        $a1, 0x2e
000B278C 80200200 sll        $a0, $v0, 2
000B2790 38f1a524 addiu      $a1, $a1, -0xec8
000B2794 21208500 addu       $a0, $a0, $a1
000B2798 0000828c lw         $v0, ($a0)
000B279C 1000bf8f lw         $ra, 0x10($sp)
000B27A0 0800e003 jr         $ra
000B27A4 2000bd27 addiu      $sp, $sp, 0x20
000B27A8 f0ffbd27 addiu      $sp, $sp, -0x10
000B27AC 0000bfaf sw         $ra, ($sp)
000B27B0 8424040c jal        0x109210
000B27B4 00000000 nop        
000B27B8 0000bf8f lw         $ra, ($sp)
000B27BC 0800e003 jr         $ra
000B27C0 1000bd27 addiu      $sp, $sp, 0x10
000B27C4 d0ffbd27 addiu      $sp, $sp, -0x30
000B27C8 1000b0af sw         $s0, 0x10($sp)
000B27CC 1400b1af sw         $s1, 0x14($sp)
000B27D0 1800b2af sw         $s2, 0x18($sp)
000B27D4 1c00b3af sw         $s3, 0x1c($sp)
000B27D8 2000bfaf sw         $ra, 0x20($sp)
000B27DC 12e1010c jal        0x78448
000B27E0 01000434 ori        $a0, $zero, 1
000B27E4 25284000 move       $a1, $v0
000B27E8 0040a430 andi       $a0, $a1, 0x4000
000B27EC 0a008010 beqz       $a0, 0xb2818
000B27F0 00000000 nop        
000B27F4 24a4020c jal        0xa9090
000B27F8 01000434 ori        $a0, $zero, 1
000B27FC 24a4020c jal        0xa9090
000B2800 02000434 ori        $a0, $zero, 2
000B2804 04000434 ori        $a0, $zero, 4
000B2808 ff51000c jal        0x147fc
000B280C 25280000 move       $a1, $zero
000B2810 5f000010 b          0xb2990
000B2814 00000000 nop        
000B2818 2d00113c lui        $s1, 0x2d
000B281C 00001334 ori        $s3, $zero, 0
000B2820 00001234 ori        $s2, $zero, 0
000B2824 1000a630 andi       $a2, $a1, 0x10
000B2828 7c18248e lw         $a0, 0x187c($s1)
000B282C 0400c010 beqz       $a2, 0xb2840
000B2830 2d00103c lui        $s0, 0x2d
000B2834 ffff1224 addiu      $s2, $zero, -1
000B2838 10000010 b          0xb287c
000B283C ffff8424 addiu      $a0, $a0, -1
000B2840 4000a630 andi       $a2, $a1, 0x40
000B2844 0400c010 beqz       $a2, 0xb2858
000B2848 00000000 nop        
000B284C 01001234 ori        $s2, $zero, 1
000B2850 0a000010 b          0xb287c
000B2854 01008424 addiu      $a0, $a0, 1
000B2858 8000a630 andi       $a2, $a1, 0x80
000B285C 0300c010 beqz       $a2, 0xb286c
000B2860 00000000 nop        
000B2864 05000010 b          0xb287c
000B2868 ffff1324 addiu      $s3, $zero, -1
000B286C 2000a530 andi       $a1, $a1, 0x20
000B2870 0200a010 beqz       $a1, 0xb287c
000B2874 00000000 nop        
000B2878 01001334 ori        $s3, $zero, 1
000B287C 7c1824ae sw         $a0, 0x187c($s1)
000B2880 7818058e lw         $a1, 0x1878($s0)
000B2884 03008628 slti       $a2, $a0, 3
000B2888 2128b300 addu       $a1, $a1, $s3
000B288C 0300c014 bnez       $a2, 0xb289c
000B2890 781805ae sw         $a1, 0x1878($s0)
000B2894 7c1820ae sw         $zero, 0x187c($s1)
000B2898 25200000 move       $a0, $zero
000B289C 03008104 bgez       $a0, 0xb28ac
000B28A0 00000000 nop        
000B28A4 02000434 ori        $a0, $zero, 2
000B28A8 7c1824ae sw         $a0, 0x187c($s1)