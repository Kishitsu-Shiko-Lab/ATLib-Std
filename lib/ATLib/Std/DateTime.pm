package ATLib::Std::DateTime;
use Mouse;
extends 'ATLib::Std::Any';

use Time::Local qw { timelocal_posix timegm_posix };
use Time::HiRes qw { gettimeofday };

use ATLib::Utils qw { is_int };
use ATLib::Std::String;
use ATLib::Std::Int;
use ATLib::Std::Radix;
use ATLib::Std::Collections::Dictionary;
use ATLib::Std::DateTime::Year;
use ATLib::Std::DateTime::Month;
use ATLib::Std::DateTime::Day;
use ATLib::Std::DateTime::Hour;
use ATLib::Std::DateTime::Minute;
use ATLib::Std::DateTime::Second;
use ATLib::Std::DateTime::MicroSecond;
use ATLib::Std::DateTime::Utils;
use ATLib::Std::Exception::Argument;
use ATLib::Std::Exception::Format;

# Overloads
use overload(
    q{""}    => \&as_string,
    fallback => 0,
);

my $month_short_names_of = ATLib::Std::Collections::Dictionary->of(q{Int}, q{Str});
{
    $month_short_names_of->add(1, q{Jan});
    $month_short_names_of->add(2, q{Feb});
    $month_short_names_of->add(3, q{Mar});
    $month_short_names_of->add(4, q{Apr});
    $month_short_names_of->add(5, q{May});
    $month_short_names_of->add(6, q{Jun});
    $month_short_names_of->add(7, q{Jul});
    $month_short_names_of->add(8, q{Aug});
    $month_short_names_of->add(9, q{Sep});
    $month_short_names_of->add(10, q{Oct});
    $month_short_names_of->add(11, q{Nov});
    $month_short_names_of->add(12, q{Dec});
}

my $month_names_of = ATLib::Std::Collections::Dictionary->of(q{Int}, q{Str});
{
    $month_names_of->add(1, q{January});
    $month_names_of->add(2, q{February});
    $month_names_of->add(3, q{March});
    $month_names_of->add(4, q{April});
    $month_names_of->add(5, q{May});
    $month_names_of->add(6, q{June});
    $month_names_of->add(7, q{July});
    $month_names_of->add(8, q{August});
    $month_names_of->add(9, q{September});
    $month_names_of->add(10, q{October});
    $month_names_of->add(11, q{November});
    $month_names_of->add(12, q{December});
}

my $week_short_names_of = ATLib::Std::Collections::Dictionary->of(q{Int}, q{Str});
{
    $week_short_names_of->add(0, q{Sun});
    $week_short_names_of->add(1, q{Mon});
    $week_short_names_of->add(2, q{Tue});
    $week_short_names_of->add(3, q{Wed});
    $week_short_names_of->add(4, q{Thu});
    $week_short_names_of->add(5, q{Fri});
    $week_short_names_of->add(6, q{Sat});
}

my $week_names_of = ATLib::Std::Collections::Dictionary->of(q{Int}, q{Str});
{
    $week_names_of->add(0, q{Sunday});
    $week_names_of->add(1, q{Monday});
    $week_names_of->add(2, q{Tuesday});
    $week_names_of->add(3, q{Wednesday});
    $week_names_of->add(4, q{Thursday});
    $week_names_of->add(5, q{Friday});
    $week_names_of->add(6, q{Saturday});
}

# Attributes
has 'is_utc'        => (is => 'ro', isa => 'ATLib::Std::Bool', required => 1, writer => '_set_is_utc');
has 'unix_time'     => (is => 'ro', isa => 'ATLib::Std::Int', required => 1, writer => '_set_unix_time');
has '_year'         => (is => 'ro', isa => 'ATLib::Std::DateTime::Year' => required => 1, writer => '_set__year');
has '_month'        => (is => 'ro', isa => 'ATLib::Std::DateTime::Month' => required => 1, writer => '_set__month');
has '_day'          => (is => 'ro', isa => 'ATLib::Std::DateTime::Day' => required => 1, writer => '_set__day');
has '_hour'         => (is => 'ro', isa => 'ATLib::Std::DateTime::Hour' => required => 1, writer => '_set__hour');
has '_minute'       => (is => 'ro', isa => 'ATLib::Std::DateTime::Minute' => required => 1, writer => '_set__minute');
has '_second'       => (is => 'ro', isa => 'ATLib::Std::DateTime::Second' => required => 1, writer => '_set__second');
has '_micro_second' => (is => 'ro', isa => 'ATLib::Std::DateTime::MicroSecond' => required => 1, writer => '_set__micro_second');
has '_day_of_week'  => (is => 'ro', isa => 'ATLib::Std::Radix', required => 1, writer => '_set__day_of_week');
has '_days_of_year' => (is => 'ro', isa => 'ATLib::Std::Radix', required => 1, writer => '_set__days_of_year');

sub year
{
    my $self = shift;
    return $self->_year->year;
}

sub month
{
    my $self = shift;
    return $self->_month->month;
}

sub day
{
    my $self = shift;
    return $self->_day->day;
}

sub hour
{
    my $self = shift;
    return $self->_hour->hour;
}

sub minute
{
    my $self = shift;
    return $self->_minute->minute;
}

sub second
{
    my $self = shift;
    return $self->_second->second;
}

sub in_leap_second
{
    my $self = shift;
    return $self->second >= 60 ? ATLib::Std::Bool->true : ATLib::Std::Bool->false;
}

sub milli_second
{
    my $self = shift;
    return $self->_micro_second->milli_second;
}

sub micro_second
{
    my $self = shift;
    return $self->_micro_second->micro_second;
}

sub day_of_week
{
    my $self = shift;
    return $self->_day_of_week;
}

sub days_of_year
{
    my $self = shift;
    return $self->_days_of_year + 1;
}

# Builder
sub BUILDARGS
{
    my ($class, $args_ref) = @_;

    $class->SUPER::BUILDARGS($args_ref);

    if (!exists $args_ref->{is_utc}) { $args_ref->{is_utc} = ATLib::Std::Bool->false; }
    if (!exists $args_ref->{unix_time}) { $args_ref->{unix_time} = ATLib::Std::Int->from(0); }
    if (!exists $args_ref->{_year})
    {
        my $year_ref = ATLib::Std::DateTime::Year->from(ATLib::Std::DateTime::Year->to_epoch(1900));
        $args_ref->{_year} = $year_ref;

        my $month_ref = ATLib::Std::DateTime::Month->from($year_ref, ATLib::Std::DateTime::Month->to_epoch(1));
        $args_ref->{_month} = $month_ref;

        my $day_ref = ATLib::Std::DateTime::Day->from($month_ref, ATLib::Std::DateTime::Day->to_epoch(1));
        $args_ref->{_day} = $day_ref;

        my $hour_ref = ATLib::Std::DateTime::Hour->from($day_ref, 0);
        $args_ref->{_hour} = $hour_ref;

        my $minute_ref = ATLib::Std::DateTime::Minute->from($hour_ref, 0);
        $args_ref->{_minute} = $minute_ref;

        my $second_ref = ATLib::Std::DateTime::Second->from($minute_ref, 0);
        $args_ref->{_second} = $second_ref;

        my $micro_second_ref = ATLib::Std::DateTime::MicroSecond->from($second_ref, 0);
        $args_ref->{_micro_second} = $micro_second_ref;

        my $day_of_week = ATLib::Std::Radix->from(7, 0);
        $args_ref->{_day_of_week} = $day_of_week;

        my $day_of_year = ATLib::Std::Radix->from(365, 0);
        if (ATLib::Std::DateTime::Year->is_leap_year($year_ref->year))
        {
            $day_of_year->_set__radix(366);
        }
        $args_ref->{_days_of_year} = $day_of_year;
    }
    return $args_ref;
}

# Class Methods
sub _from_unix_time
{
    my $class = shift;
    my $is_utc = shift;
    my $epoc_sec = shift;
    my $instance = undef;
    if (ATLib::Std::Bool->false->equals($is_utc))
    {
        my ($second, $minute, $hour, $day, $epoch_month, $epoch_year, $day_of_week, $days_of_year) = localtime($epoc_sec);
        my $year_ref = ATLib::Std::DateTime::Year->from($epoch_year);
        my $month_ref = ATLib::Std::DateTime::Month->from($year_ref, $epoch_month);
        my $day_ref = ATLib::Std::DateTime::Day->from($month_ref, ATLib::Std::DateTime::Day->to_epoch($day));
        my $hour_ref = ATLib::Std::DateTime::Hour->from($day_ref, $hour);
        my $minute_ref = ATLib::Std::DateTime::Minute->from($hour_ref, $minute);
        my $second_ref = ATLib::Std::DateTime::Second->from_utc($minute_ref, $second);
        my $micro_second_ref = ATLib::Std::DateTime::MicroSecond->from($second_ref, 0);
        $instance = $class->new({
            is_utc        => ATLib::Std::Bool->false,
            unix_time     => ATLib::Std::Int->from($epoc_sec),
            _year         => $year_ref,
            _month        => $month_ref,
            _day          => $day_ref,
            _hour         => $hour_ref,
            _minute       => $minute_ref,
            _second       => $second_ref,
            _micro_second => $micro_second_ref,
            _day_of_week  => ATLib::Std::Radix->from(7, $day_of_week),
            _days_of_year => ATLib::Std::Radix->from($year_ref->is_leap_year($year_ref->year) ? 366 : 365, $days_of_year),
        });
    }
    else
    {
        my ($second, $minute, $hour, $day, $epoch_month, $epoch_year, $day_of_week, $days_of_year) = gmtime($epoc_sec);
        my $year_ref = ATLib::Std::DateTime::Year->from($epoch_year);
        my $month_ref = ATLib::Std::DateTime::Month->from($year_ref, $epoch_month);
        my $day_ref = ATLib::Std::DateTime::Day->from($month_ref, ATLib::Std::DateTime::Day->to_epoch($day));
        my $hour_ref = ATLib::Std::DateTime::Hour->from($day_ref, $hour);
        my $minute_ref = ATLib::Std::DateTime::Minute->from($hour_ref, $minute);
        my $second_ref = ATLib::Std::DateTime::Second->from($minute_ref, $second);
        my $micro_second_ref = ATLib::Std::DateTime::MicroSecond->from($second_ref, 0);
        $instance = $class->new({
            is_utc        => ATLib::Std::Bool->true,
            unix_time     => ATLib::Std::Int->from($epoc_sec),
            _year         => $year_ref,
            _month        => $month_ref,
            _day          => $day_ref,
            _hour         => $hour_ref,
            _minute       => $minute_ref,
            _second       => $second_ref,
            _micro_second => $micro_second_ref,
            _day_of_week  => ATLib::Std::Radix->from(7, $day_of_week),
            _days_of_year => ATLib::Std::Radix->from($year_ref->is_leap_year($year_ref->year) ? 366 : 365, $days_of_year),
        });
    }
    return $instance;
}

sub from
{
    my $class = shift;
    my ($year, $month, $day, $hour, $minute, $second) = @_;

    if ($second > 59)
    {
        $second = 59;
    }
    my $epoc_sec = timelocal_posix(
        $second,
        $minute,
        $hour,
        $day,
        ATLib::Std::DateTime::Month->to_epoch($month),
        ATLib::Std::DateTime::Year->to_epoch($year)
    );
    return $class->_from_unix_time(ATLib::Std::Bool->false, $epoc_sec);
}

sub from_utc
{
    my $class = shift;
    my ($year, $month, $day, $hour, $minute, $second) = @_;

    if ($second > 59)
    {
         $second = 59;
    }
    my $epoc_sec = timegm_posix(
        $second,
        $minute,
        $hour,
        $day,
        ATLib::Std::DateTime::Month->to_epoch($month),
        ATLib::Std::DateTime::Year->to_epoch($year)
    );
    return $class->_from_unix_time(ATLib::Std::Bool->true, $epoc_sec);
}

sub now
{
    my $class = shift;

    my ($epoch_sec, $micro_sec) = gettimeofday();
    my $instance = $class->_from_unix_time(ATLib::Std::Bool->false, $epoch_sec);
    $instance->_set_micro_second($micro_sec);
    return $instance;
}

sub now_utc
{
    my $class = shift;

    my ($epoch_sec, $micro_sec) = gettimeofday();
    my $instance = $class->_from_unix_time(ATLib::Std::Bool->true, $epoch_sec);
    $instance->_set_micro_second($micro_sec);
    return $instance;
}

sub parse_exact
{
    my $class = shift;
    my $target = shift;
    my $format = shift;

    if (!defined $target)
    {
        ATLib::Std::Exception::Argument->new({
            message    => q{Argument is not specified.},
            param_name => q{$target},
        })->throw();
    }

    if (!defined $format)
    {
        ATLib::Std::Exception::Argument->new({
            message    => q{Argument is not specified.},
            param_name => q{$format},
        })->throw();
    }

    $target = ATLib::Std::String->from($target);
    $format = ATLib::Std::String->from($format);

    if ($target->get_length() != $format->get_length())
    {
        ATLib::Std::Exception::Format->new({
            message => q{Specified $format is invalid length.},
        })->throw();
    }

    my $year = undef;
    my $month = undef;
    my $day = undef;
    my $hour = undef;
    my $minute = undef;
    my $second = undef;
    my $milli_second = undef;
    my $micro_second = undef;

    my $current_pos = 0;
    pos $format = 0;
    while (pos $format < $format->get_length())
    {
        my $token = undef;
        if ($format =~ m{ \G (yyyy)}gcxms)
        {
            if (defined $year)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{Specified $format `yyyy` is duplicated.},
                })->throw();
            }

            $token = $target->substring($current_pos, 4);
            if (!is_int($token))
            {
                ATLib::Std::Exception::Format->new({
                    message => q{The $target is not include year(yyyy) string.},
                })->throw();
            }
            $year = ATLib::Std::String->from('0000' . $token)->substring(-4);
            $current_pos += 4;
        }
        elsif ($format =~ m{ \G (MM)}gcxms)
        {
            if (defined $month)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{Specified $format `MM` is duplicated.},
                })->throw();
            }

            $token = $target->substring($current_pos, 2);
            if (!is_int($token)
                || !($token->_value >= 1 && $token->_value <= 12))
            {
                ATLib::Std::Exception::Format->new({
                    message => q{The $target is not include month(MM) string.},
                })->throw();
            }
            $month = ATLib::Std::String->from('00' . $token)->substring(-2);
            $current_pos += 2;
        }
        elsif ($format =~ m{ \G (dd)}gcxms)
        {
            if (defined $day)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{Specified $format `dd` is duplicated.},
                })->throw();
            }

            $token = $target->substring($current_pos, 2);
            if (!is_int($token)
                || !($token->_value >= 1 && $token->_value <= 31))
            {
                ATLib::Std::Exception::Format->new({
                    message => q{The $target is not include day(dd) string.},
                })->throw();
            }
            $day = ATLib::Std::String->from('00' . $token)->substring(-2);
            $current_pos += 2;
        }
        elsif ($format =~ m{ \G (HH)}gcxms)
        {
            if (defined $hour)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{Specified $format `HH` is duplicated.},
                })->throw();
            }

            $token = $target->substring($current_pos, 2);
            if (!is_int($token)
                || !($token->_value >= 0 && $token->_value <= 59))
            {
                ATLib::Std::Exception::Format->new({
                    message => q{The $target is not include hour(HH) string.},
                })->throw();
            }
            $hour = ATLib::Std::String->from('00' . $token)->substring(-2);
            $current_pos += 2;
        }
        elsif ($format =~ m{ \G (mm)}gcxms)
        {
            if (defined $minute)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{Specified $format `mm` is duplicated.},
                })->throw();
            }

            $token = $target->substring($current_pos, 2);
            if (!is_int($token)
                || !($token->_value >= 0 && $token->_value <= 59))
            {
                ATLib::Std::Exception::Format->new({
                    message => q{The $target is not include minute(mm) string.},
                })->throw();
            }
            $minute = ATLib::Std::String->from('00' . $token)->substring(-2);
            $current_pos += 2;
        }
        elsif ($format =~ m{ \G (ss)}gcxms)
        {
            if (defined $second)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{Specified $format `ss` is duplicated.},
                })->throw();
            }

            $token = $target->substring($current_pos, 2);
            if (!is_int($token)
                || !($token->_value >= 0 && $token->_value <= 60))
            {
                ATLib::Std::Exception::Format->new({
                    message => q{The $target is not include second(ss) string.},
                })->throw();
            }
            $second = ATLib::Std::String->from('00' . $token)->substring(-2);
            $current_pos += 2;
        }
        elsif ($format =~ m{ \G (ffffff|FFFFFF)}gcxms)
        {
            if (defined $milli_second)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{The $format `fff|FFF` is already specified.},
                })->throw();
            }
            if (defined $micro_second)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{Specified $format `ffffff|FFFFFF` is duplicated.},
                })->throw();
            }

            $token = $target->substring($current_pos, 6);
            if (!is_int($token)
                || !($token->_value >= 0 && $token->_value <= 999_999))
            {
                ATLib::Std::Exception::Format->new({
                    message => q{The $target is not include micro second(ffffff|FFFFFF) string.},
                })->throw();
            }
            $micro_second = ATLib::Std::String->from('000000' . $token)->substring(-6);
            $current_pos += 6;
        }
        elsif ($format =~ m{ \G (fff|FFF)}gcxms)
        {
            if (defined $micro_second)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{The $format `ffffff|FFFFFF` is already specified.},
                })->throw();
            }
            if (defined $milli_second)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{Specified $format `fff|FFF` is duplicated.},
                })->throw();
            }

            $token = $target->substring($current_pos, 3);
            if (!is_int($token)
                || !($token->_value >= 0 && $token->_value <= 999))
            {
                ATLib::Std::Exception::Format->new({
                    message => q{The $target is not include milli second(fff|FFF) string.},
                })->throw();
            }
            $milli_second = ATLib::Std::String->from('000' . $token)->substring(-3);
            $current_pos += 3;
        }
        elsif ($format =~ m{ \G (/|-)}gcxms)
        {
            # Separator of date
            if (defined $year && defined $month && defined $day)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{Specified date separator, but it's already completed.},
                })->throw();
            }
            $current_pos += 1;
        }
        elsif ($format =~ m{ \G (:)}gcxms)
        {
            # Separator of time
            if (defined $hour && defined $minute && defined $second)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{Specified time separator, but it's already completed.},
                })->throw();
            }
            $current_pos += 1;
        }
        elsif ($format =~ m{ \G (\.)}gcxms)
        {
            # Separator of millisecond or microsecond
            if (defined $milli_second || defined $micro_second)
            {
                ATLib::Std::Exception::Format->new({
                    message => q{Specified millisecond or microsecond separator, but it's already completed.},
                })->throw();
            }
            $current_pos += 1;
        }
        elsif ($format =~ m{ \G (.)}gcxms)
        {
            $token = $target->substring($current_pos, 1);
            if ($token ne ' ')
            {
                ATLib::Std::Exception::Format->new({
                    message => qq{Invalid format keyword `$token` was specified.}
                })->throw();
            }
            $current_pos += 1;
        }
        else
        {
            # Unreachable
            $token = $target->substring($current_pos);
            ATLib::Std::Exception::Format->new({
                message => qq{Invalid format keyword `$token` was specified.}
            })->throw();
            $current_pos += $token->get_length();
        }
    }

    my $dtm = undef;
    if (defined $year && defined $month && defined $day
        && defined $hour && defined $minute && defined $second)
    {
        $dtm = $class->from($year, $month, $day, $hour, $minute, $second);
        if (defined $milli_second)
        {
            $dtm->_set__micro_second(ATLib::Std::DateTime::MicroSecond->from(
                $dtm->_second,
                $milli_second->_value * 1_000,
            ));
        }
        if (defined $micro_second)
        {
            $dtm->_set__micro_second(ATLib::Std::DateTime::MicroSecond->from(
                $dtm->_second,
                $micro_second->_value,
            ));
        }
    }
    elsif (defined $year && defined $month && defined $day
        && !defined $hour && !defined $minute && !defined $second)
    {
        $dtm = $class->from($year, $month, $day, 0, 0, 0);
    }
    elsif (!defined $year && !defined $month && !defined $day
        && defined $hour && defined $minute && defined $second)
    {
        $dtm = $class->from(1970, 1, 1, $hour, $minute, $second);
        if (defined $milli_second)
        {
            $dtm->_set__micro_second(ATLib::Std::DateTime::MicroSecond->from(
                $dtm->_second,
                $milli_second->_value * 1_000,
            ));
        }
        if (defined $micro_second)
        {
            $dtm->_set__micro_second(ATLib::Std::DateTime::MicroSecond->from(
                $dtm->_second,
                $micro_second->_value,
            ));
        }
    }
    else
    {
        ATLib::Std::Exception::Format->new({
            message => q{Cannot generate type of datetime from specified $target and $format.},
        })->throw();
    }

    return $dtm;
}

sub parse
{
    my $class = shift;
    my $target = shift;

    return $class->parse_exact($target, ATLib::Std::String->from("yyyy/MM/dd HH:mm:ss"));
}

sub is_leap_year
{
    shift;
    my $year = shift;
    return ATLib::Std::DateTime::Year->is_leap_year($year);
}

# Instance Methods
sub _set_micro_second
{
    my $self = shift;
    my $micro_second = shift;

    $self->_micro_second->_set_value($micro_second);
    return;
}

sub _adjust_leap_last_day
{
    my $self = shift;

    if ($self->day > $self->_month->last_day)
    {
        $self->_day->_set_value(ATLib::Std::Int->value(ATLib::Std::DateTime::Day->to_epoch($self->_month->last_day)));
        $self->_day->_set_radix(ATLib::Std::Int->value($self->_month->last_day));
    }
    return;
}

sub _sync_unix_time
{
    my $self = shift;
    my $second = $self->second;

    if ($self->in_leap_second)
    {
        $second = 59;
    }

    my $epoc_sec = $self->unix_time;
    if ($self->is_utc)
    {
        $epoc_sec = timegm_posix(
            ATLib::Std::Int->value($second),
            $self->minute->_value,
            $self->hour->_value,
            $self->day->_value,
            ATLib::Std::DateTime::Month->to_epoch($self->month)->_value,
            ATLib::Std::DateTime::Year->to_epoch($self->year)->_value
        );
    }
    else
    {
        $epoc_sec = timelocal_posix(
            ATLib::Std::Int->value($second),
            $self->minute->_value,
            $self->hour->_value,
            $self->day->_value,
            ATLib::Std::DateTime::Month->to_epoch($self->month)->_value,
            ATLib::Std::DateTime::Year->to_epoch($self->year)->_value
        );
    }
    $self->_set_unix_time(ATLib::Std::Int->from($epoc_sec));
    return;
}

sub copy
{
    my $self = shift;
    my $copy = ATLib::Std::DateTime->new();

    if ($self->is_utc)
    {
        $copy->_set_is_utc(ATLib::Std::Bool->true);
        $copy->_set_unix_time(ATLib::Std::Int->from(ATLib::Std::Int->value($self->unix_time)));
        $copy->_set__year(ATLib::Std::DateTime::Year->from(ATLib::Std::DateTime::Year->to_epoch($self->year)));
        $copy->_set__month(ATLib::Std::DateTime::Month->from($copy->_year, ATLib::Std::DateTime::Month->to_epoch($self->month)));
        $copy->_set__day(ATLib::Std::DateTime::Day->from($copy->_month, ATLib::Std::DateTime::Day->to_epoch($self->day)));
        $copy->_set__hour(ATLib::Std::DateTime::Hour->from($copy->_day, $self->hour));
        $copy->_set__minute(ATLib::Std::DateTime::Minute->from($copy->_hour, $self->minute));
        $copy->_set__second(ATLib::Std::DateTime::Second->from_utc($copy->_minute, $self->second));
        $copy->_set__micro_second(ATLib::Std::DateTime::MicroSecond->from($copy->_second, $self->micro_second));
        $copy->_set__day_of_week(ATLib::Std::Radix->from($self->_day_of_week->radix, $self->_day_of_week->value));
        $copy->_set__days_of_year(ATLib::Std::Radix->from($self->_days_of_year->radix, $self->_days_of_year->value));
    }
    else
    {
        $copy->_set_is_utc(ATLib::Std::Bool->false);
        $copy->_set_unix_time(ATLib::Std::Int->from(ATLib::Std::Int->value($self->unix_time)));
        $copy->_set__year(ATLib::Std::DateTime::Year->from(ATLib::Std::DateTime::Year->to_epoch($self->year)));
        $copy->_set__month(ATLib::Std::DateTime::Month->from($copy->_year, ATLib::Std::DateTime::Month->to_epoch($self->month)));
        $copy->_set__day(ATLib::Std::DateTime::Day->from($copy->_month, ATLib::Std::DateTime::Day->to_epoch($self->day)));
        $copy->_set__hour(ATLib::Std::DateTime::Hour->from($copy->_day, $self->hour));
        $copy->_set__minute(ATLib::Std::DateTime::Minute->from($copy->_hour, $self->minute));
        $copy->_set__second(ATLib::Std::DateTime::Second->from($copy->_minute, $self->second));
        $copy->_set__micro_second(ATLib::Std::DateTime::MicroSecond->from($copy->_second, $self->micro_second));
        $copy->_set__day_of_week(ATLib::Std::Radix->from($self->_day_of_week->radix, $self->_day_of_week->value));
        $copy->_set__days_of_year(ATLib::Std::Radix->from($self->_days_of_year->radix, $self->_days_of_year->value));
    }

    return $copy;
}

sub _mutable_add_years
{
    my $self = shift;
    my $years = shift;

    if ($self->in_leap_second)
    {
        my $leap_seconds = ATLib::Std::DateTime::Utils->get_leap_seconds_utc($self->_second);
        $self->_year->_value(ATLib::Std::Int->value($self->_year + $years));
        $self->_adjust_leap_last_day();
        if ($years > 0)
        {
            $self->_mutable_add_seconds($leap_seconds);
        }
        elsif ($years < 0)
        {
            $self->_mutable_add_seconds(-$leap_seconds);
        }
    }
    else
    {
        $self->_year->_value(ATLib::Std::Int->value($self->_year + $years));
        $self->_adjust_leap_last_day();
    }

    $self->_sync_unix_time();

    return $self;
}

sub add_years
{
    my $self = shift;
    my $years = shift;
    return $self->copy()->_mutable_add_years($years);
}

sub _mutable_add_months
{
    my $self = shift;
    my $months = shift;

    if ($self->in_leap_second)
    {
        my $leap_seconds = ATLib::Std::DateTime::Utils->get_leap_seconds_utc($self->_second);
        $self->_month->add($months);
        $self->_adjust_leap_last_day();
        if ($months > 0)
        {
            $self->_mutable_add_seconds($leap_seconds);
        }
        elsif ($months < 0)
        {
            $self->_mutable_add_seconds(-$leap_seconds);
        }
    }
    else
    {
        $self->_month->add($months);
        $self->_adjust_leap_last_day();
    }

    $self->_sync_unix_time();

    return $self;
}

sub add_months
{
    my $self = shift;
    my $months = shift;
    return $self->copy()->_mutable_add_months($months);
}

sub _mutable_add_days
{
    my $self = shift;
    my $days = shift;

    if ($self->in_leap_second)
    {
        my $leap_seconds = ATLib::Std::DateTime::Utils->get_leap_seconds_utc($self->_second);
        $self->_day->add($days);
        if ($days > 0)
        {
            $self->_mutable_add_seconds($leap_seconds);
        }
        elsif ($days < 0)
        {
            $self->_mutable_add_seconds(-$leap_seconds);
        }
    }
    else
    {
        $self->_day->add($days);
    }
    $self->_sync_unix_time();
    return $self;
}

sub add_days
{
    my $self = shift;
    my $days = shift;
    return $self->copy()->_mutable_add_days($days);
}

sub _mutable_add_hours
{
    my $self = shift;
    my $hours = shift;

    if ($self->in_leap_second)
    {
        my $leap_seconds = ATLib::Std::DateTime::Utils->get_leap_seconds_utc($self->_second);
        $self->_hour->add($hours);
        if ($hours > 0)
        {
            $self->_mutable_add_seconds($leap_seconds);
        }
        elsif ($hours < 0)
        {
            $self->_mutable_add_seconds(-$leap_seconds);
        }
    }
    else
    {
        $self->_hour->add($hours);
    }
    $self->_sync_unix_time();
    return $self;
}

sub add_hours
{
    my $self = shift;
    my $hours = shift;
    return $self->copy()->_mutable_add_hours($hours);
}

sub _mutable_add_minutes
{
    my $self = shift;
    my $minutes = shift;

    if ($self->in_leap_second)
    {
        my $leap_seconds = ATLib::Std::DateTime::Utils->get_leap_seconds_utc($self->_second);
        $self->_minute->add($minutes);
        if ($minutes > 0)
        {
            $self->_mutable_add_seconds($leap_seconds);
        }
        elsif ($minutes < 0)
        {
            $self->_mutable_add_seconds(-$leap_seconds);
        }
    }
    else
    {
        $self->_minute->add($minutes);
    }
    $self->_sync_unix_time();
    return $self;
}

sub add_minutes
{
    my $self = shift;
    my $minutes = shift;
    return $self->copy()->_mutable_add_minutes($minutes);
}

sub _mutable_add_seconds
{
    my $self = shift;
    my $seconds = shift;
    if ($self->is_utc)
    {
        $self->_second->add_utc($seconds);
    }
    else
    {
        $self->_second->add($seconds);
    }
    $self->_sync_unix_time();
    return $self;
}

sub add_seconds
{
    my $self = shift;
    my $seconds = shift;
    return $self->copy()->_mutable_add_seconds($seconds);
}

sub _mutable_add_milli_seconds
{
    my $self = shift;
    my $milli_seconds = shift;
    $self->_micro_second->add($milli_seconds * 1_000);
    return $self;
}

sub add_milli_seconds
{
    my $self = shift;
    my $milli_seconds = shift;
    return $self->copy()->_mutable_add_milli_seconds($milli_seconds);
}

sub _mutable_add_micro_seconds
{
    my $self = shift;
    my $micro_seconds = shift;
    $self->_micro_second->add($micro_seconds);
    return $self;
}

sub add_micro_seconds
{
    my $self = shift;
    my $micro_seconds = shift;
    return $self->copy()->_mutable_add_micro_seconds($micro_seconds);
}

sub _can_equals
{
    my $self = shift;
    my $target = shift;

    return 1 if (!defined $target);
    return 1 if (blessed($target) && $target->isa($self->get_full_name()));
    return 0;
}

sub compare
{
    my $self = shift;
    my $target = shift;

    if ($self->_can_equals($target))
    {
        my $this = $self->as_string('%Y%m%d%H%M%S') . sprintf(q{%06d}, $self->micro_second->_value);
        my $that = $target->as_string('%Y%m%d%H%M%S') . sprintf(q{%06d}, $target->micro_second->_value);
        return $this cmp $that;
    }

    return 1;
}

sub equals
{
    my $self = shift;
    my $target = shift;
    return $self->compare($target) == 0 ? ATLib::Std::Bool->true : ATLib::Std::Bool->false;
}

sub as_string
{
    my $self = shift;
    my $format = shift if (scalar(@_) > 0);

    my $offset_string = q{};
    if ($self->is_utc)
    {
        $offset_string = q{Z};
    }
    else
    {
        my $now_utc = ATLib::Std::DateTime->now_utc();
        my $now = ATLib::Std::DateTime->now();
        if ($now->day > $now_utc->day)
        {
            $offset_string = sprintf(q{+%02d%02d}, 24 + $now->hour - $now_utc->hour, $now->minute - $now_utc->minute);
        }
        elsif ($now->day < $now_utc->day)
        {
            $offset_string = sprintf(q{-%02d%02d}, 24 + $now_utc->hour - $now->hour, $now_utc->minute - $now->minute);
        }
        elsif ($now->hour > $now_utc->hour)
        {
            $offset_string = sprintf(q{+%02d%02d}, $now->hour - $now_utc->hour, $now->minute - $now_utc->minute);
        }
        else
        {
            $offset_string = sprintf(q{-%02d%02d}, $now_utc->hour - $now->hour, $now_utc->minute - $now->minute);
        }
    }

    my $date_time_string = q{};
    if (!defined $format)
    {
        # ISO 8601
        $date_time_string =
            sprintf(
                q{%04d%02d%02dT%02d%02d%02d%s},
                $self->year, $self->month, $self->day,
                $self->hour, $self->minute, $self->second, $offset_string
            );
    }
    else
    {
        $date_time_string = $format;
        my $replacement = $self->year;
        $format =~ s{%Y}{$replacement}xms;
        $replacement = substr(sprintf(q{%04d}, $self->year), 0, 2);
        $format =~ s{%C}{$replacement}xms;
        $replacement = substr(sprintf(q{%04d}, $self->year), 2, 2);
        $format =~ s{%y}{$replacement}xms;
        $replacement = sprintf(q{%02d}, $self->month);
        $format =~ s{%m}{$replacement}xms;
        $replacement = $month_short_names_of->item($self->month);
        $format =~ s{(?:%b|%h)+}{$replacement}xms;
        $replacement = $month_names_of->item($self->month);
        $format =~ s{%B}{$replacement}xms;
        $replacement = sprintf(q{%02d}, $self->day);
        $format =~ s{%d}{$replacement}xms;
        $replacement = sprintf(q{%2d}, $self->day);
        $format =~ s{%e}{$replacement}xms;
        $replacement = $week_short_names_of->item($self->day_of_week);
        $format =~ s{%a}{$replacement}xms;
        $replacement = $week_names_of->item($self->day_of_week);
        $format =~ s{%A}{$replacement}xms;
        $replacement = sprintf(q{%d}, $self->day_of_week + 1);
        $format =~ s{%u}{$replacement}xms;
        $replacement = sprintf(q{%d}, $self->day_of_week);
        $format =~ s{%w}{$replacement}xms;

        $replacement = sprintf(q{%02d}, $self->hour);
        $format =~ s{%H}{$replacement}xms;
        $replacement = sprintf(q{%2d}, $self->hour);
        $format =~ s{%k}{$replacement}xms;
        $replacement = sprintf(q{%02d}, $self->hour > 11 ? $self->hour - 12 : $self->hour);
        $format =~ s{%I}{$replacement}xms;
        $replacement = sprintf(q{%2d}, $self->hour > 11 ? $self->hour - 12 : $self->hour);
        $format =~ s{%l}{$replacement}xms;
        $replacement = $self->hour < 12 ? q{AM} : q{PM};
        $format =~ s{%p}{$replacement}xms;
        $replacement = lc($replacement);
        $format =~ s{%P}{$replacement}xms;
        $replacement = sprintf(q{%02d}, $self->minute);
        $format =~ s{%M}{$replacement}xms;
        $replacement = sprintf(q{%02d}, $self->second);
        $format =~ s{%S}{$replacement}xms;
        $format =~ s{%z}{$offset_string}xms;

        $replacement = sprintf(q{%04d/%02d/%02d %02d:%02d:%02d}, $self->year, $self->month, $self->day, $self->hour, $self->minute, $self->second);
        $format =~ s{%c}{$replacement}xms;
        $replacement = sprintf(q{%04d/%02d/%02d}, $self->year, $self->month, $self->day);
        $format =~ s{%x}{$replacement}xms;
        $replacement = sprintf(q{%02d:%02d:%02d}, $self->hour, $self->minute, $self->second);
        $format =~ s{%X}{$replacement}xms;
        if ($format =~ m{%D}xms)
        {
            $replacement = $self->as_string(q{%m/%d/%y});
            $format =~ s{%D}{$replacement}xms;
        }
        if ($format =~ m{%F}xms)
        {
            $replacement = $self->as_string(q{%Y-%m-%d});
            $format =~ s{%F}{$replacement}xms;
        }
        if ($format =~ m{%r}xms)
        {
            $replacement = $self->as_string(q{%I:%M:%S %p});
            $format =~ s{%r}{$replacement}xms;
        }
        if ($format =~ m{%T}xms)
        {
            $replacement = $self->as_string(q{%H:%M:%S});
            $format =~ s{%T}{$replacement}xms;
        }
        if ($format =~ m{%R}xms)
        {
            $replacement = $self->as_string(q{%H:%M});
            $format =~ s{%R}{$replacement}xms;
        }

        $replacement = sprintf(q{%d}, $self->unix_time);
        $format =~ s{%s}{$replacement}xms;
        $replacement = sprintf(q{%03d}, $self->days_of_year);
        $format =~ s{%j}{$replacement}xms;
        $replacement = qq{\n};
        $format =~ s{%n}{$replacement}xms;
        $replacement = qq{\t};
        $format =~ s{%t}{$replacement}xms;

        $date_time_string = $format;
    }
    return ATLib::Std::String->from($date_time_string);
}

__PACKAGE__->meta->make_immutable();
no Mouse;
1;

=encoding utf8

=head1 名前

ATLib::Std::DateTime - 日付、時間の表現、計算を行うための標準型

=head1 バージョン

この文書は ATLib::Std version v0.4.0 について説明しています。

=head1 概要

    use ATLib::Std;

    my $now = ATLib::Std::DateTime->now();
    my $passed_years = $now->add_years(1);
    my $passed_hours = $now->add_hours(1);
    ...

=head1 基底クラス

L<< ATLib::Std::Any >>

=head1 説明

ATLib::Std::DateTime は、ATLib::Stdで提供される L<< Mouse >> で実装された日時を表す型です。
基本的な日付計算、および表示形式への変換を行うことができます。
協定世界時(UTC)および、端末の地域時間をサポートしています。また閏秒を考慮します。
内部表現はエポック秒(UNIX時間)(1970/01/01 00:00:00 UTCからの秒数)です。

=head1 コンストラクタ

=head2 C<< $instance = ATLib::Std::DateTime->from($year, $month, $day, $hour, $minute, $second);  >>

西暦$year年$month月$day日 $hour:$minute:$secondを値とする日時型を生成します。
このインスタンスは端末の地域時間として初期化されます。
閏秒で60秒の場合は、59秒に丸められます。

=head2 C<< $instance = ATLib::Std::DateTime->from_utc($year, $month, $day, $hour, $minute, $second);  >>

西暦$year年$month月$day日 $hour:$minute:$secondを値とする日時型を生成します。
このインスタンスは協定世界時(UTC)として初期化されます。
閏秒で60秒の場合は、59秒に丸められます。

=head2 C<< $instance = ATLib::Std::DateTime->now(); >>

現時点を値とする日時型を生成します。このインスタンスは端末の地域時間として初期化されます。

=head2 C<< $instance = ATLib::Std::DateTime->now_utc(); >>

現時点を値とする日時型を生成します。このインスタンスは協定世界時(UTC)として初期化されます。

=head1 オーバーロード

=head2 文字列化 C<< "" >>

スカラコンテキストでは、クラスに格納された日時の値をISO 8601形式の文字列型 L<< ATLib::Std::String >> 化して返します。
このコンテキストは比較時に文字列形式の数値変換など Perlから使用されます。

=head1 プロパティ

=head2 C<< $result = $instance->is_utc; >> -E<gt> L<< ATLib::Std::Bool >>

インスタンスがあらわす日時が協定世界時(UTC)かどうかを取得します。

=head2 C<< $epoch_second = $instance->unix_time; >> -E<gt> L<< ATLib::Std::Int >>

インスタンスがあらわす日時のエポック秒(UNIX時間)(1970/01/01 00:00:00 UTCからの秒数)を取得します。

=head2 C<< $year = $instance->year; >> -E<gt> L<< ATLib::Std::Int >>

インスタンスがあらわす日時の西暦年を取得します。

=head2 C<< $month = $instance->month; >> -E<gt> L<< ATLib::Std::Int >>

インスタンスがあらわす日時の月(1〜12)を取得します。

=head2 C<< $day = $instance->day; >> -E<gt> L<< ATLib::Std::Int >>

インスタンスがあらわす日時の日(1〜31)を取得します。

=head2 C<< $hour = $instance->hour; >> -E<gt> L<< ATLib::Std::Int >>

インスタンスがあらわす日時の時(0〜23)を取得します。

=head2 C<< $minute = $instance->minute; >> -E<gt> L<< ATLib::Std::Int >>

インスタンスがあらわす日時の分(0〜59)を取得します。

=head2 C<< $second = $instance->second; >> -E<gt> L<< ATLib::Std::Int >>

インスタンスがあらわす日時の秒(0〜60)を取得します。
60は閏秒です。

=head2 C<< $result = $instance->in_leap_second; >> -E<gt> L<< ATLib::Std::Bool >>

インスタンスが現在閏秒かどうかを取得します。

=head2 C<< $milli_second = $instance->milli_second; >> -E<gt> L<< ATLib::Std::Int >>

インスタンスがあらわす日時のミリ秒(0〜999)を取得します。

=head2 C<< $micro_second = $instance->micro_second; >> -E<gt> L<< ATLib::Std::Int >>

インスタンスがあらわす日時のマイクロ秒(0〜999999)を取得します。

=head1 クラスメソッド

=head2 C<< $result = $class->is_leap_year($year); >> -E<gt> L<< ATLib::Std::Bool >>

パラメータで指定した西暦$yearが閏年かどうかを判定します。

=head2 C<< $instance = $class->parse_exact($target, $format); >> -E<gt> L<< ATLib::Std::DateTime >>

パラメータ $target で指定した日付／日時文字列を指定の書式 $format に従って解析して日付型を生成します。
以下に書式 $format として指定できる文字列を示します。

=over 4

=item *

yyyy 西暦 4桁

=item *

MM 月の前ゼロ詰め 2桁 (01〜12)

=item *

dd 日の前ゼロ詰め 2桁 (01〜31)

=item *

hh 時(24時間表記)の前ゼロ詰め 2桁 (00〜23)

=item *

mm 分の前ゼロ詰め 2桁 (00〜59)

=item *

ss 秒の前ゼロ詰め 2桁 (00〜60)

=item *

fff または FFF ミリ秒の前ゼロ詰め 3桁 (000〜999)

=item *

ffffff または FFFFFF マイクロ秒の前ゼロ詰め 6桁 (000〜999999)

=item *

/ または - 日付区切り文字

=item *

: 時分秒区切り文字

=item *

. 秒未満区切り文字

=back

=head1 インスタンスメソッド

=head2 C<< $copy = $instance->copy(); >>

インスタンスのすべてのプロパティをコピーした新しいインスタンスを取得します。

=head2 C<< $instance_new = $instance->add_years($years); >>

インスタンスの西暦年をパラメータで指定した$years年だけ加算したインスタンスを生成、返却します。
$yearsに負の数を指定した場合は、西暦年が減算されます。

=head2 C<< $instance_new = $instance->add_months($months); >>

インスタンスの月をパラメータで指定した$monthsヶ月だけ加算したインスタンスを生成、返却します。
$monthsに負の数を指定した場合は、月が減算されます。

=head2 C<< $instance_new = $instance->add_days($days); >>

インスタンスの日をパラメータで指定した$days日だけ加算したインスタンスを生成、返却します。
$daysに負の数を指定した場合は、日が減算されます。

=head2 C<< $instance_new = $instance->add_hours($hours);  >>

インスタンスの時をパラメータで指定した$hours時間だけ加算したインスタンスを生成、返却します。
$hoursに負の数を指定した場合は、時が減算されます。

=head2 C<< $instance_new = $instance->add_minutes($minutes);  >>

インスタンスの分をパラメータで指定した$minutes分だけ加算したインスタンスを生成、返却します。
$minutesに負の数を指定した場合は、分が減算されます。

=head2 C<< $instance_new = $instance->add_seconds($seconds);  >>

インスタンスの秒をパラメータで指定した$seconds秒だけ加算したインスタンスを生成、返却します。
$secondsに負の数を指定した場合は、秒が減算されます。

=head2 C<< $instance_new = $instance->add_milli_seconds($milli_seconds);  >>

インスタンスのミリ秒(1/1,000秒)をパラメータで指定した$milli_secondsミリ秒だけ加算したインスタンスを生成、返却します。
$milli_secondsに負の数を指定した場合は、ミリ秒が減算されます。

=head2 C<< $instance_new = $instance->add_micro_seconds($micro_seconds);  >>

インスタンスのマイクロ秒(1/1,000,000秒)をパラメータで指定した$micro_secondsマイクロ秒だけ加算したインスタンスを生成、返却します。
$micro_secondsに負の数を指定した場合は、マイクロ秒が減算されます。

=head2 C<< $result = $instance->compare($target);  >>

$instanceと$targetを文字列比較します。
等しい場合は 0、$instanceが大きい場合は 1、小さい場合は -1を返します。

=head2 C<< $result = $instance->equals($target); >> -E<gt> L<< ATLib::Std::Bool >>

$targetが$instanceと等価であるかを判定します。
判定には、C<< $instance->compare($target) >> が使用されます。
必要に応じて、派生クラスでオーバーライドします。

=head2 C<< $date_time_string = $instance->as_string($format); -E<gt> L<< ATLib::Std::String  >> >>

インスタンスを指定した書式$formatに従って文字列化して返します。
パラメータ$formatを省略した場合は、ISO 8601形式で書式化します。
$formatに指定できるのはPOSIXのstrftimeに従った以下の書式です。

=over 4

=item *

%Y 西暦4桁

=item *

%C 西暦4桁のうちの上2桁

=item *

%y 西暦4桁のうちの下2桁

=item *

%m 月の前ゼロ詰め2桁 (01〜12)

=item *

%b 短い形式の英語の月名 (Jan .. Dec)

=item *

%h %bと同じ。短い形式の英語の月名 (Jan .. Dec)

=item *

%B 長い形式の英語の月名 (January .. December)

=item *

%d 日の前ゼロ詰め2桁 (01〜31)

=item *

%e 日の空白詰め2桁 (_1〜31)

=item *

%a 短い形式の週日(曜日)の英語名 (Sun .. Sat)

=item *

%A 長い形式の週日(曜日)の英語名 (Sunday .. Saturday)

=item *

%u 日曜日を基点とする週日の番号 (1〜7)

=item *

%w 日曜日を基点とする週日の索引 (0〜6)

=item *

%H 時(24時間表記)の前ゼロ詰め2桁 (00〜23)

=item *

%k 時(24時間表記)の前空白詰め2桁 (_0〜23)

=item *

%I 時(12時間表記)の前ゼロ詰め2桁 (_0〜11)

=item *

%l 時(12時間表記)の前空白詰め2桁 (_0〜11)

=item *

%p 午前(AM)、または午後(PM)

=item *

%P 午前(am)、または午後(pm)

=item *

%M 分の前ゼロ詰め2桁 (00〜59)

=item *

%S 秒の前ゼロ詰め2桁 (00〜60)

=item *

%z 協定世界時(UTC)へのオフセット(+MMSS/-MMSS)、UTCの場合はZ

=item *

%c 日本で一般的な日付・時刻形式 (yyyy/MM/dd HH:mm:ss)

=item *

%x 日本で一般的な日付形式 (yyyy/MM/dd)

=item *

%X 日本で一般的な時刻形式 (HH:mm:ss)

=item *

%D %m/%d/%yと同じ

=item *

%F %Y-%m-%dと同じ

=item *

%r 12時間表記の時刻 (%I:%M:%S %pと同じ)

=item *

%T 24時間表記の時刻 (%H:%M:%Sと同じ)

=item *

%R 秒を除く24時間表記の時刻 (%H:%Mと同じ)

=item *

%s エポック秒 (UNIX時間)

=item *

%j 年の経過日数 (001〜366)

=item *

%n 改行

=item *

%t タブ

=back

=head1 AUTHOR

atdev01 E<lt>mine_t7 at hotmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020-2025 atdev01.

This library is free software; you can redistribute it and/or modify
it under the same terms of the Artistic License 2.0. For details,
see the full text of the license in the file LICENSE.

=cut