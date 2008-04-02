package HTTP::MobileAttribute::Agent::Base;
use strict;
use warnings;
use Class::Component;

sub user_agent {
    my ($self, ) = @_;

    $self->{request}->get('User-Agent');
}

1;
__END__

=head1 NAME

HTTP::MobileAttribute::Agent::Base - イワユルヒトツノアブストラクトベースクラッス

=head1 METHODS

=head2 user_agent

ゆーざーえーじぇんとをえるよ

=head1 AUTHOR

Tokuhiro Matsuno

=head1 SEE ALSO

L<HTTP::MobileAttribute>

