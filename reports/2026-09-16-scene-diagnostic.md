# Diagnóstico de escena — 2026-09-16

- Responsable: tech_lead/review_build. Encargo: diagnóstico de discrepancias de escena detectadas por QA; solo escritura de este informe durante frozen.
- Cambios: ninguno en código, configuración, builds ni Studio. No se reconstruyó ni se usó MCP Studio.
- Resultado: defecto confirmado de representación persistente de posiciones (P2); causa probable de migración de iluminación pendiente de confirmación con atributos (P2).

## Posiciones: causa identificada

Referencias: `default.project.json:23,33` y `test.project.json:41,63`. Ambos declaran Position para Baseplate y SpawnLocation. Los dos XML existentes contienen respectivamente `<Vector3 name="Position"><X>0</X><Y>-0.5</Y><Z>0</Z></Vector3>` y Y=0.5; ninguno contiene CFrame para esas partes.

La definición oficial de Roblox identifica BasePart.Position como `serialization.can_load: false` y `can_save: false`. El valor se puede asignar en ejecución, pero no representa una posición cargable desde archivo. Esto explica la pérdida al abrir el build y concuerda con la observación de QA: ambas partes aparecen en el origen. Fuente: [Roblox creator-docs, BasePart.Position, líneas 1461–1487](https://github.com/Roblox/creator-docs/blob/main/content/en-us/reference/engine/classes/BasePart.yaml#L1461).

Corrección mínima propuesta al coordinador, cuando vuelva a edit: reemplazar Position por CFrame en ambas partes y ambos proyectos. Con rotación identidad, Baseplate usaría `[0,-0.5,0,1,0,0,0,1,0,0,0,1]`; SpawnLocation usaría `[0,0.5,0,1,0,0,0,1,0,0,0,1]`. El formato de doce componentes está documentado por [Rojo, CFrame](https://rojo.space/docs/v7/properties/#cframe). Añadir una comprobación del CFrame serializado para evitar que la igualdad entre proyectos acepte el mismo error en ambos.

Aceptación pendiente: regenerar tras devolver exclusividad, abrir la versión nueva con QA y comprobar en Edit ambas posiciones y tamaños. No se declara verificada esta corrección; aquí no se implementó.

## Iluminación: hipótesis bien sustentada, aún no confirmada

Referencias: `default.project.json:41` y `test.project.json:81`. Ambos declaran Brightness=2. Los XML contienen `<float name="Brightness">2</float>`, Ambient correcto y ClockTime=14. No declaran Technology. La búsqueda en game no encuentra código que modifique Lighting.

`artifacts/qa-reconnected-snapshot.json` identifica RobloxAgencyTests.rbxl y registra Brightness=3.1333863735198975. El archivo de comparación reconectada confirma coincidencia de las siete fuentes; no se usa la captura previa de AutoRecovery como evidencia del build actual.

Un reporte de reproducción publicado en el repositorio oficial de rbx-dom describe precisamente que omitir Technology provoca que Studio lea Compatibility(2), ejecute su migración y cambie Brightness, además de insertar efectos y atributos. Es evidencia primaria del defecto de serialización, pero no prueba por sí sola que la migración sea la causa en esta instancia. [rbx-dom issue 637](https://github.com/rojo-rbx/rbx-dom/issues/637).

Comprobación mínima pedida al coordinador/QA: leer Lighting.GetAttributes y sus hijos, buscando `RBX_BackupBrightness=2`, `RBX_OriginalTechnologyOnFileLoad=2`, `RBX_LightingCompatibilityMigrated=true`, ColorGradingEffect y BloomEffect. Si coinciden, el cambio de Brightness se explica por migración al cargar. No compensar numéricamente el valor de entrada.

Propuesta posterior a esa confirmación: declarar explícitamente la configuración de iluminación soportada por el toolchain, comprobar qué propiedades quedan efectivamente serializadas y hacer un roundtrip con QA. El reporte upstream advierte que algunos valores por defecto pueden omitirse; escribir una propiedad en JSON sin comprobar el resultado no basta. No se propone actualizar dependencias ni seleccionar a ciegas una Technology.

## Pruebas y manifiesto

| Comprobación | Estado | Evidencia |
|---|---|---|
| Lectura de propiedades XML | Aprobada | XPath por Name de Baseplate, SpawnLocation y Lighting sobre ambos XML. Position existe; CFrame falta; Brightness=2. |
| Hashes existentes | Aprobada | XML pruebas `3FC2E33DF60AB8910162EC55A153A7B1D400C2B6B4294DDCD0CE386798628602`; binario `9FCE425BC2E33D8BCAF29AD32F53C0BFC6DF7CEDFF12B28B82A5E89F6BAE0325`. |
| Fuentes oficiales de Position/CFrame | Aprobada | Documentación Roblox y Rojo enlazada arriba. |
| Lectura de evidencia QA reconectada | Aprobada | Snapshot contiene brillo diferente; comparison registra siete match=true. Esta revisión no ejecutó el playtest. |
| Confirmar atributos de migración | No ejecutada | Requiere operador QA; solicitado al coordinador. |
| Corrección y prueba en Studio | No ejecutada | Frozen; reservado al siguiente ciclo edit → frozen → playtest. |

- Hashes de configuración diagnosticada: default.project.json `F8E8EAA551069AB8528B0EA63A0492A8292EBACB636529D64B66DBCB332DEBBD`; test.project.json `716CA86504A5000C83C5F22F90B427A472C194062002A70E625A1D32F4D7E016`.
- Limitaciones: no se decodificó el binario ni se operó Studio; la observación en Studio procede de QA. El enlace adicional de bug en DevForum devuelve protección antirobot; no se usó para extraer fórmulas. La revisión previa del build comprobaba árbol/contratos, no roundtrip de propiedades, y no cubría estos defectos.
- Recursos incorporados: ninguno.
- Siguiente paso: QA puede completar el contador bajo el contrato de siete fuentes, documentando aparte la escena; coordinador aplica la corrección de CFrame tras recuperar edit y confirma la causa de iluminación antes de una nueva aceptación de escena.
