package HTTP::MobileAttribute::Plugin::Default::ThirdForce;
use strict;
use warnings;
use base qw/HTTP::MobileAttribute::Plugin/;

sub initialize : Hook('initialize_ThirdForce') {
    my ($self, $c) = @_;

    $self->mk_register_accessors( ThirdForce => qw(name version model type packet_compliant serial_number vendor vendor_version java_info));
    $self->{user_agent} = $c->user_agent;
    $self->parse($c);
}

sub is_type_c   :CarrierMethod('ThirdForce') { shift->{type} =~ /^C/ }
sub is_type_p   :CarrierMethod('ThirdForce') { shift->{type} =~ /^P/ }
sub is_type_w   :CarrierMethod('ThirdForce') { shift->{type} =~ /^W/ }
sub is_type_3gc :CarrierMethod('ThirdForce') { shift->{type} eq '3GC' }

sub xhtml_compliant :CarrierMethod('ThirdForce') {
    my $self = shift;
    return ( $self->is_type_w || $self->is_type_3gc ) ? 1 : 0;
}

sub user_agent { shift->{user_agent} }

sub parse {
    my ($self, $c) = @_;

    return $self->_parse_3gc if($self->user_agent =~ /^Vodafone/);
    return $self->_parse_softbank_3gc if($self->user_agent =~ /^SoftBank/);
    return $self->_parse_motorola_3gc($c) if($self->user_agent =~ /^MOT-/);
    return $self->_parse_crawler if($self->user_agent =~ /^Nokia/); # ad hoc

    my($main, @rest) = split / /, _subtract_ua($self->user_agent);

    if (@rest) {
        # J-PHONE/4.0/J-SH51/SNJSHA3029293 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
        $self->{packet_compliant} = 1;
        @{$self}{qw(name version model serial_number)} = split m!/!, $main;
        if ($self->{serial_number}) {
            $self->{serial_number} =~ s/^SN// or return $self->no_match;
        }

        my $vendor = shift @rest;
        @{$self}{qw(vendor vendor_version)} = split m!/!, $vendor;

        my %java_info = map split(m!/!), @rest;
        $self->{java_info} = \%java_info;
    } else {
        # J-PHONE/2.0/J-DN02
        @{$self}{qw(name version model)} = split m!/!, $main;
        $self->{name} = 'J-PHONE' if $self->{name} eq 'J-Phone'; # for J-Phone/5.0/J-SH03 (YahooSeeker)
        $self->{vendor} = ($self->{model} =~ /J-([A-Z]+)/)[0] if $self->{model};
    }

    if ($self->version =~ /^2\./) {
        $self->{type} = 'C2';
    } elsif ($self->version =~ /^3\./) {
        if ($c->request->get('x-jphone-java')) {
            $self->{type} = 'C4';
        } else {
            $self->{type} = 'C3';
        }
    } elsif ($self->version =~ /^4\./) {
        my($jscl_ver) = ($self->{java_info}->{'Ext-Profile'} =~ /JSCL-(\d.+)/);

        if ($jscl_ver =~ /^1\.1\./) {
            $self->{type} = 'P4';
        } elsif ($jscl_ver eq '1.2.1') {
            $self->{type} = 'P5';
        } elsif ($jscl_ver eq '1.2.2') {
            $self->{type} = 'P6';
        } else {
            $self->{type} = 'P7';
        }
    } elsif ($self->version =~ /^5\./) {
        $self->{type} = 'W';
    }
}

# for 3gc
sub _parse_3gc {
    my $self = shift;

    # Vodafone/1.0/V802SE/SEJ001 Browser/SEMC-Browser/4.1 Profile/MIDP-2.0 Configuration/CLDC-1.1
    # Vodafone/1.0/V702NK/NKJ001 Series60/2.6 Profile/MIDP-2.0 Configuration/CLDC-1.1
    # SoftBank/1.0/910T/TJ001 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1
    my($main, @rest) = split / /, $self->user_agent;
    $self->{packet_compliant} = 1;
    $self->{type} = '3GC';

    @{$self}{qw(name version model _maker serial_number)} = split m!/!, $main;
    if ($self->{serial_number}) {
        $self->{serial_number} =~ s/^SN// or return $self->no_match;
    }

    my($java_info) = $self->user_agent =~ /(Profile.*)$/;
    my %java_info = map split(m!/!), split / /,$java_info;
    $self->{java_info} = \%java_info;
}

# for softbank 3gc
*_parse_softbank_3gc = \&_parse_3gc;

# for motorola 3gc
sub _parse_motorola_3gc{
    my ($self, $c) = @_;
    my($main, @rest) = split / /, $self->user_agent;

    #MOT-V980/80.2B.04I MIB/2.2.1 Profile/MIDP-2.0 Configuration/CLDC-1.1

    $self->{packet_compliant} = 1;
    $self->{type} = '3GC';

    @{$self}{qw(name)} = split m!/!, $main;

    shift @rest;
    my %java_info = map split(m!/!), @rest;
    $self->{java_info} = \%java_info;

    $self->{model} = 'V702MO'  if $self->{name} eq 'MOT-V980';
    $self->{model} = 'V702sMO' if $self->{name} eq 'MOT-C980';
    $self->{model} ||= $self->get_header('x-jphone-msname');
}

# for crawler
sub _parse_crawler {
    my $self = shift;
    my($main, @rest) = split / /, _subtract_ua($self->user_agent);

    # Nokia6820/2.0 (4.83) Profile/MIDP-1.0 Configuration/CLDC-1.0
    @{$self}{qw(model)} = split m!/!, $main;
    $self->{name} = 'Vodafone';
    $self->{type} = '3GC';

    shift @rest;
    my %java_info = map split(m!/!), @rest;
    $self->{java_info} = \%java_info;
}

sub _subtract_ua {
    my $user_agent = shift;
    $user_agent =~ s/\s*\(compatible\s*[^\)]+\)//i;
    return $user_agent;
}

'please release ridge!!';
