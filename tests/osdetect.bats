#!/usr/bin/env bats

@test "osdetect.sh exists" {
    [ -f src/system/osdetect.sh ]
}


@test "detect_package_manager function exists" {

    run grep "detect_package_manager" src/system/osdetect.sh

    [ "$status" -eq 0 ]
}
