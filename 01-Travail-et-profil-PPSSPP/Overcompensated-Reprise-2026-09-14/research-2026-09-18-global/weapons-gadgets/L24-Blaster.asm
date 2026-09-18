
CALLBACK 0x0010D20C end 0x0010D368 ordinal 0

0010D20C 27BDFFC0 addiu      $sp, $sp, -0x40
0010D210 AFB2002C sw         $s2, 0x2c($sp)
0010D214 00809025 move       $s2, $a0
0010D218 AFB10028 sw         $s1, 0x28($sp)
0010D21C 8E510058 lw         $s1, 0x58($s2)
0010D220 3C050028 lui        $a1, 0x28
0010D224 AFB00024 sw         $s0, 0x24($sp)
0010D228 24B02090 addiu      $s0, $a1, 0x2090
0010D22C AE200000 sw         $zero, ($s1)
0010D230 26240018 addiu      $a0, $s1, 0x18
0010D234 00002825 move       $a1, $zero
0010D238 34060044 ori        $a2, $zero, 0x44
0010D23C 34070045 ori        $a3, $zero, 0x45
0010D240 E7B40020 swc1       $f20, 0x20($sp)
0010D244 AFBF0030 sw         $ra, 0x30($sp)
0010D248 0C01859E jal        0x61678
0010D24C 02004025 move       $t0, $s0
0010D250 26240040 addiu      $a0, $s1, 0x40
0010D254 00002825 move       $a1, $zero
0010D258 34060044 ori        $a2, $zero, 0x44
0010D25C 34070045 ori        $a3, $zero, 0x45
0010D260 0C01859E jal        0x61678
0010D264 02004025 move       $t0, $s0
0010D268 0C03CDF3 jal        0xf37cc
0010D26C 2624008C addiu      $a0, $s1, 0x8c
0010D270 0C03CE1B jal        0xf386c
0010D274 26240068 addiu      $a0, $s1, 0x68
0010D278 3C043EAA lui        $a0, 0x3eaa
0010D27C 3484AAAB ori        $a0, $a0, 0xaaab
0010D280 44846000 mtc1       $a0, $f12
0010D284 AE200008 sw         $zero, 8($s1)
0010D288 E62C0004 swc1       $f12, 4($s1)
0010D28C 4480A000 mtc1       $zero, $f20
0010D290 A22000B8 sb         $zero, 0xb8($s1)
0010D294 E63400BC swc1       $f20, 0xbc($s1)
0010D298 A22000B9 sb         $zero, 0xb9($s1)
0010D29C A2400046 sb         $zero, 0x46($s2)
0010D2A0 3C100028 lui        $s0, 0x28
0010D2A4 8E05F8D8 lw         $a1, -0x728($s0)
0010D2A8 8CA600F0 lw         $a2, 0xf0($a1)
0010D2AC 26440074 addiu      $a0, $s2, 0x74
0010D2B0 34050002 ori        $a1, $zero, 2
0010D2B4 0C006F54 jal        0x1bd50
0010D2B8 2407FFFF addiu      $a3, $zero, -1
0010D2BC 8E05F8D8 lw         $a1, -0x728($s0)
0010D2C0 34040002 ori        $a0, $zero, 2
0010D2C4 0C007769 jal        0x1dda4
0010D2C8 8CA500F0 lw         $a1, 0xf0($a1)
0010D2CC 10400006 beqz       $v0, 0x10d2e8
0010D2D0 00000000 nop        
0010D2D4 8E05F8D8 lw         $a1, -0x728($s0)
0010D2D8 0C0439D6 jal        0x10e758
0010D2DC 02402025 move       $a0, $s2
0010D2E0 10000002 b          0x10d2ec
0010D2E4 AE22000C sw         $v0, 0xc($s1)
0010D2E8 AE20000C sw         $zero, 0xc($s1)
0010D2EC 34050000 ori        $a1, $zero, 0
0010D2F0 02202025 move       $a0, $s1
0010D2F4 AC800010 sw         $zero, 0x10($a0)
0010D2F8 02253021 addu       $a2, $s1, $a1
0010D2FC A0C000BA sb         $zero, 0xba($a2)
0010D300 24A50001 addiu      $a1, $a1, 1
0010D304 2CA60002 sltiu      $a2, $a1, 2
0010D308 14C0FFFA bnez       $a2, 0x10d2f4
0010D30C 24840004 addiu      $a0, $a0, 4
0010D310 E63400B4 swc1       $f20, 0xb4($s1)
0010D314 8E04F8D8 lw         $a0, -0x728($s0)
0010D318 3C05002A lui        $a1, 0x2a
0010D31C C4ACD8CC lwc1       $f12, -0x2734($a1)
0010D320 3C05002A lui        $a1, 0x2a
0010D324 C4ADD8D0 lwc1       $f13, -0x2730($a1)
0010D328 3C05002A lui        $a1, 0x2a
0010D32C C4AED8D4 lwc1       $f14, -0x272c($a1)
0010D330 3C05002A lui        $a1, 0x2a
0010D334 3C06002A lui        $a2, 0x2a
0010D338 34070001 ori        $a3, $zero, 1
0010D33C 24A5D8C0 addiu      $a1, $a1, -0x2740
0010D340 0C01569F jal        0x55a7c
0010D344 24C6D8AC addiu      $a2, $a2, -0x2754
0010D348 34020001 ori        $v0, $zero, 1
0010D34C C7B40020 lwc1       $f20, 0x20($sp)
0010D350 8FB00024 lw         $s0, 0x24($sp)
0010D354 8FB10028 lw         $s1, 0x28($sp)
0010D358 8FB2002C lw         $s2, 0x2c($sp)
0010D35C 8FBF0030 lw         $ra, 0x30($sp)
0010D360 03E00008 jr         $ra
0010D364 27BD0040 addiu      $sp, $sp, 0x40

CALLBACK 0x0010D368 end 0x0010D3C0 ordinal 1

0010D368 27BDFFE0 addiu      $sp, $sp, -0x20
0010D36C AFB00010 sw         $s0, 0x10($sp)
0010D370 8C900058 lw         $s0, 0x58($a0)
0010D374 AFBF0014 sw         $ra, 0x14($sp)
0010D378 0C03CDFE jal        0xf37f8
0010D37C 2604008C addiu      $a0, $s0, 0x8c
0010D380 8E10000C lw         $s0, 0xc($s0)
0010D384 1200000A beqz       $s0, 0x10d3b0
0010D388 00000000 nop        
0010D38C 02002025 move       $a0, $s0
0010D390 0C0192FF jal        0x64bfc
0010D394 34050001 ori        $a1, $zero, 1
0010D398 8E040064 lw         $a0, 0x64($s0)
0010D39C 30840006 andi       $a0, $a0, 6
0010D3A0 10800003 beqz       $a0, 0x10d3b0
0010D3A4 00000000 nop        
0010D3A8 0C019375 jal        0x64dd4
0010D3AC 02002025 move       $a0, $s0
0010D3B0 8FB00010 lw         $s0, 0x10($sp)
0010D3B4 8FBF0014 lw         $ra, 0x14($sp)
0010D3B8 03E00008 jr         $ra
0010D3BC 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0010D88C end 0x0010E758 ordinal 2

0010D88C 27BDFE70 addiu      $sp, $sp, -0x190
0010D890 00802825 move       $a1, $a0
0010D894 AFBE0184 sw         $fp, 0x184($sp)
0010D898 8CBE0058 lw         $fp, 0x58($a1)
0010D89C AFB6017C sw         $s6, 0x17c($sp)
0010D8A0 8FD60000 lw         $s6, ($fp)
0010D8A4 AFB00164 sw         $s0, 0x164($sp)
0010D8A8 3C10002A lui        $s0, 0x2a
0010D8AC 8FC4000C lw         $a0, 0xc($fp)
0010D8B0 27C60068 addiu      $a2, $fp, 0x68
0010D8B4 E7B40154 swc1       $f20, 0x154($sp)
0010D8B8 E7BA0160 swc1       $f26, 0x160($sp)
0010D8BC AFB10168 sw         $s1, 0x168($sp)
0010D8C0 4480D000 mtc1       $zero, $f26
0010D8C4 46006506 mov.s      $f20, $f12
0010D8C8 AFA60148 sw         $a2, 0x148($sp)
0010D8CC 34110002 ori        $s1, $zero, 2
0010D8D0 2610D850 addiu      $s0, $s0, -0x27b0
0010D8D4 E7B60158 swc1       $f22, 0x158($sp)
0010D8D8 E7B8015C swc1       $f24, 0x15c($sp)
0010D8DC AFB2016C sw         $s2, 0x16c($sp)
0010D8E0 AFB30170 sw         $s3, 0x170($sp)
0010D8E4 AFB40174 sw         $s4, 0x174($sp)
0010D8E8 AFB50178 sw         $s5, 0x178($sp)
0010D8EC AFB70180 sw         $s7, 0x180($sp)
0010D8F0 AFBF0188 sw         $ra, 0x188($sp)
0010D8F4 10800005 beqz       $a0, 0x10d90c
0010D8F8 AFA50140 sw         $a1, 0x140($sp)
0010D8FC 8C850040 lw         $a1, 0x40($a0)
0010D900 8CA5001C lw         $a1, 0x1c($a1)
0010D904 00A0F809 jalr       $a1
0010D908 4600A306 mov.s      $f12, $f20
0010D90C 8EC500F0 lw         $a1, 0xf0($s6)
0010D910 0C007541 jal        0x1d504
0010D914 34040002 ori        $a0, $zero, 2
0010D918 0C0155F5 jal        0x557d4
0010D91C 02C02025 move       $a0, $s6
0010D920 8FC5000C lw         $a1, 0xc($fp)
0010D924 00403825 move       $a3, $v0
0010D928 34040001 ori        $a0, $zero, 1
0010D92C 54A00001 bnel       $a1, $zero, 0x10d934
0010D930 02202025 move       $a0, $s1
0010D934 AFA40138 sw         $a0, 0x138($sp)
0010D938 A3A70144 sb         $a3, 0x144($sp)
0010D93C 0080B825 move       $s7, $a0
0010D940 02008825 move       $s1, $s0
0010D944 8EC500F0 lw         $a1, 0xf0($s6)
0010D948 0C007769 jal        0x1dda4
0010D94C 34040002 ori        $a0, $zero, 2
0010D950 00022140 sll        $a0, $v0, 5
0010D954 00022880 sll        $a1, $v0, 2
0010D958 00852021 addu       $a0, $a0, $a1
0010D95C 34100000 ori        $s0, $zero, 0
0010D960 00912021 addu       $a0, $a0, $s1
0010D964 0217302B sltu       $a2, $s0, $s7
0010D968 10C00026 beqz       $a2, 0x10da04
0010D96C AFA4013C sw         $a0, 0x13c($sp)
0010D970 3C14002A lui        $s4, 0x2a
0010D974 34150001 ori        $s5, $zero, 1
0010D978 27B30030 addiu      $s3, $sp, 0x30
0010D97C 27B20050 addiu      $s2, $sp, 0x50
0010D980 27B10070 addiu      $s1, $sp, 0x70
0010D984 2694D8AC addiu      $s4, $s4, -0x2754
0010D988 AFB1014C sw         $s1, 0x14c($sp)
0010D98C 8FB10140 lw         $s1, 0x140($sp)
0010D990 02602025 move       $a0, $s3
0010D994 02202825 move       $a1, $s1
0010D998 0C03AF43 jal        0xebd0c
0010D99C 02803025 move       $a2, $s4
0010D9A0 0C00A99C jal        0x2a670
0010D9A4 02C02025 move       $a0, $s6
0010D9A8 C44C0020 lwc1       $f12, 0x20($v0)
0010D9AC E64C0000 swc1       $f12, ($s2)
0010D9B0 C44C0024 lwc1       $f12, 0x24($v0)
0010D9B4 02202025 move       $a0, $s1
0010D9B8 E64C0004 swc1       $f12, 4($s2)
0010D9BC C44C0028 lwc1       $f12, 0x28($v0)
0010D9C0 E64C0008 swc1       $f12, 8($s2)
0010D9C4 C44C002C lwc1       $f12, 0x2c($v0)
0010D9C8 E64C000C swc1       $f12, 0xc($s2)
0010D9CC 16150002 bne        $s0, $s5, 0x10d9d8
0010D9D0 8FB1014C lw         $s1, 0x14c($sp)
0010D9D4 8FC4000C lw         $a0, 0xc($fp)
0010D9D8 00802825 move       $a1, $a0
0010D9DC 02202025 move       $a0, $s1
0010D9E0 0C03AF43 jal        0xebd0c
0010D9E4 02803025 move       $a2, $s4
0010D9E8 8FA40138 lw         $a0, 0x138($sp)
0010D9EC 26100001 addiu      $s0, $s0, 1
0010D9F0 26730010 addiu      $s3, $s3, 0x10
0010D9F4 26520010 addiu      $s2, $s2, 0x10
0010D9F8 0204202B sltu       $a0, $s0, $a0
0010D9FC 1480FFE2 bnez       $a0, 0x10d988
0010DA00 26310010 addiu      $s1, $s1, 0x10
0010DA04 AFA00090 sw         $zero, 0x90($sp)
0010DA08 AFA00094 sw         $zero, 0x94($sp)
0010DA0C C6D609DC lwc1       $f22, 0x9dc($s6)
0010DA10 3C04002A lui        $a0, 0x2a
0010DA14 C48CD9AC lwc1       $f12, -0x2654($a0)
0010DA18 34140000 ori        $s4, $zero, 0
0010DA1C 46166582 mul.s      $f22, $f12, $f22
0010DA20 8EC600F0 lw         $a2, 0xf0($s6)
0010DA24 34100000 ori        $s0, $zero, 0
0010DA28 34040002 ori        $a0, $zero, 2
0010DA2C 0C0076E2 jal        0x1db88
0010DA30 34050002 ori        $a1, $zero, 2
0010DA34 8FA6013C lw         $a2, 0x13c($sp)
0010DA38 93A70144 lbu        $a3, 0x144($sp)
0010DA3C 34150002 ori        $s5, $zero, 2
0010DA40 27B30030 addiu      $s3, $sp, 0x30
0010DA44 27B10050 addiu      $s1, $sp, 0x50
0010DA48 1040006A beqz       $v0, 0x10dbf4
0010DA4C 3C08002A lui        $t0, 0x2a
0010DA50 8EC4095C lw         $a0, 0x95c($s6)
0010DA54 3C050010 lui        $a1, 0x10
0010DA58 00852024 and        $a0, $a0, $a1
0010DA5C 0004202B sltu       $a0, $zero, $a0
0010DA60 308400FF andi       $a0, $a0, 0xff
0010DA64 10800063 beqz       $a0, 0x10dbf4
0010DA68 00000000 nop        
0010DA6C 86C400F8 lh         $a0, 0xf8($s6)
0010DA70 3405001F ori        $a1, $zero, 0x1f
0010DA74 1085005F beq        $a0, $a1, 0x10dbf4
0010DA78 00000000 nop        
0010DA7C A3B00150 sb         $s0, 0x150($sp)
0010DA80 AFB5014C sw         $s5, 0x14c($sp)
0010DA84 00C0A825 move       $s5, $a2
0010DA88 27B000B8 addiu      $s0, $sp, 0xb8
0010DA8C 01009025 move       $s2, $t0
0010DA90 00E0B825 move       $s7, $a3
0010DA94 AFA000B8 sw         $zero, 0xb8($sp)
0010DA98 26040004 addiu      $a0, $s0, 4
0010DA9C 00002825 move       $a1, $zero
0010DAA0 0C0600AC jal        0x1802b0
0010DAA4 3406002C ori        $a2, $zero, 0x2c
0010DAA8 0C00A99C jal        0x2a670
0010DAAC 02C02025 move       $a0, $s6
0010DAB0 C64CD9B0 lwc1       $f12, -0x2650($s2)
0010DAB4 02C02025 move       $a0, $s6
0010DAB8 460CB301 sub.s      $f12, $f22, $f12
0010DABC 3405000C ori        $a1, $zero, 0xc
0010DAC0 02003025 move       $a2, $s0
0010DAC4 02203825 move       $a3, $s1
0010DAC8 00404025 move       $t0, $v0
0010DACC 02604825 move       $t1, $s3
0010DAD0 02E05025 move       $t2, $s7
0010DAD4 0C00F1BF jal        0x3c6fc
0010DAD8 02A05825 move       $t3, $s5
0010DADC 8FA60138 lw         $a2, 0x138($sp)
0010DAE0 34050000 ori        $a1, $zero, 0
0010DAE4 8FB5014C lw         $s5, 0x14c($sp)
0010DAE8 00402025 move       $a0, $v0
0010DAEC 00A6302B sltu       $a2, $a1, $a2
0010DAF0 10C0003E beqz       $a2, 0x10dbec
0010DAF4 93B00150 lbu        $s0, 0x150($sp)
0010DAF8 34060001 ori        $a2, $zero, 1
0010DAFC 2489FFFF addiu      $t1, $a0, -1
0010DB00 340D0001 ori        $t5, $zero, 1
0010DB04 03C01825 move       $v1, $fp
0010DB08 03A06025 move       $t4, $sp
0010DB0C 03C53821 addu       $a3, $fp, $a1
0010DB10 90E800BA lbu        $t0, 0xba($a3)
0010DB14 11000028 beqz       $t0, 0x10dbb8
0010DB18 00000000 nop        
0010DB1C 01205025 move       $t2, $t1
0010DB20 05400013 bltz       $t2, 0x10db70
0010DB24 34080000 ori        $t0, $zero, 0
0010DB28 00095880 sll        $t3, $t1, 2
0010DB2C 03AB5821 addu       $t3, $sp, $t3
0010DB30 8D6200B8 lw         $v0, 0xb8($t3)
0010DB34 8C6E0010 lw         $t6, 0x10($v1)
0010DB38 144E000A bne        $v0, $t6, 0x10db64
0010DB3C 00000000 nop        
0010DB40 8C4E0040 lw         $t6, 0x40($v0)
0010DB44 91CE004B lbu        $t6, 0x4b($t6)
0010DB48 15C60006 bne        $t6, $a2, 0x10db64
0010DB4C 00000000 nop        
0010DB50 AC620010 sw         $v0, 0x10($v1)
0010DB54 AD820090 sw         $v0, 0x90($t4)
0010DB58 26940001 addiu      $s4, $s4, 1
0010DB5C 00C08025 move       $s0, $a2
0010DB60 00C04025 move       $t0, $a2
0010DB64 254AFFFF addiu      $t2, $t2, -1
0010DB68 0541FFF1 bgez       $t2, 0x10db30
0010DB6C 256BFFFC addiu      $t3, $t3, -4
0010DB70 1500000F bnez       $t0, 0x10dbb0
0010DB74 00000000 nop        
0010DB78 AD800090 sw         $zero, 0x90($t4)
0010DB7C 8C680010 lw         $t0, 0x10($v1)
0010DB80 8D080064 lw         $t0, 0x64($t0)
0010DB84 310A0001 andi       $t2, $t0, 1
0010DB88 11400007 beqz       $t2, 0x10dba8
0010DB8C 310A0008 andi       $t2, $t0, 8
0010DB90 15400005 bnez       $t2, 0x10dba8
0010DB94 310A0006 andi       $t2, $t0, 6
0010DB98 15400003 bnez       $t2, 0x10dba8
0010DB9C 31080400 andi       $t0, $t0, 0x400
0010DBA0 11000003 beqz       $t0, 0x10dbb0
0010DBA4 00000000 nop        
0010DBA8 AC600010 sw         $zero, 0x10($v1)
0010DBAC A0E000BA sb         $zero, 0xba($a3)
0010DBB0 10000008 b          0x10dbd4
0010DBB4 00000000 nop        
0010DBB8 00A4402B sltu       $t0, $a1, $a0
0010DBBC 11000005 beqz       $t0, 0x10dbd4
0010DBC0 00000000 nop        
0010DBC4 8D8800B8 lw         $t0, 0xb8($t4)
0010DBC8 AD880090 sw         $t0, 0x90($t4)
0010DBCC AC680010 sw         $t0, 0x10($v1)
0010DBD0 A0ED00BA sb         $t5, 0xba($a3)
0010DBD4 8FA70138 lw         $a3, 0x138($sp)
0010DBD8 24A50001 addiu      $a1, $a1, 1
0010DBDC 24630004 addiu      $v1, $v1, 4
0010DBE0 00A7382B sltu       $a3, $a1, $a3
0010DBE4 14E0FFC9 bnez       $a3, 0x10db0c
0010DBE8 258C0004 addiu      $t4, $t4, 4
0010DBEC 1000002D b          0x10dca4
0010DBF0 00000000 nop        
0010DBF4 A3B00150 sb         $s0, 0x150($sp)
0010DBF8 AFB5014C sw         $s5, 0x14c($sp)
0010DBFC 01009025 move       $s2, $t0
0010DC00 00E0A825 move       $s5, $a3
0010DC04 00C08025 move       $s0, $a2
0010DC08 0C00A99C jal        0x2a670
0010DC0C 02C02025 move       $a0, $s6
0010DC10 C64CD9B0 lwc1       $f12, -0x2650($s2)
0010DC14 02C02025 move       $a0, $s6
0010DC18 460CB301 sub.s      $f12, $f22, $f12
0010DC1C 02E02825 move       $a1, $s7
0010DC20 27A600E8 addiu      $a2, $sp, 0xe8
0010DC24 02203825 move       $a3, $s1
0010DC28 00404025 move       $t0, $v0
0010DC2C 02604825 move       $t1, $s3
0010DC30 02A05025 move       $t2, $s5
0010DC34 0C00F1BF jal        0x3c6fc
0010DC38 02005825 move       $t3, $s0
0010DC3C 8FA50138 lw         $a1, 0x138($sp)
0010DC40 34040000 ori        $a0, $zero, 0
0010DC44 8FB5014C lw         $s5, 0x14c($sp)
0010DC48 0040B825 move       $s7, $v0
0010DC4C 0085282B sltu       $a1, $a0, $a1
0010DC50 10A00014 beqz       $a1, 0x10dca4
0010DC54 93B00150 lbu        $s0, 0x150($sp)
0010DC58 03A02825 move       $a1, $sp
0010DC5C 03C03025 move       $a2, $fp
0010DC60 8FA70138 lw         $a3, 0x138($sp)
0010DC64 0097402B sltu       $t0, $a0, $s7
0010DC68 11000005 beqz       $t0, 0x10dc80
0010DC6C 00000000 nop        
0010DC70 8CA800E8 lw         $t0, 0xe8($a1)
0010DC74 26940001 addiu      $s4, $s4, 1
0010DC78 10000002 b          0x10dc84
0010DC7C ACA80090 sw         $t0, 0x90($a1)
0010DC80 ACA00090 sw         $zero, 0x90($a1)
0010DC84 ACC00010 sw         $zero, 0x10($a2)
0010DC88 03C44021 addu       $t0, $fp, $a0
0010DC8C A10000BA sb         $zero, 0xba($t0)
0010DC90 24840001 addiu      $a0, $a0, 1
0010DC94 24A50004 addiu      $a1, $a1, 4
0010DC98 0087402B sltu       $t0, $a0, $a3
0010DC9C 1500FFF1 bnez       $t0, 0x10dc64
0010DCA0 24C60004 addiu      $a2, $a2, 4
0010DCA4 0C00A900 jal        0x2a400
0010DCA8 02C02025 move       $a0, $s6
0010DCAC 1040002C beqz       $v0, 0x10dd60
0010DCB0 00000000 nop        
0010DCB4 1200002A beqz       $s0, 0x10dd60
0010DCB8 00000000 nop        
0010DCBC 8FA40090 lw         $a0, 0x90($sp)
0010DCC0 14800004 bnez       $a0, 0x10dcd4
0010DCC4 00000000 nop        
0010DCC8 8FA40094 lw         $a0, 0x94($sp)
0010DCCC 10800024 beqz       $a0, 0x10dd60
0010DCD0 00000000 nop        
0010DCD4 3C06002A lui        $a2, 0x2a
0010DCD8 C4CCD940 lwc1       $f12, -0x26c0($a2)
0010DCDC 3C063F80 lui        $a2, 0x3f80
0010DCE0 4486B000 mtc1       $a2, $f22
0010DCE4 34040064 ori        $a0, $zero, 0x64
0010DCE8 34050002 ori        $a1, $zero, 2
0010DCEC 0C000993 jal        0x264c
0010DCF0 4600B346 mov.s      $f13, $f22
0010DCF4 3C053F91 lui        $a1, 0x3f91
0010DCF8 4600B346 mov.s      $f13, $f22
0010DCFC 34A5EB85 ori        $a1, $a1, 0xeb85
0010DD00 44856000 mtc1       $a1, $f12
0010DD04 34040064 ori        $a0, $zero, 0x64
0010DD08 0C00099E jal        0x2678
0010DD0C 34050002 ori        $a1, $zero, 2
0010DD10 8FA40090 lw         $a0, 0x90($sp)
0010DD14 1080000A beqz       $a0, 0x10dd40
0010DD18 00000000 nop        
0010DD1C 0C00031B jal        0xc6c
0010DD20 24900030 addiu      $s0, $a0, 0x30
0010DD24 46000347 neg.s      $f13, $f0
0010DD28 02002025 move       $a0, $s0
0010DD2C 4600B306 mov.s      $f12, $f22
0010DD30 0C000A42 jal        0x2908
0010DD34 00002825 move       $a1, $zero
0010DD38 10000009 b          0x10dd60
0010DD3C 00000000 nop        
0010DD40 8FA40094 lw         $a0, 0x94($sp)
0010DD44 0C00031B jal        0xc6c
0010DD48 24900030 addiu      $s0, $a0, 0x30
0010DD4C 46000347 neg.s      $f13, $f0
0010DD50 02002025 move       $a0, $s0
0010DD54 4600B306 mov.s      $f12, $f22
0010DD58 0C000A42 jal        0x2908
0010DD5C 00002825 move       $a1, $zero
0010DD60 1280016F beqz       $s4, 0x10e320
0010DD64 00000000 nop        
0010DD68 3C043480 lui        $a0, 0x3480
0010DD6C 16950038 bne        $s4, $s5, 0x10de50
0010DD70 4484C000 mtc1       $a0, $f24
0010DD74 8EC50594 lw         $a1, 0x594($s6)
0010DD78 02C02025 move       $a0, $s6
0010DD7C 0C00A99C jal        0x2a670
0010DD80 24B00030 addiu      $s0, $a1, 0x30
0010DD84 C44C0000 lwc1       $f12, ($v0)
0010DD88 3C04002A lui        $a0, 0x2a
0010DD8C C48DD93C lwc1       $f13, -0x26c4($a0)
0010DD90 C60E0000 lwc1       $f14, ($s0)
0010DD94 460D6302 mul.s      $f12, $f12, $f13
0010DD98 460C7300 add.s      $f12, $f14, $f12
0010DD9C E7AC0100 swc1       $f12, 0x100($sp)
0010DDA0 C44F0004 lwc1       $f15, 4($v0)
0010DDA4 C6100004 lwc1       $f16, 4($s0)
0010DDA8 460D7BC2 mul.s      $f15, $f15, $f13
0010DDAC 8FA50090 lw         $a1, 0x90($sp)
0010DDB0 460F83C0 add.s      $f15, $f16, $f15
0010DDB4 24A60030 addiu      $a2, $a1, 0x30
0010DDB8 E7AF0104 swc1       $f15, 0x104($sp)
0010DDBC C44E0008 lwc1       $f14, 8($v0)
0010DDC0 C6110008 lwc1       $f17, 8($s0)
0010DDC4 460D7342 mul.s      $f13, $f14, $f13
0010DDC8 8FA40094 lw         $a0, 0x94($sp)
0010DDCC 24870030 addiu      $a3, $a0, 0x30
0010DDD0 460D8B40 add.s      $f13, $f17, $f13
0010DDD4 E7AD0108 swc1       $f13, 0x108($sp)
0010DDD8 C4D00000 lwc1       $f16, ($a2)
0010DDDC C4D20004 lwc1       $f18, 4($a2)
0010DDE0 460C8401 sub.s      $f16, $f16, $f12
0010DDE4 C4CE0008 lwc1       $f14, 8($a2)
0010DDE8 460F9481 sub.s      $f18, $f18, $f15
0010DDEC C4F10000 lwc1       $f17, ($a3)
0010DDF0 C4F30004 lwc1       $f19, 4($a3)
0010DDF4 460D7381 sub.s      $f14, $f14, $f13
0010DDF8 C4E00008 lwc1       $f0, 8($a3)
0010DDFC 460C8B01 sub.s      $f12, $f17, $f12
0010DE00 460F9BC1 sub.s      $f15, $f19, $f15
0010DE04 46108402 mul.s      $f16, $f16, $f16
0010DE08 46129482 mul.s      $f18, $f18, $f18
0010DE0C 460C6302 mul.s      $f12, $f12, $f12
0010DE10 460F7BC2 mul.s      $f15, $f15, $f15
0010DE14 460D0341 sub.s      $f13, $f0, $f13
0010DE18 460E7382 mul.s      $f14, $f14, $f14
0010DE1C 46128400 add.s      $f16, $f16, $f18
0010DE20 460F6300 add.s      $f12, $f12, $f15
0010DE24 460D6B42 mul.s      $f13, $f13, $f13
0010DE28 460E8380 add.s      $f14, $f16, $f14
0010DE2C 460D6300 add.s      $f12, $f12, $f13
0010DE30 460C703C c.lt.s     $f14, $f12
0010DE34 00000000 nop        
0010DE38 45000003 bc1f       0x10de48
0010DE3C 00000000 nop        
0010DE40 AFA50094 sw         $a1, 0x94($sp)
0010DE44 AFA40090 sw         $a0, 0x90($sp)
0010DE48 10000008 b          0x10de6c
0010DE4C 00000000 nop        
0010DE50 8FA40094 lw         $a0, 0x94($sp)
0010DE54 10800005 beqz       $a0, 0x10de6c
0010DE58 00000000 nop        
0010DE5C 8FA50090 lw         $a1, 0x90($sp)
0010DE60 14A00002 bnez       $a1, 0x10de6c
0010DE64 00000000 nop        
0010DE68 AFA40090 sw         $a0, 0x90($sp)
0010DE6C 34120000 ori        $s2, $zero, 0
0010DE70 0254202B sltu       $a0, $s2, $s4
0010DE74 1080001D beqz       $a0, 0x10deec
0010DE78 27B3010C addiu      $s3, $sp, 0x10c
0010DE7C 03A08025 move       $s0, $sp
0010DE80 27D10018 addiu      $s1, $fp, 0x18
0010DE84 8E040090 lw         $a0, 0x90($s0)
0010DE88 10800013 beqz       $a0, 0x10ded8
0010DE8C 00000000 nop        
0010DE90 0C00A900 jal        0x2a400
0010DE94 02C02025 move       $a0, $s6
0010DE98 1040000F beqz       $v0, 0x10ded8
0010DE9C 00000000 nop        
0010DEA0 8E040090 lw         $a0, 0x90($s0)
0010DEA4 02602825 move       $a1, $s3
0010DEA8 34060001 ori        $a2, $zero, 1
0010DEAC 0C019ACE jal        0x66b38
0010DEB0 00003825 move       $a3, $zero
0010DEB4 8E060090 lw         $a2, 0x90($s0)
0010DEB8 02202025 move       $a0, $s1
0010DEBC 34050001 ori        $a1, $zero, 1
0010DEC0 0C0183F6 jal        0x60fd8
0010DEC4 34070001 ori        $a3, $zero, 1
0010DEC8 02202025 move       $a0, $s1
0010DECC 02602825 move       $a1, $s3
0010DED0 0C018416 jal        0x61058
0010DED4 00003025 move       $a2, $zero
0010DED8 26520001 addiu      $s2, $s2, 1
0010DEDC 26100004 addiu      $s0, $s0, 4
0010DEE0 0254202B sltu       $a0, $s2, $s4
0010DEE4 1480FFE7 bnez       $a0, 0x10de84
0010DEE8 26310028 addiu      $s1, $s1, 0x28
0010DEEC 0C015603 jal        0x5580c
0010DEF0 02C02025 move       $a0, $s6
0010DEF4 34150000 ori        $s5, $zero, 0
0010DEF8 02B4202B sltu       $a0, $s5, $s4
0010DEFC 1080009B beqz       $a0, 0x10e16c
0010DF00 3C043F80 lui        $a0, 0x3f80
0010DF04 27B70118 addiu      $s7, $sp, 0x118
0010DF08 4484B000 mtc1       $a0, $f22
0010DF0C 03A08825 move       $s1, $sp
0010DF10 27B20050 addiu      $s2, $sp, 0x50
0010DF14 27B30070 addiu      $s3, $sp, 0x70
0010DF18 27B00098 addiu      $s0, $sp, 0x98
0010DF1C 8E240090 lw         $a0, 0x90($s1)
0010DF20 02E02825 move       $a1, $s7
0010DF24 00003025 move       $a2, $zero
0010DF28 0C019AC0 jal        0x66b00
0010DF2C 00003825 move       $a3, $zero
0010DF30 C66C0000 lwc1       $f12, ($s3)
0010DF34 C7AD0118 lwc1       $f13, 0x118($sp)
0010DF38 460C6B01 sub.s      $f12, $f13, $f12
0010DF3C 02402025 move       $a0, $s2
0010DF40 E64C0000 swc1       $f12, ($s2)
0010DF44 C7AC011C lwc1       $f12, 0x11c($sp)
0010DF48 C66E0004 lwc1       $f14, 4($s3)
0010DF4C 460E6301 sub.s      $f12, $f12, $f14
0010DF50 E64C0004 swc1       $f12, 4($s2)
0010DF54 C7AC0120 lwc1       $f12, 0x120($sp)
0010DF58 C66F0008 lwc1       $f15, 8($s3)
0010DF5C 460F6301 sub.s      $f12, $f12, $f15
0010DF60 E64C0008 swc1       $f12, 8($s2)
0010DF64 C48C0000 lwc1       $f12, ($a0)
0010DF68 C48D0004 lwc1       $f13, 4($a0)
0010DF6C 460C6302 mul.s      $f12, $f12, $f12
0010DF70 C48E0008 lwc1       $f14, 8($a0)
0010DF74 460D6B42 mul.s      $f13, $f13, $f13
0010DF78 460E7382 mul.s      $f14, $f14, $f14
0010DF7C 460D6300 add.s      $f12, $f12, $f13
0010DF80 460E6300 add.s      $f12, $f12, $f14
0010DF84 4618603C c.lt.s     $f12, $f24
0010DF88 00000000 nop        
0010DF8C 45000005 bc1f       0x10dfa4
0010DF90 00000000 nop        
0010DF94 8E240090 lw         $a0, 0x90($s1)
0010DF98 C6CC0030 lwc1       $f12, 0x30($s6)
0010DF9C 1000000F b          0x10dfdc
0010DFA0 24840030 addiu      $a0, $a0, 0x30
0010DFA4 46006304 sqrt.s     $f12, $f12
0010DFA8 460CB303 div.s      $f12, $f22, $f12
0010DFAC C48D0000 lwc1       $f13, ($a0)
0010DFB0 C48E0004 lwc1       $f14, 4($a0)
0010DFB4 C48F0008 lwc1       $f15, 8($a0)
0010DFB8 460C6B42 mul.s      $f13, $f13, $f12
0010DFBC 460C7382 mul.s      $f14, $f14, $f12
0010DFC0 E48D0000 swc1       $f13, ($a0)
0010DFC4 460C7B02 mul.s      $f12, $f15, $f12
0010DFC8 E48E0004 swc1       $f14, 4($a0)
0010DFCC E48C0008 swc1       $f12, 8($a0)
0010DFD0 8E240090 lw         $a0, 0x90($s1)
0010DFD4 C6CC0030 lwc1       $f12, 0x30($s6)
0010DFD8 24840030 addiu      $a0, $a0, 0x30
0010DFDC C48D0000 lwc1       $f13, ($a0)
0010DFE0 460C6B01 sub.s      $f12, $f13, $f12
0010DFE4 E60C0000 swc1       $f12, ($s0)
0010DFE8 C48C0004 lwc1       $f12, 4($a0)
0010DFEC C6CE0034 lwc1       $f14, 0x34($s6)
0010DFF0 460E6301 sub.s      $f12, $f12, $f14
0010DFF4 E60C0004 swc1       $f12, 4($s0)
0010DFF8 C48C0008 lwc1       $f12, 8($a0)
0010DFFC C6CF0038 lwc1       $f15, 0x38($s6)
0010E000 02002025 move       $a0, $s0
0010E004 460F6301 sub.s      $f12, $f12, $f15
0010E008 E60C0008 swc1       $f12, 8($s0)
0010E00C C48C0000 lwc1       $f12, ($a0)
0010E010 C48D0004 lwc1       $f13, 4($a0)
0010E014 460C6302 mul.s      $f12, $f12, $f12
0010E018 C48E0008 lwc1       $f14, 8($a0)
0010E01C 460D6B42 mul.s      $f13, $f13, $f13
0010E020 460E7382 mul.s      $f14, $f14, $f14
0010E024 460D6300 add.s      $f12, $f12, $f13
0010E028 460E6300 add.s      $f12, $f12, $f14
0010E02C 4618603C c.lt.s     $f12, $f24
0010E030 00000000 nop        
0010E034 45000005 bc1f       0x10e04c
0010E038 00000000 nop        
0010E03C C6CC0010 lwc1       $f12, 0x10($s6)
0010E040 C6CD0014 lwc1       $f13, 0x14($s6)
0010E044 1000000F b          0x10e084
0010E048 C6CE0018 lwc1       $f14, 0x18($s6)
0010E04C 46006304 sqrt.s     $f12, $f12
0010E050 460CB303 div.s      $f12, $f22, $f12
0010E054 C48D0000 lwc1       $f13, ($a0)
0010E058 C48E0004 lwc1       $f14, 4($a0)
0010E05C C48F0008 lwc1       $f15, 8($a0)
0010E060 460C6B42 mul.s      $f13, $f13, $f12
0010E064 460C7382 mul.s      $f14, $f14, $f12
0010E068 E48D0000 swc1       $f13, ($a0)
0010E06C 460C7B02 mul.s      $f12, $f15, $f12
0010E070 E48E0004 swc1       $f14, 4($a0)
0010E074 E48C0008 swc1       $f12, 8($a0)
0010E078 C6CC0010 lwc1       $f12, 0x10($s6)
0010E07C C6CD0014 lwc1       $f13, 0x14($s6)
0010E080 C6CE0018 lwc1       $f14, 0x18($s6)
0010E084 C60F0000 lwc1       $f15, ($s0)
0010E088 C6100004 lwc1       $f16, 4($s0)
0010E08C 460C7BC2 mul.s      $f15, $f15, $f12
0010E090 C6110008 lwc1       $f17, 8($s0)
0010E094 460D8342 mul.s      $f13, $f16, $f13
0010E098 460E8B82 mul.s      $f14, $f17, $f14
0010E09C 460D7B40 add.s      $f13, $f15, $f13
0010E0A0 460E6B40 add.s      $f13, $f13, $f14
0010E0A4 460C6B02 mul.s      $f12, $f13, $f12
0010E0A8 E7AC0128 swc1       $f12, 0x128($sp)
0010E0AC C6D20014 lwc1       $f18, 0x14($s6)
0010E0B0 46126C82 mul.s      $f18, $f13, $f18
0010E0B4 E7B2012C swc1       $f18, 0x12c($sp)
0010E0B8 C6D00018 lwc1       $f16, 0x18($s6)
0010E0BC 46106B42 mul.s      $f13, $f13, $f16
0010E0C0 02002025 move       $a0, $s0
0010E0C4 E7AD0130 swc1       $f13, 0x130($sp)
0010E0C8 C60D0000 lwc1       $f13, ($s0)
0010E0CC C60E0004 lwc1       $f14, 4($s0)
0010E0D0 460C6B01 sub.s      $f12, $f13, $f12
0010E0D4 C60F0008 lwc1       $f15, 8($s0)
0010E0D8 E60C0000 swc1       $f12, ($s0)
0010E0DC C7AC012C lwc1       $f12, 0x12c($sp)
0010E0E0 460C7301 sub.s      $f12, $f14, $f12
0010E0E4 E60C0004 swc1       $f12, 4($s0)
0010E0E8 C7AC0130 lwc1       $f12, 0x130($sp)
0010E0EC 460C7B01 sub.s      $f12, $f15, $f12
0010E0F0 E60C0008 swc1       $f12, 8($s0)
0010E0F4 C48C0000 lwc1       $f12, ($a0)
0010E0F8 C48D0004 lwc1       $f13, 4($a0)
0010E0FC 460C6302 mul.s      $f12, $f12, $f12
0010E100 C48E0008 lwc1       $f14, 8($a0)
0010E104 460D6B42 mul.s      $f13, $f13, $f13
0010E108 460E7382 mul.s      $f14, $f14, $f14
0010E10C 460D6300 add.s      $f12, $f12, $f13
0010E110 460E6300 add.s      $f12, $f12, $f14
0010E114 4618603C c.lt.s     $f12, $f24
0010E118 00000000 nop        
0010E11C 4501000C bc1t       0x10e150
0010E120 00000000 nop        
0010E124 46006304 sqrt.s     $f12, $f12
0010E128 460CB303 div.s      $f12, $f22, $f12
0010E12C C48D0000 lwc1       $f13, ($a0)
0010E130 C48E0004 lwc1       $f14, 4($a0)
0010E134 C48F0008 lwc1       $f15, 8($a0)
0010E138 460C6B42 mul.s      $f13, $f13, $f12
0010E13C 460C7382 mul.s      $f14, $f14, $f12
0010E140 E48D0000 swc1       $f13, ($a0)
0010E144 460C7B02 mul.s      $f12, $f15, $f12
0010E148 E48E0004 swc1       $f14, 4($a0)
0010E14C E48C0008 swc1       $f12, 8($a0)
0010E150 26B50001 addiu      $s5, $s5, 1
0010E154 26310004 addiu      $s1, $s1, 4
0010E158 26520010 addiu      $s2, $s2, 0x10
0010E15C 26730010 addiu      $s3, $s3, 0x10
0010E160 02B4202B sltu       $a0, $s5, $s4
0010E164 1480FF6D bnez       $a0, 0x10df1c
0010E168 2610000C addiu      $s0, $s0, 0xc
0010E16C 8FA50138 lw         $a1, 0x138($sp)
0010E170 8FA40090 lw         $a0, 0x90($sp)
0010E174 34150002 ori        $s5, $zero, 2
0010E178 14B5003C bne        $a1, $s5, 0x10e26c
0010E17C 27B30030 addiu      $s3, $sp, 0x30
0010E180 5695001D bnel       $s4, $s5, 0x10e1f8
0010E184 C7AC0050 lwc1       $f12, 0x50($sp)
0010E188 8FA50094 lw         $a1, 0x94($sp)
0010E18C C48C0030 lwc1       $f12, 0x30($a0)
0010E190 C4AD0030 lwc1       $f13, 0x30($a1)
0010E194 3C063F00 lui        $a2, 0x3f00
0010E198 460D6300 add.s      $f12, $f12, $f13
0010E19C 44867000 mtc1       $a2, $f14
0010E1A0 460E6302 mul.s      $f12, $f12, $f14
0010E1A4 3C063F80 lui        $a2, 0x3f80
0010E1A8 E7AC00F0 swc1       $f12, 0xf0($sp)
0010E1AC C48C0034 lwc1       $f12, 0x34($a0)
0010E1B0 C4AF0034 lwc1       $f15, 0x34($a1)
0010E1B4 460F6300 add.s      $f12, $f12, $f15
0010E1B8 3C070002 lui        $a3, 2
0010E1BC 44866800 mtc1       $a2, $f13
0010E1C0 460E6302 mul.s      $f12, $f12, $f14
0010E1C4 E7AC00F4 swc1       $f12, 0xf4($sp)
0010E1C8 C48C0038 lwc1       $f12, 0x38($a0)
0010E1CC C4B00038 lwc1       $f16, 0x38($a1)
0010E1D0 46106300 add.s      $f12, $f12, $f16
0010E1D4 E7AD00FC swc1       $f13, 0xfc($sp)
0010E1D8 460E6302 mul.s      $f12, $f12, $f14
0010E1DC E7AC00F8 swc1       $f12, 0xf8($sp)
0010E1E0 C6CC0030 lwc1       $f12, 0x30($s6)
0010E1E4 C6CD0034 lwc1       $f13, 0x34($s6)
0010E1E8 8EC4095C lw         $a0, 0x95c($s6)
0010E1EC C6CE0038 lwc1       $f14, 0x38($s6)
0010E1F0 1000002D b          0x10e2a8
0010E1F4 00872025 or         $a0, $a0, $a3
0010E1F8 C7AD0054 lwc1       $f13, 0x54($sp)
0010E1FC E7AC0060 swc1       $f12, 0x60($sp)
0010E200 C7AC0058 lwc1       $f12, 0x58($sp)
0010E204 E7AD0064 swc1       $f13, 0x64($sp)
0010E208 C7AD005C lwc1       $f13, 0x5c($sp)
0010E20C E7AC0068 swc1       $f12, 0x68($sp)
0010E210 C7AC0098 lwc1       $f12, 0x98($sp)
0010E214 E7AD006C swc1       $f13, 0x6c($sp)
0010E218 C7AD009C lwc1       $f13, 0x9c($sp)
0010E21C E7AC00A4 swc1       $f12, 0xa4($sp)
0010E220 C7AC00A0 lwc1       $f12, 0xa0($sp)
0010E224 E7AD00A8 swc1       $f13, 0xa8($sp)
0010E228 E7AC00AC swc1       $f12, 0xac($sp)
0010E22C 24840030 addiu      $a0, $a0, 0x30
0010E230 C48C0000 lwc1       $f12, ($a0)
0010E234 E7AC00F0 swc1       $f12, 0xf0($sp)
0010E238 C48C0004 lwc1       $f12, 4($a0)
0010E23C E7AC00F4 swc1       $f12, 0xf4($sp)
0010E240 C48C0008 lwc1       $f12, 8($a0)
0010E244 E7AC00F8 swc1       $f12, 0xf8($sp)
0010E248 C48C000C lwc1       $f12, 0xc($a0)
0010E24C 3C040002 lui        $a0, 2
0010E250 E7AC00FC swc1       $f12, 0xfc($sp)
0010E254 C6CC0030 lwc1       $f12, 0x30($s6)
0010E258 C6CD0034 lwc1       $f13, 0x34($s6)
0010E25C 8EC5095C lw         $a1, 0x95c($s6)
0010E260 C6CE0038 lwc1       $f14, 0x38($s6)
0010E264 10000010 b          0x10e2a8
0010E268 00A42025 or         $a0, $a1, $a0
0010E26C 24840030 addiu      $a0, $a0, 0x30
0010E270 C48C0000 lwc1       $f12, ($a0)
0010E274 E7AC00F0 swc1       $f12, 0xf0($sp)
0010E278 C48C0004 lwc1       $f12, 4($a0)
0010E27C E7AC00F4 swc1       $f12, 0xf4($sp)
0010E280 C48C0008 lwc1       $f12, 8($a0)
0010E284 E7AC00F8 swc1       $f12, 0xf8($sp)
0010E288 C48C000C lwc1       $f12, 0xc($a0)
0010E28C 3C040002 lui        $a0, 2
0010E290 E7AC00FC swc1       $f12, 0xfc($sp)
0010E294 C6CC0030 lwc1       $f12, 0x30($s6)
0010E298 C6CD0034 lwc1       $f13, 0x34($s6)
0010E29C 8EC5095C lw         $a1, 0x95c($s6)
0010E2A0 C6CE0038 lwc1       $f14, 0x38($s6)
0010E2A4 00A42025 or         $a0, $a1, $a0
0010E2A8 AEC4095C sw         $a0, 0x95c($s6)
0010E2AC C7AF00F0 lwc1       $f15, 0xf0($sp)
0010E2B0 460C7B01 sub.s      $f12, $f15, $f12
0010E2B4 E6CC02A8 swc1       $f12, 0x2a8($s6)
0010E2B8 C7B000F4 lwc1       $f16, 0xf4($sp)
0010E2BC 460C6442 mul.s      $f17, $f12, $f12
0010E2C0 460D8341 sub.s      $f13, $f16, $f13
0010E2C4 E6CD02AC swc1       $f13, 0x2ac($s6)
0010E2C8 C7B200F8 lwc1       $f18, 0xf8($sp)
0010E2CC 4600D346 mov.s      $f13, $f26
0010E2D0 460D6CC2 mul.s      $f19, $f13, $f13
0010E2D4 460E9381 sub.s      $f14, $f18, $f14
0010E2D8 E6DA02AC swc1       $f26, 0x2ac($s6)
0010E2DC 46138BC0 add.s      $f15, $f17, $f19
0010E2E0 460E7402 mul.s      $f16, $f14, $f14
0010E2E4 46107BC0 add.s      $f15, $f15, $f16
0010E2E8 4618783C c.lt.s     $f15, $f24
0010E2EC 00000000 nop        
0010E2F0 4501000B bc1t       0x10e320
0010E2F4 E6CE02B0 swc1       $f14, 0x2b0($s6)
0010E2F8 3C043F80 lui        $a0, 0x3f80
0010E2FC 46007BC4 sqrt.s     $f15, $f15
0010E300 44848000 mtc1       $a0, $f16
0010E304 460F83C3 div.s      $f15, $f16, $f15
0010E308 460F6302 mul.s      $f12, $f12, $f15
0010E30C 460F6B42 mul.s      $f13, $f13, $f15
0010E310 460F7382 mul.s      $f14, $f14, $f15
0010E314 E6CC02A8 swc1       $f12, 0x2a8($s6)
0010E318 E6CD02AC swc1       $f13, 0x2ac($s6)
0010E31C E6CE02B0 swc1       $f14, 0x2b0($s6)
0010E320 8FA40138 lw         $a0, 0x138($sp)
0010E324 14950010 bne        $a0, $s5, 0x10e368
0010E328 C7AC0098 lwc1       $f12, 0x98($sp)
0010E32C E6CC02B8 swc1       $f12, 0x2b8($s6)
0010E330 C7AC009C lwc1       $f12, 0x9c($sp)
0010E334 E6CC02BC swc1       $f12, 0x2bc($s6)
0010E338 C7AC00A0 lwc1       $f12, 0xa0($sp)
0010E33C E6CC02C0 swc1       $f12, 0x2c0($s6)
0010E340 C7AC00A4 lwc1       $f12, 0xa4($sp)
0010E344 E6CC02C4 swc1       $f12, 0x2c4($s6)
0010E348 C7AC00A8 lwc1       $f12, 0xa8($sp)
0010E34C E6CC02C8 swc1       $f12, 0x2c8($s6)
0010E350 C7AC00AC lwc1       $f12, 0xac($sp)
0010E354 E6CC02CC swc1       $f12, 0x2cc($s6)
0010E358 C7CC0004 lwc1       $f12, 4($fp)
0010E35C C7CD00B4 lwc1       $f13, 0xb4($fp)
0010E360 10000011 b          0x10e3a8
0010E364 46146301 sub.s      $f12, $f12, $f20
0010E368 E6CC02B8 swc1       $f12, 0x2b8($s6)
0010E36C C7AC009C lwc1       $f12, 0x9c($sp)
0010E370 02C02025 move       $a0, $s6
0010E374 E6CC02BC swc1       $f12, 0x2bc($s6)
0010E378 C7AC00A0 lwc1       $f12, 0xa0($sp)
0010E37C 0C00A99C jal        0x2a670
0010E380 E6CC02C0 swc1       $f12, 0x2c0($s6)
0010E384 C44C0020 lwc1       $f12, 0x20($v0)
0010E388 E6CC02C4 swc1       $f12, 0x2c4($s6)
0010E38C C44C0024 lwc1       $f12, 0x24($v0)
0010E390 E6CC02C8 swc1       $f12, 0x2c8($s6)
0010E394 C44C0028 lwc1       $f12, 0x28($v0)
0010E398 E6CC02CC swc1       $f12, 0x2cc($s6)
0010E39C C7CC0004 lwc1       $f12, 4($fp)
0010E3A0 C7CD00B4 lwc1       $f13, 0xb4($fp)
0010E3A4 46146301 sub.s      $f12, $f12, $f20
0010E3A8 E7CC0004 swc1       $f12, 4($fp)
0010E3AC 461A603C c.lt.s     $f12, $f26
0010E3B0 00000000 nop        
0010E3B4 45000002 bc1f       0x10e3c0
0010E3B8 8FB10138 lw         $s1, 0x138($sp)
0010E3BC E7DA0004 swc1       $f26, 4($fp)
0010E3C0 461A6832 c.eq.s     $f13, $f26
0010E3C4 00000000 nop        
0010E3C8 4501001E bc1t       0x10e444
0010E3CC 00000000 nop        
0010E3D0 46146B40 add.s      $f13, $f13, $f20
0010E3D4 3C04002A lui        $a0, 0x2a
0010E3D8 E7CD00B4 swc1       $f13, 0xb4($fp)
0010E3DC C48CD8A4 lwc1       $f12, -0x275c($a0)
0010E3E0 460C683C c.lt.s     $f13, $f12
0010E3E4 00000000 nop        
0010E3E8 45000016 bc1f       0x10e444
0010E3EC 3C04002A lui        $a0, 0x2a
0010E3F0 C48CD8A8 lwc1       $f12, -0x2758($a0)
0010E3F4 460C683E c.le.s     $f13, $f12
0010E3F8 00000000 nop        
0010E3FC 45010011 bc1t       0x10e444
0010E400 00000000 nop        
0010E404 0C0070C3 jal        0x1c30c
0010E408 02C02025 move       $a0, $s6
0010E40C 1040000D beqz       $v0, 0x10e444
0010E410 00000000 nop        
0010E414 1635000B bne        $s1, $s5, 0x10e444
0010E418 00000000 nop        
0010E41C 93C400B8 lbu        $a0, 0xb8($fp)
0010E420 10800008 beqz       $a0, 0x10e444
0010E424 00000000 nop        
0010E428 26C400C0 addiu      $a0, $s6, 0xc0
0010E42C 8C840014 lw         $a0, 0x14($a0)
0010E430 30842000 andi       $a0, $a0, 0x2000
0010E434 10800003 beqz       $a0, 0x10e444
0010E438 00000000 nop        
0010E43C 34040001 ori        $a0, $zero, 1
0010E440 A3C400B9 sb         $a0, 0xb9($fp)
0010E444 8FC40000 lw         $a0, ($fp)
0010E448 3405000C ori        $a1, $zero, 0xc
0010E44C 8C8409BC lw         $a0, 0x9bc($a0)
0010E450 10850013 beq        $a0, $a1, 0x10e4a0
0010E454 00000000 nop        
0010E458 8FB20140 lw         $s2, 0x140($sp)
0010E45C 34040002 ori        $a0, $zero, 2
0010E460 8E450058 lw         $a1, 0x58($s2)
0010E464 8CA60000 lw         $a2, ($a1)
0010E468 34050001 ori        $a1, $zero, 1
0010E46C 0C0076E2 jal        0x1db88
0010E470 8CC600F0 lw         $a2, 0xf0($a2)
0010E474 10400003 beqz       $v0, 0x10e484
0010E478 3C04002A lui        $a0, 0x2a
0010E47C 10000002 b          0x10e488
0010E480 C48CD8D8 lwc1       $f12, -0x2728($a0)
0010E484 4600D306 mov.s      $f12, $f26
0010E488 27C5008C addiu      $a1, $fp, 0x8c
0010E48C 0C03CE7B jal        0xf39ec
0010E490 02402025 move       $a0, $s2
0010E494 8FA50148 lw         $a1, 0x148($sp)
0010E498 0C03CFDF jal        0xf3f7c
0010E49C 02402025 move       $a0, $s2
0010E4A0 8FC40008 lw         $a0, 8($fp)
0010E4A4 34050003 ori        $a1, $zero, 3
0010E4A8 14850037 bne        $a0, $a1, 0x10e588
0010E4AC 8FB20140 lw         $s2, 0x140($sp)
0010E4B0 02402025 move       $a0, $s2
0010E4B4 0C019491 jal        0x65244
0010E4B8 00002825 move       $a1, $zero
0010E4BC 1440000B bnez       $v0, 0x10e4ec
0010E4C0 00000000 nop        
0010E4C4 C7CC00B4 lwc1       $f12, 0xb4($fp)
0010E4C8 3C04002A lui        $a0, 0x2a
0010E4CC C48DD8A4 lwc1       $f13, -0x275c($a0)
0010E4D0 460D603E c.le.s     $f12, $f13
0010E4D4 00000000 nop        
0010E4D8 4501002B bc1t       0x10e588
0010E4DC 00000000 nop        
0010E4E0 93C400B9 lbu        $a0, 0xb9($fp)
0010E4E4 14800028 bnez       $a0, 0x10e588
0010E4E8 00000000 nop        
0010E4EC 3C083DCC lui        $t0, 0x3dcc
0010E4F0 4600D346 mov.s      $f13, $f26
0010E4F4 A2400045 sb         $zero, 0x45($s2)
0010E4F8 3508CCCD ori        $t0, $t0, 0xcccd
0010E4FC AFC00008 sw         $zero, 8($fp)
0010E500 44886000 mtc1       $t0, $f12
0010E504 02402025 move       $a0, $s2
0010E508 00002825 move       $a1, $zero
0010E50C 00003025 move       $a2, $zero
0010E510 0C01955C jal        0x65570
0010E514 34070001 ori        $a3, $zero, 1
0010E518 12400008 beqz       $s2, 0x10e53c
0010E51C 00000000 nop        
0010E520 92440045 lbu        $a0, 0x45($s2)
0010E524 28850004 slti       $a1, $a0, 4
0010E528 14A00004 bnez       $a1, 0x10e53c
0010E52C 288400FE slti       $a0, $a0, 0xfe
0010E530 10800002 beqz       $a0, 0x10e53c
0010E534 00000000 nop        
0010E538 A2400045 sb         $zero, 0x45($s2)
0010E53C 86C400F8 lh         $a0, 0xf8($s6)
0010E540 34050045 ori        $a1, $zero, 0x45
0010E544 1485000E bne        $a0, $a1, 0x10e580
0010E548 00000000 nop        
0010E54C A6C000FA sh         $zero, 0xfa($s6)
0010E550 4600D346 mov.s      $f13, $f26
0010E554 3404005B ori        $a0, $zero, 0x5b
0010E558 8EC60594 lw         $a2, 0x594($s6)
0010E55C AEC40360 sw         $a0, 0x360($s6)
0010E560 3C083E4C lui        $t0, 0x3e4c
0010E564 00C02025 move       $a0, $a2
0010E568 3508CCCD ori        $t0, $t0, 0xcccd
0010E56C 3405005B ori        $a1, $zero, 0x5b
0010E570 44886000 mtc1       $t0, $f12
0010E574 00003025 move       $a2, $zero
0010E578 0C01955C jal        0x65570
0010E57C 34070001 ori        $a3, $zero, 1
0010E580 E7DA00B4 swc1       $f26, 0xb4($fp)
0010E584 A3C000B9 sb         $zero, 0xb9($fp)
0010E588 27A400B0 addiu      $a0, $sp, 0xb0
0010E58C 0C00A9C4 jal        0x2a710
0010E590 02C02825 move       $a1, $s6
0010E594 8EC40594 lw         $a0, 0x594($s6)
0010E598 0C019487 jal        0x6521c
0010E59C 2410FFFF addiu      $s0, $zero, -1
0010E5A0 0C00A900 jal        0x2a400
0010E5A4 02C02025 move       $a0, $s6
0010E5A8 10400036 beqz       $v0, 0x10e684
0010E5AC 00000000 nop        
0010E5B0 C7CC0004 lwc1       $f12, 4($fp)
0010E5B4 461A6032 c.eq.s     $f12, $f26
0010E5B8 00000000 nop        
0010E5BC 45000025 bc1f       0x10e654
0010E5C0 00000000 nop        
0010E5C4 0C0070C3 jal        0x1c30c
0010E5C8 02C02025 move       $a0, $s6
0010E5CC 10400021 beqz       $v0, 0x10e654
0010E5D0 00000000 nop        
0010E5D4 8FA400B0 lw         $a0, 0xb0($sp)
0010E5D8 30840020 andi       $a0, $a0, 0x20
0010E5DC 1080001D beqz       $a0, 0x10e654
0010E5E0 00000000 nop        
0010E5E4 92440045 lbu        $a0, 0x45($s2)
0010E5E8 10800003 beqz       $a0, 0x10e5f8
0010E5EC 34050004 ori        $a1, $zero, 4
0010E5F0 14850018 bne        $a0, $a1, 0x10e654
0010E5F4 00000000 nop        
0010E5F8 26C400C0 addiu      $a0, $s6, 0xc0
0010E5FC 8C840014 lw         $a0, 0x14($a0)
0010E600 30842000 andi       $a0, $a0, 0x2000
0010E604 10800011 beqz       $a0, 0x10e64c
0010E608 00000000 nop        
0010E60C 34040001 ori        $a0, $zero, 1
0010E610 34100000 ori        $s0, $zero, 0
0010E614 16350004 bne        $s1, $s5, 0x10e628
0010E618 A3C400B8 sb         $a0, 0xb8($fp)
0010E61C 34040006 ori        $a0, $zero, 6
0010E620 1000000A b          0x10e64c
0010E624 A2440045 sb         $a0, 0x45($s2)
0010E628 86C400F8 lh         $a0, 0xf8($s6)
0010E62C 34050005 ori        $a1, $zero, 5
0010E630 14850004 bne        $a0, $a1, 0x10e644
0010E634 00000000 nop        
0010E638 3C04002A lui        $a0, 0x2a
0010E63C C48CD944 lwc1       $f12, -0x26bc($a0)
0010E640 E7CC00BC swc1       $f12, 0xbc($fp)
0010E644 34040004 ori        $a0, $zero, 4
0010E648 A2440045 sb         $a0, 0x45($s2)
0010E64C 1000000D b          0x10e684
0010E650 00000000 nop        
0010E654 C7CC00B4 lwc1       $f12, 0xb4($fp)
0010E658 3C04002A lui        $a0, 0x2a
0010E65C C48DD8A0 lwc1       $f13, -0x2760($a0)
0010E660 460D603E c.le.s     $f12, $f13
0010E664 00000000 nop        
0010E668 45010006 bc1t       0x10e684
0010E66C 00000000 nop        
0010E670 93C400B9 lbu        $a0, 0xb9($fp)
0010E674 10800003 beqz       $a0, 0x10e684
0010E678 00000000 nop        
0010E67C 34100001 ori        $s0, $zero, 1
0010E680 A3C000B8 sb         $zero, 0xb8($fp)
0010E684 C7CC00BC lwc1       $f12, 0xbc($fp)
0010E688 461A6032 c.eq.s     $f12, $f26
0010E68C 00000000 nop        
0010E690 4501000C bc1t       0x10e6c4
0010E694 00000000 nop        
0010E698 3C04BF80 lui        $a0, 0xbf80
0010E69C 44846800 mtc1       $a0, $f13
0010E6A0 460D6300 add.s      $f12, $f12, $f13
0010E6A4 461A603E c.le.s     $f12, $f26
0010E6A8 00000000 nop        
0010E6AC 45000004 bc1f       0x10e6c0
0010E6B0 E7CC00BC swc1       $f12, 0xbc($fp)
0010E6B4 E7DA00BC swc1       $f26, 0xbc($fp)
0010E6B8 10000002 b          0x10e6c4
0010E6BC 34100000 ori        $s0, $zero, 0
0010E6C0 2410FFFF addiu      $s0, $zero, -1
0010E6C4 2404FFFF addiu      $a0, $zero, -1
0010E6C8 12040011 beq        $s0, $a0, 0x10e710
0010E6CC 00000000 nop        
0010E6D0 0C00A900 jal        0x2a400
0010E6D4 02C02025 move       $a0, $s6
0010E6D8 1040000D beqz       $v0, 0x10e710
0010E6DC 00000000 nop        
0010E6E0 AFA00134 sw         $zero, 0x134($sp)
0010E6E4 27A60134 addiu      $a2, $sp, 0x134
0010E6E8 02402025 move       $a0, $s2
0010E6EC 02602825 move       $a1, $s3
0010E6F0 0C04353E jal        0x10d4f8
0010E6F4 02003825 move       $a3, $s0
0010E6F8 8FA80134 lw         $t0, 0x134($sp)
0010E6FC 27A60050 addiu      $a2, $sp, 0x50
0010E700 02402025 move       $a0, $s2
0010E704 02602825 move       $a1, $s3
0010E708 0C0434F0 jal        0x10d3c0
0010E70C 02003825 move       $a3, $s0
0010E710 0C03CE25 jal        0xf3894
0010E714 8FA40148 lw         $a0, 0x148($sp)
0010E718 C7B40154 lwc1       $f20, 0x154($sp)
0010E71C C7B60158 lwc1       $f22, 0x158($sp)
0010E720 C7B8015C lwc1       $f24, 0x15c($sp)
0010E724 C7BA0160 lwc1       $f26, 0x160($sp)
0010E728 8FB00164 lw         $s0, 0x164($sp)
0010E72C 8FB10168 lw         $s1, 0x168($sp)
0010E730 8FB2016C lw         $s2, 0x16c($sp)
0010E734 8FB30170 lw         $s3, 0x170($sp)
0010E738 8FB40174 lw         $s4, 0x174($sp)
0010E73C 8FB50178 lw         $s5, 0x178($sp)
0010E740 8FB6017C lw         $s6, 0x17c($sp)
0010E744 8FB70180 lw         $s7, 0x180($sp)
0010E748 8FBE0184 lw         $fp, 0x184($sp)
0010E74C 8FBF0188 lw         $ra, 0x188($sp)
0010E750 03E00008 jr         $ra
0010E754 27BD0190 addiu      $sp, $sp, 0x190