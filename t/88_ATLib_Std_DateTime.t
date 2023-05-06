#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 224;

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
$epoch_sec = $instance->unix_time;
my $instance_new = $instance->add_days(1);
$epoch_sec += 60 * 60 * 24;
isa_ok($instance_new, $class);

#40
is($instance_new->unix_time, $epoch_sec);

#41
is($instance_new->year, $leap_year);

#42
is($instance_new->month, 2);

#43
is($instance_new->day, 29);

#44
is($instance_new->hour, 23);

#45
is($instance_new->minute, 59);

#46
is($instance_new->second, 59);

#47
is($instance_new->milli_second, 0);

#48
is($instance_new->micro_second, 0);

#49
#2004/02/29 00:59:59 <- 2004/02/28 23:59:59
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_hours(1);
$epoch_sec += 60 * 60;
isa_ok($instance_new, $class);

#50
is($instance_new->unix_time, $epoch_sec);

#51
is($instance_new->year, $leap_year);

#52
is($instance_new->month, 2);

#53
is($instance_new->day, 29);

#54
is($instance_new->hour, 0);

#55
is($instance_new->minute, 59);

#56
is($instance_new->second, 59);

#57
is($instance_new->milli_second, 0);

#58
is($instance_new->micro_second, 0);

#59
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_minutes(1);
$epoch_sec += 60;
isa_ok($instance_new, $class);

#60
is($instance_new->unix_time, $epoch_sec);

#61
is($instance_new->year, $leap_year);

#62
is($instance_new->month, 2);

#63
is($instance_new->day, 29);

#64
is($instance_new->hour, 0);

#65
is($instance_new->minute, 0);

#66
is($instance_new->second, 59);

#67
is($instance_new->milli_second, 0);

#68
is($instance_new->micro_second, 0);

#69
#2004/02/29 00:00:00 <- 2004/02/28 23:59:59
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_seconds(1);
$epoch_sec += 1;
isa_ok($instance_new, $class);

#70
is($instance_new->unix_time, $epoch_sec);

#71
is($instance_new->year, $leap_year);

#72
is($instance_new->month, 2);

#73
is($instance_new->day, 29);

#74
is($instance_new->hour, 0);

#75
is($instance_new->minute, 0);

#76
is($instance_new->second, 0);

#77
is($instance_new->milli_second, 0);

#78
is($instance_new->micro_second, 0);

#79
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_milli_seconds(1000);
isa_ok($instance_new, $class);

#80
is($instance_new->unix_time, $epoch_sec);

#81
is($instance_new->year, $leap_year);

#82
is($instance_new->month, 2);

#83
is($instance_new->day, 29);

#84
is($instance_new->hour, 0);

#85
is($instance_new->minute, 0);

#86
is($instance_new->second, 0);

#87
is($instance_new->milli_second, 0);

#88
is($instance_new->micro_second, 0);

#89
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_micro_seconds(1000000);
isa_ok($instance_new, $class);

#90
is($instance_new->unix_time, $epoch_sec);

#91
is($instance_new->year, $leap_year);

#92
is($instance_new->month, 2);

#93
is($instance_new->day, 29);

#94
is($instance_new->hour, 0);

#95
is($instance_new->minute, 0);

#96
is($instance_new->second, 0);

#97
is($instance_new->milli_second, 0);

#98
is($instance_new->micro_second, 0);

#99
$instance = $instance_new->copy()->add_days(1);
is($instance->year, $leap_year);

#100
is($instance->month, 3);

#101
is($instance->day, 1);

#102
is($instance->hour, 0);

#103
is($instance->minute, 0);

#104
is($instance->second, 0);

#105
is($instance->milli_second, 0);

#106
is($instance->micro_second, 0);

#107
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_days(-1);
$epoch_sec -= 60 * 60 * 24;
isa_ok($instance_new, $class);

#108
is($instance_new->unix_time, $epoch_sec);

#109
is($instance_new->year, $leap_year);

#110
is($instance_new->month, 2);

#111
is($instance_new->day, 29);

#112
is($instance_new->hour, 0);

#113
is($instance_new->minute, 0);

#114
is($instance_new->second, 0);

#115
is($instance_new->milli_second, 0);

#116
is($instance_new->micro_second, 0);

#117
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_hours(-1);
$epoch_sec -= 60 * 60;
isa_ok($instance_new, $class);

#118
is($instance_new->unix_time, $epoch_sec);

#119
is($instance_new->year, $leap_year);

#120
is($instance_new->month, 2);

#121
is($instance_new->day, 29);

#122
is($instance_new->hour, 23);

#123
is($instance_new->minute, 0);

#124
is($instance_new->second, 0);

#125
is($instance_new->milli_second, 0);

#126
is($instance_new->micro_second, 0);

#127
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_minutes(-1);
$epoch_sec -= 60;
isa_ok($instance_new, $class);

#128
is($instance_new->unix_time, $epoch_sec);

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
is($instance_new->second, 0);

#135
is($instance_new->milli_second, 0);

#136
is($instance_new->micro_second, 0);

#137
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_seconds(-1);
$epoch_sec -= 1;
isa_ok($instance_new, $class);

#138
is($instance_new->unix_time, $epoch_sec);

#139
is($instance_new->year, $leap_year);

#140
is($instance_new->month, 2);

#141
is($instance_new->day, 29);

#142
is($instance_new->hour, 23);

#143
is($instance_new->minute, 59);

#144
is($instance_new->second, 59);

#145
is($instance_new->milli_second, 0);

#146
is($instance_new->micro_second, 0);

#147
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_milli_seconds(-1);
isa_ok($instance_new, $class);

#148
is($instance_new->unix_time, $epoch_sec);

#149
is($instance_new->year, $leap_year);

#150
is($instance_new->month, 2);

#151
is($instance_new->day, 29);

#152
is($instance_new->hour, 23);

#153
is($instance_new->minute, 59);

#154
is($instance_new->second, 59);

#155
is($instance_new->milli_second, 999);

#156
is($instance_new->micro_second, 999000);

#157
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_micro_seconds(-999999);
isa_ok($instance_new, $class);

#158
is($instance_new->unix_time, $epoch_sec);

#159
is($instance_new->year, $leap_year);

#160
is($instance_new->month, 2);

#161
is($instance_new->day, 29);

#162
is($instance_new->hour, 23);

#163
is($instance_new->minute, 59);

#164
is($instance_new->second, 59);

#165
is($instance_new->milli_second, 0);

#166
is($instance_new->micro_second, 1);

# Can divide 4 then leap year, but can divide 100 then no leap year.
#167
$leap_year = 2100;
is($class->is_leap_year($leap_year), 0);

# But can divide 400 then leap year.
#168
$leap_year = 2000;
is($class->is_leap_year($leap_year), 1);

# The others then not leap year.
#169
$leap_year = 2022;
is($class->is_leap_year($leap_year), 0);

# Test for leap seconds
# 170
$instance = $class->from_utc(1972, 6, 30, 23, 58, 0);
$instance = $instance->add_minutes(1);
is($instance->as_string('%c'), '1972/06/30 23:59:00');

# 171
is($instance->in_leap_second, 0);

# 172
$epoch_sec = $instance->unix_time;
$instance = $instance->add_seconds(60);
$epoch_sec += 59;
is($instance->second, 60);

# 173
is($instance->unix_time, $epoch_sec);

# 174
is($instance->in_leap_second, 1);

# 175
is($instance->as_string('%c'), '1972/06/30 23:59:60');

# 176
$epoch_sec = $instance->unix_time;
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/06/30 23:59:59');

# 177
is($instance->unix_time, $epoch_sec);

# 178
$instance = $instance->add_seconds(2);
is($instance->as_string('%c'), '1972/07/01 00:00:00');

# 179
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/06/30 23:59:60');

# 180
$instance = $class->from_utc(1973, 1, 1, 0, 0, 0);
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/12/31 23:59:60');

# 181
is($instance->in_leap_second, 1);

# 182
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/12/31 23:59:59');

# 183
is($instance->in_leap_second, 0);

# 184
$instance = $instance->add_seconds(2);
is($instance->as_string('%c'), '1973/01/01 00:00:00');

# 185
$instance = $class->from_utc(1973, 12, 31, 23, 58, 0);
$instance = $instance->add_seconds(120);
is($instance->as_string('%c'), '1973/12/31 23:59:60');

# 186
is($instance->in_leap_second, 1);

# 187
$instance = $instance->add_minutes(-1);
is($instance->as_string('%c'), '1973/12/31 23:58:59');

# 188
is($instance->in_leap_second, 0);

# 189
$instance = $instance->add_minutes(1)->add_seconds(1);
is($instance->as_string('%c'), '1973/12/31 23:59:60');

# 190
is($instance->in_leap_second, 1);

# 191
$instance = $instance->add_minutes(1);
is($instance->as_string('%c'), '1974/01/01 00:01:00');

# 192
is($instance->in_leap_second, 0);

# 193
$instance = $class->from_utc(1974, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1974/12/31 23:59:60');

# 194
is($instance->in_leap_second, 1);

# 195
$instance = $instance->add_hours(-1);
is($instance->as_string('%c'), '1974/12/31 22:59:59');

# 196
is($instance->in_leap_second, 0);

# 197
$instance = $class->from_utc(1974, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1974/12/31 23:59:60');

# 198
is($instance->in_leap_second, 1);

# 199
$instance = $instance->add_hours(1);
is($instance->as_string('%c'), '1975/01/01 01:00:00');

# 200
is($instance->in_leap_second, 0);

# 201
$instance = $class->from_utc(1975, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1975/12/31 23:59:60');

# 202
is($instance->in_leap_second, 1);

# 203
$instance = $instance->add_days(-1);
is($instance->as_string('%c'), '1975/12/30 23:59:59');

# 204
is($instance->in_leap_second, 0);

# 205
$instance = $class->from_utc(1975, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1975/12/31 23:59:60');

# 206
is($instance->in_leap_second, 1);

# 207
$instance = $instance->add_hours(1);
is($instance->as_string('%c'), '1976/01/01 01:00:00');

# 208
is($instance->in_leap_second, 0);

# 209
$instance = $class->from_utc(1976, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1976/12/31 23:59:60');

# 210
is($instance->in_leap_second, 1);

# 211
$instance = $instance->add_months(-1);
is($instance->as_string('%c'), '1976/11/30 23:59:59');

# 212
is($instance->in_leap_second, 0);

# 213
$instance = $class->from_utc(1976, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1976/12/31 23:59:60');

# 214
is($instance->in_leap_second, 1);

# 215
$instance = $instance->add_months(1);
is($instance->as_string('%c'), '1977/02/01 00:00:00');

# 216
is($instance->in_leap_second, 0);

# 217
$instance = $class->from_utc(1977, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1977/12/31 23:59:60');

# 218
is($instance->in_leap_second, 1);

# 219
$instance = $instance->add_years(-1);
is($instance->as_string('%c'), '1976/12/31 23:59:59');

# 220
is($instance->in_leap_second, 0);

# 221
$instance = $class->from_utc(1977, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1977/12/31 23:59:60');

# 222
is($instance->in_leap_second, 1);

# 223
$instance = $instance->add_years(1);
is($instance->as_string('%c'), '1979/01/01 00:00:00');

# 224
is($instance->in_leap_second, 0);

done_testing();

__END__