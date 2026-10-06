#!/usr/bin/env python3
"""Publish hash-only provenance from explicitly selected local damage manifests.

No instruction text, pointer-table contents or source words enter the output.
Run inspect-damage-routes.py recipes first; local folder choices are explicit.
"""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
LOCAL = ROOT / "research/v2/decomp-candidates/_local/damage-followup-20261006"
RECORDS = [
    ("gcs-001", "gcs-001"), ("gcs-002", "gcs-002"),
    ("hazards-001", "hazards-005"), ("mp-001", "mp-003"),
    ("skyboard-001", "skyboard-004"), ("arena-001", "arena-002"),
    ("miniturret-001", "miniturret-001"), ("children-001", "children-002"),
    ("gcs-sources-001", "gcs-sources-001"),
    ("roster-001", "roster-002"),
]
C_INPUTS = {
    "132bec": "38ab6a940636d1895549bf6c50b2db21c9f09e0e0d909908f00bfa087b5fc38b",
    "132e20": "ca3da1fe7bf66be13b6ab818a56de29d872c14bb113b43b9826c5ae8e505b4d6",
    "132f30": "f6bd40c3c4d61d0a9af5dcde69f17033fc6748b565728ba37f2e3877cc9a9fb4",
    "1335f4": "3b657315f5c32da043f5437624b466fb28c07d1ac640fbe9ad2ade3a9c3b041e",
    "164100": "dd4a8b42ca137d0756b06274e0a7c30f38d82696c8c8056bd110e90e515af28c",
    "164c30": "d43b1b4069caecba3d22c656e69a887f0eefb5de1f75637f02e2bf6817720c23",
    "163f80": "c6c9d640afcc475d590d469e61f1a617b0fb5345edbdb3cca9199281386a72d3",
    "163ec0": "f826fdb50029eca62a118fa17b9655e36e536eb9e6ab7c3c427dda75768473e6",
    "14748": "042f476e547f7238f7a9b162c6017dbdc268ab38316be45988611aabcd35428f",
    "14780": "479dfdf148e9c753a52c12c6648f1b0698887da1aa4d1e6ccf763d1f3006744a",
    "1480c": "954c156a39be1f151ec5c09a73e6ba7007b6636af838926e5c597b45bd95e111",
    "1483c": "d31824f8e8a83e0d3bba6ab477d4c8a12d5401ff84319004f825824dd627f802",
    "1485c": "6601174a952c910199d2ff72712c6202d81b6e59afc4bb09edf503e1cd6c3cb5",
    "16aba8": "81667a6aeb813c95fffe9b2e55546a7171fe054cb48743fc23b2d08ef7df51dd",
}


def digest(path, canonical=False):
    raw = path.read_bytes()
    if canonical:
        raw = raw.replace(b"\r\n", b"\n")
    return hashlib.sha256(raw).hexdigest()


def main():
    rows = []
    inspector = ROOT / "research/scripts/inspect-damage-routes.py"
    for recipe_name, folder in RECORDS:
        recipe = ROOT / f"research/scripts/ghidra/recipes/damage-followup-{recipe_name}.json"
        r = json.loads(recipe.read_text(encoding="utf-8-sig"))
        m = json.loads((LOCAL / folder / "manifest.json").read_text())
        assert m["source_sha256"] == r["source_sha256"] == digest(ROOT / r["source"])
        assert m["recipe_sha256"] == digest(recipe)
        assert m["method_sha256"] == digest(inspector)
        for helper, expected in m["helpers"].items():
            assert digest(ROOT / helper) == expected
        assert [(w["start"], w["end"]) for w in m["windows"]] == [
            (w["start"], w["end"]) for w in r["windows"]]
        rows.append({"recipe": str(recipe.relative_to(ROOT)).replace("\\", "/"),
                     "recipe_canonical_lf_sha256": digest(recipe, True),
                     "source": r["source"], "source_sha256": r["source_sha256"],
                     "local_folder": folder,
                     "windows": [{k: w[k] for k in ("start", "end", "bytes_sha256")}
                                 for w in m["windows"]],
                     "relocated_reference_count": len(m["pairs"])})
    c_rows = []
    for rva, expected in C_INPUTS.items():
        path = ROOT / f"research/v2/decomp-candidates/_local/20261001-mass/all/c/0x{rva}.c"
        assert digest(path) == expected
        c_rows.append({"rva": "0x" + rva, "raw_sha256": expected})
    methods = [inspector, Path(__file__), ROOT / "research/scripts/build-plugin-sites.py",
               ROOT / "research/scripts/build-object-disasm-corpus.py"]
    result = {"scope": "Hash-only reproducibility metadata; no gameplay acceptance",
              "authored_hash_encoding": "UTF-8 bytes with CRLF normalized to LF",
              "native_hash_encoding": "Unmodified little-endian Elf.word bytes; no relocation masking",
              "methods": {str(p.relative_to(ROOT)).replace("\\", "/"): digest(p, True) for p in methods},
              "recipes": rows, "existing_c_inputs": c_rows}
    output = ROOT / "research/v2/damage-followup-20261006/provenance.json"
    output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"Verified {len(rows)} recipes and {len(c_rows)} existing C inputs; hash-only metadata written.")


if __name__ == "__main__":
    main()
