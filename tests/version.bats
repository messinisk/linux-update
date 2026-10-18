#!/usr/bin/env bats

@test "version.txt exists" {
	[ -f version.txt ]
}

@test "version.txt is not empty" {
	run cat version.txt

	[ "$status" -eq 0 ]
	[ -n "$output" ]
}
