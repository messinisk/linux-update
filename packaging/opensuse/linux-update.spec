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

mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/lib/linux-update

install -m 755 bin/linux-update \
    %{buildroot}/usr/bin/linux-update

install -m 644 lib/*.sh \
    %{buildroot}/usr/lib/linux-update/

install -m 644 version.txt \
    %{buildroot}/usr/lib/linux-update/

%files

%license LICENSE

/usr/bin/linux-update
/usr/lib/linux-update

%changelog

* Sat Oct 17 2026 Konstantinos Messinis <you@example.com> - 0.1.0
- Initial RPM package