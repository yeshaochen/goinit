#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Update sysctl
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo "Update sysctl..."
backup_etc_file /etc/sysctl.conf
cp -f config/sysctl.conf /etc/sysctl.conf
check_exit_restore /etc/sysctl.conf
