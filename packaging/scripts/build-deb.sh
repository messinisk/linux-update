#!/usr/bin/env bash

set -euo pipefail

VERSION=$(<version.txt)

BUILD_DIR="build/linux-update_${VERSION}"
TARGET_DIR="/mnt/c/Windows/Temp"

rm -rf "$BUILD_DIR"

mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/usr/bin"
mkdir -p "$BUILD_DIR/usr/lib/"
mkdir -p "$BUILD_DIR/usr/share/doc/linux-update"
mkdir -p "$BUILD_DIR/usr/share/licenses/linux-update"
cp packaging/debian/control  "$BUILD_DIR/DEBIAN/control"
cp bin/linux-update "$BUILD_DIR/usr/bin/"
cp lib/*.sh   "$BUILD_DIR/usr/lib/"
cp version.txt "$BUILD_DIR/usr/"
cp share/doc/linux-update/*.* "$BUILD_DIR/usr/share/doc/linux-update"
cp share/doc/linux-update/copyright "$BUILD_DIR/usr/share/doc/linux-update"
cp share/licenses/linux-update/LICENSE  "$BUILD_DIR/usr/share/licenses/linux-update"
(
    cd "$BUILD_DIR"
    find usr -type f -exec md5sum {} \; > DEBIAN/md5sums
)
dpkg-deb --build "$BUILD_DIR"
cp build/*.deb  "$TARGET_DIR/"
echo "$TARGET_DIR/"
rm -rf build