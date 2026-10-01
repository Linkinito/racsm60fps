/* Particle animator redirect stub (LEVEL_01 walker 0x8CC18, site 0x8CE54 `jalr t0`).
 * The walker loads the animator address into t0 and calls it through a pointer, so
 * it follows the standard ABI. The site becomes `jal ig_pwrap_stub`; this stub saves
 * t0 (the animator) and tail-jumps to the C wrapper with ra/a0-a3 untouched. */
.set noreorder
.set noat
.text
.globl ig_pwrap_stub
.ent ig_pwrap_stub
ig_pwrap_stub:
    lui   $1, %hi(ig_ptarget)
    j     ig_particles
    sw    $8, %lo(ig_ptarget)($1)
.end ig_pwrap_stub

/* Register-transparent displacement-halving stubs (IG-v11).
 * Slot n uses ig_disp[n*8 .. n*8+7]: [0] enable, [1] callee, [2] calls, [3] pad,
 * [4..7] halved copy of the float[4] displacement passed in a2. Only $at and a2
 * change (a2 points to the copy); t0-t3 are saved/restored on the stack, so callers
 * relying on non-standard register preservation (cf. 0x6C318) stay safe.
 * Halving is done on the bit pattern (exponent - 1; tiny values keep sign only). */
.macro HALF off
    lw    $9, \off($6)
    srl   $10, $9, 23
    andi  $10, $10, 0xff
    sltiu $11, $10, 2
    bnez  $11, 1f
    lui   $11, 0x80
    b     2f
    subu  $9, $9, $11
1:  lui   $11, 0x8000
    and   $9, $9, $11
2:  sw    $9, 16+\off($8)
.endm

.macro DISPSTUB n
.globl ig_disp_stub\n
.ent ig_disp_stub\n
ig_disp_stub\n:
    lui   $1, %hi(ig_disp+\n*32)
    addiu $1, $1, %lo(ig_disp+\n*32)
    addiu $sp, $sp, -16
    sw    $8, 0($sp)
    sw    $9, 4($sp)
    sw    $10, 8($sp)
    sw    $11, 12($sp)
    move  $8, $1
    lw    $9, 0($8)
    beqz  $9, 9f
    nop
    lw    $9, 8($8)
    addiu $9, $9, 1
    sw    $9, 8($8)
    HALF 0
    HALF 4
    HALF 8
    lw    $9, 12($6)
    sw    $9, 28($8)
    addiu $6, $8, 16
9:  lw    $1, 4($8)
    lw    $8, 0($sp)
    lw    $9, 4($sp)
    lw    $10, 8($sp)
    lw    $11, 12($sp)
    jr    $1
    addiu $sp, $sp, 16
.end ig_disp_stub\n
.endm

DISPSTUB 0
DISPSTUB 1
DISPSTUB 2
DISPSTUB 3
DISPSTUB 4

/* PathAnimal walk speed (IG-v13). LEVEL_01 0x15DE70 `lwc1 f12,4(s1)` loads the
 * per-instance speed (units per update, config at moby+0x54) that scales the forward
 * vector in `pos += fwd * speed`. The site becomes `jal ig_pa_speed`; the delay slot
 * (0x15DE74 `lwc1 f13,0x20(s0)`) is unchanged. f14 is reloaded at 0x15DE78, so it is
 * free here; ra is restored from the stack by PathAnimal_Update before returning.
 * Returns f12 = speed * 0.5 and counts calls in ig_cnt[0]. */
.globl ig_pa_speed
.ent ig_pa_speed
ig_pa_speed:
    addiu $sp, $sp, -8
    sw    $8, 0($sp)
    lui   $1, %hi(ig_cnt)
    lw    $8, %lo(ig_cnt)($1)
    addiu $8, $8, 1
    sw    $8, %lo(ig_cnt)($1)
    lw    $8, 0($sp)
    addiu $sp, $sp, 8
    lui   $1, 0x3F00
    mtc1  $1, $f14
    lwc1  $f12, 4($17)
    jr    $31
    mul.s $f12, $f12, $f14
.end ig_pa_speed

/* Particle allocation throttle entry (IG-v15). The two pool allocator entries call the
 * core allocator 0x8C47C(out, pool, a2, count) with `jal` at 0x8C894 (caller ra saved at
 * 0x10(sp)) and 0x8C8E4 (ra at 0x18(sp)). Those sites become `jal ig_spawn_stubN`, which
 * passes the spawning call site as 5th argument (t0) to the C function ig_spawn. */
.globl ig_spawn_stub0
.ent ig_spawn_stub0
ig_spawn_stub0:
    j     ig_spawn
    lw    $8, 16($sp)
.end ig_spawn_stub0
.globl ig_spawn_stub1
.ent ig_spawn_stub1
ig_spawn_stub1:
    j     ig_spawn
    lw    $8, 24($sp)
.end ig_spawn_stub1
