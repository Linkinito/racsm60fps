#!/usr/bin/env python3
"""Protocol fixtures for D1 preflight, transitions and lost-ack recovery."""
import argparse
import base64
import hashlib
import importlib.util
import json
from pathlib import Path
import struct

ROOT = Path(__file__).resolve().parents[3]
PATH = ROOT/'tools/runtime/switch-d1-profile.py'
spec = importlib.util.spec_from_file_location('control', PATH)
c = importlib.util.module_from_spec(spec); spec.loader.exec_module(c)


class Fixture:
    def __init__(self, manifest, recipe, mode=0):
        self.m, self.p, self.seq, self.ticks = manifest, recipe, 0, 0
        self.memory = {}; self.writes = []; self.breakpoint = False
        self.lose_ack = False; self.change_module = False
        self.base, self.plugin = 0x0919ad00, 0x08880000
        self.modules = [dict(name='rcp1', address=self.base, size=(recipe['extent']+255)&~255, isActive=True),
                        dict(name='D1Global', address=self.plugin, size=0x30000, isActive=True)]
        self.address = self.plugin+self.m['symbols']['d1_control']
        self.control = [0x44314731, 1, mode, recipe['index'], 0, 0, 0, 0xffffffff, 0, 0, 0, 0]
        self.put(self.plugin+self.m['symbols']['d1_build_id'], bytes.fromhex(manifest['buildId']))
        for name, path, prefix, magic, abi, count, base in (
            ('D0Temporal', 'd0-temporal/build/D0-v1-r3', 'd0', 0x44305430, 1, 10, 0x08900000),
            ('FamilyRecorder', 'family-recorder/build/v1-r7', 'recorder', 0x31524652, 2, 15, 0x08a00000)):
            other = json.loads((ROOT/'patches/experimental'/path/'manifest.json').read_bytes())
            self.modules.append(dict(name=name, address=base, size=0x80000, isActive=True))
            self.put(base+other['symbols'][prefix+'_control'], struct.pack('<%dI'%count, magic, abi, *([0]*(count-2))))
            self.put(base+other['symbols'][prefix+'_build_id'], bytes.fromhex(other['buildId']))
            if prefix == 'recorder' and recipe['index'] == 1:
                for site in other['sites']:
                    call = c.relocated(0x0c000000 | (site['direct'] >> 2), 1, self.base) if site['direct'] else site['word']
                    self.put(self.base+site['rva'], struct.pack('<II', call, site['delay']))
        for g in recipe['guards']:
            self.put(self.base+g['rva'], struct.pack('<I', c.relocated(g['word'], int(g['kind']==1), self.base)))
        self.apply(mode)

    def put(self, address, data):
        self.memory.update({address+i: byte for i, byte in enumerate(data)})

    def apply(self, mode):
        for r in self.p['rules']:
            key = 'after' if mode == 1 or mode == 2 and r['group'] == 0 else 'before'
            self.put(self.base+r['rva'], struct.pack('<I', c.relocated(r[key], r[key+'Kind'], self.base)))
        self.control[2] = self.control[4] = mode; self.control[5] = 2 if mode else 0
        self.control[6] = self.base if mode else 0
        self.control[7] = 123 if mode else 0xffffffff
        self.control[8] += 1
        self.control[10] = self.p['index'] if mode else 0
        self.control[11] = len(self.p['rules']) if mode else 0
        self.put(self.address, struct.pack('<12I', *self.control))

    def request(self, event, args=None):
        if event == 'game.status': return {'game': {'id': 'UCES00420'}}
        if event == 'cpu.status':
            self.ticks += 1
            return dict(paused=False, stepping=False, ticks=self.ticks)
        if event == 'cpu.breakpoint.list': return {'breakpoints': [1] if self.breakpoint else []}
        if event == 'hle.module.list': return {'modules': [dict(m) for m in self.modules]}
        if event == 'memory.read':
            data = bytes(self.memory.get(args['address']+i, 0) for i in range(args['size']))
            return {'base64': base64.b64encode(data).decode()}
        raise AssertionError(event)

    def _send_frame(self, data):
        message = json.loads(data); self.writes.append(message)
        field = (message['address']-self.address)//4
        assert field in (2, 3)
        self.control[field] = message['value']
        if field == 2:
            self.apply(message['value'])
        else:
            self.put(self.address, struct.pack('<12I', *self.control))
        self.reply = json.dumps({'event': 'memory.write_u32', 'ticket': message['ticket']})
        if field == 2 and message['value'] == 1 and self.change_module:
            self.modules[0]['address'] += 0x1000
        if field == 2 and message['value'] == 1 and self.lose_ack:
            self.lose_ack = False
            raise TimeoutError('injected lost acknowledgment after delivery')

    def _recv_message(self): return self.reply


def main():
    parser = argparse.ArgumentParser(description=__doc__); parser.add_argument('--out', type=Path, required=True)
    args = parser.parse_args()
    if args.out.exists(): raise ValueError('Refusing existing result')
    manifest = c.validate(); cases = []
    for recipe in manifest['profiles']:
        for initial in c.MODES:
            for target in ('status', *c.MODES):
                f = Fixture(manifest, recipe, c.MODES[initial])
                result = c.transition(c.Controller(f, manifest), target)
                assert result['after']['profile'] == (initial if target == 'status' else target)
                assert result['status'] in ('OBSERVED', 'ALREADY_VERIFIED', 'PROFILE_VERIFIED_NOT_GAMEPLAY_PARITY')
                cases.append((recipe['module'], initial, target))
        for defect in ('foreign_word', 'breakpoint', 'unknown_plugin', 'wrong_size', 'wrong_build', 'lost_ack', 'changed_module'):
            f = Fixture(manifest, recipe)
            if defect == 'foreign_word': f.put(f.base+recipe['rules'][0]['rva'], b'\xff'*4)
            if defect == 'breakpoint': f.breakpoint = True
            if defect == 'unknown_plugin': f.modules.append(dict(name='Foreign', isActive=True))
            if defect == 'wrong_size': f.modules[0]['size'] += 0x1000
            if defect == 'wrong_build': f.put(f.plugin+manifest['symbols']['d1_build_id'], b'\xff'*32)
            if defect == 'lost_ack': f.lose_ack = True
            if defect == 'changed_module': f.change_module = True
            try:
                result = c.transition(c.Controller(f, manifest), 'D1')
            except RuntimeError:
                assert not f.writes
            else:
                if defect == 'lost_ack':
                    assert result['status'] == 'FAILED_RECOVERED_A0' and result['recovery']['profile'] == 'A0'
                elif defect == 'changed_module':
                    assert result['status'] == 'UNRESOLVED' and len(f.writes) == 2
                else: raise AssertionError('Expected refusal: '+defect)
            cases.append((recipe['module'], defect))
    record = dict(status='CONTROLLER_FIXTURES_PASS_NOT_RUNTIME_ACCEPTED', cases=len(cases),
                  controllerSha256=c.sha(PATH), testSourceSha256=c.sha(Path(__file__)),
                  manifestSha256=c.sha(c.BUILD/'manifest.json'),
                  limits='Mock protocol only; real PSP monitor, JIT, loader and gameplay remain untested')
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_bytes((json.dumps(record, indent=2)+'\n').encode()); print(json.dumps(record))


if __name__ == '__main__': main()
