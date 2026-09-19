[CmdletBinding()]
param(
    [string]$ReportPath,
    [ValidateSet('explorer','mapper','skeptic')][string]$Role,
    [string]$MissionDirectory,
    [switch]$Legacy,
    [string]$Status,
    [string]$ReviewStatus
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Fields = @('established','corroborated','inferred','contradictions','rejected','unknown','top_hypotheses','best_discriminating_test','blockers','full_report_required')

if ($ReportPath) {
    $Raw = Get-Content -LiteralPath $ReportPath -Raw -Encoding utf8
    $Match = [regex]::Match($Raw, '(?s)<!-- PARENT_HANDOFF_V1 -->\s*```json\s*(.*?)\s*```\s*<!-- /PARENT_HANDOFF_V1 -->')
    if (-not $Match.Success) { throw "Missing compact handoff in $ReportPath; full report preserved." }
    $Data = $Match.Groups[1].Value | ConvertFrom-Json -AsHashtable
    foreach ($Field in $Fields) {
        if (-not $Data.ContainsKey($Field) -or $Data[$Field] -isnot [string] -or [string]::IsNullOrWhiteSpace($Data[$Field])) {
            throw "Invalid handoff field: $Field"
        }
        if ($Data[$Field].Length -gt 180) { throw "Handoff field exceeds 180 characters: $Field" }
    }
    if ($Data.full_report_required -notmatch '^(yes: .+|no: .+)$') { throw 'full_report_required must be yes/no: reason and exact section when yes.' }
    if ([Text.Encoding]::UTF8.GetByteCount(($Data | ConvertTo-Json -Compress)) -gt 2400) { throw 'Compact handoff exceeds 2400 bytes.' }
    $Clean = [ordered]@{schemaVersion=1; role=$Role; sourceReport=(Split-Path $ReportPath -Leaf); sourceSha256=(Get-FileHash -LiteralPath $ReportPath -Algorithm SHA256).Hash}
    foreach ($Field in $Fields) { $Clean[$Field] = $Data[$Field] }
    $Destination = Join-Path (Split-Path $ReportPath) "$Role-handoff.json"
    $Clean | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $Destination -Encoding utf8
    return
}
if (-not $MissionDirectory) { throw 'Provide ReportPath/Role or MissionDirectory.' }
$Manifest = Get-Content -LiteralPath (Join-Path $MissionDirectory 'mission.json') -Raw | ConvertFrom-Json
$Lines = [Collections.Generic.List[string]]::new()
$Lines.Add("# PARENT HANDOFF — $($Manifest.missionId)")
$Lines.Add("MISSION: $($Manifest.missionId)")
$DisplayStatus = if ($Status) { $Status } else { $Manifest.status }
$DisplayReview = if ($ReviewStatus) { $ReviewStatus } else { $Manifest.reviewStatus }
$Lines.Add("STATUS: $DisplayStatus / $DisplayReview")
$Lines.Add('Worker claims only. ESTABLISHED means worker-reported observations, not parent validation. Consensus is not validation.')
foreach ($WorkerRole in $Manifest.roles) {
    $Lines.Add("`n## $WorkerRole")
    $Path = Join-Path $MissionDirectory "workers/$WorkerRole-handoff.json"
    if (Test-Path -LiteralPath $Path) {
        $Data = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json -AsHashtable
        foreach ($Field in $Fields) { $Lines.Add("$($Field.ToUpper().Replace('_',' ')): $($Data[$Field])") }
        $Lines.Add("SOURCE: workers/$WorkerRole.md (hash in workers/$WorkerRole-handoff.json)")
    } else {
        if ($Status -eq 'WORKERS_COMPLETE' -and -not $Legacy) { throw "Required handoff missing for completed role: $WorkerRole" }
        $Lines.Add('UNKNOWN: No compact worker handoff is available. No summary has been invented.')
        $Lines.Add("FULL REPORT REQUIRED: yes: workers/$WorkerRole.md; use task-targeted headings to select sections. Verify provenance before reuse.")
        if (-not $Legacy) { $Lines.Add('BLOCKERS: Missing/invalid worker handoff; inspect role status. Completion must not be inferred.') }
    }
}
$Lines.Add("`nMachine counts, exit codes, timestamps and sizes: run get-deepseek-mission-status.ps1 -MissionId $($Manifest.missionId)")
$Lines | Set-Content -LiteralPath (Join-Path $MissionDirectory 'PARENT_HANDOFF.md') -Encoding utf8
