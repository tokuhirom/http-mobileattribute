package HTTP::MobileAttribute::Plugin::Default::DoCoMo;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

our $DefaultCacheSize = 5;

sub initialize : Hook('initialize') {
    my ( $self, $c ) = @_;
    return unless $c->carrier_longname eq 'DoCoMo';
    $self->mk_register_accessors( $c => qw/version model status bandwidth serial_number is_foma card_id xhtml_compliant comment/);

    $self->parse( $c );
}


sub name : CarrierMethod('DoCoMo') { shift->{name} }

sub cache_size :CarrierMethod('DoCoMo') {
    my $self = shift;
    return $self->{cache_size} || $DefaultCacheSize;
}

sub series :CarrierMethod('DoCoMo') {
    my $self  = shift;
    my $model = $self->model;

    if ( $self->is_foma && $model =~ /\d{4}/ ) {
        return 'FOMA';
    }

    $model =~ /(\d{3}i)/;
    return $1;
}

sub vendor :CarrierMethod('DoCoMo') {
    my $self  = shift;
    my $model = $self->model;
    $model =~ /^([A-Z]+)\d/;
    return $1;
}

# see also L<WWW::MobileCarrierJP::DoCoMo::HTMLVersion>
our $DoCoMoHTMLVersionMap = [
    # regex => version
    qr/[DFNP]501i/                                         => '1.0',
    qr/502i|821i|209i|691i|(F|N|P|KO)210i|^F671i$/         => '2.0',
    qr/(D210i|SO210i)|503i|211i|SH251i|692i|200[12]|2101V/ => '3.0',
    qr/504i|251i|^F671iS$|^F661i$|^F672i$|212i|SO213i|2051|2102V|2701|850i/ => '4.0',
    qr/eggy|P751v/ => '3.2',
    qr/505i|506i|252i|253i|P213i|600i|700i|701i|800i|880i|SH851i|P851i|881i|900i|901i/ => '5.0',
    qr/702i|D851iWM|902i/ => '6.0',
];

sub html_version: CarrierMethod('DoCoMo') {
    my ($self, $c) = @_;

    my @map = @$DoCoMoHTMLVersionMap;
    while ( my ( $re, $version ) = splice( @map, 0, 2 ) ) {
        return $version if $self->model =~ /$re/;
    }
    return;
}

sub parse {
    my ( $self, $c ) = @_;

    my ( $main, $foma_or_comment ) = split / /, $c->user_agent, 2;

    if ( $foma_or_comment && $foma_or_comment =~ s/^\((.*)\)$/$1/ ) {
        # DoCoMo/1.0/P209is (Google CHTML Proxy/1.0)
        $self->{comment} = $1;
        $self->_parse_main($main);
    }
    elsif ($foma_or_comment) {
        # DoCoMo/2.0 N2001(c10;ser0123456789abcde;icc01234567890123456789)
        $self->{is_foma} = 1;
        @{$self}{qw(name version)} = split m!/!, $main;
        $self->_parse_foma($foma_or_comment);
    }
    else {
        # DoCoMo/1.0/R692i/c10
        $self->_parse_main($main);
    }

    $self->{xhtml_compliant} =
        ( $self->is_foma
            && !( $self->html_version && $self->html_version == 3.0 ) )
        ? 1
        : 0;

}

sub _parse_main {
    my ( $self, $main ) = @_;
    my ( $name, $version, $model, $cache, @rest ) = split m!/!, $main;
    $self->{name}    = $name;
    $self->{version} = $version;
    $self->{model}   = $model;
    $self->{model}   = 'SH505i' if $self->{model} eq 'SH505i2';

    if ($cache) {
        $cache =~ s/^c// or return $self->no_match;
        $self->{cache_size} = $cache;
    }

    for (@rest) {
        /^ser(\w{11})$/  and do { $self->{serial_number} = $1;      next };
        /^(T[CDBJ])$/    and do { $self->{status}        = $1;      next };
        /^s(\d+)$/       and do { $self->{bandwidth}     = $1;      next };
        /^W(\d+)H(\d+)$/ and do { $self->{display_bytes} = "$1*$2"; next; };
    }
}

sub _parse_foma {
    my ( $self, $foma ) = @_;

    $foma =~ s/^([^\(]+)// or return $self->no_match;
    $self->{model} = $1;
    $self->{model} = 'SH2101V' if $1 eq 'MST_v_SH2101V';    # Huh?

    if ( $foma =~ s/^\((.*?)\)$// ) {
        my @options = split /;/, $1;
        for (@options) {
            /^c(\d+)$/      and $self->{cache_size}    = $1, next;
            /^ser(\w{15})$/ and $self->{serial_number} = $1, next;
            /^icc(\w{20})$/ and $self->{card_id}       = $1, next;
            /^(T[CDBJ])$/   and $self->{status}        = $1, next;
            /^W(\d+)H(\d+)$/ and $self->{display_bytes} = "$1*$2", next;
            $self->no_match;
        }
    }
}

1;
