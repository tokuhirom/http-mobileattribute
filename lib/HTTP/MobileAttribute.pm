package HTTP::MobileAttribute;
use strict;
use warnings;
our $VERSION = '0.01';

use Class::Component;
use HTTP::MobileAttribute::Agent::NonMobile;
use HTTP::MobileAttribute::Request;
use HTTP::MobileAttribute::CarrierDetecter;

__PACKAGE__->load_components(qw/Autocall::SingletonMethod/);

sub new {
    my ($class, $stuff) = @_;

    my $request = HTTP::MobileAttribute::Request->new($stuff);
    my $carrier_long_name = HTTP::MobileAttribute::CarrierDetecter->detect($request->get('User-Agent'));
    my $self = $class->NEXT(
        'new' => +{
            request => $request,
            carrier_long_name => $carrier_long_name,
        }
    );
    return $self;
}

for my $accessor (qw/request carrier_long_name/) {
    no strict 'refs';
    *{$accessor} = sub { shift->{$accessor} };
}
sub user_agent { shift->request->get('User-Agent') }

1;
__END__

=for stopwords aaaatttt gmail dotottto commmmm Kazuhiro Osawa Plaggable

=head1 NAME

HTTP::MobileAttribute - Yet Another HTTP::MobileAgent

=head1 SYNOPSIS

  use HTTP::MobileAttribute;

  HTTP::MobileAttribute->load_plugins(qw/Flash Image CarrierName/);

  my $agent = HTTP::MobileAttribute->new;
  $agent->is_supported_flash();
  $agent->is_supported_gif();

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
