#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::More;
use Test::HasValidVersion qw( all_pm_version_is_valid );

ok ( not all_pm_version_is_valid ( 'corpus/fail' )
	, 'all_pm_version_is_valid fails'
);

done_testing;
