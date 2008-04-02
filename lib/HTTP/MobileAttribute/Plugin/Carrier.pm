package HTTP::MobileAttribute::Plugin::Carrier;
use strict;
use warnings;
use base qw/Class::Component::Plugin/;

sub carrier :Method('carrier') {
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
