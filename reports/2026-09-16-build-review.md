# Revisión independiente del build — 2026-09-16

- Tarea y responsable: revisión de build y contrato BASE-04; tech_lead (review_build).
- Resultado y cambios: sin hallazgos bloqueantes en el diff de `scripts/build.ps1`, `scripts/check.ps1` y `test.project.json`. Solo se crea este informe; no se modificaron archivos del autor ni se accedió a Studio.
- Revisión Git: `0659c8a5b57f3fe06ad35dc740f4a42f931d1ad9` más cambios locales. Lectura de README, backlog, plantillas, contrato QA y siete fuentes Luau.
- Entorno: Windows, PowerShell 7.6.5. Ejecución de check/typecheck asignada al coordinador; no se duplica aquí.

| Comprobación | Estado | Evidencia |
|---|---|---|
| Revisión del árbol y separación | Aprobada | `test.project.json:4` declara DataModel y copia el árbol base con dos ramas de pruebas. `scripts/check.ps1:19` compara ambos árboles tras retirar esas ramas; líneas 39–58 comprueban servicios únicos y ubicación de las pruebas. |
| Inspección XML local | Aprobada | Ambos XML contienen exactamente Lighting, ReplicatedStorage, ServerScriptService, StarterPlayer y Workspace. Producción tiene cuatro contenedores de código; pruebas tiene siete e incluye CounterState.spec, runner e integration. |
| Revisión de formato binario | Aprobada (estática) | `scripts/build.ps1:11` cambia la extensión de salida, manteniendo proyecto y selección Test; el wrapper de herramientas aborta si Rojo devuelve error. No se ejecutó el build binario en esta revisión. |
| Contrato cliente-servidor | Aprobada (estática) | El servidor mantiene estado por Player, rechaza argumentos adicionales y valida acción, campos y frecuencia. Solo replica el valor calculado. PlayerRemoving elimina el estado. No hay persistencia, compras ni analítica. |
| Contrato QA | Aprobada (estática) | `tasks/bootstrap-qa.md` exige siete fuentes iguales, destino identificado, Play, pruebas automáticas, clic real 2→3, réplica y retorno a Edit. El test de integración no sustituye el clic manual. |
| check y typecheck | No ejecutada por este revisor | Los ejecuta el coordinador; sus resultados requieren evidencia separada. |
| Playtest y recuperación MCP | No ejecutada | Reservados a qa_studio; esta revisión no acredita BASE-04/05. |

## Manifiesto de evidencia

SHA256 de archivos revisados:

- `scripts/build.ps1`: `CAB5382E3B743775DD00EE1E302013E0B19A6C27C363DD1BC5D83C50F0299F9F`.
- `scripts/check.ps1`: `B09678377713C01B2A7CB8ADAAB03D26963E676C32B74DEBB3BB29B238C10D2D`.
- `test.project.json`: `716CA86504A5000C83C5F22F90B427A472C194062002A70E625A1D32F4D7E016`.
- `tasks/bootstrap-qa.md`: `FAE24B1F4D616C2954DBE32B0EB49A634F1FFE0DC118F6022DC17D06369C3E1D`.

Última lectura XML tras la regeneración concurrente del coordinador:

- Producción: `7DD67BEB00EE4E8207DCCD1A70534000D9560532C4E4D425E694E372729F454D`.
- Pruebas: `3FC2E33DF60AB8910162EC55A153A7B1D400C2B6B4294DDCD0CE386798628602`.

Para reproducir la inspección se cargaron los XML con `[xml](Get-Content -Raw ...)`, se enumeraron `/roblox/Item` y `//Item[@class="Script" or @class="LocalScript" or @class="ModuleScript"]`, y se calcularon hashes con Get-FileHash. La lectura inicial de producción ocurrió durante la regeneración; los valores anteriores son los de la lectura final.

- Limitaciones: revisión estática y de artefactos locales; no demuestra comportamiento de Roblox, coincidencia con la instancia abierta ni CI remota. La duplicación del árbol necesita mantenerse mediante la comprobación de igualdad ya añadida.
- Recursos incorporados y procedencia: ninguno.
- Siguiente paso: coordinador reúne check/typecheck y CI; qa_studio verifica el destino y ejecuta el contrato antes de completar BASE-04/05. No se solicitan correcciones de código.

## Ampliación: corrección de setup y CI

- Alcance adicional autorizado: revisar `scripts/setup.ps1` sin editarlo. Sin hallazgos nuevos en la corrección.
- Hallazgo original, severidad alta (P1), corregido localmente: `wally install --locked` impide instalar herramientas en CI con la versión fijada 0.3.2. Reproducción independiente: ejecutar el binario local con `install --locked` devuelve código 1 y `Found argument '--locked' which wasn't expected`. `install --help` de esa misma versión no lista la opción. `.github/workflows/validate.yml:16` ejecuta setup en el paso Install pinned tools.
- Corrección revisada: `scripts/setup.ps1:23–28` ejecuta `install` y compara SHA256 del lock existente antes y después; lanza error si cambió. `Invoke-AgencyTool` propaga el fallo de Wally. La ausencia posterior de un lock previamente existente también provoca error por la configuración Stop del wrapper. Si aún no existe lock, permite su primera generación.

| Comprobación adicional | Estado | Evidencia |
|---|---|---|
| Reproducir opción incompatible | Aprobada | Wally 0.3.2, `install --locked`, código 1. El rechazo ocurre al analizar argumentos. |
| Inspección de guardia SHA256 | Aprobada (estática) | Hash previo y posterior del mismo archivo, comparados antes de continuar setup. |
| Setup completo corregido | No ejecutada por este revisor | El coordinador comunica ejecución completa aprobada y lock sin cambios; conservar su evidencia separada. |
| CI de la corrección | No ejecutada | El coordinador identifica run 35062600912 como fallo del HEAD anterior en Install pinned tools; no acredita esta versión local. |

- SHA256 adicional: `scripts/setup.ps1` = `4BCA79C8640ED16F3029851E26634E0985498E0E525509ABD60CD929B4E9C31E`; `wally.lock` = `43608C82FF8D58D1085D13CC84E72E8648DE49A3E9257129B06AE5C1975ED7BD`.
- Limitaciones: la comparación detecta cambios después de instalar, no evita ni revierte la escritura del lock o de paquetes. Es adecuada como puerta de fallo de este bootstrap; el manifiesto actual no declara dependencias. No demuestra resolución de futuros paquetes ni un CI remoto aprobado.
- Siguiente paso: coordinador incorpora esta revisión y evidencia local; la validación remota de la corrección permanece pendiente de enviar la versión correspondiente según su autorización. No se cambió setup, workflow ni lock durante esta revisión.
