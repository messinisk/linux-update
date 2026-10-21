#!/usr/bin/env bash
set -euo pipefail


VERSION=$(<version.txt)
# shellcheck disable=SC2034
PROJECT_ROOT=$(pwd)

DIST_DIR="/mnt/c/Windows/Temp"

echo "Building Arch package $VERSION"

makepkg -f
cd packaging/arch

mkdir -p "$DIST_DIR"



cp ./*.pkg.tar.zst "$DIST_DIR/"

echo
echo "Arch package created successfully:"
ls -l "$DIST_DIR"/*.pkg.tar.zst