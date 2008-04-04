package HTTP::MobileAttribute;
use strict;
use warnings;
our $VERSION = '0.04';
use Class::Component;
use HTTP::MobileAttribute::Request;
use HTTP::MobileAttribute::CarrierDetector;

__PACKAGE__->load_components(qw/DisableDynamicPlugin Autocall::InjectMethod/);
# TODO: I want to remove IS::ThirdForce from default plugins.

# XXX: This really affects the first time H::MobileAttribute gets loaded
sub import
{
    my $class   = shift;
    my %args    = @_;
    my $plugins = delete $args{plugins} || [ 'Core' ];

    if (ref $plugins ne 'ARRAY') {
        $plugins = [ $plugins ];
    }
    $class->load_plugins(@$plugins);
}

our %CARRIER_CLASSES;
sub load_plugin {
    my $class = shift;
    %CARRIER_CLASSES = ();
    $class->SUPER::load_plugin(@_);
}

sub new {
    my ($class, $stuff) = @_;

    my $request = HTTP::MobileAttribute::Request->new($stuff);

    # XXX carrier name detection is actually simple, so instead of
    # going through the hassle of doing Detector->detect, we simply
    # create a function that does the right thing and use it
    my $carrier_longname = HTTP::MobileAttribute::CarrierDetector::detect($request->get('User-Agent'));

    my $carrier_class = $CARRIER_CLASSES{ $carrier_longname };
    if (! $carrier_class) {
        $carrier_class = $class->agent_class($carrier_longname);
        for my $type (qw/ components plugins methods hooks /) {
            my $method = "class_component_$type";
            $carrier_class->$method($class->$method);
        }
        $CARRIER_CLASSES{ $carrier_longname } = $carrier_class;
    }

    my $self = $carrier_class->SUPER::new({
        request          => $request,
        carrier_longname => $carrier_longname,
    });

    $self->create_accessors_delayed();
    $self->parse();

    return $self;
}

for my $accessor (qw/request carrier_longname/) {
    no strict 'refs';
    *{$accessor} = sub { shift->{$accessor} };
}

sub user_agent { shift->request->get('User-Agent') }

sub agent_class { 'HTTP::MobileAttribute::Agent::' . $_[1] }

my @delayed_accessors;

sub create_accessors_delayed {
    my ($self, ) = @_;

    while (my $accessor_info = pop @delayed_accessors) {
        for my $method (@{ $accessor_info->{accessors} }) {
            no strict 'refs';
            *{"$accessor_info->{package}::$method"} = sub { $_[1]->{$method} };
            $self->agent_class($accessor_info->{carrier})->register_method(
                $method => $accessor_info->{package}
            );
        }
    }
}

sub register_accessors_delayed {
    my ($self, $accessor_info) = @_;

    push @delayed_accessors, $accessor_info;
}

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

=encoding UTF-8

=for stopwords aaaatttt gmail dotottto commmmm Kazuhiro Osawa Plaggable DoCoMo ThirdForce Vodafone docs Daisuke Maki

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

可能な限り、HTTP::MobileAgent とメソッド名に互換性を持たせてある。
ただし、今時どうみてもつかわんだろうというようなものは削ってある。

具体的には

    EZweb: is_wap1, is_wap2, is_win, is_tuka
    DoCoMo->series, is_foma

のあたり。つかってないよね?使ってる人いたら、Plugin::IS::DoCoMo とかのあたりにつくればいいよ

あと、 DoCoMo の、たぶん当時はつかってたんだろうけど今はつかってないっぽいものも消してある(もともとつけられるからつけただけなのかもしらんけど)。

    vendor
    cache_size
    html_version

=head1 気になってること

=head2 メモリつかいすぎ疑惑

まあ、たしょうメモリはいっぱいつかうよね。

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom aaaatttt gmail dotottto commmmmE<gt>

Kazuhiro Osawa

Daisuke Maki

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
