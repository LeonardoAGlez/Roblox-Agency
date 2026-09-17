[CmdletBinding()]
param()
. "$PSScriptRoot/common.ps1"
Push-Location $AgencyRoot
try {
    function ConvertTo-CanonicalJson($Value) {
        if ($Value -is [System.Collections.IDictionary]) {
            $entries = foreach ($key in ($Value.Keys | Sort-Object)) {
                (ConvertTo-Json -InputObject ([string]$key) -Compress) + ':' + (ConvertTo-CanonicalJson $Value[$key])
            }
            return '{' + ($entries -join ',') + '}'
        }
        if ($Value -is [array]) {
            $entries = foreach ($element in $Value) { ConvertTo-CanonicalJson $element }
            return '[' + ($entries -join ',') + ']'
        }
        return ConvertTo-Json -InputObject $Value -Compress
    }
    $baseProject = Get-Content default.project.json -Raw | ConvertFrom-Json -AsHashtable
    $testProject = Get-Content test.project.json -Raw | ConvertFrom-Json -AsHashtable
    $testProject.tree.ServerScriptService.Remove('AgencyTests') | Out-Null
    $testProject.tree.StarterPlayer.StarterPlayerScripts.Remove('AgencyIntegrationTests') | Out-Null
    if ((ConvertTo-CanonicalJson $baseProject.tree) -cne (ConvertTo-CanonicalJson $testProject.tree)) {
        throw 'El proyecto de pruebas debe coincidir con la base salvo las dos ramas de pruebas.'
    }
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
        # Evitar que Studio interprete Technology omitido como Compatibility y migre el brillo.
        $technology = $document.SelectSingleNode('/roblox/Item[@class="Lighting"]/Properties/token[@name="Technology"]')
        $brightness = $document.SelectSingleNode('/roblox/Item[@class="Lighting"]/Properties/float[@name="Brightness"]')
        if (-not $technology -or $technology.InnerText -ne '3') {
            throw 'Lighting debe serializar Technology=ShadowMap (3) explicitamente.'
        }
        if (-not $brightness -or [double]::Parse($brightness.InnerText, [Globalization.CultureInfo]::InvariantCulture) -ne 2) {
            throw 'Lighting debe conservar Brightness=2 en el build.'
        }
        # Position no se carga desde archivos de lugar: verificar CFrame persistido.
        foreach ($partName in @('Baseplate', 'SpawnLocation')) {
            $part = $document.SelectSingleNode('/roblox/Item[@class="Workspace"]/Item[Properties/string[@name="Name" and text()="' + $partName + '"]]')
            if (-not $part) { throw "Falta $partName en Workspace." }
            if ($part.SelectSingleNode('Properties/Vector3[@name="Position"]')) {
                throw "$partName usa Position no persistible; usa CFrame."
            }
            $frame = $part.SelectSingleNode('Properties/CoordinateFrame[@name="CFrame"]')
            if (-not $frame) { throw "Falta CFrame serializado de $partName." }
            $expected = $baseProject.tree.Workspace[$partName]['$properties'].CFrame
            $components = @('X', 'Y', 'Z', 'R00', 'R01', 'R02', 'R10', 'R11', 'R12', 'R20', 'R21', 'R22')
            for ($index = 0; $index -lt $components.Count; $index++) {
                $node = $frame.SelectSingleNode($components[$index])
                if (-not $node) { throw "CFrame incompleto de $partName." }
                $value = [double]::Parse($node.InnerText, [Globalization.CultureInfo]::InvariantCulture)
                if ([Math]::Abs($value - [double]$expected[$index]) -gt 0.00001) {
                    throw "CFrame incorrecto de $partName en $($components[$index])."
                }
            }
        }
        foreach ($service in @('Lighting', 'ReplicatedStorage', 'ServerScriptService', 'StarterPlayer', 'Workspace')) {
            $instances = @($document.roblox.Item | Where-Object { $_.class -eq $service })
            if ($instances.Count -ne 1) { throw "Se esperaba un unico servicio $service; encontrados $($instances.Count)." }
        }
        $playerScripts = $document.SelectNodes('/roblox/Item[@class="StarterPlayer"]/Item[@class="StarterPlayerScripts"]')
        if ($playerScripts.Count -ne 1) { throw 'StarterPlayer debe contener un unico StarterPlayerScripts.' }
        foreach ($name in @('AgencyServer', 'AgencyClient', 'AgencyShared')) {
            if (-not $document.SelectSingleNode('//Item/Properties/string[@name="Name" and text()="' + $name + '"]')) {
                throw "Falta $name en el build."
            }
        }
    }
    if (-not $test.SelectSingleNode('/roblox/Item[@class="ServerScriptService"]/Item/Properties/string[@name="Name" and text()="AgencyTests"]')) {
        throw 'AgencyTests debe estar dentro del unico ServerScriptService.'
    }
    if (-not $test.SelectSingleNode('/roblox/Item[@class="StarterPlayer"]/Item[@class="StarterPlayerScripts"]/Item/Properties/string[@name="Name" and text()="AgencyIntegrationTests"]')) {
        throw 'AgencyIntegrationTests debe estar dentro del unico StarterPlayerScripts.'
    }
    Write-Host 'PASS: formato, lint, builds y separacion de pruebas. Playtest se ejecuta por separado en Studio.'
} finally { Pop-Location }
