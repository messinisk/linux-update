# Cosign Verification

Verify DEB

cosign verify-blob \
  --signature linux-update_0.6.0.deb.sig \
  linux-update_0.6.0.deb

Verify RPM

cosign verify-blob \
  --signature linux-update-0.6.0-1.noarch.rpm.sig \
  linux-update-0.6.0-1.noarch.rpm

Verify AppImage

cosign verify-blob \
  --signature linux-update-0.6.0-x86_64.AppImage.sig \
  linux-update-0.6.0-x86_64.AppImage