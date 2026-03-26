#!/bin/bash
set -e

PUBSPEC="sinusoide_app/pubspec.yaml"
RELEASES_DIR="releases"
KEEP_LAST=5

# Leer version actual (formato: X.Y.Z+N)
CURRENT=$(grep '^version:' "$PUBSPEC" | awk '{print $2}')
VERSION=$(echo "$CURRENT" | cut -d'+' -f1)
BUILD=$(echo "$CURRENT" | cut -d'+' -f2)

MAJOR=$(echo "$VERSION" | cut -d'.' -f1)
MINOR=$(echo "$VERSION" | cut -d'.' -f2)
PATCH=$(echo "$VERSION" | cut -d'.' -f3)

# Subir version segun argumento
case "${1:-build}" in
  major)
    MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1)); PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
  build)
    # Solo sube build number
    ;;
esac

BUILD=$((BUILD + 1))
NEW_VERSION="$MAJOR.$MINOR.$PATCH"
NEW_FULL="$NEW_VERSION+$BUILD"

echo "Compilando version $NEW_FULL..."

# Actualizar pubspec.yaml
sed -i "s/^version: .*/version: $NEW_FULL/" "$PUBSPEC"

# Compilar
export ANDROID_HOME=~/Android
export PATH="$PATH:/snap/bin"
cd sinusoide_app
flutter build apk --release
cd ..

# Copiar APK a releases/
mkdir -p "$RELEASES_DIR"
APK_NAME="sinusoide-v$NEW_VERSION+$BUILD.apk"
cp "sinusoide_app/build/app/outputs/flutter-apk/app-release.apk" "$RELEASES_DIR/$APK_NAME"

echo ""
echo "APK generado: $RELEASES_DIR/$APK_NAME"

# Conservar solo los ultimos N APKs
cd "$RELEASES_DIR"
ls -t sinusoide-v*.apk | tail -n +$((KEEP_LAST + 1)) | xargs -r rm --
cd ..

echo "APKs disponibles:"
ls -lh releases/sinusoide-v*.apk 2>/dev/null || echo "(ninguno)"
