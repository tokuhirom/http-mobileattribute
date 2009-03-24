#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use WWW::MobileCarrierJP::DoCoMo::Display;
use YAML;

print dump_it();

sub dump_it {
    my $dat = WWW::MobileCarrierJP::DoCoMo::Display->scrape;
    my %map;
    for my $phone (@$dat) {
        $map{ uc $phone->{model} } = +{
            width  => $phone->{width},
            height => $phone->{height},
            color  => $phone->{is_color},
            depth  => $phone->{depth},
        };
    }
    YAML::Dump(\%map);
}

