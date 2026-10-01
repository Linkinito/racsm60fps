# Live session 2026-09-30 — startup recovery and global-approach experiments

Verbatim checkpoint log moved out of CURRENT_STATE.md on 2026-09-30 (history, not canon).

# Current checkpoint - 2026-09-30

Priority0 UCES00420 original30 -> faithful60 parity; experimental only.
Branch v2-research (local-only); history REWRITTEN 2026-09-30, so older SHAs
quoted below or in reports (5dc4f38, 589d1f1...) no longer resolve; use
commit subjects. Active task research/tasks/global-candidate-rollout-001.md.

## 2026-09-30 repository cleanup (Claude session)

Remote v2-research/codex branches deleted (contained game PRX, SAVEDATA,
dumps, disasm); only public main remains. Local history filtered (game-
derived paths + blobs >5 MB), ~250 MB -> ~4 MB; files kept on disk, ignored.
Pre-cleanup bundle: ../RAC_60FPS-backup-2026-09-30/ (private). Root docs
reorganized: README, docs/README (map), docs/TECHNICAL_OVERVIEW,
docs/PUBLICATION_POLICY, docs/fr/ETAT_DU_PROJET, old root docs in docs/legacy.
Root clutter moved to _local/ (ignored). No gameplay/runtime work this session.

## Owner direction and delivered candidate

GLOBAL inferred prototype first, A0/patch during play, measured local exceptions
later. No per-class proof gate for experiments. Do not resume cosmetic polish,
blind EnemyWave hunting or a new architecture audit as the main work.
Strategy reports/60FPS-STRATEGY-REVIEW-2026-09-27.md remains the decision source.
Latest owner asks when to open PPSSPP. Now ready for normal Pokitaru boot.

D1-v1-r2 BUILT, now DISABLED after owner-reported startup crash and loss of sound.
PPSSPP now cannot launch even with D1 disabled. Windows Event1000/1001 identifies amdxc64.dll31.0.21910.11004, exceptionc0000005 offseta331f (latest01:36:51 Paris). Fault location OBSERVED; root cause/audio relation UNKNOWN. No D1 acceptance.
Only D1Global plugin.ini mapping set false, closed-process check/readback OK;
original descriptor backed up under d1-global/deployment/disabled-<timestamp>.
Do not re-enable D1 or retry A0/D1 switches until startup fault is resolved.
patches/experimental/d1-global/README.md and
research/live-tests/pokitaru/d1-switch/REPORT.md carry scope/method/hashes.
LEVEL_01: C1 core3 +54 one-pass calls +Help +elevator initializer =59 words.
LEVEL_03: C1 core3 +32 one-pass calls +elevator initializer =36 words.
WF-002 keeps two passes (one site/module). No EnemyWave/cascade/wings extras.
15 legacy compiled profiles,15/21 excluded;11 more eligible not yet enrolled.
FRONTEND/16-20 outside compiled coverage. Broaden after technical acceptance;
first-level perfection is not required. Hot switch cannot reset spawned state.

Static arbitration: wrapper saves original scalars, first leaf call already gets
original args, second repeats on updated memory. Direct relocated JAL to leaf
implements one_pass without game code caves or plugin callbacks. Luna's initial
remapping/stub concern was rejected after exact disassembly and corrected.
Legacy full_layers base1 is NOT C1: extra constants/local scalar doubling omitted.
Broad one-pass gameplay correction remains INFERRED, not validated.

## Build, control and current operational state

Final PRX SHA256075eb500395fabc971b311105cbe2b39ad4ae0e3967eae006b2c8f9df1572e72.
Build manifest SHA2565d4925b248922e76fb8b7911c8de607ea86d63c417468a85b14e81693563db97.
324 compiled-MIPS transaction/rollback cases pass (offline-r2.json);38 controller
fixtures pass with passive D0/recorder,47 overlapping WF callsites accounted for
(controller-r3.json). Loader/JIT/monitor/gameplay not covered. Luna reviewed;
stale binding at successful module_stop fixed inr2, unload still not live-tested.

Installed only PSP/PLUGINS/D1Global, passive request0, PPSSPP closed, readback OK.
No existing plugins/assets/config changed. Existing plugin/debugger config true.
D1 controller owns A0/C1/D1; D0Temporal must stay passive. It writes only D1 ABI
request/module words; runtime checks module identity/extent/context/ownership and
restores transactionally. Ambiguity retains ownership; confirmed unload disarms.
Each normal load/residency requires inspect/rearm. Unknown profile stops trial.

Panel: http://127.0.0.1:8768/, process40400 relaunched after connection refused; HTTP200 rechecked.
Start via bundled Python tools/runtime/d0-switch-panel.py --candidate D1 --port 8768. Shared D0 server default preserved; old D0 controller
refuses D1Global and should not be used for this trial. Shared lock prevents both.
Page200/token substitution and unauthenticated POST403 checked; no game request.
Historical D0 hot acceptance remains in d0-switch/REPORT.md, not D1 evidence.

## Exact NEXT ACTION / next-session files

AGENTS -> CURRENT_STATE -> research/tasks/global-candidate-rollout-001.md.
Then research/live-tests/pokitaru/d1-switch/REPORT.md and D1 README above.
First restore emulator startup: latest Windows reports fault in AMD driver with D1 disabled. Preserve config/logs, inspect known prior AMD workaround and backend enum, then try a reversible backend override; no driver reinstall/PPSSPP version change without authorization. 2026-09-30: GraphicsBackend switched 0 (OPENGL) -> 3 (VULKAN) in Documents/PPSSPP/PSP/SYSTEM/ppsspp.ini (only that line; backup ppsspp.ini.before-vulkan-20260930.bak). Owner-OBSERVED 2026-09-30: PPSSPP starts with Vulkan and audio works (D1 still disabled). OpenGL/AMD fault is the likely startup blocker; relation to the earlier D1-enabled crash/audio loss UNKNOWN until D1 is re-enabled passively under Vulkan. 2026-09-30: D1Global mapping re-enabled (false->true), PPSSPP closed, descriptor byte-identical to original enabled one; PRX SHA256 075eb500... rechecked. D0Temporal/FamilyRecorder mappings unchanged (true). Owner boot 20:41-20:42: Vulkan start sometimes fails first (amdxc64.dll c0000005, driver 31.0.21910.11004, also seen with D1 disabled at 20:38) then boots; audio OK; crash when Pokitaru finishes loading (PPSSPPWindows64.exe+0x2cb9cf). OBSERVED in PPSSPP log: identical 'GPU CALL to illegal address 0000016c' right before both D1-enabled crashes (01:27 OpenGL, 20:42 Vulkan); absent in D1-disabled boot 20:39. Passive D1 (request0) performs no writes per runtime.c; leading hypothesis INFERRED: user-memory pressure with 3 plugins (D0+recorder+D1) -> failed game allocation (NULL+0x16c display list). Test now: D1 ALONE (D0Temporal/FamilyRecorder mappings set false, backups in d1-global/deployment/solo-test-20260930). Evidence excerpt local: research/live-tests/pokitaru/d1-switch/raw/ppsspp-log-tail-filtered-20260930.log. 2026-09-30 ~20:52: owner updated AMD iGPU driver (Ryzen 5 5600G Radeon) 31.0.21910.11004 -> 31.0.21925.1001; last amdxc64 crash 20:51:05, none after (owner: startup OK). PPSSPP renders on RTX 3060 (owner). PPSSPP FileLogging set False (log.txt had grown to 75 GB from D0 GetModuleIdList polling).
Luna wf_reuse_audit has a bounded read-only D1/D0 runtime/build startup comparison.
Read that handoff first; distinguish plugin loading/resources from armed policy.
Actual D1 request before failure UNKNOWN; user was following initial boot steps.
Fix passive startup only after cause narrowed; then restore original acceptance
plan (status, A0->D1->A0, ordinary play, early Kalidon). No gameplay parity claim.

Quota last checked100% five-hour used/0% remaining, weekly68%; checkpoint before
live work as requested. Raw build/tests/deployment outputs stay local ignored.

## 2026-09-30 first D1 live result (supersedes the D1 acceptance plan above)

Solo D1 boot under Vulkan: Pokitaru loads, no crash (memory-pressure hypothesis
for the 3-plugin crash CORROBORATED, not proven). Live status: magic D1G1,
passive, LEVEL_01 bound, 59 rules/152 guards verified. A0->D1 switch applied
(status2, generation2, raw/switch-A0-to-D1-*). Owner OBSERVED: 60 FPS everywhere
but NO visible difference from C1; everything still ~2x too fast. Interpretation
INFERRED: one-pass WF sites only restore single leaf calls; the dominant defect
is fixed-step work executed once per outer update, which D1 does not touch.
NEXT: test the global '30 Hz logic / 60 Hz presentation' hypothesis: locate the
object/group update pump in the LEVEL_01 main update and gate it to every
second outer frame (player/camera/render stay 60 Hz). D0/FamilyRecorder
remain disabled; keep plugin count minimal.

## 2026-09-30 E1 pump-gate result (tools/runtime/pump-gate.py, no plugins)

Base 0x09139D00 with no plugins. A0->C1->G1->A0 all verified; G1 counters
91 runs/92 skips in 3 s, accum 0x3C888889 (1/60). Owner OBSERVED in G1:
overall game speed returns to normal (TESTED-by-owner support that the dominant
2x defect lives in group pump 1 fixed-step callbacks); strong visible judder
(G1 unacceptable as-is); Blaster fire cooldown longer than A0 (a pump-1 object
takes part in Blaster firing); LaserTracer ammo drain still 2x (weapon/player
route, not pump 1; known C1 defect). Raw: research/live-tests/pokitaru/e1-pump-gate/raw.
Pump 1 per-entity dispatch: 0x6B9B0 lw a1,0x1C(group); 0x6B9B4 mov.s f12,f20;
0x6B9B8 jalr a1 (a0=entity, stride 0x80). Pump reads entity +0x30/+0x34/+0x38
(distance check; position INFERRED). Per-callback policy hook at 0x6B9B8 is
feasible. Open choice: position interpolation over a gated pump vs per-class
step correction at 60 Hz, using a per-callback policy table.

## 2026-09-30 E2 option A (interpolation) result: REJECTED for now

InterpGate IG-v2 (only plugin; first build IG-v1 exited the game because main()
returned into newlib exit -> sceKernelExitGame). Hooks 0x15230->ig_pump,
0x6B9B8->ig_entity. ~177 entity callbacks per update in the test scene.
Mode G (entity callbacks half-rate, pump every frame): speeds mostly correct,
but no interaction possible (shop/teleporter) and the sea flickers every second
frame: pump 1 rebuilds per-frame lists (zeroes 0x6B84C..0x6B864) that callbacks
refill, so skipped callbacks empty them. G1 (whole pump skipped) did not show this.
Mode GI (G + half-way +0x30 position): slightly smoother but judder still clearly
visible (rotation/animation/matrices not interpolated) and the moving boat
platform bugs (player riding a blended position). Owner verdict: dead end.
Final state A0, hooks removed; InterpGate still installed/enabled (passive).
DECISION: pursue option B = 60 Hz everywhere, per-callback policy hook at 0x6B9B8
(class-level correction of fixed steps; half-rate only for invisible logic).

## 2026-09-30 option B static start: shared helper census

research/scripts/shared-helper-census.py -> research/v2/shared-helpers/shared-helpers.json
(150 LEVEL_01 atlas callbacks, 4259 approx functions, depth 3; stack stores excluded;
37 shared helpers with non-stack position stores or float RMW, used by >=5 classes).
Read so far (static, semantics INFERRED):
- 0x6AD50 (29 classes): animation start/blend setup, not movement.
- 0x6C318 (23 classes, 12 direct; Ryno/RynoRocket/LunaCutscene...): adds a fixed
  per-call displacement to an out vector a1: out.y += anim[+40]*obj+0x14 and
  out.xyz += normalized(target-obj+0x30)*anim[+44]; no delta -> 2x at 60 Hz.
  First shared-helper fix candidate: wrapper that halves the added displacement.
- 0x6CF30 (22 classes incl. Lvl3Elevator): bounds centre (min+max)*0.5, geometry,
  not a timing step.
NEXT ACTION: triage the remaining 34 candidates the same way (0x1A8CF8, 0xF7C54,
0x6C92C, 0xF84C4, 0xE290, 0xCA3BC, 0xF8B64...), classify each as fixed per-call
step / delta-based / geometry, then build one plugin with a generic
"halve-added-displacement" wrapper for fixed-step helpers and test it live with
C1 (A0 <-> candidate switch). Live census of active callbacks via hook 0x6B9B8
can rank priorities. Weapons (LaserTracer drain, Blaster cooldown) separate.

## 2026-09-30 E3 frame-time constants and E4 half-step results

E3 tools/runtime/frametime.py: C1 + all 107 other LEVEL_01 `lui rX,0x3D08`
(1/30) -> 0x3C88 (1/60) (42 mul.s, 14 sub.s, 12 div.s, 10 add.s, 30 untraced).
Owner OBSERVED vs C1: minimal difference. Teleporter animation corrected; enemy
max speed still 2x, debris 2x, Butterfly flap 2x, Waterfall 2x, enemy attack
damage lands before animation. Hard-coded 1/30 is a minor channel.
E4 InterpGate IG-v3 mode H (60 Hz; after each pump-1 entity update, changed
plain-float words of entity record [0,0x80) and regions at +0x58 (0x200 B) /
+0x54 (0x100 B) keep half their change; |change|>4 and non-floats skipped).
~180 updates/frame but only ~1.2 halved words per update. Owner OBSERVED:
Butterflies OK, enemy death animation OK; teleporter movement 2x too slow while
its animation is 2x too fast; enemy max speed still 2x (crabs); enemy damage
still early; Waterfall still 2x; many things uncorrected. INFERRED: most moving
state (enemy position/velocity, AI counters) lives outside the sampled regions
(separate moby/object structure) and/or in integer counters.
Final state A0, hooks removed; InterpGate IG-v3 installed/enabled (passive);
D1/D0/recorder mappings false. No gameplay parity claim.
NEXT ACTION (next session): live-locate the real object/moby structure of a
moving Crab (memory diff while it moves; follow entity pointers), measure which
fields change per update (floats vs integer counters), then extend H coverage
to that structure and add an integer-counter rule (e.g. apply integer decrements
only every second update). Re-test crabs (speed + attack timing) first.



## Checkpoint snapshot moved out on 2026-09-30 (late session)

# Current checkpoint - 2026-09-30 (end of session)

Priority 0: UCES00420 original 30 -> faithful 60 FPS parity; experimental only.
Branch v2-research (local-only; history rewritten 2026-09-30, older SHAs quoted
in reports no longer resolve). Full session log:
research/live-tests/pokitaru/session-2026-09-30/SESSION-LOG.md.

## Environment (owner machine)

- PPSSPP 1.20.4, GraphicsBackend 3 (VULKAN), renders on RTX 3060. OpenGL start
  faults came from the Ryzen 5600G iGPU driver (amdxc64.dll); owner updated it
  to 31.0.21925.1001; startup OK since. FileLogging False (log had reached 75 GB).
- Plugins: only InterpGate enabled (IG-v3, passive unless hooks installed).
  D1Global, D0Temporal, FamilyRecorder and others mapped false. Three plugins
  together (D0+recorder+D1) crashed at Pokitaru load ("GPU CALL to illegal
  address 0000016c"); D1 alone loaded fine. Keep plugin count minimal.
- Without plugins LEVEL_01 base is 0x09139D00; with InterpGate 0x0916BD00.

## What the 2026-09-30 live experiments established (owner-observed)

| Arm | Speed | Smoothness | Notes |
|---|---|---|---|
| C1 (3-word core) | ~2x almost everywhere | smooth | player OK, most animations OK |
| D1 (C1 + 54 one-pass WF + Help + elevator) | as C1 | smooth | no visible difference |
| G1 pump 1 every 2nd update, accumulated delta | mostly correct | strong judder | Blaster cooldown longer |
| G / GI per-entity half rate (+ position blend) | mostly correct | judder | interactions broken, sea flicker; GI breaks boat platform |
| F1 C1 + 107 other 1/30 immediates -> 1/60 | as C1 | smooth | only teleporter animation fixed |
| H C1 + halve changed floats of entity/+0x58/+0x54 | partial | smooth | Butterflies and enemy death OK; crab speed, attack timing, waterfall still 2x |

Conclusions: the dominant 2x defect lives in group pump 1 entity callbacks
(0x15230 -> 0x6B7F4, per-entity jalr at 0x6B9B8, a0 entity, f12 delta).
Half-rate updates are rejected (judder, per-frame list rebuild in pump 1,
platform bugs). Direction chosen with owner: **option B, stay at 60 Hz and
correct per-call steps**, using generic rules (half-step) plus per-class
exceptions. Enemy animations are delta-based and correct under C1; enemy
movement and AI/attack timing are per-call and 2x. LaserTracer ammo drain 2x
(player weapon route, not pump 1) and Blaster timing are separate weapon items.

## First class-family fix: ground navigation (TESTED by owner, not measured)

Crab position writes traced live (write breakpoint on entity+0x30) to 0x2AA5C
`pos += displacement` in shared ground-navigation move 0x2A8F0 (callers 0x29188,
0x29334; used by Crab, TMRobotHeadB/TorsoB, TrainingBot). Displacement =
direction * per-call speed (nav+0x1C); 0x2A8F0 only reads it. IG-v4 mode N passes
a halved copy: owner OBSERVED crab speed now normal, turning looks natural
(unconfirmed), attack damage still lands early. Crab entity: +0x00..+0x2C
rotation matrix, +0x30 position, +0x48 -> anim block whose +0x64 is animation
time advancing exactly 1/60 per update (delta-based, correct), +0x7C/+0x80 small
ints = animation system fields (+0x80 next-event index, written 0x76B4C).
Animation events fire when event.time < anim time (0x76AA4: c.lt.s at 0x76B20,
callback jalr 0x76B3C): time-based, so anim-event damage would be on time.
Early crab damage therefore comes from another path (hitbox/contact window?);
Player health: player struct = LEVEL_01 seg1 base (+0x2DD108) + 0x5A838
(= module + 0x337940); health f32 at +0x964, max at +0x968 (module + 0x3382A4);
HUD copies at module + 0x2BC840 (refresher 0xA5AFC, getter 0x312AC). Health
writer 0x38700 (-= amount). Crab attack (0x1254CC, OBSERVED): pvar(+0x58)+0x60
int frame counter +1 per update, compared as float with constant at RVA 0x2CF3C8
(27.0, single reference 0x1254F8); when >= threshold, hitbox test 0xEE9C then
damage 0.3 via 0x14A74 per contact frame. Setting the constant to 54.0 live:
owner OBSERVED attack timing correct and damage equal to original.
**Crab = first fully corrected class (N + threshold 54), owner-observed only.**
E7 integer rule (IG-v5 modes I/IN: +-1 int changes of entity/+0x58/+0x54 kept every
second update) REJECTED: crab still early (0x1254CC is called inside the crab pump-1
callback from 0x1271B8, but compares the counter right after incrementing, before
any post-update rule can act), Gadgetron shop animation restarts, nothing else
visibly fixed. Generic post-update rules (H, I) are insufficient; reliable fixes
are targeted: shared helpers (nav 0x2A8F0) and specific constants (0x2CF3C8).
E8 tools/runtime/fixes.py (IG-v6/v7; fixes nav, debris 0x191D7C x8, animdisp 0x6C318 x38,
crab constant). debris: wrapper ran (1692 calls) but owner saw no change on crate
debris; crate debris class/path UNKNOWN (census showed no new pump-1 group; the
break may have happened before polling). animdisp in IG-v6 froze the game thread
(4417 calls then logic stopped): wrapper declared void but 0x6C318 returns v0 used
by callers 0x159CAC and 0x16FC6C. IG-v7 returns v0 but animdisp STILL froze the game
(114 calls then stall): INFERRED callers rely on registers 0x6C318 leaves intact
(non-standard convention). animdisp parked; needs an all-register-preserving asm wrapper.
nav, debris and crab constant ran without stalls.
tools/runtime/group-census.py lists live pump-1 groups (class, callback, active count).
Crate debris retest (IG-v7, debris fix on, census polled 32 s while the owner broke
5 crates, Crate 57->52): no new pump-1 group and 0 calls to 0x191D7C. Crate debris
is NOT a pump-1 entity nor the shrapnel helper; INFERRED particle/effect system
outside pump 1 (candidate calls after 0x15230 in 0x1517C). Waterfall/Fire effects
may share it. NEXT: locate the particle system (write breakpoint on a debris
particle position found by value scan, or static review of 0x1517C callees).

## Class registration table (static, 2026-09-30)

research/scripts/class-table.py -> research/v2/class-table/level01-classes.json:
150 LEVEL_01 class descriptors (name, 4 code pointers incl. pump-1 update = atlas
callback for 150/150, embedded field-definition string for 67, two sizes).
Definitions give original field names/types (e.g. Butterfly `Particle *pLeftWing;
Particle *pRightWing`, Crate `f32 velocityY; f32 fallDistance`). Engine source
paths are embedded (Code/EFFECTS/*.cpp, ENGINE/rendereffect.cpp). Butterfly wings
are Particles -> a shared particle updater may cover wings, waterfall, fire, crate
debris. NEXT: follow Butterfly pvar Particle* to the particle record, find its
updater with write-probe, then correct the particle system once.
PARTICLES (TESTED by ablation, call-toggle.py): main-update call 0x15348 -> 0x8CC18
is the particle system (walker; per-pool animator jalr 0x8CE54, waterfall animator
0xDE23C). Disabling it 6 s: waterfall waves/mist/splashes vanish, then burst back
(emitters kept queueing). 0x15240->0xD2268, 0x15338->pump2, 0x1527C->0x8CAD0: no
visible effect. Particle update and draw are coupled: no half-rate gating.

## Tools (all guarded, reversible, verify words before/after)

- tools/runtime/pump-gate.py (A0/C1/G1, cave in LEVEL_01 .data zero run 0x2C1814..0x2C281C).
- tools/runtime/frametime.py (A0/C1/F1).
- tools/runtime/interp-gate.py + patches/experimental/interp-gate IG-v4 (modes C1/G/GI/H/N/HN).
- tools/runtime/crab-probe.py (field discovery), tools/runtime/write-probe.py (who writes a field).
- research/scripts/shared-helper-census.py -> research/v2/shared-helpers/shared-helpers.json;
  research/scripts/triage-helpers.py (float RMW provenance per helper).
- Static: 0x6C318 adds a fixed per-call displacement (23 classes); 0x6AD50 is
  animation setup; 0x6CF30 bounds geometry. 108 `lui 0x3D08` sites in LEVEL_01.

## Exact NEXT ACTION

1. Owner in Pokitaru, InterpGate loaded, hooks installed in C1 (interp-gate.py).
2. Live-locate a moving Crab's real object structure: follow its pump-1 entity
   (+0x54/+0x58 and other pointers), diff memory across updates while it chases,
   classify changed fields (float position/velocity vs integer counters).
3. Extend mode H coverage to that structure and add an integer-counter rule
   (apply integer decrements only every second update). Re-test crab speed and
   attack timing, then waterfall/debris. Record exceptions per class.
Next-session files: AGENTS.md, this file, the session log above,
patches/experimental/interp-gate/interp.c, tools/runtime/interp-gate.py.
