# SinusoideApp

## Descripcion del proyecto

App movil (Flutter/Dart) para facilitar la busqueda de datos en tablas de doble entrada
usadas en montajes mecanicos industriales. Reemplaza la consulta manual de planillas Excel.

## Objetivo principal

El usuario ingresa parametros de un montaje (equipo, rodamiento, etc.) y la app busca
los valores correspondientes en tablas precargadas, mostrando los resultados.

NO es una app de calculo: es una app de consulta/lookup en tablas.

## Estado actual (v1.0.x)

- Frontend Flutter con navegacion de 3 pestanas (Home, Montajes, Historial)
- Formulario de entrada con 6 campos: EQUIPO, CAJA PORT, SELLOS, MANGUITO, TIPO, RODAMIENTO
- Pantalla de resultados muestra los valores ingresados
- Historial persistido en SQLite (guarda automaticamente cada calculo)
- Exportacion via share nativo del celular (WhatsApp, email, etc.)
- Build compilado y probado en Android fisico

## Stack

- Flutter 3.41.5 / Dart >=3.0.3
- SQLite (sqflite 2.4.2) para persistencia local
- share_plus para exportacion nativa
- intl para formato de fechas
- Plataformas objetivo: Android (probado), iOS (pendiente infraestructura Apple)

## Estructura

```
sinusoide/
  CLAUDE.md              # Este archivo
  RELEASES.md            # Changelog de versiones
  build_release.sh       # Script para compilar y versionar APK
  releases/              # APKs generados (no se suben a git)
  sinusoide_app/         # Proyecto Flutter
    lib/
      main.dart          # Entry point, navegacion
      montajes.dart      # Formulario de entrada
      calculo.dart       # Pantalla de resultados (+ guardar + exportar)
      historial.dart     # Historial desde SQLite (+ borrar entradas)
      db_helper.dart     # Capa de acceso a SQLite
    assets/
      imagenes/          # Logo y recursos graficos
    pubspec.yaml         # Dependencias
    android/             # Config Android (Gradle 8.9, AGP 8.7, Kotlin 2.1)
```

## Versionado de APK

Usar el script `build_release.sh` para generar cada nueva version:
```bash
./build_release.sh          # incrementa build number y compila
./build_release.sh minor    # sube version minor (1.0 -> 1.1)
./build_release.sh major    # sube version major (1.x -> 2.0)
```
Los APKs quedan en `releases/sinusoide-vX.Y.Z+N.apk`. Se conservan los ultimos 5.

## Pendiente

- [ ] Recibir planilla Excel con tablas de doble entrada
- [ ] Definir estructura de datos a partir de las tablas
- [ ] Implementar logica de busqueda/lookup en las tablas
- [ ] Reemplazar campos de texto libre por selectores basados en las tablas
- [ ] Mostrar valores calculados reales en pantalla de resultados
- [ ] iOS: configurar build en Codemagic o Mac
