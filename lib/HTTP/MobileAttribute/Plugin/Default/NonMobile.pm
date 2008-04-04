package HTTP::MobileAttribute::Plugin::Default::NonMobile;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub initialize      :CarrierMethod('NonMobile') { } # nop
sub model           :CarrierMethod('NonMobile') { '' }
sub device_id       :CarrierMethod('NonMobile') { '' }

1;
