#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Update pam.d: only group root can su
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

        
RETCODE=0

# Update pam.d, so that only group root can su
echo "Update /etc/pam.d/su..."
if ! egrep -q '^[[:space:]]*auth[[:space:]]+required[[:space:]]+pam_wheel.so[[:space:]]*' /etc/pam.d/su
then
    if egrep -q '^#[[:space:]]*auth[[:space:]]+required[[:space:]]+pam_wheel.so[[:space:]]*$' /etc/pam.d/su
    then
        backup_etc_file /etc/pam.d/su
        sed -r -i -e 's/#[[:space:]]*auth[[:space:]]+required[[:space:]]+pam_wheel.so[[:space:]]*$/auth\t\trequired\tpam_wheel.so\troot_only/' /etc/pam.d/su
        check_exit_restore /etc/pam.d/su 'ERROR: can not modify /etc/pam.d/su'
    else
        echo "Error: Update /etc/pam.d/su fail!"
        exit 3
    fi
fi
exit $RETCODE
