#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 276;
use Test::Exception;

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
ok(!$instance->is_utc);

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
ok($instance->is_utc);

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
ok($class->is_leap_year($leap_year));

#30
#2004/02/28 23:59:59
$instance = $class->from($leap_year, 2, 28, 23, 59, 59);
isa_ok($instance, $class);

#31
ok(!$instance->is_utc);

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
ok(!$class->is_leap_year($leap_year));

# But can divide 400 then leap year.
#169
$leap_year = 2000;
ok($class->is_leap_year($leap_year));

# The others then not leap year.
#170
$leap_year = 2022;
ok(!$class->is_leap_year($leap_year));

# Test for leap seconds
# 171
$instance = $class->from_utc(1972, 6, 30, 23, 58, 0);
$instance = $instance->add_minutes(1);
is($instance->as_string('%c'), '1972/06/30 23:59:00');

# 172
ok(!$instance->in_leap_second);

# 173
$epoch_sec = $instance->unix_time;
$instance = $instance->add_seconds(60);
$epoch_sec += 59;
is($instance->second, 60);

# 174
is($instance->unix_time, $epoch_sec);

# 175
ok($instance->in_leap_second);

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
ok($instance->in_leap_second);

# 183
$instance = $instance->add_seconds(-1);
is($instance->as_string('%c'), '1972/12/31 23:59:59');

# 184
ok(!$instance->in_leap_second);

# 185
$instance = $instance->add_seconds(2);
is($instance->as_string('%c'), '1973/01/01 00:00:00');

# 186
$instance = $class->from_utc(1973, 12, 31, 23, 58, 0);
$instance = $instance->add_seconds(120);
is($instance->as_string('%c'), '1973/12/31 23:59:60');

# 187
ok($instance->in_leap_second);

# 188
$instance = $instance->add_minutes(-1);
is($instance->as_string('%c'), '1973/12/31 23:58:59');

# 189
ok(!$instance->in_leap_second);

# 190
$instance = $instance->add_minutes(1)->add_seconds(1);
is($instance->as_string('%c'), '1973/12/31 23:59:60');

# 191
ok($instance->in_leap_second);

# 192
$instance = $instance->add_minutes(1);
is($instance->as_string('%c'), '1974/01/01 00:01:00');

# 193
ok(!$instance->in_leap_second);

# 194
$instance = $class->from_utc(1974, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1974/12/31 23:59:60');

# 195
ok($instance->in_leap_second);

# 196
$instance = $instance->add_hours(-1);
is($instance->as_string('%c'), '1974/12/31 22:59:59');

# 197
ok(!$instance->in_leap_second);

# 198
$instance = $class->from_utc(1974, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1974/12/31 23:59:60');

# 199
ok($instance->in_leap_second,);

# 200
$instance = $instance->add_hours(1);
is($instance->as_string('%c'), '1975/01/01 01:00:00');

# 201
ok(!$instance->in_leap_second);

# 202
$instance = $class->from_utc(1975, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1975/12/31 23:59:60');

# 203
ok($instance->in_leap_second);

# 204
$instance = $instance->add_days(-1);
is($instance->as_string('%c'), '1975/12/30 23:59:59');

# 205
ok(!$instance->in_leap_second);

# 206
$instance = $class->from_utc(1975, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1975/12/31 23:59:60');

# 207
ok($instance->in_leap_second);

# 208
$instance = $instance->add_hours(1);
is($instance->as_string('%c'), '1976/01/01 01:00:00');

# 209
ok(!$instance->in_leap_second);

# 210
$instance = $class->from_utc(1976, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1976/12/31 23:59:60');

# 211
ok($instance->in_leap_second);

# 212
$instance = $instance->add_months(-1);
is($instance->as_string('%c'), '1976/11/30 23:59:59');

# 213
ok(!$instance->in_leap_second);

# 214
$instance = $class->from_utc(1976, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1976/12/31 23:59:60');

# 215
ok($instance->in_leap_second);

# 216
$instance = $instance->add_months(1);
is($instance->as_string('%c'), '1977/02/01 00:00:00');

# 217
ok(!$instance->in_leap_second);

# 218
$instance = $class->from_utc(1977, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1977/12/31 23:59:60');

# 219
ok($instance->in_leap_second);

# 220
$instance = $instance->add_years(-1);
is($instance->as_string('%c'), '1976/12/31 23:59:59');

# 221
ok(!$instance->in_leap_second);

# 222
$instance = $class->from_utc(1977, 12, 31, 23, 59, 59);
$instance = $instance->add_seconds(1);
is($instance->as_string('%c'), '1977/12/31 23:59:60');

# 223
ok($instance->in_leap_second);

# 224
$instance = $instance->add_years(1);
is($instance->as_string('%c'), '1979/01/01 00:00:00');

# 225
ok(!$instance->in_leap_second);

# $class->parse_exact();
# 226
my $message = 'Argument is not specified.';
throws_ok { $class->parse_exact(); } qr/$message/, q{Argument $target is not specified.};

# 227
$year = 2024;
$month = 10;
$day = 7;
my $target = sprintf(q{%04d/%02d/%02d}, $year, $month, $day);
throws_ok { $class->parse_exact($target); } qr/$message/, q{Argument $format is not specified.};

# 228
$instance = $class->parse_exact($target, 'yyyy/MM/dd');
isa_ok($instance, $class);

# 229
is($instance->as_string('%c'), '2024/10/07 00:00:00');

# 230
$hour = 6;
$min = 35;
$sec = 6;
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d}, $year, $month, $day, $hour, $min, $sec);
$message = 'Specified \$format is invalid length.';
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd'); } qr/$message/, q{Argument $format is invalid length.};

# 231
$instance = $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss');
isa_ok($instance, $class);

# 232
is($instance->as_string('%c'), '2024/10/07 06:35:06');

# 233
$micro_sec = 123_456;
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d.%06d}, $year, $month, $day, $hour, $min, $sec, $micro_sec);
$instance = $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.ffffff');
isa_ok($instance, $class);

# 234
is($instance->as_string('%c'), '2024/10/07 06:35:06');

# 235
is($instance->micro_second, $micro_sec);

# 236
$instance = $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.FFFFFF');
isa_ok($instance, $class);

# 237
is($instance->as_string('%c'), '2024/10/07 06:35:06');

# 238
is($instance->micro_second, $micro_sec);

# 239
my $milli_sec = 638;
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d.%03d}, $year, $month, $day, $hour, $min, $sec, $milli_sec);
$instance = $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.fff');
isa_ok($instance, $class);

# 240
is($instance->as_string('%c'), '2024/10/07 06:35:06');

# 241
is($instance->milli_second, $milli_sec);

# 242
$instance = $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.FFF');
isa_ok($instance, $class);

# 243
is($instance->as_string('%c'), '2024/10/07 06:35:06');

# 244
is($instance->milli_second, $milli_sec);

# 245
$message = 'Specified \$format `yyyy` is duplicated.';
$target = sprintf(q{%04d/%02d/%02d %04d}, $year, $month, $day, $year);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd yyyy'); } qr/$message/, q{Check duplicate the $format `yyyy`.};

# 246
$message = 'The \$target is not include year\(yyyy\) string.';
$target = sprintf(q{YYYY/%02d/%02d}, $month, $day);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd'); } qr/$message/, q{Check invalid the $target to replace the $format `yyyy`.};

# 247
$message = 'Specified \$format `MM` is duplicated.';
$target = sprintf(q{%04d/%02d/%02d %02d}, $year, $month, $day, $month);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd MM'); } qr/$message/, q{Check duplicate the $format `MM`.};

# 248
$message = 'The \$target is not include month\(MM\) string.';
$target = sprintf(q{%4d/MM/%02d}, $year, $day);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd'); } qr/$message/, q{Check invalid the $target to replace the $format `MM`.};

# 249
$month = 0;
$target = sprintf(q{%4d/%2d/%02d}, $year, $month, $day);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd'); } qr/$message/, q{Check invalid the $target to replace the $format `MM`.};

# 250
$month = 13;
$target = sprintf(q{%4d/%2d/%02d}, $year, $month, $day);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd'); } qr/$message/, q{Check invalid the $target to replace the $format `MM`.};

# 251
$month = 10;
$day = 7;
$message = 'Specified \$format `dd` is duplicated.';
$target = sprintf(q{%04d/%02d/%02d %02d}, $year, $month, $day, $day);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd dd'); } qr/$message/, q{Check duplicate the $format `dd`.};

# 252
$message = 'The \$target is not include day\(dd\) string.';
$target = sprintf(q{%4d/%2d/dd}, $year, $month);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd'); } qr/$message/, q{Check invalid the $target to replace the $format `dd`.};

# 253
$day = 0;
$target = sprintf(q{%4d/%2d/%02d}, $year, $month, $day);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd'); } qr/$message/, q{Check invalid the $target to replace the $format `dd`.};

# 254
$day = 32;
$target = sprintf(q{%4d/%2d/%02d}, $year, $month, $day);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd'); } qr/$message/, q{Check invalid the $target to replace the $format `dd`.};

# 255
$month = 10;
$day = 7;
$message = 'Specified \$format `HH` is duplicated.';
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d %02d}, $year, $month, $day, $hour, $min, $sec, $hour);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss HH'); } qr/$message/, q{Check duplicate the $format `HH`.};

# 256
$message = 'The \$target is not include hour\(HH\) string.';
$target = sprintf(q{%04d/%02d/%02d HH:%02d:%02d}, $year, $month, $day, $min, $sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss'); } qr/$message/, q{Check invalid the $target to replace the $format `HH`.};

# 257
$hour = -1;
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d}, $year, $month, $day, $hour, $min, $sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss'); } qr/$message/, q{Check invalid the $target to replace the $format `HH`.};

# 258
$hour = 60;
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d}, $year, $month, $day, $hour, $min, $sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss'); } qr/$message/, q{Check invalid the $target to replace the $format `HH`.};

# 259
$month = 10;
$day = 7;
$hour = 6;
$message = 'Specified \$format `mm` is duplicated.';
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d %02d}, $year, $month, $day, $hour, $min, $sec, $min);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss mm'); } qr/$message/, q{Check duplicate the $format `mm`.};

# 260
$message = 'The \$target is not include minute\(mm\) string.';
$target = sprintf(q{%04d/%02d/%02d %02d:mm:%02d}, $year, $month, $day, $hour, $sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss'); } qr/$message/, q{Check invalid the $target to replace the $format `mm`.};

# 261
$min = -1;
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d}, $year, $month, $day, $hour, $min, $sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss'); } qr/$message/, q{Check invalid the $target to replace the $format `mm`.};

# 262
$min = 60;
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d}, $year, $month, $day, $hour, $min, $sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss'); } qr/$message/, q{Check invalid the $target to replace the $format `mm`.};

# 263
$month = 10;
$day = 7;
$hour = 6;
$min = 35;
$message = 'Specified \$format `ss` is duplicated.';
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d %02d}, $year, $month, $day, $hour, $min, $sec, $sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss ss'); } qr/$message/, q{Check duplicate the $format `ss`.};

# 264
$message = 'The \$target is not include second\(ss\) string.';
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:ss}, $year, $month, $day, $hour, $min);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss'); } qr/$message/, q{Check invalid the $target to replace the $format `ss`.};

# 265
$sec = -1;
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d}, $year, $month, $day, $hour, $min, $sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss'); } qr/$message/, q{Check invalid the $target to replace the $format `ss`.};

# 266
$sec = 61;
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d}, $year, $month, $day, $hour, $min, $sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss'); } qr/$message/, q{Check invalid the $target to replace the $format `ss`.};

# 267
$month = 10;
$day = 7;
$hour = 6;
$min = 35;
$sec = 6;
$milli_sec = 123;
$micro_sec = 123_456;
$message = 'The \$format `fff\|FFF` is already specified.';
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d.%03d %06d}, $year, $month, $day, $hour, $min, $sec, $milli_sec, $micro_sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.fff ffffff');} qr/$message/, q{Check already specified $format `fff`};

# 268
$message = 'The \$format `ffffff|FFFFFF` is duplicated.';
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d.%06d %06d}, $year, $month, $day, $hour, $min, $sec, $micro_sec, $micro_sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.ffffff ffffff');} qr/$message/, q{Check duplicate the $format `ffffff`};

# 269
$message = 'The \$target is not include micro second\(ffffff\|FFFFFF\) string.';
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d.ffffff}, $year, $month, $day, $hour, $min, $sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.ffffff');} qr/$message/, q{Check duplicate the $format `ffffff`};

# 270
$micro_sec = -1;
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d.%06d}, $year, $month, $day, $hour, $min, $sec, $micro_sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.ffffff');} qr/$message/, q{Check invalid the $target to replace the $format `ffffff`.};

# 271
$micro_sec = 1_000_000;
$message = 'Invalid format keyword `0` was specified.';
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d.%06d}, $year, $month, $day, $hour, $min, $sec, $micro_sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.ffffff ');} qr/$message/, q{Check invalid the $target to replace the $format `ffffff`.`};

# 272
$month = 10;
$day = 7;
$hour = 6;
$min = 35;
$sec = 6;
$milli_sec = 123;
$micro_sec = 123_456;
$message = 'The \$format `ffffff\|FFFFFF` is already specified.';
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d.%06d %03d}, $year, $month, $day, $hour, $min, $sec, $micro_sec, $milli_sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.ffffff fff');} qr/$message/, q{Check already specified $format `ffffff`};

# 273
$message = 'The \$format `fff|FFF` is duplicated.';
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d.%03d %03d}, $year, $month, $day, $hour, $min, $sec, $milli_sec, $milli_sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.fff fff');} qr/$message/, q{Check duplicate the $format `fff`};

# 274
$message = 'The \$target is not include milli second\(fff\|FFF\) string.';
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d.fff}, $year, $month, $day, $hour, $min, $sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.fff');} qr/$message/, q{Check duplicate the $format `ffffff`};

# 275
$milli_sec = -1;
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d.%03d}, $year, $month, $day, $hour, $min, $sec, $milli_sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.fff');} qr/$message/, q{Check invalid the $target to replace the $format `fff`.};

# 276
$milli_sec = 1_000;
$message = 'Invalid format keyword `0` was specified.';
$target = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d.%03d}, $year, $month, $day, $hour, $min, $sec, $milli_sec);
throws_ok { $class->parse_exact($target, 'yyyy/MM/dd HH:mm:ss.fff ');} qr/$message/, q{Check invalid the $target to replace the $format `fff`.};

done_testing();
__END__