#!/bin/bash
# HEADER {{{
#
# Author: cloudcell (c) 2014,2015
#
# Project: Scripted Distributed Factory
# Description: SDF "janitor" script
# 
#}}} 




# Local functions {{{
function cleanup() #{{{
{
      #  echoc 0 "" ;    
        
#         # delete any outstanding proposals 
#         if [ -f $WKF_AVPR/"any.~"$MY_WK_NAME ] ; then
#                 echo "$MY_WK_NAME: cleaning up an unaccepted proposal" ;
#                 rm $WKF_AVPR/"any.~"$MY_WK_NAME ;
#         fi
        
        # Removing temp files...
        #  rm ./tmp/$MY_WK_NAME.assigned
        echocl 0 "";
        
} #}}}                   

#}}}


# check all the folders
# dig up some garbage & report it for now:


source ./scripts/folders.sh
source ./utils/functions.sh
# source ./scripts/clear.sh

ACTOR_NAME="JANITOR1"

local text_color=36 ;

# wait until $WKF_IP is empty (until all the workers leave)

mainFolderIsEmpty=0 ;

# key folder status {{{
echocl $text_color ""
echocl $text_color "-------------------"
listFolderContents $WKF_IP
echocl $text_color "-------------------"
#}}}

#while [ "$mainFolderIsEmpty" != "1" ]
while [ "`folderIsEmpty $WKF_IP`" != "1" ]
do
 #       mainFolderIsEmpty=`folderIsEmpty $WKF_IP`
        echocl $text_color "[$ACTOR_NAME]: sleep a bit..." ;
        sleep 1 ;
done
       
echocl $text_color ""
echocl $text_color "[$ACTOR_NAME]: Starting garbage registration."


# available jobs                          == "proposals requested"
echocl $text_color ""
listFolderContents $MNF_AV

# proposals to perform the jobs available == "proposals taken"
echocl $text_color ""
listFolderContents $WKF_AVPR

#-------------------------------------------------------------------------------

# jobs submitted to workers               == 'specific work requested'
echocl $text_color ""
listFolderContents $MNF_IP   

              
# jobs confirmed by workers as taken on   == 'specific work taken'
echocl $text_color ""
listFolderContents $WKF_IP                 

#-------------------------------------------------------------------------------

# jobs done (scans the $WF_DONE folder)   == 'completion status requested'
echocl $text_color ""
listFolderContents $MNF_DN         

# jobs done                               == 'completion status provided'
echocl $text_color ""
listFolderContents $WKF_DN

#-------------------------------------------------------------------------------
##}}}

echocl $text_color ""       
listFolderContents "./tmp"

cleanup ;
exit 0 ;

## data folders {{{
# #-------------------------------------------------------------------------------
# 
# # raw data in
# export SDF_DATA_IN=$BASEF"zz_pipe_data_in"
# 
# # raw data out
# export SDF_DATA_OUT=$BASEF"zz_pipe_data_out"
# 
# #-------------------------------------------------------------------------------
##}}}

                                             
                                             
                                             





