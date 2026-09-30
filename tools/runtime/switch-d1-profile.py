#!/usr/bin/env python3
"""Control the passive D1 owner through two allowlisted ABI words only."""
import argparse
import base64
import hashlib
import importlib.util
import json
from pathlib import Path
import struct
import time

ROOT = Path(__file__).resolve().parents[2]
BUILD = ROOT/'patches/experimental/d1-global/build/D1-v1-r2'
TESTS = ROOT/'patches/experimental/d1-global/tests-output/offline-r2.json'
MODES = {'A0': 0, 'D1': 1, 'C1': 2}
FIELDS = ('magic', 'abi', 'request', 'moduleRequest', 'installed', 'status',
          'base', 'moduleId', 'generation', 'error', 'moduleIndex', 'ruleCount')


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec); spec.loader.exec_module(module)
    return module


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def validate(build=BUILD, tests=TESTS):
    m = json.loads((build/'manifest.json').read_bytes())
    t = json.loads(tests.read_bytes())
    if t['status'] != 'OFFLINE_PASS_NOT_RUNTIME_ACCEPTED' or t['manifestSha256'] != sha(build/'manifest.json'):
        raise ValueError('Offline/build mismatch')
    if sha(build/'D1Global/patch.prx') != m['prxSha256']:
        raise ValueError('Package hash mismatch')
    for name, expected in m['inputs'].items():
        if sha(ROOT/name) != expected:
            raise ValueError('Changed build input: '+name)
    if sha(ROOT/'patches/experimental/d1-global/test_offline.py') != t['testSourceSha256']:
        raise ValueError('Changed offline method')
    return m


def relocated(word, kind, base):
    return (word & 0xfc000000) | (((base + ((word & 0x03ffffff) << 2)) >> 2) & 0x03ffffff) if kind else word


class Controller:
    def __init__(self, client, manifest):
        self.client, self.m = client, manifest
        self.plugin = self.game = self.recipe = None
        self.writes = []

    def raw(self, address, size):
        data = base64.b64decode(self.client.request('memory.read',
            {'address': address, 'size': size, 'replacements': False})['base64'])
        if len(data) != size:
            raise RuntimeError('Short read')
        return data

    def modules(self):
        return [m for m in self.client.request('hle.module.list')['modules'] if m.get('isActive')]

    @staticmethod
    def unique(modules, name):
        matches = [m for m in modules if m['name'] == name]
        if len(matches) != 1:
            raise RuntimeError(name+' is not uniquely loaded')
        return matches[0]

    def plugin_control(self, modules=None):
        plugin = self.unique(self.modules() if modules is None else modules, 'D1Global')
        if self.plugin is not None and plugin != self.plugin:
            raise RuntimeError('D1 plugin binding changed')
        base = plugin['address']; address = base+self.m['symbols']['d1_control']
        bid = base+self.m['symbols']['d1_build_id']
        if not base <= address < address+48 <= base+plugin['size'] or not base <= bid < bid+32 <= base+plugin['size']:
            raise RuntimeError('D1 ABI outside module')
        control = dict(zip(FIELDS, struct.unpack('<12I', self.raw(address, 48))))
        if control['magic'] != 0x44314731 or control['abi'] != 1 or self.raw(bid, 32).hex() != self.m['buildId']:
            raise RuntimeError('D1 ABI/build mismatch')
        self.plugin = plugin
        return control

    def running(self):
        deadline = time.monotonic()+1
        while True:
            cpu = self.client.request('cpu.status')
            if not cpu.get('paused', True) and not cpu.get('stepping', True):
                return cpu
            if time.monotonic() >= deadline:
                raise RuntimeError('Resume the game before switching')
            time.sleep(.05)

    def other_owners(self, modules):
        allowed = ('mcp', 'rcp1', 'D0Temporal', 'FamilyRecorder', 'D1Global')
        if any(m['name'] not in allowed for m in modules):
            raise RuntimeError('Unsupported additional plugin')
        for name, path, symbol, magic, abi, count, zeroes in (
            ('D0Temporal', 'd0-temporal/build/D0-v1-r3', 'd0', 0x44305430, 1, 10, (2, 4)),
            ('FamilyRecorder', 'family-recorder/build/v1-r7', 'recorder', 0x31524652, 2, 15, (2, 4, 7, 10))):
            matches = [m for m in modules if m['name'] == name]
            if not matches:
                continue
            plugin = self.unique(modules, name)
            manifest = json.loads((ROOT/'patches/experimental'/path/'manifest.json').read_bytes())
            base = plugin['address']; address = base+manifest['symbols'][symbol+'_control']
            bid = base+manifest['symbols'][symbol+'_build_id']
            if not base <= address < address+4*count <= base+plugin['size'] or not base <= bid < bid+32 <= base+plugin['size']:
                raise RuntimeError(name+' ABI outside module')
            words = struct.unpack('<%dI'%count, self.raw(address, 4*count))
            if words[:2] != (magic, abi) or any(words[i] for i in zeroes) or self.raw(bid, 32).hex() != manifest['buildId']:
                raise RuntimeError(name+' must be passive with a known build')
            if name == 'D0Temporal' and words[5] not in (0, 4):
                raise RuntimeError('D0 is not healthy/passive')
            # Existing recorder only supports LEVEL_01. Certify all its restored sites.
            if name == 'FamilyRecorder' and self.recipe['index'] == 1:
                installed = self.plugin_control(modules)['installed']
                rules = {r['rva']: r for r in self.recipe['rules']}
                for site in manifest['sites']:
                    call = relocated(0x0c000000 | (site['direct'] >> 2), 1, self.game['address']) if site['direct'] else site['word']
                    delay = site['delay']
                    values = [call, delay]
                    for offset in (0, 4):
                        overlap = rules.get(site['rva']+offset)
                        if overlap:
                            key = 'after' if installed == 1 or installed == 2 and overlap['group'] == 0 else 'before'
                            values[offset//4] = relocated(overlap[key], overlap[key+'Kind'], self.game['address'])
                    call, delay = values
                    if struct.unpack('<II', self.raw(self.game['address']+site['rva'], 8)) != (call, delay):
                        raise RuntimeError('Recorder callsite ownership conflict')

    def verify_words(self, installed):
        if installed not in (0, 1, 2):
            raise RuntimeError('D1 has unresolved ownership')
        base = self.game['address']
        expected = {}
        for r in self.recipe['rules']:
            after = installed == 1 or installed == 2 and r['group'] == 0
            key = 'after' if after else 'before'
            expected[r['rva']] = (relocated(r[key], r[key+'Kind'], base), 0xffffffff)
        for g in self.recipe['guards']:
            expected[g['rva']] = (g['word'], 0xffff0000) if g['kind'] == 2 else (relocated(g['word'], g['kind'], base), 0xffffffff)
        # Read nearby words together; never alter JIT replacements or game memory.
        addresses = sorted(expected); groups = []
        for address in addresses:
            if not groups or address-groups[-1][-1] > 32:
                groups.append([])
            groups[-1].append(address)
        for group in groups:
            data = self.raw(base+group[0], group[-1]-group[0]+4)
            for rva in group:
                actual = struct.unpack_from('<I', data, rva-group[0])[0]
                word, mask = expected[rva]
                if actual & mask != word & mask:
                    raise RuntimeError('Game word mismatch at RVA '+hex(rva))

    def observe(self):
        game_status = self.client.request('game.status')
        if game_status.get('game', {}).get('id') != 'UCES00420':
            raise RuntimeError('Requires UCES00420')
        self.running()
        if self.client.request('cpu.breakpoint.list').get('breakpoints'):
            raise RuntimeError('Remove observation breakpoints first')
        modules = self.modules(); game = self.unique(modules, 'rcp1')
        if self.game is not None and game != self.game:
            raise RuntimeError('Game module changed; start a new inspection')
        candidates = [p for p in self.m['profiles'] if 0 <= game['size']-p['extent'] < 256]
        if len(candidates) != 1:
            raise RuntimeError('Only enrolled Pokitaru/Kalidon module sizes are supported')
        self.game, self.recipe = game, candidates[0]
        control = self.plugin_control(modules)
        if control['request'] != control['installed'] or control['status'] != (2 if control['installed'] else 0):
            raise RuntimeError('D1 pending/refused/unresolved: '+str(control))
        if control['installed'] and (control['base'] != game['address'] or control['moduleIndex'] != self.recipe['index'] or control['moduleRequest'] != self.recipe['index'] or control['ruleCount'] != len(self.recipe['rules'])):
            raise RuntimeError('D1 ownership differs from current module')
        if not control['installed'] and (control['base'] or control['moduleIndex'] or control['ruleCount']):
            raise RuntimeError('D1 passive state remains bound')
        self.other_owners(modules); self.verify_words(control['installed'])
        # Close the read interval with identity/owner checks. Generation can advance.
        if self.modules() != modules:
            raise RuntimeError('Module list changed during inspection')
        final = self.plugin_control(modules)
        if any(final[k] != control[k] for k in FIELDS if k != 'generation'):
            raise RuntimeError('D1 state changed during inspection')
        cpu = self.running()
        if self.client.request('cpu.breakpoint.list').get('breakpoints'):
            raise RuntimeError('Breakpoint appeared during inspection')
        return {'profile': next(k for k, v in MODES.items() if v == control['installed']),
                'module': {**game, 'recipe': self.recipe['module']}, 'control': control,
                'cpu': cpu, 'verifiedRules': len(self.recipe['rules']),
                'verifiedGuards': len(self.recipe['guards'])}

    def write(self, field, value):
        if field not in (2, 3) or value not in ((0, 1, 2) if field == 2 else (1, 3)):
            raise RuntimeError('Outside D1 control allowlist')
        self.plugin_control()
        if self.unique(self.modules(), 'rcp1') != self.game:
            raise RuntimeError('Game binding changed before request')
        address = self.plugin['address']+self.m['symbols']['d1_control']+field*4
        # The shared client deliberately disallows arbitrary writes. Use one
        # narrowly checked protocol request, logging intent before acknowledgment.
        record = {'address': address, 'value': value, 'acknowledged': False}
        self.writes.append(record)
        self.client.seq += 1; ticket = 'd1-%d'%self.client.seq
        self.client._send_frame(json.dumps({'event': 'memory.write_u32', 'address': address,
                                            'value': value, 'ticket': ticket}).encode())
        deadline = time.monotonic()+5
        while True:
            reply = json.loads(self.client._recv_message())
            if reply.get('ticket') == ticket:
                if reply.get('event') == 'error' or reply.get('error'):
                    raise RuntimeError('D1 control request refused')
                break
            if time.monotonic() > deadline:
                raise RuntimeError('D1 acknowledgment lost')
        record['acknowledged'] = True
        if struct.unpack('<I', self.raw(address, 4))[0] != value:
            raise RuntimeError('D1 control readback failed')

    def wait(self, mode):
        deadline = time.monotonic()+5
        while time.monotonic() < deadline:
            c = self.plugin_control()
            if c['request'] == c['installed'] == mode and c['status'] == (2 if mode else 0) and (mode or not c['base']):
                return self.observe()
            if c['status'] in (3, 5):
                raise RuntimeError('D1 refused/unresolved: '+str(c))
            time.sleep(.05)
        raise RuntimeError('D1 transition timeout')


def transition(controller, target):
    before = controller.observe()
    result = {'status': 'OBSERVED', 'target': target, 'before': before, 'writesStarted': False}
    if target == 'status' or before['profile'] == target:
        return {**result, 'after': before, 'status': 'OBSERVED' if target == 'status' else 'ALREADY_VERIFIED'}
    try:
        result['writesStarted'] = True
        if target != 'A0':
            controller.write(3, controller.recipe['index'])
        controller.write(2, MODES[target])
        result['after'] = controller.wait(MODES[target])
        if result['after']['cpu']['ticks'] <= before['cpu']['ticks']:
            raise RuntimeError('CPU ticks did not advance')
        result['status'] = 'PROFILE_VERIFIED_NOT_GAMEPLAY_PARITY'
    except Exception as error:
        result['error'] = str(error)
        try:
            controller.write(2, 0)
            result['recovery'] = controller.wait(0)
            result['status'] = 'FAILED_RECOVERED_A0'
        except Exception as cleanup:
            result['status'] = 'UNRESOLVED'; result['recoveryError'] = str(cleanup)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--target', choices=('status', *MODES), required=True)
    parser.add_argument('--out-dir', type=Path, required=True)
    parser.add_argument('--port', type=int, default=60907)
    parser.add_argument('--build', type=Path, default=BUILD)
    parser.add_argument('--tests', type=Path, default=TESTS)
    args = parser.parse_args(); args.out_dir.mkdir(parents=True, exist_ok=False)
    client = controller = None
    try:
        manifest = validate(args.build, args.tests)
        common = load('d1_lock', ROOT/'tools/runtime/switch-d0-profile.py')
        ws = load('d1_ws', ROOT/'research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py')
        with common.exclusive_switch():
            client = ws.DebuggerClient('127.0.0.1', args.port); client.connect()
            controller = Controller(client, manifest)
            result = transition(controller, args.target)
    except Exception as error:
        result = {'status': 'REFUSED_BEFORE_SWITCH', 'error': str(error), 'writesStarted': False}
    finally:
        if client:
            client.close()
    result.update(utc=time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
                  methodSha256=sha(Path(__file__)), writes=controller.writes if controller else [])
    if (args.build/'manifest.json').exists():
        result['manifestSha256'] = sha(args.build/'manifest.json')
    (args.out_dir/'result.json').write_bytes((json.dumps(result, indent=2)+'\n').encode())
    print(json.dumps(result))
    return 0 if result['status'] in ('OBSERVED', 'ALREADY_VERIFIED', 'PROFILE_VERIFIED_NOT_GAMEPLAY_PARITY') else 2


if __name__ == '__main__':
    raise SystemExit(main())
