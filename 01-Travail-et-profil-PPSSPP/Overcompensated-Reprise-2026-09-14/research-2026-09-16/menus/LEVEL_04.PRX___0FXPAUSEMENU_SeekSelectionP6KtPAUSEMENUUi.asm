000ABBB4 e0ffbd27 addiu      $sp, $sp, -0x20
000ABBB8 0800878c lw         $a3, 8($a0)
000ABBBC 1000b0af sw         $s0, 0x10($sp)
000ABBC0 00001034 ori        $s0, $zero, 0
000ABBC4 2530e000 move       $a2, $a3
000ABBC8 5000a930 andi       $t1, $a1, 0x50
000ABBCC 1400bfaf sw         $ra, 0x14($sp)
000ABBD0 07002015 bnez       $t1, 0xabbf0
000ABBD4 0000888c lw         $t0, ($a0)
000ABBD8 80480700 sll        $t1, $a3, 2
000ABBDC 21480901 addu       $t1, $t0, $t1
000ABBE0 0000298d lw         $t1, ($t1)
000ABBE4 cc002991 lbu        $t1, 0xcc($t1)
000ABBE8 1e002015 bnez       $t1, 0xabc64
000ABBEC 00000000 nop        
000ABBF0 2548a000 move       $t1, $a1
000ABBF4 01000534 ori        $a1, $zero, 1
000ABBF8 10002931 andi       $t1, $t1, 0x10
000ABBFC 01002055 bnel       $t1, $zero, 0xabc04
000ABC00 ffff0524 addiu      $a1, $zero, -1
000ABC04 04008a8c lw         $t2, 4($a0)
000ABC08 ffff4925 addiu      $t1, $t2, -1
000ABC0C 2130c500 addu       $a2, $a2, $a1
000ABC10 0200c104 bgez       $a2, 0xabc1c
000ABC14 00000000 nop        
000ABC18 25302001 move       $a2, $t1
000ABC1C 2b58ca00 sltu       $t3, $a2, $t2
000ABC20 02006015 bnez       $t3, 0xabc2c
000ABC24 00000000 nop        
000ABC28 00000634 ori        $a2, $zero, 0
000ABC2C 80580600 sll        $t3, $a2, 2
000ABC30 21580b01 addu       $t3, $t0, $t3
000ABC34 00006b8d lw         $t3, ($t3)
000ABC38 cc006291 lbu        $v0, 0xcc($t3)
000ABC3C 05004010 beqz       $v0, 0xabc54
000ABC40 00000000 nop        
000ABC44 cd006b91 lbu        $t3, 0xcd($t3)
000ABC48 02006011 beqz       $t3, 0xabc54
000ABC4C 00000000 nop        
000ABC50 01001034 ori        $s0, $zero, 1
000ABC54 0300c710 beq        $a2, $a3, 0xabc64
000ABC58 00000000 nop        
000ABC5C ebff0012 beqz       $s0, 0xabc0c
000ABC60 00000000 nop        
000ABC64 03000012 beqz       $s0, 0xabc74
000ABC68 00000000 nop        
000ABC6C 01000010 b          0xabc74
000ABC70 2538c000 move       $a3, $a2
000ABC74 03000012 beqz       $s0, 0xabc84
000ABC78 080087ac sw         $a3, 8($a0)
000ABC7C 24a4020c jal        0xa9090
000ABC80 08000434 ori        $a0, $zero, 8
000ABC84 25100002 move       $v0, $s0
000ABC88 1000b08f lw         $s0, 0x10($sp)
000ABC8C 1400bf8f lw         $ra, 0x14($sp)
000ABC90 0800e003 jr         $ra
000ABC94 2000bd27 addiu      $sp, $sp, 0x20