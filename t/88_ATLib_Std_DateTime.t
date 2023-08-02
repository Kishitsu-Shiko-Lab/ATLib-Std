#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 225;

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
is($instance->type_name, $class);

#4
is($instance->is_utc, 0);

#5
is($instance->unix_time, $epoch_sec);

#6
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

#7
is($instance->year, $year + 1900);

#8
is($instance->month, $month + 1);

#9
is($instance->day, $day);

#10
is($instance->hour, $hour);

#11
is($instance->minute, $min);

#12
is($instance->second, $sec);

#13
is($instance->milli_second, int($micro_sec / 1000));

#14
is($instance->day_of_week, $days_of_week);

#15
is($instance->days_of_year, $days_of_year + 1);

#16
($epoch_sec, $micro_sec) = gettimeofday();
$instance = $class->now_utc();
($sec, $min, $hour, $day, $month, $year, $days_of_week, $days_of_year) = gmtime($epoch_sec);
isa_ok($instance, $class);

#17
is($instance->is_utc, 1);

#18
is($instance->unix_time, $epoch_sec);

#19
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

#20
is($instance->year, $year + 1900);

#21
is($instance->month, $month + 1);

#22
is($instance->day, $day);

#23
is($instance->hour, $hour);

#24
is($instance->minute, $min);

#25
is($instance->second, $sec);

#26
is($instance->milli_second, int($micro_sec / 1000));

#27
is($instance->day_of_week, $days_of_week);

#28
is($instance->days_of_year, $days_of_year + 1);

# Test for leap year
# Can divide 4 then leap year.
#29
my $leap_year = 2004;
is($class->is_leap_year($leap_year), 1);

#30
#2004/02/28 23:59:59
$instance = $class->from($leap_year, 2, 28, 23, 59, 59);
isa_ok($instance, $class);

#31
is($instance->is_utc, 0);

#32
is($instance->year, $leap_year);

#33
is($instance->month, 2);

#34
is($instance->day, 28);

#35
is($instance->hour, 23);

#36
is($instance->minute, 59);

#37
is($instance->second, 59);

#38
is($instance->milli_second, 0);

#39
is($instance->micro_second, 0);

#40
#2004/02/29 23:59:59 <- 2004/02/28 23:59:59
$epoch_sec = $instance->unix_time;
my $instance_new = $instance->add_days(1);
$epoch_sec += 60 * 60 * 24;
isa_ok($instance_new, $class);

#41
is($instance_new->unix_time, $epoch_sec);

#42
is($instance_new->year, $leap_year);

#43
is($instance_new->month, 2);

#44
is($instance_new->day, 29);

#45
is($instance_new->hour, 23);

#46
is($instance_new->minute, 59);

#47
is($instance_new->second, 59);

#48
is($instance_new->milli_second, 0);

#49
is($instance_new->micro_second, 0);

#50
#2004/02/29 00:59:59 <- 2004/02/28 23:59:59
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_hours(1);
$epoch_sec += 60 * 60;
isa_ok($instance_new, $class);

#51
is($instance_new->unix_time, $epoch_sec);

#52
is($instance_new->year, $leap_year);

#53
is($instance_new->month, 2);

#54
is($instance_new->day, 29);

#55
is($instance_new->hour, 0);

#56
is($instance_new->minute, 59);

#57
is($instance_new->second, 59);

#58
is($instance_new->milli_second, 0);

#59
is($instance_new->micro_second, 0);

#60
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_minutes(1);
$epoch_sec += 60;
isa_ok($instance_new, $class);

#61
is($instance_new->unix_time, $epoch_sec);

#62
is($instance_new->year, $leap_year);

#63
is($instance_new->month, 2);

#64
is($instance_new->day, 29);

#65
is($instance_new->hour, 0);

#66
is($instance_new->minute, 0);

#67
is($instance_new->second, 59);

#68
is($instance_new->milli_second, 0);

#69
is($instance_new->micro_second, 0);

#70
#2004/02/29 00:00:00 <- 2004/02/28 23:59:59
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_seconds(1);
$epoch_sec += 1;
isa_ok($instance_new, $class);

#71
is($instance_new->unix_time, $epoch_sec);

#72
is($instance_new->year, $leap_year);

#73
is($instance_new->month, 2);

#74
is($instance_new->day, 29);

#75
is($instance_new->hour, 0);

#76
is($instance_new->minute, 0);

#77
is($instance_new->second, 0);

#78
is($instance_new->milli_second, 0);

#79
is($instance_new->micro_second, 0);

#80
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_milli_seconds(1000);
isa_ok($instance_new, $class);

#81
is($instance_new->unix_time, $epoch_sec);

#82
is($instance_new->year, $leap_year);

#83
is($instance_new->month, 2);

#84
is($instance_new->day, 29);

#85
is($instance_new->hour, 0);

#86
is($instance_new->minute, 0);

#87
is($instance_new->second, 0);

#88
is($instance_new->milli_second, 0);

#89
is($instance_new->micro_second, 0);

#90
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_micro_seconds(1000000);
isa_ok($instance_new, $class);

#91
is($instance_new->unix_time, $epoch_sec);

#92
is($instance_new->year, $leap_year);

#93
is($instance_new->month, 2);

#94
is($instance_new->day, 29);

#95
is($instance_new->hour, 0);

#96
is($instance_new->minute, 0);

#97
is($instance_new->second, 0);

#98
is($instance_new->milli_second, 0);

#99
is($instance_new->micro_second, 0);

#100
$instance = $instance_new->copy()->add_days(1);
is($instance->year, $leap_year);

#101
is($instance->month, 3);

#102
is($instance->day, 1);

#103
is($instance->hour, 0);

#104
is($instance->minute, 0);

#105
is($instance->second, 0);

#106
is($instance->milli_second, 0);

#107
is($instance->micro_second, 0);

#108
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_days(-1);
$epoch_sec -= 60 * 60 * 24;
isa_ok($instance_new, $class);

#109
is($instance_new->unix_time, $epoch_sec);

#110
is($instance_new->year, $leap_year);

#111
is($instance_new->month, 2);

#112
is($instance_new->day, 29);

#113
is($instance_new->hour, 0);

#114
is($instance_new->minute, 0);

#115
is($instance_new->second, 0);

#116
is($instance_new->milli_second, 0);

#117
is($instance_new->micro_second, 0);

#118
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_hours(-1);
$epoch_sec -= 60 * 60;
isa_ok($instance_new, $class);

#119
is($instance_new->unix_time, $epoch_sec);

#120
is($instance_new->year, $leap_year);

#121
is($instance_new->month, 2);

#122
is($instance_new->day, 29);

#123
is($instance_new->hour, 23);

#124
is($instance_new->minute, 0);

#125
is($instance_new->second, 0);

#126
is($instance_new->milli_second, 0);

#127
is($instance_new->micro_second, 0);

#128
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_minutes(-1);
$epoch_sec -= 60;
isa_ok($instance_new, $class);

#129
is($instance_new->unix_time, $epoch_sec);

#130
is($instance_new->year, $leap_year);

#131
is($instance_new->month, 2);

#132
is($instance_new->day, 29);

#133
is($instance_new->hour, 23);

#134
is($instance_new->minute, 59);

#135
is($instance_new->second, 0);

#136
is($instance_new->milli_second, 0);

#137
is($instance_new->micro_second, 0);

#138
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_seconds(-1);
$epoch_sec -= 1;
isa_ok($instance_new, $class);

#139
is($instance_new->unix_time, $epoch_sec);

#140
is($instance_new->year, $leap_year);

#141
is($instance_new->month, 2);

#142
is($instance_new->day, 29);

#143
is($instance_new->hour, 23);

#144
is($instance_new->minute, 59);

#145
is($instance_new->second, 59);

#146
is($instance_new->milli_second, 0);

#147
is($instance_new->micro_second, 0);

#148
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_milli_seconds(-1);
isa_ok($instance_new, $class);

#149
is($instance_new->unix_time, $epoch_sec);

#150
is($instance_new->year, $leap_year);

#151
is($instance_new->month, 2);

#152
is($instance_new->day, 29);

#153
is($instance_new->hour, 23);

#154
is($instance_new->minute, 59);

#155
is($instance_new->second, 59);

#156
is($instance_new->milli_second, 999);

#157
is($instance_new->micro_second, 999000);

#158
$epoch_sec = $instance->unix_time;
$instance_new = $instance->add_micro_seconds(-999999);
isa_ok($instance_new, $class);

#159
is($instance_new->unix_time, $epoch_sec);

#160
is($instance_new->year, $leap_year);

#161
is($instance_new->month, 2);

#162
is($instance_new->day, 29);

#163
is($instance_new->hour, 23);

#164
is($instance_new->minute, 59);

#165
is($instance_new->second, 59);

#166
is($instance_new->milli_second, 0);

#167
is($instance_new->micro_second, 1);

# Can divide 4 then leap year, but can divide 100 then no leap year.
#168
$leap_year = 2100;
is($class->is_leap_year($leap_year), 0);

# But can divide 400 then leap year.
#169
$leap_year = 2000;
is($class->is_leap_year($leap_year), 1);

# The others then not leap year.
#170
$leap_year = 2022;
is($class->is_leap_year($leap_year), 0);

# Test for leap seconds
# 171
$instance = $class->from_utc(1972, 6, 30, 23, 58, 0);
$instance = $instance->add_minutes(1);
is($instance->as_string('%c'), '1972/06/30 23:59:00');

# 172
is($instance->in_leap_second, 0);

# 173
$epoch_sec = $instance->unix_time;
$instance = $instance->add_seconds(60);
$epoch_sec += 59;
is($instance->second, 60);

# 174
is($instance->unix_time, $epoch_sec);

# 175
is($instance->in_leap_second, 1);

# 176
is($instance->as_string('%c'), '1972/06/30 23:59:60');

# 177
$epoch_sec = $instance->unix_time;
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/06/30 23:59:59');

# 178
is($instance->unix_time, $epoch_sec);

# 179
$instance = $instance->add_seconds(2);
is($instance->as_string('%c'), '1972/07/01 00:00:00');

# 180
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/06/30 23:59:60');

# 181
$instance = $class->from_utc(1973, 1, 1, 0, 0, 0);
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/12/31 23:59:60');

# 182
is($instance->in_leap_second, 1);

# 183
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/12/31 23:59:59');

# 184
is($instance->in_leap_second, 0);

# 185
$instance = $instance->add_seconds(2);
is($instance->as_string('%c'), '1973/01/01 00:00:00');

# 186
$instance = $class->from_utc(1973, 12, 31, 23, 58, 0);
$instance = $instance->add_seconds(120);
is($instance->as_string('%c'), '1973/12/31 23:59:60');

# 187
is($instance->in_leap_second, 1);

# 188
$instance = $instance->add_minutes(-1);
is($instance->as_string('%c'), '1973/12/31 23:58:59');

# 189
is($instance->in_leap_second, 0);

# 190
$instance = $instance->add_minutes(1)->add_seconds(1);
is($instance->as_string('%c'), '1973/12/31 23:59:60');

# 191
is($instance->in_leap_second, 1);

# 192
$instance = $instance->add_minutes(1);
is($instance->as_string('%c'), '1974/01/01 00:01:00');

# 193
is($instance->in_leap_second, 0);

# 194
$instance = $class->from_utc(1974, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1974/12/31 23:59:60');

# 195
is($instance->in_leap_second, 1);

# 196
$instance = $instance->add_hours(-1);
is($instance->as_string('%c'), '1974/12/31 22:59:59');

# 197
is($instance->in_leap_second, 0);

# 198
$instance = $class->from_utc(1974, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1974/12/31 23:59:60');

# 199
is($instance->in_leap_second, 1);

# 200
$instance = $instance->add_hours(1);
is($instance->as_string('%c'), '1975/01/01 01:00:00');

# 201
is($instance->in_leap_second, 0);

# 202
$instance = $class->from_utc(1975, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1975/12/31 23:59:60');

# 203
is($instance->in_leap_second, 1);

# 204
$instance = $instance->add_days(-1);
is($instance->as_string('%c'), '1975/12/30 23:59:59');

# 205
is($instance->in_leap_second, 0);

# 206
$instance = $class->from_utc(1975, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1975/12/31 23:59:60');

# 207
is($instance->in_leap_second, 1);

# 208
$instance = $instance->add_hours(1);
is($instance->as_string('%c'), '1976/01/01 01:00:00');

# 209
is($instance->in_leap_second, 0);

# 210
$instance = $class->from_utc(1976, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1976/12/31 23:59:60');

# 211
is($instance->in_leap_second, 1);

# 212
$instance = $instance->add_months(-1);
is($instance->as_string('%c'), '1976/11/30 23:59:59');

# 213
is($instance->in_leap_second, 0);

# 214
$instance = $class->from_utc(1976, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1976/12/31 23:59:60');

# 215
is($instance->in_leap_second, 1);

# 216
$instance = $instance->add_months(1);
is($instance->as_string('%c'), '1977/02/01 00:00:00');

# 217
is($instance->in_leap_second, 0);

# 218
$instance = $class->from_utc(1977, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1977/12/31 23:59:60');

# 219
is($instance->in_leap_second, 1);

# 220
$instance = $instance->add_years(-1);
is($instance->as_string('%c'), '1976/12/31 23:59:59');

# 221
is($instance->in_leap_second, 0);

# 222
$instance = $class->from_utc(1977, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1977/12/31 23:59:60');

# 223
is($instance->in_leap_second, 1);

# 224
$instance = $instance->add_years(1);
is($instance->as_string('%c'), '1979/01/01 00:00:00');

# 225
is($instance->in_leap_second, 0);

done_testing();

__END__