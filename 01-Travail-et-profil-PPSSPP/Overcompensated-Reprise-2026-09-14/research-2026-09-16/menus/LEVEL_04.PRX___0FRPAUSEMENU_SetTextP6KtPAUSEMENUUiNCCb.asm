000ABE04 0400898c lw         $t1, 4($a0)
000ABE08 2b48a900 sltu       $t1, $a1, $t1
000ABE0C 03002015 bnez       $t1, 0xabe1c
000ABE10 ff000831 andi       $t0, $t0, 0xff
000ABE14 10000010 b          0xabe58
000ABE18 25100000 move       $v0, $zero
000ABE1C 0000898c lw         $t1, ($a0)
000ABE20 80280500 sll        $a1, $a1, 2
000ABE24 21482501 addu       $t1, $t1, $a1
000ABE28 00310600 sll        $a2, $a2, 4
000ABE2C 0000298d lw         $t1, ($t1)
000ABE30 2150c600 addu       $t2, $a2, $a2
000ABE34 2130ca00 addu       $a2, $a2, $t2
000ABE38 21482601 addu       $t1, $t1, $a2
000ABE3C 000027ad sw         $a3, ($t1)
000ABE40 0000848c lw         $a0, ($a0)
000ABE44 01000234 ori        $v0, $zero, 1
000ABE48 21208500 addu       $a0, $a0, $a1
000ABE4C 0000848c lw         $a0, ($a0)
000ABE50 21208600 addu       $a0, $a0, $a2
000ABE54 0c0088a0 sb         $t0, 0xc($a0)
000ABE58 0800e003 jr         $ra
000ABE5C 00000000 nop        