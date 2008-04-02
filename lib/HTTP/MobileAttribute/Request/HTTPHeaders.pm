package HTTP::MobileAttribute::Request::HTTPHeaders;
use strict;
use warnings;
use Scalar::Util qw/blessed/;

sub new {
    my ($class, $stuff) = @_;

    if ( blessed($stuff) && $stuff->isa('HTTP::Headers') ) {
        return bless { r => $stuff }, __PACKAGE__; 
    } else {
        return $class->next::method($stuff);
    }
}

sub get {
    my ($self, $header) = @_;
    return $self->{r}->header($header);
}

1;
