use strict;
use warnings;
use lib 'lib';
use HTTP::MobileAttribute;

my $ua = 'DoCoMo/2.0 N2001(c10;ser350200000307969;icc8981100000200188565F)';

my $agent = HTTP::MobileAttribute->new($ua) for 1..10000;

