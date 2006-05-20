#!/usr/bin/perl -w
#---------------------------------------------------------------
# Project         : Mandrake Linux
# Module          : spec-helper
# File            : translate_menu.pl
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Mon Jan 26 13:37:49 2004
# Purpose         : change the menu sections
#---------------------------------------------------------------

my $menudir = `rpm --eval %_menudir`;
chomp($menudir);

$ENV{RPM_BUILD_ROOT} or exit(0);
! -d "$ENV{RPM_BUILD_ROOT}/$menudir/" || exit(0);

my @nested = (["Configuration", "System/Configuration"],

	   ["Applications/Monitoring", "System/Monitoring"],
	   ["Applications/Publishing", "Office/Publishing"],
	   ["Applications/File tools", "System/File Tools"],
	   ["Applications/Text tools", "System/Text Tools"],
	   ["Applications/Archiving", "System/Archiving"],
	   ["Applications", "More Applications"],

	   ["Terminals", "System/Terminals"],
	   
	   ["Documentation", "More Applications/Documentation"],
	   
           ["Office/PDA", "Office/Communications/PDA"],

	   ["Networking/IRC", "Internet/Chat"],
	   ["Networking/WWW", "Internet/Web Browsers"],
	   ["^Networking", "Internet"],
	   
	   ["Amusement", "More Applications/Games"],
	   ["Session/Windowmanagers", "System/Session/Windowmanagers"],
	   );

sub translate {
    my ($str) = @_;

    foreach my $t (@nested) {
	if ($str =~ /(.*)$t->[0](.*)/ && $str !~ /$t->[1]/) {
	    print "$str => $1$t->[1]$2\n";
	    return "$1$t->[1]$2";
	}
    }
    return $str;
}

# process each file passed on cli:

foreach my $file (glob("$ENV{RPM_BUILD_ROOT}/$menudir/*")) {
    open(my $FILE, "<$file") or die $!;
    my @lines = <$FILE>;
    close($FILE);
    open($FILE, ">$file") or die $!;
    foreach my $l (@lines) {
	chomp($l);
	if ($l =~ /(.*section=)"([^"]+)"(\s*.*)/ || $l =~ /(.*section=)([^"].+?)((\s|\\)+.*)/) {
	    my ($beg, $section, $end) = ($1, $2, $3);
            $section = translate($section);
            $l = qq($beg"$section"$end);
	}
	print $FILE "$l\n";
    }
    close($FILE);
}

# translate_menu.pl ends here
