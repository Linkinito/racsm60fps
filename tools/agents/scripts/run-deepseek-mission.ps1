[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$MissionDirectory,

    [Parameter(Mandatory = $true)]
    [string]$TaskFile,

    [Parameter(Mandatory = $true)]
    [string]$Profile,

    [Parameter(Mandatory = $true)]
    [string]$RolesCsv,

    [Parameter(Mandatory = $true)]
    [string]$CodexHome
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\..\.."))
$PanelScript = Join-Path $PSScriptRoot "invoke-deepseek-panel.ps1"
$ManifestPath = Join-Path $MissionDirectory "mission.json"
$WorkersDirectory = Join-Path $MissionDirectory "workers"
$ReadyPath = Join-Path $MissionDirectory "READY_FOR_PARENT_REVIEW.md"

# Critical for detached runs launched from Codex desktop:
# the child may execute under CodexSandboxOffline without a usable HOME.
$env:CODEX_HOME = [System.IO.Path]::GetFullPath($CodexHome)

function Read-Manifest {
    if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) {
        throw "Mission manifest not found: $ManifestPath"
    }

    return Get-Content -LiteralPath $ManifestPath -Raw -Encoding utf8 | ConvertFrom-Json
}

function Write-Manifest {
    param([Parameter(Mandatory = $true)]$Manifest)
    $TemporaryPath = "$ManifestPath.tmp"
    $Manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $TemporaryPath -Encoding utf8
    Move-Item -LiteralPath $TemporaryPath -Destination $ManifestPath -Force
}

$Manifest = Read-Manifest
$Manifest.status = "RUNNING"
$Manifest.runnerPid = $PID
$Manifest.codexHome = $env:CODEX_HOME
Write-Manifest $Manifest

$Roles = @($RolesCsv -split "," | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

try {
    & $PanelScript `
        -TaskFile $TaskFile `
        -OutputDirectory $WorkersDirectory `
        -Roles $Roles `
        -Profile $Profile `
        -Force

    $Manifest = Read-Manifest
    $Manifest.status = "WORKERS_COMPLETE"
    $Manifest.reviewStatus = "READY_FOR_PARENT"
    $Manifest.completedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
    $Manifest.failure = $null

    & (Join-Path $PSScriptRoot 'export-parent-handoff.ps1') -MissionDirectory $MissionDirectory -Status $Manifest.status -ReviewStatus $Manifest.reviewStatus
    $Ready = @'
# Ready for parent review

Read PARENT_HANDOFF.md first. Use mission.json and workers/panel-summary.json
for deterministic completion evidence. Open full report sections only for
disagreement, provenance verification, requested review or genuine ambiguity.
Write parent-review.md in English. Worker completion is not gameplay validation.
Update root CURRENT_STATE.md before ending the parent session.
'@

    $Ready | Set-Content -LiteralPath $ReadyPath -Encoding utf8
    Write-Manifest $Manifest
    exit 0
}
catch {
    $FailureText = ($_ | Out-String).Trim()

    try {
        $Manifest = Read-Manifest
        $Manifest.status = "WORKERS_FAILED"
        $Manifest.reviewStatus = "BLOCKED"
        $Manifest.completedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
        $Manifest.failure = $FailureText
        Write-Manifest $Manifest
        if (Test-Path -LiteralPath $ReadyPath) { Remove-Item -LiteralPath $ReadyPath -Force }
        & (Join-Path $PSScriptRoot "export-parent-handoff.ps1") -MissionDirectory $MissionDirectory
    }
    catch {
    }

    Write-Error $FailureText
    exit 1
}
