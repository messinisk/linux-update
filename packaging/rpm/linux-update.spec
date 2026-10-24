Name:           linux-update
Version:        0.1.0
Release:        1%{?dist}
Summary:        Universal Linux update tool

License:        Apache 2
URL:            https://github.com/messinisk/linux-update
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch

Packager:       Konstantinos Messinis
Vendor:         Konstantinos Messinis

%description
Cross-distribution update utility supporting
apt, dnf and zypper.

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
