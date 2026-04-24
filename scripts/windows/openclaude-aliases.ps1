Set-StrictMode -Version Latest

$script:OpenClaudeRepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")

function Get-OpenClaudeRepoRoot {
  [CmdletBinding()]
  param()
  return $script:OpenClaudeRepoRoot.Path
}

function Test-OpenClaudeCommand {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [string]$Name
  )

  return [bool](Get-Command -Name $Name -ErrorAction SilentlyContinue)
}

function Assert-OpenClaudeCommand {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [string]$InstallHint
  )

  if (-not (Test-OpenClaudeCommand -Name $Name)) {
    throw "Required command '$Name' was not found. $InstallHint"
  }
}

function Set-OpenClaudeProvider {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("ollama", "openai", "codex", "gemini", "atomic-chat")]
    [string]$Provider,
    [ValidateSet("latency", "balanced", "coding")]
    [string]$Goal = "coding",
    [string]$Model,
    [string]$ApiKey
  )

  Assert-OpenClaudeCommand -Name "bun" -InstallHint "Install Bun from https://bun.sh and open a new terminal."

  Push-Location (Get-OpenClaudeRepoRoot)
  try {
    $args = @("run", "profile:init", "--", "--provider", $Provider)

    if ($Model) {
      $args += @("--model", $Model)
    } elseif ($Provider -eq "ollama") {
      $args += @("--goal", $Goal)
    }

    if ($ApiKey) {
      $args += @("--api-key", $ApiKey)
    }

    & bun @args
    if ($LASTEXITCODE -ne 0) {
      throw "profile:init failed with exit code $LASTEXITCODE."
    }
  }
  finally {
    Pop-Location
  }
}

function Start-OpenClaude {
  [CmdletBinding()]
  param(
    [ValidateSet("profile", "ollama", "openai", "codex", "gemini", "atomic-chat", "fast")]
    [string]$Mode = "profile"
  )

  Assert-OpenClaudeCommand -Name "bun" -InstallHint "Install Bun from https://bun.sh and open a new terminal."

  $scriptName = switch ($Mode) {
    "profile" { "dev:profile" }
    "ollama" { "dev:ollama" }
    "openai" { "dev:openai" }
    "codex" { "dev:codex" }
    "gemini" { "dev:gemini" }
    "atomic-chat" { "dev:atomic-chat" }
    "fast" { "dev:fast" }
  }

  Push-Location (Get-OpenClaudeRepoRoot)
  try {
    & bun run $scriptName
    if ($LASTEXITCODE -ne 0) {
      throw "bun run $scriptName failed with exit code $LASTEXITCODE."
    }
  }
  finally {
    Pop-Location
  }
}

function Test-OpenClaudeOllama {
  [CmdletBinding()]
  param(
    [string]$Model = "llama3.1:8b"
  )

  Assert-OpenClaudeCommand -Name "ollama" -InstallHint "Install Ollama from https://ollama.com/download/windows."

  $version = & ollama --version 2>$null
  $modelNames = (& ollama list 2>$null | Select-Object -Skip 1 | ForEach-Object {
      ($_ -split "\s+")[0]
    }) | Where-Object { $_ }

  $isModelAvailable = $modelNames -contains $Model
  $probeSucceeded = $false

  try {
    $response = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -Method Get -TimeoutSec 3
    if ($response.models) {
      $probeSucceeded = $true
    }
  }
  catch {
    $probeSucceeded = $false
  }

  [PSCustomObject]@{
    OllamaInstalled  = $true
    OllamaVersion    = $version
    OllamaListening  = $probeSucceeded
    Model            = $Model
    ModelAvailable   = $isModelAvailable
  }
}

function Initialize-OpenClaudeRunspace {
  [CmdletBinding()]
  param(
    [ValidateSet("latency", "balanced", "coding")]
    [string]$Goal = "coding",
    [string]$Model = "llama3.1:8b",
    [switch]$SkipModelPull
  )

  Assert-OpenClaudeCommand -Name "npm" -InstallHint "Install Node.js 20+ from https://nodejs.org."
  Assert-OpenClaudeCommand -Name "bun" -InstallHint "Install Bun from https://bun.sh and open a new terminal."
  Assert-OpenClaudeCommand -Name "ollama" -InstallHint "Install Ollama from https://ollama.com/download/windows."

  Push-Location (Get-OpenClaudeRepoRoot)
  try {
    if (-not $SkipModelPull) {
      & ollama pull $Model
      if ($LASTEXITCODE -ne 0) {
        throw "ollama pull $Model failed with exit code $LASTEXITCODE."
      }
    }

    Set-OpenClaudeProvider -Provider "ollama" -Goal $Goal -Model $Model

    $health = Test-OpenClaudeOllama -Model $Model
    if (-not $health.OllamaListening) {
      Write-Warning "Ollama is installed but API probe to localhost:11434 did not succeed. Start Ollama and retry."
    }
  }
  finally {
    Pop-Location
  }

  Start-OpenClaude -Mode "profile"
}

function Get-OpenClaudeQuickHelp {
  [CmdletBinding()]
  param()

  @(
    "OpenClaude quick commands:",
    "  oc-init                  -> bootstrap local Ollama profile and launch",
    "  oc                        -> launch using saved provider profile",
    "  oc-local                  -> force local Ollama launch path",
    "  oc-fast                   -> low latency local preset",
    "  oc-provider <name>        -> switch provider profile (ollama/openai/codex/gemini/atomic-chat)",
    "  oc-check                  -> show Ollama install/listening/model state"
  ) -join [Environment]::NewLine
}

function oc {
  [CmdletBinding()]
  param(
    [ValidateSet("profile", "ollama", "openai", "codex", "gemini", "atomic-chat", "fast")]
    [string]$Mode = "profile"
  )

  Start-OpenClaude -Mode $Mode
}

function oc-local {
  [CmdletBinding()]
  param()
  Start-OpenClaude -Mode "ollama"
}

function oc-fast {
  [CmdletBinding()]
  param()
  Start-OpenClaude -Mode "fast"
}

function oc-provider {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("ollama", "openai", "codex", "gemini", "atomic-chat")]
    [string]$Provider,
    [ValidateSet("latency", "balanced", "coding")]
    [string]$Goal = "coding",
    [string]$Model,
    [string]$ApiKey
  )

  Set-OpenClaudeProvider -Provider $Provider -Goal $Goal -Model $Model -ApiKey $ApiKey
}

function oc-check {
  [CmdletBinding()]
  param(
    [string]$Model = "llama3.1:8b"
  )
  Test-OpenClaudeOllama -Model $Model
}

function oc-init {
  [CmdletBinding()]
  param(
    [ValidateSet("latency", "balanced", "coding")]
    [string]$Goal = "coding",
    [string]$Model = "llama3.1:8b",
    [switch]$SkipModelPull
  )

  Initialize-OpenClaudeRunspace -Goal $Goal -Model $Model -SkipModelPull:$SkipModelPull
}

function oc-help {
  [CmdletBinding()]
  param()
  Get-OpenClaudeQuickHelp
}
