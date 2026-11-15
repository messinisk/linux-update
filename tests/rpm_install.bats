#!/usr/bin/env bats

@test "rpm package contains executable" {

    VERSION=$(<version.txt)

    bash packaging/scripts/build-rpm.sh

    RPM_FILE=$(
        find "dist/v${VERSION}" \
            -name "*.rpm" \
            | head -n1
    )

    [ -n "$RPM_FILE" ]

    run rpm -qlp "$RPM_FILE"

    [ "$status" -eq 0 ]

    echo "$output" | grep "/usr/bin/linux-update"
}