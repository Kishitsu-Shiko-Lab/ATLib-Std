package ATLib::Std::Collections::Dictionary;
use Mouse;
extends 'ATLib::Std::Any';
with qw{ATLib::Std::Role::Generic2 ATLib::Std::Role::Collection};

use ATLib::Utils qw{as_type_of equals};
use ATLib::Std::Int;
use ATLib::Std::Exception::Argument;

# Attributes
has '_items_ref' => (
    is         => q{rw},
    isa        => q{HashRef[Maybe[Defined]]},
    lazy_build => 1,
);

sub items
{
    my $self = shift;
    my $key = shift;
    my $value = shift if (scalar(@_) > 0);

    if (!$self->contains_key($key))
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Key is not found.}),
            param_name => ATLib::Std::String->from(q{$key}),
        })->throw();
    }

    if (defined $value)
    {
        $self->_items_ref->{$key} = $value;
        return;
    }
    return $self->_items_ref->{$key};
}

# Builder
sub _build__items_ref { return {} };

# Class Methods
sub of
{
    my $class = shift;
    my $TKey = shift;
    my $TValue = shift;

    return $class->new({type_name => qq{Maybe[$TValue]}, T1 => $TKey, T2 => $TValue})
}

sub from
{
    my $class = shift;
    my $TKey = shift;
    my $TValue = shift;
    my %hash = @_;

    my $instance = $class->of($TKey, $TValue);
    for my $key (keys(%hash))
    {
        my $key_entry;
        if ($TKey->isa(q{ATLib::Std::String}))
        {
            $key_entry = $TKey->from($key);
        }
        else
        {
            $key_entry = $key;
        }

        my $value_entry;
        if ($TValue->isa(q{ATLib::Std::String}))
        {
            $value_entry = $TValue->from($hash{$key});
        }
        else
        {
            $value_entry = $hash{$key};
        }
        $instance->add($key_entry, $value_entry);
    }
    return $instance;
}

# Instance Methods
sub count
{
    my $self = shift;

    my @keys = keys(%{$self->_items_ref});
    return ATLib::Std::Int->from(scalar(@keys));
}

sub contains
{
    my $self = shift;
    my $key = shift;

    if (!defined $key)
    {
        ATLib::Std::Exception::Argument->new(
            message    => ATLib::Std::String->from(q{Argument must be defined.}),
            param_name => ATLib::Std::String->from(q{$key}),
        )->throw();
    }

    if ($self->count() == 0)
    {
        return 0;
    }

    if (exists $self->_items_ref->{$key})
    {
        return 1;
    }
    return 0;
}

sub contains_key
{
    my $self = shift;
    my $key = shift;
    return $self->contains($key);
}

sub contains_value
{
    my $self = shift;
    my $value = shift;

    if ($self->count() == 0)
    {
        return 0;
    }

    my @values = values(%{$self->_items_ref});
    if (!defined $value)
    {
        for my $item (@values)
        {
            if (!defined $item)
            {
                return 1;
            }
        }
        return 0;
    }

    if (!as_type_of($self->type_name, $value))
    {
        my $type_name = $self->type_name;
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(qq{Type mismatch. The \$value must be $type_name.}),
            param_name => ATLib::Std::String->from(q{$value}),
        })->throw();
    }

    if ($value->isa(q{ATLib::Std::Any}))
    {
        for my $item (@values)
        {
            if ($value->equals($item))
            {
                return 1;
            }
        }
    }

    for my $item (@values)
    {
        if (equals($self->T2, $item, $value))
        {
            return 1;
        }
    }
    return 0;
}

sub clear
{
    my $self = shift;
    $self->_items_ref({});
    return $self;
}

sub add
{
    my $self = shift;
    my $key = shift;
    my $value = shift;

    if (!as_type_of($self->T1, $key))
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Type mismatch.}),
            param_name => ATLib::Std::String->from(q{$key}),
        })->throw();
    }

    if (!as_type_of($self->type_name, $value))
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Type mismatch.}),
            param_name => ATLib::Std::String->from(q{$value}),
        })->throw();
    }

    if ($self->contains_key($key))
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Key is already exist.}),
            param_name => ATLib::Std::String->from(q{$key}),
        })->throw();
    }

    $self->_items_ref->{$key} = $value;
    return $self;
}

sub remove
{
    my $self = shift;
    my $key = shift;

    if (!$self->contains_key($key))
    {
        return 0;
    }
    delete $self->_items_ref->{$key};
    return 1;
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;
__END__

=encoding utf8

=head1 名前

ATLib::Std::Collections::Dictionary - キーを使用して要素にアクセスできる、ジェネリックなハッシュ型

=head1 バージョン

この文書は ATLib::Std:: version 0.2.0 について説明しています。

=head1 概要

    use ATLib::Std::Collections::Dictionary;
    use ATLib::Std::Int;
    use ATLib::Std::String;

    my $TKey = q{Str};
    my $TValue = q{ATLib::Std::String};
    my $instance = ATLib::Std::Collections::Dictionary->of($TKey, $TValue);
    my $count = $instance->count();  #0

    $instance->add(q{Hello}, $TValue->from(q{world.}));
    $result = $instance->contains_key(q{Hello});  #1
    $result = $instance->contains_value(q{world.});  #1
    $count = $instance->count();  #1

    $instance->remove(q{Hello});
    $result = $instance->contains_key(q{Hello});  #0
    $result = $instance->contains_value(q{world.});  #0
    $count = $instance->count();  #0

    $instance->clear();

=head1 基底クラス

L<< ATLib::Std::Any >>

=head1 インターフェース

L<< ATLib::Std::Role::Generic2 >>
L<< ATLib::Std::Role::Collection >>

=head1 説明

ATLib::Std::Collections::Dictionary は、ATLib::Stdで提供される L<< Mouse >> で実装されたジェネリックなハッシュです。
未定義値を含む、L<< Mouse >>の型やL<< ATLib::Std::String >>派生型を要素として格納することができ、
キーでのアクセスとその他基本操作が可能です。

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::Collections::Dictionary->of($TKey, $TValue); >>

キーの型を$TKey、値の型を$TValueとするハッシュのインスタンスを生成します。

=head2 C<< $instance = ATLib::Std::Collections::Dictionary->from($TKey, $TValue, %hash);  >>

指定されたPerlのハッシュから、キーの型を$TKey、値の型を$TValueとするハッシュのインスタンスを生成します。

=head1 プロパティ

=head2 C<< $type_name = $instance->type_name;  >>

インスタンスの L<< Mouse >> における型名 Maybe[$instance->T2] を取得します。
ここで$T2はL<< Mouse >> が対応する以下に示す型名となります。

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

=head2 C<< $element = $instance->items($key, $value); -E<gt> T2 >>

$keyに対応する値を取得します。または、$keyに対応する値 $valueを設定します。
$keyが存在しない場合は、例外L<< ATLib::Std::Exception::Argument >>が発生します。

=head2 C<< $count = $instance->count; -E<gt> >> L<< ATLib::Std::Int >>

インスタンスに格納されている要素数を取得します。

=head1 インスタンスメソッド

=head2 C<< $result = $instance->contains_key($key); >>

$keyがコレクションに存在するかどうかを判定して返します。

=head2 C<< $result = $instance->contains_value($value); >>

$valueがコレクションに存在するかどうかを判定して返します。

=head2 C<< $instance = $instance->clear();  >>

インスタンスに格納されているすべての要素を削除します。
また、操作結果のインスタンスを返します。

=head2 C<< $instance = $instance->add($key, $value); >>

$key、$valueのエントリーをコレクションに追加します。
また、操作結果のインスタンスを返します。
$keyの型がundefか$instance->T1型ではない場合は、例外L<< ATLib::Std::Exception::Argument >>が発生します。
$valueの型がundefか$instance->T2型ではない場合は、例外L<< ATLib::Std::Exception::Argument >>が発生します。
$keyが既にコレクションに存在する場合は、例外L<< ATLib::Std::Exception::Argument >>が発生します。

=head2 C<< $result = $instance->remove($key); >>

$keyに対応するエントリーをインスタンスから削除します。
エントリーが削除できたかどうかを示す値を返します。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2022 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut
