# ADR 0001 — Estudio local con especialistas bajo demanda

Fecha: 2026-09-15. Estado: adoptado para la base inicial.

Se usan Rojo y Git para reconstruir el lugar; MCP opera Studio y obtiene evidencia. Se evita tener dos sincronizadores escribiendo el mismo árbol. Un coordinador integra y mantiene el backlog, con hasta tres especialistas simultáneos y un único operador de Studio.

Los roles son instrucciones propias basadas en las necesidades del proyecto. Agency Agents sirve como referencia de especialización y no se copia como dependencia. No se añaden frameworks de gameplay antes de tener una necesidad concreta. El TestEZ original no forma parte de esta base.

La implementación local y sus correcciones están autorizadas. El propietario decide el concepto, gastos y publicación pública. Las comprobaciones locales no publican ni crean infraestructura remota.

Consecuencia: el trabajo de código puede ejecutarse en paralelo, pero la integración en Studio se serializa. Cada entrega debe poder reconstruirse desde archivos e identificar qué pruebas realmente se ejecutaron.
