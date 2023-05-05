#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 42;

use ATLib::Std::DateTime::Year;

#1
my $class = q{ATLib::Std::DateTime::Month};
use_ok($class);

#2
my $year = 2022;
my $class_year = q{ATLib::Std::DateTime::Year};
my $year_ref = ATLib::Std::DateTime::Year->from($class_year->to_epoch($year));
my $month = 11;

is($class->to_epoch($month), $month - 1);

#3
my $instance = $class->from($year_ref, $class->to_epoch($month));
isa_ok($instance, $class);

#4
is($instance->year, $year);

#5
is($instance->month, $month);

#6
is($instance->last_day, 30);

#7
$month = 4;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 30);

#8
$month = 6;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 30);

#9
$month = 9;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 30);

#10
$month = 1;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#11
$month = 3;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#12
$month = 5;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#13
$month = 7;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#14
$month = 8;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#15
$month = 10;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#16
$month = 12;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#17
$month = 2;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($class_year->is_leap_year($year), 0);

#18
is($instance->last_day, 28);

#19
$year = 2020;
$month = 2;
$year_ref = $class_year->from($class_year->to_epoch($year));
$instance = $class->from($year_ref, $class->to_epoch($month));
is($class_year->is_leap_year($year), 1);

#20
is($instance->last_day, 29);

#21
$month += 1; #3
my $carry = $instance->add(1);
is($carry, 0);

#22
is($instance->month, $month);

#23
$month += 10; #3 + 10 = 13
$month %= 12; #1
$carry = $instance->add(10);
is($carry, 1);

#24
is($instance->month, $month);

#25
$year += $carry; #2021
is($instance->year, $year);

#26
$month = 3; #(12 +) 1 - 10 = 3
$carry = $instance->add(-10);
is($carry, -1);

#27
is($instance->month, $month);

#28
$year += $carry; #2020 + (-1)
is($instance->year, $year);

#29
$month += 1; #4
$carry = $instance->add(1);
is($carry, 0);

#30
is($instance->month, $month);

#31
$month -= 2; #2
$carry = $instance->subtract(2);
is($carry, 0);

#32
is($instance->month, $month);

#33
$month += 1; #3
$carry = $instance->inc();
is($carry, 0);

#34
is($instance->month, $month);

#35
$month -= 1; #2
$carry = $instance->dec();
is($carry, 0);

#36
is($instance->month, $month);

#37
$month = 12; #(12 +) 2 - 2 = 12
$carry = $instance->subtract(2);
is($carry, -1);

#38
is($instance->month, $month);

#39
$year += $carry;
is($instance->year, $year);

#40
$month = 2; #12 + 2 (- 12) = 2
$carry = $instance->add(2);
is($carry, 1);

#41
is($instance->month, $month);

#42
$year += $carry;
is($instance->year, $year);

done_testing();

__END__