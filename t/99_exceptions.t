#!perl

use 5.006;

use strict;
use warnings;

use Test::More tests => 2;

BEGIN {
    use_ok( 'Ticketmaster::API' ) || print "Bail out!\n";
}

eval { my $api = Ticketmaster::API->new(); };
like($@, qr/^No api_key provided/, 'No API Key provided');
