#!/bin/bash
# Author: cloudcell (c) 2015
# Description:
# This script generates a timestamp with millisecond accresolution
# Output format: yyyymmdd_hhmm_ss_mmm
# should be called via 'source'
# set -x

###############################################################################
# Interface (inputs & outputs defined here):
#------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Inputs:
dateprovider="/bin/date"
#dateprovider="/c/mingw/msys/1.0/bin/date.exe"
# dateprovider="/y/mingw/msys/1.0/bin/date.exe"
# y:\utils\gnudate\date.exe +%Y%m%d_%H%M_%S_%N # provides microsecond accuracy
scriptts=$0 ; #"timestamp.sh"

#-------------------------------------------------------------------------------
# Outputs:
ISODATETIME=""


###############################################################################
# Implementation (should be of no concern to the user):
#------------------------------------------------------------------------------

if [[ "$_DEBUG" = "TRUE" ]] ; then
    echo "--------------------------------------------------------------------------"
    echo "[inf] $scriptts(): Starting. Generating timestamp..." 
    echo "[inf] (this script should only be executed as 'source')"
    echo "[inf] so the variable remains available to the calling script"
fi


if ! [ -a  $dateprovider ] ; then
    echo "[inf] GNU date not found. Exiting."
    exit 1
else
    # all is ok
    #echo "Dateprovider exists. Proceeding..."
    #echo "Consider taking it from GnuUtils to get microsecond resolution..."
    if [[ "$_DEBUG" = "TRUE" ]] ; then echo "[inf] GNU date found." ; fi
fi

#date +%Y%m%d_%H%M_%S_%N > $the_line

line=$(date +%Y%m%d_%H%M_%S_%N)

# @echo Local date in raw format is [%the_line%]
#ldtmod=%the_line:~0,23%

#ldtmod=${line:0:23} -- microseconds
ldtmod=${line:0:20}


# @echo Local date in modified raw format is [%ldtmod%]
# @echo timestamp: [%ldtmod%]

ISODATETIME=$ldtmod

echo $ldtmod ;

if [[ "$_DEBUG" = "TRUE" ]] ; then
    echo [ $ldtmod ]
    echo "[inf] $scriptts(): Done. Timestamp generated. "
    echo "--------------------------------------------------------------------------"
fi

