$ErrorActionPreference = 'Stop'
$dest = Join-Path $PSScriptRoot 'Overcompensated-Reprise-2026-09-14'
New-Item -ItemType Directory -Path $dest -Force | Out-Null
$downloads = 'C:\Users\linki\Downloads'
$files = Get-ChildItem -LiteralPath $downloads -File | Where-Object { $_.Name -match '^(Size_Matters_|RCSM|RACSM_|Pokitaru_60|Dossier_technique_patch_60|Synthese_Patch_60|prx_timing_audit|named_timing_audit|PRX_extracted)' }
$archiveDir = Join-Path $dest 'archives'
New-Item -ItemType Directory -Path $archiveDir -Force | Out-Null
$manifest = foreach ($f in $files) {
    $target = Join-Path $archiveDir $f.Name
    if (!(Test-Path -LiteralPath $target)) { Copy-Item -LiteralPath $f.FullName -Destination $target }
    [pscustomobject]@{Source=$f.FullName;Copy=$target;Bytes=$f.Length;SHA256=(Get-FileHash -LiteralPath $target).Hash}
}
$manifest | Export-Csv -LiteralPath (Join-Path $dest 'archives-manifest.csv') -NoTypeInformation -Encoding utf8
$snapshot = Join-Path $dest 'snapshot-original'
if (!(Test-Path -LiteralPath $snapshot)) {
    New-Item -ItemType Directory -Path $snapshot | Out-Null
    foreach ($name in @('PLUGINS','Cheats','SAVEDATA','PPSSPP_STATE')) { Copy-Item -LiteralPath (Join-Path $PSScriptRoot "PSP\$name") -Destination $snapshot -Recurse }
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'RACSM_Controls') -Destination $snapshot -Recurse
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'PSP\SYSTEM\ppsspp.ini'),(Join-Path $PSScriptRoot 'PSP\SYSTEM\controls.ini') -Destination $snapshot
}
$expanded = Join-Path $dest 'sources-v0.4.5'
if (!(Test-Path -LiteralPath $expanded)) { Expand-Archive -LiteralPath (Join-Path $archiveDir 'Size_Matters_wrapper_profiler_v0.4.5-prealpha_UCES00420.zip') -DestinationPath $expanded }
Get-ChildItem -LiteralPath $snapshot -Recurse -File | ForEach-Object { [pscustomobject]@{Path=$_.FullName;Bytes=$_.Length;SHA256=(Get-FileHash -LiteralPath $_.FullName).Hash} } | Export-Csv -LiteralPath (Join-Path $dest 'snapshot-manifest.csv') -NoTypeInformation -Encoding utf8
Get-ChildItem -LiteralPath 'C:\Users\linki\Downloads\Ratchet & Clank - Size Matters (Europe) (PSN)' -Recurse -File | Select-Object FullName,Length,LastWriteTimeUtc | Export-Csv -LiteralPath (Join-Path $dest 'game-files.csv') -NoTypeInformation -Encoding utf8
Write-Output "Recovery directory: $dest"
Write-Output "Archives copied: $($files.Count)"
Get-ChildItem -LiteralPath $expanded -Recurse -File | Where-Object Extension -eq '.md' | ForEach-Object FullName
