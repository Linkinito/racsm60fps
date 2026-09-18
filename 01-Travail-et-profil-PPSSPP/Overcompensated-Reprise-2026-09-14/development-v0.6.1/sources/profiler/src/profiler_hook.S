/*
 * Transparent Allegrex trampoline for UCES-00420.
 *
 * A level-specific entry point is used for one important reason: its final
 * jump to the original wrapper is an immediate MIPS `j`.  No general-purpose
 * register has to carry the destination into the game, so the wrapper sees
 * every GPR, HI/LO, FCR31 and every scalar FPU register exactly as it did at
 * the redirected callsite.  The only temporary state is this PRX's own stack
 * frame.
 *
 * The original callsite `$ra` is stored by the small level stub before the
 * stub calls the shared body.  The shared body switches `$gp` to the value
 * captured by module_start(), calls a no-I/O C shim, restores the complete
 * machine state, and returns to the level stub.  The stub then restores the
 * original `$ra` and tail-jumps either to that level's verified two-pass
 * wrapper or to its verified one-pass helper.  The C runtime rewrites only
 * these PRX-owned `j` instructions when the game loader relocates the level.
 */

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

    .extern g_rcsm_plugin_gp
    .extern rcsm_profiler_hook_c

    .globl rcsm_profiler_hook_common
    .type rcsm_profiler_hook_common, @function
    .ent rcsm_profiler_hook_common
rcsm_profiler_hook_common:
    sw      $ra, RCSM_COMMON_RA($sp)
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

    /* The game owns $gp at the callsite.  Use the PRX's captured $gp only
       while executing the C shim, then restore the game value below. */
    lui     $k0, %hi(g_rcsm_plugin_gp)
    lw      $gp, %lo(g_rcsm_plugin_gp)($k0)
    lw      $a0, RCSM_ORIGINAL_RA($sp)
    jal     rcsm_profiler_hook_c
    nop

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
    lw      $ra, RCSM_COMMON_RA($sp)
    jr      $ra
    nop
    .end rcsm_profiler_hook_common
    .size rcsm_profiler_hook_common, .-rcsm_profiler_hook_common

    .macro RCSM_LEVEL_HOOK symbol, tail_symbol, wrapper
    .globl \symbol
    .type \symbol, @function
    .ent \symbol
\symbol:
    addiu   $sp, $sp, -RCSM_FRAME_SIZE
    sw      $ra, RCSM_ORIGINAL_RA($sp)
    jal     rcsm_profiler_hook_common
    nop
    lw      $ra, RCSM_ORIGINAL_RA($sp)
    .globl \tail_symbol
    .type \tail_symbol, @object
\tail_symbol:
    j       \wrapper
    .size \tail_symbol, .-\tail_symbol
    addiu   $sp, $sp, RCSM_FRAME_SIZE
    .end \symbol
    .size \symbol, .-\symbol
    .endm

    RCSM_LEVEL_HOOK rcsm_profiler_hook_l01, rcsm_profiler_tail_l01, 0x0914805C
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l01_one, rcsm_profiler_tail_l01_one, 0x09147F90
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l02, rcsm_profiler_tail_l02, 0x09148040
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l02_one, rcsm_profiler_tail_l02_one, 0x09147F74
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l03, rcsm_profiler_tail_l03, 0x09148080
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l03_one, rcsm_profiler_tail_l03_one, 0x09147FB4
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l04, rcsm_profiler_tail_l04, 0x09147E54
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l04_one, rcsm_profiler_tail_l04_one, 0x09147D88
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l05, rcsm_profiler_tail_l05, 0x0914805C
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l05_one, rcsm_profiler_tail_l05_one, 0x09147F90
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l06, rcsm_profiler_tail_l06, 0x09147EC4
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l06_one, rcsm_profiler_tail_l06_one, 0x09147DF8
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l07, rcsm_profiler_tail_l07, 0x0914805C
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l07_one, rcsm_profiler_tail_l07_one, 0x09147F90
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l08, rcsm_profiler_tail_l08, 0x091480B8
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l08_one, rcsm_profiler_tail_l08_one, 0x09147FEC
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l09, rcsm_profiler_tail_l09, 0x0914805C
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l09_one, rcsm_profiler_tail_l09_one, 0x09147F90
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l10, rcsm_profiler_tail_l10, 0x09147DD8
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l10_one, rcsm_profiler_tail_l10_one, 0x09147D0C
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l15, rcsm_profiler_tail_l15, 0x091475E8
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l15_one, rcsm_profiler_tail_l15_one, 0x0914751C
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l21, rcsm_profiler_tail_l21, 0x091475E8
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l21_one, rcsm_profiler_tail_l21_one, 0x0914751C
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l22, rcsm_profiler_tail_l22, 0x09147890
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l22_one, rcsm_profiler_tail_l22_one, 0x091477C4
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l23, rcsm_profiler_tail_l23, 0x09147ED4
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l23_one, rcsm_profiler_tail_l23_one, 0x09147E08
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l24, rcsm_profiler_tail_l24, 0x09147B74
    RCSM_LEVEL_HOOK rcsm_profiler_hook_l24_one, rcsm_profiler_tail_l24_one, 0x09147AA8

    .set at
    .set reorder
