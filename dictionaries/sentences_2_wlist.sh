#!/bin/bash

tr -d '.?!,:;' | tr [:space:] '\n' | tr [:lower:] [:upper:] | sort | uniq > /tmp/wlist.tmp
N_words=$(wc -l < "/tmp/wlist.tmp")
((N_words--))

echo "N_words = $N_words"
tail -n${N_words} "/tmp/wlist.tmp" > "wlist"
