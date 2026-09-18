
CALLBACK 0x000FF3B8 end 0x000FF4A8 ordinal 0

000FF3B8 27BDFFD0 addiu      $sp, $sp, -0x30
000FF3BC 3C06002A lui        $a2, 0x2a
000FF3C0 8CC69868 lw         $a2, -0x6798($a2)
000FF3C4 AFBF0024 sw         $ra, 0x24($sp)
000FF3C8 8CC70038 lw         $a3, 0x38($a2)
000FF3CC 34080000 ori        $t0, $zero, 0
000FF3D0 0107282B sltu       $a1, $t0, $a3
000FF3D4 10A0000F beqz       $a1, 0xff414
000FF3D8 8C840058 lw         $a0, 0x58($a0)
000FF3DC 8CC60034 lw         $a2, 0x34($a2)
000FF3E0 3C09462E lui        $t1, 0x462e
000FF3E4 34050000 ori        $a1, $zero, 0
000FF3E8 00C05025 move       $t2, $a2
000FF3EC 25294E09 addiu      $t1, $t1, 0x4e09
000FF3F0 8D4B0030 lw         $t3, 0x30($t2)
000FF3F4 15690003 bne        $t3, $t1, 0xff404
000FF3F8 25080001 addiu      $t0, $t0, 1
000FF3FC 10000006 b          0xff418
000FF400 00C53021 addu       $a2, $a2, $a1
000FF404 24A50050 addiu      $a1, $a1, 0x50
000FF408 0107582B sltu       $t3, $t0, $a3
000FF40C 1560FFF8 bnez       $t3, 0xff3f0
000FF410 254A0050 addiu      $t2, $t2, 0x50
000FF414 34060000 ori        $a2, $zero, 0
000FF418 10C0000D beqz       $a2, 0xff450
000FF41C AC860020 sw         $a2, 0x20($a0)
000FF420 8CC5003C lw         $a1, 0x3c($a2)
000FF424 10A0000A beqz       $a1, 0xff450
000FF428 34050008 ori        $a1, $zero, 8
000FF42C AFA50020 sw         $a1, 0x20($sp)
000FF430 8C850020 lw         $a1, 0x20($a0)
000FF434 24A5003C addiu      $a1, $a1, 0x3c
000FF438 8CA60000 lw         $a2, ($a1)
000FF43C 2CC60008 sltiu      $a2, $a2, 8
000FF440 54C00011 bnel       $a2, $zero, 0xff488
000FF444 27A50020 addiu      $a1, $sp, 0x20
000FF448 1000000F b          0xff488
000FF44C 00000000 nop        
000FF450 3C05002A lui        $a1, 0x2a
000FF454 3C06001A lui        $a2, 0x1a
000FF458 3C08001A lui        $t0, 0x1a
000FF45C 34040002 ori        $a0, $zero, 2
000FF460 3407007B ori        $a3, $zero, 0x7b
000FF464 24A5C4E8 addiu      $a1, $a1, -0x3b18
000FF468 24C68230 addiu      $a2, $a2, -0x7dd0
000FF46C 0C038B7E jal        0xe2df8
000FF470 25088274 addiu      $t0, $t0, -0x7d8c
000FF474 3C04001A lui        $a0, 0x1a
000FF478 0C038B89 jal        0xe2e24
000FF47C 24848278 addiu      $a0, $a0, -0x7d88
000FF480 10000006 b          0xff49c
000FF484 00001025 move       $v0, $zero
000FF488 8CA50000 lw         $a1, ($a1)
000FF48C A0800024 sb         $zero, 0x24($a0)
000FF490 A0850025 sb         $a1, 0x25($a0)
000FF494 A0800026 sb         $zero, 0x26($a0)
000FF498 34020001 ori        $v0, $zero, 1
000FF49C 8FBF0024 lw         $ra, 0x24($sp)
000FF4A0 03E00008 jr         $ra
000FF4A4 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x000FF4A8 end 0x000FF4B0 ordinal 1

000FF4A8 03E00008 jr         $ra
000FF4AC 00000000 nop        

CALLBACK 0x000FF660 end 0x000FF87C ordinal 2

000FF660 27BDFD60 addiu      $sp, $sp, -0x2a0
000FF664 E7B40270 swc1       $f20, 0x270($sp)
000FF668 AFB00274 sw         $s0, 0x274($sp)
000FF66C 46006506 mov.s      $f20, $f12
000FF670 00808025 move       $s0, $a0
000FF674 AFB10278 sw         $s1, 0x278($sp)
000FF678 AFB2027C sw         $s2, 0x27c($sp)
000FF67C AFB30280 sw         $s3, 0x280($sp)
000FF680 AFB40284 sw         $s4, 0x284($sp)
000FF684 AFB50288 sw         $s5, 0x288($sp)
000FF688 AFB6028C sw         $s6, 0x28c($sp)
000FF68C AFBF0290 sw         $ra, 0x290($sp)
000FF690 3C04002A lui        $a0, 0x2a
000FF694 8C84C4E4 lw         $a0, -0x3b1c($a0)
000FF698 34120000 ori        $s2, $zero, 0
000FF69C 8C910058 lw         $s1, 0x58($a0)
000FF6A0 92240024 lbu        $a0, 0x24($s1)
000FF6A4 0244282A slt        $a1, $s2, $a0
000FF6A8 10A00020 beqz       $a1, 0xff72c
000FF6AC 02209825 move       $s3, $s1
000FF6B0 8E650000 lw         $a1, ($s3)
000FF6B4 8CA60064 lw         $a2, 0x64($a1)
000FF6B8 30C60006 andi       $a2, $a2, 6
000FF6BC 10C00017 beqz       $a2, 0xff71c
000FF6C0 00000000 nop        
000FF6C4 0C0401AC jal        0x1006b0
000FF6C8 00A02025 move       $a0, $a1
000FF6CC 10400004 beqz       $v0, 0xff6e0
000FF6D0 00000000 nop        
000FF6D4 92240026 lbu        $a0, 0x26($s1)
000FF6D8 2484FFFF addiu      $a0, $a0, -1
000FF6DC A2240026 sb         $a0, 0x26($s1)
000FF6E0 0C019375 jal        0x64dd4
000FF6E4 8E640000 lw         $a0, ($s3)
000FF6E8 92240024 lbu        $a0, 0x24($s1)
000FF6EC 2484FFFF addiu      $a0, $a0, -1
000FF6F0 A2240024 sb         $a0, 0x24($s1)
000FF6F4 92240024 lbu        $a0, 0x24($s1)
000FF6F8 12440008 beq        $s2, $a0, 0xff71c
000FF6FC 00000000 nop        
000FF700 00042080 sll        $a0, $a0, 2
000FF704 02242021 addu       $a0, $s1, $a0
000FF708 8C840000 lw         $a0, ($a0)
000FF70C 2652FFFF addiu      $s2, $s2, -1
000FF710 AE640000 sw         $a0, ($s3)
000FF714 2673FFFC addiu      $s3, $s3, -4
000FF718 92240024 lbu        $a0, 0x24($s1)
000FF71C 26520001 addiu      $s2, $s2, 1
000FF720 0244282A slt        $a1, $s2, $a0
000FF724 14A0FFE2 bnez       $a1, 0xff6b0
000FF728 26730004 addiu      $s3, $s3, 4
000FF72C 34120000 ori        $s2, $zero, 0
000FF730 0244202A slt        $a0, $s2, $a0
000FF734 10800014 beqz       $a0, 0xff788
000FF738 03A0A025 move       $s4, $sp
000FF73C 02209825 move       $s3, $s1
000FF740 26950010 addiu      $s5, $s4, 0x10
000FF744 8E760000 lw         $s6, ($s3)
000FF748 0C040958 jal        0x102560
000FF74C 02C02025 move       $a0, $s6
000FF750 02C02025 move       $a0, $s6
000FF754 02A02825 move       $a1, $s5
000FF758 0C040248 jal        0x100920
000FF75C 34060008 ori        $a2, $zero, 8
000FF760 AE820050 sw         $v0, 0x50($s4)
000FF764 AE800054 sw         $zero, 0x54($s4)
000FF768 A2800058 sb         $zero, 0x58($s4)
000FF76C 92240024 lbu        $a0, 0x24($s1)
000FF770 26520001 addiu      $s2, $s2, 1
000FF774 26730004 addiu      $s3, $s3, 4
000FF778 2694004C addiu      $s4, $s4, 0x4c
000FF77C 0244202A slt        $a0, $s2, $a0
000FF780 1480FFF0 bnez       $a0, 0xff744
000FF784 26B5004C addiu      $s5, $s5, 0x4c
000FF788 34040000 ori        $a0, $zero, 0
000FF78C 34120000 ori        $s2, $zero, 0
000FF790 27B30010 addiu      $s3, $sp, 0x10
000FF794 14800009 bnez       $a0, 0xff7bc
000FF798 2E440028 sltiu      $a0, $s2, 0x28
000FF79C 50800008 beql       $a0, $zero, 0xff7c0
000FF7A0 92240024 lbu        $a0, 0x24($s1)
000FF7A4 02002025 move       $a0, $s0
000FF7A8 0C03FD2C jal        0xff4b0
000FF7AC 02602825 move       $a1, $s3
000FF7B0 00402025 move       $a0, $v0
000FF7B4 1000FFF7 b          0xff794
000FF7B8 26520001 addiu      $s2, $s2, 1
000FF7BC 92240024 lbu        $a0, 0x24($s1)
000FF7C0 34100000 ori        $s0, $zero, 0
000FF7C4 0204202A slt        $a0, $s0, $a0
000FF7C8 10800021 beqz       $a0, 0xff850
000FF7CC 03A09025 move       $s2, $sp
000FF7D0 02209825 move       $s3, $s1
000FF7D4 8E440054 lw         $a0, 0x54($s2)
000FF7D8 8E460050 lw         $a2, 0x50($s2)
000FF7DC 0086302B sltu       $a2, $a0, $a2
000FF7E0 10C0000B beqz       $a2, 0xff810
000FF7E4 8E650000 lw         $a1, ($s3)
000FF7E8 000420C0 sll        $a0, $a0, 3
000FF7EC 02442021 addu       $a0, $s2, $a0
000FF7F0 8C860010 lw         $a2, 0x10($a0)
000FF7F4 00A02025 move       $a0, $a1
000FF7F8 0C0409AA jal        0x1026a8
000FF7FC 00C02825 move       $a1, $a2
000FF800 8E240020 lw         $a0, 0x20($s1)
000FF804 8E650000 lw         $a1, ($s3)
000FF808 10000007 b          0xff828
000FF80C 8C84001C lw         $a0, 0x1c($a0)
000FF810 00A02025 move       $a0, $a1
000FF814 0C0409AA jal        0x1026a8
000FF818 00002825 move       $a1, $zero
000FF81C 8E240020 lw         $a0, 0x20($s1)
000FF820 8E650000 lw         $a1, ($s3)
000FF824 8C84001C lw         $a0, 0x1c($a0)
000FF828 00803025 move       $a2, $a0
000FF82C 4600A306 mov.s      $f12, $f20
000FF830 00C0F809 jalr       $a2
000FF834 00A02025 move       $a0, $a1
000FF838 92240024 lbu        $a0, 0x24($s1)
000FF83C 26100001 addiu      $s0, $s0, 1
000FF840 2652004C addiu      $s2, $s2, 0x4c
000FF844 0204202A slt        $a0, $s0, $a0
000FF848 1480FFE2 bnez       $a0, 0xff7d4
000FF84C 26730004 addiu      $s3, $s3, 4
000FF850 C7B40270 lwc1       $f20, 0x270($sp)
000FF854 8FB00274 lw         $s0, 0x274($sp)
000FF858 8FB10278 lw         $s1, 0x278($sp)
000FF85C 8FB2027C lw         $s2, 0x27c($sp)
000FF860 8FB30280 lw         $s3, 0x280($sp)
000FF864 8FB40284 lw         $s4, 0x284($sp)
000FF868 8FB50288 lw         $s5, 0x288($sp)
000FF86C 8FB6028C lw         $s6, 0x28c($sp)
000FF870 8FBF0290 lw         $ra, 0x290($sp)
000FF874 03E00008 jr         $ra
000FF878 27BD02A0 addiu      $sp, $sp, 0x2a0