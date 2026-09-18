$ErrorActionPreference = 'Stop'
$pp = @(Get-Process PPSSPPWindows64,PPSSPPWindows -ErrorAction SilentlyContinue)
if ($pp.Count -ne 1) { throw 'Exactly one PPSSPP process must be running.' }
$listeners = @(Get-NetTCPConnection -State Listen | Where-Object OwningProcess -eq $pp[0].Id | Select-Object -ExpandProperty LocalPort -Unique)
if (!$listeners.Count) { throw 'No listener found. Enable the PPSSPP remote debugger.' }
foreach ($port in $listeners) {
    & node (Join-Path $PSScriptRoot 'ppsspp-probe.mjs') $port
    if ($LASTEXITCODE -eq 0) { exit 0 }
}
throw 'No PPSSPP debugger responded successfully. Inspect connection reports.'
