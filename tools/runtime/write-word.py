#!/usr/bin/env python3
"""Write ONE word in module RAM, with an expected-value guard and read-back.

Purpose: transitions that the bigger tools refuse by design (2026-09-21: the v3 -> v4
gate-stub word, where the tool's before/after pair no longer covered the value actually
present in RAM). Kept deliberately minimal and explicit: one address, one expected old
value, one new value, both verified. Use only while the CPU is paused (owner
instruction) - the caller is responsible for pausing.

Usage:
  python tools/runtime/write-word.py --address 0x09391670 \
      --expect 0x312A0002 --value 0x312A0003 [--port 60907]
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


def load_client():
    spec = importlib.util.spec_from_file_location('ppsspp_ws', CLIENT_PATH)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--address', required=True, type=lambda x: int(x, 0))
    ap.add_argument('--expect', required=True, type=lambda x: int(x, 0))
    ap.add_argument('--value', required=True, type=lambda x: int(x, 0))
    ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args()

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
            return None

    client = Writer('127.0.0.1', a.port)
    client.connect()
    try:
        status = client.request('cpu.status')
        print('cpu: stepping=%s paused=%s pc=%s' % (status.get('stepping'),
                                                    status.get('paused'),
                                                    hex(status.get('pc', 0))))
        current = c.read_word(client, a.address)
        print('word before: 0x%08X' % current)
        if current == a.value:
            print('already at the requested value - nothing to do')
            return 0
        if current != a.expect:
            raise c.WsError('refused: 0x%08X holds 0x%08X, expected 0x%08X'
                            % (a.address, current, a.expect))
        client._transact({'event': 'memory.write_u32', 'address': a.address,
                          'value': a.value})
        back = c.read_word(client, a.address)
        print('word after : 0x%08X' % back)
        if back != a.value:
            raise c.WsError('write did not stick at 0x%08X' % a.address)
        print('OK')
    finally:
        client.close()
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
