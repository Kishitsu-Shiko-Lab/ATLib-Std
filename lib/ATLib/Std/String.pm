package ATLib::Std::String;
use Mouse;
extends 'ATLib::Std::Any';

use ATLib::Utils qw{ as_type_of };
use ATLib::Std::Bool;

# Overloads
use overload(
    q{""}  => \&as_string,
    q{cmp} => \&_compare,
    q{.}   => \&_concat,
    fallback => 1,
);

# Attributes
has '_value' => (is => 'rw', isa => 'Str', required => 1);

# Overload Handler
sub _compare
{
    my ($this, $that, $swap) = @_;

    if (defined $swap && $swap)
    {
        if (blessed($that))
        {
            return $that->compare($this);
        }
        else
        {
            return ATLib::Std::String->from($that)->compare($this);
        }
    }
    else
    {
        if (blessed($this))
        {
            return $this->compare($that);
        }
        else
        {
            return ATLib::Std::String->from($this)->compare($that);
        }
    }
}

sub _concat
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
        $value .= $that->_value;
        if (!(defined $class) || $class)
        {
            $class = $that->get_full_name();
        }
    }
    else
    {
        if (defined $swap && $swap)
        {
            $value = $that . $value;
        }
        else
        {
            $value .= $that;
        }
    }

    if (!(defined $class) || !$class)
    {
        $class = __PACKAGE__;
    }

    return $class->from($value);
}

# Class Methods
sub from
{
    my $class = shift;
    my $value = shift;

    if (as_type_of('ATLib::Std::String', $value))
    {
        $value = $value->_value;
    }
    return $class->new({_value => $value});
}

sub is_undef_or_empty
{
    my $class = shift;
    my $target = shift;

    return ATLib::Std::Bool->true if !defined $target;
    return ATLib::Std::Bool->true if blessed($target) && $target->can(q{_value}) && $target eq q{};
    return ATLib::Std::Bool->true if $target eq q{};
    return ATLib::Std::Bool->false;
}

# Instance Methods
sub as_string
{
    my $self = shift;
    return $self->_value;
}

sub _can_equals
{
    my $self = shift;
    my $target = shift;

    if (!ATLib::Std::String->is_undef_or_empty($target) && $self->SUPER::_can_equals($target))
    {
        if (blessed($target) && $target->can(q{_value}))
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

    if (!(defined $target))
    {
        return 1;
    }

    if ($self->_can_equals($target))
    {
        return $self->_value cmp $target->_value;
    }

    return $self->_value cmp $target;
}

sub equals
{
    my $self = shift;
    my $target = shift;

    return $self->compare($target) == 0 ? ATLib::Std::Bool->true : ATLib::Std::Bool->false;
}

sub get_length
{
    my $self = shift;
    return length($self);
}

sub starts_with
{
    my $self = shift;
    my $start = shift;

    if ($self =~ m{^($start)}ms)
    {
        return ATLib::Std::Bool->true;
    }
    return ATLib::Std::Bool->false;
}

sub ends_with
{
    my $self = shift;
    my $end = shift;

    if ($self =~ m{($end)$}ms)
    {
        return ATLib::Std::Bool->true;
    }
    return ATLib::Std::Bool->false;
}

sub index_of
{
    my $self = shift;
    my $search = shift;
    return index($self, $search);
}

sub to_lower
{
    my $self = shift;
    return ATLib::Std::String->from(lc($self));
}

sub to_upper
{
    my $self = shift;
    return ATLib::Std::String->from(uc($self));
}

sub trim_start
{
    my $self = shift;

    my $after = $self->_value;
    $after =~ s{^\s*}{}gxms;
    return __PACKAGE__->from($after);
}

sub trim_end
{
    my $self = shift;

    my $after = $self->_value;
    $after =~ s{\s*$}{}gxms;
    return __PACKAGE__->from($after);
}

sub trim
{
    my $self = shift;

    my $after = $self->trim_start()->trim_end();
    return __PACKAGE__->from($after->as_string());
}

sub replace
{
    my $self = shift;
    my $old_string = shift;
    my $new_string = shift;

    if ($self->is_undef_or_empty($old_string))
    {
        ATLib::Std::Exception::Argument->new({
            message    => q{$old_value is not specified.},
            param_name => q{$old_value},
        })->throw();
    }

    if ($self->is_undef_or_empty($new_string))
    {
        $new_string = ATLib::Std::String->from('');
    }

    my $replaced = $self->as_string();
    $replaced =~ s{ @{[quotemeta($old_string)]} }{ $new_string }gxms;

    return __PACKAGE__->from($replaced);
}

sub substring
{
    my $self = shift;
    my $index = shift;
    my ($length) = @_;

    my $part_of_string = q{};
    if (defined $length)
    {
        $part_of_string = substr($self, $index, $length);
    }
    else
    {
        $part_of_string = substr($self, $index);
    }

    return __PACKAGE__->from($part_of_string);
}

sub split
{
    my $self = shift;
    my $separator = shift;

    my @result = split($separator, $self->as_string());
    my @strings = ();
    for my $word (@result)
    {
        my $string = ATLib::Std::String->from($word);
        $strings[scalar(@strings)] = $string;
    }
    return @strings;
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;
__END__

=encoding utf8

=head1 名前

ATLib::Std::String - 文字列を表す標準型

=head1 バージョン

この文書は ATLib::Std version v0.4.0 について説明しています。

=head1 概要

    use ATLib::Std;

    my $instance = ATLib::Std::String->from(q{Hello, ATLib::Std::String});
    my $instance2 = ATLib::Std::String->from($instance);

    my $result = ATLib::Std::String->is_undef_or_empty(undef);
    my $result = ATLib::Std::String->is_undef_or_empty(q{});

    my $result = $instance->compare(q{Hello});  # -1
    my $result = $instance->compare($instance); # 0
    my $result = $instance->compare(q{Hello, ATLib::Std::String::Bigger}); # 1

    # You can use operator to compare; lt, le, gt, ge, eq, and cmp.
    my $result = $instance cmp q{Hello}; # -1

    my $result = $instance->equals(q{Hello, ATLib::Std::String});

    my $new_instance = $instance . q{, World.};

    my $result = $instance->starts_with(q{Hello,});
    my $result = $instance->ends_with(q{World.});

    my $index = $instance->index_of(q{,}); # 5

    my $lower_string = $instance->to_lower();
    my $upper_string = $instance->to_upper();

    my $string = $instance->trim_start();
    my $string = $instance->trim_end();
    my $string = $instance->trim();

    my $string = $instance->replace(',', ''); # Hello ATLib::Std::String

    my $string = $instance->substring(0, 5); # Hello

    my $string = q{Hello, world.};
    my @words = $new_instance->split(' ');

=head1 基底クラス

L<< ATLib::Std::Any >>

=head1 説明

ATLib::Std::String は、ATLib::Stdで提供される L<< Mouse >> で実装された文字列を表す型です。
文字列についての様々な操作を提供します。
本クラスは Perlの特性に従って、数値型を含むすべての値型のルートクラスとなります。

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::String->from($value);  >>

$valueを文字列値とするインスタンスを生成します。
$valueがATLib::Std::Stringのインスタンスの場合は、その値で新しいインスタンスを生成します。

=head1 オーバーロード

=head2 文字列化 C<< "" >>

スカラコンテキストでは、クラスに格納された文字列を返します。

=head2 文字列比較演算子 C<< lt, le, gt, ge, eq, cmp >>

標準の文字列比較演算子を使用できます。

=head2 演算子 C<< . >>

指定された文字列を結合した新たな文字列クラスを返します。

=head1 クラスメソッド

=head2 C<< $result = ATLib::Std::String->is_undef_or_empty($string); >> -E<gt> L<< ATLib::Std::Bool >>

$stringがundefか、または空文字列かどうかを判定します。

=head1 インスタンスメソッド

=head2 C<< $hash_code = $instance->get_hash_code();  >>

インスタンスのハッシュコードを取得します。
この値はオブジェクトの参照等価性チェックに使用されるため、必要な場合はオーバーライドします。

=head2 C<< $class_name = $instance->get_full_name();  >>

インスタンスのクラスの完全名を取得します。これは Perlにおけるパッケージ名です。

=head2 C<< $value = $instance->as_string(); >>

格納されている文字列を返します。
スカラコンテキストではこのメソッドの結果を返します。

=head2 C<< $result = $instance->_can_equals($target);  >>

等価性チェックで $target が比較可能であるかを判定します。
既定の実装では、基底クラスの C<< _can_equals($target) >> で$targetが基底クラスの派生クラスであるかを判定した後に、
値型 C<< _value >> プロパティが存在するかどうかを判定します。
必要な場合は派生クラスでオーバーライドします。

=head2 C<< $result = $instance->compare($target);  >>

$instanceと$targetを文字列比較します。
等しい場合は 0、$instanceが大きい場合は 1、小さい場合は -1を返します。

=head2 C<< $result = $instance->equals($target); >> -E<gt> L<< ATLib::Std::Bool >>

$targetが$instanceと等価であるかを判定します。
判定には、C<< $instance->compare($target) >> が使用されます。
必要に応じて、派生クラスでオーバーライドします。

=head2 C<< $length = $instance->get_length(); >>

格納されている文字列の長さを返します。

=head2 C<< $result = $instance->starts_with($start);  >> -E<gt> L<< ATLib::Std::Bool >>

文字列が指定した文字列 $start で始まるかどうかを判定します。

=head2 C<< $result = $instance->ends_with($end);  >> -E<gt> L<< ATLib::Std::Bool >>

文字列が指定した文字列 $end で終わるかどうかを判定します。

=head2 C<< $index = $instance->index_of($search); >>

指定した文字列 $search が最初に見つかる位置の索引を返します。

=head2 C<< $string = $instance->to_lower();  -E<gt> >> L<< ATLib::Std::String >>

文字列中の英字をすべて小文字にした新しい文字列を返します。

=head2 C<< $string = $instance->to_upper(); -E<gt> >> L<< ATLib::Std::String >>

文字列中の英字をすべて大文字にした新しい文字列を返します。

=head2 C<< $string = $instance->trim_start(); -E<gt> >> L<< ATLib::Std::String >>

文字列の先頭の空白を削除した新しい文字列を返します。

=head2 C<< $string = $instance->trim_end(); -E<gt> >> L<< ATLib::Std::String >>

文字列の末尾の空白を削除した新しい文字列を返します。

=head2 C<< $string = $instance->trim(); -E<gt> >> L<< ATLib::Std::String >>

文字列の先頭と末尾の空白を削除した新しい文字列を返します。

=head2 C<< $string = $instance->replace($old_string, $new_string); >> -E<gt> >> L<< ATLib::Std::String >>

文字列中の $old_string を $new_string に置換した結果の新しい文字列を返します。
$old_string が未指定の場合は、例外 L<< ATLib::Std::Exception::Argument >> が発生します。

=head2 C<< $string = $instance->substring($offset[, $length]); -E<gt> >> L<< ATLib::Std::String >>

文字列の指定した位置 $offset から指定した長さ $length の新しい部分文字列を返します。
$lengthを省略した場合は、指定した位置 $offset 以降の新しい部分文字列を返します。

=head2 C<< @words = $instance->split($separator); >> -E<gt> ARRAY E<lt> L<< ATLib::Std::String >> E<gt>

文字列を指定した$separatorで分割してリストで返します。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2025 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut
