#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 43;

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
is($instance->type_name, $class);

#5
is($instance->year, $year);

#6
is($instance->month, $month);

#7
is($instance->last_day, 30);

#8
$month = 4;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 30);

#9
$month = 6;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 30);

#10
$month = 9;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 30);

#11
$month = 1;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#12
$month = 3;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#13
$month = 5;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#14
$month = 7;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#15
$month = 8;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#16
$month = 10;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#17
$month = 12;
$instance = $class->from($year_ref, $class->to_epoch($month));
is($instance->last_day, 31);

#18
$month = 2;
$instance = $class->from($year_ref, $class->to_epoch($month));
ok(!$class_year->is_leap_year($year));

#19
is($instance->last_day, 28);

#20
$year = 2020;
$month = 2;
$year_ref = $class_year->from($class_year->to_epoch($year));
$instance = $class->from($year_ref, $class->to_epoch($month));
ok($class_year->is_leap_year($year));

#21
is($instance->last_day, 29);

#22
$month += 1; #3
my $carry = $instance->add(1);
is($carry, 0);

#23
is($instance->month, $month);

#24
$month += 10; #3 + 10 = 13
$month %= 12; #1
$carry = $instance->add(10);
is($carry, 1);

#25
is($instance->month, $month);

#26
$year += $carry; #2021
is($instance->year, $year);

#27
$month = 3; #(12 +) 1 - 10 = 3
$carry = $instance->add(-10);
is($carry, -1);

#28
is($instance->month, $month);

#29
$year += $carry; #2020 + (-1)
is($instance->year, $year);

#30
$month += 1; #4
$carry = $instance->add(1);
is($carry, 0);

#31
is($instance->month, $month);

#32
$month -= 2; #2
$carry = $instance->subtract(2);
is($carry, 0);

#33
is($instance->month, $month);

#34
$month += 1; #3
$carry = $instance->inc();
is($carry, 0);

#35
is($instance->month, $month);

#36
$month -= 1; #2
$carry = $instance->dec();
is($carry, 0);

#37
is($instance->month, $month);

#38
$month = 12; #(12 +) 2 - 2 = 12
$carry = $instance->subtract(2);
is($carry, -1);

#39
is($instance->month, $month);

#40
$year += $carry;
is($instance->year, $year);

#41
$month = 2; #12 + 2 (- 12) = 2
$carry = $instance->add(2);
is($carry, 1);

#42
is($instance->month, $month);

#43
$year += $carry;
is($instance->year, $year);

done_testing();

__END__