package HTTP::MobileAttribute::Plugin::IS::EZweb;

use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub is_win : CarrierMethod('EZweb') { substr($_[1]->device_id, 2, 1) eq '3' }
sub is_tuka : CarrierMethod('EZweb') {
    my ($self, $c) = @_;
    my $tuka = substr($_[1]->device_id, 2, 1);
    if ($c->is_wap2 && $tuka eq 'U') {
        return 1;
    }
    elsif ($tuka eq 'T') {
        return 1;
    }
}
sub is_wap1 : CarrierMethod('EZweb') { !$_[1]->xhtml_compliant }
sub is_wap2 : CarrierMethod('EZweb') { $_[1]->xhtml_compliant }

1;
