package Test::HasValidVersion;
use 5.006;
use strict;
use warnings;
BEGIN {
	our $VERSION = '0.1.0'; # VERSION
}
use parent 'Exporter';
use Test::Builder;
use version qw( is_lax );
use boolean;
use File::Find::Rule::Perl;
use Module::Extract::VERSION;
use Test::More;

our @EXPORT = qw ( version_all_ok );

my $test = Test::Builder->new;

sub _get_version {
	my $pm = shift;
	return my $version
		= Module::Extract::VERSION->parse_version_safely( $pm );
}

sub version_ok {
	my ( $file, $name ) = @_;

	my $version = _get_version( $file );

	$name = "$file version $version is valid" unless $name;

	if ( not $version ) {
		$test->ok( false , $name );
		$test->diag( "VERSION not defined in $file" );
	}

	if ( is_lax( $version ) ) {
		$test->ok( true, $name );
	}
	else {
		$test->ok( false, "$name");
		$test->diag( "$file VERSION $version is not a valid verion" );
	}
}

sub version_all_ok {
	my ( $dir, $name ) = @_;

	$name = "all modules in $dir have valid versions" unless $name;

	unless ( -d $dir ) {
		$test->ok( false, $name );
		$test->diag( "$dir does not exist, or is not a directory" );
		return;
	}
	my @files = File::Find::Rule->perl_module->in( $dir );

	foreach my $file ( @files ) {
		version_ok( $file );
	}
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

