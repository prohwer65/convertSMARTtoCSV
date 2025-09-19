#!/usr/bin/env perl
#===============================================================================
#
#         FILE: drivedb-atp-2259.t
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Paul Rohwer (PWR), prohwer65@gmail.com
# ORGANIZATION: PowerAudio
#      VERSION: 1.0
#      CREATED: 09/19/2025 02:30:24 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use Test::More ;  # tests => 1;                      # last test to print
#use Data::Dumper;
#local $Data::Dumper::Sortkeys = 1;
#local $Data::Dumper::Purity   = 1;  ##new to verify this


use lib qw/local.lib/;
use lib qw/./;

use_ok( "drivedbatp2259");

#is($a, $expect, "description");

print "Checking for TEST\n";
checkID( "1", "TEST");

print "Checking for unk\n";
checkID( "1", "unk");

print "done\n";


done_testing();
##################################################################
#
#
#
##################################################################

# }}}1
# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround:set foldenable foldmethod=marker:


