#!/usr/bin/env bats

@test "apt module exists" {
	[ -f lib/apt.sh ]
}

@test "apt module contains update_system" {
	run grep "update_system()" lib/apt.sh

	[ "$status" -eq 0 ]
}
