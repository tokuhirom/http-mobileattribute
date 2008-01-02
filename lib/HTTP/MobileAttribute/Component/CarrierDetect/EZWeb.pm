package HTTP::MobileAttribute::Component::CarrierDetect::EZWeb;
use strict;
use warnings;
use HTTP::MobileAttribute::Agent::EZWeb;

our $RE = qr{^(?:KDDI-[A-Z]+\d+[A-Z]? )?UP\.Browser\/};

sub get_agent {
    my ($self, $stuff) = @_;

    if ($stuff =~ $RE) {
        return HTTP::MobileAttribute::Agent::EZWeb->new;
    } else {
        return $self->NEXT('get_agent', $stuff);
    }
}

1;
