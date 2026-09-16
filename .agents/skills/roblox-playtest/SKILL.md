---
name: roblox-playtest
description: Ejecuta y documenta playtests de Roblox Agency mediante el operador qa_studio y la conexión MCP existente.
---

# Playtest en Studio

Esta operación corresponde a `qa_studio`. Los demás especialistas preparan escenarios y se los entregan. Leer `docs/runbooks/development.md` y la aceptación del cambio.

Obtener confirmación del coordinador de que se pausaron escrituras sincronizadas. Identificar la revisión o manifiesto probado. Descubrir las instancias mediante la herramienta disponible de listado; confirmar destino y estado antes de iniciar. Nunca reutilizar IDs guardados de otra sesión. Si los destinos siguen siendo indistinguibles, pedir selección antes de mutar.

Ejecutar pruebas del lugar de pruebas, interacciones reales del cliente y verificaciones relevantes del servidor. Para el contador inicial: clic válido y valor confirmado, solicitud inválida rechazada y ráfaga limitada. Guardar consola, resultados de assertions y capturas en `artifacts/`.

Detener Play al terminar y devolver al coordinador el permiso de escritura. Registrar aprobadas, fallidas y no ejecutadas en un informe bajo `reports/`. Ante desconexión seguir `docs/runbooks/recovery.md`; no informar éxito sin evidencia.
