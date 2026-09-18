
CALLBACK 0x0011C044 end 0x0011C04C ordinal 0

0011C044 03E00008 jr         $ra
0011C048 34020001 ori        $v0, $zero, 1

CALLBACK 0x0011C04C end 0x0011C078 ordinal 1

0011C04C 27BDFFE0 addiu      $sp, $sp, -0x20
0011C050 8C840058 lw         $a0, 0x58($a0)
0011C054 8C850020 lw         $a1, 0x20($a0)
0011C058 AFBF0010 sw         $ra, 0x10($sp)
0011C05C 10A00003 beqz       $a1, 0x11c06c
0011C060 00000000 nop        
0011C064 0C017E49 jal        0x5f924
0011C068 24840024 addiu      $a0, $a0, 0x24
0011C06C 8FBF0010 lw         $ra, 0x10($sp)
0011C070 03E00008 jr         $ra
0011C074 27BD0020 addiu      $sp, $sp, 0x20

CALLBACK 0x0011C1E8 end 0x0011CCF8 ordinal 2

0011C1E8 27BDFF30 addiu      $sp, $sp, -0xd0
0011C1EC C48D0070 lwc1       $f13, 0x70($a0)
0011C1F0 3C053F80 lui        $a1, 0x3f80
0011C1F4 44856000 mtc1       $a1, $f12
0011C1F8 460C6B40 add.s      $f13, $f13, $f12
0011C1FC AFB100C0 sw         $s1, 0xc0($sp)
0011C200 8C910058 lw         $s1, 0x58($a0)
0011C204 E48D0070 swc1       $f13, 0x70($a0)
0011C208 8E260020 lw         $a2, 0x20($s1)
0011C20C 3C05002D lui        $a1, 0x2d
0011C210 24A5E3E8 addiu      $a1, $a1, -0x1c18
0011C214 00063080 sll        $a2, $a2, 2
0011C218 00C52821 addu       $a1, $a2, $a1
0011C21C 8CA50000 lw         $a1, ($a1)
0011C220 AFB000BC sw         $s0, 0xbc($sp)
0011C224 00808025 move       $s0, $a0
0011C228 44856000 mtc1       $a1, $f12
0011C22C E7B400B8 swc1       $f20, 0xb8($sp)
0011C230 AFB200C4 sw         $s2, 0xc4($sp)
0011C234 AFBF00C8 sw         $ra, 0xc8($sp)
0011C238 04A10004 bgez       $a1, 0x11c24c
0011C23C 46806320 cvt.s.w    $f12, $f12
0011C240 3C044F80 lui        $a0, 0x4f80
0011C244 44847000 mtc1       $a0, $f14
0011C248 460E6300 add.s      $f12, $f12, $f14
0011C24C 460C683C c.lt.s     $f13, $f12
0011C250 00000000 nop        
0011C254 45000008 bc1f       0x11c278
0011C258 00000000 nop        
0011C25C 92040045 lbu        $a0, 0x45($s0)
0011C260 5C80000A bgtzl      $a0, 0x11c28c
0011C264 28840002 slti       $a0, $a0, 2
0011C268 0483000C bgezl      $a0, 0x11c29c
0011C26C C60C0030 lwc1       $f12, 0x30($s0)
0011C270 1000029A b          0x11ccdc
0011C274 00000000 nop        
0011C278 02002025 move       $a0, $s0
0011C27C 0C01A8F0 jal        0x6a3c0
0011C280 34050001 ori        $a1, $zero, 1
0011C284 10000295 b          0x11ccdc
0011C288 00000000 nop        
0011C28C 1080FFF8 beqz       $a0, 0x11c270
0011C290 00000000 nop        
0011C294 10000237 b          0x11cb74
0011C298 00000000 nop        
0011C29C C60D0034 lwc1       $f13, 0x34($s0)
0011C2A0 E7AC0050 swc1       $f12, 0x50($sp)
0011C2A4 C60C0038 lwc1       $f12, 0x38($s0)
0011C2A8 E7AD0054 swc1       $f13, 0x54($sp)
0011C2AC C60D003C lwc1       $f13, 0x3c($s0)
0011C2B0 E7AC0058 swc1       $f12, 0x58($sp)
0011C2B4 E7AD005C swc1       $f13, 0x5c($sp)
0011C2B8 C634000C lwc1       $f20, 0xc($s1)
0011C2BC 27A40060 addiu      $a0, $sp, 0x60
0011C2C0 27A50070 addiu      $a1, $sp, 0x70
0011C2C4 4600A306 mov.s      $f12, $f20
0011C2C8 27A60050 addiu      $a2, $sp, 0x50
0011C2CC 02203825 move       $a3, $s1
0011C2D0 34080028 ori        $t0, $zero, 0x28
0011C2D4 00004825 move       $t1, $zero
0011C2D8 0C006D3C jal        0x1b4f0
0011C2DC 00005025 move       $t2, $zero
0011C2E0 5040001D beql       $v0, $zero, 0x11c358
0011C2E4 C62C0000 lwc1       $f12, ($s1)
0011C2E8 8FA40084 lw         $a0, 0x84($sp)
0011C2EC 34050002 ori        $a1, $zero, 2
0011C2F0 14850013 bne        $a0, $a1, 0x11c340
0011C2F4 00000000 nop        
0011C2F8 8FA40080 lw         $a0, 0x80($sp)
0011C2FC 34050001 ori        $a1, $zero, 1
0011C300 8C840040 lw         $a0, 0x40($a0)
0011C304 9084004B lbu        $a0, 0x4b($a0)
0011C308 50850013 beql       $a0, $a1, 0x11c358
0011C30C C62C0000 lwc1       $f12, ($s1)
0011C310 8FA40080 lw         $a0, 0x80($sp)
0011C314 34050005 ori        $a1, $zero, 5
0011C318 8C840040 lw         $a0, 0x40($a0)
0011C31C 9084004B lbu        $a0, 0x4b($a0)
0011C320 5085000D beql       $a0, $a1, 0x11c358
0011C324 C62C0000 lwc1       $f12, ($s1)
0011C328 8FA40080 lw         $a0, 0x80($sp)
0011C32C 34050002 ori        $a1, $zero, 2
0011C330 8C840040 lw         $a0, 0x40($a0)
0011C334 9084004B lbu        $a0, 0x4b($a0)
0011C338 50850007 beql       $a0, $a1, 0x11c358
0011C33C C62C0000 lwc1       $f12, ($s1)
0011C340 3C043F66 lui        $a0, 0x3f66
0011C344 C7B40060 lwc1       $f20, 0x60($sp)
0011C348 34846666 ori        $a0, $a0, 0x6666
0011C34C 44846000 mtc1       $a0, $f12
0011C350 460CA502 mul.s      $f20, $f20, $f12
0011C354 C62C0000 lwc1       $f12, ($s1)
0011C358 C7AD0050 lwc1       $f13, 0x50($sp)
0011C35C 460CA302 mul.s      $f12, $f20, $f12
0011C360 3C043F80 lui        $a0, 0x3f80
0011C364 E7AC0064 swc1       $f12, 0x64($sp)
0011C368 C62E0004 lwc1       $f14, 4($s1)
0011C36C 460C6B00 add.s      $f12, $f13, $f12
0011C370 460EA382 mul.s      $f14, $f20, $f14
0011C374 3C06002D lui        $a2, 0x2d
0011C378 E7AE0068 swc1       $f14, 0x68($sp)
0011C37C C62E0008 lwc1       $f14, 8($s1)
0011C380 460EA382 mul.s      $f14, $f20, $f14
0011C384 24C6E3E8 addiu      $a2, $a2, -0x1c18
0011C388 3C07002D lui        $a3, 0x2d
0011C38C E7AE006C swc1       $f14, 0x6c($sp)
0011C390 E62C0010 swc1       $f12, 0x10($s1)
0011C394 C7AC0054 lwc1       $f12, 0x54($sp)
0011C398 C7AD0068 lwc1       $f13, 0x68($sp)
0011C39C 44847000 mtc1       $a0, $f14
0011C3A0 460D6300 add.s      $f12, $f12, $f13
0011C3A4 3C04002D lui        $a0, 0x2d
0011C3A8 24E7E3B8 addiu      $a3, $a3, -0x1c48
0011C3AC 3C08002D lui        $t0, 0x2d
0011C3B0 E62C0014 swc1       $f12, 0x14($s1)
0011C3B4 C7AC0058 lwc1       $f12, 0x58($sp)
0011C3B8 C7AF006C lwc1       $f15, 0x6c($sp)
0011C3BC E62E001C swc1       $f14, 0x1c($s1)
0011C3C0 460F6300 add.s      $f12, $f12, $f15
0011C3C4 8E250020 lw         $a1, 0x20($s1)
0011C3C8 00054880 sll        $t1, $a1, 2
0011C3CC 01263021 addu       $a2, $t1, $a2
0011C3D0 E62C0018 swc1       $f12, 0x18($s1)
0011C3D4 C494E3F0 lwc1       $f20, -0x1c10($a0)
0011C3D8 8CC60000 lw         $a2, ($a2)
0011C3DC 01279021 addu       $s2, $t1, $a3
0011C3E0 44866000 mtc1       $a2, $f12
0011C3E4 27A50050 addiu      $a1, $sp, 0x50
0011C3E8 2504A368 addiu      $a0, $t0, -0x5c98
0011C3EC 46806320 cvt.s.w    $f12, $f12
0011C3F0 04C10004 bgez       $a2, 0x11c404
0011C3F4 8E520000 lw         $s2, ($s2)
0011C3F8 3C064F80 lui        $a2, 0x4f80
0011C3FC 44866800 mtc1       $a2, $f13
0011C400 460D6300 add.s      $f12, $f12, $f13
0011C404 34030003 ori        $v1, $zero, 3
0011C408 46006346 mov.s      $f13, $f12
0011C40C 340C000C ori        $t4, $zero, 0xc
0011C410 4600A306 mov.s      $f12, $f20
0011C414 AFA30000 sw         $v1, ($sp)
0011C418 34020001 ori        $v0, $zero, 1
0011C41C AFAC0004 sw         $t4, 4($sp)
0011C420 00803825 move       $a3, $a0
0011C424 AFA20008 sw         $v0, 8($sp)
0011C428 26260010 addiu      $a2, $s1, 0x10
0011C42C 34040001 ori        $a0, $zero, 1
0011C430 02404025 move       $t0, $s2
0011C434 02404825 move       $t1, $s2
0011C438 340A0001 ori        $t2, $zero, 1
0011C43C 340B0001 ori        $t3, $zero, 1
0011C440 0C032730 jal        0xc9cc0
0011C444 AFA2000C sw         $v0, 0xc($sp)
0011C448 00409025 move       $s2, $v0
0011C44C 5240000A beql       $s2, $zero, 0x11c478
0011C450 8E240020 lw         $a0, 0x20($s1)
0011C454 3C040012 lui        $a0, 0x12
0011C458 2484C078 addiu      $a0, $a0, -0x3f88
0011C45C 0C06B652 jal        0x1ad948
0011C460 AE440000 sw         $a0, ($s2)
0011C464 340400FF ori        $a0, $zero, 0xff
0011C468 0044001A div        $zero, $v0, $a0
0011C46C 00002010 mfhi       $a0
0011C470 A2440006 sb         $a0, 6($s2)
0011C474 8E240020 lw         $a0, 0x20($s1)
0011C478 3C06002D lui        $a2, 0x2d
0011C47C 00042080 sll        $a0, $a0, 2
0011C480 3C07002D lui        $a3, 0x2d
0011C484 24C6E3E8 addiu      $a2, $a2, -0x1c18
0011C488 24E7E3A8 addiu      $a3, $a3, -0x1c58
0011C48C 00863021 addu       $a2, $a0, $a2
0011C490 00879021 addu       $s2, $a0, $a3
0011C494 8CC60000 lw         $a2, ($a2)
0011C498 8E520000 lw         $s2, ($s2)
0011C49C 3C04002D lui        $a0, 0x2d
0011C4A0 44866000 mtc1       $a2, $f12
0011C4A4 C48DE3F4 lwc1       $f13, -0x1c0c($a0)
0011C4A8 46806320 cvt.s.w    $f12, $f12
0011C4AC 3C04002D lui        $a0, 0x2d
0011C4B0 27A50050 addiu      $a1, $sp, 0x50
0011C4B4 04C10004 bgez       $a2, 0x11c4c8
0011C4B8 2484A368 addiu      $a0, $a0, -0x5c98
0011C4BC 3C064F80 lui        $a2, 0x4f80
0011C4C0 44867000 mtc1       $a2, $f14
0011C4C4 460E6300 add.s      $f12, $f12, $f14
0011C4C8 34030001 ori        $v1, $zero, 1
0011C4CC 46006386 mov.s      $f14, $f12
0011C4D0 340C0026 ori        $t4, $zero, 0x26
0011C4D4 46006B06 mov.s      $f12, $f13
0011C4D8 AFA30000 sw         $v1, ($sp)
0011C4DC 46007346 mov.s      $f13, $f14
0011C4E0 34020001 ori        $v0, $zero, 1
0011C4E4 AFAC0004 sw         $t4, 4($sp)
0011C4E8 00803825 move       $a3, $a0
0011C4EC AFA20008 sw         $v0, 8($sp)
0011C4F0 26260010 addiu      $a2, $s1, 0x10
0011C4F4 00002025 move       $a0, $zero
0011C4F8 02404025 move       $t0, $s2
0011C4FC 02404825 move       $t1, $s2
0011C500 340A0001 ori        $t2, $zero, 1
0011C504 340B0001 ori        $t3, $zero, 1
0011C508 0C032730 jal        0xc9cc0
0011C50C AFA2000C sw         $v0, 0xc($sp)
0011C510 00409025 move       $s2, $v0
0011C514 5240000A beql       $s2, $zero, 0x11c540
0011C518 8E240020 lw         $a0, 0x20($s1)
0011C51C 3C040012 lui        $a0, 0x12
0011C520 2484C078 addiu      $a0, $a0, -0x3f88
0011C524 0C06B652 jal        0x1ad948
0011C528 AE440000 sw         $a0, ($s2)
0011C52C 340400FF ori        $a0, $zero, 0xff
0011C530 0044001A div        $zero, $v0, $a0
0011C534 00002010 mfhi       $a0
0011C538 A2440006 sb         $a0, 6($s2)
0011C53C 8E240020 lw         $a0, 0x20($s1)
0011C540 3C06002D lui        $a2, 0x2d
0011C544 00042080 sll        $a0, $a0, 2
0011C548 3C07002D lui        $a3, 0x2d
0011C54C 24C6E3E8 addiu      $a2, $a2, -0x1c18
0011C550 24E7E3A8 addiu      $a3, $a3, -0x1c58
0011C554 00863021 addu       $a2, $a0, $a2
0011C558 00879021 addu       $s2, $a0, $a3
0011C55C 8CC60000 lw         $a2, ($a2)
0011C560 8E520000 lw         $s2, ($s2)
0011C564 3C04002D lui        $a0, 0x2d
0011C568 44866000 mtc1       $a2, $f12
0011C56C C48DE3F4 lwc1       $f13, -0x1c0c($a0)
0011C570 46806320 cvt.s.w    $f12, $f12
0011C574 3C04002D lui        $a0, 0x2d
0011C578 27A50050 addiu      $a1, $sp, 0x50
0011C57C 04C10004 bgez       $a2, 0x11c590
0011C580 2484A368 addiu      $a0, $a0, -0x5c98
0011C584 3C064F80 lui        $a2, 0x4f80
0011C588 44867000 mtc1       $a2, $f14
0011C58C 460E6300 add.s      $f12, $f12, $f14
0011C590 34030001 ori        $v1, $zero, 1
0011C594 46006386 mov.s      $f14, $f12
0011C598 340C000C ori        $t4, $zero, 0xc
0011C59C 46006B06 mov.s      $f12, $f13
0011C5A0 AFA30000 sw         $v1, ($sp)
0011C5A4 46007346 mov.s      $f13, $f14
0011C5A8 34020001 ori        $v0, $zero, 1
0011C5AC AFAC0004 sw         $t4, 4($sp)
0011C5B0 00803825 move       $a3, $a0
0011C5B4 AFA20008 sw         $v0, 8($sp)
0011C5B8 26260010 addiu      $a2, $s1, 0x10
0011C5BC 00002025 move       $a0, $zero
0011C5C0 02404025 move       $t0, $s2
0011C5C4 02404825 move       $t1, $s2
0011C5C8 340A0001 ori        $t2, $zero, 1
0011C5CC 340B0001 ori        $t3, $zero, 1
0011C5D0 0C032730 jal        0xc9cc0
0011C5D4 AFA2000C sw         $v0, 0xc($sp)
0011C5D8 00409025 move       $s2, $v0
0011C5DC 5240000A beql       $s2, $zero, 0x11c608
0011C5E0 8E240020 lw         $a0, 0x20($s1)
0011C5E4 3C040012 lui        $a0, 0x12
0011C5E8 2484C078 addiu      $a0, $a0, -0x3f88
0011C5EC 0C06B652 jal        0x1ad948
0011C5F0 AE440000 sw         $a0, ($s2)
0011C5F4 340400FF ori        $a0, $zero, 0xff
0011C5F8 0044001A div        $zero, $v0, $a0
0011C5FC 00002010 mfhi       $a0
0011C600 A2440006 sb         $a0, 6($s2)
0011C604 8E240020 lw         $a0, 0x20($s1)
0011C608 3C06002D lui        $a2, 0x2d
0011C60C 00042080 sll        $a0, $a0, 2
0011C610 3C07002D lui        $a3, 0x2d
0011C614 24C6E3E8 addiu      $a2, $a2, -0x1c18
0011C618 24E7E3B0 addiu      $a3, $a3, -0x1c50
0011C61C 00863021 addu       $a2, $a0, $a2
0011C620 00879021 addu       $s2, $a0, $a3
0011C624 8CC60000 lw         $a2, ($a2)
0011C628 8E520000 lw         $s2, ($s2)
0011C62C 3C04002D lui        $a0, 0x2d
0011C630 44866000 mtc1       $a2, $f12
0011C634 C48DE3F4 lwc1       $f13, -0x1c0c($a0)
0011C638 46806320 cvt.s.w    $f12, $f12
0011C63C 3C04002D lui        $a0, 0x2d
0011C640 27A50050 addiu      $a1, $sp, 0x50
0011C644 04C10004 bgez       $a2, 0x11c658
0011C648 2484A368 addiu      $a0, $a0, -0x5c98
0011C64C 3C064F80 lui        $a2, 0x4f80
0011C650 44867000 mtc1       $a2, $f14
0011C654 460E6300 add.s      $f12, $f12, $f14
0011C658 34030001 ori        $v1, $zero, 1
0011C65C 46006386 mov.s      $f14, $f12
0011C660 340C000B ori        $t4, $zero, 0xb
0011C664 46006B06 mov.s      $f12, $f13
0011C668 AFA30000 sw         $v1, ($sp)
0011C66C 46007346 mov.s      $f13, $f14
0011C670 34020001 ori        $v0, $zero, 1
0011C674 AFAC0004 sw         $t4, 4($sp)
0011C678 00803825 move       $a3, $a0
0011C67C AFA20008 sw         $v0, 8($sp)
0011C680 26260010 addiu      $a2, $s1, 0x10
0011C684 34040001 ori        $a0, $zero, 1
0011C688 02404025 move       $t0, $s2
0011C68C 02404825 move       $t1, $s2
0011C690 340A0001 ori        $t2, $zero, 1
0011C694 340B0001 ori        $t3, $zero, 1
0011C698 0C032730 jal        0xc9cc0
0011C69C AFA2000C sw         $v0, 0xc($sp)
0011C6A0 00409025 move       $s2, $v0
0011C6A4 5240000A beql       $s2, $zero, 0x11c6d0
0011C6A8 8E240020 lw         $a0, 0x20($s1)
0011C6AC 3C040012 lui        $a0, 0x12
0011C6B0 2484C078 addiu      $a0, $a0, -0x3f88
0011C6B4 0C06B652 jal        0x1ad948
0011C6B8 AE440000 sw         $a0, ($s2)
0011C6BC 340400FF ori        $a0, $zero, 0xff
0011C6C0 0044001A div        $zero, $v0, $a0
0011C6C4 00002010 mfhi       $a0
0011C6C8 A2440006 sb         $a0, 6($s2)
0011C6CC 8E240020 lw         $a0, 0x20($s1)
0011C6D0 3C05002D lui        $a1, 0x2d
0011C6D4 3C06002D lui        $a2, 0x2d
0011C6D8 00042080 sll        $a0, $a0, 2
0011C6DC 24A5E3B0 addiu      $a1, $a1, -0x1c50
0011C6E0 00852821 addu       $a1, $a0, $a1
0011C6E4 24C6E3E8 addiu      $a2, $a2, -0x1c18
0011C6E8 3C076700 lui        $a3, 0x6700
0011C6EC 00862021 addu       $a0, $a0, $a2
0011C6F0 8CA50000 lw         $a1, ($a1)
0011C6F4 24E6FFFF addiu      $a2, $a3, -1
0011C6F8 8C870000 lw         $a3, ($a0)
0011C6FC 3C04002D lui        $a0, 0x2d
0011C700 C48CE3F4 lwc1       $f12, -0x1c0c($a0)
0011C704 44876800 mtc1       $a3, $f13
0011C708 3C04002D lui        $a0, 0x2d
0011C70C 46806B60 cvt.s.w    $f13, $f13
0011C710 27B20050 addiu      $s2, $sp, 0x50
0011C714 00A63024 and        $a2, $a1, $a2
0011C718 04E10004 bgez       $a3, 0x11c72c
0011C71C 2484A368 addiu      $a0, $a0, -0x5c98
0011C720 3C074F80 lui        $a3, 0x4f80
0011C724 44877000 mtc1       $a3, $f14
0011C728 460E6B40 add.s      $f13, $f13, $f14
0011C72C 00803825 move       $a3, $a0
0011C730 00A04825 move       $t1, $a1
0011C734 8E240020 lw         $a0, 0x20($s1)
0011C738 3C05002D lui        $a1, 0x2d
0011C73C 00042080 sll        $a0, $a0, 2
0011C740 24A5E3C8 addiu      $a1, $a1, -0x1c38
0011C744 00852021 addu       $a0, $a0, $a1
0011C748 34030001 ori        $v1, $zero, 1
0011C74C 8C8C0000 lw         $t4, ($a0)
0011C750 AFA30000 sw         $v1, ($sp)
0011C754 34020001 ori        $v0, $zero, 1
0011C758 AFAC0004 sw         $t4, 4($sp)
0011C75C 00C04025 move       $t0, $a2
0011C760 AFA20008 sw         $v0, 8($sp)
0011C764 26260010 addiu      $a2, $s1, 0x10
0011C768 34040001 ori        $a0, $zero, 1
0011C76C 02402825 move       $a1, $s2
0011C770 340A0001 ori        $t2, $zero, 1
0011C774 340B0001 ori        $t3, $zero, 1
0011C778 0C032730 jal        0xc9cc0
0011C77C AFA2000C sw         $v0, 0xc($sp)
0011C780 00409025 move       $s2, $v0
0011C784 5240000A beql       $s2, $zero, 0x11c7b0
0011C788 8E240020 lw         $a0, 0x20($s1)
0011C78C 3C040012 lui        $a0, 0x12
0011C790 2484C078 addiu      $a0, $a0, -0x3f88
0011C794 0C06B652 jal        0x1ad948
0011C798 AE440000 sw         $a0, ($s2)
0011C79C 340400FF ori        $a0, $zero, 0xff
0011C7A0 0044001A div        $zero, $v0, $a0
0011C7A4 00002010 mfhi       $a0
0011C7A8 A2440006 sb         $a0, 6($s2)
0011C7AC 8E240020 lw         $a0, 0x20($s1)
0011C7B0 3C05002D lui        $a1, 0x2d
0011C7B4 00042080 sll        $a0, $a0, 2
0011C7B8 24A5E3E8 addiu      $a1, $a1, -0x1c18
0011C7BC 00852021 addu       $a0, $a0, $a1
0011C7C0 8C840000 lw         $a0, ($a0)
0011C7C4 24840003 addiu      $a0, $a0, 3
0011C7C8 44846000 mtc1       $a0, $f12
0011C7CC 04810004 bgez       $a0, 0x11c7e0
0011C7D0 46806320 cvt.s.w    $f12, $f12
0011C7D4 3C044F80 lui        $a0, 0x4f80
0011C7D8 44846800 mtc1       $a0, $f13
0011C7DC 460D6300 add.s      $f12, $f12, $f13
0011C7E0 8E240020 lw         $a0, 0x20($s1)
0011C7E4 3C05002D lui        $a1, 0x2d
0011C7E8 00042080 sll        $a0, $a0, 2
0011C7EC 24A5E3E8 addiu      $a1, $a1, -0x1c18
0011C7F0 00852021 addu       $a0, $a0, $a1
0011C7F4 8C840000 lw         $a0, ($a0)
0011C7F8 2484FFFE addiu      $a0, $a0, -2
0011C7FC 44846800 mtc1       $a0, $f13
0011C800 04810004 bgez       $a0, 0x11c814
0011C804 46806B60 cvt.s.w    $f13, $f13
0011C808 3C044F80 lui        $a0, 0x4f80
0011C80C 44847000 mtc1       $a0, $f14
0011C810 460E6B40 add.s      $f13, $f13, $f14
0011C814 8E240020 lw         $a0, 0x20($s1)
0011C818 46006386 mov.s      $f14, $f12
0011C81C 3C06002D lui        $a2, 0x2d
0011C820 3C023FA6 lui        $v0, 0x3fa6
0011C824 00042880 sll        $a1, $a0, 2
0011C828 24C6E3C0 addiu      $a2, $a2, -0x1c40
0011C82C 00843821 addu       $a3, $a0, $a0
0011C830 34426666 ori        $v0, $v0, 0x6666
0011C834 46006BC6 mov.s      $f15, $f13
0011C838 00A62821 addu       $a1, $a1, $a2
0011C83C 44826000 mtc1       $v0, $f12
0011C840 00872021 addu       $a0, $a0, $a3
0011C844 44806800 mtc1       $zero, $f13
0011C848 8CA70000 lw         $a3, ($a1)
0011C84C 3C023E99 lui        $v0, 0x3e99
0011C850 46006CC6 mov.s      $f19, $f13
0011C854 3C05002D lui        $a1, 0x2d
0011C858 3442999A ori        $v0, $v0, 0x999a
0011C85C 00042080 sll        $a0, $a0, 2
0011C860 44828000 mtc1       $v0, $f16
0011C864 24A5E3D0 addiu      $a1, $a1, -0x1c30
0011C868 00852021 addu       $a0, $a0, $a1
0011C86C 3C02BD4C lui        $v0, 0xbd4c
0011C870 8C890000 lw         $t1, ($a0)
0011C874 34060000 ori        $a2, $zero, 0
0011C878 3442CCCD ori        $v0, $v0, 0xcccd
0011C87C 44828800 mtc1       $v0, $f17
0011C880 AFA60000 sw         $a2, ($sp)
0011C884 3C06002D lui        $a2, 0x2d
0011C888 3C023F80 lui        $v0, 0x3f80
0011C88C 340A0001 ori        $t2, $zero, 1
0011C890 44829000 mtc1       $v0, $f18
0011C894 340B0000 ori        $t3, $zero, 0
0011C898 26250010 addiu      $a1, $s1, 0x10
0011C89C 34040001 ori        $a0, $zero, 1
0011C8A0 34080003 ori        $t0, $zero, 3
0011C8A4 0C03297A jal        0xca5e8
0011C8A8 24C6A368 addiu      $a2, $a2, -0x5c98
0011C8AC 8E240020 lw         $a0, 0x20($s1)
0011C8B0 3C05002D lui        $a1, 0x2d
0011C8B4 00042080 sll        $a0, $a0, 2
0011C8B8 24A5E3E8 addiu      $a1, $a1, -0x1c18
0011C8BC 00852021 addu       $a0, $a0, $a1
0011C8C0 8C840000 lw         $a0, ($a0)
0011C8C4 24840003 addiu      $a0, $a0, 3
0011C8C8 44846000 mtc1       $a0, $f12
0011C8CC 04810004 bgez       $a0, 0x11c8e0
0011C8D0 46806320 cvt.s.w    $f12, $f12
0011C8D4 3C044F80 lui        $a0, 0x4f80
0011C8D8 44846800 mtc1       $a0, $f13
0011C8DC 460D6300 add.s      $f12, $f12, $f13
0011C8E0 8E240020 lw         $a0, 0x20($s1)
0011C8E4 3C05002D lui        $a1, 0x2d
0011C8E8 00042080 sll        $a0, $a0, 2
0011C8EC 24A5E3E8 addiu      $a1, $a1, -0x1c18
0011C8F0 00852021 addu       $a0, $a0, $a1
0011C8F4 8C840000 lw         $a0, ($a0)
0011C8F8 2484FFFE addiu      $a0, $a0, -2
0011C8FC 44846800 mtc1       $a0, $f13
0011C900 04810004 bgez       $a0, 0x11c914
0011C904 46806B60 cvt.s.w    $f13, $f13
0011C908 3C044F80 lui        $a0, 0x4f80
0011C90C 44847000 mtc1       $a0, $f14
0011C910 460E6B40 add.s      $f13, $f13, $f14
0011C914 8E240020 lw         $a0, 0x20($s1)
0011C918 46006386 mov.s      $f14, $f12
0011C91C 3C06002D lui        $a2, 0x2d
0011C920 00042880 sll        $a1, $a0, 2
0011C924 24C6E3B0 addiu      $a2, $a2, -0x1c50
0011C928 00843821 addu       $a3, $a0, $a0
0011C92C 46006BC6 mov.s      $f15, $f13
0011C930 00A62821 addu       $a1, $a1, $a2
0011C934 00872021 addu       $a0, $a0, $a3
0011C938 44806800 mtc1       $zero, $f13
0011C93C 8CA70000 lw         $a3, ($a1)
0011C940 46006C06 mov.s      $f16, $f13
0011C944 3C05002D lui        $a1, 0x2d
0011C948 46006CC6 mov.s      $f19, $f13
0011C94C 3C023F00 lui        $v0, 0x3f00
0011C950 00042080 sll        $a0, $a0, 2
0011C954 44826000 mtc1       $v0, $f12
0011C958 24A5E3D0 addiu      $a1, $a1, -0x1c30
0011C95C 00852021 addu       $a0, $a0, $a1
0011C960 3C02BD4C lui        $v0, 0xbd4c
0011C964 8C890004 lw         $t1, 4($a0)
0011C968 34060000 ori        $a2, $zero, 0
0011C96C 3442CCCD ori        $v0, $v0, 0xcccd
0011C970 44828800 mtc1       $v0, $f17
0011C974 AFA60000 sw         $a2, ($sp)
0011C978 3C06002D lui        $a2, 0x2d
0011C97C 3C023F80 lui        $v0, 0x3f80
0011C980 340A0001 ori        $t2, $zero, 1
0011C984 44829000 mtc1       $v0, $f18
0011C988 340B0000 ori        $t3, $zero, 0
0011C98C 26250010 addiu      $a1, $s1, 0x10
0011C990 00002025 move       $a0, $zero
0011C994 34080001 ori        $t0, $zero, 1
0011C998 0C03297A jal        0xca5e8
0011C99C 24C6A368 addiu      $a2, $a2, -0x5c98
0011C9A0 8E240020 lw         $a0, 0x20($s1)
0011C9A4 3C05002D lui        $a1, 0x2d
0011C9A8 00042080 sll        $a0, $a0, 2
0011C9AC 24A5E3E8 addiu      $a1, $a1, -0x1c18
0011C9B0 00852021 addu       $a0, $a0, $a1
0011C9B4 8C840000 lw         $a0, ($a0)
0011C9B8 24840003 addiu      $a0, $a0, 3
0011C9BC 44846000 mtc1       $a0, $f12
0011C9C0 04810004 bgez       $a0, 0x11c9d4
0011C9C4 46806320 cvt.s.w    $f12, $f12
0011C9C8 3C044F80 lui        $a0, 0x4f80
0011C9CC 44846800 mtc1       $a0, $f13
0011C9D0 460D6300 add.s      $f12, $f12, $f13
0011C9D4 8E240020 lw         $a0, 0x20($s1)
0011C9D8 3C05002D lui        $a1, 0x2d
0011C9DC 00042080 sll        $a0, $a0, 2
0011C9E0 24A5E3E8 addiu      $a1, $a1, -0x1c18
0011C9E4 00852021 addu       $a0, $a0, $a1
0011C9E8 8C840000 lw         $a0, ($a0)
0011C9EC 2484FFFE addiu      $a0, $a0, -2
0011C9F0 44846800 mtc1       $a0, $f13
0011C9F4 04810004 bgez       $a0, 0x11ca08
0011C9F8 46806B60 cvt.s.w    $f13, $f13
0011C9FC 3C044F80 lui        $a0, 0x4f80
0011CA00 44847000 mtc1       $a0, $f14
0011CA04 460E6B40 add.s      $f13, $f13, $f14
0011CA08 8E240020 lw         $a0, 0x20($s1)
0011CA0C 46006386 mov.s      $f14, $f12
0011CA10 3C06002D lui        $a2, 0x2d
0011CA14 3C023F4C lui        $v0, 0x3f4c
0011CA18 00042880 sll        $a1, $a0, 2
0011CA1C 24C6E3A8 addiu      $a2, $a2, -0x1c58
0011CA20 00843821 addu       $a3, $a0, $a0
0011CA24 3442CCCD ori        $v0, $v0, 0xcccd
0011CA28 00A62821 addu       $a1, $a1, $a2
0011CA2C 44826000 mtc1       $v0, $f12
0011CA30 00872021 addu       $a0, $a0, $a3
0011CA34 46006BC6 mov.s      $f15, $f13
0011CA38 8CA70000 lw         $a3, ($a1)
0011CA3C 4480A000 mtc1       $zero, $f20
0011CA40 3C023F19 lui        $v0, 0x3f19
0011CA44 4600A346 mov.s      $f13, $f20
0011CA48 3C05002D lui        $a1, 0x2d
0011CA4C 4600A4C6 mov.s      $f19, $f20
0011CA50 3442999A ori        $v0, $v0, 0x999a
0011CA54 00042080 sll        $a0, $a0, 2
0011CA58 44828000 mtc1       $v0, $f16
0011CA5C 24A5E3D0 addiu      $a1, $a1, -0x1c30
0011CA60 00852021 addu       $a0, $a0, $a1
0011CA64 3C02BD4C lui        $v0, 0xbd4c
0011CA68 8C890008 lw         $t1, 8($a0)
0011CA6C 34060000 ori        $a2, $zero, 0
0011CA70 3442CCCD ori        $v0, $v0, 0xcccd
0011CA74 44828800 mtc1       $v0, $f17
0011CA78 AFA60000 sw         $a2, ($sp)
0011CA7C 26320010 addiu      $s2, $s1, 0x10
0011CA80 3C06002D lui        $a2, 0x2d
0011CA84 3C023F80 lui        $v0, 0x3f80
0011CA88 340A0001 ori        $t2, $zero, 1
0011CA8C 44829000 mtc1       $v0, $f18
0011CA90 340B0000 ori        $t3, $zero, 0
0011CA94 00002025 move       $a0, $zero
0011CA98 02402825 move       $a1, $s2
0011CA9C 34080001 ori        $t0, $zero, 1
0011CAA0 0C03297A jal        0xca5e8
0011CAA4 24C6A368 addiu      $a2, $a2, -0x5c98
0011CAA8 C64C0000 lwc1       $f12, ($s2)
0011CAAC 3C043E99 lui        $a0, 0x3e99
0011CAB0 E7AC0088 swc1       $f12, 0x88($sp)
0011CAB4 C64C0004 lwc1       $f12, 4($s2)
0011CAB8 3484999A ori        $a0, $a0, 0x999a
0011CABC E7AC008C swc1       $f12, 0x8c($sp)
0011CAC0 C64C0008 lwc1       $f12, 8($s2)
0011CAC4 E7AC0090 swc1       $f12, 0x90($sp)
0011CAC8 44846000 mtc1       $a0, $f12
0011CACC E7AC0094 swc1       $f12, 0x94($sp)
0011CAD0 3C043F00 lui        $a0, 0x3f00
0011CAD4 44846000 mtc1       $a0, $f12
0011CAD8 E7AC0098 swc1       $f12, 0x98($sp)
0011CADC 8E240020 lw         $a0, 0x20($s1)
0011CAE0 4600A306 mov.s      $f12, $f20
0011CAE4 00042900 sll        $a1, $a0, 4
0011CAE8 00A42023 subu       $a0, $a1, $a0
0011CAEC 00042080 sll        $a0, $a0, 2
0011CAF0 00852023 subu       $a0, $a0, $a1
0011CAF4 3C05002D lui        $a1, 0x2d
0011CAF8 24A5E444 addiu      $a1, $a1, -0x1bbc
0011CAFC 4600A346 mov.s      $f13, $f20
0011CB00 00852021 addu       $a0, $a0, $a1
0011CB04 AFA4009C sw         $a0, 0x9c($sp)
0011CB08 8E240020 lw         $a0, 0x20($s1)
0011CB0C 3C05002D lui        $a1, 0x2d
0011CB10 00042080 sll        $a0, $a0, 2
0011CB14 24A5E43C addiu      $a1, $a1, -0x1bc4
0011CB18 00852021 addu       $a0, $a0, $a1
0011CB1C 8C840000 lw         $a0, ($a0)
0011CB20 27A50088 addiu      $a1, $sp, 0x88
0011CB24 0C0357C8 jal        0xd5f20
0011CB28 34060004 ori        $a2, $zero, 4
0011CB2C 8E240020 lw         $a0, 0x20($s1)
0011CB30 1080000C beqz       $a0, 0x11cb64
0011CB34 00000000 nop        
0011CB38 3C05002D lui        $a1, 0x2d
0011CB3C 3C08002D lui        $t0, 0x2d
0011CB40 26240024 addiu      $a0, $s1, 0x24
0011CB44 26060030 addiu      $a2, $s0, 0x30
0011CB48 26270010 addiu      $a3, $s1, 0x10
0011CB4C 24A5E3F8 addiu      $a1, $a1, -0x1c08
0011CB50 0C017E1D jal        0x5f874
0011CB54 2508A378 addiu      $t0, $t0, -0x5c88
0011CB58 34040001 ori        $a0, $zero, 1
0011CB5C 10000003 b          0x11cb6c
0011CB60 A2040045 sb         $a0, 0x45($s0)
0011CB64 34040002 ori        $a0, $zero, 2
0011CB68 A2040045 sb         $a0, 0x45($s0)
0011CB6C 1000FDC0 b          0x11c270
0011CB70 00000000 nop        
0011CB74 C60C0070 lwc1       $f12, 0x70($s0)
0011CB78 3C044F00 lui        $a0, 0x4f00
0011CB7C 44846800 mtc1       $a0, $f13
0011CB80 460D603C c.lt.s     $f12, $f13
0011CB84 00000000 nop        
0011CB88 45020005 bc1fl      0x11cba0
0011CB8C C60C0070 lwc1       $f12, 0x70($s0)
0011CB90 C60C0070 lwc1       $f12, 0x70($s0)
0011CB94 4600630D trunc.w.s  $f12, $f12
0011CB98 10000008 b          0x11cbbc
0011CB9C 44046000 mfc1       $a0, $f12
0011CBA0 3C044F00 lui        $a0, 0x4f00
0011CBA4 44846800 mtc1       $a0, $f13
0011CBA8 460D6301 sub.s      $f12, $f12, $f13
0011CBAC 3C048000 lui        $a0, 0x8000
0011CBB0 4600630D trunc.w.s  $f12, $f12
0011CBB4 44056000 mfc1       $a1, $f12
0011CBB8 00A42021 addu       $a0, $a1, $a0
0011CBBC 30840001 andi       $a0, $a0, 1
0011CBC0 10800036 beqz       $a0, 0x11cc9c
0011CBC4 00000000 nop        
0011CBC8 8E240020 lw         $a0, 0x20($s1)
0011CBCC 3C05002D lui        $a1, 0x2d
0011CBD0 00042080 sll        $a0, $a0, 2
0011CBD4 24A5E3E8 addiu      $a1, $a1, -0x1c18
0011CBD8 00852021 addu       $a0, $a0, $a1
0011CBDC C60C0070 lwc1       $f12, 0x70($s0)
0011CBE0 8C840000 lw         $a0, ($a0)
0011CBE4 44846800 mtc1       $a0, $f13
0011CBE8 04810004 bgez       $a0, 0x11cbfc
0011CBEC 46806B60 cvt.s.w    $f13, $f13
0011CBF0 3C044F80 lui        $a0, 0x4f80
0011CBF4 44847000 mtc1       $a0, $f14
0011CBF8 460E6B40 add.s      $f13, $f13, $f14
0011CBFC 3C043F40 lui        $a0, 0x3f40
0011CC00 44847000 mtc1       $a0, $f14
0011CC04 460E6B42 mul.s      $f13, $f13, $f14
0011CC08 460D603C c.lt.s     $f12, $f13
0011CC0C 00000000 nop        
0011CC10 45000022 bc1f       0x11cc9c
0011CC14 26240010 addiu      $a0, $s1, 0x10
0011CC18 C48C0000 lwc1       $f12, ($a0)
0011CC1C 3C053E99 lui        $a1, 0x3e99
0011CC20 E7AC00A0 swc1       $f12, 0xa0($sp)
0011CC24 C48C0004 lwc1       $f12, 4($a0)
0011CC28 E7AC00A4 swc1       $f12, 0xa4($sp)
0011CC2C C48C0008 lwc1       $f12, 8($a0)
0011CC30 34A4999A ori        $a0, $a1, 0x999a
0011CC34 E7AC00A8 swc1       $f12, 0xa8($sp)
0011CC38 44846000 mtc1       $a0, $f12
0011CC3C E7AC00AC swc1       $f12, 0xac($sp)
0011CC40 3C043F00 lui        $a0, 0x3f00
0011CC44 44846000 mtc1       $a0, $f12
0011CC48 E7AC00B0 swc1       $f12, 0xb0($sp)
0011CC4C 8E240020 lw         $a0, 0x20($s1)
0011CC50 44806000 mtc1       $zero, $f12
0011CC54 00042900 sll        $a1, $a0, 4
0011CC58 00A42023 subu       $a0, $a1, $a0
0011CC5C 00042080 sll        $a0, $a0, 2
0011CC60 00852023 subu       $a0, $a0, $a1
0011CC64 3C05002D lui        $a1, 0x2d
0011CC68 24A5E444 addiu      $a1, $a1, -0x1bbc
0011CC6C 46006346 mov.s      $f13, $f12
0011CC70 00852021 addu       $a0, $a0, $a1
0011CC74 AFA400B4 sw         $a0, 0xb4($sp)
0011CC78 8E240020 lw         $a0, 0x20($s1)
0011CC7C 3C05002D lui        $a1, 0x2d
0011CC80 00042080 sll        $a0, $a0, 2
0011CC84 24A5E43C addiu      $a1, $a1, -0x1bc4
0011CC88 00852021 addu       $a0, $a0, $a1
0011CC8C 8C840000 lw         $a0, ($a0)
0011CC90 27A500A0 addiu      $a1, $sp, 0xa0
0011CC94 0C0357C8 jal        0xd5f20
0011CC98 34060001 ori        $a2, $zero, 1
0011CC9C 8E240020 lw         $a0, 0x20($s1)
0011CCA0 10800009 beqz       $a0, 0x11ccc8
0011CCA4 00000000 nop        
0011CCA8 0C017EB3 jal        0x5facc
0011CCAC 26240024 addiu      $a0, $s1, 0x24
0011CCB0 82240054 lb         $a0, 0x54($s1)
0011CCB4 38840003 xori       $a0, $a0, 3
0011CCB8 2C840001 sltiu      $a0, $a0, 1
0011CCBC 308400FF andi       $a0, $a0, 0xff
0011CCC0 14800003 bnez       $a0, 0x11ccd0
0011CCC4 00000000 nop        
0011CCC8 1000FD69 b          0x11c270
0011CCCC 00000000 nop        
0011CCD0 02002025 move       $a0, $s0
0011CCD4 0C01A8F0 jal        0x6a3c0
0011CCD8 34050001 ori        $a1, $zero, 1
0011CCDC C7B400B8 lwc1       $f20, 0xb8($sp)
0011CCE0 8FB000BC lw         $s0, 0xbc($sp)
0011CCE4 8FB100C0 lw         $s1, 0xc0($sp)
0011CCE8 8FB200C4 lw         $s2, 0xc4($sp)
0011CCEC 8FBF00C8 lw         $ra, 0xc8($sp)
0011CCF0 03E00008 jr         $ra
0011CCF4 27BD00D0 addiu      $sp, $sp, 0xd0