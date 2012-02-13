use Test::More tests => 10;
use Clone::Data qw( clone );

package Test::Scalar;
@ISA = qw(Clone::Data);
sub new {
  my $class = shift;
  my $self = shift;
  bless \$self, $class;
}

package main;
                                                
my $a = Test::Scalar->new(1.2);
my $b = $a->clone;
my $c = $a->clone;
my $d = clone($a);

for ($a, $b, $c, $d) {
  is(ref($_,), 'Test::Scalar');
  is($$_, 1.2);
}

# the following used to produce a segfault, rt.cpan.org id=2264
undef $a;
$b = clone($a);
is($$a, $$b);

# used to get a segfault cloning a ref to a qr data type.
my $str = 'abcdefg';
my $qr = qr/$str/;
my $qc = clone( $qr );

# test for unicode support
{
  my $a = \( chr(256) );
  my $b = clone( $a );
  is($$a, $$b);
}
