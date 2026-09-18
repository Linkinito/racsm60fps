
CALLBACK 0x0010E704 end 0x0010E70C ordinal 0

0010E704 03E00008 jr         $ra
0010E708 34020001 ori        $v0, $zero, 1

CALLBACK 0x0010E70C end 0x0010E714 ordinal 1

0010E70C 03E00008 jr         $ra
0010E710 00000000 nop        

CALLBACK 0x0010E714 end 0x0010E77C ordinal 2

0010E714 27BDFFE0 addiu      $sp, $sp, -0x20
0010E718 90850045 lbu        $a1, 0x45($a0)
0010E71C AFBF0010 sw         $ra, 0x10($sp)
0010E720 1CA00007 bgtz       $a1, 0x10e740
0010E724 28A60002 slti       $a2, $a1, 2
0010E728 04A00011 bltz       $a1, 0x10e770
0010E72C 00000000 nop        
0010E730 0C043AC7 jal        0x10eb1c
0010E734 00000000 nop        
0010E738 1000000D b          0x10e770
0010E73C 00000000 nop        
0010E740 14C00005 bnez       $a2, 0x10e758
0010E744 28A50003 slti       $a1, $a1, 3
0010E748 14A00007 bnez       $a1, 0x10e768
0010E74C 00000000 nop        
0010E750 10000007 b          0x10e770
0010E754 00000000 nop        
0010E758 0C043B70 jal        0x10edc0
0010E75C 00000000 nop        
0010E760 10000003 b          0x10e770
0010E764 00000000 nop        
0010E768 0C043DF6 jal        0x10f7d8
0010E76C 00000000 nop        
0010E770 8FBF0010 lw         $ra, 0x10($sp)
0010E774 03E00008 jr         $ra
0010E778 27BD0020 addiu      $sp, $sp, 0x20