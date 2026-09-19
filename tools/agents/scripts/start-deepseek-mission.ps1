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

    [string]$CodexHome,

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

function Resolve-CodexHome {
    param(
        [string]$ExplicitPath,
        [Parameter(Mandatory = $true)]
        [string]$ProfileName
    )

    $Candidates = [System.Collections.Generic.List[string]]::new()

    if (-not [string]::IsNullOrWhiteSpace($ExplicitPath)) {
        $Candidates.Add($ExplicitPath)
    }

    if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        $Candidates.Add($env:CODEX_HOME)
    }

    try {
        $CodexCommand = Get-Command codex -ErrorAction Stop
        $CodexSource = [System.IO.Path]::GetFullPath($CodexCommand.Source)

        if ($CodexSource -match '^(?<profile>[A-Za-z]:\\Users\\[^\\]+)\\AppData\\Local\\') {
            $Candidates.Add((Join-Path $Matches.profile ".codex"))
        }
    }
    catch {
        # A clear error is raised below if no valid home can be resolved.
    }

    foreach ($Base in @($env:USERPROFILE, $HOME)) {
        if (-not [string]::IsNullOrWhiteSpace($Base)) {
            $Candidates.Add((Join-Path $Base ".codex"))
        }
    }

    foreach ($Candidate in ($Candidates | Select-Object -Unique)) {
        try {
            $FullCandidate = [System.IO.Path]::GetFullPath($Candidate)
        }
        catch {
            continue
        }

        $ProfilePath = Join-Path $FullCandidate "$ProfileName.config.toml"

        if ((Test-Path -LiteralPath $FullCandidate -PathType Container) -and
            (Test-Path -LiteralPath $ProfilePath -PathType Leaf)) {
            return $FullCandidate
        }
    }

    throw "Could not resolve CODEX_HOME containing '$ProfileName.config.toml'. Pass -CodexHome explicitly or set CODEX_HOME."
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

$ResolvedCodexHome = Resolve-CodexHome -ExplicitPath $CodexHome -ProfileName $Profile

# Persist into this process before the detached child is created.
$env:CODEX_HOME = $ResolvedCodexHome

if ((Test-Path -LiteralPath $MissionDirectory -PathType Container) -and -not $Force) {
    throw "Mission already exists: $MissionDirectory. Use -Force only if you intentionally want to restart this mission."
}

if ($Force -and (Test-Path -LiteralPath $MissionDirectory -PathType Container)) {
    throw 'Existing missions are immutable at launch. Use a new mission ID; preserve prior evidence.'
}
$CheckpointPath = Join-Path $RepoRoot 'CURRENT_STATE.md'
if (-not (Test-Path -LiteralPath $CheckpointPath)) { throw 'Persist CURRENT_STATE.md before launching.' }
if ((Get-Item -LiteralPath $CheckpointPath).Length -gt 8192) { throw 'CURRENT_STATE.md exceeds 8 KB.' }
if (-not (Get-Content -LiteralPath $CheckpointPath -Raw).Contains($MissionId)) { throw 'Record the mission ID in CURRENT_STATE.md before launch.' }

New-Item -ItemType Directory -Path $WorkersDirectory -Force | Out-Null
Copy-Item -LiteralPath $TaskPath -Destination $TaskSnapshotPath -Force
Copy-Item -LiteralPath $CheckpointPath -Destination (Join-Path $MissionDirectory "parent-state.snapshot.md")

$GitBranch = $null
$GitHead = $null

try {
    $GitBranch = (& git -C $RepoRoot branch --show-current 2>$null).Trim()
    $GitHead = (& git -C $RepoRoot rev-parse HEAD 2>$null).Trim()
}
catch {
}

$StartedAt = (Get-Date).ToUniversalTime().ToString("o")

$Manifest = [ordered]@{
    missionId = $MissionId
    status = "QUEUED"
    reviewStatus = "PENDING_PARENT"
    schemaVersion = 2
    parentStateSha256 = (Get-FileHash -LiteralPath $CheckpointPath -Algorithm SHA256).Hash
    createdAtUtc = $StartedAt
    taskFile = $TaskPath
    taskSnapshot = $TaskSnapshotPath
    profile = $Profile
    codexHome = $ResolvedCodexHome
    roles = @($Roles)
    repoRoot = $RepoRoot
    gitBranch = $GitBranch
    gitHead = $GitHead
    workersDirectory = $WorkersDirectory
    panelSummary = (Join-Path $WorkersDirectory "panel-summary.json")
    parentReview = (Join-Path $MissionDirectory "parent-review.md")
    parentHandoff = (Join-Path $MissionDirectory "PARENT_HANDOFF.md")
    readyForReview = (Join-Path $MissionDirectory "READY_FOR_PARENT_REVIEW.md")
    runnerStdout = $RunnerStdout
    runnerStderr = $RunnerStderr
    runnerPid = $null
    completedAtUtc = $null
    failure = $null
}

$Manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $ManifestPath -Encoding utf8

$Resume = @'
# Mission resume checkpoint

Read root AGENTS.md, CURRENT_STATE.md and the active task. Inspect mission.json
once using get-deepseek-mission-status.ps1. Do not start a duplicate or poll.
For WORKERS_COMPLETE / READY_FOR_PARENT (legacy READY_FOR_SOL is equivalent),
read PARENT_HANDOFF.md first, then only sections needed to arbitrate disagreement,
verify provenance or answer a concrete ambiguity. Write parent-review.md in English.
Consensus is not validation. Preserve all original reports and contradictions.
For WORKERS_FAILED, inspect failed role status and logs; retain successful scopes.
For QUEUED/RUNNING, continue useful independent work or end the parent session.
This detached runner completes without parent callbacks. Resume from persisted
state after quota loss. No gameplay modifications without task authorization.
'@

$Resume | Set-Content -LiteralPath $ResumePath -Encoding utf8

$PwshCommand = Get-Command pwsh -ErrorAction Stop
$RolesCsv = $Roles -join ","

try {
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
        "`"$RolesCsv`"",
        "-CodexHome",
        "`"$ResolvedCodexHome`""
    ) `
    -WorkingDirectory $RepoRoot `
    -RedirectStandardOutput $RunnerStdout `
    -RedirectStandardError $RunnerStderr `
    -WindowStyle Hidden `
    -PassThru
}
catch {
    $Manifest.status = 'WORKERS_FAILED'
    $Manifest.reviewStatus = 'BLOCKED'
    $Manifest.completedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
    $Manifest.failure = 'Detached runner could not be started. Inspect launcher error; no automatic retry.'
    $Manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $ManifestPath -Encoding utf8
    throw
}

# The runner is the sole manifest writer after launch: no stale parent overwrite.
[ordered]@{launcherPid=$PID; runnerPid=$Process.Id; returnedAtUtc=(Get-Date).ToUniversalTime().ToString('o')} |
    ConvertTo-Json | Set-Content -LiteralPath (Join-Path $MissionDirectory 'launch.json') -Encoding utf8

Write-Host "DeepSeek mission launched in detached mode."
Write-Host "Mission:    $MissionId"
Write-Host "PID:        $($Process.Id)"
Write-Host "CODEX_HOME: $ResolvedCodexHome"
Write-Host "State:      $ManifestPath"
Write-Host "Resume:     $ResumePath"
Write-Host ""
Write-Host "The parent Codex session may end without losing the mission state."
