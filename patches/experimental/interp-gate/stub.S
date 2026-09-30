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
