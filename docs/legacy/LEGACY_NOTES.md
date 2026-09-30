# Legacy preservation notes

## Duplicate PRX reference set

The following directories were compared before the initial Git snapshot:

- `development-v0.6.1/verified-prx-inputs/`
- `development-v0.6.3-generalisation/prx-reference/`

The following PRX files were SHA-256 identical between both directories:

- LEVEL_01.PRX
- LEVEL_02.PRX
- LEVEL_03.PRX
- LEVEL_04.PRX
- LEVEL_05.PRX
- LEVEL_06.PRX
- LEVEL_07.PRX
- LEVEL_08.PRX
- LEVEL_09.PRX
- LEVEL_10.PRX
- LEVEL_15.PRX
- LEVEL_21.PRX
- LEVEL_22.PRX
- LEVEL_23.PRX
- LEVEL_24.PRX

The v0.6.1 copies are therefore excluded from Git to avoid storing
duplicate binary data. The v0.6.3 `prx-reference` copies are retained
as the canonical legacy reference set.

The original local files have not been deleted.

## 2026-09-30 copyright cleanup (supersedes the retention statement above)

All game modules (`LEVEL_*.PRX`), including the v0.6.3 `prx-reference`
set, were removed from the entire Git history on 2026-09-30. They are
proprietary game code and must never be committed. The local files were
not deleted; they remain on disk and are ignored by `.gitignore`.

The same cleanup removed save data, memory captures, disassembly
listings, string dumps, binary archives, generated legacy analysis data
and raw captures larger than 5 MB. The legacy archive now keeps sources,
configurations and notes only. The pre-cleanup history is preserved
outside the repository in a local `git bundle`
(`RAC_60FPS-backup-2026-09-30/full-history-before-cleanup.bundle`).
`MANIFESTE_SHA256.csv` moved to `_local/legacy/` (ignored).
See `docs/PUBLICATION_POLICY.md`.
