#!/usr/bin/env python3
"""Refit the engine spring step (LEVEL_01 0xE290) parameters for 60 Hz.

0xE290(target, k, d, max, *x, *v):  v = (target - x) * k - v * d; |v| <= max; x += v
runs once per update, so at 60 Hz a turn/door/crank settles twice as fast. Wrappers
0xE35C/0xE4F4/0xE618/0xE67C/0xE768/0xE864/0x295B4/0x2990C/0x134E5C/0x190948/0x191880
read {k, d, max} from constant structs (call-site review 2026-10-01, listed in SITES).
For each distinct (k, d) the 60 Hz pair minimising the squared error of the unit step
response sampled at the 30 Hz instants (3 s) is found by grid search plus refinement.
The cap (1000 or 100000 per call) never binds and is left unchanged.
Status STATIC_CANDIDATE_NOT_TIMING_OR_PARITY_PROOF. Output: struct RVAs, values, fit.
Usage: python research/scripts/spring-params.py --prx <LEVEL_01.PRX> --out <json>
"""
import argparse, hashlib, json, struct
from pathlib import Path

# struct RVA of k (d at +4): users
SITES = {
    0x2CED8C: 'Butterfly_Update via 0xE864', 0x2CEDBC: 'Butterfly_Update via 0xE864',
    0x2CF31C: 'Crab_Update via 0xE67C; 0x124A3C via 0x2990C (+0xC of 0x2CF310)',
    0x2CF33C: '0x1257D8 via 0x295B4 (Crab)', 0x2CF348: '0x126538 via 0x134E5C (+0xC of 0x2CF33C, Crab)',
    0x2CF3E0: 'Crab_Update via 0xE768', 0x2D15A0: '0x138594 via 0xE864',
    0x2D42EC: 'Level01Boat_Update via 0xE864 (x4)', 0x2D4D5C: 'LunaCutscene_Update via 0x191880',
    0x2D4E94: 'LunaNPC 0x153F28 via 0xE768, LunaNPC_Update via 0xE67C', 0x2D5B34: 'PathAnimal_Update via 0xE864',
    0x2D8740: 'TMRobotHeadB_Update via 0x2990C (+0xC of 0x2D8734)', 0x2D8714: 'TMRobotHeadB_Update via 0xE864/0xE768',
    0x2D8AA0: 'TMRobotTorsoB_Update via 0x2990C (+0xC of 0x2D8A94)', 0x2D8A74: 'TMRobotTorsoB_Update via 0xE67C',
    0x2D8C54: 'TMRobotTorsoCutscene_Update via 0x191880', 0x2D900C: '0x184D50 via 0x2990C (+0xC of 0x2D9000)',
    0x2CCED0: '0x10CF38 via 0x190948', 0x2D289C: 'HutDoor_Update via 0xE35C (scalars k,d,max)',
    0x2CF970: 'CrankedObject_Update via 0xE35C (table 0x2CF968 stride 0x3C, entry 0)',
    0x2D9530: 'TriggeredDoor_Update via 0xE35C (table 0x2D9528 stride 0x20, entry 0)',
    0x2D9550: 'TriggeredDoor_Update via 0xE35C (entry 1)', 0x2D9570: 'TriggeredDoor_Update via 0xE35C (entry 2)',
    # Further table entries with the same layout (k=0.1, d=0.2, cap 1e5); table length INFERRED.
    0x2CF9AC: 'CrankedObject table entry 1', 0x2CF9E8: 'CrankedObject table entry 2', 0x2CFA24: 'CrankedObject table entry 3',
    0x2D9590: 'TriggeredDoor table entry 3', 0x2D95B0: 'TriggeredDoor table entry 4',
}

def run(k, d, n, sub):
    x = v = 0.0; out = []
    for i in range(n*sub):
        v = (1-x)*k - v*d; x += v
        if (i+1) % sub == 0: out.append(x)
    return out

def fit(k, d):
    ref = run(k, d, 90, 1)
    err = lambda a, b: sum((p-q)**2 for p, q in zip(ref, run(a, b, 90, 2)))
    best = min((err(i/2000, j/200), i/2000, j/200) for i in range(4, 400) for j in range(0, 160))
    for step in (40000, 400000):
        e, a, b = best
        best = min((err(a+i/step, b+j/(step/10)), a+i/step, b+j/(step/10)) for i in range(-20, 21) for j in range(-20, 21))
    return best

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--prx', type=Path, required=True); ap.add_argument('--out', type=Path, required=True)
    a = ap.parse_args(); prx = a.prx.read_bytes()
    word = lambda r: struct.unpack_from('<I', prx, 0x74+r)[0]; flt = lambda r: struct.unpack_from('<f', prx, 0x74+r)[0]
    fits, sites = {}, []
    for r, users in sorted(SITES.items()):
        k, d = round(flt(r), 6), round(flt(r+4), 6)
        if (k, d) not in fits:
            e, k2, d2 = fit(k, d); fits[(k, d)] = (k2, d2, e, sum((p-q)**2 for p, q in zip(run(k, d, 90, 1), run(k, d, 90, 2))))
        k2, d2, e, e0 = fits[(k, d)]
        sites.append({'k': '0x%x' % r, 'd': '0x%x' % (r+4), 'users': users, 'k30': k, 'd30': d, 'k60': round(k2, 5), 'd60': round(d2, 5),
                      'kBefore': '0x%08x' % word(r), 'dBefore': '0x%08x' % word(r+4),
                      'kAfter': '0x%08x' % struct.unpack('<I', struct.pack('<f', k2))[0],
                      'dAfter': '0x%08x' % struct.unpack('<I', struct.pack('<f', d2))[0],
                      'fitError': e, 'uncorrectedError': e0})
    rec = {'status': 'STATIC_CANDIDATE_NOT_TIMING_OR_PARITY_PROOF', 'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           'prxSha256': hashlib.sha256(prx).hexdigest(), 'sites': sites}
    a.out.write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    for (k, d), (k2, d2, e, e0) in fits.items(): print('k %.3f d %.3f -> k %.5f d %.5f  err %.2e (uncorrected %.2e)' % (k, d, k2, d2, e, e0))

if __name__ == '__main__':
    main()
