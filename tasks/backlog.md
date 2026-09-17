# Backlog

Solo el coordinador edita este archivo. Estados: pendiente, en curso, bloqueado, completado. Completar exige enlazar evidencia.

| ID | Tarea | Estado | Evidencia / aceptación restante |
|---|---|---|---|
| BASE-01 | Instalar y fijar herramientas | Completado | Doctor, formato, lint y ambos builds aprobados: [informe](../reports/2026-09-15-bootstrap.md). |
| BASE-02 | Verificar descubrimiento de equipo y skills | Completado | Ocho roles registrados, cinco skills y dispatch real de diseñador/QA: [informe](../reports/2026-09-15-bootstrap.md). |
| BASE-03 | Verificar aislamiento MCP | Completado con adaptación | Sesiones raíz separadas; coordinador/diseñador sin MCP y QA con MCP. Los overrides por rol fallan en CLI 0.154.0: [procedimiento](../docs/runbooks/agent-isolation.md). |
| BASE-04 | Validar contador y pruebas en Studio | Completado | Binario actual: 7/7 fuentes, unidad/integración, clic real 2→3 y réplica aprobados; Stop/Edit confirmado. Evidencia parcial: snapshot/hashes originales, respuestas transcritas del historial; captura observada sin archivo recuperable. Escena se sigue en BASE-08. [Entrega QA](../reports/2026-09-16-qa-reconnected.md). |
| BASE-05 | Ensayar recuperación de conexión | Completado | Recuperación tras ausencia real de instancias: redescubrimiento, identidad/fuentes, pruebas y Edit. No se provocó desconexión artificial durante Play. Cierre posterior confirma nueva instancia XML en Edit, sin repetir pruebas. [Entrega QA](../reports/2026-09-16-qa-reconnected.md). |
| BASE-06 | Análisis estricto de tipos | Completado | Corregidos errores de tipos; siete scripts aprobados por Luau LSP 1.69.0. [Informe](../reports/2026-09-15-recheck.md). |
| BASE-07 | Ejecutar CI remota | Completado | Commit c9e5868: instalación, check/build y carga de artefactos aprobados en [CI 35174122842](https://github.com/LeonardoAGlez/Roblox-Agency/actions/runs/35174122842). Rama codex/reactor-preparation; sin fusionar main. Correcciones: Wally sin --locked y wally.lock con LF. |
| BASE-08 | Conservar escena al abrir builds | Bloqueado | Corrección local y CI aprobadas. Binario F38B... descubierto en Edit, pero execute_luau de lectura no respondió y se abortó tras 233.7 s. Sin Play ni mutaciones; falta diagnóstico MCP antes de repetir enfoque. [QA](../reports/2026-09-16-scene-qa.md). |
| GAME-01 | Elegir concepto y actualizar plan | Completado | Propietario solicitó implementar la actualización del plan de Defensa del Reactor. [Plan actualizado](../Projects/plan-01-reactor-defense.md) conserva alcance y usa Rojo/Git; no se requiere nueva comparativa de conceptos. |
| GAME-02 | Implementar primera oleada de Defensa del Reactor | Pendiente | [Encargo](reactor-defense-hito-1.md): arena, reactor, robot básico, autoataque, vida/respawn, victoria/derrota y reinicio. No implementado por la actualización documental. |

Última actualización: 2026-09-16 (hora local). BASE-07 cerrada con CI verde c9e5868; BASE-04/05 corresponden al build funcional anterior. BASE-08 requiere diagnosticar la lectura MCP bloqueada y comprobar escena nueva. GAME-02 está definido, sin gameplay implementado. Publicación pública no solicitada; requiere decisión explícita del propietario y aceptación QA.
