# Entrega QA — BASE-04/05

- Tarea y responsable: validación del contador actual; qa_studio, operador exclusivo autorizado por el coordinador.
- Resultado y cambios: QA bloqueado por divergencia del lugar conectado. Solo se añadieron informe y evidencia local; ninguna modificación a Studio, código o configuración. No se inició Play.
- Revisión Git: `0659c8a5b57f3fe06ad35dc740f4a42f931d1ad9`, con cambios locales. Build XML esperado y comprobado: SHA256 `3FC2E33DF60AB8910162EC55A153A7B1D400C2B6B4294DDCD0CE386798628602`. Los hashes de fuentes actuales y conectadas, normalizadas CRLF→LF, están en [comparación](../artifacts/qa-current-comparison.json).
- Entorno: Windows, MCP Roblox Studio; instancia descubierta `61d3430c-ee71-4abd-b317-004d10b59473`, `RobloxAgencyTests_AutoRecovery_1.rbxl`, PlaceId=0 y GameId=0. Versión de Studio no consultada.
- Exclusión: coordinador confirmó check/typecheck aprobados, ausencia de proceso Rojo y escrituras detenidas; concedió frozen para inspección de lectura, sin autorizar Play. Estado Edit confirmado al inicio y al final; exclusión devuelta al coordinador.

| Comprobación | Estado | Evidencia |
|---|---|---|
| Descubrimiento y respuesta MCP | Aprobada | [Instancia y estado inicial](../artifacts/qa-current-discovery.json) |
| Exactamente siete fuentes | Aprobada | [Snapshot de fuentes y escena](../artifacts/qa-current-studio-snapshot.json) |
| Fuentes coinciden con revisión actual | Fallida | Solo 3/7 coinciden: CounterProtocol, main servidor y main cliente. Difieren CounterState, CounterState.spec, runner e integration. [Hashes](../artifacts/qa-current-comparison.json) |
| Escena coincide con test.project.json | Fallida | Baseplate=(1,-0.5,68), esperado (0,-0.5,0); SpawnLocation=(-7,0.5,100), esperado (0,0.5,0); Lighting.Brightness=3.133386, esperado 2. |
| Unidad, inválidos, ráfaga y cooldown actuales | No ejecutada | El requisito de fuentes idénticas impidió iniciar Play. |
| Clic real 2→3 y réplica cliente/servidor | No ejecutada | No se inició Play. |
| Estado final Edit | Aprobada | [Estado final MCP](../artifacts/qa-current-final-state.json) |
| Ensayo completo de desconexión/reconexión | No ejecutada | MCP respondió; no se provocó desconexión y el destino actual diverge. |

- Consola observada vacía: [salida](../artifacts/qa-current-console.json). No contiene resultados de pruebas de esta sesión.
- Captura de Edit: [imagen](../artifacts/qa-current-edit.jpg).
- Diagnóstico: el AutoRecovery conserva versiones anteriores del código de tipado y pruebas; tampoco conserva la escena del build actual. No se puede tratar como validación de la revisión actual ni reemplazarlo silenciosamente.
- Limitaciones: el catálogo MCP disponible no ofrece apertura de archivos locales. El encargo prohíbe vías de shell/UI alternativas. No se tocaron permisos, sincronización, publicación ni contenido recuperado.
- Recursos incorporados y procedencia: solo evidencia propia de consultas MCP de esta sesión.
- Siguiente paso y responsable: abrir en Studio el build local `artifacts/builds/RobloxAgencyTests.rbxlx` conservando el AutoRecovery, y conectar ese lugar al MCP (propietario). QA debe redescubrir la instancia, verificar nuevamente siete fuentes y escena bajo exclusión vigente; solo entonces ejecutar las pruebas, clic real y comprobación final de Edit. BASE-04/05 siguen pendientes.
