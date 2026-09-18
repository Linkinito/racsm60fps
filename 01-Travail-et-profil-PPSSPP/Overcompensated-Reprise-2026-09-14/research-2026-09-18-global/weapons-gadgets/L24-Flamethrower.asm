
CALLBACK 0x00122D88 end 0x00122EB0 ordinal 0

00122D88 27BDFFD0 addiu      $sp, $sp, -0x30
00122D8C AFB00020 sw         $s0, 0x20($sp)
00122D90 00808025 move       $s0, $a0
00122D94 AFB20028 sw         $s2, 0x28($sp)
00122D98 8E120058 lw         $s2, 0x58($s0)
00122D9C 8E040048 lw         $a0, 0x48($s0)
00122DA0 3C050012 lui        $a1, 0x12
00122DA4 24A547FC addiu      $a1, $a1, 0x47fc
00122DA8 AC8500DC sw         $a1, 0xdc($a0)
00122DAC 8E040058 lw         $a0, 0x58($s0)
00122DB0 00002825 move       $a1, $zero
00122DB4 AFB10024 sw         $s1, 0x24($sp)
00122DB8 AFBF002C sw         $ra, 0x2c($sp)
00122DBC 0C0600AC jal        0x1802b0
00122DC0 3406027C ori        $a2, $zero, 0x27c
00122DC4 3C110028 lui        $s1, 0x28
00122DC8 8E25F8D8 lw         $a1, -0x728($s1)
00122DCC 3404000A ori        $a0, $zero, 0xa
00122DD0 0C007769 jal        0x1dda4
00122DD4 8CA500F0 lw         $a1, 0xf0($a1)
00122DD8 3C05F801 lui        $a1, 0xf801
00122DDC 24A5FFFF addiu      $a1, $a1, -1
00122DE0 3C06002A lui        $a2, 0x2a
00122DE4 1040000B beqz       $v0, 0x122e14
00122DE8 3C040009 lui        $a0, 9
00122DEC 3C07002A lui        $a3, 0x2a
00122DF0 C4ECF4B0 lwc1       $f12, -0xb50($a3)
00122DF4 E64C0278 swc1       $f12, 0x278($s2)
00122DF8 8CC7F514 lw         $a3, -0xaec($a2)
00122DFC 8C88CF90 lw         $t0, -0x3070($a0)
00122E00 00E59024 and        $s2, $a3, $a1
00122E04 00082C00 sll        $a1, $t0, 0x10
00122E08 8E24F8D8 lw         $a0, -0x728($s1)
00122E0C 1000000A b          0x122e38
00122E10 02459025 or         $s2, $s2, $a1
00122E14 3C07002A lui        $a3, 0x2a
00122E18 C4ECF484 lwc1       $f12, -0xb7c($a3)
00122E1C E64C0278 swc1       $f12, 0x278($s2)
00122E20 8CC7F514 lw         $a3, -0xaec($a2)
00122E24 8C88CF90 lw         $t0, -0x3070($a0)
00122E28 00E59024 and        $s2, $a3, $a1
00122E2C 00082C00 sll        $a1, $t0, 0x10
00122E30 8E24F8D8 lw         $a0, -0x728($s1)
00122E34 02459025 or         $s2, $s2, $a1
00122E38 ACD2F514 sw         $s2, -0xaec($a2)
00122E3C 8C8600F0 lw         $a2, 0xf0($a0)
00122E40 26040074 addiu      $a0, $s0, 0x74
00122E44 3405000A ori        $a1, $zero, 0xa
00122E48 0C006F54 jal        0x1bd50
00122E4C 2407FFFF addiu      $a3, $zero, -1
00122E50 8E24F8D8 lw         $a0, -0x728($s1)
00122E54 3C05002A lui        $a1, 0x2a
00122E58 C4ACF4D0 lwc1       $f12, -0xb30($a1)
00122E5C 3C05002A lui        $a1, 0x2a
00122E60 C4ADF4D4 lwc1       $f13, -0xb2c($a1)
00122E64 3C05002A lui        $a1, 0x2a
00122E68 C4AEF4D8 lwc1       $f14, -0xb28($a1)
00122E6C 3C05002A lui        $a1, 0x2a
00122E70 3C06002A lui        $a2, 0x2a
00122E74 34070001 ori        $a3, $zero, 1
00122E78 24A5F4C4 addiu      $a1, $a1, -0xb3c
00122E7C 0C01569F jal        0x55a7c
00122E80 24C69AE4 addiu      $a2, $a2, -0x651c
00122E84 8E040064 lw         $a0, 0x64($s0)
00122E88 3C050004 lui        $a1, 4
00122E8C 00852025 or         $a0, $a0, $a1
00122E90 AE040064 sw         $a0, 0x64($s0)
00122E94 34020001 ori        $v0, $zero, 1
00122E98 8FB00020 lw         $s0, 0x20($sp)
00122E9C 8FB10024 lw         $s1, 0x24($sp)
00122EA0 8FB20028 lw         $s2, 0x28($sp)
00122EA4 8FBF002C lw         $ra, 0x2c($sp)
00122EA8 03E00008 jr         $ra
00122EAC 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x00122F04 end 0x00122FA8 ordinal 1

00122F04 27BDFFD0 addiu      $sp, $sp, -0x30
00122F08 AFB3001C sw         $s3, 0x1c($sp)
00122F0C 8C930058 lw         $s3, 0x58($a0)
00122F10 8E640008 lw         $a0, 8($s3)
00122F14 AFB00010 sw         $s0, 0x10($sp)
00122F18 AFB10014 sw         $s1, 0x14($sp)
00122F1C AFB20018 sw         $s2, 0x18($sp)
00122F20 AFBF0020 sw         $ra, 0x20($sp)
00122F24 10800018 beqz       $a0, 0x122f88
00122F28 00000000 nop        
00122F2C 8E650004 lw         $a1, 4($s3)
00122F30 34120000 ori        $s2, $zero, 0
00122F34 0245202B sltu       $a0, $s2, $a1
00122F38 10800013 beqz       $a0, 0x122f88
00122F3C 02608825 move       $s1, $s3
00122F40 3C100028 lui        $s0, 0x28
00122F44 8E240018 lw         $a0, 0x18($s1)
00122F48 1080000A beqz       $a0, 0x122f74
00122F4C 00000000 nop        
00122F50 8E0527F8 lw         $a1, 0x27f8($s0)
00122F54 14850004 bne        $a0, $a1, 0x122f68
00122F58 00000000 nop        
00122F5C AE0027F8 sw         $zero, 0x27f8($s0)
00122F60 10000004 b          0x122f74
00122F64 8E650004 lw         $a1, 4($s3)
00122F68 0C02172B jal        0x85cac
00122F6C 00000000 nop        
00122F70 8E650004 lw         $a1, 4($s3)
00122F74 AE200018 sw         $zero, 0x18($s1)
00122F78 26520001 addiu      $s2, $s2, 1
00122F7C 0245202B sltu       $a0, $s2, $a1
00122F80 1480FFF0 bnez       $a0, 0x122f44
00122F84 26310004 addiu      $s1, $s1, 4
00122F88 AE600000 sw         $zero, ($s3)
00122F8C 8FB00010 lw         $s0, 0x10($sp)
00122F90 8FB10014 lw         $s1, 0x14($sp)
00122F94 8FB20018 lw         $s2, 0x18($sp)
00122F98 8FB3001C lw         $s3, 0x1c($sp)
00122F9C 8FBF0020 lw         $ra, 0x20($sp)
00122FA0 03E00008 jr         $ra
00122FA4 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x00123D14 end 0x00124010 ordinal 2

00123D14 27BDFFB0 addiu      $sp, $sp, -0x50
00123D18 AFB0002C sw         $s0, 0x2c($sp)
00123D1C 00808025 move       $s0, $a0
00123D20 AFB10030 sw         $s1, 0x30($sp)
00123D24 8E110058 lw         $s1, 0x58($s0)
00123D28 AFB20034 sw         $s2, 0x34($sp)
00123D2C AFB30038 sw         $s3, 0x38($sp)
00123D30 34120001 ori        $s2, $zero, 1
00123D34 8E330000 lw         $s3, ($s1)
00123D38 A2320015 sb         $s2, 0x15($s1)
00123D3C 27A40020 addiu      $a0, $sp, 0x20
00123D40 E7B40028 swc1       $f20, 0x28($sp)
00123D44 AFB4003C sw         $s4, 0x3c($sp)
00123D48 AFB50040 sw         $s5, 0x40($sp)
00123D4C AFB60044 sw         $s6, 0x44($sp)
00123D50 AFBF0048 sw         $ra, 0x48($sp)
00123D54 0C00A9C4 jal        0x2a710
00123D58 02602825 move       $a1, $s3
00123D5C 8E6500F0 lw         $a1, 0xf0($s3)
00123D60 0C007541 jal        0x1d504
00123D64 3404000A ori        $a0, $zero, 0xa
00123D68 92040046 lbu        $a0, 0x46($s0)
00123D6C 34050001 ori        $a1, $zero, 1
00123D70 14850056 bne        $a0, $a1, 0x123ecc
00123D74 0040A025 move       $s4, $v0
00123D78 8E240000 lw         $a0, ($s1)
00123D7C C60C0070 lwc1       $f12, 0x70($s0)
00123D80 8C9500D4 lw         $s5, 0xd4($a0)
00123D84 3C043F80 lui        $a0, 0x3f80
00123D88 44846800 mtc1       $a0, $f13
00123D8C 460D6300 add.s      $f12, $f12, $f13
00123D90 26240010 addiu      $a0, $s1, 0x10
00123D94 3C05002A lui        $a1, 0x2a
00123D98 4480A000 mtc1       $zero, $f20
00123D9C E60C0070 swc1       $f12, 0x70($s0)
00123DA0 C48C0000 lwc1       $f12, ($a0)
00123DA4 460D6300 add.s      $f12, $f12, $f13
00123DA8 E48C0000 swc1       $f12, ($a0)
00123DAC C48E0000 lwc1       $f14, ($a0)
00123DB0 C4ACF4A8 lwc1       $f12, -0xb58($a1)
00123DB4 460C703E c.le.s     $f14, $f12
00123DB8 00000000 nop        
00123DBC 45020001 bc1fl      0x123dc4
00123DC0 E48C0000 swc1       $f12, ($a0)
00123DC4 C60C0070 lwc1       $f12, 0x70($s0)
00123DC8 3C04002A lui        $a0, 0x2a
00123DCC C48DF498 lwc1       $f13, -0xb68($a0)
00123DD0 460D603C c.lt.s     $f12, $f13
00123DD4 00000000 nop        
00123DD8 45010006 bc1t       0x123df4
00123DDC 00000000 nop        
00123DE0 460D6301 sub.s      $f12, $f12, $f13
00123DE4 E60C0070 swc1       $f12, 0x70($s0)
00123DE8 8E840040 lw         $a0, 0x40($s4)
00123DEC 2484FFFF addiu      $a0, $a0, -1
00123DF0 AE840040 sw         $a0, 0x40($s4)
00123DF4 0C049004 jal        0x124010
00123DF8 02002025 move       $a0, $s0
00123DFC 3C05002A lui        $a1, 0x2a
00123E00 C4ACF4A4 lwc1       $f12, -0xb5c($a1)
00123E04 3C05FF23 lui        $a1, 0xff23
00123E08 26040030 addiu      $a0, $s0, 0x30
00123E0C 0C01CC7B jal        0x731ec
00123E10 24A599FF addiu      $a1, $a1, -0x6601
00123E14 32A42000 andi       $a0, $s5, 0x2000
00123E18 1080000A beqz       $a0, 0x123e44
00123E1C 00000000 nop        
00123E20 8E840040 lw         $a0, 0x40($s4)
00123E24 10800007 beqz       $a0, 0x123e44
00123E28 00000000 nop        
00123E2C 8E240000 lw         $a0, ($s1)
00123E30 C48C0964 lwc1       $f12, 0x964($a0)
00123E34 4614603E c.le.s     $f12, $f20
00123E38 00000000 nop        
00123E3C 45000016 bc1f       0x123e98
00123E40 00000000 nop        
00123E44 A2000045 sb         $zero, 0x45($s0)
00123E48 4600A346 mov.s      $f13, $f20
00123E4C A2000046 sb         $zero, 0x46($s0)
00123E50 3C07002A lui        $a3, 0x2a
00123E54 C4ECF480 lwc1       $f12, -0xb80($a3)
00123E58 02002025 move       $a0, $s0
00123E5C 00002825 move       $a1, $zero
00123E60 00003025 move       $a2, $zero
00123E64 0C01955C jal        0x65570
00123E68 34070001 ori        $a3, $zero, 1
00123E6C 3404012C ori        $a0, $zero, 0x12c
00123E70 AE240008 sw         $a0, 8($s1)
00123E74 E634000C swc1       $f20, 0xc($s1)
00123E78 8E6600F0 lw         $a2, 0xf0($s3)
00123E7C 3404000A ori        $a0, $zero, 0xa
00123E80 0C0076E2 jal        0x1db88
00123E84 3405001A ori        $a1, $zero, 0x1a
00123E88 1040000E beqz       $v0, 0x123ec4
00123E8C 00000000 nop        
00123E90 1000000C b          0x123ec4
00123E94 A2320016 sb         $s2, 0x16($s1)
00123E98 866400F8 lh         $a0, 0xf8($s3)
00123E9C 3405003E ori        $a1, $zero, 0x3e
00123EA0 10850008 beq        $a0, $a1, 0x123ec4
00123EA4 00000000 nop        
00123EA8 C66C0264 lwc1       $f12, 0x264($s3)
00123EAC 46146032 c.eq.s     $f12, $f20
00123EB0 00000000 nop        
00123EB4 45000003 bc1f       0x123ec4
00123EB8 00000000 nop        
00123EBC 34040009 ori        $a0, $zero, 9
00123EC0 A2040045 sb         $a0, 0x45($s0)
00123EC4 10000047 b          0x123fe4
00123EC8 00000000 nop        
00123ECC 8FA40020 lw         $a0, 0x20($sp)
00123ED0 30840020 andi       $a0, $a0, 0x20
00123ED4 1080002F beqz       $a0, 0x123f94
00123ED8 00000000 nop        
00123EDC 0C0070C3 jal        0x1c30c
00123EE0 02602025 move       $a0, $s3
00123EE4 1040002B beqz       $v0, 0x123f94
00123EE8 00000000 nop        
00123EEC 8E240000 lw         $a0, ($s1)
00123EF0 8C8400D4 lw         $a0, 0xd4($a0)
00123EF4 30842000 andi       $a0, $a0, 0x2000
00123EF8 10800026 beqz       $a0, 0x123f94
00123EFC 00000000 nop        
00123F00 8E240004 lw         $a0, 4($s1)
00123F04 34140000 ori        $s4, $zero, 0
00123F08 0284282B sltu       $a1, $s4, $a0
00123F0C 10A00013 beqz       $a1, 0x123f5c
00123F10 0220A825 move       $s5, $s1
00123F14 3C160028 lui        $s6, 0x28
00123F18 8EA50018 lw         $a1, 0x18($s5)
00123F1C 10A0000A beqz       $a1, 0x123f48
00123F20 00000000 nop        
00123F24 8EC427F8 lw         $a0, 0x27f8($s6)
00123F28 14A40004 bne        $a1, $a0, 0x123f3c
00123F2C 00000000 nop        
00123F30 AEC027F8 sw         $zero, 0x27f8($s6)
00123F34 10000004 b          0x123f48
00123F38 8E240004 lw         $a0, 4($s1)
00123F3C 0C02172B jal        0x85cac
00123F40 00A02025 move       $a0, $a1
00123F44 8E240004 lw         $a0, 4($s1)
00123F48 AEA00018 sw         $zero, 0x18($s5)
00123F4C 26940001 addiu      $s4, $s4, 1
00123F50 0284282B sltu       $a1, $s4, $a0
00123F54 14A0FFF0 bnez       $a1, 0x123f18
00123F58 26B50004 addiu      $s5, $s5, 4
00123F5C AE200004 sw         $zero, 4($s1)
00123F60 44806800 mtc1       $zero, $f13
00123F64 AE200008 sw         $zero, 8($s1)
00123F68 A2320014 sb         $s2, 0x14($s1)
00123F6C A2120046 sb         $s2, 0x46($s0)
00123F70 34040009 ori        $a0, $zero, 9
00123F74 A2040045 sb         $a0, 0x45($s0)
00123F78 3C08002A lui        $t0, 0x2a
00123F7C 02002025 move       $a0, $s0
00123F80 34050003 ori        $a1, $zero, 3
00123F84 00003025 move       $a2, $zero
00123F88 34070001 ori        $a3, $zero, 1
00123F8C 0C01955C jal        0x65570
00123F90 C50CF480 lwc1       $f12, -0xb80($t0)
00123F94 8E240018 lw         $a0, 0x18($s1)
00123F98 1080000B beqz       $a0, 0x123fc8
00123F9C 00000000 nop        
00123FA0 8E050064 lw         $a1, 0x64($s0)
00123FA4 90860005 lbu        $a2, 5($a0)
00123FA8 30A40020 andi       $a0, $a1, 0x20
00123FAC 00042942 srl        $a1, $a0, 5
00123FB0 10C50005 beq        $a2, $a1, 0x123fc8
00123FB4 00000000 nop        
00123FB8 0004282B sltu       $a1, $zero, $a0
00123FBC 30A500FF andi       $a1, $a1, 0xff
00123FC0 0C048D7C jal        0x1235f0
00123FC4 02002025 move       $a0, $s0
00123FC8 8E6600F0 lw         $a2, 0xf0($s3)
00123FCC 3404000A ori        $a0, $zero, 0xa
00123FD0 0C0076E2 jal        0x1db88
00123FD4 3405001A ori        $a1, $zero, 0x1a
00123FD8 10400002 beqz       $v0, 0x123fe4
00123FDC 00000000 nop        
00123FE0 A2320016 sb         $s2, 0x16($s1)
00123FE4 C7B40028 lwc1       $f20, 0x28($sp)
00123FE8 8FB0002C lw         $s0, 0x2c($sp)
00123FEC 8FB10030 lw         $s1, 0x30($sp)
00123FF0 8FB20034 lw         $s2, 0x34($sp)
00123FF4 8FB30038 lw         $s3, 0x38($sp)
00123FF8 8FB4003C lw         $s4, 0x3c($sp)
00123FFC 8FB50040 lw         $s5, 0x40($sp)
00124000 8FB60044 lw         $s6, 0x44($sp)
00124004 8FBF0048 lw         $ra, 0x48($sp)
00124008 03E00008 jr         $ra
0012400C 27BD0050 addiu      $sp, $sp, 0x50