
CALLBACK 0x0014DF64 end 0x0014DF6C ordinal 0

0014DF64 03E00008 jr         $ra
0014DF68 34020001 ori        $v0, $zero, 1

CALLBACK 0x0014DF6C end 0x0014DFB0 ordinal 1

0014DF6C 27BDFFE0 addiu      $sp, $sp, -0x20
0014DF70 AFBF0018 sw         $ra, 0x18($sp)
0014DF74 8C840058 lw         $a0, 0x58($a0)
0014DF78 34050000 ori        $a1, $zero, 0
0014DF7C 24840008 addiu      $a0, $a0, 8
0014DF80 AFA50014 sw         $a1, 0x14($sp)
0014DF84 0C016464 jal        0x59190
0014DF88 AFA40010 sw         $a0, 0x10($sp)
0014DF8C 8FA50014 lw         $a1, 0x14($sp)
0014DF90 8FA40010 lw         $a0, 0x10($sp)
0014DF94 24A50001 addiu      $a1, $a1, 1
0014DF98 2CA60003 sltiu      $a2, $a1, 3
0014DF9C 14C0FFF8 bnez       $a2, 0x14df80
0014DFA0 2484003C addiu      $a0, $a0, 0x3c
0014DFA4 8FBF0018 lw         $ra, 0x18($sp)
0014DFA8 03E00008 jr         $ra
0014DFAC 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0014DFB0 end 0x0014E278 ordinal 2

0014DFB0 27BDFF90 addiu      $sp, $sp, -0x70
0014DFB4 AFB30048 sw         $s3, 0x48($sp)
0014DFB8 00809825 move       $s3, $a0
0014DFBC AFB0003C sw         $s0, 0x3c($sp)
0014DFC0 8E700058 lw         $s0, 0x58($s3)
0014DFC4 E7B40030 swc1       $f20, 0x30($sp)
0014DFC8 E7B60034 swc1       $f22, 0x34($sp)
0014DFCC E7B80038 swc1       $f24, 0x38($sp)
0014DFD0 AFB10040 sw         $s1, 0x40($sp)
0014DFD4 AFB20044 sw         $s2, 0x44($sp)
0014DFD8 AFB4004C sw         $s4, 0x4c($sp)
0014DFDC AFB50050 sw         $s5, 0x50($sp)
0014DFE0 AFB60054 sw         $s6, 0x54($sp)
0014DFE4 AFB70058 sw         $s7, 0x58($sp)
0014DFE8 AFBE005C sw         $fp, 0x5c($sp)
0014DFEC AFBF0060 sw         $ra, 0x60($sp)
0014DFF0 0C05389E jal        0x14e278
0014DFF4 8E040004 lw         $a0, 4($s0)
0014DFF8 14400003 bnez       $v0, 0x14e008
0014DFFC 920400D4 lbu        $a0, 0xd4($s0)
0014E000 10800005 beqz       $a0, 0x14e018
0014E004 00000000 nop        
0014E008 10800008 beqz       $a0, 0x14e02c
0014E00C 00000000 nop        
0014E010 1000000C b          0x14e044
0014E014 8E040000 lw         $a0, ($s0)
0014E018 02602025 move       $a0, $s3
0014E01C 0C0192FF jal        0x64bfc
0014E020 34050001 ori        $a1, $zero, 1
0014E024 10000085 b          0x14e23c
0014E028 00000000 nop        
0014E02C 8E040004 lw         $a0, 4($s0)
0014E030 260500C8 addiu      $a1, $s0, 0xc8
0014E034 00003025 move       $a2, $zero
0014E038 0C019ACE jal        0x66b38
0014E03C 00003825 move       $a3, $zero
0014E040 8E040000 lw         $a0, ($s0)
0014E044 24840030 addiu      $a0, $a0, 0x30
0014E048 C48C0000 lwc1       $f12, ($a0)
0014E04C 3C053F00 lui        $a1, 0x3f00
0014E050 E60C00BC swc1       $f12, 0xbc($s0)
0014E054 4485A000 mtc1       $a1, $f20
0014E058 C48C0004 lwc1       $f12, 4($a0)
0014E05C E60C00C0 swc1       $f12, 0xc0($s0)
0014E060 C60C00C0 lwc1       $f12, 0xc0($s0)
0014E064 C48D0008 lwc1       $f13, 8($a0)
0014E068 46146300 add.s      $f12, $f12, $f20
0014E06C 34040007 ori        $a0, $zero, 7
0014E070 E60D00C4 swc1       $f13, 0xc4($s0)
0014E074 2405FFFF addiu      $a1, $zero, -1
0014E078 0C007870 jal        0x1e1c0
0014E07C E60C00C0 swc1       $f12, 0xc0($s0)
0014E080 3C043480 lui        $a0, 0x3480
0014E084 4484B000 mtc1       $a0, $f22
0014E088 02009025 move       $s2, $s0
0014E08C 3C043F80 lui        $a0, 0x3f80
0014E090 3C16002A lui        $s6, 0x2a
0014E094 4484C000 mtc1       $a0, $f24
0014E098 34140000 ori        $s4, $zero, 0
0014E09C 341E0001 ori        $fp, $zero, 1
0014E0A0 245700DF addiu      $s7, $v0, 0xdf
0014E0A4 27B50020 addiu      $s5, $sp, 0x20
0014E0A8 26510008 addiu      $s1, $s2, 8
0014E0AC 26D6A864 addiu      $s6, $s6, -0x579c
0014E0B0 0C0164CE jal        0x59338
0014E0B4 02202025 move       $a0, $s1
0014E0B8 82440038 lb         $a0, 0x38($s2)
0014E0BC 149E004D bne        $a0, $fp, 0x14e1f4
0014E0C0 00000000 nop        
0014E0C4 920400D4 lbu        $a0, 0xd4($s0)
0014E0C8 1480004A bnez       $a0, 0x14e1f4
0014E0CC 00000000 nop        
0014E0D0 8E040004 lw         $a0, 4($s0)
0014E0D4 C66C0030 lwc1       $f12, 0x30($s3)
0014E0D8 24840030 addiu      $a0, $a0, 0x30
0014E0DC C48D0000 lwc1       $f13, ($a0)
0014E0E0 C66E0034 lwc1       $f14, 0x34($s3)
0014E0E4 460D6301 sub.s      $f12, $f12, $f13
0014E0E8 C66F0038 lwc1       $f15, 0x38($s3)
0014E0EC E7AC0020 swc1       $f12, 0x20($sp)
0014E0F0 C48D0004 lwc1       $f13, 4($a0)
0014E0F4 460C6402 mul.s      $f16, $f12, $f12
0014E0F8 460D7341 sub.s      $f13, $f14, $f13
0014E0FC E7AD0024 swc1       $f13, 0x24($sp)
0014E100 460D6C42 mul.s      $f17, $f13, $f13
0014E104 C48E0008 lwc1       $f14, 8($a0)
0014E108 460E7B81 sub.s      $f14, $f15, $f14
0014E10C 461183C0 add.s      $f15, $f16, $f17
0014E110 460E7482 mul.s      $f18, $f14, $f14
0014E114 46127BC0 add.s      $f15, $f15, $f18
0014E118 4616783C c.lt.s     $f15, $f22
0014E11C 00000000 nop        
0014E120 45000004 bc1f       0x14e134
0014E124 E7AE0028 swc1       $f14, 0x28($sp)
0014E128 8E040004 lw         $a0, 4($s0)
0014E12C 1000000B b          0x14e15c
0014E130 24850030 addiu      $a1, $a0, 0x30
0014E134 46007BC4 sqrt.s     $f15, $f15
0014E138 460FC3C3 div.s      $f15, $f24, $f15
0014E13C 460F6302 mul.s      $f12, $f12, $f15
0014E140 460F6B42 mul.s      $f13, $f13, $f15
0014E144 460F7382 mul.s      $f14, $f14, $f15
0014E148 E7AC0020 swc1       $f12, 0x20($sp)
0014E14C E7AD0024 swc1       $f13, 0x24($sp)
0014E150 E7AE0028 swc1       $f14, 0x28($sp)
0014E154 8E040004 lw         $a0, 4($s0)
0014E158 24850030 addiu      $a1, $a0, 0x30
0014E15C 00803025 move       $a2, $a0
0014E160 8CC70040 lw         $a3, 0x40($a2)
0014E164 8CE70020 lw         $a3, 0x20($a3)
0014E168 54E00004 bnel       $a3, $zero, 0x14e17c
0014E16C 00172100 sll        $a0, $s7, 4
0014E170 2406FFFF addiu      $a2, $zero, -1
0014E174 10000017 b          0x14e1d4
0014E178 8E050000 lw         $a1, ($s0)
0014E17C 00962021 addu       $a0, $a0, $s6
0014E180 8C880000 lw         $t0, ($a0)
0014E184 29090002 slti       $t1, $t0, 2
0014E188 15200006 bnez       $t1, 0x14e1a4
0014E18C C48C0004 lwc1       $f12, 4($a0)
0014E190 29080003 slti       $t0, $t0, 3
0014E194 11000003 beqz       $t0, 0x14e1a4
0014E198 00000000 nop        
0014E19C 10000001 b          0x14e1a4
0014E1A0 46146302 mul.s      $f12, $f12, $f20
0014E1A4 00E05025 move       $t2, $a3
0014E1A8 00A03825 move       $a3, $a1
0014E1AC 8C850008 lw         $a1, 8($a0)
0014E1B0 8C89000C lw         $t1, 0xc($a0)
0014E1B4 00C02025 move       $a0, $a2
0014E1B8 01203025 move       $a2, $t1
0014E1BC 02A04025 move       $t0, $s5
0014E1C0 0140F809 jalr       $t2
0014E1C4 02604825 move       $t1, $s3
0014E1C8 8E040004 lw         $a0, 4($s0)
0014E1CC 00403025 move       $a2, $v0
0014E1D0 8E050000 lw         $a1, ($s0)
0014E1D4 00C03825 move       $a3, $a2
0014E1D8 00803025 move       $a2, $a0
0014E1DC 00A02025 move       $a0, $a1
0014E1E0 0C003EC2 jal        0xfb08
0014E1E4 34050007 ori        $a1, $zero, 7
0014E1E8 34040001 ori        $a0, $zero, 1
0014E1EC 10000007 b          0x14e20c
0014E1F0 A20400D4 sb         $a0, 0xd4($s0)
0014E1F4 82240030 lb         $a0, 0x30($s1)
0014E1F8 38840003 xori       $a0, $a0, 3
0014E1FC 2C840001 sltiu      $a0, $a0, 1
0014E200 308400FF andi       $a0, $a0, 0xff
0014E204 14800008 bnez       $a0, 0x14e228
0014E208 00000000 nop        
0014E20C 26940001 addiu      $s4, $s4, 1
0014E210 2652003C addiu      $s2, $s2, 0x3c
0014E214 2E840003 sltiu      $a0, $s4, 3
0014E218 1480FFA5 bnez       $a0, 0x14e0b0
0014E21C 2631003C addiu      $s1, $s1, 0x3c
0014E220 10000006 b          0x14e23c
0014E224 00000000 nop        
0014E228 02602025 move       $a0, $s3
0014E22C 0C0192FF jal        0x64bfc
0014E230 34050001 ori        $a1, $zero, 1
0014E234 10000001 b          0x14e23c
0014E238 00000000 nop        
0014E23C C7B40030 lwc1       $f20, 0x30($sp)
0014E240 C7B60034 lwc1       $f22, 0x34($sp)
0014E244 C7B80038 lwc1       $f24, 0x38($sp)
0014E248 8FB0003C lw         $s0, 0x3c($sp)
0014E24C 8FB10040 lw         $s1, 0x40($sp)
0014E250 8FB20044 lw         $s2, 0x44($sp)
0014E254 8FB30048 lw         $s3, 0x48($sp)
0014E258 8FB4004C lw         $s4, 0x4c($sp)
0014E25C 8FB50050 lw         $s5, 0x50($sp)
0014E260 8FB60054 lw         $s6, 0x54($sp)
0014E264 8FB70058 lw         $s7, 0x58($sp)
0014E268 8FBE005C lw         $fp, 0x5c($sp)
0014E26C 8FBF0060 lw         $ra, 0x60($sp)
0014E270 03E00008 jr         $ra
0014E274 27BD0070 addiu      $sp, $sp, 0x70