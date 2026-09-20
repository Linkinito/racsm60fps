param(
    [string]$RepoRoot = "C:\Users\linki\Documents\PPSSPP\RAC_60FPS"
)

$ErrorActionPreference = "Stop"

$mission = Join-Path $RepoRoot "reports\STATIC-60FPS-COMPLETE-AUDIT-001"

$inventoryPath = Join-Path $mission "master_inventory.csv"
$mechanismsPath = Join-Path $mission "timing_mechanisms.csv"
$candidatesPath = Join-Path $mission "patch_candidates.csv"

foreach ($p in @($inventoryPath, $mechanismsPath, $candidatesPath)) {
    if (-not (Test-Path $p)) {
        throw "Missing required table: $p"
    }
}

$inventory = Import-Csv $inventoryPath
$mechanisms = Import-Csv $mechanismsPath
$candidates = Import-Csv $candidatesPath

$errors = New-Object System.Collections.Generic.List[string]

function Find-DuplicateIds($rows, $field, $label) {
    $dupes = $rows | Where-Object { $_.$field } | Group-Object $field | Where-Object Count -gt 1
    foreach ($d in $dupes) {
        $errors.Add("Duplicate $label id: $($d.Name)")
    }
}

Find-DuplicateIds $inventory "inventory_id" "inventory"
Find-DuplicateIds $mechanisms "mechanism_id" "mechanism"
Find-DuplicateIds $candidates "candidate_id" "candidate"

$inventoryIds = @{}
foreach ($r in $inventory) { if ($r.inventory_id) { $inventoryIds[$r.inventory_id] = $true } }

$mechanismIds = @{}
foreach ($r in $mechanisms) { if ($r.mechanism_id) { $mechanismIds[$r.mechanism_id] = $true } }

foreach ($m in $mechanisms) {
    if ($m.inventory_id -and -not $inventoryIds.ContainsKey($m.inventory_id)) {
        $errors.Add("Orphan mechanism $($m.mechanism_id): inventory_id $($m.inventory_id) not found")
    }
}

foreach ($c in $candidates) {
    if ($c.mechanism_id -and -not $mechanismIds.ContainsKey($c.mechanism_id)) {
        $errors.Add("Orphan candidate $($c.candidate_id): mechanism_id $($c.mechanism_id) not found")
    }
}

$unexamined = @($inventory | Where-Object { $_.terminal_status -eq "UNEXAMINED" }).Count

Write-Host "Inventory entries : $($inventory.Count)"
Write-Host "Mechanisms        : $($mechanisms.Count)"
Write-Host "Candidates        : $($candidates.Count)"
Write-Host "UNEXAMINED        : $unexamined"
Write-Host ""

if ($errors.Count -gt 0) {
    Write-Host "Validation issues:"
    foreach ($e in $errors) {
        Write-Host " - $e"
    }
    exit 2
}

Write-Host "Table integrity checks passed."

if ($unexamined -gt 0) {
    Write-Host "Mission is not complete."
    exit 1
}

Write-Host "UNEXAMINED = 0"
Write-Host "Coverage gate can proceed to final human review."
