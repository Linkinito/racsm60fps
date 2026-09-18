
CALLBACK 0x00116380 end 0x001164DC ordinal 0

00116380 27BDFFC0 addiu      $sp, $sp, -0x40
00116384 AFB2002C sw         $s2, 0x2c($sp)
00116388 00809025 move       $s2, $a0
0011638C AFB10028 sw         $s1, 0x28($sp)
00116390 8E510058 lw         $s1, 0x58($s2)
00116394 3C05002B lui        $a1, 0x2b
00116398 AFB00024 sw         $s0, 0x24($sp)
0011639C 24B028D8 addiu      $s0, $a1, 0x28d8
001163A0 AE200000 sw         $zero, ($s1)
001163A4 26240018 addiu      $a0, $s1, 0x18
001163A8 00002825 move       $a1, $zero
001163AC 34060044 ori        $a2, $zero, 0x44
001163B0 34070045 ori        $a3, $zero, 0x45
001163B4 E7B40020 swc1       $f20, 0x20($sp)
001163B8 AFBF0030 sw         $ra, 0x30($sp)
001163BC 0C019B8F jal        0x66e3c
001163C0 02004025 move       $t0, $s0
001163C4 26240040 addiu      $a0, $s1, 0x40
001163C8 00002825 move       $a1, $zero
001163CC 34060044 ori        $a2, $zero, 0x44
001163D0 34070045 ori        $a3, $zero, 0x45
001163D4 0C019B8F jal        0x66e3c
001163D8 02004025 move       $t0, $s0
001163DC 0C03F495 jal        0xfd254
001163E0 2624008C addiu      $a0, $s1, 0x8c
001163E4 0C03F4BD jal        0xfd2f4
001163E8 26240068 addiu      $a0, $s1, 0x68
001163EC 3C043EAA lui        $a0, 0x3eaa
001163F0 3484AAAB ori        $a0, $a0, 0xaaab
001163F4 44846000 mtc1       $a0, $f12
001163F8 AE200008 sw         $zero, 8($s1)
001163FC E62C0004 swc1       $f12, 4($s1)
00116400 4480A000 mtc1       $zero, $f20
00116404 A22000B8 sb         $zero, 0xb8($s1)
00116408 E63400BC swc1       $f20, 0xbc($s1)
0011640C A22000B9 sb         $zero, 0xb9($s1)
00116410 A2400046 sb         $zero, 0x46($s2)
00116414 3C10002B lui        $s0, 0x2b
00116418 8E0500C0 lw         $a1, 0xc0($s0)
0011641C 8CA600F0 lw         $a2, 0xf0($a1)
00116420 26440074 addiu      $a0, $s2, 0x74
00116424 34050002 ori        $a1, $zero, 2
00116428 0C0077E7 jal        0x1df9c
0011642C 2407FFFF addiu      $a3, $zero, -1
00116430 8E0500C0 lw         $a1, 0xc0($s0)
00116434 34040002 ori        $a0, $zero, 2
00116438 0C007FEF jal        0x1ffbc
0011643C 8CA500F0 lw         $a1, 0xf0($a1)
00116440 10400006 beqz       $v0, 0x11645c
00116444 00000000 nop        
00116448 8E0500C0 lw         $a1, 0xc0($s0)
0011644C 0C045E33 jal        0x1178cc
00116450 02402025 move       $a0, $s2
00116454 10000002 b          0x116460
00116458 AE22000C sw         $v0, 0xc($s1)
0011645C AE20000C sw         $zero, 0xc($s1)
00116460 34050000 ori        $a1, $zero, 0
00116464 02202025 move       $a0, $s1
00116468 AC800010 sw         $zero, 0x10($a0)
0011646C 02253021 addu       $a2, $s1, $a1
00116470 A0C000BA sb         $zero, 0xba($a2)
00116474 24A50001 addiu      $a1, $a1, 1
00116478 2CA60002 sltiu      $a2, $a1, 2
0011647C 14C0FFFA bnez       $a2, 0x116468
00116480 24840004 addiu      $a0, $a0, 4
00116484 E63400B4 swc1       $f20, 0xb4($s1)
00116488 8E0400C0 lw         $a0, 0xc0($s0)
0011648C 3C05002D lui        $a1, 0x2d
00116490 C4ACDDC4 lwc1       $f12, -0x223c($a1)
00116494 3C05002D lui        $a1, 0x2d
00116498 C4ADDDC8 lwc1       $f13, -0x2238($a1)
0011649C 3C05002D lui        $a1, 0x2d
001164A0 C4AEDDCC lwc1       $f14, -0x2234($a1)
001164A4 3C05002D lui        $a1, 0x2d
001164A8 3C06002D lui        $a2, 0x2d
001164AC 34070001 ori        $a3, $zero, 1
001164B0 24A5DDB8 addiu      $a1, $a1, -0x2248
001164B4 0C01707F jal        0x5c1fc
001164B8 24C6DDA4 addiu      $a2, $a2, -0x225c
001164BC 34020001 ori        $v0, $zero, 1
001164C0 C7B40020 lwc1       $f20, 0x20($sp)
001164C4 8FB00024 lw         $s0, 0x24($sp)
001164C8 8FB10028 lw         $s1, 0x28($sp)
001164CC 8FB2002C lw         $s2, 0x2c($sp)
001164D0 8FBF0030 lw         $ra, 0x30($sp)
001164D4 03E00008 jr         $ra
001164D8 27BD0040 addiu      $sp, $sp, 0x40

CALLBACK 0x001164DC end 0x00116534 ordinal 1

001164DC 27BDFFE0 addiu      $sp, $sp, -0x20
001164E0 AFB00010 sw         $s0, 0x10($sp)
001164E4 8C900058 lw         $s0, 0x58($a0)
001164E8 AFBF0014 sw         $ra, 0x14($sp)
001164EC 0C03F4A0 jal        0xfd280
001164F0 2604008C addiu      $a0, $s0, 0x8c
001164F4 8E10000C lw         $s0, 0xc($s0)
001164F8 1200000A beqz       $s0, 0x116524
001164FC 00000000 nop        
00116500 02002025 move       $a0, $s0
00116504 0C01A8F0 jal        0x6a3c0
00116508 34050001 ori        $a1, $zero, 1
0011650C 8E040064 lw         $a0, 0x64($s0)
00116510 30840006 andi       $a0, $a0, 6
00116514 10800003 beqz       $a0, 0x116524
00116518 00000000 nop        
0011651C 0C01A966 jal        0x6a598
00116520 02002025 move       $a0, $s0
00116524 8FB00010 lw         $s0, 0x10($sp)
00116528 8FBF0014 lw         $ra, 0x14($sp)
0011652C 03E00008 jr         $ra
00116530 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x00116A00 end 0x001178CC ordinal 2

00116A00 27BDFE70 addiu      $sp, $sp, -0x190
00116A04 00802825 move       $a1, $a0
00116A08 AFBE0184 sw         $fp, 0x184($sp)
00116A0C 8CBE0058 lw         $fp, 0x58($a1)
00116A10 AFB6017C sw         $s6, 0x17c($sp)
00116A14 8FD60000 lw         $s6, ($fp)
00116A18 AFB00164 sw         $s0, 0x164($sp)
00116A1C 3C10002D lui        $s0, 0x2d
00116A20 8FC4000C lw         $a0, 0xc($fp)
00116A24 27C60068 addiu      $a2, $fp, 0x68
00116A28 E7B40154 swc1       $f20, 0x154($sp)
00116A2C E7BA0160 swc1       $f26, 0x160($sp)
00116A30 AFB10168 sw         $s1, 0x168($sp)
00116A34 4480D000 mtc1       $zero, $f26
00116A38 46006506 mov.s      $f20, $f12
00116A3C AFA60148 sw         $a2, 0x148($sp)
00116A40 34110002 ori        $s1, $zero, 2
00116A44 2610DD48 addiu      $s0, $s0, -0x22b8
00116A48 E7B60158 swc1       $f22, 0x158($sp)
00116A4C E7B8015C swc1       $f24, 0x15c($sp)
00116A50 AFB2016C sw         $s2, 0x16c($sp)
00116A54 AFB30170 sw         $s3, 0x170($sp)
00116A58 AFB40174 sw         $s4, 0x174($sp)
00116A5C AFB50178 sw         $s5, 0x178($sp)
00116A60 AFB70180 sw         $s7, 0x180($sp)
00116A64 AFBF0188 sw         $ra, 0x188($sp)
00116A68 10800005 beqz       $a0, 0x116a80
00116A6C AFA50140 sw         $a1, 0x140($sp)
00116A70 8C850040 lw         $a1, 0x40($a0)
00116A74 8CA5001C lw         $a1, 0x1c($a1)
00116A78 00A0F809 jalr       $a1
00116A7C 4600A306 mov.s      $f12, $f20
00116A80 8EC500F0 lw         $a1, 0xf0($s6)
00116A84 0C007DC7 jal        0x1f71c
00116A88 34040002 ori        $a0, $zero, 2
00116A8C 0C016FD5 jal        0x5bf54
00116A90 02C02025 move       $a0, $s6
00116A94 8FC5000C lw         $a1, 0xc($fp)
00116A98 00403825 move       $a3, $v0
00116A9C 34040001 ori        $a0, $zero, 1
00116AA0 54A00001 bnel       $a1, $zero, 0x116aa8
00116AA4 02202025 move       $a0, $s1
00116AA8 AFA40138 sw         $a0, 0x138($sp)
00116AAC A3A70144 sb         $a3, 0x144($sp)
00116AB0 0080B825 move       $s7, $a0
00116AB4 02008825 move       $s1, $s0
00116AB8 8EC500F0 lw         $a1, 0xf0($s6)
00116ABC 0C007FEF jal        0x1ffbc
00116AC0 34040002 ori        $a0, $zero, 2
00116AC4 00022140 sll        $a0, $v0, 5
00116AC8 00022880 sll        $a1, $v0, 2
00116ACC 00852021 addu       $a0, $a0, $a1
00116AD0 34100000 ori        $s0, $zero, 0
00116AD4 00912021 addu       $a0, $a0, $s1
00116AD8 0217302B sltu       $a2, $s0, $s7
00116ADC 10C00026 beqz       $a2, 0x116b78
00116AE0 AFA4013C sw         $a0, 0x13c($sp)
00116AE4 3C14002D lui        $s4, 0x2d
00116AE8 34150001 ori        $s5, $zero, 1
00116AEC 27B30030 addiu      $s3, $sp, 0x30
00116AF0 27B20050 addiu      $s2, $sp, 0x50
00116AF4 27B10070 addiu      $s1, $sp, 0x70
00116AF8 2694DDA4 addiu      $s4, $s4, -0x225c
00116AFC AFB1014C sw         $s1, 0x14c($sp)
00116B00 8FB10140 lw         $s1, 0x140($sp)
00116B04 02602025 move       $a0, $s3
00116B08 02202825 move       $a1, $s1
00116B0C 0C03D550 jal        0xf5540
00116B10 02803025 move       $a2, $s4
00116B14 0C00C4BD jal        0x312f4
00116B18 02C02025 move       $a0, $s6
00116B1C C44C0020 lwc1       $f12, 0x20($v0)
00116B20 E64C0000 swc1       $f12, ($s2)
00116B24 C44C0024 lwc1       $f12, 0x24($v0)
00116B28 02202025 move       $a0, $s1
00116B2C E64C0004 swc1       $f12, 4($s2)
00116B30 C44C0028 lwc1       $f12, 0x28($v0)
00116B34 E64C0008 swc1       $f12, 8($s2)
00116B38 C44C002C lwc1       $f12, 0x2c($v0)
00116B3C E64C000C swc1       $f12, 0xc($s2)
00116B40 16150002 bne        $s0, $s5, 0x116b4c
00116B44 8FB1014C lw         $s1, 0x14c($sp)
00116B48 8FC4000C lw         $a0, 0xc($fp)
00116B4C 00802825 move       $a1, $a0
00116B50 02202025 move       $a0, $s1
00116B54 0C03D550 jal        0xf5540
00116B58 02803025 move       $a2, $s4
00116B5C 8FA40138 lw         $a0, 0x138($sp)
00116B60 26100001 addiu      $s0, $s0, 1
00116B64 26730010 addiu      $s3, $s3, 0x10
00116B68 26520010 addiu      $s2, $s2, 0x10
00116B6C 0204202B sltu       $a0, $s0, $a0
00116B70 1480FFE2 bnez       $a0, 0x116afc
00116B74 26310010 addiu      $s1, $s1, 0x10
00116B78 AFA00090 sw         $zero, 0x90($sp)
00116B7C AFA00094 sw         $zero, 0x94($sp)
00116B80 C6D609DC lwc1       $f22, 0x9dc($s6)
00116B84 3C04002D lui        $a0, 0x2d
00116B88 C48CDEA4 lwc1       $f12, -0x215c($a0)
00116B8C 34140000 ori        $s4, $zero, 0
00116B90 46166582 mul.s      $f22, $f12, $f22
00116B94 8EC600F0 lw         $a2, 0xf0($s6)
00116B98 34100000 ori        $s0, $zero, 0
00116B9C 34040002 ori        $a0, $zero, 2
00116BA0 0C007F68 jal        0x1fda0
00116BA4 34050002 ori        $a1, $zero, 2
00116BA8 8FA6013C lw         $a2, 0x13c($sp)
00116BAC 93A70144 lbu        $a3, 0x144($sp)
00116BB0 34150002 ori        $s5, $zero, 2
00116BB4 27B30030 addiu      $s3, $sp, 0x30
00116BB8 27B10050 addiu      $s1, $sp, 0x50
00116BBC 1040006A beqz       $v0, 0x116d68
00116BC0 3C08002D lui        $t0, 0x2d
00116BC4 8EC4095C lw         $a0, 0x95c($s6)
00116BC8 3C050010 lui        $a1, 0x10
00116BCC 00852024 and        $a0, $a0, $a1
00116BD0 0004202B sltu       $a0, $zero, $a0
00116BD4 308400FF andi       $a0, $a0, 0xff
00116BD8 10800063 beqz       $a0, 0x116d68
00116BDC 00000000 nop        
00116BE0 86C400F8 lh         $a0, 0xf8($s6)
00116BE4 3405001F ori        $a1, $zero, 0x1f
00116BE8 1085005F beq        $a0, $a1, 0x116d68
00116BEC 00000000 nop        
00116BF0 A3B00150 sb         $s0, 0x150($sp)
00116BF4 AFB5014C sw         $s5, 0x14c($sp)
00116BF8 00C0A825 move       $s5, $a2
00116BFC 27B000B8 addiu      $s0, $sp, 0xb8
00116C00 01009025 move       $s2, $t0
00116C04 00E0B825 move       $s7, $a3
00116C08 AFA000B8 sw         $zero, 0xb8($sp)
00116C0C 26040004 addiu      $a0, $s0, 4
00116C10 00002825 move       $a1, $zero
00116C14 0C06B6A7 jal        0x1ada9c
00116C18 3406002C ori        $a2, $zero, 0x2c
00116C1C 0C00C4BD jal        0x312f4
00116C20 02C02025 move       $a0, $s6
00116C24 C64CDEA8 lwc1       $f12, -0x2158($s2)
00116C28 02C02025 move       $a0, $s6
00116C2C 460CB301 sub.s      $f12, $f22, $f12
00116C30 3405000C ori        $a1, $zero, 0xc
00116C34 02003025 move       $a2, $s0
00116C38 02203825 move       $a3, $s1
00116C3C 00404025 move       $t0, $v0
00116C40 02604825 move       $t1, $s3
00116C44 02E05025 move       $t2, $s7
00116C48 0C010CED jal        0x433b4
00116C4C 02A05825 move       $t3, $s5
00116C50 8FA60138 lw         $a2, 0x138($sp)
00116C54 34050000 ori        $a1, $zero, 0
00116C58 8FB5014C lw         $s5, 0x14c($sp)
00116C5C 00402025 move       $a0, $v0
00116C60 00A6302B sltu       $a2, $a1, $a2
00116C64 10C0003E beqz       $a2, 0x116d60
00116C68 93B00150 lbu        $s0, 0x150($sp)
00116C6C 34060001 ori        $a2, $zero, 1
00116C70 2489FFFF addiu      $t1, $a0, -1
00116C74 340D0001 ori        $t5, $zero, 1
00116C78 03C01825 move       $v1, $fp
00116C7C 03A06025 move       $t4, $sp
00116C80 03C53821 addu       $a3, $fp, $a1
00116C84 90E800BA lbu        $t0, 0xba($a3)
00116C88 11000028 beqz       $t0, 0x116d2c
00116C8C 00000000 nop        
00116C90 01205025 move       $t2, $t1
00116C94 05400013 bltz       $t2, 0x116ce4
00116C98 34080000 ori        $t0, $zero, 0
00116C9C 00095880 sll        $t3, $t1, 2
00116CA0 03AB5821 addu       $t3, $sp, $t3
00116CA4 8D6200B8 lw         $v0, 0xb8($t3)
00116CA8 8C6E0010 lw         $t6, 0x10($v1)
00116CAC 144E000A bne        $v0, $t6, 0x116cd8
00116CB0 00000000 nop        
00116CB4 8C4E0040 lw         $t6, 0x40($v0)
00116CB8 91CE004B lbu        $t6, 0x4b($t6)
00116CBC 15C60006 bne        $t6, $a2, 0x116cd8
00116CC0 00000000 nop        
00116CC4 AC620010 sw         $v0, 0x10($v1)
00116CC8 AD820090 sw         $v0, 0x90($t4)
00116CCC 26940001 addiu      $s4, $s4, 1
00116CD0 00C08025 move       $s0, $a2
00116CD4 00C04025 move       $t0, $a2
00116CD8 254AFFFF addiu      $t2, $t2, -1
00116CDC 0541FFF1 bgez       $t2, 0x116ca4
00116CE0 256BFFFC addiu      $t3, $t3, -4
00116CE4 1500000F bnez       $t0, 0x116d24
00116CE8 00000000 nop        
00116CEC AD800090 sw         $zero, 0x90($t4)
00116CF0 8C680010 lw         $t0, 0x10($v1)
00116CF4 8D080064 lw         $t0, 0x64($t0)
00116CF8 310A0001 andi       $t2, $t0, 1
00116CFC 11400007 beqz       $t2, 0x116d1c
00116D00 310A0008 andi       $t2, $t0, 8
00116D04 15400005 bnez       $t2, 0x116d1c
00116D08 310A0006 andi       $t2, $t0, 6
00116D0C 15400003 bnez       $t2, 0x116d1c
00116D10 31080400 andi       $t0, $t0, 0x400
00116D14 11000003 beqz       $t0, 0x116d24
00116D18 00000000 nop        
00116D1C AC600010 sw         $zero, 0x10($v1)
00116D20 A0E000BA sb         $zero, 0xba($a3)
00116D24 10000008 b          0x116d48
00116D28 00000000 nop        
00116D2C 00A4402B sltu       $t0, $a1, $a0
00116D30 11000005 beqz       $t0, 0x116d48
00116D34 00000000 nop        
00116D38 8D8800B8 lw         $t0, 0xb8($t4)
00116D3C AD880090 sw         $t0, 0x90($t4)
00116D40 AC680010 sw         $t0, 0x10($v1)
00116D44 A0ED00BA sb         $t5, 0xba($a3)
00116D48 8FA70138 lw         $a3, 0x138($sp)
00116D4C 24A50001 addiu      $a1, $a1, 1
00116D50 24630004 addiu      $v1, $v1, 4
00116D54 00A7382B sltu       $a3, $a1, $a3
00116D58 14E0FFC9 bnez       $a3, 0x116c80
00116D5C 258C0004 addiu      $t4, $t4, 4
00116D60 1000002D b          0x116e18
00116D64 00000000 nop        
00116D68 A3B00150 sb         $s0, 0x150($sp)
00116D6C AFB5014C sw         $s5, 0x14c($sp)
00116D70 01009025 move       $s2, $t0
00116D74 00E0A825 move       $s5, $a3
00116D78 00C08025 move       $s0, $a2
00116D7C 0C00C4BD jal        0x312f4
00116D80 02C02025 move       $a0, $s6
00116D84 C64CDEA8 lwc1       $f12, -0x2158($s2)
00116D88 02C02025 move       $a0, $s6
00116D8C 460CB301 sub.s      $f12, $f22, $f12
00116D90 02E02825 move       $a1, $s7
00116D94 27A600E8 addiu      $a2, $sp, 0xe8
00116D98 02203825 move       $a3, $s1
00116D9C 00404025 move       $t0, $v0
00116DA0 02604825 move       $t1, $s3
00116DA4 02A05025 move       $t2, $s5
00116DA8 0C010CED jal        0x433b4
00116DAC 02005825 move       $t3, $s0
00116DB0 8FA50138 lw         $a1, 0x138($sp)
00116DB4 34040000 ori        $a0, $zero, 0
00116DB8 8FB5014C lw         $s5, 0x14c($sp)
00116DBC 0040B825 move       $s7, $v0
00116DC0 0085282B sltu       $a1, $a0, $a1
00116DC4 10A00014 beqz       $a1, 0x116e18
00116DC8 93B00150 lbu        $s0, 0x150($sp)
00116DCC 03A02825 move       $a1, $sp
00116DD0 03C03025 move       $a2, $fp
00116DD4 8FA70138 lw         $a3, 0x138($sp)
00116DD8 0097402B sltu       $t0, $a0, $s7
00116DDC 11000005 beqz       $t0, 0x116df4
00116DE0 00000000 nop        
00116DE4 8CA800E8 lw         $t0, 0xe8($a1)
00116DE8 26940001 addiu      $s4, $s4, 1
00116DEC 10000002 b          0x116df8
00116DF0 ACA80090 sw         $t0, 0x90($a1)
00116DF4 ACA00090 sw         $zero, 0x90($a1)
00116DF8 ACC00010 sw         $zero, 0x10($a2)
00116DFC 03C44021 addu       $t0, $fp, $a0
00116E00 A10000BA sb         $zero, 0xba($t0)
00116E04 24840001 addiu      $a0, $a0, 1
00116E08 24A50004 addiu      $a1, $a1, 4
00116E0C 0087402B sltu       $t0, $a0, $a3
00116E10 1500FFF1 bnez       $t0, 0x116dd8
00116E14 24C60004 addiu      $a2, $a2, 4
00116E18 0C00C41E jal        0x31078
00116E1C 02C02025 move       $a0, $s6
00116E20 1040002C beqz       $v0, 0x116ed4
00116E24 00000000 nop        
00116E28 1200002A beqz       $s0, 0x116ed4
00116E2C 00000000 nop        
00116E30 8FA40090 lw         $a0, 0x90($sp)
00116E34 14800004 bnez       $a0, 0x116e48
00116E38 00000000 nop        
00116E3C 8FA40094 lw         $a0, 0x94($sp)
00116E40 10800024 beqz       $a0, 0x116ed4
00116E44 00000000 nop        
00116E48 3C06002D lui        $a2, 0x2d
00116E4C C4CCDE38 lwc1       $f12, -0x21c8($a2)
00116E50 3C063F80 lui        $a2, 0x3f80
00116E54 4486B000 mtc1       $a2, $f22
00116E58 34040064 ori        $a0, $zero, 0x64
00116E5C 34050002 ori        $a1, $zero, 2
00116E60 0C000A17 jal        0x285c
00116E64 4600B346 mov.s      $f13, $f22
00116E68 3C053F91 lui        $a1, 0x3f91
00116E6C 4600B346 mov.s      $f13, $f22
00116E70 34A5EB85 ori        $a1, $a1, 0xeb85
00116E74 44856000 mtc1       $a1, $f12
00116E78 34040064 ori        $a0, $zero, 0x64
00116E7C 0C000A22 jal        0x2888
00116E80 34050002 ori        $a1, $zero, 2
00116E84 8FA40090 lw         $a0, 0x90($sp)
00116E88 1080000A beqz       $a0, 0x116eb4
00116E8C 00000000 nop        
00116E90 0C00039F jal        0xe7c
00116E94 24900030 addiu      $s0, $a0, 0x30
00116E98 46000347 neg.s      $f13, $f0
00116E9C 02002025 move       $a0, $s0
00116EA0 4600B306 mov.s      $f12, $f22
00116EA4 0C000AC6 jal        0x2b18
00116EA8 00002825 move       $a1, $zero
00116EAC 10000009 b          0x116ed4
00116EB0 00000000 nop        
00116EB4 8FA40094 lw         $a0, 0x94($sp)
00116EB8 0C00039F jal        0xe7c
00116EBC 24900030 addiu      $s0, $a0, 0x30
00116EC0 46000347 neg.s      $f13, $f0
00116EC4 02002025 move       $a0, $s0
00116EC8 4600B306 mov.s      $f12, $f22
00116ECC 0C000AC6 jal        0x2b18
00116ED0 00002825 move       $a1, $zero
00116ED4 1280016F beqz       $s4, 0x117494
00116ED8 00000000 nop        
00116EDC 3C043480 lui        $a0, 0x3480
00116EE0 16950038 bne        $s4, $s5, 0x116fc4
00116EE4 4484C000 mtc1       $a0, $f24
00116EE8 8EC50594 lw         $a1, 0x594($s6)
00116EEC 02C02025 move       $a0, $s6
00116EF0 0C00C4BD jal        0x312f4
00116EF4 24B00030 addiu      $s0, $a1, 0x30
00116EF8 C44C0000 lwc1       $f12, ($v0)
00116EFC 3C04002D lui        $a0, 0x2d
00116F00 C48DDE34 lwc1       $f13, -0x21cc($a0)
00116F04 C60E0000 lwc1       $f14, ($s0)
00116F08 460D6302 mul.s      $f12, $f12, $f13
00116F0C 460C7300 add.s      $f12, $f14, $f12
00116F10 E7AC0100 swc1       $f12, 0x100($sp)
00116F14 C44F0004 lwc1       $f15, 4($v0)
00116F18 C6100004 lwc1       $f16, 4($s0)
00116F1C 460D7BC2 mul.s      $f15, $f15, $f13
00116F20 8FA50090 lw         $a1, 0x90($sp)
00116F24 460F83C0 add.s      $f15, $f16, $f15
00116F28 24A60030 addiu      $a2, $a1, 0x30
00116F2C E7AF0104 swc1       $f15, 0x104($sp)
00116F30 C44E0008 lwc1       $f14, 8($v0)
00116F34 C6110008 lwc1       $f17, 8($s0)
00116F38 460D7342 mul.s      $f13, $f14, $f13
00116F3C 8FA40094 lw         $a0, 0x94($sp)
00116F40 24870030 addiu      $a3, $a0, 0x30
00116F44 460D8B40 add.s      $f13, $f17, $f13
00116F48 E7AD0108 swc1       $f13, 0x108($sp)
00116F4C C4D00000 lwc1       $f16, ($a2)
00116F50 C4D20004 lwc1       $f18, 4($a2)
00116F54 460C8401 sub.s      $f16, $f16, $f12
00116F58 C4CE0008 lwc1       $f14, 8($a2)
00116F5C 460F9481 sub.s      $f18, $f18, $f15
00116F60 C4F10000 lwc1       $f17, ($a3)
00116F64 C4F30004 lwc1       $f19, 4($a3)
00116F68 460D7381 sub.s      $f14, $f14, $f13
00116F6C C4E00008 lwc1       $f0, 8($a3)
00116F70 460C8B01 sub.s      $f12, $f17, $f12
00116F74 460F9BC1 sub.s      $f15, $f19, $f15
00116F78 46108402 mul.s      $f16, $f16, $f16
00116F7C 46129482 mul.s      $f18, $f18, $f18
00116F80 460C6302 mul.s      $f12, $f12, $f12
00116F84 460F7BC2 mul.s      $f15, $f15, $f15
00116F88 460D0341 sub.s      $f13, $f0, $f13
00116F8C 460E7382 mul.s      $f14, $f14, $f14
00116F90 46128400 add.s      $f16, $f16, $f18
00116F94 460F6300 add.s      $f12, $f12, $f15
00116F98 460D6B42 mul.s      $f13, $f13, $f13
00116F9C 460E8380 add.s      $f14, $f16, $f14
00116FA0 460D6300 add.s      $f12, $f12, $f13
00116FA4 460C703C c.lt.s     $f14, $f12
00116FA8 00000000 nop        
00116FAC 45000003 bc1f       0x116fbc
00116FB0 00000000 nop        
00116FB4 AFA50094 sw         $a1, 0x94($sp)
00116FB8 AFA40090 sw         $a0, 0x90($sp)
00116FBC 10000008 b          0x116fe0
00116FC0 00000000 nop        
00116FC4 8FA40094 lw         $a0, 0x94($sp)
00116FC8 10800005 beqz       $a0, 0x116fe0
00116FCC 00000000 nop        
00116FD0 8FA50090 lw         $a1, 0x90($sp)
00116FD4 14A00002 bnez       $a1, 0x116fe0
00116FD8 00000000 nop        
00116FDC AFA40090 sw         $a0, 0x90($sp)
00116FE0 34120000 ori        $s2, $zero, 0
00116FE4 0254202B sltu       $a0, $s2, $s4
00116FE8 1080001D beqz       $a0, 0x117060
00116FEC 27B3010C addiu      $s3, $sp, 0x10c
00116FF0 03A08025 move       $s0, $sp
00116FF4 27D10018 addiu      $s1, $fp, 0x18
00116FF8 8E040090 lw         $a0, 0x90($s0)
00116FFC 10800013 beqz       $a0, 0x11704c
00117000 00000000 nop        
00117004 0C00C41E jal        0x31078
00117008 02C02025 move       $a0, $s6
0011700C 1040000F beqz       $v0, 0x11704c
00117010 00000000 nop        
00117014 8E040090 lw         $a0, 0x90($s0)
00117018 02602825 move       $a1, $s3
0011701C 34060001 ori        $a2, $zero, 1
00117020 0C01B0C6 jal        0x6c318
00117024 00003825 move       $a3, $zero
00117028 8E060090 lw         $a2, 0x90($s0)
0011702C 02202025 move       $a0, $s1
00117030 34050001 ori        $a1, $zero, 1
00117034 0C0199E7 jal        0x6679c
00117038 34070001 ori        $a3, $zero, 1
0011703C 02202025 move       $a0, $s1
00117040 02602825 move       $a1, $s3
00117044 0C019A07 jal        0x6681c
00117048 00003025 move       $a2, $zero
0011704C 26520001 addiu      $s2, $s2, 1
00117050 26100004 addiu      $s0, $s0, 4
00117054 0254202B sltu       $a0, $s2, $s4
00117058 1480FFE7 bnez       $a0, 0x116ff8
0011705C 26310028 addiu      $s1, $s1, 0x28
00117060 0C016FE3 jal        0x5bf8c
00117064 02C02025 move       $a0, $s6
00117068 34150000 ori        $s5, $zero, 0
0011706C 02B4202B sltu       $a0, $s5, $s4
00117070 1080009B beqz       $a0, 0x1172e0
00117074 3C043F80 lui        $a0, 0x3f80
00117078 27B70118 addiu      $s7, $sp, 0x118
0011707C 4484B000 mtc1       $a0, $f22
00117080 03A08825 move       $s1, $sp
00117084 27B20050 addiu      $s2, $sp, 0x50
00117088 27B30070 addiu      $s3, $sp, 0x70
0011708C 27B00098 addiu      $s0, $sp, 0x98
00117090 8E240090 lw         $a0, 0x90($s1)
00117094 02E02825 move       $a1, $s7
00117098 00003025 move       $a2, $zero
0011709C 0C01B0B8 jal        0x6c2e0
001170A0 00003825 move       $a3, $zero
001170A4 C66C0000 lwc1       $f12, ($s3)
001170A8 C7AD0118 lwc1       $f13, 0x118($sp)
001170AC 460C6B01 sub.s      $f12, $f13, $f12
001170B0 02402025 move       $a0, $s2
001170B4 E64C0000 swc1       $f12, ($s2)
001170B8 C7AC011C lwc1       $f12, 0x11c($sp)
001170BC C66E0004 lwc1       $f14, 4($s3)
001170C0 460E6301 sub.s      $f12, $f12, $f14
001170C4 E64C0004 swc1       $f12, 4($s2)
001170C8 C7AC0120 lwc1       $f12, 0x120($sp)
001170CC C66F0008 lwc1       $f15, 8($s3)
001170D0 460F6301 sub.s      $f12, $f12, $f15
001170D4 E64C0008 swc1       $f12, 8($s2)
001170D8 C48C0000 lwc1       $f12, ($a0)
001170DC C48D0004 lwc1       $f13, 4($a0)
001170E0 460C6302 mul.s      $f12, $f12, $f12
001170E4 C48E0008 lwc1       $f14, 8($a0)
001170E8 460D6B42 mul.s      $f13, $f13, $f13
001170EC 460E7382 mul.s      $f14, $f14, $f14
001170F0 460D6300 add.s      $f12, $f12, $f13
001170F4 460E6300 add.s      $f12, $f12, $f14
001170F8 4618603C c.lt.s     $f12, $f24
001170FC 00000000 nop        
00117100 45000005 bc1f       0x117118
00117104 00000000 nop        
00117108 8E240090 lw         $a0, 0x90($s1)
0011710C C6CC0030 lwc1       $f12, 0x30($s6)
00117110 1000000F b          0x117150
00117114 24840030 addiu      $a0, $a0, 0x30
00117118 46006304 sqrt.s     $f12, $f12
0011711C 460CB303 div.s      $f12, $f22, $f12
00117120 C48D0000 lwc1       $f13, ($a0)
00117124 C48E0004 lwc1       $f14, 4($a0)
00117128 C48F0008 lwc1       $f15, 8($a0)
0011712C 460C6B42 mul.s      $f13, $f13, $f12
00117130 460C7382 mul.s      $f14, $f14, $f12
00117134 E48D0000 swc1       $f13, ($a0)
00117138 460C7B02 mul.s      $f12, $f15, $f12
0011713C E48E0004 swc1       $f14, 4($a0)
00117140 E48C0008 swc1       $f12, 8($a0)
00117144 8E240090 lw         $a0, 0x90($s1)
00117148 C6CC0030 lwc1       $f12, 0x30($s6)
0011714C 24840030 addiu      $a0, $a0, 0x30
00117150 C48D0000 lwc1       $f13, ($a0)
00117154 460C6B01 sub.s      $f12, $f13, $f12
00117158 E60C0000 swc1       $f12, ($s0)
0011715C C48C0004 lwc1       $f12, 4($a0)
00117160 C6CE0034 lwc1       $f14, 0x34($s6)
00117164 460E6301 sub.s      $f12, $f12, $f14
00117168 E60C0004 swc1       $f12, 4($s0)
0011716C C48C0008 lwc1       $f12, 8($a0)
00117170 C6CF0038 lwc1       $f15, 0x38($s6)
00117174 02002025 move       $a0, $s0
00117178 460F6301 sub.s      $f12, $f12, $f15
0011717C E60C0008 swc1       $f12, 8($s0)
00117180 C48C0000 lwc1       $f12, ($a0)
00117184 C48D0004 lwc1       $f13, 4($a0)
00117188 460C6302 mul.s      $f12, $f12, $f12
0011718C C48E0008 lwc1       $f14, 8($a0)
00117190 460D6B42 mul.s      $f13, $f13, $f13
00117194 460E7382 mul.s      $f14, $f14, $f14
00117198 460D6300 add.s      $f12, $f12, $f13
0011719C 460E6300 add.s      $f12, $f12, $f14
001171A0 4618603C c.lt.s     $f12, $f24
001171A4 00000000 nop        
001171A8 45000005 bc1f       0x1171c0
001171AC 00000000 nop        
001171B0 C6CC0010 lwc1       $f12, 0x10($s6)
001171B4 C6CD0014 lwc1       $f13, 0x14($s6)
001171B8 1000000F b          0x1171f8
001171BC C6CE0018 lwc1       $f14, 0x18($s6)
001171C0 46006304 sqrt.s     $f12, $f12
001171C4 460CB303 div.s      $f12, $f22, $f12
001171C8 C48D0000 lwc1       $f13, ($a0)
001171CC C48E0004 lwc1       $f14, 4($a0)
001171D0 C48F0008 lwc1       $f15, 8($a0)
001171D4 460C6B42 mul.s      $f13, $f13, $f12
001171D8 460C7382 mul.s      $f14, $f14, $f12
001171DC E48D0000 swc1       $f13, ($a0)
001171E0 460C7B02 mul.s      $f12, $f15, $f12
001171E4 E48E0004 swc1       $f14, 4($a0)
001171E8 E48C0008 swc1       $f12, 8($a0)
001171EC C6CC0010 lwc1       $f12, 0x10($s6)
001171F0 C6CD0014 lwc1       $f13, 0x14($s6)
001171F4 C6CE0018 lwc1       $f14, 0x18($s6)
001171F8 C60F0000 lwc1       $f15, ($s0)
001171FC C6100004 lwc1       $f16, 4($s0)
00117200 460C7BC2 mul.s      $f15, $f15, $f12
00117204 C6110008 lwc1       $f17, 8($s0)
00117208 460D8342 mul.s      $f13, $f16, $f13
0011720C 460E8B82 mul.s      $f14, $f17, $f14
00117210 460D7B40 add.s      $f13, $f15, $f13
00117214 460E6B40 add.s      $f13, $f13, $f14
00117218 460C6B02 mul.s      $f12, $f13, $f12
0011721C E7AC0128 swc1       $f12, 0x128($sp)
00117220 C6D20014 lwc1       $f18, 0x14($s6)
00117224 46126C82 mul.s      $f18, $f13, $f18
00117228 E7B2012C swc1       $f18, 0x12c($sp)
0011722C C6D00018 lwc1       $f16, 0x18($s6)
00117230 46106B42 mul.s      $f13, $f13, $f16
00117234 02002025 move       $a0, $s0
00117238 E7AD0130 swc1       $f13, 0x130($sp)
0011723C C60D0000 lwc1       $f13, ($s0)
00117240 C60E0004 lwc1       $f14, 4($s0)
00117244 460C6B01 sub.s      $f12, $f13, $f12
00117248 C60F0008 lwc1       $f15, 8($s0)
0011724C E60C0000 swc1       $f12, ($s0)
00117250 C7AC012C lwc1       $f12, 0x12c($sp)
00117254 460C7301 sub.s      $f12, $f14, $f12
00117258 E60C0004 swc1       $f12, 4($s0)
0011725C C7AC0130 lwc1       $f12, 0x130($sp)
00117260 460C7B01 sub.s      $f12, $f15, $f12
00117264 E60C0008 swc1       $f12, 8($s0)
00117268 C48C0000 lwc1       $f12, ($a0)
0011726C C48D0004 lwc1       $f13, 4($a0)
00117270 460C6302 mul.s      $f12, $f12, $f12
00117274 C48E0008 lwc1       $f14, 8($a0)
00117278 460D6B42 mul.s      $f13, $f13, $f13
0011727C 460E7382 mul.s      $f14, $f14, $f14
00117280 460D6300 add.s      $f12, $f12, $f13
00117284 460E6300 add.s      $f12, $f12, $f14
00117288 4618603C c.lt.s     $f12, $f24
0011728C 00000000 nop        
00117290 4501000C bc1t       0x1172c4
00117294 00000000 nop        
00117298 46006304 sqrt.s     $f12, $f12
0011729C 460CB303 div.s      $f12, $f22, $f12
001172A0 C48D0000 lwc1       $f13, ($a0)
001172A4 C48E0004 lwc1       $f14, 4($a0)
001172A8 C48F0008 lwc1       $f15, 8($a0)
001172AC 460C6B42 mul.s      $f13, $f13, $f12
001172B0 460C7382 mul.s      $f14, $f14, $f12
001172B4 E48D0000 swc1       $f13, ($a0)
001172B8 460C7B02 mul.s      $f12, $f15, $f12
001172BC E48E0004 swc1       $f14, 4($a0)
001172C0 E48C0008 swc1       $f12, 8($a0)
001172C4 26B50001 addiu      $s5, $s5, 1
001172C8 26310004 addiu      $s1, $s1, 4
001172CC 26520010 addiu      $s2, $s2, 0x10
001172D0 26730010 addiu      $s3, $s3, 0x10
001172D4 02B4202B sltu       $a0, $s5, $s4
001172D8 1480FF6D bnez       $a0, 0x117090
001172DC 2610000C addiu      $s0, $s0, 0xc
001172E0 8FA50138 lw         $a1, 0x138($sp)
001172E4 8FA40090 lw         $a0, 0x90($sp)
001172E8 34150002 ori        $s5, $zero, 2
001172EC 14B5003C bne        $a1, $s5, 0x1173e0
001172F0 27B30030 addiu      $s3, $sp, 0x30
001172F4 5695001D bnel       $s4, $s5, 0x11736c
001172F8 C7AC0050 lwc1       $f12, 0x50($sp)
001172FC 8FA50094 lw         $a1, 0x94($sp)
00117300 C48C0030 lwc1       $f12, 0x30($a0)
00117304 C4AD0030 lwc1       $f13, 0x30($a1)
00117308 3C063F00 lui        $a2, 0x3f00
0011730C 460D6300 add.s      $f12, $f12, $f13
00117310 44867000 mtc1       $a2, $f14
00117314 460E6302 mul.s      $f12, $f12, $f14
00117318 3C063F80 lui        $a2, 0x3f80
0011731C E7AC00F0 swc1       $f12, 0xf0($sp)
00117320 C48C0034 lwc1       $f12, 0x34($a0)
00117324 C4AF0034 lwc1       $f15, 0x34($a1)
00117328 460F6300 add.s      $f12, $f12, $f15
0011732C 3C070002 lui        $a3, 2
00117330 44866800 mtc1       $a2, $f13
00117334 460E6302 mul.s      $f12, $f12, $f14
00117338 E7AC00F4 swc1       $f12, 0xf4($sp)
0011733C C48C0038 lwc1       $f12, 0x38($a0)
00117340 C4B00038 lwc1       $f16, 0x38($a1)
00117344 46106300 add.s      $f12, $f12, $f16
00117348 E7AD00FC swc1       $f13, 0xfc($sp)
0011734C 460E6302 mul.s      $f12, $f12, $f14
00117350 E7AC00F8 swc1       $f12, 0xf8($sp)
00117354 C6CC0030 lwc1       $f12, 0x30($s6)
00117358 C6CD0034 lwc1       $f13, 0x34($s6)
0011735C 8EC4095C lw         $a0, 0x95c($s6)
00117360 C6CE0038 lwc1       $f14, 0x38($s6)
00117364 1000002D b          0x11741c
00117368 00872025 or         $a0, $a0, $a3
0011736C C7AD0054 lwc1       $f13, 0x54($sp)
00117370 E7AC0060 swc1       $f12, 0x60($sp)
00117374 C7AC0058 lwc1       $f12, 0x58($sp)
00117378 E7AD0064 swc1       $f13, 0x64($sp)
0011737C C7AD005C lwc1       $f13, 0x5c($sp)
00117380 E7AC0068 swc1       $f12, 0x68($sp)
00117384 C7AC0098 lwc1       $f12, 0x98($sp)
00117388 E7AD006C swc1       $f13, 0x6c($sp)
0011738C C7AD009C lwc1       $f13, 0x9c($sp)
00117390 E7AC00A4 swc1       $f12, 0xa4($sp)
00117394 C7AC00A0 lwc1       $f12, 0xa0($sp)
00117398 E7AD00A8 swc1       $f13, 0xa8($sp)
0011739C E7AC00AC swc1       $f12, 0xac($sp)
001173A0 24840030 addiu      $a0, $a0, 0x30
001173A4 C48C0000 lwc1       $f12, ($a0)
001173A8 E7AC00F0 swc1       $f12, 0xf0($sp)
001173AC C48C0004 lwc1       $f12, 4($a0)
001173B0 E7AC00F4 swc1       $f12, 0xf4($sp)
001173B4 C48C0008 lwc1       $f12, 8($a0)
001173B8 E7AC00F8 swc1       $f12, 0xf8($sp)
001173BC C48C000C lwc1       $f12, 0xc($a0)
001173C0 3C040002 lui        $a0, 2
001173C4 E7AC00FC swc1       $f12, 0xfc($sp)
001173C8 C6CC0030 lwc1       $f12, 0x30($s6)
001173CC C6CD0034 lwc1       $f13, 0x34($s6)
001173D0 8EC5095C lw         $a1, 0x95c($s6)
001173D4 C6CE0038 lwc1       $f14, 0x38($s6)
001173D8 10000010 b          0x11741c
001173DC 00A42025 or         $a0, $a1, $a0
001173E0 24840030 addiu      $a0, $a0, 0x30
001173E4 C48C0000 lwc1       $f12, ($a0)
001173E8 E7AC00F0 swc1       $f12, 0xf0($sp)
001173EC C48C0004 lwc1       $f12, 4($a0)
001173F0 E7AC00F4 swc1       $f12, 0xf4($sp)
001173F4 C48C0008 lwc1       $f12, 8($a0)
001173F8 E7AC00F8 swc1       $f12, 0xf8($sp)
001173FC C48C000C lwc1       $f12, 0xc($a0)
00117400 3C040002 lui        $a0, 2
00117404 E7AC00FC swc1       $f12, 0xfc($sp)
00117408 C6CC0030 lwc1       $f12, 0x30($s6)
0011740C C6CD0034 lwc1       $f13, 0x34($s6)
00117410 8EC5095C lw         $a1, 0x95c($s6)
00117414 C6CE0038 lwc1       $f14, 0x38($s6)
00117418 00A42025 or         $a0, $a1, $a0
0011741C AEC4095C sw         $a0, 0x95c($s6)
00117420 C7AF00F0 lwc1       $f15, 0xf0($sp)
00117424 460C7B01 sub.s      $f12, $f15, $f12
00117428 E6CC02A8 swc1       $f12, 0x2a8($s6)
0011742C C7B000F4 lwc1       $f16, 0xf4($sp)
00117430 460C6442 mul.s      $f17, $f12, $f12
00117434 460D8341 sub.s      $f13, $f16, $f13
00117438 E6CD02AC swc1       $f13, 0x2ac($s6)
0011743C C7B200F8 lwc1       $f18, 0xf8($sp)
00117440 4600D346 mov.s      $f13, $f26
00117444 460D6CC2 mul.s      $f19, $f13, $f13
00117448 460E9381 sub.s      $f14, $f18, $f14
0011744C E6DA02AC swc1       $f26, 0x2ac($s6)
00117450 46138BC0 add.s      $f15, $f17, $f19
00117454 460E7402 mul.s      $f16, $f14, $f14
00117458 46107BC0 add.s      $f15, $f15, $f16
0011745C 4618783C c.lt.s     $f15, $f24
00117460 00000000 nop        
00117464 4501000B bc1t       0x117494
00117468 E6CE02B0 swc1       $f14, 0x2b0($s6)
0011746C 3C043F80 lui        $a0, 0x3f80
00117470 46007BC4 sqrt.s     $f15, $f15
00117474 44848000 mtc1       $a0, $f16
00117478 460F83C3 div.s      $f15, $f16, $f15
0011747C 460F6302 mul.s      $f12, $f12, $f15
00117480 460F6B42 mul.s      $f13, $f13, $f15
00117484 460F7382 mul.s      $f14, $f14, $f15
00117488 E6CC02A8 swc1       $f12, 0x2a8($s6)
0011748C E6CD02AC swc1       $f13, 0x2ac($s6)
00117490 E6CE02B0 swc1       $f14, 0x2b0($s6)
00117494 8FA40138 lw         $a0, 0x138($sp)
00117498 14950010 bne        $a0, $s5, 0x1174dc
0011749C C7AC0098 lwc1       $f12, 0x98($sp)
001174A0 E6CC02B8 swc1       $f12, 0x2b8($s6)
001174A4 C7AC009C lwc1       $f12, 0x9c($sp)
001174A8 E6CC02BC swc1       $f12, 0x2bc($s6)
001174AC C7AC00A0 lwc1       $f12, 0xa0($sp)
001174B0 E6CC02C0 swc1       $f12, 0x2c0($s6)
001174B4 C7AC00A4 lwc1       $f12, 0xa4($sp)
001174B8 E6CC02C4 swc1       $f12, 0x2c4($s6)
001174BC C7AC00A8 lwc1       $f12, 0xa8($sp)
001174C0 E6CC02C8 swc1       $f12, 0x2c8($s6)
001174C4 C7AC00AC lwc1       $f12, 0xac($sp)
001174C8 E6CC02CC swc1       $f12, 0x2cc($s6)
001174CC C7CC0004 lwc1       $f12, 4($fp)
001174D0 C7CD00B4 lwc1       $f13, 0xb4($fp)
001174D4 10000011 b          0x11751c
001174D8 46146301 sub.s      $f12, $f12, $f20
001174DC E6CC02B8 swc1       $f12, 0x2b8($s6)
001174E0 C7AC009C lwc1       $f12, 0x9c($sp)
001174E4 02C02025 move       $a0, $s6
001174E8 E6CC02BC swc1       $f12, 0x2bc($s6)
001174EC C7AC00A0 lwc1       $f12, 0xa0($sp)
001174F0 0C00C4BD jal        0x312f4
001174F4 E6CC02C0 swc1       $f12, 0x2c0($s6)
001174F8 C44C0020 lwc1       $f12, 0x20($v0)
001174FC E6CC02C4 swc1       $f12, 0x2c4($s6)
00117500 C44C0024 lwc1       $f12, 0x24($v0)
00117504 E6CC02C8 swc1       $f12, 0x2c8($s6)
00117508 C44C0028 lwc1       $f12, 0x28($v0)
0011750C E6CC02CC swc1       $f12, 0x2cc($s6)
00117510 C7CC0004 lwc1       $f12, 4($fp)
00117514 C7CD00B4 lwc1       $f13, 0xb4($fp)
00117518 46146301 sub.s      $f12, $f12, $f20
0011751C E7CC0004 swc1       $f12, 4($fp)
00117520 461A603C c.lt.s     $f12, $f26
00117524 00000000 nop        
00117528 45000002 bc1f       0x117534
0011752C 8FB10138 lw         $s1, 0x138($sp)
00117530 E7DA0004 swc1       $f26, 4($fp)
00117534 461A6832 c.eq.s     $f13, $f26
00117538 00000000 nop        
0011753C 4501001E bc1t       0x1175b8
00117540 00000000 nop        
00117544 46146B40 add.s      $f13, $f13, $f20
00117548 3C04002D lui        $a0, 0x2d
0011754C E7CD00B4 swc1       $f13, 0xb4($fp)
00117550 C48CDD9C lwc1       $f12, -0x2264($a0)
00117554 460C683C c.lt.s     $f13, $f12
00117558 00000000 nop        
0011755C 45000016 bc1f       0x1175b8
00117560 3C04002D lui        $a0, 0x2d
00117564 C48CDDA0 lwc1       $f12, -0x2260($a0)
00117568 460C683E c.le.s     $f13, $f12
0011756C 00000000 nop        
00117570 45010011 bc1t       0x1175b8
00117574 00000000 nop        
00117578 0C007956 jal        0x1e558
0011757C 02C02025 move       $a0, $s6
00117580 1040000D beqz       $v0, 0x1175b8
00117584 00000000 nop        
00117588 1635000B bne        $s1, $s5, 0x1175b8
0011758C 00000000 nop        
00117590 93C400B8 lbu        $a0, 0xb8($fp)
00117594 10800008 beqz       $a0, 0x1175b8
00117598 00000000 nop        
0011759C 26C400C0 addiu      $a0, $s6, 0xc0
001175A0 8C840014 lw         $a0, 0x14($a0)
001175A4 30842000 andi       $a0, $a0, 0x2000
001175A8 10800003 beqz       $a0, 0x1175b8
001175AC 00000000 nop        
001175B0 34040001 ori        $a0, $zero, 1
001175B4 A3C400B9 sb         $a0, 0xb9($fp)
001175B8 8FC40000 lw         $a0, ($fp)
001175BC 3405000C ori        $a1, $zero, 0xc
001175C0 8C8409BC lw         $a0, 0x9bc($a0)
001175C4 10850013 beq        $a0, $a1, 0x117614
001175C8 00000000 nop        
001175CC 8FB20140 lw         $s2, 0x140($sp)
001175D0 34040002 ori        $a0, $zero, 2
001175D4 8E450058 lw         $a1, 0x58($s2)
001175D8 8CA60000 lw         $a2, ($a1)
001175DC 34050001 ori        $a1, $zero, 1
001175E0 0C007F68 jal        0x1fda0
001175E4 8CC600F0 lw         $a2, 0xf0($a2)
001175E8 10400003 beqz       $v0, 0x1175f8
001175EC 3C04002D lui        $a0, 0x2d
001175F0 10000002 b          0x1175fc
001175F4 C48CDDD0 lwc1       $f12, -0x2230($a0)
001175F8 4600D306 mov.s      $f12, $f26
001175FC 27C5008C addiu      $a1, $fp, 0x8c
00117600 0C03F51D jal        0xfd474
00117604 02402025 move       $a0, $s2
00117608 8FA50148 lw         $a1, 0x148($sp)
0011760C 0C03F681 jal        0xfda04
00117610 02402025 move       $a0, $s2
00117614 8FC40008 lw         $a0, 8($fp)
00117618 34050003 ori        $a1, $zero, 3
0011761C 14850037 bne        $a0, $a1, 0x1176fc
00117620 8FB20140 lw         $s2, 0x140($sp)
00117624 02402025 move       $a0, $s2
00117628 0C01AA82 jal        0x6aa08
0011762C 00002825 move       $a1, $zero
00117630 1440000B bnez       $v0, 0x117660
00117634 00000000 nop        
00117638 C7CC00B4 lwc1       $f12, 0xb4($fp)
0011763C 3C04002D lui        $a0, 0x2d
00117640 C48DDD9C lwc1       $f13, -0x2264($a0)
00117644 460D603E c.le.s     $f12, $f13
00117648 00000000 nop        
0011764C 4501002B bc1t       0x1176fc
00117650 00000000 nop        
00117654 93C400B9 lbu        $a0, 0xb9($fp)
00117658 14800028 bnez       $a0, 0x1176fc
0011765C 00000000 nop        
00117660 3C083DCC lui        $t0, 0x3dcc
00117664 4600D346 mov.s      $f13, $f26
00117668 A2400045 sb         $zero, 0x45($s2)
0011766C 3508CCCD ori        $t0, $t0, 0xcccd
00117670 AFC00008 sw         $zero, 8($fp)
00117674 44886000 mtc1       $t0, $f12
00117678 02402025 move       $a0, $s2
0011767C 00002825 move       $a1, $zero
00117680 00003025 move       $a2, $zero
00117684 0C01AB54 jal        0x6ad50
00117688 34070001 ori        $a3, $zero, 1
0011768C 12400008 beqz       $s2, 0x1176b0
00117690 00000000 nop        
00117694 92440045 lbu        $a0, 0x45($s2)
00117698 28850004 slti       $a1, $a0, 4
0011769C 14A00004 bnez       $a1, 0x1176b0
001176A0 288400FE slti       $a0, $a0, 0xfe
001176A4 10800002 beqz       $a0, 0x1176b0
001176A8 00000000 nop        
001176AC A2400045 sb         $zero, 0x45($s2)
001176B0 86C400F8 lh         $a0, 0xf8($s6)
001176B4 34050045 ori        $a1, $zero, 0x45
001176B8 1485000E bne        $a0, $a1, 0x1176f4
001176BC 00000000 nop        
001176C0 A6C000FA sh         $zero, 0xfa($s6)
001176C4 4600D346 mov.s      $f13, $f26
001176C8 3404005B ori        $a0, $zero, 0x5b
001176CC 8EC60594 lw         $a2, 0x594($s6)
001176D0 AEC40360 sw         $a0, 0x360($s6)
001176D4 3C083E4C lui        $t0, 0x3e4c
001176D8 00C02025 move       $a0, $a2
001176DC 3508CCCD ori        $t0, $t0, 0xcccd
001176E0 3405005B ori        $a1, $zero, 0x5b
001176E4 44886000 mtc1       $t0, $f12
001176E8 00003025 move       $a2, $zero
001176EC 0C01AB54 jal        0x6ad50
001176F0 34070001 ori        $a3, $zero, 1
001176F4 E7DA00B4 swc1       $f26, 0xb4($fp)
001176F8 A3C000B9 sb         $zero, 0xb9($fp)
001176FC 27A400B0 addiu      $a0, $sp, 0xb0
00117700 0C00C4D4 jal        0x31350
00117704 02C02825 move       $a1, $s6
00117708 8EC40594 lw         $a0, 0x594($s6)
0011770C 0C01AA78 jal        0x6a9e0
00117710 2410FFFF addiu      $s0, $zero, -1
00117714 0C00C41E jal        0x31078
00117718 02C02025 move       $a0, $s6
0011771C 10400036 beqz       $v0, 0x1177f8
00117720 00000000 nop        
00117724 C7CC0004 lwc1       $f12, 4($fp)
00117728 461A6032 c.eq.s     $f12, $f26
0011772C 00000000 nop        
00117730 45000025 bc1f       0x1177c8
00117734 00000000 nop        
00117738 0C007956 jal        0x1e558
0011773C 02C02025 move       $a0, $s6
00117740 10400021 beqz       $v0, 0x1177c8
00117744 00000000 nop        
00117748 8FA400B0 lw         $a0, 0xb0($sp)
0011774C 30840020 andi       $a0, $a0, 0x20
00117750 1080001D beqz       $a0, 0x1177c8
00117754 00000000 nop        
00117758 92440045 lbu        $a0, 0x45($s2)
0011775C 10800003 beqz       $a0, 0x11776c
00117760 34050004 ori        $a1, $zero, 4
00117764 14850018 bne        $a0, $a1, 0x1177c8
00117768 00000000 nop        
0011776C 26C400C0 addiu      $a0, $s6, 0xc0
00117770 8C840014 lw         $a0, 0x14($a0)
00117774 30842000 andi       $a0, $a0, 0x2000
00117778 10800011 beqz       $a0, 0x1177c0
0011777C 00000000 nop        
00117780 34040001 ori        $a0, $zero, 1
00117784 34100000 ori        $s0, $zero, 0
00117788 16350004 bne        $s1, $s5, 0x11779c
0011778C A3C400B8 sb         $a0, 0xb8($fp)
00117790 34040006 ori        $a0, $zero, 6
00117794 1000000A b          0x1177c0
00117798 A2440045 sb         $a0, 0x45($s2)
0011779C 86C400F8 lh         $a0, 0xf8($s6)
001177A0 34050005 ori        $a1, $zero, 5
001177A4 14850004 bne        $a0, $a1, 0x1177b8
001177A8 00000000 nop        
001177AC 3C04002D lui        $a0, 0x2d
001177B0 C48CDE3C lwc1       $f12, -0x21c4($a0)
001177B4 E7CC00BC swc1       $f12, 0xbc($fp)
001177B8 34040004 ori        $a0, $zero, 4
001177BC A2440045 sb         $a0, 0x45($s2)
001177C0 1000000D b          0x1177f8
001177C4 00000000 nop        
001177C8 C7CC00B4 lwc1       $f12, 0xb4($fp)
001177CC 3C04002D lui        $a0, 0x2d
001177D0 C48DDD98 lwc1       $f13, -0x2268($a0)
001177D4 460D603E c.le.s     $f12, $f13
001177D8 00000000 nop        
001177DC 45010006 bc1t       0x1177f8
001177E0 00000000 nop        
001177E4 93C400B9 lbu        $a0, 0xb9($fp)
001177E8 10800003 beqz       $a0, 0x1177f8
001177EC 00000000 nop        
001177F0 34100001 ori        $s0, $zero, 1
001177F4 A3C000B8 sb         $zero, 0xb8($fp)
001177F8 C7CC00BC lwc1       $f12, 0xbc($fp)
001177FC 461A6032 c.eq.s     $f12, $f26
00117800 00000000 nop        
00117804 4501000C bc1t       0x117838
00117808 00000000 nop        
0011780C 3C04BF80 lui        $a0, 0xbf80
00117810 44846800 mtc1       $a0, $f13
00117814 460D6300 add.s      $f12, $f12, $f13
00117818 461A603E c.le.s     $f12, $f26
0011781C 00000000 nop        
00117820 45000004 bc1f       0x117834
00117824 E7CC00BC swc1       $f12, 0xbc($fp)
00117828 E7DA00BC swc1       $f26, 0xbc($fp)
0011782C 10000002 b          0x117838
00117830 34100000 ori        $s0, $zero, 0
00117834 2410FFFF addiu      $s0, $zero, -1
00117838 2404FFFF addiu      $a0, $zero, -1
0011783C 12040011 beq        $s0, $a0, 0x117884
00117840 00000000 nop        
00117844 0C00C41E jal        0x31078
00117848 02C02025 move       $a0, $s6
0011784C 1040000D beqz       $v0, 0x117884
00117850 00000000 nop        
00117854 AFA00134 sw         $zero, 0x134($sp)
00117858 27A60134 addiu      $a2, $sp, 0x134
0011785C 02402025 move       $a0, $s2
00117860 02602825 move       $a1, $s3
00117864 0C04599B jal        0x11666c
00117868 02003825 move       $a3, $s0
0011786C 8FA80134 lw         $t0, 0x134($sp)
00117870 27A60050 addiu      $a2, $sp, 0x50
00117874 02402025 move       $a0, $s2
00117878 02602825 move       $a1, $s3
0011787C 0C04594D jal        0x116534
00117880 02003825 move       $a3, $s0
00117884 0C03F4C7 jal        0xfd31c
00117888 8FA40148 lw         $a0, 0x148($sp)
0011788C C7B40154 lwc1       $f20, 0x154($sp)
00117890 C7B60158 lwc1       $f22, 0x158($sp)
00117894 C7B8015C lwc1       $f24, 0x15c($sp)
00117898 C7BA0160 lwc1       $f26, 0x160($sp)
0011789C 8FB00164 lw         $s0, 0x164($sp)
001178A0 8FB10168 lw         $s1, 0x168($sp)
001178A4 8FB2016C lw         $s2, 0x16c($sp)
001178A8 8FB30170 lw         $s3, 0x170($sp)
001178AC 8FB40174 lw         $s4, 0x174($sp)
001178B0 8FB50178 lw         $s5, 0x178($sp)
001178B4 8FB6017C lw         $s6, 0x17c($sp)
001178B8 8FB70180 lw         $s7, 0x180($sp)
001178BC 8FBE0184 lw         $fp, 0x184($sp)
001178C0 8FBF0188 lw         $ra, 0x188($sp)
001178C4 03E00008 jr         $ra
001178C8 27BD0190 addiu      $sp, $sp, 0x190