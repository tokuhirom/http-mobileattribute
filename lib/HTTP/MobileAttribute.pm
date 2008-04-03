package HTTP::MobileAttribute;
use strict;
use warnings;
our $VERSION = '0.01';
use Class::Component;
use HTTP::MobileAttribute::Request;
use HTTP::MobileAttribute::CarrierDetecter;
use Scalar::Util qw/refaddr/;

__PACKAGE__->load_components(qw/Autocall::InjectMethod/);
__PACKAGE__->load_plugins(qw/
    Carrier IS GPS
    Default::DoCoMo Default::ThirdForce Default::EZweb Default::NonMobile Default::AirHPhone
/);

sub new {
    my ($class, $stuff) = @_;

    my $request = HTTP::MobileAttribute::Request->new($stuff);
    my $carrier_longname = HTTP::MobileAttribute::CarrierDetecter->detect($request->get('User-Agent'));
    my $self = $class->NEXT(
        'new' => +{
            request          => $request,
            carrier_longname => $carrier_longname,
        }
    );
    $self = bless {%$self}, "HTTP::MobileAttribute::Agent::$carrier_longname"; # rebless to carrier specific package.
    $self->run_hook('initialize');
    return $self;
}

for my $accessor (qw/request carrier_longname/) {
    no strict 'refs';
    *{$accessor} = sub { shift->{$accessor} };
}

sub user_agent { shift->request->get('User-Agent') }

package # hide from pause
    HTTP::MobileAttribute::Agent::DoCoMo;
use base qw/HTTP::MobileAttribute/;

package # hide from pause
    HTTP::MobileAttribute::Agent::EZweb;
use base qw/HTTP::MobileAttribute/;

package # hide from pause
    HTTP::MobileAttribute::Agent::ThirdForce;
use base qw/HTTP::MobileAttribute/;

package # hide from pause
    HTTP::MobileAttribute::Agent::AirHPhone;
use base qw/HTTP::MobileAttribute/;

package # hide from pause
    HTTP::MobileAttribute::Agent::NonMobile;
use base qw/HTTP::MobileAttribute/;

1;
__END__

=for stopwords aaaatttt gmail dotottto commmmm Kazuhiro Osawa Plaggable DoCoMo ThirdForce Vodafone docs

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
    - HTTP::MobileAgent とできるだけ互換性をもたす。かも。

=head1 非互換メモ

当たり前のことながら、$agent->isa はつかえないね。

carrier_longname が Vodafone じゃなくて ThirdForce を返すよ

=head2 廃止したメソッド

is_wap1, is_wap2. つかってないよね?

=head1 気になってること

=head2 メモリつかいすぎ疑惑

Singleton Method って遅くね?どうなんよ?

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom aaaatttt gmail dotottto commmmmE<gt>

Kazuhiro Osawa

=head1 THANKS TO

    Tatsuhiko Miyagawa(original author of HTTP::MobileAgent)
    Satoshi Tanimoto
    Yoshiki Kurihara(Current mentainer of HTTP::MobileAgent)

=head1 SEE ALSO

L<HTTP::MobileAgent>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
