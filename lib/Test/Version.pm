package Test::Version;
use 5.006;
use strict;
use warnings;
BEGIN {
	our $VERSION = '0.04'; # VERSION
}
use parent 'Exporter';
use Test::Builder;
use version 0.77 qw( is_lax );
use boolean;
use File::Find::Rule::Perl;
use Module::Extract::VERSION;
use Test::More;

our @EXPORT = qw( version_all_ok ); ## no critic (Modules::ProhibitAutomaticExportation)
our @EXPORT_OK = qw( version_ok );

my $test = Test::Builder->new;

sub _get_version {
	my $pm = shift;
	return my $version
		= Module::Extract::VERSION->parse_version_safely( $pm );
}

sub version_ok {
	my ( $file, $name ) = @_;

	my $version = _get_version( $file );

	$name ||= "validate VERSION in $file";

	if ( not $version ) {
		$test->ok( false , $name );
		$test->diag( "VERSION not defined in $file" );
		return;
	}

	if ( is_lax( $version ) ) {
		$test->ok( true, "VERSION $version in $file is valid" );
	}
	else {
		$test->ok( false, $name );
		$test->diag( "VERSION in $file is not a valid version" );
	}
	return;
}

sub version_all_ok {
	my ( $dir, $name ) = @_;

	$dir
		= defined $dir ? $dir
		: -d 'blib'    ? 'blib'
		:                'lib'
		;

	# Report failure location correctly - GH #1
	local $Test::Builder::Level = $Test::Builder::Level + 1; ## no critic (Variables::ProhibitPackageVars)

	$name ||= "all modules in $dir have valid versions";

	unless ( -d $dir ) {
		$test->ok( false, $name );
		$test->diag( "$dir does not exist, or is not a directory" );
		return;
	}
	my @files = File::Find::Rule->perl_module->in( $dir );

	foreach my $file ( @files ) {
		version_ok( $file );
	}
	return;
}
1;

# ABSTRACT: Check to see that a valid version exists in modules


__END__
=pod

=head1 NAME

Test::Version - Check to see that a valid version exists in modules

=head1 VERSION

version 0.04

=head1 SYNOPSIS

	use Test::More;
	use Test::Version;

	# test blib or lib by default
	version_all_ok;

	done_testing;

=head1 DESCRIPTION

=head1 METHODS

=over

=item version_ok

=item version_all_ok

=back

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

