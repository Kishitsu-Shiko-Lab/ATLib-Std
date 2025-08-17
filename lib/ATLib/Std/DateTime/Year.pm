package ATLib::Std::DateTime::Year;
use Mouse;
extends 'ATLib::Std::Int';

use ATLib::Std::Bool;
use ATLib::Std::Int;

# Overloads
use overload(
    q{""}    => \&year,
    fallback => 1,
);

# Attributes
sub year
{
    my $self = shift;
    return ATLib::Std::Int->from($self->_value + 1900);
}

sub number_of_days
{
    my $self = shift;
    return ATLib::Std::Int->from(ATLib::Std::DateTime::Year->is_leap_year($self->year) ? 366 : 365);
}

# Class Methods
sub from
{
    my $class = shift;
    my $epoch_year = shift;

    return $class->new({_value => ATLib::Std::Int->value($epoch_year)});
}

sub to_epoch
{
    shift;
    my $year = shift;
    return ATLib::Std::Int->from(ATLib::Std::Int->value($year - 1900));
}

sub is_leap_year
{
    shift;
    my $year = shift;

    if ($year % 400 == 0) { return ATLib::Std::Bool->true; }
    if ($year % 4 == 0)
    {
        if ($year % 100 == 0) { return ATLib::Std::Bool->false; }
        return ATLib::Std::Bool->true;
    }
    return ATLib::Std::Bool->false;
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;

=encoding utf8

=head1 名前

ATLib::Std::DateTime::Year - ATLib::Std::DateTimeにおける年部分を管理するクラス

=head1 バージョン

この文書は ATLib::Std version v0.4.0 について説明しています。

=head1 概要

    use ATLib::Std::DateTime::Year;

    # このクラスは ATLib::Std::DateTime から使用されることを想定
    my $year = 2022;
    my $instance = ATLib::Std::DateTime::Year->from(0, $year - 1900); # Perl epoch year

=head1 基底クラス

L<< ATLib::Std::Any >> E<lt>- L<< ATLib::Std::String >> E<lt>- L<< ATLib::Std::Number >> E<lt>- L<< ATLib::Std::Int >>

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::DateTime::Year->from($is_utc, $epoch_year);  >>

$epoch_year + 1900 を年とするインスタンスを生成します。
$is_utcは協定世界時(UTC)かどうかを指定します。

=head1 オーバーロード

=head2 文字列化 C<< "" >>

スカラコンテキストでは、インスタンスがあらわす年(エポック年ではない)を整数型 L<< ATLib::Std::Int >> 化して返します。
このコンテキストは比較時に文字列形式の数値変換など Perlから使用されます。

=head2 演算子 C<< + >>

被演算子となった数値を加算して、新たな数値型クラスを返します。

=head2 演算子 C<< - >>

被演算子となった数値を減算して、新たな数値型クラスを返します。

=head1 プロパティ

=head2 C<< $year = $instance->year; -E<gt> ATLib::Std::Int >>

インスタンスがあらわす年(エポック年ではない)を取得します。

=head2 C<< $number_of_days = $instance->number_of_days; -E<gt> ATLib::Std::Int >>

インスタンスがあらわす閏年を考慮した年の日数を取得します。

=head1 クラスメソッド

=head2 C<< $epoch_year = $class->to_epoch($year); -E<gt> Int  >>

$yearをエポック年に変換します。

=head2 C<< $result = $class->is_leap_year($year); -E<gt> ATLib::Std::Bool >>

$yearが閏年かどうかを判定します。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2025 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut