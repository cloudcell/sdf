#!/bin/bash
# ATTENTION: 
#     Function code and #{{{ #}}}
#     must be separated by at least one whitespace character 
#     Otherwise, the code gets screwed up.
#  Authorship:
#    Some functions have been borrowed from 
#    the book "Advanced Bash Scripting Guide 6.3"
#    & other sources, where a source is provided
#    otherwise, the author is cloudcell (c) 2014-2015
#    Let me know if I forgot to give a proper credit to anyone.

# 1st draft, not used yet
function checkArgs() #{{{
{
     # Checking for the correct # of arguments
    ARGS=2
    E_BADARGS=85
    E_NOFILE=86
    if [ $# -ne "$ARGS" ]
    # Correct number of arguments passed to script?
    then
        echo "Usage: basename $0 filename string_to_append"
        exit $E_BADARGS
    fi
    if [ ! -f "$1" ]       # Check if file exists.
    then
        echo "File \"$1\" does not exist."
        exit $E_NOFILE
    fi      

} #}}}

function printTimeStamp() #{{{
{
    line=$(date +%Y%m%d_%H%M_%S_%N)
    ldtmod=${line:0:20}
    # printf $ldtmod ;
    echo "[$ldtmod]" ;
    return ;
}
#}}}

function echocl() # $color $text # colored echo line #{{{ # 
{
        echo -e '\e['$1'm'$2 ;
} #}}}

function echoc() # $color $text # colored echo without line end #{{{ # 
{
        echo -en '\e['$1'm'$2 ; 
} #}}}

function folderIsEmpty() # $path #{{{ # 
{
        # Test whether command-line argument is present (non-empty).
        if [ -n "$1" ] ; then
                echo -ne "" # do absolutely nothing
        else  
                echo "assertion FAILED!"
                echo "[ERROR] folderIsEmpty(): argument not specified."
                exit 1 ;
        fi
        
        # echoes the count of empty dirs
        find $1 -maxdepth 0 -type d -empty | wc -l
        
        #src: http://stackoverflow.com/questions/20456666/bash-checking-if-folder-has-contents
        #src: http://stackoverflow.com/questions/22256623/search-server-for-empty-folders
} #}}} 

# to be deprecated , so it seems...
function checkJobsAvailable() # function check incoming jobs folder empty {{{ 
{
        # Test whether command-line argument is present (non-empty).
        if [ -n "$1" ] ; then
                echo -ne "" # do absolutely nothing
        else  
                echo "assertion FAILED!"
                echo "[ERROR] checkJobsAvailable(): argument not specified."
                exit 1 ;
        fi
# assign $1        
local ACTOR_NAME=$1

echocl $text_color "$ACTOR_NAME: checking job bucket..."
#incomingJobsFolderIsEmpty=`find $MNF_AV -maxdepth 0 -type d -empty | wc -l`

# echocl $text_color "Jobs Folder Empty [true/false]: $incomingJobsFolderIsEmpty"
if [ `folderIsEmpty $MNF_AV` == "1" ] ; then
        echocl $text_color "$ACTOR_NAME: job bucket is empty."
        echocl $text_color "$ACTOR_NAME: bye."
        cleanup ;
        exit 0 ;
else
        echocl $text_color "$ACTOR_NAME: job bucket has jobs."
fi ;
return ;
}
#}}}

function listFirstFile() #arg: $foldername  {{{ 
{
# Listing only regular files: (to be implemented in another function
# this is more efficient because the folder has already
# been checked for emptiness
# so this function can only be used safely,
# if and only if the folder is NOT empty and it is known
# with 100% certainty that the folder does not contain subfolders.
#
# http://unix.stackexchange.com/questions/48492/list-only-regular-files-but-not-directories-in-current-directory
#

        # Test whether command-line argument is present (non-empty).
        if [ -n "$1" ] ; then
                echo -ne "" # do absolutely nothing
        else
                echocl 31 "assertion FAILED!"
                echo "[ERROR] listFirstFile(): argument not specified."
                exit 0 ;
        fi
        
        #foldername=$1
        #ls $foldername -c -1 -U | head -1
        ls $1 -c -1 -U | head -1
        
        ## src of comment: IRC#gnu
        ## that's cpu efficient,
        ## the kernel is closing the pipe as soon as 
        ## head exits, ls receives SIGPIPE and exits too
        return ;
} #}}}

function dummyecho() #{{{
{
        echo "DUMMY"
        return ;
} #}}}

function listFolderContents() #{{{
{
        echo "Folder: [$1]" 
        ls -l -U $1
        echo ""
        return ;
} #}}}

# gets 1 oldest folder or plain file
function getOldestFile() #{{{
{
        # Test whether command-line argument is present (non-empty).
        if [ -n "$1" ] ; then
                echo -ne "" # do absolutely nothing
        else
                echocl 31 "Assertion FAILED!"
                echo "[ERROR]: Directory argument not specified."
                exit 0 ;
        fi
        
        # ls $1 -1 -r -t | head -1
        ls $1 -1 -r -t | head -1
        #echo $output
        
} #}}}

# appends a timestamped text line to an existing file
function tstampedAppendOrCrash() # $target_file $line_to_append #{{{
{
    # Checking for the correct # of arguments
    ARGS=2
    E_BADARGS=85
    E_NOFILE=86
    if [ $# -ne "$ARGS" ]
    # Correct number of arguments passed to script?
    then
        echo "Usage: basename $0 filename string_to_append"
        exit $E_BADARGS
    fi
    if [ ! -f "$1" ]       # Check if file exists.
    then
        echo "File \"$1\" does not exist."
        exit $E_NOFILE
    fi            
    
    # generating a timestamp
    # tstamp="["`exec ./utils/timestamp.sh`"]"
    tstamp=`printTimeStamp` ;
    # echo "stamp="$tstamp ;
    
    # printing a string to file
    # printf $tstamp$2 >> $1  # this does not print a 'LINE END' character
    echo "$tstamp $2" >> $1
    mv $1 $1.tmp
    mv $1.tmp $1
    # cat $1
    
    lineRead=`tail -1 $1`
    
    if [ "$tstamp $2" == "$lineRead" ] ;
    then 
        #echo everything is cool!
        echo -ne "" 
    else
        echocl 31 "ERROR: all fucked up!"
        exit 1 ;
    fi
    
    return ;  
    
    echocl 31 "Hardware glitch! Retrying..."
    echocl 31 "Are you using any FUSE (Filesystem in Userspace) on Windows?..."
    echocl 31 "Switch to Linux... I'm gona go now. Whoever I am..."
    
    return ;  
} #}}}


 
# reference {{{ 
        
function nevercallme()  
{                
#!/bin/bash
# wf2.sh: Crude word frequency analysis on a text file.
# Uses 'xargs' to decompose lines of text into single words.
# Compare this example to the "wf.sh" script later on.
# Check for input file on command-line.
ARGS=1
E_BADARGS=85
E_NOFILE=86
if [ $# -ne "$ARGS" ]
# Correct number of arguments passed to script?
then
  echo "Usage: `basename $0` filename"
  exit $E_BADARGS
fi
if [ ! -f "$1" ]       # Check if file exists.
then
  echo "File \"$1\" does not exist."
  exit $E_NOFILE
fi        
}        

#}}} reference end


