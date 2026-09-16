param(
    [ValidateSet('coordinator', 'qa_studio')]
    [string]$Operator = 'coordinator',
    [string]$Prompt,
    [string]$TaskFile,
    [string]$ResultFile
)
$ErrorActionPreference = 'Stop'
if ($Operator -eq 'qa_studio' -and $TaskFile) {
    throw 'QA requiere sesion interactiva para tramitar aprobaciones MCP. Usa -Operator qa_studio -Prompt "Lee tasks/bootstrap-qa.md y ejecuta el encargo".'
}
$projectRoot = Split-Path $PSScriptRoot -Parent
if (-not (Get-Command codex -ErrorAction SilentlyContinue)) { throw 'Codex CLI no disponible.' }
$enabled = if ($Operator -eq 'qa_studio') { 'true' } else { 'false' }
$instructions = if ($Operator -eq 'qa_studio') {
    'Actua como qa_studio. Lee AGENTS.md, .codex/agents/qa_studio.toml y la skill roblox-playtest. No delegues. Antes de modificar Studio exige una entrega del coordinador que identifique build, destino y permiso de exclusividad con escrituras detenidas. Descubre studio_id; termina en Edit y registra evidencia. No publiques.'
} else {
    'Actua como coordinador de Roblox Agency. Lee AGENTS.md y tasks/backlog.md. Roblox MCP esta deshabilitado en esta sesion y sus subagentes. Delega desarrollo a especialistas; entrega playtests al operador separado scripts/start-agency.ps1 -Operator qa_studio. No intentes habilitar ni acceder a Studio por otros medios desde esta sesion. Cuenta al operador QA dentro del maximo de tres especialistas simultaneos.'
}
$codexArgs = @('-C', $projectRoot, '-c', "mcp_servers.Roblox_Studio.enabled=$enabled", '-c', ('developer_instructions=' + (ConvertTo-Json -InputObject $instructions -Compress)))
if ($TaskFile) {
    if ($Prompt) { throw 'Usa Prompt o TaskFile, no ambos.' }
    if (-not $ResultFile) { throw 'TaskFile requiere ResultFile para conservar evidencia.' }
    $taskText = Get-Content -LiteralPath $TaskFile -Raw
    $execArgs = @('exec', '--strict-config', '-s', 'workspace-write') + $codexArgs + @('-o', $ResultFile, '-')
    $taskText | & codex @execArgs
} else {
    if ($ResultFile) { throw 'ResultFile requiere TaskFile.' }
    if ($Prompt) { $codexArgs += $Prompt }
    & codex @codexArgs
}
if ($LASTEXITCODE -ne 0) { throw "Codex termino con codigo $LASTEXITCODE" }
