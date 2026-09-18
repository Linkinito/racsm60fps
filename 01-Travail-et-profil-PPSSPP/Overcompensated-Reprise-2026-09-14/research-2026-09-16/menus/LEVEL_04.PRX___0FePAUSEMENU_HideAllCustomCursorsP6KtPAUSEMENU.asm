000ABF78 d0ffbd27 addiu      $sp, $sp, -0x30
000ABF7C 1000b0af sw         $s0, 0x10($sp)
000ABF80 25808000 move       $s0, $a0
000ABF84 1400b1af sw         $s1, 0x14($sp)
000ABF88 1800b2af sw         $s2, 0x18($sp)
000ABF8C 1c00b3af sw         $s3, 0x1c($sp)
000ABF90 2000bfaf sw         $ra, 0x20($sp)
000ABF94 0400048e lw         $a0, 4($s0)
000ABF98 00001334 ori        $s3, $zero, 0
000ABF9C 2b206402 sltu       $a0, $s3, $a0
000ABFA0 0f008010 beqz       $a0, 0xabfe0
000ABFA4 ffff1124 addiu      $s1, $zero, -1
000ABFA8 00001234 ori        $s2, $zero, 0
000ABFAC 0000048e lw         $a0, ($s0)
000ABFB0 21209200 addu       $a0, $a0, $s2
000ABFB4 0000848c lw         $a0, ($a0)
000ABFB8 c800848c lw         $a0, 0xc8($a0)
000ABFBC 03009110 beq        $a0, $s1, 0xabfcc
000ABFC0 00000000 nop        
000ABFC4 b683020c jal        0xa0ed8
000ABFC8 25280000 move       $a1, $zero
000ABFCC 0400048e lw         $a0, 4($s0)
000ABFD0 01007326 addiu      $s3, $s3, 1
000ABFD4 2b206402 sltu       $a0, $s3, $a0
000ABFD8 f4ff8014 bnez       $a0, 0xabfac
000ABFDC 04005226 addiu      $s2, $s2, 4
000ABFE0 1000b08f lw         $s0, 0x10($sp)
000ABFE4 1400b18f lw         $s1, 0x14($sp)
000ABFE8 1800b28f lw         $s2, 0x18($sp)
000ABFEC 1c00b38f lw         $s3, 0x1c($sp)
000ABFF0 2000bf8f lw         $ra, 0x20($sp)
000ABFF4 0800e003 jr         $ra
000ABFF8 3000bd27 addiu      $sp, $sp, 0x30