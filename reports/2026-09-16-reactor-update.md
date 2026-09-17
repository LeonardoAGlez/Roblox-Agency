# Entrega — actualización de Reactor Defense

- Tarea y responsable: GAME-01 / BASE-07 / BASE-08, coordinador. Revisión independiente tech_lead y QA exclusivo qa_studio.
- Cambios: plan actualizado a Rojo/Git y estado real; preparación y primera oleada desglosadas; README/backlog alineados. Dos proyectos usan CFrame persistible y Technology=ShadowMap explícito, conservando Brightness=2. check verifica doce componentes de cada CFrame, token3 de iluminación y brillo. Se incluye la corrección anterior de setup para Wally 0.3.2 sin --locked y control de hash del lock.
- Alcance: actualización y preparación. No se han implementado reactor, enemigos, combate ni HUD de gameplay. [Siguiente encargo](../tasks/reactor-defense-hito-1.md).
- Entorno: Windows, PowerShell, Rojo 7.7.0, Wally 0.3.2 y Luau LSP 1.69.0; sin nuevas dependencias.

| Comprobación | Estado | Evidencia |
|---|---|---|
| Formato, lint, ambos XML y separación de pruebas | Aprobada | scripts/check.ps1; cero errores/warnings de lint; checks CFrame/iluminación incluidos. |
| Análisis estricto | Aprobada | scripts/typecheck.ps1; artifacts/typecheck.log. |
| Build de pruebas binario | Aprobada | scripts/build.ps1 -Test -Binary. |
| Revisión independiente | Aprobada | [Informe](2026-09-16-reactor-prep-review.md). |
| Escena corregida abierta en Studio | No ejecutada aún | Requiere abrir el nuevo binario y verificar con QA; solicitado al propietario. |
| CI remota de esta actualización | Pendiente | Se registrará ejecución y commit después del envío de la rama de validación. |

## Manifiesto de builds

- Producción XML: `F88FAEBE8E9C5B471D242EEF34134909C1B4D4584AE252CF8CDC026DFC8EF494`.
- Pruebas XML: `E906588697B2823EAC47347E6AD389E47D0BAFC903127CB0D9F3215EF18C552C`.
- Pruebas binario: `F38B854476CDD68F384F424DCA2346BEAB66490D20AE818103231C92ADA38CE7`.

La aprobación funcional del contador anterior identifica builds diferentes y no acredita estas propiedades de escena. Las fuentes Luau no se cambiaron. El diagnóstico previo documenta Position no cargable y la hipótesis de migración de iluminación; Technology explícita evita la ambigüedad del archivo, pero el efecto final requiere QA.

Después de generar los builds, el XML de pruebas cambió en disco a `AF2735117F401FD79A6F28F1A394AABC5B113BE5DC29F5A3300AE20072461BC8` (85,236 bytes). El binario conserva su hash F38B... y es el único artefacto congelado para este QA. No se reconstruye ni reemplaza el XML durante la prueba; los hashes anteriores identifican las salidas generadas, no el XML actual. No se atribuye el cambio a una acción concreta sin evidencia.

- Limitaciones: ninguna publicación de experiencia ni cambio de acceso de invitados. Los artefactos locales no están versionados. CI y QA deben cerrarse con evidencia propia.
- Recursos incorporados: ninguno.
- Siguiente paso: QA verifica apertura, posiciones, iluminación y pruebas afectadas; cerrar preparación antes de aceptar GAME-02. El calendario sigue provisional hasta una oleada jugable.
