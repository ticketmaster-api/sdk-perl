#!perl

use 5.006;

use strict;
use warnings;
use lib 't/';

use Test::More tests => 16;

BEGIN {
    use_ok( 'Mock::Ticketmaster::API' ) || print "Bail out!\n";
    use_ok( 'Ticketmaster::API::Discovery' ) || print "Bail out!\n";
}

my $api_key  = 'testAPIkey';

my $obj = Ticketmaster::API::Discovery->new(api_key => $api_key);

my $res = $obj->search_events();
my $event_id = $res->{_embedded}{events}[0]{id};
ok($event_id, "Found event_id: $event_id");

$res = $obj->event_details(id => $event_id);
is($res->{id}, $event_id, 'Received event details');

$res = $obj->event_images(id => $event_id);
ok(@{$res->{images}}, 'Received event images');

$res = $obj->search_attractions();
my $attraction_id = $res->{_embedded}{attractions}[0]{id};
ok($attraction_id, "Found Attraction ID: $attraction_id");

$res = $obj->attraction_details(id => $attraction_id);
is($res->{id}, $attraction_id, 'Received Attraction Details');

$res = $obj->search_categories();
my $category_id = $res->{_embedded}{categories}[0]{id};
ok($category_id, "Found Category ID: $category_id");

$res = $obj->category_details(id => $category_id);
is($res->{id}, $category_id, 'Received Category Details');

$res = $obj->search_venues();
my $venue_id = $res->{_embedded}{venues}[0]{id};
ok($venue_id, "Found Venue ID: $venue_id");

$res = $obj->venue_details(id => $venue_id);
is($res->{id}, $venue_id, 'Received Venue Details');

# Exceptions
eval { $res = $obj->event_details; };
like($@, qr/^No event id provided/, 'No Event ID provided');

eval { $res = $obj->event_images; };
like($@, qr/^No event id provided/, 'No Event ID provided for images');

eval { $res = $obj->attraction_details; };
like($@, qr/^No attraction id provided/, 'No Attraction ID provided');

eval { $res = $obj->category_details; };
like($@, qr/^No category id provided/, 'No Category ID provided');

eval { $res = $obj->venue_details; };
like($@, qr/^No venue id provided/, 'No Venue ID provided');
