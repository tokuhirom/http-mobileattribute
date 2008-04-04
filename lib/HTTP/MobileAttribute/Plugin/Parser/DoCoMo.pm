package HTTP::MobileAttribute::Plugin::Parser::DoCoMo;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

__PACKAGE__->accessors('DoCoMo' => [qw/version model status bandwidth serial_number is_foma card_id comment name/]);

sub parse :CarrierMethod('DoCoMo') {
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
