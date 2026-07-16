[CmdletBinding()]
param(
    [string]$Target = $(if ($env:STARSHIP_CONFIG) {
        $env:STARSHIP_CONFIG
    } else {
        Join-Path $HOME '.config\starship.toml'
    })
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$source = Join-Path $PSScriptRoot 'starship.toml'
if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
    throw "Theme file not found: $source"
}

$targetPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Target)
$targetDirectory = Split-Path -Parent $targetPath
New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null

if (Test-Path -LiteralPath $targetPath -PathType Leaf) {
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backup = "$targetPath.backup-$stamp"
    Copy-Item -LiteralPath $targetPath -Destination $backup
    Write-Host "Backed up existing config to $backup"
}

$temporary = Join-Path $targetDirectory ".starship.cosmic-$PID.tmp"
try {
    Copy-Item -LiteralPath $source -Destination $temporary -Force
    Move-Item -LiteralPath $temporary -Destination $targetPath -Force
}
finally {
    Remove-Item -LiteralPath $temporary -Force -ErrorAction SilentlyContinue
}

Write-Host "Installed cosmic-starship to $targetPath"
if (-not (Get-Command starship -ErrorAction SilentlyContinue)) {
    Write-Warning 'Starship is not on PATH. Install it before starting a new shell.'
}
Write-Host 'Use MesloLGS Nerd Font (or another Nerd Font) for every icon.'

