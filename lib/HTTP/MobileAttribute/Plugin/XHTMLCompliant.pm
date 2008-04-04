package HTTP::MobileAttribute::Plugin::XHTMLCompliant;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub docomo :CarrierMethod('DoCoMo', 'xhtml_compliant') {
    my ($self, $c) = @_;

    # TOOD: should not depend to html_version.
    return ( $c->is_foma && !( $c->html_version && $c->html_version == 3.0 ) )
            ? 1
            : 0;
}

sub ezweb :CarrierMethod('EZweb', 'xhtml_compliant') {
    my ($self, $c) = @_;

    if ( $c->user_agent =~ /^KDDI\-/ ) {
        return 1;
    } else {
        return;
    }
}

sub non_mobile :CarrierMethod('NonMobile', 'xhtml_compliant') { 1 }

sub third_force :CarrierMethod('ThirdForce', 'xhtml_compliant') {
    my ($self, $c) = @_;
    return ( $c->is_type_w || $c->is_type_3gc ) ? 1 : 0;
}

1;
