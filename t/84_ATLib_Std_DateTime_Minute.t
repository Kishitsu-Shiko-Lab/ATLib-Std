#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 37;

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
is($instance->year, $year);

#4
is($instance->month, $month);

#5
is($instance->day, $day);

#6
is($instance->hour, $hour);

#7
is($instance->minute, $minute);

#8
$minute += 1; #12 (2023/01/23 10:12)
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
is($instance->minute, $minute);

#14
$minute -= 1; #12 (2023/01/23 10:11)
$carry = $instance->dec();
is($carry, 0);

#15
is($instance->year, $year);

#16
is($instance->month, $month);

#17
is($instance->day, $day);

#18
is($instance->hour, $hour);

#19
is($instance->minute, $minute);

#20
$minute += 50; #61 -> 1 (2023/01/23 11:01)
$minute %= 60;
$hour += 1;
$carry = $instance->add(50);
is($carry, 1);

#21
is($instance->year, $year);

#22
is($instance->month, $month);

#23
is($instance->day, $day);

#24
is($instance->hour, $hour);

#25
is($instance->minute, $minute);

#26
$minute -= 120; #-59 -> 1 (2023/01/23 09:01)
$minute += 60 * 2;
$hour -= 2;
$carry = $instance->subtract(120);
is($carry, -2);

#27
is($instance->year, $year);

#28
is($instance->month, $month);

#29
is($instance->day, $day);

#30
is($instance->hour, $hour);

#31
is($instance->minute, $minute);

#32
$minute -= 1; #0 (2023/01/23 09:00)
$day -= 23;
$day += 31;
$month -= 1;
$month += 12;
$year -= 1; # (2022/12/31 09:00)
$carry = $instance->subtract(1 + (60 * 24 * 23));
is($carry, -(24 * 23));

#33
is($instance->year, $year);

#34
is($instance->month, $month);

#35
is($instance->day, $day);

#36
is($instance->hour, $hour);

#37
is($instance->minute, $minute);

done_testing();
__END__