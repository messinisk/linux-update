#!/usr/bin/env bash

run_verify() {

    echo
    echo "Verification"
    echo
    ###############################################################################
    # Dependencies
    ###############################################################################

    if command -v curl >/dev/null 2>&1
    then
        echo "[OK] curl"
    else
        echo "[FAIL] curl"
        errors=1
    fi

    ###############################################################################
    # AppImage support (FUSE)
    ###############################################################################

    if command -v fusermount >/dev/null 2>&1 ||
    command -v fusermount3 >/dev/null 2>&1
    then
        echo "[OK] FUSE"
    else
        echo "[WARN] FUSE not detected"
    fi
    local errors=0

    if [ -f "$PROJECT_ROOT/version.txt" ]
    then
        echo "[OK] version.txt"
    else
        echo "[FAIL] version.txt"
        errors=1
    fi

    if [ -f "$LIB_DIR/osdetect.sh" ]
    then
        echo "[OK] osdetect.sh"
    else
        echo "[FAIL] osdetect.sh"
        errors=1
    fi

    if [ -f "$COMMAND_DIR/self-update.sh" ]
    then
        echo "[OK] self-update.sh"
    else
        echo "[FAIL] self-update.sh"
        errors=1
    fi

    if [ -f "$UI_DIR/menu.sh" ]
    then
        echo "[OK] menu.sh"
    else
        echo "[FAIL] menu.sh"
        errors=1
    fi

    echo

    if [ "$errors" -eq 0 ]
    then
        echo "Verification successful."
        return 0
    fi

    echo "Verification failed."

    return 1
}