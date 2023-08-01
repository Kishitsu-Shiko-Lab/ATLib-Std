package ATLib::Std::Exception::Argument;
use Mouse;
extends 'ATLib::Std::Exception';

# Overloads
use overload(
    q{""}    => \&as_string,
    fallback => 1,
);

# Attributes
has 'param_name' => (is => 'rw', isa => 'ATLib::Std::String', required => 1);

# Instance Methods
sub as_string
{
    my $self = shift;
    return
        $self->get_full_name() . q{: } . $self->message . qq{\n}
            . q{Parameter name: } . $self->param_name . qq{\n\n}
            . $self->stack_trace;
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;
__END__

=encoding utf8

=head1 名前

ATLib::Std::Exception::Argument - ATLib::Stdにおける標準型で引数に関する構造化例外を表すクラス

=head1 バージョン

この文書は ATLib::Std version v0.2.0 について説明しています。

=head1 概要

    use ATLib::Std::String;
    use ATLib::Std::Exception::Argument;
    use English qw{ -no_match_vars }; # $EVAL_ERROR

    sub something_throw
    {
      my $arg = shift;

      # 何か処理を行う
      ATLib::Std::Exception::Argument->new({
        message    => ATLib::Std::String->from({q{Type mismatch.}),
        param_name => ATLib::Std::String->from(q{$arg}),
      })->throw();
    }

    # 例外捕捉の仕方は ATLib::Std::Exception を参照

=head1 基底クラス

L<< ATLib::Std::Any >> E<gt>- L<< ATLib::Std::Exception >>

=head1 説明

ATLib::Std::Exception::Argument は、ATLib::Stdで提供される L<< Mouse >> で実装された引数に関する構造化例外表す型です。

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::Exception::Argument->new({ message => $message, param_name => $param_name }); >>

C<< $message -E<gt> >> L<< ATLib::Std::String >>
C<< $param_name -E<gt> >> L<< ATLib::Std::String >>

$messageを例外メッセージとするインスタンスを生成します。
$messageは省略可能です。

=head1 オーバーロード

=head2 文字列化 C<< "" >>

スカラコンテキストでは、クラスに格納された例外メッセージとスタックトレースを
文字列型 L<< ATLib::Std::String >> 化して返します。
このコンテキストは比較時に文字列形式など Perlから使用されます。

=head1 プロパティ

=head2 C<< $message = $instance->message($message); -E<gt> >> L<< ATLib::Std::String >>

例外メッセージを取得、または設定します。

=head2 C<< $param_name = $instance($param_name); -E<gt> >> L<< ATLib::Std::String >>

引数の名前を取得、または設定します。

=head2 C<< $long_stack_trace = $instance->source; -E<gt> >> L<< ATLib::Std::String >>

長い形式のスタックトレースを取得します。

=head2 C<< $short_stack_trace = $instance->stack_trace; -E<gt> >> L<< ATLib::Std::String >>

短い形式のスタックトレースを取得します。

=head1 クラスメソッド

=head2 C<< $result = ATLib::Std::Exception->caught($object);  >>

スロー(croak)されたオブジェクトが本クラスの例外かどうかを判定します。

=head1 インスタンスメソッド

=head2 C<< $hash_code = $instance->get_hash_code(); -E<gt> >> L<< ATLib::Std::String >>

インスタンスのハッシュコードを取得します。
この値はオブジェクトの参照等価性チェックに使用されるため、必要な場合はオーバーライドします。

=head2 C<< $result = $instance->equals($target); >>

$targetが$instanceと参照等価であるかを判定します。

=head2 C<< $class_name = $instance->get_full_name(); -E<gt> >> L<< ATLib::Std::String >>

インスタンスのクラスの完全名を取得します。これは Perlにおけるパッケージ名です。

=head2 C<< $instance->throw(); >>

当該インスタンスを例外オブジェクトとしてスロー(croak())します。

=head2 C<< $string = $instance->as_string(); >>

例外の型名 C<< $instance->full_name() >> 、例外メッセージ C<< $instance->message >> 、
引数名 C<< $instance->param_name >>、およびスタックトレース C<< $instance->stack_trace >> を
整形した文字列を返します。
スカラコンテキストではこのメソッドの結果を返します。

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2022 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut