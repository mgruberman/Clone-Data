use Test::More tests => 29;
use Clone::Data qw( clone );
use Data::Dumper;
$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 0;
$Data::Dumper::Sortkeys = 1;

package Test::Hash;

use vars @ISA;
@ISA = qw(Clone::Data);

sub new {
  my $class = shift;
  my %self = @_;
  bless \%self, $class;
}

package main;

my $a = Test::Hash->new(
    level => 1,
    href  => {
      level => 2,
      href  => {
        level => 3,
        href  => {
          level => 4,
        },
      },
    },
  );

my $b = $a->clone;
my $c = $a->clone;
my $d = clone($a);

for ($a, $b, $c, $d) {
  is(Dumper($a), q{bless( {'href' => {'href' => {'href' => {'level' => 4},'level' => 3},'level' => 2},'level' => 1}, 'Test::Hash' )});
}
for ([$a, $b],
     [$a, $c],
     [$a, $d],
     [$b, $c],
     [$b, $d],
     [$c, $d]) {
  isnt($a, $b);
  isnt($a->{href}, $b->{href});
  isnt($a->{href}{href}, $b->{href}{href});
  isnt($a->{href}{href}{href}, $b->{href}{href}{href});
}

# test for unicode support
{
  my $a = { chr(256) => 1 };
  my $b = clone( $a );
  is((keys(%$a))[0], (keys(%$b))[0]);
}
