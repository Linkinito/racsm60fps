
CALLBACK 0x0017545C end 0x00175504 ordinal 0

0017545C 27BDFFD0 addiu      $sp, $sp, -0x30
00175460 AFB00020 sw         $s0, 0x20($sp)
00175464 00808025 move       $s0, $a0
00175468 3C040005 lui        $a0, 5
0017546C AFBF0024 sw         $ra, 0x24($sp)
00175470 0C017685 jal        0x5da14
00175474 248464C4 addiu      $a0, $a0, 0x64c4
00175478 8E040048 lw         $a0, 0x48($s0)
0017547C 3C050017 lui        $a1, 0x17
00175480 24A55674 addiu      $a1, $a1, 0x5674
00175484 AC8500DC sw         $a1, 0xdc($a0)
00175488 3C04002D lui        $a0, 0x2d
0017548C 24847AA4 addiu      $a0, $a0, 0x7aa4
00175490 8C86000C lw         $a2, 0xc($a0)
00175494 2405FFFF addiu      $a1, $zero, -1
00175498 54C50006 bnel       $a2, $a1, 0x1754b4
0017549C 8E040058 lw         $a0, 0x58($s0)
001754A0 3C050009 lui        $a1, 9
001754A4 24A5CF10 addiu      $a1, $a1, -0x30f0
001754A8 8CA5006C lw         $a1, 0x6c($a1)
001754AC AC85000C sw         $a1, 0xc($a0)
001754B0 8E040058 lw         $a0, 0x58($s0)
001754B4 3C05002D lui        $a1, 0x2d
001754B8 AC80000C sw         $zero, 0xc($a0)
001754BC 3C04002B lui        $a0, 0x2b
001754C0 8C8400C0 lw         $a0, 0xc0($a0)
001754C4 C4AC7AC0 lwc1       $f12, 0x7ac0($a1)
001754C8 3C05002D lui        $a1, 0x2d
001754CC C4AD7AC4 lwc1       $f13, 0x7ac4($a1)
001754D0 3C05002D lui        $a1, 0x2d
001754D4 C4AE7AC8 lwc1       $f14, 0x7ac8($a1)
001754D8 3C05002D lui        $a1, 0x2d
001754DC 3C06002D lui        $a2, 0x2d
001754E0 34070001 ori        $a3, $zero, 1
001754E4 24A57AB4 addiu      $a1, $a1, 0x7ab4
001754E8 0C01707F jal        0x5c1fc
001754EC 24C6A34C addiu      $a2, $a2, -0x5cb4
001754F0 34020001 ori        $v0, $zero, 1
001754F4 8FB00020 lw         $s0, 0x20($sp)
001754F8 8FBF0024 lw         $ra, 0x24($sp)
001754FC 03E00008 jr         $ra
00175500 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x00175504 end 0x0017553C ordinal 1

00175504 27BDFFE0 addiu      $sp, $sp, -0x20
00175508 AFB00010 sw         $s0, 0x10($sp)
0017550C 00808025 move       $s0, $a0
00175510 3C040005 lui        $a0, 5
00175514 AFBF0014 sw         $ra, 0x14($sp)
00175518 0C0176D6 jal        0x5db58
0017551C 248464C4 addiu      $a0, $a0, 0x64c4
00175520 8E040058 lw         $a0, 0x58($s0)
00175524 0C01B1A3 jal        0x6c68c
00175528 8C84000C lw         $a0, 0xc($a0)
0017552C 8FB00010 lw         $s0, 0x10($sp)
00175530 8FBF0014 lw         $ra, 0x14($sp)
00175534 03E00008 jr         $ra
00175538 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0017553C end 0x00175674 ordinal 2

0017553C 27BDFFC0 addiu      $sp, $sp, -0x40
00175540 AFB00028 sw         $s0, 0x28($sp)
00175544 00808025 move       $s0, $a0
00175548 AFB1002C sw         $s1, 0x2c($sp)
0017554C 8E110058 lw         $s1, 0x58($s0)
00175550 AFBF0030 sw         $ra, 0x30($sp)
00175554 0C00C4DA jal        0x31368
00175558 27A40020 addiu      $a0, $sp, 0x20
0017555C 92040046 lbu        $a0, 0x46($s0)
00175560 34050001 ori        $a1, $zero, 1
00175564 14850028 bne        $a0, $a1, 0x175608
00175568 00000000 nop        
0017556C 0C01D56F jal        0x755bc
00175570 34040002 ori        $a0, $zero, 2
00175574 3C04002D lui        $a0, 0x2d
00175578 24877AD0 addiu      $a3, $a0, 0x7ad0
0017557C 02202025 move       $a0, $s1
00175580 00403025 move       $a2, $v0
00175584 34050000 ori        $a1, $zero, 0
00175588 00E08825 move       $s1, $a3
0017558C 94870004 lhu        $a3, 4($a0)
00175590 9628000C lhu        $t0, 0xc($s1)
00175594 00E83821 addu       $a3, $a3, $t0
00175598 A4870004 sh         $a3, 4($a0)
0017559C 94870004 lhu        $a3, 4($a0)
001755A0 28E80801 slti       $t0, $a3, 0x801
001755A4 15000003 bnez       $t0, 0x1755b4
001755A8 00000000 nop        
001755AC 24E7F800 addiu      $a3, $a3, -0x800
001755B0 A4870004 sh         $a3, 4($a0)
001755B4 24A50001 addiu      $a1, $a1, 1
001755B8 24840002 addiu      $a0, $a0, 2
001755BC 2CA70004 sltiu      $a3, $a1, 4
001755C0 14E0FFF2 bnez       $a3, 0x17558c
001755C4 26310010 addiu      $s1, $s1, 0x10
001755C8 8CC40004 lw         $a0, 4($a2)
001755CC 30842000 andi       $a0, $a0, 0x2000
001755D0 1480000B bnez       $a0, 0x175600
001755D4 00000000 nop        
001755D8 A2000045 sb         $zero, 0x45($s0)
001755DC 44806800 mtc1       $zero, $f13
001755E0 A2000046 sb         $zero, 0x46($s0)
001755E4 3C08002D lui        $t0, 0x2d
001755E8 02002025 move       $a0, $s0
001755EC 00002825 move       $a1, $zero
001755F0 00003025 move       $a2, $zero
001755F4 34070001 ori        $a3, $zero, 1
001755F8 0C01AB54 jal        0x6ad50
001755FC C50C7A98 lwc1       $f12, 0x7a98($t0)
00175600 10000017 b          0x175660
00175604 00000000 nop        
00175608 8FA40020 lw         $a0, 0x20($sp)
0017560C 30840020 andi       $a0, $a0, 0x20
00175610 10800013 beqz       $a0, 0x175660
00175614 00000000 nop        
00175618 0C01D56F jal        0x755bc
0017561C 34040002 ori        $a0, $zero, 2
00175620 8C440004 lw         $a0, 4($v0)
00175624 30842000 andi       $a0, $a0, 0x2000
00175628 1080000D beqz       $a0, 0x175660
0017562C 00000000 nop        
00175630 34040001 ori        $a0, $zero, 1
00175634 44806800 mtc1       $zero, $f13
00175638 A2040046 sb         $a0, 0x46($s0)
0017563C 34040004 ori        $a0, $zero, 4
00175640 A2040045 sb         $a0, 0x45($s0)
00175644 3C08002D lui        $t0, 0x2d
00175648 02002025 move       $a0, $s0
0017564C 34050003 ori        $a1, $zero, 3
00175650 00003025 move       $a2, $zero
00175654 34070001 ori        $a3, $zero, 1
00175658 0C01AB54 jal        0x6ad50
0017565C C50C7A98 lwc1       $f12, 0x7a98($t0)
00175660 8FB00028 lw         $s0, 0x28($sp)
00175664 8FB1002C lw         $s1, 0x2c($sp)
00175668 8FBF0030 lw         $ra, 0x30($sp)
0017566C 03E00008 jr         $ra
00175670 27BD0040 addiu      $sp, $sp, 0x40