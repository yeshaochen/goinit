#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Install ntp
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo "Update ntp config..."
backup_etc_file /etc/ntp.conf
cp -f config/ntp.conf /etc/ntp.conf
/etc/init.d/ntp restart
update-rc.d -f ntp remove && update-rc.d ntp defaults 12
