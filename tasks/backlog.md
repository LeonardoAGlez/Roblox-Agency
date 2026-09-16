# Backlog

Solo el coordinador edita este archivo. Estados: pendiente, en curso, bloqueado, completado. Completar exige enlazar evidencia.

| ID | Tarea | Estado | Evidencia / aceptación restante |
|---|---|---|---|
| BASE-01 | Instalar y fijar herramientas | Completado | Doctor, formato, lint y ambos builds aprobados: [informe](../reports/2026-09-15-bootstrap.md). |
| BASE-02 | Verificar descubrimiento de equipo y skills | Completado | Ocho roles registrados, cinco skills y dispatch real de diseñador/QA: [informe](../reports/2026-09-15-bootstrap.md). |
| BASE-03 | Verificar aislamiento MCP | Completado con adaptación | Sesiones raíz separadas; coordinador/diseñador sin MCP y QA con MCP. Los overrides por rol fallan en CLI 0.154.0: [procedimiento](../docs/runbooks/agent-isolation.md). |
| BASE-04 | Validar contador y pruebas en Studio | Bloqueado | Nueva revisión: solo test01.rbxl descubierto; estado MCP sin respuesta. No se identifica el lugar de pruebas ni se ejecuta Play. [Informe actual](../reports/2026-09-15-recheck.md). |
| BASE-05 | Ensayar recuperación de conexión | Bloqueado | Descubrimiento funciona, pero consulta de estado no; recuperación completa sin demostrar. [QA](../reports/qa-recheck.md). |
| BASE-06 | Análisis estricto de tipos | Completado | Corregidos errores de tipos; siete scripts aprobados por Luau LSP 1.69.0. [Informe](../reports/2026-09-15-recheck.md). |
| BASE-07 | Ejecutar CI remota | Bloqueado | git remote -v no devuelve remotos. Requiere repositorio GitHub destino; validación local aprobada. |
| GAME-01 | Proponer y elegir concepto | Pendiente | Comparativa de conceptos y elección explícita del propietario. |

Última actualización: 2026-09-15 (hora local). No dar BASE-04/05 por completadas por el solo éxito de compilación. Siguiente encargo: [bootstrap QA](bootstrap-qa.md), mediante el lanzador interactivo y con comprobación previa del destino y hash. Publicación pública no solicitada; requiere decisión explícita del propietario y aceptación QA.
