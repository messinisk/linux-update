#!/usr/bin/env bash

set -euo pipefail

# 1. Βρίσκει αυτόματα τη ρίζα του repository
# shellcheck disable=SC2128
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 2. Μεταφέρεται στη ρίζα του repo
cd "$REPO_ROOT"

# Ανάγνωση της έκδοσης
VERSION=$(<version.txt)

echo "Building RPM package version: $VERSION"

RPM_ROOT="build/rpm"

# Καθαρισμός και δημιουργία δομής RPM
rm -rf "$RPM_ROOT"
mkdir -p "$RPM_ROOT"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Δημιουργία προσωρινού φακέλου για το tarball
TMP_DIR=$(mktemp -d)

# Σωστή αντιγραφή ΟΛΩΝ των αρχείων (και του version.txt) εξαιρώντας ΜΟΝΟ το build/
rsync -a --exclude='/build' ./ "$TMP_DIR/linux-update-$VERSION/"

# Δημιουργία του Source Tarball
tar czf \
  "$RPM_ROOT/SOURCES/linux-update-$VERSION.tar.gz" \
  -C "$TMP_DIR" \
  "linux-update-$VERSION"

# Καθαρισμός προσωρινού φακέλου
rm -rf "$TMP_DIR"

# Αντιγραφή του SPEC αρχείου
cp packaging/rpm/linux-update.spec "$RPM_ROOT/SPECS/"

echo "Running rpmbuild..."

# Εκτέλεση του rpmbuild
rpmbuild \
    --define "_topdir $REPO_ROOT/$RPM_ROOT" \
    -ba \
    "$RPM_ROOT/SPECS/linux-update.spec"

TARGET_DIR="/mnt/c/Windows/Temp"

# Αντιγραφή των τελικών RPM αρχείων στο Windows Temp
find "$RPM_ROOT/RPMS" -name "*.rpm" -exec cp {} "$TARGET_DIR/" \;

echo
echo "RPM packages created successfully:"
ls -l "$TARGET_DIR"/*.rpm
#rm -rf build
