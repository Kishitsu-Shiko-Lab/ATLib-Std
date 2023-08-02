#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 96;

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
is($instance->second, $second);

#10
is($instance->max_second, 59);

#11
$second += 1; #59 (2023/03/01 07:28:59)
my $carry = $instance->inc();
is($carry, 0);

#12
is($instance->max_second, 59);

#13
is($instance->year, $year);

#14
is($instance->month, $month);

#15
is($instance->day, $day);

#16
is($instance->hour, $hour);

#17
is($instance->minute, $minute);

#18
is($instance->second, $second);

#19
$second -= 1; #58 (2023/03/01 07:28:58)
$carry = $instance->dec();
is($carry, 0);

#20
is($instance->max_second, 59);

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
is($instance->second, $second);

#27
$second += 3; #61 -> 1 (2023/03/01 07:29:01)
$second %= 60;
$minute += 1;
$carry = $instance->add(3);
is($carry, 1);

#28
is($instance->max_second, 59);

#29
is($instance->year, $year);

#30
is($instance->month, $month);

#31
is($instance->day, $day);

#32
is($instance->hour, $hour);

#33
is($instance->minute, $minute);

#34
is($instance->second, $second);

#35
$second -= 120; #-119 -> 1 (2023/03/01 07:27:01)
$second += 60 * 2;
$minute -= 2;
$carry = $instance->subtract(120);
is($carry, -2);

#36
is($instance->max_second, 59);

#37
is($instance->year, $year);

#38
is($instance->month, $month);

#39
is($instance->day, $day);

#40
is($instance->hour, $hour);

#41
is($instance->minute, $minute);

#42
is($instance->second, $second);

#43
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

#44
is($instance->year, $year);

#45
is($instance->month, $month);

#46
is($instance->day, $day);

#47
is($instance->hour, $hour);

#48
is($instance->minute, $minute);

#49
is($instance->second, $second);

#50
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

#51
is($instance->max_second, 59);

#52
is($instance->year, $year);

#53
is($instance->month, $month);

#54
is($instance->day, $day);

#55
is($instance->hour, $hour);

#56
is($instance->minute, $minute);

#57
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
#58
is($instance->year, $year);

#59
is($instance->month, $month);

#60
is($instance->day, $day);

#61
is($instance->hour, $hour);

#62
is($instance->minute, $minute);

#63
is($instance->second, $second);

#64
is($instance->max_second, 60);

# 2015/06/30 23:59:00 (UTC) - 1sec  => 2015/06/30 23:58:59 (UTC)
$second -= 1;
$second += 60; #59 (Radix: 61 -> 60)
$minute -= 1;  #58
#65
$carry = $instance->dec_utc();
is($carry, -1);

#66
is($instance->year, $year);

#67
is($instance->month, $month);

#68
is($instance->day, $day);

#69
is($instance->hour, $hour);

#70
is($instance->minute, $minute);

#71
is($instance->second, $second);

#72
is($instance->max_second, 59);

# 2015/06/30 23:58:59 (UTC) + 61sec => 2015/06/30 23:59:60 (UTC)
$second += 61; #120
$second %= 60;
$second += 60; #120 -> 60 (Radix: 60 -> 61)
$minute += 1;  #59
$carry = $instance->add_utc(61);
#73
is($carry, 1);

#74
is($instance->year, $year);

#75
is($instance->month, $month);

#76
is($instance->day, $day);

#77
is($instance->hour, $hour);

#78
is($instance->minute, $minute);

#79
is($instance->second, $second);

#80
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
#81
is($carry, 1);

#82
is($instance->year, $year);

#83
is($instance->month, $month);

#84
is($instance->day, $day);

#85
is($instance->hour, $hour);

#86
is($instance->minute, $minute);

#87
is($instance->second, $second);

#88
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
#89
is($carry, -1);

#90
is($instance->year, $year);

#91
is($instance->month, $month);

#92
is($instance->day, $day);

#93
is($instance->hour, $hour);

#94
is($instance->minute, $minute);

#95
is($instance->second, $second);

#96
is($instance->max_second, 60);

done_testing();
__END__