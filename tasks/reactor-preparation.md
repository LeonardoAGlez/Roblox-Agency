# Encargo de actualización del plan y preparación

- ID y objetivo: GAME-01 / BASE-07 / BASE-08. Actualizar plan Reactor Defense a la base existente, corregir persistencia de escena y verificar CI de la preparación.
- Responsable y revisores: coordinador implementa e integra; tech_lead revisión independiente; qa_studio operador exclusivo Studio.
- Contexto: Projects/plan-01-reactor-defense.md, README/backlog, diagnóstico de escena y entrega QA reconectada del 2026-09-16.
- Archivos asignados: coordinador Projects/plan-01-reactor-defense.md, README, default/test.project.json, scripts/check.ps1, scripts/setup.ps1, tasks y reports/2026-09-16-reactor-update.md; tech_lead reports/2026-09-16-reactor-prep-review.md; QA reports/2026-09-16-scene-qa.md y artifacts/scene-qa-*.
- Dependencias: conservar Luau/toolchain y fuente Rojo/Git, ningún escritor concurrente por archivo; frozen antes de QA. No implementar gameplay en esta actualización.
- Aceptación: plan elimina estado vacío y Script Sync; primera oleada desglosada; CFrame y tecnología explícitos en archivos y builds; check/tipos aprobados; CI remota verde del commit correspondiente; QA confirma propiedades al abrir el build y final Edit. No cerrar las dos últimas condiciones por validación local.
- Pruebas y evidencia: hashes de builds, comprobaciones XML en check, revisión independiente, ejecución remota identificada, comparación y observaciones MCP persistidas al obtenerlas.
- Decisiones autorizadas: actualización solicitada por propietario; conservar alcance de gameplay original. No publicación de experiencia, gastos ni modificación de acceso de invitados.
- Estado: implementación local terminada; aceptación externa de escena y CI se registra en la entrega y backlog.
