#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Tester tests => 7;
use Test::Version qw( version_ok );

check_test(
	sub {
		version_ok( 'corpus/noversion/FooBar.pm' );
	},
	{
		ok => 0,
		name => 'check version in corpus/noversion/FooBar.pm',
		diag => 'NO_VERSION: corpus/noversion/FooBar.pm',
	},
	'no version'
);
