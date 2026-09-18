0001AD9C a457000c jal        0x15e90
0001ADA0 01000634 ori        $a2, $zero, 1
0001ADA4 0000258e lw         $a1, ($s1)
0001ADA8 0400268e lw         $a2, 4($s1)
0001ADAC 25206002 move       $a0, $s3
0001ADB0 25380000 move       $a3, $zero
0001ADB4 25400000 move       $t0, $zero
0001ADB8 25480000 move       $t1, $zero
0001ADBC 01000a34 ori        $t2, $zero, 1
0001ADC0 25580000 move       $t3, $zero
0001ADC4 ec58000c jal        0x163b0
0001ADC8 0000b0af sw         $s0, ($sp)
0001ADCC 01005226 addiu      $s2, $s2, 1
0001ADD0 0f00442e sltiu      $a0, $s2, 0xf
0001ADD4 efff8014 bnez       $a0, 0x1ad94
0001ADD8 08003126 addiu      $s1, $s1, 8
0001ADDC 1400648e lw         $a0, 0x14($s3)
0001ADE0 04008434 ori        $a0, $a0, 4
0001ADE4 10008434 ori        $a0, $a0, 0x10
0001ADE8 140064ae sw         $a0, 0x14($s3)
0001ADEC 0458000c jal        0x16010
0001ADF0 25206002 move       $a0, $s3
0001ADF4 4000b08f lw         $s0, 0x40($sp)
0001ADF8 4400b18f lw         $s1, 0x44($sp)
0001ADFC 4800b28f lw         $s2, 0x48($sp)
0001AE00 4c00b38f lw         $s3, 0x4c($sp)
0001AE04 5000bf8f lw         $ra, 0x50($sp)
0001AE08 0800e003 jr         $ra
0001AE0C 6000bd27 addiu      $sp, $sp, 0x60
0001AE10 90ffbd27 addiu      $sp, $sp, -0x70
0001AE14 4c00b0af sw         $s0, 0x4c($sp)
0001AE18 ffff1024 addiu      $s0, $zero, -1
0001AE1C 25200000 move       $a0, $zero
0001AE20 25280000 move       $a1, $zero
0001AE24 e0010634 ori        $a2, $zero, 0x1e0
0001AE28 10010734 ori        $a3, $zero, 0x110
0001AE2C 4000b4e7 swc1       $f20, 0x40($sp)
0001AE30 4400b6e7 swc1       $f22, 0x44($sp)
0001AE34 4800b8e7 swc1       $f24, 0x48($sp)
0001AE38 5000b1af sw         $s1, 0x50($sp)
0001AE3C 5400b2af sw         $s2, 0x54($sp)
0001AE40 5800b3af sw         $s3, 0x58($sp)
0001AE44 5c00b4af sw         $s4, 0x5c($sp)
0001AE48 6000b5af sw         $s5, 0x60($sp)
0001AE4C 6400bfaf sw         $ra, 0x64($sp)