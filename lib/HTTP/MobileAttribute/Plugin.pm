package HTTP::MobileAttribute::Plugin;
use strict;
use warnings;
use base qw/Class::Component::Plugin/;

__PACKAGE__->mk_classdata('__accessors');

sub new {
    my ($class, $config, $c) = @_;
    my $self = $class->SUPER::new($config, $c);
    if ($self->__accessors) {
        $c->register_accessors_delayed( $self->__accessors);
        $self->__accessors(undef);
    }
    $self;
}

sub accessors {
    my ($class, $carrier, $accessors) = @_;

    $class->__accessors({carrier => $carrier, accessors => $accessors, package => $class});
}

1;
