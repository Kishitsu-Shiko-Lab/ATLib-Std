#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 32;

use English qw{ -no_match_vars };

#1
my $class = q{ATLib::Std::Maybe};
use_ok($class);

#2
use ATLib::Std::String;
my $T = q{ATLib::Std::String};
my $instance = $class->of($T);
isa_ok($instance, $class);

#3
is($instance->has_value, 0);

#4
is($instance->type_name, qq{Maybe[$T]});

#5
is($instance->get_full_name(), $class);

#6
$instance = $class->of($T, undef);
isa_ok($instance, $class);

#7
is($instance->has_value, 0);

#8
is($instance->value, undef);

#9
is($instance->equals($instance), 1);

#10
is($instance->equals(undef), 1);

#11
my $value = $T->from(q{Hello, world.});
is($instance->equals($value), 0);

#12
is($value->equals($instance->value), 0);

#13
is($instance->compare(""), -1);

#14
$instance->value($value);
is($instance->has_value, 1);

#15
is($instance->value, $value);

#16
is($instance->compare(""), 1);

#17
is($instance->equals($value), 1);

#18
is($value->equals($instance->value), 1);

#19
is($value->equals($instance->as_string()), 1);

#20
is($value->equals($instance->value), 1);

#21
is($instance->equals(""), 0);

#22
my $pass_point_1 = 0;
my $value_scalar = $value->as_string();

eval
{
    $instance->value($value_scalar);
    $pass_point_1 = 1;
};
is($pass_point_1, 0);

#23
use ATLib::Std::Exception::Argument;
isa_ok($EVAL_ERROR, q{ATLib::Std::Exception::Argument});

#24
$pass_point_1 = 0;
eval
{
    use ATLib::Std::Any;
    $instance = $class->of(q{ATLib::Std::Any});
    $pass_point_1 = 1;
};
is($pass_point_1, 0);

#25
isa_ok($EVAL_ERROR, q{ATLib::Std::Exception::Argument});

#26
use ATLib::Std::Int;
my $T2 = q{ATLib::Std::Int};
my $instance_int = $class->of($T2);
isa_ok($instance_int, $class);

#27
is($instance_int->equals(undef), 1);

#28
my $value_of_int = $T2->from(1503);
$instance_int->value($value_of_int);
is($instance_int->equals(1503), 1);

#29
is($instance_int->equals($instance_int), 1);

#30
is($instance_int->equals($value_of_int), 1);

#31
is($value_of_int->equals($instance_int->value), 1);

#32
$instance->value($instance_int->as_string());
is($instance_int->equals($instance), 1);

done_testing();
__END__