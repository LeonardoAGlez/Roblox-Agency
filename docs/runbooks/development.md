# Desarrollo y validación

1. El coordinador toma una tarea del backlog y define aceptación, archivos asignados y dependencias usando `tasks/templates/task.md`.
2. Delega tareas independientes con un máximo de tres especialistas activos. Solo el coordinador modifica el backlog compartido; cada archivo tiene un escritor.
3. Implementar en archivos. Ejecutar `scripts/check.ps1` y construir con `scripts/build.ps1`; usar `-Test` para el lugar de pruebas.
4. El coordinador detiene escrituras sincronizadas y entrega la versión a `qa_studio`. QA descubre instancias por MCP, comprueba el destino y confirma el estado Edit antes de iniciar.
5. QA ejecuta las pruebas del lugar de pruebas y valida el botón en cliente, la confirmación del contador, el rechazo de solicitudes inválidas y el límite de frecuencia. Captura consola y pantalla, detiene Play y devuelve el control de escritura.
6. El revisor evalúa cambios y evidencia. El coordinador integra, registra limitaciones y cierra solo criterios demostrados.

Identificar la revisión Git o, si existen cambios sin commit, un manifiesto de archivos y hashes en la evidencia. Conservar capturas y logs en `artifacts/`; resumir en `reports/` con la plantilla de entrega. No sustituir el clic real de interfaz por una llamada directa al servidor: ambas pruebas cubren cosas distintas.

Tras dos ciclos fallidos sobre el mismo problema, registrar hipótesis y evidencia y cambiar el enfoque. Un fallo de conexión no justifica reintentos infinitos ni recrear el proyecto.

## Contador: aceptación reproducible

El build de pruebas añade `AgencyTests` al servidor y `AgencyIntegrationTests` al cliente. Esperar ambos mensajes `ALL PASSED` antes de interactuar: la integración parte de cero, rechaza payloads/argumentos inválidos, limita una ráfaga de 20 a un incremento y acepta otro tras el cooldown. Termina en 2. Después hacer un clic real: cliente, etiqueta y servidor deben mostrar 3. No disparar remotos desde `execute_luau` cuando sus capacidades lo impidan; usar el LocalScript de pruebas incluido por Rojo.

En CLI 0.154.0 seguir [aislamiento](agent-isolation.md). Para una entrega al operador interactivo, que pueda tramitar aprobaciones MCP del host:

```powershell
pwsh -NoProfile -File scripts/start-agency.ps1 -Operator qa_studio -Prompt "Lee tasks/bootstrap-qa.md y ejecuta el encargo; registra la entrega en artifacts/qa-final-result.md."
```

El encargo debe actualizarse con la revisión real antes de reutilizarlo. El coordinador no opera Studio mientras QA tenga exclusividad. Nunca reutilizar el hash de ejemplo para una versión modificada.
