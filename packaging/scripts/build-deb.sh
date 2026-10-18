#!/usr/bin/env bash

set -euo pipefail

VERSION=$(<version.txt)

BUILD_DIR="build/linux-update_${VERSION}"

rm -rf "$BUILD_DIR"

mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/usr/bin"
mkdir -p "$BUILD_DIR/usr/lib/linux-update"
cp packaging/debian/control  "$BUILD_DIR/DEBIAN/control"
cp bin/linux-update "$BUILD_DIR/usr/bin/"
cp lib/*.sh   "$BUILD_DIR/usr/lib/linux-update/"
cp version.txt "$BUILD_DIR/usr/lib/linux-update/"
dpkg-deb --build "$BUILD_DIR"
mkdir -p packaging/debian/dist
cp build/*.deb  packaging/dist
rm -rf build