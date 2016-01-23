#!perl

use 5.006;

use strict;
use warnings;

#use Test::More tests => 8;
use Test::More 'no_plan';

BEGIN {
    use_ok( 'Ticketmaster::API' ) || print "Bail out!\n";
}

my $api_key  = 'hPpCKOv5DletchKf3sg3hdQDorR2EGdI';

my $obj = Ticketmaster::API->new(api_key => $api_key);

$obj->get_data(mode => 'GET', path_template => 'discovery/%s/events.json');


# Exceptions
eval { my $res = $obj->get_data(); };
like($@, qr/^No mode provided /, 'No mode provided');

eval { my $res = $obj->get_data(mode => 'GET'); };
like($@, qr/^No URI template provided /, 'No URI Template provided');
