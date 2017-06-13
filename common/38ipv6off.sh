#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Disable ipv6
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo "Disable IPv6..."

version=`get_debian_version`

case "$version" in
    lenny)
        backup_etc_file /etc/modprobe.d/aliases
        sed -i -e '/alias[[:space:]]\+ipv6/d' \
               -e '/alias[[:space:]]\+net-pf-10/d' \
               -e '$a alias ipv6 off' \
               -e '$a alias net-pf-10 off' /etc/modprobe.d/aliases
        ;;
    squeeze|wheezy)
        echo 'net.ipv6.conf.all.disable_ipv6=1' > /etc/sysctl.d/disableipv6.conf 
        ;;
    *)
        backup_etc_file /etc/modprobe.d/aliases
        sed -i -e '/alias[[:space:]]\+ipv6/d' \
               -e '/alias[[:space:]]\+net-pf-10/d' \
               -e '$a alias ipv6 off' \
               -e '$a alias net-pf-10 off' /etc/modprobe.d/aliases
        ;;
esac

check_exit 'ERROR: disable ipv6 error'

if [ -f '/etc/exim4/update-exim4.conf.conf' ]
then
    echo 'Update exim4 config for disable ipv6...'
    backup_etc_file /etc/exim4/update-exim4.conf.conf
    sed -i "s/dc_local_interfaces.*/dc_local_interfaces='127.0.0.1'/" /etc/exim4/update-exim4.conf.conf
fi
