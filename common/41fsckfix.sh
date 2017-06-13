#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# repair file systems without asking for permission 
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo "Update rcS..."
backup_etc_file /etc/default/rcS

sed -i '/FSCKFIX/d' /etc/default/rcS && echo 'FSCKFIX=yes' >> /etc/default/rcS
check_exit_restore /etc/default/rcS
