[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TaskFile,

    [string]$OutputDirectory,

    [ValidateSet("explorer", "mapper", "skeptic")]
    [string[]]$Roles = @("explorer", "mapper", "skeptic"),

    [string]$Profile = "deepseek-flash-high",

    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-RepoPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PathValue,

        [Parameter(Mandatory = $true)]
        [string]$RepoRoot
    )

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return [System.IO.Path]::GetFullPath($PathValue)
    }

    return [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $PathValue))
}

function Quote-SingleQuotedPowerShellString {
    param([Parameter(Mandatory = $true)][string]$Value)
    return "'" + ($Value -replace "'", "''") + "'"
}

# tools/agents/scripts -> repository root
$RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\..\.."))
$WorkerScript = Join-Path $PSScriptRoot "invoke-deepseek-worker.ps1"
$TaskPath = Resolve-RepoPath -PathValue $TaskFile -RepoRoot $RepoRoot

if (-not (Test-Path -LiteralPath $WorkerScript -PathType Leaf)) {
    throw "Worker script not found: $WorkerScript"
}

if (-not (Test-Path -LiteralPath $TaskPath -PathType Leaf)) {
    throw "Task file not found: $TaskPath"
}

if ($Roles.Count -eq 0) {
    throw "At least one role must be specified."
}

$PwshCommand = Get-Command pwsh -ErrorAction SilentlyContinue
if (-not $PwshCommand) {
    throw "PowerShell 7 (pwsh) was not found in PATH."
}
$PwshExe = $PwshCommand.Source

if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $TaskStem = [System.IO.Path]::GetFileNameWithoutExtension($TaskPath)
    $OutputDirectory = "research/inbox/deepseek/$TaskStem"
}

$ResolvedOutputDirectory = Resolve-RepoPath -PathValue $OutputDirectory -RepoRoot $RepoRoot

if (-not (Test-Path -LiteralPath $ResolvedOutputDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $ResolvedOutputDirectory -Force | Out-Null
}

$LogDirectory = Join-Path $ResolvedOutputDirectory "_logs"
if (-not (Test-Path -LiteralPath $LogDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $LogDirectory -Force | Out-Null
}

$ExpectedOutputs = @{}
foreach ($Role in $Roles) {
    $ExpectedOutputs[$Role] = Join-Path $ResolvedOutputDirectory "$Role.md"

    if ((Test-Path -LiteralPath $ExpectedOutputs[$Role] -PathType Leaf) -and -not $Force) {
        throw "Output already exists for role '$Role': $($ExpectedOutputs[$Role]). Use -Force to overwrite panel outputs."
    }
}

$StartedAt = (Get-Date).ToUniversalTime()

Write-Host "Starting DeepSeek panel..."
Write-Host "Task:    $TaskPath"
Write-Host "Roles:   $($Roles -join ', ')"
Write-Host "Profile: $Profile"
Write-Host "Output:  $ResolvedOutputDirectory"
Write-Host ""

$Workers = @()

foreach ($Role in $Roles) {
    $ReportPath = $ExpectedOutputs[$Role]
    $StdoutPath = Join-Path $LogDirectory "$Role.stdout.log"
    $StderrPath = Join-Path $LogDirectory "$Role.stderr.log"
    $StatusPath = Join-Path $LogDirectory "$Role.status.json"

    Remove-Item -LiteralPath $StdoutPath, $StderrPath, $StatusPath -Force -ErrorAction SilentlyContinue

    # The child writes its own status marker. This avoids relying on
    # Start-Process.ExitCode, which can be null/unreliable in some host
    # combinations even after WaitForExit().
    $WorkerScriptQ = Quote-SingleQuotedPowerShellString $WorkerScript
    $RoleQ = Quote-SingleQuotedPowerShellString $Role
    $TaskQ = Quote-SingleQuotedPowerShellString $TaskPath
    $ReportQ = Quote-SingleQuotedPowerShellString $ReportPath
    $ProfileQ = Quote-SingleQuotedPowerShellString $Profile
    $StatusQ = Quote-SingleQuotedPowerShellString $StatusPath

    $ForceArgument = if ($Force) { " -Force" } else { "" }

    $ChildCommand = @"
`$ErrorActionPreference = 'Stop'
`$status = [ordered]@{
    succeeded = `$false
    message = `$null
    exitCode = 1
    startedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
    completedAtUtc = `$null
}
try {
    & $WorkerScriptQ -Role $RoleQ -TaskFile $TaskQ -OutputFile $ReportQ -Profile $ProfileQ$ForceArgument
    `$status.succeeded = `$true
    `$status.exitCode = 0
}
catch {
    `$status.message = (`$_ | Out-String).Trim()
    Write-Error `$_
}
finally {
    `$status.completedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
    `$status | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $StatusQ -Encoding utf8
}
if (-not `$status.succeeded) { exit 1 }
exit 0
"@

    $EncodedCommand = [Convert]::ToBase64String(
        [Text.Encoding]::Unicode.GetBytes($ChildCommand)
    )

    $Process = Start-Process `
        -FilePath $PwshExe `
        -ArgumentList @(
            "-NoLogo",
            "-NoProfile",
            "-ExecutionPolicy",
            "Bypass",
            "-EncodedCommand",
            $EncodedCommand
        ) `
        -WorkingDirectory $RepoRoot `
        -RedirectStandardOutput $StdoutPath `
        -RedirectStandardError $StderrPath `
        -WindowStyle Hidden `
        -PassThru

    $Workers += [pscustomobject]@{
        role       = $Role
        process    = $Process
        report     = $ReportPath
        stdoutLog  = $StdoutPath
        stderrLog  = $StderrPath
        statusFile = $StatusPath
    }

    Write-Host ("Started {0,-10} PID {1}" -f $Role, $Process.Id)
}

Write-Host ""
Write-Host "Waiting for DeepSeek workers..."

foreach ($Worker in $Workers) {
    $Worker.process.WaitForExit()
}

$CompletedAt = (Get-Date).ToUniversalTime()
$Results = @()

foreach ($Worker in $Workers) {
    $ReportExists = Test-Path -LiteralPath $Worker.report -PathType Leaf
    $ReportBytes = if ($ReportExists) {
        (Get-Item -LiteralPath $Worker.report).Length
    }
    else {
        0
    }

    $StatusExists = Test-Path -LiteralPath $Worker.statusFile -PathType Leaf
    $ChildSucceeded = $false
    $ChildMessage = $null

    if ($StatusExists) {
        try {
            $ChildStatus = Get-Content -LiteralPath $Worker.statusFile -Raw -Encoding utf8 | ConvertFrom-Json
            $ChildSucceeded = [bool]$ChildStatus.succeeded
            $ChildMessage = $ChildStatus.message
        }
        catch {
            $ChildMessage = "Could not parse child status file: $($_.Exception.Message)"
        }
    }
    else {
        $ChildMessage = "Child status file was not created."
    }

    $Succeeded = ($ChildSucceeded -and $ReportExists -and $ReportBytes -gt 0)

    $Results += [pscustomobject]@{
        role          = $Worker.role
        succeeded     = $Succeeded
        childSucceeded = $ChildSucceeded
        exitCode = if ($ChildSucceeded) { 0 } else { 1 }
        handoff = (Join-Path $ResolvedOutputDirectory "$($Worker.role)-handoff.json")
        report        = $Worker.report
        reportExists  = $ReportExists
        reportBytes   = $ReportBytes
        stdoutLog     = $Worker.stdoutLog
        stderrLog     = $Worker.stderrLog
        statusFile    = $Worker.statusFile
        failureReason = $ChildMessage
    }
}

$Summary = [pscustomobject]@{
    taskFile       = $TaskPath
    profile        = $Profile
    startedAtUtc   = $StartedAt.ToString("o")
    completedAtUtc = $CompletedAt.ToString("o")
    roles          = $Results
}

$SummaryPath = Join-Path $ResolvedOutputDirectory "panel-summary.json"
$Summary | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $SummaryPath -Encoding utf8

Write-Host ""
Write-Host "DeepSeek panel results:"
foreach ($Result in $Results) {
    $State = if ($Result.succeeded) { "PASS" } else { "FAIL" }
    Write-Host ("  {0,-10} {1,-5} bytes={2}  {3}" -f `
        $Result.role,
        $State,
        $Result.reportBytes,
        $Result.report)
}

Write-Host "Summary: $SummaryPath"

$Failed = @($Results | Where-Object { -not $_.succeeded })

if ($Failed.Count -gt 0) {
    Write-Host ""
    Write-Host "Failure diagnostics:"

    foreach ($Result in $Failed) {
        Write-Host ""
        Write-Host "[$($Result.role)]"

        if (-not [string]::IsNullOrWhiteSpace($Result.failureReason)) {
            Write-Host "  Status: $($Result.failureReason)"
        }

        if (Test-Path -LiteralPath $Result.stderrLog -PathType Leaf) {
            $Tail = Get-Content -LiteralPath $Result.stderrLog -Tail 30 -Encoding utf8 -ErrorAction SilentlyContinue

            if ($Tail) {
                Write-Host "  stderr tail:"
                $Tail | ForEach-Object { Write-Host "    $_" }
            }
        }
    }

    $FailedRoles = ($Failed.role -join ", ")
    throw "DeepSeek panel completed with failed or missing reports for: $FailedRoles"
}

# Preserve child status and diagnostic logs for detached provenance.

Write-Host ""
Write-Host "DeepSeek panel completed successfully."
