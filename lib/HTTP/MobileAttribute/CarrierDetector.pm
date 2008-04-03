package HTTP::MobileAttribute::CarrierDetector;
use strict;
use warnings;

# Dynamically generate it!
BEGIN
{
    # this matching should be robust enough
    # detailed analysis is done in subclass's parse()
    my $DoCoMoRE = '^DoCoMo\/\d\.\d[ \/]';
    my $JPhoneRE = '^(?i:J-PHONE\/\d\.\d)';
    my $VodafoneRE = '^Vodafone\/\d\.\d';
    my $VodafoneMotRE = '^MOT-';
    my $SoftBankRE = '^SoftBank\/\d\.\d';
    my $SoftBankCrawlerRE = '^Nokia[^\/]+\/\d\.\d';
    my $EZwebRE  = '^(?:KDDI-[A-Z]+\d+[A-Z]? )?UP\.Browser\\/';
    my $AirHRE = '^Mozilla\/3\.0\((?:WILLCOM|DDIPOCKET)\;';

    # We use a list instead of a hash here, because the order matters.
    # we check from the most likely to least likely
    my @map = (
        DoCoMo     => [ $DoCoMoRE ],
        ThirdForce => [ $JPhoneRE, $VodafoneRE, $VodafoneMotRE, $SoftBankRE, $SoftBankCrawlerRE ],
        EZweb      => [ $EZwebRE ],
        AirHPhone  => [ $AirHRE ]
    );

    my $code = <<EOM;
sub detect {
    my \$user_agent = shift;
EOM
    my $not_first = 0;
    while (@map) {
        my ($key, $re_list) = (shift @map, shift @map);
        my $re = join('|', @$re_list);
        $code .= sprintf( <<EOM, $not_first++ ? '} elsif' : 'if', $key);
    %s (\$user_agent =~ /$re/) {
        return '%s';
EOM
    }

    $code .= <<EOM;
    }
    return 'NonMobile';
}
EOM

    eval $code;
    die "$@\n$code" if $@;
}
        
1;
__END__

=encoding UTF-8

=head1 NAME

HTTP::MobileAttribute::CarrierDetecter - キャリヤ判別ルーチン

=head1 SYNOPSIS

    use HTTP::MobileAttribute::CarrierDetecter;

    HTTP::MobileAttribute::CarrierDetecter::detect('DoCoMo/1.0/NM502i'); # => DoCoMo

=head1 DESCRIPTION

User-Agent 文字列からケータイキャリヤを判別するよ。

=head1 AUTHOR

Tokuhiro Matsuno
