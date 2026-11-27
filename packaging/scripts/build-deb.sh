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

TARGET_DIR="${TARGET_DIR:-dist/v${VERSION}}"
mkdir -p "$TARGET_DIR"

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
  "s/@VERSION@/$VERSION/g" \
  packaging/debian/control.in \
  > build/debian/control

###############################################################################
# Install runtime tree
###############################################################################

# shellcheck disable=SC1091
source packaging/scripts/install-tree.sh

install_tree "$BUILD_DIR"
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
#  Validate package contents
###############################################################################
required_files=(
    "$BUILD_DIR/usr/bin/linux-update"
    "$BUILD_DIR/usr/lib/linux-update/menu.sh"
    "$BUILD_DIR/usr/lib/linux-update/osdetect.sh"
    "$BUILD_DIR/usr/lib/linux-update/self-update.sh"
    "$BUILD_DIR/usr/lib/linux-update/version.txt"
)

for file in "${required_files[@]}"
do
    if [ ! -f "$file" ]
    then
        echo "Missing required file: $file"
        exit 1
    fi
done

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

# rm -rf build

echo
echo "DEB build completed successfully"s