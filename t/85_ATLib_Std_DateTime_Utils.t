#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 101;

use ATLib::Std::DateTime::Year;
use ATLib::Std::DateTime::Month;
use ATLib::Std::DateTime::Day;
use ATLib::Std::DateTime::Hour;
use ATLib::Std::DateTime::Minute;
use ATLib::Std::DateTime::Second;

#1
my $class = q{ATLib::Std::DateTime::Utils};
use_ok($class);

# Utility
sub build_second_ref
{
    my ($year, $month, $day, $hour, $minute, $second) = @_;
    my $year_ref = ATLib::Std::DateTime::Year->from(ATLib::Std::DateTime::Year->to_epoch($year));
    my $month_ref = ATLib::Std::DateTime::Month->from($year_ref, ATLib::Std::DateTime::Month->to_epoch($month));
    my $day_ref = ATLib::Std::DateTime::Day->from($month_ref, ATLib::Std::DateTime::Day->to_epoch($day));
    my $hour_ref = ATLib::Std::DateTime::Hour->from($day_ref, $hour);
    my $minute_ref = ATLib::Std::DateTime::Minute->from($hour_ref, $minute);
    my $second_ref = ATLib::Std::DateTime::Second->from($minute_ref, $second);

    return $second_ref;
}

# -- 1972 (June)
# 2 (Before)
my $second_ref = build_second_ref(1972, 6, 30, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 3
$second_ref = build_second_ref(1972, 6, 30, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 4
$second_ref = build_second_ref(1972, 6, 30, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 5 (After)
$second_ref = build_second_ref(1972, 7, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1972 (December)
# 6 (Before)
$second_ref = build_second_ref(1972, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 7
$second_ref = build_second_ref(1972, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 8
$second_ref = build_second_ref(1972, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 9 (After)
$second_ref = build_second_ref(1973, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1973 (December)
# 10 (Before)
$second_ref = build_second_ref(1973, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 11
$second_ref = build_second_ref(1973, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 12
$second_ref = build_second_ref(1973, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 13 (After)
$second_ref = build_second_ref(1974, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1974 (December)
# 14 (Before)
$second_ref = build_second_ref(1974, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 15
$second_ref = build_second_ref(1974, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 16
$second_ref = build_second_ref(1974, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 17 (After)
$second_ref = build_second_ref(1975, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1975 (December)
# 18 (Before)
$second_ref = build_second_ref(1975, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 19
$second_ref = build_second_ref(1975, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 20
$second_ref = build_second_ref(1975, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 21 (After)
$second_ref = build_second_ref(1976, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1976 (December)
# 22 (Before)
$second_ref = build_second_ref(1976, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 23
$second_ref = build_second_ref(1976, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 24
$second_ref = build_second_ref(1976, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 25 (After)
$second_ref = build_second_ref(1977, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1977 (December)
# 26 (Before)
$second_ref = build_second_ref(1977, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 27
$second_ref = build_second_ref(1977, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 28
$second_ref = build_second_ref(1977, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 29 (After)
$second_ref = build_second_ref(1978, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1978 (December)
# 30 (Before)
$second_ref = build_second_ref(1978, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 31
$second_ref = build_second_ref(1978, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 32
$second_ref = build_second_ref(1978, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 33 (After)
$second_ref = build_second_ref(1979, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1979 (December)
# 34 (Before)
$second_ref = build_second_ref(1979, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 35
$second_ref = build_second_ref(1979, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 36
$second_ref = build_second_ref(1979, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 37 (After)
$second_ref = build_second_ref(1980, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1981 (June)
# 38 (Before)
$second_ref = build_second_ref(1981, 6, 30, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 39
$second_ref = build_second_ref(1981, 6, 30, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 40
$second_ref = build_second_ref(1981, 6, 30, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 41 (After)
$second_ref = build_second_ref(1981, 7, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1982 (June)
# 42 (Before)
$second_ref = build_second_ref(1982, 6, 30, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 43
$second_ref = build_second_ref(1982, 6, 30, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 44
$second_ref = build_second_ref(1982, 6, 30, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 45 (After)
$second_ref = build_second_ref(1982, 7, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1983 (June)
# 46 (Before)
$second_ref = build_second_ref(1983, 6, 30, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 47
$second_ref = build_second_ref(1983, 6, 30, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 48
$second_ref = build_second_ref(1983, 6, 30, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 49 (After)
$second_ref = build_second_ref(1983, 7, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1985 (June)
# 50 (Before)
$second_ref = build_second_ref(1985, 6, 30, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 51
$second_ref = build_second_ref(1985, 6, 30, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 52
$second_ref = build_second_ref(1985, 6, 30, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 53 (After)
$second_ref = build_second_ref(1985, 7, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1987 (December)
# 54 (Before)
$second_ref = build_second_ref(1987, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 55
$second_ref = build_second_ref(1987, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 56
$second_ref = build_second_ref(1987, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 57 (After)
$second_ref = build_second_ref(1988, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1989 (December)
# 58 (Before)
$second_ref = build_second_ref(1989, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 59
$second_ref = build_second_ref(1989, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 60
$second_ref = build_second_ref(1989, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 61 (After)
$second_ref = build_second_ref(1990, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1990 (December)
# 62 (Before)
$second_ref = build_second_ref(1990, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 63
$second_ref = build_second_ref(1990, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 64
$second_ref = build_second_ref(1990, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 65 (After)
$second_ref = build_second_ref(1991, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1992 (June)
# 66 (Before)
$second_ref = build_second_ref(1992, 6, 30, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 67
$second_ref = build_second_ref(1992, 6, 30, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 68
$second_ref = build_second_ref(1992, 6, 30, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 69 (After)
$second_ref = build_second_ref(1992, 7, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1993 (June)
# 70 (Before)
$second_ref = build_second_ref(1993, 6, 30, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 71
$second_ref = build_second_ref(1993, 6, 30, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 72
$second_ref = build_second_ref(1993, 6, 30, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 73 (After)
$second_ref = build_second_ref(1993, 7, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1994 (June)
# 74 (Before)
$second_ref = build_second_ref(1994, 6, 30, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 75
$second_ref = build_second_ref(1994, 6, 30, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 76
$second_ref = build_second_ref(1994, 6, 30, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 77 (After)
$second_ref = build_second_ref(1994, 7, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 1998 (December)
# 78 (Before)
$second_ref = build_second_ref(1998, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 79
$second_ref = build_second_ref(1998, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 80
$second_ref = build_second_ref(1998, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 81 (After)
$second_ref = build_second_ref(1999, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 2005 (December)
# 82 (Before)
$second_ref = build_second_ref(2005, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 83
$second_ref = build_second_ref(2005, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 84
$second_ref = build_second_ref(2005, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 85 (After)
$second_ref = build_second_ref(2006, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 2008 (December)
# 86 (Before)
$second_ref = build_second_ref(2008, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 87
$second_ref = build_second_ref(2008, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 88
$second_ref = build_second_ref(2008, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 89 (After)
$second_ref = build_second_ref(2009, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 2012 (June)
# 90 (Before)
$second_ref = build_second_ref(2012, 6, 30, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 91
$second_ref = build_second_ref(2012, 6, 30, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 92
$second_ref = build_second_ref(2012, 6, 30, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 93 (After)
$second_ref = build_second_ref(2012, 7, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 2015 (June)
# 94 (Before)
$second_ref = build_second_ref(2015, 6, 30, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 95
$second_ref = build_second_ref(2015, 6, 30, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 96
$second_ref = build_second_ref(2015, 6, 30, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 97 (After)
$second_ref = build_second_ref(2015, 7, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

# -- 2016 (December)
# 98 (Before)
$second_ref = build_second_ref(2016, 12, 31, 23, 58, 59);
is($class->get_leap_seconds_utc($second_ref), 0);

# 99
$second_ref = build_second_ref(2016, 12, 31, 23, 59, 0);
is($class->get_leap_seconds_utc($second_ref), 1);

# 100
$second_ref = build_second_ref(2016, 12, 31, 23, 59, 59);
is($class->get_leap_seconds_utc($second_ref), 1);

# 101 (After)
$second_ref = build_second_ref(2017, 1, 1, 0, 0, 0);
is($class->get_leap_seconds_utc($second_ref), 0);

done_testing();
__END__