#!/usr/bin/env python3
"""Audit statique et binaire du profiler PRX UCES00420.

Le script ne prétend pas remplacer un essai dans PPSSPP. Il vérifie les
invariants démontrables hors jeu : corpus, relocalisation dynamique, cibles et
queues des quinze stubs Allegrex, état CPU sauvegardé, type PRX et empreinte.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
import re
import shutil
import subprocess
from collections import Counter
from pathlib import Path


EXPECTED_TWO_PASS_TARGETS = {
    1: 0x0914805C,
    2: 0x09148040,
    3: 0x09148080,
    4: 0x09147E54,
    5: 0x0914805C,
    6: 0x09147EC4,
    7: 0x0914805C,
    8: 0x091480B8,
    9: 0x0914805C,
    10: 0x09147DD8,
    15: 0x091475E8,
    21: 0x091475E8,
    22: 0x09147890,
    23: 0x09147ED4,
    24: 0x09147B74,
}

EXPECTED_ONE_PASS_TARGETS = {
    1: 0x09147F90,
    2: 0x09147F74,
    3: 0x09147FB4,
    4: 0x09147D88,
    5: 0x09147F90,
    6: 0x09147DF8,
    7: 0x09147F90,
    8: 0x09147FEC,
    9: 0x09147F90,
    10: 0x09147D0C,
    15: 0x0914751C,
    21: 0x0914751C,
    22: 0x091477C4,
    23: 0x09147E08,
    24: 0x09147AA8,
}

EXPECTED_DETECTION_WORDS = {
    1: 0xC60E0000,
    2: 0xC6000008,
    3: 0xAFA00050,
    4: 0x8FBF0058,
    5: 0x45000003,
    6: 0x34040000,
    7: 0x46116B42,
    8: 0x4488A000,
    9: 0x3C043F80,
    10: 0x8FBF0080,
    15: 0x45010006,
    21: 0x45010006,
    22: 0x45010012,
    23: 0xC44F0004,
    24: 0x00034900,
}

PRESERVED_GPRS = [
    "at", "v0", "v1", "a0", "a1", "a2", "a3",
    "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7",
    "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7",
    "t8", "t9", "k0", "k1", "gp", "s8",
]


def run(tool: Path, *args: str) -> str:
    completed = subprocess.run(
        [str(tool), *args], check=True, text=True, capture_output=True
    )
    return completed.stdout


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def locate_tool(name: str, pspdev: Path | None) -> Path | None:
    if pspdev is not None:
        candidate = pspdev / "bin" / name
        if candidate.is_file():
            return candidate
    found = shutil.which(name)
    return Path(found) if found else None


def require(condition: bool, message: str, checks: list[str]) -> None:
    if not condition:
        raise SystemExit(f"FAIL: {message}")
    checks.append(message)


def parse_stub_source(assembly: str) -> dict[str, dict[int, int]]:
    pattern = re.compile(
        r"RCSM_LEVEL_HOOK\s+rcsm_profiler_hook_l(\d+)(_one)?,\s*"
        r"rcsm_profiler_tail_l\d+(?:_one)?,\s*(0x[0-9A-Fa-f]+)"
    )
    targets: dict[str, dict[int, int]] = {"two_pass": {}, "one_pass": {}}
    for level, suffix, target in pattern.findall(assembly):
        route = "one_pass" if suffix else "two_pass"
        targets[route][int(level)] = int(target, 16)
    return targets


def disassembly_body(output: str, symbol: str) -> str:
    match = re.search(rf"<{re.escape(symbol)}>:\n(.*?)(?:\n\n|\Z)", output, re.DOTALL)
    if match is None:
        raise SystemExit(f"FAIL: corps désassemblé introuvable pour {symbol}")
    return match.group(1).lower()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--pspdev", type=Path, help="Racine PSPDEV (dossier contenant bin/)")
    parser.add_argument("--output", type=Path, help="Écrit aussi le rapport JSON ici")
    parser.add_argument("--static-only", action="store_true", help="N'exécute pas les binutils PSP")
    args = parser.parse_args()

    profiler = Path(__file__).resolve().parents[1]
    package = profiler.parent
    assembly_path = profiler / "src" / "profiler_hook.S"
    callsites_path = profiler / "callsite_redirect_plan.csv"
    fingerprints_path = profiler / "module_fingerprints.csv"
    elf_path = profiler / "patch.elf"
    prx_path = profiler / "patch.prx"
    checks: list[str] = []

    assembly = assembly_path.read_text(encoding="utf-8")
    source_targets = parse_stub_source(assembly)
    require(
        source_targets["two_pass"] == EXPECTED_TWO_PASS_TARGETS,
        "15 cibles TWO_PASS source exactement conformes",
        checks,
    )
    require(
        source_targets["one_pass"] == EXPECTED_ONE_PASS_TARGETS,
        "15 cibles ONE_PASS source exactement conformes",
        checks,
    )
    require("RCSM_FRAME_SIZE, 0x120" in assembly, "frame Allegrex de 288 octets", checks)
    for register in range(32):
        require(f"$f{register}," in assembly, f"FPR f{register} sauvegardé/restauré", checks)
    for instruction in ("mfhi", "mflo", "mthi", "mtlo", "cfc1", "ctc1"):
        require(instruction in assembly, f"instruction d'état {instruction} présente", checks)

    with callsites_path.open(encoding="utf-8-sig", newline="") as handle:
        rows = list(csv.DictReader(handle))
    module_counts = Counter(int(row["module_index"]) for row in rows)
    require(len(rows) == 493, "493 callsites dans le plan", checks)
    require(set(module_counts) == set(EXPECTED_TWO_PASS_TARGETS), "15 modules dans le plan", checks)
    require(max(module_counts.values()) == 57, "maximum de 57 callsites actifs", checks)
    for row in rows:
        ra = int(row["mips_ra_runtime"], 16)
        site = int(row["callsite_runtime"], 16)
        require(ra == site + 8, f"RA=jal+8 à {row['callsite_runtime']}", checks)

    with fingerprints_path.open(encoding="utf-8-sig", newline="") as handle:
        fingerprint_rows = list(csv.DictReader(handle))
    observed_fingerprints = {
        int(row["module_index"]): int(row["anchor_1_word"], 16)
        for row in fingerprint_rows
    }
    require(len(fingerprint_rows) == 15, "15 empreintes module", checks)
    require(
        {int(row["anchor_1_address"], 16) for row in fingerprint_rows} == {0x09148800},
        "ancre non relocalisée unique à 0x09148800",
        checks,
    )
    require(
        observed_fingerprints == EXPECTED_DETECTION_WORDS,
        "mots de détection post-chargement conformes",
        checks,
    )
    core_source = (profiler / "src" / "rcsm_profiler_core.c").read_text(encoding="utf-8")
    runtime_source = (profiler / "src" / "psp_plugin_runtime.c").read_text(encoding="utf-8")
    core_header = (profiler / "include" / "rcsm_profiler_core.h").read_text(encoding="utf-8")
    require(
        "word != rcsm_encode_jal(runtime_inner)" in core_source,
        "garde de suppression comparée avec la cible R_MIPS_26 relocalisée",
        checks,
    )
    require(
        all(field in core_header for field in (
            "active_vblanks", "same_vblank_hits", "max_hits_per_vblank",
            "gap_1_vblank", "gap_2_vblank", "gap_other_vblank",
        )) and "sample - stat->last_sample" in core_source,
        "métriques temporelles VBlank et histogramme des écarts dans le cœur",
        checks,
    )
    require(
        "rcsm-wrapper-trace/5" in runtime_source and
        '"rcsm-wrapper-trace/5"' in (profiler / "trace_schema.json").read_text(encoding="utf-8"),
        "export et schéma de trace v5",
        checks,
    )
    require(
        "rcsm_identify_module_at_delta" in core_source and "rcsm_relocate_profile" in core_source,
        "détection et profils paramétrés par un delta runtime",
        checks,
    )
    require(
        "anchor_index == 0u && rcsm_is_ppsspp_emuhack(word)" in core_source and
        "RCSM_PPSSPP_EMUHACK_MASK" in (profiler / "include" / "rcsm_profiler_core.h").read_text(encoding="utf-8"),
        "marqueur JIT PPSSPP accepté uniquement au premier mot du prologue",
        checks,
    )
    require(
        "sceKernelGetModuleIdList" in runtime_source and "sceKernelQueryModuleInfo" in runtime_source,
        "résolution primaire par le gestionnaire de modules PSP",
        checks,
    )
    require(
        "rcsm_scan_module_deltas" in runtime_source and "RCSM_FALLBACK_DELTA_STEP" in runtime_source,
        "balayage borné disponible comme repli",
        checks,
    )
    require(
        "prepare_tail_jump(profile, RCSM_POLICY_TWO_PASS)" in runtime_source and
        "prepare_tail_jump(profile, RCSM_POLICY_ONE_PASS)" in runtime_source and
        "runtime_profile->one_pass_inner" in runtime_source,
        "deux tail-jumps adaptés aux cibles runtime",
        checks,
    )
    require(
        "0x6000" not in runtime_source.lower(),
        "aucun décalage observé +0x6000 codé en dur dans le runtime",
        checks,
    )
    require(
        "manual export ignored: no recognized module" in runtime_source,
        "combinaison manuelle journalisée sans module reconnu",
        checks,
    )
    require(
        "RCSM_MODE_FOCUSED_POKITARU" in runtime_source and
        "RCSM_DEFAULT_FOCUS_FAMILY 19u" in runtime_source and
        "binding->focused_callsites[focused_count++]" in runtime_source,
        "mode focalisé WF-019 construit depuis le profil relocalisé",
        checks,
    )
    require(
        "RCSM_MODE_POLICY_MODULE" in runtime_source and
        "rcsm_install_policy_redirects" in runtime_source and
        "custom policies use safe two_pass fallback" in runtime_source,
        "dispatcher configurable et repli CUSTOM sûr",
        checks,
    )
    require(
        "one_pass_families" in runtime_source and "one_pass_ras" in runtime_source and
        "absent_reference_ra" in runtime_source and "absent_family" in runtime_source,
        "sélecteurs INI par famille et RA validés",
        checks,
    )
    focused_rows = [
        row for row in rows
        if int(row["module_index"]) == 1 and row["family_id"] == "WF-019"
    ]
    require(len(focused_rows) == 2, "WF-019 possède exactement deux branches Pokitaru", checks)
    require(
        {int(row["mips_ra_runtime"], 16) for row in focused_rows} == {0x092C142C, 0x092C16AC},
        "deux retours TriggeredDoor attendus dans le corpus",
        checks,
    )
    require(
        '#define RCSM_VERSION "0.6.1-metalis-integration-dev.2"' in runtime_source,
        "version runtime 0.6.1-metalis-integration-dev.2",
        checks,
    )
    require(
        "trace_schema=5" in runtime_source,
        "schéma de trace v5 annoncé dans la ligne de démarrage",
        checks,
    )

    report: dict[str, object] = {
        "schema": "rcsm-prx-validation/1",
        "status": "PASS",
        "scope": "host_static_and_psp_binary; no_in_game_execution",
        "game_id": "UCES00420",
        "package": package.name,
        "corpus": {
            "modules": len(module_counts),
            "callsites": len(rows),
            "max_active_callsites": max(module_counts.values()),
            "per_module": {str(key): module_counts[key] for key in sorted(module_counts)},
        },
        "source_stub_targets": {
            route: {str(key): f"0x{value:08X}" for key, value in targets.items()}
            for route, targets in source_targets.items()
        },
        "checks_passed": len(checks),
    }

    if not args.static_only:
        pspdev = args.pspdev or (Path(os.environ["PSPDEV"]) if "PSPDEV" in os.environ else None)
        tools = {name: locate_tool(name, pspdev) for name in ("psp-gcc", "psp-size", "psp-nm", "psp-objdump", "psp-readelf")}
        missing = [name for name, path in tools.items() if path is None]
        require(not missing, f"binutils PSP disponibles ({', '.join(missing) or 'aucun manquant'})", checks)
        require(elf_path.is_file() and prx_path.is_file(), "patch.elf et patch.prx présents", checks)
        require(b"0.6.1-metalis-integration-dev.2" in prx_path.read_bytes(), "version 0.6.1 intégrée au PRX", checks)

        gcc_version = run(tools["psp-gcc"], "--version").splitlines()[0]
        size_output = run(tools["psp-size"], str(elf_path))
        size_match = re.search(r"\n\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+([0-9a-fA-F]+)\s+", size_output)
        require(size_match is not None, "taille ELF lisible", checks)
        text_size, data_size, bss_size, memory_size = map(int, size_match.groups()[:4])

        nm_output = run(tools["psp-nm"], "-n", str(elf_path))
        symbol_offsets: dict[int, int] = {}
        one_symbol_offsets: dict[int, int] = {}
        for level in EXPECTED_TWO_PASS_TARGETS:
            match = re.search(
                rf"^([0-9A-Fa-f]+)\s+T\s+rcsm_profiler_hook_l{level:02d}$",
                nm_output,
                re.MULTILINE,
            )
            require(match is not None, f"symbole binaire hook L{level:02d}", checks)
            symbol_offsets[level] = int(match.group(1), 16)
            tail_match = re.search(
                rf"^([0-9A-Fa-f]+)\s+[Tt]\s+rcsm_profiler_tail_l{level:02d}$",
                nm_output,
                re.MULTILINE,
            )
            require(tail_match is not None, f"symbole binaire tail L{level:02d}", checks)
            one_match = re.search(
                rf"^([0-9A-Fa-f]+)\s+T\s+rcsm_profiler_hook_l{level:02d}_one$",
                nm_output,
                re.MULTILINE,
            )
            require(one_match is not None, f"symbole binaire hook ONE_PASS L{level:02d}", checks)
            one_symbol_offsets[level] = int(one_match.group(1), 16)
            one_tail_match = re.search(
                rf"^([0-9A-Fa-f]+)\s+[Tt]\s+rcsm_profiler_tail_l{level:02d}_one$",
                nm_output,
                re.MULTILINE,
            )
            require(one_tail_match is not None, f"symbole binaire tail ONE_PASS L{level:02d}", checks)

        full_disassembly = run(tools["psp-objdump"], "-D", str(elf_path))
        for level, target in EXPECTED_TWO_PASS_TARGETS.items():
            symbol = f"rcsm_profiler_hook_l{level:02d}"
            tail_symbol = f"rcsm_profiler_tail_l{level:02d}"
            hook_body = re.sub(r"\s+", " ", disassembly_body(full_disassembly, symbol))
            tail_body = re.sub(r"\s+", " ", disassembly_body(full_disassembly, tail_symbol))
            require("addiu sp,sp,-288" in hook_body, f"L{level:02d} alloue 288 octets", checks)
            require("sw ra,132(sp)" in hook_body, f"L{level:02d} capture le RA original", checks)
            require("lw ra,132(sp)" in hook_body, f"L{level:02d} restaure le RA original", checks)
            require("addiu sp,sp,288" in tail_body, f"L{level:02d} libère la frame", checks)
            require(re.search(rf"\bj\s+0*{target:x}\b", tail_body) is not None,
                    f"L{level:02d} tail-jump vers 0x{target:08X}", checks)
            one_symbol = f"rcsm_profiler_hook_l{level:02d}_one"
            one_tail_symbol = f"rcsm_profiler_tail_l{level:02d}_one"
            one_target = EXPECTED_ONE_PASS_TARGETS[level]
            one_hook_body = re.sub(r"\s+", " ", disassembly_body(full_disassembly, one_symbol))
            one_tail_body = re.sub(r"\s+", " ", disassembly_body(full_disassembly, one_tail_symbol))
            require("addiu sp,sp,-288" in one_hook_body, f"ONE_PASS L{level:02d} alloue 288 octets", checks)
            require("sw ra,132(sp)" in one_hook_body, f"ONE_PASS L{level:02d} capture le RA", checks)
            require("lw ra,132(sp)" in one_hook_body, f"ONE_PASS L{level:02d} restaure le RA", checks)
            require("addiu sp,sp,288" in one_tail_body, f"ONE_PASS L{level:02d} libère la frame", checks)
            require(re.search(rf"\bj\s+0*{one_target:x}\b", one_tail_body) is not None,
                    f"ONE_PASS L{level:02d} tail-jump vers 0x{one_target:08X}", checks)

        common = disassembly_body(
            run(tools["psp-objdump"], "-d", "--disassemble=rcsm_profiler_hook_common", str(elf_path)),
            "rcsm_profiler_hook_common",
        )
        for register in PRESERVED_GPRS:
            require(re.search(rf"\bsw\s+{register},", common) is not None,
                    f"binaire sauve GPR {register}", checks)
            require(re.search(rf"\blw\s+{register},", common) is not None,
                    f"binaire restaure GPR {register}", checks)
        for register in range(32):
            require(re.search(rf"\bswc1\s+\$?f{register},", common) is not None,
                    f"binaire sauve f{register}", checks)
            require(re.search(rf"\blwc1\s+\$?f{register},", common) is not None,
                    f"binaire restaure f{register}", checks)
        for instruction in ("mfhi", "mflo", "mthi", "mtlo", "cfc1", "ctc1"):
            require(re.search(rf"\b{instruction}\b", common) is not None,
                    f"binaire contient {instruction}", checks)
        require(re.search(r"\bjal\s+[^\n]*<rcsm_profiler_hook_c>", common) is not None,
                "corps commun appelle uniquement le shim C après sauvegarde", checks)

        hot_path = disassembly_body(
            run(tools["psp-objdump"], "-d", "--disassemble=rcsm_profiler_hook_c", str(elf_path)),
            "rcsm_profiler_hook_c",
        )
        hot_calls = re.findall(r"\bjal\s+[^\n]+", hot_path)
        require(len(hot_calls) == 1 and "<rcsm_record_hit>" in hot_calls[0],
                "shim chaud n'appelle que rcsm_record_hit", checks)
        require("sce" not in hot_path, "aucun syscall PSP dans le shim chaud", checks)

        elf_header = run(tools["psp-readelf"], "-h", str(prx_path))
        require("Type:                              Processor Specific: (ffa0)" in elf_header,
                "type ELF PRX 0xFFA0", checks)
        require("Machine:                           MIPS R3000" in elf_header,
                "machine MIPS R3000/Allegrex", checks)
        module_info = run(tools["psp-objdump"], "-s", "-j", ".rodata.sceModuleInfo", str(prx_path))
        require("5243534d 50726f66 696c6572" in module_info,
                "module PSP nommé RCSMProfiler", checks)

        config_text = (profiler / "RCSMProfiler.ini").read_text(encoding="utf-8")
        require(re.search(r"^mode\s*=\s*global_60fps\s*$", config_text, re.MULTILINE) is not None,
                "configuration globale de test explicitement active", checks)
        require(re.search(r"^allowed_module\s*=\s*0\s*$", config_text, re.MULTILINE) is not None,
                "configuration couvrant les modules du catalogue", checks)
        require(re.search(r"^default_policy\s*=\s*two_pass\s*$", config_text, re.MULTILINE) is not None,
                "politique racine sûre TWO_PASS", checks)

        sce_imports = sorted(
            match.group(1)
            for match in re.finditer(r"^[0-9A-Fa-f]+\s+T\s+(sce[A-Za-z0-9_]+)$", nm_output, re.MULTILINE)
        )
        require("sceKernelGetModuleIdList" in sce_imports, "import PSP de la liste des modules", checks)
        require("sceKernelQueryModuleInfo" in sce_imports, "import PSP des informations de module", checks)
        require("sceKernelSuspendDispatchThread" in sce_imports and "sceKernelResumeDispatchThread" in sce_imports,
                "installation et retrait sous suspension de l'ordonnanceur PSP", checks)
        require("g_full_caves" in nm_output and "rcsm_full_install" in nm_output,
                "routines et moteur de correctifs integres au PRX", checks)
        report["toolchain"] = gcc_version
        report["binary"] = {
            "prx_bytes": prx_path.stat().st_size,
            "prx_sha256": sha256(prx_path),
            "elf_text_bytes": text_size,
            "elf_data_bytes": data_size,
            "elf_bss_bytes": bss_size,
            "elf_load_bytes": memory_size,
            "declared_thread_stacks_bytes": 16 * 1024 + 0x800,
            "estimated_module_plus_declared_stacks_bytes": memory_size + 16 * 1024 + 0x800,
            "hook_symbol_offsets": {str(key): f"0x{value:08X}" for key, value in symbol_offsets.items()},
            "one_pass_hook_symbol_offsets": {
                str(key): f"0x{value:08X}" for key, value in one_symbol_offsets.items()
            },
            "sce_import_stubs": sce_imports,
        }

    report["checks_passed"] = len(checks)
    rendered = json.dumps(report, ensure_ascii=False, indent=2) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding="utf-8")
    print(rendered, end="")


if __name__ == "__main__":
    main()

