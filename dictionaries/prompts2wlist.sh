#!/bin/bash
# Script to generate a file containing a list of words contained in the prompts file provided.
# Usage:
#     prompts2wlist.sh prompts_file wlist_file
#
# Input:
#     prompts_file: File ontaining the set of numbered prompts
#
# Output:
#     wlist_file: File containing a list of unique words contained in the prompts file sorted
#                 alphabetically 
#

if [ $# -ne 2 ]
then
    echo "Number of arguments incorrect! Two parameter files are required!"
    exit 1
fi

file_prompts=$1
file_wlist=$2
file_tmp="wlist.tmp"

if ! [ -f $file_prompts ]
then
    echo "Unable to locate prompts file: ${file_prompts}"
    exit 1
fi

# Discarding the numeric tag value | Removing final characters '.?!,:;' | Converting spaces into new lines |
# Converting lower case letters to upper case | Sorting words | Removing repeated words  
cut -d' ' -f2- $file_prompts | tr -d '.?!,:;' | tr [:space:] '\n' | tr [:lower:] [:upper:] | sort | uniq > $file_tmp 
N_words=$(wc -l < $file_tmp)
((N_words--))

echo "N_words = $N_words"
tail -n${N_words} $file_tmp > $file_wlist

# Removing temporal file
rm $file_tmp 

 
