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

    # shellcheck disable=SC2012
    PACKAGE=$(ls /mnt/c/Windows/Temp/v0.5.0/*.deb | head -n1)

    dpkg-deb -c "$PACKAGE" | grep menu.sh
}

