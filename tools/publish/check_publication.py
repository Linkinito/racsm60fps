#!/usr/bin/env python3
"""Pre-publication checker for curated pushes to the public `main` branch.

Runs deterministic checks on an explicit file allowlist before it is copied to
or committed on `main` (docs/PUBLICATION_POLICY.md). It complements, and does
not replace, a human review of the staged list.

Usage:
  python tools/publish/check_publication.py FILE [FILE ...]
  python tools/publish/check_publication.py --from-file allowlist.txt
  python tools/publish/check_publication.py --staged      # on main, after git add
  options: --json  (machine-readable report)  --strict  (warnings also fail)

Exit code: 0 = no failure, 1 = at least one failure (or warning with --strict),
2 = usage error.

FAIL: forbidden path/extension (game images, modules, saves, captures,
disassembly, archives, build outputs, local workspace folders), file over
5 MB, unexpected binary file, secrets, disassembly-like listings or hex dumps
above the excerpt tolerance.
WARN: files under research/ (owner approval per file), absolute user paths, personal e-mail addresses, short disassembly or
hex excerpts, byte-signature strings, files over 1 MB, CURRENT_STATE.md.
"""

import argparse
import fnmatch
import json
import re
import subprocess
import sys
from pathlib import Path

MAX_FAIL_BYTES = 5 * 1024 * 1024
MAX_WARN_BYTES = 1 * 1024 * 1024

# Policy categories (docs/PUBLICATION_POLICY.md). Matched case-insensitively
# against the repository-relative POSIX path.
FORBIDDEN_GLOBS = [
    ("game image", ["*.iso", "*.cso", "*.chd"]),
    ("game module", ["*.prx", "*eboot.bin", "*/psp_game/*", "psp_game/*"]),
    ("save data", ["*/savedata/*", "savedata/*", "*param.sfo", "*secure.bin", "*icon0.png"]),
    ("memory capture", ["*.bin", "*.dump", "*.dmp", "*.ppst", "*ram*.dump*"]),
    ("disassembly or string dump", ["*.asm", "disasm-*.txt", "*/disasm-*.txt", "*disassembly*.txt", "*.ascii.txt"]),
    ("binary archive", ["*.zip", "*.7z", "*.rar", "*.tar", "*.tar.gz", "*.tgz"]),
    ("build output", ["*.elf", "*.o", "build/*", "*/build/*"]),
    ("local-only workspace", ["output/*", "outputs/*", "*/output/*", "*/outputs/*", "tmp/*", "*/tmp/*",
                              "measurements/*", "*/measurements/*", "_local/*", "*/_local/*"]),
    ("local-only workspace folder", ["01-travail-et-profil-ppsspp/*", "02-jeu-et-dumps/*", "03-emulateur/*",
                                     "*/toolchains/*", "toolchains/*"]),
]

# Allowed only with explicit owner approval for this file (WARN, FAIL with --strict).
REVIEW_GLOBS = [
    ("research tree (local by default; raw measurements/captures stay local)", ["research/*"]),
]

TEXT_SUFFIXES = {".md", ".txt", ".py", ".mjs", ".js", ".ts", ".json", ".ps1", ".psm1", ".c", ".h",
                 ".cpp", ".hpp", ".ini", ".cfg", ".toml", ".yml", ".yaml", ".html", ".css", ".csv",
                 ".sh", ".bat", ".cmd", ".gitignore", ".gitattributes", ".exp", ".mak", ".java", ".cs"}
IMAGE_SUFFIXES = {".png", ".jpg", ".jpeg", ".gif", ".svg", ".webp"}
TEXT_NAMES = {"makefile", "license", "readme", "agents.md", ".gitignore", ".gitattributes"}

# Allegrex/MIPS mnemonics frequent in listings. Used only together with an
# address/word prefix so ordinary prose does not match.
MNEMONICS = ("addiu|addu|subu|lui|ori|andi|xori|slti|sltiu|slt|sltu|sll|srl|sra|lw|sw|lh|lhu|sh|lb|lbu|sb|"
             "lwc1|swc1|lv\\.s|sv\\.s|lv\\.q|sv\\.q|jal|jalr|jr|j|beq|bne|beql|bnel|blez|bgtz|bltz|bgez|"
             "bc1t|bc1f|mtc1|mfc1|mov\\.s|add\\.s|sub\\.s|mul\\.s|div\\.s|c\\.lt\\.s|c\\.le\\.s|c\\.eq\\.s|"
             "cvt\\.s\\.w|trunc\\.w\\.s|nop|move|mult|multu|div|divu|mfhi|mflo|ext|ins|seb|seh|movz|movn|"
             "max|min|vadd\\.\\w|vmul\\.\\w|vmov\\.\\w")
DISASM_LINE = re.compile(
    r"^\s*(?:[0-9A-Fa-f]{2}:)?(?:0x)?[0-9A-Fa-f]{5,8}\s*[:|]?\s+(?:(?:0x)?[0-9A-Fa-f]{8}\s+)?"
    r"(?:" + MNEMONICS + r")\b", re.I)
# 16+ spaced bytes, or 80+ contiguous hex digits (SHA-1/SHA-256 digests are 40/64 and allowed).
HEX_DUMP_LINE = re.compile(r"(?:\b[0-9A-Fa-f]{2}\s+){15,}[0-9A-Fa-f]{2}\b|[0-9A-Fa-f]{80,}")
SIGNATURE_STRING = re.compile(r"[\"'](?:[0-9A-Fa-f]{2}|\?{1,2})(?:\s+(?:[0-9A-Fa-f]{2}|\?{1,2})){7,}[\"']")

SECRET_PATTERNS = [
    ("GitHub token", re.compile(r"\b(?:ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{30,}\b|\bgithub_pat_[A-Za-z0-9_]{40,}\b")),
    ("API key (sk- style)", re.compile(r"\bsk-(?:ant-|proj-)?[A-Za-z0-9_-]{24,}\b")),
    ("AWS access key", re.compile(r"\bAKIA[0-9A-Z]{16}\b")),
    ("private key block", re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----")),
    ("credential assignment", re.compile(
        # The value must contain a digit, so placeholders such as __SESSION_TOKEN__ pass.
        r"(?i)\b(?:api[_-]?key|secret|password|passwd|token)\b\s*[:=]\s*[\"']?"
        r"(?=[A-Za-z_\-/+=]*\d)[A-Za-z0-9_\-/+=]{16,}")),
]
USER_PATH = re.compile(r"[A-Za-z]:[\\/]+Users[\\/]+(?!Public\b)[A-Za-z0-9_][^\\/\s`\"']*"
                       r"|/c/Users/(?!Public\b)[A-Za-z0-9_][^/\s`\"']*"
                       r"|/home/[a-z_][a-z0-9_-]*/|/Users/(?!Shared\b)[A-Za-z][^/\s`\"']*/")
EMAIL = re.compile(r"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b")
EMAIL_ALLOWED = re.compile(r"(?i)noreply|no-reply|example\.(?:com|org)|users\.noreply\.github\.com")

DISASM_FAIL, DISASM_WARN = 20, 5
HEX_FAIL, HEX_WARN = 8, 1


def repo_root() -> Path:
    try:
        out = subprocess.run(["git", "rev-parse", "--show-toplevel"], capture_output=True, text=True, check=True)
        return Path(out.stdout.strip())
    except (OSError, subprocess.CalledProcessError):
        return Path.cwd()


def rel_posix(path: Path, root: Path) -> str:
    try:
        return path.resolve().relative_to(root.resolve()).as_posix()
    except ValueError:
        return path.as_posix()


def forbidden_category(rel: str) -> str | None:
    low = rel.lower()
    for label, globs in FORBIDDEN_GLOBS:
        if any(fnmatch.fnmatchcase(low, g) for g in globs):
            return label
    return None


def review_category(rel: str) -> str | None:
    low = rel.lower()
    for label, globs in REVIEW_GLOBS:
        if any(fnmatch.fnmatchcase(low, g) for g in globs):
            return label
    return None


def is_text_candidate(path: Path) -> bool:
    return path.suffix.lower() in TEXT_SUFFIXES or path.name.lower() in TEXT_NAMES


def scan_text(text: str) -> tuple[list[str], list[str]]:
    fails, warns = [], []
    lines = text.splitlines()
    disasm = [i + 1 for i, l in enumerate(lines) if DISASM_LINE.search(l)]
    hexd = [i + 1 for i, l in enumerate(lines) if HEX_DUMP_LINE.search(l)]
    sigs = [i + 1 for i, l in enumerate(lines) if SIGNATURE_STRING.search(l)]
    if len(disasm) >= DISASM_FAIL:
        fails.append(f"{len(disasm)} disassembly-like lines (first at line {disasm[0]}); "
                     f"policy allows short excerpts only")
    elif len(disasm) >= DISASM_WARN:
        warns.append(f"{len(disasm)} disassembly-like lines (first at line {disasm[0]}); confirm they are short excerpts")
    if len(hexd) >= HEX_FAIL:
        fails.append(f"{len(hexd)} hex-dump-like lines (first at line {hexd[0]})")
    elif len(hexd) >= HEX_WARN:
        warns.append(f"{len(hexd)} hex-dump-like line(s) (first at line {hexd[0]}); confirm not game-derived")
    if sigs:
        warns.append(f"{len(sigs)} byte-signature string(s) (first at line {sigs[0]}); game-derived bytes, owner review")
    for label, rx in SECRET_PATTERNS:
        m = rx.search(text)
        if m:
            line = text.count("\n", 0, m.start()) + 1
            fails.append(f"possible {label} at line {line}")
    m = USER_PATH.search(text)
    if m:
        line = text.count("\n", 0, m.start()) + 1
        warns.append(f"absolute user path at line {line} (use <you>, %USERPROFILE% or a relative path)")
    for m in EMAIL.finditer(text):
        if not EMAIL_ALLOWED.search(m.group(0)):
            line = text.count("\n", 0, m.start()) + 1
            warns.append(f"e-mail address at line {line}; confirm it may be public")
            break
    return fails, warns


def check_file(path: Path, root: Path) -> dict:
    rel = rel_posix(path, root)
    res = {"path": rel, "fail": [], "warn": []}
    if not path.exists():
        res["fail"].append("file not found")
        return res
    if path.is_dir():
        res["fail"].append("directory given; list files explicitly")
        return res
    cat = forbidden_category(rel)
    if cat:
        res["fail"].append(f"forbidden by publication policy: {cat}")
    rev = review_category(rel)
    if rev:
        res["warn"].append(f"needs explicit owner approval: {rev}")
    if Path(rel).name == "CURRENT_STATE.md":
        res["warn"].append("checkpoint file; publish only if the owner asked for it")
    size = path.stat().st_size
    if size > MAX_FAIL_BYTES:
        res["fail"].append(f"{size} bytes exceeds the 5 MB limit")
    elif size > MAX_WARN_BYTES:
        res["warn"].append(f"{size} bytes; large for a curated publication")
    data = path.read_bytes()
    suffix = path.suffix.lower()
    if b"\x00" in data[:65536] and not is_text_candidate(path):
        if suffix in IMAGE_SUFFIXES:
            res["warn"].append("image; confirm it is project-authored, not a game capture or texture")
        else:
            res["fail"].append("binary file; only project-authored text sources and images are published")
        return res
    if suffix in IMAGE_SUFFIXES:
        res["warn"].append("image; confirm it is project-authored, not a game capture or texture")
        if suffix != ".svg":
            return res
    text = data.decode("utf-8", errors="replace")
    f, w = scan_text(text)
    res["fail"] += f
    res["warn"] += w
    return res


def staged_files(root: Path) -> list[Path]:
    out = subprocess.run(["git", "diff", "--cached", "--name-only", "--diff-filter=ACMR"],
                         capture_output=True, text=True, check=True, cwd=root)
    return [root / p for p in out.stdout.splitlines() if p.strip()]


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("files", nargs="*")
    ap.add_argument("--from-file", help="text file with one path per line (# comments allowed)")
    ap.add_argument("--staged", action="store_true", help="check files staged in the current index")
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--strict", action="store_true", help="treat warnings as failures")
    a = ap.parse_args(argv)
    root = repo_root()
    paths = [Path(p) for p in a.files]
    if a.from_file:
        for line in Path(a.from_file).read_text(encoding="utf-8").splitlines():
            line = line.split("#", 1)[0].strip()
            if line:
                paths.append(root / line)
    if a.staged:
        paths += staged_files(root)
    if not paths:
        ap.print_usage(sys.stderr)
        print("error: no files to check", file=sys.stderr)
        return 2
    results = [check_file(p if p.is_absolute() else Path.cwd() / p, root) for p in paths]
    n_fail = sum(1 for r in results if r["fail"])
    n_warn = sum(1 for r in results if r["warn"])
    if a.json:
        print(json.dumps({"files": results, "failed": n_fail, "warned": n_warn}, indent=1))
    else:
        for r in results:
            status = "FAIL" if r["fail"] else ("WARN" if r["warn"] else "ok")
            print(f"{status:4}  {r['path']}")
            for m in r["fail"]:
                print(f"      FAIL {m}")
            for m in r["warn"]:
                print(f"      warn {m}")
        print(f"\n{len(results)} file(s): {n_fail} failed, {n_warn} with warnings")
    return 1 if n_fail or (a.strict and n_warn) else 0


if __name__ == "__main__":
    sys.exit(main())
