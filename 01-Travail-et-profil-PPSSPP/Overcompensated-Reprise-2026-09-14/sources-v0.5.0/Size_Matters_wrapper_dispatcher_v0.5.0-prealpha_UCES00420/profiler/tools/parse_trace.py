#!/usr/bin/env python3
"""Valide une trace RCSM, la recoupe avec le corpus et l'exporte en CSV."""

from __future__ import annotations

import argparse
import csv
import json
import re
from pathlib import Path


UINT32_MAX = 0xFFFFFFFF
INT32_MIN = -0x80000000
INT32_MAX = 0x7FFFFFFF
REFERENCE_LEVEL_BASE = 0x09139D00
RA_PATTERN = re.compile(r"^0x[0-9A-Fa-f]{8}$")
FAMILY_PATTERN = re.compile(r"^WF-[0-9]{3}$")


def fail(message: str) -> None:
    raise SystemExit(f"FAIL: {message}")


def check_u32(value: object, label: str) -> int:
    if isinstance(value, bool) or not isinstance(value, int) or not 0 <= value <= UINT32_MAX:
        fail(f"{label} doit être un entier non signé 32 bits")
    return value


def load_expected(corpus_path: Path, module_index: int) -> list[tuple[str, str]]:
    with corpus_path.open(encoding="utf-8-sig", newline="") as handle:
        rows = [row for row in csv.DictReader(handle) if int(row["module_index"]) == module_index]
    return [(row["mips_ra_runtime"].upper().replace("0X", "0x"), row["family_id"]) for row in rows]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("trace", type=Path)
    parser.add_argument("--csv", type=Path, dest="csv_path", help="Export détaillé optionnel")
    parser.add_argument(
        "--corpus",
        type=Path,
        default=Path(__file__).resolve().parents[2] / "tables" / "profiler_ra_lookup.csv",
        help="Table de référence utilisée pour recouper RA et familles",
    )
    args = parser.parse_args()

    data = json.loads(args.trace.read_text(encoding="utf-8"))
    schema = data.get("schema")
    if schema not in {
        "rcsm-wrapper-trace/1", "rcsm-wrapper-trace/2",
        "rcsm-wrapper-trace/3", "rcsm-wrapper-trace/4", "rcsm-wrapper-trace/5"
    }:
        fail("schéma de trace inconnu")
    if data.get("game_id") != "UCES00420":
        fail("cette trace ne cible pas UCES00420")
    module_index = data.get("module_index")
    if isinstance(module_index, bool) or not isinstance(module_index, int):
        fail("module_index invalide")
    entries = data.get("entries")
    if not isinstance(entries, list):
        fail("entries doit être une liste")

    expected = load_expected(args.corpus, module_index)
    if not expected:
        fail(f"module {module_index} absent du corpus")
    expected_map = dict(expected)
    seen: set[str] = set()
    normalized_rows: list[dict[str, object]] = []
    for index, row in enumerate(entries):
        if not isinstance(row, dict):
            fail(f"entrée {index}: objet attendu")
        required = {"ra", "family_id", "hits", "first_sample", "last_sample"}
        if schema.endswith(("/2", "/3", "/4", "/5")):
            required.add("installed")
        if schema.endswith(("/3", "/4", "/5")):
            required.add("runtime_ra")
        if schema.endswith(("/4", "/5")):
            required.update({
                "active_vblanks", "same_vblank_hits", "max_hits_per_vblank",
                "gap_1_vblank", "gap_2_vblank", "gap_other_vblank",
            })
        if schema.endswith("/5"):
            required.update({"configured_policy", "effective_policy", "custom_fallback"})
        missing = required.difference(row)
        if missing:
            fail(f"entrée {index}: champs manquants {sorted(missing)}")
        ra = row["ra"]
        family = row["family_id"]
        if not isinstance(ra, str) or RA_PATTERN.fullmatch(ra) is None:
            fail(f"entrée {index}: RA invalide")
        ra = ra.upper().replace("0X", "0x")
        if ra in seen:
            fail(f"entrée {index}: RA dupliqué {ra}")
        seen.add(ra)
        if not isinstance(family, str) or FAMILY_PATTERN.fullmatch(family) is None:
            fail(f"entrée {index}: famille invalide")
        if expected_map.get(ra) != family:
            fail(f"entrée {index}: paire RA/famille absente du corpus ({ra}, {family})")
        runtime_ra = row.get("runtime_ra", ra)
        if not isinstance(runtime_ra, str) or RA_PATTERN.fullmatch(runtime_ra) is None:
            fail(f"entrée {index}: runtime_ra invalide")
        runtime_ra = runtime_ra.upper().replace("0X", "0x")
        hits = check_u32(row["hits"], f"entrée {index}.hits")
        first = check_u32(row["first_sample"], f"entrée {index}.first_sample")
        last = check_u32(row["last_sample"], f"entrée {index}.last_sample")
        if hits > 0 and last < first:
            fail(f"entrée {index}: last_sample antérieur à first_sample")
        installed = row.get("installed", True)
        if not isinstance(installed, bool):
            fail(f"entrée {index}: installed doit être booléen")
        normalized = {
            "ra": ra,
            "runtime_ra": runtime_ra,
            "family_id": family,
            "installed": installed,
            "hits": hits,
            "first_sample": first,
            "last_sample": last,
        }
        if schema.endswith("/5"):
            configured_policy = row["configured_policy"]
            effective_policy = row["effective_policy"]
            custom_fallback = row["custom_fallback"]
            if configured_policy not in {"vanilla", "two_pass", "one_pass", "custom"}:
                fail(f"entrée {index}: configured_policy invalide")
            if effective_policy not in {"two_pass", "one_pass"}:
                fail(f"entrée {index}: effective_policy invalide")
            expected_effective = "one_pass" if configured_policy == "one_pass" else "two_pass"
            if effective_policy != expected_effective:
                fail(f"entrée {index}: politique effective incohérente")
            if not isinstance(custom_fallback, bool) or custom_fallback != (configured_policy == "custom"):
                fail(f"entrée {index}: custom_fallback incohérent")
            normalized.update({
                "configured_policy": configured_policy,
                "effective_policy": effective_policy,
                "custom_fallback": custom_fallback,
            })
        if schema.endswith(("/4", "/5")):
            active_vblanks = check_u32(row["active_vblanks"], f"entrée {index}.active_vblanks")
            same_vblank_hits = check_u32(row["same_vblank_hits"], f"entrée {index}.same_vblank_hits")
            max_hits_per_vblank = check_u32(
                row["max_hits_per_vblank"], f"entrée {index}.max_hits_per_vblank"
            )
            gap_1_vblank = check_u32(row["gap_1_vblank"], f"entrée {index}.gap_1_vblank")
            gap_2_vblank = check_u32(row["gap_2_vblank"], f"entrée {index}.gap_2_vblank")
            gap_other_vblank = check_u32(row["gap_other_vblank"], f"entrée {index}.gap_other_vblank")
            if hits == 0:
                if any((active_vblanks, same_vblank_hits, max_hits_per_vblank,
                        gap_1_vblank, gap_2_vblank, gap_other_vblank)):
                    fail(f"entrée {index}: métriques temporelles non nulles sans hit")
            else:
                if not 1 <= active_vblanks <= hits:
                    fail(f"entrée {index}: active_vblanks incompatible avec hits")
                if same_vblank_hits != hits - active_vblanks:
                    fail(f"entrée {index}: same_vblank_hits incompatible avec hits")
                if not 1 <= max_hits_per_vblank <= hits:
                    fail(f"entrée {index}: max_hits_per_vblank incompatible avec hits")
                if gap_1_vblank + gap_2_vblank + gap_other_vblank != active_vblanks - 1:
                    fail(f"entrée {index}: histogramme des écarts incomplet")
            normalized.update({
                "active_vblanks": active_vblanks,
                "same_vblank_hits": same_vblank_hits,
                "max_hits_per_vblank": max_hits_per_vblank,
                "gap_1_vblank": gap_1_vblank,
                "gap_2_vblank": gap_2_vblank,
                "gap_other_vblank": gap_other_vblank,
            })
        normalized_rows.append(normalized)

    if set(expected_map) != seen:
        missing = sorted(set(expected_map).difference(seen))
        extra = sorted(seen.difference(expected_map))
        fail(f"table incomplète : {len(missing)} RA manquants, {len(extra)} RA excédentaires")
    unknown_hits = check_u32(data.get("unknown_hits", 0), "unknown_hits")

    if schema.endswith(("/2", "/3", "/4", "/5")):
        if data.get("mode") not in {
            "detect_only", "single_pokitaru", "focused_pokitaru", "full_module", "policy_module"
        }:
            fail("mode v2 invalide")
        if data.get("reason") not in {"manual", "module_transition", "redirect_health_change", "plugin_stop"}:
            fail("raison d'export v2 invalide")
        if data.get("module_key") != f"LEVEL_{module_index:02d}":
            fail("module_key ne correspond pas à module_index")
        if data.get("sample_unit") != "vblank":
            fail("sample_unit v2 doit valoir vblank")
        if not isinstance(data.get("plugin_version"), str) or not data["plugin_version"]:
            fail("plugin_version v2 manquant")
        if not isinstance(data.get("target_environment"), str) or not data["target_environment"]:
            fail("target_environment v2 manquant")
        capture = data.get("capture")
        if not isinstance(capture, dict):
            fail("capture v2 manquant")
        start = check_u32(capture.get("start_sample"), "capture.start_sample")
        end = check_u32(capture.get("end_sample"), "capture.end_sample")
        if end < start and end != UINT32_MAX:
            fail("capture.end_sample antérieur au début")
        installed_count = check_u32(capture.get("installed_callsites"), "capture.installed_callsites")
        equivalent_matches = check_u32(
            capture.get("equivalent_profile_matches"), "capture.equivalent_profile_matches"
        )
        if not 1 <= equivalent_matches <= 15:
            fail("capture.equivalent_profile_matches hors limites")
        if installed_count != sum(bool(row["installed"]) for row in normalized_rows):
            fail("capture.installed_callsites ne correspond pas aux entrées")

        if schema.endswith(("/3", "/4", "/5")):
            reference_base = capture.get("reference_base")
            runtime_base = capture.get("runtime_base")
            address_delta = capture.get("address_delta")
            if not isinstance(reference_base, str) or RA_PATTERN.fullmatch(reference_base) is None:
                fail("capture.reference_base v3 invalide")
            if not isinstance(runtime_base, str) or RA_PATTERN.fullmatch(runtime_base) is None:
                fail("capture.runtime_base v3 invalide")
            if isinstance(address_delta, bool) or not isinstance(address_delta, int) or not INT32_MIN <= address_delta <= INT32_MAX:
                fail("capture.address_delta v3 invalide")
            if capture.get("resolution_source") not in {"module_api", "fallback_scan"}:
                fail("capture.resolution_source v3 invalide")
            reference_base_value = int(reference_base, 16)
            runtime_base_value = int(runtime_base, 16)
            if reference_base_value != REFERENCE_LEVEL_BASE:
                fail("capture.reference_base v3 ne correspond pas au corpus")
            if not 0 <= reference_base_value + address_delta <= UINT32_MAX or \
                    runtime_base_value != reference_base_value + address_delta:
                fail("capture.runtime_base v3 ne correspond pas au delta")
            for index, row in enumerate(normalized_rows):
                expected_runtime_ra = int(str(row["ra"]), 16) + address_delta
                if not 0 <= expected_runtime_ra <= UINT32_MAX or \
                        int(str(row["runtime_ra"]), 16) != expected_runtime_ra:
                    fail(f"entrée {index}: runtime_ra ne correspond pas au delta")

        if schema.endswith("/5"):
            policy = data.get("policy")
            if not isinstance(policy, dict):
                fail("policy v5 manquant")
            if policy.get("default") not in {"vanilla", "two_pass", "one_pass", "custom"}:
                fail("policy.default v5 invalide")
            if not isinstance(policy.get("instrumentation_enabled"), bool):
                fail("policy.instrumentation_enabled v5 invalide")
            two_pass_callsites = check_u32(policy.get("two_pass_callsites"), "policy.two_pass_callsites")
            one_pass_callsites = check_u32(policy.get("one_pass_callsites"), "policy.one_pass_callsites")
            custom_fallback_callsites = check_u32(
                policy.get("custom_fallback_callsites"), "policy.custom_fallback_callsites"
            )
            installed_rows = [row for row in normalized_rows if bool(row["installed"])]
            if two_pass_callsites != sum(row["effective_policy"] == "two_pass" for row in installed_rows):
                fail("policy.two_pass_callsites ne correspond pas aux entrées installées")
            if one_pass_callsites != sum(row["effective_policy"] == "one_pass" for row in installed_rows):
                fail("policy.one_pass_callsites ne correspond pas aux entrées installées")
            if custom_fallback_callsites != sum(bool(row["custom_fallback"]) for row in installed_rows):
                fail("policy.custom_fallback_callsites ne correspond pas aux entrées installées")

    if args.csv_path:
        args.csv_path.parent.mkdir(parents=True, exist_ok=True)
        with args.csv_path.open("w", encoding="utf-8-sig", newline="") as handle:
            fields = ["ra", "runtime_ra", "family_id", "installed", "hits", "first_sample", "last_sample"]
            if schema.endswith("/5"):
                fields.extend(["configured_policy", "effective_policy", "custom_fallback"])
            if schema.endswith(("/4", "/5")):
                fields.extend([
                    "active_vblanks", "same_vblank_hits", "max_hits_per_vblank",
                    "gap_1_vblank", "gap_2_vblank", "gap_other_vblank",
                ])
            writer = csv.DictWriter(handle, fieldnames=fields)
            writer.writeheader()
            writer.writerows(normalized_rows)

    active = sum(int(row["hits"]) > 0 for row in normalized_rows)
    total_hits = sum(int(row["hits"]) for row in normalized_rows)
    summary = {
        "status": "PASS",
        "schema": schema,
        "module_index": module_index,
        "entries": len(normalized_rows),
        "installed": sum(bool(row["installed"]) for row in normalized_rows),
        "active": active,
        "total_hits": total_hits,
        "unknown_hits": unknown_hits,
        "corpus_match": True,
    }
    print(json.dumps(summary, ensure_ascii=False))


if __name__ == "__main__":
    main()
