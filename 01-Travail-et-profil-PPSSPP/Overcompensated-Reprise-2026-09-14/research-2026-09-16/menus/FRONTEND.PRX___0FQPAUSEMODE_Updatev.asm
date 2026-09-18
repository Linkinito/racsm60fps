00017420 d0ffbd27 addiu      $sp, $sp, -0x30
00017424 2000b0af sw         $s0, 0x20($sp)
00017428 1200103c lui        $s0, 0x12
0001742C 2400bfaf sw         $ra, 0x24($sp)
00017430 6310000c jal        0x418c
00017434 00000000 nop        
00017438 e010000c jal        0x4380
0001743C 106b0434 ori        $a0, $zero, 0x6b10
00017440 715e000c jal        0x179c4
00017444 25204000 move       $a0, $v0
00017448 695e000c jal        0x179a4
0001744C 00000000 nop        
00017450 1200043c lui        $a0, 0x12
00017454 8d56000c jal        0x15a34
00017458 6cbb8424 addiu      $a0, $a0, -0x4494
0001745C 1200043c lui        $a0, 0x12
00017460 8d56000c jal        0x15a34
00017464 94bb8424 addiu      $a0, $a0, -0x446c
00017468 5a38000c jal        0xe168
0001746C ffff0424 addiu      $a0, $zero, -1
00017470 5738000c jal        0xe15c
00017474 ffff0424 addiu      $a0, $zero, -1
00017478 25200000 move       $a0, $zero
0001747C 7311000c jal        0x45cc
00017480 25280000 move       $a1, $zero
00017484 5a05000c jal        0x1568
00017488 00000000 nop        
0001748C 58bb058e lw         $a1, -0x44a8($s0)
00017490 0a00a010 beqz       $a1, 0x174bc
00017494 0800043c lui        $a0, 8
00017498 f8f38424 addiu      $a0, $a0, -0xc08
0001749C 0c00848c lw         $a0, 0xc($a0)
000174A0 04008010 beqz       $a0, 0x174b4
000174A4 1200063c lui        $a2, 0x12
000174A8 5cbbc68c lw         $a2, -0x44a4($a2)
000174AC 03008614 bne        $a0, $a2, 0x174bc
000174B0 00000000 nop        
000174B4 ffffa524 addiu      $a1, $a1, -1
000174B8 58bb05ae sw         $a1, -0x44a8($s0)
000174BC 0700a014 bnez       $a1, 0x174dc
000174C0 00000000 nop        
000174C4 20000534 ori        $a1, $zero, 0x20
000174C8 20000634 ori        $a2, $zero, 0x20
000174CC 03000734 ori        $a3, $zero, 3
000174D0 25400000 move       $t0, $zero
000174D4 1e37000c jal        0xdc78
000174D8 00c0043c lui        $a0, 0xc000
000174DC 3b37000c jal        0xdcec
000174E0 00000000 nop        
000174E4 4b37000c jal        0xdd2c
000174E8 00000000 nop        
000174EC 2e5e000c jal        0x178b8
000174F0 00000000 nop        
000174F4 1a00000c jal        0x68
000174F8 00000000 nop        
000174FC 1200043c lui        $a0, 0x12
00017500 54bb80e4 swc1       $f0, -0x44ac($a0)
00017504 2000b08f lw         $s0, 0x20($sp)
00017508 2400bf8f lw         $ra, 0x24($sp)
0001750C 0800e003 jr         $ra
00017510 3000bd27 addiu      $sp, $sp, 0x30