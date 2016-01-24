package Ticketmaster::API;

use 5.006;
use strict;
use warnings;

use Carp;
use JSON::XS;
use LWP::UserAgent;

=head1 NAME

Ticketmaster::API - The great new Ticketmaster::API!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Ticketmaster::API;

    my $foo = Ticketmaster::API->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

sub new {
    my $self;
    my $package = shift;
    my $class = ref($package) || $package;

    $self = {@_};
    bless($self, $class);

    $self->base_uri('https://app.ticketmaster.com') unless $self->base_uri;
    $self->version('v1') unless $self->version;
    
    Carp::croak("No api_key provided") unless $self->api_key();

    return $self;
}

sub base_uri {
    my $self = shift;

    $self->{base_uri} = shift if @_;

    return $self->{base_uri};
}

sub version {
    my $self = shift;

    $self->{version} = shift if @_;

    return $self->{version};
}

sub api_key {
    my $self = shift;

    $self->{api_key} = shift if @_;

    return $self->{api_key};
}

# Requires: mode, path_template (sprintf string), parameters (hash ref)
sub get_data {
    my $self = shift;
    my %args = @_;

    my $mode = $args{mode} || Carp::croak("No mode provided (GET)");
    my $path_template = $args{path_template} || Carp::croak("No URI template provided");
    my %parameters = exists $args{parameters} ? %{$args{parameters}} : ();

    my $uri = $self->base_uri;
    $uri .= '/' unless $uri =~ /\/$/;
    $uri .= sprintf($path_template, $self->version());

    $uri .= '?apikey=' . $self->api_key();

    foreach my $key (keys %parameters) {
        $uri .= '&' . $key . '=' . $parameters{$key};
    }

    my $ua = LWP::UserAgent->new;

    my $req = HTTP::Request->new($mode => $uri);

    my $res = $ua->request($req);

    if ($res->is_success) {
        return decode_json($res->content);
    }
    else {
        Carp::croak("Error: " . $res->status_line);
    }
}

=head1 AUTHOR

Erik Tank, C<< <erik.tank at ticketmaster.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-ticketmaster-api at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Ticketmaster-API>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Ticketmaster::API


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Ticketmaster-API>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Ticketmaster-API>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Ticketmaster-API>

=item * Search CPAN

L<http://search.cpan.org/dist/Ticketmaster-API/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2016 Erik Tank.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Ticketmaster::API
