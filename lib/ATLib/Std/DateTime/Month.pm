package ATLib::Std::DateTime::Month;
use Mouse;
extends 'ATLib::Std::Radix';

use ATLib::Std::Int;
use ATLib::Std::DateTime::Year;

# Overloads
use overload(
    q{""}    => \&month,
    fallback => 0,
);

# Attributes
has '_year_ref' => (is => 'ro', isa => 'ATLib::Std::DateTime::Year', required => 1);

sub year
{
    my $self = shift;
    return $self->_year_ref->year;
}

sub month
{
    my $self = shift;
    return ATLib::Std::Int->from($self->value + 1);
}

sub last_day
{
    my $self = shift;

    if ($self->month == 2)
    {
        if (ATLib::Std::DateTime::Year->is_leap_year($self->year))
        {
            return ATLib::Std::Int->from(29);
        }
        else
        {
            return ATLib::Std::Int->from(28);
        }
    }
    elsif ($self->month == 4 || $self->month == 6 || $self->month == 9 || $self->month == 11)
    {
        return ATLib::Std::Int->from(30);
    }
    return ATLib::Std::Int->from(31);
}

# Class Methods
sub from
{
    my $class = shift;
    my $year_ref = shift;
    my $epoch_month = shift;

    if ($epoch_month->isa('ATLib::Std::Int'))
    {
        $epoch_month = $epoch_month->_value;
    }

    return $class->new({
        _year_ref => $year_ref,
        radix     => 12,
        value     => $epoch_month,
    });
}

sub to_epoch
{
    shift;
    my $month = shift;

    return ATLib::Std::Int->from(ATLib::Std::Int->value($month - 1));
}

# Instance Methods
sub add
{
    my $self = shift;
    my $months = shift;

    my $carry = 0;
    if ($months == 0)
    {
        return $carry;
    }

    if ($months < 0)
    {
        return $self->subtract(-$months);
    }

    $carry = $self->SUPER::add($months);
    my $year = $self->year + $carry;
    $self->_year_ref->_value(ATLib::Std::DateTime::Year->to_epoch($year)->_value);

    return $carry;
}

sub subtract
{
    my $self = shift;
    my $months = shift;

    my $carry = 0;
    if ($months == 0)
    {
        return $carry;
    }

    if ($months < 0)
    {
        return $self->add(-$months);
    }

    $carry = $self->SUPER::subtract($months);
    my $year = $self->year + $carry;
    $self->_year_ref->_value(ATLib::Std::DateTime::Year->to_epoch($year)->_value);

    return $carry;
}

sub inc
{
    my $self = shift;
    return $self->add(1);
}

sub dec
{
    my $self = shift;
    return $self->subtract(1);
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;

=encoding utf8

=head1 名前

ATLib::Std::DateTime::Month - ATLib::Std::DateTimeにおける月部分を管理するクラス

=head1 バージョン

この文書は ATLib::Std version v0.4.0 について説明しています。

=head1 概要

    use ATLib::Std::DateTime::Year;
    use ATLib::Std::DateTime::Month;

    # このクラスは ATLib::Std::DateTime から使用されることを想定
    my $year = 2022;
    my $year_ref = ATLib::Std::DateTime::Year->from($year - 1900); # Perl epoch year
    my $month = 11;
    my $instance = ATLib::Std::DateTime::Month->from($year_ref, $month - 1); # Perl epoch month

=head1 基底クラス

L<< ATLib::Std::Any >> E<lt>- L<< ATLib::Std::Radix >>

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::DateTime::Month->from($year_ref, $epoch_month);  >>

年をあらわす$year_refと$epoch_month + 1を年月とするインスタンスを生成します。

=head1 オーバーロード

=head2 文字列化 C<< "" >>

スカラコンテキストでは、インスタンスがあらわす月(エポック月ではない)を整数型 L<< ATLib::Std::Int >> 化して返します。
このコンテキストは比較時に文字列形式の数値変換など Perlから使用されます。

=head1 プロパティ

=head2 C<< $year = $instance->year; -E<gt> ATLib::Std::Int >>

インスタンスが関連づいている年(エポック年ではない)を取得します。

=head2 C<< $month = $instance->month; -E<gt> ATLib::Std::Int >>

インスタンスがあらわす月(エポック月ではない)を取得します。

=head2 C<< $last_day = $instance->last_day; -E<gt> ATLib::Std::Int >>

インスタンスがあらわす閏年を考慮した年月の最終日を取得します。

=head1 クラスメソッド

=head2 C<< $epoch_month = $class->to_epoch($month); -E<gt> ATLib::Std::Int  >>

$monthをエポック月に変換します。

=head1 インスタンスメソッド

=head2 C<< $carry = $instance->add($months); -E<gt> ATLib::Std::Int >>

インスタンスの月を$months月分加算します。$monthsが負数の場合は、月を減算します。
年をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに年をまたいだ数を正、または負の数で返却します。

=head2 C<< $carry = $instance->subtract($months); -E<gt> ATLib::Std::Int >>

インスタンスの月を$months月分減算します。$monthsが負数の場合は、月を加算します。
年をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに年をまたいだ数を正、または負の数で返却します。

=head2 C<< $carry = $instance->inc(); -E<gt> ATLib::Std::Int >>

インスタンスの月を 1ヶ月加算します。
年をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに年をまたいだ数を正、または負の数で返却します。

=head2 C<< $carry = $instance->dec(); -E<gt> ATLib::Std::Int >>

インスタンスの月を 1ヶ月減算します。
年をまたぐ場合は、計算結果を包含する時間単位の参照オブジェクトに伝播させます。
さらに年をまたいだ数を負の数で返却します。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2025 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut
