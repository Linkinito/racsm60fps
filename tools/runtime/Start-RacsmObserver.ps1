<#
.SYNOPSIS
  Launches the RACSM Runtime Observer v0.2.
.DESCRIPTION
  Finds a usable Node.js runtime, then starts tools/runtime/racsm-observer.mjs
  with the requested PPSSPP debugger port. The observer keeps one PPSSPP
  WebSocket connection open for the whole interactive session.
  This launcher never changes any PPSSPP setting. The PPSSPP debugger server
  must already be enabled and listening on the given port.
.EXAMPLE
  .\tools\runtime\Start-RacsmObserver.ps1 -Port 60907
.EXAMPLE
  .\tools\runtime\Start-RacsmObserver.ps1 -Port 60907 -MeasurementsDir D:\racsm-measurements
#>
[CmdletBinding()]
param(
    [int]$Port = 60907,
    [string]$MeasurementsDir,
    [string]$NodePath,
    [switch]$NoBanner,
    [switch]$SelfTest
)

$ErrorActionPreference = 'Stop'

$runtimeDir = $PSScriptRoot
$observerScript = Join-Path $runtimeDir 'racsm-observer.mjs'
$selfTestScript = Join-Path $runtimeDir 'tests\run-observer-tests.mjs'
if (-not (Test-Path -LiteralPath $observerScript)) {
    throw "Observer script not found: $observerScript"
}

function Test-NodeCandidate {
    param([string]$Path)
    if (-not $Path) { return $null }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    try {
        $version = (& $Path --version 2>$null | Select-Object -First 1).Trim()
    } catch {
        return $null
    }
    if ($version -notmatch '^v(\d+)\.') { return $null }
    $major = [int]$Matches[1]
    return [pscustomobject]@{ Path = $Path; Version = $version; Major = $major }
}

$candidates = New-Object System.Collections.Generic.List[string]
if ($NodePath) { $candidates.Add($NodePath) }
$onPath = Get-Command node -ErrorAction SilentlyContinue | Select-Object -First 1
if ($onPath) { $candidates.Add($onPath.Source) }
$candidates.Add((Join-Path $env:ProgramFiles 'nodejs\node.exe'))
if (${env:ProgramFiles(x86)}) { $candidates.Add((Join-Path ${env:ProgramFiles(x86)} 'nodejs\node.exe')) }
if ($env:LOCALAPPDATA) {
    $candidates.Add((Join-Path $env:LOCALAPPDATA 'Programs\nodejs\node.exe'))
    $candidates.Add((Join-Path $env:LOCALAPPDATA 'Programs\node\node.exe'))
    $candidates.AddRange([string[]](Get-ChildItem -Path (Join-Path $env:LOCALAPPDATA 'OpenAI\Codex\runtimes') -Filter 'node.exe' -Recurse -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }))
}
# Node runtimes shipped inside other applications (last resort, version-checked).
$candidates.Add((Join-Path $env:ProgramFiles 'Adobe\Adobe Creative Cloud Experience\libs\node.exe'))
$candidates.Add((Join-Path $env:ProgramFiles 'Common Files\Adobe\Creative Cloud Libraries\libs\node.exe'))
if ($env:USERPROFILE) { $candidates.Add((Join-Path $env:USERPROFILE '.lmstudio\.internal\utils\node.exe')) }

function Test-TcpListener {
    param([int]$TargetPort)
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $async = $client.BeginConnect('127.0.0.1', $TargetPort, $null, $null)
        if (-not $async.AsyncWaitHandle.WaitOne(700)) { return $false }
        $client.EndConnect($async)
        return $true
    } catch {
        return $false
    } finally {
        $client.Close()
    }
}

$node = $null
$rejected = @()
foreach ($candidate in $candidates) {
    $resolved = Test-NodeCandidate -Path $candidate
    if ($null -eq $resolved) { continue }
    if ($resolved.Major -lt 22) {
        $rejected += "$($resolved.Path) ($($resolved.Version))"
        continue
    }
    $node = $resolved
    break
}

if ($null -eq $node) {
    $message = @(
        'No usable Node.js runtime found (Node.js 22 or newer is required).',
        'Install Node.js, or pass an explicit runtime:',
        '  .\tools\runtime\Start-RacsmObserver.ps1 -Port 60907 -NodePath "C:\Program Files\nodejs\node.exe"'
    )
    if ($rejected.Count -gt 0) {
        $message += @('Rejected candidates (version < 22):') + ($rejected | ForEach-Object { "  $_" })
    }
    throw ($message -join [Environment]::NewLine)
}

Write-Host ("Node.js {0} -> {1}" -f $node.Version, $node.Path)

if ($SelfTest) {
    Write-Host "Running the self-test against a fake PPSSPP debugger (no emulator contact) ..."
    & $node.Path $selfTestScript
    exit $LASTEXITCODE
}

# Connectivity hint: this never changes any state.
if (Test-TcpListener -TargetPort $Port) {
    Write-Host "PPSSPP debugger port $Port is accepting connections."
} else {
    Write-Warning "Nothing is listening on TCP port $Port right now. Start PPSSPP with the debugger enabled, then run 'status' in the observer."
}

Write-Host 'RACSM Observer v0.2 never writes game memory; automatic profiles own one temporary breakpoint only for address discovery.'

$arguments = @($observerScript, '--port', $Port)
if ($MeasurementsDir) { $arguments += @('--measurements', $MeasurementsDir) }
if ($NoBanner) { $arguments += '--no-banner' }

& $node.Path @arguments
exit $LASTEXITCODE
