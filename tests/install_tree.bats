#!/usr/bin/env bats


@test "install-tree installs menu.sh" {

    TMP=$(mktemp -d)

    bash packaging/scripts/install-tree.sh "$TMP"

    [ -f "$TMP/usr/lib/linux-update/menu.sh" ]
}

@test "install-tree installs osdetect.sh" {

    TMP=$(mktemp -d)

    bash packaging/scripts/install-tree.sh "$TMP"

    [ -f "$TMP/usr/lib/linux-update/menu.sh" ]
}

@test "install-tree installs self-update.sh" {

    TMP=$(mktemp -d)

    bash packaging/scripts/install-tree.sh "$TMP"

    [ -f "$TMP/usr/lib/linux-update/menu.sh" ]
}

@test "install-tree installs linux-update executable" {

    TMP=$(mktemp -d)

    bash packaging/scripts/install-tree.sh "$TMP"

    [ -f "$TMP/usr/lib/linux-update/menu.sh" ]
}
