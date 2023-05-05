#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 95;

use ATLib::Std::DateTime::Year;
use ATLib::Std::DateTime::Month;
use ATLib::Std::DateTime::Day;
use ATLib::Std::DateTime::Hour;
use ATLib::Std::DateTime::Minute;

#1
my $class = q{ATLib::Std::DateTime::Second};
use_ok($class);

#2
my $year = 2023;
my $class_year = q{ATLib::Std::DateTime::Year};
my $year_ref = $class_year->from($class_year->to_epoch($year));

my $month = 3;
my $class_month = q{ATLib::Std::DateTime::Month};
my $month_ref = $class_month->from($year_ref, $class_month->to_epoch($month));

my $day = 1;
my $class_day = q{ATLib::Std::DateTime::Day};
my $day_ref = $class_day->from($month_ref, $class_day->to_epoch($day));

my $hour = 7;
my $class_hour = q{ATLib::Std::DateTime::Hour};
my $hour_ref = $class_hour->from($day_ref, $hour);

my $minute = 28;
my $class_minute = q{ATLib::Std::DateTime::Minute};
my $minute_ref = $class_minute->from($hour_ref, $minute);

my $second = 58;
my $instance = $class->from($minute_ref, $second);
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
is($instance->max_second, 59);

#10
$second += 1; #59 (2023/03/01 07:28:59)
my $carry = $instance->inc();
is($carry, 0);

#11
is($instance->max_second, 59);

#12
is($instance->year, $year);

#13
is($instance->month, $month);

#14
is($instance->day, $day);

#15
is($instance->hour, $hour);

#16
is($instance->minute, $minute);

#17
is($instance->second, $second);

#18
$second -= 1; #58 (2023/03/01 07:28:58)
$carry = $instance->dec();
is($carry, 0);

#19
is($instance->max_second, 59);

#20
is($instance->year, $year);

#21
is($instance->month, $month);

#22
is($instance->day, $day);

#23
is($instance->hour, $hour);

#24
is($instance->minute, $minute);

#25
is($instance->second, $second);

#26
$second += 3; #61 -> 1 (2023/03/01 07:29:01)
$second %= 60;
$minute += 1;
$carry = $instance->add(3);
is($carry, 1);

#27
is($instance->max_second, 59);

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
is($instance->second, $second);

#34
$second -= 120; #-119 -> 1 (2023/03/01 07:27:01)
$second += 60 * 2;
$minute -= 2;
$carry = $instance->subtract(120);
is($carry, -2);

#35
is($instance->max_second, 59);

#36
is($instance->year, $year);

#37
is($instance->month, $month);

#38
is($instance->day, $day);

#39
is($instance->hour, $hour);

#40
is($instance->minute, $minute);

#41
is($instance->second, $second);

#42
# Init (2023/01/02 03:04:05)
$year = 2023;
$year_ref = $class_year->from($class_year->to_epoch($year));
$month = 1;
$month_ref = $class_month->from($year_ref, $class_month->to_epoch($month));
$day = 2;
$day_ref = $class_day->from($month_ref, $class_day->to_epoch($day));
$hour = 3;
$hour_ref = $class_hour->from($day_ref, $hour);
$minute = 4;
$minute_ref = $class_minute->from($hour_ref, $minute);
$second = 5;
$instance = $class->from($minute_ref, $second);
is($instance->max_second, 59);

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
# Init (2023/01/02 03:04:05)
$second -= 5; # 0 (2023/01/02 03:04:00) (Carry: 0)
$second -= 60 * 4; # -240 (2023/01/02 03:00:00) (Carry: -4)
$second %= 60;
$minute -= 4;
$second -= 60 * 60 * 3; # -10800 (2023/01/02 00:00:00) (Carry: -180)
$second %= 60;
$hour -= 3;
$second -= 60 * 60 * 24 * 2; # -172800 (2022/12/31 00:00:00) (Carry: -2880)
$second %= 60;
$day -= 2;
$day += 31;
$month -= 1;
$month += 12;
$year -= 1;
$carry = $instance->subtract(5 + (60 * 4) + (60 * 60 * 3) + (60 * 60 * 24 * 2));
is($carry, -(4 + 60 * 3 + 60 * 24 * 2));

#50
is($instance->max_second, 59);

#51
is($instance->year, $year);

#52
is($instance->month, $month);

#53
is($instance->day, $day);

#54
is($instance->hour, $hour);

#55
is($instance->minute, $minute);

#56
is($instance->second, $second);

# Test for leap seconds
# Init (2015/06/30 23:59:00 (UTC))
$year = 2015;
$year_ref = $class_year->from($class_year->to_epoch($year));
$month = 6;
$month_ref = $class_month->from($year_ref, $class_month->to_epoch($month));
$day = 30;
$day_ref = $class_day->from($month_ref, $class_day->to_epoch($day));
$hour = 23;
$hour_ref = $class_hour->from($day_ref, $hour);
$minute = 59;
$minute_ref = $class_minute->from($hour_ref, $minute);
$second = 0;
$instance = $class->from_utc($minute_ref, $second);
#57
is($instance->year, $year);

#58
is($instance->month, $month);

#59
is($instance->day, $day);

#60
is($instance->hour, $hour);

#61
is($instance->minute, $minute);

#62
is($instance->second, $second);

#63
is($instance->max_second, 60);

# 2015/06/30 23:59:00 (UTC) - 1sec  => 2015/06/30 23:58:59 (UTC)
$second -= 1;
$second += 60; #59 (Radix: 61 -> 60)
$minute -= 1;  #58
#64
$carry = $instance->dec_utc();
is($carry, -1);

#65
is($instance->year, $year);

#66
is($instance->month, $month);

#67
is($instance->day, $day);

#68
is($instance->hour, $hour);

#69
is($instance->minute, $minute);

#70
is($instance->second, $second);

#71
is($instance->max_second, 59);

# 2015/06/30 23:58:59 (UTC) + 61sec => 2015/06/30 23:59:60 (UTC)
$second += 61; #120
$second %= 60;
$second += 60; #120 -> 60 (Radix: 60 -> 61)
$minute += 1;  #59
$carry = $instance->add_utc(61);
#72
is($carry, 1);

#73
is($instance->year, $year);

#74
is($instance->month, $month);

#75
is($instance->day, $day);

#76
is($instance->hour, $hour);

#77
is($instance->minute, $minute);

#78
is($instance->second, $second);

#79
is($instance->max_second, 60);

# 2015/06/30 23:59:60 (UTC) + 1sec => 2015/07/01 00:00:00 (UTC)
$second += 1;
$second %= (60 + 1); #61 -> 0 (Radix: 61 -> 60)
$minute += 1;
$minute %= 60; #60 -> 0
$hour += 1;
$hour %= 24;   #24 -> 0
$day += 1;
$day %= 30;    #31 -> 1
$month += 1;   #7
$carry = $instance->inc_utc();
#80
is($carry, 1);

#81
is($instance->year, $year);

#82
is($instance->month, $month);

#83
is($instance->day, $day);

#84
is($instance->hour, $hour);

#85
is($instance->minute, $minute);

#86
is($instance->second, $second);

#87
is($instance->max_second, 59);

# 2015/07/01 00:00:00 (UTC) - 60sec => 2015/06/30 23:59:01 (UTC)
$second -= 60;
$second += 61; #0 -> 1 (Radix: 60 -> 61)
$minute -= 1;
$minute += 60; #59
$hour -= 1;
$hour += 24;   #23
$day -= 1;
$day += 30;    #30
$month -= 1;
$carry = $instance->subtract_utc(60);
#88
is($carry, -1);

#89
is($instance->year, $year);

#90
is($instance->month, $month);

#91
is($instance->day, $day);

#92
is($instance->hour, $hour);

#93
is($instance->minute, $minute);

#94
is($instance->second, $second);

#95
is($instance->max_second, 60);

done_testing();
__END__