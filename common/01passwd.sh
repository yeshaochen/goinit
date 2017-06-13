#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# CHANGE ROOT PASSWORD

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

if [ -z "$MYIP" ]
then
    echo "export MYIP first" >&2
    exit 2
fi

if [ -z "$setpasswd" ]
then
    echo "export setpasswd first" >&2
    exit 2
fi

RETCODE=0

case "$setpasswd" in
    0)
        exit 0
        ;;
    *)
        case "$MYIP" in
            192.168.*|10.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*)
                exit 0
                ;;
            *)
                echo "Change root password..."
                passwd root
                ;;
        esac
        ;;
esac
