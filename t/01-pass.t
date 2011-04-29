#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::More;
use Test::HasValidVersion qw( all_pm_version_is_valid );

all_pm_version_is_valid ( 'corpus/pass' );

done_testing;
