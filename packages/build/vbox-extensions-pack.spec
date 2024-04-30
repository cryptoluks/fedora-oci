Name: VirtualBox-Extension-Pack
%define version _VERSION_
Version: %{version}
Release: 1
Summary: VirtualBox Extensions Pack
License: Oracle
Source0: Oracle_VM_VirtualBox_Extension_Pack-%{version}.vbox-extpack
ExclusiveArch: x86_64
BuildRoot: %{tmpdir}/%{name}-%{version}-root-%(id -u -n)
%define _enable_debug_packages 0
%define install_dir /usr/lib64/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack

%description
Virtualbox Extensions Pack

%prep
%setup -qcT
%{__tar} -zxf %{SOURCE0}

%install
install -d $RPM_BUILD_ROOT%{install_dir}
cp -a linux.amd64 $RPM_BUILD_ROOT%{install_dir}
install -p PXE-Intel.rom $RPM_BUILD_ROOT%{install_dir}
install -p ExtPack.xml $RPM_BUILD_ROOT%{install_dir}

%files
%defattr(644,root,root,755)
%dir %{install_dir}
%dir %{install_dir}/linux.amd64
%attr(755,root,root) %{install_dir}/linux.amd64/*
%attr(755,root,root) %{install_dir}/PXE-Intel.rom
%attr(755,root,root) %{install_dir}/ExtPack.xml
