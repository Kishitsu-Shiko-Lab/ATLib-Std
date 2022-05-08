use strict;
use warnings;
use Test::More 0.98;

use_ok $_ for qw(
    ATLib::Std
    ATLib::Std::Any
    ATLib::Std::String
    ATLib::Std::Number
    ATLib::Std::Int
    ATLib::Std::Exception
    ATLib::Std::Exception::Argument
    ATLib::Std::Maybe
    ATLib::Std::Collections::List
    ATLib::Std::Collections::Dictionary
);

done_testing;
__END__