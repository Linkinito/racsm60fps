
CALLBACK 0x00119FFC end 0x0011A130 ordinal 0

00119FFC 27BDFFD0 addiu      $sp, $sp, -0x30
0011A000 AFB00020 sw         $s0, 0x20($sp)
0011A004 00808025 move       $s0, $a0
0011A008 AFB10024 sw         $s1, 0x24($sp)
0011A00C 8E110058 lw         $s1, 0x58($s0)
0011A010 3C043E2A lui        $a0, 0x3e2a
0011A014 AE200000 sw         $zero, ($s1)
0011A018 3484AB8A ori        $a0, $a0, 0xab8a
0011A01C 44846800 mtc1       $a0, $f13
0011A020 AE200008 sw         $zero, 8($s1)
0011A024 44806000 mtc1       $zero, $f12
0011A028 E62D0004 swc1       $f13, 4($s1)
0011A02C E62C000C swc1       $f12, 0xc($s1)
0011A030 3C08002B lui        $t0, 0x2b
0011A034 E62C0040 swc1       $f12, 0x40($s1)
0011A038 26240018 addiu      $a0, $s1, 0x18
0011A03C 00002825 move       $a1, $zero
0011A040 34060044 ori        $a2, $zero, 0x44
0011A044 34070045 ori        $a3, $zero, 0x45
0011A048 AFB20028 sw         $s2, 0x28($sp)
0011A04C AFBF002C sw         $ra, 0x2c($sp)
0011A050 0C019B8F jal        0x66e3c
0011A054 250828D8 addiu      $t0, $t0, 0x28d8
0011A058 AE200010 sw         $zero, 0x10($s1)
0011A05C A2200014 sb         $zero, 0x14($s1)
0011A060 AE200044 sw         $zero, 0x44($s1)
0011A064 8E040048 lw         $a0, 0x48($s0)
0011A068 3C050012 lui        $a1, 0x12
0011A06C 24A5A2E8 addiu      $a1, $a1, -0x5d18
0011A070 AC8500DC sw         $a1, 0xdc($a0)
0011A074 3C12002B lui        $s2, 0x2b
0011A078 8E4500C0 lw         $a1, 0xc0($s2)
0011A07C 8CA600F0 lw         $a2, 0xf0($a1)
0011A080 26040074 addiu      $a0, $s0, 0x74
0011A084 34050003 ori        $a1, $zero, 3
0011A088 0C0077E7 jal        0x1df9c
0011A08C 2407FFFF addiu      $a3, $zero, -1
0011A090 0C046949 jal        0x11a524
0011A094 26240048 addiu      $a0, $s1, 0x48
0011A098 3C050009 lui        $a1, 9
0011A09C 8E4400C0 lw         $a0, 0xc0($s2)
0011A0A0 24A5CF10 addiu      $a1, $a1, -0x30f0
0011A0A4 8CA60038 lw         $a2, 0x38($a1)
0011A0A8 8CA500B0 lw         $a1, 0xb0($a1)
0011A0AC 3C07002D lui        $a3, 0x2d
0011A0B0 8CE8E304 lw         $t0, -0x1cfc($a3)
0011A0B4 3C09F801 lui        $t1, 0xf801
0011A0B8 2529FFFF addiu      $t1, $t1, -1
0011A0BC 00063400 sll        $a2, $a2, 0x10
0011A0C0 01094024 and        $t0, $t0, $t1
0011A0C4 3C0A002D lui        $t2, 0x2d
0011A0C8 8D4BE308 lw         $t3, -0x1cf8($t2)
0011A0CC 01063025 or         $a2, $t0, $a2
0011A0D0 ACE6E304 sw         $a2, -0x1cfc($a3)
0011A0D4 01693024 and        $a2, $t3, $t1
0011A0D8 00052C00 sll        $a1, $a1, 0x10
0011A0DC 00C52825 or         $a1, $a2, $a1
0011A0E0 AD45E308 sw         $a1, -0x1cf8($t2)
0011A0E4 3C05002D lui        $a1, 0x2d
0011A0E8 C4ACE2F8 lwc1       $f12, -0x1d08($a1)
0011A0EC 3C05002D lui        $a1, 0x2d
0011A0F0 C4ADE2FC lwc1       $f13, -0x1d04($a1)
0011A0F4 3C05002D lui        $a1, 0x2d
0011A0F8 C4AEE300 lwc1       $f14, -0x1d00($a1)
0011A0FC 3C05002D lui        $a1, 0x2d
0011A100 3C06002D lui        $a2, 0x2d
0011A104 34070001 ori        $a3, $zero, 1
0011A108 24A5E2EC addiu      $a1, $a1, -0x1d14
0011A10C 0C01707F jal        0x5c1fc
0011A110 24C6E2D4 addiu      $a2, $a2, -0x1d2c
0011A114 34020001 ori        $v0, $zero, 1
0011A118 8FB00020 lw         $s0, 0x20($sp)
0011A11C 8FB10024 lw         $s1, 0x24($sp)
0011A120 8FB20028 lw         $s2, 0x28($sp)
0011A124 8FBF002C lw         $ra, 0x2c($sp)
0011A128 03E00008 jr         $ra
0011A12C 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x0011A158 end 0x0011A178 ordinal 1

0011A158 27BDFFE0 addiu      $sp, $sp, -0x20
0011A15C 8C840058 lw         $a0, 0x58($a0)
0011A160 AFBF0010 sw         $ra, 0x10($sp)
0011A164 0C01B1A3 jal        0x6c68c
0011A168 8C840044 lw         $a0, 0x44($a0)
0011A16C 8FBF0010 lw         $ra, 0x10($sp)
0011A170 03E00008 jr         $ra
0011A174 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0011A5B0 end 0x0011B4F8 ordinal 2

0011A5B0 27BDFE80 addiu      $sp, $sp, -0x180
0011A5B4 AFB2015C sw         $s2, 0x15c($sp)
0011A5B8 00809025 move       $s2, $a0
0011A5BC AFB10158 sw         $s1, 0x158($sp)
0011A5C0 8E510058 lw         $s1, 0x58($s2)
0011A5C4 E7B4013C swc1       $f20, 0x13c($sp)
0011A5C8 AFB30160 sw         $s3, 0x160($sp)
0011A5CC 46006506 mov.s      $f20, $f12
0011A5D0 34040003 ori        $a0, $zero, 3
0011A5D4 8E330000 lw         $s3, ($s1)
0011A5D8 E7B60140 swc1       $f22, 0x140($sp)
0011A5DC E7B80144 swc1       $f24, 0x144($sp)
0011A5E0 E7BA0148 swc1       $f26, 0x148($sp)
0011A5E4 E7BC014C swc1       $f28, 0x14c($sp)
0011A5E8 E7BE0150 swc1       $f30, 0x150($sp)
0011A5EC AFB00154 sw         $s0, 0x154($sp)
0011A5F0 AFB40164 sw         $s4, 0x164($sp)
0011A5F4 AFB50168 sw         $s5, 0x168($sp)
0011A5F8 AFB6016C sw         $s6, 0x16c($sp)
0011A5FC AFB70170 sw         $s7, 0x170($sp)
0011A600 AFBE0174 sw         $fp, 0x174($sp)
0011A604 AFBF0178 sw         $ra, 0x178($sp)
0011A608 0C007DC7 jal        0x1f71c
0011A60C 8E6500F0 lw         $a1, 0xf0($s3)
0011A610 0040B025 move       $s6, $v0
0011A614 0C016FD5 jal        0x5bf54
0011A618 02602025 move       $a0, $s3
0011A61C 0040A025 move       $s4, $v0
0011A620 0C00C4BD jal        0x312f4
0011A624 02602025 move       $a0, $s3
0011A628 C64C0020 lwc1       $f12, 0x20($s2)
0011A62C C64D0024 lwc1       $f13, 0x24($s2)
0011A630 C64E0028 lwc1       $f14, 0x28($s2)
0011A634 E7AC0070 swc1       $f12, 0x70($sp)
0011A638 E7AD0074 swc1       $f13, 0x74($sp)
0011A63C C64F002C lwc1       $f15, 0x2c($s2)
0011A640 E7AE0078 swc1       $f14, 0x78($sp)
0011A644 C6500000 lwc1       $f16, ($s2)
0011A648 E7AF007C swc1       $f15, 0x7c($sp)
0011A64C C6510004 lwc1       $f17, 4($s2)
0011A650 E7B00050 swc1       $f16, 0x50($sp)
0011A654 C6530008 lwc1       $f19, 8($s2)
0011A658 E7B10054 swc1       $f17, 0x54($sp)
0011A65C C640000C lwc1       $f0, 0xc($s2)
0011A660 E7B30058 swc1       $f19, 0x58($sp)
0011A664 C6410010 lwc1       $f1, 0x10($s2)
0011A668 E7A0005C swc1       $f0, 0x5c($sp)
0011A66C C6400014 lwc1       $f0, 0x14($s2)
0011A670 E7A10060 swc1       $f1, 0x60($sp)
0011A674 460C63C2 mul.s      $f15, $f12, $f12
0011A678 460D6C82 mul.s      $f18, $f13, $f13
0011A67C C6430018 lwc1       $f3, 0x18($s2)
0011A680 E7A00064 swc1       $f0, 0x64($sp)
0011A684 C645001C lwc1       $f5, 0x1c($s2)
0011A688 E7A30068 swc1       $f3, 0x68($sp)
0011A68C 46127880 add.s      $f2, $f15, $f18
0011A690 C6460030 lwc1       $f6, 0x30($s2)
0011A694 E7A5006C swc1       $f5, 0x6c($sp)
0011A698 C6450034 lwc1       $f5, 0x34($s2)
0011A69C 460E7102 mul.s      $f4, $f14, $f14
0011A6A0 E7A60080 swc1       $f6, 0x80($sp)
0011A6A4 C64F0038 lwc1       $f15, 0x38($s2)
0011A6A8 E7A50084 swc1       $f5, 0x84($sp)
0011A6AC C652003C lwc1       $f18, 0x3c($s2)
0011A6B0 46041080 add.s      $f2, $f2, $f4
0011A6B4 E7AF0088 swc1       $f15, 0x88($sp)
0011A6B8 460083C6 mov.s      $f15, $f16
0011A6BC 3C043480 lui        $a0, 0x3480
0011A6C0 46008C06 mov.s      $f16, $f17
0011A6C4 E7B2008C swc1       $f18, 0x8c($sp)
0011A6C8 46009C46 mov.s      $f17, $f19
0011A6CC 3C1E002D lui        $fp, 0x2d
0011A6D0 4484D000 mtc1       $a0, $f26
0011A6D4 00408025 move       $s0, $v0
0011A6D8 4480F000 mtc1       $zero, $f30
0011A6DC 27DEE25C addiu      $fp, $fp, -0x1da4
0011A6E0 460004C6 mov.s      $f19, $f0
0011A6E4 3C17002D lui        $s7, 0x2d
0011A6E8 46000C86 mov.s      $f18, $f1
0011A6EC 461A103C c.lt.s     $f2, $f26
0011A6F0 00000000 nop        
0011A6F4 4501000B bc1t       0x11a724
0011A6F8 46001806 mov.s      $f0, $f3
0011A6FC 3C043F80 lui        $a0, 0x3f80
0011A700 46001084 sqrt.s     $f2, $f2
0011A704 44840800 mtc1       $a0, $f1
0011A708 46020883 div.s      $f2, $f1, $f2
0011A70C 46026302 mul.s      $f12, $f12, $f2
0011A710 46026B42 mul.s      $f13, $f13, $f2
0011A714 46027382 mul.s      $f14, $f14, $f2
0011A718 E7AC0070 swc1       $f12, 0x70($sp)
0011A71C E7AD0074 swc1       $f13, 0x74($sp)
0011A720 E7AE0078 swc1       $f14, 0x78($sp)
0011A724 460F7B02 mul.s      $f12, $f15, $f15
0011A728 46108342 mul.s      $f13, $f16, $f16
0011A72C 46118B82 mul.s      $f14, $f17, $f17
0011A730 460D6300 add.s      $f12, $f12, $f13
0011A734 460E6300 add.s      $f12, $f12, $f14
0011A738 461A603C c.lt.s     $f12, $f26
0011A73C 00000000 nop        
0011A740 4501000A bc1t       0x11a76c
0011A744 3C043F80 lui        $a0, 0x3f80
0011A748 46006304 sqrt.s     $f12, $f12
0011A74C 44846800 mtc1       $a0, $f13
0011A750 460C6B03 div.s      $f12, $f13, $f12
0011A754 460C7B82 mul.s      $f14, $f15, $f12
0011A758 460C8402 mul.s      $f16, $f16, $f12
0011A75C E7AE0050 swc1       $f14, 0x50($sp)
0011A760 460C8B02 mul.s      $f12, $f17, $f12
0011A764 E7B00054 swc1       $f16, 0x54($sp)
0011A768 E7AC0058 swc1       $f12, 0x58($sp)
0011A76C 46129302 mul.s      $f12, $f18, $f18
0011A770 46139B42 mul.s      $f13, $f19, $f19
0011A774 46000382 mul.s      $f14, $f0, $f0
0011A778 460D6300 add.s      $f12, $f12, $f13
0011A77C 460E6300 add.s      $f12, $f12, $f14
0011A780 461A603C c.lt.s     $f12, $f26
0011A784 00000000 nop        
0011A788 45000003 bc1f       0x11a798
0011A78C 3C043F80 lui        $a0, 0x3f80
0011A790 1000000B b          0x11a7c0
0011A794 926409E4 lbu        $a0, 0x9e4($s3)
0011A798 46006304 sqrt.s     $f12, $f12
0011A79C 44846800 mtc1       $a0, $f13
0011A7A0 460C6B03 div.s      $f12, $f13, $f12
0011A7A4 460C9382 mul.s      $f14, $f18, $f12
0011A7A8 460C9BC2 mul.s      $f15, $f19, $f12
0011A7AC E7AE0060 swc1       $f14, 0x60($sp)
0011A7B0 460C0302 mul.s      $f12, $f0, $f12
0011A7B4 E7AF0064 swc1       $f15, 0x64($sp)
0011A7B8 E7AC0068 swc1       $f12, 0x68($sp)
0011A7BC 926409E4 lbu        $a0, 0x9e4($s3)
0011A7C0 1080001D beqz       $a0, 0x11a838
0011A7C4 00000000 nop        
0011A7C8 C66C09E8 lwc1       $f12, 0x9e8($s3)
0011A7CC 3C043CA3 lui        $a0, 0x3ca3
0011A7D0 E7AC0090 swc1       $f12, 0x90($sp)
0011A7D4 C66C09EC lwc1       $f12, 0x9ec($s3)
0011A7D8 3484D70A ori        $a0, $a0, 0xd70a
0011A7DC E7AC0094 swc1       $f12, 0x94($sp)
0011A7E0 44846800 mtc1       $a0, $f13
0011A7E4 C66C09F0 lwc1       $f12, 0x9f0($s3)
0011A7E8 E7AC0098 swc1       $f12, 0x98($sp)
0011A7EC C66C09F4 lwc1       $f12, 0x9f4($s3)
0011A7F0 C7AE0090 lwc1       $f14, 0x90($sp)
0011A7F4 460D6302 mul.s      $f12, $f12, $f13
0011A7F8 C7AF0094 lwc1       $f15, 0x94($sp)
0011A7FC E7AC00B0 swc1       $f12, 0xb0($sp)
0011A800 C67009F8 lwc1       $f16, 0x9f8($s3)
0011A804 460C7300 add.s      $f12, $f14, $f12
0011A808 C7B10098 lwc1       $f17, 0x98($sp)
0011A80C 460D8402 mul.s      $f16, $f16, $f13
0011A810 E7B000B4 swc1       $f16, 0xb4($sp)
0011A814 46107BC0 add.s      $f15, $f15, $f16
0011A818 C67209FC lwc1       $f18, 0x9fc($s3)
0011A81C E7AC0090 swc1       $f12, 0x90($sp)
0011A820 460D9342 mul.s      $f13, $f18, $f13
0011A824 E7AF0094 swc1       $f15, 0x94($sp)
0011A828 460D8B00 add.s      $f12, $f17, $f13
0011A82C E7AD00B8 swc1       $f13, 0xb8($sp)
0011A830 10000006 b          0x11a84c
0011A834 E7AC0098 swc1       $f12, 0x98($sp)
0011A838 3C06002D lui        $a2, 0x2d
0011A83C 27A40090 addiu      $a0, $sp, 0x90
0011A840 27A50050 addiu      $a1, $sp, 0x50
0011A844 0C03D550 jal        0xf5540
0011A848 24C6E2D4 addiu      $a2, $a2, -0x1d2c
0011A84C 0C00C4BD jal        0x312f4
0011A850 02602025 move       $a0, $s3
0011A854 C44C0020 lwc1       $f12, 0x20($v0)
0011A858 E7AC00A0 swc1       $f12, 0xa0($sp)
0011A85C C44C0024 lwc1       $f12, 0x24($v0)
0011A860 E7AC00A4 swc1       $f12, 0xa4($sp)
0011A864 C44C0028 lwc1       $f12, 0x28($v0)
0011A868 E7AC00A8 swc1       $f12, 0xa8($sp)
0011A86C C44C002C lwc1       $f12, 0x2c($v0)
0011A870 E7AC00AC swc1       $f12, 0xac($sp)
0011A874 C62C0004 lwc1       $f12, 4($s1)
0011A878 46146301 sub.s      $f12, $f12, $f20
0011A87C 461E603C c.lt.s     $f12, $f30
0011A880 00000000 nop        
0011A884 45000002 bc1f       0x11a890
0011A888 E62C0004 swc1       $f12, 4($s1)
0011A88C E63E0004 swc1       $f30, 4($s1)
0011A890 8E240008 lw         $a0, 8($s1)
0011A894 34050003 ori        $a1, $zero, 3
0011A898 14850011 bne        $a0, $a1, 0x11a8e0
0011A89C 00000000 nop        
0011A8A0 02402025 move       $a0, $s2
0011A8A4 0C01AA82 jal        0x6aa08
0011A8A8 00002825 move       $a1, $zero
0011A8AC 1040000C beqz       $v0, 0x11a8e0
0011A8B0 00000000 nop        
0011A8B4 3C083DCC lui        $t0, 0x3dcc
0011A8B8 4600F346 mov.s      $f13, $f30
0011A8BC A2400045 sb         $zero, 0x45($s2)
0011A8C0 3508CCCD ori        $t0, $t0, 0xcccd
0011A8C4 AE200008 sw         $zero, 8($s1)
0011A8C8 44886000 mtc1       $t0, $f12
0011A8CC 02402025 move       $a0, $s2
0011A8D0 00002825 move       $a1, $zero
0011A8D4 00003025 move       $a2, $zero
0011A8D8 0C01AB54 jal        0x6ad50
0011A8DC 34070001 ori        $a3, $zero, 1
0011A8E0 8E6600F0 lw         $a2, 0xf0($s3)
0011A8E4 34150000 ori        $s5, $zero, 0
0011A8E8 34040003 ori        $a0, $zero, 3
0011A8EC 0C007F68 jal        0x1fda0
0011A8F0 34050006 ori        $a1, $zero, 6
0011A8F4 10400059 beqz       $v0, 0x11aa5c
0011A8F8 00000000 nop        
0011A8FC 8E64095C lw         $a0, 0x95c($s3)
0011A900 3C050010 lui        $a1, 0x10
0011A904 00852024 and        $a0, $a0, $a1
0011A908 0004202B sltu       $a0, $zero, $a0
0011A90C 308400FF andi       $a0, $a0, 0xff
0011A910 10800052 beqz       $a0, 0x11aa5c
0011A914 00000000 nop        
0011A918 866400F8 lh         $a0, 0xf8($s3)
0011A91C 3405001F ori        $a1, $zero, 0x1f
0011A920 1085004E beq        $a0, $a1, 0x11aa5c
0011A924 00000000 nop        
0011A928 92240014 lbu        $a0, 0x14($s1)
0011A92C 1080002E beqz       $a0, 0x11a9e8
0011A930 00000000 nop        
0011A934 8E250010 lw         $a1, 0x10($s1)
0011A938 8CA50064 lw         $a1, 0x64($a1)
0011A93C 30A60001 andi       $a2, $a1, 1
0011A940 10C00007 beqz       $a2, 0x11a960
0011A944 30A60008 andi       $a2, $a1, 8
0011A948 14C00005 bnez       $a2, 0x11a960
0011A94C 30A60006 andi       $a2, $a1, 6
0011A950 14C00003 bnez       $a2, 0x11a960
0011A954 30A50400 andi       $a1, $a1, 0x400
0011A958 10A00043 beqz       $a1, 0x11aa68
0011A95C 00000000 nop        
0011A960 0C00C4BD jal        0x312f4
0011A964 02602025 move       $a0, $s3
0011A968 8EC4003C lw         $a0, 0x3c($s6)
0011A96C 3C09002D lui        $t1, 0x2d
0011A970 00042080 sll        $a0, $a0, 2
0011A974 009E2021 addu       $a0, $a0, $fp
0011A978 C48C0000 lwc1       $f12, ($a0)
0011A97C C6EDE288 lwc1       $f13, -0x1d78($s7)
0011A980 27A70090 addiu      $a3, $sp, 0x90
0011A984 02602025 move       $a0, $s3
0011A988 460C6B02 mul.s      $f12, $f13, $f12
0011A98C 27A500A0 addiu      $a1, $sp, 0xa0
0011A990 00403025 move       $a2, $v0
0011A994 02804025 move       $t0, $s4
0011A998 0C00D6BC jal        0x35af0
0011A99C 2529E238 addiu      $t1, $t1, -0x1dc8
0011A9A0 0040A025 move       $s4, $v0
0011A9A4 1280000B beqz       $s4, 0x11a9d4
0011A9A8 00000000 nop        
0011A9AC 8E840040 lw         $a0, 0x40($s4)
0011A9B0 34050001 ori        $a1, $zero, 1
0011A9B4 9084004B lbu        $a0, 0x4b($a0)
0011A9B8 14850006 bne        $a0, $a1, 0x11a9d4
0011A9BC 00000000 nop        
0011A9C0 34040001 ori        $a0, $zero, 1
0011A9C4 AE340010 sw         $s4, 0x10($s1)
0011A9C8 A2240014 sb         $a0, 0x14($s1)
0011A9CC 10000004 b          0x11a9e0
0011A9D0 92240014 lbu        $a0, 0x14($s1)
0011A9D4 AE200010 sw         $zero, 0x10($s1)
0011A9D8 A2200014 sb         $zero, 0x14($s1)
0011A9DC 92240014 lbu        $a0, 0x14($s1)
0011A9E0 10000021 b          0x11aa68
0011A9E4 00000000 nop        
0011A9E8 0C00C4BD jal        0x312f4
0011A9EC 02602025 move       $a0, $s3
0011A9F0 8EC4003C lw         $a0, 0x3c($s6)
0011A9F4 3C09002D lui        $t1, 0x2d
0011A9F8 00042080 sll        $a0, $a0, 2
0011A9FC 009E2021 addu       $a0, $a0, $fp
0011AA00 C48C0000 lwc1       $f12, ($a0)
0011AA04 C6EDE288 lwc1       $f13, -0x1d78($s7)
0011AA08 27A70090 addiu      $a3, $sp, 0x90
0011AA0C 02602025 move       $a0, $s3
0011AA10 460C6B02 mul.s      $f12, $f13, $f12
0011AA14 27A500A0 addiu      $a1, $sp, 0xa0
0011AA18 00403025 move       $a2, $v0
0011AA1C 02804025 move       $t0, $s4
0011AA20 0C00D6BC jal        0x35af0
0011AA24 2529E238 addiu      $t1, $t1, -0x1dc8
0011AA28 0040A025 move       $s4, $v0
0011AA2C 12800009 beqz       $s4, 0x11aa54
0011AA30 00000000 nop        
0011AA34 8E840040 lw         $a0, 0x40($s4)
0011AA38 34050001 ori        $a1, $zero, 1
0011AA3C 9084004B lbu        $a0, 0x4b($a0)
0011AA40 14850004 bne        $a0, $a1, 0x11aa54
0011AA44 00000000 nop        
0011AA48 AE340010 sw         $s4, 0x10($s1)
0011AA4C 34040001 ori        $a0, $zero, 1
0011AA50 A2240014 sb         $a0, 0x14($s1)
0011AA54 10000004 b          0x11aa68
0011AA58 92240014 lbu        $a0, 0x14($s1)
0011AA5C AE200010 sw         $zero, 0x10($s1)
0011AA60 A2200014 sb         $zero, 0x14($s1)
0011AA64 92240014 lbu        $a0, 0x14($s1)
0011AA68 10800032 beqz       $a0, 0x11ab34
0011AA6C 3C14002D lui        $s4, 0x2d
0011AA70 8E240010 lw         $a0, 0x10($s1)
0011AA74 1080002F beqz       $a0, 0x11ab34
0011AA78 00000000 nop        
0011AA7C 0C00C41E jal        0x31078
0011AA80 02602025 move       $a0, $s3
0011AA84 1040002B beqz       $v0, 0x11ab34
0011AA88 00000000 nop        
0011AA8C AFB40134 sw         $s4, 0x134($sp)
0011AA90 3C06002D lui        $a2, 0x2d
0011AA94 C4CCE394 lwc1       $f12, -0x1c6c($a2)
0011AA98 3C063F80 lui        $a2, 0x3f80
0011AA9C 4486A000 mtc1       $a2, $f20
0011AAA0 34040064 ori        $a0, $zero, 0x64
0011AAA4 34050002 ori        $a1, $zero, 2
0011AAA8 0C000A17 jal        0x285c
0011AAAC 4600A346 mov.s      $f13, $f20
0011AAB0 3C053F91 lui        $a1, 0x3f91
0011AAB4 4600A346 mov.s      $f13, $f20
0011AAB8 34A5EB85 ori        $a1, $a1, 0xeb85
0011AABC 44856000 mtc1       $a1, $f12
0011AAC0 34040064 ori        $a0, $zero, 0x64
0011AAC4 0C000A22 jal        0x2888
0011AAC8 34050002 ori        $a1, $zero, 2
0011AACC 8E240010 lw         $a0, 0x10($s1)
0011AAD0 0C00039F jal        0xe7c
0011AAD4 24940030 addiu      $s4, $a0, 0x30
0011AAD8 46000347 neg.s      $f13, $f0
0011AADC 02802025 move       $a0, $s4
0011AAE0 4600A306 mov.s      $f12, $f20
0011AAE4 0C000AC6 jal        0x2b18
0011AAE8 00002825 move       $a1, $zero
0011AAEC 8E240010 lw         $a0, 0x10($s1)
0011AAF0 27A500BC addiu      $a1, $sp, 0xbc
0011AAF4 34060001 ori        $a2, $zero, 1
0011AAF8 0C01B0C6 jal        0x6c318
0011AAFC 00003825 move       $a3, $zero
0011AB00 0C016FE3 jal        0x5bf8c
0011AB04 8E240000 lw         $a0, ($s1)
0011AB08 26340018 addiu      $s4, $s1, 0x18
0011AB0C 8E260010 lw         $a2, 0x10($s1)
0011AB10 02802025 move       $a0, $s4
0011AB14 34050001 ori        $a1, $zero, 1
0011AB18 0C0199E7 jal        0x6679c
0011AB1C 34070001 ori        $a3, $zero, 1
0011AB20 02802025 move       $a0, $s4
0011AB24 27A500BC addiu      $a1, $sp, 0xbc
0011AB28 0C019A07 jal        0x6681c
0011AB2C 00003025 move       $a2, $zero
0011AB30 8FB40134 lw         $s4, 0x134($sp)
0011AB34 C62C0004 lwc1       $f12, 4($s1)
0011AB38 461E6032 c.eq.s     $f12, $f30
0011AB3C 00000000 nop        
0011AB40 45000033 bc1f       0x11ac10
0011AB44 00000000 nop        
0011AB48 8E64095C lw         $a0, 0x95c($s3)
0011AB4C 30840020 andi       $a0, $a0, 0x20
0011AB50 1080002F beqz       $a0, 0x11ac10
0011AB54 00000000 nop        
0011AB58 0C007956 jal        0x1e558
0011AB5C 02602025 move       $a0, $s3
0011AB60 1040002B beqz       $v0, 0x11ac10
0011AB64 00000000 nop        
0011AB68 92440045 lbu        $a0, 0x45($s2)
0011AB6C 14800028 bnez       $a0, 0x11ac10
0011AB70 00000000 nop        
0011AB74 C62C0040 lwc1       $f12, 0x40($s1)
0011AB78 461E6032 c.eq.s     $f12, $f30
0011AB7C 00000000 nop        
0011AB80 45000023 bc1f       0x11ac10
0011AB84 00000000 nop        
0011AB88 266400C0 addiu      $a0, $s3, 0xc0
0011AB8C 8C840014 lw         $a0, 0x14($a0)
0011AB90 30842000 andi       $a0, $a0, 0x2000
0011AB94 1080001E beqz       $a0, 0x11ac10
0011AB98 00000000 nop        
0011AB9C 8E6600F0 lw         $a2, 0xf0($s3)
0011ABA0 34040003 ori        $a0, $zero, 3
0011ABA4 0C007F68 jal        0x1fda0
0011ABA8 34050005 ori        $a1, $zero, 5
0011ABAC 10400017 beqz       $v0, 0x11ac0c
0011ABB0 00000000 nop        
0011ABB4 3C043DCC lui        $a0, 0x3dcc
0011ABB8 3484CCCD ori        $a0, $a0, 0xcccd
0011ABBC 44846000 mtc1       $a0, $f12
0011ABC0 3C04002D lui        $a0, 0x2d
0011ABC4 E62C0040 swc1       $f12, 0x40($s1)
0011ABC8 8C84E310 lw         $a0, -0x1cf0($a0)
0011ABCC 10800010 beqz       $a0, 0x11ac10
0011ABD0 00802825 move       $a1, $a0
0011ABD4 C4AC0014 lwc1       $f12, 0x14($a1)
0011ABD8 C4AD0018 lwc1       $f13, 0x18($a1)
0011ABDC C4AE001C lwc1       $f14, 0x1c($a1)
0011ABE0 26260044 addiu      $a2, $s1, 0x44
0011ABE4 C4AF0020 lwc1       $f15, 0x20($a1)
0011ABE8 34070000 ori        $a3, $zero, 0
0011ABEC 34090000 ori        $t1, $zero, 0
0011ABF0 340A0000 ori        $t2, $zero, 0
0011ABF4 340B0001 ori        $t3, $zero, 1
0011ABF8 02402025 move       $a0, $s2
0011ABFC 0C01B147 jal        0x6c51c
0011AC00 00004025 move       $t0, $zero
0011AC04 10000002 b          0x11ac10
0011AC08 00000000 nop        
0011AC0C 34150001 ori        $s5, $zero, 1
0011AC10 8E6600F0 lw         $a2, 0xf0($s3)
0011AC14 34040003 ori        $a0, $zero, 3
0011AC18 0C007F68 jal        0x1fda0
0011AC1C 34050005 ori        $a1, $zero, 5
0011AC20 10400003 beqz       $v0, 0x11ac30
0011AC24 C6340040 lwc1       $f20, 0x40($s1)
0011AC28 10000003 b          0x11ac38
0011AC2C C69CE2A0 lwc1       $f28, -0x1d60($s4)
0011AC30 3C043F80 lui        $a0, 0x3f80
0011AC34 4484E000 mtc1       $a0, $f28
0011AC38 461EA032 c.eq.s     $f20, $f30
0011AC3C 00000000 nop        
0011AC40 45010034 bc1t       0x11ad14
0011AC44 3C04002D lui        $a0, 0x2d
0011AC48 C62C000C lwc1       $f12, 0xc($s1)
0011AC4C 461E6032 c.eq.s     $f12, $f30
0011AC50 00000000 nop        
0011AC54 4500002F bc1f       0x11ad14
0011AC58 3C04002D lui        $a0, 0x2d
0011AC5C 266400C0 addiu      $a0, $s3, 0xc0
0011AC60 8C840014 lw         $a0, 0x14($a0)
0011AC64 30842000 andi       $a0, $a0, 0x2000
0011AC68 10800028 beqz       $a0, 0x11ad0c
0011AC6C 00000000 nop        
0011AC70 8E6600F0 lw         $a2, 0xf0($s3)
0011AC74 34040003 ori        $a0, $zero, 3
0011AC78 0C007F68 jal        0x1fda0
0011AC7C 34050005 ori        $a1, $zero, 5
0011AC80 10400023 beqz       $v0, 0x11ad10
0011AC84 C6340040 lwc1       $f20, 0x40($s1)
0011AC88 3C04002D lui        $a0, 0x2d
0011AC8C C48CE2BC lwc1       $f12, -0x1d44($a0)
0011AC90 460CA03C c.lt.s     $f20, $f12
0011AC94 00000000 nop        
0011AC98 4500001D bc1f       0x11ad10
0011AC9C 3C04002D lui        $a0, 0x2d
0011ACA0 C48CE28C lwc1       $f12, -0x1d74($a0)
0011ACA4 3C043D08 lui        $a0, 0x3d08
0011ACA8 34848889 ori        $a0, $a0, 0x8889
0011ACAC 44846800 mtc1       $a0, $f13
0011ACB0 3C063D99 lui        $a2, 0x3d99
0011ACB4 460D6302 mul.s      $f12, $f12, $f13
0011ACB8 34C6999A ori        $a2, $a2, 0x999a
0011ACBC 44867000 mtc1       $a2, $f14
0011ACC0 3C06BC23 lui        $a2, 0xbc23
0011ACC4 34C6D70A ori        $a2, $a2, 0xd70a
0011ACC8 460CA300 add.s      $f12, $f20, $f12
0011ACCC 27A50090 addiu      $a1, $sp, 0x90
0011ACD0 44867800 mtc1       $a2, $f15
0011ACD4 34040001 ori        $a0, $zero, 1
0011ACD8 3C063FC0 lui        $a2, 0x3fc0
0011ACDC 4600F406 mov.s      $f16, $f30
0011ACE0 2407FFFF addiu      $a3, $zero, -1
0011ACE4 E62C0040 swc1       $f12, 0x40($s1)
0011ACE8 44866000 mtc1       $a2, $f12
0011ACEC 34080007 ori        $t0, $zero, 7
0011ACF0 3C064060 lui        $a2, 0x4060
0011ACF4 44866800 mtc1       $a2, $f13
0011ACF8 3C06FF21 lui        $a2, 0xff21
0011ACFC 0C031BD0 jal        0xc6f40
0011AD00 24C680FF addiu      $a2, $a2, -0x7f01
0011AD04 10000002 b          0x11ad10
0011AD08 C6340040 lwc1       $f20, 0x40($s1)
0011AD0C 34150001 ori        $s5, $zero, 1
0011AD10 3C04002D lui        $a0, 0x2d
0011AD14 C48CE2C0 lwc1       $f12, -0x1d40($a0)
0011AD18 8EC4003C lw         $a0, 0x3c($s6)
0011AD1C C68DE2A0 lwc1       $f13, -0x1d60($s4)
0011AD20 460CA302 mul.s      $f12, $f20, $f12
0011AD24 00042080 sll        $a0, $a0, 2
0011AD28 009E2021 addu       $a0, $a0, $fp
0011AD2C C48E0000 lwc1       $f14, ($a0)
0011AD30 C6EFE288 lwc1       $f15, -0x1d78($s7)
0011AD34 460D6302 mul.s      $f12, $f12, $f13
0011AD38 3C04002D lui        $a0, 0x2d
0011AD3C C490E29C lwc1       $f16, -0x1d64($a0)
0011AD40 460E7B82 mul.s      $f14, $f15, $f14
0011AD44 8E6600F0 lw         $a2, 0xf0($s3)
0011AD48 4610A502 mul.s      $f20, $f20, $f16
0011AD4C 3C04002D lui        $a0, 0x2d
0011AD50 C498E280 lwc1       $f24, -0x1d80($a0)
0011AD54 460CE700 add.s      $f28, $f28, $f12
0011AD58 34040003 ori        $a0, $zero, 3
0011AD5C 34050004 ori        $a1, $zero, 4
0011AD60 0C007F68 jal        0x1fda0
0011AD64 46147500 add.s      $f20, $f14, $f20
0011AD68 10400004 beqz       $v0, 0x11ad7c
0011AD6C 00000000 nop        
0011AD70 3C04002D lui        $a0, 0x2d
0011AD74 C48CE284 lwc1       $f12, -0x1d7c($a0)
0011AD78 460CC602 mul.s      $f24, $f24, $f12
0011AD7C 8ED6003C lw         $s6, 0x3c($s6)
0011AD80 12A00007 beqz       $s5, 0x11ada0
0011AD84 26D60039 addiu      $s6, $s6, 0x39
0011AD88 0C00C41E jal        0x31078
0011AD8C 02602025 move       $a0, $s3
0011AD90 10400003 beqz       $v0, 0x11ada0
0011AD94 00000000 nop        
0011AD98 0C04685E jal        0x11a178
0011AD9C 02402025 move       $a0, $s2
0011ADA0 C62C000C lwc1       $f12, 0xc($s1)
0011ADA4 461E6032 c.eq.s     $f12, $f30
0011ADA8 00000000 nop        
0011ADAC 450101BE bc1t       0x11b4a8
0011ADB0 00000000 nop        
0011ADB4 8E250000 lw         $a1, ($s1)
0011ADB8 34040003 ori        $a0, $zero, 3
0011ADBC 0C007FEF jal        0x1ffbc
0011ADC0 8CA500F0 lw         $a1, 0xf0($a1)
0011ADC4 C62C000C lwc1       $f12, 0xc($s1)
0011ADC8 3C043F80 lui        $a0, 0x3f80
0011ADCC 44846800 mtc1       $a0, $f13
0011ADD0 0040A825 move       $s5, $v0
0011ADD4 460D6301 sub.s      $f12, $f12, $f13
0011ADD8 461E603E c.le.s     $f12, $f30
0011ADDC 00000000 nop        
0011ADE0 450001B1 bc1f       0x11b4a8
0011ADE4 E62C000C swc1       $f12, 0xc($s1)
0011ADE8 E63E000C swc1       $f30, 0xc($s1)
0011ADEC 8E240044 lw         $a0, 0x44($s1)
0011ADF0 3C054F00 lui        $a1, 0x4f00
0011ADF4 27B40090 addiu      $s4, $sp, 0x90
0011ADF8 10800003 beqz       $a0, 0x11ae08
0011ADFC 4485B000 mtc1       $a1, $f22
0011AE00 0C01B1A3 jal        0x6c68c
0011AE04 00000000 nop        
0011AE08 0C00C41E jal        0x31078
0011AE0C 02602025 move       $a0, $s3
0011AE10 3C04002D lui        $a0, 0x2d
0011AE14 1040000E beqz       $v0, 0x11ae50
0011AE18 C48CE388 lwc1       $f12, -0x1c78($a0)
0011AE1C C60D0020 lwc1       $f13, 0x20($s0)
0011AE20 460D6342 mul.s      $f13, $f12, $f13
0011AE24 27A400D0 addiu      $a0, $sp, 0xd0
0011AE28 E7AD00D0 swc1       $f13, 0xd0($sp)
0011AE2C C60D0024 lwc1       $f13, 0x24($s0)
0011AE30 460D6342 mul.s      $f13, $f12, $f13
0011AE34 E7AD00D4 swc1       $f13, 0xd4($sp)
0011AE38 C60D0028 lwc1       $f13, 0x28($s0)
0011AE3C 460D6302 mul.s      $f12, $f12, $f13
0011AE40 0C003467 jal        0xd19c
0011AE44 E7AC00D8 swc1       $f12, 0xd8($sp)
0011AE48 1000000A b          0x11ae74
0011AE4C 00000000 nop        
0011AE50 460063C6 mov.s      $f15, $f12
0011AE54 3C05002D lui        $a1, 0x2d
0011AE58 46006406 mov.s      $f16, $f12
0011AE5C 26440030 addiu      $a0, $s2, 0x30
0011AE60 C4ACE38C lwc1       $f12, -0x1c74($a1)
0011AE64 4600F386 mov.s      $f14, $f30
0011AE68 3C05002D lui        $a1, 0x2d
0011AE6C 0C003476 jal        0xd1d8
0011AE70 C4ADE390 lwc1       $f13, -0x1c70($a1)
0011AE74 27A600A0 addiu      $a2, $sp, 0xa0
0011AE78 4600A306 mov.s      $f12, $f20
0011AE7C 02402025 move       $a0, $s2
0011AE80 4600C346 mov.s      $f13, $f24
0011AE84 02802825 move       $a1, $s4
0011AE88 4600E386 mov.s      $f14, $f28
0011AE8C 02C03825 move       $a3, $s6
0011AE90 0C046D3E jal        0x11b4f8
0011AE94 34080001 ori        $t0, $zero, 1
0011AE98 C63C0040 lwc1       $f28, 0x40($s1)
0011AE9C 4616E03C c.lt.s     $f28, $f22
0011AEA0 00000000 nop        
0011AEA4 45000006 bc1f       0x11aec0
0011AEA8 0040B025 move       $s6, $v0
0011AEAC 4600E30D trunc.w.s  $f12, $f28
0011AEB0 44046000 mfc1       $a0, $f12
0011AEB4 0096B023 subu       $s6, $a0, $s6
0011AEB8 10000008 b          0x11aedc
0011AEBC 26D60008 addiu      $s6, $s6, 8
0011AEC0 4616E301 sub.s      $f12, $f28, $f22
0011AEC4 3C048000 lui        $a0, 0x8000
0011AEC8 4600630D trunc.w.s  $f12, $f12
0011AECC 44056000 mfc1       $a1, $f12
0011AED0 00A42021 addu       $a0, $a1, $a0
0011AED4 0096B023 subu       $s6, $a0, $s6
0011AED8 26D60008 addiu      $s6, $s6, 8
0011AEDC AFB600C8 sw         $s6, 0xc8($sp)
0011AEE0 0016202B sltu       $a0, $zero, $s6
0011AEE4 10800004 beqz       $a0, 0x11aef8
0011AEE8 AFA000CC sw         $zero, 0xcc($sp)
0011AEEC 27B600C8 addiu      $s6, $sp, 0xc8
0011AEF0 10000003 b          0x11af00
0011AEF4 8ED60000 lw         $s6, ($s6)
0011AEF8 27B600CC addiu      $s6, $sp, 0xcc
0011AEFC 8ED60000 lw         $s6, ($s6)
0011AF00 34170000 ori        $s7, $zero, 0
0011AF04 02F6202B sltu       $a0, $s7, $s6
0011AF08 10800090 beqz       $a0, 0x11b14c
0011AF0C 3C043ECC lui        $a0, 0x3ecc
0011AF10 3C042FFF lui        $a0, 0x2fff
0011AF14 4480F000 mtc1       $zero, $f30
0011AF18 3484FFFE ori        $a0, $a0, 0xfffe
0011AF1C 4484B000 mtc1       $a0, $f22
0011AF20 27BE0104 addiu      $fp, $sp, 0x104
0011AF24 3C043F00 lui        $a0, 0x3f00
0011AF28 4484E000 mtc1       $a0, $f28
0011AF2C E63E0040 swc1       $f30, 0x40($s1)
0011AF30 0C06B652 jal        0x1ad948
0011AF34 E7BE0138 swc1       $f30, 0x138($sp)
0011AF38 44826000 mtc1       $v0, $f12
0011AF3C 46806320 cvt.s.w    $f12, $f12
0011AF40 46166302 mul.s      $f12, $f12, $f22
0011AF44 0C06B652 jal        0x1ad948
0011AF48 461C6781 sub.s      $f30, $f12, $f28
0011AF4C 44826800 mtc1       $v0, $f13
0011AF50 46806B60 cvt.s.w    $f13, $f13
0011AF54 4600F3C6 mov.s      $f15, $f30
0011AF58 E7BE00DC swc1       $f30, 0xdc($sp)
0011AF5C 460F7B02 mul.s      $f12, $f15, $f15
0011AF60 46166C02 mul.s      $f16, $f13, $f22
0011AF64 461C8401 sub.s      $f16, $f16, $f28
0011AF68 46108382 mul.s      $f14, $f16, $f16
0011AF6C E7B000E0 swc1       $f16, 0xe0($sp)
0011AF70 460E6300 add.s      $f12, $f12, $f14
0011AF74 461A603C c.lt.s     $f12, $f26
0011AF78 00000000 nop        
0011AF7C 4500000A bc1f       0x11afa8
0011AF80 C7BE0138 lwc1       $f30, 0x138($sp)
0011AF84 C7AC00A0 lwc1       $f12, 0xa0($sp)
0011AF88 46188402 mul.s      $f16, $f16, $f24
0011AF8C C7AD00A4 lwc1       $f13, 0xa4($sp)
0011AF90 C7AE00A8 lwc1       $f14, 0xa8($sp)
0011AF94 460CA442 mul.s      $f17, $f20, $f12
0011AF98 460DA482 mul.s      $f18, $f20, $f13
0011AF9C 461C8402 mul.s      $f16, $f16, $f28
0011AFA0 10000014 b          0x11aff4
0011AFA4 460EA4C2 mul.s      $f19, $f20, $f14
0011AFA8 0C0697C0 jal        0x1a5f00
0011AFAC 00000000 nop        
0011AFB0 3C043F80 lui        $a0, 0x3f80
0011AFB4 44846000 mtc1       $a0, $f12
0011AFB8 460063C3 div.s      $f15, $f12, $f0
0011AFBC C7B000E0 lwc1       $f16, 0xe0($sp)
0011AFC0 C7A200DC lwc1       $f2, 0xdc($sp)
0011AFC4 46107C02 mul.s      $f16, $f15, $f16
0011AFC8 C7AC00A0 lwc1       $f12, 0xa0($sp)
0011AFCC C7AD00A4 lwc1       $f13, 0xa4($sp)
0011AFD0 C7AE00A8 lwc1       $f14, 0xa8($sp)
0011AFD4 460CA442 mul.s      $f17, $f20, $f12
0011AFD8 460DA482 mul.s      $f18, $f20, $f13
0011AFDC 46027BC2 mul.s      $f15, $f15, $f2
0011AFE0 E7B000E0 swc1       $f16, 0xe0($sp)
0011AFE4 46188002 mul.s      $f0, $f16, $f24
0011AFE8 460EA4C2 mul.s      $f19, $f20, $f14
0011AFEC E7AF00DC swc1       $f15, 0xdc($sp)
0011AFF0 461C0402 mul.s      $f16, $f0, $f28
0011AFF4 461E783C c.lt.s     $f15, $f30
0011AFF8 00000000 nop        
0011AFFC 45020004 bc1fl      0x11b010
0011B000 46187BC2 mul.s      $f15, $f15, $f24
0011B004 46007BC7 neg.s      $f15, $f15
0011B008 E7AF00DC swc1       $f15, 0xdc($sp)
0011B00C 46187BC2 mul.s      $f15, $f15, $f24
0011B010 C6000010 lwc1       $f0, 0x10($s0)
0011B014 461C7BC2 mul.s      $f15, $f15, $f28
0011B018 46007802 mul.s      $f0, $f15, $f0
0011B01C E7A000E4 swc1       $f0, 0xe4($sp)
0011B020 C6020014 lwc1       $f2, 0x14($s0)
0011B024 46027882 mul.s      $f2, $f15, $f2
0011B028 E7A200E8 swc1       $f2, 0xe8($sp)
0011B02C C6010018 lwc1       $f1, 0x18($s0)
0011B030 46017BC2 mul.s      $f15, $f15, $f1
0011B034 E7AF00EC swc1       $f15, 0xec($sp)
0011B038 C6030018 lwc1       $f3, 0x18($s0)
0011B03C C6040014 lwc1       $f4, 0x14($s0)
0011B040 460368C2 mul.s      $f3, $f13, $f3
0011B044 46047102 mul.s      $f4, $f14, $f4
0011B048 460418C1 sub.s      $f3, $f3, $f4
0011B04C E7A300F4 swc1       $f3, 0xf4($sp)
0011B050 C6050010 lwc1       $f5, 0x10($s0)
0011B054 C6010018 lwc1       $f1, 0x18($s0)
0011B058 46057382 mul.s      $f14, $f14, $f5
0011B05C 46016042 mul.s      $f1, $f12, $f1
0011B060 461018C2 mul.s      $f3, $f3, $f16
0011B064 46017381 sub.s      $f14, $f14, $f1
0011B068 46029080 add.s      $f2, $f18, $f2
0011B06C E7AE00F8 swc1       $f14, 0xf8($sp)
0011B070 C6040014 lwc1       $f4, 0x14($s0)
0011B074 46107382 mul.s      $f14, $f14, $f16
0011B078 C6050010 lwc1       $f5, 0x10($s0)
0011B07C 46046302 mul.s      $f12, $f12, $f4
0011B080 46056B42 mul.s      $f13, $f13, $f5
0011B084 E7A300F4 swc1       $f3, 0xf4($sp)
0011B088 E7AE00F8 swc1       $f14, 0xf8($sp)
0011B08C 46008800 add.s      $f0, $f17, $f0
0011B090 460F9BC0 add.s      $f15, $f19, $f15
0011B094 460D6341 sub.s      $f13, $f12, $f13
0011B098 46106C02 mul.s      $f16, $f13, $f16
0011B09C E7AD00FC swc1       $f13, 0xfc($sp)
0011B0A0 46030300 add.s      $f12, $f0, $f3
0011B0A4 E7B10104 swc1       $f17, 0x104($sp)
0011B0A8 E7B20108 swc1       $f18, 0x108($sp)
0011B0AC E7B3010C swc1       $f19, 0x10c($sp)
0011B0B0 460E1340 add.s      $f13, $f2, $f14
0011B0B4 E7B000FC swc1       $f16, 0xfc($sp)
0011B0B8 460C6442 mul.s      $f17, $f12, $f12
0011B0BC E7A00104 swc1       $f0, 0x104($sp)
0011B0C0 E7A20108 swc1       $f2, 0x108($sp)
0011B0C4 46107B80 add.s      $f14, $f15, $f16
0011B0C8 E7AF010C swc1       $f15, 0x10c($sp)
0011B0CC E7AC0104 swc1       $f12, 0x104($sp)
0011B0D0 E7AD0108 swc1       $f13, 0x108($sp)
0011B0D4 460D6C02 mul.s      $f16, $f13, $f13
0011B0D8 460E73C2 mul.s      $f15, $f14, $f14
0011B0DC 46108C00 add.s      $f16, $f17, $f16
0011B0E0 460F83C0 add.s      $f15, $f16, $f15
0011B0E4 461A783C c.lt.s     $f15, $f26
0011B0E8 00000000 nop        
0011B0EC 4501000B bc1t       0x11b11c
0011B0F0 E7AE010C swc1       $f14, 0x10c($sp)
0011B0F4 3C043F80 lui        $a0, 0x3f80
0011B0F8 46007BC4 sqrt.s     $f15, $f15
0011B0FC 44848000 mtc1       $a0, $f16
0011B100 460F83C3 div.s      $f15, $f16, $f15
0011B104 460F6302 mul.s      $f12, $f12, $f15
0011B108 460F6B42 mul.s      $f13, $f13, $f15
0011B10C 460F7382 mul.s      $f14, $f14, $f15
0011B110 E7AC0104 swc1       $f12, 0x104($sp)
0011B114 E7AD0108 swc1       $f13, 0x108($sp)
0011B118 E7AE010C swc1       $f14, 0x10c($sp)
0011B11C 02402025 move       $a0, $s2
0011B120 4600A306 mov.s      $f12, $f20
0011B124 02802825 move       $a1, $s4
0011B128 03C03025 move       $a2, $fp
0011B12C 0C046F9E jal        0x11be78
0011B130 02A03825 move       $a3, $s5
0011B134 26F70001 addiu      $s7, $s7, 1
0011B138 32F700FF andi       $s7, $s7, 0xff
0011B13C 02F6202B sltu       $a0, $s7, $s6
0011B140 1480FF7A bnez       $a0, 0x11af2c
0011B144 00000000 nop        
0011B148 3C043ECC lui        $a0, 0x3ecc
0011B14C 3484CCCD ori        $a0, $a0, 0xcccd
0011B150 4484C000 mtc1       $a0, $f24
0011B154 3C04BE4C lui        $a0, 0xbe4c
0011B158 3484CCCD ori        $a0, $a0, 0xcccd
0011B15C 4484B000 mtc1       $a0, $f22
0011B160 3C178081 lui        $s7, 0x8081
0011B164 3C043C23 lui        $a0, 0x3c23
0011B168 3484D70A ori        $a0, $a0, 0xd70a
0011B16C 4484F000 mtc1       $a0, $f30
0011B170 34100000 ori        $s0, $zero, 0
0011B174 3C043F7A lui        $a0, 0x3f7a
0011B178 3484E148 ori        $a0, $a0, 0xe148
0011B17C 4484E000 mtc1       $a0, $f28
0011B180 27B20114 addiu      $s2, $sp, 0x114
0011B184 3C043000 lui        $a0, 0x3000
0011B188 27B60124 addiu      $s6, $sp, 0x124
0011B18C 4484A000 mtc1       $a0, $f20
0011B190 26F78080 addiu      $s7, $s7, -0x7f80
0011B194 0C06B652 jal        0x1ad948
0011B198 00000000 nop        
0011B19C 44826000 mtc1       $v0, $f12
0011B1A0 46806320 cvt.s.w    $f12, $f12
0011B1A4 C7AD0090 lwc1       $f13, 0x90($sp)
0011B1A8 46146302 mul.s      $f12, $f12, $f20
0011B1AC 46186302 mul.s      $f12, $f12, $f24
0011B1B0 46166300 add.s      $f12, $f12, $f22
0011B1B4 460D6300 add.s      $f12, $f12, $f13
0011B1B8 0C06B652 jal        0x1ad948
0011B1BC E7AC0114 swc1       $f12, 0x114($sp)
0011B1C0 44826000 mtc1       $v0, $f12
0011B1C4 46806320 cvt.s.w    $f12, $f12
0011B1C8 C7AE0094 lwc1       $f14, 0x94($sp)
0011B1CC 46146302 mul.s      $f12, $f12, $f20
0011B1D0 46186302 mul.s      $f12, $f12, $f24
0011B1D4 46166300 add.s      $f12, $f12, $f22
0011B1D8 460E6300 add.s      $f12, $f12, $f14
0011B1DC 0C06B652 jal        0x1ad948
0011B1E0 E7AC0118 swc1       $f12, 0x118($sp)
0011B1E4 44826000 mtc1       $v0, $f12
0011B1E8 46806320 cvt.s.w    $f12, $f12
0011B1EC C7AD0098 lwc1       $f13, 0x98($sp)
0011B1F0 46146302 mul.s      $f12, $f12, $f20
0011B1F4 46186302 mul.s      $f12, $f12, $f24
0011B1F8 46166300 add.s      $f12, $f12, $f22
0011B1FC 460D6300 add.s      $f12, $f12, $f13
0011B200 0C06B652 jal        0x1ad948
0011B204 E7AC011C swc1       $f12, 0x11c($sp)
0011B208 44826000 mtc1       $v0, $f12
0011B20C 3C043FA0 lui        $a0, 0x3fa0
0011B210 46806320 cvt.s.w    $f12, $f12
0011B214 44847000 mtc1       $a0, $f14
0011B218 3C043F40 lui        $a0, 0x3f40
0011B21C 46146302 mul.s      $f12, $f12, $f20
0011B220 4484D000 mtc1       $a0, $f26
0011B224 460E6302 mul.s      $f12, $f12, $f14
0011B228 0C06B652 jal        0x1ad948
0011B22C 461A6680 add.s      $f26, $f12, $f26
0011B230 44826800 mtc1       $v0, $f13
0011B234 3C044120 lui        $a0, 0x4120
0011B238 46806B60 cvt.s.w    $f13, $f13
0011B23C 44847800 mtc1       $a0, $f15
0011B240 3C043D75 lui        $a0, 0x3d75
0011B244 44807000 mtc1       $zero, $f14
0011B248 3484C28F ori        $a0, $a0, 0xc28f
0011B24C 46146B02 mul.s      $f12, $f13, $f20
0011B250 E7AE0124 swc1       $f14, 0x124($sp)
0011B254 44848000 mtc1       $a0, $f16
0011B258 2E050002 sltiu      $a1, $s0, 2
0011B25C 3C0441C8 lui        $a0, 0x41c8
0011B260 44848800 mtc1       $a0, $f17
0011B264 E7B00128 swc1       $f16, 0x128($sp)
0011B268 460F6302 mul.s      $f12, $f12, $f15
0011B26C 3C044100 lui        $a0, 0x4100
0011B270 E7AE012C swc1       $f14, 0x12c($sp)
0011B274 44846800 mtc1       $a0, $f13
0011B278 E7AE0130 swc1       $f14, 0x130($sp)
0011B27C 34040003 ori        $a0, $zero, 3
0011B280 46116300 add.s      $f12, $f12, $f17
0011B284 460D6341 sub.s      $f13, $f12, $f13
0011B288 54A00001 bnel       $a1, $zero, 0x11b290
0011B28C 34040001 ori        $a0, $zero, 1
0011B290 34020000 ori        $v0, $zero, 0
0011B294 46006BC6 mov.s      $f15, $f13
0011B298 AFA20000 sw         $v0, ($sp)
0011B29C 46006386 mov.s      $f14, $f12
0011B2A0 3C023CA3 lui        $v0, 0x3ca3
0011B2A4 44809800 mtc1       $zero, $f19
0011B2A8 00804025 move       $t0, $a0
0011B2AC 4600D306 mov.s      $f12, $f26
0011B2B0 3442D70A ori        $v0, $v0, 0xd70a
0011B2B4 46009B46 mov.s      $f13, $f19
0011B2B8 340A0001 ori        $t2, $zero, 1
0011B2BC 4600F446 mov.s      $f17, $f30
0011B2C0 340B0000 ori        $t3, $zero, 0
0011B2C4 4600E486 mov.s      $f18, $f28
0011B2C8 34040001 ori        $a0, $zero, 1
0011B2CC 44828000 mtc1       $v0, $f16
0011B2D0 02402825 move       $a1, $s2
0011B2D4 02C03025 move       $a2, $s6
0011B2D8 02E03825 move       $a3, $s7
0011B2DC 0C03297A jal        0xca5e8
0011B2E0 3409000B ori        $t1, $zero, 0xb
0011B2E4 26100001 addiu      $s0, $s0, 1
0011B2E8 2E040004 sltiu      $a0, $s0, 4
0011B2EC 1480FFA9 bnez       $a0, 0x11b194
0011B2F0 02B52021 addu       $a0, $s5, $s5
0011B2F4 02A42021 addu       $a0, $s5, $a0
0011B2F8 3C05002D lui        $a1, 0x2d
0011B2FC 00042080 sll        $a0, $a0, 2
0011B300 24A5E2A4 addiu      $a1, $a1, -0x1d5c
0011B304 00858021 addu       $s0, $a0, $a1
0011B308 8E070000 lw         $a3, ($s0)
0011B30C 34020000 ori        $v0, $zero, 0
0011B310 AFA20000 sw         $v0, ($sp)
0011B314 3C16002D lui        $s6, 0x2d
0011B318 3C023F00 lui        $v0, 0x3f00
0011B31C 4480A000 mtc1       $zero, $f20
0011B320 C6CEE2C8 lwc1       $f14, -0x1d38($s6)
0011B324 4482B000 mtc1       $v0, $f22
0011B328 3C17002D lui        $s7, 0x2d
0011B32C 4600A346 mov.s      $f13, $f20
0011B330 C6ECE2C4 lwc1       $f12, -0x1d3c($s7)
0011B334 461673C2 mul.s      $f15, $f14, $f22
0011B338 3C023FC0 lui        $v0, 0x3fc0
0011B33C 4600A4C6 mov.s      $f19, $f20
0011B340 44828800 mtc1       $v0, $f17
0011B344 3C04002D lui        $a0, 0x2d
0011B348 46116302 mul.s      $f12, $f12, $f17
0011B34C 3C023F80 lui        $v0, 0x3f80
0011B350 34120001 ori        $s2, $zero, 1
0011B354 4482C000 mtc1       $v0, $f24
0011B358 2495A368 addiu      $s5, $a0, -0x5c98
0011B35C 4600B406 mov.s      $f16, $f22
0011B360 3C1E002D lui        $fp, 0x2d
0011B364 4600C486 mov.s      $f18, $f24
0011B368 340B0000 ori        $t3, $zero, 0
0011B36C 00002025 move       $a0, $zero
0011B370 02802825 move       $a1, $s4
0011B374 02A03025 move       $a2, $s5
0011B378 34080001 ori        $t0, $zero, 1
0011B37C 34090034 ori        $t1, $zero, 0x34
0011B380 02405025 move       $t2, $s2
0011B384 0C03297A jal        0xca5e8
0011B388 C7D1E2CC lwc1       $f17, -0x1d34($fp)
0011B38C C6CEE2C8 lwc1       $f14, -0x1d38($s6)
0011B390 3C043F99 lui        $a0, 0x3f99
0011B394 4600C486 mov.s      $f18, $f24
0011B398 C6ECE2C4 lwc1       $f12, -0x1d3c($s7)
0011B39C 461673C2 mul.s      $f15, $f14, $f22
0011B3A0 3484999A ori        $a0, $a0, 0x999a
0011B3A4 4600A4C6 mov.s      $f19, $f20
0011B3A8 44846800 mtc1       $a0, $f13
0011B3AC C7D1E2CC lwc1       $f17, -0x1d34($fp)
0011B3B0 460D6302 mul.s      $f12, $f12, $f13
0011B3B4 8E070004 lw         $a3, 4($s0)
0011B3B8 34020000 ori        $v0, $zero, 0
0011B3BC AFA20000 sw         $v0, ($sp)
0011B3C0 3C02BF00 lui        $v0, 0xbf00
0011B3C4 4600A346 mov.s      $f13, $f20
0011B3C8 340B0000 ori        $t3, $zero, 0
0011B3CC 00002025 move       $a0, $zero
0011B3D0 44828000 mtc1       $v0, $f16
0011B3D4 02802825 move       $a1, $s4
0011B3D8 02A03025 move       $a2, $s5
0011B3DC 34080001 ori        $t0, $zero, 1
0011B3E0 34090025 ori        $t1, $zero, 0x25
0011B3E4 0C03297A jal        0xca5e8
0011B3E8 02405025 move       $t2, $s2
0011B3EC C6ECE2C4 lwc1       $f12, -0x1d3c($s7)
0011B3F0 4600A346 mov.s      $f13, $f20
0011B3F4 C6CEE2C8 lwc1       $f14, -0x1d38($s6)
0011B3F8 4600C486 mov.s      $f18, $f24
0011B3FC C7D1E2CC lwc1       $f17, -0x1d34($fp)
0011B400 4600A4C6 mov.s      $f19, $f20
0011B404 8E070008 lw         $a3, 8($s0)
0011B408 461673C2 mul.s      $f15, $f14, $f22
0011B40C 34020000 ori        $v0, $zero, 0
0011B410 AFA20000 sw         $v0, ($sp)
0011B414 3C023E4C lui        $v0, 0x3e4c
0011B418 3442CCCD ori        $v0, $v0, 0xcccd
0011B41C 340B0000 ori        $t3, $zero, 0
0011B420 44828000 mtc1       $v0, $f16
0011B424 00002025 move       $a0, $zero
0011B428 02802825 move       $a1, $s4
0011B42C 02A03025 move       $a2, $s5
0011B430 34080001 ori        $t0, $zero, 1
0011B434 34090034 ori        $t1, $zero, 0x34
0011B438 0C03297A jal        0xca5e8
0011B43C 02405025 move       $t2, $s2
0011B440 0C00C41E jal        0x31078
0011B444 02602025 move       $a0, $s3
0011B448 5040000F beql       $v0, $zero, 0x11b488
0011B44C C7AC0090 lwc1       $f12, 0x90($sp)
0011B450 3C0A002D lui        $t2, 0x2d
0011B454 C54CE378 lwc1       $f12, -0x1c88($t2)
0011B458 3C0A002D lui        $t2, 0x2d
0011B45C C54DE37C lwc1       $f13, -0x1c84($t2)
0011B460 3C0A002D lui        $t2, 0x2d
0011B464 00002025 move       $a0, $zero
0011B468 00002825 move       $a1, $zero
0011B46C 2406FFFF addiu      $a2, $zero, -1
0011B470 340700AA ori        $a3, $zero, 0xaa
0011B474 34080007 ori        $t0, $zero, 7
0011B478 00004825 move       $t1, $zero
0011B47C 0C0317FD jal        0xc5ff4
0011B480 C54EE374 lwc1       $f14, -0x1c8c($t2)
0011B484 C7AC0090 lwc1       $f12, 0x90($sp)
0011B488 3C04002D lui        $a0, 0x2d
0011B48C E62C0054 swc1       $f12, 0x54($s1)
0011B490 C7AC0094 lwc1       $f12, 0x94($sp)
0011B494 E62C0058 swc1       $f12, 0x58($s1)
0011B498 C7AC0098 lwc1       $f12, 0x98($sp)
0011B49C E62C005C swc1       $f12, 0x5c($s1)
0011B4A0 C48CE2E8 lwc1       $f12, -0x1d18($a0)
0011B4A4 E62C0050 swc1       $f12, 0x50($s1)
0011B4A8 0C046952 jal        0x11a548
0011B4AC 26240048 addiu      $a0, $s1, 0x48
0011B4B0 C7B4013C lwc1       $f20, 0x13c($sp)
0011B4B4 C7B60140 lwc1       $f22, 0x140($sp)
0011B4B8 C7B80144 lwc1       $f24, 0x144($sp)
0011B4BC C7BA0148 lwc1       $f26, 0x148($sp)
0011B4C0 C7BC014C lwc1       $f28, 0x14c($sp)
0011B4C4 C7BE0150 lwc1       $f30, 0x150($sp)
0011B4C8 8FB00154 lw         $s0, 0x154($sp)
0011B4CC 8FB10158 lw         $s1, 0x158($sp)
0011B4D0 8FB2015C lw         $s2, 0x15c($sp)
0011B4D4 8FB30160 lw         $s3, 0x160($sp)
0011B4D8 8FB40164 lw         $s4, 0x164($sp)
0011B4DC 8FB50168 lw         $s5, 0x168($sp)
0011B4E0 8FB6016C lw         $s6, 0x16c($sp)
0011B4E4 8FB70170 lw         $s7, 0x170($sp)
0011B4E8 8FBE0174 lw         $fp, 0x174($sp)
0011B4EC 8FBF0178 lw         $ra, 0x178($sp)
0011B4F0 03E00008 jr         $ra
0011B4F4 27BD0180 addiu      $sp, $sp, 0x180