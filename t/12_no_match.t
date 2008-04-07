use strict;
use warnings;
use Test::More tests => 1;
use Test::Warn;
use HTTP::MobileAttribute::Agent::AirHPhone;
use HTTP::MobileAttribute::Request;

local $^W = 1;

my $agent = HTTP::MobileAttribute::Agent::AirHPhone->new(
    {
        request => HTTP::MobileAttribute::Request->new('DoCoMo/1.0'),
        carrier_longname => 'AirHPhone',
    }
);

warnings_like { $agent->parse } qr{please contact the author};

