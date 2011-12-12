package Test::DoubleEncodedEntities;

use strict;
use warnings;

use HTML::TokeParser::Simple;
use Test::DoubleEncodedEntities::Entities;
use Test::Builder;
require Exporter;

use vars qw(@EXPORT @ISA $VERSION);
@EXPORT = qw(ok_dee);
@ISA = qw(Exporter);

$VERSION = "0.01";

my $Tester = Test::Builder->new();

my $entities = join "|", @entities;

sub ok_dee
{
  my $input = shift;
  my $name  = shift || "double encoded entity test";

  # parse the input
  my $p = HTML::TokeParser::Simple->new( doc => $input )
   or die "Can't parse input";

  $p->unbroken_text(1);

  # search all text bits for problems
  my %oops;
  while ( my $token = $p->get_token )
  {
    next unless $token->is_text;
    my $string = $token->as_is;

    # look for bad entities
    $oops{$_}++ foreach $string =~ m/&amp;($entities|#\d+);/go;
  }

  # did we get away okay?
  unless(%oops)
    { return $Tester->ok(1,$name) }

  # report the problem
  $Tester->ok(0, $name);
  foreach (sort { $a cmp $b } keys %oops)
   { $Tester->diag(qq{Found $oops{$_} "&amp;$_;"\n}) }

  # return 0 as we got an error
  return 0;
}

=head1 NAME

Test::DoubleEncodedEntities - check for double encoded entities

=head1 SYNOPSIS

  use Test::More tests => 1;
  use Test::DoubleEncodedEntities;

  ok_dee('<html><body>&amp;eacute;</body></html>', "ent test");

=head1 DESCRIPTION

This is a testing module that checks for double encoded entities
in your string.  It exports one function ok_dee that does
the testing.  You should pass it the html you want to test
and optionally the name for the test.  It will run the test
producing B<Test::Harness> compatible output, and will return
1 on a pass and 0 on a failure.

Note that this only checks the body text;  Entities in attributes
are ignored as often you may want to double encoded entities on
purpose in things like URLs.

This module knows about all the entities defined in the HTML 4.0
specification, and numerical entities.

=head1 AUTHOR

  Copyright Mark Fowler 2004.  All rights reserved.

  This program is free software; you can redistribute it
  and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Test::DoubleEncodedEntities::Entities>

=cut

1;
