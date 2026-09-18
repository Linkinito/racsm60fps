00089EC4 2c00043c lui        $a0, 0x2c
00089EC8 846c848c lw         $a0, 0x6c84($a0)
00089ECC 2b008010 beqz       $a0, 0x89f7c
00089ED0 00000000 nop        
00089ED4 2c00043c lui        $a0, 0x2c
00089ED8 a86c9024 addiu      $s0, $a0, 0x6ca8
00089EDC 8d9a020c jal        0xa6a34
00089EE0 25200002 move       $a0, $s0
00089EE4 b59a020c jal        0xa6ad4
00089EE8 25200002 move       $a0, $s0
00089EEC e772020c jal        0x9cb9c
00089EF0 00000000 nop        
00089EF4 4c73020c jal        0x9cd30
00089EF8 00000000 nop        
00089EFC b59a020c jal        0xa6ad4
00089F00 25200002 move       $a0, $s0

000ADD6C 25804000 move       $s0, $v0
000ADD70 bd14030c jal        0xc52f4
000ADD74 25200002 move       $a0, $s0
000ADD78 b514030c jal        0xc52d4
000ADD7C 00000000 nop        
000ADD80 2d00043c lui        $a0, 0x2d
000ADD84 8d9a020c jal        0xa6a34
000ADD88 bcf78424 addiu      $a0, $a0, -0x844
000ADD8C 2d00043c lui        $a0, 0x2d
000ADD90 8d9a020c jal        0xa6a34
000ADD94 e4f78424 addiu      $a0, $a0, -0x81c
000ADD98 6518030c jal        0xc6194
000ADD9C 25200002 move       $a0, $s0
000ADDA0 e225030c jal        0xc9788
000ADDA4 00000000 nop        
000ADDA8 b831040c jal        0x10c6e0

000ADD78 b514030c jal        0xc52d4
000ADD7C 00000000 nop        
000ADD80 2d00043c lui        $a0, 0x2d
000ADD84 8d9a020c jal        0xa6a34
000ADD88 bcf78424 addiu      $a0, $a0, -0x844
000ADD8C 2d00043c lui        $a0, 0x2d
000ADD90 8d9a020c jal        0xa6a34
000ADD94 e4f78424 addiu      $a0, $a0, -0x81c
000ADD98 6518030c jal        0xc6194
000ADD9C 25200002 move       $a0, $s0
000ADDA0 e225030c jal        0xc9788
000ADDA4 00000000 nop        
000ADDA8 b831040c jal        0x10c6e0
000ADDAC 00000000 nop        
000ADDB0 6472020c jal        0x9c990
000ADDB4 ffff0424 addiu      $a0, $zero, -1

000B2BDC 5400bf8f lw         $ra, 0x54($sp)
000B2BE0 0800e003 jr         $ra
000B2BE4 6000bd27 addiu      $sp, $sp, 0x60
000B2BE8 e0ffbd27 addiu      $sp, $sp, -0x20
000B2BEC 2d00043c lui        $a0, 0x2d
000B2BF0 1000bfaf sw         $ra, 0x10($sp)
000B2BF4 8d9a020c jal        0xa6a34
000B2BF8 50188424 addiu      $a0, $a0, 0x1850
000B2BFC f1c9020c jal        0xb27c4
000B2C00 00000000 nop        
000B2C04 1000bf8f lw         $ra, 0x10($sp)
000B2C08 0800e003 jr         $ra
000B2C0C 2000bd27 addiu      $sp, $sp, 0x20
000B2C10 f0ffbd27 addiu      $sp, $sp, -0x10
000B2C14 0000bfaf sw         $ra, ($sp)
000B2C18 6bca020c jal        0xb29ac

000B3078 02008010 beqz       $a0, 0xb3084
000B307C 00000434 ori        $a0, $zero, 0
000B3080 401924ae sw         $a0, 0x1940($s1)
000B3084 3ecb020c jal        0xb2cf8
000B3088 00000000 nop        
000B308C 2d00043c lui        $a0, 0x2d
000B3090 8d9a020c jal        0xa6a34
000B3094 60198424 addiu      $a0, $a0, 0x1960
000B3098 2d00043c lui        $a0, 0x2d
000B309C 8d9a020c jal        0xa6a34
000B30A0 88198424 addiu      $a0, $a0, 0x1988
000B30A4 31cc020c jal        0xb30c4
000B30A8 25200000 move       $a0, $zero
000B30AC 2000b08f lw         $s0, 0x20($sp)
000B30B0 2400b18f lw         $s1, 0x24($sp)
000B30B4 2800b28f lw         $s2, 0x28($sp)

000B3084 3ecb020c jal        0xb2cf8
000B3088 00000000 nop        
000B308C 2d00043c lui        $a0, 0x2d
000B3090 8d9a020c jal        0xa6a34
000B3094 60198424 addiu      $a0, $a0, 0x1960
000B3098 2d00043c lui        $a0, 0x2d
000B309C 8d9a020c jal        0xa6a34
000B30A0 88198424 addiu      $a0, $a0, 0x1988
000B30A4 31cc020c jal        0xb30c4
000B30A8 25200000 move       $a0, $zero
000B30AC 2000b08f lw         $s0, 0x20($sp)
000B30B0 2400b18f lw         $s1, 0x24($sp)
000B30B4 2800b28f lw         $s2, 0x28($sp)
000B30B8 2c00bf8f lw         $ra, 0x2c($sp)
000B30BC 0800e003 jr         $ra
000B30C0 3000bd27 addiu      $sp, $sp, 0x30

000B4264 04000010 b          0xb4278
000B4268 00000000 nop        
000B426C 25288000 move       $a1, $a0
000B4270 c6ae020c jal        0xabb18
000B4274 25202002 move       $a0, $s1
000B4278 2d00043c lui        $a0, 0x2d
000B427C 8d9a020c jal        0xa6a34
000B4280 bcf78424 addiu      $a0, $a0, -0x844
000B4284 1b000012 beqz       $s0, 0xb42f4
000B4288 00000000 nop        
000B428C d000048e lw         $a0, 0xd0($s0)
000B4290 18008010 beqz       $a0, 0xb42f4
000B4294 00000000 nop        
000B4298 ffff8724 addiu      $a3, $a0, -1
000B429C 2d00043c lui        $a0, 0x2d
000B42A0 681a87ac sw         $a3, 0x1a68($a0)

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

000BA7AC 02008010 beqz       $a0, 0xba7b8
000BA7B0 07000434 ori        $a0, $zero, 7
000BA7B4 783fe4ac sw         $a0, 0x3f78($a3)
000BA7B8 24a4020c jal        0xa9090
000BA7BC 01000434 ori        $a0, $zero, 1
000BA7C0 2d00043c lui        $a0, 0x2d
000BA7C4 8d9a020c jal        0xa6a34
000BA7C8 b03f8424 addiu      $a0, $a0, 0x3fb0
000BA7CC 2d00043c lui        $a0, 0x2d
000BA7D0 8d9a020c jal        0xa6a34
000BA7D4 d83f8424 addiu      $a0, $a0, 0x3fd8
000BA7D8 7000b08f lw         $s0, 0x70($sp)
000BA7DC 7400bf8f lw         $ra, 0x74($sp)
000BA7E0 0800e003 jr         $ra
000BA7E4 8000bd27 addiu      $sp, $sp, 0x80
000BA7E8 e0febd27 addiu      $sp, $sp, -0x120

000BA7B8 24a4020c jal        0xa9090
000BA7BC 01000434 ori        $a0, $zero, 1
000BA7C0 2d00043c lui        $a0, 0x2d
000BA7C4 8d9a020c jal        0xa6a34
000BA7C8 b03f8424 addiu      $a0, $a0, 0x3fb0
000BA7CC 2d00043c lui        $a0, 0x2d
000BA7D0 8d9a020c jal        0xa6a34
000BA7D4 d83f8424 addiu      $a0, $a0, 0x3fd8
000BA7D8 7000b08f lw         $s0, 0x70($sp)
000BA7DC 7400bf8f lw         $ra, 0x74($sp)
000BA7E0 0800e003 jr         $ra
000BA7E4 8000bd27 addiu      $sp, $sp, 0x80
000BA7E8 e0febd27 addiu      $sp, $sp, -0x120
000BA7EC 2d00043c lui        $a0, 0x2d
000BA7F0 6c3f848c lw         $a0, 0x3f6c($a0)
000BA7F4 2d00063c lui        $a2, 0x2d

000C1B6C 05000010 b          0xc1b84
000C1B70 0c7444ae sw         $a0, 0x740c($s2)
000C1B74 2a28a400 slt        $a1, $a1, $a0
000C1B78 0200a010 beqz       $a1, 0xc1b84
000C1B7C feff8424 addiu      $a0, $a0, -2
000C1B80 0c7444ae sw         $a0, 0x740c($s2)
000C1B84 8d9a020c jal        0xa6a34
000C1B88 25200002 move       $a0, $s0
000C1B8C 8d9a020c jal        0xa6a34
000C1B90 25202002 move       $a0, $s1
000C1B94 ef06030c jal        0xc1bbc
000C1B98 25200000 move       $a0, $zero
000C1B9C 3000b08f lw         $s0, 0x30($sp)
000C1BA0 3400b18f lw         $s1, 0x34($sp)
000C1BA4 3800b28f lw         $s2, 0x38($sp)
000C1BA8 3c00b38f lw         $s3, 0x3c($sp)

000C1B74 2a28a400 slt        $a1, $a1, $a0
000C1B78 0200a010 beqz       $a1, 0xc1b84
000C1B7C feff8424 addiu      $a0, $a0, -2
000C1B80 0c7444ae sw         $a0, 0x740c($s2)
000C1B84 8d9a020c jal        0xa6a34
000C1B88 25200002 move       $a0, $s0
000C1B8C 8d9a020c jal        0xa6a34
000C1B90 25202002 move       $a0, $s1
000C1B94 ef06030c jal        0xc1bbc
000C1B98 25200000 move       $a0, $zero
000C1B9C 3000b08f lw         $s0, 0x30($sp)
000C1BA0 3400b18f lw         $s1, 0x34($sp)
000C1BA4 3800b28f lw         $s2, 0x38($sp)
000C1BA8 3c00b38f lw         $s3, 0x3c($sp)
000C1BAC 4000b48f lw         $s4, 0x40($sp)
000C1BB0 4400bf8f lw         $ra, 0x44($sp)