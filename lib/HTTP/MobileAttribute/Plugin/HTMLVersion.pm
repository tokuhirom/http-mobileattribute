package HTTP::MobileAttribute::Plugin::HTMLVersion;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

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

1;
