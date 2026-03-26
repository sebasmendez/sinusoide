# SinusoideApp

## Descripcion del proyecto

App movil (Flutter/Dart) para facilitar la busqueda de datos en tablas de doble entrada
usadas en montajes mecanicos industriales. Reemplaza la consulta manual de planillas Excel.

## Objetivo principal

El usuario ingresa parametros de un montaje (equipo, rodamiento, etc.) y la app busca
los valores correspondientes en tablas precargadas, mostrando los resultados.

NO es una app de calculo: es una app de consulta/lookup en tablas.

## Estado actual

- Existe un frontend Flutter basico con navegacion de 3 pestanas (Home, Montajes, Historial)
- La logica de negocio (busqueda en tablas) NO esta implementada
- Los datos de las tablas aun no estan cargados
- Se necesita recibir la planilla Excel con las tablas de doble entrada para definir
  la estructura de datos

## Stack

- Flutter (Dart >=3.0.3)
- SQLite (sqflite) para persistencia local
- Plataformas: Android, iOS, Web, Desktop

## Estructura

```
sinusoide/
  CLAUDE.md              # Este archivo
  sinusoide_app/         # Proyecto Flutter
    lib/
      main.dart          # Entry point, navegacion
      montajes.dart      # Formulario de entrada
      calculo.dart       # Pantalla de resultados
      historial.dart     # Historial de consultas
    assets/              # Imagenes y datos
    pubspec.yaml         # Dependencias
```

## Pendiente

- [ ] Recibir planilla Excel con tablas de doble entrada
- [ ] Definir estructura de datos a partir de las tablas
- [ ] Repensar la app como herramienta de consulta (no de calculo)
- [ ] Implementar logica de busqueda/lookup
- [ ] Persistencia de historial en SQLite
