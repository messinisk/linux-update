#!/usr/bin/env bash

set -euo pipefail

VERSION=$(<version.txt)

REPO_DIR="repository"

usage() {
    cat << EOF
Usage:

  $0 stable
  $0 testing

  $0 index stable
  $0 index testing

EOF
}
###############################################################################
# Parse arguments
###############################################################################

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

MODE="build"
CHANNEL=""

case "$1" in

    index)

        MODE="index"

        if [ $# -ne 2 ]; then
            usage
            exit 1
        fi

        CHANNEL="$2"
        ;;

    verify)

        MODE="verify"

        if [ $# -ne 2 ]; then
            usage
            exit 1
        fi

        CHANNEL="$2"
        ;;

    sign)

        MODE="sign"

        if [ $# -ne 2 ]; then
            usage
            exit 1
        fi

        CHANNEL="$2"
        ;;

    stable|testing)

        MODE="build"
        CHANNEL="$1"
        ;;

    *)

        echo "ERROR: Invalid channel: $1"
        exit 1
        ;;

esac

DIST_DIR="dist/v$VERSION"

###############################################################################
# Build repository structure
###############################################################################

build_repository() {

    echo "linux-update repository builder"
    echo "Version : $VERSION"
    echo "Channel : $CHANNEL"

    DEB_FILE="$DIST_DIR/linux-update_${VERSION}.deb"
    RPM_FILE="$DIST_DIR/linux-update-${VERSION}-1.noarch.rpm"
    APPIMAGE_FILE="$DIST_DIR/linux-update-${VERSION}-x86_64.AppImage"

    [ -f "$DEB_FILE" ] || {
        echo "Missing DEB package"
        exit 1
    }

    [ -f "$RPM_FILE" ] || {
        echo "Missing RPM package"
        exit 1
    }

    [ -f "$APPIMAGE_FILE" ] || {
        echo "Missing AppImage package"
        exit 1
    }

    TARGET_DIR="${REPO_DIR:?}/${CHANNEL:?}"

    rm -rf "$TARGET_DIR"

    mkdir -p "$REPO_DIR/$CHANNEL/apt/pool/main"
    mkdir -p "$REPO_DIR/$CHANNEL/rpm"
    mkdir -p "$REPO_DIR/$CHANNEL/appimage"

    cp "$DEB_FILE" \
       "$REPO_DIR/$CHANNEL/apt/pool/main/"

    cp "$RPM_FILE" \
       "$REPO_DIR/$CHANNEL/rpm/"

    cp "$APPIMAGE_FILE" \
       "$REPO_DIR/$CHANNEL/appimage/"

    for artifact in \
        SHA256SUMS \
        SHA256SUMS.asc \
        public.key
    do
        if [ -f "$DIST_DIR/$artifact" ]; then
            cp "$DIST_DIR/$artifact" \
               "$REPO_DIR/$CHANNEL/appimage/"
        fi
    done

    cat > "$REPO_DIR/$CHANNEL/INFO" << EOF
linux-update repository
version=$VERSION
channel=$CHANNEL
generated=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
EOF

    echo
    echo "Repository created:"
    echo

    find "$REPO_DIR/$CHANNEL"
}

###############################################################################
# Generate metadata
###############################################################################

generate_metadata() {

    echo "linux-update repository indexer"
    echo "Channel : $CHANNEL"

    APT_DIR="$REPO_DIR/$CHANNEL/apt"
    RPM_DIR="$REPO_DIR/$CHANNEL/rpm"

    ###########################################################################
    # APT metadata
    ###########################################################################

    if command -v dpkg-scanpackages >/dev/null 2>&1
    then
        echo
        echo "[APT] Generating metadata"

        mkdir -p \
            "$APT_DIR/dists/$CHANNEL/main/binary-amd64"

        dpkg-scanpackages \
            "$APT_DIR/pool" \
            /dev/null \
            > "$APT_DIR/dists/$CHANNEL/main/binary-amd64/Packages"

        gzip -kf \
            "$APT_DIR/dists/$CHANNEL/main/binary-amd64/Packages"

        cat > "$APT_DIR/dists/$CHANNEL/Release" << EOF
Origin: linux-update
Label: linux-update
Suite: $CHANNEL
Codename: $CHANNEL
Architectures: amd64
Components: main
Description: linux-update package repository
EOF

        echo "APT metadata generated"
    else
        echo "WARNING: dpkg-scanpackages not found"
    fi

    ###########################################################################
    # RPM metadata
    ###########################################################################

    if command -v createrepo_c >/dev/null 2>&1
    then
        echo
        echo "[RPM] Generating metadata"

        createrepo_c "$RPM_DIR"

        echo "RPM metadata generated"
    else
        echo "WARNING: createrepo_c not found"
    fi

    echo
    echo "Repository indexing complete"
}

verify_repository() {

    echo "linux-update repository verification"
    echo "Channel : $CHANNEL"
    echo

    ROOT="$REPO_DIR/$CHANNEL"

    FAILED=0

    check_file() {
        if [ -f "$1" ]; then
            echo "[OK] $2"
        else
            echo "[FAIL] $2"
            FAILED=1
        fi
    }

    check_dir() {
        if [ -d "$1" ]; then
            echo "[OK] $2"
        else
            echo "[FAIL] $2"
            FAILED=1
        fi
    }

    ###########################################################################
    # Core Layout
    ###########################################################################

    check_file "$ROOT/INFO" "INFO"

    ###########################################################################
    # DEB
    ###########################################################################

    check_file \
        "$ROOT/apt/pool/main/linux-update_${VERSION}.deb" \
        "DEB package"

    ###########################################################################
    # RPM
    ###########################################################################

    check_file \
        "$ROOT/rpm/linux-update-${VERSION}-1.noarch.rpm" \
        "RPM package"

    ###########################################################################
    # AppImage
    ###########################################################################

    check_file \
        "$ROOT/appimage/linux-update-${VERSION}-x86_64.AppImage" \
        "AppImage"

    ###########################################################################
    # APT Repository
    ###########################################################################

    check_file \
        "$ROOT/apt/dists/$CHANNEL/Release" \
        "APT Release"

    check_file \
        "$ROOT/apt/dists/$CHANNEL/main/binary-amd64/Packages" \
        "APT Packages"

    check_file \
        "$ROOT/apt/dists/$CHANNEL/main/binary-amd64/Packages.gz" \
        "APT Packages.gz"

    ###########################################################################
    # RPM Repository
    ###########################################################################

    check_dir \
        "$ROOT/rpm/repodata" \
        "RPM repodata"

    ###########################################################################
    # Final Result
    ###########################################################################

    echo

    if [ "$FAILED" -eq 0 ]; then
        echo "Repository verification PASSED"
        return 0
    fi

    echo "Repository verification FAILED"
    return 1
}

sign_repository() {

    echo "linux-update repository signing"
    echo "Channel : $CHANNEL"
    echo

    ROOT="$REPO_DIR/$CHANNEL"
    APT_DIR="$ROOT/apt"

    ###########################################################################
    # Verify repository first
    ###########################################################################

    verify_repository

    ###########################################################################
    # Locate GPG key
    ###########################################################################

    KEY_ID=$(
        gpg --list-secret-keys --with-colons \
        | awk -F: '/^sec:/ {print $5; exit}'
    )

    if [ -z "$KEY_ID" ]; then
        echo "ERROR: No GPG secret key found"
        return 1
    fi

    echo "Using key: $KEY_ID"

    ###########################################################################
    # Export public key
    ###########################################################################

    mkdir -p "$REPO_DIR/keys"

    gpg \
        --armor \
        --export "$KEY_ID" \
        > "$REPO_DIR/keys/public.key"

    echo "Created: $REPO_DIR/keys/public.key"

    ###########################################################################
    # APT Release signing
    ###########################################################################

    RELEASE_FILE="$APT_DIR/dists/$CHANNEL/Release"

    if [ ! -f "$RELEASE_FILE" ]; then
        echo "ERROR: Release file not found"
        return 1
    fi

    rm -f \
        "$APT_DIR/dists/$CHANNEL/Release.gpg" \
        "$APT_DIR/dists/$CHANNEL/InRelease"

    gpg \
        --local-user "$KEY_ID" \
        --armor \
        --detach-sign \
        --output "$APT_DIR/dists/$CHANNEL/Release.gpg" \
        "$RELEASE_FILE"

    gpg \
        --local-user "$KEY_ID" \
        --clearsign \
        --output "$APT_DIR/dists/$CHANNEL/InRelease" \
        "$RELEASE_FILE"

    echo "Created Release.gpg"
    echo "Created InRelease"

    ###########################################################################
    # Verify signatures
    ###########################################################################

    gpg \
        --verify \
        "$APT_DIR/dists/$CHANNEL/Release.gpg" \
        "$RELEASE_FILE"

    echo "Release.gpg verification OK"

    echo
    echo "Repository signing PASSED"
}


###############################################################################
# Execute
###############################################################################


case "$MODE" in

    build)
        build_repository
        ;;

    index)
        generate_metadata
        ;;

    verify)
        verify_repository
        ;;

    sign)
        sign_repository
        ;;

esac