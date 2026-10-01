#!/usr/bin/env python3
"""Numeric fix monitor: per-update telemetry from InterpGate IG-v12, in game seconds.

Requires `fixes.py ... --fix telemetry` (pump-1 call 0x15230 -> ig_tel_pump). Once per main
update the plugin samples up to 64 watches (read-only) and accumulates per-update changes
and the delta passed to pump 1. Rates are therefore per GAME second and comparable between
A0 (30 Hz) and C1 (60 Hz). This tool:
  1. lists active pump-1 entities (group array +0x0C, 0x80-byte records, flag +0x64 bit 0),
  2. watches explicit timing probes (PROBES) and the position of up to --per-class
     instances of every active class,
  3. samples the watch block every 0.25 s for --seconds wall seconds,
  4. reports hook call rates, rates/top speeds/reload durations per game second, the
     theoretical A0 expectation where one is known statically, and ratios against an A0
     baseline recorded by this tool (--save-baseline / --compare).
Measurements are TELEMETRY_NOT_GAMEPLAY_VALIDATED; visual validation stays with the owner.
Usage:
  python tools/runtime/fix-monitor.py --seconds 10 --out <new dir> [--save-baseline <file>]
  python tools/runtime/fix-monitor.py --seconds 10 --out <new dir> --compare <baseline file>
"""
import argparse, hashlib, importlib.util, json, statistics, struct, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
def _load(name, path):
    s = importlib.util.spec_from_file_location(name, path); m = importlib.util.module_from_spec(s); s.loader.exec_module(m); return m
fx = _load('fixes', REPO/'tools/runtime/fixes.py'); pg = fx.pg
MANAGER, GROUP_STRIDE, RECORD = 0x2CA0D0, 0x50, 0x80
WATCHES, WWORDS = 64, 16
KIND = {'f32': 1, 's32': 2, 's16': 3, 'vec3': 4}

# Explicit timing probes. path: offsets from the entity record; every element but the last
# is dereferenced. a0Frames: state durations in 30 Hz frames (static, timer-patch spec);
# rateA0: expected change per game second while changing (static per-call step x 30).
PROBES = {
    'Crab': [{'name': 'stateTimer', 'path': [0x58, 0x60], 'kind': 's32', 'limit': 1.5,
              'a0Frames': [[45, 89], [30, 89], [90, 149], [120, 179], [90, 119], [4, 4], [27, 27]]},
             {'name': 'counter64', 'path': [0x58, 0x64], 'kind': 's32', 'limit': 1.5, 'a0Frames': [[15, 15], [8, 8]]}],
    'TrainingBot': [{'name': 'stateTimer', 'path': [0x58, 0x80], 'kind': 's16', 'limit': 1.5,
                     'a0Frames': [[4, 4], [10, 10], [30, 60], [60, 90]]}],
    'Lvl3Elevator': [{'name': 'progress', 'path': [0x54, 0x8], 'kind': 'f32', 'limit': 0.5,
                      'note': 'trip seconds = 1/activeRate if progress spans 0..1 (A0 Pokitaru trip measured 10 s)'}],
    # Blaster (Blaster_Update 0x116A00, pvar = moby+0x58): refire cooldown pvar+4 (-= dt, reloaded on fire)
    # and hold timer pvar+0xB4 (+= dt, re-arm past 0.3). Both only advance through P_Player_WeaponUpdate.
    'Blaster': [{'name': 'cooldown', 'path': [0x58, 0x4], 'kind': 'f32', 'limit': 0.1},
                {'name': 'holdTimer', 'path': [0x58, 0xB4], 'kind': 'f32', 'limit': 0.1}],
    # Ryno (Ryno_Update 0x168C28): refire counter moby+0x70 = 24.0 on fire, -1.0 per call.
    'Ryno': [{'name': 'refire70', 'path': [0x70], 'kind': 'f32', 'limit': 2.0}],
    'BoltCrankBolt': [{'name': 'framesLeft70', 'path': [0x70], 'kind': 'f32', 'limit': 2.0, 'rateA0': 30.0}],
    'Level01Boat': [{'name': 'fade70', 'path': [0x70], 'kind': 'f32', 'limit': 0.5, 'rateA0': 2.0}],
}
HOOKS = {'nav': ('ig_disp', 8), 'nav2': ('ig_disp', 40), 'cow1': ('ig_disp', 72), 'cow2': ('ig_disp', 104),
         'cow3': ('ig_disp', 136), 'debris': ('ig_fix', 8), 'particles': ('ig_pfix', 8),
         'particleRecords': ('ig_pfix', 12, 'particles'), 'pathanimal': ('ig_cnt', 0), 'spawnCalls': ('ig_sp', 8, 'spawn0'), 'spawnWithheld': ('ig_sp', 12, 'spawn0')}

def f32(w): return struct.unpack('<f', struct.pack('<I', w))[0]
def bits(x): return struct.unpack('<I', struct.pack('<f', x))[0]

def classes():
    t = json.loads((REPO/'research/v2/decomp-summary/level01-class-updates.json').read_text(encoding='utf-8'))['classes']
    return {int(c['update'], 16): c['class'] for c in t}

def entities(c, base, names):
    mgr = c.read(base+MANAGER, 1)[0]; arr, n = c.read(mgr+0x34, 2); out = {}
    for i in range(min(n, 256)):
        g = c.read(arr+i*GROUP_STRIDE, 20)
        if (g[19] & 0xFFFF) + (g[19] >> 16) == 0: continue
        cls = names.get(g[7]-base, 'cb_%x' % (g[7]-base)); recs = g[3]; cap = min(g[15], 512)
        flags = c.read(recs, cap*RECORD//4)[0x64//4::RECORD//4] if cap else []
        live = [recs+k*RECORD for k, f in enumerate(flags) if f & 1]
        if live: out.setdefault(cls, []).extend(live)
    return out

def resolve(c, ent, path):
    a = ent
    for off in path[:-1]:
        a = c.read(a+off, 1)[0]
        if not 0x08800000 <= a < 0x0A000000: return None
    return a+path[-1]

def plan(c, ents, per_class, only):
    watches = []
    for cls in sorted(ents):
        if only and cls not in only: continue
        for p in PROBES.get(cls, []):
            for ent in ents[cls][:per_class]:
                a = resolve(c, ent, p['path'])
                if a: watches.append({'class': cls, 'probe': p['name'], 'entity': ent, 'addr': a, 'kind': p['kind'], 'limit': p['limit']})
    for cls in sorted(ents):
        if only and cls not in only: continue
        for ent in ents[cls][:per_class]:
            watches.append({'class': cls, 'probe': 'pos', 'entity': ent, 'addr': ent+0x30, 'kind': 'vec3', 'limit': 4.0})
    return watches[:WATCHES]

def in_ranges(x, ranges, tol): return any(lo-tol <= x <= hi+tol for lo, hi in ranges)

def analyse(w, words, ups, dt_sum, reload_values):
    n, changes = words[2], words[3]; sum_abs, max_step = f32(words[7]), f32(words[8])
    r = {'class': w['class'], 'probe': w['probe'], 'entity': hex(w['entity']), 'updates': n, 'changes': changes,
         'jumps': words[12], 'reloads': words[9]}
    if not n or not ups: return r
    r['ratePerGameSecond'] = sum_abs/dt_sum if dt_sum else None
    r['activeRatePerGameSecond'] = sum_abs/changes*ups if changes else 0.0
    r['maxRatePerGameSecond'] = max_step*ups
    r['signedRatePerGameSecond'] = f32(words[13])/dt_sum if dt_sum else None
    if reload_values:
        r['reloadSeconds'] = [round(v/ups, 3) for v in reload_values]
    p = next((p for p in PROBES.get(w['class'], []) if p['name'] == w['probe']), {})
    if 'a0Frames' in p and reload_values:
        a0 = [[lo/30, hi/30] for lo, hi in p['a0Frames']]; fast = [[lo/60, hi/60] for lo, hi in p['a0Frames']]
        tol = 1.5/30
        ok = sum(1 for s in r['reloadSeconds'] if in_ranges(s, a0, tol))
        fastonly = sum(1 for s in r['reloadSeconds'] if in_ranges(s, fast, tol/2) and not in_ranges(s, a0, tol))
        r['theory'] = {'a0Seconds': a0, 'withinA0': ok, 'only2xFast': fastonly, 'samples': len(r['reloadSeconds'])}
    if 'rateA0' in p and changes:
        r['theory'] = {'rateA0': p['rateA0'], 'ratio': r['activeRatePerGameSecond']/p['rateA0']}
    if 'note' in p: r['note'] = p['note']
    return r

def verdict(ratio):
    if ratio is None: return 'n/a'
    if 0.8 <= ratio <= 1.25: return 'OK'
    if 1.6 <= ratio <= 2.5: return '2x FAST'
    if 0.4 <= ratio <= 0.62: return '2x SLOW'
    return 'CHECK'

def aggregate(rows):
    agg = {}
    for r in rows:
        if not r.get('changes'): continue
        k = r['class']+'/'+r['probe']; a = agg.setdefault(k, {'maxRate': 0.0, 'activeRates': [], 'reloadSeconds': []})
        a['maxRate'] = max(a['maxRate'], r.get('maxRatePerGameSecond') or 0.0)
        a['activeRates'].append(r.get('activeRatePerGameSecond') or 0.0); a['reloadSeconds'] += r.get('reloadSeconds', [])
    for a in agg.values():
        a['activeRate'] = statistics.median(a.pop('activeRates')) if a.get('activeRates') else 0.0
        a['reloadMedian'] = statistics.median(a['reloadSeconds']) if a['reloadSeconds'] else None
    return agg

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--seconds', type=float, default=10.0); ap.add_argument('--out', type=Path, required=True)
    ap.add_argument('--per-class', type=int, default=2); ap.add_argument('--classes', default='')
    ap.add_argument('--save-baseline', type=Path); ap.add_argument('--compare', type=Path)
    ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args(); only = {x for x in a.classes.split(',') if x}
    manifest = json.loads((fx.BUILD/'manifest.json').read_text(encoding='utf-8'))
    rec = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'status': 'TELEMETRY_NOT_GAMEPLAY_VALIDATED',
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(), 'prxSha256': manifest['prxSha256']}
    c = pg.Client('127.0.0.1', a.port); c.connect(); paused = False
    try:
        base, addr = fx.resident(c, manifest['symbols']); rec['base'] = hex(base)
        core, fixes = fx.state(c, base, addr); rec['core'] = core; rec['fixes'] = {k: v for k, v in fixes.items() if v != 'off'}
        if fixes.get('telemetry') != 'on': raise RuntimeError('telemetry hook is off: run fixes.py with --fix ...,telemetry')
        ents = entities(c, base, classes()); rec['activeClasses'] = {k: len(v) for k, v in sorted(ents.items())}
        watches = plan(c, ents, a.per_class, only); rec['watches'] = len(watches)
        hook0 = {k: c.read(addr[h[0]]+h[1], 1)[0] for k, h in HOOKS.items()}
        npm = len(fx.PARTICLE_POOLS); pm0 = c.read(addr['ig_pmap'], 5*npm)
        old = c.read(addr['ig_watch'], WATCHES*WWORDS)
        c.request('cpu.stepping'); paused = True
        for i in range(WATCHES):
            wa = addr['ig_watch']+i*WWORDS*4
            if i < len(watches):
                w = watches[i]
                for off, val in ((0, w['addr']), (15, bits(w['limit'])), (1, KIND[w['kind']])):
                    if old[i*WWORDS+off] != val: c.write(wa+off*4, val)
            elif old[i*WWORDS+1]: c.write(wa+4, 0)
        c.write(addr['ig_tel']+24, 1)                                 # reset request
        c.request('cpu.resume'); paused = False
        t0, reloads, seen = time.time(), [[] for _ in watches], [0]*len(watches)
        while time.time()-t0 < a.seconds:
            time.sleep(0.25)
            blk = c.read(addr['ig_watch'], len(watches)*WWORDS) if watches else []
            for i in range(len(watches)):
                w = blk[i*WWORDS:(i+1)*WWORDS]
                if w[9] > seen[i]:
                    reloads[i].append(f32(w[10])); seen[i] = w[9]
        wall = time.time()-t0
        tel = c.read(addr['ig_tel'], 8); blk = c.read(addr['ig_watch'], len(watches)*WWORDS) if watches else []
        hook1 = {k: c.read(addr[h[0]]+h[1], 1)[0] for k, h in HOOKS.items()}
        pm1 = c.read(addr['ig_pmap'], 5*npm)
        updates, dt_sum = tel[3], f32(tel[4]); ups = updates/dt_sum if dt_sum else 0.0
        rec['timing'] = {'updates': updates, 'gameSeconds': round(dt_sum, 3), 'wallSeconds': round(wall, 3),
                         'updatesPerGameSecond': round(ups, 2), 'lastDelta': f32(tel[5]),
                         'emulationSpeed': round(dt_sum/wall, 3) if wall else None,
                         'theory': {'A0': 30, 'C1': 60}.get(core)}
        rec['hooksPerGameSecond'] = {k: round((hook1[k]-hook0[k]) % 2**32/dt_sum, 1) if dt_sum else None for k, h in HOOKS.items()
                                     if fixes.get(h[2] if len(h) > 2 else k) == 'on'}
        if fixes.get('particles') == 'on' and dt_sum:
            rec['particleRecordsPerGameSecond'] = {'%#x' % (pm1[5*i]-base): round((pm1[5*i+4]-pm0[5*i+4]) % 2**32/dt_sum, 1)
                                                   for i in range(npm) if pm1[5*i+2] and pm1[5*i+4] != pm0[5*i+4]}
        rows = [analyse(w, blk[i*WWORDS:(i+1)*WWORDS], ups, dt_sum, reloads[i]) for i, w in enumerate(watches)]
        rec['rows'] = rows; agg = aggregate(rows); rec['aggregate'] = agg
        if a.compare:
            bl = json.loads(a.compare.read_text(encoding='utf-8'))
            if bl.get('core') != 'A0': rec['compareWarning'] = 'baseline is not A0'
            cmp = {}
            for k, v in agg.items():
                b = bl['aggregate'].get(k)
                if not b: continue
                ratio = lambda x, y: x/y if x and y else None
                # Countdown timers tick once per update by design; only their durations are comparable.
                timer = any('a0Frames' in p for p in PROBES.get(k.split('/')[0], []) if p['name'] == k.split('/')[1])
                cmp[k] = {'maxRate': None if timer else ratio(v['maxRate'], b['maxRate']),
                          'activeRate': None if timer else ratio(v['activeRate'], b['activeRate']),
                          # durations: a shorter duration means faster, so the speed ratio is baseline / current
                          'reload': ratio(b['reloadMedian'], v['reloadMedian'])}
                cmp[k]['verdict'] = {m: verdict(x) for m, x in cmp[k].items() if m != 'verdict'}
            rec['compare'] = {'baseline': str(a.compare), 'baselineCore': bl.get('core'), 'ratios': cmp}
        rec['result'] = 'OBSERVED'
    except Exception as e:
        rec['result'] = 'FAILED'; rec['error'] = str(e)
    finally:
        if paused:
            try: c.request('cpu.resume')
            except Exception as e: rec['resumeError'] = str(e)
        c.close(); a.out.mkdir(parents=True, exist_ok=False)
        (a.out/'result.json').write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
        if a.save_baseline and rec['result'] == 'OBSERVED':
            a.save_baseline.parent.mkdir(parents=True, exist_ok=True)
            a.save_baseline.write_text(json.dumps({k: rec[k] for k in ('utc', 'core', 'fixes', 'timing', 'aggregate')}, indent=1)+'\n', encoding='utf-8')
        (a.out/'report.md').write_text(report(rec), encoding='utf-8')
    return rec

def report(rec):
    L = ['# Fix monitor report', '', 'Status: %s. Result: %s.' % (rec['status'], rec['result'])]
    if rec['result'] != 'OBSERVED': return '\n'.join(L+['', 'Error: %s' % rec.get('error')])+'\n'
    t = rec['timing']
    L += ['', 'Core %s, fixes on: %s.' % (rec['core'], ', '.join(sorted(k for k in rec['fixes'] if not k.startswith(('ft0x', 'f300x', 'age0x')))) or 'none'),
          'Updates per game second %s (theory %s); emulation speed %s; %s game s over %s wall s.' % (
              t['updatesPerGameSecond'], t['theory'], t['emulationSpeed'], t['gameSeconds'], t['wallSeconds']), '',
          'Hook calls per game second: %s' % (', '.join('%s %s' % kv for kv in rec['hooksPerGameSecond'].items()) or 'none'), '',
          'Particle records corrected per game second (animator: n): %s' % (', '.join('%s %s' % kv for kv in rec.get('particleRecordsPerGameSecond', {}).items()) or 'none'), '',
          '| Class/probe | top rate /s | active rate /s | reload s (median) | speed vs A0 (top/active/duration) |', '|---|---:|---:|---:|---|']
    cmp = rec.get('compare', {}).get('ratios', {})
    for k, v in sorted(rec['aggregate'].items()):
        c = cmp.get(k); cs = ' / '.join('%s %s' % ('%.2f' % c[m] if c[m] else '-', c['verdict'][m]) for m in ('maxRate', 'activeRate', 'reload')) if c else ''
        L.append('| %s | %.3f | %.3f | %s | %s |' % (k, v['maxRate'], v['activeRate'], '%.2f' % v['reloadMedian'] if v['reloadMedian'] else '', cs))
    th = [r for r in rec['rows'] if r.get('theory')]
    if th:
        L += ['', 'Static theory checks:']
        for r in th: L.append('- %s/%s %s: %s' % (r['class'], r['probe'], r['entity'], json.dumps(r['theory'])))
    return '\n'.join(L)+'\n'

if __name__ == '__main__':
    r = main(); print(json.dumps({k: r.get(k) for k in ('result', 'error', 'core', 'timing', 'hooksPerGameSecond', 'compare') if k in r}, indent=1))
    raise SystemExit(0 if r['result'] == 'OBSERVED' else 2)
