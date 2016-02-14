#!/bin/bash

# AT THIS POINT, JOB DISPATCHER IS "PARKED"
# there's no need for this structure atm!

# HEADER {{{
#
# Author: cloudcell (c) 2014,2015
#
# Project: Scripted Distributed Factory/Filter
# Description: SDF job dispatcher script 
# 
#set -x       
#}}}      

## scrapped {{{
##########################################################################
# STRUCTURE GROWETH FROM MULTIPLE USAGE -- HACK FIRST -- STRUCTURE LATER #
##########################################################################


#
# This script contains a set of commands to be executed.
# To adjust the Distributed Factory to any particular needs, one may 
# wish to create a job template. Job templates shall be kept in the 
# folder $SDF_HOME/job_templates/
#
# here's an example (to be moved to templates)

# take some configuration file



# ATTN: signals are to be "moved" not "created" inside the destination folder
# find out how to pass signals 
#   1. between spedific processes
#   2. across computers
#   kill -l lists all the signals (as does the file /usr/include/asm/signal.h).
#-------------------------------------------------------------------------------
##  Table 15-1. Job identifiers (p210, book "Advanced Bash Scripting Guide 6.3")
##  Notation Meaning
##  %N Job number [N]
##  %S Invocation (command-line) of job begins with string S
##  %?S Invocation (command-line) of job contains within it string S
##  %% "current" job (last job stopped in foreground or started in background)
##  %+ "current" job (last job stopped in foreground or started in background)
##  %- Last job
##  $! Last background process
#-------------------------------------------------------------------------------
#    
#         

# declare global variable $TEMPLATE_ID (?)

# the routine is this:
# 1. pre dispatching
# 2. dispatch
# 3. waiting for completion
# 4. post-completion
#

# 1. pre dispatching {{{
## raw-job file (the files flowing in the /mant/ folder
## may have a set of data needed to do the job
## so job-dispatcher and raw-job files have to fit together
## in my case the main runner/node executable file takes a config file
## that contains all the necessary parameters for it to run
## but a job file shall contain [meta] tags
## one of the purposes of these [meta] tags / variables
## is to describe where to store the produced output
##
## so this template assumes the following bash command template
## app_name config_file > output_destination1
## post-processing commands: 
##   * additional filters > output_destination2 
##   * additional parsers > output_destination3
##   * additional commands > output_destinationN
##
## These [meta] commands must be preceeded by a hash/pound sign '#'
## so the app ignores them in the config file (after the whole job is appended 
## to a template config file 
## The lines in the job file with [meta] tags shall be filtered out
## and run as regular bash commands
## 
## Better yet, a job file should be split into sections
## with exact commands to be run by the dispatcher (at the right moment)
## So it may be sth. like the following:
##  

# [SECTION: SUCHANDSUCH]-------------
# appending the following to a config file
# but I would have to know the source & destination in advance...
#
# [SECTION: SUCHANDSUCH]-------------
# running the app

## Too contrived, simple is better:
# 1. get path of the general config template 
#    (to be specified here in the job-dispatcher not in folders)
# 2. append the damn thing (job_file) to config
# 3. feed the merged file to the app and direct the output to

# filter the lines marked by #[meta] into (job_file.sh)
# execute it as source
# the file is supposed to set 
OUTPUT_DESTINATION_RAW=""




#}}}

# 2. dispatch {{{

#}}}

# 3. waiting for completion {{{

#}}}

# 4. post-completion {{{

#}}}

#}}}

## scrapped {{{

################################################################################
# take 2:
################################################################################

# 1. unpack the job file: 

#}}}

################################################################################
# take 3:
################################################################################

# there is no need for a dispatcher
# a job script can simply be run

#temporary path import here FIXME: XXX: TODO: to be remmed!
#-------------------------------------------------------------------------------
#### Inputs:

### 
### #export PATH="/y/mingw/msys/1.0/bin/:/y/mingw/bin/:/y/mingw/include/:$PATH"
### export PATH="/y/mingw/msys/1.0/bin/:/y/mingw/bin/:/y/mingw/include/:/y/java/jre7/bin/"
### export PATH="/c/mingw/msys/1.0/bin/:/c/mingw/bin/:/c/mingw/include/:/c/java/jre7/bin/:$PATH"
### export PATH="/cygdrive/c/mingw/msys/1.0/bin/:/cygdrive/c/mingw/bin/:/cygdrive/c/mingw/include/:/cygdrive/c/java/jre7/bin/:$PATH"
### 
##  source ./scripts/folders.sh
##  source ./utils/functions.sh
##  SDF_HOME="."
##  WK_NAME=test                   
##  
##  if [[ ! -e $SDF_HOME/ops/$WK_NAME ]] ; then
##      echocl $text_color "Working directory does not exist... creating..."
##      mkdir $SDF_HOME/ops/$WK_NAME
##  fi

job_to_process=$1
job_to_process_source_dir=$MNF_IP

echo "$MY_WK_NAME copying production phase common template to worker's ops folder..."
# copy template to ops folder:
cp --remove-destination \
   $SDF_HOME/di/test_ext_vs_int.cfg \
   $SDF_HOME/ops/$MY_WK_NAME/test_ext_vs_int.cfg 
echo "$MY_WK_NAME: \$?=$?" 
   #exit 0 ;
echo "$MY_WK_NAME copying job to worker's ops folder..."
cp --remove-destination $MNF_IP/$job_to_process $SDF_HOME/ops/$MY_WK_NAME/
echo "$MY_WK_NAME: \$?=$?"

export jobpathedname=$SDF_HOME/ops/$MY_WK_NAME/$job_to_process

# run the job within the ops folder 
## $jobpathedname $jobpathedname ./ops/$MY_WK_NAME/test_ext_vs_int.cfg

#sed -n '/\x23\[node_config_begin]/,/\x23\[node_config_end]/p' $1 | tee -a $2

sed -n '/'\x23\[node_config_begin]'/,/'\x23\[node_config_end]'/p' $jobpathedname >> ./ops/$MY_WK_NAME/test_ext_vs_int.cfg

return ;   
        
