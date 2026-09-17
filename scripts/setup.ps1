[CmdletBinding()]
param()
. "$PSScriptRoot/common.ps1"
Push-Location $AgencyRoot
try {
    $downloadDirectory = Join-Path $AgencyRoot 'artifacts/downloads'
    $bootstrapDirectory = Join-Path $AgencyRoot '.tools/rokit'
    New-Item -ItemType Directory -Force -Path $downloadDirectory,$bootstrapDirectory | Out-Null
    $rokit = Join-Path $bootstrapDirectory 'rokit.exe'
    if (-not (Test-Path -LiteralPath $rokit)) {
        $archive = Join-Path $downloadDirectory 'rokit.zip'
        Invoke-WebRequest -Uri 'https://github.com/rojo-rbx/rokit/releases/download/v1.2.0/rokit-1.2.0-windows-x86_64.zip' -OutFile $archive
        $expected = 'f9ba1704014ff67d51e8005f605955c7c26d2429a5312a9419dc477fc310e96d'
        if ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash -ne $expected) { throw 'Rokit: SHA256 incorrecto.' }
        Expand-Archive -LiteralPath $archive -DestinationPath $bootstrapDirectory -Force
    }
    & $rokit self-install
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo instalar Rokit.' }
    & $rokit trust 'rojo-rbx/rojo' 'UpliftGames/wally' 'Kampfkarren/selene' 'JohnnyMorganz/StyLua'
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo registrar confianza en los cuatro repositorios seleccionados.' }
    & $rokit install
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo instalar el toolchain.' }
    # Wally 0.3.2 no admite --locked; comprobar que install conserva el lock.
    $lockHash = if (Test-Path -LiteralPath 'wally.lock') { (Get-FileHash -LiteralPath 'wally.lock' -Algorithm SHA256).Hash } else { $null }
    Invoke-AgencyTool -Name wally -Arguments @('install')
    if ($lockHash -and ((Get-FileHash -LiteralPath 'wally.lock' -Algorithm SHA256).Hash -ne $lockHash)) {
        throw 'Wally modifico wally.lock. Revisa y confirma la resolucion de dependencias antes de continuar.'
    }
    if (-not (Test-Path -LiteralPath 'roblox.yml')) {
        Invoke-AgencyTool -Name selene -Arguments @('generate-roblox-std')
    }
    Write-Host 'Herramientas listas. Ejecuta scripts/check.ps1 y scripts/build.ps1 -Test.'
} finally { Pop-Location }
