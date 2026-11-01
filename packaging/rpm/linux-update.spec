Name:           linux-update
Version:        0.4.3
Release:        1%{?dist}
Summary:        Universal Linux update tool

License:        Apache 2
URL:            https://github.com/messinisk/linux-update

Requires:       bash
Requires:       curl
Requires:       gnupg2
Requires:       wget


Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch

Packager:       Konstantinos Messinis
Vendor:         Konstantinos Messinis

Provides:       linux-update

Group:          System/Base

%description
Cross-distribution update utility supporting
apt, dnf and zypper.
Designed for Ubuntu, kali-linux
Debian, eLxr , openSUSE, fendora,
Oracle Linux , AlmaLinux ,Rocky Linux Plus 9.

%prep
%setup -q

%build
# Nothing to build

%install

mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/lib/linux-update

install -m 755 src/linux-update \
    %{buildroot}/usr/bin/linux-update

install -m 644 src/system/*.sh \
    %{buildroot}/usr/lib/linux-update/

install -m 644 src/commands/*.sh \
    %{buildroot}/usr/lib/linux-update/

install -m 644 version.txt \
    %{buildroot}/usr/lib/linux-update/

%files

%license LICENSE

%doc README.md
%doc CHANGELOG.md

/usr/bin/linux-update
/usr/lib/linux-update

%changelog

* Sat Oct 17 2026 Konstantinos Messinis <messiniskostas0@gmail.com> - 0.2.0
- Initial RPM package