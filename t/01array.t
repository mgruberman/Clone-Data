use Test::More tests => 73;
use Clone::Data qw( clone );

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

package Test::Array;
use vars @ISA;
@ISA = qw(Clone::Data);

sub new {
  my $class = shift;
  my @self = @_;
  bless \@self, $class;
}

package main;

my $a = Test::Array->new(
    1, 
    [ 'two', 
      [ 3,
        ['four']
      ],
    ],
  );
my $b = $a->clone;
my $c = $a->clone;
my $d = clone($a);

for ( $a, $b, $c, $d) {
  is(ref($_), 'Test::Array');
  is($#$_, 1);
  is($_->[0], 1);
  is(ref($_->[1]), 'ARRAY');

  is($#{$_->[1]}, 1);
  is($_->[1][0], 'two');
  is(ref($_->[1][1]), 'ARRAY');

  is($#{$_->[1][1]}, 1);
  is($_->[1][1][0],  3);
  is(ref($_->[1][1][1]), 'ARRAY');

  is($#{$_->[1][1][1]}, 0);
  is($_->[1][1][1][0], 'four');
}

for ([ $a, $b ],
     [ $a, $c ],
     [ $a, $d ],
     [ $b, $c ],
     [ $b, $d ],
     [ $c, $d ]) {
  isnt($_->[0],          $_->[1]);
  isnt($_->[0][1],       $_->[1][1]);
  isnt($_->[0][1][1],    $_->[1][1][1]);
  isnt($_->[0][1][1][1], $_->[1][1][1][1]);
}

# test for unicode support
{
  my $a = [ chr(256) => 1 ];
  my $b = clone( $a );
  is($b->[0], chr(256));
}
