Name:           linux-update
Version:        0.1.0
Release:        1%{?dist}
Summary:        Universal Linux Update Utility

License:        Apache 2
BuildArch:      noarch

Source0:        %{name}-%{version}.tar.gz

Requires:       bash

%description
linux-update is a Bash CLI utility that detects the system
package manager and performs update operations on supported
Linux distributions.

%prep
%setup -q

%build
# Nothing to build

%install
# 1. Δημιουργία των απαραίτητων καταλογών στο buildroot
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/lib

# 2. Εγκατάσταση του εκτελέσιμου αρχείου
install -m 755 bin/linux-update \
    %{buildroot}/usr/bin/

# 3. Εγκατάσταση των βιβλιοθηκών .sh στον δικό τους υποφάκελο
install -m 644 lib/*.sh \
    %{buildroot}/usr/lib/

# 4. Εγκατάσταση του version.txt απευθείας στο /usr/
install -m 644 version.txt \
    %{buildroot}/usr/version.txt

%files
%license LICENSE

# Στοχευμένη δήλωση αρχείων και φακέλων (Ασφαλές για το σύστημα)
/usr/bin/linux-update
/usr/lib/*.sh
/usr/version.txt

%changelog
* Sat Oct 17 2026 Konstantinos Messinis <messiniskostas0@gmail.com> - 0.1.0
- Initial RPM package
