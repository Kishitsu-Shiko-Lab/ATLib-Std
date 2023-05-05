#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 49;

use ATLib::Std::DateTime::Year;
use ATLib::Std::DateTime::Month;
use ATLib::Std::DateTime::Day;
use ATLib::Std::DateTime::Hour;
use ATLib::Std::DateTime::Minute;
use ATLib::Std::DateTime::Second;

#1
my $class = q{ATLib::Std::DateTime::MicroSecond};
use_ok($class);

#2
my $year = 2023;
my $class_year = q{ATLib::Std::DateTime::Year};
my $year_ref = $class_year->from($class_year->to_epoch($year));

my $month = 12;
my $class_month = q{ATLib::Std::DateTime::Month};
my $month_ref = $class_month->from($year_ref, $class_month->to_epoch($month));

my $day = 31;
my $class_day = q{ATLib::Std::DateTime::Day};
my $day_ref = $class_day->from($month_ref, $class_day->to_epoch($day));

my $hour = 23;
my $class_hour = q{ATLib::Std::DateTime::Hour};
my $hour_ref = $class_hour->from($day_ref, $hour);

my $minute = 59;
my $class_minute = q{ATLib::Std::DateTime::Minute};
my $minute_ref = $class_minute->from($hour_ref, $minute);

my $second = 59;
my $class_second = q{ATLib::Std::DateTime::Second};
my $second_ref = $class_second->from($minute_ref, $second);

my $micro_second = 999_990;
my $instance = $class->from($second_ref, $micro_second);
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
is($instance->second, $second);

#9
is($instance->micro_second, $micro_second);

#10
$micro_second += 1; #999,991 (2023/12/31 23:59:59.999991)
my $carry = $instance->inc();
is($carry, 0);

#11
is($instance->year, $year);

#12
is($instance->month, $month);

#13
is($instance->day, $day);

#14
is($instance->hour, $hour);

#15
is($instance->minute, $minute);

#16
is($instance->second, $second);

#17
is($instance->micro_second, $micro_second);

#18
$micro_second += 9; #1,000,000 -> 0 (2024/01/01 00:00:00.000000)
$micro_second %= 1_000_000;
$second += 1;       #60 -> 0
$second %= 60;
$minute += 1;       #60 -> 0
$minute %= 60;
$hour += 1;         #24 -> 0
$hour %= 24;
$day += 1;          #32 -> 1
$day %= 31;
$month += 1;        #13 -> 1
$month %= 12;
$year += 1;         #2024
$carry = $instance->add(9);
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
is($instance->minute, $minute);

#24
is($instance->second, $second);

#25
is($instance->micro_second, $micro_second);

#26 (2024/01/01 00:00:00.000000)
$micro_second -= 1; #-1 -> 999,999 (2023/12/31 23:59:59.999999)
$micro_second += 1_000_000;
$second -= 1;       #-1 -> 59
$second += 60;
$minute -= 1;       #-1 -> 59
$minute += 60;
$hour -= 1;         #-1 -> 23
$hour += 24;
$day -= 1;          #0 -> 31
$day += 31;
$month -= 1;        #-1 -> 12
$month += 12;
$year -= 1;         #2023
$carry = $instance->dec();
is($carry, -1);

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
is($instance->second, $second);

#33
is($instance->micro_second, $micro_second);

#34 (2023/12/31 23:59:59.999999)
$micro_second -= 1_000_000; #-1 -> 999,999 (2023/12/31 23:59:58.999999)
$micro_second += 1_000_000;
$second -= 1;       #58
$carry = $instance->subtract(1_000_000);
is($carry, -1);

#35
is($instance->year, $year);

#36
is($instance->month, $month);

#37
is($instance->day, $day);

#38
is($instance->hour, $hour);

#39
is($instance->minute, $minute);

#40
is($instance->second, $second);

#41
is($instance->micro_second, $micro_second);

#42 (2023/12/31 23:59:58.999999)
$micro_second += 2_000_000; #2999999 -> 999,999 (2024/01/01 00:00:00.999999)
$micro_second %= 1_000_000;
$second += 2;       #60->0
$second %= 60;
$minute += 1;       #60->0
$minute %= 60;
$hour += 1;         #24 -> 0
$hour %= 24;
$day += 1;          #32 -> 1
$day %= 31;
$month += 1;        #13 -> 1
$month %= 12;
$year += 1;         #2024
$carry = $instance->add(2_000_000);
is($carry, 2);

#43
is($instance->year, $year);

#44
is($instance->month, $month);

#45
is($instance->day, $day);

#46
is($instance->hour, $hour);

#47
is($instance->minute, $minute);

#48
is($instance->second, $second);

#49
is($instance->micro_second, $micro_second);

done_testing();
__END__