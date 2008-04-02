package HTTP::MobileAttribute::Request;
use strict;
use warnings;
use base qw/Class::C3::Componentised/;
use Carp;

sub component_base_class { __PACKAGE__ }

__PACKAGE__->load_components(
    qw/
        Apache
        Env
        HTTPHeaders
    /
);

sub new {
    my ($class, $stuff) = @_;

    my $self = $class->next::method($stuff);
    unless ($self) {
        croak "unknown request type: $stuff";
    }
    return $self;
}

1;
