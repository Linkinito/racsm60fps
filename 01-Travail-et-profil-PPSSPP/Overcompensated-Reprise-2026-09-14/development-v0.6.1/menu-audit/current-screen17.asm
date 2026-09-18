000B71E0 e0ffbd27 addiu      $sp, $sp, -0x20
000B71E4 1000b0af sw         $s0, 0x10($sp)
000B71E8 1400b1af sw         $s1, 0x14($sp)
000B71EC 1800bfaf sw         $ra, 0x18($sp)
000B71F0 f3e0010c jal        0x783cc
000B71F4 106b0434 ori        $a0, $zero, 0x6b10
000B71F8 b26d020c jal        0x9b6c8
000B71FC 25804000 move       $s0, $v0
000B7200 3e004010 beqz       $v0, 0xb72fc
000B7204 00000000 nop        
000B7208 b6e0010c jal        0x782d8
000B720C 106b0434 ori        $a0, $zero, 0x6b10
000B7210 25884000 move       $s1, $v0
000B7214 c3e0010c jal        0x7830c
000B7218 106b0434 ori        $a0, $zero, 0x6b10
000B721C 10004cc4 lwc1       $f12, 0x10($v0)
000B7220 2d00043c lui        $a0, 0x2d
000B7224 38368dc4 lwc1       $f13, 0x3638($a0)
000B7228 14004ec4 lwc1       $f14, 0x14($v0)
000B722C 02630d46 mul.s      $f12, $f12, $f13
000B7230 2d00043c lui        $a0, 0x2d
000B7234 bc35858c lw         $a1, 0x35bc($a0)
000B7238 42730d46 mul.s      $f13, $f14, $f13
000B723C 0d630046 trunc.w.s  $f12, $f12
000B7240 4d6b0046 trunc.w.s  $f13, $f13
000B7244 00600644 mfc1       $a2, $f12
000B7248 00360600 sll        $a2, $a2, 0x18
000B724C 03360600 sra        $a2, $a2, 0x18
000B7250 2328a600 subu       $a1, $a1, $a2
000B7254 00680744 mfc1       $a3, $f13
000B7258 2d00063c lui        $a2, 0x2d
000B725C 003e0700 sll        $a3, $a3, 0x18
000B7260 c035c88c lw         $t0, 0x35c0($a2)
000B7264 033e0700 sra        $a3, $a3, 0x18
000B7268 bc3585ac sw         $a1, 0x35bc($a0)
000B726C 23280701 subu       $a1, $t0, $a3
000B7270 c035c5ac sw         $a1, 0x35c0($a2)
000B7274 bc358424 addiu      $a0, $a0, 0x35bc
000B7278 c4db020c jal        0xb6f10
000B727C c035c524 addiu      $a1, $a2, 0x35c0
000B7280 0400248e lw         $a0, 4($s1)
000B7284 00808530 andi       $a1, $a0, 0x8000
000B7288 0e00a010 beqz       $a1, 0xb72c4
000B728C 00000000 nop        
000B7290 2d00043c lui        $a0, 0x2d
000B7294 1c368cc4 lwc1       $f12, 0x361c($a0)
000B7298 2d00053c lui        $a1, 0x2d
000B729C 2036adc4 lwc1       $f13, 0x3620($a1)
000B72A0 2d00053c lui        $a1, 0x2d
000B72A4 40630d46 add.s      $f13, $f12, $f13
000B72A8 2436acc4 lwc1       $f12, 0x3624($a1)
000B72AC 3e680c46 c.le.s     $f13, $f12
000B72B0 00000000 nop        
000B72B4 11000145 bc1t       0xb72fc
000B72B8 1c368de4 swc1       $f13, 0x361c($a0)
000B72BC 0f000010 b          0xb72fc
000B72C0 1c368ce4 swc1       $f12, 0x361c($a0)
000B72C4 00208430 andi       $a0, $a0, 0x2000
000B72C8 0c008010 beqz       $a0, 0xb72fc
000B72CC 2d00043c lui        $a0, 0x2d
000B72D0 1c368cc4 lwc1       $f12, 0x361c($a0)
000B72D4 2d00053c lui        $a1, 0x2d
000B72D8 2036adc4 lwc1       $f13, 0x3620($a1)
000B72DC 2d00053c lui        $a1, 0x2d
000B72E0 41630d46 sub.s      $f13, $f12, $f13
000B72E4 2836acc4 lwc1       $f12, 0x3628($a1)
000B72E8 3c680c46 c.lt.s     $f13, $f12
000B72EC 00000000 nop        
000B72F0 02000045 bc1f       0xb72fc
000B72F4 1c368de4 swc1       $f13, 0x361c($a0)
000B72F8 1c368ce4 swc1       $f12, 0x361c($a0)
000B72FC 00100432 andi       $a0, $s0, 0x1000
000B7300 05008014 bnez       $a0, 0xb7318
000B7304 00000000 nop        
000B7308 986d020c jal        0x9b660
000B730C 00000000 nop        
000B7310 09004014 bnez       $v0, 0xb7338
000B7314 00000000 nop        
000B7318 24a4020c jal        0xa9090
000B731C 07000434 ori        $a0, $zero, 7
000B7320 24a4020c jal        0xa9090
000B7324 25200000 move       $a0, $zero
000B7328 32ba020c jal        0xae8c8
000B732C 03000434 ori        $a0, $zero, 3
000B7330 12000010 b          0xb737c
000B7334 00000000 nop        
000B7338 08000432 andi       $a0, $s0, 8
000B733C 08008010 beqz       $a0, 0xb7360
000B7340 00000000 nop        
000B7344 24a4020c jal        0xa9090
000B7348 07000434 ori        $a0, $zero, 7
000B734C 04000434 ori        $a0, $zero, 4
000B7350 ff51000c jal        0x147fc
000B7354 25280000 move       $a1, $zero
000B7358 08000010 b          0xb737c
000B735C 00000000 nop        
000B7360 00400432 andi       $a0, $s0, 0x4000
000B7364 05008010 beqz       $a0, 0xb737c
000B7368 00000000 nop        
000B736C 24a4020c jal        0xa9090
000B7370 06000434 ori        $a0, $zero, 6
000B7374 32ba020c jal        0xae8c8
000B7378 0f000434 ori        $a0, $zero, 0xf
000B737C 2d00043c lui        $a0, 0x2d
000B7380 8d9a020c jal        0xa6a34
000B7384 cc358424 addiu      $a0, $a0, 0x35cc
000B7388 2d00043c lui        $a0, 0x2d
000B738C f4359024 addiu      $s0, $a0, 0x35f4
000B7390 8d9a020c jal        0xa6a34
000B7394 25200002 move       $a0, $s0
000B7398 b59a020c jal        0xa6ad4
000B739C 25200002 move       $a0, $s0
000B73A0 1800043c lui        $a0, 0x18
000B73A4 5838848c lw         $a0, 0x3858($a0)
000B73A8 05000534 ori        $a1, $zero, 5
000B73AC 9963020c jal        0x98e64
000B73B0 25304000 move       $a2, $v0
000B73B4 1000b08f lw         $s0, 0x10($sp)
000B73B8 1400b18f lw         $s1, 0x14($sp)
000B73BC 1800bf8f lw         $ra, 0x18($sp)
000B73C0 0800e003 jr         $ra
000B73C4 2000bd27 addiu      $sp, $sp, 0x20
000B73C8 a0ffbd27 addiu      $sp, $sp, -0x60
000B73CC 00240400 sll        $a0, $a0, 0x10
000B73D0 4800b0af sw         $s0, 0x48($sp)
000B73D4 002c0500 sll        $a1, $a1, 0x10
000B73D8 03840400 sra        $s0, $a0, 0x10
000B73DC 4c00b1af sw         $s1, 0x4c($sp)
000B73E0 038c0500 sra        $s1, $a1, 0x10
000B73E4 1800043c lui        $a0, 0x18
000B73E8 c85b8524 addiu      $a1, $a0, 0x5bc8
000B73EC c85b8dc4 lwc1       $f13, 0x5bc8($a0)
000B73F0 4000b4e7 swc1       $f20, 0x40($sp)
000B73F4 4400b6e7 swc1       $f22, 0x44($sp)
000B73F8 5000bfaf sw         $ra, 0x50($sp)
000B73FC d9e5060c jal        0x1b9764
000B7400 0800acc4 lwc1       $f12, 8($a1)
000B7404 c93f043c lui        $a0, 0x3fc9
000B7408 db0f8434 ori        $a0, $a0, 0xfdb
000B740C 00608444 mtc1       $a0, $f12
000B7410 2d00043c lui        $a0, 0x2d
000B7414 1c368dc4 lwc1       $f13, 0x361c($a0)
000B7418 003f043c lui        $a0, 0x3f00
000B741C 00708444 mtc1       $a0, $f14
000B7420 00050c46 add.s      $f20, $f0, $f12
000B7424 2d00043c lui        $a0, 0x2d
000B7428 826d0e46 mul.s      $f22, $f13, $f14
000B742C b59a020c jal        0xa6ad4
000B7430 cc358424 addiu      $a0, $a0, 0x35cc
000B7434 2d00043c lui        $a0, 0x2d
000B7438 34368894 lhu        $t0, 0x3634($a0)
000B743C 06b30046 mov.s      $f12, $f22
000B7440 2e000434 ori        $a0, $zero, 0x2e
000B7444 46b30046 mov.s      $f13, $f22
000B7448 25280002 move       $a1, $s0
000B744C 86a30046 mov.s      $f14, $f20
000B7450 25302002 move       $a2, $s1
000B7454 25380001 move       $a3, $t0
000B7458 25484000 move       $t1, $v0
000B745C 25504000 move       $t2, $v0
000B7460 25584000 move       $t3, $v0
000B7464 6e7e020c jal        0x9f9b8
000B7468 0000a2af sw         $v0, ($sp)
000B746C f572020c jal        0x9cbd4
000B7470 00000000 nop        
000B7474 4000b4c7 lwc1       $f20, 0x40($sp)
000B7478 4400b6c7 lwc1       $f22, 0x44($sp)
000B747C 4800b08f lw         $s0, 0x48($sp)
000B7480 4c00b18f lw         $s1, 0x4c($sp)
000B7484 5000bf8f lw         $ra, 0x50($sp)
000B7488 0800e003 jr         $ra
000B748C 6000bd27 addiu      $sp, $sp, 0x60
000B7490 90ffbd27 addiu      $sp, $sp, -0x70
000B7494 25200000 move       $a0, $zero
000B7498 25280000 move       $a1, $zero
000B749C e0010634 ori        $a2, $zero, 0x1e0
000B74A0 10010734 ori        $a3, $zero, 0x110
000B74A4 4c00b4e7 swc1       $f20, 0x4c($sp)
000B74A8 5000b6e7 swc1       $f22, 0x50($sp)
000B74AC 5400b0af sw         $s0, 0x54($sp)
000B74B0 5800b1af sw         $s1, 0x58($sp)
000B74B4 5c00b2af sw         $s2, 0x5c($sp)
000B74B8 6000bfaf sw         $ra, 0x60($sp)
000B74BC 177b020c jal        0x9ec5c
000B74C0 10ff083c lui        $t0, 0xff10
000B74C4 b9040434 ori        $a0, $zero, 0x4b9
000B74C8 b683020c jal        0xa0ed8
000B74CC 25280000 move       $a1, $zero
000B74D0 ba040434 ori        $a0, $zero, 0x4ba
000B74D4 b683020c jal        0xa0ed8
000B74D8 25280000 move       $a1, $zero
000B74DC 00a08044 mtc1       $zero, $f20
000B74E0 33000434 ori        $a0, $zero, 0x33
000B74E4 ffff0524 addiu      $a1, $zero, -1
000B74E8 4485020c jal        0xa1510
000B74EC 06a30046 mov.s      $f12, $f20
000B74F0 3000b127 addiu      $s1, $sp, 0x30
000B74F4 06a30046 mov.s      $f12, $f20
000B74F8 c2010434 ori        $a0, $zero, 0x1c2
000B74FC f583020c jal        0xa0fd4
000B7500 25282002 move       $a1, $s1
000B7504 3000a48f lw         $a0, 0x30($sp)
000B7508 3400a58f lw         $a1, 0x34($sp)
000B750C 3800a68f lw         $a2, 0x38($sp)
000B7510 3c00a78f lw         $a3, 0x3c($sp)
000B7514 00240400 sll        $a0, $a0, 0x10
000B7518 002c0500 sll        $a1, $a1, 0x10
000B751C 00340600 sll        $a2, $a2, 0x10
000B7520 003c0700 sll        $a3, $a3, 0x10
000B7524 8cff083c lui        $t0, 0xff8c
000B7528 03240400 sra        $a0, $a0, 0x10
000B752C 032c0500 sra        $a1, $a1, 0x10
000B7530 03340600 sra        $a2, $a2, 0x10
000B7534 033c0700 sra        $a3, $a3, 0x10
000B7538 177b020c jal        0x9ec5c
000B753C 486f0825 addiu      $t0, $t0, 0x6f48
000B7540 6472020c jal        0x9c990
000B7544 ffff0424 addiu      $a0, $zero, -1
000B7548 c3010434 ori        $a0, $zero, 0x1c3
000B754C 06a30046 mov.s      $f12, $f20
000B7550 f583020c jal        0xa0fd4
000B7554 25282002 move       $a1, $s1
000B7558 b26d020c jal        0x9b6c8
000B755C 00000000 nop        
000B7560 25004010 beqz       $v0, 0xb75f8
000B7564 00000000 nop        
000B7568 2c00043c lui        $a0, 0x2c
000B756C 001d848c lw         $a0, 0x1d00($a0)
000B7570 25280000 move       $a1, $zero
000B7574 4e24040c jal        0x109138
000B7578 2c1c848c lw         $a0, 0x1c2c($a0)
000B757C 25804000 move       $s0, $v0
000B7580 10000012 beqz       $s0, 0xb75c4
000B7584 00000000 nop        
000B7588 6c72020c jal        0x9c9b0
000B758C 25200000 move       $a0, $zero
000B7590 3a8a020c jal        0xa28e8
000B7594 25202002 move       $a0, $s1
000B7598 3c00a58f lw         $a1, 0x3c($sp)
000B759C 00240200 sll        $a0, $v0, 0x10
000B75A0 002c0500 sll        $a1, $a1, 0x10
000B75A4 03240400 sra        $a0, $a0, 0x10
000B75A8 032c0500 sra        $a1, $a1, 0x10
000B75AC 9477020c jal        0x9de50
000B75B0 25300002 move       $a2, $s0
000B75B4 6c72020c jal        0x9c9b0
000B75B8 01000434 ori        $a0, $zero, 1
000B75BC 0e000010 b          0xb75f8
000B75C0 00000000 nop        
000B75C4 3a8a020c jal        0xa28e8
000B75C8 25202002 move       $a0, $s1
000B75CC 3c00a48f lw         $a0, 0x3c($sp)
000B75D0 002c0200 sll        $a1, $v0, 0x10
000B75D4 00240400 sll        $a0, $a0, 0x10
000B75D8 03940400 sra        $s2, $a0, 0x10
000B75DC 03840500 sra        $s0, $a1, 0x10
000B75E0 5227040c jal        0x109d48
000B75E4 da000434 ori        $a0, $zero, 0xda
000B75E8 25200002 move       $a0, $s0
000B75EC 25284002 move       $a1, $s2
000B75F0 9477020c jal        0x9de50
000B75F4 25304000 move       $a2, $v0
000B75F8 4000b4e7 swc1       $f20, 0x40($sp)
000B75FC 4400b4e7 swc1       $f20, 0x44($sp)
000B7600 4800a0a7 sh         $zero, 0x48($sp)
000B7604 b26d020c jal        0x9b6c8
000B7608 4a00a0a7 sh         $zero, 0x4a($sp)
000B760C 56004010 beqz       $v0, 0xb7768
000B7610 00000000 nop        
000B7614 986d020c jal        0x9b660
000B7618 00000000 nop        
000B761C 58004010 beqz       $v0, 0xb7780
000B7620 0400043c lui        $a0, 4
000B7624 c4689024 addiu      $s0, $a0, 0x68c4
000B7628 0400058e lw         $a1, 4($s0)
000B762C c468868c lw         $a2, 0x68c4($a0)
000B7630 ffffa430 andi       $a0, $a1, 0xffff
000B7634 0800078e lw         $a3, 8($s0)
000B7638 ffffc530 andi       $a1, $a2, 0xffff
000B763C 0c00098e lw         $t1, 0xc($s0)
000B7640 ffffe630 andi       $a2, $a3, 0xffff
000B7644 01000834 ori        $t0, $zero, 1
000B7648 0973020c jal        0x9cc24
000B764C ffff2731 andi       $a3, $t1, 0xffff
000B7650 1000048e lw         $a0, 0x10($s0)
000B7654 2d00053c lui        $a1, 0x2d
000B7658 00608444 mtc1       $a0, $f12
000B765C 1400048e lw         $a0, 0x14($s0)
000B7660 bc35a58c lw         $a1, 0x35bc($a1)
000B7664 00688444 mtc1       $a0, $f13
000B7668 2d00043c lui        $a0, 0x2d
000B766C 00708544 mtc1       $a1, $f14
000B7670 1c368fc4 lwc1       $f15, 0x361c($a0)
000B7674 a0738046 cvt.s.w    $f14, $f14
000B7678 2d00043c lui        $a0, 0x2d
000B767C 20638046 cvt.s.w    $f12, $f12
000B7680 c035848c lw         $a0, 0x35c0($a0)
000B7684 606b8046 cvt.s.w    $f13, $f13
000B7688 00808444 mtc1       $a0, $f16
000B768C 20848046 cvt.s.w    $f16, $f16
000B7690 0044043c lui        $a0, 0x4400
000B7694 82730f46 mul.s      $f14, $f14, $f15
000B7698 00888444 mtc1       $a0, $f17
000B769C 1800063c lui        $a2, 0x18
000B76A0 02840f46 mul.s      $f16, $f16, $f15
000B76A4 00630e46 add.s      $f12, $f12, $f14
000B76A8 5838c88c lw         $t0, 0x3858($a2)
000B76AC ff010234 ori        $v0, $zero, 0x1ff
000B76B0 406b1046 add.s      $f13, $f13, $f16
000B76B4 c27b1146 mul.s      $f15, $f15, $f17
000B76B8 0d630046 trunc.w.s  $f12, $f12
000B76BC ffff0324 addiu      $v1, $zero, -1
000B76C0 0000a2af sw         $v0, ($sp)
000B76C4 4d6b0046 trunc.w.s  $f13, $f13
000B76C8 25480000 move       $t1, $zero
000B76CC cd7b0046 trunc.w.s  $f15, $f15
000B76D0 25500000 move       $t2, $zero
000B76D4 00600444 mfc1       $a0, $f12
000B76D8 ff010b34 ori        $t3, $zero, 0x1ff
000B76DC 002c0400 sll        $a1, $a0, 0x10
000B76E0 00680444 mfc1       $a0, $f13
000B76E4 032c0500 sra        $a1, $a1, 0x10
000B76E8 00780744 mfc1       $a3, $f15
000B76EC 00340400 sll        $a2, $a0, 0x10
000B76F0 ffffe730 andi       $a3, $a3, 0xffff
000B76F4 25200001 move       $a0, $t0
000B76F8 03340600 sra        $a2, $a2, 0x10
000B76FC 2540e000 move       $t0, $a3
000B7700 ed7d020c jal        0x9f7b4
000B7704 0400a3af sw         $v1, 4($sp)
000B7708 dedb020c jal        0xb6f78
000B770C 00000000 nop        
000B7710 2d00063c lui        $a2, 0x2d
000B7714 2c36ccc4 lwc1       $f12, 0x362c($a2)
000B7718 2d00063c lui        $a2, 0x2d
000B771C 4000a427 addiu      $a0, $sp, 0x40
000B7720 4400a527 addiu      $a1, $sp, 0x44
000B7724 c270020c jal        0x9c308
000B7728 3036cdc4 lwc1       $f13, 0x3630($a2)
000B772C 4000acc7 lwc1       $f12, 0x40($sp)
000B7730 4400adc7 lwc1       $f13, 0x44($sp)
000B7734 4800a427 addiu      $a0, $sp, 0x48
000B7738 0adb020c jal        0xb6c28
000B773C 4a00a527 addiu      $a1, $sp, 0x4a
000B7740 4800a487 lh         $a0, 0x48($sp)
000B7744 4a00a587 lh         $a1, 0x4a($sp)
000B7748 0c000634 ori        $a2, $zero, 0xc
000B774C ffff0824 addiu      $t0, $zero, -1
000B7750 f2dc020c jal        0xb73c8
000B7754 00a0073c lui        $a3, 0xa000
000B7758 f572020c jal        0x9cbd4
000B775C 00000000 nop        
000B7760 07000010 b          0xb7780
000B7764 00000000 nop        
000B7768 5227040c jal        0x109d48
000B776C 1b020434 ori        $a0, $zero, 0x21b
000B7770 f0000434 ori        $a0, $zero, 0xf0
000B7774 88000534 ori        $a1, $zero, 0x88
000B7778 9477020c jal        0x9de50
000B777C 25304000 move       $a2, $v0
000B7780 c4010434 ori        $a0, $zero, 0x1c4
000B7784 06a30046 mov.s      $f12, $f20
000B7788 f583020c jal        0xa0fd4
000B778C 25282002 move       $a1, $s1
000B7790 3800a48f lw         $a0, 0x38($sp)
000B7794 3c00a58f lw         $a1, 0x3c($sp)
000B7798 00240400 sll        $a0, $a0, 0x10
000B779C 03840400 sra        $s0, $a0, 0x10
000B77A0 00240500 sll        $a0, $a1, 0x10
000B77A4 03940400 sra        $s2, $a0, 0x10
000B77A8 5227040c jal        0x109d48
000B77AC db000434 ori        $a0, $zero, 0xdb
000B77B0 25200002 move       $a0, $s0
000B77B4 25284002 move       $a1, $s2
000B77B8 2979020c jal        0x9e4a4
000B77BC 25304000 move       $a2, $v0
000B77C0 c5010434 ori        $a0, $zero, 0x1c5
000B77C4 06a30046 mov.s      $f12, $f20
000B77C8 f583020c jal        0xa0fd4
000B77CC 25282002 move       $a1, $s1
000B77D0 3000a48f lw         $a0, 0x30($sp)
000B77D4 3c00a58f lw         $a1, 0x3c($sp)
000B77D8 00240400 sll        $a0, $a0, 0x10
000B77DC 03840400 sra        $s0, $a0, 0x10
000B77E0 00240500 sll        $a0, $a1, 0x10
000B77E4 03940400 sra        $s2, $a0, 0x10
000B77E8 5227040c jal        0x109d48
000B77EC 6c010434 ori        $a0, $zero, 0x16c
000B77F0 25200002 move       $a0, $s0
000B77F4 25284002 move       $a1, $s2
000B77F8 3e75020c jal        0x9d4f8
000B77FC 25304000 move       $a2, $v0
000B7800 b9040434 ori        $a0, $zero, 0x4b9
000B7804 b683020c jal        0xa0ed8
000B7808 01000534 ori        $a1, $zero, 1
000B780C ba040434 ori        $a0, $zero, 0x4ba
000B7810 b683020c jal        0xa0ed8
000B7814 01000534 ori        $a1, $zero, 1
000B7818 803f093c lui        $t1, 0x3f80
000B781C 86a30046 mov.s      $f14, $f20
000B7820 00b08944 mtc1       $t1, $f22
000B7824 b9040434 ori        $a0, $zero, 0x4b9
000B7828 25280000 move       $a1, $zero
000B782C c6a30046 mov.s      $f15, $f20