#!/usr/bin/env python3
"""Cave-based gate fix: apply / revert / verify (procedure P4, owner-authorized).

Design (reports/AGENT-SESSION-2026-09-21/CAVE-PATCH-DESIGN.md): the owner allows a
large code cave, so the fix is a routine instead of a hand-fitted in-place sequence.

What this applies (all words are RUNTIME encodings for module base 0x09139D00):

  code site                     before       after        meaning
  0x2FCB0  sltiu a0,s1,1        0x2E240001   0x00000000   disable the in-loop gate write
  0x2FCB4  sb a0,0x9F08(s2)     0xA2449F08   0x00000000   (same)
  0x2FD08  ori a0,zero,1        0x34040001   0x0E569440   jal 0x095A5100 (the cave stub)
  0x2FD0C  sb a0,0x9F08(s2)     0xA2449F08   0x00000000   delay slot of that jal

  cave stub at runtime 0x095A5100 (module .bss tail, RVA 0x46B400; verified-zero
  region, see CAVE-FREE-REGION-PROBE.md):
  0x3C08093F  lui  t0, 0x093F          ; 0x093F0000, the relocated high half
  0x91099F08  lbu  t1, -0x60F8(t0)     ; t1 = gate   (0x093F0000 - 0x60F8 = 0x093E9F08)
  0x39290001  xori t1, t1, 1           ; flip the parity
  0xA1099F08  sb   t1, -0x60F8(t0)     ; gate = parity
  0x03E00008  jr   ra                  ; return
  0x00000000  nop

The consumer (LaserTracer, `0x148D7C`) reads the gate inside the pass body, i.e. the
value stored at the END of the previous frame, so it sees 1,0,1,0 - one work window
per two frames = its original 30 Hz rate. The parity state IS the gate, so the patch
owns no extra byte and cannot collide with game data.

Safety: every write is checked against its expected previous word, read back, and
`--revert` restores the recorded words exactly. No PRX/ISO change; RAM only.

Usage:
  python tools/runtime/apply-gate-cave.py --verify        # read-only check
  python tools/runtime/apply-gate-cave.py --apply --expect-state C1
  python tools/runtime/apply-gate-cave.py --revert
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
BASE = 0x09139D00

# (rva, expected before, after, note)
CODE_WORDS = [
    (0x2FCB0, 0x2E240001, 0x00000000, 'disable in-loop gate write (pass 0)'),
    (0x2FCB4, 0xA2449F08, 0x00000000, 'disable in-loop gate store'),
    (0x2FD08, 0x34040001, 0x0E4E4599, 'hook: jal to the cave stub'),
    (0x2FD0C, 0xA2449F08, 0x00000000, 'delay slot of the hook'),
]
# Cave inside PT_LOAD0 (flags 0x5 = R+X): RVA 0x2C1814..0x2C281C is a 4104-byte
# unreferenced zero run (find-cave-slack.py). The `.bss` tail used before is NOT
# executable - see CAVE-RAM-FINDING.md. Runtime address = base + 0x2C1814 =
# 0x093FB514 for base 0x09139D00, i.e. jal imm26 = (0x093FB514 >> 2) = 0x024FED45.
# Cave inside the READ-ONLY part of PT_LOAD0 (`.rodata`, section flags 0x2): RVA
# 0x257964..0x258080 is an unreferenced 1820-byte zero run. The previous cave sat in
# `.data` (writable) and the GAME OVERWROTE it - see BODY-RATE-AND-CAVE-DURABILITY.md.
# Runtime address = base + 0x257964 = 0x09391664, jal imm26 = 0x024E4599.
CAVE_RVA = 0x257964
CAVE_WORDS = [
    # v4 stub (2026-09-21): v3 used `counter & 2`, which is zero for TWO values out of
    # four (c ≡ 0 or 1 mod 4) - i.e. a 1-frame-in-2 gate, and the measured body rate
    # stayed 1/frame (60/s). With `counter & 3` the gate is open only when
    # c ≡ 0 (mod 4): one frame in four, so 2 calls per open frame -> 2 bodies per 4
    # frames = 0.5 bodies/frame = 30/s = the A0 reference (measured 30/s).
    (0x00, 0x3C08093F, 'lui t0,0x093F      ; gate/data region base'),
    (0x04, 0x91099F09, 'lbu t1,-0x60F7(t0) ; counter = gate+1'),
    (0x08, 0x25290001, 'addiu t1,t1,1'),
    (0x0C, 0x312A0003, 'andi t2,t1,3       ; t2 = counter & 3  (1 frame in 4)'),
    (0x10, 0xA1099F09, 'sb t1,-0x60F7(t0)  ; counter += 1'),
    (0x14, 0x2D4B0001, 'sltiu t3,t2,1      ; 1 when (counter & 2) == 0'),
    (0x18, 0xA10B9F08, 'sb t3,-0x60F8(t0)  ; gate = t3'),
    (0x1C, 0x03E00008, 'jr ra'),
    (0x20, 0x00000000, 'nop'),
]


def load_client():
    spec = importlib.util.spec_from_file_location('ppsspp_ws', CLIENT_PATH)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    ap.add_argument('--revert', action='store_true')
    ap.add_argument('--verify', action='store_true')
    ap.add_argument('--expect-state', default=None)
    ap.add_argument('--port', type=int, default=60907)
    ap.add_argument('--json-out', default=None)
    a = ap.parse_args()
    if sum([a.apply, a.revert, a.verify]) != 1:
        raise SystemExit('choose exactly one of --apply / --revert / --verify')

    c = load_client()
    targets = [(BASE + r, before, after, note) for r, before, after, note in CODE_WORDS]
    targets += [(BASE + CAVE_RVA + off, 0x00000000, word, note)
                for off, word, note in CAVE_WORDS]
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
                    raise c.WsError('timeout waiting for %s' % message['event'])

        def write_word(self, address, value):
            if address not in allowed:
                raise c.WsError('refused: 0x%08X is outside the gate-cave allowlist'
                                % address)
            return self._transact({'event': 'memory.write_u32', 'address': address,
                                   'value': value})

    client = Writer('127.0.0.1', a.port)
    client.connect()
    out = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
           'mode': 'apply' if a.apply else ('revert' if a.revert else 'verify'),
           'words': []}
    try:
        modules = client.request('hle.module.list').get('modules', [])
        active = [m for m in modules if m.get('name') == 'rcp1' and m.get('isActive')]
        base = active[0]['address']
        out['base'] = hex(base)
        if base != BASE:
            raise c.WsError('module base 0x%08X does not match the encoded 0x%08X'
                            % (base, BASE))
        state = c.decode_state(client, base)
        out['state'] = state['state']
        if a.expect_state and state['state'] != a.expect_state:
            raise c.WsError('state is %s, expected %s' % (state['state'], a.expect_state))

        for address, before, after, note in targets:
            current = c.read_word(client, address)
            want = after if a.apply else before
            other = before if a.apply else after
            entry = {'address': hex(address), 'rva': hex(address - base), 'note': note,
                     'wordBefore': hex(current), 'wordWanted': hex(want)}
            if a.verify:
                entry['action'] = 'read'
            elif current == want:
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
            print('%-38s %s %s -> %s [%s]' % (note, hex(address - base),
                                              entry['wordBefore'], hex(want),
                                              entry['action']))
        out['stateAfter'] = c.decode_state(client, base)['state']
        print('state %s -> %s' % (out['state'], out['stateAfter']))
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
