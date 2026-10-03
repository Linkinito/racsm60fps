"""Offline tests for the 2026-10-03 live tools (no emulator, synthetic data only).

Run: python -m unittest discover -s tools/runtime/tests -p "test_live_tools_offline.py"
Covers: level-sigmap masking/pair decoding, count-multi site parsing and
delay-slot detection, analyze-samples decoding/cut/analysis, FlamerGate
signature generation (build.py) and state decoding (flamer-gate.py).
All instruction words here are synthetic encodings built in the test.
"""

import importlib.util
import json
import struct
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[3]


def load(name, rel):
    spec = importlib.util.spec_from_file_location(name, REPO / rel)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


sigmap = load("level_sigmap", "tools/runtime/level-sigmap.py")
countm = load("count_multi", "tools/runtime/count-multi.py")
anal = load("analyze_samples", "tools/runtime/analyze-samples.py")
build = load("fg_build", "patches/experimental/flamer-gate/build.py")
fgate = load("flamer_gate", "tools/runtime/flamer-gate.py")


def lui(rt, imm): return 0x3C000000 | rt << 16 | (imm & 0xFFFF)
def lw(rt, off, rs): return 0x8C000000 | rs << 21 | rt << 16 | (off & 0xFFFF)
def addiu(rt, rs, imm): return 0x24000000 | rs << 21 | rt << 16 | (imm & 0xFFFF)
def jal(target): return 0x0C000000 | ((target >> 2) & 0x03FFFFFF)
def beq(rs, rt, off): return 0x10000000 | rs << 21 | rt << 16 | (off & 0xFFFF)
def jr(rs): return rs << 21 | 0x08
def f32(x): return struct.unpack("<I", struct.pack("<f", x))[0]


class LevelSigmapTests(unittest.TestCase):
    def test_masks_and_pairs(self):
        target = 0x093FBF8C  # hi 0x0940 with negative low half
        hi = (target + 0x8000) >> 16
        lo = target - (hi << 16)
        words = [addiu(29, 29, -16), lui(2, hi), jal(0x09200000), lw(4, lo, 2), addiu(4, 4, 1)]
        masks, pairs = sigmap.analyse(words, 0x09000000)
        self.assertEqual(masks[0], 0xFFFFFFFF)
        self.assertEqual(masks[1], 0xFFFF0000)    # lui immediate masked
        self.assertEqual(masks[2], 0xFC000000)    # jal target masked
        self.assertEqual(masks[3], 0xFFFF0000)    # paired low immediate masked
        self.assertEqual(pairs, [(3, target)])

    def test_find_sig_unique_and_shifted(self):
        sig_words = [addiu(29, 29, -32), lui(3, 0x0941), lw(5, 0x10, 3), beq(5, 0, 3), jal(0x09300000)]
        masks, _ = sigmap.analyse(sig_words, 0)
        sig = {"words": sig_words, "masks": masks}
        # Target module: same code relocated (different lui/jal immediates) at index 7.
        moved = [lui(3, 0x0952), lw(5, 0x10, 3), beq(5, 0, 3), jal(0x09411000)]
        allw = [0] * 7 + [sig_words[0]] + moved + [0] * 5
        counts = {}
        for i, w in enumerate(allw):
            counts[w] = counts.get(w, 0) + 1
            counts.setdefault(("pos", w), []).append(i)
        hits = sigmap.find_sig(allw, sig, counts)
        self.assertEqual(hits[0], (7, len(sig_words)))


class CountMultiTests(unittest.TestCase):
    def test_parse_site_literal(self):
        s = countm.parse_site("L=0x13B914:0xA2320015:regs=s1,s2:byte=s1+0x15")
        self.assertEqual((s["label"], s["rva"], s["expect"], s["regs"], s["byte"]),
                         ("L", 0x13B914, 0xA2320015, ["s1", "s2"], ("s1", 0x15)))

    def test_parse_site_from_map(self):
        m = {"sites": {"flamer.query": {"rva": "0x13A8EC"}}, "words": {"flamer.query": "0x27BDFDD0"}}
        s = countm.parse_site("Q=@flamer.query", m)
        self.assertEqual((s["rva"], s["expect"]), (0x13A8EC, 0x27BDFDD0))
        with self.assertRaises(SystemExit):
            countm.parse_site("Q=@flamer.missing", m)

    def test_delay_slot_detection(self):
        self.assertTrue(countm.is_branch_or_jump(beq(1, 2, 4)))
        self.assertTrue(countm.is_branch_or_jump(jal(0x09000000)))
        self.assertTrue(countm.is_branch_or_jump(jr(31)))
        self.assertFalse(countm.is_branch_or_jump(addiu(4, 4, 1)))
        self.assertFalse(countm.is_branch_or_jump(lui(2, 0x0940)))


class AnalyzeSamplesTests(unittest.TestCase):
    def recording(self):
        # state at +0x18, hp float at +0x24, shield float at +0x30; 3 frames per sample at 30 FPS.
        init = ["%08X" % 0] * 16
        init[0x18 // 4] = "%08X" % 2
        init[0x24 // 4] = "%08X" % f32(100.0)
        init[0x30 // 4] = "%08X" % f32(10.0)
        samples, frame, tick = [], 1000, 0
        seq = [(2, 100.0, 10.0), (2, 100.0, 5.0), (9, 100.0, 0.0), (9, 92.0, 0.0), (9, 84.0, 0.0),
               (8, 84.0, 10.0), (2, 84.0, 10.0), (2, 84.0, 10.0)]
        prev = (2, 100.0, 10.0)
        for i, (st, hp, sh) in enumerate(seq):
            chg = {}
            if st != prev[0]: chg["18"] = "%08X" % st
            if hp != prev[1]: chg["24"] = "%08X" % f32(hp)
            if sh != prev[2]: chg["30"] = "%08X" % f32(sh)
            samples.append({"t": i * 0.1, "tick": tick, "frame": frame, "chg": {"pvar": chg} if chg else {}})
            prev = (st, hp, sh)
            frame += 3
            tick += int(3 / 30 * 222_000_000)
        # savestate reload: frame counter jumps back
        samples.append({"t": 0.8, "tick": tick, "frame": 500, "chg": {"pvar": {"24": "%08X" % f32(100.0)}}})
        return {"initial": {"pvar": init}, "samples": samples, "label": "synthetic"}

    def test_decode_cut_and_analyse(self):
        fields = [("st", 0x18, "u32"), ("hp", 0x24, "f32"), ("shield", 0x30, "f32")]
        rows = anal.rows_from(self.recording(), "pvar", fields)
        rows, cut = anal.cut_at_reload(rows)
        self.assertEqual(cut, 8)
        res = anal.analyse(rows, "st", ["hp", "shield"], ["shield"])
        self.assertAlmostEqual(res["framesPerEmuSecond"], 30.0, places=1)
        self.assertEqual(res["fields"]["hp"]["totalDecrease"], 16.0)
        self.assertEqual(res["fields"]["hp"]["decreaseSteps"], [(8.0, 2)])
        self.assertEqual(res["refills"]["shield"], [{"t": 0.5, "frames": 9, "emuS": 0.3, "value": 10.0}])
        self.assertEqual(res["states"]["9"]["frames"], [(9, 1)])   # complete segment 9 lasted 9 frames


class FlamerGateBuildTests(unittest.TestCase):
    def pack(self):
        def window(site_word):
            w = [addiu(29, 29, -48)] + [addiu(4, 4, k) for k in range(1, 11)] + [lui(2, 0x0940)] + [site_word] + \
                [addiu(5, 5, k) for k in range(1, 28)]
            m, pairs = sigmap.analyse(w, 0)
            return w, m, pairs
        sites = {}
        for key in ("flamer.update", "flamer.latchSet", "flamer.callback", "flamer.latchClear", "flamer.query",
                    "guard.sharedDelta"):
            w, m, _ = window(addiu(6, 6, len(sites) + 100))
            sites[key] = {"rva": 0x1000, "words": w, "masks": m, "pairs": []}
        w, m, pairs = window(lw(7, -0x4074, 2))
        return {"before": 12, "after": 28, "source": {"sha256": "x"}, "sites": sites,
                "anchors": {"frameCounter": {"rva": 0x2AF28C, "refs": [{"rva": 0x3188, "words": w, "masks": m,
                                                                        "pairs": pairs}]}}}

    def test_gen_sigs_header(self):
        with tempfile.TemporaryDirectory() as d:
            out = Path(d) / "sigs.h"
            build.gen_sigs(self.pack(), out)
            text = out.read_text(encoding="utf-8")
        self.assertIn("#define FG_SIG_COUNT 6", text)
        self.assertIn("#define FG_SITE_SHAREDDELTA 5", text)
        self.assertIn("#define FG_SITE_QUERY 4", text)
        self.assertIn("#define FG_FC_COUNT 1", text)
        self.assertIn("never commit", text)

    def test_pick_anchor_avoids_trivial_and_stack(self):
        w = [0, addiu(29, 29, -16), 0x03E00008, addiu(4, 4, 1), addiu(5, 5, 2)]
        m = [0xFFFFFFFF] * len(w)
        self.assertEqual(build.pick_anchor(w, m, 2, "t"), 3)
        with self.assertRaises(SystemExit):
            build.pick_anchor([0, 0x03E00008], [0xFFFFFFFF] * 2, 0, "t")


class FlamerGateDecodeTests(unittest.TestCase):
    def test_decode_v1(self):
        man = {"version": "FG-v2", "prxSha256": "x",
               "sites": ["update", "latchSet", "callback", "latchClear", "query", "sharedDelta"]}
        base = 0x0913AD00
        n = 6
        w = [0x30544746, 2, 10, 1, 394, base, 0x1C0000, 2] + [base + r for r in (0x1392C8, 0x1392EC, 0x139DB0,
                                                                                   0x139E0C, 0x13A8EC, 0x14958)]
        w += [1] * n + [base + 0x13A028, 1]
        ctl = [1, 1, 0, 1, 0, 1, base + 0x2B6B0C, 1]
        gate = [1, base + 0x2B6B0C, 1, base + 0x13A8EC, 30, 30, 0, 0, 31, 29]
        res = fgate.decode(man, w, ctl, gate, base, 0x08958000)
        self.assertTrue(res["magicOk"])
        self.assertEqual(res["sites"]["queryCall"]["rva"], "0x13A028")
        self.assertEqual(res["ctl"]["appliedMode"], 1)
        self.assertEqual(res["ctl"]["frameCounterRva"], "0x2B6B0C")
        self.assertEqual((res["gate"]["queryRun"], res["gate"]["querySkip"]), (30, 30))
        self.assertEqual((res["gate"]["latchClear"], res["gate"]["latchRetain"]), (31, 29))
        self.assertEqual(res["ctl"]["error"], "none")

    def test_decode_v3_companion(self):
        man = {"version": "FG-v3", "prxSha256": "x",
               "sites": ["update", "latchSet", "callback", "latchClear", "query", "sharedDelta"]}
        base = 0x0913BD00
        w = [0x30544746, 5, 1, 1, 1, base, 0x1C0000, 2] + [base + 4] * 6 + [1] * 6 + [base + 0x13A028, 1]
        ctl = [1, 1, 0, 1, 0, 0, base + 0x2B6B0C, 1]
        gate = [1, base + 0x2B6B0C, 0, base + 0x13A8EC, 9, 9, 9, 9, 10, 9, base + 0x13A204, 0,
                5, 5, 2, 5, 5, 1, base + 0x647F0, base + 0x648C8, base + 0x64870, base + 0x649A0, 1, 0]
        res = fgate.decode(man, w, ctl, gate, base, 0x08957100)
        self.assertTrue(res["companion"]["installed"])
        self.assertEqual(res["companion"]["damageSiteRva"], "0x647F0")
        self.assertEqual(res["companion"]["ageSkipTargetRva"], "0x649A0")
        self.assertEqual((res["companion"]["damageRun"], res["companion"]["damageSkip"]), (5, 5))


if __name__ == "__main__":
    unittest.main()
