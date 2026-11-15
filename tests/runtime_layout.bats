#!/usr/bin/env bats

@test "runtime contains menu.sh" {

    TMP=$(mktemp -d)

    bash packaging/scripts/install-tree.sh "$TMP"

    [ -f "$TMP/usr/lib/linux-update/menu.sh" ]
}