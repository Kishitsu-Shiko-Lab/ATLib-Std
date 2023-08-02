package ATLib::Std::Number;
use Mouse;
extends 'ATLib::Std::String';

use ATLib::Utils qw{is_number};
use ATLib::Std::String;
use ATLib::Std::Exception;

# Overloads
use overload(
    q{""}    => \&as_string,
    q{0+}    => \&as_number,
    q{+}     => \&_add,
    q{-}     => \&_subtract,
    fallback => 1,
);

# Attributes
has '+_value' => (isa => 'Num');

# Overload Handler
sub _add
{
    my $this = shift;
    my $that = shift;
    my $swap = shift;

    my $class = blessed($this);
    my $value = undef;
    if ($class && $this->isa(__PACKAGE__))
    {
        $value = $this->_value;
        $class = $this->get_full_name();
    }
    else
    {
        $value = $this;
    }

    if (blessed($that) && $that->isa(__PACKAGE__))
    {
        $value += $that->_value;
        if (!(defined $class) || !$class)
        {
            $class = $that->get_full_name();
        }
    }
    else
    {
        $value += $that;
    }

    if (!(defined $class) || !$class)
    {
        $class = __PACKAGE__;
    }

    return $class->from($value) if ((!defined $swap || !$swap) && blessed($this) && $this->isa(__PACKAGE__));
    return $class->from($value) if (defined $swap && $swap && blessed($that) && $that->isa(__PACKAGE__));
    return $value;
}

sub _subtract
{
    my $this = shift;
    my $that = shift;
    my $swap = shift;

    my $class = blessed($this);
    my $value = undef;
    if ($class && $this->isa(__PACKAGE__))
    {
        $value = $this->_value;
        $class = $this->get_full_name();
    }
    else
    {
        $value = $this;
    }

    if (blessed($that) && $that->isa(__PACKAGE__))
    {
        $value -= $that->_value;
        if (!(defined $class) || !$class)
        {
            $class = $that->get_full_name();
        }
    }
    else
    {
        $value -= $that;
    }

    if (defined $swap && $swap)
    {
        $value = -$value;
    }

    if (!(defined $class) || !$class)
    {
        $class = __PACKAGE__;
    }

    return $class->from($value) if ((!defined $swap || !$swap) && blessed($this) && $this->isa(__PACKAGE__));
    return $class->from($value) if (defined $swap && $swap && blessed($that) && $that->isa(__PACKAGE__));
    return $value;
}

# Class Methods
sub value
{
    my $class = shift;
    my $target = shift;

    if (blessed($target) && $target->isa($class))
    {
        return $target->_value;
    }
    return $target;
}

# Instance Methods
sub as_string
{
    my $self = shift;
    return ATLib::Std::String->from($self->_value);
}

sub as_number
{
    my $self = shift;
    return $self->_value;
}

sub _can_equals
{
    my $self = shift;
    my $target = shift;

    if (!defined $target)
    {
        return 0;
    }

    if ($target->isa($self->get_full_name))
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
        return $self->_value <=> $target->_value;
    }

    if (!is_number($target))
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Type mismatch.}),
            param_name => ATLib::Std::String->from(q{$target}),
        })->throw();
    }

    return $self->_value <=> $target;
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;
__END__

=encoding utf8

=head1 名前

ATLib::Std::Number - ATLib::Stdにおける標準型で数値を表すクラス

=head1 バージョン

この文書は ATLib::Std version v0.3.1 について説明しています。

=head1 概要

    use ATLib::Std::Number;

    my $instance1 = ATLib::Std::Number->from(123.45);

    my $instance2 = $instance1 + 100; # The value of $instance2 is 223.45
    my $instance3 = 100 + $instance1; # The value of $instance3 is 223.45
    # And you can also use operator of '-', '*', and '/'.

    my $result = $instance1->compare(123.44); # 1
    my $result = $instance2->compare($instance3); # 0
    my $result = $instance3->compare($instance1); # -1
    # And you can also use operator of '<', '<=', '>', '>=', '<=>'.

    my $result = $instance1->equals(123.44); # 1
    my $result = $instance1->equals($instance2); # 0
    # And you can also use operator of '==', '!='.

=head1 基底クラス

L<< ATLib::Std::Any >> E<lt>- L<< ATLib::Std::String >>

=head1 説明

ATLib::Std::Number は、ATLib::Stdで提供される L<< Mouse >> で実装された数値を表す型です。
本クラスは Perlの特性に従って、文字列型 L<< ATLib::Std::String >> から派生しています。

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::Number::from($value);  >>

$valueを整数値とするインスタンスを生成します。

=head1 オーバーロード

=head2 文字列化 C<< "" >>

スカラコンテキストでは、クラスに格納された整数値を文字列型 L<< ATLib::Std::String >> 化して返します。
このコンテキストは比較時に文字列形式の数値変換など Perlから使用されます。

=head2 数値化 C<< 0+ >>

スカラコンテキストで数値が必要な場合は、インスタンスに格納された整数値を返します。
これによりPerl標準の数値比較演算子 C<< E<lt>, E<le>, E<gt>, E<ge>, E<lt>=E<gt>, == >>を使用できます。

=head2 演算子 C<< + >>

被演算子となった数値を加算して、新たな数値型クラスを返します。

=head2 演算子 C<< - >>

被演算子となった数値を減算して、新たな数値型クラスを返します。

=head1 プロパティ

=head2 C<< $type_name = $instance->type_name;  >>

インスタンスの L<< Mouse >> における型名 C<< ATLib::Std::Number >> を取得します。
派生クラスでは L<< Mouse >> が対応する以下に示す型名を返却するように実装します。

=over 4

=item *

Item

=item *

Bool

=item *

Int

=item *

Num

=item *

E<lt> Class Name E<gt>

=item *

Ref

=item *

Maybe[ E<lt>type_name E<gt> ]

=back

=head1 インスタンスメソッド

=head2 C<< $hash_code = $instance->get_hash_code();  >>

インスタンスのハッシュコードを取得します。
この値はオブジェクトの参照等価性チェックに使用されるため、必要な場合はオーバーライドします。

=head2 C<< $class_name = $instance->get_full_name();  >>

インスタンスのクラスの完全名を取得します。これは Perlにおけるパッケージ名です。

=head2 C<< $string = $instance->as_string(); >>

格納されている数値を L<< ATLib::Std::String >> 型で返します。
スカラコンテキストではこのメソッドの結果を返します。

=head2 C<< $result = $instance->_can_equals($target);  >>

等価性チェックで $target が比較可能であるかを判定します。
既定の実装では、基底クラスの C<< _can_equals($target) >> で$targetが基底クラスの派生クラスであるかを判定した後に、
値型 C<< _value >> プロパティが存在するかどうかを判定します。
必要な場合は派生クラスでオーバーライドします。

=head2 C<< $result = $instance->compare($target);  >>

$instanceと$targetを数値比較します。
等しい場合は 0、$instanceが大きい場合は 1、小さい場合は -1を返します。

=head2 C<< $result = $instance->equals($target); >>

$targetが$instanceと等価であるかを判定します。
判定には、C<< $instance->compare($target) >> が使用されます。
必要に応じて、派生クラスでオーバーライドします。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2023 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut