package HTTP::MobileAttribute::Attribute::MobileMethod;
use strict;
use warnings;
use base 'Class::Component::Attribute';

sub register {
    my ( $class, $plugin, $c, $method, $parameter, $code ) = @_;
    $parameter =~ s/\s*//g;
    my ($meth, $carrier ) = split /,/, $parameter;
    if ($c->carrier_longname eq $carrier) {
        $c->register_method( $meth => $plugin );
    }
}

1;

__END__

=head1 SYNOPSIS

    sub foo : MobileMethod('html_version,DoCoMo') {
        # your codes here
    }

