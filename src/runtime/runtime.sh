#!/usr/bin/env bash

detect_runtime() {

    local script_dir
    local repo_root

    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    repo_root="$(dirname "$(dirname "$script_dir")")"

    if [ -f "$repo_root/src/system/osdetect.sh" ]
    then

        MODE="development"

        PROJECT_ROOT="$repo_root"

        SYSTEM_DIR="$PROJECT_ROOT/src/system"
        COMMAND_DIR="$PROJECT_ROOT/src/commands"
        UI_DIR="$PROJECT_ROOT/src/ui"

        return
    fi

    if [ -n "${APPIMAGE+x}" ] && [ -d "$APPDIR" ]
    then

        MODE="appimage"

        PROJECT_ROOT="$APPDIR/usr/lib/linux-update"

        SYSTEM_DIR="$PROJECT_ROOT"
        COMMAND_DIR="$PROJECT_ROOT"
        UI_DIR="$PROJECT_ROOT"

        return
    fi

    if [ -f /usr/lib/linux-update/version.txt ]
    then

        # shellcheck disable=SC2034
        MODE="installed"

        PROJECT_ROOT="/usr/lib/linux-update"

        # shellcheck disable=SC2034
        SYSTEM_DIR="$PROJECT_ROOT"
        # shellcheck disable=SC2034
        COMMAND_DIR="$PROJECT_ROOT"
        # shellcheck disable=SC2034
        UI_DIR="$PROJECT_ROOT"

        return
    fi

    echo "Cannot locate runtime files"
    exit 1
}

