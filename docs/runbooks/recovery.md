# Recuperación

## Studio o MCP desconectado

- Pausar el playtest y las escrituras que puedan sincronizarse; conservar logs y trabajo en disco.
- Consultar las instancias actuales por MCP. Los IDs previos pueden haber caducado.
- Comprobar Studio abierto, MCP habilitado y la conexión del cliente. Usar la [guía oficial](https://create.roblox.com/docs/studio/mcp) para corregirla.
- Al reconectar, confirmar nombre, identidad del lugar y estado de juego antes de cualquier modificación. Si hay varios destinos indistinguibles, solicitar la selección del usuario.
- Reconstruir desde los archivos y repetir únicamente pruebas interrumpidas o afectadas. Registrar la interrupción en el informe.

## Conflicto de sincronización o contenido perdido

Detener Rojo y cualquier sincronizador adicional, preservar los cambios locales y exportar lo necesario de Studio. Comparar con Git y resolver el conflicto en archivos; no hacer reset destructivo para limpiar el estado. Reconectar un único sincronizador y volver a construir.

## Herramienta fallida

Ejecutar `scripts/doctor.ps1`, comparar versiones con `rokit.toml` y revisar la salida del comando que falló. Resolver instalación o conectividad sin modificar arbitrariamente las versiones fijadas. Tras dos intentos fallidos equivalentes, entregar diagnóstico y el bloqueo concreto.
