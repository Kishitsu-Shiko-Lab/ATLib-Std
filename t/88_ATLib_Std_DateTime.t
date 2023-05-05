#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 210;

#1
my $class = q{ATLib::Std::DateTime};
use_ok($class);

#2
use Time::HiRes qw{gettimeofday};
my ($epoch_sec, $micro_sec) = gettimeofday();
my $instance = $class->now();
my ($sec, $min, $hour, $day, $month, $year, $days_of_week, $days_of_year) = localtime($epoch_sec);
isa_ok($instance, $class);

#3
is($instance->is_utc, 0);

#4
is($instance->unix_time, $epoch_sec);

#5
if ($instance->micro_second != $micro_sec)
{
    ++$micro_sec;
}
is($instance->micro_second, $micro_sec);

#6
is($instance->year, $year + 1900);

#7
is($instance->month, $month + 1);

#8
is($instance->day, $day);

#9
is($instance->hour, $hour);

#10
is($instance->minute, $min);

#11
is($instance->second, $sec);

#12
is($instance->milli_second, int($micro_sec / 1000));

#13
is($instance->day_of_week, $days_of_week);

#14
is($instance->days_of_year, $days_of_year + 1);

#15
($epoch_sec, $micro_sec) = gettimeofday();
$instance = $class->now_utc();
($sec, $min, $hour, $day, $month, $year, $days_of_week, $days_of_year) = gmtime($epoch_sec);
isa_ok($instance, $class);

#16
is($instance->is_utc, 1);

#17
is($instance->unix_time, $epoch_sec);

#18
{
    my $i = 0;
    while ($instance->micro_second != $micro_sec)
    {
        last if ($i > 99999);
        ++$micro_sec;
        ++$i;
        diag('Adjust the excepted micro_second');
    }
    diag('Complete...');
}
is($instance->micro_second, $micro_sec);

#19
is($instance->year, $year + 1900);

#20
is($instance->month, $month + 1);

#21
is($instance->day, $day);

#22
is($instance->hour, $hour);

#23
is($instance->minute, $min);

#24
is($instance->second, $sec);

#25
is($instance->milli_second, int($micro_sec / 1000));

#26
is($instance->day_of_week, $days_of_week);

#27
is($instance->days_of_year, $days_of_year + 1);

# Test for leap year
# Can divide 4 then leap year.
#28
my $leap_year = 2004;
is($class->is_leap_year($leap_year), 1);

#29
#2004/02/28 23:59:59
$instance = $class->from($leap_year, 2, 28, 23, 59, 59);
isa_ok($instance, $class);

#30
is($instance->is_utc, 0);

#31
is($instance->year, $leap_year);

#32
is($instance->month, 2);

#33
is($instance->day, 28);

#34
is($instance->hour, 23);

#35
is($instance->minute, 59);

#36
is($instance->second, 59);

#37
is($instance->milli_second, 0);

#38
is($instance->micro_second, 0);

#39
#2004/02/29 23:59:59 <- 2004/02/28 23:59:59
my $instance_new = $instance->add_days(1);
isa_ok($instance_new, $class);

#40
is($instance_new->year, $leap_year);

#41
is($instance_new->month, 2);

#42
is($instance_new->day, 29);

#43
is($instance_new->hour, 23);

#44
is($instance_new->minute, 59);

#45
is($instance_new->second, 59);

#46
is($instance_new->milli_second, 0);

#47
is($instance_new->micro_second, 0);

#48
#2004/02/29 00:59:59 <- 2004/02/28 23:59:59
$instance_new = $instance->add_hours(1);
isa_ok($instance_new, $class);

#49
is($instance_new->year, $leap_year);

#50
is($instance_new->month, 2);

#51
is($instance_new->day, 29);

#52
is($instance_new->hour, 0);

#53
is($instance_new->minute, 59);

#54
is($instance_new->second, 59);

#55
is($instance_new->milli_second, 0);

#56
is($instance_new->micro_second, 0);

#57
$instance_new = $instance->add_minutes(1);
isa_ok($instance_new, $class);

#58
is($instance_new->year, $leap_year);

#59
is($instance_new->month, 2);

#60
is($instance_new->day, 29);

#61
is($instance_new->hour, 0);

#62
is($instance_new->minute, 0);

#63
is($instance_new->second, 59);

#64
is($instance_new->milli_second, 0);

#65
is($instance_new->micro_second, 0);

#66
#2004/02/29 00:00:00 <- 2004/02/28 23:59:59
$instance_new = $instance->add_seconds(1);
isa_ok($instance_new, $class);

#67
is($instance_new->year, $leap_year);

#68
is($instance_new->month, 2);

#69
is($instance_new->day, 29);

#70
is($instance_new->hour, 0);

#71
is($instance_new->minute, 0);

#72
is($instance_new->second, 0);

#73
is($instance_new->milli_second, 0);

#74
is($instance_new->micro_second, 0);

#75
$instance_new = $instance->add_milli_seconds(1000);
isa_ok($instance_new, $class);

#76
is($instance_new->year, $leap_year);

#77
is($instance_new->month, 2);

#78
is($instance_new->day, 29);

#79
is($instance_new->hour, 0);

#80
is($instance_new->minute, 0);

#81
is($instance_new->second, 0);

#82
is($instance_new->milli_second, 0);

#83
is($instance_new->micro_second, 0);

#84
$instance_new = $instance->add_micro_seconds(1000000);
isa_ok($instance_new, $class);

#85
is($instance_new->year, $leap_year);

#86
is($instance_new->month, 2);

#87
is($instance_new->day, 29);

#88
is($instance_new->hour, 0);

#89
is($instance_new->minute, 0);

#90
is($instance_new->second, 0);

#91
is($instance_new->milli_second, 0);

#92
is($instance_new->micro_second, 0);

#93
$instance = $instance_new->copy()->add_days(1);
is($instance->year, $leap_year);

#94
is($instance->month, 3);

#95
is($instance->day, 1);

#96
is($instance->hour, 0);

#97
is($instance->minute, 0);

#98
is($instance->second, 0);

#99
is($instance->milli_second, 0);

#100
is($instance->micro_second, 0);

#101
$instance_new = $instance->add_days(-1);
isa_ok($instance_new, $class);

#102
is($instance_new->year, $leap_year);

#103
is($instance_new->month, 2);

#104
is($instance_new->day, 29);

#105
is($instance_new->hour, 0);

#106
is($instance_new->minute, 0);

#107
is($instance_new->second, 0);

#108
is($instance_new->milli_second, 0);

#109
is($instance_new->micro_second, 0);

#110
$instance_new = $instance->add_hours(-1);
isa_ok($instance_new, $class);

#111
is($instance_new->year, $leap_year);

#112
is($instance_new->month, 2);

#113
is($instance_new->day, 29);

#114
is($instance_new->hour, 23);

#115
is($instance_new->minute, 0);

#116
is($instance_new->second, 0);

#117
is($instance_new->milli_second, 0);

#118
is($instance_new->micro_second, 0);

#119
$instance_new = $instance->add_minutes(-1);
isa_ok($instance_new, $class);

#120
is($instance_new->year, $leap_year);

#121
is($instance_new->month, 2);

#122
is($instance_new->day, 29);

#123
is($instance_new->hour, 23);

#124
is($instance_new->minute, 59);

#125
is($instance_new->second, 0);

#126
is($instance_new->milli_second, 0);

#127
is($instance_new->micro_second, 0);

#128
$instance_new = $instance->add_seconds(-1);
isa_ok($instance_new, $class);

#129
is($instance_new->year, $leap_year);

#130
is($instance_new->month, 2);

#131
is($instance_new->day, 29);

#132
is($instance_new->hour, 23);

#133
is($instance_new->minute, 59);

#134
is($instance_new->second, 59);

#135
is($instance_new->milli_second, 0);

#136
is($instance_new->micro_second, 0);

#137
$instance_new = $instance->add_milli_seconds(-1);
isa_ok($instance_new, $class);

#138
is($instance_new->year, $leap_year);

#139
is($instance_new->month, 2);

#140
is($instance_new->day, 29);

#141
is($instance_new->hour, 23);

#142
is($instance_new->minute, 59);

#143
is($instance_new->second, 59);

#144
is($instance_new->milli_second, 999);

#145
is($instance_new->micro_second, 999000);

#146
$instance_new = $instance->add_micro_seconds(-999999);
isa_ok($instance_new, $class);

#147
is($instance_new->year, $leap_year);

#148
is($instance_new->month, 2);

#149
is($instance_new->day, 29);

#150
is($instance_new->hour, 23);

#151
is($instance_new->minute, 59);

#152
is($instance_new->second, 59);

#153
is($instance_new->milli_second, 0);

#154
is($instance_new->micro_second, 1);

# Can divide 4 then leap year, but can divide 100 then no leap year.
#155
$leap_year = 2100;
is($class->is_leap_year($leap_year), 0);

# But can divide 400 then leap year.
#156
$leap_year = 2000;
is($class->is_leap_year($leap_year), 1);

# The others then not leap year.
#157
$leap_year = 2022;
is($class->is_leap_year($leap_year), 0);

# Test for leap seconds
# 158
$instance = $class->from_utc(1972, 6, 30, 23, 58, 0);
$instance = $instance->add_minutes(1);
is($instance->as_string('%c'), '1972/06/30 23:59:00');

# 159
is($instance->in_leap_second, 0);

# 160
$instance = $instance->add_seconds(60);
is($instance->second, 60);

# 161
is($instance->in_leap_second, 1);

# 162
is($instance->as_string('%c'), '1972/06/30 23:59:60');

# 163
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/06/30 23:59:59');

# 164
$instance = $instance->add_seconds(2);
is($instance->as_string('%c'), '1972/07/01 00:00:00');

# 165
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/06/30 23:59:60');

# 166
$instance = $class->from_utc(1973, 1, 1, 0, 0, 0);
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/12/31 23:59:60');

# 167
is($instance->in_leap_second, 1);

# 168
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/12/31 23:59:59');

# 169
is($instance->in_leap_second, 0);

# 170
$instance = $instance->add_seconds(2);
is($instance->as_string('%c'), '1973/01/01 00:00:00');

# 171
$instance = $class->from_utc(1973, 12, 31, 23, 58, 0);
$instance = $instance->add_seconds(120);
is($instance->as_string('%c'), '1973/12/31 23:59:60');

# 172
is($instance->in_leap_second, 1);

# 173
$instance = $instance->add_minutes(-1);
is($instance->as_string('%c'), '1973/12/31 23:58:59');

# 174
is($instance->in_leap_second, 0);

# 175
$instance = $instance->add_minutes(1)->add_seconds(1);
is($instance->as_string('%c'), '1973/12/31 23:59:60');

# 176
is($instance->in_leap_second, 1);

# 177
$instance = $instance->add_minutes(1);
is($instance->as_string('%c'), '1974/01/01 00:01:00');

# 178
is($instance->in_leap_second, 0);

# 179
$instance = $class->from_utc(1974, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1974/12/31 23:59:60');

# 180
is($instance->in_leap_second, 1);

# 181
$instance = $instance->add_hours(-1);
is($instance->as_string('%c'), '1974/12/31 22:59:59');

# 182
is($instance->in_leap_second, 0);

# 183
$instance = $class->from_utc(1974, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1974/12/31 23:59:60');

# 184
is($instance->in_leap_second, 1);

# 185
$instance = $instance->add_hours(1);
is($instance->as_string('%c'), '1975/01/01 01:00:00');

# 186
is($instance->in_leap_second, 0);

# 187
$instance = $class->from_utc(1975, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1975/12/31 23:59:60');

# 188
is($instance->in_leap_second, 1);

# 189
$instance = $instance->add_days(-1);
is($instance->as_string('%c'), '1975/12/30 23:59:59');

# 190
is($instance->in_leap_second, 0);

# 191
$instance = $class->from_utc(1975, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1975/12/31 23:59:60');

# 192
is($instance->in_leap_second, 1);

# 193
$instance = $instance->add_hours(1);
is($instance->as_string('%c'), '1976/01/01 01:00:00');

# 194
is($instance->in_leap_second, 0);

# 195
$instance = $class->from_utc(1976, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1976/12/31 23:59:60');

# 196
is($instance->in_leap_second, 1);

# 197
$instance = $instance->add_months(-1);
is($instance->as_string('%c'), '1976/11/31 23:59:59');

# 198
is($instance->in_leap_second, 0);

# 199
$instance = $class->from_utc(1976, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1976/12/31 23:59:60');

# 200
is($instance->in_leap_second, 1);

# 201
$instance = $instance->add_months(1);
is($instance->as_string('%c'), '1977/02/01 00:00:00');

# 202
is($instance->in_leap_second, 0);

# 203
$instance = $class->from_utc(1977, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1977/12/31 23:59:60');

# 204
is($instance->in_leap_second, 1);

# 205
$instance = $instance->add_years(-1);
is($instance->as_string('%c'), '1976/12/31 23:59:59');

# 206
is($instance->in_leap_second, 0);

# 207
$instance = $class->from_utc(1977, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1977/12/31 23:59:60');

# 208
is($instance->in_leap_second, 1);

# 209
$instance = $instance->add_years(1);
is($instance->as_string('%c'), '1979/01/01 00:00:00');

# 210
is($instance->in_leap_second, 0);

done_testing();

__END__