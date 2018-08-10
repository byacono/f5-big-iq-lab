#!/bin/bash
# Uncomment set command below for code debuging bash
# set -x

home="/home/f5/scripts"
dcdip="10.1.1.6"
#dcdip="10.192.75.181" # SJC
#dcdip="10.11.150.16" # SEA

already3=$(ps -ef | grep $0 | grep bash | grep -v grep | wc -l)
if [  $already3 -gt 1 ]; then
    echo "The script is already running $already3 time."
    exit 1
fi

cd $home/DoSPlayback
$home/eventSender.py -l $dcdip

cd $home/AFMPlayback
$home/eventSender.py -l $dcdip