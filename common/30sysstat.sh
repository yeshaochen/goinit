#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Setting sysstat
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo "Setting sysstat..."
backup_etc_file /etc/default/sysstat
sed -i -e 's/ENABLED="false"/ENABLED="true"/' /etc/default/sysstat 
check_exit_restore /etc/default/sysstat

backup_etc_file /etc/cron.d/sysstat
#sed -i -e 's#5-55/10#*#' /etc/cron.d/sysstat && /etc/init.d/sysstat restart
sed -i -e 's#5-55/10#*#' /etc/cron.d/sysstat
check_exit_restore /etc/cron.d/sysstat
