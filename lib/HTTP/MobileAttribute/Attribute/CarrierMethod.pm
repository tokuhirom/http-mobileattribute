package HTTP::MobileAttribute::Attribute::CarrierMethod;
use strict;
use warnings;
use base 'Class::Component::Attribute';

sub register {
    my ( $class, $plugin, $c, $method, $carrier, $code ) = @_;

    if ($c->carrier_longname eq $carrier) {
        $c->register_method( $method => $plugin );
    }
}

1;

__END__

=head1 SYNOPSIS

    sub foo : MobileMethod('DoCoMo') {
        # your codes here
    }

