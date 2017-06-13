#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Update dns setting
# Environment: FUNCTION, ISP, MYIP

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo "Update resolv.conf..."
backup_etc_file /etc/resolv.conf

num=`date +%N`
tag=`expr ${num} % 2`
case "$ISP" in
    0)
        echo "Location: BGP"
        cp -f config/resolv.conf /etc/resolv.conf
        ;;
    1)
        echo "Location: ChinaNet"
        cp -f config/resolv.conf /etc/resolv.conf
        ;;
    2)
        echo "Location: CNC"
        cp -f config/resolv.conf /etc/resolv.conf
        ;;
    3)
        echo "Location: CERNET"
        #cernet has not any DNS cache server, so use cnc's DNS servers instead.
        cp -f config/resolv.conf /etc/resolv.conf
        ;;
    4)
        echo "Location: Unknown"
        echo "Keep the original configuration"
        ;;
    *)
        echo "Location: Unknown"
        exit 1
        ;;
esac

check_exit_restore /etc/resolv.conf
