#!/usr/bin/env bash

set -euo pipefail

VERSION=$(<version.txt)

TARGET_DIR="/mnt/c/Windows/Temp/v${VERSION}"

APPDIR="build/AppDir"

echo "linux-update AppImage builder"
echo "Version: $VERSION"

rm -rf build

mkdir -p "$TARGET_DIR"

###############################################################################
# AppDir structure
###############################################################################

mkdir -p "$APPDIR/usr/bin"

mkdir -p "$APPDIR/usr/lib/linux-update"

###############################################################################
# Main executable
###############################################################################

cp src/linux-update \
   "$APPDIR/usr/bin/linux-update"

###############################################################################
# Runtime modules
###############################################################################

cp src/system/*.sh \
   "$APPDIR/usr/lib/linux-update/"

cp src/commands/*.sh \
   "$APPDIR/usr/lib/linux-update/"

cp version.txt \
   "$APPDIR/usr/lib/linux-update/"

###############################################################################
# AppRun
###############################################################################

cat > "$APPDIR/AppRun" << 'EOF'
#!/bin/sh

HERE="$(dirname "$(readlink -f "$0")")"

export PATH="$HERE/usr/bin:$PATH"

exec "$HERE/usr/bin/linux-update" "$@"
EOF

chmod +x "$APPDIR/AppRun"

###############################################################################
# Desktop file
###############################################################################

cat > "$APPDIR/linux-update.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=linux-update
Exec=linux-update
Terminal=true
Categories=System;
EOF

###############################################################################
# Placeholder icon
###############################################################################

touch "$APPDIR/linux-update.png"

###############################################################################
# Build AppImage
###############################################################################

APPIMAGETOOL="release/tools/appimagetool-x86_64.AppImage"

chmod +x "$APPIMAGETOOL"

ARCH=x86_64 \
"$APPIMAGETOOL" \
    "$APPDIR" \
    "$TARGET_DIR/linux-update-${VERSION}-x86_64.AppImage"

echo
echo "Created:"
echo "$TARGET_DIR/linux-update-${VERSION}-x86_64.AppImage"

# rm -rf build