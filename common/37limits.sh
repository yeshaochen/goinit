#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Update /etc/security/limits.conf
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo "Changing limits.conf"
backup_etc_file /etc/security/limits.conf
cp -f config/limits.conf /etc/security/limits.conf
check_exit_restore /etc/security/limits.conf
