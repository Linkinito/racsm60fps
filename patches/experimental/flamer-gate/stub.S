# FlamerGate hooks (FG-v2.2), after GPT's two-hook design plus the mod19 reach hook
# (research/v2/otto-flamer-static-20261003/REPORT.md, "Two hooks, no callback-entry early return").
#
# fg_gate layout (gate.c): 0 enabled, 4 frame-counter address, 8 run parity P,
# 12 original query target, 16 query run count, 20 query skip count,
# 24 reach store run count, 28 reach store skip count, 32 latch clear count,
# 36 latch retain count.
# Frame phase test: the query runs and the latch is cleared when (C & 1) == P.
	.set noreorder
	.set noat
	.text

# Query hook: reached by `jal fg_query_hook` written over the callback's
# `jal query` (its delay slot `move a2,s2` is kept). Call boundary: t8, t9, at
# are caller-saved, so they are used without saving. a0-a3, saved GPRs, f20-f30,
# sp and ra are untouched. Run: tail-jump to the query (it returns to the game
# caller). Skip: return the cached distance pvar+0x278 in f0, as the query would.
	.globl fg_query_hook
	.type fg_query_hook, @function
fg_query_hook:
	lui   $t9, %hi(fg_gate)
	addiu $t9, $t9, %lo(fg_gate)
	lw    $t8, 0($t9)            # enabled?
	beqz  $t8, 1f
	nop
	lw    $t8, 4($t9)            # C
	lw    $t8, 0($t8)
	andi  $t8, $t8, 1
	lw    $at, 8($t9)            # P
	bne   $t8, $at, 2f
	nop
1:	lw    $t8, 16($t9)           # run
	addiu $t8, $t8, 1
	sw    $t8, 16($t9)
	lw    $t9, 12($t9)
	jr    $t9
	nop
2:	lw    $t8, 20($t9)           # skip
	addiu $t8, $t8, 1
	sw    $t8, 20($t9)
	lw    $t8, 0x58($a0)         # pvar
	jr    $ra
	lwc1  $f0, 0x278($t8)        # cached beam distance (GPT: initialized in both initializers)
	.size fg_query_hook, .-fg_query_hook

# Clear hook: reached by `j fg_clear_hook` written over `sb zero,0x15(s0)`;
# the original next instruction `lbu a0,0x46(s6)` runs in the jump's delay slot,
# so a0 is the callback's firing byte here. Mid-function: every register used
# is saved and restored. Clears the latch unless the gate is enabled, the
# callback is firing (a0 == 1) and the frame is off-phase, in which case the
# latch is retained for the next frame. Returns to clear site + 8 through a
# `j` word written by gate.c at install time (fg_clear_return).
	.globl fg_clear_hook
	.type fg_clear_hook, @function
fg_clear_hook:
	addiu $sp, $sp, -16
	sw    $t8, 0($sp)
	sw    $t9, 4($sp)
	sw    $at, 8($sp)
	lui   $t9, %hi(fg_gate)
	addiu $t9, $t9, %lo(fg_gate)
	lw    $t8, 0($t9)            # enabled?
	beqz  $t8, 1f
	nop
	addiu $at, $zero, 1
	bne   $a0, $at, 1f           # inactive callback consumes the latch normally
	nop
	lw    $t8, 4($t9)            # C
	lw    $t8, 0($t8)
	andi  $t8, $t8, 1
	lw    $at, 8($t9)            # P
	bne   $t8, $at, 2f           # off-phase: retain
	nop
1:	sb    $zero, 0x15($s0)       # the original clear
	lw    $t8, 32($t9)
	addiu $t8, $t8, 1
	b     3f
	sw    $t8, 32($t9)
2:	lw    $t8, 36($t9)
	addiu $t8, $t8, 1
	sw    $t8, 36($t9)
3:	lw    $t8, 0($sp)
	lw    $t9, 4($sp)
	lw    $at, 8($sp)
	.globl fg_clear_return
fg_clear_return:
	.word 0                      # rewritten at install: j <clear site + 8> (nop until then)
	addiu $sp, $sp, 16           # delay slot of that j
	.size fg_clear_hook, .-fg_clear_hook

# Reach hook (FG-v2.2): reached by `j fg_reach_hook` written over the mod19 reach
# store `swc1 f12,0x278(s0)` in the callback (`reach += pvar+0x10 * K`); the next
# original instruction runs in the jump's delay slot. On off-phase frames the
# store is skipped, so the reach only advances on frames whose query runs, as in
# A0 (live 2026-10-03: without it the reach overshot 39 up to 66 with the gate).
# Mid-function: registers used are saved and restored.
	.globl fg_reach_hook
	.type fg_reach_hook, @function
fg_reach_hook:
	addiu $sp, $sp, -16
	sw    $t8, 0($sp)
	sw    $t9, 4($sp)
	sw    $at, 8($sp)
	lui   $t9, %hi(fg_gate)
	addiu $t9, $t9, %lo(fg_gate)
	lw    $t8, 0($t9)            # enabled?
	beqz  $t8, 1f
	nop
	lw    $t8, 4($t9)            # C
	lw    $t8, 0($t8)
	andi  $t8, $t8, 1
	lw    $at, 8($t9)            # P
	bne   $t8, $at, 2f           # off-phase: skip the store
	nop
1:	swc1  $f12, 0x278($s0)       # the original store
	lw    $t8, 24($t9)
	addiu $t8, $t8, 1
	b     3f
	sw    $t8, 24($t9)
2:	lw    $t8, 28($t9)
	addiu $t8, $t8, 1
	sw    $t8, 28($t9)
3:	lw    $t8, 0($sp)
	lw    $t9, 4($sp)
	lw    $at, 8($sp)
	.globl fg_reach_return
fg_reach_return:
	.word 0                      # rewritten at install: j <reach site + 8>
	addiu $sp, $sp, 16           # delay slot of that j
	.size fg_reach_hook, .-fg_reach_hook

# ---------------------------------------------------------------------------
# FG-v3: deferred secondary flame damage companion (GPT design, task 4 of
# research/v2/weapons-finalize-static-20261003/REPORT.md). Two sites in the
# secondary-damage callback, each replaced by a single `j hook` whose delay
# slot is the original second instruction (it only computes a0, recomputed here).
# Scope (else original behaviour): gate enabled, record origin == 10
# (Flamethrower), non-null target with a group whose hash is not 0x3795CB33
# (Spitfire fireball). Phase: same C/P as the query gate.
# fg_gate: 48 dmg run, 52 dmg skip, 56 dmg bypass, 60 age run, 64 age skip,
# 68 age bypass. Return slots are `j` words written at install.

	.globl fg_dmg_hook
	.type fg_dmg_hook, @function
fg_dmg_hook:                          # at site: s3 = target, s5 = origin, s6 = owner
	addiu $sp, $sp, -16
	sw    $t8, 0($sp)
	sw    $t9, 4($sp)
	sw    $at, 8($sp)
	lui   $t9, %hi(fg_gate)
	addiu $t9, $t9, %lo(fg_gate)
	lw    $t8, 0($t9)
	beqz  $t8, 9f                     # gate off: bypass
	addiu $at, $zero, 10
	bne   $s5, $at, 9f                # not Flamethrower origin
	nop
	beqz  $s3, 9f
	nop
	lw    $t8, 0x40($s3)              # target group
	beqz  $t8, 9f
	nop
	lw    $t8, 0x30($t8)              # group hash
	lui   $at, 0x3795
	ori   $at, $at, 0xCB33
	beq   $t8, $at, 9f                # Spitfire: bypass
	nop
	lw    $t8, 4($t9)                 # C
	lw    $t8, 0($t8)
	andi  $t8, $t8, 1
	lw    $at, 8($t9)                 # P
	bne   $t8, $at, 8f                # off-phase: skip damage
	nop
	lw    $t8, 48($t9)                # run
	addiu $t8, $t8, 1
	b     7f
	sw    $t8, 48($t9)
9:	lw    $t8, 56($t9)                # bypass (original behaviour)
	addiu $t8, $t8, 1
	sw    $t8, 56($t9)
7:	lw    $t8, 0($sp)
	lw    $t9, 4($sp)
	lw    $at, 8($sp)
	lw    $a0, 0x64($s0)              # replayed original pair
	andi  $a0, $a0, 8
	.globl fg_dmg_run_ret
fg_dmg_run_ret:
	.word 0                           # j <damage site + 8> (original branch)
	addiu $sp, $sp, 16
8:	lw    $t8, 52($t9)                # skip
	addiu $t8, $t8, 1
	sw    $t8, 52($t9)
	lw    $t8, 0($sp)
	lw    $t9, 4($sp)
	lw    $at, 8($sp)
	addiu $sp, $sp, 16
	.globl fg_dmg_skip_ret
fg_dmg_skip_ret:
	.word 0                           # j <original branch target: post-damage lookup>
	swc1  $f22, 0x2C($sp)             # the original branch delay write (GPT: mandatory)
	.size fg_dmg_hook, .-fg_dmg_hook

	.globl fg_age_hook
	.type fg_age_hook, @function
fg_age_hook:                          # at site: s3 = relooked-up record
	addiu $sp, $sp, -16
	sw    $t8, 0($sp)
	sw    $t9, 4($sp)
	sw    $at, 8($sp)
	lui   $t9, %hi(fg_gate)
	addiu $t9, $t9, %lo(fg_gate)
	lw    $t8, 0($t9)
	beqz  $t8, 9f
	nop
	lw    $t8, 0x18($s3)              # record origin
	addiu $at, $zero, 10
	bne   $t8, $at, 9f
	nop
	lw    $t8, 0($s3)                 # record target
	beqz  $t8, 9f
	nop
	lw    $t8, 0x40($t8)
	beqz  $t8, 9f
	nop
	lw    $t8, 0x30($t8)
	lui   $at, 0x3795
	ori   $at, $at, 0xCB33
	beq   $t8, $at, 9f
	nop
	lw    $t8, 4($t9)                 # C
	lw    $t8, 0($t8)
	andi  $t8, $t8, 1
	lw    $at, 8($t9)                 # P
	bne   $t8, $at, 8f                # off-phase: no age decrement
	nop
	lw    $t8, 60($t9)
	addiu $t8, $t8, 1
	b     7f
	sw    $t8, 60($t9)
9:	lw    $t8, 68($t9)
	addiu $t8, $t8, 1
	sw    $t8, 68($t9)
7:	lw    $t8, 0($sp)
	lw    $t9, 4($sp)
	lw    $at, 8($sp)
	lw    $a0, 8($s3)                 # replayed original pair
	addiu $a0, $a0, -1
	.globl fg_age_run_ret
fg_age_run_ret:
	.word 0                           # j <age site + 8> (original branch, delay store)
	addiu $sp, $sp, 16
8:	lw    $t8, 64($t9)
	addiu $t8, $t8, 1
	sw    $t8, 64($t9)
	lw    $t8, 0($sp)
	lw    $t9, 4($sp)
	lw    $at, 8($sp)
	addiu $sp, $sp, 16
	.globl fg_age_skip_ret
fg_age_skip_ret:
	.word 0                           # j <original branch target: epilogue>
	nop
	.size fg_age_hook, .-fg_age_hook

# ---------------------------------------------------------------------------
# FG-v4 extras (gate.c wg[]): 24 flag address, 56/60 flag run/skip,
# 64/68 damage run/skip, 72 frame-counter address, 76 run parity P, 4 applied mask.

# LaserTracer flag hook: reached by `j wg_flag_hook` written over the reader's
# `lui a0,hi`; its delay slot (the reader's `lbu a0,lo(a0)`) is a nop while
# installed. Reloads the flag into a0 and clears it on off-phase frames, so the
# flag-gated block (ammo countdown) runs at 30 Hz in C1 as in A0. Mid-function:
# t8, t9, at are saved and restored. Returns to the reader's `beq a0,zero`.
	.globl wg_flag_hook
	.type wg_flag_hook, @function
wg_flag_hook:
	addiu $sp, $sp, -16
	sw    $t8, 0($sp)
	sw    $t9, 4($sp)
	sw    $at, 8($sp)
	lui   $t9, %hi(wg)
	addiu $t9, $t9, %lo(wg)
	lw    $a0, 24($t9)           # flag address
	lbu   $a0, 0($a0)            # the original load
	beqz  $a0, 3f                # flag already clear: nothing to gate
	nop
	lw    $t8, 4($t9)            # applied mask
	andi  $t8, $t8, 1
	beqz  $t8, 3f
	nop
	lw    $t8, 72($t9)           # C
	lw    $t8, 0($t8)
	andi  $t8, $t8, 1
	lw    $at, 76($t9)           # P
	bne   $t8, $at, 2f
	nop
	lw    $t8, 56($t9)           # run
	addiu $t8, $t8, 1
	b     3f
	sw    $t8, 56($t9)
2:	move  $a0, $zero             # off-phase: the block sees the flag clear
	lw    $t8, 60($t9)           # skip
	addiu $t8, $t8, 1
	sw    $t8, 60($t9)
3:	lw    $t8, 0($sp)
	lw    $t9, 4($sp)
	lw    $at, 8($sp)
	.globl wg_flag_return
wg_flag_return:
	.word 0                      # rewritten at install: j <reader + 8> (the beq)
	addiu $sp, $sp, 16           # delay slot of that j
	.size wg_flag_hook, .-wg_flag_hook

# LaserTracer damage hook: reached by `jal wg_dmg_hook` written over the beam
# update's `jalr t2` (same ra; the original delay slot `move t1,s0` still runs).
# Call boundary: t8, t9, at are free; argument registers a0-a3, t0-t3 untouched.
# On-phase: tail-jump to the handler in t2. Off-phase: no call, v0 = 0.
	.globl wg_dmg_hook
	.type wg_dmg_hook, @function
wg_dmg_hook:
	lui   $t9, %hi(wg)
	addiu $t9, $t9, %lo(wg)
	lw    $t8, 4($t9)            # applied mask
	andi  $t8, $t8, 1
	beqz  $t8, 1f
	nop
	lw    $t8, 72($t9)           # C
	lw    $t8, 0($t8)
	andi  $t8, $t8, 1
	lw    $at, 76($t9)           # P
	bne   $t8, $at, 2f
	nop
1:	lw    $t8, 64($t9)           # run
	addiu $t8, $t8, 1
	sw    $t8, 64($t9)
	jr    $t2
	nop
2:	lw    $t8, 68($t9)           # skip
	addiu $t8, $t8, 1
	sw    $t8, 68($t9)
	jr    $ra
	move  $v0, $zero
	.size wg_dmg_hook, .-wg_dmg_hook
