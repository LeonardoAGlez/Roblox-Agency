# Preparar un lanzamiento

Esta base no publica automáticamente. Un encargo de lanzamiento produce primero un paquete revisable.

1. Identificar revisión exacta, concepto aprobado y destino propuesto (experiencia y propietario).
2. Ejecutar comprobaciones, construir el lugar normal y verificar que excluye pruebas y utilidades QA.
3. Obtener playtest de la revisión candidata, revisión técnica y lista de limitaciones abiertas.
4. Preparar notas, recursos de la ficha con procedencia, instrucciones de carga y la revisión anterior utilizable para recuperación.
5. Presentar el paquete al propietario. Si no existe autorización vigente para ese destino y publicación, pedirla inmediatamente antes de publicar. Los gastos también requieren una decisión explícita del propietario.
6. Si la publicación está autorizada, realizarla sobre el destino confirmado, registrar el resultado y comprobar el comportamiento publicado. Ante error incierto, consultar estado antes de repetir.

GitHub Actions comprueba archivos y builds al conectar el repositorio a GitHub; pasar CI no prueba el comportamiento dentro de Studio. No crear credenciales, repositorios remotos, compras ni publicación por ejecutar los scripts locales.
