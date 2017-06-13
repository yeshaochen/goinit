#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Install needed software and remove unwanted services

USELESS_SERVICE="ppp inetd lpd nfs-common portmap rpcbind"
RUN_LEVEL=2
echo "Remove services... "
for SERVICE in $USELESS_SERVICE
do
    echo "Removing service: $SERVICE"
    if [ -f /etc/init.d/$SERVICE ] && [ -f /etc/rc${RUN_LEVEL}.d/S*${SERVICE} ]
    then
        /etc/init.d/$SERVICE stop
        update-rc.d -f $SERVICE remove
    fi
done
