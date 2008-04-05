package HTTP::MobileAttribute::Agent::Base;
use strict;
use warnings;
require Class::Component;

sub import {
    my $pkg = caller(0);

    no strict 'refs';

    *{"$pkg\::mk_accessors"} = \&mk_accessors;
    *{"$pkg\::user_agent"}   = sub { $_[0]->request->get('User-Agent') };
    *{"$pkg\::class_component_load_plugin_resolver"} = sub { "HTTP::MobileAttribute::Plugin::$_[1]" };
    $pkg->mk_accessors(qw/request carrier_longname/);

    unless ($pkg->isa('Class::Component')) {
        unshift @{"$pkg\::ISA"}, 'Class::Component';
    }
    Class::Component::Implement->init($pkg);

    $pkg->load_components(qw/DisableDynamicPlugin Autocall::InjectMethod/);
}

sub mk_accessors {
    my ($class, @methods) = @_;

    no strict 'refs';
    for my $method (@methods) {
        *{"${class}::${method}"} = sub { $_[0]->{$method} };
    }
}

1;
