# Primer prototipo: Defensa del Reactor

## 1. Objetivo y alcance

Construir un juego cooperativo para **1–4 jugadores en PC y móvil**: defender un reactor de robots, combatir con autoataque y decidir cuándo mejorar el arma o reparar la base.

**Resultado esperado:** una versión jugable para pruebas cerradas que permita evaluar comprensión, diversión y ganas de repetir. El potencial de monetización se evaluará después.

Decisiones acordadas:

- Ambientación de robots y reactor, con modelos geométricos simples.
- Un mapa, cinco oleadas y partidas de aproximadamente 5–7 minutos.
- Progreso únicamente dentro de cada partida.
- Sin compras, guardado permanente, torretas, inventarios, misiones ni matchmaking propio.
- Interfaz inicial en español; móvil en orientación horizontal.
- Pruebas iniciales con conocidos de 16 años o más, como supuesto de reclutamiento.

**Estado comprobado al 2026-09-16:** base Luau con Rojo y Git, herramientas fijadas, separación de builds de producción/pruebas y análisis estricto operativo. QA verificó las siete fuentes, unidad/integración, clic real del contador y réplica cliente/servidor; recuperó la conexión MCP y confirmó Edit. La captura final no quedó persistida; el alcance de la evidencia está en [la entrega QA](../reports/2026-09-16-qa-reconnected.md). El contador valida el entorno, no implementa todavía Defensa del Reactor.

**Preparación restante:** cerrar BASE-07 (CI remota con el instalador corregido) y BASE-08 (posiciones e iluminación al abrir builds), según [backlog](../tasks/backlog.md). El diseño y los contratos del hito 1 pueden avanzar en paralelo; su aceptación requiere validar el build correcto en Studio. No se asume que `Place1` ni un AutoRecovery sean destinos autorizados.

## 2. Diseño jugable

### Ciclo de partida

**Prepararse → defender → recibir chatarra → mejorar o reparar → siguiente oleada → resultado → repetir.**

- La partida empieza tras 20 segundos de preparación cuando hay al menos un jugador.
- Los robots llegan por tres rutas despejadas hacia el reactor.
- Cada oleada termina al eliminar todos sus enemigos; hay 15 segundos entre oleadas.
- Victoria al completar cinco oleadas con el reactor vivo. Derrota cuando su vida llega a cero.
- Pantalla de resultados durante 15 segundos y reinicio automático. Todos los recursos y mejoras se restablecen.
- Una oleada tiene un límite de 90 segundos; agotarlo provoca derrota por sobrecarga, evitando partidas bloqueadas.

### Combate y cooperación

- Cámara estándar de Roblox en tercera persona, movimiento con teclado o joystick táctil.
- El arma dispara automáticamente al enemigo más cercano dentro de alcance y línea de visión. El servidor selecciona el objetivo y aplica daño.
- Los robots atacan el reactor. Los jugadores reciben daño por contacto, lo que añade riesgo al interceptarlos.
- Al morir, el jugador reaparece tras cinco segundos y conserva sus mejoras de esa partida.
- Cada oleada superada entrega la misma chatarra a todos los participantes, sin depender de quién dio el último golpe.
- Durante el descanso, cada jugador puede gastar su chatarra en daño, cadencia o reparación inmediata del reactor.
- Un jugador que entra durante una oleada espera en una zona segura hasta la siguiente. Recibe el presupuesto acumulado de oleadas anteriores para incorporarse en condiciones comparables.
- La dificultad se calcula al comenzar cada oleada según sus participantes. Las desconexiones no alteran enemigos ya creados; un servidor vacío reinicia la partida.

### Contenido y balance inicial

Estos valores son un punto de partida para pruebas, no un balance definitivo:

| Elemento | Configuración inicial |
|---|---|
| Arena | 120 × 120 studs, reactor central y tres entradas |
| Reactor / jugador | 1,000 / 100 puntos de vida |
| Arma | 20 de daño, un disparo cada 0.6 s, alcance de 40 studs |
| Enemigos | Básico desde oleada 1; rápido desde 3; pesado desde 5 |
| Cantidades para un jugador | 10, 14, 18, 22 y 26 enemigos |
| Escalado cooperativo | Cantidad × `1 + 0.6 × (jugadores − 1)`, redondeada hacia arriba |
| Recompensa | 100 de chatarra por oleada completada |
| Mejoras | Daño +25% o intervalo de disparo ×0.85; máximo tres niveles por opción |
| Costos de mejoras | 100, 150 y 200 por nivel |
| Reparación | 100 de chatarra restaura 200 de vida, hasta el máximo |

Limitar a 40 enemigos activos; mantener los restantes en una cola de aparición. Usar rutas fijas sin obstáculos y enemigos sin colisión entre sí para reducir problemas de navegación.

El HUD mostrará vida del reactor y jugador, oleada, enemigos restantes, chatarra y próxima acción. El mensaje inicial será: **“Protege el reactor. Acércate a los robots para disparar automáticamente.”**

## 3. Implementación técnica

### Flujo de desarrollo

Usar **Rojo + Git + Studio + MCP**, conservando la base del repositorio y el [procedimiento de desarrollo](../docs/runbooks/development.md). No activar Script Sync en los árboles administrados por Rojo.

- Mantener `game/src` y los proyectos Rojo como fuente de verdad; `game/tests` solo entra mediante `test.project.json`.
- Generar mapa, robots y UI de forma reproducible. Representar transformaciones persistentes con CFrame y comprobar las propiedades al abrir el build; exportar y revisar cualquier cambio persistente hecho en Studio.
- Usar Luau con `--!strict`, configuración centralizada y autoridad de servidor. Conservar las herramientas fijadas; no añadir paquetes sin necesidad concreta.
- Ejecutar `scripts/check.ps1`, `scripts/typecheck.ps1` y `scripts/build.ps1 -Test` al cambiar gameplay; la compilación no sustituye el playtest.
- El coordinador asigna archivos disjuntos y congela escrituras/sincronización antes de QA. Solo `qa_studio` opera MCP: descubre la instancia, confirma identidad, fuentes y Edit, prueba y devuelve Edit. Seguir el aislamiento descrito en el README.
- Registrar hashes, resultados realmente observados y evidencia local en cada entrega. Actualizar el manifiesto al reconstruir; los PASS del contador no se transfieren al gameplay nuevo.

Crear documentación breve de diseño, arquitectura, pruebas y reglas para agentes. Registrar cada hito con su resultado de prueba.

### Sistemas

| Sistema | Responsabilidad |
|---|---|
| Partidas | Estados, temporizadores, oleadas, participantes y reinicios |
| Enemigos | Aparición, rutas, ataques y limpieza |
| Combate | Selección de objetivos, cadencia, daño y muertes |
| Mejoras | Chatarra temporal, compras y reparación |
| Cliente | HUD, cámara, efectos y controles de interfaz |
| Diagnóstico | Eventos de partida y resumen de pruebas |

El servidor controla vida, daño, recursos, mejoras y resultado. El cliente presenta información y solicita acciones, conforme a la [guía de validación de Roblox](https://create.roblox.com/docs/scripting/security/client-server-boundary).

**Interfaces mínimas:**

- Solicitud de compra con el identificador de mejora o reparación.
- Respuesta de compra con resultado y motivo de rechazo.
- Estado replicado de partida, reactor y progreso individual.
- Eventos visuales de disparos e impactos, sin autoridad sobre daño.
- Eventos internos de inicio, oleada completada, muerte, compra y resultado.

Validar en servidor fase, participación, saldo, límites y frecuencia de solicitudes. Procesar descuento y beneficio juntos. Rechazar reparaciones con vida completa sin cobrar. Cada reinicio debe cancelar temporizadores anteriores y eliminar enemigos, efectos y conexiones de la partida terminada.

## 4. Entregas y calendario

**Estimación provisional: dos semanas**, con 5–10 horas semanales tuyas para configuración, pruebas y feedback. Reestimar después de la primera oleada jugable (hito 1), según resultados reales. Las pruebas en teléfono y el reclutamiento dependen de disponibilidad externa.

| Hito | Trabajo | Criterio de salida |
|---|---|---|
| 0. Preparación de la base | Conservar Rojo/Git; corregir persistencia de escena y cerrar CI | Builds y tipos aprobados, propiedades confirmadas al abrir el build y CI verde del commit preparado |
| 1. Defensa básica | Arena, reactor, enemigo básico, autoataque, vida, respawn y reinicio de una oleada | Una persona puede ganar, perder y volver a jugar sin enemigos, temporizadores ni conexiones residuales |
| 2. Partida completa | Cinco oleadas, tres enemigos, chatarra, mejoras y reinicio | Tres partidas consecutivas sin errores ni estado residual |
| 3. Cooperación y móvil | Escalado, entradas tardías, desconexiones y UI adaptable | Prueba con cuatro clientes y una partida completa en teléfono real |
| 4. Validación cerrada | Acceso de invitados, sesiones observadas y ajustes | Informe de resultados y decisión sobre la siguiente iteración |

Codex implementará sistemas y realizará las pruebas disponibles mediante Studio. Tú aportarás decisiones de sensación de juego, prueba en teléfono, acceso de cuenta y reclutamiento.

Antes del hito 4, comprobar los requisitos vigentes de la cuenta y el acceso de invitados en la [documentación oficial de publicación](https://create.roblox.com/docs/production/publishing/publish-games-and-places). La preparación local no autoriza publicación ni cambios de acceso; esas decisiones corresponden al propietario. No bloquear la primera oleada local por la configuración de invitados.

El primer encargo está desglosado en [GAME-02: defensa básica](../tasks/reactor-defense-hito-1.md). Se mantiene el alcance original del prototipo: las mejoras, cinco oleadas y progresión temporal pertenecen al hito 2; cooperación completa y teléfono real, al hito 3.

## 5. Pruebas y decisión de continuidad

### Aceptación técnica

- Completar partidas solo y con 2–4 clientes; comprobar victoria, derrota y reinicio.
- Verificar muerte, entrada tardía, desconexión y salida de todos los jugadores.
- Confirmar daño, cadencia, recompensas, costos, límites y reparaciones simultáneas.
- Intentar compras repetidas, identificadores inválidos y solicitudes fuera de fase; ninguna concede beneficios indebidos.
- Ejecutar tres partidas seguidas sin errores de scripts ni acumulación de enemigos.
- Comprobar controles y legibilidad en emulador, teléfono real y PC.
- Objetivo de al menos 30 FPS sostenidos en el teléfono de prueba con la carga máxima; registrar modelo y calidad gráfica.
- Probar latencia simulada para detectar desincronización y compras duplicadas. Studio dispone de [simulación multicliente, dispositivos y red](https://create.roblox.com/docs/studio/testing-modes).

### Validación con personas

Primero realizar cinco sesiones observadas y corregir bloqueos; después ampliar hasta **20 participantes únicos**, incluyendo al menos cinco usuarios móviles.

Registrar manualmente por participante comprensión del objetivo, tiempo jugado, oleada alcanzada, repetición y principal dificultad. Los registros técnicos complementarán estas observaciones; no se construirá un backend de analítica.

**Umbrales internos para avanzar:**

- Al menos 16 de 20 entienden el objetivo antes de 30 segundos sin explicación verbal.
- Al menos 12 de 20 comienzan voluntariamente una segunda partida.
- Mediana de sesión de al menos ocho minutos.
- Ningún bloqueo técnico pendiente en combate, compras, reinicio o controles.

Son criterios exploratorios, no referencias del mercado ni evidencia de rentabilidad. Si no se cumplen, hacer una iteración centrada en la mayor causa de abandono y repetir la prueba. Si se cumplen, planear el MVP con persistencia y más progresión; la monetización tendrá su propia validación.
