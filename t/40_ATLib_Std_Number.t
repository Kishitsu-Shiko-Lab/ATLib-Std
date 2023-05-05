#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 25;
use English qw{ -no_match_vars };

use ATLib::Std::Exception::Argument;

#1
my $class = q{ATLib::Std::Number};
use_ok($class);

#2
my $value = 123450.65;
my $number_instance = $class->from($value);
isa_ok($number_instance, $class);

#3
is($number_instance->type_name, $class);

#4
is($number_instance == $value, 1);

#5
isa_ok($number_instance->as_string(), q{ATLib::Std::String});

#6
is($number_instance + 5.23, $value + 5.23);

#7
is(5.23 + $number_instance, $value + 5.23);

#8
is($number_instance - 45.23, $value - 45.23);

#9
is(45.23 - $number_instance, 45.23 - $value);

#10
is($number_instance * 2.5, $value * 2.5);

#11
is(2.5 * $number_instance * 2.5, 2.5 * $value * 2.5);

#12
is($number_instance / 2.5, $value / 2.5);

#13
is(2.5 / $number_instance, 2.5 / $value);

#14
my $number_instance_add = $number_instance + 5.43;
isa_ok($number_instance_add, $class);

#15
is($number_instance->_can_equals(q{Hello}), 0);

#16
is($number_instance->compare(q{4649}), 1);

#17
is($number_instance->compare($number_instance), 0);

#18
is($number_instance->equals(q{4649}), 0);

#19
is($number_instance->_can_equals($value), 0);

#20
is($number_instance == $number_instance, 1);

#21
is($number_instance <=> $number_instance, 0);

#>> 22 -
eval
{
    $number_instance->compare(q{String value.});
};

#22
ok($EVAL_ERROR);

#23
my $class_as_exception = q{ATLib::Std::Exception::Argument};
isa_ok($EVAL_ERROR, $class_as_exception);

#24
is($EVAL_ERROR->message, q{Type mismatch.});

#25
is($EVAL_ERROR->param_name, q{$target});

done_testing();
__END__