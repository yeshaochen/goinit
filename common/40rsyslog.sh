#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Update rsyslog setting
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

backup_etc_file /etc/rsyslog.conf

echo "Update rsyslog setting..."

version=`get_debian_version`
case "$version" in
    lenny|squeeze)
        config='config/rsyslog-v4.conf'
        ;;
    wheezy)
        config='config/rsyslog-v5.conf'
        ;;
    *)
        config='config/rsyslog-v5.conf'
        ;;
esac

cp -f "$config" /etc/rsyslog.conf
check_exit_restore /etc/rsyslog.conf

/etc/init.d/rsyslog restart
