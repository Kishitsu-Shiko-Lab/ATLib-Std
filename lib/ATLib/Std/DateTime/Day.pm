package ATLib::Std::DateTime::Day;
use Mouse;
extends 'ATLib::Std::Radix';

use ATLib::Std::Int;

# Overloads
use overload(
    q{""}    => \&day,
    fallback => 0,
);

# Attributes
has '_month_ref' => (is => 'ro', isa => 'ATLib::Std::DateTime::Month', required => 1, writer => '_set__month_ref');

sub year
{
    my $self = shift;
    return $self->_month_ref->year;
}

sub month
{
    my $self = shift;
    return $self->_month_ref->month;
}

sub day
{
    my $self = shift;
    return ATLib::Std::Int->from($self->value + 1);
}

sub last_day
{
    my $self = shift;
    return $self->_month_ref->last_day;
}

# Class Methods
sub from
{
    my $class = shift;
    my $month_ref = shift;
    my $epoch_day = shift;

    if ($epoch_day->isa('ATLib::Std::Int'))
    {
        $epoch_day = $epoch_day->_value;
    }

    return $class->new({
        _month_ref => $month_ref,
        radix      => $month_ref->last_day->_value,
        value      => $epoch_day,
    });
}

sub to_epoch
{
    shift;
    my $day = shift;

    return ATLib::Std::Int->from(ATLib::Std::Int->value($day - 1));
}

# Instance Methods
sub inc
{
    my $self = shift;

    my $carry = 0;
    if ($self->day + 1 > $self->last_day)
    {
        $self->_month_ref->inc();
        $self->_set_radix($self->last_day->_value);
        $self->_set_value(ATLib::Std::DateTime::Day->to_epoch(1)->_value);
        ++$carry;
    }
    else
    {
        $self->SUPER::inc();
    }

    return $carry;
}

sub dec
{
    my $self = shift;

    my $carry = 0;
    if ($self->day - 1 < 1)
    {
        $self->_month_ref->dec();
        $self->_set_radix($self->last_day->_value);
        $self->_set_value(ATLib::Std::DateTime::Day->to_epoch($self->last_day->_value)->_value);
        --$carry;
    }
    else
    {
        $self->SUPER::dec();
    }

    return $carry;
}

sub add
{
    my $self = shift;
    my $days = shift;

    my $carry = 0;
    if ($days == 0)
    {
        return $carry;
    }

    if ($days < 0)
    {
        return $self->subtract(-$days);
    }

    my $i = $days;
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

sub subtract
{
    my $self = shift;
    my $days = shift;

    my $carry = 0;
    if ($days == 0)
    {
        return $carry;
    }

    if ($days < 0)
    {
        return $self->add(-$days);
    }

    my $i = $days;
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

__PACKAGE__->meta->make_immutable();
no Mouse;
1;

=encoding utf8

=head1 名前

ATLib::Std::DateTime::Day - ATLib::Std::DateTimeにおける日部分を管理するクラス

=head1 バージョン

この文書は ATLib::Std version v0.3.1 について説明しています。

=head1 概要

    use ATLib::Std::DateTime::Year;
    use ATLib::Std::DateTime::Month;
    use ATLib::Std::DateTime::Day;

    # このクラスは ATLib::Std::DateTime から使用されることを想定
    my $year = 2022;
    my $year_ref = ATLib::Std::DateTime::Year->from($year - 1900); # Perl epoch year
    my $month = 11;
    my $month_ref = ATLib::Std::DateTime::Month->from($year_ref, $month - 1); # Perl epoch month
    my $day = 5;
    my $instance = ATLib::Std::DateTime::Day->from($month_ref, $day - 1); # Perl epoch day

=head1 基底クラス

L<< ATLib::Std::Any >> E<lt>- L<< ATLib::Std::Radix >>

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::DateTime::Day->from($month_ref, $epoch_day);  >>

月をあらわす$month_refと$epoch_day + 1を年月日とするインスタンスを生成します。
年は月をあらわすオブジェクトに内包されています。

=head1 オーバーロード

=head2 文字列化 C<< "" >>

スカラコンテキストでは、インスタンスがあらわす日(エポック日ではない)を整数型 L<< ATLib::Std::Int >> 化して返します。
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

=head1 クラスメソッド

=head2 C<< $epoch_day = $class->to_epoch($day); -E<gt> ATLib::Std::Int  >>

$dayをエポック日に変換します。

=head1 インスタンスメソッド

=head2 C<< $carry = $instance->add($days); -E<gt> ATLib::Std::Int >>

インスタンスの日を$days日分加算します。$daysが負数の場合は、月を減算します。
年、月をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに月をまたいだ数を正、または負の数で返却します。

=head2 C<< $carry = $instance->subtract($days); -E<gt> ATLib::Std::Int >>

インスタンスの月を$days月分減算します。$daysが負数の場合は、月を加算します。
年、月をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに月をまたいだ数を正、または負の数で返却します。

=head2 C<< $carry = $instance->inc(); -E<gt> ATLib::Std::Int >>

インスタンスの日を 1日加算します。
年、月をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに年をまたいだ数を正の数で返却します。

=head2 C<< $carry = $instance->dec(); -E<gt> ATLib::Std::Int >>

インスタンスの日を 1日減算します。
年、月をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに年をまたいだ数を負の数で返却します。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2023 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut
