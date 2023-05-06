# 名前

ATLib::Std - ATLib 共通型システムの [Mouse](https://metacpan.org/pod/Mouse) による実装

# バージョン

この文書は ATLib::Std version v0.2.4 について説明しています。

# 概要

それぞれのクラスのドキュメントを参照してください。

# 説明

ATLib::Std は、Perlでの開発に.NET Frameworkのような共通型を [Mouse](https://metacpan.org/pod/Mouse) による実装で導入します。
標準型は.NET Framework (C#) での開発経験からエンタープライズ開発で便利と考えられるものを、
Perlの型に合わせて作成しております。

# インターフェース

## [ATLib::Std::Role::Generic](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3ARole%3A%3AGeneric)

型を1個内包するジェネリック型を定義するためのインターフェースです。

## [ATLib::Std::Role::Generic2](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3ARole%3A%3AGeneric2)

型を2個内包するジェネリック型を定義するためのインターフェースです。

# クラス

## [ATLib::Std::Any](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3AAny)

共通型システムにおけるルートとなる型です。

## [ATLib::Std::Exception](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3AException)

構造化例外を表す型です。

## [ATLib::Std::Exception::Argument](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3AException%3A%3AArgument)

引数に関する構造化例外を表す型です。

## [ATLib::Std::String](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3AString)

文字列型。Perlの特性に従い、他の値型のルートとなります。

## [ATLib::Std::Number](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3ANumber)

数値型。Perlの特性に従い、文字列型から派生します。

## [ATLib::Std::Int](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3AInt)

整数型。数値型から派生します。

## [ATLib::Std::Radix](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3ARadix)

基数計算に使用する型。

## [ATLib::Std::Maybe](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3AMaybe)

値型に関して、未定義を許容するジェネリックな型です。

## [ATLib::Std::Collections::List](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3ACollections%3A%3AList)

索引を使用して要素にアクセスできるジェネリックなコレクション型です。

## [ATLib::Std::Collections::Dictionary](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3ACollections%3A%3ADictionary)

キーを使用して要素にアクセスできるジェネリックなコレクション型です。

## [ATLib::Std::DateTime](https://metacpan.org/pod/ATLib%3A%3AStd%3A%3ADateTime)

日時型。日付、時間の表現、計算を行うための型です。

# インストール方法

    $cpanm https://github.com/Kishitsu-Shiko-Lab/ATLib-Utils.git
    $cpanm https://github.com/Kishitsu-Shiko-Lab/ATLib-Std.git

# AUTHOR

atdev01 &lt;mine\_t7 at hotmail.com>

# COPYRIGHT AND LICENSE

Copyright (C) 2020-2023 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.
