# Arquitectura

## Fuente del proyecto

Git y los archivos del repositorio son la fuente del contenido administrado por Rojo. No activar Script Sync sobre los mismos árboles. Los cambios persistentes realizados en Studio deben exportarse e incorporarse al proyecto antes de cerrar una tarea.

| Directorio | Destino Roblox | Responsabilidad |
|---|---|---|
| `game/src/server` | `ServerScriptService` | Estado autorizado y validación |
| `game/src/client` | `StarterPlayerScripts` | Interfaz y entrada del jugador |
| `game/src/shared` | `ReplicatedStorage` | Contratos y módulos compartidos |
| `game/tests` | Solo proyecto de pruebas | Comprobaciones y utilidades de QA |
| `game/assets` | Según mapa Rojo | Recursos exportados y su procedencia |

`default.project.json` construye el lugar normal; `test.project.json` añade pruebas. Los archivos generados y capturas van a `artifacts/`, fuera de Git. Los informes resumidos van a `reports/`.

## Demostración

Un botón envía una solicitud por RemoteEvent. El servidor valida la forma y frecuencia de la solicitud, actualiza un contador temporal por jugador y replica el valor confirmado. El cliente representa ese valor. La implementación y sus constantes son la autoridad sobre el contrato exacto; no hay compras ni persistencia iniciales.

## Coordinación

El coordinador delega a un máximo de tres especialistas simultáneos, con modelos heredados de la sesión. Asigna un escritor por archivo y es el único que modifica el backlog compartido. Entre especialistas, solo `qa_studio` usa el MCP de Roblox. Descubre la instancia al comenzar cada sesión y pausa las escrituras sincronizadas durante los playtests. La configuración de herramientas debe verificarse en una sesión nueva; una instrucción textual por sí sola no prueba aislamiento.

## Dependencias y calidad

### Compatibilidad de agentes

En CLI 0.154.0 los overrides MCP por rol no se aplican. Usar sesiones raíz separadas de coordinación y QA según [el procedimiento de aislamiento](runbooks/agent-isolation.md). Los ocho perfiles siguen disponibles; QA opera en su sesión dedicada cuando necesita Studio. No confundir una opción declarada con una restricción comprobada.

Rokit fija herramientas; Wally queda preparado sin librerías de gameplay iniciales. StyLua comprueba formato, Selene realiza análisis estático y Rojo valida la construcción. Luau usa tipos estrictos. Las pruebas de comportamiento se ejecutan dentro de Roblox y no se consideran aprobadas por pasar únicamente el build.
