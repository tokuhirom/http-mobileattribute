package HTTP::MobileAttribute::Plugin::Default::EZweb;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub initialize : CarrierMethod('EZweb') {
    my ( $self, $c ) = @_;

    $self->mk_register_accessors( EZweb => qw(name version model device_id server xhtml_compliant comment));

    $self->parse( $c );
}

sub is_tuka : CarrierMethod('EZweb') {
    my ($self, $c) = @_;

    my $tuka = substr( $c->device_id, 2, 1 );

    if ( $c->xhtml_compliant ) {
        return 1 if $tuka eq 'U';
    }
    else {
        return 1 if $tuka eq 'T';
    }
    return;
}

sub is_win : CarrierMethod('EZweb') {
    my ($self, $c) = @_;
    my $win = substr( $c->device_id, 2, 1 );
    $win eq '3' ? 1 : 0;
}

sub parse {
    my ( $self, $c ) = @_;

    my $ua = $c->user_agent;
    if ( $ua =~ s/^KDDI\-// ) {
        # KDDI-TS21 UP.Browser/6.0.2.276 (GUI) MMP/1.1
        $c->{xhtml_compliant} = 1;
        my ( $device, $browser, $opt, $server ) = split / /, $ua, 4;
        $c->{device_id} = $device;

        my ( $name, $version ) = split m!/!, $browser;
        $c->{name}    = $name;
        $c->{version} = "$version $opt";
        $c->{server}  = $server;
    }
    else {
        # UP.Browser/3.01-HI01 UP.Link/3.4.5.2
        my ( $browser, $server, $comment ) = split / /, $ua, 3;
        my ( $name, $software ) = split m!/!, $browser;
        $c->{name} = $name;
        @{$c}{qw(version device_id)} = split /-/, $software;
        $c->{server} = $server;
        if ($comment) {
            $comment =~ s/^\((.*)\)$/$1/;
            $c->{comment} = $comment;
        }
    }
    $c->{model} = $c->{device_id};
}

1;
