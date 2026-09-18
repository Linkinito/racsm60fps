#!/usr/bin/env python3
"""Build a reproducible, binary-free reference corpus for UCES-00420.

The builder consumes the locally supplied game binaries, RAM dumps, asset
archives and patch packages.  It emits metadata, hashes, address maps and a
self-contained HTML report, but deliberately never copies copyrighted game
assets into the resulting deliverable.
"""

from __future__ import annotations

import argparse
import bisect
import csv
import hashlib
import html
import json
import re
import shutil
import struct
import sys
from collections import Counter, defaultdict
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterable
from zipfile import ZipFile


PSP_MEMORY_BASE = 0x08800000
PSP_MEMORY_SIZE = 0x01800000
EBOOT_RUNTIME_BASE = 0x08804000
LEVEL_RUNTIME_BASE = 0x09139D00
MODULE_INDEX_ADDRESS = 0x08841120
EBOOT_HOOK_ADDRESS = 0x08806DA4
PROFILE_MARKER_ADDRESS = 0x08803FE0
DISPATCHER_INDEX_ADDRESS = 0x08803FE4
DISPATCHER_STATE_ADDRESS = 0x08803FE8
DISPATCHER_COUNT_ADDRESS = 0x08803FEC
WRAPPER_ENTRY_DELTA = 0x38
WRAPPER_ONE_PASS_DELTA = 0x104
FUNCTION_SIGNATURE_BYTES = 96


LEVEL_NAMES = {
    0: "Frontend",
    1: "Pokitaru",
    2: "Ryllus",
    3: "Kalidon",
    4: "Metalis",
    5: "Dreamtime",
    6: "Medical Outpost Omega",
    7: "Challax",
    8: "Dayni Moon",
    9: "Inside Clank",
    10: "Quadrona",
    15: "Giant Clank — niveau 4",
    16: "Multijoueur — carte 1",
    17: "Multijoueur — carte 2",
    18: "Multijoueur — carte 3",
    19: "Multijoueur — carte 4",
    20: "Lobby multijoueur",
    21: "Giant Clank — niveau 7",
    22: "Airboard — niveau 3",
    23: "Airboard — niveau 6",
    24: "HIG Treehouse",
}


RELOCATION_NAMES = {
    0: "R_MIPS_NONE",
    1: "R_MIPS_16",
    2: "R_MIPS_32",
    3: "R_MIPS_REL32",
    4: "R_MIPS_26",
    5: "R_MIPS_HI16",
    6: "R_MIPS_LO16",
    7: "R_MIPS_GPREL16",
    9: "R_MIPS_GOT16",
    10: "R_MIPS_PC16",
    11: "R_MIPS_CALL16",
    12: "R_MIPS_GPREL32",
}


SOURCE_ROLES = {
    "01-RAM.dump": "Capture RAM brute — Ryllus / module 2",
    "02-RAM.dump.gzf": "Archive Ghidra associée à RAM.dump",
    "03-URL-Liste-de-patchs-60-fps-pour-PPSSPP.txt": "Référence communautaire — liste de patchs 60 FPS",
    "04-URL-Tutoriaux-pour-passer-un-jeu-en-60-fps-sur-PPSSPP.txt": "Références communautaires — tutoriels et tentative antérieure",
    "05-GLOBALWAD-1-.zip": "Conteneurs de données globaux du jeu",
    "06-HUD-1-.zip": "Données HUD et localisation",
    "07-BIN-1-.zip": "Corpus principal des PRX de niveau",
    "ALLLEVELS(1).zip": "WAD de tous les niveaux fournis",
    "LEVEL_02_clean(1).PRX": "PRX propre de Ryllus",
    "RAM2(2).dump": "Capture RAM brute — Pokitaru / module 1",
    "RCPM(1).PRX": "PRX RCPM déchiffré",
    "UCES00420_EBOOT(1).BIN": "EBOOT déchiffré UCES-00420",
    "UCES00420.ini": "Profil PPSSPP global actuellement fourni",
    "Size_Matters_60FPS_GLOBAL_SOCLE_v0.1.0-prealpha.1_UCES00420(1).zip": "Paquet de patch socle v0.1.0",
    "Size_Matters_60FPS_GLOBAL_EXPERIENCE_v0.2.0-prealpha.1_UCES00420(1).zip": "Paquet expérience v0.2.0",
    "Size_Matters_60FPS_GLOBAL_EXPERIENCE_v0.2.1-prealpha.1_UCES00420(1).zip": "Paquet expérience corrigé v0.2.1",
}


@dataclass(frozen=True)
class Section:
    index: int
    name: str
    type: int
    flags: int
    address: int
    offset: int
    size: int
    link: int
    info: int
    alignment: int
    entry_size: int

    @property
    def allocated(self) -> bool:
        return bool(self.flags & 0x2)

    @property
    def executable(self) -> bool:
        return bool(self.flags & 0x4)

    @property
    def writable(self) -> bool:
        return bool(self.flags & 0x1)


class Elf32:
    """Small dependency-free reader for the ELF32/MIPS PRX files in this corpus."""

    def __init__(self, data: bytes, source_name: str):
        self.data = data
        self.source_name = source_name
        if len(data) < 52 or data[:4] != b"\x7fELF":
            raise ValueError(f"{source_name}: fichier ELF32 invalide")
        if data[4] != 1 or data[5] != 1:
            raise ValueError(f"{source_name}: seul ELF32 little-endian est pris en charge")
        values = struct.unpack_from("<16sHHIIIIIHHHHHH", data, 0)
        (
            _ident,
            self.elf_type,
            self.machine,
            self.version,
            self.entry_point,
            self.program_header_offset,
            self.section_header_offset,
            self.flags,
            self.header_size,
            self.program_header_entry_size,
            self.program_header_count,
            self.section_header_entry_size,
            self.section_header_count,
            self.section_name_index,
        ) = values
        raw_sections = [
            struct.unpack_from(
                "<IIIIIIIIII",
                data,
                self.section_header_offset + i * self.section_header_entry_size,
            )
            for i in range(self.section_header_count)
        ]
        shstr = raw_sections[self.section_name_index]
        names = data[shstr[4] : shstr[4] + shstr[5]]
        self.sections: list[Section] = []
        for index, raw in enumerate(raw_sections):
            name_end = names.find(b"\0", raw[0])
            name = names[raw[0] : name_end].decode("ascii", errors="replace") if raw[0] else ""
            self.sections.append(
                Section(
                    index=index,
                    name=name,
                    type=raw[1],
                    flags=raw[2],
                    address=raw[3],
                    offset=raw[4],
                    size=raw[5],
                    link=raw[6],
                    info=raw[7],
                    alignment=raw[8],
                    entry_size=raw[9],
                )
            )
        self.by_name = {section.name: section for section in self.sections}
        self.program_headers = []
        for index in range(self.program_header_count):
            offset = self.program_header_offset + index * self.program_header_entry_size
            if offset + 32 <= len(data):
                p = struct.unpack_from("<IIIIIIII", data, offset)
                self.program_headers.append(
                    {
                        "index": index,
                        "type": p[0],
                        "offset": p[1],
                        "virtual_address": p[2],
                        "physical_address": p[3],
                        "file_size": p[4],
                        "memory_size": p[5],
                        "flags": p[6],
                        "alignment": p[7],
                    }
                )

    def section_bytes(self, name: str) -> bytes:
        section = self.by_name[name]
        if section.type == 8:
            return b""
        return self.data[section.offset : section.offset + section.size]

    def section_for_vaddr(self, address: int, include_nobits: bool = True) -> Section | None:
        for section in self.sections:
            if section.address <= address < section.address + section.size:
                if include_nobits or section.type != 8:
                    return section
        return None

    def file_offset(self, address: int) -> int | None:
        section = self.section_for_vaddr(address, include_nobits=False)
        if section is None:
            return None
        return section.offset + address - section.address

    def read_vaddr(self, address: int, size: int) -> bytes:
        offset = self.file_offset(address)
        if offset is None or offset + size > len(self.data):
            raise ValueError(f"{self.source_name}: adresse ELF hors fichier 0x{address:08X}")
        return self.data[offset : offset + size]

    def read_u32(self, address: int) -> int:
        return struct.unpack("<I", self.read_vaddr(address, 4))[0]

    @property
    def memory_size(self) -> int:
        return max(
            (section.address + section.size for section in self.sections if section.allocated),
            default=0,
        )

    def module_info(self) -> dict[str, Any]:
        section = self.by_name.get(".rodata.sceModuleInfo")
        if section is None or section.size < 52:
            return {}
        raw = self.section_bytes(section.name)[:52]
        attributes, version = struct.unpack_from("<HH", raw, 0)
        name = raw[4:32].split(b"\0", 1)[0].decode("ascii", errors="replace")
        gp, ent_top, ent_end, stub_top, stub_end = struct.unpack_from("<IIIII", raw, 32)
        return {
            "attributes": attributes,
            "version": version,
            "name": name,
            "gp": gp,
            "ent_top": ent_top,
            "ent_end": ent_end,
            "stub_top": stub_top,
            "stub_end": stub_end,
        }

    def imports(self) -> list[dict[str, Any]]:
        section = self.by_name.get(".lib.stub")
        if section is None:
            return []
        output = []
        cursor = section.address
        section_end = section.address + section.size
        while cursor + 12 <= section_end:
            prefix = self.read_vaddr(cursor, 12)
            length = prefix[8]
            descriptor_size = length * 4
            if descriptor_size < 20 or cursor + descriptor_size > section_end:
                break
            raw = self.read_vaddr(cursor, descriptor_size)
            name_ptr, version, flags, length, variable_count, function_count, nid_ptr, stub_ptr = struct.unpack(
                "<IHHBBHII", raw[:20]
            )
            try:
                library = self.read_c_string(name_ptr)
            except ValueError:
                library = f"<name@0x{name_ptr:08X}>"
            for index in range(function_count):
                nid = self.read_u32(nid_ptr + index * 4)
                output.append(
                    {
                        "library": library,
                        "library_version": version,
                        "library_flags": flags,
                        "stub_descriptor_rva": cursor,
                        "kind": "function",
                        "ordinal": index,
                        "nid": nid,
                        "stub_rva": stub_ptr + index * 8,
                    }
                )
            for index in range(variable_count):
                variable_table_ptr = struct.unpack_from("<I", raw, 20)[0] if descriptor_size >= 24 else 0
                try:
                    nid = self.read_u32(variable_table_ptr + 4 + index * 8) if variable_table_ptr else 0
                except ValueError:
                    nid = 0
                output.append(
                    {
                        "library": library,
                        "library_version": version,
                        "library_flags": flags,
                        "stub_descriptor_rva": cursor,
                        "kind": "variable",
                        "ordinal": index,
                        "nid": nid,
                        "stub_rva": variable_table_ptr + index * 8 if variable_table_ptr else 0,
                    }
                )
            cursor += descriptor_size
        return output

    def exports(self) -> list[dict[str, Any]]:
        section = self.by_name.get(".lib.ent")
        if section is None:
            return []
        output = []
        for cursor in range(section.address, section.address + section.size, 16):
            if cursor + 16 > section.address + section.size:
                break
            raw = self.read_vaddr(cursor, 16)
            name_ptr, version, flags, length, variable_count, function_count, table_ptr = struct.unpack(
                "<IHHBBHI", raw
            )
            library = "syslib" if name_ptr == 0 else self.read_c_string(name_ptr)
            total = function_count + variable_count
            for index in range(total):
                nid = self.read_u32(table_ptr + index * 4)
                address = self.read_u32(table_ptr + total * 4 + index * 4)
                output.append(
                    {
                        "library": library,
                        "library_version": version,
                        "library_flags": flags,
                        "entry_descriptor_rva": cursor,
                        "kind": "function" if index < function_count else "variable",
                        "ordinal": index if index < function_count else index - function_count,
                        "nid": nid,
                        "export_rva": address,
                    }
                )
        return output

    def read_c_string(self, address: int, limit: int = 512) -> str:
        offset = self.file_offset(address)
        if offset is None:
            raise ValueError("adresse de chaîne invalide")
        end = self.data.find(b"\0", offset, min(len(self.data), offset + limit))
        if end < 0:
            end = min(len(self.data), offset + limit)
        return self.data[offset:end].decode("ascii", errors="replace")

    def relocations(self) -> list[dict[str, Any]]:
        rows = []
        for section in self.sections:
            if not section.name.startswith(".rel") or section.entry_size not in (0, 8):
                continue
            if section.size % 8:
                continue
            target_section = self.sections[section.info].name if section.info < len(self.sections) else ""
            for offset in range(section.offset, section.offset + section.size, 8):
                relocation_address, info = struct.unpack_from("<II", self.data, offset)
                relocation_type = info & 0xFF
                rows.append(
                    {
                        "relocation_section": section.name,
                        "target_section": target_section,
                        "rva": relocation_address,
                        "type": relocation_type,
                        "type_name": RELOCATION_NAMES.get(relocation_type, f"R_MIPS_{relocation_type}"),
                        "symbol": info >> 8,
                    }
                )
        return rows


@dataclass
class ModuleSource:
    key: str
    file_name: str
    module_index: int | None
    level_name: str
    mode: str
    source_container: str
    source_member: str
    data: bytes
    runtime_base: int | None
    base_evidence: str


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def hash_zip_member(archive: ZipFile, member: str) -> tuple[str, bytes]:
    digest = hashlib.sha256()
    first = b""
    with archive.open(member) as handle:
        while True:
            chunk = handle.read(1024 * 1024)
            if not chunk:
                break
            if len(first) < 64:
                first += chunk[: 64 - len(first)]
            digest.update(chunk)
    return digest.hexdigest(), first


def hex_or_blank(value: int | None, width: int = 8) -> str:
    return "" if value is None else f"0x{value:0{width}X}"


def signed16(value: int) -> int:
    return value - 0x10000 if value & 0x8000 else value


def normalize_line_endings(data: bytes) -> bytes:
    if data.startswith(b"\xef\xbb\xbf"):
        data = data[3:]
    return data.replace(b"\r\n", b"\n").rstrip(b"\n")


def find_ascii_strings(data: bytes, minimum: int = 4) -> list[str]:
    pattern = rb"[\x20-\x7E]{" + str(minimum).encode("ascii") + rb",}"
    return [match.group().decode("ascii", errors="replace") for match in re.finditer(pattern, data)]


def normalized_code_window(
    elf: Elf32,
    start_rva: int,
    relocation_types: dict[int, int],
    length: int = FUNCTION_SIGNATURE_BYTES,
) -> bytes:
    text = elf.by_name.get(".text")
    if text is None or not (text.address <= start_rva < text.address + text.size):
        return b""
    available = min(length, text.address + text.size - start_rva)
    available -= available % 4
    raw = bytearray(elf.read_vaddr(start_rva, available))
    for relative in range(0, available, 4):
        address = start_rva + relative
        relocation_type = relocation_types.get(address)
        if relocation_type is not None:
            struct.pack_into("<I", raw, relative, 0xF0000000 | relocation_type)
    return bytes(raw)


def normalized_text_hash(elf: Elf32, relocation_types: dict[int, int]) -> str:
    text = elf.by_name[".text"]
    raw = bytearray(elf.section_bytes(".text"))
    for rva, relocation_type in relocation_types.items():
        if text.address <= rva <= text.address + text.size - 4:
            struct.pack_into("<I", raw, rva - text.address, 0xF0000000 | relocation_type)
    return sha256_bytes(bytes(raw))


def format_mips(word: int, site: int | None = None) -> str:
    opcode = word >> 26
    rs = (word >> 21) & 31
    rt = (word >> 16) & 31
    rd = (word >> 11) & 31
    immediate = word & 0xFFFF
    registers = [
        "zero", "at", "v0", "v1", "a0", "a1", "a2", "a3",
        "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7",
        "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7",
        "t8", "t9", "k0", "k1", "gp", "sp", "fp", "ra",
    ]
    if word == 0:
        return "nop"
    if opcode == 0:
        function = word & 0x3F
        if function == 8:
            return f"jr ${registers[rs]}"
        if function == 9:
            return f"jalr ${registers[rd]}, ${registers[rs]}"
        if function in (0x21, 0x23):
            return f"{'addu' if function == 0x21 else 'subu'} ${registers[rd]}, ${registers[rs]}, ${registers[rt]}"
        if function in (0x00, 0x02, 0x03):
            mnemonic = {0x00: "sll", 0x02: "srl", 0x03: "sra"}[function]
            return f"{mnemonic} ${registers[rd]}, ${registers[rt]}, {(word >> 6) & 31}"
    if opcode in (2, 3):
        target = (word & 0x03FFFFFF) << 2
        if site is not None:
            target |= (site + 4) & 0xF0000000
        return f"{'jal' if opcode == 3 else 'j'} 0x{target:08X}"
    if opcode in (4, 5):
        target = ""
        if site is not None:
            target = f"0x{site + 4 + (signed16(immediate) << 2):08X}"
        return f"{'beq' if opcode == 4 else 'bne'} ${registers[rs]}, ${registers[rt]}, {target or signed16(immediate)}"
    if opcode in (8, 9, 10, 11, 12, 13, 14, 15):
        mnemonic = {8: "addi", 9: "addiu", 10: "slti", 11: "sltiu", 12: "andi", 13: "ori", 14: "xori", 15: "lui"}[opcode]
        if opcode == 15:
            return f"lui ${registers[rt]}, 0x{immediate:04X}"
        value = immediate if opcode in (12, 13, 14) else signed16(immediate)
        return f"{mnemonic} ${registers[rt]}, ${registers[rs]}, {value}"
    if opcode in (0x20, 0x21, 0x23, 0x24, 0x25, 0x28, 0x29, 0x2B, 0x31, 0x39):
        mnemonic = {
            0x20: "lb", 0x21: "lh", 0x23: "lw", 0x24: "lbu", 0x25: "lhu",
            0x28: "sb", 0x29: "sh", 0x2B: "sw", 0x31: "lwc1", 0x39: "swc1",
        }[opcode]
        target_register = f"$f{rt}" if opcode in (0x31, 0x39) else f"${registers[rt]}"
        return f"{mnemonic} {target_register}, {signed16(immediate)}(${registers[rs]})"
    return f".word 0x{word:08X}"


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str] | None = None) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if fieldnames is None:
        fieldnames = []
        seen = set()
        for row in rows:
            for key in row:
                if key not in seen:
                    seen.add(key)
                    fieldnames.append(key)
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def resolve_inputs(root: Path) -> dict[str, Path]:
    exact = {
        "ram_ryllus": root / "project_sources/01-RAM.dump",
        "ram_gzf": root / "project_sources/02-RAM.dump.gzf",
        "patch_urls": root / "project_sources/03-URL-Liste-de-patchs-60-fps-pour-PPSSPP.txt",
        "tutorial_urls": root / "project_sources/04-URL-Tutoriaux-pour-passer-un-jeu-en-60-fps-sur-PPSSPP.txt",
        "globalwad_zip": root / "project_sources/05-GLOBALWAD-1-.zip",
        "hud_zip": root / "project_sources/06-HUD-1-.zip",
        "bin_zip": root / "project_sources/07-BIN-1-.zip",
        "alllevels_zip": root / "upload/ALLLEVELS(1).zip",
        "level2_clean": root / "upload/LEVEL_02_clean(1).PRX",
        "ram_pokitaru": root / "upload/RAM2(2).dump",
        "rcpm": root / "upload/RCPM(1).PRX",
        "eboot": root / "upload/UCES00420_EBOOT(1).BIN",
        "ini": root / "upload/UCES00420.ini",
        "patch_socle": root / "upload/Size_Matters_60FPS_GLOBAL_SOCLE_v0.1.0-prealpha.1_UCES00420(1).zip",
        "patch_v020": root / "upload/Size_Matters_60FPS_GLOBAL_EXPERIENCE_v0.2.0-prealpha.1_UCES00420(1).zip",
        "patch_v021": root / "upload/Size_Matters_60FPS_GLOBAL_EXPERIENCE_v0.2.1-prealpha.1_UCES00420(1).zip",
    }
    missing = [str(path) for path in exact.values() if not path.is_file()]
    if missing:
        raise FileNotFoundError("Fichiers requis absents :\n" + "\n".join(missing))
    return exact


def load_manifest(path: Path) -> tuple[dict[str, Any], bytes, bytes]:
    with ZipFile(path) as archive:
        member = next(name for name in archive.namelist() if name.endswith("patch_manifest.json"))
        manifest = json.loads(archive.read(member))
        experience_member = next(
            name for name in archive.namelist() if name.endswith("03_GLOBAL_60FPS_EXPERIENCE_PREALPHA.ini")
        )
        readme_member = next(name for name in archive.namelist() if name.endswith("README.md"))
        return manifest, archive.read(experience_member), archive.read(readme_member)


def load_modules(inputs: dict[str, Path]) -> tuple[list[ModuleSource], dict[str, Any]]:
    modules: list[ModuleSource] = []
    checks: dict[str, Any] = {}
    with ZipFile(inputs["bin_zip"]) as archive:
        bad = archive.testzip()
        checks["bin_zip_integrity"] = {"status": "PASS" if bad is None else "FAIL", "bad_member": bad or ""}
        frontend = archive.read("BIN/FRONTEND.PRX")
        modules.append(
            ModuleSource(
                key="FRONTEND",
                file_name="FRONTEND.PRX",
                module_index=0,
                level_name=LEVEL_NAMES[0],
                mode="frontend",
                source_container=inputs["bin_zip"].name,
                source_member="BIN/FRONTEND.PRX",
                data=frontend,
                runtime_base=LEVEL_RUNTIME_BASE,
                base_evidence="hypothèse du slot PRX commun; non observé dans les dumps fournis",
            )
        )
        for index in (1, 3, 4, 5, 6, 7, 8, 9, 10, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24):
            member = f"BIN/LEVEL_{index:02d}.PRX"
            mode = "multiplayer" if 16 <= index <= 20 else "level_variant" if index >= 15 else "singleplayer"
            modules.append(
                ModuleSource(
                    key=f"LEVEL_{index:02d}",
                    file_name=f"LEVEL_{index:02d}.PRX",
                    module_index=index,
                    level_name=LEVEL_NAMES[index],
                    mode=mode,
                    source_container=inputs["bin_zip"].name,
                    source_member=member,
                    data=archive.read(member),
                    runtime_base=LEVEL_RUNTIME_BASE,
                    base_evidence=(
                        "slot observé dynamiquement" if index == 1 else "slot commun confirmé par les profils multi-PRX"
                    ),
                )
            )
        archived_level2 = archive.read("LEVEL_02.PRX")
    clean_level2 = inputs["level2_clean"].read_bytes()
    checks["level2_clean_equals_bin_archive"] = {
        "status": "PASS" if clean_level2 == archived_level2 else "FAIL",
        "clean_sha256": sha256_bytes(clean_level2),
        "archive_sha256": sha256_bytes(archived_level2),
    }
    modules.append(
        ModuleSource(
            key="LEVEL_02",
            file_name="LEVEL_02.PRX",
            module_index=2,
            level_name=LEVEL_NAMES[2],
            mode="singleplayer",
            source_container=inputs["level2_clean"].name,
            source_member="",
            data=clean_level2,
            runtime_base=LEVEL_RUNTIME_BASE,
            base_evidence="slot 0x09139D00 observé dans RAM.dump",
        )
    )
    modules.extend(
        [
            ModuleSource(
                key="EBOOT",
                file_name="UCES00420_EBOOT.BIN",
                module_index=None,
                level_name="Exécutable principal",
                mode="core",
                source_container=inputs["eboot"].name,
                source_member="",
                data=inputs["eboot"].read_bytes(),
                runtime_base=EBOOT_RUNTIME_BASE,
                base_evidence="base 0x08804000 observée dans les deux dumps",
            ),
            ModuleSource(
                key="RCPM",
                file_name="RCPM.PRX",
                module_index=None,
                level_name="Module RCPM",
                mode="service_or_network",
                source_container=inputs["rcpm"].name,
                source_member="",
                data=inputs["rcpm"].read_bytes(),
                runtime_base=None,
                base_evidence="module non retrouvé de façon probante dans les deux captures RAM",
            ),
        ]
    )
    order = {"EBOOT": -2, "RCPM": -1, "FRONTEND": 0}
    modules.sort(key=lambda item: order.get(item.key, item.module_index if item.module_index is not None else 999))
    return modules, checks


def source_inventory(inputs: dict[str, Path]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    source_rows = []
    archive_rows = []
    for source_id, path in inputs.items():
        suffix = path.suffix.lower().lstrip(".")
        source_rows.append(
            {
                "source_id": source_id,
                "file_name": path.name,
                "relative_path": path.relative_to(path.parents[1]).as_posix() if len(path.parents) > 1 else path.name,
                "kind": suffix or "file",
                "size_bytes": path.stat().st_size,
                "sha256": sha256_file(path),
                "role": SOURCE_ROLES.get(path.name, "Source fournie"),
                "included_in_deliverable": "non — métadonnées uniquement",
            }
        )
        if suffix != "zip":
            continue
        with ZipFile(path) as archive:
            bad = archive.testzip()
            if bad is not None:
                raise RuntimeError(f"Archive corrompue {path.name}: {bad}")
            for info in archive.infolist():
                if info.is_dir():
                    continue
                digest, first = hash_zip_member(archive, info.filename)
                extension = Path(info.filename).suffix.lower().lstrip(".")
                archive_rows.append(
                    {
                        "archive": path.name,
                        "member": info.filename,
                        "kind": extension or "file",
                        "size_bytes": info.file_size,
                        "compressed_bytes": info.compress_size,
                        "crc32": f"0x{info.CRC:08X}",
                        "sha256": digest,
                        "magic_16_bytes": first[:16].hex(" ").upper(),
                    }
                )
    return source_rows, archive_rows


def relocation_map(elf: Elf32, target_section: str = ".text") -> dict[int, int]:
    return {
        int(row["rva"]): int(row["type"])
        for row in elf.relocations()
        if row["target_section"] == target_section
    }


def detect_prologues(elf: Elf32) -> list[int]:
    text = elf.by_name.get(".text")
    if text is None:
        return []
    output = []
    raw = elf.section_bytes(".text")
    for relative in range(0, len(raw) - 3, 4):
        word = struct.unpack_from("<I", raw, relative)[0]
        if word & 0xFFFF0000 == 0x27BD0000 and signed16(word & 0xFFFF) < 0:
            output.append(text.address + relative)
    return output


def scan_direct_calls(
    elf: Elf32,
    runtime_base: int | None,
    imports: list[dict[str, Any]],
    relocations_by_rva: dict[int, int],
) -> list[dict[str, Any]]:
    text = elf.by_name.get(".text")
    if text is None:
        return []
    import_stubs = {int(item["stub_rva"]): item for item in imports if item["kind"] == "function"}
    output = []
    raw = elf.section_bytes(".text")
    for relative in range(0, len(raw) - 3, 4):
        word = struct.unpack_from("<I", raw, relative)[0]
        if word >> 26 != 3:
            continue
        site_rva = text.address + relative
        relocation_type = relocations_by_rva.get(site_rva)
        encoded_target = (word & 0x03FFFFFF) << 2
        target_rva = encoded_target if relocation_type == 4 else None
        site_runtime = runtime_base + site_rva if runtime_base is not None else None
        if runtime_base is not None:
            if relocation_type == 4:
                target_runtime = runtime_base + encoded_target
            else:
                target_runtime = ((site_runtime + 4) & 0xF0000000) | encoded_target
        else:
            target_runtime = None
        imported = import_stubs.get(encoded_target) if relocation_type == 4 else None
        if imported is not None:
            target_kind = "import_stub"
            target_label = f"{imported['library']}:NID_0x{int(imported['nid']):08X}"
        elif relocation_type == 4 and text.address <= encoded_target < text.address + text.size:
            target_kind = "internal_text"
            target_label = ""
        elif relocation_type == 4:
            target_section = elf.section_for_vaddr(encoded_target)
            target_kind = f"internal_{target_section.name}" if target_section else "internal_unknown"
            target_label = ""
        else:
            target_kind = "absolute_or_unrelocated"
            target_label = ""
        output.append(
            {
                "site_rva": site_rva,
                "site_runtime": site_runtime,
                "file_offset": elf.file_offset(site_rva),
                "raw_word": word,
                "relocation_type": relocation_type,
                "target_rva": target_rva,
                "target_runtime": target_runtime,
                "target_kind": target_kind,
                "target_label": target_label,
            }
        )
    return output


def analyze_modules(
    modules: list[ModuleSource],
    manifest: dict[str, Any],
) -> dict[str, Any]:
    wrapper_patches = {
        int(item["module_index"]): int(item["address"], 16)
        for item in manifest["patches"]
        if item.get("layer") == "WRAPPER"
    }
    wrapper_expected = {}
    for item in manifest["patches"]:
        if item.get("layer") != "WRAPPER":
            continue
        match = re.search(r"(\d+) appelants", item.get("evidence", ""))
        wrapper_expected[int(item["module_index"])] = int(match.group(1)) if match else None

    module_rows = []
    section_rows = []
    relocation_summary = []
    import_rows = []
    export_rows = []
    call_rows = []
    target_rows = []
    function_rows = []
    wrapper_rows = []
    module_context: dict[str, dict[str, Any]] = {}

    for module in modules:
        elf = Elf32(module.data, module.file_name)
        info = elf.module_info()
        imports = elf.imports()
        exports = elf.exports()
        relocs = elf.relocations()
        text_relocs = {
            int(row["rva"]): int(row["type"])
            for row in relocs
            if row["target_section"] == ".text"
        }
        calls = scan_direct_calls(elf, module.runtime_base, imports, text_relocs)
        prologues = detect_prologues(elf)
        prologue_set = set(prologues)
        text = elf.by_name.get(".text")
        strong_entries = {elf.entry_point}
        strong_entries.update(
            int(call["target_rva"])
            for call in calls
            if call["target_kind"] == "internal_text" and call["target_rva"] is not None
        )
        strong_entries = {
            entry for entry in strong_entries if text and text.address <= entry < text.address + text.size
        }
        wrapper_inner = wrapper_patches.get(module.module_index) if module.module_index is not None else None
        wrapper_entry = wrapper_inner - WRAPPER_ENTRY_DELTA if wrapper_inner is not None else None
        wrapper_one_pass = wrapper_inner - WRAPPER_ONE_PASS_DELTA if wrapper_inner is not None else None
        if wrapper_entry is not None and module.runtime_base is not None:
            strong_entries.add(wrapper_entry - module.runtime_base)
            strong_entries.add(wrapper_one_pass - module.runtime_base)
        strong_sorted = sorted(strong_entries)
        owner_candidates = sorted(strong_entries | prologue_set)

        incoming = Counter(
            int(call["target_rva"])
            for call in calls
            if call["target_kind"] == "internal_text" and call["target_rva"] is not None
        )
        signature_by_rva = {}
        for entry in strong_sorted:
            window = normalized_code_window(elf, entry, text_relocs)
            signature = sha256_bytes(window) if window else ""
            signature_by_rva[entry] = signature
            function_rows.append(
                {
                    "module_key": module.key,
                    "module_index": "" if module.module_index is None else module.module_index,
                    "level": module.level_name,
                    "entry_rva": hex_or_blank(entry),
                    "entry_runtime": hex_or_blank(module.runtime_base + entry if module.runtime_base is not None else None),
                    "entry_file_offset": hex_or_blank(elf.file_offset(entry)),
                    "incoming_direct_calls": incoming.get(entry, 0),
                    "has_stack_prologue": "yes" if entry in prologue_set else "no",
                    "entry_evidence": "direct_call_target+prologue" if entry in prologue_set else "direct_call_target",
                    "normalized_96b_sha256": signature,
                }
            )

        wrapper_call_count = 0
        for call in calls:
            owner = None
            position = bisect.bisect_right(owner_candidates, int(call["site_rva"])) - 1
            if position >= 0:
                candidate = owner_candidates[position]
                if int(call["site_rva"]) - candidate <= 0x2000:
                    owner = candidate
            row = {
                "module_key": module.key,
                "module_index": "" if module.module_index is None else module.module_index,
                "level": module.level_name,
                "site_rva": hex_or_blank(int(call["site_rva"])),
                "site_runtime": hex_or_blank(call["site_runtime"]),
                "file_offset": hex_or_blank(call["file_offset"]),
                "raw_word": hex_or_blank(int(call["raw_word"])),
                "relocation": RELOCATION_NAMES.get(call["relocation_type"], call["relocation_type"] or ""),
                "target_rva": hex_or_blank(call["target_rva"]),
                "target_runtime": hex_or_blank(call["target_runtime"]),
                "target_kind": call["target_kind"],
                "target_label": call["target_label"],
                "owner_rva_heuristic": hex_or_blank(owner),
                "owner_runtime_heuristic": hex_or_blank(
                    module.runtime_base + owner if owner is not None and module.runtime_base is not None else None
                ),
            }
            if call["target_kind"] != "internal_text":
                call_rows.append(row)
            if wrapper_entry is None or call["target_runtime"] != wrapper_entry:
                continue
            wrapper_call_count += 1
            site_rva = int(call["site_rva"])
            context_parts = []
            for context_rva in range(max(text.address, site_rva - 8), min(text.address + text.size, site_rva + 16), 4):
                word = struct.unpack("<I", elf.read_vaddr(context_rva, 4))[0]
                runtime_site = module.runtime_base + context_rva if module.runtime_base is not None else None
                runtime_word = word
                if text_relocs.get(context_rva) == 4 and module.runtime_base is not None:
                    runtime_word = (word & 0xFC000000) | (
                        ((word & 0x03FFFFFF) + (module.runtime_base >> 2)) & 0x03FFFFFF
                    )
                marker = ">" if context_rva == site_rva else " "
                context_parts.append(
                    f"{marker}{hex_or_blank(runtime_site or context_rva)} {word:08X} {format_mips(runtime_word, runtime_site)}"
                )
            owner_window = normalized_code_window(elf, owner, text_relocs) if owner is not None else b""
            wrapper_rows.append(
                {
                    "module_key": module.key,
                    "module_index": module.module_index,
                    "level": module.level_name,
                    "callsite_runtime": hex_or_blank(call["site_runtime"]),
                    "callsite_rva": hex_or_blank(site_rva),
                    "file_offset": hex_or_blank(call["file_offset"]),
                    "wrapper_entry_runtime": hex_or_blank(wrapper_entry),
                    "wrapper_one_pass_runtime": hex_or_blank(wrapper_one_pass),
                    "owner_runtime_heuristic": hex_or_blank(
                        module.runtime_base + owner if owner is not None and module.runtime_base is not None else None
                    ),
                    "owner_rva_heuristic": hex_or_blank(owner),
                    "owner_signature_sha256": sha256_bytes(owner_window) if owner_window else "",
                    "instruction_context": " | ".join(context_parts),
                }
            )

        targets = defaultdict(list)
        for call in calls:
            target_key = (
                call["target_runtime"] if call["target_runtime"] is not None else call["target_rva"],
                call["target_kind"],
                call["target_label"],
            )
            targets[target_key].append(call)
        for (target, kind, label), target_calls in sorted(
            targets.items(), key=lambda item: (-len(item[1]), str(item[0]))
        ):
            target_rows.append(
                {
                    "module_key": module.key,
                    "module_index": "" if module.module_index is None else module.module_index,
                    "level": module.level_name,
                    "target": hex_or_blank(target),
                    "target_kind": kind,
                    "target_label": label,
                    "direct_call_count": len(target_calls),
                }
            )

        for item in imports:
            import_rows.append(
                {
                    "module_key": module.key,
                    "module_index": "" if module.module_index is None else module.module_index,
                    "level": module.level_name,
                    "library": item["library"],
                    "kind": item["kind"],
                    "ordinal": item["ordinal"],
                    "nid": f"0x{int(item['nid']):08X}",
                    "stub_rva": hex_or_blank(int(item["stub_rva"])),
                    "stub_runtime": hex_or_blank(
                        module.runtime_base + int(item["stub_rva"]) if module.runtime_base is not None else None
                    ),
                    "library_version": f"0x{int(item['library_version']):04X}",
                    "library_flags": f"0x{int(item['library_flags']):04X}",
                }
            )
        for item in exports:
            export_rows.append(
                {
                    "module_key": module.key,
                    "module_index": "" if module.module_index is None else module.module_index,
                    "level": module.level_name,
                    "library": item["library"],
                    "kind": item["kind"],
                    "ordinal": item["ordinal"],
                    "nid": f"0x{int(item['nid']):08X}",
                    "export_rva": hex_or_blank(int(item["export_rva"])),
                    "export_runtime": hex_or_blank(
                        module.runtime_base + int(item["export_rva"]) if module.runtime_base is not None else None
                    ),
                    "library_version": f"0x{int(item['library_version']):04X}",
                    "library_flags": f"0x{int(item['library_flags']):04X}",
                }
            )

        relocation_counts = Counter((item["target_section"], item["type"], item["type_name"]) for item in relocs)
        for (target_section, relocation_type, relocation_name), count in sorted(relocation_counts.items()):
            relocation_summary.append(
                {
                    "module_key": module.key,
                    "module_index": "" if module.module_index is None else module.module_index,
                    "target_section": target_section,
                    "relocation_type": relocation_type,
                    "relocation_name": relocation_name,
                    "count": count,
                }
            )
        for section in elf.sections:
            section_rows.append(
                {
                    "module_key": module.key,
                    "module_index": "" if module.module_index is None else module.module_index,
                    "section_index": section.index,
                    "section": section.name,
                    "type": f"0x{section.type:08X}",
                    "flags": f"0x{section.flags:08X}",
                    "rva": hex_or_blank(section.address),
                    "runtime_address": hex_or_blank(
                        module.runtime_base + section.address if module.runtime_base is not None and section.allocated else None
                    ),
                    "file_offset": hex_or_blank(section.offset),
                    "size_bytes": section.size,
                    "allocated": "yes" if section.allocated else "no",
                    "executable": "yes" if section.executable else "no",
                    "writable": "yes" if section.writable else "no",
                }
            )

        wad_strings = [
            value
            for value in find_ascii_strings(module.data)
            if re.search(r"ART[/\\]LEVELS[/\\].*\.mb\.wad", value, flags=re.IGNORECASE)
        ]
        wad_reference = wad_strings[0] if wad_strings else ""
        imported_libraries = sorted({item["library"] for item in imports})
        exported_libraries = sorted({item["library"] for item in exports})
        module_rows.append(
            {
                "module_key": module.key,
                "module_index": "" if module.module_index is None else module.module_index,
                "file_name": module.file_name,
                "module_info_name": info.get("name", ""),
                "level": module.level_name,
                "mode": module.mode,
                "source_container": module.source_container,
                "source_member": module.source_member,
                "full_size_bytes": len(module.data),
                "full_sha256": sha256_bytes(module.data),
                "text_size_bytes": text.size if text else 0,
                "text_sha256": sha256_bytes(elf.section_bytes(".text")) if text else "",
                "normalized_text_sha256": normalized_text_hash(elf, text_relocs) if text else "",
                "entry_rva": hex_or_blank(elf.entry_point),
                "runtime_base": hex_or_blank(module.runtime_base),
                "entry_runtime": hex_or_blank(
                    module.runtime_base + elf.entry_point if module.runtime_base is not None else None
                ),
                "memory_size_bytes": elf.memory_size,
                "runtime_end": hex_or_blank(
                    module.runtime_base + elf.memory_size if module.runtime_base is not None else None
                ),
                "base_evidence": module.base_evidence,
                "section_count": len(elf.sections),
                "relocation_count": len(relocs),
                "import_library_count": len(imported_libraries),
                "import_function_count": sum(1 for item in imports if item["kind"] == "function"),
                "export_library_count": len(exported_libraries),
                "export_function_count": sum(1 for item in exports if item["kind"] == "function"),
                "direct_jal_count": len(calls),
                "unique_direct_targets": len(targets),
                "strong_function_entries": len(strong_entries),
                "stack_prologue_candidates": len(prologues),
                "wrapper_entry_runtime": hex_or_blank(wrapper_entry),
                "wrapper_one_pass_runtime": hex_or_blank(wrapper_one_pass),
                "wrapper_inner_patch_runtime": hex_or_blank(wrapper_inner),
                "wrapper_direct_callers": wrapper_call_count if wrapper_inner is not None else "",
                "wrapper_expected_callers": wrapper_expected.get(module.module_index, ""),
                "wad_reference_in_prx": wad_reference,
                "import_libraries": "; ".join(imported_libraries),
            }
        )
        module_context[module.key] = {
            "source": module,
            "elf": elf,
            "relocations": relocs,
            "text_relocations": text_relocs,
            "calls": calls,
            "imports": imports,
            "exports": exports,
            "wad_reference": wad_reference,
            "signature_by_rva": signature_by_rva,
        }

    signature_groups = defaultdict(list)
    for row in function_rows:
        if row["normalized_96b_sha256"]:
            signature_groups[row["normalized_96b_sha256"]].append(row)
    group_rows = []
    group_number = 0
    for signature, members in sorted(signature_groups.items()):
        module_count = len({member["module_key"] for member in members})
        if module_count < 2:
            continue
        group_number += 1
        group_id = f"FSG-{group_number:05d}"
        for member in members:
            group_rows.append(
                {
                    "signature_group": group_id,
                    "module_count": module_count,
                    "occurrence_count": len(members),
                    "normalized_96b_sha256": signature,
                    "module_key": member["module_key"],
                    "module_index": member["module_index"],
                    "level": member["level"],
                    "entry_rva": member["entry_rva"],
                    "entry_runtime": member["entry_runtime"],
                    "incoming_direct_calls": member["incoming_direct_calls"],
                }
            )

    return {
        "modules": module_rows,
        "sections": section_rows,
        "relocations": relocation_summary,
        "imports": import_rows,
        "exports": export_rows,
        "calls": call_rows,
        "call_targets": target_rows,
        "functions": function_rows,
        "function_groups": group_rows,
        "wrapper_callers": wrapper_rows,
        "context": module_context,
        "wrapper_expected": wrapper_expected,
    }


def analyze_patches(
    manifest: dict[str, Any],
    module_context: dict[str, dict[str, Any]],
) -> tuple[list[dict[str, Any]], list[dict[str, Any]], list[dict[str, Any]]]:
    module_by_index = {
        context["source"].module_index: (key, context)
        for key, context in module_context.items()
        if context["source"].module_index is not None
    }
    eboot_context = module_context["EBOOT"]
    rows = []
    for number, patch in enumerate(manifest["patches"], start=1):
        index = int(patch["module_index"])
        address = int(patch["address"], 16)
        module_key, context = module_by_index[index]
        source: ModuleSource = context["source"]
        elf: Elf32 = context["elf"]
        rva = None
        file_offset = None
        section_name = patch.get("section", "")
        address_space = "unclassified"
        coordinate_evidence = ""
        if PSP_MEMORY_BASE <= address < EBOOT_RUNTIME_BASE:
            address_space = "low_memory_patch_arena"
            coordinate_evidence = "zone située avant la base EBOOT"
        elif EBOOT_RUNTIME_BASE <= address < EBOOT_RUNTIME_BASE + eboot_context["elf"].memory_size:
            address_space = "EBOOT"
            rva = address - EBOOT_RUNTIME_BASE
            file_offset = eboot_context["elf"].file_offset(rva)
            coordinate_evidence = "base EBOOT observée dans les deux dumps"
            if not section_name:
                section = eboot_context["elf"].section_for_vaddr(rva)
                section_name = section.name if section else ""
        elif source.runtime_base is not None and source.runtime_base <= address < source.runtime_base + elf.memory_size:
            address_space = "level_prx"
            rva = address - source.runtime_base
            file_offset = elf.file_offset(rva)
            coordinate_evidence = source.base_evidence
            if not section_name:
                section = elf.section_for_vaddr(rva)
                section_name = section.name if section else ""
        rows.append(
            {
                "patch_id": f"P-{number:04d}",
                "module_index": index,
                "module_key": module_key,
                "module": patch.get("module", source.file_name),
                "level": patch.get("level", source.level_name),
                "layer": patch.get("layer", ""),
                "category": patch.get("category", ""),
                "mechanic": patch.get("mechanic", ""),
                "source_address": patch.get("source_address", ""),
                "runtime_address": f"0x{address:08X}",
                "address_space": address_space,
                "rva": hex_or_blank(rva),
                "file_offset": hex_or_blank(file_offset),
                "section": section_name,
                "file_vanilla": patch.get("file_vanilla", ""),
                "runtime_vanilla": patch.get("runtime_vanilla", ""),
                "patched": patch.get("patched", ""),
                "kind": patch.get("kind", ""),
                "continuous": "yes" if patch.get("continuous") else "no",
                "is_hook": "yes" if patch.get("is_hook") else "no",
                "restore": "yes" if patch.get("restore") else "no",
                "weapon_id": patch.get("weapon_id", ""),
                "weapon_title": patch.get("weapon_title", ""),
                "score": patch.get("score", ""),
                "margin": patch.get("margin", ""),
                "evidence": patch.get("evidence", ""),
                "coordinate_evidence": coordinate_evidence,
            }
        )
    summary_counter = Counter(
        (row["module_index"], row["module_key"], row["level"], row["layer"], row["category"])
        for row in rows
    )
    summary_rows = [
        {
            "module_index": index,
            "module_key": module_key,
            "level": level,
            "layer": layer,
            "category": category,
            "patch_count": count,
        }
        for (index, module_key, level, layer, category), count in sorted(summary_counter.items())
    ]
    layer_counter = Counter(row["layer"] for row in rows)
    layer_rows = [{"layer": layer, "patch_count": count} for layer, count in sorted(layer_counter.items())]
    return rows, summary_rows, layer_rows


def extract_upstream_analysis(patch_zip: Path, output_tables: Path) -> list[dict[str, Any]]:
    copied = []
    with ZipFile(patch_zip) as archive:
        for member in archive.namelist():
            if "/analysis/" not in member or not member.lower().endswith((".csv", ".json", ".txt")):
                continue
            destination = output_tables / f"upstream_{Path(member).name}"
            destination.write_bytes(archive.read(member))
            copied.append(
                {
                    "source_member": member,
                    "output_file": destination.name,
                    "size_bytes": destination.stat().st_size,
                    "sha256": sha256_file(destination),
                }
            )
    return copied


def analyze_assets(
    inputs: dict[str, Path],
    module_context: dict[str, dict[str, Any]],
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    archives = [inputs["globalwad_zip"], inputs["hud_zip"], inputs["alllevels_zip"]]
    referenced_by_basename = defaultdict(list)
    for module_key, context in module_context.items():
        reference = context.get("wad_reference", "")
        if not reference:
            continue
        basename = re.split(r"[/\\]", reference)[-1].lower()
        referenced_by_basename[basename].append(module_key)
    asset_rows = []
    member_lookup: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for path in archives:
        with ZipFile(path) as archive:
            bad = archive.testzip()
            if bad is not None:
                raise RuntimeError(f"Archive d’assets corrompue {path.name}: {bad}")
            for info in archive.infolist():
                if info.is_dir():
                    continue
                extension = Path(info.filename).suffix.lower()
                if extension not in {".wad", ".pak", ".bin", ".w3d", ".png"}:
                    continue
                data = archive.read(info.filename)
                strings = find_ascii_strings(data)
                basename = Path(info.filename).name.lower()
                modules = referenced_by_basename.get(basename, [])
                row = {
                    "archive": path.name,
                    "member": info.filename,
                    "file_name": Path(info.filename).name,
                    "kind": extension.lstrip("."),
                    "size_bytes": len(data),
                    "compressed_bytes": info.compress_size,
                    "compression_ratio": round(info.compress_size / len(data), 4) if data else 0,
                    "crc32": f"0x{info.CRC:08X}",
                    "sha256": sha256_bytes(data),
                    "magic_16_bytes": data[:16].hex(" ").upper(),
                    "printable_string_count": len(strings),
                    "referenced_by_modules": "; ".join(modules),
                }
                asset_rows.append(row)
                member_lookup[basename].append(row)
    mapping_rows = []
    for module_key, context in module_context.items():
        source: ModuleSource = context["source"]
        reference = context.get("wad_reference", "")
        if not reference:
            continue
        basename = re.split(r"[/\\]", reference)[-1].lower()
        matches = member_lookup.get(basename, [])
        mapping_rows.append(
            {
                "module_key": module_key,
                "module_index": "" if source.module_index is None else source.module_index,
                "level": source.level_name,
                "prx_embedded_wad_path": reference,
                "matched_asset_count": len(matches),
                "matched_archive": matches[0]["archive"] if len(matches) == 1 else "",
                "matched_member": matches[0]["member"] if len(matches) == 1 else "",
                "matched_sha256": matches[0]["sha256"] if len(matches) == 1 else "",
                "status": "MATCH" if len(matches) == 1 else "AMBIGUOUS" if matches else "NOT_FOUND",
            }
        )
    return asset_rows, mapping_rows


def top_unrelocated_probes(elf: Elf32, count: int = 24) -> list[tuple[int, bytes]]:
    text = elf.by_name.get(".text")
    rel_section = elf.by_name.get(".rel.text")
    if text is None or rel_section is None:
        return []
    relocs = sorted(
        int(row["rva"])
        for row in elf.relocations()
        if row["target_section"] == ".text" and text.address <= int(row["rva"]) < text.address + text.size
    )
    gaps = []
    previous = text.address
    for address in relocs + [text.address + text.size]:
        if address - previous >= 192:
            gaps.append((address - previous, previous))
        previous = address + 4
    gaps.sort(reverse=True)
    output = []
    for _gap, address in gaps[:count]:
        output.append((address, elf.read_vaddr(address, 128)))
    return output


def verify_loaded_image(memory: bytes, elf: Elf32, runtime_base: int) -> tuple[int, int]:
    probes = top_unrelocated_probes(elf)
    matches = 0
    for rva, needle in probes:
        offset = runtime_base + rva - PSP_MEMORY_BASE
        if 0 <= offset <= len(memory) - len(needle) and memory[offset : offset + len(needle)] == needle:
            matches += 1
    return matches, len(probes)


def infer_loaded_base(memory: bytes, elf: Elf32) -> tuple[int | None, int]:
    counts: Counter[int] = Counter()
    for rva, needle in top_unrelocated_probes(elf, count=16):
        position = memory.find(needle)
        while position >= 0:
            base = PSP_MEMORY_BASE + position - rva
            if PSP_MEMORY_BASE <= base < PSP_MEMORY_BASE + len(memory) and base & 0xFF == 0:
                counts[base] += 1
            position = memory.find(needle, position + 1)
    if not counts:
        return None, 0
    base, score = counts.most_common(1)[0]
    return (base if score >= 3 else None), score


def analyze_memory(
    inputs: dict[str, Path],
    module_context: dict[str, dict[str, Any]],
    patch_rows: list[dict[str, Any]],
) -> tuple[list[dict[str, Any]], list[dict[str, Any]], list[dict[str, Any]], dict[str, Any]]:
    snapshots = [
        ("RAM_RYLLUS", inputs["ram_ryllus"]),
        ("RAM_POKITARU", inputs["ram_pokitaru"]),
    ]
    module_for_index = {
        context["source"].module_index: context
        for context in module_context.values()
        if context["source"].module_index is not None
    }
    eboot = module_context["EBOOT"]
    rcpm = module_context["RCPM"]
    snapshot_rows = []
    observation_rows = []
    region_rows = []
    checks = {}
    for snapshot_id, path in snapshots:
        memory = path.read_bytes()
        if len(memory) != PSP_MEMORY_SIZE:
            raise RuntimeError(f"{path.name}: taille RAM inattendue {len(memory)}")

        def read_u32(address: int) -> int:
            offset = address - PSP_MEMORY_BASE
            if not 0 <= offset <= len(memory) - 4:
                raise ValueError(f"Adresse hors dump 0x{address:08X}")
            return struct.unpack_from("<I", memory, offset)[0]

        module_index = read_u32(MODULE_INDEX_ADDRESS)
        active_context = module_for_index.get(module_index)
        active_key = active_context["source"].key if active_context else ""
        level = active_context["source"].level_name if active_context else "inconnu"
        eboot_matches, eboot_probe_count = verify_loaded_image(memory, eboot["elf"], EBOOT_RUNTIME_BASE)
        if active_context:
            level_matches, level_probe_count = verify_loaded_image(memory, active_context["elf"], LEVEL_RUNTIME_BASE)
        else:
            level_matches, level_probe_count = 0, 0
        rcpm_base, rcpm_score = infer_loaded_base(memory, rcpm["elf"])
        hook_word = read_u32(EBOOT_HOOK_ADDRESS)
        marker = read_u32(PROFILE_MARKER_ADDRESS)
        dispatcher_index = read_u32(DISPATCHER_INDEX_ADDRESS)
        dispatcher_state = read_u32(DISPATCHER_STATE_ADDRESS)
        dispatcher_count = read_u32(DISPATCHER_COUNT_ADDRESS)
        low_arena = memory[0 : EBOOT_RUNTIME_BASE - PSP_MEMORY_BASE]
        low_nonzero = sum(1 for value in low_arena if value)

        classification = Counter()
        for patch in patch_rows:
            if patch["module_index"] != module_index:
                continue
            address = int(patch["runtime_address"], 16)
            if not PSP_MEMORY_BASE <= address <= PSP_MEMORY_BASE + len(memory) - 4:
                continue
            actual = read_u32(address)
            vanilla_text = patch["runtime_vanilla"]
            patched_text = patch["patched"]
            vanilla = int(vanilla_text, 16) if vanilla_text else None
            patched = int(patched_text, 16) if patched_text else None
            if actual == vanilla == patched:
                state = "same_in_both_profiles"
            elif patched is not None and actual == patched:
                state = "patched_value_present"
            elif vanilla is not None and actual == vanilla:
                state = "vanilla_value_present"
            else:
                state = "other_runtime_value"
            classification[state] += 1
            observation_rows.append(
                {
                    "snapshot_id": snapshot_id,
                    "snapshot_file": path.name,
                    "module_index": module_index,
                    "module_key": active_key,
                    "patch_id": patch["patch_id"],
                    "layer": patch["layer"],
                    "mechanic": patch["mechanic"],
                    "runtime_address": patch["runtime_address"],
                    "dump_offset": hex_or_blank(address - PSP_MEMORY_BASE),
                    "actual_word": f"0x{actual:08X}",
                    "runtime_vanilla": vanilla_text,
                    "patched": patched_text,
                    "classification": state,
                }
            )
        snapshot_rows.append(
            {
                "snapshot_id": snapshot_id,
                "file_name": path.name,
                "size_bytes": len(memory),
                "sha256": sha256_bytes(memory),
                "memory_base": hex_or_blank(PSP_MEMORY_BASE),
                "memory_end": hex_or_blank(PSP_MEMORY_BASE + len(memory)),
                "module_index": module_index,
                "module_key": active_key,
                "level": level,
                "eboot_runtime_base": hex_or_blank(EBOOT_RUNTIME_BASE),
                "eboot_probe_matches": f"{eboot_matches}/{eboot_probe_count}",
                "level_runtime_base": hex_or_blank(LEVEL_RUNTIME_BASE),
                "level_probe_matches": f"{level_matches}/{level_probe_count}",
                "rcpm_detected_base": hex_or_blank(rcpm_base),
                "rcpm_best_probe_score": rcpm_score,
                "eboot_hook_word": f"0x{hook_word:08X}",
                "profile_marker": f"0x{marker:08X}",
                "dispatcher_index": f"0x{dispatcher_index:08X}",
                "dispatcher_state": f"0x{dispatcher_state:08X}",
                "dispatcher_count": f"0x{dispatcher_count:08X}",
                "low_arena_nonzero_bytes": low_nonzero,
                "patch_vanilla_words": classification["vanilla_value_present"],
                "patch_present_words": classification["patched_value_present"],
                "patch_other_words": classification["other_runtime_value"],
            }
        )
        region_rows.extend(
            [
                {
                    "snapshot_id": snapshot_id,
                    "region": "low_memory_before_eboot",
                    "start": hex_or_blank(PSP_MEMORY_BASE),
                    "end_exclusive": hex_or_blank(EBOOT_RUNTIME_BASE),
                    "size_bytes": EBOOT_RUNTIME_BASE - PSP_MEMORY_BASE,
                    "evidence": f"{low_nonzero} octets non nuls dans la capture",
                },
                {
                    "snapshot_id": snapshot_id,
                    "region": "EBOOT",
                    "start": hex_or_blank(EBOOT_RUNTIME_BASE),
                    "end_exclusive": hex_or_blank(EBOOT_RUNTIME_BASE + eboot["elf"].memory_size),
                    "size_bytes": eboot["elf"].memory_size,
                    "evidence": f"{eboot_matches}/{eboot_probe_count} sondes exactes",
                },
                {
                    "snapshot_id": snapshot_id,
                    "region": active_key or "level_slot",
                    "start": hex_or_blank(LEVEL_RUNTIME_BASE),
                    "end_exclusive": hex_or_blank(
                        LEVEL_RUNTIME_BASE + active_context["elf"].memory_size if active_context else None
                    ),
                    "size_bytes": active_context["elf"].memory_size if active_context else "",
                    "evidence": f"{level_matches}/{level_probe_count} sondes exactes",
                },
            ]
        )
        expected_module_index = 2 if snapshot_id == "RAM_RYLLUS" else 1
        checks[f"{snapshot_id.lower()}_module_index"] = {
            "status": "PASS" if module_index == expected_module_index else "FAIL",
            "value": module_index,
            "expected": expected_module_index,
        }
        checks[f"{snapshot_id.lower()}_eboot_base"] = {
            "status": "PASS" if eboot_matches == eboot_probe_count and eboot_probe_count else "FAIL",
            "probe_matches": eboot_matches,
            "probe_count": eboot_probe_count,
        }
        checks[f"{snapshot_id.lower()}_level_base"] = {
            "status": "PASS" if level_matches == level_probe_count and level_probe_count else "FAIL",
            "probe_matches": level_matches,
            "probe_count": level_probe_count,
        }
    return snapshot_rows, observation_rows, region_rows, checks


def table_html(
    rows: list[dict[str, Any]],
    columns: list[tuple[str, str]],
    table_id: str,
    searchable: bool = True,
) -> str:
    search = (
        f'<label class="table-search">Filtrer <input type="search" data-table="{html.escape(table_id)}" '
        'placeholder="Adresse, module, niveau…"></label>'
        if searchable
        else ""
    )
    header = "".join(f"<th>{html.escape(label)}</th>" for _key, label in columns)
    body_rows = []
    for row in rows:
        cells = []
        for key, _label in columns:
            value = row.get(key, "")
            display = "" if value is None else str(value)
            css = "mono" if "address" in key or key.endswith("_rva") or key.endswith("_runtime") or key in {
                "runtime_base", "runtime_end", "site", "target", "nid", "file_offset", "sha256"
            } else ""
            cells.append(f'<td class="{css}">{html.escape(display)}</td>')
        body_rows.append("<tr>" + "".join(cells) + "</tr>")
    return (
        search
        + f'<div class="table-wrap"><table id="{html.escape(table_id)}"><thead><tr>{header}</tr></thead>'
        + "<tbody>"
        + "".join(body_rows)
        + "</tbody></table></div>"
    )


def render_report(
    package_name: str,
    module_rows: list[dict[str, Any]],
    wrapper_rows: list[dict[str, Any]],
    patch_rows: list[dict[str, Any]],
    patch_layer_rows: list[dict[str, Any]],
    snapshot_rows: list[dict[str, Any]],
    asset_rows: list[dict[str, Any]],
    wad_map_rows: list[dict[str, Any]],
    import_rows: list[dict[str, Any]],
    function_group_rows: list[dict[str, Any]],
    validation_rows: list[dict[str, Any]],
) -> str:
    wrapper_counts = Counter((row["module_index"], row["module_key"], row["level"]) for row in wrapper_rows)
    wrapper_summary = [
        {
            "module_index": index,
            "module_key": key,
            "level": level,
            "callers": count,
            "wrapper_entry": next(
                row["wrapper_entry_runtime"]
                for row in wrapper_rows
                if row["module_index"] == index
            ),
            "one_pass": next(
                row["wrapper_one_pass_runtime"]
                for row in wrapper_rows
                if row["module_index"] == index
            ),
        }
        for (index, key, level), count in sorted(wrapper_counts.items())
    ]
    import_counts = Counter((row["module_key"], row["level"], row["library"]) for row in import_rows)
    import_summary = [
        {"module_key": key, "level": level, "library": library, "imports": count}
        for (key, level, library), count in sorted(import_counts.items())
    ]
    unique_function_groups = len({row["signature_group"] for row in function_group_rows})
    direct_calls = sum(int(row["direct_jal_count"]) for row in module_rows)
    status_counts = Counter(row["status"] for row in validation_rows)
    generated = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")

    modules_table = table_html(
        module_rows,
        [
            ("module_index", "Index"),
            ("module_key", "Module"),
            ("level", "Niveau / rôle"),
            ("runtime_base", "Base RAM"),
            ("text_size_bytes", ".text"),
            ("memory_size_bytes", "Mémoire"),
            ("direct_jal_count", "jal directs"),
            ("unique_direct_targets", "Cibles"),
            ("wrapper_direct_callers", "Wrapper"),
            ("wad_reference_in_prx", "WAD référencé"),
            ("base_evidence", "Preuve de base"),
        ],
        "modules-table",
    )
    memory_table = table_html(
        snapshot_rows,
        [
            ("snapshot_id", "Capture"),
            ("module_index", "Index"),
            ("module_key", "Module"),
            ("level", "Niveau"),
            ("eboot_probe_matches", "Sondes EBOOT"),
            ("level_probe_matches", "Sondes PRX"),
            ("eboot_hook_word", "Hook EBOOT"),
            ("profile_marker", "Marqueur"),
            ("patch_vanilla_words", "Mots vanilla"),
            ("patch_present_words", "Mots patchés"),
            ("patch_other_words", "Autres"),
        ],
        "memory-table",
        searchable=False,
    )
    wrapper_summary_table = table_html(
        wrapper_summary,
        [
            ("module_index", "Index"),
            ("module_key", "Module"),
            ("level", "Niveau"),
            ("callers", "Appelants directs"),
            ("wrapper_entry", "Entrée 2 passes"),
            ("one_pass", "Routine 1 passe"),
        ],
        "wrapper-summary-table",
    )
    wrapper_sites_table = table_html(
        wrapper_rows,
        [
            ("module_index", "Index"),
            ("level", "Niveau"),
            ("callsite_runtime", "Site RAM"),
            ("callsite_rva", "RVA"),
            ("file_offset", "Offset fichier"),
            ("owner_runtime_heuristic", "Fonction parente estimée"),
            ("owner_signature_sha256", "Signature parente"),
        ],
        "wrapper-sites-table",
    )
    patch_layers_table = table_html(
        patch_layer_rows,
        [("layer", "Couche"), ("patch_count", "Écritures logiques")],
        "patch-layer-table",
        searchable=False,
    )
    wad_table = table_html(
        wad_map_rows,
        [
            ("module_index", "Index"),
            ("module_key", "Module"),
            ("level", "Niveau"),
            ("prx_embedded_wad_path", "Chemin déclaré dans le PRX"),
            ("matched_member", "Fichier fourni"),
            ("status", "Statut"),
        ],
        "wad-map-table",
    )
    imports_table = table_html(
        import_summary,
        [
            ("module_key", "Module"),
            ("level", "Rôle"),
            ("library", "Bibliothèque importée"),
            ("imports", "NID / stubs"),
        ],
        "imports-table",
    )
    validation_table = table_html(
        validation_rows,
        [("check", "Contrôle"), ("status", "Résultat"), ("details", "Détails")],
        "validation-table",
        searchable=False,
    )

    return f"""<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Corpus de référence — Size Matters 60 FPS</title>
<style>
:root {{ color-scheme: light dark; --bg:#0e1320; --panel:#171f31; --panel2:#202b42; --text:#eef3ff; --muted:#aebbd2; --accent:#75c8ff; --accent2:#9ff0c6; --line:#34425e; --warn:#ffd27d; }}
* {{ box-sizing:border-box; }} body {{ margin:0; background:linear-gradient(150deg,#0b101b,#111a2b 45%,#101725); color:var(--text); font:15px/1.55 system-ui,-apple-system,Segoe UI,sans-serif; }}
header {{ padding:44px clamp(20px,5vw,76px) 34px; border-bottom:1px solid var(--line); background:radial-gradient(circle at 85% 10%,#19476a88,transparent 34%); }}
header h1 {{ max-width:1050px; margin:0 0 12px; font-size:clamp(30px,5vw,58px); line-height:1.05; }} header p {{ max-width:920px; color:var(--muted); font-size:17px; }}
nav {{ position:sticky; top:0; z-index:5; display:flex; gap:18px; overflow:auto; padding:12px clamp(20px,5vw,76px); background:#0e1320ee; backdrop-filter:blur(12px); border-bottom:1px solid var(--line); }}
nav a {{ color:var(--accent); text-decoration:none; white-space:nowrap; }} main {{ max-width:1500px; margin:auto; padding:34px clamp(16px,4vw,56px) 80px; }}
section {{ margin:0 0 46px; scroll-margin-top:70px; }} h2 {{ font-size:29px; margin:0 0 14px; }} h3 {{ margin-top:28px; }} p {{ max-width:1050px; }}
.cards {{ display:grid; grid-template-columns:repeat(auto-fit,minmax(170px,1fr)); gap:12px; margin:24px 0; }} .card {{ padding:18px; background:var(--panel); border:1px solid var(--line); border-radius:14px; }}
.card strong {{ display:block; color:var(--accent2); font-size:28px; }} .card span {{ color:var(--muted); }} .note {{ padding:16px 18px; border-left:4px solid var(--warn); background:#2b2518; border-radius:6px; max-width:1100px; }}
.formula {{ display:inline-block; padding:8px 11px; margin:4px 4px 4px 0; border:1px solid var(--line); border-radius:8px; background:var(--panel); font-family:ui-monospace,SFMono-Regular,Consolas,monospace; }}
.table-search {{ display:flex; gap:10px; align-items:center; max-width:620px; margin:12px 0; color:var(--muted); }} .table-search input {{ width:min(520px,70vw); padding:9px 11px; border-radius:8px; border:1px solid var(--line); background:var(--panel); color:var(--text); }}
.table-wrap {{ overflow:auto; max-height:620px; border:1px solid var(--line); border-radius:10px; background:var(--panel); }} table {{ width:100%; border-collapse:collapse; min-width:850px; }} th {{ position:sticky; top:0; background:var(--panel2); color:var(--accent); text-align:left; }} th,td {{ padding:8px 10px; border-bottom:1px solid var(--line); vertical-align:top; }} tbody tr:hover {{ background:#27334c; }} .mono {{ font-family:ui-monospace,SFMono-Regular,Consolas,monospace; white-space:nowrap; }}
.downloads {{ display:grid; grid-template-columns:repeat(auto-fit,minmax(280px,1fr)); gap:10px; }} .downloads a {{ display:block; padding:12px 14px; color:var(--accent); background:var(--panel); border:1px solid var(--line); border-radius:9px; text-decoration:none; }}
details {{ border:1px solid var(--line); border-radius:10px; padding:12px 14px; background:var(--panel); }} summary {{ cursor:pointer; color:var(--accent); font-weight:650; }} code {{ color:var(--accent2); }}
@media (prefers-color-scheme:light) {{ :root {{ --bg:#f5f7fb; --panel:#fff; --panel2:#e8eef8; --text:#15213a; --muted:#52627d; --accent:#006ba8; --accent2:#08734a; --line:#cdd7e8; --warn:#8a5a00; }} body {{ background:#f5f7fb; }} nav {{ background:#ffffffee; }} .note {{ background:#fff3d8; }} tbody tr:hover {{ background:#edf3fb; }} }}
</style>
</head>
<body>
<header>
  <h1>Corpus de référence UCES‑00420</h1>
  <p>Cette première cartographie relie les fichiers propres, les modules PRX, les WAD, les captures RAM et les 1 485 écritures logiques du profil expérience v0.2.1. Elle sert de vérité de travail reproductible pour analyser le wrapper, préparer un runtime PRX et éviter de confondre une adresse PPSSPP avec un offset de fichier.</p>
  <p>Généré le {generated}. Le paquet est volontairement dépourvu de PRX, WAD, EBOOT et dumps : il contient uniquement des empreintes, métadonnées, tables d’analyse et outils de reconstruction.</p>
</header>
<nav><a href="#definition">Définition</a><a href="#addresses">Adresses</a><a href="#modules">Modules</a><a href="#memory">RAM</a><a href="#wrapper">Wrapper</a><a href="#patches">Patchs</a><a href="#assets">WAD</a><a href="#imports">Imports</a><a href="#limits">Limites</a><a href="#downloads">Tables</a></nav>
<main>
<section id="definition">
  <h2>Ce que signifie « corpus de référence »</h2>
  <p>Le corpus est un état de référence immuable et vérifiable : chaque source possède une empreinte SHA‑256, un rôle et une provenance, tandis que chaque affirmation structurelle renvoie à un binaire, une capture ou une règle de conversion. Il ne prétend pas encore expliquer automatiquement le gameplay ; il fixe d’abord le terrain pour que toute hypothèse future puisse être reproduite et réfutée.</p>
  <div class="cards">
    <div class="card"><strong>{len(module_rows)}</strong><span>ELF / PRX cartographiés</span></div>
    <div class="card"><strong>{direct_calls:,}</strong><span>instructions <code>jal</code> recensées</span></div>
    <div class="card"><strong>{len(wrapper_rows)}</strong><span>appelants directs du wrapper</span></div>
    <div class="card"><strong>{len(patch_rows):,}</strong><span>écritures logiques documentées</span></div>
    <div class="card"><strong>{unique_function_groups:,}</strong><span>signatures communes multi‑modules</span></div>
    <div class="card"><strong>{len(asset_rows)}</strong><span>conteneurs d’assets indexés</span></div>
  </div>
</section>
<section id="addresses">
  <h2>Un même point, quatre coordonnées</h2>
  <p>Les modules de niveau observés sont chargés à <code>0x09139D00</code>, alors que le dump commence à <code>0x08800000</code>. Pour une adresse d’exécution donnée, le RVA identifie sa position dans le PRX ; l’offset fichier est ensuite obtenu par la section ELF concernée, car la règle « +0x74 » n’est valide que dans <code>.text</code>.</p>
  <div><span class="formula">RVA = adresse RAM − base du module</span><span class="formula">offset dump = adresse RAM − 0x08800000</span><span class="formula">offset fichier = section.offset + RVA − section.address</span></div>
  <p>Exemple Ryllus : <code>0x0914F2E4</code> devient le RVA <code>0x000155E4</code>, l’offset fichier <code>0x00015658</code> et l’offset de dump <code>0x0094F2E4</code>. Cette conversion est déjà appliquée à chaque ligne de <a href="tables/patches.csv">patches.csv</a>.</p>
</section>
<section id="modules"><h2>Carte des exécutables et modules</h2><p>Les bases de Pokitaru, Ryllus et de l’EBOOT sont prouvées directement par des fenêtres de code non relocalisées retrouvées dans les captures. Pour les autres niveaux, <code>0x09139D00</code> reste une inférence très solide issue du slot commun et des profils multi‑PRX, mais elle est signalée comme telle plutôt que présentée comme une observation dynamique.</p>{modules_table}</section>
<section id="memory"><h2>Captures RAM</h2><p><code>RAM.dump</code> est la capture Ryllus avec l’index 2, tandis que <code>RAM2.dump</code> est la capture Pokitaru avec l’index 1. Les deux conservent le hook EBOOT vanilla <code>0x0E201CD8</code> et n’exposent pas les marqueurs du dispatcher v0.2.1 ; Ryllus présente les 121 mots contrôlés en état vanilla, alors que Pokitaru contient déjà 10 valeurs équivalentes au profil patché et 112 valeurs vanilla.</p><p>La zone <code>0x08800000–0x08803FFF</code> est entièrement nulle dans ces deux instantanés. Cela documente l’état observé et explique pourquoi le dispatcher CWCheat peut y fonctionner, mais ne suffit pas à garantir que cette plage constitue une allocation sûre pour un PRX sur toutes les configurations.</p>{memory_table}</section>
<section id="wrapper">
  <h2>Wrapper commun : les « 55 appels » deviennent 493 sites identifiés</h2>
  <p>Le nombre dépend réellement du module : Pokitaru possède 55 appelants directs, Ryllus 57, et les variantes Giant Clank seulement 6. Le scanner cible l’entrée deux‑passes propre à chaque PRX et vérifie son résultat contre le nombre annoncé dans le manifeste v0.2.1 ; il ne compte pas les appels indirects via <code>jalr</code>, qui devront être observés dynamiquement.</p>
  {wrapper_summary_table}
  <details><summary>Afficher les {len(wrapper_rows)} sites d’appel</summary><p>La fonction parente est une estimation obtenue à partir des cibles directes et des prologues de pile MIPS. L’adresse du site, son RVA et son offset fichier sont en revanche des coordonnées exactes.</p>{wrapper_sites_table}</details>
</section>
<section id="patches"><h2>Couche sémantique des patchs connus</h2><p>Le manifeste v0.2.1 sert ici d’annotation, pas de vérité dynamique : il apporte la mécanique, la valeur vanilla, la valeur patchée et le niveau de preuve, puis le corpus recalcule les coordonnées dans les PRX propres. Les captures permettent en parallèle de relever la valeur réellement présente à chaque adresse de Pokitaru et Ryllus.</p>{patch_layers_table}</section>
<section id="assets"><h2>Relations PRX ↔ WAD</h2><p>Chaque association provient du chemin <code>ART/LEVELS/…/*.mb.wad</code> présent dans le PRX, puis d’une correspondance exacte avec le fichier fourni dans <code>ALLLEVELS</code>. Les WAD sont seulement indexés à ce stade : leur taille, leur empreinte, leur en‑tête et leur densité de chaînes sont connus, mais leurs structures internes ne sont pas encore interprétées comme des objets de gameplay.</p>{wad_table}</section>
<section id="imports"><h2>Imports, exports et frontières du moteur</h2><p>Les tables PSP <code>.lib.stub</code> et <code>.lib.ent</code> ont été décodées jusqu’aux NID et aux adresses de stub. Cette carte permet notamment de repérer les dépendances à <code>sceDisplay</code>, <code>sceRtc</code>, <code>ThreadManForUser</code> et <code>ModuleMgrForUser</code>, ce qui guidera un futur PRX pour les frontières de frame et le cycle de vie des modules.</p>{imports_table}</section>
<section id="limits">
  <h2>Ce que cette v0.1 ne prétend pas résoudre</h2>
  <div class="note"><p>Une signature commune prouve une forte parenté binaire, pas que la fonction est frame‑based. Le corpus réduit considérablement l’espace de recherche, mais la distinction entre delta time, compteur par frame, fixed step et logique événementielle nécessitera encore des traces comparées à 30 et 60 FPS.</p></div>
  <ul><li>Les appels indirects <code>jalr</code> ne sont pas attribués à une cible sans trace d’exécution.</li><li>Les frontières de fonctions sans symboles sont conservatrices et étiquetées comme heuristiques.</li><li>RCPM n’est pas retrouvé avec assez de sondes dans les deux captures ; sa base de chargement reste donc inconnue.</li><li>Les modules 3 à 24 partagent une base très probable, mais seuls LEVEL_01 et LEVEL_02 sont observés dans les dumps fournis.</li><li>Le format interne des WAD reste à rétro‑documenter avant de relier chaque objet de niveau à une routine précise.</li></ul>
  <h3>Contrôles de construction</h3><p>{status_counts.get('PASS', 0)} contrôles passent et {status_counts.get('FAIL', 0)} échouent. Un échec est bloquant pour la publication du paquet.</p>{validation_table}
</section>
<section id="downloads"><h2>Tables et données</h2><p>Le rapport est une vue de consultation ; les fichiers ci-dessous constituent la matière de travail pour Ghidra, Excel, Python ou un futur générateur de profils PRX. Les CSV utilisent UTF‑8 avec BOM afin de s’ouvrir correctement dans Excel français.</p>
<div class="downloads">
<a href="tables/module_inventory.csv">Inventaire des modules</a><a href="tables/wrapper_callers.csv">493 appelants du wrapper</a><a href="tables/patches.csv">1 485 patchs et coordonnées</a><a href="tables/memory_patch_observations.csv">Valeurs observées dans les dumps</a><a href="tables/imports.csv">Imports PSP et NID</a><a href="tables/exports.csv">Exports PSP et NID</a><a href="tables/direct_call_targets.csv">Cibles <code>jal</code> agrégées</a><a href="tables/function_signature_groups.csv">Fonctions communes entre PRX</a><a href="tables/module_wad_map.csv">Correspondances PRX↔WAD</a><a href="data/corpus.json">Corpus JSON consolidé</a><a href="data/validation.json">Résultats de validation</a><a href="METHODOLOGY.md">Méthode et niveaux de preuve</a>
</div></section>
</main>
<script>
for (const input of document.querySelectorAll('input[data-table]')) {{ input.addEventListener('input', () => {{ const q=input.value.toLowerCase(); const table=document.getElementById(input.dataset.table); for (const row of table.tBodies[0].rows) row.hidden=!row.textContent.toLowerCase().includes(q); }}); }}
</script>
</body></html>"""


def generate_readme(package_name: str, counts: dict[str, int]) -> str:
    return f"""# Corpus de référence — Ratchet & Clank: Size Matters UCES-00420

Ce paquet constitue la première base reproductible du chantier 60 FPS/PRX. Il relie les binaires propres, les captures RAM, les données de niveau et les patchs connus sans redistribuer les fichiers du jeu ; ouvrez `index.html` pour la vue guidée, puis utilisez les CSV ou `data/corpus.json` pour les analyses détaillées.

Le corpus recense {counts['modules']} exécutables ou modules, {counts['wrapper_callers']} appelants directs du wrapper, {counts['patches']} écritures logiques et {counts['assets']} conteneurs d’assets. Les coordonnées sont exprimées à la fois en adresse d’exécution, RVA, offset fichier ELF et offset dans le dump lorsqu’une capture correspondante existe.

## Contenu

- `index.html` : rapport autonome, filtres et synthèse pédagogique ;
- `tables/` : inventaires CSV complets, compatibles Excel ;
- `data/corpus.json` : données consolidées utiles aux scripts ;
- `data/validation.json` : contrôles reproductibles et résultats ;
- `tools/build_reference_corpus.py` : générateur sans dépendance tierce ;
- `METHODOLOGY.md` : règles de preuve, conversions d’adresses et limites.
- `MANIFEST_SHA256.txt` : empreinte de chaque fichier produit.

## Reconstruction

Le générateur attend l’arborescence `project_sources/` et `upload/` utilisée lors de cette analyse. Exécutez `python tools/build_reference_corpus.py --root <dossier-des-sources> --output <nouveau-dossier>` ; le programme s’arrête si une source manque, si une archive est corrompue ou si une correspondance critique diverge.

## Limite juridique et technique

Aucun PRX, EBOOT, WAD, PAK, dump RAM ou archive Ghidra du jeu n’est présent dans ce paquet. Les empreintes et métadonnées ne remplacent pas une copie légitime de la version européenne UCES-00420, et les résultats statiques ne prouvent pas encore qu’une mécanique donnée dépend du nombre de frames.
"""


def generate_methodology() -> str:
    return """# Méthode du corpus de référence

## Niveaux de preuve

**Observé dynamiquement** signifie qu’une valeur ou une fenêtre de code est lue directement dans un dump fourni. **Confirmé statiquement** signifie qu’elle est dérivée sans ambiguïté d’un ELF/PRX propre, d’une relocation ou d’une table PSP ; **inféré** désigne une correspondance de signature ou une hypothèse de slot commun qui devra encore être vérifiée dans une capture dédiée.

## Coordonnées

La mémoire utilisateur des dumps commence à `0x08800000`. L’EBOOT est observé à `0x08804000`, et les PRX LEVEL_01/LEVEL_02 à `0x09139D00` ; le RVA vaut `adresse_runtime - base_module`, tandis que l’offset de dump vaut `adresse_runtime - 0x08800000`. L’offset fichier est résolu par les sections ELF et ne doit pas être extrapolé au-delà de la section concernée.

## Cartographie MIPS

Le scanner décode les instructions `jal` directes et applique les relocations `R_MIPS_26` pour reconstruire leur cible d’exécution. Les appels indirects `jalr` sont conservés comme une limite explicite, car leur cible dépend d’un registre et ne peut pas être déterminée correctement sans analyse de flot ou trace d’exécution.

Les entrées de fonction fortes proviennent de l’entrypoint ou d’une cible de `jal`. Une fenêtre de 96 octets est normalisée en remplaçant les mots relocalisés par le type de relocation, puis hachée ; deux fenêtres identiques dans plusieurs modules forment un groupe de signature, mais ce groupe ne reçoit pas automatiquement un nom ni une fonction gameplay.

## Wrapper commun

Le manifeste v0.2.1 fournit l’instruction interne supprimant la seconde passe. L’entrée deux-passes est située 0x38 octets avant cette instruction et la routine une-passe 0x104 octets avant ; le scanner compte ensuite toutes les `jal` relocalisées qui ciblent exactement l’entrée deux-passes, puis exporte leurs quatre coordonnées.

## Assets et patchs

Les relations PRX↔WAD viennent des chemins ASCII embarqués dans les PRX et d’une correspondance exacte par nom de fichier dans les archives fournies. Les patchs sont importés depuis le manifeste v0.2.1, puis leurs RVA, sections et offsets sont recalculés contre les PRX propres ; le score du manifeste reste une annotation amont et n’est jamais remplacé par une certitude dynamique.
"""


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path.cwd(), help="Racine contenant project_sources et upload")
    parser.add_argument("--output", type=Path, required=True, help="Nouveau dossier de sortie")
    args = parser.parse_args()
    root = args.root.resolve()
    output = args.output.resolve()
    if output.exists() and any(output.iterdir()):
        raise RuntimeError(f"Le dossier de sortie n’est pas vide : {output}")
    output.mkdir(parents=True, exist_ok=True)
    tables = output / "tables"
    data_dir = output / "data"
    tools_dir = output / "tools"
    tables.mkdir(parents=True, exist_ok=True)
    data_dir.mkdir(parents=True, exist_ok=True)
    tools_dir.mkdir(parents=True, exist_ok=True)

    inputs = resolve_inputs(root)
    manifest, experience_ini, upstream_readme = load_manifest(inputs["patch_v021"])
    source_rows, archive_rows = source_inventory(inputs)
    modules, module_checks = load_modules(inputs)
    analysis = analyze_modules(modules, manifest)
    patch_rows, patch_summary_rows, patch_layer_rows = analyze_patches(manifest, analysis["context"])
    asset_rows, wad_map_rows = analyze_assets(inputs, analysis["context"])
    snapshot_rows, memory_observations, memory_regions, memory_checks = analyze_memory(
        inputs, analysis["context"], patch_rows
    )

    validation: dict[str, Any] = {}
    validation.update(module_checks)
    validation.update(memory_checks)
    validation["standalone_ini_equals_v021_experience"] = {
        "status": "PASS"
        if normalize_line_endings(inputs["ini"].read_bytes()) == normalize_line_endings(experience_ini)
        else "FAIL",
        "standalone_sha256": sha256_file(inputs["ini"]),
        "pack_member_normalized_sha256": sha256_bytes(normalize_line_endings(experience_ini)),
        "comparison": "normalisation BOM, CRLF et retour final",
    }
    eboot_elf: Elf32 = analysis["context"]["EBOOT"]["elf"]
    hook_rva = EBOOT_HOOK_ADDRESS - EBOOT_RUNTIME_BASE
    hook_offset = eboot_elf.file_offset(hook_rva)
    hook_word = struct.unpack_from("<I", analysis["context"]["EBOOT"]["source"].data, hook_offset)[0]
    hook_runtime_word = (hook_word & 0xFC000000) | (
        ((hook_word & 0x03FFFFFF) + (EBOOT_RUNTIME_BASE >> 2)) & 0x03FFFFFF
    )
    validation["eboot_hook_is_vanilla"] = {
        "status": "PASS" if hook_runtime_word == 0x0E201CD8 else "FAIL",
        "file_word": f"0x{hook_word:08X}",
        "runtime_word_after_R_MIPS_26": f"0x{hook_runtime_word:08X}",
        "file_offset": hex_or_blank(hook_offset),
    }
    module_hashes = {row["module_key"]: row for row in analysis["modules"]}
    validation["level15_level21_identical_text"] = {
        "status": "PASS"
        if module_hashes["LEVEL_15"]["text_sha256"] == module_hashes["LEVEL_21"]["text_sha256"]
        else "FAIL",
        "level15_text_sha256": module_hashes["LEVEL_15"]["text_sha256"],
        "level21_text_sha256": module_hashes["LEVEL_21"]["text_sha256"],
    }
    wrapper_actual = Counter(int(row["module_index"]) for row in analysis["wrapper_callers"])
    for index, expected in sorted(analysis["wrapper_expected"].items()):
        validation[f"wrapper_callers_level_{index:02d}"] = {
            "status": "PASS" if wrapper_actual[index] == expected else "FAIL",
            "actual": wrapper_actual[index],
            "expected": expected,
        }
    validation["all_prx_wad_references_resolved"] = {
        "status": "PASS" if wad_map_rows and all(row["status"] == "MATCH" for row in wad_map_rows) else "FAIL",
        "matches": sum(row["status"] == "MATCH" for row in wad_map_rows),
        "total": len(wad_map_rows),
    }
    for source_id in ("patch_socle", "patch_v020", "patch_v021", "alllevels_zip", "globalwad_zip", "hud_zip"):
        with ZipFile(inputs[source_id]) as archive:
            bad = archive.testzip()
        validation[f"zip_integrity_{source_id}"] = {
            "status": "PASS" if bad is None else "FAIL",
            "bad_member": bad or "",
        }
    if any(item["status"] != "PASS" for item in validation.values()):
        failures = [key for key, item in validation.items() if item["status"] != "PASS"]
        raise RuntimeError("Contrôles bloquants en échec : " + ", ".join(failures))

    validation_rows = [
        {
            "check": key,
            "status": item["status"],
            "details": "; ".join(f"{name}={value}" for name, value in item.items() if name != "status"),
        }
        for key, item in validation.items()
    ]
    upstream_rows = extract_upstream_analysis(inputs["patch_v021"], tables)

    url_rows = []
    for source_id in ("patch_urls", "tutorial_urls"):
        text = inputs[source_id].read_text(encoding="utf-8", errors="replace")
        for url in re.findall(r"https?://[^\s]+", text):
            url_rows.append({"source": inputs[source_id].name, "url": url, "role": SOURCE_ROLES[inputs[source_id].name]})
    url_rows.extend(
        [
            {"source": "conversation", "url": "https://www.gog.com/blog/preserving-sands-of-time/", "role": "Architecture de wrapper de référence"},
            {"source": "PSPSDK", "url": "https://github.com/pspdev/pspsdk/blob/master/tools/psp-prxgen.c", "role": "Référence primaire du format PRX/relocations"},
        ]
    )

    table_map = {
        "source_inventory.csv": source_rows,
        "archive_entries.csv": archive_rows,
        "module_inventory.csv": analysis["modules"],
        "elf_sections.csv": analysis["sections"],
        "relocation_summary.csv": analysis["relocations"],
        "imports.csv": analysis["imports"],
        "exports.csv": analysis["exports"],
        "external_direct_calls.csv": analysis["calls"],
        "direct_call_targets.csv": analysis["call_targets"],
        "function_entries.csv": analysis["functions"],
        "function_signature_groups.csv": analysis["function_groups"],
        "wrapper_callers.csv": analysis["wrapper_callers"],
        "patches.csv": patch_rows,
        "patch_summary.csv": patch_summary_rows,
        "patch_layers.csv": patch_layer_rows,
        "asset_inventory.csv": asset_rows,
        "module_wad_map.csv": wad_map_rows,
        "memory_snapshots.csv": snapshot_rows,
        "memory_patch_observations.csv": memory_observations,
        "memory_regions.csv": memory_regions,
        "references.csv": url_rows,
        "upstream_analysis_files.csv": upstream_rows,
        "validation.csv": validation_rows,
    }
    for filename, rows in table_map.items():
        write_csv(tables / filename, rows)

    compact_corpus = {
        "schema_version": "0.1.0",
        "game": "Ratchet & Clank: Size Matters",
        "game_id": "UCES-00420",
        "generated_utc": datetime.now(timezone.utc).isoformat(),
        "address_spaces": {
            "psp_memory_base": hex_or_blank(PSP_MEMORY_BASE),
            "psp_memory_size": hex_or_blank(PSP_MEMORY_SIZE),
            "eboot_runtime_base": hex_or_blank(EBOOT_RUNTIME_BASE),
            "level_runtime_base": hex_or_blank(LEVEL_RUNTIME_BASE),
            "module_index_address": hex_or_blank(MODULE_INDEX_ADDRESS),
        },
        "sources": source_rows,
        "modules": analysis["modules"],
        "memory_snapshots": snapshot_rows,
        "wrapper_callers": analysis["wrapper_callers"],
        "patches": patch_rows,
        "patch_layers": patch_layer_rows,
        "module_wad_map": wad_map_rows,
        "validation": validation,
        "references": url_rows,
        "full_tables": {name: f"../tables/{name}" for name in table_map},
    }
    write_json(data_dir / "corpus.json", compact_corpus)
    write_json(data_dir / "validation.json", validation)
    write_json(
        data_dir / "build_config.json",
        {
            "schema_version": "0.1.0",
            "required_sources": {key: path.relative_to(root).as_posix() for key, path in inputs.items()},
            "no_game_binaries_in_output": True,
        },
    )

    counts = {
        "modules": len(analysis["modules"]),
        "wrapper_callers": len(analysis["wrapper_callers"]),
        "patches": len(patch_rows),
        "assets": len(asset_rows),
    }
    package_name = output.name
    (output / "index.html").write_text(
        render_report(
            package_name,
            analysis["modules"],
            analysis["wrapper_callers"],
            patch_rows,
            patch_layer_rows,
            snapshot_rows,
            asset_rows,
            wad_map_rows,
            analysis["imports"],
            analysis["function_groups"],
            validation_rows,
        ),
        encoding="utf-8",
    )
    (output / "README.md").write_text(generate_readme(package_name, counts), encoding="utf-8")
    (output / "METHODOLOGY.md").write_text(generate_methodology(), encoding="utf-8")
    shutil.copy2(Path(__file__).resolve(), tools_dir / "build_reference_corpus.py")

    forbidden = {".prx", ".wad", ".dump", ".gzf", ".bin", ".pak", ".w3d", ".png"}
    offenders = [path.relative_to(output).as_posix() for path in output.rglob("*") if path.is_file() and path.suffix.lower() in forbidden]
    if offenders:
        raise RuntimeError("Binaire du jeu copié par erreur : " + ", ".join(offenders))
    manifest_lines = []
    for path in sorted(item for item in output.rglob("*") if item.is_file() and item.name != "MANIFEST_SHA256.txt"):
        manifest_lines.append(f"{sha256_file(path)}  {path.relative_to(output).as_posix()}")
    (output / "MANIFEST_SHA256.txt").write_text("\n".join(manifest_lines) + "\n", encoding="utf-8")
    result = {
        "status": "PASS",
        "output": str(output),
        "modules": counts["modules"],
        "wrapper_callers": counts["wrapper_callers"],
        "patches": counts["patches"],
        "assets": counts["assets"],
        "validation_checks": len(validation),
        "files": sum(1 for path in output.rglob("*") if path.is_file()),
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
