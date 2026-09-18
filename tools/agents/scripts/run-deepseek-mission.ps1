[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$MissionDirectory,

    [Parameter(Mandatory = $true)]
    [string]$TaskFile,

    [Parameter(Mandatory = $true)]
    [string]$Profile,

    [Parameter(Mandatory = $true)]
    [string]$RolesCsv
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\..\.."))
$PanelScript = Join-Path $PSScriptRoot "invoke-deepseek-panel.ps1"
$ManifestPath = Join-Path $MissionDirectory "mission.json"
$WorkersDirectory = Join-Path $MissionDirectory "workers"
$ReadyPath = Join-Path $MissionDirectory "READY_FOR_SOL_REVIEW.md"

function Read-Manifest {
    if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) {
        throw "Mission manifest not found: $ManifestPath"
    }

    return Get-Content -LiteralPath $ManifestPath -Raw -Encoding utf8 | ConvertFrom-Json
}

function Write-Manifest {
    param([Parameter(Mandatory = $true)]$Manifest)

    $Manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $ManifestPath -Encoding utf8
}

$Manifest = Read-Manifest
$Manifest.status = "RUNNING"
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
    $Manifest.reviewStatus = "READY_FOR_SOL"
    $Manifest.completedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
    $Manifest.failure = $null
    Write-Manifest $Manifest

    $Ready = @"
# Ready for Sol review

The external DeepSeek worker stage completed successfully.

Mission: $($Manifest.missionId)

Read, in this order:

1. `AGENTS.md`
2. `PROJECT_GOALS.md`
3. `MIGRATION.md`
4. `docs/methodology/EVIDENCE_LEVELS.md`
5. `$($Manifest.taskSnapshot)`
6. `$($Manifest.panelSummary)`
7. `workers/explorer.md`
8. `workers/mapper.md`
9. `workers/skeptic.md`

Then write the critical parent synthesis to:

`$($Manifest.solReview)`

Rules:

- Do not treat agreement among workers as validation.
- Distinguish OBSERVED / INFERRED / CORROBORATED / TESTED.
- Preserve contradictions rather than averaging them away.
- Identify the deterministic test that would resolve each material uncertainty.
- Astra is escalation, not a quota fallback and not an authority of truth.
- Priority 0 is 30 FPS -> 60 FPS behavioral parity.
"@

    $Ready | Set-Content -LiteralPath $ReadyPath -Encoding utf8
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
    }
    catch {
        # Preserve original failure as process exit even if manifest update fails.
    }

    Write-Error $FailureText
    exit 1
}
