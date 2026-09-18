[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("explorer", "mapper", "skeptic")]
    [string]$Role,

    [Parameter(Mandatory = $true)]
    [string]$TaskFile,

    [Parameter(Mandatory = $true)]
    [string]$OutputFile,

    [string]$Profile = "deepseek-flash-high",

    [string]$CodexHome,

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

function Resolve-CodexHome {
    param(
        [string]$ExplicitPath,
        [Parameter(Mandatory = $true)]
        [string]$ProfileName
    )

    $Candidates = [System.Collections.Generic.List[string]]::new()

    if (-not [string]::IsNullOrWhiteSpace($ExplicitPath)) {
        $Candidates.Add($ExplicitPath)
    }

    if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        $Candidates.Add($env:CODEX_HOME)
    }

    # When launched from the Codex desktop sandbox, HOME/USERPROFILE may be
    # unavailable or refer to CodexSandboxOffline. The installed codex.exe path
    # still normally lives under the real Windows user's AppData tree, so use it
    # as a machine-local discovery source.
    try {
        $CodexCommand = Get-Command codex -ErrorAction Stop
        $CodexSource = [System.IO.Path]::GetFullPath($CodexCommand.Source)

        if ($CodexSource -match '^(?<profile>[A-Za-z]:\\Users\\[^\\]+)\\AppData\\Local\\') {
            $Candidates.Add((Join-Path $Matches.profile ".codex"))
        }
    }
    catch {
        # The caller performs the definitive codex command check later.
    }

    foreach ($Base in @($env:USERPROFILE, $HOME)) {
        if (-not [string]::IsNullOrWhiteSpace($Base)) {
            $Candidates.Add((Join-Path $Base ".codex"))
        }
    }

    foreach ($Candidate in ($Candidates | Select-Object -Unique)) {
        try {
            $FullCandidate = [System.IO.Path]::GetFullPath($Candidate)
        }
        catch {
            continue
        }

        $ProfilePath = Join-Path $FullCandidate "$ProfileName.config.toml"

        if ((Test-Path -LiteralPath $FullCandidate -PathType Container) -and
            (Test-Path -LiteralPath $ProfilePath -PathType Leaf)) {
            return $FullCandidate
        }
    }

    throw "Could not resolve CODEX_HOME containing '$ProfileName.config.toml'. Pass -CodexHome explicitly or set CODEX_HOME."
}

# tools/agents/scripts -> repository root
$RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\..\.."))
$RolePromptPath = Join-Path $RepoRoot "tools\agents\prompts\$Role.md"
$TaskPath = Resolve-RepoPath -PathValue $TaskFile -RepoRoot $RepoRoot
$OutputPath = Resolve-RepoPath -PathValue $OutputFile -RepoRoot $RepoRoot

if (-not (Test-Path -LiteralPath (Join-Path $RepoRoot "AGENTS.md") -PathType Leaf)) {
    throw "Repository root check failed: AGENTS.md was not found at '$RepoRoot'."
}

if (-not (Test-Path -LiteralPath $RolePromptPath -PathType Leaf)) {
    throw "Role prompt not found: $RolePromptPath"
}

if (-not (Test-Path -LiteralPath $TaskPath -PathType Leaf)) {
    throw "Task file not found: $TaskPath"
}

if ((Test-Path -LiteralPath $OutputPath -PathType Leaf) -and -not $Force) {
    throw "Output already exists: $OutputPath. Use -Force to overwrite it."
}

$OutputDirectory = Split-Path -Parent $OutputPath
if (-not (Test-Path -LiteralPath $OutputDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

$CodexCommand = Get-Command codex -ErrorAction Stop
$ResolvedCodexHome = Resolve-CodexHome -ExplicitPath $CodexHome -ProfileName $Profile

# Set this before starting codex.exe. Child processes inherit it even when this
# worker was itself launched from the Codex desktop sandbox account.
$env:CODEX_HOME = $ResolvedCodexHome

$ProfilePath = Join-Path $ResolvedCodexHome "$Profile.config.toml"

# Codex GUI processes may not inherit a newly-created Windows environment
# variable. If the current process does not have the DeepSeek key, hydrate it
# from the persistent Windows environment without printing the secret.
if ([string]::IsNullOrWhiteSpace($env:DEEPSEEK_API_KEY)) {
    $PersistentKey = [Environment]::GetEnvironmentVariable("DEEPSEEK_API_KEY", "User")

    if ([string]::IsNullOrWhiteSpace($PersistentKey)) {
        $PersistentKey = [Environment]::GetEnvironmentVariable("DEEPSEEK_API_KEY", "Machine")
    }

    if (-not [string]::IsNullOrWhiteSpace($PersistentKey)) {
        $env:DEEPSEEK_API_KEY = $PersistentKey
    }
}

if ([string]::IsNullOrWhiteSpace($env:DEEPSEEK_API_KEY)) {
    throw "DEEPSEEK_API_KEY is unavailable to this process and was not found in the persistent Windows User/Machine environment."
}

$RoleInstructions = Get-Content -LiteralPath $RolePromptPath -Raw
$TaskContents = Get-Content -LiteralPath $TaskPath -Raw

$InstructionPrompt = @"
You are an external DeepSeek research worker for the Overcompensated V2 project.

Before investigating, read and obey:
- AGENTS.md
- PROJECT_GOALS.md
- MIGRATION.md
- docs/methodology/EVIDENCE_LEVELS.md

Project priority:
The primary objective is faithful behavioral parity between the original
30 FPS game and the corrected 60 FPS game. Optional user-facing features
are out of scope unless the project owner explicitly says otherwise.

Your assigned role is:

$RoleInstructions

The task specification is provided on standard input.

Rules:
- Treat the repository as read-only.
- Do not modify project files.
- Do not create or apply patches.
- Do not run destructive commands.
- Distinguish observations from inferences.
- Do not treat model agreement as evidence.
- Do not promote historical claims to TESTED without supporting evidence.
- Use UNKNOWN when evidence is absent instead of estimating.
- Prefer primary evidence over summaries when available.
- Persistent technical output must be written in English.
- Return a self-contained technical report suitable for review by the parent Sol agent.
"@

Push-Location $RepoRoot

try {
    Write-Host "Starting DeepSeek worker '$Role' with profile '$Profile'..."
    Write-Host "CODEX_HOME: $ResolvedCodexHome"
    Write-Host "Task:   $TaskPath"
    Write-Host "Output: $OutputPath"

    $TaskContents | & $CodexCommand.Source exec `
        --profile $Profile `
        --ephemeral `
        --sandbox read-only `
        --config 'approval_policy="never"' `
        --output-last-message $OutputPath `
        $InstructionPrompt

    $ExitCode = $LASTEXITCODE
}
finally {
    Pop-Location
}

if ($ExitCode -ne 0) {
    throw "DeepSeek worker '$Role' failed with exit code $ExitCode."
}

if (-not (Test-Path -LiteralPath $OutputPath -PathType Leaf)) {
    throw "DeepSeek worker '$Role' completed without creating the expected report: $OutputPath"
}

$OutputInfo = Get-Item -LiteralPath $OutputPath
if ($OutputInfo.Length -eq 0) {
    throw "DeepSeek worker '$Role' created an empty report: $OutputPath"
}

Write-Host "DeepSeek worker '$Role' completed successfully."
Write-Host "Report: $OutputPath"
