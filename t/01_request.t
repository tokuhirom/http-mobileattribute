use strict;
use warnings;
use Test::More tests => 9;

BEGIN { use_ok 'HTTP::MobileAttribute::Request' }

# various way to make request

my $ua = "Mozilla/1.0";

{
    my $req = HTTP::MobileAttribute::Request->new($ua);
    isa_ok $req->{impl}, 'HTTP::MobileAttribute::Request::Env';
    is $req->get('user_agent'), $ua;
}

{
    local $ENV{HTTP_USER_AGENT} = $ua;
    my $req = HTTP::MobileAttribute::Request->new($ua);
    isa_ok $req->{impl}, 'HTTP::MobileAttribute::Request::Env';
    is $req->get('user_agent'), $ua;
}

SKIP: {
    eval { require HTTP::Headers; };
    skip "no HTTP::Headers", 2 if $@;

    my $header = HTTP::Headers->new;
    $header->header('User-Agent' => $ua);

    my $req = HTTP::MobileAttribute::Request->new($header);
    isa_ok $req->{impl}, 'HTTP::MobileAttribute::Request::HTTPHeaders';
    is $req->get('user_agent'), $ua;
}

{
    # mock object
    package Apache;
    sub header_in {
        my($r, $header) = @_;
        return $r->{$header};
    }

    package main;
    my $r = bless { 'User-Agent' => $ua }, 'Apache';
    my $req = HTTP::MobileAttribute::Request->new($r);
    isa_ok $req->{impl}, 'HTTP::MobileAttribute::Request::Apache';
    is $req->get('User-Agent'), $ua;
}
