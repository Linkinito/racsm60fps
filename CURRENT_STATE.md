# Current checkpoint - 2026-09-30 (late session)

Priority 0: UCES00420 original 30 -> faithful 60 FPS parity; experimental only.
Branch v2-research (local-only; history rewritten 2026-09-30, older SHAs quoted in
reports no longer resolve). Full chronology and superseded details:
research/live-tests/pokitaru/session-2026-09-30/SESSION-LOG.md.

## Environment

PPSSPP 1.20.4, Vulkan, RTX 3060 (AMD iGPU driver updated; OpenGL start faults
gone). FileLogging off. Only plugin enabled: InterpGate IG-v9 (passive unless
tools install redirects). D1/D0/recorder mapped false (3 plugins crashed load).
LEVEL_01 base 0x09139D00 without plugins; ~0x0916BD00-0x0916CD00 with InterpGate.

## Established (owner-observed unless stated)

- C1 (3 words) fixes Ratchet and everything that is delta-based (animation
  system: anim time += delta, events fire on time). Remaining 2x = fixed per-call
  steps, mostly inside pump-1 entity callbacks (0x15230 -> 0x6B7F4, jalr 0x6B9B8).
- Rejected global arms: D1, G1/G/GI (half-rate + blend: judder, list rebuild,
  platform bugs), F1 (1/30 immediates), H (halve float changes), I (int +-1 rule).
- Working targeted fixes (tools/runtime/fixes.py, IG-v7):
  nav = halve ground-navigation displacement (0x2A8F0 via 0x29188/0x29334;
  Crab, TMRobotHead/TorsoB, TrainingBot) -> crab speed OK;
  crab = attack frame threshold data 0x2CF3C8 27.0 -> 54.0 -> timing OK;
  debris = shrapnel physics half-step (0x191D7C x8) runs, not crate debris;
  animdisp (0x6C318 x38) PARKED: freezes game (register convention; needs asm).
- Player health: player struct = seg1 base(+0x2DD108)+0x5A838; health f32 +0x964.
- Class table: research/v2/class-table/level01-classes.json (150 classes, update
  callbacks, embedded original field definitions for 67).
- PARTICLES: main-update call 0x15348 -> 0x8CC18 = particle system (ablation:
  waterfall waves/mist/splashes vanish then burst back). Update and draw are
  coupled (no half-rate). Walker dispatches per-pool animators via jalr 0x8CE54
  (t0 = pool descriptor +4, a1 = first particle index). Active near waterfall:
  0x7E810, 0xDE23C (waterfall; life += -1.0 via lui 0xBF80 at 0xDE344, gravity
  slot +0x1C 0.008), 0xDE8A8. Animators are fixed-step per particle.
- Particle half-step at walker site 0x8CE54 (jalr t0 -> asm stub ig_pwrap_stub,
  C wrapper ig_particles, fix `particles` in fixes.py, waterfall animator only):
  IG-v8 flickered (dir vector shrank), IG-v9 still flickered/flashes. Cause found:
  0xDE23C swap-removes dead particles (copies last 80-byte record into the slot,
  0xDE458..0xDE484, first/count shrink), breaking slot identity. IG-v10 (BUILT,
  NOT INSTALLED/TESTED) corrects only live slots with unchanged per-particle
  constants (+0x1C/+0x3C/+0x44). Installed plugin is still IG-v9 (fix off by default).
  Waterfall small waves use another animator (0x7E810 or 0xDE8A8), not corrected.

## Tools

pump-gate.py, frametime.py, interp-gate.py (legacy modes), fixes.py, crab-probe.py,
write-probe.py (--address/--deref/--change), call-probe.py, call-toggle.py
(ablation), value-scan.py, group-census.py (live classes); research/scripts:
shared-helper-census.py, triage-helpers.py, class-table.py.

## Exact NEXT ACTION

1. Install/test IG-v10 on the waterfall (C1 vs C1+particles). Then particle animators: enumerate all animator functions (pool descriptors), read
   each one's per-particle update, and add a half-step correction per animator
   (lifetime step, velocity/gravity, position) in the plugin; test on waterfall,
   then crate debris and fire. Goal: few animators -> all particle effects.
2. Verify nav fix on TM robots / TrainingBot; continue enemy-by-enemy with the
   crab method (census -> write/call probes -> targeted constant or helper fix).
3. Later: self-applying plugin (no debugger), port fixes to other levels by
   signature, animdisp asm wrapper, weapons (LaserTracer drain, Blaster), FRONTEND
   intro/language skip as separate dev-convenience plugin (owner request).
4. Priority 2 (separate plugin, owner request 2026-10-01): docs/priority2/README.md
   indexes 15 workstreams (right stick, L2/R2, camera speed/FOV, loading 20 FPS,
   menus, blink, checkbox menu, debug menu, stats, objectives, RetroAchievements,
   free camera, draw distance, Miniturret). Doc-only so far, NOTHING measured
   (cloud session without game). Triage items 5-7 as possible Priority 0 defects first.
Next-session files: AGENTS.md, this file, session log,
patches/experimental/interp-gate/interp.c, tools/runtime/fixes.py.
