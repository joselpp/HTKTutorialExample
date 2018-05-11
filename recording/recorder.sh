#!/bin/bash

# Input
f_prompts="/home/jluis/Devel/TestBox/HTK/dictionaries/TIMIT/TRAIN/PROMPTS_TRAIN_SHORT_UPPER.txt"
default_audio_name="out.wav"
time_pause=2            # [s]
wait_max=60             # Number of maximum time_pause steps to wait for recording

echo "Script to rename output files from audio recorder for the set of prompts provided by ${f_prompts}"
echo ""
echo "List of prompt to record:"
echo ""
while read -r line
do
    echo $line
    prompt=$(echo $line | cut -d ' ' -f1)
    file_out="S${prompt}.wav"

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

