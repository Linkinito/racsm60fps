00016130 c0ffbd27 addiu      $sp, $sp, -0x40
00016134 2400b0af sw         $s0, 0x24($sp)
00016138 25808000 move       $s0, $a0
0001613C 240005ae sw         $a1, 0x24($s0)
00016140 2120a600 addu       $a0, $a1, $a2
00016144 280004ae sw         $a0, 0x28($s0)
00016148 2c0005ae sw         $a1, 0x2c($s0)
0001614C 300000ae sw         $zero, 0x30($s0)
00016150 340000ae sw         $zero, 0x34($s0)
00016154 380000ae sw         $zero, 0x38($s0)
00016158 2800b1af sw         $s1, 0x28($sp)
0001615C 080000ae sw         $zero, 8($s0)
00016160 ffff1124 addiu      $s1, $zero, -1
00016164 25200002 move       $a0, $s0
00016168 2000b4e7 swc1       $f20, 0x20($sp)
0001616C 2c00b2af sw         $s2, 0x2c($sp)
00016170 3000bfaf sw         $ra, 0x30($sp)
00016174 2858000c jal        0x160a0
00016178 ffff0524 addiu      $a1, $zero, -1
0001617C 803f053c lui        $a1, 0x3f80
00016180 00a08544 mtc1       $a1, $f20
00016184 25200002 move       $a0, $s0
00016188 06a30046 mov.s      $f12, $f20
0001618C 2058000c jal        0x16080
00016190 46a30046 mov.s      $f13, $f20
00016194 02000434 ori        $a0, $zero, 2
00016198 480004ae sw         $a0, 0x48($s0)
0001619C 01001234 ori        $s2, $zero, 1
000161A0 25200002 move       $a0, $s0
000161A4 01000534 ori        $a1, $zero, 1
000161A8 2458000c jal        0x16090
000161AC 01000634 ori        $a2, $zero, 1
000161B0 25200002 move       $a0, $s0
000161B4 25280000 move       $a1, $zero
000161B8 25300000 move       $a2, $zero
000161BC e0010734 ori        $a3, $zero, 0x1e0
000161C0 2a59000c jal        0x164a8
000161C4 10010834 ori        $t0, $zero, 0x110
000161C8 640011ae sw         $s1, 0x64($s0)
000161CC 680000ae sw         $zero, 0x68($s0)
000161D0 ffff0424 addiu      $a0, $zero, -1
000161D4 6c0004ae sw         $a0, 0x6c($s0)
000161D8 700004ae sw         $a0, 0x70($s0)
000161DC 0c0014e6 swc1       $f20, 0xc($s0)
000161E0 100014e6 swc1       $f20, 0x10($s0)
000161E4 3c0011ae sw         $s1, 0x3c($s0)
000161E8 0a000434 ori        $a0, $zero, 0xa
000161EC 140004ae sw         $a0, 0x14($s0)
000161F0 25104002 move       $v0, $s2
000161F4 2000b4c7 lwc1       $f20, 0x20($sp)
000161F8 2400b08f lw         $s0, 0x24($sp)
000161FC 2800b18f lw         $s1, 0x28($sp)
00016200 2c00b28f lw         $s2, 0x2c($sp)
00016204 3000bf8f lw         $ra, 0x30($sp)
00016208 0800e003 jr         $ra
0001620C 4000bd27 addiu      $sp, $sp, 0x40