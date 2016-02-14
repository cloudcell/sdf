#!/bin/bash
# Reference: borrowed code (see below)
# one approach to using pseudo-2D arrays in bash
# Incept 2013-05-17 09:20:17 CDT (May Fri) - erlkonig <at> talisman.org
# http://www.talisman.org/~erlkonig/software/pub/bash-arrays2d

# each 2d array has (rows * cols) fields, with cols as the stride to record:
declare -A _Arrays2d    # each is name -> cols

Array2dGet () {
    local array_name="$1" row="$2" col="$3"
    local cols=${_Arrays2d[$array_name]}
    local i ; (( i = cols * row + col ))
    eval 'echo ${'"$array_name"'['$i']}'
}
Array2dPut () {
    local array_name="$1" row="$2" col="$3" value="$4"
    local cols=${_Arrays2d[$array_name]}
    local i ; (( i = cols * row + col ))
    eval "$array_name"'['$i']='"'$value'"
}
Array2dCols () {    # may be zero for 0 or 1 rows
    local name="$1" cols="$2"
    local saved_cols=${_Arrays2d[$array2d]}
    if [ -n "$saved_cols" ] ; then
        if [ "$saved_cols" -gt 0 -a "$saved_cols" -ne "$cols" ] ; then
            echo Array2dCols: attempt to change array "$name'"s column number from $saved_cols to $cols, aborting >&2
            exit 1
        fi
    fi
    _Arrays2d["$name"]="$cols"
} 
Array2dColsClear () { Array2dCols "$1" 0 ; }

# determine the stride based on the fields found in the first line
Array2dFromDelimited ()
{
    line_array="$1" ; delim="$2" ; array2d="$3"
    Array2dColsClear "$array2d"
    local i=0 row=0
    for line in "${lines[@]}" ; do
        line="$line$delim"
        local col=0
        while [ -n "$line" ] ; do
            local value
            case "$line" in
                *${delim}*)
                     value="${line%%${delim}*}" ; line="${line#*${delim}}" ;;
                *)
                     value="${line}" ; line= ;;
            esac
            Array2dPut "$array2d" "$row" "$col" "$value"
            (( ++col ))
        done
        Array2dCols "$array2d" $col
        (( ++row ))
    done
    rows=${#lines[@]}
}

Array2dStdout () 
{
    local array_name="$1"
    local cols=${_Arrays2d[$array_name]}
    for    (( row=0 ; row < rows ; ++row )) ; do
        printf 'row %2d: ' $row
        for (( col=0 ; col < cols ; ++col )) ; do
            printf '%5s ' "$(Array2dGet "$array_name" $row $col)"
        done
        printf '\n'
    done
}

file_data=(
    $'\t\t'
    $'\t\tbC'
    $'\tcB\t'
    $'\tdB\tdC'
    $'eA\t\t'
    $'fA\t\tfC'
    $'gA\tgB\t'
    $'hA\thB\thC' )
delimiter=$'\t'
file_input () { printf '%s\n' "${file_data[@]}" ; }  # simulated input file

# the IFS=$'\n' has a side-effect of skipping blank lines; acceptable:
OIFS="$IFS" ; IFS=$'\n' ; oset="$-" ; set -f
lines=($(file_input))
set -"$oset" ; IFS="$OIFS"  # read "file"

Array2dFromDelimited lines "$delimiter" data
Array2dStdout data

#---eof
    
