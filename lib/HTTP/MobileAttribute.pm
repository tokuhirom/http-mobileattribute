package HTTP::MobileAttribute;
use strict;
use warnings;
our $VERSION = '0.01';

use Class::Component;
use HTTP::MobileAttribute::Agent::NonMobile;

__PACKAGE__->load_components(
    qw/
      CarrierDetect::AirHPhone
      CarrierDetect::EZWeb
      CarrierDetect::ThirdForce
      CarrierDetect::DoCoMo
      /
);

sub get_agent {
    my ($self, $stuff) = @_;

    my $agent = $self->NEXT('get_agent' => $stuff);

    if (ref($agent) =~ /^HTTP::MobileAttribute::Agent/) {
        return $agent;
    } else {
        return HTTP::MobileAttribute::Agent::NonMobile->new;
    }
}

1;
__END__

=for stopwords aaaatttt gmail dotottto commmmm Kazuhiro Osawa Plaggable

=head1 NAME

HTTP::MobileAttribute - Yet Another HTTP::MobileAgent

=head1 SYNOPSIS

  use HTTP::MobileAttribute;

=head1 WARNINGS

WE ARE NOW TESTING THE CONCEPT.

DO NOT USE THIS MODULE.

=head1 DESCRIPTION

HTTP::MobileAttribute is Plaggable version of HTTP::MobileAgent.

っていうか、まあ日本人しかつかわないだろうから日本語で docs かくね。

現時点では、とりあえずキャリヤ判定がデキルッポイ。

=head1 コンセプト

    - キャリヤ判別もプラグァーブル
    - トニカクぷらぐぁーぶる

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom aaaatttt gmail dotottto commmmmE<gt>

Kazuhiro Osawa

=head1 SEE ALSO

L<HTTP::MobileAgent>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
