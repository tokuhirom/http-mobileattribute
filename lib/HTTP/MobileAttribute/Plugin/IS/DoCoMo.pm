package HTTP::MobileAttribute::Plugin::IS::DoCoMo;

use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub is_foma : CarrierMethod('DoCoMo') { $_[1]->version eq '2.0' }

1;

