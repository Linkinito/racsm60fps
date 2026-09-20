param(
    [Parameter(Mandatory=$true)]
    [ValidateRange(2,999)]
    [int]$RunNumber,

    [string[]]$Roles = @("explorer", "mapper", "skeptic")
)

$ErrorActionPreference = "Stop"

$RepoRoot = "C:\Users\linki\Documents\PPSSPP\RAC_60FPS"
$RunSuffix = "{0:D3}" -f $RunNumber
$MissionId = "static-60fps-complete-audit-resume-$RunSuffix"
$TaskFile = Join-Path $RepoRoot "research\tasks\static-60fps-complete-audit-run-001.md"
$StartScript = Join-Path $RepoRoot "tools\agents\scripts\start-deepseek-mission.ps1"
$CodexHome = "C:\Users\linki\.codex"
$Profile = "deepseek-flash-high"

if (-not (Test-Path $TaskFile)) {
    throw "Task file missing: $TaskFile"
}
if (-not (Test-Path $StartScript)) {
    throw "DeepSeek mission launcher missing: $StartScript"
}

$ExistingMission = Join-Path $RepoRoot "research\inbox\deepseek\missions\$MissionId\mission.json"
if (Test-Path $ExistingMission) {
    throw "Resume mission $MissionId already exists. Choose another -RunNumber."
}

Write-Host ""
Write-Host "Launching resume mission:"
Write-Host "  MissionId: $MissionId"
Write-Host "  Roles    : $($Roles -join ', ')"
Write-Host ""
Write-Host "Workers are instructed by the shared task to resume from persisted role progress."
Write-Host ""

& $StartScript `
    -MissionId $MissionId `
    -TaskFile $TaskFile `
    -Roles $Roles `
    -Profile $Profile `
    -CodexHome $CodexHome
