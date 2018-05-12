#!/bin/bash

# Input
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
echo "List of prompt to record:"
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
        while ! [ -f $default_audio_name ] && [ $k -lt $wait_max ]
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

done < "${f_prompts}"

