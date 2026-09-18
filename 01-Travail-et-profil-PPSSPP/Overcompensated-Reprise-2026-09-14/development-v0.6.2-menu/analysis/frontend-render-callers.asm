000190C0 25280000 move       $a1, $zero
000190C4 e0010634 ori        $a2, $zero, 0x1e0
000190C8 10010734 ori        $a3, $zero, 0x110
000190CC 3400bfaf sw         $ra, 0x34($sp)
000190D0 2f40000c jal        0x100bc
000190D4 ffff0824 addiu      $t0, $zero, -1
000190D8 1200043c lui        $a0, 0x12
000190DC fcb9848c lw         $a0, -0x4604($a0)
000190E0 10010234 ori        $v0, $zero, 0x110
000190E4 0000a2af sw         $v0, ($sp)
000190E8 25280000 move       $a1, $zero
000190EC 25300000 move       $a2, $zero
000190F0 e0010734 ori        $a3, $zero, 0x1e0
000190F4 10010834 ori        $t0, $zero, 0x110
000190F8 25480000 move       $t1, $zero
000190FC 25500000 move       $t2, $zero
00019100 e0010b34 ori        $t3, $zero, 0x1e0
00019104 9e41000c jal        0x10678
00019108 0400b0af sw         $s0, 4($sp)
0001910C 1200043c lui        $a0, 0x12
00019110 3459000c jal        0x164d0
00019114 f0c28424 addiu      $a0, $a0, -0x3d10
00019118 3000b08f lw         $s0, 0x30($sp)
0001911C 3400bf8f lw         $ra, 0x34($sp)
00019120 0800e003 jr         $ra
00019124 4000bd27 addiu      $sp, $sp, 0x40
00019128 e0ffbd27 addiu      $sp, $sp, -0x20
0001912C 1000bfaf sw         $ra, 0x10($sp)
00019130 b32f000c jal        0xbecc
00019134 01000434 ori        $a0, $zero, 1
00019138 bd69000c jal        0x1a6f4
0001913C 00000000 nop        
00019140 7830000c jal        0xc1e0
00019144 25200000 move       $a0, $zero
00019148 1000bf8f lw         $ra, 0x10($sp)
0001914C 0800e003 jr         $ra
00019150 2000bd27 addiu      $sp, $sp, 0x20
00019154 e0ffbd27 addiu      $sp, $sp, -0x20
00019158 1100053c lui        $a1, 0x11
0001915C 302aa58c lw         $a1, 0x2a30($a1)
00019160 1200063c lui        $a2, 0x12
00019164 2c1ca0ac sw         $zero, 0x1c2c($a1)
00019168 60bec4ac sw         $a0, -0x41a0($a2)
0001916C 0000053c lui        $a1, 0
00019170 25200000 move       $a0, $zero

0001A7D4 25200000 move       $a0, $zero
0001A7D8 25280000 move       $a1, $zero
0001A7DC e0010634 ori        $a2, $zero, 0x1e0
0001A7E0 10010734 ori        $a3, $zero, 0x110
0001A7E4 2f40000c jal        0x100bc
0001A7E8 ffff0824 addiu      $t0, $zero, -1
0001A7EC 1200043c lui        $a0, 0x12
0001A7F0 fcb9848c lw         $a0, -0x4604($a0)
0001A7F4 10010234 ori        $v0, $zero, 0x110
0001A7F8 0000a2af sw         $v0, ($sp)
0001A7FC 25280000 move       $a1, $zero
0001A800 25300000 move       $a2, $zero
0001A804 e0010734 ori        $a3, $zero, 0x1e0
0001A808 10010834 ori        $t0, $zero, 0x110
0001A80C 25480000 move       $t1, $zero
0001A810 25500000 move       $t2, $zero
0001A814 e0010b34 ori        $t3, $zero, 0x1e0
0001A818 9e41000c jal        0x10678
0001A81C 0400b0af sw         $s0, 4($sp)
0001A820 1200043c lui        $a0, 0x12
0001A824 3459000c jal        0x164d0
0001A828 f0c28424 addiu      $a0, $a0, -0x3d10
0001A82C 275f000c jal        0x17c9c
0001A830 00000000 nop        
0001A834 09000010 b          0x1a85c
0001A838 00000000 nop        
0001A83C 2c64000c jal        0x190b0
0001A840 00000000 nop        
0001A844 275f000c jal        0x17c9c
0001A848 00000000 nop        
0001A84C 03000010 b          0x1a85c
0001A850 00000000 nop        
0001A854 275f000c jal        0x17c9c
0001A858 00000000 nop        
0001A85C 4337000c jal        0xdd0c
0001A860 00000000 nop        
0001A864 3000b08f lw         $s0, 0x30($sp)
0001A868 3400bf8f lw         $ra, 0x34($sp)
0001A86C 0800e003 jr         $ra
0001A870 4000bd27 addiu      $sp, $sp, 0x40
0001A874 e0ffbd27 addiu      $sp, $sp, -0x20
0001A878 1000bfaf sw         $ra, 0x10($sp)
0001A87C 3e39000c jal        0xe4f8
0001A880 00000000 nop        
0001A884 e738000c jal        0xe39c

0001A840 00000000 nop        
0001A844 275f000c jal        0x17c9c
0001A848 00000000 nop        
0001A84C 03000010 b          0x1a85c
0001A850 00000000 nop        
0001A854 275f000c jal        0x17c9c
0001A858 00000000 nop        
0001A85C 4337000c jal        0xdd0c
0001A860 00000000 nop        
0001A864 3000b08f lw         $s0, 0x30($sp)
0001A868 3400bf8f lw         $ra, 0x34($sp)
0001A86C 0800e003 jr         $ra
0001A870 4000bd27 addiu      $sp, $sp, 0x40
0001A874 e0ffbd27 addiu      $sp, $sp, -0x20
0001A878 1000bfaf sw         $ra, 0x10($sp)
0001A87C 3e39000c jal        0xe4f8
0001A880 00000000 nop        
0001A884 e738000c jal        0xe39c
0001A888 00000000 nop        
0001A88C 1200043c lui        $a0, 0x12
0001A890 3459000c jal        0x164d0
0001A894 74c58424 addiu      $a0, $a0, -0x3a8c
0001A898 275f000c jal        0x17c9c
0001A89C 00000000 nop        
0001A8A0 4337000c jal        0xdd0c
0001A8A4 00000000 nop        
0001A8A8 1000bf8f lw         $ra, 0x10($sp)
0001A8AC 0800e003 jr         $ra
0001A8B0 2000bd27 addiu      $sp, $sp, 0x20
0001A8B4 0800e003 jr         $ra
0001A8B8 00000000 nop        
0001A8BC 0800e003 jr         $ra
0001A8C0 00000000 nop        
0001A8C4 e0ffbd27 addiu      $sp, $sp, -0x20
0001A8C8 1000b0af sw         $s0, 0x10($sp)
0001A8CC 1400bfaf sw         $ra, 0x14($sp)
0001A8D0 5a38000c jal        0xe168
0001A8D4 ffff0424 addiu      $a0, $zero, -1
0001A8D8 6310000c jal        0x418c
0001A8DC 00000000 nop        
0001A8E0 25200000 move       $a0, $zero
0001A8E4 7311000c jal        0x45cc
0001A8E8 25280000 move       $a1, $zero
0001A8EC 5a05000c jal        0x1568
0001A8F0 00000000 nop        

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
0001ABC8 1c00a48f lw         $a0, 0x1c($sp)
0001ABCC 002c0200 sll        $a1, $v0, 0x10
0001ABD0 00340400 sll        $a2, $a0, 0x10
0001ABD4 03240500 sra        $a0, $a1, 0x10
0001ABD8 032c0600 sra        $a1, $a2, 0x10
0001ABDC 0300063c lui        $a2, 3
0001ABE0 b03c000c jal        0xf2c0
0001ABE4 ac25c624 addiu      $a2, $a2, 0x25ac
0001ABE8 0200043c lui        $a0, 2
0001ABEC 3459000c jal        0x164d0
0001ABF0 d8228424 addiu      $a0, $a0, 0x22d8
0001ABF4 9b020434 ori        $a0, $zero, 0x29b
0001ABF8 06a30046 mov.s      $f12, $f20
0001ABFC 5247000c jal        0x11d48
0001AC00 25280002 move       $a1, $s0
0001AC04 1000a48f lw         $a0, 0x10($sp)
0001AC08 1c00a58f lw         $a1, 0x1c($sp)
0001AC0C 00240400 sll        $a0, $a0, 0x10
0001AC10 038c0400 sra        $s1, $a0, 0x10
0001AC14 00240500 sll        $a0, $a1, 0x10
0001AC18 03940400 sra        $s2, $a0, 0x10
0001AC1C dd73000c jal        0x1cf74
0001AC20 41010434 ori        $a0, $zero, 0x141
0001AC24 25202002 move       $a0, $s1
0001AC28 25284002 move       $a1, $s2
0001AC2C 303b000c jal        0xecc0
0001AC30 25304000 move       $a2, $v0
0001AC34 9d020434 ori        $a0, $zero, 0x29d
0001AC38 06a30046 mov.s      $f12, $f20
0001AC3C 5247000c jal        0x11d48
0001AC40 25280002 move       $a1, $s0
0001AC44 1800a48f lw         $a0, 0x18($sp)
0001AC48 1c00a58f lw         $a1, 0x1c($sp)
0001AC4C 00240400 sll        $a0, $a0, 0x10

0001AE40 5800b3af sw         $s3, 0x58($sp)
0001AE44 5c00b4af sw         $s4, 0x5c($sp)
0001AE48 6000b5af sw         $s5, 0x60($sp)
0001AE4C 6400bfaf sw         $ra, 0x64($sp)
0001AE50 2f40000c jal        0x100bc
0001AE54 ffff0824 addiu      $t0, $zero, -1
0001AE58 1200043c lui        $a0, 0x12
0001AE5C fcb9848c lw         $a0, -0x4604($a0)
0001AE60 10010234 ori        $v0, $zero, 0x110
0001AE64 0000a2af sw         $v0, ($sp)
0001AE68 25280000 move       $a1, $zero
0001AE6C 25300000 move       $a2, $zero
0001AE70 e0010734 ori        $a3, $zero, 0x1e0
0001AE74 10010834 ori        $t0, $zero, 0x110
0001AE78 25480000 move       $t1, $zero
0001AE7C 25500000 move       $t2, $zero
0001AE80 e0010b34 ori        $t3, $zero, 0x1e0
0001AE84 9e41000c jal        0x10678
0001AE88 0400b0af sw         $s0, 4($sp)
0001AE8C 1200043c lui        $a0, 0x12
0001AE90 3459000c jal        0x164d0
0001AE94 24db8424 addiu      $a0, $a0, -0x24dc
0001AE98 803f093c lui        $t1, 0x3f80
0001AE9C 00a08044 mtc1       $zero, $f20
0001AEA0 00b08944 mtc1       $t1, $f22
0001AEA4 40030434 ori        $a0, $zero, 0x340
0001AEA8 25280000 move       $a1, $zero
0001AEAC 86a30046 mov.s      $f14, $f20
0001AEB0 25300000 move       $a2, $zero
0001AEB4 c6a30046 mov.s      $f15, $f20
0001AEB8 25380000 move       $a3, $zero
0001AEBC 06b30046 mov.s      $f12, $f22
0001AEC0 ffff0824 addiu      $t0, $zero, -1
0001AEC4 9f52000c jal        0x14a7c
0001AEC8 46b30046 mov.s      $f13, $f22
0001AECC 5a38000c jal        0xe168
0001AED0 ffff0424 addiu      $a0, $zero, -1
0001AED4 3000b027 addiu      $s0, $sp, 0x30
0001AED8 06a30046 mov.s      $f12, $f20
0001AEDC 57010434 ori        $a0, $zero, 0x157
0001AEE0 5247000c jal        0x11d48
0001AEE4 25280002 move       $a1, $s0
0001AEE8 e24c000c jal        0x13388
0001AEEC 25200002 move       $a0, $s0
0001AEF0 3c00a48f lw         $a0, 0x3c($sp)