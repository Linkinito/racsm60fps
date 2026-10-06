#!/usr/bin/env python3
"""Bounded offline plugin-site extraction. Never builds, connects or patches.

Replacement expressions are evaluated from selected existing source statements;
no original/replacement game words are embedded in this generator. Derived
words, guards and recipes are written exclusively below the ignored _local/.
"""
import argparse
import ast
from bisect import bisect_right
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import struct
from types import SimpleNamespace

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'research/v2/plugin-sites-20261005'
BIN = ROOT / '02-Jeu-et-dumps/Data/BACKUP/BIN'
INDEX = 'research/v2/decomp-candidates/_local/20261001-mass/all/index.json'
FIXES = 'tools/runtime/fixes.py'
INVENTORY = 'research/v2/plugin-inventory-20261005/fixes.json'
INPUTS = {}


def read(path):
    p = ROOT / path
    raw = p.read_bytes()
    INPUTS[p.relative_to(ROOT).as_posix()] = hashlib.sha256(raw).hexdigest()
    return raw


def document(path):
    return json.loads(read(path))


def hx(x):
    return None if x is None else '0x%X' % x


def dump(path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


class Elf:
    """PT_LOAD-backed words and PSP relocations only; no matching/indexing."""
    def __init__(self, path):
        self.raw = read(path)
        if self.raw[:6] != b'\x7fELF\x01\x01':
            raise ValueError('Not little-endian ELF32: ' + str(path))
        po, so = struct.unpack_from('<II', self.raw, 28)
        pe, pn, se, sn = struct.unpack_from('<HHHH', self.raw, 42)
        self.segments = [struct.unpack_from('<8I', self.raw, po + i*pe) for i in range(pn)]
        self.sections = [struct.unpack_from('<10I', self.raw, so + i*se) for i in range(sn)]
        self.rel = {}
        for s in self.sections:
            if s[1] == 0x700000A0:
                for p in range(s[4], s[4]+s[5], 8):
                    off, info = struct.unpack_from('<II', self.raw, p)
                    self.rel[off+self.segments[(info >> 8) & 255][2]] = info

    def word(self, at):
        positions = [s[1]+at-s[2] for s in self.segments
                     if s[0] == 1 and s[2] <= at and at+4 <= s[2]+s[4]]
        if len(positions) != 1:
            raise ValueError('Not uniquely file-backed: ' + hx(at))
        return struct.unpack_from('<I', self.raw, positions[0])[0]

    def mask(self, at):
        kind = self.rel.get(at, 0) & 255
        return 0xFC000000 if kind == 4 else 0xFFFF0000 if kind in (5, 6) else 0xFFFFFFFF

    def value(self, at, size):
        positions = [s[1]+at-s[2] for s in self.segments
                     if s[0]==1 and s[2]<=at and at+size<=s[2]+s[4]]
        if len(positions)!=1:
            raise ValueError('Unbacked/BSS scalar at '+hx(at))
        return int.from_bytes(self.raw[positions[0]:positions[0]+size], 'little')


def source_tree(path):
    return ast.parse(read(path).decode('utf-8-sig'), filename=path)


def top_assignments(path, names):
    out = {}
    for n in source_tree(path).body:
        if isinstance(n, ast.Assign) and any(isinstance(t, ast.Name) and t.id in names for t in n.targets):
            value = ast.literal_eval(n.value)
            for t in n.targets:
                if isinstance(t, ast.Name):
                    out[t.id] = (value, '%s:%d' % (path, n.lineno))
    return out


def offline_function(path, name, namespace):
    node = next(n for n in source_tree(path).body if isinstance(n, ast.FunctionDef) and n.name == name)
    exec(compile(ast.Module(body=[node], type_ignores=[]), path, 'exec'), namespace)
    return namespace[name], '%s:%d' % (path, node.lineno)


def tool_data():
    """Evaluate just the required literal/formula blocks, without imports/main."""
    tree = source_tree(FIXES)
    env = {'DATA': {}, 'struct': struct}
    offline_function(FIXES, '_f2w', env)
    chosen = []
    for node in tree.body:
        # Bounded source blocks: input camera, butterfly, weapondt, projectiles.
        if (131 <= node.lineno <= 145 or 227 <= node.lineno <= 233 or
                node.lineno == 254 or 333 <= node.lineno <= 345):
            if isinstance(node, (ast.Assign, ast.For)):
                chosen.append(node)
    exec(compile(ast.Module(body=chosen, type_ignores=[]), FIXES, 'exec'), env)
    initial = next(n for n in tree.body if isinstance(n, ast.Assign) and
                   any(isinstance(t, ast.Name) and t.id == 'DATA' for t in n.targets))
    env['DATA'].update(ast.literal_eval(initial.value))
    lines = {}
    for node in ast.walk(tree):
        if isinstance(node, ast.Assign):
            for t in node.targets:
                if isinstance(t, ast.Subscript) and isinstance(t.value, ast.Name) and t.value.id == 'DATA':
                    if isinstance(t.slice, ast.Constant):
                        lines[t.slice.value] = node.lineno
    for key in env['DATA']:
        if key.startswith('cam0x') and key not in lines:
            lines[key] = 140 if int(key[5:], 16) in (0x3634, 0x37F8) else 135 if int(key[5:], 16) < 0x8000 else 139
        if key.startswith('rr_turn'):
            lines[key] = 344
    return env['DATA'], lines


def branch(word):
    op, rt = word >> 26, (word >> 16) & 31
    return (op in (2, 3, 4, 5, 6, 7, 20, 21, 22, 23) or
            (op == 1 and rt in (0, 1, 2, 3, 16, 17, 18, 19)) or
            (op == 0 and word & 63 in (8, 9)) or
            (op in (16, 17, 18) and (word >> 21) & 31 == 8))


def fg_resolve(elf):
    """Replay FG-v3's six existing signatures and its bounded site patterns."""
    pack_path = 'research/live-tests/_local/sigpack-level01.json'
    pack = document(pack_path)
    saved = 'patches/experimental/flamer-gate/build/FG-v3/'
    gate = read(saved+'gate.c').decode()
    read(saved+'stub.S')
    manifest = document(saved+'manifest.json')
    assert manifest['packSourceSha256'] == pack['source']['sha256']
    assert INPUTS[saved+'gate.c'] == manifest['sourceSha256']
    assert INPUTS[saved+'stub.S'] == manifest['stubSha256']
    defines = {k: int(v, 16) for k, v in re.findall(r'^#define\s+(FG_\w+)\s+(0x[0-9A-Fa-f]+)u', gate, re.M)}
    seg = next(s for s in elf.segments if s[0] == 1 and s[6] & 1)
    text = struct.unpack_from('<%dI' % (seg[4]//4), elf.raw, seg[1])
    bound = {}
    for short, key in [('update','flamer.update'), ('latchSet','flamer.latchSet'),
                       ('callback','flamer.callback'), ('latchClear','flamer.latchClear'),
                       ('query','flamer.query'), ('sharedDelta','guard.sharedDelta')]:
        sig = pack['sites'][key]
        ww, mm, before = sig['words'], sig['masks'], pack['before']
        anchor = next(i for i, m in enumerate(mm) if m == 0xFFFFFFFF)
        hits = [i-anchor for i, w in enumerate(text) if w == ww[anchor] and i >= anchor and
                i-anchor+len(ww) <= len(text) and
                all(text[i-anchor+j] & mask == value & mask for j, (value, mask) in enumerate(zip(ww, mm)))]
        if len(hits) != 1:
            raise ValueError('FG-v3 signature not unique: '+short)
        bound[short] = (hits[0]+before)*4
    cb, query = bound['callback'], bound['query']
    call = next(at for at in range(cb, cb+0x400, 4) if elf.word(at) >> 26 == 3 and
                (elf.word(at) & 0x03FFFFFF)*4 == query)
    reach = [at for at in range(cb+12, cb+0xC00, 4)
             if elf.word(at) == defines['FG_REACH_STORE'] and
             elf.word(at-4) in (defines['FG_REACH_ADD_A'], defines['FG_REACH_ADD_B']) and
             defines['FG_REACH_LOAD'] in (elf.word(at-8), elf.word(at-12))]
    assert len(reach) == 1
    companions = {}
    for key, prefix in [('damage','FG_DMG'), ('age','FG_AGE')]:
        hits = [4*i for i in range(len(text)-3) if text[i] == defines[prefix+'_W0'] and
                text[i+1] == defines[prefix+'_W1'] and text[i+2] >> 16 == 0x1480 and
                text[i+3] == defines[prefix+'_W3']]
        assert len(hits) == 1
        companions[key] = hits[0]
    assert 0 < companions['age']-companions['damage'] < 0x200
    return bound, {'query': call, 'latch-clear': bound['latchClear'], 'reach': reach[0],
                   'secondary-damage': companions['damage'], 'secondary-age': companions['age']}, defines


def task_a():
    inv = document(INVENTORY)
    required = {x['name']: x for x in inv['fixes'] if x['mustApply']}
    elf = Elf('02-Jeu-et-dumps/Data/BACKUP/BIN/LEVEL_01.PRX')
    data, lines = tool_data()
    public, private = [], []

    def add(fix, label, rva, kind, source, replacement=None, expected=None, hook=None, role='write', unknown=()):
        item = required[fix]
        site = fix + '.' + label
        row = {'fix': fix, 'site': site, 'group': item['category'], 'status': item['status'],
               'mustApply': True, 'kind': kind, 'role': role, 'rva01': hx(rva), 'function01': None,
               'offset': None, 'delaySlot': None, 'precedingBranchRva01': None, 'dataRef': None,
               'dependsOn': [] if fix == 'C1-core' else ['C1-core'],
               'conflictsWith': [item['dependenciesConflicts']] if item['dependenciesConflicts'] else [],
               'source': source, 'acceptanceSources': item['sources'],
               'acceptanceScope': item.get('acceptanceScope', item['patchOrHook']),
               'supersededVariants': item['supersededVariants'],
               'evidence': 'OBSERVED' if rva is not None else 'UNKNOWN', 'unknown': list(unknown)}
        words = {'site': site, 'rva01': hx(rva), 'originalWord': None, 'toolExpectedWord': hx(expected),
                 'replacementWord': hx(replacement), 'hook': hook, 'guardWindow': [],
                 'source': source}
        if rva is not None:
            w = elf.word(rva)
            words['originalWord'] = hx(w)
            for at in range(max(0, rva-8), rva+12, 4):
                words['guardWindow'].append({'rva': hx(at), 'word': hx(elf.word(at)), 'mask': hx(elf.mask(at))})
            if expected is not None and expected != w:
                row['unknown'].append('Clean original differs from the tool expected value; refuse automatic install.')
            if role == 'write' and replacement is None and hook is None:
                row['unknown'].append('Replacement or hook entry absent from the existing tool.')
        public.append(row)
        private.append(words)
        return row, words

    wrappers = top_assignments(FIXES, {'WRAPPERS'})['WRAPPERS'][0]
    for fix in ('nav', 'animlat'):
        callee, addresses, symbol, enable, offset = wrappers[fix]
        for i, at in enumerate(addresses):
            row, words = add(fix, str(i), at, 'hook', FIXES+(':%d' % (69 if fix == 'nav' else 85)),
                            hook={'entry': symbol, 'source': 'patches/experimental/interp-gate/' +
                                  ('stub.S' if fix == 'nav' else 'interp.c'),
                                  'toolVersion': 'IG-v16f register-transparent nav / IG-v20 animlat; current tool IG-v24',
                                  'originalCalleeRva01': hx(callee), 'enableSymbol': enable,
                                  'enableWordOffset': offset, 'addressEncoding': 'relocated JAL supplied by loader/plugin build'})
            row['dependsOn'].append('InterpGate state/configuration binding')
    keys = {'crab': ['crab'], 'weapondt': ['weapondt'],
            'camera': ['cam0x308c', 'cam0x361c', 'cam0x37e0', 'cam0x3634', 'cam0x37f8'],
            'blastershot': ['bshot_speed', 'bshot_life'],
            'rynorocket': ['rr_speed', 'rr_life', 'rr_turn0', 'rr_turn1', 'rr_turn2', 'rr_turn3'],
            'butterfly': ['bflap1', 'bflap2', 'bspeed1', 'bspeed2', 'bspringk', 'bspringd']}
    for fix, names in keys.items():
        for key in names:
            at, before, after = data[key]
            add(fix, key, at, 'data' if at >= 0x2AA000 else 'word',
                FIXES+':'+str(lines.get(key, 88)), after, before)
    springs_path = 'research/v2/decomp-summary/level01-spring-params.json'
    for s in document(springs_path)['sites']:
        if int(s['k'], 16) in (0x2CED8C, 0x2CEDBC):
            for field in ('k', 'd'):
                at = int(s[field], 16)
                add('butterfly', 'spring.'+s[field], at, 'data', FIXES+':205; '+springs_path,
                    int(s[field+'After'], 16), int(s[field+'Before'], 16))
    timer_path = 'research/v2/decomp-summary/level01-timer-patch-spec.json'
    timers = {s['site']: s for s in document(timer_path)['classes']['Butterfly']}
    for label, s in sorted(timers.items()):
        add('butterfly', 'timer.'+label, int(label, 16), 'word',
            'tools/runtime/timer-patches.py:40; '+timer_path, int(s['after'], 16), int(s['before'], 16))
    for row in public:
        if row['fix'] == 'butterfly':
            row['conflictsWith'].append('WF.butterfly-flap for bflap1/bflap2: choose one flap owner, never stack')
            row['unknown'].append('Standalone live-instance/init-copy migration is not supplied by fixes.py; owner accepted with a separate instance edit.')
    pg_path = 'tools/runtime/pump-gate.py'
    pg_tree = source_tree(pg_path)
    anchors = next(n for n in pg_tree.body if isinstance(n, ast.Assign) and
                   isinstance(n.targets[0], ast.Tuple) and n.targets[0].elts[0].id == 'VBLANK')
    env = dict(zip([t.id for t in anchors.targets[0].elts], ast.literal_eval(anchors.value)))
    core = next(n for n in pg_tree.body if isinstance(n, ast.Assign) and
                isinstance(n.targets[0], ast.Name) and n.targets[0].id == 'CORE')
    recipe = eval(compile(ast.Expression(core.value), pg_path, 'eval'), {'__builtins__': {}}, env)
    for at, after in sorted(recipe['C1'].items()):
        add('C1-core', hx(at), at, 'word', pg_path+':'+str(core.lineno), after)
    # The existing expected() supplies VBLANK=0 for C1/G1; take that AST constant.
    node = next(n for n in source_tree(pg_path).body if isinstance(n, ast.FunctionDef) and n.name == 'expected')
    upd = next(n for n in ast.walk(node) if isinstance(n, ast.Dict) and any(
        isinstance(k, ast.Name) and k.id == 'VBLANK' and isinstance(v, ast.Constant)
        for k, v in zip(n.keys, n.values)))
    value = next(ast.literal_eval(v) for k, v in zip(upd.keys, upd.values) if isinstance(k, ast.Name) and k.id == 'VBLANK')
    add('C1-core', 'wait', 0x96650, 'word', pg_path+':86', value)
    add('C1-core', 'context', 0x2FBBC, 'word', 'patches/experimental/waterfall-companion/companion.c:129', role='guard-only')
    d0_path = 'patches/experimental/d0-temporal/build.py'
    d0 = top_assignments(d0_path, {'RULES'})['RULES'][0][0]
    add('D0.Help', 'elapsed', d0['rva'], 'word', d0_path+':9', d0['after'], d0['before'])
    # Emitter recipe is identical in the existing source tool and WF-v12.
    node = next(n for n in source_tree(FIXES).body if isinstance(n, ast.Assign) and
                any(isinstance(t, ast.Subscript) and isinstance(t.slice, ast.Constant) and t.slice.value == 'wfparity' for t in n.targets))
    at, before, after = ast.literal_eval(node.value)
    add('WF.emission', 'gate', at, 'word', FIXES+':'+str(node.lineno), after, before)
    flap_path = 'tools/runtime/apply-butterfly-flap.py'
    flap = top_assignments(flap_path, {'SITE', 'ORIGINAL', 'CAVE', 'SPAN', 'CONTEXT'})
    jump, _ = offline_function('tools/runtime/apply-waterfall-mist-motion.py', 'jump', {})
    fn, citation = offline_function(flap_path, 'cave_words',
                                  {'motion': SimpleNamespace(jump=jump), **{k: v[0] for k, v in flap.items()}})
    row, words = add('WF.butterfly-flap', 'hook', flap['SITE'][0], 'hook', flap_path+':14',
                     expected=flap['ORIGINAL'][0], hook={'entry': 'cave_words', 'source': citation,
                       'toolVersion': 'WF-v12 tested recipe (v13 logging-only source)',
                       'caveRva01': hx(flap['CAVE'][0]), 'caveSpan': flap['SPAN'][0],
                       'returnRva01': hx(flap['SITE'][0]+8), 'addressEncoding': 'rebased J; preserve existing delay slot'})
    words['caveRecipeAtBaseZero'] = [hx(w) for w in fn(0)]
    words['exactContextGuards'] = [{'rva': hx(at), 'word': hx(w)} for at, w in sorted(flap['CONTEXT'][0].items())]
    bindings, redirects, defines = fg_resolve(elf)
    fg_path = 'patches/experimental/flamer-gate/build/FG-v3/'
    for suffix, at in redirects.items():
        symbol = {'query':'fg_query_hook', 'latch-clear':'fg_clear_hook', 'reach':'fg_reach_hook',
                  'secondary-damage':'fg_dmg_hook', 'secondary-age':'fg_age_hook'}[suffix]
        row, words = add('FG-v3.'+suffix, 'redirect', at, 'hook', fg_path+'gate.c:334-355',
                        hook={'entry':symbol, 'source':fg_path+'stub.S', 'toolVersion':'FG-v3 immutable snapshot',
                              'addressEncoding':'relocated JAL' if suffix == 'query' else 'rebased J',
                              'returnRva01': None if suffix == 'query' else hx(at+8),
                              'preserveDelaySlotRva01':hx(at+4)})
        row['dependsOn'].append('shared phase and FG state/resolver bindings')
        if suffix.startswith('secondary'):
            imm = elf.word(at+8) & 0xFFFF
            words['hook']['skipRva01'] = hx(at+12+4*(imm if imm < 0x8000 else imm-0x10000))
        words['resolverBindings'] = {k:hx(v) for k,v in bindings.items()}
    add('frames30.hud', 'acceptance-unbound', None, 'word', 'docs/FIX_CATALOGUE_2026-10-01.md:63',
        unknown=['Owner acceptance identifies HUD hide delay (2 seconds), but not which A3xxx/A5xxx conversion; selecting all would broaden acceptance.'])
    add('standalone-coordinator', 'unimplemented', None, 'hook', 'docs/STANDALONE_PLUGIN_DESIGN.md:architecture',
        unknown=['No implemented autonomous coordinator hook: Claude owns new plugin code, binding, phase, rollback and cache handling.'])
    assert set(required) == {s['fix'] for s in public}
    return public, private, elf


def function_index():
    rows = document(INDEX)
    return sorted([(int(r['rva'], 16), r['size']) for r in rows])


def owner(index, at):
    i = bisect_right([r[0] for r in index], at)-1
    return index[i][0] if i >= 0 and at < sum(index[i]) else None


def pair_address(elf, hi, lo):
    a, b = elf.word(hi), elf.word(lo)
    h, l = elf.rel.get(hi, 0), elf.rel.get(lo, 0)
    if a >> 26 != 15 or (a >> 16) & 31 != (b >> 21) & 31 or h & 255 != 5 or l & 255 != 6 or h >> 16 != l >> 16:
        raise ValueError('Not a segment-relative HI16/LO16 pair')
    imm = b & 0xFFFF
    return ((a & 0xFFFF) << 16) + (imm if imm < 0x8000 else imm-0x10000) + elf.segments[(h >> 16) & 255][2]


def gpr_written(word):
    op, rt, rd, fn = word >> 26, (word >> 16) & 31, (word >> 11) & 31, word & 63
    if op == 0:
        return rd if fn not in (8, 12, 13, 17, 19, 24, 25, 26, 27) else None
    if op == 3:
        return 31
    if op in (8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 48, 56):
        return rt
    if op in (16, 17, 18) and (word >> 21) & 31 in (0, 2):
        return rt
    return None


def pairs(elf, index, only_functions=None, targets=None, diagnostics=None):
    """Existing HI/LO method, restricted output and conservative reaching guard.

    No new census: B retains only named required data addresses; E supplies a
    finite containing-function allowlist. Ambiguous/clobbered pairs are omitted.
    """
    highs, out = {}, []
    for at, info in sorted(elf.rel.items()):
        if info & 255 not in (5, 6):
            continue
        fn = owner(index, at)
        if fn is None or (only_functions is not None and fn not in only_functions):
            continue
        w = elf.word(at)
        if info & 255 == 5:
            highs[(fn, info >> 16, (w >> 16) & 31)] = at
            continue
        hi = highs.get((fn, info >> 16, (w >> 21) & 31))
        if hi is None:
            if diagnostics is not None:
                diagnostics.setdefault(fn,[]).append({'loRva01':hx(at), 'reason':'No same-function matching relocated HI16 reaching definition.'})
            continue
        try:
            addr = pair_address(elf, hi, at)
        except ValueError:
            if diagnostics is not None:
                diagnostics.setdefault(fn,[]).append({'loRva01':hx(at), 'reason':'Unsupported PSP relocation pair.'})
            continue
        if targets is not None and addr not in targets:
            continue
        reg = (w >> 21) & 31
        unsafe = any(gpr_written(elf.word(p)) == reg or
                     (p != at-4 and elf.word(p) >> 26 == 3 and reg not in range(16, 24))
                     for p in range(hi+4, at, 4))
        if unsafe:
            if diagnostics is not None:
                diagnostics.setdefault(fn,[]).append({'hiRva01':hx(hi), 'loRva01':hx(at),
                                                      'reason':'Intervening GPR write/call invalidates direct HI16/LO16 resolution.'})
            continue
        out.append({'function':fn, 'hi':hi, 'lo':at, 'data':addr, 'opcode':w >> 26})
    return out


def task_b(sites, words, elf):
    index = function_index()
    lookup = {w['site']:w for w in words}
    # The two spring fields are reached through one struct pointer; Ryno caps
    # through the existing four-entry table pointer, not independent literals.
    objects = {0x2CED90:0x2CED8C, 0x2CEDC0:0x2CEDBC,
               0x2D6B84:0x2D6B80, 0x2D6B88:0x2D6B80, 0x2D6B8C:0x2D6B80}
    data_sites = {int(s['rva01'], 16) for s in sites if s['kind'] == 'data' and s['rva01']}
    refs = pairs(elf, index, targets=data_sites | set(objects.values()))
    for s in sites:
        if s['rva01'] is None:
            s['unknown'].append('No portable binding until the exact site/implementation is identified.')
            continue
        at = int(s['rva01'], 16)
        if s['kind'] == 'data':
            base = objects.get(at, at)
            hits = sorted((r for r in refs if r['data'] == base), key=lambda r:(r['function'], r['lo']))
            choices = []
            for r in hits:
                choices.append({'function01':hx(r['function']), 'hi16Offset':hx(r['hi']-r['function']),
                                'lo16Offset':hx(r['lo']-r['function']), 'hi16Rva01':hx(r['hi']),
                                'lo16Rva01':hx(r['lo']), 'dataRva01':hx(at), 'baseDataRva01':hx(base),
                                'fieldOffset':hx(at-base), 'dataType':'float32',
                                'referenceKind':'direct-load' if r['opcode'] == 49 else 'address/struct-or-table',
                                'source':INDEX+'; original PSP HI16/LO16 relocations'})
            s['dataRef'] = choices[0] if choices else None
            s['alternativeDataRefs'] = choices[1:]
            s['delaySlot'] = False
            if not choices:
                s['unknown'].append('No unclobbered indexed HI16/LO16 reference to this data/known struct base in the bounded search.')
        else:
            fn = owner(index, at)
            s['function01'], s['offset'] = hx(fn), hx(at-fn) if fn is not None else None
            s['delaySlot'] = branch(elf.word(at-4)) if at else False
            s['precedingBranchRva01'] = hx(at-4) if s['delaySlot'] else None
            s['jitCaveat'] = ('Rewrite/invalidate preceding branch as well; original delay slot is a translated unit.'
                              if s['delaySlot'] else 'Invalidate changed instruction and verify active code; preserve following hook delay slot.')
            if fn is None:
                s['unknown'].append('Site falls outside 2026-10-01 indexed function extents.')
        w = lookup[s['site']]
        w['portableBinding'] = s['dataRef'] if s['kind'] == 'data' else {'function01':s['function01'], 'offset':s['offset']}
    return index


def task_c(sites, words, elf):
    data, lines = tool_data()
    for key in ('cam0x79b8', 'cam0x7aa4', 'cam0x7af0', 'cam0x7b38', 'cam0x2aa500'):
        at, _, _ = data[key]
        site = 'camera-follow-assist.'+key
        sites.append({'fix':'camera-follow-assist', 'site':site, 'group':'candidate',
                      'status':'experimental', 'mustApply':False,
                      'kind':'data' if at >= 0x2AA000 else 'word', 'role':'candidate-site-only',
                      'rva01':hx(at), 'function01':None, 'offset':None, 'delaySlot':None,
                      'precedingBranchRva01':None, 'dataRef':None, 'dependsOn':['C1-core'],
                      'conflictsWith':[], 'source':FIXES+':'+str(lines[key]),
                      'acceptanceScope':'Follow assist is separate from accepted manual camera; no promotion.',
                      'evidence':'OBSERVED', 'unknown':[]})
        words.append({'site':site, 'rva01':hx(at), 'originalWord':hx(elf.word(at)),
                      'replacementWord':None, 'hook':None, 'guardWindow':[],
                      'source':FIXES+':'+str(lines[key]), 'wordScope':'Site identification only, as task C requires.'})
    task_b(sites[-5:], words[-5:], elf)
    read('docs/WEAPONS_PARITY_2026-10-02.md')
    read('research/live-tests/pokitaru/session-2026-10-02b/SESSION-LOG.md')
    frames_path = 'research/v2/decomp-summary/level01-frames30-sites.json'
    hud = [s for s in document(frames_path)['sites'] if int(s['site'], 16) in
           (0xA3A80, 0xA3C2C, 0xA5DE8, 0xA5E9C, 0xA5F3C)]
    for s in hud:
        read('research/v2/decomp-candidates/_local/20261001-mass/all/c/'+s['fn']+'.c')
    bindings, redirects, _ = fg_resolve(elf)
    index = function_index()
    return {'rynorocket':{'status':'CLOSED_STATIC', 'sites':[s['site'] for s in sites if s['fix']=='rynorocket'],
                          'testedSource':'research/live-tests/pokitaru/session-2026-10-02b/SESSION-LOG.md:67,73'},
            'blastershot':{'status':'CLOSED_STATIC', 'lifetimeRva01':'0x118178',
                           'testedSource':'research/live-tests/pokitaru/session-2026-10-02b/SESSION-LOG.md:26,54'},
            'hud-hide-delay':{'status':'UNKNOWN', 'candidateRvas01':[hx(int(s['site'],16)) for s in hud],
                              'reason':'A3 functions set message-duration counters; A5 functions set three distinct countdowns. Existing acceptance does not identify which produced the 2-second HUD hide delay.',
                              'source':'docs/FIX_CATALOGUE_2026-10-01.md:63; '+frames_path},
            'FG-v3':{'status':'CLOSED_STATIC', 'redirects':{k:hx(v) for k,v in redirects.items()},
                     'bindings':{k:{'rva01':hx(v), 'function01':hx(owner(index,v)),
                                    'offset':hx(v-owner(index,v)) if owner(index,v) is not None else None,
                                    'role':'guard-only' if k=='sharedDelta' else 'binding-only'} for k,v in bindings.items()},
                     'followingWords':'Preserved; never rewrite as an extra game site.',
                     'source':'patches/experimental/flamer-gate/build/FG-v3/gate.c:180,328'},
            'camera-follow-assist':{'status':'experimental', 'sites':[s['site'] for s in sites if s['fix']=='camera-follow-assist'],
                                   'acceptance':'No owner acceptance; site list only.'}}


def campaign_inputs():
    modules = {}
    provenance = document('research/v2/module-bytematch-20261005/summary.json')
    assert provenance['reference']['sha256'] == INPUTS['02-Jeu-et-dumps/Data/BACKUP/BIN/LEVEL_01.PRX']
    assert provenance['index']['sha256'] == INPUTS[INDEX]
    for n in range(2, 11):
        name = 'LEVEL_%02d' % n
        filename = name+'_clean' if n == 2 else name
        modules[name] = (Elf('02-Jeu-et-dumps/Data/BACKUP/BIN/'+filename+'.PRX'),
                         document('research/v2/module-bytematch-20261005/_local/matches-'+filename+'.json'))
        assert provenance['modules'][filename]['sha256'] == INPUTS['02-Jeu-et-dumps/Data/BACKUP/BIN/'+filename+'.PRX']
    return modules


def task_d(sites, words, ref, extra):
    modules = campaign_inputs()
    local = {w['site']:w for w in words}
    counts = {}
    for name, (target, mapping) in modules.items():
        tally = Counter()
        for site in sites:
            binding = site['dataRef'] if site['kind']=='data' else site
            fn = binding['function01'] if binding is not None else None
            match = mapping.get(hx(int(fn,16)).lower()) if fn is not None else None
            result = {'class':match['class'] if match else 'UNKNOWN', 'function':match.get('at') if match else None,
                      'rva':None, 'originalCheck':'NOT_CHECKED', 'portStatus':'NOT_PORTED'}
            raw = {'module':name, 'site':site['site']}
            if not match:
                result['reason'] = 'No resolved indexed portable binding or existing map entry.'
            elif match['class'] != 'EXACT':
                result['reason'] = 'Only unique EXACT functions may supply a ported coordinate.'
            else:
                target_fn = int(match['at'], 16)
                try:
                    if site['kind']=='data':
                        hi, lo = target_fn+int(binding['hi16Offset'],16), target_fn+int(binding['lo16Offset'],16)
                        at = pair_address(target, hi, lo)+int(binding['fieldOffset'],16)
                        w01, wt = ref.word(int(site['rva01'],16)), target.word(at)
                        equal = w01 == wt
                        result['reference'] = {'hi16Rva':hx(hi), 'lo16Rva':hx(lo), 'fieldOffset':binding['fieldOffset']}
                        raw.update({'original01':hx(w01), 'originalTarget':hx(wt)})
                    else:
                        at = target_fn+int(site['offset'],16)
                        r01 = int(site['rva01'],16)
                        w01, wt = ref.word(r01), target.word(at)
                        m01, mt = ref.mask(r01), target.mask(at)
                        equal = m01 == mt and w01 & m01 == wt & mt
                        raw.update({'original01':hx(w01), 'originalTarget':hx(wt), 'mask01':hx(m01), 'maskTarget':hx(mt)})
                    result['rva'] = hx(at)
                    result['originalCheck'] = 'EQUAL' if equal else 'DIFFER'
                    result['portStatus'] = 'STATIC_COORDINATE_VERIFIED' if equal else 'REFUSED_ORIGINAL_DIFFER'
                    result['calleesDisagree'] = match.get('callees_disagree',0)
                    if match.get('callees_disagree',0):
                        result['portStatus'] = 'REFUSED_CALLEE_DISAGREEMENT'
                        result['reason'] = 'Existing EXACT map records inconsistent mapped callees.'
                    if not equal:
                        result['reason'] = 'EXACT function hides a different relocated data value or original/mask mismatch.'
                    hook = local[site['site']].get('hook')
                    if hook and hook.get('originalCalleeRva01'):
                        cm = mapping.get(hook['originalCalleeRva01'].lower())
                        result['originalCalleeMapping'] = cm
                        if not cm or cm['class'] != 'EXACT':
                            result['portStatus'] = 'REFUSED_CALLEE_NOT_EXACT'
                            result['reason'] = 'Redirecting caller alone does not port the original hook callee.'
                except (ValueError, KeyError) as exc:
                    result['originalCheck'] = 'UNKNOWN'
                    result['reason'] = str(exc)
            tally[result['class']] += 1
            tally['check.'+result['originalCheck']] += 1
            tally['port.'+result['portStatus']] += 1
            site.setdefault('campaign',{})[name] = result
            local[site['site']].setdefault('campaign',{})[name] = raw
        counts[name] = dict(sorted(tally.items()))
    # Six FG bindings are also classified, but never counted as extra writes.
    for binding in extra['missingSets']['FG-v3']['bindings'].values():
        binding['campaign'] = {}
        for name, (target, mapping) in modules.items():
            match = mapping.get(binding['function01'].lower()) if binding['function01'] else None
            row = {'class':match['class'] if match else 'UNKNOWN', 'rva':None}
            if match and match['class']=='EXACT':
                at = int(match['at'],16)+int(binding['offset'],16)
                row['rva'] = hx(at)
                a01 = int(binding['rva01'],16)
                row['originalEqual'] = ref.mask(a01)==target.mask(at) and ref.word(a01)&ref.mask(a01)==target.word(at)&target.mask(at)
            binding['campaign'][name] = row
    extra['campaignCounts'] = counts
    extra['portPolicy'] = 'Coordinates only: an EXACT original-word check does not certify group completeness, hook state/caves/return targets, dynamic guards, copied-instance values or runtime parity.'
    return modules


def task_e(sites, ref, modules, extra, local):
    index = function_index()
    required_fns = set()
    for s in sites:
        if not s['mustApply']:
            continue
        if s['function01']:
            required_fns.add(int(s['function01'],16))
        for r in ([s['dataRef']] if s['dataRef'] else []) + s.get('alternativeDataRefs',[]):
            required_fns.add(int(r['function01'],16))
    diag = {}
    refs = pairs(ref,index,only_functions=required_fns,diagnostics=diag)
    load_types = {32:('int8',1),33:('int16',2),35:('int32-bits',4),
                  36:('uint8',1),37:('uint16',2),49:('float32',4)}
    results, private = [], []
    for fn in sorted(required_fns):
        row = {'function01':hx(fn), 'classification':'UNKNOWN', 'scope':'File-backed direct scalar HI16/LO16 loads in this indexed function only; mutability/semantic role not established.',
               'loads':[], 'unsupportedReferences':list(diag.get(fn,[])), 'campaign':{}}
        raw = {'function01':hx(fn), 'loads':[]}
        for r in [r for r in refs if r['function']==fn]:
            if r['opcode'] not in load_types:
                row['unsupportedReferences'].append({'hiRva01':hx(r['hi']), 'loRva01':hx(r['lo']),
                                                      'dataRva01':hx(r['data']), 'reason':'Address/struct/table/store reference, not a direct supported scalar load.'})
                continue
            typ, width = load_types[r['opcode']]
            load = {'hi16Offset':hx(r['hi']-fn), 'lo16Offset':hx(r['lo']-fn),
                    'dataRva01':hx(r['data']), 'dataType':typ, 'width':width, 'campaign':{}}
            values = {'lo16Rva01':hx(r['lo']), 'original01':None, 'campaign':{}}
            try:
                if ref.rel.get(r['data'],0)&255==2:
                    raise ValueError('Relocated pointer data; not an integer/float constant.')
                original = ref.value(r['data'],width)
                values['original01'] = hx(original)
            except ValueError as exc:
                original = None
                load['unknown'] = str(exc)
            for name,(target,mapping) in modules.items():
                match = mapping.get(hx(fn).lower())
                cell = {'functionClass':match['class'] if match else 'UNKNOWN', 'classification':'UNKNOWN', 'dataRva':None}
                if match and match['class']=='EXACT':
                    try:
                        hi,lo = int(match['at'],16)+r['hi']-fn,int(match['at'],16)+r['lo']-fn
                        at = pair_address(target,hi,lo)
                        cell['dataRva'] = hx(at)
                        if target.rel.get(at,0)&255==2:
                            raise ValueError('Target load points to relocated pointer data.')
                        value = target.value(at,width)
                        values['campaign'][name] = hx(value)
                        cell['classification'] = ('constants equal' if value==original else 'differ') if original is not None else 'UNKNOWN'
                    except ValueError as exc:
                        cell['reason'] = str(exc)
                else:
                    cell['reason'] = 'Containing function is not unique EXACT in this module.'
                load['campaign'][name] = cell
            row['loads'].append(load)
            raw['loads'].append(values)
        exact_modules = []
        for name,(_,mapping) in modules.items():
            match = mapping.get(hx(fn).lower())
            if not match or match['class']!='EXACT':
                row['campaign'][name] = {'classification':'UNKNOWN','reason':'No unique EXACT campaign function.'}
                continue
            exact_modules.append(name)
            classes = [l['campaign'][name]['classification'] for l in row['loads']]
            cls = 'differ' if 'differ' in classes else 'UNKNOWN' if 'UNKNOWN' in classes or row['unsupportedReferences'] else 'constants equal'
            row['campaign'][name] = {'classification':cls, 'directLoads':len(classes),
                                     'differingLoads':classes.count('differ'), 'unknownLoads':classes.count('UNKNOWN'),
                                     'unsupportedReferences':len(row['unsupportedReferences'])}
        classes = [row['campaign'][name]['classification'] for name in exact_modules]
        row['classification'] = 'differ' if 'differ' in classes else 'constants equal' if classes and all(c=='constants equal' for c in classes) else 'UNKNOWN'
        if not exact_modules:
            row['reason'] = 'No unique EXACT target function in campaign02..10; no cross-module constant comparison possible.'
        if not row['loads'] and exact_modules and not row['unsupportedReferences']:
            row['reason'] = 'No supported relocated scalar loads; equality is vacuous for this bounded load class.'
        results.append(row)
        private.append(raw)
    extra['functionConstants'] = results
    extra['constantCounts'] = dict(Counter(r['classification'] for r in results))
    local['functionConstants'] = private


def task_f(ref, extra, local):
    paths = ['research/v2/laser-gate-static-20261003/REPORT.md',
             'research/live-tests/quodrona/laser-001-20261003/REPORT.md',
             'research/v2/decomp-candidates/_local/20261001-mass/all/c/0x13f0c.c',
             'research/v2/decomp-candidates/_local/20261001-mass/all/c/0x159dc.c',
             'research/v2/decomp-candidates/_local/20261001-mass/all/c/0x1517c.c',
             'patches/experimental/flamer-gate/build/FG-v3/gate.c',
             'patches/experimental/flamer-gate/build/FG-v3/stub.S',
             'patches/experimental/flamer-gate/build/FG-v5-1/gate.c',
             'patches/experimental/flamer-gate/build/FG-v5-1/stub.S']
    for p in paths:
        read(p)
    manifest = document('patches/experimental/flamer-gate/build/FG-v5-1/manifest.json')
    assert INPUTS[paths[-2]] == manifest['sourceSha256']
    assert INPUTS[paths[-1]] == manifest['stubSha256']
    counter_refs = pairs(ref, function_index(), only_functions={0x13F0C}, targets={0x2AF28C})
    writer = next(r for r in counter_refs if r['lo']==0x13FB4 and r['opcode']==43)
    extra['phaseRecommendation'] = {
        'status':'INFERRED_CANDIDATE_NOT_LIVE_ACCEPTED',
        'sourceCounterRva01':'0x2AF28C', 'writerRva01':'0x13FB4',
        'writerDataRef':{'function01':'0x13F0C', 'hi16Offset':hx(writer['hi']-0x13F0C),
                         'lo16Offset':hx(writer['lo']-0x13F0C), 'dataRva01':'0x2AF28C', 'dataType':'uint32-counter'},
        'dispatcherRva01':'0x159DC', 'simulationEntryRva01':'0x1517C',
        'sourceEvidence':'OBSERVED: increment before dispatcher, then main/player/pump2 share that counter in ordinary simulation.',
        'advanceA0':'One increment per outer level-loop tick; nominal30/s in active gameplay, two player substeps/tick.',
        'advanceC1':'One increment per outer tick; nominal60/s in active gameplay, one player substep/tick.',
        'counterIsNotSimulationClock':'Dispatcher can omit main update while the outer counter continues; menu state can conditionally run main.',
        'derivedPhase':'Use the bound raw counter as tick/epoch witness; increment one plugin-owned eligible-update ordinal once at main entry, before all consumers. Never increment per hook, hit, target, poll, vblank or wall time.',
        'origin':'Record first eligible main-entry F0 after guarded fresh binding/quiescent profile activation; first eligible ordinal is U1. Origin is a candidate convention until the A0 edge-order test passes.',
        'statePhase':'U1 (even zero-based eligible ordinal); retain original Laser flag AND this phase, preserve ungated preamble.',
        'damagePhase':'U2 (odd zero-based eligible ordinal); FG query/reach/latch/secondary and all Laser receivers share it.',
        'rawParityEquivalence':'With contiguous raw ticks only, Pdamage=(F0+1)&1 and Pstate=Pdamage^1. Do not use this equation across a gap without eligibility normalization.',
        'pauseMenuPolicy':'Freeze eligible ordinal when main is omitted; retain origin within the same module/profile. If menu allows main, advance once. Preserve weapon-switch phase. If eligibility/continuity is unknown, disarm pending controlled rebinding.',
        'resetPolicy':'New confirmed module epoch or quiescent A0/C1 profile transition: reset plugin origin/ordinal before consumers. Pause alone: freeze, not reset. Savestate/counter discontinuity: invalidate origin and disarm; distinguish modulo counter wrap only with continuity evidence.',
        'unknown':['Exact runtime counter initialization/reset writes and pause/menu transition behavior are not proven by these sources.',
                   'Fresh-boot phase origin and combined Flamer/Laser state/damage ordering need live falsification.',
                   'FG-v5.1 opposite Laser state phase is implemented, but extras are not accepted by this mission.'],
        'falsification':['Record coherent raw counter, eligible ordinal, module epoch, state eligibility, player substep, original Laser flag, ammo/state, FG run/skip and all receiver events.',
                        'In A0 establish a semantic U1-only fire/aim change and its U2-only complement; compare C1 both phase assignments, including startup/release and cached geometry.',
                        'Repeat odd/even paused outer ticks, menus that do/do not run main, weapon switches, fresh reload and controlled profile transition. Pause must not shift the next eligible phase.',
                        'Reject if source counter advances between consumers of one eligible update, ordinal double-advances/misses eligible updates, or opposite ordering/rates/HP/ammo/event edges fail.']}
    local['phaseCounter'] = {'rva01':'0x2AF28C', 'originalFileWord':hx(ref.word(0x2AF28C)),
                             'sourceCounterWrite':{'rva01':'0x13FB4','originalWord':hx(ref.word(0x13FB4))}}


def validate(public, local):
    required = {s['fix'] for s in public['sites'] if s['mustApply']}
    expected = {r['name'] for r in document(INVENTORY)['fixes'] if r['mustApply']}
    assert required == expected
    assert len({s['site'] for s in public['sites']}) == len(public['sites'])
    private = {s['site']:s for s in local['sites']}
    for s in public['sites']:
        assert s['site'] in private
        if s['mustApply'] and s['rva01'] and s['role']=='write':
            w = private[s['site']]
            assert w['originalWord'] is not None
            assert w.get('replacementWord') is not None or w.get('hook') is not None or s['unknown']
        if public['throughTask'] >= 'B':
            assert s['function01'] or s['dataRef'] or s['unknown']
        if public['throughTask'] >= 'D':
            assert len(s['campaign']) == 9
    forbidden = {'word','words','originalWord','toolExpectedWord','replacementWord','guardWindow',
                 'original01','originalTarget','originalFileWord','mask01','maskTarget','caveRecipeAtBaseZero'}
    def walk(obj):
        if isinstance(obj,dict):
            assert not forbidden.intersection(obj), 'Game-derived word key in public JSON'
            for value in obj.values():
                walk(value)
        elif isinstance(obj,list):
            for value in obj:
                walk(value)
    walk(public)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--through', choices=list('ABCDEF'), default='A')
    args = ap.parse_args()
    read(Path(__file__).relative_to(ROOT))
    sites, words, elf = task_a()
    extra = {}
    if args.through >= 'B':
        task_b(sites, words, elf)
    if args.through >= 'C':
        extra['missingSets'] = task_c(sites, words, elf)
    if args.through >= 'D':
        modules = task_d(sites, words, elf, extra)
    local_extra = {}
    if args.through >= 'E':
        task_e(sites, elf, modules, extra, local_extra)
    if args.through >= 'F':
        task_f(elf, extra, local_extra)
    public = {'schemaVersion': 1, 'date': '2026-10-05', 'throughTask': args.through,
              'scope': 'OFFLINE_EXISTING_TOOLS_NO_MATCHING_BUILD_EMULATOR_OR_PATCH',
              'wordPolicy': 'No game words in public output; originals/replacements/guards are local only.',
              'inputSha256': INPUTS, 'sites': sites, **extra}
    local = {'schemaVersion': 1, 'throughTask': args.through, 'inputSha256': INPUTS, 'sites': words, **local_extra}
    validate(public, local)
    dump(OUT/'sites.json', public)
    dump(OUT/'_local/words.json', local)
    print(json.dumps({'task': args.through, 'sites': len(sites), 'fixes': len(set(s['fix'] for s in sites)),
                      'unknownSites': sum(bool(s['unknown']) for s in sites)}))


if __name__ == '__main__':
    main()
