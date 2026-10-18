#!/usr/bin/env bash

set -euo pipefail

VERSION=$(<version.txt)

echo "Building RPM package $VERSION"

RPM_ROOT="build/rpm"

rm -rf "$RPM_ROOT"

mkdir -p "$RPM_ROOT"/BUILD
mkdir -p "$RPM_ROOT"/RPMS
mkdir -p "$RPM_ROOT"/SOURCES
mkdir -p "$RPM_ROOT"/SPECS
mkdir -p "$RPM_ROOT"/SRPMS


TMP_DIR=$(mktemp -d)

cp -r . "$TMP_DIR/linux-update-$VERSION"

tar czf \
"$RPM_ROOT/SOURCES/linux-update-$VERSION.tar.gz" \
-C "$TMP_DIR" \
"linux-update-$VERSION"

rm -rf "$TMP_DIR"

cp packaging/rpm/linux-update.spec \
"$RPM_ROOT/SPECS/"

echo "Running rpmbuild..."

rpmbuild \
    --define "_topdir $(pwd)/$RPM_ROOT" \
    -ba \
    "$RPM_ROOT/SPECS/linux-update.spec"

find "$RPM_ROOT/RPMS" \
    -name "*.rpm" \
    -exec cp {} packaging/dist/ \;

echo
echo "RPM packages:"
ls -l packaging/dist/*.rpm
rm -rf build