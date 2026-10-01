#!/usr/bin/env python3
"""Find per-call constant phase/fade/countdown steps read from exclusive data constants.

Pattern (local full decompilation): `v = x +- DAT_<c>;` followed within three lines by a
clamp or wrap on v (`if (v < 0.0)` or `if (1.0 <= v)`), i.e. a value advanced by a fixed
amount per call and clamped/wrapped. A site is a patch candidate when the constant is
referenced by exactly one function, is never assigned, and its file value is a plain
non-zero float; the 60 Hz candidate value is half of it. Exclusions are listed with a
reason in the output. Output (no code text): function, constant RVA, value, verdict.
Status STATIC_CANDIDATE_NOT_TIMING_OR_PARITY_PROOF.
Usage: python research/scripts/phase-steps.py --all <dir> --prx <LEVEL_01.PRX> --out <json>
"""
import argparse, glob, hashlib, json, math, re, struct
from pathlib import Path

EXCLUDE = {  # constant RVA: reason
    '0x2d488c': 'Level01Waterfall spawn accumulator inside the every-2nd-update block (fixed by the parity patch)',
    '0x2d489c': 'Level01Waterfall spawn accumulator inside the every-2nd-update block (fixed by the parity patch)',
    '0x2b27ec': 'step 4.0 reaches the 1.0 limit in one call; role unknown',
    '0x2c9c2c': 'particle animator field (covered by the generic particle half-step)',
}

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--all', type=Path, required=True); ap.add_argument('--prx', type=Path, required=True)
    ap.add_argument('--out', type=Path, required=True)
    a = ap.parse_args()
    prx = a.prx.read_bytes()
    texts = {Path(f).stem: Path(f).read_text(encoding='utf-8', errors='replace') for f in glob.glob(str(a.all/'c'/'*.c'))}
    users, written = {}, set()
    for f, t in texts.items():
        for d in set(re.findall(r'DAT_([0-9a-f]{8})', t)): users.setdefault(d, set()).add(f)
        written |= set(re.findall(r'DAT_([0-9a-f]{8}) = ', t))
    pat = re.compile(r'(\w+) = ([^;]*?) ([+-]) DAT_([0-9a-f]{8});\n(?:[^\n]*\n){0,2}?\s*if \((?:\1 < 0\.0|1\.0 <= \1|1\.0 < \1)\)')
    sites = {}
    for f, t in sorted(texts.items()):
        name = re.search(r'\b(\w+)\(', t.split('{')[0]); name = name.group(1) if name else f
        for m in pat.finditer(t):
            d = m.group(4); rva = '0x%x' % int(d, 16)
            w = struct.unpack_from('<I', prx, 0x74+int(d, 16))[0]; v = struct.unpack('<f', struct.pack('<I', w))[0]
            e = (w >> 23) & 0xFF
            reason = EXCLUDE.get(rva) or ('shared constant' if len(users[d]) > 1 else 'assigned somewhere' if d in written
                                          else 'not a plain non-zero float' if not (w and 0x40 <= e <= 0xBE and math.isfinite(v)) else None)
            sites.setdefault(rva, {'constant': rva, 'function': f, 'functionName': name, 'value': v, 'before': '0x%08x' % w,
                                   'after': '0x%08x' % (w - 0x00800000) if not reason else None, 'op': m.group(3),
                                   'verdict': 'PATCH_CANDIDATE' if not reason else 'EXCLUDED', 'reason': reason})
    rec = {'status': 'STATIC_CANDIDATE_NOT_TIMING_OR_PARITY_PROOF', 'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           'prxSha256': hashlib.sha256(prx).hexdigest(), 'sites': sorted(sites.values(), key=lambda s: s['constant'])}
    a.out.write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    print(sum(s['verdict'] == 'PATCH_CANDIDATE' for s in rec['sites']), 'candidates of', len(rec['sites']))

if __name__ == '__main__':
    main()
