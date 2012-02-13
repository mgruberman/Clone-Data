use Test::More tests => 1;
use Clone::Data 'clone';
use Data::Dumper;

package Test::Hash;
@ISA = qw( Clone::Data );

sub new {
  my ($class) = @_;
  my $self = {};
  bless $self, $class;
}

package main;

{
  my $a = Test::Hash->new;
  my $b = $a->clone;
}

# benchmarking bug
{
  my $a = Test::Hash->new;
  my $sref = sub { my $b = clone($a) };
  $sref->();
}

# test for cloning unblessed ref
{
  my $a = {};
  my $b = clone($a);
  bless $a, 'Test::Hash';
  bless $b, 'Test::Hash';
}

# test for cloning unblessed ref
{
  my $a = [];
  my $b = clone($a);
  bless $a, 'Test::Hash';
  bless $b, 'Test::Hash';
}

# test for cloning ref that was an int(IV)
{
  my $a = 1;
  $a = [];
  my $b = clone($a);
  bless $a, 'Test::Hash';
  bless $b, 'Test::Hash';
}

# test for cloning ref that was a string(PV)
{
  my $a = '';
  $a = [];
  my $b = clone($a);
  bless $a, 'Test::Hash';
  bless $b, 'Test::Hash';
}

# test for cloning ref that was a magic(PVMG)
{
  my $a = *STDOUT;
  $a = [];
  my $b = clone($a);
  bless $a, 'Test::Hash';
  bless $b, 'Test::Hash';
}

# test for cloning weak reference
{
  use Scalar::Util qw(weaken isweak);
  my $a = Test::Hash->new;
  my $b = { r => $a };
  weaken($b->{'r'});
  my $c = clone($a);
}

# another weak reference problem, this one causes a segfault in 0.24
{
  use Scalar::Util qw(weaken isweak);
  my $a = Test::Hash->new;
  {
    my $b = [ $a, $a ];
    weaken($b->[0]);
    weaken($b->[1]);
  }
  my $c = clone($a);
  # check that references point to the same thing
}

pass();
