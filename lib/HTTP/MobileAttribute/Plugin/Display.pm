package HTTP::MobileAttribute::Plugin::Display;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;
use HTTP::MobileAttribute;
use HTTP::MobileAttribute::Plugin::Display::DoCoMoMap qw/$DisplayMap/;

my %ARG_DISPATCH = (
    ThirdForce => \&__thirdforce_args,
    EZweb      => \&__ezweb_args,
    DoCoMo     => \&__docomo_args,
);

sub display : Method {
    my ($self, $c) = @_;

    my $code = $ARG_DISPATCH{$c->carrier_longname};
    if ($code) {
        HTTP::MobileAttribute::Plugin::Display::Display->new( $code->($c) );
    } else {
        return;
    }
}

sub __thirdforce_args
{
    my $c = shift;
    my $request = $c->request;

    my($width, $height) = split /\*/, $request->get('x-jphone-display');

    my($color, $depth);
    if (my $c_str = $request->get('x-jphone-color')) {
        ($color, $depth) = $c_str =~ /^([CG])(\d+)$/;
    }

    +{
        width  => $width,
        height => $height,
        color  => $color eq 'C',
        depth  => $depth,
    };
}

sub __ezweb_args
{
    my $c = shift;
    my $request = $c->request;

    my ( $width, $height ) = split /,/, $request->get('x-up-devcap-screenpixels');
    my $depth = ( split /,/, $request->get('x-up-devcap-screendepth') )[0];
    my $color = $request->get('x-up-devcap-iscolor');

    +{
        width  => $width,
        height => $height,
        color  => ( defined $color && $color eq '1' ),
        depth  => 2**$depth,
    };
}

sub __docomo_args
{
    my $c = shift;
    $DisplayMap->{ uc( $c->model ) };
}

package HTTP::MobileAttribute::Plugin::Display::Display;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors(qw/width height color depth/);

1;
