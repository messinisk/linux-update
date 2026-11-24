#!/usr/bin/env bats



VERSION=$(<version.txt)

setup() {
    rm -rf repository/stable

    release/repository.sh stable >/dev/null
    release/repository.sh index stable >/dev/null
}

@test "apt repository contains package" {
    [ -f \
      "repository/stable/apt/pool/main/linux-update_${VERSION}.deb" ]
}

@test "apt packages index exists" {
    [ -f \
      "repository/stable/apt/dists/stable/main/binary-amd64/Packages" ]
}

@test "apt packages.gz exists" {
    [ -f \
      "repository/stable/apt/dists/stable/main/binary-amd64/Packages.gz" ]
}

@test "apt release file exists" {
    [ -f \
      "repository/stable/apt/dists/stable/Release" ]
}

@test "apt index references linux-update" {
    run grep "^Package: linux-update" \
        repository/stable/apt/dists/stable/main/binary-amd64/Packages

    [ "$status" -eq 0 ]
}

@test "rpm repository contains package" {
    [ -f \
      "repository/stable/rpm/linux-update-${VERSION}-1.noarch.rpm" ]
}

@test "rpm repository metadata exists" {
    [ -d \
      "repository/stable/rpm/repodata" ]
}

@test "rpm metadata files exist" {
    run find repository/stable/rpm/repodata -type f

    [ "$status" -eq 0 ]
    [ -n "$output" ]
}

@test "repository verify succeeds" {
    run release/repository.sh verify stable

    [ "$status" -eq 0 ]
}

@test "repository verify reports passed" {
    run release/repository.sh verify stable

    [[ "$output" =~ PASSED ]]
}



@test "apt metadata exists" {
    [ -f repository/stable/apt/dists/stable/Release ]
}

@test "rpm metadata exists" {
    [ -d repository/stable/rpm/repodata ]
}

@test "repository verify stable" {
    run release/repository.sh verify stable
    [ "$status" -eq 0 ]
}