#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Test::More tests => 44;

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
is($class->is_undef_or_empty($instance), 0);

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
is($instance->compare($instance_bigger), -1);

#13
is($instance_bigger->compare($instance), 1);

#14
is($instance->compare($string_value), 0);

#15
is($instance->compare(q{}), 1);

#16
is($instance->compare(q{Hello, ATLib::Std}), 1);

#17
is($instance->compare($string_value_bigger), -1);

#18
is($instance->equals($instance), 1);

#19
is($instance->equals($instance_bigger), 0);

#20
is($instance->_can_equals($string_value), 0);

#21
is($instance->equals($string_value), 1);

#22
is($instance->equals($string_value_bigger), 0);

#23
is($instance->_can_equals(undef), 0);

#24
is($instance->equals(undef), 0);

#25
my $string_value_concat = q{ And ATLib framework.};
my $instance_concat = $instance . $string_value_concat;
is($instance_concat, $instance->_value . $string_value_concat);

#26
my $instance_world = ATLib::Std::String->from(q{, world});
my $string_value_hello = q{Hello};
my $instance_hello_world = $string_value_hello . $instance_world;
is($instance_hello_world->get_full_name(), $class);

#27
is($instance_hello_world, $string_value_hello . $instance_world->_value);

#28
isnt($instance_concat->get_hash_code(), $instance->get_hash_code());

#29
is($instance_concat->get_full_name(), $class);

#30
is($instance_concat->get_full_name(), $instance->get_full_name());

#31
is($instance->type_name, $class);

#32
my $mixed_string = ATLib::Std::String->from(q{Mixed 混合 String.});
my $class_as_int = q{ATLib::Std::Int};
is($mixed_string->get_length(), 16);

#33
my $starts = $class->from(q{Mixed 混合});
is($mixed_string->starts_with($starts), 1);

#34
my $ends = $class->from(q{混合 String.});
is($mixed_string->starts_with($ends), 0);

#35
is($mixed_string->ends_with($starts), 0);

#36
is($mixed_string->ends_with($ends), 1);

#37
my $search = q{混合};
is($mixed_string->index_of($search), 6);

#38
is($mixed_string->to_lower(), q{mixed 混合 string.});

#39
is($mixed_string->to_upper(), q{MIXED 混合 STRING.});

#40
my $string = $class->from(q{  String value.  });
is($string->trim_start(), q{String value.  });

#41
is($string->trim_end(), q{  String value.});

#42
is($string->trim(), q{String value.});

#43
is($string->substring(2, length(q{String value.})), q{String value.});

#44
is($string->substring(2), q{String value.  });

done_testing();
__END__