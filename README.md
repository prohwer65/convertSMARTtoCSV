# convertSMARTtoCSV
Perl program to convert SMART SATA files into a CSV format for easier review

Converts a list of text files that hold SMART data into one Comma Seperated Value (CSV) 
for easy importing into Excel or Excel-like program for better analysis. 

Usage: `convertSmartToCSV.pl   (smart text files)     > smartTables.csv`

then `smartTables.csv` can be used by any spreadsheet program like Excel or gnumeric. 


# Example 1:
  `smartctl -a /dev/sda > before_smart.txt`

something happens

  `smartctl -a /dev/sda > after_smart.txt`
  `convertSmartToCSV.pl before_smart.txt  after_smart.txt  > compareSmart.csv`
  
  `gnumeric compareSmart.csv`


# Example 2:
  gather multiple SMART outputs from multple hosts to compare results. 

  `convertSmartToCSV.pl  smart?.txt  > compareSmart.csv`
  
  `gnumeric compareSmart.csv`

