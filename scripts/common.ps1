Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$AgencyRoot = Split-Path -Parent $PSScriptRoot

function Invoke-AgencyTool {
    param([Parameter(Mandatory)][string]$Name, [string[]]$Arguments = @())
    $candidate = Join-Path $env:USERPROFILE ('.rokit/bin/' + $Name + '.exe')
    if (-not (Test-Path -LiteralPath $candidate)) {
        $command = Get-Command $Name -ErrorAction SilentlyContinue
        if (-not $command) { throw "Falta $Name. Ejecuta scripts/setup.ps1." }
        $candidate = $command.Source
    }
    & $candidate @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Name fallo con codigo $LASTEXITCODE." }
}
