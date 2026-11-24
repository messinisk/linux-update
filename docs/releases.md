# Release Policy

## Overview

linux-update uses two release channels:

- stable
- testing

---

## Stable Channel

Stable releases are intended for production use.

Examples:


0.5.0\
0.5.1\
1.0.0

### Repository location:

- repository/stable/


Requirements:

- All tests pass\
- DEB build succeeds\
- RPM build succeeds\
- AppImage build succeeds\
- Repository generation succeeds

## Testing Channel

Testing releases are intended for validation before promotion to stable.

- 0.6.0-beta1\
- 0.6.0-beta2\
- 0.6.0-rc1


### Repository location:

- repository/testing

Testing releases may contain:

- new features
- packaging changes
- experimental functionality


## Promotion Policy

Release promotion flow:

testing
    ↓
validation
    ↓
stable

Promotion requirements:

Tests                PASS
DEB Build            PASS
RPM Build            PASS
AppImage Build       PASS
Repository Build     PASS


Current validation target:

53 tests
0 failures
1 skipped

### Release Process

A release is created using the project build pipeline.

Generated artifacts:

linux-update_VERSION.deb
linux-update_VERSION.rpm
linux-update_VERSION.AppImage

