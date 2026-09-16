[CmdletBinding()]
param()
. "$PSScriptRoot/common.ps1"
Push-Location $AgencyRoot
try {
    $failed = $false
    foreach ($name in @('rokit','rojo','wally','selene','stylua')) {
        try { Invoke-AgencyTool -Name $name -Arguments @('--version') }
        catch { Write-Warning $_; $failed = $true }
    }
    foreach ($name in @('git','codex')) {
        $command = Get-Command $name -ErrorAction SilentlyContinue
        if ($command) { & $command.Source --version } else { Write-Warning "Falta $name"; $failed = $true }
    }
    foreach ($file in @('.codex/config.toml','AGENTS.md','default.project.json','test.project.json','wally.lock')) {
        if (-not (Test-Path -LiteralPath $file)) { Write-Warning "Falta $file"; $failed = $true }
    }
    Write-Host 'Studio/MCP: comprobar con list_roblox_studios desde Codex; este script no modifica Studio.'
    if ($failed) { throw 'Diagnostico incompleto: revisa los avisos.' }
} finally { Pop-Location }
