#!/usr/bin/env python3
"""Build the v0.3 binary-free semantic catalog underlying the v0.4 profiler.

The catalog starts from the reproducible UCES-00420 corpus builder.  It groups
the direct callers of the two-pass floating-point helper, estimates their
function boundaries, follows MIPS relocations to strings/constants, recovers
level object descriptors, relates known 60 FPS patches to the same functions,
and emits a profiling lookup table keyed by the MIPS return address ($ra).

No EBOOT, PRX, WAD, RAM dump, texture or other game binary is copied to the
output directory.  This historical generator deliberately does not reproduce
the maintained v0.4 PRX runtime, installer or in-situ protocol; see
``tools/README.md`` before regenerating anything.
"""

from __future__ import annotations

import argparse
import bisect
import csv
import hashlib
import html
import json
import math
import re
import shutil
import struct
import subprocess
import sys
import tempfile
from collections import Counter, defaultdict, deque
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterable


SCRIPT_DIR = Path(__file__).resolve().parent
for candidate in (SCRIPT_DIR, SCRIPT_DIR.parent / "corpus_builder"):
    if (candidate / "build_reference_corpus.py").is_file():
        sys.path.insert(0, str(candidate))
        break

import build_reference_corpus as base  # noqa: E402


SCHEMA_VERSION = "0.2.0"
CATALOG_TITLE = "Cartographie sémantique des familles du wrapper"
MAX_REVERSE_DEPTH = 3
PROFILER_TABLE_CAPACITY = 64
PROFILER_ENTRY_BYTES = 12


REGISTERS = (
    "zero", "at", "v0", "v1", "a0", "a1", "a2", "a3",
    "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7",
    "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7",
    "t8", "t9", "k0", "k1", "gp", "sp", "fp", "ra",
)


DOMAIN_RULES: tuple[tuple[str, tuple[str, ...]], ...] = (
    (
        "Armes et dégâts",
        (
            "weapon", "blaster", "blitz", "bomb", "agents", "beemine",
            "shield", "shockrocket", "crossbow", "flame", "laser", "acid",
            "mine", "cannon", "moot", "ryno", "turret", "projectile",
            "agentofdoom", "polarizer", "mutantcow", "mutantmadcow", "dart",
            "vehiclemissile",
        ),
    ),
    (
        "Cassables, caisses et boulons",
        ("breakable", "crate", "bolt", "titanium", "boxbreaker"),
    ),
    (
        "Joueur et locomotion",
        ("player", "hero", "ratchet", "jump", "glide", "grind", "hypershot"),
    ),
    (
        "Ennemis et acteurs",
        (
            "enemy", "robot", "shark", "crab", "boss", "npc", "creature",
            "butterfly", "moby", "clank", "botflinger", "microbot", "sprout",
            "razorback", "mungo", "pygmy", "soldier", "nurse", "skyboarder",
            "flyinghypo",
        ),
    ),
    (
        "Objets mobiles et mécanismes",
        (
            "door", "boat", "bridge", "crank", "movedobject", "platform",
            "elevator", "lift", "path", "curve", "trigger", "expandable",
            "dropship", "boulder", "column", "vehicle", "flyingcar",
        ),
    ),
    (
        "Particules et effets visuels",
        ("particle", "effect", "glow", "waterstream", "poison", "spark", "fx"),
    ),
    ("Caméra", ("camera",)),
    ("Animation", ("anim", "animation")),
    ("Collision et physique", ("collision", "physics", "dynagrid", "sweep")),
    ("Interface et HUD", ("hud", "menu", "interface", "quickselect")),
    ("Audio", ("sound", "audio", "snd_")),
)


TEST_RECIPES = {
    "Helper transversal / contextes multiples": (
        "Tracer d’abord dans plusieurs scènes représentatives sans changer la politique ; "
        "séparer ensuite les callsites si une même famille dessert des objets aux comportements différents."
    ),
    "Objet de niveau identifié — rôle à tester": (
        "Observer d’abord l’objet sans interaction, puis déclencher une seule action ; "
        "mesurer mouvement, durée, collisions et état final avant de choisir une politique."
    ),
    "Objet ou acteur parent — rôle à tester": (
        "Confirmer que le callsite s’active avec l’objet indiqué, puis isoler la propriété "
        "qui varie réellement avec le framerate."
    ),
    "Armes et dégâts": (
        "Mesurer cadence, consommation de munitions et dégâts sur une cible stable ; "
        "pour les effets continus, mesurer aussi les ticks et la durée résiduelle."
    ),
    "Cassables, caisses et boulons": (
        "Casser un objet isolé puis un groupe identique ; comparer délai de destruction, "
        "nombre de boulons et durée d’attraction."
    ),
    "Joueur et locomotion": (
        "Comparer sur une trajectoire reproductible distance, hauteur, durée du saut et "
        "retour à l’état neutre à 30 puis 60 FPS."
    ),
    "Ennemis et acteurs": (
        "Chronométrer déplacement, délai d’acquisition, cadence d’attaque et récupération "
        "sur le même ennemi sans le tuer trop vite."
    ),
    "Objets mobiles et mécanismes": (
        "Chronométrer un cycle complet et relever les positions de début, milieu et fin ; "
        "tester également la reprise après pause ou éloignement."
    ),
    "Particules et effets visuels": (
        "Comparer durée d’émission, durée de vie et vitesse apparente sans utiliser le rendu "
        "comme preuve d’un changement de logique gameplay."
    ),
    "Caméra": (
        "Comparer temps de recentrage, amplitude et vitesse angulaire avec la même entrée "
        "analogique enregistrée."
    ),
    "Animation": (
        "Mesurer la durée de l’animation et vérifier séparément les fenêtres d’événement, "
        "collisions et transitions d’état."
    ),
    "Collision et physique": (
        "Répéter la même collision à vitesse contrôlée ; comparer pénétration, rebond, "
        "correction de position et stabilité sur plusieurs secondes."
    ),
    "Interface et HUD": (
        "Comparer clignotement, interpolation et durée des transitions sans conclure sur la "
        "simulation principale."
    ),
    "Audio": (
        "Vérifier fréquence de déclenchement et durée sans modifier le mixage ; les appels "
        "audio peuvent seulement accompagner une logique temporelle située ailleurs."
    ),
    "Indéterminé": (
        "Tracer le compteur par scène, puis provoquer une seule action à la fois afin de "
        "distinguer appel par frame, tick fixe et appel événementiel."
    ),
}


@dataclass(frozen=True)
class StringRecord:
    start: int
    end: int
    section: str
    text: str
    kind: str


@dataclass(frozen=True)
class AddressReference:
    site_rva: int
    hi_rva: int
    target_rva: int
    instruction: int
    opcode: int
    section: str


@dataclass
class FunctionModel:
    start: int
    end: int
    incoming: int
    has_prologue: bool
    calls: list[dict[str, Any]]
    references: list[AddressReference]


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def as_hex(value: int | None, width: int = 8) -> str:
    return "" if value is None else f"0x{value:0{width}X}"


def parse_hex(value: str | int | None) -> int | None:
    if value is None or value == "":
        return None
    if isinstance(value, int):
        return value
    return int(value, 16)


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str] | None = None) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fields: list[str] = list(fieldnames or [])
    seen: set[str] = set(fields)
    for row in rows:
        for key in row:
            if key not in seen:
                fields.append(key)
                seen.add(key)
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def classify_string(text: str) -> str:
    lower = text.lower()
    if re.search(r"[a-z]:[/\\].*\.cpp$", lower) or lower.endswith((".cpp", ".c", ".h")):
        return "source_path"
    if "/" in text or "\\" in text:
        return "asset_or_path"
    if re.fullmatch(r"[A-Za-z_~][A-Za-z0-9_:@<>~]{3,}", text):
        if "_" in text or re.search(r"[a-z][A-Z]", text):
            return "symbolic_name"
    if ";" in text and any(token in text for token in ("f32", "u32", "MobyLink", "VEC", "Toggle")):
        return "pvar_schema"
    return "message_or_literal"


def collect_strings(elf: base.Elf32) -> list[StringRecord]:
    records: list[StringRecord] = []
    pattern = re.compile(rb"[\x20-\x7E]{4,}")
    for section_name in (".rodata", ".data"):
        section = elf.by_name.get(section_name)
        if section is None:
            continue
        raw = elf.section_bytes(section_name)
        for match in pattern.finditer(raw):
            text = match.group().decode("ascii", errors="replace")
            records.append(
                StringRecord(
                    start=section.address + match.start(),
                    end=section.address + match.end(),
                    section=section_name,
                    text=text,
                    kind=classify_string(text),
                )
            )
    return sorted(records, key=lambda item: item.start)


def gpr_written(word: int) -> int | None:
    opcode = word >> 26
    rt = (word >> 16) & 31
    rd = (word >> 11) & 31
    function = word & 0x3F
    if opcode == 0:
        if function in (8, 12, 13, 16, 17, 18, 19, 24, 25, 26, 27):
            return None
        return rd or None
    if opcode == 3:
        return 31
    if opcode in (1, 2, 4, 5, 6, 7, 0x28, 0x29, 0x2A, 0x2B, 0x2E, 0x30, 0x31, 0x32, 0x38, 0x39, 0x3A):
        return None
    return rt or None


def collect_address_references(elf: base.Elf32) -> list[AddressReference]:
    relocations = {
        int(item["rva"]): int(item["type"])
        for item in elf.relocations()
        if item["target_section"] == ".text"
    }
    text = elf.by_name.get(".text")
    if text is None:
        return []
    output: list[AddressReference] = []
    for lo_rva, relocation_type in sorted(relocations.items()):
        if relocation_type != 6:
            continue
        word = elf.read_u32(lo_rva)
        source_register = (word >> 21) & 31
        low = base.signed16(word & 0xFFFF)
        chosen: tuple[int, int] | None = None
        for hi_rva in range(lo_rva - 4, max(text.address - 4, lo_rva - 0x400), -4):
            if relocations.get(hi_rva) != 5:
                continue
            hi_word = elf.read_u32(hi_rva)
            if hi_word >> 26 != 15 or ((hi_word >> 16) & 31) != source_register:
                continue
            target = (((hi_word & 0xFFFF) << 16) + low) & 0xFFFFFFFF
            section = elf.section_for_vaddr(target)
            if section is not None and section.allocated:
                chosen = (hi_rva, target)
                break
        if chosen is None:
            continue
        hi_rva, target = chosen
        target_section = elf.section_for_vaddr(target)
        output.append(
            AddressReference(
                site_rva=lo_rva,
                hi_rva=hi_rva,
                target_rva=target,
                instruction=word,
                opcode=word >> 26,
                section=target_section.name if target_section else "",
            )
        )
    return output


def direct_call_target(word: int) -> int | None:
    return (word & 0x03FFFFFF) << 2 if word >> 26 == 3 else None


def function_candidates(context: dict[str, Any], wrapper_rows: list[dict[str, Any]]) -> list[int]:
    elf: base.Elf32 = context["elf"]
    text = elf.by_name[".text"]
    entries = {elf.entry_point}
    entries.update(base.detect_prologues(elf))
    entries.update(
        int(call["target_rva"])
        for call in context["calls"]
        if call["target_kind"] == "internal_text" and call["target_rva"] is not None
    )
    entries.update(
        int(row["owner_rva_heuristic"], 16)
        for row in wrapper_rows
        if row.get("owner_rva_heuristic")
    )
    return sorted(entry for entry in entries if text.address <= entry < text.address + text.size)


def owner_for_site(candidates: list[int], site: int) -> int | None:
    index = bisect.bisect_right(candidates, site) - 1
    return candidates[index] if index >= 0 else None


def build_function_models(
    context: dict[str, Any],
    wrapper_rows: list[dict[str, Any]],
    references: list[AddressReference],
) -> tuple[dict[int, FunctionModel], list[int]]:
    elf: base.Elf32 = context["elf"]
    text = elf.by_name[".text"]
    candidates = function_candidates(context, wrapper_rows)
    prologues = set(base.detect_prologues(elf))
    incoming = Counter(
        int(call["target_rva"])
        for call in context["calls"]
        if call["target_kind"] == "internal_text" and call["target_rva"] is not None
    )
    calls_by_owner: dict[int, list[dict[str, Any]]] = defaultdict(list)
    for call in context["calls"]:
        owner = owner_for_site(candidates, int(call["site_rva"]))
        if owner is not None:
            calls_by_owner[owner].append(call)
    refs_by_owner: dict[int, list[AddressReference]] = defaultdict(list)
    for reference in references:
        owner = owner_for_site(candidates, reference.site_rva)
        if owner is not None:
            refs_by_owner[owner].append(reference)
    models: dict[int, FunctionModel] = {}
    for index, start in enumerate(candidates):
        end = candidates[index + 1] if index + 1 < len(candidates) else text.address + text.size
        models[start] = FunctionModel(
            start=start,
            end=end,
            incoming=incoming.get(start, 0),
            has_prologue=start in prologues,
            calls=calls_by_owner.get(start, []),
            references=refs_by_owner.get(start, []),
        )
    return models, candidates


def find_string(strings: list[StringRecord], starts: list[int], address: int) -> StringRecord | None:
    index = bisect.bisect_right(starts, address) - 1
    if index >= 0 and strings[index].start <= address < strings[index].end:
        return strings[index]
    return None


def read_c_string_safe(elf: base.Elf32, address: int, limit: int = 1024) -> str:
    try:
        value = elf.read_c_string(address, limit)
    except (ValueError, UnicodeDecodeError):
        return ""
    if not value or any(ord(char) < 9 or (13 < ord(char) < 32) for char in value):
        return ""
    return value


def recover_object_descriptors(elf: base.Elf32) -> tuple[list[dict[str, Any]], dict[int, list[dict[str, Any]]]]:
    relocations = {
        int(item["rva"]): int(item["type"])
        for item in elf.relocations()
        if item["target_section"] == ".data"
    }
    descriptors: list[dict[str, Any]] = []
    by_callback: dict[int, list[dict[str, Any]]] = defaultdict(list)
    data = elf.by_name.get(".data")
    text = elf.by_name.get(".text")
    if data is None or text is None:
        return descriptors, by_callback
    for address in sorted(relocations):
        if relocations[address] != 2:
            continue
        name_pointer = elf.read_u32(address)
        name_section = elf.section_for_vaddr(name_pointer)
        if name_section is None or name_section.name != ".rodata":
            continue
        name = read_c_string_safe(elf, name_pointer, 96)
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]{2,63}", name):
            continue
        callbacks: list[int] = []
        cursor = address + 4
        while cursor <= address + 0x28 and relocations.get(cursor) == 2:
            target = elf.read_u32(cursor)
            if not (text.address <= target < text.address + text.size):
                break
            callbacks.append(target)
            cursor += 4
        if len(callbacks) < 2:
            continue
        pvar_schema = ""
        for probe in range(cursor, min(cursor + 0x20, data.address + data.size), 4):
            if relocations.get(probe) != 2:
                continue
            pointer = elf.read_u32(probe)
            section = elf.section_for_vaddr(pointer)
            if section is None or section.name != ".data":
                continue
            candidate = read_c_string_safe(elf, pointer, 700)
            if ";" in candidate or any(token in candidate for token in ("MobyLink", "f32", "u32", "VEC")):
                pvar_schema = candidate
                break
        descriptor = {
            "descriptor_rva": address,
            "object_name_rva": name_pointer,
            "object_name": name,
            "callbacks": callbacks,
            "pvar_schema": pvar_schema,
        }
        descriptors.append(descriptor)
        for ordinal, callback in enumerate(callbacks):
            by_callback[callback].append(
                {
                    "object_name": name,
                    "descriptor_rva": address,
                    "callback_ordinal": ordinal,
                    "pvar_schema": pvar_schema,
                }
            )
    return descriptors, by_callback


def build_reverse_call_graph(
    models: dict[int, FunctionModel], candidates: list[int]
) -> dict[int, set[int]]:
    reverse: dict[int, set[int]] = defaultdict(set)
    for caller, model in models.items():
        for call in model.calls:
            if call["target_kind"] != "internal_text" or call["target_rva"] is None:
                continue
            target = owner_for_site(candidates, int(call["target_rva"]))
            if target is not None:
                reverse[target].add(caller)
    return reverse


def object_ancestors(
    start: int,
    reverse_graph: dict[int, set[int]],
    descriptor_by_callback: dict[int, list[dict[str, Any]]],
    max_depth: int = MAX_REVERSE_DEPTH,
) -> list[dict[str, Any]]:
    found: dict[tuple[str, int], dict[str, Any]] = {}
    queue = deque([(start, 0, (start,))])
    visited = {start: 0}
    while queue:
        node, depth, path = queue.popleft()
        for descriptor in descriptor_by_callback.get(node, []):
            key = (descriptor["object_name"], node)
            candidate = {
                **descriptor,
                "distance": depth,
                "callback_rva": node,
                "path": path,
            }
            previous = found.get(key)
            if previous is None or depth < previous["distance"]:
                found[key] = candidate
        if depth >= max_depth:
            continue
        for parent in sorted(reverse_graph.get(node, set())):
            next_depth = depth + 1
            if visited.get(parent, 999) <= next_depth:
                continue
            visited[parent] = next_depth
            queue.append((parent, next_depth, (parent,) + path))
    return sorted(found.values(), key=lambda item: (item["distance"], item["object_name"], item["callback_rva"]))


def embedded_float_constants(elf: base.Elf32, model: FunctionModel, text_relocations: dict[int, int]) -> list[float]:
    values: set[float] = set()
    for address in range(model.start, model.end, 4):
        word = elf.read_u32(address)
        if word >> 26 != 15 or text_relocations.get(address) == 5:
            continue
        bits = (word & 0xFFFF) << 16
        value = struct.unpack("<f", struct.pack("<I", bits))[0]
        if math.isfinite(value) and (value == 0.0 or 1e-7 <= abs(value) <= 1e6):
            values.add(round(value, 9))
    return sorted(values, key=lambda value: (abs(value), value))[:24]


def referenced_float_constants(elf: base.Elf32, model: FunctionModel) -> list[dict[str, Any]]:
    output: list[dict[str, Any]] = []
    seen: set[tuple[int, int]] = set()
    for reference in model.references:
        if reference.opcode != 0x31 or reference.target_rva % 4:
            continue
        try:
            bits = elf.read_u32(reference.target_rva)
        except ValueError:
            continue
        value = struct.unpack("<f", struct.pack("<I", bits))[0]
        if not math.isfinite(value) or (value != 0.0 and not 1e-9 <= abs(value) <= 1e9):
            continue
        key = (reference.target_rva, bits)
        if key in seen:
            continue
        seen.add(key)
        output.append(
            {
                "site_rva": reference.site_rva,
                "constant_rva": reference.target_rva,
                "bits": bits,
                "value": value,
            }
        )
    return output


def instruction_metrics(elf: base.Elf32, model: FunctionModel) -> dict[str, int]:
    metrics = Counter()
    for address in range(model.start, model.end, 4):
        word = elf.read_u32(address)
        opcode = word >> 26
        metrics["instructions"] += 1
        if opcode == 0x11:
            metrics["cop1"] += 1
            function = word & 0x3F
            if function in (0, 1, 2, 3, 4, 5, 6, 7):
                metrics["fp_arithmetic"] += 1
            elif 0x30 <= function <= 0x3F:
                metrics["fp_compare"] += 1
        if opcode in (0x31, 0x39):
            metrics["fp_memory"] += 1
        if opcode in (1, 4, 5, 6, 7) or (opcode == 0x11 and ((word >> 21) & 31) == 8):
            metrics["branches"] += 1
            target = address + 4 + (base.signed16(word & 0xFFFF) << 2)
            if target < address:
                metrics["backward_branches"] += 1
        if opcode == 2:
            metrics["jumps"] += 1
        if opcode == 3:
            metrics["direct_calls"] += 1
        if word == 0x03E00008:
            metrics["return_sites"] += 1
    return dict(metrics)


def normalized_function_hash(elf: base.Elf32, model: FunctionModel, text_relocations: dict[int, int]) -> str:
    raw = bytearray(elf.read_vaddr(model.start, model.end - model.start))
    for relative in range(0, len(raw), 4):
        address = model.start + relative
        relocation_type = text_relocations.get(address)
        if relocation_type is not None:
            struct.pack_into("<I", raw, relative, 0xF0000000 | relocation_type)
    return sha256_bytes(bytes(raw))


def format_float(value: float) -> str:
    return f"{value:.9g}"


def decode_mips(word: int, site: int) -> str:
    opcode = word >> 26
    rs = (word >> 21) & 31
    rt = (word >> 16) & 31
    rd = (word >> 11) & 31
    sa = (word >> 6) & 31
    function = word & 0x3F
    immediate = word & 0xFFFF
    if word == 0:
        return "nop"
    if opcode == 0:
        names = {
            0x00: "sll", 0x02: "srl", 0x03: "sra", 0x04: "sllv", 0x06: "srlv", 0x07: "srav",
            0x21: "addu", 0x23: "subu", 0x24: "and", 0x25: "or", 0x26: "xor", 0x27: "nor",
            0x2A: "slt", 0x2B: "sltu",
        }
        if function == 8:
            return f"jr ${REGISTERS[rs]}"
        if function == 9:
            return f"jalr ${REGISTERS[rd]}, ${REGISTERS[rs]}"
        if function in (0, 2, 3):
            return f"{names[function]} ${REGISTERS[rd]}, ${REGISTERS[rt]}, {sa}"
        if function in names:
            return f"{names[function]} ${REGISTERS[rd]}, ${REGISTERS[rs]}, ${REGISTERS[rt]}"
    if opcode in (2, 3):
        target = ((site + 4) & 0xF0000000) | ((word & 0x03FFFFFF) << 2)
        return f"{'jal' if opcode == 3 else 'j'} 0x{target:08X}"
    if opcode in (4, 5, 6, 7):
        target = site + 4 + (base.signed16(immediate) << 2)
        mnemonic = {4: "beq", 5: "bne", 6: "blez", 7: "bgtz"}[opcode]
        if opcode in (4, 5):
            return f"{mnemonic} ${REGISTERS[rs]}, ${REGISTERS[rt]}, 0x{target:08X}"
        return f"{mnemonic} ${REGISTERS[rs]}, 0x{target:08X}"
    if opcode in (8, 9, 10, 11, 12, 13, 14, 15):
        mnemonic = {8: "addi", 9: "addiu", 10: "slti", 11: "sltiu", 12: "andi", 13: "ori", 14: "xori", 15: "lui"}[opcode]
        if opcode == 15:
            return f"lui ${REGISTERS[rt]}, 0x{immediate:04X}"
        value = immediate if opcode in (12, 13, 14) else base.signed16(immediate)
        return f"{mnemonic} ${REGISTERS[rt]}, ${REGISTERS[rs]}, {value}"
    memory_names = {
        0x20: "lb", 0x21: "lh", 0x23: "lw", 0x24: "lbu", 0x25: "lhu",
        0x28: "sb", 0x29: "sh", 0x2B: "sw", 0x31: "lwc1", 0x39: "swc1",
    }
    if opcode in memory_names:
        target_register = f"$f{rt}" if opcode in (0x31, 0x39) else f"${REGISTERS[rt]}"
        return f"{memory_names[opcode]} {target_register}, {base.signed16(immediate)}(${REGISTERS[rs]})"
    if opcode == 0x11:
        fmt = rs
        ft = rt
        fs = (word >> 11) & 31
        fd = (word >> 6) & 31
        if fmt == 8:
            target = site + 4 + (base.signed16(immediate) << 2)
            return f"{'bc1t' if rt & 1 else 'bc1f'} 0x{target:08X}"
        if fmt == 0:
            return f"mfc1 ${REGISTERS[rt]}, $f{fs}"
        if fmt == 4:
            return f"mtc1 ${REGISTERS[rt]}, $f{fs}"
        if fmt == 16:
            names = {0: "add.s", 1: "sub.s", 2: "mul.s", 3: "div.s", 4: "sqrt.s", 5: "abs.s", 6: "mov.s", 7: "neg.s"}
            if function in names:
                if function in (4, 5, 6, 7):
                    return f"{names[function]} $f{fd}, $f{fs}"
                return f"{names[function]} $f{fd}, $f{fs}, $f{ft}"
            if 0x30 <= function <= 0x3F:
                compare = {0x32: "c.eq.s", 0x3C: "c.lt.s", 0x3E: "c.le.s"}.get(function, f"c.0x{function:02X}.s")
                return f"{compare} $f{fs}, $f{ft}"
    return f".word 0x{word:08X}"


def disassembly_window(
    elf: base.Elf32,
    center: int,
    runtime_base: int,
    before: int = 4,
    after: int = 5,
) -> str:
    text = elf.by_name[".text"]
    lines: list[str] = []
    start = max(text.address, center - before * 4)
    end = min(text.address + text.size, center + (after + 1) * 4)
    for address in range(start, end, 4):
        word = elf.read_u32(address)
        marker = ">" if address == center else " "
        runtime = runtime_base + address
        display_word = word
        line = decode_mips(display_word, runtime)
        lines.append(f"{marker} 0x{runtime:08X}  {word:08X}  {line}")
    return "\n".join(lines)


def semantic_domains(tokens: Iterable[str], patch_layers: Iterable[str]) -> tuple[list[str], list[str]]:
    evidence_text = " ".join(tokens).lower()
    domains: list[str] = []
    evidence: list[str] = []
    layer_map = {
        "WEAPONS": "Armes et dégâts",
        "BREAKABLES": "Cassables, caisses et boulons",
        "PARTICLES": "Particules et effets visuels",
    }
    for layer in sorted(set(patch_layers)):
        if layer in layer_map and layer_map[layer] not in domains:
            domains.append(layer_map[layer])
            evidence.append(f"patch {layer} dans la même fonction")
    for domain, keywords in DOMAIN_RULES:
        hits = sorted({keyword for keyword in keywords if keyword in evidence_text})
        if hits and domain not in domains:
            domains.append(domain)
            evidence.append(f"mots-clés {', '.join(hits[:6])}")
    return domains or ["Indéterminé"], evidence


def priority_for_family(module_indices: set[int], module_count: int, evidence_strength: str) -> str:
    focus = bool(module_indices & {1, 2})
    if focus and evidence_strength in ("forte", "moyenne"):
        return "P0 — test Pokitaru/Ryllus ciblé"
    if focus:
        return "P1 — trace Pokitaru/Ryllus"
    if module_count >= 10:
        return "P1 — famille transversale"
    if module_count >= 2:
        return "P2 — extension multi-niveaux"
    return "P3 — niveau spécifique"


def evidence_strength(
    exact_objects: set[str],
    ancestor_objects: dict[str, int],
    patch_mechanics: set[str],
    symbolic_names: set[str],
) -> str:
    if exact_objects or patch_mechanics:
        return "forte"
    if len(ancestor_objects) > 8 and not symbolic_names:
        return "faible"
    if any(distance <= 2 for distance in ancestor_objects.values()) or symbolic_names:
        return "moyenne"
    if ancestor_objects:
        return "faible"
    return "indéterminée"


def build_catalog(root: Path) -> dict[str, Any]:
    inputs = base.resolve_inputs(root)
    manifest, _experience_ini, _readme = base.load_manifest(inputs["patch_v021"])
    modules, module_checks = base.load_modules(inputs)
    base_analysis = base.analyze_modules(modules, manifest)
    patch_rows, _patch_summary, _patch_layers = base.analyze_patches(manifest, base_analysis["context"])

    wrapper_by_module: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for row in base_analysis["wrapper_callers"]:
        wrapper_by_module[row["module_key"]].append(row)

    contexts: dict[str, dict[str, Any]] = {}
    descriptor_rows: list[dict[str, Any]] = []
    for module in modules:
        if module.key not in wrapper_by_module:
            continue
        context = base_analysis["context"][module.key]
        elf: base.Elf32 = context["elf"]
        strings = collect_strings(elf)
        starts = [item.start for item in strings]
        references = collect_address_references(elf)
        models, candidates = build_function_models(context, wrapper_by_module[module.key], references)
        descriptors, descriptor_by_callback = recover_object_descriptors(elf)
        reverse_graph = build_reverse_call_graph(models, candidates)
        text_relocations = context["text_relocations"]
        for descriptor in descriptors:
            descriptor_rows.append(
                {
                    "module_key": module.key,
                    "module_index": module.module_index,
                    "level": module.level_name,
                    "descriptor_rva": as_hex(descriptor["descriptor_rva"]),
                    "descriptor_runtime": as_hex(module.runtime_base + descriptor["descriptor_rva"]),
                    "object_name": descriptor["object_name"],
                    "callback_count": len(descriptor["callbacks"]),
                    "callback_rvas": "; ".join(as_hex(value) for value in descriptor["callbacks"]),
                    "callback_runtime_addresses": "; ".join(
                        as_hex(module.runtime_base + value) for value in descriptor["callbacks"]
                    ),
                    "pvar_schema": descriptor["pvar_schema"],
                }
            )
        contexts[module.key] = {
            "module": module,
            "context": context,
            "elf": elf,
            "strings": strings,
            "string_starts": starts,
            "references": references,
            "models": models,
            "candidates": candidates,
            "descriptors": descriptors,
            "descriptor_by_callback": descriptor_by_callback,
            "reverse_graph": reverse_graph,
            "text_relocations": text_relocations,
        }

    resolved_wrapper_rows: list[dict[str, Any]] = []
    recovered_assignment_count = 0
    for original in base_analysis["wrapper_callers"]:
        row = dict(original)
        if row.get("owner_rva_heuristic"):
            row["owner_assignment_status"] = "confirmed_by_previous_corpus_heuristic"
            resolved_wrapper_rows.append(row)
            continue
        ctx = contexts[row["module_key"]]
        site_rva = int(row["callsite_rva"], 16)
        owner = owner_for_site(ctx["candidates"], site_rva)
        if owner is None:
            raise RuntimeError(f"Callsite wrapper sans parent récupérable : {row['module_key']} {row['callsite_rva']}")
        distance = site_rva - owner
        row["owner_rva_heuristic"] = as_hex(owner)
        row["owner_runtime_heuristic"] = as_hex(ctx["module"].runtime_base + owner)
        window = base.normalized_code_window(ctx["elf"], owner, ctx["text_relocations"])
        row["owner_signature_sha256"] = sha256_bytes(window)
        row["owner_assignment_status"] = f"recovered_large_function_owner_distance_0x{distance:X}"
        recovered_assignment_count += 1
        resolved_wrapper_rows.append(row)

    patches_by_owner: dict[tuple[str, int], list[dict[str, Any]]] = defaultdict(list)
    for patch in patch_rows:
        module_key = patch["module_key"]
        if module_key not in contexts or patch["section"] != ".text":
            continue
        rva = parse_hex(patch["rva"])
        if rva is None:
            continue
        owner = owner_for_site(contexts[module_key]["candidates"], rva)
        if owner is not None:
            patches_by_owner[(module_key, owner)].append(patch)

    members_by_key: dict[tuple[str, int], list[dict[str, Any]]] = defaultdict(list)
    for row in resolved_wrapper_rows:
        owner = int(row["owner_rva_heuristic"], 16)
        members_by_key[(row["module_key"], owner)].append(row)

    member_rows: list[dict[str, Any]] = []
    callsite_rows: list[dict[str, Any]] = []
    callee_rows: list[dict[str, Any]] = []
    data_reference_rows: list[dict[str, Any]] = []
    patch_relation_rows: list[dict[str, Any]] = []
    member_evidence: dict[tuple[str, int], dict[str, Any]] = {}

    for (module_key, owner), wrapper_calls in sorted(members_by_key.items()):
        ctx = contexts[module_key]
        module: base.ModuleSource = ctx["module"]
        elf: base.Elf32 = ctx["elf"]
        model: FunctionModel = ctx["models"][owner]
        strings: list[StringRecord] = ctx["strings"]
        string_starts: list[int] = ctx["string_starts"]
        direct_strings: list[StringRecord] = []
        for reference in model.references:
            string = find_string(strings, string_starts, reference.target_rva)
            if string is not None:
                direct_strings.append(string)
                data_reference_rows.append(
                    {
                        "module_key": module_key,
                        "module_index": module.module_index,
                        "level": module.level_name,
                        "owner_rva": as_hex(owner),
                        "reference_site_rva": as_hex(reference.site_rva),
                        "reference_site_runtime": as_hex(module.runtime_base + reference.site_rva),
                        "target_rva": as_hex(reference.target_rva),
                        "target_section": reference.section,
                        "reference_kind": string.kind,
                        "value": string.text,
                    }
                )
        direct_strings = list({(item.start, item.text): item for item in direct_strings}.values())
        symbolic_names = {item.text for item in direct_strings if item.kind == "symbolic_name"}
        source_paths = {item.text for item in direct_strings if item.kind == "source_path"}
        exact_objects = {
            descriptor["object_name"]
            for descriptor in ctx["descriptor_by_callback"].get(owner, [])
        }
        ancestors = object_ancestors(owner, ctx["reverse_graph"], ctx["descriptor_by_callback"])
        ancestor_objects: dict[str, int] = {}
        for item in ancestors:
            name = item["object_name"]
            ancestor_objects[name] = min(ancestor_objects.get(name, 999), item["distance"])
        related_patches = [
            patch for patch in patches_by_owner.get((module_key, owner), []) if patch["layer"] != "WRAPPER"
        ]
        for patch in related_patches:
            patch_relation_rows.append(
                {
                    "module_key": module_key,
                    "module_index": module.module_index,
                    "level": module.level_name,
                    "owner_rva": as_hex(owner),
                    "patch_id": patch["patch_id"],
                    "patch_runtime_address": patch["runtime_address"],
                    "layer": patch["layer"],
                    "category": patch["category"],
                    "mechanic": patch["mechanic"],
                    "weapon_title": patch["weapon_title"],
                    "evidence": patch["evidence"],
                }
            )
        metrics = instruction_metrics(elf, model)
        referenced_floats = referenced_float_constants(elf, model)
        embedded_floats = embedded_float_constants(elf, model, ctx["text_relocations"])
        for item in referenced_floats:
            data_reference_rows.append(
                {
                    "module_key": module_key,
                    "module_index": module.module_index,
                    "level": module.level_name,
                    "owner_rva": as_hex(owner),
                    "reference_site_rva": as_hex(item["site_rva"]),
                    "reference_site_runtime": as_hex(module.runtime_base + item["site_rva"]),
                    "target_rva": as_hex(item["constant_rva"]),
                    "target_section": elf.section_for_vaddr(item["constant_rva"]).name,
                    "reference_kind": "float32",
                    "value": f"{format_float(item['value'])} / 0x{item['bits']:08X}",
                }
            )
        callees: list[str] = []
        imports: list[str] = []
        for call in model.calls:
            label = call["target_label"]
            target_rva = call["target_rva"]
            target_owner = None
            object_labels: set[str] = set()
            target_names: set[str] = set()
            if call["target_kind"] == "internal_text" and target_rva is not None:
                target_owner = owner_for_site(ctx["candidates"], int(target_rva))
                if target_owner is not None:
                    object_labels.update(
                        item["object_name"] for item in ctx["descriptor_by_callback"].get(target_owner, [])
                    )
                    target_model = ctx["models"].get(target_owner)
                    if target_model:
                        for reference in target_model.references:
                            string = find_string(strings, string_starts, reference.target_rva)
                            if string and string.kind == "symbolic_name":
                                target_names.add(string.text)
                text_label = ", ".join(sorted(object_labels | target_names))
                label = text_label or as_hex(int(target_rva))
                callees.append(label)
            elif call["target_kind"] == "import_stub":
                imports.append(label)
            callee_rows.append(
                {
                    "module_key": module_key,
                    "module_index": module.module_index,
                    "level": module.level_name,
                    "owner_rva": as_hex(owner),
                    "callsite_rva": as_hex(int(call["site_rva"])),
                    "callsite_runtime": as_hex(call["site_runtime"]),
                    "target_kind": call["target_kind"],
                    "target_rva": as_hex(target_rva),
                    "target_runtime": as_hex(call["target_runtime"]),
                    "target_owner_rva": as_hex(target_owner),
                    "target_label": label,
                }
            )
        full_hash = normalized_function_hash(elf, model, ctx["text_relocations"])
        first_signature = wrapper_calls[0]["owner_signature_sha256"]
        evidence = {
            "module_key": module_key,
            "module_index": int(module.module_index),
            "level": module.level_name,
            "owner": owner,
            "model": model,
            "signature": first_signature,
            "full_hash": full_hash,
            "callsites": wrapper_calls,
            "symbolic_names": symbolic_names,
            "source_paths": source_paths,
            "exact_objects": exact_objects,
            "ancestor_objects": ancestor_objects,
            "patches": related_patches,
            "metrics": metrics,
            "referenced_floats": referenced_floats,
            "embedded_floats": embedded_floats,
            "callees": set(callees),
            "imports": set(imports),
            "recovered": any(
                str(call.get("owner_assignment_status", "")).startswith("recovered_")
                for call in wrapper_calls
            ),
        }
        member_evidence[(module_key, owner)] = evidence
        member_rows.append(
            {
                "owner_signature_sha256": first_signature,
                "module_key": module_key,
                "module_index": module.module_index,
                "level": module.level_name,
                "owner_rva": as_hex(owner),
                "owner_runtime": as_hex(module.runtime_base + owner),
                "function_end_rva_estimate": as_hex(model.end),
                "function_size_bytes_estimate": model.end - model.start,
                "boundary_evidence": "entrée JAL/prologue précédente → entrée forte suivante",
                "owner_assignment_status": "; ".join(
                    sorted({str(call.get("owner_assignment_status", "")) for call in wrapper_calls})
                ),
                "full_normalized_sha256": full_hash,
                "wrapper_call_count": len(wrapper_calls),
                "incoming_direct_calls": model.incoming,
                "instruction_count": metrics.get("instructions", 0),
                "direct_call_count": metrics.get("direct_calls", 0),
                "fp_arithmetic_count": metrics.get("fp_arithmetic", 0),
                "fp_compare_count": metrics.get("fp_compare", 0),
                "fp_memory_count": metrics.get("fp_memory", 0),
                "branch_count": metrics.get("branches", 0),
                "backward_branch_count": metrics.get("backward_branches", 0),
                "return_site_count": metrics.get("return_sites", 0),
                "exact_object_descriptors": "; ".join(sorted(exact_objects)),
                "object_ancestors_depth_le_3": "; ".join(
                    f"{name}@{distance}" for name, distance in sorted(ancestor_objects.items(), key=lambda item: (item[1], item[0]))
                ),
                "symbolic_names": "; ".join(sorted(symbolic_names)),
                "source_paths": "; ".join(sorted(source_paths)),
                "same_function_patch_count": len(related_patches),
                "same_function_patch_layers": "; ".join(sorted({patch["layer"] for patch in related_patches})),
                "same_function_patch_mechanics": "; ".join(sorted({patch["mechanic"] for patch in related_patches})),
                "referenced_float32": "; ".join(
                    f"{format_float(item['value'])}@{as_hex(item['constant_rva'])}" for item in referenced_floats[:16]
                ),
                "embedded_float_high_halves": "; ".join(format_float(value) for value in embedded_floats),
                "direct_internal_callees": "; ".join(sorted(set(callees))),
                "direct_imports": "; ".join(sorted(set(imports))),
            }
        )
        for ordinal, call in enumerate(sorted(wrapper_calls, key=lambda item: int(item["callsite_rva"], 16)), start=1):
            callsite = int(call["callsite_runtime"], 16)
            callsite_rows.append(
                {
                    "owner_signature_sha256": first_signature,
                    "module_key": module_key,
                    "module_index": module.module_index,
                    "level": module.level_name,
                    "owner_rva": as_hex(owner),
                    "owner_runtime": as_hex(module.runtime_base + owner),
                    "owner_call_ordinal": ordinal,
                    "callsite_rva": call["callsite_rva"],
                    "callsite_runtime": call["callsite_runtime"],
                    "mips_ra_runtime": as_hex(callsite + 8),
                    "wrapper_entry_runtime": call["wrapper_entry_runtime"],
                    "wrapper_one_pass_runtime": call["wrapper_one_pass_runtime"],
                    "file_offset": call["file_offset"],
                    "instruction_context": call["instruction_context"],
                    "profiler_default_policy": "VANILLA",
                }
            )

    family_members: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for evidence in member_evidence.values():
        family_members[evidence["signature"]].append(evidence)
    ordered_signatures = sorted(
        family_members,
        key=lambda signature: (
            -len({item["module_index"] for item in family_members[signature]}),
            -sum(len(item["callsites"]) for item in family_members[signature]),
            signature,
        ),
    )
    recovered_signatures = [
        signature for signature in ordered_signatures if any(item["recovered"] for item in family_members[signature])
    ]
    family_id_by_signature = {
        signature: f"WF-{index:03d}" for index, signature in enumerate(ordered_signatures, start=1)
    }
    family_rows: list[dict[str, Any]] = []
    family_details: list[dict[str, Any]] = []
    for signature in ordered_signatures:
        members = family_members[signature]
        family_id = family_id_by_signature[signature]
        module_indices = {item["module_index"] for item in members}
        module_names = {item["level"] for item in members}
        call_count = sum(len(item["callsites"]) for item in members)
        call_count_by_module = Counter(
            item["module_index"]
            for item in members
            for _callsite in item["callsites"]
        )
        exact_objects = set().union(*(item["exact_objects"] for item in members))
        ancestor_objects: dict[str, int] = {}
        for item in members:
            for name, distance in item["ancestor_objects"].items():
                ancestor_objects[name] = min(ancestor_objects.get(name, 999), distance)
        symbolic_names = set().union(*(item["symbolic_names"] for item in members))
        source_paths = set().union(*(item["source_paths"] for item in members))
        patch_mechanics = {
            patch["mechanic"] for item in members for patch in item["patches"]
        }
        patch_layers = {patch["layer"] for item in members for patch in item["patches"]}
        tokens = list(exact_objects) + list(ancestor_objects) + list(symbolic_names) + list(source_paths) + list(patch_mechanics)
        domains, domain_evidence = semantic_domains(tokens, patch_layers)
        if len(ancestor_objects) > 8 and not exact_objects and not patch_mechanics and not symbolic_names:
            domains = ["Helper transversal / contextes multiples"]
            domain_evidence = [
                f"{len(ancestor_objects)} objets parents distincts à trois appels ou moins ; aucune association exclusive"
            ]
        elif domains == ["Indéterminé"] and exact_objects:
            domains = ["Objet de niveau identifié — rôle à tester"]
            domain_evidence = ["descripteur exact sans rôle gameplay déductible du nom"]
        elif domains == ["Indéterminé"] and ancestor_objects:
            domains = ["Objet ou acteur parent — rôle à tester"]
            domain_evidence = ["callback parent retrouvé, mais rôle gameplay non déductible du nom"]
        strength = evidence_strength(exact_objects, ancestor_objects, patch_mechanics, symbolic_names)
        priority = priority_for_family(module_indices, len(module_indices), strength)
        main_domain = domains[0]
        full_hashes = {item["full_hash"] for item in members}
        sizes = {item["model"].end - item["model"].start for item in members}
        recipe = TEST_RECIPES.get(main_domain, TEST_RECIPES["Indéterminé"])
        family_status = "recovered" if any(item["recovered"] for item in members) else "confirmed"
        family_row = {
            "family_id": family_id,
            "family_status": family_status,
            "family_key": f"SIG-{signature[:12].upper()}",
            "owner_signature_sha256": signature,
            "module_count": len(module_indices),
            "member_count": len(members),
            "callsite_count": call_count,
            "pokitaru_callsite_count": call_count_by_module[1],
            "ryllus_callsite_count": call_count_by_module[2],
            "focus_callsite_count": call_count_by_module[1] + call_count_by_module[2],
            "module_indices": "; ".join(str(value) for value in sorted(module_indices)),
            "levels": "; ".join(sorted(module_names)),
            "present_in_pokitaru": "yes" if 1 in module_indices else "no",
            "present_in_ryllus": "yes" if 2 in module_indices else "no",
            "pokitaru_ryllus_scope": (
                "commune aux deux" if {1, 2} <= module_indices else "Pokitaru" if 1 in module_indices else "Ryllus" if 2 in module_indices else "hors focus"
            ),
            "full_function_hash_variants": len(full_hashes),
            "function_size_variants": "; ".join(str(value) for value in sorted(sizes)),
            "static_domain_hypotheses": "; ".join(domains),
            "domain_evidence": "; ".join(domain_evidence),
            "evidence_strength": strength,
            "exact_object_descriptors": "; ".join(sorted(exact_objects)),
            "object_ancestors_depth_le_3": "; ".join(
                f"{name}@{distance}" for name, distance in sorted(ancestor_objects.items(), key=lambda item: (item[1], item[0]))
            ),
            "symbolic_names": "; ".join(sorted(symbolic_names)),
            "source_paths": "; ".join(sorted(source_paths)),
            "same_function_patch_layers": "; ".join(sorted(patch_layers)),
            "same_function_patch_mechanics": "; ".join(sorted(patch_mechanics)),
            "profiling_priority": priority,
            "safe_initial_policy": "VANILLA_UNTIL_PROFILED",
            "test_recipe": recipe,
            "static_limit": "La fréquence d’appel et le bon nombre de passes ne sont pas prouvables par la seule structure binaire.",
        }
        family_rows.append(family_row)
        family_details.append({"row": family_row, "members": members})

    for row in member_rows:
        row["family_id"] = family_id_by_signature[row["owner_signature_sha256"]]
    for row in callsite_rows:
        row["family_id"] = family_id_by_signature[row["owner_signature_sha256"]]
    for row in callee_rows:
        signature = member_evidence[(row["module_key"], int(row["owner_rva"], 16))]["signature"]
        row["family_id"] = family_id_by_signature[signature]
    for row in data_reference_rows:
        signature = member_evidence[(row["module_key"], int(row["owner_rva"], 16))]["signature"]
        row["family_id"] = family_id_by_signature[signature]
    for row in patch_relation_rows:
        signature = member_evidence[(row["module_key"], int(row["owner_rva"], 16))]["signature"]
        row["family_id"] = family_id_by_signature[signature]

    profiler_rows = [
        {
            "module_index": row["module_index"],
            "module_key": row["module_key"],
            "level": row["level"],
            "mips_ra_runtime": row["mips_ra_runtime"],
            "callsite_runtime": row["callsite_runtime"],
            "owner_runtime": row["owner_runtime"],
            "family_id": row["family_id"],
            "default_policy": "VANILLA",
            "note": "$ra = adresse du jal + 8 sur MIPS avec delay slot",
        }
        for row in sorted(callsite_rows, key=lambda item: (int(item["module_index"]), int(item["callsite_runtime"], 16)))
    ]

    wrapper_anatomy_rows: list[dict[str, Any]] = []
    for module_key, rows in sorted(wrapper_by_module.items(), key=lambda item: int(item[1][0]["module_index"])):
        ctx = contexts[module_key]
        module: base.ModuleSource = ctx["module"]
        entry = int(rows[0]["wrapper_entry_runtime"], 16)
        inner = int(rows[0]["wrapper_one_pass_runtime"], 16)
        inner_patch = entry + base.WRAPPER_ENTRY_DELTA
        patch_rva = inner_patch - module.runtime_base
        wrapper_anatomy_rows.append(
            {
                "module_index": module.module_index,
                "module_key": module_key,
                "level": module.level_name,
                "two_pass_entry_runtime": as_hex(entry),
                "one_pass_inner_runtime": as_hex(inner),
                "internal_call_suppression_site_runtime": as_hex(inner_patch),
                "entry_to_patch_delta": as_hex(base.WRAPPER_ENTRY_DELTA, 0),
                "inner_to_patch_delta": as_hex(base.WRAPPER_ONE_PASS_DELTA, 0),
                "direct_caller_count": len(rows),
                "entry_word_0": as_hex(ctx["elf"].read_u32(entry - module.runtime_base)),
                "entry_word_1": as_hex(ctx["elf"].read_u32(entry - module.runtime_base + 4)),
                "entry_word_2": as_hex(ctx["elf"].read_u32(entry - module.runtime_base + 8)),
                "entry_word_3": as_hex(ctx["elf"].read_u32(entry - module.runtime_base + 12)),
                "original_word_at_suppression_site": as_hex(ctx["elf"].read_u32(patch_rva)),
            }
        )

    focus_signatures = {
        row["owner_signature_sha256"]
        for row in family_rows
        if row["present_in_pokitaru"] == "yes" or row["present_in_ryllus"] == "yes"
    }
    shared_focus = {
        row["owner_signature_sha256"]
        for row in family_rows
        if row["present_in_pokitaru"] == "yes" and row["present_in_ryllus"] == "yes"
    }
    module_counts = Counter(int(row["module_index"]) for row in callsite_rows)
    recovered_members = [
        item for item in member_evidence.values() if item["recovered"]
    ]
    recovered_member_valid = (
        len(recovered_members) == 1
        and recovered_members[0]["module_index"] == 3
        and recovered_members[0]["exact_objects"] == {"Lvl3Platform"}
        and recovered_members[0]["model"].has_prologue
        and recovered_members[0]["model"].end - recovered_members[0]["model"].start == 0x2A08
    )
    multi_module_rows = [row for row in family_rows if int(row["module_count"]) >= 2]
    validation: dict[str, dict[str, Any]] = {
        **module_checks,
        "wrapper_callsite_total": {
            "status": "PASS" if len(callsite_rows) == 493 else "FAIL",
            "actual": len(callsite_rows),
            "expected": 493,
        },
        "wrapper_family_total": {
            "status": "PASS" if len(ordered_signatures) == 59 else "FAIL",
            "actual": len(ordered_signatures),
            "expected": 59,
        },
        "recovered_large_function_owner": {
            "status": "PASS" if recovered_assignment_count == 1 and len(recovered_signatures) == 1 else "FAIL",
            "callsite_assignments": recovered_assignment_count,
            "recovered_families": len(recovered_signatures),
            "expected": 1,
        },
        "recovered_level03_platform_evidence": {
            "status": "PASS" if recovered_member_valid else "FAIL",
            "module_index": recovered_members[0]["module_index"] if recovered_members else "",
            "owner_rva": as_hex(recovered_members[0]["owner"]) if recovered_members else "",
            "function_size_bytes": (
                recovered_members[0]["model"].end - recovered_members[0]["model"].start
                if recovered_members else ""
            ),
            "exact_object": "; ".join(sorted(recovered_members[0]["exact_objects"])) if recovered_members else "",
        },
        "focus_family_total": {
            "status": "PASS" if len(focus_signatures) == 38 else "FAIL",
            "actual": len(focus_signatures),
            "expected": 38,
        },
        "shared_pokitaru_ryllus_families": {
            "status": "PASS" if len(shared_focus) == 18 else "FAIL",
            "actual": len(shared_focus),
            "expected": 18,
        },
        "pokitaru_ryllus_callsite_total": {
            "status": "PASS" if sum(
                1 for row in callsite_rows if int(row["module_index"]) in (1, 2)
            ) == 112 else "FAIL",
            "actual": sum(1 for row in callsite_rows if int(row["module_index"]) in (1, 2)),
            "expected": 112,
        },
        "multi_module_full_function_hashes_stable": {
            "status": "PASS" if len(multi_module_rows) == 31 and all(
                int(row["full_function_hash_variants"]) == 1 for row in multi_module_rows
            ) else "FAIL",
            "multi_module_families": len(multi_module_rows),
            "stable_full_hash_families": sum(
                int(row["full_function_hash_variants"]) == 1 for row in multi_module_rows
            ),
            "expected": 31,
        },
        "pokitaru_callers": {
            "status": "PASS" if module_counts[1] == 55 else "FAIL",
            "actual": module_counts[1],
            "expected": 55,
        },
        "ryllus_callers": {
            "status": "PASS" if module_counts[2] == 57 else "FAIL",
            "actual": module_counts[2],
            "expected": 57,
        },
        "profiler_capacity": {
            "status": "PASS" if max(module_counts.values()) < PROFILER_TABLE_CAPACITY else "FAIL",
            "maximum_active_module_callsites": max(module_counts.values()),
            "capacity": PROFILER_TABLE_CAPACITY,
        },
        "all_callsites_have_ra": {
            "status": "PASS" if all(row["mips_ra_runtime"] for row in callsite_rows) else "FAIL",
            "rows": len(callsite_rows),
        },
        "all_family_ids_resolved": {
            "status": "PASS" if all(row.get("family_id") for row in callsite_rows) else "FAIL",
            "rows": len(callsite_rows),
        },
        "all_callsite_words_match_wrapper_jal": {
            "status": "PASS" if all(
                contexts[row["module_key"]]["elf"].read_u32(int(row["callsite_rva"], 16))
                == (
                    0x0C000000
                    | (
                        (
                            int(row["wrapper_entry_runtime"], 16)
                            - contexts[row["module_key"]]["module"].runtime_base
                        )
                        >> 2
                    )
                    & 0x03FFFFFF
                )
                for row in callsite_rows
            ) else "FAIL",
            "rows": len(callsite_rows),
            "expected_instruction": "jal wrapper_two_pass (mot PRX relogeable)",
        },
    }
    failures = [name for name, result in validation.items() if result["status"] != "PASS"]
    if failures:
        raise RuntimeError("Contrôles bloquants en échec : " + ", ".join(failures))

    counts = {
        "families": len(ordered_signatures),
        "family_records": len(family_rows),
        "recovered_families": len(recovered_signatures),
        "focus_families": len(focus_signatures),
        "shared_focus_families": len(shared_focus),
        "callsites": len(callsite_rows),
        "members": len(member_rows),
        "descriptors": len(descriptor_rows),
        "families_with_strong_evidence": sum(row["evidence_strength"] == "forte" for row in family_rows),
        "families_with_any_semantic_evidence": sum(row["evidence_strength"] != "indéterminée" for row in family_rows),
        "max_callsites_per_module": max(module_counts.values()),
        "multi_module_families": sum(int(row["module_count"]) >= 2 for row in family_rows),
        "multi_module_full_hash_stable": sum(
            int(row["module_count"]) >= 2 and int(row["full_function_hash_variants"]) == 1
            for row in family_rows
        ),
        "singleton_families": sum(int(row["module_count"]) == 1 for row in family_rows),
        "focus_callsites": sum(
            1 for row in callsite_rows if int(row["module_index"]) in (1, 2)
        ),
        "focus_l1_only_families": sum(row["pokitaru_ryllus_scope"] == "Pokitaru" for row in family_rows),
        "focus_l2_only_families": sum(row["pokitaru_ryllus_scope"] == "Ryllus" for row in family_rows),
        "same_function_patch_relations": len(patch_relation_rows),
    }
    return {
        "generated_utc": datetime.now(timezone.utc).isoformat(),
        "counts": counts,
        "families": family_rows,
        "family_details": family_details,
        "members": member_rows,
        "callsites": callsite_rows,
        "callees": callee_rows,
        "data_references": data_reference_rows,
        "patch_relations": patch_relation_rows,
        "object_descriptors": descriptor_rows,
        "profiler_lookup": profiler_rows,
        "wrapper_anatomy": wrapper_anatomy_rows,
        "validation": validation,
        "contexts": contexts,
        "family_id_by_signature": family_id_by_signature,
    }


def h(value: Any) -> str:
    return html.escape(str(value), quote=True)


def table_html(rows: list[dict[str, Any]], columns: list[tuple[str, str]], css_class: str = "") -> str:
    if not rows:
        return '<p class="muted">Aucune entrée.</p>'
    head = "".join(f"<th>{h(label)}</th>" for _key, label in columns)
    body = []
    for row in rows:
        cells = "".join(f"<td>{h(row.get(key, ''))}</td>" for key, _label in columns)
        body.append(f"<tr>{cells}</tr>")
    return f'<div class="table-wrap"><table class="{h(css_class)}"><thead><tr>{head}</tr></thead><tbody>{"".join(body)}</tbody></table></div>'


def render_report(catalog: dict[str, Any], package_name: str) -> str:
    counts = catalog["counts"]
    families = catalog["families"]
    focus = [row for row in families if row["present_in_pokitaru"] == "yes" or row["present_in_ryllus"] == "yes"]
    focus.sort(key=lambda row: (row["profiling_priority"], row["family_id"]))
    module_summary = []
    call_counts = Counter(int(row["module_index"]) for row in catalog["callsites"])
    family_counts: dict[int, set[str]] = defaultdict(set)
    for row in catalog["callsites"]:
        family_counts[int(row["module_index"])].add(row["family_id"])
    for anatomy in catalog["wrapper_anatomy"]:
        index = int(anatomy["module_index"])
        module_summary.append(
            {
                "module_index": index,
                "level": anatomy["level"],
                "calls": call_counts[index],
                "families": len(family_counts[index]),
                "entry": anatomy["two_pass_entry_runtime"],
                "inner": anatomy["one_pass_inner_runtime"],
            }
        )

    focus_table = table_html(
        focus,
        [
            ("family_id", "Famille"),
            ("pokitaru_ryllus_scope", "Portée L1/L2"),
            ("focus_callsite_count", "Appels L1+L2"),
            ("pokitaru_callsite_count", "L1"),
            ("ryllus_callsite_count", "L2"),
            ("module_count", "Modules"),
            ("static_domain_hypotheses", "Hypothèse statique"),
            ("exact_object_descriptors", "Objets exacts"),
            ("evidence_strength", "Preuve"),
            ("profiling_priority", "Priorité"),
        ],
        "filterable",
    )
    module_table = table_html(
        module_summary,
        [
            ("module_index", "Index"),
            ("level", "Niveau"),
            ("calls", "Callsites"),
            ("families", "Familles"),
            ("entry", "Wrapper 2 passes"),
            ("inner", "Routine 1 passe"),
        ],
    )
    family_table = table_html(
        families,
        [
            ("family_id", "Famille"),
            ("module_count", "Modules"),
            ("callsite_count", "Appels"),
            ("levels", "Niveaux"),
            ("static_domain_hypotheses", "Domaines suggérés"),
            ("evidence_strength", "Preuve"),
            ("safe_initial_policy", "Politique initiale"),
        ],
        "filterable",
    )

    object_examples = [
        {
            "family": row["family_id"],
            "objects": row["exact_object_descriptors"],
            "levels": row["levels"],
            "why": "Le descripteur de l’objet pointe directement vers cette fonction.",
        }
        for row in families
        if row["exact_object_descriptors"]
    ][:12]
    object_examples_table = table_html(
        object_examples,
        [
            ("family", "Famille"),
            ("objects", "Nom(s) retrouvé(s) dans le jeu"),
            ("levels", "Niveau(x)"),
            ("why", "Pourquoi le lien est fort"),
        ],
    )
    proof_legend_table = table_html(
        [
            {"kind": "Observation exacte", "example": "instruction jal, opcode, adresse runtime, $ra, relocation, descripteur", "meaning": "Reproductible directement depuis les PRX fournis."},
            {"kind": "Regroupement robuste", "example": "hash normalisé et fonction complète identiques entre plusieurs PRX", "meaning": "Très bon indice qu’il s’agit du même code relocalisé."},
            {"kind": "Inférence documentée", "example": "objet parent à une, deux ou trois arêtes dans le graphe d’appels", "meaning": "Contexte probable, avec la distance conservée pour ne pas le présenter comme une certitude."},
            {"kind": "Hypothèse à tester", "example": "logique par frame, delta time, tick fixe ou événement", "meaning": "Impossible à trancher proprement sans exécution et mesure 30/60 FPS."},
        ],
        [("kind", "Nature"), ("example", "Exemple"), ("meaning", "Ce que l’on peut en conclure")],
    )
    capability_table = table_html(
        [
            {"stage": "1. Cartographier le binaire", "status": "FAIT", "deliverable": f"{counts['callsites']} callsites, {counts['families']} familles, {counts['descriptors']} descripteurs", "need": "Rien"},
            {"stage": "2. Préparer le profiler", "status": "FOURNI ICI", "deliverable": "tables C générées, cœur de lookup, test PC, configuration PPSSPP et format de trace", "need": "Rien"},
            {"stage": "3. Finaliser le hook MIPS", "status": "PROCHAINE ÉTAPE", "deliverable": "trampoline préservant l’état CPU puis tail-jump vers le wrapper original", "need": "PSPSDK et revue instruction par instruction"},
            {"stage": "4. Compiler patch.prx", "status": "À FAIRE", "deliverable": "plugin utilisateur PPSSPP pour UCES00420", "need": "Chaîne PSPDEV/PSPSDK (absente de cet environnement)"},
            {"stage": "5. Mesurer dans le jeu", "status": "À TESTER", "deliverable": "traces A/B/C de scènes reproductibles", "need": "Ta version de PPSSPP, des sauvegardes en jeu et quelques parcours de test"},
            {"stage": "6. Décider par famille", "status": "APRÈS LES TRACES", "deliverable": "VANILLA, TWO_PASS, ONE_PASS ou CUSTOM par famille/callsite", "need": "Résultats de fréquence et observation gameplay"},
            {"stage": "7. Porter sur PSP réelle", "status": "OPTION ULTÉRIEURE", "deliverable": "même cœur utilisateur avec chargeur/bootstrap CFW séparé", "need": "Matériel, CFW ciblé et tests de mémoire/performances"},
        ],
        [("stage", "Étape"), ("status", "État"), ("deliverable", "Ce que je peux produire"), ("need", "Ce qu’il faut pour avancer")],
    )
    glossary_table = table_html(
        [
            {"term": "Frame / image", "plain": "Une image affichée. À 60 FPS, le jeu en produit environ deux fois plus qu’à 30 FPS.", "technical": "Une itération de rendu ; elle ne doit pas nécessairement être une itération de simulation."},
            {"term": "Delta time (dt)", "plain": "Le temps réellement écoulé depuis l’image précédente.", "technical": "Multiplier une vitesse par dt permet en principe de conserver la même vitesse à différents FPS."},
            {"term": "Tick fixe", "plain": "Une cadence de simulation indépendante du nombre d’images.", "technical": "La simulation avance par pas constants, par exemple 1/30 s, avec éventuellement plusieurs ticks par frame."},
            {"term": "PRX", "plain": "Un module exécutable de la PSP, comparable à une petite bibliothèque chargée en plus du jeu.", "technical": "ELF MIPS relogeable au format module PSP."},
            {"term": "MIPS / Allegrex", "plain": "Le langage machine du processeur principal de la PSP.", "technical": "Jeu d’instructions MIPS 32 bits avec particularités Allegrex/VFPU."},
            {"term": "jal", "plain": "L’instruction qui appelle une fonction.", "technical": "Jump And Link : saute vers la cible et place PC+8 dans $ra."},
            {"term": "Delay slot", "plain": "L’instruction juste après un saut, encore exécutée avant le changement de fonction.", "technical": "Sur ce MIPS, le mot à PC+4 fait partie de la sémantique de l’appel."},
            {"term": "$ra", "plain": "Le ticket de retour laissé par l’appelant.", "technical": "Registre 31 ; ici sa valeur exacte identifie le callsite par $ra = adresse du jal + 8."},
            {"term": "Callsite", "plain": "L’endroit précis où une fonction du jeu appelle le wrapper.", "technical": "Adresse runtime d’une instruction jal ciblant l’entrée deux passes."},
            {"term": "Famille", "plain": "Plusieurs fonctions de niveaux différents reconnues comme le même morceau de code.", "technical": "Regroupement par hash normalisé des relocations, contrôlé par le hash de fonction complète."},
            {"term": "RVA", "plain": "Une adresse relative au début du module.", "technical": "Pratique pour comparer des PRX indépendamment de leur adresse de chargement."},
            {"term": "Adresse runtime", "plain": "L’adresse effective lorsque le jeu est chargé en mémoire.", "technical": "Base de chargement + RVA ; c’est celle qu’utilise le hook."},
            {"term": "Relocation", "plain": "Une indication disant au chargeur quelles adresses adapter.", "technical": "Les mots relocalisés sont neutralisés lors du hash pour comparer le code plutôt que ses adresses."},
            {"term": "Wrapper / helper", "plain": "Une fonction intermédiaire réutilisée par beaucoup de mécaniques.", "technical": "Ici, une fonction flottante qui appelle deux fois une routine interne à une passe."},
            {"term": "Hook / trampoline", "plain": "Une petite déviation contrôlée vers notre code, puis un retour au jeu.", "technical": "Ici le jal est redirigé, son delay slot reste intact, puis le hook restaure l’état CPU et saute vers le wrapper original."},
            {"term": "Dispatcher", "plain": "L’aiguilleur qui choisira le comportement selon l’appelant.", "technical": "Lookup module + $ra vers une politique explicite par famille ou callsite."},
            {"term": "VANILLA", "plain": "Ne rien changer au comportement original.", "technical": "Valeur par défaut et mode de repli en cas de signature inconnue."},
        ],
        [("term", "Terme"), ("plain", "Version simple"), ("technical", "Précision technique")],
    )

    details = []
    for family in catalog["family_details"]:
        row = family["row"]
        members = family["members"]
        member_summary = []
        snippets = []
        for item in sorted(members, key=lambda value: value["module_index"]):
            model: FunctionModel = item["model"]
            member_summary.append(
                {
                    "module": item["module_index"],
                    "level": item["level"],
                    "owner": as_hex(catalog["contexts"][item["module_key"]]["module"].runtime_base + item["owner"]),
                    "size": model.end - model.start,
                    "wrapper_calls": len(item["callsites"]),
                    "objects": "; ".join(sorted(item["exact_objects"])),
                    "ancestors": "; ".join(
                        f"{name}@{distance}" for name, distance in sorted(item["ancestor_objects"].items(), key=lambda value: (value[1], value[0]))[:8]
                    ),
                    "patches": "; ".join(sorted({patch["mechanic"] for patch in item["patches"]})),
                }
            )
            representative_call = min(item["callsites"], key=lambda value: int(value["callsite_rva"], 16))
            call_rva = int(representative_call["callsite_rva"], 16)
            ctx = catalog["contexts"][item["module_key"]]
            snippets.append(
                f"<h5>{h(item['module_key'])} — {h(item['level'])}, appel représentatif {h(representative_call['callsite_runtime'])}</h5>"
                f"<pre>{h(disassembly_window(ctx['elf'], call_rva, ctx['module'].runtime_base))}</pre>"
            )
        evidence_bits = []
        if row["exact_object_descriptors"]:
            evidence_bits.append(f"Objets directement reliés à la fonction : {row['exact_object_descriptors']}.")
        if row["object_ancestors_depth_le_3"]:
            evidence_bits.append(f"Callbacks parents retrouvés dans le graphe : {row['object_ancestors_depth_le_3']}.")
        if row["same_function_patch_mechanics"]:
            evidence_bits.append(f"Patchs connus dans les mêmes bornes : {row['same_function_patch_mechanics']}.")
        if row["symbolic_names"]:
            evidence_bits.append(f"Noms symboliques référencés : {row['symbolic_names']}.")
        if not evidence_bits:
            evidence_bits.append("Aucun nom gameplay direct n’est conservé dans cette fonction ; la famille reste structurelle.")
        details.append(
            f"""
<details class="family-card" data-search="{h(' '.join(str(value) for value in row.values()))}">
  <summary><span>{h(row['family_id'])}</span> — {h(row['static_domain_hypotheses'])} <small>{h(row['module_count'])} module(s), {h(row['callsite_count'])} appel(s), preuve {h(row['evidence_strength'])}</small></summary>
  <div class="family-body">
    <div class="two-col">
      <div><h4>Lecture actuelle</h4><p>{h(' '.join(evidence_bits))}</p><p><strong>Décision sûre :</strong> conserver le comportement vanilla tant qu’une trace 30/60 FPS n’a pas établi la fréquence et l’effet de la passe.</p></div>
      <div><h4>Test proposé</h4><p>{h(row['test_recipe'])}</p><p><strong>Priorité :</strong> {h(row['profiling_priority'])}. La signature stable est <code>{h(row['family_key'])}</code>.</p></div>
    </div>
    {table_html(member_summary, [('module','Module'),('level','Niveau'),('owner','Fonction'),('size','Taille estimée'),('wrapper_calls','Appels wrapper'),('objects','Objets exacts'),('ancestors','Objets parents'),('patches','Patchs liés')])}
    <details><summary>Afficher les fenêtres assembleur représentatives</summary>{''.join(snippets)}</details>
  </div>
</details>
"""
        )

    generated = catalog["generated_utc"]
    return f"""<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{h(CATALOG_TITLE)} — UCES-00420</title>
<style>
:root{{--bg:#0c1118;--panel:#131b25;--panel2:#192432;--text:#eaf1f8;--muted:#9eb0c3;--line:#2a3b4d;--accent:#61d4b3;--accent2:#7fb5ff;--warn:#ffd479}}
*{{box-sizing:border-box}} body{{margin:0;background:var(--bg);color:var(--text);font:15px/1.55 system-ui,-apple-system,Segoe UI,sans-serif}}
header,main,footer{{max-width:1480px;margin:auto;padding:28px}} header{{padding-top:44px}} h1{{font-size:clamp(2rem,4vw,3.5rem);line-height:1.05;margin:.2em 0}}
h2{{margin-top:2.3em;border-bottom:1px solid var(--line);padding-bottom:.35em}} h3,h4,h5{{color:#d8eaff}} p{{max-width:1050px}} a{{color:var(--accent2)}} code,pre{{font-family:ui-monospace,SFMono-Regular,Consolas,monospace}}
pre{{background:#080d13;border:1px solid var(--line);padding:14px;overflow:auto;color:#cce6ff}} nav{{position:sticky;top:0;z-index:4;background:#101823ee;border-block:1px solid var(--line);padding:10px 28px}}
nav a{{display:inline-block;margin:4px 16px 4px 0;text-decoration:none}} .lede{{font-size:1.12rem;color:#c8d5e2;max-width:1000px}}
.cards{{display:grid;grid-template-columns:repeat(auto-fit,minmax(190px,1fr));gap:12px;margin:24px 0}} .card{{background:linear-gradient(145deg,var(--panel2),var(--panel));border:1px solid var(--line);border-radius:12px;padding:18px}}
.card strong{{display:block;font-size:2rem;color:var(--accent)}} .card span,.muted,small{{color:var(--muted)}} .note{{border-left:4px solid var(--warn);background:#1b1b16;padding:12px 18px;margin:18px 0}}
.ok{{border-left-color:var(--accent);background:#10201c}} .table-wrap{{overflow:auto;border:1px solid var(--line);border-radius:10px;margin:14px 0 24px}} table{{width:100%;border-collapse:collapse;min-width:900px}}
th,td{{padding:9px 11px;border-bottom:1px solid var(--line);vertical-align:top;text-align:left}} th{{position:sticky;top:0;background:#1b2837;color:#ddecff}} tr:hover td{{background:#15202b}}
.family-card{{border:1px solid var(--line);border-radius:10px;background:var(--panel);margin:10px 0}} .family-card>summary{{cursor:pointer;padding:14px 16px;font-weight:650}}
.family-card>summary span{{color:var(--accent)}} .family-card>summary small{{margin-left:10px;font-weight:400}} .family-body{{padding:0 16px 18px}} .two-col{{display:grid;grid-template-columns:repeat(auto-fit,minmax(310px,1fr));gap:18px}}
.toolbar{{display:flex;gap:10px;flex-wrap:wrap;margin:14px 0}} input,select{{background:#0a1017;color:var(--text);border:1px solid var(--line);border-radius:7px;padding:10px 12px;min-width:260px}}
.downloads{{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:8px}} .downloads a{{display:block;background:var(--panel);border:1px solid var(--line);padding:12px;border-radius:8px;text-decoration:none}}
.flow{{display:grid;grid-template-columns:repeat(4,minmax(160px,1fr));gap:10px;margin:22px 0}} .step{{position:relative;background:var(--panel);border:1px solid var(--line);border-radius:12px;padding:16px}}
.step:not(:last-child)::after{{content:"→";position:absolute;right:-11px;top:42%;z-index:2;color:var(--accent);font-weight:800;background:var(--bg);padding:0 3px}} .step b{{display:block;color:var(--accent);margin-bottom:6px}}
.reading-key{{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:12px;margin:18px 0}} .reading-key>div{{background:var(--panel);border:1px solid var(--line);border-radius:10px;padding:15px}}
.badge{{display:inline-block;border:1px solid var(--line);border-radius:999px;padding:2px 9px;margin-right:5px;color:#ddecff;background:#172432;font-size:.86rem}} .plain{{color:#e9f7f2}} .tech{{color:#b9c9d9}}
kbd{{background:#eef3f8;color:#0b1118;border-radius:4px;padding:1px 5px;font:600 .9em ui-monospace,monospace}} .compact li{{margin:.45em 0}} .sources li{{margin:.7em 0;max-width:1100px}}
@media(max-width:700px){{header,main,footer{{padding:20px}} nav{{padding:8px 20px}}}}
@media(max-width:900px){{.flow{{grid-template-columns:1fr}} .step:not(:last-child)::after{{content:"↓";right:auto;left:50%;top:auto;bottom:-18px}}}}
</style>
</head>
<body>
<header>
  <p class="muted">Ratchet &amp; Clank: Size Matters · PSP · UCES-00420 · {h(package_name)}</p>
  <h1>{h(CATALOG_TITLE)}</h1>
  <p class="lede">Ce rapport explique, du niveau débutant jusqu’aux adresses MIPS, comment les 493 appels d’un helper à deux passes ont été regroupés en {counts['families']} familles. Le but n’est pas de « deviner automatiquement » le bon correctif, mais de construire un PRX capable de mesurer puis d’appliquer une décision sûre selon l’appelant.</p>
  <div class="cards">
    <div class="card"><strong>{counts['callsites']}</strong><span>callsites exacts</span></div>
    <div class="card"><strong>{counts['families']}</strong><span>familles globales</span></div>
    <div class="card"><strong>{counts['recovered_families']}</strong><span>famille supplémentaire récupérée</span></div>
    <div class="card"><strong>{counts['focus_families']}</strong><span>familles L1/L2</span></div>
    <div class="card"><strong>{counts['shared_focus_families']}</strong><span>communes Pokitaru/Ryllus</span></div>
    <div class="card"><strong>{counts['multi_module_full_hash_stable']}/{counts['multi_module_families']}</strong><span>familles multi-PRX entièrement stables</span></div>
    <div class="card"><strong>{counts['families_with_strong_evidence']}</strong><span>familles à preuve sémantique forte</span></div>
    <div class="card"><strong>{counts['descriptors']}</strong><span>descripteurs d’objets récupérés</span></div>
  </div>
</header>
<nav><a href="#start">Comprendre</a><a href="#conclusion">Conclusion</a><a href="#reading">Lire une fiche</a><a href="#helper">Helper</a><a href="#focus">Pokitaru/Ryllus</a><a href="#families">{counts['families']} familles</a><a href="#profiler">Profiler</a><a href="#capabilities">Ce que je peux faire</a><a href="#glossary">Glossaire</a><a href="#limits">Limites</a><a href="#downloads">Fichiers</a></nav>
<main>
<section id="start">
  <h2>Comprendre le projet en cinq minutes</h2>
  <p class="plain">Imagine qu’une mécanique du jeu ajoute « un petit pas » à chaque image. À 30 images par seconde, elle fait 30 petits pas ; à 60 FPS, elle peut en faire 60 et aller deux fois trop vite. Une mécanique bien conçue utilise au contraire le temps écoulé, ou un rythme de simulation fixe, et ne double pas automatiquement. Dans <em>Size Matters</em>, les deux modèles peuvent coexister : c’est précisément pourquoi un patch global peut corriger une porte tout en cassant une arme, une collision ou une animation.</p>
  <div class="flow">
    <div class="step"><b>1 · Le jeu appelle</b>Une fonction de bateau, porte, ennemi ou effet appelle le helper.</div>
    <div class="step"><b>2 · Le wrapper travaille</b>Le helper exécute actuellement deux fois sa petite routine interne.</div>
    <div class="step"><b>3 · Le profiler reconnaît</b>Le registre <code>$ra</code> indique exactement quel endroit a lancé l’appel.</div>
    <div class="step"><b>4 · Le dispatcher choisit</b>Après mesure, cet appel reste vanilla ou reçoit une politique explicite.</div>
  </div>
  <div class="note ok"><p><strong>La bonne idée « game-agnostic » :</strong> réutiliser l’infrastructure — chargement du plugin, détection des frames, compteur, lookup et sécurité — tout en gardant des profils propres à chaque jeu. GOG dit la même chose pour son wrapper DirectX 9 : son cœur est réutilisable, mais l’identification des calculs de physique, de FOV et des constantes demande toujours du reverse engineering jeu par jeu. <a href="https://www.gog.com/blog/preserving-sands-of-time/">Article technique GOG</a>.</p></div>
  <h3>Ce qui se transpose de GOG, et ce qui ne se transpose pas</h3>
  <div class="reading-key">
    <div><span class="badge">Réutilisable</span><h4>La plateforme</h4><p>Un composant chargé avec le jeu, un point d’observation stable, un format de profils, une interface de réglage et des garde-fous.</p></div>
    <div><span class="badge">Spécifique PSP</span><h4>Le point d’entrée</h4><p>Il n’y a pas DirectX sur PSP. Le PRX doit observer les fonctions MIPS du jeu et, si besoin, un signal de frame fourni par le jeu ou PPSSPP.</p></div>
    <div><span class="badge">Spécifique au jeu</span><h4>La décision</h4><p>Aucun wrapper ne peut savoir seul qu’une valeur représente une vitesse, une durée ou un tick de dégâts. Il faut cartographier et tester.</p></div>
  </div>
  <h3>Ce que les fichiers ont déjà permis d’établir</h3>
  {proof_legend_table}
</section>
<section id="conclusion">
  <h2>Conclusion opérationnelle</h2>
  <p>Le corpus suffit pour préparer un profiler et un futur dispatcher : chaque appel possède désormais une clé runtime exacte, <code>$ra = jal + 8</code>, et une famille stable. En revanche, le PRX ne doit pas décider automatiquement qu’une famille est frame-based simplement parce qu’elle appelle ce helper ; la politique sûre reste <code>VANILLA_UNTIL_PROFILED</code>, puis une décision explicite par famille ou par callsite.</p>
  <p>Les {counts['callsites']} mots d’appel bruts ont également été revérifiés comme des <code>jal</code> vers le wrapper attendu. Le plan runtime peut donc précontrôler tous les callsites du niveau avant d’en rediriger un seul ; une divergence annule l’installation entière.</p>
  <p>Le total passe de 58 à 59 familles : l’ancien plafond heuristique de 0x2000 octets avait laissé sans parent un appel de Kalidon. Le nouveau passage l’inscrit dans la fonction de 0x2A08 octets associée directement au descripteur <code>Lvl3Platform</code> ; cette correction ne change pas les 38 familles de Pokitaru/Ryllus.</p>
  <p>La jointure avec les correctifs v0.2.1 ne trouve aucun mot de patch connu à l’intérieur des mêmes bornes de fonction que ces callers. Les hypothèses sémantiques du rapport viennent donc des descripteurs d’objets et du graphe d’appels, sans être artificiellement déduites des catégories du patch existant.</p>
  <div class="note ok"><p>Le prototype réserve {PROFILER_TABLE_CAPACITY} statistiques de {PROFILER_ENTRY_BYTES} octets, soit {PROFILER_TABLE_CAPACITY * PROFILER_ENTRY_BYTES} octets, alors que le module le plus chargé n’a que {counts['max_callsites_per_module']} callsites. Les {counts['callsites']} profils immuables ajoutent {counts['callsites'] * 8} octets. Ces données appartiennent au PRX chargé ; le coût final du code, de la pile et du trampoline reste à mesurer sur la cible.</p></div>
</section>
<section id="reading">
  <h2>Comment lire une fiche de famille</h2>
  <p>Une fiche n’est pas un verdict automatique. Elle rassemble plusieurs couches de preuve pour décider quel test exécuter. Les quatre éléments ci-dessous suffisent pour une première lecture ; l’assembleur reste replié tant qu’on n’en a pas besoin.</p>
  <div class="reading-key">
    <div><h4>Famille <code>WF-xxx</code></h4><p>Identifiant stable attribué à un même profil de fonction. Si une famille existe dans plusieurs PRX, ses adresses peuvent changer mais son code normalisé reste comparable.</p></div>
    <div><h4>Objet exact</h4><p>Nom récupéré dans un descripteur du jeu dont un callback pointe directement vers la fonction. C’est la preuve sémantique la plus lisible et la plus forte de ce corpus.</p></div>
    <div><h4>Objet parent <code>@N</code></h4><p>Le nom se trouve à <code>N</code> appels de distance. <code>@1</code> est proche ; <code>@3</code> est utile pour orienter un test, mais ne doit pas être présenté comme une identité certaine.</p></div>
    <div><h4><code>VANILLA_UNTIL_PROFILED</code></h4><p>Politique de sécurité : ne pas modifier cette famille avant d’avoir comparé son activité et son effet réel à 30 et 60 FPS.</p></div>
    <div><h4>Adresse runtime</h4><p>Adresse utilisée pendant l’exécution. Elle sert au hook et au lookup ; elle n’est valable que pour le module et la version UCES-00420 vérifiés.</p></div>
    <div><h4>Priorité de profilage</h4><p>Ordre expérimental, pas importance gameplay. P1 signifie que la famille apparaît déjà dans Pokitaru ou Ryllus et peut être testée tôt.</p></div>
  </div>
  <h3>Quelques liens sémantiques directs</h3>
  <p>Ces exemples ne viennent pas d’un simple mot ressemblant trouvé à proximité : le descripteur de l’objet référence directement la fonction membre de la famille.</p>
  {object_examples_table}
</section>
<section id="helper">
  <h2>Ce que le « wrapper » représente réellement</h2>
  <p>Les adresses montrent une fonction flottante à deux passes qui appelle deux fois une routine interne à une passe. Le patch expérimental supprime l’un de ces appels internes ; les 493 sites recensés sont les fonctions qui invoquent le wrapper complet, et non 493 timers identiques.</p>
  <p>Cette distinction est essentielle : un appel peut appartenir à une porte, un bateau, un ennemi, une arme ou une correction géométrique sans que son nombre de passes doive nécessairement suivre le framerate. La cartographie ci-dessous décrit donc le contexte du caller et prépare une expérience contrôlée.</p>
  <p>La consolidation est néanmoins robuste : les {counts['multi_module_families']} familles présentes dans plusieurs PRX conservent toutes le même hash normalisé sur la totalité de leur fonction estimée, pas seulement sur les 96 premiers octets utilisés pour les découvrir.</p>
  {module_table}
</section>
<section id="focus">
  <h2>File de travail Pokitaru et Ryllus</h2>
  <p>Les deux premiers niveaux représentent {counts['focus_callsites']} callsites, regroupés en {counts['focus_families']} familles : {counts['shared_focus_families']} communes aux deux PRX, {counts['focus_l1_only_families']} propres à Pokitaru et {counts['focus_l2_only_families']} propres à Ryllus. Les catégories sont déduites de descripteurs d’objets, de chaînes référencées, du graphe d’appels et des patchs déjà établis ; elles ne valent pas encore verdict temporel.</p>
  <div class="toolbar"><input id="focusSearch" type="search" placeholder="Filtrer les familles L1/L2…"></div>
  <div id="focusTable">{focus_table}</div>
</section>
<section id="families">
  <h2>Catalogue détaillé des {counts['families']} familles</h2>
  <p>Une famille est formée par une fenêtre de 96 octets normalisée vis-à-vis des relocations MIPS. Le rapport indique également le nombre de variantes du hash de fonction complet : lorsque ce nombre dépasse un, seule l’entrée est identique et le corps ultérieur comporte des différences.</p>
  <div class="toolbar"><input id="familySearch" type="search" placeholder="Rechercher objet, niveau, patch…"><select id="strengthFilter"><option value="">Toutes les preuves</option><option>forte</option><option>moyenne</option><option>faible</option><option>indéterminée</option></select></div>
  {family_table}
  <h3>Fiches et assembleur</h3>
  <div id="familyCards">{''.join(details)}</div>
</section>
<section id="profiler">
  <h2>Passage à la validation dynamique</h2>
  <p>Le paquet contient désormais le cœur C généré du profiler, ses {counts['callsites']} clés <code>(module, $ra)</code>, un plan exact de redirection, un test exécutable sur PC, une configuration PPSSPP limitée à <code>UCES00420</code> et un squelette de module PSP. Le trampoline assembleur reste une étape explicite : il faut le compiler avec PSPSDK et vérifier la préservation de l’état CPU avant de le considérer sûr.</p>
  <p>La stratégie retenue ne modifie pas le prologue du wrapper. Dans le module actif, chaque <code>jal wrapper</code> connu est remplacé par un <code>jal profiler_hook</code> d’un seul mot, tandis que son delay slot reste intact. À l’arrivée, <code>$ra</code> identifie naturellement le callsite ; le hook compte l’appel, restaure les arguments puis effectue un tail-jump vers le wrapper original avec le même <code>$ra</code>. Le wrapper retourne donc directement au jeu comme avant.</p>
  <p class="plain"><strong>Image simple :</strong> au lieu d’ouvrir la machine centrale pour y placer un compteur, on change temporairement le numéro composé par chaque poste connu. Le standard intermédiaire note quel poste a appelé, puis transfère immédiatement l’appel vers le numéro original.</p>
  <ol>
    <li><strong>Détecter le module :</strong> comparer une petite empreinte de mots de code ; les PRX partagent la même base runtime et le seul nom interne ne suffit pas toujours.</li>
    <li><strong>Refuser si la signature diffère :</strong> comparer quatre mots à l’entrée, le mot de l’appel interne et tous les <code>jal</code> candidats avant la première écriture.</li>
    <li><strong>Tracer sans corriger :</strong> laisser la politique <code>VANILLA</code>, compter les appels par <code>$ra</code> et mémoriser les bornes temporelles.</li>
    <li><strong>Comparer A/B/C :</strong> 30 FPS vanilla, 60 FPS avec comportement deux passes, puis 60 FPS avec une seule famille candidate modifiée.</li>
    <li><strong>Décider sur deux axes :</strong> fréquence d’appel et effet gameplay mesuré — durée, distance, dégâts, ticks, collision ou état final.</li>
  </ol>
  <div class="note ok"><p><strong>Mémoire non interférente par conception :</strong> les tables vivent dans les données du PRX chargé, pas dans une adresse du jeu choisie parce qu’elle semblait vide. Le fichier <code>plugin.ini</code> n’active pas l’option PPSSPP <code>memory = 64</code>, car la documentation officielle avertit qu’elle modifie la carte mémoire et peut affecter les cheats ou la gestion mémoire du jeu.</p></div>
  <div class="note"><p>Un compteur qui double ne prouve pas à lui seul qu’il faut une passe : il faut aussi observer l’effet gameplay. Inversement, une famille appelée une fois par événement peut contenir une durée ou une impulsion qui exige un correctif local plutôt qu’une modification du helper.</p></div>
  <h3>Pourquoi commencer par PPSSPP</h3>
  <p>PPSSPP ne charge pas les plugins CFW traditionnels dépendants du noyau PSP, mais il prend en charge des plugins PRX spécifiques à l’émulateur. Ceux-ci peuvent appeler les mêmes fonctions utilisateur que le jeu et modifier sa RAM. Cela correspond bien à un premier prototype de profiler ; le port PSP réelle gardera le même cœur de lookup, avec un chargeur/bootstrap CFW séparé.</p>
  <p class="muted">Pour les essais, privilégier les sauvegardes internes du jeu : PPSSPP précise qu’un savestate peut conserver l’état d’un plugin même après sa mise à jour ou sa suppression.</p>
</section>
<section id="capabilities">
  <h2>Ce que je peux faire à partir de ce corpus</h2>
  <p>Le travail se divise entre analyse hors ligne, code généré, compilation PSP et expérimentation dans le jeu. Voici la frontière exacte, afin de ne pas confondre un composant préparé avec un PRX déjà validé en conditions réelles.</p>
  {capability_table}
  <div class="note"><p><strong>Ce dont j’aurai besoin plus tard :</strong> la version précise de PPSSPP, idéalement deux sauvegardes internes proches d’actions reproductibles sur Pokitaru et Ryllus, puis les traces produites. Rien de cela ne bloque la génération et la revue statique actuelles.</p></div>
</section>
<section id="glossary">
  <h2>Glossaire débutant → technique</h2>
  <p>La colonne centrale donne une intuition suffisante pour suivre le rapport. La dernière colonne conserve la formulation précise utile au développement du PRX.</p>
  {glossary_table}
</section>
<section id="limits">
  <h2>Limites et niveau de preuve</h2>
  <p>Les callsites, les opcodes, les relocations, les descripteurs et les adresses <code>$ra</code> sont des observations statiques exactes. Les bornes de fonction sont des estimations fondées sur les cibles de <code>jal</code> et les prologues de pile ; les liens d’objet à distance 1–3 sont des inférences de graphe, et les domaines gameplay restent des hypothèses lexicales documentées.</p>
  <p>Le rapport n’attribue donc encore aucune famille à <code>ONE_PASS</code> ou <code>TWO_PASS</code>. Cette retenue évite de reproduire à grande échelle l’effet secondaire du wrapper global : corriger des objets réellement exécutés deux fois trop vite, mais altérer simultanément des calculs déjà corrects, événementiels ou fondés sur un delta.</p>
  <p>Le squelette PSP livré n’est pas un <code>patch.prx</code> prêt à lancer. La chaîne PSPDEV/PSPSDK n’est pas disponible dans l’environnement ayant généré ce paquet ; le cœur portable est testable avec un compilateur C de bureau, tandis que le trampoline Allegrex, la synchronisation des caches et le cycle chargement/déchargement des PRX de niveau doivent encore être compilés puis observés dans PPSSPP.</p>
</section>
<section id="references">
  <h2>Références techniques primaires</h2>
  <ul class="sources">
    <li><a href="https://www.gog.com/blog/preserving-sands-of-time/">GOG — Preserving Sands of Time</a> : distinction explicite entre infrastructure DirectX 9 réutilisable et reverse engineering propre à chaque jeu.</li>
    <li><a href="https://www.ppsspp.org/docs/reference/plugins/">PPSSPP — Plugins</a> : format <code>plugin.ini</code>, portée des PRX utilisateur, installation, mémoire additionnelle et prudence avec les savestates.</li>
    <li><a href="https://github.com/hrydgard/ppsspp/pull/13335">PPSSPP — pull request #13335</a> : ajout historique du chargement des plugins PRX spécifiques aux jeux.</li>
    <li><a href="https://github.com/xan1242/PSPModBase">PSPModBase</a> : base de code pour injection PSP, compilation PSPDEV et séparation entre chargement PPSSPP et bootstrap CFW.</li>
    <li><a href="https://pspdev.github.io/pspsdk/group__Utils.html">PSPSDK — Utils</a> : API officielles de writeback/invalidation des caches données et instructions nécessaires après modification de code.</li>
    <li><a href="https://github.com/pspdev/pspsdk/blob/master/src/user/pspmodulemgr.h">PSPSDK — pspmodulemgr.h</a> : énumération et interrogation des modules utilisateur chargés.</li>
  </ul>
</section>
<section id="downloads">
  <h2>Tables et données</h2>
  <div class="downloads">
    <a href="tables/wrapper_families.csv">{counts['families']} familles agrégées</a>
    <a href="tables/wrapper_family_members.csv">Fonctions membres</a>
    <a href="tables/wrapper_callsites.csv">493 callsites et contextes</a>
    <a href="tables/profiler_ra_lookup.csv">Table $ra pour le profiler</a>
    <a href="tables/object_descriptors.csv">Descripteurs d’objets récupérés</a>
    <a href="tables/family_patch_relations.csv">Patchs dans les mêmes fonctions</a>
    <a href="tables/family_data_references.csv">Chaînes et constantes flottantes</a>
    <a href="tables/family_callees.csv">Graphe d’appels direct</a>
    <a href="data/catalog.json">Catalogue JSON consolidé</a>
    <a href="data/validation.json">Contrôles de cohérence</a>
    <a href="METHODOLOGY.md">Méthode et prudence d’interprétation</a>
    <a href="PROFILER_SPEC.md">Spécification du profiler MIPS</a>
    <a href="profiler/README.md">Profiler : état, compilation et prochaines étapes</a>
    <a href="profiler/HOOK_DESIGN.md">Choix détaillé du hook par redirection des callsites</a>
    <a href="profiler/callsite_redirect_plan.csv">Plan exact des 493 redirections à un mot</a>
    <a href="profiler/generated/wrapper_profiles.generated.c">Tables C générées pour les {counts['callsites']} callsites</a>
    <a href="profiler/src/rcsm_profiler_core.c">Cœur C portable du lookup</a>
    <a href="profiler/tests/test_profiler_core.c">Test hôte du profiler</a>
    <a href="profiler/HOST_VALIDATION.json">Résultat de compilation/exécution du test hôte</a>
    <a href="profiler/plugin.ini">Configuration PPSSPP UCES00420</a>
    <a href="profiler/trace_schema.json">Format de trace documenté</a>
  </div>
</section>
</main>
<footer><p class="muted">Généré en UTC le {h(generated)}. Le paquet ne contient aucun binaire du jeu.</p></footer>
<script>
function filterTable(root, query){{root.querySelectorAll('tbody tr').forEach(row=>{{row.hidden=!row.textContent.toLowerCase().includes(query)}})}}
document.getElementById('focusSearch').addEventListener('input',e=>filterTable(document.getElementById('focusTable'),e.target.value.toLowerCase()));
function filterFamilies(){{const q=document.getElementById('familySearch').value.toLowerCase();const s=document.getElementById('strengthFilter').value.toLowerCase();document.querySelectorAll('#familyCards>.family-card').forEach(card=>{{const text=card.dataset.search.toLowerCase();card.hidden=!(text.includes(q)&&text.includes(s))}})}}
document.getElementById('familySearch').addEventListener('input',filterFamilies);document.getElementById('strengthFilter').addEventListener('change',filterFamilies);
</script>
</body>
</html>"""


def methodology_text() -> str:
    return """# Méthode — catalogue des familles du wrapper

## Coordonnées et regroupement

Les modules PRX sont lus comme des ELF32 MIPS little-endian. Les 493 instructions `jal` dirigées vers l’entrée runtime du helper à deux passes sont des coordonnées exactes ; l’adresse de retour enregistrée par MIPS est calculée par `$ra = PC + 8`, le mot situé à `PC + 4` étant le delay slot.

Une fonction parente est estimée à partir de la plus proche entrée forte antérieure : cible directe de `jal`, entrypoint ou prologue `addiu $sp,$sp,-N`. La borne finale est l’entrée forte suivante. Cette approximation est conservatrice et signalée comme telle dans les tables.

Un appel de `LEVEL_03` dépassait de 0xD4 octets l’ancienne limite arbitraire de recherche fixée à 0x2000. Son parent est désormais confirmé par un prologue réel, une borne suivante cohérente et un descripteur de callback exact `Lvl3Platform` : la fonction mesure 0x2A08 octets et porte le total global de 58 à 59 familles, sans modifier le sous-ensemble Pokitaru/Ryllus.

Les familles utilisent le hash SHA-256 d’une fenêtre de 96 octets dont chaque mot relocalisé est remplacé par son type de relocation. Cela absorbe les changements d’adresse entre PRX. Le hash normalisé du corps estimé complet est fourni séparément pour révéler les familles dont seule l’entrée est identique.

## Références sémantiques

Les couples `R_MIPS_HI16` / `R_MIPS_LO16` sont reconstitués pour récupérer les adresses de chaînes et de constantes chargées depuis `.rodata` ou `.data`. Les chemins source, noms symboliques et schémas de PVars sont classés sans modifier les octets d’origine.

Les descripteurs d’objets sont reconnus dans `.data` lorsqu’un pointeur relocalisé vise un identifiant en `.rodata`, suivi d’au moins deux callbacks visant `.text`. Cette structure permet par exemple de relier directement une fonction à `Level01Boat`, `TriggeredDoor` ou `Level02ExpandableBridge`. Un parcours inverse du graphe de `jal`, limité à trois arêtes, rattache ensuite certaines sous-fonctions à leurs callbacks parents ; ce lien est une inférence et sa distance reste visible.

Les patchs v0.2.1 sont associés à la même fonction estimée lorsqu’ils résident dans `.text`. Une catégorie `WEAPONS`, `BREAKABLES` ou `PARTICLES` située dans les mêmes bornes constitue un indice sémantique fort, mais ne prouve pas que l’appel du helper doit adopter une passe particulière.

## Interprétation

Le niveau **fort** correspond à un descripteur d’objet directement relié ou à un patch connu dans la même fonction. Le niveau **moyen** correspond à un nom symbolique direct ou à un callback parent distant d’au plus deux appels ; le niveau **faible** désigne uniquement un parent à trois appels. Sans ces éléments, la famille demeure indéterminée.

Toutes les familles commencent avec la politique `VANILLA_UNTIL_PROFILED`. La structure statique peut identifier le contexte et réduire l’espace de recherche, mais elle ne peut pas déterminer de façon générale si une logique est par frame, fondée sur un delta, exécutée à tick fixe ou déclenchée par événement.

## Exclusion des données du jeu

Le paquet généré contient uniquement des rapports, tables, hashes, extraits assembleur textuels et scripts d’analyse. Il exclut explicitement les extensions PRX, BIN, WAD, DUMP, GZF, PAK, textures et archives sources.
"""


def profiler_spec_text(counts: dict[str, Any]) -> str:
    return f"""# Spécification de travail — profiler MIPS du wrapper

## Objectif

Le profiler ne choisit pas encore la correction. Il mesure quels callsites atteignent le helper pendant une scène, à quelle fréquence et sur quelle plage de frames, puis restitue une table compacte après le test.

## Clé de lookup

Chaque `jal wrapper` connu du module actif est redirigé vers le trampoline par un seul mot, sans toucher à son delay slot. Le trampoline capture `$ra` dès son entrée ; pour un `jal` MIPS, cette valeur est l’adresse de l’instruction d’appel plus 8 octets. `tables/profiler_ra_lookup.csv` contient les {counts['callsites']} clés attendues, regroupées par index de module et famille.

## Structures générées

```c
typedef struct RcsmCallsiteProfile {{
    uint32_t ra;
    uint16_t family_id;
    uint8_t  policy;
    uint8_t  flags;
}} RcsmCallsiteProfile;     // 8 octets

typedef struct RcsmTraceStat {{
    uint32_t hits;
    uint32_t first_sample;
    uint32_t last_sample;
}} RcsmTraceStat;           // 12 octets
```

Les {counts['callsites']} profils immuables représentent {counts['callsites'] * 8} octets. Seules {PROFILER_TABLE_CAPACITY} statistiques sont actives à la fois, soit {PROFILER_TABLE_CAPACITY * PROFILER_ENTRY_BYTES} octets. Le maximum observé est de {counts['max_callsites_per_module']} callsites dans un module ; les appels inconnus disposent d’un compteur séparé. Cette organisation n’alloue rien sur le chemin chaud.

## Sécurité attendue

Avant d’installer les redirections, le runtime doit vérifier l’identifiant du jeu, une empreinte du module, quatre mots à l’entrée du helper, le mot du second appel interne et tous les `jal` candidats. Une divergence impose un retour vanilla sans aucune écriture ; après chaque mot modifié, les caches données et instructions doivent être synchronisés par les API PSP prévues.

Le stockage ne doit pas occuper arbitrairement une zone RAM simplement observée à zéro. Les tables et compteurs livrés sont des données du PRX : le chargeur leur attribue sa propre mémoire. Leur coût complet, code et pile compris, devra malgré tout être mesuré sur PPSSPP avant tout essai sur PSP réelle.

## État de l’implémentation

Le dossier `profiler/` contient les tables C générées, le lookup binaire, les compteurs, l’identification du module par empreinte, un test hôte et un squelette PRX de découverte. Il ne contient pas encore le trampoline Allegrex : aucun binaire `patch.prx` prêt à profiler n’est revendiqué.

## Protocole A/B/C

1. A — 30 FPS vanilla, scène reproductible pendant environ dix secondes.
2. B — 60 FPS avec le socle et le wrapper deux passes.
3. C — 60 FPS avec une seule famille candidate modifiée.

Les compteurs doivent être accompagnés d’une mesure de l’effet : distance, durée, dégâts, nombre de ticks, cadence ou état final. Une fréquence doublée n’est qu’un indice ; la politique `ONE_PASS`, `TWO_PASS`, `CUSTOM` ou `VANILLA` est attribuée après comparaison des deux dimensions.
"""


def readme_text(package_name: str, counts: dict[str, Any]) -> str:
    return f"""# {package_name}

Catalogue reproductible et sans binaire du jeu pour le helper flottant utilisé dans les PRX de niveau de *Ratchet & Clank: Size Matters* UCES-00420.

- {counts['callsites']} callsites exacts ;
- {counts['families']} familles globales ;
- {counts['focus_families']} familles présentes dans Pokitaru ou Ryllus ;
- {counts['descriptors']} descripteurs d’objets récupérés ;
- table `$ra` directement exploitable par le futur profiler.

Ouvrir `index.html` pour la lecture principale. Les tables CSV et le JSON consolidé permettent de poursuivre l’analyse ou de générer des profils PRX sans reprendre le reverse engineering depuis zéro.
"""


def build_profiler_fingerprints(catalog: dict[str, Any]) -> dict[str, Any]:
    """Choose a small deterministic set of code words that identifies profiles.

    LEVEL_15 and LEVEL_21 are byte-identical for the mapped wrapper callers and
    intentionally remain an equivalent pair: either lookup table produces the
    same result.  Profiles with different lookups must be separated.
    """

    anatomies = sorted(catalog["wrapper_anatomy"], key=lambda row: int(row["module_index"]))
    indices = [int(row["module_index"]) for row in anatomies]
    contexts = {ctx["module"].module_index: ctx for ctx in catalog["contexts"].values()}
    bases = {contexts[index]["module"].runtime_base for index in indices}
    if len(bases) != 1:
        raise RuntimeError("Les profils runtime n’utilisent pas une base commune")
    runtime_base = next(iter(bases))

    lookup_by_module: dict[int, tuple[tuple[int, str], ...]] = {}
    for index in indices:
        lookup_by_module[index] = tuple(
            (int(row["mips_ra_runtime"], 16), row["family_id"])
            for row in catalog["profiler_lookup"]
            if int(row["module_index"]) == index
        )

    text_sizes = {
        index: next(section.size for section in contexts[index]["elf"].sections if section.name == ".text")
        for index in indices
    }
    common_size = min(text_sizes.values())
    patched_rvas = {
        int(row["callsite_runtime"], 16) - runtime_base
        for row in catalog["callsites"]
        if 0 <= int(row["callsite_runtime"], 16) - runtime_base <= common_size - 4
    }
    guarded_rvas: set[int] = set()
    for anatomy in anatomies:
        entry_rva = int(anatomy["two_pass_entry_runtime"], 16) - runtime_base
        guarded_rvas.update(entry_rva + offset for offset in (0, 4, 8, 12))
        guarded_rvas.add(int(anatomy["internal_call_suppression_site_runtime"], 16) - runtime_base)
    relocated_rvas: set[int] = set()
    for index in indices:
        relocated_rvas.update(contexts[index]["text_relocations"])
    # Detection words must remain unchanged both after loading and after
    # callsite redirection.  Exclude every relocated word: comparing the raw
    # PRX operand with the post-relocation runtime instruction was the cause of
    # the v0.4.0 detector failure observed in PPSSPP.
    candidate_rvas = {
        rva
        for rva in range(0, common_size - 3, 0x100)
        if rva not in patched_rvas and rva not in guarded_rvas and rva not in relocated_rvas
    }

    values: dict[int, tuple[int, ...]] = {
        runtime_base + rva: tuple(contexts[index]["elf"].read_u32(rva) for index in indices)
        for rva in sorted(candidate_rvas)
    }
    uncovered = {
        (left, right)
        for pos, left in enumerate(indices)
        for right in indices[pos + 1 :]
        if lookup_by_module[left] != lookup_by_module[right]
    }
    anchors: list[int] = []
    while uncovered:
        best_address = None
        best_pairs: set[tuple[int, int]] = set()
        for address, words in values.items():
            separated = {
                pair
                for pair in uncovered
                if words[indices.index(pair[0])] != words[indices.index(pair[1])]
            }
            if len(separated) > len(best_pairs):
                best_address = address
                best_pairs = separated
        if best_address is None or not best_pairs:
            break
        anchors.append(best_address)
        uncovered.difference_update(best_pairs)
        values.pop(best_address)
    if uncovered:
        raise RuntimeError(f"Empreinte module incomplète : {len(uncovered)} paire(s) non séparée(s)")
    if len(anchors) > 32:
        raise RuntimeError(f"Empreinte module trop grande : {len(anchors)} ancres")

    expected = {
        index: [contexts[index]["elf"].read_u32(address - runtime_base) for address in anchors]
        for index in indices
    }
    equivalent_pairs = [
        [left, right]
        for pos, left in enumerate(indices)
        for right in indices[pos + 1 :]
        if lookup_by_module[left] == lookup_by_module[right]
    ]
    return {
        "runtime_base": runtime_base,
        "anchors": anchors,
        "expected": expected,
        "equivalent_pairs": equivalent_pairs,
    }


def profiler_core_header_text() -> str:
    return r"""#ifndef RCSM_PROFILER_CORE_H
#define RCSM_PROFILER_CORE_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define RCSM_MAX_ACTIVE_CALLS 64u
#define RCSM_MAX_DETECTION_ANCHORS 32u

typedef enum RcsmPolicy {
    RCSM_POLICY_VANILLA = 0,
    RCSM_POLICY_TWO_PASS = 1,
    RCSM_POLICY_ONE_PASS = 2,
    RCSM_POLICY_CUSTOM = 3
} RcsmPolicy;

typedef struct RcsmCallsiteProfile {
    uint32_t ra;
    uint16_t family_id;
    uint8_t policy;
    uint8_t flags;
} RcsmCallsiteProfile;

typedef struct RcsmModuleProfile {
    uint8_t module_index;
    uint8_t reserved;
    uint16_t callsite_count;
    const char *module_key;
    uint32_t two_pass_entry;
    uint32_t one_pass_inner;
    uint32_t suppression_site;
    uint32_t expected_entry_words[4];
    uint32_t expected_suppression_word; /* Raw PRX word before R_MIPS_26. */
    const uint32_t *expected_detection_words;
    const RcsmCallsiteProfile *callsites;
} RcsmModuleProfile;

typedef struct RcsmTraceStat {
    uint32_t hits;
    uint32_t first_sample;
    uint32_t last_sample;
} RcsmTraceStat;

typedef struct RcsmProfiler {
    const RcsmModuleProfile *profile;
    RcsmTraceStat stats[RCSM_MAX_ACTIVE_CALLS];
    uint32_t unknown_hits;
} RcsmProfiler;

typedef int (*RcsmReadWord)(uint32_t address, uint32_t *value, void *user);
typedef int (*RcsmWriteWord)(uint32_t address, uint32_t value, void *user);
typedef void (*RcsmSyncCode)(uint32_t address, uint32_t size, void *user);

typedef struct RcsmPatchResult {
    uint16_t examined;
    uint16_t modified;
    uint16_t mismatched;
    uint16_t rolled_back;
} RcsmPatchResult;

const RcsmModuleProfile *rcsm_find_module_profile(uint8_t module_index);
int rcsm_profiles_equivalent(const RcsmModuleProfile *left, const RcsmModuleProfile *right);
const RcsmModuleProfile *rcsm_identify_module(RcsmReadWord reader, void *user, unsigned *equivalent_matches);
int rcsm_validate_profile(const RcsmModuleProfile *profile);
int rcsm_bind_profile(RcsmProfiler *profiler, const RcsmModuleProfile *profile);
int rcsm_record_hit(RcsmProfiler *profiler, uint32_t ra, uint32_t sample);
const RcsmTraceStat *rcsm_stat_at(const RcsmProfiler *profiler, size_t index);
uint32_t rcsm_encode_jal(uint32_t target);
int rcsm_jal_reachable(uint32_t callsite, uint32_t target);
int rcsm_install_callsite_redirects(
    const RcsmModuleProfile *profile,
    uint32_t hook_target,
    RcsmReadWord reader,
    RcsmWriteWord writer,
    RcsmSyncCode sync,
    void *user,
    RcsmPatchResult *result
);
int rcsm_remove_callsite_redirects(
    const RcsmModuleProfile *profile,
    uint32_t hook_target,
    RcsmReadWord reader,
    RcsmWriteWord writer,
    RcsmSyncCode sync,
    void *user,
    RcsmPatchResult *result
);

#ifdef __cplusplus
}
#endif

#endif
"""


def profiler_generated_header_text() -> str:
    return r"""#ifndef RCSM_WRAPPER_PROFILES_GENERATED_H
#define RCSM_WRAPPER_PROFILES_GENERATED_H

#include "rcsm_profiler_core.h"

extern const uint32_t g_rcsm_reference_level_base;
extern const uint32_t g_rcsm_detection_addresses[];
extern const size_t g_rcsm_detection_anchor_count;
extern const RcsmModuleProfile g_rcsm_module_profiles[];
extern const size_t g_rcsm_module_profile_count;
extern const size_t g_rcsm_total_callsite_count;

#endif
"""


def profiler_generated_source_text(catalog: dict[str, Any], fingerprints: dict[str, Any]) -> str:
    lookups: dict[int, list[dict[str, Any]]] = defaultdict(list)
    for row in catalog["profiler_lookup"]:
        lookups[int(row["module_index"])].append(row)
    anatomies = sorted(catalog["wrapper_anatomy"], key=lambda row: int(row["module_index"]))
    parts = [
        "/* Generated from the UCES-00420 corpus. Do not edit by hand. */\n",
        '#include "wrapper_profiles.generated.h"\n\n',
        f"const uint32_t g_rcsm_reference_level_base = 0x{fingerprints['runtime_base']:08X}u;\n",
        "const uint32_t g_rcsm_detection_addresses[] = {\n",
    ]
    parts.extend(f"    0x{address:08X}u,\n" for address in fingerprints["anchors"])
    parts.append("};\n")
    parts.append(f"const size_t g_rcsm_detection_anchor_count = {len(fingerprints['anchors'])}u;\n\n")

    for anatomy in anatomies:
        index = int(anatomy["module_index"])
        rows = sorted(lookups[index], key=lambda row: int(row["mips_ra_runtime"], 16))
        parts.append(f"static const RcsmCallsiteProfile kModule{index}Callsites[] = {{\n")
        for row in rows:
            family_number = int(row["family_id"].split("-")[1])
            parts.append(
                f"    {{{row['mips_ra_runtime']}u, {family_number}u, RCSM_POLICY_VANILLA, 0u}},\n"
            )
        parts.append("};\n")
        parts.append(f"static const uint32_t kModule{index}DetectionWords[] = {{\n")
        parts.extend(f"    0x{word:08X}u,\n" for word in fingerprints["expected"][index])
        parts.append("};\n\n")

    parts.append("const RcsmModuleProfile g_rcsm_module_profiles[] = {\n")
    for anatomy in anatomies:
        index = int(anatomy["module_index"])
        entry_words = ", ".join(f"{anatomy[f'entry_word_{word}']}u" for word in range(4))
        parts.append(
            "    {"
            f"{index}u, 0u, {len(lookups[index])}u, \"{anatomy['module_key']}\", "
            f"{anatomy['two_pass_entry_runtime']}u, {anatomy['one_pass_inner_runtime']}u, "
            f"{anatomy['internal_call_suppression_site_runtime']}u, "
            f"{{{entry_words}}}, {anatomy['original_word_at_suppression_site']}u, "
            f"kModule{index}DetectionWords, kModule{index}Callsites"
            "},\n"
        )
    parts.append("};\n")
    parts.append(f"const size_t g_rcsm_module_profile_count = {len(anatomies)}u;\n")
    parts.append(f"const size_t g_rcsm_total_callsite_count = {len(catalog['profiler_lookup'])}u;\n")
    return "".join(parts)


def profiler_core_source_text() -> str:
    return r"""#include "rcsm_profiler_core.h"
#include "wrapper_profiles.generated.h"

#include <string.h>

const RcsmModuleProfile *rcsm_find_module_profile(uint8_t module_index) {
    size_t index;
    for (index = 0; index < g_rcsm_module_profile_count; ++index) {
        if (g_rcsm_module_profiles[index].module_index == module_index) {
            return &g_rcsm_module_profiles[index];
        }
    }
    return NULL;
}

int rcsm_profiles_equivalent(const RcsmModuleProfile *left, const RcsmModuleProfile *right) {
    size_t index;
    if (left == NULL || right == NULL || left->callsite_count != right->callsite_count) {
        return 0;
    }
    for (index = 0; index < left->callsite_count; ++index) {
        const RcsmCallsiteProfile *a = &left->callsites[index];
        const RcsmCallsiteProfile *b = &right->callsites[index];
        if (a->ra != b->ra || a->family_id != b->family_id || a->policy != b->policy) {
            return 0;
        }
    }
    return 1;
}

int rcsm_validate_profile(const RcsmModuleProfile *profile) {
    size_t index;
    if (profile == NULL || profile->callsites == NULL || profile->expected_detection_words == NULL) {
        return 0;
    }
    if (profile->callsite_count == 0u || profile->callsite_count > RCSM_MAX_ACTIVE_CALLS) {
        return 0;
    }
    for (index = 0; index < profile->callsite_count; ++index) {
        const RcsmCallsiteProfile *entry = &profile->callsites[index];
        if (entry->family_id == 0u || entry->family_id > 59u || entry->policy > RCSM_POLICY_CUSTOM) {
            return 0;
        }
        if (index > 0u && profile->callsites[index - 1u].ra >= entry->ra) {
            return 0;
        }
    }
    return 1;
}

const RcsmModuleProfile *rcsm_identify_module(RcsmReadWord reader, void *user, unsigned *equivalent_matches) {
    uint32_t observed[RCSM_MAX_DETECTION_ANCHORS];
    const RcsmModuleProfile *first = NULL;
    size_t profile_index;
    size_t anchor_index;
    unsigned matches = 0u;

    if (equivalent_matches != NULL) {
        *equivalent_matches = 0u;
    }
    if (reader == NULL || g_rcsm_detection_anchor_count > RCSM_MAX_DETECTION_ANCHORS) {
        return NULL;
    }
    for (anchor_index = 0; anchor_index < g_rcsm_detection_anchor_count; ++anchor_index) {
        if (reader(g_rcsm_detection_addresses[anchor_index], &observed[anchor_index], user) != 0) {
            return NULL;
        }
    }
    for (profile_index = 0; profile_index < g_rcsm_module_profile_count; ++profile_index) {
        const RcsmModuleProfile *profile = &g_rcsm_module_profiles[profile_index];
        uint32_t word;
        int match = 1;
        for (anchor_index = 0; anchor_index < g_rcsm_detection_anchor_count; ++anchor_index) {
            if (observed[anchor_index] != profile->expected_detection_words[anchor_index]) {
                match = 0;
                break;
            }
        }
        if (!match) {
            continue;
        }
        for (anchor_index = 0; anchor_index < 4u; ++anchor_index) {
            if (reader(profile->two_pass_entry + (uint32_t)(anchor_index * 4u), &word, user) != 0 ||
                word != profile->expected_entry_words[anchor_index]) {
                match = 0;
                break;
            }
        }
        /* The stored word comes from the raw PRX before R_MIPS_26.  Compare
           memory with the relocated runtime jal instead. */
        if (match && (reader(profile->suppression_site, &word, user) != 0 ||
                      word != rcsm_encode_jal(profile->one_pass_inner))) {
            match = 0;
        }
        if (!match) {
            continue;
        }
        if (first == NULL) {
            first = profile;
        } else if (!rcsm_profiles_equivalent(first, profile)) {
            return NULL;
        }
        ++matches;
    }
    if (equivalent_matches != NULL) {
        *equivalent_matches = matches;
    }
    return first;
}

int rcsm_bind_profile(RcsmProfiler *profiler, const RcsmModuleProfile *profile) {
    if (profiler == NULL || !rcsm_validate_profile(profile)) {
        return 0;
    }
    memset(profiler, 0, sizeof(*profiler));
    profiler->profile = profile;
    return 1;
}

int rcsm_record_hit(RcsmProfiler *profiler, uint32_t ra, uint32_t sample) {
    size_t low = 0u;
    size_t high;
    if (profiler == NULL || profiler->profile == NULL) {
        return -1;
    }
    high = profiler->profile->callsite_count;
    while (low < high) {
        size_t middle = low + (high - low) / 2u;
        uint32_t candidate = profiler->profile->callsites[middle].ra;
        if (candidate < ra) {
            low = middle + 1u;
        } else {
            high = middle;
        }
    }
    if (low >= profiler->profile->callsite_count || profiler->profile->callsites[low].ra != ra) {
        if (profiler->unknown_hits != 0xFFFFFFFFu) {
            ++profiler->unknown_hits;
        }
        return -1;
    }
    if (profiler->stats[low].hits == 0u) {
        profiler->stats[low].first_sample = sample;
    }
    if (profiler->stats[low].hits != 0xFFFFFFFFu) {
        ++profiler->stats[low].hits;
    }
    profiler->stats[low].last_sample = sample;
    return (int)low;
}

const RcsmTraceStat *rcsm_stat_at(const RcsmProfiler *profiler, size_t index) {
    if (profiler == NULL || profiler->profile == NULL || index >= profiler->profile->callsite_count) {
        return NULL;
    }
    return &profiler->stats[index];
}

uint32_t rcsm_encode_jal(uint32_t target) {
    return 0x0C000000u | ((target >> 2u) & 0x03FFFFFFu);
}

int rcsm_jal_reachable(uint32_t callsite, uint32_t target) {
    return (target & 3u) == 0u && ((callsite + 4u) & 0xF0000000u) == (target & 0xF0000000u);
}

int rcsm_install_callsite_redirects(
    const RcsmModuleProfile *profile,
    uint32_t hook_target,
    RcsmReadWord reader,
    RcsmWriteWord writer,
    RcsmSyncCode sync,
    void *user,
    RcsmPatchResult *result
) {
    RcsmPatchResult local = {0u, 0u, 0u, 0u};
    uint32_t original_word;
    uint32_t hook_word;
    size_t index;
    if (result != NULL) {
        *result = local;
    }
    if (!rcsm_validate_profile(profile) || reader == NULL || writer == NULL) {
        return 0;
    }
    original_word = rcsm_encode_jal(profile->two_pass_entry);
    hook_word = rcsm_encode_jal(hook_target);

    /* Preflight every site before the first write: all-or-nothing on mismatch. */
    for (index = 0; index < profile->callsite_count; ++index) {
        uint32_t word = 0u;
        uint32_t site = profile->callsites[index].ra - 8u;
        ++local.examined;
        if (!rcsm_jal_reachable(site, hook_target) || reader(site, &word, user) != 0 || word != original_word) {
            ++local.mismatched;
        }
    }
    if (local.mismatched != 0u) {
        if (result != NULL) {
            *result = local;
        }
        return 0;
    }

    for (index = 0; index < profile->callsite_count; ++index) {
        uint32_t site = profile->callsites[index].ra - 8u;
        if (writer(site, hook_word, user) != 0) {
            size_t rollback;
            for (rollback = 0; rollback < index; ++rollback) {
                uint32_t previous_site = profile->callsites[rollback].ra - 8u;
                if (writer(previous_site, original_word, user) == 0) {
                    ++local.rolled_back;
                    if (sync != NULL) {
                        sync(previous_site, 4u, user);
                    }
                }
            }
            if (result != NULL) {
                *result = local;
            }
            return 0;
        }
        ++local.modified;
        if (sync != NULL) {
            sync(site, 4u, user);
        }
    }
    if (result != NULL) {
        *result = local;
    }
    return 1;
}

int rcsm_remove_callsite_redirects(
    const RcsmModuleProfile *profile,
    uint32_t hook_target,
    RcsmReadWord reader,
    RcsmWriteWord writer,
    RcsmSyncCode sync,
    void *user,
    RcsmPatchResult *result
) {
    RcsmPatchResult local = {0u, 0u, 0u, 0u};
    uint32_t original_word;
    uint32_t hook_word;
    size_t index;
    if (result != NULL) {
        *result = local;
    }
    if (!rcsm_validate_profile(profile) || reader == NULL || writer == NULL) {
        return 0;
    }
    original_word = rcsm_encode_jal(profile->two_pass_entry);
    hook_word = rcsm_encode_jal(hook_target);
    for (index = 0; index < profile->callsite_count; ++index) {
        uint32_t word = 0u;
        uint32_t site = profile->callsites[index].ra - 8u;
        ++local.examined;
        if (reader(site, &word, user) != 0) {
            ++local.mismatched;
            continue;
        }
        if (word == original_word) {
            continue;
        }
        if (word != hook_word || writer(site, original_word, user) != 0) {
            ++local.mismatched;
            continue;
        }
        ++local.modified;
        if (sync != NULL) {
            sync(site, 4u, user);
        }
    }
    if (result != NULL) {
        *result = local;
    }
    return local.mismatched == 0u;
}
"""


def profiler_host_test_text() -> str:
    return r"""#include "rcsm_profiler_core.h"
#include "wrapper_profiles.generated.h"

#include <assert.h>
#include <stdio.h>

typedef struct TestMemory {
    const RcsmModuleProfile *profile;
} TestMemory;

typedef struct PatchMemory {
    uint32_t addresses[RCSM_MAX_ACTIVE_CALLS];
    uint32_t words[RCSM_MAX_ACTIVE_CALLS];
    size_t count;
    size_t syncs;
} PatchMemory;

static int read_test_word(uint32_t address, uint32_t *value, void *user) {
    const TestMemory *memory = (const TestMemory *)user;
    size_t index;
    for (index = 0; index < g_rcsm_detection_anchor_count; ++index) {
        if (g_rcsm_detection_addresses[index] == address) {
            *value = memory->profile->expected_detection_words[index];
            return 0;
        }
    }
    for (index = 0; index < 4u; ++index) {
        if (memory->profile->two_pass_entry + (uint32_t)(index * 4u) == address) {
            *value = memory->profile->expected_entry_words[index];
            return 0;
        }
    }
    if (memory->profile->suppression_site == address) {
        *value = rcsm_encode_jal(memory->profile->one_pass_inner);
        return 0;
    }
    return -1;
}

static int read_patch_word(uint32_t address, uint32_t *value, void *user) {
    PatchMemory *memory = (PatchMemory *)user;
    size_t index;
    for (index = 0; index < memory->count; ++index) {
        if (memory->addresses[index] == address) {
            *value = memory->words[index];
            return 0;
        }
    }
    return -1;
}

static int write_patch_word(uint32_t address, uint32_t value, void *user) {
    PatchMemory *memory = (PatchMemory *)user;
    size_t index;
    for (index = 0; index < memory->count; ++index) {
        if (memory->addresses[index] == address) {
            memory->words[index] = value;
            return 0;
        }
    }
    return -1;
}

static void sync_patch_word(uint32_t address, uint32_t size, void *user) {
    PatchMemory *memory = (PatchMemory *)user;
    (void)address;
    assert(size == 4u);
    ++memory->syncs;
}

int main(void) {
    size_t module_index;
    size_t total = 0u;
    size_t maximum = 0u;
    RcsmProfiler profiler;

    assert(g_rcsm_module_profile_count == 15u);
    assert(g_rcsm_total_callsite_count == 493u);
    assert(g_rcsm_detection_anchor_count > 0u);
    assert(g_rcsm_detection_anchor_count <= RCSM_MAX_DETECTION_ANCHORS);

    for (module_index = 0; module_index < g_rcsm_module_profile_count; ++module_index) {
        const RcsmModuleProfile *profile = &g_rcsm_module_profiles[module_index];
        const RcsmModuleProfile *identified;
        TestMemory memory = {profile};
        unsigned matches = 0u;
        size_t callsite_index;
        assert(rcsm_validate_profile(profile));
        assert(rcsm_find_module_profile(profile->module_index) == profile);
        assert(profile->expected_suppression_word != rcsm_encode_jal(profile->one_pass_inner));
        identified = rcsm_identify_module(read_test_word, &memory, &matches);
        assert(identified != NULL);
        assert(matches >= 1u);
        assert(rcsm_profiles_equivalent(identified, profile));
        total += profile->callsite_count;
        if (profile->callsite_count > maximum) {
            maximum = profile->callsite_count;
        }
        for (callsite_index = 0; callsite_index < profile->callsite_count; ++callsite_index) {
            assert(profile->callsites[callsite_index].family_id >= 1u);
            assert(profile->callsites[callsite_index].family_id <= 59u);
            assert(profile->callsites[callsite_index].policy == RCSM_POLICY_VANILLA);
        }
    }
    assert(total == 493u);
    assert(maximum == 57u);

    assert(rcsm_bind_profile(&profiler, rcsm_find_module_profile(1u)));
    {
        uint32_t ra = profiler.profile->callsites[0].ra;
        int slot = rcsm_record_hit(&profiler, ra, 100u);
        assert(slot == 0);
        assert(rcsm_record_hit(&profiler, ra, 125u) == 0);
        assert(profiler.stats[0].hits == 2u);
        assert(profiler.stats[0].first_sample == 100u);
        assert(profiler.stats[0].last_sample == 125u);
    }
    assert(rcsm_record_hit(&profiler, 0xDEADBEEFu, 130u) == -1);
    assert(profiler.unknown_hits == 1u);
    assert(rcsm_stat_at(&profiler, profiler.profile->callsite_count) == NULL);

    {
        const RcsmModuleProfile *profile = rcsm_find_module_profile(1u);
        const uint32_t hook_target = 0x08810000u;
        const uint32_t original_word = rcsm_encode_jal(profile->two_pass_entry);
        const uint32_t hook_word = rcsm_encode_jal(hook_target);
        RcsmPatchResult result;
        PatchMemory memory = {{0u}, {0u}, profile->callsite_count, 0u};
        size_t index;
        for (index = 0; index < memory.count; ++index) {
            memory.addresses[index] = profile->callsites[index].ra - 8u;
            memory.words[index] = original_word;
            assert(rcsm_jal_reachable(memory.addresses[index], hook_target));
        }
        assert(rcsm_install_callsite_redirects(
            profile, hook_target, read_patch_word, write_patch_word, sync_patch_word, &memory, &result
        ));
        assert(result.examined == profile->callsite_count);
        assert(result.modified == profile->callsite_count);
        assert(memory.syncs == profile->callsite_count);
        for (index = 0; index < memory.count; ++index) {
            assert(memory.words[index] == hook_word);
        }
        assert(rcsm_remove_callsite_redirects(
            profile, hook_target, read_patch_word, write_patch_word, sync_patch_word, &memory, &result
        ));
        assert(result.modified == profile->callsite_count);
        for (index = 0; index < memory.count; ++index) {
            assert(memory.words[index] == original_word);
        }

        /* One mismatched word must block the complete installation preflight. */
        memory.words[0] = 0u;
        memory.syncs = 0u;
        assert(!rcsm_install_callsite_redirects(
            profile, hook_target, read_patch_word, write_patch_word, sync_patch_word, &memory, &result
        ));
        assert(result.mismatched == 1u);
        assert(result.modified == 0u);
        assert(memory.syncs == 0u);
        for (index = 1; index < memory.count; ++index) {
            assert(memory.words[index] == original_word);
        }
    }

    printf("{\"status\":\"PASS\",\"modules\":%zu,\"callsites\":%zu,\"max_active\":%zu,\"anchors\":%zu,\"callsite_redirects\":\"PASS\"}\n",
           g_rcsm_module_profile_count, total, maximum, g_rcsm_detection_anchor_count);
    return 0;
}
"""


def profiler_psp_skeleton_text() -> str:
    return r"""/*
 * Discovery-only PSP/PPSSPP module skeleton.
 *
 * This file deliberately performs no code patch.  It identifies the active
 * UCES-00420 level profile and binds the static lookup table.  The reviewed
 * Allegrex trampoline must be added before the known callsites can be safely
 * redirected through rcsm_record_hit() and then tail-jump to the game wrapper.
 */
#include <pspkernel.h>
#include <pspthreadman.h>
#include <stdint.h>

#include "rcsm_profiler_core.h"

PSP_MODULE_INFO("RCSMProfiler", PSP_MODULE_USER, 0, 2);

static volatile int g_stop_requested = 0;
static SceUID g_monitor_thread = -1;
volatile uint32_t g_rcsm_active_module_index = 0u;
volatile uint32_t g_rcsm_equivalent_profile_matches = 0u;
static RcsmProfiler g_profiler;

static int read_game_word(uint32_t address, uint32_t *value, void *user) {
    (void)user;
    if (value == NULL || address < 0x08800000u || address > 0x09FFFFFCu || (address & 3u) != 0u) {
        return -1;
    }
    *value = *(volatile const uint32_t *)(uintptr_t)address;
    return 0;
}

static int monitor_thread(SceSize args, void *argp) {
    const RcsmModuleProfile *bound = NULL;
    (void)args;
    (void)argp;
    while (!g_stop_requested) {
        unsigned matches = 0u;
        const RcsmModuleProfile *detected = rcsm_identify_module(read_game_word, NULL, &matches);
        if (detected != NULL && detected != bound) {
            if (rcsm_bind_profile(&g_profiler, detected)) {
                bound = detected;
                g_rcsm_active_module_index = detected->module_index;
                g_rcsm_equivalent_profile_matches = matches;
                /* TODO: install reviewed one-word callsite redirects only here. */
            }
        } else if (detected == NULL) {
            bound = NULL;
            g_rcsm_active_module_index = 0u;
            g_rcsm_equivalent_profile_matches = 0u;
        }
        sceKernelDelayThread(500000u);
    }
    sceKernelExitDeleteThread(0);
    return 0;
}

int module_start(SceSize args, void *argp) {
    (void)args;
    (void)argp;
    g_stop_requested = 0;
    g_monitor_thread = sceKernelCreateThread(
        "rcsm_profiler_monitor", monitor_thread, 0x18, 0x1000, PSP_THREAD_ATTR_USER, NULL
    );
    if (g_monitor_thread >= 0) {
        sceKernelStartThread(g_monitor_thread, 0, NULL);
    }
    return 0;
}

int module_stop(SceSize args, void *argp) {
    (void)args;
    (void)argp;
    g_stop_requested = 1;
    if (g_monitor_thread >= 0) {
        sceKernelWaitThreadEnd(g_monitor_thread, NULL);
    }
    return 0;
}
"""


def profiler_parser_text() -> str:
    return r'''#!/usr/bin/env python3
"""Validate a RCSM wrapper trace JSON and optionally export its rows to CSV."""

import argparse
import csv
import json
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("trace", type=Path)
    parser.add_argument("--csv", type=Path, dest="csv_path")
    args = parser.parse_args()
    data = json.loads(args.trace.read_text(encoding="utf-8"))
    if data.get("schema") != "rcsm-wrapper-trace/1":
        raise SystemExit("Schéma de trace inconnu")
    if data.get("game_id") != "UCES00420":
        raise SystemExit("Cette trace ne cible pas UCES00420")
    entries = data.get("entries")
    if not isinstance(entries, list):
        raise SystemExit("Le champ entries doit être une liste")
    required = {"ra", "family_id", "hits", "first_sample", "last_sample"}
    for index, row in enumerate(entries):
        missing = required.difference(row)
        if missing:
            raise SystemExit(f"Entrée {index}: champs manquants {sorted(missing)}")
        if int(row["hits"]) < 0:
            raise SystemExit(f"Entrée {index}: compteur négatif")
    if args.csv_path:
        with args.csv_path.open("w", encoding="utf-8-sig", newline="") as handle:
            writer = csv.DictWriter(handle, fieldnames=sorted(required))
            writer.writeheader()
            writer.writerows(entries)
    active = sum(int(row["hits"]) > 0 for row in entries)
    print(json.dumps({"status": "PASS", "entries": len(entries), "active": active}, ensure_ascii=False))


if __name__ == "__main__":
    main()
'''


def profiler_readme_text(counts: dict[str, Any], anchor_count: int, equivalent_pairs: list[list[int]]) -> str:
    pairs = ", ".join(f"LEVEL_{left:02d}/LEVEL_{right:02d}" for left, right in equivalent_pairs) or "aucune"
    callsite_bytes = counts["callsites"] * 8
    stat_bytes = PROFILER_TABLE_CAPACITY * PROFILER_ENTRY_BYTES
    return f"""# Prototype de profiler du wrapper — UCES00420

## État exact

Ce dossier fournit un **cœur de profiler portable et testable**, mais pas encore un PRX de traçage prêt à jouer. Les {counts['callsites']} associations `(module, $ra)` sont générées en C, triées et toutes initialisées à `RCSM_POLICY_VANILLA`. Le lookup, les compteurs saturants, l’identification du profil actif, les cas inconnus et l’installation transactionnelle des redirections de callsites sont couverts par `tests/test_profiler_core.c`.

`src/psp_plugin_skeleton.c` est un module utilisateur de découverte : il reconnaît le code actif grâce à {anchor_count} {"mot-signature" if anchor_count == 1 else "mots-signatures"} plus cinq mots de garde autour du wrapper, puis lie la bonne table. Il n’écrit aucun octet dans le code du jeu. Le trampoline Allegrex qui appellera `rcsm_record_hit()` reste volontairement à implémenter et à revoir.

La stratégie documentée dans `HOOK_DESIGN.md` redirige les `jal wrapper` connus, un mot par callsite, plutôt que de modifier le prologue du wrapper. `callsite_redirect_plan.csv` contient le mot runtime attendu pour chaque redirection ; le cœur C effectue un précontrôle global avant toute écriture et conserve le delay slot d’origine.

## Pourquoi cette mémoire n’empiète pas sur celle du jeu

Les données sont des variables du PRX et sont donc placées par le chargeur dans la mémoire attribuée au module. Aucune adresse « apparemment vide » du jeu n’est réquisitionnée. Le fichier `plugin.ini` n’emploie pas `memory = 64`.

- profils de callsites : {counts['callsites']} × 8 = {callsite_bytes} octets ;
- statistiques du seul module actif : {PROFILER_TABLE_CAPACITY} × {PROFILER_ENTRY_BYTES} = {stat_bytes} octets ;
- métadonnées, empreintes, code, pile du thread et futur trampoline : coût additionnel à mesurer sur la cible.

Le maximum réel est de {counts['max_callsites_per_module']} callsites actifs ; la capacité fixe de {PROFILER_TABLE_CAPACITY} garde donc {PROFILER_TABLE_CAPACITY - counts['max_callsites_per_module']} emplacements de marge sans allocation dynamique.

## Test sur un PC

Depuis la racine de ce paquet :

```sh
cc -std=c11 -Wall -Wextra -Werror \\
  -Iprofiler/include -Iprofiler/generated \\
  profiler/src/rcsm_profiler_core.c \\
  profiler/generated/wrapper_profiles.generated.c \\
  profiler/tests/test_profiler_core.c \\
  -o /tmp/rcsm_profiler_test
/tmp/rcsm_profiler_test
```

La sortie attendue est un objet JSON avec `status: PASS`, 15 profils, {counts['callsites']} callsites et un maximum actif de {counts['max_callsites_per_module']}.

## Compilation PSP/PPSSPP

1. Installer PSPDEV/PSPSDK.
2. Copier `Makefile.pspsdk.template` vers `Makefile`.
3. Lancer `make` dans ce dossier.
4. Placer `patch.prx` et `plugin.ini` dans `PSP/PLUGINS/SizeMattersWrapperProfiler/` du Memory Stick PPSSPP.

À ce stade, le PRX compilé ne fera encore que reconnaître le profil actif. Il ne deviendra un profiler qu’après ajout du hook décrit dans `PORTING_NOTES.md`. La chaîne PSPDEV n’était pas disponible dans l’environnement de génération : aucune réussite de compilation PSP n’est revendiquée ici.

## Identification des niveaux

Les PRX utilisent la même base runtime ; se fier seulement à l’adresse du wrapper ne suffit donc pas. Les empreintes générées différencient toutes les tables qui ont un contenu différent. Paire volontairement ambiguë : {pairs}. Cette ambiguïté est sûre, car ces profils ont exactement les mêmes clés `$ra` et familles.

## PPSSPP puis PSP réelle

PPSSPP charge directement un PRX utilisateur via `plugin.ini`. Une PSP réelle sous CFW demande normalement un bootstrap/chargeur distinct ; le cœur C et les tables peuvent rester identiques, mais le cycle de chargement et les API disponibles doivent être revalidés.
"""


def profiler_porting_notes_text() -> str:
    return """# Notes de portage — ce qui manque avant un hook réel

## Stratégie retenue : rediriger les callsites

Le prototype ne remplacera pas le prologue commun du wrapper. Il remplacera chaque instruction `jal wrapper` du module actif par `jal profiler_hook`, en conservant intact le delay slot à `callsite + 4`. Cette solution présente trois avantages : `$ra` identifie naturellement le callsite, chaque modification tient dans un seul mot aligné et, pendant l’installation progressive, un appel va soit au wrapper original, soit au hook — jamais vers une instruction intermédiaire incomplète.

`rcsm_install_callsite_redirects()` effectue déjà un précontrôle de tous les mots avant la première écriture, refuse une cible `jal` hors région, restaure les mots déjà modifiés si une écriture échoue et demande une synchronisation de cache pour chaque mot. Le test hôte couvre installation, retrait et refus complet sur un mot divergent.

## Trampoline Allegrex encore à écrire

1. capturer `$ra` avant tout `jal` ajouté par le hook ;
2. sauvegarder les registres généraux, HI/LO et les registres flottants nécessaires pour rendre au wrapper exactement ses arguments d’origine ;
3. appeler un shim très court qui transmet `(module, $ra, sample)` à `rcsm_record_hit()` ;
4. restaurer l’état CPU et la valeur originale de `$ra` ;
5. effectuer un **tail jump** vers `profile->two_pass_entry`, afin que le wrapper retourne directement à `callsite + 8` ;
6. ne jamais exécuter d’I/O, d’allocation ou de formatage de chaîne sur ce chemin chaud.

Le jump final doit être vérifié pour la région MIPS courante ou passer par un registre. Le shim et le trampoline doivent être compilés avec `-G0` ou gérer explicitement le registre `$gp` du PRX.

## Installation et retrait

Même si un store 32 bits aligné réduit fortement la fenêtre de risque, l’installation doit idéalement se produire à un moment où le module vient d’être chargé et avant son utilisation gameplay. Au retrait, un mot n’est restauré que s’il vise encore notre hook ; un mot déjà remplacé par le chargeur du niveau suivant ou modifié par un autre patch n’est jamais écrasé.

Après chaque modification, l’adaptateur PSP devra appeler `sceKernelDcacheWritebackInvalidateRange()` puis `sceKernelIcacheInvalidateRange()` sur les quatre octets concernés.

## Signal temporel

Le champ `sample` est volontairement abstrait. Trois options devront être évaluées dans cet ordre : compteur de frame déjà maintenu par le jeu, callback de VBlank utilisateur, ou compteur monotone du plugin. Il ne faut pas confondre VBlank, frame rendue et tick de simulation sans une mesure préalable.

## Cycle des PRX de niveau

Le thread de découverte reconnaît le profil actif par une empreinte située hors des 493 callsites et hors des mots de garde du wrapper. Lors d’un changement de niveau, il retire conditionnellement les redirections encore présentes, réinitialise les compteurs, vérifie intégralement le nouveau profil puis installe ses redirections.

## Sortie de trace

Le futur export doit produire `trace_schema.json` et n’écrire qu’à la demande, jamais à chaque appel. Les compteurs peuvent rester entièrement en mémoire pendant une séquence de test.

## Concurrence

Le cœur actuel utilise des incréments simples. Si les traces montrent que le wrapper est appelé depuis plusieurs threads, il faudra soit attribuer un buffer par thread, soit protéger la mise à jour par une primitive à coût mesuré. Désactiver globalement les interruptions sur le chemin chaud n’est pas retenu par défaut.
"""


def profiler_hook_design_text(counts: dict[str, Any], anchor_count: int) -> str:
    anchor_clause = (
        "le mot de détection est choisi"
        if anchor_count == 1
        else f"les {anchor_count} mots de détection sont choisis"
    )
    return f"""# Conception du hook — décision et preuves

## Décision

La première idée consistait à détourner l’entrée du wrapper. L’analyse des prologues montre que les quinze profils commencent tous par les mêmes quatre mots :

| Décalage | Mot | Instruction |
|---:|---:|---|
| `+0x00` | `0x27BDFFC0` | `addiu $sp, $sp, -0x40` |
| `+0x04` | `0xE7B40020` | `swc1 $f20, 0x20($sp)` |
| `+0x08` | `0xE7B60024` | `swc1 $f22, 0x24($sp)` |
| `+0x0C` | `0xE7B80028` | `swc1 $f24, 0x28($sp)` |

Ce point rendrait un trampoline commun possible, mais le patch de plusieurs mots au prologue crée une transition délicate : un thread pourrait exécuter un saut nouveau avec un delay slot ancien, ou l’inverse. La stratégie retenue est donc plus sûre et plus informative : rediriger les instructions `jal` des callsites.

## Transformation d’un callsite

Avant :

```mips
jal  wrapper_two_pass       # mot remplacé
<delay slot d'origine>      # mot conservé
```

Après :

```mips
jal  profiler_hook          # seul mot modifié
<delay slot d'origine>      # sémantique inchangée
```

À l’entrée de `profiler_hook`, `$ra` vaut toujours `callsite + 8`. Le hook peut donc compter la bonne famille, restaurer l’état CPU puis effectuer un tail jump vers le wrapper original en conservant ce `$ra`. Le wrapper retourne alors au jeu comme si l’appel n’avait jamais été redirigé.

## Pourquoi cette voie est adaptée au corpus

- seulement {counts['max_callsites_per_module']} mots au maximum sont modifiés dans le module actif, pas les {counts['callsites']} simultanément ;
- chaque mot original est calculable depuis l’adresse vérifiée du wrapper et contrôlé avant la première écriture ;
- le delay slot de chaque appel reste inchangé ;
- l’identifiant de famille est déjà disponible dans la table `(module, $ra)` ;
- {anchor_clause} hors de tous les callsites, afin que le module reste identifiable après installation ;
- le retrait ne restaure que les mots qui ciblent encore notre hook.

## Garde-fous bloquants

L’installation doit échouer sans écriture si le jeu n’est pas UCES00420, si l’empreinte ne correspond à aucun profil, si les cinq mots de garde du wrapper divergent, si un seul callsite ne contient pas le `jal` attendu ou si le hook n’est pas atteignable par l’encodage MIPS direct. Les callbacks de lecture, écriture et synchronisation de cache séparent le cœur testable du code PSP spécifique.

## Élément encore non validé

Le trampoline assembleur n’est pas livré comme « terminé » : sa liste de registres à sauver, la gestion de `$gp`, le signal de frame et son coût doivent être validés avec PSPSDK puis dans PPSSPP. Le choix du patch sur les callsites, l’encodage des `jal`, le précontrôle transactionnel et la restauration conditionnelle sont déjà implémentés et testés sur hôte.

Les mots `expected_original_jal_word` du CSV correspondent à l’image **après relocation en mémoire**. Les mots bruts du PRX utilisent une cible relative et sont couverts séparément par le contrôle statique `all_callsite_words_match_wrapper_jal`.
"""


def validate_host_profiler(profiler: Path) -> dict[str, Any]:
    compiler = shutil.which("cc") or shutil.which("gcc") or shutil.which("clang")
    if compiler is None:
        return {
            "status": "NOT_RUN",
            "reason": "Aucun compilateur C hôte disponible ; exécuter la commande documentée dans README.md.",
        }
    with tempfile.TemporaryDirectory(prefix="rcsm-profiler-test-") as temp_dir:
        executable = Path(temp_dir) / "rcsm_profiler_test"
        command = [
            compiler,
            "-std=c11",
            "-Wall",
            "-Wextra",
            "-Werror",
            f"-I{profiler / 'include'}",
            f"-I{profiler / 'generated'}",
            str(profiler / "src/rcsm_profiler_core.c"),
            str(profiler / "generated/wrapper_profiles.generated.c"),
            str(profiler / "tests/test_profiler_core.c"),
            "-o",
            str(executable),
        ]
        compiled = subprocess.run(command, capture_output=True, text=True, check=False)
        if compiled.returncode != 0:
            return {
                "status": "FAIL",
                "phase": "compile",
                "compiler": compiler,
                "returncode": compiled.returncode,
                "stdout": compiled.stdout,
                "stderr": compiled.stderr,
            }
        executed = subprocess.run([str(executable)], capture_output=True, text=True, check=False)
        return {
            "status": "PASS" if executed.returncode == 0 else "FAIL",
            "phase": "execute",
            "compiler": compiler,
            "returncode": executed.returncode,
            "stdout": executed.stdout.strip(),
            "stderr": executed.stderr.strip(),
            "compiled_with_werror": True,
            "binary_packaged": False,
        }


def write_profiler_scaffold(output: Path, catalog: dict[str, Any]) -> dict[str, Any]:
    profiler = output / "profiler"
    include_dir = profiler / "include"
    generated_dir = profiler / "generated"
    source_dir = profiler / "src"
    tests_dir = profiler / "tests"
    profiler_tools = profiler / "tools"
    for directory in (include_dir, generated_dir, source_dir, tests_dir, profiler_tools):
        directory.mkdir(parents=True, exist_ok=True)

    fingerprints = build_profiler_fingerprints(catalog)
    (include_dir / "rcsm_profiler_core.h").write_text(profiler_core_header_text(), encoding="utf-8")
    (generated_dir / "wrapper_profiles.generated.h").write_text(profiler_generated_header_text(), encoding="utf-8")
    (generated_dir / "wrapper_profiles.generated.c").write_text(
        profiler_generated_source_text(catalog, fingerprints), encoding="utf-8"
    )
    (source_dir / "rcsm_profiler_core.c").write_text(profiler_core_source_text(), encoding="utf-8")
    (source_dir / "psp_plugin_skeleton.c").write_text(profiler_psp_skeleton_text(), encoding="utf-8")
    (tests_dir / "test_profiler_core.c").write_text(profiler_host_test_text(), encoding="utf-8")
    (profiler_tools / "parse_trace.py").write_text(profiler_parser_text(), encoding="utf-8")
    (profiler / "README.md").write_text(
        profiler_readme_text(catalog["counts"], len(fingerprints["anchors"]), fingerprints["equivalent_pairs"]),
        encoding="utf-8",
    )
    (profiler / "PORTING_NOTES.md").write_text(profiler_porting_notes_text(), encoding="utf-8")
    (profiler / "HOOK_DESIGN.md").write_text(
        profiler_hook_design_text(catalog["counts"], len(fingerprints["anchors"])), encoding="utf-8"
    )
    (profiler / "plugin.ini").write_text(
        "[options]\nversion = 1\ntype = prx\nfilename = patch.prx\n\n[games]\nUCES00420 = true\n",
        encoding="utf-8",
    )
    (profiler / "Makefile.pspsdk.template").write_text(
        "TARGET = patch\n"
        "OBJS = src/psp_plugin_skeleton.o src/rcsm_profiler_core.o generated/wrapper_profiles.generated.o\n\n"
        "INCDIR = include generated\nCFLAGS = -O2 -G0 -Wall -Wextra\nCXXFLAGS = $(CFLAGS) -fno-exceptions -fno-rtti\n"
        "ASFLAGS = $(CFLAGS)\nBUILD_PRX = 1\nPSP_FW_VERSION = 660\n\n"
        "include $(PSPSDK)/lib/build.mak\n",
        encoding="utf-8",
    )
    write_json(
        profiler / "trace_schema.json",
        {
            "$schema": "https://json-schema.org/draft/2020-12/schema",
            "title": "RCSM wrapper trace",
            "type": "object",
            "required": ["schema", "game_id", "module_index", "sample_unit", "entries"],
            "properties": {
                "schema": {"const": "rcsm-wrapper-trace/1"},
                "game_id": {"const": "UCES00420"},
                "module_index": {"type": "integer", "minimum": 1, "maximum": 24},
                "sample_unit": {"enum": ["game_frame", "vblank", "microseconds", "unknown"]},
                "unknown_hits": {"type": "integer", "minimum": 0},
                "entries": {
                    "type": "array",
                    "items": {
                        "type": "object",
                        "required": ["ra", "family_id", "hits", "first_sample", "last_sample"],
                        "properties": {
                            "ra": {"type": "string", "pattern": "^0x[0-9A-Fa-f]{8}$"},
                            "family_id": {"type": "string", "pattern": "^WF-[0-9]{3}$"},
                            "hits": {"type": "integer", "minimum": 0},
                            "first_sample": {"type": "integer", "minimum": 0},
                            "last_sample": {"type": "integer", "minimum": 0},
                        },
                    },
                },
            },
        },
    )
    fingerprint_rows = []
    anatomy_by_index = {int(row["module_index"]): row for row in catalog["wrapper_anatomy"]}
    for index, words in sorted(fingerprints["expected"].items()):
        row: dict[str, Any] = {
            "module_index": index,
            "module_key": anatomy_by_index[index]["module_key"],
            "equivalent_profile_indices": "; ".join(
                str(other)
                for pair in fingerprints["equivalent_pairs"]
                if index in pair
                for other in pair
                if other != index
            ),
        }
        for anchor_index, (address, word) in enumerate(zip(fingerprints["anchors"], words), start=1):
            row[f"anchor_{anchor_index}_address"] = as_hex(address)
            row[f"anchor_{anchor_index}_word"] = as_hex(word)
        fingerprint_rows.append(row)
    write_csv(profiler / "module_fingerprints.csv", fingerprint_rows)
    redirect_rows = []
    for row in catalog["profiler_lookup"]:
        module_index = int(row["module_index"])
        wrapper_entry = int(anatomy_by_index[module_index]["two_pass_entry_runtime"], 16)
        ra = int(row["mips_ra_runtime"], 16)
        redirect_rows.append(
            {
                "module_index": module_index,
                "module_key": row["module_key"],
                "level": row["level"],
                "family_id": row["family_id"],
                "callsite_runtime": as_hex(ra - 8),
                "delay_slot_runtime": as_hex(ra - 4),
                "mips_ra_runtime": as_hex(ra),
                "wrapper_entry_runtime": as_hex(wrapper_entry),
                "expected_original_jal_word": as_hex(0x0C000000 | ((wrapper_entry >> 2) & 0x03FFFFFF)),
                "replacement_formula": "0x0C000000 | ((profiler_hook >> 2) & 0x03FFFFFF)",
                "default_policy": "VANILLA",
            }
        )
    write_csv(profiler / "callsite_redirect_plan.csv", redirect_rows)
    host_validation = validate_host_profiler(profiler)
    write_json(profiler / "HOST_VALIDATION.json", host_validation)
    if host_validation["status"] == "FAIL":
        raise RuntimeError("Le test hôte du profiler a échoué")
    return {
        "anchors": len(fingerprints["anchors"]),
        "equivalent_pairs": fingerprints["equivalent_pairs"],
        "callsite_profile_bytes": len(catalog["profiler_lookup"]) * 8,
        "active_stats_bytes": PROFILER_TABLE_CAPACITY * PROFILER_ENTRY_BYTES,
        "host_validation": host_validation,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path.cwd(), help="Racine contenant project_sources et upload")
    parser.add_argument("--output", type=Path, required=True, help="Dossier de sortie vide")
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

    catalog = build_catalog(root)
    table_map = {
        "wrapper_families.csv": catalog["families"],
        "wrapper_family_members.csv": catalog["members"],
        "wrapper_callsites.csv": catalog["callsites"],
        "profiler_ra_lookup.csv": catalog["profiler_lookup"],
        "wrapper_anatomy.csv": catalog["wrapper_anatomy"],
        "object_descriptors.csv": catalog["object_descriptors"],
        "family_patch_relations.csv": catalog["patch_relations"],
        "family_data_references.csv": catalog["data_references"],
        "family_callees.csv": catalog["callees"],
        "validation.csv": [
            {
                "check": name,
                "status": result["status"],
                "details": "; ".join(f"{key}={value}" for key, value in result.items() if key != "status"),
            }
            for name, result in catalog["validation"].items()
        ],
    }
    empty_table_fields = {
        "family_patch_relations.csv": [
            "family_id", "module_key", "module_index", "level", "owner_rva",
            "patch_id", "patch_runtime_address", "layer", "category", "mechanic",
            "weapon_title", "evidence",
        ],
    }
    for filename, rows in table_map.items():
        write_csv(tables / filename, rows, empty_table_fields.get(filename))

    compact = {
        "schema_version": SCHEMA_VERSION,
        "game": "Ratchet & Clank: Size Matters",
        "game_id": "UCES-00420",
        "generated_utc": catalog["generated_utc"],
        "counts": catalog["counts"],
        "families": catalog["families"],
        "members": catalog["members"],
        "profiler_lookup": catalog["profiler_lookup"],
        "wrapper_anatomy": catalog["wrapper_anatomy"],
        "validation": catalog["validation"],
        "tables": {name: f"../tables/{name}" for name in table_map},
    }
    write_json(data_dir / "catalog.json", compact)
    write_json(data_dir / "validation.json", catalog["validation"])
    write_json(
        data_dir / "build_config.json",
        {
            "schema_version": SCHEMA_VERSION,
            "required_root_layout": ["project_sources", "upload"],
            "base_builder": "build_reference_corpus.py",
            "no_game_binaries_in_output": True,
        },
    )

    package_name = output.name
    (output / "index.html").write_text(render_report(catalog, package_name), encoding="utf-8")
    (output / "README.md").write_text(readme_text(package_name, catalog["counts"]), encoding="utf-8")
    (output / "METHODOLOGY.md").write_text(methodology_text(), encoding="utf-8")
    (output / "PROFILER_SPEC.md").write_text(profiler_spec_text(catalog["counts"]), encoding="utf-8")
    profiler_metadata = write_profiler_scaffold(output, catalog)
    write_json(data_dir / "profiler_build.json", profiler_metadata)
    shutil.copy2(Path(__file__).resolve(), tools_dir / "build_wrapper_family_catalog.py")
    base_builder = Path(base.__file__).resolve()
    shutil.copy2(base_builder, tools_dir / "build_reference_corpus.py")

    forbidden = {".prx", ".wad", ".dump", ".gzf", ".bin", ".pak", ".w3d", ".png", ".zip"}
    offenders = [
        path.relative_to(output).as_posix()
        for path in output.rglob("*")
        if path.is_file() and path.suffix.lower() in forbidden
    ]
    if offenders:
        raise RuntimeError("Binaire du jeu copié par erreur : " + ", ".join(offenders))

    manifest_lines = []
    for path in sorted(item for item in output.rglob("*") if item.is_file() and item.name != "MANIFEST_SHA256.txt"):
        manifest_lines.append(f"{sha256_file(path)}  {path.relative_to(output).as_posix()}")
    (output / "MANIFEST_SHA256.txt").write_text("\n".join(manifest_lines) + "\n", encoding="utf-8")
    result = {
        "status": "PASS",
        "output": str(output),
        **catalog["counts"],
        "validation_checks": len(catalog["validation"]),
        "profiler_detection_anchors": profiler_metadata["anchors"],
        "profiler_equivalent_pairs": profiler_metadata["equivalent_pairs"],
        "files": sum(1 for path in output.rglob("*") if path.is_file()),
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
