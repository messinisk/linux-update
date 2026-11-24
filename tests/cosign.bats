#!/usr/bin/env bats

WORKFLOW=".github/workflows/cosign.yml"

@test "cosign workflow exists" {

    [ -f "$WORKFLOW" ]
}

@test "cosign workflow uses oidc" {

    run grep "id-token: write" "$WORKFLOW"

    [ "$status" -eq 0 ]
}

@test "cosign workflow signs deb" {

    run grep "Sign DEB" "$WORKFLOW"

    [ "$status" -eq 0 ]
}

@test "cosign workflow signs rpm" {

    run grep "Sign RPM" "$WORKFLOW"

    [ "$status" -eq 0 ]
}

@test "cosign workflow signs appimage" {

    run grep "Sign AppImage" "$WORKFLOW"

    [ "$status" -eq 0 ]
}