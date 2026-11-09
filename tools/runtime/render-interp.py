#!/usr/bin/env python3
"""RI-v1 prototype driver: gate pump 1 (every 2nd update) and blend moving records before pump 2.

Experimental RAM patch of LEVEL_01 (Pokitaru) from a debugger session; no plugin. Requires the A0
word state at every site (checked), a zero cave 0x2C1818..0x2C23FF, CPU running, no breakpoints.
Targets:  apply [--mode 1|2]   builds the blob for the live base, writes cave + hooks + C1 core words
          mode N               runtime switch (0 passthrough at 60 Hz = B-like, 1 gate only, 2 gate+blend)
          status               prints counters
          remove               mode 0, wait, restore the A0 words
Counters (ri_st): 0 mode, 1 phase, 3 runs, 4 skips, 5 frames, 6 blended last frame, 7 slot cap,
8 init (1 ok, 2 alloc failed), 9 total blended, 10 backup count.
Usage: python tools/runtime/render-interp.py apply --mode 2 --out <new dir>
"""
import argparse, importlib.util, json, subprocess, sys, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pg', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)

LINK, CAVE_END = 0x2C1818, 0x2C281C
CALL1, CALL2, CALLF = 0x15230, 0x15338, 0x13FB0
PUMP2, FRAME = 0x6E6D4, 0x159DC
FOGRESET, LIGHTS, PRIMRESET, SCRATCH, PARTICLES, FLUSH = 0x88768, 0x159A0, 0x8DC14, 0x7D510, 0x8CC18, 0x8E2D4
HILINK, HIEND = 0x2B7700, 0x2B9000     # second cave (zero padding before the first pointer into the run at 0x2B7B2C)
ENTITYCALL, JALR_A1 = 0x6B9B8, 0x00A0F809   # `jalr a1` in group pump 1 (a0 set in its delay slot, f12 = delta)
BSHOT = {0x117B70: (0x3C0641F0, 0x3C064270), 0x118178: (0x3C0541F0, 0x3C054270)}   # accepted BlasterShot speed/life words (60 Hz object)
RYNO = {0x2D6A94: (0x3F4CCCCE, 0x3ECCCCCE), 0x2D6B94: (0x42100000, 0x42900000), 0x2D6B80: (0x3EC19D7F, 0x3E419D7F), 0x2D6B84: (0x3EC19D7F, 0x3E419D7F),
        0x2D6B88: (0x3F20D97C, 0x3EA0D97C), 0x2D6B8C: (0x3F20D97C, 0x3EA0D97C)}   # RynoRocket speed, life, homing turn caps (fixes.py rynorocket) for a 60 Hz rocket
SHOCK = {0x2D74A0: (0x3DA0D97C, 0x3D20D97C), 0x2D74A4: (0x3DA0D97C, 0x3D20D97C)}
SHOCK.update({a: (0x3E20D97C, 0x3DA0D97C) for a in range(0x2D74A8, 0x2D74C0, 4)})
SHOCK.update({0x2D74C4: (0x42700000, 0x42F00000), 0x2D74C8: (0x3F4CCCCE, 0x3ECCCCCE), 0x2D74D0: (0x41700000, 0x41F00000)})   # ShockRocketShot turn caps, life 60->120, speed 0.8->0.4, blast 15->30 (standalone/build.py shockrocket family)
FIXSETS = {'bshot': BSHOT, 'ryno': RYNO, 'shock': SHOCK}
# weapon update delta (player substep loop gives the weapon call 2 x delta, as A0 ran it twice per 30 Hz frame);
# word at a delay slot: the preceding branch must be rewritten too (JIT, GOTCHAS)
WEAPONDT = (0x2FCF4, 0x4600A306, 0x4614A300)   # accepted weapondt: delay slot of the weapon call, 2 x delta (JIT: rewrite the jal before it)
HELPCALL, HELPFN = 0x9DEAC, 0xA47B8     # jal FUN_000A47B8 in the HUD update (single call site)
# owner-accepted manual camera words (tools/runtime/fixes.py): original -> 1/60 literals, with the C1 core
CAMERA = {0x308C: (0x3C063D08, 0x3C063C88), 0x361C: (0x3C043D08, 0x3C043C88), 0x37E0: (0x3C043D08, 0x3C043C88),
          0x3634: (0x3C04BD08, 0x3C04BC88), 0x37F8: (0x3C04BD08, 0x3C04BC88)}

def find_calls(c, base, targets):
    ws = c.read(base+0x1517C, 200); out = {}
    for name, t in targets.items():
        hits = [0x1517C+4*i for i, w in enumerate(ws) if w == pg.jal(base+t)]
        if len(hits) != 1: raise SystemExit('call site for %s not unique: %s' % (name, hits))
        out[name] = hits[0]
    return out

def a0_words(base, sites=None, wtarget=None):
    wtarget = None
    w = {r: o for r, (o, n) in CAMERA.items()}
    w[HELPCALL] = pg.jal(base+HELPFN)
    w[WEAPONDT[0]] = WEAPONDT[1]
    w[ENTITYCALL] = JALR_A1
    if sites: w.update({sites['fog']: pg.jal(base+FOGRESET), sites['lights']: pg.jal(base+LIGHTS), sites['prim']: pg.jal(base+PRIMRESET), sites['particles']: pg.jal(base+PARTICLES), sites['flush']: pg.jal(base+FLUSH)})
    return {**w, pg.VBLANK: pg.jal(base+pg.VBLANK_STUB), pg.DELTA: 0x3C043D08, pg.LOOP: 0x2A240002,
            CALL1: pg.jal(base+pg.PUMP1), CALL2: pg.jal(base+PUMP2), CALLF: pg.jal(base+FRAME)}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('target', choices=('apply', 'mode', 'status', 'remove', 'off', 'cls', 'bshot', 'ryno', 'shock', 'xfade'))
    ap.add_argument('value', nargs='?', type=int)
    ap.add_argument('--mode', type=int, default=2)
    ap.add_argument('--port', type=int, default=60907)
    ap.add_argument('--rvas', default='', help='cls: comma separated class update RVAs run at 60 Hz (empty clears)')
    ap.add_argument('--out', type=Path)
    a = ap.parse_args()
    c = pg.Client('127.0.0.1', a.port); c.connect()
    if c.request('game.status').get('game', {}).get('id') != 'UCES00420': raise SystemExit('UCES00420 required')
    mods = {m['name']: m for m in c.request('hle.module.list')['modules'] if m.get('isActive')}
    if 'rcp1' not in mods or mods['rcp1']['size'] not in (0x46B900, 0x473100): print('warning: unexpected rcp1 size', hex(mods['rcp1']['size']))
    base = mods['rcp1']['address']
    cpu = c.request('cpu.status')
    if cpu.get('paused') or cpu.get('stepping') or c.request('cpu.breakpoint.list').get('breakpoints'): raise SystemExit('CPU must run without breakpoints')
    saved = json.loads((REPO/'tmp/render-interp-last.json').read_text()).get('sites', {}) if (REPO/'tmp/render-interp-last.json').exists() else {}
    sites = {}
    for name, t in {'fog': FOGRESET, 'lights': LIGHTS, 'prim': PRIMRESET, 'particles': PARTICLES, 'flush': FLUSH}.items():
        try: sites[name] = find_calls(c, base, {name: t})[name]
        except SystemExit:
            if name not in saved: raise
            sites[name] = saved[name]
    sites = {k: int(v) for k, v in sites.items()}
    wtarget = None
    exp = a0_words(base, sites, wtarget)
    cur = {r: c.read(base+r, 1)[0] for r in exp}
    # blob location is fixed once built; symbol table read from the build output when applied earlier
    if a.target in ('status', 'mode', 'remove', 'off', 'cls', 'bshot', 'ryno', 'shock', 'xfade'):
        st_addr = int(json.loads((REPO/'tmp/render-interp-last.json').read_text())['st'], 16) if (REPO/'tmp/render-interp-last.json').exists() else None
        if st_addr is None: raise SystemExit('no applied build recorded (tmp/render-interp-last.json)')
        if json.loads((REPO/'tmp/render-interp-last.json').read_text())['base'] != hex(base): raise SystemExit('base changed since apply')
        st = lambda: c.read(st_addr, 32)
        if a.target == 'status':
            s = st(); print(json.dumps({'words_are_A0': cur == exp, 'mode': s[0], 'runs': s[3], 'skips': s[4], 'frames': s[5], 'blended_last': s[6], 'cap': s[7], 'init': s[8], 'blended_total': s[9], 'backup': s[10], 'others_wrote': s[11], 'fog_resets_skipped': s[12], 'light_resets_skipped': s[13], 'particle_vertices_mixed': s[14], 'scratch_kept': s[17], 'pad_merges': s[18], 'prim_replays': s[19], 'particle_vertices_seen': s[20], 'weapon_skips': s[21], 'rng_sync': s[22], 'flush_rng_update': s[23], 'flush_rng_skipped': s[24], 'rng_replays': s[25], 'off_mask': s[26]}))
            return
        if a.target == 'xfade':
            c.write(st_addr+21*4, a.value); print('sprite cross-fade', 'on' if c.read(st_addr+21*4, 1)[0] else 'off'); return
        if a.target == 'cls':
            addrs = [base+int(x, 0) for x in a.rvas.split(',') if x.strip()][:8]
            clsa = int(json.loads((REPO/'tmp/render-interp-last.json').read_text())['cls'], 16)
            for i in range(8): c.write(clsa+4*i, addrs[i] if i < len(addrs) else 0)
            print('classes at 60 Hz:', [hex(x) for x in c.read(clsa, 8)]); return
        if a.target in FIXSETS:
            words = FIXSETS[a.target]
            lj = json.loads((REPO/'tmp/render-interp-last.json').read_text())
            for r, (o, n) in words.items(): lj['originals'].setdefault(hex(r), c.read(base+r, 1)[0])
            (REPO/'tmp/render-interp-last.json').write_text(json.dumps(lj))
            c.request('cpu.stepping')
            try:
                for r, (o, n) in words.items():
                    if c.read(base+r, 1)[0] not in (o, n): raise SystemExit('%s word %#x unexpected: %#x' % (a.target, r, c.read(base+r, 1)[0]))
                for r, (o, n) in words.items(): c.write(base+r, n if a.value else o)
            finally: c.request('cpu.resume')
            print(a.target, '60 Hz words', 'on' if a.value else 'off', [hex(c.read(base+r, 1)[0]) for r in words]); return
        if a.target == 'off':
            c.write(st_addr+26*4, a.value); print('off mask', c.read(st_addr+26*4, 1)[0]); return
        if a.target == 'mode':
            c.write(st_addr, a.value); time.sleep(0.2); print('mode', st()[0]); return
        # remove: restore every recorded original word, then check nothing still points into the cave before zeroing it
        lastj = json.loads((REPO/'tmp/render-interp-last.json').read_text())
        orig = {int(k, 16): v for k, v in lastj.get('originals', {}).items()} or exp
        c.write(st_addr, 0); time.sleep(0.3)
        c.write(st_addr+16*4, 1)
        for _ in range(40):
            time.sleep(0.1)
            if c.read(st_addr+16*4, 1)[0] == 2: break
        print('block released:', c.read(st_addr+16*4, 1)[0] == 2)
        c.request('cpu.stepping')
        try:
            for r, w in orig.items():
                if c.read(base+r, 1)[0] != w:
                    c.write(base+r, w)
                    if r == WEAPONDT[0]: c.write(base+r-4, c.read(base+r-4, 1)[0])   # JIT refresh
            cavelo, cavehi = base+LINK, base+CAVE_END
            hlo, hhi = base+HILINK, base+HIEND
            for r in range(0x1517C, 0x15400, 4):         # main update
                w = c.read(base+r, 1)[0]; tg = ((w & 0x3FFFFFF) << 2) | (base & 0xF0000000)
                if w >> 26 == 3 and (cavelo <= tg < cavehi or hlo <= tg < hhi): raise SystemExit('call at %#x still points into the cave; not zeroing' % r)
            for r in (0x2FCF0, 0x9DEAC, 0x13FB0, ENTITYCALL):
                w = c.read(base+r, 1)[0]
                if w >> 26 == 3 and (cavelo <= (((w & 0x3FFFFFF) << 2) | (base & 0xF0000000)) < cavehi or hlo <= (((w & 0x3FFFFFF) << 2) | (base & 0xF0000000)) < hhi): raise SystemExit('call at %#x still points into the cave; not zeroing' % r)
        finally:
            c.request('cpu.resume')
        # Calls that were in flight when the CPU was paused may still have a return address inside the caves: let the game
        # run for a while with every hook removed so they finish, and only then clear the caves (owner crash 2026-11-09).
        time.sleep(1.5)
        c.request('cpu.stepping')
        try:
            pc = c.request('cpu.status')['pc']
            if cavelo <= pc < cavehi or hlo <= pc < hhi: raise SystemExit('CPU is inside a cave (pc %#x); not zeroing, run remove again' % pc)
            for i in range(0, (HIEND-HILINK)//4):
                if c.read(base+HILINK+4*i, 1)[0]: c.write(base+HILINK+4*i, 0)
            for i in range(0, (CAVE_END-LINK)//4):
                if c.read(base+LINK+4*i, 1)[0]: c.write(base+LINK+4*i, 0)
        finally:
            c.request('cpu.resume')
        time.sleep(1); print('removed; words A0:', all(c.read(base+r, 1)[0] == w for r, w in exp.items()), 'backup', st()[10]); return
    # apply
    if cur != exp: raise SystemExit('site words are not the A0 state: %s' % {hex(k): hex(v) for k, v in cur.items()})
    cave = c.read(base+LINK, (CAVE_END-LINK)//4)
    if any(cave): raise SystemExit('cave not zero')
    if any(c.read(base+HILINK, (HIEND-HILINK)//4)): raise SystemExit('second cave not zero')
    out = a.out or (REPO/'tmp/render-interp-build'); 
    subprocess.run([sys.executable, str(REPO/'patches/experimental/render-interp/build.py'), '--base', hex(base), '--out', str(out)], check=True, stdout=subprocess.DEVNULL)
    info = json.loads((out/'ri.json').read_text()); blob = (out/'ri.bin').read_bytes()
    if len(blob) % 4 or LINK+len(blob) > CAVE_END: raise SystemExit('blob does not fit the cave')
    words = [int.from_bytes(blob[i:i+4], 'little') for i in range(0, len(blob), 4)]
    hiblob = (out/'ri.hi.bin').read_bytes()
    if len(hiblob) % 4 or HILINK+len(hiblob) > HIEND: raise SystemExit('hi blob does not fit the second cave')
    hiwords = [int.from_bytes(hiblob[i:i+4], 'little') for i in range(0, len(hiblob), 4)]
    sy = {k: int(v, 16) for k, v in info['symbols'].items()}
    st_off = sy['ri_st']-(base+LINK)
    words[st_off//4] = a.mode
    originals = {hex(r): c.read(base+r, 1)[0] for r in list(exp) + [WEAPONDT[0]]}
    c.request('cpu.stepping')
    try:
        if c.read(base+pg.CALL, 1)[0] != exp[CALL1]: raise SystemExit('changed while pausing')
        for i, w in enumerate(words): c.write(base+LINK+4*i, w)
        for i, w in enumerate(hiwords): c.write(base+HILINK+4*i, w)
        if c.read(base+LINK, len(words)) != words or c.read(base+HILINK, len(hiwords)) != hiwords: raise SystemExit('cave read-back mismatch')
        c.write(base+pg.VBLANK, 0); c.write(base+pg.DELTA, 0x3C043C88); c.write(base+pg.LOOP, 0x2A240001)
        for r, (o, n) in CAMERA.items(): c.write(base+r, n)
        c.write(base+sites['fog'], pg.jal(sy['ri_fog'])); c.write(base+sites['lights'], pg.jal(sy['ri_lights'])); c.write(base+sites['prim'], pg.jal(sy['ri_prim'])); c.write(base+HELPCALL, pg.jal(sy['ri_help'])); c.write(base+sites['particles'], pg.jal(sy['ri_particles'])); c.write(base+ENTITYCALL, pg.jal(sy['ri_entity'])); c.write(base+sites['flush'], pg.jal(sy['ri_flush']))
        c.write(base+WEAPONDT[0], WEAPONDT[2]); c.write(base+WEAPONDT[0]-4, c.read(base+WEAPONDT[0]-4, 1)[0])   # JIT refresh
        c.write(base+CALL1, pg.jal(sy['ri_pump1'])); c.write(base+CALL2, pg.jal(sy['ri_pump2'])); c.write(base+CALLF, pg.jal(sy['ri_frame']))
    finally:
        c.request('cpu.resume')
    (REPO/'tmp/render-interp-last.json').write_text(json.dumps({'base': hex(base), 'st': hex(sy['ri_st']), 'blob_sha': __import__('hashlib').sha256(blob).hexdigest(), 'sites': sites, 'wtarget': wtarget, 'originals': originals, 'cls': hex(sy['ri_cls'])}))
    t0 = c.request('cpu.status')['ticks']; time.sleep(3)
    s = c.read(sy['ri_st'], 32); t1 = c.request('cpu.status')['ticks']
    print(json.dumps({'ticks_advanced': t1 > t0, 'mode': s[0], 'runs': s[3], 'skips': s[4], 'frames': s[5], 'cap': s[7], 'init': s[8], 'particle_vertices_mixed': s[14], 'particle_vertices_seen': s[20]}))

if __name__ == '__main__': main()
