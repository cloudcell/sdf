# HEADER {{{
#
# Author: cloudcell (c) 2014,2015
# Project: Scripted Distributed Factory
# Script: Infrastructure folders 
#         (must NOT include job-specific folders, which would make
#          this factory/framework dependent upon data/jobs it processes)
#
#}}}

# time reporting format {{{
# ATTENTION: this setting is needed at runtime
# To use the Bash builtin time rather than /bin/time you can set this variable
# The number specifies the precision and can range from 0 to 3 (the default).
# The l (ell) gives a long format: " TIMEFORMAT='%3lR' "
TIMEFORMAT='%3R'
#}}}

# this file might be renamed to 'locations' or deployment_options:
# this will include the name of the binary to be run, etc, etc.

## the engine {{{
# the engine (to be renamed into the engine), because it's driving everything
# or, rather kernel, or core ("nann OS" -- sounds quite cool)
## TODO FIXME --> rename into core_binary (node...)... tbd!
app="./bin/dc_parser" 
#}}}

echo "-------------------------------------------"
if [[ "$OSTYPE" == "cygwin" ]]; then
    echo "OSTYPE is cygwin"
    echo "no paths are shall be modified or added."
elif [[ "$OSTYPE" == "msys" ]]; then
    echo "OSTYPE is msys"
    echo "no paths are shall be modified or added."
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo "OSTYPE is linux"
    echo "no paths are shall be modified or added."
else
    echo "OSTYPE is hell knows what"
    echo "if anything goes wrong blame these paths:"
    set -x # echo ON
    #export PATH="/y/mingw/msys/1.0/bin/:/y/mingw/bin/:/y/mingw/include/:$PATH"
    export PATH="/y/mingw/msys/1.0/bin/:/y/mingw/bin/:/y/mingw/include/:/y/java/jre7/bin/:$PATH"
    export PATH="/c/mingw/msys/1.0/bin/:/c/mingw/bin/:/c/mingw/include/:/c/java/jre7/bin/:$PATH"
    export PATH="/cygdrive/c/mingw/msys/1.0/bin/:/cygdrive/c/mingw/bin/:/cygdrive/c/mingw/include/:/cygdrive/c/java/jre7/bin/:$PATH"
    
    function notafunction() # just temp-ly removed
    {
        export PATH="/cygdrive/c/mingw/msys/1.0/bin/:/cygdrive/c/mingw/bin/:/cygdrive/c/mingw/include/:/cygdrive/c/java/jre7/bin/" #:$PATH"
    }
    set +x # echo OFF
fi
echo "-------------------------------------------"


# folder from which this app starts
## TODO: to be fixed !!!
export SDF_HOME="." # this folder
# export SDF_HOME=`pwd` # TODO XXX FIXME this is to be set by the sdf.sh (maybe...)
export SDF_SCRIPTS=$SDF_HOME/scripts
export SDF_OPS=$SDF_HOME/ops

ac_manager=$SDF_HOME/scripts/manager.sh
#ac_manager=$SDF_HOME/manager.sh




export BASEF=./mant/


## MNF == MaNagement Folders {{{
#-------------------------------------------------------------------------------

# AVailable jobs                          == "proposals requested"
export MNF_AV=$BASEF"aa_avail__mw"

# proposals to perform the jobs available == "proposals taken"
export WKF_AVPR=$BASEF"ab_avail_proposals__ww"

#-------------------------------------------------------------------------------

# jobs submitted to workers 'In Progress' == 'specific work requested'
export MNF_IP=$BASEF"ba_inprg__mw"


# jobs confirmed by workers as taken on   == 'specific work taken' 
export WKF_IP=$BASEF"bb_inprg_enggmnt__ww"

#-------------------------------------------------------------------------------

# jobs done (scans the $WF_DONE folder)   == 'completion status requested' 
export MNF_DN=$BASEF"ca_jdone__mw"         

# jobs done                               == 'completion status provided'
export WKF_DN=$BASEF"cb_jdone_status__ww"

#-------------------------------------------------------------------------------
##}}}

## data folders {{{
#-------------------------------------------------------------------------------

# raw data in
export SDF_DATA_IN=$BASEF"zz_pipe_data_in"

# raw data out
export SDF_DATA_OUT=$BASEF"zz_pipe_data_out"

#-------------------------------------------------------------------------------
##}}}


