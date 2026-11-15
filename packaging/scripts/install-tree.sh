#!/usr/bin/env bash

install_tree() {

    local root="$1"

    mkdir -p "$root/usr/bin"
    mkdir -p "$root/usr/lib/linux-update"

    cp src/linux-update \
       "$root/usr/bin/linux-update"

    chmod 755 \
       "$root/usr/bin/linux-update"

    cp src/system/*.sh \
       "$root/usr/lib/linux-update/"

    cp src/commands/*.sh \
       "$root/usr/lib/linux-update/"

    cp src/ui/*.sh \
       "$root/usr/lib/linux-update/"

    cp version.txt \
       "$root/usr/lib/linux-update/"
}

if [ $# -ne 1 ]
then
    echo "Usage: $0 <root>"
    exit 1
fi

install_tree "$1"