---
name: roblox-release
description: Prepara y valida paquetes de lanzamiento de Roblox Agency y publica únicamente con autorización vigente del propietario.
---

# Lanzamiento

Leer `docs/runbooks/release.md` y el brief. Identificar revisión candidata y destino propuesto. Preparar build normal, comprobaciones, playtest, revisión, notas y recursos de ficha con procedencia. Confirmar exclusión de utilidades QA y establecer una revisión de recuperación.

Completar el paquete revisable antes de solicitar la decisión final. Publicar requiere autorización explícita vigente para el destino; reutilizar la existente si cubre la acción. Una solicitud para preparar el lanzamiento no autoriza publicación ni gastos.

Si hay autorización, ejecutar sobre el destino confirmado y registrar estado y comprobación posterior. Ante respuesta incierta, inspeccionar el estado antes de repetir. Un bloqueo de acceso se informa con su causa y el paquete ya preparado.

Mantener evidencia en `reports/`. Distinguir preparación local, publicación y validación posterior; no declarar publicado por haber generado un archivo.
