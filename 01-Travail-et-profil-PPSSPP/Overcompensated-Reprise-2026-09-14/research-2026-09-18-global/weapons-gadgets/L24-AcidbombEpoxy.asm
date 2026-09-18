
CALLBACK 0x000FEE08 end 0x000FEE10 ordinal 0

000FEE08 03E00008 jr         $ra
000FEE0C 34020001 ori        $v0, $zero, 1

CALLBACK 0x000FEE10 end 0x000FEE98 ordinal 1

000FEE10 27BDFFD0 addiu      $sp, $sp, -0x30
000FEE14 8C850058 lw         $a1, 0x58($a0)
000FEE18 8CA70004 lw         $a3, 4($a1)
000FEE1C AFBF0020 sw         $ra, 0x20($sp)
000FEE20 10E0001A beqz       $a3, 0xfee8c
000FEE24 00000000 nop        
000FEE28 8CE60040 lw         $a2, 0x40($a3)
000FEE2C 8CC60020 lw         $a2, 0x20($a2)
000FEE30 10C00016 beqz       $a2, 0xfee8c
000FEE34 3C08002A lui        $t0, 0x2a
000FEE38 2509A864 addiu      $t1, $t0, -0x579c
000FEE3C 25290140 addiu      $t1, $t1, 0x140
000FEE40 8D280000 lw         $t0, ($t1)
000FEE44 290A0002 slti       $t2, $t0, 2
000FEE48 15400007 bnez       $t2, 0xfee68
000FEE4C C52C0004 lwc1       $f12, 4($t1)
000FEE50 29080003 slti       $t0, $t0, 3
000FEE54 11000004 beqz       $t0, 0xfee68
000FEE58 3C083F00 lui        $t0, 0x3f00
000FEE5C 44886800 mtc1       $t0, $f13
000FEE60 10000001 b          0xfee68
000FEE64 460D6302 mul.s      $f12, $f12, $f13
000FEE68 24A8000C addiu      $t0, $a1, 0xc
000FEE6C 00C05025 move       $t2, $a2
000FEE70 00805825 move       $t3, $a0
000FEE74 8D250008 lw         $a1, 8($t1)
000FEE78 8D26000C lw         $a2, 0xc($t1)
000FEE7C 00E02025 move       $a0, $a3
000FEE80 25670030 addiu      $a3, $t3, 0x30
000FEE84 0140F809 jalr       $t2
000FEE88 01604825 move       $t1, $t3
000FEE8C 8FBF0020 lw         $ra, 0x20($sp)
000FEE90 03E00008 jr         $ra
000FEE94 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x000FEE98 end 0x000FF040 ordinal 2

000FEE98 27BDFFD0 addiu      $sp, $sp, -0x30
000FEE9C AFB00020 sw         $s0, 0x20($sp)
000FEEA0 00808025 move       $s0, $a0
000FEEA4 8E040058 lw         $a0, 0x58($s0)
000FEEA8 8C850004 lw         $a1, 4($a0)
000FEEAC AFBF0024 sw         $ra, 0x24($sp)
000FEEB0 10A0000B beqz       $a1, 0xfeee0
000FEEB4 00000000 nop        
000FEEB8 8CA60064 lw         $a2, 0x64($a1)
000FEEBC 30C70006 andi       $a3, $a2, 6
000FEEC0 14E00005 bnez       $a3, 0xfeed8
000FEEC4 30C70008 andi       $a3, $a2, 8
000FEEC8 14E00003 bnez       $a3, 0xfeed8
000FEECC 30C60001 andi       $a2, $a2, 1
000FEED0 14C00003 bnez       $a2, 0xfeee0
000FEED4 00000000 nop        
000FEED8 AC800004 sw         $zero, 4($a0)
000FEEDC 00002825 move       $a1, $zero
000FEEE0 10A00012 beqz       $a1, 0xfef2c
000FEEE4 00000000 nop        
000FEEE8 8C860008 lw         $a2, 8($a0)
000FEEEC 10C0000F beqz       $a2, 0xfef2c
000FEEF0 00000000 nop        
000FEEF4 8CC60064 lw         $a2, 0x64($a2)
000FEEF8 30C70006 andi       $a3, $a2, 6
000FEEFC 14E0000B bnez       $a3, 0xfef2c
000FEF00 30C70008 andi       $a3, $a2, 8
000FEF04 14E00009 bnez       $a3, 0xfef2c
000FEF08 30C60001 andi       $a2, $a2, 1
000FEF0C 10C00007 beqz       $a2, 0xfef2c
000FEF10 00000000 nop        
000FEF14 8CA60040 lw         $a2, 0x40($a1)
000FEF18 8CC60020 lw         $a2, 0x20($a2)
000FEF1C 14C00008 bnez       $a2, 0xfef40
000FEF20 3C07002A lui        $a3, 0x2a
000FEF24 1000001D b          0xfef9c
000FEF28 2404FFFF addiu      $a0, $zero, -1
000FEF2C 02002025 move       $a0, $s0
000FEF30 0C0192FF jal        0x64bfc
000FEF34 34050001 ori        $a1, $zero, 1
000FEF38 1000001E b          0xfefb4
000FEF3C 00000000 nop        
000FEF40 24E7A864 addiu      $a3, $a3, -0x579c
000FEF44 24E70130 addiu      $a3, $a3, 0x130
000FEF48 8CE80000 lw         $t0, ($a3)
000FEF4C 29090002 slti       $t1, $t0, 2
000FEF50 15200007 bnez       $t1, 0xfef70
000FEF54 C4EC0004 lwc1       $f12, 4($a3)
000FEF58 29080003 slti       $t0, $t0, 3
000FEF5C 11000004 beqz       $t0, 0xfef70
000FEF60 3C083F00 lui        $t0, 0x3f00
000FEF64 44886800 mtc1       $t0, $f13
000FEF68 10000001 b          0xfef70
000FEF6C 460D6302 mul.s      $f12, $f12, $f13
000FEF70 00C05025 move       $t2, $a2
000FEF74 8CE60008 lw         $a2, 8($a3)
000FEF78 2488000C addiu      $t0, $a0, 0xc
000FEF7C 8CE9000C lw         $t1, 0xc($a3)
000FEF80 00A02025 move       $a0, $a1
000FEF84 00C02825 move       $a1, $a2
000FEF88 01203025 move       $a2, $t1
000FEF8C 26070030 addiu      $a3, $s0, 0x30
000FEF90 0140F809 jalr       $t2
000FEF94 02004825 move       $t1, $s0
000FEF98 00402025 move       $a0, $v0
000FEF9C 34050003 ori        $a1, $zero, 3
000FEFA0 14850004 bne        $a0, $a1, 0xfefb4
000FEFA4 00000000 nop        
000FEFA8 02002025 move       $a0, $s0
000FEFAC 0C0192FF jal        0x64bfc
000FEFB0 34050001 ori        $a1, $zero, 1
000FEFB4 8FB00020 lw         $s0, 0x20($sp)
000FEFB8 8FBF0024 lw         $ra, 0x24($sp)
000FEFBC 03E00008 jr         $ra
000FEFC0 27BD0030 addiu      $sp, $sp, 0x30
000FEFC4 3C05002A lui        $a1, 0x2a
000FEFC8 8CA59868 lw         $a1, -0x6798($a1)
000FEFCC 8CA80038 lw         $t0, 0x38($a1)
000FEFD0 34090000 ori        $t1, $zero, 0
000FEFD4 0128202B sltu       $a0, $t1, $t0
000FEFD8 1080000F beqz       $a0, 0xff018
000FEFDC 00000000 nop        
000FEFE0 8CA50034 lw         $a1, 0x34($a1)
000FEFE4 3C06355F lui        $a2, 0x355f
000FEFE8 34040000 ori        $a0, $zero, 0
000FEFEC 00A03825 move       $a3, $a1
000FEFF0 24C68368 addiu      $a2, $a2, -0x7c98
000FEFF4 8CEA0030 lw         $t2, 0x30($a3)
000FEFF8 15460003 bne        $t2, $a2, 0xff008
000FEFFC 25290001 addiu      $t1, $t1, 1
000FF000 10000006 b          0xff01c
000FF004 00A42821 addu       $a1, $a1, $a0
000FF008 24840050 addiu      $a0, $a0, 0x50
000FF00C 0128502B sltu       $t2, $t1, $t0
000FF010 1540FFF8 bnez       $t2, 0xfeff4
000FF014 24E70050 addiu      $a3, $a3, 0x50
000FF018 34050000 ori        $a1, $zero, 0
000FF01C 8CA4000C lw         $a0, 0xc($a1)
000FF020 8CA5003C lw         $a1, 0x3c($a1)
000FF024 3C06002A lui        $a2, 0x2a
000FF028 ACC4C3B8 sw         $a0, -0x3c48($a2)
000FF02C 000529C0 sll        $a1, $a1, 7
000FF030 00852021 addu       $a0, $a0, $a1
000FF034 3C05002A lui        $a1, 0x2a
000FF038 03E00008 jr         $ra
000FF03C ACA4C3BC sw         $a0, -0x3c44($a1)