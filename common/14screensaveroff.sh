#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Turn off screensaver
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo "Add Turning off screensaver in /etc/rc.local..."
backup_etc_file /etc/rc.local

echo '/usr/bin/setterm -blank 0' >> /etc/rc.local
check_exit_restore /etc/rc.local "ERROR: Add setterm wrong." 
