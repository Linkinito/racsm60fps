
CALLBACK 0x00144830 end 0x00144898 ordinal 0

00144830 27BDFFD0 addiu      $sp, $sp, -0x30
00144834 AFB00020 sw         $s0, 0x20($sp)
00144838 00808025 move       $s0, $a0
0014483C 8E040058 lw         $a0, 0x58($s0)
00144840 AC800000 sw         $zero, ($a0)
00144844 44806000 mtc1       $zero, $f12
00144848 AC800004 sw         $zero, 4($a0)
0014484C E48C0008 swc1       $f12, 8($a0)
00144850 3C08002B lui        $t0, 0x2b
00144854 24840010 addiu      $a0, $a0, 0x10
00144858 00002825 move       $a1, $zero
0014485C 34060044 ori        $a2, $zero, 0x44
00144860 34070045 ori        $a3, $zero, 0x45
00144864 AFBF0024 sw         $ra, 0x24($sp)
00144868 0C019B8F jal        0x66e3c
0014486C 250828D8 addiu      $t0, $t0, 0x28d8
00144870 8E040064 lw         $a0, 0x64($s0)
00144874 3C050004 lui        $a1, 4
00144878 A2000045 sb         $zero, 0x45($s0)
0014487C 00852025 or         $a0, $a0, $a1
00144880 AE040064 sw         $a0, 0x64($s0)
00144884 34020001 ori        $v0, $zero, 1
00144888 8FB00020 lw         $s0, 0x20($sp)
0014488C 8FBF0024 lw         $ra, 0x24($sp)
00144890 03E00008 jr         $ra
00144894 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x001448CC end 0x001448D4 ordinal 1

001448CC 03E00008 jr         $ra
001448D0 00000000 nop        

CALLBACK 0x00144954 end 0x00144ABC ordinal 2

00144954 27BDFFB0 addiu      $sp, $sp, -0x50
00144958 AFB00034 sw         $s0, 0x34($sp)
0014495C 8C900058 lw         $s0, 0x58($a0)
00144960 90850045 lbu        $a1, 0x45($a0)
00144964 E7B4002C swc1       $f20, 0x2c($sp)
00144968 E7B60030 swc1       $f22, 0x30($sp)
0014496C AFB2003C sw         $s2, 0x3c($sp)
00144970 4480B000 mtc1       $zero, $f22
00144974 46006506 mov.s      $f20, $f12
00144978 8E120000 lw         $s2, ($s0)
0014497C 34060001 ori        $a2, $zero, 1
00144980 AFB10038 sw         $s1, 0x38($sp)
00144984 AFBF0040 sw         $ra, 0x40($sp)
00144988 14A60010 bne        $a1, $a2, 0x1449cc
0014498C 00808825 move       $s1, $a0
00144990 02202025 move       $a0, $s1
00144994 0C01AA82 jal        0x6aa08
00144998 00002825 move       $a1, $zero
0014499C 1040000B beqz       $v0, 0x1449cc
001449A0 00000000 nop        
001449A4 3C083DCC lui        $t0, 0x3dcc
001449A8 4600B346 mov.s      $f13, $f22
001449AC 3508CCCD ori        $t0, $t0, 0xcccd
001449B0 02202025 move       $a0, $s1
001449B4 44886000 mtc1       $t0, $f12
001449B8 00002825 move       $a1, $zero
001449BC 00003025 move       $a2, $zero
001449C0 0C01AB54 jal        0x6ad50
001449C4 34070001 ori        $a3, $zero, 1
001449C8 A2200045 sb         $zero, 0x45($s1)
001449CC C60C0008 lwc1       $f12, 8($s0)
001449D0 46166032 c.eq.s     $f12, $f22
001449D4 00000000 nop        
001449D8 45010016 bc1t       0x144a34
001449DC 00000000 nop        
001449E0 AE000004 sw         $zero, 4($s0)
001449E4 8E04000C lw         $a0, 0xc($s0)
001449E8 1080000A beqz       $a0, 0x144a14
001449EC 00000000 nop        
001449F0 264400C0 addiu      $a0, $s2, 0xc0
001449F4 8C840014 lw         $a0, 0x14($a0)
001449F8 30842000 andi       $a0, $a0, 0x2000
001449FC 14800003 bnez       $a0, 0x144a0c
00144A00 00000000 nop        
00144A04 10000003 b          0x144a14
00144A08 AE00000C sw         $zero, 0xc($s0)
00144A0C 10000023 b          0x144a9c
00144A10 00000000 nop        
00144A14 46146301 sub.s      $f12, $f12, $f20
00144A18 4616603E c.le.s     $f12, $f22
00144A1C 00000000 nop        
00144A20 45000002 bc1f       0x144a2c
00144A24 E60C0008 swc1       $f12, 8($s0)
00144A28 E6160008 swc1       $f22, 8($s0)
00144A2C 1000001B b          0x144a9c
00144A30 00000000 nop        
00144A34 02402025 move       $a0, $s2
00144A38 0C016260 jal        0x58980
00144A3C 34050001 ori        $a1, $zero, 1
00144A40 AE020004 sw         $v0, 4($s0)
00144A44 0C00C41E jal        0x31078
00144A48 02402025 move       $a0, $s2
00144A4C 10400013 beqz       $v0, 0x144a9c
00144A50 00000000 nop        
00144A54 8E040004 lw         $a0, 4($s0)
00144A58 10800010 beqz       $a0, 0x144a9c
00144A5C 00000000 nop        
00144A60 27B10020 addiu      $s1, $sp, 0x20
00144A64 02202825 move       $a1, $s1
00144A68 34060001 ori        $a2, $zero, 1
00144A6C 0C01B0C6 jal        0x6c318
00144A70 00003825 move       $a3, $zero
00144A74 8E060004 lw         $a2, 4($s0)
00144A78 26100010 addiu      $s0, $s0, 0x10
00144A7C 02002025 move       $a0, $s0
00144A80 34050001 ori        $a1, $zero, 1
00144A84 0C0199E7 jal        0x6679c
00144A88 34070001 ori        $a3, $zero, 1
00144A8C 02002025 move       $a0, $s0
00144A90 02202825 move       $a1, $s1
00144A94 0C019A07 jal        0x6681c
00144A98 00003025 move       $a2, $zero
00144A9C C7B4002C lwc1       $f20, 0x2c($sp)
00144AA0 C7B60030 lwc1       $f22, 0x30($sp)
00144AA4 8FB00034 lw         $s0, 0x34($sp)
00144AA8 8FB10038 lw         $s1, 0x38($sp)
00144AAC 8FB2003C lw         $s2, 0x3c($sp)
00144AB0 8FBF0040 lw         $ra, 0x40($sp)
00144AB4 03E00008 jr         $ra
00144AB8 27BD0050 addiu      $sp, $sp, 0x50