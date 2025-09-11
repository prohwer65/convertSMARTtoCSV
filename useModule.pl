#!/usr/bin/perl
use lib qq/local.lib/;
#use strict;
use warnings;
use FindBin qw{$Script };
use Disk::SMART;
use Data::Dumper qw( Dumper) ;


my $disk = '/dev/sda';

# Create an object for a specific device.
my $smart = Disk::SMART->new('/dev/sda');
print Dumper( \$smart ) ; 

# Or, let the module auto-detect devices.
my $smart_auto = Disk::SMART->new();
my @disks = $smart_auto->get_disk_list();
print Dumper( \@disks);

# Get the overall health status.
my $health = $smart->get_disk_health('/dev/sda');
print "Device /dev/sda health: $health\n";

# Retrieve all S.M.A.R.T. attributes.
my $attributes = $smart->get_disk_attributes('/dev/sda');
print Dumper( $attributes);
if ($attributes) {
    foreach my $attr (@$attributes) {
        print "ID: $attr->{id}, Name: $attr->{name}, Value: $attr->{value}\n";
    }
}

# Run a self-test (e.g., a short one).
#my $result = $smart->run_test('short');
#print "Test result: $result\n";

# Get the latest self-test results.
#my $test_log = $smart->get_test_results();
#if ($test_log) {
#    print "Latest test result: $test_log->[0]->{status}\n";
#}

