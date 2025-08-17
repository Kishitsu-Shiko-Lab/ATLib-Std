#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 211;

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
ok($instance->count()->equals(0));

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
    ok($instance->contains($string));
    isa_ok($instance->item($i), $T);
}

#106
ok(!$instance->contains(undef));

#107
$instance->add(undef);
++$number_of_list;
ok($instance->contains(undef));

#108
is($instance->count(), $number_of_list);

#109
my $result = $instance->remove(undef);
--$number_of_list;
ok($result);

#110
ok(!$instance->contains(undef));

#111
is($instance->count(), $number_of_list);

#112
is($instance->item(30), $T->from($test_string[30]));

#113
isa_ok($instance->item(30), $T);

#114
$instance->remove_at(30);
--$number_of_list;
is($instance->count(), $number_of_list);

#115
isnt($instance->item(30), $T->from($test_string[30]));
splice(@test_string, 30, 1);

#116 - 164
for my $i (0 .. $number_of_list - 1)
{
    my $string = $T->from($test_string[$i]);
    ok($instance->contains($string));
}

#165
$instance->clear();
$number_of_list = 0;
is($instance->count(), $number_of_list);

#166
my @test_int = qw{1 2 3 4 5 60 700 8000 90000 100000};
push @test_int, undef;
$number_of_list = scalar(@test_int);
$T = q{ATLib::Std::Int};
$instance = $class->from($T, @test_int);
isa_ok($instance, $class);

#167
is($instance->count(), $number_of_list);

#168 - 178, 179 - 189
use ATLib::Utils qw{as_type_of};
for my $i (0 .. $number_of_list - 1)
{
    is($instance->item($i), $test_int[$i]);
    is(as_type_of($instance->T, $instance->item($i)), 1);
}

# Basic type of Mouse
$T = q{Int};
$instance = $class->from($T, @test_int);

#190 - 200, 201 - 211
for my $i (0 .. $number_of_list - 1)
{
    is($instance->item($i), $test_int[$i]);
    is(as_type_of($instance->T, $instance->item($i)), 1);
}

done_testing();
__END__