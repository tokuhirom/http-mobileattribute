package HTTP::MobileAttribute::Request::Env;
use strict;
use warnings;
use Scalar::Util qw/blessed/;

sub new {
    my ($class, $stuff) = @_;

    if ( not defined $stuff ) {
        return bless { env => \%ENV }, __PACKAGE__; 
    } elsif ( not ref $stuff ) {
        return bless { env => { HTTP_USER_AGENT => $stuff } }, __PACKAGE__; 
    } else {
        return $class->next::method($stuff);
    }
}

sub get {
    my ($self, $header) = @_;
    $header =~ tr/-/_/;
    return $self->{env}->{"HTTP_" . uc($header)};
}

1;
