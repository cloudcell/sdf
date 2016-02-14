#!/bin/bash
# HEADER {{{
#
# Author: cloudcell (c) 2014,2015
#
# Project: Scripted Distributed Factory
# Description: SDF worker script 
# 
#set -x       
#}}}                                    


###############################################################################
# Interface (inputs & outputs defined here):
#---------------------------------------------------------------{{{

#-------------------------------------------------------------------------------
#### Inputs:
INITIAL_SYSTEM_STARTUP_TIME=1 ;
PROPOSAL_PROCESSING_WAITING_TIME=1 ;
text_color=32 ;
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
cleanup () #{{{
{
        echoc 0 "" ;    
        
        # delete any outstanding proposals             
#        if [ -f $WKF_AVPR/"any.~"$MY_WK_NAME ] ; then
#                echo "$MY_WK_NAME: cleaning up an unaccepted proposal" ;
#                rm $WKF_AVPR/"any.~"$MY_WK_NAME ;
#        fi
        
        # Removing temp files...
        #  rm ./tmp/$MY_WK_NAME.assigned
        echocl 0 "";
        
} #}}}                   

#}}}

export MY_WK_NAME=$1
TIMELIMIT=$2 ; # Imitate hard work :)

echocl $text_color "$MY_WK_NAME: hi"
sleep $INITIAL_SYSTEM_STARTUP_TIME ;

TIMETOQUIT="FALSE"
export ACTOR_NAME=$MY_WK_NAME ;       


# it's ok to use this function before applying for a job!
# but do not use it after a proposal has been submitted !
# the management may have just moved the assigned job to WIP folder
# and this function will quit on it erroneously
### checkJobsAvailable $MY_WK_NAME     

# updates NOJOBSINBUCKET variable {{{
if [ `folderIsEmpty $MNF_AV` == "1" ] ; then
    NOJOBSINBUCKET="TRUE"
    echocl $text_color "$ACTOR_NAME: job bucket is empty."
else
    NOJOBSINBUCKET="FALSE"
    echocl $text_color "$ACTOR_NAME: job bucket has jobs."        
fi
# }}}

# updates TIMETOQUIT variable {{{
if [ "$NOJOBSINBUCKET" == "FALSE" ] ; then
    TIMETOQUIT="FALSE" ;               
else
    TIMETOQUIT="TRUE" ;
    echocl $text_color "$ACTOR_NAME: bye."
    cleanup ;              
    exit 0 ;
    #########################################################################
    ###   ALTERNATIVE EXIT POINT                                          ###
    #########################################################################
fi ;              
# }}}
    
    
# work/ops folders should only be created if there are jobs to be done {{{
echocl $text_color $MY_WK_NAME": Preparing work directories"
echocl $text_color $MY_WK_NAME": Checking whether directory exists..."
if [[ ! -e $SDF_HOME/ops/$MY_WK_NAME ]] ; then
    echocl $text_color $MY_WK_NAME": Working directory does not exist... creating..."
    mkdir $SDF_HOME/ops/$MY_WK_NAME
else
    echocl $text_color $MY_WK_NAME": directory/file with the same name already exists."
    echocl $text_color $MY_WK_NAME": we're good to go."
fi              
#}}}                      
                  
        
       
# The main loop #{{{
while [ "$TIMETOQUIT" == "FALSE" ]
do
    # read all available jobs (sort newest first)
    echocl $text_color "$MY_WK_NAME: checking jobs folder..."
        
    # take the one with the latest date (the top one)            
             
    # create status file $JB_NAME.~$MY_WK_NAME in $WF_AVPR 
    
    #--- proposes its service --- {{{
    #        useless() #{{{ 
    #        {        
    #        ls -1 -c $MNF_AV > ./tmp/$MY_WK_NAME.avail.tmp
    #        mv ./tmp/$MY_WK_NAME.avail.tmp ./tmp/$MY_WK_NAME.avail 
    #        
    #        # check whether size is zero, i.e. whether there is nothing to do
    #        { read fname ; } < ./tmp/$MY_WK_NAME.avail
    #        if [ "$fname" == "" ] ; then
    #                echocl $text_color "$MY_WK_NAME: I see no jobs"
    #                echocl $text_color "$MY_WK_NAME: bye" ; 
    #                exit 0 ;
    #        fi
    #        
    #        # say that the most recent file "is MINE! my precious!!!"
    #        { read fname ; } < ./tmp/$MY_WK_NAME.avail
    #        echocl $text_color "__"$fname"__"
    #        }#}}}
    
    ### REFACTORED IT OUT OF THE LOOP
    ###  # it's ok to use this function before applying for a job!
    ###  # but do not use it after a proposal has been submitted !
    ###  # the management may have just moved the assigned job to WIP folder
    ###  # and this function will quit on it erroneously
    ###  checkJobsAvailable $MY_WK_NAME
    
    fname="any" ; # any job will do
    
    echo "-start-" > ./tmp/$fname.~$MY_WK_NAME.tmp
    mv ./tmp/$fname.~$MY_WK_NAME.tmp ./tmp/$fname.~$MY_WK_NAME      
    
    tstampedAppendOrCrash ./tmp/$fname.~$MY_WK_NAME "$MY_WK_NAME: PROPOSED."
    mv ./tmp/$fname.~$MY_WK_NAME $WKF_AVPR/$fname.~$MY_WK_NAME
    
    #echo "$MY_WK_NAME: PROPOSED [date/time]" > ./tmp/$fname.~$MY_WK_NAME
    # apply for the job by creating a file in the folder $WF_AVPR (available -- proposal)
                           
    #}}}
    
    #--- waits for the script-manager to process the proposal {{{ 
    # (request to get assigned some job)
    sleep $PROPOSAL_PROCESSING_WAITING_TIME ;
    #}}}
    
    #--- waiting / working cycle --- {{{       
    NOJOBSINBUCKET="FALSE"
    APPROVAL="FALSE"
    WAITFORAPPROVAL="TRUE"
    #echo "[dbg] outside approval-waiting loop"
    #while [ 1 ]
    while [ "$WAITFORAPPROVAL" == "TRUE" ]
    do 
        #echo "[dbg] inside approval-waiting loop"
        #--------------------------------------------------------------
        # check whether there are any jobs at all {{{
        # if not: 
        #       1. take it into account (maybe my job just got moved)
        #          (in this case, an approval must have already
        #           been signed !!!)
        #           NOJOBSINBUCKET="TRUE"
        #       2. proceed to checking the approval }}}   
        #--------------------------------------------------------------
        #--------------------------------------------------------------
        # check whether anything got approved (see WIP folder) {{{
        # if so:
        #          APPROVAL="TRUE"   
        #       1. do the job
        #       2. move the job to the next folder upon completion
        #       3. move documentation to the next folder after (2).
        #
        # if not so:
        #          APPROVAL="FALSE" }}}
        #--------------------------------------------------------------
        #--------------------------------------------------------------
        # test if NOJOBSINBUCKET="TRUE" && APPROVAL="FALSE" 
        #--------------------------------------------------------------
                
        # check whether the incoming jobs folder has any jobs
        # ('MaNagement Folder AVailable jobs')
        if [ `folderIsEmpty $MNF_AV` == "1" ] ; then
            NOJOBSINBUCKET="TRUE"
        else
            NOJOBSINBUCKET="FALSE"
        fi
        
        
        # jsig_fname is a file name used to indicate an approval to take a job
        # the worker itself will later move the file to WKF_DN folder
        jsig_fname=`ls -1 -c $WKF_IP | grep ".~$MY_WK_NAME" | head -1`
        
        if [ "$jsig_fname" != "" ] ; then
            APPROVAL="TRUE"
            echocl $text_color $MY_WK_NAME" got a job to do..." ;
            #------------#-#-#------------------------------------------------
            # WORK SECTION - START
            #- working --#-#-#--------------------------------------{{{
            echocl $text_color $MY_WK_NAME"--> working on [$jsig_fname]"      
            sleep $TIMELIMIT ; # working (WTF? FIXME disable this)
                                            
            # generate the job name to run
            JB_NAME=${jsig_fname%.~*} ; # cuts from the right, so * is in the right section
            
            # this part is what jobdispatcher&job does =================== {{{
            #temporarily disable:
            #source ./scripts/jobdispatcher.sh $JB_NAME # $JB_NAME
            source $MNF_IP/$JB_NAME
            disabledfunnnnn() ##{{{
            {
                echocl $text_color "$MY_WK_NAME copying production phase common template to worker's ops folder..."
                # copy template to ops folder:
                cp --remove-destination \
                $SDF_HOME/di/test_ext_vs_int.cfg \
                $SDF_HOME/ops/$MY_WK_NAME/test_ext_vs_int.cfg 
                echocl $text_color "$MY_WK_NAME: \$?=$?" 
                
                #set -x # ON
                
                echocl $text_color "$MY_WK_NAME preparing config for this job..."
                #sed  '/\#\[node_config_begin]/,/\#\[node_config_end]/p' "$MNF_IP/$JB_NAME" 
                #>> ./ops/$MY_WK_NAME/test_ext_vs_int.cfg
                
                echoc $text_color "pwd=" ;  pwd
                
                EXPORT_BEGIN="\x23\[node_config_begin]"
                EXPORT_END="\x23\[node_config_end]"
                sed -n -e '/'$EXPORT_BEGIN'/,/'$EXPORT_END'/p' "$MNF_IP/$JB_NAME" | tee -a ./ops/$MY_WK_NAME/test_ext_vs_int.cfg | sed $'s/^/\033[0;34m/'
                
                echocl $text_color "$MY_WK_NAME: \$?=$?" # print exit code from prev. command
            } ##}}}
            #set +x # OFF
            # ============================================================ }}}
            
            echocl $text_color "$MY_WK_NAME: AND WE ARE BACK IN THE STUDIO!"
            
            echocl $text_color $MY_WK_NAME"--> moving [$jsig_fname] to [$WKF_DN]"
            mv $WKF_IP/$jsig_fname $WKF_DN/$jsig_fname
            mv $MNF_IP/$JB_NAME $MNF_DN/$JB_NAME
            #------------#-#-#----------------------------------------}}}
            # WORK SECTION - END
            #------------#-#-#------------------------------------------------
        else
            APPROVAL="FALSE"
            echocl $text_color $MY_WK_NAME" is idle..." ;
        fi
            
        if [ "$APPROVAL" == "TRUE" ] ; then
            # quit the waiting loop & submit the next
            # 'available for work' status
            WAITFORAPPROVAL="FALSE" ;
        elif [ "$NOJOBSINBUCKET" == "FALSE" ] ; then
            WAITFORAPPROVAL="TRUE" ;
            #--- waits (inside this loop) for
            # the script-manager to process the proposal
            # # (request to get assigned some job) {{{
            sleep $PROPOSAL_PROCESSING_WAITING_TIME ;
            #}}}
        else           
            WAITFORAPPROVAL="FALSE" ; 
            TIMETOQUIT="TRUE" ;        
            echocl $text_color "$ACTOR_NAME: bye."   
        fi ;                                   
        # echo "NOJOBSINBUCKET $NOJOBSINBUCKET ; APPROVAL $APPROVAL ; TIMETOQUIT $TIMETOQUIT" ; 
    done #}}}  
done #}}}
                  
cleanup ;              
exit 0 ;
#}}}

# generate a list & feed it to dc_parser
#./bin/dc_parser $configfolder$configfile >./log.txt

