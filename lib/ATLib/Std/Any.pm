package ATLib::Std::Any;
use Mouse;

use Digest::SHA qw{ sha512_base64 };

# Attributes
has 'type_name' => (is => q{ro}, isa => q{Str}, required => 1, default => q{Item});

# Instance Methods
sub get_hash_code
{
    my $self = shift;
    return sha512_base64(scalar($self));
}

sub get_full_name
{
    my $self = shift;
    return blessed($self);
}

sub _can_equals
{
    my $self = shift;
    my $target = shift;

    if (!(defined $target))
    {
        return 0;
    }

    return $target->isa($self->get_full_name()) ? 1 : 0;
}

sub equals
{
    my $self = shift;
    my $target = shift;

    if (!(defined $target))
    {
        return 0;
    }

    if (blessed($target) && $target->can(q{_can_equals}) && $target->_can_equals($self))
    {
        if ($self->get_hash_code() eq $target->get_hash_code())
        {
            return 1;
        }
    }

    return 0;
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;

=encoding utf8

=head1 名前

ATLib::Std::Any - ATLib::Stdで提供される標準型のルートクラス

=head1 バージョン

この文書は ATLib::Std version v0.2.0 について説明しています。

=head1 概要

    use ATLib::Std;

=head1 説明

ATLib::Std::Any は、ATLib::Stdで提供される L<< Mouse >> で実装されたクラスのすべてのルートとなるクラスです。
すべてのクラスで必要な最小限の機能を提供します。
このクラスを生成して使用することは基本的にありません。継承先から間接的に機能を使用するか、またはカスタマイズします。

=head1 プロパティ

=head2 C<< $type_name = $instance->type_name;  >>

インスタンスの L<< Mouse >> における型名を取得します。
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

Copyright (C) 2020-2022 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut
