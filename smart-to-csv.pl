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
#use FindBin qw{$Bin $Script $RealBin $RealScript $Dir $RealDir};

use lib qq/local.lib/;

my $VERSION        = '';

my $DOCUMENTATION = <<EOMESSAGE;
Please describe what this program does

Usage : $Script [-he [-w Z] [-d X] [-f N] 

    Options     : Descriptions
    --------      ------------------------------------------------------
    -h          : Help menu
    -e          : Enable something
    -d  drive   : Option with agrument
    -w  win     : Option with agrument
    --help      : Help Menu
    --version   : Version 

EOMESSAGE

use Getopt::Std;
use POSIX ":sys_wait_h";
use English '-no_match_vars';
    # see perlvar for variable names and features
    # no_match to reduce regx effiecency loss


#use File::stat;
#use File::Copy;
use Config;
use Data::Dumper;


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
sub passing_argu_3orless;
sub passing_argu_4ormore;
sub HELP_MESSAGE();
sub VERSION_MESSAGE();

sub parseSmartTable();
# ------------------------------------------------------------------------------
# global variables
# ------------------------------------------------------------------------------

my $OS;
my %cmdLineOption;
getopts( "hd:f:", \%cmdLineOption );
    #	<+INPUTOPTIONS+>

 # examples of direct associating
my @ARRAY = qw(0  2 3 4 5 6 7 8 9   17 19 20 21 23 25);
my %HASH  = ( somevalue => 'as', );

my $ref_ARRAY = [ qw(0  2 3 4 5 6 7 8 9   17 19 20 21 23 25)] ;
my $ref_HASH  = { somevalue => 'as', another => "value", };
# ------------------------------------------------------------------------------
# Database of values;
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# parse command line and setup defaults
# ------------------------------------------------------------------------------
if ( $Config{'osname'} =~ /Win/ ) {
    $OS = "Windows";
}

local $Data::Dumper::Sortkeys = 1;
local $Data::Dumper::Purity   = 1;  ##new to verify this

#print Data::Dumper->Dump( [ \%Config ], [qw(Config  )] );

if ( defined $cmdLineOption{h} ) {
    HELP_MESSAGE();
    exit(15);
}

#if ( defined $cmdLineOption{d} )  {
# something =   $cmdLineOption{d} ;
#	<+INPUTOPTIONS+>
#}

#if ( defined $cmdLineOption{f} )  {
# something =   $cmdLineOption{f} ;
#	<+INPUTOPTIONS+>
#}

# ------------------------------------------------------------------------------
#  MAIN part of program
# ------------------------------------------------------------------------------

#<+MAIN+>
my $time = localtime();
print "$time\n";


parseSmartTable( );

passing_argu_3orless( 1, 2, 3 );
my $runFunction = \&passing_argu_3orless;

&{ $runFunction }(4, 5, 6);
# or [\&passing_argu_3orless, 4, 5, 6 ]   # when passing a agru to another function like Tk's -command =>  


passing_argu_4ormore( { text => "test", cols => 20, centered => 1, } );

my $sc = returnScalar();
my $ar = returnArray();
my $ha = returnHash();

my $b = 0;
my $a = ref( \$b);

print "Return Scalar ". $a ." \n";
print "Return Array ". ref( $ar ) ." \n";
print "Return Hash ". ref( $ha ) ." \n";
print "Return Hash ". scalar( $ha ) ." \n";


#print Data::Dumper->Dump( [ \$time, \@ARRAY, \%cmdLineOption, \%HASH ], [qw(time   ARRAY    cmd_line_option    HASH )] );

exit 0;

# ------------------------------------------------------------------------------
# Define subroutines
#     <+SUB+>
# ------------------------------------------------------------------------------

sub passing_argu_3orless {

    # unpack input arguments
    my ( $first, $second, $third ) = @_;

    print "passing_argu_3orless()\n";
    print "First arg is $first, then $second, and $third\n";
}

sub passing_argu_4ormore() {

    # when passing in several input arguments, use a hash
    my ($in_argu_ref) = @_;

    print "passing_argu_4ormore()\n";
    if ( !defined $in_argu_ref->{junk} ) {
        # set an agrument to default value if not defined. 
        $in_argu_ref->{junk} = "JUNK";
    }

    foreach my $key (keys %$in_argu_ref) {
        print "$key -> $in_argu_ref->{$key}, ";
    }
    print "\n";

    #print " $in_argu_ref->{cols};\n";
    #print " $in_argu_ref->{centered};\n";
} # end of passing_argu_4ormore


sub returnScalar {
    my $a = 0;
    return \$a;
}

sub returnArray {
    my @a = qw/ 1 2 3/; 
    return \@a;
}

sub returnHash {
    my %a = ( 'a' => 'asdf');

    return \%a;
}

 #------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
sub HELP_MESSAGE() {

    print <<EOTEXT;
-----------------------------------------------------------------------------
$Script - TITLE
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

sub parseSmartTable() {



    my	$smartTable_file_name = '';		# input file name

    my %smartData;
    open  my $smartTable, '<', $smartTable_file_name
        or die  "$0 : failed to open  input file '$smartTable_file_name' : $!\n";

    while ( <$smartTable> )  {
        if ( $_ =~ /^Model Number:\s*(\S)/ ) { $smartData{modelNumber} = $1;}
        if ( $_ =~ /^Device Model:\s*(\S)/ ) { $smartData{modelNumber} = $1;}
        if ( $_ =~ /^Firmware Version:\s*(\S)/ ) { $smartData{firmwareVersion} = $1;}
        if ( $_ =~ /^Serial Number:\s*(\S)/ ) { $smartData{serialNumber} = $1;}
        if ( $_ =~ /^Total NVM Capacity:\s*(\S)/ ) { $smartData{capacity} = $1;}
        if ( $_ =~ /^Total NVM Capacity:\s*(\S)/ ) { $smartData{capacity} = $1;}

        if ( $_ =~ /^Critical Warning:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Temperature:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Available Spare:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Available Spare Threshold:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Percentage Used:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Data Units Read:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Data Units Written:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Host Read Commands:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Host Write Commands:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Controller Busy Time:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Power Cycles:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Power On Hours:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Unsafe Shutdowns:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Media and Data Integrity Errors:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Error Information Log Entries:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Warning  Comp. Temperature Time:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Critical Comp. Temperature Time:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Temperature Sensor 1:\s*(\S)/ ) { $smartData{zz} = $1;}
        if ( $_ =~ /^Temperature Sensor 2:\s*(\S)/ ) { $smartData{zz} = $1;}

    }
    
    
    close  $smartTable
        or warn "$0 : failed to close input file '$smartTable_file_name' : $!\n";

}
##################################################################
#                                                                #
#                                                                #
#                                                                #
##################################################################

# }}}1
# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround:set foldenable foldmethod=marker:
