#!/usr/bin/env python3
"""Extract the LEVEL_01 class registration table (static, OBSERVED layout, INFERRED roles).

Descriptor layout found by pointer search (2026-09-30): word1 class-name string,
words 2..5 code pointers (word4 = pump-1 update callback for known classes),
word6 embedded property-definition string, word7/word8 sizes (INFERRED: config
block size, runtime block size), words 9..11 optional code pointers. Pointers are
unrelocated RVAs in the file. Output: research/v2/class-table/level01-classes.json.
Usage: python research/scripts/class-table.py
"""
import hashlib, json, re, struct
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
PRX = REPO/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX'
SHA = 'd10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571'
T, TEXT_END, DATA_LO, DATA_HI = 0x74, 0x1BF1AC, 0x2A9E80, 0x2DD080
NAME = re.compile(rb'[A-Za-z_][A-Za-z0-9_]{2,48}')

def main():
    raw = PRX.read_bytes()
    if hashlib.sha256(raw).hexdigest() != SHA: raise SystemExit('vanilla hash mismatch')
    w = lambda rva: struct.unpack_from('<I', raw, T+rva)[0]
    def cstr(rva):
        end = raw.index(b'\0', T+rva); return raw[T+rva:end]
    def is_code(x): return 0 < x < TEXT_END and not x & 3
    classes = []
    for d in range(DATA_LO, DATA_HI-48, 4):
        name_ptr = w(d+4)
        if not (0x1BF000 < name_ptr < DATA_HI): continue
        name = cstr(name_ptr)
        if not NAME.fullmatch(name): continue
        code = [w(d+8+4*k) for k in range(4)]
        if not (is_code(code[0]) and is_code(code[2])): continue
        definition = w(d+24)
        text = cstr(definition).decode(errors='replace') if 0x1BF000 < definition < DATA_HI else None
        if text is not None and ';' not in text and text: text = None
        classes.append({'descriptor': hex(d), 'class': name.decode(), 'code': [hex(x) if x else None for x in code],
                        'update': hex(code[2]), 'definition': text, 'size1': hex(w(d+28)), 'size2': hex(w(d+32)),
                        'extra': [hex(w(d+36+4*k)) if is_code(w(d+36+4*k)) else None for k in range(3)]})
    out = REPO/'research/v2/class-table'; out.mkdir(parents=True, exist_ok=True)
    rec = {'status': 'STATIC_LAYOUT_OBSERVED_ROLES_INFERRED', 'prxSha256': SHA,
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           'count': len(classes), 'withDefinition': sum(1 for c in classes if c['definition']), 'classes': classes}
    (out/'level01-classes.json').write_text(json.dumps(rec, indent=1), encoding='utf-8')
    print(json.dumps({'count': rec['count'], 'withDefinition': rec['withDefinition']}))

if __name__ == '__main__':
    main()
