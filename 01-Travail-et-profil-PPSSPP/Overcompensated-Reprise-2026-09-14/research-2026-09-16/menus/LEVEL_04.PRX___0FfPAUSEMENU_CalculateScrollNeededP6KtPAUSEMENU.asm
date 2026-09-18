000AC2AC d0ffbd27 addiu      $sp, $sp, -0x30
000AC2B0 1000b0af sw         $s0, 0x10($sp)
000AC2B4 1800b2af sw         $s2, 0x18($sp)
000AC2B8 25808000 move       $s0, $a0
000AC2BC 00001234 ori        $s2, $zero, 0
000AC2C0 1400b1af sw         $s1, 0x14($sp)
000AC2C4 1c00b3af sw         $s3, 0x1c($sp)
000AC2C8 2000bfaf sw         $ra, 0x20($sp)
000AC2CC 81b0020c jal        0xac204
000AC2D0 0800118e lw         $s1, 8($s0)
000AC2D4 18002202 mult       $s1, $v0
000AC2D8 5000058e lw         $a1, 0x50($s0)
000AC2DC 12300000 mflo       $a2
000AC2E0 01003326 addiu      $s3, $s1, 1
000AC2E4 2128c500 addu       $a1, $a2, $a1
000AC2E8 25200002 move       $a0, $s0
000AC2EC 008c0500 sll        $s1, $a1, 0x10
000AC2F0 81b0020c jal        0xac204
000AC2F4 038c1100 sra        $s1, $s1, 0x10
000AC2F8 18006202 mult       $s3, $v0
000AC2FC 5000048e lw         $a0, 0x50($s0)
000AC300 8000078e lw         $a3, 0x80($s0)
000AC304 12400000 mflo       $t0
000AC308 8400058e lw         $a1, 0x84($s0)
000AC30C 00340700 sll        $a2, $a3, 0x10
000AC310 21200401 addu       $a0, $t0, $a0
000AC314 00440400 sll        $t0, $a0, 0x10
000AC318 03340600 sra        $a2, $a2, 0x10
000AC31C 00240500 sll        $a0, $a1, 0x10
000AC320 03440800 sra        $t0, $t0, 0x10
000AC324 2a482602 slt        $t1, $s1, $a2
000AC328 05002011 beqz       $t1, 0xac340
000AC32C 03240400 sra        $a0, $a0, 0x10
000AC330 23202602 subu       $a0, $s1, $a2
000AC334 00940400 sll        $s2, $a0, 0x10
000AC338 07000010 b          0xac358
000AC33C 03941200 sra        $s2, $s2, 0x10
000AC340 2a308800 slt        $a2, $a0, $t0
000AC344 0400c010 beqz       $a2, 0xac358
000AC348 00000000 nop        
000AC34C 23200401 subu       $a0, $t0, $a0
000AC350 00940400 sll        $s2, $a0, 0x10
000AC354 03941200 sra        $s2, $s2, 0x10
000AC358 05004012 beqz       $s2, 0xac370
000AC35C 00000000 nop        
000AC360 2120f200 addu       $a0, $a3, $s2
000AC364 800004ae sw         $a0, 0x80($s0)
000AC368 2120b200 addu       $a0, $a1, $s2
000AC36C 840004ae sw         $a0, 0x84($s0)
000AC370 25104002 move       $v0, $s2
000AC374 1000b08f lw         $s0, 0x10($sp)
000AC378 1400b18f lw         $s1, 0x14($sp)
000AC37C 1800b28f lw         $s2, 0x18($sp)
000AC380 1c00b38f lw         $s3, 0x1c($sp)
000AC384 2000bf8f lw         $ra, 0x20($sp)
000AC388 0800e003 jr         $ra
000AC38C 3000bd27 addiu      $sp, $sp, 0x30