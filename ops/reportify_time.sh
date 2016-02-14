#!/bin/bash
# HEADER {{{
#
# Author: cloudcell (c) 2014, 2015
#
# Reportify_time of execution
#
# list all the files in the underlying folders
# create a single report for fitness
# jobname, data_header, data_value

# (portions of the code borrowed from StackOverflow)

##############################################################################
# http://linux.die.net/man/1/time
# Issue: why not do a time report in a regular csv format with fields
#        tabulated across (left to right)
# Resolution: time output format is not set in stone, so every field goes
#        on its line!
#
#  Gnu Version
#  Below a description of the GNU 1.7 version of time. Disregarding the name 
#    of the utility, GNU makes it output lots of useful information, not only 
#    about time used, but also on other resources like memory, I/O and IPC 
#    calls (where available). The output is formatted using a format string 
#    that can be specified using the -f option or 
#    the TIME environment variable.
#      
#  The default format string is:
#  %Uuser %Ssystem %Eelapsed %PCPU (%Xtext+%Ddata %Mmax)k
#  %Iinputs+%Ooutputs (%Fmajor+%Rminor)pagefaults %Wswaps
#      
#  When the -p option is given the (portable) output format
#  real %e
#  user %U
#  sys %S
#  is used.
##############################################################################      



#
#}}}

# SENTINEL: ARGUMENTS {{{
    # Checking for the correct # of arguments
    ARGS=1
    E_BADARGS=85
    E_NOFILE=86
    if [ $# -ne "$ARGS" ]
    # Correct number of arguments passed to script?
    then
        echo "Usage: $0 report_file"
        exit $E_BADARGS
    fi
#    if [ ! -f "$1" ]       # Check if file exists.
#    then
#        echo "File \"$1\" does not exist."
#        exit $E_NOFILE
#    fi       

# SENTINEL END: ARGUMENTS # }}}

# time reporting format {{{
# ATTENTION: this setting is needed at runtime
# To use the Bash builtin time rather than /bin/time you can set this variable
# The number specifies the precision and can range from 0 to 3 (the default).
# The l (ell) gives a long format: " TIMEFORMAT='%3lR' "
TIMEFORMAT='%3R'
#}}}

##############################################################################        
# Implementation (should be of no concern to the user):                       
#---------------------------------------------------------------{{{  

#{{{
function print_job_time_csv()
{
    OIFS="$IFS" 
    
    # ---------------------------------------------
    # List files recursively in Linux CLI with path relative to the current directory
    # http://stackoverflow.com/questions/245698/list-files-recursively-in-linux-cli-with-path-relative-to-the-current-directory
    # find . -name \*.time -print    

    #IFS=    # empty line works as well!
    tabchar=$'\t'
    IFS=$' '
    while read pathfname ; 
    do
        #    echo ${pathfname/%time/} ;
        fname=${pathfname/%.sh.time/} ;
        # reference: http://tldp.org/LDP/abs/html/parameter-substitution.html
        jobname=${fname##./*/} ;

        
        #IFS=$'\t '        
        while read linevalue ;
        do
        #{ read linevalue ; }
            if [[ "${#linevalue}" != "0" ]] ; then # chk length
                echo -n $jobname ;
                # replace a space with ',' here ${linevalue/ /,}
                linevalue_csv=${linevalue//$tabchar/,}
                echo ","$linevalue_csv ;
            fi
        done < $pathfname ;
        
        
    done <<< `find . -name \*.time -print`     
    # ---------------------------------------------
    
    # It's best to unset IFS after you've done your work, with 
    # unset IFS
    # , so that it returns to its default value. This will avoid any 
    # potential problems that could arise in the rest of your script.
    IFS="$OIFS"

    return ;
} #}}}


#-----------------------------------------------------------------------------
# --->>> Script entry point --->>>                                            
#-----------------------------------------------------------------------------

echo "Generating job time report..."
print_job_time_csv > $1


# exec 4>&-   # Now close it for the remainder of the script.
# set +x        

# create a single report for time
# jobname, data  

exit 0 ;

#}}}




##############################################################################

# set -x

# Bourne
# Redirect stderr to a pipe, keeping stdout unaffected.

# exec 4>&1  # Save current "value" of stdout.

# exec 4>&1
# ls -R | grep .fitness 2>&1 >&4    # Send stdout to FD 4.

#ls -R | grep .fitness 2>&1 >&3    # Send stdout to FD 3.
#ls -R | grep .fitness 1>&3

# echo ${{ `ls -R | grep .fitness` }/%.sh.fitness/}

# ---

# done <&4
