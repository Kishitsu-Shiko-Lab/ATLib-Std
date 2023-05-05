#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 11;

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
is($instance->year, $year);

#5
is($class->is_leap_year($year), 0);

#6
is($instance->number_of_days, 365);

#7
$year += 2;
$instance = $instance + 2;
is($instance->year, $year);

#8
is($class->is_leap_year($year), 1);

#9
is($instance->number_of_days, 366);

#10
$year = 400;
is($class->is_leap_year($year), 1);

#11
$year = 2200;
is($class->is_leap_year($year), 0);

done_testing();

__END__