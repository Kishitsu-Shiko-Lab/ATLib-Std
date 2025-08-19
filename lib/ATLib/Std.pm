package ATLib::Std;
use 5.016_001;
use version; our $VERSION = version->declare('v0.4.1');
use strict;
use warnings;

sub import
{
    use ATLib::Std::Any;
    use ATLib::Std::Bool;
    use ATLib::Std::String;
    use ATLib::Std::Exception;
    use ATLib::Std::Exception::Argument;
    use ATLib::Std::Exception::InvalidOperation;
    use ATLib::Std::Exception::InvalidCast;
    use ATLib::Std::Number;
    use ATLib::Std::Int;
    use ATLib::Std::Radix;
    use ATLib::Std::DateTime;
    use ATLib::Std::Maybe;
    use ATLib::Std::Collections::List;
    use ATLib::Std::Collections::Dictionary;
}

1;
__END__

=encoding utf8

=head1 名前

ATLib::Std - ATLib 標準型システムの L<< Mouse >> による実装

=head1 バージョン

この文書は ATLib::Std version v0.4.0 について説明しています。

=head1 概要

それぞれのクラスのドキュメントを参照してください。

=head1 説明

ATLib::Std は、Perlでの開発に.NET Frameworkのような共通型を L<< Mouse >> による実装で導入します。

=head1 インターフェース

=head2 L<< ATLib::Std::Role::Generic >>

型を1個内包するジェネリック型を定義するためのインターフェースです。

=head2 L<< ATLib::Std::Role::Generic2 >>

型を2個内包するジェネリック型を定義するためのインターフェースです。

=head1 クラス

=head2 L<< ATLib::Std::Any >>

ATLib におけるすべての型の基底クラスです。

=head2 L<< ATLib::Std::Bool >>

真偽値を表す標準型です。

=head2 L<< ATLib::Std::Exception >>

構造化例外を表す標準型です。

=head2 L<< ATLib::Std::Exception::Argument >>

引数に関する構造化例外を表す標準型です。

=head2 L<< ATLib::Std::Exception::InvalidOperation >>

無効なメソッド呼び出しを表す構造化例外です。

=head2 L<< ATLib::Std::Exception::InvalidCast >>

無効なキャストを表す構造化例外です。

=head2 L<< ATLib::Std::Exception::Format >>

無効な引数での書式指定を表す構造化例外です。

=head2 L<< ATLib::Std::String >>

文字列を表す標準型。Perlの特性に従い、他の値型のルートとなります。

=head2 L<< ATLib::Std::Number >>

数値を表す標準型。Perlの特性に従い、文字列型から派生します。

=head2 L<< ATLib::Std::Int >>

整数値を表す整数型。数値型から派生します。

=head2 L<< ATLib::Std::Radix >>

基数計算に使用する型。

=head2 L<< ATLib::Std::Maybe >>

値型に関して、未定義を許容するジェネリックな標準型です。

=head2 L<< ATLib::Std::Collections::List >>

索引を使用して要素にアクセスできるジェネリックなコレクション型です。

=head2 L<< ATLib::Std::Collections::Dictionary >>

キーを使用して要素にアクセスできるジェネリックなコレクション型です。

=head2 L<< ATLib::Std::DateTime >>

日付、時間の表現、計算を行うための標準型です。

=head1 インストール方法

    $cpanm https://github.com/Kishitsu-Shiko-Lab/ATLib-Utils.git
    $cpanm https://github.com/Kishitsu-Shiko-Lab/ATLib-Std.git

    Or

    $cpm install https://github.com/Kishitsu-Shiko-Lab/ATLib-Std.git

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2025 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut

