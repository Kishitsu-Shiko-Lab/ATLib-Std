#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 41;

use ATLib::Std::DateTime::Year;
use ATLib::Std::DateTime::Month;
use ATLib::Std::DateTime::Day;

#1
my $class = q{ATLib::Std::DateTime::Hour};
use_ok($class);

#2
my $year = 2023;
my $class_year = q{ATLib::Std::DateTime::Year};
my $year_ref = $class_year->from($class_year->to_epoch($year));

my $month = 1;
my $class_month = q{ATLib::Std::DateTime::Month};
my $month_ref = $class_month->from($year_ref, $class_month->to_epoch($month));

my $day = 4;
my $class_day = q{ATLib::Std::DateTime::Day};
my $day_ref = $class_day->from($month_ref, $class_day->to_epoch($day));

my $hour = 7;
my $instance = $class->from($day_ref, $hour);
isa_ok($instance, $class);

#3
is($instance->year, $year);

#4
is($instance->month, $month);

#5
is($instance->day, $day);

#6
is($instance->hour, $hour);

#7
$hour += 1; #8 (2023/01/04)
my $carry = $instance->inc();
is($carry, 0);

#8
is($instance->year, $year);

#9
is($instance->month, $month);

#10
is($instance->day, $day);

#11
is($instance->hour, $hour);

#12
$hour -= 1; #7 (2023/01/04)
$carry = $instance->dec();
is($carry, 0);

#13
is($instance->year, $year);

#14
is($instance->month, $month);

#15
is($instance->day, $day);

#16
is($instance->hour, $hour);

#17
$hour += 17; #24 -> 0 (2023/01/05)
$hour %= 24;
$day += 1;
$carry = $instance->add(17);
is($carry, 1);

#18
is($instance->year, $year);

#19
is($instance->month, $month);

#20
is($instance->day, $day);

#21
is($instance->hour, $hour);

#22
$hour -= 1; #-1 -> 23 (2023/01/04)
$hour += 24;
$day -= 1;
$carry = $instance->dec();
is($carry, -1);

#23
is($instance->year, $year);

#24
is($instance->month, $month);

#25
is($instance->day, $day);

#26
is($instance->hour, $hour);

#27
$hour += 1; #24 -> 0 (2023/01/05)
$hour %= 24;
$day += 1;
$carry = $instance->inc();
is($carry, 1);

#28
is($instance->year, $year);

#29
is($instance->month, $month);

#30
is($instance->day, $day);

#31
is($instance->hour, $hour);

#32
$hour -= 24 * 5; #-120 -> 0 (2022/12/31)
$hour %= 24;
$day -= 5;
$day += 31;
$month -= 1;
$month += 12;
$year -= 1;
$carry = $instance->subtract(24 * 5);
is($carry, -5);

#33
is($instance->year, $year);

#34
is($instance->month, $month);

#35
is($instance->day, $day);

#36
is($instance->hour, $hour);

#37
$hour += 24 * 6; #144 -> 0 (2023/01/06)
$hour %= 24;
$day += 6;
$day %= 31;
$month += 1;
$month %= 12;
$year += 1;
$carry = $instance->add(24 * 6);
is($carry, 6);

#38
is($instance->year, $year);

#39
is($instance->month, $month);

#40
is($instance->day, $day);

#41
is($instance->hour, $hour);

done_testing();
__END__