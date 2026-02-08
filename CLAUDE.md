# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**sinusoide_app** is a Flutter application for equipment assembly calculations (montajes de equipos). It targets all platforms (Android, iOS, Web, macOS, Windows, Linux). The project is in early development — calculation logic uses placeholder values, history uses mock data, and SQLite is configured but not yet integrated into the UI.

## Development Commands

All commands should be run from the `sinusoide_app/` directory.

```bash
# Install dependencies
flutter pub get

# Run the app (debug)
flutter run
flutter run -d chrome          # Run on web/Chrome

# Analyze/lint code
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test
flutter test test/widget_test.dart   # Run a single test file

# Build
flutter build apk             # Android
flutter build web              # Web
flutter build ios              # iOS
```

## Architecture

The app uses a simple Material Design structure with bottom navigation (no state management library — just StatefulWidgets).

**Navigation flow:**
- `NavBar` (in `main.dart`) — shell widget with `BottomNavigationBar` managing 3 tabs
- Tab 0: `HomePage` — splash screen with SINUSOIDE logo
- Tab 1: `MontajesPage` (`montajes.dart`) — form with 6 text inputs (Equipo, Caja Port, Sellos, Manguito, Tipo, Rodamiento) → navigates to `pantallaResultado`
- Tab 2: `HistorialPage` (`historial.dart`) — ListView of past calculations (currently mock data)

**Results page:** `pantallaResultado` (`calculo.dart`) — displays 5 calculation sections (Galgeo, Referencia, Reducción de Juego Radial, Cálculo del Juego, Ajuste Final), each with L Rodete and L Acople values. Currently shows hardcoded placeholder values.

**Database:** `sqflite` (mobile) and `sqflite_common_ffi` (desktop) are declared as dependencies but not yet wired into the UI.

## Key Conventions

- Language in code and UI: Spanish
- Linting: uses `package:flutter_lints/flutter.yaml` (configured in `analysis_options.yaml`)
- SDK constraint: Dart >=3.0.3 <4.0.0, Flutter >=3.3.0
- Android namespace: `com.example.sinusoide_app`
