package HTTP::MobileAttribute::Component::CarrierDetect::AirHPhone;
use strict;
use warnings;
use HTTP::MobileAttribute::Agent::AirHPhone;

our $RE = qr{^Mozilla/3\.0\((?:WILLCOM|DDIPOCKET)\;};

sub get_agent {
    my ($self, $stuff) = @_;

    if ($stuff =~ $RE) {
        return HTTP::MobileAttribute::Agent::AirHPhone->new;
    } else {
        return $self->NEXT('get_agent', $stuff);
    }
}

1;
