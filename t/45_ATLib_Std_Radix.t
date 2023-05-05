#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 25;

#1
my $class = q{ATLib::Std::Radix};
use_ok($class);

#2
my $radix = 60;
my $value = 59;
my $instance = $class->from($radix, $value);
isa_ok($instance, $class);

#3
is ($instance->type_name, $class);

#4
is($instance->radix, $radix);

#5
is($instance, $value);

#6
my $carry = $instance->inc();
isa_ok($carry, q{ATLib::Std::Int});

#7
is($carry, 1);

#8
is($instance, 0);

#9
$carry = $instance->dec();
isa_ok($carry, q{ATLib::Std::Int});

#10
is($carry, -1);

#11
is($instance, 59);

#12
is($instance->equals(59), 1);

#13
use ATLib::Std::Int;
is($instance->equals(ATLib::Std::Int->from(59)), 1);

#14
$carry = $instance->add($radix * 30 + 9);
is($carry, 31);

#15
is($instance->equals(8), 1);

#16
$carry = $instance->subtract($radix * 2 + 9);
is($carry, -3);

#17
is($instance, 59);

#18
$value = 0;
$instance = $class->from($radix, $value);
$carry = $instance->inc();
is($carry, 0);

#19
is($instance, 1);

#20
$carry = $instance->dec();
is($carry, 0);

#21
is($instance, 0);

#22
$carry = $instance->add($radix - 1);
is($carry, 0);

#23
is($instance, 59);


#24
$carry = $instance->subtract($radix - 1);
is($carry, 0);

#25
is($instance, 0);

done_testing();
__END__