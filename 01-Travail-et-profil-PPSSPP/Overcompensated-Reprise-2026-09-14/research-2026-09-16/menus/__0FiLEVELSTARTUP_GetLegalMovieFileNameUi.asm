00018B8C 0500862c sltiu      $a2, $a0, 5
00018B90 0300c014 bnez       $a2, 0x18ba0
00018B94 1200053c lui        $a1, 0x12
00018B98 05000010 b          0x18bb0
00018B9C 24faa28c lw         $v0, -0x5dc($a1)
00018BA0 80200400 sll        $a0, $a0, 2
00018BA4 24faa524 addiu      $a1, $a1, -0x5dc
00018BA8 21208500 addu       $a0, $a0, $a1
00018BAC 0000828c lw         $v0, ($a0)
00018BB0 0800e003 jr         $ra
00018BB4 00000000 nop        