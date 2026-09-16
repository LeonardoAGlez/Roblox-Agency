[CmdletBinding()]
param([switch]$Test)
. "$PSScriptRoot/common.ps1"
Push-Location $AgencyRoot
try {
    $outputDirectory = Join-Path $AgencyRoot 'artifacts/builds'
    New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
    $project = 'default.project.json'
    $fileName = 'RobloxAgency.rbxlx'
    if ($Test) { $project = 'test.project.json'; $fileName = 'RobloxAgencyTests.rbxlx' }
    $outputFile = Join-Path $outputDirectory $fileName
    Invoke-AgencyTool -Name rojo -Arguments @('build', $project, '-o', $outputFile)
    Get-FileHash -LiteralPath $outputFile -Algorithm SHA256 | Format-List
} finally { Pop-Location }
