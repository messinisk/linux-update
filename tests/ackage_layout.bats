#!/usr/bin/env bats

@test "required runtime files exist" {

    [ -f src/linux-update ]

    [ -f src/system/osdetect.sh ]

    [ -f src/ui/menu.sh ]

    [ -f src/commands/self-update.sh ]

    [ -f src/commands/version.sh ]

    [ -f src/commands/verify.sh  ]
}

@test "deb build contains menu.sh" {

    VERSION=$(<version.txt)

    bash packaging/scripts/build-deb.sh

    PACKAGE=$(
        find "dist/v${VERSION}" \
            -name "*.deb" \
            | head -n1
    )

    [ -n "$PACKAGE" ]

    dpkg-deb -c "$PACKAGE" | grep menu.sh
}
