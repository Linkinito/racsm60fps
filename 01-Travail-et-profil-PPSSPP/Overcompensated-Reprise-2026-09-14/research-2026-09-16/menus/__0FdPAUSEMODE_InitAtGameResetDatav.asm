00017508 e0ffbd27 addiu      $sp, $sp, -0x20
0001750C 1000bfaf sw         $ra, 0x10($sp)
00017510 375e000c jal        0x178dc
00017514 03000434 ori        $a0, $zero, 3
00017518 0a00043c lui        $a0, 0xa
0001751C b8138424 addiu      $a0, $a0, 0x13b8
00017520 080080ac sw         $zero, 8($a0)
00017524 0c0080ac sw         $zero, 0xc($a0)
00017528 140080ac sw         $zero, 0x14($a0)
0001752C 100080ac sw         $zero, 0x10($a0)
00017530 040080ac sw         $zero, 4($a0)
00017534 180080a0 sb         $zero, 0x18($a0)
00017538 1c0080ac sw         $zero, 0x1c($a0)
0001753C 2d5d000c jal        0x174b4
00017540 200080ac sw         $zero, 0x20($a0)
00017544 1000bf8f lw         $ra, 0x10($sp)
00017548 0800e003 jr         $ra
0001754C 2000bd27 addiu      $sp, $sp, 0x20