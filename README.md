# Roblox Agency

Estudio de desarrollo Roblox operado desde Codex: un coordinador, ocho especialistas bajo demanda y una base Luau reproducible con Rojo.

## Empezar

Abre esta carpeta en una sesión nueva de Codex para cargar los agentes y las cinco skills. Para aislamiento técnico de Studio con Codex CLI 0.154.0, inicia coordinación y QA en sesiones separadas:

```powershell
pwsh -NoProfile -File scripts/start-agency.ps1
pwsh -NoProfile -File scripts/start-agency.ps1 -Operator qa_studio
```

El segundo comando se usa al entregar un playtest, con escrituras detenidas. La sesión coordinadora y sus subagentes no reciben Roblox MCP; QA no subdelega. En esta versión, las opciones MCP dentro de los roles se ignoran: abrir solamente la carpeta en la app no garantiza aislamiento. Consulta [el diagnóstico](docs/runbooks/agent-isolation.md).

Puedes pedir:

> Usa agency-delivery. Encarga al diseñador proponer tres conceptos de juego viables, al arquitecto evaluar su dificultad y a economía analizar sus hipótesis. Consolida las opciones antes de elegir conmigo el primer juego.

Para trabajar en una función existente:

> Implementa esta función con roblox-feature. Asigna archivos disjuntos a los especialistas necesarios, pide revisión a tech_lead y pruebas a qa_studio. Conserva la evidencia de lo ejecutado.

El usuario decide concepto, gastos y publicación pública. El equipo implementa, prueba y corrige localmente dentro del encargo autorizado. Los especialistas heredan el modelo y razonamiento de la sesión; se activan como máximo tres a la vez.

## Herramientas y comandos

Windows x64 y PowerShell 7. `setup` descarga Rokit 1.2.0 con SHA256 verificado e instala Rojo 7.7.0, Wally 0.3.2, Selene 0.31.0 y StyLua 2.5.2. Usa el perfil local de Rokit; puede necesitar red y autorización del host. La definición Roblox de Selene se conserva en Git.

```powershell
pwsh -NoProfile -File scripts/setup.ps1
pwsh -NoProfile -File scripts/doctor.ps1
pwsh -NoProfile -File scripts/check.ps1
pwsh -NoProfile -File scripts/build.ps1 -Test
python scripts/inspect-codex.py
```

`inspect-codex.py` requiere Python 3.11 o posterior y consulta el app-server local sin imprimir credenciales. Las verificaciones de archivos y registro no sustituyen la prueba de agentes y Studio.

Para análisis estricto de tipos, preparar Luau LSP según [typecheck](docs/runbooks/typecheck.md) y ejecutar `pwsh -NoProfile -File scripts/typecheck.ps1`. La última revisión de bloqueos está en [el informe de cierre](reports/2026-09-15-recheck.md).

Los builds se generan en `artifacts/builds/RobloxAgency.rbxlx` y `RobloxAgencyTests.rbxlx`. El segundo contiene las pruebas; el primero las excluye. `check` ejecuta formato, lint, ambos builds y comprueba esa separación. No realiza un playtest.

## Equipo

| Rol | Función |
|---|---|
| Coordinador (conversación principal) | Encargos, dependencias, integración y evidencia |
| game_designer | Concepto, investigación, diseño y narrativa |
| tech_lead | Arquitectura y revisión independiente |
| gameplay_engineer | Gameplay y estado autoritativo del servidor |
| ui_engineer | Interfaz, controles y adaptación a pantallas |
| technical_artist | Escena, modelos, efectos, animación y audio |
| qa_studio | Operador exclusivo del MCP Roblox y pruebas |
| economy_analytics | Economía, monetización y medición |
| release_growth | Builds, lanzamiento y actualizaciones |

Las instrucciones por rol están en `.codex/agents`; las skills están en `.agents/skills`. La separación MCP efectiva se aplica al iniciar las sesiones con `start-agency.ps1`. Las opciones MCP declaradas en los roles expresan la intención, pero no la aplican en CLI 0.154.0. Un agente sin MCP no debe intentar acceder a Studio por otros medios.

## Base jugable de validación

El botón solicita `{ action = "increment" }` a `AgencyRemotes.IncrementCounter`. El servidor valida el payload, rechaza argumentos adicionales y acepta como máximo un incremento por jugador cada 0.3 segundos. Replica el atributo `AgencyCounter`; la UI muestra ese valor. El estado se elimina al salir. No usa persistencia, compras ni servicios de analítica.

Rojo administra archivos y escena. Para edición en vivo, usa el plugin Rojo instalado y `rojo serve default.project.json` sobre un lugar local dedicado. Detén la sincronización durante playtests. Exporta cualquier recurso persistente creado en Studio antes de cerrar una entrega.

## Documentación y evidencia

- [Backlog](tasks/backlog.md): estado real de preparación y próximos encargos.
- [Arquitectura](docs/architecture.md): contratos y organización.
- [Preparación](docs/runbooks/setup.md), [desarrollo](docs/runbooks/development.md), [recuperación](docs/runbooks/recovery.md) y [lanzamiento](docs/runbooks/release.md).
- [Fuentes](docs/sources.md): documentación oficial y referencias comunitarias. Los roles son originales; no se importó un framework externo de orquestación.
- [Informes](reports/README.md): evidencia resumida y limitaciones. Capturas y builds locales viven en `artifacts/`, excluido de Git.

El workflow de GitHub Actions está preparado; solo podrá ejecutarse remotamente cuando el repositorio se conecte a GitHub. El concepto del primer juego está pendiente de elección.
