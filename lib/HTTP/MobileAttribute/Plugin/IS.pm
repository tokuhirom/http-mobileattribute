package HTTP::MobileAttribute::Plugin::IS;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub is_docomo: Method {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'DoCoMo' ? 1 : 0;
}

sub is_j_phone: Method {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'ThirdForce' ? 1 : 0;
}

sub is_vodafone: Method {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'ThirdForce' ? 1 : 0;
}

sub is_softbank: Method {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'ThirdForce' ? 1 : 0;
}

sub is_ezweb: Method {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'EZweb' ? 1 : 0;
}

sub is_airh_phone: Method {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'AirHPhone' ? 1 : 0;
}

sub is_non_mobile: Method {
    my ($self, $c) = @_;
    return $c->carrier_longname eq 'NonMobile' ? 1 : 0;
}

1;
