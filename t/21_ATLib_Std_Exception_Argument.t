#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 5;

use ATLib::Std::String;

#1
my $class = q{ATLib::Std::Exception::Argument};
use_ok($class);

#2
my $message = ATLib::Std::String->from(q{The unit testing.});
my $param_name = ATLib::Std::String->from(q{$param_name});
my $instance = ATLib::Std::Exception::Argument->new({message => $message, param_name => $param_name});
isa_ok($instance, $class);

#3
is($instance->type_name, $class);

#4
is($instance->message, $message);

#5
is($instance->param_name, $param_name);

done_testing();
__END__