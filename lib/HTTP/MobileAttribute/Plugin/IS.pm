package HTTP::MobileAttribute::Plugin::IS;
use strict;
use warnings;
use base qw/Class::Component::Plugin/;

sub is_docomo: Method('is_docomo') {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'DoCoMo' ? 1 : 0;
}

sub is_j_phone: Method('is_j_phone') {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'ThirdForce' ? 1 : 0;
}

sub is_vodafone: Method('is_vodafone') {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'ThirdForce' ? 1 : 0;
}

sub is_ezweb: Method('is_ezweb') {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'EZweb' ? 1 : 0;
}

sub is_airh_phone: Method('is_airh_phone') {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'AirHPhone' ? 1 : 0;
}

sub is_non_mobile: Method('is_non_mobile') {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'NonMobile' ? 1 : 0;
}

1;
