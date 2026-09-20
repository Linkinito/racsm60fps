I have enough primary evidence. Writing the report now.

# TIMING-ATLAS-GLOBAL-001 — Explorer report (DeepSeek external worker, read-only)

**Role performed**: Explorer (breadth-first inventory + timing classification). Mapper/Skeptic deliverables are represented only where my own scans produced structural or adversarial evidence; they are labelled as such and are not a substitute for those roles.

---

## 0. Scope, tooling, provenance (read this before using any number)

**Tooling reality.** This sandbox has no Python, no Capstone, no Ghidra, no `objdump`, no `Get-FileHash` (Windows PowerShell 5.1 in **ConstrainedLanguage**), and no write access. All results below were produced by in-memory byte/word analysis: ELF header + section-header parsing, aligned 32-bit little-endian word reads, and byte-pattern scans via `IndexOf`. **No decompiler was used**, so every "semantics" statement is a raw-instruction decode, not a Ghidra-grade dataflow claim. Where I say OBSERVED I mean: I read the bytes and decoded the instruction word myself.

**Address model (verified on LEVEL_01, reused for all modules).** Segment 0: `p_offset = 0x74`, `p_vaddr = 0`, `p_filesz = 0x2DD104`; therefore **file_offset = RVA + 0x74** for every module (all 16 modules I parsed have a segment-0 offset of `0x74`, `vaddr 0`). Your Ghidra "reference addresses" and my RVAs are consistent: `0x151E0` etc. all decoded to the expected instructions (section 1).

**Corpus and hashes.** Taken from `MANIFESTE_SHA256.csv` (files are listed there with size + full SHA256; I could not recompute hashes in-sandbox, so these are **quoted**, not re-verified):

| module | size | sha256 (from manifest) |
|---|---|---|
| LEVEL_01 | 3444725 | d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571 |
| LEVEL_02 (prx-reference, vanilla) | 3567813 | 0037689a926197969231795c4d6b05980e5e94558394617b21e8b8bcd79bc8aa |
| LEVEL_02 (Data\BIN, contaminated) | 3567813 | 8b25dc880062912c28adc49b78ce1e90952037ca18db8164e41301530647c7e9 |
| LEVEL_03 | 3552853 | 4b6cf5e41ab9f3f30e182f15752a4d9d264904794ce568582fa78ad8177e8b94 |
| LEVEL_04 | 3538213 | 6896122ac19973e928303dc94c40fa309b5f06e5fef6ab14f624987035a4dc37 |
| LEVEL_05 | 3340201 | af7474d3af87dd392717d45b2be30a3512ab5f6df3f449e1ac15ce9971a75bbb |
| LEVEL_06 | 3356473 | c7953cd34e82fbea8fca4125cd5f30581fa8450b858e454f83968b2cd0fec39c |
| LEVEL_07 | 3519445 | 40e236a82cce9be46044a06945dcd0e7aab754e91d1eb7bb75b8040101dc233d |
| LEVEL_08 | 3782229 | c6906ca8805ec805063036429ecc86ce316efdd386641e87fc8c92dd90dad8a8 |
| LEVEL_09 | 3327325 | 5674dd1a09d43d0a35578a1252ce46035d6f64a139dc2660bb25a941f78e6370 |
| LEVEL_10 | 3482861 | 07f9010f78cf6f49f8fdad0dbf89ce20375dff600183117605c3ebf231583772 |
| LEVEL_15 | 2680321 | cebd5b53f4a7f0b42cc7aec7f7e2e13749089a3dd630a3af1fcccaf81748e70a |
| LEVEL_21 | 2680321 | 0e7a7f7d70a70e51081b0471e257f50d3a86f987a5eae546b2a178d2190dd706 |
| LEVEL_22 | 2695137 | be7ef86357ee668bb1c194226e4cd2e55920a4f7f375952ffb494c0de5a78986 |
| LEVEL_23 | 3196201 | 7c8a790eccf722cfd8e5a6e066d17300cf84c1f4068535a6575542229c0f7561 |
| LEVEL_24 | 3181025 | a4e3f6496b3d2d238767fbb72b9db274dc5179db4d6f71eea2ce1fee22480bf |
| FRONTEND | 2121369 | f203e56c49ae36651fd80db97b901159d076ea379da4bb55cecb490356fc2104 |

**LEVEL_02 provenance rule honoured.** All LEVEL_02 statements below come from `…\development-v0.6.3-generalisation\prx-reference\LEVEL_02.PRX` = `0037689a…` (vanilla). `Data\BIN\LEVEL_02.PRX` = `8b25dc88…` is the contaminated one-pass variant and was **not** used as vanilla. LEVEL_15 and LEVEL_21 have **identical `.text` size (0x12E628) and identical class lists but different hashes** — treat as a homologue pair requiring a provenance check of its own.

---

## 1. Independent verification of the accepted static model (raw words, LEVEL_01)

Every item below is my own aligned 32-bit read. All matched the parent model.

| RVA | word | decode |
|---|---|---|
| 0x151E0 | 0x3C043D08 | `lui a0,0x3D08` |
| 0x151E4 | 0x34848889 | `ori a0,a0,0x8889` → 0x3D088889 = 1/30 |
| 0x151E8 | 0x0C0221DA | `jal 0x88768` (confirms current model, not 0x884A4) |
| 0x151EC | 0x4484A000 | `mtc1 a0,f20` (delay slot) |
| 0x2FBBC | 0x46006506 | `mov.s f20,f12` |
| 0x2FCB0 | 0x2E240001 | `sltiu a0,s1,1` |
| 0x2FCB4 | 0xA2440208 | `sb a0,0x208(s2)` (the module-local flag store) |
| 0x2FC60 | 0x0C00D829 | `jal 0x360A4` |
| 0x2FCE4 | 0x0C00E6DD | `jal 0x39B74` |
| 0x3FF6C/0x3FF70 | 0x3C053C88 / 0x34A58889 | 1/60 build → 0x3FF78 `add.s` (0x460D6300) → `swc1 field+0x70` |
| 0x4000C/0x40010 | 0x3C043C88 / 0x34848889 | 1/60 build → 0x40018 `sub.s` (0x460D6301) → `swc1 field+0x34` |
| 0x361C/0x3620 | 0x3C043D08 / 0x34848889 | +1/30 literal in the camera-code region |
| 0x3634/0x363C | 0x3C04BD08 / 0x34848889 | **−1/30** (0xBD088889) literal, same region |
| 0x14CA78/0x14CA7C | 0x3C04002D / 0xC4902C04 | `lui a0,0x2D` + `lwc1 f16,0x2C04(a0)` (rate load) |
| 0x14CA80/0x14CA88 | 0x46106B43 / 0xE48D2C08 | `div.s` (1.0/rate) → `swc1 dt,0x2C08(a0)` |
| 0x14CB08/0x14CB0C/0x14CB10/0x14CB18 | 0x3C044270 / 0x44847000 / 0x460E8032 / 0x45000005 | 60.0f build → `mtc1` → **`c.eq.s rate,60.0`** → `bc1t` |

So: the shared 1/30 fan-out, the two-pass substep loop, `state+0x578`, the hard-coded 1/60 timer pair, the camera ±1/30 literals, and the tracer `rate==60` branch are all confirmed byte-for-byte from the vanilla reference module.

---

## 2. Explorer A — class / update inventory (new breadth artifact)

**Method (mechanical, reproducible).** In `.data` (vaddr range), every aligned word `W` that points into `.rodata` where a NUL-terminated, identifier-shaped ASCII string (`^[A-Za-z_][A-Za-z0-9_]*$`, length 3–39) begins is treated as a class record: word 0 = class name pointer, words at +0x4/+0x8/+0xC/+0x10/+0x20…+0x40 = relocated function pointers. This reproduces the parent-accepted LaserTracer record exactly (`0x2D414C` name→"LaserTracer", +0xC `0x2D4158` = 0x148CEC).

**Descriptor-layout hypothesis (INFERRED; anchors CORROBORATED).** `+0x4` behaves as init/ctor-like, `+0xC` as the update-like callback. Anchors: LaserTracer +0xC = `0x148CEC` (parent-verified update), Flamethrower +0xC = `0x13B8F0` (parent-verified `Flamethrower_Update`), and Lvl3Elevator +0x4 = `0x1562DC` (the function that contains the fixed-step init at `0x1563E8`). **False positives exist**: some +offset words are small integers, not pointers (e.g. Crate +0x3C = 0x2B95, ShieldCharger +0x1C = 0x1084, Lvl3Elevator +0x3C = 0x1018). Any production scanner must require the word to land on a *known* function start, not merely inside `.text`.

**Per-module counts (OBSERVED):** LEVEL_01 150, LEVEL_02 174, LEVEL_03 160, LEVEL_04 167, LEVEL_05 130, LEVEL_06 130, LEVEL_07 165, LEVEL_08 212, LEVEL_09 134, LEVEL_10 158, **LEVEL_15 9**, **LEVEL_21 9**, **LEVEL_22 44**, LEVEL_23 103, LEVEL_24 120, FRONTEND 2. Union = **534 distinct class names**; **~90 shared by 10–14 modules** (Ratchet, Wrench, all weapons, agents, crates, bolts, HUD, breakables, tracers, shields, pickups, vendor…); **no class name is present in all 15 single-player modules** (LEVEL_15/21 carry only 9 shared classes; LEVEL_22 carries 44).

**LEVEL_01 name → +0xC update-candidate RVA (OBSERVED, full registry):**

```
Acidbomb 0x107534 | AcidbombEpoxy 0x108A08 | AcidGloveHUD 0x108F20 | AgentController 0x1091D0 | AgentOfDoom 0x1099BC
AgentOfDoomShrapnel 0x10E404 | AgentsBomb 0x10E714 | AgentsGlove 0x10FD58 | AgentsGrenade 0x1107CC | AgentsLaser 0x111104
AgentsRocket 0x111C54 | ArmorHelmet 0x11254C | ArmorLeftFoot 0x112564 | ArmorLeftHand 0x11257C | ArmorPickup 0x112DF4
ArmorRightFoot 0x113340 | ArmorRightHand 0x113358 | ArmorTorso 0x113370 | BeeMine 0x113E00 | BeeMineGlove 0x115990
BeeMineGloveHUD 0x115FC0 | BeeMineShrapnel 0x116308 | Blaster 0x116A00 | BlasterAkimbo 0x117A94 | BlasterShot 0x118130
BlitzGun 0x11A5B0 | BlitzGunShot 0x11C1E8 | BoltController 0x1204C0 | BoltCrankBolt 0x120A80 | BoltCrankCam 0x120FB4
BoltGrabber 0x121264 | Bombglove 0x1217F4 | BoxBreaker 0x121D74 | BoxBreakerHelp 0x121E10 | BreakableObject 0x122080
Butterfly 0x122820 | ChameleonDecoy 0x123248 | ClankForShipAnim 0x123394 | ClankPack 0x1233D4 | ConditionalStartLocation 0x123424
ContinuePoint 0x1234D0 | CowBell 0x1239B0 | Crab 0x126F28 | CrabObjectController 0x127F18 | CrabShrapnel 0x1281C8
CrankedObject 0x128C20 | Crate 0x129558 | CrateAmmo 0x129668 | CrossbowGun 0x12B254 | CrossbowShot 0x12CDEC
CrystalGroundShard 0x12E168 | DesignTest 0x12E898 | DropshipB 0x12F850 | DropshipLaser 0x1305D8 | DualBlasterHUD 0x1307B0
electricXplo 0x130FAC | ElectroBall 0x132BEC | ElectroshockWave 0x134310 | EndMovie 0x1347EC | EnemyController 0x134FCC
EnemyWave 0x137D9C | ExplosiveBee 0x1391B0 | Fire 0x13A51C | Flamethrower 0x13B8F0 | FlyingCarLwDirectional 0x13E12C
FlyingCarLwOrbit 0x13F1D0 | FlyingCarLwPathed 0x1401A8 | FogMoby 0x141204 | GlowCard 0x14187C | GravityCrystal 0x142E30
HeadShrapnel 0x143248 | Helipack 0x143850 | HutDoor 0x143FEC | Hypershot 0x144954 | InitialCamera 0x144BE8
IntroMovie 0x144DD4 | LaserTracer 0x148CEC | Level01Boat 0x14EB68 | Level01Cutscene01 0x1503AC | Level01DoorTarget 0x15083C
Level01HelpManager 0x150EF8 | Level01OceanSound 0x151654 | Level01SkyController 0x1519A8 | Level01Waterfall 0x151D78
LevelSettings 0x15299C | LunaCamera 0x1529F0 | LunaCutscene 0x152EA0 | LunaNPC 0x154294 | LunaPhotoTarget 0x155CE4
Lvl3Elevator 0x156710 | MapOMaticGadget 0x1570A0 | MatrixMoby 0x1570B8 | MobyGroup 0x157160 | MobyIce 0x15841C
Mootator 0x15A364 | MutantCow 0x15AF7C | MutantMadCow 0x15C060 | NapalmBubble 0x15CCE0 | PathAnimal 0x15DD3C
PDA 0x15E380 | Polarizer 0x15F058 | PowerupAmmo 0x16009C | PowerupHealth 0x1615C8 | Ratchet 0x162FB8
RatchetDecoyInner 0x164C30 | RatchetDecoyOuter 0x165184 | RatchetShip 0x1653F4 | RatchetShipAnimation 0x166438 | Region 0x1684A4
Ryno 0x168C28 | RynoRocket 0x169698 | SetCamera 0x16A670 | ShakeyBush 0x16ABA8 | Sharkagator 0x16AFD4
SharkagatorFin 0x16B830 | ShieldCharger 0x16CB78 | ShieldChargerBolt 0x16F228 | ShockRocket 0x16F954 | ShockRocketShot 0x170B20
ShrapnelGeneric 0x171948 | ShrinkBeam 0x17202C | ShrinkRayRatchet 0x172CFC | SkillPoint_L01 0x172FB8 | SlideController 0x173788
Spitfire 0x173AA0 | Splash 0x174E84 | Sproutomatic 0x17553C | StaticBarrierBelt 0x175B3C | SuckCannon 0x1762A8
SuckCannonComet 0x19ADF4 | SuckCannonCometTie 0x176C18 | SuckCannonManager 0x17794C | SwarmManager 0x178A1C | Teleporter 0x1799C0
TieManipulator 0x17A8E4 | TitaniumBolt 0x17AFCC | TMRobotHeadB 0x17D49C | TMRobotTorsoB 0x180970 | TMRobotTorsoCutscene 0x182678
TorsoAShot 0x1827C4 | TorsoShrapnel 0x1833B8 | TrainingBot 0x185B34 | TrainingBotShrapnel 0x18670C | TriggerCollection 0x186E14
TriggeredDoor 0x187614 | TripleWaveBeacon 0x188214 | vendor 0x1886E8 | WaterWaves 0x188AAC | Wrench 0x189BE8
ZipLineController 0x18CCB8
```
(Level-specific classes recovered the same way, to be added to the atlas per module: LEVEL_02 BotFlinger, Boulder, ClankBot*, ElevatorRings, Pygmy, Razorback, DartShooter…; LEVEL_03 Lvl3DeadlyFluid, Lvl3Platform, Lvl3SinkingPlatform, Lvl3PumpMachinery, Lvl3MagnaRoom, ConveyerItem, Drone01, Mungo*…; LEVEL_04 Level04Crusher, ObstacleSaw, DamageSphere, Level04Crane…; LEVEL_05 Lvl05MiniBoss, FlyingHypo, QuarkDoctor…; LEVEL_06 Lvl06MedicTurret, MedicBot, SentryTurret01Trigger…; LEVEL_07 Lvl07ConveyorBelt, Lvl07GuardBeam, Lvl07ExplodeDoor, Lvl07EleGlass…; LEVEL_08 LunaBoss*, ObstacleFlameJets/Hay/Thresher, DayNightController…; LEVEL_09 Lvl09Televator, Lvl09Shocker, Lvl09Lift, Lvl09Piston, SparkEmitter…; LEVEL_10 GiantClankPlayer, Otto*, EliteClone*, SimpleTimer, TubeController…; LEVEL_22 AirRaceCameraTweaker; LEVEL_23 AirRaceSentry, SelfInflictedCatatonia; LEVEL_24 MiniTurret*, Treehouse*.)

**Cadence caveat (must not be skipped).** Descriptor ownership proves *reachability via a pointer*, not *call cadence*. Explorer/Mapper cannot infer from the callback body whether a callback runs once per outer frame, once per substep, once per object instance, or only on state transitions. The only cadence-linking structure found so far is the `0x2B0208` substep gate consumed by LaserTracer (`0x148D7C`), which is *player-substep coupled* — a genuinely unusual case, not a template.

---

## 3. Explorer B — timing signature classification

**Fingerprint method (OBSERVED, upper-bound).** For each `+0xC` callback I took the byte window `[start, next_known_start)` (next descriptor-derived function start as the boundary; capped at 20 KB) and counted: `jal`, `lwc1`, `swc1`, COP1 arithmetic (`add/sub/mul/div.s` via byte0 ∈ {0,1,2,3}, byte3 = 0x46), `mtc1`, `addiu +1`, and raw occurrences of the `lui 0x3D08` (1/30 hi), `lui 0x3C88` (1/60 hi), `lui 0x41F0` (30.0f), `lui 0x4270` (60.0f), `lui 0x3F80` (1.0f) immediate byte-pairs. **Important honesty note:** these last counts are *alignment-unfiltered byte-pair hits* (I later discovered my first full-build filter had a register-field bug), so they are **upper bounds**, not exact sites. Conclusions drawn from them are only of the form "this callback contains no such byte pair at all" (safe direction) or "this callback deserves a Ghidra look".

**Result (LEVEL_01, 150 update callbacks).** The large majority — including every crate, pickup, bolt, armor piece, HUD widget, door, trigger, decoy and generic shrapnel class — show `jal = 0` and **zero float operations and zero timing constants**: `BreakableObject`, `Crate`, `CrateAmmo`, `BoltGrabber`, `BoxBreaker`, `Region`, `LevelSettings`, `StaticBarrierBelt`, `MatrixMoby`, `MapOMaticGadget`, `Ratchet` (0x162FB8 is a 0-jal stub), `ShrinkRayRatchet`, `GlowCard`, `ArmorHelmet/…`, `MapOMaticGadget`, `PDA`, `ClankPack`, `Level01Cutscene01`, `TriggerCollection`, `EndMovie`, `Hypershot` (8 jal, no floats). These are candidates for the **pure event/state-gated `E`** archetype (or for "logic lives in a shared behaviour called through `+0x4`/`+0x8`, not in `+0xC`") — they cannot be classified further without runtime or a real decompiler.

Callbacks containing **at least one 1/30 / 1/60 / 30.0f / 60.0f byte-pair hit** (upper-bound list; verify in Ghidra before promoting): `AgentsRocket`, `BlasterAkimbo`, `BlasterShot`, `BlitzGun`, `BoltCrankCam`, `ElectroshockWave`, `EnemyWave`, `Flamethrower`, `FlyingCarLightweight*` (all three), `Level01HelpManager`, `LunaNPC`, `Polarizer`, `PowerupAmmo`, `PowerupHealth`, `RatchetShipAnimation`, `ShieldCharger`, `ShakeyBush`, `SkillPoint_L01`, `TMRobotHeadB`, `Wrench`. Notably `LaserTracer 0x148CEC` itself shows **no timing constant** — its rate-aware work lives in the separate initializer, which is exactly the trap the mission warns about.

**Cross-module constant census (OBSERVED, exact full-build filters where stated):**

| module | `.text` size | 1/30 builds (`lui 0x3D08`+`ori 0x8889`, reg-matched) | 1/60 builds (`lui 0x3C88`+`ori 0x8889`) | aligned `lui R,0x4270` (60.0f) sites |
|---|---|---|---|---|
| LEVEL_01 | 0x1BF1AC | 59 | 3 | 9 |
| LEVEL_02 | 0x1D4BB4 | 60 | 3 | 8 |
| LEVEL_03 | 0x1D3850 | 65 | 3 | 9 |
| LEVEL_04 | 0x1D2A6C | 55 | 3 | 8 |
| LEVEL_05 | 0x1AE218 | 56 | 3 | 8 |
| LEVEL_06 | 0x1AFEF0 | 61 | 3 | 8 |
| LEVEL_07 | 0x1CF310 | 77 | 3 | 11 |
| LEVEL_08 | 0x1FD1A8 | 54 | 3 | 8 |
| LEVEL_09 | 0x1AAD78 | 59 | 3 | 8 |
| LEVEL_10 | 0x1C7780 | 52 | 3 | 8 |
| LEVEL_15 | 0x12E628 | 54 | 3 | 6 |
| LEVEL_21 | 0x12E628 | 54 | 3 | 6 |
| LEVEL_22 | 0x1343F8 | 55 | 3 | 5 |
| LEVEL_23 | 0x194C38 | 60 | 3 | 8 |
| LEVEL_24 | 0x1918E4 | 60 | 3 | 8 |
| FRONTEND | 0x3037C | **1** | **0** | **0** |

The 1/30 counts reproduce the earlier Mapper table (59/60/65/55/56/61/77/54/59/52/54/54/55/60/52/1) exactly — an independent reproduction of that artifact. **Exactly three 1/60 builds per gameplay module** is confirmed; in LEVEL_01 two are the `field+0x70 += 1/60` / `field+0x34 −= 1/60` timer pair (`0x3FF6C`, `0x4000C`).

---

## 4. Explorer C — latent rate-aware subsystems (`R`)

**Structural detector (runs per module, no address assumptions):** find aligned `div.s`; within 14 instructions back require an `lwc1 base,field` plus a matching `lui base,hi`; require a `lui R,0x3F80` (1.0f) nearby; require `swc1 base,field+4` within 6 instructions forward; then tag `R60` if a `lui R,0x4270` (60.0f) build occurs within ±30..60 instructions.

**Result (OBSERVED).** Every gameplay module except three has exactly one `R60`-tagged initializer, and the three exceptions are exactly the three modules that do **not** contain the LaserTracer class:

| module | R60 rate-aware initializer (div.s site) | reciprocal-only `Rx` sites | LaserTracer class present |
|---|---|---|---|
| LEVEL_01 | **0x14CA80** (fn `0x14CA70`, field `0x2C04`) | 0x10FC7C, 0x11BE68, 0x17E964 | yes |
| LEVEL_02 | 0x161414 | 3 | yes |
| LEVEL_03 | 0x14E748 | 4 | yes |
| LEVEL_04 | 0x1545C0 | 3 | yes |
| LEVEL_05 | 0x140464 | 2 | yes |
| LEVEL_06 | 0x141D24 | 4 | yes |
| LEVEL_07 | **0x132FF8 + 0x133010 + 0x1632F4 (3 sites — anomaly)** | 4 | yes |
| LEVEL_08 | 0x16A7A8 | 2 | yes |
| LEVEL_09 | 0x141FA4 | 3 | yes |
| LEVEL_10 | 0x14E628 | 2 | yes |
| LEVEL_15 | **none** | 0 | no |
| LEVEL_21 | **none** | 0 | no |
| LEVEL_22 | **none** | 0 | no |
| LEVEL_23 | 0x13ABBC | 2 | yes |
| LEVEL_24 | 0x133F6C | 2 | yes |

This is a **12/12 correspondence** between "module contains the LaserTracer descriptor" and "module contains a reciprocal initializer with a 60.0f build in the same region". It corroborates the parent model (local, tracer-family rate-aware subsystem, not a master clock) and gives the parent a concrete per-module RVA to read at runtime.

**Anatomy of the LEVEL_01 initializer (OBSERVED raw words, `0x14CA70..0x14CB2x`)** — it derives a whole family of globals from `rate` before the 30/60 branch:
`0x14CA78 lui a0,0x002D` → `0x14CA7C lwc1 0x2C04(a0)` (rate) → `0x14CA80 div.s` (1.0/rate) → `0x14CA88 swc1 0x2C08(a0)` (dt) → `0x14CA94 lui 0x3D88 / ori 0x8889` (0x3D888889 = 2/30) → `mul.s` rate → `swc1 0x2C4C` → `0x14CAAC 0x3F490FDB` (π/4) `mul.s dt` → `0x2C88` → `0x14CAC4 0x3DB2B8C3` (0.0872665 rad ≈ 5°) × dt → `0x2C90` → `0x14CADC 0x3F060A92` (π/6) × dt → `0x2C94` → `0x14CAF4 0x41A00000` (20.0) × dt → `0x2CA0` → `0x14CB08 60.0f` → `c.eq.s` → `bc1t` → damping constants `0x3F036F4E / 0x3F376E98` chosen per rate. Two independent rate constants (`1/rate` and `rate`) and angle-valued constants coexist in one initializer — **do not treat every constant in this block as a timestep**.

**Counter-evidence against a blanket "60.0f = timing" reading:** LEVEL_01 has 9 aligned 60.0f builds; only one (`0x14CB08`) is the rate comparison. The others store or multiply by 60.0 (`0x4F1EC swc1 …0x9F0`, `0xD37AC swc1 …0x24`, `0xD8F70`, `0xDAB9C`, `0x17453C mul.s`, `0x18459C mul.s`). Mission rule 5 is therefore empirically supported, not just asserted.

---

## 5. Mapper-relevant structural findings (limited: this is Explorer scope)

- **Reachability is pointer-table based.** Class callbacks are reached through relocated `.data` records (`R_MIPS_32`), not `jal` — consistent with the accepted `0x2D4158` result.
- **`.text` regions that are engine code, not class code.** The player outer loop (`0x2FB8C`), `0x360A4`, `0x39B74`, `0x1EBC4`, the camera literals (`0x361C`/`0x3634`), the VBlank limiter (`0x96650`) and the F60 timer pair (`0x3FF6C`) are **not** inside any descriptor-listed class function. A descriptor-only dispatcher map will therefore silently miss the player/camera/frame-sync domains. This matters for "does the wrapper corpus capture all timing-relevant calls" (Skeptic item 8) — with my method it demonstrably does not.
- **Timing content cannot establish cadence.** Example: `Lvl3Elevator`'s update (`0x156710`) is a state-machine callback whose stored step was computed once in `0x1562DC`; nothing in its body says how often the engine calls it.
- **Homologue classes exist as compiled copies, not as shared engine code.** e.g. `Lvl3Elevator` exists in many modules although only a few levels use an elevator; class presence is therefore *not* evidence of use.

---

## 6. Explorer D — historical symptom anchors (static association only)

**Pokitaru final elevator — `Lvl3Elevator` (LEVEL_01).** OBSERVED: init function `0x1562DC` (+0x4) contains `…0x1563D8 lui a2,0x3F80 (1.0f) … 0x1563E4 mul.s/div.s … 0x1563E8 lui a0,0x3D08 ; 0x1563EC ori a0,a0,0x8889 (1/30) … 0x156404 swc1 f13,0x8(base)`. This is exactly "`(1.0/speed)*(1/30)` stored once"; the update `0x156710` (+0xC) is a state machine that neither recomputes nor (in its first 56 words) multiplies by delta. → **fixed-step mover, `C`+`F30`, per-call progress; doubling call rate doubles wall-time progress unless compensated.** Same shape confirmed present in LEVEL_03 `Lvl3Elevator` (`0x156xxx` per module, module-local).

**Kalidon acid (LEVEL_03, parent-cited RVA 0x15AA84).** OBSERVED at `0x15AA80..0x15AA90`: `lwc1 f12,0x144`; `lwc1 f12,0x34`; `lwc1 f13,0x48`; `add.s f12,f12,f13`; `swc1 f12,0x34` → **`field+0x34 += field+0x48` with no delta multiply**. Per-call fixed-step accumulation confirmed by direct decode. **Owner attribution refined/rejected:** using descriptor-derived function boundaries, `0x15AA84` lies inside the function starting at `0x158A18`, which is `Lvl3Platform`'s `+0xC` (update) pointer — **not** `Lvl3DeadlyFluid` (whose callbacks sit near `0x151A90/0x151CDC/0x151DC8`). Because an unlisted static function could sit between `0x158A18` and the next known start (`0x15B420`), I mark the owner **INFERRED / MEDIUM**, and I flag that the parent's "Kalidon acid" label may point at a platform-controller function. This is a genuine contradiction worth resolving before any acid-specific patch.

**Camera.** OBSERVED ±1/30 literals at `0x361C`/`0x3634` (raw words in §1), located in engine code adjacent to the Ratchet class's `+0x2C` pointer target `0x35B2C`, i.e. outside the descriptor registry. → **hard-coded `F30` camera step, per-call; B0/or-remove-limiter doubling is a direct risk; the historical "halve the camera constants" fix is mechanically explicable.**

**Continuous damage (Burner/Flamethrower).** `Flamethrower 0x13B8F0` (+0xC) is a per-call counter/modulo-heavy callback (`jal 82`, `mtc1 78`, plus 1/30 and 1/60 byte-pair hits, `%3`-style pseudo-random decimation per accepted model). Its effect object `0x13B20C` uses life/fade countdowns. → **`C` + probabilistic emission**; the direct damage path remains UNKNOWN (unchanged from the accepted model).

**Other anchors now class-mapped (static only):** teleporters `Teleporter 0x1799C0` (LEVEL_01) / `Lvl09Televator` / `Lvl05Portal`; level hazards `Lvl3DeadlyFluid`, `Lvl07GuardBeam`, `Lvl09Shocker`, `Level04Crusher`/`ObstacleSaw`, `Level08ObstacleFlameJets`/`Thresher`/`Hay`; platform/elevator family `ElevatorRings` (L02), `Lvl05MagnaPlatform`, `Lvl07Platform`, `Lvl09Lift`/`Lvl09Piston`, `Level10CollapsingPlatform`, `Lvl3SinkingPlatform`/`Lvl3StaticPlatform`; bosses `LunaBoss*` (L08), `Lvl05MiniBoss`, `OttoGiant`/`PsychicBomb` (L10); special modes `GiantClankPlayer` (L10), `AirRaceCameraTweaker`/`AirRaceSentry` (L22/L23), `MiniTurret*` (L24). None of these has yet been timing-classified beyond name/RVA.

---

## 7. Contradictions, corrections and negative results

1. **My own correction (recorded deliberately).** A first `c.eq.s` census returned "3–5 per module, zero in LEVEL_15/21/22", suggesting a clean LaserTracer correlation. That filter was wrong (`funct` field mask ignored the `fd` bits). Corrected counts are 328–366 per gameplay module (still 0 `c.le.s`). The *structural* `R60` detector (not the count) is what now supports the 12/12 correspondence in §4.
2. **"No class in all 15 modules"** is a real observation, driven by LEVEL_15/21 (9 classes) and LEVEL_22 (44). It contradicts any assumption that a single class-level patch target is universal.
3. **LEVEL_15 vs LEVEL_21**: identical `.text` size and identical class list, different SHA256. The parent's earlier note (same size, different hash) is confirmed; provenance of the pair remains UNKNOWN.
4. **FRONTEND is structurally outside the family**: 1 1/30 build, 0 1/60 builds, 0 60.0f builds, 2 `div.s`, 2 classes. Any "global" engine claim must exclude it explicitly (or the claim is wrong).
5. **Acid owner contradiction** (see §6): parent-cited acid site resolves to `Lvl3Platform`'s update function, not `Lvl3DeadlyFluid`.
6. **Descriptor false positives**: integer-valued words that look like pointers (`0x2B95`, `0x1018`, `0x1084`) mean a naive "word < .text end" rule over-reports callbacks.
7. **The `.data` 30.0f census** (LEVEL_01 hits at `0x2AA480/0x2AA5A0/0x2AA5E0/0x2AF9AC…`, several per module, some at regular strides like 0x120/0x40) shows 30.0 is also used as ordinary data (ranges/limits), so "30.0f in .data = rate field" is **not** a valid rule on its own. The parent's `0x2D2C04` identification rests on the *code* that reads it (`0x14CA7C`), which I did reproduce.
8. **Historical E-VPI-008 claim** ("LEVEL_16–20 lack the central timing signatures") is not re-tested here (out of scope), but note the contradiction recorded by the previous panel: those modules do carry the shared 1/30 init. I did not verify LEVEL_16–20 in this mission.

---

## 8. Missing evidence / open questions

- **Runtime cadence for any callback other than the player chain: UNKNOWN.** No non-player callback has a proven call frequency.
- Mapping from `+0x4`/`+0x8`/`+0xC`/`+0x30` to *semantic roles* is anchored for only 3 classes (LaserTracer, Flamethrower, Lvl3Elevator) — the rest is INFERRED layout.
- Whether the 12 `R60` initializers are the same code shape (only LEVEL_01 has been decoded word-by-word). LEVEL_07's three `R60` sites are unexplained.
- Which `+0x30`-family callbacks are per-object "physics/verlet" updates (LaserTracer's `+0x30` = `0x149184`) — not investigated.
- Whether the "stub-like" `+0xC` callbacks (0 jal, 0 floats: crates, bolts, pickups, doors, triggers) delegate to a shared behaviour table; the `Crate`/`Breakable` source strings (`CORE/behaviors/CrateShared.cpp`, `navigate.cpp`) suggest they do, but the delegation mechanism was not resolved.
- LEVEL_02 class count (174) is the highest of any module while its contaminated Data copy differs by one byte — worth re-checking which copy PPSSPP loads (already an open parent item).

---

## 9. Timing archetypes (compact, mission-mandated form)

1. **Explicit-delta integrator (`O`/`D`)** — outer player timing fields `0x360A4`; substep countdowns `0x32588`; shared-delta consumers fed by `f20` (`0x87A84`, `0x6B7F4`, `0x2FFF0`, `0x6B618`).
2. **Normalized-displacement velocity (`N-VEL`)** — `+0x578 = dt*30` consumed by `0x328A0` (divide displacement by it).
3. **Normalized-step reuse as countdown (`N-TIMER`)** — `0x42C04` subtracting `+0x578`, mixed with a literal `-1.0` branch.
4. **Fixed-step mover (`C`/`F30`)** — `Lvl3Elevator` (`(1.0/speed)*(1/30)` stored at `0x1563E8`, applied per call by `0x156710`); camera ±1/30 at `0x361C`/`0x3634` (engine code).
5. **Hard-coded fixed-step timer (`F60`)** — the `field+0x70 += 1/60` / `field+0x34 -= 1/60` pair (`0x3FF6C`, `0x4000C`), present in all 15 modules.
6. **Bare per-call accumulation (`C`)** — `field+0x34 += field+0x48`, LEVEL_03 `0x15AA84` region (acid/fluid-height candidate).
7. **Local rate-aware initializer (`R`)** — `0x14CA70`: `dt = 1/rate`, derived constants, explicit `rate == 60.0` branch; one per module in the 12 LaserTracer-bearing modules.
8. **First-substep / post-loop gated callback (`S`+`C`)** — LaserTracer update `0x148CEC` behind `0x2B0208`, with a `-1.0` fixed decrement.
9. **Per-call counter + pseudo-random emission (`C`)** — Flamethrower `0x13B8F0` / `0x13BBEC`.
10. **State/event-only or delegated callback (`E`/`U`)** — the large majority of `+0xC` callbacks (crates, bolts, armor, HUD, doors, triggers, decoys): 0 `jal`, 0 float ops.
11. **Frame-sync / display limiter (`V`)** — `0x9662C` / `0x96650` (LEVEL_01 has 6 calls into the `.sceStub.text.sceDisplay` section; other modules 1).
12. **Wrapper/call-composition (`H`)** — not re-verified in this mission.

---

## 10. Deterministic scanner specification (as actually implemented here)

Inputs: each `LEVEL_*.PRX`/`FRONTEND.PRX` parsed independently. Steps that worked and their failure modes:

1. Parse ELF headers: `e_shoff`(0x20), `e_shentsize`(0x2E), `e_shnum`(0x30), `e_shstrndx`(0x32); resolve section names via the `.shstrtab` section (`sh_offset`+16, `sh_size`+20). Section map: `.text`(addr 0, off 0x74), `.rodata`, `.data`, `.rel.*` (type 0x700000A0), `.bss`.
2. Use `rva = file_offset − 0x74` universally (verify per module via program header 0).
3. Class registry: scan aligned words in `.data`; accept word → `.rodata` string (`^[A-Za-z_][A-Za-z0-9_]{2,39}$`); record `+0x4 … +0x40` pointers. **Guard:** require target ∈ [0x10000, .text_end) *and* ideally ∈ the set of observed function prologues (`addiu sp,sp,-N`); otherwise integer fields produce false positives (0x2B95, 0x1018, 0x1084).
4. Float-constant builders: match the **full** `lui`+`ori` pair with register equality using `rt = byte2 & 0x1F` on the `lui` and `rt = byte2 & 0x1F` on the `ori` (`ori` byte2 also carries `rs` in bits 5–7 — masking is mandatory). Values: 0x3D088889 (1/30), 0x3C888889 (1/60).
5. Single-instruction scans: `lui R,imm` = byte3 = 0x3C and byte1/byte0 = imm high/low; `lwc1`/`swc1` base = `((byte2>>5)&7) | ((byte3&3)<<3)` (**not** byte2 alone); COP1 `funct` = `byte0 & 0x3F` with format check `byte3 == 0x46` (**not** byte0 equality).
6. Rate-aware initializer signature: aligned `div.s` + preceding `lui base`/`lwc1 base,field` + `lui 0x3F80` + following `swc1 base,field+4`; `R60` tag if a `lui 0x4270` occurs within ~250 bytes. Expected false positives: ordinary reciprocal-smoothing initializers (my `Rx` set: 2–4 per module).
7. Two-pass player loop: `make the window explicit` — `sltiu a0,s1,1` (`0x2E240001`) + `sb a0,0x208(s2)` (`0xA2440208`), plus `slti ...,2` candidates (`0x2A240002` family, 13–18 raw hits per module). Never match bare `slti`.
8. Frame limiter: resolve `.sceStub.text.sceDisplay` by section name; count `jal` targets inside it (LEVEL_01 = 6, others = 1).
9. Join matches to the wrapper ledger by `(module, rva)`; never carry an RVA across modules.

Impossible to automate with this method: indirect-call owners (`[[record+k]]`), data-table indexing, per-instance multiplicity, and any semantic naming.

---

## 11. Ranked runtime queue proposed to the parent (not executed)

1. **A0→B0 player outer cadence** (`base+0x2FB8C`, plus loop counter and `state+0x574`/`+0x578` slopes). Control for everything else.
2. **LaserTracer gated block** (`0x148CEC` call count + `P+0xD` counter) A0/B0/B1 — discriminates first-substep gating from delta/rate scaling.
3. **`Lvl3Elevator` (`0x156710`) progress rate** A0/B0 (Pokitaru elevator): the cleanest `C`+`F30` discriminator (time to target in seconds vs call count).
4. **Camera ±1/30 (`0x361C`/`0x3634`) rotation rate** A0/B0: engine-level `F30` outside the player chain.
5. **R60 initializer + rate field** (read-only): log `field` (LEVEL_01 `0x2D2C04` homologue per §4) A0/B0 to see whether any writer exists.
6. **F60 timer pair** (`0x3FF6C`/`0x4000C`): time-to-threshold in seconds A0/B0.
7. **Kalidon fluid/acid (`LEVEL_03 0x15AA84` region)**: rise time in seconds, plus ownership check (is the executing function `Lvl3Platform 0x158A18` or another `Lvl3Platform` pointer?) to resolve §6 contradiction.
8. **One projectile (`BlasterShot 0x118130` or `CrossbowShot 0x12CDEC`) and one enemy (`Crab 0x126F28`, `TrainingBot 0x185B34`)**: count callbacks per second + projectile lifetime in seconds A0/B0 (two discriminators at once: cadence vs explicit-delta).

---

## 12. Bottom line for the parent

The atlas is now broad enough to stop working class-by-class in the *inventory* sense: 534 class names, 150 mapped update callbacks for the reference module, per-module counts, per-module rate-aware initializer RVAs, and mechanically verified anchors for the elevator/acid/camera/timer cases. What remains genuinely unknown is **cadence** for everything outside the player chain, and that is a runtime question, not a static one. The strongest static results added by this mission are (a) the class→callback registry with its false-positive guard, (b) the 12/12 LaserTracer↔`R60` initializer correspondence across modules, and (c) the direct decode of the elevator/acid/camera/timer mechanics — including the correction that the parent-cited acid site resolves to `Lvl3Platform`, not `Lvl3DeadlyFluid`.

<!-- PARENT_HANDOFF_V1 -->
```json
{
  "established": "OBSERVED L01 raw words: 0x151E0/E4=1/30, jal0x88768, 0x361C,+1/30 and 0x3634,-1/30, 0x3FF6C/0x4000C=1/60 add/sub pair; full-report S1",
  "corroborated": "Class->+0xC update registry (L01 150 classes, +0xC anchors LaserTracer 0x148CEC, Flamethrower 0x13B8F0); 12/12 match: modules with LaserTracer have an R60 rate init; report S2/S4",
  "inferred": "Lvl3Elevator 0x1562DC stores (1.0/speed)*(1/30) used per call by 0x156710; LEVEL_03 0x15AA84 is field+=field add.s, owner Lvl3Platform 0x158A18; report S6",
  "contradictions": "Parent acid site 0x15AA84 resolves to Lvl3Platform+0xC, not Lvl3DeadlyFluid; LEVEL_15/21 same text size+class list, different hash; no class present in all 15 modules; report S6/S7",
  "rejected": "Global 60.0f=timing (only 1 of 9 L01 lui0x4270 sites is the rate compare); descriptor word<textEnd as pointer test (0x2B95/0x1018/0x1084 false positives); my first c.eq.s census; report S4/S7",
  "unknown": "Call cadence for every non-player callback; role of descriptor +0x4/+0x8/+0x30; whether 12 R60 initializers are identical; L15/L21 provenance; report S8",
  "top_hypotheses": "H1 timing splits into engine-global (frame sync, camera F30, F60 timers), player-local (outer/substep), and class-local (fixed-step movers, rate-aware tracers); report S3/S6/S9",
  "best_discriminating_test": "A0/B0 log of Lvl3Elevator 0x156710 progress rate plus callback count per second; separates fixed-step per-call (C) from delta-driven (O/D) ownership; report S11",
  "blockers": "No disassembler/decompiler/Python in this worker sandbox; hashes quoted from MANIFESTE_SHA256.csv, not recomputed; no runtime access; report S0",
  "full_report_required": "yes: S2 class registry with 150 L01 name->RVA rows, S4 per-module R60 RVAs and constant census, S10 scanner filters; handoff cannot carry the tables"
}
```
<!-- /PARENT_HANDOFF_V1 -->