package HTTP::MobileAttribute::Plugin::GPS;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

our $DoCoMoGPSModels = { map { $_ => 1 } qw(F661i F505iGPS) };

# only for backward compatiblity
sub is_gps : CarrierMethod('DoCoMo') {
    my ($self, $c) = @_;
    warn "THIS METHOD IS OBSOLETE. DO NOT USE THIS.";
    return exists $DoCoMoGPSModels->{ $c->model };
}

# -------------------------------------------------------------------------

our $DOCOMO_GPS_COMPLIANT_MODELS = qr/(?:903i(?!TV|X)|(?:90[4-6]|SA[78]0[02])i)/;

sub gc_i :CarrierMethod('DoCoMo', 'gps_compliant') {
    my ($self, $c) = @_;
    return $c->model =~ $DOCOMO_GPS_COMPLIANT_MODELS;
}

sub gc_e :CarrierMethod('EZweb', 'gps_compliant') {
    my @specs = split //, $ENV{ HTTP_X_UP_DEVCAP_MULTIMEDIA } || '';
    return defined $specs[ 1 ] && $specs[ 1 ] =~ /^[23]$/;
}

sub gc_v :CarrierMethod('ThirdForce', 'gps_compliant') {
    my ($self, $c) = @_;
    return $c->is_type_3gc;
}

sub gc_h :CarrierMethod('AirHPhone', 'gps_compliant') {
    return 0; # does not supported.
}

1;
