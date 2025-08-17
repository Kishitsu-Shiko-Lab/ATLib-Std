#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Test::More tests => 75;

use ATLib::Std::Any;

#1
my $class = q{ATLib::Std::String};
use_ok($class);

#2
ok(!$class->is_undef_or_empty(q{String as type of bare.}));

#3
ok($class->is_undef_or_empty(q{}));

#4
my $base_instance = ATLib::Std::Any->new();
my $string_value = q{Hello, ATLib::Std::String.};
my $instance = undef;
ok($class->is_undef_or_empty($instance));

#5
$instance = ATLib::Std::String->from(q{});
ok($class->is_undef_or_empty($instance));

#6
is($instance->type_name, $class);

#7
$instance = ATLib::Std::String->from($string_value);
ok(!$class->is_undef_or_empty($instance));

#8
isa_ok($instance, $class);

#9
is($instance->type_name, $class);

#10
is($instance->_can_equals($base_instance), 0);

#11
my $string_value_bigger = q{Hello, ATLib::Std::String::Bigger.};
my $instance_bigger = ATLib::Std::String->from($string_value_bigger);
is($instance->_can_equals($instance_bigger), 1);

#12
is($instance->compare($instance), 0);

#13
isnt($instance lt $instance, 1);

#14
is($instance le $instance, 1);

#15
isnt($instance gt $instance, 1);

#16
is($instance ge $instance, 1);

#17
is($instance eq $instance, 1);

#18
is($instance cmp $instance, 0);

#19
is($instance lt $string_value_bigger, 1);

#20
is($instance le $string_value_bigger, 1);

#21
isnt($instance gt $string_value_bigger, 1);

#22
isnt($instance ge $string_value_bigger, 1);

#23
isnt($instance eq $string_value_bigger, 1);

#24
is($instance cmp $string_value_bigger, -1);

#25
is($instance lt $instance_bigger, 1);

#26
is($instance le $instance_bigger, 1);

#27
isnt($instance gt $instance_bigger, 1);

#28
isnt($instance ge $instance_bigger, 1);

#29
isnt($instance eq $instance_bigger, 1);

#30
is($instance cmp $instance_bigger, -1);

#31
isnt($string_value_bigger lt $instance, 1);

#32
isnt($string_value_bigger le $instance, 1);

#33
is($string_value_bigger gt $instance, 1);

#34
is($string_value_bigger ge $instance, 1);

#35
isnt($string_value_bigger eq $instance, 1);

#36
is($string_value_bigger cmp $instance, 1);

#37
is($instance->compare($instance_bigger), -1);

#38
is($instance_bigger->compare($instance), 1);

#39
is($instance->compare($string_value), 0);

#40
is($instance->compare(q{}), 1);

#41
is($instance->compare(q{Hello, ATLib::Std}), 1);

#42
is($instance->compare($string_value_bigger), -1);

#43
ok($instance->equals($instance));

#44
ok(!$instance->equals($instance_bigger));

#45
is($instance->_can_equals($string_value), 0);

#46
ok($instance->equals($string_value));

#47
ok(!$instance->equals($string_value_bigger));

#48
is($instance->_can_equals(undef), 0);

#49
ok(!$instance->equals(undef));

#50
my $string_value_concat = q{ And ATLib framework.};
my $instance_concat = $instance . $string_value_concat;
is($instance_concat, $instance->_value . $string_value_concat);

#51
my $instance_world = ATLib::Std::String->from(q{, world});
my $string_value_hello = q{Hello};
my $instance_hello_world = $string_value_hello . $instance_world;
is($instance_hello_world->get_full_name(), $class);

#52
is($instance_hello_world, $string_value_hello . $instance_world->_value);

#53
isnt($instance_concat->get_hash_code(), $instance->get_hash_code());

#54
is($instance_concat->get_full_name(), $class);

#55
is($instance_concat->get_full_name(), $instance->get_full_name());

#56
is($instance->type_name, $class);

#57
my $mixed_string = ATLib::Std::String->from(q{Mixed 混合 String.});
my $class_as_int = q{ATLib::Std::Int};
is($mixed_string->get_length(), 16);

#58
my $starts = $class->from(q{Mixed 混合});
ok($mixed_string->starts_with($starts));

#59
my $ends = $class->from(q{混合 String.});
ok(!$mixed_string->starts_with($ends));

#60
ok(!$mixed_string->ends_with($starts));

#61
ok($mixed_string->ends_with($ends));

#62
my $search = q{混合};
is($mixed_string->index_of($search), 6);

#63
is($mixed_string->to_lower(), q{mixed 混合 string.});

#64
is($mixed_string->to_upper(), q{MIXED 混合 STRING.});

#65
my $string = $class->from(q{  String value.  });
is($string->trim_start(), q{String value.  });

#66
is($string->trim_end(), q{  String value.});

#67
is($string->trim(), q{String value.});

#68
is($string->substring(2, length(q{String value.})), q{String value.});

#69
is($string->substring(2), q{String value.  });

#70
my @words = $string->split(q{ });
is(scalar(@words), 2);

#71
isa_ok($words[0], $class);

#72
is($words[0], q{String});

#73
is($words[1], q{value.});

#74
my $string2 = $class->from($string);
isa_ok($string2, $class);

#75
is($string2, $string);

done_testing();
__END__