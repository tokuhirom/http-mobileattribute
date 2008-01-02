package HTTP::MobileAttribute::Component::CarrierDetect::DoCoMo;
use strict;
use warnings;
use HTTP::MobileAttribute::Agent::DoCoMo;

our $RE = qr{^DoCoMo/\d\.\d[ /]};

sub get_agent {
    my ($self, $stuff) = @_;

    if ($stuff =~ $RE) {
        return HTTP::MobileAttribute::Agent::DoCoMo->new;
    } else {
        return $self->NEXT('get_agent', $stuff);
    }
}

1;
