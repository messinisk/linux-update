#!/usr/bin/env bats

@test "rpm package contains executable" {

    bash packaging/scripts/build-rpm.sh

    RPM_FILE=$(find /mnt/c/Windows/Temp/v0.5.0 \
        -name "*.rpm" | head -n1)

    run rpm -qlp "$RPM_FILE"

    echo "$output" | grep "/usr/bin/linux-update"
}



