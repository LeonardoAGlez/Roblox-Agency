# Aislamiento de Studio

## Diagnóstico verificado en CLI 0.154.0

El smoke de roles personalizados cargó `game_designer` y `qa_studio`, pero ambos recibieron 28 herramientas Roblox. `enabled=false` en el TOML del diseñador no las retiró. Evidencia local: `artifacts/codex-smoke-persistent-result.md` y sus eventos JSONL.

El código oficial de esta versión omite `mcp_servers` de los campos aplicados por `AgentRoleOverrides`: [role.rs](https://github.com/openai/codex/blob/rust-v0.154.0/codex-rs/core/src/agent/role.rs#L33). No basta con revisar los TOML. La prueba efímera previa también falló al crear subagentes (`no thread with id`); usar sesiones persistentes para este smoke.

## Operación compatible

1. Iniciar `pwsh -NoProfile -File scripts/start-agency.ps1`. Aplica `mcp_servers.Roblox_Studio.enabled=false` a la sesión raíz. El smoke confirmó cero herramientas Roblox tanto en raíz como en un `game_designer` real.
2. Desarrollar con especialistas. No asignar Studio al subagente QA de esta sesión: hereda el MCP deshabilitado.
3. Entregar a una sesión dedicada: `pwsh -NoProfile -File scripts/start-agency.ps1 -Operator qa_studio`. Este operador recibe MCP habilitado e instrucciones QA, sin delegación. No cambia el modelo, credenciales ni configuración global.
4. Entregar ruta/hash del build, lugar dedicado, pruebas y autorización de exclusividad. Detener escrituras y Rojo antes de Play. Contar QA dentro del máximo de tres especialistas activos.
5. QA descubre instancia, verifica destino, ejecuta pruebas, guarda evidencia y devuelve Edit. El coordinador integra el informe antes de reanudar cambios.

La separación es de herramientas MCP, no un sandbox independiente para shell. Las instrucciones prohíben vías alternativas. El permiso de publicación pública continúa perteneciendo al usuario.

QA debe ser interactivo: `codex exec` rechazó `execute_luau` con `MCP tool call requires approval, but approval policy is never`. El lanzador impide combinar QA con TaskFile para no repetir esa ejecución inoperante. No deshabilitar aprobaciones ni cambiar políticas para eludir el rechazo. Una sesión QA separada sí pudo enumerar Studio y consultar Edit; no se ha validado todavía el playtest completo con el lanzador interactivo.

Al actualizar Codex, repetir el smoke antes de cambiar a aislamiento por rol. `inspect-codex.py` verifica descubrimiento/configuración declarada; no prueba permisos efectivos.
