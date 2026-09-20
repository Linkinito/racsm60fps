param(
    [string[]]$Roles = @("explorer", "mapper", "skeptic")
)

$ErrorActionPreference = "Stop"

$RepoRoot = "C:\Users\linki\Documents\PPSSPP\RAC_60FPS"
$MissionId = "static-60fps-complete-audit-run-001"
$TaskFile = Join-Path $RepoRoot "research\tasks\static-60fps-complete-audit-run-001.md"
$StartScript = Join-Path $RepoRoot "tools\agents\scripts\start-deepseek-mission.ps1"
$CodexHome = "C:\Users\linki\.codex"
$Profile = "deepseek-flash-high"

$Required = @(
    $TaskFile,
    $StartScript,
    (Join-Path $RepoRoot "research\EVIDENCE_INDEX.md"),
    (Join-Path $RepoRoot "research\checkpoints\2026-09-20\CURRENT_STATE_complete_2026-09-20.md"),
    (Join-Path $RepoRoot "research\v2\c1-residual-timing-atlas\c1-residual-timing-atlas.csv")
)

foreach ($Path in $Required) {
    if (-not (Test-Path $Path)) {
        throw "Required input not found: $Path"
    }
}

$ExistingMission = Join-Path $RepoRoot "research\inbox\deepseek\missions\$MissionId\mission.json"
if (Test-Path $ExistingMission) {
    throw "Mission $MissionId already exists. Use the status script, or Resume-StaticAuditMission.ps1 with a new run number."
}

Write-Host ""
Write-Host "Launching detached DeepSeek mission:"
Write-Host "  MissionId: $MissionId"
Write-Host "  TaskFile : $TaskFile"
Write-Host "  Profile  : $Profile"
Write-Host "  Roles    : $($Roles -join ', ')"
Write-Host ""

& $StartScript `
    -MissionId $MissionId `
    -TaskFile $TaskFile `
    -Roles $Roles `
    -Profile $Profile `
    -CodexHome $CodexHome

Write-Host ""
Write-Host "Launch command returned."
Write-Host "Use Get-StaticAuditMissionStatus.ps1 to inspect detached mission state."
