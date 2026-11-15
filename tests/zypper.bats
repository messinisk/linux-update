#!/usr/bin/env bats

@test "zypper module exists" {
    [ -f src/system/zypper.sh ]
}

@test "zypper module contains update_zypper" {
    run grep "update_zypper" src/system/zypper.sh
    [ "$status" -eq 0 ]
}

@test "zypper module contains upgrade_zypper" {
    run grep "upgrade_zypper" src/system/zypper.sh
    [ "$status" -eq 0 ]
}

@test "zypper module contains autoremove_zypper" {
    run grep "autoremove_zypper" src/system/zypper.sh
    [ "$status" -eq 0 ]
}

@test "zypper module contains clean_zypper" {
    run grep "clean_zypper" src/system/zypper.sh
    [ "$status" -eq 0 ]
}