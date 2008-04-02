package HTTP::MobileAttribute::Plugin;
use strict;
use warnings;
use base qw/Class::Component::Plugin/;

sub mk_register_accessors {
    my $self = shift;
    my $c     = shift;
    my $class = ref $self;

    for my $method (@_) {
        no strict 'refs';
        *{"$class\::$method"} = sub { shift->{$method} } unless *{"$class\::$method"}{CODE};
        $c->register_method( $method => $self );
    }
}
1;
