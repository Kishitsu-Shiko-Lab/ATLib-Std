#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 18;
use English qw{ -no_match_vars };

use ATLib::Std::String;

#1
my $class = q{ATLib::Std::Exception};
use_ok($class);

#2
my $message = ATLib::Std::String->from(q{Exception occurred by something_throw().});
my $exception_with_message = $class->new({message => $message});
isa_ok($exception_with_message, $class);

#3
is($exception_with_message->type_name, $class);

#4
my $class_as_string = q{ATLib::Std::String};
my $hash_code = $exception_with_message->get_hash_code();
isa_ok($hash_code, $class_as_string);

#5
my $full_name = $exception_with_message->get_full_name();
isa_ok($full_name, $class_as_string);

#6
is($full_name, $class);

#7
isa_ok($exception_with_message->message, $class_as_string);

#8
is($exception_with_message->message, $message);

#9
my $exception_without_message = $class->new();
isa_ok($exception_without_message, $class);

#10
my $hash_code_without_message = $exception_without_message->get_hash_code();
isa_ok($hash_code_without_message, $class_as_string);

#11
is($exception_with_message->equals($exception_with_message), 1);

#12
is($exception_with_message->equals($exception_without_message), 0);

#>> 13 - 15
sub raise_exception
{
    my $exception = shift;
    $exception->throw();
}

my $pass_point_1 = 0;
eval
{
    raise_exception($exception_with_message);
    $pass_point_1 = 1;
};

#13
is($pass_point_1, 0);

#14
isa_ok($EVAL_ERROR, $class);

my $pass_point_2 = 0;
if ($class->caught($EVAL_ERROR))
{
    $pass_point_2 = 1;
}

#15
is($pass_point_2, 1);

#<<

#>> 16 - 17
$pass_point_1 = 0;
$pass_point_2 = 0;
sub raise_runtime_error
{
    die(q{Runtime error raised.});
}

eval
{
    raise_runtime_error();
};

#16
ok($EVAL_ERROR);

if ($class->caught($EVAL_ERROR))
{
    $pass_point_1 = 1;
}

#17
is($pass_point_1, 0);

#<<

#18
my $plain_message = 'Plain message';
my $exception = ATLib::Std::Exception->new({message => $plain_message});
isa_ok($exception->message, $class_as_string);

done_testing();
__END__
