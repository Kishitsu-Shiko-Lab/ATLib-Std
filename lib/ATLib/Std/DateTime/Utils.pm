package ATLib::Std::DateTime::Utils;
use Mouse;
extends 'ATLib::Std::Any';

use ATLib::Std::Collections::Dictionary;
use ATLib::Std::DateTime::Second;

# The table of leap seconds (UTC)
my $leap_seconds_utc_year_of = ATLib::Std::Collections::Dictionary->of(q{Int}, q{ATLib::Std::Collections::Dictionary});
{
    my $class = __PACKAGE__;
    # 1972
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1972, 6, 1);
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1972, 12, 1);
    # 1973
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1973, 12, 1);
    # 1974
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1974, 12, 1);
    # 1975
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1975, 12, 1);
    # 1976
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1976, 12, 1);
    # 1977
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1977, 12, 1);
    # 1978
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1978, 12, 1);
    # 1979
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1979, 12, 1);
    # 1981
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1981, 6, 1);
    # 1982
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1982, 6, 1);
    # 1983
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1983, 6, 1);
    # 1985
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1985, 6, 1);
    # 1987
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1987, 12, 1);
    # 1989
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1989, 12, 1);
    # 1990
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1990, 12, 1);
    # 1992
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1992, 6, 1);
    # 1993
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1993, 6, 1);
    # 1994
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1994, 6, 1);
    # 1995
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1995, 12, 1);
    # 1997
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1997, 6, 1);
    # 1998
    $class->_insert_leap_seconds_utc_with_year_of_month_of(1998, 12, 1);
    # 2005
    $class->_insert_leap_seconds_utc_with_year_of_month_of(2005, 12, 1);
    # 2008
    $class->_insert_leap_seconds_utc_with_year_of_month_of(2008, 12, 1);
    # 2012
    $class->_insert_leap_seconds_utc_with_year_of_month_of(2012, 6, 1);
    # 2015
    $class->_insert_leap_seconds_utc_with_year_of_month_of(2015, 6, 1);
    # 2016
    $class->_insert_leap_seconds_utc_with_year_of_month_of(2016, 12, 1);
}

# Class Methods
sub _insert_leap_seconds_utc_with_year_of_month_of
{
    my $class = shift;
    my $year = shift;
    my $month = shift;
    my $seconds = shift;

    my $leap_seconds_utc_year_of_month_of;
    if ($leap_seconds_utc_year_of->contains_key($year))
    {
        $leap_seconds_utc_year_of_month_of = $leap_seconds_utc_year_of->item($year);
        $leap_seconds_utc_year_of_month_of->add($month, $seconds);
    }
    else
    {
        $leap_seconds_utc_year_of_month_of = ATLib::Std::Collections::Dictionary->of(q{Int}, q{Int});
        $leap_seconds_utc_year_of_month_of->add($month, $seconds);
        $leap_seconds_utc_year_of->add($year, $leap_seconds_utc_year_of_month_of);
    }
    return;
}

sub get_leap_seconds_utc
{
    my $class = shift;
    my $second_ref = shift;

    if ($leap_seconds_utc_year_of->contains_key($second_ref->year))
    {
        my $leap_seconds_utc_year_of_month_of = $leap_seconds_utc_year_of->item($second_ref->year);
        if ($leap_seconds_utc_year_of_month_of->contains_key($second_ref->month))
        {
            if ($second_ref->day == $second_ref->last_day
                && $second_ref->hour == 23 && $second_ref->minute == 59)
            {
                return $leap_seconds_utc_year_of_month_of->item($second_ref->month);
            }
        }
    }
    return 0;
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;

=encoding utf8

=head1 名前

ATLib::Std::DateTime::Utils - ATLib::Std::DateTimeの部分管理クラスで使用するユーティリティ

=head1 バージョン

この文書は ATLib::Std version v0.4.0 について説明しています。

=head1 概要

    use ATLib::Std::DateTime::Year;
    use ATLib::Std::DateTime::Month;
    use ATLib::Std::DateTime::Day;
    use ATLib::Std::DateTime::Hour;
    use ATLib::Std::DateTime::Minute;
    use ATLib::Std::DateTime::Second;
    use ATLib::Std::DateTime::Utils;

    # このクラスは ATLib::Std::DateTime::Second から使用されることを想定
    my $year = 2023;
    my $year_ref = ATLib::Std::DateTime::Year->from($year - 1900); # Perl epoch year
    my $month = 2;
    my $month_ref = ATLib::Std::DateTime::Month->from($year_ref, $month - 1); # Perl epoch month
    my $day = 2;
    my $day_ref = ATLib::Std::DateTime::Day->from($month_ref, $day - 1); # Perl epoch day
    my $hour = 6;
    my $hour_ref = ATLib::Std::DateTime::Hour->from($day_ref, $hour);
    my $minute = 53;
    my $minute_ref = ATLib::Std::DateTime::Minute->from($hour_ref, $minute);
    my $second = 24;
    my $second_ref = ATLib::Std::DateTime::Second->from($minute_ref, $second);

    my $leap_seconds = ATLib::Std::DateTime::Utils->get_leap_seconds_utc($second_ref);

=head1 基底クラス

L<< ATLib::Std::Any >>

=head1 クラスメソッド

=head2 C<< $leap_second = $class->get_leap_seconds_utc($seconds_ref); -E<gt> Int >>

$second_refが包含する年、月、日、時、分の閏秒を取得します。
$second_refは協定世界時(UTC)である必要があります。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2025 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut