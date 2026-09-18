
CALLBACK 0x0012126C end 0x00121344 ordinal 0

0012126C 27BDFFD0 addiu      $sp, $sp, -0x30
00121270 AFB00020 sw         $s0, 0x20($sp)
00121274 00808025 move       $s0, $a0
00121278 AFB10024 sw         $s1, 0x24($sp)
0012127C 8E110058 lw         $s1, 0x58($s0)
00121280 00002825 move       $a1, $zero
00121284 02202025 move       $a0, $s1
00121288 AFB20028 sw         $s2, 0x28($sp)
0012128C AFBF002C sw         $ra, 0x2c($sp)
00121290 0C06B6A7 jal        0x1ada9c
00121294 34060044 ori        $a2, $zero, 0x44
00121298 2624001C addiu      $a0, $s1, 0x1c
0012129C 3C08002B lui        $t0, 0x2b
001212A0 34110001 ori        $s1, $zero, 1
001212A4 34050001 ori        $a1, $zero, 1
001212A8 34060044 ori        $a2, $zero, 0x44
001212AC 34070045 ori        $a3, $zero, 0x45
001212B0 0C019B8F jal        0x66e3c
001212B4 250828D8 addiu      $t0, $t0, 0x28d8
001212B8 3C04002B lui        $a0, 0x2b
001212BC 8C9200C0 lw         $s2, 0xc0($a0)
001212C0 26040074 addiu      $a0, $s0, 0x74
001212C4 8E4600F0 lw         $a2, 0xf0($s2)
001212C8 34050004 ori        $a1, $zero, 4
001212CC 0C0077E7 jal        0x1df9c
001212D0 2407FFFF addiu      $a3, $zero, -1
001212D4 8E040048 lw         $a0, 0x48($s0)
001212D8 3C050012 lui        $a1, 0x12
001212DC 24A51370 addiu      $a1, $a1, 0x1370
001212E0 AC8500DC sw         $a1, 0xdc($a0)
001212E4 3C05002D lui        $a1, 0x2d
001212E8 C4ACEA5C lwc1       $f12, -0x15a4($a1)
001212EC 3C05002D lui        $a1, 0x2d
001212F0 C4ADEA60 lwc1       $f13, -0x15a0($a1)
001212F4 3C05002D lui        $a1, 0x2d
001212F8 3C084120 lui        $t0, 0x4120
001212FC 3C06002D lui        $a2, 0x2d
00121300 44887000 mtc1       $t0, $f14
00121304 02402025 move       $a0, $s2
00121308 00003825 move       $a3, $zero
0012130C 24A5EA50 addiu      $a1, $a1, -0x15b0
00121310 0C01707F jal        0x5c1fc
00121314 24C6EA64 addiu      $a2, $a2, -0x159c
00121318 8E040064 lw         $a0, 0x64($s0)
0012131C 3C050004 lui        $a1, 4
00121320 00852025 or         $a0, $a0, $a1
00121324 AE040064 sw         $a0, 0x64($s0)
00121328 02201025 move       $v0, $s1
0012132C 8FB00020 lw         $s0, 0x20($sp)
00121330 8FB10024 lw         $s1, 0x24($sp)
00121334 8FB20028 lw         $s2, 0x28($sp)
00121338 8FBF002C lw         $ra, 0x2c($sp)
0012133C 03E00008 jr         $ra
00121340 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x00121344 end 0x00121370 ordinal 1

00121344 27BDFFE0 addiu      $sp, $sp, -0x20
00121348 8C840058 lw         $a0, 0x58($a0)
0012134C 8C840000 lw         $a0, ($a0)
00121350 AFBF0010 sw         $ra, 0x10($sp)
00121354 10800003 beqz       $a0, 0x121364
00121358 00000000 nop        
0012135C 0C00C2D1 jal        0x30b44
00121360 34050001 ori        $a1, $zero, 1
00121364 8FBF0010 lw         $ra, 0x10($sp)
00121368 03E00008 jr         $ra
0012136C 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x001217F4 end 0x00121D64 ordinal 2

001217F4 27BDFF30 addiu      $sp, $sp, -0xd0
001217F8 AFBE00BC sw         $fp, 0xbc($sp)
001217FC 0080F025 move       $fp, $a0
00121800 8FC40058 lw         $a0, 0x58($fp)
00121804 E7B40094 swc1       $f20, 0x94($sp)
00121808 AFB600B4 sw         $s6, 0xb4($sp)
0012180C 46006506 mov.s      $f20, $f12
00121810 00002825 move       $a1, $zero
00121814 8C960000 lw         $s6, ($a0)
00121818 E7B60098 swc1       $f22, 0x98($sp)
0012181C AFB0009C sw         $s0, 0x9c($sp)
00121820 AFB100A0 sw         $s1, 0xa0($sp)
00121824 AFB200A4 sw         $s2, 0xa4($sp)
00121828 AFB300A8 sw         $s3, 0xa8($sp)
0012182C AFB400AC sw         $s4, 0xac($sp)
00121830 AFB500B0 sw         $s5, 0xb0($sp)
00121834 AFB700B8 sw         $s7, 0xb8($sp)
00121838 AFBF00C0 sw         $ra, 0xc0($sp)
0012183C 0C00C2D1 jal        0x30b44
00121840 02C02025 move       $a0, $s6
00121844 8FD70058 lw         $s7, 0x58($fp)
00121848 8EC500F0 lw         $a1, 0xf0($s6)
0012184C 0C007DC7 jal        0x1f71c
00121850 34040004 ori        $a0, $zero, 4
00121854 27A40020 addiu      $a0, $sp, 0x20
00121858 0C00C4D4 jal        0x31350
0012185C 02C02825 move       $a1, $s6
00121860 34100000 ori        $s0, $zero, 0
00121864 0C00C41E jal        0x31078
00121868 02C02025 move       $a0, $s6
0012186C 10400006 beqz       $v0, 0x121888
00121870 4480B000 mtc1       $zero, $f22
00121874 0C016FD5 jal        0x5bf54
00121878 02C02025 move       $a0, $s6
0012187C 10400002 beqz       $v0, 0x121888
00121880 00000000 nop        
00121884 34100001 ori        $s0, $zero, 1
00121888 C6EC0018 lwc1       $f12, 0x18($s7)
0012188C 46166032 c.eq.s     $f12, $f22
00121890 00000000 nop        
00121894 4501001B bc1t       0x121904
00121898 321300FF andi       $s3, $s0, 0xff
0012189C 46146301 sub.s      $f12, $f12, $f20
001218A0 02C02025 move       $a0, $s6
001218A4 0C00C426 jal        0x31098
001218A8 E6EC0018 swc1       $f12, 0x18($s7)
001218AC C6EC0018 lwc1       $f12, 0x18($s7)
001218B0 4616603E c.le.s     $f12, $f22
001218B4 00000000 nop        
001218B8 4501000F bc1t       0x1218f8
001218BC 00402025 move       $a0, $v0
001218C0 8FA50020 lw         $a1, 0x20($sp)
001218C4 30A50020 andi       $a1, $a1, 0x20
001218C8 10A0000E beqz       $a1, 0x121904
001218CC 3405001E ori        $a1, $zero, 0x1e
001218D0 1085000C beq        $a0, $a1, 0x121904
001218D4 3C04002D lui        $a0, 0x2d
001218D8 C48DEA44 lwc1       $f13, -0x15bc($a0)
001218DC 3C04002D lui        $a0, 0x2d
001218E0 C48EEA48 lwc1       $f14, -0x15b8($a0)
001218E4 460E6B41 sub.s      $f13, $f13, $f14
001218E8 460D603E c.le.s     $f12, $f13
001218EC 00000000 nop        
001218F0 45000004 bc1f       0x121904
001218F4 00000000 nop        
001218F8 E6F60018 swc1       $f22, 0x18($s7)
001218FC 34040001 ori        $a0, $zero, 1
00121900 A3C40046 sb         $a0, 0x46($fp)
00121904 C6EC0014 lwc1       $f12, 0x14($s7)
00121908 46146301 sub.s      $f12, $f12, $f20
0012190C 4616603C c.lt.s     $f12, $f22
00121910 00000000 nop        
00121914 45000002 bc1f       0x121920
00121918 E6EC0014 swc1       $f12, 0x14($s7)
0012191C E6F60014 swc1       $f22, 0x14($s7)
00121920 8EE40010 lw         $a0, 0x10($s7)
00121924 34050004 ori        $a1, $zero, 4
00121928 14850007 bne        $a0, $a1, 0x121948
0012192C 00000000 nop        
00121930 03C02025 move       $a0, $fp
00121934 0C01AA82 jal        0x6aa08
00121938 00002825 move       $a1, $zero
0012193C 10400002 beqz       $v0, 0x121948
00121940 00000000 nop        
00121944 A3C00045 sb         $zero, 0x45($fp)
00121948 A3B30091 sb         $s3, 0x91($sp)
0012194C 0C00C4BD jal        0x312f4
00121950 02C02025 move       $a0, $s6
00121954 C44C0020 lwc1       $f12, 0x20($v0)
00121958 E7AC0028 swc1       $f12, 0x28($sp)
0012195C C44C0024 lwc1       $f12, 0x24($v0)
00121960 E7AC002C swc1       $f12, 0x2c($sp)
00121964 C44C0028 lwc1       $f12, 0x28($v0)
00121968 E7AC0030 swc1       $f12, 0x30($sp)
0012196C C6CC0030 lwc1       $f12, 0x30($s6)
00121970 3C043F80 lui        $a0, 0x3f80
00121974 E7AC0038 swc1       $f12, 0x38($sp)
00121978 C6CC0034 lwc1       $f12, 0x34($s6)
0012197C E7AC003C swc1       $f12, 0x3c($sp)
00121980 C6CC0038 lwc1       $f12, 0x38($s6)
00121984 C7AD003C lwc1       $f13, 0x3c($sp)
00121988 E7AC0040 swc1       $f12, 0x40($sp)
0012198C 44846000 mtc1       $a0, $f12
00121990 460C6B00 add.s      $f12, $f13, $f12
00121994 34120000 ori        $s2, $zero, 0
00121998 E7AC003C swc1       $f12, 0x3c($sp)
0012199C C6EC0014 lwc1       $f12, 0x14($s7)
001219A0 46166032 c.eq.s     $f12, $f22
001219A4 00000000 nop        
001219A8 450000B3 bc1f       0x121c78
001219AC 34150000 ori        $s5, $zero, 0
001219B0 A3B30091 sb         $s3, 0x91($sp)
001219B4 0C00C41E jal        0x31078
001219B8 02C02025 move       $a0, $s6
001219BC 104000AE beqz       $v0, 0x121c78
001219C0 00000000 nop        
001219C4 A3B30091 sb         $s3, 0x91($sp)
001219C8 0C00C4BD jal        0x312f4
001219CC 02C02025 move       $a0, $s6
001219D0 27B10038 addiu      $s1, $sp, 0x38
001219D4 3C10002D lui        $s0, 0x2d
001219D8 3C09002D lui        $t1, 0x2d
001219DC 02C02025 move       $a0, $s6
001219E0 27A50028 addiu      $a1, $sp, 0x28
001219E4 00403025 move       $a2, $v0
001219E8 C60CEA74 lwc1       $f12, -0x158c($s0)
001219EC 02203825 move       $a3, $s1
001219F0 02604025 move       $t0, $s3
001219F4 0C00D6BC jal        0x35af0
001219F8 2529EA78 addiu      $t1, $t1, -0x1588
001219FC 34120001 ori        $s2, $zero, 1
00121A00 0040A825 move       $s5, $v0
00121A04 12A00058 beqz       $s5, 0x121b68
00121A08 A3B20090 sb         $s2, 0x90($sp)
00121A0C AFA00058 sw         $zero, 0x58($sp)
00121A10 AFA00054 sw         $zero, 0x54($sp)
00121A14 E7B6005C swc1       $f22, 0x5c($sp)
00121A18 C6AC0030 lwc1       $f12, 0x30($s5)
00121A1C E7AC0060 swc1       $f12, 0x60($sp)
00121A20 C6AC0034 lwc1       $f12, 0x34($s5)
00121A24 E7AC0064 swc1       $f12, 0x64($sp)
00121A28 C6AC0038 lwc1       $f12, 0x38($s5)
00121A2C C7AD0060 lwc1       $f13, 0x60($sp)
00121A30 E7AC0068 swc1       $f12, 0x68($sp)
00121A34 C6AC0010 lwc1       $f12, 0x10($s5)
00121A38 C7AE0064 lwc1       $f14, 0x64($sp)
00121A3C 460C6B00 add.s      $f12, $f13, $f12
00121A40 C7AF0068 lwc1       $f15, 0x68($sp)
00121A44 3C040006 lui        $a0, 6
00121A48 2484E228 addiu      $a0, $a0, -0x1dd8
00121A4C E7AC0060 swc1       $f12, 0x60($sp)
00121A50 C6AC0014 lwc1       $f12, 0x14($s5)
00121A54 C490000C lwc1       $f16, 0xc($a0)
00121A58 460C7300 add.s      $f12, $f14, $f12
00121A5C 27B00044 addiu      $s0, $sp, 0x44
00121A60 27B10060 addiu      $s1, $sp, 0x60
00121A64 27A4005C addiu      $a0, $sp, 0x5c
00121A68 E7AC0064 swc1       $f12, 0x64($sp)
00121A6C C6AD0018 lwc1       $f13, 0x18($s5)
00121A70 46106301 sub.s      $f12, $f12, $f16
00121A74 02002825 move       $a1, $s0
00121A78 460D7B40 add.s      $f13, $f15, $f13
00121A7C 02203025 move       $a2, $s1
00121A80 34070008 ori        $a3, $zero, 8
00121A84 00004025 move       $t0, $zero
00121A88 02A04825 move       $t1, $s5
00121A8C 0C006BDD jal        0x1af74
00121A90 E7AD0068 swc1       $f13, 0x68($sp)
00121A94 10400032 beqz       $v0, 0x121b60
00121A98 00000000 nop        
00121A9C C7AC0044 lwc1       $f12, 0x44($sp)
00121AA0 C7AD0048 lwc1       $f13, 0x48($sp)
00121AA4 460C6302 mul.s      $f12, $f12, $f12
00121AA8 C7AE004C lwc1       $f14, 0x4c($sp)
00121AAC 460D6B42 mul.s      $f13, $f13, $f13
00121AB0 3C053727 lui        $a1, 0x3727
00121AB4 460E7382 mul.s      $f14, $f14, $f14
00121AB8 34A5C5AC ori        $a1, $a1, 0xc5ac
00121ABC 44857800 mtc1       $a1, $f15
00121AC0 34040000 ori        $a0, $zero, 0
00121AC4 460D6300 add.s      $f12, $f12, $f13
00121AC8 460E6300 add.s      $f12, $f12, $f14
00121ACC 46006305 abs.s      $f12, $f12
00121AD0 460F603E c.le.s     $f12, $f15
00121AD4 00000000 nop        
00121AD8 45030001 bc1tl      0x121ae0
00121ADC 34040001 ori        $a0, $zero, 1
00121AE0 308400FF andi       $a0, $a0, 0xff
00121AE4 1480001E bnez       $a0, 0x121b60
00121AE8 00000000 nop        
00121AEC C7AC005C lwc1       $f12, 0x5c($sp)
00121AF0 C6AD0010 lwc1       $f13, 0x10($s5)
00121AF4 46006307 neg.s      $f12, $f12
00121AF8 C7AE0060 lwc1       $f14, 0x60($sp)
00121AFC 460C6B42 mul.s      $f13, $f13, $f12
00121B00 C7AF0064 lwc1       $f15, 0x64($sp)
00121B04 C7B00068 lwc1       $f16, 0x68($sp)
00121B08 460D7340 add.s      $f13, $f14, $f13
00121B0C 26F3001C addiu      $s3, $s7, 0x1c
00121B10 E7AD0060 swc1       $f13, 0x60($sp)
00121B14 C6AD0014 lwc1       $f13, 0x14($s5)
00121B18 460C6B42 mul.s      $f13, $f13, $f12
00121B1C 02602025 move       $a0, $s3
00121B20 34050001 ori        $a1, $zero, 1
00121B24 460D7B40 add.s      $f13, $f15, $f13
00121B28 02A03025 move       $a2, $s5
00121B2C 34070001 ori        $a3, $zero, 1
00121B30 E7AD0064 swc1       $f13, 0x64($sp)
00121B34 C6AD0018 lwc1       $f13, 0x18($s5)
00121B38 460C6B02 mul.s      $f12, $f13, $f12
00121B3C 460C8300 add.s      $f12, $f16, $f12
00121B40 0C0199E7 jal        0x6679c
00121B44 E7AC0068 swc1       $f12, 0x68($sp)
00121B48 3C07002B lui        $a3, 0x2b
00121B4C 02602025 move       $a0, $s3
00121B50 02202825 move       $a1, $s1
00121B54 02003025 move       $a2, $s0
00121B58 0C019A67 jal        0x6699c
00121B5C C4EC2958 lwc1       $f12, 0x2958($a3)
00121B60 10000045 b          0x121c78
00121B64 00000000 nop        
00121B68 C60CEA74 lwc1       $f12, -0x158c($s0)
00121B6C C7AD002C lwc1       $f13, 0x2c($sp)
00121B70 C7AE0028 lwc1       $f14, 0x28($sp)
00121B74 460D6342 mul.s      $f13, $f12, $f13
00121B78 C7AF0030 lwc1       $f15, 0x30($sp)
00121B7C 460E6382 mul.s      $f14, $f12, $f14
00121B80 3C044000 lui        $a0, 0x4000
00121B84 44848000 mtc1       $a0, $f16
00121B88 26F4001C addiu      $s4, $s7, 0x1c
00121B8C 02802025 move       $a0, $s4
00121B90 E7AD0070 swc1       $f13, 0x70($sp)
00121B94 460F6302 mul.s      $f12, $f12, $f15
00121B98 E7AE006C swc1       $f14, 0x6c($sp)
00121B9C 46106B40 add.s      $f13, $f13, $f16
00121BA0 00002825 move       $a1, $zero
00121BA4 00003025 move       $a2, $zero
00121BA8 34070001 ori        $a3, $zero, 1
00121BAC E7AC0074 swc1       $f12, 0x74($sp)
00121BB0 0C0199E7 jal        0x6679c
00121BB4 E7AD0070 swc1       $f13, 0x70($sp)
00121BB8 27B30078 addiu      $s3, $sp, 0x78
00121BBC 27B20084 addiu      $s2, $sp, 0x84
00121BC0 27B0006C addiu      $s0, $sp, 0x6c
00121BC4 02602025 move       $a0, $s3
00121BC8 02402825 move       $a1, $s2
00121BCC 02203025 move       $a2, $s1
00121BD0 0C019ADF jal        0x66b7c
00121BD4 02003825 move       $a3, $s0
00121BD8 50400009 beql       $v0, $zero, 0x121c00
00121BDC C7AC0038 lwc1       $f12, 0x38($sp)
00121BE0 3C07002B lui        $a3, 0x2b
00121BE4 02802025 move       $a0, $s4
00121BE8 02602825 move       $a1, $s3
00121BEC 02403025 move       $a2, $s2
00121BF0 0C019A67 jal        0x6699c
00121BF4 C4EC2958 lwc1       $f12, 0x2958($a3)
00121BF8 1000001E b          0x121c74
00121BFC 00000000 nop        
00121C00 C7AD006C lwc1       $f13, 0x6c($sp)
00121C04 C7AE003C lwc1       $f14, 0x3c($sp)
00121C08 460D6300 add.s      $f12, $f12, $f13
00121C0C C7AF0070 lwc1       $f15, 0x70($sp)
00121C10 C7B00040 lwc1       $f16, 0x40($sp)
00121C14 C7B10074 lwc1       $f17, 0x74($sp)
00121C18 460F7380 add.s      $f14, $f14, $f15
00121C1C 3C04C120 lui        $a0, 0xc120
00121C20 E7AC0038 swc1       $f12, 0x38($sp)
00121C24 46118300 add.s      $f12, $f16, $f17
00121C28 E7B6006C swc1       $f22, 0x6c($sp)
00121C2C E7AE003C swc1       $f14, 0x3c($sp)
00121C30 02402825 move       $a1, $s2
00121C34 02203025 move       $a2, $s1
00121C38 E7AC0040 swc1       $f12, 0x40($sp)
00121C3C 44846000 mtc1       $a0, $f12
00121C40 02003825 move       $a3, $s0
00121C44 E7AC0070 swc1       $f12, 0x70($sp)
00121C48 E7B60074 swc1       $f22, 0x74($sp)
00121C4C 0C019ADF jal        0x66b7c
00121C50 02602025 move       $a0, $s3
00121C54 10400007 beqz       $v0, 0x121c74
00121C58 00000000 nop        
00121C5C 3C07002B lui        $a3, 0x2b
00121C60 02802025 move       $a0, $s4
00121C64 02602825 move       $a1, $s3
00121C68 02403025 move       $a2, $s2
00121C6C 0C019A67 jal        0x6699c
00121C70 C4EC2958 lwc1       $f12, 0x2958($a3)
00121C74 93B20090 lbu        $s2, 0x90($sp)
00121C78 0C00C41E jal        0x31078
00121C7C 02C02025 move       $a0, $s6
00121C80 1040002A beqz       $v0, 0x121d2c
00121C84 00000000 nop        
00121C88 C6EC0014 lwc1       $f12, 0x14($s7)
00121C8C 46166032 c.eq.s     $f12, $f22
00121C90 00000000 nop        
00121C94 45000025 bc1f       0x121d2c
00121C98 00000000 nop        
00121C9C 0C007956 jal        0x1e558
00121CA0 02C02025 move       $a0, $s6
00121CA4 10400021 beqz       $v0, 0x121d2c
00121CA8 00000000 nop        
00121CAC 8FA40020 lw         $a0, 0x20($sp)
00121CB0 30840020 andi       $a0, $a0, 0x20
00121CB4 1080001D beqz       $a0, 0x121d2c
00121CB8 00000000 nop        
00121CBC 93C40045 lbu        $a0, 0x45($fp)
00121CC0 10800003 beqz       $a0, 0x121cd0
00121CC4 34050005 ori        $a1, $zero, 5
00121CC8 14850018 bne        $a0, $a1, 0x121d2c
00121CCC 00000000 nop        
00121CD0 26C400C0 addiu      $a0, $s6, 0xc0
00121CD4 8C840014 lw         $a0, 0x14($a0)
00121CD8 30842000 andi       $a0, $a0, 0x2000
00121CDC 10800013 beqz       $a0, 0x121d2c
00121CE0 00000000 nop        
00121CE4 1640000E bnez       $s2, 0x121d20
00121CE8 00000000 nop        
00121CEC 0C00C4BD jal        0x312f4
00121CF0 02C02025 move       $a0, $s6
00121CF4 3C06002D lui        $a2, 0x2d
00121CF8 C4CCEA74 lwc1       $f12, -0x158c($a2)
00121CFC 3C09002D lui        $t1, 0x2d
00121D00 27A70038 addiu      $a3, $sp, 0x38
00121D04 02C02025 move       $a0, $s6
00121D08 27A50028 addiu      $a1, $sp, 0x28
00121D0C 93A80091 lbu        $t0, 0x91($sp)
00121D10 00403025 move       $a2, $v0
00121D14 0C00D6BC jal        0x35af0
00121D18 2529EA78 addiu      $t1, $t1, -0x1588
00121D1C 0040A825 move       $s5, $v0
00121D20 03C02025 move       $a0, $fp
00121D24 0C048567 jal        0x12159c
00121D28 02A02825 move       $a1, $s5
00121D2C C7B40094 lwc1       $f20, 0x94($sp)
00121D30 C7B60098 lwc1       $f22, 0x98($sp)
00121D34 8FB0009C lw         $s0, 0x9c($sp)
00121D38 8FB100A0 lw         $s1, 0xa0($sp)
00121D3C 8FB200A4 lw         $s2, 0xa4($sp)
00121D40 8FB300A8 lw         $s3, 0xa8($sp)
00121D44 8FB400AC lw         $s4, 0xac($sp)
00121D48 8FB500B0 lw         $s5, 0xb0($sp)
00121D4C 8FB600B4 lw         $s6, 0xb4($sp)
00121D50 8FB700B8 lw         $s7, 0xb8($sp)
00121D54 8FBE00BC lw         $fp, 0xbc($sp)
00121D58 8FBF00C0 lw         $ra, 0xc0($sp)
00121D5C 03E00008 jr         $ra
00121D60 27BD00D0 addiu      $sp, $sp, 0xd0