#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 10;

use Digest::SHA qw{ sha512_base64 };

#1
use_ok(q{ATLib::Std::Any});

#2
my $instance = ATLib::Std::Any->new();
my $hash_code_instance = sha512_base64(scalar($instance));
is($instance->get_hash_code(), $hash_code_instance);

#3
is($instance->get_full_name(), q{ATLib::Std::Any});

#4
is($instance->type_name, q{Item});

#5
is($instance->_can_equals($instance), 1);

#6
is($instance->equals($instance), 1);

#7
my $instance_other = ATLib::Std::Any->new();
is($instance_other->_can_equals($instance), 1);

#8
is($instance_other->equals($instance), 0);

#9
is($instance->_can_equals($instance_other), 1);

#10
is($instance->equals($instance_other), 0);

done_testing();
__END__