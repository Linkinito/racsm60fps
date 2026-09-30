#!/usr/bin/env python3
"""Build an isolated experimental companion PRX without editing archived sources.

The five known Lvl3Elevator initializer copies are added to the companion's
guarded full-patch transaction. The original ISO and installed PRX are never
written by this builder.
"""

import hashlib
import json
import os
from pathlib import Path
import shutil
import struct
import subprocess

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
ARCHIVE = REPO / (
    "01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/"
    "development-v0.6.4-no-menu/sources/profiler"
)
SDK = REPO / (
    "01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/"
    "toolchains/pspdev-win"
)
BUILD = HERE / "build"
PROJECT = BUILD / "companion-overlay-src-v4"
PACKAGE_SOURCE = HERE / "plugin-package"
PACKAGE = BUILD / "Lvl3ElevatorExperimental-v4"
RECIPE = HERE / "recipe.json"
SITE_RVAS = {1: 0x1563E8, 2: 0x16B050, 3: 0x153BF4,
             7: 0x166174, 24: 0x1367B8}
ORIGINAL_C_SHA256 = "e6ebc8af1eae253af9721a4a61b8dffc8888d3258330c44f236cf451cd535b5f"
ORIGINAL_RETURN = (
    "    return rcsm_full_prepare(&g_full,m->module_index,binding->runtime_base,\n"
    "                             addresses,g_config.full_layers);\n"
)
PATH_REPLACEMENTS = {
    'ms0:/PSP/PLUGINS/SizeMattersWrapperProfiler/RCSMProfiler.ini':
        'ms0:/PSP/PLUGINS/Lvl3ElevatorExperimental/RCSMProfiler.ini',
    'ms0:/PSP/PLUGINS/SizeMattersWrapperProfiler/status.log':
        'ms0:/PSP/PLUGINS/Lvl3ElevatorExperimental/status.log',
    'ms0:/PSP/PLUGINS/SizeMattersWrapperProfiler/trace':
        'ms0:/PSP/PLUGINS/Lvl3ElevatorExperimental/trace',
}
ORIGINAL_PATCH_VIEW = """    if (g_config.mode == RCSM_MODE_GLOBAL_60FPS) {
        return g_config.allowed_module == 0u || g_config.allowed_module == profile->module_index;
    }
"""
PATCH_VIEW_REPLACEMENT = """    if (g_config.mode == RCSM_MODE_GLOBAL_60FPS) {
        /* The experimental plugin may only arm the five verified elevator modules.
           The INI's singular allowed_module is zero; this is the module allowlist. */
        if (g_config.allowed_module != 0u &&
            g_config.allowed_module != profile->module_index) return 0;
        switch (profile->module_index) {
        case 1u: case 2u: case 3u: case 7u: case 24u: return 1;
        default: return 0;
        }
    }
"""
REPLACEMENT = """    if (!rcsm_full_prepare(&g_full,m->module_index,binding->runtime_base,
                           addresses,g_config.full_layers)) return 0;
    /* The five Lvl3Elevator initializer copies share one timing-domain fix.
       The selected module's transaction owns preflight/install/rollback. */
    {
        RcsmFullEntry *entry;
        uint32_t site_rva = 0u;
        uint32_t site, context_word;
        switch (m->module_index) {
        case 1u: site_rva = 0x1563E8u; break;
        case 2u: site_rva = 0x16B050u; break;
        case 3u: site_rva = 0x153BF4u; break;
        case 7u: site_rva = 0x166174u; break;
        case 24u: site_rva = 0x1367B8u; break;
        default: return 0;
        }
        if (binding->runtime_base > 0x09FFFFD4u - site_rva ||
            g_full.count >= RCSM_FULL_CAPACITY) return 0;
        site = binding->runtime_base + site_rva;
        /* Guard four downstream instructions, in addition to the exact
           original word checked by rcsm_full_preflight. */
        if (read_patch_word(site + 0x04u, &context_word, NULL) != 0 ||
            context_word != 0x34C68889u ||
            read_patch_word(site + 0x20u, &context_word, NULL) != 0 ||
            context_word != 0x44866800u ||
            read_patch_word(site + 0x24u, &context_word, NULL) != 0 ||
            context_word != 0x460D6302u ||
            read_patch_word(site + 0x28u, &context_word, NULL) != 0 ||
            context_word != 0xE62C000Cu) return 0;
        for (i = 0; i < g_full.count; ++i)
            if (g_full.entries[i].address == site) return 0;
        entry = &g_full.entries[g_full.count++];
        memset(entry, 0, sizeof(*entry));
        entry->address = site;
        entry->original = 0x3C063D08u;
        entry->patched = 0x3C063C88u;
        entry->flags = RCSM_FULL_CODE;
    }
    return 1;
"""
SOURCES = [
    "src/rcsm_fps_choice.c", "src/psp_plugin_runtime.c", "src/profiler_hook.S",
    "src/rcsm_profiler_core.c", "src/rcsm_format.c", "src/rcsm_full_patch.c",
    "generated/wrapper_profiles.generated.c", "generated/full_patch.generated.c",
]


def sha256_file(path):
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(8 * 1024 * 1024):
            digest.update(block)
    return digest.hexdigest()


def executable_file_offset(image, rva):
    if image[:4] != b"\x7fELF" or image[4] != 1 or image[5] != 1:
        raise ValueError("Expected little-endian ELF32 reference PRX")
    phoff = struct.unpack_from("<I", image, 28)[0]
    phentsize, phnum = struct.unpack_from("<HH", image, 42)
    for index in range(phnum):
        offset = phoff + index * phentsize
        p_type, p_offset, p_vaddr = struct.unpack_from("<III", image, offset)
        p_filesz = struct.unpack_from("<I", image, offset + 16)[0]
        p_flags = struct.unpack_from("<I", image, offset + 24)[0]
        if p_type == 1 and p_flags & 1 and p_vaddr <= rva < p_vaddr + p_filesz:
            file_offset = p_offset + rva - p_vaddr
            if file_offset + 4 > len(image):
                raise ValueError(f"Executable RVA outside file: 0x{rva:X}")
            return file_offset
    raise ValueError(f"RVA is not file-backed executable code: 0x{rva:X}")


def verify_reference_sites():
    recipe = json.loads(RECIPE.read_text(encoding="utf-8"))
    observed = {}
    for item in recipe["modules"]:
        module = item["module"]
        index = int(module.removeprefix("LEVEL_").removesuffix(".PRX"))
        if index not in SITE_RVAS or index in observed or len(item["edits"]) != 1:
            raise ValueError(f"Unexpected or duplicate recipe module: {module}")
        edit = item["edits"][0]
        rva = int(edit["rva"], 0)
        if (rva != SITE_RVAS[index] or int(edit["before_word"], 0) != 0x3C063D08
                or int(edit["after_word"], 0) != 0x3C063C88):
            raise ValueError(f"Initializer recipe mismatch: {module}")
        source = REPO / item["source"]
        if sha256_file(source) != item["sha256"]:
            raise ValueError(f"Reference PRX hash mismatch: {module}")
        image = source.read_bytes()
        file_offset = executable_file_offset(image, rva)
        if struct.unpack_from("<I", image, file_offset)[0] != 0x3C063D08:
            raise ValueError(f"Reference initializer word mismatch: {module}")
        expected_context = {4: 0x34C68889, 0x20: 0x44866800,
                            0x24: 0x460D6302, 0x28: 0xE62C000C}
        actual_context = {int(c["delta"], 0): int(c["word"], 0)
                          for c in edit["context"]}
        if actual_context != expected_context:
            raise ValueError(f"Recipe context mismatch: {module}")
        for delta, expected in expected_context.items():
            context_offset = executable_file_offset(image, rva + delta)
            if struct.unpack_from("<I", image, context_offset)[0] != expected:
                raise ValueError(f"Reference context word mismatch: {module}+0x{delta:X}")
        observed[index] = {"module": module, "rva": hex(rva),
                           "source_sha256": item["sha256"]}
    if set(observed) != set(SITE_RVAS):
        raise ValueError(f"Missing recipe modules: {set(SITE_RVAS) - set(observed)}")
    return [observed[index] for index in sorted(observed)]


def run(args, env):
    result = subprocess.run(
        [str(arg) for arg in args], cwd=PROJECT, env=env,
        text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        check=False,
    )
    print(result.stdout, end="")
    if result.returncode:
        raise SystemExit(f"Build command failed ({result.returncode}): {args[0]}")


def main():
    verified_sites = verify_reference_sites()
    archive_runtime = ARCHIVE / "src/psp_plugin_runtime.c"
    if sha256_file(archive_runtime) != ORIGINAL_C_SHA256:
        raise SystemExit("Archived companion source changed; overlay refused")
    if not (SDK / "bin/psp-gcc.exe").is_file():
        raise SystemExit("Existing PSPDEV Windows toolchain is unavailable")
    if PROJECT.exists() or PACKAGE.exists():
        raise SystemExit("Overlay build/package already exists; refusing overwrite")
    BUILD.mkdir(parents=True, exist_ok=True)
    shutil.copytree(
        ARCHIVE, PROJECT,
        ignore=shutil.ignore_patterns("*.o", "*.elf", "*.prx", "*.pyc", "__pycache__"),
    )
    runtime = PROJECT / "src/psp_plugin_runtime.c"
    original = runtime.read_text(encoding="utf-8")
    if original.count(ORIGINAL_RETURN) != 1:
        raise SystemExit("Runtime insertion point missing or nonunique")
    modified = original.replace(ORIGINAL_RETURN, REPLACEMENT)
    if modified.count(ORIGINAL_PATCH_VIEW) != 1:
        raise SystemExit("Global 60 FPS module gate missing or nonunique")
    modified = modified.replace(ORIGINAL_PATCH_VIEW, PATCH_VIEW_REPLACEMENT)
    for before, after in PATH_REPLACEMENTS.items():
        if modified.count(before) != 1:
            raise SystemExit(f"Runtime path/version insertion point missing: {before}")
        modified = modified.replace(before, after)
    runtime.write_text(modified, encoding="utf-8", newline="\n")

    env = os.environ.copy()
    env["PSPDEV"] = str(SDK)
    env["PATH"] = str(SDK / "bin") + os.pathsep + env.get("PATH", "")
    pspsdk = SDK / "psp/sdk"
    cc = SDK / "bin/psp-gcc.exe"
    flags = [
        "-O2", "-G0", "-std=c11", "-Wall", "-Wextra", "-Werror",
        "-fno-strict-aliasing", "-D_PSP_FW_VERSION=660", "-Iinclude",
        "-Igenerated", "-I.", "-I" + (SDK / "psp/include").as_posix(),
        "-I" + (pspsdk / "include").as_posix(),
    ]
    objects = []
    for source in SOURCES:
        obj = str(Path(source).with_suffix(".o"))
        print(f"Compile {source}", flush=True)
        run([cc, *flags, "-c", source, "-o", obj], env)
        objects.append(obj)
    run([
        cc, *flags, "-L.", "-L" + (SDK / "psp/lib").as_posix(),
        "-L" + (pspsdk / "lib").as_posix(),
        "-specs=" + (pspsdk / "lib/prxspecs").as_posix(),
        "-Wl,-q,-T" + (pspsdk / "lib/linkfile.prx").as_posix(),
        "-Wl,-zmax-page-size=128", *objects,
        (pspsdk / "lib/prxexports.o").as_posix(),
        "-lpspdebug", "-lpspdisplay", "-lpspge", "-lpspctrl", "-lpspnet",
        "-lpspnet_apctl", "-o", "patch.elf",
    ], env)
    run([SDK / "bin/psp-fixup-imports.exe", "patch.elf"], env)
    run([SDK / "bin/psp-prxgen.exe", "patch.elf", "patch.prx"], env)
    PACKAGE.mkdir()
    shutil.copy2(PROJECT / "patch.prx", PACKAGE / "patch.prx")
    shutil.copy2(PACKAGE_SOURCE / "plugin.ini", PACKAGE / "plugin.ini")
    shutil.copy2(PACKAGE_SOURCE / "RCSMProfiler.ini", PACKAGE / "RCSMProfiler.ini")
    manifest = {
        "status": "experimental_generalized_five_modules_not_runtime_validated",
        "modules": verified_sites,
        "before_word": "0x3C063D08",
        "after_word": "0x3C063C88",
        "archived_runtime_sha256": ORIGINAL_C_SHA256,
        "overlay_runtime_sha256": sha256_file(runtime),
        "elf_sha256": sha256_file(PROJECT / "patch.elf"),
        "prx_sha256": sha256_file(PROJECT / "patch.prx"),
        "prx_bytes": (PROJECT / "patch.prx").stat().st_size,
        "package": str(PACKAGE),
        "plugin_ini_sha256": sha256_file(PACKAGE / "plugin.ini"),
        "config_sha256": sha256_file(PACKAGE / "RCSMProfiler.ini"),
        "toolchain": str(SDK),
    }
    with (BUILD / "companion-overlay-manifest-v4.json").open("x", encoding="utf-8") as handle:
        json.dump(manifest, handle, indent=2)
        handle.write("\n")
    print(json.dumps(manifest, indent=2))


if __name__ == "__main__":
    main()
