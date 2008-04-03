package HTTP::MobileAttribute::Plugin::Default::AirHPhone;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub initialize : Hook('initialize_AirHPhone') {
    my ($self, $c) = @_;

    $self->mk_register_accessors( AirHPhone => qw(name vendor model model_version browser_version cache_size));
    $self->parse($c->user_agent);
}

sub parse {
    my ($self, $ua) = @_;
    $ua =~ m!^Mozilla/3\.0\((WILLCOM|DDIPOCKET);(.*)\)! or $self->no_match;
    $self->{name} = $1;
    @{$self}{qw(vendor model model_version browser_version cache_size)} = split m!/!, $2;
    $self->{cache_size} =~ s/^c//i;
}

'please release ridge!!';
