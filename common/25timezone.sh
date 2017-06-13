#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Update timezone
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo "Change Timezone to Asia/Hong_Kong"
backup_etc_file /etc/timezone 

echo -n "Asia/Hong_Kong" > /etc/timezone 
check_exit_restore /etc/timezone

backup_etc_file /etc/localtime
ln -sfT /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
check_exit_restore /etc/localtime
