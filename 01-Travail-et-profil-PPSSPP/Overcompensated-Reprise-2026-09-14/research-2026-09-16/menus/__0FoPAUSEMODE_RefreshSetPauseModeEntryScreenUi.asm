000178DC 02008014 bnez       $a0, 0x178e8
000178E0 00000000 nop        
000178E4 03000434 ori        $a0, $zero, 3
000178E8 0a00053c lui        $a1, 0xa
000178EC b813a4ac sw         $a0, 0x13b8($a1)
000178F0 02000434 ori        $a0, $zero, 2
000178F4 b813a524 addiu      $a1, $a1, 0x13b8
000178F8 0800a4ac sw         $a0, 8($a1)
000178FC 0800e003 jr         $ra
00017900 01000234 ori        $v0, $zero, 1