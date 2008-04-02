package HTTP::MobileAttribute::Plugin::GPS;
use strict;
use warnings;
use base qw/Class::Component::Plugin/;

our $DoCoMoGPSModels = { map { $_ => 1 } qw(F661i F505iGPS) };

sub is_gps : MobileMethod('is_gps,DoCoMo') {
    my ($self, $c) = @_;
    return exists $DoCoMoGPSModels->{ $c->model };
}

1;
