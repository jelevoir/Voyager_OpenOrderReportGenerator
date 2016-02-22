#!/usr/bin/perl

########################################
#  Oakland University Kresge Library's #
#  Open Order Report Generator         #
########################################
#  .INP processor                      #
########################################
#  @author Josh LeVoir                 #
########################################

# Restricts unsafe code
use strict;
# Enables warnings
use warnings;

# Sets up directory search module
use File::Find;

# Sets working directory same as script and 
# allows for user to input their own directory
# when running from command line
my $dir = ".";
if (defined $ARGV[0]) {
    $dir = $ARGV[0];
}

# Searches for files within
# specified directory
find( \&change_file, $dir);

# Sub routine to change contents of file
sub change_file {


    # Checks if object is a regular file
    if (not -f $_) {
        return;
    }
    # Checks to make sure file is inp
    if (substr($_, -4) ne ".inp") {
        return;
    }
    
    # Asks for permission to process the file
    print "Do you want to process the file $_? (y to continue)\n";
    my $continue = <STDIN>;
    chomp($continue);
    if ($continue ne "y") {
        return;
    }

    # Asks user which ledgers they wanted
    print "\n\nWhat ledger did you want to search for?
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
    
    # Asks for the Fiscal Year
    print "\n\nEnter the Fiscal Year\n
Ex. FY11/12 or FY13/14\n
> FY";
    my $fiscalYear = "FY".<STDIN>;
    chomp($fiscalYear);
    if ($fiscalYear !~ /^FY[0-9]{2}\/[0-9]{2}$/) {
        return;
    }

    # Creates .inp file for storing data
    open (my $inpFile, '>>openorder.Acq.inp') or die "Could not create file!\nCheck folder permissions.";

    # Opens file and sets file handler
    if (open my $fh, $_) {
        local $/ = undef;
        while(<$fh>) {
            chomp;
            my @bigList = split('\n');
            for (my $x=0; $x<@bigList; $x++) {
                my $singleLine = $bigList[$x];
                my @shortList = split("\Q|\E", $singleLine);
                if (grep(/$fiscalYear/,@shortList)) {
                    foreach my $ledger (@ledgers) {
                        if ($ledger eq substr($shortList[6], 0, length($ledger)) && $shortList[16] ne "Received Complete" && $shortList[10] ne "Continuation") {
                            print $inpFile join("\|", @shortList);
                            print $inpFile "\n";
                        }
                    }
                }
            }
            # Closes .inp file
            close ($inpFile);

        }
    } else {
        warn "Could not open '$_' for reading\nCheck your permissions!\n";
        return;
    }
    return;
}
