# CURRENT_STATE — Ratchet & Clank: Size Matters — Overcompensated V2

_Last updated: 2026-09-20_

## 0. Project priority and repository state

Priority 0 remains:

> **UCES00420 original 30 FPS → faithful 60 FPS behavioral parity, 1:1 in real time.**

Repository:
`C:\Users\linki\Documents\PPSSPP\RAC_60FPS`

Branch:
`v2-research`

Last parent-review commit / last verified HEAD:
`96a91ebc9dd9e858ea9b67e16d3848a95eacd338`

Always re-check the actual HEAD and dirty state before committing. Runtime/research folders contain local and untracked artifacts from previous missions; do not clean or delete them blindly.

Public repository:
`Linkinito/racsm60fps`

Do **not** commit proprietary PRX/game binaries or RAM dumps to the public repository. Text reverse-engineering reports, hashes, scanner specs, derived measurements and scripts are acceptable.

---

## 1. Evidence policy

Project evidence states:

- `OBSERVED` — directly observed in bytes/runtime/tool output.
- `INFERRED` — reasoned interpretation from observations.
- `CORROBORATED` — independently reproduced by more than one analysis path/worker.
- `TESTED` — controlled runtime experiment supports the claim.
- `UNKNOWN` — not established.
- `REJECTED` — contradicted by stronger evidence.
- `SUPERSEDED` — older interpretation replaced by a better one.

Model consensus is **not** runtime validation.

Static reverse engineering can establish code, constants, control flow, descriptors, callsites and dataflow. It generally cannot establish wall-clock cadence for pointer-dispatched callbacks without runtime evidence.

---

## 2. Experimental arms — canonical definitions

These names must remain stable across future reports.

### A0 — vanilla control

Completely unmodified vanilla 30 FPS behavior.

- second VBlank wait present at `LEVEL_01 RVA 0x96650`
- shared delta remains ~`1/30`
- player loop threshold remains `2`
- local player scalar remains `mov.s f20,f12`

Purpose:
baseline cadence and behavior.

### B0 — VBlank unlock only

A0 plus only:

- loaded `base + 0x96650` → `NOP`

Nothing else changes.

Purpose:
measure the causal effect of removing only the conditional second VBlank wait.

Current status:
**UNTESTED.**
No valid A0/B0 cadence experiment has yet completed.

### B1 — VBlank unlock + shared delta 1/60

B0 plus:

- shared delta constructor changed from ~`1/30` to ~`1/60`
- LEVEL_01 high word historically changes from `0x3C043D08` to `0x3C043C88`
- `ori ... 0x8889` remains

Player loop remains two passes.
Local player scalar remains vanilla.

Purpose:
separate explicit-delta normalization from per-call cadence effects.

Status:
historically understood conceptually; **not authorized until B0 has been measured cleanly in the current V2 experiment**.

### C1 — experimental split-domain arm

B1 plus:

- player loop threshold `2 → 1` at the module-local homolog of LEVEL_01 `0x2FCFC`

But:

- keep `0x2FBBC` vanilla (`mov.s f20,f12`)
- do **not** apply the historical local `×2` scalar

Intended experimental architecture:

- outer schedule ≈60/s
- outer delta ≈1/60
- one player logical substep per outer update ≈60/s

Important:
C1 is **not** yet a final parity patch. Vanilla substep consumers such as `0x32588` receive `1/30` on each of ~60 logical substeps/s. Under a naïve one-pass C1 they could instead receive `1/60` on ~60 calls/s and therefore progress at half the vanilla wall-time rate.

Future split-domain work may need a **local reconstruction of 1/30 only for selected substep consumers**, not a broad outer scalar.

### D / historical full four-change socle

Historical patch combination:

1. VBlank unlock at `0x96650`
2. shared delta ~`1/30 → 1/60`
3. player loop `2 → 1`
4. local player scalar `f20 = f12 × 2` at `0x2FBBC`

This produced good empirical player movement/jump/glide behavior in earlier V1 work.

However, the local `×2` is now structurally suspect because it occurs before:

- `0x360A4` outer timing fields
- the player loop
- both delta-fed substep consumers

Therefore it doubles the timing value seen by outer accumulators as well as by substep logic.

`D` remains useful as historical evidence, but it is **not** the preferred architecture for V2.

---

## 3. Core LEVEL_01 timing architecture

Vanilla Pokitaru `LEVEL_01.PRX` SHA256:

`d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`

### 3.1 Shared delta producer

At LEVEL_01:

- `0x151E0` — `lui a0,0x3D08`
- `0x151E4` — `ori a0,a0,0x8889`
- value = approximately `1/30`
- `0x151E8` — `jal 0x88768`
- `0x151EC` — `mtc1 a0,f20` in the delay slot

The earlier target `0x884A4` was wrong.
Correct target:
`0x88768`.

`0x88768` does not consume the delta or alter `f20` in a way that explains B1 behavior. A hidden side effect there is `REJECTED`.

### 3.2 Shared fan-out

`0x1517C` forwards `f20` as `f12` to four direct consumers:

- `0x87A84`
- `0x6B7F4`
- `0x2FFF0`
- `0x6B618`

This is a **shared delta producer inside this timing domain**, not a universal master clock for the entire game.

The module contains many other independent `1/30` literals and timing families.

### 3.3 Phase/state dispatch above `0x1517C`

`0x1517C` has two direct callers:

- `0x15AA8`
- `0x15B18`

They sit in a phase/state-dispatch region referenced through a relocated `.rodata` function-pointer table around `0x1C02C8`.

The reader/owner of that state table and its exact wall-clock cadence remain `UNKNOWN`.

This is why the real-time cadence of `0x1517C` must be measured at runtime.

---

## 4. Player clock

Outer chain:

`0x1517C`
→ `0x2FFF0`
→ `0x2FB8C`

`0x2FFF0` copies incoming `f12` into `f20` and forwards it to `0x2FB8C`.

### 4.1 Player outer update

`0x2FB8C` is the accepted `Player_UpdateOuter` candidate.

It:

1. receives the incoming timing value
2. calls `0x360A4` once before the substep loop
3. executes a two-pass normal-path loop
4. restores the substep gate to `1` after the loop

Historical patch site:

- `0x2FBBC`
- vanilla `0x46006506`
- `mov.s f20,f12`

The old patch used a local ×2 here.
That broad approach is no longer preferred.

### 4.2 Exact vanilla gate behavior

At `0x2FCB0`:

`sltiu a0,s1,1`

At `0x2FCB4`:

store to module-local gate byte.

Normal sequence:

- pass 0 → gate = `1`
- pass 1 → gate = `0`
- after loop → gate restored to `1`

The earlier claim that the gate was zero throughout the loop is `REJECTED`.

### 4.3 Two-pass loop

Loop tail:

- `0x2FCF8` — increment pass counter
- `0x2FCFC` — `slti ...,2`
- `0x2FD00` — branch back
- post-loop store restores gate `1`

Seven calls occur per pass, but only the final two explicitly receive the timing value through `f12`:

- `0x39B74`
- `0x1EBC4`

Therefore:

> “all seven player-loop functions receive the delta” is `REJECTED`.

---

## 5. Player timing consumers

### 5.1 `0x360A4` — outer timing fields

Called once before the two-pass loop.

Observed behavior includes:

- `player+0x56C = dt`
- `player+0x570 = wrapped/phase-like value + dt`
- `player+0x574 += dt`
- `player+0x578 = dt * 30`
- `player+0x584 += dt`
- `player+0x588 += dt`
- `player+0x58C += dt`
- state-dependent accumulation into `+0x580` or `+0x57C`

This is why doubling `f20` at `0x2FBBC` is too early:
it changes outer timing accumulators as well as substep behavior.

### 5.2 `+0x578` — normalized frame step

`+0x578 = dt * 30`.

This is **not** simply a timer.

At `0x328A0`, displacement is divided by `+0x578` to reconstruct normalized velocity.

At vanilla `dt ≈ 1/30`:

`+0x578 ≈ 1`

At `dt ≈ 1/60`:

`+0x578 ≈ 0.5`

That 0.5 is potentially correct for velocity normalization.

Therefore a global “force +0x578 to 1” or “change dt*30 to dt*60” strategy is `REJECTED`.

Tags:

- `N-VEL` for normalized velocity use
- `N-TIMER` where the same field is reused for countdown/progression

### 5.3 `0x32588` — explicit substep delta countdown

Subtracts the incoming delta from fields including:

- `+0xA00`
- `+0xA08`
- `+0xA14`
- `+0xA18`
- `+0xA0C`

with clamp-to-zero behavior.

Vanilla likely executes this at ~60 logical substeps/s while passing ~1/30 each time.

This is a key reason a future clean split-domain patch may need selective local timing reconstruction.

### 5.4 `0x42C04` — mixed normalized timer

Contains countdown behavior using `player+0x578`, while another path uses a literal per-call decrement.

This is an archetypal mixed `N-TIMER` case:
one shared producer can have correct velocity semantics and incorrect timer semantics at 60 Hz.

### 5.5 `0x39B74`

Mixed timing function containing:

- incoming delta consumers
- `dt*30`-style normalized values
- per-call `+1/-1`
- hardcoded `1/60`
- hardcoded `1/30`

It must not be treated as one homogeneous timing family.

---

## 6. Weapon update domain

`0x1EBC4` = accepted `Player_WeaponUpdate` candidate.

It has three direct callers:

- `0x1E4E8`
- `0x1E610`
- `0x2FCF0`

For player-substep attribution, count the callsite at `0x2FCF0`, not all entries to `0x1EBC4`.

Weapon dispatch contract:

- current weapon object
- weapon `+0x40` → class/descriptor
- descriptor slot `+0x1C` → update callback
- indirect `jalr`
- `f12` receives the forwarded timing scalar

This means weapon callbacks are pointer-dispatched and their cadence must be measured or derived from the dispatcher path.

---

## 7. Class / descriptor atlas

The breadth-first timing atlas recovered:

- 150 candidate class records in LEVEL_01
- 534 distinct class names across the scanned gameplay corpus

Representative LEVEL_01 callback anchors include:

- `Crab` → `0x126F28`
- `BlasterShot` → `0x118130`
- `Flamethrower` → `0x13B8F0`
- `LaserTracer` → `0x148CEC`
- `Lvl3Elevator` → `0x156710`
- `SetCamera` → `0x16A670`
- `Teleporter` → `0x1799C0`
- `TrainingBot` → `0x185B34`

Descriptor ownership proves reachability, **not call cadence**.

`+0xC` is strongly update-associated for anchored classes such as LaserTracer and Flamethrower, but it is not yet proven to mean universal `Update()` for every class.

Many classes have stub-like or state/delegation-heavy callbacks.

No single class name is present in all 15 single-player modules.

---

## 8. Candidate entity manager / object pump

Mapper identified a high-value manager region around:

`0x6EBE4`

Observed structure:

- walk over records with stride `0xF8`
- state/flag test
- multiple indirect callbacks around record offsets:
  - `+0xD4/+0xD8`
  - `+0xDC`
  - `+0xE0`

This may be a general entity/Moby-style update pump and could become an important future PRX observation or hook point.

Current status:

- structure `OBSERVED`
- global Moby/entity ownership `UNKNOWN`
- real-time cadence `UNKNOWN`

Do not promote it to “the global Moby dispatcher” without further evidence.

---

## 9. LaserTracer local rate-aware subsystem

LEVEL_01 local initializer around `0x14CA70`:

- reads a local `rate`
- vanilla rate data = `30.0f`
- computes `dt = 1/rate`
- derives multiple constants from both `rate` and `dt`
- explicitly compares `rate == 60.0f`
- chooses different damping constants for 30/60

This is a local rate-aware subsystem, not a game-wide master clock.

Across the scanned gameplay modules:

- modules containing `LaserTracer` correlate 12/12 with an R60-style initializer
- LEVEL_15/21/22 do not contain LaserTracer and do not show the same initializer
- LEVEL_07 produced a three-hit anomaly that remains unresolved

`0x148CEC` is pointer-dispatched and gated by the player substep flag.

Safe current interpretation:

- vanilla pass 0 can execute gated work
- vanilla pass 1 suppresses gated work
- restoring the gate to `1` after the loop does **not** itself prove another dispatch
- a future one-pass 60 Hz design may double this work **in real time** if the callback occurs once per outer frame

Actual cadence remains `UNKNOWN`.

---

## 10. Flamethrower / Burner

`Flamethrower` update:
`0x13B8F0`

Observed per-call behavior includes counters.

Related effect/emission logic contains:

- a global `-1` per-call countdown
- RNG/modulo logic

Historical patch changing `%3` to `%6` is now understood as changing a **probability**, not a deterministic “every 3 frames → every 6 frames” cadence.

The exact causal path from that random selection to Burner damage remains `UNKNOWN`.

Do not describe the `%3→%6` patch as periodic frame decimation.

---

## 11. Fixed-step world archetypes

### 11.1 Pokitaru final elevator

`Lvl3Elevator`

Initializer around `0x1562DC` constructs approximately:

`(1 / speed) * (1/30)`

and stores a per-update increment.

Update candidate:
`0x156710`

This is the cleanest current `C + F30` fixed-step mover archetype.

If its callback doubles in wall-clock frequency without compensating the stored increment, travel speed should double.

Runtime cadence has not yet been measured.

### 11.2 LEVEL_03 / Kalidon per-call accumulation

Region around `0x15AA84`:

`field+0x34 += field+0x48`

No explicit delta multiplication in that operation.

The per-call accumulation is solid.

Owner attribution to `Lvl3Platform` is `INFERRED` from descriptor/function boundaries.
Earlier “Lvl3DeadlyFluid / acid” naming is not sufficiently proven.

Treat the visual symptom and the exact owning class as separate questions.

---

## 12. Camera

LEVEL_01 contains engine-code `±1/30` literals around:

- `0x361C`
- `0x3634`

Historical camera ×2 behavior at 60 FPS is mechanically consistent with a fixed/reference-30 timing dependency.

However, the exact dataflow may represent a rate multiplied by a 30 Hz reference rather than a naïve fixed increment.

Current tag:
`F30 / fixed-reference timing`

Do not yet simplify it to “plain per-call movement”.

---

## 13. Display limiter / VBlank structure

LEVEL_01 frame-limiter region:

- first wait around `0x9662C`
- VCOUNT-like read around `0x96638`
- compare against stored previous count + 1
- branch at `0x96648`
- historical B0 site at `0x96650`
- second VCOUNT-like read around `0x96658`

Canonical static interpretation:

- if current VCOUNT == stored+1:
  - branch not taken
  - execution reaches the second wait at `0x96650`
- if current VCOUNT != stored+1:
  - branch is taken
  - second wait is skipped
  - execution continues at the later VCOUNT path

Therefore the Mapper wording “0x96650 is a catch-up wait” is `REJECTED`.

The more defensible interpretation is:

- normal on-time path waits a second VBlank, producing approximately 30 Hz on a 60 Hz display
- already-late frames skip that extra wait

However:

> the real A0→B0 scheduling effect remains `UNTESTED`.

The previous runtime attempt collected **no timing evidence**.

---

## 14. sceDisplay call counting

LEVEL_01 `.sceStub.text.sceDisplay` contains five stubs.

Section-wide call counts are not a valid way to identify the limiter.
Calls must be resolved per stub and per local control-flow pattern.

The earlier “six sceDisplay callsites” statement was too broad/incomplete.

---

## 15. ELF / PRX address mapping

Universal:

`file_offset = RVA + 0x74`

is `REJECTED`.

Use the file-backed `PT_LOAD` containing the RVA:

`file_offset = p_offset + (RVA - p_vaddr)`

Example:
LEVEL_01 second load segment uses a different delta.
`0x2DD1F8 → file 0x2DD268`.

Runtime relocation is a separate layer.

Do not mix:

- module RVA
- file offset
- relocated live address

---

## 16. LEVEL_02 provenance

Current `Data/BIN/LEVEL_02.PRX` is restored vanilla:

SHA256:
`0037689a926197969231795c4d6b05980e5e94558394617b21e8b8bcd79bc8aa`

Current loop threshold is vanilla `2`.

Historical contaminated one-pass hash:

`8b25dc880062912c28adc49b78ce1e90952037ca18db8164e41301530647c7e9`

is no longer the active baseline.

Any old manifest entry describing current `Data/BIN/LEVEL_02.PRX` as `8b25...` is stale.

---

## 17. LEVEL_15 / LEVEL_21

Strong static evidence shows LEVEL_15 and LEVEL_21 are near-identical compiled gameplay modules.

Observed:

- identical file size
- identical `.text` size
- identical class list
- matching structural metrics
- Skeptic found only 14 differing bytes concentrated around level-index/path data

Treat RVAs as potentially transferable for this pair only after exact verification.
Do not generalize this rule to unrelated modules.

---

## 18. Timing taxonomy — canonical

Use these tags consistently:

- `O` — outer explicit delta
- `S` — logical substep
- `D` — explicit delta consumer
- `N-VEL` — normalized frame step used for velocity/displacement normalization
- `N-TIMER` — normalized frame step reused for timer/progression
- `C` — fixed amount per call
- `F30` — fixed/reference 30 Hz constant
- `F60` — fixed/reference 60 Hz constant
- `R` — local configurable/rate-aware subsystem
- `E` — event/state-gated
- `V` — display/VBlank/frame-sync domain
- `H` — wrapper/composition/dispatcher
- `U` — unresolved

Known engine behavior is heterogeneous.
Do not force all `1/30`, `1/60`, `60.0f` or per-call constructs into one family.

---

## 19. Rejected / superseded claims — do not resurrect

- `0x151E8 -> 0x884A4` — wrong; correct target is `0x88768`.
- `0x2B00C0` as permanent player identity — wrong; scratch/current target only.
- gate zero through the whole two-pass loop — wrong; exact sequence is `1/0/post1`.
- all seven player-loop callees receive delta — wrong; only `0x39B74` and `0x1EBC4`.
- global `dt*30 → dt*60` / force `+0x578=1` — rejected.
- historical local player scalar ×2 as universal clean fix — rejected as preferred architecture.
- every `60.0f` literal means refresh-rate support — false.
- all `1/30` literals belong to one delta domain — false.
- universal `RVA+0x74` — false.
- bare loop-tail pattern as player-loop discriminator — false.
- `LaserTracer` rate block as game-wide master clock — false.
- post-loop gate restoration proves a second LaserTracer dispatch — false.
- Flamethrower `%3→%6` as deterministic frame decimation — false.
- old LEVEL_02 contaminated file as current baseline — stale.
- Mapper label “0x96650 catch-up wait” — rejected by branch direction.

---

## 20. Historical V1 observations that still matter

Earlier V1 work established that the old four-change socle could make major player behavior look close to correct:

- movement
- jumps
- glide
- many weapon cooldowns

But residual ×2 symptoms existed, including examples such as:

- camera
- menu blinking
- teleportation
- Pokitaru final elevator
- Kalidon acid/platform motion
- Burner damage behavior
- animations/particles/cosmetics

These historical symptoms remain useful test anchors, but they are not automatically evidence for one shared timing mechanism.

---

## 21. Final architecture direction — PRX, not giant INI

INI/CWCheat remains useful as a **laboratory** for:

- A0/B0/B1-style instruction tests
- isolated constant changes
- fast falsification
- reproducing single writes

The final Overcompensated product should be a PRX/runtime layer.

Likely responsibilities:

- detect current level/module
- verify expected vanilla words/signatures
- install/remove hooks safely on module load/unload
- perform simple writes where simple writes are sufficient
- centralize timing compatibility behavior
- manage per-level RVA/signature data
- expose 30/60 FPS toggle
- later expose PS2-style camera options
- later expose modern controls / second stick
- later integrate the Overcompensated special menu

The goal is **not** to replace every INI write with a hook.

The goal is to put all permanent behavior under the authority of a module-aware PRX, using:

- simple writes when sufficient
- hooks/wrappers when contextual behavior is required
- local fixes only where the engine architecture cannot be generalized safely

---

## 22. Completed major static missions

Completed / accepted or parent-reviewed:

- `player-clock-consumer-map-001`
- `player-clock-delta-producer-001`
- `timing-domains-crosslevel-001`
- `timing-atlas-global-001`
- `timing-atlas-parent-review-001`

`timing-atlas-global-001` used three DeepSeek roles:

- Explorer
- Mapper
- Skeptic

All three completed successfully.

The atlas is broad enough that the project should **not** return to manually reverse-engineering every class before runtime validation.

---

## 23. Runtime status — IMPORTANT

No valid A0/B0 wall-clock cadence measurement has yet been completed.

The latest runtime attempt failed before connecting to PPSSPP because no process was running.

Observed from that failed attempt:

- no diagnostic pilot
- no debugger connection
- no module/base discovery
- no cadence counts
- no branch counts
- no `+0x574/+0x578` measurement
- no B0 write
- no restoration required

Therefore all runtime cadence predictions remain `UNKNOWN`, not zero.

The orchestration failure taught an important operational lesson.

---

## 24. Runtime operating model — NEW POLICY

Current runtime policy:

> **Owner-managed emulator, agent-managed measurement.**

The user launches PPSSPP manually.

The user:

- opens the intended PPSSPP environment
- loads UCES00420
- loads the intended savestate/checkpoint
- places the game in the intended scene/state
- explicitly tells the agent that the currently open PPSSPP session is authorized

The runtime agent then:

1. finds the already-running PPSSPP process
2. connects to its debugger/API
3. verifies UCES00420
4. verifies active LEVEL_01 / relevant module
5. rediscovers the current module base
6. verifies the relevant guard words
7. performs only the requested measurement/write
8. persists the result
9. restores any authorized temporary write exactly

The agent should **not** spend native quota launching, reconstructing, cloning, rebuilding or forensically re-validating the entire PPSSPP laboratory unless explicitly asked.

Do not create a second emulator environment.

Do not assume historical PID, port or module base.

---

## 25. NEXT RUNTIME GATE — A0/B0

Immediate scientific goal:

> Determine what actually changes in scheduling when only `base+0x96650` is NOPed.

The user should first open PPSSPP manually on the controlled Pokitaru savestate and declare it ready.

### A0 minimum measurement set

Prefer:

- `base+0x1517C` — shared/level update cadence
- `base+0x2FB8C` — player outer cadence
- `base+0x39B74` — player substep cadence
- `base+0x2FCF0` — weapon update callsite from player substep, if cheap/reliable
- `base+0x96490` — limiter/driver, if cheap/reliable
- `base+0x96648` — branch equality/inequality
- `base+0x96650` — second-wait site reach
- player `+0x574` slope
- player `+0x578` value

Do not build new instrumentation infrastructure just to obtain optional counters.

### Expected A0 hypothesis

If the current architecture is correct:

- `0x1517C` ≈30/s
- `0x2FB8C` ≈30/s
- `0x39B74` ≈60/s
- player loop remains two passes
- `+0x574` ≈1 unit/s
- `+0x578` ≈1

These are predictions, not acceptance criteria.

### B0

Save the exact loaded runtime word at:

`base + 0x96650`

Then apply only:

`NOP`

No other socle change.

Repeat the same measurements.

If shared scheduling truly doubles, expected hypothesis:

- `0x1517C` ≈60/s
- `0x2FB8C` ≈60/s
- `0x39B74` ≈120/s
- two player passes remain
- `+0x574` ≈2 units/s
- `+0x578` remains ≈1

Then restore **the exact saved loaded runtime word**, not an assumed raw PRX word.

### Restored A0

Verify restoration and, when practical, confirm the baseline returns.

### Mandatory stop

After interpreting A0/B0/restored-A0:

**STOP.**

Do not automatically continue to B1/C1/D merely because quota remains.

The observed result should determine the next mission.

---

## 26. Runtime interpretation targets

Possible high-value outcomes:

### Shared outer doubling

If:

- `0x1517C` doubles
- `0x2FB8C` doubles
- `0x39B74` doubles proportionally from ~60 to ~120
- loop remains two passes
- `+0x574` slope doubles

then B0 strongly supports:

> vanilla outer schedule ≈30 Hz with an already-60-Hz player substep budget; B0 raises outer schedule toward ≈60 Hz and therefore overdrives the two-pass player domain toward ≈120 logical substeps/s.

This would explain a large part of the historical V1 behavior.

It would still be tested only for the controlled scene, not automatically for every object and level.

### Player-local change only

If player cadence doubles but `0x1517C` does not, then the current engine-global scheduling hypothesis is wrong/incomplete.

### No doubling

If both level and player cadence remain ≈1× and the second wait was exercised, the simple B0-doubling premise is falsified for that state.

### Non-uniform ratios

If different domains change by different ratios, preserve the data.
Do not force a single-clock explanation.

---

## 27. Next queue after A0/B0 — not yet authorized

Only after A0/B0 interpretation:

1. Pokitaru `Lvl3Elevator` callback count + progress/travel time
2. candidate `0x6EBE4` entity-manager ownership/cadence
3. LaserTracer dispatch/gate/local rate
4. one enemy callback
5. one projectile callback/lifetime
6. camera
7. LEVEL_03 platform/fluid ownership + wall-time motion
8. only then design the next timing-correction arm

B1/C1/future split-domain patch design should be based on the measured B0 result, not on static expectation alone.

---

## 28. Quota discipline

Native GPT quota is scarce and can end abruptly.

Runtime sessions should be narrow.

Do not spend native quota on:

- launching/rebuilding PPSSPP
- recreating the lab
- broad repository rediscovery
- broad static reverse engineering already completed by DeepSeek
- constructing elaborate new tracing infrastructure unless explicitly approved

Persist meaningful results immediately.

Preferred workflow:

1. user prepares PPSSPP
2. agent measures one arm
3. result is written
4. next arm is explicitly authorized
5. restoration is verified
6. stop when the experiment's question has been answered

DeepSeek remains appropriate for broad static inventory work.
Native GPT should be reserved for parent arbitration, targeted reverse engineering, runtime measurements and patch architecture decisions.

---

## 29. Current one-sentence state

**We now have a broad, evidence-ranked map of Size Matters' heterogeneous timing architecture, but the central causal runtime premise — what the game actually schedules at A0 and what changes when only the second VBlank wait is removed in B0 — remains untested and is the immediate next gate.**
