"""The rejected Crab batch must never reach an emulator connection."""
import importlib.util
from pathlib import Path
import unittest
from unittest.mock import patch

path = Path(__file__).resolve().parents[1] / 'timer-patches.py'
spec = importlib.util.spec_from_file_location('timer_patch_quarantine', path)
controller = importlib.util.module_from_spec(spec)
spec.loader.exec_module(controller)


class QuarantineTests(unittest.TestCase):
    def test_crab_on_refuses_before_connection(self):
        with patch.object(controller.pg, 'Client') as client, patch('sys.argv', [
            str(path), '--class', 'Crab', '--target', 'on', '--out', 'unused-test-output'
        ]):
            with self.assertRaisesRegex(ValueError, '10 of 29'):
                controller.main()
            client.assert_not_called()

    def test_restoration_and_observation_remain_available(self):
        for target in ('off', 'status'):
            controller.require_activation_review('Crab', target)

    def test_other_classes_are_not_reclassified_by_crab_review(self):
        controller.require_activation_review('Butterfly', 'on')


if __name__ == '__main__':
    unittest.main()
