# Revisión de preparación Reactor Defense — 2026-09-16

- Tarea y responsable: revisión independiente de configuración persistente y preparación, tech_lead/review_build.
- Archivos propios: solo este informe. No se cambió código/configuración, no se reconstruyó y no se accedió a Studio.
- Entorno: Rojo 7.7.0 confirmado con `rojo --version`; `build --help` confirma formatos rbxl/rbxlx. Herramientas fijadas en rokit.toml sin cambios.
- Estado: investigación y revisión del diff final completadas; configuración aprobada estáticamente, aceptación en Studio pendiente.

## Recomendación de iluminación

La opción mínima recomendada para este bootstrap es `"Technology": "ShadowMap"` dentro de Lighting.$properties en ambos proyectos, conservando Brightness=2. Es un puente de compatibilidad de serialización para el toolchain fijado; no una decisión artística definitiva de Reactor Defense.

La [definición oficial de Technology](https://github.com/Roblox/creator-docs/blob/main/content/en-us/reference/engine/enums/Technology.yaml) asigna ShadowMap=3; Compatibility=2 está retirado. La [definición de Lighting](https://github.com/Roblox/creator-docs/blob/main/content/en-us/reference/engine/classes/Lighting.yaml#L564) conserva Technology como cargable/guardable, aunque sustituida por LightingStyle y PrioritizeLightingQuality. Es una propiedad restringida, así que no se propone modificarla mediante un script del juego.

[Rojo documenta enums](https://rojo.space/docs/v7/properties/#enum) por nombre o valor explícito: si el nombre no se resuelve, el formato tipado es `"Technology": { "Enum": 3 }`. No se ha necesitado ni probado esa alternativa aquí.

El [reporte primario rbx-dom #637](https://github.com/rojo-rbx/rbx-dom/issues/637) describe la migración al omitir Technology y el problema de defaults dependientes. ShadowMap=3 evita tanto Compatibility=2 como la ambigüedad del default Voxel=1 descrito en ese reporte. Su equivalencia moderna esperada es Soft con PrioritizeLightingQuality=true. Esta equivalencia y la ausencia de migración deben comprobarse al abrir el resultado; no se dan por ejecutadas.

La alternativa Voxel=1 es válida si el coordinador desea ese estilo, pero requiere verificar que el token 1 quede explícito en el artefacto. No aceptar un XML que omita Technology. No compensar el brillo ajustando el número de entrada ni añadir un script de runtime para ocultar la migración.

## Aceptación necesaria

| Comprobación | Estado | Evidencia o condición |
|---|---|---|
| Investigación oficial de enum/serialización | Aprobada | Fuentes y comandos arriba. |
| CFrame persistente en ambos proyectos | Pendiente de revisión final | Baseplate Y=-0.5, SpawnLocation Y=0.5; identidad de rotación. |
| Lighting serializado | No ejecutada | Coordinador debe comprobar `<token name="Technology">3</token>` y Brightness=2 tras build. |
| Escena en Studio | No ejecutada por este revisor | QA debe comprobar posiciones, brillo, estilo y ausencia de nueva migración Compatibility. |
| Separación de pruebas y checks | Pendiente de revisión final | Mantener árbol base idéntico salvo dos ramas; producción sin tests. |
| Documentación de Reactor y Rojo/Git | Pendiente de revisión final | Verificar alcance autorizado, fuente de verdad y distinción entre aprobación estática y QA. |

- Limitaciones: no se ha ejecutado una prueba de serialización con el cambio propuesto; la recomendación requiere el build y roundtrip del coordinador/QA. Ninguna aprobación de este informe sustituye un playtest.
- Recursos incorporados: ninguno.
- Siguiente paso: coordinador avisa al finalizar el diff; este revisor comprueba configuración, comprobaciones de regresión y documentos, y añade hashes y hallazgos aquí.

## Revisión final del diff

Sin defectos nuevos en código/configuración. Ambos proyectos usan CFrame de doce componentes con Y=-0.5/+0.5 y rotación identidad, y Technology ShadowMap. La inspección independiente de los dos XML producidos por el coordinador confirmó CoordinateFrame completo, ausencia de Position, token Technology=3 y Brightness=2. `scripts/check.ps1:39–66` comprueba precisamente esas propiedades: parseo con cultura invariante, doce componentes y tolerancia 0.00001; mantiene las comprobaciones de árbol único y exclusión de pruebas.

Plan, README y encargo de la primera oleada conservan Rojo/Git y delimitan preparación, gameplay futuro y aceptación con Studio. El hito inicial es individual y el prototipo completo sigue contemplando 1–4 jugadores; no se confunden esas dos entregas. Los contratos propuestos mantienen autoridad del servidor, cancelación de trabajo obsoleto y exclusión de persistencia/compras reales. No existe gameplay nuevo que revisar.

Hallazgos remitidos al coordinador (sin editar sus documentos):

- **P2, encargo QA desactualizado:** `tasks/bootstrap-qa.md:8` aún incluye hashes 3FC2… y 9FCE… del build anterior. Reproducción: comparar esos valores con Get-FileHash del binario actual, F38B…. Reutilizarlo lleva a rechazar el build corregido o validar el antiguo. Actualizar el manifiesto antes de despachar QA o marcar ese encargo como histórico y proporcionar uno vigente.
- **P3, estado de BASE-08:** `tasks/backlog.md` todavía describe reemplazar Position y diagnosticar iluminación como acciones no realizadas. La corrección local ya existe; debe describir el roundtrip pendiente sin declarar aprobado el comportamiento.

| Comprobación final | Estado | Evidencia |
|---|---|---|
| Revisión de proyectos y regresión | Aprobada | Diff e inspección XML de ambos builds. |
| Separación producción/pruebas | Aprobada (estática) | Se conservan ramas disjuntas y checks previos; ningún script nuevo. |
| Coherencia plan/hito/README | Aprobada | Alcance local y futuro distinguidos; Rojo/Git y autoridad de servidor. |
| Check y build binario | No ejecutada por este revisor | Coordinador informa ejecución aprobada; no se repiten builds en este encargo. |
| QA del build corregido | No ejecutada por este revisor | No se accedió a Studio. El PASS anterior del contador no acredita el roundtrip nuevo. |

Manifiesto SHA256 de la revisión final:

- default.project.json: `2E9C83C3BCD0385CCD4726405B7A0CFE494FF70C59123C7130A7730B0197ECC2`.
- test.project.json: `9CD4DF612987606F8B553A0F46661217588B319BC1DE079B8682876BB4FCB61C`.
- scripts/check.ps1: `13568EE9EE34E00F8382EF73F8F44A739F3951F0CE0BE50D2D2056775709D077`.
- Projects/plan-01-reactor-defense.md: `273064DA8ECF528BFFF298A22F24E2D6D6C279ED70E35904164E1823CB66D8BD`.
- tasks/reactor-defense-hito-1.md: `AAB6A7903E2F2C75DCDC44EAD88B531BA8621C769715391A9E272424DF285275`.
- RobloxAgencyTests.rbxl: `F38B854476CDD68F384F424DCA2346BEAB66490D20AE818103231C92ADA38CE7`.

Siguiente paso final: coordinador corrige referencias de QA/estado; qa_studio comprueba el build nuevo en Edit y prueba lo afectado. Aceptar preparación únicamente con evidencia correspondiente a esa versión y CI remoto cuando se envíe la corrección.

Seguimiento de referencias: el coordinador actualizó el encargo con aceptación de escena y binario F38B… correcto. Una lectura posterior detectó que el XML declarado E906… no coincide con el archivo presente: `AF2735117F401FD79A6F28F1A394AABC5B113BE5DC29F5A3300AE20072461BC8`, comprobado dos veces sin reconstruir. Se remitió esa discrepancia para reconciliar el manifiesto definitivo; el hash no debe copiarse entre reconstrucciones sin volver a medirlo.
