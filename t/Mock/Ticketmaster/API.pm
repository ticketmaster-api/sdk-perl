package Mock::Ticketmaster::API;

use strict;
use warnings;

use Storable;
use Test::Mock::Simple;

my $mock = Test::Mock::Simple->new( module => 'Ticketmaster::API', allow_new_methods => 1);

# Requires: mode, path_template (sprintf string), parameters (hash ref)
$mock->add( get_data => sub {
    my $self = shift;
    my %args = @_;

    my $mode = $args{mode} || Carp::croak("No mode provided (GET)");
    my $path_template = $args{path_template} || Carp::croak("No URI template provided");
    my %parameters = exists $args{parameters} ? %{$args{parameters}} : ();

    my $uri .= sprintf($path_template, $self->version());

    $uri .= '?apikey=' . $self->api_key();

    foreach my $key (sort {$a cmp $b} keys %parameters) {
        $uri .= '&' . $key . '=' . $parameters{$key};
    }

    $uri =~ s/[?&\/=]/_/g;

    my $mock_file_name = 't/recordings/' . $mode . '_' . $uri;

    my $ret = retrieve($mock_file_name);

    return $ret;
});

1;
