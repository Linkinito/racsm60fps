
CALLBACK 0x0014B4D0 end 0x0014B900 ordinal 0

0014B4D0 27BDFF70 addiu      $sp, $sp, -0x90
0014B4D4 3C06002A lui        $a2, 0x2a
0014B4D8 8CC6BD20 lw         $a2, -0x42e0($a2)
0014B4DC 34050009 ori        $a1, $zero, 9
0014B4E0 E7B40050 swc1       $f20, 0x50($sp)
0014B4E4 E7B60054 swc1       $f22, 0x54($sp)
0014B4E8 E7B80058 swc1       $f24, 0x58($sp)
0014B4EC AFB0005C sw         $s0, 0x5c($sp)
0014B4F0 AFB10060 sw         $s1, 0x60($sp)
0014B4F4 AFB20064 sw         $s2, 0x64($sp)
0014B4F8 AFB30068 sw         $s3, 0x68($sp)
0014B4FC AFB4006C sw         $s4, 0x6c($sp)
0014B500 AFB50070 sw         $s5, 0x70($sp)
0014B504 AFB60074 sw         $s6, 0x74($sp)
0014B508 AFB70078 sw         $s7, 0x78($sp)
0014B50C AFBE007C sw         $fp, 0x7c($sp)
0014B510 AFBF0080 sw         $ra, 0x80($sp)
0014B514 14C5000A bne        $a2, $a1, 0x14b540
0014B518 00808025 move       $s0, $a0
0014B51C 3C040009 lui        $a0, 9
0014B520 2484C9A8 addiu      $a0, $a0, -0x3658
0014B524 9085000D lbu        $a1, 0xd($a0)
0014B528 18A00005 blez       $a1, 0x14b540
0014B52C 28A50040 slti       $a1, $a1, 0x40
0014B530 10A00003 beqz       $a1, 0x14b540
0014B534 00000000 nop        
0014B538 34050080 ori        $a1, $zero, 0x80
0014B53C A085000D sb         $a1, 0xd($a0)
0014B540 8E110058 lw         $s1, 0x58($s0)
0014B544 3C040028 lui        $a0, 0x28
0014B548 AE200000 sw         $zero, ($s1)
0014B54C AE201080 sw         $zero, 0x1080($s1)
0014B550 8C85F8D8 lw         $a1, -0x728($a0)
0014B554 34040007 ori        $a0, $zero, 7
0014B558 0C007541 jal        0x1d504
0014B55C 8CA500F0 lw         $a1, 0xf0($a1)
0014B560 00409025 move       $s2, $v0
0014B564 8E440040 lw         $a0, 0x40($s2)
0014B568 14800008 bnez       $a0, 0x14b58c
0014B56C 00000000 nop        
0014B570 3C04001A lui        $a0, 0x1a
0014B574 2405FFC3 addiu      $a1, $zero, -0x3d
0014B578 2406FFFF addiu      $a2, $zero, -1
0014B57C 0C0274C7 jal        0x9d31c
0014B580 248497C8 addiu      $a0, $a0, -0x6838
0014B584 100000CF b          0x14b8c4
0014B588 00001025 move       $v0, $zero
0014B58C 26240004 addiu      $a0, $s1, 4
0014B590 00002825 move       $a1, $zero
0014B594 0C0600AC jal        0x1802b0
0014B598 340600A0 ori        $a2, $zero, 0xa0
0014B59C 3C044049 lui        $a0, 0x4049
0014B5A0 4480C000 mtc1       $zero, $f24
0014B5A4 34840FDB ori        $a0, $a0, 0xfdb
0014B5A8 4484A000 mtc1       $a0, $f20
0014B5AC 3C16002A lui        $s6, 0x2a
0014B5B0 3C043000 lui        $a0, 0x3000
0014B5B4 34130000 ori        $s3, $zero, 0
0014B5B8 4484B000 mtc1       $a0, $f22
0014B5BC 26340004 addiu      $s4, $s1, 4
0014B5C0 0220B825 move       $s7, $s1
0014B5C4 341E0001 ori        $fp, $zero, 1
0014B5C8 26D636B0 addiu      $s6, $s6, 0x36b0
0014B5CC 3C15002A lui        $s5, 0x2a
0014B5D0 8EA53648 lw         $a1, 0x3648($s5)
0014B5D4 02802025 move       $a0, $s4
0014B5D8 0C03204D jal        0xc8134
0014B5DC 02C03025 move       $a2, $s6
0014B5E0 0C060057 jal        0x18015c
0014B5E4 00000000 nop        
0014B5E8 44826000 mtc1       $v0, $f12
0014B5EC 46806320 cvt.s.w    $f12, $f12
0014B5F0 46166302 mul.s      $f12, $f12, $f22
0014B5F4 46146302 mul.s      $f12, $f12, $f20
0014B5F8 0C060057 jal        0x18015c
0014B5FC E6EC00A4 swc1       $f12, 0xa4($s7)
0014B600 44826000 mtc1       $v0, $f12
0014B604 46806320 cvt.s.w    $f12, $f12
0014B608 46166302 mul.s      $f12, $f12, $f22
0014B60C 46146302 mul.s      $f12, $f12, $f20
0014B610 0C060057 jal        0x18015c
0014B614 E6EC00B4 swc1       $f12, 0xb4($s7)
0014B618 44826000 mtc1       $v0, $f12
0014B61C 46806320 cvt.s.w    $f12, $f12
0014B620 46166302 mul.s      $f12, $f12, $f22
0014B624 46146302 mul.s      $f12, $f12, $f20
0014B628 0C060057 jal        0x18015c
0014B62C E6EC00C4 swc1       $f12, 0xc4($s7)
0014B630 44826000 mtc1       $v0, $f12
0014B634 46806320 cvt.s.w    $f12, $f12
0014B638 46166302 mul.s      $f12, $f12, $f22
0014B63C 46146302 mul.s      $f12, $f12, $f20
0014B640 0C060057 jal        0x18015c
0014B644 E6EC00D4 swc1       $f12, 0xd4($s7)
0014B648 44826000 mtc1       $v0, $f12
0014B64C 46806320 cvt.s.w    $f12, $f12
0014B650 46166302 mul.s      $f12, $f12, $f22
0014B654 46146302 mul.s      $f12, $f12, $f20
0014B658 0C060057 jal        0x18015c
0014B65C E6EC00E4 swc1       $f12, 0xe4($s7)
0014B660 44826000 mtc1       $v0, $f12
0014B664 46806320 cvt.s.w    $f12, $f12
0014B668 26730001 addiu      $s3, $s3, 1
0014B66C 26940028 addiu      $s4, $s4, 0x28
0014B670 2E640004 sltiu      $a0, $s3, 4
0014B674 46166302 mul.s      $f12, $f12, $f22
0014B678 46146302 mul.s      $f12, $f12, $f20
0014B67C E6EC00F4 swc1       $f12, 0xf4($s7)
0014B680 1480FFD3 bnez       $a0, 0x14b5d0
0014B684 26F70004 addiu      $s7, $s7, 4
0014B688 8E44003C lw         $a0, 0x3c($s2)
0014B68C 3C05002A lui        $a1, 0x2a
0014B690 AE241078 sw         $a0, 0x1078($s1)
0014B694 00042080 sll        $a0, $a0, 2
0014B698 24A536F4 addiu      $a1, $a1, 0x36f4
0014B69C 00852021 addu       $a0, $a0, $a1
0014B6A0 C48C0000 lwc1       $f12, ($a0)
0014B6A4 3C04002A lui        $a0, 0x2a
0014B6A8 E62C1070 swc1       $f12, 0x1070($s1)
0014B6AC 8C8436DC lw         $a0, 0x36dc($a0)
0014B6B0 E6381074 swc1       $f24, 0x1074($s1)
0014B6B4 AE24106C sw         $a0, 0x106c($s1)
0014B6B8 E6381068 swc1       $f24, 0x1068($s1)
0014B6BC 8E24106C lw         $a0, 0x106c($s1)
0014B6C0 8E050064 lw         $a1, 0x64($s0)
0014B6C4 AE04006C sw         $a0, 0x6c($s0)
0014B6C8 34A40020 ori        $a0, $a1, 0x20
0014B6CC AE040064 sw         $a0, 0x64($s0)
0014B6D0 E6180070 swc1       $f24, 0x70($s0)
0014B6D4 A2000045 sb         $zero, 0x45($s0)
0014B6D8 8E440040 lw         $a0, 0x40($s2)
0014B6DC 3C050006 lui        $a1, 6
0014B6E0 2484FFFF addiu      $a0, $a0, -1
0014B6E4 AE440040 sw         $a0, 0x40($s2)
0014B6E8 24A4A8B8 addiu      $a0, $a1, -0x5748
0014B6EC C48C0030 lwc1       $f12, 0x30($a0)
0014B6F0 3C120005 lui        $s2, 5
0014B6F4 E60C0030 swc1       $f12, 0x30($s0)
0014B6F8 C48C0034 lwc1       $f12, 0x34($a0)
0014B6FC E60C0034 swc1       $f12, 0x34($s0)
0014B700 C48C0038 lwc1       $f12, 0x38($a0)
0014B704 E60C0038 swc1       $f12, 0x38($s0)
0014B708 8E5263A0 lw         $s2, 0x63a0($s2)
0014B70C 1240000E beqz       $s2, 0x14b748
0014B710 00000000 nop        
0014B714 C64C0014 lwc1       $f12, 0x14($s2)
0014B718 C64D0018 lwc1       $f13, 0x18($s2)
0014B71C C64E001C lwc1       $f14, 0x1c($s2)
0014B720 2626107C addiu      $a2, $s1, 0x107c
0014B724 C64F0020 lwc1       $f15, 0x20($s2)
0014B728 34070000 ori        $a3, $zero, 0
0014B72C 34090000 ori        $t1, $zero, 0
0014B730 340A0000 ori        $t2, $zero, 0
0014B734 02002025 move       $a0, $s0
0014B738 02402825 move       $a1, $s2
0014B73C 00004025 move       $t0, $zero
0014B740 0C019B4F jal        0x66d3c
0014B744 03C05825 move       $t3, $fp
0014B748 3C040005 lui        $a0, 5
0014B74C 8C8463A4 lw         $a0, 0x63a4($a0)
0014B750 1080000D beqz       $a0, 0x14b788
0014B754 00802825 move       $a1, $a0
0014B758 C4AC0014 lwc1       $f12, 0x14($a1)
0014B75C C4AD0018 lwc1       $f13, 0x18($a1)
0014B760 C4AE001C lwc1       $f14, 0x1c($a1)
0014B764 C4AF0020 lwc1       $f15, 0x20($a1)
0014B768 34070000 ori        $a3, $zero, 0
0014B76C 34090000 ori        $t1, $zero, 0
0014B770 340A0000 ori        $t2, $zero, 0
0014B774 02002025 move       $a0, $s0
0014B778 00003025 move       $a2, $zero
0014B77C 00004025 move       $t0, $zero
0014B780 0C019B4F jal        0x66d3c
0014B784 03C05825 move       $t3, $fp
0014B788 92040044 lbu        $a0, 0x44($s0)
0014B78C 8E050040 lw         $a1, 0x40($s0)
0014B790 00043100 sll        $a2, $a0, 4
0014B794 00862021 addu       $a0, $a0, $a2
0014B798 8CA50004 lw         $a1, 4($a1)
0014B79C 00042080 sll        $a0, $a0, 2
0014B7A0 00862023 subu       $a0, $a0, $a2
0014B7A4 00A42021 addu       $a0, $a1, $a0
0014B7A8 8C840004 lw         $a0, 4($a0)
0014B7AC 3C051000 lui        $a1, 0x1000
0014B7B0 8C840004 lw         $a0, 4($a0)
0014B7B4 24A50006 addiu      $a1, $a1, 6
0014B7B8 10850003 beq        $a0, $a1, 0x14b7c8
0014B7BC 00000000 nop        
0014B7C0 10000040 b          0x14b8c4
0014B7C4 03C01025 move       $v0, $fp
0014B7C8 3C044F80 lui        $a0, 0x4f80
0014B7CC 4484A000 mtc1       $a0, $f20
0014B7D0 3C130005 lui        $s3, 5
0014B7D4 3C044300 lui        $a0, 0x4300
0014B7D8 34120000 ori        $s2, $zero, 0
0014B7DC 4484B000 mtc1       $a0, $f22
0014B7E0 26735F9C addiu      $s3, $s3, 0x5f9c
0014B7E4 44926000 mtc1       $s2, $f12
0014B7E8 46806320 cvt.s.w    $f12, $f12
0014B7EC 06420001 bltzl      $s2, 0x14b7f4
0014B7F0 46146300 add.s      $f12, $f12, $f20
0014B7F4 460CB301 sub.s      $f12, $f22, $f12
0014B7F8 4600630D trunc.w.s  $f12, $f12
0014B7FC 0C05FC0E jal        0x17f038
0014B800 44046000 mfc1       $a0, $f12
0014B804 2444007F addiu      $a0, $v0, 0x7f
0014B808 308500FF andi       $a1, $a0, 0xff
0014B80C 308600FF andi       $a2, $a0, 0xff
0014B810 00052E00 sll        $a1, $a1, 0x18
0014B814 00063200 sll        $a2, $a2, 8
0014B818 308700FF andi       $a3, $a0, 0xff
0014B81C 00A62825 or         $a1, $a1, $a2
0014B820 00073400 sll        $a2, $a3, 0x10
0014B824 00A62825 or         $a1, $a1, $a2
0014B828 308400FF andi       $a0, $a0, 0xff
0014B82C 00A42025 or         $a0, $a1, $a0
0014B830 AE640000 sw         $a0, ($s3)
0014B834 26520001 addiu      $s2, $s2, 1
0014B838 2E440100 sltiu      $a0, $s2, 0x100
0014B83C 1480FFE9 bnez       $a0, 0x14b7e4
0014B840 26730004 addiu      $s3, $s3, 4
0014B844 E7B80030 swc1       $f24, 0x30($sp)
0014B848 3C04BF80 lui        $a0, 0xbf80
0014B84C 44846000 mtc1       $a0, $f12
0014B850 E7B80038 swc1       $f24, 0x38($sp)
0014B854 E7AC0034 swc1       $f12, 0x34($sp)
0014B858 E7B8003C swc1       $f24, 0x3c($sp)
0014B85C 27A50030 addiu      $a1, $sp, 0x30
0014B860 0C052BFF jal        0x14affc
0014B864 02002025 move       $a0, $s0
0014B868 3C04002A lui        $a0, 0x2a
0014B86C AC823638 sw         $v0, 0x3638($a0)
0014B870 E7B80040 swc1       $f24, 0x40($sp)
0014B874 3C043F80 lui        $a0, 0x3f80
0014B878 44846000 mtc1       $a0, $f12
0014B87C E7B80048 swc1       $f24, 0x48($sp)
0014B880 E7AC0044 swc1       $f12, 0x44($sp)
0014B884 E7B8004C swc1       $f24, 0x4c($sp)
0014B888 27A50040 addiu      $a1, $sp, 0x40
0014B88C 0C052BFF jal        0x14affc
0014B890 02002025 move       $a0, $s0
0014B894 3C04002A lui        $a0, 0x2a
0014B898 AC82363C sw         $v0, 0x363c($a0)
0014B89C 26240108 addiu      $a0, $s1, 0x108
0014B8A0 00002825 move       $a1, $zero
0014B8A4 0C0600AC jal        0x1802b0
0014B8A8 340607B0 ori        $a2, $zero, 0x7b0
0014B8AC 262408B8 addiu      $a0, $s1, 0x8b8
0014B8B0 00002825 move       $a1, $zero
0014B8B4 0C0600AC jal        0x1802b0
0014B8B8 340607B0 ori        $a2, $zero, 0x7b0
0014B8BC AE200104 sw         $zero, 0x104($s1)
0014B8C0 03C01025 move       $v0, $fp
0014B8C4 C7B40050 lwc1       $f20, 0x50($sp)
0014B8C8 C7B60054 lwc1       $f22, 0x54($sp)
0014B8CC C7B80058 lwc1       $f24, 0x58($sp)
0014B8D0 8FB0005C lw         $s0, 0x5c($sp)
0014B8D4 8FB10060 lw         $s1, 0x60($sp)
0014B8D8 8FB20064 lw         $s2, 0x64($sp)
0014B8DC 8FB30068 lw         $s3, 0x68($sp)
0014B8E0 8FB4006C lw         $s4, 0x6c($sp)
0014B8E4 8FB50070 lw         $s5, 0x70($sp)
0014B8E8 8FB60074 lw         $s6, 0x74($sp)
0014B8EC 8FB70078 lw         $s7, 0x78($sp)
0014B8F0 8FBE007C lw         $fp, 0x7c($sp)
0014B8F4 8FBF0080 lw         $ra, 0x80($sp)
0014B8F8 03E00008 jr         $ra
0014B8FC 27BD0090 addiu      $sp, $sp, 0x90

CALLBACK 0x0014AB90 end 0x0014AE0C ordinal 1

0014AB90 27BDFF60 addiu      $sp, $sp, -0xa0
0014AB94 AFB10070 sw         $s1, 0x70($sp)
0014AB98 00808825 move       $s1, $a0
0014AB9C E7B40054 swc1       $f20, 0x54($sp)
0014ABA0 E7B60058 swc1       $f22, 0x58($sp)
0014ABA4 E7B8005C swc1       $f24, 0x5c($sp)
0014ABA8 E7BA0060 swc1       $f26, 0x60($sp)
0014ABAC E7BC0064 swc1       $f28, 0x64($sp)
0014ABB0 E7BE0068 swc1       $f30, 0x68($sp)
0014ABB4 AFB0006C sw         $s0, 0x6c($sp)
0014ABB8 AFB20074 sw         $s2, 0x74($sp)
0014ABBC AFB30078 sw         $s3, 0x78($sp)
0014ABC0 AFB4007C sw         $s4, 0x7c($sp)
0014ABC4 AFB50080 sw         $s5, 0x80($sp)
0014ABC8 AFB60084 sw         $s6, 0x84($sp)
0014ABCC AFB70088 sw         $s7, 0x88($sp)
0014ABD0 AFBE008C sw         $fp, 0x8c($sp)
0014ABD4 AFBF0090 sw         $ra, 0x90($sp)
0014ABD8 8E240058 lw         $a0, 0x58($s1)
0014ABDC 4480E000 mtc1       $zero, $f28
0014ABE0 AFA40048 sw         $a0, 0x48($sp)
0014ABE4 3C043149 lui        $a0, 0x3149
0014ABE8 34840FDB ori        $a0, $a0, 0xfdb
0014ABEC 4484C000 mtc1       $a0, $f24
0014ABF0 3C044049 lui        $a0, 0x4049
0014ABF4 34840FDB ori        $a0, $a0, 0xfdb
0014ABF8 4484D000 mtc1       $a0, $f26
0014ABFC 34100000 ori        $s0, $zero, 0
0014AC00 3C043080 lui        $a0, 0x3080
0014AC04 4484A000 mtc1       $a0, $f20
0014AC08 27BE0030 addiu      $fp, $sp, 0x30
0014AC0C 3C043F80 lui        $a0, 0x3f80
0014AC10 4484B000 mtc1       $a0, $f22
0014AC14 27B7003C addiu      $s7, $sp, 0x3c
0014AC18 3C043000 lui        $a0, 0x3000
0014AC1C 4484F000 mtc1       $a0, $f30
0014AC20 3C13002A lui        $s3, 0x2a
0014AC24 3C12002A lui        $s2, 0x2a
0014AC28 3C16002A lui        $s6, 0x2a
0014AC2C 3C15002A lui        $s5, 0x2a
0014AC30 3C14002A lui        $s4, 0x2a
0014AC34 0C060057 jal        0x18015c
0014AC38 E7BE004C swc1       $f30, 0x4c($sp)
0014AC3C 44826000 mtc1       $v0, $f12
0014AC40 46806320 cvt.s.w    $f12, $f12
0014AC44 46146302 mul.s      $f12, $f12, $f20
0014AC48 46166301 sub.s      $f12, $f12, $f22
0014AC4C 0C060057 jal        0x18015c
0014AC50 E7AC0044 swc1       $f12, 0x44($sp)
0014AC54 44826000 mtc1       $v0, $f12
0014AC58 46806320 cvt.s.w    $f12, $f12
0014AC5C 46186302 mul.s      $f12, $f12, $f24
0014AC60 461A6781 sub.s      $f30, $f12, $f26
0014AC64 0C0620CD jal        0x188334
0014AC68 4600F306 mov.s      $f12, $f30
0014AC6C 46000306 mov.s      $f12, $f0
0014AC70 460C6342 mul.s      $f13, $f12, $f12
0014AC74 461CF03C c.lt.s     $f30, $f28
0014AC78 C7BE004C lwc1       $f30, 0x4c($sp)
0014AC7C 460DB341 sub.s      $f13, $f22, $f13
0014AC80 46006B44 sqrt.s     $f13, $f13
0014AC84 45030001 bc1tl      0x14ac8c
0014AC88 46006B47 neg.s      $f13, $f13
0014AC8C E7B80050 swc1       $f24, 0x50($sp)
0014AC90 E7BA004C swc1       $f26, 0x4c($sp)
0014AC94 C7AE0044 lwc1       $f14, 0x44($sp)
0014AC98 460E73C2 mul.s      $f15, $f14, $f14
0014AC9C C6300030 lwc1       $f16, 0x30($s1)
0014ACA0 C6310034 lwc1       $f17, 0x34($s1)
0014ACA4 C6320038 lwc1       $f18, 0x38($s1)
0014ACA8 460FB3C1 sub.s      $f15, $f22, $f15
0014ACAC C6733718 lwc1       $f19, 0x3718($s3)
0014ACB0 3C04002A lui        $a0, 0x2a
0014ACB4 46127380 add.s      $f14, $f14, $f18
0014ACB8 C480371C lwc1       $f0, 0x371c($a0)
0014ACBC 46007BC4 sqrt.s     $f15, $f15
0014ACC0 460F6302 mul.s      $f12, $f12, $f15
0014ACC4 460F6B42 mul.s      $f13, $f13, $f15
0014ACC8 46130681 sub.s      $f26, $f0, $f19
0014ACCC 46106400 add.s      $f16, $f12, $f16
0014ACD0 E7AC003C swc1       $f12, 0x3c($sp)
0014ACD4 E7AD0040 swc1       $f13, 0x40($sp)
0014ACD8 E7AE0038 swc1       $f14, 0x38($sp)
0014ACDC 46116B00 add.s      $f12, $f13, $f17
0014ACE0 E7B00030 swc1       $f16, 0x30($sp)
0014ACE4 0C060057 jal        0x18015c
0014ACE8 E7AC0034 swc1       $f12, 0x34($sp)
0014ACEC 44826000 mtc1       $v0, $f12
0014ACF0 46806320 cvt.s.w    $f12, $f12
0014ACF4 C66D3718 lwc1       $f13, 0x3718($s3)
0014ACF8 C64E3724 lwc1       $f14, 0x3724($s2)
0014ACFC 3C04002A lui        $a0, 0x2a
0014AD00 C48F3728 lwc1       $f15, 0x3728($a0)
0014AD04 461E6302 mul.s      $f12, $f12, $f30
0014AD08 460E7E01 sub.s      $f24, $f15, $f14
0014AD0C 461A6302 mul.s      $f12, $f12, $f26
0014AD10 0C060057 jal        0x18015c
0014AD14 460C6E80 add.s      $f26, $f13, $f12
0014AD18 44828000 mtc1       $v0, $f16
0014AD1C C64F3724 lwc1       $f15, 0x3724($s2)
0014AD20 46808420 cvt.s.w    $f16, $f16
0014AD24 8FA40048 lw         $a0, 0x48($sp)
0014AD28 C6CE3720 lwc1       $f14, 0x3720($s6)
0014AD2C 4600D306 mov.s      $f12, $f26
0014AD30 03C02825 move       $a1, $fp
0014AD34 461E8342 mul.s      $f13, $f16, $f30
0014AD38 02E03025 move       $a2, $s7
0014AD3C 00004025 move       $t0, $zero
0014AD40 00004825 move       $t1, $zero
0014AD44 46186C82 mul.s      $f18, $f13, $f24
0014AD48 C6B03730 lwc1       $f16, 0x3730($s5)
0014AD4C 8C87106C lw         $a3, 0x106c($a0)
0014AD50 C691372C lwc1       $f17, 0x372c($s4)
0014AD54 3C04002A lui        $a0, 0x2a
0014AD58 8C843750 lw         $a0, 0x3750($a0)
0014AD5C 4600E346 mov.s      $f13, $f28
0014AD60 0C030DDB jal        0xc376c
0014AD64 46127BC0 add.s      $f15, $f15, $f18
0014AD68 26100001 addiu      $s0, $s0, 1
0014AD6C C7BA004C lwc1       $f26, 0x4c($sp)
0014AD70 2E040064 sltiu      $a0, $s0, 0x64
0014AD74 1480FFAF bnez       $a0, 0x14ac34
0014AD78 C7B80050 lwc1       $f24, 0x50($sp)
0014AD7C 0C00AAAC jal        0x2aab0
0014AD80 00000000 nop        
0014AD84 8FB20048 lw         $s2, 0x48($sp)
0014AD88 34100000 ori        $s0, $zero, 0
0014AD8C 26510004 addiu      $s1, $s2, 4
0014AD90 0C021698 jal        0x85a60
0014AD94 02202025 move       $a0, $s1
0014AD98 26100001 addiu      $s0, $s0, 1
0014AD9C 2E040004 sltiu      $a0, $s0, 4
0014ADA0 1480FFFB bnez       $a0, 0x14ad90
0014ADA4 26310028 addiu      $s1, $s1, 0x28
0014ADA8 8E44107C lw         $a0, 0x107c($s2)
0014ADAC 10800005 beqz       $a0, 0x14adc4
0014ADB0 00000000 nop        
0014ADB4 0C019BAB jal        0x66eac
0014ADB8 AFB20048 sw         $s2, 0x48($sp)
0014ADBC 8FA40048 lw         $a0, 0x48($sp)
0014ADC0 AC80107C sw         $zero, 0x107c($a0)
0014ADC4 C7B40054 lwc1       $f20, 0x54($sp)
0014ADC8 C7B60058 lwc1       $f22, 0x58($sp)
0014ADCC C7B8005C lwc1       $f24, 0x5c($sp)
0014ADD0 C7BA0060 lwc1       $f26, 0x60($sp)
0014ADD4 C7BC0064 lwc1       $f28, 0x64($sp)
0014ADD8 C7BE0068 lwc1       $f30, 0x68($sp)
0014ADDC 8FB0006C lw         $s0, 0x6c($sp)
0014ADE0 8FB10070 lw         $s1, 0x70($sp)
0014ADE4 8FB20074 lw         $s2, 0x74($sp)
0014ADE8 8FB30078 lw         $s3, 0x78($sp)
0014ADEC 8FB4007C lw         $s4, 0x7c($sp)
0014ADF0 8FB50080 lw         $s5, 0x80($sp)
0014ADF4 8FB60084 lw         $s6, 0x84($sp)
0014ADF8 8FB70088 lw         $s7, 0x88($sp)
0014ADFC 8FBE008C lw         $fp, 0x8c($sp)
0014AE00 8FBF0090 lw         $ra, 0x90($sp)
0014AE04 03E00008 jr         $ra
0014AE08 27BD00A0 addiu      $sp, $sp, 0xa0

CALLBACK 0x0014B900 end 0x0014C104 ordinal 2

0014B900 27BDFF00 addiu      $sp, $sp, -0x100
0014B904 AFB200E0 sw         $s2, 0xe0($sp)
0014B908 00809025 move       $s2, $a0
0014B90C AFB300E4 sw         $s3, 0xe4($sp)
0014B910 8E530058 lw         $s3, 0x58($s2)
0014B914 E7B400CC swc1       $f20, 0xcc($sp)
0014B918 E7B600D0 swc1       $f22, 0xd0($sp)
0014B91C E7B800D4 swc1       $f24, 0xd4($sp)
0014B920 AFB000D8 sw         $s0, 0xd8($sp)
0014B924 AFB100DC sw         $s1, 0xdc($sp)
0014B928 AFB400E8 sw         $s4, 0xe8($sp)
0014B92C AFB500EC sw         $s5, 0xec($sp)
0014B930 AFB600F0 sw         $s6, 0xf0($sp)
0014B934 AFB700F4 sw         $s7, 0xf4($sp)
0014B938 AFBE00F8 sw         $fp, 0xf8($sp)
0014B93C AFBF00FC sw         $ra, 0xfc($sp)
0014B940 0C00A52F jal        0x294bc
0014B944 8E640000 lw         $a0, ($s3)
0014B948 1440000C bnez       $v0, 0x14b97c
0014B94C 00000000 nop        
0014B950 0C01BA8A jal        0x6ea28
0014B954 00000000 nop        
0014B958 34048000 ori        $a0, $zero, 0x8000
0014B95C 10440007 beq        $v0, $a0, 0x14b97c
0014B960 00000000 nop        
0014B964 92440045 lbu        $a0, 0x45($s2)
0014B968 34050001 ori        $a1, $zero, 1
0014B96C 50850008 beql       $a0, $a1, 0x14b990
0014B970 8E641078 lw         $a0, 0x1078($s3)
0014B974 100000C8 b          0x14bc98
0014B978 00000000 nop        
0014B97C 02402025 move       $a0, $s2
0014B980 0C0192FF jal        0x64bfc
0014B984 34050001 ori        $a1, $zero, 1
0014B988 100001CF b          0x14c0c8
0014B98C 00000000 nop        
0014B990 3C05002A lui        $a1, 0x2a
0014B994 00042080 sll        $a0, $a0, 2
0014B998 24A536F4 addiu      $a1, $a1, 0x36f4
0014B99C 00852021 addu       $a0, $a0, $a1
0014B9A0 C66C1070 lwc1       $f12, 0x1070($s3)
0014B9A4 3C05002A lui        $a1, 0x2a
0014B9A8 8CA536E0 lw         $a1, 0x36e0($a1)
0014B9AC C48D0000 lwc1       $f13, ($a0)
0014B9B0 3C04002A lui        $a0, 0x2a
0014B9B4 460D6303 div.s      $f12, $f12, $f13
0014B9B8 8C8636DC lw         $a2, 0x36dc($a0)
0014B9BC 00A02025 move       $a0, $a1
0014B9C0 0C03A359 jal        0xe8d64
0014B9C4 00C02825 move       $a1, $a2
0014B9C8 C66C1068 lwc1       $f12, 0x1068($s3)
0014B9CC AE62106C sw         $v0, 0x106c($s3)
0014B9D0 44807000 mtc1       $zero, $f14
0014B9D4 460E6032 c.eq.s     $f12, $f14
0014B9D8 00000000 nop        
0014B9DC 45010006 bc1t       0x14b9f8
0014B9E0 341E0003 ori        $fp, $zero, 3
0014B9E4 3C04BF80 lui        $a0, 0xbf80
0014B9E8 44846800 mtc1       $a0, $f13
0014B9EC 460D6300 add.s      $f12, $f12, $f13
0014B9F0 1000000E b          0x14ba2c
0014B9F4 E66C1068 swc1       $f12, 0x1068($s3)
0014B9F8 34040007 ori        $a0, $zero, 7
0014B9FC 0C007870 jal        0x1e1c0
0014BA00 2405FFFF addiu      $a1, $zero, -1
0014BA04 28440003 slti       $a0, $v0, 3
0014BA08 14800008 bnez       $a0, 0x14ba2c
0014BA0C 00000000 nop        
0014BA10 0C05373A jal        0x14dce8
0014BA14 02402025 move       $a0, $s2
0014BA18 10400004 beqz       $v0, 0x14ba2c
0014BA1C 00000000 nop        
0014BA20 3C044316 lui        $a0, 0x4316
0014BA24 44846000 mtc1       $a0, $f12
0014BA28 E66C1068 swc1       $f12, 0x1068($s3)
0014BA2C 8E641080 lw         $a0, 0x1080($s3)
0014BA30 10800003 beqz       $a0, 0x14ba40
0014BA34 00000000 nop        
0014BA38 2484FFFF addiu      $a0, $a0, -1
0014BA3C AE641080 sw         $a0, 0x1080($s3)
0014BA40 34040007 ori        $a0, $zero, 7
0014BA44 0C007870 jal        0x1e1c0
0014BA48 2405FFFF addiu      $a1, $zero, -1
0014BA4C 00408025 move       $s0, $v0
0014BA50 2E040001 sltiu      $a0, $s0, 1
0014BA54 1480008E bnez       $a0, 0x14bc90
0014BA58 00000000 nop        
0014BA5C 3C08002A lui        $t0, 0x2a
0014BA60 C50C3758 lwc1       $f12, 0x3758($t0)
0014BA64 27A40040 addiu      $a0, $sp, 0x40
0014BA68 26460030 addiu      $a2, $s2, 0x30
0014BA6C 34050010 ori        $a1, $zero, 0x10
0014BA70 34070169 ori        $a3, $zero, 0x169
0014BA74 34080101 ori        $t0, $zero, 0x101
0014BA78 34090002 ori        $t1, $zero, 2
0014BA7C 0C00555F jal        0x1557c
0014BA80 340A0001 ori        $t2, $zero, 1
0014BA84 0040A025 move       $s4, $v0
0014BA88 34110000 ori        $s1, $zero, 0
0014BA8C 0234202B sltu       $a0, $s1, $s4
0014BA90 10800059 beqz       $a0, 0x14bbf8
0014BA94 34050000 ori        $a1, $zero, 0
0014BA98 3C043480 lui        $a0, 0x3480
0014BA9C 4484A000 mtc1       $a0, $f20
0014BAA0 261700D7 addiu      $s7, $s0, 0xd7
0014BAA4 3C043F80 lui        $a0, 0x3f80
0014BAA8 4484C000 mtc1       $a0, $f24
0014BAAC 3C16002A lui        $s6, 0x2a
0014BAB0 3C043F00 lui        $a0, 0x3f00
0014BAB4 27B50080 addiu      $s5, $sp, 0x80
0014BAB8 4484B000 mtc1       $a0, $f22
0014BABC 03A08025 move       $s0, $sp
0014BAC0 26D6A864 addiu      $s6, $s6, -0x579c
0014BAC4 8E040040 lw         $a0, 0x40($s0)
0014BAC8 8C860040 lw         $a2, 0x40($a0)
0014BACC 10C00046 beqz       $a2, 0x14bbe8
0014BAD0 00000000 nop        
0014BAD4 8CC60020 lw         $a2, 0x20($a2)
0014BAD8 10C00043 beqz       $a2, 0x14bbe8
0014BADC 00000000 nop        
0014BAE0 24850030 addiu      $a1, $a0, 0x30
0014BAE4 C4AC0000 lwc1       $f12, ($a1)
0014BAE8 C64D0030 lwc1       $f13, 0x30($s2)
0014BAEC C64E0034 lwc1       $f14, 0x34($s2)
0014BAF0 460C6B01 sub.s      $f12, $f13, $f12
0014BAF4 C64F0038 lwc1       $f15, 0x38($s2)
0014BAF8 E7AC0080 swc1       $f12, 0x80($sp)
0014BAFC C4AD0004 lwc1       $f13, 4($a1)
0014BB00 460C6402 mul.s      $f16, $f12, $f12
0014BB04 460D7341 sub.s      $f13, $f14, $f13
0014BB08 E7AD0084 swc1       $f13, 0x84($sp)
0014BB0C 460D6C42 mul.s      $f17, $f13, $f13
0014BB10 C4AE0008 lwc1       $f14, 8($a1)
0014BB14 460E7B81 sub.s      $f14, $f15, $f14
0014BB18 461183C0 add.s      $f15, $f16, $f17
0014BB1C 460E7482 mul.s      $f18, $f14, $f14
0014BB20 46127BC0 add.s      $f15, $f15, $f18
0014BB24 4614783C c.lt.s     $f15, $f20
0014BB28 00000000 nop        
0014BB2C 45010009 bc1t       0x14bb54
0014BB30 E7AE0088 swc1       $f14, 0x88($sp)
0014BB34 46007BC4 sqrt.s     $f15, $f15
0014BB38 460FC3C3 div.s      $f15, $f24, $f15
0014BB3C 460F6302 mul.s      $f12, $f12, $f15
0014BB40 460F6B42 mul.s      $f13, $f13, $f15
0014BB44 460F7382 mul.s      $f14, $f14, $f15
0014BB48 E7AC0080 swc1       $f12, 0x80($sp)
0014BB4C E7AD0084 swc1       $f13, 0x84($sp)
0014BB50 E7AE0088 swc1       $f14, 0x88($sp)
0014BB54 00803025 move       $a2, $a0
0014BB58 8CC70040 lw         $a3, 0x40($a2)
0014BB5C 8CE70020 lw         $a3, 0x20($a3)
0014BB60 54E00004 bnel       $a3, $zero, 0x14bb74
0014BB64 00172100 sll        $a0, $s7, 4
0014BB68 2405FFFF addiu      $a1, $zero, -1
0014BB6C 10000017 b          0x14bbcc
0014BB70 8E660000 lw         $a2, ($s3)
0014BB74 00962021 addu       $a0, $a0, $s6
0014BB78 8C880000 lw         $t0, ($a0)
0014BB7C 29090002 slti       $t1, $t0, 2
0014BB80 15200006 bnez       $t1, 0x14bb9c
0014BB84 C48C0004 lwc1       $f12, 4($a0)
0014BB88 29080003 slti       $t0, $t0, 3
0014BB8C 11000003 beqz       $t0, 0x14bb9c
0014BB90 00000000 nop        
0014BB94 10000001 b          0x14bb9c
0014BB98 46166302 mul.s      $f12, $f12, $f22
0014BB9C 00E05025 move       $t2, $a3
0014BBA0 00A03825 move       $a3, $a1
0014BBA4 8C850008 lw         $a1, 8($a0)
0014BBA8 8C89000C lw         $t1, 0xc($a0)
0014BBAC 00C02025 move       $a0, $a2
0014BBB0 01203025 move       $a2, $t1
0014BBB4 02A04025 move       $t0, $s5
0014BBB8 0140F809 jalr       $t2
0014BBBC 02404825 move       $t1, $s2
0014BBC0 8E660000 lw         $a2, ($s3)
0014BBC4 00402825 move       $a1, $v0
0014BBC8 8E040040 lw         $a0, 0x40($s0)
0014BBCC 00804025 move       $t0, $a0
0014BBD0 00A03825 move       $a3, $a1
0014BBD4 00C02025 move       $a0, $a2
0014BBD8 34050007 ori        $a1, $zero, 7
0014BBDC 0C003EC2 jal        0xfb08
0014BBE0 01003025 move       $a2, $t0
0014BBE4 34050001 ori        $a1, $zero, 1
0014BBE8 26310001 addiu      $s1, $s1, 1
0014BBEC 0234202B sltu       $a0, $s1, $s4
0014BBF0 1480FFB4 bnez       $a0, 0x14bac4
0014BBF4 26100004 addiu      $s0, $s0, 4
0014BBF8 8E641080 lw         $a0, 0x1080($s3)
0014BBFC 14800024 bnez       $a0, 0x14bc90
0014BC00 00000000 nop        
0014BC04 10A00022 beqz       $a1, 0x14bc90
0014BC08 00000000 nop        
0014BC0C 0C0001C8 jal        0x720
0014BC10 34040002 ori        $a0, $zero, 2
0014BC14 3C054F00 lui        $a1, 0x4f00
0014BC18 00402025 move       $a0, $v0
0014BC1C 1080000E beqz       $a0, 0x14bc58
0014BC20 4485A000 mtc1       $a1, $f20
0014BC24 00802825 move       $a1, $a0
0014BC28 C4AC0014 lwc1       $f12, 0x14($a1)
0014BC2C C4AD0018 lwc1       $f13, 0x18($a1)
0014BC30 C4AE001C lwc1       $f14, 0x1c($a1)
0014BC34 C4AF0020 lwc1       $f15, 0x20($a1)
0014BC38 34070000 ori        $a3, $zero, 0
0014BC3C 34090000 ori        $t1, $zero, 0
0014BC40 340A0000 ori        $t2, $zero, 0
0014BC44 340B0001 ori        $t3, $zero, 1
0014BC48 02402025 move       $a0, $s2
0014BC4C 00003025 move       $a2, $zero
0014BC50 0C019B4F jal        0x66d3c
0014BC54 00004025 move       $t0, $zero
0014BC58 3C04002A lui        $a0, 0x2a
0014BC5C C48C375C lwc1       $f12, 0x375c($a0)
0014BC60 4614603C c.lt.s     $f12, $f20
0014BC64 00000000 nop        
0014BC68 45020004 bc1fl      0x14bc7c
0014BC6C 46146301 sub.s      $f12, $f12, $f20
0014BC70 4600630D trunc.w.s  $f12, $f12
0014BC74 10000005 b          0x14bc8c
0014BC78 44046000 mfc1       $a0, $f12
0014BC7C 3C048000 lui        $a0, 0x8000
0014BC80 4600630D trunc.w.s  $f12, $f12
0014BC84 44056000 mfc1       $a1, $f12
0014BC88 00A42021 addu       $a0, $a1, $a0
0014BC8C AE641080 sw         $a0, 0x1080($s3)
0014BC90 10000053 b          0x14bde0
0014BC94 00000000 nop        
0014BC98 14800008 bnez       $a0, 0x14bcbc
0014BC9C 00000000 nop        
0014BCA0 8E640000 lw         $a0, ($s3)
0014BCA4 0C00AAA8 jal        0x2aaa0
0014BCA8 02402825 move       $a1, $s2
0014BCAC 34040001 ori        $a0, $zero, 1
0014BCB0 A2440045 sb         $a0, 0x45($s2)
0014BCB4 1000004A b          0x14bde0
0014BCB8 341E0003 ori        $fp, $zero, 3
0014BCBC 34050002 ori        $a1, $zero, 2
0014BCC0 14850034 bne        $a0, $a1, 0x14bd94
0014BCC4 00000000 nop        
0014BCC8 92440046 lbu        $a0, 0x46($s2)
0014BCCC 28840003 slti       $a0, $a0, 3
0014BCD0 10800008 beqz       $a0, 0x14bcf4
0014BCD4 00000000 nop        
0014BCD8 2404FFFF addiu      $a0, $zero, -1
0014BCDC AE64106C sw         $a0, 0x106c($s3)
0014BCE0 92440046 lbu        $a0, 0x46($s2)
0014BCE4 341E0003 ori        $fp, $zero, 3
0014BCE8 24840001 addiu      $a0, $a0, 1
0014BCEC 1000003C b          0x14bde0
0014BCF0 A2440046 sb         $a0, 0x46($s2)
0014BCF4 C66C1074 lwc1       $f12, 0x1074($s3)
0014BCF8 44806800 mtc1       $zero, $f13
0014BCFC 460D603E c.le.s     $f12, $f13
0014BD00 00000000 nop        
0014BD04 45010007 bc1t       0x14bd24
0014BD08 00000000 nop        
0014BD0C 0C060057 jal        0x18015c
0014BD10 34100022 ori        $s0, $zero, 0x22
0014BD14 0050001A div        $zero, $v0, $s0
0014BD18 00002010 mfhi       $a0
0014BD1C 10000004 b          0x14bd30
0014BD20 341E0003 ori        $fp, $zero, 3
0014BD24 34040001 ori        $a0, $zero, 1
0014BD28 100000E7 b          0x14c0c8
0014BD2C A2440045 sb         $a0, 0x45($s2)
0014BD30 3C050100 lui        $a1, 0x100
0014BD34 24840033 addiu      $a0, $a0, 0x33
0014BD38 24A5FFFF addiu      $a1, $a1, -1
0014BD3C 00052824 and        $a1, $zero, $a1
0014BD40 00043600 sll        $a2, $a0, 0x18
0014BD44 00A62825 or         $a1, $a1, $a2
0014BD48 AE60106C sw         $zero, 0x106c($s3)
0014BD4C 2406FF00 addiu      $a2, $zero, -0x100
0014BD50 00A63024 and        $a2, $a1, $a2
0014BD54 AE65106C sw         $a1, 0x106c($s3)
0014BD58 00C42825 or         $a1, $a2, $a0
0014BD5C 3C06FFFF lui        $a2, 0xffff
0014BD60 24C600FF addiu      $a2, $a2, 0xff
0014BD64 AE65106C sw         $a1, 0x106c($s3)
0014BD68 00A62824 and        $a1, $a1, $a2
0014BD6C 00043200 sll        $a2, $a0, 8
0014BD70 00A62825 or         $a1, $a1, $a2
0014BD74 3C06FF01 lui        $a2, 0xff01
0014BD78 AE65106C sw         $a1, 0x106c($s3)
0014BD7C 24C6FFFF addiu      $a2, $a2, -1
0014BD80 00A62824 and        $a1, $a1, $a2
0014BD84 00042400 sll        $a0, $a0, 0x10
0014BD88 00A42025 or         $a0, $a1, $a0
0014BD8C 10000014 b          0x14bde0
0014BD90 AE64106C sw         $a0, 0x106c($s3)
0014BD94 341E0003 ori        $fp, $zero, 3
0014BD98 149E0011 bne        $a0, $fp, 0x14bde0
0014BD9C 3C043D08 lui        $a0, 0x3d08
0014BDA0 C64C0070 lwc1       $f12, 0x70($s2)
0014BDA4 34848889 ori        $a0, $a0, 0x8889
0014BDA8 44846800 mtc1       $a0, $f13
0014BDAC 460D6300 add.s      $f12, $f12, $f13
0014BDB0 3C04002A lui        $a0, 0x2a
0014BDB4 E64C0070 swc1       $f12, 0x70($s2)
0014BDB8 C48E364C lwc1       $f14, 0x364c($a0)
0014BDBC 460E603C c.lt.s     $f12, $f14
0014BDC0 00000000 nop        
0014BDC4 45010004 bc1t       0x14bdd8
0014BDC8 00000000 nop        
0014BDCC 02402025 move       $a0, $s2
0014BDD0 0C0192FF jal        0x64bfc
0014BDD4 34050001 ori        $a1, $zero, 1
0014BDD8 100000BB b          0x14c0c8
0014BDDC 00000000 nop        
0014BDE0 C66C1074 lwc1       $f12, 0x1074($s3)
0014BDE4 3C04BF80 lui        $a0, 0xbf80
0014BDE8 44846800 mtc1       $a0, $f13
0014BDEC 3C050015 lui        $a1, 0x15
0014BDF0 460D6300 add.s      $f12, $f12, $f13
0014BDF4 02402025 move       $a0, $s2
0014BDF8 34060004 ori        $a2, $zero, 4
0014BDFC 24A5B2E0 addiu      $a1, $a1, -0x4d20
0014BE00 0C019BFC jal        0x66ff0
0014BE04 E66C1074 swc1       $f12, 0x1074($s3)
0014BE08 0C05360F jal        0x14d83c
0014BE0C 02402025 move       $a0, $s2
0014BE10 44806000 mtc1       $zero, $f12
0014BE14 3C043F80 lui        $a0, 0x3f80
0014BE18 E7AC0030 swc1       $f12, 0x30($sp)
0014BE1C 4484A000 mtc1       $a0, $f20
0014BE20 E7AC0034 swc1       $f12, 0x34($sp)
0014BE24 E7AC0038 swc1       $f12, 0x38($sp)
0014BE28 E7B4003C swc1       $f20, 0x3c($sp)
0014BE2C 8E640000 lw         $a0, ($s3)
0014BE30 248401A8 addiu      $a0, $a0, 0x1a8
0014BE34 C48C0000 lwc1       $f12, ($a0)
0014BE38 E7AC0030 swc1       $f12, 0x30($sp)
0014BE3C C48C0004 lwc1       $f12, 4($a0)
0014BE40 E7AC0034 swc1       $f12, 0x34($sp)
0014BE44 C48C0008 lwc1       $f12, 8($a0)
0014BE48 3C10002A lui        $s0, 0x2a
0014BE4C E7AC0038 swc1       $f12, 0x38($sp)
0014BE50 C48C000C lwc1       $f12, 0xc($a0)
0014BE54 E7AC003C swc1       $f12, 0x3c($sp)
0014BE58 8E640000 lw         $a0, ($s3)
0014BE5C C60C3734 lwc1       $f12, 0x3734($s0)
0014BE60 C48D0264 lwc1       $f13, 0x264($a0)
0014BE64 460C683E c.le.s     $f13, $f12
0014BE68 00000000 nop        
0014BE6C 4501001D bc1t       0x14bee4
0014BE70 3C11002A lui        $s1, 0x2a
0014BE74 C7AF0030 lwc1       $f15, 0x30($sp)
0014BE78 C7AE0034 lwc1       $f14, 0x34($sp)
0014BE7C 460F7B02 mul.s      $f12, $f15, $f15
0014BE80 C7AD0038 lwc1       $f13, 0x38($sp)
0014BE84 460E7402 mul.s      $f16, $f14, $f14
0014BE88 3C043480 lui        $a0, 0x3480
0014BE8C 460D6C42 mul.s      $f17, $f13, $f13
0014BE90 44849000 mtc1       $a0, $f18
0014BE94 46106300 add.s      $f12, $f12, $f16
0014BE98 46116300 add.s      $f12, $f12, $f17
0014BE9C 4612603C c.lt.s     $f12, $f18
0014BEA0 00000000 nop        
0014BEA4 45010009 bc1t       0x14becc
0014BEA8 27A40030 addiu      $a0, $sp, 0x30
0014BEAC 46006304 sqrt.s     $f12, $f12
0014BEB0 460CA303 div.s      $f12, $f20, $f12
0014BEB4 460C7BC2 mul.s      $f15, $f15, $f12
0014BEB8 460C7382 mul.s      $f14, $f14, $f12
0014BEBC E7AF0030 swc1       $f15, 0x30($sp)
0014BEC0 460C6B02 mul.s      $f12, $f13, $f12
0014BEC4 E7AE0034 swc1       $f14, 0x34($sp)
0014BEC8 E7AC0038 swc1       $f12, 0x38($sp)
0014BECC 00803025 move       $a2, $a0
0014BED0 02402025 move       $a0, $s2
0014BED4 0C05358A jal        0x14d628
0014BED8 34050001 ori        $a1, $zero, 1
0014BEDC 8E640000 lw         $a0, ($s3)
0014BEE0 C60C3734 lwc1       $f12, 0x3734($s0)
0014BEE4 248401A8 addiu      $a0, $a0, 0x1a8
0014BEE8 C48D0000 lwc1       $f13, ($a0)
0014BEEC E7AD0030 swc1       $f13, 0x30($sp)
0014BEF0 C48D0004 lwc1       $f13, 4($a0)
0014BEF4 E7AD0034 swc1       $f13, 0x34($sp)
0014BEF8 C48D0008 lwc1       $f13, 8($a0)
0014BEFC E7AD0038 swc1       $f13, 0x38($sp)
0014BF00 C48D000C lwc1       $f13, 0xc($a0)
0014BF04 E7AD003C swc1       $f13, 0x3c($sp)
0014BF08 8E640000 lw         $a0, ($s3)
0014BF0C C48D0264 lwc1       $f13, 0x264($a0)
0014BF10 460C683E c.le.s     $f13, $f12
0014BF14 00000000 nop        
0014BF18 4501003B bc1t       0x14c008
0014BF1C 00000000 nop        
0014BF20 C7AC0030 lwc1       $f12, 0x30($sp)
0014BF24 C7AD0034 lwc1       $f13, 0x34($sp)
0014BF28 460C63C2 mul.s      $f15, $f12, $f12
0014BF2C C7AE0038 lwc1       $f14, 0x38($sp)
0014BF30 460D6C02 mul.s      $f16, $f13, $f13
0014BF34 3C043480 lui        $a0, 0x3480
0014BF38 460E7442 mul.s      $f17, $f14, $f14
0014BF3C 3C10002A lui        $s0, 0x2a
0014BF40 44849000 mtc1       $a0, $f18
0014BF44 46107BC0 add.s      $f15, $f15, $f16
0014BF48 27A40030 addiu      $a0, $sp, 0x30
0014BF4C 46117BC0 add.s      $f15, $f15, $f17
0014BF50 4612783C c.lt.s     $f15, $f18
0014BF54 00000000 nop        
0014BF58 45010009 bc1t       0x14bf80
0014BF5C C61036D4 lwc1       $f16, 0x36d4($s0)
0014BF60 46007BC4 sqrt.s     $f15, $f15
0014BF64 460FA3C3 div.s      $f15, $f20, $f15
0014BF68 460F6302 mul.s      $f12, $f12, $f15
0014BF6C 460F6B42 mul.s      $f13, $f13, $f15
0014BF70 460F7382 mul.s      $f14, $f14, $f15
0014BF74 E7AC0030 swc1       $f12, 0x30($sp)
0014BF78 E7AD0034 swc1       $f13, 0x34($sp)
0014BF7C E7AE0038 swc1       $f14, 0x38($sp)
0014BF80 00803825 move       $a3, $a0
0014BF84 46008306 mov.s      $f12, $f16
0014BF88 27A40090 addiu      $a0, $sp, 0x90
0014BF8C 27A50094 addiu      $a1, $sp, 0x94
0014BF90 26460030 addiu      $a2, $s2, 0x30
0014BF94 34080068 ori        $t0, $zero, 0x68
0014BF98 34090000 ori        $t1, $zero, 0
0014BF9C 0C00654F jal        0x1953c
0014BFA0 00005025 move       $t2, $zero
0014BFA4 10400018 beqz       $v0, 0x14c008
0014BFA8 00000000 nop        
0014BFAC C7AC0030 lwc1       $f12, 0x30($sp)
0014BFB0 C60D36D4 lwc1       $f13, 0x36d4($s0)
0014BFB4 C64E0030 lwc1       $f14, 0x30($s2)
0014BFB8 C7AF0034 lwc1       $f15, 0x34($sp)
0014BFBC 460D6302 mul.s      $f12, $f12, $f13
0014BFC0 AFA000B0 sw         $zero, 0xb0($sp)
0014BFC4 AFA000B4 sw         $zero, 0xb4($sp)
0014BFC8 460D7BC2 mul.s      $f15, $f15, $f13
0014BFCC C6500034 lwc1       $f16, 0x34($s2)
0014BFD0 C7B10038 lwc1       $f17, 0x38($sp)
0014BFD4 460C7300 add.s      $f12, $f14, $f12
0014BFD8 AFA000B8 sw         $zero, 0xb8($sp)
0014BFDC 460D8B42 mul.s      $f13, $f17, $f13
0014BFE0 C6520038 lwc1       $f18, 0x38($s2)
0014BFE4 460F83C0 add.s      $f15, $f16, $f15
0014BFE8 27A600AC addiu      $a2, $sp, 0xac
0014BFEC E7AC00AC swc1       $f12, 0xac($sp)
0014BFF0 02402025 move       $a0, $s2
0014BFF4 460D9300 add.s      $f12, $f18, $f13
0014BFF8 34050002 ori        $a1, $zero, 2
0014BFFC E7AF00B0 swc1       $f15, 0xb0($sp)
0014C000 0C05358A jal        0x14d628
0014C004 E7AC00B4 swc1       $f12, 0xb4($sp)
0014C008 8E243788 lw         $a0, 0x3788($s1)
0014C00C 10800003 beqz       $a0, 0x14c01c
0014C010 00000000 nop        
0014C014 2484FFFF addiu      $a0, $a0, -1
0014C018 AE243788 sw         $a0, 0x3788($s1)
0014C01C 8E640000 lw         $a0, ($s3)
0014C020 848500F8 lh         $a1, 0xf8($a0)
0014C024 14BE000D bne        $a1, $fp, 0x14c05c
0014C028 00000000 nop        
0014C02C 8E263788 lw         $a2, 0x3788($s1)
0014C030 14C0000A bnez       $a2, 0x14c05c
0014C034 00000000 nop        
0014C038 34040064 ori        $a0, $zero, 0x64
0014C03C AE243788 sw         $a0, 0x3788($s1)
0014C040 8E660000 lw         $a2, ($s3)
0014C044 02402025 move       $a0, $s2
0014C048 24C60010 addiu      $a2, $a2, 0x10
0014C04C 0C05358A jal        0x14d628
0014C050 34050003 ori        $a1, $zero, 3
0014C054 8E640000 lw         $a0, ($s3)
0014C058 848500F8 lh         $a1, 0xf8($a0)
0014C05C 34060005 ori        $a2, $zero, 5
0014C060 14A6000E bne        $a1, $a2, 0x14c09c
0014C064 24840010 addiu      $a0, $a0, 0x10
0014C068 C48C0000 lwc1       $f12, ($a0)
0014C06C 46006307 neg.s      $f12, $f12
0014C070 E7AC00BC swc1       $f12, 0xbc($sp)
0014C074 C48C0004 lwc1       $f12, 4($a0)
0014C078 27A600BC addiu      $a2, $sp, 0xbc
0014C07C 46006307 neg.s      $f12, $f12
0014C080 34050004 ori        $a1, $zero, 4
0014C084 E7AC00C0 swc1       $f12, 0xc0($sp)
0014C088 C48C0008 lwc1       $f12, 8($a0)
0014C08C 02402025 move       $a0, $s2
0014C090 46006307 neg.s      $f12, $f12
0014C094 0C05358A jal        0x14d628
0014C098 E7AC00C4 swc1       $f12, 0xc4($sp)
0014C09C 92440044 lbu        $a0, 0x44($s2)
0014C0A0 8E450040 lw         $a1, 0x40($s2)
0014C0A4 00043100 sll        $a2, $a0, 4
0014C0A8 00862021 addu       $a0, $a0, $a2
0014C0AC 8CA50004 lw         $a1, 4($a1)
0014C0B0 00042080 sll        $a0, $a0, 2
0014C0B4 00862023 subu       $a0, $a0, $a2
0014C0B8 00A42021 addu       $a0, $a1, $a0
0014C0BC 8C850004 lw         $a1, 4($a0)
0014C0C0 0C052B9A jal        0x14ae68
0014C0C4 02402025 move       $a0, $s2
0014C0C8 C7B400CC lwc1       $f20, 0xcc($sp)
0014C0CC C7B600D0 lwc1       $f22, 0xd0($sp)
0014C0D0 C7B800D4 lwc1       $f24, 0xd4($sp)
0014C0D4 8FB000D8 lw         $s0, 0xd8($sp)
0014C0D8 8FB100DC lw         $s1, 0xdc($sp)
0014C0DC 8FB200E0 lw         $s2, 0xe0($sp)
0014C0E0 8FB300E4 lw         $s3, 0xe4($sp)
0014C0E4 8FB400E8 lw         $s4, 0xe8($sp)
0014C0E8 8FB500EC lw         $s5, 0xec($sp)
0014C0EC 8FB600F0 lw         $s6, 0xf0($sp)
0014C0F0 8FB700F4 lw         $s7, 0xf4($sp)
0014C0F4 8FBE00F8 lw         $fp, 0xf8($sp)
0014C0F8 8FBF00FC lw         $ra, 0xfc($sp)
0014C0FC 03E00008 jr         $ra
0014C100 27BD0100 addiu      $sp, $sp, 0x100

CALLBACK 0x0014C104 end 0x0014CD90 ordinal 3

0014C104 27BDFE80 addiu      $sp, $sp, -0x180
0014C108 AFB50160 sw         $s5, 0x160($sp)
0014C10C 8C950058 lw         $s5, 0x58($a0)
0014C110 908B0045 lbu        $t3, 0x45($a0)
0014C114 E7B40144 swc1       $f20, 0x144($sp)
0014C118 AFB10150 sw         $s1, 0x150($sp)
0014C11C AFB20154 sw         $s2, 0x154($sp)
0014C120 AFB4015C sw         $s4, 0x15c($sp)
0014C124 AFB60164 sw         $s6, 0x164($sp)
0014C128 AFBE016C sw         $fp, 0x16c($sp)
0014C12C 46006506 mov.s      $f20, $f12
0014C130 34110001 ori        $s1, $zero, 1
0014C134 34020003 ori        $v0, $zero, 3
0014C138 00809025 move       $s2, $a0
0014C13C 00A05025 move       $t2, $a1
0014C140 00C0F025 move       $fp, $a2
0014C144 00E0A025 move       $s4, $a3
0014C148 0100B025 move       $s6, $t0
0014C14C E7B60148 swc1       $f22, 0x148($sp)
0014C150 AFB0014C sw         $s0, 0x14c($sp)
0014C154 AFB30158 sw         $s3, 0x158($sp)
0014C158 AFB70168 sw         $s7, 0x168($sp)
0014C15C AFBF0170 sw         $ra, 0x170($sp)
0014C160 11620014 beq        $t3, $v0, 0x14c1b4
0014C164 0120B825 move       $s7, $t1
0014C168 3404000E ori        $a0, $zero, 0xe
0014C16C 11440009 beq        $t2, $a0, 0x14c194
0014C170 AFAA0140 sw         $t2, 0x140($sp)
0014C174 C6AC1074 lwc1       $f12, 0x1074($s5)
0014C178 44806800 mtc1       $zero, $f13
0014C17C 460D603C c.lt.s     $f12, $f13
0014C180 00000000 nop        
0014C184 4500000D bc1f       0x14c1bc
0014C188 00000000 nop        
0014C18C 1000000C b          0x14c1c0
0014C190 00000000 nop        
0014C194 0C00AAAA jal        0x2aaa8
0014C198 8EA40000 lw         $a0, ($s5)
0014C19C 34040003 ori        $a0, $zero, 3
0014C1A0 44806000 mtc1       $zero, $f12
0014C1A4 A2440045 sb         $a0, 0x45($s2)
0014C1A8 E64C0070 swc1       $f12, 0x70($s2)
0014C1AC 100002EA b          0x14cd58
0014C1B0 34020003 ori        $v0, $zero, 3
0014C1B4 100002E8 b          0x14cd58
0014C1B8 00001025 move       $v0, $zero
0014C1BC 34110000 ori        $s1, $zero, 0
0014C1C0 3C040005 lui        $a0, 5
0014C1C4 8C84639C lw         $a0, 0x639c($a0)
0014C1C8 1080000E beqz       $a0, 0x14c204
0014C1CC 3C040005 lui        $a0, 5
0014C1D0 8C85639C lw         $a1, 0x639c($a0)
0014C1D4 34070000 ori        $a3, $zero, 0
0014C1D8 C4AC0014 lwc1       $f12, 0x14($a1)
0014C1DC C4AD0018 lwc1       $f13, 0x18($a1)
0014C1E0 C4AE001C lwc1       $f14, 0x1c($a1)
0014C1E4 C4AF0020 lwc1       $f15, 0x20($a1)
0014C1E8 34090000 ori        $t1, $zero, 0
0014C1EC 340A0000 ori        $t2, $zero, 0
0014C1F0 340B0001 ori        $t3, $zero, 1
0014C1F4 02402025 move       $a0, $s2
0014C1F8 00003025 move       $a2, $zero
0014C1FC 0C019B4F jal        0x66d3c
0014C200 00004025 move       $t0, $zero
0014C204 34040007 ori        $a0, $zero, 7
0014C208 34050010 ori        $a1, $zero, 0x10
0014C20C 0C0076E2 jal        0x1db88
0014C210 2406FFFF addiu      $a2, $zero, -1
0014C214 1040017D beqz       $v0, 0x14c80c
0014C218 00000000 nop        
0014C21C 12E0017B beqz       $s7, 0x14c80c
0014C220 00000000 nop        
0014C224 12C00179 beqz       $s6, 0x14c80c
0014C228 00000000 nop        
0014C22C 12800177 beqz       $s4, 0x14c80c
0014C230 00000000 nop        
0014C234 0C052B83 jal        0x14ae0c
0014C238 02E02025 move       $a0, $s7
0014C23C 10400173 beqz       $v0, 0x14c80c
0014C240 00000000 nop        
0014C244 3C04002A lui        $a0, 0x2a
0014C248 34130000 ori        $s3, $zero, 0
0014C24C 34100000 ori        $s0, $zero, 0
0014C250 0C060057 jal        0x18015c
0014C254 C4963760 lwc1       $f22, 0x3760($a0)
0014C258 44826000 mtc1       $v0, $f12
0014C25C 3C042FFF lui        $a0, 0x2fff
0014C260 46806320 cvt.s.w    $f12, $f12
0014C264 3484FFFE ori        $a0, $a0, 0xfffe
0014C268 44846800 mtc1       $a0, $f13
0014C26C 460D6302 mul.s      $f12, $f12, $f13
0014C270 460CB03C c.lt.s     $f22, $f12
0014C274 00000000 nop        
0014C278 45020001 bc1fl      0x14c280
0014C27C 34100001 ori        $s0, $zero, 1
0014C280 320400FF andi       $a0, $s0, 0xff
0014C284 10800055 beqz       $a0, 0x14c3dc
0014C288 A3B1013C sb         $s1, 0x13c($sp)
0014C28C 3C08002A lui        $t0, 0x2a
0014C290 C50C3764 lwc1       $f12, 0x3764($t0)
0014C294 27A40070 addiu      $a0, $sp, 0x70
0014C298 26460030 addiu      $a2, $s2, 0x30
0014C29C 34050020 ori        $a1, $zero, 0x20
0014C2A0 340700A9 ori        $a3, $zero, 0xa9
0014C2A4 34080081 ori        $t0, $zero, 0x81
0014C2A8 34090002 ori        $t1, $zero, 2
0014C2AC 0C00555F jal        0x1557c
0014C2B0 00005025 move       $t2, $zero
0014C2B4 00408825 move       $s1, $v0
0014C2B8 2A240002 slti       $a0, $s1, 2
0014C2BC 10800013 beqz       $a0, 0x14c30c
0014C2C0 00000000 nop        
0014C2C4 12200044 beqz       $s1, 0x14c3d8
0014C2C8 3C04002A lui        $a0, 0x2a
0014C2CC 34100000 ori        $s0, $zero, 0
0014C2D0 0C060057 jal        0x18015c
0014C2D4 C4963760 lwc1       $f22, 0x3760($a0)
0014C2D8 44826000 mtc1       $v0, $f12
0014C2DC 3C042FFF lui        $a0, 0x2fff
0014C2E0 46806320 cvt.s.w    $f12, $f12
0014C2E4 3484FFFE ori        $a0, $a0, 0xfffe
0014C2E8 44846800 mtc1       $a0, $f13
0014C2EC 460D6302 mul.s      $f12, $f12, $f13
0014C2F0 460CB03C c.lt.s     $f22, $f12
0014C2F4 00000000 nop        
0014C2F8 45020001 bc1fl      0x14c300
0014C2FC 34100001 ori        $s0, $zero, 1
0014C300 320400FF andi       $a0, $s0, 0xff
0014C304 10800034 beqz       $a0, 0x14c3d8
0014C308 00000000 nop        
0014C30C 52200007 beql       $s1, $zero, 0x14c32c
0014C310 34110000 ori        $s1, $zero, 0
0014C314 0C060057 jal        0x18015c
0014C318 00000000 nop        
0014C31C 0051001A div        $zero, $v0, $s1
0014C320 00008810 mfhi       $s1
0014C324 10000001 b          0x14c32c
0014C328 00000000 nop        
0014C32C 00112080 sll        $a0, $s1, 2
0014C330 03A42021 addu       $a0, $sp, $a0
0014C334 8C840070 lw         $a0, 0x70($a0)
0014C338 27A500F0 addiu      $a1, $sp, 0xf0
0014C33C 00003025 move       $a2, $zero
0014C340 0C019ACE jal        0x66b38
0014C344 00003825 move       $a3, $zero
0014C348 C7AC00F0 lwc1       $f12, 0xf0($sp)
0014C34C C68D0000 lwc1       $f13, ($s4)
0014C350 C7AE00F4 lwc1       $f14, 0xf4($sp)
0014C354 C68F0004 lwc1       $f15, 4($s4)
0014C358 460D6301 sub.s      $f12, $f12, $f13
0014C35C C7B000F8 lwc1       $f16, 0xf8($sp)
0014C360 460F7381 sub.s      $f14, $f14, $f15
0014C364 C6910008 lwc1       $f17, 8($s4)
0014C368 E7AC0050 swc1       $f12, 0x50($sp)
0014C36C 46118401 sub.s      $f16, $f16, $f17
0014C370 460C6302 mul.s      $f12, $f12, $f12
0014C374 460E7342 mul.s      $f13, $f14, $f14
0014C378 E7AE0054 swc1       $f14, 0x54($sp)
0014C37C 3C043480 lui        $a0, 0x3480
0014C380 44847800 mtc1       $a0, $f15
0014C384 46108382 mul.s      $f14, $f16, $f16
0014C388 460D6300 add.s      $f12, $f12, $f13
0014C38C 460E6300 add.s      $f12, $f12, $f14
0014C390 460F603C c.lt.s     $f12, $f15
0014C394 00000000 nop        
0014C398 4501000E bc1t       0x14c3d4
0014C39C E7B00058 swc1       $f16, 0x58($sp)
0014C3A0 3C043F80 lui        $a0, 0x3f80
0014C3A4 46006304 sqrt.s     $f12, $f12
0014C3A8 44846800 mtc1       $a0, $f13
0014C3AC 460C6B03 div.s      $f12, $f13, $f12
0014C3B0 C7AE0050 lwc1       $f14, 0x50($sp)
0014C3B4 C7AF0054 lwc1       $f15, 0x54($sp)
0014C3B8 C7B00058 lwc1       $f16, 0x58($sp)
0014C3BC 460C7382 mul.s      $f14, $f14, $f12
0014C3C0 460C7BC2 mul.s      $f15, $f15, $f12
0014C3C4 E7AE0050 swc1       $f14, 0x50($sp)
0014C3C8 460C8302 mul.s      $f12, $f16, $f12
0014C3CC E7AF0054 swc1       $f15, 0x54($sp)
0014C3D0 E7AC0058 swc1       $f12, 0x58($sp)
0014C3D4 34130001 ori        $s3, $zero, 1
0014C3D8 93B1013C lbu        $s1, 0x13c($sp)
0014C3DC 16600033 bnez       $s3, 0x14c4ac
0014C3E0 3C04002A lui        $a0, 0x2a
0014C3E4 C6CC0000 lwc1       $f12, ($s6)
0014C3E8 C6CD0004 lwc1       $f13, 4($s6)
0014C3EC 46006307 neg.s      $f12, $f12
0014C3F0 C6CE0008 lwc1       $f14, 8($s6)
0014C3F4 46006B47 neg.s      $f13, $f13
0014C3F8 E7AC0050 swc1       $f12, 0x50($sp)
0014C3FC 460C6302 mul.s      $f12, $f12, $f12
0014C400 E7AD0054 swc1       $f13, 0x54($sp)
0014C404 460D6BC2 mul.s      $f15, $f13, $f13
0014C408 46007387 neg.s      $f14, $f14
0014C40C 3C043480 lui        $a0, 0x3480
0014C410 E7AE0058 swc1       $f14, 0x58($sp)
0014C414 460E7342 mul.s      $f13, $f14, $f14
0014C418 460F6300 add.s      $f12, $f12, $f15
0014C41C 44847000 mtc1       $a0, $f14
0014C420 460D6300 add.s      $f12, $f12, $f13
0014C424 460E603C c.lt.s     $f12, $f14
0014C428 00000000 nop        
0014C42C 4501000D bc1t       0x14c464
0014C430 3C043F80 lui        $a0, 0x3f80
0014C434 46006304 sqrt.s     $f12, $f12
0014C438 44846800 mtc1       $a0, $f13
0014C43C 460C6B03 div.s      $f12, $f13, $f12
0014C440 C7AE0050 lwc1       $f14, 0x50($sp)
0014C444 C7AF0054 lwc1       $f15, 0x54($sp)
0014C448 C7B00058 lwc1       $f16, 0x58($sp)
0014C44C 460C7382 mul.s      $f14, $f14, $f12
0014C450 460C7BC2 mul.s      $f15, $f15, $f12
0014C454 E7AE0050 swc1       $f14, 0x50($sp)
0014C458 460C8302 mul.s      $f12, $f16, $f12
0014C45C E7AF0054 swc1       $f15, 0x54($sp)
0014C460 E7AC0058 swc1       $f12, 0x58($sp)
0014C464 3C0440C9 lui        $a0, 0x40c9
0014C468 34840FDB ori        $a0, $a0, 0xfdb
0014C46C 0C060057 jal        0x18015c
0014C470 4484B000 mtc1       $a0, $f22
0014C474 44826000 mtc1       $v0, $f12
0014C478 3C043000 lui        $a0, 0x3000
0014C47C 46806320 cvt.s.w    $f12, $f12
0014C480 44846800 mtc1       $a0, $f13
0014C484 3C04C049 lui        $a0, 0xc049
0014C488 34850FDB ori        $a1, $a0, 0xfdb
0014C48C 460D6302 mul.s      $f12, $f12, $f13
0014C490 27A40050 addiu      $a0, $sp, 0x50
0014C494 44857000 mtc1       $a1, $f14
0014C498 00802825 move       $a1, $a0
0014C49C 46166302 mul.s      $f12, $f12, $f22
0014C4A0 0C03ACA6 jal        0xeb298
0014C4A4 460E6300 add.s      $f12, $f12, $f14
0014C4A8 3C04002A lui        $a0, 0x2a
0014C4AC C7AC0058 lwc1       $f12, 0x58($sp)
0014C4B0 24859B10 addiu      $a1, $a0, -0x64f0
0014C4B4 C4AD0004 lwc1       $f13, 4($a1)
0014C4B8 C4AE0008 lwc1       $f14, 8($a1)
0014C4BC C7AF0054 lwc1       $f15, 0x54($sp)
0014C4C0 460C6C02 mul.s      $f16, $f13, $f12
0014C4C4 C7B10050 lwc1       $f17, 0x50($sp)
0014C4C8 460F7482 mul.s      $f18, $f14, $f15
0014C4CC C4939B10 lwc1       $f19, -0x64f0($a0)
0014C4D0 460C9B02 mul.s      $f12, $f19, $f12
0014C4D4 46116B42 mul.s      $f13, $f13, $f17
0014C4D8 46117382 mul.s      $f14, $f14, $f17
0014C4DC 46128401 sub.s      $f16, $f16, $f18
0014C4E0 460F9BC2 mul.s      $f15, $f19, $f15
0014C4E4 460C7301 sub.s      $f12, $f14, $f12
0014C4E8 46108002 mul.s      $f0, $f16, $f16
0014C4EC E7B00030 swc1       $f16, 0x30($sp)
0014C4F0 460D7B41 sub.s      $f13, $f15, $f13
0014C4F4 3C043480 lui        $a0, 0x3480
0014C4F8 E7AC0034 swc1       $f12, 0x34($sp)
0014C4FC 460C6402 mul.s      $f16, $f12, $f12
0014C500 44847000 mtc1       $a0, $f14
0014C504 44806000 mtc1       $zero, $f12
0014C508 E7AC003C swc1       $f12, 0x3c($sp)
0014C50C 460D6B02 mul.s      $f12, $f13, $f13
0014C510 E7AD0038 swc1       $f13, 0x38($sp)
0014C514 46100340 add.s      $f13, $f0, $f16
0014C518 460C6B00 add.s      $f12, $f13, $f12
0014C51C 460E603C c.lt.s     $f12, $f14
0014C520 00000000 nop        
0014C524 4501000D bc1t       0x14c55c
0014C528 3C043F80 lui        $a0, 0x3f80
0014C52C 46006304 sqrt.s     $f12, $f12
0014C530 44846800 mtc1       $a0, $f13
0014C534 460C6B03 div.s      $f12, $f13, $f12
0014C538 C7AE0030 lwc1       $f14, 0x30($sp)
0014C53C C7AF0034 lwc1       $f15, 0x34($sp)
0014C540 C7B00038 lwc1       $f16, 0x38($sp)
0014C544 460C7382 mul.s      $f14, $f14, $f12
0014C548 460C7BC2 mul.s      $f15, $f15, $f12
0014C54C E7AE0030 swc1       $f14, 0x30($sp)
0014C550 460C8302 mul.s      $f12, $f16, $f12
0014C554 E7AF0034 swc1       $f15, 0x34($sp)
0014C558 E7AC0038 swc1       $f12, 0x38($sp)
0014C55C C7AC0054 lwc1       $f12, 0x54($sp)
0014C560 C7AD0038 lwc1       $f13, 0x38($sp)
0014C564 C7AE0058 lwc1       $f14, 0x58($sp)
0014C568 C7AF0034 lwc1       $f15, 0x34($sp)
0014C56C 460D6402 mul.s      $f16, $f12, $f13
0014C570 C7B10030 lwc1       $f17, 0x30($sp)
0014C574 460F7482 mul.s      $f18, $f14, $f15
0014C578 C7B30050 lwc1       $f19, 0x50($sp)
0014C57C C6800000 lwc1       $f0, ($s4)
0014C580 44801000 mtc1       $zero, $f2
0014C584 460D9B42 mul.s      $f13, $f19, $f13
0014C588 46116302 mul.s      $f12, $f12, $f17
0014C58C 46117382 mul.s      $f14, $f14, $f17
0014C590 46128401 sub.s      $f16, $f16, $f18
0014C594 460F9BC2 mul.s      $f15, $f19, $f15
0014C598 3C053F80 lui        $a1, 0x3f80
0014C59C 460D7341 sub.s      $f13, $f14, $f13
0014C5A0 E7B00040 swc1       $f16, 0x40($sp)
0014C5A4 460C7B01 sub.s      $f12, $f15, $f12
0014C5A8 E7A2004C swc1       $f2, 0x4c($sp)
0014C5AC E7AD0044 swc1       $f13, 0x44($sp)
0014C5B0 C68D0004 lwc1       $f13, 4($s4)
0014C5B4 E7A00060 swc1       $f0, 0x60($sp)
0014C5B8 E7AC0048 swc1       $f12, 0x48($sp)
0014C5BC C68C0008 lwc1       $f12, 8($s4)
0014C5C0 E7AD0064 swc1       $f13, 0x64($sp)
0014C5C4 E7AC0068 swc1       $f12, 0x68($sp)
0014C5C8 E7A2003C swc1       $f2, 0x3c($sp)
0014C5CC 44856000 mtc1       $a1, $f12
0014C5D0 E7A2005C swc1       $f2, 0x5c($sp)
0014C5D4 3C04702C lui        $a0, 0x702c
0014C5D8 8EE50040 lw         $a1, 0x40($s7)
0014C5DC E7AC006C swc1       $f12, 0x6c($sp)
0014C5E0 2486F650 addiu      $a2, $a0, -0x9b0
0014C5E4 8CA40030 lw         $a0, 0x30($a1)
0014C5E8 10860055 beq        $a0, $a2, 0x14c740
0014C5EC 3C05BF16 lui        $a1, 0xbf16
0014C5F0 24A5E7AB addiu      $a1, $a1, -0x1855
0014C5F4 1085001C beq        $a0, $a1, 0x14c668
0014C5F8 3C05B7E3 lui        $a1, 0xb7e3
0014C5FC 24A506B3 addiu      $a1, $a1, 0x6b3
0014C600 1085000C beq        $a0, $a1, 0x14c634
0014C604 3C05B5E7 lui        $a1, 0xb5e7
0014C608 24A56E00 addiu      $a1, $a1, 0x6e00
0014C60C 10850010 beq        $a0, $a1, 0x14c650
0014C610 3C058239 lui        $a1, 0x8239
0014C614 24A56476 addiu      $a1, $a1, 0x6476
0014C618 1485007C bne        $a0, $a1, 0x14c80c
0014C61C 00000000 nop        
0014C620 27A40030 addiu      $a0, $sp, 0x30
0014C624 0C03F2B0 jal        0xfcac0
0014C628 00002825 move       $a1, $zero
0014C62C 10000077 b          0x14c80c
0014C630 00000000 nop        
0014C634 8EE50054 lw         $a1, 0x54($s7)
0014C638 27A40030 addiu      $a0, $sp, 0x30
0014C63C 8CA60008 lw         $a2, 8($a1)
0014C640 0C03F2B2 jal        0xfcac8
0014C644 00002825 move       $a1, $zero
0014C648 10000070 b          0x14c80c
0014C64C 00000000 nop        
0014C650 27A50060 addiu      $a1, $sp, 0x60
0014C654 27A60050 addiu      $a2, $sp, 0x50
0014C658 0C03F280 jal        0xfca00
0014C65C 02402025 move       $a0, $s2
0014C660 1000006A b          0x14c80c
0014C664 00000000 nop        
0014C668 8EE40054 lw         $a0, 0x54($s7)
0014C66C 3C05002A lui        $a1, 0x2a
0014C670 8C900010 lw         $s0, 0x10($a0)
0014C674 8CA59868 lw         $a1, -0x6798($a1)
0014C678 34040000 ori        $a0, $zero, 0
0014C67C 8CA50038 lw         $a1, 0x38($a1)
0014C680 0085282B sltu       $a1, $a0, $a1
0014C684 10A0001B beqz       $a1, 0x14c6f4
0014C688 00000000 nop        
0014C68C 3C07002A lui        $a3, 0x2a
0014C690 00042980 sll        $a1, $a0, 6
0014C694 00043100 sll        $a2, $a0, 4
0014C698 8CE79868 lw         $a3, -0x6798($a3)
0014C69C 00A62821 addu       $a1, $a1, $a2
0014C6A0 8CE60034 lw         $a2, 0x34($a3)
0014C6A4 3C07BF16 lui        $a3, 0xbf16
0014C6A8 00C52821 addu       $a1, $a2, $a1
0014C6AC 8CA50030 lw         $a1, 0x30($a1)
0014C6B0 24E6E7AB addiu      $a2, $a3, -0x1855
0014C6B4 14A60009 bne        $a1, $a2, 0x14c6dc
0014C6B8 3C05002A lui        $a1, 0x2a
0014C6BC 00042980 sll        $a1, $a0, 6
0014C6C0 3C06002A lui        $a2, 0x2a
0014C6C4 00042100 sll        $a0, $a0, 4
0014C6C8 8CC69868 lw         $a2, -0x6798($a2)
0014C6CC 00A42021 addu       $a0, $a1, $a0
0014C6D0 8CC50034 lw         $a1, 0x34($a2)
0014C6D4 10000008 b          0x14c6f8
0014C6D8 00A42021 addu       $a0, $a1, $a0
0014C6DC 8CA59868 lw         $a1, -0x6798($a1)
0014C6E0 24840001 addiu      $a0, $a0, 1
0014C6E4 8CA50038 lw         $a1, 0x38($a1)
0014C6E8 0085282B sltu       $a1, $a0, $a1
0014C6EC 14A0FFE8 bnez       $a1, 0x14c690
0014C6F0 3C07002A lui        $a3, 0x2a
0014C6F4 34040000 ori        $a0, $zero, 0
0014C6F8 14800003 bnez       $a0, 0x14c708
0014C6FC 3C05BF16 lui        $a1, 0xbf16
0014C700 10000006 b          0x14c71c
0014C704 34040000 ori        $a0, $zero, 0
0014C708 27A60030 addiu      $a2, $sp, 0x30
0014C70C 340700FF ori        $a3, $zero, 0xff
0014C710 0C0192B4 jal        0x64ad0
0014C714 24A5E7AB addiu      $a1, $a1, -0x1855
0014C718 00402025 move       $a0, $v0
0014C71C 10800006 beqz       $a0, 0x14c738
0014C720 00000000 nop        
0014C724 3C074120 lui        $a3, 0x4120
0014C728 02402825 move       $a1, $s2
0014C72C 44876000 mtc1       $a3, $f12
0014C730 0C03F296 jal        0xfca58
0014C734 02003025 move       $a2, $s0
0014C738 10000034 b          0x14c80c
0014C73C 00000000 nop        
0014C740 8EE40054 lw         $a0, 0x54($s7)
0014C744 3C05002A lui        $a1, 0x2a
0014C748 8C900008 lw         $s0, 8($a0)
0014C74C 8CA59868 lw         $a1, -0x6798($a1)
0014C750 34040000 ori        $a0, $zero, 0
0014C754 8CA50038 lw         $a1, 0x38($a1)
0014C758 0085282B sltu       $a1, $a0, $a1
0014C75C 10A0001B beqz       $a1, 0x14c7cc
0014C760 00000000 nop        
0014C764 3C07002A lui        $a3, 0x2a
0014C768 00042980 sll        $a1, $a0, 6
0014C76C 00043100 sll        $a2, $a0, 4
0014C770 8CE79868 lw         $a3, -0x6798($a3)
0014C774 00A62821 addu       $a1, $a1, $a2
0014C778 8CE60034 lw         $a2, 0x34($a3)
0014C77C 3C07702C lui        $a3, 0x702c
0014C780 00C52821 addu       $a1, $a2, $a1
0014C784 8CA50030 lw         $a1, 0x30($a1)
0014C788 24E6F650 addiu      $a2, $a3, -0x9b0
0014C78C 14A60009 bne        $a1, $a2, 0x14c7b4
0014C790 3C05002A lui        $a1, 0x2a
0014C794 00042980 sll        $a1, $a0, 6
0014C798 3C06002A lui        $a2, 0x2a
0014C79C 00042100 sll        $a0, $a0, 4
0014C7A0 8CC69868 lw         $a2, -0x6798($a2)
0014C7A4 00A42021 addu       $a0, $a1, $a0
0014C7A8 8CC50034 lw         $a1, 0x34($a2)
0014C7AC 10000008 b          0x14c7d0
0014C7B0 00A42021 addu       $a0, $a1, $a0
0014C7B4 8CA59868 lw         $a1, -0x6798($a1)
0014C7B8 24840001 addiu      $a0, $a0, 1
0014C7BC 8CA50038 lw         $a1, 0x38($a1)
0014C7C0 0085282B sltu       $a1, $a0, $a1
0014C7C4 14A0FFE8 bnez       $a1, 0x14c768
0014C7C8 3C07002A lui        $a3, 0x2a
0014C7CC 34040000 ori        $a0, $zero, 0
0014C7D0 14800003 bnez       $a0, 0x14c7e0
0014C7D4 27A60030 addiu      $a2, $sp, 0x30
0014C7D8 10000005 b          0x14c7f0
0014C7DC 34040000 ori        $a0, $zero, 0
0014C7E0 00002825 move       $a1, $zero
0014C7E4 0C0192B4 jal        0x64ad0
0014C7E8 340700FF ori        $a3, $zero, 0xff
0014C7EC 00402025 move       $a0, $v0
0014C7F0 10800006 beqz       $a0, 0x14c80c
0014C7F4 00000000 nop        
0014C7F8 3C074120 lui        $a3, 0x4120
0014C7FC 02402825 move       $a1, $s2
0014C800 44876000 mtc1       $a3, $f12
0014C804 0C03F2C8 jal        0xfcb20
0014C808 02003025 move       $a2, $s0
0014C80C 12200071 beqz       $s1, 0x14c9d4
0014C810 00000000 nop        
0014C814 C6AD1070 lwc1       $f13, 0x1070($s5)
0014C818 44806000 mtc1       $zero, $f12
0014C81C 46146B41 sub.s      $f13, $f13, $f20
0014C820 E6AD1070 swc1       $f13, 0x1070($s5)
0014C824 460C683C c.lt.s     $f13, $f12
0014C828 00000000 nop        
0014C82C 45030001 bc1tl      0x14c834
0014C830 E6AC1070 swc1       $f12, 0x1070($s5)
0014C834 8EA41078 lw         $a0, 0x1078($s5)
0014C838 C6AD1070 lwc1       $f13, 0x1070($s5)
0014C83C 3C06002A lui        $a2, 0x2a
0014C840 C4CC3714 lwc1       $f12, 0x3714($a2)
0014C844 3C05002A lui        $a1, 0x2a
0014C848 00042080 sll        $a0, $a0, 2
0014C84C 460CA302 mul.s      $f12, $f20, $f12
0014C850 24A536F4 addiu      $a1, $a1, 0x36f4
0014C854 00852021 addu       $a0, $a0, $a1
0014C858 3C054F00 lui        $a1, 0x4f00
0014C85C C48E0000 lwc1       $f14, ($a0)
0014C860 44857800 mtc1       $a1, $f15
0014C864 460E6D03 div.s      $f20, $f13, $f14
0014C868 460F603C c.lt.s     $f12, $f15
0014C86C 00000000 nop        
0014C870 45000004 bc1f       0x14c884
0014C874 8EA40000 lw         $a0, ($s5)
0014C878 4600630D trunc.w.s  $f12, $f12
0014C87C 10000008 b          0x14c8a0
0014C880 44056000 mfc1       $a1, $f12
0014C884 3C054F00 lui        $a1, 0x4f00
0014C888 44856800 mtc1       $a1, $f13
0014C88C 460D6301 sub.s      $f12, $f12, $f13
0014C890 3C058000 lui        $a1, 0x8000
0014C894 4600630D trunc.w.s  $f12, $f12
0014C898 44066000 mfc1       $a2, $f12
0014C89C 00C52821 addu       $a1, $a2, $a1
0014C8A0 00A03025 move       $a2, $a1
0014C8A4 0C003EE2 jal        0xfb88
0014C8A8 34050007 ori        $a1, $zero, 7
0014C8AC 3C04002A lui        $a0, 0x2a
0014C8B0 4600A306 mov.s      $f12, $f20
0014C8B4 8C8436E0 lw         $a0, 0x36e0($a0)
0014C8B8 3C05002A lui        $a1, 0x2a
0014C8BC 0C03A359 jal        0xe8d64
0014C8C0 8CA536DC lw         $a1, 0x36dc($a1)
0014C8C4 AEA2106C sw         $v0, 0x106c($s5)
0014C8C8 3C04002A lui        $a0, 0x2a
0014C8CC 8C843640 lw         $a0, 0x3640($a0)
0014C8D0 4484A000 mtc1       $a0, $f20
0014C8D4 04810004 bgez       $a0, 0x14c8e8
0014C8D8 4680A520 cvt.s.w    $f20, $f20
0014C8DC 3C044F80 lui        $a0, 0x4f80
0014C8E0 44846000 mtc1       $a0, $f12
0014C8E4 460CA500 add.s      $f20, $f20, $f12
0014C8E8 E6B41074 swc1       $f20, 0x1074($s5)
0014C8EC 92440045 lbu        $a0, 0x45($s2)
0014C8F0 34050001 ori        $a1, $zero, 1
0014C8F4 14850004 bne        $a0, $a1, 0x14c908
0014C8F8 00000000 nop        
0014C8FC 34040002 ori        $a0, $zero, 2
0014C900 A2440045 sb         $a0, 0x45($s2)
0014C904 A2400046 sb         $zero, 0x46($s2)
0014C908 34040007 ori        $a0, $zero, 7
0014C90C 34050011 ori        $a1, $zero, 0x11
0014C910 0C0076E2 jal        0x1db88
0014C914 2406FFFF addiu      $a2, $zero, -1
0014C918 10400009 beqz       $v0, 0x14c940
0014C91C 00000000 nop        
0014C920 0C051133 jal        0x1444cc
0014C924 02402025 move       $a0, $s2
0014C928 10400005 beqz       $v0, 0x14c940
0014C92C 00000000 nop        
0014C930 02402025 move       $a0, $s2
0014C934 02E02825 move       $a1, $s7
0014C938 0C0511CF jal        0x14473c
0014C93C 02C03025 move       $a2, $s6
0014C940 C6AC1070 lwc1       $f12, 0x1070($s5)
0014C944 44806800 mtc1       $zero, $f13
0014C948 460D6032 c.eq.s     $f12, $f13
0014C94C 00000000 nop        
0014C950 45000020 bc1f       0x14c9d4
0014C954 00000000 nop        
0014C958 0C00AAAA jal        0x2aaa8
0014C95C 8EA40000 lw         $a0, ($s5)
0014C960 3C040006 lui        $a0, 6
0014C964 0C00AAB5 jal        0x2aad4
0014C968 2490A8B8 addiu      $s0, $a0, -0x5748
0014C96C 02002025 move       $a0, $s0
0014C970 0C00AA99 jal        0x2aa64
0014C974 46000306 mov.s      $f12, $f0
0014C978 34040003 ori        $a0, $zero, 3
0014C97C 44806000 mtc1       $zero, $f12
0014C980 A2440045 sb         $a0, 0x45($s2)
0014C984 E64C0070 swc1       $f12, 0x70($s2)
0014C988 3C040005 lui        $a0, 5
0014C98C 8C8463A8 lw         $a0, 0x63a8($a0)
0014C990 1080000E beqz       $a0, 0x14c9cc
0014C994 3C040005 lui        $a0, 5
0014C998 8C8563A8 lw         $a1, 0x63a8($a0)
0014C99C 34070000 ori        $a3, $zero, 0
0014C9A0 C4AC0014 lwc1       $f12, 0x14($a1)
0014C9A4 C4AD0018 lwc1       $f13, 0x18($a1)
0014C9A8 C4AE001C lwc1       $f14, 0x1c($a1)
0014C9AC C4AF0020 lwc1       $f15, 0x20($a1)
0014C9B0 34090000 ori        $t1, $zero, 0
0014C9B4 340A0000 ori        $t2, $zero, 0
0014C9B8 340B0001 ori        $t3, $zero, 1
0014C9BC 02402025 move       $a0, $s2
0014C9C0 00003025 move       $a2, $zero
0014C9C4 0C019B4F jal        0x66d3c
0014C9C8 00004025 move       $t0, $zero
0014C9CC 100000E2 b          0x14cd58
0014C9D0 34020003 ori        $v0, $zero, 3
0014C9D4 0C0155F5 jal        0x557d4
0014C9D8 8EA40000 lw         $a0, ($s5)
0014C9DC 10400005 beqz       $v0, 0x14c9f4
0014C9E0 00000000 nop        
0014C9E4 0C0155FF jal        0x557fc
0014C9E8 8EA40000 lw         $a0, ($s5)
0014C9EC 100000D5 b          0x14cd44
0014C9F0 00000000 nop        
0014C9F4 8FA40140 lw         $a0, 0x140($sp)
0014C9F8 14800008 bnez       $a0, 0x14ca1c
0014C9FC 00000000 nop        
0014CA00 26470030 addiu      $a3, $s2, 0x30
0014CA04 02402025 move       $a0, $s2
0014CA08 34050001 ori        $a1, $zero, 1
0014CA0C 0C052C51 jal        0x14b144
0014CA10 03C03025 move       $a2, $fp
0014CA14 100000CB b          0x14cd44
0014CA18 00000000 nop        
0014CA1C 56800008 bnel       $s4, $zero, 0x14ca40
0014CA20 C68C0000 lwc1       $f12, ($s4)
0014CA24 26470030 addiu      $a3, $s2, 0x30
0014CA28 02402025 move       $a0, $s2
0014CA2C 34050001 ori        $a1, $zero, 1
0014CA30 0C052C51 jal        0x14b144
0014CA34 03C03025 move       $a2, $fp
0014CA38 100000C2 b          0x14cd44
0014CA3C 00000000 nop        
0014CA40 C64D0030 lwc1       $f13, 0x30($s2)
0014CA44 C68E0004 lwc1       $f14, 4($s4)
0014CA48 C64F0034 lwc1       $f15, 0x34($s2)
0014CA4C 460D6301 sub.s      $f12, $f12, $f13
0014CA50 C6900008 lwc1       $f16, 8($s4)
0014CA54 460F7381 sub.s      $f14, $f14, $f15
0014CA58 C6510038 lwc1       $f17, 0x38($s2)
0014CA5C 46118401 sub.s      $f16, $f16, $f17
0014CA60 E7AC0100 swc1       $f12, 0x100($sp)
0014CA64 460C6342 mul.s      $f13, $f12, $f12
0014CA68 460E7482 mul.s      $f18, $f14, $f14
0014CA6C 3C04002A lui        $a0, 0x2a
0014CA70 E7AE0104 swc1       $f14, 0x104($sp)
0014CA74 46108302 mul.s      $f12, $f16, $f16
0014CA78 46126B40 add.s      $f13, $f13, $f18
0014CA7C C48E36D8 lwc1       $f14, 0x36d8($a0)
0014CA80 3C053727 lui        $a1, 0x3727
0014CA84 34A5C5AC ori        $a1, $a1, 0xc5ac
0014CA88 460C6B00 add.s      $f12, $f13, $f12
0014CA8C E7B00108 swc1       $f16, 0x108($sp)
0014CA90 44857800 mtc1       $a1, $f15
0014CA94 34040000 ori        $a0, $zero, 0
0014CA98 460E6381 sub.s      $f14, $f12, $f14
0014CA9C 46007385 abs.s      $f14, $f14
0014CAA0 460F703E c.le.s     $f14, $f15
0014CAA4 00000000 nop        
0014CAA8 45030001 bc1tl      0x14cab0
0014CAAC 34040001 ori        $a0, $zero, 1
0014CAB0 308400FF andi       $a0, $a0, 0xff
0014CAB4 10800008 beqz       $a0, 0x14cad8
0014CAB8 00000000 nop        
0014CABC 02402025 move       $a0, $s2
0014CAC0 00002825 move       $a1, $zero
0014CAC4 03C03025 move       $a2, $fp
0014CAC8 0C052C51 jal        0x14b144
0014CACC 02803825 move       $a3, $s4
0014CAD0 1000009C b          0x14cd44
0014CAD4 00000000 nop        
0014CAD8 3C04002A lui        $a0, 0x2a
0014CADC C48D36D8 lwc1       $f13, 0x36d8($a0)
0014CAE0 460D603C c.lt.s     $f12, $f13
0014CAE4 00000000 nop        
0014CAE8 45000020 bc1f       0x14cb6c
0014CAEC 00000000 nop        
0014CAF0 44806800 mtc1       $zero, $f13
0014CAF4 3C043F80 lui        $a0, 0x3f80
0014CAF8 E7AD010C swc1       $f13, 0x10c($sp)
0014CAFC 4484A000 mtc1       $a0, $f20
0014CB00 E7AD0110 swc1       $f13, 0x110($sp)
0014CB04 E7AD0114 swc1       $f13, 0x114($sp)
0014CB08 0C06207E jal        0x1881f8
0014CB0C E7B40118 swc1       $f20, 0x118($sp)
0014CB10 4600A303 div.s      $f12, $f20, $f0
0014CB14 C7AD0100 lwc1       $f13, 0x100($sp)
0014CB18 C64E0030 lwc1       $f14, 0x30($s2)
0014CB1C C7AF0104 lwc1       $f15, 0x104($sp)
0014CB20 C6500034 lwc1       $f16, 0x34($s2)
0014CB24 C7B10108 lwc1       $f17, 0x108($sp)
0014CB28 C6520038 lwc1       $f18, 0x38($s2)
0014CB2C 27A7010C addiu      $a3, $sp, 0x10c
0014CB30 02402025 move       $a0, $s2
0014CB34 00002825 move       $a1, $zero
0014CB38 03C03025 move       $a2, $fp
0014CB3C 460C6B42 mul.s      $f13, $f13, $f12
0014CB40 460C7BC2 mul.s      $f15, $f15, $f12
0014CB44 460D7340 add.s      $f13, $f14, $f13
0014CB48 460C8B02 mul.s      $f12, $f17, $f12
0014CB4C 460F83C0 add.s      $f15, $f16, $f15
0014CB50 E7AD010C swc1       $f13, 0x10c($sp)
0014CB54 460C9300 add.s      $f12, $f18, $f12
0014CB58 E7AF0110 swc1       $f15, 0x110($sp)
0014CB5C 0C052C51 jal        0x14b144
0014CB60 E7AC0114 swc1       $f12, 0x114($sp)
0014CB64 10000077 b          0x14cd44
0014CB68 00000000 nop        
0014CB6C 16C0000E bnez       $s6, 0x14cba8
0014CB70 00000000 nop        
0014CB74 C64C0030 lwc1       $f12, 0x30($s2)
0014CB78 C68D0000 lwc1       $f13, ($s4)
0014CB7C C64E0034 lwc1       $f14, 0x34($s2)
0014CB80 460D6301 sub.s      $f12, $f12, $f13
0014CB84 C68F0004 lwc1       $f15, 4($s4)
0014CB88 C6500038 lwc1       $f16, 0x38($s2)
0014CB8C C6910008 lwc1       $f17, 8($s4)
0014CB90 460F7381 sub.s      $f14, $f14, $f15
0014CB94 E7AC011C swc1       $f12, 0x11c($sp)
0014CB98 46118301 sub.s      $f12, $f16, $f17
0014CB9C E7AE0120 swc1       $f14, 0x120($sp)
0014CBA0 10000007 b          0x14cbc0
0014CBA4 E7AC0124 swc1       $f12, 0x124($sp)
0014CBA8 C6CC0000 lwc1       $f12, ($s6)
0014CBAC C6CD0004 lwc1       $f13, 4($s6)
0014CBB0 E7AC011C swc1       $f12, 0x11c($sp)
0014CBB4 C6CC0008 lwc1       $f12, 8($s6)
0014CBB8 E7AD0120 swc1       $f13, 0x120($sp)
0014CBBC E7AC0124 swc1       $f12, 0x124($sp)
0014CBC0 C7AC011C lwc1       $f12, 0x11c($sp)
0014CBC4 C7AD0120 lwc1       $f13, 0x120($sp)
0014CBC8 460C6302 mul.s      $f12, $f12, $f12
0014CBCC C7AE0124 lwc1       $f14, 0x124($sp)
0014CBD0 460D6B42 mul.s      $f13, $f13, $f13
0014CBD4 3C043F80 lui        $a0, 0x3f80
0014CBD8 460E7382 mul.s      $f14, $f14, $f14
0014CBDC 44808000 mtc1       $zero, $f16
0014CBE0 3C053727 lui        $a1, 0x3727
0014CBE4 E7B00128 swc1       $f16, 0x128($sp)
0014CBE8 44847800 mtc1       $a0, $f15
0014CBEC 460D6300 add.s      $f12, $f12, $f13
0014CBF0 E7B0012C swc1       $f16, 0x12c($sp)
0014CBF4 E7B00130 swc1       $f16, 0x130($sp)
0014CBF8 E7AF0134 swc1       $f15, 0x134($sp)
0014CBFC 460E6300 add.s      $f12, $f12, $f14
0014CC00 34A5C5AC ori        $a1, $a1, 0xc5ac
0014CC04 44858000 mtc1       $a1, $f16
0014CC08 34040000 ori        $a0, $zero, 0
0014CC0C 460F63C1 sub.s      $f15, $f12, $f15
0014CC10 46007BC5 abs.s      $f15, $f15
0014CC14 4610783E c.le.s     $f15, $f16
0014CC18 00000000 nop        
0014CC1C 45030001 bc1tl      0x14cc24
0014CC20 34040001 ori        $a0, $zero, 1
0014CC24 308400FF andi       $a0, $a0, 0xff
0014CC28 54800010 bnel       $a0, $zero, 0x14cc6c
0014CC2C C64C0030 lwc1       $f12, 0x30($s2)
0014CC30 0C06207E jal        0x1881f8
0014CC34 00000000 nop        
0014CC38 3C043F80 lui        $a0, 0x3f80
0014CC3C 44846000 mtc1       $a0, $f12
0014CC40 46006303 div.s      $f12, $f12, $f0
0014CC44 C7AD011C lwc1       $f13, 0x11c($sp)
0014CC48 C7AE0120 lwc1       $f14, 0x120($sp)
0014CC4C C7AF0124 lwc1       $f15, 0x124($sp)
0014CC50 460C6B42 mul.s      $f13, $f13, $f12
0014CC54 460C7382 mul.s      $f14, $f14, $f12
0014CC58 E7AD011C swc1       $f13, 0x11c($sp)
0014CC5C 460C7B02 mul.s      $f12, $f15, $f12
0014CC60 E7AE0120 swc1       $f14, 0x120($sp)
0014CC64 E7AC0124 swc1       $f12, 0x124($sp)
0014CC68 C64C0030 lwc1       $f12, 0x30($s2)
0014CC6C C68D0000 lwc1       $f13, ($s4)
0014CC70 C64E0034 lwc1       $f14, 0x34($s2)
0014CC74 C68F0004 lwc1       $f15, 4($s4)
0014CC78 460D6301 sub.s      $f12, $f12, $f13
0014CC7C C6500038 lwc1       $f16, 0x38($s2)
0014CC80 460F7381 sub.s      $f14, $f14, $f15
0014CC84 C6910008 lwc1       $f17, 8($s4)
0014CC88 460C6302 mul.s      $f12, $f12, $f12
0014CC8C 46118401 sub.s      $f16, $f16, $f17
0014CC90 460E7342 mul.s      $f13, $f14, $f14
0014CC94 46108402 mul.s      $f16, $f16, $f16
0014CC98 460D6300 add.s      $f12, $f12, $f13
0014CC9C 0C05E2E0 jal        0x178b80
0014CCA0 46106300 add.s      $f12, $f12, $f16
0014CCA4 44806000 mtc1       $zero, $f12
0014CCA8 3C05002A lui        $a1, 0x2a
0014CCAC E7AC0138 swc1       $f12, 0x138($sp)
0014CCB0 C4AD36D8 lwc1       $f13, 0x36d8($a1)
0014CCB4 46000306 mov.s      $f12, $f0
0014CCB8 27A40138 addiu      $a0, $sp, 0x138
0014CCBC 27A6011C addiu      $a2, $sp, 0x11c
0014CCC0 26470030 addiu      $a3, $s2, 0x30
0014CCC4 0C038C38 jal        0xe30e0
0014CCC8 02802825 move       $a1, $s4
0014CCCC 10400018 beqz       $v0, 0x14cd30
0014CCD0 00000000 nop        
0014CCD4 C7AC0138 lwc1       $f12, 0x138($sp)
0014CCD8 C7AD011C lwc1       $f13, 0x11c($sp)
0014CCDC C68E0000 lwc1       $f14, ($s4)
0014CCE0 C7AF0120 lwc1       $f15, 0x120($sp)
0014CCE4 460C6B42 mul.s      $f13, $f13, $f12
0014CCE8 C6900004 lwc1       $f16, 4($s4)
0014CCEC 460C7BC2 mul.s      $f15, $f15, $f12
0014CCF0 C7B10124 lwc1       $f17, 0x124($sp)
0014CCF4 C6920008 lwc1       $f18, 8($s4)
0014CCF8 460D7340 add.s      $f13, $f14, $f13
0014CCFC 27A70128 addiu      $a3, $sp, 0x128
0014CD00 460C8B02 mul.s      $f12, $f17, $f12
0014CD04 02402025 move       $a0, $s2
0014CD08 460F83C0 add.s      $f15, $f16, $f15
0014CD0C 00002825 move       $a1, $zero
0014CD10 E7AD0128 swc1       $f13, 0x128($sp)
0014CD14 03C03025 move       $a2, $fp
0014CD18 460C9300 add.s      $f12, $f18, $f12
0014CD1C E7AF012C swc1       $f15, 0x12c($sp)
0014CD20 0C052C51 jal        0x14b144
0014CD24 E7AC0130 swc1       $f12, 0x130($sp)
0014CD28 10000006 b          0x14cd44
0014CD2C 00000000 nop        
0014CD30 26470030 addiu      $a3, $s2, 0x30
0014CD34 02402025 move       $a0, $s2
0014CD38 34050001 ori        $a1, $zero, 1
0014CD3C 0C052C51 jal        0x14b144
0014CD40 03C03025 move       $a2, $fp
0014CD44 12200003 beqz       $s1, 0x14cd54
0014CD48 00000000 nop        
0014CD4C 10000002 b          0x14cd58
0014CD50 34020002 ori        $v0, $zero, 2
0014CD54 34020001 ori        $v0, $zero, 1
0014CD58 C7B40144 lwc1       $f20, 0x144($sp)
0014CD5C C7B60148 lwc1       $f22, 0x148($sp)
0014CD60 8FB0014C lw         $s0, 0x14c($sp)
0014CD64 8FB10150 lw         $s1, 0x150($sp)
0014CD68 8FB20154 lw         $s2, 0x154($sp)
0014CD6C 8FB30158 lw         $s3, 0x158($sp)
0014CD70 8FB4015C lw         $s4, 0x15c($sp)
0014CD74 8FB50160 lw         $s5, 0x160($sp)
0014CD78 8FB60164 lw         $s6, 0x164($sp)
0014CD7C 8FB70168 lw         $s7, 0x168($sp)
0014CD80 8FBE016C lw         $fp, 0x16c($sp)
0014CD84 8FBF0170 lw         $ra, 0x170($sp)
0014CD88 03E00008 jr         $ra
0014CD8C 27BD0180 addiu      $sp, $sp, 0x180