# Releases - SinusoideApp

Ver **[CHANGELOG.md](CHANGELOG.md)** para historial detallado de cambios por versión.

## Versiones disponibles

| Versión | Fecha | Archivo APK | Estado |
|---------|-------|------------|--------|
| v1.2.0+2 | 2026-03-26 | `sinusoide-v1.2.0+2.apk` (55.5 MB) | ✅ Compilado |
| v1.1.0+7 | 2026-03-25 | `sinusoide-v1.1.0+7.apk` | ✅ Compilado |
| v1.0.1 | 2026-03-25 | — | ✅ Compilado |
| v1.0.0 | 2026-03-25 | — | ✅ Compilado |

## Compilar nueva versión

```bash
./build_release.sh                # incrementa build number
./build_release.sh minor          # sube version minor (1.2 → 1.3)
./build_release.sh major          # sube version major (1.x → 2.0)
```

Los APKs se guardan en `releases/` (últimos 5 conservados).

## Links útiles

- **CHANGELOG.md** — historial detallado de cambios
- **CLAUDE.md** — descripción del proyecto, arquitectura, estructura de archivos
- **pubspec.yaml** — dependencias y versión actual
