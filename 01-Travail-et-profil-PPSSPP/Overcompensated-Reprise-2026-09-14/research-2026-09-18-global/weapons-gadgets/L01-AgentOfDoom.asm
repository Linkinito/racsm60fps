
CALLBACK 0x00109820 end 0x001098FC ordinal 0

00109820 27BDFFE0 addiu      $sp, $sp, -0x20
00109824 8C850064 lw         $a1, 0x64($a0)
00109828 3C064461 lui        $a2, 0x4461
0010982C 44866000 mtc1       $a2, $f12
00109830 34A50400 ori        $a1, $a1, 0x400
00109834 E48C0070 swc1       $f12, 0x70($a0)
00109838 AC850064 sw         $a1, 0x64($a0)
0010983C 34A51000 ori        $a1, $a1, 0x1000
00109840 AC850064 sw         $a1, 0x64($a0)
00109844 8C850048 lw         $a1, 0x48($a0)
00109848 3C060011 lui        $a2, 0x11
0010984C 24C6DA48 addiu      $a2, $a2, -0x25b8
00109850 ACA600DC sw         $a2, 0xdc($a1)
00109854 8C850064 lw         $a1, 0x64($a0)
00109858 8C860058 lw         $a2, 0x58($a0)
0010985C 34A54000 ori        $a1, $a1, 0x4000
00109860 AC850064 sw         $a1, 0x64($a0)
00109864 ACC00070 sw         $zero, 0x70($a2)
00109868 34050002 ori        $a1, $zero, 2
0010986C A0C5000E sb         $a1, 0xe($a2)
00109870 ACC40010 sw         $a0, 0x10($a2)
00109874 ACC00014 sw         $zero, 0x14($a2)
00109878 44806000 mtc1       $zero, $f12
0010987C ACC00000 sw         $zero, ($a2)
00109880 E4CC004C swc1       $f12, 0x4c($a2)
00109884 E4CC0050 swc1       $f12, 0x50($a2)
00109888 E4CC0054 swc1       $f12, 0x54($a2)
0010988C E4CC0044 swc1       $f12, 0x44($a2)
00109890 E4CC0048 swc1       $f12, 0x48($a2)
00109894 ACC00068 sw         $zero, 0x68($a2)
00109898 ACC0006C sw         $zero, 0x6c($a2)
0010989C A0C000E8 sb         $zero, 0xe8($a2)
001098A0 A0C000ED sb         $zero, 0xed($a2)
001098A4 A0C000EE sb         $zero, 0xee($a2)
001098A8 A0C000EF sb         $zero, 0xef($a2)
001098AC A0C000F2 sb         $zero, 0xf2($a2)
001098B0 3C05002D lui        $a1, 0x2d
001098B4 C4ADCECC lwc1       $f13, -0x3134($a1)
001098B8 46006B4D trunc.w.s  $f13, $f13
001098BC A0C000EB sb         $zero, 0xeb($a2)
001098C0 E4CC005C swc1       $f12, 0x5c($a2)
001098C4 E4CC0060 swc1       $f12, 0x60($a2)
001098C8 E4CC0064 swc1       $f12, 0x64($a2)
001098CC 44056800 mfc1       $a1, $f13
001098D0 A0C500F1 sb         $a1, 0xf1($a2)
001098D4 24840074 addiu      $a0, $a0, 0x74
001098D8 2407FFFF addiu      $a3, $zero, -1
001098DC 34050005 ori        $a1, $zero, 5
001098E0 AFBF0010 sw         $ra, 0x10($sp)
001098E4 0C0077E7 jal        0x1df9c
001098E8 2406FFFF addiu      $a2, $zero, -1
001098EC 34020001 ori        $v0, $zero, 1
001098F0 8FBF0010 lw         $ra, 0x10($sp)
001098F4 03E00008 jr         $ra
001098F8 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x001098FC end 0x001099BC ordinal 1

001098FC 27BDFFD0 addiu      $sp, $sp, -0x30
00109900 AFB00010 sw         $s0, 0x10($sp)
00109904 8C900058 lw         $s0, 0x58($a0)
00109908 920400E9 lbu        $a0, 0xe9($s0)
0010990C AFB10014 sw         $s1, 0x14($sp)
00109910 AFB20018 sw         $s2, 0x18($sp)
00109914 AFB3001C sw         $s3, 0x1c($sp)
00109918 AFBF0020 sw         $ra, 0x20($sp)
0010991C 10800016 beqz       $a0, 0x109978
00109920 00000000 nop        
00109924 34130000 ori        $s3, $zero, 0
00109928 02009025 move       $s2, $s0
0010992C 3C11002B lui        $s1, 0x2b
00109930 8E450034 lw         $a1, 0x34($s2)
00109934 10A0000C beqz       $a1, 0x109968
00109938 00000000 nop        
0010993C 00A02025 move       $a0, $a1
00109940 10800008 beqz       $a0, 0x109964
00109944 00000000 nop        
00109948 8E263058 lw         $a2, 0x3058($s1)
0010994C 14A60003 bne        $a1, $a2, 0x10995c
00109950 00000000 nop        
00109954 10000003 b          0x109964
00109958 AE203058 sw         $zero, 0x3058($s1)
0010995C 0C023293 jal        0x8ca4c
00109960 00000000 nop        
00109964 AE400034 sw         $zero, 0x34($s2)
00109968 26730001 addiu      $s3, $s3, 1
0010996C 2E640008 sltiu      $a0, $s3, 8
00109970 1480FFEF bnez       $a0, 0x109930
00109974 26520004 addiu      $s2, $s2, 4
00109978 8E040014 lw         $a0, 0x14($s0)
0010997C 10800008 beqz       $a0, 0x1099a0
00109980 00000000 nop        
00109984 8E050000 lw         $a1, ($s0)
00109988 10A00004 beqz       $a1, 0x10999c
0010998C AC850000 sw         $a1, ($a0)
00109990 8E040014 lw         $a0, 0x14($s0)
00109994 8E050000 lw         $a1, ($s0)
00109998 ACA40014 sw         $a0, 0x14($a1)
0010999C AE000014 sw         $zero, 0x14($s0)
001099A0 8FB00010 lw         $s0, 0x10($sp)
001099A4 8FB10014 lw         $s1, 0x14($sp)
001099A8 8FB20018 lw         $s2, 0x18($sp)
001099AC 8FB3001C lw         $s3, 0x1c($sp)
001099B0 8FBF0020 lw         $ra, 0x20($sp)
001099B4 03E00008 jr         $ra
001099B8 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x001099BC end 0x00109A68 ordinal 2

001099BC 27BDFFE0 addiu      $sp, $sp, -0x20
001099C0 8C850058 lw         $a1, 0x58($a0)
001099C4 ACA000DC sw         $zero, 0xdc($a1)
001099C8 C48C0070 lwc1       $f12, 0x70($a0)
001099CC 44806800 mtc1       $zero, $f13
001099D0 AFBF0010 sw         $ra, 0x10($sp)
001099D4 460D603E c.le.s     $f12, $f13
001099D8 00000000 nop        
001099DC 45000008 bc1f       0x109a00
001099E0 3C06BF80 lui        $a2, 0xbf80
001099E4 90A600EE lbu        $a2, 0xee($a1)
001099E8 10C0000D beqz       $a2, 0x109a20
001099EC 00000000 nop        
001099F0 8CA60068 lw         $a2, 0x68($a1)
001099F4 10C0000A beqz       $a2, 0x109a20
001099F8 00000000 nop        
001099FC 3C06BF80 lui        $a2, 0xbf80
00109A00 44866800 mtc1       $a2, $f13
00109A04 460D6300 add.s      $f12, $f12, $f13
00109A08 E48C0070 swc1       $f12, 0x70($a0)
00109A0C 90A600F1 lbu        $a2, 0xf1($a1)
00109A10 14C00007 bnez       $a2, 0x109a30
00109A14 00000000 nop        
00109A18 10000007 b          0x109a38
00109A1C 00000000 nop        
00109A20 0C042BB3 jal        0x10aecc
00109A24 00000000 nop        
00109A28 1000000C b          0x109a5c
00109A2C 00000000 nop        
00109A30 24C6FFFF addiu      $a2, $a2, -1
00109A34 A0A600F1 sb         $a2, 0xf1($a1)
00109A38 90A600E9 lbu        $a2, 0xe9($a1)
00109A3C 10C00005 beqz       $a2, 0x109a54
00109A40 00000000 nop        
00109A44 0C042706 jal        0x109c18
00109A48 00000000 nop        
00109A4C 10000003 b          0x109a5c
00109A50 00000000 nop        
00109A54 0C043057 jal        0x10c15c
00109A58 00000000 nop        
00109A5C 8FBF0010 lw         $ra, 0x10($sp)
00109A60 03E00008 jr         $ra
00109A64 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x00109CDC end 0x00109CE4 ordinal 3

00109CDC 03E00008 jr         $ra
00109CE0 00001025 move       $v0, $zero