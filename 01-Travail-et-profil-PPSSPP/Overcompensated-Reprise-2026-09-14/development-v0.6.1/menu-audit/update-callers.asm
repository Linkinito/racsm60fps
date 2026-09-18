000B08D8 00000000 nop        
000B08DC 10000012 beqz       $s0, 0xb0920
000B08E0 00000000 nop        
000B08E4 d000048e lw         $a0, 0xd0($s0)
000B08E8 0d008010 beqz       $a0, 0xb0920
000B08EC 00000000 nop        
000B08F0 b3c1020c jal        0xb06cc
000B08F4 00000000 nop        
000B08F8 d800108e lw         $s0, 0xd8($s0)
000B08FC 08000012 beqz       $s0, 0xb0920
000B0900 00000000 nop        
000B0904 0600043c lui        $a0, 6
000B0908 b8b18424 addiu      $a0, $a0, -0x4e48
000B090C 04000010 b          0xb0920
000B0910 c80590ac sw         $s0, 0x5c8($a0)
000B0914 25204002 move       $a0, $s2
000B0918 c6ae020c jal        0xabb18
000B091C 25282002 move       $a1, $s1
000B0920 bebb020c jal        0xaeef8
000B0924 00000000 nop        
000B0928 2000b08f lw         $s0, 0x20($sp)
000B092C 2400b18f lw         $s1, 0x24($sp)
000B0930 2800b28f lw         $s2, 0x28($sp)
000B0934 2c00bf8f lw         $ra, 0x2c($sp)
000B0938 0800e003 jr         $ra
000B093C 3000bd27 addiu      $sp, $sp, 0x30
000B0940 b0ffbd27 addiu      $sp, $sp, -0x50
000B0944 2d00043c lui        $a0, 0x2d
000B0948 e0f880ac sw         $zero, -0x720($a0)
000B094C 3000b4e7 swc1       $f20, 0x30($sp)
000B0950 00a08044 mtc1       $zero, $f20
000B0954 2d00043c lui        $a0, 0x2d
000B0958 3400b6e7 swc1       $f22, 0x34($sp)
000B095C 3800b0af sw         $s0, 0x38($sp)
000B0960 3c00b1af sw         $s1, 0x3c($sp)
000B0964 4000b2af sw         $s2, 0x40($sp)

000B1BF4 fbff4426 addiu      $a0, $s2, -5
000B1BF8 8287000c jal        0x21e08
000B1BFC 1c00a4ac sw         $a0, 0x1c($a1)
000B1C00 02000010 b          0xb1c0c
000B1C04 00000000 nop        
000B1C08 00001534 ori        $s5, $zero, 0
000B1C0C 0600a012 beqz       $s5, 0xb1c28
000B1C10 00000000 nop        
000B1C14 5c0ec496 lhu        $a0, 0xe5c($s6)
000B1C18 08008428 slti       $a0, $a0, 8
000B1C1C 02008014 bnez       $a0, 0xb1c28
000B1C20 00000000 nop        
000B1C24 01001334 ori        $s3, $zero, 1
000B1C28 04000010 b          0xb1c3c
000B1C2C 00000000 nop        
000B1C30 25208002 move       $a0, $s4
000B1C34 c6ae020c jal        0xabb18
000B1C38 2528a002 move       $a1, $s5
000B1C3C 2d00043c lui        $a0, 0x2d
000B1C40 b59a020c jal        0xa6ad4
000B1C44 bcf78424 addiu      $a0, $a0, -0x844
000B1C48 1ec6020c jal        0xb1878
000B1C4C 1c0082ae sw         $v0, 0x1c($s4)
000B1C50 9c87000c jal        0x21e70
000B1C54 00000000 nop        
000B1C58 0c006012 beqz       $s3, 0xb1c8c
000B1C5C 00000000 nop        
000B1C60 001d108e lw         $s0, 0x1d00($s0)
000B1C64 1800048e lw         $a0, 0x18($s0)
000B1C68 04002416 bne        $s1, $a0, 0xb1c7c
000B1C6C 00000000 nop        
000B1C70 1c00048e lw         $a0, 0x1c($s0)
000B1C74 05004412 beq        $s2, $a0, 0xb1c8c
000B1C78 00000000 nop        
000B1C7C 24a4020c jal        0xa9090
000B1C80 0b000434 ori        $a0, $zero, 0xb

000B23AC 3c00c78c lw         $a3, 0x3c($a2)
000B23B0 23208700 subu       $a0, $a0, $a3
000B23B4 06000010 b          0xb23d0
000B23B8 3c00c4ac sw         $a0, 0x3c($a2)
000B23BC 0800c48c lw         $a0, 8($a2)
000B23C0 01008438 xori       $a0, $a0, 1
000B23C4 02000010 b          0xb23d0
000B23C8 0800c4ac sw         $a0, 8($a2)
000B23CC 00000534 ori        $a1, $zero, 0
000B23D0 0300a010 beqz       $a1, 0xb23e0
000B23D4 00000000 nop        
000B23D8 24a4020c jal        0xa9090
000B23DC 0b000434 ori        $a0, $zero, 0xb
000B23E0 04000010 b          0xb23f4
000B23E4 00000000 nop        
000B23E8 25288000 move       $a1, $a0
000B23EC c6ae020c jal        0xabb18
000B23F0 25200002 move       $a0, $s0
000B23F4 2d00043c lui        $a0, 0x2d
000B23F8 b59a020c jal        0xa6ad4
000B23FC bcf78424 addiu      $a0, $a0, -0x844
000B2400 b0c7020c jal        0xb1ec0
000B2404 1c0002ae sw         $v0, 0x1c($s0)
000B2408 9c87000c jal        0x21e70
000B240C 00000000 nop        
000B2410 1287000c jal        0x21c48
000B2414 00000000 nop        
000B2418 c287000c jal        0x21f08
000B241C 00000000 nop        
000B2420 2000b08f lw         $s0, 0x20($sp)
000B2424 2400b18f lw         $s1, 0x24($sp)
000B2428 2800b28f lw         $s2, 0x28($sp)
000B242C 2c00bf8f lw         $ra, 0x2c($sp)
000B2430 0800e003 jr         $ra
000B2434 3000bd27 addiu      $sp, $sp, 0x30
000B2438 0800e003 jr         $ra

000B26CC 2d00053c lui        $a1, 0x2d
000B26D0 7015a4a0 sb         $a0, 0x1570($a1)
000B26D4 23c9020c jal        0xb248c
000B26D8 c3010434 ori        $a0, $zero, 0x1c3
000B26DC 08000010 b          0xb2700
000B26E0 00000000 nop        
000B26E4 65000534 ori        $a1, $zero, 0x65
000B26E8 05008514 bne        $a0, $a1, 0xb2700
000B26EC 00000000 nop        
000B26F0 2d00043c lui        $a0, 0x2d
000B26F4 701580a0 sb         $zero, 0x1570($a0)
000B26F8 23c9020c jal        0xb248c
000B26FC c4010434 ori        $a0, $zero, 0x1c4
000B2700 04000010 b          0xb2714
000B2704 00000000 nop        
000B2708 25200002 move       $a0, $s0
000B270C c6ae020c jal        0xabb18
000B2710 25282002 move       $a1, $s1
000B2714 2d00043c lui        $a0, 0x2d
000B2718 b59a020c jal        0xa6ad4
000B271C bcf78424 addiu      $a0, $a0, -0x844
000B2720 1c0002ae sw         $v0, 0x1c($s0)
000B2724 1000b08f lw         $s0, 0x10($sp)
000B2728 1400b18f lw         $s1, 0x14($sp)
000B272C 1800bf8f lw         $ra, 0x18($sp)
000B2730 0800e003 jr         $ra
000B2734 2000bd27 addiu      $sp, $sp, 0x20
000B2738 00290500 sll        $a1, $a1, 4
000B273C 80200400 sll        $a0, $a0, 2
000B2740 2120a400 addu       $a0, $a1, $a0
000B2744 2d00053c lui        $a1, 0x2d
000B2748 f017a524 addiu      $a1, $a1, 0x17f0
000B274C 21208500 addu       $a0, $a0, $a1
000B2750 0800e003 jr         $ra
000B2754 0000828c lw         $v0, ($a0)
000B2758 00290500 sll        $a1, $a1, 4

000B4230 758a000c jal        0x229d4
000B4234 00000000 nop        
000B4238 07004014 bnez       $v0, 0xb4258
000B423C 00000000 nop        
000B4240 2c00043c lui        $a0, 0x2c
000B4244 881d848c lw         $a0, 0x1d88($a0)
000B4248 3452000c jal        0x148d0
000B424C 01000534 ori        $a1, $zero, 1
000B4250 09000010 b          0xb4278
000B4254 00000000 nop        
000B4258 04000434 ori        $a0, $zero, 4
000B425C ff51000c jal        0x147fc
000B4260 25280000 move       $a1, $zero
000B4264 04000010 b          0xb4278
000B4268 00000000 nop        
000B426C 25288000 move       $a1, $a0
000B4270 c6ae020c jal        0xabb18
000B4274 25202002 move       $a0, $s1
000B4278 2d00043c lui        $a0, 0x2d
000B427C 8d9a020c jal        0xa6a34
000B4280 bcf78424 addiu      $a0, $a0, -0x844
000B4284 1b000012 beqz       $s0, 0xb42f4
000B4288 00000000 nop        
000B428C d000048e lw         $a0, 0xd0($s0)
000B4290 18008010 beqz       $a0, 0xb42f4
000B4294 00000000 nop        
000B4298 ffff8724 addiu      $a3, $a0, -1
000B429C 2d00043c lui        $a0, 0x2d
000B42A0 681a87ac sw         $a3, 0x1a68($a0)
000B42A4 2d00063c lui        $a2, 0x2d
000B42A8 4c1ac88c lw         $t0, 0x1a4c($a2)
000B42AC 2d00053c lui        $a1, 0x2d
000B42B0 09000711 beq        $t0, $a3, 0xb42d8
000B42B4 501aa48c lw         $a0, 0x1a50($a1)
000B42B8 01000834 ori        $t0, $zero, 1
000B42BC 03008814 bne        $a0, $t0, 0xb42cc

000B56FC 08002016 bnez       $s1, 0xb5720
000B5700 00000000 nop        
000B5704 24a4020c jal        0xa9090
000B5708 07000434 ori        $a0, $zero, 7
000B570C 04000434 ori        $a0, $zero, 4
000B5710 ff51000c jal        0x147fc
000B5714 25280000 move       $a1, $zero
000B5718 05000010 b          0xb5730
000B571C 00000000 nop        
000B5720 24a4020c jal        0xa9090
000B5724 06000434 ori        $a0, $zero, 6
000B5728 32ba020c jal        0xae8c8
000B572C 25202002 move       $a0, $s1
000B5730 04000010 b          0xb5744
000B5734 00000000 nop        
000B5738 25288000 move       $a1, $a0
000B573C c6ae020c jal        0xabb18
000B5740 25200002 move       $a0, $s0
000B5744 2d00043c lui        $a0, 0x2d
000B5748 b59a020c jal        0xa6ad4
000B574C bcf78424 addiu      $a0, $a0, -0x844
000B5750 1c0002ae sw         $v0, 0x1c($s0)
000B5754 1000b08f lw         $s0, 0x10($sp)
000B5758 1400b18f lw         $s1, 0x14($sp)
000B575C 1800bf8f lw         $ra, 0x18($sp)
000B5760 0800e003 jr         $ra
000B5764 2000bd27 addiu      $sp, $sp, 0x20
000B5768 e0ffbd27 addiu      $sp, $sp, -0x20
000B576C 1000b0af sw         $s0, 0x10($sp)
000B5770 1400bfaf sw         $ra, 0x14($sp)
000B5774 12e1010c jal        0x78448
000B5778 106b0434 ori        $a0, $zero, 0x6b10
000B577C 25204000 move       $a0, $v0
000B5780 0400103c lui        $s0, 4
000B5784 08008530 andi       $a1, $a0, 8
000B5788 0a00a010 beqz       $a1, 0xb57b4

000B57B8 0e00a010 beqz       $a1, 0xb57f4
000B57BC 00000000 nop        
000B57C0 24a4020c jal        0xa9090
000B57C4 07000434 ori        $a0, $zero, 7
000B57C8 24a4020c jal        0xa9090
000B57CC 25200000 move       $a0, $zero
000B57D0 51ba020c jal        0xae944
000B57D4 00000000 nop        
000B57D8 09004014 bnez       $v0, 0xb5800
000B57DC 00000000 nop        
000B57E0 04000434 ori        $a0, $zero, 4
000B57E4 ff51000c jal        0x147fc
000B57E8 25280000 move       $a1, $zero
000B57EC 04000010 b          0xb5800
000B57F0 00000000 nop        
000B57F4 25288000 move       $a1, $a0
000B57F8 c6ae020c jal        0xabb18
000B57FC 25200002 move       $a0, $s0
000B5800 fcb1020c jal        0xac7f0
000B5804 25200002 move       $a0, $s0
000B5808 25804000 move       $s0, $v0
000B580C 07000012 beqz       $s0, 0xb582c
000B5810 00000000 nop        
000B5814 d400108e lw         $s0, 0xd4($s0)
000B5818 04000012 beqz       $s0, 0xb582c
000B581C 00000000 nop        
000B5820 25200000 move       $a0, $zero
000B5824 c530040c jal        0x10c314
000B5828 25280002 move       $a1, $s0
000B582C 1000b08f lw         $s0, 0x10($sp)
000B5830 1400bf8f lw         $ra, 0x14($sp)
000B5834 0800e003 jr         $ra
000B5838 2000bd27 addiu      $sp, $sp, 0x20
000B583C c0ffbd27 addiu      $sp, $sp, -0x40
000B5840 2000b4e7 swc1       $f20, 0x20($sp)
000B5844 00a08044 mtc1       $zero, $f20

000B5CB0 0e00a010 beqz       $a1, 0xb5cec
000B5CB4 00000000 nop        
000B5CB8 24a4020c jal        0xa9090
000B5CBC 07000434 ori        $a0, $zero, 7
000B5CC0 24a4020c jal        0xa9090
000B5CC4 25200000 move       $a0, $zero
000B5CC8 51ba020c jal        0xae944
000B5CCC 00000000 nop        
000B5CD0 09004014 bnez       $v0, 0xb5cf8
000B5CD4 00000000 nop        
000B5CD8 04000434 ori        $a0, $zero, 4
000B5CDC ff51000c jal        0x147fc
000B5CE0 25280000 move       $a1, $zero
000B5CE4 04000010 b          0xb5cf8
000B5CE8 00000000 nop        
000B5CEC 25288000 move       $a1, $a0
000B5CF0 c6ae020c jal        0xabb18
000B5CF4 25200002 move       $a0, $s0
000B5CF8 1000b08f lw         $s0, 0x10($sp)
000B5CFC 1400bf8f lw         $ra, 0x14($sp)
000B5D00 0800e003 jr         $ra
000B5D04 2000bd27 addiu      $sp, $sp, 0x20
000B5D08 c0ffbd27 addiu      $sp, $sp, -0x40
000B5D0C 2000b4e7 swc1       $f20, 0x20($sp)
000B5D10 00a08044 mtc1       $zero, $f20
000B5D14 30000434 ori        $a0, $zero, 0x30
000B5D18 ffff0524 addiu      $a1, $zero, -1
000B5D1C 2400b0af sw         $s0, 0x24($sp)
000B5D20 2800b1af sw         $s1, 0x28($sp)
000B5D24 2c00b2af sw         $s2, 0x2c($sp)
000B5D28 3000b3af sw         $s3, 0x30($sp)
000B5D2C 3400b4af sw         $s4, 0x34($sp)
000B5D30 3800bfaf sw         $ra, 0x38($sp)
000B5D34 4485020c jal        0xa1510
000B5D38 06a30046 mov.s      $f12, $f20
000B5D3C 1000b027 addiu      $s0, $sp, 0x10

000B6530 08002016 bnez       $s1, 0xb6554
000B6534 00000000 nop        
000B6538 24a4020c jal        0xa9090
000B653C 07000434 ori        $a0, $zero, 7
000B6540 04000434 ori        $a0, $zero, 4
000B6544 ff51000c jal        0x147fc
000B6548 25280000 move       $a1, $zero
000B654C 05000010 b          0xb6564
000B6550 00000000 nop        
000B6554 24a4020c jal        0xa9090
000B6558 06000434 ori        $a0, $zero, 6
000B655C 32ba020c jal        0xae8c8
000B6560 25202002 move       $a0, $s1
000B6564 04000010 b          0xb6578
000B6568 00000000 nop        
000B656C 25288000 move       $a1, $a0
000B6570 c6ae020c jal        0xabb18
000B6574 25200002 move       $a0, $s0
000B6578 2d00043c lui        $a0, 0x2d
000B657C b59a020c jal        0xa6ad4
000B6580 bcf78424 addiu      $a0, $a0, -0x844
000B6584 1c0002ae sw         $v0, 0x1c($s0)
000B6588 1000b08f lw         $s0, 0x10($sp)
000B658C 1400b18f lw         $s1, 0x14($sp)
000B6590 1800bf8f lw         $ra, 0x18($sp)
000B6594 0800e003 jr         $ra
000B6598 2000bd27 addiu      $sp, $sp, 0x20
000B659C e0ffbd27 addiu      $sp, $sp, -0x20
000B65A0 1000b0af sw         $s0, 0x10($sp)
000B65A4 1400bfaf sw         $ra, 0x14($sp)
000B65A8 12e1010c jal        0x78448
000B65AC 106b0434 ori        $a0, $zero, 0x6b10
000B65B0 25204000 move       $a0, $v0
000B65B4 0400103c lui        $s0, 4
000B65B8 08008530 andi       $a1, $a0, 8
000B65BC 0800a010 beqz       $a1, 0xb65e0

000B664C 11000010 b          0xb6694
000B6650 ac3585ac sw         $a1, 0x35ac($a0)
000B6654 00028530 andi       $a1, $a0, 0x200
000B6658 0b00a010 beqz       $a1, 0xb6688
000B665C 00000000 nop        
000B6660 2d00043c lui        $a0, 0x2d
000B6664 ac35858c lw         $a1, 0x35ac($a0)
000B6668 0100a524 addiu      $a1, $a1, 1
000B666C ac3585ac sw         $a1, 0x35ac($a0)
000B6670 0200a52c sltiu      $a1, $a1, 2
000B6674 0700a014 bnez       $a1, 0xb6694
000B6678 00000000 nop        
000B667C 01000534 ori        $a1, $zero, 1
000B6680 04000010 b          0xb6694
000B6684 ac3585ac sw         $a1, 0x35ac($a0)
000B6688 25288000 move       $a1, $a0
000B668C c6ae020c jal        0xabb18
000B6690 25200002 move       $a0, $s0
000B6694 fcb1020c jal        0xac7f0
000B6698 25200002 move       $a0, $s0
000B669C 25804000 move       $s0, $v0
000B66A0 16000012 beqz       $s0, 0xb66fc
000B66A4 00000000 nop        
000B66A8 d400048e lw         $a0, 0xd4($s0)
000B66AC 1800053c lui        $a1, 0x18
000B66B0 80200400 sll        $a0, $a0, 2
000B66B4 c83ba524 addiu      $a1, $a1, 0x3bc8
000B66B8 21208500 addu       $a0, $a0, $a1
000B66BC 0000908c lw         $s0, ($a0)
000B66C0 3400048e lw         $a0, 0x34($s0)
000B66C4 0d008010 beqz       $a0, 0xb66fc
000B66C8 00000000 nop        
000B66CC 3000048e lw         $a0, 0x30($s0)
000B66D0 2d00053c lui        $a1, 0x2d
000B66D4 ffff8424 addiu      $a0, $a0, -1
000B66D8 80200400 sll        $a0, $a0, 2

000B8900 25200002 move       $a0, $s0
000B8904 24a4020c jal        0xa9090
000B8908 01000434 ori        $a0, $zero, 1
000B890C 0e000010 b          0xb8948
000B8910 00000000 nop        
000B8914 2d00103c lui        $s0, 0x2d
000B8918 7f360492 lbu        $a0, 0x367f($s0)
000B891C 07008010 beqz       $a0, 0xb893c
000B8920 00000000 nop        
000B8924 5036a48e lw         $a0, 0x3650($s5)
000B8928 04008014 bnez       $a0, 0xb893c
000B892C 00000000 nop        
000B8930 a48f000c jal        0x23e90
000B8934 00000000 nop        
000B8938 7f3600a2 sb         $zero, 0x367f($s0)
000B893C 2800a48f lw         $a0, 0x28($sp)
000B8940 c6ae020c jal        0xabb18
000B8944 2528c002 move       $a1, $s6
000B8948 2d00043c lui        $a0, 0x2d
000B894C 2800b08f lw         $s0, 0x28($sp)
000B8950 b59a020c jal        0xa6ad4
000B8954 bcf78424 addiu      $a0, $a0, -0x844
000B8958 1c0002ae sw         $v0, 0x1c($s0)
000B895C 3000b08f lw         $s0, 0x30($sp)
000B8960 3400b18f lw         $s1, 0x34($sp)
000B8964 3800b28f lw         $s2, 0x38($sp)
000B8968 3c00b38f lw         $s3, 0x3c($sp)
000B896C 4000b48f lw         $s4, 0x40($sp)
000B8970 4400b58f lw         $s5, 0x44($sp)
000B8974 4800b68f lw         $s6, 0x48($sp)
000B8978 4c00b78f lw         $s7, 0x4c($sp)
000B897C 5000be8f lw         $fp, 0x50($sp)
000B8980 5400bf8f lw         $ra, 0x54($sp)
000B8984 0800e003 jr         $ra
000B8988 6000bd27 addiu      $sp, $sp, 0x60
000B898C d0ffbd27 addiu      $sp, $sp, -0x30

000BB094 08002016 bnez       $s1, 0xbb0b8
000BB098 00000000 nop        
000BB09C 24a4020c jal        0xa9090
000BB0A0 07000434 ori        $a0, $zero, 7
000BB0A4 04000434 ori        $a0, $zero, 4
000BB0A8 ff51000c jal        0x147fc
000BB0AC 25280000 move       $a1, $zero
000BB0B0 05000010 b          0xbb0c8
000BB0B4 00000000 nop        
000BB0B8 24a4020c jal        0xa9090
000BB0BC 06000434 ori        $a0, $zero, 6
000BB0C0 32ba020c jal        0xae8c8
000BB0C4 25202002 move       $a0, $s1
000BB0C8 04000010 b          0xbb0dc
000BB0CC 00000000 nop        
000BB0D0 25288000 move       $a1, $a0
000BB0D4 c6ae020c jal        0xabb18
000BB0D8 25200002 move       $a0, $s0
000BB0DC 2d00043c lui        $a0, 0x2d
000BB0E0 b59a020c jal        0xa6ad4
000BB0E4 bcf78424 addiu      $a0, $a0, -0x844
000BB0E8 1c0002ae sw         $v0, 0x1c($s0)
000BB0EC 1000b08f lw         $s0, 0x10($sp)
000BB0F0 1400b18f lw         $s1, 0x14($sp)
000BB0F4 1800bf8f lw         $ra, 0x18($sp)
000BB0F8 0800e003 jr         $ra
000BB0FC 2000bd27 addiu      $sp, $sp, 0x20
000BB100 d0ffbd27 addiu      $sp, $sp, -0x30
000BB104 1400b1af sw         $s1, 0x14($sp)
000BB108 0400113c lui        $s1, 4
000BB10C 006a3126 addiu      $s1, $s1, 0x6a00
000BB110 1000b0af sw         $s0, 0x10($sp)
000BB114 1800b2af sw         $s2, 0x18($sp)
000BB118 1c00b3af sw         $s3, 0x1c($sp)
000BB11C 2000b4af sw         $s4, 0x20($sp)
000BB120 2400bfaf sw         $ra, 0x24($sp)

000BB280 00000000 nop        
000BB284 24a4020c jal        0xa9090
000BB288 0c000434 ori        $a0, $zero, 0xc
000BB28C 0e000010 b          0xbb2c8
000BB290 00000000 nop        
000BB294 24a4020c jal        0xa9090
000BB298 0b000434 ori        $a0, $zero, 0xb
000BB29C 4690000c jal        0x24118
000BB2A0 0c00448e lw         $a0, 0xc($s2)
000BB2A4 08000010 b          0xbb2c8
000BB2A8 00000000 nop        
000BB2AC 24a4020c jal        0xa9090
000BB2B0 0c000434 ori        $a0, $zero, 0xc
000BB2B4 04000010 b          0xbb2c8
000BB2B8 00000000 nop        
000BB2BC 25202002 move       $a0, $s1
000BB2C0 c6ae020c jal        0xabb18
000BB2C4 25280002 move       $a1, $s0
000BB2C8 e7ed020c jal        0xbb79c
000BB2CC 00000000 nop        
000BB2D0 1000b08f lw         $s0, 0x10($sp)
000BB2D4 1400b18f lw         $s1, 0x14($sp)
000BB2D8 1800b28f lw         $s2, 0x18($sp)
000BB2DC 1c00b38f lw         $s3, 0x1c($sp)
000BB2E0 2000b48f lw         $s4, 0x20($sp)
000BB2E4 2400bf8f lw         $ra, 0x24($sp)
000BB2E8 0800e003 jr         $ra
000BB2EC 3000bd27 addiu      $sp, $sp, 0x30
000BB2F0 c0ffbd27 addiu      $sp, $sp, -0x40
000BB2F4 2000b4e7 swc1       $f20, 0x20($sp)
000BB2F8 00a08044 mtc1       $zero, $f20
000BB2FC 29000434 ori        $a0, $zero, 0x29
000BB300 ffff0524 addiu      $a1, $zero, -1
000BB304 2400b0af sw         $s0, 0x24($sp)
000BB308 2800b1af sw         $s1, 0x28($sp)
000BB30C 2c00b2af sw         $s2, 0x2c($sp)

000BBB24 fcb1020c jal        0xac7f0
000BBB28 25202002 move       $a0, $s1
000BBB2C 0400053c lui        $a1, 4
000BBB30 15010434 ori        $a0, $zero, 0x115
000BBB34 5227040c jal        0x109d48
000BBB38 9c6bb024 addiu      $s0, $a1, 0x6b9c
000BBB3C 0000448e lw         $a0, ($s2)
000BBB40 5227040c jal        0x109d48
000BBB44 25884000 move       $s1, $v0
000BBB48 25200002 move       $a0, $s0
000BBB4C 25282002 move       $a1, $s1
000BBB50 1100070c jal        0x1c0044
000BBB54 25304000 move       $a2, $v0
000BBB58 04000010 b          0xbbb6c
000BBB5C 00000000 nop        
000BBB60 25202002 move       $a0, $s1
000BBB64 c6ae020c jal        0xabb18
000BBB68 25284002 move       $a1, $s2
000BBB6C 30000010 b          0xbbc30
000BBB70 00000000 nop        
000BBB74 01001134 ori        $s1, $zero, 1
000BBB78 2d009114 bne        $a0, $s1, 0xbbc30
000BBB7C 00000000 nop        
000BBB80 0400053c lui        $a1, 4
000BBB84 24020434 ori        $a0, $zero, 0x224
000BBB88 5227040c jal        0x109d48
000BBB8C 9c6bb224 addiu      $s2, $a1, 0x6b9c
000BBB90 25984000 move       $s3, $v0
000BBB94 5227040c jal        0x109d48
000BBB98 37010434 ori        $a0, $zero, 0x137
000BBB9C 03000434 ori        $a0, $zero, 3
000BBBA0 25284002 move       $a1, $s2
000BBBA4 25306002 move       $a2, $s3
000BBBA8 b316030c jal        0xc5acc
000BBBAC 25384000 move       $a3, $v0
000BBBB0 6c15030c jal        0xc55b0

000BD11C 0e00a010 beqz       $a1, 0xbd158
000BD120 00000000 nop        
000BD124 24a4020c jal        0xa9090
000BD128 07000434 ori        $a0, $zero, 7
000BD12C 24a4020c jal        0xa9090
000BD130 25200000 move       $a0, $zero
000BD134 51ba020c jal        0xae944
000BD138 00000000 nop        
000BD13C 09004014 bnez       $v0, 0xbd164
000BD140 00000000 nop        
000BD144 04000434 ori        $a0, $zero, 4
000BD148 ff51000c jal        0x147fc
000BD14C 25280000 move       $a1, $zero
000BD150 04000010 b          0xbd164
000BD154 00000000 nop        
000BD158 25288000 move       $a1, $a0
000BD15C c6ae020c jal        0xabb18
000BD160 25200002 move       $a0, $s0
000BD164 fcb1020c jal        0xac7f0
000BD168 25200002 move       $a0, $s0
000BD16C 25804000 move       $s0, $v0
000BD170 07000012 beqz       $s0, 0xbd190
000BD174 00000000 nop        
000BD178 dc00108e lw         $s0, 0xdc($s0)
000BD17C 04000012 beqz       $s0, 0xbd190
000BD180 00000000 nop        
000BD184 25200000 move       $a0, $zero
000BD188 c530040c jal        0x10c314
000BD18C 25280002 move       $a1, $s0
000BD190 1000b08f lw         $s0, 0x10($sp)
000BD194 1400bf8f lw         $ra, 0x14($sp)
000BD198 0800e003 jr         $ra
000BD19C 2000bd27 addiu      $sp, $sp, 0x20
000BD1A0 b0ffbd27 addiu      $sp, $sp, -0x50
000BD1A4 2800b4e7 swc1       $f20, 0x28($sp)
000BD1A8 00a08044 mtc1       $zero, $f20

000BD98C 0c00073c lui        $a3, 0xc
000BD990 0800058e lw         $a1, 8($s0)
000BD994 25300000 move       $a2, $zero
000BD998 25400000 move       $t0, $zero
000BD99C 25480000 move       $t1, $zero
000BD9A0 ffff0a24 addiu      $t2, $zero, -1
000BD9A4 25580000 move       $t3, $zero
000BD9A8 fd82000c jal        0x20bf4
000BD9AC 20dee724 addiu      $a3, $a3, -0x21e0
000BD9B0 08000010 b          0xbd9d4
000BD9B4 00000000 nop        
000BD9B8 24a4020c jal        0xa9090
000BD9BC 0c000434 ori        $a0, $zero, 0xc
000BD9C0 04000010 b          0xbd9d4
000BD9C4 00000000 nop        
000BD9C8 25204002 move       $a0, $s2
000BD9CC c6ae020c jal        0xabb18
000BD9D0 25286002 move       $a1, $s3
000BD9D4 09002012 beqz       $s1, 0xbd9fc
000BD9D8 00000000 nop        
000BD9DC 07000012 beqz       $s0, 0xbd9fc
000BD9E0 00000000 nop        
000BD9E4 0c00108e lw         $s0, 0xc($s0)
000BD9E8 04000012 beqz       $s0, 0xbd9fc
000BD9EC 00000000 nop        
000BD9F0 25200000 move       $a0, $zero
000BD9F4 c530040c jal        0x10c314
000BD9F8 25280002 move       $a1, $s0
000BD9FC 2000b08f lw         $s0, 0x20($sp)
000BDA00 2400b18f lw         $s1, 0x24($sp)
000BDA04 2800b28f lw         $s2, 0x28($sp)
000BDA08 2c00b38f lw         $s3, 0x2c($sp)
000BDA0C 3000bf8f lw         $ra, 0x30($sp)
000BDA10 0800e003 jr         $ra
000BDA14 4000bd27 addiu      $sp, $sp, 0x40
000BDA18 c0ffbd27 addiu      $sp, $sp, -0x40

000C3338 25280000 move       $a1, $zero
000C333C d400048e lw         $a0, 0xd4($s0)
000C3340 5968040c jal        0x11a164
000C3344 d000058e lw         $a1, 0xd0($s0)
000C3348 d400048e lw         $a0, 0xd4($s0)
000C334C 2d00053c lui        $a1, 0x2d
000C3350 8068040c jal        0x11a200
000C3354 dc74b18c lw         $s1, 0x74dc($a1)
000C3358 d000068e lw         $a2, 0xd0($s0)
000C335C ff004530 andi       $a1, $v0, 0xff
000C3360 ff00c630 andi       $a2, $a2, 0xff
000C3364 1dad040c jal        0x12b474
000C3368 25202002 move       $a0, $s1
000C336C 04000010 b          0xc3380
000C3370 00000000 nop        
000C3374 25288000 move       $a1, $a0
000C3378 c6ae020c jal        0xabb18
000C337C 25202002 move       $a0, $s1
000C3380 05000012 beqz       $s0, 0xc3398
000C3384 00000434 ori        $a0, $zero, 0
000C3388 d400048e lw         $a0, 0xd4($s0)
000C338C 8467040c jal        0x119e10
000C3390 d000058e lw         $a1, 0xd0($s0)
000C3394 25204000 move       $a0, $v0
000C3398 25288000 move       $a1, $a0
000C339C c530040c jal        0x10c314
000C33A0 25200000 move       $a0, $zero
000C33A4 01000434 ori        $a0, $zero, 1
000C33A8 c530040c jal        0x10c314
000C33AC 1f000534 ori        $a1, $zero, 0x1f
000C33B0 1000b08f lw         $s0, 0x10($sp)
000C33B4 1400b18f lw         $s1, 0x14($sp)
000C33B8 1800b28f lw         $s2, 0x18($sp)
000C33BC 1c00bf8f lw         $ra, 0x1c($sp)
000C33C0 0800e003 jr         $ra
000C33C4 2000bd27 addiu      $sp, $sp, 0x20

000C3EC4 0000848c lw         $a0, ($a0)
000C3EC8 cc008490 lbu        $a0, 0xcc($a0)
000C3ECC 0f008010 beqz       $a0, 0xc3f0c
000C3ED0 00000000 nop        
000C3ED4 24a4020c jal        0xa9090
000C3ED8 01000434 ori        $a0, $zero, 1
000C3EDC 0800048e lw         $a0, 8($s0)
000C3EE0 0000053c lui        $a1, 0
000C3EE4 a702a4a0 sb         $a0, 0x2a7($a1)
000C3EE8 24a4020c jal        0xa9090
000C3EEC 07000434 ori        $a0, $zero, 7
000C3EF0 04000434 ori        $a0, $zero, 4
000C3EF4 ff51000c jal        0x147fc
000C3EF8 25280000 move       $a1, $zero
000C3EFC 03000010 b          0xc3f0c
000C3F00 00000000 nop        
000C3F04 c6ae020c jal        0xabb18
000C3F08 25200002 move       $a0, $s0
000C3F0C 2d00043c lui        $a0, 0x2d
000C3F10 b59a020c jal        0xa6ad4
000C3F14 bcf78424 addiu      $a0, $a0, -0x844
000C3F18 1c0002ae sw         $v0, 0x1c($s0)
000C3F1C 1000b08f lw         $s0, 0x10($sp)
000C3F20 1400bf8f lw         $ra, 0x14($sp)
000C3F24 0800e003 jr         $ra
000C3F28 2000bd27 addiu      $sp, $sp, 0x20
000C3F2C a0ffbd27 addiu      $sp, $sp, -0x60
000C3F30 3000b0af sw         $s0, 0x30($sp)
000C3F34 3400b1af sw         $s1, 0x34($sp)
000C3F38 3800b2af sw         $s2, 0x38($sp)
000C3F3C 3c00b3af sw         $s3, 0x3c($sp)
000C3F40 4000b4af sw         $s4, 0x40($sp)
000C3F44 4400b5af sw         $s5, 0x44($sp)
000C3F48 4800b6af sw         $s6, 0x48($sp)
000C3F4C 4c00b7af sw         $s7, 0x4c($sp)
000C3F50 5000beaf sw         $fp, 0x50($sp)

000C4B60 0800868c lw         $a2, 8($a0)
000C4B64 3979a0a0 sb         $zero, 0x7939($a1)
000C4B68 0100c538 xori       $a1, $a2, 1
000C4B6C 09000010 b          0xc4b94
000C4B70 080085ac sw         $a1, 8($a0)
000C4B74 07009114 bne        $a0, $s1, 0xc4b94
000C4B78 00000000 nop        
000C4B7C 48b8020c jal        0xae120
000C4B80 00000000 nop        
000C4B84 e6de020c jal        0xb7b98
000C4B88 25204000 move       $a0, $v0
000C4B8C 32ba020c jal        0xae8c8
000C4B90 06000434 ori        $a0, $zero, 6
000C4B94 04000010 b          0xc4ba8
000C4B98 00000000 nop        
000C4B9C 25200002 move       $a0, $s0
000C4BA0 c6ae020c jal        0xabb18
000C4BA4 25284002 move       $a1, $s2
000C4BA8 2d00043c lui        $a0, 0x2d
000C4BAC b59a020c jal        0xa6ad4
000C4BB0 bcf78424 addiu      $a0, $a0, -0x844
000C4BB4 1c0002ae sw         $v0, 0x1c($s0)
000C4BB8 1000b08f lw         $s0, 0x10($sp)
000C4BBC 1400b18f lw         $s1, 0x14($sp)
000C4BC0 1800b28f lw         $s2, 0x18($sp)
000C4BC4 1c00bf8f lw         $ra, 0x1c($sp)
000C4BC8 0800e003 jr         $ra
000C4BCC 2000bd27 addiu      $sp, $sp, 0x20
000C4BD0 0800e003 jr         $ra
000C4BD4 00000000 nop        
000C4BD8 f0ffbd27 addiu      $sp, $sp, -0x10
000C4BDC 0000bfaf sw         $ra, ($sp)
000C4BE0 f412030c jal        0xc4bd0
000C4BE4 00000000 nop        
000C4BE8 0000bf8f lw         $ra, ($sp)
000C4BEC 0800e003 jr         $ra

000C4E60 a07c80a0 sb         $zero, 0x7ca0($a0)
000C4E64 0713030c jal        0xc4c1c
000C4E68 c4010434 ori        $a0, $zero, 0x1c4
000C4E6C 09000010 b          0xc4e94
000C4E70 00000000 nop        
000C4E74 07009114 bne        $a0, $s1, 0xc4e94
000C4E78 00000000 nop        
000C4E7C 48b8020c jal        0xae120
000C4E80 00000000 nop        
000C4E84 e6de020c jal        0xb7b98
000C4E88 25204000 move       $a0, $v0
000C4E8C 32ba020c jal        0xae8c8
000C4E90 06000434 ori        $a0, $zero, 6
000C4E94 04000010 b          0xc4ea8
000C4E98 00000000 nop        
000C4E9C 25200002 move       $a0, $s0
000C4EA0 c6ae020c jal        0xabb18
000C4EA4 25284002 move       $a1, $s2
000C4EA8 2d00043c lui        $a0, 0x2d
000C4EAC b59a020c jal        0xa6ad4
000C4EB0 bcf78424 addiu      $a0, $a0, -0x844
000C4EB4 1c0002ae sw         $v0, 0x1c($s0)
000C4EB8 1000b08f lw         $s0, 0x10($sp)
000C4EBC 1400b18f lw         $s1, 0x14($sp)
000C4EC0 1800b28f lw         $s2, 0x18($sp)
000C4EC4 1c00bf8f lw         $ra, 0x1c($sp)
000C4EC8 0800e003 jr         $ra
000C4ECC 2000bd27 addiu      $sp, $sp, 0x20
000C4ED0 d0febd27 addiu      $sp, $sp, -0x130
000C4ED4 2401b1af sw         $s1, 0x124($sp)
000C4ED8 2e00113c lui        $s1, 0x2e
000C4EDC 6090248e lw         $a0, -0x6fa0($s1)
000C4EE0 2001b0af sw         $s0, 0x120($sp)
000C4EE4 0400103c lui        $s0, 4
000C4EE8 2801bfaf sw         $ra, 0x128($sp)
000C4EEC 09008010 beqz       $a0, 0xc4f14

000C4F90 25280000 move       $a1, $zero
000C4F94 10000010 b          0xc4fd8
000C4F98 00000000 nop        
000C4F9C 00408530 andi       $a1, $a0, 0x4000
000C4FA0 0a00a010 beqz       $a1, 0xc4fcc
000C4FA4 00000000 nop        
000C4FA8 0b002012 beqz       $s1, 0xc4fd8
000C4FAC 00000000 nop        
000C4FB0 24a4020c jal        0xa9090
000C4FB4 01000434 ori        $a0, $zero, 1
000C4FB8 d000248e lw         $a0, 0xd0($s1)
000C4FBC 3452000c jal        0x148d0
000C4FC0 01000534 ori        $a1, $zero, 1
000C4FC4 04000010 b          0xc4fd8
000C4FC8 00000000 nop        
000C4FCC 25288000 move       $a1, $a0
000C4FD0 c6ae020c jal        0xabb18
000C4FD4 25200002 move       $a0, $s0
000C4FD8 2001b08f lw         $s0, 0x120($sp)
000C4FDC 2401b18f lw         $s1, 0x124($sp)
000C4FE0 2801bf8f lw         $ra, 0x128($sp)
000C4FE4 0800e003 jr         $ra
000C4FE8 3001bd27 addiu      $sp, $sp, 0x130
000C4FEC c0ffbd27 addiu      $sp, $sp, -0x40
000C4FF0 2000b4e7 swc1       $f20, 0x20($sp)
000C4FF4 2400b0af sw         $s0, 0x24($sp)
000C4FF8 2800b1af sw         $s1, 0x28($sp)
000C4FFC 2c00b2af sw         $s2, 0x2c($sp)
000C5000 3000bfaf sw         $ra, 0x30($sp)
000C5004 4c73020c jal        0x9cd30
000C5008 00000000 nop        
000C500C f572020c jal        0x9cbd4
000C5010 00000000 nop        
000C5014 00a08044 mtc1       $zero, $f20
000C5018 1000b027 addiu      $s0, $sp, 0x10
000C501C d0010434 ori        $a0, $zero, 0x1d0