# Prevent brp-python-bytecompile from running
%define __os_install_post %{___build_post}

Summary: A gopher client
Name: harbour-gophish
Version: 0.2.0
Release: 1
Source: %{name}-%{version}.tar.gz
BuildArch: noarch
URL: https://github.com/blabber/harbour-gophish
License: MIT
Group: Applications/Internet
Requires: sailfishsilica-qt5
Requires: pyotherside-qml-plugin-python3-qt5 >= 1.3.0
Requires: libsailfishapp-launcher

%description
gophish is a native gopher client for SailfishOS. 

Burrow through the gopherspace and experience the internet, as it used to be
before the rise of the World Wide Web.

Plain text is beautiful!

%prep
%setup -q

%build
# Nothing to do

%install

TARGET=%{buildroot}/%{_datadir}/%{name}
mkdir -p $TARGET
cp -rpv python $TARGET/
cp -rpv qml $TARGET/

TARGET=%{buildroot}/%{_datadir}/applications
mkdir -p $TARGET
cp -rpv %{name}.desktop $TARGET/

TARGET=%{buildroot}/%{_datadir}/icons/hicolor/86x86/apps/
mkdir -p $TARGET
cp -rpv icons/86x86/%{name}.png $TARGET/

TARGET=%{buildroot}/%{_datadir}/icons/hicolor/108x108/apps/
mkdir -p $TARGET
cp -rpv icons/108x108/%{name}.png $TARGET/

TARGET=%{buildroot}/%{_datadir}/icons/hicolor/128x128/apps/
mkdir -p $TARGET
cp -rpv icons/128x128/%{name}.png $TARGET/

TARGET=%{buildroot}/%{_datadir}/icons/hicolor/256x256/apps/
mkdir -p $TARGET
cp -rpv icons/256x256/%{name}.png $TARGET/

%files
%defattr(-,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png

