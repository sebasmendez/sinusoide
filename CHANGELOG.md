# Changelog - SinusoideApp

## v1.3.1
Rediseño Home como Dashboard hub + Límite historial 10 registros

- **[UI] Home rediseñada:** Dashboard hub que reemplaza completamente el BottomNavigationBar redundante.
  - Eliminado: `NavBar` y navegación por tabs
  - Home es la pantalla raíz con 3 botones grandes para acceder a funciones
  - Logo empresa prominente + Título + 3 botones de acción
  - Navegación con `Navigator.push` → botón "atrás" automático en pantallas secundarias

- **[NAV] Estructura sin BottomNav:**
  - Botón "NUEVO CÁLCULO" (naranja, full width 56px) → Montajes
  - Botón "HISTORIAL" (verde, 50% ancho 56px) → Historial
  - Botón "VUÓMETRO" (azul, 50% ancho 56px) → Vibración
  - Cada pantalla secundaria tiene AppBar propio con botón "atrás" automático

- **[DB] Límite de 10 registros en historial:**
  - `guardarCalculo()` ahora mantiene solo los últimos 10 cálculos
  - El 11º registro automáticamente sobrescribe el más viejo
  - Implementado en `db_helper.dart` con limpieza automática en cada insert

- **[REMOVED] Eliminado redundancia:**
  - BottomNavigationBar completamente removido
  - NavBar StatefulWidget removido
  - Callbacks de navegación por tabs removidos
  - Home es ahora StatelessWidget simple

**Beneficios:** Home tiene sentido como hub real, elimina redundancia de navegación, interfaz más limpia y moderna. Marketing visible con logo prominente.

## v1.3.0
Medidor de vibraciones con VU meter

- **[FEAT] Nueva pestaña "Vibración":** medidor de nivel de audio en tiempo real (dBFS)
  - Captura la señal del sensor de vibraciones conectado al jack de audio (3.5mm) o vía USB/Bluetooth
  - Stream en vivo de amplitud desde el micrófono del dispositivo

- **[UI] VU Meter visual:**
  - Barra horizontal con gradiente de colores: verde (-60 a -18 dBFS) → amarillo (-18 a -6 dBFS) → rojo (-6 a 0 dBFS)
  - Valor numérico grande (64px) mostrando dBFS actual
  - Indicador de pico (máximo detectado desde el inicio)
  - Estadísticas: mínimo, promedio, máximo desde que se inició la medición

- **[UI] Controles:**
  - Botón "Iniciar/Detener" 56px full width (verde al detener, rojo al medir)
  - Card instructiva: "Conectá el sensor al jack de audio antes de iniciar"
  - Indicador de estado (punto verde si está capturando)

- **[PERMS] Permisos de micrófono:**
  - Android: `RECORD_AUDIO` en `AndroidManifest.xml`
  - iOS: `NSMicrophoneUsageDescription` en `Info.plist`
  - Solicitud en tiempo de ejecución via `permission_handler`

- **[DEPS] Packages nuevos:**
  - `noise_meter: ^5.1.0` — captura de niveles dB en tiempo real
  - `permission_handler: ^12.0.0` — gestión de permisos de micrófono en Android/iOS

- **[NAV] Nuevo item en BottomNavigationBar:**
  - 4ta pestaña "Vibración" con ícono `Icons.graphic_eq`
  - Navegación extendida a 4 opciones (Home, Montajes, Historial, Vibración)

**Caso de uso:** El técnico conecta un sensor de vibraciones (acelerómetro/velocímetro) al jack de audio del celular. En lugar de escuchar subjetivamente la amplitud (dependiendo del oído, ruido ambiente, calidad del auricular), ve la medición objetiva en dBFS. Permite comparar niveles entre diferentes ejes de rotores y detectar anomalías de vibración.

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
