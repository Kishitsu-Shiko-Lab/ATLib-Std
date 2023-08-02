package ATLib::Std::DateTime::Second;
use Mouse;
extends 'ATLib::Std::Radix';

use ATLib::Std::Int;
use ATLib::Std::DateTime::Utils;

# Overloads
use overload(
    q{""}    => \&second,
    fallback => 0,
);

# Attributes
has '_minute_ref' => (is => 'ro', isa => 'ATLib::Std::DateTime::Minute', required => 1, writer => '_set__minute_ref');

sub year
{
    my $self = shift;
    return $self->_minute_ref->year;
}

sub month
{
    my $self = shift;
    return $self->_minute_ref->month;
}

sub day
{
    my $self = shift;
    return $self->_minute_ref->day;
}

sub last_day
{
    my $self = shift;
    return $self->_minute_ref->last_day;
}

sub hour
{
    my $self = shift;
    return $self->_minute_ref->hour;
}

sub minute
{
    my $self = shift;
    return $self->_minute_ref->minute;
}

sub second
{
    my $self = shift;
    return ATLib::Std::Int->from($self->value);
}

sub max_second
{
    my $self = shift;
    my $max_second = shift if (scalar(@_));

    if (!defined $max_second)
    {
        return $self->max_value;
    }

    $self->_set_radix($max_second + 1);
    return;
}

# Class Methods
sub from
{
    my $class = shift;
    my $minute_ref = shift;
    my $second = shift;

    if ($second->isa('ATLib::Std::Int'))
    {
        $second = $second->_value;
    }

    return $class->new({
        _minute_ref => $minute_ref,
        radix       => 60,
        value       => $second,
    });
}

sub from_utc
{
    my $class = shift;
    my $minute_ref = shift;
    my $second = shift;

    my $instance = $class->from($minute_ref, $second);
    my $leap_second = ATLib::Std::DateTime::Utils->get_leap_seconds_utc($instance);
    if ($leap_second != 0)
    {
        $instance->max_second(ATLib::Std::Int->value($instance->max_second) + $leap_second);
    }
    return $instance;
}

# Instance Methods
sub inc
{
    my $self = shift;

    if ($self->second + 1 > $self->max_value)
    {
        $self->_minute_ref->inc();
    }

    my $carry = $self->SUPER::inc();

    return $carry;
}

sub inc_utc
{
    my $self = shift;
    if ($self->second + 1 > $self->max_value)
    {
        $self->_minute_ref->inc();
    }

    my $carry = $self->SUPER::inc();

    my $leap_seconds = ATLib::Std::DateTime::Utils->get_leap_seconds_utc($self);
    $self->max_second(59 + $leap_seconds);

    return $carry;
}

sub dec
{
    my $self = shift;

    if ($self->second - 1 < 0)
    {
        $self->_minute_ref->dec();
    }

    my $carry = $self->SUPER::dec();

    return $carry;
}

sub dec_utc
{
    my $self = shift;

    if ($self->second - 1 < 0)
    {
        $self->_minute_ref->dec();

        my $leap_seconds = ATLib::Std::DateTime::Utils->get_leap_seconds_utc($self);
        $self->max_second(59 + $leap_seconds);
    }

    my $carry = $self->SUPER::dec();

    return $carry;
}

sub add
{
    my $self = shift;
    my $seconds = shift;

    my $carry = 0;
    if ($seconds == 0)
    {
        return $carry;
    }

    if ($seconds < 0)
    {
        return $self->subtract(-$seconds);
    }

    my $i = $seconds;
    while ($i > 0)
    {
        if ($i > $self->max_value)
        {
            my $pack = $self->max_value - $self->value;
            $self->SUPER::add($pack);
            $i -= $pack;
        }
        $carry += $self->inc();
        --$i;
    }
    return $carry;
}

sub add_utc
{
    my $self = shift;
    my $seconds = shift;

    my $carry = 0;
    if ($seconds == 0)
    {
        return $carry;
    }

    if ($seconds < 0)
    {
        return $self->subtract_utc(-$seconds);
    }

    my $i = $seconds;
    while ($i > 0)
    {
        if (ATLib::Std::DateTime::Utils->get_leap_seconds_utc($self) == 0)
        {
            if ($i > $self->max_value)
            {
                my $pack = $self->max_value - $self->value;
                $self->SUPER::add($pack);
                $i -= $pack;
            }
        }
        $carry += $self->inc_utc();
        --$i;
    }
    return $carry;
}

sub subtract
{
    my $self = shift;
    my $seconds = shift;

    my $carry = 0;
    if ($seconds == 0)
    {
        return $carry;
    }

    if ($seconds < 0)
    {
        return $self->add(-$seconds);
    }

    my $i = $seconds;
    while ($i > 0)
    {
        if ($i > $self->value)
        {
            my $pack = $self->value;
            $self->SUPER::subtract($self->value);
            $i -= $pack;
        }
        $carry += $self->dec();
        --$i;
    }
    return $carry;
}

sub subtract_utc
{
    my $self = shift;
    my $seconds = shift;

    my $carry = 0;
    if ($seconds == 0)
    {
        return $carry;
    }

    if ($seconds < 0)
    {
        return $self->add_utc(-$seconds);
    }

    my $i = $seconds;
    while ($i > 0)
    {
        if (ATLib::Std::DateTime::Utils->get_leap_seconds_utc($self) == 0)
        {
            if ($i > $self->value)
            {
                my $pack = $self->value;
                $self->SUPER::subtract($self->value);
                $i -= $pack;
            }
        }
        $carry += $self->dec_utc();
        --$i;
    }
    return $carry;
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;

=encoding utf8

=head1 名前

ATLib::Std::DateTime::Second - ATLib::Std::DateTimeにおける秒部分を管理するクラス

=head1 バージョン

この文書は ATLib::Std version v0.3.1 について説明しています。

=head1 概要

    use ATLib::Std::DateTime::Year;
    use ATLib::Std::DateTime::Month;
    use ATLib::Std::DateTime::Day;
    use ATLib::Std::DateTime::Hour;
    use ATLib::Std::DateTime::Minute;
    use ATLib::Std::DateTime::Second;

    # このクラスは ATLib::Std::DateTime から使用されることを想定
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

=head1 基底クラス

L<< ATLib::Std::Any >> E<lt>- L<< ATLib::Std::Radix >>

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::DateTime::Second->from($minute_ref, $second);  >>

分をあらわす$minute_refと$secondを秒とするインスタンスを生成します。
年月日、時間、分は分をあらわすオブジェクトに内包されています。

=head2 C<< $instance = ATLib::Std::DateTime::Second->from_utc($minute_ref, $second);  >>

分をあらわす$minute_refと$secondを秒とするインスタンスを生成します。
年月日、時間、分は分をあらわすオブジェクトに内包されています。
このコンストラクタは閏秒を考慮した初期化を行います。

=head1 オーバーロード

=head2 文字列化 C<< "" >>

スカラコンテキストでは、インスタンスがあらわす時を整数型 L<< ATLib::Std::Int >> 化して返します。
このコンテキストは比較時に文字列形式の数値変換など Perlから使用されます。

=head1 プロパティ

=head2 C<< $year = $instance->year; -E<gt> ATLib::Std::Int >>

インスタンスが関連づいている年(エポック年ではない)を取得します。

=head2 C<< $month = $instance->month; -E<gt> ATLib::Std::Int >>

インスタンスが関連づいている月(エポック月ではない)を取得します。

=head2 C<< $day = $instance->day; -E<gt> ATLib::Std::Int >>

インスタンスがあらわす日(エポック日ではない)を取得します。

=head2 C<< $last_day = $instance->last_day; -E<gt> ATLib::Std::Int >>

インスタンスがあらわす閏年を考慮した年月の最終日を取得します。

=head2 C<< $hour = $instance->hour; -E<gt> ATLib::Std::Int >>

インスタンスがあらわす時を取得します。

=head2 C<< $minute = $instance->minute; -E<gt> ATLib::Std::Int >>

インスタンスがあらわす分を取得します。

=head2 C<< $second = $instance->second; -E<gt> ATLib::Std::Int >>

インスタンスがあらわす秒を取得します。

=head1 インスタンスメソッド

=head2 C<< $carry = $instance->add($seconds); -E<gt> ATLib::Std::Int >>

インスタンスの時間を$seconds秒加算します。$secondsが負数の場合は、秒を減算します。
年、月、日、時間、分をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに秒をまたいだ数を正、または負の数で返却します。

=head2 C<< $carry = $instance->add_utc($seconds); -E<gt> ATLib::Std::Int >>

インスタンスの時間を$seconds秒加算します。$secondsが負数の場合は、秒を減算します。
年、月、日、時間、分をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに秒をまたいだ数を正、または負の数で返却します。
このメソッドは計算の際に閏秒を考慮します。

=head2 C<< $carry = $instance->subtract($seconds); -E<gt> ATLib::Std::Int >>

インスタンスの時間を$seconds秒減算します。$secondsが負数の場合は、秒を加算します。
年、月、日、時間、分をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに秒をまたいだ数を正、または負の数で返却します。

=head2 C<< $carry = $instance->subtract_utc($seconds); -E<gt> ATLib::Std::Int >>

インスタンスの時間を$seconds秒減算します。$secondsが負数の場合は、秒を加算します。
年、月、日、時間、分をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに秒をまたいだ数を正、または負の数で返却します。
このメソッドは計算の際に閏秒を考慮します。

=head2 C<< $carry = $instance->inc(); -E<gt> ATLib::Std::Int >>

インスタンスの秒を 1秒加算します。
年、月、日、時間、分をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに秒をまたいだ数を正の数で返却します。

=head2 C<< $carry = $instance->inc_utc(); -E<gt> ATLib::Std::Int >>

インスタンスの秒を 1秒加算します。計算の際に閏秒を考慮します。
年、月、日、時間、分をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに秒をまたいだ数を正の数で返却します。

=head2 C<< $carry = $instance->dec(); -E<gt> ATLib::Std::Int >>

インスタンスの秒を 1秒減算します。
年、月、日、時間、分をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに秒をまたいだ数を負の数で返却します。

=head2 C<< $carry = $instance->dec_utc(); -E<gt> ATLib::Std::Int >>

インスタンスの秒を 1秒減算します。計算の際に閏秒を考慮します。
年、月、日、時間、分をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに秒をまたいだ数を負の数で返却します。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2023 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut