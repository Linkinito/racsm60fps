# DeepSeek External Worker Tools

These scripts let the parent Codex/Sol session invoke external DeepSeek workers
without changing the parent ChatGPT-authenticated Codex session.

## Design

- `invoke-deepseek-worker.ps1` runs one DeepSeek worker.
- `invoke-deepseek-panel.ps1` runs multiple independent roles in parallel.
- Workers are forced into Codex `read-only` sandbox mode with approvals disabled.
- The DeepSeek API key is never stored in the repository.
- If the current process does not inherit `DEEPSEEK_API_KEY`, the worker script
  attempts to load the persistent Windows User/Machine environment variable into
  the child process without printing it.
- Persistent technical reports are written in English.
- The parent Sol agent remains responsible for synthesis and decisions.
- Model agreement is not validation; deterministic evidence and controlled
  gameplay tests remain authoritative.

## Requirements

The user-level Codex profile must exist:

`%USERPROFILE%\.codex\deepseek-flash-high.config.toml`

The DeepSeek provider must be configured in the user-level Codex configuration,
and `DEEPSEEK_API_KEY` must exist as a persistent Windows environment variable.

## Run one worker

Example:

```powershell
.\tools\agents\scripts\invoke-deepseek-worker.ps1 `
    -Role explorer `
    -TaskFile research\tasks\kalidon-acid.md `
    -OutputFile research\inbox\deepseek\kalidon-acid\explorer.md
```

Use `-Force` only when intentionally replacing an existing report.

## Run a parallel panel

Example:

```powershell
.\tools\agents\scripts\invoke-deepseek-panel.ps1 `
    -TaskFile research\tasks\kalidon-acid.md `
    -OutputDirectory research\inbox\deepseek\kalidon-acid
```

By default the panel launches:

- `explorer`
- `mapper`
- `skeptic`

The three roles work independently and write separate reports. The panel also
writes `panel-summary.json`.

You can run a subset:

```powershell
.\tools\agents\scripts\invoke-deepseek-panel.ps1 `
    -TaskFile research\tasks\kalidon-acid.md `
    -Roles explorer,skeptic `
    -OutputDirectory research\inbox\deepseek\kalidon-acid
```

## Recommended parent-agent workflow

1. Sol defines a narrow research question in a task file.
2. Sol launches one worker or the three-role panel.
3. Sol reads the resulting reports.
4. Sol reconciles evidence and disagreements.
5. Astra is used only when a materially difficult ambiguity remains.
6. A deterministic experiment or gameplay comparison decides the technical claim.
