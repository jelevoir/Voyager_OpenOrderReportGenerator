# Open Order Report Generator
### A.K.A. INP Processor
This project is used when someone requests a Report of all Open Orders.

## Installation / Prerequisites
There is no installation needed to run these tools. 
If you are running Linux, distributions come packaged with Perl v5. 
If you are running Windows, there is a compiled version of this utility included in this package. (See Report\_Generator.exe)
> Note: 
> If you are going to run the uncompiled Windows version, you will need to make sure you have the following installed:
> > * Perl v5
> > * Spreadsheet::SimpleExcel
> If you are going to compile a windows version, you will need the following:
> > * PP (Perl Packager)
> If you are unsure about what Perl to install for Windows...
> I recommend [Strawberry Perl](http://strawberryperl.com/ "Strawberry Perl").

## Usage
There is currently a Windows and Linux version of this tool.
Simple Instructions:
* Run the utility.
* It will scan the current directory for any files with the extension .INP and ask to process it.
* Next it'll prompt for a comma-delimited list of ledger types you want to search the file for. 
> * (E.g.`New Programs,Serials,Online Resources`)
* Lastly, it will ask for the Fiscal Year you want to return.
> * (E.g. `FY13/14`)
* You will be given output in the form of a comma-delimited .INP file or .XLS spreadsheet.

## Additional Information
* This utility is licensed under [Creative Commons Attribution 4.0 International](http://creativecommons.org/license/by/4.0/ "CC BY 4.0")
* Simply put, you can use this however you want; but you must give credit for the original works.
