#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 210;

#1
my $T = q{ATLib::Std::String};
my $class = q{ATLib::Std::Collections::List};
use_ok($class);

#2
my $instance = $class->of($T);
isa_ok($instance, $class);

#3
is($instance->type_name, $class);

#4
is($instance->count()->equals(0), 1);

#5
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

#6 - 55, 56 - 105
for my $i (0 .. $number_of_list - 1)
{
    my $string = $T->from($test_string[$i]);
    is($instance->contains($string), 1);
    isa_ok($instance->items($i), $T);
}

#106
is($instance->contains(undef), 0);

#107
$instance->add(undef);
++$number_of_list;
is($instance->contains(undef), 1);

#108
is($instance->count(), $number_of_list);

#109
$instance->remove(undef);
--$number_of_list;
is($instance->contains(undef), 0);

#110
is($instance->count(), $number_of_list);

#111
is($instance->items(30), $T->from($test_string[30]));

#112
isa_ok($instance->items(30), $T);

#113
$instance->remove_at(30);
--$number_of_list;
is($instance->count(), $number_of_list);

#114
isnt($instance->items(30), $T->from($test_string[30]));
splice(@test_string, 30, 1);

#115 - 163
for my $i (0 .. $number_of_list - 1)
{
    my $string = $T->from($test_string[$i]);
    is($instance->contains($string), 1);
}

#164
$instance->clear();
$number_of_list = 0;
is($instance->count(), $number_of_list);

#165
my @test_int = qw{1 2 3 4 5 60 700 8000 90000 100000};
push @test_int, undef;
$number_of_list = scalar(@test_int);
$T = q{ATLib::Std::Int};
$instance = $class->from($T, @test_int);
isa_ok($instance, $class);

#166
is($instance->count(), $number_of_list);

#167 - 177, 178 - 188
use ATLib::Utils qw{as_type_of};
for my $i (0 .. $number_of_list - 1)
{
    is($instance->items($i), $test_int[$i]);
    is(as_type_of($instance->T, $instance->items($i)), 1);
}

# Basic type of Mouse
$T = q{Int};
$instance = $class->from($T, @test_int);

#189 - 199, 200 - 210
for my $i (0 .. $number_of_list - 1)
{
    is($instance->items($i), $test_int[$i]);
    is(as_type_of($instance->T, $instance->items($i)), 1);
}

done_testing();
__END__