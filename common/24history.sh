#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Install locale files
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo 'Update /etc/profile for HISTORY SET...'
backup_etc_file /etc/profile

sed -r -i -e '/^[[:space:]]*export[[:space:]]+(HISTFILESIZE|HISTCONTROL|HISTSIZE|HISTTIMEFORMAT)[[:space:]]*=[[:space:]]*.*/d' /etc/profile && \
echo 'export HISTFILESIZE=1000000000
export HISTCONTROL=ignoredups
export HISTSIZE=1000000
export HISTTIMEFORMAT="[%Y-%m-%d %H:%M:%S]  "'>> /etc/profile

check_exit_restore /etc/profile
