package HTTP::MobileAttribute::Request::Apache;
use strict;
use warnings;
use Scalar::Util qw/blessed/;

sub new {
    my ($class, $stuff) = @_;

    if ( blessed($stuff) && $stuff->isa('Apache') ) {
        return bless { r => $stuff }, __PACKAGE__; 
    } else {
        return $class->next::method($stuff);
    }
}

sub get {
    my ($self, $header) = @_;
    return $self->{r}->header_in($header);
}

1;
