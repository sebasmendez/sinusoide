# Changelog - SinusoideApp

## v1.2.1
Campos de diámetro del eje (Acople y Rodete)

- **[FORM] Campos de diámetro del eje:** dos nuevos campos en sección "DATOS DEL RODAMIENTO"
  - Diámetro Lado Acople (mm)
  - Diámetro Lado Rodete (mm)
  - Ubicados entre "Clase de juego" y "Galgeos"
  - Validación: números positivos obligatorios

- **[FEAT] Soporte para rodamientos diferentes en cada lado:**
  - Cada lado puede tener diámetro distinto
  - Permite equipos con configuraciones asimétricas
  - Cálculos independientes por lado

- **[LOGIC] Cambio en función calcularMontaje():**
  - Anterior: `calcularMontaje(rodamiento, clase, galgeo)` — calculaba diámetro automáticamente
  - Nuevo: `calcularMontaje(diametro, clase, galgeo)` — acepta diámetro como parámetro
  - El usuario ingresa explícitamente el diámetro en lugar de derivarlo del rodamiento

- **[UX] Interfaz:** Layout con dos columnas lado a lado, área táctil amplia para ambiente con guantes.

## v1.2.0
Mejoras UX para ambiente industrial

- **[UI] Clase de juego:** reemplazado `DropdownButtonFormField` por `SegmentedButton<String>` con 5 opciones visibles (C2, NORMAL, C3, C4, C5). Un tap, área táctil grande, estado visual inmediato — optimizado para guantes en campo.
- **[UI] Botón Calcular:** ahora `SizedBox(width: double.infinity, height: 56px)` con color naranja destacado (`Colors.orange.shade700`). Full width, prominente, fácil de tocar con guantes.
- **[UI] Jerarquía visual:** campos críticos (rodamiento, clase de juego, galgeos) en `Card` azul con borde resaltado; datos opcionales del equipo en `Card` gris — deja claro qué parámetros determinan el cálculo.
- **[UI] Tamaño de fuentes:** aumentadas en tabla de resultados de `fontSize: 11` → `13` para mejor legibilidad en condiciones de campo (sol, distancia, lentes).
- **[UI] Ajuste final:** sacado de la tabla → sección independiente `Card` amarilla con dos campos etiquetados (Lado Acople / Lado Rodete) en `Row` con hints de ejemplo.
- **[UI] Botones de acción:** reordenados por importancia en pantalla de resultados:
  - PDF: `ElevatedButton` full width 56px verde (`Colors.green.shade700`) — acción principal
  - Guardar: `OutlinedButton` full width 48px — secundaria
  - Volver: `TextButton` — navegación

- **[NAV] Home mejorada:** agregado botón **"NUEVO CÁLCULO"** (56px naranja, full width) que navega directo al formulario. Acceso inmediato sin confusión.

## v1.1.0
Tablas de datos SKF + cálculo real + exportación PDF

- **[DATA] Tablas SKF precargadas:**
  - Tabla 1 (DATOS SKF SIN MONTAR): juego radial interno por rango de diámetro + clase de juego (C2/NORMAL/C3/C4/C5) en micrones
  - Tabla 2 (REDUCCIÓN DEL JUEGO): reducción del juego radial MIN/MAX (mm) por rango de diámetro
  - Fuente: `tablas.dart` con datos de manual SKF

- **[CALC] Lógica de búsqueda:** búsqueda automática en Tabla 1 (por rango diámetro + clase) y Tabla 2 (por rango diámetro). Cálculo del juego residual por lado: `juego_min = galgeo - reduccion_max`, `juego_max = galgeo - reduccion_min`
  - Verificado contra informe real: Rod. 22217 NORMAL, galgeo 0.09 → juego (0.040 - 0.050) ✓

- **[PDF] Exportación profesional:** generación de PDF con tabla de dos columnas (Lado Acople / Lado Rodete), datos del equipo completos, referencias de cálculo. Exportable vía share nativo (WhatsApp, email, Gmail, etc.)
  - Stack: `pdf` package + `printing` para visualización

- **[DB] Persistencia v3:** esquema de SQLite actualizado para soportar dos lados (Acople/Rodete) con `juego_min/max` y `ajuste_final` por lado. Guardado automático en cada cálculo.

- **[UI] Pantalla de resultados:** tabla clara con 4 filas (Referencia SKF, Reducción, Cálculo del juego, Ajuste final), dos columnas (Lado Acople / Lado Rodete).

## v1.0.1
Persistencia + Historial + Exportación

- **[DB] SQLite (sqflite):** historial persistido automáticamente en cada cálculo. Tabla `calculos` con campos: equipo, rodamiento, clase, galgeos, timestamp.

- **[UI] Pantalla Historial:** listado de cálculos guardados con detalles expandibles, posibilidad de borrar entradas con confirmación.

- **[EXPORT] Share nativo:** exportación vía `share_plus` — WhatsApp, email, SMS, etc. directamente desde la app.

- **[UI] Pantalla de resultados:** visualización de todos los datos ingresados + tabla de resultado.

## v1.0.0
Primera versión compilada y funcional

- **[NAV] Navegación:** bottom nav bar con 3 pestañas (Home, Montajes, Historial).
  - Home: logo Sinusoide + título "MONTAJE DE RODAMIENTOS"
  - Montajes: formulario de entrada
  - Historial: registros guardados

- **[FORM] Formulario inicial:**
  - 6 campos de texto: Equipo, TAG, Eje, Rodamiento, Clase de juego, Galgeo
  - Validación básica (rodamiento obligatorio y numérico)

- **[BUILD] Compilación Android:** APK generado y probado en dispositivo físico (Gradle 8.9, AGP 8.7, Kotlin 2.1).

- **[DEPS] Stack base:** Flutter 3.41.5, Dart >=3.0.3, intl para fechas.
