
CALLBACK 0x0019ABB8 end 0x0019ABC0 ordinal 0

0019ABB8 03E00008 jr         $ra
0019ABBC 34020001 ori        $v0, $zero, 1

CALLBACK 0x0019ABC0 end 0x0019ABC8 ordinal 1

0019ABC0 03E00008 jr         $ra
0019ABC4 00000000 nop        

CALLBACK 0x0019ADF4 end 0x0019B940 ordinal 2

0019ADF4 27BDFEF0 addiu      $sp, $sp, -0x110
0019ADF8 AFB70104 sw         $s7, 0x104($sp)
0019ADFC 8C970058 lw         $s7, 0x58($a0)
0019AE00 AFBE0108 sw         $fp, 0x108($sp)
0019AE04 92E50041 lbu        $a1, 0x41($s7)
0019AE08 0080F025 move       $fp, $a0
0019AE0C 24A40001 addiu      $a0, $a1, 1
0019AE10 308500FF andi       $a1, $a0, 0xff
0019AE14 A2E40041 sb         $a0, 0x41($s7)
0019AE18 28A40002 slti       $a0, $a1, 2
0019AE1C E7B400D8 swc1       $f20, 0xd8($sp)
0019AE20 E7B600DC swc1       $f22, 0xdc($sp)
0019AE24 E7B800E0 swc1       $f24, 0xe0($sp)
0019AE28 E7BA00E4 swc1       $f26, 0xe4($sp)
0019AE2C AFB000E8 sw         $s0, 0xe8($sp)
0019AE30 AFB100EC sw         $s1, 0xec($sp)
0019AE34 AFB200F0 sw         $s2, 0xf0($sp)
0019AE38 AFB300F4 sw         $s3, 0xf4($sp)
0019AE3C AFB400F8 sw         $s4, 0xf8($sp)
0019AE40 AFB500FC sw         $s5, 0xfc($sp)
0019AE44 AFB60100 sw         $s6, 0x100($sp)
0019AE48 AFBF010C sw         $ra, 0x10c($sp)
0019AE4C 1480000D bnez       $a0, 0x19ae84
0019AE50 00000000 nop        
0019AE54 C7CC0070 lwc1       $f12, 0x70($fp)
0019AE58 3C043F80 lui        $a0, 0x3f80
0019AE5C 4484A000 mtc1       $a0, $f20
0019AE60 46146300 add.s      $f12, $f12, $f20
0019AE64 3C04002E lui        $a0, 0x2e
0019AE68 C48DA704 lwc1       $f13, -0x58fc($a0)
0019AE6C 460D603E c.le.s     $f12, $f13
0019AE70 00000000 nop        
0019AE74 45000005 bc1f       0x19ae8c
0019AE78 E7CC0070 swc1       $f12, 0x70($fp)
0019AE7C 10000038 b          0x19af60
0019AE80 00000000 nop        
0019AE84 1000029E b          0x19b900
0019AE88 00000000 nop        
0019AE8C 8EE4003C lw         $a0, 0x3c($s7)
0019AE90 2C840003 sltiu      $a0, $a0, 3
0019AE94 14800018 bnez       $a0, 0x19aef8
0019AE98 27D70030 addiu      $s7, $fp, 0x30
0019AE9C 34040006 ori        $a0, $zero, 6
0019AEA0 0C03467E jal        0xd19f8
0019AEA4 02E02825 move       $a1, $s7
0019AEA8 0C007AEB jal        0x1ebac
0019AEAC 34040005 ori        $a0, $zero, 5
0019AEB0 0040B825 move       $s7, $v0
0019AEB4 12E00025 beqz       $s7, 0x19af4c
0019AEB8 00000000 nop        
0019AEBC C6EC0014 lwc1       $f12, 0x14($s7)
0019AEC0 C6ED0018 lwc1       $f13, 0x18($s7)
0019AEC4 C6EE001C lwc1       $f14, 0x1c($s7)
0019AEC8 C6EF0020 lwc1       $f15, 0x20($s7)
0019AECC 34070000 ori        $a3, $zero, 0
0019AED0 34090000 ori        $t1, $zero, 0
0019AED4 340A0000 ori        $t2, $zero, 0
0019AED8 340B0001 ori        $t3, $zero, 1
0019AEDC 03C02025 move       $a0, $fp
0019AEE0 02E02825 move       $a1, $s7
0019AEE4 00003025 move       $a2, $zero
0019AEE8 0C01B147 jal        0x6c51c
0019AEEC 00004025 move       $t0, $zero
0019AEF0 10000016 b          0x19af4c
0019AEF4 00000000 nop        
0019AEF8 34040007 ori        $a0, $zero, 7
0019AEFC 0C03467E jal        0xd19f8
0019AF00 02E02825 move       $a1, $s7
0019AF04 0C007AEB jal        0x1ebac
0019AF08 34040003 ori        $a0, $zero, 3
0019AF0C 0040B825 move       $s7, $v0
0019AF10 12E0000E beqz       $s7, 0x19af4c
0019AF14 00000000 nop        
0019AF18 C6EC0014 lwc1       $f12, 0x14($s7)
0019AF1C C6ED0018 lwc1       $f13, 0x18($s7)
0019AF20 C6EE001C lwc1       $f14, 0x1c($s7)
0019AF24 C6EF0020 lwc1       $f15, 0x20($s7)
0019AF28 34070000 ori        $a3, $zero, 0
0019AF2C 34090000 ori        $t1, $zero, 0
0019AF30 340A0000 ori        $t2, $zero, 0
0019AF34 340B0001 ori        $t3, $zero, 1
0019AF38 03C02025 move       $a0, $fp
0019AF3C 02E02825 move       $a1, $s7
0019AF40 00003025 move       $a2, $zero
0019AF44 0C01B147 jal        0x6c51c
0019AF48 00004025 move       $t0, $zero
0019AF4C 03C02025 move       $a0, $fp
0019AF50 0C01A8F0 jal        0x6a3c0
0019AF54 34050001 ori        $a1, $zero, 1
0019AF58 10000269 b          0x19b900
0019AF5C 00000000 nop        
0019AF60 34040028 ori        $a0, $zero, 0x28
0019AF64 AFA400D4 sw         $a0, 0xd4($sp)
0019AF68 34060000 ori        $a2, $zero, 0
0019AF6C 8FC50040 lw         $a1, 0x40($fp)
0019AF70 AFA600D0 sw         $a2, 0xd0($sp)
0019AF74 3C04002E lui        $a0, 0x2e
0019AF78 C496A71C lwc1       $f22, -0x58e4($a0)
0019AF7C 90A40048 lbu        $a0, 0x48($a1)
0019AF80 1080000F beqz       $a0, 0x19afc0
0019AF84 3C06002E lui        $a2, 0x2e
0019AF88 93C70044 lbu        $a3, 0x44($fp)
0019AF8C 44806800 mtc1       $zero, $f13
0019AF90 8CA50004 lw         $a1, 4($a1)
0019AF94 00074100 sll        $t0, $a3, 4
0019AF98 00E83821 addu       $a3, $a3, $t0
0019AF9C 00073880 sll        $a3, $a3, 2
0019AFA0 00E83823 subu       $a3, $a3, $t0
0019AFA4 00A72821 addu       $a1, $a1, $a3
0019AFA8 C4AC0028 lwc1       $f12, 0x28($a1)
0019AFAC 460D6032 c.eq.s     $f12, $f13
0019AFB0 00000000 nop        
0019AFB4 45010002 bc1t       0x19afc0
0019AFB8 00000000 nop        
0019AFBC 46006586 mov.s      $f22, $f12
0019AFC0 10800012 beqz       $a0, 0x19b00c
0019AFC4 00000000 nop        
0019AFC8 C6EC0008 lwc1       $f12, 8($s7)
0019AFCC C7CD0010 lwc1       $f13, 0x10($fp)
0019AFD0 460CB302 mul.s      $f12, $f22, $f12
0019AFD4 C7CE0030 lwc1       $f14, 0x30($fp)
0019AFD8 C7CF0014 lwc1       $f15, 0x14($fp)
0019AFDC C7D00034 lwc1       $f16, 0x34($fp)
0019AFE0 C7D10018 lwc1       $f17, 0x18($fp)
0019AFE4 460C6B42 mul.s      $f13, $f13, $f12
0019AFE8 C7D20038 lwc1       $f18, 0x38($fp)
0019AFEC 460C7BC2 mul.s      $f15, $f15, $f12
0019AFF0 460D7340 add.s      $f13, $f14, $f13
0019AFF4 460C8B02 mul.s      $f12, $f17, $f12
0019AFF8 460F83C0 add.s      $f15, $f16, $f15
0019AFFC E7CD0030 swc1       $f13, 0x30($fp)
0019B000 460C9300 add.s      $f12, $f18, $f12
0019B004 E7CF0034 swc1       $f15, 0x34($fp)
0019B008 E7CC0038 swc1       $f12, 0x38($fp)
0019B00C 92E40040 lbu        $a0, 0x40($s7)
0019B010 10800004 beqz       $a0, 0x19b024
0019B014 C6F8001C lwc1       $f24, 0x1c($s7)
0019B018 2484FFFF addiu      $a0, $a0, -1
0019B01C A2E40040 sb         $a0, 0x40($s7)
0019B020 92E40040 lbu        $a0, 0x40($s7)
0019B024 C4CCA710 lwc1       $f12, -0x58f0($a2)
0019B028 460CC303 div.s      $f12, $f24, $f12
0019B02C 46146300 add.s      $f12, $f12, $f20
0019B030 4600630D trunc.w.s  $f12, $f12
0019B034 14800158 bnez       $a0, 0x19b598
0019B038 44166000 mfc1       $s6, $f12
0019B03C 34100000 ori        $s0, $zero, 0
0019B040 0216202A slt        $a0, $s0, $s6
0019B044 1080014D beqz       $a0, 0x19b57c
0019B048 00000000 nop        
0019B04C 4496C000 mtc1       $s6, $f24
0019B050 27B40048 addiu      $s4, $sp, 0x48
0019B054 4680C620 cvt.s.w    $f24, $f24
0019B058 27B3004C addiu      $s3, $sp, 0x4c
0019B05C 27B20030 addiu      $s2, $sp, 0x30
0019B060 27B10058 addiu      $s1, $sp, 0x58
0019B064 34150002 ori        $s5, $zero, 2
0019B068 26100001 addiu      $s0, $s0, 1
0019B06C 44906000 mtc1       $s0, $f12
0019B070 C6ED001C lwc1       $f13, 0x1c($s7)
0019B074 46806320 cvt.s.w    $f12, $f12
0019B078 C6EF0010 lwc1       $f15, 0x10($s7)
0019B07C 460D6302 mul.s      $f12, $f12, $f13
0019B080 46186383 div.s      $f14, $f12, $f24
0019B084 C7D00030 lwc1       $f16, 0x30($fp)
0019B088 C7D10034 lwc1       $f17, 0x34($fp)
0019B08C C7D20038 lwc1       $f18, 0x38($fp)
0019B090 3C08002E lui        $t0, 0x2e
0019B094 02802025 move       $a0, $s4
0019B098 02602825 move       $a1, $s3
0019B09C 02403025 move       $a2, $s2
0019B0A0 02203825 move       $a3, $s1
0019B0A4 460E7B42 mul.s      $f13, $f15, $f14
0019B0A8 C50CA710 lwc1       $f12, -0x58f0($t0)
0019B0AC 8FA800D4 lw         $t0, 0xd4($sp)
0019B0B0 8FA900D0 lw         $t1, 0xd0($sp)
0019B0B4 460D8340 add.s      $f13, $f16, $f13
0019B0B8 E7AD0058 swc1       $f13, 0x58($sp)
0019B0BC C6ED0014 lwc1       $f13, 0x14($s7)
0019B0C0 460E6B42 mul.s      $f13, $f13, $f14
0019B0C4 460D8B40 add.s      $f13, $f17, $f13
0019B0C8 E7AD005C swc1       $f13, 0x5c($sp)
0019B0CC C6ED0018 lwc1       $f13, 0x18($s7)
0019B0D0 460E6B42 mul.s      $f13, $f13, $f14
0019B0D4 460D9340 add.s      $f13, $f18, $f13
0019B0D8 0C0070C2 jal        0x1c308
0019B0DC E7AD0060 swc1       $f13, 0x60($sp)
0019B0E0 10400123 beqz       $v0, 0x19b570
0019B0E4 00000000 nop        
0019B0E8 8FA40044 lw         $a0, 0x44($sp)
0019B0EC 1495000B bne        $a0, $s5, 0x19b11c
0019B0F0 00000000 nop        
0019B0F4 8EE60000 lw         $a2, ($s7)
0019B0F8 8FA50040 lw         $a1, 0x40($sp)
0019B0FC 8CC60594 lw         $a2, 0x594($a2)
0019B100 10A60004 beq        $a1, $a2, 0x19b114
0019B104 00000000 nop        
0019B108 8EE60004 lw         $a2, 4($s7)
0019B10C 14A60003 bne        $a1, $a2, 0x19b11c
0019B110 00000000 nop        
0019B114 10000116 b          0x19b570
0019B118 00000000 nop        
0019B11C 149500C1 bne        $a0, $s5, 0x19b424
0019B120 00000000 nop        
0019B124 8FA40040 lw         $a0, 0x40($sp)
0019B128 8C850040 lw         $a1, 0x40($a0)
0019B12C 8CA50020 lw         $a1, 0x20($a1)
0019B130 10A000BC beqz       $a1, 0x19b424
0019B134 00000000 nop        
0019B138 27B000A4 addiu      $s0, $sp, 0xa4
0019B13C 02002825 move       $a1, $s0
0019B140 00003025 move       $a2, $zero
0019B144 0C01B0C6 jal        0x6c318
0019B148 00003825 move       $a3, $zero
0019B14C 8EE4003C lw         $a0, 0x3c($s7)
0019B150 2C850003 sltiu      $a1, $a0, 3
0019B154 54A00057 bnel       $a1, $zero, 0x19b2b4
0019B158 C6EC0010 lwc1       $f12, 0x10($s7)
0019B15C 92E50043 lbu        $a1, 0x43($s7)
0019B160 54A00054 bnel       $a1, $zero, 0x19b2b4
0019B164 C6EC0010 lwc1       $f12, 0x10($s7)
0019B168 248500C6 addiu      $a1, $a0, 0xc6
0019B16C 27D10030 addiu      $s1, $fp, 0x30
0019B170 8EE70000 lw         $a3, ($s7)
0019B174 3C02002E lui        $v0, 0x2e
0019B178 02202025 move       $a0, $s1
0019B17C 03C03025 move       $a2, $fp
0019B180 3408000C ori        $t0, $zero, 0xc
0019B184 34090129 ori        $t1, $zero, 0x129
0019B188 340A0101 ori        $t2, $zero, 0x101
0019B18C 340B0036 ori        $t3, $zero, 0x36
0019B190 0C04030C jal        0x100c30
0019B194 C44CA714 lwc1       $f12, -0x58ec($v0)
0019B198 C6EC0010 lwc1       $f12, 0x10($s7)
0019B19C E7AC00B0 swc1       $f12, 0xb0($sp)
0019B1A0 C6EC0014 lwc1       $f12, 0x14($s7)
0019B1A4 E7AC00B4 swc1       $f12, 0xb4($sp)
0019B1A8 C6EC0018 lwc1       $f12, 0x18($s7)
0019B1AC E7B400BC swc1       $f20, 0xbc($sp)
0019B1B0 E7AC00B8 swc1       $f12, 0xb8($sp)
0019B1B4 8FA80040 lw         $t0, 0x40($sp)
0019B1B8 8EE4003C lw         $a0, 0x3c($s7)
0019B1BC 8D050040 lw         $a1, 0x40($t0)
0019B1C0 8CA50020 lw         $a1, 0x20($a1)
0019B1C4 14A00004 bnez       $a1, 0x19b1d8
0019B1C8 248400B6 addiu      $a0, $a0, 0xb6
0019B1CC 2405FFFF addiu      $a1, $zero, -1
0019B1D0 1000001C b          0x19b244
0019B1D4 8EE40000 lw         $a0, ($s7)
0019B1D8 3C06002D lui        $a2, 0x2d
0019B1DC 00042100 sll        $a0, $a0, 4
0019B1E0 24C6B0CC addiu      $a2, $a2, -0x4f34
0019B1E4 00863821 addu       $a3, $a0, $a2
0019B1E8 8CE40000 lw         $a0, ($a3)
0019B1EC 8CE60008 lw         $a2, 8($a3)
0019B1F0 C4EC0004 lwc1       $f12, 4($a3)
0019B1F4 28890002 slti       $t1, $a0, 2
0019B1F8 15200007 bnez       $t1, 0x19b218
0019B1FC 8CE7000C lw         $a3, 0xc($a3)
0019B200 28840003 slti       $a0, $a0, 3
0019B204 10800004 beqz       $a0, 0x19b218
0019B208 3C043F00 lui        $a0, 0x3f00
0019B20C 44846800 mtc1       $a0, $f13
0019B210 10000001 b          0x19b218
0019B214 460D6302 mul.s      $f12, $f12, $f13
0019B218 00A05025 move       $t2, $a1
0019B21C 00C02825 move       $a1, $a2
0019B220 01002025 move       $a0, $t0
0019B224 00E03025 move       $a2, $a3
0019B228 27A800B0 addiu      $t0, $sp, 0xb0
0019B22C 02203825 move       $a3, $s1
0019B230 0140F809 jalr       $t2
0019B234 03C04825 move       $t1, $fp
0019B238 8FA80040 lw         $t0, 0x40($sp)
0019B23C 00402825 move       $a1, $v0
0019B240 8EE40000 lw         $a0, ($s7)
0019B244 00A03825 move       $a3, $a1
0019B248 3405000C ori        $a1, $zero, 0xc
0019B24C 0C004249 jal        0x10924
0019B250 01003025 move       $a2, $t0
0019B254 34040006 ori        $a0, $zero, 6
0019B258 0C03467E jal        0xd19f8
0019B25C 02002825 move       $a1, $s0
0019B260 0C007AEB jal        0x1ebac
0019B264 34040005 ori        $a0, $zero, 5
0019B268 00408025 move       $s0, $v0
0019B26C 1200000E beqz       $s0, 0x19b2a8
0019B270 00000000 nop        
0019B274 C60C0014 lwc1       $f12, 0x14($s0)
0019B278 C60D0018 lwc1       $f13, 0x18($s0)
0019B27C C60E001C lwc1       $f14, 0x1c($s0)
0019B280 C60F0020 lwc1       $f15, 0x20($s0)
0019B284 34070000 ori        $a3, $zero, 0
0019B288 34090000 ori        $t1, $zero, 0
0019B28C 340A0000 ori        $t2, $zero, 0
0019B290 340B0001 ori        $t3, $zero, 1
0019B294 03C02025 move       $a0, $fp
0019B298 02002825 move       $a1, $s0
0019B29C 00003025 move       $a2, $zero
0019B2A0 0C01B147 jal        0x6c51c
0019B2A4 00004025 move       $t0, $zero
0019B2A8 8EE4003C lw         $a0, 0x3c($s7)
0019B2AC 1000004E b          0x19b3e8
0019B2B0 2C840001 sltiu      $a0, $a0, 1
0019B2B4 E7AC00C0 swc1       $f12, 0xc0($sp)
0019B2B8 C6EC0014 lwc1       $f12, 0x14($s7)
0019B2BC E7AC00C4 swc1       $f12, 0xc4($sp)
0019B2C0 C6EC0018 lwc1       $f12, 0x18($s7)
0019B2C4 E7B400CC swc1       $f20, 0xcc($sp)
0019B2C8 E7AC00C8 swc1       $f12, 0xc8($sp)
0019B2CC 92E50043 lbu        $a1, 0x43($s7)
0019B2D0 8EE7003C lw         $a3, 0x3c($s7)
0019B2D4 18A00003 blez       $a1, 0x19b2e4
0019B2D8 8FA40040 lw         $a0, 0x40($sp)
0019B2DC 10000002 b          0x19b2e8
0019B2E0 24E700BE addiu      $a3, $a3, 0xbe
0019B2E4 24E700B6 addiu      $a3, $a3, 0xb6
0019B2E8 00802825 move       $a1, $a0
0019B2EC 8CA60040 lw         $a2, 0x40($a1)
0019B2F0 8CC60020 lw         $a2, 0x20($a2)
0019B2F4 54C00004 bnel       $a2, $zero, 0x19b308
0019B2F8 00072100 sll        $a0, $a3, 4
0019B2FC 2406FFFF addiu      $a2, $zero, -1
0019B300 1000001E b          0x19b37c
0019B304 8EE50000 lw         $a1, ($s7)
0019B308 3C07002D lui        $a3, 0x2d
0019B30C 24E7B0CC addiu      $a3, $a3, -0x4f34
0019B310 00873821 addu       $a3, $a0, $a3
0019B314 8CE90000 lw         $t1, ($a3)
0019B318 8CE40008 lw         $a0, 8($a3)
0019B31C C4EC0004 lwc1       $f12, 4($a3)
0019B320 292A0002 slti       $t2, $t1, 2
0019B324 27C80030 addiu      $t0, $fp, 0x30
0019B328 15400007 bnez       $t2, 0x19b348
0019B32C 8CE7000C lw         $a3, 0xc($a3)
0019B330 29290003 slti       $t1, $t1, 3
0019B334 11200004 beqz       $t1, 0x19b348
0019B338 3C093F00 lui        $t1, 0x3f00
0019B33C 44896800 mtc1       $t1, $f13
0019B340 10000001 b          0x19b348
0019B344 460D6302 mul.s      $f12, $f12, $f13
0019B348 00C05025 move       $t2, $a2
0019B34C 00803025 move       $a2, $a0
0019B350 00A02025 move       $a0, $a1
0019B354 00C02825 move       $a1, $a2
0019B358 00E03025 move       $a2, $a3
0019B35C 27A900C0 addiu      $t1, $sp, 0xc0
0019B360 01003825 move       $a3, $t0
0019B364 01204025 move       $t0, $t1
0019B368 0140F809 jalr       $t2
0019B36C 03C04825 move       $t1, $fp
0019B370 8FA40040 lw         $a0, 0x40($sp)
0019B374 00403025 move       $a2, $v0
0019B378 8EE50000 lw         $a1, ($s7)
0019B37C 00C03825 move       $a3, $a2
0019B380 00803025 move       $a2, $a0
0019B384 00A02025 move       $a0, $a1
0019B388 0C004249 jal        0x10924
0019B38C 3405000C ori        $a1, $zero, 0xc
0019B390 34040007 ori        $a0, $zero, 7
0019B394 0C03467E jal        0xd19f8
0019B398 02002825 move       $a1, $s0
0019B39C 0C007AEB jal        0x1ebac
0019B3A0 34040003 ori        $a0, $zero, 3
0019B3A4 00402025 move       $a0, $v0
0019B3A8 1080000D beqz       $a0, 0x19b3e0
0019B3AC 00802825 move       $a1, $a0
0019B3B0 C4AC0014 lwc1       $f12, 0x14($a1)
0019B3B4 C4AD0018 lwc1       $f13, 0x18($a1)
0019B3B8 C4AE001C lwc1       $f14, 0x1c($a1)
0019B3BC C4AF0020 lwc1       $f15, 0x20($a1)
0019B3C0 34070000 ori        $a3, $zero, 0
0019B3C4 34090000 ori        $t1, $zero, 0
0019B3C8 340A0000 ori        $t2, $zero, 0
0019B3CC 340B0001 ori        $t3, $zero, 1
0019B3D0 03C02025 move       $a0, $fp
0019B3D4 00003025 move       $a2, $zero
0019B3D8 0C01B147 jal        0x6c51c
0019B3DC 00004025 move       $t0, $zero
0019B3E0 8EE4003C lw         $a0, 0x3c($s7)
0019B3E4 2C840001 sltiu      $a0, $a0, 1
0019B3E8 1480000C bnez       $a0, 0x19b41c
0019B3EC 00000000 nop        
0019B3F0 0C018E0C jal        0x63830
0019B3F4 8FA40040 lw         $a0, 0x40($sp)
0019B3F8 10400008 beqz       $v0, 0x19b41c
0019B3FC 00000000 nop        
0019B400 8EE5003C lw         $a1, 0x3c($s7)
0019B404 44806000 mtc1       $zero, $f12
0019B408 8FA40040 lw         $a0, 0x40($sp)
0019B40C 24A500CF addiu      $a1, $a1, 0xcf
0019B410 00003025 move       $a2, $zero
0019B414 0C018E99 jal        0x63a64
0019B418 00003825 move       $a3, $zero
0019B41C 1000003E b          0x19b518
0019B420 00000000 nop        
0019B424 8EE4003C lw         $a0, 0x3c($s7)
0019B428 2C850003 sltiu      $a1, $a0, 3
0019B42C 14A00025 bnez       $a1, 0x19b4c4
0019B430 27D00030 addiu      $s0, $fp, 0x30
0019B434 92E50043 lbu        $a1, 0x43($s7)
0019B438 14A00022 bnez       $a1, 0x19b4c4
0019B43C 00000000 nop        
0019B440 8EE70000 lw         $a3, ($s7)
0019B444 3C0B002E lui        $t3, 0x2e
0019B448 248500C6 addiu      $a1, $a0, 0xc6
0019B44C C56CA714 lwc1       $f12, -0x58ec($t3)
0019B450 02002025 move       $a0, $s0
0019B454 03C03025 move       $a2, $fp
0019B458 3408000C ori        $t0, $zero, 0xc
0019B45C 34090129 ori        $t1, $zero, 0x129
0019B460 340A0101 ori        $t2, $zero, 0x101
0019B464 0C04030C jal        0x100c30
0019B468 340B0036 ori        $t3, $zero, 0x36
0019B46C 34040006 ori        $a0, $zero, 6
0019B470 0C03467E jal        0xd19f8
0019B474 02002825 move       $a1, $s0
0019B478 0C007AEB jal        0x1ebac
0019B47C 34040005 ori        $a0, $zero, 5
0019B480 00402025 move       $a0, $v0
0019B484 1080000D beqz       $a0, 0x19b4bc
0019B488 00802825 move       $a1, $a0
0019B48C C4AC0014 lwc1       $f12, 0x14($a1)
0019B490 C4AD0018 lwc1       $f13, 0x18($a1)
0019B494 C4AE001C lwc1       $f14, 0x1c($a1)
0019B498 C4AF0020 lwc1       $f15, 0x20($a1)
0019B49C 34070000 ori        $a3, $zero, 0
0019B4A0 34090000 ori        $t1, $zero, 0
0019B4A4 340A0000 ori        $t2, $zero, 0
0019B4A8 340B0001 ori        $t3, $zero, 1
0019B4AC 03C02025 move       $a0, $fp
0019B4B0 00003025 move       $a2, $zero
0019B4B4 0C01B147 jal        0x6c51c
0019B4B8 00004025 move       $t0, $zero
0019B4BC 10000016 b          0x19b518
0019B4C0 00000000 nop        
0019B4C4 34040007 ori        $a0, $zero, 7
0019B4C8 0C03467E jal        0xd19f8
0019B4CC 02002825 move       $a1, $s0
0019B4D0 0C007AEB jal        0x1ebac
0019B4D4 34040003 ori        $a0, $zero, 3
0019B4D8 00408025 move       $s0, $v0
0019B4DC 1200000E beqz       $s0, 0x19b518
0019B4E0 00000000 nop        
0019B4E4 C60C0014 lwc1       $f12, 0x14($s0)
0019B4E8 C60D0018 lwc1       $f13, 0x18($s0)
0019B4EC C60E001C lwc1       $f14, 0x1c($s0)
0019B4F0 C60F0020 lwc1       $f15, 0x20($s0)
0019B4F4 34070000 ori        $a3, $zero, 0
0019B4F8 34090000 ori        $t1, $zero, 0
0019B4FC 340A0000 ori        $t2, $zero, 0
0019B500 340B0001 ori        $t3, $zero, 1
0019B504 03C02025 move       $a0, $fp
0019B508 02002825 move       $a1, $s0
0019B50C 00003025 move       $a2, $zero
0019B510 0C01B147 jal        0x6c51c
0019B514 00004025 move       $t0, $zero
0019B518 92E40042 lbu        $a0, 0x42($s7)
0019B51C 1080000F beqz       $a0, 0x19b55c
0019B520 00000000 nop        
0019B524 92E40043 lbu        $a0, 0x43($s7)
0019B528 28840003 slti       $a0, $a0, 3
0019B52C 1080000B beqz       $a0, 0x19b55c
0019B530 00000000 nop        
0019B534 0C066AFB jal        0x19abec
0019B538 03C02025 move       $a0, $fp
0019B53C 92E40043 lbu        $a0, 0x43($s7)
0019B540 C6F80008 lwc1       $f24, 8($s7)
0019B544 24840001 addiu      $a0, $a0, 1
0019B548 A2E40043 sb         $a0, 0x43($s7)
0019B54C 3C043480 lui        $a0, 0x3480
0019B550 C6EC000C lwc1       $f12, 0xc($s7)
0019B554 10000089 b          0x19b77c
0019B558 4484D000 mtc1       $a0, $f26
0019B55C 03C02025 move       $a0, $fp
0019B560 0C01A8F0 jal        0x6a3c0
0019B564 34050001 ori        $a1, $zero, 1
0019B568 100000E5 b          0x19b900
0019B56C 00000000 nop        
0019B570 0216202A slt        $a0, $s0, $s6
0019B574 1480FEBD bnez       $a0, 0x19b06c
0019B578 26100001 addiu      $s0, $s0, 1
0019B57C 3C053480 lui        $a1, 0x3480
0019B580 4480C000 mtc1       $zero, $f24
0019B584 27B00064 addiu      $s0, $sp, 0x64
0019B588 4485D000 mtc1       $a1, $f26
0019B58C 26E40020 addiu      $a0, $s7, 0x20
0019B590 10000016 b          0x19b5ec
0019B594 C6EC002C lwc1       $f12, 0x2c($s7)
0019B598 C6EC0010 lwc1       $f12, 0x10($s7)
0019B59C C7CD0030 lwc1       $f13, 0x30($fp)
0019B5A0 46186302 mul.s      $f12, $f12, $f24
0019B5A4 C7CE0034 lwc1       $f14, 0x34($fp)
0019B5A8 C7CF0038 lwc1       $f15, 0x38($fp)
0019B5AC 460C6B00 add.s      $f12, $f13, $f12
0019B5B0 3C053480 lui        $a1, 0x3480
0019B5B4 E7AC0058 swc1       $f12, 0x58($sp)
0019B5B8 C6EC0014 lwc1       $f12, 0x14($s7)
0019B5BC 46186302 mul.s      $f12, $f12, $f24
0019B5C0 27B00064 addiu      $s0, $sp, 0x64
0019B5C4 26E40020 addiu      $a0, $s7, 0x20
0019B5C8 4485D000 mtc1       $a1, $f26
0019B5CC 460C7300 add.s      $f12, $f14, $f12
0019B5D0 E7AC005C swc1       $f12, 0x5c($sp)
0019B5D4 C6EC0018 lwc1       $f12, 0x18($s7)
0019B5D8 46186302 mul.s      $f12, $f12, $f24
0019B5DC 460C7B00 add.s      $f12, $f15, $f12
0019B5E0 4480C000 mtc1       $zero, $f24
0019B5E4 E7AC0060 swc1       $f12, 0x60($sp)
0019B5E8 C6EC002C lwc1       $f12, 0x2c($s7)
0019B5EC 00802825 move       $a1, $a0
0019B5F0 0C03D16F jal        0xf45bc
0019B5F4 02002025 move       $a0, $s0
0019B5F8 C7D20020 lwc1       $f18, 0x20($fp)
0019B5FC C7D10024 lwc1       $f17, 0x24($fp)
0019B600 46129302 mul.s      $f12, $f18, $f18
0019B604 C7D00028 lwc1       $f16, 0x28($fp)
0019B608 46118B42 mul.s      $f13, $f17, $f17
0019B60C C7CF0010 lwc1       $f15, 0x10($fp)
0019B610 461084C2 mul.s      $f19, $f16, $f16
0019B614 C7CE0014 lwc1       $f14, 0x14($fp)
0019B618 460D6300 add.s      $f12, $f12, $f13
0019B61C 46136300 add.s      $f12, $f12, $f19
0019B620 461A603C c.lt.s     $f12, $f26
0019B624 00000000 nop        
0019B628 4500000B bc1f       0x19b658
0019B62C C7CD0018 lwc1       $f13, 0x18($fp)
0019B630 46107302 mul.s      $f12, $f14, $f16
0019B634 46116CC2 mul.s      $f19, $f13, $f17
0019B638 46107802 mul.s      $f0, $f15, $f16
0019B63C 46127382 mul.s      $f14, $f14, $f18
0019B640 46126B42 mul.s      $f13, $f13, $f18
0019B644 46117BC2 mul.s      $f15, $f15, $f17
0019B648 46136301 sub.s      $f12, $f12, $f19
0019B64C 46006B41 sub.s      $f13, $f13, $f0
0019B650 10000012 b          0x19b69c
0019B654 460E7B81 sub.s      $f14, $f15, $f14
0019B658 46006304 sqrt.s     $f12, $f12
0019B65C 460CA303 div.s      $f12, $f20, $f12
0019B660 460C9482 mul.s      $f18, $f18, $f12
0019B664 460C8C42 mul.s      $f17, $f17, $f12
0019B668 460C8402 mul.s      $f16, $f16, $f12
0019B66C 46126CC2 mul.s      $f19, $f13, $f18
0019B670 E7D20020 swc1       $f18, 0x20($fp)
0019B674 46116B02 mul.s      $f12, $f13, $f17
0019B678 46107002 mul.s      $f0, $f14, $f16
0019B67C E7D10024 swc1       $f17, 0x24($fp)
0019B680 E7D00028 swc1       $f16, 0x28($fp)
0019B684 46107B42 mul.s      $f13, $f15, $f16
0019B688 46127382 mul.s      $f14, $f14, $f18
0019B68C 460C0301 sub.s      $f12, $f0, $f12
0019B690 46117BC2 mul.s      $f15, $f15, $f17
0019B694 460D9B41 sub.s      $f13, $f19, $f13
0019B698 460E7B81 sub.s      $f14, $f15, $f14
0019B69C E7CD0004 swc1       $f13, 4($fp)
0019B6A0 460063C6 mov.s      $f15, $f12
0019B6A4 E7CE0008 swc1       $f14, 8($fp)
0019B6A8 460F7CC2 mul.s      $f19, $f15, $f15
0019B6AC E7CC0000 swc1       $f12, ($fp)
0019B6B0 460E7002 mul.s      $f0, $f14, $f14
0019B6B4 460D6B02 mul.s      $f12, $f13, $f13
0019B6B8 460C9B00 add.s      $f12, $f19, $f12
0019B6BC 46006300 add.s      $f12, $f12, $f0
0019B6C0 461A603C c.lt.s     $f12, $f26
0019B6C4 00000000 nop        
0019B6C8 4500000B bc1f       0x19b6f8
0019B6CC E7D8000C swc1       $f24, 0xc($fp)
0019B6D0 460D8302 mul.s      $f12, $f16, $f13
0019B6D4 460E8D02 mul.s      $f20, $f17, $f14
0019B6D8 460F8402 mul.s      $f16, $f16, $f15
0019B6DC 460E9382 mul.s      $f14, $f18, $f14
0019B6E0 460D9342 mul.s      $f13, $f18, $f13
0019B6E4 460CA501 sub.s      $f20, $f20, $f12
0019B6E8 460F8BC2 mul.s      $f15, $f17, $f15
0019B6EC 460E8381 sub.s      $f14, $f16, $f14
0019B6F0 10000012 b          0x19b73c
0019B6F4 460F6B01 sub.s      $f12, $f13, $f15
0019B6F8 46006304 sqrt.s     $f12, $f12
0019B6FC 460CA303 div.s      $f12, $f20, $f12
0019B700 460C7BC2 mul.s      $f15, $f15, $f12
0019B704 460C6B42 mul.s      $f13, $f13, $f12
0019B708 E7CF0000 swc1       $f15, ($fp)
0019B70C 460C7302 mul.s      $f12, $f14, $f12
0019B710 E7CD0004 swc1       $f13, 4($fp)
0019B714 460D8502 mul.s      $f20, $f16, $f13
0019B718 460C8CC2 mul.s      $f19, $f17, $f12
0019B71C E7CC0008 swc1       $f12, 8($fp)
0019B720 460F8382 mul.s      $f14, $f16, $f15
0019B724 460D9342 mul.s      $f13, $f18, $f13
0019B728 460C9302 mul.s      $f12, $f18, $f12
0019B72C 460F8BC2 mul.s      $f15, $f17, $f15
0019B730 46149D01 sub.s      $f20, $f19, $f20
0019B734 460C7381 sub.s      $f14, $f14, $f12
0019B738 460F6B01 sub.s      $f12, $f13, $f15
0019B73C E7D40010 swc1       $f20, 0x10($fp)
0019B740 E7CE0014 swc1       $f14, 0x14($fp)
0019B744 E7CC0018 swc1       $f12, 0x18($fp)
0019B748 E7D8001C swc1       $f24, 0x1c($fp)
0019B74C 03C02025 move       $a0, $fp
0019B750 03C02825 move       $a1, $fp
0019B754 0C03DF15 jal        0xf7c54
0019B758 02003025 move       $a2, $s0
0019B75C C7AC0058 lwc1       $f12, 0x58($sp)
0019B760 C7AD005C lwc1       $f13, 0x5c($sp)
0019B764 E7CC0030 swc1       $f12, 0x30($fp)
0019B768 C7AC0060 lwc1       $f12, 0x60($sp)
0019B76C E7CD0034 swc1       $f13, 0x34($fp)
0019B770 E7CC0038 swc1       $f12, 0x38($fp)
0019B774 C6F80008 lwc1       $f24, 8($s7)
0019B778 C6EC000C lwc1       $f12, 0xc($s7)
0019B77C 460CC03C c.lt.s     $f24, $f12
0019B780 00000000 nop        
0019B784 45000009 bc1f       0x19b7ac
0019B788 3C04002E lui        $a0, 0x2e
0019B78C C48DA6F4 lwc1       $f13, -0x590c($a0)
0019B790 460DC600 add.s      $f24, $f24, $f13
0019B794 460CC03E c.le.s     $f24, $f12
0019B798 00000000 nop        
0019B79C 45010003 bc1t       0x19b7ac
0019B7A0 E6F80008 swc1       $f24, 8($s7)
0019B7A4 E6EC0008 swc1       $f12, 8($s7)
0019B7A8 46006606 mov.s      $f24, $f12
0019B7AC C7CF0020 lwc1       $f15, 0x20($fp)
0019B7B0 C7D00024 lwc1       $f16, 0x24($fp)
0019B7B4 460F7B42 mul.s      $f13, $f15, $f15
0019B7B8 C7D10028 lwc1       $f17, 0x28($fp)
0019B7BC 46108382 mul.s      $f14, $f16, $f16
0019B7C0 8FC40040 lw         $a0, 0x40($fp)
0019B7C4 46118882 mul.s      $f2, $f17, $f17
0019B7C8 C7CC0010 lwc1       $f12, 0x10($fp)
0019B7CC 460E6CC0 add.s      $f19, $f13, $f14
0019B7D0 46029880 add.s      $f2, $f19, $f2
0019B7D4 C7CD0014 lwc1       $f13, 0x14($fp)
0019B7D8 C7CE0018 lwc1       $f14, 0x18($fp)
0019B7DC C7D20000 lwc1       $f18, ($fp)
0019B7E0 C7D30004 lwc1       $f19, 4($fp)
0019B7E4 461A103C c.lt.s     $f2, $f26
0019B7E8 00000000 nop        
0019B7EC 4501000A bc1t       0x19b818
0019B7F0 C7C00008 lwc1       $f0, 8($fp)
0019B7F4 46001084 sqrt.s     $f2, $f2
0019B7F8 4602C083 div.s      $f2, $f24, $f2
0019B7FC 46027BC2 mul.s      $f15, $f15, $f2
0019B800 46028402 mul.s      $f16, $f16, $f2
0019B804 46028C42 mul.s      $f17, $f17, $f2
0019B808 E7CF0020 swc1       $f15, 0x20($fp)
0019B80C E7D00024 swc1       $f16, 0x24($fp)
0019B810 E7D10028 swc1       $f17, 0x28($fp)
0019B814 C6F80008 lwc1       $f24, 8($s7)
0019B818 460C63C2 mul.s      $f15, $f12, $f12
0019B81C 460D6C02 mul.s      $f16, $f13, $f13
0019B820 460E7442 mul.s      $f17, $f14, $f14
0019B824 46107BC0 add.s      $f15, $f15, $f16
0019B828 46117BC0 add.s      $f15, $f15, $f17
0019B82C 461A783C c.lt.s     $f15, $f26
0019B830 00000000 nop        
0019B834 4503000B bc1tl      0x19b864
0019B838 46129302 mul.s      $f12, $f18, $f18
0019B83C 46007BC4 sqrt.s     $f15, $f15
0019B840 460FC3C3 div.s      $f15, $f24, $f15
0019B844 460F6302 mul.s      $f12, $f12, $f15
0019B848 460F6B42 mul.s      $f13, $f13, $f15
0019B84C 460F7382 mul.s      $f14, $f14, $f15
0019B850 E7CC0010 swc1       $f12, 0x10($fp)
0019B854 E7CD0014 swc1       $f13, 0x14($fp)
0019B858 E7CE0018 swc1       $f14, 0x18($fp)
0019B85C C6F80008 lwc1       $f24, 8($s7)
0019B860 46129302 mul.s      $f12, $f18, $f18
0019B864 46139B42 mul.s      $f13, $f19, $f19
0019B868 46000382 mul.s      $f14, $f0, $f0
0019B86C 460D6300 add.s      $f12, $f12, $f13
0019B870 460E6300 add.s      $f12, $f12, $f14
0019B874 461A603C c.lt.s     $f12, $f26
0019B878 00000000 nop        
0019B87C 45000003 bc1f       0x19b88c
0019B880 00000000 nop        
0019B884 1000000A b          0x19b8b0
0019B888 90840048 lbu        $a0, 0x48($a0)
0019B88C 46006304 sqrt.s     $f12, $f12
0019B890 460CC303 div.s      $f12, $f24, $f12
0019B894 460C9342 mul.s      $f13, $f18, $f12
0019B898 460C9B82 mul.s      $f14, $f19, $f12
0019B89C E7CD0000 swc1       $f13, ($fp)
0019B8A0 460C0302 mul.s      $f12, $f0, $f12
0019B8A4 E7CE0004 swc1       $f14, 4($fp)
0019B8A8 E7CC0008 swc1       $f12, 8($fp)
0019B8AC 90840048 lbu        $a0, 0x48($a0)
0019B8B0 10800013 beqz       $a0, 0x19b900
0019B8B4 00000000 nop        
0019B8B8 C6EC0008 lwc1       $f12, 8($s7)
0019B8BC C7CD0010 lwc1       $f13, 0x10($fp)
0019B8C0 460CB302 mul.s      $f12, $f22, $f12
0019B8C4 C7CE0030 lwc1       $f14, 0x30($fp)
0019B8C8 C7CF0014 lwc1       $f15, 0x14($fp)
0019B8CC C7D00034 lwc1       $f16, 0x34($fp)
0019B8D0 C7D10018 lwc1       $f17, 0x18($fp)
0019B8D4 46006307 neg.s      $f12, $f12
0019B8D8 C7D20038 lwc1       $f18, 0x38($fp)
0019B8DC 460C6B42 mul.s      $f13, $f13, $f12
0019B8E0 460C7BC2 mul.s      $f15, $f15, $f12
0019B8E4 460D7340 add.s      $f13, $f14, $f13
0019B8E8 460C8B02 mul.s      $f12, $f17, $f12
0019B8EC 460F83C0 add.s      $f15, $f16, $f15
0019B8F0 E7CD0030 swc1       $f13, 0x30($fp)
0019B8F4 460C9300 add.s      $f12, $f18, $f12
0019B8F8 E7CF0034 swc1       $f15, 0x34($fp)
0019B8FC E7CC0038 swc1       $f12, 0x38($fp)
0019B900 C7B400D8 lwc1       $f20, 0xd8($sp)
0019B904 C7B600DC lwc1       $f22, 0xdc($sp)
0019B908 C7B800E0 lwc1       $f24, 0xe0($sp)
0019B90C C7BA00E4 lwc1       $f26, 0xe4($sp)
0019B910 8FB000E8 lw         $s0, 0xe8($sp)
0019B914 8FB100EC lw         $s1, 0xec($sp)
0019B918 8FB200F0 lw         $s2, 0xf0($sp)
0019B91C 8FB300F4 lw         $s3, 0xf4($sp)
0019B920 8FB400F8 lw         $s4, 0xf8($sp)
0019B924 8FB500FC lw         $s5, 0xfc($sp)
0019B928 8FB60100 lw         $s6, 0x100($sp)
0019B92C 8FB70104 lw         $s7, 0x104($sp)
0019B930 8FBE0108 lw         $fp, 0x108($sp)
0019B934 8FBF010C lw         $ra, 0x10c($sp)
0019B938 03E00008 jr         $ra
0019B93C 27BD0110 addiu      $sp, $sp, 0x110