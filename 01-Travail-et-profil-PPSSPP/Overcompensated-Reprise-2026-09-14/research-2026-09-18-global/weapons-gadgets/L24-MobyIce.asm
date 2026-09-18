
CALLBACK 0x0013BC04 end 0x0013BC1C ordinal 0

0013BC04 8C850064 lw         $a1, 0x64($a0)
0013BC08 A0800045 sb         $zero, 0x45($a0)
0013BC0C 34A51000 ori        $a1, $a1, 0x1000
0013BC10 AC850064 sw         $a1, 0x64($a0)
0013BC14 03E00008 jr         $ra
0013BC18 34020001 ori        $v0, $zero, 1

CALLBACK 0x0013BC1C end 0x0013BCE4 ordinal 1

0013BC1C 27BDFFD0 addiu      $sp, $sp, -0x30
0013BC20 8C860058 lw         $a2, 0x58($a0)
0013BC24 8CC50024 lw         $a1, 0x24($a2)
0013BC28 AFBF0020 sw         $ra, 0x20($sp)
0013BC2C 10A0000C beqz       $a1, 0x13bc60
0013BC30 00000000 nop        
0013BC34 8CC40018 lw         $a0, 0x18($a2)
0013BC38 10800027 beqz       $a0, 0x13bcd8
0013BC3C 00000000 nop        
0013BC40 8CC50004 lw         $a1, 4($a2)
0013BC44 10A00004 beqz       $a1, 0x13bc58
0013BC48 AC850000 sw         $a1, ($a0)
0013BC4C 8CC40018 lw         $a0, 0x18($a2)
0013BC50 8CC50004 lw         $a1, 4($a2)
0013BC54 ACA40014 sw         $a0, 0x14($a1)
0013BC58 1000001F b          0x13bcd8
0013BC5C ACC00018 sw         $zero, 0x18($a2)
0013BC60 8CC60028 lw         $a2, 0x28($a2)
0013BC64 10C0001C beqz       $a2, 0x13bcd8
0013BC68 00000000 nop        
0013BC6C 90850045 lbu        $a1, 0x45($a0)
0013BC70 14A00019 bnez       $a1, 0x13bcd8
0013BC74 00000000 nop        
0013BC78 8CC50040 lw         $a1, 0x40($a2)
0013BC7C 8CA50020 lw         $a1, 0x20($a1)
0013BC80 10A00015 beqz       $a1, 0x13bcd8
0013BC84 3C07002A lui        $a3, 0x2a
0013BC88 24E8A864 addiu      $t0, $a3, -0x579c
0013BC8C 25080FA0 addiu      $t0, $t0, 0xfa0
0013BC90 8D070000 lw         $a3, ($t0)
0013BC94 28E90002 slti       $t1, $a3, 2
0013BC98 15200007 bnez       $t1, 0x13bcb8
0013BC9C C50C0004 lwc1       $f12, 4($t0)
0013BCA0 28E70003 slti       $a3, $a3, 3
0013BCA4 10E00004 beqz       $a3, 0x13bcb8
0013BCA8 3C073F00 lui        $a3, 0x3f00
0013BCAC 44876800 mtc1       $a3, $f13
0013BCB0 10000001 b          0x13bcb8
0013BCB4 460D6302 mul.s      $f12, $f12, $f13
0013BCB8 00A05025 move       $t2, $a1
0013BCBC 00804825 move       $t1, $a0
0013BCC0 8D050008 lw         $a1, 8($t0)
0013BCC4 00C02025 move       $a0, $a2
0013BCC8 8D06000C lw         $a2, 0xc($t0)
0013BCCC 00003825 move       $a3, $zero
0013BCD0 0140F809 jalr       $t2
0013BCD4 00004025 move       $t0, $zero
0013BCD8 8FBF0020 lw         $ra, 0x20($sp)
0013BCDC 03E00008 jr         $ra
0013BCE0 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x0013C5A0 end 0x0013CE54 ordinal 2

0013C5A0 27BDFFA0 addiu      $sp, $sp, -0x60
0013C5A4 C48C0070 lwc1       $f12, 0x70($a0)
0013C5A8 3C053F80 lui        $a1, 0x3f80
0013C5AC 44856800 mtc1       $a1, $f13
0013C5B0 460D6301 sub.s      $f12, $f12, $f13
0013C5B4 AFB10054 sw         $s1, 0x54($sp)
0013C5B8 8C910058 lw         $s1, 0x58($a0)
0013C5BC AFB00050 sw         $s0, 0x50($sp)
0013C5C0 00808025 move       $s0, $a0
0013C5C4 E48C0070 swc1       $f12, 0x70($a0)
0013C5C8 8E240028 lw         $a0, 0x28($s1)
0013C5CC E7B4004C swc1       $f20, 0x4c($sp)
0013C5D0 AFB20058 sw         $s2, 0x58($sp)
0013C5D4 AFBF005C sw         $ra, 0x5c($sp)
0013C5D8 10800009 beqz       $a0, 0x13c600
0013C5DC 00000000 nop        
0013C5E0 8E240028 lw         $a0, 0x28($s1)
0013C5E4 24840030 addiu      $a0, $a0, 0x30
0013C5E8 C48C0000 lwc1       $f12, ($a0)
0013C5EC E60C0030 swc1       $f12, 0x30($s0)
0013C5F0 C48C0004 lwc1       $f12, 4($a0)
0013C5F4 E60C0034 swc1       $f12, 0x34($s0)
0013C5F8 C48C0008 lwc1       $f12, 8($a0)
0013C5FC E60C0038 swc1       $f12, 0x38($s0)
0013C600 92040045 lbu        $a0, 0x45($s0)
0013C604 5C800008 bgtzl      $a0, 0x13c628
0013C608 28840002 slti       $a0, $a0, 2
0013C60C 04800105 bltz       $a0, 0x13ca24
0013C610 00000000 nop        
0013C614 8E240024 lw         $a0, 0x24($s1)
0013C618 1480000A bnez       $a0, 0x13c644
0013C61C 00000000 nop        
0013C620 10000102 b          0x13ca2c
0013C624 00000000 nop        
0013C628 108000FE beqz       $a0, 0x13ca24
0013C62C 00000000 nop        
0013C630 8E240028 lw         $a0, 0x28($s1)
0013C634 54800198 bnel       $a0, $zero, 0x13cc98
0013C638 C60D0070 lwc1       $f13, 0x70($s0)
0013C63C 100001F3 b          0x13ce0c
0013C640 00000000 nop        
0013C644 8E240028 lw         $a0, 0x28($s1)
0013C648 10800028 beqz       $a0, 0x13c6ec
0013C64C 34120000 ori        $s2, $zero, 0
0013C650 8E240028 lw         $a0, 0x28($s1)
0013C654 8C840064 lw         $a0, 0x64($a0)
0013C658 30840001 andi       $a0, $a0, 1
0013C65C 10800014 beqz       $a0, 0x13c6b0
0013C660 00000000 nop        
0013C664 8E240028 lw         $a0, 0x28($s1)
0013C668 8C840064 lw         $a0, 0x64($a0)
0013C66C 30840006 andi       $a0, $a0, 6
0013C670 1480000F bnez       $a0, 0x13c6b0
0013C674 00000000 nop        
0013C678 8E240028 lw         $a0, 0x28($s1)
0013C67C 8C840064 lw         $a0, 0x64($a0)
0013C680 30840008 andi       $a0, $a0, 8
0013C684 1480000A bnez       $a0, 0x13c6b0
0013C688 00000000 nop        
0013C68C 8E240028 lw         $a0, 0x28($s1)
0013C690 8C840040 lw         $a0, 0x40($a0)
0013C694 8C840010 lw         $a0, 0x10($a0)
0013C698 8C84003C lw         $a0, 0x3c($a0)
0013C69C 30840008 andi       $a0, $a0, 8
0013C6A0 1480000A bnez       $a0, 0x13c6cc
0013C6A4 00000000 nop        
0013C6A8 10000010 b          0x13c6ec
0013C6AC 00000000 nop        
0013C6B0 0C04EF80 jal        0x13be00
0013C6B4 02002025 move       $a0, $s0
0013C6B8 02002025 move       $a0, $s0
0013C6BC 0C0192FF jal        0x64bfc
0013C6C0 34050001 ori        $a1, $zero, 1
0013C6C4 100001DC b          0x13ce38
0013C6C8 00000000 nop        
0013C6CC 8E260028 lw         $a2, 0x28($s1)
0013C6D0 2625005C addiu      $a1, $s1, 0x5c
0013C6D4 0C03BC37 jal        0xef0dc
0013C6D8 02002025 move       $a0, $s0
0013C6DC 8E250028 lw         $a1, 0x28($s1)
0013C6E0 0C03AB3E jal        0xeacf8
0013C6E4 2624002C addiu      $a0, $s1, 0x2c
0013C6E8 34120001 ori        $s2, $zero, 1
0013C6EC 0C04F060 jal        0x13c180
0013C6F0 02002025 move       $a0, $s0
0013C6F4 C62C001C lwc1       $f12, 0x1c($s1)
0013C6F8 C62D0020 lwc1       $f13, 0x20($s1)
0013C6FC 460D603C c.lt.s     $f12, $f13
0013C700 00000000 nop        
0013C704 45000029 bc1f       0x13c7ac
0013C708 00000000 nop        
0013C70C 8E240024 lw         $a0, 0x24($s1)
0013C710 34050001 ori        $a1, $zero, 1
0013C714 14850013 bne        $a0, $a1, 0x13c764
0013C718 00000000 nop        
0013C71C 3C04002A lui        $a0, 0x2a
0013C720 C48C2270 lwc1       $f12, 0x2270($a0)
0013C724 3C12002A lui        $s2, 0x2a
0013C728 C64D226C lwc1       $f13, 0x226c($s2)
0013C72C 0C060057 jal        0x18015c
0013C730 460D6501 sub.s      $f20, $f12, $f13
0013C734 44827000 mtc1       $v0, $f14
0013C738 3C043000 lui        $a0, 0x3000
0013C73C 468073A0 cvt.s.w    $f14, $f14
0013C740 44847800 mtc1       $a0, $f15
0013C744 C650226C lwc1       $f16, 0x226c($s2)
0013C748 C62C001C lwc1       $f12, 0x1c($s1)
0013C74C 460F7342 mul.s      $f13, $f14, $f15
0013C750 46146B42 mul.s      $f13, $f13, $f20
0013C754 460D8340 add.s      $f13, $f16, $f13
0013C758 460C6B00 add.s      $f12, $f13, $f12
0013C75C 10000012 b          0x13c7a8
0013C760 E62C001C swc1       $f12, 0x1c($s1)
0013C764 3C04002A lui        $a0, 0x2a
0013C768 C48C2278 lwc1       $f12, 0x2278($a0)
0013C76C 3C12002A lui        $s2, 0x2a
0013C770 C64D2274 lwc1       $f13, 0x2274($s2)
0013C774 0C060057 jal        0x18015c
0013C778 460D6501 sub.s      $f20, $f12, $f13
0013C77C 44827000 mtc1       $v0, $f14
0013C780 3C043000 lui        $a0, 0x3000
0013C784 468073A0 cvt.s.w    $f14, $f14
0013C788 44847800 mtc1       $a0, $f15
0013C78C C6502274 lwc1       $f16, 0x2274($s2)
0013C790 C62C001C lwc1       $f12, 0x1c($s1)
0013C794 460F7342 mul.s      $f13, $f14, $f15
0013C798 46146B42 mul.s      $f13, $f13, $f20
0013C79C 460D8340 add.s      $f13, $f16, $f13
0013C7A0 460C6B00 add.s      $f12, $f13, $f12
0013C7A4 E62C001C swc1       $f12, 0x1c($s1)
0013C7A8 34120001 ori        $s2, $zero, 1
0013C7AC 1240004D beqz       $s2, 0x13c8e4
0013C7B0 3C040006 lui        $a0, 6
0013C7B4 C60C0010 lwc1       $f12, 0x10($s0)
0013C7B8 C60D0014 lwc1       $f13, 0x14($s0)
0013C7BC 460C6382 mul.s      $f14, $f12, $f12
0013C7C0 C60F0018 lwc1       $f15, 0x18($s0)
0013C7C4 460D6B42 mul.s      $f13, $f13, $f13
0013C7C8 3C043480 lui        $a0, 0x3480
0013C7CC 460F7BC2 mul.s      $f15, $f15, $f15
0013C7D0 44848000 mtc1       $a0, $f16
0013C7D4 460D7340 add.s      $f13, $f14, $f13
0013C7D8 460F6B40 add.s      $f13, $f13, $f15
0013C7DC 4610683C c.lt.s     $f13, $f16
0013C7E0 00000000 nop        
0013C7E4 4501000C bc1t       0x13c818
0013C7E8 C62C001C lwc1       $f12, 0x1c($s1)
0013C7EC 46006B44 sqrt.s     $f13, $f13
0013C7F0 460D6303 div.s      $f12, $f12, $f13
0013C7F4 C60E0010 lwc1       $f14, 0x10($s0)
0013C7F8 C60F0014 lwc1       $f15, 0x14($s0)
0013C7FC C6100018 lwc1       $f16, 0x18($s0)
0013C800 460C7382 mul.s      $f14, $f14, $f12
0013C804 460C7BC2 mul.s      $f15, $f15, $f12
0013C808 E60E0010 swc1       $f14, 0x10($s0)
0013C80C 460C8302 mul.s      $f12, $f16, $f12
0013C810 E60F0014 swc1       $f15, 0x14($s0)
0013C814 E60C0018 swc1       $f12, 0x18($s0)
0013C818 C60C0000 lwc1       $f12, ($s0)
0013C81C C60D0004 lwc1       $f13, 4($s0)
0013C820 460C6382 mul.s      $f14, $f12, $f12
0013C824 C60F0008 lwc1       $f15, 8($s0)
0013C828 460D6B42 mul.s      $f13, $f13, $f13
0013C82C 3C043480 lui        $a0, 0x3480
0013C830 460F7BC2 mul.s      $f15, $f15, $f15
0013C834 44848000 mtc1       $a0, $f16
0013C838 460D7340 add.s      $f13, $f14, $f13
0013C83C 460F6B40 add.s      $f13, $f13, $f15
0013C840 4610683C c.lt.s     $f13, $f16
0013C844 00000000 nop        
0013C848 4501000C bc1t       0x13c87c
0013C84C C62C001C lwc1       $f12, 0x1c($s1)
0013C850 46006B44 sqrt.s     $f13, $f13
0013C854 460D6303 div.s      $f12, $f12, $f13
0013C858 C60E0000 lwc1       $f14, ($s0)
0013C85C C60F0004 lwc1       $f15, 4($s0)
0013C860 C6100008 lwc1       $f16, 8($s0)
0013C864 460C7382 mul.s      $f14, $f14, $f12
0013C868 460C7BC2 mul.s      $f15, $f15, $f12
0013C86C E60E0000 swc1       $f14, ($s0)
0013C870 460C8302 mul.s      $f12, $f16, $f12
0013C874 E60F0004 swc1       $f15, 4($s0)
0013C878 E60C0008 swc1       $f12, 8($s0)
0013C87C C60C0020 lwc1       $f12, 0x20($s0)
0013C880 C60D0024 lwc1       $f13, 0x24($s0)
0013C884 460C6382 mul.s      $f14, $f12, $f12
0013C888 C60F0028 lwc1       $f15, 0x28($s0)
0013C88C 460D6B42 mul.s      $f13, $f13, $f13
0013C890 3C043480 lui        $a0, 0x3480
0013C894 460F7BC2 mul.s      $f15, $f15, $f15
0013C898 44848000 mtc1       $a0, $f16
0013C89C 460D7340 add.s      $f13, $f14, $f13
0013C8A0 460F6B40 add.s      $f13, $f13, $f15
0013C8A4 4610683C c.lt.s     $f13, $f16
0013C8A8 00000000 nop        
0013C8AC 4501000C bc1t       0x13c8e0
0013C8B0 C62C001C lwc1       $f12, 0x1c($s1)
0013C8B4 46006B44 sqrt.s     $f13, $f13
0013C8B8 460D6303 div.s      $f12, $f12, $f13
0013C8BC C60E0020 lwc1       $f14, 0x20($s0)
0013C8C0 C60F0024 lwc1       $f15, 0x24($s0)
0013C8C4 C6100028 lwc1       $f16, 0x28($s0)
0013C8C8 460C7382 mul.s      $f14, $f14, $f12
0013C8CC 460C7BC2 mul.s      $f15, $f15, $f12
0013C8D0 E60E0020 swc1       $f14, 0x20($s0)
0013C8D4 460C8302 mul.s      $f12, $f16, $f12
0013C8D8 E60F0024 swc1       $f15, 0x24($s0)
0013C8DC E60C0028 swc1       $f12, 0x28($s0)
0013C8E0 3C040006 lui        $a0, 6
0013C8E4 2484A8B8 addiu      $a0, $a0, -0x5748
0013C8E8 24840030 addiu      $a0, $a0, 0x30
0013C8EC 8C850004 lw         $a1, 4($a0)
0013C8F0 8C860000 lw         $a2, ($a0)
0013C8F4 AFA50024 sw         $a1, 0x24($sp)
0013C8F8 C7AC0024 lwc1       $f12, 0x24($sp)
0013C8FC 8C840008 lw         $a0, 8($a0)
0013C900 3C050028 lui        $a1, 0x28
0013C904 C4ADF8F4 lwc1       $f13, -0x70c($a1)
0013C908 AFA60020 sw         $a2, 0x20($sp)
0013C90C 460D6300 add.s      $f12, $f12, $f13
0013C910 AFA40028 sw         $a0, 0x28($sp)
0013C914 92040044 lbu        $a0, 0x44($s0)
0013C918 8E050040 lw         $a1, 0x40($s0)
0013C91C 00043100 sll        $a2, $a0, 4
0013C920 E7AC0024 swc1       $f12, 0x24($sp)
0013C924 00862021 addu       $a0, $a0, $a2
0013C928 8CA50004 lw         $a1, 4($a1)
0013C92C 00042080 sll        $a0, $a0, 2
0013C930 00862023 subu       $a0, $a0, $a2
0013C934 00A42021 addu       $a0, $a1, $a0
0013C938 8C84000C lw         $a0, 0xc($a0)
0013C93C 1080000C beqz       $a0, 0x13c970
0013C940 00000000 nop        
0013C944 8C860004 lw         $a2, 4($a0)
0013C948 90870000 lbu        $a3, ($a0)
0013C94C 3C05002A lui        $a1, 0x2a
0013C950 C4AC2268 lwc1       $f12, 0x2268($a1)
0013C954 00C02825 move       $a1, $a2
0013C958 00E03025 move       $a2, $a3
0013C95C 27A40020 addiu      $a0, $sp, 0x20
0013C960 0C005FFB jal        0x17fec
0013C964 02003825 move       $a3, $s0
0013C968 1440000E bnez       $v0, 0x13c9a4
0013C96C 00000000 nop        
0013C970 C60C0070 lwc1       $f12, 0x70($s0)
0013C974 44806800 mtc1       $zero, $f13
0013C978 460D603E c.le.s     $f12, $f13
0013C97C 00000000 nop        
0013C980 4500000F bc1f       0x13c9c0
0013C984 00000000 nop        
0013C988 0C04EF80 jal        0x13be00
0013C98C 02002025 move       $a0, $s0
0013C990 02002025 move       $a0, $s0
0013C994 0C0192FF jal        0x64bfc
0013C998 34050001 ori        $a1, $zero, 1
0013C99C 10000126 b          0x13ce38
0013C9A0 00000000 nop        
0013C9A4 0C04EF80 jal        0x13be00
0013C9A8 02002025 move       $a0, $s0
0013C9AC 02002025 move       $a0, $s0
0013C9B0 0C0192FF jal        0x64bfc
0013C9B4 34050001 ori        $a1, $zero, 1
0013C9B8 1000011F b          0x13ce38
0013C9BC 00000000 nop        
0013C9C0 C62C001C lwc1       $f12, 0x1c($s1)
0013C9C4 27A4002C addiu      $a0, $sp, 0x2c
0013C9C8 26060030 addiu      $a2, $s0, 0x30
0013C9CC 34050008 ori        $a1, $zero, 8
0013C9D0 34070469 ori        $a3, $zero, 0x469
0013C9D4 34080001 ori        $t0, $zero, 1
0013C9D8 34090002 ori        $t1, $zero, 2
0013C9DC 0C00555F jal        0x1557c
0013C9E0 340A0001 ori        $t2, $zero, 1
0013C9E4 00408025 move       $s0, $v0
0013C9E8 34120000 ori        $s2, $zero, 0
0013C9EC 0250202B sltu       $a0, $s2, $s0
0013C9F0 1080000C beqz       $a0, 0x13ca24
0013C9F4 00000000 nop        
0013C9F8 00122080 sll        $a0, $s2, 2
0013C9FC 8E250000 lw         $a1, ($s1)
0013CA00 03A42021 addu       $a0, $sp, $a0
0013CA04 8C86002C lw         $a2, 0x2c($a0)
0013CA08 00A02025 move       $a0, $a1
0013CA0C 0C04ECE6 jal        0x13b398
0013CA10 00C02825 move       $a1, $a2
0013CA14 26520001 addiu      $s2, $s2, 1
0013CA18 0250202B sltu       $a0, $s2, $s0
0013CA1C 1480FFF6 bnez       $a0, 0x13c9f8
0013CA20 00000000 nop        
0013CA24 10000104 b          0x13ce38
0013CA28 00000000 nop        
0013CA2C 8E240028 lw         $a0, 0x28($s1)
0013CA30 10800092 beqz       $a0, 0x13cc7c
0013CA34 00000000 nop        
0013CA38 8E240028 lw         $a0, 0x28($s1)
0013CA3C 8C840064 lw         $a0, 0x64($a0)
0013CA40 30840006 andi       $a0, $a0, 6
0013CA44 1480000B bnez       $a0, 0x13ca74
0013CA48 00000000 nop        
0013CA4C 8E240028 lw         $a0, 0x28($s1)
0013CA50 8C840064 lw         $a0, 0x64($a0)
0013CA54 30840008 andi       $a0, $a0, 8
0013CA58 14800006 bnez       $a0, 0x13ca74
0013CA5C 00000000 nop        
0013CA60 8E240028 lw         $a0, 0x28($s1)
0013CA64 8C840064 lw         $a0, 0x64($a0)
0013CA68 30840001 andi       $a0, $a0, 1
0013CA6C 14800024 bnez       $a0, 0x13cb00
0013CA70 00000000 nop        
0013CA74 8E310028 lw         $s1, 0x28($s1)
0013CA78 8E240040 lw         $a0, 0x40($s1)
0013CA7C 8C850020 lw         $a1, 0x20($a0)
0013CA80 10A00018 beqz       $a1, 0x13cae4
0013CA84 3C05002A lui        $a1, 0x2a
0013CA88 24A5A864 addiu      $a1, $a1, -0x579c
0013CA8C 24A50FA0 addiu      $a1, $a1, 0xfa0
0013CA90 00A03025 move       $a2, $a1
0013CA94 8CC70000 lw         $a3, ($a2)
0013CA98 28E80002 slti       $t0, $a3, 2
0013CA9C 15000008 bnez       $t0, 0x13cac0
0013CAA0 28E70003 slti       $a3, $a3, 3
0013CAA4 50E00007 beql       $a3, $zero, 0x13cac4
0013CAA8 C4CC0004 lwc1       $f12, 4($a2)
0013CAAC C4CC0004 lwc1       $f12, 4($a2)
0013CAB0 3C063F00 lui        $a2, 0x3f00
0013CAB4 44866800 mtc1       $a2, $f13
0013CAB8 10000002 b          0x13cac4
0013CABC 460D6302 mul.s      $f12, $f12, $f13
0013CAC0 C4CC0004 lwc1       $f12, 4($a2)
0013CAC4 8CA6000C lw         $a2, 0xc($a1)
0013CAC8 8CA50008 lw         $a1, 8($a1)
0013CACC 8C8A0020 lw         $t2, 0x20($a0)
0013CAD0 02202025 move       $a0, $s1
0013CAD4 00003825 move       $a3, $zero
0013CAD8 00004025 move       $t0, $zero
0013CADC 0140F809 jalr       $t2
0013CAE0 02004825 move       $t1, $s0
0013CAE4 0C04EF80 jal        0x13be00
0013CAE8 02002025 move       $a0, $s0
0013CAEC 02002025 move       $a0, $s0
0013CAF0 0C0192FF jal        0x64bfc
0013CAF4 34050001 ori        $a1, $zero, 1
0013CAF8 100000CF b          0x13ce38
0013CAFC 00000000 nop        
0013CB00 8E240028 lw         $a0, 0x28($s1)
0013CB04 2405F040 addiu      $a1, $zero, -0xfc0
0013CB08 00003025 move       $a2, $zero
0013CB0C 0C0188F1 jal        0x623c4
0013CB10 00003825 move       $a3, $zero
0013CB14 0C04F060 jal        0x13c180
0013CB18 02002025 move       $a0, $s0
0013CB1C C60C0070 lwc1       $f12, 0x70($s0)
0013CB20 44806800 mtc1       $zero, $f13
0013CB24 460D603E c.le.s     $f12, $f13
0013CB28 00000000 nop        
0013CB2C 45000028 bc1f       0x13cbd0
0013CB30 00000000 nop        
0013CB34 8E310028 lw         $s1, 0x28($s1)
0013CB38 8E240040 lw         $a0, 0x40($s1)
0013CB3C 8C850020 lw         $a1, 0x20($a0)
0013CB40 10A00018 beqz       $a1, 0x13cba4
0013CB44 3C05002A lui        $a1, 0x2a
0013CB48 24A5A864 addiu      $a1, $a1, -0x579c
0013CB4C 24A50FA0 addiu      $a1, $a1, 0xfa0
0013CB50 00A03025 move       $a2, $a1
0013CB54 8CC70000 lw         $a3, ($a2)
0013CB58 28E80002 slti       $t0, $a3, 2
0013CB5C 15000008 bnez       $t0, 0x13cb80
0013CB60 28E70003 slti       $a3, $a3, 3
0013CB64 50E00007 beql       $a3, $zero, 0x13cb84
0013CB68 C4CC0004 lwc1       $f12, 4($a2)
0013CB6C C4CC0004 lwc1       $f12, 4($a2)
0013CB70 3C063F00 lui        $a2, 0x3f00
0013CB74 44866800 mtc1       $a2, $f13
0013CB78 10000002 b          0x13cb84
0013CB7C 460D6302 mul.s      $f12, $f12, $f13
0013CB80 C4CC0004 lwc1       $f12, 4($a2)
0013CB84 8CA6000C lw         $a2, 0xc($a1)
0013CB88 8CA50008 lw         $a1, 8($a1)
0013CB8C 8C8A0020 lw         $t2, 0x20($a0)
0013CB90 02202025 move       $a0, $s1
0013CB94 00003825 move       $a3, $zero
0013CB98 00004025 move       $t0, $zero
0013CB9C 0140F809 jalr       $t2
0013CBA0 02004825 move       $t1, $s0
0013CBA4 0C04EF80 jal        0x13be00
0013CBA8 02002025 move       $a0, $s0
0013CBAC 3C04002A lui        $a0, 0x2a
0013CBB0 C48C2244 lwc1       $f12, 0x2244($a0)
0013CBB4 34040001 ori        $a0, $zero, 1
0013CBB8 E60C0070 swc1       $f12, 0x70($s0)
0013CBBC 8E050064 lw         $a1, 0x64($s0)
0013CBC0 A2040045 sb         $a0, 0x45($s0)
0013CBC4 34A40020 ori        $a0, $a1, 0x20
0013CBC8 1000009B b          0x13ce38
0013CBCC AE040064 sw         $a0, 0x64($s0)
0013CBD0 8E310028 lw         $s1, 0x28($s1)
0013CBD4 8E240040 lw         $a0, 0x40($s1)
0013CBD8 8C850020 lw         $a1, 0x20($a0)
0013CBDC 14A00003 bnez       $a1, 0x13cbec
0013CBE0 3C05002A lui        $a1, 0x2a
0013CBE4 10000019 b          0x13cc4c
0013CBE8 2411FFFF addiu      $s1, $zero, -1
0013CBEC 24A5A864 addiu      $a1, $a1, -0x579c
0013CBF0 24A50F90 addiu      $a1, $a1, 0xf90
0013CBF4 00A03025 move       $a2, $a1
0013CBF8 8CC70000 lw         $a3, ($a2)
0013CBFC 28E80002 slti       $t0, $a3, 2
0013CC00 15000008 bnez       $t0, 0x13cc24
0013CC04 28E70003 slti       $a3, $a3, 3
0013CC08 50E00007 beql       $a3, $zero, 0x13cc28
0013CC0C C4CC0004 lwc1       $f12, 4($a2)
0013CC10 C4CC0004 lwc1       $f12, 4($a2)
0013CC14 3C063F00 lui        $a2, 0x3f00
0013CC18 44866800 mtc1       $a2, $f13
0013CC1C 10000002 b          0x13cc28
0013CC20 460D6302 mul.s      $f12, $f12, $f13
0013CC24 C4CC0004 lwc1       $f12, 4($a2)
0013CC28 8CA6000C lw         $a2, 0xc($a1)
0013CC2C 8CA50008 lw         $a1, 8($a1)
0013CC30 8C8A0020 lw         $t2, 0x20($a0)
0013CC34 02202025 move       $a0, $s1
0013CC38 00003825 move       $a3, $zero
0013CC3C 00004025 move       $t0, $zero
0013CC40 0140F809 jalr       $t2
0013CC44 02004825 move       $t1, $s0
0013CC48 00408825 move       $s1, $v0
0013CC4C 34040003 ori        $a0, $zero, 3
0013CC50 16240008 bne        $s1, $a0, 0x13cc74
0013CC54 00000000 nop        
0013CC58 0C04EF80 jal        0x13be00
0013CC5C 02002025 move       $a0, $s0
0013CC60 02002025 move       $a0, $s0
0013CC64 0C0192FF jal        0x64bfc
0013CC68 34050001 ori        $a1, $zero, 1
0013CC6C 10000072 b          0x13ce38
0013CC70 00000000 nop        
0013CC74 1000FF6B b          0x13ca24
0013CC78 00000000 nop        
0013CC7C 0C04EF80 jal        0x13be00
0013CC80 02002025 move       $a0, $s0
0013CC84 02002025 move       $a0, $s0
0013CC88 0C0192FF jal        0x64bfc
0013CC8C 34050001 ori        $a1, $zero, 1
0013CC90 10000069 b          0x13ce38
0013CC94 00000000 nop        
0013CC98 3C04002A lui        $a0, 0x2a
0013CC9C C48C2244 lwc1       $f12, 0x2244($a0)
0013CCA0 460C6B43 div.s      $f13, $f13, $f12
0013CCA4 3C043F80 lui        $a0, 0x3f80
0013CCA8 340500FF ori        $a1, $zero, 0xff
0013CCAC 44857000 mtc1       $a1, $f14
0013CCB0 468073A0 cvt.s.w    $f14, $f14
0013CCB4 44846000 mtc1       $a0, $f12
0013CCB8 04A10004 bgez       $a1, 0x13cccc
0013CCBC 460D6301 sub.s      $f12, $f12, $f13
0013CCC0 3C044F80 lui        $a0, 0x4f80
0013CCC4 44847800 mtc1       $a0, $f15
0013CCC8 460F7380 add.s      $f14, $f14, $f15
0013CCCC 34040040 ori        $a0, $zero, 0x40
0013CCD0 44847800 mtc1       $a0, $f15
0013CCD4 04810004 bgez       $a0, 0x13cce8
0013CCD8 46807BE0 cvt.s.w    $f15, $f15
0013CCDC 3C044F80 lui        $a0, 0x4f80
0013CCE0 44848000 mtc1       $a0, $f16
0013CCE4 46107BC0 add.s      $f15, $f15, $f16
0013CCE8 460D7BC2 mul.s      $f15, $f15, $f13
0013CCEC 460C7382 mul.s      $f14, $f14, $f12
0013CCF0 340500FF ori        $a1, $zero, 0xff
0013CCF4 44858000 mtc1       $a1, $f16
0013CCF8 460F73C0 add.s      $f15, $f14, $f15
0013CCFC 46007BCD trunc.w.s  $f15, $f15
0013CD00 468083A0 cvt.s.w    $f14, $f16
0013CD04 04A10004 bgez       $a1, 0x13cd18
0013CD08 44047800 mfc1       $a0, $f15
0013CD0C 3C054F80 lui        $a1, 0x4f80
0013CD10 44857800 mtc1       $a1, $f15
0013CD14 460F7380 add.s      $f14, $f14, $f15
0013CD18 340500F0 ori        $a1, $zero, 0xf0
0013CD1C 44857800 mtc1       $a1, $f15
0013CD20 04A10004 bgez       $a1, 0x13cd34
0013CD24 46807BE0 cvt.s.w    $f15, $f15
0013CD28 3C054F80 lui        $a1, 0x4f80
0013CD2C 44858000 mtc1       $a1, $f16
0013CD30 46107BC0 add.s      $f15, $f15, $f16
0013CD34 460D7BC2 mul.s      $f15, $f15, $f13
0013CD38 460C7382 mul.s      $f14, $f14, $f12
0013CD3C 340600FF ori        $a2, $zero, 0xff
0013CD40 44868000 mtc1       $a2, $f16
0013CD44 460F73C0 add.s      $f15, $f14, $f15
0013CD48 46007BCD trunc.w.s  $f15, $f15
0013CD4C 468083A0 cvt.s.w    $f14, $f16
0013CD50 04C10004 bgez       $a2, 0x13cd64
0013CD54 44057800 mfc1       $a1, $f15
0013CD58 3C064F80 lui        $a2, 0x4f80
0013CD5C 44867800 mtc1       $a2, $f15
0013CD60 460F7380 add.s      $f14, $f14, $f15
0013CD64 340600FF ori        $a2, $zero, 0xff
0013CD68 44867800 mtc1       $a2, $f15
0013CD6C 04C10004 bgez       $a2, 0x13cd80
0013CD70 46807BE0 cvt.s.w    $f15, $f15
0013CD74 3C064F80 lui        $a2, 0x4f80
0013CD78 44868000 mtc1       $a2, $f16
0013CD7C 46107BC0 add.s      $f15, $f15, $f16
0013CD80 460D7BC2 mul.s      $f15, $f15, $f13
0013CD84 460C7382 mul.s      $f14, $f14, $f12
0013CD88 340700FF ori        $a3, $zero, 0xff
0013CD8C 44878000 mtc1       $a3, $f16
0013CD90 460F73C0 add.s      $f15, $f14, $f15
0013CD94 46007BCD trunc.w.s  $f15, $f15
0013CD98 468083A0 cvt.s.w    $f14, $f16
0013CD9C 04E10004 bgez       $a3, 0x13cdb0
0013CDA0 44067800 mfc1       $a2, $f15
0013CDA4 3C074F80 lui        $a3, 0x4f80
0013CDA8 44877800 mtc1       $a3, $f15
0013CDAC 460F7380 add.s      $f14, $f14, $f15
0013CDB0 340700FF ori        $a3, $zero, 0xff
0013CDB4 44877800 mtc1       $a3, $f15
0013CDB8 04E10004 bgez       $a3, 0x13cdcc
0013CDBC 46807BE0 cvt.s.w    $f15, $f15
0013CDC0 3C074F80 lui        $a3, 0x4f80
0013CDC4 44878000 mtc1       $a3, $f16
0013CDC8 46107BC0 add.s      $f15, $f15, $f16
0013CDCC 460D7B42 mul.s      $f13, $f15, $f13
0013CDD0 460C7302 mul.s      $f12, $f14, $f12
0013CDD4 00064C00 sll        $t1, $a2, 0x10
0013CDD8 00052A00 sll        $a1, $a1, 8
0013CDDC 00804025 move       $t0, $a0
0013CDE0 460D6300 add.s      $f12, $f12, $f13
0013CDE4 8E240028 lw         $a0, 0x28($s1)
0013CDE8 00003025 move       $a2, $zero
0013CDEC 00003825 move       $a3, $zero
0013CDF0 4600630D trunc.w.s  $f12, $f12
0013CDF4 440A6000 mfc1       $t2, $f12
0013CDF8 000A5600 sll        $t2, $t2, 0x18
0013CDFC 01494825 or         $t1, $t2, $t1
0013CE00 01252825 or         $a1, $t1, $a1
0013CE04 0C0188F1 jal        0x623c4
0013CE08 00A82825 or         $a1, $a1, $t0
0013CE0C C60C0070 lwc1       $f12, 0x70($s0)
0013CE10 44806800 mtc1       $zero, $f13
0013CE14 460D603E c.le.s     $f12, $f13
0013CE18 00000000 nop        
0013CE1C 45010003 bc1t       0x13ce2c
0013CE20 00000000 nop        
0013CE24 1000FEFF b          0x13ca24
0013CE28 00000000 nop        
0013CE2C 02002025 move       $a0, $s0
0013CE30 0C0192FF jal        0x64bfc
0013CE34 34050001 ori        $a1, $zero, 1
0013CE38 C7B4004C lwc1       $f20, 0x4c($sp)
0013CE3C 8FB00050 lw         $s0, 0x50($sp)
0013CE40 8FB10054 lw         $s1, 0x54($sp)
0013CE44 8FB20058 lw         $s2, 0x58($sp)
0013CE48 8FBF005C lw         $ra, 0x5c($sp)
0013CE4C 03E00008 jr         $ra
0013CE50 27BD0060 addiu      $sp, $sp, 0x60