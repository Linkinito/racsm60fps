
CALLBACK 0x0016F57C end 0x0016F668 ordinal 0

0016F57C 27BDFFC0 addiu      $sp, $sp, -0x40
0016F580 AFB00020 sw         $s0, 0x20($sp)
0016F584 00808025 move       $s0, $a0
0016F588 AFB10024 sw         $s1, 0x24($sp)
0016F58C AFB20028 sw         $s2, 0x28($sp)
0016F590 AFB3002C sw         $s3, 0x2c($sp)
0016F594 AFB40030 sw         $s4, 0x30($sp)
0016F598 AFBF0034 sw         $ra, 0x34($sp)
0016F59C 8E140058 lw         $s4, 0x58($s0)
0016F5A0 3C11002B lui        $s1, 0x2b
0016F5A4 AE800000 sw         $zero, ($s4)
0016F5A8 34130000 ori        $s3, $zero, 0
0016F5AC 263128D8 addiu      $s1, $s1, 0x28d8
0016F5B0 26920020 addiu      $s2, $s4, 0x20
0016F5B4 02402025 move       $a0, $s2
0016F5B8 00002825 move       $a1, $zero
0016F5BC 34060044 ori        $a2, $zero, 0x44
0016F5C0 34070045 ori        $a3, $zero, 0x45
0016F5C4 0C019B8F jal        0x66e3c
0016F5C8 02204025 move       $t0, $s1
0016F5CC 26730001 addiu      $s3, $s3, 1
0016F5D0 2E640004 sltiu      $a0, $s3, 4
0016F5D4 1480FFF7 bnez       $a0, 0x16f5b4
0016F5D8 26520028 addiu      $s2, $s2, 0x28
0016F5DC 44806000 mtc1       $zero, $f12
0016F5E0 AE80001C sw         $zero, 0x1c($s4)
0016F5E4 E68C0010 swc1       $f12, 0x10($s4)
0016F5E8 A28000C0 sb         $zero, 0xc0($s4)
0016F5EC AE800014 sw         $zero, 0x14($s4)
0016F5F0 E68C0018 swc1       $f12, 0x18($s4)
0016F5F4 3C11002B lui        $s1, 0x2b
0016F5F8 8E2400C0 lw         $a0, 0xc0($s1)
0016F5FC 3C05002D lui        $a1, 0x2d
0016F600 C4AC73E4 lwc1       $f12, 0x73e4($a1)
0016F604 3C05002D lui        $a1, 0x2d
0016F608 C4AD73E8 lwc1       $f13, 0x73e8($a1)
0016F60C 3C05002D lui        $a1, 0x2d
0016F610 C4AE73EC lwc1       $f14, 0x73ec($a1)
0016F614 3C05002D lui        $a1, 0x2d
0016F618 3C06002D lui        $a2, 0x2d
0016F61C 34070001 ori        $a3, $zero, 1
0016F620 24A573D8 addiu      $a1, $a1, 0x73d8
0016F624 0C01707F jal        0x5c1fc
0016F628 24C67364 addiu      $a2, $a2, 0x7364
0016F62C 8E2500C0 lw         $a1, 0xc0($s1)
0016F630 26040074 addiu      $a0, $s0, 0x74
0016F634 8CA600F0 lw         $a2, 0xf0($a1)
0016F638 34050008 ori        $a1, $zero, 8
0016F63C 0C0077E7 jal        0x1df9c
0016F640 2407FFFF addiu      $a3, $zero, -1
0016F644 34020001 ori        $v0, $zero, 1
0016F648 8FB00020 lw         $s0, 0x20($sp)
0016F64C 8FB10024 lw         $s1, 0x24($sp)
0016F650 8FB20028 lw         $s2, 0x28($sp)
0016F654 8FB3002C lw         $s3, 0x2c($sp)
0016F658 8FB40030 lw         $s4, 0x30($sp)
0016F65C 8FBF0034 lw         $ra, 0x34($sp)
0016F660 03E00008 jr         $ra
0016F664 27BD0040 addiu      $sp, $sp, 0x40

CALLBACK 0x0016F668 end 0x0016F670 ordinal 1

0016F668 03E00008 jr         $ra
0016F66C 00000000 nop        

CALLBACK 0x0016F954 end 0x00170188 ordinal 2

0016F954 27BDFEF0 addiu      $sp, $sp, -0x110
0016F958 AFB100E4 sw         $s1, 0xe4($sp)
0016F95C 00808825 move       $s1, $a0
0016F960 3C04002B lui        $a0, 0x2b
0016F964 8C8400C0 lw         $a0, 0xc0($a0)
0016F968 3C05002D lui        $a1, 0x2d
0016F96C C4AC73E4 lwc1       $f12, 0x73e4($a1)
0016F970 3C05002D lui        $a1, 0x2d
0016F974 C4AD73E8 lwc1       $f13, 0x73e8($a1)
0016F978 AFB000E0 sw         $s0, 0xe0($sp)
0016F97C 3C05002D lui        $a1, 0x2d
0016F980 3C10002D lui        $s0, 0x2d
0016F984 C4AE73EC lwc1       $f14, 0x73ec($a1)
0016F988 26107364 addiu      $s0, $s0, 0x7364
0016F98C 3C05002D lui        $a1, 0x2d
0016F990 02003025 move       $a2, $s0
0016F994 34070001 ori        $a3, $zero, 1
0016F998 E7B400D4 swc1       $f20, 0xd4($sp)
0016F99C E7B600D8 swc1       $f22, 0xd8($sp)
0016F9A0 E7B800DC swc1       $f24, 0xdc($sp)
0016F9A4 AFB200E8 sw         $s2, 0xe8($sp)
0016F9A8 AFB300EC sw         $s3, 0xec($sp)
0016F9AC AFB400F0 sw         $s4, 0xf0($sp)
0016F9B0 AFB500F4 sw         $s5, 0xf4($sp)
0016F9B4 AFB600F8 sw         $s6, 0xf8($sp)
0016F9B8 AFB700FC sw         $s7, 0xfc($sp)
0016F9BC AFBE0100 sw         $fp, 0x100($sp)
0016F9C0 AFBF0104 sw         $ra, 0x104($sp)
0016F9C4 0C01707F jal        0x5c1fc
0016F9C8 24A573D8 addiu      $a1, $a1, 0x73d8
0016F9CC 8E3E0058 lw         $fp, 0x58($s1)
0016F9D0 34040008 ori        $a0, $zero, 8
0016F9D4 8FD30000 lw         $s3, ($fp)
0016F9D8 0C007DC7 jal        0x1f71c
0016F9DC 8E6500F0 lw         $a1, 0xf0($s3)
0016F9E0 926409E4 lbu        $a0, 0x9e4($s3)
0016F9E4 3C053F80 lui        $a1, 0x3f80
0016F9E8 4480B000 mtc1       $zero, $f22
0016F9EC 27D40004 addiu      $s4, $fp, 4
0016F9F0 4485A000 mtc1       $a1, $f20
0016F9F4 10800022 beqz       $a0, 0x16fa80
0016F9F8 27B50048 addiu      $s5, $sp, 0x48
0016F9FC C66C09E8 lwc1       $f12, 0x9e8($s3)
0016FA00 3C043CA3 lui        $a0, 0x3ca3
0016FA04 E7CC0004 swc1       $f12, 4($fp)
0016FA08 C66C09EC lwc1       $f12, 0x9ec($s3)
0016FA0C 3484D70A ori        $a0, $a0, 0xd70a
0016FA10 E7CC0008 swc1       $f12, 8($fp)
0016FA14 44846800 mtc1       $a0, $f13
0016FA18 C66C09F0 lwc1       $f12, 0x9f0($s3)
0016FA1C E7CC000C swc1       $f12, 0xc($fp)
0016FA20 C66C09F4 lwc1       $f12, 0x9f4($s3)
0016FA24 460D6302 mul.s      $f12, $f12, $f13
0016FA28 E7AC0058 swc1       $f12, 0x58($sp)
0016FA2C C66E09F8 lwc1       $f14, 0x9f8($s3)
0016FA30 460D7382 mul.s      $f14, $f14, $f13
0016FA34 E7AE005C swc1       $f14, 0x5c($sp)
0016FA38 C66E09FC lwc1       $f14, 0x9fc($s3)
0016FA3C 460D7342 mul.s      $f13, $f14, $f13
0016FA40 E7AD0060 swc1       $f13, 0x60($sp)
0016FA44 C7CD0004 lwc1       $f13, 4($fp)
0016FA48 C7CF0008 lwc1       $f15, 8($fp)
0016FA4C 460C6B00 add.s      $f12, $f13, $f12
0016FA50 C7D0000C lwc1       $f16, 0xc($fp)
0016FA54 C7D10010 lwc1       $f17, 0x10($fp)
0016FA58 E7CC0004 swc1       $f12, 4($fp)
0016FA5C C7AC005C lwc1       $f12, 0x5c($sp)
0016FA60 8FD00014 lw         $s0, 0x14($fp)
0016FA64 460C7B80 add.s      $f14, $f15, $f12
0016FA68 E7CE0008 swc1       $f14, 8($fp)
0016FA6C 46148B01 sub.s      $f12, $f17, $f20
0016FA70 C7AD0060 lwc1       $f13, 0x60($sp)
0016FA74 460D8340 add.s      $f13, $f16, $f13
0016FA78 10000008 b          0x16fa9c
0016FA7C E7CD000C swc1       $f13, 0xc($fp)
0016FA80 02802025 move       $a0, $s4
0016FA84 02202825 move       $a1, $s1
0016FA88 0C03D4B1 jal        0xf52c4
0016FA8C 02003025 move       $a2, $s0
0016FA90 C7CC0010 lwc1       $f12, 0x10($fp)
0016FA94 8FD00014 lw         $s0, 0x14($fp)
0016FA98 46146301 sub.s      $f12, $f12, $f20
0016FA9C 4616603C c.lt.s     $f12, $f22
0016FAA0 00000000 nop        
0016FAA4 45000002 bc1f       0x16fab0
0016FAA8 E7CC0010 swc1       $f12, 0x10($fp)
0016FAAC E7D60010 swc1       $f22, 0x10($fp)
0016FAB0 34040003 ori        $a0, $zero, 3
0016FAB4 16040013 bne        $s0, $a0, 0x16fb04
0016FAB8 AFB100C8 sw         $s1, 0xc8($sp)
0016FABC AFB100C8 sw         $s1, 0xc8($sp)
0016FAC0 02202025 move       $a0, $s1
0016FAC4 0C01AA82 jal        0x6aa08
0016FAC8 00002825 move       $a1, $zero
0016FACC 1040000D beqz       $v0, 0x16fb04
0016FAD0 00000000 nop        
0016FAD4 AFB100C8 sw         $s1, 0xc8($sp)
0016FAD8 4600B346 mov.s      $f13, $f22
0016FADC 3C083DCC lui        $t0, 0x3dcc
0016FAE0 A2200045 sb         $zero, 0x45($s1)
0016FAE4 3508CCCD ori        $t0, $t0, 0xcccd
0016FAE8 AFC00014 sw         $zero, 0x14($fp)
0016FAEC 44886000 mtc1       $t0, $f12
0016FAF0 02202025 move       $a0, $s1
0016FAF4 00002825 move       $a1, $zero
0016FAF8 00003025 move       $a2, $zero
0016FAFC 0C01AB54 jal        0x6ad50
0016FB00 34070001 ori        $a3, $zero, 1
0016FB04 8E6600F0 lw         $a2, 0xf0($s3)
0016FB08 34040008 ori        $a0, $zero, 8
0016FB0C 0C007F68 jal        0x1fda0
0016FB10 34050014 ori        $a1, $zero, 0x14
0016FB14 34100001 ori        $s0, $zero, 1
0016FB18 10400017 beqz       $v0, 0x16fb78
0016FB1C A3A200CC sb         $v0, 0xcc($sp)
0016FB20 C7CC0018 lwc1       $f12, 0x18($fp)
0016FB24 34040001 ori        $a0, $zero, 1
0016FB28 4600630D trunc.w.s  $f12, $f12
0016FB2C AFA40068 sw         $a0, 0x68($sp)
0016FB30 34050004 ori        $a1, $zero, 4
0016FB34 AFA5006C sw         $a1, 0x6c($sp)
0016FB38 44046000 mfc1       $a0, $f12
0016FB3C 24840001 addiu      $a0, $a0, 1
0016FB40 28850001 slti       $a1, $a0, 1
0016FB44 10A00004 beqz       $a1, 0x16fb58
0016FB48 AFA40064 sw         $a0, 0x64($sp)
0016FB4C 27A40068 addiu      $a0, $sp, 0x68
0016FB50 10000008 b          0x16fb74
0016FB54 8C840000 lw         $a0, ($a0)
0016FB58 8FA5006C lw         $a1, 0x6c($sp)
0016FB5C 00A4202A slt        $a0, $a1, $a0
0016FB60 10800003 beqz       $a0, 0x16fb70
0016FB64 27A40064 addiu      $a0, $sp, 0x64
0016FB68 10000001 b          0x16fb70
0016FB6C 27A4006C addiu      $a0, $sp, 0x6c
0016FB70 8C840000 lw         $a0, ($a0)
0016FB74 00808025 move       $s0, $a0
0016FB78 27A40030 addiu      $a0, $sp, 0x30
0016FB7C 0C00C4D4 jal        0x31350
0016FB80 02602825 move       $a1, $s3
0016FB84 0C00C4BD jal        0x312f4
0016FB88 02602025 move       $a0, $s3
0016FB8C 24440020 addiu      $a0, $v0, 0x20
0016FB90 C48C0000 lwc1       $f12, ($a0)
0016FB94 C48D0004 lwc1       $f13, 4($a0)
0016FB98 AFA200C4 sw         $v0, 0xc4($sp)
0016FB9C 44056000 mfc1       $a1, $f12
0016FBA0 C48E0008 lwc1       $f14, 8($a0)
0016FBA4 44066800 mfc1       $a2, $f13
0016FBA8 C48F000C lwc1       $f15, 0xc($a0)
0016FBAC AFA50038 sw         $a1, 0x38($sp)
0016FBB0 44047000 mfc1       $a0, $f14
0016FBB4 AFA6003C sw         $a2, 0x3c($sp)
0016FBB8 44057800 mfc1       $a1, $f15
0016FBBC AFA40040 sw         $a0, 0x40($sp)
0016FBC0 AFA50044 sw         $a1, 0x44($sp)
0016FBC4 34170000 ori        $s7, $zero, 0
0016FBC8 0C00C41E jal        0x31078
0016FBCC 02602025 move       $a0, $s3
0016FBD0 10400006 beqz       $v0, 0x16fbec
0016FBD4 00000000 nop        
0016FBD8 0C016FD5 jal        0x5bf54
0016FBDC 02602025 move       $a0, $s3
0016FBE0 10400002 beqz       $v0, 0x16fbec
0016FBE4 00000000 nop        
0016FBE8 34170001 ori        $s7, $zero, 1
0016FBEC AFB400D0 sw         $s4, 0xd0($sp)
0016FBF0 AFB000BC sw         $s0, 0xbc($sp)
0016FBF4 32F100FF andi       $s1, $s7, 0xff
0016FBF8 AFB100C0 sw         $s1, 0xc0($sp)
0016FBFC 0C00C4BD jal        0x312f4
0016FC00 02602025 move       $a0, $s3
0016FC04 3C09002D lui        $t1, 0x2d
0016FC08 C52C7360 lwc1       $f12, 0x7360($t1)
0016FC0C 3C0B002D lui        $t3, 0x2d
0016FC10 02602025 move       $a0, $s3
0016FC14 02002825 move       $a1, $s0
0016FC18 02A03025 move       $a2, $s5
0016FC1C 27A70038 addiu      $a3, $sp, 0x38
0016FC20 00404025 move       $t0, $v0
0016FC24 02804825 move       $t1, $s4
0016FC28 02205025 move       $t2, $s1
0016FC2C 0C010CED jal        0x433b4
0016FC30 256B73B4 addiu      $t3, $t3, 0x73b4
0016FC34 0040B825 move       $s7, $v0
0016FC38 34120000 ori        $s2, $zero, 0
0016FC3C 0257202B sltu       $a0, $s2, $s7
0016FC40 10800048 beqz       $a0, 0x16fd64
0016FC44 3C043480 lui        $a0, 0x3480
0016FC48 27B40070 addiu      $s4, $sp, 0x70
0016FC4C 4484C000 mtc1       $a0, $f24
0016FC50 27B5007C addiu      $s5, $sp, 0x7c
0016FC54 03A08825 move       $s1, $sp
0016FC58 27D00020 addiu      $s0, $fp, 0x20
0016FC5C 3C160002 lui        $s6, 2
0016FC60 8E240048 lw         $a0, 0x48($s1)
0016FC64 02802825 move       $a1, $s4
0016FC68 34060001 ori        $a2, $zero, 1
0016FC6C 0C01B0C6 jal        0x6c318
0016FC70 00003825 move       $a3, $zero
0016FC74 0C00C41E jal        0x31078
0016FC78 02602025 move       $a0, $s3
0016FC7C 1040000A beqz       $v0, 0x16fca8
0016FC80 00000000 nop        
0016FC84 8E260048 lw         $a2, 0x48($s1)
0016FC88 02002025 move       $a0, $s0
0016FC8C 34050001 ori        $a1, $zero, 1
0016FC90 0C0199E7 jal        0x6679c
0016FC94 34070001 ori        $a3, $zero, 1
0016FC98 02002025 move       $a0, $s0
0016FC9C 02802825 move       $a1, $s4
0016FCA0 0C019A07 jal        0x6681c
0016FCA4 00003025 move       $a2, $zero
0016FCA8 16400029 bnez       $s2, 0x16fd50
0016FCAC 00000000 nop        
0016FCB0 0C016FE3 jal        0x5bf8c
0016FCB4 02602025 move       $a0, $s3
0016FCB8 8E64095C lw         $a0, 0x95c($s3)
0016FCBC 02A02825 move       $a1, $s5
0016FCC0 00962025 or         $a0, $a0, $s6
0016FCC4 AE64095C sw         $a0, 0x95c($s3)
0016FCC8 8FA40048 lw         $a0, 0x48($sp)
0016FCCC 00003025 move       $a2, $zero
0016FCD0 0C01B0C6 jal        0x6c318
0016FCD4 00003825 move       $a3, $zero
0016FCD8 C7AC007C lwc1       $f12, 0x7c($sp)
0016FCDC C66D0030 lwc1       $f13, 0x30($s3)
0016FCE0 C66E0034 lwc1       $f14, 0x34($s3)
0016FCE4 460D6301 sub.s      $f12, $f12, $f13
0016FCE8 C66F0038 lwc1       $f15, 0x38($s3)
0016FCEC E66C02A8 swc1       $f12, 0x2a8($s3)
0016FCF0 C7B00080 lwc1       $f16, 0x80($sp)
0016FCF4 4600B346 mov.s      $f13, $f22
0016FCF8 460E8381 sub.s      $f14, $f16, $f14
0016FCFC 460C6442 mul.s      $f17, $f12, $f12
0016FD00 460D6C82 mul.s      $f18, $f13, $f13
0016FD04 E66E02AC swc1       $f14, 0x2ac($s3)
0016FD08 C7AE0084 lwc1       $f14, 0x84($sp)
0016FD0C 46128C40 add.s      $f17, $f17, $f18
0016FD10 460F7381 sub.s      $f14, $f14, $f15
0016FD14 E67602AC swc1       $f22, 0x2ac($s3)
0016FD18 460E73C2 mul.s      $f15, $f14, $f14
0016FD1C 460F8BC0 add.s      $f15, $f17, $f15
0016FD20 4618783C c.lt.s     $f15, $f24
0016FD24 00000000 nop        
0016FD28 45010009 bc1t       0x16fd50
0016FD2C E66E02B0 swc1       $f14, 0x2b0($s3)
0016FD30 46007BC4 sqrt.s     $f15, $f15
0016FD34 460FA3C3 div.s      $f15, $f20, $f15
0016FD38 460F6302 mul.s      $f12, $f12, $f15
0016FD3C 460F6B42 mul.s      $f13, $f13, $f15
0016FD40 460F7382 mul.s      $f14, $f14, $f15
0016FD44 E66C02A8 swc1       $f12, 0x2a8($s3)
0016FD48 E66D02AC swc1       $f13, 0x2ac($s3)
0016FD4C E66E02B0 swc1       $f14, 0x2b0($s3)
0016FD50 26520001 addiu      $s2, $s2, 1
0016FD54 26310004 addiu      $s1, $s1, 4
0016FD58 0257202B sltu       $a0, $s2, $s7
0016FD5C 1480FFC0 bnez       $a0, 0x16fc60
0016FD60 26100028 addiu      $s0, $s0, 0x28
0016FD64 8E6600F0 lw         $a2, 0xf0($s3)
0016FD68 34040008 ori        $a0, $zero, 8
0016FD6C 0C007F68 jal        0x1fda0
0016FD70 34050015 ori        $a1, $zero, 0x15
0016FD74 10400033 beqz       $v0, 0x16fe44
0016FD78 34050001 ori        $a1, $zero, 1
0016FD7C 8E64095C lw         $a0, 0x95c($s3)
0016FD80 3C060010 lui        $a2, 0x10
0016FD84 00862024 and        $a0, $a0, $a2
0016FD88 0004202B sltu       $a0, $zero, $a0
0016FD8C 308400FF andi       $a0, $a0, 0xff
0016FD90 1080002C beqz       $a0, 0x16fe44
0016FD94 00000000 nop        
0016FD98 866400F8 lh         $a0, 0xf8($s3)
0016FD9C 3406001F ori        $a2, $zero, 0x1f
0016FDA0 10860028 beq        $a0, $a2, 0x16fe44
0016FDA4 00000000 nop        
0016FDA8 93C400C0 lbu        $a0, 0xc0($fp)
0016FDAC 1080001A beqz       $a0, 0x16fe18
0016FDB0 00000000 nop        
0016FDB4 8FC4001C lw         $a0, 0x1c($fp)
0016FDB8 8C840064 lw         $a0, 0x64($a0)
0016FDBC 30860001 andi       $a2, $a0, 1
0016FDC0 10C00007 beqz       $a2, 0x16fde0
0016FDC4 30860008 andi       $a2, $a0, 8
0016FDC8 14C00005 bnez       $a2, 0x16fde0
0016FDCC 30860006 andi       $a2, $a0, 6
0016FDD0 14C00003 bnez       $a2, 0x16fde0
0016FDD4 30840400 andi       $a0, $a0, 0x400
0016FDD8 1080001C beqz       $a0, 0x16fe4c
0016FDDC 00000000 nop        
0016FDE0 8FA40048 lw         $a0, 0x48($sp)
0016FDE4 10800009 beqz       $a0, 0x16fe0c
0016FDE8 00000000 nop        
0016FDEC 8C860040 lw         $a2, 0x40($a0)
0016FDF0 34070001 ori        $a3, $zero, 1
0016FDF4 90C6004B lbu        $a2, 0x4b($a2)
0016FDF8 14C70004 bne        $a2, $a3, 0x16fe0c
0016FDFC 00000000 nop        
0016FE00 AFC4001C sw         $a0, 0x1c($fp)
0016FE04 10000011 b          0x16fe4c
0016FE08 A3C500C0 sb         $a1, 0xc0($fp)
0016FE0C AFC0001C sw         $zero, 0x1c($fp)
0016FE10 1000000E b          0x16fe4c
0016FE14 A3C000C0 sb         $zero, 0xc0($fp)
0016FE18 8FA40048 lw         $a0, 0x48($sp)
0016FE1C 1080000B beqz       $a0, 0x16fe4c
0016FE20 00000000 nop        
0016FE24 8C860040 lw         $a2, 0x40($a0)
0016FE28 34070001 ori        $a3, $zero, 1
0016FE2C 90C6004B lbu        $a2, 0x4b($a2)
0016FE30 14C70006 bne        $a2, $a3, 0x16fe4c
0016FE34 00000000 nop        
0016FE38 AFC4001C sw         $a0, 0x1c($fp)
0016FE3C 10000003 b          0x16fe4c
0016FE40 A3C500C0 sb         $a1, 0xc0($fp)
0016FE44 AFC0001C sw         $zero, 0x1c($fp)
0016FE48 A3C000C0 sb         $zero, 0xc0($fp)
0016FE4C 0C00C41E jal        0x31078
0016FE50 02602025 move       $a0, $s3
0016FE54 1040001C beqz       $v0, 0x16fec8
0016FE58 00000000 nop        
0016FE5C 93C400C0 lbu        $a0, 0xc0($fp)
0016FE60 10800019 beqz       $a0, 0x16fec8
0016FE64 00000000 nop        
0016FE68 8FC4001C lw         $a0, 0x1c($fp)
0016FE6C 10800016 beqz       $a0, 0x16fec8
0016FE70 00000000 nop        
0016FE74 3C06002D lui        $a2, 0x2d
0016FE78 4600A346 mov.s      $f13, $f20
0016FE7C 34040064 ori        $a0, $zero, 0x64
0016FE80 34050002 ori        $a1, $zero, 2
0016FE84 0C000A17 jal        0x285c
0016FE88 C4CC7458 lwc1       $f12, 0x7458($a2)
0016FE8C 3C053F91 lui        $a1, 0x3f91
0016FE90 4600A346 mov.s      $f13, $f20
0016FE94 34A5EB85 ori        $a1, $a1, 0xeb85
0016FE98 44856000 mtc1       $a1, $f12
0016FE9C 34040064 ori        $a0, $zero, 0x64
0016FEA0 0C000A22 jal        0x2888
0016FEA4 34050002 ori        $a1, $zero, 2
0016FEA8 8FC4001C lw         $a0, 0x1c($fp)
0016FEAC 0C00039F jal        0xe7c
0016FEB0 24900030 addiu      $s0, $a0, 0x30
0016FEB4 46000347 neg.s      $f13, $f0
0016FEB8 02002025 move       $a0, $s0
0016FEBC 4600A306 mov.s      $f12, $f20
0016FEC0 0C000AC6 jal        0x2b18
0016FEC4 00002825 move       $a1, $zero
0016FEC8 0C00C41E jal        0x31078
0016FECC 02602025 move       $a0, $s3
0016FED0 1040009E beqz       $v0, 0x17014c
0016FED4 00000000 nop        
0016FED8 C7CC0010 lwc1       $f12, 0x10($fp)
0016FEDC 46166032 c.eq.s     $f12, $f22
0016FEE0 00000000 nop        
0016FEE4 45000099 bc1f       0x17014c
0016FEE8 00000000 nop        
0016FEEC 0C007956 jal        0x1e558
0016FEF0 02602025 move       $a0, $s3
0016FEF4 10400095 beqz       $v0, 0x17014c
0016FEF8 00000000 nop        
0016FEFC 8FA40030 lw         $a0, 0x30($sp)
0016FF00 30840020 andi       $a0, $a0, 0x20
0016FF04 10800091 beqz       $a0, 0x17014c
0016FF08 00000000 nop        
0016FF0C 8FA400C8 lw         $a0, 0xc8($sp)
0016FF10 90840045 lbu        $a0, 0x45($a0)
0016FF14 10800003 beqz       $a0, 0x16ff24
0016FF18 34050008 ori        $a1, $zero, 8
0016FF1C 1485008B bne        $a0, $a1, 0x17014c
0016FF20 00000000 nop        
0016FF24 266400C0 addiu      $a0, $s3, 0xc0
0016FF28 8C930014 lw         $s3, 0x14($a0)
0016FF2C 93A400CC lbu        $a0, 0xcc($sp)
0016FF30 34100000 ori        $s0, $zero, 0
0016FF34 1080003B beqz       $a0, 0x170024
0016FF38 32732000 andi       $s3, $s3, 0x2000
0016FF3C 12600033 beqz       $s3, 0x17000c
0016FF40 C7CC0018 lwc1       $f12, 0x18($fp)
0016FF44 3C044F00 lui        $a0, 0x4f00
0016FF48 44846800 mtc1       $a0, $f13
0016FF4C 3C04002D lui        $a0, 0x2d
0016FF50 460D603C c.lt.s     $f12, $f13
0016FF54 00000000 nop        
0016FF58 45000004 bc1f       0x16ff6c
0016FF5C C48E73F0 lwc1       $f14, 0x73f0($a0)
0016FF60 460063CD trunc.w.s  $f15, $f12
0016FF64 10000006 b          0x16ff80
0016FF68 44047800 mfc1       $a0, $f15
0016FF6C 460D63C1 sub.s      $f15, $f12, $f13
0016FF70 3C048000 lui        $a0, 0x8000
0016FF74 46007BCD trunc.w.s  $f15, $f15
0016FF78 44057800 mfc1       $a1, $f15
0016FF7C 00A42021 addu       $a0, $a1, $a0
0016FF80 460E6300 add.s      $f12, $f12, $f14
0016FF84 3C054080 lui        $a1, 0x4080
0016FF88 44857800 mtc1       $a1, $f15
0016FF8C E7CC0018 swc1       $f12, 0x18($fp)
0016FF90 E7AF0088 swc1       $f15, 0x88($sp)
0016FF94 C7CC0018 lwc1       $f12, 0x18($fp)
0016FF98 460F603C c.lt.s     $f12, $f15
0016FF9C 00000000 nop        
0016FFA0 45000004 bc1f       0x16ffb4
0016FFA4 27A50088 addiu      $a1, $sp, 0x88
0016FFA8 27C50018 addiu      $a1, $fp, 0x18
0016FFAC 10000002 b          0x16ffb8
0016FFB0 C4AC0000 lwc1       $f12, ($a1)
0016FFB4 C4AC0000 lwc1       $f12, ($a1)
0016FFB8 E7CC0018 swc1       $f12, 0x18($fp)
0016FFBC C7CC0018 lwc1       $f12, 0x18($fp)
0016FFC0 460D603C c.lt.s     $f12, $f13
0016FFC4 00000000 nop        
0016FFC8 45020005 bc1fl      0x16ffe0
0016FFCC 460D6301 sub.s      $f12, $f12, $f13
0016FFD0 4600630D trunc.w.s  $f12, $f12
0016FFD4 44056000 mfc1       $a1, $f12
0016FFD8 10000006 b          0x16fff4
0016FFDC 0085202B sltu       $a0, $a0, $a1
0016FFE0 3C058000 lui        $a1, 0x8000
0016FFE4 4600630D trunc.w.s  $f12, $f12
0016FFE8 44066000 mfc1       $a2, $f12
0016FFEC 00C52821 addu       $a1, $a2, $a1
0016FFF0 0085202B sltu       $a0, $a0, $a1
0016FFF4 10800003 beqz       $a0, 0x170004
0016FFF8 00000000 nop        
0016FFFC 0C0294A9 jal        0xa52a4
00170000 34040006 ori        $a0, $zero, 6
00170004 1000000A b          0x170030
00170008 00000000 nop        
0017000C 46166032 c.eq.s     $f12, $f22
00170010 00000000 nop        
00170014 45010006 bc1t       0x170030
00170018 00000000 nop        
0017001C 10000004 b          0x170030
00170020 34100001 ori        $s0, $zero, 1
00170024 12600002 beqz       $s3, 0x170030
00170028 00000000 nop        
0017002C 34100001 ori        $s0, $zero, 1
00170030 12000046 beqz       $s0, 0x17014c
00170034 00000000 nop        
00170038 8FA400BC lw         $a0, 0xbc($sp)
0017003C 34120000 ori        $s2, $zero, 0
00170040 0244202B sltu       $a0, $s2, $a0
00170044 1080003B beqz       $a0, 0x170134
00170048 34100000 ori        $s0, $zero, 0
0017004C 8FB600BC lw         $s6, 0xbc($sp)
00170050 8FB700C0 lw         $s7, 0xc0($sp)
00170054 26C4FFFF addiu      $a0, $s6, -1
00170058 00049880 sll        $s3, $a0, 2
0017005C 3C04002D lui        $a0, 0x2d
00170060 248473A0 addiu      $a0, $a0, 0x73a0
00170064 3C14002D lui        $s4, 0x2d
00170068 34150001 ori        $s5, $zero, 1
0017006C 27B1008C addiu      $s1, $sp, 0x8c
00170070 02649821 addu       $s3, $s3, $a0
00170074 8FBE00C4 lw         $fp, 0xc4($sp)
00170078 26947370 addiu      $s4, $s4, 0x7370
0017007C 12E0000A beqz       $s7, 0x1700a8
00170080 00000000 nop        
00170084 16D50008 bne        $s6, $s5, 0x1700a8
00170088 00000000 nop        
0017008C C7AC0038 lwc1       $f12, 0x38($sp)
00170090 E62C0000 swc1       $f12, ($s1)
00170094 C7AC003C lwc1       $f12, 0x3c($sp)
00170098 E62C0004 swc1       $f12, 4($s1)
0017009C C7AC0040 lwc1       $f12, 0x40($sp)
001700A0 10000016 b          0x1700fc
001700A4 E62C0008 swc1       $f12, 8($s1)
001700A8 1640000C bnez       $s2, 0x1700dc
001700AC 00102080 sll        $a0, $s0, 2
001700B0 03A42021 addu       $a0, $sp, $a0
001700B4 8C840048 lw         $a0, 0x48($a0)
001700B8 10800008 beqz       $a0, 0x1700dc
001700BC 00000000 nop        
001700C0 C7AC0038 lwc1       $f12, 0x38($sp)
001700C4 E62C0000 swc1       $f12, ($s1)
001700C8 C7AC003C lwc1       $f12, 0x3c($sp)
001700CC E62C0004 swc1       $f12, 4($s1)
001700D0 C7AC0040 lwc1       $f12, 0x40($sp)
001700D4 10000009 b          0x1700fc
001700D8 E62C0008 swc1       $f12, 8($s1)
001700DC 92650000 lbu        $a1, ($s3)
001700E0 02202025 move       $a0, $s1
001700E4 00A53021 addu       $a2, $a1, $a1
001700E8 00A62821 addu       $a1, $a1, $a2
001700EC 00053080 sll        $a2, $a1, 2
001700F0 00D43021 addu       $a2, $a2, $s4
001700F4 0C03D465 jal        0xf5194
001700F8 03C02825 move       $a1, $fp
001700FC 26100001 addiu      $s0, $s0, 1
00170100 2E040004 sltiu      $a0, $s0, 4
00170104 10800005 beqz       $a0, 0x17011c
00170108 00102080 sll        $a0, $s0, 2
0017010C 03A42021 addu       $a0, $sp, $a0
00170110 8C840048 lw         $a0, 0x48($a0)
00170114 14800002 bnez       $a0, 0x170120
00170118 00000000 nop        
0017011C 34100000 ori        $s0, $zero, 0
00170120 26520001 addiu      $s2, $s2, 1
00170124 2631000C addiu      $s1, $s1, 0xc
00170128 0256202B sltu       $a0, $s2, $s6
0017012C 1480FFD3 bnez       $a0, 0x17007c
00170130 26730001 addiu      $s3, $s3, 1
00170134 8FA400C8 lw         $a0, 0xc8($sp)
00170138 8FA500D0 lw         $a1, 0xd0($sp)
0017013C 27A6008C addiu      $a2, $sp, 0x8c
00170140 27A70048 addiu      $a3, $sp, 0x48
00170144 0C05BD9C jal        0x16f670
00170148 8FA800BC lw         $t0, 0xbc($sp)
0017014C C7B400D4 lwc1       $f20, 0xd4($sp)
00170150 C7B600D8 lwc1       $f22, 0xd8($sp)
00170154 C7B800DC lwc1       $f24, 0xdc($sp)
00170158 8FB000E0 lw         $s0, 0xe0($sp)
0017015C 8FB100E4 lw         $s1, 0xe4($sp)
00170160 8FB200E8 lw         $s2, 0xe8($sp)
00170164 8FB300EC lw         $s3, 0xec($sp)
00170168 8FB400F0 lw         $s4, 0xf0($sp)
0017016C 8FB500F4 lw         $s5, 0xf4($sp)
00170170 8FB600F8 lw         $s6, 0xf8($sp)
00170174 8FB700FC lw         $s7, 0xfc($sp)
00170178 8FBE0100 lw         $fp, 0x100($sp)
0017017C 8FBF0104 lw         $ra, 0x104($sp)
00170180 03E00008 jr         $ra
00170184 27BD0110 addiu      $sp, $sp, 0x110