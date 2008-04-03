package HTTP::MobileAttribute::Request;
use strict;
use warnings;
use Carp;
use Class::Inspector;
use Scalar::Util qw/blessed/;

sub new {
    my ($class, $stuff) = @_;

    # This is the not-so-sexy approach that uses less code than the original
    my $impl_base = __PACKAGE__;
    my $impl_class;
    if (! $stuff || ! ref $stuff ) {
        # first, if $stuff is not defined or is not a reference...
        $impl_class = join("::", $impl_base, "Env");
    } elsif (blessed($stuff)) {
        # or, if it's blessed, check if they are of appropriate types
        foreach my $pkg qw(Apache HTTP::Headers) {
            if ($stuff->isa($pkg)) {
                $impl_class = join("::", $impl_base, $pkg);
                 # XXX Hack. Will only work for HTTPHeaders
                $impl_class =~ s/HTTP::Headers$/HTTPHeaders/;
                last;
            }
        }
    }

    if (! $impl_class) {
        croak "unknown request type: $stuff";
    }

    if (! Class::Inspector->loaded($impl_class)) {
        # Continuing on our not-so-sexy route, we do not use 
        # UNIVERSAL::require here.
        eval "require $impl_class"; ## no critic.
        croak if $@;
    }

    return bless {
        impl => $impl_class->new($stuff)
    }, $class;
}

sub get { shift->{impl}->get(@_) }

1;
