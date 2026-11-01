# Security Policy

## Supported Versions

| Version | Supported |
|----------|----------|
| 0.4.x | Yes|
| 0.3.x | Yes|
| 0.2.x | No |
| 0.1.x | No |

## Reporting a Vulnerability

Please do not open a public issue.

Report vulnerabilities through:

- GitHub Security Advisories
- GitHub Issues (private disclosure request)

## Release Signing

Official releases are signed using OpenPGP (GPG).

Every release includes:

- public.key
- SHA256SUMS
- SHA256SUMS.asc

## Package Verification

Always verify downloaded packages before installation.

### Verify Release Metadata

Import the public key:

```
gpg --import public.key

```

Verify SHA256SUMS:

```
gpg --verify SHA256SUMS.asc SHA256SUMS

```
Verify package hashes:

```
sha256sum -c SHA256SUMS

```
DEB Verification

```
gpg --verify \
linux-update_VERSION.deb.sig \
linux-update_VERSION.deb
```
RPM Verification
```
rpm -Kv linux-update-VERSION-1.noarch.rpm
```

AppImage Verification

```
gpg --verify \
linux-update-VERSION-x86_64.AppImage.sig \
linux-update-VERSION-x86_64.AppImage
```

