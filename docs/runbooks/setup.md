# Preparar el entorno

Ejecutar PowerShell desde la raíz del repositorio. Los scripts resuelven sus rutas desde su propia ubicación y deben admitir espacios.

```powershell
.\scripts\doctor.ps1
.\scripts\setup.ps1
.\scripts\check.ps1
.\scripts\build.ps1
.\scripts\build.ps1 -Test
```

`doctor` diagnostica disponibilidad; `setup` prepara las herramientas declaradas. Revisar su salida y resolver cualquier bloqueo antes de afirmar que el entorno está listo. La instalación puede requerir acceso de red o aprobación del entorno administrado.

En una sesión nueva de Codex, verificar que carga `AGENTS.md`, las ocho definiciones de `.codex/agents` y las cinco skills de `.agents/skills`. Reutilizar el MCP ya configurado. No guardar identificadores efímeros de Studio en archivos.

Para sincronización interactiva, instalar el plugin oficial Rojo compatible con la CLI fijada, abrir un lugar local dedicado, ejecutar `rojo serve default.project.json` y conectar el plugin al servidor local. Consultar [Rojo](https://rojo.space/docs/) si cambia el flujo. No conectar sobre un lugar que contenga trabajo sin preservar. No activar Script Sync en los árboles administrados.

La validación de instalación requiere un build y un playtest reales; consultar `development.md`. Registrar versiones y resultados en un informe, incluyendo verificaciones no ejecutadas.
