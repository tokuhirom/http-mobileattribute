package HTTP::MobileAttribute::Plugin::Display;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;
use HTTP::MobileAttribute;
use HTTP::MobileAttribute::Plugin::Display::DoCoMoMap qw/$DisplayMap/;

sub display : Method {
    my ($self, $c) = @_;

    my $code = +{
        ThirdForce => sub {
            my($width, $height) = split /\*/, $c->request->get('x-jphone-display');

            my($color, $depth);
            if (my $c_str = $c->request->get('x-jphone-color')) {
                ($color, $depth) = $c_str =~ /^([CG])(\d+)$/;
            }

            +{
                width  => $width,
                height => $height,
                color  => $color eq 'C',
                depth  => $depth,
            };
        },
        EZweb => sub {
            my ( $width, $height ) = split /,/, $c->request->get('x-up-devcap-screenpixels');
            my $depth = ( split /,/, $c->request->get('x-up-devcap-screendepth') )[0];
            my $color = $c->request->get('x-up-devcap-iscolor');

            +{
                width  => $width,
                height => $height,
                color  => ( defined $color && $color eq '1' ),
                depth  => 2**$depth,
            };
        },
        DoCoMo => sub {
            $DisplayMap->{ uc( $c->model ) };
        },
    }->{$c->carrier_longname};

    if ($code) {
        HTTP::MobileAttribute::Plugin::Display::Display->new( $code->() );
    } else {
        return;
    }
}

package HTTP::MobileAttribute::Plugin::Display::Display;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors(qw/width height color depth/);

1;
