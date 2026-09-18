#!/usr/bin/env python3
"""Test hôte du contrat trace v4 temporel et du recoupement avec le corpus."""

from __future__ import annotations

import csv
import json
import subprocess
import sys
import tempfile
from pathlib import Path


def main() -> None:
    profiler = Path(__file__).resolve().parents[1]
    package = profiler.parent
    with (package / "tables" / "profiler_ra_lookup.csv").open(
        encoding="utf-8-sig", newline=""
    ) as handle:
        rows = [row for row in csv.DictReader(handle) if row["module_index"] == "1"]
    address_delta = 0x7000
    entries = [
        {
            "ra": row["mips_ra_runtime"],
            "runtime_ra": f"0x{int(row['mips_ra_runtime'], 16) + address_delta:08X}",
            "family_id": row["family_id"],
            "installed": row["family_id"] == "WF-019",
            "hits": 3 if row["family_id"] == "WF-019" else 0,
            "first_sample": 120 if row["family_id"] == "WF-019" else 0,
            "last_sample": 180 if row["family_id"] == "WF-019" else 0,
            "active_vblanks": 3 if row["family_id"] == "WF-019" else 0,
            "same_vblank_hits": 0,
            "max_hits_per_vblank": 1 if row["family_id"] == "WF-019" else 0,
            "gap_1_vblank": 0,
            "gap_2_vblank": 0,
            "gap_other_vblank": 2 if row["family_id"] == "WF-019" else 0,
        }
        for index, row in enumerate(rows)
    ]
    trace = {
        "schema": "rcsm-wrapper-trace/4",
        "game_id": "UCES00420",
        "plugin_version": "test",
        "target_environment": "host synthetic",
        "mode": "focused_pokitaru",
        "reason": "manual",
        "module_index": 1,
        "module_key": "LEVEL_01",
        "sample_unit": "vblank",
        "capture": {
            "start_sample": 100,
            "end_sample": 200,
            "installed_callsites": 2,
            "equivalent_profile_matches": 1,
            "reference_base": "0x09139D00",
            "runtime_base": "0x09140D00",
            "address_delta": address_delta,
            "resolution_source": "module_api",
        },
        "unknown_hits": 0,
        "entries": entries,
    }
    active_index = next(index for index, row in enumerate(entries) if row["hits"] > 0)
    json.loads((profiler / "trace_schema.json").read_text(encoding="utf-8"))
    with tempfile.TemporaryDirectory(prefix="rcsm-trace-test-") as directory:
        trace_path = Path(directory) / "trace.json"
        csv_path = Path(directory) / "trace.csv"
        trace_path.write_text(json.dumps(trace), encoding="utf-8")
        valid = subprocess.run(
            [sys.executable, str(profiler / "tools" / "parse_trace.py"), str(trace_path), "--csv", str(csv_path)],
            check=True,
            text=True,
            capture_output=True,
        )
        summary = json.loads(valid.stdout)
        assert summary["status"] == "PASS"
        assert summary["entries"] == 55
        assert summary["installed"] == 2
        assert summary["active"] == 2
        assert csv_path.is_file()

        trace["entries"][active_index]["same_vblank_hits"] = 1
        trace_path.write_text(json.dumps(trace), encoding="utf-8")
        invalid_temporal = subprocess.run(
            [sys.executable, str(profiler / "tools" / "parse_trace.py"), str(trace_path)],
            text=True,
            capture_output=True,
        )
        assert invalid_temporal.returncode != 0
        assert "same_vblank_hits incompatible" in invalid_temporal.stderr
        trace["entries"][active_index]["same_vblank_hits"] = 0

        trace["entries"][0]["family_id"] = "WF-999"
        trace_path.write_text(json.dumps(trace), encoding="utf-8")
        invalid = subprocess.run(
            [sys.executable, str(profiler / "tools" / "parse_trace.py"), str(trace_path)],
            text=True,
            capture_output=True,
        )
        assert invalid.returncode != 0
        assert "absente du corpus" in invalid.stderr
    print(json.dumps({"status": "PASS", "trace_schema": 4, "entries": len(entries), "address_delta": address_delta}))


if __name__ == "__main__":
    main()
