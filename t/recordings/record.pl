#!perl

use 5.006;

use strict;
use warnings;
use lib '../../lib/';

use Storable;

use Ticketmaster::API;

my $api_key  = 'testAPIkey';
my $mode = 'GET';
my $path_template = 'discovery/%s/events.json';
my %parameters = (
    marketId => 101
);

my $recording_name = 'GET_' . sprintf($path_template, 'v1') . "?apikey=$api_key";
foreach my $key (sort {$a cmp $b} keys %parameters) {
    $recording_name .= '_' . $key . '_' . $parameters{$key};
}
$recording_name =~ s/[=?&\/]/_/g;

die("record.pl needs to be run within the recordings directory") unless $0 eq 'record.pl';
die("recording already exists: $recording_name\n") if -e $recording_name;

my $obj = Ticketmaster::API->new(api_key => $api_key);
my $res = $obj->get_data(mode => $mode, path_template => $path_template);

store $res, $recording_name;

print "$recording_name populated\n";
