#!/usr/bin/perl

# WoW 7.3 changed the PlaySound API to require a constant, not a
# string, as an argument. This script searches LUA and XML files
# beneath the current directory for such calls and fixes the argument.
# This is typically called from ...\WorldOfWarcraft\Interface\Addons.

use strict;
use File::Find::Rule;

sub camelCaseToUpperCase {
	my ($symbol) = @_;
	# put an underscore in front of any capital
	$symbol =~ s/([A-Z])/_$1/g;
	# trim leading underscore
	$symbol =~ s/^_//;
	# capitalize the result
	$symbol = uc($symbol);
	# some special cases
	$symbol =~ s/MAIN_MENU/MAINMENU/g;
	$symbol =~ s/SPELL_BOOK/SPELLBOOK/g;
	$symbol =~ s/CHECK_BOX/CHECKBOX/g;
	return $symbol;
}

# process one file
sub process {
	my $filename = $_;
	my ( $shortname, $path, $fullname ) = @_;
	print "\nProcessing ", $fullname, "\n";

	# set up ARGV for local use of diamond operator and in-place search and replace
	local @ARGV;
	@ARGV = ( $filename );
	$^I = ".bak";
	while (<>)
	{
		if (/(^.*PlaySound\()"(\w+)"(\).*)/) {
		# grab 3 pieces, before, symbol, and after
			my $before = $1;
			my $symbol = $2;
			my $after = $3;
			print $before, 'SOUNDKIT.', camelCaseToUpperCase($symbol), $after, "\n";
		} else {
			print $_;
		}
	}

	1;
}

# filter for LUA and XML
sub wanted {
	/.*\.(xml|lua)$/ && process($_);
}

# Walk the tree from current directory, invoking process on each XML or
# LUA file matching the grep expression (PlaySound with a quoted
# argument).

my $rule = File::Find::Rule
	   ->file
	   ->name( '*.xml', '*.lua' )
	   ->grep( qr/PlaySound\("/ )
	   ->exec( \&process );

	   # run the rule
$rule->in( "." );

1;
