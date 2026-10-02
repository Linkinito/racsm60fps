#!/usr/bin/env python3
"""LEVEL_01 call-context map and frame-delta dataflow (work plan O1+O2, static).

Why: earlier static verdicts were per function ("delta-based, correct under C1")
and missed the caller context. Example: Blaster_Update is delta-based but runs
inside the player substep loop, so C1 halves it (measured A0 4.2 vs C1 2.0
shots/s). The timing domain of a mechanism is function x context.

What it does (read-only over the vanilla PRX and the local Ghidra index):
  1. Functions and direct `jal` edges from the mass corpus index.json; the
     edges are re-derived from the PRX bytes and compared with Ghidra's list.
  2. Regions (roots): per-frame main update, player substep loop body, pump-1
     class updates, other class code slots, particle animators. A function is
     labelled with every region whose root reaches it by direct calls.
  3. Function pointers materialised in code (lui + addiu/ori = entry RVA) and
     found as aligned words in the data range (callback registration).
  4. Frame-delta taint over each function's control-flow graph (basic blocks,
     delay slots, branch-likely, switch jr): FPU registers, GPR copies, stack
     slots and globals; may-taint union at joins. Seeded by the shared delta
     constant in the main update (0x3D088889 = 1/30) and propagated to callees
     that really read f12 (used, stored or forwarded), until a fixpoint.
     Pump-1 indirect calls with f12 = delta feed the class updates (OBSERVED
     from the 0x15230 annotation/telemetry hook). Curated live indirect edges
     come from --observed.

Honesty: VFPU moves are not followed, struct-field reloads of a stored delta
are reported (dtFieldStores) but not chased, switch targets are approximated
and indirect targets are incomplete. Region labels over-approximate through
shared helpers. Results are OBSERVED code facts plus INFERRED dataflow; they
rank candidates for review, they do not prove cadence or parity.

Usage: python research/scripts/call-contexts.py [--observed FILE]
Output: research/v2/decomp-summary/level01-call-contexts.json
"""
import argparse, hashlib, json, struct, sys
from collections import defaultdict, deque
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).resolve().parent))
from mips_subset import decode_word  # noqa: E402

PRX = REPO/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX'
SHA = 'd10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571'
INDEX = REPO/'research/v2/decomp-candidates/_local/20261001-mass/all/index.json'
CLASSES = REPO/'research/v2/class-table/level01-classes.json'
POOLS = REPO/'research/v2/decomp-summary/level01-particle-pools.json'
OBSERVED = REPO/'research/v2/decomp-summary/level01-observed-indirect-edges.json'
OUT = REPO/'research/v2/decomp-summary/level01-call-contexts'
T, TEXT_END, DATA_LO, DATA_HI = 0x74, 0x1BF1AC, 0x2A9E80, 0x2DD080

MAIN = 0x1517C          # P_MainUpdate_SharedDelta
PUMP1 = 0x6B7F4         # P_GroupPump1_EntityUpdates (jalr class update, f12 = delta)
PUMP2 = 0x6E6D4
WALKER = 0x8CC18        # P_Particles_Walker
PLAYER_WRAP = 0x2FFF0
SUBSTEP = 0x2FB8C       # P_Player_SubstepLoop; body runs 2x per A0 frame
SUBSTEP_LOOP = (0x2FCB0, 0x2FD04)  # address range of the do/while body (checked below)
DT_CONSTS = {0x3D088889, 0x3D080000}
K30 = {0x3D088889}
CALLER_SAVED_F = set(range(0, 20))
CALLER_SAVED_G = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 24, 25}
SP = 29
LIKELY = {0x14: 'beql', 0x15: 'bnel', 0x16: 'blezl', 0x17: 'bgtzl'}
BRANCHES = {'beq', 'bne', 'blez', 'bgtz', 'bltz', 'bgez', 'bltzal', 'bgezal', 'bc1f', 'bc1t',
            'beql', 'bnel', 'blezl', 'bgtzl', 'bltzl', 'bgezl'}
GPR_ALU = {'addu', 'subu', 'and', 'or', 'xor', 'nor', 'slt', 'sltu', 'sll', 'srl', 'sra',
           'add', 'sub', 'mfhi', 'mflo', 'sllv', 'srlv', 'rotr', 'ext', 'ins'}


def h(x): return '0x%x' % x


def fix(i):
    # mips_subset labels opcode 0x39 'swc1x' and 0x35 'swc1'; on MIPS/Allegrex
    # SWC1 is 0x39 and 0x35 is not an FPU store. It also leaves branch-likely
    # opcodes undecoded. Normalise locally.
    op = i.word >> 26
    if i.simm is None:
        imm = i.word & 0xFFFF
        i.imm, i.simm = imm, imm - 0x10000 if imm & 0x8000 else imm
        i.rs, i.rt = (i.word >> 21) & 31, (i.word >> 16) & 31
    if op == 0x39: i.mnem = 'swc1'
    elif op == 0x35: i.mnem = 'op35'
    elif op in LIKELY:
        i.mnem = LIKELY[op]; i.target = i.rva + 4 + (i.simm << 2)
    elif op == 1 and ((i.word >> 16) & 31) in (2, 3):
        i.mnem = 'bltzl' if ((i.word >> 16) & 31) == 2 else 'bgezl'
        i.target = i.rva + 4 + (i.simm << 2)
    return i


def merge_taint(a, b):
    out = dict(a)
    for k, v in b.items():
        o = out.get(k)
        out[k] = v if o is None else ('dt' if 'dt' in (o, v) else 'der')
    return out


class State:
    __slots__ = ('ft', 'gt', 'gk', 'stack')

    def __init__(self, ft=None, gt=None, gk=None, stack=None):
        self.ft, self.gt, self.gk, self.stack = ft or {}, gt or {}, gk or {}, stack or {}

    def copy(self):
        return State(dict(self.ft), dict(self.gt), dict(self.gk), dict(self.stack))

    def merge(self, o):
        gk = {k: v for k, v in self.gk.items() if o.gk.get(k) == v}
        return State(merge_taint(self.ft, o.ft), merge_taint(self.gt, o.gt), gk,
                     merge_taint(self.stack, o.stack))

    def key(self):
        return (tuple(sorted(self.ft.items())), tuple(sorted(self.gt.items())),
                tuple(sorted(self.gk.items())), tuple(sorted(self.stack.items())))


class Analyzer:
    def __init__(self, raw, funcs):
        self.funcs = funcs
        self.entries = set(funcs)
        self.code, self.cfg = {}, {}
        for rva, f in funcs.items():
            n = f['size'] // 4
            self.code[rva] = [fix(decode_word(rva + 4*i, struct.unpack_from('<I', raw, T + rva + 4*i)[0]))
                              for i in range(n)]

    def blocks(self, rva):
        """Basic blocks [start, end, successors, switch] over instruction indices.
        Delay slots stay in their branch's block. A jr through a non-ra register
        (switch) gets every otherwise predecessor-less block as successor."""
        if rva in self.cfg: return self.cfg[rva]
        ins = self.code[rva]; n = len(ins)
        idx = lambda a: (a - rva) // 4
        leaders = {0}
        for k, i in enumerate(ins):
            if i.mnem in BRANCHES or i.mnem in ('j', 'jr'):
                leaders.add(min(k + 2, n))
                if i.mnem != 'jr' and i.target is not None and 0 <= idx(i.target) < n:
                    leaders.add(idx(i.target))
        L = sorted(x for x in leaders if x < n)
        out = []
        for bi, st in enumerate(L):
            en = L[bi + 1] if bi + 1 < len(L) else n
            last = None
            for k in range(st, en):
                if ins[k].mnem in BRANCHES or ins[k].mnem in ('j', 'jr'): last = k
            succ, switch = [], False
            if last is None:
                if en < n: succ.append(en)
            else:
                i = ins[last]
                t = idx(i.target) if i.target is not None else -1
                if i.mnem in BRANCHES:
                    if 0 <= t < n: succ.append(t)
                    if en < n: succ.append(en)
                elif i.mnem == 'j':
                    if 0 <= t < n: succ.append(t)
                elif i.mnem == 'jr' and i.rs != 31:
                    switch = True
            out.append([st, en, succ, switch])
        has_pred = {0}
        for b in out: has_pred.update(b[2])
        orphans = [b[0] for b in out if b[0] not in has_pred]
        for b in out:
            if b[3]: b[2] = b[2] + orphans
        self.cfg[rva] = out
        return out

    def scan(self, rva, entry_taint, dt_globals):
        """CFG dataflow (may-taint union at joins). entry_taint: freg -> 'dt'|'der'."""
        ins = self.code[rva]
        blocks = self.blocks(rva)
        bstart = {b[0]: b for b in blocks}
        facts = {'calls': [], 'icalls': [], 'fptr': set(), 'dtUses': [], 'dtStores': [],
                 'dtGlobalStores': set(), 'k30': [], 'globalLoads': set()}
        sink = [None]  # facts are recorded only in the final pass

        def note(key, val):
            if sink[0] is None: return
            if isinstance(facts[key], set): facts[key].add(val)
            else: facts[key].append(val)

        def step(S, i):
            ft, gt, gk, stack = S.ft, S.gt, S.gk, S.stack
            m = i.mnem
            if m == 'lui':
                gk[i.rt] = (i.imm << 16) & 0xFFFFFFFF; gt.pop(i.rt, None); return
            if m in ('addiu', 'ori'):
                if i.rs in gk:
                    v = (gk[i.rs] + i.simm) & 0xFFFFFFFF if m == 'addiu' else gk[i.rs] | i.imm
                    gk[i.rt] = v
                    if v in self.entries and v != rva: note('fptr', v)
                else:
                    gk.pop(i.rt, None)
                gt.pop(i.rt, None); return
            if m == 'mtc1':
                v = gk.get(i.rt)
                if v in K30: note('k30', i.rva)
                if rva == MAIN and v in DT_CONSTS: ft[i.rs] = 'dt'
                elif i.rt in gt: ft[i.rs] = gt[i.rt]
                else: ft.pop(i.rs, None)
                return
            if m == 'mfc1':
                if i.rs in ft: gt[i.rt] = ft[i.rs]; note('dtUses', (i.rva, m))
                else: gt.pop(i.rt, None)
                gk.pop(i.rt, None); return
            if m == 'lwc1':
                if i.rs == SP:
                    t = stack.get(i.simm)
                elif i.rs in gk:
                    a = (gk[i.rs] + i.simm) & 0xFFFFFFFF
                    note('globalLoads', a)
                    t = 'dt' if a in dt_globals else None
                else:
                    t = None
                if t: ft[i.rt] = t
                else: ft.pop(i.rt, None)
                return
            if m == 'swc1':
                t = ft.get(i.rt)
                if i.rs == SP:
                    if t: stack[i.simm] = t
                    else: stack.pop(i.simm, None)
                elif t:
                    if i.rs in gk and t == 'dt':
                        note('dtGlobalStores', (gk[i.rs] + i.simm) & 0xFFFFFFFF)
                    note('dtStores', (i.rva, i.rs, i.simm, t))
                return
            if m == 'sw' and i.rs == SP:
                if i.rt in gt: stack[i.simm] = gt[i.rt]
                else: stack.pop(i.simm, None)
                return
            if m == 'lw' and i.rs == SP:
                t = stack.get(i.simm)
                if t: gt[i.rt] = t
                else: gt.pop(i.rt, None)
                gk.pop(i.rt, None); return
            if i.op == 'COP1':
                fs, ftr, fd = i.rs, i.rt, (i.word >> 6) & 31
                if m.startswith('c.'):
                    if fs in ft or ftr in ft: note('dtUses', (i.rva, m))
                    return
                if m in ('mov.s', 'neg.s', 'abs.s'):
                    t = ft.get(fs)
                    t = t if m == 'mov.s' else ('der' if t else None)
                elif m in ('add.s', 'sub.s', 'mul.s', 'div.s'):
                    t = 'der' if (fs in ft or ftr in ft) else None
                    if t: note('dtUses', (i.rva, m))
                else:  # sqrt, cvt, trunc, round ...
                    t = 'der' if fs in ft else None
                    if t: note('dtUses', (i.rva, m))
                if t: ft[fd] = t
                else: ft.pop(fd, None)
                return
            if m in ('lw', 'lh', 'lhu', 'lb', 'lbu', 'slti', 'sltiu', 'andi', 'xori', 'addi'):
                if m == 'lw' and i.rs in gk: note('globalLoads', (gk[i.rs] + i.simm) & 0xFFFFFFFF)
                gk.pop(i.rt, None); gt.pop(i.rt, None); return
            if m in GPR_ALU:
                mv = m in ('addu', 'or') and (i.rt == 0 or i.rs == 0)
                src = (i.rs if i.rt == 0 else i.rt) if mv else None
                if mv and src in gk: gk[i.rd] = gk[src]
                else: gk.pop(i.rd, None)
                if mv and src in gt: gt[i.rd] = gt[src]
                else: gt.pop(i.rd, None)
                return
            # VFPU and undecoded words: not tracked (documented limit)

        def call_effect(S, i, kind):
            arg = {'site': i.rva, 'f12': S.ft.get(12), 'f14': S.ft.get(14)}
            if kind == 'jal':
                arg['target'] = i.target; note('calls', arg)
            else:
                arg['reg'] = i.rs; note('icalls', arg)
            for r in CALLER_SAVED_F: S.ft.pop(r, None)
            for r in CALLER_SAVED_G: S.gk.pop(r, None); S.gt.pop(r, None)

        def run_block(S, b):
            k, en = b[0], b[1]
            while k < en:
                i = ins[k]
                if (i.mnem in BRANCHES or i.mnem in ('jal', 'jalr', 'j', 'jr')) and k + 1 < len(ins):
                    step(S, ins[k+1])               # delay slot executes first
                    if i.mnem == 'jal': call_effect(S, i, 'jal')
                    elif i.mnem == 'jalr': call_effect(S, i, 'jalr')
                    elif i.mnem == 'j' and not (rva <= (i.target or 0) < rva + 4*len(ins)):
                        call_effect(S, i, 'jal')     # tail call
                    k += 2; continue
                step(S, i); k += 1
            return S

        IN = {0: State(ft=dict(entry_taint))}
        keys = {0: IN[0].key()}
        work = deque([0]); guard = 0
        while work and guard < 50000:
            guard += 1
            st = work.popleft()
            S = run_block(IN[st].copy(), bstart[st])
            for s_ in bstart[st][2]:
                new = S.copy() if s_ not in IN else IN[s_].merge(S)
                kk = new.key()
                if keys.get(s_) != kk:
                    keys[s_] = kk; IN[s_] = new; work.append(s_)
        sink[0] = True
        for st in sorted(IN):
            run_block(IN[st].copy(), bstart[st])
        return facts

    def reads_f12(self, rva, memo, depth=0):
        """f12 is a float argument: its entry value is used, stored, passed to an
        indirect call, or forwarded to a direct callee that reads it."""
        if rva in memo: return memo[rva]
        memo[rva] = False
        fx = self.scan(rva, {12: 'dt'}, set())
        res = bool(fx['dtUses'] or fx['dtStores'] or any(c['f12'] for c in fx['icalls']))
        if not res and depth < 8:
            for c in fx['calls']:
                if c['f12'] and c['target'] in self.code and self.reads_f12(c['target'], memo, depth + 1):
                    res = True; break
        memo[rva] = res
        return res


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--observed', default=str(OBSERVED))
    args = ap.parse_args()
    raw = PRX.read_bytes()
    if hashlib.sha256(raw).hexdigest() != SHA: raise SystemExit('vanilla hash mismatch')
    idx = json.loads(INDEX.read_text(encoding='utf-8'))
    funcs = {int(f['rva'], 16): f for f in idx}
    names = {r: f['name'] for r, f in funcs.items()}
    A = Analyzer(raw, funcs)

    # ---- 1. direct edges re-derived from bytes, compared with Ghidra
    edges = defaultdict(set)
    mismatch = 0
    for r in funcs:
        mine = {i.target for i in A.code[r] if i.mnem == 'jal' and i.target in funcs}
        ghid = {int(c, 16) for c in funcs[r]['callees']}
        if mine != ghid: mismatch += 1
        edges[r] = mine | ghid
    callers = defaultdict(set)
    for a, bs in edges.items():
        for b in bs: callers[b].add(a)

    # ---- 2. regions
    cls = json.loads(CLASSES.read_text(encoding='utf-8'))['classes']
    pools = json.loads(POOLS.read_text(encoding='utf-8'))['pools']
    observed = json.loads(Path(args.observed).read_text(encoding='utf-8')) if Path(args.observed).exists() else {'edges': []}
    update_of = defaultdict(list)
    slot_of = defaultdict(list)
    for c in cls:
        for k, v in enumerate(c['code']):
            if not v: continue
            (update_of if k == 2 else slot_of)[int(v, 16)].append('%s.slot%d' % (c['class'], k))
    loop_body = [i.target for i in A.code[SUBSTEP]
                 if i.mnem == 'jal' and SUBSTEP_LOOP[0] <= i.rva < SUBSTEP_LOOP[1]]
    assert 0x1EBC4 in loop_body, 'substep loop body range check failed: %s' % [h(x) for x in loop_body]
    main_direct = {i.target for i in A.code[MAIN] if i.mnem == 'jal'}
    roots = {
        'substep': set(loop_body),
        'pump1-update': set(update_of),
        'class-slot': set(slot_of),
        'particle-animator': {int(p['animator'], 16) for p in pools if p['animator'].startswith('0x')},
        'frame': main_direct - {PUMP1, PUMP2, WALKER, PLAYER_WRAP},
        'player-frame': {PLAYER_WRAP},
        'pump2': {PUMP2},
    }
    for e in observed.get('edges', []):
        roots.setdefault(e['region'], set()).add(int(e['target'], 16))
    region = defaultdict(set)
    for name, rs in roots.items():
        q = deque(r for r in rs if r in funcs); seen = set(q)
        while q:
            x = q.popleft(); region[x].add(name)
            for y in edges[x]:
                if y in seen: continue
                if name == 'player-frame' and y in roots['substep']: continue
                seen.add(y); q.append(y)

    # ---- 3. data function pointers (aligned words in the data range)
    data_refs = defaultdict(list)
    for a in range(DATA_LO, DATA_HI, 4):
        v = struct.unpack_from('<I', raw, T + a)[0]
        if v in funcs and v > 0x1000: data_refs[v].append(a)

    # ---- 4. delta taint fixpoint (worklist over functions whose entry changed)
    memo = {}
    argf12 = {r: A.reads_f12(r, memo) for r in funcs}
    receivers = {MAIN: {}}
    recv_from = defaultdict(set)
    dt_globals = set()
    for c in update_of:          # pump-1 indirect: f12 = delta (OBSERVED annotation 0x15230)
        if argf12[c]:
            receivers[c] = {12: 'dt'}; recv_from[c].add('pump1-indirect')
    for e in observed.get('edges', []):
        if e.get('f12') in ('dt', 'der'):
            t = int(e['target'], 16); receivers[t] = {12: e['f12']}; recv_from[t].add('observed:' + e['site'])
    facts = {}
    pending = deque(funcs); queued = set(funcs)
    while pending:
        r = pending.popleft(); queued.discard(r)
        fx = A.scan(r, receivers.get(r, {}), dt_globals)
        facts[r] = fx
        new_g = {g for g in fx['dtGlobalStores'] if g not in dt_globals and DATA_LO <= g < DATA_HI + 0x100000}
        if new_g:
            dt_globals |= new_g
            for x in funcs:
                if x not in queued: pending.append(x); queued.add(x)
        for c in fx['calls']:
            t, tt = c['target'], c['f12']
            if tt and t in funcs and argf12[t]:
                recv_from[t].add(h(c['site']))
                old = receivers.get(t, {}).get(12)
                new = 'dt' if 'dt' in (old, tt) else 'der'
                if old != new:
                    receivers.setdefault(t, {})[12] = new
                    if t not in queued: pending.append(t); queued.add(t)

    # ---- 5. assemble
    rows = []
    for r in sorted(funcs):
        fx = facts[r]
        rows.append({
            'rva': h(r), 'name': names[r], 'size': funcs[r]['size'],
            'regions': sorted(region[r]),
            'classUpdateOf': update_of.get(r, []), 'classSlotOf': slot_of.get(r, []),
            'readsF12': argf12[r],
            'dtEntry': receivers.get(r, {}).get(12),
            'dtFrom': sorted(recv_from[r])[:12],
            'dtUses': len(fx['dtUses']),
            'dtUseSites': [h(s) + ':' + m for s, m in fx['dtUses']][:16],
            'dtPassedTo': sorted({h(c['target']) for c in fx['calls'] if c['f12'] and argf12.get(c['target'])}),
            'dtDerivedPassedTo': sorted({h(c['target']) for c in fx['calls']
                                         if c['f12'] == 'der' and argf12.get(c['target'])}),
            'icallsWithDt': sorted({h(c['site']) for c in fx['icalls'] if c['f12']}),
            'icallsNoDt': sorted({h(c['site']) for c in fx['icalls'] if not c['f12']}),
            'dtFieldStores': sorted({(h(s), off) for s, base, off, t in fx['dtStores'] if base != SP})[:12],
            'k30Sites': sorted({h(s) for s in fx['k30']}),
            'fptrRefs': sorted(h(x) for x in fx['fptr']),
            'dataRefs': [h(a) for a in data_refs.get(r, [])][:6],
            'callers': len(callers[r]),
        })
    referenced_by = defaultdict(list)
    for x in rows:
        for t in x['fptrRefs']: referenced_by[t].append(x['rva'])
    for x in rows: x['fptrReferencedBy'] = referenced_by.get(x['rva'], [])[:8]
    cu = [x for x in rows if x['classUpdateOf']]
    summary = {
        'functions': len(rows), 'directEdges': sum(len(v) for v in edges.values()),
        'ghidraEdgeMismatchFunctions': mismatch,
        'substepBody': [h(x) for x in loop_body],
        'regionCounts': {k: sum(1 for x in rows if k in x['regions']) for k in roots},
        'unreached': sum(1 for x in rows if not x['regions']),
        'readsF12': sum(1 for x in rows if x['readsF12']),
        'dtReceivers': sum(1 for x in rows if x['dtEntry']),
        'classUpdates': len(cu), 'classUpdatesReadingDt': sum(1 for x in cu if x['readsF12']),
        'dtGlobals': sorted(h(g) for g in dt_globals),
        'fptrReferenced': len(referenced_by), 'dataReferenced': len(data_refs),
    }
    method = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    rec = {'status': 'STATIC: OBSERVED edges/pointers, INFERRED dataflow (CFG may-taint, no VFPU, '
                     'field reloads not chased, incomplete indirect targets)',
           'prxSha256': SHA, 'methodSha256': method,
           'indexSha256': hashlib.sha256(INDEX.read_bytes()).hexdigest(),
           'observedEdgesSha256': hashlib.sha256(Path(args.observed).read_bytes()).hexdigest()
           if Path(args.observed).exists() else None,
           'summary': summary, 'functions': rows}
    OUT.with_suffix('.json').write_text(json.dumps(rec, indent=1), encoding='utf-8')
    print(json.dumps(summary, indent=1))


if __name__ == '__main__':
    main()
