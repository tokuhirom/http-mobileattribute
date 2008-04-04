package HTTP::MobileAttribute::Plugin::Default::DoCoMo;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

__PACKAGE__->accessors('DoCoMo' => [qw/version model status bandwidth serial_number is_foma card_id comment name/]);

sub initialize : CarrierMethod('DoCoMo') {
    my ( $self, $c ) = @_;

    $self->parse( $c );
}

# see also L<WWW::MobileCarrierJP::DoCoMo::HTMLVersion>
our $Ver10RE = qr/[DFNP]501i/;
our $Ver20RE = qr/502i|821i|209i|691i|(?:F|N|P|KO)210i|^F671i$/;
our $Ver30RE = qr/(?:D210i|SO210i)|503i|211i|SH251i|692i|200[12]|2101V/;
our $Ver32RE = qr/eggy|P751v/;
our $Ver40RE = qr/504i|251i|^F671iS$|^F661i$|^F672i$|212i|SO213i|2051|2102V|2701|850i/;
our $Ver50RE = qr/505i|506i|252i|253i|P213i|600i|700i|701i|800i|880i|SH851i|P851i|881i|900i|901i/;
our $Ver60RE = qr/702i|D851iWM|902i/;

sub html_version: CarrierMethod('DoCoMo') {
    my ($self, $c) = @_;

    # I want memoize...
    return $c->{__html_version} ||= do {
        my $model = $c->model;

        # id:tokuhirm doesn't like eval expansion, so I'm handrolling this bitch ;)
        if ($model =~ /$Ver10RE/) {
            return '1.0';
        } elsif ($model =~ /$Ver20RE/) {
            return '2.0';
        } elsif ($model =~ /$Ver30RE/) {
            return '3.0';
        } elsif ($model =~ /$Ver40RE/) {
            return '4.0';
        } elsif ($model =~ /$Ver32RE/) {
            return '3.2';
        } elsif ($model =~ /$Ver50RE/) {
            return '5.0';
        } elsif ($model =~ /$Ver60RE/) {
            return '6.0';
        } 
        return;
    };
}

sub parse {
    my ( $self, $c ) = @_;

    my ( $main, $foma_or_comment ) = split / /, $c->user_agent, 2;

    if ( $foma_or_comment && $foma_or_comment =~ s/^\((.*)\)$/$1/ ) {
        # DoCoMo/1.0/P209is (Google CHTML Proxy/1.0)
        $c->{comment} = $1;
        $self->_parse_main($c, $main);
    }
    elsif ($foma_or_comment) {
        # DoCoMo/2.0 N2001(c10;ser0123456789abcde;icc01234567890123456789)
        $c->{is_foma} = 1;
        @{$c}{qw(name version)} = split m!/!, $main;
        $self->_parse_foma($c, $foma_or_comment);
    }
    else {
        # DoCoMo/1.0/R692i/c10
        $self->_parse_main($c, $main);
    }

}

sub _parse_main {
    my ( $self, $c, $main ) = @_;
    my ( $name, $version, $model, $cache, @rest ) = split m!/!, $main;
    $c->{name}    = $name;
    $c->{version} = $version;
    $c->{model}   = $model;
    $c->{model}   = 'SH505i' if $c->{model} eq 'SH505i2';

    if ($cache) {
        $cache =~ s/^c// or return $c->no_match;
        $c->{cache_size} = $cache;
    }

    for (@rest) {
        /^ser(\w{11})$/  and do { $c->{serial_number} = $1;      next };
        /^(T[CDBJ])$/    and do { $c->{status}        = $1;      next };
        /^s(\d+)$/       and do { $c->{bandwidth}     = $1;      next };
        /^W(\d+)H(\d+)$/ and do { $c->{display_bytes} = "$1*$2"; next; };
    }
}

sub _parse_foma {
    my ( $self, $c, $foma ) = @_;

    $foma =~ s/^([^\(]+)// or return $c->no_match;
    $c->{model} = $1;
    $c->{model} = 'SH2101V' if $1 eq 'MST_v_SH2101V';    # Huh?

    $foma =~ /^\(/g or return;
    while ($foma =~ /\G
        (?:
            c(\d+)      | # cache size
            ser(\w{15}) | # serial_number
            icc(\w{20}) | # card_id
            (T[CDBJ])   | # status
            W(\d+)H(\d+)  # display_bytes
        )
        [;\)]/gx)
    {
        $1         and $c->{cache_size}    = $1, next;
        $2         and $c->{serial_number} = $2, next;
        $3         and $c->{card_id}       = $3, next;
        $4         and $c->{status}        = $4, next;
        ($5 && $6) and $c->{display_bytes} = "$5*$6", next;
        $c->no_match;
    }
}

1;
