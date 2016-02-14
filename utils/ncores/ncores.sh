# Author (script): cloudcell (c) 2015
# Author (java): see java source.
#
# make sure java is installed !
# TODO report error if java is not installed
#retval=$( /c/java/jre7/bin/java.exe -cp ./utils/ncores/ NumberOfCores )
#retval=`/c/java/jre7/bin/java.exe -cp ./utils/ncores/ NumberOfCores` # same as () above
retval=`java.exe -cp ./utils/ncores/ NumberOfCores` # same as () above
echo 'this is retval: ' $retval

# string to be deleted
searchstr="Total number of system cores(processors): "

# cut off the unneeded verbiage:
nOfCores=${retval/$searchstr/}

echo "nOfCores is equal to $nOfCores"

len=`expr length "$nOfCores"`
echo "length of $nOfCores = $len"

echo numberOfCores=$nOfCores ;

# -cp