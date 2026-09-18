00018BB8 0500862c sltiu      $a2, $a0, 5
00018BBC 0300c014 bnez       $a2, 0x18bcc
00018BC0 1200053c lui        $a1, 0x12
00018BC4 05000010 b          0x18bdc
00018BC8 38faa28c lw         $v0, -0x5c8($a1)
00018BCC 80200400 sll        $a0, $a0, 2
00018BD0 38faa524 addiu      $a1, $a1, -0x5c8
00018BD4 21208500 addu       $a0, $a0, $a1
00018BD8 0000828c lw         $v0, ($a0)
00018BDC 0800e003 jr         $ra
00018BE0 00000000 nop        