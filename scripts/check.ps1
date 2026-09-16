[CmdletBinding()]
param()
. "$PSScriptRoot/common.ps1"
Push-Location $AgencyRoot
try {
    Invoke-AgencyTool -Name stylua -Arguments @('--check', 'game')
    Invoke-AgencyTool -Name selene -Arguments @('game')
    & "$PSScriptRoot/build.ps1"
    & "$PSScriptRoot/build.ps1" -Test
    $buildPath = Join-Path $AgencyRoot 'artifacts/builds'
    [xml]$normal = Get-Content -Raw -LiteralPath (Join-Path $buildPath 'RobloxAgency.rbxlx')
    [xml]$test = Get-Content -Raw -LiteralPath (Join-Path $buildPath 'RobloxAgencyTests.rbxlx')
    foreach ($folder in @('AgencyTests', 'AgencyIntegrationTests')) {
        $testFolder = '//Item/Properties/string[@name="Name" and text()="' + $folder + '"]'
        if ($normal.SelectSingleNode($testFolder)) { throw "El build normal contiene $folder." }
        if (-not $test.SelectSingleNode($testFolder)) { throw "El build de pruebas no contiene $folder." }
    }
    foreach ($document in @($normal, $test)) {
        foreach ($name in @('AgencyServer', 'AgencyClient', 'AgencyShared')) {
            if (-not $document.SelectSingleNode('//Item/Properties/string[@name="Name" and text()="' + $name + '"]')) {
                throw "Falta $name en el build."
            }
        }
    }
    Write-Host 'PASS: formato, lint, builds y separacion de pruebas. Playtest se ejecuta por separado en Studio.'
} finally { Pop-Location }
