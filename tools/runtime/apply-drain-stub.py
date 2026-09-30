#!/usr/bin/env python3
"""Clip-drain fix v5: hook + cave stub with a private float register.

Design: reports/AGENT-SESSION-2026-09-21/CLIP-DRAIN-STUB-DESIGN.md
Replaces the five drain instructions of the LaserTracer body by a call to a cave stub that
does the same subtraction with its own 0.5 constant, in `f2`, which the body never touches.
`f20` (the value forwarded to callees) is left alone - that was the previous failure.

Precondition enforced before applying: `f2` must appear in no instruction of the body
(LEVEL_01 0x148CEC..0x148FDC) - checked offline from the module image, including swc1.

Usage (always while the CPU is paused):
  python tools/runtime/apply-drain-stub.py --check
  python tools/runtime/apply-drain-stub.py --apply --expect-state C1
  python tools/runtime/apply-drain-stub.py --revert
"""
import argparse
import importlib.util
import json
import os
import struct
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '..', '..'))
CLIENT_PATH = os.path.join(REPO, 'research', 'live-tests', 'pokitaru',
                           'waterfall-001', 'ppsspp-ws.py')
GAME_BIN = r'C:\Users\linki\Downloads\Ratchet & Clank - Size Matters (Europe) (PSN)\Data\BIN'
CAL = 0x74
BASE = 0x09139D00
BODY_START, BODY_END = 0x148CEC, 0x148FDC
F2 = 2

# (rva, expected before, after, note)
HOOK = [
    (0x148DF8, 0xC62C0008, 0x0E4E4599, 'drain -> jal to the cave stub'),
    (0x148DFC, 0x3C043F80, 0x00000000, 'nop (was lui a0,0x3F80)'),
    (0x148E00, 0x4484A000, 0x00000000, 'nop (was mtc1 a0,f20)'),
    (0x148E04, 0x46146301, 0x00000000, 'nop (was sub.s f12,f12,f20)'),
    (0x148E08, 0xE62C0008, 0x00000000, 'nop (was swc1 f12,0x8(s1))'),
]
CAVE_RVA = 0x257964
STUB = [
    # v6 (2026-09-21): reproduce EVERY side effect of the original sequence, then halve
    # the drain. The original `lui a0,0x3F80 / mtc1 a0,f20` establishes f20 = 1.0 for the
    # callees downstream; v5 omitted it and the model broke again
    # (see DRAIN-V6-F20-INVARIANT.md).
    (0x00, 0x3C043F80, 'lui a0,0x3F80      ; 1.0f (as the original)'),
    (0x04, 0x4484A000, 'mtc1 a0,f20       ; f20 = 1.0  <- side effect preserved'),
    (0x08, 0xC62C0008, 'lwc1 f12,0x8(s1)  ; clip counter'),
    (0x0C, 0x3C043F00, 'lui a0,0x3F00      ; 0.5f'),
    (0x10, 0x44841000, 'mtc1 a0,f2         ; private scratch (f2 unused in the body)'),
    (0x14, 0x46026301, 'sub.s f12,f12,f2   ; clip -= 0.5'),
    (0x18, 0xE62C0008, 'swc1 f12,0x8(s1)   ; store back'),
    (0x1C, 0x03E00008, 'jr ra'),
    (0x20, 0x00000000, 'nop'),
]


def f2_used_in_body():
    """Offline precondition: does the body touch f2 anywhere (incl. swc1 opcode 0x39)?"""
    d = open(os.path.join(GAME_BIN, 'LEVEL_01.PRX'), 'rb').read()
    hits = []
    for rva in range(BODY_START, BODY_END, 4):
        x = struct.unpack_from('<I', d, rva + CAL)[0]
        op, rs = x >> 26, (x >> 21) & 31
        regs = set()
        if op == 0x11:
            if rs in (0x10, 0x11, 0x14, 0x15):
                regs = {(x >> 6) & 31, (x >> 11) & 31, (x >> 16) & 31}
            elif rs in (0x00, 0x02, 0x04, 0x06):
                regs = {(x >> 11) & 31}
        elif op in (0x31, 0x39):          # lwc1 / swc1
            regs = {(x >> 16) & 31}
        if F2 in regs:
            hits.append(hex(rva))
    return hits


def load_client():
    spec = importlib.util.spec_from_file_location('ppsspp_ws', CLIENT_PATH)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--check', action='store_true')
    ap.add_argument('--apply', action='store_true')
    ap.add_argument('--revert', action='store_true')
    ap.add_argument('--expect-state', default=None)
    ap.add_argument('--port', type=int, default=60907)
    ap.add_argument('--json-out', default=None)
    a = ap.parse_args()
    if sum([a.check, a.apply, a.revert]) != 1:
        raise SystemExit('choose exactly one of --check / --apply / --revert')

    hits = f2_used_in_body()
    print('precondition: f2 used in the body ->', hits if hits else 'not used (OK)')
    if a.check:
        return 0
    if hits:
        raise SystemExit('refused: f2 is used by the body at %s' % hits)

    c = load_client()
    targets = [(BASE + r, before, after, note) for r, before, after, note in HOOK]
    targets += [(BASE + CAVE_RVA + off, 0x00000000, word, note) for off, word, note in STUB]
    allowed = {addr for addr, _, _, _ in targets}

    class Writer(c.DebuggerClient):
        def _transact(self, message):
            self.seq += 1
            message['ticket'] = 'agent-%d' % self.seq
            self._send_frame(json.dumps(message).encode())
            deadline = time.monotonic() + c.REQUEST_TIMEOUT_S
            while True:
                response = json.loads(self._recv_message())
                if response.get('ticket') == message['ticket']:
                    return response
                if time.monotonic() > deadline:
                    raise c.WsError('timeout on %s' % message['event'])

        def write_word(self, address, value):
            if address not in allowed:
                raise c.WsError('refused: 0x%08X outside the drain-stub allowlist' % address)
            return self._transact({'event': 'memory.write_u32', 'address': address,
                                   'value': value})

    client = Writer('127.0.0.1', a.port)
    client.connect()
    out = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
           'mode': 'apply' if a.apply else 'revert', 'f2_check': hits, 'words': []}
    try:
        status = client.request('cpu.status')
        out['cpuStepping'] = status.get('stepping')
        print('cpu: stepping=%s pc=%s' % (status.get('stepping'), hex(status.get('pc', 0))))
        modules = client.request('hle.module.list').get('modules', [])
        active = [m for m in modules if m.get('name') == 'rcp1' and m.get('isActive')]
        base = active[0]['address']
        if base != BASE:
            raise c.WsError('module base 0x%08X != 0x%08X' % (base, BASE))
        state = c.decode_state(client, base)['state']
        out['state'] = state
        if a.expect_state and state != a.expect_state:
            raise c.WsError('state is %s, expected %s' % (state, a.expect_state))

        # stub first, then the hook: never leave a jump without its target
        ordered = targets[len(HOOK):] + targets[:len(HOOK)]
        for address, before, after, note in ordered:
            current = c.read_word(client, address)
            want = after if a.apply else before
            other = before if a.apply else after
            entry = {'address': hex(address), 'rva': hex(address - base), 'note': note,
                     'wordBefore': hex(current), 'wordWanted': hex(want)}
            if current == want:
                entry['action'] = 'already'
            elif current != other:
                raise c.WsError('refused: 0x%08X holds 0x%08X, expected 0x%08X or 0x%08X'
                                % (address, current, before, after))
            else:
                client.write_word(address, want)
                back = c.read_word(client, address)
                entry['action'] = 'written'
                entry['wordAfter'] = hex(back)
                if back != want:
                    raise c.WsError('write did not stick at 0x%08X' % address)
            out['words'].append(entry)
            print('%-40s %s %s -> %s [%s]' % (note, hex(address - base),
                                              entry['wordBefore'], hex(want),
                                              entry['action']))
    finally:
        client.close()
    if a.json_out:
        json.dump(out, open(a.json_out, 'w', encoding='utf-8'), indent=2, sort_keys=True)
        print('written', a.json_out)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
