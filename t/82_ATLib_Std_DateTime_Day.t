#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 33;

use ATLib::Std::DateTime::Year;
use ATLib::Std::DateTime::Month;

#1
my $class = q{ATLib::Std::DateTime::Day};
use_ok($class);

#2
my $year = 2022;
my $class_year = q{ATLib::Std::DateTime::Year};
my $year_ref = $class_year->from($class_year->to_epoch($year));

my $month = 12;
my $class_month = q{ATLib::Std::DateTime::Month};
my $month_ref = $class_month->from($year_ref, $class_month->to_epoch($month));

my $day = 7;
is($class->to_epoch($day), $day - 1);

#3
my $instance = $class->from($month_ref, $class->to_epoch($day));
isa_ok($instance, $class);

#4
is($instance->year, $year);

#5
is($instance->month, $month);

#6
is($instance->day, $day);

#7
is($instance->last_day, 31);

#8
$day += 10; #17 (2022/12/17)
my $carry = $instance->add(10);
is($carry, 0);

#9
is($instance->day, $day);

#10
$day += 15; #32
$day %= 31; #1
$carry = $instance->add(15);
is($carry, 1);

#11
$month += 1;  #13
$month %= 12; #1
is($instance->month, $month);

#12
$year += 1; #2023
is($instance->year, $year);

#13
is($instance->day, $day);

#14
$day += 1; #2 (2023/01/02)
$carry = $instance->inc();
is($carry, 0);

#15
is($instance->year, $year);

#16
is($instance->month, $month);

#17
is($instance->day, $day);

#18
$day -= 1; #1 (2023/01/01)
$carry = $instance->subtract(1);
is($carry, 0);

#19
is($instance->year, $year);

#20
is($instance->month, $month);

#21
is($instance->day, $day);

#22
$day = 31; #31 (2022/12/31)
$month = 12;
$year -= 1; #2022
$carry = $instance->dec();
is($carry, -1);

#23
is($instance->year, $year);

#24
is($instance->month, $month);

#25
is($instance->day, $day);

#26
$day -= -5; #31 - (-5) = 36
$day %= 31; #5 (2023/01/05)
$month += 1; #13
$month %= 12; #1
$year += 1; #2023
$carry = $instance->subtract(-5);
is($carry, 1);

#27
is($instance->year, $year);

#28
is($instance->month, $month);

#29
is($instance->day, $day);

#30
$day += -6; #1 + (-6) = -5
$day += 31; #26 (2022/12/26)
$month -= 1; #0
$month += 12; #12
$year -= 1; #2022
$carry = $instance->add(-6);
is($carry, -1);

#31
is($instance->year, $year);

#32
is($instance->month, $month);

#33
is($instance->day, $day);

done_testing();

__END__