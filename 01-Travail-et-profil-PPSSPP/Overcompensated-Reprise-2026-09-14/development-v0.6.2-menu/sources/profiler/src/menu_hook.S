/* Original input executes with game GP. C sees plugin GP. Only v0 is changed. */
.set noreorder
.set noat
.text
.align 4
    .equ RCSM_FRAME_SIZE, 0x120
    .equ RCSM_AT,          0x010
    .equ RCSM_V0,          0x014
    .equ RCSM_V1,          0x018
    .equ RCSM_A0,          0x01C
    .equ RCSM_A1,          0x020
    .equ RCSM_A2,          0x024
    .equ RCSM_A3,          0x028
    .equ RCSM_T0,          0x02C
    .equ RCSM_T1,          0x030
    .equ RCSM_T2,          0x034
    .equ RCSM_T3,          0x038
    .equ RCSM_T4,          0x03C
    .equ RCSM_T5,          0x040
    .equ RCSM_T6,          0x044
    .equ RCSM_T7,          0x048
    .equ RCSM_S0,          0x04C
    .equ RCSM_S1,          0x050
    .equ RCSM_S2,          0x054
    .equ RCSM_S3,          0x058
    .equ RCSM_S4,          0x05C
    .equ RCSM_S5,          0x060
    .equ RCSM_S6,          0x064
    .equ RCSM_S7,          0x068
    .equ RCSM_T8,          0x06C
    .equ RCSM_T9,          0x070
    .equ RCSM_K0,          0x074
    .equ RCSM_K1,          0x078
    .equ RCSM_GP,          0x07C
    .equ RCSM_FP,          0x080
    .equ RCSM_ORIGINAL_RA, 0x084
    .equ RCSM_HI,          0x088
    .equ RCSM_LO,          0x08C
    .equ RCSM_FCR31,       0x090
    .equ RCSM_F0,          0x098
    .equ RCSM_COMMON_RA,   0x118


.globl rcsm_menu_hook_0
.ent rcsm_menu_hook_0
rcsm_menu_hook_0:
    addiu $sp, $sp, -0x130
    sw $ra, 0x120($sp)
    sw $k0, 0x128($sp)
    sw $k1, 0x12c($sp)
    lui $k0, %hi(g_rcsm_menu_active_hooks)
    lw $k1, %lo(g_rcsm_menu_active_hooks)($k0)
    addiu $k1, $k1, 1
    sw $k1, %lo(g_rcsm_menu_active_hooks)($k0)
    lw $k0, 0x128($sp)
    lw $k1, 0x12c($sp)
.globl rcsm_menu_original_0
rcsm_menu_original_0:
    jal 0
    nop
    sw $k0, 0x128($sp)
    ori $k0, $zero, 0
    sw $k0, 0x124($sp)
    lw $k0, 0x128($sp)
    j rcsm_menu_hook_common
    nop
.end rcsm_menu_hook_0

.globl rcsm_menu_hook_1
.ent rcsm_menu_hook_1
rcsm_menu_hook_1:
    addiu $sp, $sp, -0x130
    sw $ra, 0x120($sp)
    sw $k0, 0x128($sp)
    sw $k1, 0x12c($sp)
    lui $k0, %hi(g_rcsm_menu_active_hooks)
    lw $k1, %lo(g_rcsm_menu_active_hooks)($k0)
    addiu $k1, $k1, 1
    sw $k1, %lo(g_rcsm_menu_active_hooks)($k0)
    lw $k0, 0x128($sp)
    lw $k1, 0x12c($sp)
.globl rcsm_menu_original_1
rcsm_menu_original_1:
    jal 0
    nop
    sw $k0, 0x128($sp)
    ori $k0, $zero, 1
    sw $k0, 0x124($sp)
    lw $k0, 0x128($sp)
    j rcsm_menu_hook_common
    nop
.end rcsm_menu_hook_1

.globl rcsm_menu_hook_2
.ent rcsm_menu_hook_2
rcsm_menu_hook_2:
    addiu $sp, $sp, -0x130
    sw $ra, 0x120($sp)
    sw $k0, 0x128($sp)
    sw $k1, 0x12c($sp)
    lui $k0, %hi(g_rcsm_menu_active_hooks)
    lw $k1, %lo(g_rcsm_menu_active_hooks)($k0)
    addiu $k1, $k1, 1
    sw $k1, %lo(g_rcsm_menu_active_hooks)($k0)
    lw $k0, 0x128($sp)
    lw $k1, 0x12c($sp)
.globl rcsm_menu_original_2
rcsm_menu_original_2:
    jal 0
    nop
    sw $k0, 0x128($sp)
    ori $k0, $zero, 2
    sw $k0, 0x124($sp)
    lw $k0, 0x128($sp)
    j rcsm_menu_hook_common
    nop
.end rcsm_menu_hook_2

.ent rcsm_menu_hook_common
rcsm_menu_hook_common:
    sw      $at, RCSM_AT($sp)
    sw      $v0, RCSM_V0($sp)
    sw      $v1, RCSM_V1($sp)
    sw      $a0, RCSM_A0($sp)
    sw      $a1, RCSM_A1($sp)
    sw      $a2, RCSM_A2($sp)
    sw      $a3, RCSM_A3($sp)
    sw      $t0, RCSM_T0($sp)
    sw      $t1, RCSM_T1($sp)
    sw      $t2, RCSM_T2($sp)
    sw      $t3, RCSM_T3($sp)
    sw      $t4, RCSM_T4($sp)
    sw      $t5, RCSM_T5($sp)
    sw      $t6, RCSM_T6($sp)
    sw      $t7, RCSM_T7($sp)
    sw      $s0, RCSM_S0($sp)
    sw      $s1, RCSM_S1($sp)
    sw      $s2, RCSM_S2($sp)
    sw      $s3, RCSM_S3($sp)
    sw      $s4, RCSM_S4($sp)
    sw      $s5, RCSM_S5($sp)
    sw      $s6, RCSM_S6($sp)
    sw      $s7, RCSM_S7($sp)
    sw      $t8, RCSM_T8($sp)
    sw      $t9, RCSM_T9($sp)
    sw      $k0, RCSM_K0($sp)
    sw      $k1, RCSM_K1($sp)
    sw      $gp, RCSM_GP($sp)
    sw      $fp, RCSM_FP($sp)

    mfhi    $k0
    sw      $k0, RCSM_HI($sp)
    mflo    $k0
    sw      $k0, RCSM_LO($sp)
    cfc1    $k0, $31
    sw      $k0, RCSM_FCR31($sp)

    swc1    $f0,  RCSM_F0+0x00($sp)
    swc1    $f1,  RCSM_F0+0x04($sp)
    swc1    $f2,  RCSM_F0+0x08($sp)
    swc1    $f3,  RCSM_F0+0x0C($sp)
    swc1    $f4,  RCSM_F0+0x10($sp)
    swc1    $f5,  RCSM_F0+0x14($sp)
    swc1    $f6,  RCSM_F0+0x18($sp)
    swc1    $f7,  RCSM_F0+0x1C($sp)
    swc1    $f8,  RCSM_F0+0x20($sp)
    swc1    $f9,  RCSM_F0+0x24($sp)
    swc1    $f10, RCSM_F0+0x28($sp)
    swc1    $f11, RCSM_F0+0x2C($sp)
    swc1    $f12, RCSM_F0+0x30($sp)
    swc1    $f13, RCSM_F0+0x34($sp)
    swc1    $f14, RCSM_F0+0x38($sp)
    swc1    $f15, RCSM_F0+0x3C($sp)
    swc1    $f16, RCSM_F0+0x40($sp)
    swc1    $f17, RCSM_F0+0x44($sp)
    swc1    $f18, RCSM_F0+0x48($sp)
    swc1    $f19, RCSM_F0+0x4C($sp)
    swc1    $f20, RCSM_F0+0x50($sp)
    swc1    $f21, RCSM_F0+0x54($sp)
    swc1    $f22, RCSM_F0+0x58($sp)
    swc1    $f23, RCSM_F0+0x5C($sp)
    swc1    $f24, RCSM_F0+0x60($sp)
    swc1    $f25, RCSM_F0+0x64($sp)
    swc1    $f26, RCSM_F0+0x68($sp)
    swc1    $f27, RCSM_F0+0x6C($sp)
    swc1    $f28, RCSM_F0+0x70($sp)
    swc1    $f29, RCSM_F0+0x74($sp)
    swc1    $f30, RCSM_F0+0x78($sp)
    swc1    $f31, RCSM_F0+0x7C($sp)


    lui $k0, %hi(g_rcsm_plugin_gp)
    lw $gp, %lo(g_rcsm_plugin_gp)($k0)
    lw $a0, 0x124($sp)
    lw $a1, RCSM_V0($sp)
    jal rcsm_menu_hook_c
    nop
    sw $v0, RCSM_V0($sp)
    lui $k0, %hi(g_rcsm_menu_active_hooks)
    lw $k1, %lo(g_rcsm_menu_active_hooks)($k0)
    addiu $k1, $k1, -1
    sw $k1, %lo(g_rcsm_menu_active_hooks)($k0)
    lwc1    $f0,  RCSM_F0+0x00($sp)
    lwc1    $f1,  RCSM_F0+0x04($sp)
    lwc1    $f2,  RCSM_F0+0x08($sp)
    lwc1    $f3,  RCSM_F0+0x0C($sp)
    lwc1    $f4,  RCSM_F0+0x10($sp)
    lwc1    $f5,  RCSM_F0+0x14($sp)
    lwc1    $f6,  RCSM_F0+0x18($sp)
    lwc1    $f7,  RCSM_F0+0x1C($sp)
    lwc1    $f8,  RCSM_F0+0x20($sp)
    lwc1    $f9,  RCSM_F0+0x24($sp)
    lwc1    $f10, RCSM_F0+0x28($sp)
    lwc1    $f11, RCSM_F0+0x2C($sp)
    lwc1    $f12, RCSM_F0+0x30($sp)
    lwc1    $f13, RCSM_F0+0x34($sp)
    lwc1    $f14, RCSM_F0+0x38($sp)
    lwc1    $f15, RCSM_F0+0x3C($sp)
    lwc1    $f16, RCSM_F0+0x40($sp)
    lwc1    $f17, RCSM_F0+0x44($sp)
    lwc1    $f18, RCSM_F0+0x48($sp)
    lwc1    $f19, RCSM_F0+0x4C($sp)
    lwc1    $f20, RCSM_F0+0x50($sp)
    lwc1    $f21, RCSM_F0+0x54($sp)
    lwc1    $f22, RCSM_F0+0x58($sp)
    lwc1    $f23, RCSM_F0+0x5C($sp)
    lwc1    $f24, RCSM_F0+0x60($sp)
    lwc1    $f25, RCSM_F0+0x64($sp)
    lwc1    $f26, RCSM_F0+0x68($sp)
    lwc1    $f27, RCSM_F0+0x6C($sp)
    lwc1    $f28, RCSM_F0+0x70($sp)
    lwc1    $f29, RCSM_F0+0x74($sp)
    lwc1    $f30, RCSM_F0+0x78($sp)
    lwc1    $f31, RCSM_F0+0x7C($sp)

    lw      $k0, RCSM_FCR31($sp)
    ctc1    $k0, $31
    lw      $k0, RCSM_HI($sp)
    mthi    $k0
    lw      $k0, RCSM_LO($sp)
    mtlo    $k0

    lw      $at, RCSM_AT($sp)
    lw      $v0, RCSM_V0($sp)
    lw      $v1, RCSM_V1($sp)
    lw      $a0, RCSM_A0($sp)
    lw      $a1, RCSM_A1($sp)
    lw      $a2, RCSM_A2($sp)
    lw      $a3, RCSM_A3($sp)
    lw      $t0, RCSM_T0($sp)
    lw      $t1, RCSM_T1($sp)
    lw      $t2, RCSM_T2($sp)
    lw      $t3, RCSM_T3($sp)
    lw      $t4, RCSM_T4($sp)
    lw      $t5, RCSM_T5($sp)
    lw      $t6, RCSM_T6($sp)
    lw      $t7, RCSM_T7($sp)
    lw      $s0, RCSM_S0($sp)
    lw      $s1, RCSM_S1($sp)
    lw      $s2, RCSM_S2($sp)
    lw      $s3, RCSM_S3($sp)
    lw      $s4, RCSM_S4($sp)
    lw      $s5, RCSM_S5($sp)
    lw      $s6, RCSM_S6($sp)
    lw      $s7, RCSM_S7($sp)
    lw      $t8, RCSM_T8($sp)
    lw      $t9, RCSM_T9($sp)
    lw      $k0, RCSM_K0($sp)
    lw      $k1, RCSM_K1($sp)
    lw      $gp, RCSM_GP($sp)
    lw      $fp, RCSM_FP($sp)
    lw      $ra, 0x120($sp)
    jr      $ra
    addiu   $sp, $sp, 0x130

.end rcsm_menu_hook_common
