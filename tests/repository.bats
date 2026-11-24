#!/usr/bin/env bats

setup() {
    rm -rf repository/stable
    rm -rf repository/testing
}

@test "repository script exists" {
    [ -x release/repository.sh ]
}

@test "repository uses version.txt" {
    run grep "VERSION=" release/repository.sh
    [ "$status" -eq 0 ]
}

@test "repository handles invalid channel" {
    run release/repository.sh invalid
    [ "$status" -ne 0 ]
}

@test "repository supports stable" {
    run grep "stable" release/repository.sh
    [ "$status" -eq 0 ]
}

@test "repository supports testing" {
    run grep "testing" release/repository.sh
    [ "$status" -eq 0 ]
}

@test "repository creates stable layout" {
    run release/repository.sh stable

    [ "$status" -eq 0 ]

    [ -d repository/stable/apt ]
    [ -d repository/stable/rpm ]
    [ -d repository/stable/appimage ]
}

@test "repository copies deb package" {
    run release/repository.sh stable

    [ "$status" -eq 0 ]

    VERSION=$(<version.txt)

    [ -f repository/stable/apt/pool/main/linux-update_${VERSION}.deb ]
}