000AC3A0 d0ffbd27 addiu      $sp, $sp, -0x30
000AC3A4 1000b0af sw         $s0, 0x10($sp)
000AC3A8 25808000 move       $s0, $a0
000AC3AC 00240600 sll        $a0, $a2, 0x10
000AC3B0 1400b1af sw         $s1, 0x14($sp)
000AC3B4 038c0400 sra        $s1, $a0, 0x10
000AC3B8 00240800 sll        $a0, $t0, 0x10
000AC3BC 1c00b3af sw         $s3, 0x1c($sp)
000AC3C0 039c0400 sra        $s3, $a0, 0x10
000AC3C4 002c0500 sll        $a1, $a1, 0x10
000AC3C8 540013ae sw         $s3, 0x54($s0)
000AC3CC 032c0500 sra        $a1, $a1, 0x10
000AC3D0 00340700 sll        $a2, $a3, 0x10
000AC3D4 500011ae sw         $s1, 0x50($s0)
000AC3D8 1800b2af sw         $s2, 0x18($sp)
000AC3DC 03940600 sra        $s2, $a2, 0x10
000AC3E0 580005ae sw         $a1, 0x58($s0)
000AC3E4 5c0012ae sw         $s2, 0x5c($s0)
000AC3E8 800011ae sw         $s1, 0x80($s0)
000AC3EC 2000b4af sw         $s4, 0x20($sp)
000AC3F0 2400bfaf sw         $ra, 0x24($sp)
000AC3F4 81b0020c jal        0xac204
000AC3F8 25200002 move       $a0, $s0
000AC3FC 25a04000 move       $s4, $v0
000AC400 81b0020c jal        0xac204
000AC404 25200002 move       $a0, $s0
000AC408 23207102 subu       $a0, $s3, $s1
000AC40C 1a008200 div        $zero, $a0, $v0
000AC410 8c0013ae sw         $s3, 0x8c($s0)
000AC414 880011ae sw         $s1, 0x88($s0)
000AC418 f0ff4426 addiu      $a0, $s2, -0x10
000AC41C 900004ae sw         $a0, 0x90($s0)
000AC420 940012ae sw         $s2, 0x94($s0)
000AC424 02000434 ori        $a0, $zero, 2
000AC428 980004ae sw         $a0, 0x98($s0)
000AC42C 9c0000a2 sb         $zero, 0x9c($s0)
000AC430 03000434 ori        $a0, $zero, 3
000AC434 a00004ae sw         $a0, 0xa0($s0)
000AC438 12200000 mflo       $a0
000AC43C 00000000 nop        
000AC440 00000000 nop        
000AC444 18009400 mult       $a0, $s4
000AC448 12200000 mflo       $a0
000AC44C 21202402 addu       $a0, $s1, $a0
000AC450 01000234 ori        $v0, $zero, 1
000AC454 840004ae sw         $a0, 0x84($s0)
000AC458 1000b08f lw         $s0, 0x10($sp)
000AC45C 1400b18f lw         $s1, 0x14($sp)
000AC460 1800b28f lw         $s2, 0x18($sp)
000AC464 1c00b38f lw         $s3, 0x1c($sp)
000AC468 2000b48f lw         $s4, 0x20($sp)
000AC46C 2400bf8f lw         $ra, 0x24($sp)
000AC470 0800e003 jr         $ra
000AC474 3000bd27 addiu      $sp, $sp, 0x30