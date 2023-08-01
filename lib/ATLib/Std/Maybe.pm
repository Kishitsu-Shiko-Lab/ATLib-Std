package ATLib::Std::Maybe;
use Mouse;
extends 'ATLib::Std::Any';
with 'ATLib::Std::Role::Generic';

use ATLib::Utils qw{as_type_of is_number};
use ATLib::Std::String;
use ATLib::Std::Exception::Argument;

# Overloads
use overload(
    q{""} => \&as_string,
);

# Attribute
has '_value' => (is => q{rw}, isa => q{Maybe[Item]}, required => 1);
sub value
{
    my $self = shift;
    if (scalar(@_) == 1)
    {
        my $value = shift;
        if (!defined $value)
        {
            $self->_value(undef);
            return;
        }

        if (!as_type_of($self->T, $value))
        {
            ATLib::Std::Exception::Argument->new({
                message    => ATLib::Std::String->from(q{Type mismatch.}),
                param_name => ATLib::Std::String->from(q{$value}),
            })->throw();
        }
        $self->_value($value);
        return;
    }

    return $self->_value;
}

# Class Methods
sub of
{
    my $class = shift;
    my $T = shift;
    my ($value) = @_;

    if (!$T->isa(q{ATLib::Std::String}))
    {
        ATLib::Std::Exception::Argument->new({
            message    => ATLib::Std::String->from(q{Type mismatch.}),
            param_name => ATLib::Std::String->from(q{$T}),
        })->throw();
    }

    return $class->new({T => qq{Maybe[$T]}, _value => $value});
}

# Instance Methods
sub has_value
{
    my $self = shift;
    return 1 if defined $self->value;
    return 0;
}

sub as_string
{
    my $self = shift;
    return $self->value if $self->has_value();
    return "";
}

sub _can_equals
{
    my $self = shift;
    my $target = shift;

    return 1 if(!defined $target);
    return 1 if (blessed($target) && $target->isa($self->get_full_name()));
    return 1 if (blessed($target) && $target->isa($self->T));
    return 0;
}

sub compare
{
    my $self = shift;
    my $target = shift;

    if ($self->_can_equals($target))
    {
        if (!defined $target)
        {
            return $self->has_value() ? 1 : 0;
        }

        if ($target->isa($self->get_full_name()))
        {
            return $self->compare($target->value);
        }

        if ($target->isa($self->T))
        {
            return $target->compare($self->value);
        }
    }

    return defined($target) ? -1 : 0 if (!$self->has_value());
    return $self->value == $target if (is_number($self) && is_number($target));
    return $self->value cmp $target;
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

ATLib::Std::Maybe - 未定義値を値として持つこと許容可能にするジェネリックなクラス

=head1 バージョン

この文書は ATLib::Std version v0.3.0 について説明しています。

=head1 概要

    use ATLib::Std::Maybe;
    use ATLib::Std::String;

    $instance = ATLib::Std::Maybe->of(q{ATLib::Std::String});
    # Or
    $instance = ATLib::Std::Maybe->of(q{ATLib::Std::String}, undef);
    $result = $instance->has_value; # 0

    $string = ATLib::Std::String->from(q{Hello, ATLib.});
    $instance = ATLib::Std::Maybe->of(q{ATLib::Std::String}, $string);

    $result = $instance->has_value; # 1

=head1 基底クラス

L<< ATLib::Std::Any >>

=head1 インターフェース

L<< ATLib::Std::Role::Generic  >>

=head1 説明

ATLib::Std::Maybeは、値型に対して未定義値を値として許容することができるようにします。
ここで値型とは、L<< ATLib::Std::String >>から派生した C<< $instance->_value >>を実装する型です。

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::Maybe->of($T, $value); -E<gt> Maybe[$T]  >>

未定義値を許容する$T型を包含するインスタンスを生成します。
$valueは省略可能で、初期値を設定します。
$Tが値型ではない場合は、例外L<< ATLib::Std::Exception::Argument >>が発生します。

=head1 プロパティ

=head2 C<< $value = $instance->value($value); -E<gt> Maybe[$T]  >>

インスタンスに格納されている値、参照を取得、または設定します。
設定する値、または参照が、undefか$instance->T型ではない場合は例外L<< ATLib::Std::Exception::Argument >>が発生します。

=head1 インスタンスメソッド

=head2 C<< $hash_code = $instance->get_hash_code();  >>

インスタンスのハッシュコードを取得します。
この値はオブジェクトの参照等価性チェックに使用されるため、必要な場合はオーバーライドします。

=head2 C<< $class_name = $instance->get_full_name();  >>

インスタンスのクラスの完全名を取得します。これは Perlにおけるパッケージ名です。

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
