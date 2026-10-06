#!/usr/bin/env python3
"""Bounded read-only native windows and PSP pointer resolution, without matching.

Recipes contain previously evidenced windows/pairs only. Raw outputs stay local.
Uses the existing ELF relocation helper and installed/vendored decoder unchanged.
"""
import argparse
import hashlib
import importlib.util
import json
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("recipe", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    out = args.output.resolve()
    local = (ROOT / "research/v2/decomp-candidates/_local").resolve()
    assert out.is_relative_to(local) and out != local
    assert not (out / "manifest.json").exists(), "Preserve prior output"
    recipe = json.loads(args.recipe.read_text(encoding="utf-8-sig"))
    helper = ROOT / "research/scripts/build-plugin-sites.py"
    decoder = ROOT / "research/scripts/build-object-disasm-corpus.py"
    p = load("damage_sites", helper)
    d = load("damage_decoder", decoder)
    source = ROOT / recipe["source"]
    before = sha(source)
    assert before == recipe["source_sha256"]
    elf = p.Elf(recipe["source"])
    cs = d.load_capstone()
    md = cs.Cs(cs.CS_ARCH_MIPS, cs.CS_MODE_MIPS32 | cs.CS_MODE_LITTLE_ENDIAN)
    windows = recipe.get("windows", [])
    assert 1 <= len(windows) <= 32
    out.mkdir(parents=True, exist_ok=True)
    rows = []
    for window in windows:
        start, end = int(window["start"], 16), int(window["end"], 16)
        assert start % 4 == end % 4 == 0 and 0 < end-start <= 16384
        assert window["entry_evidence"]
        lines, raw = [], bytearray()
        for at in range(start, end, 4):
            word = struct.pack("<I", elf.word(at))
            raw.extend(word)
            ins = list(md.disasm(word, at))
            text = f"{ins[0].mnemonic} {ins[0].op_str}" if ins else "UNDECODED"
            lines.append(f"{at:08x}\t{text}")
        path = out / f"{start:08x}.instructions.txt"
        path.write_text("\n".join(lines)+"\n", encoding="utf-8")
        rows.append({**window, "bytes_sha256": hashlib.sha256(raw).hexdigest(),
                     "listing_sha256": sha(path), "file": path.name})
    resolved = []
    for pair in recipe.get("pairs", []):
        hi, lo = int(pair["hi"],16), int(pair["lo"],16)
        address = p.pair_address(elf, hi, lo)
        item = {**pair, "resolved": hex(address)}
        if pair.get("table_bytes"):
            size = pair["table_bytes"]
            assert 0 < size <= 256 and size % 4 == 0
            entries = []
            for at in range(address, address+size, 4):
                word, info = elf.word(at), elf.rel.get(at, 0)
                value = word + elf.segments[(info>>16)&255][2] if info&255 == 2 else word
                entries.append({"rva":hex(at), "value":hex(value), "relocation_kind":info&255})
            item["entries"] = entries
        resolved.append(item)
    assert sha(source) == before
    manifest = {"mode":"READ_ONLY_NATIVE_NO_MATCHING", "source":recipe["source"],
                "source_sha256":before, "recipe_sha256":sha(args.recipe),
                "method_sha256":sha(Path(__file__)), "helpers":{str(x.relative_to(ROOT)):sha(x) for x in (helper,decoder)},
                "windows":rows, "pairs":resolved,
                "limits":"Explicit windows only; no claimed function extent, C prototype or gameplay parity"}
    (out / "manifest.json").write_text(json.dumps(manifest,indent=2)+"\n",encoding="utf-8")
    print(f"Verified read-only source; {len(rows)} bounded windows, {len(resolved)} relocated references; raw output local.")


if __name__ == "__main__":
    main()
