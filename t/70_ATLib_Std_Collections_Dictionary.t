#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 328;

#1
my $TKey = q{Str};
my $TValue = q{ATLib::Std::String};
my $class = q{ATLib::Std::Collections::Dictionary};
use_ok($class);

#2
my $instance = $class->of($TKey, $TValue);
isa_ok($instance, $class);

#3
is($instance->T1, $TKey);

#4
is($instance->T2, qq{Maybe[$TValue]});

#5
is($instance->type_name, $class);

#6
ok($instance->count()->equals(0));

#7
ok(!$instance->contains_key(''));

#8
use ATLib::Std::Any;
my %test_hash;
my $number_of_entry = 50;
for my $i (0 .. $number_of_entry - 1)
{
    my $key = ATLib::Std::Any->new()->get_hash_code();
    my $value = $TValue->from(ATLib::Std::Any->new()->get_hash_code());
    $test_hash{$key} = $value;
    $instance->add($key, $value);
}

is($instance->count(), $number_of_entry);

#9 - 58
for my $key (keys(%test_hash))
{
    ok($instance->contains_key($key));
}

#59 - 108
for my $key (keys(%test_hash))
{
    my $value = $instance->item($key);
    ok($instance->contains_value($value));
}

#109
my $key_undef = q{UNDEF};
$instance->add($key_undef, undef);
$test_hash{$key_undef} = undef;
++$number_of_entry;
is($instance->count(), $number_of_entry);

#110
ok($instance->contains_value(undef));

#111 - 161, 162 - 212, 213 - 263
use ATLib::Utils qw{as_type_of};
for my $key (@{$instance->get_keys_ref()})
{
    is(as_type_of($TKey, $key), 1);
    is($instance->item($key), $test_hash{$key});
    if (defined $instance->item($key))
    {
        isa_ok($instance->item($key), $TValue);
    }
    else
    {
        is(as_type_of($instance->T2, $instance->item($key)), 1);
    }
}

#264
ok($instance->remove($key_undef));
delete $test_hash{$key_undef};
--$number_of_entry;

#265
is($instance->count(), $number_of_entry);

#266
ok(!$instance->contains_key($key_undef));

#267
$instance->clear();
$number_of_entry = 0;
ok($instance->count()->equals($number_of_entry));

#268
%test_hash = ();
$number_of_entry = 20;
$TKey = q{ATLib::Std::Int};
$TValue = q{ATLib::Std::String};
for my $i (0 .. $number_of_entry - 1)
{
    my $key = $TKey->from($i);
    my $value = ATLib::Std::Any->new()->get_hash_code();
    $test_hash{$key} = $value;
}
$instance = $class->from($TKey, $TValue, %test_hash);
ok($instance->count()->equals($number_of_entry));

#269 - 288, 289 - 308, 309 - 328
my @values = @{$instance->get_values_ref()};
my $i = 0;
for my $key (@{$instance->get_keys_ref()})
{
    is(as_type_of($TKey, $key), 1);
    ok($instance->item($key)->equals($test_hash{$key}));
    ok($instance->item($key)->equals($values[$i]));
    ++$i;
}

done_testing();
__END__
