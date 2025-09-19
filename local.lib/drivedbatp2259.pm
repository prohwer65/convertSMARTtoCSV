#
#===============================================================================
#
#         FILE: drivedb-atp-229.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Paul Rohwer (PWR), prohwer65@gmail.com
# ORGANIZATION: ATP Inc
#      VERSION: 1.0
#      CREATED: 09/19/2025 11:15:42 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
 
#package drivedb-atp-2259;

#use Moose;
#use Moose::Util::TypeConstraints;
#use Data::Dumper;
#local $Data::Dumper::Sortkeys = 1;
#local $Data::Dumper::Purity   = 1;  ##new to verify this

#use parent 'myParentOOP';

#has 'name'       => ( is => 'ro', isa => "Str" );

#my %ages = (
#    'John' => 30,
#    'Jane' => 25,
#    'Mike' => 40,
#);

my %drivedb = ( 
          "1"    => "Raw_Read_Err_Cnt",
          "5"    => "Reallocated_FBlk_Cnt",
          "9"    => "Power_On_Hours",
          "12"   => "Normal_Power_Cnt",
          "14"   => "Dev_Physical_Capacity",
          "15"   => "Dev_User_Capacity",
          "16"   => "Initial_Spare_blocks",
          "17"   => "Remaining_Spare_Blks",
          "100"  => "Total_Erase_Cnt",
          "160"  => "UNC_RW_Sector_Cnt",
          "172"  => "Total_Blk_Erase_Fail",
          "173"  => "Maximum_Erase_Cnt",
          "174"  => "Unexpected_Power_Loss",
          "175"  => "Average_Erase_Cnt",
          "181"  => "Total_Blk_Program_Fail",
          "187"  => "Reported_UNC_Err",
          "194"  => "Device_Temperature",
          "195"  => "Hardware_ECC_Recovered",
          "197"  => "Current_Pending_Blk_Cnt",
          "198"  => "Offline_Surface_Scan",
          "199"  => "SATA_FIS_CRC_Err",
          "202"  => "Drive_Life_Used(%)",
          "205"  => "Thermal_Asperity_Rate",
          "231"  => "Controller_Temperature",
          "234"  => "Total_NAND_Sectors_Rd",
          "235"  => "Total_HOST_Sectors_Wr",
          "241"  => "Total_NAND_Sectors_Wr",
          "242"  => "Total_HOST_Sectors_Rd",
          "248"  => "Remaining_Life(%)",
          "249"  => "Spare_Blk_Remaining",
        );


sub checkIDattr {
    my $id = shift; 
    my $name = shift; 

    #print "checking $id to $name\n";
    if ( $name =~ /unk/i) {
        #print $drivedb{ $id} . "\n"; 
        return $drivedb{ $id} ;
    }  else {
        #print $name. "\n";
        return $name;
    }
}

1;
##################################################################
#
#
#
##################################################################

# }}}1
# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround:set foldenable foldmethod=marker:


