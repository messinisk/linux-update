#!/usr/bin/env bats

@test "osdetect.sh exists" {
	[ -f lib/osdetect.sh ]
}

@test "detect_package_manager function exists" {
	run grep "detect_package_manager()" lib/osdetect.sh

	[ "$status" -eq 0 ]
}
