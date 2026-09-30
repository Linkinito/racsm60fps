#!/usr/bin/env python3
"""Exercise the actual profile composition with injected reviewed-controller results."""
import importlib.util
from pathlib import Path
import unittest

path = Path(__file__).resolve().parents[1]/'switch-d0-profile.py'
spec = importlib.util.spec_from_file_location('d0_profile', path)
module = importlib.util.module_from_spec(spec); spec.loader.exec_module(module)


class Fake:
    def __init__(self, profile='A0', fail_arm=False, fail_off=False, remap=False, refuse=False):
        self.profile, self.calls = profile, []
        self.fail_arm, self.fail_off, self.remap, self.refuse = fail_arm, fail_off, remap, refuse
        self.base = 0x0919AD00

    def observe(self):
        if self.refuse:
            raise RuntimeError('Active recorder/breakpoint')
        return {'profile': self.profile, 'module': {'baseDecimal': self.base}}

    def run(self, kind, action):
        self.calls.append((kind, action))
        if kind == 'core':
            self.profile = action if action == 'A0' else 'C1/idle'
        elif action == 'off':
            if self.fail_off:
                raise RuntimeError('Ownership conflict')
            if self.profile == 'D0':
                self.profile = 'C1/idle'
            if self.remap:
                self.base += 0x10000
        elif action == 'arm':
            if self.fail_arm:
                raise RuntimeError('Arm refused')
            self.profile = 'D0'


class Tests(unittest.TestCase):
    def test_switch_both_directions(self):
        fake = Fake()
        self.assertEqual(module.transition(fake, 'D0')['after']['profile'], 'D0')
        self.assertEqual(fake.calls, [('d0','off'),('core','C1'),('d0','arm')])
        fake.calls.clear()
        self.assertEqual(module.transition(fake, 'A0')['after']['profile'], 'A0')
        self.assertEqual(fake.calls, [('d0','off'),('core','A0')])

    def test_idempotent(self):
        fake = Fake('D0')
        self.assertEqual(module.transition(fake, 'D0')['status'], 'ALREADY_VERIFIED')
        self.assertEqual(fake.calls, [])

    def test_failed_arm_recovers_original(self):
        fake = Fake(fail_arm=True)
        result = module.transition(fake, 'D0')
        self.assertEqual(result['status'], 'FAILED_RECOVERED_A0')
        self.assertEqual(result['recovery']['profile'], 'A0')

    def test_ownership_conflict_preserves_core(self):
        fake = Fake('D0', fail_off=True)
        self.assertEqual(module.transition(fake, 'A0')['status'], 'UNRESOLVED')
        self.assertFalse(any(kind == 'core' for kind, action in fake.calls))

    def test_remap_refuses_new_module(self):
        fake = Fake(remap=True)
        self.assertEqual(module.transition(fake, 'D0')['status'], 'UNRESOLVED')
        self.assertEqual(fake.calls, [('d0','off')])

    def test_observer_conflict_before_writes(self):
        fake = Fake(refuse=True)
        with self.assertRaises(RuntimeError):
            module.transition(fake, 'D0')
        self.assertEqual(fake.calls, [])


if __name__ == '__main__':
    unittest.main()
