[CmdletBinding()]
param(
    [string]$MissionId
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\..\.."))
$MissionsRoot = Join-Path $RepoRoot "research\inbox\deepseek\missions"

if (-not (Test-Path -LiteralPath $MissionsRoot -PathType Container)) {
    throw "No mission directory exists yet: $MissionsRoot"
}

if ([string]::IsNullOrWhiteSpace($MissionId)) {
    $MissionDirectory = Get-ChildItem -LiteralPath $MissionsRoot -Directory |
        Sort-Object LastWriteTimeUtc -Descending |
        Select-Object -First 1 |
        Select-Object -ExpandProperty FullName

    if ([string]::IsNullOrWhiteSpace($MissionDirectory)) {
        throw "No DeepSeek missions found."
    }
}
else {
    $MissionDirectory = Join-Path $MissionsRoot $MissionId
}

$ManifestPath = Join-Path $MissionDirectory "mission.json"

if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) {
    throw "Mission manifest not found: $ManifestPath"
}

$Manifest = Get-Content -LiteralPath $ManifestPath -Raw -Encoding utf8 | ConvertFrom-Json

Write-Host "Mission:       $($Manifest.missionId)"
Write-Host "Status:        $($Manifest.status)"
Write-Host "Review status: $($Manifest.reviewStatus)"
Write-Host "Runner PID:    $($Manifest.runnerPid)"
Write-Host "Git branch:    $($Manifest.gitBranch)"
Write-Host "Git HEAD:      $($Manifest.gitHead)"
Write-Host "Created UTC:   $($Manifest.createdAtUtc)"
Write-Host "Completed UTC: $($Manifest.completedAtUtc)"
Write-Host ""

if ($Manifest.runnerPid) {
    $Process = Get-Process -Id $Manifest.runnerPid -ErrorAction SilentlyContinue
    Write-Host ("Runner active: " + [bool]$Process)
}

Write-Host "Mission dir:   $MissionDirectory"
Write-Host "Resume file:   $(Join-Path $MissionDirectory 'RESUME.md')"

$ReadyPath = Join-Path $MissionDirectory "READY_FOR_SOL_REVIEW.md"
if (Test-Path -LiteralPath $ReadyPath -PathType Leaf) {
    Write-Host "Ready file:    $ReadyPath"
}
