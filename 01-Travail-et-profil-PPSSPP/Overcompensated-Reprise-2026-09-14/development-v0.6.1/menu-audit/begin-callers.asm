000ABFC4 b683020c jal        0xa0ed8
000ABFC8 25280000 move       $a1, $zero
000ABFCC 0400048e lw         $a0, 4($s0)
000ABFD0 01007326 addiu      $s3, $s3, 1
000ABFD4 2b206402 sltu       $a0, $s3, $a0
000ABFD8 f4ff8014 bnez       $a0, 0xabfac
000ABFDC 04005226 addiu      $s2, $s2, 4
000ABFE0 1000b08f lw         $s0, 0x10($sp)
000ABFE4 1400b18f lw         $s1, 0x14($sp)
000ABFE8 1800b28f lw         $s2, 0x18($sp)
000ABFEC 1c00b38f lw         $s3, 0x1c($sp)
000ABFF0 2000bf8f lw         $ra, 0x20($sp)
000ABFF4 0800e003 jr         $ra
000ABFF8 3000bd27 addiu      $sp, $sp, 0x30
000ABFFC e0ffbd27 addiu      $sp, $sp, -0x20
000AC000 1000bfaf sw         $ra, 0x10($sp)
000AC004 06b0020c jal        0xac018
000AC008 00000000 nop        
000AC00C 1000bf8f lw         $ra, 0x10($sp)
000AC010 0800e003 jr         $ra
000AC014 2000bd27 addiu      $sp, $sp, 0x20
000AC018 c0ffbd27 addiu      $sp, $sp, -0x40
000AC01C 2400b0af sw         $s0, 0x24($sp)
000AC020 25808000 move       $s0, $a0
000AC024 240005ae sw         $a1, 0x24($s0)
000AC028 2120a600 addu       $a0, $a1, $a2
000AC02C 280004ae sw         $a0, 0x28($s0)
000AC030 2c0005ae sw         $a1, 0x2c($s0)
000AC034 300000ae sw         $zero, 0x30($s0)
000AC038 340000ae sw         $zero, 0x34($s0)
000AC03C 380000ae sw         $zero, 0x38($s0)
000AC040 2800b1af sw         $s1, 0x28($sp)
000AC044 080000ae sw         $zero, 8($s0)
000AC048 ffff1124 addiu      $s1, $zero, -1
000AC04C 25200002 move       $a0, $s0
000AC050 2000b4e7 swc1       $f20, 0x20($sp)

000B107C 4000b1af sw         $s1, 0x40($sp)
000B1080 4400b2af sw         $s2, 0x44($sp)
000B1084 4c00b4af sw         $s4, 0x4c($sp)
000B1088 5400b6af sw         $s6, 0x54($sp)
000B108C 5800b7af sw         $s7, 0x58($sp)
000B1090 5c00beaf sw         $fp, 0x5c($sp)
000B1094 6000bfaf sw         $ra, 0x60($sp)
000B1098 3400b5af sw         $s5, 0x34($sp)
000B109C 00000434 ori        $a0, $zero, 0
000B10A0 3000a4af sw         $a0, 0x30($sp)
000B10A4 06001e3c lui        $fp, 6
000B10A8 2d00053c lui        $a1, 0x2d
000B10AC 25206002 move       $a0, $s3
000B10B0 00100634 ori        $a2, $zero, 0x1000
000B10B4 25380000 move       $a3, $zero
000B10B8 b8b1de27 addiu      $fp, $fp, -0x4e48
000B10BC 06b0020c jal        0xac018
000B10C0 e4f8a524 addiu      $a1, $a1, -0x71c
000B10C4 2000b027 addiu      $s0, $sp, 0x20
000B10C8 00a08044 mtc1       $zero, $f20
000B10CC 24010434 ori        $a0, $zero, 0x124
000B10D0 06a30046 mov.s      $f12, $f20
000B10D4 f583020c jal        0xa0fd4
000B10D8 25280002 move       $a1, $s0
000B10DC 2000a48f lw         $a0, 0x20($sp)
000B10E0 2400a68f lw         $a2, 0x24($sp)
000B10E4 002c0400 sll        $a1, $a0, 0x10
000B10E8 2800a48f lw         $a0, 0x28($sp)
000B10EC 2c00a88f lw         $t0, 0x2c($sp)
000B10F0 00340600 sll        $a2, $a2, 0x10
000B10F4 003c0400 sll        $a3, $a0, 0x10
000B10F8 00440800 sll        $t0, $t0, 0x10
000B10FC 032c0500 sra        $a1, $a1, 0x10
000B1100 03340600 sra        $a2, $a2, 0x10
000B1104 033c0700 sra        $a3, $a3, 0x10
000B1108 03440800 sra        $t0, $t0, 0x10

000B4350 1000b08f lw         $s0, 0x10($sp)
000B4354 1400bf8f lw         $ra, 0x14($sp)
000B4358 0800e003 jr         $ra
000B435C 2000bd27 addiu      $sp, $sp, 0x20
000B4360 a0ffbd27 addiu      $sp, $sp, -0x60
000B4364 4c00b3af sw         $s3, 0x4c($sp)
000B4368 0400133c lui        $s3, 4
000B436C 64607326 addiu      $s3, $s3, 0x6064
000B4370 4000b0af sw         $s0, 0x40($sp)
000B4374 4400b1af sw         $s1, 0x44($sp)
000B4378 4800b2af sw         $s2, 0x48($sp)
000B437C 5000bfaf sw         $ra, 0x50($sp)
000B4380 2d00053c lui        $a1, 0x2d
000B4384 25206002 move       $a0, $s3
000B4388 00100634 ori        $a2, $zero, 0x1000
000B438C 25380000 move       $a3, $zero
000B4390 06b0020c jal        0xac018
000B4394 e41aa524 addiu      $a1, $a1, 0x1ae4
000B4398 3000a527 addiu      $a1, $sp, 0x30
000B439C 00608044 mtc1       $zero, $f12
000B43A0 f583020c jal        0xa0fd4
000B43A4 a4010434 ori        $a0, $zero, 0x1a4
000B43A8 3000a48f lw         $a0, 0x30($sp)
000B43AC 3400a68f lw         $a2, 0x34($sp)
000B43B0 002c0400 sll        $a1, $a0, 0x10
000B43B4 3800a48f lw         $a0, 0x38($sp)
000B43B8 3c00a88f lw         $t0, 0x3c($sp)
000B43BC 00340600 sll        $a2, $a2, 0x10
000B43C0 003c0400 sll        $a3, $a0, 0x10
000B43C4 00440800 sll        $t0, $t0, 0x10
000B43C8 032c0500 sra        $a1, $a1, 0x10
000B43CC 03340600 sra        $a2, $a2, 0x10
000B43D0 033c0700 sra        $a3, $a3, 0x10
000B43D4 03440800 sra        $t0, $t0, 0x10
000B43D8 e8b0020c jal        0xac3a0
000B43DC 25206002 move       $a0, $s3

000BC344 2000bd27 addiu      $sp, $sp, 0x20
000BC348 a0ffbd27 addiu      $sp, $sp, -0x60
000BC34C 4400b1af sw         $s1, 0x44($sp)
000BC350 5000b4af sw         $s4, 0x50($sp)
000BC354 0400143c lui        $s4, 4
000BC358 2d00113c lui        $s1, 0x2d
000BC35C f86a9426 addiu      $s4, $s4, 0x6af8
000BC360 7c563126 addiu      $s1, $s1, 0x567c
000BC364 4000b0af sw         $s0, 0x40($sp)
000BC368 4800b2af sw         $s2, 0x48($sp)
000BC36C 4c00b3af sw         $s3, 0x4c($sp)
000BC370 5400bfaf sw         $ra, 0x54($sp)
000BC374 2d00053c lui        $a1, 0x2d
000BC378 25208002 move       $a0, $s4
000BC37C 00100634 ori        $a2, $zero, 0x1000
000BC380 25380000 move       $a3, $zero
000BC384 06b0020c jal        0xac018
000BC388 6846a524 addiu      $a1, $a1, 0x4668
000BC38C 3000a527 addiu      $a1, $sp, 0x30
000BC390 00608044 mtc1       $zero, $f12
000BC394 f583020c jal        0xa0fd4
000BC398 2f020434 ori        $a0, $zero, 0x22f
000BC39C 3000a48f lw         $a0, 0x30($sp)
000BC3A0 3400a68f lw         $a2, 0x34($sp)
000BC3A4 002c0400 sll        $a1, $a0, 0x10
000BC3A8 3800a48f lw         $a0, 0x38($sp)
000BC3AC 3c00a88f lw         $t0, 0x3c($sp)
000BC3B0 00340600 sll        $a2, $a2, 0x10
000BC3B4 003c0400 sll        $a3, $a0, 0x10
000BC3B8 00440800 sll        $t0, $t0, 0x10
000BC3BC 032c0500 sra        $a1, $a1, 0x10
000BC3C0 03340600 sra        $a2, $a2, 0x10
000BC3C4 033c0700 sra        $a3, $a3, 0x10
000BC3C8 03440800 sra        $t0, $t0, 0x10
000BC3CC e8b0020c jal        0xac3a0
000BC3D0 25208002 move       $a0, $s4

000C5160 2000bd27 addiu      $sp, $sp, 0x20
000C5164 a0ffbd27 addiu      $sp, $sp, -0x60
000C5168 4400b1af sw         $s1, 0x44($sp)
000C516C 5000b4af sw         $s4, 0x50($sp)
000C5170 0400143c lui        $s4, 4
000C5174 2e00113c lui        $s1, 0x2e
000C5178 80779426 addiu      $s4, $s4, 0x7780
000C517C 08903126 addiu      $s1, $s1, -0x6ff8
000C5180 4000b0af sw         $s0, 0x40($sp)
000C5184 4800b2af sw         $s2, 0x48($sp)
000C5188 4c00b3af sw         $s3, 0x4c($sp)
000C518C 5400bfaf sw         $ra, 0x54($sp)
000C5190 2e00053c lui        $a1, 0x2e
000C5194 25208002 move       $a0, $s4
000C5198 00100634 ori        $a2, $zero, 0x1000
000C519C 25380000 move       $a3, $zero
000C51A0 06b0020c jal        0xac018
000C51A4 0880a524 addiu      $a1, $a1, -0x7ff8
000C51A8 64000534 ori        $a1, $zero, 0x64
000C51AC 32000634 ori        $a2, $zero, 0x32
000C51B0 3000a5af sw         $a1, 0x30($sp)
000C51B4 7c010734 ori        $a3, $zero, 0x17c
000C51B8 3400a6af sw         $a2, 0x34($sp)
000C51BC de000834 ori        $t0, $zero, 0xde
000C51C0 3800a7af sw         $a3, 0x38($sp)
000C51C4 3c00a8af sw         $t0, 0x3c($sp)
000C51C8 e8b0020c jal        0xac3a0
000C51CC 25208002 move       $a0, $s4
000C51D0 6040053c lui        $a1, 0x4060
000C51D4 b0ff063c lui        $a2, 0xffb0
000C51D8 25208002 move       $a0, $s4
000C51DC 2020a524 addiu      $a1, $a1, 0x2020
000C51E0 98af020c jal        0xabe60
000C51E4 5070c624 addiu      $a2, $a2, 0x7050
000C51E8 00001334 ori        $s3, $zero, 0
000C51EC ffff1024 addiu      $s0, $zero, -1