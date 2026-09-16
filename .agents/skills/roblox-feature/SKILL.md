---
name: roblox-feature
description: Implementa funciones Luau en la base Rojo de Roblox Agency con contratos cliente-servidor y validación funcional.
---

# Función Roblox

Leer `AGENTS.md`, `docs/architecture.md` y los criterios del encargo. Inspeccionar módulos existentes antes de definir contratos. Consultar documentación oficial de Roblox para APIs y límites actuales.

Editar archivos administrados por Rojo; no activar Script Sync sobre el mismo árbol. Mantener estado autorizado y validación de entradas en servidor. El cliente representa estado confirmado. Aplicar tipos estrictos y añadir dependencias solo cuando resuelvan una necesidad del encargo.

Ejecutar `scripts/check.ps1` y `scripts/build.ps1`; añadir pruebas de comportamiento proporcionadas al cambio. Para pruebas dentro de Roblox, preparar el proyecto `-Test` y entregar a `qa_studio`. No incluir utilidades QA en el build normal.

Usar `docs/runbooks/development.md` para integración y `tasks/templates/delivery.md` para resultados. Un build aprobado no demuestra comportamiento de UI o servidor.
