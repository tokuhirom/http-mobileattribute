package HTTP::MobileAttribute::Attribute::CarrierMethod;
use strict;
use warnings;
use base 'Class::Component::Attribute';

sub register {
    my ( $class, $plugin, $c, $method, $param, $code ) = @_;

    my $carrier;
    if (ref $param) {
        my $original_method = $method;
        my $proto           = ref $plugin;

        $carrier = $param->[0];
        $method  = $param->[1];
        $plugin  = "${proto}::${carrier}";

        no strict 'refs';
        *{"${plugin}::${method}"} = *{"${proto}::${original_method}"};
    } else {
        $carrier = $param;
    }

    $c->agent_class($carrier)->register_method( $method => $plugin );
}

1;

__END__

=head1 SYNOPSIS

    sub foo : MobileMethod('DoCoMo') {
        # your codes here
    }

