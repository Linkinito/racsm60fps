# A0 preparation — 2026-09-19

Parent session HEAD: c13068d134e5139985349fa0194e829bc15a167d.
No gameplay trial, save-state creation, input injection or patch application.

## Provenance obtained

Owner identifies ordinary save slot 5 and the full-name Europe PSN ISO, not
copy.iso. Normal boot, Pokitaru, vanilla remain owner testimony.
`provenance-20260919T144757Z/record.json` and script.py record filesystem hashes
and directly parse ISO9660 directory extents without extracting or modifying assets.
Full-name ISO SHA256:
`4dfd2f8e31e7f4ff40ede123ca34f6238abaf54dfafc01c82606dd4c755b15d4`.
Its /PSP_GAME/USRDIR/BIN/LEVEL_01.PRX SHA256:
`d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`.
OBSERVED: exact identity with the historical reference PRX, including original four
core words. This closes reference-versus-user-ISO identity for LEVEL_01; it does
not independently certify an official unmodified disc or all loaded RAM/routes.
copy.iso has a different whole-ISO hash and size but the same LEVEL_01 PRX.

Active process PID3404: C:/Program Files/PPSSPP/PPSSPPWindows64.exe, command line
contains only that executable, no ISO/config arguments (read-only CIM query).
Installed executable SHA256:
`27d3edbb06dc623dab60877d3e3a975aef4034c7d4fac464e92fd4998864d2ec`.
File version and debugger report v1.20.4; no global latest-release claim.
Fresh read-only debugger record: `inspection-1789829201941/record.json`.
Selected core words remain original after disassembly/relocation handling.

Candidate config: C:/Users/linki/Documents/PPSSPP/PSP/SYSTEM/ppsspp.ini.
Its Recent entry agrees with owner ISO, but active config binding remains UNKNOWN.
No UCES00420-named per-game config found in that candidate SYSTEM directory.
Selected on-disk settings include CPUCore1, CPUSpeed0, no frame skip, D3D11,
VSync false, InternalResolution10, FrameRate30, FrameRate2 -1, EnableCheats false,
EnablePlugins false but LoadPlugins true. Resolve exact version semantics and
runtime settings before using these as active-state evidence. In particular,
FrameRate30 is not a measured cadence and could be an alternative-speed setting.
Only whitelisted settings and hashes were persisted, not full account settings.

## Safe staging

`a0-staging-20260919T144841Z/manifest.json` records 15 copied save files from
all five UCES00420 directories. Source hash before and after copy equals copy hash
for every file. Binary copies remain local under ignored local/save-snapshot/.
No slot-to-folder mapping was assumed; select owner slot5 in the future isolated
session. No config or emulator was copied/launched. Original session untouched.
A normal-save snapshot preserves on-disk progress, not current unsaved RAM state;
do not navigate the original session without further preservation.

## Delegated method gate

New mission player-clock-a0-method-001 was launched detached (launcher PID31876),
with Explorer replay/clocks, Mapper relocation/normalization, Skeptic isolation.
Task: research/tasks/player-clock-a0-method-001.md. Existing missions not restarted.
Completion not checked this session; no polling. On next session, one compact
status check and PARENT_HANDOFF first. Reports are research input, not validation.

NEXT: arbitrate version-specific isolation options and input/counter APIs; build
an isolated config and working save copy from the preserved snapshot, explicitly
select the identified ISO and slot5, prove active paths/plugins, cold boot, verify
normalized loaded code, then validate observables before A0 repetitions.

## Recovery and snapshot audit

Method001 was inspected once on the next owner continuation: all3 scopes failed
at CLI startup, zero reports; Codex home and app-server access denied. Failure
retained in that mission's parent-review.md. Elevated recovery initially rejected
by automatic approval review; owner explicitly approved launcher access to Codex
home/config. Method002 then launched detached with PID9980 and unchanged worker
read-only sandbox. Its completion is not yet checked. Use method002 next; do not
restart method001 or completed gameplay-support workers.

audit-save-snapshot.py produced save-audit-20260919T145713Z.json: all15 copied
files match manifest and current originals. SFO SAVEDATA_DIRECTORY strings match
DATA0..DATA4 folder names, but in-game ordering is not proved by this. An initial
strict UTF-8 title decode failed; final decoder retains raw hex and UNKNOWN for
nonstandard title bytes instead of changing saves or silently replacing text.
No emulator access, configuration changes or save writes occurred in this audit.
Local cached api-reference/directory.json references v1.19.3; do not reuse cached
sources as proof of active 1.20.4 behavior without version checks.

At the owner's explicit subsequent status request, method002 was RUNNING with
0 failed/3 pending and active runner. Process tree showed three child codex.exe
processes (18532/8208/4088), with nonempty role logs. No final reports or handoff
yet. This establishes process activity, not successful analysis or future completion.
