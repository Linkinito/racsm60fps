
CALLBACK 0x0012C0C0 end 0x0012C128 ordinal 0

0012C0C0 27BDFFD0 addiu      $sp, $sp, -0x30
0012C0C4 AFB00020 sw         $s0, 0x20($sp)
0012C0C8 00808025 move       $s0, $a0
0012C0CC 8E040058 lw         $a0, 0x58($s0)
0012C0D0 AC800000 sw         $zero, ($a0)
0012C0D4 44806000 mtc1       $zero, $f12
0012C0D8 AC800004 sw         $zero, 4($a0)
0012C0DC E48C0008 swc1       $f12, 8($a0)
0012C0E0 3C080028 lui        $t0, 0x28
0012C0E4 24840010 addiu      $a0, $a0, 0x10
0012C0E8 00002825 move       $a1, $zero
0012C0EC 34060044 ori        $a2, $zero, 0x44
0012C0F0 34070045 ori        $a3, $zero, 0x45
0012C0F4 AFBF0024 sw         $ra, 0x24($sp)
0012C0F8 0C01859E jal        0x61678
0012C0FC 25082090 addiu      $t0, $t0, 0x2090
0012C100 8E040064 lw         $a0, 0x64($s0)
0012C104 3C050004 lui        $a1, 4
0012C108 A2000045 sb         $zero, 0x45($s0)
0012C10C 00852025 or         $a0, $a0, $a1
0012C110 AE040064 sw         $a0, 0x64($s0)
0012C114 34020001 ori        $v0, $zero, 1
0012C118 8FB00020 lw         $s0, 0x20($sp)
0012C11C 8FBF0024 lw         $ra, 0x24($sp)
0012C120 03E00008 jr         $ra
0012C124 27BD0030 addiu      $sp, $sp, 0x30

CALLBACK 0x0012C15C end 0x0012C164 ordinal 1

0012C15C 03E00008 jr         $ra
0012C160 00000000 nop        

CALLBACK 0x0012C1E4 end 0x0012C34C ordinal 2

0012C1E4 27BDFFB0 addiu      $sp, $sp, -0x50
0012C1E8 AFB00034 sw         $s0, 0x34($sp)
0012C1EC 8C900058 lw         $s0, 0x58($a0)
0012C1F0 90850045 lbu        $a1, 0x45($a0)
0012C1F4 E7B4002C swc1       $f20, 0x2c($sp)
0012C1F8 E7B60030 swc1       $f22, 0x30($sp)
0012C1FC AFB2003C sw         $s2, 0x3c($sp)
0012C200 4480B000 mtc1       $zero, $f22
0012C204 46006506 mov.s      $f20, $f12
0012C208 8E120000 lw         $s2, ($s0)
0012C20C 34060001 ori        $a2, $zero, 1
0012C210 AFB10038 sw         $s1, 0x38($sp)
0012C214 AFBF0040 sw         $ra, 0x40($sp)
0012C218 14A60010 bne        $a1, $a2, 0x12c25c
0012C21C 00808825 move       $s1, $a0
0012C220 02202025 move       $a0, $s1
0012C224 0C019491 jal        0x65244
0012C228 00002825 move       $a1, $zero
0012C22C 1040000B beqz       $v0, 0x12c25c
0012C230 00000000 nop        
0012C234 3C083DCC lui        $t0, 0x3dcc
0012C238 4600B346 mov.s      $f13, $f22
0012C23C 3508CCCD ori        $t0, $t0, 0xcccd
0012C240 02202025 move       $a0, $s1
0012C244 44886000 mtc1       $t0, $f12
0012C248 00002825 move       $a1, $zero
0012C24C 00003025 move       $a2, $zero
0012C250 0C01955C jal        0x65570
0012C254 34070001 ori        $a3, $zero, 1
0012C258 A2200045 sb         $zero, 0x45($s1)
0012C25C C60C0008 lwc1       $f12, 8($s0)
0012C260 46166032 c.eq.s     $f12, $f22
0012C264 00000000 nop        
0012C268 45010016 bc1t       0x12c2c4
0012C26C 00000000 nop        
0012C270 AE000004 sw         $zero, 4($s0)
0012C274 8E04000C lw         $a0, 0xc($s0)
0012C278 1080000A beqz       $a0, 0x12c2a4
0012C27C 00000000 nop        
0012C280 264400C0 addiu      $a0, $s2, 0xc0
0012C284 8C840014 lw         $a0, 0x14($a0)
0012C288 30842000 andi       $a0, $a0, 0x2000
0012C28C 14800003 bnez       $a0, 0x12c29c
0012C290 00000000 nop        
0012C294 10000003 b          0x12c2a4
0012C298 AE00000C sw         $zero, 0xc($s0)
0012C29C 10000023 b          0x12c32c
0012C2A0 00000000 nop        
0012C2A4 46146301 sub.s      $f12, $f12, $f20
0012C2A8 4616603E c.le.s     $f12, $f22
0012C2AC 00000000 nop        
0012C2B0 45000002 bc1f       0x12c2bc
0012C2B4 E60C0008 swc1       $f12, 8($s0)
0012C2B8 E6160008 swc1       $f22, 8($s0)
0012C2BC 1000001B b          0x12c32c
0012C2C0 00000000 nop        
0012C2C4 02402025 move       $a0, $s2
0012C2C8 0C014880 jal        0x52200
0012C2CC 34050001 ori        $a1, $zero, 1
0012C2D0 AE020004 sw         $v0, 4($s0)
0012C2D4 0C00A900 jal        0x2a400
0012C2D8 02402025 move       $a0, $s2
0012C2DC 10400013 beqz       $v0, 0x12c32c
0012C2E0 00000000 nop        
0012C2E4 8E040004 lw         $a0, 4($s0)
0012C2E8 10800010 beqz       $a0, 0x12c32c
0012C2EC 00000000 nop        
0012C2F0 27B10020 addiu      $s1, $sp, 0x20
0012C2F4 02202825 move       $a1, $s1
0012C2F8 34060001 ori        $a2, $zero, 1
0012C2FC 0C019ACE jal        0x66b38
0012C300 00003825 move       $a3, $zero
0012C304 8E060004 lw         $a2, 4($s0)
0012C308 26100010 addiu      $s0, $s0, 0x10
0012C30C 02002025 move       $a0, $s0
0012C310 34050001 ori        $a1, $zero, 1
0012C314 0C0183F6 jal        0x60fd8
0012C318 34070001 ori        $a3, $zero, 1
0012C31C 02002025 move       $a0, $s0
0012C320 02202825 move       $a1, $s1
0012C324 0C018416 jal        0x61058
0012C328 00003025 move       $a2, $zero
0012C32C C7B4002C lwc1       $f20, 0x2c($sp)
0012C330 C7B60030 lwc1       $f22, 0x30($sp)
0012C334 8FB00034 lw         $s0, 0x34($sp)
0012C338 8FB10038 lw         $s1, 0x38($sp)
0012C33C 8FB2003C lw         $s2, 0x3c($sp)
0012C340 8FBF0040 lw         $ra, 0x40($sp)
0012C344 03E00008 jr         $ra
0012C348 27BD0050 addiu      $sp, $sp, 0x50