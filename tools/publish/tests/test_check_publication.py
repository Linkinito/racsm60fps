"""Tests for tools/publish/check_publication.py (run: python -m unittest discover tools/publish/tests).

Fixtures are synthetic and generated at runtime so this file contains no
listing, dump or secret that would itself trip the checker.
"""

import importlib.util
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("check_publication", HERE.parent / "check_publication.py")
cp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cp)


def fake_listing(n: int) -> str:
    return "\n".join(f"0x{0x10000 + 4 * i:08X}: {0x27BDFFF0 + i:08X}  addiu sp, sp, -0x10" for i in range(n))


class CheckPublicationTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)

    def tearDown(self):
        self.tmp.cleanup()

    def put(self, rel: str, content, binary=False) -> Path:
        p = self.root / rel
        p.parent.mkdir(parents=True, exist_ok=True)
        if binary:
            p.write_bytes(content)
        else:
            p.write_text(content, encoding="utf-8")
        return p

    def check(self, rel, content, binary=False):
        return cp.check_file(self.put(rel, content, binary), self.root)

    def test_clean_doc_passes(self):
        r = self.check("docs/NOTE.md", "# Note\n\nPlain prose about cadence at 0x2FCF4.\n")
        self.assertEqual(r["fail"], [])
        self.assertEqual(r["warn"], [])

    def test_forbidden_extensions(self):
        for rel in ("game/LEVEL_01.PRX", "x/EBOOT.BIN", "cap/ram.bin", "a/listing.asm", "a/disasm-01.txt",
                    "b/bundle.zip", "s/SAVEDATA/DATA.BIN", "out/patch.elf", "02-Jeu-et-dumps/readme.md"):
            with self.subTest(rel=rel):
                r = self.check(rel, "x")
                self.assertTrue(any("forbidden" in m for m in r["fail"]), r)

    def test_project_tool_named_disasm_is_allowed(self):
        r = self.check("tools/runtime/disasm-listing.py", "print('tool')\n")
        self.assertEqual(r["fail"], [])

    def test_research_needs_owner_approval(self):
        r = self.check("research/v2/x/REPORT.md", "text\n")
        self.assertEqual(r["fail"], [])
        self.assertTrue(any("owner approval" in m for m in r["warn"]))

    def test_listing_thresholds(self):
        self.assertEqual(self.check("docs/a.md", fake_listing(3))["warn"], [])
        self.assertTrue(self.check("docs/b.md", fake_listing(cp.DISASM_WARN))["warn"])
        self.assertTrue(self.check("docs/c.md", fake_listing(cp.DISASM_FAIL))["fail"])

    def test_sha256_is_not_a_hex_dump(self):
        r = self.check("docs/h.md", "SHA256 " + "ab" * 32 + "\n")
        self.assertEqual(r["warn"], [])

    def test_hex_dump_detected(self):
        line = " ".join(f"{i:02X}" for i in range(16))
        r = self.check("docs/d.md", "\n".join([line] * cp.HEX_FAIL))
        self.assertTrue(r["fail"])

    def test_signature_string_warns(self):
        r = self.check("src/main.c", 'p = find("' + " ".join(["3C", "??", "A5", "34"] * 2) + '");\n')
        self.assertTrue(any("signature" in m for m in r["warn"]))

    def test_secret_fails_placeholder_passes(self):
        fake = "gh" + "p_" + "A1b2C3d4" * 5
        self.assertTrue(self.check("docs/s.md", f"key {fake}\n")["fail"])
        self.assertEqual(self.check("tools/p.html", "const token='__SESSION_TOKEN__';\n")["fail"], [])

    def test_user_path_and_email_warn(self):
        r = self.check("docs/u.md", "C:" + "\\Users\\someone\\x and a" + "@" + "b.org\n")
        self.assertEqual(len(r["warn"]), 2)
        r2 = self.check("docs/v.md", "%USERPROFILE%\\x and noreply" + "@" + "anthropic.com\n")
        self.assertEqual(r2["warn"], [])

    def test_unknown_binary_fails(self):
        r = self.check("docs/blob.dat", b"\x00\x01\x02", binary=True)
        self.assertTrue(r["fail"])

    def test_size_limit(self):
        r = self.check("docs/big.md", "a" * (cp.MAX_FAIL_BYTES + 1))
        self.assertTrue(any("5 MB" in m for m in r["fail"]))

    def test_missing_file(self):
        self.assertTrue(cp.check_file(self.root / "nope.md", self.root)["fail"])


if __name__ == "__main__":
    unittest.main()
