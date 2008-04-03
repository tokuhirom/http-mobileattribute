package HTTP::MobileAttribute::Plugin::Default::NonMobile;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub model           :CarrierMethod('NonMobile') { '' }
sub device_id       :CarrierMethod('NonMobile') { '' }
sub xhtml_compliant :CarrierMethod('NonMobile') { 1 }

1;
