#!/usr/bin/env python3
"""Build the LEVEL_01 annotation set (function names, plate and address comments).

Hand-written entries summarise the 2026-09-30/10-01 findings; generated entries come from
the committed summaries (phase steps, clock sites, springs, age70, frames30, frame-time
constants, particle pools, class table). Output is addresses + our own English text only
(no game code), applied to the LOCAL Ghidra copy by ghidra/ApplyAnnotations.java.
Evidence words follow docs/methodology/EVIDENCE_LEVELS.md; names are tentative.
Usage: python research/scripts/build-annotations.py --out research/v2/decomp-summary/level01-annotations.json
"""
import argparse, hashlib, json
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
S = REPO/'research/v2/decomp-summary'
def load(n): return json.loads((S/n).read_text(encoding='utf-8'))

FUNCTIONS = {  # rva: (name or None to keep, plate comment)
    0x13F0C: ('P_LevelLoop', 'Level loop. While the state word is -1: frame counter 0x2AF28C += 1, then the per-frame '
              'function 0x159DC. The counter is the game clock of 30+ users (see fix "clock"). OBSERVED.'),
    0x1517C: (None, 'Per-frame main update. 0x151E0 loads the shared delta 1/30 (C1: lui 0x3D08 -> 0x3C88 = 1/60); '
              'pump 1 at 0x15230 (f12 = delta; telemetry hook ig_tel_pump), pump 2 at 0x15338, particle walker at 0x15348. '
              'C1 also removes the 2nd VBlank wait (jal at 0x96650) and sets player substeps slti 2->1 (0x2FCFC).'),
    0x6B7F4: (None, 'Pump 1: groups at *(0x2CA0D0)+0x34 (count +0x38, stride 0x50; callback +0x1C, records +0x0C, '
              'capacity +0x3C, live counts u16 +0x4C/+0x4E). Records 0x80 bytes: pos +0x30, flags +0x64 (bit0 active), '
              'activation radius byte +0x76 vs reference 0x369640. Callback(f12 delta, a0 moby) via jalr 0x6B9B8.'),
    0x6E6D4: (None, 'Pump 2 (draw/visibility): draw radius byte +0x77, frustum test 0x68EB4.'),
    0x8CC18: (None, 'Particle walker: for each registered pool calls its animator with jalr t0 at 0x8CE54 '
              '(a0 vertex out, a1 first vertex, a2 instance list sentinel, a3 pool params). Instance: +8 records, '
              '+12 u16 first, +14 u16 count; dead particles are swap-removed inside the animator. Fixes "particles(-all)".'),
    0x8BA64: ('P_Particles_RegisterPool', 'Registers a particle pool (handle, id, animator, record size, ...). 49 calls in LEVEL_01.'),
    0x8C86C: ('P_Particles_Alloc', 'Allocate count particles in pool id: 0x8C47C(out, pool, a2, count); *out = allocated, '
              'returns record pointer or 0 (pool full). jal at 0x8C894 -> IG-v15 density throttle (fix "spawn").'),
    0x8C8A8: ('P_Particles_AllocForInstance', 'Second allocator entry (12 callers); jal 0x8C47C at 0x8C8E4 (fix "spawn").'),
    0x8C47C: ('P_Particles_AllocCore', 'Core allocator. Failure path: *out = 0, return 0 (callers handle it).'),
    0xE290: ('P_Spring_Step', 'Spring step once per call: v = (target - x) * k - v * d; |v| <= max; x += v. Not delta '
             'scaled: settles 2x faster at 60 Hz. 60 Hz {k,d} refits in level01-spring-params.json (fix "springs").'),
    0xE35C: ('P_Spring_Step2', 'Two P_Spring_Step calls (target, k, d, max, x*, v*).'),
    0xE4F4: ('P_Spring_Vec3', 'Spring on three components with params {k, d, max}.'),
    0xE618: ('P_Spring_Face_A', 'Facing spring wrapper -> 0xE67C.'),
    0xE67C: ('P_Spring_Face_B', 'Facing spring wrapper -> 0xE768 (params struct {k, d, max}).'),
    0xE768: ('P_Spring_Face', 'Turns an orientation toward a target with P_Spring_Step2 (params struct {k, d, max}).'),
    0xE864: ('P_Spring_FaceDir', 'Facing spring on a direction (P_Spring_Vec3) then rebuilds the basis (used by PathAnimal, '
             'Butterfly, Boat, TM robots).'),
    0x2A8F0: (None, 'Ground navigation move: pos += a2 float[3] per call (not delta scaled). Callers 0x29188/0x29334 -> '
              'IG asm stub halves the vector (fix "nav", owner-accepted for crabs).'),
    0x2935C: (None, 'Second navigation move (call site 0x29164) -> fix "nav2".'),
    0x190D6C: (None, 'Displacement mover (MutantCow/MadCow/AgentOfDoom), site 0x190388 -> fix "cows".'),
    0x191154: (None, 'Displacement mover, site 0x1915F4 -> fix "cows".'),
    0x1913A4: (None, 'Displacement mover, site 0x19163C -> fix "cows".'),
    0x191D7C: (None, 'Shrapnel physics per call: life +0x70 -= step, v.y -= g, pos += v (8 call sites, fix "debris").'),
    0x6C318: ('P_AnimAttachPoint', 'REJECTED as a timing step: 0x6C2B8 -> 0xF5624 copies the moby position into out, '
              'then animation/camera offsets are added: an absolute point (effects/attachments).'),
    0x7248: ('P_LookAtMatrix', 'Builds a look-at matrix and translates it (ArmorPickup/TitaniumBolt pickup cameras). '
             'Not a displacement integrator (REJECTED candidate).'),
    0x3060: ('P_Camera_Input', 'Camera input: yaw (R - L) and pitch (Up - Down, needs flag 0x2DD451 bit 3) with 1/30 '
             'literals per call; camera state +0x274/+0x278. OCEnhance hooks it for the right stick; fix "camera" (1/60).'),
    0x35B0: ('P_Camera_Yaw', 'Yaw integration per call (1/30 literal, fix "camera").'),
    0x37AC: ('P_Camera_Pitch', 'Pitch integration per call (1/30 literal, fix "camera").'),
    0x7740: ('P_Camera_FollowYaw', 'Follow-yaw assist: cap 1/30 x 4 sites, gain 0.6 per call -> 1 - sqrt(0.4) (fix "camera").'),
    0xAD0: ('P_Camera_ResetFOV', 'Every frame resets FOV 0x2AA3C0 (0.5498 rad), near 1.0, far 10000.0. View constants '
            'pattern used by OCEnhance (distance 5.0 at +0x30, height 1.14 at +0x3C).'),
    0x75454: ('P_Pad_Update', 'Controller poll (sceCtrlPeekBufferPositive stub at +0x24); OCEnhance filters L2/R2 there.'),
    0x137D9C: (None, 'EnemyWave: state 1 counts down by a literal 1/30 per update (0x137F5C, fix "frametimers"); '
               'state 2 uses the delta. Field +0x15C of the target is an enemy count, not a timer.'),
    0x151D78: (None, 'Level01Waterfall: spawns mist/splash particles when (n+1)&1 == 0 (andi at 0x151EDC; fix '
               '"waterfall" -> &3), texture scroll steps 0x2D4890/0x2D4894 per call.'),
    0x13A51C: (None, 'Fire: emission accumulator acc += 0.667 (0x2D1708) per call, spawns floor(acc) (fix "firerate").'),
    0x15DD3C: (None, 'PathAnimal: pos += fwd * speed (moby+0x54 -> +4, per call; stub at 0x15DE70 fix "pathanimals"), '
               'facing spring 0x2D5B34, fall v += 1/90 (0x2D5B50); y -= v per call.'),
    0x120A80: (None, 'BoltCrankBolt state 2: y -= DAT_2CE884 (runtime value) and +0x70 -= 1.0 (0x120C38) per call (fix "crank").'),
    0x122820: (None, 'Butterfly: pos += fwd * speed (data moby+0x54: +0x50), flap phase +0x70 += +0x5C per call, '
               'speed spring 0x2CEDC8, timer +0x6C. Fix "butterfly" (owner-accepted 2026-10-01).'),
    0x1223BC: ('Butterfly_Init', 'Draws speed rand(0x2CEDB0..B4) and flap step rand(0x2CEDA8..AC) per butterfly.'),
    0x1226B0: ('Butterfly_NewTarget', 'New speed target and timer rand%6+9 frames (timer-patches Butterfly).'),
    0x153F28: ('LunaNPC_JumpStep', 'Luna jump: pos += dir * 0x2D4EA8 per call, vy += g (+0x498) per call; +0x4A0 frames left.'),
    0x153718: ('LunaNPC_PlanJump', 'Solves the jump arc per frame: frames = distance / 0x2D4EA8 (fix "luna" keeps it consistent).'),
    0x154D7C: ('LunaNPC_SetState', 'Idle timer +0x4A0 = rand%30+15 frames (0x154E74/0x154E80, fix "luna").'),
    0x146B54: ('LaserTracer_BeamScroll', 'Beam fade +0x264 per call and per-layer texture scroll (table 0x2D360C) (fix "laserbeam").'),
    0x149284: ('LaserTracer_Sparks', 'Spark spawn deadline = frame counter + rand%10+10 (fix "clock").'),
    0x172FB8: (None, 'Skill point "train faster": window (counter - start) < 0xAC8 frames (fix "clock"; never also double 2760).'),
    0x126F28: (None, 'Crab update: pvar = moby+0x58; +0x64 counter -1 per update; state timer +0x60 (count-up, attack '
               'threshold data 0x2CF3C8 = 27 frames). Fixes "crab" + timer-patches Crab (owner-accepted).'),
    0x185B34: (None, 'TrainingBot: s16 timer pvar+0x80 (timer-patches TrainingBot).'),
    0x156710: (None, 'Lvl3Elevator: progress +8 += +0xC per call (moby+0x54 data); init 0x1563E8 computes '
               '(1/moveTime)*(1/30) (fix "elevator").'),
    0x14EB68: (None, 'Level01Boat: fade/progress moby+0x70 -= 1/15 per call (0x2D42FC, fix "boatfade"); countdown seconds x 30.'),
    0x2FB8C: (None, 'Player substep loop (domain 8): when player flag +0x95C & 0x8000, runs its body twice per frame in A0 '
              '(C1 slti 2->1 at 0x2FCFC) and passes the full frame delta to 0x39B74 (delay slot 0x2FCE8) and '
              'P_Player_WeaponUpdate (0x2FCF4) each time: dt consumers got 2 x 1/30 per A0 frame. See docs/WHY_60FPS_IS_HARD.md.'),
    0x39B74: ('P_Player_StepTimed', 'Player step that receives the frame delta; calls 0x32588 (player timers).'),
    0x32588: ('P_Player_TimersTick', 'Player timers +0xA00/+0xA08/+0xA0C/+0xA14/+0xA18 -= dt (idle/fidget timers, reloads '
              'rand(10..24) from 0x2B0138..48). Run twice per frame in A0 -> half speed in C1 (fix "substepdt").'),
    0x1EBC4: (None, 'P_Player_WeaponUpdate: f20 = delta; calls the held weapon class slot (+0x1C) via jalr 0x1F2D0 with that '
              'delta. Other callers 0x1E4E8/0x1E610 pass 0 (weapon switch).'),
    0x116A00: (None, 'Blaster_Update(dt, moby): pvar = moby+0x58; refire cooldown pvar+4 -= dt (reloaded on fire), hold timer '
               'pvar+0xB4 += dt (re-arm past 0.3, double shot 0.4333); fires through 0x116534 when cooldown == 0 and '
               'gun state +0x45 is 0/4. Measured A0 4.2 shots/s, C1 2.0 shots/s (2026-10-02).'),
    0x116534: ('Blaster_Fire', 'Spawns shots (0x1167E8) and consumes ammo (0x1168A0).'),
    0x1168A0: ('Blaster_UseAmmo', 'Inventory entry 0x1F71C(2, id) +0x40 -= 1 (0x1168E8; fix "infammo").'),
    0x1F71C: ('P_Inventory_GetEntry', 'Returns the weapon inventory entry (ammo at +0x40). Blaster entry at module+0x2AEA0C.'),
    0x2832C: ('P_SmallPhys_Step', 'Small-object physics per call: rec+0x24 life -= 1, pos += vel + g/2, vel.y += g, '
              '+0x34 -= 1 when settled. Bolts (0x11EE20) and crate debris (0x2ED88). Fix "physstep" (IG-v18 ig_phys).'),
    0x11EC70: ('BoltPool_Update', 'Bolt pool (0x4686B4, table 0x2CE790) per-frame update -> 0x2832C.'),
    0x2EB90: ('PhysPool_Update', 'Generic physics pool (0x46A230, table 0x2B008C) per-frame update -> 0x2832C; fed by '
              'Crate/CrateAmmo through 0x2E92C (crate debris are NOT particles).'),
    0x2E92C: ('PhysPool_Spawn', 'Spawns an object into the generic physics pool (crate debris).'),
    0x93E60: ('P_ObjPool_Init', 'Initialises an object pool list with a callback table (+0x10 = per-frame update). 10 pools.'),
    0x93F64: ('P_ObjPool_Alloc', 'Allocates from an object pool (bolts etc.).'),
    0x64F9C: ('P_FxEmitter_Tick', 'Emitter timer += 1/30 per call (0x64FA0, fix "frametimers"); spawns effect particles at '
              'its interval (teleporter). Emitted particles still move per call (fix "particles-rate").'),
    0x2C84: ('P_Camera_Recentre', 'Recentres the camera behind the player when the pad word has L+R held (== 0x300); '
             'OCEnhance R3 injects L+R only inside this call.'),
    0xB958: ('P_Camera_ApplyDefaults', 'Every frame copies default params, incl. target pitch 0x2AA40C -> 0x2DD4D8 '
             '(OCEnhance moves that default for vertical look).'),
    0x804C: ('P_Camera_AutoPitch', 'Auto pitch toward the target pitch 0x2DD4D8 (active while moving).'),
    0x9444: ('P_Camera_Place', 'Camera placement with ground collision; writes pitch 0x2DD4C4.'),
    0x88180: ('P_Model_DrawMesh', 'Emits mesh texture offsets (GE UOFFSET 0x4A / VOFFSET 0x4B) from mesh data +0x24/+0x28.'),
    0xCA24: ('P_Camera_InitFilters', 'Computes k = omega x 1/30 (one lui at 0xCA2C) for the 20 critically damped camera filters '
             '(omega, k, exp(-omega/30)); exact 60 Hz: k = omega/60, e = sqrt(e) (fix "camfilters").'),
    0x49A0: (None, 'Camera smoothing with the exact critically damped step: v=(v+e k)E; x=t+v+e E; v-= x k (constants 0x2AA474..).'),
    0x5C650: (None, 'Player-side damped filter (0x2B0FD8 triplet) inside the player substep loop: already 60 Hz in A0, no fix.'),
    0x150EF8: (None, 'Level01HelpManager: view-map hint timer += 1/30 (0x150F0C, "frametimers"); wrench hint after 18000 frames '
               '(sltiu 0x150FC0, "helphint").'),
    0x168C28: (None, 'Ryno_Update: refire counter moby+0x70 = 24 on fire (0x168A6C, DAT 0x2D6A90), -1 per call (candidate "rynorate").'),
}
ADDRESS = {  # rva: comment (instruction or data)
    0x96650: 'C1: second VBlank wait (jal) -> nop.',
    0x151E0: 'C1: shared delta lui 0x3D08 (1/30) -> 0x3C88 (1/60).',
    0x2FCFC: 'C1: player substep limit slti 2 -> 1.',
    0x15230: 'jal pump 1; telemetry/clock hook redirects it to ig_tel_pump.',
    0x8CE54: 'jalr t0 (particle animator); fix "particles" -> jal ig_pwrap_stub.',
    0x2AF28C: 'Global frame counter (+1 per frame in 0x13F0C).',
    0x2CF3C8: 'Crab attack threshold 27.0 frames (fix "crab" -> 54).',
    0x2AEA4C: 'Blaster ammo (inventory entry +0x40), found live 2026-10-02.',
    0x2AA40C: 'Default target pitch 0.0, copied every frame by 0xB958 (OCEnhance vertical look).',
    0x2FCE8: 'Delay slot mov.s f12,f20 of jal 0x39B74 (fix "substepdt" -> add.s, 2 x dt).',
    0x2FCF4: 'Delay slot mov.s f12,f20 of jal P_Player_WeaponUpdate (fix "weapondt" -> add.s, 2 x dt).',
    0x2AA3C0: 'View constants: FOV 0.5498, near 1.0, far 10000; +0x30 distance 5.0; +0x3C height 1.14 (OCEnhance).',
}

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0]); ap.add_argument('--out', type=Path, required=True)
    a = ap.parse_args()
    fn = {'0x%x' % r: {'name': n, 'comment': c} for r, (n, c) in FUNCTIONS.items()}
    def add_fn(rva, text):
        e = fn.setdefault(rva, {'name': None, 'comment': ''})
        if text not in e['comment']: e['comment'] = (e['comment'] + ' ' + text).strip()
    addr = {'0x%x' % r: c for r, c in ADDRESS.items()}
    for s in load('level01-phase-steps.json')['sites']:
        if s['verdict'] == 'PATCH_CANDIDATE':
            add_fn(s['function'], 'Per-call phase/fade step DAT_%s = %g (fix "phases").' % (s['constant'][2:], s['value']))
            addr[s['constant']] = 'Per-call step %g read by %s (fix "phases" halves it).' % (s['value'], s['functionName'])
    for g in load('level01-clock-sites.json')['groups']:
        add_fn(g['function'], 'Clock user of frame counter 0x2AF28C: %s (fix "clock").' % g['role'])
        for l in g['loads']: addr[l['site']] = 'Frame counter load (fix "clock" -> ig_clock half-rate copy).'
    for s in load('level01-spring-params.json')['sites']:
        addr[s['k']] = 'Spring k=%g d=%g (%s); 60 Hz refit k=%g d=%g (fix "springs").' % (s['k30'], s['d30'], s['users'], s['k60'], s['d60'])
    for n in ('level01-age70-sites.json', 'level01-age70-reviewed-sites.json'):
        for s in load(n)['sites']:
            addr[s['site']] = 'Age +0x70 += 1.0 per call (%s); fix "age70" -> 0.5.' % s['class']
            add_fn(s['fn'], 'Entity age +0x70 += 1.0 per call (fix "age70").')
    for s in load('level01-frames30-sites.json')['sites']:
        addr[s['site']] = '30.0 frames-per-second conversion; fix "frames30" -> 60.0.'
    for s in load('level01-frame-time-constants.json')['sites']:
        addr.setdefault(s['site'], 'Literal 1/30 (%s)%s.' % (s['kind'], '; fix "frametimers" -> 1/60' if s['kind'].startswith('timer') else ''))
    for p in load('level01-particle-pools.json')['pools']:
        if p['animator'].startswith('0x'):
            add_fn(p['animator'], 'Particle animator, record 0x%x bytes (registered by %s); generic half-step "particles-all".'
                   % (int(p['recordSize'], 16), p['registeredBy']))
    rec = {'status': 'TENTATIVE_NAMES_STATIC_FINDINGS', 'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           'functions': dict(sorted(fn.items(), key=lambda kv: int(kv[0], 16))),
           'addresses': dict(sorted(addr.items(), key=lambda kv: int(kv[0], 16)))}
    a.out.write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    print(len(rec['functions']), 'functions,', len(rec['addresses']), 'address comments')

if __name__ == '__main__':
    main()
