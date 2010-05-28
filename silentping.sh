#!/bin/bash
if [[ "$#" != "3" ]]; then
    echo "Usage: silentping IP onsign offsign";
fi

# Get the status
STATUS="$(ping $1 -c 1 -w 2 | grep packets | sed "s/^.*tted, //;s/1/$2/;s/0/$3/;s/ re.*$//")"

# Create the directory
if [ ! -d /tmp/status ]; then
    mkdir /tmp/status;
fi

# Remove the old status
if [ "$STATUS" == "$2" ]; then
    if [ -f /tmp/status/$1.$3 ]; then
        rm /tmp/status/$1.$3;
    fi
else
    if [ -f /tmp/status/$1.$2 ]; then
        rm /tmp/status/$1.$2;
    fi
fi
# Create the new status file
if [ ! -f /tmp/status/$1.$STATUS ]; then
    touch /tmp/status/$1.$STATUS;
fi
