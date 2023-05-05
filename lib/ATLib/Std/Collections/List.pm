package ATLib::Std::Collections::List;
use Mouse;
extends 'ATLib::Std::Any';
with qw{ATLib::Std::Role::Generic ATLib::Std::Role::Collection};

use ATLib::Utils qw{as_type_of equals};
use ATLib::Std::String;
use ATLib::Std::Int;
use ATLib::Std::Maybe;
use ATLib::Std::Exception::Argument;

# Attributes
has '_items_ref' => (
    is         => q{rw},
    isa        => q{ArrayRef[Maybe[Defined]]},
    lazy_build => 1,
);

sub items
{
    my $self = shift;
    my $index = shift;
    my $element = shift if (scalar(@_) > 0);

    if ($index < 0 || $index >= $self->count())
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Out of range.}),
            param_name => ATLib::Std::String->from(q{$index}),
        })->throw();
    }

    if (defined $element)
    {
        if (!as_type_of($self->type_name, $element))
        {
            my $type_name = $self->type_name;
            ATLib::Std::Exception::Argument->new({
                message    => ATLib::Std::String->from(qq{Type mismatch. The \$element must be $type_name.}),
                param_name => ATLib::Std::String->from(q{$element}),
            })->throw();
        }
        $self->_items_ref->[$index] = $element;
        return;
    }

    return $self->_items_ref->[$index];
}

# Builder
sub _build__items_ref { return [] };

# Class Methods
sub of
{
    my $class = shift;
    my $T = shift;

    return $class->new({type_name => qq{Maybe[$T]}, T => $T});
}

sub from
{
    my $class = shift;
    my $T = shift;
    my @array = @_;

    my $instance = $class->of($T);
    for my $item (@array)
    {
        if (defined $item)
        {
            if ($T->isa(q{ATLib::Std::String}))
            {
                my $element = $T->from($item);
                $instance->add($element);
            }
            else
            {
                $instance->add($item);
            }
        }
        else
        {
            $instance->add($item);
        }
    }
    return $instance;
}

# Instance Methods
sub count
{
    my $self = shift;
    return ATLib::Std::Int->from(scalar(@{$self->_items_ref}));
}

sub contains
{
    my $self = shift;
    my $element = shift;

    if ($self->count() == 0)
    {
        return 0;
    }

    if (!defined $element)
    {
        for my $i (0 .. $self->count() - 1)
        {
            if (!defined $self->_items_ref->[$i])
            {
                return 1;
            }
        }
        return 0;
    }

    if (!as_type_of($self->type_name, $element))
    {
        my $type_name = $self->type_name;
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(qq{Type mismatch. The \$element must be $type_name.}),
            param_name => ATLib::Std::String->from(q{$element}),
        })->throw();
    }

    if ($element->isa(q{ATLib::Std::Any}))
    {
        for my $i (0 .. $self->count() - 1)
        {
            if ($element->equals($self->items($i)))
            {
                return 1;
            }
        }
        return 0;
    }

    for my $i (0 .. $self->count() - 1)
    {
        if (equals($self->T, $self->_items_ref->[$i], $element))
        {
            return 1;
        }
    }
    return 0;
}

sub clear
{
    my $self = shift;
    $self->_items_ref([]);
    return $self;
}

sub add
{
    my $self = shift;
    my $element = shift;

    if (!as_type_of($self->type_name, $element))
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Type mismatch.}),
            param_name => ATLib::Std::String->from(q{$element}),
        })->throw();
    }

    $self->_items_ref->[$self->count()] = $element;
    return $self;
}

sub remove_at
{
    my $self = shift;
    my $index = shift;

    if ($index < 0 || $index >= $self->count())
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Out of range.}),
            param_name => ATLib::Std::String->from(q{$index}),
        })->throw();
    }

    splice(@{$self->_items_ref}, $index, 1);
    return;
}

sub remove
{
    my $self = shift;
    my $element = shift;

    if ($self->count() == 0)
    {
        return 0;
    }

    if (!as_type_of($self->type_name, $element))
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Type mismatch.}),
            param_name => ATLib::Std::String->from(q{$element}),
        })->throw();
    }

    if (defined $element && $element->isa(q{ATLib::Std::Any}))
    {
        for my $i (0 .. $self->count() - 1)
        {
            if ($element->equals($self->items($i)))
            {
                $self->remove_at($i);
                return 1;
            }
        }
        return 0;
    }

    for my $i (0 .. $self->count() - 1)
    {
        if (equals($self->type_name, $self->_items_ref->[$i], $element))
        {
            $self->remove_at($i);
            return 1;
        }
    }
    return 0;
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;
__END__

=encoding utf8

=head1 名前

ATLib::Std::Collections::List - 索引を使用して要素にアクセスできる、ジェネリックなリスト

=head1 バージョン

この文書は ATLib::Std version v0.2.0 について説明しています。

=head1 概要

    use ATLib::Std::Collections::List;
    use ATLib::Std::Int;
    use ATLib::Std::String;

    my $instance = ATLib::Std::Collections::List->of(q{ATLib::Std::String});
    my $count = $instance->count(); # 0

    my $string = ATLib::Std::String->from(q{Hello, ATLib::Std system.});

    $instance->add($string);
    $instance->add($string);
    $result = $instance->contains($string); # 1
    $count = $instance->count(); # 2

    $instance->remove($string);
    $result = $instance->contains($string); # 1
    $count = $instance->count(); # 1

    $instance->remove_at(0);
    $count = $instance->count(); # 0

    $instance->clear();

    $instance = ATLib::Std::Collections::List->from(q{ATLib::Std::Int}, qw{1 2 3 4 5});

=head1 基底クラス

L<< ATLib::Std::Any >>

=head1 インターフェース

L<< ATLib::Std::Role::Generic >>
L<< ATLib::Std::Role::Collection >>

=head1 説明

ATLib::Std::Collections::List は、ATLib::Stdで提供される L<< Mouse >> で実装されたジェネリックなリストです。
未定義値を含む、L<< Mouse >>の型やL<< ATLib::Std::String >>派生型を要素として格納することができ、
索引でのアクセスとその他の基本操作が可能です。

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::Collections::List->of($T); >>

$T型の要素を格納するリストのインスタンスを生成します。

=head2 C<< $instance = ATLib::Std::Collections::List->from($T, @array); >>

指定されたPerlの配列から$T型の要素を格納するリストのインスタンスを生成します。

=head1 プロパティ

=head2 C<< $type_name = $instance->type_name;  >>

インスタンスの L<< Mouse >> における型名 Maybe[$instance->T] を取得します。
ここで$TはL<< Mouse >> が対応する以下に示す型名となります。

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

=head2 C<< $element = $instance->items($index, $element); -E<gt> T >>

索引 $index の位置にある要素を取得します。
または、索引 $index の位置に要素 $element を設定します。$elementの型がundefか$instance->T型ではない場合は
例外L<< ATLib::Std::Exception::Argument >>が発生します。

=head2 C<< $count = $instance->count; -E<gt> >> L<< ATLib::Std::Int >>

インスタンスに格納されている要素数を取得します。

=head1 インスタンスメソッド

=head2 C<< $result = $instance->contains($element); >>

要素$elementがインスタンスに格納されているかどうかを判定して返します。

=head2 C<< $instance = $instance->clear();  >>

インスタンスに格納されているすべての要素を削除します。
また、操作結果のインスタンスを返します。

=head2 C<< $instance = $instance->add($element); >>

インスタンスの最後尾に要素$elementを追加します。
$elementの型がundefか$instance->T型ではない場合は、例外L<< ATLib::Std::Exception::Argument >>が発生します。
また、操作結果のインスタンスを返します。

=head2 C<< $instance = $instance->remove_at($index);  >>

インスタンスの索引$indexの位置にある要素を削除します。
$indexが要素数以上の場合は、例外L<< ATLib::Std::Exception::Argument >>が発生します。
また、操作結果のインスタンスを返します。

=head2 C<< $result = $instance->remove($element); >>

インスタンスの要素から最初に見つかった要素$elementを削除します。
要素が削除できたかどうかを示す値を返します。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2023 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut