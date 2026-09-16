# Encargo BASE-04 — comprobación final

- Responsable: qa_studio en sesión raíz dedicada; revisor: coordinador.
- Objetivo: validar contador y pruebas de integración actuales con MCP Studio.
- Archivos asignados: solo artifacts/qa-final-* (evidencia); no editar código/configuración.
- Dependencias: check.ps1 y typecheck.ps1 aprobados para el build actualizado. La sincronización del build actual NO está confirmada. Antes de comenzar, el coordinador debe detener escrituras/Rojo y otorgar exclusividad; este archivo por sí solo no representa una exclusión vigente.
- Destino: abrir el build local artifacts/builds/RobloxAgencyTests.rbxlx como lugar de pruebas dedicado y redescubrir Studio. En la revisión anterior solo apareció test01.rbxl; no asumir que ese lugar puede modificarse. Si el destino sigue ambiguo, solicitar su identificación al propietario.
- Descubre studio_id. Verifica estado Edit y lugar dedicado indicado. Confirma exactamente siete LuaSourceContainer, compara Source con los siete archivos de game/src y game/tests (normaliza CRLF). No iniciar Play si falta AgencyIntegrationTests.integration o difiere algún script. Si la conexión falla o falta el script, diagnostica y reporta, sin modificar Studio ni seguridad ni usar shell para UI.
- Hash build test esperado: 73F73980013F90AF23EA95309ADE015B058F9FB5D50846D9D04134EF93BA0296.
- Si fuentes coinciden: iniciar Play, esperar como máximo 30 segundos por consola AgencyTests ALL PASSED y AgencyIntegration ALL PASSED. Verificar atributo AgencyCounter=2 y TextLabel Count=2 en cliente. Enviar un clic real con user_mouse_input a LocalPlayer.PlayerGui.AgencyCounterUI.CounterCard.IncrementButton. Verificar cliente/UI=3 y atributo del jugador en servidor=3.
- Guardar consola, assertions y captura en artifacts/qa-final-*. No ocultar errores ni declarar PASS no ejecutados. Detener Play al terminar incluso ante fallos, verificar Edit y devolver exclusividad al coordinador.
- Aceptación: fuentes iguales, unidad/integración/clic/replicación pasan y Edit restaurado. No ejecutar cambios de permisos, publicaciones, compras ni delegación. Usa tasks/templates/delivery.md para informe final; si algo impide comprobar, reportar limitación concreta.
