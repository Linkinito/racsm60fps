
CALLBACK 0x000FFD78 end 0x000FFE54 ordinal 0

000FFD78 27BDFFE0 addiu      $sp, $sp, -0x20
000FFD7C 8C850064 lw         $a1, 0x64($a0)
000FFD80 3C064461 lui        $a2, 0x4461
000FFD84 44866000 mtc1       $a2, $f12
000FFD88 34A50400 ori        $a1, $a1, 0x400
000FFD8C E48C0070 swc1       $f12, 0x70($a0)
000FFD90 AC850064 sw         $a1, 0x64($a0)
000FFD94 34A51000 ori        $a1, $a1, 0x1000
000FFD98 AC850064 sw         $a1, 0x64($a0)
000FFD9C 8C850048 lw         $a1, 0x48($a0)
000FFDA0 3C060010 lui        $a2, 0x10
000FFDA4 24C63FA0 addiu      $a2, $a2, 0x3fa0
000FFDA8 ACA600DC sw         $a2, 0xdc($a1)
000FFDAC 8C850064 lw         $a1, 0x64($a0)
000FFDB0 8C860058 lw         $a2, 0x58($a0)
000FFDB4 34A54000 ori        $a1, $a1, 0x4000
000FFDB8 AC850064 sw         $a1, 0x64($a0)
000FFDBC ACC00070 sw         $zero, 0x70($a2)
000FFDC0 34050002 ori        $a1, $zero, 2
000FFDC4 A0C5000E sb         $a1, 0xe($a2)
000FFDC8 ACC40010 sw         $a0, 0x10($a2)
000FFDCC ACC00014 sw         $zero, 0x14($a2)
000FFDD0 44806000 mtc1       $zero, $f12
000FFDD4 ACC00000 sw         $zero, ($a2)
000FFDD8 E4CC004C swc1       $f12, 0x4c($a2)
000FFDDC E4CC0050 swc1       $f12, 0x50($a2)
000FFDE0 E4CC0054 swc1       $f12, 0x54($a2)
000FFDE4 E4CC0044 swc1       $f12, 0x44($a2)
000FFDE8 E4CC0048 swc1       $f12, 0x48($a2)
000FFDEC ACC00068 sw         $zero, 0x68($a2)
000FFDF0 ACC0006C sw         $zero, 0x6c($a2)
000FFDF4 A0C000E8 sb         $zero, 0xe8($a2)
000FFDF8 A0C000ED sb         $zero, 0xed($a2)
000FFDFC A0C000EE sb         $zero, 0xee($a2)
000FFE00 A0C000EF sb         $zero, 0xef($a2)
000FFE04 A0C000F2 sb         $zero, 0xf2($a2)
000FFE08 3C05002A lui        $a1, 0x2a
000FFE0C C4ADC574 lwc1       $f13, -0x3a8c($a1)
000FFE10 46006B4D trunc.w.s  $f13, $f13
000FFE14 A0C000EB sb         $zero, 0xeb($a2)
000FFE18 E4CC005C swc1       $f12, 0x5c($a2)
000FFE1C E4CC0060 swc1       $f12, 0x60($a2)
000FFE20 E4CC0064 swc1       $f12, 0x64($a2)
000FFE24 44056800 mfc1       $a1, $f13
000FFE28 A0C500F1 sb         $a1, 0xf1($a2)
000FFE2C 24840074 addiu      $a0, $a0, 0x74
000FFE30 2407FFFF addiu      $a3, $zero, -1
000FFE34 34050005 ori        $a1, $zero, 5
000FFE38 AFBF0010 sw         $ra, 0x10($sp)
000FFE3C 0C006F54 jal        0x1bd50
000FFE40 2406FFFF addiu      $a2, $zero, -1
000FFE44 34020001 ori        $v0, $zero, 1
000FFE48 8FBF0010 lw         $ra, 0x10($sp)
000FFE4C 03E00008 jr         $ra
000FFE50 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x000FFE54 end 0x000FFF14 ordinal 1

000FFE54 27BDFFD0 addiu      $sp, $sp, -0x30
000FFE58 AFB00010 sw         $s0, 0x10($sp)
000FFE5C 8C900058 lw         $s0, 0x58($a0)
000FFE60 920400E9 lbu        $a0, 0xe9($s0)
000FFE64 AFB10014 sw         $s1, 0x14($sp)
000FFE68 AFB20018 sw         $s2, 0x18($sp)
000FFE6C AFB3001C sw         $s3, 0x1c($sp)
000FFE70 AFBF0020 sw         $ra, 0x20($sp)
000FFE74 10800016 beqz       $a0, 0xffed0
000FFE78 00000000 nop        
000FFE7C 34130000 ori        $s3, $zero, 0
000FFE80 02009025 move       $s2, $s0
000FFE84 3C110028 lui        $s1, 0x28
000FFE88 8E450034 lw         $a1, 0x34($s2)
000FFE8C 10A0000C beqz       $a1, 0xffec0
000FFE90 00000000 nop        
000FFE94 00A02025 move       $a0, $a1
000FFE98 10800008 beqz       $a0, 0xffebc
000FFE9C 00000000 nop        
000FFEA0 8E2627F8 lw         $a2, 0x27f8($s1)
000FFEA4 14A60003 bne        $a1, $a2, 0xffeb4
000FFEA8 00000000 nop        
000FFEAC 10000003 b          0xffebc
000FFEB0 AE2027F8 sw         $zero, 0x27f8($s1)
000FFEB4 0C02172B jal        0x85cac
000FFEB8 00000000 nop        
000FFEBC AE400034 sw         $zero, 0x34($s2)
000FFEC0 26730001 addiu      $s3, $s3, 1
000FFEC4 2E640008 sltiu      $a0, $s3, 8
000FFEC8 1480FFEF bnez       $a0, 0xffe88
000FFECC 26520004 addiu      $s2, $s2, 4
000FFED0 8E040014 lw         $a0, 0x14($s0)
000FFED4 10800008 beqz       $a0, 0xffef8
000FFED8 00000000 nop        
000FFEDC 8E050000 lw         $a1, ($s0)
000FFEE0 10A00004 beqz       $a1, 0xffef4
000FFEE4 AC850000 sw         $a1, ($a0)
000FFEE8 8E040014 lw         $a0, 0x14($s0)
000FFEEC 8E050000 lw         $a1, ($s0)
000FFEF0 ACA40014 sw         $a0, 0x14($a1)
000FFEF4 AE000014 sw         $zero, 0x14($s0)
000FFEF8 8FB00010 lw         $s0, 0x10($sp)
000FFEFC 8FB10014 lw         $s1, 0x14($sp)
000FFF00 8FB20018 lw         $s2, 0x18($sp)
000FFF04 8FB3001C lw         $s3, 0x1c($sp)
000FFF08 8FBF0020 lw         $ra, 0x20($sp)
000FFF0C 03E00008 jr         $ra
000FFF10 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x000FFF14 end 0x000FFFC0 ordinal 2

000FFF14 27BDFFE0 addiu      $sp, $sp, -0x20
000FFF18 8C850058 lw         $a1, 0x58($a0)
000FFF1C ACA000DC sw         $zero, 0xdc($a1)
000FFF20 C48C0070 lwc1       $f12, 0x70($a0)
000FFF24 44806800 mtc1       $zero, $f13
000FFF28 AFBF0010 sw         $ra, 0x10($sp)
000FFF2C 460D603E c.le.s     $f12, $f13
000FFF30 00000000 nop        
000FFF34 45000008 bc1f       0xfff58
000FFF38 3C06BF80 lui        $a2, 0xbf80
000FFF3C 90A600EE lbu        $a2, 0xee($a1)
000FFF40 10C0000D beqz       $a2, 0xfff78
000FFF44 00000000 nop        
000FFF48 8CA60068 lw         $a2, 0x68($a1)
000FFF4C 10C0000A beqz       $a2, 0xfff78
000FFF50 00000000 nop        
000FFF54 3C06BF80 lui        $a2, 0xbf80
000FFF58 44866800 mtc1       $a2, $f13
000FFF5C 460D6300 add.s      $f12, $f12, $f13
000FFF60 E48C0070 swc1       $f12, 0x70($a0)
000FFF64 90A600F1 lbu        $a2, 0xf1($a1)
000FFF68 14C00007 bnez       $a2, 0xfff88
000FFF6C 00000000 nop        
000FFF70 10000007 b          0xfff90
000FFF74 00000000 nop        
000FFF78 0C040509 jal        0x101424
000FFF7C 00000000 nop        
000FFF80 1000000C b          0xfffb4
000FFF84 00000000 nop        
000FFF88 24C6FFFF addiu      $a2, $a2, -1
000FFF8C A0A600F1 sb         $a2, 0xf1($a1)
000FFF90 90A600E9 lbu        $a2, 0xe9($a1)
000FFF94 10C00005 beqz       $a2, 0xfffac
000FFF98 00000000 nop        
000FFF9C 0C04005C jal        0x100170
000FFFA0 00000000 nop        
000FFFA4 10000003 b          0xfffb4
000FFFA8 00000000 nop        
000FFFAC 0C0409AD jal        0x1026b4
000FFFB0 00000000 nop        
000FFFB4 8FBF0010 lw         $ra, 0x10($sp)
000FFFB8 03E00008 jr         $ra
000FFFBC 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x00100234 end 0x0010023C ordinal 3

00100234 03E00008 jr         $ra
00100238 00001025 move       $v0, $zero