package HTTP::MobileAttribute::Plugin::Core;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub new {
    my ($class, $config, $c) = @_;
    my $self = $class->SUPER::new($config, $c);
    $c->load_plugins(map({ "Parser::$_" } qw/DoCoMo ThirdForce EZweb NonMobile AirHPhone/));
    $self;
}

1;
