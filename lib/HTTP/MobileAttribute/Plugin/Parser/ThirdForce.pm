package HTTP::MobileAttribute::Plugin::Parser::ThirdForce;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

__PACKAGE__->accessors( 'ThirdForce' => [qw(name version model type packet_compliant serial_number vendor vendor_version java_info)] );

sub parse :CarrierMethod('ThirdForce') {
    my ($self, $c) = @_;

    my $user_agent = $c->user_agent;

    return $self->_parse_3gc($c)          if($user_agent =~ /^Vodafone/);
    return $self->_parse_softbank_3gc($c) if($user_agent =~ /^SoftBank/);
    return $self->_parse_motorola_3gc($c) if($user_agent =~ /^MOT-/);
    return $self->_parse_crawler($c)      if($user_agent =~ /^Nokia/); # ad hoc

    my($main, @rest) = split / /, _subtract_ua($user_agent);

    if (@rest) {
        # J-PHONE/4.0/J-SH51/SNJSHA3029293 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
        $c->{packet_compliant} = 1;
        @{$c}{qw(name version model serial_number)} = split m!/!, $main;
        if ($c->{serial_number}) {
            $c->{serial_number} =~ s/^SN// or return $c->no_match;
        }

        my $vendor = shift @rest;
        @{$c}{qw(vendor vendor_version)} = split m!/!, $vendor;

        my %java_info = map split(m!/!), @rest;
        $c->{java_info} = \%java_info;
    } else {
        # J-PHONE/2.0/J-DN02
        @{$c}{qw(name version model)} = split m!/!, $main;
        $c->{name} = 'J-PHONE' if $c->{name} eq 'J-Phone'; # for J-Phone/5.0/J-SH03 (YahooSeeker)
        $c->{vendor} = ($c->{model} =~ /J-([A-Z]+)/)[0] if $c->{model};
    }

    if ($c->version =~ /^2\./) {
        $c->{type} = 'C2';
    } elsif ($c->version =~ /^3\./) {
        if ($c->request->get('x-jphone-java')) {
            $c->{type} = 'C4';
        } else {
            $c->{type} = 'C3';
        }
    } elsif ($c->version =~ /^4\./) {
        my($jscl_ver) = ($c->{java_info}->{'Ext-Profile'} =~ /JSCL-(\d.+)/);

        if ($jscl_ver =~ /^1\.1\./) {
            $c->{type} = 'P4';
        } elsif ($jscl_ver eq '1.2.1') {
            $c->{type} = 'P5';
        } elsif ($jscl_ver eq '1.2.2') {
            $c->{type} = 'P6';
        } else {
            $c->{type} = 'P7';
        }
    } elsif ($c->version =~ /^5\./) {
        $c->{type} = 'W';
    }
}

# for 3gc
sub _parse_3gc {
    my ($self, $c) = @_;

    # Vodafone/1.0/V802SE/SEJ001 Browser/SEMC-Browser/4.1 Profile/MIDP-2.0 Configuration/CLDC-1.1
    # Vodafone/1.0/V702NK/NKJ001 Series60/2.6 Profile/MIDP-2.0 Configuration/CLDC-1.1
    # SoftBank/1.0/910T/TJ001 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1
    my($main, @rest) = split / /, $c->user_agent;
    $c->{packet_compliant} = 1;
    $c->{type} = '3GC';

    @{$c}{qw(name version model _maker serial_number)} = split m!/!, $main;
    if ($c->{serial_number}) {
        $c->{serial_number} =~ s/^SN// or return $c->no_match;
    }

    my($java_info) = $c->user_agent =~ /(Profile.*)$/;
    my %java_info = map split(m!/!), split / /,$java_info;
    $c->{java_info} = \%java_info;
}

# for softbank 3gc
*_parse_softbank_3gc = \&_parse_3gc;

# for motorola 3gc
sub _parse_motorola_3gc{
    my ($self, $c) = @_;

    my($main, @rest) = split / /, $c->user_agent;

    #MOT-V980/80.2B.04I MIB/2.2.1 Profile/MIDP-2.0 Configuration/CLDC-1.1

    $c->{packet_compliant} = 1;
    $c->{type} = '3GC';

    @{$c}{qw(name)} = split m!/!, $main;

    shift @rest;
    my %java_info = map split(m!/!), @rest;
    $c->{java_info} = \%java_info;

    $c->{model} = 'V702MO'  if $c->{name} eq 'MOT-V980';
    $c->{model} = 'V702sMO' if $c->{name} eq 'MOT-C980';
    $c->{model} ||= $c->request->get('x-jphone-msname');
}

# for crawler
sub _parse_crawler {
    my ($self, $c) = @_;

    my($main, @rest) = split / /, _subtract_ua($c->user_agent);

    # Nokia6820/2.0 (4.83) Profile/MIDP-1.0 Configuration/CLDC-1.0
    @{$c}{qw(model)} = split m!/!, $main;
    $c->{name} = 'Vodafone';
    $c->{type} = '3GC';

    shift @rest;
    my %java_info = map split(m!/!), @rest;
    $c->{java_info} = \%java_info;
}

sub _subtract_ua {
    my $user_agent = shift;
    $user_agent =~ s/\s*\(compatible\s*[^\)]+\)//i;
    return $user_agent;
}

'please release ridge!!';
