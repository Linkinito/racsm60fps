#!/usr/bin/env python3
"""Validate, index and search report front matter (docs/methodology/REPORT_FRONT_MATTER.md).

  report_catalog.py check [FILE ...]   validate (explicit files must have front matter)
  report_catalog.py index              write research/REPORT_CATALOG.md + research/report_catalog.json
  report_catalog.py search TERM ...    [--status S] [--kind K] [--system X] [--level L]
  report_catalog.py new --kind K --title T --author A [--out FILE]

Dependency-free: parses the documented YAML subset (scalars and inline lists).
Scans research/ and docs/ Markdown files; files without front matter are
ignored by `index` and by `check` without arguments.
"""

import argparse
import datetime as dt
import json
import re
import subprocess
import sys
from pathlib import Path

KINDS = ("static", "live", "offline", "survey", "session-log", "protocol", "register")
STATUSES = ("active", "complete", "blocked", "superseded", "invalid")
LEVELS = ("OBSERVED", "INFERRED", "CORROBORATED", "TESTED", "UNKNOWN", "REJECTED", "SUPERSEDED")
REQUIRED = ("kind", "title", "date", "authors", "status", "evidence", "summary")
LIST_KEYS = ("authors", "evidence", "systems", "levels", "variants", "supersedes", "superseded_by",
             "related", "tags")
OPTIONAL = ("game", "environment") + tuple(k for k in LIST_KEYS if k not in REQUIRED)
SCAN_DIRS = ("research", "docs")
CATALOG_MD = Path("research/REPORT_CATALOG.md")
CATALOG_JSON = Path("research/report_catalog.json")
KEY_LINE = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*)\s*:\s*(.*)$")


def repo_root() -> Path:
    try:
        out = subprocess.run(["git", "rev-parse", "--show-toplevel"], capture_output=True, text=True, check=True)
        return Path(out.stdout.strip())
    except (OSError, subprocess.CalledProcessError):
        return Path(__file__).resolve().parents[2]


def _unquote(v: str) -> str:
    v = v.strip()
    if len(v) >= 2 and v[0] == v[-1] and v[0] in "\"'":
        return v[1:-1]
    return v


def _split_list(body: str) -> list[str]:
    items, cur, quote = [], "", None
    for ch in body:
        if quote:
            cur += ch
            if ch == quote:
                quote = None
        elif ch in "\"'":
            quote = ch
            cur += ch
        elif ch == ",":
            items.append(cur)
            cur = ""
        else:
            cur += ch
    if cur.strip():
        items.append(cur)
    return [_unquote(i) for i in items if i.strip()]


def _strip_trailing_comment(rest: str, what: str) -> None:
    rest = rest.strip()
    if rest and not rest.startswith("#"):
        raise ValueError(f"unexpected text after {what}: {rest!r}")


def parse_value(raw: str):
    raw = raw.strip()
    if raw.startswith("["):
        quote = None
        for i, ch in enumerate(raw):
            if quote:
                quote = None if ch == quote else quote
            elif ch in "\"'":
                quote = ch
            elif ch == "]":
                _strip_trailing_comment(raw[i + 1:], "inline list")
                return _split_list(raw[1:i])
        raise ValueError("unterminated inline list")
    if raw[:1] in "\"'":
        end = raw.find(raw[0], 1)
        if end < 0:
            raise ValueError("unterminated quoted value")
        _strip_trailing_comment(raw[end + 1:], "quoted value")
        return raw[1:end]
    return re.sub(r"\s+#.*$", "", raw)


def parse_front_matter(text: str) -> tuple[dict | None, list[str]]:
    """Return (meta, errors). meta is None when the file has no front matter."""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return None, []
    errors, meta = [], {}
    for i, line in enumerate(lines[1:], start=2):
        if line.strip() == "---":
            return meta, errors
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        m = KEY_LINE.match(line)
        if not m:
            errors.append(f"line {i}: expected 'key: value' (no nesting or multi-line values)")
            continue
        key, raw = m.groups()
        if key in meta:
            errors.append(f"line {i}: duplicate key {key!r}")
        try:
            meta[key] = parse_value(raw)
        except ValueError as e:
            errors.append(f"line {i}: {e}")
    return None, ["front matter starts with '---' but is never closed"]


def validate(meta: dict, path: Path, root: Path) -> tuple[list[str], list[str]]:
    fails, warns = [], []
    for k in REQUIRED:
        if meta.get(k) in (None, "", []):
            fails.append(f"missing required key: {k}")
    for k in meta:
        if k not in REQUIRED and k not in OPTIONAL:
            warns.append(f"unknown key: {k}")
    for k in LIST_KEYS:
        if k in meta and not isinstance(meta[k], list):
            fails.append(f"{k} must be an inline list, e.g. {k}: [a, b]")
    if meta.get("kind") and meta["kind"] not in KINDS:
        fails.append(f"kind {meta['kind']!r} not one of: {', '.join(KINDS)}")
    if meta.get("status") and meta["status"] not in STATUSES:
        fails.append(f"status {meta['status']!r} not one of: {', '.join(STATUSES)}")
    if isinstance(meta.get("evidence"), list):
        bad = [e for e in meta["evidence"] if e not in LEVELS]
        if bad:
            fails.append(f"evidence levels not recognised: {', '.join(bad)} (use {', '.join(LEVELS)})")
    d = meta.get("date")
    if d:
        try:
            dt.date.fromisoformat(str(d))
        except ValueError:
            fails.append(f"date must be YYYY-MM-DD, got {d!r}")
    if meta.get("status") == "superseded" and not meta.get("superseded_by"):
        warns.append("status superseded without superseded_by")
    for k in ("supersedes", "superseded_by", "related"):
        for ref in meta.get(k, []) if isinstance(meta.get(k), list) else []:
            if not (root / ref).exists():
                warns.append(f"{k} path not found: {ref}")
    return fails, warns


def scan(root: Path) -> list[Path]:
    files = []
    for d in SCAN_DIRS:
        base = root / d
        if base.is_dir():
            files += [p for p in base.rglob("*.md") if p.is_file()]
    return sorted(files)


def load(path: Path):
    text = path.read_text(encoding="utf-8", errors="replace")
    return parse_front_matter(text)


def rel(path: Path, root: Path) -> str:
    try:
        return path.resolve().relative_to(root.resolve()).as_posix()
    except ValueError:
        return path.as_posix()


def collect(root: Path) -> tuple[list[dict], list[str]]:
    entries, problems = [], []
    for p in scan(root):
        meta, errors = load(p)
        if meta is None and not errors:
            continue
        r = rel(p, root)
        if errors:
            problems += [f"{r}: {e}" for e in errors]
            continue
        fails, _ = validate(meta, p, root)
        if fails:
            problems += [f"{r}: {f}" for f in fails]
        entries.append({"path": r, **meta})
    entries.sort(key=lambda e: (str(e.get("date", "")), e["path"]), reverse=True)
    return entries, problems


def cmd_check(a, root: Path) -> int:
    explicit = bool(a.files)
    paths = [Path(f) for f in a.files] if explicit else scan(root)
    n_fail = n_checked = 0
    for p in paths:
        p = p if p.is_absolute() else Path.cwd() / p
        r = rel(p, root)
        if not p.exists():
            print(f"FAIL  {r}\n      file not found")
            n_fail += 1
            continue
        meta, errors = load(p)
        if meta is None and not errors:
            if explicit:
                print(f"FAIL  {r}\n      no front matter")
                n_fail += 1
            continue
        n_checked += 1
        fails, warns = (errors, []) if errors else validate(meta, p, root)
        status = "FAIL" if fails else ("WARN" if warns else "ok")
        if fails or warns or explicit:
            print(f"{status:4}  {r}")
            for m in fails:
                print(f"      FAIL {m}")
            for m in warns:
                print(f"      warn {m}")
        n_fail += bool(fails)
    print(f"\n{n_checked} file(s) with front matter checked, {n_fail} failed")
    return 1 if n_fail else 0


def _cell(v) -> str:
    if isinstance(v, list):
        v = ", ".join(v)
    return str(v or "").replace("|", "\\|").replace("\n", " ")


def cmd_index(a, root: Path) -> int:
    entries, problems = collect(root)
    lines = [
        "# Report catalog",
        "",
        "Generated by `python tools/research/report_catalog.py index` from report front matter",
        "(docs/methodology/REPORT_FRONT_MATTER.md). Do not edit by hand; regenerate.",
        "Only reports with front matter appear here; older reports remain in",
        "research/EVIDENCE_INDEX.md.",
        "",
        f"{len(entries)} report(s).",
        "",
        "| Date | Status | Kind | Report | Systems | Levels | Evidence | Summary |",
        "| --- | --- | --- | --- | --- | --- | --- | --- |",
    ]
    for e in entries:
        link = f"[{_cell(e.get('title'))}]({Path(e['path']).relative_to('research').as_posix()})" \
            if e["path"].startswith("research/") else f"[{_cell(e.get('title'))}](../{e['path']})"
        lines.append(f"| {_cell(e.get('date'))} | {_cell(e.get('status'))} | {_cell(e.get('kind'))} | {link} | "
                     f"{_cell(e.get('systems'))} | {_cell(e.get('levels'))} | {_cell(e.get('evidence'))} | "
                     f"{_cell(e.get('summary'))} |")
    if problems:
        lines += ["", "## Validation problems", ""] + [f"- {p}" for p in problems]
    (root / CATALOG_MD).write_text("\n".join(lines) + "\n", encoding="utf-8")
    (root / CATALOG_JSON).write_text(json.dumps(entries, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"wrote {CATALOG_MD.as_posix()} and {CATALOG_JSON.as_posix()}: {len(entries)} report(s), "
          f"{len(problems)} problem(s)")
    return 1 if problems else 0


def cmd_search(a, root: Path) -> int:
    entries, _ = collect(root)
    terms = [t.lower() for t in a.terms]

    def has(e, key, val):
        v = e.get(key, [])
        v = v if isinstance(v, list) else [v]
        return any(val.lower() == str(x).lower() for x in v)

    hits = []
    for e in entries:
        blob = json.dumps(e, ensure_ascii=False).lower()
        if any(t not in blob for t in terms):
            continue
        if a.status and e.get("status") != a.status:
            continue
        if a.kind and e.get("kind") != a.kind:
            continue
        if a.system and not has(e, "systems", a.system):
            continue
        if a.level and not has(e, "levels", a.level):
            continue
        hits.append(e)
    for e in hits:
        print(f"{e.get('date')}  {e.get('status'):10}  {e['path']}\n    {e.get('summary')}")
    print(f"\n{len(hits)} match(es)")
    return 0


TEMPLATE = """---
kind: {kind}
title: "{title}"
date: {date}
authors: ["{author}"]
status: active
evidence: [UNKNOWN]
summary: "One sentence: the result and its main limit."
systems: []
levels: []
variants: []
environment: ""
supersedes: []
related: []
---

# {title}

## Question

## Method and environment

## Results

## What was not verified

## Next action
"""


def cmd_new(a, root: Path) -> int:
    if a.kind not in KINDS:
        print(f"kind must be one of: {', '.join(KINDS)}", file=sys.stderr)
        return 2
    text = TEMPLATE.format(kind=a.kind, title=a.title.replace('"', "'"), author=a.author,
                           date=dt.date.today().isoformat())
    if a.out:
        out = Path(a.out)
        if out.exists():
            print(f"refusing to overwrite {out}", file=sys.stderr)
            return 2
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(text, encoding="utf-8")
        print(f"wrote {out}")
    else:
        sys.stdout.write(text)
    return 0


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("check")
    p.add_argument("files", nargs="*")
    sub.add_parser("index")
    p = sub.add_parser("search")
    p.add_argument("terms", nargs="*")
    p.add_argument("--status", choices=STATUSES)
    p.add_argument("--kind", choices=KINDS)
    p.add_argument("--system")
    p.add_argument("--level")
    p = sub.add_parser("new")
    p.add_argument("--kind", required=True)
    p.add_argument("--title", required=True)
    p.add_argument("--author", required=True)
    p.add_argument("--out")
    a = ap.parse_args(argv)
    root = repo_root()
    return {"check": cmd_check, "index": cmd_index, "search": cmd_search, "new": cmd_new}[a.cmd](a, root)


if __name__ == "__main__":
    sys.exit(main())
