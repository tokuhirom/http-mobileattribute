package HTTP::MobileAttribute::Plugin::Display;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;
use HTTP::MobileAttribute;
use HTTP::MobileAttribute::Plugin::Display::DoCoMoMap qw/$DisplayMap/;

sub thirdforce :CarrierMethod('ThirdForce', 'display') {
    my ($self, $c) = @_;
    my $request = $c->request;

    my($width, $height) = split /\*/, $request->get('x-jphone-display');

    my($color, $depth);
    if (my $c_str = $request->get('x-jphone-color')) {
        ($color, $depth) = $c_str =~ /^([CG])(\d+)$/;
    }

    return HTTP::MobileAttribute::Plugin::Display::Display->new(+{
        width  => $width,
        height => $height,
        color  => $color eq 'C',
        depth  => $depth,
    });
}

sub ezweb :CarrierMethod('EZweb', 'display') {
    my ($self, $c) = @_;
    my $request = $c->request;

    my ( $width, $height ) = split /,/, $request->get('x-up-devcap-screenpixels');
    my $depth = ( split /,/, $request->get('x-up-devcap-screendepth') )[0];
    my $color = $request->get('x-up-devcap-iscolor');

    return HTTP::MobileAttribute::Plugin::Display::Display->new(+{
        width  => $width,
        height => $height,
        color  => ( defined $color && $color eq '1' ),
        depth  => 2**$depth,
    });
}

sub docomo :CarrierMethod('DoCoMo', 'display') {
    my ($self, $c) = @_;
    return HTTP::MobileAttribute::Plugin::Display::Display->new($DisplayMap->{ uc( $c->model ) });
}

package HTTP::MobileAttribute::Plugin::Display::Display;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors(qw/width height color depth/);

1;
