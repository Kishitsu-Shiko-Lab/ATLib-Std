#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 137;

#1
my $T = q{ATLib::Std::String};
my $class = q{ATLib::Std::Collections::List};
use_ok($class);

#2
my $instance = $class->of($T);
isa_ok($instance, $class);

#3
is($instance->count()->equals(0), 1);

#4
use ATLib::Std::Any;
my @test_string;
my $number_of_list = 50;
for my $i (0 .. $number_of_list - 1)
{
    $test_string[$i] = ATLib::Std::Any->new()->get_hash_code();
    my $string = $T->from($test_string[$i]);
    $instance->add($string);
}

is($instance->count(), $number_of_list);

#5 - 54
for my $i (0 .. $number_of_list - 1)
{
    my $string = $T->from($test_string[$i]);
    is($instance->contains($string), 1);
}

#55
is($instance->contains(undef), 0);

#56
$instance->add(undef);
++$number_of_list;
is($instance->contains(undef), 1);

#57
is($instance->count(), $number_of_list);

#58
$instance->remove(undef);
--$number_of_list;
is($instance->contains(undef), 0);

#59
is($instance->count(), $number_of_list);

#60
is($instance->items(30), $T->from($test_string[30]));

#61
isa_ok($instance->items(30), $T);

#62
$instance->remove_at(30);
--$number_of_list;
is($instance->count(), $number_of_list);

#63
isnt($instance->items(30), $T->from($test_string[30]));
splice(@test_string, 30, 1);

#64 - 112
for my $i (0 .. $number_of_list - 1)
{
    my $string = $T->from($test_string[$i]);
    is($instance->contains($string), 1);
}

#113
$instance->clear();
$number_of_list = 0;
is($instance->count(), $number_of_list);

#114
my @test_int = qw{1 2 3 4 5 60 700 8000 90000 100000};
push @test_int, undef;
$number_of_list = scalar(@test_int);
$T = q{ATLib::Std::Int};
$instance = $class->from($T, @test_int);
isa_ok($instance, $class);

#115
is($instance->count(), $number_of_list);

#116 - 126
for my $i (0 .. $number_of_list - 1)
{
    is($instance->items($i), $test_int[$i]);
}

# Basic type of Mouse
#127 - 137
$T = q{Int};
$instance = $class->from($T, @test_int);
for my $i (0 .. $number_of_list - 1)
{
    is($instance->items($i), $test_int[$i]);
}

done_testing();
__END__