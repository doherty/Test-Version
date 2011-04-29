#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::More;
use Test::HasValidVersion qw( all_pm_version_is_valid );

ok ( all_pm_version_is_valid ( 'corpus/pass' )
	, 'all_pm_version_is_valid passes'
);

done_testing;
