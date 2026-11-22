#!/usr/bin/env bats

@test "appimage build script exists" {
  [ -x packaging/scripts/appimage.sh ]
}

@test "appimage build completes" {
  run bash packaging/scripts/appimage.sh
  [ "$status" -eq 0 ]
}

@test "appimage artifact created" {
  run find dist -name "*.AppImage"
  [ "$status" -eq 0 ]
}

@test "appimage artifact exists" {
  bash packaging/scripts/appimage.sh
  run find dist -name "*.AppImage"
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}