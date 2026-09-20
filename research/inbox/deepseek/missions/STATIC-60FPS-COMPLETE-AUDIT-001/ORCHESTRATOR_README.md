# ORCHESTRATOR_README.md

This overlay makes STATIC-60FPS-COMPLETE-AUDIT-001 launchable through the project's existing detached DeepSeek mission runner.

## Important naming split

Instruction kit:
`research\inbox\deepseek\missions\STATIC-60FPS-COMPLETE-AUDIT-001`

Orchestrator run 1:
`static-60fps-complete-audit-run-001`

This avoids colliding with the already-existing instruction-kit directory.

The orchestrator will create its own run directory:
`research\inbox\deepseek\missions\static-60fps-complete-audit-run-001`

## Task file

`research\tasks\static-60fps-complete-audit-run-001.md`

## First launch

From repository root:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
& ".\research\inbox\deepseek\missions\STATIC-60FPS-COMPLETE-AUDIT-001\scripts\Start-StaticAuditMission.ps1"
```

The project runner is expected at:

`tools\agents\scripts\start-deepseek-mission.ps1`

The launcher uses:

- profile `deepseek-flash-high`
- roles `explorer`, `mapper`, `skeptic`
- existing `C:\Users\linki\.codex`
- detached mission infrastructure

## Status

```powershell
& ".\research\inbox\deepseek\missions\STATIC-60FPS-COMPLETE-AUDIT-001\scripts\Get-StaticAuditMissionStatus.ps1"
```

## Optional live terminal watcher

```powershell
& ".\research\inbox\deepseek\missions\STATIC-60FPS-COMPLETE-AUDIT-001\scripts\Watch-StaticAuditMission.ps1"
```

The watcher is for the owner terminal only. It does not require parent/model polling.

## Resume after partial quota/context completion

Example run 2:

```powershell
& ".\research\inbox\deepseek\missions\STATIC-60FPS-COMPLETE-AUDIT-001\scripts\Resume-StaticAuditMission.ps1" -RunNumber 2
```

Run only selected incomplete roles:

```powershell
& ".\research\inbox\deepseek\missions\STATIC-60FPS-COMPLETE-AUDIT-001\scripts\Resume-StaticAuditMission.ps1" -RunNumber 2 -Roles mapper
```

or:

```powershell
& ".\research\inbox\deepseek\missions\STATIC-60FPS-COMPLETE-AUDIT-001\scripts\Resume-StaticAuditMission.ps1" -RunNumber 2 -Roles explorer,mapper
```

Every resume uses the same task file.

The task instructs workers to read role progress and continue only incomplete 25-name shards.

## mission.json

Do not manually create `mission.json`.

The orchestration runner creates authoritative runtime metadata including:
- mission ID
- schema version
- task snapshot
- selected roles
- profile
- PIDs
- panel summary paths
- completion/failure status

Pre-creating a fake mission.json would risk conflicting with the runner.

## No PPSSPP

This campaign is static-only.

Existing runtime reports may be read as prior evidence, but workers must not attach to or launch PPSSPP.
