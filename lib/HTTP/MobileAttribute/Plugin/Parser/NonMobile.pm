package HTTP::MobileAttribute::Plugin::Parser::NonMobile;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub parse           :CarrierMethod('NonMobile') { } # nop
sub model           :CarrierMethod('NonMobile') { '' }
sub device_id       :CarrierMethod('NonMobile') { '' }

1;
