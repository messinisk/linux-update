# linux-update

AUTOMATION & CLI for Linux system maintenance and package update workflows.

## Features

### Package Manager Support

- APT (Debian / Ubuntu)
- DNF (Fedora / Rocky / RHEL)
- Zypper (openSUSE)

### Distribution Formats

- DEB package
- RPM package
- AppImage

### Repository Infrastructure

- Repository Build
- Repository Index
- Repository Verification
- Repository Signing

### Supply Chain Security

- Cosign Signatures
- GitHub OIDC Keyless Signing
- Build Provenance
- Provenance Signature

---

# Installation

## Debian / Ubuntu

Download the latest:

```bash
linux-update_VERSION.deb
```

Install:

```bash
sudo dpkg -i linux-update_VERSION.deb
```

---

## Fedora / Rocky / RHEL

Download:

```bash
linux-update-VERSION-1.noarch.rpm
```

Install:

```bash
sudo rpm -Uvh linux-update-VERSION-1.noarch.rpm
```

---

## Generic Linux

Download:

```bash
linux-update-VERSION-x86_64.AppImage
```

Run:

```bash
chmod +x linux-update-VERSION-x86_64.AppImage
./linux-update-VERSION-x86_64.AppImage
```

---

# Security

Every GitHub Release contains:

- Package files
- Cosign signatures (*.sig)
- provenance.json
- provenance.json.sig

---

# Verify Artifacts

Example:

```bash
cosign verify-blob \
  --signature linux-update_VERSION.deb.sig \
  linux-update_VERSION.deb
```

---

# Build Provenance

Each release includes:

```text
provenance.json
provenance.json.sig
```

The provenance document contains:

- Version
- Git Commit
- GitHub Workflow
- Build Timestamp
- Artifact Hashes

---

# Releases

Packages are distributed through GitHub Releases.

Supported assets:

- DEB
- RPM
- AppImage
- Signatures
- Provenance

---

# Development

Run tests:

```bash
bats tests
```

Current project status:

- CI/CD
- Repository Infrastructure
- Cosign Integration
- Release Automation
- Provenance Support

---

# License

See LICENSE.