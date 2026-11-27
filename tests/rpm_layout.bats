#!/usr/bin/env bats

@test "rpm spec uses install-tree helper" {

    run grep "install-tree.sh" \
        packaging/rpm/linux-update.spec.in

    [ "$status" -eq 0 ]
}

@test "rpm spec does not install source files directly" {

    run grep -E \
        "src/system|src/commands|src/ui" \
        packaging/rpm/linux-update.spec.in

    [ "$status" -ne 0 ]
}

@test "install-tree contains ui modules" {

    run grep "src/ui" \
        packaging/scripts/install-tree.sh

    [ "$status" -eq 0 ]
}

@test "install-tree contains command modules" {

    run grep "src/commands" \
        packaging/scripts/install-tree.sh

    [ "$status" -eq 0 ]
}

@test "install-tree contains system modules" {

    run grep "src/system" \
        packaging/scripts/install-tree.sh

    [ "$status" -eq 0 ]
}

@test "rpm package contains runtime files" {

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

    echo "$output" | grep "linux-update"
    echo "$output" | grep "osdetect.sh"
    echo "$output" | grep "menu.sh"
    echo "$output" | grep "self-update.sh"
    echo "$output" | grep "version.txt"
}

@test "rpm package contains menu.sh" {

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

    echo "$output" | grep "menu.sh"
}

@test "rpm package contains version.txt" {

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

    echo "$output" | grep "version.txt"
}