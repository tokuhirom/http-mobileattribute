package HTTP::MobileAttribute::Plugin;
use strict;
use warnings;
use base qw/Class::Component::Plugin/;

sub class_component_load_attribute_resolver {
    $_[1] eq 'CarrierMethod' ? "HTTP::MobileAttribute::Attribute::CarrierMethod" : undef
}

1;
