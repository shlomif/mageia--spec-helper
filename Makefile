#---------------------------------------------------------------
# Project         : Linux-Mandrake
# Module          : spec-helper
# File            : Makefile
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Fri Feb 18 08:11:21 2000
#---------------------------------------------------------------

VERSION=0.4
FILES= spec-helper clean_files clean_perl compress_files strip_files relative_me_babe lib_symlinks
DISTFILES= Makefile ChangeLog Howto-spec-helper $(FILES) macroszification
NAME=spec-helper
DIST=$(NAME)-$(VERSION)
bindir=/usr/bin

all:
	@echo "use make install or make dist"

dist:
	rm -f $(NAME)-$(VERSION).tar.bz2
	rm -rf $(DIST)
	mkdir $(DIST)
	ln $(DISTFILES) $(DIST)
	tar cvf $(NAME)-$(VERSION).tar $(DIST)
	bzip2 -9vf $(NAME)-$(VERSION).tar
	rm -rf $(DIST)

install:
	install -d -m755 $(bindir)
	install -m755 macroszification $(bindir)/
	install -d -m 755 $(DESTDIR)/usr/share/spec-helper
	install -m 755 $(FILES) $(DESTDIR)/usr/share/spec-helper

dis:
	rm -rf $(NAME)-$(VERSION) ../$(NAME)-$(VERSION).tar*
	mkdir -p $(NAME)-$(VERSION)
	ln $(DISTFILES) $(NAME)-$(VERSION)
	tar cvf ../$(NAME)-$(VERSION).tar $(NAME)-$(VERSION)
	bzip2 -9vf ../$(NAME)-$(VERSION).tar
	rm -rf $(NAME)-$(VERSION)

changelog: ../common/username
#cvs2cl is available in our contrib.
	cvs2cl -U ../common/username -I ChangeLog -I $(NAME).spec
	rm -f ChangeLog.bak
	cvs commit -m "Generated by cvs2cl the `date '+%d_%b'`" ChangeLog

rpm: dis
	test -d $(RPM)/SOURCES && test -d $(RPM)/
	cp -f ../$(NAME)-$(VERSION).tar.bz2 $(RPM)/SOURCES
	-rpm -ba --clean --rmsource $(NAME).spec
	rm -f $(NAME)-$(VERSION).tar.bz2

# Local variables:
# mode: makefile
# End:
#
# Makefile ends here
