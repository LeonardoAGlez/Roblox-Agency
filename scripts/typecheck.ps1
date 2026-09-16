[CmdletBinding()]
param()
. "$PSScriptRoot/common.ps1"
Push-Location $AgencyRoot
try {
    $analyzer = Join-Path $AgencyRoot '.tools/luau-lsp/luau-lsp.exe'
    $definitions = Join-Path $AgencyRoot '.tools/luau-lsp/globalTypes.d.luau'
    if (-not (Test-Path $analyzer) -or -not (Test-Path $definitions)) {
        throw 'Falta Luau LSP y sus definiciones. Consulta docs/runbooks/typecheck.md.'
    }
    New-Item -ItemType Directory -Force artifacts | Out-Null
    Invoke-AgencyTool -Name rojo -Arguments @('sourcemap', 'test.project.json', '--output', 'artifacts/typecheck-sourcemap.json')
    & $analyzer analyze --platform=roblox --sourcemap=artifacts/typecheck-sourcemap.json "--definitions=@roblox=$definitions" game 2>&1 | Tee-Object artifacts/typecheck.log
    if ($LASTEXITCODE -ne 0) { throw "Analisis de tipos fallo con codigo $LASTEXITCODE" }
    Write-Host 'PASS: analisis de tipos de fuentes y pruebas con DataModel Rojo.'
} finally { Pop-Location }
