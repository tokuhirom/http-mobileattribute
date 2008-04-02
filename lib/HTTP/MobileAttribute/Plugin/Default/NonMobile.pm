package HTTP::MobileAttribute::Plugin::Default::NonMobile;
use strict;
use warnings;
use base qw/Class::Component::Plugin/;

sub model           :MobileMethod('NonMobile') { '' }
sub device_id       :MobileMethod('NonMobile') { '' }
sub xhtml_compliant :MobileMethod('NonMobile') { 1 }

1;
