#!/usr/bin/env python3
"""Valide une configuration v0.5 et résout ses routes sur le corpus."""

from __future__ import annotations

import argparse
import configparser
import csv
import json
from pathlib import Path


POLICIES = {"vanilla", "two_pass", "one_pass", "custom"}


def fail(message: str) -> None:
    raise SystemExit(f"FAIL: {message}")


def parse_number_list(value: str, label: str) -> list[int]:
    values: list[int] = []
    for raw in value.split(","):
        token = raw.strip()
        if not token:
            continue
        try:
            values.append(int(token, 0))
        except ValueError:
            fail(f"{label}: valeur invalide {token!r}")
    return values


def assign(mapping: dict[int, str], values: list[int], policy: str, label: str) -> None:
    for value in values:
        previous = mapping.get(value)
        if previous is not None and previous != policy:
            fail(f"{label}: {value:#x} reçoit à la fois {previous} et {policy}")
        mapping[value] = policy


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("config", type=Path)
    parser.add_argument(
        "--corpus",
        type=Path,
        default=Path(__file__).resolve().parents[1] / "callsite_redirect_plan.csv",
    )
    args = parser.parse_args()

    config = configparser.ConfigParser(interpolation=None)
    config.read(args.config, encoding="utf-8")
    section_name = "dispatcher" if config.has_section("dispatcher") else "profiler"
    if not config.has_section(section_name):
        fail("section [dispatcher] absente")
    section = config[section_name]
    mode = section.get("mode", "detect_only").strip().lower()
    if mode not in {"detect_only", "single_pokitaru", "focused_pokitaru", "full_module", "policy_module"}:
        fail(f"mode inconnu {mode!r}")
    try:
        module_index = int(section.get("allowed_module", "0"), 0)
    except ValueError:
        fail("allowed_module invalide")
    if mode == "policy_module" and module_index == 0:
        fail("policy_module exige allowed_module non nul")
    default_policy = section.get("default_policy", "two_pass").strip().lower()
    if default_policy not in POLICIES:
        fail(f"default_policy inconnu {default_policy!r}")

    family_policies: dict[int, str] = {}
    ra_policies: dict[int, str] = {}
    for policy in ("one_pass", "two_pass", "custom"):
        assign(
            family_policies,
            parse_number_list(section.get(f"{policy}_families", ""), f"{policy}_families"),
            policy,
            "famille",
        )
        assign(
            ra_policies,
            parse_number_list(section.get(f"{policy}_ras", ""), f"{policy}_ras"),
            policy,
            "RA",
        )
    if any(not 1 <= family <= 59 for family in family_policies):
        fail("les familles doivent être comprises entre 1 et 59")

    with args.corpus.open(encoding="utf-8-sig", newline="") as handle:
        rows = [row for row in csv.DictReader(handle) if int(row["module_index"]) == module_index]
    if module_index != 0 and not rows:
        fail(f"module {module_index} absent du corpus")
    present_families = {int(row["family_id"].split("-")[1]) for row in rows}
    present_ras = {int(row["mips_ra_runtime"], 16) for row in rows}
    absent_families = sorted(set(family_policies).difference(present_families))
    absent_ras = sorted(set(ra_policies).difference(present_ras))
    if absent_families:
        fail(f"familles absentes du module {module_index}: {absent_families}")
    if absent_ras:
        fail(
            f"RA absents du module {module_index}: " +
            ", ".join(f"0x{ra:08X}" for ra in absent_ras)
        )

    routes: list[dict[str, object]] = []
    for row in rows:
        family = int(row["family_id"].split("-")[1])
        ra = int(row["mips_ra_runtime"], 16)
        configured = ra_policies.get(ra, family_policies.get(family, default_policy))
        effective = "one_pass" if configured == "one_pass" else "two_pass"
        routes.append({
            "ra": f"0x{ra:08X}",
            "family_id": row["family_id"],
            "configured_policy": configured,
            "effective_policy": effective,
        })

    armed = mode == "policy_module"
    summary = {
        "status": "PASS",
        "config": str(args.config),
        "mode": mode,
        "module_index": module_index,
        "callsites": len(routes),
        "armed_callsites": len(routes) if armed else 0,
        "two_pass_callsites": sum(route["effective_policy"] == "two_pass" for route in routes) if armed else 0,
        "one_pass_callsites": sum(route["effective_policy"] == "one_pass" for route in routes) if armed else 0,
        "custom_fallback_callsites": sum(route["configured_policy"] == "custom" for route in routes) if armed else 0,
        "one_pass_families": sorted({
            route["family_id"] for route in routes if route["effective_policy"] == "one_pass"
        }),
        "routes": routes,
    }
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
