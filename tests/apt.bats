#!/usr/bin/env bats

@test "apt module exists" {
	[ -f src/system/apt.sh ]
}

@test "apt module contains update_apt" {

    run grep "update_apt" src/system/apt.sh

    [ "$status" -eq 0 ]
}