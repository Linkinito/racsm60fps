# Publication and copyright policy

The GitHub repository `Linkinito/racsm60fps` is **public**. Only project-authored
material may ever be pushed.

## Never commit (on any branch)

Enforced by `.gitignore`; still check before every commit.

| Category | Examples |
| --- | --- |
| Game images and modules | `*.iso`, `*.cso`, `LEVEL_*.PRX`, `EBOOT.BIN`, extracted `PSP_GAME/` data |
| Save data | `SAVEDATA/`, `PARAM.SFO`, `SECURE.BIN`, `ICON0.PNG` |
| Memory captures | RAM dumps, `*.bin` object/memory captures, savestates (`*.ppst`) |
| Disassembly and extracted text | `*.asm` listings, `disasm-*.txt`, `*disassembly*.txt`, `*.ascii.txt` string dumps |
| Binary archives | `*.zip` bundles, which have contained game modules in the past |

Short instruction excerpts inside a research report (a few words with their
addresses) are acceptable. Bulk listings of game functions are not.

## Local-only (research workspace)

These stay on disk and out of Git: raw captures, generated datasets over
5 MB, build outputs (`build/`, `*.prx`, `*.elf`), deployment backups,
`output/`, `outputs/`, `tmp/`, `measurements/` and `_local/`. Keep their
generation method and hashes in Git so they can be regenerated.

## Branches

| Branch | Where | Contents |
| --- | --- | --- |
| `main` | GitHub (public) | Curated: README, docs, cheats, project-authored plugin sources and tools |
| `v2-research` | Local only | Full research history. **Never push it as a whole.** |

To update `main`, copy an explicit file allowlist from `v2-research`
(`git checkout v2-research -- <paths>` on `main`). Review the staged list,
then commit and push.

## 2026-09-30 cleanup record

- The remote branches `v2-research` and `codex/curated-publication-2026-09-23` were
  deleted from GitHub. They contained game modules, save data, memory
  captures and disassembly.
- The local history was rewritten with `git filter-repo` to remove the same
  categories and all blobs over 5 MB. The repository went from about 250 MB
  to about 4 MB.
- The full pre-cleanup history is preserved outside the repository in a local
  backup: `../RAC_60FPS-backup-2026-09-30/full-history-before-cleanup.bundle`.
  Keep this backup private.
- GitHub may keep unreachable commits reachable by direct SHA link for a
  while. For a complete purge, the owner can ask GitHub Support to run
  garbage collection on the repository.
