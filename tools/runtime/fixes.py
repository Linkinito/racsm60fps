#!/usr/bin/env python3
"""Targeted LEVEL_01 60 FPS fixes on top of C1, switchable live (experimental RAM).

Requires the InterpGate plugin (IG-v16f, lean) as the only plugin. Each fix is a guarded
set of word writes; wrappers live in the plugin, data fixes are direct writes.
  nav       ground-navigation displacement halved (0x2A8F0 callers)       [owner: crab speed OK]
  nav2      second navigation mode 0x2935C (Crab/TM robots/TrainingBot)
  frametimers  28 hard-coded 1/30 timer steps -> 1/60 (EnemyWave, Help, Teleporter, ...)
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
  debris    debris physics half-step (0x191D7C callers, 8 shrapnel classes)
  crab      crab attack frame threshold 27 -> 54 (data RVA 0x2CF3C8)    [owner: timing OK]
  particles waterfall particle animator 0xDE23C half-step (walker jalr site 0x8CE54)
  pathanimals PathAnimal walk speed x0.5 (stub at 0x15DE70), turn spring refit and fall gravity (data)
  butterfly Butterfly flap/speed steps halved, speed and turn springs refitted (+ timer-patches --class Butterfly)
  laserbeam LaserTracer beam fade in/out frames x2 and texture scroll steps halved
  spawn     particle density: continuous emitters (same call site on consecutive updates) get half their count
  springs   engine spring 0xE290 {k,d} refitted for 60 Hz at 28 struct sites (turning, doors, cranks)
  luna      LunaNPC step 0x2D4EA8 halved, idle timer x2, Luna turn springs
  crank     BoltCrankBolt frames step 1.0 -> 0.5 (0x120C38) and runtime drop step 0x2CE884 halved
  laseracc  LaserTracer runtime accumulator step 0x2D2D74 halved (role INFERRED)
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
BUILD = REPO/'patches/experimental/interp-gate/build/IG-v16f'
WRAPPERS = {  # name: (callee RVA, call sites, wrapper symbol, enable symbol, word offset)
    # Register-transparent asm stubs (IG-v11) halve the displacement vector passed in a2.
    'nav': (0x2A8F0, (0x29188, 0x29334), 'ig_disp_stub0', 'ig_disp', 0),
    'nav2': (0x2935C, (0x29164,), 'ig_disp_stub1', 'ig_disp', 8),
    'cow1': (0x190D6C, (0x190388,), 'ig_disp_stub2', 'ig_disp', 16),
    'cow2': (0x191154, (0x1915F4,), 'ig_disp_stub3', 'ig_disp', 24),
    'cow3': (0x1913A4, (0x19163C,), 'ig_disp_stub4', 'ig_disp', 32),
    'debris': (0x191D7C, (0x10E41C, 0x116320, 0x1239C8, 0x128230, 0x14328C, 0x17195C, 0x1833FC, 0x186750),
               'ig_debris', 'ig_fix', 0),
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
FRAMETIMERS = [k for k in DATA if k.startswith('ft0x')]
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
        DATA[_k] = (int(_r['constant'], 16), int(_r['before'], 16), int(_r['after'], 16)); PHASES.append(_k)
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
ALIASES = {'butterfly': {'bflap1', 'bflap2', 'bspeed1', 'bspeed2', 'bspringk', 'bspringd', 'sp0x2ced8ck', 'sp0x2ced90d', 'sp0x2cedbck', 'sp0x2cedc0d'},
           'laserbeam': set(LASERBEAM), 'spawn': {'spawn0', 'spawn1', 'telemetry'}, 'springs': set(SPRINGS), 'luna': {'lunastep', 'lunaidle1', 'lunaidle2', 'sp0x2d4e94k', 'sp0x2d4e98d', 'sp0x2d4d5ck', 'sp0x2d4d60d'},
           'clock': {'clock', 'telemetry'}, 'waterfall': {'wfparity', 'wfscroll1', 'wfscroll2'}, 'phases': set(PHASES), 'pathanimals': {'pathanimal', 'pathgrav', 'sp0x2d5b34k', 'sp0x2d5b38d'}, 'crank': {'crankframes', 'crankdrop'},
           'particles-all': {'particles-all', 'particles'}}
FIXES = (*WRAPPERS, *DATA, *CODESTUBS, *RUNTIME, 'particles', 'particles-all', 'telemetry', 'clock')

def resident(c, symbols):
    mods = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive')]
    other = [m['name'] for m in mods if m['name'] not in ('mcp', 'rcp1', 'InterpGate')]
    if other: raise RuntimeError('refusing: other plugins resident: %s' % other)
    game = [m for m in mods if m['name'] == 'rcp1']; ig = [m for m in mods if m['name'] == 'InterpGate']
    if len(game) != 1 or game[0]['size'] != pg.MODULE_SIZE: raise RuntimeError('LEVEL_01 not unique')
    if len(ig) != 1: raise RuntimeError('InterpGate not loaded')
    addr = {k: ig[0]['address']+v for k, v in symbols.items()}
    for name, sig in plugin_signature().items():
        if [_sigword(w) for w in c.read(addr[name], len(sig))] != sig:
            raise RuntimeError('loaded InterpGate is not %s (code signature mismatch at %s)' % (BUILD.name, name))
    return game[0]['address'], addr

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
    fixes['particles'] = 'on' if site == 'on' and en.get(PARTICLE_ANIMATOR) else 'off' if site == 'off' else site
    fixes['particles-all'] = 'on' if site == 'on' and all(en.get(r) for r, _ in PARTICLE_POOLS) else 'off' if site != 'MIXED' else site
    fixes['telemetry'] = 'on' if telemetry else 'off'
    cw = [(c.read(base+r, 1)[0], o, n) for r, o, n in clock_words(addr['ig_clock'], base)]
    fixes['clock'] = 'off' if all(w == o for w, o, _ in cw) else 'on' if all(w == n for w, _, n in cw) else 'MIXED'
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
            if c.read(address, 1)[0] != value: c.write(address, value); rec['writes'] += 1
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
            put(e+8, 1 if 'particles-all' in want or ('particles' in want and rva == PARTICLE_ANIMATOR) else 0)
        put(addr['ig_pmap']+20*len(PARTICLE_POOLS), 0)
        put(addr['ig_pfix'], 1 if 'particles' in want else 0)
        put(base+PARTICLE_SITE, pg.jal(addr['ig_pwrap_stub']) if 'particles' in want else JALR_T0)
        for r in (pg.VBLANK, pg.DELTA, pg.LOOP): put(base+r, exp[r])
        put(addr['ig_tel']+8, base+pg.PUMP1); put(addr['ig_tel']+4, 1 if 'telemetry' in want else 0)
        put(addr['ig_clock']+4, base+0x2AF28C); put(addr['ig_clock'], c.read(base+0x2AF28C, 1)[0] >> 1)
        put(base+pg.CALL, pg.jal(addr['ig_tel_pump']) if 'telemetry' in want else exp[pg.CALL])
        for r, o, n in clock_words(addr['ig_clock'], base): put(base+r, n if 'clock' in want else o)
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
