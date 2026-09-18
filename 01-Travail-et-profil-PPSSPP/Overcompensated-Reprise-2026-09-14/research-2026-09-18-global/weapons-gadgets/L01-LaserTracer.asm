
CALLBACK 0x00148A70 end 0x00148B64 ordinal 0

00148A70 27BDFFD0 addiu      $sp, $sp, -0x30
00148A74 AFB00020 sw         $s0, 0x20($sp)
00148A78 AFB10024 sw         $s1, 0x24($sp)
00148A7C AFB20028 sw         $s2, 0x28($sp)
00148A80 AFBF002C sw         $ra, 0x2c($sp)
00148A84 00808025 move       $s0, $a0
00148A88 0C05221F jal        0x14887c
00148A8C 00000000 nop        
00148A90 8E110058 lw         $s1, 0x58($s0)
00148A94 A220000D sb         $zero, 0xd($s1)
00148A98 3C04002B lui        $a0, 0x2b
00148A9C 8C8500C0 lw         $a1, 0xc0($a0)
00148AA0 AE250000 sw         $a1, ($s1)
00148AA4 3C05002D lui        $a1, 0x2d
00148AA8 C4AC2C4C lwc1       $f12, 0x2c4c($a1)
00148AAC E62C0008 swc1       $f12, 8($s1)
00148AB0 8C9200C0 lw         $s2, 0xc0($a0)
00148AB4 26040074 addiu      $a0, $s0, 0x74
00148AB8 8E4600F0 lw         $a2, 0xf0($s2)
00148ABC 3405000B ori        $a1, $zero, 0xb
00148AC0 0C0077E7 jal        0x1df9c
00148AC4 2407FFFF addiu      $a3, $zero, -1
00148AC8 3C040015 lui        $a0, 0x15
00148ACC 2484C474 addiu      $a0, $a0, -0x3b8c
00148AD0 8E050048 lw         $a1, 0x48($s0)
00148AD4 ACA400DC sw         $a0, 0xdc($a1)
00148AD8 3C05002D lui        $a1, 0x2d
00148ADC 24A52C28 addiu      $a1, $a1, 0x2c28
00148AE0 3C06002D lui        $a2, 0x2d
00148AE4 24C62C10 addiu      $a2, $a2, 0x2c10
00148AE8 3C04002D lui        $a0, 0x2d
00148AEC C48C2C34 lwc1       $f12, 0x2c34($a0)
00148AF0 3C04002D lui        $a0, 0x2d
00148AF4 C48D2C38 lwc1       $f13, 0x2c38($a0)
00148AF8 3C04002D lui        $a0, 0x2d
00148AFC C48E2C3C lwc1       $f14, 0x2c3c($a0)
00148B00 02402025 move       $a0, $s2
00148B04 0C01707F jal        0x5c1fc
00148B08 34070001 ori        $a3, $zero, 1
00148B0C 26240230 addiu      $a0, $s1, 0x230
00148B10 3C05002D lui        $a1, 0x2d
00148B14 24B23F4C addiu      $s2, $a1, 0x3f4c
00148B18 26260198 addiu      $a2, $s1, 0x198
00148B1C 0C0689BA jal        0x1a26e8
00148B20 02402825 move       $a1, $s2
00148B24 262401C8 addiu      $a0, $s1, 0x1c8
00148B28 0C0689E7 jal        0x1a279c
00148B2C 02402825 move       $a1, $s2
00148B30 0C051713 jal        0x145c4c
00148B34 26240044 addiu      $a0, $s1, 0x44
00148B38 0C0514AB jal        0x1452ac
00148B3C 02002025 move       $a0, $s0
00148B40 0C052271 jal        0x1489c4
00148B44 02002025 move       $a0, $s0
00148B48 34020001 ori        $v0, $zero, 1
00148B4C 8FB00020 lw         $s0, 0x20($sp)
00148B50 8FB10024 lw         $s1, 0x24($sp)
00148B54 8FB20028 lw         $s2, 0x28($sp)
00148B58 8FBF002C lw         $ra, 0x2c($sp)
00148B5C 03E00008 jr         $ra
00148B60 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x00148B64 end 0x00148C50 ordinal 1

00148B64 27BDFFD0 addiu      $sp, $sp, -0x30
00148B68 AFB00010 sw         $s0, 0x10($sp)
00148B6C AFB10014 sw         $s1, 0x14($sp)
00148B70 AFB20018 sw         $s2, 0x18($sp)
00148B74 AFB3001C sw         $s3, 0x1c($sp)
00148B78 AFBF0020 sw         $ra, 0x20($sp)
00148B7C 00808025 move       $s0, $a0
00148B80 8E110058 lw         $s1, 0x58($s0)
00148B84 8E320000 lw         $s2, ($s1)
00148B88 8E4500F0 lw         $a1, 0xf0($s2)
00148B8C 0C007DC7 jal        0x1f71c
00148B90 3404000B ori        $a0, $zero, 0xb
00148B94 8C44003C lw         $a0, 0x3c($v0)
00148B98 34050003 ori        $a1, $zero, 3
00148B9C 0085202D .byte      0x2d, 0x20, 0x85, 0x00
00148BA0 00042100 sll        $a0, $a0, 4
00148BA4 00042821 addu       $a1, $zero, $a0
00148BA8 00042080 sll        $a0, $a0, 2
00148BAC 00A42821 addu       $a1, $a1, $a0
00148BB0 000420C0 sll        $a0, $a0, 3
00148BB4 00A42021 addu       $a0, $a1, $a0
00148BB8 3C05002D lui        $a1, 0x2d
00148BBC 24A5360C addiu      $a1, $a1, 0x360c
00148BC0 00859821 addu       $s3, $a0, $a1
00148BC4 8E240000 lw         $a0, ($s1)
00148BC8 0C0170A4 jal        0x5c290
00148BCC 00002825 move       $a1, $zero
00148BD0 02002025 move       $a0, $s0
00148BD4 0C0521E8 jal        0x1487a0
00148BD8 02602825 move       $a1, $s3
00148BDC 0C051DB3 jal        0x1476cc
00148BE0 02002025 move       $a0, $s0
00148BE4 8E040058 lw         $a0, 0x58($s0)
00148BE8 8C850000 lw         $a1, ($a0)
00148BEC A080001C sb         $zero, 0x1c($a0)
00148BF0 44806000 mtc1       $zero, $f12
00148BF4 E48C0034 swc1       $f12, 0x34($a0)
00148BF8 E48C0040 swc1       $f12, 0x40($a0)
00148BFC 3C040004 lui        $a0, 4
00148C00 24848C74 addiu      $a0, $a0, -0x738c
00148C04 8CA50594 lw         $a1, 0x594($a1)
00148C08 8CA50048 lw         $a1, 0x48($a1)
00148C0C ACA400E0 sw         $a0, 0xe0($a1)
00148C10 8E040048 lw         $a0, 0x48($s0)
00148C14 AC8000DC sw         $zero, 0xdc($a0)
00148C18 AE400FA4 sw         $zero, 0xfa4($s2)
00148C1C 0C0689D5 jal        0x1a2754
00148C20 26240230 addiu      $a0, $s1, 0x230
00148C24 0C051737 jal        0x145cdc
00148C28 26240044 addiu      $a0, $s1, 0x44
00148C2C 0C0514B3 jal        0x1452cc
00148C30 02002025 move       $a0, $s0
00148C34 8FB00010 lw         $s0, 0x10($sp)
00148C38 8FB10014 lw         $s1, 0x14($sp)
00148C3C 8FB20018 lw         $s2, 0x18($sp)
00148C40 8FB3001C lw         $s3, 0x1c($sp)
00148C44 8FBF0020 lw         $ra, 0x20($sp)
00148C48 03E00008 jr         $ra
00148C4C 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x00148CEC end 0x00149014 ordinal 2

00148CEC 27BDFFC0 addiu      $sp, $sp, -0x40
00148CF0 E7B40010 swc1       $f20, 0x10($sp)
00148CF4 E7B60014 swc1       $f22, 0x14($sp)
00148CF8 E7B80018 swc1       $f24, 0x18($sp)
00148CFC E7BA001C swc1       $f26, 0x1c($sp)
00148D00 E7BC0020 swc1       $f28, 0x20($sp)
00148D04 E7BE0024 swc1       $f30, 0x24($sp)
00148D08 AFB00028 sw         $s0, 0x28($sp)
00148D0C AFB1002C sw         $s1, 0x2c($sp)
00148D10 AFB20030 sw         $s2, 0x30($sp)
00148D14 AFB30034 sw         $s3, 0x34($sp)
00148D18 AFB40038 sw         $s4, 0x38($sp)
00148D1C AFBF003C sw         $ra, 0x3c($sp)
00148D20 00808025 move       $s0, $a0
00148D24 8E110058 lw         $s1, 0x58($s0)
00148D28 8E320000 lw         $s2, ($s1)
00148D2C 9224000D lbu        $a0, 0xd($s1)
00148D30 10800011 beqz       $a0, 0x148d78
00148D34 00000000 nop        
00148D38 8E45095C lw         $a1, 0x95c($s2)
00148D3C 3C06FFFE lui        $a2, 0xfffe
00148D40 24C6FFFF addiu      $a2, $a2, -1
00148D44 00A62824 and        $a1, $a1, $a2
00148D48 30840001 andi       $a0, $a0, 1
00148D4C 00042440 sll        $a0, $a0, 0x11
00148D50 00A42025 or         $a0, $a1, $a0
00148D54 AE44095C sw         $a0, 0x95c($s2)
00148D58 264402A8 addiu      $a0, $s2, 0x2a8
00148D5C 26250010 addiu      $a1, $s1, 0x10
00148D60 8CA60000 lw         $a2, ($a1)
00148D64 8CA70004 lw         $a3, 4($a1)
00148D68 8CA50008 lw         $a1, 8($a1)
00148D6C AC860000 sw         $a2, ($a0)
00148D70 AC870004 sw         $a3, 4($a0)
00148D74 AC850008 sw         $a1, 8($a0)
00148D78 3C04002B lui        $a0, 0x2b
00148D7C 90840208 lbu        $a0, 0x208($a0)
00148D80 10800027 beqz       $a0, 0x148e20
00148D84 00000000 nop        
00148D88 A220000D sb         $zero, 0xd($s1)
00148D8C 02002025 move       $a0, $s0
00148D90 0C052314 jal        0x148c50
00148D94 02402825 move       $a1, $s2
00148D98 8E4500F0 lw         $a1, 0xf0($s2)
00148D9C 0C007DC7 jal        0x1f71c
00148DA0 3404000B ori        $a0, $zero, 0xb
00148DA4 8C44003C lw         $a0, 0x3c($v0)
00148DA8 34050003 ori        $a1, $zero, 3
00148DAC 0085202D .byte      0x2d, 0x20, 0x85, 0x00
00148DB0 00042100 sll        $a0, $a0, 4
00148DB4 00042821 addu       $a1, $zero, $a0
00148DB8 00042080 sll        $a0, $a0, 2
00148DBC 00A42821 addu       $a1, $a1, $a0
00148DC0 000420C0 sll        $a0, $a0, 3
00148DC4 00A49821 addu       $s3, $a1, $a0
00148DC8 3C04002D lui        $a0, 0x2d
00148DCC 2484360C addiu      $a0, $a0, 0x360c
00148DD0 02649821 addu       $s3, $s3, $a0
00148DD4 3C040019 lui        $a0, 0x19
00148DD8 2484E568 addiu      $a0, $a0, -0x1a98
00148DDC 24840050 addiu      $a0, $a0, 0x50
00148DE0 0C064EBC jal        0x193af0
00148DE4 26650124 addiu      $a1, $s3, 0x124
00148DE8 3C050015 lui        $a1, 0x15
00148DEC 24A58970 addiu      $a1, $a1, -0x7690
00148DF0 0C0170A4 jal        0x5c290
00148DF4 02402025 move       $a0, $s2
00148DF8 C62C0008 lwc1       $f12, 8($s1)
00148DFC 3C043F80 lui        $a0, 0x3f80
00148E00 4484A000 mtc1       $a0, $f20
00148E04 46146301 sub.s      $f12, $f12, $f20
00148E08 E62C0008 swc1       $f12, 8($s1)
00148E0C 92040046 lbu        $a0, 0x46($s0)
00148E10 14800005 bnez       $a0, 0x148e28
00148E14 00000000 nop        
00148E18 10000005 b          0x148e30
00148E1C 00000000 nop        
00148E20 1000006E b          0x148fdc
00148E24 00000000 nop        
00148E28 0C016FD5 jal        0x5bf54
00148E2C 02402025 move       $a0, $s2
00148E30 A220000C sb         $zero, 0xc($s1)
00148E34 02002025 move       $a0, $s0
00148E38 0C0520F0 jal        0x1483c0
00148E3C 02602825 move       $a1, $s3
00148E40 92040046 lbu        $a0, 0x46($s0)
00148E44 10800006 beqz       $a0, 0x148e60
00148E48 34140000 ori        $s4, $zero, 0
00148E4C 0C016FD5 jal        0x5bf54
00148E50 02402025 move       $a0, $s2
00148E54 14400003 bnez       $v0, 0x148e64
00148E58 328400FF andi       $a0, $s4, 0xff
00148E5C 34140001 ori        $s4, $zero, 1
00148E60 328400FF andi       $a0, $s4, 0xff
00148E64 308500FF andi       $a1, $a0, 0xff
00148E68 8E140058 lw         $s4, 0x58($s0)
00148E6C 10A00007 beqz       $a1, 0x148e8c
00148E70 8E840000 lw         $a0, ($s4)
00148E74 3C050014 lui        $a1, 0x14
00148E78 24A57370 addiu      $a1, $a1, 0x7370
00148E7C 8C840594 lw         $a0, 0x594($a0)
00148E80 8C840048 lw         $a0, 0x48($a0)
00148E84 1000000A b          0x148eb0
00148E88 AC8500E0 sw         $a1, 0xe0($a0)
00148E8C A280001C sb         $zero, 0x1c($s4)
00148E90 44806000 mtc1       $zero, $f12
00148E94 E68C0034 swc1       $f12, 0x34($s4)
00148E98 E68C0040 swc1       $f12, 0x40($s4)
00148E9C 3C050004 lui        $a1, 4
00148EA0 24A58C74 addiu      $a1, $a1, -0x738c
00148EA4 8C840594 lw         $a0, 0x594($a0)
00148EA8 8C840048 lw         $a0, 0x48($a0)
00148EAC AC8500E0 sw         $a1, 0xe0($a0)
00148EB0 26250044 addiu      $a1, $s1, 0x44
00148EB4 02002025 move       $a0, $s0
00148EB8 0C051971 jal        0x1465c4
00148EBC 02603025 move       $a2, $s3
00148EC0 02202025 move       $a0, $s1
00148EC4 0C051AD5 jal        0x146b54
00148EC8 02602825 move       $a1, $s3
00148ECC 9224001C lbu        $a0, 0x1c($s1)
00148ED0 10800040 beqz       $a0, 0x148fd4
00148ED4 00000000 nop        
00148ED8 3C04002D lui        $a0, 0x2d
00148EDC C48C2CA0 lwc1       $f12, 0x2ca0($a0)
00148EE0 3C04002D lui        $a0, 0x2d
00148EE4 C48D2CA4 lwc1       $f13, 0x2ca4($a0)
00148EE8 C62E0034 lwc1       $f14, 0x34($s1)
00148EEC C62F002C lwc1       $f15, 0x2c($s1)
00148EF0 460E7BC1 sub.s      $f15, $f15, $f14
00148EF4 C6300030 lwc1       $f16, 0x30($s1)
00148EF8 460C7C42 mul.s      $f17, $f15, $f12
00148EFC 46118400 add.s      $f16, $f16, $f17
00148F00 460D8402 mul.s      $f16, $f16, $f13
00148F04 460D7B42 mul.s      $f13, $f15, $f13
00148F08 460D8340 add.s      $f13, $f16, $f13
00148F0C 460C6B02 mul.s      $f12, $f13, $f12
00148F10 460C8301 sub.s      $f12, $f16, $f12
00148F14 E62C0030 swc1       $f12, 0x30($s1)
00148F18 460E6F80 add.s      $f30, $f13, $f14
00148F1C E63E002C swc1       $f30, 0x2c($s1)
00148F20 3C04002D lui        $a0, 0x2d
00148F24 C48C2CA8 lwc1       $f12, 0x2ca8($a0)
00148F28 3C04002D lui        $a0, 0x2d
00148F2C C48F2CAC lwc1       $f15, 0x2cac($a0)
00148F30 C6380040 lwc1       $f24, 0x40($s1)
00148F34 C62D0038 lwc1       $f13, 0x38($s1)
00148F38 46186B41 sub.s      $f13, $f13, $f24
00148F3C C62E003C lwc1       $f14, 0x3c($s1)
00148F40 460C6C02 mul.s      $f16, $f13, $f12
00148F44 46107380 add.s      $f14, $f14, $f16
00148F48 460F7382 mul.s      $f14, $f14, $f15
00148F4C 460F6B42 mul.s      $f13, $f13, $f15
00148F50 460D7340 add.s      $f13, $f14, $f13
00148F54 460C6B02 mul.s      $f12, $f13, $f12
00148F58 460C7301 sub.s      $f12, $f14, $f12
00148F5C E62C003C swc1       $f12, 0x3c($s1)
00148F60 46186E00 add.s      $f24, $f13, $f24
00148F64 E6380038 swc1       $f24, 0x38($s1)
00148F68 0C06D6C8 jal        0x1b5b20
00148F6C 4600F306 mov.s      $f12, $f30
00148F70 46000686 mov.s      $f26, $f0
00148F74 461AD302 mul.s      $f12, $f26, $f26
00148F78 460CA701 sub.s      $f28, $f20, $f12
00148F7C 4600E704 sqrt.s     $f28, $f28
00148F80 4480B000 mtc1       $zero, $f22
00148F84 4616F03C c.lt.s     $f30, $f22
00148F88 00000000 nop        
00148F8C 45030001 bc1tl      0x148f94
00148F90 4600E707 neg.s      $f28, $f28
00148F94 0C06D6C8 jal        0x1b5b20
00148F98 4600C306 mov.s      $f12, $f24
00148F9C 46000306 mov.s      $f12, $f0
00148FA0 460C6342 mul.s      $f13, $f12, $f12
00148FA4 460DA501 sub.s      $f20, $f20, $f13
00148FA8 4600A504 sqrt.s     $f20, $f20
00148FAC 4616C03C c.lt.s     $f24, $f22
00148FB0 00000000 nop        
00148FB4 45030001 bc1tl      0x148fbc
00148FB8 4600A507 neg.s      $f20, $f20
00148FBC 461C6342 mul.s      $f13, $f12, $f28
00148FC0 E62D0020 swc1       $f13, 0x20($s1)
00148FC4 4600A347 neg.s      $f13, $f20
00148FC8 E62D0024 swc1       $f13, 0x24($s1)
00148FCC 461A6302 mul.s      $f12, $f12, $f26
00148FD0 E62C0028 swc1       $f12, 0x28($s1)
00148FD4 0C0514BB jal        0x1452ec
00148FD8 02002025 move       $a0, $s0
00148FDC C7B40010 lwc1       $f20, 0x10($sp)
00148FE0 C7B60014 lwc1       $f22, 0x14($sp)
00148FE4 C7B80018 lwc1       $f24, 0x18($sp)
00148FE8 C7BA001C lwc1       $f26, 0x1c($sp)
00148FEC C7BC0020 lwc1       $f28, 0x20($sp)
00148FF0 C7BE0024 lwc1       $f30, 0x24($sp)
00148FF4 8FB00028 lw         $s0, 0x28($sp)
00148FF8 8FB1002C lw         $s1, 0x2c($sp)
00148FFC 8FB20030 lw         $s2, 0x30($sp)
00149000 8FB30034 lw         $s3, 0x34($sp)
00149004 8FB40038 lw         $s4, 0x38($sp)
00149008 8FBF003C lw         $ra, 0x3c($sp)
0014900C 03E00008 jr         $ra
00149010 27BD0040 addiu      $sp, $sp, 0x40