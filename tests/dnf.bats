#!/usr/bin/env bats

@test "dnf module exists" {
    [ -f src/system/dnf.sh ]
}

@test "dnf module contains update_dnf" {
    run grep "update_dnf" src/system/dnf.sh
    [ "$status" -eq 0 ]
}

@test "dnf module contains upgrade_dnf" {
    run grep "upgrade_dnf" src/system/dnf.sh
    [ "$status" -eq 0 ]
}

@test "dnf module contains autoremove_dnf" {
    run grep "autoremove_dnf" src/system/dnf.sh
    [ "$status" -eq 0 ]
}

@test "dnf module contains clean_dnf" {
    run grep "clean_dnf" src/system/dnf.sh
    [ "$status" -eq 0 ]
}