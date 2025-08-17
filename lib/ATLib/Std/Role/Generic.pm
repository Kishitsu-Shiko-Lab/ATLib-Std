package ATLib::Std::Role::Generic;
use Mouse::Role;

# Attributes
has 'T' => (is => q{ro}, isa => q{Defined}, required => 1);

# Interface
requires qw{ of };

no Mouse::Role;
1;
__END__

=encoding utf8

=head1 名前

ATLib::Std::Role::Generic - 型をひとつ持つジェネリックインターフェース

=head1 バージョン

この文書は ATLib::Utils version v0.4.0 について説明しています。

=head1 概要

    use Mouse;
    with 'ATLib::Std::Role::Generic';

    ...

=head1 説明

ATLib::Std::Role::Genericは、型をひとつ持つジェネリック型を定義するためのインターフェースです。

=head1 プロパティ

=head2 C<< $type_name = $instance->T; >>

内包するジェネリック型名を取得します。この型名はコンストラクタで設定されるように実装します。

=head1 メソッド

=head2 C<< $instance = $class->of($T, $initial);  >>

内包するジェネリック型名と初期値を指定して、ジェネリック型のインスタンスが生成されるように実装します。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2025 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut