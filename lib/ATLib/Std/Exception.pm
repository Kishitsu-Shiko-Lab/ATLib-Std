package ATLib::Std::Exception;
use Mouse;
extends 'ATLib::Std::Any';

use Carp;

use ATLib::Std::String;

# Overloads
use overload(
    q{""}    => \&as_string,
    fallback => 1,
);

# Attributes
has 'message'     => (is => 'rw', isa => 'ATLib::Std::String');
has 'source'      => (is => 'ro', isa => 'ATLib::Std::String', writer => '_set_source');
has 'stack_trace' => (is => 'ro', isa => 'ATLib::Std::String', writer => '_set_stack_trace');

# Initialize
sub BUILD
{
    my $self = shift;

    local $Carp::Internal{caller()} = 1;
    if (!defined $self->message)
    {
        $self->message(ATLib::Std::String->from(''));
    }

    $self->_set_source(ATLib::Std::String->from(Carp::shortmess()));
    $self->_set_stack_trace(ATLib::Std::String->from(Carp::longmess()));

    return;
}

# Class Methods
sub caught
{
    my $class = shift;
    my $exception = shift;

    return if !blessed($exception);
    return $exception->isa($class);
}

# Instance Methods
sub get_hash_code
{
    my $self = shift;
    return ATLib::Std::String->from($self->SUPER::get_hash_code());
}

sub get_full_name
{
    my $self = shift;
    return ATLib::Std::String->from($self->SUPER::get_full_name());
}

sub throw
{
    my $self = shift;
    croak($self);
}

sub as_string
{
    my $self = shift;
    return
        $self->get_full_name() . q{: } . $self->message . qq{\n\n}
            . $self->stack_trace;
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;
__END__

=encoding utf8

=head1 名前

ATLib::Std::Exception - ATLib::Stdにおける標準型で構造化例外を表すクラス

=head1 バージョン

この文書は ATLib::Std version v0.2.0 について説明しています。

=head1 概要

    use ATLib::Std::String;
    use ATLib::Std::Exception;
    use English qw{ -no_match_vars }; # $EVAL_ERROR

    sub something_throw
    {
      # 何か処理を行う
      ATLib::Std::Exception->new({
        message => ATLib::Std::String->from(q{Exception occurred by something_throw().)
      })->throw();
    }

    # eval() で例外処理を行う方法
    eval
    {
      something_throw();
    };

    if (ATLib::Std::Exception->caught($EVAL_ERROR))
    {
      # 構造化例外を補足した場合の処理
    }
    else
    {
      if ($EVAL_ERROR)
      {
        # 構造化例外ではない例外を補足した場合の処理
      }
    }

    # または try-catch を使用する方法

=head1 基底クラス

L<< ATLib::Std::Any >>

=head1 説明

ATLib::Std::Exception は、ATLib::Stdで提供される L<< Mouse >> で実装された構造化例外表す型です。

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::Exception->new({ message => $message }); >>

C<< $message -E<gt> >> L<< ATLib::Std::String >>

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
およびスタックトレース C<< $instance->stack_trace >> を
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