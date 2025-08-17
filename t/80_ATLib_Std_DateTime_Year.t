#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 12;

#1
my $class = q{ATLib::Std::DateTime::Year};
use_ok($class);

#2
my $year = 2022;
is($class->to_epoch($year), $year - 1900);

#3
my $instance = $class->from($class->to_epoch($year));
isa_ok($instance, $class);

#4
is($instance->type_name, $class);

#5
is($instance->year, $year);

#6
ok(!$class->is_leap_year($year));

#7
is($instance->number_of_days, 365);

#8
$year += 2;
$instance = $instance + 2;
is($instance->year, $year);

#9
ok($class->is_leap_year($year));

#10
is($instance->number_of_days, 366);

#11
$year = 400;
ok($class->is_leap_year($year));

#12
$year = 2200;
ok(!$class->is_leap_year($year));

done_testing();

__END__