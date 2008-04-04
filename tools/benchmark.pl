use strict;
use warnings;
use lib 'lib';
use HTTP::MobileAgent;
use HTTP::MobileAttribute;
use Benchmark qw/cmpthese/; 

my $ua = 'DoCoMo/2.0 N2001(c10;ser350200000307969;icc8981100000200188565F)';

cmpthese(
    100000 => +{
        agent => sub {
            my $agent = HTTP::MobileAgent->new($ua);
        },
        attribute => sub {
            my $agent = HTTP::MobileAttribute->new($ua);
        },
    }
);
