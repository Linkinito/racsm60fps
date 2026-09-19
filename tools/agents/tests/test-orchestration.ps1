$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../..'))
$Scripts = Join-Path $Root 'tools/agents/scripts'
$TestId = 'infra-fixture-' + [Guid]::NewGuid().ToString('N')
$Missions = [IO.Path]::GetFullPath((Join-Path $Root 'research/inbox/deepseek/missions'))
$Fixture = [IO.Path]::GetFullPath((Join-Path $Missions $TestId))
function Assert($Condition, $Message) { if (-not $Condition) { throw $Message } }
try {
    foreach ($File in Get-ChildItem -LiteralPath $Scripts -Filter '*.ps1') {
        $Tokens = $null; $ParseErrors = $null
        [Management.Automation.Language.Parser]::ParseFile($File.FullName, [ref]$Tokens, [ref]$ParseErrors) | Out-Null
        Assert ($ParseErrors.Count -eq 0) "Syntax: $($File.Name)"
    }
    New-Item -ItemType Directory -Path "$Fixture/workers/_logs" -Force | Out-Null
    $Manifest = @{missionId=$TestId; schemaVersion=2; status='RUNNING'; reviewStatus='PENDING_PARENT'; roles=@('explorer','mapper','skeptic'); runnerPid=$null; createdAtUtc=[DateTime]::UtcNow.ToString('o'); completedAtUtc=$null}
    $Manifest | ConvertTo-Json | Set-Content "$Fixture/mission.json"
    $Data = [ordered]@{established='OBSERVED: fixture only';corroborated='UNKNOWN';inferred='UNKNOWN';contradictions='NONE';rejected='NONE';unknown='UNKNOWN';top_hypotheses='UNKNOWN';best_discriminating_test='Host assertions';blockers='NONE';full_report_required='no: fixture only'}
    $Report = "$Fixture/workers/explorer.md"
    $Body = "# Full report`nEvidence retained.`n<!-- PARENT_HANDOFF_V1 -->`n" + '```json' + "`n" + ($Data | ConvertTo-Json) + "`n" + '```' + "`n<!-- /PARENT_HANDOFF_V1 -->"
    $Body | Set-Content $Report
    $Before = (Get-FileHash $Report).Hash
    & "$Scripts/export-parent-handoff.ps1" -ReportPath $Report -Role explorer
    Assert ((Get-FileHash $Report).Hash -eq $Before) 'Extraction changed full report'
    $Extracted = Get-Content "$Fixture/workers/explorer-handoff.json" -Raw | ConvertFrom-Json
    Assert ($Extracted.sourceSha256 -eq $Before) 'Provenance hash mismatch'
    '{"succeeded":true,"exitCode":0}' | Set-Content "$Fixture/workers/_logs/explorer.status.json"
    '{"succeeded":false,"exitCode":1}' | Set-Content "$Fixture/workers/_logs/mapper.status.json"
    $Status = & "$Scripts/get-deepseek-mission-status.ps1" -MissionId $TestId | ConvertFrom-Json
    Assert ($Status.success -eq 1 -and $Status.failed -eq 1 -and $Status.pending -eq 1) 'Partial outcome count mismatch'
    & "$Scripts/export-parent-handoff.ps1" -MissionDirectory $Fixture
    $Aggregate = Get-Content "$Fixture/PARENT_HANDOFF.md" -Raw
    Assert ($Aggregate.Contains('No compact worker handoff') -and $Aggregate.Contains('OBSERVED: fixture only')) 'Missing-role aggregate lost evidence'
    $CompletionRejected = $false
    try { & "$Scripts/export-parent-handoff.ps1" -MissionDirectory $Fixture -Status WORKERS_COMPLETE } catch { $CompletionRejected = $true }
    Assert $CompletionRejected 'Completion allowed with missing handoffs'
    foreach ($Bad in @('no block', $Body.Replace('"UNKNOWN"','null'), $Body.Replace('OBSERVED: fixture only',('x' * 181)))) {
        $Bad | Set-Content "$Fixture/workers/mapper.md"
        $Rejected = $false
        try { & "$Scripts/export-parent-handoff.ps1" -ReportPath "$Fixture/workers/mapper.md" -Role mapper } catch { $Rejected = $true }
        Assert $Rejected 'Malformed handoff accepted'
    }
    # Legacy completion requires reports + recorded success, never a new handoff.
    $Manifest.Remove('schemaVersion'); $Manifest.roles=@('explorer'); $Manifest.status='WORKERS_COMPLETE'; $Manifest.reviewStatus='READY_FOR_SOL'
    $Manifest | ConvertTo-Json | Set-Content "$Fixture/mission.json"
    Remove-Item -LiteralPath "$Fixture/workers/explorer-handoff.json","$Fixture/workers/_logs/explorer.status.json"
    '{"roles":[{"role":"explorer","succeeded":true}]}' | Set-Content "$Fixture/workers/panel-summary.json"
    $Legacy = & "$Scripts/get-deepseek-mission-status.ps1" -MissionId $TestId | ConvertFrom-Json
    Assert ($Legacy.success -eq 1 -and $null -eq $Legacy.workers[0].exitCode) 'Legacy completion compatibility failed'
    & "$Scripts/export-parent-handoff.ps1" -MissionDirectory $Fixture -Legacy
    Assert ((Get-Content "$Fixture/PARENT_HANDOFF.md" -Raw).Contains('UNKNOWN')) 'Legacy synthesis invented'
    Assert ((Get-Item "$Root/CURRENT_STATE.md").Length -le 8192) 'Checkpoint too large'
    'PASS: syntax, immutable full report/hash, extraction, malformed/oversize rejection, partial counts, legacy compatibility, checkpoint limit.'
} finally {
    # Delete only this generated fixture, using one native shell and checked root.
    if ($Fixture.StartsWith($Missions + [IO.Path]::DirectorySeparatorChar) -and (Split-Path $Fixture -Leaf) -eq $TestId -and (Test-Path -LiteralPath $Fixture)) {
        Remove-Item -LiteralPath $Fixture -Recurse -Force
    }
}
