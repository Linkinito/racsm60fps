000AC970 20fdbd27 addiu      $sp, $sp, -0x2e0
000AC974 9802b4e7 swc1       $f20, 0x298($sp)
000AC978 9c02b6e7 swc1       $f22, 0x29c($sp)
000AC97C a002b8e7 swc1       $f24, 0x2a0($sp)
000AC980 a402bae7 swc1       $f26, 0x2a4($sp)
000AC984 a802bce7 swc1       $f28, 0x2a8($sp)
000AC988 ac02bee7 swc1       $f30, 0x2ac($sp)
000AC98C b002b0af sw         $s0, 0x2b0($sp)
000AC990 b402b1af sw         $s1, 0x2b4($sp)
000AC994 b802b2af sw         $s2, 0x2b8($sp)
000AC998 bc02b3af sw         $s3, 0x2bc($sp)
000AC99C c002b4af sw         $s4, 0x2c0($sp)
000AC9A0 c402b5af sw         $s5, 0x2c4($sp)
000AC9A4 c802b6af sw         $s6, 0x2c8($sp)
000AC9A8 cc02b7af sw         $s7, 0x2cc($sp)
000AC9AC d002beaf sw         $fp, 0x2d0($sp)
000AC9B0 d402bfaf sw         $ra, 0x2d4($sp)
000AC9B4 6f72020c jal        0x9c9bc
000AC9B8 25908000 move       $s2, $a0
000AC9BC 9002a2a3 sb         $v0, 0x290($sp)
000AC9C0 6c72020c jal        0x9c9b0
000AC9C4 25200000 move       $a0, $zero
000AC9C8 1400448e lw         $a0, 0x14($s2)
000AC9CC 00001134 ori        $s1, $zero, 0
000AC9D0 02008430 andi       $a0, $a0, 2
000AC9D4 15008010 beqz       $a0, 0xaca2c
000AC9D8 01001034 ori        $s0, $zero, 1
000AC9DC 5000448e lw         $a0, 0x50($s2)
000AC9E0 4800458e lw         $a1, 0x48($s2)
000AC9E4 00340400 sll        $a2, $a0, 0x10
000AC9E8 03340600 sra        $a2, $a2, 0x10
000AC9EC 2128c500 addu       $a1, $a2, $a1
000AC9F0 008c0500 sll        $s1, $a1, 0x10
000AC9F4 2d00053c lui        $a1, 0x2d
000AC9F8 8cf7a590 lbu        $a1, -0x874($a1)
000AC9FC 0b00a010 beqz       $a1, 0xaca2c
000ACA00 038c1100 sra        $s1, $s1, 0x10
000ACA04 5800458e lw         $a1, 0x58($s2)
000ACA08 5c00468e lw         $a2, 0x5c($s2)
000ACA0C ffffa830 andi       $t0, $a1, 0xffff
000ACA10 ffff8530 andi       $a1, $a0, 0xffff
000ACA14 5400478e lw         $a3, 0x54($s2)
000ACA18 25200001 move       $a0, $t0
000ACA1C ffffc630 andi       $a2, $a2, 0xffff
000ACA20 ffffe730 andi       $a3, $a3, 0xffff
000ACA24 0973020c jal        0x9cc24
000ACA28 01000834 ori        $t0, $zero, 1
000ACA2C 3000a0af sw         $zero, 0x30($sp)
000ACA30 3400a0af sw         $zero, 0x34($sp)
000ACA34 3000a527 addiu      $a1, $sp, 0x30
000ACA38 3400a627 addiu      $a2, $sp, 0x34
000ACA3C 84b0020c jal        0xac210
000ACA40 25204002 move       $a0, $s2
000ACA44 9800458e lw         $a1, 0x98($s2)
000ACA48 0a00b010 beq        $a1, $s0, 0xaca74
000ACA4C 00000434 ori        $a0, $zero, 0
000ACA50 3000a68f lw         $a2, 0x30($sp)
000ACA54 0500c014 bnez       $a2, 0xaca6c
000ACA58 00000000 nop        
000ACA5C 3400a68f lw         $a2, 0x34($sp)
000ACA60 0400478e lw         $a3, 4($s2)
000ACA64 0400c710 beq        $a2, $a3, 0xaca78
000ACA68 00000000 nop        
000ACA6C 0200a010 beqz       $a1, 0xaca78
000ACA70 00000000 nop        
000ACA74 25200002 move       $a0, $s0
000ACA78 ff008430 andi       $a0, $a0, 0xff
000ACA7C 00000534 ori        $a1, $zero, 0
000ACA80 05008010 beqz       $a0, 0xaca98
000ACA84 8c02a4af sw         $a0, 0x28c($sp)
000ACA88 9c004492 lbu        $a0, 0x9c($s2)
000ACA8C 02008014 bnez       $a0, 0xaca98
000ACA90 00000000 nop        
000ACA94 13000534 ori        $a1, $zero, 0x13
000ACA98 1400448e lw         $a0, 0x14($s2)
000ACA9C 04008430 andi       $a0, $a0, 4
000ACAA0 12008010 beqz       $a0, 0xacaec
000ACAA4 8802a5af sw         $a1, 0x288($sp)
000ACAA8 5800448e lw         $a0, 0x58($s2)
000ACAAC 5000468e lw         $a2, 0x50($s2)
000ACAB0 8802a5af sw         $a1, 0x288($sp)
000ACAB4 5c00478e lw         $a3, 0x5c($s2)
000ACAB8 00340600 sll        $a2, $a2, 0x10
000ACABC 2328e500 subu       $a1, $a3, $a1
000ACAC0 03440600 sra        $t0, $a2, 0x10
000ACAC4 5400478e lw         $a3, 0x54($s2)
000ACAC8 00340500 sll        $a2, $a1, 0x10
000ACACC 00240400 sll        $a0, $a0, 0x10
000ACAD0 003c0700 sll        $a3, $a3, 0x10
000ACAD4 25280001 move       $a1, $t0
000ACAD8 03240400 sra        $a0, $a0, 0x10
000ACADC 03340600 sra        $a2, $a2, 0x10
000ACAE0 033c0700 sra        $a3, $a3, 0x10
000ACAE4 177b020c jal        0x9ec5c
000ACAE8 4040083c lui        $t0, 0x4040
000ACAEC 7802b1a7 sh         $s1, 0x278($sp)
000ACAF0 0000448e lw         $a0, ($s2)
000ACAF4 03008054 bnel       $a0, $zero, 0xacb04
000ACAF8 3000b68f lw         $s6, 0x30($sp)
000ACAFC 03030010 b          0xad70c
000ACB00 00000000 nop        
000ACB04 00d08044 mtc1       $zero, $f26
000ACB08 7802b187 lh         $s1, 0x278($sp)
000ACB0C 00291600 sll        $a1, $s6, 4
000ACB10 2000a624 addiu      $a2, $a1, 0x20
000ACB14 2f00a524 addiu      $a1, $a1, 0x2f
000ACB18 8402a6af sw         $a2, 0x284($sp)
000ACB1C 803f043c lui        $a0, 0x3f80
000ACB20 8002a5af sw         $a1, 0x280($sp)
000ACB24 00e08444 mtc1       $a0, $f28
000ACB28 004f053c lui        $a1, 0x4f00
000ACB2C ffff1524 addiu      $s5, $zero, -1
000ACB30 00f08544 mtc1       $a1, $f30
000ACB34 4800b727 addiu      $s7, $sp, 0x48
000ACB38 0004c42e sltiu      $a0, $s6, 0x400
000ACB3C 80a01600 sll        $s4, $s6, 2
000ACB40 4a028010 beqz       $a0, 0xad46c
000ACB44 00000000 nop        
000ACB48 0000448e lw         $a0, ($s2)
000ACB4C 21209400 addu       $a0, $a0, $s4
000ACB50 0000848c lw         $a0, ($a0)
000ACB54 45028010 beqz       $a0, 0xad46c
000ACB58 00000000 nop        
000ACB5C 3400a48f lw         $a0, 0x34($sp)
000ACB60 2b20c402 sltu       $a0, $s6, $a0
000ACB64 41028010 beqz       $a0, 0xad46c
000ACB68 00000000 nop        
000ACB6C 1400448e lw         $a0, 0x14($s2)
000ACB70 00001e34 ori        $fp, $zero, 0
000ACB74 01008430 andi       $a0, $a0, 1
000ACB78 0100842c sltiu      $a0, $a0, 1
000ACB7C 7c02a4af sw         $a0, 0x27c($sp)
000ACB80 00001334 ori        $s3, $zero, 0
000ACB84 0000448e lw         $a0, ($s2)
000ACB88 21489400 addu       $t1, $a0, $s4
000ACB8C 0000298d lw         $t1, ($t1)
000ACB90 cd002591 lbu        $a1, 0xcd($t1)
000ACB94 2202a010 beqz       $a1, 0xad420
000ACB98 7c02b08f lw         $s0, 0x27c($sp)
000ACB9C 0400c017 bnez       $fp, 0xacbb0
000ACBA0 1400478e lw         $a3, 0x14($s2)
000ACBA4 0000858c lw         $a1, ($a0)
000ACBA8 02000010 b          0xacbb4
000ACBAC c000b8c4 lwc1       $f24, 0xc0($a1)
000ACBB0 06e60046 mov.s      $f24, $f28
000ACBB4 0400c057 bnel       $fp, $zero, 0xacbc8
000ACBB8 86e50046 mov.s      $f22, $f28
000ACBBC 0000848c lw         $a0, ($a0)
000ACBC0 01000010 b          0xacbc8
000ACBC4 c40096c4 lwc1       $f22, 0xc4($a0)
000ACBC8 0200e430 andi       $a0, $a3, 2
000ACBCC 44008014 bnez       $a0, 0xacce0
000ACBD0 06b50046 mov.s      $f20, $f22
000ACBD4 0800448e lw         $a0, 8($s2)
000ACBD8 1c00c416 bne        $s6, $a0, 0xacc4c
000ACBDC 00000000 nop        
000ACBE0 cc002491 lbu        $a0, 0xcc($t1)
000ACBE4 19008010 beqz       $a0, 0xacc4c
000ACBE8 00000000 nop        
000ACBEC 21203301 addu       $a0, $t1, $s3
000ACBF0 0400848c lw         $a0, 4($a0)
000ACBF4 3a008010 beqz       $a0, 0xacce0
000ACBF8 00000000 nop        
000ACBFC 6172020c jal        0x9c984
000ACC00 1800448e lw         $a0, 0x18($s2)
000ACC04 0000448e lw         $a0, ($s2)
000ACC08 06c30046 mov.s      $f12, $f24
000ACC0C 46a30046 mov.s      $f13, $f20
000ACC10 04000534 ori        $a1, $zero, 4
000ACC14 21209400 addu       $a0, $a0, $s4
000ACC18 86d30046 mov.s      $f14, $f26
000ACC1C 0000848c lw         $a0, ($a0)
000ACC20 c6d30046 mov.s      $f15, $f26
000ACC24 25300000 move       $a2, $zero
000ACC28 21209300 addu       $a0, $a0, $s3
000ACC2C 0400848c lw         $a0, 4($a0)
000ACC30 25380000 move       $a3, $zero
000ACC34 6490020c jal        0xa4190
000ACC38 ffff0824 addiu      $t0, $zero, -1
000ACC3C 0000448e lw         $a0, ($s2)
000ACC40 21489400 addu       $t1, $a0, $s4
000ACC44 26000010 b          0xacce0
000ACC48 0000298d lw         $t1, ($t1)
000ACC4C 24000012 beqz       $s0, 0xacce0
000ACC50 00000000 nop        
000ACC54 21203301 addu       $a0, $t1, $s3
000ACC58 0400848c lw         $a0, 4($a0)
000ACC5C 20008010 beqz       $a0, 0xacce0
000ACC60 00000000 nop        
000ACC64 2528e000 move       $a1, $a3
000ACC68 2540a002 move       $t0, $s5
000ACC6C 2000a530 andi       $a1, $a1, 0x20
000ACC70 1000a010 beqz       $a1, 0xaccb4
000ACC74 00000734 ori        $a3, $zero, 0
000ACC78 e0002591 lbu        $a1, 0xe0($t1)
000ACC7C 0d00a010 beqz       $a1, 0xaccb4
000ACC80 00000000 nop        
000ACC84 9402b0af sw         $s0, 0x294($sp)
000ACC88 2d00103c lui        $s0, 0x2d
000ACC8C 6172020c jal        0x9c984
000ACC90 88f7048e lw         $a0, -0x878($s0)
000ACC94 0000448e lw         $a0, ($s2)
000ACC98 88f7088e lw         $t0, -0x878($s0)
000ACC9C 21209400 addu       $a0, $a0, $s4
000ACCA0 0000848c lw         $a0, ($a0)
000ACCA4 04000734 ori        $a3, $zero, 4
000ACCA8 21209300 addu       $a0, $a0, $s3
000ACCAC 0400848c lw         $a0, 4($a0)
000ACCB0 9402b08f lw         $s0, 0x294($sp)
000ACCB4 ff00e530 andi       $a1, $a3, 0xff
000ACCB8 06c30046 mov.s      $f12, $f24
000ACCBC 46a30046 mov.s      $f13, $f20
000ACCC0 25300000 move       $a2, $zero
000ACCC4 86d30046 mov.s      $f14, $f26
000ACCC8 25380000 move       $a3, $zero
000ACCCC 6490020c jal        0xa4190
000ACCD0 c6d30046 mov.s      $f15, $f26
000ACCD4 0000448e lw         $a0, ($s2)
000ACCD8 21489400 addu       $t1, $a0, $s4
000ACCDC 0000298d lw         $t1, ($t1)
000ACCE0 2600c017 bnez       $fp, 0xacd7c
000ACCE4 00000000 nop        
000ACCE8 0800448e lw         $a0, 8($s2)
000ACCEC 2300c416 bne        $s6, $a0, 0xacd7c
000ACCF0 00000000 nop        
000ACCF4 cc002491 lbu        $a0, 0xcc($t1)
000ACCF8 20008010 beqz       $a0, 0xacd7c
000ACCFC 00000000 nop        
000ACD00 c800248d lw         $a0, 0xc8($t1)
000ACD04 1d009510 beq        $a0, $s5, 0xacd7c
000ACD08 00000000 nop        
000ACD0C 1b008010 beqz       $a0, 0xacd7c
000ACD10 00000000 nop        
000ACD14 b683020c jal        0xa0ed8
000ACD18 01000534 ori        $a1, $zero, 1
000ACD1C 6172020c jal        0x9c984
000ACD20 1c00448e lw         $a0, 0x1c($s2)
000ACD24 0000448e lw         $a0, ($s2)
000ACD28 06c30046 mov.s      $f12, $f24
000ACD2C 1c00488e lw         $t0, 0x1c($s2)
000ACD30 46a30046 mov.s      $f13, $f20
000ACD34 21209400 addu       $a0, $a0, $s4
000ACD38 86d30046 mov.s      $f14, $f26
000ACD3C 0000848c lw         $a0, ($a0)
000ACD40 c6d30046 mov.s      $f15, $f26
000ACD44 04000534 ori        $a1, $zero, 4
000ACD48 c800848c lw         $a0, 0xc8($a0)
000ACD4C 25300000 move       $a2, $zero
000ACD50 6490020c jal        0xa4190
000ACD54 25380000 move       $a3, $zero
000ACD58 0000448e lw         $a0, ($s2)
000ACD5C 25280000 move       $a1, $zero
000ACD60 21209400 addu       $a0, $a0, $s4
000ACD64 0000848c lw         $a0, ($a0)
000ACD68 b683020c jal        0xa0ed8
000ACD6C c800848c lw         $a0, 0xc8($a0)
000ACD70 0000448e lw         $a0, ($s2)
000ACD74 21489400 addu       $t1, $a0, $s4
000ACD78 0000298d lw         $t1, ($t1)
000ACD7C 1400448e lw         $a0, 0x14($s2)
000ACD80 21383301 addu       $a3, $t1, $s3
000ACD84 02008530 andi       $a1, $a0, 2
000ACD88 7200a014 bnez       $a1, 0xacf54
000ACD8C 0000e48c lw         $a0, ($a3)
000ACD90 a3018010 beqz       $a0, 0xad420
000ACD94 00000000 nop        
000ACD98 cc002991 lbu        $t1, 0xcc($t1)
000ACD9C 25203001 or         $a0, $t1, $s0
000ACDA0 9f018010 beqz       $a0, 0xad420
000ACDA4 00000000 nop        
000ACDA8 2400e490 lbu        $a0, 0x24($a3)
000ACDAC 08004b8e lw         $t3, 8($s2)
000ACDB0 2550a002 move       $t2, $s5
000ACDB4 0800e28c lw         $v0, 8($a3)
000ACDB8 01008054 bnel       $a0, $zero, 0xacdc0
000ACDBC 1800ea8c lw         $t2, 0x18($a3)
000ACDC0 03008050 beql       $a0, $zero, 0xacdd0
000ACDC4 2000488e lw         $t0, 0x20($s2)
000ACDC8 01000010 b          0xacdd0
000ACDCC 1c00e88c lw         $t0, 0x1c($a3)
000ACDD0 25288000 move       $a1, $a0
000ACDD4 81ff043c lui        $a0, 0xff81
000ACDD8 80808424 addiu      $a0, $a0, -0x7f80
000ACDDC 0100a054 bnel       $a1, $zero, 0xacde4
000ACDE0 2000e48c lw         $a0, 0x20($a3)
000ACDE4 01002055 bnel       $t1, $zero, 0xacdec
000ACDE8 25204001 move       $a0, $t2
000ACDEC 0400cb16 bne        $s6, $t3, 0xace00
000ACDF0 00000000 nop        
000ACDF4 02002011 beqz       $t1, 0xace00
000ACDF8 00000000 nop        
000ACDFC 25200001 move       $a0, $t0
000ACE00 0300cb56 bnel       $s6, $t3, 0xace10
000ACE04 0c0054c6 lwc1       $f20, 0xc($s2)
000ACE08 01000010 b          0xace10
000ACE0C 100054c6 lwc1       $f20, 0x10($s2)
000ACE10 01008050 beql       $a0, $zero, 0xace18
000ACE14 25204001 move       $a0, $t2
000ACE18 0a005514 bne        $v0, $s5, 0xace44
000ACE1C 25808000 move       $s0, $a0
000ACE20 ee000434 ori        $a0, $zero, 0xee
000ACE24 3800a4af sw         $a0, 0x38($sp)
000ACE28 f2000534 ori        $a1, $zero, 0xf2
000ACE2C 8402a48f lw         $a0, 0x284($sp)
000ACE30 4000a5af sw         $a1, 0x40($sp)
000ACE34 8002a58f lw         $a1, 0x280($sp)
000ACE38 3c00a4af sw         $a0, 0x3c($sp)
000ACE3C 05000010 b          0xace54
000ACE40 4400a5af sw         $a1, 0x44($sp)
000ACE44 3800a527 addiu      $a1, $sp, 0x38
000ACE48 06d30046 mov.s      $f12, $f26
000ACE4C f583020c jal        0xa0fd4
000ACE50 25204000 move       $a0, $v0
000ACE54 6472020c jal        0x9c990
000ACE58 25200002 move       $a0, $s0
000ACE5C 0000448e lw         $a0, ($s2)
000ACE60 21209400 addu       $a0, $a0, $s4
000ACE64 0000848c lw         $a0, ($a0)
000ACE68 21809300 addu       $s0, $a0, $s3
000ACE6C 0c000492 lbu        $a0, 0xc($s0)
000ACE70 03008010 beqz       $a0, 0xace80
000ACE74 0000108e lw         $s0, ($s0)
000ACE78 04000010 b          0xace8c
000ACE7C 00000000 nop        
000ACE80 5227040c jal        0x109d48
000ACE84 25200002 move       $a0, $s0
000ACE88 25804000 move       $s0, $v0
000ACE8C 3a8a020c jal        0xa28e8
000ACE90 3800a427 addiu      $a0, $sp, 0x38
000ACE94 4400a58f lw         $a1, 0x44($sp)
000ACE98 06a30046 mov.s      $f12, $f20
000ACE9C 00240200 sll        $a0, $v0, 0x10
000ACEA0 46a30046 mov.s      $f13, $f20
000ACEA4 002c0500 sll        $a1, $a1, 0x10
000ACEA8 03240400 sra        $a0, $a0, 0x10
000ACEAC 032c0500 sra        $a1, $a1, 0x10
000ACEB0 4378020c jal        0x9e10c
000ACEB4 25300002 move       $a2, $s0
000ACEB8 0000508e lw         $s0, ($s2)
000ACEBC 21801402 addu       $s0, $s0, $s4
000ACEC0 0000048e lw         $a0, ($s0)
000ACEC4 21209300 addu       $a0, $a0, $s3
000ACEC8 1000858c lw         $a1, 0x10($a0)
000ACECC 1f00a010 beqz       $a1, 0xacf4c
000ACED0 00000000 nop        
000ACED4 1400848c lw         $a0, 0x14($a0)
000ACED8 0e009514 bne        $a0, $s5, 0xacf14
000ACEDC 00000000 nop        
000ACEE0 8e000434 ori        $a0, $zero, 0x8e
000ACEE4 3800a4af sw         $a0, 0x38($sp)
000ACEE8 b2000534 ori        $a1, $zero, 0xb2
000ACEEC 8402a48f lw         $a0, 0x284($sp)
000ACEF0 4000a5af sw         $a1, 0x40($sp)
000ACEF4 8002a58f lw         $a1, 0x280($sp)
000ACEF8 3c00a4af sw         $a0, 0x3c($sp)
000ACEFC 4400a5af sw         $a1, 0x44($sp)
000ACF00 0000048e lw         $a0, ($s0)
000ACF04 21209300 addu       $a0, $a0, $s3
000ACF08 1000868c lw         $a2, 0x10($a0)
000ACF0C 0a000010 b          0xacf38
000ACF10 2c00848c lw         $a0, 0x2c($a0)
000ACF14 3800a527 addiu      $a1, $sp, 0x38
000ACF18 f583020c jal        0xa0fd4
000ACF1C 06d30046 mov.s      $f12, $f26
000ACF20 0000448e lw         $a0, ($s2)
000ACF24 21209400 addu       $a0, $a0, $s4
000ACF28 0000848c lw         $a0, ($a0)
000ACF2C 21209300 addu       $a0, $a0, $s3
000ACF30 1000868c lw         $a2, 0x10($a0)
000ACF34 2c00848c lw         $a0, 0x2c($a0)
000ACF38 25388000 move       $a3, $a0
000ACF3C 2520c000 move       $a0, $a2
000ACF40 3800a527 addiu      $a1, $sp, 0x38
000ACF44 137f020c jal        0x9fc4c
000ACF48 2530e000 move       $a2, $a3
000ACF4C 34010010 b          0xad420
000ACF50 00000000 nop        
000ACF54 32018010 beqz       $a0, 0xad420
000ACF58 00000000 nop        
000ACF5C 7c02b08f lw         $s0, 0x27c($sp)
000ACF60 cc002991 lbu        $t1, 0xcc($t1)
000ACF64 25203001 or         $a0, $t1, $s0
000ACF68 2d018010 beqz       $a0, 0xad420
000ACF6C 00000000 nop        
000ACF70 2400e490 lbu        $a0, 0x24($a3)
000ACF74 08004b8e lw         $t3, 8($s2)
000ACF78 2540a002 move       $t0, $s5
000ACF7C 0800e28c lw         $v0, 8($a3)
000ACF80 01008054 bnel       $a0, $zero, 0xacf88
000ACF84 1800e88c lw         $t0, 0x18($a3)
000ACF88 2550a002 move       $t2, $s5
000ACF8C 01008054 bnel       $a0, $zero, 0xacf94
000ACF90 1c00ea8c lw         $t2, 0x1c($a3)
000ACF94 25288000 move       $a1, $a0
000ACF98 81ff043c lui        $a0, 0xff81
000ACF9C 80808424 addiu      $a0, $a0, -0x7f80
000ACFA0 0100a054 bnel       $a1, $zero, 0xacfa8
000ACFA4 2000e48c lw         $a0, 0x20($a3)
000ACFA8 01002055 bnel       $t1, $zero, 0xacfb0
000ACFAC 25200001 move       $a0, $t0
000ACFB0 0400cb16 bne        $s6, $t3, 0xacfc4
000ACFB4 00000000 nop        
000ACFB8 02002011 beqz       $t1, 0xacfc4
000ACFBC 00000000 nop        
000ACFC0 25204001 move       $a0, $t2
000ACFC4 0300cb16 bne        $s6, $t3, 0xacfd4
000ACFC8 25a88000 move       $s5, $a0
000ACFCC 02000010 b          0xacfd8
000ACFD0 100054c6 lwc1       $f20, 0x10($s2)
000ACFD4 0c0054c6 lwc1       $f20, 0xc($s2)
000ACFD8 ffff0424 addiu      $a0, $zero, -1
000ACFDC 0d004414 bne        $v0, $a0, 0xad014
000ACFE0 00000000 nop        
000ACFE4 ee000434 ori        $a0, $zero, 0xee
000ACFE8 f2000834 ori        $t0, $zero, 0xf2
000ACFEC 4800a4af sw         $a0, 0x48($sp)
000ACFF0 20000434 ori        $a0, $zero, 0x20
000ACFF4 5000a8af sw         $t0, 0x50($sp)
000ACFF8 4c00a4af sw         $a0, 0x4c($sp)
000ACFFC 9000448e lw         $a0, 0x90($s2)
000AD000 2f000534 ori        $a1, $zero, 0x2f
000AD004 5400a5af sw         $a1, 0x54($sp)
000AD008 0f002726 addiu      $a3, $s1, 0xf
000AD00C 0d000010 b          0xad044
000AD010 f200842c sltiu      $a0, $a0, 0xf2
000AD014 25204000 move       $a0, $v0
000AD018 06d30046 mov.s      $f12, $f26
000AD01C f583020c jal        0xa0fd4
000AD020 2528e002 move       $a1, $s7
000AD024 4c00a48f lw         $a0, 0x4c($sp)
000AD028 5000a88f lw         $t0, 0x50($sp)
000AD02C 5400a58f lw         $a1, 0x54($sp)
000AD030 08004b8e lw         $t3, 8($s2)
000AD034 2338a400 subu       $a3, $a1, $a0
000AD038 9000448e lw         $a0, 0x90($s2)
000AD03C 2138f100 addu       $a3, $a3, $s1
000AD040 2b208800 sltu       $a0, $a0, $t0
000AD044 5400a7af sw         $a3, 0x54($sp)
000AD048 04008010 beqz       $a0, 0xad05c
000AD04C 4c00b1af sw         $s1, 0x4c($sp)
000AD050 8802a48f lw         $a0, 0x288($sp)
000AD054 23200401 subu       $a0, $t0, $a0
000AD058 5000a4af sw         $a0, 0x50($sp)
000AD05C 3100cb16 bne        $s6, $t3, 0xad124
000AD060 00000000 nop        
000AD064 0000448e lw         $a0, ($s2)
000AD068 21209400 addu       $a0, $a0, $s4
000AD06C 0000848c lw         $a0, ($a0)
000AD070 cc008590 lbu        $a1, 0xcc($a0)
000AD074 2b00a010 beqz       $a1, 0xad124
000AD078 00000000 nop        
000AD07C 21209300 addu       $a0, $a0, $s3
000AD080 7802b1a7 sh         $s1, 0x278($sp)
000AD084 0400848c lw         $a0, 4($a0)
000AD088 41008010 beqz       $a0, 0xad190
000AD08C 00000000 nop        
000AD090 6172020c jal        0x9c984
000AD094 1800448e lw         $a0, 0x18($s2)
000AD098 0000448e lw         $a0, ($s2)
000AD09C 21209400 addu       $a0, $a0, $s4
000AD0A0 0000858c lw         $a1, ($a0)
000AD0A4 2520e002 move       $a0, $s7
000AD0A8 2128b300 addu       $a1, $a1, $s3
000AD0AC 3a8a020c jal        0xa28e8
000AD0B0 0400b18c lw         $s1, 4($a1)
000AD0B4 25804000 move       $s0, $v0
000AD0B8 468a020c jal        0xa2918
000AD0BC 2520e002 move       $a0, $s7
000AD0C0 00608244 mtc1       $v0, $f12
000AD0C4 3cb01e46 c.lt.s     $f22, $f30
000AD0C8 00000000 nop        
000AD0CC 04000045 bc1f       0xad0e0
000AD0D0 20638046 cvt.s.w    $f12, $f12
000AD0D4 4db30046 trunc.w.s  $f13, $f22
000AD0D8 06000010 b          0xad0f4
000AD0DC 00680444 mfc1       $a0, $f13
000AD0E0 41b31e46 sub.s      $f13, $f22, $f30
000AD0E4 0080043c lui        $a0, 0x8000
000AD0E8 4d6b0046 trunc.w.s  $f13, $f13
000AD0EC 00680544 mfc1       $a1, $f13
000AD0F0 2120a400 addu       $a0, $a1, $a0
000AD0F4 25408000 move       $t0, $a0
000AD0F8 46c30046 mov.s      $f13, $f24
000AD0FC 804f093c lui        $t1, 0x4f80
000AD100 86d30046 mov.s      $f14, $f26
000AD104 25202002 move       $a0, $s1
000AD108 00788944 mtc1       $t1, $f15
000AD10C 01000534 ori        $a1, $zero, 1
000AD110 05000634 ori        $a2, $zero, 5
000AD114 6490020c jal        0xa4190
000AD118 25380002 move       $a3, $s0
000AD11C 1c000010 b          0xad190
000AD120 00000000 nop        
000AD124 1a000012 beqz       $s0, 0xad190
000AD128 7802b1a7 sh         $s1, 0x278($sp)
000AD12C 0000448e lw         $a0, ($s2)
000AD130 7802b1a7 sh         $s1, 0x278($sp)
000AD134 21209400 addu       $a0, $a0, $s4
000AD138 0000848c lw         $a0, ($a0)
000AD13C 21209300 addu       $a0, $a0, $s3
000AD140 0400848c lw         $a0, 4($a0)
000AD144 12008010 beqz       $a0, 0xad190
000AD148 00000000 nop        
000AD14C 25808000 move       $s0, $a0
000AD150 7802b1a7 sh         $s1, 0x278($sp)
000AD154 3a8a020c jal        0xa28e8
000AD158 2520e002 move       $a0, $s7
000AD15C 25884000 move       $s1, $v0
000AD160 468a020c jal        0xa2918
000AD164 2520e002 move       $a0, $s7
000AD168 25200002 move       $a0, $s0
000AD16C 06e30046 mov.s      $f12, $f28
000AD170 01000534 ori        $a1, $zero, 1
000AD174 46e30046 mov.s      $f13, $f28
000AD178 25302002 move       $a2, $s1
000AD17C 86d30046 mov.s      $f14, $f26
000AD180 25384000 move       $a3, $v0
000AD184 c6d30046 mov.s      $f15, $f26
000AD188 6490020c jal        0xa4190
000AD18C ffff0824 addiu      $t0, $zero, -1
000AD190 1400448e lw         $a0, 0x14($s2)
000AD194 08008530 andi       $a1, $a0, 8
000AD198 1600a010 beqz       $a1, 0xad1f4
000AD19C 7802b187 lh         $s1, 0x278($sp)
000AD1A0 10008630 andi       $a2, $a0, 0x10
000AD1A4 7800448e lw         $a0, 0x78($s2)
000AD1A8 5000ab8f lw         $t3, 0x50($sp)
000AD1AC 4c00aa8f lw         $t2, 0x4c($sp)
000AD1B0 0500c010 beqz       $a2, 0xad1c8
000AD1B4 5400a98f lw         $t1, 0x54($sp)
000AD1B8 0800458e lw         $a1, 8($s2)
000AD1BC 0200c516 bne        $s6, $a1, 0xad1c8
000AD1C0 00000000 nop        
000AD1C4 7c00448e lw         $a0, 0x7c($s2)
000AD1C8 25408000 move       $t0, $a0
000AD1CC 4800a48f lw         $a0, 0x48($sp)
000AD1D0 002c0a00 sll        $a1, $t2, 0x10
000AD1D4 00240400 sll        $a0, $a0, 0x10
000AD1D8 00340b00 sll        $a2, $t3, 0x10
000AD1DC 003c0900 sll        $a3, $t1, 0x10
000AD1E0 03240400 sra        $a0, $a0, 0x10
000AD1E4 032c0500 sra        $a1, $a1, 0x10
000AD1E8 03340600 sra        $a2, $a2, 0x10
000AD1EC 177b020c jal        0x9ec5c
000AD1F0 033c0700 sra        $a3, $a3, 0x10
000AD1F4 6472020c jal        0x9c990
000AD1F8 2520a002 move       $a0, $s5
000AD1FC 0000448e lw         $a0, ($s2)
000AD200 21209400 addu       $a0, $a0, $s4
000AD204 0000848c lw         $a0, ($a0)
000AD208 21209300 addu       $a0, $a0, $s3
000AD20C 0c008590 lbu        $a1, 0xc($a0)
000AD210 0d00a010 beqz       $a1, 0xad248
000AD214 0000848c lw         $a0, ($a0)
000AD218 25288000 move       $a1, $a0
000AD21C 5800b027 addiu      $s0, $sp, 0x58
000AD220 25200002 move       $a0, $s0
000AD224 9a05070c jal        0x1c1668
000AD228 ff010634 ori        $a2, $zero, 0x1ff
000AD22C 0000488e lw         $t0, ($s2)
000AD230 ffff1524 addiu      $s5, $zero, -1
000AD234 21401401 addu       $t0, $t0, $s4
000AD238 0000098d lw         $t1, ($t0)
000AD23C 21483301 addu       $t1, $t1, $s3
000AD240 0e000010 b          0xad27c
000AD244 2800248d lw         $a0, 0x28($t1)
000AD248 5227040c jal        0x109d48
000AD24C 00000000 nop        
000AD250 5800b027 addiu      $s0, $sp, 0x58
000AD254 25200002 move       $a0, $s0
000AD258 25284000 move       $a1, $v0
000AD25C 9a05070c jal        0x1c1668
000AD260 ff010634 ori        $a2, $zero, 0x1ff
000AD264 0000488e lw         $t0, ($s2)
000AD268 ffff1524 addiu      $s5, $zero, -1
000AD26C 21401401 addu       $t0, $t0, $s4
000AD270 0000098d lw         $t1, ($t0)
000AD274 21483301 addu       $t1, $t1, $s3
000AD278 2800248d lw         $a0, 0x28($t1)
000AD27C 1a008014 bnez       $a0, 0xad2e8
000AD280 00000000 nop        
000AD284 7802b1a7 sh         $s1, 0x278($sp)
000AD288 9402b5af sw         $s5, 0x294($sp)
000AD28C 4800a48f lw         $a0, 0x48($sp)
000AD290 5400a58f lw         $a1, 0x54($sp)
000AD294 00240400 sll        $a0, $a0, 0x10
000AD298 feffa524 addiu      $a1, $a1, -2
000AD29C 03ac0400 sra        $s5, $a0, 0x10
000AD2A0 00240500 sll        $a0, $a1, 0x10
000AD2A4 038c0400 sra        $s1, $a0, 0x10
000AD2A8 048a020c jal        0xa2810
000AD2AC 2520e002 move       $a0, $s7
000AD2B0 2520a002 move       $a0, $s5
000AD2B4 06a30046 mov.s      $f12, $f20
000AD2B8 25282002 move       $a1, $s1
000AD2BC 46a30046 mov.s      $f13, $f20
000AD2C0 25300002 move       $a2, $s0
000AD2C4 d98a020c jal        0xa2b64
000AD2C8 25384000 move       $a3, $v0
000AD2CC 0000488e lw         $t0, ($s2)
000AD2D0 21401401 addu       $t0, $t0, $s4
000AD2D4 0000098d lw         $t1, ($t0)
000AD2D8 9402b58f lw         $s5, 0x294($sp)
000AD2DC 21483301 addu       $t1, $t1, $s3
000AD2E0 2e000010 b          0xad39c
000AD2E4 7802b187 lh         $s1, 0x278($sp)
000AD2E8 01000534 ori        $a1, $zero, 1
000AD2EC 15008514 bne        $a0, $a1, 0xad344
000AD2F0 00000000 nop        
000AD2F4 048a020c jal        0xa2810
000AD2F8 2520e002 move       $a0, $s7
000AD2FC 4800a48f lw         $a0, 0x48($sp)
000AD300 06a30046 mov.s      $f12, $f20
000AD304 5400a58f lw         $a1, 0x54($sp)
000AD308 46a30046 mov.s      $f13, $f20
000AD30C 21208200 addu       $a0, $a0, $v0
000AD310 43200400 sra        $a0, $a0, 1
000AD314 feffa524 addiu      $a1, $a1, -2
000AD318 00240400 sll        $a0, $a0, 0x10
000AD31C 002c0500 sll        $a1, $a1, 0x10
000AD320 03240400 sra        $a0, $a0, 0x10
000AD324 032c0500 sra        $a1, $a1, 0x10
000AD328 4378020c jal        0x9e10c
000AD32C 25300002 move       $a2, $s0
000AD330 0000488e lw         $t0, ($s2)
000AD334 21401401 addu       $t0, $t0, $s4
000AD338 0000098d lw         $t1, ($t0)
000AD33C 17000010 b          0xad39c
000AD340 21483301 addu       $t1, $t1, $s3
000AD344 02000534 ori        $a1, $zero, 2
000AD348 14008514 bne        $a0, $a1, 0xad39c
000AD34C 00000000 nop        
000AD350 048a020c jal        0xa2810
000AD354 2520e002 move       $a0, $s7
000AD358 4800a48f lw         $a0, 0x48($sp)
000AD35C 06a30046 mov.s      $f12, $f20
000AD360 5400a58f lw         $a1, 0x54($sp)
000AD364 46a30046 mov.s      $f13, $f20
000AD368 21208200 addu       $a0, $a0, $v0
000AD36C feff8424 addiu      $a0, $a0, -2
000AD370 feffa524 addiu      $a1, $a1, -2
000AD374 00240400 sll        $a0, $a0, 0x10
000AD378 002c0500 sll        $a1, $a1, 0x10
000AD37C 03240400 sra        $a0, $a0, 0x10
000AD380 032c0500 sra        $a1, $a1, 0x10
000AD384 c179020c jal        0x9e704
000AD388 25300002 move       $a2, $s0
000AD38C 0000488e lw         $t0, ($s2)
000AD390 21401401 addu       $t0, $t0, $s4
000AD394 0000098d lw         $t1, ($t0)
000AD398 21483301 addu       $t1, $t1, $s3
000AD39C 1000248d lw         $a0, 0x10($t1)
000AD3A0 1f008010 beqz       $a0, 0xad420
000AD3A4 5802b027 addiu      $s0, $sp, 0x258
000AD3A8 1400248d lw         $a0, 0x14($t1)
000AD3AC 0b009514 bne        $a0, $s5, 0xad3dc
000AD3B0 00000000 nop        
000AD3B4 ee000434 ori        $a0, $zero, 0xee
000AD3B8 f2000534 ori        $a1, $zero, 0xf2
000AD3BC 5802a4af sw         $a0, 0x258($sp)
000AD3C0 20000434 ori        $a0, $zero, 0x20
000AD3C4 6002a5af sw         $a1, 0x260($sp)
000AD3C8 2f000534 ori        $a1, $zero, 0x2f
000AD3CC 5c02a4af sw         $a0, 0x25c($sp)
000AD3D0 6402a5af sw         $a1, 0x264($sp)
000AD3D4 0a000010 b          0xad400
000AD3D8 0f002426 addiu      $a0, $s1, 0xf
000AD3DC 06d30046 mov.s      $f12, $f26
000AD3E0 f583020c jal        0xa0fd4
000AD3E4 25280002 move       $a1, $s0
000AD3E8 0000488e lw         $t0, ($s2)
000AD3EC 5c02a48f lw         $a0, 0x25c($sp)
000AD3F0 6402a58f lw         $a1, 0x264($sp)
000AD3F4 21401401 addu       $t0, $t0, $s4
000AD3F8 2320a400 subu       $a0, $a1, $a0
000AD3FC 21209100 addu       $a0, $a0, $s1
000AD400 6402a4af sw         $a0, 0x264($sp)
000AD404 5c02b1af sw         $s1, 0x25c($sp)
000AD408 0000048d lw         $a0, ($t0)
000AD40C 25280002 move       $a1, $s0
000AD410 21209300 addu       $a0, $a0, $s3
000AD414 2c00868c lw         $a2, 0x2c($a0)
000AD418 137f020c jal        0x9fc4c
000AD41C 1000848c lw         $a0, 0x10($a0)
000AD420 0100de27 addiu      $fp, $fp, 1
000AD424 0400c42f sltiu      $a0, $fp, 4
000AD428 d6fd8014 bnez       $a0, 0xacb84
000AD42C 30007326 addiu      $s3, $s3, 0x30
000AD430 4800448e lw         $a0, 0x48($s2)
000AD434 8402a58f lw         $a1, 0x284($sp)
000AD438 21209100 addu       $a0, $a0, $s1
000AD43C 10008424 addiu      $a0, $a0, 0x10
000AD440 008c0400 sll        $s1, $a0, 0x10
000AD444 8002a48f lw         $a0, 0x280($sp)
000AD448 1000a524 addiu      $a1, $a1, 0x10
000AD44C 0100d626 addiu      $s6, $s6, 1
000AD450 10008624 addiu      $a2, $a0, 0x10
000AD454 8402a5af sw         $a1, 0x284($sp)
000AD458 038c1100 sra        $s1, $s1, 0x10
000AD45C 04009426 addiu      $s4, $s4, 4
000AD460 0004c42e sltiu      $a0, $s6, 0x400
000AD464 b6fd0010 b          0xacb40
000AD468 8002a6af sw         $a2, 0x280($sp)
000AD46C 8c02a48f lw         $a0, 0x28c($sp)
000AD470 a2008010 beqz       $a0, 0xad6fc
000AD474 00000000 nop        
000AD478 9400568e lw         $s6, 0x94($s2)
000AD47C 06e30046 mov.s      $f12, $f28
000AD480 8800548e lw         $s4, 0x88($s2)
000AD484 46e30046 mov.s      $f13, $f28
000AD488 8c00538e lw         $s3, 0x8c($s2)
000AD48C 86d30046 mov.s      $f14, $f26
000AD490 9000508e lw         $s0, 0x90($s2)
000AD494 002c1400 sll        $a1, $s4, 0x10
000AD498 00241000 sll        $a0, $s0, 0x10
000AD49C 00341600 sll        $a2, $s6, 0x10
000AD4A0 003c1300 sll        $a3, $s3, 0x10
000AD4A4 4040083c lui        $t0, 0x4040
000AD4A8 03240400 sra        $a0, $a0, 0x10
000AD4AC 032c0500 sra        $a1, $a1, 0x10
000AD4B0 03340600 sra        $a2, $a2, 0x10
000AD4B4 033c0700 sra        $a3, $a3, 0x10
000AD4B8 25480001 move       $t1, $t0
000AD4BC 25500001 move       $t2, $t0
000AD4C0 567b020c jal        0x9ed58
000AD4C4 25580001 move       $t3, $t0
000AD4C8 a000468e lw         $a2, 0xa0($s2)
000AD4CC 23b0c602 subu       $s6, $s6, $a2
000AD4D0 21a08602 addu       $s4, $s4, $a2
000AD4D4 21380602 addu       $a3, $s0, $a2
000AD4D8 00609444 mtc1       $s4, $f12
000AD4DC 7002b6af sw         $s6, 0x270($sp)
000AD4E0 20658046 cvt.s.w    $f20, $f12
000AD4E4 23986602 subu       $s3, $s3, $a2
000AD4E8 6802a7af sw         $a3, 0x268($sp)
000AD4EC 00689344 mtc1       $s3, $f13
000AD4F0 6c02b4af sw         $s4, 0x26c($sp)
000AD4F4 606b8046 cvt.s.w    $f13, $f13
000AD4F8 7402b3af sw         $s3, 0x274($sp)
000AD4FC 0400458e lw         $a1, 4($s2)
000AD500 b0ff153c lui        $s5, 0xffb0
000AD504 00f40700 sll        $fp, $a3, 0x10
000AD508 00608544 mtc1       $a1, $f12
000AD50C 00bc1600 sll        $s7, $s6, 0x10
000AD510 016d1446 sub.s      $f20, $f13, $f20
000AD514 3000a48f lw         $a0, 0x30($sp)
000AD518 20638046 cvt.s.w    $f12, $f12
000AD51C 03f41e00 sra        $fp, $fp, 0x10
000AD520 03bc1700 sra        $s7, $s7, 0x10
000AD524 0400a104 bgez       $a1, 0xad538
000AD528 5070b526 addiu      $s5, $s5, 0x7050
000AD52C 804f083c lui        $t0, 0x4f80
000AD530 00688844 mtc1       $t0, $f13
000AD534 00630d46 add.s      $f12, $f12, $f13
000AD538 03a50c46 div.s      $f20, $f20, $f12
000AD53C 2188c600 addu       $s1, $a2, $a2
000AD540 2138f600 addu       $a3, $a3, $s6
000AD544 43400700 sra        $t0, $a3, 1
000AD548 c2470800 srl        $t0, $t0, 0x1f
000AD54C 21b0e800 addu       $s6, $a3, $t0
000AD550 804f073c lui        $a3, 0x4f80
000AD554 43b01600 sra        $s6, $s6, 1
000AD558 00609144 mtc1       $s1, $f12
000AD55C 20638046 cvt.s.w    $f12, $f12
000AD560 3e601446 c.le.s     $f12, $f20
000AD564 00000000 nop        
000AD568 03000145 bc1t       0xad578
000AD56C 00b08744 mtc1       $a3, $f22
000AD570 0da30046 trunc.w.s  $f12, $f20
000AD574 00601144 mfc1       $s1, $f12
000AD578 0400272a slti       $a3, $s1, 4
000AD57C 0600e010 beqz       $a3, 0xad598
000AD580 00001034 ori        $s0, $zero, 0
000AD584 0200c728 slti       $a3, $a2, 2
000AD588 0300e014 bnez       $a3, 0xad598
000AD58C 00000000 nop        
000AD590 ffffd024 addiu      $s0, $a2, -1
000AD594 21883002 addu       $s1, $s1, $s0
000AD598 14008010 beqz       $a0, 0xad5ec
000AD59C 00000000 nop        
000AD5A0 21209102 addu       $a0, $s4, $s1
000AD5A4 06e30046 mov.s      $f12, $f28
000AD5A8 23209000 subu       $a0, $a0, $s0
000AD5AC 46e30046 mov.s      $f13, $f28
000AD5B0 002c0400 sll        $a1, $a0, 0x10
000AD5B4 86d30046 mov.s      $f14, $f26
000AD5B8 23209002 subu       $a0, $s4, $s0
000AD5BC 032c0500 sra        $a1, $a1, 0x10
000AD5C0 00341600 sll        $a2, $s6, 0x10
000AD5C4 003c0400 sll        $a3, $a0, 0x10
000AD5C8 03340600 sra        $a2, $a2, 0x10
000AD5CC 033c0700 sra        $a3, $a3, 0x10
000AD5D0 2520c003 move       $a0, $fp
000AD5D4 2540e002 move       $t0, $s7
000AD5D8 2548a000 move       $t1, $a1
000AD5DC ee89020c jal        0xa27b8
000AD5E0 2550a002 move       $t2, $s5
000AD5E4 3000a48f lw         $a0, 0x30($sp)
000AD5E8 0400458e lw         $a1, 4($s2)
000AD5EC 2530a000 move       $a2, $a1
000AD5F0 7400458e lw         $a1, 0x74($s2)
000AD5F4 2138a400 addu       $a3, $a1, $a0
000AD5F8 2b30e600 sltu       $a2, $a3, $a2
000AD5FC 1400c010 beqz       $a2, 0xad650
000AD600 00000000 nop        
000AD604 23207102 subu       $a0, $s3, $s1
000AD608 06e30046 mov.s      $f12, $f28
000AD60C 21209000 addu       $a0, $a0, $s0
000AD610 46e30046 mov.s      $f13, $f28
000AD614 002c0400 sll        $a1, $a0, 0x10
000AD618 86d30046 mov.s      $f14, $f26
000AD61C 21207002 addu       $a0, $s3, $s0
000AD620 032c0500 sra        $a1, $a1, 0x10
000AD624 00341600 sll        $a2, $s6, 0x10
000AD628 003c0400 sll        $a3, $a0, 0x10
000AD62C 03340600 sra        $a2, $a2, 0x10
000AD630 033c0700 sra        $a3, $a3, 0x10
000AD634 2520c003 move       $a0, $fp
000AD638 2540e002 move       $t0, $s7
000AD63C 2548a000 move       $t1, $a1
000AD640 ee89020c jal        0xa27b8
000AD644 2550a002 move       $t2, $s5
000AD648 3000a48f lw         $a0, 0x30($sp)
000AD64C 7400458e lw         $a1, 0x74($s2)
000AD650 00608444 mtc1       $a0, $f12
000AD654 20638046 cvt.s.w    $f12, $f12
000AD658 01008204 bltzl      $a0, 0xad660
000AD65C 00631646 add.s      $f12, $f12, $f22
000AD660 02a30c46 mul.s      $f12, $f20, $f12
000AD664 3c601e46 c.lt.s     $f12, $f30
000AD668 00000000 nop        
000AD66C 05000245 bc1fl      0xad684
000AD670 01631e46 sub.s      $f12, $f12, $f30
000AD674 0d630046 trunc.w.s  $f12, $f12
000AD678 00600444 mfc1       $a0, $f12
000AD67C 06000010 b          0xad698
000AD680 21a08402 addu       $s4, $s4, $a0
000AD684 0080043c lui        $a0, 0x8000
000AD688 0d630046 trunc.w.s  $f12, $f12
000AD68C 00600644 mfc1       $a2, $f12
000AD690 2120c400 addu       $a0, $a2, $a0
000AD694 21a08402 addu       $s4, $s4, $a0
000AD698 00608544 mtc1       $a1, $f12
000AD69C 6c02b4af sw         $s4, 0x26c($sp)
000AD6A0 20638046 cvt.s.w    $f12, $f12
000AD6A4 0100a204 bltzl      $a1, 0xad6ac
000AD6A8 00631646 add.s      $f12, $f12, $f22
000AD6AC 42631446 mul.s      $f13, $f12, $f20
000AD6B0 6c02a78f lw         $a3, 0x26c($sp)
000AD6B4 2520c003 move       $a0, $fp
000AD6B8 003c0700 sll        $a3, $a3, 0x10
000AD6BC 8d6b0046 trunc.w.s  $f14, $f13
000AD6C0 2530e002 move       $a2, $s7
000AD6C4 06e30046 mov.s      $f12, $f28
000AD6C8 2540a002 move       $t0, $s5
000AD6CC 2548a002 move       $t1, $s5
000AD6D0 2558a002 move       $t3, $s5
000AD6D4 00700544 mfc1       $a1, $f14
000AD6D8 21288502 addu       $a1, $s4, $a1
000AD6DC 46e30046 mov.s      $f13, $f28
000AD6E0 7402a5af sw         $a1, 0x274($sp)
000AD6E4 86d30046 mov.s      $f14, $f26
000AD6E8 00540500 sll        $t2, $a1, 0x10
000AD6EC 032c0700 sra        $a1, $a3, 0x10
000AD6F0 033c0a00 sra        $a3, $t2, 0x10
000AD6F4 567b020c jal        0x9ed58
000AD6F8 2550a002 move       $t2, $s5
000AD6FC f572020c jal        0x9cbd4
000AD700 00000000 nop        
000AD704 6c72020c jal        0x9c9b0
000AD708 9002a493 lbu        $a0, 0x290($sp)
000AD70C 9802b4c7 lwc1       $f20, 0x298($sp)
000AD710 9c02b6c7 lwc1       $f22, 0x29c($sp)
000AD714 a002b8c7 lwc1       $f24, 0x2a0($sp)
000AD718 a402bac7 lwc1       $f26, 0x2a4($sp)
000AD71C a802bcc7 lwc1       $f28, 0x2a8($sp)
000AD720 ac02bec7 lwc1       $f30, 0x2ac($sp)
000AD724 b002b08f lw         $s0, 0x2b0($sp)
000AD728 b402b18f lw         $s1, 0x2b4($sp)
000AD72C b802b28f lw         $s2, 0x2b8($sp)
000AD730 bc02b38f lw         $s3, 0x2bc($sp)
000AD734 c002b48f lw         $s4, 0x2c0($sp)
000AD738 c402b58f lw         $s5, 0x2c4($sp)
000AD73C c802b68f lw         $s6, 0x2c8($sp)
000AD740 cc02b78f lw         $s7, 0x2cc($sp)
000AD744 d002be8f lw         $fp, 0x2d0($sp)
000AD748 d402bf8f lw         $ra, 0x2d4($sp)
000AD74C 0800e003 jr         $ra
000AD750 e002bd27 addiu      $sp, $sp, 0x2e0