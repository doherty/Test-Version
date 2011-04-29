package Test::HasValidVersion;
use 5.006;
use strict;
use warnings;
BEGIN {
	our $VERSION = '0.1.0'; # VERSION
}
use Test::Builder;
use Module::Extract::VERSION;
use version qw( is_lax );
use parent 'Exporter';
use boolean;
use File::Find::Rule::Perl;
use Test::More;

our @EXPORT = qw ( all_pm_version_is_valid );

my $test = Test::Builder->new;

sub _get_version {
	my $pm = shift;
	return my $version
		= Module::Extract::VERSION->parse_version_safely( $pm );
}

sub version_is_valid {
	my ( $version, $name, $file ) = @_;

	$name = "$version is valid" unless $name;

	if ( is_lax( $version ) ) {
		$test->ok( true, $name );
	}
	else {
		$test->ok( false, "$file version not valid");
	}
}

sub all_pm_version_is_valid {
	my ( $dir, $name ) = @_;

	$name = "all modules in $dir have valid versions" unless $name;

	unless ( -d $dir ) {
		$test->ok( 0, $name );
		$test->diag( "$dir does not exist, or is not a directory" );
		return;
	}
	my @files = File::Find::Rule->perl_module->in( $dir );

	$test->subtest( "All versions are valid", sub {
		foreach my $file ( @files ) {
			my $version = _get_version( $file );
			next unless $version;

			version_is_valid( $version, "$file version $version is valid");
		}
	});
}
1;

# ABSTRACT: Check Perl modules for valid version numbers

__END__
=pod

=head1 NAME

Test::HasValidVersion - Check Perl modules for valid version numbers

=head1 VERSION

version 0.1.0

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

