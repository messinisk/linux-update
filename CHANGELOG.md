## Changelog

## v0.6.4

### Added

- Dynamic version handling from Git tags
- Automated release notes generation
- Release workflow improvements

### Changed

- Reduced dependency on static version files
- Improved build reproducibility

---

## v0.6.3

### Added

- Provenance generation
- Provenance signing with Cosign

### Security

- Artifact provenance verification support

---

## v0.6.2

### Added

- GitHub Release Automation
- Automatic asset publishing

### Security

- Cosign signatures published with releases

---

## v0.6.1

### Changed

- Version management improvements
- Packaging pipeline cleanup
- Repository test stabilization

### CI/CD

- Build workflow improvements
- Integration test fixes

---

## v0.6.0

### Added

- Cosign Integration
- Keyless Signing using GitHub OIDC
- Supply Chain Security Foundation

### Security

- Release artifact signatures
- Sigstore support

---

## v0.5.0

### Added

- Repository Build
- Repository Index
- Repository Verification
- Repository Signing

### Testing

- Repository integration tests
- Repository signing tests

### Packaging

- DEB support
- RPM support
- AppImage support




## [0.4.2] - 2026-11-01

### Added

- AppImage package generation
- AppImage detached signatures (.AppImage.sig)

### Improved

- Packaging refactor using src/
- Unified runtime layout for DEB and RPM
- Release signing workflow

### Security

- SHA256SUMS signing
- DEB detached signatures
- AppImage detached signatures
- RPM embedded signatures



## [0.4.2] - 2026-11-01

### Added

- AppImage package generation
- AppImage detached signatures (`.AppImage.sig`)
- AppImage integration into release pipeline

### Changed

- Refactored project structure (`src/`, `release/`, `packaging/`)
- Unified runtime layout for DEB, RPM and AppImage packages
- Improved package build automation

### Security

- AppImage signature verification support
- AppImage inclusion in SHA256SUMS release verification

---

## [0.4.1] - 2026-11-01

### Changed

- Refactored command architecture
- Introduced command modules
- Introduced self-update module structure
- Improved packaging scripts organization

### Fixed

- RPM runtime path resolution issues
- Package layout consistency between DEB and RPM

---

## [0.4.0] - 2026-10-28

### Added

- RPM package signing (`rpm --addsign`)
- DEB detached signatures (`.deb.sig`)
- Self-update prototype
- Public key distribution

### Security

- Package authenticity verification for DEB releases
- RPM OpenPGP signatures

---

## [0.3.0] - 2026-10-24

### Added

- SHA256SUMS generation
- SHA256SUMS.asc signatures
- GPG public key distribution

### Changed

- Improved package metadata

---

## [0.2.0] - 2026-10-24

### Added

- DEB metadata
- RPM metadata
- README installation documentation
- LICENSE packaging
- CHANGELOG packaging
- md5sums generation

---

## [0.1.0] - 2026-10-21

### Added

- Initial release
- apt support
- dnf support
- zypper support
