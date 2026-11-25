#!/usr/bin/env bats

@test "sign-packages uses version.txt" {
  run grep "VERSION=" release/sign-packages.sh
  [ "$status" -eq 0 ]
}

@test "sign-packages generates SHA256SUMS" {
  run grep "SHA256SUMS" release/sign-packages.sh
  [ "$status" -eq 0 ]
}

@test "sign-packages exports public key" {
  run grep "public.key" release/sign-packages.sh
  [ "$status" -eq 0 ]
}

@test "sign-packages signs checksums" {
  run grep "SHA256SUMS.asc" release/sign-packages.sh
  [ "$status" -eq 0 ]
}

@test "sign-packages verifies signature" {
  run grep -- "--verify" release/sign-packages.sh
  [ "$status" -eq 0 ]
}

@test "sign-packages signs AppImage" {
  run grep "AppImage" release/sign-packages.sh
  [ "$status" -eq 0 ]
}

@test "sign-packages signs RPM" {
  run grep "rpm --addsign" release/sign-packages.sh
  [ "$status" -eq 0 ]
}

@test "sign-packages fails gracefully when directory missing" {
  run release/sign-packages.sh /tmp/not-found
  [ "$status" -ne 0 ]
}

VERSION=$(<version.txt)

@test "release directory contains packages" {

    [ -f "dist/v${VERSION}/linux-update_${VERSION}.deb" ]
    [ -f "dist/v${VERSION}/linux-update-${VERSION}-1.noarch.rpm" ]
}

@test "sign-packages includes AppImage in checksums" {

    run grep "AppImage" release/sign-packages.sh

    [ "$status" -eq 0 ]
}