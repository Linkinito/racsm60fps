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
000AC054 2c00b2af sw         $s2, 0x2c($sp)
000AC058 3000bfaf sw         $ra, 0x30($sp)
000AC05C dbaf020c jal        0xabf6c
000AC060 ffff0524 addiu      $a1, $zero, -1
000AC064 803f053c lui        $a1, 0x3f80
000AC068 00a08544 mtc1       $a1, $f20
000AC06C 25200002 move       $a0, $s0
000AC070 06a30046 mov.s      $f12, $f20
000AC074 d3af020c jal        0xabf4c
000AC078 46a30046 mov.s      $f13, $f20
000AC07C 02000434 ori        $a0, $zero, 2
000AC080 480004ae sw         $a0, 0x48($s0)
000AC084 01001234 ori        $s2, $zero, 1
000AC088 25200002 move       $a0, $s0
000AC08C 01000534 ori        $a1, $zero, 1
000AC090 d7af020c jal        0xabf5c
000AC094 01000634 ori        $a2, $zero, 1
000AC098 25200002 move       $a0, $s0
000AC09C 25280000 move       $a1, $zero
000AC0A0 25300000 move       $a2, $zero
000AC0A4 e0010734 ori        $a3, $zero, 0x1e0
000AC0A8 e8b0020c jal        0xac3a0
000AC0AC 10010834 ori        $t0, $zero, 0x110
000AC0B0 640011ae sw         $s1, 0x64($s0)
000AC0B4 680000ae sw         $zero, 0x68($s0)
000AC0B8 ffff0424 addiu      $a0, $zero, -1
000AC0BC 6c0004ae sw         $a0, 0x6c($s0)
000AC0C0 700004ae sw         $a0, 0x70($s0)
000AC0C4 0c0014e6 swc1       $f20, 0xc($s0)
000AC0C8 100014e6 swc1       $f20, 0x10($s0)
000AC0CC 3c0011ae sw         $s1, 0x3c($s0)
000AC0D0 0a000434 ori        $a0, $zero, 0xa
000AC0D4 140004ae sw         $a0, 0x14($s0)
000AC0D8 25104002 move       $v0, $s2
000AC0DC 2000b4c7 lwc1       $f20, 0x20($sp)
000AC0E0 2400b08f lw         $s0, 0x24($sp)
000AC0E4 2800b18f lw         $s1, 0x28($sp)
000AC0E8 2c00b28f lw         $s2, 0x2c($sp)
000AC0EC 3000bf8f lw         $ra, 0x30($sp)
000AC0F0 0800e003 jr         $ra
000AC0F4 4000bd27 addiu      $sp, $sp, 0x40