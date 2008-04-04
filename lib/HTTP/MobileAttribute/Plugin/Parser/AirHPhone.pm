package HTTP::MobileAttribute::Plugin::Parser::AirHPhone;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

__PACKAGE__->accessors( AirHPhone => [qw/name vendor model model_version browser_version cache_size/]);

sub parse :CarrierMethod('AirHPhone') {
    my ($self, $c) = @_;
    $c->user_agent =~ m!^Mozilla/3\.0\((WILLCOM|DDIPOCKET);(.*)\)! or $self->no_match;
    $c->{name} = $1;
    @{$c}{qw(vendor model model_version browser_version cache_size)} = split m!/!, $2;
    $c->{cache_size} =~ s/^c//i;
}

'please release ridge!!';
