
CALLBACK 0x0013A39C end 0x0013A3A4 ordinal 0

0013A39C 03E00008 jr         $ra
0013A3A0 34020001 ori        $v0, $zero, 1

CALLBACK 0x0013A3A4 end 0x0013A3AC ordinal 1

0013A3A4 03E00008 jr         $ra
0013A3A8 00000000 nop        

CALLBACK 0x0013A3AC end 0x0013A5F4 ordinal 2

0013A3AC 27BDFF30 addiu      $sp, $sp, -0xd0
0013A3B0 AFB000C0 sw         $s0, 0xc0($sp)
0013A3B4 00808025 move       $s0, $a0
0013A3B8 AFB100C4 sw         $s1, 0xc4($sp)
0013A3BC 8E110058 lw         $s1, 0x58($s0)
0013A3C0 C62D001C lwc1       $f13, 0x1c($s1)
0013A3C4 C62C0020 lwc1       $f12, 0x20($s1)
0013A3C8 460D6B82 mul.s      $f14, $f13, $f13
0013A3CC 460C6302 mul.s      $f12, $f12, $f12
0013A3D0 C62F0024 lwc1       $f15, 0x24($s1)
0013A3D4 460F7BC2 mul.s      $f15, $f15, $f15
0013A3D8 460C7300 add.s      $f12, $f14, $f12
0013A3DC 460F6300 add.s      $f12, $f12, $f15
0013A3E0 3C043F80 lui        $a0, 0x3f80
0013A3E4 E7B400BC swc1       $f20, 0xbc($sp)
0013A3E8 4484A000 mtc1       $a0, $f20
0013A3EC 46006304 sqrt.s     $f12, $f12
0013A3F0 460CA403 div.s      $f16, $f20, $f12
0013A3F4 460D8342 mul.s      $f13, $f16, $f13
0013A3F8 E7AD003C swc1       $f13, 0x3c($sp)
0013A3FC C62D0020 lwc1       $f13, 0x20($s1)
0013A400 460D8342 mul.s      $f13, $f16, $f13
0013A404 E7AD0040 swc1       $f13, 0x40($sp)
0013A408 C62D0024 lwc1       $f13, 0x24($s1)
0013A40C 27A40020 addiu      $a0, $sp, 0x20
0013A410 27A50024 addiu      $a1, $sp, 0x24
0013A414 460D8342 mul.s      $f13, $f16, $f13
0013A418 26060030 addiu      $a2, $s0, 0x30
0013A41C 27A7003C addiu      $a3, $sp, 0x3c
0013A420 34080028 ori        $t0, $zero, 0x28
0013A424 00004825 move       $t1, $zero
0013A428 00005025 move       $t2, $zero
0013A42C AFB200C8 sw         $s2, 0xc8($sp)
0013A430 AFBF00CC sw         $ra, 0xcc($sp)
0013A434 0C00654F jal        0x1953c
0013A438 E7AD0044 swc1       $f13, 0x44($sp)
0013A43C 10400046 beqz       $v0, 0x13a558
0013A440 00000000 nop        
0013A444 C62C001C lwc1       $f12, 0x1c($s1)
0013A448 C62D0020 lwc1       $f13, 0x20($s1)
0013A44C 460C6382 mul.s      $f14, $f12, $f12
0013A450 C62F0024 lwc1       $f15, 0x24($s1)
0013A454 460D6B42 mul.s      $f13, $f13, $f13
0013A458 460F7BC2 mul.s      $f15, $f15, $f15
0013A45C 460D7340 add.s      $f13, $f14, $f13
0013A460 460F6B40 add.s      $f13, $f13, $f15
0013A464 3C04002A lui        $a0, 0x2a
0013A468 46006B44 sqrt.s     $f13, $f13
0013A46C 460DA343 div.s      $f13, $f20, $f13
0013A470 C4909B10 lwc1       $f16, -0x64f0($a0)
0013A474 24849B10 addiu      $a0, $a0, -0x64f0
0013A478 C48E0004 lwc1       $f14, 4($a0)
0013A47C C48F0008 lwc1       $f15, 8($a0)
0013A480 C6110030 lwc1       $f17, 0x30($s0)
0013A484 C6120034 lwc1       $f18, 0x34($s0)
0013A488 C6130038 lwc1       $f19, 0x38($s0)
0013A48C 27A50058 addiu      $a1, $sp, 0x58
0013A490 460C6B02 mul.s      $f12, $f13, $f12
0013A494 E7AC0048 swc1       $f12, 0x48($sp)
0013A498 C6200020 lwc1       $f0, 0x20($s1)
0013A49C 460C7882 mul.s      $f2, $f15, $f12
0013A4A0 46006802 mul.s      $f0, $f13, $f0
0013A4A4 460C7302 mul.s      $f12, $f14, $f12
0013A4A8 E7A0004C swc1       $f0, 0x4c($sp)
0013A4AC 460078C2 mul.s      $f3, $f15, $f0
0013A4B0 C6210024 lwc1       $f1, 0x24($s1)
0013A4B4 E7B00068 swc1       $f16, 0x68($sp)
0013A4B8 46016B42 mul.s      $f13, $f13, $f1
0013A4BC E7AE006C swc1       $f14, 0x6c($sp)
0013A4C0 46008002 mul.s      $f0, $f16, $f0
0013A4C4 460D7102 mul.s      $f4, $f14, $f13
0013A4C8 E7AD0050 swc1       $f13, 0x50($sp)
0013A4CC 460C0301 sub.s      $f12, $f0, $f12
0013A4D0 E7AF0070 swc1       $f15, 0x70($sp)
0013A4D4 460D8342 mul.s      $f13, $f16, $f13
0013A4D8 460320C1 sub.s      $f3, $f4, $f3
0013A4DC E7AC0060 swc1       $f12, 0x60($sp)
0013A4E0 460E6042 mul.s      $f1, $f12, $f14
0013A4E4 460D1341 sub.s      $f13, $f2, $f13
0013A4E8 460F1942 mul.s      $f5, $f3, $f15
0013A4EC E7A30058 swc1       $f3, 0x58($sp)
0013A4F0 46106302 mul.s      $f12, $f12, $f16
0013A4F4 460E1B82 mul.s      $f14, $f3, $f14
0013A4F8 E7AD005C swc1       $f13, 0x5c($sp)
0013A4FC 460F6BC2 mul.s      $f15, $f13, $f15
0013A500 E7B10088 swc1       $f17, 0x88($sp)
0013A504 46056301 sub.s      $f12, $f12, $f5
0013A508 E7B2008C swc1       $f18, 0x8c($sp)
0013A50C 46106B42 mul.s      $f13, $f13, $f16
0013A510 46017BC1 sub.s      $f15, $f15, $f1
0013A514 E7AC007C swc1       $f12, 0x7c($sp)
0013A518 44806000 mtc1       $zero, $f12
0013A51C 460D7341 sub.s      $f13, $f14, $f13
0013A520 E7AF0078 swc1       $f15, 0x78($sp)
0013A524 E7B30090 swc1       $f19, 0x90($sp)
0013A528 E7AD0080 swc1       $f13, 0x80($sp)
0013A52C E7AC0064 swc1       $f12, 0x64($sp)
0013A530 E7AC0074 swc1       $f12, 0x74($sp)
0013A534 E7AC0084 swc1       $f12, 0x84($sp)
0013A538 E7B40094 swc1       $f20, 0x94($sp)
0013A53C 0C04E36B jal        0x138dac
0013A540 8E240000 lw         $a0, ($s1)
0013A544 02002025 move       $a0, $s0
0013A548 0C0192FF jal        0x64bfc
0013A54C 34050001 ori        $a1, $zero, 1
0013A550 10000021 b          0x13a5d8
0013A554 00000000 nop        
0013A558 27B20098 addiu      $s2, $sp, 0x98
0013A55C C62C0028 lwc1       $f12, 0x28($s1)
0013A560 26250010 addiu      $a1, $s1, 0x10
0013A564 0C03AC60 jal        0xeb180
0013A568 02402025 move       $a0, $s2
0013A56C 02002025 move       $a0, $s0
0013A570 02002825 move       $a1, $s0
0013A574 0C03BA8F jal        0xeea3c
0013A578 02403025 move       $a2, $s2
0013A57C C62C001C lwc1       $f12, 0x1c($s1)
0013A580 C62D0004 lwc1       $f13, 4($s1)
0013A584 C62E0020 lwc1       $f14, 0x20($s1)
0013A588 C62F0008 lwc1       $f15, 8($s1)
0013A58C 460D6300 add.s      $f12, $f12, $f13
0013A590 C6300024 lwc1       $f16, 0x24($s1)
0013A594 C631000C lwc1       $f17, 0xc($s1)
0013A598 460F7380 add.s      $f14, $f14, $f15
0013A59C 46118400 add.s      $f16, $f16, $f17
0013A5A0 E62C001C swc1       $f12, 0x1c($s1)
0013A5A4 E62E0020 swc1       $f14, 0x20($s1)
0013A5A8 E6300024 swc1       $f16, 0x24($s1)
0013A5AC C60E0030 lwc1       $f14, 0x30($s0)
0013A5B0 C60D0034 lwc1       $f13, 0x34($s0)
0013A5B4 460C7300 add.s      $f12, $f14, $f12
0013A5B8 C6100038 lwc1       $f16, 0x38($s0)
0013A5BC E60C0030 swc1       $f12, 0x30($s0)
0013A5C0 C62C0020 lwc1       $f12, 0x20($s1)
0013A5C4 460C6B00 add.s      $f12, $f13, $f12
0013A5C8 E60C0034 swc1       $f12, 0x34($s0)
0013A5CC C62C0024 lwc1       $f12, 0x24($s1)
0013A5D0 460C8300 add.s      $f12, $f16, $f12
0013A5D4 E60C0038 swc1       $f12, 0x38($s0)
0013A5D8 C7B400BC lwc1       $f20, 0xbc($sp)
0013A5DC 8FB000C0 lw         $s0, 0xc0($sp)
0013A5E0 8FB100C4 lw         $s1, 0xc4($sp)
0013A5E4 8FB200C8 lw         $s2, 0xc8($sp)
0013A5E8 8FBF00CC lw         $ra, 0xcc($sp)
0013A5EC 03E00008 jr         $ra
0013A5F0 27BD00D0 addiu      $sp, $sp, 0xd0