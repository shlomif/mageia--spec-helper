#---------------------------------------------------------------
# Project         : Mandrake Linux
# Module          : spec-helper
# File            : Makefile
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Fri Feb 18 08:11:21 2000
#---------------------------------------------------------------

PACKAGE=spec-helper
VERSION:=$(shell rpm --qf %{VERSION} -q --specfile spec-helper.spec)
RELEASE:=$(shell rpm --qf %{RELEASE} -q --specfile spec-helper.spec)
TAG := $(shell echo "V$(VERSION)_$(RELEASE)" | tr -- '-.' '__')

FILES= spec-helper clean_files clean_perl compress_files strip_files relative_me_babe lib_symlinks gprintify.py fix-mo translate_menu.pl \
	   fixpamd gprintify remove_info_dir
MACROSFILE = $(PACKAGE).macros
DISTFILES= AUTHORS Makefile ChangeLog Howto-spec-helper $(FILES) macroszification spec-helper.spec $(MACROSFILE).in
bindir=/usr/bin

spec_helper_dir=/usr/share/spec-helper
rpmmacrosdir=/etc/rpm

all:
	@echo "use make install or make dist"

install: $(MACROSFILE)
	install -d -m755 $(DESTDIR)$(bindir)
	install -m755 macroszification $(DESTDIR)$(bindir)/
	install -d -m 755 $(DESTDIR)$(spec_helper_dir)
	install -m 755 $(FILES) $(DESTDIR)$(spec_helper_dir)
	install -d -m 755 $(DESTDIR)/$(rpmmacrosdir)
	install -m 644 $(MACROSFILE) $(DESTDIR)/$(rpmmacrosdir)

clean:
	find . -name '*~' | xargs rm -f

# rules to build a test rpm

localrpm: localdist buildrpm

localdist: cleandist dir localcopy tar

cleandist: clean
	rm -rf $(PACKAGE)-$(VERSION) $(PACKAGE)-$(VERSION).tar.bz2

dir:
	mkdir $(PACKAGE)-$(VERSION)

localcopy:
	ln $(DISTFILES) $(PACKAGE)-$(VERSION)

tar:
	tar cvf $(PACKAGE)-$(VERSION).tar $(PACKAGE)-$(VERSION)
	bzip2 -9vf $(PACKAGE)-$(VERSION).tar
	rm -rf $(PACKAGE)-$(VERSION)

spec-helper.macros: spec-helper.macros.in
	cat $< | sed -e 's:@SPEC_HELPER_ROOT@:$(spec_helper_dir):' > $@

buildrpm:
	rpm -ta $(PACKAGE)-$(VERSION).tar.bz2

# rules to build a distributable rpm

rpm: changelog cvstag dist buildrpm

dist: cleandist dir export tar

export:
	cvs export -d $(PACKAGE)-$(VERSION) -r $(TAG) $(PACKAGE)

cvstag:
	cvs commit
	cvs tag $(CVSTAGOPT) $(TAG)

changelog: ../common/username
	cvs2cl -U ../common/username -I ChangeLog 
	rm -f ChangeLog.bak
	cvs commit -m "Generated by cvs2cl the `date '+%d_%b'`" ChangeLog

# Local variables:
# mode: makefile
# End:
#
# Makefile ends here
