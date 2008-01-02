package HTTP::MobileAttribute::Component::CarrierDetect::ThirdForce;
use strict;
use warnings;
use HTTP::MobileAttribute::Agent::ThirdForce;

my $JPhoneRE = '^(?i:J-PHONE/\d\.\d)';
my $VodafoneRE = '^Vodafone/\d\.\d';
my $VodafoneMotRE = '^MOT-';
my $SoftBankRE = '^SoftBank/\d\.\d';
my $SoftBankCrawlerRE = '^Nokia[^/]+/\d\.\d';

our $RE = qr{(?:$JPhoneRE|$VodafoneRE|$VodafoneMotRE|$SoftBankRE|$SoftBankCrawlerRE)};

sub get_agent {
    my ($self, $stuff) = @_;

    if ($stuff =~ $RE) {
        return HTTP::MobileAttribute::Agent::ThirdForce->new;
    } else {
        return $self->NEXT('get_agent', $stuff);
    }
}

1;
