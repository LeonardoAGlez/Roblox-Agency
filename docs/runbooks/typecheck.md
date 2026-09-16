# Análisis estricto de tipos

`scripts/typecheck.ps1` analiza todos los scripts de `game`, incluidas pruebas, con el DataModel de Rojo. No sustituye playtests. Usa Luau LSP 1.69.0, publicado por su mantenedor, y definiciones Roblox de seguridad None.

Preparación local en PowerShell 7 (requiere red):

```powershell
New-Item -ItemType Directory -Force .tools/luau-lsp | Out-Null
Invoke-WebRequest 'https://github.com/JohnnyMorganz/luau-lsp/releases/download/1.69.0/luau-lsp-win64.zip' -OutFile .tools/luau-lsp/package.zip
if ((Get-FileHash .tools/luau-lsp/package.zip -Algorithm SHA256).Hash -ne 'FAEA1B177F4761E4C34E0DAB72009A2FDD00F21D61F3F7B7C1FE1AC3F38A05D2') { throw 'Checksum incorrecto' }
Expand-Archive .tools/luau-lsp/package.zip .tools/luau-lsp -Force
Invoke-WebRequest 'https://luau-lsp.pages.dev/type-definitions/globalTypes.None.d.luau' -OutFile .tools/luau-lsp/globalTypes.d.luau
Get-FileHash .tools/luau-lsp/globalTypes.d.luau -Algorithm SHA256
pwsh -NoProfile -File scripts/typecheck.ps1
```

El archivo de definiciones servido por el mantenedor evoluciona. El usado en la revisión de 2026-09-15 tiene SHA256 `A39C75FFB7FE1747D9AF96327C0A57FF8FA9B6F26B14BDA954262AE17B154707`; conservarlo en `.tools` para repetir exactamente esta ejecución. Una descarga con hash diferente requiere registrar la nueva versión de definiciones y repetir la revisión; no implica por sí misma un fallo de seguridad.

Evidencia: `artifacts/typecheck.log` y `artifacts/typecheck-sourcemap.json`. El aviso de watcher deshabilitado es esperado en análisis puntual: se genera el mapa antes de cada ejecución.

Fuentes: [README del mantenedor](https://github.com/JohnnyMorganz/luau-lsp), [release 1.69.0](https://github.com/JohnnyMorganz/luau-lsp/releases/tag/1.69.0), [configuración de definiciones](https://github.com/JohnnyMorganz/luau-lsp/blob/main/editors/README.md). Binario y definiciones son herramientas locales; no se incorporan al juego.
