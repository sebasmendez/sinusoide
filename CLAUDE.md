# SinusoideApp

## Descripcion del proyecto

App movil (Flutter/Dart) para facilitar la busqueda de datos en tablas de doble entrada
usadas en montajes mecanicos industriales. Reemplaza la consulta manual de planillas Excel.

## Objetivo principal

El usuario ingresa parametros de un montaje (rodamiento, clase de juego, galgeo medido)
y la app busca los valores correspondientes en tablas SKF precargadas, mostrando los resultados
para ambos lados del rodamiento (Lado Acople y Lado Rodete).

NO es una app de calculo: es una app de consulta/lookup en tablas.

## Flujo de la app

1. Usuario ingresa: numero de rodamiento + clase de juego (C2/Normal/C3/C4/C5)
2. Ingresa galgeo medido para Lado Acople y Lado Rodete por separado
3. Se calcula el diametro del eje: ultimos 2 digitos del rodamiento x 5
4. Tabla 1 (DATOS SKF SIN MONTAR): busca por rango de diametro + clase de juego -> referencia MIN/MAX
5. Tabla 2 (REDUCCION DEL JUEGO): busca por rango de diametro -> reduccion MIN/MAX
6. Juego residual por cada lado:
   - juego_min = galgeo - reduccion_max
   - juego_max = galgeo - reduccion_min
7. Muestra resultados en tabla con dos columnas (Acople / Rodete)
8. El usuario ingresa el ajuste final medido post-montaje
9. Se puede exportar como PDF profesional

## Estado actual (v1.3.1)

### Producción (master)
- **v1.2.0** — Mejoras UX para ambiente industrial
  - Frontend Flutter optimizado para ambiente industrial (tecnico con guantes en campo)
  - Navegacion con BottomNavigationBar: Home, Montajes, Historial
  - Formulario dividido en secciones visuales (Card gris/azul)
  - Clase de juego con SegmentedButton (5 opciones visibles)
  - Boton "Calcular" full-width 56px color naranja
  - Pantalla de resultados con tabla clara
  - Exportacion a PDF profesional
  - Historial persistido en SQLite
  - Build compilado y probado en Android fisico

### En desarrollo (feature/vibracion-vu-meter)
- **v1.3.1** — Rediseño Home como Dashboard hub + Vumetro + Límite historial 10 registros
  - ✅ Home rediseñada como dashboard (sin BottomNav redundante)
    - 3 botones principales: NUEVO CÁLCULO (naranja), HISTORIAL (verde), VUMETRO (azul)
    - Logo empresa prominente + Changelog modal
  - ✅ Medidor de vibraciones (Vumetro) con VU meter visual
    - Barra horizontal con animación suave (80ms)
    - Escala de colores: verde → amarillo → rojo
    - Estadísticas: mínimo, promedio, máximo, pico
    - Captura señal de sensor vía jack de audio (3.5mm) o USB/Bluetooth
  - ✅ Límite de 10 registros en historial (el 11º sobrescribe el más viejo)
  - ✅ Navegación con Navigator.push (botón atrás automático)
  - 🔄 **EN FASE DE PRUEBA:** Pendiente adaptador USB-C para validar Vumetro en equipo real
  - Rama: `feature/vibracion-vu-meter` (sincronizada en GitHub)
  - APK: `sinusoide-v1.3.1+3.apk` (disponible para testing)
  - Web: `http://192.168.88.245:9000` (versión de desarrollo local)

## Stack

- Flutter / Dart >=3.0.3
- SQLite (sqflite) para persistencia local
- share_plus para exportacion nativa
- pdf + printing para generacion de PDF
- path_provider para rutas de archivos
- intl para formato de fechas
- Plataformas objetivo: Android (probado), iOS (pendiente)

## Estructura

```
sinusoide/
  CLAUDE.md              # Este archivo
  RELEASES.md            # Changelog de versiones
  build_release.sh       # Script para compilar y versionar APK
  releases/              # APKs generados (no se suben a git)
  sinusoide_app/         # Proyecto Flutter
    lib/
      main.dart          # Entry point, navegacion, Home con logo
      montajes.dart      # Formulario de entrada (equipo, cajas port, rodamiento, galgeos)
      calculo.dart       # Pantalla de resultados (tabla Acople/Rodete + ajuste final + PDF)
      historial.dart     # Historial desde SQLite (ver, exportar PDF, borrar)
      db_helper.dart     # Capa de acceso a SQLite (v3, dos lados)
      logica.dart        # Logica de busqueda en tablas y calculo de juego residual
      tablas.dart        # Tablas SKF (juego radial + reduccion) como datos Dart
      pdf_service.dart   # Generacion de PDF profesional
    imagenes/            # Logo y recursos graficos
    pubspec.yaml         # Dependencias
    android/             # Config Android
```

## Tablas de datos

### Tabla 1: Juego radial interno (DATOS SKF SIN MONTAR)
- Filas: rango de diametro del agujero (24mm a 1800mm)
- Columnas: clase de juego (C2, Normal, C3, C4, C5) con MIN y MAX en micrones
- Fuente: tablas.dart (variable tabla1)

### Tabla 2: Reduccion del juego residual
- Filas: rango de diametro del agujero (24mm a 1800mm)
- Columnas: reduccion juego radial (MIN/MAX mm)
- Fuente: tablas.dart (variable tabla2)

## Formula del juego residual

```
diametro = (rodamiento % 100) * 5
juego_min = galgeo_medido - reduccion_max
juego_max = galgeo_medido - reduccion_min
```

Verificado contra informe real:
- Rod. 22217, NORMAL, galgeo Acople 0.09 -> juego (0.040 - 0.050) OK
- Rod. 22217, NORMAL, galgeo Rodete 0.08 -> juego (0.030 - 0.040) OK

## Versionado de APK (Semantic Versioning)

### Criterios de versionado: MAJOR.MINOR.PATCH+BUILD

**MAJOR (1.x.x)** — Breaking Changes
- Cambios que rompen compatibilidad o redesign fundamental
- Ejemplo: v1.x → v2.0.0 (nueva arquitectura completa)

**MINOR (1.x.0)** — Nuevas características importantes
- Funcionalidades nuevas que son backward-compatible
- Ejemplos:
  - v1.2.0 → v1.3.0 (agregamos Vumetro — nueva característica)
  - v1.3.0 → v1.4.0 (agregaríamos dark mode — nueva feature)

**PATCH (1.3.x)** — Bug fixes + mejoras menores
- Correcciones de bugs
- Ajustes visuales
- Cambios internos sin impacto en UX
- Nuevos campos en formularios (mejora de entrada de datos)
- Ejemplos:
  - v1.3.0 → v1.3.1 (barra animada Vumetro, nombre corregido)
  - v1.2.0 → v1.2.1 (campos de diámetro del eje)

**BUILD NUMBER (+N)** — Sin cambios de código
- Recompilaciones sin modificaciones
- Auto-incrementado por `./build_release.sh`
- Ejemplo: v1.3.1+1 → v1.3.1+2 → v1.3.1+3

### Matriz de decisión rápida

| Cambio | Tipo | Criterio |
|--------|------|----------|
| Nueva pantalla/feature completa | MINOR | Funcionalidad nueva importante |
| Nuevo sensor/medidor | MINOR | Feature completa e independiente |
| Nuevo campo en formulario | PATCH | Mejora de entrada, no feature nueva |
| Fix de bug visual | PATCH | Corrección de rendering |
| Barra animada/cosmética | PATCH | Mejora de UX, no funcionalidad |
| Corrección de nombre/texto | PATCH | Ajuste menor |
| Recompilación sin cambios | +N | Build number |

**FLUJO OBLIGATORIO para cada versión:**

1. **Editar CHANGELOG.md PRIMERO** con todos los cambios de la versión
   - Agregar sección `## vX.Y.Z` con título descriptivo
   - Listar todos los cambios categorizados ([UI], [NAV], [DB], etc.)
   - Ejemplo: cambios en main.dart, vibracion.dart, etc. VAN en CHANGELOG.md ANTES de compilar

2. **Editar changelog_data.dart** si hay cambios de UI que el usuario debe ver
   - Actualizar `appVersion` al nuevo número
   - Agregar entrada en `changelogData` con los cambios

3. **Hacer commit con los cambios a CHANGELOG.md**
   ```bash
   git add CHANGELOG.md changelog_data.dart
   git commit -m "vX.Y.Z - Descripción de cambios"
   ```

4. **Compilar APK**
   ```bash
   ./build_release.sh          # incrementa build number automáticamente
   ```
   - El `pubspec.yaml` **automáticamente** actualiza version: X.Y.Z+N

5. **Hacer commit final de la compilación**
   ```bash
   git add pubspec.yaml
   git commit -m "Build: vX.Y.Z+N compilada"
   ```

**Resultado:** Una versión vX.Y.Z tiene UNA sola APK compilada (vX.Y.Z+N), que corresponde EXACTAMENTE con las notas en CHANGELOG.md vX.Y.Z.

**NO hacer:**
- ❌ Compilar varias APKs con el mismo número de versión (v1.3.1+2, v1.3.1+3)
- ❌ Cambiar código sin actualizar CHANGELOG.md primero
- ❌ Olvidar sincronizar CHANGELOG.md con changelog_data.dart

## Roadmap y Estado

### v1.3.1 — EN FASE DE PRUEBA (feature/vibracion-vu-meter)
- [ ] Comprar adaptador USB-C para conectar sensor de vibraciones
- [ ] Validar Vumetro con equipo real (Android)
- [ ] Confirmar funcionamiento de barra animada en condiciones reales
- [ ] Testing completo de flujos en ambiente industrial
- **Cuando esté validado:** Crear PR y mergear a master para producción

### v1.4.0 — Próximas mejoras (planificadas)
- [ ] iOS: configurar build en Xcode + testing
- [ ] Darkmode: para ambiente con poca luz en campo
- [ ] Vibracion haptica en errores de validacion
- [ ] Mejoras de UX: splash screen, animaciones de transición
- [ ] Posible: agregar calado axial y angulo de apriete a resultados/PDF

### Branches activas
- `master` — v1.2.1 (producción) — con campos de diámetro del eje
- `feature/vibracion-vu-meter` — v1.3.1 (desarrollo, en testing) — Home dashboard + Vumetro
