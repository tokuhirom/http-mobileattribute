package HTTP::MobileAttribute::Plugin::Carrier;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub carrier :Method {
    my ($self, $c) = @_;

    return +{
        DoCoMo     => 'I',
        ThirdForce => 'V',
        EZweb      => 'E',
        AirHPhone  => 'H',
        NonMobile  => 'N',
    }->{ $c->carrier_longname };
}

1;
