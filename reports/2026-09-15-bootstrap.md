# Entrega de bootstrap — Roblox Agency

Estado histórico. Consultar [la revisión posterior](2026-09-15-recheck.md) para errores de tipos corregidos, hashes actuales y bloqueos vigentes de Studio/CI.

- Responsable: coordinador; implementación delegada a especialistas; revisión independiente final por tech_lead.
- Resultado: ocho perfiles, cinco skills, fuente Rojo, contador autoritativo, pruebas, herramientas fijadas, CI y procedimientos implementados. El concepto comercial permanece pendiente del propietario.
- Entorno: Windows, PowerShell 7, Codex CLI 0.154.0, Rokit 1.2.0, Rojo 7.7.0, Wally 0.3.2, Selene 0.31.0, StyLua 2.5.2.
- Revisión: archivos locales sin commit. Hashes SHA256 de builds:
  - Normal: `1DE10D069D6D597EB6CF433B1D8381C91B9C14F11E90CDEDE241802E5546960E`.
  - Pruebas: `F667DDFC9B53809EA19185ED6529C4DC4B115880ADC043CB9FC975DBF5105118`.

| Comprobación | Resultado | Evidencia |
|---|---|---|
| Instalación/versiones | Aprobada | setup y doctor ejecutados; versiones anteriores |
| Formato, lint, builds y separación de pruebas | Aprobada | check.ps1: 0 errores, 0 warnings, ambos árboles de pruebas excluidos del normal |
| Cinco skills válidas | Aprobada | [Informe de skills](2026-09-15-skills.md) |
| Descubrimiento de ocho roles y cinco skills | Aprobada | inspect-codex.py contra app-server local; smoke persistente cargó roles personalizados |
| Aislamiento por TOML individual | Fallida | game_designer recibió 28 herramientas Roblox pese a enabled=false |
| Coordinador sin MCP y diseñador heredado | Aprobada | artifacts/codex-isolation-result.md: cero herramientas Roblox en ambos |
| QA con MCP | Aprobada | artifacts/codex-smoke-persistent-result.md: qa_studio enumeró el lugar por MCP |
| Revisión independiente de contratos/seguridad | Aprobada | tech_lead, sin hallazgos accionables en código, tests y separación |
| Unidad y clic real del contador inicial | Aprobada | Sesión previa: AgencyTests ALL PASSED; clic real incrementó atributo/UI de 0 a 1 |
| Integración ampliada del build actual | No ejecutada, bloqueada | artifacts/qa-final-assertions.json: seis scripts observados; falta AgencyIntegrationTests.integration |
| Análisis estricto de tipos | No ejecutada | Selene y --!strict no sustituyen un analizador de tipos |
| CI remota y publicación | No ejecutadas | Workflow preparado; no se publicó experiencia |

## Incidentes y cambios de enfoque

- CLI efímera no pudo crear subagentes (`no thread with id`). Sesión persistente sí cargó game_designer y qa_studio.
- En CLI 0.154.0 las opciones MCP de los roles se ignoran. La separación efectiva se implementa en sesiones raíz con `scripts/start-agency.ps1`; ver [diagnóstico y operación](../docs/runbooks/agent-isolation.md). Abrir la carpeta en la app por sí solo no aplica ese aislamiento.
- Una instancia anterior de Studio falló. Se redescubrió el lugar local recuperado y se compararon sus seis fuentes con los archivos antes del playtest inicial; coincidieron. No se sustituyó un Place1 desconocido.
- MCP impidió FireServer e inserción del LocalScript por capacidades del contexto. No se modificaron permisos. La integración se incluyó en el build de pruebas para ejecución normal del cliente.
- Apertura por CLI de Studio falló por comillas en ruta. Rojo mostró conexión y sincronización aceptada sobre el lugar dedicado; la lectura MCP posterior seguía mostrando seis fuentes, y consola agotó 300 segundos. No se inició Play sobre esa discrepancia. Se entregó a QA una sesión MCP nueva para diagnosticar.

## Alcance de la evidencia

Los logs detallados, builds y capturas de artifacts son locales y están excluidos de Git. No se ha probado latencia artificial, multijugador real ni rendimiento en dispositivos móviles. No hay persistencia, compras, analítica real ni assets externos añadidos al juego.

## Entrega QA y bloqueo restante

El operador dedicado pudo descubrir Studio y confirmar Edit. Encontró seis scripts; el test de integración no estaba presente. La lectura Source recibió `MCP tool call requires approval, but approval policy is never`. No inició Play. Después la sesión CLI terminó por límite de uso; no se compraron créditos ni se consumió un reinicio de cuota.

Se conserva `artifacts/qa-final-assertions.json` con el manifiesto de siete fuentes locales y resultados. La sesión no produjo un informe final completo. El lanzador ahora rechaza QA no interactivo: usar la sesión interactiva para tramitar aprobaciones ordinarias. No se ajustaron políticas de seguridad para eludir el rechazo.

Siguiente paso: QA interactivo debe cargar o sincronizar el build de pruebas en el lugar dedicado, comprobar siete fuentes, ejecutar unidad/integración/clic y devolver Edit. BASE-04 permanece bloqueada hasta tener esa evidencia. El trabajo de archivos y su revisión están terminados; la aceptación completa de Studio no lo está.
