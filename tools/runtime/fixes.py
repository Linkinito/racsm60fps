#!/usr/bin/env python3
"""Targeted LEVEL_01 60 FPS fixes on top of C1, switchable live (experimental RAM).

Requires the InterpGate plugin (IG-v24, lean) as the only plugin. Each fix is a guarded
set of word writes; wrappers live in the plugin, data fixes are direct writes.
  nav       ground-navigation displacement halved (0x2A8F0 callers)       [owner: crab speed OK]
  nav2      second navigation mode 0x2935C (Crab/TM robots/TrainingBot)
  frametimers  19 hard-coded 1/30 timer steps -> 1/60 (EnemyWave, Help, Teleporter, ...); 10 player substep sites excluded
  frames30  17 x30.0 seconds->frames conversions -> x60.0 (boat countdown, crossbow, BlitzGun, HUD/pickup timers, particle 0x60100)
  age70     projectile/flying-car age +0x70 += 1.0 -> 0.5 (BlasterShot, ShockRocketShot, FlyingCars, Swarm, SuckCannonComet)
  elevator  Lvl3Elevator progress increment initializer 1/30 -> 1/60 (apply before the elevator initializes)
  camera    camera manual yaw/pitch (0x3060, 0x35B0, 0x37AC) and follow-yaw assist (0x7740) per-call steps: 1/30 -> 1/60, assist gain 0.6 -> 0.3675
  campos    PS2-like follow camera: default distance 5.0 -> 9.0 (0x2AA3F0), height 1.14 -> 1.90 (0x2AA3FC)
            [owner-validated on Pokitaru in the legacy session; applies at the next camera init / level load]
            options: --cam-distance, --cam-height
  fov       vertical FOV constant 0x2AA3C0 (vanilla 0.5498 rad) -> --fov-rad (no default; PS2 value UNKNOWN)
  boatfade  Level01Boat per-call fade step halved (data 0x2D42FC)
  laser     LaserTracer per-call +0x68 steps 1.25/1.5 halved (data 0x2D2D68, 0x2D2D80)
  cows      displacement helpers 0x190D6C/0x191154/0x1913A4 (MutantCow/MadCow, AgentOfDoom)
  physstep bolts and crate debris physics half-step (0x2832C callers)
  debris    debris physics half-step (0x191D7C callers, 8 shrapnel classes)
  crab      crab attack frame threshold 27 -> 54 (data RVA 0x2CF3C8)    [owner: timing OK]
  particles waterfall particle animator 0xDE23C half-step (walker jalr site 0x8CE54)
  pathanimals PathAnimal walk speed x0.5 (stub at 0x15DE70), turn spring refit and fall gravity (data)
  blitzhalf IG-v24: BlitzGunShot class update at 30 Hz (2 x dt); with segrate + raycb = Tremblator 30 Hz island (candidate)
  raycb     IG-v24: ray particle callback 0xC9ED8 at 30 Hz (Tremblator, Acidbomb rays) (candidate)
  segrate   segment animator 0x60100 at 30 Hz (particle mode 2, this animator only; with rayhalf) (candidate)
  rayhalf   IG-v22: ray state machine 0x5FACC at 30 Hz for Tremblator/Crossbow/ShieldCharger shots (candidate)
  animlat   IG-v20: non-looping animation end events delivered 2/30 s after the end like A0 (candidate)
  weapondt  weapon update gets 2 x delta in the single C1 substep (A0 ran it twice per frame)
  domain8   weapondt + substepdt + framescale: the whole player substep loop gets A0 time per call (candidate)
  framescale player frame scale +0x578 = dt x 30 -> dt x 60 (0x360E8; read only by substep code) (candidate)
  skyrot    Level01SkyController per-call sky angle step halved (0x2D47D8) (candidate)
  teleporterfx Teleporter particle effects: 7 literal 1/30 per-call rates -> 1/60 (candidate)
  groupfade four global fade channels 0x2B2A80.. ramp 1/30 per frame -> 1/60 (role UNKNOWN) (candidate)
  tbtimers  reviewed TrainingBot timers x2 (12 words; replaces the quarantined generated list) (candidate)
  k30calls  11 literal 1/30 per-call motion rates (pickup pop, flying cars, TieManipulator, crank cam, Polarizer, beacon) (candidate)
  infammo   TEST AID: weapons do not consume ammo (7 weapon functions; not part of parity)
  crabtimers reviewed Crab state/cooldown reloads x2 (replaces the quarantined timer-patches Crab batch)
  butterfly Butterfly flap/speed steps halved, speed and turn springs refitted (+ timer-patches --class Butterfly)
  laserbeam LaserTracer beam fade in/out frames x2 and texture scroll steps halved
  spawn     particle density: continuous emitters (same call site on consecutive updates) get half their count
  springs   engine spring 0xE290 {k,d} refitted for 60 Hz at 28 struct sites (turning, doors, cranks)
  luna      LunaNPC step 0x2D4EA8 halved, idle timer x2, Luna turn springs
  crank     BoltCrankBolt frames step 1.0 -> 0.5 (0x120C38) and runtime drop step 0x2CE884 halved
  laseracc  LaserTracer runtime accumulator step 0x2D2D74 halved (role INFERRED)
  camfilters exact 60 Hz conversion of the 20 critically damped camera filters (init literal, k, exp)
  particles-rate  every particle animator updates at 30 Hz but still draws at 60 Hz (IG-v19 byte-exact restore)
  particles-all  generic particle half-step for every registered animator (particles = waterfall only)
  waterfall Level01Waterfall spawn every 4th update (was 2nd) and texture scroll steps halved
  phases    24 exclusive per-call fade/countdown/phase constants halved (level01-phase-steps.json)
  clock     19 clock users of the frame counter (periodic triggers, deadlines, skill-point window) use a half-rate copy
  firerate  Fire particle emission rate 0.667 -> 0.333 per call (0x2D1708)
  telemetry pump-1 call 0x15230 -> ig_tel_pump (read-only per-update watches for fix-monitor.py)
Usage:
  python tools/runtime/fixes.py --target C1 --fix nav,crab --out <new dir>
  python tools/runtime/fixes.py --target A0 --out <new dir>
  python tools/runtime/fixes.py --target status --out <new dir>
"""
import argparse, hashlib, importlib.util, json, struct, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
BUILD = REPO/'patches/experimental/interp-gate/build/IG-v24'
WRAPPERS = {  # name: (callee RVA, call sites, wrapper symbol, enable symbol, word offset)
    # Register-transparent asm stubs (IG-v11) halve the displacement vector passed in a2.
    'nav': (0x2A8F0, (0x29188, 0x29334), 'ig_disp_stub0', 'ig_disp', 0),
    'nav2': (0x2935C, (0x29164,), 'ig_disp_stub1', 'ig_disp', 8),
    'cow1': (0x190D6C, (0x190388,), 'ig_disp_stub2', 'ig_disp', 16),
    'cow2': (0x191154, (0x1915F4,), 'ig_disp_stub3', 'ig_disp', 24),
    'cow3': (0x1913A4, (0x19163C,), 'ig_disp_stub4', 'ig_disp', 32),
    'debris': (0x191D7C, (0x10E41C, 0x116320, 0x1239C8, 0x128230, 0x14328C, 0x17195C, 0x1833FC, 0x186750),
               'ig_debris', 'ig_fix', 0),
    # physstep: generic small-object physics step 0x2832C (bolts 0x11EE20, crate debris pool 0x2ED88), per call
    # life -= 1, pos += vel + g/2, vel.y += g -> IG-v18 ig_phys keeps half of each change.
    'physstep': (0x2832C, (0x2ED88, 0x11EE20), 'ig_phys', 'ig_fix', 4),
    # animlat (IG-v20): animation end event latency. 0x76BCC advances a channel once per update and raises
    # end bit 4 on the first update past the end; readers see it one update later. Non-looping end events are
    # withheld 2 extra 60 Hz calls so they arrive 2/30 s after the end as in A0 (Ryno cadence 28 -> 30 frames).
    # rayhalf (IG-v21): segmented-ray state machine 0x5FACC (per-call segments, 1/30 hold, per-call removal, state 3
    # destroys the owner) run on every other 60 Hz frame at the weapon call sites (Tremblator, Crossbow, ShieldCharger).
    'rayhalf': (0x5FACC, (0x11CCA8, 0x12D350, 0x16F328), 'ig_seghalf', 'ig_seg', 0),
    'animlat': (0x76BCC, (0x785B8, 0x78618, 0x78658), 'ig_animadv', 'ig_anim', 0),
    # animdisp (0x6C318) REJECTED: absolute point, not a per-call step; wrapper removed in IG-v16.
}
DATA = {'crab': (0x2CF3C8, 0x41D80000, 0x42580000),
        # LaserTracer per-call additions to field +0x68 (only references 0x149828 / 0x145568), halved
        'laser1': (0x2D2D68, 0x3FA00000, 0x3F200000), 'laser2': (0x2D2D80, 0x3FC00000, 0x3F400000)}
# frametimers: hard-coded 1/30 used as a per-call timer step (static classification in
# research/v2/decomp-summary/level01-frame-time-constants.json) -> 1/60. Code words
# `lui rX,0x3D08` keep their register; the C1 delta site 0x151E0 is excluded.
_FT = json.loads((REPO/'research/v2/decomp-summary/level01-frame-time-constants.json').read_text(encoding='utf-8'))
_RAW = (REPO/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX')
if _RAW.exists():
    _B = _RAW.read_bytes()
    for _r in _FT['sites']:
        _s = int(_r['site'], 16)
        if _r['kind'].startswith('timer') and _s != 0x151E0:
            _w = int.from_bytes(_B[0x74+_s:0x78+_s], 'little')
            DATA['ft' + _r['site']] = (_s, _w, (_w & 0xFFFF0000) | 0x3C88)
# Context exclusion (research/v2/call-context-20261002/REPORT.md): these 1/30 steps sit in functions reached
# only from the player substep loop body (0x3C88C, 0x44ED8, 0x4A4F0, 0x570F0). The body ran twice per A0
# frame, so 60 calls/s in A0 and in C1: already correct, halving them makes them 2x slow (0x4A4F0 gates the
# fire-enable bit 0x95C&0x20 on player timer +0x138). Kept as individual keys, removed from the group.
SUBSTEP_FT = {0x3E170, 0x3EB14, 0x40824, 0x4085C, 0x40894, 0x45284, 0x4556C, 0x4AC5C, 0x575EC, 0x57624}
FRAMETIMERS = [k for k in DATA if k.startswith('ft0x') and DATA[k][0] not in SUBSTEP_FT]
# frames30: `lui rX,0x41F0` (30.0) used to convert seconds/sixtieths into 30 Hz frame
# counts or per-frame rates -> 60.0 (research/v2/decomp-summary/level01-frames30-sites.json).
for _r in json.loads((REPO/'research/v2/decomp-summary/level01-frames30-sites.json').read_text(encoding='utf-8'))['sites']:
    _w = int(_r['before'], 16); DATA['f30' + _r['site']] = (int(_r['site'], 16), _w, (_w & 0xFFFF0000) | 0x4270)
FRAMES30 = [k for k in DATA if k.startswith('f300x')]
# age70: entity age counter +0x70 += 1.0 per call -> 0.5 (projectiles/flying cars; one 1.0 load per function)
for _r in json.loads((REPO/'research/v2/decomp-summary/level01-age70-sites.json').read_text(encoding='utf-8'))['sites']:
    _w = int(_r['before'], 16); DATA['age' + _r['site']] = (int(_r['site'], 16), _w, (_w & 0xFFFF0000) | 0x3F00)
for _r in json.loads((REPO/'research/v2/decomp-summary/level01-age70-reviewed-sites.json').read_text(encoding='utf-8'))['sites']:
    _w = int(_r['before'], 16); DATA['age' + _r['site']] = (int(_r['site'], 16), _w, (_w & 0xFFFF0000) | 0x3F00)   # reviewed shared-load functions
AGE70 = [k for k in DATA if k.startswith('age0x')]
# Lvl3Elevator initializer (1/moveTime)*(1/30) -> 1/60 (legacy recipe lvl3-elevator-halfstep; acts at elevator init)
DATA['elevator'] = (0x1563E8, 0x3C063D08, 0x3C063C88)
# Level01Boat per-call fade step 1/15 (data 0x2D42FC, only reference Level01Boat_Update) halved.
DATA['boatfade'] = (0x2D42FC, 0x3D888889, 0x3D088889)
PARTICLE_SITE, JALR_T0, PARTICLE_ANIMATOR = 0x8CE54, 0x0100F809, 0xDE23C
# camera: manual yaw/pitch (L/R, D-pad) work in per-call units with one `lui rX,0x3D08` (1/30) each in
# 0x3060 (input accel, x2), 0x35B0 (yaw damping x2, cap x1) and 0x37AC (pitch). The camera runs once per
# frame, so at C1 it turned 2x too fast (owner). 1/60 gives accel/4, damping/4, cap/2 per call = original
# angular speed and ramp time. Owner-reported, STATIC_CANDIDATE; not yet tested live.
for _s, _w in ((0x308C, 0x3C063D08), (0x361C, 0x3C043D08), (0x37E0, 0x3C043D08)):
    DATA['cam%#x' % _s] = (_s, _w, (_w & 0xFFFF0000) | 0x3C88)
# Follow-yaw assist 0x7740: per-call cap aa4fc x 1/30 (lui at 4 branch copies) and proportional gain
# 0x2AA500 = 0.6 (only 0x7740 reads it). Remaining error per call is 0.4, so the 60 Hz gain is 1-sqrt(0.4).
for _s in (0x79B8, 0x7AA4, 0x7AF0, 0x7B38):
    DATA['cam%#x' % _s] = (_s, 0x3C043D08, 0x3C043C88)
DATA['cam0x2aa500'] = (0x2AA500, 0x3F19999A, int.from_bytes(struct.pack('<f', 1 - 0.4 ** 0.5), 'little'))
# Negative speed caps use their own `lui 0xBD08` (-1/30): yaw 0x3634 and pitch 0x37F8. Without them only one
# direction was corrected (owner 2026-10-02: L / stick left still 2x fast, R correct).
for _s in (0x3634, 0x37F8):
    DATA['cam%#x' % _s] = (_s, 0x3C04BD08, 0x3C04BC88)
CAMERA = [k for k in DATA if k.startswith('cam0x')]
def _f2w(x): return int.from_bytes(struct.pack('<f', x), 'little')
# PathAnimal_Update: pos += fwd * speed with the per-instance speed loaded at 0x15DE70 (`lwc1 f12,4(s1)`);
# the IG-v13 stub returns speed x0.5. Facing lerp 0.1 per call (0x2D5B34) -> 1-sqrt(0.9); falling
# `v += 1/90; y -= v` per call (0x2D5B50) -> gravity /4. Constants read only by PathAnimal_Update.
CODESTUBS = {'pathanimal': (0x15DE70, 0xC62C0004, 'ig_pa_speed'),
             # spawn: both pool allocator entries' `jal 0x8C47C` -> IG-v15 density throttle (continuous emitters x0.5)
             'spawn0': (0x8C894, 0x0C02311F, 'ig_spawn_stub0'), 'spawn1': (0x8C8E4, 0x0C02311F, 'ig_spawn_stub1')}
DATA['pathgrav'] = (0x2D5B50, 0x3C360B62, 0x3B360B62)
# BoltCrankBolt_Update (state 2): y -= DAT_2CE884 and frames +0x70 -= 1.0 per call. The 1.0 is the only
# `lui a0,0xBF80` there (0x120C38) -> -0.5; the drop is runtime-initialised data (0 in the file) -> RUNTIME.
DATA['crankframes'] = (0x120C38, 0x3C04BF80, 0x3C04BF00)
# Runtime-initialised floats halved live; the original is kept in the plugin (ig_saved slot).
RUNTIME = {'crankdrop': (0, 0x2CE884), 'laseracc': (1, 0x2D2D74)}
PARTICLE_POOLS = [(int(p['animator'], 16), int(p['recordSize'], 16)) for p in json.loads(
    (REPO/'research/v2/decomp-summary/level01-particle-pools.json').read_text(encoding='utf-8'))['pools']
    if p['animator'].startswith('0x')]
# Level01Waterfall_Update spawns its mist/splash particles when a parity counter `(n+1) & 1` is 0, i.e.
# every 2nd update (2x the particles at 60 Hz): andi 1 -> 3 at 0x151EDC (every 4th update). Its two texture
# scroll phases step 1/60 (0x2D4890) and 0.025 (0x2D4894) per call -> halved. Constants exclusive.
DATA['wfparity'] = (0x151EDC, 0x30A40001, 0x30A40003)
DATA['wfscroll1'] = (0x2D4890, 0x3C888889, 0x3C088889)
DATA['wfscroll2'] = (0x2D4894, 0x3CCCCCCE, 0x3C4CCCCE)
# phases: per-call constant fade/countdown/phase steps with clamp or wrap, exclusive constants
# (research/v2/decomp-summary/level01-phase-steps.json): HUD fades, ocean sound, bee/decoy/beacon
# countdowns (17.0 per call into int fields: 8.5 truncates to 9, ~6% fast), projectile spin phases.
PHASES = []
for _r in json.loads((REPO/'research/v2/decomp-summary/level01-phase-steps.json').read_text(encoding='utf-8'))['sites']:
    _k = 'ph' + _r['constant']
    if _r['verdict'] == 'PATCH_CANDIDATE' and int(_r['constant'], 16) not in {v[0] for v in DATA.values()}:
        DATA[_k] = (int(_r['constant'], 16), int(_r['before'], 16), int(_r['after'], 16))
        if int(_r['constant'], 16) != 0x2B0E70:   # only user 0x56A04 is substep-only: already correct in C1
            PHASES.append(_k)
# clock: clock users of the frame counter 0x2AF28C (+1 per frame) load the plugin's half-rate copy
# ig_clock[0] instead (lui/lw pairs, research/v2/decomp-summary/level01-clock-sites.json). Needs the
# pump-1 hook (implies telemetry) that refreshes the copy every main update.
CLOCK = [g for g in json.loads((REPO/'research/v2/decomp-summary/level01-clock-sites.json').read_text(encoding='utf-8'))['groups'] if g['exclusive']]
def clock_words(var, base):
    """(rva, original, redirected) words. The lui/lw immediates are relocated by the loader, so the
    original words address base+0x2AF28C (file words are module-relative)."""
    out, ctr = [], base + 0x2AF28C
    hi = lambda a: (a + 0x8000) >> 16 & 0xFFFF
    for g in CLOCK:
        lw = int(g['luiWord'], 16) & 0xFFFF0000; out.append((int(g['lui'], 16), lw | hi(ctr), lw | hi(var)))
        for l in g['loads']:
            w = int(l['word'], 16) & 0xFFFF0000; out.append((int(l['site'], 16), w | (ctr & 0xFFFF), w | (var & 0xFFFF)))
    return out
def stub_orig(orig, base):
    """Original word of a code-stub site; `jal` words are relocated by the loader."""
    return pg.jal(base + ((orig & 0x03FFFFFF) << 2)) if orig >> 26 == 3 else orig
# Fire_Update emission accumulator: acc += 0.6667 per call, spawn floor(acc) particles (20/s at 30 Hz,
# 40/s at 60 Hz). The rate constant 0x2D1708 (also its reciprocal for sub-frame placement) is
# read only by Fire_Update -> halved.
DATA['firerate'] = (0x2D1708, 0x3F2AAAAB, 0x3EAAAAAB)
# springs: engine spring step 0xE290 (v = (t-x)k - v d; x += v, once per update) with constant {k, d}
# structs; refitted 60 Hz pairs from research/v2/decomp-summary/level01-spring-params.json (turning of
# crabs, TM robots, butterflies, boat, Luna, path animals; doors and cranked objects).
SPRINGS = {}
for _r in json.loads((REPO/'research/v2/decomp-summary/level01-spring-params.json').read_text(encoding='utf-8'))['sites']:
    for _f in ('k', 'd'):
        _k = 'sp%s%s' % (_r[_f], _f); DATA[_k] = (int(_r[_f], 16), int(_r[_f+'Before'], 16), int(_r[_f+'After'], 16))
        SPRINGS[_k] = _r['users']
# LunaNPC: jump/walk step 0x2D4EA8 (0.2667 per call; the jump arc is solved per frame from
# distance / step, so halving it doubles the frame count consistently) and idle timer
# rand % 30 + 15 frames (0x154E74 li 30 -> 60, 0x154E80 addiu 15 -> 30).
DATA['lunastep'] = (0x2D4EA8, 0x3E888889, 0x3E088889)
DATA['lunaidle1'] = (0x154E74, 0x3413001E, 0x3413003C)
DATA['lunaidle2'] = (0x154E80, 0x2484000F, 0x2484001E)
# laserbeam: LaserTracer beam fade rate +0x264 = 1/15 (in) and -1/6 (out) per call -> frame counts x2
# (0x2D2DD4, 0x2D2DD8, only used for that rate); beam texture layers scroll by per-call steps at
# layer +0x28/+0x2C (0x146B54; 4 table entries 0x2D360C stride 0x250, 4 layers each, arrays at
# 0x2D2E14 + n*0xE0, stride 0x38) -> halved.
DATA['laserfadein'] = (0x2D2DD4, 0x41700000, 0x41F00000)
DATA['laserfadeout'] = (0x2D2DD8, 0x40C00000, 0x41400000)
LASERBEAM = ['laserfadein', 'laserfadeout']
if _RAW.exists():
    for _n in range(4):
        for _j in range(4):
            for _o in (0x28, 0x2C):
                _s = 0x2D2E14 + _n*0xE0 + _j*0x38 + _o; _w = int.from_bytes(_B[0x74+_s:0x78+_s], 'little')
                if _w & 0x7F800000: DATA['lb%#x' % _s] = (_s, _w, _w - 0x00800000); LASERBEAM.append('lb%#x' % _s)
# butterfly (Butterfly_Update 0x122820, inits 0x1223BC/0x1226B0): flap phase +0x70 += rand(0.833..1.167)
# per call (0x2CEDA8/AC), speed rand(0.01..0.0333) per call (0x2CEDB0/B4, also the spring target),
# speed spring scalars k 0.02 d 0.2 (0x2CEDC8/CC) refitted like `springs`; the +0x6C timer
# (rand%6+9 frames) is in timer-patches.py --class Butterfly. Constants read only by Butterfly code.
DATA['bflap1'] = (0x2CEDA8, 0x3F555556, 0x3ED55556); DATA['bflap2'] = (0x2CEDAC, 0x3F955556, 0x3F155556)
DATA['bspeed1'] = (0x2CEDB0, 0x3C23D70B, 0x3BA3D70B); DATA['bspeed2'] = (0x2CEDB4, 0x3D088889, 0x3C888889)
DATA['bspringk'] = (0x2CEDC8, 0x3CA3D70A, _f2w(0.01256)); DATA['bspringd'] = (0x2CEDCC, 0x3E4CCCCD, _f2w(0.50025))
# crabtimers: reviewed replacement for the quarantined `timer-patches.py --class Crab` batch (10 of its 29
# sites were animation ids, a capacity check and entity/lifecycle flag ORs, see
# research/v2/crab-timer-audit-20261001/REPORT.md): 19 reload sites of Crab data+0x60 x2 and the data+0x64
# cooldown trunc(helper * 15.0) -> 30.0 (research/v2/crab-timer-audit-20261001/crab-timer-recipe-v2.json).
CRABTIMERS = []
for _r in json.loads((REPO/'research/v2/crab-timer-audit-20261001/crab-timer-recipe-v2.json').read_text(encoding='utf-8'))['sites']:
    DATA['ct' + _r['site']] = (int(_r['site'], 16), int(_r['before'], 16), int(_r['after'], 16)); CRABTIMERS.append('ct' + _r['site'])
# infammo (TEST AID, not parity): weapon ammo is field +0x40 of the inventory entry returned by 0x1F71C
# (Blaster stock found live at module+0x2AEA4C; decrement 0x1168E8 by write breakpoint 2026-10-02). Same
# shape in 7 weapon functions: 5 `addiu a0,a0,-1` -> +0, LaserTracer 2 `subu a1,a1,a0` -> `addu a1,a1,zero`.
INFAMMO = []
# 0x175D08 (SuckCannon) excluded: its "ammo" is the sucked objects (owner: infinite but fires nothing).
for _s in (0x110160, 0x115EF8, 0x1168E8, 0x11A1C0, 0x12B178, 0x13B9C8, 0x168B88, 0x16C958, 0x16F884):
    DATA['ammo%#x' % _s] = (_s, 0x2484FFFF, 0x24840000); INFAMMO.append('ammo%#x' % _s)
for _s in (0x14790C, 0x147C04):
    DATA['ammo%#x' % _s] = (_s, 0x00A42823, 0x00A02821); INFAMMO.append('ammo%#x' % _s)
# weapondt: in A0 the player substep loop (0x2FB8C) runs twice per 30 Hz frame and passes the full frame delta
# (1/30) to P_Player_WeaponUpdate each time, so delta-based weapon timers advance 2/30 s per frame. C1 runs the
# loop once with 1/60: weapons run at half the original rate (Blaster measured 4.2 -> 2.0 shots/s, 2026-10-02).
# The delay slot `mov.s f12,f20` of the weapon call (0x2FCF4) becomes `add.s f12,f20,f20` (2 x delta).
DATA['weapondt'] = (0x2FCF4, 0x4600A306, 0x4614A300)
# experiment: the other delta consumer of the loop, 0x39B74 (delay slot 0x2FCE8), role UNKNOWN
DATA['substepdt'] = (0x2FCE8, 0x4600A306, 0x4614A300)
# rynorate (candidate): Ryno refire counter moby+0x70 = 24.0 on fire (0x168A6C, DAT 0x2D6A90 exclusive) and
# -= 1.0 per Ryno_Update call. Owner: TELT (Ryno) fires too fast at 60 FPS -> 24 -> 48 if Ryno_Update runs once
# per frame (to confirm with fix-monitor probe Ryno/refire70: A0 vs C1 duration).
# CAUTION (call-context 2026-10-02): the equipped weapon's update is called from P_Player_WeaponUpdate inside the
# substep loop (Blaster OBSERVED); if Ryno_Update runs there, -1.0 per call is already 60/s in A0 and C1 and
# rynorate would make refire 2x slow. Probe before enabling.
DATA['rynorate'] = (0x2D6A90, 0x41C00000, 0x42400000)
# camfilters: camera filters are exact critically damped steps with dt = 1/30 baked in: per filter omega (data),
# k = omega x 1/30 computed at init by 0xCA24 (one `lui 0x3D08` at 0xCA2C for all) and e = exp(-omega/30)
# precomputed in data (all 20 verified). 60 Hz is exact with k = omega/60 and e = sqrt(e): patch the init literal,
# the already computed k words and the e words. Camera follow/placement smoothing (0x49A0, 0x804C, 0xAE14, ...).
def _f32mul(a, bw): return int.from_bytes(struct.pack('<f', struct.unpack('<f', struct.pack('<I', a))[0] * struct.unpack('<f', struct.pack('<I', bw))[0]), 'little')
CAMFILTERS = ['camf_init']
DATA['camf_init'] = (0xCA2C, 0x3C043D08, 0x3C043C88)
if _RAW.exists():
    for _src, _k, _e in [(r, r+4, r+8) for r in (0x2AA3E0, 0x2AA418, 0x2AA434, 0x2AA440, 0x2AA44C, 0x2AA45C, 0x2AA468, 0x2AA474,
                        0x2AA480, 0x2AA490, 0x2AA4B8, 0x2AA4C8, 0x2AA4D4, 0x2AA4E0, 0x2AA4EC, 0x2AA57C, 0x2AA588, 0x2AA594, 0x2AA5A0)] + [(0x2AA5B8, 0x2AA5C0, 0x2AA5C4)]:
        _om = int.from_bytes(_B[0x74+_src:0x78+_src], 'little'); _ew = int.from_bytes(_B[0x74+_e:0x78+_e], 'little')
        DATA['camf%#x' % _k] = (_k, _f32mul(_om, 0x3D088889), _f32mul(_om, 0x3C888889))
        DATA['camf%#x' % _e] = (_e, _ew, _f2w(struct.unpack('<f', struct.pack('<I', _ew))[0] ** 0.5))
        CAMFILTERS += ['camf%#x' % _k, 'camf%#x' % _e]
# helphint: Level01HelpManager shows the wrench-throw hint after 18000 update frames (10 min at 30 Hz):
# `sltiu a0,a0,18000` at 0x150FC0. 36000 does not fit a signed 16-bit immediate; 32767 = 9.1 min at 60 Hz.
DATA['helphint'] = (0x150FC0, 0x2C844650, 0x2C847FFF)
# framescale (candidate, static 2026-10-02): P_Player_TimingFields (0x360A4, once per frame, outside the substep
# loop) stores +0x578 = dt x 30.0 (`lui a0,0x41F0` at 0x360E8). Only substep code reads it (0x42C04 gun-pose
# countdowns +0x9D4/+0x9D8 -= +0x578, 0x328A0 velocity / +0x578, 0x59D04 speed / +0x578): A0 1.0 per call at
# 60 calls/s, C1 0.5 per call at 60 calls/s. x60.0 restores 1.0 per call. Not in frames30.
DATA['framescale'] = (0x360E8, 0x3C0441F0, 0x3C044270)
# skyrot (candidate, static): Level01SkyController_Update adds DAT 0x2D47D8 (0.000556) to the sky angle per call,
# no delta; only user. Exact half (exponent - 1).
DATA['skyrot'] = (0x2D47D8, 0x3A11A373, 0x3991A373)
# teleporterfx (candidate, static): Teleporter particle effects advance per call with literal 1/30 rates
# (`lui 0x3D08` + `ori 0x8889`): progress rate (1/30)/duration set at spawn 0x6539C and re-set by the record
# callbacks 0x65758/0x65A6C, per-call step +0x54 (0x65228 -> callback 0x65D78), callback 0x65D78 increment,
# emitter rate 0x650EC and animator 0x661FC. All run once per frame (pump 1 / particle walker), none reads the
# delta; classified "scale" by the 1/30 census, hence missing from frametimers. 1/30 -> 1/60.
TELEPORTERFX = []
for _s in (0x65434, 0x65874, 0x65AB0, 0x652B0, 0x65DDC, 0x65174, 0x6638C):
    _w = int.from_bytes(_B[0x74+_s:0x78+_s], 'little') if _RAW.exists() else 0
    DATA['tp%#x' % _s] = (_s, _w, (_w & 0xFFFF0000) | 0x3C88); TELEPORTERFX.append('tp%#x' % _s)
# groupfade (candidate, static): 0x6DF94 (called only by pump 1, once per frame) ramps four global fade channels
# 0x2B2A80..0x2B2A8C toward 0/1 by DAT 0x2B2A7C (0.5) x 1/30 per call: 2 s in A0, 1 s in C1. Consumer 0x6DDE4
# (pump 2) gates a per-moby draw effect 0x784A4 on flag bits DAT_002af280+0x1900; visible role UNKNOWN.
GROUPFADE = []
for _s in (0x6DFD0, 0x6E01C, 0x6E05C, 0x6E0A8, 0x6E0E8, 0x6E134, 0x6E174, 0x6E1C0):
    _w = int.from_bytes(_B[0x74+_s:0x78+_s], 'little') if _RAW.exists() else 0
    DATA['gf%#x' % _s] = (_s, _w, (_w & 0xFFFF0000) | 0x3C88); GROUPFADE.append('gf%#x' % _s)
# k30calls (candidates, static re-audit research/v2/decomp-summary/level01-k30-context-audit.json): literal 1/30 in
# per-call motion of functions that never receive the delta, per-frame context (old census label "scale"/"other"):
# PowerupAmmo/PowerupHealth pop motion pos += v/30 (state-1 helpers 0x16013C, 0x1619C8), flying cars speed x 1/30
# (Directional 0x13E12C, Orbit 0x13F1D0, Pathed 0x14043C + init 0x140C40), TieManipulator init per-call angle rates,
# BoltCrankCam (1/30)/DAT step, Polarizer (1/30)/DAT rate, TripleWaveBeacon alpha step (255/t)/30. 1/30 -> 1/60.
K30CALLS = []
for _s in (0x16014C, 0x1619DC, 0x13E19C, 0x13F274, 0x1409C4, 0x140D00, 0x17A6D0, 0x121070, 0x1210C4, 0x15E844, 0x133FE8):
    _w = int.from_bytes(_B[0x74+_s:0x78+_s], 'little') if _RAW.exists() else 0
    DATA['kc%#x' % _s] = (_s, _w, (_w & 0xFFFF0000) | 0x3C88); K30CALLS.append('kc%#x' % _s)
# tbtimers (reviewed replacement for the quarantined generated TrainingBot list; report F9). Field +0x80 (short)
# per-call counter of the pump-1 TrainingBot states, +0x7C hit-immunity countdown (15 calls). x2 in 60 Hz calls:
#   random reloads rand%30+60 / rand%60+90 (0x186164): moduli and offsets x2 (same range in seconds);
#   float reload rand*30.0+60.0 (0x1844F0, missed by the integer generator): 30.0 -> 60.0, 60.0 -> 120.0;
#   window 50 <= v < 53 (0x185150): both bounds x2 (generator doubled only the upper one);
#   event at v == 2 (0x1853F0) -> 4; hit immunity 15 -> 30 (TrainingBot_slot3 0x18421C).
# Excluded: 0x18456C `li a1,10` is the P_Anim_Start animation id, not a duration.
TBTIMERS = []
for _s, _o, _n in ((0x1862D4, 0x3412001E, 0x3412003C), (0x1862F8, 0x2644003C, 0x26440078),
                   (0x1863A0, 0x3412003C, 0x34120078), (0x1863C4, 0x2644005A, 0x264400B4),
                   (0x1865DC, 0x3412003C, 0x34120078), (0x186600, 0x2644005A, 0x264400B4),
                   (0x184580, 0x3C0441F0, 0x3C044270), (0x18459C, 0x3C044270, 0x3C0442F0),
                   (0x185314, 0x2A240032, 0x2A240064), (0x18531C, 0x2A240035, 0x2A24006A),
                   (0x185450, 0x34050002, 0x34050004), (0x18421C, 0x3404000F, 0x3404001E)):
    DATA['tb%#x' % _s] = (_s, _o, _n); TBTIMERS.append('tb%#x' % _s)
# blastershot (candidate, measured defect 2026-10-02b): BlasterShot moves `pos += v` and ages +1.0 per update;
# v = 21.0 / (10.0 x 0.016667 x 30.0) = 4.2 per update (0x117AE4) and it dies at age 10.0 x 0.016667 x 30.0 = 5
# (BlasterShot_Update 0x118130). A0 ~126 u/s, C1 ~250 u/s and half the life. 30.0 -> 60.0 in both formulas gives
# 2.1 per update for 10 updates: same speed in u/s, same lifetime and range at 60 Hz. Exclusive with age0x118144.
DATA['bshot_speed'] = (0x117B70, 0x3C0641F0, 0x3C064270)
DATA['bshot_life'] = (0x118178, 0x3C0541F0, 0x3C054270)
# rynorocket (candidate, measured defect 2026-10-02b): RynoRocket moves dir x speed per update and lives 36 updates;
# A0 ~24 u/s for ~1.13 s, C1 ~48 u/s for ~0.57 s (same 0.8 step, same age count). Exclusive data: speed 0.8
# (0x2D6A94, read only by Ryno fire 0x168590), life 36.0 (0x2D6B94, RynoRocket_Update + guidance 0x16A080),
# per-call homing turn caps 0x2D6B80..0x2D6B8C (table read by 0x16A080). Halve speed and caps, double life.
# Random wobble kicks per call (0x16A080 -> 0xF470C) are not converted (residual, UNKNOWN visibility).
# Ryno refire (24 calls, substep context) measured ~7.6% fast in C1, NOT 2x: `rynorate` is REJECTED.
RYNOROCKET = ['rr_speed', 'rr_life', 'rr_turn0', 'rr_turn1', 'rr_turn2', 'rr_turn3']
DATA['rr_speed'] = (0x2D6A94, 0x3F4CCCCE, 0x3ECCCCCE)
DATA['rr_life'] = (0x2D6B94, 0x42100000, 0x42900000)
for _i, (_a, _w) in enumerate(((0x2D6B80, 0x3EC19D7F), (0x2D6B84, 0x3EC19D7F), (0x2D6B88, 0x3F20D97C), (0x2D6B8C, 0x3F20D97C))):
    DATA['rr_turn%d' % _i] = (_a, _w, _w - 0x00800000)
# blitzshot (candidate, measured 2026-10-02b): BlitzGunShot (Tremblator shock wave, 8 static records per shot) ages
# +1.0 per update and dies at the integer table DAT 0x2CE3E8[level] = 9 / 14 updates (only reader BlitzGunShot_Update,
# also passed as particle lifetime to 0xC9CC0). A0 life ~0.40 s, C1 ~0.17 s. Table x2 (18 / 28). Exclusive with age0x11c1f0.
DATA['blitz_life0'] = (0x2CE3E8, 9, 18)
DATA['blitz_life1'] = (0x2CE3EC, 14, 28)
# rayfix (candidate): segmented-ray timing as data. Hold `+0x24 += 1/30` per call in 0x5FACC (ft0x5ffa0) and the
# segment fade step 1/(seconds x 30.0) in the segment pool animator 0x60100 (f30 0x60378/0x603A4/0x603E4). Rays of
# Tremblator, Crossbow, ShieldCharger and non-weapon users (pump-1 / particle walker, once per frame). Exclusive with rayhalf.
ALIASES = {'domain8': {'weapondt', 'substepdt', 'framescale'}, 'rayfix': {'ft0x5ffa0', 'f300x60378', 'f300x603a4', 'f300x603e4'}, 'segfade': {'f300x60378', 'f300x603a4', 'f300x603e4'}, 'blastershot': {'bshot_speed', 'bshot_life'}, 'blitzshot': {'blitz_life0', 'blitz_life1'}, 'rynorocket': set(RYNOROCKET), 'tbtimers': set(TBTIMERS), 'teleporterfx': set(TELEPORTERFX), 'groupfade': set(GROUPFADE), 'k30calls': set(K30CALLS),'camfilters': set(CAMFILTERS), 'particles-rate': {'particles-rate', 'particles', 'telemetry'}, 'infammo': set(INFAMMO), 'crabtimers': set(CRABTIMERS), 'butterfly': {'bflap1', 'bflap2', 'bspeed1', 'bspeed2', 'bspringk', 'bspringd', 'sp0x2ced8ck', 'sp0x2ced90d', 'sp0x2cedbck', 'sp0x2cedc0d'},
           'laserbeam': set(LASERBEAM), 'spawn': {'spawn0', 'spawn1', 'telemetry'}, 'springs': set(SPRINGS), 'luna': {'lunastep', 'lunaidle1', 'lunaidle2', 'sp0x2d4e94k', 'sp0x2d4e98d', 'sp0x2d4d5ck', 'sp0x2d4d60d'},
           'clock': {'clock', 'telemetry'}, 'waterfall': {'wfparity', 'wfscroll1', 'wfscroll2'}, 'phases': set(PHASES), 'pathanimals': {'pathanimal', 'pathgrav', 'sp0x2d5b34k', 'sp0x2d5b38d'}, 'crank': {'crankframes', 'crankdrop'},
           'particles-all': {'particles-all', 'particles'}}
FIXES = (*WRAPPERS, *DATA, *CODESTUBS, *RUNTIME, 'particles', 'particles-all', 'particles-rate', 'segrate', 'telemetry', 'clock')
SEG_ANIMATOR = 0x60100   # segmented-ray segment pool animator (segrate: particle mode 3 for this animator only)
# 30 Hz islands (IG-v24): pump-1 class updates run on every other main update (group +0x1C -> ig_classhalf)
CLASSHALF = {'blitzhalf': 0x11C1E8}          # BlitzGunShot (Tremblator shock wave records)
# ray particle callback 0xC9ED8 (life -1, pos += v, fade per call) installed by 0xC9CC0: lui/addiu at 0xC9D74/0xC9D78
CB_LUI, CB_ADDIU, CB_FN = 0xC9D74, 0xC9D78, 0xC9ED8
FIXES = (*FIXES, *CLASSHALF, 'raycb')
def _hi(a): return (a + 0x8000) >> 16 & 0xFFFF
def cb_words(target, base):
    return [(CB_LUI, 0x3C040000 | _hi(base + CB_FN), 0x3C040000 | _hi(target)),
            (CB_ADDIU, 0x24840000 | ((base + CB_FN) & 0xFFFF), 0x24840000 | (target & 0xFFFF))]
def find_group(c, base, upd, wrapper):
    mgr = c.read(base + 0x2CA0D0, 1)[0]; arr, n = c.read(mgr + 0x34, 2)
    for i in range(min(n, 256)):
        g = arr + i * 0x50; p = c.read(g + 0x1C, 1)[0]
        if p in (base + upd, wrapper): return g, p
    return None, None

def resident(c, symbols):
    mods = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive')]
    other = [m['name'] for m in mods if m['name'] not in ('mcp', 'rcp1', 'InterpGate', 'OCEnhance')]   # OCEnhance: optional camera/controls plugin
    if other: raise RuntimeError('refusing: other plugins resident: %s' % other)
    game = [m for m in mods if m['name'] == 'rcp1']; ig = [m for m in mods if m['name'] == 'InterpGate']
    if len(game) != 1 or game[0]['size'] != pg.MODULE_SIZE: raise RuntimeError('LEVEL_01 not unique')
    if len(ig) != 1: raise RuntimeError('InterpGate not loaded')
    addr = {k: ig[0]['address']+v for k, v in symbols.items()}
    for name, sig in plugin_signature().items():
        if [_sigword(w) for w in c.read(addr[name], len(sig))] != sig:
            raise RuntimeError('loaded InterpGate is not %s (code signature mismatch at %s)' % (BUILD.name, name))
    return game[0]['address'], addr

def _is_branch(w):
    """MIPS/Allegrex branch or jump (the next word is its delay slot)."""
    op = w >> 26
    if op in (2, 3, 4, 5, 6, 7, 0x14, 0x15, 0x16, 0x17, 1): return True
    if op == 0x11 and ((w >> 21) & 31) == 8: return True        # bc1f/bc1t(l)
    return op == 0 and (w & 0x3F) in (8, 9)                     # jr / jalr

def _sigword(w):
    """Relocation-free part of an instruction: j/jal keep the opcode only, others the upper half."""
    return w >> 26 << 10 if w >> 26 in (2, 3) else w >> 16

def plugin_signature(n=6):
    """{symbol: upper halves (opcode/registers, relocation-free) of its first n words} for every
    code symbol of the selected build's patch.elf; a differently built plugin mismatches."""
    elf = (BUILD/'patch.elf').read_bytes(); syms = json.loads((BUILD/'manifest.json').read_text(encoding='utf-8'))['symbols']
    shoff, shentsize, shnum = struct.unpack_from('<I', elf, 0x20)[0], *struct.unpack_from('<HH', elf, 0x2E)
    secs = [struct.unpack_from('<IIIIII', elf, shoff+i*shentsize) for i in range(shnum)]
    out = {}
    for name, sym in syms.items():
        for _, typ, flags, sa, so, ss in secs:
            if typ == 1 and flags & 4 and sa <= sym < sa+ss:
                out[name] = [_sigword(struct.unpack_from('<I', elf, so+sym-sa+4*k)[0]) for k in range(n)]
    if 'ig_tel_pump' not in out: raise RuntimeError('ig_tel_pump not found in patch.elf')
    return out

def _half(w): return _f2w(struct.unpack('<f', struct.pack('<I', w))[0] * 0.5)

def state(c, base, addr):
    core = {r: c.read(base+r, 1)[0] for r in (pg.VBLANK, pg.DELTA, pg.LOOP, pg.CALL, pg.DELAY)}
    telemetry = core[pg.CALL] == pg.jal(addr['ig_tel_pump'])
    if telemetry: core[pg.CALL] = pg.jal(base+pg.PUMP1)         # telemetry hook still calls pump 1
    core_state = next((p for p in ('A0', 'C1') if all(core[r] == v for r, v in pg.expected(base, p).items())), 'OTHER')
    fixes = {}
    for name, (callee, sites, sym, _, _) in WRAPPERS.items():
        words = [c.read(base+s, 1)[0] for s in sites]
        fixes[name] = 'off' if all(w == pg.jal(base+callee) for w in words) else \
            'on' if all(w == pg.jal(addr[sym]) for w in words) else 'MIXED'
    for name, (rva, orig, new) in DATA.items():
        w = c.read(base+rva, 1)[0]; fixes[name] = 'off' if w == orig else 'on' if w == new else 'MIXED'
    for name, (rva, orig, sym) in CODESTUBS.items():
        w = c.read(base+rva, 1)[0]; fixes[name] = 'off' if w == stub_orig(orig, base) else 'on' if w == pg.jal(addr[sym]) else 'MIXED'
    for name, (slot, rva) in RUNTIME.items():
        sa, so = c.read(addr['ig_saved']+8*slot, 2); w = c.read(base+rva, 1)[0]
        fixes[name] = 'on' if sa == base+rva and so and w == _half(so) else 'off'
    w = c.read(base+PARTICLE_SITE, 1)[0]
    pm = c.read(addr['ig_pmap'], 5*len(PARTICLE_POOLS)); en = {pm[5*i]-base: pm[5*i+2] for i in range(len(PARTICLE_POOLS))}
    site = 'off' if w == JALR_T0 else 'on' if w == pg.jal(addr['ig_pwrap_stub']) and c.read(addr['ig_pfix'], 1)[0] else 'MIXED'
    fixes['particles'] = 'on' if site == 'on' and en.get(PARTICLE_ANIMATOR) else 'off' if site != 'MIXED' else site
    fixes['particles-all'] = 'on' if site == 'on' and all(en.get(r) == 1 for r, _ in PARTICLE_POOLS) else 'off' if site != 'MIXED' else site
    fixes['particles-rate'] = 'on' if site == 'on' and all(en.get(r) == 2 for r, _ in PARTICLE_POOLS) else 'off' if site != 'MIXED' else site
    fixes['segrate'] = 'on' if site == 'on' and en.get(SEG_ANIMATOR) == 3 else 'off' if site != 'MIXED' else site
    fixes['telemetry'] = 'on' if telemetry else 'off'
    cw = [(c.read(base+r, 1)[0], o, n) for r, o, n in clock_words(addr['ig_clock'], base)]
    fixes['clock'] = 'off' if all(w == o for w, o, _ in cw) else 'on' if all(w == n for w, _, n in cw) else 'MIXED'
    chon = c.read(addr['ig_chalf'], 1)[0]
    for name, rva in CLASSHALF.items():
        g, p = find_group(c, base, rva, addr['ig_classhalf'])
        fixes[name] = 'off' if g is None or p == base + rva else 'on' if chon else 'MIXED'
    cbw = [(c.read(base + r, 1)[0], o, n) for r, o, n in cb_words(addr['ig_cbhalf'], base)]
    fixes['raycb'] = 'off' if all(w == o for w, o, _ in cbw) else 'on' if all(w == n for w, _, n in cbw) and c.read(addr['ig_cb'], 1)[0] else 'MIXED'
    return core_state, fixes

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--target', required=True, choices=('status', 'A0', 'C1'))
    ap.add_argument('--fix', default='', help='comma list: '+','.join(FIXES))
    ap.add_argument('--out', type=Path, required=True); ap.add_argument('--port', type=int, default=60907)
    ap.add_argument('--cam-distance', type=float, default=9.0); ap.add_argument('--cam-height', type=float, default=1.90)
    ap.add_argument('--fov-rad', type=float)
    a = ap.parse_args(); want = {f for f in a.fix.split(',') if f}
    f2w = lambda v: int.from_bytes(struct.pack('<f', v), 'little')
    if 'campos' in want:  # source constants copied into 0x2AA3F4/0x2AA400 by 0xCA24 and read by 0xB958/0x2A90/0x2AB4
        if not (3.0 <= a.cam_distance <= 20.0 and 0.5 <= a.cam_height <= 5.0): ap.error('camera values out of range')
        DATA['campos_d'] = (0x2AA3F0, 0x40A00000, f2w(a.cam_distance)); DATA['campos_h'] = (0x2AA3FC, 0x3F91EB85, f2w(a.cam_height))
        want = (want - {'campos'}) | {'campos_d', 'campos_h'}
    if 'fov' in want:
        if a.fov_rad is None or not 0.3 <= a.fov_rad <= 1.2: ap.error('--fov-rad required (0.3..1.2)')
        DATA['fov'] = (0x2AA3C0, 0x3F0CBE4C, f2w(a.fov_rad))
    if 'cows' in want: want = (want - {'cows'}) | {'cow1', 'cow2', 'cow3'}
    if 'laser' in want: want = (want - {'laser'}) | {'laser1', 'laser2'}
    if 'frames30' in want: want = (want - {'frames30'}) | set(FRAMES30)
    if 'age70' in want: want = (want - {'age70'}) | set(AGE70)
    if 'camera' in want: want = (want - {'camera'}) | set(CAMERA)
    for k, v in ALIASES.items():
        if k in want: want = (want - {k}) | v
    if 'frametimers' in want: want = (want - {'frametimers'}) | set(FRAMETIMERS)
    if want & {'rayhalf', 'segrate', 'raycb', *CLASSHALF}: want |= {'telemetry'}
    if 'blitzhalf' in want and want & {'rayhalf', 'blitz_life0', 'blitz_life1', 'age0x11c1f0'}: ap.error('blitzhalf already runs BlitzGunShot (and its ray machine and life table) at 30 Hz')           # IG-v22 half-rate parity comes from the pump-1 hook
    if 'segrate' in want and want & {'f300x60378', 'f300x603a4', 'f300x603e4'}: ap.error('segrate and segfade double-correct the ray segments')
    # teleporterfx rates are consumed by particle callbacks/animators that particles-rate already runs at 30 Hz
    if 'rayhalf' in want and 'ft0x5ffa0' in want: ap.error('rayhalf and frametimers 0x5FFA0 double-correct the ray hold')
    if 'age0x11c1f0' in want and want & {'blitz_life0', 'blitz_life1'}: ap.error('blitzshot and age70 (0x11c1f0) double-correct BlitzGunShot')
    if 'age0x118144' in want and want & {'bshot_speed', 'bshot_life'}: ap.error('blastershot and age70 (0x118144) double-correct BlasterShot')
    if 'particles-rate' in want and want & set(TELEPORTERFX): ap.error('teleporterfx and particles-rate double-correct the Teleporter effects')
    if want - (set(FIXES) | set(DATA)) - {'cows', 'frametimers', 'laser', 'frames30', 'age70', 'camera', 'fov'}: ap.error('unknown fix')
    if a.target == 'A0' and want - {'telemetry'}: ap.error('A0 takes no fixes (telemetry only)')
    manifest = json.loads((BUILD/'manifest.json').read_text(encoding='utf-8'))
    rec = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'target': a.target, 'fix': sorted(want),
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(), 'prxSha256': manifest['prxSha256'], 'writes': 0}
    c = pg.Client('127.0.0.1', a.port); c.connect(); paused = False
    try:
        base, addr = resident(c, manifest['symbols']); rec['base'] = hex(base)
        rec['before'] = state(c, base, addr)
        if 'OTHER' in rec['before'][0] or 'MIXED' in rec['before'][1].values(): raise RuntimeError('unknown state %r' % (rec['before'],))
        if a.target == 'status': rec['result'] = 'OBSERVED'; return rec
        cpu = c.request('cpu.status')
        if cpu.get('paused') or cpu.get('stepping'): raise RuntimeError('CPU must be running')
        c.request('cpu.stepping'); paused = True
        def put(address, value):
            if c.read(address, 1)[0] != value:
                c.write(address, value); rec['writes'] += 1
                # PPSSPP keeps a branch and its delay slot translated together: a delay-slot edit is not
                # executed until the branch is rewritten (OBSERVED 2026-09-26 waterfall-004 and 2026-10-02:
                # weapondt read back correctly but WeaponUpdate still got 1/60 until 0x2FCF0 was rewritten).
                if base <= address < base + 0x1BF1AC:
                    prev = c.read(address - 4, 1)[0]
                    if _is_branch(prev):
                        c.write(address - 4, prev); rec['jitRefresh'] = rec.get('jitRefresh', 0) + 1
        exp = pg.expected(base, a.target)
        for name, (callee, sites, sym, en, off) in WRAPPERS.items():
            on = name in want
            put(addr[en]+4*off+4, base+callee)                 # original address before redirect
            put(addr[en]+4*off, 1 if on else 0)
            for s in sites: put(base+s, pg.jal(addr[sym]) if on else pg.jal(base+callee))
        for name, (rva, orig, new) in DATA.items(): put(base+rva, new if name in want else orig)
        put(addr['ig_sp']+4, base+0x8C47C); put(addr['ig_sp'], 1 if 'spawn0' in want else 0)
        for name, (rva, orig, sym) in CODESTUBS.items(): put(base+rva, pg.jal(addr[sym]) if name in want else stub_orig(orig, base))
        for name, (slot, rva) in RUNTIME.items():
            sa, so = c.read(addr['ig_saved']+8*slot, 2); w = c.read(base+rva, 1)[0]
            on = sa == base+rva and so and w == _half(so)
            if name in want and not on:
                f = struct.unpack('<f', struct.pack('<I', w))[0]
                if not (w and 1e-6 < abs(f) < 1e6): rec.setdefault('skipped', []).append(name); continue
                put(addr['ig_saved']+8*slot, base+rva); put(addr['ig_saved']+8*slot+4, w); put(base+rva, _half(w))
            elif name not in want and on: put(base+rva, so); put(addr['ig_saved']+8*slot, 0)
        for i, (rva, size) in enumerate(PARTICLE_POOLS):
            e = addr['ig_pmap']+20*i
            put(e, base+rva); put(e+4, size)
            put(e+8, 2 if 'particles-rate' in want else 3 if ('segrate' in want and rva == SEG_ANIMATOR) else 1 if 'particles-all' in want or ('particles' in want and rva == PARTICLE_ANIMATOR) else 0)
        put(addr['ig_pmap']+20*len(PARTICLE_POOLS), 0)
        site_on = 'particles' in want or 'segrate' in want
        put(addr['ig_pfix'], 1 if site_on else 0)
        put(base+PARTICLE_SITE, pg.jal(addr['ig_pwrap_stub']) if site_on else JALR_T0)
        for r in (pg.VBLANK, pg.DELTA, pg.LOOP): put(base+r, exp[r])
        put(addr['ig_tel']+8, base+pg.PUMP1); put(addr['ig_tel']+4, 1 if 'telemetry' in want else 0)
        put(addr['ig_clock']+4, base+0x2AF28C); put(addr['ig_clock'], c.read(base+0x2AF28C, 1)[0] >> 1)
        put(base+pg.CALL, pg.jal(addr['ig_tel_pump']) if 'telemetry' in want else exp[pg.CALL])
        for r, o, n in clock_words(addr['ig_clock'], base): put(base+r, n if 'clock' in want else o)
        for k, (name, rva) in enumerate(CLASSHALF.items()):
            g, p = find_group(c, base, rva, addr['ig_classhalf'])
            if g is None:
                if name in want: raise RuntimeError('%s: class group not present (fire once first)' % name)
                continue
            put(addr['ig_chalf'] + 4 * (2 + 2 * k), g); put(addr['ig_chalf'] + 4 * (3 + 2 * k), base + rva)
            put(g + 0x1C, addr['ig_classhalf'] if name in want else base + rva)
        put(addr['ig_chalf'], 1 if want & set(CLASSHALF) else 0)
        put(addr['ig_cb'] + 4, base + CB_FN); put(addr['ig_cb'], 1 if 'raycb' in want else 0)
        for r, o, n in cb_words(addr['ig_cbhalf'], base): put(base + r, n if 'raycb' in want else o)
        after = state(c, base, addr)
        if after[0] != a.target or any((v == 'on') != (k in want) for k, v in after[1].items() if k not in rec.get('skipped', [])):
            raise RuntimeError('post-write state %r' % (after,))
        c.request('cpu.resume'); paused = False
        t0 = c.request('cpu.status')['ticks']; time.sleep(3); t1 = c.request('cpu.status')['ticks']
        rec['after'] = state(c, base, addr)
        rec['calls'] = {'nav': c.read(addr['ig_disp']+8, 1)[0], 'nav2': c.read(addr['ig_disp']+40, 1)[0],
                        'cows': sum(c.read(addr['ig_disp']+32*k+8, 1)[0] for k in (2, 3, 4)), 'debris': c.read(addr['ig_fix']+8, 1)[0],
                        'particleCalls': c.read(addr['ig_pfix']+8, 1)[0],
                        'particles': c.read(addr['ig_pfix']+12, 1)[0], 'pathanimal': c.read(addr['ig_cnt'], 1)[0],
                        'spawnCalls': c.read(addr['ig_sp']+8, 1)[0], 'spawnWithheld': c.read(addr['ig_sp']+12, 1)[0]}
        if t1 <= t0: raise RuntimeError('ticks did not advance')
        rec['result'] = 'APPLIED_NOT_GAMEPLAY_VALIDATED'
    except Exception as e:
        rec['result'] = 'FAILED'; rec['error'] = str(e)
    finally:
        if paused:
            try: c.request('cpu.resume')
            except Exception as e: rec['resumeError'] = str(e)
        c.close(); a.out.mkdir(parents=True, exist_ok=False)
        (a.out/'result.json').write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    return rec

if __name__ == '__main__':
    r = main(); print(json.dumps(r))
    raise SystemExit(0 if r['result'] in ('OBSERVED', 'APPLIED_NOT_GAMEPLAY_VALIDATED') else 2)
