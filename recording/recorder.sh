#!/bin/bash
# Script to assist the recording process. It is expected to be launched along with an audio recorder
# program, such  as Audacity. It shows the user the list of sentences to be recorded and renames the
# files generated. 
# It uses the list of prompts provided by a file to print into screen the corresponding sentence to 
# record with the audio recorder. The recorded file corresponding to the current prompt must be 
# saved with the provisional name indicated by "default_audio_nam", which is then renamed by the 
# script to the proper name as indicated by the numeric tag of each prompt. The script provides a 
# waiting time of 2 minutes to record the audio, time limit that can be adjusted. If the waiting 
# time is exceeded, the program ends.
#
# Usage:
#       recorder.sh prompts_file
#
# Input:
#       prompts_file: File containing the set of prompts to record
#
# Output:
#       The script only renames the files generated with the audio recording program.
#

if [ $# -ne 1 ]
then
    echo "Number of arguments incorrect! One parameter file is required!"
    exit 1
fi

f_prompts=$1
default_audio_nam="out.wav"
preffix="S"
time_pause=2            # [s]
wait_max=60             # Number of maximum time_pause steps to wait for recording

if ! [ -f $f_prompts ]
then
    echo "Unable to locate prompts file: ${f_prompts}"
    exit 1
fi

echo "Script to rename output files from audio recorder for the set of prompts provided by ${f_prompts}"
echo ""
echo "List of prompts to record:"
echo ""
while read -r line
do
    echo $line
    prompt=$(echo $line | cut -d ' ' -f1)
    file_out="${preffix}${prompt}.wav"

    if ! [ -f "$file_out" ] # Recording audio
    then
        k=0
        echo "Recording..."
        while [[ !(-f $default_audio_name) ]] && [ $k -lt $wait_max ]
        do
            ((k++))
            sleep $time_pause
        done
        if [ $k -eq $wait_max ]
        then
            echo "Recording waiting period ($((wait_max*time_pause)) [s]) elapsed!"
            exit 1
        fi

        mv "$default_audio_name" "${file_out}"
        echo "${file_out} generated!"
        echo ""
    else                    # Audio already exists
        echo "${file_out} already exists!"
        echo ""
    fi
exit 1
done < "${f_prompts}"

