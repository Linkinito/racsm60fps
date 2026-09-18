
CALLBACK 0x0015ED88 end 0x0015EF38 ordinal 0

0015ED88 27BDFFA0 addiu      $sp, $sp, -0x60
0015ED8C AFB00038 sw         $s0, 0x38($sp)
0015ED90 00808025 move       $s0, $a0
0015ED94 AFB1003C sw         $s1, 0x3c($sp)
0015ED98 8E110058 lw         $s1, 0x58($s0)
0015ED9C 34040002 ori        $a0, $zero, 2
0015EDA0 A2240012 sb         $a0, 0x12($s1)
0015EDA4 AE300014 sw         $s0, 0x14($s1)
0015EDA8 AE200018 sw         $zero, 0x18($s1)
0015EDAC AE200004 sw         $zero, 4($s1)
0015EDB0 92050044 lbu        $a1, 0x44($s0)
0015EDB4 8E040040 lw         $a0, 0x40($s0)
0015EDB8 00053900 sll        $a3, $a1, 4
0015EDBC 8E060064 lw         $a2, 0x64($s0)
0015EDC0 00A72821 addu       $a1, $a1, $a3
0015EDC4 8C880004 lw         $t0, 4($a0)
0015EDC8 00052880 sll        $a1, $a1, 2
0015EDCC 00A72823 subu       $a1, $a1, $a3
0015EDD0 AFB30044 sw         $s3, 0x44($sp)
0015EDD4 30D31420 andi       $s3, $a2, 0x1420
0015EDD8 01052821 addu       $a1, $t0, $a1
0015EDDC 24A6000C addiu      $a2, $a1, 0xc
0015EDE0 8CC70000 lw         $a3, ($a2)
0015EDE4 AFB20040 sw         $s2, 0x40($sp)
0015EDE8 AFB40048 sw         $s4, 0x48($sp)
0015EDEC AFB5004C sw         $s5, 0x4c($sp)
0015EDF0 36730001 ori        $s3, $s3, 1
0015EDF4 34120001 ori        $s2, $zero, 1
0015EDF8 27B40020 addiu      $s4, $sp, 0x20
0015EDFC 27B5002C addiu      $s5, $sp, 0x2c
0015EE00 AFBF0050 sw         $ra, 0x50($sp)
0015EE04 54E00001 bnel       $a3, $zero, 0x15ee0c
0015EE08 36730080 ori        $s3, $s3, 0x80
0015EE0C 8CC60004 lw         $a2, 4($a2)
0015EE10 54C00001 bnel       $a2, $zero, 0x15ee18
0015EE14 36730100 ori        $s3, $s3, 0x100
0015EE18 8CA50014 lw         $a1, 0x14($a1)
0015EE1C 54A00001 bnel       $a1, $zero, 0x15ee24
0015EE20 36730200 ori        $s3, $s3, 0x200
0015EE24 9084004B lbu        $a0, 0x4b($a0)
0015EE28 50920001 beql       $a0, $s2, 0x15ee30
0015EE2C 36730800 ori        $s3, $s3, 0x800
0015EE30 8E040064 lw         $a0, 0x64($s0)
0015EE34 30840008 andi       $a0, $a0, 8
0015EE38 54800001 bnel       $a0, $zero, 0x15ee40
0015EE3C 36730400 ori        $s3, $s3, 0x400
0015EE40 8E260014 lw         $a2, 0x14($s1)
0015EE44 36730010 ori        $s3, $s3, 0x10
0015EE48 02802025 move       $a0, $s4
0015EE4C 0C019E1E jal        0x67878
0015EE50 02A02825 move       $a1, $s5
0015EE54 50400020 beql       $v0, $zero, 0x15eed8
0015EE58 8E040064 lw         $a0, 0x64($s0)
0015EE5C C7AC002C lwc1       $f12, 0x2c($sp)
0015EE60 C7AD0020 lwc1       $f13, 0x20($sp)
0015EE64 C7AE0034 lwc1       $f14, 0x34($sp)
0015EE68 460D63C1 sub.s      $f15, $f12, $f13
0015EE6C 3C054100 lui        $a1, 0x4100
0015EE70 34040000 ori        $a0, $zero, 0
0015EE74 C7AC0028 lwc1       $f12, 0x28($sp)
0015EE78 44856800 mtc1       $a1, $f13
0015EE7C 460D783E c.le.s     $f15, $f13
0015EE80 00000000 nop        
0015EE84 45000005 bc1f       0x15ee9c
0015EE88 460C7301 sub.s      $f12, $f14, $f12
0015EE8C 460D603E c.le.s     $f12, $f13
0015EE90 00000000 nop        
0015EE94 45010003 bc1t       0x15eea4
0015EE98 00042900 sll        $a1, $a0, 4
0015EE9C 02402025 move       $a0, $s2
0015EEA0 00042900 sll        $a1, $a0, 4
0015EEA4 00A43023 subu       $a2, $a1, $a0
0015EEA8 A2240013 sb         $a0, 0x13($s1)
0015EEAC 000620C0 sll        $a0, $a2, 3
0015EEB0 00852023 subu       $a0, $a0, $a1
0015EEB4 3C050006 lui        $a1, 6
0015EEB8 24A5E2A8 addiu      $a1, $a1, -0x1d58
0015EEBC 00852021 addu       $a0, $a0, $a1
0015EEC0 26250004 addiu      $a1, $s1, 4
0015EEC4 02803025 move       $a2, $s4
0015EEC8 02A03825 move       $a3, $s5
0015EECC 0C020EB5 jal        0x83ad4
0015EED0 02604025 move       $t0, $s3
0015EED4 8E040064 lw         $a0, 0x64($s0)
0015EED8 3C05002A lui        $a1, 0x2a
0015EEDC 34841000 ori        $a0, $a0, 0x1000
0015EEE0 AE040064 sw         $a0, 0x64($s0)
0015EEE4 C4AC4F50 lwc1       $f12, 0x4f50($a1)
0015EEE8 3C04002A lui        $a0, 0x2a
0015EEEC E60C0070 swc1       $f12, 0x70($s0)
0015EEF0 C48C4F54 lwc1       $f12, 0x4f54($a0)
0015EEF4 3C043F00 lui        $a0, 0x3f00
0015EEF8 44846800 mtc1       $a0, $f13
0015EEFC 02401025 move       $v0, $s2
0015EF00 460D6302 mul.s      $f12, $f12, $f13
0015EF04 3C04437F lui        $a0, 0x437f
0015EF08 44847000 mtc1       $a0, $f14
0015EF0C E62E0020 swc1       $f14, 0x20($s1)
0015EF10 E62C001C swc1       $f12, 0x1c($s1)
0015EF14 8FB00038 lw         $s0, 0x38($sp)
0015EF18 8FB1003C lw         $s1, 0x3c($sp)
0015EF1C 8FB20040 lw         $s2, 0x40($sp)
0015EF20 8FB30044 lw         $s3, 0x44($sp)
0015EF24 8FB40048 lw         $s4, 0x48($sp)
0015EF28 8FB5004C lw         $s5, 0x4c($sp)
0015EF2C 8FBF0050 lw         $ra, 0x50($sp)
0015EF30 03E00008 jr         $ra
0015EF34 27BD0060 addiu      $sp, $sp, 0x60

CALLBACK 0x0015EF38 end 0x0015EF6C ordinal 1

0015EF38 8C850058 lw         $a1, 0x58($a0)
0015EF3C 8CA40018 lw         $a0, 0x18($a1)
0015EF40 10800008 beqz       $a0, 0x15ef64
0015EF44 00000000 nop        
0015EF48 8CA60004 lw         $a2, 4($a1)
0015EF4C 10C00004 beqz       $a2, 0x15ef60
0015EF50 AC860000 sw         $a2, ($a0)
0015EF54 8CA40018 lw         $a0, 0x18($a1)
0015EF58 8CA60004 lw         $a2, 4($a1)
0015EF5C ACC40014 sw         $a0, 0x14($a2)
0015EF60 ACA00018 sw         $zero, 0x18($a1)
0015EF64 03E00008 jr         $ra
0015EF68 00000000 nop        

CALLBACK 0x0015EF6C end 0x0015F214 ordinal 2

0015EF6C 27BDFFD0 addiu      $sp, $sp, -0x30
0015EF70 AFB00020 sw         $s0, 0x20($sp)
0015EF74 00808025 move       $s0, $a0
0015EF78 92050045 lbu        $a1, 0x45($s0)
0015EF7C 34040003 ori        $a0, $zero, 3
0015EF80 AFB10024 sw         $s1, 0x24($sp)
0015EF84 AFBF0028 sw         $ra, 0x28($sp)
0015EF88 10A40012 beq        $a1, $a0, 0x15efd4
0015EF8C 8E110058 lw         $s1, 0x58($s0)
0015EF90 C60C0070 lwc1       $f12, 0x70($s0)
0015EF94 44806800 mtc1       $zero, $f13
0015EF98 3C06BF80 lui        $a2, 0xbf80
0015EF9C 44867000 mtc1       $a2, $f14
0015EFA0 460E6300 add.s      $f12, $f12, $f14
0015EFA4 460D603E c.le.s     $f12, $f13
0015EFA8 00000000 nop        
0015EFAC 45000009 bc1f       0x15efd4
0015EFB0 E60C0070 swc1       $f12, 0x70($s0)
0015EFB4 8E040064 lw         $a0, 0x64($s0)
0015EFB8 2405FFFF addiu      $a1, $zero, -1
0015EFBC 34840040 ori        $a0, $a0, 0x40
0015EFC0 AE040064 sw         $a0, 0x64($s0)
0015EFC4 AE050068 sw         $a1, 0x68($s0)
0015EFC8 34040003 ori        $a0, $zero, 3
0015EFCC 1000002C b          0x15f080
0015EFD0 A2040045 sb         $a0, 0x45($s0)
0015EFD4 14A4002A bne        $a1, $a0, 0x15f080
0015EFD8 00000000 nop        
0015EFDC C62E0020 lwc1       $f14, 0x20($s1)
0015EFE0 44806800 mtc1       $zero, $f13
0015EFE4 460D7032 c.eq.s     $f14, $f13
0015EFE8 00000000 nop        
0015EFEC 4501001F bc1t       0x15f06c
0015EFF0 3C04002A lui        $a0, 0x2a
0015EFF4 C48C4F5C lwc1       $f12, 0x4f5c($a0)
0015EFF8 3C044F00 lui        $a0, 0x4f00
0015EFFC 460C7381 sub.s      $f14, $f14, $f12
0015F000 44846000 mtc1       $a0, $f12
0015F004 460D703C c.lt.s     $f14, $f13
0015F008 00000000 nop        
0015F00C 45000003 bc1f       0x15f01c
0015F010 E62E0020 swc1       $f14, 0x20($s1)
0015F014 E62D0020 swc1       $f13, 0x20($s1)
0015F018 46006B86 mov.s      $f14, $f13
0015F01C 8E040068 lw         $a0, 0x68($s0)
0015F020 460C703C c.lt.s     $f14, $f12
0015F024 3C050100 lui        $a1, 0x100
0015F028 24A5FFFF addiu      $a1, $a1, -1
0015F02C 45000006 bc1f       0x15f048
0015F030 00852024 and        $a0, $a0, $a1
0015F034 4600730D trunc.w.s  $f12, $f14
0015F038 44056000 mfc1       $a1, $f12
0015F03C 00052E00 sll        $a1, $a1, 0x18
0015F040 10000008 b          0x15f064
0015F044 00A42025 or         $a0, $a1, $a0
0015F048 460C7301 sub.s      $f12, $f14, $f12
0015F04C 3C058000 lui        $a1, 0x8000
0015F050 4600630D trunc.w.s  $f12, $f12
0015F054 44066000 mfc1       $a2, $f12
0015F058 00C52821 addu       $a1, $a2, $a1
0015F05C 00052E00 sll        $a1, $a1, 0x18
0015F060 00A42025 or         $a0, $a1, $a0
0015F064 10000006 b          0x15f080
0015F068 AE040068 sw         $a0, 0x68($s0)
0015F06C 02002025 move       $a0, $s0
0015F070 0C0192FF jal        0x64bfc
0015F074 34050001 ori        $a1, $zero, 1
0015F078 10000061 b          0x15f200
0015F07C 00000000 nop        
0015F080 8E250024 lw         $a1, 0x24($s1)
0015F084 10A00020 beqz       $a1, 0x15f108
0015F088 00000000 nop        
0015F08C 8CA40064 lw         $a0, 0x64($a1)
0015F090 30860001 andi       $a2, $a0, 1
0015F094 10C0000D beqz       $a2, 0x15f0cc
0015F098 30860006 andi       $a2, $a0, 6
0015F09C 14C0000B bnez       $a2, 0x15f0cc
0015F0A0 30840008 andi       $a0, $a0, 8
0015F0A4 14800009 bnez       $a0, 0x15f0cc
0015F0A8 00000000 nop        
0015F0AC 8CA40040 lw         $a0, 0x40($a1)
0015F0B0 8C840010 lw         $a0, 0x10($a0)
0015F0B4 8C84003C lw         $a0, 0x3c($a0)
0015F0B8 30840008 andi       $a0, $a0, 8
0015F0BC 1480000B bnez       $a0, 0x15f0ec
0015F0C0 00000000 nop        
0015F0C4 10000010 b          0x15f108
0015F0C8 00000000 nop        
0015F0CC 8E040064 lw         $a0, 0x64($s0)
0015F0D0 2405FFFF addiu      $a1, $zero, -1
0015F0D4 34840040 ori        $a0, $a0, 0x40
0015F0D8 AE040064 sw         $a0, 0x64($s0)
0015F0DC AE050068 sw         $a1, 0x68($s0)
0015F0E0 34040003 ori        $a0, $zero, 3
0015F0E4 10000046 b          0x15f200
0015F0E8 A2040045 sb         $a0, 0x45($s0)
0015F0EC 00A03025 move       $a2, $a1
0015F0F0 26250058 addiu      $a1, $s1, 0x58
0015F0F4 0C03BC37 jal        0xef0dc
0015F0F8 02002025 move       $a0, $s0
0015F0FC 8E250024 lw         $a1, 0x24($s1)
0015F100 0C03AB3E jal        0xeacf8
0015F104 26240028 addiu      $a0, $s1, 0x28
0015F108 C62C001C lwc1       $f12, 0x1c($s1)
0015F10C 44806800 mtc1       $zero, $f13
0015F110 3C04BF80 lui        $a0, 0xbf80
0015F114 44847000 mtc1       $a0, $f14
0015F118 460E6300 add.s      $f12, $f12, $f14
0015F11C 460D603E c.le.s     $f12, $f13
0015F120 00000000 nop        
0015F124 45000036 bc1f       0x15f200
0015F128 E62C001C swc1       $f12, 0x1c($s1)
0015F12C 3C04002A lui        $a0, 0x2a
0015F130 C48C4F54 lwc1       $f12, 0x4f54($a0)
0015F134 3C04002A lui        $a0, 0x2a
0015F138 E62C001C swc1       $f12, 0x1c($s1)
0015F13C C60C0010 lwc1       $f12, 0x10($s0)
0015F140 C48D4F58 lwc1       $f13, 0x4f58($a0)
0015F144 C60E0030 lwc1       $f14, 0x30($s0)
0015F148 C60F0014 lwc1       $f15, 0x14($s0)
0015F14C 460D6302 mul.s      $f12, $f12, $f13
0015F150 C6100034 lwc1       $f16, 0x34($s0)
0015F154 460D7BC2 mul.s      $f15, $f15, $f13
0015F158 C6110018 lwc1       $f17, 0x18($s0)
0015F15C C6120038 lwc1       $f18, 0x38($s0)
0015F160 460C7300 add.s      $f12, $f14, $f12
0015F164 92050045 lbu        $a1, 0x45($s0)
0015F168 460D8B42 mul.s      $f13, $f17, $f13
0015F16C 460F83C0 add.s      $f15, $f16, $f15
0015F170 E7AC0014 swc1       $f12, 0x14($sp)
0015F174 460D9300 add.s      $f12, $f18, $f13
0015F178 E7AF0018 swc1       $f15, 0x18($sp)
0015F17C 1CA0000B bgtz       $a1, 0x15f1ac
0015F180 E7AC001C swc1       $f12, 0x1c($sp)
0015F184 04A0001E bltz       $a1, 0x15f200
0015F188 00000000 nop        
0015F18C 27A40014 addiu      $a0, $sp, 0x14
0015F190 26050020 addiu      $a1, $s0, 0x20
0015F194 34110001 ori        $s1, $zero, 1
0015F198 34060001 ori        $a2, $zero, 1
0015F19C 0C04813C jal        0x1204f0
0015F1A0 00003825 move       $a3, $zero
0015F1A4 10000016 b          0x15f200
0015F1A8 A2110045 sb         $s1, 0x45($s0)
0015F1AC 28A40002 slti       $a0, $a1, 2
0015F1B0 14800005 bnez       $a0, 0x15f1c8
0015F1B4 28A40003 slti       $a0, $a1, 3
0015F1B8 1480000B bnez       $a0, 0x15f1e8
0015F1BC 00000000 nop        
0015F1C0 1000000F b          0x15f200
0015F1C4 00000000 nop        
0015F1C8 27A40014 addiu      $a0, $sp, 0x14
0015F1CC 26050020 addiu      $a1, $s0, 0x20
0015F1D0 34110002 ori        $s1, $zero, 2
0015F1D4 34060002 ori        $a2, $zero, 2
0015F1D8 0C04813C jal        0x1204f0
0015F1DC 00003825 move       $a3, $zero
0015F1E0 10000007 b          0x15f200
0015F1E4 A2110045 sb         $s1, 0x45($s0)
0015F1E8 27A40014 addiu      $a0, $sp, 0x14
0015F1EC 26050020 addiu      $a1, $s0, 0x20
0015F1F0 34060003 ori        $a2, $zero, 3
0015F1F4 0C04813C jal        0x1204f0
0015F1F8 00003825 move       $a3, $zero
0015F1FC A2000045 sb         $zero, 0x45($s0)
0015F200 8FB00020 lw         $s0, 0x20($sp)
0015F204 8FB10024 lw         $s1, 0x24($sp)
0015F208 8FBF0028 lw         $ra, 0x28($sp)
0015F20C 03E00008 jr         $ra
0015F210 27BD0030 addiu      $sp, $sp, 0x30