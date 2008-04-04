package HTTP::MobileAttribute::Plugin::Parser::EZweb;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

__PACKAGE__->accessors('EZweb' => [qw/name version model device_id server comment/]);

sub parse :CarrierMethod('EZweb') {
    my ( $self, $c ) = @_;

    my $ua = $c->user_agent;
    if ( $ua =~ s/^KDDI\-// ) {
        # KDDI-TS21 UP.Browser/6.0.2.276 (GUI) MMP/1.1
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
