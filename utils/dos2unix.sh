#!/bin/bash

awk '{ sub("\r$", ""); print }' $1 > $2.tmp
mv $2.tmp $2

exit 0 ;

# below is documentation
# Not Run:
src: http://www.softpanorama.org/Unixification/conversion_of_files_from_windows_to_unix_format.shtml




dos2unix and unix2dos

The utilities dos2unix and unix2dos are available for converting 
files from the Unix command line.

To convert a Windows file to a Unix file, enter:

dos2unix winfile.txt unixfile.txt
To convert a Unix file to Windows, enter:

unix2dos unixfile.txt winfile.txt
  

  
tr

You can use tr to remove all carriage returns and Ctrl-z (^Z) 
characters from a Windows file:

  tr -d '\15\32' < winfile.txt > unixfile.txt
However, you cannot use tr to convert a document from Unix format to Windows.


awk

To use awk to convert a Windows file to Unix, enter:

awk '{ sub("\r$", ""); print }' winfile.txt > unixfile.txt
To convert a Unix file to Windows, enter:

awk 'sub("$", "\r")' unixfile.txt > winfile.txt
Older versions of awk do not include the sub function. In such cases, use the 
same command, but replace awk with gawk or nawk.



Perl

To convert a Windows text file to a Unix text file using Perl, enter:

perl -p -e 's/\r$//' < winfile.txt > unixfile.txt
To convert from a Unix text file to a Windows text file, enter:

perl -p -e 's/\n/\r\n/' < unixfile.txt > winfile.txt
You must use single quotation marks in either command line. This prevents 
your shell from trying to evaluate anything inside.


vi

In vi, you can remove carriage return ( ^M ) characters with the following command:

  :1,$s/^M//g
Note: To input the ^M character, press Ctrl-v, and then press Enter or return.

In vim, use :set ff=unix to convert to Unix; use :set ff=dos to convert to Windows.

This document was developed with support from National Science Foundation (NSF) 
grant OCI-1053575. Any opinions, findings, and conclusions or recommendations 
expressed in this material are those of the author(s) and do not necessarily 
reflect the views of the NSF.




