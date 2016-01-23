#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Ticketmaster::API' ) || print "Bail out!\n";
}

diag( "Testing Ticketmaster::API $Ticketmaster::API::VERSION, Perl $], $^X" );
