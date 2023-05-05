package ATLib::Std::DateTime::Hour;
use Mouse;
extends 'ATLib::Std::Radix';

use ATLib::Std::Int;

# Overloads
use overload(
    q{""}    => \&hour,
    fallback => 0,
);

# Attributes
has '_day_ref' => (is => 'ro', isa => 'ATLib::Std::DateTime::Day', required => 1, writer => '_set__day_ref');

sub year
{
    my $self = shift;
    return $self->_day_ref->year;
}

sub month
{
    my $self = shift;
    return $self->_day_ref->month;
}

sub day
{
    my $self = shift;
    return $self->_day_ref->day;
}

sub last_day
{
    my $self = shift;
    return $self->_day_ref->last_day;
}

sub hour
{
    my $self = shift;
    return ATLib::Std::Int->from($self->value);
}

# Class Methods
sub from
{
    my $class = shift;
    my $day_ref = shift;
    my $hour = shift;

    if ($hour->isa('ATLib::Std::Int'))
    {
        $hour = $hour->_value;
    }

    return $class->new({
        type_name => $class,
        _day_ref  => $day_ref,
        radix     => 24,
        value     => $hour,
    });
}

# Instance Methods
sub inc
{
    my $self = shift;

    if ($self->hour + 1 > $self->max_value)
    {
        $self->_day_ref->inc();
    }

    my $carry = $self->SUPER::inc();

    return $carry;
}

sub dec
{
    my $self = shift;

    if ($self->hour - 1 < 0)
    {
        $self->_day_ref->dec();
    }

    my $carry = $self->SUPER::dec();

    return $carry;
}

sub add
{
    my $self = shift;
    my $hours = shift;

    my $carry = 0;
    if ($hours == 0)
    {
        return $carry;
    }

    if ($hours < 0)
    {
        return $self->subtract(-$hours);
    }

    my $i = $hours;
    while ($i > 0)
    {
        $carry += $self->inc();
        --$i;
    }
    return $carry;
}

sub subtract
{
    my $self = shift;
    my $hours = shift;

    my $carry = 0;
    if ($hours == 0)
    {
        return $carry;
    }

    if ($hours < 0)
    {
        return $self->add(-$hours);
    }

    my $i = $hours;
    while ($i > 0)
    {
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

ATLib::Std::DateTime::Hour - ATLib::Std::DateTimeにおける時間部分を管理するクラス

=head1 バージョン

この文書は ATLib::Std version v0.2.2 について説明しています。

=head1 概要

    use ATLib::Std::DateTime::Year;
    use ATLib::Std::DateTime::Month;
    use ATLib::Std::DateTime::Day;
    use ATLib::Std::DateTime::Hour;

    # このクラスは ATLib::Std::DateTime から使用されることを想定
    my $year = 2022;
    my $year_ref = ATLib::Std::DateTime::Year->from($year - 1900); # Perl epoch year
    my $month = 12;
    my $month_ref = ATLib::Std::DateTime::Month->from($year_ref, $month - 1); # Perl epoch month
    my $day = 23;
    my $day_ref = ATLib::Std::DateTime::Day->from($month_ref, $day - 1); # Perl epoch day
    my $hour = 8;
    my $hour_ref = ATLib::Std::DateTime::Hour->from($day_ref, $hour);

=head1 基底クラス

L<< ATLib::Std::Any >> E<lt>- L<< ATLib::Std::Radix >>

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::DateTime::Hour->from($day_ref, $hour);  >>

日をあらわす$day_refと$hourを時とするインスタンスを生成します。
年月日は日をあらわすオブジェクトに内包されています。

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

=head1 インスタンスメソッド

=head2 C<< $carry = $instance->add($hours); -E<gt> ATLib::Std::Int >>

インスタンスの時間を$hours時間分加算します。$hoursが負数の場合は、時間を減算します。
年、月、日をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに日をまたいだ数を正、または負の数で返却します。

=head2 C<< $carry = $instance->subtract($hours); -E<gt> ATLib::Std::Int >>

インスタンスの時間を$hours時間分減算します。$hoursが負数の場合は、時間を加算します。
年、月、日をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに日をまたいだ数を正、または負の数で返却します。

=head2 C<< $carry = $instance->inc(); -E<gt> ATLib::Std::Int >>

インスタンスの時間を 1時間加算します。
年、月、日をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに日をまたいだ数を正の数で返却します。

=head2 C<< $carry = $instance->dec(); -E<gt> ATLib::Std::Int >>

インスタンスの時間を 1時間減算します。
年、月、日をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに年をまたいだ数を負の数で返却します。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2023 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut
