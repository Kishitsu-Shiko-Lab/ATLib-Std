requires 'perl', '5.016_001';

requires 'Mouse';
requires 'Digest::SHA';
requires 'Time::Local';
requires 'Time::HiRes';

requires 'ATLib::Utils';    # from github

on 'test' => sub {
    requires 'Test::More', '0.98';
};

