#!/usr/bin/env bash

###############################################################################
# linux-update DEB builder
#
# Source of truth:
#
#   version.txt
#
# Generated:
#
#   build/linux-update_<version>.deb
#
###############################################################################

set -euo pipefail

###############################################################################
# Read version
###############################################################################

VERSION=$(<version.txt)

###############################################################################
# Build paths
###############################################################################

BUILD_DIR="build/linux-update_${VERSION}"

TARGET_DIR="/mnt/c/Windows/Temp/v${VERSION}"

echo "linux-update DEB builder"
echo "Version: $VERSION"

###############################################################################
# Clean previous build
###############################################################################

rm -rf "$BUILD_DIR"

mkdir -p "$TARGET_DIR"

###############################################################################
# Package structure
###############################################################################

mkdir -p "$BUILD_DIR/DEBIAN"

mkdir -p "$BUILD_DIR/usr/bin"

mkdir -p "$BUILD_DIR/usr/lib/linux-update"

mkdir -p "$BUILD_DIR/usr/share/doc/linux-update"

mkdir -p "$BUILD_DIR/usr/share/licenses/linux-update"

###############################################################################
# Generate DEBIAN/control
#
# Automatically replaces:
#
#   Version: x.y.z
#
###############################################################################

sed \
    "s/^Version:.*/Version: $VERSION/" \
    packaging/debian/control \
    > "$BUILD_DIR/DEBIAN/control"

###############################################################################
# Main executable
###############################################################################
cp src/linux-update "$BUILD_DIR/usr/bin/linux-update"
chmod 755  "$BUILD_DIR//usr/bin/linux-update"

cp src/system/*.sh \
   "$BUILD_DIR/usr/lib/linux-update/"

chmod 755 "$BUILD_DIR/usr/lib/linux-update/"

###############################################################################
# Library scripts
###############################################################################

cp src/commands/*.sh \
   "$BUILD_DIR/usr/lib/linux-update/"

###############################################################################
# Runtime version file
###############################################################################

cp \
    version.txt \
    "$BUILD_DIR/usr/lib/linux-update/"

###############################################################################
# Documentation
###############################################################################

cp README.md \
   "$BUILD_DIR/usr/share/doc/linux-update/"

gzip -c CHANGELOG.md \
 > "$BUILD_DIR/usr/share/doc/linux-update/changelog.gz"

cp copyright \
    "$BUILD_DIR/usr/share/doc/linux-update/"

###############################################################################
# License
###############################################################################

cp LICENSE \
    "$BUILD_DIR/usr/share/licenses/linux-update/"

###############################################################################
# md5sums
###############################################################################

(
    cd "$BUILD_DIR"

    find usr -type f \
        -exec md5sum {} \; \
        > DEBIAN/md5sums
)

###############################################################################
# Build package
###############################################################################

dpkg-deb --build "$BUILD_DIR"

###############################################################################
# Export package
###############################################################################

cp \
    build/*.deb \
    "$TARGET_DIR/"

echo
echo "Package exported to:"
echo "$TARGET_DIR"

###############################################################################
# Cleanup
###############################################################################

rm -rf build

echo
echo "DEB build completed successfully"s