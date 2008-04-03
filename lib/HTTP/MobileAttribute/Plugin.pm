package HTTP::MobileAttribute::Plugin;
use strict;
use warnings;
use base qw/Class::Component::Plugin/;

sub mk_register_accessors {
    my $self    = shift;
    return if $self->{__method_registerd};
    my $carrier = shift;
    my $class   = ref $self;

    my $pkg = HTTP::MobileAttribute->agent_class($carrier);
    for my $method (@_) {
        no strict 'refs';
        *{"$class\::$method"} = sub { shift->{$method} };
        $pkg->register_method( $method => $self );
    }
    $self->{__method_registerd} = 1;
}

sub instance_clear : Hook('instance_clear') {
    my($self, $c) = @_;
    for my $key (keys %{ $self }) {
        delete $self->{$key} unless $key eq 'config' || $key eq '__method_registerd';
    }
}

1;
