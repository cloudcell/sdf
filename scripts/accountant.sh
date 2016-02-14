#!/bin/bash
# HEADER {{{
#
# Author: cloudcell (c) 2014,2015
#
# Project: Scripted Distributed Factory
# Description: SDF accountant script 
# 
#set -x
#}}}                                    

###############################################################################
# Interface (inputs & outputs defined here):
#---------------------------------------------------------------{{{

#-------------------------------------------------------------------------------
#### Inputs:
#INITIAL_SYSTEM_STARTUP_TIME=1 ;
#PROPOSAL_PROCESSING_WAITING_TIME=1 ;
text_color=32 ; # used by this script

source ./utils/functions.sh

# the next one must be run if a worker is started on its own, 
# independently from the management script
source ./scripts/folders.sh
              
#-------------------------------------------------------------------------------
# Outputs:

# }}}

###############################################################################
# Implementation (should be of no concern to the user):
#---------------------------------------------------------------{{{

# Local functions {{{
#}}}

#-------------------------------------------------------------------------------
# --->>> Script entry point --->>>
#-------------------------------------------------------------------------------


echo "The funny games are over. Here comes the accountant..."



while [ 1 ]
do
        
    # report queue length {{{

    #}}}    
        
    # check whether he can leave {{{

    #}}}    
        
done

#}}}



