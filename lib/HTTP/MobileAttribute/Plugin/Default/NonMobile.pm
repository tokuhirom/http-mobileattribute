package HTTP::MobileAttribute::Plugin::Default::NonMobile;
use strict;
use warnings;
use base qw/Class::Component::Plugin/;

sub model           :MobileMethod('model,NonMobile') { '' }
sub device_id       :MobileMethod('model,NonMobile') { '' }
sub xhtml_compliant :MobileMethod('xhtml_compliant,NonMobile') { 1 }

1;
