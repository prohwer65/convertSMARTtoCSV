#!/usr/bin/perl
use lib qq/local.lib/;

use SMART;

my $smart = Disk::SMART->new('/dev/sda'); # Initialize for a specific drive

if ($smart) {
    my $status = $smart->get_status();
    print "Drive /dev/sda status: $status\n";

    my $attributes = $smart->get_attributes();
    foreach my $attr (sort keys %{$attributes}) {
        print "$attr: " . $attributes->{$attr}->{'value'} . "\n";
    }
} else {
    print "Could not initialize Disk::SMART for /dev/sda. Ensure smartctl is installed and the drive is accessible.\n";
}

