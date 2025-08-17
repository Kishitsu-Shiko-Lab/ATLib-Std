package ATLib::Std::Collections::Dictionary;
use Mouse;
extends 'ATLib::Std::Any';
with qw{ATLib::Std::Role::Generic2 ATLib::Std::Role::Collection};

use ATLib::Utils qw{as_type_of equals};
use ATLib::Std::Bool;
use ATLib::Std::Int;
use ATLib::Std::Exception::Argument;
use ATLib::Std::Collections::List;

# Attributes
has '_items_key_of_ref' => (
    is  => q{rw},
    isa => q{HashRef[Maybe[Defined]]},
    lazy_build => 1,
);

has '_items_value_of_ref' => (
    is  => q{rw},
    isa => q{HashRef[Maybe[Defined]]},
    lazy_build => 1,
);

sub item
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
        $self->_items_value_of_ref->{$key} = $value;
        return;
    }
    return $self->_items_value_of_ref->{$key};
}

# Builder
sub _build__items_key_of_ref { return {} };
sub _build__items_value_of_ref { return {} };

# Class Methods
sub of
{
    my $class = shift;
    my $TKey = shift;
    my $TValue = shift;

    return $class->new({T1 => $TKey, T2 => qq{Maybe[$TValue]}})
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

    my @keys = keys(%{$self->_items_key_of_ref});
    return ATLib::Std::Int->from(scalar(@keys));
}

sub get_keys_ref
{
    my $self = shift;

    my @keys = ();
    for my $key (keys %{$self->_items_key_of_ref})
    {
        push @keys, $self->_items_key_of_ref->{$key};
    }
    return \@keys;
}

sub get_values_ref
{
    my $self = shift;

    my @values = ();
    for my $key (keys %{$self->_items_key_of_ref})
    {
        push @values, $self->_items_value_of_ref->{$key};
    }
    return \@values;
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
        return ATLib::Std::Bool->false;
    }

    if (exists $self->_items_key_of_ref->{$key})
    {
        return ATLib::Std::Bool->true;
    }
    return ATLib::Std::Bool->false;
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
        return ATLib::Std::Bool->false;
    }

    my @values = @{$self->get_values_ref()};
    if (!defined $value)
    {
        for my $item (@values)
        {
            if (!defined $item)
            {
                return ATLib::Std::Bool->true;
            }
        }
        return ATLib::Std::Bool->false;
    }

    if (!as_type_of($self->T2, $value))
    {
        my $type_name = $self->T2;
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
                return ATLib::Std::Bool->true;
            }
        }
    }

    for my $item (@values)
    {
        if (equals($self->T2, $item, $value))
        {
            return ATLib::Std::Bool->true;
        }
    }
    return ATLib::Std::Bool->false;
}

sub clear
{
    my $self = shift;
    $self->_items_key_of_ref({});
    $self->_items_value_of_ref({});
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

    if (!as_type_of($self->T2, $value))
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

    $self->_items_key_of_ref->{$key} = $key;
    $self->_items_value_of_ref->{$key} = $value;
    return $self;
}

sub remove
{
    my $self = shift;
    my $key = shift;

    if (!$self->contains_key($key))
    {
        return ATLib::Std::Bool->false;
    }
    delete $self->_items_key_of_ref->{$key};
    delete $self->_items_value_of_ref->{$key};
    return ATLib::Std::Bool->true;
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;
__END__

=encoding utf8

=head1 名前

ATLib::Std::Collections::Dictionary - キーを使用して要素にアクセスできる、ジェネリックなハッシュ型

=head1 バージョン

この文書は ATLib::Std:: version 0.4.0 について説明しています。

=head1 概要

    use ATLib::Std::Collections::Dictionary;
    use ATLib::Std::Int;
    use ATLib::Std::String;

    my $TKey = q{Str};
    my $TValue = q{ATLib::Std::String};
    my $instance = ATLib::Std::Collections::Dictionary->of($TKey, $TValue);
    my $count = $instance->count();  #0

    $instance->add(q{Hello}, $TValue->from(q{world.}));
    $result = $instance->contains_key(q{Hello});  # ATLib::Std::Bool->true
    $result = $instance->contains_value(q{world.});  # ATLib::Std::Bool->true
    $count = $instance->count();  #1

    for my $key (@{$instance->get_keys_ref()})
    {
      ...
    }

    for my $value (@{$instance->get_values_ref()})
    {
      ...
    }

    $instance->remove(q{Hello});
    $result = $instance->contains_key(q{Hello});  # ATLib::Std::Bool->false
    $result = $instance->contains_value(q{world.});  # ATLib::Std::Bool->false
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

=head2 C<< $element = $instance->item($key, $value); -E<gt> T2 >>

$keyに対応する値を取得します。または、$keyに対応する値 $valueを設定します。
$keyが存在しない場合は、例外L<< ATLib::Std::Exception::Argument >>が発生します。

=head2 C<< $count = $instance->count; -E<gt> >> L<< ATLib::Std::Int >>

インスタンスに格納されている要素数を取得します。

=head1 インスタンスメソッド

=head2 C<< $keys_array_ref = $instance->get_keys_ref(); >>

コレクションに格納されているキーを配列の参照で取得します。

=head2 C<< $values_array_ref = $instance->get_values_ref(); >>

コレクションに格納されている値を配列の参照で取得します。
C<< $instance->get_keys_ref() >>で取得したキーの順序で取得されます。

=head2 C<< $result = $instance->contains_key($key); >> -E<gt> L<< ATLib::Std::Bool >>

$keyがコレクションに存在するかどうかを判定して返します。

=head2 C<< $result = $instance->contains_value($value); >> -E<gt> L<< ATLib::Std::Bool >>

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

=head2 C<< $result = $instance->remove($key); >> -E<gt> L<< ATLib::Std::Bool >>

$keyに対応するエントリーをインスタンスから削除します。
エントリーが削除できたかどうかを示す値を返します。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2025 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut
