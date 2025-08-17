#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 18;

#1
my $class = q{ATLib::Std::Int};
use_ok($class);

#2
my $value = 123450;
my $number_instance = $class->from($value);
isa_ok($number_instance, $class);

#3
is($number_instance->type_name, $class);

#4
is($number_instance == $value, 1);

#5
my $class_as_string = q{ATLib::Std::String};
isa_ok($number_instance->as_string(), $class_as_string);

#6
is($number_instance + 5, $value + 5);

#7
is(5 + $number_instance, $value + 5);

#8
is($number_instance - 45, $value - 45);

#9
is(45 - $number_instance, 45 - $value);

#10
is($number_instance * 2, $value * 2);

#11
is(2 * $number_instance * 2, 2 * $value * 2);

#12
is($number_instance / 2, $value / 2);

#13
is(2 / $number_instance, 2 / $value);

#14
my $number_instance_add = $number_instance + 5;
isa_ok($number_instance_add, $class);

#15
is($number_instance->_can_equals(q{Hello}), 0);

#16
is($number_instance->compare(q{4649}), 1);

#17
ok(!$number_instance->equals(q{4649}));

#18
is($number_instance->_can_equals($value), 0);

done_testing();

__END__