use strict;
use warnings;
use Test::More 0.98;

use_ok $_ for qw(
    ATLib::Std
    ATLib::Std::Any
    ATLib::Std::Bool
    ATLib::Std::String
    ATLib::Std::Number
    ATLib::Std::Int
    ATLib::Std::Radix
    ATLib::Std::DateTime::Year
    ATLib::Std::DateTime::Month
    ATLib::Std::DateTime::Day
    ATLib::Std::DateTime::Hour
    ATLib::Std::DateTime::Minute
    ATLib::Std::DateTime::Utils
    ATLib::Std::DateTime::Second
    ATLib::Std::DateTime::MicroSecond
    ATLib::Std::DateTime
    ATLib::Std::Exception
    ATLib::Std::Exception::Argument
    ATLib::Std::Exception::InvalidOperation
    ATLib::Std::Exception::InvalidCast
    ATLib::Std::Exception::Format
    ATLib::Std::Maybe
    ATLib::Std::Collections::List
    ATLib::Std::Collections::Dictionary
);

done_testing;
__END__
