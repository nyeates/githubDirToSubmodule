#!/bin/sh
########################
# Makes a list of subdirectories and their full paths
# format will come out like:
# /path/to/dir/nameOfDir nameOfDir/
#
# Ex: ./directoryList.sh > output.txt
#
# Notes:
# Will cause issues with directories that have spaces in their names
# Do not use with dirs with spaces in their names
########################

#Variables
# Insert the directory that you want to create the output for
Directory="/usr/local/git/testSplit/"

directoryListing() 
( 
    # use the parameter passed to this function in $1, or if nothing passed in, use "." (current dir)
    cd "${1:-.}" || return
    
    # for each directory in the current directory
    for directory in */; do
        # print full path of dir AND directory name only (without trailing slash)
        printf "%s %s\n" "$PWD/$directory" "${directory%/}"
    done
)

directoryListing $Directory