#!/usr/bin/env perl
#===============================================================================
#
#         FILE: smart-to-csv.pl
#
#        USAGE: ./smart-to-csv.pl
#
#  DESCRIPTION:
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Paul Rohwer (PWR), prohwer65@gmail.com
# ORGANIZATION:
#      VERSION: 1.0
#      CREATED: 09/02/2025 01:40:56 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use FindBin qw{$Script };
use lib qw/local.lib/;

#use FindBin qw{$Bin $Script $RealBin $RealScript $Dir $RealDir};
#use SMART;

my $VERSION = '';

my $DOCUMENTATION = <<EOMESSAGE;
Converts several smart tables into a Comma Seperated Values (CSV) format
which is easily imported in Excel like applications. 

It parses the files in sections:  header, SATA ID#, etc. 

Usage : $Script <filenames>

    Options     : Descriptions
    --------      ------------------------------------------------------
    -h          : Help menu
    --help      : Help Menu
    --version   : Version 


Example 1:
  smartctl -a /dev/sda > before_smart.txt

something happens

  smartctl -a /dev/sda > after_smart.txt
  convertSmartToCSV.pl before_smart.txt  after_smart.txt  > compareSmart.csv

Example 2:
# gather multiple SMART outputs from multple hosts to compare results. 
#
  convertSmartToCSV.pl  smart?.txt  > compareSmart.csv
 

EOMESSAGE

use Getopt::Std;
use POSIX ":sys_wait_h";
use English '-no_match_vars';

# see perlvar for variable names and features
# no_match to reduce regx effiecency loss

#use File::stat;
#use File::Copy;
use Config;
use Data::Dumper qw( Dumper);

#print Dumper( \@ARGV);

#use Readonly;
#Readonly my $PI => 3.14;

# ------------------------------------------------------------------------------
# BEGIN
# ------------------------------------------------------------------------------
#BEGIN {
#}

# ------------------------------------------------------------------------------
# INIT
# ------------------------------------------------------------------------------
#INIT {
#}

# ------------------------------------------------------------------------------
# END
# ------------------------------------------------------------------------------
#END {
#}

# ------------------------------------------------------------------------------
# CHECK
# ------------------------------------------------------------------------------
#CHECK {
#}

# ------------------------------------------------------------------------------
# declare sub  <+SUB+>
# ------------------------------------------------------------------------------
#sub passing_argu_3orless;
#sub passing_argu_4ormore;
sub HELP_MESSAGE();
sub VERSION_MESSAGE();

# ------------------------------------------------------------------------------
# global variables
# ------------------------------------------------------------------------------

my $DEBUG = 0;
my $OS;
my %cmdLineOption;
getopts( "hD:f:", \%cmdLineOption );
local $Data::Dumper::Sortkeys = 1;
local $Data::Dumper::Purity   = 1;    ##new to verify this

#my %regex_actions;

#$regex_actions{qr/error/} = sub { print "Error detected!\n"; };
#$regex_actions{qr/warning/} = sub { print "Warning encountered.\n"; };

#my $log_entry = "This is a log entry with an error.";

if ( defined $cmdLineOption{h} ) {
    HELP_MESSAGE();
    exit(15);
}

if ( defined $cmdLineOption{D} ) {
    $DEBUG = $cmdLineOption{D};
}

#if ( defined $cmdLineOption{f} )  {
# something =   $cmdLineOption{f} ;
#	<+INPUTOPTIONS+>
#}

# ------------------------------------------------------------------------------
#  MAIN part of program
# ------------------------------------------------------------------------------

my %smartValues;
my %smartHeader;
foreach my $filename (@ARGV) {
    if ( -e $filename ) {

        open my $fh, "<", $filename or die "Unable to open $filename $!";

        my $foundID = 0;

        while ( my $line = <$fh> ) {

            # search for line startin with ID# then start to prase
            if ( $foundID == 0 ) {

                if ( $line =~ /^Model Number:\s+(\b.*$)/ )       { $smartValues{$filename}{0}{modelNumber}     = $1; next; }
                if ( $line =~ /^Device Model:\s+(\b.*$)/ )       { $smartValues{$filename}{0}{modelNumber}     = $1; next; }
                if ( $line =~ /^Firmware Version:\s+(\b.*$)/ )   { $smartValues{$filename}{0}{firmwareVersion} = $1; next; }
                if ( $line =~ /^Serial Number:\s+(\b.*$)/ )      { $smartValues{$filename}{0}{serialNumber}    = $1; next; }
                if ( $line =~ /^Total NVM Capacity:\s+(\b.*$)/ ) { $smartValues{$filename}{0}{capacity}        = $1; next; }
                if ( $line =~ /^User Capacity:\s+(\b.*$)/ )      { $smartValues{$filename}{0}{capacity}        = $1; next; }
                if ( $line =~ /^ID#/ ) {
                    $foundID++;
                    if ($DEBUG) { print "Found ID starting to parse\n"; }
                    if ($DEBUG) { print "		$line"; }
                }
                next;
            }
            if ( $foundID == 1 ) {

                # Stop parsing when a line starting with SMART is found
                if ( $line =~ /^SMART/ ) {
                    $foundID++;
                    print "Found SMART stopping  parse\n" if ( $DEBUG);
                    next;
                }


                chomp $line;
                if ( $line =~ /(\w+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S)\s+(\d+)/ ) {
                    if ($DEBUG) { print "Parsing:  " . $line . "\n"; }
                    my $id = $1;

                    $smartValues{$filename}{$id}{attr}        = $2;
                    $smartValues{$filename}{$id}{flag}        = $3;
                    $smartValues{$filename}{$id}{value}       = $4;
                    $smartValues{$filename}{$id}{worst}       = $5;
                    $smartValues{$filename}{$id}{thresh}      = $6;
                    $smartValues{$filename}{$id}{type}        = $7;
                    $smartValues{$filename}{$id}{update}      = $8;
                    $smartValues{$filename}{$id}{when_failed} = $9;
                    $smartValues{$filename}{$id}{raw_value}   = $10;

                    if ($DEBUG) {
                        print $id . ":  ";
                        foreach my $key (qw/ attr type raw_value /) {
                            print uc($key) . ": " . $smartValues{$filename}{$id}{$key} . "; ";
                        }
                        print "\n";
                    }

                }
            }    # foundID ==1

        }    # while <>

        close $fh or warn "Unable to close $filename : $!";

    }    # if -e
}    # foreach filename

print Dumper( \%smartValues ) if ( $DEBUG);


outputHashtoCSV( \%smartValues );
exit 0;

# ------------------------------------------------------------------------------
# Define subroutines
#     <+SUB+>
# ------------------------------------------------------------------------------

sub parseSmartTable() {

    my $smartTable_file_name = '';    # input file name

    my %smartTable;

    open my $smartTable, '<', $smartTable_file_name
      or die "$0 : failed to open  input file '$smartTable_file_name' : $!\n";

    while (<$smartTable>) {
        if ( $_ =~ /^Model Number:\s+(\w+)/ )       { $smartTable{modelNumber}     = $1; }
        if ( $_ =~ /^Device Model:\s+(\w+)/ )       { $smartTable{modelNumber}     = $1; }
        if ( $_ =~ /^Firmware Version:\s+(\w+)/ )   { $smartTable{firmwareVersion} = $1; }
        if ( $_ =~ /^Serial Number:\s+(\w+)/ )      { $smartTable{serialNumber}    = $1; }
        if ( $_ =~ /^Total NVM Capacity:\s+(\w+)/ ) { $smartTable{capacity}        = $1; }

        if ( $_ =~ /^Critical Warning:\s+(\w+)/ )                { $smartTable{zz} = $1; }
        if ( $_ =~ /^Temperature:\s+(\w+)/ )                     { $smartTable{zz} = $1; }
        if ( $_ =~ /^Available Spare:\s+(\w+)/ )                 { $smartTable{zz} = $1; }
        if ( $_ =~ /^Available Spare Threshold:\s+(\w+)/ )       { $smartTable{zz} = $1; }
        if ( $_ =~ /^Percentage Used:\s+(\w+)/ )                 { $smartTable{zz} = $1; }
        if ( $_ =~ /^Data Units Read:\s+(\w+)/ )                 { $smartTable{zz} = $1; }
        if ( $_ =~ /^Data Units Written:\s+(\w+)/ )              { $smartTable{zz} = $1; }
        if ( $_ =~ /^Host Read Commands:\s+(\w+)/ )              { $smartTable{zz} = $1; }
        if ( $_ =~ /^Host Write Commands:\s+(\w+)/ )             { $smartTable{zz} = $1; }
        if ( $_ =~ /^Controller Busy Time:\s+(\w+)/ )            { $smartTable{zz} = $1; }
        if ( $_ =~ /^Power Cycles:\s+(\w+)/ )                    { $smartTable{zz} = $1; }
        if ( $_ =~ /^Power On Hours:\s+(\w+)/ )                  { $smartTable{zz} = $1; }
        if ( $_ =~ /^Unsafe Shutdowns:\s+(\w+)/ )                { $smartTable{zz} = $1; }
        if ( $_ =~ /^Media and Data Integrity Errors:\s+(\w+)/ ) { $smartTable{zz} = $1; }
        if ( $_ =~ /^Error Information Log Entries:\s+(\w+)/ )   { $smartTable{zz} = $1; }
        if ( $_ =~ /^Warning  Comp. Temperature Time:\s+(\w+)/ ) { $smartTable{zz} = $1; }
        if ( $_ =~ /^Critical Comp. Temperature Time:\s+(\w+)/ ) { $smartTable{zz} = $1; }
        if ( $_ =~ /^Temperature Sensor 1:\s+(\w+)/ )            { $smartTable{zz} = $1; }
        if ( $_ =~ /^Temperature Sensor 2:\s+(\w+)/ )            { $smartTable{zz} = $1; }

    }

    close $smartTable
      or warn "$0 : failed to close input file '$smartTable_file_name' : $!\n";

}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
sub outputHashtoCSV {
    my ($hash) = @_;

    my @headerValue = qw/capacity firmwareVersion modelNumber serialNumber/ ; 
    
    # print the id numbers
    foreach my $filename ( sort keys %$hash ) {
        print $filename . ", ";
        foreach my $id ( sort { $a <=> $b } keys %{ $hash->{$filename} } ) {
            if ( $id == 0 ) { 
                foreach my $key ( @headerValue ) {
                    print ", ";
                }
            } else {
                print "ID#" . $id . ", ";
            }
        }
        print "\n";

    #print the attr name
    #
    #print "ATTR\n";
        print $filename . ", ";
        foreach my $id ( sort { $a <=> $b } keys %{ $hash->{$filename} } ) {
            if ( $id == 0 ) { 
                foreach my $key ( @headerValue ) {
                    #my $str = $hash->{$filename}{$id}{$key} || $key."_undef";
                    print $key . ", ";
                }
            } else {
                print $hash->{$filename}{$id}{attr} . ", ";
            }
        }
        print "\n";

    #print the raw value
    #
    #print "RAW VALUES\n";
        print $filename . ", ";
        foreach my $id ( sort { $a <=> $b } keys %{ $hash->{$filename} } ) {
            if ( $id == 0 ) { 
                foreach my $key ( @headerValue ) {
                    my $str = $hash->{$filename}{$id}{$key} || $key."_undef";
                    $str =~ s/,//g;
                    print $str . ", ";
                }
            } else {
                print $hash->{$filename}{$id}{raw_value} . ", ";
            }
        }
        print "\n";
    }

}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
sub HELP_MESSAGE() {

    print <<EOTEXT;
-----------------------------------------------------------------------------
$Script - Convert SMART text files into Comma Seperated Values file. 
$DOCUMENTATION

$^X
EOTEXT
    exit(1);
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
sub VERSION_MESSAGE() {
    $Getopt::Std::STANDARD_HELP_VERSION = 1;

    # The above prevents this function from running exit();
    # but it causes a false warning, therefore I print it.
    print "$Script :  $VERSION $Getopt::Std::STANDARD_HELP_VERSION \n";
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

##################################################################
#                                                                #
#                                                                #
#                                                                #
##################################################################

# }}}1
# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround:set foldenable foldmethod=marker:
