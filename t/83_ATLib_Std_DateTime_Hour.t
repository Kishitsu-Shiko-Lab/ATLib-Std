#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 42;

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
is($instance->type_name, $class);

#4
is($instance->year, $year);

#5
is($instance->month, $month);

#6
is($instance->day, $day);

#7
is($instance->hour, $hour);

#8
$hour += 1; #8 (2023/01/04)
my $carry = $instance->inc();
is($carry, 0);

#9
is($instance->year, $year);

#10
is($instance->month, $month);

#11
is($instance->day, $day);

#12
is($instance->hour, $hour);

#13
$hour -= 1; #7 (2023/01/04)
$carry = $instance->dec();
is($carry, 0);

#14
is($instance->year, $year);

#15
is($instance->month, $month);

#16
is($instance->day, $day);

#17
is($instance->hour, $hour);

#18
$hour += 17; #24 -> 0 (2023/01/05)
$hour %= 24;
$day += 1;
$carry = $instance->add(17);
is($carry, 1);

#19
is($instance->year, $year);

#20
is($instance->month, $month);

#21
is($instance->day, $day);

#22
is($instance->hour, $hour);

#23
$hour -= 1; #-1 -> 23 (2023/01/04)
$hour += 24;
$day -= 1;
$carry = $instance->dec();
is($carry, -1);

#24
is($instance->year, $year);

#25
is($instance->month, $month);

#26
is($instance->day, $day);

#27
is($instance->hour, $hour);

#28
$hour += 1; #24 -> 0 (2023/01/05)
$hour %= 24;
$day += 1;
$carry = $instance->inc();
is($carry, 1);

#29
is($instance->year, $year);

#30
is($instance->month, $month);

#31
is($instance->day, $day);

#32
is($instance->hour, $hour);

#33
$hour -= 24 * 5; #-120 -> 0 (2022/12/31)
$hour %= 24;
$day -= 5;
$day += 31;
$month -= 1;
$month += 12;
$year -= 1;
$carry = $instance->subtract(24 * 5);
is($carry, -5);

#34
is($instance->year, $year);

#35
is($instance->month, $month);

#36
is($instance->day, $day);

#37
is($instance->hour, $hour);

#38
$hour += 24 * 6; #144 -> 0 (2023/01/06)
$hour %= 24;
$day += 6;
$day %= 31;
$month += 1;
$month %= 12;
$year += 1;
$carry = $instance->add(24 * 6);
is($carry, 6);

#39
is($instance->year, $year);

#40
is($instance->month, $month);

#41
is($instance->day, $day);

#42
is($instance->hour, $hour);

done_testing();
__END__