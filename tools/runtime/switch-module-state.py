#!/usr/bin/env python3
"""Switch the loaded rcp1 module between the A0/B0/B1/C1 experimental arms.

OWNER AUTHORIZATION (2026-09-21, explicit): the three memory writes below are
authorized for the running PPSSPP session, so that the agent can switch arms
without the owner at the keyboard. Nothing else may be written: this tool refuses
any address outside its allowlist, verifies the word it is about to replace, reads
every write back, and can restore A0 (`--arm A0`).

Allowlist (rcp1-relative RVA, runtime address = module base + RVA):

| RVA | arm | vanilla word | patched word | meaning |
| --- | --- | --- | --- | --- |
| 0x96650 | B0 | 0x0E4BE449 | 0x00000000 | second VBlank wait: jal -> NOP |
| 0x151E0 | B1 | 0x3C043D08 | 0x3C043C88 | shared delta: `lui a0,0x3D08` -> `lui a0,0x3C88` (1/30 -> 1/60) |
| 0x2FCFC | C1 | 0x2A240002 | 0x2A240001 | player loop threshold: `slti a0,s1,2` -> `...,1` |

Arms: A0 = vanilla; B0 = NOP wait; B1 = B0 + delta 1/60; C1 = B1 + threshold 1.

Mechanics: the read-only client `ppsspp-ws.py` refuses writes by design, so this
tool subclasses its DebuggerClient and re-implements only the request path it needs,
with the allowlist enforced on the *runtime address* before anything is sent. The
state label printed at the end is the client's own guard decode, so a silent failure
to change the state is visible.

Read-only otherwise: no savestate, no input, no PRX/ISO modification (RAM only).

Usage:
  python tools/runtime/switch-module-state.py --arm C1 [--port 60907]
  python tools/runtime/switch-module-state.py --arm A0 --json-out state-a0.json
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

ALLOWLIST = {
    0x96650: {'vanilla': 0x0E4BE449, 'patched': 0x00000000,
              'note': 'wait stub jal -> NOP (B0)'},
    0x151E0: {'vanilla': 0x3C043D08, 'patched': 0x3C043C88,
              'note': 'shared delta lui 0x3D08 -> 0x3C88 (B1)'},
    0x2FCFC: {'vanilla': 0x2A240002, 'patched': 0x2A240001,
              'note': 'loop threshold slti 2 -> 1 (C1)'},
}
ARMS = {
    'A0': {},
    'B0': {0x96650: 'patched'},
    'B1': {0x96650: 'patched', 0x151E0: 'patched'},
    'C1': {0x96650: 'patched', 0x151E0: 'patched', 0x2FCFC: 'patched'},
}


def load_client():
    spec = importlib.util.spec_from_file_location('ppsspp_ws', CLIENT_PATH)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--arm', required=True, choices=sorted(ARMS))
    ap.add_argument('--port', type=int, default=60907)
    ap.add_argument('--host', default='127.0.0.1')
    ap.add_argument('--module', default='rcp1')
    ap.add_argument('--json-out', default=None)
    ap.add_argument('--expected-base', type=lambda s: int(s, 0), default=None)
    a = ap.parse_args()
    if a.json_out and os.path.exists(a.json_out):
        raise RuntimeError('refusing to overwrite evidence')

    c = load_client()

    class Writer(c.DebuggerClient):
        """DebuggerClient with an explicit, allowlisted write path."""

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
            if rva not in ALLOWLIST:
                raise c.WsError('refused: 0x%08X (rcp1+0x%X) is outside the '
                                'owner-authorized allowlist' % (address, rva))
            return self._transact({'event': 'memory.write_u32', 'address': address,
                                   'value': value})

    client = Writer(a.host, a.port)
    client.connect()
    transcript = {'arm': a.arm, 'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
                  'allowlist': {hex(k): v for k, v in ALLOWLIST.items()}, 'writes': []}
    paused = False
    changed = []
    try:
        identity = c.identity(client)
        transcript['identityBefore'] = identity
        if a.module != 'rcp1' or identity['game'].get('id') != 'UCES00420' or identity['module']['size'] != 0x46B900:
            raise c.WsError('this transaction requires the measured LEVEL_01 module')
        if identity['cpu']['paused'] or identity['cpu']['stepping'] or client.request('cpu.breakpoint.list').get('breakpoints'):
            raise c.WsError('CPU must be running without breakpoints')
        modules = client.request('hle.module.list').get('modules', [])
        active = [m for m in modules if m.get('name') == a.module and m.get('isActive')]
        if len(active) != 1:
            raise c.WsError('active %s count is %d' % (a.module, len(active)))
        base = active[0]['address']
        transcript['base'] = hex(base)
        if a.expected_base is not None and base != a.expected_base:
            raise c.WsError('module differs from expected switch binding; no writes')

        before = c.decode_state(client, base)
        transcript['stateBefore'] = before['state']
        if before['state'] == 'UNKNOWN':
            raise c.WsError('unknown core state')
        resolved = {rva: dict(spec) for rva, spec in ALLOWLIST.items()}
        resolved[0x96650]['vanilla'] = c.jal_word(base + 0x96650, base + c.WAIT_TARGET_RVA)
        transcript['resolvedAllowlist'] = {hex(k): v for k, v in resolved.items()}
        client.request('cpu.stepping')
        paused = True
        stopped = c.identity(client)
        if stopped['module'] != identity['module'] or stopped['state'] != identity['state']:
            raise c.WsError('identity changed before core transaction')

        wanted = ARMS[a.arm]
        for rva, spec in sorted(resolved.items()):
            target_key = wanted.get(rva, 'vanilla')
            target = spec[target_key]
            address = base + rva
            current = c.read_word(client, address)
            entry = {'rva': hex(rva), 'address': hex(address), 'requested': target_key,
                     'wordBefore': hex(current), 'wordWanted': hex(target),
                     'note': spec['note']}
            if current == target:
                entry['action'] = 'already'
            else:
                expected = spec['vanilla'] if current == spec['vanilla'] else None
                if expected is None and current != spec['patched']:
                    raise c.WsError('refused: 0x%08X holds 0x%08X, neither the vanilla '
                                    'nor the patched word - not touching it'
                                    % (address, current))
                changed.append((address, current, target))
                client.write_word(address, target, base)
                after = c.read_word(client, address)
                entry['action'] = 'written'
                entry['wordAfter'] = hex(after)
                if after != target:
                    raise c.WsError('write did not stick at 0x%08X' % address)
            transcript['writes'].append(entry)
            print('%-10s %s %s -> %s' % (entry['note'], entry['address'],
                                         entry['wordBefore'], entry['wordWanted']))
        after_state = c.decode_state(client, base)
        transcript['stateAfter'] = after_state['state']
        transcript['guardsAfter'] = after_state['words']
        print('state: %s -> %s' % (transcript['stateBefore'], transcript['stateAfter']))
        if transcript['stateAfter'] != a.arm:
            raise c.WsError('final core state mismatch')
        transcript['result'] = 'PASS'
    except Exception as error:
        transcript['result'] = 'FAILED'
        transcript['error'] = str(error)
        transcript['rollback'] = []
        for address, original, target in reversed(changed):
            current = c.read_word(client, address)
            if current == target:
                client.write_word(address, original, base)
            restored = c.read_word(client, address) == original
            transcript['rollback'].append({'address': hex(address), 'restored': restored})
            if not restored:
                paused = False  # Preserve the stop for manual conflict resolution.
        raise
    finally:
        if paused:
            client.request('cpu.resume')
        if a.json_out:
            with open(a.json_out, 'w', encoding='utf-8') as fh:
                json.dump(transcript, fh, indent=2, sort_keys=True)
                fh.write('\n')
        client.close()
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
