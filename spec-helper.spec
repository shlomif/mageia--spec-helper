%define name spec-helper
%define version 0.2
%define release 4mdk

Summary: Tools to ease the creation of rpm packages
Name: %{name}
Version: %{version}
Release: %{release}
# get the source from our cvs repository (see
# http://www.linuxmandrake.com/en/cvs.php3)
Source0: %{name}-%{version}.tar.bz2
Copyright: GPL
Group: Development/Tools
BuildRoot: %{_tmppath}/%{name}-buildroot
Prefix: %{_prefix}
BuildArchitectures: noarch
Requires: perl

%description
Tools to ease the creation of rpm packages for the Linux-Mandrake distribution.
Compress man pages using bzip2, strip executables, ...

%prep
%setup

%build

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc Howto-spec-helper ChangeLog
/usr/share/spec-helper

%changelog
* Fri Mar 31 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.2-4mdk
- initscripts.spec: Requires: perl

* Fri Mar 24 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.2-3mdk
- compress_files: If we found gzip file decompress and bzip2 them.

* Thu Mar 23 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.2-2mdk
- compress_files: Don't compress whatis and dir in /usr/{info|man}.

* Mon Feb 28 2000 Frederic Lepied <flepied@mandrakesoft.com> 0.2-1mdk
- 0.2: added EXCLUDE_FROM_COMPRESS and EXCLUDE_FROM_STRIP environment
variables.

* Tue Feb 22 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.1-3mdk
- Add mail of fred about spec-helper as doc.

* Fri Feb 18 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.1-2mdk
- cvs import.

* Fri Feb 18 2000 Frederic Lepied <flepied@mandrakesoft.com> 0.1-1mdk
- first version.

# end of file
