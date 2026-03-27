# Changelog - SinusoideApp

## v1.2.0 (2026-03-26)

### Mejoras UX para ambiente industrial
- **Clase de juego**: reemplazar dropdown por botones segmentados (SegmentedButton) — más rápido y área táctil más grande para guantes
- **Botón Calcular**: ahora full width con altura 56px y color naranja destacado
- **Jerarquía visual**: campos críticos (rodamiento, clase de juego, galgeos) en Card azul con borde resaltado; datos opcionales en Card gris
- **Tamaño de fuentes**: aumentar fontSize en tabla de resultados de 11px → 13px (mejor legibilidad en campo)
- **Ajuste final**: sacado de la tabla → sección independiente con campos claros para Lado Acople y Lado Rodete
- **Botones de acción**: reordenados por importancia — PDF full width verde destacado, Guardar outlined secundario, Volver como TextButton
- **Home**: agregado botón "NUEVO CÁLCULO" para acceso directo al formulario sin navegar manualmente

---

## v1.1.0 (2026-03-25)

### Tablas de datos SKF + PDF profesional
- **Tablas de doble entrada**: Tabla 1 (juego radial interno SKF sin montar), Tabla 2 (reducción del juego radial)
- **Cálculo real**: implementada lógica de búsqueda en tablas + cálculo del juego residual (juego_min/max = galgeo - reduccion)
- **Exportación PDF profesional**: genera informe con tabla de dos columnas (Lado Acople / Lado Rodete), datos del equipo, referencias
- **Ajuste final editable**: campos para ingresa el ajuste medido post-montaje, guardados en base de datos
- **Base de datos v3**: esquema actualizado para soportar dos lados (Acople/Rodete) con juego y ajuste por lado

Verificado contra informes reales (Rod. 22217 NORMAL, galgeo 0.09 → juego 0.040-0.050 ✓)

---

## v1.0.1 (2026-03-25)

### Persistencia + Historial
- Historial persistido en SQLite (guarda automáticamente cada cálculo)
- Exportación via share nativo del celular (WhatsApp, email, Gmail, etc.)
- Pantalla de resultados muestra todos los datos reales ingresados
- Se puede borrar entradas del historial con confirmación
- Visualización expandible del historial con detalles de cada cálculo

---

## v1.0.0 (2026-03-25)

### Primera versión compilada y funcional
- Navegación de 3 pestañas: Home (logo Sinusoide), Montajes (formulario), Historial (registros)
- Formulario con 6 campos iniciales: Equipo, TAG, Eje, Rodamiento, Clase de juego, Galgeos
- Pantalla de resultados básica (tabla simple)
- Compilado y probado en Android físico (APK v1.0.0+2)
