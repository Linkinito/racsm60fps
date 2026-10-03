"""Tests for tools/research/report_catalog.py (run: python -m unittest discover -s tools/research/tests)."""

import contextlib
import importlib.util
import io
import json
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("report_catalog", HERE.parent / "report_catalog.py")
rc = importlib.util.module_from_spec(spec)
spec.loader.exec_module(rc)

GOOD = """---
kind: live
title: "Flamethrower counts: A0 vs C1"
date: 2026-10-04
authors: ["Claude (Opus 5.5)"]
status: active
evidence: [OBSERVED, UNKNOWN]
summary: "Counts matched; DPS UNKNOWN."   # trailing comments are ignored
systems: [Flamethrower, damage]
levels: [Pokitaru]
related: [research/other.md]
---

# Body
"""


class ReportCatalogTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        (self.root / "research").mkdir()
        (self.root / "research/other.md").write_text("no front matter\n", encoding="utf-8")

    def tearDown(self):
        self.tmp.cleanup()

    def write(self, rel, text):
        p = self.root / rel
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(text, encoding="utf-8")
        return p

    def run_cmd(self, argv):
        buf = io.StringIO()
        orig = rc.repo_root
        rc.repo_root = lambda: self.root
        try:
            with contextlib.redirect_stdout(buf):
                code = rc.main(argv)
        finally:
            rc.repo_root = orig
        return code, buf.getvalue()

    def test_parse_good(self):
        meta, errors = rc.parse_front_matter(GOOD)
        self.assertEqual(errors, [])
        self.assertEqual(meta["title"], "Flamethrower counts: A0 vs C1")
        self.assertEqual(meta["systems"], ["Flamethrower", "damage"])
        self.assertEqual(meta["summary"], "Counts matched; DPS UNKNOWN.")
        p = self.write("research/a.md", GOOD)
        self.assertEqual(rc.validate(meta, p, self.root), ([], []))

    def test_no_front_matter(self):
        self.assertEqual(rc.parse_front_matter("# Title\n---\n"), (None, []))

    def test_unclosed_and_bad_lines(self):
        self.assertTrue(rc.parse_front_matter("---\nkind: live\n")[1])
        self.assertTrue(rc.parse_front_matter("---\n  - nested\n---\n")[1])
        self.assertTrue(rc.parse_front_matter("---\nsystems: [a, b\n---\n")[1])

    def test_validation_errors(self):
        meta, _ = rc.parse_front_matter(
            GOOD.replace("status: active", "status: done").replace("[OBSERVED, UNKNOWN]", "[PROVEN]")
                .replace("date: 2026-10-04", "date: 04/10/2026").replace("levels: [Pokitaru]", "levels: Pokitaru"))
        fails, _ = rc.validate(meta, self.root / "x.md", self.root)
        joined = " ".join(fails)
        for needle in ("status", "evidence", "date", "levels must be"):
            self.assertIn(needle, joined)

    def test_missing_required_and_warnings(self):
        meta, _ = rc.parse_front_matter("---\nkind: live\nstatus: superseded\nfoo: bar\n"
                                        "related: [research/missing.md]\n---\n")
        fails, warns = rc.validate(meta, self.root / "x.md", self.root)
        self.assertTrue(any("title" in f for f in fails))
        self.assertTrue(any("unknown key" in w for w in warns))
        self.assertTrue(any("superseded_by" in w for w in warns))
        self.assertTrue(any("not found" in w for w in warns))

    def test_index_and_search(self):
        self.write("research/v2/x/REPORT.md", GOOD)
        self.write("docs/NOTE.md", GOOD.replace("2026-10-04", "2026-10-01").replace("Flamethrower,", "Blaster,"))
        code, _ = self.run_cmd(["index"])
        self.assertEqual(code, 0)
        data = json.loads((self.root / "research/report_catalog.json").read_text(encoding="utf-8"))
        self.assertEqual([e["path"] for e in data], ["research/v2/x/REPORT.md", "docs/NOTE.md"])
        md = (self.root / "research/REPORT_CATALOG.md").read_text(encoding="utf-8")
        self.assertIn("(v2/x/REPORT.md)", md)
        self.assertIn("(../docs/NOTE.md)", md)
        code, out = self.run_cmd(["search", "--system", "flamethrower"])
        self.assertIn("1 match", out)

    def test_check_explicit_requires_front_matter(self):
        code, out = self.run_cmd(["check", str(self.root / "research/other.md")])
        self.assertEqual(code, 1)
        self.assertIn("no front matter", out)

    def test_new_template_is_valid(self):
        out = self.root / "research/new.md"
        code, _ = self.run_cmd(["new", "--kind", "static", "--title", "A test", "--author", "Claude", "--out", str(out)])
        self.assertEqual(code, 0)
        meta, errors = rc.parse_front_matter(out.read_text(encoding="utf-8"))
        self.assertEqual(errors, [])
        self.assertEqual(rc.validate(meta, out, self.root)[0], [])
        code, _ = self.run_cmd(["new", "--kind", "static", "--title", "A", "--author", "C", "--out", str(out)])
        self.assertEqual(code, 2)


if __name__ == "__main__":
    unittest.main()
