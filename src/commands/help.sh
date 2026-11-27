#!/usr/bin/env bash

show_help() {

cat <<EOF
linux-update

USAGE

  linux-update [command]

COMMANDS

  help, --help
      Show help

  version, --version
      Show version

  verify
      Verify release artifacts

  self-update
      Self update utility

MENU

  Run without arguments to start interactive mode.

EOF

}