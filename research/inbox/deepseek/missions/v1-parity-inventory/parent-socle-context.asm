
# RVA 00015140..00015340; file SHA256 d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571
00015140 2406FFFF addiu      $a2, $zero, -1
00015144 0C028ED4 jal        0xa3b50
00015148 24840204 addiu      $a0, $a0, 0x204
0001514C 9625A93E lhu        $a1, -0x56c2($s1)
00015150 34040080 ori        $a0, $zero, 0x80
00015154 0C0086EC jal        0x21bb0
00015158 00003025 move       $a2, $zero
0001515C 9624A93E lhu        $a0, -0x56c2($s1)
00015160 24840001 addiu      $a0, $a0, 1
00015164 A624A93E sh         $a0, -0x56c2($s1)
00015168 8FB00014 lw         $s0, 0x14($sp)
0001516C 8FB10018 lw         $s1, 0x18($sp)
00015170 8FBF001C lw         $ra, 0x1c($sp)
00015174 03E00008 jr         $ra
00015178 27BD0020 addiu      $sp, $sp, 0x20
0001517C 27BDFF50 addiu      $sp, $sp, -0xb0
00015180 34040001 ori        $a0, $zero, 1
00015184 3C05002B lui        $a1, 0x2b
00015188 E7B40090 swc1       $f20, 0x90($sp)
0001518C AFB00094 sw         $s0, 0x94($sp)
00015190 AFB10098 sw         $s1, 0x98($sp)
00015194 AFB2009C sw         $s2, 0x9c($sp)
00015198 AFB300A0 sw         $s3, 0xa0($sp)
0001519C AFBF00A4 sw         $ra, 0xa4($sp)
000151A0 0C0097E9 jal        0x25fa4
000151A4 A0A4A928 sb         $a0, -0x56d8($a1)
000151A8 0C00542F jal        0x150bc
000151AC 00000000 nop        
000151B0 0C00542D jal        0x150b4
000151B4 00000000 nop        
000151B8 0C005308 jal        0x14c20
000151BC 34040006 ori        $a0, $zero, 6
000151C0 3C110006 lui        $s1, 6
000151C4 2631E1E8 addiu      $s1, $s1, -0x1e18
000151C8 14400003 bnez       $v0, 0x151d8
000151CC 3C10002B lui        $s0, 0x2b
000151D0 0C01D515 jal        0x75454
000151D4 00000000 nop        
000151D8 0C01D59F jal        0x7567c
000151DC 34040001 ori        $a0, $zero, 1
000151E0 3C043D08 lui        $a0, 0x3d08
000151E4 34848889 ori        $a0, $a0, 0x8889
000151E8 0C0221DA jal        0x88768
000151EC 4484A000 mtc1       $a0, $f20
000151F0 0C0002B4 jal        0xad0
000151F4 00000000 nop        
000151F8 0C00B589 jal        0x2d624
000151FC 00000000 nop        
00015200 0C00BEDB jal        0x2fb6c
00015204 00000000 nop        
00015208 0C00B891 jal        0x2e244
0001520C 00000000 nop        
00015210 0C023705 jal        0x8dc14
00015214 00000000 nop        
00015218 0C021EA1 jal        0x87a84
0001521C 4600A306 mov.s      $f12, $f20
00015220 0C01F544 jal        0x7d510
00015224 00000000 nop        
00015228 0C005668 jal        0x159a0
0001522C 00000000 nop        
00015230 0C01ADFD jal        0x6b7f4
00015234 4600A306 mov.s      $f12, $f20
00015238 0C0094DD jal        0x25374
0001523C 00000000 nop        
00015240 0C03489A jal        0xd2268
00015244 00000000 nop        
00015248 0C024F22 jal        0x93c88
0001524C 00000000 nop        
00015250 0C01AEAE jal        0x6bab8
00015254 00000000 nop        
00015258 0C024F44 jal        0x93d10
0001525C 00000000 nop        
00015260 0C00BFFC jal        0x2fff0
00015264 4600A306 mov.s      $f12, $f20
00015268 0C01AD86 jal        0x6b618
0001526C 4600A306 mov.s      $f12, $f20
00015270 0C01B1B1 jal        0x6c6c4
00015274 00000000 nop        
00015278 00002025 move       $a0, $zero
0001527C 0C0232B4 jal        0x8cad0
00015280 3405001D ori        $a1, $zero, 0x1d
00015284 0C01F56E jal        0x7d5b8
00015288 00000000 nop        
0001528C 0C0002C6 jal        0xb18
00015290 00000000 nop        
00015294 0C00340B jal        0xd02c
00015298 00000000 nop        
0001529C 0C004911 jal        0x12444
000152A0 00000000 nop        
000152A4 0C00B899 jal        0x2e264
000152A8 00000000 nop        
000152AC 0C023736 jal        0x8dcd8
000152B0 00000000 nop        
000152B4 0C027774 jal        0x9ddd0
000152B8 00000000 nop        
000152BC 3C04002B lui        $a0, 0x2b
000152C0 9084A929 lbu        $a0, -0x56d7($a0)
000152C4 10800007 beqz       $a0, 0x152e4
000152C8 00000000 nop        
000152CC 3C040009 lui        $a0, 9
000152D0 2484C5C0 addiu      $a0, $a0, -0x3a40
000152D4 0C01FE44 jal        0x7f910
000152D8 00802825 move       $a1, $a0
000152DC 10000005 b          0x152f4
000152E0 00000000 nop        
000152E4 3C040006 lui        $a0, 6
000152E8 02202825 move       $a1, $s1
000152EC 0C01FE44 jal        0x7f910
000152F0 2484A838 addiu      $a0, $a0, -0x57c8
000152F4 0C0055E0 jal        0x15780
000152F8 00000000 nop        
000152FC 0C00036B jal        0xdac
00015300 00000000 nop        
00015304 27B20010 addiu      $s2, $sp, 0x10
00015308 27B30050 addiu      $s3, $sp, 0x50
0001530C 02402025 move       $a0, $s2
00015310 0C00929F jal        0x24a7c
00015314 02602825 move       $a1, $s3
00015318 02202025 move       $a0, $s1
0001531C 02402825 move       $a1, $s2
00015320 0C023739 jal        0x8dce4
00015324 02603025 move       $a2, $s3
00015328 0C01E056 jal        0x78158
0001532C 00000000 nop        
00015330 0C024F66 jal        0x93d98
00015334 00000000 nop        
00015338 0C01B9B5 jal        0x6e6d4
0001533C 00000000 nop        

# RVA 0002F900..0002FD60; file SHA256 d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571
0002F900 AC400040 sw         $zero, 0x40($v0)
0002F904 8E040594 lw         $a0, 0x594($s0)
0002F908 34050002 ori        $a1, $zero, 2
0002F90C A2050F96 sb         $a1, 0xf96($s0)
0002F910 AE040F98 sw         $a0, 0xf98($s0)
0002F914 AE000F9C sw         $zero, 0xf9c($s0)
0002F918 AE000F88 sw         $zero, 0xf88($s0)
0002F91C 3C04002B lui        $a0, 0x2b
0002F920 8C84F280 lw         $a0, -0xd80($a0)
0002F924 10800024 beqz       $a0, 0x2f9b8
0002F928 00000000 nop        
0002F92C 0C00892E jal        0x224b8
0002F930 8C841C34 lw         $a0, 0x1c34($a0)
0002F934 00402025 move       $a0, $v0
0002F938 10800010 beqz       $a0, 0x2f97c
0002F93C 00000000 nop        
0002F940 8C840000 lw         $a0, ($a0)
0002F944 AE040F80 sw         $a0, 0xf80($s0)
0002F948 3C04002B lui        $a0, 0x2b
0002F94C C48C0118 lwc1       $f12, 0x118($a0)
0002F950 44806800 mtc1       $zero, $f13
0002F954 460D6032 c.eq.s     $f12, $f13
0002F958 00000000 nop        
0002F95C 45000014 bc1f       0x2f9b0
0002F960 00000000 nop        
0002F964 8E050F80 lw         $a1, 0xf80($s0)
0002F968 02002025 move       $a0, $s0
0002F96C 0C00D604 jal        0x35810
0002F970 34060001 ori        $a2, $zero, 1
0002F974 1000000E b          0x2f9b0
0002F978 00000000 nop        
0002F97C AE000F80 sw         $zero, 0xf80($s0)
0002F980 3C05002B lui        $a1, 0x2b
0002F984 24A50545 addiu      $a1, $a1, 0x545
0002F988 3C06001C lui        $a2, 0x1c
0002F98C 24C61010 addiu      $a2, $a2, 0x1010
0002F990 3C08001C lui        $t0, 0x1c
0002F994 25081078 addiu      $t0, $t0, 0x1078
0002F998 34040001 ori        $a0, $zero, 1
0002F99C 0C03B04D jal        0xec134
0002F9A0 34070335 ori        $a3, $zero, 0x335
0002F9A4 3C04001C lui        $a0, 0x1c
0002F9A8 0C03B058 jal        0xec160
0002F9AC 2484107C addiu      $a0, $a0, 0x107c
0002F9B0 1000000D b          0x2f9e8
0002F9B4 00000000 nop        
0002F9B8 3C05002B lui        $a1, 0x2b
0002F9BC 24A50545 addiu      $a1, $a1, 0x545
0002F9C0 3C06001C lui        $a2, 0x1c
0002F9C4 24C61010 addiu      $a2, $a2, 0x1010
0002F9C8 3C08001C lui        $t0, 0x1c
0002F9CC 25081078 addiu      $t0, $t0, 0x1078
0002F9D0 34040002 ori        $a0, $zero, 2
0002F9D4 0C03B04D jal        0xec134
0002F9D8 3407033B ori        $a3, $zero, 0x33b
0002F9DC 3C04001C lui        $a0, 0x1c
0002F9E0 0C03B058 jal        0xec160
0002F9E4 248410E0 addiu      $a0, $a0, 0x10e0
0002F9E8 8FB00020 lw         $s0, 0x20($sp)
0002F9EC 8FBF0024 lw         $ra, 0x24($sp)
0002F9F0 03E00008 jr         $ra
0002F9F4 27BD0030 addiu      $sp, $sp, 0x30
0002F9F8 27BDFFE0 addiu      $sp, $sp, -0x20
0002F9FC AFBF0010 sw         $ra, 0x10($sp)
0002FA00 3C040006 lui        $a0, 6
0002FA04 0C00BDEB jal        0x2f7ac
0002FA08 2484A838 addiu      $a0, $a0, -0x57c8
0002FA0C 8FBF0010 lw         $ra, 0x10($sp)
0002FA10 03E00008 jr         $ra
0002FA14 27BD0020 addiu      $sp, $sp, 0x20
0002FA18 27BDFFE0 addiu      $sp, $sp, -0x20
0002FA1C AFB00010 sw         $s0, 0x10($sp)
0002FA20 AFBF0014 sw         $ra, 0x14($sp)
0002FA24 3C05002D lui        $a1, 0x2d
0002FA28 8CA5A0D0 lw         $a1, -0x5f30($a1)
0002FA2C 8CA60038 lw         $a2, 0x38($a1)
0002FA30 00808025 move       $s0, $a0
0002FA34 34090000 ori        $t1, $zero, 0
0002FA38 0126202B sltu       $a0, $t1, $a2
0002FA3C 10800010 beqz       $a0, 0x2fa80
0002FA40 00000000 nop        
0002FA44 8CA50034 lw         $a1, 0x34($a1)
0002FA48 3C073692 lui        $a3, 0x3692
0002FA4C 24E79224 addiu      $a3, $a3, -0x6ddc
0002FA50 34040000 ori        $a0, $zero, 0
0002FA54 00A04025 move       $t0, $a1
0002FA58 8D0A0030 lw         $t2, 0x30($t0)
0002FA5C 15470004 bne        $t2, $a3, 0x2fa70
0002FA60 25290001 addiu      $t1, $t1, 1
0002FA64 00A42821 addu       $a1, $a1, $a0
0002FA68 10000006 b          0x2fa84
0002FA6C 0005282B sltu       $a1, $zero, $a1
0002FA70 24840050 addiu      $a0, $a0, 0x50
0002FA74 0126502B sltu       $t2, $t1, $a2
0002FA78 1540FFF7 bnez       $t2, 0x2fa58
0002FA7C 25080050 addiu      $t0, $t0, 0x50
0002FA80 34050000 ori        $a1, $zero, 0
0002FA84 3C04002B lui        $a0, 0x2b
0002FA88 A08500C4 sb         $a1, 0xc4($a0)
0002FA8C 908400C4 lbu        $a0, 0xc4($a0)
0002FA90 10800003 beqz       $a0, 0x2faa0
0002FA94 00000000 nop        
0002FA98 0C058C8B jal        0x16322c
0002FA9C 02002025 move       $a0, $s0
0002FAA0 0C011E01 jal        0x47804
0002FAA4 02002025 move       $a0, $s0
0002FAA8 0C012F79 jal        0x4bde4
0002FAAC 02002025 move       $a0, $s0
0002FAB0 8FB00010 lw         $s0, 0x10($sp)
0002FAB4 8FBF0014 lw         $ra, 0x14($sp)
0002FAB8 03E00008 jr         $ra
0002FABC 27BD0020 addiu      $sp, $sp, 0x20
0002FAC0 27BDFFE0 addiu      $sp, $sp, -0x20
0002FAC4 AFB00010 sw         $s0, 0x10($sp)
0002FAC8 AFB10014 sw         $s1, 0x14($sp)
0002FACC AFBF0018 sw         $ra, 0x18($sp)
0002FAD0 3C040006 lui        $a0, 6
0002FAD4 0C00BE86 jal        0x2fa18
0002FAD8 2484A838 addiu      $a0, $a0, -0x57c8
0002FADC 0C012282 jal        0x48a08
0002FAE0 00000000 nop        
0002FAE4 3C040009 lui        $a0, 9
0002FAE8 2490CF10 addiu      $s0, $a0, -0x30f0
0002FAEC 8E04006C lw         $a0, 0x6c($s0)
0002FAF0 00042400 sll        $a0, $a0, 0x10
0002FAF4 3C05A000 lui        $a1, 0xa000
0002FAF8 24B110C1 addiu      $s1, $a1, 0x10c1
0002FAFC 00912025 or         $a0, $a0, $s1
0002FB00 0C037489 jal        0xdd224
0002FB04 00000000 nop        
0002FB08 3C04002B lui        $a0, 0x2b
0002FB0C AC820178 sw         $v0, 0x178($a0)
0002FB10 8E04002C lw         $a0, 0x2c($s0)
0002FB14 00042400 sll        $a0, $a0, 0x10
0002FB18 00912025 or         $a0, $a0, $s1
0002FB1C 0C037489 jal        0xdd224
0002FB20 00000000 nop        
0002FB24 3C04002B lui        $a0, 0x2b
0002FB28 AC82017C sw         $v0, 0x17c($a0)
0002FB2C 8E0400C0 lw         $a0, 0xc0($s0)
0002FB30 00042400 sll        $a0, $a0, 0x10
0002FB34 3C05A000 lui        $a1, 0xa000
0002FB38 24A51041 addiu      $a1, $a1, 0x1041
0002FB3C 00852025 or         $a0, $a0, $a1
0002FB40 0C037877 jal        0xde1dc
0002FB44 00000000 nop        
0002FB48 3C04002B lui        $a0, 0x2b
0002FB4C AC820174 sw         $v0, 0x174($a0)
0002FB50 0C00BD00 jal        0x2f400
0002FB54 00000000 nop        
0002FB58 8FB00010 lw         $s0, 0x10($sp)
0002FB5C 8FB10014 lw         $s1, 0x14($sp)
0002FB60 8FBF0018 lw         $ra, 0x18($sp)
0002FB64 03E00008 jr         $ra
0002FB68 27BD0020 addiu      $sp, $sp, 0x20
0002FB6C 27BDFFE0 addiu      $sp, $sp, -0x20
0002FB70 AFBF0010 sw         $ra, 0x10($sp)
0002FB74 3C040006 lui        $a0, 6
0002FB78 0C016F0C jal        0x5bc30
0002FB7C 2484A838 addiu      $a0, $a0, -0x57c8
0002FB80 8FBF0010 lw         $ra, 0x10($sp)
0002FB84 03E00008 jr         $ra
0002FB88 27BD0020 addiu      $sp, $sp, 0x20
0002FB8C 27BDFF90 addiu      $sp, $sp, -0x70
0002FB90 E7B40044 swc1       $f20, 0x44($sp)
0002FB94 AFB00048 sw         $s0, 0x48($sp)
0002FB98 AFB1004C sw         $s1, 0x4c($sp)
0002FB9C AFB20050 sw         $s2, 0x50($sp)
0002FBA0 AFB30054 sw         $s3, 0x54($sp)
0002FBA4 AFB40058 sw         $s4, 0x58($sp)
0002FBA8 AFB5005C sw         $s5, 0x5c($sp)
0002FBAC AFB60060 sw         $s6, 0x60($sp)
0002FBB0 AFB70064 sw         $s7, 0x64($sp)
0002FBB4 AFBF0068 sw         $ra, 0x68($sp)
0002FBB8 00808025 move       $s0, $a0
0002FBBC 46006506 mov.s      $f20, $f12
0002FBC0 3C04002B lui        $a0, 0x2b
0002FBC4 AC9000C0 sw         $s0, 0xc0($a0)
0002FBC8 44806000 mtc1       $zero, $f12
0002FBCC E7AC0020 swc1       $f12, 0x20($sp)
0002FBD0 3C04461C lui        $a0, 0x461c
0002FBD4 34844000 ori        $a0, $a0, 0x4000
0002FBD8 44846800 mtc1       $a0, $f13
0002FBDC E7AD0024 swc1       $f13, 0x24($sp)
0002FBE0 E7AC0028 swc1       $f12, 0x28($sp)
0002FBE4 8FA40020 lw         $a0, 0x20($sp)
0002FBE8 8FA50024 lw         $a1, 0x24($sp)
0002FBEC 8FA60028 lw         $a2, 0x28($sp)
0002FBF0 3C070009 lui        $a3, 9
0002FBF4 ACE4FB30 sw         $a0, -0x4d0($a3)
0002FBF8 24E4FB30 addiu      $a0, $a3, -0x4d0
0002FBFC AC850004 sw         $a1, 4($a0)
0002FC00 AC860008 sw         $a2, 8($a0)
0002FC04 8E040D90 lw         $a0, 0xd90($s0)
0002FC08 14800006 bnez       $a0, 0x2fc24
0002FC0C 00000000 nop        
0002FC10 8E040594 lw         $a0, 0x594($s0)
0002FC14 10800008 beqz       $a0, 0x2fc38
0002FC18 00000000 nop        
0002FC1C 1000000F b          0x2fc5c
0002FC20 00000000 nop        
0002FC24 8C850000 lw         $a1, ($a0)
0002FC28 00A0F809 jalr       $a1
0002FC2C 02002025 move       $a0, $s0
0002FC30 100000E3 b          0x2ffc0
0002FC34 00000000 nop        
0002FC38 8E0405AC lw         $a0, 0x5ac($s0)
0002FC3C 10800005 beqz       $a0, 0x2fc54
0002FC40 00000000 nop        
0002FC44 0C015760 jal        0x55d80
0002FC48 02002025 move       $a0, $s0
0002FC4C 10000003 b          0x2fc5c
0002FC50 00000000 nop        
0002FC54 100000DA b          0x2ffc0
0002FC58 00000000 nop        
0002FC5C 02002025 move       $a0, $s0
0002FC60 0C00D829 jal        0x360a4
0002FC64 4600A306 mov.s      $f12, $f20
0002FC68 C60C0A20 lwc1       $f12, 0xa20($s0)
0002FC6C E60C0F6C swc1       $f12, 0xf6c($s0)
0002FC70 C60C0A24 lwc1       $f12, 0xa24($s0)
0002FC74 E60C0F70 swc1       $f12, 0xf70($s0)
0002FC78 C60C0A28 lwc1       $f12, 0xa28($s0)
0002FC7C E60C0F74 swc1       $f12, 0xf74($s0)
0002FC80 8E04095C lw         $a0, 0x95c($s0)
0002FC84 30848000 andi       $a0, $a0, 0x8000
0002FC88 3C130040 lui        $s3, 0x40
0002FC8C 3C14FFC0 lui        $s4, 0xffc0
0002FC90 2694FFFF addiu      $s4, $s4, -1
0002FC94 27B5002C addiu      $s5, $sp, 0x2c
0002FC98 27B60038 addiu      $s6, $sp, 0x38
0002FC9C 3C170006 lui        $s7, 6
0002FCA0 10800029 beqz       $a0, 0x2fd48
0002FCA4 26F7E228 addiu      $s7, $s7, -0x1dd8
0002FCA8 34110000 ori        $s1, $zero, 0
0002FCAC 3C12002B lui        $s2, 0x2b
0002FCB0 2E240001 sltiu      $a0, $s1, 1
0002FCB4 A2440208 sb         $a0, 0x208($s2)
0002FCB8 0C00D4E9 jal        0x353a4
0002FCBC 02002025 move       $a0, $s0
0002FCC0 0C00C801 jal        0x32004
0002FCC4 02002025 move       $a0, $s0
0002FCC8 0C00EFFE jal        0x3bff8
0002FCCC 02002025 move       $a0, $s0
0002FCD0 0C00F223 jal        0x3c88c
0002FCD4 02002025 move       $a0, $s0
0002FCD8 0C00CA22 jal        0x32888
0002FCDC 02002025 move       $a0, $s0
0002FCE0 02002025 move       $a0, $s0
0002FCE4 0C00E6DD jal        0x39b74
0002FCE8 4600A306 mov.s      $f12, $f20
0002FCEC 02002025 move       $a0, $s0
0002FCF0 0C007AF1 jal        0x1ebc4
0002FCF4 4600A306 mov.s      $f12, $f20
0002FCF8 26310001 addiu      $s1, $s1, 1
0002FCFC 2A240002 slti       $a0, $s1, 2
0002FD00 1480FFEB bnez       $a0, 0x2fcb0
0002FD04 00000000 nop        
0002FD08 34040001 ori        $a0, $zero, 1
0002FD0C A2440208 sb         $a0, 0x208($s2)
0002FD10 0C00D659 jal        0x35964
0002FD14 02002025 move       $a0, $s0
0002FD18 10400005 beqz       $v0, 0x2fd30
0002FD1C 00000000 nop        
0002FD20 0C00D650 jal        0x35940
0002FD24 02002025 move       $a0, $s0
0002FD28 0C013CB4 jal        0x4f2d0
0002FD2C 02002025 move       $a0, $s0
0002FD30 8E040594 lw         $a0, 0x594($s0)
0002FD34 8C840064 lw         $a0, 0x64($a0)
0002FD38 00939824 and        $s3, $a0, $s3
0002FD3C 0013982B sltu       $s3, $zero, $s3
0002FD40 10000008 b          0x2fd64
0002FD44 8E04059C lw         $a0, 0x59c($s0)
0002FD48 0C00D4E9 jal        0x353a4
0002FD4C 02002025 move       $a0, $s0
0002FD50 8E040594 lw         $a0, 0x594($s0)
0002FD54 8C840064 lw         $a0, 0x64($a0)
0002FD58 00939824 and        $s3, $a0, $s3
0002FD5C 0013982B sltu       $s3, $zero, $s3

# RVA 00096600..000966C0; file SHA256 d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571
00096600 0C005308 jal        0x14c20
00096604 34040004 ori        $a0, $zero, 4
00096608 10400003 beqz       $v0, 0x96618
0009660C 00000000 nop        
00096610 12000003 beqz       $s0, 0x96620
00096614 00000000 nop        
00096618 34040001 ori        $a0, $zero, 1
0009661C A2846E50 sb         $a0, 0x6e50($s4)
00096620 92846E50 lbu        $a0, 0x6e50($s4)
00096624 10800010 beqz       $a0, 0x96668
00096628 00000000 nop        
0009662C 0C06FD09 jal        0x1bf424
00096630 00000000 nop        
00096634 3C10002B lui        $s0, 0x2b
00096638 0C06FD0B jal        0x1bf42c
0009663C 00000000 nop        
00096640 8E046E58 lw         $a0, 0x6e58($s0)
00096644 24840001 addiu      $a0, $a0, 1
00096648 14440003 bne        $v0, $a0, 0x96658
0009664C 00000000 nop        
00096650 0C06FD09 jal        0x1bf424
00096654 00000000 nop        
00096658 0C06FD0B jal        0x1bf42c
0009665C 00000000 nop        
00096660 10000003 b          0x96670
00096664 AE026E58 sw         $v0, 0x6e58($s0)
00096668 0C06FD2D jal        0x1bf4b4
0009666C 34040064 ori        $a0, $zero, 0x64
00096670 0C06DD20 jal        0x1b7480
00096674 00000000 nop        
00096678 AE226DF4 sw         $v0, 0x6df4($s1)
0009667C 8FB00010 lw         $s0, 0x10($sp)
00096680 8FB10014 lw         $s1, 0x14($sp)
00096684 8FB20018 lw         $s2, 0x18($sp)
00096688 8FB3001C lw         $s3, 0x1c($sp)
0009668C 8FB40020 lw         $s4, 0x20($sp)
00096690 8FBF0024 lw         $ra, 0x24($sp)
00096694 03E00008 jr         $ra
00096698 27BD0030 addiu      $sp, $sp, 0x30
0009669C 27BDFFE0 addiu      $sp, $sp, -0x20
000966A0 AFB10014 sw         $s1, 0x14($sp)
000966A4 00808825 move       $s1, $a0
000966A8 AFB00010 sw         $s0, 0x10($sp)
000966AC 00A08025 move       $s0, $a1
000966B0 8E240010 lw         $a0, 0x10($s1)
000966B4 8E250000 lw         $a1, ($s1)
000966B8 AFBF0018 sw         $ra, 0x18($sp)
000966BC 0C06DCD9 jal        0x1b7364

# RVA 0000E290..0000E400; file SHA256 d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571
0000E290 C4900000 lwc1       $f16, ($a0)
0000E294 46106301 sub.s      $f12, $f12, $f16
0000E298 460D6302 mul.s      $f12, $f12, $f13
0000E29C C4B10000 lwc1       $f17, ($a1)
0000E2A0 460E8B82 mul.s      $f14, $f17, $f14
0000E2A4 460E6301 sub.s      $f12, $f12, $f14
0000E2A8 E4AC0000 swc1       $f12, ($a1)
0000E2AC 460F603E c.le.s     $f12, $f15
0000E2B0 00000000 nop        
0000E2B4 45010004 bc1t       0xe2c8
0000E2B8 00000000 nop        
0000E2BC E4AF0000 swc1       $f15, ($a1)
0000E2C0 10000008 b          0xe2e4
0000E2C4 46007B06 mov.s      $f12, $f15
0000E2C8 46007B47 neg.s      $f13, $f15
0000E2CC 460D603C c.lt.s     $f12, $f13
0000E2D0 00000000 nop        
0000E2D4 45000003 bc1f       0xe2e4
0000E2D8 00000000 nop        
0000E2DC E4AD0000 swc1       $f13, ($a1)
0000E2E0 46006B06 mov.s      $f12, $f13
0000E2E4 C48D0000 lwc1       $f13, ($a0)
0000E2E8 460C6B00 add.s      $f12, $f13, $f12
0000E2EC 03E00008 jr         $ra
0000E2F0 E48C0000 swc1       $f12, ($a0)
0000E2F4 C4900000 lwc1       $f16, ($a0)
0000E2F8 46106301 sub.s      $f12, $f12, $f16
0000E2FC C4B10000 lwc1       $f17, ($a1)
0000E300 460D6302 mul.s      $f12, $f12, $f13
0000E304 460E8B82 mul.s      $f14, $f17, $f14
0000E308 460E6301 sub.s      $f12, $f12, $f14
0000E30C 460C8B00 add.s      $f12, $f17, $f12
0000E310 E4AC0000 swc1       $f12, ($a1)
0000E314 460F603E c.le.s     $f12, $f15
0000E318 00000000 nop        
0000E31C 45010004 bc1t       0xe330
0000E320 00000000 nop        
0000E324 E4AF0000 swc1       $f15, ($a1)
0000E328 10000008 b          0xe34c
0000E32C 46007B06 mov.s      $f12, $f15
0000E330 46007B47 neg.s      $f13, $f15
0000E334 460D603C c.lt.s     $f12, $f13
0000E338 00000000 nop        
0000E33C 45000003 bc1f       0xe34c
0000E340 00000000 nop        
0000E344 E4AD0000 swc1       $f13, ($a1)
0000E348 46006B06 mov.s      $f12, $f13
0000E34C C48D0000 lwc1       $f13, ($a0)
0000E350 460C6B00 add.s      $f12, $f13, $f12
0000E354 03E00008 jr         $ra
0000E358 E48C0000 swc1       $f12, ($a0)
0000E35C 27BDFFC0 addiu      $sp, $sp, -0x40
0000E360 E7B40020 swc1       $f20, 0x20($sp)
0000E364 E7B60024 swc1       $f22, 0x24($sp)
0000E368 E7B80028 swc1       $f24, 0x28($sp)
0000E36C E7BA002C swc1       $f26, 0x2c($sp)
0000E370 AFB00030 sw         $s0, 0x30($sp)
0000E374 AFB10034 sw         $s1, 0x34($sp)
0000E378 AFBF0038 sw         $ra, 0x38($sp)
0000E37C 46007D06 mov.s      $f20, $f15
0000E380 46007586 mov.s      $f22, $f14
0000E384 46006E06 mov.s      $f24, $f13
0000E388 46006686 mov.s      $f26, $f12
0000E38C 00A08025 move       $s0, $a1
0000E390 00808825 move       $s1, $a0
0000E394 0C0038A4 jal        0xe290
0000E398 00000000 nop        
0000E39C 02202025 move       $a0, $s1
0000E3A0 4600D306 mov.s      $f12, $f26
0000E3A4 02002825 move       $a1, $s0
0000E3A8 4600C346 mov.s      $f13, $f24
0000E3AC 4600B386 mov.s      $f14, $f22
0000E3B0 0C0038A4 jal        0xe290
0000E3B4 4600A3C6 mov.s      $f15, $f20
0000E3B8 C7B40020 lwc1       $f20, 0x20($sp)
0000E3BC C7B60024 lwc1       $f22, 0x24($sp)
0000E3C0 C7B80028 lwc1       $f24, 0x28($sp)
0000E3C4 C7BA002C lwc1       $f26, 0x2c($sp)
0000E3C8 8FB00030 lw         $s0, 0x30($sp)
0000E3CC 8FB10034 lw         $s1, 0x34($sp)
0000E3D0 8FBF0038 lw         $ra, 0x38($sp)
0000E3D4 03E00008 jr         $ra
0000E3D8 27BD0040 addiu      $sp, $sp, 0x40
0000E3DC C4910000 lwc1       $f17, ($a0)
0000E3E0 46116441 sub.s      $f17, $f12, $f17
0000E3E4 3C064049 lui        $a2, 0x4049
0000E3E8 34C60FDB ori        $a2, $a2, 0xfdb
0000E3EC 44868000 mtc1       $a2, $f16
0000E3F0 4610883E c.le.s     $f17, $f16
0000E3F4 00000000 nop        
0000E3F8 45010006 bc1t       0xe414
0000E3FC C4AC0000 lwc1       $f12, ($a1)

# RVA 0017B770..0017B7B0; file SHA256 d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571
0017B770 460C6B02 mul.s      $f12, $f13, $f12
0017B774 C48E0038 lwc1       $f14, 0x38($a0)
0017B778 44867800 mtc1       $a2, $f15
0017B77C 460C7300 add.s      $f12, $f14, $f12
0017B780 E48C0038 swc1       $f12, 0x38($a0)
0017B784 C4AC8608 lwc1       $f12, -0x79f8($a1)
0017B788 460F6303 div.s      $f12, $f12, $f15
0017B78C 3C044000 lui        $a0, 0x4000
0017B790 C64D008C lwc1       $f13, 0x8c($s2)
0017B794 44848000 mtc1       $a0, $f16
0017B798 46106302 mul.s      $f12, $f12, $f16
0017B79C 460C6B01 sub.s      $f12, $f13, $f12
0017B7A0 E64C008C swc1       $f12, 0x8c($s2)
0017B7A4 3C044015 lui        $a0, 0x4015
0017B7A8 34845555 ori        $a0, $a0, 0x5555
0017B7AC 44846000 mtc1       $a0, $f12
