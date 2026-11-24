#!/usr/bin/env bats

setup() {

    export GNUPGHOME="$BATS_TEST_TMPDIR/gnupg"

    mkdir -p "$GNUPGHOME"

    chmod 700 "$GNUPGHOME"

    cat > "$BATS_TEST_TMPDIR/gpg-batch" <<EOF
%no-protection
Key-Type: RSA
Key-Length: 2048
Name-Real: linux-update test
Name-Email: test@linux-update.local
Expire-Date: 0
%commit
EOF

    gpg \
        --batch \
        --generate-key \
        "$BATS_TEST_TMPDIR/gpg-batch" \
        >/dev/null 2>&1

    release/repository.sh stable >/dev/null
    release/repository.sh index stable >/dev/null
}

@test "repository supports sign mode" {

    run grep 'MODE="sign"' release/repository.sh

    [ "$status" -eq 0 ]
}

@test "repository signing succeeds" {

    run release/repository.sh sign stable

    echo "STATUS=$status"
    echo "$output"

    [ "$status" -eq 0 ]
}

@test "public key exists after signing" {

    release/repository.sh sign stable >/dev/null

    [ -f repository/keys/public.key ]
}

@test "release gpg exists after signing" {

    release/repository.sh sign stable >/dev/null

    [ -f repository/stable/apt/dists/stable/Release.gpg ]
}

@test "inrelease exists after signing" {

    release/repository.sh sign stable >/dev/null

    [ -f repository/stable/apt/dists/stable/InRelease ]
}

