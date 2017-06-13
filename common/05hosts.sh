#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Update hostname and hosts setting
# Environment: FUNCTION

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

RETCODE=0

awkscript='{
    for (i=1; i<=NF; i++) {
        if ($i == "pointer") {split($(i+1),array,".");print array[1];quit}
    }
}'

check_installed_package bind9-host >/dev/null || aptitude -yy --without-recommends install bind9-host

case "$MYIP" in
    192.168.*|10.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*)
        hostname="onlinegame"
        ;;
    *)
        hostname=`host "$MYIP" | awk "$awkscript"`
        ;;
esac

if [ -n "$hostname" ]
then
    echo "Update /etc/hostname..."
    backup_etc_file /etc/hostname

    shorthostname=`echo "$hostname" | sed 's/chinanet/tel/'`
    echo "${shorthostname}" > /etc/hostname
    check_exit_restore /etc/hostname
else
    echo "ERROR: Can not resolv my hostname. Add DNS first!" >&2
    exit 1
fi

hosts=`cat config/hosts`
hosts=`eval "echo \"$hosts\""`
RETCODE=$?

if [ "$RETCODE" -eq 0 ] && [ -n "$hosts" ]
then
    echo "Update /etc/hosts..."
    backup_etc_file /etc/hosts

    echo "$hosts" > /etc/hosts
    check_exit_restore /etc/hosts
else
    echo "ERROR: Can not update my hosts." >&2
    exit 1
fi
