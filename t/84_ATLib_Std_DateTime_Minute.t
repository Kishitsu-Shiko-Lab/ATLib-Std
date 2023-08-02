#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 38;

use ATLib::Std::DateTime::Year;
use ATLib::Std::DateTime::Month;
use ATLib::Std::DateTime::Day;
use ATLib::Std::DateTime::Hour;

#1
my $class = q{ATLib::Std::DateTime::Minute};
use_ok($class);

#2
my $year = 2023;
my $class_year = q{ATLib::Std::DateTime::Year};
my $year_ref = $class_year->from($class_year->to_epoch($year));

my $month = 1;
my $class_month = q{ATLib::Std::DateTime::Month};
my $month_ref = $class_month->from($year_ref, $class_month->to_epoch($month));

my $day = 23;
my $class_day = q{ATLib::Std::DateTime::Day};
my $day_ref = $class_day->from($month_ref, $class_day->to_epoch($day));

my $hour = 10;
my $class_hour = q{ATLib::Std::DateTime::Hour};
my $hour_ref = $class_hour->from($day_ref, $hour);

my $minute = 11;
my $instance = $class->from($hour_ref, $minute);
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
is($instance->minute, $minute);

#9
$minute += 1; #12 (2023/01/23 10:12)
my $carry = $instance->inc();
is($carry, 0);

#10
is($instance->year, $year);

#11
is($instance->month, $month);

#12
is($instance->day, $day);

#13
is($instance->hour, $hour);

#14
is($instance->minute, $minute);

#15
$minute -= 1; #12 (2023/01/23 10:11)
$carry = $instance->dec();
is($carry, 0);

#16
is($instance->year, $year);

#17
is($instance->month, $month);

#18
is($instance->day, $day);

#19
is($instance->hour, $hour);

#20
is($instance->minute, $minute);

#21
$minute += 50; #61 -> 1 (2023/01/23 11:01)
$minute %= 60;
$hour += 1;
$carry = $instance->add(50);
is($carry, 1);

#22
is($instance->year, $year);

#23
is($instance->month, $month);

#24
is($instance->day, $day);

#25
is($instance->hour, $hour);

#26
is($instance->minute, $minute);

#27
$minute -= 120; #-59 -> 1 (2023/01/23 09:01)
$minute += 60 * 2;
$hour -= 2;
$carry = $instance->subtract(120);
is($carry, -2);

#28
is($instance->year, $year);

#29
is($instance->month, $month);

#30
is($instance->day, $day);

#31
is($instance->hour, $hour);

#32
is($instance->minute, $minute);

#33
$minute -= 1; #0 (2023/01/23 09:00)
$day -= 23;
$day += 31;
$month -= 1;
$month += 12;
$year -= 1; # (2022/12/31 09:00)
$carry = $instance->subtract(1 + (60 * 24 * 23));
is($carry, -(24 * 23));

#34
is($instance->year, $year);

#35
is($instance->month, $month);

#36
is($instance->day, $day);

#37
is($instance->hour, $hour);

#38
is($instance->minute, $minute);

done_testing();
__END__