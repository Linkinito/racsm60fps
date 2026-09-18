
CALLBACK 0x00104C5C end 0x00104C64 ordinal 0

00104C5C 03E00008 jr         $ra
00104C60 34020001 ori        $v0, $zero, 1

CALLBACK 0x00104C64 end 0x00104C6C ordinal 1

00104C64 03E00008 jr         $ra
00104C68 00000000 nop        

CALLBACK 0x00104C6C end 0x00104CD4 ordinal 2

00104C6C 27BDFFE0 addiu      $sp, $sp, -0x20
00104C70 90850045 lbu        $a1, 0x45($a0)
00104C74 AFBF0010 sw         $ra, 0x10($sp)
00104C78 1CA00007 bgtz       $a1, 0x104c98
00104C7C 28A60002 slti       $a2, $a1, 2
00104C80 04A00011 bltz       $a1, 0x104cc8
00104C84 00000000 nop        
00104C88 0C04141D jal        0x105074
00104C8C 00000000 nop        
00104C90 1000000D b          0x104cc8
00104C94 00000000 nop        
00104C98 14C00005 bnez       $a2, 0x104cb0
00104C9C 28A50003 slti       $a1, $a1, 3
00104CA0 14A00007 bnez       $a1, 0x104cc0
00104CA4 00000000 nop        
00104CA8 10000007 b          0x104cc8
00104CAC 00000000 nop        
00104CB0 0C0414C6 jal        0x105318
00104CB4 00000000 nop        
00104CB8 10000003 b          0x104cc8
00104CBC 00000000 nop        
00104CC0 0C04174C jal        0x105d30
00104CC4 00000000 nop        
00104CC8 8FBF0010 lw         $ra, 0x10($sp)
00104CCC 03E00008 jr         $ra
00104CD0 27BD0020 addiu      $sp, $sp, 0x20