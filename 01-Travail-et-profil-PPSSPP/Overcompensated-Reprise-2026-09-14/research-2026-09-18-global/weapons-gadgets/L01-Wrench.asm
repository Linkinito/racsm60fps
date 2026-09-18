
CALLBACK 0x001896D8 end 0x001897AC ordinal 0

001896D8 27BDFFD0 addiu      $sp, $sp, -0x30
001896DC AFB00020 sw         $s0, 0x20($sp)
001896E0 00808025 move       $s0, $a0
001896E4 AFB10024 sw         $s1, 0x24($sp)
001896E8 AFBF0028 sw         $ra, 0x28($sp)
001896EC 8E110058 lw         $s1, 0x58($s0)
001896F0 00002825 move       $a1, $zero
001896F4 02202025 move       $a0, $s1
001896F8 0C06B6A7 jal        0x1ada9c
001896FC 34060104 ori        $a2, $zero, 0x104
00189700 AE200000 sw         $zero, ($s1)
00189704 0C03FCAD jal        0xff2b4
00189708 26240004 addiu      $a0, $s1, 4
0018970C 8E040048 lw         $a0, 0x48($s0)
00189710 3C050019 lui        $a1, 0x19
00189714 24A5A6C8 addiu      $a1, $a1, -0x5938
00189718 AC8500DC sw         $a1, 0xdc($a0)
0018971C A2000046 sb         $zero, 0x46($s0)
00189720 A22000FC sb         $zero, 0xfc($s1)
00189724 AE2000F8 sw         $zero, 0xf8($s1)
00189728 34050000 ori        $a1, $zero, 0
0018972C 02202025 move       $a0, $s1
00189730 AC8000E0 sw         $zero, 0xe0($a0)
00189734 24A50001 addiu      $a1, $a1, 1
00189738 2CA60006 sltiu      $a2, $a1, 6
0018973C 14C0FFFC bnez       $a2, 0x189730
00189740 24840004 addiu      $a0, $a0, 4
00189744 3C04002B lui        $a0, 0x2b
00189748 8C8400C0 lw         $a0, 0xc0($a0)
0018974C 3C05002E lui        $a1, 0x2e
00189750 C4AC9910 lwc1       $f12, -0x66f0($a1)
00189754 3C05002E lui        $a1, 0x2e
00189758 C4AD9914 lwc1       $f13, -0x66ec($a1)
0018975C 3C05002E lui        $a1, 0x2e
00189760 3C06002D lui        $a2, 0x2d
00189764 3C084120 lui        $t0, 0x4120
00189768 00003825 move       $a3, $zero
0018976C 44887000 mtc1       $t0, $f14
00189770 24A59904 addiu      $a1, $a1, -0x66fc
00189774 0C01707F jal        0x5c1fc
00189778 24C6A34C addiu      $a2, $a2, -0x5cb4
0018977C 8E040064 lw         $a0, 0x64($s0)
00189780 3C050004 lui        $a1, 4
00189784 00852025 or         $a0, $a0, $a1
00189788 AE040064 sw         $a0, 0x64($s0)
0018978C A2200102 sb         $zero, 0x102($s1)
00189790 A2200103 sb         $zero, 0x103($s1)
00189794 34020001 ori        $v0, $zero, 1
00189798 8FB00020 lw         $s0, 0x20($sp)
0018979C 8FB10024 lw         $s1, 0x24($sp)
001897A0 8FBF0028 lw         $ra, 0x28($sp)
001897A4 03E00008 jr         $ra
001897A8 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x001897AC end 0x001897FC ordinal 1

001897AC 27BDFFE0 addiu      $sp, $sp, -0x20
001897B0 AFB00014 sw         $s0, 0x14($sp)
001897B4 00808025 move       $s0, $a0
001897B8 8E050058 lw         $a1, 0x58($s0)
001897BC 8CA400F8 lw         $a0, 0xf8($a1)
001897C0 AFBF0018 sw         $ra, 0x18($sp)
001897C4 10800005 beqz       $a0, 0x1897dc
001897C8 00000000 nop        
001897CC 0C01B1A3 jal        0x6c68c
001897D0 AFA50010 sw         $a1, 0x10($sp)
001897D4 8FA40010 lw         $a0, 0x10($sp)
001897D8 AC8000F8 sw         $zero, 0xf8($a0)
001897DC 0C064C47 jal        0x19311c
001897E0 00000000 nop        
001897E4 0C06265B jal        0x18996c
001897E8 02002025 move       $a0, $s0
001897EC 8FB00014 lw         $s0, 0x14($sp)
001897F0 8FBF0018 lw         $ra, 0x18($sp)
001897F4 03E00008 jr         $ra
001897F8 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x00189BE8 end 0x00189ECC ordinal 2

00189BE8 27BDFFD0 addiu      $sp, $sp, -0x30
00189BEC AFB00020 sw         $s0, 0x20($sp)
00189BF0 00808025 move       $s0, $a0
00189BF4 AFB10024 sw         $s1, 0x24($sp)
00189BF8 8E110058 lw         $s1, 0x58($s0)
00189BFC 8E240000 lw         $a0, ($s1)
00189C00 A22000FE sb         $zero, 0xfe($s1)
00189C04 848500F8 lh         $a1, 0xf8($a0)
00189C08 92260100 lbu        $a2, 0x100($s1)
00189C0C AFBF0028 sw         $ra, 0x28($sp)
00189C10 54A60006 bnel       $a1, $a2, 0x189c2c
00189C14 8C87095C lw         $a3, 0x95c($a0)
00189C18 94870100 lhu        $a3, 0x100($a0)
00189C1C 92280101 lbu        $t0, 0x101($s1)
00189C20 10E8001F beq        $a3, $t0, 0x189ca0
00189C24 00000000 nop        
00189C28 8C87095C lw         $a3, 0x95c($a0)
00189C2C 30E70800 andi       $a3, $a3, 0x800
00189C30 14E0001B bnez       $a3, 0x189ca0
00189C34 00000000 nop        
00189C38 34070011 ori        $a3, $zero, 0x11
00189C3C 14A70005 bne        $a1, $a3, 0x189c54
00189C40 34080012 ori        $t0, $zero, 0x12
00189C44 34080010 ori        $t0, $zero, 0x10
00189C48 10C80012 beq        $a2, $t0, 0x189c94
00189C4C 00000000 nop        
00189C50 34080012 ori        $t0, $zero, 0x12
00189C54 54A80004 bnel       $a1, $t0, 0x189c68
00189C58 34070013 ori        $a3, $zero, 0x13
00189C5C 10C7000D beq        $a2, $a3, 0x189c94
00189C60 00000000 nop        
00189C64 34070013 ori        $a3, $zero, 0x13
00189C68 14A70003 bne        $a1, $a3, 0x189c78
00189C6C 00000000 nop        
00189C70 10C80008 beq        $a2, $t0, 0x189c94
00189C74 00000000 nop        
00189C78 A22000CA sb         $zero, 0xca($s1)
00189C7C A22000CD sb         $zero, 0xcd($s1)
00189C80 A22000FD sb         $zero, 0xfd($s1)
00189C84 3C05002E lui        $a1, 0x2e
00189C88 A0A0984C sb         $zero, -0x67b4($a1)
00189C8C A22000FC sb         $zero, 0xfc($s1)
00189C90 848500F8 lh         $a1, 0xf8($a0)
00189C94 A2250100 sb         $a1, 0x100($s1)
00189C98 94850100 lhu        $a1, 0x100($a0)
00189C9C A2250101 sb         $a1, 0x101($s1)
00189CA0 8E2500DC lw         $a1, 0xdc($s1)
00189CA4 24A5FFFF addiu      $a1, $a1, -1
00189CA8 04A10002 bgez       $a1, 0x189cb4
00189CAC AE2500DC sw         $a1, 0xdc($s1)
00189CB0 AE2000DC sw         $zero, 0xdc($s1)
00189CB4 8C8605C8 lw         $a2, 0x5c8($a0)
00189CB8 24C6FFFF addiu      $a2, $a2, -1
00189CBC 2CC7000D sltiu      $a3, $a2, 0xd
00189CC0 10E00014 beqz       $a3, 0x189d14
00189CC4 34050000 ori        $a1, $zero, 0
00189CC8 00063080 sll        $a2, $a2, 2
00189CCC 3C01001D lui        $at, 0x1d
00189CD0 00260821 addu       $at, $at, $a2
00189CD4 8C21A2B0 lw         $at, -0x5d50($at)
00189CD8 00200008 jr         $at
00189CDC 00000000 nop        
00189CE0 1000000C b          0x189d14
00189CE4 34050001 ori        $a1, $zero, 1
00189CE8 1000000A b          0x189d14
00189CEC 34050002 ori        $a1, $zero, 2
00189CF0 10000008 b          0x189d14
00189CF4 34050003 ori        $a1, $zero, 3
00189CF8 10000006 b          0x189d14
00189CFC 34050004 ori        $a1, $zero, 4
00189D00 10000004 b          0x189d14
00189D04 34050005 ori        $a1, $zero, 5
00189D08 10000002 b          0x189d14
00189D0C 34050006 ori        $a1, $zero, 6
00189D10 34050007 ori        $a1, $zero, 7
00189D14 14A00005 bnez       $a1, 0x189d2c
00189D18 00000000 nop        
00189D1C 92260103 lbu        $a2, 0x103($s1)
00189D20 34070001 ori        $a3, $zero, 1
00189D24 10C7005C beq        $a2, $a3, 0x189e98
00189D28 00000000 nop        
00189D2C 848600F8 lh         $a2, 0xf8($a0)
00189D30 24C6FFF7 addiu      $a2, $a2, -9
00189D34 2CC7002F sltiu      $a3, $a2, 0x2f
00189D38 10E00045 beqz       $a3, 0x189e50
00189D3C 00000000 nop        
00189D40 00063080 sll        $a2, $a2, 2
00189D44 3C01001D lui        $at, 0x1d
00189D48 00260821 addu       $at, $at, $a2
00189D4C 8C21A2E8 lw         $at, -0x5d18($at)
00189D50 00200008 jr         $at
00189D54 00000000 nop        
00189D58 00A04025 move       $t0, $a1
00189D5C 8C860594 lw         $a2, 0x594($a0)
00189D60 262400C8 addiu      $a0, $s1, 0xc8
00189D64 02002825 move       $a1, $s0
00189D68 0C03FD4B jal        0xff52c
00189D6C 00003825 move       $a3, $zero
00189D70 10000049 b          0x189e98
00189D74 00000000 nop        
00189D78 00A04025 move       $t0, $a1
00189D7C 8C860594 lw         $a2, 0x594($a0)
00189D80 262400C8 addiu      $a0, $s1, 0xc8
00189D84 02002825 move       $a1, $s0
00189D88 0C03FD4B jal        0xff52c
00189D8C 34070001 ori        $a3, $zero, 1
00189D90 10000041 b          0x189e98
00189D94 00000000 nop        
00189D98 00A04025 move       $t0, $a1
00189D9C 8C860594 lw         $a2, 0x594($a0)
00189DA0 262400C8 addiu      $a0, $s1, 0xc8
00189DA4 02002825 move       $a1, $s0
00189DA8 0C03FD4B jal        0xff52c
00189DAC 34070002 ori        $a3, $zero, 2
00189DB0 10000039 b          0x189e98
00189DB4 00000000 nop        
00189DB8 10000037 b          0x189e98
00189DBC 00000000 nop        
00189DC0 00A04025 move       $t0, $a1
00189DC4 8C860594 lw         $a2, 0x594($a0)
00189DC8 262400C8 addiu      $a0, $s1, 0xc8
00189DCC 02002825 move       $a1, $s0
00189DD0 0C03FD4B jal        0xff52c
00189DD4 34070003 ori        $a3, $zero, 3
00189DD8 1000002F b          0x189e98
00189DDC 00000000 nop        
00189DE0 1000002D b          0x189e98
00189DE4 00000000 nop        
00189DE8 0C06260E jal        0x189838
00189DEC 02002025 move       $a0, $s0
00189DF0 10000029 b          0x189e98
00189DF4 00000000 nop        
00189DF8 94860100 lhu        $a2, 0x100($a0)
00189DFC 34070006 ori        $a3, $zero, 6
00189E00 14C70007 bne        $a2, $a3, 0x189e20
00189E04 00000000 nop        
00189E08 00A04025 move       $t0, $a1
00189E0C 8C860594 lw         $a2, 0x594($a0)
00189E10 262400C8 addiu      $a0, $s1, 0xc8
00189E14 02002825 move       $a1, $s0
00189E18 0C03FD4B jal        0xff52c
00189E1C 00003825 move       $a3, $zero
00189E20 1000001D b          0x189e98
00189E24 00000000 nop        
00189E28 94860100 lhu        $a2, 0x100($a0)
00189E2C 34070005 ori        $a3, $zero, 5
00189E30 14C70007 bne        $a2, $a3, 0x189e50
00189E34 00000000 nop        
00189E38 00A04025 move       $t0, $a1
00189E3C 8C860594 lw         $a2, 0x594($a0)
00189E40 262400C8 addiu      $a0, $s1, 0xc8
00189E44 02002825 move       $a1, $s0
00189E48 0C03FD4B jal        0xff52c
00189E4C 00003825 move       $a3, $zero
00189E50 02002025 move       $a0, $s0
00189E54 0C01AA82 jal        0x6aa08
00189E58 00002825 move       $a1, $zero
00189E5C 1040000E beqz       $v0, 0x189e98
00189E60 00000000 nop        
00189E64 0C01ABB4 jal        0x6aed0
00189E68 02002025 move       $a0, $s0
00189E6C 1040000A beqz       $v0, 0x189e98
00189E70 00000000 nop        
00189E74 3C083ECC lui        $t0, 0x3ecc
00189E78 44806800 mtc1       $zero, $f13
00189E7C 3508CCCD ori        $t0, $t0, 0xcccd
00189E80 02002025 move       $a0, $s0
00189E84 44886000 mtc1       $t0, $f12
00189E88 00002825 move       $a1, $zero
00189E8C 00003025 move       $a2, $zero
00189E90 0C01AB54 jal        0x6ad50
00189E94 34070001 ori        $a3, $zero, 1
00189E98 92040046 lbu        $a0, 0x46($s0)
00189E9C 10800003 beqz       $a0, 0x189eac
00189EA0 00000000 nop        
00189EA4 0C0627B3 jal        0x189ecc
00189EA8 02002025 move       $a0, $s0
00189EAC 92240103 lbu        $a0, 0x103($s1)
00189EB0 2C840001 sltiu      $a0, $a0, 1
00189EB4 A2240103 sb         $a0, 0x103($s1)
00189EB8 8FB00020 lw         $s0, 0x20($sp)
00189EBC 8FB10024 lw         $s1, 0x24($sp)
00189EC0 8FBF0028 lw         $ra, 0x28($sp)
00189EC4 03E00008 jr         $ra
00189EC8 27BD0030 addiu      $sp, $sp, 0x30