#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 9;

use ATLib::Std;

#1
my $class = q{ATLib::Std::Any};
my $instance = ATLib::Std::Any->new();
my $hash_code = $instance->get_hash_code();
is($instance->get_hash_code(), $hash_code);

#2
is($instance->get_full_name(), $class);

#3
is($instance->type_name, $class);

#4
is($instance->_can_equals($instance), 1);

#5
is($instance->equals($instance), 1);

#6
my $instance_other = ATLib::Std::Any->new();
is($instance_other->_can_equals($instance), 1);

#7
is($instance_other->equals($instance), 0);

#8
is($instance->_can_equals($instance_other), 1);

#9
is($instance->equals($instance_other), 0);

done_testing();
__END__