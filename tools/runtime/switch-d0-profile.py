#!/usr/bin/env python3
"""Compose reviewed controllers for a reversible, core-only A0/D0-help switch."""
import argparse
import base64
import contextlib
import importlib.util
import json
import os
from pathlib import Path
import struct
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[2]
BUILD = ROOT/'patches/experimental/d0-temporal/build/D0-v1-r3'
TESTS = ROOT/'patches/experimental/d0-temporal/tests-output/offline-r3.json'
RECORDER = ROOT/'patches/experimental/family-recorder/build/v1-r7/manifest.json'
OUTPUT = ROOT/'research/live-tests/pokitaru/d0-switch'


@contextlib.contextmanager
def exclusive_switch():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    with (OUTPUT/'controller.lock').open('a+b') as lock:
        if lock.tell() == 0:
            lock.write(b'0'); lock.flush()
        lock.seek(0)
        if os.name == 'nt':
            import msvcrt
            msvcrt.locking(lock.fileno(), msvcrt.LK_NBLCK, 1)
        else:
            import fcntl
            fcntl.flock(lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        try:
            yield
        finally:
            lock.seek(0)
            if os.name == 'nt':
                msvcrt.locking(lock.fileno(), msvcrt.LK_UNLCK, 1)
            else:
                fcntl.flock(lock.fileno(), fcntl.LOCK_UN)


class Controller:
    def __init__(self, directory, port=60907):
        self.directory, self.port, self.sequence = directory, port, 0
        self.expected_base = None

    def run(self, kind, action):
        self.sequence += 1
        output = self.directory/f'{self.sequence:02d}-{kind}-{action}.json'
        if kind == 'd0':
            args = ['control-d0.py', '--build', str(BUILD), '--tests', str(TESTS),
                    '--action', action, '--profile', 'help', '--out', str(output)]
        else:
            args = ['switch-module-state.py', '--arm', action, '--json-out', str(output)]
        if self.expected_base is not None:
            args += ['--expected-base', hex(self.expected_base)]
        completed = subprocess.run([sys.executable, str(ROOT/'tools/runtime'/args[0]),
                                    *args[1:], '--port', str(self.port)],
                                   capture_output=True, text=True, timeout=90)
        if completed.returncode:
            raise RuntimeError(f'{kind}/{action} failed; details: {output.name}')
        return json.loads(output.read_bytes())

    def observe(self):
        record = self.run('d0', 'status')  # Validates loaded ABI/build/guards/rules.
        identity, control = record['identityBefore'], record['controlBefore']
        if identity['cpu']['paused'] or identity['cpu']['stepping']:
            raise RuntimeError('Game is paused; resume it before switching')
        if identity['state'] not in ('A0', 'C1'):
            raise RuntimeError('Unsupported core profile')
        if control['request'] not in (0, 1) or control['installed'] not in (0, 1):
            raise RuntimeError('Unmeasured or transitioning D0 mask')
        spec = importlib.util.spec_from_file_location('d0_switch_ws',
            ROOT/'research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py')
        ws = importlib.util.module_from_spec(spec); spec.loader.exec_module(ws)
        client = ws.DebuggerClient('127.0.0.1', self.port)
        try:
            client.connect()
            if client.request('cpu.breakpoint.list').get('breakpoints'):
                raise RuntimeError('An observation breakpoint is active')
            modules = [m for m in client.request('hle.module.list')['modules'] if m.get('isActive')]
            if any(m['name'] not in ('mcp', 'rcp1', 'D0Temporal', 'FamilyRecorder') for m in modules):
                raise RuntimeError('Unsupported additional plugin/profile')
            manifest = json.loads(RECORDER.read_bytes())
            matches = [m for m in modules if m['name'] == 'FamilyRecorder']
            if len(matches) > 1:
                raise RuntimeError('Ambiguous recorder module')
            def raw(address, size):
                data = base64.b64decode(client.request('memory.read',
                    {'address': address, 'size': size, 'replacements': False})['base64'])
                if len(data) != size:
                    raise RuntimeError('Short read')
                return data
            if matches:
                plugin = matches[0]; base = plugin['address']
                address = base+manifest['symbols']['recorder_control']
                if address+60 > base+plugin['size']:
                    raise RuntimeError('Recorder ABI outside module')
                values = struct.unpack('<15I', raw(address, 60))
                if values[0] != 0x31524652 or values[1] != 2 or values[2] or values[4] or values[7] or values[10]:
                    raise RuntimeError('Recorder is active or unhealthy; finish observation first')
                if raw(base+manifest['symbols']['recorder_build_id'], 32).hex() != manifest['buildId']:
                    raise RuntimeError('Recorder build mismatch')
            # Certify original recorder callsites even if the module is absent.
            base = identity['module']['baseDecimal']
            for site in manifest['sites']:
                actual = struct.unpack('<II', raw(base+site['rva'], 8))
                call = ws.jal_word(base+site['rva'], base+site['direct']) if site['direct'] else site['word']
                delay = 0x3C043C88 if control['installed'] == 1 and site['rva']+4 == 0x150F0C else site['delay']
                if actual != (call, delay):
                    raise RuntimeError(f'Recorder/callsite ownership conflict at {site["rva"]:X}')
            after = ws.identity(client)
            deadline = time.monotonic()+1
            while after['cpu']['paused'] or after['cpu']['stepping']:
                if time.monotonic() >= deadline:
                    raise RuntimeError('Game remains paused after inspection; no switch')
                time.sleep(.05)
                after = ws.identity(client)  # Wait naturally; never resume a foreign stop.
            if after['module'] != identity['module'] or after['state'] != identity['state']:
                raise RuntimeError('Module/core changed during inspection')
            if client.request('cpu.breakpoint.list').get('breakpoints'):
                raise RuntimeError('Breakpoint appeared during inspection')
        finally:
            client.close()
        profile = 'D0' if identity['state'] == 'C1' and control['request'] == control['installed'] == 1 and control['status'] == 2 else 'A0' if identity['state'] == 'A0' and not control['request'] and not control['installed'] else identity['state']+'/pending'
        return {'profile': profile, 'core': identity['state'], 'control': control,
                'module': identity['module'], 'recorderOriginalSites': len(manifest['sites']),
                'scope': 'C1 core + HelpManager timer; no EnemyWave/cascade/wings'}


def transition(controller, target):
    before = controller.observe()
    controller.expected_base = before['module']['baseDecimal']
    result = {'status': 'FAILED', 'target': target, 'before': before, 'writesStarted': False}
    if target == 'status':
        return {**result, 'status': 'OBSERVED', 'after': before}
    if before['profile'] == target:
        return {**result, 'status': 'ALREADY_VERIFIED', 'after': before}
    try:
        result['writesStarted'] = True
        controller.run('d0', 'off')
        middle = controller.observe()
        if middle['module'] != before['module']:
            raise RuntimeError('Module changed; refusing further writes')
        controller.run('core', 'C1' if target == 'D0' else 'A0')
        if target == 'D0':
            controller.run('d0', 'arm')
        result['after'] = controller.observe()
        if result['after']['module'] != before['module'] or result['after']['profile'] != target:
            raise RuntimeError('Final profile/binding mismatch')
        result['status'] = 'PROFILE_VERIFIED_NOT_GAMEPLAY_PARITY'
    except Exception as error:
        result['error'] = str(error)
        try:
            current = controller.observe()
            if current['module'] != before['module']:
                raise RuntimeError('Binding changed; no rollback into a new module')
            controller.run('d0', 'off')
            controller.run('core', 'A0')
            result['recovery'] = controller.observe()
            if result['recovery']['profile'] != 'A0':
                raise RuntimeError('A0 recovery mismatch')
            result['status'] = 'FAILED_RECOVERED_A0'
        except Exception as cleanup:
            result['status'] = 'UNRESOLVED'; result['recoveryError'] = str(cleanup)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--target', choices=('status', 'A0', 'D0'), required=True)
    parser.add_argument('--out-dir', type=Path, required=True)
    parser.add_argument('--port', type=int, default=60907)
    args = parser.parse_args()
    args.out_dir.mkdir(parents=True, exist_ok=False)
    try:
        with exclusive_switch():
            result = transition(Controller(args.out_dir, args.port), args.target)
    except Exception as error:
        result = {'status': 'REFUSED_BEFORE_SWITCH', 'error': str(error), 'writesStarted': False}
    result['utc'] = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())
    (args.out_dir/'result.json').write_bytes((json.dumps(result, indent=2)+'\n').encode())
    print(json.dumps(result))
    return 0 if result['status'] in ('OBSERVED', 'ALREADY_VERIFIED', 'PROFILE_VERIFIED_NOT_GAMEPLAY_PARITY') else 2


if __name__ == '__main__':
    raise SystemExit(main())
