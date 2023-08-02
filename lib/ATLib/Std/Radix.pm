package ATLib::Std::Radix;
use Mouse;
extends 'ATLib::Std::Any';

use ATLib::Utils qw{is_int};
use ATLib::Std::String;
use ATLib::Std::Number;
use ATLib::Std::Int;
use ATLib::Std::Exception::Argument;

# Overloads
use overload(
    q{""}    => \&as_string,
    fallback => 1,
);

# Attribute
has 'radix' => (is => 'ro', isa => 'Int', required => 1, writer => '_set_radix');
has 'value' => (is => 'ro', isa => 'Int', required => 1, writer => '_set_value');

sub max_value
{
    my $self = shift;
    return ATLib::Std::Int->from($self->radix - 1);
}

# Class Methods
sub from
{
    my $class = shift;
    my $radix = shift;
    my $value = shift;

    if ($radix <= 0)
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Argument is out of range. The $radix must be greater than zero.}),
            param_name => ATLib::Std::String->from(q{$radix}),
        })->throw();
    }
    if ($value < 0 || $value >= $radix)
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Argument is out of range. The $value must be between zero and $radix - 1.}),
            param_name => ATLib::Std::String->from(q{$radix}),
        })->throw();
    }

    return $class->new({radix => $radix, value => $value});
}

# Instance Methods
sub as_string
{
    my $self = shift;
    return ATLib::Std::String->from($self->value);
}

sub inc
{
    my $self = shift;

    my $carry = 0;
    my $value = $self->value;
    ++$value;
    if ($value > $self->max_value)
    {
        $carry = 1;
        $value = 0;
    }
    $self->_set_value($value);
    return ATLib::Std::Int->from($carry);
}

sub dec
{
    my $self = shift;

    my $carry = 0;
    my $value = $self->value;
    --$value;
    if ($value < 0)
    {
        $carry = -1;
        $value = $self->radix - 1;
    }
    $self->_set_value($value);
    return ATLib::Std::Int->from($carry);
}

sub add
{
    my $self = shift;
    my $number_of_addition = shift;

    my $carry = 0;
    if ($number_of_addition == 0)
    {
        return $carry;
    }

    if ($number_of_addition < 0)
    {
        return $self->subtract(-$number_of_addition);
    }

    if ($number_of_addition >= $self->radix)
    {
        $carry = int($number_of_addition / $self->radix);
        $number_of_addition = ATLib::Std::Int->from($number_of_addition % $self->radix);
    }
    my $value = $self->value;
    if ($value + $number_of_addition >= $self->radix)
    {
        ++$carry;
        $value -= $self->radix;
    }

    $value += $number_of_addition;
    $self->_set_value($value);

    return $carry;
}

sub subtract
{
    my $self = shift;
    my $number_of_subtract = shift;

    my $carry = 0;
    if ($number_of_subtract == 0)
    {
        return $carry;
    }

    if ($number_of_subtract < 0)
    {
        return $self->add(-$number_of_subtract);
    }

    if ($number_of_subtract >= $self->radix)
    {
        $carry = -1 * int($number_of_subtract / $self->radix);
        $number_of_subtract = ATLib::Std::Int->from($number_of_subtract % $self->radix);
    }
    my $value = $self->value;
    if ($value - $number_of_subtract < 0)
    {
        --$carry;
        $value += $self->radix;
    }

    $value -= $number_of_subtract;
    $self->_set_value($value);

    return $carry;
}

sub _can_equals
{
    my $self = shift;
    my $target = shift;

    if ($target->isa($self->get_full_name()) || $target->isa(q{ATLib::Std::Number}))
    {
        if ($target->can(q{_value}))
        {
            return 1;
        }
    }

    return 0;
}

sub compare
{
    my $self = shift;
    my $target = shift;

    if (!defined $target)
    {
        return 1;
    }

    if ($self->_can_equals($target))
    {
        return $self->value <=> $target->_value;
    }

    if (!is_int($target))
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Type mismatch.}),
            param_name => ATLib::Std::String->from(q{$target}),
        })->throw();
    }

    return $self->value <=> $target;
}

sub equals
{
    my $self = shift;
    my $target = shift;

    return $self->compare($target) == 0 ? 1 : 0;
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;

=encoding utf8

=head1 名前

ATLib::Std::Radix - ATLib::Stdにおける基数クラス

=head1 バージョン

この文書は ATLib::Std version v0.3.1 について説明しています。

=head1 概要

    use ATLib::Std::Radix;

    my $instance = ATLib::Std::Radix->from(60, 0);

=head1 基底クラス

L<< ATLib::Std::Any >>

=head1 説明

ATLib::Std::Radix は、ATLib::Stdで提供される L<< Mouse >> で実装された基数を表すクラスです。
N進数のような計算を行う際に利用できます。

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::Radix->from($radix, $value);  >>

$radixを基数とする$valueが初期値のインスタンスを生成します。
$radixは 0より大きい値を設定する必要があります。また、$valueは 0〜$radix - 1の範囲である必要があります。
上記が範囲外の場合は、L<< ATLib::Std::Exception::Argument >>が発生します。

=head1 オーバーロード

=head2 文字列化 C<< "" >>

スカラコンテキストでは、クラスに格納された値の文字列を返します。

=head1 プロパティ

=head2 C<< $type_name = $instance->type_name;  >>

インスタンスの L<< Mouse >> における型名を取得します。

=head2 C<< $radix = $instance->radix; ->E<<gt>> Int >>

インスタンスに格納されている基数を取得します。

=head2 C<< $value = $instance->value; ->E<<gt>> Int >>

インスタンスに格納されている値を取得します。

=head2 C<< $value = $instance->max_value; ->E<<gt>> Int >>

インスタンスに格納できる最大値を取得します。

=head1 インスタンスメソッド

=head2 C<< $hash_code = $instance->get_hash_code();  >>

インスタンスのハッシュコードを取得します。
この値はオブジェクトの参照等価性チェックに使用されるため、必要な場合はオーバーライドします。

=head2 C<< $class_name = $instance->get_full_name();  >>

インスタンスのクラスの完全名を取得します。これは Perlにおけるパッケージ名です。

=head2 C<< $carry = $instance->inc(); -E<gt> L<< ATLib::Std::Int >> >>

インスタンスに格納されている値をインクリメントします。
また、桁上がりした数を正の数で返却します。

=head2 C<< $carry = $instance->dec(); -E<gt> L<< ATLib::Std::Int >> >>

インスタンスに格納されている値をデクリメントします。
また、桁下がりした数を負の数で返却します。

=head2 C<< $carry = $instance->add($number_of_addition); -E<gt> L<< ATLib::Std::Int >> >>

インスタンスに格納されている値に指定した数を加算します。
また、桁上がりした数を正の数で返却します。
引数 $number_of_additionに負数を設定した場合は、C<< $instance->subtract(-1 * $number_of_addition); >>を呼び出します。

=head2 C<< $carry = $instance->subtract($number_of_subtract); -E<gt> L<< ATLib::Std::Int >> >>

インスタンスに格納されている値から指定した数を減算します。
また、桁下がりした数を負の数で返却します。
引数 $number_of_additionに負数を設定した場合は、C<< $instance->add(-1 * $number_of_subtract); >>を呼び出します。

=head2 C<< $result = $instance->_can_equals($target);  >>

参照等価性チェックで $target が比較可能であるかを判定します。
既定の実装では、$targetが本インスタンス (ここでは $instance) の派生クラスであるかを判定して結果を返します。
必要な場合は派生クラスでオーバーライドします。

=head2 C<< $result = $instance->equals($target); >>

$targetが$instanceと等価であるかを判定します。
既定の実装では、比較可能チェックC<< $instance->_can_equals($target) >>を通過後に参照等価性チェックを行います。
オブジェクトの機能 (例えば、等値チェックを行いたい場合など) により派生クラスでオーバーライドします。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2023 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut
