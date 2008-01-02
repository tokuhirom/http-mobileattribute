use strict;
use warnings;
use Test::Base;
use HTTP::MobileAttribute;

HTTP::MobileAttribute->load_components(qw/
    CarrierDetect::AirHPhone
    CarrierDetect::EZWeb
    CarrierDetect::ThirdForce
    CarrierDetect::DoCoMo
/);

plan tests => 1*blocks;

filters {
    input    => [qw/get_carrier/],
    expected => [qw/append_prefix/],
};

sub append_prefix {
    my $x = shift;
    "HTTP::MobileAttribute::Agent::$x";
}

sub get_carrier {
    my $ua = shift;
    ref HTTP::MobileAttribute->new->get_agent($ua);
}

run_is input => 'expected';

__END__

===
--- input: DoCoMo/1.0/NM502i
--- expected: DoCoMo

===
--- input: J-PHONE/5.0/V801SA
--- expected: ThirdForce

===
--- input: KDDI-TS21 UP.Browser/6.0.2.276 (GUI) MMP/1.1
--- expected: EZWeb

===
--- input: Mozilla/2.0 (compatible; Ask Jeeves)
--- expected: NonMobile

===
--- input: Mozilla/3.0(DDIPOCKET;JRC/AH-J3001V,AH-J3002V/1.0/0100/c50)CNF/2.0
--- expected: AirHPhone

