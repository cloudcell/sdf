#!/bin/bash
# HEADER {{{
#
# Author: cloudcell (c) 2014, 2015
#
# Project: Scripted Distributed Factory
# Launcher Script
#
# Description: Launches SDF & Exits  
#
# Note: use jEdit with custom folding based on {{{ }}} tags to edit scripts
#}}}

# 
# Script sdf.sh
# ROADMAP {{{
# to create a single-script deployment - where a script unwraps itself
# and has an ability to delete itself
# 1. build a "factory" for unwrapping
#
# 2. give it a script (tcl?) so it assesses the # of computers available
# 3. distribute all the scripts across all the selected computers
# 4. launch the unwrapping
#    - java plugin can be UUCP/txt encoded
#    - binaries can be encoded as well
#
#
# }}}

# TODO - current manager(former'sdf') - to be moved to ./scripts folder
# TODO - this main script should periodically wake up the manager
#        for it to process any work
#      - alternatively, this script itself should check whether any job
#        has arrived and 
#        - introduce some kind of watcher service or 
#          transport service that moves the data and wakes the
#          manager up... still tbd.

# TODO: clean up the following comments:
# adds asdf.sh - launcher -- to be renamed to sdf when 
# the 'manager'(current name sdf.sh) is in place in the $SDF_HOME/scripts
# adds some reference 
# 
#

source ./scripts/folders.sh

# global setting:
# redirecting the standart error to the standard output: command 2>&1
# 2>&1

echo "param1= "$1

if [ $1 == "--standby" ] ; then
    export STANDBYMODE="TRUE"
else
    export STANDBYMODE="FALSE"
fi

echo "Standby mode = "$STANDBYMODE
sleep 1

# launch 'manager script' as source (to pick up the folders)
source $ac_manager



echo -e '\e[1;32m'"HELLO WORLD!"
exit 0 ;




