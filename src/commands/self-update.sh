#!/usr/bin/env bash


# shellcheck disable=SC2012
set -euo pipefail
TMPDIR=""

cleanup() {
    rm -rf "$TMPDIR"
}


rollback_deb() {

    echo
    echo "Rolling back DEB package..."

    if [ ! -f "$TMPDIR/backup/current.deb" ]
    then
        echo "ERROR: No backup package available."
        return 1
    fi

    sudo dpkg -i "$TMPDIR/backup/current.deb"

    return 1
}

rollback_rpm() {

    echo
    echo "Rolling back RPM package..."

    if [ ! -f "$TMPDIR/backup/current.rpm" ]
    then
        echo "ERROR: No backup package available."
        return 1
    fi

    sudo rpm \
         -Uvh \
         --oldpackage \
         "$TMPDIR/backup/current.rpm"

    return 1
}


run_self_update() {
    local REPO
    local CURRENT_VERSION
    local LATEST_VERSION
    local BASE_URL
    local PACKAGE
    local BACKUP_FILE
    local NEW_VERSION

    REPO="messinisk/linux-update"

    TMPDIR=$(mktemp -d)

    trap cleanup RETURN


    ###############################################################################
    # Read current version
    ###############################################################################

    CURRENT_VERSION=$(< "$PROJECT_ROOT/version.txt")

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
    # Version checks
    ###############################################################################

    if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]
    then
        echo "Already up to date."
        return  0
    fi

    if [ "$CURRENT_VERSION" \> "$LATEST_VERSION" ]
    then
        echo
        echo "Installed version is newer than the latest release."
        echo "Self-update aborted."
        return  0
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
        return 1

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

        echo "Creating package backup..."

        dpkg-repack linux-update


        BACKUP_FILE=$(ls linux-update*.deb 2>/dev/null | head -n1)

        if [ -n "$BACKUP_FILE" ]
        then
            mv "$BACKUP_FILE" \
                "$TMPDIR/backup/current.deb"
        else
            echo "WARNING: Backup package not generated."
        fi

    else

        echo "WARNING: dpkg-repack not installed"
        echo "Rollback will not be available"

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

    local NEW_VERSION
    NEW_VERSION=$(< "$PROJECT_ROOT/version.txt")

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
    return 0
}