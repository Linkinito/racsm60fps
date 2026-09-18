
CALLBACK 0x0016C748 end 0x0016CB78 ordinal 0

0016C748 27BDFF70 addiu      $sp, $sp, -0x90
0016C74C 3C06002D lui        $a2, 0x2d
0016C750 8CC6C588 lw         $a2, -0x3a78($a2)
0016C754 34050009 ori        $a1, $zero, 9
0016C758 E7B40050 swc1       $f20, 0x50($sp)
0016C75C E7B60054 swc1       $f22, 0x54($sp)
0016C760 E7B80058 swc1       $f24, 0x58($sp)
0016C764 AFB0005C sw         $s0, 0x5c($sp)
0016C768 AFB10060 sw         $s1, 0x60($sp)
0016C76C AFB20064 sw         $s2, 0x64($sp)
0016C770 AFB30068 sw         $s3, 0x68($sp)
0016C774 AFB4006C sw         $s4, 0x6c($sp)
0016C778 AFB50070 sw         $s5, 0x70($sp)
0016C77C AFB60074 sw         $s6, 0x74($sp)
0016C780 AFB70078 sw         $s7, 0x78($sp)
0016C784 AFBE007C sw         $fp, 0x7c($sp)
0016C788 AFBF0080 sw         $ra, 0x80($sp)
0016C78C 14C5000A bne        $a2, $a1, 0x16c7b8
0016C790 00808025 move       $s0, $a0
0016C794 3C040009 lui        $a0, 9
0016C798 2484C928 addiu      $a0, $a0, -0x36d8
0016C79C 9085000D lbu        $a1, 0xd($a0)
0016C7A0 18A00005 blez       $a1, 0x16c7b8
0016C7A4 28A50040 slti       $a1, $a1, 0x40
0016C7A8 10A00003 beqz       $a1, 0x16c7b8
0016C7AC 00000000 nop        
0016C7B0 34050080 ori        $a1, $zero, 0x80
0016C7B4 A085000D sb         $a1, 0xd($a0)
0016C7B8 8E110058 lw         $s1, 0x58($s0)
0016C7BC 3C04002B lui        $a0, 0x2b
0016C7C0 AE200000 sw         $zero, ($s1)
0016C7C4 AE201080 sw         $zero, 0x1080($s1)
0016C7C8 8C8500C0 lw         $a1, 0xc0($a0)
0016C7CC 34040007 ori        $a0, $zero, 7
0016C7D0 0C007DC7 jal        0x1f71c
0016C7D4 8CA500F0 lw         $a1, 0xf0($a1)
0016C7D8 00409025 move       $s2, $v0
0016C7DC 8E440040 lw         $a0, 0x40($s2)
0016C7E0 14800008 bnez       $a0, 0x16c804
0016C7E4 00000000 nop        
0016C7E8 3C04001D lui        $a0, 0x1d
0016C7EC 2405FFC3 addiu      $a1, $zero, -0x3d
0016C7F0 2406FFFF addiu      $a2, $zero, -1
0016C7F4 0C028ED4 jal        0xa3b50
0016C7F8 24848EC8 addiu      $a0, $a0, -0x7138
0016C7FC 100000CF b          0x16cb3c
0016C800 00001025 move       $v0, $zero
0016C804 26240004 addiu      $a0, $s1, 4
0016C808 00002825 move       $a1, $zero
0016C80C 0C06B6A7 jal        0x1ada9c
0016C810 340600A0 ori        $a2, $zero, 0xa0
0016C814 3C044049 lui        $a0, 0x4049
0016C818 4480C000 mtc1       $zero, $f24
0016C81C 34840FDB ori        $a0, $a0, 0xfdb
0016C820 4484A000 mtc1       $a0, $f20
0016C824 3C16002D lui        $s6, 0x2d
0016C828 3C043000 lui        $a0, 0x3000
0016C82C 34130000 ori        $s3, $zero, 0
0016C830 4484B000 mtc1       $a0, $f22
0016C834 26340004 addiu      $s4, $s1, 4
0016C838 0220B825 move       $s7, $s1
0016C83C 341E0001 ori        $fp, $zero, 1
0016C840 26D671B0 addiu      $s6, $s6, 0x71b0
0016C844 3C15002D lui        $s5, 0x2d
0016C848 8EA57148 lw         $a1, 0x7148($s5)
0016C84C 02802025 move       $a0, $s4
0016C850 0C0340F3 jal        0xd03cc
0016C854 02C03025 move       $a2, $s6
0016C858 0C06B652 jal        0x1ad948
0016C85C 00000000 nop        
0016C860 44826000 mtc1       $v0, $f12
0016C864 46806320 cvt.s.w    $f12, $f12
0016C868 46166302 mul.s      $f12, $f12, $f22
0016C86C 46146302 mul.s      $f12, $f12, $f20
0016C870 0C06B652 jal        0x1ad948
0016C874 E6EC00A4 swc1       $f12, 0xa4($s7)
0016C878 44826000 mtc1       $v0, $f12
0016C87C 46806320 cvt.s.w    $f12, $f12
0016C880 46166302 mul.s      $f12, $f12, $f22
0016C884 46146302 mul.s      $f12, $f12, $f20
0016C888 0C06B652 jal        0x1ad948
0016C88C E6EC00B4 swc1       $f12, 0xb4($s7)
0016C890 44826000 mtc1       $v0, $f12
0016C894 46806320 cvt.s.w    $f12, $f12
0016C898 46166302 mul.s      $f12, $f12, $f22
0016C89C 46146302 mul.s      $f12, $f12, $f20
0016C8A0 0C06B652 jal        0x1ad948
0016C8A4 E6EC00C4 swc1       $f12, 0xc4($s7)
0016C8A8 44826000 mtc1       $v0, $f12
0016C8AC 46806320 cvt.s.w    $f12, $f12
0016C8B0 46166302 mul.s      $f12, $f12, $f22
0016C8B4 46146302 mul.s      $f12, $f12, $f20
0016C8B8 0C06B652 jal        0x1ad948
0016C8BC E6EC00D4 swc1       $f12, 0xd4($s7)
0016C8C0 44826000 mtc1       $v0, $f12
0016C8C4 46806320 cvt.s.w    $f12, $f12
0016C8C8 46166302 mul.s      $f12, $f12, $f22
0016C8CC 46146302 mul.s      $f12, $f12, $f20
0016C8D0 0C06B652 jal        0x1ad948
0016C8D4 E6EC00E4 swc1       $f12, 0xe4($s7)
0016C8D8 44826000 mtc1       $v0, $f12
0016C8DC 46806320 cvt.s.w    $f12, $f12
0016C8E0 26730001 addiu      $s3, $s3, 1
0016C8E4 26940028 addiu      $s4, $s4, 0x28
0016C8E8 2E640004 sltiu      $a0, $s3, 4
0016C8EC 46166302 mul.s      $f12, $f12, $f22
0016C8F0 46146302 mul.s      $f12, $f12, $f20
0016C8F4 E6EC00F4 swc1       $f12, 0xf4($s7)
0016C8F8 1480FFD3 bnez       $a0, 0x16c848
0016C8FC 26F70004 addiu      $s7, $s7, 4
0016C900 8E44003C lw         $a0, 0x3c($s2)
0016C904 3C05002D lui        $a1, 0x2d
0016C908 AE241078 sw         $a0, 0x1078($s1)
0016C90C 00042080 sll        $a0, $a0, 2
0016C910 24A571F4 addiu      $a1, $a1, 0x71f4
0016C914 00852021 addu       $a0, $a0, $a1
0016C918 C48C0000 lwc1       $f12, ($a0)
0016C91C 3C04002D lui        $a0, 0x2d
0016C920 E62C1070 swc1       $f12, 0x1070($s1)
0016C924 8C8471DC lw         $a0, 0x71dc($a0)
0016C928 E6381074 swc1       $f24, 0x1074($s1)
0016C92C AE24106C sw         $a0, 0x106c($s1)
0016C930 E6381068 swc1       $f24, 0x1068($s1)
0016C934 8E24106C lw         $a0, 0x106c($s1)
0016C938 8E050064 lw         $a1, 0x64($s0)
0016C93C AE04006C sw         $a0, 0x6c($s0)
0016C940 34A40020 ori        $a0, $a1, 0x20
0016C944 AE040064 sw         $a0, 0x64($s0)
0016C948 E6180070 swc1       $f24, 0x70($s0)
0016C94C A2000045 sb         $zero, 0x45($s0)
0016C950 8E440040 lw         $a0, 0x40($s2)
0016C954 3C050006 lui        $a1, 6
0016C958 2484FFFF addiu      $a0, $a0, -1
0016C95C AE440040 sw         $a0, 0x40($s2)
0016C960 24A4A838 addiu      $a0, $a1, -0x57c8
0016C964 C48C0030 lwc1       $f12, 0x30($a0)
0016C968 3C120005 lui        $s2, 5
0016C96C E60C0030 swc1       $f12, 0x30($s0)
0016C970 C48C0034 lwc1       $f12, 0x34($a0)
0016C974 E60C0034 swc1       $f12, 0x34($s0)
0016C978 C48C0038 lwc1       $f12, 0x38($a0)
0016C97C E60C0038 swc1       $f12, 0x38($s0)
0016C980 8E5264A4 lw         $s2, 0x64a4($s2)
0016C984 1240000E beqz       $s2, 0x16c9c0
0016C988 00000000 nop        
0016C98C C64C0014 lwc1       $f12, 0x14($s2)
0016C990 C64D0018 lwc1       $f13, 0x18($s2)
0016C994 C64E001C lwc1       $f14, 0x1c($s2)
0016C998 2626107C addiu      $a2, $s1, 0x107c
0016C99C C64F0020 lwc1       $f15, 0x20($s2)
0016C9A0 34070000 ori        $a3, $zero, 0
0016C9A4 34090000 ori        $t1, $zero, 0
0016C9A8 340A0000 ori        $t2, $zero, 0
0016C9AC 02002025 move       $a0, $s0
0016C9B0 02402825 move       $a1, $s2
0016C9B4 00004025 move       $t0, $zero
0016C9B8 0C01B147 jal        0x6c51c
0016C9BC 03C05825 move       $t3, $fp
0016C9C0 3C040005 lui        $a0, 5
0016C9C4 8C8464A8 lw         $a0, 0x64a8($a0)
0016C9C8 1080000D beqz       $a0, 0x16ca00
0016C9CC 00802825 move       $a1, $a0
0016C9D0 C4AC0014 lwc1       $f12, 0x14($a1)
0016C9D4 C4AD0018 lwc1       $f13, 0x18($a1)
0016C9D8 C4AE001C lwc1       $f14, 0x1c($a1)
0016C9DC C4AF0020 lwc1       $f15, 0x20($a1)
0016C9E0 34070000 ori        $a3, $zero, 0
0016C9E4 34090000 ori        $t1, $zero, 0
0016C9E8 340A0000 ori        $t2, $zero, 0
0016C9EC 02002025 move       $a0, $s0
0016C9F0 00003025 move       $a2, $zero
0016C9F4 00004025 move       $t0, $zero
0016C9F8 0C01B147 jal        0x6c51c
0016C9FC 03C05825 move       $t3, $fp
0016CA00 92040044 lbu        $a0, 0x44($s0)
0016CA04 8E050040 lw         $a1, 0x40($s0)
0016CA08 00043100 sll        $a2, $a0, 4
0016CA0C 00862021 addu       $a0, $a0, $a2
0016CA10 8CA50004 lw         $a1, 4($a1)
0016CA14 00042080 sll        $a0, $a0, 2
0016CA18 00862023 subu       $a0, $a0, $a2
0016CA1C 00A42021 addu       $a0, $a1, $a0
0016CA20 8C840004 lw         $a0, 4($a0)
0016CA24 3C051000 lui        $a1, 0x1000
0016CA28 8C840004 lw         $a0, 4($a0)
0016CA2C 24A50006 addiu      $a1, $a1, 6
0016CA30 10850003 beq        $a0, $a1, 0x16ca40
0016CA34 00000000 nop        
0016CA38 10000040 b          0x16cb3c
0016CA3C 03C01025 move       $v0, $fp
0016CA40 3C044F80 lui        $a0, 0x4f80
0016CA44 4484A000 mtc1       $a0, $f20
0016CA48 3C130005 lui        $s3, 5
0016CA4C 3C044300 lui        $a0, 0x4300
0016CA50 34120000 ori        $s2, $zero, 0
0016CA54 4484B000 mtc1       $a0, $f22
0016CA58 267360A0 addiu      $s3, $s3, 0x60a0
0016CA5C 44926000 mtc1       $s2, $f12
0016CA60 46806320 cvt.s.w    $f12, $f12
0016CA64 06420001 bltzl      $s2, 0x16ca6c
0016CA68 46146300 add.s      $f12, $f12, $f20
0016CA6C 460CB301 sub.s      $f12, $f22, $f12
0016CA70 4600630D trunc.w.s  $f12, $f12
0016CA74 0C06B209 jal        0x1ac824
0016CA78 44046000 mfc1       $a0, $f12
0016CA7C 2444007F addiu      $a0, $v0, 0x7f
0016CA80 308500FF andi       $a1, $a0, 0xff
0016CA84 308600FF andi       $a2, $a0, 0xff
0016CA88 00052E00 sll        $a1, $a1, 0x18
0016CA8C 00063200 sll        $a2, $a2, 8
0016CA90 308700FF andi       $a3, $a0, 0xff
0016CA94 00A62825 or         $a1, $a1, $a2
0016CA98 00073400 sll        $a2, $a3, 0x10
0016CA9C 00A62825 or         $a1, $a1, $a2
0016CAA0 308400FF andi       $a0, $a0, 0xff
0016CAA4 00A42025 or         $a0, $a1, $a0
0016CAA8 AE640000 sw         $a0, ($s3)
0016CAAC 26520001 addiu      $s2, $s2, 1
0016CAB0 2E440100 sltiu      $a0, $s2, 0x100
0016CAB4 1480FFE9 bnez       $a0, 0x16ca5c
0016CAB8 26730004 addiu      $s3, $s3, 4
0016CABC E7B80030 swc1       $f24, 0x30($sp)
0016CAC0 3C04BF80 lui        $a0, 0xbf80
0016CAC4 44846000 mtc1       $a0, $f12
0016CAC8 E7B80038 swc1       $f24, 0x38($sp)
0016CACC E7AC0034 swc1       $f12, 0x34($sp)
0016CAD0 E7B8003C swc1       $f24, 0x3c($sp)
0016CAD4 27A50030 addiu      $a1, $sp, 0x30
0016CAD8 0C05B09D jal        0x16c274
0016CADC 02002025 move       $a0, $s0
0016CAE0 3C04002D lui        $a0, 0x2d
0016CAE4 AC827138 sw         $v0, 0x7138($a0)
0016CAE8 E7B80040 swc1       $f24, 0x40($sp)
0016CAEC 3C043F80 lui        $a0, 0x3f80
0016CAF0 44846000 mtc1       $a0, $f12
0016CAF4 E7B80048 swc1       $f24, 0x48($sp)
0016CAF8 E7AC0044 swc1       $f12, 0x44($sp)
0016CAFC E7B8004C swc1       $f24, 0x4c($sp)
0016CB00 27A50040 addiu      $a1, $sp, 0x40
0016CB04 0C05B09D jal        0x16c274
0016CB08 02002025 move       $a0, $s0
0016CB0C 3C04002D lui        $a0, 0x2d
0016CB10 AC82713C sw         $v0, 0x713c($a0)
0016CB14 26240108 addiu      $a0, $s1, 0x108
0016CB18 00002825 move       $a1, $zero
0016CB1C 0C06B6A7 jal        0x1ada9c
0016CB20 340607B0 ori        $a2, $zero, 0x7b0
0016CB24 262408B8 addiu      $a0, $s1, 0x8b8
0016CB28 00002825 move       $a1, $zero
0016CB2C 0C06B6A7 jal        0x1ada9c
0016CB30 340607B0 ori        $a2, $zero, 0x7b0
0016CB34 AE200104 sw         $zero, 0x104($s1)
0016CB38 03C01025 move       $v0, $fp
0016CB3C C7B40050 lwc1       $f20, 0x50($sp)
0016CB40 C7B60054 lwc1       $f22, 0x54($sp)
0016CB44 C7B80058 lwc1       $f24, 0x58($sp)
0016CB48 8FB0005C lw         $s0, 0x5c($sp)
0016CB4C 8FB10060 lw         $s1, 0x60($sp)
0016CB50 8FB20064 lw         $s2, 0x64($sp)
0016CB54 8FB30068 lw         $s3, 0x68($sp)
0016CB58 8FB4006C lw         $s4, 0x6c($sp)
0016CB5C 8FB50070 lw         $s5, 0x70($sp)
0016CB60 8FB60074 lw         $s6, 0x74($sp)
0016CB64 8FB70078 lw         $s7, 0x78($sp)
0016CB68 8FBE007C lw         $fp, 0x7c($sp)
0016CB6C 8FBF0080 lw         $ra, 0x80($sp)
0016CB70 03E00008 jr         $ra
0016CB74 27BD0090 addiu      $sp, $sp, 0x90

CALLBACK 0x0016BE08 end 0x0016C084 ordinal 1

0016BE08 27BDFF60 addiu      $sp, $sp, -0xa0
0016BE0C AFB10070 sw         $s1, 0x70($sp)
0016BE10 00808825 move       $s1, $a0
0016BE14 E7B40054 swc1       $f20, 0x54($sp)
0016BE18 E7B60058 swc1       $f22, 0x58($sp)
0016BE1C E7B8005C swc1       $f24, 0x5c($sp)
0016BE20 E7BA0060 swc1       $f26, 0x60($sp)
0016BE24 E7BC0064 swc1       $f28, 0x64($sp)
0016BE28 E7BE0068 swc1       $f30, 0x68($sp)
0016BE2C AFB0006C sw         $s0, 0x6c($sp)
0016BE30 AFB20074 sw         $s2, 0x74($sp)
0016BE34 AFB30078 sw         $s3, 0x78($sp)
0016BE38 AFB4007C sw         $s4, 0x7c($sp)
0016BE3C AFB50080 sw         $s5, 0x80($sp)
0016BE40 AFB60084 sw         $s6, 0x84($sp)
0016BE44 AFB70088 sw         $s7, 0x88($sp)
0016BE48 AFBE008C sw         $fp, 0x8c($sp)
0016BE4C AFBF0090 sw         $ra, 0x90($sp)
0016BE50 8E240058 lw         $a0, 0x58($s1)
0016BE54 4480E000 mtc1       $zero, $f28
0016BE58 AFA40048 sw         $a0, 0x48($sp)
0016BE5C 3C043149 lui        $a0, 0x3149
0016BE60 34840FDB ori        $a0, $a0, 0xfdb
0016BE64 4484C000 mtc1       $a0, $f24
0016BE68 3C044049 lui        $a0, 0x4049
0016BE6C 34840FDB ori        $a0, $a0, 0xfdb
0016BE70 4484D000 mtc1       $a0, $f26
0016BE74 34100000 ori        $s0, $zero, 0
0016BE78 3C043080 lui        $a0, 0x3080
0016BE7C 4484A000 mtc1       $a0, $f20
0016BE80 27BE0030 addiu      $fp, $sp, 0x30
0016BE84 3C043F80 lui        $a0, 0x3f80
0016BE88 4484B000 mtc1       $a0, $f22
0016BE8C 27B7003C addiu      $s7, $sp, 0x3c
0016BE90 3C043000 lui        $a0, 0x3000
0016BE94 4484F000 mtc1       $a0, $f30
0016BE98 3C13002D lui        $s3, 0x2d
0016BE9C 3C12002D lui        $s2, 0x2d
0016BEA0 3C16002D lui        $s6, 0x2d
0016BEA4 3C15002D lui        $s5, 0x2d
0016BEA8 3C14002D lui        $s4, 0x2d
0016BEAC 0C06B652 jal        0x1ad948
0016BEB0 E7BE004C swc1       $f30, 0x4c($sp)
0016BEB4 44826000 mtc1       $v0, $f12
0016BEB8 46806320 cvt.s.w    $f12, $f12
0016BEBC 46146302 mul.s      $f12, $f12, $f20
0016BEC0 46166301 sub.s      $f12, $f12, $f22
0016BEC4 0C06B652 jal        0x1ad948
0016BEC8 E7AC0044 swc1       $f12, 0x44($sp)
0016BECC 44826000 mtc1       $v0, $f12
0016BED0 46806320 cvt.s.w    $f12, $f12
0016BED4 46186302 mul.s      $f12, $f12, $f24
0016BED8 461A6781 sub.s      $f30, $f12, $f26
0016BEDC 0C06D6C8 jal        0x1b5b20
0016BEE0 4600F306 mov.s      $f12, $f30
0016BEE4 46000306 mov.s      $f12, $f0
0016BEE8 460C6342 mul.s      $f13, $f12, $f12
0016BEEC 461CF03C c.lt.s     $f30, $f28
0016BEF0 C7BE004C lwc1       $f30, 0x4c($sp)
0016BEF4 460DB341 sub.s      $f13, $f22, $f13
0016BEF8 46006B44 sqrt.s     $f13, $f13
0016BEFC 45030001 bc1tl      0x16bf04
0016BF00 46006B47 neg.s      $f13, $f13
0016BF04 E7B80050 swc1       $f24, 0x50($sp)
0016BF08 E7BA004C swc1       $f26, 0x4c($sp)
0016BF0C C7AE0044 lwc1       $f14, 0x44($sp)
0016BF10 460E73C2 mul.s      $f15, $f14, $f14
0016BF14 C6300030 lwc1       $f16, 0x30($s1)
0016BF18 C6310034 lwc1       $f17, 0x34($s1)
0016BF1C C6320038 lwc1       $f18, 0x38($s1)
0016BF20 460FB3C1 sub.s      $f15, $f22, $f15
0016BF24 C6737218 lwc1       $f19, 0x7218($s3)
0016BF28 3C04002D lui        $a0, 0x2d
0016BF2C 46127380 add.s      $f14, $f14, $f18
0016BF30 C480721C lwc1       $f0, 0x721c($a0)
0016BF34 46007BC4 sqrt.s     $f15, $f15
0016BF38 460F6302 mul.s      $f12, $f12, $f15
0016BF3C 460F6B42 mul.s      $f13, $f13, $f15
0016BF40 46130681 sub.s      $f26, $f0, $f19
0016BF44 46106400 add.s      $f16, $f12, $f16
0016BF48 E7AC003C swc1       $f12, 0x3c($sp)
0016BF4C E7AD0040 swc1       $f13, 0x40($sp)
0016BF50 E7AE0038 swc1       $f14, 0x38($sp)
0016BF54 46116B00 add.s      $f12, $f13, $f17
0016BF58 E7B00030 swc1       $f16, 0x30($sp)
0016BF5C 0C06B652 jal        0x1ad948
0016BF60 E7AC0034 swc1       $f12, 0x34($sp)
0016BF64 44826000 mtc1       $v0, $f12
0016BF68 46806320 cvt.s.w    $f12, $f12
0016BF6C C66D7218 lwc1       $f13, 0x7218($s3)
0016BF70 C64E7224 lwc1       $f14, 0x7224($s2)
0016BF74 3C04002D lui        $a0, 0x2d
0016BF78 C48F7228 lwc1       $f15, 0x7228($a0)
0016BF7C 461E6302 mul.s      $f12, $f12, $f30
0016BF80 460E7E01 sub.s      $f24, $f15, $f14
0016BF84 461A6302 mul.s      $f12, $f12, $f26
0016BF88 0C06B652 jal        0x1ad948
0016BF8C 460C6E80 add.s      $f26, $f13, $f12
0016BF90 44828000 mtc1       $v0, $f16
0016BF94 C64F7224 lwc1       $f15, 0x7224($s2)
0016BF98 46808420 cvt.s.w    $f16, $f16
0016BF9C 8FA40048 lw         $a0, 0x48($sp)
0016BFA0 C6CE7220 lwc1       $f14, 0x7220($s6)
0016BFA4 4600D306 mov.s      $f12, $f26
0016BFA8 03C02825 move       $a1, $fp
0016BFAC 461E8342 mul.s      $f13, $f16, $f30
0016BFB0 02E03025 move       $a2, $s7
0016BFB4 00004025 move       $t0, $zero
0016BFB8 00004825 move       $t1, $zero
0016BFBC 46186C82 mul.s      $f18, $f13, $f24
0016BFC0 C6B07230 lwc1       $f16, 0x7230($s5)
0016BFC4 8C87106C lw         $a3, 0x106c($a0)
0016BFC8 C691722C lwc1       $f17, 0x722c($s4)
0016BFCC 3C04002D lui        $a0, 0x2d
0016BFD0 8C847250 lw         $a0, 0x7250($a0)
0016BFD4 4600E346 mov.s      $f13, $f28
0016BFD8 0C032A92 jal        0xcaa48
0016BFDC 46127BC0 add.s      $f15, $f15, $f18
0016BFE0 26100001 addiu      $s0, $s0, 1
0016BFE4 C7BA004C lwc1       $f26, 0x4c($sp)
0016BFE8 2E040064 sltiu      $a0, $s0, 0x64
0016BFEC 1480FFAF bnez       $a0, 0x16beac
0016BFF0 C7B80050 lwc1       $f24, 0x50($sp)
0016BFF4 0C00C5F6 jal        0x317d8
0016BFF8 00000000 nop        
0016BFFC 8FB20048 lw         $s2, 0x48($sp)
0016C000 34100000 ori        $s0, $zero, 0
0016C004 26510004 addiu      $s1, $s2, 4
0016C008 0C02320E jal        0x8c838
0016C00C 02202025 move       $a0, $s1
0016C010 26100001 addiu      $s0, $s0, 1
0016C014 2E040004 sltiu      $a0, $s0, 4
0016C018 1480FFFB bnez       $a0, 0x16c008
0016C01C 26310028 addiu      $s1, $s1, 0x28
0016C020 8E44107C lw         $a0, 0x107c($s2)
0016C024 10800005 beqz       $a0, 0x16c03c
0016C028 00000000 nop        
0016C02C 0C01B1A3 jal        0x6c68c
0016C030 AFB20048 sw         $s2, 0x48($sp)
0016C034 8FA40048 lw         $a0, 0x48($sp)
0016C038 AC80107C sw         $zero, 0x107c($a0)
0016C03C C7B40054 lwc1       $f20, 0x54($sp)
0016C040 C7B60058 lwc1       $f22, 0x58($sp)
0016C044 C7B8005C lwc1       $f24, 0x5c($sp)
0016C048 C7BA0060 lwc1       $f26, 0x60($sp)
0016C04C C7BC0064 lwc1       $f28, 0x64($sp)
0016C050 C7BE0068 lwc1       $f30, 0x68($sp)
0016C054 8FB0006C lw         $s0, 0x6c($sp)
0016C058 8FB10070 lw         $s1, 0x70($sp)
0016C05C 8FB20074 lw         $s2, 0x74($sp)
0016C060 8FB30078 lw         $s3, 0x78($sp)
0016C064 8FB4007C lw         $s4, 0x7c($sp)
0016C068 8FB50080 lw         $s5, 0x80($sp)
0016C06C 8FB60084 lw         $s6, 0x84($sp)
0016C070 8FB70088 lw         $s7, 0x88($sp)
0016C074 8FBE008C lw         $fp, 0x8c($sp)
0016C078 8FBF0090 lw         $ra, 0x90($sp)
0016C07C 03E00008 jr         $ra
0016C080 27BD00A0 addiu      $sp, $sp, 0xa0

CALLBACK 0x0016CB78 end 0x0016D37C ordinal 2

0016CB78 27BDFF00 addiu      $sp, $sp, -0x100
0016CB7C AFB200E0 sw         $s2, 0xe0($sp)
0016CB80 00809025 move       $s2, $a0
0016CB84 AFB300E4 sw         $s3, 0xe4($sp)
0016CB88 8E530058 lw         $s3, 0x58($s2)
0016CB8C E7B400CC swc1       $f20, 0xcc($sp)
0016CB90 E7B600D0 swc1       $f22, 0xd0($sp)
0016CB94 E7B800D4 swc1       $f24, 0xd4($sp)
0016CB98 AFB000D8 sw         $s0, 0xd8($sp)
0016CB9C AFB100DC sw         $s1, 0xdc($sp)
0016CBA0 AFB400E8 sw         $s4, 0xe8($sp)
0016CBA4 AFB500EC sw         $s5, 0xec($sp)
0016CBA8 AFB600F0 sw         $s6, 0xf0($sp)
0016CBAC AFB700F4 sw         $s7, 0xf4($sp)
0016CBB0 AFBE00F8 sw         $fp, 0xf8($sp)
0016CBB4 AFBF00FC sw         $ra, 0xfc($sp)
0016CBB8 0C00C04D jal        0x30134
0016CBBC 8E640000 lw         $a0, ($s3)
0016CBC0 1440000C bnez       $v0, 0x16cbf4
0016CBC4 00000000 nop        
0016CBC8 0C01D56C jal        0x755b0
0016CBCC 00000000 nop        
0016CBD0 34048000 ori        $a0, $zero, 0x8000
0016CBD4 10440007 beq        $v0, $a0, 0x16cbf4
0016CBD8 00000000 nop        
0016CBDC 92440045 lbu        $a0, 0x45($s2)
0016CBE0 34050001 ori        $a1, $zero, 1
0016CBE4 50850008 beql       $a0, $a1, 0x16cc08
0016CBE8 8E641078 lw         $a0, 0x1078($s3)
0016CBEC 100000C8 b          0x16cf10
0016CBF0 00000000 nop        
0016CBF4 02402025 move       $a0, $s2
0016CBF8 0C01A8F0 jal        0x6a3c0
0016CBFC 34050001 ori        $a1, $zero, 1
0016CC00 100001CF b          0x16d340
0016CC04 00000000 nop        
0016CC08 3C05002D lui        $a1, 0x2d
0016CC0C 00042080 sll        $a0, $a0, 2
0016CC10 24A571F4 addiu      $a1, $a1, 0x71f4
0016CC14 00852021 addu       $a0, $a0, $a1
0016CC18 C66C1070 lwc1       $f12, 0x1070($s3)
0016CC1C 3C05002D lui        $a1, 0x2d
0016CC20 8CA571E0 lw         $a1, 0x71e0($a1)
0016CC24 C48D0000 lwc1       $f13, ($a0)
0016CC28 3C04002D lui        $a0, 0x2d
0016CC2C 460D6303 div.s      $f12, $f12, $f13
0016CC30 8C8671DC lw         $a2, 0x71dc($a0)
0016CC34 00A02025 move       $a0, $a1
0016CC38 0C03C93C jal        0xf24f0
0016CC3C 00C02825 move       $a1, $a2
0016CC40 C66C1068 lwc1       $f12, 0x1068($s3)
0016CC44 AE62106C sw         $v0, 0x106c($s3)
0016CC48 44807000 mtc1       $zero, $f14
0016CC4C 460E6032 c.eq.s     $f12, $f14
0016CC50 00000000 nop        
0016CC54 45010006 bc1t       0x16cc70
0016CC58 341E0003 ori        $fp, $zero, 3
0016CC5C 3C04BF80 lui        $a0, 0xbf80
0016CC60 44846800 mtc1       $a0, $f13
0016CC64 460D6300 add.s      $f12, $f12, $f13
0016CC68 1000000E b          0x16cca4
0016CC6C E66C1068 swc1       $f12, 0x1068($s3)
0016CC70 34040007 ori        $a0, $zero, 7
0016CC74 0C00810D jal        0x20434
0016CC78 2405FFFF addiu      $a1, $zero, -1
0016CC7C 28440003 slti       $a0, $v0, 3
0016CC80 14800008 bnez       $a0, 0x16cca4
0016CC84 00000000 nop        
0016CC88 0C05BBD8 jal        0x16ef60
0016CC8C 02402025 move       $a0, $s2
0016CC90 10400004 beqz       $v0, 0x16cca4
0016CC94 00000000 nop        
0016CC98 3C044316 lui        $a0, 0x4316
0016CC9C 44846000 mtc1       $a0, $f12
0016CCA0 E66C1068 swc1       $f12, 0x1068($s3)
0016CCA4 8E641080 lw         $a0, 0x1080($s3)
0016CCA8 10800003 beqz       $a0, 0x16ccb8
0016CCAC 00000000 nop        
0016CCB0 2484FFFF addiu      $a0, $a0, -1
0016CCB4 AE641080 sw         $a0, 0x1080($s3)
0016CCB8 34040007 ori        $a0, $zero, 7
0016CCBC 0C00810D jal        0x20434
0016CCC0 2405FFFF addiu      $a1, $zero, -1
0016CCC4 00408025 move       $s0, $v0
0016CCC8 2E040001 sltiu      $a0, $s0, 1
0016CCCC 1480008E bnez       $a0, 0x16cf08
0016CCD0 00000000 nop        
0016CCD4 3C08002D lui        $t0, 0x2d
0016CCD8 C50C7258 lwc1       $f12, 0x7258($t0)
0016CCDC 27A40040 addiu      $a0, $sp, 0x40
0016CCE0 26460030 addiu      $a2, $s2, 0x30
0016CCE4 34050010 ori        $a1, $zero, 0x10
0016CCE8 34070169 ori        $a3, $zero, 0x169
0016CCEC 34080101 ori        $t0, $zero, 0x101
0016CCF0 34090002 ori        $t1, $zero, 2
0016CCF4 0C005BA6 jal        0x16e98
0016CCF8 340A0001 ori        $t2, $zero, 1
0016CCFC 0040A025 move       $s4, $v0
0016CD00 34110000 ori        $s1, $zero, 0
0016CD04 0234202B sltu       $a0, $s1, $s4
0016CD08 10800059 beqz       $a0, 0x16ce70
0016CD0C 34050000 ori        $a1, $zero, 0
0016CD10 3C043480 lui        $a0, 0x3480
0016CD14 4484A000 mtc1       $a0, $f20
0016CD18 261700D7 addiu      $s7, $s0, 0xd7
0016CD1C 3C043F80 lui        $a0, 0x3f80
0016CD20 4484C000 mtc1       $a0, $f24
0016CD24 3C16002D lui        $s6, 0x2d
0016CD28 3C043F00 lui        $a0, 0x3f00
0016CD2C 27B50080 addiu      $s5, $sp, 0x80
0016CD30 4484B000 mtc1       $a0, $f22
0016CD34 03A08025 move       $s0, $sp
0016CD38 26D6B0CC addiu      $s6, $s6, -0x4f34
0016CD3C 8E040040 lw         $a0, 0x40($s0)
0016CD40 8C860040 lw         $a2, 0x40($a0)
0016CD44 10C00046 beqz       $a2, 0x16ce60
0016CD48 00000000 nop        
0016CD4C 8CC60020 lw         $a2, 0x20($a2)
0016CD50 10C00043 beqz       $a2, 0x16ce60
0016CD54 00000000 nop        
0016CD58 24850030 addiu      $a1, $a0, 0x30
0016CD5C C4AC0000 lwc1       $f12, ($a1)
0016CD60 C64D0030 lwc1       $f13, 0x30($s2)
0016CD64 C64E0034 lwc1       $f14, 0x34($s2)
0016CD68 460C6B01 sub.s      $f12, $f13, $f12
0016CD6C C64F0038 lwc1       $f15, 0x38($s2)
0016CD70 E7AC0080 swc1       $f12, 0x80($sp)
0016CD74 C4AD0004 lwc1       $f13, 4($a1)
0016CD78 460C6402 mul.s      $f16, $f12, $f12
0016CD7C 460D7341 sub.s      $f13, $f14, $f13
0016CD80 E7AD0084 swc1       $f13, 0x84($sp)
0016CD84 460D6C42 mul.s      $f17, $f13, $f13
0016CD88 C4AE0008 lwc1       $f14, 8($a1)
0016CD8C 460E7B81 sub.s      $f14, $f15, $f14
0016CD90 461183C0 add.s      $f15, $f16, $f17
0016CD94 460E7482 mul.s      $f18, $f14, $f14
0016CD98 46127BC0 add.s      $f15, $f15, $f18
0016CD9C 4614783C c.lt.s     $f15, $f20
0016CDA0 00000000 nop        
0016CDA4 45010009 bc1t       0x16cdcc
0016CDA8 E7AE0088 swc1       $f14, 0x88($sp)
0016CDAC 46007BC4 sqrt.s     $f15, $f15
0016CDB0 460FC3C3 div.s      $f15, $f24, $f15
0016CDB4 460F6302 mul.s      $f12, $f12, $f15
0016CDB8 460F6B42 mul.s      $f13, $f13, $f15
0016CDBC 460F7382 mul.s      $f14, $f14, $f15
0016CDC0 E7AC0080 swc1       $f12, 0x80($sp)
0016CDC4 E7AD0084 swc1       $f13, 0x84($sp)
0016CDC8 E7AE0088 swc1       $f14, 0x88($sp)
0016CDCC 00803025 move       $a2, $a0
0016CDD0 8CC70040 lw         $a3, 0x40($a2)
0016CDD4 8CE70020 lw         $a3, 0x20($a3)
0016CDD8 54E00004 bnel       $a3, $zero, 0x16cdec
0016CDDC 00172100 sll        $a0, $s7, 4
0016CDE0 2405FFFF addiu      $a1, $zero, -1
0016CDE4 10000017 b          0x16ce44
0016CDE8 8E660000 lw         $a2, ($s3)
0016CDEC 00962021 addu       $a0, $a0, $s6
0016CDF0 8C880000 lw         $t0, ($a0)
0016CDF4 29090002 slti       $t1, $t0, 2
0016CDF8 15200006 bnez       $t1, 0x16ce14
0016CDFC C48C0004 lwc1       $f12, 4($a0)
0016CE00 29080003 slti       $t0, $t0, 3
0016CE04 11000003 beqz       $t0, 0x16ce14
0016CE08 00000000 nop        
0016CE0C 10000001 b          0x16ce14
0016CE10 46166302 mul.s      $f12, $f12, $f22
0016CE14 00E05025 move       $t2, $a3
0016CE18 00A03825 move       $a3, $a1
0016CE1C 8C850008 lw         $a1, 8($a0)
0016CE20 8C89000C lw         $t1, 0xc($a0)
0016CE24 00C02025 move       $a0, $a2
0016CE28 01203025 move       $a2, $t1
0016CE2C 02A04025 move       $t0, $s5
0016CE30 0140F809 jalr       $t2
0016CE34 02404825 move       $t1, $s2
0016CE38 8E660000 lw         $a2, ($s3)
0016CE3C 00402825 move       $a1, $v0
0016CE40 8E040040 lw         $a0, 0x40($s0)
0016CE44 00804025 move       $t0, $a0
0016CE48 00A03825 move       $a3, $a1
0016CE4C 00C02025 move       $a0, $a2
0016CE50 34050007 ori        $a1, $zero, 7
0016CE54 0C004249 jal        0x10924
0016CE58 01003025 move       $a2, $t0
0016CE5C 34050001 ori        $a1, $zero, 1
0016CE60 26310001 addiu      $s1, $s1, 1
0016CE64 0234202B sltu       $a0, $s1, $s4
0016CE68 1480FFB4 bnez       $a0, 0x16cd3c
0016CE6C 26100004 addiu      $s0, $s0, 4
0016CE70 8E641080 lw         $a0, 0x1080($s3)
0016CE74 14800024 bnez       $a0, 0x16cf08
0016CE78 00000000 nop        
0016CE7C 10A00022 beqz       $a1, 0x16cf08
0016CE80 00000000 nop        
0016CE84 0C00024C jal        0x930
0016CE88 34040002 ori        $a0, $zero, 2
0016CE8C 3C054F00 lui        $a1, 0x4f00
0016CE90 00402025 move       $a0, $v0
0016CE94 1080000E beqz       $a0, 0x16ced0
0016CE98 4485A000 mtc1       $a1, $f20
0016CE9C 00802825 move       $a1, $a0
0016CEA0 C4AC0014 lwc1       $f12, 0x14($a1)
0016CEA4 C4AD0018 lwc1       $f13, 0x18($a1)
0016CEA8 C4AE001C lwc1       $f14, 0x1c($a1)
0016CEAC C4AF0020 lwc1       $f15, 0x20($a1)
0016CEB0 34070000 ori        $a3, $zero, 0
0016CEB4 34090000 ori        $t1, $zero, 0
0016CEB8 340A0000 ori        $t2, $zero, 0
0016CEBC 340B0001 ori        $t3, $zero, 1
0016CEC0 02402025 move       $a0, $s2
0016CEC4 00003025 move       $a2, $zero
0016CEC8 0C01B147 jal        0x6c51c
0016CECC 00004025 move       $t0, $zero
0016CED0 3C04002D lui        $a0, 0x2d
0016CED4 C48C725C lwc1       $f12, 0x725c($a0)
0016CED8 4614603C c.lt.s     $f12, $f20
0016CEDC 00000000 nop        
0016CEE0 45020004 bc1fl      0x16cef4
0016CEE4 46146301 sub.s      $f12, $f12, $f20
0016CEE8 4600630D trunc.w.s  $f12, $f12
0016CEEC 10000005 b          0x16cf04
0016CEF0 44046000 mfc1       $a0, $f12
0016CEF4 3C048000 lui        $a0, 0x8000
0016CEF8 4600630D trunc.w.s  $f12, $f12
0016CEFC 44056000 mfc1       $a1, $f12
0016CF00 00A42021 addu       $a0, $a1, $a0
0016CF04 AE641080 sw         $a0, 0x1080($s3)
0016CF08 10000053 b          0x16d058
0016CF0C 00000000 nop        
0016CF10 14800008 bnez       $a0, 0x16cf34
0016CF14 00000000 nop        
0016CF18 8E640000 lw         $a0, ($s3)
0016CF1C 0C00C5F2 jal        0x317c8
0016CF20 02402825 move       $a1, $s2
0016CF24 34040001 ori        $a0, $zero, 1
0016CF28 A2440045 sb         $a0, 0x45($s2)
0016CF2C 1000004A b          0x16d058
0016CF30 341E0003 ori        $fp, $zero, 3
0016CF34 34050002 ori        $a1, $zero, 2
0016CF38 14850034 bne        $a0, $a1, 0x16d00c
0016CF3C 00000000 nop        
0016CF40 92440046 lbu        $a0, 0x46($s2)
0016CF44 28840003 slti       $a0, $a0, 3
0016CF48 10800008 beqz       $a0, 0x16cf6c
0016CF4C 00000000 nop        
0016CF50 2404FFFF addiu      $a0, $zero, -1
0016CF54 AE64106C sw         $a0, 0x106c($s3)
0016CF58 92440046 lbu        $a0, 0x46($s2)
0016CF5C 341E0003 ori        $fp, $zero, 3
0016CF60 24840001 addiu      $a0, $a0, 1
0016CF64 1000003C b          0x16d058
0016CF68 A2440046 sb         $a0, 0x46($s2)
0016CF6C C66C1074 lwc1       $f12, 0x1074($s3)
0016CF70 44806800 mtc1       $zero, $f13
0016CF74 460D603E c.le.s     $f12, $f13
0016CF78 00000000 nop        
0016CF7C 45010007 bc1t       0x16cf9c
0016CF80 00000000 nop        
0016CF84 0C06B652 jal        0x1ad948
0016CF88 34100022 ori        $s0, $zero, 0x22
0016CF8C 0050001A div        $zero, $v0, $s0
0016CF90 00002010 mfhi       $a0
0016CF94 10000004 b          0x16cfa8
0016CF98 341E0003 ori        $fp, $zero, 3
0016CF9C 34040001 ori        $a0, $zero, 1
0016CFA0 100000E7 b          0x16d340
0016CFA4 A2440045 sb         $a0, 0x45($s2)
0016CFA8 3C050100 lui        $a1, 0x100
0016CFAC 24840033 addiu      $a0, $a0, 0x33
0016CFB0 24A5FFFF addiu      $a1, $a1, -1
0016CFB4 00052824 and        $a1, $zero, $a1
0016CFB8 00043600 sll        $a2, $a0, 0x18
0016CFBC 00A62825 or         $a1, $a1, $a2
0016CFC0 AE60106C sw         $zero, 0x106c($s3)
0016CFC4 2406FF00 addiu      $a2, $zero, -0x100
0016CFC8 00A63024 and        $a2, $a1, $a2
0016CFCC AE65106C sw         $a1, 0x106c($s3)
0016CFD0 00C42825 or         $a1, $a2, $a0
0016CFD4 3C06FFFF lui        $a2, 0xffff
0016CFD8 24C600FF addiu      $a2, $a2, 0xff
0016CFDC AE65106C sw         $a1, 0x106c($s3)
0016CFE0 00A62824 and        $a1, $a1, $a2
0016CFE4 00043200 sll        $a2, $a0, 8
0016CFE8 00A62825 or         $a1, $a1, $a2
0016CFEC 3C06FF01 lui        $a2, 0xff01
0016CFF0 AE65106C sw         $a1, 0x106c($s3)
0016CFF4 24C6FFFF addiu      $a2, $a2, -1
0016CFF8 00A62824 and        $a1, $a1, $a2
0016CFFC 00042400 sll        $a0, $a0, 0x10
0016D000 00A42025 or         $a0, $a1, $a0
0016D004 10000014 b          0x16d058
0016D008 AE64106C sw         $a0, 0x106c($s3)
0016D00C 341E0003 ori        $fp, $zero, 3
0016D010 149E0011 bne        $a0, $fp, 0x16d058
0016D014 3C043D08 lui        $a0, 0x3d08
0016D018 C64C0070 lwc1       $f12, 0x70($s2)
0016D01C 34848889 ori        $a0, $a0, 0x8889
0016D020 44846800 mtc1       $a0, $f13
0016D024 460D6300 add.s      $f12, $f12, $f13
0016D028 3C04002D lui        $a0, 0x2d
0016D02C E64C0070 swc1       $f12, 0x70($s2)
0016D030 C48E714C lwc1       $f14, 0x714c($a0)
0016D034 460E603C c.lt.s     $f12, $f14
0016D038 00000000 nop        
0016D03C 45010004 bc1t       0x16d050
0016D040 00000000 nop        
0016D044 02402025 move       $a0, $s2
0016D048 0C01A8F0 jal        0x6a3c0
0016D04C 34050001 ori        $a1, $zero, 1
0016D050 100000BB b          0x16d340
0016D054 00000000 nop        
0016D058 C66C1074 lwc1       $f12, 0x1074($s3)
0016D05C 3C04BF80 lui        $a0, 0xbf80
0016D060 44846800 mtc1       $a0, $f13
0016D064 3C050017 lui        $a1, 0x17
0016D068 460D6300 add.s      $f12, $f12, $f13
0016D06C 02402025 move       $a0, $s2
0016D070 34060004 ori        $a2, $zero, 4
0016D074 24A5C558 addiu      $a1, $a1, -0x3aa8
0016D078 0C01B1D0 jal        0x6c740
0016D07C E66C1074 swc1       $f12, 0x1074($s3)
0016D080 0C05BAAD jal        0x16eab4
0016D084 02402025 move       $a0, $s2
0016D088 44806000 mtc1       $zero, $f12
0016D08C 3C043F80 lui        $a0, 0x3f80
0016D090 E7AC0030 swc1       $f12, 0x30($sp)
0016D094 4484A000 mtc1       $a0, $f20
0016D098 E7AC0034 swc1       $f12, 0x34($sp)
0016D09C E7AC0038 swc1       $f12, 0x38($sp)
0016D0A0 E7B4003C swc1       $f20, 0x3c($sp)
0016D0A4 8E640000 lw         $a0, ($s3)
0016D0A8 248401A8 addiu      $a0, $a0, 0x1a8
0016D0AC C48C0000 lwc1       $f12, ($a0)
0016D0B0 E7AC0030 swc1       $f12, 0x30($sp)
0016D0B4 C48C0004 lwc1       $f12, 4($a0)
0016D0B8 E7AC0034 swc1       $f12, 0x34($sp)
0016D0BC C48C0008 lwc1       $f12, 8($a0)
0016D0C0 3C10002D lui        $s0, 0x2d
0016D0C4 E7AC0038 swc1       $f12, 0x38($sp)
0016D0C8 C48C000C lwc1       $f12, 0xc($a0)
0016D0CC E7AC003C swc1       $f12, 0x3c($sp)
0016D0D0 8E640000 lw         $a0, ($s3)
0016D0D4 C60C7234 lwc1       $f12, 0x7234($s0)
0016D0D8 C48D0264 lwc1       $f13, 0x264($a0)
0016D0DC 460C683E c.le.s     $f13, $f12
0016D0E0 00000000 nop        
0016D0E4 4501001D bc1t       0x16d15c
0016D0E8 3C11002D lui        $s1, 0x2d
0016D0EC C7AF0030 lwc1       $f15, 0x30($sp)
0016D0F0 C7AE0034 lwc1       $f14, 0x34($sp)
0016D0F4 460F7B02 mul.s      $f12, $f15, $f15
0016D0F8 C7AD0038 lwc1       $f13, 0x38($sp)
0016D0FC 460E7402 mul.s      $f16, $f14, $f14
0016D100 3C043480 lui        $a0, 0x3480
0016D104 460D6C42 mul.s      $f17, $f13, $f13
0016D108 44849000 mtc1       $a0, $f18
0016D10C 46106300 add.s      $f12, $f12, $f16
0016D110 46116300 add.s      $f12, $f12, $f17
0016D114 4612603C c.lt.s     $f12, $f18
0016D118 00000000 nop        
0016D11C 45010009 bc1t       0x16d144
0016D120 27A40030 addiu      $a0, $sp, 0x30
0016D124 46006304 sqrt.s     $f12, $f12
0016D128 460CA303 div.s      $f12, $f20, $f12
0016D12C 460C7BC2 mul.s      $f15, $f15, $f12
0016D130 460C7382 mul.s      $f14, $f14, $f12
0016D134 E7AF0030 swc1       $f15, 0x30($sp)
0016D138 460C6B02 mul.s      $f12, $f13, $f12
0016D13C E7AE0034 swc1       $f14, 0x34($sp)
0016D140 E7AC0038 swc1       $f12, 0x38($sp)
0016D144 00803025 move       $a2, $a0
0016D148 02402025 move       $a0, $s2
0016D14C 0C05BA28 jal        0x16e8a0
0016D150 34050001 ori        $a1, $zero, 1
0016D154 8E640000 lw         $a0, ($s3)
0016D158 C60C7234 lwc1       $f12, 0x7234($s0)
0016D15C 248401A8 addiu      $a0, $a0, 0x1a8
0016D160 C48D0000 lwc1       $f13, ($a0)
0016D164 E7AD0030 swc1       $f13, 0x30($sp)
0016D168 C48D0004 lwc1       $f13, 4($a0)
0016D16C E7AD0034 swc1       $f13, 0x34($sp)
0016D170 C48D0008 lwc1       $f13, 8($a0)
0016D174 E7AD0038 swc1       $f13, 0x38($sp)
0016D178 C48D000C lwc1       $f13, 0xc($a0)
0016D17C E7AD003C swc1       $f13, 0x3c($sp)
0016D180 8E640000 lw         $a0, ($s3)
0016D184 C48D0264 lwc1       $f13, 0x264($a0)
0016D188 460C683E c.le.s     $f13, $f12
0016D18C 00000000 nop        
0016D190 4501003B bc1t       0x16d280
0016D194 00000000 nop        
0016D198 C7AC0030 lwc1       $f12, 0x30($sp)
0016D19C C7AD0034 lwc1       $f13, 0x34($sp)
0016D1A0 460C63C2 mul.s      $f15, $f12, $f12
0016D1A4 C7AE0038 lwc1       $f14, 0x38($sp)
0016D1A8 460D6C02 mul.s      $f16, $f13, $f13
0016D1AC 3C043480 lui        $a0, 0x3480
0016D1B0 460E7442 mul.s      $f17, $f14, $f14
0016D1B4 3C10002D lui        $s0, 0x2d
0016D1B8 44849000 mtc1       $a0, $f18
0016D1BC 46107BC0 add.s      $f15, $f15, $f16
0016D1C0 27A40030 addiu      $a0, $sp, 0x30
0016D1C4 46117BC0 add.s      $f15, $f15, $f17
0016D1C8 4612783C c.lt.s     $f15, $f18
0016D1CC 00000000 nop        
0016D1D0 45010009 bc1t       0x16d1f8
0016D1D4 C61071D4 lwc1       $f16, 0x71d4($s0)
0016D1D8 46007BC4 sqrt.s     $f15, $f15
0016D1DC 460FA3C3 div.s      $f15, $f20, $f15
0016D1E0 460F6302 mul.s      $f12, $f12, $f15
0016D1E4 460F6B42 mul.s      $f13, $f13, $f15
0016D1E8 460F7382 mul.s      $f14, $f14, $f15
0016D1EC E7AC0030 swc1       $f12, 0x30($sp)
0016D1F0 E7AD0034 swc1       $f13, 0x34($sp)
0016D1F4 E7AE0038 swc1       $f14, 0x38($sp)
0016D1F8 00803825 move       $a3, $a0
0016D1FC 46008306 mov.s      $f12, $f16
0016D200 27A40090 addiu      $a0, $sp, 0x90
0016D204 27A50094 addiu      $a1, $sp, 0x94
0016D208 26460030 addiu      $a2, $s2, 0x30
0016D20C 34080068 ori        $t0, $zero, 0x68
0016D210 34090000 ori        $t1, $zero, 0
0016D214 0C006D3C jal        0x1b4f0
0016D218 00005025 move       $t2, $zero
0016D21C 10400018 beqz       $v0, 0x16d280
0016D220 00000000 nop        
0016D224 C7AC0030 lwc1       $f12, 0x30($sp)
0016D228 C60D71D4 lwc1       $f13, 0x71d4($s0)
0016D22C C64E0030 lwc1       $f14, 0x30($s2)
0016D230 C7AF0034 lwc1       $f15, 0x34($sp)
0016D234 460D6302 mul.s      $f12, $f12, $f13
0016D238 AFA000B0 sw         $zero, 0xb0($sp)
0016D23C AFA000B4 sw         $zero, 0xb4($sp)
0016D240 460D7BC2 mul.s      $f15, $f15, $f13
0016D244 C6500034 lwc1       $f16, 0x34($s2)
0016D248 C7B10038 lwc1       $f17, 0x38($sp)
0016D24C 460C7300 add.s      $f12, $f14, $f12
0016D250 AFA000B8 sw         $zero, 0xb8($sp)
0016D254 460D8B42 mul.s      $f13, $f17, $f13
0016D258 C6520038 lwc1       $f18, 0x38($s2)
0016D25C 460F83C0 add.s      $f15, $f16, $f15
0016D260 27A600AC addiu      $a2, $sp, 0xac
0016D264 E7AC00AC swc1       $f12, 0xac($sp)
0016D268 02402025 move       $a0, $s2
0016D26C 460D9300 add.s      $f12, $f18, $f13
0016D270 34050002 ori        $a1, $zero, 2
0016D274 E7AF00B0 swc1       $f15, 0xb0($sp)
0016D278 0C05BA28 jal        0x16e8a0
0016D27C E7AC00B4 swc1       $f12, 0xb4($sp)
0016D280 8E247288 lw         $a0, 0x7288($s1)
0016D284 10800003 beqz       $a0, 0x16d294
0016D288 00000000 nop        
0016D28C 2484FFFF addiu      $a0, $a0, -1
0016D290 AE247288 sw         $a0, 0x7288($s1)
0016D294 8E640000 lw         $a0, ($s3)
0016D298 848500F8 lh         $a1, 0xf8($a0)
0016D29C 14BE000D bne        $a1, $fp, 0x16d2d4
0016D2A0 00000000 nop        
0016D2A4 8E267288 lw         $a2, 0x7288($s1)
0016D2A8 14C0000A bnez       $a2, 0x16d2d4
0016D2AC 00000000 nop        
0016D2B0 34040064 ori        $a0, $zero, 0x64
0016D2B4 AE247288 sw         $a0, 0x7288($s1)
0016D2B8 8E660000 lw         $a2, ($s3)
0016D2BC 02402025 move       $a0, $s2
0016D2C0 24C60010 addiu      $a2, $a2, 0x10
0016D2C4 0C05BA28 jal        0x16e8a0
0016D2C8 34050003 ori        $a1, $zero, 3
0016D2CC 8E640000 lw         $a0, ($s3)
0016D2D0 848500F8 lh         $a1, 0xf8($a0)
0016D2D4 34060005 ori        $a2, $zero, 5
0016D2D8 14A6000E bne        $a1, $a2, 0x16d314
0016D2DC 24840010 addiu      $a0, $a0, 0x10
0016D2E0 C48C0000 lwc1       $f12, ($a0)
0016D2E4 46006307 neg.s      $f12, $f12
0016D2E8 E7AC00BC swc1       $f12, 0xbc($sp)
0016D2EC C48C0004 lwc1       $f12, 4($a0)
0016D2F0 27A600BC addiu      $a2, $sp, 0xbc
0016D2F4 46006307 neg.s      $f12, $f12
0016D2F8 34050004 ori        $a1, $zero, 4
0016D2FC E7AC00C0 swc1       $f12, 0xc0($sp)
0016D300 C48C0008 lwc1       $f12, 8($a0)
0016D304 02402025 move       $a0, $s2
0016D308 46006307 neg.s      $f12, $f12
0016D30C 0C05BA28 jal        0x16e8a0
0016D310 E7AC00C4 swc1       $f12, 0xc4($sp)
0016D314 92440044 lbu        $a0, 0x44($s2)
0016D318 8E450040 lw         $a1, 0x40($s2)
0016D31C 00043100 sll        $a2, $a0, 4
0016D320 00862021 addu       $a0, $a0, $a2
0016D324 8CA50004 lw         $a1, 4($a1)
0016D328 00042080 sll        $a0, $a0, 2
0016D32C 00862023 subu       $a0, $a0, $a2
0016D330 00A42021 addu       $a0, $a1, $a0
0016D334 8C850004 lw         $a1, 4($a0)
0016D338 0C05B038 jal        0x16c0e0
0016D33C 02402025 move       $a0, $s2
0016D340 C7B400CC lwc1       $f20, 0xcc($sp)
0016D344 C7B600D0 lwc1       $f22, 0xd0($sp)
0016D348 C7B800D4 lwc1       $f24, 0xd4($sp)
0016D34C 8FB000D8 lw         $s0, 0xd8($sp)
0016D350 8FB100DC lw         $s1, 0xdc($sp)
0016D354 8FB200E0 lw         $s2, 0xe0($sp)
0016D358 8FB300E4 lw         $s3, 0xe4($sp)
0016D35C 8FB400E8 lw         $s4, 0xe8($sp)
0016D360 8FB500EC lw         $s5, 0xec($sp)
0016D364 8FB600F0 lw         $s6, 0xf0($sp)
0016D368 8FB700F4 lw         $s7, 0xf4($sp)
0016D36C 8FBE00F8 lw         $fp, 0xf8($sp)
0016D370 8FBF00FC lw         $ra, 0xfc($sp)
0016D374 03E00008 jr         $ra
0016D378 27BD0100 addiu      $sp, $sp, 0x100

CALLBACK 0x0016D37C end 0x0016E008 ordinal 3

0016D37C 27BDFE80 addiu      $sp, $sp, -0x180
0016D380 AFB50160 sw         $s5, 0x160($sp)
0016D384 8C950058 lw         $s5, 0x58($a0)
0016D388 908B0045 lbu        $t3, 0x45($a0)
0016D38C E7B40144 swc1       $f20, 0x144($sp)
0016D390 AFB10150 sw         $s1, 0x150($sp)
0016D394 AFB20154 sw         $s2, 0x154($sp)
0016D398 AFB4015C sw         $s4, 0x15c($sp)
0016D39C AFB60164 sw         $s6, 0x164($sp)
0016D3A0 AFBE016C sw         $fp, 0x16c($sp)
0016D3A4 46006506 mov.s      $f20, $f12
0016D3A8 34110001 ori        $s1, $zero, 1
0016D3AC 34020003 ori        $v0, $zero, 3
0016D3B0 00809025 move       $s2, $a0
0016D3B4 00A05025 move       $t2, $a1
0016D3B8 00C0F025 move       $fp, $a2
0016D3BC 00E0A025 move       $s4, $a3
0016D3C0 0100B025 move       $s6, $t0
0016D3C4 E7B60148 swc1       $f22, 0x148($sp)
0016D3C8 AFB0014C sw         $s0, 0x14c($sp)
0016D3CC AFB30158 sw         $s3, 0x158($sp)
0016D3D0 AFB70168 sw         $s7, 0x168($sp)
0016D3D4 AFBF0170 sw         $ra, 0x170($sp)
0016D3D8 11620014 beq        $t3, $v0, 0x16d42c
0016D3DC 0120B825 move       $s7, $t1
0016D3E0 3404000E ori        $a0, $zero, 0xe
0016D3E4 11440009 beq        $t2, $a0, 0x16d40c
0016D3E8 AFAA0140 sw         $t2, 0x140($sp)
0016D3EC C6AC1074 lwc1       $f12, 0x1074($s5)
0016D3F0 44806800 mtc1       $zero, $f13
0016D3F4 460D603C c.lt.s     $f12, $f13
0016D3F8 00000000 nop        
0016D3FC 4500000D bc1f       0x16d434
0016D400 00000000 nop        
0016D404 1000000C b          0x16d438
0016D408 00000000 nop        
0016D40C 0C00C5F4 jal        0x317d0
0016D410 8EA40000 lw         $a0, ($s5)
0016D414 34040003 ori        $a0, $zero, 3
0016D418 44806000 mtc1       $zero, $f12
0016D41C A2440045 sb         $a0, 0x45($s2)
0016D420 E64C0070 swc1       $f12, 0x70($s2)
0016D424 100002EA b          0x16dfd0
0016D428 34020003 ori        $v0, $zero, 3
0016D42C 100002E8 b          0x16dfd0
0016D430 00001025 move       $v0, $zero
0016D434 34110000 ori        $s1, $zero, 0
0016D438 3C040005 lui        $a0, 5
0016D43C 8C8464A0 lw         $a0, 0x64a0($a0)
0016D440 1080000E beqz       $a0, 0x16d47c
0016D444 3C040005 lui        $a0, 5
0016D448 8C8564A0 lw         $a1, 0x64a0($a0)
0016D44C 34070000 ori        $a3, $zero, 0
0016D450 C4AC0014 lwc1       $f12, 0x14($a1)
0016D454 C4AD0018 lwc1       $f13, 0x18($a1)
0016D458 C4AE001C lwc1       $f14, 0x1c($a1)
0016D45C C4AF0020 lwc1       $f15, 0x20($a1)
0016D460 34090000 ori        $t1, $zero, 0
0016D464 340A0000 ori        $t2, $zero, 0
0016D468 340B0001 ori        $t3, $zero, 1
0016D46C 02402025 move       $a0, $s2
0016D470 00003025 move       $a2, $zero
0016D474 0C01B147 jal        0x6c51c
0016D478 00004025 move       $t0, $zero
0016D47C 34040007 ori        $a0, $zero, 7
0016D480 34050010 ori        $a1, $zero, 0x10
0016D484 0C007F68 jal        0x1fda0
0016D488 2406FFFF addiu      $a2, $zero, -1
0016D48C 1040017D beqz       $v0, 0x16da84
0016D490 00000000 nop        
0016D494 12E0017B beqz       $s7, 0x16da84
0016D498 00000000 nop        
0016D49C 12C00179 beqz       $s6, 0x16da84
0016D4A0 00000000 nop        
0016D4A4 12800177 beqz       $s4, 0x16da84
0016D4A8 00000000 nop        
0016D4AC 0C05B021 jal        0x16c084
0016D4B0 02E02025 move       $a0, $s7
0016D4B4 10400173 beqz       $v0, 0x16da84
0016D4B8 00000000 nop        
0016D4BC 3C04002D lui        $a0, 0x2d
0016D4C0 34130000 ori        $s3, $zero, 0
0016D4C4 34100000 ori        $s0, $zero, 0
0016D4C8 0C06B652 jal        0x1ad948
0016D4CC C4967260 lwc1       $f22, 0x7260($a0)
0016D4D0 44826000 mtc1       $v0, $f12
0016D4D4 3C042FFF lui        $a0, 0x2fff
0016D4D8 46806320 cvt.s.w    $f12, $f12
0016D4DC 3484FFFE ori        $a0, $a0, 0xfffe
0016D4E0 44846800 mtc1       $a0, $f13
0016D4E4 460D6302 mul.s      $f12, $f12, $f13
0016D4E8 460CB03C c.lt.s     $f22, $f12
0016D4EC 00000000 nop        
0016D4F0 45020001 bc1fl      0x16d4f8
0016D4F4 34100001 ori        $s0, $zero, 1
0016D4F8 320400FF andi       $a0, $s0, 0xff
0016D4FC 10800055 beqz       $a0, 0x16d654
0016D500 A3B1013C sb         $s1, 0x13c($sp)
0016D504 3C08002D lui        $t0, 0x2d
0016D508 C50C7264 lwc1       $f12, 0x7264($t0)
0016D50C 27A40070 addiu      $a0, $sp, 0x70
0016D510 26460030 addiu      $a2, $s2, 0x30
0016D514 34050020 ori        $a1, $zero, 0x20
0016D518 340700A9 ori        $a3, $zero, 0xa9
0016D51C 34080081 ori        $t0, $zero, 0x81
0016D520 34090002 ori        $t1, $zero, 2
0016D524 0C005BA6 jal        0x16e98
0016D528 00005025 move       $t2, $zero
0016D52C 00408825 move       $s1, $v0
0016D530 2A240002 slti       $a0, $s1, 2
0016D534 10800013 beqz       $a0, 0x16d584
0016D538 00000000 nop        
0016D53C 12200044 beqz       $s1, 0x16d650
0016D540 3C04002D lui        $a0, 0x2d
0016D544 34100000 ori        $s0, $zero, 0
0016D548 0C06B652 jal        0x1ad948
0016D54C C4967260 lwc1       $f22, 0x7260($a0)
0016D550 44826000 mtc1       $v0, $f12
0016D554 3C042FFF lui        $a0, 0x2fff
0016D558 46806320 cvt.s.w    $f12, $f12
0016D55C 3484FFFE ori        $a0, $a0, 0xfffe
0016D560 44846800 mtc1       $a0, $f13
0016D564 460D6302 mul.s      $f12, $f12, $f13
0016D568 460CB03C c.lt.s     $f22, $f12
0016D56C 00000000 nop        
0016D570 45020001 bc1fl      0x16d578
0016D574 34100001 ori        $s0, $zero, 1
0016D578 320400FF andi       $a0, $s0, 0xff
0016D57C 10800034 beqz       $a0, 0x16d650
0016D580 00000000 nop        
0016D584 52200007 beql       $s1, $zero, 0x16d5a4
0016D588 34110000 ori        $s1, $zero, 0
0016D58C 0C06B652 jal        0x1ad948
0016D590 00000000 nop        
0016D594 0051001A div        $zero, $v0, $s1
0016D598 00008810 mfhi       $s1
0016D59C 10000001 b          0x16d5a4
0016D5A0 00000000 nop        
0016D5A4 00112080 sll        $a0, $s1, 2
0016D5A8 03A42021 addu       $a0, $sp, $a0
0016D5AC 8C840070 lw         $a0, 0x70($a0)
0016D5B0 27A500F0 addiu      $a1, $sp, 0xf0
0016D5B4 00003025 move       $a2, $zero
0016D5B8 0C01B0C6 jal        0x6c318
0016D5BC 00003825 move       $a3, $zero
0016D5C0 C7AC00F0 lwc1       $f12, 0xf0($sp)
0016D5C4 C68D0000 lwc1       $f13, ($s4)
0016D5C8 C7AE00F4 lwc1       $f14, 0xf4($sp)
0016D5CC C68F0004 lwc1       $f15, 4($s4)
0016D5D0 460D6301 sub.s      $f12, $f12, $f13
0016D5D4 C7B000F8 lwc1       $f16, 0xf8($sp)
0016D5D8 460F7381 sub.s      $f14, $f14, $f15
0016D5DC C6910008 lwc1       $f17, 8($s4)
0016D5E0 E7AC0050 swc1       $f12, 0x50($sp)
0016D5E4 46118401 sub.s      $f16, $f16, $f17
0016D5E8 460C6302 mul.s      $f12, $f12, $f12
0016D5EC 460E7342 mul.s      $f13, $f14, $f14
0016D5F0 E7AE0054 swc1       $f14, 0x54($sp)
0016D5F4 3C043480 lui        $a0, 0x3480
0016D5F8 44847800 mtc1       $a0, $f15
0016D5FC 46108382 mul.s      $f14, $f16, $f16
0016D600 460D6300 add.s      $f12, $f12, $f13
0016D604 460E6300 add.s      $f12, $f12, $f14
0016D608 460F603C c.lt.s     $f12, $f15
0016D60C 00000000 nop        
0016D610 4501000E bc1t       0x16d64c
0016D614 E7B00058 swc1       $f16, 0x58($sp)
0016D618 3C043F80 lui        $a0, 0x3f80
0016D61C 46006304 sqrt.s     $f12, $f12
0016D620 44846800 mtc1       $a0, $f13
0016D624 460C6B03 div.s      $f12, $f13, $f12
0016D628 C7AE0050 lwc1       $f14, 0x50($sp)
0016D62C C7AF0054 lwc1       $f15, 0x54($sp)
0016D630 C7B00058 lwc1       $f16, 0x58($sp)
0016D634 460C7382 mul.s      $f14, $f14, $f12
0016D638 460C7BC2 mul.s      $f15, $f15, $f12
0016D63C E7AE0050 swc1       $f14, 0x50($sp)
0016D640 460C8302 mul.s      $f12, $f16, $f12
0016D644 E7AF0054 swc1       $f15, 0x54($sp)
0016D648 E7AC0058 swc1       $f12, 0x58($sp)
0016D64C 34130001 ori        $s3, $zero, 1
0016D650 93B1013C lbu        $s1, 0x13c($sp)
0016D654 16600033 bnez       $s3, 0x16d724
0016D658 3C04002D lui        $a0, 0x2d
0016D65C C6CC0000 lwc1       $f12, ($s6)
0016D660 C6CD0004 lwc1       $f13, 4($s6)
0016D664 46006307 neg.s      $f12, $f12
0016D668 C6CE0008 lwc1       $f14, 8($s6)
0016D66C 46006B47 neg.s      $f13, $f13
0016D670 E7AC0050 swc1       $f12, 0x50($sp)
0016D674 460C6302 mul.s      $f12, $f12, $f12
0016D678 E7AD0054 swc1       $f13, 0x54($sp)
0016D67C 460D6BC2 mul.s      $f15, $f13, $f13
0016D680 46007387 neg.s      $f14, $f14
0016D684 3C043480 lui        $a0, 0x3480
0016D688 E7AE0058 swc1       $f14, 0x58($sp)
0016D68C 460E7342 mul.s      $f13, $f14, $f14
0016D690 460F6300 add.s      $f12, $f12, $f15
0016D694 44847000 mtc1       $a0, $f14
0016D698 460D6300 add.s      $f12, $f12, $f13
0016D69C 460E603C c.lt.s     $f12, $f14
0016D6A0 00000000 nop        
0016D6A4 4501000D bc1t       0x16d6dc
0016D6A8 3C043F80 lui        $a0, 0x3f80
0016D6AC 46006304 sqrt.s     $f12, $f12
0016D6B0 44846800 mtc1       $a0, $f13
0016D6B4 460C6B03 div.s      $f12, $f13, $f12
0016D6B8 C7AE0050 lwc1       $f14, 0x50($sp)
0016D6BC C7AF0054 lwc1       $f15, 0x54($sp)
0016D6C0 C7B00058 lwc1       $f16, 0x58($sp)
0016D6C4 460C7382 mul.s      $f14, $f14, $f12
0016D6C8 460C7BC2 mul.s      $f15, $f15, $f12
0016D6CC E7AE0050 swc1       $f14, 0x50($sp)
0016D6D0 460C8302 mul.s      $f12, $f16, $f12
0016D6D4 E7AF0054 swc1       $f15, 0x54($sp)
0016D6D8 E7AC0058 swc1       $f12, 0x58($sp)
0016D6DC 3C0440C9 lui        $a0, 0x40c9
0016D6E0 34840FDB ori        $a0, $a0, 0xfdb
0016D6E4 0C06B652 jal        0x1ad948
0016D6E8 4484B000 mtc1       $a0, $f22
0016D6EC 44826000 mtc1       $v0, $f12
0016D6F0 3C043000 lui        $a0, 0x3000
0016D6F4 46806320 cvt.s.w    $f12, $f12
0016D6F8 44846800 mtc1       $a0, $f13
0016D6FC 3C04C049 lui        $a0, 0xc049
0016D700 34850FDB ori        $a1, $a0, 0xfdb
0016D704 460D6302 mul.s      $f12, $f12, $f13
0016D708 27A40050 addiu      $a0, $sp, 0x50
0016D70C 44857000 mtc1       $a1, $f14
0016D710 00802825 move       $a1, $a0
0016D714 46166302 mul.s      $f12, $f12, $f22
0016D718 0C03D26A jal        0xf49a8
0016D71C 460E6300 add.s      $f12, $f12, $f14
0016D720 3C04002D lui        $a0, 0x2d
0016D724 C7AC0058 lwc1       $f12, 0x58($sp)
0016D728 2485A378 addiu      $a1, $a0, -0x5c88
0016D72C C4AD0004 lwc1       $f13, 4($a1)
0016D730 C4AE0008 lwc1       $f14, 8($a1)
0016D734 C7AF0054 lwc1       $f15, 0x54($sp)
0016D738 460C6C02 mul.s      $f16, $f13, $f12
0016D73C C7B10050 lwc1       $f17, 0x50($sp)
0016D740 460F7482 mul.s      $f18, $f14, $f15
0016D744 C493A378 lwc1       $f19, -0x5c88($a0)
0016D748 460C9B02 mul.s      $f12, $f19, $f12
0016D74C 46116B42 mul.s      $f13, $f13, $f17
0016D750 46117382 mul.s      $f14, $f14, $f17
0016D754 46128401 sub.s      $f16, $f16, $f18
0016D758 460F9BC2 mul.s      $f15, $f19, $f15
0016D75C 460C7301 sub.s      $f12, $f14, $f12
0016D760 46108002 mul.s      $f0, $f16, $f16
0016D764 E7B00030 swc1       $f16, 0x30($sp)
0016D768 460D7B41 sub.s      $f13, $f15, $f13
0016D76C 3C043480 lui        $a0, 0x3480
0016D770 E7AC0034 swc1       $f12, 0x34($sp)
0016D774 460C6402 mul.s      $f16, $f12, $f12
0016D778 44847000 mtc1       $a0, $f14
0016D77C 44806000 mtc1       $zero, $f12
0016D780 E7AC003C swc1       $f12, 0x3c($sp)
0016D784 460D6B02 mul.s      $f12, $f13, $f13
0016D788 E7AD0038 swc1       $f13, 0x38($sp)
0016D78C 46100340 add.s      $f13, $f0, $f16
0016D790 460C6B00 add.s      $f12, $f13, $f12
0016D794 460E603C c.lt.s     $f12, $f14
0016D798 00000000 nop        
0016D79C 4501000D bc1t       0x16d7d4
0016D7A0 3C043F80 lui        $a0, 0x3f80
0016D7A4 46006304 sqrt.s     $f12, $f12
0016D7A8 44846800 mtc1       $a0, $f13
0016D7AC 460C6B03 div.s      $f12, $f13, $f12
0016D7B0 C7AE0030 lwc1       $f14, 0x30($sp)
0016D7B4 C7AF0034 lwc1       $f15, 0x34($sp)
0016D7B8 C7B00038 lwc1       $f16, 0x38($sp)
0016D7BC 460C7382 mul.s      $f14, $f14, $f12
0016D7C0 460C7BC2 mul.s      $f15, $f15, $f12
0016D7C4 E7AE0030 swc1       $f14, 0x30($sp)
0016D7C8 460C8302 mul.s      $f12, $f16, $f12
0016D7CC E7AF0034 swc1       $f15, 0x34($sp)
0016D7D0 E7AC0038 swc1       $f12, 0x38($sp)
0016D7D4 C7AC0054 lwc1       $f12, 0x54($sp)
0016D7D8 C7AD0038 lwc1       $f13, 0x38($sp)
0016D7DC C7AE0058 lwc1       $f14, 0x58($sp)
0016D7E0 C7AF0034 lwc1       $f15, 0x34($sp)
0016D7E4 460D6402 mul.s      $f16, $f12, $f13
0016D7E8 C7B10030 lwc1       $f17, 0x30($sp)
0016D7EC 460F7482 mul.s      $f18, $f14, $f15
0016D7F0 C7B30050 lwc1       $f19, 0x50($sp)
0016D7F4 C6800000 lwc1       $f0, ($s4)
0016D7F8 44801000 mtc1       $zero, $f2
0016D7FC 460D9B42 mul.s      $f13, $f19, $f13
0016D800 46116302 mul.s      $f12, $f12, $f17
0016D804 46117382 mul.s      $f14, $f14, $f17
0016D808 46128401 sub.s      $f16, $f16, $f18
0016D80C 460F9BC2 mul.s      $f15, $f19, $f15
0016D810 3C053F80 lui        $a1, 0x3f80
0016D814 460D7341 sub.s      $f13, $f14, $f13
0016D818 E7B00040 swc1       $f16, 0x40($sp)
0016D81C 460C7B01 sub.s      $f12, $f15, $f12
0016D820 E7A2004C swc1       $f2, 0x4c($sp)
0016D824 E7AD0044 swc1       $f13, 0x44($sp)
0016D828 C68D0004 lwc1       $f13, 4($s4)
0016D82C E7A00060 swc1       $f0, 0x60($sp)
0016D830 E7AC0048 swc1       $f12, 0x48($sp)
0016D834 C68C0008 lwc1       $f12, 8($s4)
0016D838 E7AD0064 swc1       $f13, 0x64($sp)
0016D83C E7AC0068 swc1       $f12, 0x68($sp)
0016D840 E7A2003C swc1       $f2, 0x3c($sp)
0016D844 44856000 mtc1       $a1, $f12
0016D848 E7A2005C swc1       $f2, 0x5c($sp)
0016D84C 3C04702C lui        $a0, 0x702c
0016D850 8EE50040 lw         $a1, 0x40($s7)
0016D854 E7AC006C swc1       $f12, 0x6c($sp)
0016D858 2486F650 addiu      $a2, $a0, -0x9b0
0016D85C 8CA40030 lw         $a0, 0x30($a1)
0016D860 10860055 beq        $a0, $a2, 0x16d9b8
0016D864 3C05BF16 lui        $a1, 0xbf16
0016D868 24A5E7AB addiu      $a1, $a1, -0x1855
0016D86C 1085001C beq        $a0, $a1, 0x16d8e0
0016D870 3C05B7E3 lui        $a1, 0xb7e3
0016D874 24A506B3 addiu      $a1, $a1, 0x6b3
0016D878 1085000C beq        $a0, $a1, 0x16d8ac
0016D87C 3C05B5E7 lui        $a1, 0xb5e7
0016D880 24A56E00 addiu      $a1, $a1, 0x6e00
0016D884 10850010 beq        $a0, $a1, 0x16d8c8
0016D888 3C058239 lui        $a1, 0x8239
0016D88C 24A56476 addiu      $a1, $a1, 0x6476
0016D890 1485007C bne        $a0, $a1, 0x16da84
0016D894 00000000 nop        
0016D898 27A40030 addiu      $a0, $sp, 0x30
0016D89C 0C041988 jal        0x106620
0016D8A0 00002825 move       $a1, $zero
0016D8A4 10000077 b          0x16da84
0016D8A8 00000000 nop        
0016D8AC 8EE50054 lw         $a1, 0x54($s7)
0016D8B0 27A40030 addiu      $a0, $sp, 0x30
0016D8B4 8CA60008 lw         $a2, 8($a1)
0016D8B8 0C04198A jal        0x106628
0016D8BC 00002825 move       $a1, $zero
0016D8C0 10000070 b          0x16da84
0016D8C4 00000000 nop        
0016D8C8 27A50060 addiu      $a1, $sp, 0x60
0016D8CC 27A60050 addiu      $a2, $sp, 0x50
0016D8D0 0C04193A jal        0x1064e8
0016D8D4 02402025 move       $a0, $s2
0016D8D8 1000006A b          0x16da84
0016D8DC 00000000 nop        
0016D8E0 8EE40054 lw         $a0, 0x54($s7)
0016D8E4 3C05002D lui        $a1, 0x2d
0016D8E8 8C900010 lw         $s0, 0x10($a0)
0016D8EC 8CA5A0D0 lw         $a1, -0x5f30($a1)
0016D8F0 34040000 ori        $a0, $zero, 0
0016D8F4 8CA50038 lw         $a1, 0x38($a1)
0016D8F8 0085282B sltu       $a1, $a0, $a1
0016D8FC 10A0001B beqz       $a1, 0x16d96c
0016D900 00000000 nop        
0016D904 3C07002D lui        $a3, 0x2d
0016D908 00042980 sll        $a1, $a0, 6
0016D90C 00043100 sll        $a2, $a0, 4
0016D910 8CE7A0D0 lw         $a3, -0x5f30($a3)
0016D914 00A62821 addu       $a1, $a1, $a2
0016D918 8CE60034 lw         $a2, 0x34($a3)
0016D91C 3C07BF16 lui        $a3, 0xbf16
0016D920 00C52821 addu       $a1, $a2, $a1
0016D924 8CA50030 lw         $a1, 0x30($a1)
0016D928 24E6E7AB addiu      $a2, $a3, -0x1855
0016D92C 14A60009 bne        $a1, $a2, 0x16d954
0016D930 3C05002D lui        $a1, 0x2d
0016D934 00042980 sll        $a1, $a0, 6
0016D938 3C06002D lui        $a2, 0x2d
0016D93C 00042100 sll        $a0, $a0, 4
0016D940 8CC6A0D0 lw         $a2, -0x5f30($a2)
0016D944 00A42021 addu       $a0, $a1, $a0
0016D948 8CC50034 lw         $a1, 0x34($a2)
0016D94C 10000008 b          0x16d970
0016D950 00A42021 addu       $a0, $a1, $a0
0016D954 8CA5A0D0 lw         $a1, -0x5f30($a1)
0016D958 24840001 addiu      $a0, $a0, 1
0016D95C 8CA50038 lw         $a1, 0x38($a1)
0016D960 0085282B sltu       $a1, $a0, $a1
0016D964 14A0FFE8 bnez       $a1, 0x16d908
0016D968 3C07002D lui        $a3, 0x2d
0016D96C 34040000 ori        $a0, $zero, 0
0016D970 14800003 bnez       $a0, 0x16d980
0016D974 3C05BF16 lui        $a1, 0xbf16
0016D978 10000006 b          0x16d994
0016D97C 34040000 ori        $a0, $zero, 0
0016D980 27A60030 addiu      $a2, $sp, 0x30
0016D984 340700FF ori        $a3, $zero, 0xff
0016D988 0C01A8A5 jal        0x6a294
0016D98C 24A5E7AB addiu      $a1, $a1, -0x1855
0016D990 00402025 move       $a0, $v0
0016D994 10800006 beqz       $a0, 0x16d9b0
0016D998 00000000 nop        
0016D99C 3C074120 lui        $a3, 0x4120
0016D9A0 02402825 move       $a1, $s2
0016D9A4 44876000 mtc1       $a3, $f12
0016D9A8 0C041950 jal        0x106540
0016D9AC 02003025 move       $a2, $s0
0016D9B0 10000034 b          0x16da84
0016D9B4 00000000 nop        
0016D9B8 8EE40054 lw         $a0, 0x54($s7)
0016D9BC 3C05002D lui        $a1, 0x2d
0016D9C0 8C900008 lw         $s0, 8($a0)
0016D9C4 8CA5A0D0 lw         $a1, -0x5f30($a1)
0016D9C8 34040000 ori        $a0, $zero, 0
0016D9CC 8CA50038 lw         $a1, 0x38($a1)
0016D9D0 0085282B sltu       $a1, $a0, $a1
0016D9D4 10A0001B beqz       $a1, 0x16da44
0016D9D8 00000000 nop        
0016D9DC 3C07002D lui        $a3, 0x2d
0016D9E0 00042980 sll        $a1, $a0, 6
0016D9E4 00043100 sll        $a2, $a0, 4
0016D9E8 8CE7A0D0 lw         $a3, -0x5f30($a3)
0016D9EC 00A62821 addu       $a1, $a1, $a2
0016D9F0 8CE60034 lw         $a2, 0x34($a3)
0016D9F4 3C07702C lui        $a3, 0x702c
0016D9F8 00C52821 addu       $a1, $a2, $a1
0016D9FC 8CA50030 lw         $a1, 0x30($a1)
0016DA00 24E6F650 addiu      $a2, $a3, -0x9b0
0016DA04 14A60009 bne        $a1, $a2, 0x16da2c
0016DA08 3C05002D lui        $a1, 0x2d
0016DA0C 00042980 sll        $a1, $a0, 6
0016DA10 3C06002D lui        $a2, 0x2d
0016DA14 00042100 sll        $a0, $a0, 4
0016DA18 8CC6A0D0 lw         $a2, -0x5f30($a2)
0016DA1C 00A42021 addu       $a0, $a1, $a0
0016DA20 8CC50034 lw         $a1, 0x34($a2)
0016DA24 10000008 b          0x16da48
0016DA28 00A42021 addu       $a0, $a1, $a0
0016DA2C 8CA5A0D0 lw         $a1, -0x5f30($a1)
0016DA30 24840001 addiu      $a0, $a0, 1
0016DA34 8CA50038 lw         $a1, 0x38($a1)
0016DA38 0085282B sltu       $a1, $a0, $a1
0016DA3C 14A0FFE8 bnez       $a1, 0x16d9e0
0016DA40 3C07002D lui        $a3, 0x2d
0016DA44 34040000 ori        $a0, $zero, 0
0016DA48 14800003 bnez       $a0, 0x16da58
0016DA4C 27A60030 addiu      $a2, $sp, 0x30
0016DA50 10000005 b          0x16da68
0016DA54 34040000 ori        $a0, $zero, 0
0016DA58 00002825 move       $a1, $zero
0016DA5C 0C01A8A5 jal        0x6a294
0016DA60 340700FF ori        $a3, $zero, 0xff
0016DA64 00402025 move       $a0, $v0
0016DA68 10800006 beqz       $a0, 0x16da84
0016DA6C 00000000 nop        
0016DA70 3C074120 lui        $a3, 0x4120
0016DA74 02402825 move       $a1, $s2
0016DA78 44876000 mtc1       $a3, $f12
0016DA7C 0C060AEE jal        0x182bb8
0016DA80 02003025 move       $a2, $s0
0016DA84 12200071 beqz       $s1, 0x16dc4c
0016DA88 00000000 nop        
0016DA8C C6AD1070 lwc1       $f13, 0x1070($s5)
0016DA90 44806000 mtc1       $zero, $f12
0016DA94 46146B41 sub.s      $f13, $f13, $f20
0016DA98 E6AD1070 swc1       $f13, 0x1070($s5)
0016DA9C 460C683C c.lt.s     $f13, $f12
0016DAA0 00000000 nop        
0016DAA4 45030001 bc1tl      0x16daac
0016DAA8 E6AC1070 swc1       $f12, 0x1070($s5)
0016DAAC 8EA41078 lw         $a0, 0x1078($s5)
0016DAB0 C6AD1070 lwc1       $f13, 0x1070($s5)
0016DAB4 3C06002D lui        $a2, 0x2d
0016DAB8 C4CC7214 lwc1       $f12, 0x7214($a2)
0016DABC 3C05002D lui        $a1, 0x2d
0016DAC0 00042080 sll        $a0, $a0, 2
0016DAC4 460CA302 mul.s      $f12, $f20, $f12
0016DAC8 24A571F4 addiu      $a1, $a1, 0x71f4
0016DACC 00852021 addu       $a0, $a0, $a1
0016DAD0 3C054F00 lui        $a1, 0x4f00
0016DAD4 C48E0000 lwc1       $f14, ($a0)
0016DAD8 44857800 mtc1       $a1, $f15
0016DADC 460E6D03 div.s      $f20, $f13, $f14
0016DAE0 460F603C c.lt.s     $f12, $f15
0016DAE4 00000000 nop        
0016DAE8 45000004 bc1f       0x16dafc
0016DAEC 8EA40000 lw         $a0, ($s5)
0016DAF0 4600630D trunc.w.s  $f12, $f12
0016DAF4 10000008 b          0x16db18
0016DAF8 44056000 mfc1       $a1, $f12
0016DAFC 3C054F00 lui        $a1, 0x4f00
0016DB00 44856800 mtc1       $a1, $f13
0016DB04 460D6301 sub.s      $f12, $f12, $f13
0016DB08 3C058000 lui        $a1, 0x8000
0016DB0C 4600630D trunc.w.s  $f12, $f12
0016DB10 44066000 mfc1       $a2, $f12
0016DB14 00C52821 addu       $a1, $a2, $a1
0016DB18 00A03025 move       $a2, $a1
0016DB1C 0C004269 jal        0x109a4
0016DB20 34050007 ori        $a1, $zero, 7
0016DB24 3C04002D lui        $a0, 0x2d
0016DB28 4600A306 mov.s      $f12, $f20
0016DB2C 8C8471E0 lw         $a0, 0x71e0($a0)
0016DB30 3C05002D lui        $a1, 0x2d
0016DB34 0C03C93C jal        0xf24f0
0016DB38 8CA571DC lw         $a1, 0x71dc($a1)
0016DB3C AEA2106C sw         $v0, 0x106c($s5)
0016DB40 3C04002D lui        $a0, 0x2d
0016DB44 8C847140 lw         $a0, 0x7140($a0)
0016DB48 4484A000 mtc1       $a0, $f20
0016DB4C 04810004 bgez       $a0, 0x16db60
0016DB50 4680A520 cvt.s.w    $f20, $f20
0016DB54 3C044F80 lui        $a0, 0x4f80
0016DB58 44846000 mtc1       $a0, $f12
0016DB5C 460CA500 add.s      $f20, $f20, $f12
0016DB60 E6B41074 swc1       $f20, 0x1074($s5)
0016DB64 92440045 lbu        $a0, 0x45($s2)
0016DB68 34050001 ori        $a1, $zero, 1
0016DB6C 14850004 bne        $a0, $a1, 0x16db80
0016DB70 00000000 nop        
0016DB74 34040002 ori        $a0, $zero, 2
0016DB78 A2440045 sb         $a0, 0x45($s2)
0016DB7C A2400046 sb         $zero, 0x46($s2)
0016DB80 34040007 ori        $a0, $zero, 7
0016DB84 34050011 ori        $a1, $zero, 0x11
0016DB88 0C007F68 jal        0x1fda0
0016DB8C 2406FFFF addiu      $a2, $zero, -1
0016DB90 10400009 beqz       $v0, 0x16dbb8
0016DB94 00000000 nop        
0016DB98 0C058FA4 jal        0x163e90
0016DB9C 02402025 move       $a0, $s2
0016DBA0 10400005 beqz       $v0, 0x16dbb8
0016DBA4 00000000 nop        
0016DBA8 02402025 move       $a0, $s2
0016DBAC 02E02825 move       $a1, $s7
0016DBB0 0C059040 jal        0x164100
0016DBB4 02C03025 move       $a2, $s6
0016DBB8 C6AC1070 lwc1       $f12, 0x1070($s5)
0016DBBC 44806800 mtc1       $zero, $f13
0016DBC0 460D6032 c.eq.s     $f12, $f13
0016DBC4 00000000 nop        
0016DBC8 45000020 bc1f       0x16dc4c
0016DBCC 00000000 nop        
0016DBD0 0C00C5F4 jal        0x317d0
0016DBD4 8EA40000 lw         $a0, ($s5)
0016DBD8 3C040006 lui        $a0, 6
0016DBDC 0C00C5FF jal        0x317fc
0016DBE0 2490A838 addiu      $s0, $a0, -0x57c8
0016DBE4 02002025 move       $a0, $s0
0016DBE8 0C00C5E3 jal        0x3178c
0016DBEC 46000306 mov.s      $f12, $f0
0016DBF0 34040003 ori        $a0, $zero, 3
0016DBF4 44806000 mtc1       $zero, $f12
0016DBF8 A2440045 sb         $a0, 0x45($s2)
0016DBFC E64C0070 swc1       $f12, 0x70($s2)
0016DC00 3C040005 lui        $a0, 5
0016DC04 8C8464AC lw         $a0, 0x64ac($a0)
0016DC08 1080000E beqz       $a0, 0x16dc44
0016DC0C 3C040005 lui        $a0, 5
0016DC10 8C8564AC lw         $a1, 0x64ac($a0)
0016DC14 34070000 ori        $a3, $zero, 0
0016DC18 C4AC0014 lwc1       $f12, 0x14($a1)
0016DC1C C4AD0018 lwc1       $f13, 0x18($a1)
0016DC20 C4AE001C lwc1       $f14, 0x1c($a1)
0016DC24 C4AF0020 lwc1       $f15, 0x20($a1)
0016DC28 34090000 ori        $t1, $zero, 0
0016DC2C 340A0000 ori        $t2, $zero, 0
0016DC30 340B0001 ori        $t3, $zero, 1
0016DC34 02402025 move       $a0, $s2
0016DC38 00003025 move       $a2, $zero
0016DC3C 0C01B147 jal        0x6c51c
0016DC40 00004025 move       $t0, $zero
0016DC44 100000E2 b          0x16dfd0
0016DC48 34020003 ori        $v0, $zero, 3
0016DC4C 0C016FD5 jal        0x5bf54
0016DC50 8EA40000 lw         $a0, ($s5)
0016DC54 10400005 beqz       $v0, 0x16dc6c
0016DC58 00000000 nop        
0016DC5C 0C016FDF jal        0x5bf7c
0016DC60 8EA40000 lw         $a0, ($s5)
0016DC64 100000D5 b          0x16dfbc
0016DC68 00000000 nop        
0016DC6C 8FA40140 lw         $a0, 0x140($sp)
0016DC70 14800008 bnez       $a0, 0x16dc94
0016DC74 00000000 nop        
0016DC78 26470030 addiu      $a3, $s2, 0x30
0016DC7C 02402025 move       $a0, $s2
0016DC80 34050001 ori        $a1, $zero, 1
0016DC84 0C05B0EF jal        0x16c3bc
0016DC88 03C03025 move       $a2, $fp
0016DC8C 100000CB b          0x16dfbc
0016DC90 00000000 nop        
0016DC94 56800008 bnel       $s4, $zero, 0x16dcb8
0016DC98 C68C0000 lwc1       $f12, ($s4)
0016DC9C 26470030 addiu      $a3, $s2, 0x30
0016DCA0 02402025 move       $a0, $s2
0016DCA4 34050001 ori        $a1, $zero, 1
0016DCA8 0C05B0EF jal        0x16c3bc
0016DCAC 03C03025 move       $a2, $fp
0016DCB0 100000C2 b          0x16dfbc
0016DCB4 00000000 nop        
0016DCB8 C64D0030 lwc1       $f13, 0x30($s2)
0016DCBC C68E0004 lwc1       $f14, 4($s4)
0016DCC0 C64F0034 lwc1       $f15, 0x34($s2)
0016DCC4 460D6301 sub.s      $f12, $f12, $f13
0016DCC8 C6900008 lwc1       $f16, 8($s4)
0016DCCC 460F7381 sub.s      $f14, $f14, $f15
0016DCD0 C6510038 lwc1       $f17, 0x38($s2)
0016DCD4 46118401 sub.s      $f16, $f16, $f17
0016DCD8 E7AC0100 swc1       $f12, 0x100($sp)
0016DCDC 460C6342 mul.s      $f13, $f12, $f12
0016DCE0 460E7482 mul.s      $f18, $f14, $f14
0016DCE4 3C04002D lui        $a0, 0x2d
0016DCE8 E7AE0104 swc1       $f14, 0x104($sp)
0016DCEC 46108302 mul.s      $f12, $f16, $f16
0016DCF0 46126B40 add.s      $f13, $f13, $f18
0016DCF4 C48E71D8 lwc1       $f14, 0x71d8($a0)
0016DCF8 3C053727 lui        $a1, 0x3727
0016DCFC 34A5C5AC ori        $a1, $a1, 0xc5ac
0016DD00 460C6B00 add.s      $f12, $f13, $f12
0016DD04 E7B00108 swc1       $f16, 0x108($sp)
0016DD08 44857800 mtc1       $a1, $f15
0016DD0C 34040000 ori        $a0, $zero, 0
0016DD10 460E6381 sub.s      $f14, $f12, $f14
0016DD14 46007385 abs.s      $f14, $f14
0016DD18 460F703E c.le.s     $f14, $f15
0016DD1C 00000000 nop        
0016DD20 45030001 bc1tl      0x16dd28
0016DD24 34040001 ori        $a0, $zero, 1
0016DD28 308400FF andi       $a0, $a0, 0xff
0016DD2C 10800008 beqz       $a0, 0x16dd50
0016DD30 00000000 nop        
0016DD34 02402025 move       $a0, $s2
0016DD38 00002825 move       $a1, $zero
0016DD3C 03C03025 move       $a2, $fp
0016DD40 0C05B0EF jal        0x16c3bc
0016DD44 02803825 move       $a3, $s4
0016DD48 1000009C b          0x16dfbc
0016DD4C 00000000 nop        
0016DD50 3C04002D lui        $a0, 0x2d
0016DD54 C48D71D8 lwc1       $f13, 0x71d8($a0)
0016DD58 460D603C c.lt.s     $f12, $f13
0016DD5C 00000000 nop        
0016DD60 45000020 bc1f       0x16dde4
0016DD64 00000000 nop        
0016DD68 44806800 mtc1       $zero, $f13
0016DD6C 3C043F80 lui        $a0, 0x3f80
0016DD70 E7AD010C swc1       $f13, 0x10c($sp)
0016DD74 4484A000 mtc1       $a0, $f20
0016DD78 E7AD0110 swc1       $f13, 0x110($sp)
0016DD7C E7AD0114 swc1       $f13, 0x114($sp)
0016DD80 0C06D679 jal        0x1b59e4
0016DD84 E7B40118 swc1       $f20, 0x118($sp)
0016DD88 4600A303 div.s      $f12, $f20, $f0
0016DD8C C7AD0100 lwc1       $f13, 0x100($sp)
0016DD90 C64E0030 lwc1       $f14, 0x30($s2)
0016DD94 C7AF0104 lwc1       $f15, 0x104($sp)
0016DD98 C6500034 lwc1       $f16, 0x34($s2)
0016DD9C C7B10108 lwc1       $f17, 0x108($sp)
0016DDA0 C6520038 lwc1       $f18, 0x38($s2)
0016DDA4 27A7010C addiu      $a3, $sp, 0x10c
0016DDA8 02402025 move       $a0, $s2
0016DDAC 00002825 move       $a1, $zero
0016DDB0 03C03025 move       $a2, $fp
0016DDB4 460C6B42 mul.s      $f13, $f13, $f12
0016DDB8 460C7BC2 mul.s      $f15, $f15, $f12
0016DDBC 460D7340 add.s      $f13, $f14, $f13
0016DDC0 460C8B02 mul.s      $f12, $f17, $f12
0016DDC4 460F83C0 add.s      $f15, $f16, $f15
0016DDC8 E7AD010C swc1       $f13, 0x10c($sp)
0016DDCC 460C9300 add.s      $f12, $f18, $f12
0016DDD0 E7AF0110 swc1       $f15, 0x110($sp)
0016DDD4 0C05B0EF jal        0x16c3bc
0016DDD8 E7AC0114 swc1       $f12, 0x114($sp)
0016DDDC 10000077 b          0x16dfbc
0016DDE0 00000000 nop        
0016DDE4 16C0000E bnez       $s6, 0x16de20
0016DDE8 00000000 nop        
0016DDEC C64C0030 lwc1       $f12, 0x30($s2)
0016DDF0 C68D0000 lwc1       $f13, ($s4)
0016DDF4 C64E0034 lwc1       $f14, 0x34($s2)
0016DDF8 460D6301 sub.s      $f12, $f12, $f13
0016DDFC C68F0004 lwc1       $f15, 4($s4)
0016DE00 C6500038 lwc1       $f16, 0x38($s2)
0016DE04 C6910008 lwc1       $f17, 8($s4)
0016DE08 460F7381 sub.s      $f14, $f14, $f15
0016DE0C E7AC011C swc1       $f12, 0x11c($sp)
0016DE10 46118301 sub.s      $f12, $f16, $f17
0016DE14 E7AE0120 swc1       $f14, 0x120($sp)
0016DE18 10000007 b          0x16de38
0016DE1C E7AC0124 swc1       $f12, 0x124($sp)
0016DE20 C6CC0000 lwc1       $f12, ($s6)
0016DE24 C6CD0004 lwc1       $f13, 4($s6)
0016DE28 E7AC011C swc1       $f12, 0x11c($sp)
0016DE2C C6CC0008 lwc1       $f12, 8($s6)
0016DE30 E7AD0120 swc1       $f13, 0x120($sp)
0016DE34 E7AC0124 swc1       $f12, 0x124($sp)
0016DE38 C7AC011C lwc1       $f12, 0x11c($sp)
0016DE3C C7AD0120 lwc1       $f13, 0x120($sp)
0016DE40 460C6302 mul.s      $f12, $f12, $f12
0016DE44 C7AE0124 lwc1       $f14, 0x124($sp)
0016DE48 460D6B42 mul.s      $f13, $f13, $f13
0016DE4C 3C043F80 lui        $a0, 0x3f80
0016DE50 460E7382 mul.s      $f14, $f14, $f14
0016DE54 44808000 mtc1       $zero, $f16
0016DE58 3C053727 lui        $a1, 0x3727
0016DE5C E7B00128 swc1       $f16, 0x128($sp)
0016DE60 44847800 mtc1       $a0, $f15
0016DE64 460D6300 add.s      $f12, $f12, $f13
0016DE68 E7B0012C swc1       $f16, 0x12c($sp)
0016DE6C E7B00130 swc1       $f16, 0x130($sp)
0016DE70 E7AF0134 swc1       $f15, 0x134($sp)
0016DE74 460E6300 add.s      $f12, $f12, $f14
0016DE78 34A5C5AC ori        $a1, $a1, 0xc5ac
0016DE7C 44858000 mtc1       $a1, $f16
0016DE80 34040000 ori        $a0, $zero, 0
0016DE84 460F63C1 sub.s      $f15, $f12, $f15
0016DE88 46007BC5 abs.s      $f15, $f15
0016DE8C 4610783E c.le.s     $f15, $f16
0016DE90 00000000 nop        
0016DE94 45030001 bc1tl      0x16de9c
0016DE98 34040001 ori        $a0, $zero, 1
0016DE9C 308400FF andi       $a0, $a0, 0xff
0016DEA0 54800010 bnel       $a0, $zero, 0x16dee4
0016DEA4 C64C0030 lwc1       $f12, 0x30($s2)
0016DEA8 0C06D679 jal        0x1b59e4
0016DEAC 00000000 nop        
0016DEB0 3C043F80 lui        $a0, 0x3f80
0016DEB4 44846000 mtc1       $a0, $f12
0016DEB8 46006303 div.s      $f12, $f12, $f0
0016DEBC C7AD011C lwc1       $f13, 0x11c($sp)
0016DEC0 C7AE0120 lwc1       $f14, 0x120($sp)
0016DEC4 C7AF0124 lwc1       $f15, 0x124($sp)
0016DEC8 460C6B42 mul.s      $f13, $f13, $f12
0016DECC 460C7382 mul.s      $f14, $f14, $f12
0016DED0 E7AD011C swc1       $f13, 0x11c($sp)
0016DED4 460C7B02 mul.s      $f12, $f15, $f12
0016DED8 E7AE0120 swc1       $f14, 0x120($sp)
0016DEDC E7AC0124 swc1       $f12, 0x124($sp)
0016DEE0 C64C0030 lwc1       $f12, 0x30($s2)
0016DEE4 C68D0000 lwc1       $f13, ($s4)
0016DEE8 C64E0034 lwc1       $f14, 0x34($s2)
0016DEEC C68F0004 lwc1       $f15, 4($s4)
0016DEF0 460D6301 sub.s      $f12, $f12, $f13
0016DEF4 C6500038 lwc1       $f16, 0x38($s2)
0016DEF8 460F7381 sub.s      $f14, $f14, $f15
0016DEFC C6910008 lwc1       $f17, 8($s4)
0016DF00 460C6302 mul.s      $f12, $f12, $f12
0016DF04 46118401 sub.s      $f16, $f16, $f17
0016DF08 460E7342 mul.s      $f13, $f14, $f14
0016DF0C 46108402 mul.s      $f16, $f16, $f16
0016DF10 460D6300 add.s      $f12, $f12, $f13
0016DF14 0C0697C0 jal        0x1a5f00
0016DF18 46106300 add.s      $f12, $f12, $f16
0016DF1C 44806000 mtc1       $zero, $f12
0016DF20 3C05002D lui        $a1, 0x2d
0016DF24 E7AC0138 swc1       $f12, 0x138($sp)
0016DF28 C4AD71D8 lwc1       $f13, 0x71d8($a1)
0016DF2C 46000306 mov.s      $f12, $f0
0016DF30 27A40138 addiu      $a0, $sp, 0x138
0016DF34 27A6011C addiu      $a2, $sp, 0x11c
0016DF38 26470030 addiu      $a3, $s2, 0x30
0016DF3C 0C03B107 jal        0xec41c
0016DF40 02802825 move       $a1, $s4
0016DF44 10400018 beqz       $v0, 0x16dfa8
0016DF48 00000000 nop        
0016DF4C C7AC0138 lwc1       $f12, 0x138($sp)
0016DF50 C7AD011C lwc1       $f13, 0x11c($sp)
0016DF54 C68E0000 lwc1       $f14, ($s4)
0016DF58 C7AF0120 lwc1       $f15, 0x120($sp)
0016DF5C 460C6B42 mul.s      $f13, $f13, $f12
0016DF60 C6900004 lwc1       $f16, 4($s4)
0016DF64 460C7BC2 mul.s      $f15, $f15, $f12
0016DF68 C7B10124 lwc1       $f17, 0x124($sp)
0016DF6C C6920008 lwc1       $f18, 8($s4)
0016DF70 460D7340 add.s      $f13, $f14, $f13
0016DF74 27A70128 addiu      $a3, $sp, 0x128
0016DF78 460C8B02 mul.s      $f12, $f17, $f12
0016DF7C 02402025 move       $a0, $s2
0016DF80 460F83C0 add.s      $f15, $f16, $f15
0016DF84 00002825 move       $a1, $zero
0016DF88 E7AD0128 swc1       $f13, 0x128($sp)
0016DF8C 03C03025 move       $a2, $fp
0016DF90 460C9300 add.s      $f12, $f18, $f12
0016DF94 E7AF012C swc1       $f15, 0x12c($sp)
0016DF98 0C05B0EF jal        0x16c3bc
0016DF9C E7AC0130 swc1       $f12, 0x130($sp)
0016DFA0 10000006 b          0x16dfbc
0016DFA4 00000000 nop        
0016DFA8 26470030 addiu      $a3, $s2, 0x30
0016DFAC 02402025 move       $a0, $s2
0016DFB0 34050001 ori        $a1, $zero, 1
0016DFB4 0C05B0EF jal        0x16c3bc
0016DFB8 03C03025 move       $a2, $fp
0016DFBC 12200003 beqz       $s1, 0x16dfcc
0016DFC0 00000000 nop        
0016DFC4 10000002 b          0x16dfd0
0016DFC8 34020002 ori        $v0, $zero, 2
0016DFCC 34020001 ori        $v0, $zero, 1
0016DFD0 C7B40144 lwc1       $f20, 0x144($sp)
0016DFD4 C7B60148 lwc1       $f22, 0x148($sp)
0016DFD8 8FB0014C lw         $s0, 0x14c($sp)
0016DFDC 8FB10150 lw         $s1, 0x150($sp)
0016DFE0 8FB20154 lw         $s2, 0x154($sp)
0016DFE4 8FB30158 lw         $s3, 0x158($sp)
0016DFE8 8FB4015C lw         $s4, 0x15c($sp)
0016DFEC 8FB50160 lw         $s5, 0x160($sp)
0016DFF0 8FB60164 lw         $s6, 0x164($sp)
0016DFF4 8FB70168 lw         $s7, 0x168($sp)
0016DFF8 8FBE016C lw         $fp, 0x16c($sp)
0016DFFC 8FBF0170 lw         $ra, 0x170($sp)
0016E000 03E00008 jr         $ra
0016E004 27BD0180 addiu      $sp, $sp, 0x180