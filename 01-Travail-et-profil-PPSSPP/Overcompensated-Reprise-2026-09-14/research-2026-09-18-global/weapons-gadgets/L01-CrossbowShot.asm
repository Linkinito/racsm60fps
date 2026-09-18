
CALLBACK 0x0012B8A4 end 0x0012B8AC ordinal 0

0012B8A4 03E00008 jr         $ra
0012B8A8 34020001 ori        $v0, $zero, 1

CALLBACK 0x0012B8AC end 0x0012B8E8 ordinal 1

0012B8AC 27BDFFE0 addiu      $sp, $sp, -0x20
0012B8B0 8C840058 lw         $a0, 0x58($a0)
0012B8B4 9085025D lbu        $a1, 0x25d($a0)
0012B8B8 AFBF0014 sw         $ra, 0x14($sp)
0012B8BC 10A00007 beqz       $a1, 0x12b8dc
0012B8C0 00000000 nop        
0012B8C4 AFA40010 sw         $a0, 0x10($sp)
0012B8C8 0C03732A jal        0xdcca8
0012B8CC 2484013C addiu      $a0, $a0, 0x13c
0012B8D0 8FA40010 lw         $a0, 0x10($sp)
0012B8D4 0C03732A jal        0xdcca8
0012B8D8 24840198 addiu      $a0, $a0, 0x198
0012B8DC 8FBF0014 lw         $ra, 0x14($sp)
0012B8E0 03E00008 jr         $ra
0012B8E4 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0012CDEC end 0x0012D604 ordinal 2

0012CDEC 27BDFF20 addiu      $sp, $sp, -0xe0
0012CDF0 AFB000B4 sw         $s0, 0xb4($sp)
0012CDF4 00808025 move       $s0, $a0
0012CDF8 92040045 lbu        $a0, 0x45($s0)
0012CDFC E7B4009C swc1       $f20, 0x9c($sp)
0012CE00 28850002 slti       $a1, $a0, 2
0012CE04 E7B600A0 swc1       $f22, 0xa0($sp)
0012CE08 E7B800A4 swc1       $f24, 0xa4($sp)
0012CE0C E7BA00A8 swc1       $f26, 0xa8($sp)
0012CE10 E7BC00AC swc1       $f28, 0xac($sp)
0012CE14 E7BE00B0 swc1       $f30, 0xb0($sp)
0012CE18 AFB100B8 sw         $s1, 0xb8($sp)
0012CE1C AFB200BC sw         $s2, 0xbc($sp)
0012CE20 AFB300C0 sw         $s3, 0xc0($sp)
0012CE24 AFB400C4 sw         $s4, 0xc4($sp)
0012CE28 AFB500C8 sw         $s5, 0xc8($sp)
0012CE2C AFB600CC sw         $s6, 0xcc($sp)
0012CE30 AFB700D0 sw         $s7, 0xd0($sp)
0012CE34 AFBE00D4 sw         $fp, 0xd4($sp)
0012CE38 AFBF00D8 sw         $ra, 0xd8($sp)
0012CE3C 10A00007 beqz       $a1, 0x12ce5c
0012CE40 8E1E0058 lw         $fp, 0x58($s0)
0012CE44 04800137 bltz       $a0, 0x12d324
0012CE48 AFB00094 sw         $s0, 0x94($sp)
0012CE4C 18800035 blez       $a0, 0x12cf24
0012CE50 00000000 nop        
0012CE54 10000008 b          0x12ce78
0012CE58 00000000 nop        
0012CE5C 28850003 slti       $a1, $a0, 3
0012CE60 14A00127 bnez       $a1, 0x12d300
0012CE64 28840004 slti       $a0, $a0, 4
0012CE68 1480012D bnez       $a0, 0x12d320
0012CE6C AFB00094 sw         $s0, 0x94($sp)
0012CE70 1000012C b          0x12d324
0012CE74 00000000 nop        
0012CE78 C60C0070 lwc1       $f12, 0x70($s0)
0012CE7C 44806800 mtc1       $zero, $f13
0012CE80 3C04BF80 lui        $a0, 0xbf80
0012CE84 44847000 mtc1       $a0, $f14
0012CE88 460E6300 add.s      $f12, $f12, $f14
0012CE8C 460D603E c.le.s     $f12, $f13
0012CE90 00000000 nop        
0012CE94 45010007 bc1t       0x12ceb4
0012CE98 E60C0070 swc1       $f12, 0x70($s0)
0012CE9C 3C04002D lui        $a0, 0x2d
0012CEA0 C48C0778 lwc1       $f12, 0x778($a0)
0012CEA4 0C04AF97 jal        0x12be5c
0012CEA8 02002025 move       $a0, $s0
0012CEAC 10400004 beqz       $v0, 0x12cec0
0012CEB0 00000000 nop        
0012CEB4 AFB00094 sw         $s0, 0x94($sp)
0012CEB8 1000011A b          0x12d324
0012CEBC A2000045 sb         $zero, 0x45($s0)
0012CEC0 8FC40004 lw         $a0, 4($fp)
0012CEC4 10800012 beqz       $a0, 0x12cf10
0012CEC8 00000000 nop        
0012CECC 8C850064 lw         $a1, 0x64($a0)
0012CED0 30A60001 andi       $a2, $a1, 1
0012CED4 10C00005 beqz       $a2, 0x12ceec
0012CED8 30A60006 andi       $a2, $a1, 6
0012CEDC 14C00003 bnez       $a2, 0x12ceec
0012CEE0 30A50008 andi       $a1, $a1, 8
0012CEE4 10A00003 beqz       $a1, 0x12cef4
0012CEE8 00000000 nop        
0012CEEC 10000008 b          0x12cf10
0012CEF0 A2000045 sb         $zero, 0x45($s0)
0012CEF4 00803025 move       $a2, $a0
0012CEF8 27C5004C addiu      $a1, $fp, 0x4c
0012CEFC 0C03E2D9 jal        0xf8b64
0012CF00 02002025 move       $a0, $s0
0012CF04 8FC50004 lw         $a1, 4($fp)
0012CF08 0C03D0F2 jal        0xf43c8
0012CF0C 27C4001C addiu      $a0, $fp, 0x1c
0012CF10 AFB00094 sw         $s0, 0x94($sp)
0012CF14 0C04B581 jal        0x12d604
0012CF18 27C40228 addiu      $a0, $fp, 0x228
0012CF1C 10000101 b          0x12d324
0012CF20 00000000 nop        
0012CF24 0C04AE3A jal        0x12b8e8
0012CF28 02002025 move       $a0, $s0
0012CF2C 8FC50000 lw         $a1, ($fp)
0012CF30 34040009 ori        $a0, $zero, 9
0012CF34 8CA600F0 lw         $a2, 0xf0($a1)
0012CF38 0C007F68 jal        0x1fda0
0012CF3C 34050016 ori        $a1, $zero, 0x16
0012CF40 10400062 beqz       $v0, 0x12d0cc
0012CF44 00000000 nop        
0012CF48 93C4025E lbu        $a0, 0x25e($fp)
0012CF4C 1480005F bnez       $a0, 0x12d0cc
0012CF50 00000000 nop        
0012CF54 8FC40004 lw         $a0, 4($fp)
0012CF58 1080005C beqz       $a0, 0x12d0cc
0012CF5C AFB00094 sw         $s0, 0x94($sp)
0012CF60 3C13002D lui        $s3, 0x2d
0012CF64 3C044000 lui        $a0, 0x4000
0012CF68 4480E000 mtc1       $zero, $f28
0012CF6C C66C0774 lwc1       $f12, 0x774($s3)
0012CF70 44846800 mtc1       $a0, $f13
0012CF74 3C04002D lui        $a0, 0x2d
0012CF78 460D6502 mul.s      $f20, $f12, $f13
0012CF7C C4960750 lwc1       $f22, 0x750($a0)
0012CF80 3C053F00 lui        $a1, 0x3f00
0012CF84 3C044F80 lui        $a0, 0x4f80
0012CF88 44857000 mtc1       $a1, $f14
0012CF8C 8FB20094 lw         $s2, 0x94($sp)
0012CF90 4484C000 mtc1       $a0, $f24
0012CF94 3C053F80 lui        $a1, 0x3f80
0012CF98 460EA502 mul.s      $f20, $f20, $f14
0012CF9C 26440020 addiu      $a0, $s2, 0x20
0012CFA0 4485D000 mtc1       $a1, $f26
0012CFA4 26570010 addiu      $s7, $s2, 0x10
0012CFA8 34100000 ori        $s0, $zero, 0
0012CFAC 27B10030 addiu      $s1, $sp, 0x30
0012CFB0 27B60058 addiu      $s6, $sp, 0x58
0012CFB4 AFA40090 sw         $a0, 0x90($sp)
0012CFB8 27B50040 addiu      $s5, $sp, 0x40
0012CFBC 26520030 addiu      $s2, $s2, 0x30
0012CFC0 27D40218 addiu      $s4, $fp, 0x218
0012CFC4 44906000 mtc1       $s0, $f12
0012CFC8 46806320 cvt.s.w    $f12, $f12
0012CFCC 06020001 bltzl      $s0, 0x12cfd4
0012CFD0 46186300 add.s      $f12, $f12, $f24
0012CFD4 C66D0774 lwc1       $f13, 0x774($s3)
0012CFD8 460C6B02 mul.s      $f12, $f13, $f12
0012CFDC 46146781 sub.s      $f30, $f12, $f20
0012CFE0 0C06D6C8 jal        0x1b5b20
0012CFE4 4600F306 mov.s      $f12, $f30
0012CFE8 46000306 mov.s      $f12, $f0
0012CFEC 460C6382 mul.s      $f14, $f12, $f12
0012CFF0 461CF03C c.lt.s     $f30, $f28
0012CFF4 460ED341 sub.s      $f13, $f26, $f14
0012CFF8 46006B44 sqrt.s     $f13, $f13
0012CFFC 45030001 bc1tl      0x12d004
0012D000 46006B47 neg.s      $f13, $f13
0012D004 46006386 mov.s      $f14, $f12
0012D008 8FA50090 lw         $a1, 0x90($sp)
0012D00C 46006B06 mov.s      $f12, $f13
0012D010 02202025 move       $a0, $s1
0012D014 46007346 mov.s      $f13, $f14
0012D018 0C03DCFC jal        0xf73f0
0012D01C 02E03025 move       $a2, $s7
0012D020 E7BC003C swc1       $f28, 0x3c($sp)
0012D024 4600B306 mov.s      $f12, $f22
0012D028 E7B60058 swc1       $f22, 0x58($sp)
0012D02C 8FCA0004 lw         $t2, 4($fp)
0012D030 02C02025 move       $a0, $s6
0012D034 02A02825 move       $a1, $s5
0012D038 02403025 move       $a2, $s2
0012D03C 02203825 move       $a3, $s1
0012D040 34080068 ori        $t0, $zero, 0x68
0012D044 0C007517 jal        0x1d45c
0012D048 00004825 move       $t1, $zero
0012D04C 8FC40000 lw         $a0, ($fp)
0012D050 8FC7000C lw         $a3, 0xc($fp)
0012D054 C7AC0058 lwc1       $f12, 0x58($sp)
0012D058 93C5025C lbu        $a1, 0x25c($fp)
0012D05C 8FC90008 lw         $t1, 8($fp)
0012D060 0005502B sltu       $t2, $zero, $a1
0012D064 34020001 ori        $v0, $zero, 1
0012D068 314A00FF andi       $t2, $t2, 0xff
0012D06C 02402825 move       $a1, $s2
0012D070 02203025 move       $a2, $s1
0012D074 00004025 move       $t0, $zero
0012D078 340B0001 ori        $t3, $zero, 1
0012D07C 0C04B007 jal        0x12c01c
0012D080 AFA20000 sw         $v0, ($sp)
0012D084 00402025 move       $a0, $v0
0012D088 1080000B beqz       $a0, 0x12d0b8
0012D08C 00000000 nop        
0012D090 AFB20098 sw         $s2, 0x98($sp)
0012D094 8C920058 lw         $s2, 0x58($a0)
0012D098 93C60267 lbu        $a2, 0x267($fp)
0012D09C 26440218 addiu      $a0, $s2, 0x218
0012D0A0 00063080 sll        $a2, $a2, 2
0012D0A4 0C06B672 jal        0x1ad9c8
0012D0A8 02802825 move       $a1, $s4
0012D0AC 93C40267 lbu        $a0, 0x267($fp)
0012D0B0 A2440267 sb         $a0, 0x267($s2)
0012D0B4 8FB20098 lw         $s2, 0x98($sp)
0012D0B8 26100001 addiu      $s0, $s0, 1
0012D0BC 2E040003 sltiu      $a0, $s0, 3
0012D0C0 1480FFC0 bnez       $a0, 0x12cfc4
0012D0C4 00000000 nop        
0012D0C8 8FB00094 lw         $s0, 0x94($sp)
0012D0CC 8FC40008 lw         $a0, 8($fp)
0012D0D0 2C840003 sltiu      $a0, $a0, 3
0012D0D4 14800083 bnez       $a0, 0x12d2e4
0012D0D8 AFB00094 sw         $s0, 0x94($sp)
0012D0DC 3C044049 lui        $a0, 0x4049
0012D0E0 34840FDB ori        $a0, $a0, 0xfdb
0012D0E4 4484D000 mtc1       $a0, $f26
0012D0E8 8FB40094 lw         $s4, 0x94($sp)
0012D0EC 3C043E99 lui        $a0, 0x3e99
0012D0F0 4480A000 mtc1       $zero, $f20
0012D0F4 3484999A ori        $a0, $a0, 0x999a
0012D0F8 4484E000 mtc1       $a0, $f28
0012D0FC 03C08825 move       $s1, $fp
0012D100 3C043000 lui        $a0, 0x3000
0012D104 4484C000 mtc1       $a0, $f24
0012D108 3C12002D lui        $s2, 0x2d
0012D10C 3C044000 lui        $a0, 0x4000
0012D110 3C16002D lui        $s6, 0x2d
0012D114 4484B000 mtc1       $a0, $f22
0012D118 34130000 ori        $s3, $zero, 0
0012D11C 26940030 addiu      $s4, $s4, 0x30
0012D120 263001F4 addiu      $s0, $s1, 0x1f4
0012D124 2635007C addiu      $s5, $s1, 0x7c
0012D128 265207B8 addiu      $s2, $s2, 0x7b8
0012D12C 26D6A378 addiu      $s6, $s6, -0x5c88
0012D130 3C17002D lui        $s7, 0x2d
0012D134 0C06B652 jal        0x1ad948
0012D138 00000000 nop        
0012D13C 44826000 mtc1       $v0, $f12
0012D140 46806320 cvt.s.w    $f12, $f12
0012D144 46186302 mul.s      $f12, $f12, $f24
0012D148 46166302 mul.s      $f12, $f12, $f22
0012D14C 461A6782 mul.s      $f30, $f12, $f26
0012D150 0C069359 jal        0x1a4d64
0012D154 4600F306 mov.s      $f12, $f30
0012D158 E7A0005C swc1       $f0, 0x5c($sp)
0012D15C 0C0693A3 jal        0x1a4e8c
0012D160 4600F306 mov.s      $f12, $f30
0012D164 E7A00064 swc1       $f0, 0x64($sp)
0012D168 E7B40060 swc1       $f20, 0x60($sp)
0012D16C C6ED0768 lwc1       $f13, 0x768($s7)
0012D170 3C04002D lui        $a0, 0x2d
0012D174 C48E076C lwc1       $f14, 0x76c($a0)
0012D178 0C06B652 jal        0x1ad948
0012D17C 460D7781 sub.s      $f30, $f14, $f13
0012D180 44826000 mtc1       $v0, $f12
0012D184 46806320 cvt.s.w    $f12, $f12
0012D188 C6EF0768 lwc1       $f15, 0x768($s7)
0012D18C C7B0005C lwc1       $f16, 0x5c($sp)
0012D190 46186302 mul.s      $f12, $f12, $f24
0012D194 C68E0000 lwc1       $f14, ($s4)
0012D198 461E6302 mul.s      $f12, $f12, $f30
0012D19C 460C7B00 add.s      $f12, $f15, $f12
0012D1A0 460C8342 mul.s      $f13, $f16, $f12
0012D1A4 460D7340 add.s      $f13, $f14, $f13
0012D1A8 E60D0000 swc1       $f13, ($s0)
0012D1AC C7AD0060 lwc1       $f13, 0x60($sp)
0012D1B0 C6910004 lwc1       $f17, 4($s4)
0012D1B4 460C6B42 mul.s      $f13, $f13, $f12
0012D1B8 3C09002D lui        $t1, 0x2d
0012D1BC 460D8B40 add.s      $f13, $f17, $f13
0012D1C0 27A40068 addiu      $a0, $sp, 0x68
0012D1C4 E60D0004 swc1       $f13, 4($s0)
0012D1C8 C7AD0064 lwc1       $f13, 0x64($sp)
0012D1CC C68F0008 lwc1       $f15, 8($s4)
0012D1D0 460C6B02 mul.s      $f12, $f13, $f12
0012D1D4 27A5006C addiu      $a1, $sp, 0x6c
0012D1D8 02003025 move       $a2, $s0
0012D1DC 460C7B00 add.s      $f12, $f15, $f12
0012D1E0 34070868 ori        $a3, $zero, 0x868
0012D1E4 00004025 move       $t0, $zero
0012D1E8 E60C0008 swc1       $f12, 8($s0)
0012D1EC C62C01F8 lwc1       $f12, 0x1f8($s1)
0012D1F0 C64E0008 lwc1       $f14, 8($s2)
0012D1F4 460E6300 add.s      $f12, $f12, $f14
0012D1F8 E62C01F8 swc1       $f12, 0x1f8($s1)
0012D1FC C52C0770 lwc1       $f12, 0x770($t1)
0012D200 AFA00080 sw         $zero, 0x80($sp)
0012D204 0C006B36 jal        0x1acd8
0012D208 E7AC0068 swc1       $f12, 0x68($sp)
0012D20C 1040001D beqz       $v0, 0x12d284
0012D210 00000000 nop        
0012D214 8FA40080 lw         $a0, 0x80($sp)
0012D218 1080001A beqz       $a0, 0x12d284
0012D21C 00000000 nop        
0012D220 C7AC0068 lwc1       $f12, 0x68($sp)
0012D224 C61E0000 lwc1       $f30, ($s0)
0012D228 0C06D153 jal        0x1b454c
0012D22C 461C6301 sub.s      $f12, $f12, $f28
0012D230 00602825 move       $a1, $v1
0012D234 0C06D459 jal        0x1b5164
0012D238 00402025 move       $a0, $v0
0012D23C 00602825 move       $a1, $v1
0012D240 0C06D477 jal        0x1b51dc
0012D244 00402025 move       $a0, $v0
0012D248 3C04002D lui        $a0, 0x2d
0012D24C C48CA378 lwc1       $f12, -0x5c88($a0)
0012D250 C60D0004 lwc1       $f13, 4($s0)
0012D254 46006302 mul.s      $f12, $f12, $f0
0012D258 C60E0008 lwc1       $f14, 8($s0)
0012D25C 460CF300 add.s      $f12, $f30, $f12
0012D260 E60C0000 swc1       $f12, ($s0)
0012D264 C6CC0004 lwc1       $f12, 4($s6)
0012D268 46006302 mul.s      $f12, $f12, $f0
0012D26C 460C6B00 add.s      $f12, $f13, $f12
0012D270 E60C0004 swc1       $f12, 4($s0)
0012D274 C6CC0008 lwc1       $f12, 8($s6)
0012D278 46006302 mul.s      $f12, $f12, $f0
0012D27C 460C7300 add.s      $f12, $f14, $f12
0012D280 E60C0008 swc1       $f12, 8($s0)
0012D284 8FC80000 lw         $t0, ($fp)
0012D288 02A02025 move       $a0, $s5
0012D28C 25080010 addiu      $t0, $t0, 0x10
0012D290 02402825 move       $a1, $s2
0012D294 02803025 move       $a2, $s4
0012D298 0C017E1D jal        0x5f874
0012D29C 02003825 move       $a3, $s0
0012D2A0 03D32021 addu       $a0, $fp, $s3
0012D2A4 34050001 ori        $a1, $zero, 1
0012D2A8 A0800263 sb         $zero, 0x263($a0)
0012D2AC A0850260 sb         $a1, 0x260($a0)
0012D2B0 26730001 addiu      $s3, $s3, 1
0012D2B4 2631000C addiu      $s1, $s1, 0xc
0012D2B8 2610000C addiu      $s0, $s0, 0xc
0012D2BC 26520044 addiu      $s2, $s2, 0x44
0012D2C0 2E640003 sltiu      $a0, $s3, 3
0012D2C4 1480FF9B bnez       $a0, 0x12d134
0012D2C8 26B5003C addiu      $s5, $s5, 0x3c
0012D2CC 8FB00094 lw         $s0, 0x94($sp)
0012D2D0 34040002 ori        $a0, $zero, 2
0012D2D4 8E050064 lw         $a1, 0x64($s0)
0012D2D8 A2040045 sb         $a0, 0x45($s0)
0012D2DC 10000005 b          0x12d2f4
0012D2E0 34A40020 ori        $a0, $a1, 0x20
0012D2E4 34040003 ori        $a0, $zero, 3
0012D2E8 8E050064 lw         $a1, 0x64($s0)
0012D2EC A2040045 sb         $a0, 0x45($s0)
0012D2F0 34A40020 ori        $a0, $a1, 0x20
0012D2F4 AFB00094 sw         $s0, 0x94($sp)
0012D2F8 1000000A b          0x12d324
0012D2FC AE040064 sw         $a0, 0x64($s0)
0012D300 93C40266 lbu        $a0, 0x266($fp)
0012D304 34050003 ori        $a1, $zero, 3
0012D308 14850003 bne        $a0, $a1, 0x12d318
0012D30C 00000000 nop        
0012D310 34040003 ori        $a0, $zero, 3
0012D314 A2040045 sb         $a0, 0x45($s0)
0012D318 10000002 b          0x12d324
0012D31C AFB00094 sw         $s0, 0x94($sp)
0012D320 AFB00094 sw         $s0, 0x94($sp)
0012D324 03C09025 move       $s2, $fp
0012D328 34100000 ori        $s0, $zero, 0
0012D32C 34140001 ori        $s4, $zero, 1
0012D330 2653007C addiu      $s3, $s2, 0x7c
0012D334 265501F4 addiu      $s5, $s2, 0x1f4
0012D338 8FB60094 lw         $s6, 0x94($sp)
0012D33C 34170001 ori        $s7, $zero, 1
0012D340 03D08821 addu       $s1, $fp, $s0
0012D344 92240260 lbu        $a0, 0x260($s1)
0012D348 10800043 beqz       $a0, 0x12d458
0012D34C 00000000 nop        
0012D350 0C017EB3 jal        0x5facc
0012D354 02602025 move       $a0, $s3
0012D358 824400AC lb         $a0, 0xac($s2)
0012D35C 14940032 bne        $a0, $s4, 0x12d428
0012D360 00000000 nop        
0012D364 92240263 lbu        $a0, 0x263($s1)
0012D368 1480002F bnez       $a0, 0x12d428
0012D36C 00000000 nop        
0012D370 A2370263 sb         $s7, 0x263($s1)
0012D374 02C02025 move       $a0, $s6
0012D378 0C04AEEF jal        0x12bbbc
0012D37C 02A02825 move       $a1, $s5
0012D380 0C06B652 jal        0x1ad948
0012D384 00000000 nop        
0012D388 00408825 move       $s1, $v0
0012D38C 06210004 bgez       $s1, 0x12d3a0
0012D390 00112023 negu       $a0, $s1
0012D394 30910003 andi       $s1, $a0, 3
0012D398 10000002 b          0x12d3a4
0012D39C 00118823 negu       $s1, $s1
0012D3A0 32310003 andi       $s1, $s1, 3
0012D3A4 2A240002 slti       $a0, $s1, 2
0012D3A8 1080000A beqz       $a0, 0x12d3d4
0012D3AC 2A240003 slti       $a0, $s1, 3
0012D3B0 0620001B bltz       $s1, 0x12d420
0012D3B4 00000000 nop        
0012D3B8 1E20000C bgtz       $s1, 0x12d3ec
0012D3BC 00000000 nop        
0012D3C0 34040008 ori        $a0, $zero, 8
0012D3C4 0C03467E jal        0xd19f8
0012D3C8 02A02825 move       $a1, $s5
0012D3CC 10000014 b          0x12d420
0012D3D0 00000000 nop        
0012D3D4 1480000A bnez       $a0, 0x12d400
0012D3D8 2A240004 slti       $a0, $s1, 4
0012D3DC 1480000D bnez       $a0, 0x12d414
0012D3E0 00000000 nop        
0012D3E4 1000000E b          0x12d420
0012D3E8 00000000 nop        
0012D3EC 34040009 ori        $a0, $zero, 9
0012D3F0 0C03467E jal        0xd19f8
0012D3F4 02A02825 move       $a1, $s5
0012D3F8 10000009 b          0x12d420
0012D3FC 00000000 nop        
0012D400 3404000A ori        $a0, $zero, 0xa
0012D404 0C03467E jal        0xd19f8
0012D408 02A02825 move       $a1, $s5
0012D40C 10000004 b          0x12d420
0012D410 00000000 nop        
0012D414 3404000B ori        $a0, $zero, 0xb
0012D418 0C03467E jal        0xd19f8
0012D41C 02A02825 move       $a1, $s5
0012D420 1000000D b          0x12d458
0012D424 00000000 nop        
0012D428 82640030 lb         $a0, 0x30($s3)
0012D42C 38840003 xori       $a0, $a0, 3
0012D430 2C840001 sltiu      $a0, $a0, 1
0012D434 308400FF andi       $a0, $a0, 0xff
0012D438 10800007 beqz       $a0, 0x12d458
0012D43C 00000000 nop        
0012D440 0C017E49 jal        0x5f924
0012D444 02602025 move       $a0, $s3
0012D448 93C40266 lbu        $a0, 0x266($fp)
0012D44C A2200260 sb         $zero, 0x260($s1)
0012D450 24840001 addiu      $a0, $a0, 1
0012D454 A3C40266 sb         $a0, 0x266($fp)
0012D458 26100001 addiu      $s0, $s0, 1
0012D45C 2652003C addiu      $s2, $s2, 0x3c
0012D460 2673003C addiu      $s3, $s3, 0x3c
0012D464 2E040003 sltiu      $a0, $s0, 3
0012D468 1480FFB5 bnez       $a0, 0x12d340
0012D46C 26B5000C addiu      $s5, $s5, 0xc
0012D470 93C4025D lbu        $a0, 0x25d($fp)
0012D474 1080004A beqz       $a0, 0x12d5a0
0012D478 00000000 nop        
0012D47C 3C043F00 lui        $a0, 0x3f00
0012D480 34120000 ori        $s2, $zero, 0
0012D484 4484A000 mtc1       $a0, $f20
0012D488 27B40084 addiu      $s4, $sp, 0x84
0012D48C 27D1013C addiu      $s1, $fp, 0x13c
0012D490 3C17002D lui        $s7, 0x2d
0012D494 3C16002D lui        $s6, 0x2d
0012D498 3C13002D lui        $s3, 0x2d
0012D49C 3C15002D lui        $s5, 0x2d
0012D4A0 02208025 move       $s0, $s1
0012D4A4 0C037334 jal        0xdccd0
0012D4A8 02002025 move       $a0, $s0
0012D4AC 00022602 srl        $a0, $v0, 0x18
0012D4B0 2484FFE2 addiu      $a0, $a0, -0x1e
0012D4B4 00042400 sll        $a0, $a0, 0x10
0012D4B8 00042403 sra        $a0, $a0, 0x10
0012D4BC 1C800005 bgtz       $a0, 0x12d4d4
0012D4C0 02002825 move       $a1, $s0
0012D4C4 0C03732A jal        0xdcca8
0012D4C8 02002025 move       $a0, $s0
0012D4CC 1000002E b          0x12d588
0012D4D0 A3C0025D sb         $zero, 0x25d($fp)
0012D4D4 8FC6000C lw         $a2, 0xc($fp)
0012D4D8 00048600 sll        $s0, $a0, 0x18
0012D4DC 8CC40000 lw         $a0, ($a2)
0012D4E0 3C060100 lui        $a2, 0x100
0012D4E4 24C6FFFF addiu      $a2, $a2, -1
0012D4E8 00862024 and        $a0, $a0, $a2
0012D4EC 00908025 or         $s0, $a0, $s0
0012D4F0 00A02025 move       $a0, $a1
0012D4F4 0C037331 jal        0xdccc4
0012D4F8 02002825 move       $a1, $s0
0012D4FC 93C4025F lbu        $a0, 0x25f($fp)
0012D500 10800021 beqz       $a0, 0x12d588
0012D504 00000000 nop        
0012D508 8FA40094 lw         $a0, 0x94($sp)
0012D50C C6EC0764 lwc1       $f12, 0x764($s7)
0012D510 C48D0020 lwc1       $f13, 0x20($a0)
0012D514 C48E0030 lwc1       $f14, 0x30($a0)
0012D518 C48F0024 lwc1       $f15, 0x24($a0)
0012D51C 460C6B42 mul.s      $f13, $f13, $f12
0012D520 C4900034 lwc1       $f16, 0x34($a0)
0012D524 460C7BC2 mul.s      $f15, $f15, $f12
0012D528 C4910028 lwc1       $f17, 0x28($a0)
0012D52C C4920038 lwc1       $f18, 0x38($a0)
0012D530 460D7340 add.s      $f13, $f14, $f13
0012D534 8EC507AC lw         $a1, 0x7ac($s6)
0012D538 460C8B02 mul.s      $f12, $f17, $f12
0012D53C 02802025 move       $a0, $s4
0012D540 460F83C0 add.s      $f15, $f16, $f15
0012D544 02003025 move       $a2, $s0
0012D548 E7AD0084 swc1       $f13, 0x84($sp)
0012D54C C66D0760 lwc1       $f13, 0x760($s3)
0012D550 460C9480 add.s      $f18, $f18, $f12
0012D554 00003825 move       $a3, $zero
0012D558 E7AF0088 swc1       $f15, 0x88($sp)
0012D55C 46006B06 mov.s      $f12, $f13
0012D560 0C024046 jal        0x90118
0012D564 E7B2008C swc1       $f18, 0x8c($sp)
0012D568 C66C0760 lwc1       $f12, 0x760($s3)
0012D56C 8EA507B0 lw         $a1, 0x7b0($s5)
0012D570 46146302 mul.s      $f12, $f12, $f20
0012D574 02802025 move       $a0, $s4
0012D578 02003025 move       $a2, $s0
0012D57C 00003825 move       $a3, $zero
0012D580 0C024046 jal        0x90118
0012D584 46006346 mov.s      $f13, $f12
0012D588 26520001 addiu      $s2, $s2, 1
0012D58C 2E440002 sltiu      $a0, $s2, 2
0012D590 1480FFC3 bnez       $a0, 0x12d4a0
0012D594 2631005C addiu      $s1, $s1, 0x5c
0012D598 10000008 b          0x12d5bc
0012D59C 00000000 nop        
0012D5A0 8FA40094 lw         $a0, 0x94($sp)
0012D5A4 34050003 ori        $a1, $zero, 3
0012D5A8 90860045 lbu        $a2, 0x45($a0)
0012D5AC 14C50003 bne        $a2, $a1, 0x12d5bc
0012D5B0 00000000 nop        
0012D5B4 0C01A8F0 jal        0x6a3c0
0012D5B8 34050001 ori        $a1, $zero, 1
0012D5BC C7B4009C lwc1       $f20, 0x9c($sp)
0012D5C0 C7B600A0 lwc1       $f22, 0xa0($sp)
0012D5C4 C7B800A4 lwc1       $f24, 0xa4($sp)
0012D5C8 C7BA00A8 lwc1       $f26, 0xa8($sp)
0012D5CC C7BC00AC lwc1       $f28, 0xac($sp)
0012D5D0 C7BE00B0 lwc1       $f30, 0xb0($sp)
0012D5D4 8FB000B4 lw         $s0, 0xb4($sp)
0012D5D8 8FB100B8 lw         $s1, 0xb8($sp)
0012D5DC 8FB200BC lw         $s2, 0xbc($sp)
0012D5E0 8FB300C0 lw         $s3, 0xc0($sp)
0012D5E4 8FB400C4 lw         $s4, 0xc4($sp)
0012D5E8 8FB500C8 lw         $s5, 0xc8($sp)
0012D5EC 8FB600CC lw         $s6, 0xcc($sp)
0012D5F0 8FB700D0 lw         $s7, 0xd0($sp)
0012D5F4 8FBE00D4 lw         $fp, 0xd4($sp)
0012D5F8 8FBF00D8 lw         $ra, 0xd8($sp)
0012D5FC 03E00008 jr         $ra
0012D600 27BD00E0 addiu      $sp, $sp, 0xe0