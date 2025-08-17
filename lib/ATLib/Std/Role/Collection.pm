package ATLib::Std::Role::Collection;
use Mouse::Role;

# Interface
requires qw{ item count contains clear add remove };

no Mouse::Role;
1;
__END__

=encoding utf8

=head1 名前

ATLib::Std::Role::Collection - コレクションを表すインターフェース

=head1 バージョン

この文書は ATLib::Utils version v0.4.0 について説明しています。

=head2 概要

    use Mouse;
    with 'ATLib::Std::Role::Collection';

    ...

=head1 説明

ATLib::Std::Role::Collectionは、コレクション型を定義するためのインターフェースです。

=head1 メソッド

=head2 C<< $count = $instance->count(); -E<gt> ATLib::Std::Int >>

コレクションに格納されている要素数を返すように実装します。

=head2 C<< $result = $instance->contains($element); >>

コレクションに要素として$elementが格納されているかどうかを判定した結果を返すように実装します。

=head2 C<< $instance = $instance->clear(); >>

コレクションに格納されている要素をすべて削除して、処理後のインスタンスを返すように実装します。

=head2 C<< $instance = $instance->add($element);  >>

コレクションの要素に$elementを追加して、処理後のインスタンスを返すように実装します。

=head2 C<< $result = $instance->remove_at($index);  >>

コレクションの要素から$indexの位置の要素を削除するように実装します。

=head2 C<< $instance->remove($element);  >>

コレクションの要素から最初に見つかった$elementの削除を試行して、処理結果を返却するように実装します。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2025 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut