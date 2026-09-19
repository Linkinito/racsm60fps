[CmdletBinding()]
param([ValidatePattern('^[A-Za-z0-9._-]+$')][string]$MissionId)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$RepoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../..'))
$Root = Join-Path $RepoRoot 'research/inbox/deepseek/missions'
$Dir = if ($MissionId) { Join-Path $Root $MissionId } else {
    (Get-ChildItem -LiteralPath $Root -Directory | Sort-Object LastWriteTimeUtc -Descending | Select-Object -First 1).FullName
}
$M = Get-Content -LiteralPath (Join-Path $Dir 'mission.json') -Raw | ConvertFrom-Json -AsHashtable
$Rows = @()
foreach ($Role in $M.roles) {
    $Report = Join-Path $Dir "workers/$Role.md"
    $Handoff = Join-Path $Dir "workers/$Role-handoff.json"
    $StatusPath = Join-Path $Dir "workers/_logs/$Role.status.json"
    $S = if (Test-Path -LiteralPath $StatusPath) { Get-Content -LiteralPath $StatusPath -Raw | ConvertFrom-Json -AsHashtable } else { $null }
    if (-not $S -and (Test-Path -LiteralPath (Join-Path $Dir 'workers/panel-summary.json'))) {
        $Panel = Get-Content -LiteralPath (Join-Path $Dir 'workers/panel-summary.json') -Raw | ConvertFrom-Json
        $Old = @($Panel.roles | Where-Object role -eq $Role)
        if ($Old.Count) { $S = @{succeeded=[bool]$Old[0].succeeded} }
    }
    $Bytes = if (Test-Path -LiteralPath $Report) { (Get-Item -LiteralPath $Report).Length } else { 0 }
    $NeedsHandoff = $M.ContainsKey('schemaVersion') -and $M.schemaVersion -ge 2
    $Good = $S -and $S.succeeded -and $Bytes -gt 0 -and ((-not $NeedsHandoff) -or (Test-Path -LiteralPath $Handoff))
    $State = if ($Good) { 'SUCCESS' } elseif ($S) { 'FAILED' } else { 'PENDING' }
    $Rows += [ordered]@{role=$Role; status=$State; exitCode=if($S -and $S.ContainsKey('exitCode')){$S.exitCode}else{$null}; reportBytes=$Bytes; handoffExists=(Test-Path -LiteralPath $Handoff)}
}
$Running = $false
if ($M.runnerPid) {
    $Process = Get-Process -Id $M.runnerPid -ErrorAction SilentlyContinue
    if ($Process) {
        try { $Running = $Process.StartTime.ToUniversalTime() -ge ([DateTime]$M.createdAtUtc).ToUniversalTime().AddSeconds(-2) -and $Process.ProcessName -match 'pwsh|powershell' } catch { }
    }
}
$Terminal = $M.status -in @('WORKERS_COMPLETE','WORKERS_FAILED')
[ordered]@{
    mission=$M.missionId; status=$M.status; review=$M.reviewStatus
    success=@($Rows | Where-Object status -eq SUCCESS).Count
    failed=@($Rows | Where-Object status -eq FAILED).Count
    pending=@($Rows | Where-Object status -eq PENDING).Count
    runnerActive=$Running
    attention=if(-not $Terminal -and -not $Running){'Runner not verified alive; inspect launch.json/logs once. Do not restart blindly.'}else{$null}
    createdAtUtc=$M.createdAtUtc; completedAtUtc=$M.completedAtUtc
    resumeExists=(Test-Path -LiteralPath (Join-Path $Dir 'RESUME.md'))
    parentHandoffExists=(Test-Path -LiteralPath (Join-Path $Dir 'PARENT_HANDOFF.md'))
    readyExists=((Test-Path -LiteralPath (Join-Path $Dir 'READY_FOR_PARENT_REVIEW.md')) -or (Test-Path -LiteralPath (Join-Path $Dir 'READY_FOR_SOL_REVIEW.md')))
    workers=$Rows
} | ConvertTo-Json -Depth 5 -Compress
