#!/strawberry/perl/bin/

########################################
#  Oakland University Kresge Library's #
#    Open Order Report Generator       #
########################################
#  .INP processor                      #
#  Converts Report to .XLS filetype    #
########################################
#  @author Josh LeVoir                 #
########################################


#######################
# Restricts unsafe code
use strict;
# Enables warnings
use warnings;

#################################
# Sets up directory search module
use File::Find;

##############################
# Sets up Excel export feature
use Spreadsheet::SimpleExcel;

# Sets up file name including current date for title
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$year = sprintf("%02d", $year % 100);
$mon += 1;
my $excelFileName = "Open Orders ".$mon."-".$mday."-".$year.".xls";

# Creates the spreadsheet and adds worksheet
my $excel = Spreadsheet::SimpleExcel->new();
$excel->add_worksheet('Open Order');
$excel->set_headers('Open Order',[qw/P.O. Vendor Type Title OrderProcess Ledger/]);

##########################################
# Sets working directory same as script
# and allows for user to input their own
# directory when running from command line
my $dir = ".";
if (defined $ARGV[0]) {
    $dir = $ARGV[0];
}

###########################
# Searches for files within
# specified directory
find( \&change_file, $dir);

#######################################
# Subroutine to change contents of file
sub change_file {

    # Checks if object is a regular file
    if (not -f $_) {
        return;
    }
    # Checks if object is an inp file
    if (substr($_, -4) ne ".inp") {
        return;
    }
    
    # Asks for permission to process the file
    system "cls";
    print "Do you want to process the file $_? (y to continue)\n";
    my $continue = <STDIN>;
    chomp($continue);
    if ($continue ne "y") {
        return;
    }
    
    # Asks user which ledgers they wanted
    system "cls";
    print "What ledger did you want to search for?
Can take multiple ledger names. Use commas to delimit them.
> ";
    my $allLedgers = <STDIN>;
    chomp($allLedgers);
    my @ledgers = split(",", $allLedgers);
    my $ledgerSize = @ledgers;
    if ($ledgerSize < 1) {
        print "No ledgers specified.";
        return;
    }
    
    # Asks user for Fiscal Year in 'YY/YY' format
    system "cls";
    print "Enter the Fiscal Year\n
Ex. FY11/12 or FY13/14\n
> FY";
    my $fiscalYear = "FY".<STDIN>;
    chomp($fiscalYear);
    if ($fiscalYear !~ /^FY[0-9]{2}\/[0-9]{2}$/) {
        return;
    }
    
    ##################################
    # Opens file and sets file handler
    if (open my $fh, $_) {
        local $/ = undef;
        while(<$fh>) {
            chomp;
            my @bigList = split('\n');
            for (my $x=0; $x<@bigList; $x++) {
                my $singleLine = $bigList[$x];
                my @shortList = split("\Q|\E", $singleLine);
                # The following splices remove elements:
                #  1,2,3,4,5,6,7,9,12,14,15,16,18,19,20,21
                splice @shortList, 0, 7;
                splice @shortList, 1, 1;
                splice @shortList, 3, 1;
                splice @shortList, 4, 3;
                splice @shortList, 5, 4;
                # Leaving behind elements:
                #  8,10,11,13,17,22
                # in @shortList
                if (grep(/$fiscalYear/,@shortList)) {
                    foreach my $ledger (@ledgers) {
                        if ($ledger eq substr($shortList[5], 0, length($ledger)) && $shortList[4] ne "Received Complete" && $shortList[2] ne "Continuation") {
                            $excel->add_row('Open Order', [@shortList]);
                        }
                    }
                }
            }
        }
    ##############################################
    # Catches and warns if file couldn't be opened
    } else {
        warn "Could not open '$_' for reading\nCheck to make sure you have read permissions for the file.\n";
        return;
    }
    ##############################
    # Outputs the data to xls file
    $excel->output_to_file($excelFileName) or die $excel->errstr();
    return;
}
