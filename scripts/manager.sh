#!/bin/bash
# HEADER {{{
#
# Author: cloudcell (c) 2014,2015
#
# Project: Scripted Distributed Factory
# Description: The main script that works as a classical 'filter'
#              in a sense that it accepts jobs into an input folder 
#              and releases output in an output folder
#              the rest is of no concern to the user
#
# (for now) this script launches the system (to be changed)
#
# As the number of the network grows 'the 'script overhead cost' 
# becomes negligible
# 
#set -x
#}}}


###############################################################################
# Interface (inputs & outputs defined here):
#---------------------------------------------------------------{{{


#-------------------------------------------------------------------------------
#### Inputs:

source ./scripts/folders.sh


configfolder="./conf/"
#configfile="parserR_20141217_1219.cfg"
#configfile="parserR_20141217_1139.cfg"
#configfile="parserR_20141217_1139_ext.cfg"
#configfile="parserR_20141217_1139_ext2.cfg"
#configfile="parserR_20141217_1139_ext3.cfg"
#configfile="parserR_20141217_1139_ext4.cfg"   
configfile="parserR_20141217_1139_ext5.cfg"      # TODO: clean this mess up - this line might be unnecessary already
configfile2="parserR_20141217_1139_ext5_alt.cfg" # TODO: clean this mess up - this line might be unnecessary already

logfolder="./log/"
logfile="log6a.txt"
logfile2="log6b.txt"

MY_MGR_NAME="MGR1" ;
ACTOR_NAME=$MY_MGR_NAME ;
text_color=35 ;

WAITTIME_WORKERS_TO_PROPOSE=0 ;
workImitationTime=5 ;        

#-------------------------------------------------------------------------------
# Outputs:
                                
# }}}

###############################################################################
# Implementation (should be of no concern to the user):
#---------------------------------------------------------------{{{

# imported functions {{{

source ./utils/functions.sh
source ./utils/clear.sh

#}}}

# local functions {{{
                                                 
function processProposal() #{{{
{
    FILENAME=$1
    #${$1#~*}
    # extract the name of worker that made the proposal 
    
    #echo THE NAME: $FILENAME
    JB_NAME=${FILENAME%.~*} ; # cuts from the right, so * is in the right section
    WK_NAME=${FILENAME#*.~} ; # cuts from the left,  so * is in the left section
    
    
    # echo "$MY_MGR_NAME: job:[$JB_NAME]:worker:[$WK_NAME]" ;
    
    #-------------------------------------------------------------------------------
    #JB_NAME=dummyecho ; # this works!
    JB_NAME=`listFirstFile $MNF_AV`
    echocl $text_color "$MY_MGR_NAME: assigning job[$JB_NAME]->worker[$WK_NAME]..." ;
    #echo "Now the job is - job   : $JB_NAME"
    #-------------------------------------------------------------------------------
    
    # See "Advanced Bash Scripting Guide v6.3": "7.2. File test operators"
    # [ -f ... ] -> file is a regular file (not a directory or device file)
    if [ -f $MNF_AV/$JB_NAME ] ; then
        
        ## writing to file:
        tstampedAppendOrCrash $WKF_AVPR/$FILENAME "$MY_MGR_NAME: ACCEPTED PROPOSAL."
        
        
        # echo "$MY_MGR_NAME: ACCEPTED PROPOSAL [date/time]" >> $WKF_AVPR/$FILENAME
        # mv $WKF_AVPR/$FILENAME $WKF_AVPR/$FILENAME.tmp
        # mv $WKF_AVPR/$FILENAME.tmp $WKF_AVPR/$FILENAME
        # tstampedAppendOrCrash $WKF_AVPR/$FILENAME " - Please continue nice bookkeeping & logs in this file... "
        # echo " - please continue nice bookkeeping & logs in this file... " >> $WKF_AVPR/$FILENAME.tmp
        # mv $WKF_AVPR/$FILENAME $WKF_AVPR/$FILENAME.tmp
        # mv $WKF_AVPR/$FILENAME.tmp $WKF_AVPR/$FILENAME
        
        # create a new (more appropriate) name for the signed proposal
        FILENAME_SIGNED=$JB_NAME.~$WK_NAME
        
        # move the signed proposal (the new name) to the next "pile"
        mv $WKF_AVPR/$FILENAME $WKF_IP/$FILENAME_SIGNED
        echocl $text_color "$MY_MGR_NAME: Proposal [$FILENAME->$FILENAME_SIGNED] assigned." ;
        
        # finally, give the job to this worker: move MF_AV from to MF_IP 
        mv $MNF_AV/$JB_NAME $MNF_IP/$JB_NAME
        # approve & "sign" the proposal
    else
        echocl 31 "Assertion FAILED: We should never get in here!"
        echocl 31 "ERROR ERROR... THE HORROR, THE HORROR ! \('o')/"
        echocl 31 "...Elvis has left the building..."
        # delete the proposal
        # echo "File missing. Deleting proposal..." ;
        # rm $WKF_AVPR/$FILENAME
        # echo "Proposal [$FILENAME] deleted." ;
        exit 1 ;
    fi
    
    return ;

} #}}}

cleanup() #{{{
{
    echoc $text_color "$MY_MGR_NAME: letting janitor in..." ;
    source ./scripts/janitor.sh &
    
    # delete any files left in the tmp  folder
    #rm ./tmp/$MY_MGR_NAME.proposals
    
    # set color to default
    echoc 0 "" ;
}
#}}}

nocleanup() #{{{
{
    echoc $text_color "$MY_MGR_NAME: quitting..." ;
    if [ 1 == 0 ] ; then
        source ./scripts/janitor.sh &
    fi
    
    # delete any files left in the tmp  folder
    #rm ./tmp/$MY_MGR_NAME.proposals
    
    # set color to default
    echoc 0 "" ;
}
#}}}

#}}}

#-------------------------------------------------------------------------------
# --->>> Script entry point --->>>
#-------------------------------------------------------------------------------

TIMETOQUIT="FALSE"


# checks if there's anything to do at all {{{
# checkJobsAvailable $MY_MGR_NAME
#echocl "1;31" "FIXME: at this point, TIMETOQUIT VARIABLE MUST BE SET"
if [ `folderIsEmpty $MNF_AV` == "1" ] ; then
    NOJOBSINBUCKET="TRUE"
    echocl $text_color "$ACTOR_NAME: job bucket is empty."
else
    NOJOBSINBUCKET="FALSE"
    echocl $text_color "$ACTOR_NAME: job bucket has jobs."     
fi

if [ "$STANDBYMODE" == "TRUE" ] ; then
    echo "$ACTOR_NAME: Operating in standby mode."
fi

if [ "$NOJOBSINBUCKET" == "FALSE" ] || [ "$STANDBYMODE" == "TRUE" ] ; then
    TIMETOQUIT="FALSE" ;                
else
    TIMETOQUIT="TRUE" ;
    echocl $text_color "$ACTOR_NAME: bye."        
fi ;

#}}}


# launches workers {{{
if [ "$TIMETOQUIT" == "FALSE" ] ; then 
    ## XXX refactor & move into a new function        
    
    # launches workers {{{
    # (should / might be done externally, and not in this script)
    
    export  NUM_OF_CPU_CORES=0 ;
    searchstr="numberOfCores=" ;
    
    # No spaces b/n "=" and $ !!!
    returnvalue=$( ./utils/ncores/ncores.sh | grep $searchstr 2>&1 ) 
    NUM_OF_CPU_CORES=${returnvalue/$searchstr/}
    
    echocl $text_color NUM_OF_CPU_CORES=$NUM_OF_CPU_CORES
    
    RUNNING_WKRS_LIMIT=$NUM_OF_CPU_CORES ;
    if [[ 1 == 0 ]] ; then
        RUNNING_WKRS_LIMIT=1 ; #$NUM_OF_CPU_CORES ; 
    fi
    echocl $text_color "RUNNING_WKRS_LIMIT="$RUNNING_WKRS_LIMIT
    
    # FIXME introduce $BOX_NAME
    BOX_NAME="BBX"
    # seq $RUNNING_WKRS_LIMIT
    
    for wk_nbr in $( seq $RUNNING_WKRS_LIMIT )
    do
        echocl $text_color "Starting worker number $wk_nbr ..." ;
        WORKER_NAME=$BOX_NAME"_W"$wk_nbr"_"
        # the second argument is "time to imitate work"
        source ./scripts/worker.sh $WORKER_NAME $workImitationTime &
    done
    #}}}
    
    # waits a specified period of time for workers to come to their senses {{{
    timet=$WAITTIME_WORKERS_TO_PROPOSE
    while [ "$timet" -ne 0 ]
    do
        echoc  $text_color  $timet
        sleep 1 ;                       
        echoc  $text_color " . "
        (( timet-- )) ;
    done
    echocl $text_color ""
    #exit 0 ;
    
    #sleep $WAITTIME_WORKERS_TO_PROPOSE ;
    #}}}
    
fi ;
# }}}


# processes proposals {{{
#...............................................................................
## processing proposals:
## 0. Prepare list as FIFO queue (oldest first) // src: $WF_AVPR
## v-Loop Until the list is empty 
##     1) if  proposal is still relevant -- give workers what they want
##     2) if the oldest proposal is not relevant -- erase it
## ^-Loop Next

while [ "$TIMETOQUIT" == "FALSE" ] # {{{
do
    # no need to check here -- as we've just checked this condition 
    # right outside the loop! just at the start of this script !!!
    # quit if nothing to do
    ###### checkJobsAvailable $MY_MGR_NAME
    
    
    # process 1 'AVailable PRoposal' proposal if there are any {{{
    if [ `folderIsEmpty $WKF_AVPR` == "0" ] ; then
        
        # FIFO queue:
        proposalname=`getOldestFile $WKF_AVPR`
        # while read proposalname < ./tmp/$MY_MGR_NAME.proposals ; 
        # do
        #echo "Line # $ntotal : $proposalname" ;
        processProposal $proposalname ;
        # done
    else
        # if getOldestFile is used here, it will give an empty line 
        echocl $text_color "Incoming proposals bucket is empty. Waiting..."
    fi
    # }}}
    
    # excluded part {{{
    if [ 1 == 0 ] ; then
        # the main loop {{{
        
        # sorting in (-r) reverse order (oldest/longest-waiting first):
        #ls -1 -c $WKF_AVPR > ./tmp/$MY_MGR_NAME.proposals.tmp
        ls -r -1 $WKF_AVPR > ./tmp/$MY_MGR_NAME.proposals.tmp
        
        # flush the data!
        mv ./tmp/$MY_MGR_NAME.proposals.tmp ./tmp/$MY_MGR_NAME.proposals
        
        echocl $text_color "proposals made:"
        cat ./tmp/$MY_MGR_NAME.proposals
        
        while read proposalname < ./tmp/$MY_MGR_NAME.proposals ; 
        do
            #echo "Line # $ntotal : $proposalname" ;
            processProposal $proposalname ;
        done 
        
        # delete old proposals register for this "manager" 
        #  of the distributed filter (SDF) node
        rm ./tmp/$MY_MGR_NAME.proposals
        
        #}}}
    fi
    # }}}
    
    # update the variable NOJOBSINBUCKET {{{
    if [ `folderIsEmpty $MNF_AV` == "1" ] ; then
        NOJOBSINBUCKET="TRUE"
        echocl $text_color "$ACTOR_NAME: job bucket is empty."
    else
        NOJOBSINBUCKET="FALSE"
        echocl $text_color "$ACTOR_NAME: job bucket has jobs."        
    fi
    # }}}
    
    if [ "$STANDBYMODE" == "TRUE" ] ; then
        echo "$ACTOR_NAME: Operating in standby mode."
    fi
    
    # update the variable TIMETOQUIT {{{
    if [ "$NOJOBSINBUCKET" == "FALSE" ] || [ "$STANDBYMODE" == "TRUE" ] ; then
        echo -n "" ; # do nothing                
        TIMETOQUIT="FALSE" ;
    else
        TIMETOQUIT="TRUE" ;
        echocl $text_color "$ACTOR_NAME: bye."        
    fi ;
    # }}}

        
done #}}}
#...............................................................................
#}}}


# leaves politely {{{
nocleanup ;
return ;

echocl 31 "MANAGER MUST ALWAYS BE STARTED BY sdf.sh"
exit 1 ;

#}}}

#}}}



### junk waiting to be relocated {{{
{
    time $app $configfolder$configfile ;
    exitcode=$? ;
    echocl  $text_color "exit code = $exitcode" ;
} &> $logfolder$logfile &

{
    time $app $configfolder$configfile2 ;
    exitcode=$? ;
    echocl  $text_color "exit code = $exitcode" ;
} &> $logfolder$logfile2 &
#}}}


