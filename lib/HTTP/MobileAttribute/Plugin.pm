package HTTP::MobileAttribute::Plugin;
use strict;
use warnings;
use base qw/Class::Component::Plugin/;

sub mk_register_accessors {
    my $self    = shift;
    my $carrier = shift;
    my $class   = ref $self;

    my $pkg = HTTP::MobileAttribute->agent_class($carrier);
    for my $method (@_) {
        no strict 'refs';
        *{"$class\::$method"} = sub { shift->{$method} } unless *{"$class\::$method"}{CODE};
        $pkg->register_method( $method => $self );
    }
}

sub instance_clear : Hook('instance_clear') {
    my($self, $c) = @_;
    for my $key (keys %{ $self }) {
        delete $self->{$key} unless $key eq 'config';
    }
}

1;
