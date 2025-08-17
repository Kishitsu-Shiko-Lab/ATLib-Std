#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 13;

#1
my $class = q{ATLib::Std::Bool};
use_ok($class);

#2
my $instance_of_true = $class->true;
isa_ok($instance_of_true, $class);

#3
is($instance_of_true->type_name, $class);

#4
is($instance_of_true->_value, 1);

#5
my $instance_of_false = $class->false;
isa_ok($instance_of_false, $class);

#6
is($instance_of_false->type_name, $class);

#7
is($instance_of_false->_value, 0);

#8
is($instance_of_true->equals($instance_of_true), 1);

#9
is($instance_of_false->equals($instance_of_false), 1);

#10
is($instance_of_true->equals($instance_of_false), 0);

#11
is($instance_of_false->equals($instance_of_true), 0);

#12
ok($instance_of_true);

#13
ok(!$instance_of_false);

done_testing();
__END__