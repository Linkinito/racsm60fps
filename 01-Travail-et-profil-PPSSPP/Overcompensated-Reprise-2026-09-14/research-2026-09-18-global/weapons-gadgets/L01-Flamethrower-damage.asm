0013BBEC 27BDFEE0 addiu      $sp, $sp, -0x120
0013BBF0 AFB30104 sw         $s3, 0x104($sp)
0013BBF4 00809825 move       $s3, $a0
0013BBF8 3C04002D lui        $a0, 0x2d
0013BBFC C48C1AFC lwc1       $f12, 0x1afc($a0)
0013BC00 3C06BF80 lui        $a2, 0xbf80
0013BC04 44866800 mtc1       $a2, $f13
0013BC08 460D6300 add.s      $f12, $f12, $f13
0013BC0C 8E650058 lw         $a1, 0x58($s3)
0013BC10 E7BC00F0 swc1       $f28, 0xf0($sp)
0013BC14 4480E000 mtc1       $zero, $f28
0013BC18 AFA500CC sw         $a1, 0xcc($sp)
0013BC1C E7B400E0 swc1       $f20, 0xe0($sp)
0013BC20 461C603E c.le.s     $f12, $f28
0013BC24 E7B600E4 swc1       $f22, 0xe4($sp)
0013BC28 E7B800E8 swc1       $f24, 0xe8($sp)
0013BC2C E7BA00EC swc1       $f26, 0xec($sp)
0013BC30 E7BE00F4 swc1       $f30, 0xf4($sp)
0013BC34 AFB000F8 sw         $s0, 0xf8($sp)
0013BC38 AFB100FC sw         $s1, 0xfc($sp)
0013BC3C AFB20100 sw         $s2, 0x100($sp)
0013BC40 AFB40108 sw         $s4, 0x108($sp)
0013BC44 AFB5010C sw         $s5, 0x10c($sp)
0013BC48 AFB60110 sw         $s6, 0x110($sp)
0013BC4C AFB70114 sw         $s7, 0x114($sp)
0013BC50 AFBE0118 sw         $fp, 0x118($sp)
0013BC54 AFBF011C sw         $ra, 0x11c($sp)
0013BC58 45000006 bc1f       0x13bc74
0013BC5C E48C1AFC swc1       $f12, 0x1afc($a0)
0013BC60 3C05002D lui        $a1, 0x2d
0013BC64 C4AC1AF8 lwc1       $f12, 0x1af8($a1)
0013BC68 3C05002D lui        $a1, 0x2d
0013BC6C 10000003 b          0x13bc7c
0013BC70 E48C1AFC swc1       $f12, 0x1afc($a0)
0013BC74 100001C6 b          0x13c390
0013BC78 00000000 nop        
0013BC7C 34040000 ori        $a0, $zero, 0
0013BC80 8CA51ABC lw         $a1, 0x1abc($a1)
0013BC84 AFA400B4 sw         $a0, 0xb4($sp)
0013BC88 0085202B sltu       $a0, $a0, $a1
0013BC8C 108001C0 beqz       $a0, 0x13c390
0013BC90 3C04002D lui        $a0, 0x2d
0013BC94 248419E4 addiu      $a0, $a0, 0x19e4
0013BC98 AFA400B8 sw         $a0, 0xb8($sp)
0013BC9C 3C04002D lui        $a0, 0x2d
0013BCA0 248419FC addiu      $a0, $a0, 0x19fc
0013BCA4 AFA400C8 sw         $a0, 0xc8($sp)
0013BCA8 3C04002D lui        $a0, 0x2d
0013BCAC 24841A14 addiu      $a0, $a0, 0x1a14
0013BCB0 3C05002D lui        $a1, 0x2d
0013BCB4 AFA400C4 sw         $a0, 0xc4($sp)
0013BCB8 24A51B8C addiu      $a1, $a1, 0x1b8c
0013BCBC 3C04002D lui        $a0, 0x2d
0013BCC0 24841B60 addiu      $a0, $a0, 0x1b60
0013BCC4 AFA500C0 sw         $a1, 0xc0($sp)
0013BCC8 AFA400BC sw         $a0, 0xbc($sp)
0013BCCC 3C043000 lui        $a0, 0x3000
0013BCD0 4484B000 mtc1       $a0, $f22
0013BCD4 3C15002D lui        $s5, 0x2d
0013BCD8 3C043F80 lui        $a0, 0x3f80
0013BCDC 26B51AE8 addiu      $s5, $s5, 0x1ae8
0013BCE0 4484F000 mtc1       $a0, $f30
0013BCE4 3C14002B lui        $s4, 0x2b
0013BCE8 3C1E002D lui        $fp, 0x2d
0013BCEC 3C17002D lui        $s7, 0x2d
0013BCF0 3C16002D lui        $s6, 0x2d
0013BCF4 3C04002D lui        $a0, 0x2d
0013BCF8 C48C1AE8 lwc1       $f12, 0x1ae8($a0)
0013BCFC C6AD0004 lwc1       $f13, 4($s5)
0013BD00 E7AC004C swc1       $f12, 0x4c($sp)
0013BD04 C6AC0008 lwc1       $f12, 8($s5)
0013BD08 E7AD0050 swc1       $f13, 0x50($sp)
0013BD0C C6AD000C lwc1       $f13, 0xc($s5)
0013BD10 E7AC0054 swc1       $f12, 0x54($sp)
0013BD14 E7AD0058 swc1       $f13, 0x58($sp)
0013BD18 8FA400B8 lw         $a0, 0xb8($sp)
0013BD1C 8E8500C0 lw         $a1, 0xc0($s4)
0013BD20 8C91000C lw         $s1, 0xc($a0)
0013BD24 34120000 ori        $s2, $zero, 0
0013BD28 8CA500F0 lw         $a1, 0xf0($a1)
0013BD2C 0C007FEF jal        0x1ffbc
0013BD30 3404000A ori        $a0, $zero, 0xa
0013BD34 10400003 beqz       $v0, 0x13bd44
0013BD38 00000000 nop        
0013BD3C 8FA400C8 lw         $a0, 0xc8($sp)
0013BD40 8C91000C lw         $s1, 0xc($a0)
0013BD44 3C04002D lui        $a0, 0x2d
0013BD48 8C901B00 lw         $s0, 0x1b00($a0)
0013BD4C 3C04002D lui        $a0, 0x2d
0013BD50 0C06B652 jal        0x1ad948
0013BD54 C49A1AD8 lwc1       $f26, 0x1ad8($a0)
0013BD58 34040003 ori        $a0, $zero, 3
0013BD5C 0044001A div        $zero, $v0, $a0
0013BD60 00002010 mfhi       $a0
0013BD64 14800058 bnez       $a0, 0x13bec8
0013BD68 00000000 nop        
0013BD6C E7BC00D8 swc1       $f28, 0xd8($sp)
0013BD70 E7BE00D4 swc1       $f30, 0xd4($sp)
0013BD74 3C10002D lui        $s0, 0x2d
0013BD78 C60C1B50 lwc1       $f12, 0x1b50($s0)
0013BD7C 3C04002D lui        $a0, 0x2d
0013BD80 C49A1ADC lwc1       $f26, 0x1adc($a0)
0013BD84 46006507 neg.s      $f20, $f12
0013BD88 3C04002D lui        $a0, 0x2d
0013BD8C 46146601 sub.s      $f24, $f12, $f20
0013BD90 8C911B04 lw         $s1, 0x1b04($a0)
0013BD94 34120001 ori        $s2, $zero, 1
0013BD98 0C06B652 jal        0x1ad948
0013BD9C E7BA00D0 swc1       $f26, 0xd0($sp)
0013BDA0 44826800 mtc1       $v0, $f13
0013BDA4 46806B60 cvt.s.w    $f13, $f13
0013BDA8 C7AC004C lwc1       $f12, 0x4c($sp)
0013BDAC C60E1B50 lwc1       $f14, 0x1b50($s0)
0013BDB0 46166B42 mul.s      $f13, $f13, $f22
0013BDB4 46007687 neg.s      $f26, $f14
0013BDB8 46186B42 mul.s      $f13, $f13, $f24
0013BDBC 460DA340 add.s      $f13, $f20, $f13
0013BDC0 461A7601 sub.s      $f24, $f14, $f26
0013BDC4 460D6300 add.s      $f12, $f12, $f13
0013BDC8 0C06B652 jal        0x1ad948
0013BDCC E7AC004C swc1       $f12, 0x4c($sp)
0013BDD0 44826000 mtc1       $v0, $f12
0013BDD4 46806320 cvt.s.w    $f12, $f12
0013BDD8 C7AF0050 lwc1       $f15, 0x50($sp)
0013BDDC C60E1B50 lwc1       $f14, 0x1b50($s0)
0013BDE0 46166302 mul.s      $f12, $f12, $f22
0013BDE4 46007507 neg.s      $f20, $f14
0013BDE8 46186302 mul.s      $f12, $f12, $f24
0013BDEC 460CD300 add.s      $f12, $f26, $f12
0013BDF0 46147601 sub.s      $f24, $f14, $f20
0013BDF4 460C7B00 add.s      $f12, $f15, $f12
0013BDF8 0C06B652 jal        0x1ad948
0013BDFC E7AC0050 swc1       $f12, 0x50($sp)
0013BE00 44826000 mtc1       $v0, $f12
0013BE04 46806320 cvt.s.w    $f12, $f12
0013BE08 C7AD0054 lwc1       $f13, 0x54($sp)
0013BE0C 3C10002D lui        $s0, 0x2d
0013BE10 C60E1AC4 lwc1       $f14, 0x1ac4($s0)
0013BE14 46166302 mul.s      $f12, $f12, $f22
0013BE18 46007687 neg.s      $f26, $f14
0013BE1C 46186302 mul.s      $f12, $f12, $f24
0013BE20 460CA300 add.s      $f12, $f20, $f12
0013BE24 461A7601 sub.s      $f24, $f14, $f26
0013BE28 460C6B00 add.s      $f12, $f13, $f12
0013BE2C 0C06B652 jal        0x1ad948
0013BE30 E7AC0054 swc1       $f12, 0x54($sp)
0013BE34 44826000 mtc1       $v0, $f12
0013BE38 46806320 cvt.s.w    $f12, $f12
0013BE3C C60F1AC4 lwc1       $f15, 0x1ac4($s0)
0013BE40 46007D07 neg.s      $f20, $f15
0013BE44 46166302 mul.s      $f12, $f12, $f22
0013BE48 46147F81 sub.s      $f30, $f15, $f20
0013BE4C 46186302 mul.s      $f12, $f12, $f24
0013BE50 460CD300 add.s      $f12, $f26, $f12
0013BE54 0C06B652 jal        0x1ad948
0013BE58 E7AC0040 swc1       $f12, 0x40($sp)
0013BE5C 44826000 mtc1       $v0, $f12
0013BE60 46806320 cvt.s.w    $f12, $f12
0013BE64 C60D1AC4 lwc1       $f13, 0x1ac4($s0)
0013BE68 46006E87 neg.s      $f26, $f13
0013BE6C 46166302 mul.s      $f12, $f12, $f22
0013BE70 461A6F01 sub.s      $f28, $f13, $f26
0013BE74 461E6302 mul.s      $f12, $f12, $f30
0013BE78 460CA300 add.s      $f12, $f20, $f12
0013BE7C 0C06B652 jal        0x1ad948
0013BE80 E7AC0044 swc1       $f12, 0x44($sp)
0013BE84 44826000 mtc1       $v0, $f12
0013BE88 46806320 cvt.s.w    $f12, $f12
0013BE8C 8E8400C0 lw         $a0, 0xc0($s4)
0013BE90 3C05002D lui        $a1, 0x2d
0013BE94 4491C000 mtc1       $s1, $f24
0013BE98 C4B41AD0 lwc1       $f20, 0x1ad0($a1)
0013BE9C 46166302 mul.s      $f12, $f12, $f22
0013BEA0 2411FFFF addiu      $s1, $zero, -1
0013BEA4 4680C620 cvt.s.w    $f24, $f24
0013BEA8 461C6302 mul.s      $f12, $f12, $f28
0013BEAC 460CD300 add.s      $f12, $f26, $f12
0013BEB0 E7AC0048 swc1       $f12, 0x48($sp)
0013BEB4 8C8400F0 lw         $a0, 0xf0($a0)
0013BEB8 C7BA00D0 lwc1       $f26, 0xd0($sp)
0013BEBC C7BE00D4 lwc1       $f30, 0xd4($sp)
0013BEC0 1000004F b          0x13c000
0013BEC4 C7BC00D8 lwc1       $f28, 0xd8($sp)
0013BEC8 E7BC00D4 swc1       $f28, 0xd4($sp)
0013BECC E7BA00D0 swc1       $f26, 0xd0($sp)
0013BED0 E7BE00D8 swc1       $f30, 0xd8($sp)
0013BED4 C7CC1B4C lwc1       $f12, 0x1b4c($fp)
0013BED8 46006507 neg.s      $f20, $f12
0013BEDC 0C06B652 jal        0x1ad948
0013BEE0 46146601 sub.s      $f24, $f12, $f20
0013BEE4 44826800 mtc1       $v0, $f13
0013BEE8 46806B60 cvt.s.w    $f13, $f13
0013BEEC C7AE004C lwc1       $f14, 0x4c($sp)
0013BEF0 C7CF1B4C lwc1       $f15, 0x1b4c($fp)
0013BEF4 46166B42 mul.s      $f13, $f13, $f22
0013BEF8 46007F87 neg.s      $f30, $f15
0013BEFC 46186B02 mul.s      $f12, $f13, $f24
0013BF00 460CA300 add.s      $f12, $f20, $f12
0013BF04 461E7E01 sub.s      $f24, $f15, $f30
0013BF08 460C7300 add.s      $f12, $f14, $f12
0013BF0C 0C06B652 jal        0x1ad948
0013BF10 E7AC004C swc1       $f12, 0x4c($sp)
0013BF14 44826000 mtc1       $v0, $f12
0013BF18 46806320 cvt.s.w    $f12, $f12
0013BF1C C7AD0050 lwc1       $f13, 0x50($sp)
0013BF20 C7CF1B4C lwc1       $f15, 0x1b4c($fp)
0013BF24 46166302 mul.s      $f12, $f12, $f22
0013BF28 46007D07 neg.s      $f20, $f15
0013BF2C 46186302 mul.s      $f12, $f12, $f24
0013BF30 460CF300 add.s      $f12, $f30, $f12
0013BF34 46147E01 sub.s      $f24, $f15, $f20
0013BF38 460C6B00 add.s      $f12, $f13, $f12
0013BF3C 0C06B652 jal        0x1ad948
0013BF40 E7AC0050 swc1       $f12, 0x50($sp)
0013BF44 44826000 mtc1       $v0, $f12
0013BF48 46806320 cvt.s.w    $f12, $f12
0013BF4C C7AE0054 lwc1       $f14, 0x54($sp)
0013BF50 C6EF1AC0 lwc1       $f15, 0x1ac0($s7)
0013BF54 46166302 mul.s      $f12, $f12, $f22
0013BF58 46007F87 neg.s      $f30, $f15
0013BF5C 46186302 mul.s      $f12, $f12, $f24
0013BF60 460CA300 add.s      $f12, $f20, $f12
0013BF64 461E7E01 sub.s      $f24, $f15, $f30
0013BF68 460C7300 add.s      $f12, $f14, $f12
0013BF6C 0C06B652 jal        0x1ad948
0013BF70 E7AC0054 swc1       $f12, 0x54($sp)
0013BF74 44826000 mtc1       $v0, $f12
0013BF78 46806320 cvt.s.w    $f12, $f12
0013BF7C C6ED1AC0 lwc1       $f13, 0x1ac0($s7)
0013BF80 46006D07 neg.s      $f20, $f13
0013BF84 46166302 mul.s      $f12, $f12, $f22
0013BF88 46146E81 sub.s      $f26, $f13, $f20
0013BF8C 46186302 mul.s      $f12, $f12, $f24
0013BF90 460CF300 add.s      $f12, $f30, $f12
0013BF94 0C06B652 jal        0x1ad948
0013BF98 E7AC0040 swc1       $f12, 0x40($sp)
0013BF9C 44826000 mtc1       $v0, $f12
0013BFA0 46806320 cvt.s.w    $f12, $f12
0013BFA4 C6EE1AC0 lwc1       $f14, 0x1ac0($s7)
0013BFA8 46007787 neg.s      $f30, $f14
0013BFAC 46166302 mul.s      $f12, $f12, $f22
0013BFB0 461E7701 sub.s      $f28, $f14, $f30
0013BFB4 461A6302 mul.s      $f12, $f12, $f26
0013BFB8 460CA300 add.s      $f12, $f20, $f12
0013BFBC 0C06B652 jal        0x1ad948
0013BFC0 E7AC0044 swc1       $f12, 0x44($sp)
0013BFC4 44826000 mtc1       $v0, $f12
0013BFC8 46806320 cvt.s.w    $f12, $f12
0013BFCC 8E8400C0 lw         $a0, 0xc0($s4)
0013BFD0 3C05002D lui        $a1, 0x2d
0013BFD4 4490C000 mtc1       $s0, $f24
0013BFD8 C4B41AD0 lwc1       $f20, 0x1ad0($a1)
0013BFDC 46166302 mul.s      $f12, $f12, $f22
0013BFE0 4680C620 cvt.s.w    $f24, $f24
0013BFE4 461C6302 mul.s      $f12, $f12, $f28
0013BFE8 460CF300 add.s      $f12, $f30, $f12
0013BFEC E7AC0048 swc1       $f12, 0x48($sp)
0013BFF0 8C8400F0 lw         $a0, 0xf0($a0)
0013BFF4 C7BE00D8 lwc1       $f30, 0xd8($sp)
0013BFF8 C7BA00D0 lwc1       $f26, 0xd0($sp)
0013BFFC C7BC00D4 lwc1       $f28, 0xd4($sp)
0013C000 00802825 move       $a1, $a0
0013C004 0C007FEF jal        0x1ffbc
0013C008 3404000A ori        $a0, $zero, 0xa
0013C00C 50400004 beql       $v0, $zero, 0x13c020
0013C010 E7BC00D8 swc1       $f28, 0xd8($sp)
0013C014 3C04002D lui        $a0, 0x2d
0013C018 C4941AD4 lwc1       $f20, 0x1ad4($a0)
0013C01C E7BC00D8 swc1       $f28, 0xd8($sp)
0013C020 E7BE00D4 swc1       $f30, 0xd4($sp)
0013C024 AFB700DC sw         $s7, 0xdc($sp)
0013C028 8FA400CC lw         $a0, 0xcc($sp)
0013C02C 8FB000B8 lw         $s0, 0xb8($sp)
0013C030 C48C0278 lwc1       $f12, 0x278($a0)
0013C034 3C043F99 lui        $a0, 0x3f99
0013C038 3C17002D lui        $s7, 0x2d
0013C03C 3484999A ori        $a0, $a0, 0x999a
0013C040 C6EE1ACC lwc1       $f14, 0x1acc($s7)
0013C044 44846800 mtc1       $a0, $f13
0013C048 460D6782 mul.s      $f30, $f12, $f13
0013C04C 0C06B652 jal        0x1ad948
0013C050 460EA501 sub.s      $f20, $f20, $f14
0013C054 44827800 mtc1       $v0, $f15
0013C058 C6F01ACC lwc1       $f16, 0x1acc($s7)
0013C05C 46807BE0 cvt.s.w    $f15, $f15
0013C060 8E040010 lw         $a0, 0x10($s0)
0013C064 3C050100 lui        $a1, 0x100
0013C068 24A5FFFF addiu      $a1, $a1, -1
0013C06C 00858024 and        $s0, $a0, $a1
0013C070 46167B02 mul.s      $f12, $f15, $f22
0013C074 3C04002D lui        $a0, 0x2d
0013C078 C48D1AE4 lwc1       $f13, 0x1ae4($a0)
0013C07C 3C17002D lui        $s7, 0x2d
0013C080 C6EE1AE0 lwc1       $f14, 0x1ae0($s7)
0013C084 46146302 mul.s      $f12, $f12, $f20
0013C088 460E6F01 sub.s      $f28, $f13, $f14
0013C08C 0C06B652 jal        0x1ad948
0013C090 460C8500 add.s      $f20, $f16, $f12
0013C094 44827800 mtc1       $v0, $f15
0013C098 46807BE0 cvt.s.w    $f15, $f15
0013C09C C6F11AE0 lwc1       $f17, 0x1ae0($s7)
0013C0A0 3C073C88 lui        $a3, 0x3c88
0013C0A4 34E7893B ori        $a3, $a3, 0x893b
0013C0A8 46167BC2 mul.s      $f15, $f15, $f22
0013C0AC 3C0841F0 lui        $t0, 0x41f0
0013C0B0 44877000 mtc1       $a3, $f14
0013C0B4 34020001 ori        $v0, $zero, 1
0013C0B8 44888000 mtc1       $t0, $f16
0013C0BC 461C7B42 mul.s      $f13, $f15, $f28
0013C0C0 AFA20000 sw         $v0, ($sp)
0013C0C4 34040002 ori        $a0, $zero, 2
0013C0C8 4600F306 mov.s      $f12, $f30
0013C0CC 27A6004C addiu      $a2, $sp, 0x4c
0013C0D0 460D8B40 add.s      $f13, $f17, $f13
0013C0D4 02602825 move       $a1, $s3
0013C0D8 27A70040 addiu      $a3, $sp, 0x40
0013C0DC 02204025 move       $t0, $s1
0013C0E0 460E6BC2 mul.s      $f15, $f13, $f14
0013C0E4 02004825 move       $t1, $s0
0013C0E8 340A0001 ori        $t2, $zero, 1
0013C0EC 00005825 move       $t3, $zero
0013C0F0 AFB20004 sw         $s2, 4($sp)
0013C0F4 46107BC2 mul.s      $f15, $f15, $f16
0013C0F8 4600C346 mov.s      $f13, $f24
0013C0FC 4600A386 mov.s      $f14, $f20
0013C100 0C04ED7E jal        0x13b5f8
0013C104 4600D406 mov.s      $f16, $f26
0013C108 8EC41B40 lw         $a0, 0x1b40($s6)
0013C10C 8FB700DC lw         $s7, 0xdc($sp)
0013C110 C7BE00D4 lwc1       $f30, 0xd4($sp)
0013C114 14800051 bnez       $a0, 0x13c25c
0013C118 C7BC00D8 lwc1       $f28, 0xd8($sp)
0013C11C 3C04002D lui        $a0, 0x2d
0013C120 C48C1B3C lwc1       $f12, 0x1b3c($a0)
0013C124 C66D0010 lwc1       $f13, 0x10($s3)
0013C128 C66E0014 lwc1       $f14, 0x14($s3)
0013C12C 46006307 neg.s      $f12, $f12
0013C130 460D6342 mul.s      $f13, $f12, $f13
0013C134 C66F0018 lwc1       $f15, 0x18($s3)
0013C138 460E6382 mul.s      $f14, $f12, $f14
0013C13C 3C10002D lui        $s0, 0x2d
0013C140 C6101AC8 lwc1       $f16, 0x1ac8($s0)
0013C144 E7AD005C swc1       $f13, 0x5c($sp)
0013C148 46008507 neg.s      $f20, $f16
0013C14C 460F6302 mul.s      $f12, $f12, $f15
0013C150 E7AE0060 swc1       $f14, 0x60($sp)
0013C154 46148601 sub.s      $f24, $f16, $f20
0013C158 0C06B652 jal        0x1ad948
0013C15C E7AC0064 swc1       $f12, 0x64($sp)
0013C160 44826000 mtc1       $v0, $f12
0013C164 46806320 cvt.s.w    $f12, $f12
0013C168 C7AD005C lwc1       $f13, 0x5c($sp)
0013C16C 46166302 mul.s      $f12, $f12, $f22
0013C170 46186302 mul.s      $f12, $f12, $f24
0013C174 460CA300 add.s      $f12, $f20, $f12
0013C178 460C6B00 add.s      $f12, $f13, $f12
0013C17C 0C06B652 jal        0x1ad948
0013C180 E7AC005C swc1       $f12, 0x5c($sp)
0013C184 44826000 mtc1       $v0, $f12
0013C188 3C044110 lui        $a0, 0x4110
0013C18C 46806320 cvt.s.w    $f12, $f12
0013C190 44847000 mtc1       $a0, $f14
0013C194 C7AF0060 lwc1       $f15, 0x60($sp)
0013C198 3C04C120 lui        $a0, 0xc120
0013C19C 46166302 mul.s      $f12, $f12, $f22
0013C1A0 C6101AC8 lwc1       $f16, 0x1ac8($s0)
0013C1A4 44846800 mtc1       $a0, $f13
0013C1A8 46008507 neg.s      $f20, $f16
0013C1AC 460E6302 mul.s      $f12, $f12, $f14
0013C1B0 46148601 sub.s      $f24, $f16, $f20
0013C1B4 460D6300 add.s      $f12, $f12, $f13
0013C1B8 460F6300 add.s      $f12, $f12, $f15
0013C1BC 0C06B652 jal        0x1ad948
0013C1C0 E7AC0060 swc1       $f12, 0x60($sp)
0013C1C4 44826000 mtc1       $v0, $f12
0013C1C8 46806460 cvt.s.w    $f17, $f12
0013C1CC C7AE0064 lwc1       $f14, 0x64($sp)
0013C1D0 46168C02 mul.s      $f16, $f17, $f22
0013C1D4 C7AC005C lwc1       $f12, 0x5c($sp)
0013C1D8 C7AD0060 lwc1       $f13, 0x60($sp)
0013C1DC 460C63C2 mul.s      $f15, $f12, $f12
0013C1E0 46188402 mul.s      $f16, $f16, $f24
0013C1E4 460D6C82 mul.s      $f18, $f13, $f13
0013C1E8 3C043480 lui        $a0, 0x3480
0013C1EC 4610A400 add.s      $f16, $f20, $f16
0013C1F0 46127BC0 add.s      $f15, $f15, $f18
0013C1F4 44848800 mtc1       $a0, $f17
0013C1F8 46107380 add.s      $f14, $f14, $f16
0013C1FC 460E74C2 mul.s      $f19, $f14, $f14
0013C200 46137BC0 add.s      $f15, $f15, $f19
0013C204 4611783C c.lt.s     $f15, $f17
0013C208 00000000 nop        
0013C20C 45010009 bc1t       0x13c234
0013C210 E7AE0064 swc1       $f14, 0x64($sp)
0013C214 46007BC4 sqrt.s     $f15, $f15
0013C218 460FF3C3 div.s      $f15, $f30, $f15
0013C21C 460F6302 mul.s      $f12, $f12, $f15
0013C220 460F6B42 mul.s      $f13, $f13, $f15
0013C224 460F7382 mul.s      $f14, $f14, $f15
0013C228 E7AC005C swc1       $f12, 0x5c($sp)
0013C22C E7AD0060 swc1       $f13, 0x60($sp)
0013C230 E7AE0064 swc1       $f14, 0x64($sp)
0013C234 27B0006C addiu      $s0, $sp, 0x6c
0013C238 8FB100C4 lw         $s1, 0xc4($sp)
0013C23C 02002025 move       $a0, $s0
0013C240 02602825 move       $a1, $s3
0013C244 0C03D550 jal        0xf5540
0013C248 02A03025 move       $a2, $s5
0013C24C 02002025 move       $a0, $s0
0013C250 27A5005C addiu      $a1, $sp, 0x5c
0013C254 0C036A34 jal        0xda8d0
0013C258 02203025 move       $a2, $s1
0013C25C 8EC41B40 lw         $a0, 0x1b40($s6)
0013C260 3405000A ori        $a1, $zero, 0xa
0013C264 24840001 addiu      $a0, $a0, 1
0013C268 0085001B divu       $zero, $a0, $a1
0013C26C 8E8500C0 lw         $a1, 0xc0($s4)
0013C270 34100008 ori        $s0, $zero, 8
0013C274 3404000A ori        $a0, $zero, 0xa
0013C278 00003010 mfhi       $a2
0013C27C AEC61B40 sw         $a2, 0x1b40($s6)
0013C280 0C007FEF jal        0x1ffbc
0013C284 8CA500F0 lw         $a1, 0xf0($a1)
0013C288 10400002 beqz       $v0, 0x13c294
0013C28C 00000000 nop        
0013C290 34100006 ori        $s0, $zero, 6
0013C294 12000007 beqz       $s0, 0x13c2b4
0013C298 34040000 ori        $a0, $zero, 0
0013C29C 0C06B652 jal        0x1ad948
0013C2A0 00000000 nop        
0013C2A4 0050001A div        $zero, $v0, $s0
0013C2A8 00002010 mfhi       $a0
0013C2AC 10000001 b          0x13c2b4
0013C2B0 00000000 nop        
0013C2B4 1480002F bnez       $a0, 0x13c374
0013C2B8 00000000 nop        
0013C2BC 27A400A4 addiu      $a0, $sp, 0xa4
0013C2C0 02602825 move       $a1, $s3
0013C2C4 0C03D550 jal        0xf5540
0013C2C8 02A03025 move       $a2, $s5
0013C2CC C7AC00A4 lwc1       $f12, 0xa4($sp)
0013C2D0 C7AD00A8 lwc1       $f13, 0xa8($sp)
0013C2D4 E7AC007C swc1       $f12, 0x7c($sp)
0013C2D8 C7AC00AC lwc1       $f12, 0xac($sp)
0013C2DC C66E0010 lwc1       $f14, 0x10($s3)
0013C2E0 E7AD0080 swc1       $f13, 0x80($sp)
0013C2E4 E7AC0084 swc1       $f12, 0x84($sp)
0013C2E8 C66D0014 lwc1       $f13, 0x14($s3)
0013C2EC 46007307 neg.s      $f12, $f14
0013C2F0 C66F0018 lwc1       $f15, 0x18($s3)
0013C2F4 E7AC0090 swc1       $f12, 0x90($sp)
0013C2F8 46006B07 neg.s      $f12, $f13
0013C2FC 3C04002D lui        $a0, 0x2d
0013C300 E7AC0094 swc1       $f12, 0x94($sp)
0013C304 46007B07 neg.s      $f12, $f15
0013C308 C4901B54 lwc1       $f16, 0x1b54($a0)
0013C30C E7AC0098 swc1       $f12, 0x98($sp)
0013C310 3C04002D lui        $a0, 0x2d
0013C314 C48C1B58 lwc1       $f12, 0x1b58($a0)
0013C318 E7B00088 swc1       $f16, 0x88($sp)
0013C31C 3C04002D lui        $a0, 0x2d
0013C320 C48D1B5C lwc1       $f13, 0x1b5c($a0)
0013C324 E7AC008C swc1       $f12, 0x8c($sp)
0013C328 E7AD009C swc1       $f13, 0x9c($sp)
0013C32C 8E8500C0 lw         $a1, 0xc0($s4)
0013C330 3404000A ori        $a0, $zero, 0xa
0013C334 0C007FEF jal        0x1ffbc
0013C338 8CA500F0 lw         $a1, 0xf0($a1)
0013C33C 10400004 beqz       $v0, 0x13c350
0013C340 00000000 nop        
0013C344 8FA400C0 lw         $a0, 0xc0($sp)
0013C348 10000003 b          0x13c358
0013C34C AFA400A0 sw         $a0, 0xa0($sp)
0013C350 8FA400BC lw         $a0, 0xbc($sp)
0013C354 AFA400A0 sw         $a0, 0xa0($sp)
0013C358 3C04002D lui        $a0, 0x2d
0013C35C 4600E306 mov.s      $f12, $f28
0013C360 8C841AB8 lw         $a0, 0x1ab8($a0)
0013C364 4600E346 mov.s      $f13, $f28
0013C368 27A5007C addiu      $a1, $sp, 0x7c
0013C36C 0C035902 jal        0xd6408
0013C370 34060001 ori        $a2, $zero, 1
0013C374 8FA400B4 lw         $a0, 0xb4($sp)
0013C378 3C05002D lui        $a1, 0x2d
0013C37C 8CA51ABC lw         $a1, 0x1abc($a1)
0013C380 24840001 addiu      $a0, $a0, 1
0013C384 0085282B sltu       $a1, $a0, $a1
0013C388 14A0FE5A bnez       $a1, 0x13bcf4
0013C38C AFA400B4 sw         $a0, 0xb4($sp)
0013C390 C7B400E0 lwc1       $f20, 0xe0($sp)
0013C394 C7B600E4 lwc1       $f22, 0xe4($sp)
0013C398 C7B800E8 lwc1       $f24, 0xe8($sp)
0013C39C C7BA00EC lwc1       $f26, 0xec($sp)
0013C3A0 C7BC00F0 lwc1       $f28, 0xf0($sp)
0013C3A4 C7BE00F4 lwc1       $f30, 0xf4($sp)
0013C3A8 8FB000F8 lw         $s0, 0xf8($sp)
0013C3AC 8FB100FC lw         $s1, 0xfc($sp)
0013C3B0 8FB20100 lw         $s2, 0x100($sp)
0013C3B4 8FB30104 lw         $s3, 0x104($sp)
0013C3B8 8FB40108 lw         $s4, 0x108($sp)
0013C3BC 8FB5010C lw         $s5, 0x10c($sp)
0013C3C0 8FB60110 lw         $s6, 0x110($sp)
0013C3C4 8FB70114 lw         $s7, 0x114($sp)
0013C3C8 8FBE0118 lw         $fp, 0x118($sp)
0013C3CC 8FBF011C lw         $ra, 0x11c($sp)
0013C3D0 03E00008 jr         $ra
0013C3D4 27BD0120 addiu      $sp, $sp, 0x120
0013C3D8 27BDFEA0 addiu      $sp, $sp, -0x160
0013C3DC AFB00138 sw         $s0, 0x138($sp)
0013C3E0 8C900058 lw         $s0, 0x58($a0)
0013C3E4 AFB60150 sw         $s6, 0x150($sp)
0013C3E8 92050015 lbu        $a1, 0x15($s0)
0013C3EC 0080B025 move       $s6, $a0
0013C3F0 E7B40120 swc1       $f20, 0x120($sp)
0013C3F4 E7B60124 swc1       $f22, 0x124($sp)
0013C3F8 E7B80128 swc1       $f24, 0x128($sp)
0013C3FC E7BA012C swc1       $f26, 0x12c($sp)
0013C400 E7BC0130 swc1       $f28, 0x130($sp)
0013C404 E7BE0134 swc1       $f30, 0x134($sp)
0013C408 AFB1013C sw         $s1, 0x13c($sp)
0013C40C AFB20140 sw         $s2, 0x140($sp)
0013C410 AFB30144 sw         $s3, 0x144($sp)
0013C414 AFB40148 sw         $s4, 0x148($sp)
0013C418 AFB5014C sw         $s5, 0x14c($sp)
0013C41C AFB70154 sw         $s7, 0x154($sp)
0013C420 AFBE0158 sw         $fp, 0x158($sp)
0013C424 AFBF015C sw         $ra, 0x15c($sp)
0013C428 10A00009 beqz       $a1, 0x13c450
0013C42C 8E120000 lw         $s2, ($s0)
0013C430 AFB60118 sw         $s6, 0x118($sp)
0013C434 A2000015 sb         $zero, 0x15($s0)
0013C438 92C40046 lbu        $a0, 0x46($s6)
0013C43C 34050001 ori        $a1, $zero, 1
0013C440 10850005 beq        $a0, $a1, 0x13c458
0013C444 00000000 nop        
0013C448 10000131 b          0x13c910
0013C44C 00000000 nop        
0013C450 1000029E b          0x13cecc
0013C454 00000000 nop        
0013C458 8FB30118 lw         $s3, 0x118($sp)
0013C45C 27B10050 addiu      $s1, $sp, 0x50
0013C460 02602025 move       $a0, $s3
0013C464 02202825 move       $a1, $s1
0013C468 0C01AC1B jal        0x6b06c
0013C46C 34060006 ori        $a2, $zero, 6
0013C470 C7AC0070 lwc1       $f12, 0x70($sp)
0013C474 C7AD0074 lwc1       $f13, 0x74($sp)
0013C478 E7AC0090 swc1       $f12, 0x90($sp)
0013C47C C7AC0078 lwc1       $f12, 0x78($sp)
0013C480 E7AD0094 swc1       $f13, 0x94($sp)
0013C484 E7AC0098 swc1       $f12, 0x98($sp)
0013C488 C7AC0060 lwc1       $f12, 0x60($sp)
0013C48C C7AD0064 lwc1       $f13, 0x64($sp)
0013C490 46006307 neg.s      $f12, $f12
0013C494 C7AE0068 lwc1       $f14, 0x68($sp)
0013C498 E7AC0070 swc1       $f12, 0x70($sp)
0013C49C 46006B07 neg.s      $f12, $f13
0013C4A0 E7AC0074 swc1       $f12, 0x74($sp)
0013C4A4 46007307 neg.s      $f12, $f14
0013C4A8 C7AF0050 lwc1       $f15, 0x50($sp)
0013C4AC E7AC0078 swc1       $f12, 0x78($sp)
0013C4B0 C7AC0054 lwc1       $f12, 0x54($sp)
0013C4B4 E7AF0060 swc1       $f15, 0x60($sp)
0013C4B8 C7AF0058 lwc1       $f15, 0x58($sp)
0013C4BC E7AC0064 swc1       $f12, 0x64($sp)
0013C4C0 C7AC0090 lwc1       $f12, 0x90($sp)
0013C4C4 E7AF0068 swc1       $f15, 0x68($sp)
0013C4C8 C7AF0094 lwc1       $f15, 0x94($sp)
0013C4CC E7AC0050 swc1       $f12, 0x50($sp)
0013C4D0 C7AC0098 lwc1       $f12, 0x98($sp)
0013C4D4 E7AF0054 swc1       $f15, 0x54($sp)
0013C4D8 E7AC0058 swc1       $f12, 0x58($sp)
0013C4DC 8E4500F0 lw         $a1, 0xf0($s2)
0013C4E0 0C007FEF jal        0x1ffbc
0013C4E4 3404000A ori        $a0, $zero, 0xa
0013C4E8 3C043D75 lui        $a0, 0x3d75
