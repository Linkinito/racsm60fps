00015F30 c0ffbd27 addiu      $sp, $sp, -0x40
00015F34 2400b0af sw         $s0, 0x24($sp)
00015F38 25808000 move       $s0, $a0
00015F3C 240005ae sw         $a1, 0x24($s0)
00015F40 2120a600 addu       $a0, $a1, $a2
00015F44 280004ae sw         $a0, 0x28($s0)
00015F48 2c0005ae sw         $a1, 0x2c($s0)
00015F4C 300000ae sw         $zero, 0x30($s0)
00015F50 340000ae sw         $zero, 0x34($s0)
00015F54 380000ae sw         $zero, 0x38($s0)
00015F58 2800b1af sw         $s1, 0x28($sp)
00015F5C 080000ae sw         $zero, 8($s0)
00015F60 ffff1124 addiu      $s1, $zero, -1
00015F64 25200002 move       $a0, $s0
00015F68 2000b4e7 swc1       $f20, 0x20($sp)
00015F6C 2c00b2af sw         $s2, 0x2c($sp)
00015F70 3000bfaf sw         $ra, 0x30($sp)
00015F74 a857000c jal        0x15ea0
00015F78 ffff0524 addiu      $a1, $zero, -1
00015F7C 803f053c lui        $a1, 0x3f80
00015F80 00a08544 mtc1       $a1, $f20
00015F84 25200002 move       $a0, $s0
00015F88 06a30046 mov.s      $f12, $f20
00015F8C a057000c jal        0x15e80
00015F90 46a30046 mov.s      $f13, $f20
00015F94 02000434 ori        $a0, $zero, 2
00015F98 480004ae sw         $a0, 0x48($s0)
00015F9C 01001234 ori        $s2, $zero, 1
00015FA0 25200002 move       $a0, $s0
00015FA4 01000534 ori        $a1, $zero, 1
00015FA8 a457000c jal        0x15e90
00015FAC 01000634 ori        $a2, $zero, 1
00015FB0 25200002 move       $a0, $s0
00015FB4 25280000 move       $a1, $zero
00015FB8 25300000 move       $a2, $zero
00015FBC e0010734 ori        $a3, $zero, 0x1e0
00015FC0 aa58000c jal        0x162a8
00015FC4 10010834 ori        $t0, $zero, 0x110
00015FC8 640011ae sw         $s1, 0x64($s0)
00015FCC 680000ae sw         $zero, 0x68($s0)
00015FD0 ffff0424 addiu      $a0, $zero, -1
00015FD4 6c0004ae sw         $a0, 0x6c($s0)
00015FD8 700004ae sw         $a0, 0x70($s0)
00015FDC 0c0014e6 swc1       $f20, 0xc($s0)
00015FE0 100014e6 swc1       $f20, 0x10($s0)
00015FE4 3c0011ae sw         $s1, 0x3c($s0)
00015FE8 0a000434 ori        $a0, $zero, 0xa
00015FEC 140004ae sw         $a0, 0x14($s0)
00015FF0 25104002 move       $v0, $s2
00015FF4 2000b4c7 lwc1       $f20, 0x20($sp)
00015FF8 2400b08f lw         $s0, 0x24($sp)
00015FFC 2800b18f lw         $s1, 0x28($sp)
00016000 2c00b28f lw         $s2, 0x2c($sp)
00016004 3000bf8f lw         $ra, 0x30($sp)
00016008 0800e003 jr         $ra
0001600C 4000bd27 addiu      $sp, $sp, 0x40