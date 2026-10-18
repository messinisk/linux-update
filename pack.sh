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

arch)
	bash packaging/scripts/build-arch.sh
	;;

all)
	bash packaging/scripts/build-deb.sh
	bash packaging/scripts/build-rpm.sh
	bash packaging/scripts/build-arch.sh
	;;
 *)
        echo "Usage:"
        echo "  ./pack.sh check"
        echo "  ./pack.sh deb"
        echo "  ./pack.sh rpm"
        echo "  ./pack.sh arch"
        echo "  ./pack.sh all"
        exit 1
        ;;
esac
