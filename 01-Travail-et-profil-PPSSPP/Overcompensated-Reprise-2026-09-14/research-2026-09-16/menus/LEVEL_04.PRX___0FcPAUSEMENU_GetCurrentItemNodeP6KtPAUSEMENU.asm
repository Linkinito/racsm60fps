000AC7F0 0400858c lw         $a1, 4($a0)
000AC7F4 0300a014 bnez       $a1, 0xac804
000AC7F8 00000000 nop        
000AC7FC 06000010 b          0xac818
000AC800 25100000 move       $v0, $zero
000AC804 0800858c lw         $a1, 8($a0)
000AC808 0000848c lw         $a0, ($a0)
000AC80C 80280500 sll        $a1, $a1, 2
000AC810 21208500 addu       $a0, $a0, $a1
000AC814 0000828c lw         $v0, ($a0)
000AC818 0800e003 jr         $ra
000AC81C 00000000 nop        