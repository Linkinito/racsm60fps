000AC210 d0ffbd27 addiu      $sp, $sp, -0x30
000AC214 1400878c lw         $a3, 0x14($a0)
000AC218 2400b2af sw         $s2, 0x24($sp)
000AC21C 25908000 move       $s2, $a0
000AC220 2000b1af sw         $s1, 0x20($sp)
000AC224 0200e430 andi       $a0, $a3, 2
000AC228 2588a000 move       $s1, $a1
000AC22C 1c00b0af sw         $s0, 0x1c($sp)
000AC230 2800bfaf sw         $ra, 0x28($sp)
000AC234 0c008010 beqz       $a0, 0xac268
000AC238 2580c000 move       $s0, $a2
000AC23C 81b0020c jal        0xac204
000AC240 25204002 move       $a0, $s2
000AC244 6800448e lw         $a0, 0x68($s2)
000AC248 1a008200 div        $zero, $a0, $v0
000AC24C 7400448e lw         $a0, 0x74($s2)
000AC250 12280000 mflo       $a1
000AC254 0000a628 slti       $a2, $a1, 0
000AC258 0700c014 bnez       $a2, 0xac278
000AC25C 2120a400 addu       $a0, $a1, $a0
000AC260 06000010 b          0xac27c
000AC264 00000000 nop        
000AC268 000020ae sw         $zero, ($s1)
000AC26C 0400448e lw         $a0, 4($s2)
000AC270 08000010 b          0xac294
000AC274 000004ae sw         $a0, ($s0)
000AC278 00000534 ori        $a1, $zero, 0
000AC27C 0400468e lw         $a2, 4($s2)
000AC280 2a38c400 slt        $a3, $a2, $a0
000AC284 0100e054 bnel       $a3, $zero, 0xac28c
000AC288 2520c000 move       $a0, $a2
000AC28C 000025ae sw         $a1, ($s1)
000AC290 000004ae sw         $a0, ($s0)
000AC294 1c00b08f lw         $s0, 0x1c($sp)
000AC298 2000b18f lw         $s1, 0x20($sp)
000AC29C 2400b28f lw         $s2, 0x24($sp)
000AC2A0 2800bf8f lw         $ra, 0x28($sp)
000AC2A4 0800e003 jr         $ra
000AC2A8 3000bd27 addiu      $sp, $sp, 0x30