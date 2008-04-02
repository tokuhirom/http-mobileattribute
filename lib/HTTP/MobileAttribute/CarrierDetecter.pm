package HTTP::MobileAttribute::CarrierDetecter;
use strict;
use warnings;

# this matching should be robust enough
# detailed analysis is done in subclass's parse()
my $DoCoMoRE = '^DoCoMo/\d\.\d[ /]';
my $JPhoneRE = '^(?i:J-PHONE/\d\.\d)';
my $VodafoneRE = '^Vodafone/\d\.\d';
my $VodafoneMotRE = '^MOT-';
my $SoftBankRE = '^SoftBank/\d\.\d';
my $SoftBankCrawlerRE = '^Nokia[^/]+/\d\.\d';
my $EZwebRE  = '^(?:KDDI-[A-Z]+\d+[A-Z]? )?UP\.Browser\/';
my $AirHRE = '^Mozilla/3\.0\((?:WILLCOM|DDIPOCKET)\;';
our $MobileAgentRE = qr/(?:($DoCoMoRE)|($JPhoneRE|$VodafoneRE|$VodafoneMotRE|$SoftBankRE|$SoftBankCrawlerRE)|($EZwebRE)|($AirHRE))/;

sub detect {
    my ($class, $user_agent) = @_;

    return   ($user_agent =~ /$MobileAgentRE/)
                ? ($1 ? 'DoCoMo' : $2 ? 'ThirdForce' : $3 ? 'EZweb' : 'AirHPhone' )
                : 'NonMobile';
}

1;
__END__

=head1 NAME

HTTP::MobileAttribute::CarrierDetecter - キャリヤ判別ルーチン

=head1 SYNOPSIS

    use HTTP::MobileAttribute::CarrierDetecter;

    HTTP::MobileAttribute::CarrierDetecter->detect('DoCoMo/1.0/NM502i'); # => DoCoMo

=head1 DESCRIPTION

User-Agent 文字列からケータイキャリヤを判別するよ。

=head1 AUTHOR

Tokuhiro Matsuno
