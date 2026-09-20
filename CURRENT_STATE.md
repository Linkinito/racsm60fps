# CURRENT_STATE — Overcompensated V2 (DeepSeek compact)

_Last updated: 2026-09-20_

Priority0: UCES00420 vanilla 30 FPS -> faithful 60 FPS behavioral parity, 1:1 real time.

Repo: `C:\Users\linki\Documents\PPSSPP\RAC_60FPS`
Branch: `v2-research`
Last verified parent-review HEAD: `96a91ebc9dd9e858ea9b67e16d3848a95eacd338`
Reverify HEAD/dirty state. Do not commit proprietary PRX/game binaries/RAM dumps.

Evidence: OBSERVED, INFERRED, CORROBORATED, TESTED, UNKNOWN, REJECTED, SUPERSEDED.
Model consensus is not runtime validation.

## Experimental arms

- **A0**: vanilla 30 FPS.
- **B0**: A0 + only `base+0x96650 -> NOP`.
- **B1**: B0 + shared delta ~1/30 -> ~1/60.
- **C1**: B1 + player loop 2 -> 1; keep `0x2FBBC` vanilla, no local x2.
- **D historical**: B1 + loop 2 -> 1 + local `f20=f12*2` at `0x2FBBC`. Good empirically for player motion in V1, but structurally suspect because x2 also reaches outer timing.

No B1/C1/D before clean B0 measurement.

## LEVEL_01 core timing

Vanilla SHA256:
`d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`

Shared delta:
- `0x151E0` lui a0,0x3D08
- `0x151E4` ori a0,a0,0x8889 ~=1/30
- `0x151E8` jal `0x88768` (old 0x884A4 REJECTED)
- `0x151EC` mtc1 a0,f20

`0x1517C` forwards f20/f12 to:
`0x87A84`, `0x6B7F4`, `0x2FFF0`, `0x6B618`.

Shared within one timing domain, not a global master clock.

Direct callers of `0x1517C`: `0x15AA8`, `0x15B18`, behind a phase/state table near `.rodata 0x1C02C8`. Owner/thread/cadence UNKNOWN.

## Player chain

`0x1517C -> 0x2FFF0 -> 0x2FB8C`

`0x2FB8C`:
- calls `0x360A4` once before loop
- normal path = 2 passes
- gate sequence = 1 / 0 / post-loop 1
- only `0x39B74` and `0x1EBC4` receive explicit delta

REJECTED: all 7 loop callees receive delta.

Historical scalar site:
`0x2FBBC = mov.s f20,f12`
Old local x2 is too early; it also affects outer timing.

`0x360A4`:
- `+0x56C = dt`
- `+0x574 += dt`
- `+0x578 = dt*30`
- other outer accumulators +=dt

`+0x578` is mixed-use:
- N-VEL at `0x328A0`
- N-TIMER in countdown/progression logic
Global `dt*30 -> dt*60` / force +0x578=1 is REJECTED.

`0x32588`: subtracts incoming substep dt from +A00/+A08/+A14/+A18/+A0C.
`0x42C04`: mixed +0x578 timer + literal per-call decrement.
`0x39B74`: mixed dt / dt*30 / per-call +/-1 / fixed 1/60 / fixed 1/30.

## Weapons

`0x1EBC4` = Player_WeaponUpdate candidate.
Callers: `0x1E4E8`, `0x1E610`, `0x2FCF0`.
For player-substep cadence count `0x2FCF0`, not total 0x1EBC4.

Weapon dispatch:
weapon +0x40 -> descriptor -> slot +0x1C -> jalr; f12 carries timing scalar.

## Atlas / object structures

- 150 candidate class records in L01
- 534 distinct class names across scanned gameplay modules

Anchors:
Crab `0x126F28`; BlasterShot `0x118130`; Flamethrower `0x13B8F0`;
LaserTracer `0x148CEC`; Lvl3Elevator `0x156710`; Teleporter `0x1799C0`;
TrainingBot `0x185B34`.

Descriptor ownership proves reachability, not cadence.
`+0xC` is update-associated for anchored classes, not universally proven.

Candidate manager near `0x6EBE4`:
0xF8-stride record walk + state gate + callbacks near +D4/+D8/+DC/+E0.
Structure OBSERVED; global Moby ownership/cadence UNKNOWN.

## LaserTracer

L01 local initializer `0x14CA70`:
local rate=30, dt=1/rate, explicit rate==60 branch, different damping constants.

Local rate-aware subsystem, not global clock.
12/12 LaserTracer-bearing modules also have R60-style init; L15/L21/L22 do not. L07 anomaly unresolved.

`0x148CEC` is pointer-dispatched and substep-gated.
Post-loop gate reset does NOT prove second dispatch.
Real-time cadence UNKNOWN.

## Fixed-step / symptom anchors

Pokitaru `Lvl3Elevator`:
init ~`(1/speed)*(1/30)`, update `0x156710`.
Clean C+F30 archetype; runtime cadence UNTESTED.

L03 `0x15AA84`: `field+0x34 += field+0x48`, no explicit dt multiply.
Per-call accumulation solid; exact owner unresolved.

Camera: engine ±1/30 literals near `0x361C/0x3634`.
Tag: F30/fixed-reference timing; exact dataflow unresolved.

Flamethrower `0x13B8F0`: per-call counters + RNG/modulo.
Historical `%3 -> %6` changes probability, NOT deterministic frame decimation.
Exact damage path UNKNOWN.

## VBlank limiter

L01:
- first wait ~`0x9662C`
- VCOUNT-like read `0x96638`
- branch `0x96648`
- B0 site `0x96650`
- second VCOUNT-like read `0x96658`

Canonical static reading:
- vcount == stored+1 -> second wait executes
- vcount != stored+1 -> second wait skipped

Mapper “catch-up wait” label REJECTED.
Likely: on-time path waits second VBlank (~30 Hz on 60 Hz display); late frame skips it.
Actual A0->B0 cadence effect remains UNTESTED.

## ELF / provenance

Universal `RVA+0x74` REJECTED.
Use containing file-backed PT_LOAD:
`file_offset = p_offset + (RVA - p_vaddr)`.
Runtime relocation is separate.

Current `Data/BIN/LEVEL_02.PRX` vanilla:
`0037689a926197969231795c4d6b05980e5e94558394617b21e8b8bcd79bc8aa`, loop=2.
Historical `8b25dc88...` contaminated hash is stale.

L15/L21 are near-identical gameplay builds; transfer RVAs only after verification.

## Timing tags

O outer delta; S logical substep; D explicit delta consumer;
N-VEL normalized velocity step; N-TIMER normalized timer/progression;
C fixed per-call; F30/F60 fixed-reference rates; R local rate-aware;
E event/state-gated; V display/VBlank; H wrapper/dispatcher; U unresolved.

## Do not resurrect

REJECTED/SUPERSEDED:
- 0x151E8 -> 0x884A4
- 0x2B00C0 as permanent player identity
- gate zero through whole loop
- all 7 player-loop callees receive dt
- global +0x578 force-to-1 / dt*60 rewrite
- historical local x2 as preferred architecture
- every 60.0f = refresh support
- all 1/30 literals = one delta domain
- universal RVA+0x74
- LaserTracer block = global clock
- post-loop gate reset = second LaserTracer dispatch
- Flamethrower %3->%6 = periodic decimation
- old contaminated LEVEL_02 = current baseline
- 0x96650 “catch-up wait”

## Final product direction

INI/CWCheat = laboratory.
Final Overcompensated = module-aware PRX/runtime:
module detection, signature guards, safe writes/hooks, timing compatibility,
per-level RVA/signatures, 30/60 toggle, later camera/controls/menu.
Use simple writes where sufficient; hooks/wrappers where context is required.

## Runtime policy

**Owner-managed emulator, agent-managed measurement.**

User manually launches PPSSPP, loads UCES00420 + chosen savestate, positions scene, then authorizes the open session.

Agent:
1. find running PPSSPP
2. connect debugger/API
3. verify UCES00420 + active module
4. rediscover module base
5. verify guard words
6. perform only requested measurement/write
7. persist result
8. restore temporary write exactly

Do not spend native GPT quota launching/rebuilding PPSSPP unless explicitly asked.
Do not assume historical PID/port/base.

## Immediate next gate: A0/B0

No valid wall-clock A0/B0 measurement exists.
Previous attempt failed before debugger connection because PPSSPP was not running.

When user says Pokitaru savestate is ready, measure preferably:
- `base+0x1517C`
- `base+0x2FB8C`
- `base+0x39B74`
- `base+0x2FCF0` if cheap
- `base+0x96490` if cheap
- branch `base+0x96648`
- site `base+0x96650`
- player +0x574 slope
- player +0x578

A0 hypothesis:
1517C ~30/s; 2FB8C ~30/s; 39B74 ~60/s; +574 ~1/s; +578 ~1.

B0:
save exact loaded word at `base+0x96650`, NOP only that site, repeat measurements, restore exact saved word.

If shared scheduling doubles:
1517C ~60/s; 2FB8C ~60/s; 39B74 ~120/s; +574 ~2/s; +578 ~1.

STOP after A0/B0/restored-A0 interpretation.
Do not auto-continue to B1/C1/D.

Next queue only after B0:
1. Lvl3Elevator cadence/progress
2. 0x6EBE4 manager cadence
3. LaserTracer dispatch/gate/rate
4. one enemy
5. one projectile
6. camera
7. L03 platform/fluid
8. then next correction arm

## One-sentence state

Broad timing architecture is mapped and evidence-ranked, but the central causal runtime premise — what A0 schedules and what changes when only the second VBlank wait is removed in B0 — remains UNTESTED and is the immediate next gate.
