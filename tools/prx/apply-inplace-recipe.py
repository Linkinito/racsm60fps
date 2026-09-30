#!/usr/bin/env python3
"""Build guarded in-place PSP PRX word edits from an experimental recipe.

Only existing words in executable, file-backed PT_LOAD segments are changed.
This tool never injects code, changes ELF metadata, or writes source images.
"""

import argparse
import hashlib
import json
import os
import struct
from pathlib import Path


REPO = Path(__file__).resolve().parents[2]
SHT_REL = 9
SHT_PSPREL = 0x700000A0


def digest(data):
    return hashlib.sha256(data).hexdigest()


def number(value):
    return int(value, 0) if isinstance(value, str) else int(value)


def segments(data):
    assert data[:4] == b"\x7fELF" and data[4:6] == b"\x01\x01", "not ELF32 LE"
    elf_type, machine = struct.unpack_from("<HH", data, 16)
    assert elf_type == 0xFFA0 and machine == 8, "not a MIPS PRX"
    offset = struct.unpack_from("<I", data, 28)[0]
    entry_size, count = struct.unpack_from("<HH", data, 42)
    assert entry_size == 32 and offset + count * entry_size <= len(data)
    return [struct.unpack_from("<8I", data, offset + i * entry_size)
            for i in range(count)]


def executable_file_offset(data, phdrs, rva):
    matches = []
    for ptype, offset, vaddr, _, filesz, _, flags, _ in phdrs:
        if ptype == 1 and flags & 1 and vaddr <= rva and rva + 4 <= vaddr + filesz:
            result = offset + rva - vaddr
            assert result + 4 <= len(data), "truncated executable segment"
            matches.append(result)
    assert len(matches) == 1, "RVA is not uniquely mapped to executable file data"
    return matches[0]


def relocation_offsets(data):
    offset = struct.unpack_from("<I", data, 32)[0]
    entry_size, count = struct.unpack_from("<HH", data, 46)
    assert entry_size == 40 and offset + count * entry_size <= len(data)
    result = set()
    for i in range(count):
        fields = struct.unpack_from("<10I", data, offset + i * entry_size)
        section_type, file_offset, size, reloc_entry_size = (
            fields[1], fields[4], fields[5], fields[9])
        if section_type == SHT_REL:
            raise AssertionError("standard SHT_REL mapping is not supported by this PRX writer")
        if section_type != SHT_PSPREL:
            continue
        assert reloc_entry_size == 8 and size % 8 == 0
        assert file_offset + size <= len(data)
        for pos in range(file_offset, file_offset + size, 8):
            result.add(struct.unpack_from("<I", data, pos)[0])
    return result


def build_one(recipe_entry):
    module_name = recipe_entry["module"]
    assert Path(module_name).name == module_name and module_name.endswith(".PRX"), (
        "invalid module filename", module_name)
    source = (REPO / recipe_entry["source"]).resolve()
    assert source.is_relative_to(REPO), "source outside repository"
    assert source.name == module_name, "module name and source filename differ"
    raw = source.read_bytes()
    assert digest(raw) == recipe_entry["sha256"], "source hash mismatch: %s" % source
    phdrs = segments(raw)
    relocations = relocation_offsets(raw)
    patched = bytearray(raw)
    edits = []
    seen = set()
    for edit in recipe_entry["edits"]:
        rva = number(edit["rva"])
        assert rva % 4 == 0 and rva not in seen
        seen.add(rva)
        assert rva not in relocations, "relocated word at RVA 0x%X" % rva
        file_offset = executable_file_offset(raw, phdrs, rva)
        before, after = number(edit["before_word"]), number(edit["after_word"])
        assert before != after and 0 <= before < 2**32 and 0 <= after < 2**32
        assert struct.unpack_from("<I", raw, file_offset)[0] == before, (
            "before-word mismatch", recipe_entry["module"], hex(rva))
        for check in edit.get("context", []):
            check_rva = rva + number(check["delta"])
            check_offset = executable_file_offset(raw, phdrs, check_rva)
            assert struct.unpack_from("<I", raw, check_offset)[0] == number(check["word"]), (
                "context mismatch", recipe_entry["module"], hex(check_rva))
        struct.pack_into("<I", patched, file_offset, after)
        edits.append({"rva": "0x%06X" % rva,
                      "file_offset": "0x%X" % file_offset,
                      "before_word": "0x%08X" % before,
                      "after_word": "0x%08X" % after})
    changed = {i for i, (a, b) in enumerate(zip(raw, patched)) if a != b}
    allowed = {int(edit["file_offset"], 16) + j for edit in edits for j in range(4)}
    assert changed and changed <= allowed, "unexpected changed byte"
    return source, bytes(patched), {
        "module": recipe_entry["module"],
        "source": recipe_entry["source"],
        "source_sha256": digest(raw),
        "patched_sha256": digest(patched),
        "source_bytes": len(raw),
        "patched_bytes": len(patched),
        "changed_byte_count": len(changed),
        "edits": edits,
        "relocation_entries_scanned": sum(1 for _ in relocations),
    }


def write_if_new(path, data):
    if path.exists():
        assert path.read_bytes() == data, "existing output differs: %s" % path
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = path.with_name(path.name + ".tmp")
    assert not temp.exists(), "temporary output already exists: %s" % temp
    temp.write_bytes(data)
    os.replace(temp, path)


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--recipe", required=True, type=Path)
    parser.add_argument("--output-dir", type=Path,
                        help="write guarded PRX copies here; omission is a dry run")
    args = parser.parse_args()
    recipe_raw = args.recipe.read_bytes()
    recipe = json.loads(recipe_raw)
    assert recipe["schema_version"] == 1
    assert recipe["game_id"] == "UCES00420"
    builds = [build_one(entry) for entry in recipe["modules"]]
    names = [item[2]["module"] for item in builds]
    assert len(names) == len(set(names)), "duplicate module"
    summary = {
        "recipe_sha256": digest(recipe_raw),
        "patch_id": recipe["patch_id"],
        "game_id": recipe["game_id"],
        "status": "experimental_static_only",
        "modules": [item[2] for item in builds],
    }
    if args.output_dir:
        outdir = args.output_dir.resolve()
        assert all(outdir != source.parent and not outdir.is_relative_to(source.parent)
                   for source, _, _ in builds), "output directory overlaps source"
        manifest_bytes = (json.dumps(summary, indent=2, sort_keys=True) + "\n").encode("utf-8")
        desired = [(outdir / entry["module"], patched)
                   for _, patched, entry in builds]
        desired.append((outdir / "build-manifest.json", manifest_bytes))
        for path, data in desired:
            assert not path.exists() or path.read_bytes() == data, (
                "existing output differs", str(path))
        for path, data in desired:
            write_if_new(path, data)
        print("WROTE %d experimental PRX copies to %s" % (len(builds), outdir))
    else:
        print("PASS: %d guarded modules; dry run, no PRX written" % len(builds))
    for entry in summary["modules"]:
        print("%s %s -> %s" % (entry["module"], entry["source_sha256"],
                                entry["patched_sha256"]))


if __name__ == "__main__":
    main()
