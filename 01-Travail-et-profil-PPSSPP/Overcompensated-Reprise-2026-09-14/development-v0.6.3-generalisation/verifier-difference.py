#!/usr/bin/env python3
"""Compare la table de correctifs de la version de base et celle de la version 0.6.3.

Lit les deux fichiers full_patch.generated.c, puis liste :
  - les entrees ajoutees, retirees ou modifiees, module par module
  - les differences dans les modeles de cave
Ecrit le resultat dans DIFFERENCE_TABLES.json et l'affiche en resume.
"""
import json
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
BASE = HERE.parent / 'development-v0.6.2-menu/sources/profiler/generated/full_patch.generated.c'
NEW = HERE / 'sources/profiler/generated/full_patch.generated.c'

WORD_RE = re.compile(r'0x([0-9A-Fa-f]{8})u')
ROW_RE = re.compile(r'\{\s*0x([0-9A-Fa-f]+)u,\s*0x([0-9A-Fa-f]+)u,\s*0x([0-9A-Fa-f]+)u,\s*(\d+)u,\s*(\d+)u\}')


def load(path):
    lines = path.read_text(encoding='utf-8').splitlines()
    caves = []
    for line in lines:
        if line.strip().startswith('{0x') and '0x' in line and len(WORD_RE.findall(line)) == 64:
            caves.append([int(w, 16) for w in WORD_RE.findall(line)])
    modules = {}
    current = None
    for line in lines:
        m = re.match(r'static const RcsmFullWord kFull(\d+)\[\]', line.strip())
        if m:
            current = int(m.group(1))
            modules[current] = []
            continue
        if current is not None:
            r = ROW_RE.search(line)
            if r:
                modules[current].append((int(r.group(1), 16), int(r.group(2), 16),
                                         int(r.group(3), 16), int(r.group(4)), int(r.group(5))))
            elif line.strip() == '};':
                current = None
    return caves, modules


def entry_key(entry):
    return entry[0]


def main():
    base_caves, base_modules = load(BASE)
    new_caves, new_modules = load(NEW)
    report = {'base': str(BASE), 'new': str(NEW), 'modules': {}, 'cave_differences': []}
    for cave_index, (b, n) in enumerate(zip(base_caves, new_caves)):
        for word_index, (bw, nw) in enumerate(zip(b, n)):
            if bw != nw:
                report['cave_differences'].append({
                    'cave_index': cave_index, 'word_index': word_index,
                    'base': f'0x{bw:08X}', 'new': f'0x{nw:08X}'})
    for index in sorted(set(base_modules) | set(new_modules)):
        b = {entry_key(e): e for e in base_modules.get(index, [])}
        n = {entry_key(e): e for e in new_modules.get(index, [])}
        added = [n[k] for k in n if k not in b]
        removed = [b[k] for k in b if k not in n]
        changed = [(b[k], n[k]) for k in n if k in b and b[k] != n[k]]
        if added or removed or changed:
            report['modules'][index] = {
                'base_count': len(b), 'new_count': len(n),
                'added': [{'offset': f'0x{o:08X}', 'original': f'0x{old:08X}', 'patched': f'0x{new:08X}'}
                          for o, old, new, _f, _l in added],
                'removed': [f'0x{o:08X}' for o, *_ in removed],
                'changed': [{'offset': f'0x{b0[0]:08X}', 'base': f'0x{b0[2]:08X}', 'new': f'0x{n0[2]:08X}'}
                            for b0, n0 in changed],
            }
    (HERE / 'DIFFERENCE_TABLES.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print('cave :', len(report['cave_differences']), 'mot(s) modifie(s)')
    for d in report['cave_differences']:
        print(f"  cave {d['cave_index']} mot {d['word_index']} : {d['base']} -> {d['new']}")
    print('modules modifies :', ', '.join(str(k) for k in report['modules']) or 'aucun')
    for index, m in report['modules'].items():
        print(f"  L{index:02d} : {m['base_count']} -> {m['new_count']} "
              f"(+{len(m['added'])} / -{len(m['removed'])} / ~{len(m['changed'])})")


if __name__ == '__main__':
    main()
