# FlamerGate (experimental)

Level-independent PSP plugin for the Flamethrower 30 Hz damage-query candidate.

- FG-v0 (2026-10-03): observation only. Finds the level module `rcp1`, locates
  the Flamethrower update, latch set, callback, latch clear, query and the
  query call by masked signatures, publishes `fg_state` and appends to
  `ms0:/PSP/PLUGINS/FlamerGate/log.txt`. Writes no game memory.
- FG-v1 (2026-10-03, SUPERSEDED before any run): single query-call gate. Defects
  found against GPT's design: no f0 return on skipped queries, latch always
  cleared, no C1 guard. Kept in Git history only.
- FG-v1 original description: adds a
  guarded, reversible call gate. Requesting mode 1 (`flamer-gate.py --mode 1`)
  replaces the query call `jal query` by `jal fg_gate_stub` only if the current
  word is the expected original; the stub (`stub.S`, temporaries only) runs the
  query on frames whose level frame-counter parity equals `--parity` and
  otherwise returns `fg_gate[6]` (0) without calling it. Mode 0 restores the
  word. The frame counter is derived in the plugin from signature windows of
  its lui/lo references. Default mode 0 (`--default-mode 1` arms at load).
  Gate site and skip semantics are a candidate mechanism: confirm against
  GPT's design (research/inbox/PROMPT_GPT_OTTO_FLAMER_20261003.md, task B),
  including the query return value use and the release-fireball path.

Build (signatures generated from a local pack into the ignored build dir):

    python patches/experimental/flamer-gate/build.py --name FG-v0 \
        --pack research/live-tests/_local/sigpack-level01.json

Install: copy `build/<name>/FlamerGate/` to `PSP/PLUGINS/FlamerGate/`.
Read state: `python tools/runtime/flamer-gate.py --manifest build/<name>/manifest.json [--map <levelmap.json>]`.

Note: PPSSPP loads plugins at game boot. A savestate taken without the plugin
restores memory without it; test through a normal game/save load.
- FG-v2 (2026-10-03, built, NOT runtime-validated, not installed): GPT's two-hook
  design (research/v2/otto-flamer-static-20261003/REPORT.md, task B). Query hook
  returns the cached distance pvar+0x278 in f0 on skipped frames; clear hook keeps
  the latch on off-phase frames while firing; installs only when the shared-delta
  word shows C1 core, restores when C1 is left; refuses unexpected words or a
  clear site in a delay slot. Limits (GPT): query-owned visuals/RNG at 30 Hz;
  deferred secondary damage not gated; phase P = (F0+1)&1 chosen tool-side.

- FG-v2.1 (2026-10-03, live-validated on Quodrona, fg21-001): code reads after
  icache invalidation (PPSSPP JIT emuhack words) and post-install verification.
  C1+gate: query entry 30/s, update/callback 60/s, ammo 4/s.
- FG-v2.2 (2026-10-03, built, installed, NOT yet run): adds a third hook on the
  mod19 reach store `swc1 f12,0x278(s0)` (`reach += pvar+0x10*K`), found
  structurally in the callback (unique match required). On off-phase frames the
  store is skipped. Reason (live, otto-fg21-001): with FG-v2.1 and mod19 the
  query saw reach 21..66 instead of A0's 21/30/39 and missed Otto; without
  mod19 the reach stayed 12.0 in A0 and C1+gate. The deferred secondary damage
  is still ungated (26.0 per contact hit in C1+gate vs 21.33 in C1).

- FG-v2.2 live (otto-fg22-001): reach cycle back to A0's 21/30/39; Otto contact
  hits 29.97/s (A0 29.96/s) at 26.0 per hit (A0 21.33): deferred damage ungated.
- FG-v3 (2026-10-03, built, NOT yet run): deferred secondary damage companion
  (GPT design). Two single-word hooks found by authored instruction patterns
  (damage `lw a0,0x64(s0); andi a0,a0,8; bne a0,zero; swc1 f22,0x2C(sp)`,
  age `lw a0,8(s3); addiu a0,a0,-1; bne a0,zero; sw a0,8(s3)`, unique, age
  within 0x200 after damage); skip targets are the original branch targets.
  Scope: gate enabled, record origin 10, target group hash != 0x3795CB33
  (Spitfire); off-phase skips the damage (replaying the swc1 delay write) and
  the age decrement. Optional: absent patterns leave the query gate active.
  Limit: owner (player) not checked; origin 10 assumed player-only.
- FG-v3 live (Quodrona otto-fg3-001..005, fireball-001, flamer-ranks-001;
  Pokitaru flamer-fg3-001): Flamethrower damage per A0 frame equals A0 at
  V1/V4/V5/V8, hit rate equal at matched distance/facing, fireball unchanged.
- FG-v4 (2026-10-03, built and installed, NOT yet run; FG-v3 behaviour unchanged
  while wg[0] = 0): independent extras requested by `flamer-gate.py --extras
  MASK` (bit 0 LaserTracer, bit 1 AgentsGlove), C1 only, run parity fg_ctl[5].
  Laser: the unique reader of the first-substep flag gets `j wg_flag_hook`
  (delay slot nop; the hook reloads the flag and clears it off-phase, ammo
  countdown at 30 Hz) and the 1..4 beam damage `jalr t2` calls get
  `jal wg_dmg_hook` (off-phase: no call, v0 = 0; return contract UNKNOWN).
  Agents: both lifetime step literals `lui a2,0xBF80` -> `lui a2,0xBF00`.
  Basis: debugger emulations on Quodrona (laser-001, weapons-otto-001);
  offline census `research/scripts/scan-weapon-gate-sites.py`: flag writer,
  reader, 4 damage calls and the agent pair unique in LEVEL_01..10, 23, 24;
  absent in 15..22 (no LaserTracer/agents code with these shapes).
- FG-v5 (2026-10-03, built and installed over FG-v4, NOT yet run): extras are a
  table of guarded literal patches `wg_lit` (address, original, new, request
  bit) plus the laser hooks; each write invalidates from the word before it
  (delay slots compile with their branch). New bits: 2 weapon delta (the
  weapon-update call's `mov.s f12,f20` at flag writer + 0x44 -> `add.s
  f12,f20,f20`, only when the original loop limit is 2: never LEVEL_02),
  3 BlasterShot speed/life 30.0 -> 60.0 (signatures generated offline from
  LEVEL_01 by `research/scripts/make-offline-sigpack.py` into an ignored pack;
  `build.py --extra-pack`). Census: research/v2/port-census-20261003/REPORT.md.
- FG-v5.1 (installed, NOT yet run): the laser flag gate uses the opposite
  parity of the damage gate (Pstate = P ^ 1), after GPT's laser contract
  (research/v2/laser-gate-static-20261003/REPORT.md): A0's first-pass state
  and pair-end damage fall on opposite phases. Skipped damage calls return
  v0 = 0 (target stays opaque as after a non-kill hit; never 3).
 (owner present): install over FG-v0, boot, confirm
`frameCounter` matches the level map, then `--mode 1 --parity 1`, verify
`gate.queryRun`/`querySkip` and `latchClear`/`latchRetain` alternate and count-multi shows the query call at
30/s in C1 with update and ammo unchanged; `--mode 0` restores.

Status: FG-v3 live-validated on Quodrona and Pokitaru (Flamethrower); FG-v4/FG-v5 extras BUILT_EXPERIMENTAL_NOT_RUNTIME_VALIDATED.
