# Entrega QA — contador y recuperación de conexión

- Tarea y responsable: BASE-04/05, qa_studio, operador exclusivo con congelación de escrituras confirmada por el coordinador.
- Resultado: pruebas funcionales ejecutadas y aprobadas en `RobloxAgencyTests.rbxl`; Stop y Edit observados. Recuperación tras ausencia real de instancias demostrada mediante nuevo descubrimiento, identidad, siete fuentes y repetición de pruebas. No se provocó una desconexión artificial.
- Cambios: solo evidencia e informe. No se editaron fuentes, escena, permisos o configuración. La reapertura de cierre fue solo lectura; no se repitió Play.
- Revisión/manifiesto probado: XML SHA256 `3FC2E33DF60AB8910162EC55A153A7B1D400C2B6B4294DDCD0CE386798628602`; binario SHA256 `9FCE425BC2E33D8BCAF29AD32F53C0BFC6DF7CEDFF12B28B82A5E89F6BAE0325`. Ambos hashes locales comprobados antes de Play; no había proceso Rojo. [Siete hashes de fuentes](../artifacts/qa-reconnected-comparison.json), normalización CRLF→LF.
- Entorno probado: Studio `0.739.0.7390687`, Windows, instancia `ef7ec0ca-b22e-4b91-840e-30ab8916958c`, lugar binario dedicado, PlaceId/GameId=0. [Snapshot original persistido](../artifacts/qa-reconnected-snapshot.json).

| Comprobación | Estado | Evidencia y alcance |
|---|---|---|
| Siete fuentes actuales idénticas | Aprobada | Comparación automática 7/7 persistida antes del playtest |
| Unidad CounterState.spec | Aprobada | `AgencyTests ALL PASSED (1 spec)` observado en respuesta MCP |
| Payloads inválidos y argumentos adicionales | Aprobada | Integración preservó cero |
| Ráfaga y cooldown | Aprobada | 20 solicitudes aceptadas una vez; posterior aceptada y UI=2 |
| Cliente/UI antes del clic | Aprobada | Assertion devolvió count=2 y text="2" |
| Clic real | Aprobada | user_mouse_input sobre IncrementButton devolvió Success |
| Réplica tras clic | Aprobada | Assertions cliente/UI=3 y servidor=3, mismo UserId 10320910654 |
| Stop y regreso a Edit | Aprobada | Respuestas `Game Stopped` y estado Edit observadas en instancia probada |
| Recuperación de conexión real | Aprobada en este alcance | Ausencia previa documentada en qa-final-discovery.json; nueva instancia, identidad y fuentes verificadas; pruebas ejecutadas y Edit restaurado |
| Desconexión provocada durante Play | No ejecutada | No necesaria para la recuperación real observada; no se afirma ensayo artificial |
| Escena reproducible respecto al proyecto | Fallida | Ambas partes en (0,0,0), esperadas y=-0.5/+0.5; Brightness=3.133386, esperado 2 |
| Estado actual al cierre posterior | Aprobada | Nuevo lugar XML en Edit, evidencia raw enlazada abajo; no es repetición de validación funcional de ese XML |

## Procedencia y limitaciones de evidencia

El snapshot de fuentes/escena y comparación de hashes se guardaron directamente durante la sesión. La consola, assertions y Stop/Edit fueron respuestas ejecutadas visibles en el historial, pero sus objetos originales en `functions.store` se perdieron al reiniciarse el entorno. Se conserva una [transcripción explícitamente identificada](../artifacts/qa-reconnected-observed-history.json); no se presenta como raw original.

La captura del contador 3 fue recibida y mostrada en la conversación, pero no se persistieron sus bytes antes del reinicio. No se inventó ni recreó una imagen. La consulta opcional final de atributos Lighting quedó pendiente y su resultado no es recuperable; no se repitió. La consola consultada durante Play contenía únicamente los seis mensajes de aprobación transcritos; no se dispone de una segunda captura raw de consola final.

El coordinador autorizó expresamente la prueba funcional pese a la discrepancia de escena, porque no afecta al protocolo ni a las pruebas del contador. Esta aprobación no certifica fidelidad de escena. Su diagnóstico/corrección pertenece a una tarea separada; QA no modificó Studio para ocultarla.

## Verificación posterior y entrega de exclusión

Al retomar el cierre se redescubrió otra instancia: `576afe8f-6945-436e-b752-e150a70a93fe`, `RobloxAgencyTests.rbxlx`. [Respuesta raw de descubrimiento](../artifacts/qa-reconnected-closure-discovery.json) y [estado raw Edit](../artifacts/qa-reconnected-closure-state.json). No se reutilizó el ID previo ni se inició Play. Este lugar XML no recibió una nueva comparación de fuentes ni pruebas funcionales en la fase de cierre.

- Recursos incorporados: evidencia propia de MCP y archivos locales; sin assets externos.
- Siguiente paso: coordinador integra resultados BASE-04/05 con el alcance indicado y seguimiento separado de escena. Si se cambia configuración de escena/build, verificar el nuevo lugar y ejecutar las comprobaciones afectadas bajo nueva exclusión.
- Exclusión devuelta al coordinador; estado actual confirmado Edit.
