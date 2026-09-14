%global _pkgname pano-scrobbler
%global _pkgver 444
%global _pkgdir /opt/%{_pkgname}

# Suppress debug package and stripping for prebuilt binaries
%global debug_package %{nil}
%global __strip /bin/true

Name:           pano-scrobbler
Version:        4.44
Release:        1%{?dist}
Summary:        Feature packed cross-platform music tracker
License:        GPL-3.0-or-later
URL:            https://github.com/kawaiiDango/pano-scrobbler
ExclusiveArch:  x86_64 aarch64

Source0:        %{url}/releases/download/%{_pkgver}/%{_pkgname}-linux-x64.tar.gz
Source1:        %{url}/releases/download/%{_pkgver}/%{_pkgname}-linux-arm64.tar.gz

Requires:       dbus
Requires:       webkitgtk6.0

Requires(post): %{_bindir}/update-alternatives
Requires(postun): %{_bindir}/update-alternatives

%description
Feature rich scrobbler for Windows, Linux & Android.
Supports Last.fm, ListenBrainz, Libre.fm & Pleroma.
With regex edits, charts & Discord Rich Presence on PC. 

%prep
# -c creates a wrapping directory since the tarball does not have one
%ifarch x86_64
%setup -q -c -T -a 0
%endif
%ifarch aarch64
%setup -q -c -T -a 1
%endif

%build
# Nothing to build — prebuilt binaries

%install
# Main executable
install -Dm755 -t %{buildroot}%{_pkgdir} %{_pkgname}

# Shared libs
install -Dm755 -t %{buildroot}%{_pkgdir} *.so
install -Dm755 -t %{buildroot}%{_pkgdir}/lib lib/*.so

# .desktop, icon
install -Dm644 -t %{buildroot}%{_datadir}/applications %{_pkgname}.desktop
install -Dm644 -t %{buildroot}%{_datadir}/icons/hicolor/scalable/apps icons/hicolor/scalable/apps/*.svg
install -Dm644 -t %{buildroot}%{_datadir}/icons/hicolor/symbolic/apps icons/hicolor/symbolic/apps/*.svg

%post
update-alternatives --install %{_bindir}/%{_pkgname} %{_pkgname} \
    %{_pkgdir}/%{_pkgname} 100

%postun
if [ $1 -eq 0 ]; then
    update-alternatives --remove %{_pkgname} %{_pkgdir}/%{_pkgname}
fi

%files
%{_pkgdir}/
%ghost %attr(0755,-,-) %{_bindir}/%{_pkgname}
%{_datadir}/applications/%{_pkgname}.desktop
%{_datadir}/icons/hicolor/scalable/apps/%{_pkgname}.svg
%{_datadir}/icons/hicolor/symbolic/apps/%{_pkgname}*.svg
%license LICENSE

%changelog
* Mon Sep 14 2026 kawaiiDango <kawaiiDango@protonmail.com> - 4.44-1
- Update to 4.44
