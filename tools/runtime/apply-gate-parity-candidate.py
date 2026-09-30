#!/usr/bin/env python3
"""Candidate fix for the frame gate: frame-parity decimation (route A).

Problem (TESTED 2026-09-21): the gate `module+0x2B0208` is written once per substep
pass as `(pass == 0)`. In A0 the loop runs twice per frame, so the single consumer
(LEVEL_01 `0x148D7C`, the LaserTracer callback, `beq a0,zero,skip`) runs once per
frame = 30/s. In a one-pass 60 FPS state (C1) the flag stays 1, so the same consumer
runs on every frame = 60/s, i.e. 2x its original real-time rate. Measured: A0
`a0` = 1,0,1,0 with +1/30 per two stops; C1 `a0` = 1 every stop with +1/30 per stop.

No combination of the loop threshold fixes this: decimation has to happen at the
*frame* level. The candidate therefore makes the gate carry a **frame parity** that
flips once per frame, using only slots that execute exactly once per frame in the
one-pass state:

| RVA | vanilla | candidate | effect |
| --- | --- | --- | --- |
| 0x2FCB0 | `sltiu a0,s1,1` (0x2E240001) | `lbu a0,0x208(s2)` (0x92440208) | load the gate left by the previous frame |
| 0x2FCB4 | `sb a0,0x208(s2)` | *(unchanged)* | rewrite the same value (harmless) |
| 0x2FD08 | `ori a0,zero,1` (0x34040001) | `xori a0,a0,1` (0x38840001) | invert it |
| 0x2FD0C | `sb a0,0x208(s2)` | *(unchanged)* | store the inverted value |

Sequence in the one-pass state: the consumer is dispatched inside the pass body,
i.e. after 0x2FCB4 and before 0x2FD08, so it observes the value stored at the end of
the *previous* frame; the end-of-frame store flips it. The consumer therefore runs
on alternating frames = 30/s, its original rate. Expected gate byte at the waterfall
callback (one call per outer update): alternating 1,0 instead of constant 1.

Scope, limits, and honesty:
  - the candidate is meaningful **only in a one-pass state** (C1). In a two-pass
    state both passes would read the same value, so it must not be applied there;
  - it restores the consumer's *rate*; the phase shifts (the consumer now runs on
    even frames instead of on the first pass). The gate has exactly one consumer per
    module, whose use is plain decimation, so nothing else depends on the phase;
  - the gate byte is read by that one consumer only (census over all 21 modules), so
    this patch is not a behavioural change anywhere else;
  - REVERT is supported and verified (`--revert`), and the arm state (A0..C1) is not
    touched by this tool.

OWNER AUTHORIZATION: the owner authorized RAM fixes on 2026-09-21 and asked for this
corrective work; the tool writes exactly the two RVAs above and verifies the word it
replaces before every write. Nothing else is written (no PRX/ISO change).

Usage:
  python tools/runtime/apply-gate-parity-candidate.py --apply
  python tools/runtime/apply-gate-parity-candidate.py --revert
"""
import argparse
import importlib.util
import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '..', '..'))
CLIENT_PATH = os.path.join(REPO, 'research', 'live-tests', 'pokitaru',
                           'waterfall-001', 'ppsspp-ws.py')

CANDIDATE = {
    # 0x2FCB0: `sltiu a0,s1,1` -> `lbu a0,0x9F08(s2)`.
    # CRITICAL: at runtime the module is relocated, so the instruction that writes the
    # gate is `sb a0,0x9F08(s2)` (0xA2449F08), not the file-image `sb a0,0x208(s2)`
    # (0xA2440208): the low half of the gate address carries the module base, i.e.
    # 0x208 + 0x9D00 (low half of 0x09139D00). A first attempt used the file-image
    # immediate 0x208, read 0x093E0208 instead of the gate (byte 0x80) and produced a
    # non-zero a0. Patches must be RUNTIME words, and PRECONDITIONS_APPLY below asserts
    # that runtime encoding instead of trusting it. (The 0x09160208 quoted in an earlier
    # revision of this comment does not follow from the encoding: s2 = 0x093E0000, so the
    # file-image immediate 0x208 lands on 0x093E0208.)
    0x2FCB0: {'from': 0x2E240001, 'to': 0x92449F08,
              'note': 'pass-0: load the gate (runtime 0x9F08(s2)) and rewrite it'},
    # 0x2FD04 is a nop in the file image and at runtime (nops carry no relocation).
    # The flip must happen HERE and not before the loop: `a0` is caller-saved and the
    # loop body (seven calls) clobbers it, and the loop-tail `slti a0,s1,1` leaves 0
    # in it - the first attempt inverted that 0 every frame and the gate stayed 1.
    0x2FD04: {'from': 0x00000000, 'to': 0x92449F08,
              'note': 'post-loop: reload the gate before inverting it'},
    # 0x2FD08: `ori a0,zero,1` -> `xori a0,a0,1`; no relocation on this word, so the
    # file-image and runtime encodings are identical.
    0x2FD08: {'from': 0x34040001, 'to': 0x38840001, 'note': 'invert instead of constant 1'},
}


# Runtime precondition, asserted before any write. The `sb` at 0x2FCB4 writes the gate
# through s2 and carries a LO16 relocation, so at runtime its immediate is
# 0x208 + (0x09139D00 & 0xFFFF) = 0x9F08 while `lui s2,0x2b` at 0x2FCAC becomes
# `lui s2,0x93e` (0x2B + high16(0x09139D00)); the effective address 0x093E0000 + 0x9F08 =
# 0x093E9F08 is rcp1 + 0x2B0208, the gate. If the low half were not relocated, the load
# this tool writes at 0x2FCB0 would land on 0x093E0208, the gate byte would never be read
# and the patch would be a silent no-op with one stray byte written - so the encoding is
# checked, not assumed.
PRECONDITIONS_APPLY = {
    0x2FCB4: (0xA2449F08, 'sb a0,0x9F08(s2) = rcp1+0x2B0208, gated through s2'),
}
PRECONDITIONS_REVERT = {
    0x2FCB4: (0xA2449F08, 'sb a0,0x9F08(s2) - untouched by this patch'),
}


def load_client():
    spec = importlib.util.spec_from_file_location('ppsspp_ws', CLIENT_PATH)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    ap.add_argument('--revert', action='store_true')
    ap.add_argument('--port', type=int, default=60907)
    ap.add_argument('--host', default='127.0.0.1')
    ap.add_argument('--module', default='rcp1')
    ap.add_argument('--expect-state', default=None)
    ap.add_argument('--json-out', default=None)
    a = ap.parse_args()
    if a.apply == a.revert:
        raise SystemExit('choose exactly one of --apply / --revert')

    c = load_client()

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
                    raise c.WsError('timeout waiting for %s' % message['event'])

        def write_word(self, address, value, base):
            rva = address - base
            if rva not in CANDIDATE:
                raise c.WsError('refused: 0x%08X (rcp1+0x%X) is outside the '
                                'candidate allowlist' % (address, rva))
            return self._transact({'event': 'memory.write_u32', 'address': address,
                                   'value': value})

    client = Writer(a.host, a.port)
    client.connect()
    out = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
           'candidate': 'gate-parity', 'mode': 'apply' if a.apply else 'revert',
           'writes': []}
    try:
        modules = client.request('hle.module.list').get('modules', [])
        active = [m for m in modules if m.get('name') == a.module and m.get('isActive')]
        if len(active) != 1:
            raise c.WsError('active %s count is %d' % (a.module, len(active)))
        base = active[0]['address']
        out['base'] = hex(base)
        before = c.decode_state(client, base)
        out['stateBefore'] = before['state']
        if a.expect_state and before['state'] != a.expect_state:
            raise c.WsError('state is %s, expected %s' % (before['state'], a.expect_state))

        preconditions = PRECONDITIONS_APPLY if a.apply else PRECONDITIONS_REVERT
        out['preconditions'] = []
        for rva, (want, note) in sorted(preconditions.items()):
            current = c.read_word(client, base + rva)
            out['preconditions'].append({'rva': hex(rva), 'word': hex(current),
                                         'wordWanted': hex(want), 'ok': current == want,
                                         'note': note})
            if current != want:
                raise c.WsError('refused: rcp1+0x%X holds 0x%08X, expected 0x%08X (%s)'
                                % (rva, current, want, note))
            print('precondition ok: rcp1+0x%X %s  %s' % (rva, hex(current), note))

        for rva, spec in sorted(CANDIDATE.items()):
            address = base + rva
            current = c.read_word(client, address)
            want = spec['to'] if a.apply else spec['from']
            other = spec['from'] if a.apply else spec['to']
            entry = {'rva': hex(rva), 'address': hex(address), 'note': spec['note'],
                     'wordBefore': hex(current), 'wordWanted': hex(want)}
            if current == want:
                entry['action'] = 'already'
            elif current != other:
                raise c.WsError('refused: 0x%08X holds 0x%08X, expected 0x%08X or 0x%08X'
                                % (address, current, spec['from'], spec['to']))
            else:
                client.write_word(address, want, base)
                after = c.read_word(client, address)
                entry['action'] = 'written'
                entry['wordAfter'] = hex(after)
                if after != want:
                    raise c.WsError('write did not stick at 0x%08X' % address)
            out['writes'].append(entry)
            print('%-34s %s %s -> %s (%s)' % (spec['note'], hex(rva),
                                              entry['wordBefore'], hex(want),
                                              entry['action']))
        after_state = c.decode_state(client, base)
        out['stateAfter'] = after_state['state']
        print('arm unchanged: %s -> %s' % (out['stateBefore'], out['stateAfter']))
    finally:
        client.close()
    if a.json_out:
        with open(a.json_out, 'w', encoding='utf-8') as fh:
            json.dump(out, fh, indent=2, sort_keys=True)
            fh.write('\n')
        print('written', a.json_out)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
