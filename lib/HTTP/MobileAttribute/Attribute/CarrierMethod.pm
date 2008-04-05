package HTTP::MobileAttribute::Attribute::CarrierMethod;
use strict;
use warnings;
use base 'Class::Component::Attribute';

sub register {
    my ( $class, $plugin, $c, $method, $param, $code ) = @_;

    if (ref $param) {
        return unless $c =~ $param->[0];
        $c->register_method( $param->[1] => { plugin => $plugin, method => $method } );
    } else {
        return unless $c =~ $param;
        $c->register_method( $method => $plugin );
    }
}

1;

__END__

=head1 SYNOPSIS

    sub foo : MobileMethod('DoCoMo') {
        # your codes here
    }

