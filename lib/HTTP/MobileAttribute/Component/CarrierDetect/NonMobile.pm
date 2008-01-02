package HTTP::MobileAttribute::Component::CarrierDetect::NonMobile;
use strict;
use warnings;

sub get_agent {
    my ($self, $stuff) = @_;

    return $self->NEXT('get_agent', $stuff);
}

1;
