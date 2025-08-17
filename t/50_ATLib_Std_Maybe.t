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
ok(!$instance->has_value);

#4
is($instance->type_name, $class);

#5
is($instance->get_full_name(), $class);

#6
$instance = $class->of($T, undef);
isa_ok($instance, $class);

#7
ok(!$instance->has_value);

#8
is($instance->value, undef);

#9
ok($instance->equals($instance));

#10
ok($instance->equals(undef));

#11
my $value = $T->from(q{Hello, world.});
ok(!$instance->equals($value));

#12
ok(!$value->equals($instance->value));

#13
is($instance->compare(""), -1);

#14
$instance->value($value);
ok($instance->has_value);

#15
is($instance->value, $value);

#16
ok($instance->compare(""));

#17
ok($instance->equals($value));

#18
ok($value->equals($instance->value));

#19
ok($value->equals($instance->as_string()));

#20
ok($value->equals($instance->value));

#21
ok(!$instance->equals(""));

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
ok($instance_int->equals(undef));

#28
my $value_of_int = $T2->from(1503);
$instance_int->value($value_of_int);
ok($instance_int->equals(1503));

#29
ok($instance_int->equals($instance_int));

#30
ok($instance_int->equals($value_of_int));

#31
ok($value_of_int->equals($instance_int->value));

#32
$instance->value($instance_int->as_string());
ok($instance_int->equals($instance));

done_testing();
__END__