#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 4;

use ATLib::Std::String;

#1
my $class = 'ATLib::Std::Exception::Format';
use_ok($class);

#2
my $message = ATLib::Std::String->from(q{The unit testing.});
my $instance = $class->new({message => $message});
isa_ok($instance, $class);

#3
is($instance->type_name, $class);

#4
is($instance->message, $message);

done_testing();
__END__
