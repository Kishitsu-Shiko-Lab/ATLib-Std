package ATLib::Std::Int;
use Mouse;
extends 'ATLib::Std::Number';

# Attributes
has '+_value' => (isa => 'Int');

__PACKAGE__->meta->make_immutable();
no Mouse;
1;
__END__

=encoding utf8

=head1 名前

ATLib::Std::Int - 整数値を表す標準型

=head1 バージョン

この文書は ATLib::Std version v0.4.0 について説明しています。

=head1 概要

    use ATLib::Std;

    my $instance1 = ATLib::Std::Int->from(123);

    my $instance2 = $instance1 + 100; # The value of $instance2 is 223
    my $instance3 = 100 + $instance1; # The value of $instance3 is 223
    # And you can also use operator of '-', '*', and '/'.

    my $result = $instance1->compare(123); # 1
    my $result = $instance2->compare($instance3); # 0
    my $result = $instance3->compare($instance1); # -1
    # And you can also use operator of '<', '<=', '>', '>='.

    my $result = $instance1->equals(123); # 1
    my $result = $instance1->equals($instance2); # 0
    # And you can also use operator of '==', '!='.

=head1 基底クラス

L<< ATLib::Std::Any >> E<lt>- L<< ATLib::Std::String >> E<lt>- L<< ATLib::Std::Number >>

=head1 説明

ATLib::Std::Int は、ATLib::Stdで提供される L<< Mouse >> で実装された整数値を表す型です。
本クラスは Perlの特性に従って、文字列型 L<< ATLib::Std::String >> から派生しています。

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::Int::from($value);  >>

$valueを整数値とするインスタンスを生成します。

=head1 オーバーロード

=head2 文字列化 C<< "" >>

スカラコンテキストでは、クラスに格納された整数値を文字列型 L<< ATLib::Std::String >> 化して返します。
このコンテキストは比較時に文字列形式の数値変換など Perlから使用されます。

=head2 演算子 C<< + >>

被演算子となった数値を加算して、新たな数値型クラスを返します。

=head2 演算子 C<< - >>

被演算子となった数値を減算して、新たな数値型クラスを返します。

=head1 プロパティ

=head2 C<< $type_name = $instance->type_name;  >>

インスタンスの L<< Mouse >> における型名 C<< ATLib::Std::Int >> を取得します。
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

Copyright (C) 2020-2025 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut