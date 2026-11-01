# linux-update

Universal Linux update utility for multiple Linux distributions.

---

## Supported Distributions

| Distribution Family | Package Manager |
|---------------------|-----------------|
| Debian              | apt |
| Ubuntu              | apt |
| Kali Linux          | apt |
| eLxr                | apt |
| Fedora              | dnf |
| AlmaLinux           | dnf |
| Oracle Linux        | dnf |
| Rocky Linux         | dnf |
| openSUSE            | zypper |

---

## Current Version

```text
linux-update 0.4.2
```

---

## Package Formats

Official release formats:

- DEB
- RPM
- AppImage

---

## Downloads

Latest releases:

https://github.com/messinisk/linux-update/releases

---

## Installation

### Debian, Ubuntu, Kali Linux, eLxr

```bash
sudo apt install ./linux-update_0.4.2.deb
```

### Fedora, AlmaLinux, Oracle Linux, Rocky Linux

```bash
sudo dnf install ./linux-update-0.4.2-1.noarch.rpm
```

### openSUSE

```bash
sudo zypper install ./linux-update-0.4.2-1.noarch.rpm
```

### AppImage

```bash
chmod +x linux-update-0.4.2-x86_64.AppImage

./linux-update-0.4.2-x86_64.AppImage
```

---

## Release Verification

Import the public key:

```bash
gpg --import public.key
```

Verify release metadata:

```bash
gpg --verify SHA256SUMS.asc SHA256SUMS
```

Verify file integrity:

```bash
sha256sum -c SHA256SUMS
```

---

## DEB Verification

```bash
gpg --verify \
linux-update_0.4.2.deb.sig \
linux-update_0.4.2.deb
```

---

## AppImage Verification

```bash
gpg --verify \
linux-update-0.4.2-x86_64.AppImage.sig \
linux-update-0.4.2-x86_64.AppImage
```

---

## RPM Verification

```bash
rpm -Kv \
linux-update-0.4.2-1.noarch.rpm
```

---

## Usage

Run system updates:

```bash
linux-update
```

Check for a newer release:

```bash
linux-update self-update
```

---

## Project Status

Current Release:

```text
v0.4.2 (Pre-release)
```

Implemented:

- apt support
- dnf support
- zypper support
- DEB packaging
- RPM packaging
- AppImage packaging
- SHA256SUMS generation
- OpenPGP release signing
- RPM package signing
- DEB detached signatures
- AppImage detached signatures
- Self-update prototype

---

## License

Apache License 2.0

Copyright 2026 Konstantinos Messinis