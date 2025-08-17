package ATLib::Std::Bool;
use Mouse;
extends 'ATLib::Std::Any';

use ATLib::Utils qw{ as_type_of };

# Overloads
use overload(
    q{""}    => \&as_string,
    q{bool}  => \&as_bool,
    q{!}     => \&apply_not,
    q{<=>}   => \&_compare,
    fallback => 0,
);

# Attributes
has '_value' => (is => 'rw', isa => 'Bool', required => 1);

# Overload Handler
sub as_string
{
    my $self = shift;
    return '1' if ($self->_value == 1);
    return '0';
}

sub as_bool
{
    my $self = shift;
    return 1 if ($self->_value == 1);
    return 0;
}

sub apply_not
{
    my $self = shift;
    return 0 if ($self->_value == 1);
    return 1;
}

sub _compare
{
    my ($this, $that, $swap) = @_;

    if (defined $swap && $swap)
    {
        if (as_type_of(q{ATLib::Std::Bool}, $that))
        {
            return $that->compare($this);
        }
        else
        {
            return -1;
        }
    }
    else
    {
        if (as_type_of(q{ATLib::Std::Bool}, $this))
        {
            return $this->compare($that);
        }
        else
        {
            return -1;
        }
    }
}

# Class Methods
sub true
{
    my $class = shift;
    return $class->new({_value => 1});
}

sub false
{
    my $class = shift;
    return $class->new({_value => 0});
}

# Instance Methods
sub compare
{
    my $self = shift;
    my $target = shift;

    if (!$self->SUPER::_can_equals($target))
    {
        return -99;
    }
    return ($self->_value - $target->_value);
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

ATLib::Std::Bool - 真偽値を表す標準型

=head1 バージョン

この文書は ATLib::Std version v0.4.0 について説明しています。

=head1 概要

    use ATLib::Std;

    my $instance1 = ATLib::Std::Bool->true;
    my $instance2 = ATLib::Std::Bool->false;

    my $result = $instance1->equals($instance2);    # 0
    my $result = $instance1->equals($instance1);    # 1
    my $result = $instance2->equals($instance1);    # 0

=head1 基底クラス

L<< ATLib::Std::Any >>

=head1 説明

ATLib::Std::Bool は、ATLib::Stdで提供される L<< Mouse >> で実装された真偽値を表す型です。

=head1 コンストラクタ

=head2 C<< $instance_of_true = ATLib::Std::Bool->true; >>

Perl で真となる値をもつ真偽値のインスタンスを生成します。

=head2 C<< $instance_of_false = ATLib::Std::Bool->false; >>

Perl で偽となる値をもつ真偽値のインスタンスを生成します。

=head1 オーバーロード

=head2 文字列化 C<< "" >>

スカラコンテキストでは、クラスに格納された真偽値を表す整数値を返します。

=head1 インスタンスメソッド

=head2 C<< $result = $instance->compare($target);  >>

$instanceと$targetを数値比較します。
$targetが等しい場合は 0、$instanceが真で等しくない場合は 1、それ以外場合は -1を返します。
また、$targetが比較不可能である場合は、-99を返します。

=head2 C<< $result = $instance->equals($target); >> -E<gt> Bool

$targetが$instanceと等価であるかを判定します。
判定には、C<< $instance->compare($target) >> が使用されます。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2025 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut
