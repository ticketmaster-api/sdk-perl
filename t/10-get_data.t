#!perl

use 5.006;

use strict;
use warnings;
use lib 't/';

use Test::More tests => 6;

BEGIN {
    use_ok( 'Mock::Ticketmaster::API' ) || print "Bail out!\n";
    #use_ok( 'Ticketmaster::API' ) || print "Bail out!\n";
}

my $api_key  = 'testAPIkey';

my $obj = Ticketmaster::API->new(api_key => $api_key);

my $res = $obj->get_data(mode => 'GET', path_template => 'discovery/%s/events.json');
ok(exists $res->{_embedded}, 'Got response');

my $market_id = $res->{_embedded}{events}[0]{_embedded}{venue}[0]{marketId}[0];
ok($market_id, "Found a market_id: $market_id");

$obj = Ticketmaster::API->new(api_key => $api_key, base_uri => 'https://app.ticketmaster.com/');
$res = $obj->get_data(mode => 'GET', path_template => 'discovery/%s/events.json', parameters => { marketId => $market_id });
is($res->{_embedded}{events}[0]{_embedded}{venue}[0]{marketId}[0], $market_id,
    "Response for the correct market");

# Exceptions
eval { my $res = $obj->get_data(); };
like($@, qr/^No mode provided /, 'No mode provided');

eval { my $res = $obj->get_data(mode => 'GET'); };
like($@, qr/^No URI template provided /, 'No URI Template provided');
