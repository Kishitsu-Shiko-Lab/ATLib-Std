#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Test::More tests => 68;

use ATLib::Std::Any;

#1
my $class = q{ATLib::Std::String};
use_ok($class);

#2
is($class->is_undef_or_empty(q{String as type of bare.}), 0);

#3
is($class->is_undef_or_empty(q{}), 1);

#4
my $base_instance = ATLib::Std::Any->new();
my $string_value = q{Hello, ATLib::Std::String.};
my $instance = undef;
is($class->is_undef_or_empty($instance), 1);

#5
$instance = ATLib::Std::String->from(q{});
is($class->is_undef_or_empty($instance), 1);

#6
$instance = ATLib::Std::String->from($string_value);
is($class->is_undef_or_empty($instance), 0);

#7
isa_ok($instance, $class);

#8
is($instance->type_name, $class);

#9
is($instance->_can_equals($base_instance), 0);

#10
my $string_value_bigger = q{Hello, ATLib::Std::String::Bigger.};
my $instance_bigger = ATLib::Std::String->from($string_value_bigger);
is($instance->_can_equals($instance_bigger), 1);

#11
is($instance->compare($instance), 0);

#12
isnt($instance lt $instance, 1);

#13
is($instance le $instance, 1);

#14
isnt($instance gt $instance, 1);

#15
is($instance ge $instance, 1);

#16
is($instance eq $instance, 1);

#17
is($instance cmp $instance, 0);

#18
is($instance lt $string_value_bigger, 1);

#19
is($instance le $string_value_bigger, 1);

#20
isnt($instance gt $string_value_bigger, 1);

#21
isnt($instance ge $string_value_bigger, 1);

#22
isnt($instance eq $string_value_bigger, 1);

#23
is($instance cmp $string_value_bigger, -1);

#24
is($instance lt $instance_bigger, 1);

#25
is($instance le $instance_bigger, 1);

#26
isnt($instance gt $instance_bigger, 1);

#27
isnt($instance ge $instance_bigger, 1);

#28
isnt($instance eq $instance_bigger, 1);

#29
is($instance cmp $instance_bigger, -1);

#30
isnt($string_value_bigger lt $instance, 1);

#31
isnt($string_value_bigger le $instance, 1);

#32
is($string_value_bigger gt $instance, 1);

#33
is($string_value_bigger ge $instance, 1);

#34
isnt($string_value_bigger eq $instance, 1);

#35
is($string_value_bigger cmp $instance, 1);

#36
is($instance->compare($instance_bigger), -1);

#37
is($instance_bigger->compare($instance), 1);

#38
is($instance->compare($string_value), 0);

#39
is($instance->compare(q{}), 1);

#40
is($instance->compare(q{Hello, ATLib::Std}), 1);

#41
is($instance->compare($string_value_bigger), -1);

#42
is($instance->equals($instance), 1);

#43
is($instance->equals($instance_bigger), 0);

#44
is($instance->_can_equals($string_value), 0);

#45
is($instance->equals($string_value), 1);

#46
is($instance->equals($string_value_bigger), 0);

#47
is($instance->_can_equals(undef), 0);

#48
is($instance->equals(undef), 0);

#49
my $string_value_concat = q{ And ATLib framework.};
my $instance_concat = $instance . $string_value_concat;
is($instance_concat, $instance->_value . $string_value_concat);

#50
my $instance_world = ATLib::Std::String->from(q{, world});
my $string_value_hello = q{Hello};
my $instance_hello_world = $string_value_hello . $instance_world;
is($instance_hello_world->get_full_name(), $class);

#51
is($instance_hello_world, $string_value_hello . $instance_world->_value);

#52
isnt($instance_concat->get_hash_code(), $instance->get_hash_code());

#53
is($instance_concat->get_full_name(), $class);

#54
is($instance_concat->get_full_name(), $instance->get_full_name());

#55
is($instance->type_name, $class);

#56
my $mixed_string = ATLib::Std::String->from(q{Mixed 混合 String.});
my $class_as_int = q{ATLib::Std::Int};
is($mixed_string->get_length(), 16);

#57
my $starts = $class->from(q{Mixed 混合});
is($mixed_string->starts_with($starts), 1);

#58
my $ends = $class->from(q{混合 String.});
is($mixed_string->starts_with($ends), 0);

#59
is($mixed_string->ends_with($starts), 0);

#60
is($mixed_string->ends_with($ends), 1);

#61
my $search = q{混合};
is($mixed_string->index_of($search), 6);

#62
is($mixed_string->to_lower(), q{mixed 混合 string.});

#63
is($mixed_string->to_upper(), q{MIXED 混合 STRING.});

#64
my $string = $class->from(q{  String value.  });
is($string->trim_start(), q{String value.  });

#65
is($string->trim_end(), q{  String value.});

#66
is($string->trim(), q{String value.});

#67
is($string->substring(2, length(q{String value.})), q{String value.});

#68
is($string->substring(2), q{String value.  });

done_testing();
__END__