#!/usr/bin/env bash

###############################################################################
# linux-update self updater
#
# Performs:
#
#   1. Discover latest stable release
#   2. Download release metadata
#   3. Verify GPG signature
#   4. Verify package checksum
#   5. Backup current package
#   6. Install update
#   7. Rollback on failure
#
###############################################################################

set -euo pipefail

###############################################################################
# Configuration
###############################################################################

REPO="messinisk/linux-update"

TMPDIR=$(mktemp -d)

cleanup() {
    rm -rf "$TMPDIR"
}

trap cleanup EXIT

###############################################################################
# Read current version
###############################################################################

###############################################################################
# Read current version (Dynamic detection for System or AppImage)
###############################################################################

if [ -n "${APPIMAGE+x}" ] && [ -d "$APPDIR" ]; then
    # Αν τρέχει μέσα από το AppImage
    CURRENT_VERSION=$(< "$APPDIR/usr/lib/linux-update/version.txt")
else
    # Αν τρέχει ως κανονική εγκατάσταση στο σύστημα
    CURRENT_VERSION=$(< /usr/lib/linux-update/version.txt)
fi


echo "Current version: $CURRENT_VERSION"

###############################################################################
# Discover latest stable GitHub release
###############################################################################

LATEST_VERSION=$(
curl -fsSL \
"https://api.github.com/repos/${REPO}/releases/latest" \
| grep '"tag_name"' \
| cut -d '"' -f4 \
| sed 's/^v//'
)

echo "Latest version:  $LATEST_VERSION"

###############################################################################
# Already up-to-date
###############################################################################

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]
then
    echo "Already up to date."
    exit 0
fi

###############################################################################
# Release URL
###############################################################################

BASE_URL="https://github.com/${REPO}/releases/download/v${LATEST_VERSION}"

###############################################################################
# Download verification files
###############################################################################

curl -fsSL \
"$BASE_URL/public.key" \
-o "$TMPDIR/public.key"

curl -fsSL \
"$BASE_URL/SHA256SUMS" \
-o "$TMPDIR/SHA256SUMS"

curl -fsSL \
"$BASE_URL/SHA256SUMS.asc" \
-o "$TMPDIR/SHA256SUMS.asc"

###############################################################################
# Verify Release Signature
###############################################################################

gpg --import "$TMPDIR/public.key" >/dev/null 2>&1

gpg \
    --verify \
    "$TMPDIR/SHA256SUMS.asc" \
    "$TMPDIR/SHA256SUMS"

echo "Release signature OK"

###############################################################################
# Detect package manager
###############################################################################

if command -v apt >/dev/null 2>&1
then

    PACKAGE="linux-update_${LATEST_VERSION}.deb"

elif command -v dnf >/dev/null 2>&1 \
   || command -v rpm >/dev/null 2>&1
then

    PACKAGE="linux-update-${LATEST_VERSION}-1.noarch.rpm"

elif command -v zypper >/dev/null 2>&1
then

    PACKAGE="linux-update-${LATEST_VERSION}-1.noarch.rpm"

else

    echo "Unsupported distribution"
    exit 1

fi

###############################################################################
# Download package
###############################################################################

curl -fsSL \
"$BASE_URL/$PACKAGE" \
-o "$TMPDIR/$PACKAGE"

###############################################################################
# Verify checksum
###############################################################################
(
    cd "$TMPDIR"

    # Χρησιμοποιούμε το $PACKAGE που περιέχει ήδη το σωστό όνομα αρχείου 
    # (.deb ή .rpm) ανάλογα με τη διανομή του χρήστη.
    grep "$PACKAGE" SHA256SUMS | sha256sum -c -
)

echo "Checksum OK"


###############################################################################
# Rollback helpers
###############################################################################

rollback_deb() {

    echo
    echo "Rolling back DEB package..."

    sudo dpkg -i "$TMPDIR/backup/current.deb"

    exit 1
}

rollback_rpm() {

    echo
    echo "Rolling back RPM package..."

    sudo rpm \
         -Uvh \
         --oldpackage \
         "$TMPDIR/backup/current.rpm"

    exit 1
}

###############################################################################
# Create backup
###############################################################################

mkdir -p "$TMPDIR/backup"

###############################################################################
# Install DEB
###############################################################################

if [[ "$PACKAGE" == *.deb ]]
then

    echo "Creating backup..."

    if command -v dpkg-repack >/dev/null 2>&1
    then

        dpkg-repack linux-update

        mv linux-update*.deb \
           "$TMPDIR/backup/current.deb"

    fi

    echo "Installing update..."

    if ! sudo dpkg -i "$TMPDIR/$PACKAGE"
    then
        rollback_deb
    fi

###############################################################################
# Install RPM
###############################################################################

else

    echo "Installing update..."

    if ! sudo rpm -Uvh "$TMPDIR/$PACKAGE"
    then
        rollback_rpm
    fi

fi

###############################################################################
# Final verification
###############################################################################

NEW_VERSION=$(< /usr/lib/linux-update/version.txt)

if [ "$NEW_VERSION" != "$LATEST_VERSION" ]
then

    echo "Version verification failed."

    if [[ "$PACKAGE" == *.deb ]]
    then
        rollback_deb
    else
        rollback_rpm
    fi

fi

###############################################################################
# Success
###############################################################################

echo
echo "Update successful."
echo "Running version: $NEW_VERSION"