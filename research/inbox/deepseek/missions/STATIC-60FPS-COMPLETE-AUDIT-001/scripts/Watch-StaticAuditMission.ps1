param(
    [string]$MissionId = "static-60fps-complete-audit-run-001",
    [string]$RepoRoot = "C:\Users\linki\Documents\PPSSPP\RAC_60FPS",
    [int]$RefreshSeconds = 5
)


Set-StrictMode -Version 2.0
$ErrorActionPreference = "SilentlyContinue"

function Read-JsonSafe {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    try {
        return (Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json)
    } catch {
        return $null
    }
}

function Strip-Ansi {
    param([string]$Text)
    if ($null -eq $Text) { return "" }
    $esc = [char]27
    return [regex]::Replace($Text, ([regex]::Escape([string]$esc) + '\[[0-9;?]*[ -/]*[@-~]'), "")
}

function Shorten-Line {
    param([string]$Text, [int]$Max = 220)
    $t = (Strip-Ansi $Text).Trim()
    $t = [regex]::Replace($t, '\s+', ' ')
    if ($t.Length -gt $Max) { return $t.Substring(0, $Max - 1) + "..." }
    return $t
}

function Get-ObjectProperty {
    param($Object, [string[]]$Names)
    if ($null -eq $Object) { return $null }
    foreach ($name in $Names) {
        $p = $Object.PSObject.Properties[$name]
        if ($null -ne $p -and $null -ne $p.Value -and "$($p.Value)".Length -gt 0) {
            return $p.Value
        }
    }
    return $null
}

function Extract-JsonText {
    param($Object)
    if ($null -eq $Object) { return $null }

    foreach ($name in @("activity","summary","message","text","content","detail","phase","task","statusText","description")) {
        $p = $Object.PSObject.Properties[$name]
        if ($null -ne $p -and $null -ne $p.Value) {
            if ($p.Value -is [string] -and $p.Value.Trim().Length -gt 0) {
                return (Shorten-Line $p.Value)
            }
            if ($p.Value -isnot [string] -and $p.Value -isnot [ValueType]) {
                $nested = Extract-JsonText $p.Value
                if ($nested) { return $nested }
            }
        }
    }
    return $null
}

function Get-MeaningfulTailText {
    param([string[]]$Paths)

    $candidateLines = New-Object System.Collections.Generic.List[string]

    foreach ($path in $Paths) {
        if (-not (Test-Path -LiteralPath $path)) { continue }

        $lines = @(Get-Content -LiteralPath $path -Tail 160 -Encoding UTF8)
        foreach ($raw in $lines) {
            $line = (Strip-Ansi ([string]$raw)).Trim()
            if (-not $line) { continue }

            if ($line.StartsWith("{") -and $line.EndsWith("}")) {
                try {
                    $obj = $line | ConvertFrom-Json
                    $jsonText = Extract-JsonText $obj
                    if ($jsonText) {
                        $candidateLines.Add($jsonText)
                        continue
                    }
                } catch {}
            }

            if ($line -match '^(DEBUG|TRACE|event:|data:)\s*') { continue }
            if ($line -match '^(usage|tokens?|input_tokens|output_tokens|cached|reasoning_tokens)\b') { continue }
            if ($line -match '^[{}\[\],]+$') { continue }
            if ($line.Length -lt 10) { continue }

            $candidateLines.Add((Shorten-Line $line))
        }
    }

    if ($candidateLines.Count -eq 0) {
        return @("Aucune phrase d'activite exploitable dans la fin des logs.")
    }

    $keywords = '(?i)\b(analy|inspect|read|search|map|classif|audit|review|trace|follow|write|updat|build|check|compar|scan|parse|investig|examin|shard|inventory|candidate|timing|function|object|module|PRX|address|caller|callee)\w*'
    $preferred = @($candidateLines | Where-Object { $_ -match $keywords })

    if ($preferred.Count -gt 0) {
        $src = @($preferred)
    } else {
        $src = @($candidateLines)
    }

    $result = New-Object System.Collections.Generic.List[string]
    for ($i = $src.Count - 1; $i -ge 0 -and $result.Count -lt 2; $i--) {
        $v = [string]$src[$i]
        if ($v -and -not $result.Contains($v)) {
            $result.Insert(0, $v)
        }
    }

    return @($result)
}

function Get-WorkerActivity {
    param([string]$MissionPath, [string]$Role)

    $activityCandidates = @(
        (Join-Path $MissionPath "workers\_activity\$Role.activity.json"),
        (Join-Path $MissionPath "workers\$Role.activity.json"),
        (Join-Path $MissionPath "workers\_logs\$Role.activity.json")
    )

    foreach ($path in $activityCandidates) {
        if (Test-Path -LiteralPath $path) {
            $a = Read-JsonSafe $path
            if ($a) {
                $summary = Get-ObjectProperty $a @("activity","summary","task","phase","message","text")
                $detail = Get-ObjectProperty $a @("detail")
                $lines = New-Object System.Collections.Generic.List[string]
                if ($summary) { $lines.Add((Shorten-Line ([string]$summary))) }
                if ($detail) { $lines.Add((Shorten-Line ([string]$detail))) }
                if ($lines.Count -gt 0) {
                    return [pscustomobject]@{
                        Source = "activity.json"
                        Lines = @($lines)
                    }
                }
            }
        }
    }

    $stderr = Join-Path $MissionPath "workers\_logs\$Role.stderr.log"
    $stdout = Join-Path $MissionPath "workers\_logs\$Role.stdout.log"

    return [pscustomobject]@{
        Source = "fin des logs (heuristique)"
        Lines = @(Get-MeaningfulTailText @($stderr,$stdout))
    }
}

function Get-WorkerSnapshot {
    param([string]$MissionPath, [string]$Role)

    $statusPath = Join-Path $MissionPath "workers\_logs\$Role.status.json"
    $stderrPath = Join-Path $MissionPath "workers\_logs\$Role.stderr.log"
    $stdoutPath = Join-Path $MissionPath "workers\_logs\$Role.stdout.log"
    $handoffPath = Join-Path $MissionPath "workers\$Role-handoff.json"
    $reportPath = Join-Path $MissionPath "workers\$Role.md"

    $statusObj = Read-JsonSafe $statusPath

    $state = Get-ObjectProperty $statusObj @("status","state","phase")
    $exitCode = Get-ObjectProperty $statusObj @("exitCode","exit_code")
    $workerPid = Get-ObjectProperty $statusObj @("pid","processId","process_id","childPid")

    if (-not $state) {
        if (Test-Path -LiteralPath $handoffPath) {
            $state = "HANDOFF_READY"
        } elseif (Test-Path -LiteralPath $stderrPath) {
            $age = ((Get-Date) - (Get-Item -LiteralPath $stderrPath).LastWriteTime).TotalSeconds
            if ($age -lt 90) { $state = "ACTIVE" } else { $state = "QUIET/UNKNOWN" }
        } else {
            $state = "NOT_STARTED/UNKNOWN"
        }
    }

    $activity = Get-WorkerActivity -MissionPath $MissionPath -Role $Role

    $lastWrite = $null
    [double]$totalBytes = 0

    foreach ($p in @($stderrPath,$stdoutPath,$statusPath,$handoffPath,$reportPath)) {
        if (Test-Path -LiteralPath $p) {
            $it = Get-Item -LiteralPath $p
            $totalBytes += [double]$it.Length
            if ($null -eq $lastWrite -or $it.LastWriteTime -gt $lastWrite) {
                $lastWrite = $it.LastWriteTime
            }
        }
    }

    return [pscustomobject]@{
        Role = $Role
        State = [string]$state
        PID = $(if ($workerPid) { [string]$workerPid } else { "" })
        ExitCode = $(if ($null -ne $exitCode) { [string]$exitCode } else { "" })
        LastWrite = $lastWrite
        TotalBytes = $totalBytes
        ActivitySource = $activity.Source
        ActivityLines = @($activity.Lines)
        Handoff = (Test-Path -LiteralPath $handoffPath)
        Report = (Test-Path -LiteralPath $reportPath)
    }
}

function Show-MissionSnapshot {
    param([string]$MissionId, [string]$RepoRoot)

    $missionPath = Join-Path $RepoRoot "research\inbox\deepseek\missions\$MissionId"
    $missionFile = Join-Path $missionPath "mission.json"

    if (-not (Test-Path -LiteralPath $missionFile)) {
        Write-Host "Mission introuvable: $missionPath" -ForegroundColor Red
        return
    }

    $m = Read-JsonSafe $missionFile
    if (-not $m) {
        Write-Host "mission.json illisible." -ForegroundColor Red
        return
    }

    $runnerPid = Get-ObjectProperty $m @("runnerPid")
    $runnerAlive = $false
    if ($runnerPid) {
        $runnerAlive = $null -ne (Get-Process -Id ([int]$runnerPid) -ErrorAction SilentlyContinue)
    }

    Write-Host "STATIC 60 FPS AUDIT - LIVE STATUS" -ForegroundColor Cyan
    Write-Host ("Mission      : {0}" -f $m.missionId)
    Write-Host ("Etat global  : {0}" -f $m.status)
    Write-Host ("Review       : {0}" -f $m.reviewStatus)

    $runnerState = if ($runnerAlive) { "vivant" } else { "absent/termine" }
    Write-Host ("Runner PID   : {0} ({1})" -f $runnerPid, $runnerState)
    Write-Host ("Creee UTC    : {0}" -f $m.createdAtUtc)

    if ($m.completedAtUtc) {
        Write-Host ("Terminee UTC : {0}" -f $m.completedAtUtc)
    }
    if ($m.failure) {
        Write-Host ("Failure      : {0}" -f $m.failure) -ForegroundColor Red
    }

    Write-Host ""

    foreach ($role in @($m.roles)) {
        $w = Get-WorkerSnapshot -MissionPath $missionPath -Role ([string]$role)

        if ($w.LastWrite) {
            $age = [int]((Get-Date) - $w.LastWrite).TotalSeconds
            $ageText = "$age s"
        } else {
            $ageText = "n/a"
        }

        if ($w.State -match 'FAIL|ERROR') {
            $stateColor = "Red"
        } elseif ($w.State -match 'COMPLETE|HANDOFF|SUCCESS') {
            $stateColor = "Green"
        } elseif ($w.State -match 'ACTIVE|RUNNING') {
            $stateColor = "Yellow"
        } else {
            $stateColor = "Gray"
        }

        Write-Host ("[{0}] {1}" -f $w.Role.ToUpper(), $w.State) -ForegroundColor $stateColor
        Write-Host ("  Derniere ecriture : {0}" -f $ageText)
        Write-Host ("  Artefacts         : {0:N0} octets" -f $w.TotalBytes)

        if ($w.PID) {
            Write-Host ("  PID worker        : {0}" -f $w.PID)
        }
        if ($w.ExitCode -ne "") {
            Write-Host ("  Exit code         : {0}" -f $w.ExitCode)
        }

        Write-Host ("  Handoff / rapport : {0} / {1}" -f $w.Handoff, $w.Report)
        Write-Host ("  Activite ({0}) :" -f $w.ActivitySource)

        foreach ($line in @($w.ActivityLines)) {
            Write-Host ("    - {0}" -f $line)
        }

        Write-Host ""
    }

    $panel = Join-Path $missionPath "workers\panel-summary.json"
    if (Test-Path -LiteralPath $panel) {
        Write-Host "Panel summary present." -ForegroundColor Green
    }

    $handoff = Join-Path $missionPath "PARENT_HANDOFF.md"
    if (Test-Path -LiteralPath $handoff) {
        Write-Host "PARENT_HANDOFF present." -ForegroundColor Green
    }

    Write-Host ("Actualise : {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
}


while ($true) {
    Clear-Host
    Show-MissionSnapshot -MissionId $MissionId -RepoRoot $RepoRoot
    Write-Host ""
    Write-Host ("Rafraichissement toutes les {0} s - Ctrl+C pour quitter." -f $RefreshSeconds) -ForegroundColor DarkGray
    Start-Sleep -Seconds $RefreshSeconds
}
