#!/usr/bin/env bash

set -euo pipefail

VERSION=$(<version.txt)

MODE="${1:-check}"

echo "linux-update build system"
echo "Version: $VERSION"
echo

case "$MODE" in

deb)
	bash packaging/scripts/build-deb.sh
	;;

rpm)
	bash packaging/scripts/build-rpm.sh
	;;
appimage)

    bash packaging/scripts/appimage.sh
    ;;

all)
	bash packaging/scripts/build-deb.sh
	bash packaging/scripts/build-rpm.sh
	bash packaging/scripts/appimage.sh
	;;
 *)
        echo "Usage:"
        echo "  ./pack.sh check"
        echo "  ./pack.sh deb"
        echo "  ./pack.sh rpm"
		echo "  ./pack.sh appimage"
        echo "  ./pack.sh all"
        exit 1
        ;;
esac
