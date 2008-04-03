package HTTP::MobileAttribute::Plugin::IS::ThirdForce;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub is_type_c   :CarrierMethod('ThirdForce') { $_[1]->type =~ /^C/ }
sub is_type_p   :CarrierMethod('ThirdForce') { $_[1]->type =~ /^P/ }
sub is_type_w   :CarrierMethod('ThirdForce') { $_[1]->type =~ /^W/ }
sub is_type_3gc :CarrierMethod('ThirdForce') { $_[1]->type eq '3GC' }

1;
