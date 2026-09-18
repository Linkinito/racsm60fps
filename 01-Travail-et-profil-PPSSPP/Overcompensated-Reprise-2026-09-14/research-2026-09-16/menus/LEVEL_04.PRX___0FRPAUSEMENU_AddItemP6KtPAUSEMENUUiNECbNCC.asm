000AC850 ff004231 andi       $v0, $t2, 0xff
000AC854 3000838c lw         $v1, 0x30($a0)
000AC858 09006014 bnez       $v1, 0xac880
000AC85C 0000aa8f lw         $t2, ($sp)
000AC860 28008c8c lw         $t4, 0x28($a0)
000AC864 2c00838c lw         $v1, 0x2c($a0)
000AC868 1cff8c25 addiu      $t4, $t4, -0xe4
000AC86C 2b608301 sltu       $t4, $t4, $v1
000AC870 05008051 beql       $t4, $zero, 0xac888
000AC874 4c008c90 lbu        $t4, 0x4c($a0)
000AC878 3b000010 b          0xac968
000AC87C 25100000 move       $v0, $zero
000AC880 39000010 b          0xac968
000AC884 25100000 move       $v0, $zero
000AC888 2568c000 move       $t5, $a2
000AC88C cc006ca0 sb         $t4, 0xcc($v1)
000AC890 4d008690 lbu        $a2, 0x4d($a0)
000AC894 cd0066a0 sb         $a2, 0xcd($v1)
000AC898 40008cc4 lwc1       $f12, 0x40($a0)
000AC89C ffff0624 addiu      $a2, $zero, -1
000AC8A0 c0006ce4 swc1       $f12, 0xc0($v1)
000AC8A4 44008cc4 lwc1       $f12, 0x44($a0)
000AC8A8 c80066ac sw         $a2, 0xc8($v1)
000AC8AC c4006ce4 swc1       $f12, 0xc4($v1)
000AC8B0 d0006dac sw         $t5, 0xd0($v1)
000AC8B4 d40067ac sw         $a3, 0xd4($v1)
000AC8B8 d80068ac sw         $t0, 0xd8($v1)
000AC8BC dc0069ac sw         $t1, 0xdc($v1)
000AC8C0 7000878c lw         $a3, 0x70($a0)
000AC8C4 080067ac sw         $a3, 8($v1)
000AC8C8 6c00878c lw         $a3, 0x6c($a0)
000AC8CC 10006bac sw         $t3, 0x10($v1)
000AC8D0 140067ac sw         $a3, 0x14($v1)
000AC8D4 0c0062a0 sb         $v0, 0xc($v1)
000AC8D8 000065ac sw         $a1, ($v1)
000AC8DC 3c00858c lw         $a1, 0x3c($a0)
000AC8E0 240060a0 sb         $zero, 0x24($v1)
000AC8E4 040065ac sw         $a1, 4($v1)
000AC8E8 2c006aac sw         $t2, 0x2c($v1)
000AC8EC 280060ac sw         $zero, 0x28($v1)
000AC8F0 01000534 ori        $a1, $zero, 1
000AC8F4 30006224 addiu      $v0, $v1, 0x30
000AC8F8 080046ac sw         $a2, 8($v0)
000AC8FC 140046ac sw         $a2, 0x14($v0)
000AC900 100040ac sw         $zero, 0x10($v0)
000AC904 0c0040a0 sb         $zero, 0xc($v0)
000AC908 000040ac sw         $zero, ($v0)
000AC90C 040046ac sw         $a2, 4($v0)
000AC910 180046ac sw         $a2, 0x18($v0)
000AC914 240040a0 sb         $zero, 0x24($v0)
000AC918 2c004aac sw         $t2, 0x2c($v0)
000AC91C 280040ac sw         $zero, 0x28($v0)
000AC920 0100a524 addiu      $a1, $a1, 1
000AC924 0400a72c sltiu      $a3, $a1, 4
000AC928 f3ffe014 bnez       $a3, 0xac8f8
000AC92C 30004224 addiu      $v0, $v0, 0x30
000AC930 3400858c lw         $a1, 0x34($a0)
000AC934 2c00868c lw         $a2, 0x2c($a0)
000AC938 0100a524 addiu      $a1, $a1, 1
000AC93C 340085ac sw         $a1, 0x34($a0)
000AC940 e400c624 addiu      $a2, $a2, 0xe4
000AC944 2800858c lw         $a1, 0x28($a0)
000AC948 2c0086ac sw         $a2, 0x2c($a0)
000AC94C 2b30a600 sltu       $a2, $a1, $a2
000AC950 0400c010 beqz       $a2, 0xac964
000AC954 00000000 nop        
000AC958 2c0085ac sw         $a1, 0x2c($a0)
000AC95C 02000010 b          0xac968
000AC960 25100000 move       $v0, $zero
000AC964 01000234 ori        $v0, $zero, 1
000AC968 0800e003 jr         $ra
000AC96C 00000000 nop        