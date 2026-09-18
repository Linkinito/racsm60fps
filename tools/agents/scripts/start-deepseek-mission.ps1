[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[A-Za-z0-9._-]+$')]
    [string]$MissionId,

    [Parameter(Mandatory = $true)]
    [string]$TaskFile,

    [ValidateSet("explorer", "mapper", "skeptic")]
    [string[]]$Roles = @("explorer", "mapper", "skeptic"),

    [string]$Profile = "deepseek-flash-high",

    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-RepoPath {
    param(
        [Parameter(Mandatory = $true)][string]$PathValue,
        [Parameter(Mandatory = $true)][string]$RepoRoot
    )

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return [System.IO.Path]::GetFullPath($PathValue)
    }

    return [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $PathValue))
}

$RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\..\.."))
$RunnerScript = Join-Path $PSScriptRoot "run-deepseek-mission.ps1"
$TaskPath = Resolve-RepoPath -PathValue $TaskFile -RepoRoot $RepoRoot
$MissionDirectory = Join-Path $RepoRoot "research\inbox\deepseek\missions\$MissionId"
$WorkersDirectory = Join-Path $MissionDirectory "workers"
$ManifestPath = Join-Path $MissionDirectory "mission.json"
$ResumePath = Join-Path $MissionDirectory "RESUME.md"
$TaskSnapshotPath = Join-Path $MissionDirectory "task.snapshot.md"
$RunnerStdout = Join-Path $MissionDirectory "mission-run.stdout.log"
$RunnerStderr = Join-Path $MissionDirectory "mission-run.stderr.log"

if (-not (Test-Path -LiteralPath $RunnerScript -PathType Leaf)) {
    throw "Mission runner not found: $RunnerScript"
}

if (-not (Test-Path -LiteralPath $TaskPath -PathType Leaf)) {
    throw "Task file not found: $TaskPath"
}

if ((Test-Path -LiteralPath $MissionDirectory -PathType Container) -and -not $Force) {
    throw "Mission already exists: $MissionDirectory. Use -Force only if you intentionally want to restart this mission."
}

if ($Force -and (Test-Path -LiteralPath $MissionDirectory -PathType Container)) {
    Remove-Item -LiteralPath $MissionDirectory -Recurse -Force
}

New-Item -ItemType Directory -Path $WorkersDirectory -Force | Out-Null

# Snapshot the exact task before launching any expensive work.
Copy-Item -LiteralPath $TaskPath -Destination $TaskSnapshotPath -Force

$GitBranch = $null
$GitHead = $null

try {
    $GitBranch = (& git -C $RepoRoot branch --show-current 2>$null).Trim()
    $GitHead = (& git -C $RepoRoot rev-parse HEAD 2>$null).Trim()
}
catch {
    # Git provenance is useful but not required for mission execution.
}

$StartedAt = (Get-Date).ToUniversalTime().ToString("o")

$Manifest = [ordered]@{
    missionId = $MissionId
    status = "QUEUED"
    reviewStatus = "PENDING_SOL"
    createdAtUtc = $StartedAt
    taskFile = $TaskPath
    taskSnapshot = $TaskSnapshotPath
    profile = $Profile
    roles = @($Roles)
    repoRoot = $RepoRoot
    gitBranch = $GitBranch
    gitHead = $GitHead
    workersDirectory = $WorkersDirectory
    panelSummary = (Join-Path $WorkersDirectory "panel-summary.json")
    solReview = (Join-Path $MissionDirectory "sol-review.md")
    readyForReview = (Join-Path $MissionDirectory "READY_FOR_SOL_REVIEW.md")
    runnerStdout = $RunnerStdout
    runnerStderr = $RunnerStderr
    runnerPid = $null
    completedAtUtc = $null
    failure = $null
}

$Manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $ManifestPath -Encoding utf8

$Resume = @"
# Overcompensated V2 — Mission Resume Checkpoint

Mission: `$MissionId`

This file exists so the investigation can be resumed even if the parent Codex
session stops because of a usage limit, application restart, crash, or context loss.

## Canonical mission state

Read:

- `mission.json`
- `task.snapshot.md`
- `workers/panel-summary.json` when present
- `workers/explorer.md` when present
- `workers/mapper.md` when present
- `workers/skeptic.md` when present

The governing project files remain:

- `AGENTS.md`
- `PROJECT_GOALS.md`
- `MIGRATION.md`
- `docs/methodology/EVIDENCE_LEVELS.md`

## Resume procedure for Sol

If `mission.json` says `WORKERS_COMPLETE`:

1. Read the governing project files.
2. Read `task.snapshot.md`.
3. Read all worker reports and `workers/panel-summary.json`.
4. Treat worker agreement as corroboration only, never validation.
5. Write the parent review to `sol-review.md` in English.
6. Identify contradictions, missing evidence, and deterministic next tests.
7. Escalate to Astra only if a materially difficult ambiguity remains after normal review.
8. Summarize the outcome to the project owner in French.
9. Do not modify gameplay patches unless the original mission explicitly authorizes it.

If `mission.json` says `WORKERS_FAILED`:

1. Inspect `mission-run.stderr.log`.
2. Inspect `workers/_logs/` if present.
3. Preserve successful worker reports.
4. Restart only the failed scope unless the evidence set itself must be regenerated.

If the mission is still `QUEUED` or `RUNNING`, inspect the recorded runner PID
and logs before starting a duplicate mission.

## Important

DeepSeek output is research evidence/hypothesis material, not authoritative truth.
Priority 0 remains faithful 30 FPS -> 60 FPS behavioral parity.
"@

$Resume | Set-Content -LiteralPath $ResumePath -Encoding utf8

$PwshCommand = Get-Command pwsh -ErrorAction Stop

$RolesCsv = $Roles -join ","

$Process = Start-Process `
    -FilePath $PwshCommand.Source `
    -ArgumentList @(
        "-NoLogo",
        "-NoProfile",
        "-ExecutionPolicy",
        "Bypass",
        "-File",
        "`"$RunnerScript`"",
        "-MissionDirectory",
        "`"$MissionDirectory`"",
        "-TaskFile",
        "`"$TaskSnapshotPath`"",
        "-Profile",
        "`"$Profile`"",
        "-RolesCsv",
        "`"$RolesCsv`""
    ) `
    -WorkingDirectory $RepoRoot `
    -RedirectStandardOutput $RunnerStdout `
    -RedirectStandardError $RunnerStderr `
    -WindowStyle Hidden `
    -PassThru

$Manifest.runnerPid = $Process.Id
$Manifest.status = "RUNNING"
$Manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $ManifestPath -Encoding utf8

Write-Host "DeepSeek mission launched in detached mode."
Write-Host "Mission: $MissionId"
Write-Host "PID:     $($Process.Id)"
Write-Host "State:   $ManifestPath"
Write-Host "Resume:  $ResumePath"
Write-Host ""
Write-Host "The parent Codex session may end without losing the mission state."
