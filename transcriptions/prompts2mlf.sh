#!/bin/bash
# Script to generate Master Label File (MLF) for the given file containing a list of prompts
# with the following format for each of the lines:
#
# Tag_number PROMPT
#
# Usage:
#       prompts2mlf.sh prompts_file mlf_file
#
# Input:
#       mlf_file: File containing the Master Label File
# Output:
#       prompts_file: File containing the set of prompts 
#

preffix='S'

if [ $# -ne 2 ]
then
    echo "Number of arguments incorrect! Two parameter files are required!"
    exit 1
fi

file_prompts=$1
file_mlf=$2
file_tmp="/tmp/tmp.txt"
 
if ! [ -f $file_prompts ]
then
    echo "Unable to locate prompts file: ${file_prompts}"
    exit 1
fi

# "?", "!" and "." symbols removal
sed 's/[.?!]//g' $file_prompts | tr -s " " > $file_tmp

# Master Label File header
echo "#!MLF!#" > $file_mlf

# Conversion line by line
while IFS='' read -r line || [[ -n "$line" ]]
do
    echo "$line"
    # Tag creation
    echo "\"*/${preffix}$(echo ${line} | cut -d' ' -f1).lab\"" >> $file_mlf

    # Words separation
    echo ${line} | cut -d' ' -f2- | tr ' ' '\n' >> $file_mlf

    # Adding extra dot '.' to the end of each prompt
    echo "." >> $file_mlf

done < $file_tmp
echo ""
echo "MLF (${file_mlf}) generated!"





