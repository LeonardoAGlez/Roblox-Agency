# Fuentes y atribuciones

Fecha de consulta inicial: 2026-09-15. Revalidar APIs y políticas al utilizarlas. Las cifras de estrellas del plan previo eran aproximadas y no son una garantía de calidad ni un requisito técnico; esta base no las usa como evidencia de compatibilidad.

## Documentación primaria

| Fuente | Aplicación |
|---|---|
| [Roblox: agentes de código](https://create.roblox.com/docs/ai/coding-harness) | Flujo documentado de archivos, agentes y Studio; su ejemplo usa Script Sync, mientras este proyecto elige Rojo. |
| [Roblox: sincronización](https://create.roblox.com/docs/scripting/sync) | Comparación de sincronizadores. |
| [Roblox: MCP](https://create.roblox.com/docs/studio/mcp) | Capacidades y selección explícita de instancia de Studio. |
| [Roblox: cliente y servidor](https://create.roblox.com/docs/scripting/security/client-server-boundary) | Validación del lado servidor. |
| [Codex: agentes](https://developers.openai.com/codex/multi-agent/) | Configuración y ejecución de especialistas. |
| [Codex: AGENTS.md](https://developers.openai.com/codex/guides/agents-md/) | Instrucciones del repositorio. |
| [Codex: skills](https://developers.openai.com/codex/skills/) | Descubrimiento y formato de procedimientos reutilizables. |

## Repositorios seleccionados

| Repositorio | Uso |
|---|---|
| [Agency Agents](https://github.com/msitarzewski/agency-agents) | Inspiración para dividir responsabilidades. No se copiaron prompts, código ni recursos. |
| [Rojo](https://github.com/rojo-rbx/rojo) | Sincronización y build. |
| [Rokit](https://github.com/rojo-rbx/rokit) | Instalación de herramientas fijadas. |
| [Wally](https://github.com/UpliftGames/wally) | Gestión de paquetes. |
| [Selene](https://github.com/Kampfkarren/selene) | Análisis estático. |
| [StyLua](https://github.com/JohnnyMorganz/StyLua) | Formato Luau. |

Las versiones exactas de las herramientas pertenecen a `rokit.toml`; las dependencias resueltas pertenecen a `wally.lock`. No se distribuye código de esos repositorios dentro de las instrucciones del equipo. Para futuras adaptaciones o recursos, registrar URL, autor, revisión o ID, licencia, fecha y restricciones antes de integrarlos; conservar las atribuciones exigidas.
