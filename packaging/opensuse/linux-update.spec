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

* Sat Oct 17 2026 Konstantinos Messinis <you@example.com> - 0.1.0-1
- Initial RPM package