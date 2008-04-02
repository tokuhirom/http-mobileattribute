package HTTP::MobileAttribute::Plugin::Default::AirHPhone;
use strict;
use warnings;
use base qw/Class::Component::Plugin/;

sub initialize : Hook('initialize') {
    my ($self, $c) = @_;
    return unless $c->carrier_longname eq 'AirHPhone';
    $self->parse($c->user_agent);
}

for my $method (qw(name vendor model model_version browser_version cache_size)) {
    eval qq! sub $method :MobileMethod("$method,AirHPhone") { shift->{$method} }; !; ## no critic.
    die $@ if $@;
}

sub parse {
    my ($self, $ua) = @_;
    $ua =~ m!^Mozilla/3\.0\((WILLCOM|DDIPOCKET);(.*)\)! or $self->no_match;
    $self->{name} = $1;
    @{$self}{qw(vendor model model_version browser_version cache_size)} = split m!/!, $2;
    $self->{cache_size} =~ s/^c//i;
}

'please release ridge!!';
